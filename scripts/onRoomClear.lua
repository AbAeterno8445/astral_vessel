function PSTAVessel:onRoomClear()
    ---@type EntityPlayer
    local player = PST:getPlayer()

    local room = Game():GetRoom()
    local roomType = room:GetType()

    local playerGotHit = PST:getTreeSnapshotMod("roomGotHitByMob", false)

    -- Mod: % chance to spawn a wisp when clearing a room without taking damage
    local tmpMod = PST:getTreeSnapshotMod("vesselWispOnClear", 0)
    if tmpMod > 0 and not playerGotHit and 100 * math.random() < tmpMod then
        player:AddWisp(CollectibleType.COLLECTIBLE_NULL, player.Position)
    end

    -- Mod: % chance to be teleported to the Angel room when clearing a boss room without taking damage
    tmpMod = PST:getTreeSnapshotMod("angelTPOnBoss", 0)
    if player:GetEternalHearts() > 0 then
        tmpMod = tmpMod * 2
    end
    if tmpMod > 0 and roomType == RoomType.ROOM_BOSS and not playerGotHit and 100 * math.random() < tmpMod then
        SFXManager():Play(SoundEffect.SOUND_HELL_PORTAL2)
        Isaac.ExecuteCommand("goto s.angel")
    else
        -- Mod: % chance to be teleported to the Devil room when clearing a boss room without taking damage, while holding the negative. +% chance per black heart
        tmpMod = PST:getTreeSnapshotMod("negativeDevilTP", 0)
        if tmpMod > 0 then
            tmpMod = tmpMod + PSTAVessel:GetBlackHeartCount(player) * 2
        end
        if tmpMod > 0 and player:HasCollectible(CollectibleType.COLLECTIBLE_NEGATIVE) and not playerGotHit and 100 * math.random() < tmpMod then
            SFXManager():Play(SoundEffect.SOUND_HELL_PORTAL2)
            Isaac.ExecuteCommand("goto s.devil")
        end
    end

    -- Mod: clearing room within 5 seconds without taking damage has % chance to spawn a temporary incubus
    tmpMod = PST:getTreeSnapshotMod("roomClearIncubus", 0)
    if tmpMod > 0 and room:GetFrameCount() <= 150 and not playerGotHit and 100 * math.random() < tmpMod then
        if PSTAVessel.modCooldowns.roomClearIncubus == 0 then
            player:AddInnateCollectible(CollectibleType.COLLECTIBLE_INCUBUS)
        end
        PSTAVessel.modCooldowns.roomClearIncubus = 600
    end

    -- Mutagenic Tear node (Abomination mutagenic tree)
    if PSTAVessel.modCooldowns.mutagenicTear > 0 then
        PSTAVessel.modCooldowns.mutagenicTear = 0
    end

    -- Boss room clear
    if roomType == RoomType.ROOM_BOSS then
        -- Mod: boss room soul conversion
        tmpMod = PST:getTreeSnapshotMod("bossClearSoulConv", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local playerSoulHearts = player:GetSoulHearts() - PSTAVessel:GetBlackHeartCount(player)
            if playerSoulHearts < 2 then
                player:AddSoulHearts(2)
                SFXManager():Play(SoundEffect.SOUND_HOLY)
            else
                player:AddSoulHearts(-2)
                player:AddBlackHearts(2)
                SFXManager():Play(SoundEffect.SOUND_UNHOLY)
            end
        end

        -- Mod: % chance to gain Rock Bottom for the current floor when clearing the boss room without taking damage
        tmpMod = PST:getTreeSnapshotMod("sunRockBottomBossClear", 0)
        if tmpMod > 0 and not playerGotHit and not player:HasCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM) and 100 * math.random() < tmpMod then
            player:AddCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM)
            PST:addModifiers({ sunRockBottomProc = true }, true)
        end

        -- Solar Scion node (Sun cosmic constellation)
        if PST:getTreeSnapshotMod("solarScion", false) then
            PST:addModifiers({ solarScionBossDead = true }, true)
        end

        -- Mod: % chance for an additional rotten heart to drop when clearing the boss room without taking damage
        tmpMod = PST:getTreeSnapshotMod("amalgamRottenOnBoss", 0)
        if tmpMod > 0 and not playerGotHit and 100 * math.random() < tmpMod then
            local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN, tmpPos, Vector.Zero, nil)
        end
    -- Challenge room clear
    elseif roomType == RoomType.ROOM_CHALLENGE then
        -- Mod: % chance to spawn a random mushroom item (up to quality 3) when completing a challenge room without getting hit, up to twice per run
        tmpMod = PST:getTreeSnapshotMod("mushOnChallClear", 0)
        if tmpMod > 0 and not playerGotHit and PST:getTreeSnapshotMod("mushOnChallClearProcs", 0) < 2 and 100 * math.random() < tmpMod then
            local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40, true)
            local newItem = Game():GetItemPool():GetCollectibleFromList(PSTAVessel.mushroomItemsQ3)
            if newItem ~= CollectibleType.COLLECTIBLE_BREAKFAST then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, tmpPos, Vector.Zero, nil)
                PST:addModifiers({ mushOnChallClear = 1 }, true)
            end
        end
    end
end