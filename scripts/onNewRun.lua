function PSTAVessel:onNewRun(isContinued)
    Isaac.DebugString("[Astral Vessel] Beginning run init...")
    local player = Isaac.GetPlayer()
    local isVessel = (player:GetPlayerType() == PSTAVessel.vesselType)
    PSTAVessel.tmpHairSprite = nil

    -- Reset temporary trackers/timers
    PSTAVessel.lightlessMawDmg = 0
    PSTAVessel.lightlessMawLuckTears = 0
    PSTAVessel.lightlessMawSpeedRange = 0
    for tmpCooldown, _ in pairs(PSTAVessel.modCooldowns) do
        PSTAVessel.modCooldowns[tmpCooldown] = 0
    end

    if isVessel then
        -- Astral Vessel custom color application
        player:GetSprite().Color = PSTAVessel:getRunVesselColor()
    end

    if isContinued then
        if isVessel then
            PSTAVessel:updateHairAndFace(player)
        end
        return
    end

    local itemPool = Game():GetItemPool()
    -- Starting item addition func
    local function PSTAVessel_addStartItem(item)
        local plPickups = {
            coins = player:GetNumCoins(),
            bombs = player:GetNumBombs(),
            keys = player:GetNumKeys()
        }
        player:AddCollectible(item)
        itemPool:RemoveCollectible(item)
        -- Decrease transformation counters
        for _, tmpForm in pairs(PlayerForm) do
            -- Exception for Guppy with Cat's-Eye Prism Ancient Jewel
            if not (tmpForm == PlayerForm.PLAYERFORM_GUPPY and PST:SC_getSnapshotMod("catseyePrism", false)) then
                player:IncrementPlayerFormCounter(tmpForm, -1)
            end
        end
        -- Return pickups to pre-item addition (prevents +pickup items)
        player:AddCoins(plPickups.coins - player:GetNumCoins())
        player:AddBombs(plPickups.bombs - player:GetNumBombs())
        player:AddKeys(plPickups.keys - player:GetNumKeys())
    end

    if isVessel then
        -- Apply constellation trees
        for _, tmpType in pairs(PSTAVConstellationType) do
            local tmpTree = "Astral Vessel " .. tmpType
            if PST.trees[tmpTree] then
                for nodeID, node in pairs(PST.trees[tmpTree]) do
                    if PST:isNodeAllocated(tmpTree, nodeID) then
                        local applyNode = true
                        -- Check if node's constellation is locked (unaffordable)
                        if node.reqs and node.reqs.vesselBaseConst then
                            local baseConstData = PSTAVessel.constelAlloc[tmpType][node.reqs.vesselBaseConst]
                            if baseConstData and baseConstData.cannotAfford then
                                applyNode = false
                            end
                        end
                        if applyNode then
                            PST:addModifiers(node.modifiers, true)
                        end
                    end
                end
            end
        end

        -- Snapshot loadout data for the run
        local vesselModList = {
            vesselColor = {PSTAVessel.charColor.R, PSTAVessel.charColor.G, PSTAVessel.charColor.B},
            vesselHairColor = {PSTAVessel.charHairColor.R, PSTAVessel.charHairColor.G, PSTAVessel.charHairColor.B},
            vesselHair = PST:copyTable(PSTAVessel.charHair),
            vesselFace = PST:copyTable(PSTAVessel.charFace)
        }
        for _, tmpType in pairs(PSTAVConstellationType) do
            local allocData = PSTAVessel.constelAlloc[tmpType]
            if allocData and allocData.affinity and allocData.affinity > 0 then
                vesselModList["affinity" .. tmpType] = allocData.affinity
            end
        end
        PST:addModifiers(vesselModList, true)

        -- Starting item loadout
        if #PSTAVessel.charStartItems > 0 then
            for _, startItem in ipairs(PSTAVessel.charStartItems) do
                if not startItem.cannotAfford then
                    -- Walking Nullifier node (Voidborn cosmic constellation) - Don't add active items, spawn them as pedestals in first room
                    if PST:getTreeSnapshotMod("walkingNullifier", false) and startItem.active then
                        local tmpPos = Isaac.GetFreeNearPosition(Game():GetRoom():GetCenterPos() + Vector(150, 40), 40)
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, startItem.item, tmpPos, Vector.Zero, nil)
                    else
                        PSTAVessel_addStartItem(startItem.item)
                    end
                end
            end
        end

        PSTAVessel:applyCostumes()
    end

    -- Walking Nullifier node (Voidborn cosmic constellation)
    if PST:getTreeSnapshotMod("walkingNullifier", false) then
        PSTAVessel_addStartItem(CollectibleType.COLLECTIBLE_VOID)
        player:SetActiveCharge(6, ActiveSlot.SLOT_PRIMARY)
    end

    -- Extra XP unlock
    if PSTAVessel.charXPBonus > 0 then
        PST:addModifiers({ xpgain = PSTAVessel.charXPBonus }, true)
    end

    -- Extra Obols
    if PSTAVessel.charObolBonus > 0 then
        PST:addModifiers({ obolsFound = PSTAVessel.charObolBonus }, true)
    end

    -- Starting trinket
    local tmpMod = PST:getTreeSnapshotMod("vesselTrinket", 0)
    if tmpMod > 0 then
        if not PST:getTreeSnapshotMod("ingrainedPower", false) then
            player:AddTrinket(tmpMod, false)
        else
            player:AddSmeltedTrinket(tmpMod, false)
        end
    end

    -- Dark Decay node (Archdemon demonic constellation)
    if PST:getTreeSnapshotMod("archdemonDarkDecay", false) then
        PSTAVessel_addStartItem(CollectibleType.COLLECTIBLE_ABADDON)
    end

    -- Corpse Raiser node (Necromancer occult constellation)
    if PST:getTreeSnapshotMod("corpseRaiser", false) then
        PST:addModifiers({
            corpseRaiserChoice1 = PSTAVessel.corpseRaiserChoice[1],
            corpseRaiserChoice2 = PSTAVessel.corpseRaiserChoice[2],
            corpseRaiserChoice3 = PSTAVessel.corpseRaiserChoice[3]
        }, true)
    end

    -- Teardrop Charm node (God Of Fortune mercantile constellation)
    if PST:getTreeSnapshotMod("teardropCharm", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_TEARDROP_CHARM)
    end

    -- Gold-Bound node (Greed mercantile constellation)
    if PST:getTreeSnapshotMod("goldBound", false) then
        player:AddMaxHearts(2)
        player:AddHearts(2)
    end

    -- Smelted Myosotis node (Flower mundane constellation)
    if PST:getTreeSnapshotMod("smeltedMyosotis", false) then
        player:AddSmeltedTrinket(TrinketType.TRINKET_MYOSOTIS)
    end

    -- Mod: random stat % (+2% per node of this type)
    tmpMod = PST:getTreeSnapshotMod("randomStatPerc", 0)
    if tmpMod > 0 then
        local tmpStatList = {}
        for _=1,tmpMod do
            local randStat = PST:getRandomStat()
            if not tmpStatList[randStat .. "Perc"] then tmpStatList[randStat .. "Perc"] = 0 end
            tmpStatList[randStat .. "Perc"] = tmpStatList[randStat .. "Perc"] + 2
        end
        PST:addModifiers(tmpStatList, true)
    end

    -- Mod: +1% to a random stat per full red heart you have at the beginning
    tmpMod = PST:getTreeSnapshotMod("amalgamHPStat", 0)
    if tmpMod > 0 then
        for _=1,math.floor(player:GetHearts() / 2) do
            local randStat = PST:getRandomStat()
            PST:addModifiers({ [randStat .. "Perc"] = tmpMod }, true)
        end
    end

    -- Mod: % chance to start with an additional coin, key or bomb. Above 100%, roll multiple times
    tmpMod = PST:getTreeSnapshotMod("randPickupStart", 0)
    if tmpMod > 0 then
        while tmpMod > 0 do
            if 100 * math.random() < tmpMod then
                local randPick = math.random(3)
                if randPick == 1 then player:AddCoins(1)
                elseif randPick == 2 then player:AddKeys(1)
                else player:AddBombs(1) end
            end
            tmpMod = tmpMod - 100
        end
    end

    -- Weaponsmith node (Blacksmith mundane constellation)
    if PST:getTreeSnapshotMod("weaponsmith", false) and PST.astralWepApplyMods then
        local wepTier = math.min(5, math.floor(PST.modData.charData["Astral Vessel"].level / 20))
        local newWeapon = PST:createAstralWep(PSTAVessel.weaponsmithType, PSTAstralWepRarity.NORMAL, wepTier)
        PST:addModifiers({ vesselSideWeapon = newWeapon }, true)

        PST:astralWepApplyMods(newWeapon)
    end

    -- The Future compat
    PSTAVessel:initFutureStevenDialogue()

    PSTAVessel:onNewLevel()
    PSTAVessel:onNewRoom()
    PSTAVessel:save()
    Isaac.DebugString("[Astral Vessel] Run init complete.")
end