---@param pickup EntityPickup
---@param player EntityPlayer
---@param spent number
function PSTAVessel:onShopPurchase(pickup, player, spent)
    -- Purchased item
    if spent > 0 then
        -- Mod: % chance to spawn a golden chest when purchasing a pickup item, up to 3x per floor
        local tmpMod = PST:getTreeSnapshotMod("purchaseChest", 0)
        if tmpMod > 0 and pickup.Variant ~= PickupVariant.PICKUP_COLLECTIBLE and PST:getTreeSnapshotMod("purchaseChestProcs", 0) < 3 and
        100 * math.random() < tmpMod then
            local tmpPos = Game():GetRoom():FindFreePickupSpawnPosition(pickup.Position, 20, true)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LOCKEDCHEST, 0, tmpPos, Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
            PST:addModifiers({ purchaseChestProcs = 1 }, true)
        end
    -- Devil deal
    elseif spent < 0 then
        -- Dark Decay node (Archdemon demonic constellation)
        if PST:getTreeSnapshotMod("archdemonDarkDecay", false) and player:HasCollectible(CollectibleType.COLLECTIBLE_ABADDON) and math.random() < 0.33 then
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_ABADDON)
            PST:createFloatTextFX("Dark Decay", Vector.Zero, Color(0.3, 0.3, 0.3, 1), 0.13, 120, true)
            SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
        end
    end
end