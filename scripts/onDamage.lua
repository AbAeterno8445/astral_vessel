---@param target Entity
---@param damage number
---@param flag integer
---@param source EntityRef
function PSTAVessel:onDamage(target, damage, flag, source)
    local tmpMod
    local player = target:ToPlayer()
    if player then
        -- Player got hit
        -- True Eternal node (Archangel divine constellation)
        if PST:getTreeSnapshotMod("trueEternal", false) and player:GetEternalHearts() > 0 then
            PSTAVessel.trueEternalHitProc = true
        end
    elseif target and target.Type ~= EntityType.ENTITY_GIDEON then
        local srcPlayer
        if source and source.Entity then
            if source.Type == EntityType.ENTITY_PLAYER then
                srcPlayer = source.Entity:ToPlayer()
            elseif source.Entity.SpawnerEntity and source.Entity.SpawnerEntity == EntityType.ENTITY_PLAYER then
                srcPlayer = source.Entity.SpawnerEntity:ToPlayer()
            elseif source.Entity.Parent and source.Entity.Parent == EntityType.ENTITY_PLAYER then
                srcPlayer = source.Entity.Parent:ToPlayer()
            end
        end
        if not srcPlayer then srcPlayer = PST:getPlayer() end

        local dmgMult = 1
        local dmgExtra = 0

        -- Check if a familiar got hit
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
        -- Valid enemy
        elseif target:IsVulnerableEnemy() and target:IsActiveEnemy(false) and not EntityRef(target).IsFriendly then
            --print("hitdata", source.Type, source.Variant, (source.Entity and source.Entity.SubType or nil), flag, damage)

            if source and source.Entity then
                -- Check if a familiar hit enemy
                tmpFamiliar = source.Entity:ToFamiliar()
                if tmpFamiliar == nil and source.Entity.SpawnerEntity ~= nil then
                    -- For tears shot by familiars
                    tmpFamiliar = source.Entity.SpawnerEntity:ToFamiliar()
                end
                if tmpFamiliar and target:IsActiveEnemy(false) then
                    -- Wisp hit
                    if tmpFamiliar.Variant == FamiliarVariant.WISP then
                        -- Mod: Wisps inherit % of your damage
                        tmpMod = PST:getTreeSnapshotMod("vesselWispInherit", 0)
                        if tmpMod > 0 then
                            dmgExtra = dmgExtra + srcPlayer.Damage * (tmpMod / 100)
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
            end

            local isHolyWeaponHit = false

            -- Spear of Destiny hit
            if source.Type == EntityType.ENTITY_EFFECT and source.Variant == EffectVariant.SPEAR_OF_DESTINY then
                isHolyWeaponHit = true
            end

            -- Hit by Holy Beam
            if not isHolyWeaponHit then
                local beamNearby = false
                local nearbyBeams = Isaac.FindInRadius(target.Position, 40, EntityPartition.EFFECT)
                for _, tmpEffect in ipairs(nearbyBeams) do
                    if tmpEffect.Variant == EffectVariant.CRACK_THE_SKY then
                        beamNearby = true
                        break
                    end
                end
                if beamNearby then
                    isHolyWeaponHit = true
                end
            end

            -- Hit by Spirit Sword
            local hitIndex = target:GetHitListIndex()
            -- Function by babybluesheep from D!Edith - slightly altered
            local function IterateOverKnives(variant, subtype)
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
                -- Mod: +% damage with holy beams and weapons
                tmpMod = PST:getTreeSnapshotMod("holyWpDmg", 0)
                if tmpMod > 0 then
                    dmgMult = dmgMult + tmpMod / 100
                end
            end

            -- Mod: % chance to slow flying enemies on hit, 1/2 chance if you don't have flight. Same chance to slow ground enemies if you have flight
            tmpMod = PST:getTreeSnapshotMod("cherubSlow", 0)
            if not srcPlayer:IsFlying() then tmpMod = tmpMod / 2 end
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                if target:IsFlying() or (srcPlayer:IsFlying() and not target:IsFlying()) then
                    target:AddSlowing(EntityRef(srcPlayer), 90, 0.75, Color(0.8, 0.8, 0.8, 1))
                end
            end

            -- Mod: % chance to create a beam of light when hitting enemies, halved if you don't have flight. 2 sec CD
            tmpMod = PST:getTreeSnapshotMod("lightBeamHit", 0)
            if tmpMod > 0 and PSTAVessel.modCooldowns.lightBeamHit == 0 and 100 * math.random() < tmpMod then
                local newLightBeam = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, target.Position, Vector.Zero, srcPlayer)
                newLightBeam.CollisionDamage = srcPlayer.Damage / 5
                PSTAVessel.modCooldowns.lightBeamHit = 60
            end

            -- NPC checks
            local tmpNPC = target:ToNPC()
            if tmpNPC then
                -- Mod: swords on champion hit
                tmpMod = PST:getTreeSnapshotMod("palaChampSwords", 0)
                if tmpMod > 0 and PSTAVessel.modCooldowns.palaChampSwords == 0 and (tmpNPC:IsBoss() or tmpNPC:IsChampion()) and
                not (source.Entity and source.Entity:GetData().vesselPalaSword) and 100 * math.random() < tmpMod then
                    local tmpCount = 2 + math.random(3)
                    for i=1,tmpCount do
                        local randAng = math.random() * 2 * math.pi
                        local tmpPos = srcPlayer.Position + Vector(30 * math.cos(randAng), 30 * math.sin(randAng))
                        local tmpVel = (target.Position - tmpPos):Normalized() * (7 + 0.5 * math.random())
                        local newSword = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.SWORD_BEAM, 0, tmpPos, tmpVel, srcPlayer)
                        newSword.CollisionDamage = math.min(25, srcPlayer.Damage / 2)
                        newSword:GetData().vesselPalaSword = true
                        PSTAVessel.modCooldowns.palaChampSwords = 90
                        SFXManager():Play(SoundEffect.SOUND_SWORD_SPIN, 0.3, (i - 1) * 2, false, 1.4 + 0.6 * math.random())
                    end
                end
            end

            -- Hit source is directly the player or their tears
            local trueSrcPlayer = source.Entity:ToPlayer()
            if trueSrcPlayer == nil then
                if source.Entity.Parent then
                    trueSrcPlayer = source.Entity.Parent:ToPlayer()
                end
                if trueSrcPlayer == nil and source.Entity.SpawnerEntity then
                    trueSrcPlayer = source.Entity.SpawnerEntity:ToPlayer()
                end
            end
            if trueSrcPlayer then
                -- Squeeze Blood From Stone node (Baphomet demonic constellation)
                if PST:getTreeSnapshotMod("squeezeBloodStone", false) and (flag & DamageFlag.DAMAGE_LASER) == 0 and target:GetFreezeCountdown() > 0 and PSTAVessel.modCooldowns.squeezeBloodStone == 0 then
                    local nearbyEnems = Isaac.FindInRadius(srcPlayer.Position, 120, EntityPartition.ENEMY)
                    for _, tmpEnem in ipairs(nearbyEnems) do
                        local tmpNPC = tmpEnem:ToNPC()
                        if tmpNPC and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsActiveEnemy(false) and not EntityRef(tmpNPC).IsFriendly then
                            if tmpNPC:GetFreezeCountdown() > 0 then
                                local newLaser = srcPlayer:FireBrimstone((tmpNPC.Position - srcPlayer.Position):Normalized(), srcPlayer, 0.9)
                                newLaser:SetScale(0.5)
                            end
                        end
                    end
                    PSTAVessel.modCooldowns.squeezeBloodStone = 150
                end
            end
        end

        if dmgMult ~= 1 and dmgExtra ~= 0 then
            return { Damage = damage * math.max(0.01, dmgMult) + dmgExtra }
        end
    end
end