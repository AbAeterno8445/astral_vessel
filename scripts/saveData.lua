local json = require("json")

-- Sanitize consellation tree data
function PSTAVessel:sanitizeTrees()
    for _, tmpType in pairs(PSTAVConstellationType) do
        local tmpTree = "Astral Vessel " .. tmpType
        if PST.modData.treeNodes[tmpTree] then
            local tmpTreeData = { [0] = 0 }
            for k, v in pairs(PST.modData.treeNodes[tmpTree]) do
                if tonumber(k) ~= nil then
                    tmpTreeData[tonumber(k)] = v
                end
            end
            PST.modData.treeNodes[tmpTree] = tmpTreeData
        end
    end
end

-- Save mod data
function PSTAVessel:save()
    PSTAVessel:saveLoadout()
    local modData = {
        version = PSTAVessel.version,
        charUnlocks = PSTAVessel.charUnlocks,
        currentLoadout = PSTAVessel.currentLoadout,
        charLoadouts = PSTAVessel.charLoadouts,
        lastVersion = PSTAVessel.version
    }
    PSTAVessel:SaveData(json.encode(modData))
    PSTAVessel:sanitizeTrees()
end

-- Load mod data
function PSTAVessel:load()
    PSTAVessel:sanitizeTrees()
    -- If Astral Vessel not initialized
    if PST and not PST.modData.charData["Astral Vessel"] then
        return
    end
    local loadData = PSTAVessel:LoadData()
    if #loadData ~= 0 then
        local decoded = json.decode(loadData)
        PSTAVessel.charUnlocks = decoded.charUnlocks or {}
        PSTAVessel.charLoadouts = decoded.charLoadouts
        PSTAVessel:switchLoadout(decoded.currentLoadout)

        PSTAVessel.lastVersion = decoded.lastVersion
    else
        PSTAVessel.charUnlocks = {}
        PSTAVessel.charLoadouts = {}
        PSTAVessel:switchLoadout("1")
    end
    PSTAVessel:updateUnlockData()
    PSTAVessel:calcConstellationAffinities()

    -- Version
	if not PSTAVessel.lastVersion or PSTAVessel.lastVersion ~= PSTAVessel.version then
		PSTAVessel.lastVersion = PSTAVessel.version
		PSTAVessel.isNewVersion = true
	end
end

-- Save variables thrown 'as-is'
local asIsVars = {
    "charAccessories", "charStartItems", "corpseRaiserChoice", "charHurtSFX", "charDeathSFX", "charHurtPitch", "charHurtRandpitch",
    "weaponsmithType"
}

-- Save current settings into the currently selected loadout (PSTAVessel.currentLoadout)
function PSTAVessel:saveLoadout()
    -- 1. Character color (always present)
    local newLoadout = {
        charColor = {PSTAVessel.charColor.R, PSTAVessel.charColor.G, PSTAVessel.charColor.B}
    }
    -- 2. Character hair
    if PSTAVessel.charHair then
        newLoadout.charHair = {path=PSTAVessel.charHair.path}
        if PSTAVessel.charHair.variant then
            newLoadout.charHair.variant = PSTAVessel.charHair.variant
        end
        newLoadout.charHairColor = {PSTAVessel.charHairColor.R, PSTAVessel.charHairColor.G, PSTAVessel.charHairColor.B}
    end
    -- 3. Character face
    if PSTAVessel.charFace then
        newLoadout.charFace = PSTAVessel.charFace.path
    end
    -- 4. Variables thrown 'as-is'
    for _, tmpVar in ipairs(asIsVars) do
        local origVar = PSTAVessel[tmpVar]
        if origVar ~= nil then
            newLoadout[tmpVar] = origVar
        end
    end
    -- 5. Constellation trees & affinities
    newLoadout.constTrees = {}
    newLoadout.constAffinities = {}
    for _, tmpType in pairs(PSTAVConstellationType) do
        if PST.modData.treeNodes["Astral Vessel " .. tmpType] then
            newLoadout.constTrees[tmpType] = PSTAVessel:copyTable(PST.modData.treeNodes["Astral Vessel " .. tmpType])
        end
        newLoadout.constAffinities[tmpType] = PSTAVessel.constelAlloc[tmpType].affinity or 0
    end

    PSTAVessel.charLoadouts[PSTAVessel.currentLoadout] = newLoadout
