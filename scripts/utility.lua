function PSTAVessel:copyTable(dataTable)
	local tmpTable = {}
	if type(dataTable) == "table" then
	  	for k, v in pairs(dataTable) do
			tmpTable[k] = PST:copyTable(v)
		end
	else
	  	tmpTable = dataTable
	end
	return tmpTable
end

function PSTAVessel:getColorStr(col)
    return tostring(PST:roundFloat(255 * (col / 2), 0))
end

function PSTAVessel:postPlayerUpdate(player)
    -- Custom hair color
    if player:GetPlayerType() == PSTAVessel.charType and PSTAVessel.tmpHairSprite then
        PSTAVessel.tmpHairSprite.Color = PSTAVessel.charHairColor
    end
end

function PSTAVessel:arrHasValue(arr, value)
	for _, item in ipairs(arr) do
		if item == value then
			return true
		end
	end
	return false
end

function PSTAVessel:RGBColor(r, g, b, a)
	return Color(r / 255, g / 255, b / 255, a or 1)
end

function PSTAVessel:RGBKColor(r, g, b, a)
	return KColor(r / 255, g / 255, b / 255, a or 1)
end

function PSTAVessel:strStartsWith(txt, start)
	return string.sub(txt, 1, string.len(start)) == start
end

function PSTAVessel:strSplit(str, delimiter)
    local result = {}
    for part in string.gmatch(str, "([^" .. delimiter .. "]+)") do
        table.insert(result, part)
    end
    return result
end

-- Completion events tracking and unlocks
function PSTAVessel:onCompletion(event)
    PSTAVessel.charUnlocks[event] = true
    if Game():IsHardMode() then
        PSTAVessel.charUnlocks[event .. "hard"] = true
    end

    local gameData = Isaac.GetPersistentGameData()
    for achievementName, tmpData in pairs(PSTAVessel.unlocksData) do
        local achievementID = Isaac.GetAchievementIdByName(achievementName)
        if achievementID ~= -1 and not gameData:Unlocked(achievementID) then
            local allUnlocked = true
            for _, tmpUnlock in ipairs(tmpData.reqs) do
                if not PSTAVessel.charUnlocks[tmpUnlock] then
                    allUnlocked = false
                    break
                end
            end
            if allUnlocked then
                gameData:TryUnlock(achievementID)
            end
        end
    end
    PSTAVessel:save()
    PSTAVessel:updateUnlockData()
end

---- Function by TheCatWizard, taken from Modding of Isaac Discord ----
-- Returns the actual amount of black hearts the player has
---@param player EntityPlayer
function PSTAVessel:GetBlackHeartCount(player)
    local black_count = 0
    local soul_hearts = player:GetSoulHearts()
    local black_mask = player:GetBlackHearts()

    for i = 1, soul_hearts do
        local bit = 2 ^ math.floor((i - 1) / 2)
        if black_mask | bit == black_mask then
            black_count = black_count + 1
        end
    end

    return black_count
end

---@param player EntityPlayer
function PSTAVessel:playerHealthType(player)
    if player:GetPlayerType() == PSTAVessel.charType then
        -- Gold-Bound node (Greed mercantile constellation)
        if PST:getTreeSnapshotMod("goldBound", false) then
            return HealthType.COIN
        end
    end
end

---@param pos Vector
---@param radius number
---@param partition EntityPartition
---@return EntityNPC[]
function PSTAVessel:getNearbyEntities(pos, radius, partition)
    local enemList = {}
    local nearbyEnems = Isaac.FindInRadius(pos, radius, partition)
    for _, tmpEnem in ipairs(nearbyEnems) do
        local tmpNPC = tmpEnem:ToNPC()
        if tmpNPC and tmpNPC:IsActiveEnemy(false) and tmpNPC:IsVulnerableEnemy() and not EntityRef(tmpNPC).IsFriendly then
            table.insert(enemList, tmpNPC)
        end
    end
    return enemList
end

---@param pos Vector
---@param radius number
---@return EntityNPC|nil
function PSTAVessel:getClosestEnemy(pos, radius)
    local enemList = PSTAVessel:getNearbyEntities(pos, radius, EntityPartition.ENEMY)
    local closest = nil
    local closestDist = 1000
    for _, tmpEnem in ipairs(enemList) do
        local dist = pos:Distance(tmpEnem.Position)
        if dist < closestDist then
            closest = tmpEnem
            closestDist = dist
        end
    end
    return closest
end