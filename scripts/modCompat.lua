local modCompatInit = false
function PSTAVessel:initModCompat()
    if modCompatInit then return end

    -- Fiend Folio
    if FiendFolio then
        --[[ TODO: get permission to use costumes!!
        -- Faces
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_dads_dip.anm2", sourceMod="Fiend Folio"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_isaac_dot_chr.anm2", sourceMod="Fiend Folio"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_twinkleofcontagion.anm2", sourceMod="Fiend Folio"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_deadlydose.anm2", sourceMod="Fiend Folio"})
        ]]
    end

    -- Epiphany
    if Epiphany then
        -- Faces
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/epiphany/face_technical_character.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/costume_printer.anm2", sourceMod="Epiphany"})

        -- Accessories
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/costume_bad_company.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/costume_broken_halo.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/costume_crimson_bandana.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/costume_linen_shroud.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/costume_warm_coat.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/costume_woolen_cap.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/lost_d_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/tarnished_cain_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/tarnished_judas_extra_1.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/tarnished_keeper_extra.anm2", sourceMod="Epiphany"})

        -- Hairstyles
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/tarnished_eden_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/tarnished_magdalene_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/tarnished_samson_extra.anm2", sourceMod="Epiphany"})
    end

    -- Alternate Hairstyles
    if Isaac.GetCostumeIdByPath("gfx/characters/extrahair_bethany_01.anm2") ~= -1 then
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_bethany_01.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_eve_01.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_eve_02.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_isaac_01.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_isaac_02.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_t_isaac_01.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_judas_01.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_lazarus_01.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_lazarus2_01.anm2", sourceMod="Alternate Hairstyles"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_maggy_01.anm2", sourceMod="Alternate Hairstyles"})
    end

    modCompatInit = true
end