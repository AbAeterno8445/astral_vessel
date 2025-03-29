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
local coinWorth = {
    [CoinSubType.COIN_PENNY] = 1,
    [CoinSubType.COIN_NICKEL] = 5,
    [CoinSubType.COIN_DIME] = 10,
    [CoinSubType.COIN_DOUBLEPACK] = 2,
    [CoinSubType.COIN_GOLDEN] = 1,
    [CoinSubType.COIN_STICKYNICKEL] = 5,
    [CoinSubType.COIN_LUCKYPENNY] = 1
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
        -- Coin pickup
        elseif pickup.Variant == PickupVariant.PICKUP_COIN then
            -- Penny pickup
            if pickup.SubType == CoinSubType.COIN_PENNY then
                -- Mod: % chance to gain a gold heart when picking up pennies, once per floor
                local tmpMod = PST:getTreeSnapshotMod("goldHeartOnPenny", 0)
                if tmpMod > 0 and not PST:getTreeSnapshotMod("goldHeartOnPennyProc", false) and 100 * math.random() < tmpMod then
                    player:AddGoldenHearts(1)
                    SFXManager():Play(SoundEffect.SOUND_GOLD_HEART, 0.8)
                    PST:addModifiers({ goldHeartOnPennyProc = true }, true)
                end
            end

            -- Mod: % chance to fire a ring of coin tears when picking up coins
            local tmpMod = PST:getTreeSnapshotMod("wealthGodCoinRing", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                for i=1,12 do
                    local tearAng = ((math.pi * 2) / 12) * i
                    local tearVel = Vector(math.cos(tearAng) * 7, math.sin(tearAng) * 7)
                    local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.COIN, 0, pickup.Position, tearVel, player)
                    newTear:ToTear():AddTearFlags(TearFlags.TEAR_GREED_COIN)
                    newTear.CollisionDamage = 1 + math.min(11, player.Damage / 2)

                    if coinWorth[pickup.SubType] then
                        if coinWorth[pickup.SubType] >= 10 then
                            newTear.Color = Color(1, 1, 1, 1, 0.5, 0.5, 0.5)
                            newTear.CollisionDamage = 10 + math.min(20, math.ceil(player.Damage * 1.5))
                        elseif coinWorth[pickup.SubType] >= 5 then
                            newTear.Color = Color(0.1, 0.1, 0.1, 1)
                            newTear.CollisionDamage = 3 + math.min(13, player.Damage)
                        end
                    end
                end
            end
        -- Battery pickup
        elseif pickup.Variant == PickupVariant.PICKUP_LIL_BATTERY then
            -- Mod: +% temporary speed when picking up any battery
            if PST:getTreeSnapshotMod("batterySpeedBuff", 0) > 0 then
                if PSTAVessel.modCooldowns.batterySpeedBuff == 0 then
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                end
                PSTAVessel.modCooldowns.batterySpeedBuff = 450
            end
        -- Poop pickup
        elseif pickup.Variant == PickupVariant.PICKUP_POOP then
            -- Mod: spawn 1-2 associated friendly Dip variants when picking up poop pickups
            local tmpMod = PST:getTreeSnapshotMod("poopPickupOnKill", 0)
            if tmpMod > 0 and (pickup.SubType == PoopPickupSubType.POOP_SMALL or pickup.SubType == PoopPickupSubType.POOP_BIG) then
                local presentDips = #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP)
                if presentDips < 20 then
                    local maxDips = 1
                    local dipWeights = {
                        [DipSubType.NORMAL] = 40,
                        [DipSubType.CORN] = 7,
                        [DipSubType.BROWNIE] = 5,
                        [DipSubType.FLAMING] = 3,
                        [DipSubType.GOLDEN] = 1,
                        [DipSubType.HOLY] = 1,
                        [DipSubType.PETRIFIED] = 4,
                        [DipSubType.POISON] = 3,
                        [DipSubType.RAINBOW] = 2,
                        [DipSubType.RED] = 5
                    }
                    if pickup.SubType == PoopPickupSubType.POOP_BIG then
                        maxDips = 1 + math.random(2)
                        dipWeights[DipSubType.NORMAL] = 10
                    end
                    local totalWeight = 0
                    for _, tmpWeight in pairs(dipWeights) do
                        totalWeight = totalWeight + tmpWeight
                    end

                    for _=1,maxDips do
                        local randWeight = math.random(totalWeight)
                        for dipType, tmpWeight in pairs(dipWeights) do
                            randWeight = randWeight - tmpWeight
                            if randWeight <= 0 then
                                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, dipType, pickup.Position, RandomVector() * 2, player)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

