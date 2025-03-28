local function tearsUp(firedelay, newValue)
    local newTears = 30 / (firedelay + 1) + newValue
    return math.max((30 / newTears) - 1, -0.75)
end

-- Player cache updates
---@param player EntityPlayer
---@param cacheFlag CacheFlag
function PSTAVessel:onCache(player, cacheFlag)
    -- Skip non-stat related cache update
    if (cacheFlag & PST.allstatsCache) == 0 then return end

    local tmpMod
    local dynamicMods = {
        damage = 0, luck = 0, speed = 0, tears = 0, shotSpeed = 0, range = 0,
        damagePerc = 0, luckPerc = 0, speedPerc = 0, tearsPerc = 0, shotSpeedPerc = 0, rangePerc = 0,
        allstatsPerc = 0, allstats = 0
    }

    -- DAMAGE CACHE
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        -- Mod: +% damage per devil item you have
        tmpMod = PST:getTreeSnapshotMod("devilItemDmg", 0)
        if tmpMod > 0 then
            local itemPool = Game():GetItemPool()
            local devilItems = 0
            for _, itemData in pairs(itemPool:GetCollectiblesFromPool(ItemPoolType.POOL_DEVIL)) do
                devilItems = devilItems + player:GetCollectibleNum(itemData.itemID, true)
            end
            dynamicMods.damagePerc = dynamicMods.damagePerc + tmpMod * devilItems
        end

        -- Mod: +% damage per knife item you have
        tmpMod = PST:getTreeSnapshotMod("knifeItemsDmg", 0)
        if tmpMod > 0 then
            local itemQ = 0
            for _, tmpKnifeItem in ipairs(PSTAVessel.knifeItems) do
                itemQ = itemQ + player:GetCollectibleNum(tmpKnifeItem, true)
            end
            dynamicMods.damagePerc = dynamicMods.damagePerc + tmpMod * itemQ
        end

        -- Mod: +% damage until you kill a monster in the room
        tmpMod = PST:getTreeSnapshotMod("dmgUntilKill", 0)
        if PST:getTreeSnapshotMod("dmgUntilKillProc", false) then
            tmpMod = tmpMod * math.max(0, PSTAVessel.modCooldowns.dmgUntilKill / 150)
        end
        if tmpMod > 0 then
            dynamicMods.damagePerc = dynamicMods.damagePerc + tmpMod
        end

        -- Mod: +% damage per charge on your current active item
        tmpMod = PST:getTreeSnapshotMod("activeChargeDmg", 0)
        if tmpMod > 0 then
            local currentCharges = player:GetTotalActiveCharge(ActiveSlot.SLOT_PRIMARY)
            if currentCharges and currentCharges > 0 then
                dynamicMods.damagePerc = dynamicMods.damagePerc + tmpMod * currentCharges
            end
        end

        -- Solar Scion node (Sun cosmic constellation) - Fire ring buff
        if PSTAVessel.inSolarFireRing then
            local tmpBonus = 20
            if PST:getTreeSnapshotMod("solarScionBossDead", false) then
                tmpBonus = 30
            end
            dynamicMods.damagePerc = dynamicMods.damagePerc + tmpBonus
        end
    -- TEARS CACHE
    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- Mod: +% tears per angel item you have
        tmpMod = PST:getTreeSnapshotMod("angelItemTears", 0)
        if tmpMod > 0 then
            local itemPool = Game():GetItemPool()
            local angelItems = 0
            for _, itemData in pairs(itemPool:GetCollectiblesFromPool(ItemPoolType.POOL_ANGEL)) do
                angelItems = angelItems + player:GetCollectibleNum(itemData.itemID, true)
            end
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpMod * angelItems
        end

        -- Mod: +% tears whenever a friendly undead monster is summoned
        tmpMod = PST:getTreeSnapshotMod("undeadSummonTears", 0)
        if tmpMod > 0 and PSTAVessel.modCooldowns.undeadSummonTears > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpMod
        end

        -- Mod: +% speed and tears when killing poisoned enemies
        tmpMod = PST:getTreeSnapshotMod("poisonVialKillBuff", 0)
        if tmpMod > 0 and PSTAVessel.modCooldowns.poisonVialKillBuff > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpMod
        end

        -- Mod: destroying frozen enemies grants you a tears buff
        if PST:getTreeSnapshotMod("frozenMobTearBuff", false) and PSTAVessel.modCooldowns.frozenMobTearBuff > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + 12
        end
    -- SPEED CACHE
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        -- Mod: +% speed for 3 seconds after killing an enemy. Stacks up to 5 times
        tmpMod = PST:getTreeSnapshotMod("tempSpeedOnKill", 0)
        local tmpStacks = PST:getTreeSnapshotMod("tempSpeedOnKillStacks", 0)
        if tmpMod > 0 and tmpStacks > 0 and PSTAVessel.modCooldowns.tempSpeedOnKill > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpMod * math.min(5, tmpStacks)
        end

        -- Mod: +% speed and tears when killing poisoned enemies
        tmpMod = PST:getTreeSnapshotMod("poisonVialKillBuff", 0)
        if tmpMod > 0 and PSTAVessel.modCooldowns.poisonVialKillBuff > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpMod
        end

        -- Mod: +% temporary speed when picking up any battery
        tmpMod = PST:getTreeSnapshotMod("batterySpeedBuff", 0)
        if tmpMod > 0 and PSTAVessel.modCooldowns.batterySpeedBuff > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpMod
        end

        -- Mod: +% speed when first entering secret rooms
        tmpMod = PST:getTreeSnapshotMod("secretRoomSpeedBuff", 0)
        if tmpMod > 0 and PSTAVessel.modCooldowns.secretRoomSpeedBuff > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpMod
        end

        -- Mod: +% temporary speed when entering a room per blue fly you have
        if PSTAVessel.modCooldowns.vesselFliesSpeed > 0 and PSTAVessel.vesselFliesSpeedBuff > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + PSTAVessel.vesselFliesSpeedBuff
        end
    end

    -- Mod: +% all stats while you have eternal hearts
    tmpMod = PST:getTreeSnapshotMod("eternalAllstat", 0)
    if tmpMod > 0 and player:GetEternalHearts() > 0 then
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + tmpMod
    end

    -- Mod: buffs based on present level curses
    tmpMod = PST:getTreeSnapshotMod("hexerCurseBuff", 0)
    if tmpMod > 0 then
        local lvlCurses = Game():GetLevel():GetCurses()
        -- Curse of the Blind: +% tears
        if (lvlCurses & LevelCurse.CURSE_OF_BLIND) > 0 then
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + tmpMod
        end
        -- Curse of the Lost/Labyrinth/Maze: +% speed
        if (lvlCurses & (LevelCurse.CURSE_OF_LABYRINTH | LevelCurse.CURSE_OF_MAZE | LevelCurse.CURSE_OF_THE_LOST)) > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpMod
        end
    end

    -- Lightless Maw node (Singularity cosmic constellation)
    if PSTAVessel.modCooldowns.lightlessMaw > 0 then
        if PSTAVessel.lightlessMawDmg > 0 then
            dynamicMods.damagePerc = dynamicMods.damagePerc + math.min(25, PSTAVessel.lightlessMawDmg)
        end
        if PSTAVessel.lightlessMawLuckTears > 0 then
            dynamicMods.luckPerc = dynamicMods.luckPerc + math.min(25, PSTAVessel.lightlessMawLuckTears)
            dynamicMods.tearsPerc = dynamicMods.tearsPerc + math.min(25, PSTAVessel.lightlessMawLuckTears)
        end
        if PSTAVessel.lightlessMawSpeedRange > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + math.min(25, PSTAVessel.lightlessMawSpeedRange)
            dynamicMods.rangePerc = dynamicMods.rangePerc + math.min(25, PSTAVessel.lightlessMawSpeedRange)
        end
    end

    -- Lunar Scion node (Moon cosmic constellation)
    if PSTAVessel.modCooldowns.lunarScion > 0 then
        local tmpBonus = 5 + PST:getTreeSnapshotMod("lunarScionExtras", 0) * 2
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + tmpBonus * PST:getTreeSnapshotMod("lunarScionStacks", 1)
    end

    -- Mod: temporary +% all stats when killing enemies afflicted with Hemoptysis' curse
    if PSTAVessel.modCooldowns.mephitCurseKillBuff > 0 then
        tmpMod = PST:getTreeSnapshotMod("mephitCurseKillBuff", 0)
        local tmpStacks = PST:getTreeSnapshotMod("mephitCurseKillBuffStacks", 0)
        dynamicMods.allstatsPerc = dynamicMods.allstatsPerc + tmpMod * tmpStacks
    end

    ---- Stat modifier application ----
    local allstats = dynamicMods.allstats
    local allstatsPerc = dynamicMods.allstatsPerc
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        -- DAMAGE
        tmpMod = dynamicMods.damage + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + dynamicMods.damagePerc / 100
        player.Damage = (player.Damage + tmpMod) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
        -- TEARS (MaxFireDelay)
        tmpMod = dynamicMods.tears + dynamicMods.allstats
        local tmpMult = 1 - dynamicMods.allstatsPerc / 100
        tmpMult = tmpMult - dynamicMods.tearsPerc / 100
        player.MaxFireDelay = tearsUp(player.MaxFireDelay, tmpMod) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_LUCK then
        -- LUCK
        tmpMod = dynamicMods.luck
        local tmpMult = dynamicMods.luckPerc / 100
        player.Luck = player.Luck + tmpMod + math.abs(player.Luck) * tmpMult

    elseif cacheFlag == CacheFlag.CACHE_RANGE then
        -- RANGE
        tmpMod = dynamicMods.range + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + dynamicMods.rangePerc / 100
        player.TearRange = (player.TearRange + tmpMod * 40) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        -- SHOT SPEED
        tmpMod = dynamicMods.shotSpeed + allstats
        local tmpMult = 1 + allstatsPerc / 200
        tmpMult = tmpMult + dynamicMods.shotSpeedPerc / 200
        player.ShotSpeed = (player.ShotSpeed + tmpMod / 2) * math.max(0.05, tmpMult)

    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        -- MOVEMENT SPEED
        tmpMod = dynamicMods.speed + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + dynamicMods.speedPerc / 100
        player.MoveSpeed = (player.MoveSpeed + tmpMod / 2) * math.max(0.05, tmpMult)

        -- Mod: Spacefarer minimum speed
        if PST:getTreeSnapshotMod("spacefarerMinSpdProc", false) then
            tmpMod = PST:getTreeSnapshotMod("spacefarerMinSpd", 0)
            if tmpMod > 0 then
                local minSpeed = 0.8 + 0.03 * tmpMod
                if player.MoveSpeed < minSpeed then
                    player.MoveSpeed = minSpeed
                end
            end
        end
    end
end