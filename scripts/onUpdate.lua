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
                    newCarrionMob:GetData().PST_carrionHarvestMob = true
                end
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
            end
        end
    end

    -- Heart update checks
    PSTAVessel:onUpdateHeartChecks(player)

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
                    newSword:GetData().vesselPalaSword = true
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
                    newSword:GetData().vesselPalaSword = true
                    newSword:GetData().swordstormOrbiter = true
                    newSword:ToTear():AddTearFlags(TearFlags.TEAR_SLOW)
                end
                SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 1, 17, false, 1.1)
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
                if PST:getTreeSnapshotMod("ritualPurpleFlame", false) then
                    tmpTimer = (4 - PST:getTreeSnapshotMod("ritualPurpleFlameDur", 0)) * 30
                end

                PSTAVessel.firingCooldowns[modName] = tmpTimer
            elseif CDNum > 0 then
                PSTAVessel.firingCooldowns[modName] = PSTAVessel.firingCooldowns[modName] - 1

                if PSTAVessel.firingCooldowns[modName] == 0 then
                    -- Mod: summon a purple flame every 4 seconds spent firing
                    if PST:getTreeSnapshotMod("ritualPurpleFlame", false) then
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector.Zero, nil)
                        SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS, 0.5, 2, false, 1.6)
                        local newFlame = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 1, player.Position, Vector.Zero, player)
                        newFlame:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_purple.png", true)
                        newFlame:GetData().PST_ritualPurpleFlame = true
                        newFlame:ToEffect().Timeout = 240
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
                local nearbyEnems = PSTAVessel:getNearbyEntities(player.Position, 200, EntityPartition.ENEMY)
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
                newEmber:GetData().PST_ember = true
                SFXManager():Play(SoundEffect.SOUND_CANDLE_LIGHT, 0.8, 2, false, 0.9 + 0.4 * math.random())

                PSTAVessel.fusilladeEmbers = PSTAVessel.fusilladeEmbers - 1
            end
        end
    end

    -- Mod: petrification aura
    local tmpMod = PST:getTreeSnapshotMod("petriAura", 0)
    if tmpMod > 0 and (roomFrame % 30) == 0 then
        local nearbyEnems = PSTAVessel:getNearbyEntities(player.Position, 100, EntityPartition.ENEMY)
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
            newFlame:GetData().PST_mobDeathFire = true
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
            newShard:GetData().PST_snowstormShard = true
            SFXManager():Play(SoundEffect.SOUND_FREEZE, 0.6, 2, false, 1.3 + 0.3 * math.random())
        end
        PSTAVessel.spiralAbilityAng = PSTAVessel.spiralAbilityAng + 0.2
    end

    if PSTAVessel.spiralAbilityAng >= math.pi * 2 then
        PSTAVessel.spiralAbilityAng = PSTAVessel.spiralAbilityAng - math.pi * 2
    end

    -- Mod: slowing aura
    if PST:getTreeSnapshotMod("slowingAura", false) and (roomFrame % 30) == 0 then
        local nearbyEnems = PSTAVessel:getNearbyEntities(player.Position, 100 + PST:getTreeSnapshotMod("slowingAuraRadius", 0) * 2, EntityPartition.ENEMY)
        for _, tmpEnem in ipairs(nearbyEnems) do
            if math.random() < 0.9 then
                tmpEnem:AddSlowing(EntityRef(player), 40, 0.8, Color(0.8, 0.8, 0.8, 1))
            end
        end
    end
end

---@param tear EntityTear
function PSTAVessel:tearUpdate(tear)
    -- Swordstorm sword tears
    if tear:GetData().swordstormOrbiter then
        local tearAng = math.atan(tear.Velocity.Y, tear.Velocity.X) + 4
        tear:AddVelocity(Vector(-0.25 * math.cos(tearAng), -0.25 * math.sin(tearAng)))
    end

    -- Frozen enemy ice shards
    if tear:GetData().PST_frozenMobIceShard then
        local tearAng = math.atan(tear.Velocity.Y, tear.Velocity.X) + 8
        tear:AddVelocity(Vector(-0.25 * math.cos(tearAng), -0.25 * math.sin(tearAng)))
    end
end