local basePickups = {
    [PickupVariant.PICKUP_COIN] = {CoinSubType.COIN_PENNY, CoinSubType.COIN_DOUBLEPACK},
    [PickupVariant.PICKUP_KEY] = {KeySubType.KEY_NORMAL, KeySubType.KEY_CHARGED, KeySubType.KEY_DOUBLEPACK},
    [PickupVariant.PICKUP_BOMB] = {BombSubType.BOMB_NORMAL, BombSubType.BOMB_DOUBLEPACK}
}

---@param pickup EntityPickup
function PSTAVessel:onPickupInit(pickup, firstSpawn)
    local room = PST:getRoom()
    local isShop = room:GetType() == RoomType.ROOM_SHOP
    local variant = pickup.Variant
    local subtype = pickup.SubType

    local pickupGone = false

    -- First pickup spawn effects
    if firstSpawn then
        -- Mod: % chance to turn basic pickups into sacks
        local tmpMod = PST:getTreeSnapshotMod("pickupSacks", 0)
        if tmpMod > 0 and not isShop and basePickups[variant] and PSTAVessel:arrHasValue(basePickups[variant], subtype) and PST:getTreeSnapshotMod("pickupSacksProcs", 0) < 4 and
        100 * math.random() < tmpMod then
            PST:addModifiers({ pickupSacksProcs = 1 }, true)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, 0, pickup.Position, pickup.Velocity, nil)
            pickup:Remove()
            pickupGone = true
        end

        -- Mod: While you haven't taken damage in the floor, pennies have a chance to spawn as a rarer variant or a gold heart
        tmpMod = PST:getTreeSnapshotMod("wealthGodPennyConv", 0)
        if tmpMod > 0 and not pickupGone and variant == PickupVariant.PICKUP_COIN and subtype == CoinSubType.COIN_PENNY and not PST:getTreeSnapshotMod("floorGotHit", false) and
        not isShop and 100 * math.random() < tmpMod then
            if math.random() < 0.1 then
                pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_GOLDEN)
            else
                local tmpVariants = {
                    {CoinSubType.COIN_LUCKYPENNY, 50},
                    {CoinSubType.COIN_NICKEL, 200},
                    {CoinSubType.COIN_DOUBLEPACK, 100},
                    {CoinSubType.COIN_DIME, 30}
                }
                local totalWeight = 0
                for _, t in ipairs(tmpVariants) do totalWeight = totalWeight + t[2] end

                local randWeight = math.random(totalWeight)
                for _, t in ipairs(tmpVariants) do
                    randWeight = randWeight - t[2]
                    if randWeight <= 0 then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, t[1])
                        break
                    end
                end
            end
        end

        -- Mod: % chance to convert dropped pills into their horse pill version
        tmpMod = PST:getTreeSnapshotMod("horsePillConv", 0)
        if tmpMod > 0 and pickup.Variant == PickupVariant.PICKUP_PILL and 100 * math.random() < tmpMod then
            pickup:Morph(pickup.Type, pickup.Variant, pickup.SubType | PillColor.PILL_GIANT_FLAG, true)
        end

        -- Collectibles
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local itemRerolled = false
            -- Mod: % chance for spawned items to be rerolled into an item from a different pool
            tmpMod = PST:getTreeSnapshotMod("randPoolItems", 0)
            if tmpMod > 0 and not PSTAVessel:arrHasValue(PST.progressionItems, pickup.SubType) and 100 * math.random() < tmpMod then
                local randPool = Game():GetItemPool():GetRandomPool(RNG(math.random(100000)))
                ---@diagnostic disable-next-line: param-type-mismatch
                local newItem = Game():GetItemPool():GetCollectible(randPool)
                pickup:Morph(pickup.Type, pickup.Variant, newItem, true)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
                itemRerolled = true
            end

            -- Mod: % chance to reroll spawned items into a random red item
            tmpMod = PST:getTreeSnapshotMod("redItemConv", 0) / (2 ^ PST:getTreeSnapshotMod("redItemConvProcs", 0))
            if tmpMod > 0 and not itemRerolled and not PSTAVessel:arrHasValue(PST.progressionItems, pickup.SubType) and 100 * math.random() < tmpMod then
                local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_ULTRA_SECRET)
                pickup:Morph(pickup.Type, pickup.Variant, newItem, true)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
                itemRerolled = true
            end
        end
    end
