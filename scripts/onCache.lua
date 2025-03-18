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
    -- SPEED CACHE
    elseif cacheFlag == CacheFlag.CACHE_SPEED then
        -- Mod: +% speed for 3 seconds after killing an enemy. Stacks up to 5 times
        tmpMod = PST:getTreeSnapshotMod("tempSpeedOnKill", 0)
        local tmpStacks = PST:getTreeSnapshotMod("tempSpeedOnKillStacks", 0)
        if tmpMod > 0 and tmpStacks > 0 and PSTAVessel.modCooldowns.tempSpeedOnKill > 0 then
            dynamicMods.speedPerc = dynamicMods.speedPerc + tmpMod * math.min(5, tmpStacks)
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
        tmpMod = PST:getTreeSnapshotMod("speed", 0) + dynamicMods.speed + allstats
        local tmpMult = 1 + allstatsPerc / 100
        tmpMult = tmpMult + dynamicMods.speedPerc / 100
        player.MoveSpeed = (player.MoveSpeed + tmpMod / 2) * math.max(0.05, tmpMult)
    end
end