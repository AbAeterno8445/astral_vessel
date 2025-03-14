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
    end

    PSTAVessel:onNewRoom()
    PSTAVessel:save()
end