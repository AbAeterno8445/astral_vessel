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

local costumeLayers = {"body", "head"}
local extraAnimOldColor = nil
---@param player EntityPlayer
function PSTAVessel:postPlayerUpdate(player)
    if player:GetPlayerType() == PSTAVessel.vesselType then
        -- Astral Vessel custom color application
        local plColor = PSTAVessel:getRunVesselColor()
        if not player:IsExtraAnimationFinished() then
            if not extraAnimOldColor then
                local extraColor = player:GetSprite():GetLayer("extra"):GetColor()
                extraAnimOldColor = Color(extraColor.R, extraColor.G, extraColor.B, extraColor.A, extraColor.RO, extraColor.GO, extraColor.BO)
            end
            player:GetSprite():GetLayer("extra"):SetColor(plColor)
        elseif extraAnimOldColor then
            player:GetSprite():GetLayer("extra"):SetColor(extraAnimOldColor)
            extraAnimOldColor = nil
        end
        for _, tmpCostumeLayer in ipairs(costumeLayers) do
            player:GetSprite():GetLayer(tmpCostumeLayer):SetColor(plColor)
            local costumeSprites = player:GetCostumeSpriteDescs()
            for _, tmpCostumeDesc in ipairs(costumeSprites) do
                local tmpLayer = tmpCostumeDesc:GetSprite():GetLayer(tmpCostumeLayer)
                if tmpLayer then tmpLayer:SetColor(plColor) end
            end
        end

        -- Custom hair color
        if PSTAVessel.tmpHairSprite then
            PSTAVessel.tmpHairSprite.Color = PSTAVessel:getRunVesselHairColor()
            PSTAVessel.tmpHairSprite.Color.A = player:GetSprite().Color.A
        end
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
    if player:GetPlayerType() == PSTAVessel.vesselType then
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
function PSTAVessel:getNearbyNPCs(pos, radius, partition)
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
    local enemList = PSTAVessel:getNearbyNPCs(pos, radius, EntityPartition.ENEMY)
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

---@param player EntityPlayer
function PSTAVessel:getClotSubtypeFromHearts(player)
    local clotWeights = {
        player:GetHearts(),
        player:GetSoulHearts() - PSTAVessel:GetBlackHeartCount(player),
        PSTAVessel:GetBlackHeartCount(player),
        player:GetEternalHearts(),
        player:GetGoldenHearts(),
        player:GetBoneHearts(),
        player:GetRottenHearts()
    }
    local totalWeight = 0
    for _, tmpWeight in ipairs(clotWeights) do
        totalWeight = totalWeight + tmpWeight
    end
    local randWeight = math.random(totalWeight)
    for i, tmpWeight in ipairs(clotWeights) do
        randWeight = randWeight - tmpWeight
        if randWeight <= 0 then
            return i - 1
        end
    end
    return 0
end

function PSTAVessel:getRunVesselColor()
    local tmpColor = PST:getTreeSnapshotMod("vesselColor", {1, 1, 1, 1})
    return Color(table.unpack(tmpColor))
end

function PSTAVessel:getRunVesselHairColor()
    local tmpColor = PST:getTreeSnapshotMod("vesselHairColor", {1, 1, 1, 1})
    return Color(table.unpack(tmpColor))
end

---@param str string
function PSTAVessel:strHash(str)
    if type(str) ~= "string" then str = tostring(str) end
    local hash = 0
    for i = 1, #str do
        hash = (hash * 31 + str:byte(i)) % 0x7FFFFFFF
    end
    return hash
end