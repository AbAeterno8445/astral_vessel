local AVesselMainTree = include("scripts.constellationTrees.mainVesselTreeBank")

local bubbleSpr = Sprite("gfx/ui/astralvessel/selection_bubble.anm2", true)
bubbleSpr.Color.A = 0.8

-- Constellation trees
local constTreeBanks = {
    [PSTAVConstellationType.DIVINE] = include("scripts.constellationTrees.divineTreeBank"),
    [PSTAVConstellationType.DEMONIC] = include("scripts.constellationTrees.demonicTreeBank"),
    [PSTAVConstellationType.OCCULT] = include("scripts.constellationTrees.occultTreeBank"),
    [PSTAVConstellationType.MERCANTILE] = include("scripts.constellationTrees.mercantileTreeBank"),
    [PSTAVConstellationType.ELEMENTAL] = include("scripts.constellationTrees.elementalTreeBank"),
    [PSTAVConstellationType.MUNDANE] = include("scripts.constellationTrees.mundaneTreeBank"),
    [PSTAVConstellationType.MUTAGENIC] = include("scripts.constellationTrees.mutagenicTreeBank"),
    [PSTAVConstellationType.COSMIC] = include("scripts.constellationTrees.cosmicTreeBank")
}

function PSTAVessel:initVesselTree()
    -- Init items
    PSTAVessel:initConstellationItems()

    local vesselNodesSprite = Sprite("gfx/ui/astralvessel/vessel_nodes.anm2", true)
    PST.SkillTreesAPI.InitCustomNodeImage("astralvessel", vesselNodesSprite)

    -- Init main tree
    PST.SkillTreesAPI.AddCharacterTree("Astral Vessel", true, AVesselMainTree)

    -- Info-only nodes
    PST:addPassiveInfoNode("Astral Vessel Unlocks")
    PST:addPassiveInfoNode("Blacksmith Side Weapon")

    -- Constellation node special descriptions
    local function PSTAVessel_constNodeDesc(descName, tmpDescription, isAllocated, tScreen, extraData)
        local reqs = extraData.node.reqs
        if reqs and reqs.vesselConstType then
            local newDesc = {}
            -- Type + Tier
            local constType = reqs.vesselConstType
            local constTier = reqs.vesselConstTier
            local constColor = PSTAVessel.constelKColors[constType]
            table.insert(newDesc, {"Type: " .. constType, constColor})
            table.insert(newDesc, "Tier: " .. PSTAVessel.constelTierNames[constTier])
            -- Allocation affinity
            local constAffinity = PSTAVessel.constelAffinityWorth[constTier]
            local allocPerc = PSTAVessel.charConstAffinityReq * 100
            table.insert(newDesc, "Allocating " .. allocPerc .. "% of this constellation will grant you " .. constAffinity .. " " .. constType .. " Affinity.")
            if isAllocated then
                local constName = string.sub(extraData.node.name, 16)
                local constAllocData = PSTAVessel.constelAlloc[constType][constName]
                if constAllocData then
                    table.insert(newDesc, "Allocated nodes: " .. (constAllocData.alloc or 0) .. "/" .. constAllocData.max)
                    table.insert(newDesc, constType .. " Affinity gained: " .. (constAllocData.affinity or 0) .. "/" .. constAffinity)
                    if constAllocData.cannotAfford then
                        table.insert(newDesc, {"Constellation locked: not enough affinity from lower tier constellations to afford this one!", PST.kcolors.YELLOW1})
                        table.insert(newDesc, {"To re-enable, allocate more nodes in lower tier constellations.", PST.kcolors.YELLOW1})
                        table.insert(newDesc, {"Affinity and nodes from this constellation will not apply while locked.", PST.kcolors.YELLOW1})
                    end
                end
            else
                local affinityReq = PSTAVessel:getConstTierAffinityCost(reqs.vesselConstTier)
                local tmpAllocData = PSTAVessel.constelAlloc[constType]
                if tmpAllocData then
                    -- Affinity check
                    if tmpAllocData.affinity and affinityReq > 0 then
                        local tmpColor = PST.kcolors.LIGHTBLUE1
                        if tmpAllocData.affinity < affinityReq then
                            tmpColor = PST.kcolors.RED1
                        end
                        table.insert(newDesc, {"Requires " .. affinityReq .. " " .. constType .. " Affinity.", tmpColor})
                    end
                    -- Tier allocation limit
                    local tierAllocTotal = PSTAVessel.tiersAlloc[reqs.vesselConstTier]
                    local tmpTotal = PSTAVessel.charMaxConsts[reqs.vesselConstTier]
                    if tierAllocTotal >= tmpTotal then
                        local tmpMsg = "You have allocated your maximum of " .. tmpTotal .. " " .. PSTAVessel.constelTierNames[reqs.vesselConstTier] .. " constellation(s)!"
                        table.insert(newDesc, {tmpMsg, PST.kcolors.RED1})
                    end
                end
            end

            return { name = descName, description = newDesc }
        end
        -- Coalescing soul achievement req
        if reqs and reqs.vesselSoulUnlock then
            local tmpAchievementID = Isaac.GetAchievementIdByName("AVesselSoul")
            if tmpAchievementID ~= -1 and not Isaac.GetPersistentGameData():Unlocked(tmpAchievementID) then
                local newDesc = {table.unpack(tmpDescription)}
                table.insert(newDesc, {"Locked. Requires unlocking the Soul of the Vessel soul stone.", PST.kcolors.RED1})
                return { name = descName, description = newDesc }
            end
        end
        -- Constellation nodes
        local newDesc
        if reqs and reqs.vesselBaseConst then
            newDesc = {table.unpack(tmpDescription)}
            table.insert(newDesc, {"Base constellation: " .. reqs.vesselBaseConst, PST.kcolors.LIGHTBLUE1})

            if isAllocated then
                -- Weaponsmith node, add selected weapon type + PST version warning
                if descName == "Weaponsmith" and isAllocated then
                    local wepData = PST.astralWepData[PSTAVessel.weaponsmithType]
                    if wepData then
                        table.insert(newDesc, {"Selected weapon type: " .. wepData.name, PST.kcolors.ANCIENT_ORANGE})
                    end
                    if not PST.astralWepApplyMods then
                        table.insert(newDesc, {"Warning: PST version 1.2.5+ is required for this node to function properly! PST update required.", PST.kcolors.RED1})
                    end
                end
                for _, tmpType in pairs(PSTAVConstellationType) do
                    local baseConstData = PSTAVessel.constelAlloc[tmpType][reqs.vesselBaseConst]
                    if baseConstData then
                        if baseConstData.cannotAfford then
                            table.insert(newDesc, {"Constellation locked: not enough affinity from lower tier constellations to afford this one!", PST.kcolors.YELLOW1})
                            table.insert(newDesc, {"To re-enable, allocate more nodes in lower tier constellations.", PST.kcolors.YELLOW1})
                            table.insert(newDesc, {"Affinity and nodes from this constellation will not apply while locked.", PST.kcolors.YELLOW1})
                        end
                        break
                    end
                end
            end
        end
        -- Starting trinket node limitation msg
        local mods = extraData.node.modifiers
        if mods and mods.vesselTrinket then
            if not newDesc then
                newDesc = {table.unpack(tmpDescription)}
            end
            if PSTAVessel.charTrinketAlloc then
                table.insert(newDesc, {"You already have a starting trinket node allocated!", PST.kcolors.RED1})
            elseif not PSTAVessel.charTrinketsAllowed then
                table.insert(newDesc, {"Starting Trinket nodes are locked. Check the 'Unlocks' node in the main tree.", PST.kcolors.RED1})
            end
        end
        if newDesc then
            return { name = descName, description = newDesc }
        end
        -- Stellar Nexus notes + starting items display
        if descName == "Stellar Nexus" then
            newDesc = {table.unpack(tmpDescription)}
            table.insert(newDesc, {"Note: Starting items do not count towards transformations.", PST.kcolors.ANCIENT_ORANGE})
            table.insert(newDesc, {"Note: Starting items cannot grant starting pickups (e.g. '+5 bombs' items won't grant bombs).", PST.kcolors.ANCIENT_ORANGE})
            for _, tmpItem in ipairs(PSTAVessel.charStartItems) do
                local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem.item)
                if itemCfg then
                    local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
		            if itemName == "StringTable::InvalidKey" then itemName = itemCfg.Name end

                    local affordExtra = ""
                    local tmpColor = PST.kcolors.LIGHTBLUE1
                    if tmpItem.cannotAfford then
                        affordExtra = " (Cannot afford)"
                        tmpColor = PST.kcolors.RED1
                    end
                    table.insert(newDesc, {"Starting item: " .. itemName .. affordExtra, tmpColor})
                end
            end
            return { name = descName, description = newDesc }
        -- Astral Vessel Unlocks info
        elseif descName == "Astral Vessel Unlocks" then
            newDesc = {}
            local gameData = Isaac.GetPersistentGameData()
            for _, achievementName in ipairs(PSTAVessel.unlocksDisplayOrder) do
                local unlockData = PSTAVessel.unlocksData[achievementName]
                if unlockData then
                    local achievementID = Isaac.GetAchievementIdByName(achievementName)
                    local tmpColor = PST.kcolors.RED1
                    if achievementID ~= -1 and gameData:Unlocked(achievementID) then
                        tmpColor = PST.kcolors.GREEN1
                    end
                    table.insert(newDesc, {unlockData.desc, tmpColor})
                end
            end
            return { name = descName, description = newDesc }
        -- Ingrained Power node requirement
        elseif descName == "Ingrained Power" then
            newDesc = {table.unpack(tmpDescription)}
            if not PSTAVessel.ingrainedUnlock then
                table.insert(newDesc, {"Locked. Check the Unlocks node for more info.", PST.kcolors.RED1})
            end
            return { name = descName, description = newDesc }
        -- Changelog, new version
        elseif descName == "Astral Vessel Changelog" then
            newDesc = {table.unpack(tmpDescription)}
            table.insert(newDesc, "Current version: " .. PSTAVessel.version)
            if PSTAVessel.isNewVersion then
                table.insert(newDesc, {"(New!)", PST.kcolors.LIGHTBLUE1})
            end
            return { name = descName, description = newDesc }
        -- Tonic of Forgetfulness, respec cost calc
        elseif descName == "Tonic Of Forgetfulness" then
            newDesc = {table.unpack(tmpDescription)}
            local tonicTree
            if reqs and reqs.vesselTonic then
                tonicTree = "Astral Vessel " .. reqs.vesselTonic
            end
            if tonicTree then
                local allocNodes = 0
                local tmpTree = PST.trees[tonicTree]
                for nodeID, nodeData in pairs(tmpTree) do
                    if not (nodeData.reqs and nodeData.reqs.noSP) and PST:isNodeAllocated(tonicTree, nodeID) then
                        allocNodes = allocNodes + 1
                    end
                end
                table.insert(newDesc, "Respeccing: " .. reqs.vesselTonic .. " tree.")
                table.insert(newDesc, "Respec cost: " .. allocNodes)
            end
            return { name = descName, description = newDesc }
        -- Blacksmith Side Weapon node, show side weapon data while in run
        elseif descName == "Blacksmith Side Weapon" and Isaac.IsInGame() then
            local wepData = PST:getTreeSnapshotMod("vesselSideWeapon", nil)
            if wepData then
                newDesc = PST:getAstralWepDesc(wepData, PST:isKeybindActive(PSTKeybind.PAN_FASTER, true))
                return { name = descName, description = newDesc }
            end
        end
    end
    PST:addExtraNodeDescFunc("avesselConst", PSTAVessel_constNodeDesc)

    -- Constellation node allocation update callback
    local function PSTAVessel_onConstNodeAlloc(node)
        local reqs = node.reqs
        if reqs and (reqs.vesselBaseConst or reqs.vesselConstType) then
            PSTAVessel:calcConstellationAffinities()
        end
        PSTAVessel:save()
    end
    PST:addNodeAllocCallback("avesselConstNodeAlloc", 2, PSTAVessel_onConstNodeAlloc)

    -- Constellation node special allocation requirements function
    local function PSTAVessel_constNodeReqs(node)
        local reqs = node.reqs
        if reqs then
            if reqs.vesselConstType and reqs.vesselConstTier then
                local affinityReq = PSTAVessel:getConstTierAffinityCost(reqs.vesselConstTier)
                local tierAllocTotal = PSTAVessel.tiersAlloc[reqs.vesselConstTier]
                local tmpAllocData = PSTAVessel.constelAlloc[reqs.vesselConstType]
                if tmpAllocData and tmpAllocData.affinity and tmpAllocData.affinity >= affinityReq and tierAllocTotal < PSTAVessel.charMaxConsts[reqs.vesselConstTier] then
                    return true
                end
                return false
            end
            if reqs.vesselIngrained and not PSTAVessel.ingrainedUnlock then
                return false
            end
            if reqs.vesselSoulUnlock then
                local tmpAchievementID = Isaac.GetAchievementIdByName("AVesselSoul")
                if tmpAchievementID ~= -1 and not Isaac.GetPersistentGameData():Unlocked(tmpAchievementID) then
                    return false
                end
            end
        end
        local mods = node.modifiers
        if mods and mods.vesselTrinket and (PSTAVessel.charTrinketAlloc or not PSTAVessel.charTrinketsAllowed) then
            return false
        end
        return true
    end
    PST:addExtraNodeReqFunc("avesselConstNodeReqs", PSTAVessel_constNodeReqs)

    -- Node extra drawing funcs
    local function PSTAVessel_nodeExtraDrawing(node, x, y, isAllocated)
        -- Constellation nodes, show corresponding affinity
        local z = PST.treeScreen.zoomScale
        if isAllocated then
            for _, tmpType in pairs(PSTAVConstellationType) do
                if node.name == tmpType .. " Constellations" then
                    PST.miniFont:DrawStringScaled(tostring(PSTAVessel.constelAlloc[tmpType].affinity or 0), x + 5 * z, y + 5 * z, z, z, PSTAVessel.constelKColors[tmpType])
                end
                if node.reqs and (node.reqs.vesselBaseConst or node.reqs.vesselConstTier) then
                    local baseConst
                    if node.reqs.vesselBaseConst then
                        baseConst = PSTAVessel.constelAlloc[tmpType][node.reqs.vesselBaseConst]
                    elseif node.reqs.vesselConstTier then
                        local constName = string.sub(node.name, 16)
                        baseConst = PSTAVessel.constelAlloc[tmpType][constName]
                    end
                    if baseConst and baseConst.cannotAfford then
                        if bubbleSpr.Scale.X ~= PST.treeScreen.zoomScale then
                            bubbleSpr.Scale = Vector(PST.treeScreen.zoomScale, PST.treeScreen.zoomScale)
                        end
                        bubbleSpr:SetFrame("Default", 3)
                        bubbleSpr:Render(Vector(x, y))
                    end
                end
            end
        end
        -- Vessel Loadouts node, show loadout ID
        if node.name == "Vessel Loadouts" then
            PST.miniFont:DrawStringScaled(tostring(PSTAVessel.currentLoadout or 1), x + 5 * z, y + 5 * z, z, z, PST.kcolors.WHITE)
        -- Changelog node, show version
        elseif node.name == "Astral Vessel Changelog" then
            PST.miniFont:DrawStringScaled(PSTAVessel.version, x - 7 * z, y + 5 * z, z, z, PST.kcolors.WHITE)

            -- Flash bubble on new version
            if PSTAVessel.isNewVersion then
                if bubbleSpr.Scale.X ~= PST.treeScreen.zoomScale then
                    bubbleSpr.Scale = Vector(PST.treeScreen.zoomScale, PST.treeScreen.zoomScale)
                end
                local alphaFlash = PST.treeScreen.modules.nodeDrawingModule.alphaFlash
                bubbleSpr.Color.A = alphaFlash
                bubbleSpr:SetFrame("Default", 1)
                bubbleSpr:Render(Vector(x, y))
                bubbleSpr.Color.A = 1
            end
        -- Blacksmith Side Weapon node, draw current run weapon
        elseif node.name == "Blacksmith Side Weapon" and Isaac.IsInGame() then
            local wepData = PST:getTreeSnapshotMod("vesselSideWeapon", nil)
            if wepData then
                ---@type Sprite
                local wepSprite = PST.treeScreen.modules.submenusModule.submenus[PSTAVessel.weaponsmithSubmenuID].weaponSprite
                PST:renderAstralWepAt(wepData, wepSprite, x, y, PST.treeScreen.zoomScale)
            end
        end
    end
    PST:addNodeDrawExtraFunc("avesselNodeDraw", PSTAVessel_nodeExtraDrawing)

    -- Node visibility extra funcs
    local function PSTAVessel_nodeVisibility(node)
        -- Blacksmith Side Weapon node, make invisible if no side weapon or not in-game
        if node.name == "Blacksmith Side Weapon" and (not Isaac.IsInGame() or not PST:getTreeSnapshotMod("vesselSideWeapon", nil)) then
            return false
        end
    end
    if PST.addNodeVisibilityExtraFunc then
        PST:addNodeVisibilityExtraFunc("avesselNodeVis", PSTAVessel_nodeVisibility)
    end

    -- Menu-opening nodes
    PST:addMenuNode("Vessel-Shaping", PSTAVessel.AppearanceMenuID)
    PST:addMenuNode("Stellar Nexus", PSTAVessel.NexusMenuID)
    PST:addMenuNode("Astral Vessel Changelog", PSTAVessel.ChangelogMenuID)
    -- Constellation tree nodes
    for _, tmpType in pairs(PSTAVConstellationType) do
        PST:addTreeOpenNode(tmpType .. " Constellations", "Astral Vessel " .. tmpType)
    end
    -- Submenu-opening nodes
    PST:addSubmenuOpenNode("Vessel Loadouts", PSTAVessel.loadoutSubmenuID)
    PST:addSubmenuOpenNode("Corpse Raiser", PSTAVessel.corpseRaiserSubmenuID)
    PST:addSubmenuOpenNode("Weaponsmith", PSTAVessel.weaponsmithSubmenuID)
    PST:addSubmenuOpenNode("Custom Hurt Sound", PSTAVessel.customSFXSubmenuID)

    -- Save when closing PST tree
    PST:addCloseTreeExtraFunc("avesselCloseTree", function()
        PSTAVessel:save()
    end)

    -- Init constellation trees
    for tmpType, treeData in pairs(constTreeBanks) do
        local tmpTreeName = "Astral Vessel " .. tmpType
        PST.SkillTreesAPI.AddCharacterTree(tmpTreeName, true, treeData)
        PST.treeScreen.treeAliases[tmpTreeName] = "Astral Vessel"
        PST.treeScreen.treeNameAliases[tmpTreeName] = "Constellations (" .. tmpType .. ")"
    end