end

local firstLoadDone = false
-- Switch to the given loadout, loading its data
function PSTAVessel:switchLoadout(loadoutID)
    if type(loadoutID) == "number" then
        loadoutID = tostring(loadoutID)
    end

    PSTAVessel.currentLoadout = loadoutID

    -- Create new loadout with current data if it doesn't exist, or load existing one
    PSTAVessel:initCharData()
    local newLoadout = PSTAVessel.charLoadouts[loadoutID]

    if newLoadout then
        -- 1. Character color
        PSTAVessel.charColor = Color(newLoadout.charColor[1], newLoadout.charColor[2], newLoadout.charColor[3], 1)
        -- 2. Character hair
        if newLoadout.charHair then
            PSTAVessel.charHair = {path=newLoadout.charHair.path}
            if newLoadout.charHair.variant then
                PSTAVessel.charHair.variant = newLoadout.charHair.variant
            end
            PSTAVessel.charHairColor = Color(newLoadout.charHairColor[1], newLoadout.charHairColor[2], newLoadout.charHairColor[3], 1)
        end
        -- 3. Character face
        if newLoadout.charFace then
            PSTAVessel.charFace = {path=newLoadout.charFace}
        end
        -- 4. 'As-is' variables
        for _, tmpVar in ipairs(asIsVars) do
            if newLoadout[tmpVar] ~= nil then
                PSTAVessel[tmpVar] = newLoadout[tmpVar]
            end
        end
    end
    -- 5. Constellation trees
    for _, tmpType in pairs(PSTAVConstellationType) do
        local baseTree = PST.modData.treeNodes["Astral Vessel " .. tmpType]
        if baseTree then
            -- Get how many nodes are allocated for this tree in the current save
            local tmpAllocated = 0
            for _, alloc in pairs(baseTree) do
                if alloc == 1 then
                    tmpAllocated = tmpAllocated + 1
                end
            end
            -- Reset skill points
            local maxSP = PST.modData.charData["Astral Vessel"].level
            PST.modData.charData["Astral Vessel"].skillPoints = math.min(maxSP, PST.modData.charData["Astral Vessel"].skillPoints + tmpAllocated)

            if newLoadout and newLoadout.constTrees and newLoadout.constTrees[tmpType] then
                -- Set base tree to new save
                PST.modData.treeNodes["Astral Vessel " .. tmpType] = PSTAVessel:copyTable(newLoadout.constTrees[tmpType])
                -- Get how many nodes are allocated in new save, and subtract SP accordingly
                tmpAllocated = 0
                for _, alloc in pairs(newLoadout.constTrees[tmpType]) do
                    if alloc == 1 then
                        tmpAllocated = tmpAllocated + 1
                    end
                end
                PST.modData.charData["Astral Vessel"].skillPoints = math.max(0, PST.modData.charData["Astral Vessel"].skillPoints - tmpAllocated)
            else
                -- Reset base tree if no data is loaded
                PST.modData.treeNodes["Astral Vessel " .. tmpType] = {}
            end
        end
        PSTAVessel:sanitizeTrees()
        PST:save()
    end

    ---- Mod data validation ----
    -- Accessories
    for i=#PSTAVessel.charAccessories,1,-1 do
        local accID = PSTAVessel.charAccessories[i]
        if not PSTAVessel.accessoryMap[accID] then
            print("[Astral Vessel] Removed accessory ID", accID, "- no longer mapped.")
            table.remove(PSTAVessel.charAccessories, i)
        end
    end
    -- Starting items
    for i=#PSTAVessel.charStartItems,1,-1 do
        local startItem = PSTAVessel.charStartItems[i]
        if Isaac.GetItemConfig():GetCollectible(startItem.item) == -1 then
            print("[Astral Vessel] Removed starting item ID", startItem.item, "- no longer present.")
            table.remove(PSTAVessel.charStartItems, i)
        end
    end

    PSTAVessel:calcConstellationAffinities()
    if firstLoadDone then
        PSTAVessel:save()
    end

    firstLoadDone = true
end