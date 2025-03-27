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
    -- Lunar Scion node (Moon cosmic constellation) - Moonlight ray effect
    elseif effect.Variant == PSTAVessel.lunarScionMoonlightID then
        if not effect:GetData().PST_lunarRayDisappear then
            if Game():GetFrameCount() % 15 == 0 then
                -- Player nearby - trigger effect
                if effect.Position:Distance(PST:getPlayer().Position) <= 30 then
                    PST:addModifiers({ lunarScionStacks = 1 }, true)
                    PST:updateCacheDelayed()
                    PSTAVessel.modCooldowns.lunarScion = 300
                    effect:GetData().PST_lunarRayDisappear = true
                    effect:GetSprite():Play("Disappear")
                    SFXManager():Play(SoundEffect.SOUND_HOLY, 0.4, 2, false, 1.3)
                end
                if PST:getRoom():GetAliveEnemiesCount() == 0 then
                    effect:GetData().PST_lunarRayDisappear = true
                    effect:GetSprite():Play("Disappear")
                end
            end
        elseif effect:GetSprite():IsFinished() then
            effect:Remove()
        end
    -- Solar Scion node (Sun cosmic constellation) - Fire ring effect
    elseif effect.Variant == PSTAVessel.solarScionFireRingID then
        effect.DepthOffset = -100
        if not effect:GetData().PST_solarRingInit then
            effect:GetSprite().PlaybackSpeed = 0.5
            effect:GetData().PST_solarRingTarget = Game():GetRoom():GetRandomPosition(20)
            effect:GetData().PST_solarRingInit = true
            SFXManager():Play(SoundEffect.SOUND_FLAMETHROWER_START, 0.4, 0, false, 0.9)

            local lightFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LIGHT, 0, effect.Position, Vector.Zero, nil)
            lightFX:ToEffect().SpriteScale = Vector(2, 2)
            lightFX:ToEffect().Color = Color(0.9, 0.65, 0.2, 1)
            effect:GetData().PST_solarRingLightFX = lightFX
        elseif not effect:GetData().PST_solarRingFading then
            local frameCount = Game():GetFrameCount()
            if frameCount % 2 == 0 then
                -- Ember FX particles
                if not effect:GetData().PST_solarRingActive then
                    for _=1,2 do
                        local tmpAng = math.pi * 2 * math.random()
                        local tmpSpawnPos = effect.Position + Vector(math.cos(tmpAng) * 60, math.sin(tmpAng) * 60)
                        local tmpVel = Vector(math.cos(tmpAng + math.pi) * 5, math.sin(tmpAng + math.pi) * 5)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, tmpSpawnPos, tmpVel, nil)
                    end
                else
                    for _=1,3 do
                        local tmpAng = math.pi * 2 * math.random()
                        local tmpSpawnPos = effect.Position + Vector(math.cos(tmpAng) * 40, math.sin(tmpAng) * 40)
                        local tmpVel = Vector(math.cos(tmpAng + math.pi / 2) * 7, math.sin(tmpAng + math.pi / 2) * 7)
                        local emberFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.EMBER_PARTICLE, 0, tmpSpawnPos, tmpVel, nil)
                        emberFX:GetData().PST_solarRingEmberFX = true
                    end

                    -- Disappear on room clear
                    if frameCount % 15 == 0 and PST:getRoom():GetAliveEnemiesCount() == 0 then
                        effect:GetData().PST_solarRingFading = true
                    end
                end

                -- Movement
                local targetDist = effect.Position:Distance(effect:GetData().PST_solarRingTarget)
                if targetDist > 25 then
                    local tmpVel = (effect:GetData().PST_solarRingTarget - effect.Position):Normalized()
                    effect:AddVelocity(tmpVel * 0.02)
                else
                    effect:GetData().PST_solarRingTarget = Game():GetRoom():GetRandomPosition(20)
                end
                if effect:GetData().PST_solarRingLightFX and effect:GetData().PST_solarRingLightFX:Exists() then
                    effect:GetData().PST_solarRingLightFX.Position = effect.Position
                end
            end
            -- Growing -> Active phase
            if effect:GetSprite():IsFinished("Growing") then
                effect:GetSprite().PlaybackSpeed = 1
                effect:GetSprite():Play("Active", true)
                effect:GetData().PST_solarRingActive = true
                SFXManager():Play(SoundEffect.SOUND_FLAME_BURST, 0.7, 2, false, 1.2)
            end
        elseif effect:GetSprite().Color.A > 0 then
            effect:GetSprite().Color.A = effect:GetSprite().Color.A - 0.05
        else
            effect:Remove()
        end
    -- Solar Scion fire ring ember particle
    elseif effect:GetData().PST_solarRingEmberFX then
        effect.Velocity = effect.Velocity * 0.95
        SFXManager():Play(SoundEffect.SOUND_FIRE_BURN)
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

---@param familiar EntityFamiliar
function PSTAVessel:onFamiliarInit(familiar)
    -- Blue spider
    if familiar.Variant == FamiliarVariant.BLUE_SPIDER then
        -- Mod: whenever a blue spider is spawned, % chance to spawn an additional one, up to 4x per room
        local tmpMod = PST:getTreeSnapshotMod("spiderDupe", 0)
        if tmpMod > 0 and PST:getTreeSnapshotMod("spiderDupeProcs", 0) < 4 and 100 * math.random() < tmpMod then
            Game():GetPlayer(0):ThrowBlueSpider(familiar.Position, RandomVector() * 30)
            PST:addModifiers({ spiderDupeProcs = 1 }, true)
        end
    end
end