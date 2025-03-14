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
end