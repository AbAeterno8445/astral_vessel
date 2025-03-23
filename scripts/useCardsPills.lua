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
end