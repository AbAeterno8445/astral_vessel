---@param tear EntityTear
function PSTAVessel:postFireTear(tear)
    -- Swordstorm node (Paladin Divine constellation)
    if PST:getTreeSnapshotMod("palaSwordstorm", false) and (tear.Variant == TearVariant.BLUE or tear.Variant == TearVariant.BLOOD) then
        tear:ChangeVariant(TearVariant.SWORD_BEAM)
    end
end