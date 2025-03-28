local gridSpecialPoopDips = {
    [GridPoopVariant.CORN] = DipSubType.CORN,
    [GridPoopVariant.BLACK] = DipSubType.BLACK,
    [GridPoopVariant.GOLDEN] = DipSubType.GOLDEN,
    [GridPoopVariant.HOLY] = DipSubType.HOLY,
    [GridPoopVariant.WHITE] = DipSubType.HOLY,
    [GridPoopVariant.RAINBOW] = DipSubType.RAINBOW,
    [GridPoopVariant.RED] = DipSubType.RED
}

function PSTAVessel:initExtraPSTFuncs()
    -- Extra PST function: Poop destroyed
    ---@param poopEntity GridEntityPoop
    PST:addPoopDestroyExtraFunc("avesselPoopFunc", function(poopEntity)
        -- Mod: % chance to create associated Dip when destroying a poop, up to 7x per room
        local tmpMod = PST:getTreeSnapshotMod("poopDip", 0)
        if tmpMod > 0 and PST:getTreeSnapshotMod("poopDipProcs", 0) < 7 and 100 * math.random() < tmpMod then
            local tmpDipType = gridSpecialPoopDips[poopEntity:GetVariant()] or DipSubType.NORMAL
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.DIP, tmpDipType, poopEntity.Position, RandomVector() * 3, PST:getPlayer())
            PST:addModifiers({ poopDipProcs = 1 }, true)
        end
    end)
end