end

---@param pickup EntityPickup
function PSTAVessel:onPickupUpdate(pickup)
    -- Init pickup
    if pickup.FrameCount == 1 then
        ---@type Room
        local room = PST:getRoom()
        local pickupData = PST:getEntData(pickup)
        local isFirstSpawn = not pickupData.PSTAVessel_init and not pickupData.PST_duped and (room:IsFirstVisit() or room:GetFrameCount() > 1)
        PSTAVessel:onPickupInit(pickup, isFirstSpawn)
        pickupData.PSTAVessel_init = true

        pickupData.PST_price = pickup.Price
    end

    -- Shop discounts
    if pickup.Price > 0 and PST:getEntData(pickup).PST_price then
        -- Mod: % chance to reduce all shop prices by 1-4 coins
        local tmpMod = PST:getTreeSnapshotMod("travelMerchShopDiscountProc", 0)
        if tmpMod > 0 then
            pickup.Price = math.max(1, PST:getEntData(pickup).PST_price - tmpMod)
        end
    end

    if pickup.Timeout <= 0 then
        -- Chests
        if PST:isPickupChest(pickup.Variant) then
            local pickupSpr = pickup:GetSprite()
            -- Opened chest
            if pickupSpr:GetAnimation() == "Open" and pickupSpr:GetFrame() == 1 then
                local player = PST:getPlayer()

                -- Mod: % chance for golden chests to return 1 key and 1 coin when opened
                local tmpMod = PST:getTreeSnapshotMod("goldChestReturns", 0)
                if tmpMod > 0 and pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST and 100 * math.random() < tmpMod then
                    player:AddKeys(1)
                    player:AddCoins(1)
                end

                -- Mod: % chance for regular/golden chests to spawn a random Mercantile pool item you don't currently have
                tmpMod = PST:getTreeSnapshotMod("chestsMercantile", 0)
                if PST:getTreeSnapshotMod("chestsMercantileProcs", 0) > 0 then
                    tmpMod = tmpMod / 2
                end
                if tmpMod > 0 and PST:getTreeSnapshotMod("chestsMercantileProcs", 0) < 2 and (pickup.Variant == PickupVariant.PICKUP_LOCKEDCHEST or pickup.Variant == PickupVariant.PICKUP_CHEST) and
                100 * math.random() < tmpMod then
                    local itemPool = Game():GetItemPool()
                    local newItem = itemPool:GetCollectibleFromList(PSTAVessel.constelItemPools[PSTAVConstellationType.MERCANTILE])
                    local failsafe = 0
                    while player:HasCollectible(newItem) and failsafe < 200 do
                        newItem = itemPool:GetCollectibleFromList(PSTAVessel.constelItemPools[PSTAVConstellationType.MERCANTILE])
                        failsafe = failsafe + 1
                    end
                    if failsafe < 200 then
                        local tmpPos = Game():GetRoom():FindFreePickupSpawnPosition(pickup.Position, 20, true)
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, tmpPos, Vector.Zero, nil)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
                        PST:addModifiers({ chestsMercantileProcs = 1 }, true)
                    end
                end
            end
        end
    end
end