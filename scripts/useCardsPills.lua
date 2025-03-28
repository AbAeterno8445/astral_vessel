---@param card Card
---@param player EntityPlayer
---@param useFlags UseFlag
function PSTAVessel:onUseCard(card, player, useFlags)
    -- Astral Angle node (Dark Gambler occult constellation)
    if PST:getTreeSnapshotMod("astralAngle", false) and card == Card.CARD_REVERSE_STARS then
        PST:addModifiers({ astralAngleProc = { value = 2, set = true } }, true)
    end

    -- Soul of the Vessel soul stone
    if card == PSTAVessel.vesselSoulstoneID then
        PST:sideArtiAddEnergy(200, true)
        PST:triggerMeridion(PST:getRandomMeridion())
    end

    -- Rune usage
    if PSTAVessel:arrHasValue(PST.allRunes, card) then
        -- Mod: +% all stats for the current floor when using a rune
        local tmpMod = PST:getTreeSnapshotMod("divinatorRuneBuff", 0)
        if card == Card.RUNE_SHARD then
            tmpMod = tmpMod * 0.33
        end
        if tmpMod > 0 then
            local tmpAdd = math.min(10 - PST:getTreeSnapshotMod("divinatorRuneBuffApplied", 0), tmpMod)
            if tmpAdd > 0 then
                PST:addModifiers({ allstatsPerc = tmpAdd, divinatorRuneBuffApplied = tmpAdd }, true)
            end
        end

        -- Mod: % chance to drop a rune shard when using a rune
        tmpMod = PST:getTreeSnapshotMod("runeUseShardDrop", 0)
        if tmpMod > 0 and 100 * math.random() < tmpMod then
            local newShard = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.RUNE_SHARD, player.Position, RandomVector() * 3, nil)
            newShard:ToPickup().Wait = 20
        end
    end
end