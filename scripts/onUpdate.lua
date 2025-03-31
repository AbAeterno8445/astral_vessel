include("scripts.onUpdateHearts")

local collectibleSprite = Sprite("gfx/005.100_collectible.anm2", true)
collectibleSprite:Play("ShopIdle")

function PSTAVessel:onUpdate()
    ---@type EntityPlayer
    local player = PST:getPlayer()
    --if player:GetPlayerType() ~= PSTAVessel.charType then return end

    ---@type Room
    local room = PST:getRoom()
    local roomFrame = room:GetFrameCount()

    -- First update after entering floor
    if PSTAVessel.floorFirstUpdate then
        PSTAVessel.floorFirstUpdate = false

        -- True Eternal node (Archangel divine constellation)
        if PST:getTreeSnapshotMod("trueEternal", false) then
            if player:GetEternalHearts() == 0 then
                player:AddEternalHearts(1)
            end
        end

        -- Mod: % chance to spawn a Crane Game at the beginning of the floor
        local tmpMod = PST:getTreeSnapshotMod("floorStartCrane", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos() - Vector(70, 70), 20)
            Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.CRANE_GAME, 0, tmpPos, Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
            SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
        end

        -- Mod: +% speed after entering secret room
        if PSTAVessel.modCooldowns.secretRoomSpeedBuff > 0 then
            PSTAVessel.modCooldowns.secretRoomSpeedBuff = 0
            PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
        end

        -- Mod: % chance to spawn a Confessional when entering a floor
        tmpMod = PST:getTreeSnapshotMod("floorConfessional", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local tmpPos = room:GetCenterPos() + Vector(120, -80)
            Isaac.Spawn(EntityType.ENTITY_SLOT, SlotVariant.CONFESSIONAL, 0, Isaac.GetFreeNearPosition(tmpPos, 20), Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
            SFXManager():Play(SoundEffect.SOUND_SLOTSPAWN)
        end

        -- On first floor
        if PST:isFirstOrigStage() then
            -- Spindown Angle node (Dark Gambler occult constellation)
            if PST:getTreeSnapshotMod("spindownAngle", false) then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos() + Vector(40, -40), 20)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_SPINDOWN_DICE, tmpPos, Vector.Zero, nil)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
            end
        -- After first floor
        else
            -- Dark Decay node (Archdemon demonic constellation)
            if PST:getTreeSnapshotMod("archdemonDarkDecay", false) and player:HasCollectible(CollectibleType.COLLECTIBLE_ABADDON) and
            PSTAVessel:GetBlackHeartCount(player) > 6 and math.random() < 0.66 then
                player:AddBlackHearts(-1)
                PST:createFloatTextFX("Dark Decay", Vector.Zero, Color(0.3, 0.3, 0.3, 1), 0.13, 120, true)
                SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
            end

            -- Mod: % chance to spawn a random pill when entering a floor past the first
            tmpMod = PST:getTreeSnapshotMod("floorRandomPill", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos() - Vector(60, 60), 20, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, tmpPos, Vector.Zero, nil)
            end

            -- Shuffling Form node (Abomination mutagenic tree)
            if PST:getTreeSnapshotMod("shufflingForm", false) then
                local mutantItems = {}
                for _, tmpItem in ipairs(PSTAVessel.constelItemPools[PSTAVConstellationType.MUTAGENIC]) do
                    local itemCount = player:GetCollectibleNum(tmpItem, true, true)
                    if itemCount > 0 then
                        table.insert(mutantItems, tmpItem)
                    end
                end
                for _, tmpItem in ipairs(mutantItems) do
                    local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem)
                    if itemCfg then
                        local targetPool = PSTAVessel.constelItems[PSTAVConstellationType.MUTAGENIC]["Q" .. itemCfg.Quality]
                        if targetPool then
                            local newItem = targetPool[math.random(#targetPool)]
                            local failsafe = 0
                            while (newItem.active or player:HasCollectible(newItem.item)) and failsafe < 200 do
                                newItem = targetPool[math.random(#targetPool)]
                                failsafe = failsafe + 1
                            end
                            if failsafe < 200 then
                                player:RemoveCollectible(tmpItem)
                                player:AddCollectible(newItem.item)
                            end
                        end
                    end
                end
                local extraProc = false
                if PST:getTreeSnapshotMod("shufflingFormExtra", 0) < 2 and math.random() < 0.15 then
                    local newItem = Game():GetItemPool():GetCollectible(PSTAVessel.constelItemPools[PSTAVConstellationType.MUTAGENIC])
                    local failsafe = 0
                    while player:HasCollectible(newItem) and failsafe < 200 do
                        newItem = Game():GetItemPool():GetCollectible(PSTAVessel.constelItemPools[PSTAVConstellationType.MUTAGENIC])
                        failsafe = failsafe + 1
                    end
                    if failsafe < 200 then
                        player:AddCollectible(newItem)
                        PST:addModifiers({ shufflingFormExtra = 1 }, true)
                        extraProc = true
                    end
                end
                -- FX
                local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
                poofFX.Color = Color(math.random(), math.random(), math.random())

                local grunts = {0, 1, 2, 4, 5}
                SFXManager():Play(SoundEffect["SOUND_MONSTER_GRUNT_" .. grunts[math.random(#grunts)]], 1, 2, false, 0.7 + 0.5 * math.random())
                SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER, 0.6)

                local tmpMsg = extraProc and "Shuffling Form (+1)" or "Shuffling Form"
                PST:createFloatTextFX(tmpMsg, Vector.Zero, Color(math.random(), math.random(), math.random()), 0.13, 100, true)
            end

            -- Mod: +% to the lowest stat for this floor
            tmpMod = PST:getTreeSnapshotMod("floorLowestBuff", 0)
            if tmpMod > 0 then
                -- Remove previous buff if applied
                local tmpBuff = PST:getTreeSnapshotMod("floorLowestBuffStat", nil)
                if tmpBuff then
                    local tmpBuffVal = PST:getTreeSnapshotMod("floorLowestBuffVal", 0)
                    PST:addModifiers({
                        [tmpBuff] = -tmpBuffVal,
                        floorLowestBuffVal = { value = 0, set = true }
                    }, true)
                end
                local statList = {
                    damagePerc = player.Damage - 3,
                    rangePerc = player.TearRange / 40 - 7,
                    tearsPerc = 30 / (player.MaxFireDelay + 1) - 3,
                    speedPerc = player.MoveSpeed - 1
                }
                local lowestStat
                local lowestVal = 1000
                for statName, statVal in pairs(statList) do
                    if statVal < lowestVal then
                        lowestStat = statName
                        lowestVal = statVal
                    end
                end
                PST:addModifiers({
                    floorLowestBuffStat = lowestStat,
                    floorLowestBuffVal = tmpMod,
                    [lowestStat] = tmpMod
                }, true)
            end
        end
    end

    -- First update after entering room
    if roomFrame == 1 then
        -- Carrion Harvest node (Ritualist occult constellation)
        if PST:getTreeSnapshotMod("carrionHarvest", false) and #PSTAVessel.carrionMobs > 0 and (room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_BOSSRUSH) then
            for i=1,3 do
                local tmpMobData = PSTAVessel.carrionMobs[i]
                if tmpMobData then
                    local newCarrionMob = Isaac.Spawn(tmpMobData[1], tmpMobData[2], tmpMobData[3], player.Position, Vector.Zero, player)
                    newCarrionMob.Color = Color(0.4, 0.2, 0.75, 1)
                    newCarrionMob:AddCharmed(EntityRef(player), -1)
                    PST:getEntData(newCarrionMob).PST_carrionHarvestMob = true
                end
            end
        end

        -- Mod: % chance to turn a random rock into a tinted rock, up to twice per floor
        local tmpMod = PST:getTreeSnapshotMod("tintedRockDiscover", 0)
        if tmpMod > 0 and room:IsFirstVisit() and PST:getTreeSnapshotMod("tintedRockDiscoverProcs", 0) < 2 and 100 * math.random() < tmpMod then
            for i=0,room:GetGridSize() do
                local tmpGridEnt = room:GetGridEntity(i)
                if tmpGridEnt and tmpGridEnt:GetType() == GridEntityType.GRID_ROCK then
                    tmpGridEnt:Destroy(true)
                    room:SpawnGridEntity(i, GridEntityType.GRID_ROCKT, 0)
                    PST:addModifiers({ tintedRockDiscoverProcs = 1 }, true)
                    break
                end
            end
        end

        -- Mod: % chance for rocks to be replaced with tinted rock in secret rooms, up to 3 times per floor
        tmpMod = PST:getTreeSnapshotMod("secretRoomTinted", 0)
        if tmpMod > 0 and room:IsFirstVisit() and room:GetType() == RoomType.ROOM_SECRET and PST:getTreeSnapshotMod("secretRoomTintedProcs", 0) < 3 then
            for i=0,room:GetGridSize() do
                if PST:getTreeSnapshotMod("secretRoomTintedProcs", 0) >= 3 then break end

                local tmpGridEnt = room:GetGridEntity(i)
                if tmpGridEnt and tmpGridEnt:GetType() == GridEntityType.GRID_ROCK and 100 * math.random() < tmpMod then
                    tmpGridEnt:Destroy(true)
                    room:SpawnGridEntity(i, GridEntityType.GRID_ROCKT, 0)
                    PST:addModifiers({ secretRoomTintedProcs = 1 }, true)
                end
            end
        end

        -- Mod: % chance to replace rocks with poop
        tmpMod = PST:getTreeSnapshotMod("poopRockReplace", 0)
        if tmpMod > 0 and room:IsFirstVisit() then
            for i=0,room:GetGridSize() do
                local tmpGridEnt = room:GetGridEntity(i)
                if tmpGridEnt and tmpGridEnt:GetType() == GridEntityType.GRID_ROCK and 100 * math.random() < tmpMod then
                    tmpGridEnt:Destroy(true)
                    local tmpPoopVariant = GridPoopVariant.NORMAL
                    if 100 * math.random() < tmpMod then
                        local specialTypes = {
                            GridPoopVariant.BLACK, GridPoopVariant.CHARMING, GridPoopVariant.CHUNKY, GridPoopVariant.CORN,
                            GridPoopVariant.GOLDEN, GridPoopVariant.HOLY, GridPoopVariant.RAINBOW, GridPoopVariant.RED,
                            GridPoopVariant.WHITE
                        }
                        tmpPoopVariant = specialTypes[math.random(#specialTypes)]
                    end
                    room:SpawnGridEntity(i, GridEntityType.GRID_POOP, tmpPoopVariant)
                end
            end
        end

        -- Room has monsters
        if room:GetAliveEnemiesCount() > 0 then
            local maxBlooms = 15
            -- Crimson Lifeblooms node (Flower mundane constellation)
            if PST:getTreeSnapshotMod("crimsonLifeblooms", false) then
                local bloomSpawns = math.min(maxBlooms, player:GetHearts())
                for _=1,bloomSpawns do
                    local tmpPos = room:GetRandomPosition(40)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.crimsonBloomID, 0, tmpPos, Vector.Zero, nil)
                end
            end
            -- Azure Lifeblooms node (Flower mundane constellation)
            if PST:getTreeSnapshotMod("azureLifeblooms", false) then
                local bloomSpawns = math.min(maxBlooms, player:GetSoulHearts() - PSTAVessel:GetBlackHeartCount(player))
                for _=1,bloomSpawns do
                    local tmpPos = room:GetRandomPosition(40)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.azureBloomID, 0, tmpPos, Vector.Zero, nil)
                end
            end
            -- Onyx Lifeblooms node (Flower mundane constellation)
            if PST:getTreeSnapshotMod("onyxLifeblooms", false) then
                local bloomSpawns = math.min(maxBlooms, PSTAVessel:GetBlackHeartCount(player))
                for _=1,bloomSpawns do
                    local tmpPos = room:GetRandomPosition(40)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.onyxBloomID, 0, tmpPos, Vector.Zero, nil)
                end
            end
            -- Calcified Lifeblooms node (Flower mundane constellation)
            if PST:getTreeSnapshotMod("calcifiedLifeblooms", false) then
                local bloomSpawns = math.min(5, player:GetBoneHearts())
                for _=1,bloomSpawns do
                    local tmpPos = room:GetRandomPosition(40)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.calcifiedBloomID, 0, tmpPos, Vector.Zero, nil)
                end
            end
            -- Eternal Lifeblooms node (Flower mundane constellation)
            if PST:getTreeSnapshotMod("eternalLifeblooms", false) and player:GetEternalHearts() then
                local tmpPos = room:GetRandomPosition(40)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.eternalBloomID, 0, tmpPos, Vector.Zero, nil)
            end
            -- Rotblooms node (Flower mundane constellation)
            if PST:getTreeSnapshotMod("rotblooms", false) then
                local bloomSpawns = math.min(maxBlooms, player:GetRottenHearts())
                for _=1,bloomSpawns do
                    local tmpPos = room:GetRandomPosition(40)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.rotBloomID, 0, tmpPos, Vector.Zero, nil)
                end
            end
            -- Gilded Lifeblooms node (Flower mundane constellation)
            if PST:getTreeSnapshotMod("gildedLifeblooms", false) then
                local bloomSpawns = math.min(maxBlooms, player:GetGoldenHearts())
                if player:GetHealthType() == HealthType.COIN then
                    bloomSpawns = math.min(maxBlooms, bloomSpawns + math.ceil(player:GetMaxHearts() / 2))
                end
                for _=1,bloomSpawns do
                    local tmpPos = room:GetRandomPosition(40)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.gildedBloomID, 0, tmpPos, Vector.Zero, nil)
                end
            end

            -- Suzerain Of Flies node (Dragonfly mutagenic constellation)
            if PST:getTreeSnapshotMod("suzerainOfFlies", false) and room:IsFirstVisit() and room:GetType() == RoomType.ROOM_BOSS then
                for _=1,7 do
                    local newFly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SWARM_FLY_ORBITAL, 0, player.Position, Vector.Zero, player)
                    PST:getEntData(newFly).PST_suzerainSwarmFly = true
                end
                PST:addModifiers({ suzerainSwarmProc = true }, true)
            end
        end
    end

    -- Effect cooldowns
    for modName, CDNum in pairs(PSTAVessel.modCooldowns) do
        if CDNum > 0 then
            PSTAVessel.modCooldowns[modName] = PSTAVessel.modCooldowns[modName] - 1
            -- Expired effects
            if PSTAVessel.modCooldowns[modName] == 0 then
                -- Mod: +% speed for 3 seconds after killing an enemy
                if modName == "tempSpeedOnKill" then
                    PST:addModifiers({ tempSpeedOnKillStacks = { value = 0, set = true } }, true)
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                end
                -- Mod: temporary incubus
                if modName == "roomClearIncubus" then
                    player:AddInnateCollectible(CollectibleType.COLLECTIBLE_INCUBUS, -1)
                end
                -- Mod: +% tears when summoning friendly undead
                if modName == "undeadSummonTears" then
                    PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                end
                -- Mod: +% damage until you kill a monster in the room
                if modName == "dmgUntilKill" then
                    PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
                end
                -- Mod: +% speed and tears when killing poisoned enemies
                if modName == "poisonVialKillBuff" then
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
                end
                -- Mod: destroying frozen enemies grants you a tears buff
                if modName == "frozenMobTearBuff" then
                    PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                end
                -- Mod: +% temporary speed when picking up any battery
                if modName == "batterySpeedBuff" then
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                end
                -- Lightless Maw node (Singularity cosmic constellation)
                if modName == "lightlessMaw" then
                    PST:updateCacheDelayed()
                end
                -- Mod: +% speed when first entering secret rooms
                if modName == "secretRoomSpeedBuff" then
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                end
                -- Lunar Scion node (Moon cosmic constellation)
                if modName == "lunarScion" then
                    PST:addModifiers({ lunarScionStacks = { value = 0, set = true } }, true)
                    PST:updateCacheDelayed()
                end
                -- Mod: +% temporary speed when entering a room per blue fly you have
                if modName == "vesselFliesSpeed" then
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                end
                -- Mutagenic Tear node (Abomination mutagenic constellation)
                if modName == "mutagenicTear" and room:GetAliveEnemiesCount() > 0 then
                    local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.GODS_FLESH_BLOOD, 0, player.Position, RandomVector() * 7, player)
                    PST:getEntData(newTear).PST_mutagenicTear = true
                    newTear:ToTear():AddTearFlags(TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_PIERCING | TearFlags.TEAR_ORBIT_ADVANCED)
                    newTear:ToTear().Color = Color(math.random(), math.random(), math.random(), 0.8)
                    newTear:ToTear().SpriteScale = Vector(1.4, 1.4)
                    newTear:ToTear().Height = -30
                    newTear:ToTear().FallingAcceleration = 0.01
                    newTear:ToTear().FallingSpeed = -10
                    newTear.CollisionDamage = math.min(80, player.Damage)
                end
                -- Mod: temporary +% all stats when killing enemies afflicted with Hemoptysis' curse
                if modName == "mephitCurseKillBuff" then
                    PST:addModifiers({ mephitCurseKillBuffStacks = { value = 0, set = true } }, true)
                    PST:updateCacheDelayed()
                end
            end
        end
    end

    -- Heart update checks
    PSTAVessel:onUpdateHeartChecks(player)

    -- Primary active slot charge update tracker
    if PSTAVessel.updateTrackers.primarySlotCharge ~= player:GetTotalActiveCharge(ActiveSlot.SLOT_PRIMARY) then
        -- Mod: +% damage per charge on your current active item
        if PST:getTreeSnapshotMod("activeChargeDmg", 0) > 0 then
            PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
        end

        PSTAVessel.updateTrackers.primarySlotCharge = player:GetTotalActiveCharge(ActiveSlot.SLOT_PRIMARY)
    end

    -- Player firing
    local plInput = player:GetShootingInput()
	local isShooting = plInput.X ~= 0 or plInput.Y ~= 0

    -- First instance of player firing in the room
    if not PSTAVessel.roomFirstFire then
        if isShooting then
            -- Swordstorm node (Paladin divine constellation)
            if PST:getTreeSnapshotMod("palaSwordstorm", false) then
                local outerRingMax = 12
                for i=1,outerRingMax do
                    local tmpAng = ((math.pi * 2) / outerRingMax) * i
                    local tmpVel = Vector(10 * math.cos(tmpAng), 10 * math.sin(tmpAng))
                    local newSword = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SWORD_BEAM, 0, player.Position, tmpVel, player)
                    newSword.CollisionDamage = math.min(40, player.Damage)
                    PST:getEntData(newSword).vesselPalaSword = true
                    newSword:ToTear():AddTearFlags(TearFlags.TEAR_SLOW)
                end
                SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 1, 2, false, 0.8)

                -- Sword spiral
                local innerRingMax = 7
                for i=1,innerRingMax do
                    local tmpAng = ((math.pi * 2) / innerRingMax) * i
                    local tmpVel = Vector(3 * math.cos(tmpAng), 3 * math.sin(tmpAng))
                    local newSword = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SWORD_BEAM, 0, player.Position, tmpVel, player)
                    newSword.CollisionDamage = math.min(40, player.Damage)
                    PST:getEntData(newSword).vesselPalaSword = true
                    PST:getEntData(newSword).swordstormOrbiter = true
                    newSword:ToTear():AddTearFlags(TearFlags.TEAR_SLOW)
                end
                SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 1, 17, false, 1.1)
            end

            -- Suzerain Of Flies node (Dragonfly mutagenic constellation)
            if PST:getTreeSnapshotMod("suzerainOfFlies", false) and room:GetAliveEnemiesCount() > 0 then
                local maxSwarmFlies = 2 + math.random(3) + player:GetRottenHearts()
                Isaac.CreateTimer(function()
                    local flyFamType = PSTAVessel.flyFamiliars[math.random(#PSTAVessel.flyFamiliars)]
                    local newFly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, flyFamType, 0, player.Position, RandomVector() * 5, player)

                    local flyTimer = 239 + math.random(120) + player:GetRottenHearts() * 60
                    Isaac.CreateTimer(function()
                        if newFly and newFly:Exists() then
                            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, newFly.Position, Vector.Zero, nil)
                            newFly:Remove()
                        end
                    end, flyTimer, 1, true)
                end, 5, maxSwarmFlies, false)
            end

            PSTAVessel.roomFirstFire = true
        end
    end

    -- Player firing-related cooldowns
    for modName, CDNum in pairs(PSTAVessel.firingCooldowns) do
        if isShooting then
            if CDNum == 0 then
                local tmpTimer = 0

                -- Mod: summon a purple flame every 4 seconds spent firing
                if modName == "ritualPurpleFlame" and PST:getTreeSnapshotMod("ritualPurpleFlame", false) then
                    tmpTimer = (4 - PST:getTreeSnapshotMod("ritualPurpleFlameDur", 0)) * 30
                -- Mod: summon orbiting, piercing fearing tears
                elseif modName == "singularityFearTears" and PST:getTreeSnapshotMod("singularityFearTears", 0) > 0 then
                    tmpTimer = 30
                    if (Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_DARKNESS) then
                        tmpTimer = 15
                    end
                end

                PSTAVessel.firingCooldowns[modName] = tmpTimer
            elseif CDNum > 0 then
                PSTAVessel.firingCooldowns[modName] = PSTAVessel.firingCooldowns[modName] - 1

                if PSTAVessel.firingCooldowns[modName] == 0 then
                    -- Mod: summon a purple flame every 4 seconds spent firing
                    if modName == "ritualPurpleFlame" and PST:getTreeSnapshotMod("ritualPurpleFlame", false) then
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
                        SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.5, 2, false, 1.6)
                        local newFlame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 1, player.Position, Vector.Zero, player)
                        newFlame:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_purple.png", true)
                        PST:getEntData(newFlame).PST_ritualPurpleFlame = true
                        newFlame:ToEffect().Timeout = 240
                    -- Mod: summon orbiting, piercing fearing tears
                    elseif modName == "singularityFearTears" and 100 * math.random() < PST:getTreeSnapshotMod("singularityFearTears", 0) then
                        local initAng = (2 * math.pi * math.random())
                        for i=1,2 do
                            local tmpAng = initAng + math.pi * (i - 1)
                            local tmpVel = Vector(math.cos(tmpAng) * 6, math.sin(tmpAng) * 6)
                            local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.DARK_MATTER, 0, player.Position, tmpVel, player)
                            newTear:ToTear().Scale = 2
                            newTear:ToTear():AddTearFlags(TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL | TearFlags.TEAR_FEAR)
                            newTear:ToTear().Height = -60
                            newTear:ToTear().FallingSpeed = 0.01
                            newTear:ToTear().FallingAcceleration = -0.04
                            newTear.CollisionDamage = math.min(40, player.Damage)
                            Isaac.CreateTimer(function()
                                newTear:ToTear():AddTearFlags(TearFlags.TEAR_ORBIT_ADVANCED)
                            end, 5, 1, false)
                        end
                    end
                end
            end
        end
    end

    -- Mod: Meteor ember fusillade
    if PSTAVessel.modCooldowns.meteorEmber > 0 or PSTAVessel.fusilladeEmbers > 0 then
        if isShooting then
            PSTAVessel.modCooldowns.meteorEmber = PSTAVessel.fusilladeDelay
        elseif PSTAVessel.modCooldowns.meteorEmber <= 30 then
            -- Fire embers in a slightly delayed sequence
            if PSTAVessel.modCooldowns.meteorEmber % 3 == 0 and PSTAVessel.fusilladeEmbers > 0 then
                local nearbyEnems = PSTAVessel:getNearbyNPCs(player.Position, 200, EntityPartition.ENEMY)
                local closestEnem = nil
                local closestDist = 1000
                for _, tmpEnem in ipairs(nearbyEnems) do
                    local dist = player.Position:Distance(tmpEnem.Position)
                    if dist < closestDist then
                        closestEnem = tmpEnem
                        closestDist = dist
                    end
                end

                local emberID = PSTAVessel.fusilladeEmbers
                local emberAng = (math.pi * 0.2) * emberID + PSTAVessel.fusilladeEmberAng
                local emberPos = player.Position + Vector(math.cos(emberAng) * PSTAVessel.fusilladeEmberDist, math.sin(emberAng) * PSTAVessel.fusilladeEmberDist)
                local tmpVel = (emberPos - player.Position):Normalized() * 15
                if closestEnem then
                    tmpVel = (closestEnem.Position - emberPos):Normalized() * 15
                end
                local newEmber = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE_MIND, 0, emberPos, tmpVel, player)
                newEmber:ToTear().Scale = 0.8
                newEmber.CollisionDamage = 2 + math.min(18, math.ceil(player.Damage * 0.75))
                PST:getEntData(newEmber).PST_ember = true
                SFXManager():Play(SoundEffect.SOUND_CANDLE_LIGHT, 0.8, 2, false, 0.9 + 0.4 * math.random())

                PSTAVessel.fusilladeEmbers = PSTAVessel.fusilladeEmbers - 1
            end
        end
    end

    -- Mod: petrification aura
    local tmpMod = PST:getTreeSnapshotMod("petriAura", 0)
    if tmpMod > 0 and (roomFrame % 30) == 0 then
        local nearbyEnems = PSTAVessel:getNearbyNPCs(player.Position, 100, EntityPartition.ENEMY)
        local affected = 0
        for _, tmpEnem in ipairs(nearbyEnems) do
            if 100 * math.random() < tmpMod then
                tmpEnem:AddFreeze(EntityRef(player), 45)
                affected = affected + 1
                if affected == 3 then break end
            end
        end
    end

    -- Spindown Angle node (Dark Gambler occult constellation)
    if PST:getTreeSnapshotMod("spindownAngle", false) and PST:getTreeSnapshotMod("spindownAngleProc", false) and room:IsFirstVisit() and room:GetFrameCount() == 60 then
        player:UseActiveItem(CollectibleType.COLLECTIBLE_SPINDOWN_DICE, UseFlag.USE_NOANIM)
        SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL, 0.6)
        local spinDownGFX = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SPINDOWN_DICE).GfxFileName
        collectibleSprite:ReplaceSpritesheet(1, spinDownGFX, true)
        PST:createFloatIconFX(collectibleSprite, Vector.Zero, 0.2, 120, true)
    end

    -- Mod: +% damage until you kill a monster in the room
    if PST:getTreeSnapshotMod("dmgUntilKillProc", false) and PSTAVessel.modCooldowns.dmgUntilKill > 0 and roomFrame % 15 == 0 then
        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
    end

    -- Raging Energy node (Volcano elemental constellation)
    if PSTAVessel.modCooldowns.ragingEnergy > 0 and PSTAVessel.modCooldowns.ragingEnergy % 3 == 0 then
        for i=1,4 do
            local tmpAng = (math.pi * 0.5) * i + PSTAVessel.spiralAbilityAng
            local tmpVel = Vector(math.cos(tmpAng) * 10, math.sin(tmpAng) * 10)
            local newFlame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, player.Position, tmpVel, player)
            newFlame.CollisionDamage = math.max(6, math.min(20, player.Damage))
            PST:getEntData(newFlame).PST_mobDeathFire = true
            newFlame:ToEffect().Timeout = 30
            SFXManager():Play(SoundEffect.SOUND_BEAST_FIRE_RING, 0.6, 2, false, 0.9 + 0.3 * math.random())
        end
        PSTAVessel.spiralAbilityAng = PSTAVessel.spiralAbilityAng + 0.2
    end

    -- Snowstorm node (Blizzard elemental constellation)
    if PSTAVessel.modCooldowns.blizzardSnowstorm > 0 and PSTAVessel.modCooldowns.blizzardSnowstorm % 3 == 0 then
        for i=1,6 do
            local tmpAng = (math.pi * 1/3) * i + PSTAVessel.spiralAbilityAng
            local tmpVel = Vector(math.cos(tmpAng) * 10, math.sin(tmpAng) * 10)
            local newShard = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ICE, 0, player.Position, tmpVel, player)
            newShard:ToTear().Scale = 2 - (1 - PSTAVessel.modCooldowns.blizzardSnowstorm / 60)
            newShard:ToTear():AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_FREEZE)
            newShard.CollisionDamage = math.max(6, math.min(20, player.Damage))
            PST:getEntData(newShard).PST_snowstormShard = true
            SFXManager():Play(SoundEffect.SOUND_FREEZE, 0.6, 2, false, 1.3 + 0.3 * math.random())
        end
        PSTAVessel.spiralAbilityAng = PSTAVessel.spiralAbilityAng + 0.2
    end

    if PSTAVessel.spiralAbilityAng >= math.pi * 2 then
        PSTAVessel.spiralAbilityAng = PSTAVessel.spiralAbilityAng - math.pi * 2
    end

    -- Mod: slowing aura
    if PST:getTreeSnapshotMod("slowingAura", false) and (roomFrame % 30) == 0 then
        local nearbyEnems = PSTAVessel:getNearbyNPCs(player.Position, 100 + PST:getTreeSnapshotMod("slowingAuraRadius", 0) * 2, EntityPartition.ENEMY)
        for _, tmpEnem in ipairs(nearbyEnems) do
            if math.random() < 0.9 then
                tmpEnem:AddSlowing(EntityRef(player), 40, 0.8, Color(0.8, 0.8, 0.8, 1))
            end
        end
    end

    -- Mod: % chance to regain charges when using void
    if PSTAVessel.chargeGainProc > 0 then
        local tmpSlot = player:GetActiveItemSlot(CollectibleType.COLLECTIBLE_VOID)
        if tmpSlot ~= -1 then
            player:AddActiveCharge(PSTAVessel.chargeGainProc, tmpSlot, true, false, false)
        end
        PSTAVessel.chargeGainProc = 0
    end

    -- Lunar Scion node (Moon cosmic constellation)
    if PST:getTreeSnapshotMod("lunarScion", false) and roomFrame % 30 == 0 and room:GetAliveEnemiesCount() > 0 then
        local maxProcs = 2 + PST:getTreeSnapshotMod("lunarScionExtras", 0)
        if room:GetType() == RoomType.ROOM_BOSS or room:GetType() == RoomType.ROOM_BOSSRUSH then
            maxProcs = maxProcs + 1
        end
        if PST:getTreeSnapshotMod("lunarScionProcs", 0) < maxProcs then
            local tmpChance = 5 + PST:getTreeSnapshotMod("lunarScionExtras", 0) * 3
            if 100 * math.random() < tmpChance then
                local tmpPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(20), 20)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.lunarScionMoonlightID, 0, tmpPos, Vector.Zero, nil)
            end
        end
    end

    -- Solar Scion node (Sun cosmic constellation)
    if PST:getTreeSnapshotMod("solarScion", false) then
        if PST:getTreeSnapshotMod("solarScionProcs", 0) < 2 and roomFrame % 30 == 0 and room:GetAliveEnemiesCount() > 0 then
            local tmpChance = 7
            if PST:getTreeSnapshotMod("solarScionBossDead", false) then
                tmpChance = 14
            end
            if 100 * math.random() < tmpChance then
                local tmpPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(20), 20)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.solarScionFireRingID, 0, tmpPos, Vector.Zero, nil)
                PST:addModifiers({ solarScionProcs = 1 }, true)
            end
        end
        -- Player near fire ring
        if roomFrame % 10 == 0 then
            local tmpFireRings = Isaac.FindByType(EntityType.ENTITY_EFFECT, PSTAVessel.solarScionFireRingID)
            local withinRing = false
            for _, tmpRing in ipairs(tmpFireRings) do
                if tmpRing.Position:Distance(player.Position) <= 70 then
                    withinRing = true
                    break
                end
            end
            if withinRing and not PSTAVessel.inSolarFireRing then
                PSTAVessel.inSolarFireRing = true
                PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
            elseif not withinRing and PSTAVessel.inSolarFireRing then
                PSTAVessel.inSolarFireRing = false
                PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
            end
        end
    end

    -- Mutagenic Tear node (Abomination mutagenic constellation)
    if PST:getTreeSnapshotMod("mutagenicTear", false) and room:GetAliveEnemiesCount() > 0 and PSTAVessel.modCooldowns.mutagenicTear == 0 then
        PSTAVessel.modCooldowns.mutagenicTear = 150 - math.floor(PST:getTreeSnapshotMod("mutagenicTearDelay", 0) * 30)
    end

    -- Level 100 unlock
    if roomFrame % 30 == 0 then
        local charData = PST.modData.charData["Astral Vessel"]
        if not Isaac.GetPersistentGameData():Unlocked(Isaac.GetAchievementIdByName("AVesselIngrained")) and charData and charData.level >= 100 then
            PSTAVessel:onCompletion("lvl100", true)
        end
    end
end

---@param tear EntityTear
function PSTAVessel:tearUpdate(tear)
    local tearData = PST:getEntData(tear)
    -- Swordstorm sword tears
    if tearData.swordstormOrbiter then
        local tearAng = math.atan(tear.Velocity.Y, tear.Velocity.X) + 4
        tear:AddVelocity(Vector(-0.25 * math.cos(tearAng), -0.25 * math.sin(tearAng)))
    end

    -- Frozen enemy ice shards
    if tearData.PST_frozenMobIceShard then
        local tearAng = math.atan(tear.Velocity.Y, tear.Velocity.X) + 8
        tear:AddVelocity(Vector(-0.25 * math.cos(tearAng), -0.25 * math.sin(tearAng)))
    end
end