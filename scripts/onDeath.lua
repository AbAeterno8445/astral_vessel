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

        -- Mod: % chance for enemies with at least 10 HP to drop a vanishing 1/2 soul heart on death, if you have less than 3 soul hearts
        local tmpMod = PST:getTreeSnapshotMod("tempSoulOnKill", 0)
        if tmpMod > 0 and entity.MaxHitPoints >= 10 and player:GetSoulHearts() < 6 and 100 * math.random() < tmpMod then
            local newSoulHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, entity.Position, RandomVector() * 3, nil)
            newSoulHeart:ToPickup().Timeout = 90
        end

        -- Squeeze Blood From Stone node (Baphomet demonic constellation)
        if PST:getTreeSnapshotMod("squeezeBloodStone", false) and entity:GetFreezeCountdown() > 0 and math.random() < 0.4 then
            local newHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, RandomVector() * 3, nil)
            newHeart:ToPickup().Timeout = 90
        end

        -- Mod: % chance for enemies to drop a vanishing 1/2 heart on death
        tmpMod = PST:getTreeSnapshotMod("tempHeartOnDeath", 0)
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
                            PST:getEntData(newSummon).PST_corpseRaised = true
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
            PST:getEntData(newFire).PST_mobDeathFire = true
        end

        -- Mod: % chance for enemies to leave a poisonous cloud on death
        tmpMod = PST:getTreeSnapshotMod("poisonCloudOnDeath", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local newCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, entity.Position, Vector.Zero, player)
            PST:getEntData(newCloud).PST_poisonCloudOnDeath = true
            newCloud:ToEffect().Timeout = 150
        end

        -- Lightless Maw node (Singularity cosmic constellation)
        if PST:getTreeSnapshotMod("lightlessMaw", false) then
            local blackHoles = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE)
            local nearBlackHole = false
            for _, tmpBlackHole in ipairs(blackHoles) do
                if entity.Position:Distance(tmpBlackHole.Position) <= 90 then
                    nearBlackHole = true
                    break
                end
            end
            if nearBlackHole then
                if entity:GetFearCountdown() > 0 or entity:GetBurnCountdown() > 0 or entity:HasEntityFlags(EntityFlag.FLAG_POISON) then
                    PSTAVessel.lightlessMawDmg = PSTAVessel.lightlessMawDmg + 2
                    PSTAVessel.modCooldowns.lightlessMaw = 450
                    PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
                end
                if entity:GetCharmedCountdown() > 0 or entity:GetBaitedCountdown() > 0 then
                    PSTAVessel.lightlessMawLuckTears = PSTAVessel.lightlessMawLuckTears + 2
                    PSTAVessel.modCooldowns.lightlessMaw = 450
                    PST:updateCacheDelayed(CacheFlag.CACHE_LUCK | CacheFlag.CACHE_FIREDELAY)
                end
                if entity:GetSlowingCountdown() > 0 or entity:GetSpeedMultiplier() < 1 or entity:GetShrinkCountdown() > 0 or entity:GetMagnetizedCountdown() > 0 or
                entity:HasEntityFlags(EntityFlag.FLAG_CONFUSION | EntityFlag.FLAG_BLEED_OUT | EntityFlag.FLAG_WEAKNESS) then
                    PSTAVessel.lightlessMawSpeedRange = PSTAVessel.lightlessMawSpeedRange + 2
                    PSTAVessel.modCooldowns.lightlessMaw = 450
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
                end
            end
        end

        -- Mod: % chance for enemies to leave a hovering Mucormycosis tear on death
        tmpMod = PST:getTreeSnapshotMod("mucorOnDeath", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SPORE, 0, entity.Position, Vector.Zero, player):ToTear()
            if newTear then
                newTear:AddTearFlags(TearFlags.TEAR_SPORE)
                newTear.FallingAcceleration = -0.1
                newTear.FallingSpeed = -0.1
                newTear.Height = -20
                Isaac.CreateTimer(function()
                    if newTear and newTear:Exists() then
                        newTear.FallingSpeed = 0
                        newTear.FallingAcceleration = 0.2
                    end
                end, 150, 1, false)
            end
        end

        -- Mod: % chance to spawn a clot when killing an enemy, up to 3 per room, up to 5 max present
        tmpMod = PST:getTreeSnapshotMod("vesselClotOnKill", 0)
        if tmpMod > 0 and PST:getTreeSnapshotMod("vesselClotOnKillProcs", 0) < 3 and 100 * math.random() < tmpMod then
            local totalClots = #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY)
            if totalClots < 5 then
                local clotType = PSTAVessel:getClotSubtypeFromHearts(player)
                local newClot = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, clotType, player.Position, RandomVector() * 3, nil)
                newClot:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
                PST:addModifiers({ vesselClotOnKillProcs = 1 }, true)
            end
        end

        -- Mod: % chance for monsters with at least 10 HP to drop a random poop pickup on death
        tmpMod = PST:getTreeSnapshotMod("poopPickupOnKill", 0)
        if tmpMod > 0 and entity.MaxHitPoints >= 10 and 100 * math.random() < tmpMod then
            local tmpPoopType = PoopPickupSubType.POOP_SMALL
            if math.random() < 0.3 then
                tmpPoopType = PoopPickupSubType.POOP_BIG
            end
            local newPoop = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_POOP, tmpPoopType, entity.Position, RandomVector() * 3, nil)
            newPoop:ToPickup().Timeout = 120
        end

        -- Mod: killing enemies has a % chance to grant you a leprosy orbital, up to 3 per room
        tmpMod = PST:getTreeSnapshotMod("leprosyOrbital", 0)
        if tmpMod > 0 and PST:getTreeSnapshotMod("leprosyOrbitalProcs", 0) < 3 and 100 * math.random() < tmpMod then
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LEPROSY, 0, player.Position, Vector.Zero, player)
            PST:addModifiers({ leprosyOrbitalProcs = 1 }, true)
        end

        -- Caustic Bite node (Tarantula mutagenic constellation)
        if PST:getTreeSnapshotMod("causticBite", false) and entity:HasEntityFlags(EntityFlag.FLAG_POISON) then
            local totalSpiders = #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER)
            if totalSpiders < 30 and 100 * math.random() < 0.33 then
                for _=1,2 do
                    player:ThrowBlueSpider(entity.Position, entity.Position + RandomVector() * 30)
                end
            end
        end

        -- Mod: % chance to spawn a friendly fly monster when killing enemies with at least X HP
        tmpMod = PST:getTreeSnapshotMod("flyFriendOnKill", 0)
        if tmpMod > 0 and entity.MaxHitPoints >= 25 - PST:getTreeSnapshotMod("flyFriendHP", 0) and PST:getTreeSnapshotMod("flyFriendProcs", 0) < 6 and
        100 * math.random() < tmpMod then
            local randFly = PSTAVessel.flyFriendsList[math.random(#PSTAVessel.flyFriendsList)]
            local newFly = Isaac.Spawn(randFly[1], randFly[2] or 0, randFly[3] or 0, entity.Position, Vector.Zero, player)
            newFly:AddCharmed(EntityRef(player), -1)
            newFly:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
            PST:addModifiers({ flyFriendProcs = 1 }, true)
        end

        -- Mod: temporary +% all stats when killing enemies inflicted with Hemoptysis' curse. Stacks up to 4x
        tmpMod = PST:getTreeSnapshotMod("mephitCurseKillBuff", 0)
        if tmpMod > 0 and entity:HasEntityFlags(EntityFlag.FLAG_BRIMSTONE_MARKED) then
            PSTAVessel.modCooldowns.mephitCurseKillBuff = 120
            if PST:getTreeSnapshotMod("mephitCurseKillBuffStacks", 0) < 4 then
                PST:addModifiers({ mephitCurseKillBuffStacks = 1 }, true)
                PST:updateCacheDelayed()
            end
        end

        -- NPC checks
        local tmpNPC = entity:ToNPC()
        if tmpNPC then
            local NPCisBoss = tmpNPC:IsBoss()
            local NPCisChampion = tmpNPC:IsChampion()

            -- Carrion Harvest node (Ritualist occult constellation)
            if not NPCisBoss and PST:getEntData(entity).PST_carrionCurse then
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
            if tmpMod > 0 and (NPCisBoss or NPCisChampion) and PST:getTreeSnapshotMod("bossChampPillProcs", 0) < 3 and
            100 * math.random() < tmpMod then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, 0, entity.Position, RandomVector() * 3, nil)
                PST:addModifiers({ bossChampPillProcs = 1 }, true)
            end

            -- Mod: % chance for champions to drop a cracked key on death, up to 3 per floor
            tmpMod = PST:getTreeSnapshotMod("champCrackedKey", 0)
            if tmpMod > 0 and NPCisChampion and PST:getTreeSnapshotMod("champCrackedKeyProcs", 0) < 3 and 100 * math.random() < tmpMod then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_CRACKED_KEY, entity.Position, RandomVector() * 3, nil)
                PST:addModifiers({ champCrackedKeyProcs = 1 }, true)
            end

            -- Mod: gain +% damage against final bosses when killing a boss enemy
            tmpMod = PST:getTreeSnapshotMod("bossKillFinalDmg", 0)
            if tmpMod > 0 and NPCisBoss and PST:getTreeSnapshotMod("bossKillFinalDmgProcs", 0) < 50 then
                PST:addModifiers({ finalBossDmg = tmpMod, bossKillFinalDmgProcs = 1 }, true)
            end

            -- Mod: % chance to spawn a spider when killing enemies within 6 seconds of entering a room
            tmpMod = PST:getTreeSnapshotMod("quickKillSpider", 0)
            if NPCisChampion then
                tmpMod = tmpMod * 2
            end
            if tmpMod > 0 and Game():GetRoom():GetFrameCount() <= 180 and 100 * math.random() < tmpMod then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)
                local maxSpiders = 1
                if NPCisChampion then maxSpiders = 2 end
                for _=1,maxSpiders do
                    player:ThrowBlueSpider(entity.Position, entity.Position + RandomVector() * 70)

                    PST:getPlayer():ThrowBlueSpider(PST:getPlayer().Position, PST:getPlayer().Position + RandomVector() * 70)
                end
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
                PST:getEntData(newShard).PST_frozenMobIceShard = true
                PST:getEntData(newShard).PST_iceShard = true
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