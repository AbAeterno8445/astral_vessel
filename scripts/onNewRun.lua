function PSTAVessel:onNewRun(isContinued)
    local player = Isaac.GetPlayer()
    local isVessel = (player:GetPlayerType() == PSTAVessel.charType)
    PSTAVessel.tmpHairSprite = nil

    if isContinued then
        if isVessel then
            PSTAVessel:updateHairVariant(player)
        end
        return
    end

    if isVessel then
        -- Reset cooldowns (just in case)
        for tmpCooldown, _ in pairs(PSTAVessel.modCooldowns) do
            PSTAVessel.modCooldowns[tmpCooldown] = 0
        end

        -- Apply constellation trees
        for _, tmpType in pairs(PSTAVConstellationType) do
            local tmpTree = "Astral Vessel " .. tmpType
            if PST.trees[tmpTree] then
                for nodeID, node in pairs(PST.trees[tmpTree]) do
                    if PST:isNodeAllocated(tmpTree, nodeID) then
                        PST:addModifiers(node.modifiers, true)
                    end
                end
            end
        end

        local itemPool = Game():GetItemPool()
        local function PSTAVessel_addStartItem(item)
            player:AddCollectible(item)
            itemPool:RemoveCollectible(item)
        end

        -- Starting item loadout
        if #PSTAVessel.charStartItems > 0 then
            for _, startItem in ipairs(PSTAVessel.charStartItems) do
                PSTAVessel_addStartItem(startItem.item)
            end
        end

        PSTAVessel:applyCostumes()

        -- Extra XP unlock
        if PSTAVessel.charXPBonus > 0 then
            PST:addModifiers({ xpbonus = PSTAVessel.charXPBonus }, true)
        end

        -- Starting trinket
        local tmpMod = PST:getTreeSnapshotMod("vesselTrinket", 0)
        if tmpMod > 0 then
            player:AddTrinket(tmpMod, false)
        end

        -- Dark Decay node (Archdemon demonic constellation)
        if PST:getTreeSnapshotMod("archdemonDarkDecay", false) then
            PSTAVessel_addStartItem(CollectibleType.COLLECTIBLE_ABADDON)
        end

        -- Corpse Raiser node (Necromancer occult constellation)
        if PST:getTreeSnapshotMod("corpseRaiser", false) then
            PST:addModifiers({
                corpseRaiserChoice1 = PSTAVessel.corpseRaiserChoice[1],
                corpseRaiserChoice2 = PSTAVessel.corpseRaiserChoice[2],
                corpseRaiserChoice3 = PSTAVessel.corpseRaiserChoice[3]
            }, true)
        end

        -- Teardrop Charm node (God Of Fortune mercantile constellation)
        if PST:getTreeSnapshotMod("teardropCharm", false) then
            player:AddSmeltedTrinket(TrinketType.TRINKET_TEARDROP_CHARM)
        end

        -- Gold-Bound node (Greed mercantile constellation)
        if PST:getTreeSnapshotMod("goldBound", false) then
            player:AddMaxHearts(2)
            player:AddHearts(2)
        end

        -- Smelted Myosotis node (Flower mundane constellation)
        if PST:getTreeSnapshotMod("smeltedMyosotis", false) then
            player:AddSmeltedTrinket(TrinketType.TRINKET_MYOSOTIS)
        end
    end

    PSTAVessel:onNewLevel()
    PSTAVessel:onNewRoom()
    PSTAVessel:save()
end