end

-- Re-calculates total affinity for each constellation type. Also remove starting items if no longer affordable from changes in affinity
function PSTAVessel:calcConstellationAffinities()
    PSTAVessel.tiersAlloc = {0, 0, 0}
    PSTAVessel.charTrinketAlloc = false
    for _, tmpType in pairs(PSTAVConstellationType) do
        PSTAVessel.constelAlloc[tmpType] = {}
        local typeAlloc = PSTAVessel.constelAlloc[tmpType]

        -- Setup per-constellation tier and max nodes
        local tmpTreeName = "Astral Vessel " .. tmpType
        local tmpConstTree = PST.trees[tmpTreeName]
        if tmpConstTree then
            for nodeID, node in pairs(tmpConstTree) do
                local reqs = node.reqs
                if reqs then
                    -- Base constellation node, contains the tier
                    if reqs.vesselConstTier then
                        local baseConst = string.sub(node.name, 16)
                        if not typeAlloc[baseConst] then
                            typeAlloc[baseConst] = {}
                        end
                        typeAlloc[baseConst].tier = reqs.vesselConstTier

                        if PST:isNodeAllocated(tmpTreeName, tonumber(nodeID)) then
                            PSTAVessel.tiersAlloc[reqs.vesselConstTier] = PSTAVessel.tiersAlloc[reqs.vesselConstTier] + 1
                        end
                    -- Constellation nodes
                    elseif reqs.vesselBaseConst then
                        local isAllocated = PST:isNodeAllocated(tmpTreeName, tonumber(nodeID))
                        if not (node.modifiers and node.modifiers.vesselTrinket) then
                            local baseConst = node.reqs.vesselBaseConst
                            if not typeAlloc[baseConst] then
                                typeAlloc[baseConst] = {}
                            end
                            if not typeAlloc[baseConst].max then
                                typeAlloc[baseConst].max = 0
                                typeAlloc[baseConst].alloc = 0
                            end
                            typeAlloc[baseConst].max = typeAlloc[baseConst].max + 1

                            if isAllocated then
                                typeAlloc[baseConst].alloc = typeAlloc[baseConst].alloc + 1
                            end
                        elseif isAllocated then
                            PSTAVessel.charTrinketAlloc = true
                        end
                    end
                end
            end

            -- Calculate per-constellation + total affinity for this constellation type
            local totalAffinity = 0
            local function PSTAVessel_getConstellationAff(constData)
                local constReq = constData.max * PSTAVessel.charConstAffinityReq
                local constAffinity = math.min(
                    PSTAVessel.constelAffinityWorth[constData.tier],
                    math.floor((constData.alloc or 0) / constReq * PSTAVessel.constelAffinityWorth[constData.tier])
                )
                if not constData.affinity then
                    constData.affinity = constAffinity
                end
                return constAffinity
            end
            -- Sum Lesser constellations' affinity
            for _, constData in pairs(typeAlloc) do
                if constData.tier and constData.tier == 1 then
                    totalAffinity = totalAffinity + PSTAVessel_getConstellationAff(constData)
                end
            end
            -- Sum greater constellations' affinity, if affordable - tag as unaffordable if not
            for _, constData in pairs(typeAlloc) do
                if constData.tier and constData.tier == 2 then
                    constData.cannotAfford = nil
                    local tmpCost = PSTAVessel:getConstTierAffinityCost(constData.tier)
                    if totalAffinity < tmpCost then
                        constData.cannotAfford = true
                    else
                        totalAffinity = totalAffinity + PSTAVessel_getConstellationAff(constData)
                    end
                end
            end
            -- Sum empyrean constellations' affinity, if affordable - tag as unaffordable if not
            for _, constData in pairs(typeAlloc) do
                if constData.tier and constData.tier == 3 then
                    constData.cannotAfford = nil
                    local tmpCost = PSTAVessel:getConstTierAffinityCost(constData.tier)
                    if totalAffinity < tmpCost then
                        constData.cannotAfford = true
                    else
                        totalAffinity = totalAffinity + PSTAVessel_getConstellationAff(constData)
                    end
                end
            end
            typeAlloc.affinity = totalAffinity
            typeAlloc.spent = 0
        end
    end

    -- Check if starting items are still affordable, and tag as not affordable if not
    local tmpSpent = {}
    for i=#PSTAVessel.charStartItems,1,-1 do
        local startItem = PSTAVessel.charStartItems[i]
        if startItem and startItem.spentType then
            local tmpType = startItem.spentType
            PSTAVessel.charStartItems[i].cannotAfford = nil

            if not tmpSpent[tmpType] then
                tmpSpent[tmpType] = 0
            end
            tmpSpent[tmpType] = tmpSpent[tmpType] + startItem.spent

            local typeAff = PSTAVessel.constelAlloc[tmpType]
            if typeAff and typeAff.affinity and tmpSpent[tmpType] > typeAff.affinity then
                tmpSpent[tmpType] = tmpSpent[tmpType] - startItem.spent
                PSTAVessel.charStartItems[i].cannotAfford = true
            else
                if not PSTAVessel.constelAlloc[tmpType].spent then PSTAVessel.constelAlloc[tmpType].spent = 0 end
                PSTAVessel.constelAlloc[tmpType].spent = PSTAVessel.constelAlloc[tmpType].spent + startItem.spent
            end
        end
    end
end

function PSTAVessel:getConstTierAffinityCost(tier)
    if tier == 1 then return 0 end
    if tier == 2 then return PSTAVessel.constelAffinityWorth[1] end
    return PSTAVessel.constelAffinityWorth[1] + PSTAVessel.constelAffinityWorth[2]
end

function PSTAVessel:charHasStartingItem(itemType)
    for _, tmpItem in ipairs(PSTAVessel.charStartItems) do
        if tmpItem.item == itemType then return true end
    end
    return false
end

function PSTAVessel:charHasStartingActive()
    for _, tmpItem in ipairs(PSTAVessel.charStartItems) do
        if tmpItem.active then return true end
    end
    return false
end

function PSTAVessel:charGetQualStartingQuant(qual)
    local quant = 0
    for _, tmpItem in ipairs(PSTAVessel.charStartItems) do
        if tmpItem.qual == qual then quant = quant + 1 end
    end
    return quant
end