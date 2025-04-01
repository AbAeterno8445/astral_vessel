local curseIDs = {
    LevelCurse.CURSE_OF_BLIND,
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_LABYRINTH,
    LevelCurse.CURSE_OF_MAZE,
    LevelCurse.CURSE_OF_THE_LOST,
    LevelCurse.CURSE_OF_THE_UNKNOWN
}

function PSTAVessel:onNewLevel()
    if not PST.gameInit then return end

    PSTAVessel.carrionMobs = {}

    ---@type EntityPlayer
    local player = PST:getPlayer()
    local level = Game():GetLevel()

    -- Birthright cache cleanup
    if player:GetPlayerType() == PSTAVessel.vesselType then
        PST.modData.treeModSnapshot.vesselBirthrightCache = {}
    end

    -- Mod: When entering an angel room, % chance to begin the next level with no curses (reset)
    if PST:getTreeSnapshotMod("angelRoomCurseProc", false) then
        PST:addModifiers({ angelRoomCurseProc = false, naturalCurseCleanse = -100 }, true)
    end

    -- True Eternal node (Archangel divine constellation)
    if PST:getTreeSnapshotMod("trueEternal", false) then
        PSTAVessel.trueEternalHitProc = false
        if player:GetEternalHearts() > 0 then
            player:AddEternalHearts(-1)
        end

        local tmpMod = PST:getTreeSnapshotMod("trueEternalDmg", 0)
        if tmpMod > 0 then
            PST:addModifiers({ trueEternalDmg = -tmpMod / 2, damagePerc = -tmpMod / 2 }, true)
        end

        if PST:getTreeSnapshotMod("trueEternalBlockProc", false) then
            PST:addModifiers({ trueEternalBlockProc = false }, true)
        end
    end

    -- Mod: hexer curse buffs
    if PST:getTreeSnapshotMod("hexerCurseBuffBlocks", 0) > 0 then
        PST:addModifiers({ hexerCurseBuffBlocks = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to spawn a Lil Abaddon for the floor when hit
    local tmpMod = PST:getTreeSnapshotMod("lilAbaddonOnHitProcs", 0)
    if tmpMod > 0 then
        for _=1,tmpMod do
            player:RemoveCollectible(CollectibleType.COLLECTIBLE_LIL_ABADDON)
        end
        PST:addModifiers({ lilAbaddonOnHitProcs = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to reduce all shop prices by 1-4 coins
    tmpMod = PST:getTreeSnapshotMod("travelMerchShopDiscount", 0)
    if tmpMod > 0 and 100 * math.random() < tmpMod then
        PST:addModifiers({ travelMerchShopDiscountProc = { value = math.random(4), set = true } }, true)
    elseif PST:getTreeSnapshotMod("travelMerchShopDiscountProc", 0) > 0 then
        PST:addModifiers({ travelMerchShopDiscountProc = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to spawn a golden chest when purchasing an item
    if PST:getTreeSnapshotMod("purchaseChestProcs", 0) > 0 then
        PST:addModifiers({ purchaseChestProcs = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to gain a gold heart when picking up pennies, once per floor
    if PST:getTreeSnapshotMod("goldHeartOnPennyProc", false) then
        PST:addModifiers({ goldHeartOnPennyProc = false }, true)
    end

    -- Mod: +% damage for the current floor when destroying a fireplace
    tmpMod = PST:getTreeSnapshotMod("fireplaceDmgBuff", 0)
    if tmpMod > 0 then
        PST:addModifiers({
            fireplaceDmgBuffTotal = { value = 0, set = true },
            fireplaceDmgBuffProcs = { value = 0, set = true },
            damagePerc = -tmpMod
        }, true)
    end

    -- Mod: % chance for bosses/champions
    if PST:getTreeSnapshotMod("bossChampPillProcs", 0) > 0 then
        PST:addModifiers({ bossChampPillProcs = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to convert rocks to tinted rocks, up to twice per floor
    if PST:getTreeSnapshotMod("tintedRockDiscoverProcs", 0) > 0 then
        PST:addModifiers({ tintedRockDiscoverProcs = { value = 0, set = true } }, true)
    end

    -- Mod: Spacefarer min speed
    if PST:getTreeSnapshotMod("spacefarerMinSpdProc", false) then
        PST:addModifiers({ spacefarerMinSpdProc = false }, true)
        PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
    end

    -- Mod: % chance for champions to drop a cracked key on death
    if PST:getTreeSnapshotMod("champCrackedKeyProcs", 0) > 0 then
        PST:addModifiers({ champCrackedKeyProcs = { value = 0, set = true } }, true)
    end

    -- Mod: +% to a random stat for the current floor when entering red rooms
    if PST:getTreeSnapshotMod("redRoomRandStat", 0) > 0 then
        local statsList = {"damage", "luck", "speed", "tears", "shotSpeed", "range"}
        local tmpModList = {}
        for _, tmpStat in ipairs(statsList) do
            tmpMod = PST:getTreeSnapshotMod("redRoomRandStat" .. tmpStat, 0)
            if tmpMod > 0 then
                tmpModList[tmpStat .. "Perc"] = -tmpMod
                tmpModList["redRoomRandStat" .. tmpStat] = { value = 0, set = true }
            end
        end
        PST:addModifiers(tmpModList, true)
    end

    -- Mod: % chance to replace a level curse with curse of darkness
    tmpMod = PST:getTreeSnapshotMod("singularityDarkCurse", 0)
    if tmpMod > 0 and 100 * math.random() < tmpMod * 15 then
        local lvlCurses = level:GetCurses()
        for _, tmpCurse in ipairs(curseIDs) do
            if tmpCurse ~= LevelCurse.CURSE_OF_DARKNESS then
                if (lvlCurses & tmpCurse) > 0 then
                    level:RemoveCurses(tmpCurse)
                    level:AddCurse(LevelCurse.CURSE_OF_DARKNESS, false)
                    break
                end
            end
        end
    end

    -- Mod: % chance for rocks in secret rooms to be replaced with tinted rocks, up to 3 times per floor
    if PST:getTreeSnapshotMod("secretRoomTintedProcs", 0) > 0 then
        PST:addModifiers({ secretRoomTintedProcs = { value = 0, set = true } }, true)
    end

    -- Lunar Scion node (Moon cosmic constellation)
    if PST:getTreeSnapshotMod("lunarScionExtras", 0) > 0 then
        PST:addModifiers({ lunarScionExtras = { value = 0, set = true } }, true)
    end
    if PSTAVessel.modCooldowns.lunarScion > 0 then
        PSTAVessel.modCooldowns.lunarScion = 0
        PST:addModifiers({ lunarScionStacks = { value = 0, set = true } }, true)
        PST:updateCacheDelayed()
    end

    -- Solar Scion node (Sun cosmic constellation)
    if PST:getTreeSnapshotMod("solarScionBossDead", false) then
        PST:addModifiers({ solarScionBossDead = false }, true)
    end

    -- Mod: % chance to gain Rock Bottom for the current floor when clearing the boss room without taking damage
    if PST:getTreeSnapshotMod("sunRockBottomProc", false) then
        player:RemoveCollectible(CollectibleType.COLLECTIBLE_ROCK_BOTTOM)
        PST:addModifiers({ sunRockBottomProc = false })
    end

    -- Mod: % chance to spawn a friendly fly monster when killing enemies with at least X HP
    if PST:getTreeSnapshotMod("flyFriendProcs", 0) > 0 then
        PST:addModifiers({ flyFriendProcs = { value = 0, set = true } }, true)
    end

    -- Mod: +% stats for the current floor when using a rune
    tmpMod = PST:getTreeSnapshotMod("divinatorRuneBuffApplied", 0)
    if tmpMod > 0 then
        PST:addModifiers({ allstatsPerc = -tmpMod, divinatorRuneBuffApplied = { value = 0, set = true } }, true)
    end

    PSTAVessel.floorFirstUpdate = true
end