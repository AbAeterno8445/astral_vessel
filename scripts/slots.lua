local lastResources = { hearts = 0, coins = 0, keys = 0, bombs = 0 }

function PSTAVessel:preSlotCollision(slot, collider, low)
    local player = collider:ToPlayer()
    if player then
        local playerHearts = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetBoneHearts() + player:GetRottenHearts()
        lastResources.hearts = playerHearts
        lastResources.coins = player:GetNumCoins()
        lastResources.keys = player:GetNumKeys()
        lastResources.bombs = player:GetNumBombs()
    end
end

---@param slot EntitySlot
function PSTAVessel:onSlotUpdate(slot)
    -- Player collided with slot
    if slot:GetTouch() > 0 then
        local player = PST:getPlayer()
        local playerHearts = player:GetHearts() + player:GetSoulHearts() + player:GetEternalHearts() + player:GetBoneHearts() + player:GetRottenHearts()

        local spentCoins = player:GetNumCoins() < lastResources.coins
        local spentHearts = playerHearts < lastResources.hearts
        local spentKeys = player:GetNumKeys() < lastResources.keys
        local spentBombs = player:GetNumBombs() < lastResources.bombs

        -- Shop donation machine
        if slot.Variant == SlotVariant.DONATION_MACHINE and spentCoins then
            -- Mod: % chance for donation machines to grant an additional random non-coin pickup on use
            local tmpMod = PST:getTreeSnapshotMod("donoMachinePickups", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local pickupTypes = {
                    {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}, {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
                    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF}, {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL},
                    {PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MICRO}, {PickupVariant.PICKUP_TRINKET, 0}
                }
                local randPickup = pickupTypes[math.random(#pickupTypes)]
                Isaac.Spawn(EntityType.ENTITY_PICKUP, randPickup[1], randPickup[2], slot.Position, RandomVector() * 3, nil)
            end
        -- Confessional
        elseif slot.Variant == SlotVariant.CONFESSIONAL and spentHearts then
            print("HERE")
            -- Mod: % chance for Confessionals to return a red heart when used
            local tmpMod = PST:getTreeSnapshotMod("confessRedReturn", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, slot.Position, RandomVector() * 3, nil)
            end
        end
    end
end