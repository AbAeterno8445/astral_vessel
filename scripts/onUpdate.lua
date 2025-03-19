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

    -- Mod: petrification aura
    local tmpMod = PST:getTreeSnapshotMod("petriAura", 0)
    if tmpMod > 0 and (roomFrame % 30) == 0 then
        local nearbyEnems = Isaac.FindInRadius(player.Position, 100, EntityPartition.ENEMY)
        local affected = 0
        for _, tmpEnem in ipairs(nearbyEnems) do
            local tmpNPC = tmpEnem:ToNPC()
            if tmpNPC and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsActiveEnemy(false) and not EntityRef(tmpNPC).IsFriendly then
                if 100 * math.random() < tmpMod then
                    tmpNPC:AddFreeze(EntityRef(player), 45)
                    affected = affected + 1
                    if affected == 3 then break end
                end
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
end

---@param tear EntityTear
function PSTAVessel:tearUpdate(tear)
    if tear:GetData().swordstormOrbiter then
        local tearAng = math.atan(tear.Velocity.Y, tear.Velocity.X) + 4
        tear:AddVelocity(Vector(-0.25 * math.cos(tearAng), -0.25 * math.sin(tearAng)))
    end
end