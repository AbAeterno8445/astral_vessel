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

    -- Mod: % chance to drop an additional coin, key or bomb when clearing a room without taking damage
    tmpMod = PST:getTreeSnapshotMod("vesselSelfPickupDrops", 0) / (2 ^ PST:getTreeSnapshotMod("floorHitsReceived", 0))
    if tmpMod > 0 and not playerGotHit and 100 * math.random() < tmpMod then
        local randPicks = {
            {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
            {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
            {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
        }
        local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true)
        local newPick = randPicks[math.random(#randPicks)]
        Isaac.Spawn(EntityType.ENTITY_PICKUP, newPick[1], newPick[2], tmpPos, Vector.Zero, nil)
    end

    -- Mod: % chance for the side weapon to gain 1 honing when completing rooms without taking damage past the first floor
    tmpMod = PST:getTreeSnapshotMod("sideWepClearHoning", 0)
    if tmpMod > 0 and not playerGotHit and not PST:isFirstOrigStage() and 100 * math.random() < tmpMod then
        local wepData = PST:getTreeSnapshotMod("vesselSideWeapon", nil)
        if wepData then
            PST:astralWepForgeHone(wepData)
            PST:astralWepApplyMods(wepData, false)
            PST:createFloatTextFX("+1 side weapon honing", Vector.Zero, Color(), 0.13, 100, true)
        end
    end

    -- Mod: % chance to gain an additional gold heart when completing a room without taking damage, if you don't currently have one
    tmpMod = PST:getTreeSnapshotMod("goldHeartOnRoomComp", 0)
    if tmpMod > 0 and not playerGotHit and player:GetGoldenHearts() == 0 and 100 * math.random() < tmpMod then
        player:AddGoldenHearts(1)
        SFXManager():Play(SoundEffect.SOUND_GOLD_HEART, 0.8)
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

        -- Mod: clearing a challenge room will upgrade the side weapon from normal to magic (1mod), or from magic with 1 mod to 2 mods
        if PST:getTreeSnapshotMod("challengeSideWepUpgrade", false) then
            local wepData = PST:getTreeSnapshotMod("vesselSideWeapon", nil)
            if wepData then
                if PST:astralWepForgeTransmute(wepData) then
                    SFXManager():Play(PSTAVessel.SFXSmithy, 1, 20, false, 0.85 + 0.3 * math.random())
                    PST:createFloatTextFX("Side weapon upgraded to Magic!", Vector.Zero, Color(0.4, 0.5, 1), 0.1, 150, true)
                elseif PST:astralWepForgeAdd(wepData) then
                    SFXManager():Play(PSTAVessel.SFXSmithy, 1, 20, false, 0.85 + 0.3 * math.random())
                    PST:createFloatTextFX("Added modifier to side weapon!", Vector.Zero, Color(0.6, 0.7, 1), 0.1, 150, true)
                end
                PST:astralWepApplyMods(wepData)
            end
        end
    end
end