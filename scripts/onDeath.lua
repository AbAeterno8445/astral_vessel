-- On entity death
---@param entity Entity
function PSTAVessel:onDeath(entity)
    ---@type EntityPlayer
    local player = PST:getPlayer()

    if entity:IsActiveEnemy(true) and entity.Type ~= EntityType.ENTITY_BLOOD_PUPPY and not EntityRef(entity).IsFriendly and
    PST:getRoom():GetFrameCount() > 1 then
        -- Mom death procs
        if entity.Type == EntityType.ENTITY_MOM then
            PSTAVessel:onCompletion("Mom")
            if Game():IsHardMode() then
                PSTAVessel:onCompletion("Momhard")
            end
        end

        -- Mod: % chance for enemies with at least 10 HP to drop a vanishing 1/2 soul heart on death, if you have less than 4 soul hearts
        local tmpMod = PST:getTreeSnapshotMod("tempSoulOnKill", 0)
        if tmpMod > 0 and entity.MaxHitPoints >= 10 and player:GetSoulHearts() < 8 and 100 * math.random() < tmpMod then
            local newSoulHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF_SOUL, entity.Position, RandomVector() * 3, nil)
            newSoulHeart:ToPickup().Timeout = 90
        end

        -- Squeeze Blood From Stone node (Baphomet demonic constellation)
        if PST:getTreeSnapshotMod("squeezeBloodStone", false) and entity:GetFreezeCountdown() > 0 and math.random() < 0.4 then
            local newHeart = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF, entity.Position, RandomVector() * 3, nil)
            newHeart:ToPickup().Timeout = 90
        end
    end
end