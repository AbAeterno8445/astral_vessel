---@param pickup EntityPickup
---@param player EntityPlayer
---@param spent number
function PSTAVessel:onShopPurchase(pickup, player, spent)
    -- Purchased item
    if spent > 0 then

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