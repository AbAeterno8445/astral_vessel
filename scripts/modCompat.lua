local modCompatInit = false
function PSTAVessel:initModCompat()
    if modCompatInit then return end

    -- Extra PST items
    PSTAVessel:addConstellationItem(Isaac.GetItemIdByName("Shadowmeld"), {PSTAVConstellationType.DEMONIC})

    -- Fiend Folio
    if FiendFolio then
        -- Faces
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_dads_dip.anm2", sourceMod="Fiend Folio"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_isaac_dot_chr.anm2", sourceMod="Fiend Folio"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_twinkleofcontagion.anm2", sourceMod="Fiend Folio"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/fiend_folio/face_deadlydose.anm2", sourceMod="Fiend Folio"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/black_moon_evangelion.anm2", sourceMod="Fiend Folio"})

		-- Accessories
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.GMO_CORN, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.COOL_SUNGLASSES, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.FIENDS_HORN, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.GOLEMS_ORB, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {path="gfx/characters/sanguine_hook.anm2", sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.FETAL_FIEND, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.SECRET_STASH, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.DEVILLED_EGG, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.SMALL_PIPE, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.SMALL_WOOD, sourceMod="Fiend Folio"}) -- hehe - wooky		
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.MUSCA, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.MODEL_ROCKET, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.HAPPYHEAD_AXE, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.PENNY_ROLL, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.ROBOBABY3, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.NYX, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.DICE_GOBLIN, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.SPINDLE, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.DEVILS_DAGGER, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.EMOJI_GLASSES, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.X10KACHING, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.X10BATOOMKLING, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.MOMS_STOCKINGS, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.HOST_ON_TOAST, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.BOX_TOP, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.SMASH_TROPHY, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.GOLDSHI_LUNCH, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {path="gfx/characters/sculpted_pepper.anm2", sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.COMMUNITY_ACHIEVEMENT, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.DEVILS_UMBRELLA, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.DADS_WALLET, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.DEIMOS, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.BRIDGE_BOMBS, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {item=FiendFolio.ITEM.COLLECTIBLE.GLIZZY, sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {path="gfx/characters/reimu_bow.anm2", sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {path="gfx/characters/explorers_hat.anm2", sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.accessoryList, {path="gfx/characters/devils_harvest_revive.anm2", sourceMod="Fiend Folio"})

		-- Hairstyles
		table.insert(PSTAVessel.hairstyles, {path="gfx/characters/dads_postiche.anm2", sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.hairstyles, {path="gfx/characters/excelsior.anm2", sourceMod="Fiend Folio"})
		table.insert(PSTAVessel.hairstyles, {path="gfx/characters/sanguine_hook_challenge.anm2", sourceMod="Fiend Folio"})

        -- Items
        local function PSTAVessel_addFFItem(ffItemName, types, extraCost)
            if not FiendFolio.ITEM.COLLECTIBLE[ffItemName] then
                print("[Astral Vessel] Warning: No Fiend Folio item '" .. ffItemName .."' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(FiendFolio.ITEM.COLLECTIBLE[ffItemName], types, extraCost or 0, "Fiend Folio")
        end
        PSTAVessel_addFFItem("PYROMANCY", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("DICE_BAG", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("LIL_FIEND", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("BABY_CRATER", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("MAMA_SPOOTER", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("RANDY_THE_SNAIL", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("CORN_KERNEL", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("COOL_SUNGLASSES", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("FIENDS_HORN", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("SPARE_RIBS", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("DEVILS_UMBRELLA", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("NUGGET_BOMBS", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("BEE_SKIN", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("PINHEAD", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("LIL_LAMB", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addFFItem("GRABBER", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("IMP_SODA", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("DADS_WALLET", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("BEGINNERS_LUCK", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("DICHROMATIC_BUTTERFLY", {PSTAVConstellationType.DIVINE}, 6)
        PSTAVessel_addFFItem("SLIPPYS_GUTS", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("SLIPPYS_HEART", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("MODERN_OUROBOROS", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("PEACH_CREEP", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("GORGON", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("OPHIUCHUS", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("CETUS", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("DEIMOS", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("PET_ROCK", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("BLACK_LANTERN", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("CRUCIFIX", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("PRANK_COOKIE", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("RUBBER_BULLETS", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("LIL_MINX", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addFFItem("PEPPERMINT", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("BLACK_MOON", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addFFItem("PAGE_OF_VIRTUES", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addFFItem("BRIDGE_BOMBS", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("LAWN_DARTS", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("TOY_PIANO", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("HYPNO_RING", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("MUSCA", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("MODEL_ROCKET", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("GREG_THE_EGG", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("FAMILIAR_FLY", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("MONAS_HIEROGLYPHICA", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("CYANIDE_DEADLY_DOSE", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("DADS_POSTICHE", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("EXCELSIOR", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addFFItem("HAPPYHEAD_AXE", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addFFItem("EVIL_STICKER", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("WIMPY_BRO", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("ROBOBABY3", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("NYX", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("TELEBOMBS", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("DICE_GOBLIN", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("SPINDLE", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("DEVILS_DAGGER", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addFFItem("D3", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("EMOJI_GLASSES", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("SACK_OF_SPICY", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("HEART_OF_CHINA", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("DEVILS_ABACUS", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addFFItem("INFINITY_VOLT", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("HORNCOB", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("MIME_DEGREE", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("CRAZY_JACKPOT", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("CLUTCHS_CURSE", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("PET_PEEVE", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("TIME_ITSELF", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("BAG_OF_BOBBIES", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("SMASH_TROPHY", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("FISTFUL_OF_ASH", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("DADS_BATTERY", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("BRICK_FIGURE", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("TWINKLE_OF_CONTAGION", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("REHEATED_PIZZA", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("ISAAC_DOT_CHR", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("TOO_MANY_OPTIONS", {PSTAVConstellationType.OCCULT})

        PSTAVessel_addFFItem("FIEND_FOLIO", {PSTAVConstellationType.OCCULT}, 2)
        PSTAVessel_addFFItem("D2", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("RISKS_REWARD", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("ALPHA_COIN", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("GOLEMS_ROCK", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("GRAPPLING_HOOK", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("FROG_HEAD", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("SANGUINE_HOOK", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("FIDDLE_CUBE", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("AVGM", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("MALICE", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("CLEAR_CASE", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("BEDTIME_STORY", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("ETERNAL_D12", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("FIEND_MIX", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("WHITE_PEPPER", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("GOLDEN_PLUM_FLUTE", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("DOGBOARD", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("ETERNAL_D10", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("TOY_CAMERA", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("THE_BROWN_HORN", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("SNOW_GLOBE", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("CHERRY_BOMB", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("ASTROPULVIS", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("AZURITE_SPINDOWN", {PSTAVConstellationType.MERCANTILE}, 4)
        PSTAVessel_addFFItem("KING_WORM", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("DAZZLING_SLOT", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("KALUS_HEAD", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addFFItem("ANGELIC_LYRE_B", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addFFItem("LEMON_MISHUH", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("NIL_PASTA", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("EMPTY_BOOK", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("GAMMA_GLOVES", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("SHREDDER", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addFFItem("TORTURE_COOKIE", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addFFItem("MOONBEAM", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("DUSTY_D10", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addFFItem("WRONG_WARP", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addFFItem("HEDONISTS_COOKBOOK", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addFFItem("SCULPTED_PEPPER", {PSTAVConstellationType.ELEMENTAL})

        -- Battery Items
        table.insert(PSTAVessel.batteryItems, FiendFolio.ITEM.COLLECTIBLE.DADS_BATTERY)
        table.insert(PSTAVessel.batteryItems, FiendFolio.ITEM.COLLECTIBLE.X10BZZT)

        -- Knife Items
        table.insert(PSTAVessel.knifeItems, FiendFolio.ITEM.COLLECTIBLE.YOUR_ETERNAL_REWARD)
        table.insert(PSTAVessel.knifeItems, FiendFolio.ITEM.COLLECTIBLE.DEVILS_DAGGER)
    end

    -- Epiphany
    if Epiphany then
        -- Faces
        table.insert(PSTAVessel.facesList, {path="gfx/characters/faces/astralvessel/epiphany/face_technical_character.anm2", sourceMod="Epiphany"})

        -- Accessories
        table.insert(PSTAVessel.accessoryList, {item=Epiphany.Item.BAD_COMPANY.ID, sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {item=Epiphany.Item.BROKEN_HALO.ID, sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {item=Epiphany.Item.CRIMSON_BANDANA.ID, sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {item=Epiphany.Item.LINEN_SHROUD.ID, sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {item=Epiphany.Item.WARM_COAT.ID, sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {item=Epiphany.Item.WOOLEN_CAP.ID, sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {item=Epiphany.Item.PRINTER.ID, sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/lost_d_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/tarnished_cain_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/tarnished_judas_1_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/tarnished_keeper_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.accessoryList, {path="gfx/characters/epiphany_anniversary.anm2", sourceMod="Epiphany"})

        -- Hairstyles
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/tarnished_eden_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/tarnished_magdalene_extra.anm2", sourceMod="Epiphany"})
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/tarnished_samson_extra.anm2", sourceMod="Epiphany"})

        -- Items
        local function PSTAVessel_addEpItem(epItemName, types, extraCost)
            if not Epiphany.Item[epItemName] then
                print("[Astral Vessel] Warning: No Epiphany item '" .. epItemName .."' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(Epiphany.Item[epItemName].ID, types, extraCost or 0, "Epiphany")
        end
        PSTAVessel_addEpItem("NOTHING", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("THIRTY_PIECES_OF_SILVER", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEpItem("COIN_CASE", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEpItem("REVOLT", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEpItem("RETRIBUTION", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEpItem("WORK_IN_PROGRESS", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("MOTHERS_SHADOW", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEpItem("WARM_COAT", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("TRUE_LOVE", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("WOOLEN_CAP", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("BROKEN_HALO", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEpItem("OLD_KNIFE", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("KINS_CURSE", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addEpItem("CRIMSON_BANDANA", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("BROKEN_PILLAR", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("PRINTER", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("ZIP_BOMBS", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("SEGMENTATION_FAULT", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEpItem("BOTTLED_SPIRITS", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addEpItem("LIL_GUPPY", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEpItem("STOCK_FLUCTUATION", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEpItem("BAD_COMPANY", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEpItem("GOLDEN_COBWEB", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEpItem("GLITCH_ITEM_0", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEpItem("GLITCH_ITEM_1", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEpItem("GLITCH_ITEM_2", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEpItem("GLITCH_ITEM_3", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEpItem("BURNING_PASSION", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEpItem("ROTTEN_CORE", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEpItem("CARDBOARD_CUTOUT", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEpItem("ANAL_FISSURE", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEpItem("FLY_TRAP", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})

        PSTAVessel_addEpItem("CARDIAC_ARREST", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEpItem("THROWING_BAG", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("DESCENT", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addEpItem("KILLER_INSTINCT", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEpItem("MOMS_HUG", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("CHANCE_CUBE", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEpItem("EMPTY_DECK", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEpItem("D5", {PSTAVConstellationType.MERCANTILE}, 4)
        PSTAVessel_addEpItem("WEIRD_HEART", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEpItem("SURPRISE_BOX", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEpItem("SAVAGE_CHAINS", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEpItem("PORTABLE_DICE_MACHINE", {PSTAVConstellationType.MERCANTILE})

        -- Knife items
        table.insert(PSTAVessel.knifeItems, Epiphany.Item.DESCENT.ID)
        table.insert(PSTAVessel.knifeItems, Epiphany.Item.OLD_KNIFE.ID)

        -- Hurt/Death SFX
        table.insert(PSTAVessel.customHurtSFXList, {Isaac.GetSoundIdByName("Guppy Giggle"), "Guppy Giggle", "Epiphany"})
        table.insert(PSTAVessel.customHurtSFXList, {Isaac.GetSoundIdByName("Eden Hurt"), "Tr. Eden Hurt", "Epiphany"})
        table.insert(PSTAVessel.customHurtSFXList, {Isaac.GetSoundIdByName("Keeper Hurt"), "Tr. Keeper Hurt", "Epiphany"})
        table.insert(PSTAVessel.customHurtSFXList, {Isaac.GetSoundIdByName("Lost Ghost Charge"), "Ghost Charge", "Epiphany"})
        table.insert(PSTAVessel.customDeathSFXList, {Isaac.GetSoundIdByName("Eden Dies"), "Tr. Eden Death", "Epiphany"})
        table.insert(PSTAVessel.customDeathSFXList, {Isaac.GetSoundIdByName("Keeper Dies"), "Tr. Keeper Death", "Epiphany"})
        table.insert(PSTAVessel.customDeathSFXList, {Isaac.GetSoundIdByName("Lost Ghost Charge Full"), "Ghost Charge Full", "Epiphany"})
        table.insert(PSTAVessel.customDeathSFXList, {Isaac.GetSoundIdByName("Death Roar"), "Death Roar", "Epiphany"})
    end

    -- Reverie
    if Reverie then
        -- Items
        local function PSTAVessel_addRevItem(revItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(revItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Reverie item '" .. revItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Reverie")
        end
        PSTAVessel_addRevItem("Marisa's Broom", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Great Fairy Fountain", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Koakuma Baby", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Maid Uniform", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Frozen Sakura", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Chen Baby", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Shanghai Doll", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("One of Nine Tails", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Starseeker", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Pathseeker", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Gourd-Shroom", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Song of the Nightbird", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Rabbit Trap", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Illusion", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Dragon Neck Jewel", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Buddha's Bowl", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Robe of Firerat", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Swallow's Shell", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Jeweled Branch", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Ash of Phoenix", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Sunflower Pot", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Continue?", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Sunny Fairy", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Luna Fairy", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Star Fairy", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Leaf Shield", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Broken Amulet", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Wolf Eye", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Young Native God", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Escape", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Angel's Raiment", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Plague Lord", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Green Eyed Envy", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Oni's Horn", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Psychic Eye", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Guppy's Corpse Cart", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Technology 666", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Dowsing Rods", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Scary Umbrella", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Unzan", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Ethereal Arm", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Mountain Ear", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Zombie Infestation", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Holy Thunder", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Geomantic Detector", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Lightbombs", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("The Infamies", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Sekibanki's Head", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Thunder Drum", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Lunatic Gun", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Vicious Curse", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Carnival Hat", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Hekate", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Dad's Shares", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Yamanba's Chopper", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Golem of Isaac", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Dancer Servants", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Back Door", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Cockcrow Wings", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Kiketsu Family Blackmail", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Carving Tools", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Brutal Horseshoe", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Hunger", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Sake of The Forgotten", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Fox in a Tube", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Daitengu Telescope", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Rusted Rod", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Curse of Blood", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Netherworld Wanted Poster", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Bloodthirsty Orb", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Parasitic Mushroom", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Ice Sculpture", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Asthma", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Dagger of Servants", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Bloody Tears", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Blizzard", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Springy Spring of Spring", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Poltermancy", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Hakurouken", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Mobile Satellite", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Train Ticket Receipt", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Queen of the Clan", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Broken Calendar", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("3D Glasses", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Warmth", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Fabrication", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Ominous Doll", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Electrodynamics", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("The Eel", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Jealousy", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Megaphone", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Corrupt Heart", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Stillbirth Cultivation", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Lightning Orb", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Guppy Fish", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Possessed Qin", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Possessed Pipa", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Weaver's Needle", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Door", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Rocky Jelly", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Sacabambaspis", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Seymour", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Tomb Pots", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Pegasus", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Cursed Blood", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Fortunate Coin", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Ghostly Lamp", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Boulder Trap", {PSTAVConstellationType.ELEMENTAL})

        PSTAVessel_addRevItem("Yin-Yang Orb", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Rainbow Dragon Badge", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Grimoire of Patchouli", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Destruction", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Melancholic Violin", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Maniac Trumpet", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Illusionary Keyboard", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Roukanken", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("The Gap", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Jar of Fireflies", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Peerless Elixir", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Rabbit Shovel", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Tengu Camera", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Rod of Remorse", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Extending Arm", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Benediction", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Onbashira", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Geographic Chain", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Rune Sword", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Keystone", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Bucket of Wisps", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Psycho Knife", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Transfuse", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Sorcerer's Scroll", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Saucer Remote", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Tengu Cellphone", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Warping Hairpin", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Nimble Fabric", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Miracle Mallet Replica", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Fetus Blood", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Gambling D6", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Yamawaro's Crate", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Empty Book", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Delusion Pipe", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Soul Magatama", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Rebel Mecha Caller", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Spirit Cannon", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("The Golden Fertilizer", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("The Thinker Clock", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Sword of Hisou", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Body Bag", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Blacksmith Hammer", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("The Saint's Motorcycle", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Eye of Chimera", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Portable Copier", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Turnabout Bracelet", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Zhou Interprets Dreams", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Censer of Illness", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Rubblemaker", {PSTAVConstellationType.ELEMENTAL}, 6)
        PSTAVessel_addRevItem("Cerberus' Bowls", {PSTAVConstellationType.DEMONIC}, 6)
        PSTAVessel_addRevItem("Bishamonten's Pagota", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Captain's Log", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Rainbow Card", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Miracle Mallet", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("DELETED ERHU", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Mohgwyn's Spear", {PSTAVConstellationType.DEMONIC})

        -- Battery Items
        table.insert(PSTAVessel.batteryItems, Isaac.GetItemIdByName("Electrodynamics"))

        -- Knife Items
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Psycho Knife"))
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Dagger of Servants"))
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Yamanba's Chopper"))
    end

    -- Reverie: MGO
    if ReverieMGO then
        -- Items
        local function PSTAVessel_addRevItem(revItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(revItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Reverie MGO item '" .. revItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Reverie MGO")
        end
        PSTAVessel_addRevItem("[Load Failure]", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Silver Knife", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Bustling Fungus", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Cucumber Battery", {PSTAVConstellationType.MUNDANE}, 4)
        PSTAVessel_addRevItem("Curse of the Haunting God", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Last Stand Formation", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("The Gentle Good Night", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Sera's Lure", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Magatama Necklace", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Atypus's Delude", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("The Negative SinGyoku", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("The Positive SinGyoku", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Shimenawa", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Divine Beans", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("The Devotion", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Brain Implosion Energy Drink", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Sing-Along Buddy", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Treasure Scout Mouse", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Deep Reading", {PSTAVConstellationType.MUNDANE})

        PSTAVessel_addRevItem("Impulse to Destroy", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Blood Gem", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Donation Box", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("D58", {PSTAVConstellationType.MERCANTILE}, 6)
        PSTAVessel_addRevItem("Quantum Peach", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Sonic Screwdriver", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE})

        -- Battery Items
        table.insert(PSTAVessel.batteryItems, Isaac.GetItemIdByName("Cucumber Battery"))

        -- Knife Items
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Silver Knife"))
    end

    -- Repentance Plus! (mod)
    if RepentancePlusMod then
        -- Items
        local function PSTAVessel_addRepItem(repItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(repItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Repentance Plus! item '" .. repItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Repentance Plus!")
        end
        PSTAVessel_addRepItem("Ordinary Life", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Red Bomber", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRepItem("Cherry Friends", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("The Mark of Cain", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRepItem("Red Map", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRepItem("Black Doll", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRepItem("Ceremonial Blade", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRepItem("Bag-o-Trash", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Bless of the Dead", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("A Bird of Hope", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("Ultra Flesh Kid!", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRepItem("Temper Tantrum", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRepItem("Nerve Pinch", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRepItem("The Cross of Chaos", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRepItem("Magic Pen", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRepItem("Cherubim", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("Mother's Love", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("Friendly Sack", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRepItem("2+1", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRepItem("Enraged Soul", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRepItem("Pure Soul", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("Ceiling with the Stars", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRepItem("Tank Boys", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Sibling Rivalry", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRepItem("Helicopter Boys", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("The Hood", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("Spiritual Amends", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("Dead Weight", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRepItem("Keeper's Annoying Fly", {PSTAVConstellationType.MUTAGENIC})

        PSTAVessel_addRepItem("Rubik's Cube", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Cookie Cutter", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Blood Vessel", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRepItem("Tower of Babel", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Book of Judges", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("A Scalpel", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Book of Leviathan", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRepItem("Magic Marker", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Soul Bond", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRepItem("Rejection", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRepItem("Auction Gavel", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRepItem("Bottomless Bag", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRepItem("Vault of Havoc", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRepItem("Handicapped Placard", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRepItem("Stargazer's Hat", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRepItem("Cheese Grater", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRepItem("Bag of Jewels", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRepItem("We Need To Go Sideways", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})

        -- Knife Items
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Ceremonial Blade"))
    end

    -- Revelations
    if REVEL then
        -- Items
        local function PSTAVessel_addRevItem(repItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(repItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Revelations item '" .. repItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Revelations")
        end
        PSTAVessel_addRevItem("Heavenly Bell", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Mint Gum", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Fecal Freak", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Dynamo", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Aegis", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Penance", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Ice Tray", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Window Cleaner", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Cotton Bud", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Sponge Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Spirit of Patience", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Birth Control", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Friendly Fire", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Tummy Bug", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Wandering Soul", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Cabbage Patch", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Haphephobia", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Death Mask", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Mirror Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Broken Oar", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Perseverance", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Addict", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Ophanim", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Wrath's Rage", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Pride's Posturing", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Sloth's Saddle", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Lover's Libido", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Prescription", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Geode", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Not a Bullet", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Lil Frost Rider", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Lil Belial", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Virgil", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Cursed Grail", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Bandage Baby", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Lil Michael", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRevItem("Hungry Grub", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Envy's Enmity", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRevItem("Bargainer's Burden", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRevItem("Willo", {PSTAVConstellationType.ELEMENTAL})

        PSTAVessel_addRevItem("The Monolith", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Hyper Dice", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRevItem("Chum Bucket", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Cardboard Robot", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Ghastly Flame", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Waka Waka", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Oops!", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRevItem("Glutton's Gut", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Moxie's Paw", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Music Box", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRevItem("Half Chewed Pony", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Moxie's Yarn", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRevItem("Super Meat Blade", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRevItem("Dramamine", {PSTAVConstellationType.MUTAGENIC})
    end

    -- Retribution
    if Retribution then
        -- Items
        local function PSTAVessel_addRetItem(repItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(repItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Retribution item '" .. repItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Retribution")
        end
        PSTAVessel_addRetItem("Bob's Heart", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Bedbug", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Cactus", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Cracked Infamy", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRetItem("Dead Lung", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Frail Fly", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Hundred Dollar Steak", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Lent", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Rickets", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Salesman's Eye", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Sloth's Toe", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Soap Box", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Axolotl", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Bad Apple", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Baptismal Shell", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUTAGENIC}, 4)
        PSTAVessel_addRetItem("Bar of Soap", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Baron Fly", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Cataract", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Chastity Belt", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Chunk of Tofu", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Coil", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Defibrillator", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Eve's Nail Polish", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Friendly Monster", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRetItem("Guppy's Pride", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Hyperopia", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Joyful", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Mad Onion", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Mark of Cain", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Peashy", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Rapture", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Roll Film", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Slick Spade", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Soy Bean", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Sunken Fly", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Tithe", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Vanilla Wafer", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Weltling Sac", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Friend Folio", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Beeconomy", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Brownie", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Conjunctivitis", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Milk of Baphomet", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Devil's Tooth", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Melitodes", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Swindler", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Bandage Binder", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Heartbroker", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MERCANTILE}, 4)
        PSTAVessel_addRetItem("Jet Feather", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Heart Rupture", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Hemorrhoid", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Baby's Breath", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Arrow of Light", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Azazel's Horn", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Celestial Berry", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Chimerism", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Cholera", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Cootie", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Cyst", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Effigy", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Empiric", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Eternal Bombs", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Milk Teeth", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Mustard Seed", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Photon", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Reflux", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Rewards Card", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Silver Flesh", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Smooth Stone", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Some Options", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Sucker Sac", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Tool", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Toy Drum", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Wax Wing", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Booster Shot", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Eye of Balor", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Glioma", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Spoils Pouch", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Technology Omicron", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Bell Clapper", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Impact Wax", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Myopia", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Sculpted Soapstone", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Heel Spur", {PSTAVConstellationType.MUTAGENIC}, 4)
        PSTAVessel_addRetItem("Sinner's Prayer", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Derelict Anchor", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Red Chain", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRetItem("Dominicus", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addRetItem("Polaris", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addRetItem("Bag of Seeds", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Bleeding Heart", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Gloriosa", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("F.O.P.", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Corpse Flower", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})

        PSTAVessel_addRetItem("Baptismal Font", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Book of Mormon", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Communion", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Lily", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Stained Shard", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Everlasting Pill", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Fry's Paw", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Gacha-Go", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Black Hammer", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Book of Genesis", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addRetItem("Bell of Circe", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Snap Bang", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Dowsing Rod", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Melatonin", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Monster Candy", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Moonlit Mirror", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("The Iliad", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("The Odyssey", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Black Box", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Death Cap", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("False Idol", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Sculpting Clay", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Meat Grinder", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Bone Saw", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addRetItem("Coinflip", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Blazing Beak", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Lifeblood Syringe", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Bygone Arm", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("The Pig Bang", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addRetItem("Seed Sack", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addRetItem("Pumpkin Mask", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addRetItem("Shattered Dice", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addRetItem("Bottled Fairy", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addRetItem("Puffstool", {PSTAVConstellationType.ELEMENTAL})
    end

    -- Eclipsed
    if EclipsedMod then
        -- Items
        local function PSTAVessel_addEclItem(eclItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(eclItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Eclipsed item '" .. eclItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Eclipsed")
        end
        PSTAVessel_addEclItem("Mongo Cells", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Melted Candle", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Ivory Oil", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Red Lotus", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Curse of the Midas", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEclItem("Duckling", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Red Button", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Compo Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Limbus", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Black Hole Bombs", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Glass Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Ice Cube Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("VVV", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Red Bag", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Lililith", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEclItem("Abihu", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Nadab's Brain", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Nadab's Body", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Death's Sickle", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Mew-Gen", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Eclipse", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Battery Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Pyrophilia", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Spike Collar", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Dead Bombs", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Surrogate Conception", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Holy Ravioli", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEclItem("Shroomface", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Glitter Injection", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Mephisto's Pact", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEclItem("Varg", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Aurora", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Sarbokan", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Tindal", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Horoles", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Dark Bombs", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Bufo", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Black Plague", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Levitan", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Soul in a Jar", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Fool Moon", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Wonder Waffle", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Expurgation", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEclItem("Blood V", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Unholy Collection", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Ares", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Stone Frog", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Cultist Baby", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Magician's Top", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Witch's Cone", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Influenza", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Shock Therapy", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Dream Tiger", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Super Underwear", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Batter-Yum", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Betty Sweetooth", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Retro Virus", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Mushroom Soup", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Angry Meal", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Little Diablo", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})

        PSTAVessel_addEclItem("Red Mirror", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Black Knight", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("White Knight", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Moonlighter", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Unicorn", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Lost Mirror", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Bleeding Grimoire", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Black Book", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Rubik's Dice", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("VHS Cassette", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Threshold", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Charon's Obol", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEclItem("Book of Memories", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Space Jam", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Elder Sign", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Witch's Pot", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Pandora's Jar", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Secret Love Letter", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Heart Transplant", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Garden Trowel", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Elder Myth", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Forgotten Grimoire", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Codex Animarum", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Red Book", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Ancient Sacred Volume", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Tome of Holy Healing", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEclItem("Wizard's Book", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Ritual Manuscripts", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEclItem("Stitched Papers", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Nirly's Codex", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEclItem("Alchemic Notes", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Locked Grimoire", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addEclItem("Stone Scripture", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEclItem("Hunter's Journal", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Tome of the Dead", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Ignite", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Astral Dice", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Symbiont", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Comm4nd4", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Inner Demon", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEclItem("Gospel", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEclItem("Little Inferno", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Big Bertha", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Pizza Pepperoni", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addEclItem("Stained Glass", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addEclItem("Mystic Novel", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEclItem("Foo Charm", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Troll Book", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Potion of Motion", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addEclItem("Everything Bagel", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("L.D.R.", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addEclItem("Birds of the World", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("Applied Horticulture", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addEclItem("On Tentacles", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Overcoming Arachnophobia", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addEclItem("Babylon Candle", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addEclItem("Lux Aeterna", {PSTAVConstellationType.DIVINE})

        -- Battery Items
        table.insert(PSTAVessel.batteryItems, Isaac.GetItemIdByName("Battery Bombs"))
    end

    -- Lost and Forgotten
    if LNF then
        -- Items
        local function PSTAVessel_addLnfItem(eclItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(eclItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Lost and Forgotten item '" .. eclItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Lost and Forgotten")
        end
        PSTAVessel_addLnfItem("Conscience", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Math Problem", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Broken Hourglass", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addLnfItem("Syrup", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Shampoo", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Small Knives", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Parasite Eggs", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Ancient Technology", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Hydrosis", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Megaphone", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Wellingtons", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Mutation", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Wedding Ring", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Monocle", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addLnfItem("Enlightenment", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addLnfItem("Demon's Eye", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Calotte", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Carrion", {PSTAVConstellationType.MUTAGENIC})
        --PSTAVessel_addLnfItem("Testament", {PSTAVConstellationType.DIVINE}) -- Unsupported Quality level?
        PSTAVessel_addLnfItem("Champion Mush", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Old Clock", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Purple Skull", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Can Of Tar", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Card Game", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Schizophrenia", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Inner Demon", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Followers", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Dead Womb", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("God's Wrath", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Keeper's Noose", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addLnfItem("Soaked Sponge", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Lamb Skull", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Apollyon's Horns", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addLnfItem("Golden Cross", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Paimon's Mark", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Dragon Scales", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Corporeal", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Monster Cell", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Reanimator", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Green Cap", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Colitis", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Blessing", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Mephisto's Pact", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Wealthy Heart", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addLnfItem("Fire And Ice", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Lums", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addLnfItem("Psychedelic Spores", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addLnfItem("Personality Split", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Primordial Sin", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Scrapheap", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Mental Breakdown", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Battery Bag", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Rations", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Fragile Strength", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Blood Ball", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Lil Guardian", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Lil Forsaken", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Tree Of Life", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Lil Maw", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Divided Baby", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Munitus Baby", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Dry Bones", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Ladygrub", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Mashy", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Drizzle Maker", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Revenant's Head", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Fruit of Eden", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Low Priest", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Robo-Baby X", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Mark I", {PSTAVConstellationType.ELEMENTAL})

        PSTAVessel_addLnfItem("Glass Heart", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Epidemic", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Anthrax", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Gong", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Cupid's Bow", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addLnfItem("Dad's Hammer", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Moirai String", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Gospel Of Judas", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addLnfItem("Dissolving Cat", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Dedal's Blueprint", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Gross Remote", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Cursed Gem", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Prescription", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Robot's Battery", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Workshop", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Moon Rock", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addLnfItem("Nightmare Fuel", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addLnfItem("Hot Rocks", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Blood Shrine", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addLnfItem("Animatronic's Mask", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addLnfItem("Red Mass", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addLnfItem("Dynamite", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addLnfItem("Tube Milk", {PSTAVConstellationType.MUNDANE})

        -- Battery Items
        table.insert(PSTAVessel.batteryItems, Isaac.GetItemIdByName("Robot's Battery"))

        -- Knife Items
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Plastic Knife"))
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Small Knives"))

        -- Questionnaire interaction for Vessel
        LNF:AddQuestionnaireDrop(PSTAVessel.vesselType, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Isaac.GetTrinketIdByName("Arcane Obols 3"))
    end

    -- Community Remix
    if communityRemix then
        -- Items
        local function PSTAVessel_addCrItem(crItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(crItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Community Remix item '" .. crItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Community Remix")
        end
        PSTAVessel_addCrItem("Mudpie", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Cryobombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("The Mark of Cain", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addCrItem("Box of Wires", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Mortal Coil", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("The Hive", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCrItem("Blood Money", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCrItem("Jack-O-Lantern", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("Forbidden Seed", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addCrItem("Blue Waffle", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Sinner's Scars", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("Boner Baby", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("Oven Mitt", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Coconut Milk", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Toothpaste", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Donkey's Jawbone", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCrItem("Counterfeit Dollar", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCrItem("Voodoo Prick", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("Patient Zero", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Heartache", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addCrItem("Benadryl", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Ophiuchus", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addCrItem("Tammy's Tail", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCrItem("Akedah", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addCrItem("Menorah", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Gacha Bombs", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCrItem("Goat Heart", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCrItem("Plum's Manifesto", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Dad's Little Secret", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("The Beast of Prophecy", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addCrItem("Conqueror Baby", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addCrItem("Mandrake", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("Old Bib", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("LMAOBOX", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Dagon", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addCrItem("Cthulhu", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addCrItem("Tulzscha", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addCrItem("Kassogtha", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addCrItem("Azathoth", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addCrItem("Burnt Baby", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Magic Powder", {PSTAVConstellationType.MUTAGENIC})

        PSTAVessel_addCrItem("The Pebble", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Chilly Bean", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Potty", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCrItem("D3", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCrItem("Bowl o' Beans", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Occam's Razor", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("Spice", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addCrItem("Molotov Cocktail", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Tammy's Paw", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCrItem("Clay Dreidel", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addCrItem("The Book of Love", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addCrItem("Tulip", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("The Apple", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addCrItem("The Book of Sorrow", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCrItem("Snake Eyes", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCrItem("Mom's Cellphone", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Geode", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Spring Bean", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCrItem("Green Candle", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCrItem("Moldy D6", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCrItem("Communion Wine", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addCrItem("Twin Candles", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})

        -- Knife Items
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Misericorde"))
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Ceremonial Blade"))

        -- Hurt/Death SFX
        table.insert(PSTAVessel.customDeathSFXList, {Isaac.GetSoundIdByName("mandrake scream"), "Mandrake Scream", "Community Remix"})
    end

    -- Reshaken Vol 1
    if MilkshakeVol1 then
        -- Items
        local function PSTAVessel_addReItem(crItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(crItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Reshaken Vol 1 item '" .. crItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Reshaken Vol 1")
        end
        PSTAVessel_addReItem("Firecracker Flower", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addReItem("Sharp Cursor", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addReItem("La Chancla", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addReItem("Lyra", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addReItem("Spirit Bum", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addReItem("Celestial Mirror", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addReItem("Sickle Cell", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addReItem("Pot of Gold", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addReItem("Battery Acid", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addReItem("Doggy Bag", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addReItem("Dad's Mitt", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addReItem("Lil Bishop", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addReItem("Witch Doctor Mask", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addReItem("Scripulous Fingore", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addReItem("Black Eye", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addReItem("Chromatic Prism", {PSTAVConstellationType.COSMIC})

        PSTAVessel_addReItem("Globin In A Bucket", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addReItem("Empty Slot", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addReItem("Shattered Orb", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addReItem("Mirror Key", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addReItem("Dice Dice", {PSTAVConstellationType.MERCANTILE})

        -- Battery Items
        table.insert(PSTAVessel.batteryItems, Isaac.GetItemIdByName("Battery Acid"))
    end

    -- Kicks and Giggles
    if Diepio then
        -- Items
        local function PSTAVessel_addKgItem(kgItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(kgItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Kicks and Giggles item '" .. kgItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Kicks and Giggles")
        end
        PSTAVessel_addKgItem("Black Orb", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addKgItem("Monoball", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addKgItem("Miscarriage", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addKgItem("Square Candy", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addKgItem("YouTuber Luck", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addKgItem("Seal of Winifred", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addKgItem("Monstromagnetic Energy Drink", {PSTAVConstellationType.MUNDANE})

        PSTAVessel_addKgItem("Lewis's Replica Headband", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        --PSTAVessel_addKgItem("Paramedic's Medikit", {PSTAVConstellationType.MUTAGENIC}) -- Unsupported quality level
        PSTAVessel_addKgItem("Shattered Candy", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addKgItem("Dodging Manual", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addKgItem("Haumea", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addKgItem("Winifred's Grimoire", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addKgItem("Book of Bleakness", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addKgItem("Book of Weaponry", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addKgItem("Book of Filth", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addKgItem("Book of Procreation", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addKgItem("Book of The Moonlight", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
    end

    -- Siren (character)
    if Isaac.GetPlayerTypeByName("Siren") ~= -1 then
        -- Items
        local function PSTAVessel_addSItem(sItemName, types, extraCost)
            PSTAVessel:addConstellationItem(Isaac.GetItemIdByName(sItemName), types, extraCost or 0, "Siren Character")
        end
        PSTAVessel_addSItem("Poo Bum", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addSItem("Little Little Horn", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addSItem("Little Siren", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})

        -- Hairstyles
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/character_siren.anm2", sourceMod="Siren (character)"})
    end

    -- Andromeda
    if ANDROMEDA then
        -- Items
        local function PSTAVessel_addAndItem(andItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(andItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Andromeda item '" .. andItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Andromeda")
        end
        PSTAVessel_addAndItem("Juno", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Pallas", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Ceres", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Vesta", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Ophiuchus", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Luminary Flare", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Starburst", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Celestial Crown", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Baby Pluto", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Plutonium", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})

        PSTAVessel_addAndItem("Gravity Shift", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Extinction Event", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("Book of Cosmos", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addAndItem("The Sporepedia", {PSTAVConstellationType.COSMIC})

        -- Faces
        table.insert(PSTAVessel.facesList, {path="gfx/characters/andromedabheadeyes.anm2", sourceMod="Andromeda"})
        table.insert(PSTAVessel.facesList, {path="gfx/characters/andromedabheadeyes_blood.anm2", sourceMod="Andromeda"})

        -- Hurt/Death SFX
        table.insert(PSTAVessel.customHurtSFXList, {Isaac.GetSoundIdByName("AndromedaHurt"), "Andromeda Hurt", "Andromeda"})
        table.insert(PSTAVessel.customHurtSFXList, {Isaac.GetSoundIdByName("TAndromedaHurt"), "T. Andromeda Hurt", "Andromeda"})
        table.insert(PSTAVessel.customDeathSFXList, {Isaac.GetSoundIdByName("AndromedaDeath"), "Andromeda Death", "Andromeda"})
        table.insert(PSTAVessel.customDeathSFXList, {Isaac.GetSoundIdByName("TAndromedaDeath"), "T. Andromeda Death", "Andromeda"})
    end

    -- Samael
    if SamaelMod then
        -- Items
        local function PSTAVessel_addSamItem(samItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(samItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Samael item '" .. samItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Samael")
        end
        PSTAVessel_addSamItem("Thanatophobia", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addSamItem("Thanatophilia", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addSamItem("Reaper Bum", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addSamItem("Remembrance of the Forgotten", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addSamItem("Remembrance of Death", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addSamItem("Punishment of the Grave", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addSamItem("Spirit of Anger", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addSamItem("Spirit of Bargaining", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addSamItem("Spirit of Depression", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addSamItem("Mask of Thanatos", {PSTAVConstellationType.OCCULT})

        PSTAVessel_addSamItem("Malakh Mot", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addSamItem("Memento Mori", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addSamItem("Jar of Scythes", {PSTAVConstellationType.OCCULT})
    end

    -- Mastema
    if MASTEMA then
        -- Items
        local function PSTAVessel_addMasItem(masItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(masItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Mastema item '" .. masItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Mastema")
        end
        PSTAVessel_addMasItem("Book of Jubilees", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addMasItem("Mastema's Wrath", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addMasItem("Torn Wings", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addMasItem("Bloodsplosion", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addMasItem("Sacrificial Chalice", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addMasItem("Corrupt Heart", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})

        PSTAVessel_addMasItem("Bloody Harvest", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addMasItem("Raven Skull", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addMasItem("Infernal Covenant", {PSTAVConstellationType.DEMONIC})
        --PSTAVessel_addMasItem("Broken Dice", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MERCANTILE}) -- Unsupported quality level
    end

    -- D!Edith
    if dedith then
        -- Items
        local function PSTAVessel_addDedItem(dedItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(dedItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No D!Edith item '" .. dedItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "D!Edith")
        end
        PSTAVessel_addDedItem("​​​Salty Baby", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addDedItem("​​​Voodoo Pin", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addDedItem("​​​Checked Mate", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addDedItem("Yellow Paint", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addDedItem("Dante's Inferno", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addDedItem("Epic Bacon", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addDedItem("​​​Hemorrhoid", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addDedItem("Cool Aid", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})

        PSTAVessel_addDedItem("​​​Salt Shaker", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addDedItem("Bindle", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addDedItem("Fast Forward", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
    end

    -- The Sheriff
    if Sheriff then
        -- Items
        local function PSTAVessel_addShItem(shItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(shItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Sheriff item '" .. shItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Sheriff")
        end
        PSTAVessel_addShItem("Tumbleweed", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addShItem("Ten-Gallon Hat", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addShItem("Blunt Force", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addShItem("Armed Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addShItem("Little Ram", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addShItem("Bandit's Bandana", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addShItem("Chewing Tobacco", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addShItem("Glass Bullets", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addShItem("Spirit of the West", {PSTAVConstellationType.OCCULT})

        PSTAVessel_addShItem("Quick Draw", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addShItem("Deader Eye", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addShItem("B.U.R.T.", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addShItem("Holster", {PSTAVConstellationType.MUNDANE})
    end

    -- Martha of Bethany
    if Isaac.GetPlayerTypeByName("Martha") ~= -1 then
        -- Items
        local function PSTAVessel_addMarItem(marItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(marItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Martha of Bethany item '" .. marItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Martha of Bethany")
        end
        PSTAVessel_addMarItem("Morning Star", {PSTAVConstellationType.DEMONIC})
        PSTAVessel_addMarItem("Grand Cross", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addMarItem("Ragged Baby", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addMarItem("Oripathy", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addMarItem("Tarasque", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addMarItem("Frying Pan", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addMarItem("Degeneracy", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addMarItem("Vampiric Cloth", {PSTAVConstellationType.OCCULT})
        if REVEL then
            PSTAVessel_addMarItem("Melting Ice Cream", {PSTAVConstellationType.MUNDANE})
        end
        if Retribution then
            PSTAVessel_addMarItem("Birdfeeder", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        end

        PSTAVessel_addMarItem("Hope", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addMarItem("Faith", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addMarItem("Love", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addMarItem("Shopping Cart", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addMarItem("Holy Hand Grenade", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addMarItem("Ms. Dolly", {PSTAVConstellationType.MUNDANE})
        if REVEL then
            PSTAVessel_addMarItem("Tactical Shovel", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        end
        if Retribution then
            PSTAVessel_addMarItem("Mortar", {PSTAVConstellationType.MUNDANE})
        end
    end

    -- Arachna
    if ARACHNAMOD then
        -- Items
        local function PSTAVessel_addArItem(arItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(arItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Arachna item '" .. arItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Arachna")
        end
        PSTAVessel_addArItem("Mutagen", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addArItem("Lil Arachna", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addArItem("The Yarn", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addArItem("Mechanical Eye", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addArItem("Arachnid's Grip", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addArItem("Dad's Newspaper", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addArItem("3D Glasses", {PSTAVConstellationType.MUNDANE})

        PSTAVessel_addArItem("Arachna's Spool", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addArItem("Divine Cloth", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addArItem("Yarn Heart", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addArItem("Geptameron", {PSTAVConstellationType.DIVINE})
    end

    -- Tainted Treasure Rooms
    if TaintedTreasure then
        -- Items
        local function PSTAVessel_addTtrItem(ttrItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(ttrItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Tainted Treasure Rooms item '" .. ttrItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Tainted Treasure Rooms")
        end
        PSTAVessel_addTtrItem("Atlas", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("The Bad Onion", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addTtrItem("Fork Bender", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addTtrItem("Yearning Page", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT})
        PSTAVessel_addTtrItem("Buzzing Magnets", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Clandestine Card", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addTtrItem("Glad Bombs", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Dionysius", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addTtrItem("Consecration", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addTtrItem("No Options", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addTtrItem("Steamy Surprise", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addTtrItem("Skeleton Lock", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addTtrItem("Salt of Magnesium", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addTtrItem("Whore of Galilee", {PSTAVConstellationType.DIVINE})
        PSTAVessel_addTtrItem("Eternal Candle", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addTtrItem("Overstock", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addTtrItem("Spider Freak", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addTtrItem("Bugulon Super Fan", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addTtrItem("Arrowhead", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addTtrItem("White Belt", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addTtrItem("D-Pad", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addTtrItem("The War Maiden", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("The Basilisk", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("The Poisoned Dart", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("Colored Contacts", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("The Reaper", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("ATG in a Jar", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Dryad's Blessing", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Broodmind", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addTtrItem("Tech Organelle", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Gazemaster", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("Seared Club", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("The Leviathan", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("The Ravenous", {PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("The Sorrowful Shallot", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Overcharged Battery", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Blue Canary", {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addTtrItem("Wormwood", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("The Maelstrom", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("Lil Abyss", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.COSMIC})
        PSTAVessel_addTtrItem("The Sword", {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC})

        -- Battery Items
        table.insert(PSTAVessel.batteryItems, Isaac.GetItemIdByName("Overcharged Battery"))
    end

    -- Sewing Machine
    if SewnMod then
        -- Items
        local function PSTAVessel_addSewItem(sewItemName, types, extraCost)
            PSTAVessel:addConstellationItem(Isaac.GetItemIdByName(sewItemName), types, extraCost or 0, "Sewing Machine")
        end
        PSTAVessel_addSewItem("Doll's Tainted Head", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addSewItem("Doll's Pure Body", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addSewItem("Sewing Box", {PSTAVConstellationType.MUNDANE})
    end

    -- Malware the Forgotten Modern Horseman
    if MalwareHorseman then
        PSTAVessel:addConstellationItem(Isaac.GetItemIdByName("Digital Pony"), {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUNDANE, PSTAVConstellationType.COSMIC}, 0, "Malware & Spam")
    end

    -- Lazy Mattpack
    if MattPack then
        -- Items
        local function PSTAVessel_addMatItem(matItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(matItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Lazy Mattpack item '" .. matItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Lazy Mattpack")
        end
        PSTAVessel_addMatItem("Alt Rock", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addMatItem("Tech Omega", {PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addMatItem("Mutant Mycelium", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addMatItem("Tech 5090", {PSTAVConstellationType.ELEMENTAL})

        -- Knife Items
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Kitchen Knife"))
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Knife Bender"))
    end

    -- Bael
    if BaelMOD then
        -- Items
        local function PSTAVessel_addCatItem(catItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(catItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Bael item '" .. catItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Bael")
        end
        PSTAVessel_addCatItem("The Left Finger", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Surgical Doll", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Squishy Friend", {PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Emblem", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addCatItem("Cat's Candle", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Cat's Nugget", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Top", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Option", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Cat's Bed", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Laxative", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Foot", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Bean", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Glasses", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Onion", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Mushroom", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Sawblade", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Cat's Skeleton", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Scaredy Cat", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addCatItem("Cat Piss", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Mask", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Cat's Colony", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Candy", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Prey", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Cat's Pact", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addCatItem("Cat's Feast", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Contagion", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Missile", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCatItem("Dark Catter", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCatItem("Cat's Blood", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Locket", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DIVINE})
        PSTAVessel_addCatItem("Cat's Contraband", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Egg", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Jellybean", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Ipecat", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCatItem("Cat's Cash", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCatItem("Cat's Cold", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Puzzle", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Belt", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat Squish Toy", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Gacha", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCatItem("Cat's Home", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.COSMIC})
        PSTAVessel_addCatItem("Cat-aracts", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat Tar", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addCatItem("Cat's Bell", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DIVINE})
        PSTAVessel_addCatItem("Cat's Tomb", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC})
        PSTAVessel_addCatItem("Guppy's Skeleton", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Dark Cube", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCatItem("Coin on a String", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCatItem("Cat Boy Jr.", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addCatItem("Gamblers Flesh", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCatItem("Tombmates", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC})

        PSTAVessel_addCatItem("Cat's Nickel", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCatItem("Cat's Reward", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DIVINE})
        PSTAVessel_addCatItem("Cat's Polygon", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addCatItem("Cat's Vigor", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addCatItem("Cat's Master Key", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Razor", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addCatItem("Cat's Skin", {PSTAVConstellationType.OCCULT})
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
        table.insert(PSTAVessel.hairstyles, {path="gfx/characters/extrahair_maggy_01.anm2", sourceMod="Alternate Hairstyles"})
    end

	-- Restored Collection
	if RestoredCollection then
		-- Items
        local function PSTAVessel_addRcItem(rcItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(rcItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Restored Collection item '" .. rcItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Restored Collection")
        end
		PSTAVessel_addRcItem("Stone Bombs", {PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addRcItem("Blank Bombs", {PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addRcItem("Checked Mate", {PSTAVConstellationType.MUNDANE})
		PSTAVessel_addRcItem("​Donkey Jawbone", {PSTAVConstellationType.DEMONIC})
		PSTAVessel_addRcItem("Lucky Seven", {PSTAVConstellationType.MERCANTILE})
		PSTAVessel_addRcItem("Beth's Heart", {PSTAVConstellationType.DIVINE})
		PSTAVessel_addRcItem("Keeper's Rope", {PSTAVConstellationType.MERCANTILE})
		PSTAVessel_addRcItem("Pacifist", {PSTAVConstellationType.DIVINE})
		PSTAVessel_addRcItem("Safety Bombs", {PSTAVConstellationType.MUNDANE})
		PSTAVessel_addRcItem("Ol' Lopper", {PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRcItem("​Max's Head", {PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRcItem("​Pumpkin Mask", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addRcItem("​Tammy's Tail", {PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRcItem("Melted Candle", {PSTAVConstellationType.DIVINE, PSTAVConstellationType.ELEMENTAL})

		PSTAVessel_addRcItem("Lunch Box", {PSTAVConstellationType.MUNDANE})
		PSTAVessel_addRcItem("Book of Despair", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addRcItem("Pill Crusher", {PSTAVConstellationType.MUNDANE})
		PSTAVessel_addRcItem("​Voodoo Pin", {PSTAVConstellationType.OCCULT})
	end

	-- Rune Rooms
	if RuneRooms then
		-- Items
        local function PSTAVessel_addRuneRoomItem(runeRoomItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(runeRoomItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Rune Rooms item '" .. runeRoomItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Rune Rooms")
        end
		PSTAVessel_addRuneRoomItem("Essence of Hagalaz", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addRuneRoomItem("Essence of Jera", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.MERCANTILE})
		PSTAVessel_addRuneRoomItem("Essence of Ehwaz", {PSTAVConstellationType.COSMIC})
		PSTAVessel_addRuneRoomItem("Essence of Dagaz", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.DIVINE})
		PSTAVessel_addRuneRoomItem("Essence of Ansuz", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.OCCULT})
		PSTAVessel_addRuneRoomItem("Essence of Perthro", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.MERCANTILE})
		PSTAVessel_addRuneRoomItem("Essence of Berkano", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRuneRoomItem("Essence of Algiz", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.DIVINE})
		PSTAVessel_addRuneRoomItem("Essence of Gebo", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.MERCANTILE})
		PSTAVessel_addRuneRoomItem("Essence of Kenaz", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addRuneRoomItem("Essence of Fehu", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.MERCANTILE})
		PSTAVessel_addRuneRoomItem("Essence of Othala", {PSTAVConstellationType.COSMIC}, 10)
		PSTAVessel_addRuneRoomItem("Essence of Ingwaz", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.MERCANTILE})
		PSTAVessel_addRuneRoomItem("Essence of Sowilo", {PSTAVConstellationType.COSMIC, PSTAVConstellationType.ELEMENTAL})
	end

    ---- Preyn's Collections ----
	-- Cursed Collection
	if CURCOL then
		-- Items
        local function PSTAVessel_addCurColItem(curColItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(curColItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Cursed Collection item '" .. curColItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Cursed Collection")
        end
		PSTAVessel_addCurColItem("Siren's call", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addCurColItem("Anathema", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.DEMONIC})
		PSTAVessel_addCurColItem("Pentacle", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addCurColItem("Fettered heart", {PSTAVConstellationType.DEMONIC})
		PSTAVessel_addCurColItem("Secretion", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addCurColItem("Revenir", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addCurColItem("Reverse of the tower", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addCurColItem("Papyrus rags", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addCurColItem("Chained spikey", {PSTAVConstellationType.DEMONIC})
		PSTAVessel_addCurColItem("Lil heretic", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addCurColItem("Mended knife", {PSTAVConstellationType.OCCULT, PSTAVConstellationType.MUNDANE})

		PSTAVessel_addCurColItem("Soul cleaver", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addCurColItem("Cursed flame", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.OCCULT})

		-- Knife Items
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Soul cleaver"))
        table.insert(PSTAVessel.knifeItems, Isaac.GetItemIdByName("Mended knife"))
	end

	-- Quarry Collection
	if QUACOL then
		-- Items
        local function PSTAVessel_addQuaColItem(quaColItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(quaColItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Quarry Collection item '" .. quaColItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Quarry Collection")
        end
		PSTAVessel_addQuaColItem("Gideon's gaze", {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addQuaColItem("Limestone carving", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addQuaColItem("Premature detonation", {PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addQuaColItem("Singed stones", {PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addQuaColItem("Hot wheels", {PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addQuaColItem("Broken shell", {PSTAVConstellationType.ELEMENTAL})

		PSTAVessel_addQuaColItem("Pile of bones", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addQuaColItem("Quake oats", {PSTAVConstellationType.ELEMENTAL})
	end

	-- Golden Collection
	if GOLCG then
		-- Items
        local function PSTAVessel_addGolCgItem(golCgItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(golCgItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Golden Collection item '" .. golCgItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Golden Collection")
		end
        PSTAVessel_addGolCgItem("Temptation", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Gold rope", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Childrens fund", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Stolen placard", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Black card", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.OCCULT})
        PSTAVessel_addGolCgItem("Abundance", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Fancy brooch", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Spinning cent", {PSTAVConstellationType.MERCANTILE})

        PSTAVessel_addGolCgItem("Molten dime", {PSTAVConstellationType.MERCANTILE, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addGolCgItem("Golden god!", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Quality stamp", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Silver lacquered chisel", {PSTAVConstellationType.MERCANTILE})
        PSTAVessel_addGolCgItem("Ancient hourglass", {PSTAVConstellationType.COSMIC})
	end

	-- Rotten Collection
	if ROTCG then
		-- Items
        local function PSTAVessel_addRotCgItem(rotCgItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(rotCgItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Rotten Collection item '" .. rotCgItemName .. "' found (mod compat).")
                return
            end
			PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Rotten Collection")
		end
		PSTAVessel_addRotCgItem("Necrosis", {PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRotCgItem("Knout", {PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRotCgItem("Cube of rot", {PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRotCgItem("Mother's spine", {PSTAVConstellationType.MUTAGENIC})
		PSTAVessel_addRotCgItem("Rotten gut", {PSTAVConstellationType.MUTAGENIC})
	end

	-- Sewage Collection
	if SEWCOL then
        -- Items
        local function PSTAVessel_addSewColItem(sewColItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(sewColItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Sewage Collection item '" .. sewColItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Sewage Collection")
        end
        PSTAVessel_addSewColItem("Haunted rose", {PSTAVConstellationType.OCCULT})
        PSTAVessel_addSewColItem("Plastic bag", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.MUNDANE})
        PSTAVessel_addSewColItem("Slippy tooth", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addSewColItem("Whirling leech", {PSTAVConstellationType.MUTAGENIC})
        PSTAVessel_addSewColItem("Willo", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})
        PSTAVessel_addSewColItem("Driftwood", {PSTAVConstellationType.ELEMENTAL})

        PSTAVessel_addSewColItem("The pail", {PSTAVConstellationType.MUTAGENIC})
	end

	-- Toybox Collection
	if TOYCG then
		-- Items
        local function PSTAVessel_addToyCgItem(toyCgItemName, types, extraCost)
            local tmpItem = Isaac.GetItemIdByName(toyCgItemName)
            if tmpItem == -1 then
                print("[Astral Vessel] Warning: No Toybox Collection item '" .. toyCgItemName .. "' found (mod compat).")
                return
            end
            PSTAVessel:addConstellationItem(tmpItem, types, extraCost or 0, "Toybox Collection")
		end
		PSTAVessel_addToyCgItem("Ancestral assistance", {PSTAVConstellationType.DIVINE})
		PSTAVessel_addToyCgItem("Old relic", {PSTAVConstellationType.MUNDANE})
		PSTAVessel_addToyCgItem("Jar of air", {PSTAVConstellationType.ELEMENTAL})
		PSTAVessel_addToyCgItem("Witch wand", {PSTAVConstellationType.OCCULT})
		PSTAVessel_addToyCgItem("Sigil of knowledge", {PSTAVConstellationType.COSMIC})
		PSTAVessel_addToyCgItem("Blank", {PSTAVConstellationType.MUNDANE})
		PSTAVessel_addToyCgItem("Wow factor!", {PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.ELEMENTAL})

		PSTAVessel_addToyCgItem("Concussion", {PSTAVConstellationType.MUNDANE})
	end

    PSTAVessel:sortConstellationItems()
    PSTAVessel:updateAccessoryMap()
    modCompatInit = true
end

include("scripts.modCompatSteven")