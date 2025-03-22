include("scripts.lifeblooms")

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
    local effectData = effect:GetData()

    -- Mod: ritual purple flame
    if effectData.PST_ritualPurpleFlame then
        local frameCount = Game():GetFrameCount()
        if frameCount % 10 == 0 then
            local player = PST:getPlayer()
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 110, EntityPartition.ENEMY)
            local closest = nil
            local closestDist = 1000
            for _, tmpEnem in ipairs(nearbyEnems) do
                local tmpDist = effect.Position:Distance(tmpEnem.Position)
                if tmpDist < closestDist then
                    closest = tmpEnem
                    closestDist = tmpDist
                end
                if tmpDist <= 60 then
                    tmpEnem:TakeDamage(4, DamageFlag.DAMAGE_FIRE, EntityRef(player), 0)
                    tmpEnem:AddFear(EntityRef(player), 75)
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
    -- Mod: poison cloud on death
    elseif effectData.PST_poisonCloudOnDeath then
        local frameCount = Game():GetFrameCount()
        if frameCount % 15 == 0 then
            local player = PST:getPlayer()
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 60, EntityPartition.ENEMY)
            for _, tmpEnem in ipairs(nearbyEnems) do
                tmpEnem:TakeDamage(1, DamageFlag.DAMAGE_POISON_BURN, EntityRef(player), 0)
                if not tmpEnem:HasEntityFlags(EntityFlag.FLAG_POISON) then
                    tmpEnem:AddPoison(EntityRef(player), 75, math.min(10, player.Damage))
                end
            end
        end
    -- Crimson Bloom
    elseif PSTAVessel:arrHasValue(PSTAVessel.lifebloomsList, effect.Variant) then
        PSTAVessel:effectLifebloomUpdate(effect)
    else
        ---@type EntityPlayer
        local player = PST:getPlayer()

        -- Mod: volcano fire tears
        if effect.Variant == EffectVariant.RED_CANDLE_FLAME and PST:getTreeSnapshotMod("volcanoFireTears", false) and
        effect.SpawnerType == EntityType.ENTITY_PLAYER then
            local tearCD = 40
            if not effect:GetData().PST_volcanoFireCD then
                effect:GetData().PST_volcanoFireCD = tearCD
            elseif effect:GetData().PST_volcanoFireCD > 0 then
                effect:GetData().PST_volcanoFireCD = effect:GetData().PST_volcanoFireCD - 1
            elseif effect:GetData().PST_volcanoFireCD == 0 then
                local closestEnem = PSTAVessel:getClosestEnemy(effect.Position, 100)
                if closestEnem then
                    local tmpVel = (closestEnem.Position - effect.Position):Normalized() * 10
                    local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.FIRE_MIND, 0, effect.Position, tmpVel, effect)
                    newTear.CollisionDamage = math.min(30, player.Damage + player.Damage * (PST:getTreeSnapshotMod("volcanoFireTearDmg", 0) / 100))
                end
                effect:GetData().PST_volcanoFireCD = tearCD
            end
        end
    end
end