local AVesselTree = [[
{
"11": "{\"pos\":[-1,-2],\"type\":5055,\"size\":\"Large\",\"name\":\"Divine Constellations\",\"description\":[\"Once allocated, press Allocate to access the Divine Constellations tree.\",\"This tree contains nodes that grant holy themed powers.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"13": "{\"pos\":[-2,-1],\"type\":5061,\"size\":\"Large\",\"name\":\"Cosmic Constellations\",\"description\":[\"Once allocated, press Allocate to access the Cosmic Constellations tree.\",\"This tree contains nodes that grant space/zodiac themed powers.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"14": "{\"pos\":[-2,1],\"type\":5060,\"size\":\"Large\",\"name\":\"Mundane Constellations\",\"description\":[\"Once allocated, press Allocate to access the Mundane Constellations tree.\",\"This tree contains nodes that grant regular/everyday themed powers.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"15": "{\"pos\":[-1,2],\"type\":5059,\"size\":\"Large\",\"name\":\"Elemental Constellations\",\"description\":[\"Once allocated, press Allocate to access the Elemental Constellations tree.\",\"This tree contains nodes that grant elemental/status effect themed powers.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"16": "{\"pos\":[1,2],\"type\":5057,\"size\":\"Large\",\"name\":\"Occult Constellations\",\"description\":[\"Once allocated, press Allocate to access the Occult Constellations tree.\",\"This tree contains nodes that grant occult/undead themed powers.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"17": "{\"pos\":[2,1],\"type\":5056,\"size\":\"Large\",\"name\":\"Demonic Constellations\",\"description\":[\"Once allocated, press Allocate to access the Demonic Constellations tree.\",\"This tree contains nodes that grant demon/evil themed powers.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"20": "{\"pos\":[1,-2],\"type\":5058,\"size\":\"Large\",\"name\":\"Mercantile Constellations\",\"description\":[\"Once allocated, press Allocate to access the Mercantile Constellations tree.\",\"This tree contains nodes that grant wealth/luck themed powers.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"23": "{\"pos\":[0,-4],\"type\":5000,\"size\":\"Large\",\"name\":\"Vessel-Shaping\",\"description\":[\"Once allocated, press Allocate to access a menu that allows customizing\",\"Astral Vessel's appearance.\"],\"modifiers\":{},\"adjacent\":[],\"reqs\":{\"noSP\":true},\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"25": "{\"pos\":[0,-3],\"type\":5063,\"size\":\"Large\",\"name\":\"Astral Vessel Unlocks\",\"description\":[\"\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"26": "{\"pos\":[0,-5],\"type\":5001,\"size\":\"Large\",\"name\":\"Vessel Loadouts\",\"description\":[\"Once allocated, press Allocate to open a menu that allows you to switch between different\",\"loadouts.\",\"Loadouts store your customization, constellation and starting item settings.\"],\"modifiers\":{},\"adjacent\":[],\"reqs\":{\"noSP\":true},\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}",
"27": "{\"pos\":[0,0],\"type\":5002,\"size\":\"Large\",\"name\":\"Stellar Nexus\",\"description\":[\"Once allocated, press Allocate to open a menu that allows you to pick your starting items.\",\"Items are divided into categories matching constellation types, and require affinity with\",\"those constellations to choose.\"],\"modifiers\":{},\"adjacent\":[],\"alwaysAvailable\":true,\"customID\":\"astralvessel\",\"reqs\":{}}",
"28": "{\"pos\":[0,4],\"type\":5238,\"size\":\"Large\",\"name\":\"Ingrained Power\",\"description\":[\"When beginning a run, smelt your starting trinket, if you have one.\"],\"modifiers\":{\"ingrainedPower\":true},\"adjacent\":[],\"reqs\":{\"vesselIngrained\":true},\"alwaysAvailable\":true,\"customID\":\"astralvessel\"}"
}
]]

-- Constellation trees
local constTreeBanks = {
    [PSTAVConstellationType.DIVINE] = include("scripts.constellationTrees.divineTreeBank"),
    [PSTAVConstellationType.DEMONIC] = include("scripts.constellationTrees.demonicTreeBank"),
    [PSTAVConstellationType.OCCULT] = include("scripts.constellationTrees.occultTreeBank"),
    [PSTAVConstellationType.MERCANTILE] = include("scripts.constellationTrees.mercantileTreeBank"),
    [PSTAVConstellationType.ELEMENTAL] = include("scripts.constellationTrees.elementalTreeBank"),
    [PSTAVConstellationType.MUNDANE] = include("scripts.constellationTrees.mundaneTreeBank"),
    --[PSTAVConstellationType.MUTAGENIC] = include("scripts.constellationTrees.mutagenicTreeBank"),
    [PSTAVConstellationType.COSMIC] = include("scripts.constellationTrees.cosmicTreeBank")
}

function PSTAVessel:initVesselTree()
    -- Init items
    PSTAVessel:initConstellationItems()

    local vesselNodesSprite = Sprite("gfx/ui/astralvessel/vessel_nodes.anm2", true)
    PST.SkillTreesAPI.InitCustomNodeImage("astralvessel", vesselNodesSprite)

    -- Init main tree
    PST.SkillTreesAPI.AddCharacterTree("Astral Vessel", true, AVesselTree)

    -- Info-only nodes
    PST:addPassiveInfoNode("Astral Vessel Unlocks")

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
                end
            else
                local affinityReq = PSTAVessel:getConstellationAffinityCost(reqs.vesselConstTier)
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
        -- Starting trinket node limitation msg
        local mods = extraData.node.mods
        if mods and mods.vesselTrinket then
            local newDesc = {table.unpack(tmpDescription)}
            if PSTAVessel.charTrinketAlloc then
                table.insert(newDesc, {"You already have a starting trinket node allocated!", PST.kcolors.RED1})
            elseif not PSTAVessel.charTrinketsAllowed then
                table.insert(newDesc, {"Starting Trinket nodes are locked. Check the 'Unlocks' node in the main tree.", PST.kcolors.RED1})
            end

            return { name = descName, description = newDesc}
        end
        -- Stellar Nexus starting items display
        if descName == "Stellar Nexus" then
            local newDesc = {table.unpack(tmpDescription)}
            for _, tmpItem in ipairs(PSTAVessel.charStartItems) do
                local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem.item)
                if itemCfg then
                    local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
		            if itemName == "StringTable::InvalidKey" then itemName = "Unknown Item" end

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
            local newDesc = {}
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
            local newDesc = {table.unpack(tmpDescription)}
            if not PSTAVessel.ingrainedUnlock then
                table.insert(newDesc, {"Locked. Check the Unlocks node for more info.", PST.kcolors.RED1})
            end
            return { name = descName, description = newDesc }
        end
    end
    PST:addExtraNodeDescFunc("avesselConst", PSTAVessel_constNodeDesc)

    -- Constellation node allocation update callback
    local function PSTAVessel_onConstNodeAlloc(node)
        local reqs = node.reqs
        if reqs and reqs.vesselBaseConst then
            PSTAVessel:calcConstellationAffinities()
        end
    end
    PST:addNodeAllocCallback("avesselConstNodeAlloc", 2, PSTAVessel_onConstNodeAlloc)

    -- Constellation node special allocation requirements function
    local function PSTAVessel_constNodeReqs(node)
        local reqs = node.reqs
        if reqs then
            if reqs.vesselConstType and reqs.vesselConstTier and reqs.vesselConstTier > 1 then
                local affinityReq = PSTAVessel:getConstellationAffinityCost(reqs.vesselConstTier)
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
        end
        local mods = node.mods
        if mods and mods.vesselTrinket and (PSTAVessel.charTrinketAlloc or not PSTAVessel.charTrinketsAllowed) then
            return false
        end
        return true
    end
    PST:addExtraNodeReqFunc("avesselConstNodeReqs", PSTAVessel_constNodeReqs)

    -- Menu-opening nodes
    PST:addMenuNode("Vessel-Shaping", PSTAVessel.AppearanceMenuID)
    PST:addMenuNode("Stellar Nexus", PSTAVessel.NexusMenuID)
    -- Constellation tree nodes
    for _, tmpType in pairs(PSTAVConstellationType) do
        PST:addTreeOpenNode(tmpType .. " Constellations", "Astral Vessel " .. tmpType)
    end
    -- Submenu-opening nodes
    PST:addSubmenuOpenNode("Vessel Loadouts", PSTAVessel.loadoutSubmenuID)
    PST:addSubmenuOpenNode("Corpse Raiser", PSTAVessel.corpseRaiserSubmenuID)

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
                    elseif reqs.vesselBaseConst and not (node.modifiers and node.modifiers.vesselTrinket) then
                        local baseConst = node.reqs.vesselBaseConst
                        if not typeAlloc[baseConst] then
                            typeAlloc[baseConst] = {}
                        end
                        if not typeAlloc[baseConst].max then
                            typeAlloc[baseConst].max = 0
                            typeAlloc[baseConst].alloc = 0
                        end
                        typeAlloc[baseConst].max = typeAlloc[baseConst].max + 1

                        if PST:isNodeAllocated(tmpTreeName, tonumber(nodeID)) then
                            typeAlloc[baseConst].alloc = typeAlloc[baseConst].alloc + 1

                            if PSTAVessel:strStartsWith(node.name, "Starting Trinket:") then
                                PSTAVessel.charTrinketAlloc = true
                            end
                        end
                    end
                end
            end

            -- Calculate per-constellation + total affinity for this constellation type
            local tmpAffinity = 0
            for _, constData in pairs(typeAlloc) do
                if constData.alloc and constData.tier then
                    local constReq = constData.max * PSTAVessel.charConstAffinityReq
                    local constAffinity = math.min(
                        PSTAVessel.constelAffinityWorth[constData.tier],
                        math.floor(constData.alloc / constReq * PSTAVessel.constelAffinityWorth[constData.tier])
                    )
                    if not constData.affinity then
                        constData.affinity = constAffinity
                    end
                    tmpAffinity = tmpAffinity + constAffinity
                end
            end
            typeAlloc.affinity = tmpAffinity
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

function PSTAVessel:getConstellationAffinityCost(tier)
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