function PSTAVessel:onNewLevel()
    if not PST.gameInit then return end

    PSTAVessel.carrionMobs = {}

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

    -- Mod: hexer curse buffs
    if PST:getTreeSnapshotMod("hexerCurseBuffBlocks", 0) > 0 then
        PST:addModifiers({ hexerCurseBuffBlocks = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to spawn a Lil Abaddon for the floor when hit
    local tmpMod = PST:getTreeSnapshotMod("lilAbaddonOnHitProcs", 0)
    if tmpMod > 0 then
        for _=1,tmpMod do
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_LIL_ABADDON)
        end
        PST:addModifiers({ lilAbaddonOnHitProcs = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to reduce all shop prices by 1-4 coins
    tmpMod = PST:getTreeSnapshotMod("travelMerchShopDiscount", 0)
    if tmpMod > 0 and 100 * math.random() < tmpMod then
        PST:addModifiers({ travelMerchShopDiscountProc = { value = math.random(4), set = true } }, true)
    elseif PST:getTreeSnapshotMod("travelMerchShopDiscountProc", 0) > 0 then
        PST:addModifiers({ travelMerchShopDiscountProc = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to spawn a golden chest when purchasing an item
    if PST:getTreeSnapshotMod("purchaseChestProcs", 0) > 0 then
        PST:addModifiers({ purchaseChestProcs = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to gain a gold heart when picking up pennies, once per floor
    if PST:getTreeSnapshotMod("goldHeartOnPennyProc", false) then
        PST:addModifiers({ goldHeartOnPennyProc = false }, true)
    end

    -- Mod: +% damage for the current floor when destroying a fireplace
    tmpMod = PST:getTreeSnapshotMod("fireplaceDmgBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({
            fireplaceDmgBuffTotal = { value = 0, set = true },
            fireplaceDmgBuffProcs = { value = 0, set = true },
            damagePerc = -tmpMod
        }, true)
    end

    PSTAVessel.floorFirstUpdate = true
end