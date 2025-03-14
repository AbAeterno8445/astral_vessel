---@param itemType CollectibleType
---@param player EntityPlayer
function PSTAVessel:onUseItem(itemType, RNG, player, useFlags, slot, customVarData)
    local itemCfg = Isaac.GetItemConfig():GetCollectible(itemType)
    local isNormalCharge = (itemCfg and itemCfg.ChargeType == 0) or (slot ~= -1 and player:GetActiveMaxCharge(slot) > 0 and player:GetActiveMaxCharge(slot) <= 15)

    --[[if PST:getTreeSnapshotMod("tenetBelial", false) and itemType ~= CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL and isNormalCharge and
    player:GetActiveMaxCharge(slot) >= 4 then]]

    -- Valid slot usage
    if slot ~= -1 then
        -- Mod: % chance when using an active item with at least 2 charges to fire thin brimstone lasers at nearby enemies
        local tmpMod = PST:getTreeSnapshotMod("baphometActiveLaser", 0)
        if tmpMod > 0 and isNormalCharge and player:GetActiveCharge(slot) >= 2 and 100 * math.random() < tmpMod then
            local nearbyEnems = Isaac.FindInRadius(player.Position, 120, EntityPartition.ENEMY)
            if #nearbyEnems > 0 then
                local extraCharges = player:GetActiveCharge(slot) - 2
                for _=1,math.min(#nearbyEnems + 1, extraCharges + 1) do
                    for _, tmpEnem in ipairs(nearbyEnems) do
                        local tmpNPC = tmpEnem:ToNPC()
                        if tmpNPC and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsActiveEnemy(false) and not EntityRef(tmpNPC).IsFriendly then
                            local newLaser = player:FireBrimstone((tmpNPC.Position - player.Position):Normalized(), player, 0.9)
                            newLaser:SetScale(0.5)
                            break
                        end
                    end
                    PST:shuffleList(nearbyEnems)
                end
            end
        end
    end
end