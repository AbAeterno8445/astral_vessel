function PSTAVessel:onNewLevel()
    if not PST.gameInit then return end

    ---@type EntityPlayer
    local player = PST:getPlayer()
    local level = Game():GetLevel()

    -- Mod: When entering an angel room, % chance to begin the next level with no curses (reset)
    if PST:getTreeSnapshotMod("angelRoomCurseProc", false) then
        PST:addModifiers({ angelRoomCurseProc = false, naturalCurseCleanse = -100 }, true)
    end

    -- True Eternal node (Archangel divine constellation)
    if PST:getTreeSnapshotMod("trueEternal", false) then
        PSTAVessel.trueEternalHitProc = false
        if player:GetEternalHearts() > 0 then
            player:AddEternalHearts(-1)
        end

        local tmpMod = PST:getTreeSnapshotMod("trueEternalDmg", 0)
        if tmpMod > 0 then
            PST:addModifiers({ trueEternalDmg = -tmpMod / 2, damagePerc = -tmpMod / 2 }, true)
        end

        if PST:getTreeSnapshotMod("trueEternalBlockProc", false) then
            PST:addModifiers({ trueEternalBlockProc = false }, true)
        end
    end

    PSTAVessel.floorFirstUpdate = true
end