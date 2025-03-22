-- On entity death
---@param entity Entity
function PSTAVessel:onDeath(entity)
    ---@type EntityPlayer
    local player = PST:getPlayer()

    local isFrozen = entity:HasEntityFlags(EntityFlag.FLAG_ICE_FROZEN)

    if entity:IsActiveEnemy(true) and entity.Type ~= EntityType.ENTITY_BLOOD_PUPPY and not EntityRef(entity).IsFriendly and
    PST:getRoom():GetFrameCount() > 1 and not isFrozen then
        -- Mom death procs
        if entity.Type == EntityType.ENTITY_MOM then
            PSTAVessel:onCompletion("Mom")
            if Game():IsHardMode() then
                PSTAVessel:onCompletion("Momhard")
            end
        end

        -- Mod: % chance for enemies with at least 10 HP to drop a vanishing 1/2 soul heart on death, if you have less than 4 soul hearts
        local tmpMod = PST:getTreeSnapshotMod("tempSoulOnKill", 0)
        if tmpMod > 0 and entity.MaxHitPoints >= 10 and player:GetSoulHearts() < 8 and 100 * math.random() < tmpMod then
            local newSoulHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, entity.Position, RandomVector() * 3, nil)
            newSoulHeart:ToPickup().Timeout = 90
        end

        -- Squeeze Blood From Stone node (Baphomet demonic constellation)
        if PST:getTreeSnapshotMod("squeezeBloodStone", false) and entity:GetFreezeCountdown() > 0 and math.random() < 0.4 then
            local newHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, RandomVector() * 3, nil)
            newHeart:ToPickup().Timeout = 90
        end

        -- Mod: % chance for enemies to drop a vanishing 1/2 heart on death
        tmpMod = PST:getTreeSnapshotMod("tempSoulOnKill", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local newHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, RandomVector() * 3, nil)
            newHeart:ToPickup().Timeout = 60
        end

        -- Mod: +% speed for 3 seconds after killing an enemy. Stacks up to 5 times
        tmpMod = PST:getTreeSnapshotMod("tempSpeedOnKill", 0)
        if tmpMod > 0 then
            if PST:getTreeSnapshotMod("tempSpeedOnKillStacks", 0) < 5 then
                PST:addModifiers({ tempSpeedOnKillStacks = 1 }, true)
                PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
            end
            PSTAVessel.modCooldowns.tempSpeedOnKill = 90
        end

        -- Mod: % chance to gain up to 1/2 lost heart in the room when killing enemies
        tmpMod = PST:getTreeSnapshotMod("daggerHeartOnKill", 0)
        if tmpMod > 0 and not PST:getTreeSnapshotMod("daggerHeartOnKillProc", false) and 100 * math.random() < tmpMod then
            local proc = false
            if PST:getTreeSnapshotMod("daggerHeartOnKill_eternal", false) then
                player:AddEternalHearts(1)
                proc = true
            elseif PST:getTreeSnapshotMod("daggerHeartOnKill_black", false) then
                player:AddBlackHearts(1)
                proc = true
            elseif PST:getTreeSnapshotMod("daggerHeartOnKill_soul", false) then
                player:AddSoulHearts(1)
                proc = true
            elseif PST:getTreeSnapshotMod("daggerHeartOnKill_red", false) then
                player:AddHearts(1)
                proc = true
            end
            if proc then
                PST:addModifiers({ daggerHeartOnKillProc = true }, true)
                SFXManager():Play(SoundEffect.SOUND_PLOP, 1, 2, false, 1.6)
            end
        end

        -- Corpse Raiser node (Necromancer occult constellation)
        if PST:getTreeSnapshotMod("corpseRaiser", false) then
            local tmpChance = 10 + PST:getTreeSnapshotMod("corpseRaiserChance", 0)
            if 100 * math.random() < tmpChance then
                local tmpStage = Game():GetLevel():GetStage()
                local summonTier = 1
                if tmpStage > 5 and tmpStage < 10 then
                    summonTier = 2
                elseif tmpStage >= 10 then
                    summonTier = 3
                end
                local baseSummonData = PSTAVessel["corpseRaiserSummons" .. summonTier]
                if baseSummonData then
                    local newSummonData = baseSummonData[PST:getTreeSnapshotMod("corpseRaiserChoice" .. summonTier, 1)] or baseSummonData[1]
                    if newSummonData then
                        local existingSummons = #Isaac.FindByType(newSummonData[1], newSummonData[2])
                        if existingSummons < newSummonData[3] then
                            local newSummon = Isaac.Spawn(newSummonData[1], newSummonData[2], 0, entity.Position, Vector.Zero, player)
                            newSummon:AddCharmed(EntityRef(player), -1)
                            newSummon:GetData().PST_corpseRaised = true
                        end
                    end
                end
            end
        end

        -- Mod: +% damage until you kill a monster in the room
        tmpMod = PST:getTreeSnapshotMod("dmgUntilKill", 0)
        if tmpMod > 0 and not PST:getTreeSnapshotMod("dmgUntilKillProc", false) then
            PSTAVessel.modCooldowns.dmgUntilKill = 150
            PST:addModifiers({ dmgUntilKillProc = true }, true)
        end

        -- Mod: % chance for monsters with at least X HP to drop an additional penny on death
        tmpMod = PST:getTreeSnapshotMod("hpMobPenny", 0)
        if tmpMod > 0 and entity.MaxHitPoints >= 10 and 100 * math.random() < tmpMod then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, entity.Position, RandomVector() * 3, nil)
        end

        -- Mod: % chance for monsters to drop an additional vanishing penny on death
        tmpMod = PST:getTreeSnapshotMod("tempPennyOnKill", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local newPenny = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, entity.Position, RandomVector() * 3, nil)
            newPenny:ToPickup().Timeout = 60
        end

        -- Mod: +% speed and tears for 3 seconds after killing a poisoned enemy with at least 10 HP
        tmpMod = PST:getTreeSnapshotMod("poisonVialKillBuff", 0)
        if tmpMod > 0 then
            if PSTAVessel.modCooldowns.poisonVialKillBuff == 0 then
                PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
            end
            PSTAVessel.modCooldowns.poisonVialKillBuff = 90
        end

        -- Mod: % chance for enemies to leave a fire on death
        tmpMod = PST:getTreeSnapshotMod("mobDeathFire", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local newFire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0, entity.Position, Vector.Zero, player)
            newFire:ToEffect().Timeout = 150
            newFire.CollisionDamage = math.min(20, player.Damage / 2)
            newFire:GetData().PST_mobDeathFire = true
        end

        -- Mod: % chance for enemies to leave a poisonous cloud on death
        tmpMod = PST:getTreeSnapshotMod("poisonCloudOnDeath", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local newCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, player)
            newCloud:GetData().PST_poisonCloudOnDeath = true
            newCloud:ToEffect().Timeout = 150
        end

        -- NPC checks
        local tmpNPC = entity:ToNPC()
        if tmpNPC then
            -- Carrion Harvest node (Ritualist occult constellation)
            if not tmpNPC:IsBoss() and entity:GetData().PST_carrionCurse then
                if #PSTAVessel.carrionMobs < 3 then
                    table.insert(PSTAVessel.carrionMobs, {entity.Type, entity.Variant, entity.SubType, entity.MaxHitPoints})
                else
                    local randMobID = math.random(3)
                    if tmpNPC.MaxHitPoints > PSTAVessel.carrionMobs[randMobID][4] then
                        PSTAVessel[randMobID] = {entity.Type, entity.Variant, entity.SubType, entity.MaxHitPoints}
                    end
                end
            end

            -- Mod: % chance for bosses/champions to drop a pill on death, up to 3 per floor
            tmpMod = PST:getTreeSnapshotMod("bossChampPill", 0)
            if tmpMod > 0 and (tmpNPC:IsBoss() or tmpNPC:IsChampion()) and PST:getTreeSnapshotMod("bossChampPillProcs", 0) < 3 and
            100 * math.random() < tmpMod then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, entity.Position, RandomVector() * 3, nil)
                PST:addModifiers({ bossChampPillProcs = 1 }, true)
            end
        end
    end

    -- Destroyed frozen enemy
    if isFrozen then
        -- Mod: % chance to trigger The Hourglass' effect when destroying frozen enemies
        local tmpMod = PST:getTreeSnapshotMod("freezeDestroyHourglass", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_HOURGLASS, UseFlag.USE_NOANIM)
        end

        -- Frozen enemy ice shards node
        if PST:getTreeSnapshotMod("frozenMobIceShards", false) then
            local maxIceShards = 3 + PST:getTreeSnapshotMod("frozenMobIceShardQuant", 0)
            for i=1,maxIceShards do
                local tmpAng = ((math.pi * 2) / maxIceShards) * i
                local tmpVel = Vector(math.cos(tmpAng) * 5, math.sin(tmpAng) * 5)
                local newShard = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ICE, 0, entity.Position, tmpVel, player)
                newShard:ToTear():AddTearFlags(TearFlags.TEAR_SLOW | TearFlags.TEAR_ICE)
                newShard:ToTear().FallingAcceleration = -0.1
                newShard:ToTear().FallingSpeed = -0.1
                newShard:GetData().PST_frozenMobIceShard = true
                newShard:GetData().PST_iceShard = true
            end
        end

        -- Mod: destroying frozen enemies grants you a tears buff
        if PST:getTreeSnapshotMod("frozenMobTearBuff", false) then
            local enemReq = 15 - PST:getTreeSnapshotMod("frozenTearBuffExtra", 0)
            PST:addModifiers({ frozenMobTearBuffKills = 1 }, true)
            if PST:getTreeSnapshotMod("frozenMobTearBuffKills", 0) >= enemReq then
                if PSTAVessel.modCooldowns.frozenMobTearBuff == 0 then
                    PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
                end
                PSTAVessel.modCooldowns.frozenMobTearBuff = 600
                PST:addModifiers({ frozenMobTearBuffKills = { value = 0, set = true } }, true)
            end
        end
    end
end