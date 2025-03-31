function PSTAVessel:applyCostumes(clearOld)
    local player = Isaac.GetPlayer()
    if (player:GetPlayerType() == PSTAVessel.vesselType) then
        if clearOld then player:ClearCostumes() end

        -- Apply custom face
        if PSTAVessel.charFace then
            local faceCostumeID = Isaac.GetCostumeIdByPath(PSTAVessel.baseFaceCostumePath)
            for _, tmpFaceEntry in ipairs(PSTAVessel.facesList) do
                if tmpFaceEntry.path == PSTAVessel.charFace.path and tmpFaceEntry.baseSprite then
                    faceCostumeID = Isaac.GetCostumeIdByPath(tmpFaceEntry.baseSprite)
                    break
                end
            end
            if faceCostumeID ~= -1 then
                player:AddNullCostume(faceCostumeID)
            end
        end

        -- Apply custom hair
        if PSTAVessel.charHair then
            local hairCostumeID = Isaac.GetCostumeIdByPath(PSTAVessel.baseHairCostumePath)
            if hairCostumeID ~= -1 then
                player:AddNullCostume(hairCostumeID)
            end
        end

        -- Apply accessories
        for _, accID in ipairs(PSTAVessel.charAccessories) do
            local accData = PSTAVessel.accessoryMap[accID]
            if accData then
                if accData.path then
                    local costID = Isaac.GetCostumeIdByPath(accData.path)
                    if costID ~= -1 then
                        player:AddNullCostume(costID)
                    end
                elseif accData.item then
                    local itemCfg = Isaac.GetItemConfig():GetCollectible(accData.item)
                    if itemCfg then
                        player:AddCostume(itemCfg)
                    end
                end
            end
        end
    end
end

local tmpSpriteCache = {}
function PSTAVessel:updateHairAndFace(player)
    local charHair = PST:getTreeSnapshotMod("vesselHair", nil)
    if charHair then
        local tmpCostumeID = Isaac.GetItemConfig():GetNullItem(Isaac.GetCostumeIdByPath(PSTAVessel.baseHairCostumePath))
        if tmpCostumeID then
            local tmpSpriteID = charHair.variant or charHair.path
            if tmpSpriteID then
                if not tmpSpriteCache[tmpSpriteID] then
                    tmpSpriteCache[tmpSpriteID] = Sprite(charHair.path, true)
                end
                if tmpSpriteCache[tmpSpriteID] and tmpSpriteCache[tmpSpriteID]:GetLayer(0) then
                    local pngPath = tmpSpriteCache[tmpSpriteID]:GetLayer(0):GetSpritesheetPath()
                    if charHair.variant then
                        pngPath = charHair.variant
                    end
                    player:ReplaceCostumeSprite(tmpCostumeID, pngPath, 0)
                end
            end
        end
    end

    local charFace = PST:getTreeSnapshotMod("vesselFace", nil)
    if charFace then
        local tmpCostumeID = Isaac.GetItemConfig():GetNullItem(Isaac.GetCostumeIdByPath(PSTAVessel.baseFaceCostumePath))
        for _, tmpFaceEntry in ipairs(PSTAVessel.facesList) do
            if tmpFaceEntry.path == PSTAVessel.charFace.path and tmpFaceEntry.baseSprite then
                tmpCostumeID = Isaac.GetItemConfig():GetNullItem(Isaac.GetCostumeIdByPath(tmpFaceEntry.baseSprite))
                break
            end
        end
        if tmpCostumeID then
            local tmpSpriteID = charFace.path
            if tmpSpriteID then
                if not tmpSpriteCache[tmpSpriteID] then
                    tmpSpriteCache[tmpSpriteID] = Sprite(charFace.path, true)
                end
                if tmpSpriteCache[tmpSpriteID] and tmpSpriteCache[tmpSpriteID]:GetLayer(0) then
                    local pngPath = tmpSpriteCache[tmpSpriteID]:GetLayer(0):GetSpritesheetPath()
                    player:ReplaceCostumeSprite(tmpCostumeID, pngPath, 0)
                end
            end
        end
    end
end