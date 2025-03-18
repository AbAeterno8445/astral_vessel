---@param pickup EntityPickup
---@param collider Entity
function PSTAVessel:prePickup(pickup, collider, low)
    local player = collider:ToPlayer()
    if player then
        -- Eternal hearts
        if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.SubType == HeartSubType.HEART_ETERNAL then
            -- True Eternal node (Archangel divine constellation)
            if PST:getTreeSnapshotMod("trueEternal", false) and player:GetEternalHearts() > 0 then
                player:AddEternalHearts(-1)
                PST:addModifiers({ trueEternalDmg = 7, damagePerc = 7 }, true)
            end
        end
    end
end

local redHeartVariants = {HeartSubType.HEART_FULL, HeartSubType.HEART_HALF, HeartSubType.HEART_DOUBLEPACK, HeartSubType.HEART_SCARED}
local redHeartWorth = {
    [HeartSubType.HEART_HALF] = 1,
    [HeartSubType.HEART_FULL] = 2,
    [HeartSubType.HEART_SCARED] = 2,
    [HeartSubType.HEART_DOUBLEPACK] = 4
}

---@param pickup EntityPickup
---@param collider Entity
---@param low boolean
---@param forced boolean
function PSTAVessel:onPickup(pickup, collider, low, forced)
    local player = collider:ToPlayer()

    -- Squeeze Blood From Stone node (Baphomet demonic constellation)
    if PST:getTreeSnapshotMod("squeezeBloodStone", false) and pickup.Variant == PickupVariant.PICKUP_HEART and
    PSTAVessel:arrHasValue(redHeartVariants, pickup.SubType) and pickup.Timeout > 0 then
        -- Force vanishing red heart pickup
        if player and player:GetHearts() >= player:GetMaxHearts() then
            pickup:GetSprite():Play("Collect")
            pickup:PlayPickupSound()
            pickup:Die()
            forced = true
        end
    end

    -- Exit if not collecting
    if pickup:GetSprite():GetAnimation() ~= "Collect" and not forced then return end

    if player then
        -- Red heart pickup
        if pickup.Variant == PickupVariant.PICKUP_HEART and PSTAVessel:arrHasValue(redHeartVariants, pickup.SubType) then
            -- Squeeze Blood From Stone node (Baphomet demonic constellation)
            if PST:getTreeSnapshotMod("squeezeBloodStone", false) and pickup.Timeout > 0 then
                local nearbyEnems = Isaac.FindInRadius(player.Position, 150, EntityPartition.ENEMY)
                if #nearbyEnems > 0 then
                    PST:shuffleList(nearbyEnems)
                    for _, tmpEnem in ipairs(nearbyEnems) do
                        local tmpNPC = tmpEnem:ToNPC()
                        if tmpNPC and tmpNPC:IsVulnerableEnemy() and tmpNPC:IsActiveEnemy(false) and not EntityRef(tmpNPC).IsFriendly then
                            local newLaser = player:FireBrimstone((tmpNPC.Position - player.Position):Normalized(), player, 0.9)
                            newLaser:SetScale(0.5)
                            break
                        end
                    end
                end
            end

            -- Mod: % chance to gain a charge with active items when picking up red hearts, doubled if temporary
            local tmpMod = PST:getTreeSnapshotMod("vampHeartCharges", 0)
            if pickup.Timeout > 0 then tmpMod = tmpMod * 2 end
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local tmpWorth = redHeartWorth[pickup.SubType] or 1
                player:AddActiveCharge(tmpWorth, ActiveSlot.SLOT_PRIMARY, true, false, false)
                player:AddActiveCharge(tmpWorth, ActiveSlot.SLOT_POCKET, true, false, false)
            end
        end
    end
end