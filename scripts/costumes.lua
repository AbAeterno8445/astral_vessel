function PSTAVessel:applyCostumes(clearOld)
    local player = Isaac.GetPlayer()
    if (player:GetPlayerType() == PSTAVessel.vesselType) then
        if clearOld then player:ClearCostumes() end

        -- Apply custom face
        if PSTAVessel.charFace then
            local faceCostumeID = Isaac.GetCostumeIdByPath(PSTAVessel.charFace.path)
            if faceCostumeID ~= -1 then
                player:AddNullCostume(faceCostumeID)
            end
        end

        -- Apply custom hair
        if PSTAVessel.charHair then
            --local hairCostumeID = Isaac.GetCostumeIdByPath(PSTAVessel.charHair.path)
            local hairCostumeID = Isaac.GetCostumeIdByPath("gfx/characters/hair/astralvessel/hair_vessel.anm2")
            if hairCostumeID ~= -1 then
                player:AddNullCostume(hairCostumeID)
            end
        end

        -- Apply accessories
        if #PSTAVessel.charAccessories > 0 then
            for _, tmpAccID in ipairs(PSTAVessel.charAccessories) do
                local accData = PSTAVessel.accessoryList[tmpAccID]
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
end

local tmpHairSprites = {}
function PSTAVessel:updateHairVariant(player)
    if PSTAVessel.charHair then
        local tmpCostumeID = Isaac.GetItemConfig():GetNullItem(Isaac.GetCostumeIdByPath("gfx/characters/hair/astralvessel/hair_vessel.anm2"))
        if tmpCostumeID then
            local tmpSpriteID = PSTAVessel.charHair.variant or PSTAVessel.charHair.path
            if tmpSpriteID then
                if not tmpHairSprites[tmpSpriteID] then
                    tmpHairSprites[tmpSpriteID] = Sprite(PSTAVessel.charHair.path, true)
                end
                if tmpHairSprites[tmpSpriteID] and tmpHairSprites[tmpSpriteID]:GetLayer(0) then
                    local pngPath = tmpHairSprites[tmpSpriteID]:GetLayer(0):GetSpritesheetPath()
                    if PSTAVessel.charHair.variant then
                        pngPath = PSTAVessel.charHair.variant
                    end
                    player:ReplaceCostumeSprite(tmpCostumeID, pngPath, 0)
                end
            end
        end
    end
end