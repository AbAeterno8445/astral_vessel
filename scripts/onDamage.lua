---@param target Entity
---@param damage number
---@param flag integer
---@param source EntityRef
function PSTAVessel:onDamage(target, damage, flag, source)
    local tmpMod
    -- Player got hit
    if target.Type == EntityType.ENTITY_PLAYER then
        local player = target:ToPlayer()
        if player then
            -- 'Damage window' (e.g. for hurt SFX switching)
            if player:GetPlayerType() == PSTAVessel.vesselType then
                PSTAVessel.modCooldowns.playerDmgWindow = 10
            end

            -- True Eternal node (Archangel divine constellation)
            if PST:getTreeSnapshotMod("trueEternal", false) and player:GetEternalHearts() > 0 then
                PSTAVessel.trueEternalHitProc = true
            end

            -- Source mob checks
            if source and source.Entity then
                local sourceMob = source.Entity:ToNPC()
                if not sourceMob and source.Entity.Parent then
                    sourceMob = source.Entity.Parent:ToNPC()
                end
                if not sourceMob and source.Entity.SpawnerEntity then
                    sourceMob = source.Entity.SpawnerEntity:ToNPC()
                end
                if sourceMob then
                    -- Mod: hexer curse buffs, up to % chance to block damage. Halve the chance when blocking
                    tmpMod = PST:getTreeSnapshotMod("hexerCurseBuff", 0) / (2 ^ PST:getTreeSnapshotMod("hexerCurseBuffBlocks", 0))
                    if tmpMod > 0 and (Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_THE_UNKNOWN) > 0 and 100 * math.random() < tmpMod * 2 then
                        PST:addModifiers({ hexerCurseBuffBlocks = 1 }, true)
                        SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
                        return { Damage = 0 }
                    end

                    -- Mod: % chance to spawn a Lil Abaddon for the room when hit
                    tmpMod = PST:getTreeSnapshotMod("lilAbaddonOnHit", 0)
                    if tmpMod > 0 and PST:getTreeSnapshotMod("lilAbaddonOnHitProcs", 0) < 2 and 100 * math.random() < tmpMod then
                        player:AddCollectible(CollectibleType.COLLECTIBLE_LIL_ABADDON)
                        PST:addModifiers({ lilAbaddonOnHitProcs = 1 }, true)
                    end

                    -- Mod: % chance to block attacks from burning enemies
                    tmpMod = PST:getTreeSnapshotMod("burningMobBlock", 0)
                    if tmpMod > 0 and sourceMob:GetBurnCountdown() > 0 and 100 * math.random() < tmpMod then
                        SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
                        SFXManager():Play(SoundEffect.SOUND_FIREDEATH_HISS)
                        return { Damage = 0 }
                    end

                    -- Mod: % chance to trigger Lemon Mishap when hit
                    tmpMod = PST:getTreeSnapshotMod("lemonMishapHit", 0)
                    if tmpMod > 0 and 100 * math.random() < tmpMod then
                        if player:GetHearts() > 2 then
                            player:UseActiveItem(CollectibleType.COLLECTIBLE_LEMON_MISHAP, UseFlag.USE_NOANIM)
                        else
                            player:UseActiveItem(CollectibleType.COLLECTIBLE_FREE_LEMONADE, UseFlag.USE_NOANIM)
                        end
                    end
                end
            end

            -- Killing hits
            local plHealth = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetRottenHearts() / 2
            if damage >= plHealth then
                -- Life Insured node (God Of Fortune mercantile constellation)
                if PST:getTreeSnapshotMod("lifeInsured", false) and player:GetNumCoins() >= 20 and not PST:getTreeSnapshotMod("lifeInsuredProc", false) and
                PST:getTreeSnapshotMod("lifeInsuredProcsRun", 0) < 5 then
                    player:AddCoins(-20)
                    PST:addModifiers({ lifeInsuredProc = true, lifeInsuredProcsRun = 1 }, true)
                    SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE, 1, 2, false, 1.2)
                    PST:createFloatTextFX("Life Insured", Vector.Zero, Color(1, 1, 0.3, 1), 0.13, 120, true)
                    return { Damage = 0 }
                end
            end
        end
    elseif target and target.Type ~= EntityType.ENTITY_GIDEON then
        -- Blacklisted sources
        local isBlacklistedSrc = (source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.BLACK_HOLE)
        if isBlacklistedSrc then return nil end

        local tmpNPC = target:ToNPC()
        local srcPlayer = PST:getPlayer()

        local dmgMult = 1
        local dmgExtra = 0

        -- Check if a familiar got hit
        if source.Type == EntityType.ENTITY_FAMILIAR then
            local tmpFamiliar = target:ToFamiliar()
            if tmpFamiliar then
                -- Wisp got hit
                if tmpFamiliar.Variant == FamiliarVariant.WISP then
                    -- Mod: Wisps get % damage reduction
                    tmpMod = PST:getTreeSnapshotMod("wispDmgRed", 0)
                    if tmpMod > 0 then
                        dmgMult = dmgMult - tmpMod / 100
                    end
                end
            end
        -- Valid enemy
        elseif target:IsVulnerableEnemy() and target:IsActiveEnemy(false) and not EntityRef(target).IsFriendly then
            if source and source.Entity then
                -- Check if a familiar hit enemy
                local tmpFamiliar = nil
                if source.Type == EntityType.ENTITY_FAMILIAR then
                    tmpFamiliar = source.Entity:ToFamiliar()
                elseif source.SpawnerType == EntityType.ENTITY_FAMILIAR and source.Entity.SpawnerEntity then
                    tmpFamiliar = source.Entity.SpawnerEntity:ToFamiliar()
                end
                if tmpFamiliar then
                    -- Wisp hit
                    if tmpFamiliar.Variant == FamiliarVariant.WISP then
                        -- Mod: Wisps inherit % of your damage
                        tmpMod = PST:getTreeSnapshotMod("vesselWispInherit", 0)
                        if tmpMod > 0 then
                            dmgExtra = dmgExtra + srcPlayer.Damage * (tmpMod / 100)
                        end
                    -- Blue spider hit
                    elseif tmpFamiliar.Variant == FamiliarVariant.BLUE_SPIDER then
                        -- Mod: blue spiders inherit +% of your damage
                        tmpMod = PST:getTreeSnapshotMod("blueSpiderDmgInherit", 0)
                        if tmpMod > 0 then
                            dmgExtra = dmgExtra + srcPlayer.Damage * (tmpMod / 100)
                        end

                        -- Mod: blue spiders petrify slowed enemies on hit
                        tmpMod = PST:getTreeSnapshotMod("blueSpiderPetriSlow", 0)
                        if tmpMod > 0 and (target:GetSlowingCountdown() > 0 or target:GetSpeedMultiplier() < 1) then
                            target:AddFreeze(EntityRef(srcPlayer), math.ceil(tmpMod * 30))
                        end

                        -- Caustic Bite node (Tarantula mutagenic constellation)
                        if PST:getTreeSnapshotMod("causticBite", false) then
                            target:AddPoison(EntityRef(srcPlayer), 120, srcPlayer.Damage)
                        end

                        -- Blue spider death
                        if source.Entity:HasMortalDamage() then
                            PSTAVessel.roomBlueSpiderDeaths = PSTAVessel.roomBlueSpiderDeaths + 1

                            -- Mod: % chance for blue spiders to leave slowing creep on death
                            tmpMod = PST:getTreeSnapshotMod("blueSpiderSlowCreep", 0)
                            if tmpMod > 0 and 100 * math.random() < tmpMod then
                                local newCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, source.Position, Vector.Zero, nil)
                                newCreep:ToEffect().Scale = 2
                            end
                        end
                    -- Blue fly hit
                    elseif tmpFamiliar.Variant == FamiliarVariant.BLUE_FLY then
                        -- Blue fly death
                        if source.Entity:HasMortalDamage() then
                            -- Mod: % chance for blue flies to turn into a blue locust for the current room on death, up to 10x
                            tmpMod = PST:getTreeSnapshotMod("blueFlyLocust", 0)
                            if tmpMod > 0 and PST:getTreeSnapshotMod("blueFlyLocustProcs", 0) < 10 and 100 * math.random() < tmpMod then
                                local newLocust = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 0, source.Position, Vector.Zero, srcPlayer)
                                newLocust.Color = Color(0, 0.3, 1, 1, 0, 0, 0.6)
                            end
                        end
                    end
                end

                -- Sword Projectile hit
                if source.Type == EntityType.ENTITY_TEAR and source.Variant == TearVariant.SWORD_BEAM then
                    -- Mod: +% damage with sword projectiles per full soul heart you have
                    tmpMod = PST:getTreeSnapshotMod("palaSoulSwordDmg", 0)
                    if tmpMod > 0 then
                        local soulHearts = math.floor((srcPlayer:GetSoulHearts() - PSTAVessel:GetBlackHeartCount(srcPlayer)) / 2)
                        if soulHearts > 0 then
                            dmgMult = dmgMult + (tmpMod / 100) * soulHearts
                        end
                    end
                end

                -- Hit source is directly the player or their tears
                if source.Type == EntityType.ENTITY_PLAYER or source.SpawnerType == EntityType.ENTITY_PLAYER then
                    local trueSrcPlayer = source.Entity:ToPlayer() or source.Entity.SpawnerEntity:ToPlayer()
                    if trueSrcPlayer then
                        -- Squeeze Blood From Stone node (Baphomet demonic constellation)
                        if PST:getTreeSnapshotMod("squeezeBloodStone", false) and (flag & DamageFlag.DAMAGE_LASER) == 0 and target:GetFreezeCountdown() > 0 and PSTAVessel.modCooldowns.squeezeBloodStone == 0 then
                            local nearbyEnems = Isaac.FindInRadius(srcPlayer.Position, 120, EntityPartition.ENEMY)
                            for _, tmpEnem in ipairs(nearbyEnems) do
                                local nearNPC = tmpEnem:ToNPC()
                                if nearNPC and nearNPC:IsVulnerableEnemy() and nearNPC:IsActiveEnemy(false) and not EntityRef(nearNPC).IsFriendly then
                                    if nearNPC:GetFreezeCountdown() > 0 then
                                        local newLaser = srcPlayer:FireBrimstone((nearNPC.Position - srcPlayer.Position):Normalized(), srcPlayer, 0.9)
                                        newLaser:SetScale(0.5)
                                    end
                                end
                            end
                            PSTAVessel.modCooldowns.squeezeBloodStone = 150
                        end

                        -- Mod: hexer curse buffs, up to +% damage dealt to enemies far away from you
                        tmpMod = PST:getTreeSnapshotMod("hexerCurseBuff", 0)
                        if tmpMod > 0 and (Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_DARKNESS) > 0 then
                            local tmpDist = trueSrcPlayer.Position:Distance(target.Position)
                            if tmpDist >= 70 then
                                dmgMult = dmgMult + math.min((tmpMod * 2), (tmpMod * 2) * ((tmpDist - 69) / 150))
                            end
                        end

                        -- Mod: +% damage dealt to burning enemies
                        tmpMod = PST:getTreeSnapshotMod("burningExtraDmg", 0)
                        if tmpMod > 0 and target:GetBurnCountdown() > 0 then
                            dmgMult = dmgMult + tmpMod / 100
                        end

                        -- Mod: % chance to cause slowed enemies to freeze on death
                        tmpMod = PST:getTreeSnapshotMod("slowMobFreeze", 0)
                        if tmpMod > 0 and 100 * math.random() < tmpMod then
                            target:AddIce(EntityRef(trueSrcPlayer), 150)
                        end

                        -- Mod: % chance to petrify poisoned enemies for 2 seconds on hit, once per enemy
                        tmpMod = PST:getTreeSnapshotMod("poisonPetrify", 0)
                        if tmpMod > 0 and target:HasEntityFlags(EntityFlag.FLAG_POISON) and not PST:getEntData(target).PST_poisonPetrifyProc and
                        100 * math.random() < tmpMod then
                            target:AddFreeze(EntityRef(srcPlayer), 60)
                            PST:getEntData(target).PST_poisonPetrifyProc = true
                        end

                        -- Mod: % chance to spawn an orbiting ember on hit. Double the chance and embers gained when hitting burning enemies
                        tmpMod = PST:getTreeSnapshotMod("meteorEmber", 0)
                        if tmpMod > 0 then
                            if target:GetBurnCountdown() > 0 then
                                tmpMod = tmpMod * 2
                            end
                            if not (source.Entity and PST:getEntData(source.Entity).PST_ember) and 100 * math.random() < tmpMod then
                                if PSTAVessel.fusilladeEmbers < 10 then
                                    SFXManager():Play(SoundEffect.SOUND_BEAST_FIRE_RING, 0.4, 2, false, 1.3 + 0.4 * math.random())
                                    PSTAVessel.fusilladeSpawnFrom = PSTAVessel.fusilladeEmbers
                                    local tmpAdd = 1
                                    if target:GetBurnCountdown() > 0 then
                                        tmpAdd = 2
                                    end
                                    PSTAVessel.fusilladeEmbers = math.min(10, PSTAVessel.fusilladeEmbers + tmpAdd)
                                    PSTAVessel.modCooldowns.meteorEmber = PSTAVessel.fusilladeDelay
                                end
                            end
                        end

                        -- Mod: % chance to fire an ice shard towards the closest enemy when hitting slowed enemies
                        tmpMod = PST:getTreeSnapshotMod("slowHitIceShard", 0)
                        if tmpMod > 0 and (target:GetSlowingCountdown() > 0 or target:GetSpeedMultiplier() < 1) and not (source.Entity and PST:getEntData(source.Entity).PST_iceShard) and
                        100 * math.random() < tmpMod then
                            local closestEnem = PSTAVessel:getClosestEnemy(srcPlayer.Position, 120)
                            if closestEnem then
                                local tmpVel = (closestEnem.Position - srcPlayer.Position):Normalized() * 8
                                local newShard = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ICE, 0, srcPlayer.Position, tmpVel, srcPlayer)
                                newShard.CollisionDamage = 1 + math.min(20, srcPlayer.Damage)
                                PST:getEntData(newShard).PST_iceShard = true
                            end
                        end

                        -- Mod: +% damage dealt to slowed enemies
                        tmpMod = PST:getTreeSnapshotMod("slowedDmg", 0)
                        if tmpMod > 0 and (target:GetSlowingCountdown() > 0 or target:GetSpeedMultiplier() < 1) then
                            dmgMult = dmgMult + tmpMod / 100
                        end

                        -- Mod: +% damage dealt by your ice shards
                        tmpMod = PST:getTreeSnapshotMod("frozenTearBuffExtra", 0)
                        if tmpMod > 0 and (source.Type == EntityType.ENTITY_TEAR and source.Variant == TearVariant.ICE) then
                            dmgMult = dmgMult + tmpMod * 0.02
                        end

                        -- Snowstorm node (Blizzard elemental constellation) - double damage from shards against bosses
                        if PST:getTreeSnapshotMod("blizzardSnowstorm", false) and tmpNPC and tmpNPC:IsBoss() and PST:getEntData(source.Entity).PST_snowstormShard then
                            dmgMult = dmgMult + 1
                        end

                        -- Mod: hitting poisoned enemies shoots 2 poison tears towards them
                        if PST:getTreeSnapshotMod("scorpionHitTears", false) and PSTAVessel.modCooldowns.scorpionHitTears == 0 then
                            local tmpMaxTears = 2
                            if 100 * math.random() < PST:getTreeSnapshotMod("scorpionHitTearsExtra", 0) then
                                tmpMaxTears = 3
                            end
                            for _=1,tmpMaxTears do
                                local tmpVel = (target.Position + RandomVector() * 40 - srcPlayer.Position):Normalized() * 10
                                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, srcPlayer.Position, tmpVel, srcPlayer)
                                newTear.Color = Color(0.5, 0.5, 0.5, 1, 0, 0.5, 0)
                                newTear:ToTear():AddTearFlags(TearFlags.TEAR_POISON | TearFlags.TEAR_BOUNCE)
                                newTear.CollisionDamage = math.min(20, srcPlayer.Damage)
                            end
                            PSTAVessel.modCooldowns.scorpionHitTears = math.floor(120 - PST:getTreeSnapshotMod("scorpionHitTearsCD", 0) * 30)
                        end

                        -- Mod: % chance to spread poison to nearby enemies when hitting poisoned enemies
                        tmpMod = PST:getTreeSnapshotMod("viperPoisonSpread", 0)
                        if tmpMod > 0 and target:HasEntityFlags(EntityFlag.FLAG_POISON) and 100 * math.random() < tmpMod then
                            local nearbyEnems = PSTAVessel:getNearbyNPCs(target.Position, 90, EntityPartition.ENEMY)
                            for _, tmpEnem in ipairs(nearbyEnems) do
                                if tmpEnem.InitSeed ~= target.InitSeed then
                                    tmpEnem:AddPoison(EntityRef(srcPlayer), math.max(45, tmpEnem:GetPoisonDamageTimer()), math.min(15, srcPlayer.Damage / 2))
                                end
                            end
                        end

                        -- Mod: +% damage dealt against poisoned enemies
                        tmpMod = PST:getTreeSnapshotMod("poisonMobDmg", 0)
                        if tmpMod > 0 and target:HasEntityFlags(EntityFlag.FLAG_POISON) then
                            dmgMult = dmgMult + tmpMod / 100
                        end

                        -- Viperine Lash node (Viper elemental constellation)
                        if PST:getTreeSnapshotMod("viperineLash", false) and tmpNPC and (tmpNPC:IsBoss() or tmpNPC:IsChampion()) and PSTAVessel.modCooldowns.viperineLash == 0 then
                            local tmpMaxTears = 5 + math.floor(7 * (1 - target.HitPoints / target.MaxHitPoints))
                            for _=1,tmpMaxTears do
                                local tmpVel = (target.Position + RandomVector() * 40 - srcPlayer.Position):Normalized() * (30 * math.random())
                                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, srcPlayer.Position, tmpVel, srcPlayer)
                                newTear.Color = Color(0.5, 0.5, 0.5, 1, 0, 0.5, 0)
                                newTear:ToTear().Scale = 0.5 + math.random()
                                newTear:ToTear():AddTearFlags(TearFlags.TEAR_POISON | TearFlags.TEAR_BOUNCE | TearFlags.TEAR_DECELERATE)
                                newTear:ToTear().Height = -40
                                newTear:ToTear().FallingSpeed = 0.01
                                newTear:ToTear().FallingAcceleration = 0.01
                            end
                            SFXManager():Play(SoundEffect.SOUND_HEARTOUT, 0.9, 2, false, 0.8 + 0.4 * math.random())
                            PSTAVessel.modCooldowns.viperineLash = 150
                            if target:HasEntityFlags(EntityFlag.FLAG_POISON) then
                                PSTAVessel.modCooldowns.viperineLash = 75
                            end
                        end

                        -- Mod: % chance for enemies to leave a fire on death (burns on hit)
                        if (PST:getEntData(source.Entity).PST_mobDeathFire) and target:GetBurnCountdown() == 0 then
                            target:AddBurn(EntityRef(srcPlayer), 100, math.min(20, srcPlayer.Damage / 2))
                        end

                        -- Mod: % chance per battery item you have to fire a homing electric tear when hitting enemies
                        tmpMod = PST:getTreeSnapshotMod("batteryItemElecTear", 0)
                        if tmpMod > 0 and PSTAVessel.modCooldowns.batteryItemElecTear == 0 then
                            local batteryItems = 0
                            for _, tmpItem in ipairs(PSTAVessel.batteryItems) do
                                batteryItems = batteryItems + srcPlayer:GetCollectibleNum(tmpItem, true)
                            end
                            if batteryItems > 0 and 100 * math.random() < tmpMod * batteryItems then
                                local tmpVel = (target.Position - srcPlayer.Position):Normalized() * 10
                                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, srcPlayer.Position, tmpVel, srcPlayer)
                                newTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING | TearFlags.TEAR_JACOBS)
                                PSTAVessel.modCooldowns.batteryItemElecTear = 60
                            end
                        end

                        -- Mod: % chance to create a black hole on hit
                        tmpMod = PST:getTreeSnapshotMod("hitBlackHole", 0)
                        if tmpMod > 0 then
                            local darkCursePresent = (PST:getLevel():GetCurses() & LevelCurse.CURSE_OF_DARKNESS) > 0
                            if darkCursePresent then
                                tmpMod = tmpMod * 2
                            end
                            if tmpMod > 0 and PSTAVessel.modCooldowns.hitBlackHole == 0 and 100 * math.random() < tmpMod then
                                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, 0, target.Position, Vector.Zero, nil)
                                PSTAVessel.modCooldowns.hitBlackHole = 900
                                if darkCursePresent then
                                    PSTAVessel.modCooldowns.hitBlackHole = 450
                                end
                            end
                        end

                        -- Mod: % chance to poison enemies on hit per blue spider that died this room
                        tmpMod = PST:getTreeSnapshotMod("spiderDeathHitStatus", 0)
                        if tmpMod > 0 and 100 * math.random() < tmpMod * PSTAVessel.roomBlueSpiderDeaths then
                            if PSTAVessel.roomBlueSpiderDeaths < 7 then
                                target:AddPoison(EntityRef(srcPlayer), 90, srcPlayer.Damage)
                            else
                                target:AddFreeze(EntityRef(srcPlayer), 45)
                            end
                        end

                        -- Mod: % chance to launch a homing Mucormycosis tear when hitting poisoned enemies
                        tmpMod = PST:getTreeSnapshotMod("poisonHitMucor", 0)
                        if tmpMod > 0 and target:HasEntityFlags(EntityFlag.FLAG_POISON) and PSTAVessel.modCooldowns.poisonHitMucor == 0 and
                        100 * math.random() < tmpMod then
                            local tmpVel = (target.Position - srcPlayer.Position):Normalized() * 9
                            local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SPORE, 0, srcPlayer.Position, tmpVel, srcPlayer)
                            newTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING | TearFlags.TEAR_SPORE)
                            newTear.CollisionDamage = srcPlayer.Damage
                            PSTAVessel.modCooldowns.poisonHitMucor = 30
                        end

                        -- Mutagenic tear hit - inflict random status
                        if PST:getEntData(source.Entity).PST_mutagenicTear then
                            PST:inflictRandomStatus(srcPlayer, target, 90)
                        end

                        -- Caustic Bite node (Tarantula mutagenic constellation)
                        if PST:getTreeSnapshotMod("causticBite", false) and target:HasEntityFlags(EntityFlag.FLAG_POISON) then
                            local totalSpiders = #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_SPIDER)
                            if totalSpiders < 30 and 100 * math.random() < 0.05 then
                                srcPlayer:ThrowBlueSpider(target.Position, target.Position + RandomVector() * 40)
                                PSTAVessel.modCooldowns.causticBite = 15
                            end
                        end

                        -- Mod: % chance to charm enemies on hit per familiar you have
                        tmpMod = PST:getTreeSnapshotMod("sirenCharmBuff", 0) * PST:getTreeSnapshotMod("totalFamiliars", 0)
                        if tmpMod > 0 and 100 * math.random() < tmpMod then
                            target:AddCharmed(EntityRef(srcPlayer), 90)
                        end

                        -- Mod: inflict Hemoptysis' curse on hit for the first X seconds of a room
                        tmpMod = PST:getTreeSnapshotMod("tempHemoCurseHit", 0)
                        if tmpMod > 0 and Game():GetRoom():GetFrameCount() <= tmpMod * 30 then
                            target:AddBrimstoneMark(EntityRef(srcPlayer), 150)
                        end
                    end
                end

                -- Mod: % chance for creep to poison enemies on hit
                tmpMod = PST:getTreeSnapshotMod("creepPoison", 0)
                if tmpMod > 0 and source.Type == EntityType.ENTITY_EFFECT and PSTAVessel:arrHasValue(PST.playerDamagingCreep, source.Variant) and
                not target:HasEntityFlags(EntityFlag.FLAG_POISON) and 100 * math.random() < tmpMod then
                    target:AddPoison(EntityRef(srcPlayer), 90, srcPlayer.Damage)
                end
            end

            -- Mod: +% damage with holy beams and weapons
            tmpMod = PST:getTreeSnapshotMod("holyWpDmg", 0)
            if tmpMod > 0 then
                local isHolyWeaponHit = false
                -- Spear of Destiny hit
                if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.SPEAR_OF_DESTINY then
                    isHolyWeaponHit = true
                end

                -- Hit by Holy Beam
                if not isHolyWeaponHit then
                    local beamNearby = false
                    local tmpBeams = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY)
                    for _, tmpEffect in ipairs(tmpBeams) do
                        local dist = tmpEffect.Position:Distance(srcPlayer.Position)
                        if dist <= 40 then
                            beamNearby = true
                            break
                        end
                    end
                    if beamNearby then
                        isHolyWeaponHit = true
                    end
                end

                -- Hit by Spirit Sword
                -- Function by babybluesheep from D!Edith - slightly altered
                local function IterateOverKnives(variant, subtype)
                    local hitIndex = target:GetHitListIndex()
                    for _, v in ipairs(Isaac.FindByType(EntityType.ENTITY_KNIFE, variant, subtype)) do
                        local knife = v:ToKnife()
                        if knife and knife:GetIsSwinging() then
                            for _, i in ipairs(knife:GetHitList()) do
                                if i == hitIndex then
                                    return true
                                end
                            end
                        end
                    end
                end
                -- Spirit sword hit
                if not isHolyWeaponHit and IterateOverKnives(KnifeVariant.SPIRIT_SWORD, 4) then
                    isHolyWeaponHit = true
                end

                if isHolyWeaponHit then
                    dmgMult = dmgMult + tmpMod / 100
                end
            end

            -- Mod: % chance to slow flying enemies on hit, 1/2 chance if you don't have flight. Same chance to slow ground enemies if you have flight
            tmpMod = PST:getTreeSnapshotMod("cherubSlow", 0)
            if tmpMod > 0 then
                if not srcPlayer:IsFlying() then tmpMod = tmpMod / 2 end
                if 100 * math.random() < tmpMod then
                    if target:IsFlying() or (srcPlayer:IsFlying() and not target:IsFlying()) then
                        target:AddSlowing(EntityRef(srcPlayer), 90, 0.75, Color(0.8, 0.8, 0.8, 1))
                    end
                end
            end

            -- Mod: % chance to create a beam of light when hitting enemies, halved if you don't have flight. 2 sec CD
            tmpMod = PST:getTreeSnapshotMod("lightBeamHit", 0)
            if tmpMod > 0 and PSTAVessel.modCooldowns.lightBeamHit == 0 and 100 * math.random() < tmpMod then
                local newLightBeam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, target.Position, Vector.Zero, srcPlayer)
                newLightBeam.CollisionDamage = srcPlayer.Damage / 5
                PSTAVessel.modCooldowns.lightBeamHit = 60
            end

            -- Carrion Harvest node (Ritualist occult constellation)
            if PST:getTreeSnapshotMod("carrionHarvestHits", 0) > 0 then
                local tgData = PST:getEntData(target)
                if tgData.PST_carrionCurse then
                    dmgMult = dmgMult + 0.1
                else
                    tgData.PST_carrionCurse = true
                    PST:addModifiers({ carrionHarvestHits = -1 }, true)
                end
            end

            -- Mod: % chance for explosions to cause burning for 4 seconds
            tmpMod = PST:getTreeSnapshotMod("explosionsBurn", 0)
            if tmpMod > 0 and (flag & DamageFlag.DAMAGE_EXPLOSION) > 0 and 100 * math.random() < tmpMod then
                target:AddBurn(EntityRef(srcPlayer), 120, math.min(20, srcPlayer.Damage / 2))
            end

            -- Solar Scion node (Sun cosmic constellation)
            if PST:getTreeSnapshotMod("solarScionBossDead", false) and PSTAVessel.inSolarFireRing then
                target:AddBurn(EntityRef(srcPlayer), 90, math.min(20, srcPlayer.Damage / 2))
            end

            -- NPC checks
            if tmpNPC then
                -- Mod: swords on champion hit
                tmpMod = PST:getTreeSnapshotMod("palaChampSwords", 0)
                if tmpMod > 0 and PSTAVessel.modCooldowns.palaChampSwords == 0 and (tmpNPC:IsBoss() or tmpNPC:IsChampion()) and
                not (source.Entity and PST:getEntData(source.Entity).vesselPalaSword) and 100 * math.random() < tmpMod then
                    local tmpCount = 2 + math.random(3)
                    for i=1,tmpCount do
                        local randAng = math.random() * 2 * math.pi
                        local tmpPos = srcPlayer.Position + Vector(30 * math.cos(randAng), 30 * math.sin(randAng))
                        local tmpVel = (target.Position - tmpPos):Normalized() * (7 + 0.5 * math.random())
                        local newSword = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SWORD_BEAM, 0, tmpPos, tmpVel, srcPlayer)
                        newSword:ToTear():AddTearFlags(TearFlags.TEAR_ACCELERATE)
                        newSword.CollisionDamage = math.min(25, srcPlayer.Damage / 2)
                        PST:getEntData(newSword).vesselPalaSword = true
                        PSTAVessel.modCooldowns.palaChampSwords = 90
                        SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 0.3, (i - 1) * 2, false, 1.4 + 0.6 * math.random())
                    end
                end

                -- Mod: +% damage dealt to full health enemies per 1/2 red heart you have. Double bonus against bosses in boss rooms
                tmpMod = PST:getTreeSnapshotMod("vampHealthyDmg", 0)
                local roomType = Game():GetRoom():GetType()
                if tmpNPC:IsBoss() and (roomType == RoomType.ROOM_BOSS or roomType == RoomType.ROOM_BOSSRUSH) then
                    tmpMod = tmpMod * 2
                end
                if tmpMod > 0 and target.HitPoints == target.MaxHitPoints then
                    dmgMult = dmgMult + (tmpMod / 100) * srcPlayer:GetHearts()
                end
            end
        end

        if dmgMult ~= 1 and dmgExtra ~= 0 then
            return { Damage = damage * math.max(0.01, dmgMult) + dmgExtra }
        end
    end
end