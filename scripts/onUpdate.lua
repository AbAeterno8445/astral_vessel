function PSTAVessel:onUpdate()
    ---@type EntityPlayer
    local player = PST:getPlayer()
    if player:GetPlayerType() ~= PSTAVessel.charType then return end

    -- First update after entering floor
    if PSTAVessel.floorFirstUpdate then
        PSTAVessel.floorFirstUpdate = false

        -- True Eternal node (Archangel divine constellation)
        if PST:getTreeSnapshotMod("trueEternal", false) then
            if player:GetEternalHearts() == 0 then
                player:AddEternalHearts(1)
            end
        end

        -- After first floor
        if not PST:isFirstOrigStage() then
            -- Dark Decay node (Archdemon demonic constellation)
            if PST:getTreeSnapshotMod("archdemonDarkDecay", false) and player:HasCollectible(CollectibleType.COLLECTIBLE_ABADDON) and
            PSTAVessel:GetBlackHeartCount(player) > 6 and math.random() < 0.66 then
                player:AddBlackHearts(-1)
                PST:createFloatTextFX("Dark Decay", Vector.Zero, Color(0.3, 0.3, 0.3, 1), 0.13, 120, true)
                SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
            end
        end
    end

    -- Effect cooldowns
    for modName, CDNum in pairs(PSTAVessel.modCooldowns) do
        if CDNum > 0 then
            PSTAVessel.modCooldowns[modName] = PSTAVessel.modCooldowns[modName] - 1
        end
    end

    -- Eternal heart updates
    if player:GetEternalHearts() ~= PSTAVessel.updateTrackers.eternalHearts then
        -- Mod: +% all stats while you have eternal hearts
        local tmpMod = PST:getTreeSnapshotMod("eternalAllstat", 0)
        if tmpMod > 0 then
            PST:updateCacheDelayed()
        end

        local diff = player:GetEternalHearts() - PSTAVessel.updateTrackers.eternalHearts
        if diff < 0 then
            -- Lost Eternal hearts
            if PSTAVessel.trueEternalHitProc then
                -- True Eternal chance to block hit
                if not PST:getTreeSnapshotMod("trueEternalBlockProc", false) and math.random() < 0.77 then
                    player:AddEternalHearts(1)
                    SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
                    PST:addModifiers({ trueEternalBlockProc = true }, true)
                end
                PSTAVessel.trueEternalHitProc = false
            end
        end

        PSTAVessel.updateTrackers.eternalHearts = player:GetEternalHearts()
    end

    -- First instance of player firing in the room
    if not PSTAVessel.roomFirstFire then
        local plInput = player:GetShootingInput()
		local isShooting = plInput.X ~= 0 or plInput.Y ~= 0
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

    -- Mod: petrification aura
    local tmpMod = PST:getTreeSnapshotMod("petriAura", 0)
    if tmpMod > 0 and (Game():GetFrameCount() % 30) == 0 then
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
end

---@param tear EntityTear
function PSTAVessel:tearUpdate(tear)
    if tear:GetData().swordstormOrbiter then
        local tearAng = math.atan(tear.Velocity.Y, tear.Velocity.X) + 4
        tear:AddVelocity(Vector(-0.25 * math.cos(tearAng), -0.25 * math.sin(tearAng)))
    end
end