---@param player EntityPlayer
function PSTAVessel:onUpdateHeartChecks(player)
    -- Eternal heart updates
    local heartDiff = player:GetEternalHearts() - PSTAVessel.updateTrackers.eternalHearts
    if heartDiff ~= 0 then
        -- Mod: +% all stats while you have eternal hearts
        local tmpMod = PST:getTreeSnapshotMod("eternalAllstat", 0)
        if tmpMod > 0 then
            PST:updateCacheDelayed()
        end

        -- Lost Eternal hearts
        if heartDiff < 0 then
            -- True Eternal chance to block hit
            if PSTAVessel.trueEternalHitProc then
                if not PST:getTreeSnapshotMod("trueEternalBlockProc", false) and math.random() < 0.77 then
                    player:AddEternalHearts(1)
                    SFXManager():Play(SoundEffect.SOUND_HOLY_MANTLE)
                    PST:addModifiers({ trueEternalBlockProc = true }, true)
                end
                PSTAVessel.trueEternalHitProc = false
            end

            -- Mod: % chance to gain up to 1/2 lost heart in the room when killing enemies
            tmpMod = PST:getTreeSnapshotMod("daggerHeartOnKill", 0)
            if tmpMod > 0 then
                PST:addModifiers({ daggerHeartOnKill_eternal = true }, true)
            end
        end

        PSTAVessel.updateTrackers.eternalHearts = player:GetEternalHearts()
    end

    -- Red heart updates
    heartDiff = player:GetHearts() - PSTAVessel.updateTrackers.redHearts
    if heartDiff ~= 0 then
        -- Lost red hearts
        if heartDiff < 0 then
            -- Mod: % chance to gain up to 1/2 lost heart in the room when killing enemies
            local tmpMod = PST:getTreeSnapshotMod("daggerHeartOnKill", 0)
            if tmpMod > 0 then
                PST:addModifiers({ daggerHeartOnKill_red = true }, true)
            end
        end
        PSTAVessel.updateTrackers.redHearts = player:GetHearts()
    end

    -- Soul heart updates
    heartDiff = player:GetSoulHearts() - PSTAVessel.updateTrackers.soulHearts
    if heartDiff ~= 0 then
        -- Lost soul hearts
        if heartDiff < 0 then
            -- Mod: % chance to gain up to 1/2 lost heart in the room when killing enemies
            local tmpMod = PST:getTreeSnapshotMod("daggerHeartOnKill", 0)
            if tmpMod > 0 then
                PST:addModifiers({ daggerHeartOnKill_soul = true }, true)
            end
        end
        PSTAVessel.updateTrackers.soulHearts = player:GetSoulHearts()
    end

    -- Black heart updates
    heartDiff = PSTAVessel:GetBlackHeartCount(player) - PSTAVessel.updateTrackers.blackHearts
    if heartDiff ~= 0 then
        -- Lost black hearts
        if heartDiff < 0 then
            -- Mod: % chance to gain up to 1/2 lost heart in the room when killing enemies
            local tmpMod = PST:getTreeSnapshotMod("daggerHeartOnKill", 0)
            if tmpMod > 0 then
                PST:addModifiers({ daggerHeartOnKill_black = true }, true)
            end
        end
        PSTAVessel.updateTrackers.soulHearts = PSTAVessel:GetBlackHeartCount(player)
    end

    -- Rotten heart updates
    heartDiff = player:GetRottenHearts() - PSTAVessel.updateTrackers.rottenHearts
    if heartDiff ~= 0 then
        -- Lost rotten hearts
        if heartDiff < 0 then
            -- Mod: % chance to drop a rotten heart from you when losing rotten hearts, up to twice per room
            local tmpMod = PST:getTreeSnapshotMod("dupeRottenOnHit", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("dupeRottenOnHitProcs", 0) < 2 and 100 * math.random() < tmpMod then
                local newHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, player.Position, RandomVector() * 3, nil)
                newHeart:ToPickup().Wait = 25
                PST:addModifiers({ dupeRottenOnHitProcs = 1 }, true)
            end
        end
        PSTAVessel.updateTrackers.rottenHearts = player:GetRottenHearts()
    end
end