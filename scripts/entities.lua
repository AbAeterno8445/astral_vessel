---@param npc EntityNPC
function PSTAVessel:onNPCUpdate(npc)
    -- Mod: +% tears for 6 seconds whenever a friendly undead monster is summoned
    local tmpMod = PST:getTreeSnapshotMod("undeadSummonTears", 0)
    if tmpMod > 0 and PST:isMobUndead(npc) then
        -- Friendly NPC init
        if EntityRef(npc).IsFriendly and not npc:GetData().PST_friendInit then
            npc:GetData().PST_friendInit = true

            if PSTAVessel.modCooldowns.undeadSummonTears == 0 then
                PST:updateCacheDelayed(CacheFlag.CACHE_FIREDELAY)
            end
            PSTAVessel.modCooldowns.undeadSummonTears = 180
        end
    end

    -- Carrion Harvest node (Ritualist occult constellation) - effect
    if npc:GetData().PST_carrionCurse and Game():GetFrameCount() % 8 == 0 then
        local carrionCurseSprite = Sprite("gfx/effects/avessel_carrioncurse.anm2", true)
        carrionCurseSprite.Scale = Vector(0.5, 0.5)
        carrionCurseSprite:Play("Default")
        PST:createFloatIconFX(carrionCurseSprite, npc.Position + RandomVector() * 8, 0.15, 40, false, true)
    end
end

---@param effect EntityEffect
function PSTAVessel:effectUpdate(effect)
    -- Mod: ritual purple flame
    if effect:GetData().PST_ritualPurpleFlame then
        local frameCount = Game():GetFrameCount()
        if frameCount % 10 == 0 then
            local player = PST:getPlayer()
            local nearbyEnems = Isaac.FindInRadius(effect.Position, 110, EntityPartition.ENEMY)
            local closest = nil
            local closestDist = 1000
            for _, tmpEnem in ipairs(nearbyEnems) do
                local tmpNPC = tmpEnem:ToNPC()
                if tmpNPC and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsActiveEnemy(false) and not EntityRef(tmpNPC).IsFriendly then
                    local tmpDist = effect.Position:Distance(tmpNPC.Position)
                    if tmpDist < closestDist then
                        closest = tmpNPC
                        closestDist = tmpDist
                    end
                    if tmpDist <= 60 then
                        tmpNPC:TakeDamage(4, DamageFlag.DAMAGE_FIRE, EntityRef(player), 0)
                        tmpNPC:AddFear(EntityRef(player), 75)
                    end
                end
            end
            if closest and frameCount % 20 == 0 then
                local tmpVel = (closest.Position - effect.Position):Normalized() * 7
                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, effect.Position, tmpVel, player)
                newTear.Color = Color(0.4, 0.15, 0.38, 1)
                newTear.CollisionDamage = 1 + math.min(18, player.Damage / 2)
                newTear:ToTear():AddTearFlags(TearFlags.TEAR_HOMING)
            end
        end
    end
end