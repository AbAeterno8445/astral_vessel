---@enum PSTAVConstellationType
PSTAVConstellationType = {
    DIVINE = "Divine",
    DEMONIC = "Demonic",
    OCCULT = "Occult",
    MERCANTILE = "Mercantile",
    ELEMENTAL = "Elemental",
    MUNDANE = "Mundane",
    MUTAGENIC = "Mutagenic",
    COSMIC = "Cosmic",
    --OTHERWORLDLY = "Otherworldly"
}

-- Constellation tier names
PSTAVessel.constelTierNames = {"Lesser", "Greater", "Empyrean"}

-- Constellation affinity values (lesser, greater, empyrean)
PSTAVessel.constelAffinityWorth = {5, 10, 15}

-- Constellation colors
PSTAVessel.constelKColors = {
    [PSTAVConstellationType.DIVINE] = PSTAVessel:RGBKColor(111, 229, 252),
    [PSTAVConstellationType.DEMONIC] = PSTAVessel:RGBKColor(189, 29, 11),
    [PSTAVConstellationType.OCCULT] = PSTAVessel:RGBKColor(145, 77, 255),
    [PSTAVConstellationType.MERCANTILE] = PSTAVessel:RGBKColor(240, 225, 22),
    [PSTAVConstellationType.ELEMENTAL] = PSTAVessel:RGBKColor(204, 85, 0),
    [PSTAVConstellationType.MUNDANE] = PSTAVessel:RGBKColor(196, 196, 196),
    [PSTAVConstellationType.MUTAGENIC] = PSTAVessel:RGBKColor(199, 78, 187),
    [PSTAVConstellationType.COSMIC] = PSTAVessel:RGBKColor(23, 74, 227)
}
PSTAVessel.constelColors = {}
for tmpType, kcol in pairs(PSTAVessel.constelKColors) do
    PSTAVessel.constelColors[tmpType] = Color(kcol.Red, kcol.Green, kcol.Blue, kcol.Alpha)
end

-- Constellation allocation + affinity tracker
-- e.g. Cherub constellation data: PSTAVessel.constelAlloc["Divine"]["Cherub"] = {tier = 1, max = 21, alloc = 5, affinity = 1}
-- e.g. Total Divine affinity: PSTAVessel.constelAlloc["Divine"].affinity
PSTAVessel.constelAlloc = {
    [PSTAVConstellationType.DIVINE] = {},
    [PSTAVConstellationType.DEMONIC] = {},
    [PSTAVConstellationType.OCCULT] = {},
    [PSTAVConstellationType.MERCANTILE] = {},
    [PSTAVConstellationType.ELEMENTAL] = {},
    [PSTAVConstellationType.MUNDANE] = {},
    [PSTAVConstellationType.MUTAGENIC] = {},
    [PSTAVConstellationType.COSMIC] = {}
}

-- How many base constellations of each tier are allocated
PSTAVessel.tiersAlloc = {0, 0, 0}

-- Constellation item base affinity costs, based on quality
PSTAVessel.constelBaseItemCosts = {
    [0] = 2,
    [1] = 4,
    [2] = 8,
    [3] = 15
}

-- Per-item-type total affinity cost, including extra
PSTAVessel.constelItemCosts = {}

-- Constellation item pools
PSTAVessel.constelItems = {
    [PSTAVConstellationType.DIVINE] = {Q3={}, Q2={}, Q1={}, Q0={}},
    [PSTAVConstellationType.DEMONIC] = {Q3={}, Q2={}, Q1={}, Q0={}},
    [PSTAVConstellationType.OCCULT] = {Q3={}, Q2={}, Q1={}, Q0={}},
    [PSTAVConstellationType.MERCANTILE] = {Q3={}, Q2={}, Q1={}, Q0={}},
    [PSTAVConstellationType.ELEMENTAL] = {Q3={}, Q2={}, Q1={}, Q0={}},
    [PSTAVConstellationType.MUNDANE] = {Q3={}, Q2={}, Q1={}, Q0={}},
    [PSTAVConstellationType.MUTAGENIC] = {Q3={}, Q2={}, Q1={}, Q0={}},
    [PSTAVConstellationType.COSMIC] = {Q3={}, Q2={}, Q1={}, Q0={}}
}
--[[ Item properties example:
{
    item = CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES
    name = "Book Of Virtues"
    types = {"Divine", "Cosmic"}
    gfx = (GfxFileName from ItemConfig entry)
    extraCost = 4 (or nil)
    active = true (or nil)
    qual = 2
}
]]

local tmpAddedItems = {}
-- Add an item to the constellation pool
---@param itemType CollectibleType
---@param itemCategories PSTAVConstellationType[]
function PSTAVessel:addConstellationItem(itemType, itemCategories, extraCost)
    local itemCfg = Isaac.GetItemConfig():GetCollectible(itemType)
    if itemCfg ~= -1 and not PSTAVessel:arrHasValue(tmpAddedItems, itemType) and itemCfg.Quality >= 0 and itemCfg.Quality <= 4 then
        local newEntry = {
            item = itemType,
            types = itemCategories,
            gfx = itemCfg.GfxFileName,
            qual = itemCfg.Quality
        }
        if extraCost then newEntry.extraCost = extraCost end
        if itemCfg.Type == ItemType.ITEM_ACTIVE then newEntry.active = true end

        local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
		if itemName ~= "StringTable::InvalidKey" then newEntry.name = itemName end

        for _, tmpType in ipairs(itemCategories) do
            table.insert(PSTAVessel.constelItems[tmpType]["Q" .. itemCfg.Quality], newEntry)
        end
        table.insert(tmpAddedItems, itemType)

        PSTAVessel.constelItemCosts[itemType] = PSTAVessel.constelBaseItemCosts[itemCfg.Quality] + (extraCost or 0)
    end
end


function PSTAVessel:initConstellationItems()
    ---- DIVINE ----
    local tmpItems = {
        {CollectibleType.COLLECTIBLE_PASCHAL_CANDLE},
        {CollectibleType.COLLECTIBLE_IMMACULATE_HEART},
        {CollectibleType.COLLECTIBLE_SPIRIT_SWORD},
        {CollectibleType.COLLECTIBLE_ACT_OF_CONTRITION},
        {CollectibleType.COLLECTIBLE_STAIRWAY},
        {CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM},
        {CollectibleType.COLLECTIBLE_SALVATION},
        {CollectibleType.COLLECTIBLE_RELIC},
        {CollectibleType.COLLECTIBLE_MITRE},
        {CollectibleType.COLLECTIBLE_HOLY_WATER, {PSTAVConstellationType.ELEMENTAL}},
        {CollectibleType.COLLECTIBLE_HOLY_GRAIL},
        {CollectibleType.COLLECTIBLE_SWORN_PROTECTOR},
        {CollectibleType.COLLECTIBLE_HOLY_LIGHT},
        {CollectibleType.COLLECTIBLE_CENSER},
        {CollectibleType.COLLECTIBLE_SERAPHIM},
        {CollectibleType.COLLECTIBLE_ANGELIC_PRISM},
        {CollectibleType.COLLECTIBLE_TRISAGION},
        {CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES},
        {CollectibleType.COLLECTIBLE_GENESIS},
        {CollectibleType.COLLECTIBLE_URN_OF_SOULS},
        {CollectibleType.COLLECTIBLE_PRAYER_CARD},
        {CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS},
        {CollectibleType.COLLECTIBLE_DIVINE_INTERVENTION},
        {CollectibleType.COLLECTIBLE_MONSTRANCE},
        {CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL},
        {CollectibleType.COLLECTIBLE_SCAPULAR},
        {CollectibleType.COLLECTIBLE_TRINITY_SHIELD},
        {CollectibleType.COLLECTIBLE_HABIT, nil, 8},
        {CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY},
        {CollectibleType.COLLECTIBLE_CIRCLE_OF_PROTECTION},
        {CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE, nil, 8},
        {CollectibleType.COLLECTIBLE_REDEMPTION},
        {CollectibleType.COLLECTIBLE_LIL_DELIRIUM, {PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_FATES_REWARD},
        {CollectibleType.COLLECTIBLE_JAR_OF_WISPS},
        {CollectibleType.COLLECTIBLE_SOUL_LOCKET},
        {CollectibleType.COLLECTIBLE_BIBLE},
        {CollectibleType.COLLECTIBLE_CELTIC_CROSS},
        {CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION},
        {CollectibleType.COLLECTIBLE_HALLOWED_GROUND},
        {CollectibleType.COLLECTIBLE_BREATH_OF_LIFE},
        {CollectibleType.COLLECTIBLE_DEAD_SEA_SCROLLS},
        {CollectibleType.COLLECTIBLE_CRACK_THE_SKY}
    }
    local function PSTAV_addConstItems(itemList, baseType)
        for _, tmpItem in ipairs(itemList) do
            local tmpTypes = {baseType}
            if tmpItem[2] then tmpTypes = {table.unpack(tmpTypes), table.unpack(tmpItem[2])} end

            local tmpExtra = nil
            if tmpItem[3] then tmpExtra = tmpItem[3] end

            PSTAVessel:addConstellationItem(tmpItem[1], tmpTypes, tmpExtra)
        end
    end
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.DIVINE)

    ---- DEMONIC ----
    tmpItems = {
        {CollectibleType.COLLECTIBLE_EYE_OF_THE_OCCULT, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_OCULAR_RIFT},
        {CollectibleType.COLLECTIBLE_GELLO, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_DEAD_CAT},
        {CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT, nil, 7},
        {CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER, {PSTAVConstellationType.MERCANTILE}},
        {CollectibleType.COLLECTIBLE_CONTRACT_FROM_BELOW, {PSTAVConstellationType.MERCANTILE}},
        {CollectibleType.COLLECTIBLE_DARK_MATTER, {PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_ROTTEN_BABY, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_DARK_BUM},
        {CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID},
        {CollectibleType.COLLECTIBLE_ATHAME, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_CHAOS},
        {CollectibleType.COLLECTIBLE_EYE_OF_BELIAL},
        {CollectibleType.COLLECTIBLE_LEMEGETON, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_FORGET_ME_NOW, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_FALSE_PHD},
        {CollectibleType.COLLECTIBLE_LIL_ABADDON},
        {CollectibleType.COLLECTIBLE_HUNGRY_SOUL, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_BLOODY_GUST},
        {CollectibleType.COLLECTIBLE_BERSERK, nil, 4},
        {CollectibleType.COLLECTIBLE_DEMON_BABY},
        {CollectibleType.COLLECTIBLE_OUIJA_BOARD, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON},
        {CollectibleType.COLLECTIBLE_BLOODY_LUST},
        {CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_GIMPY},
        {CollectibleType.COLLECTIBLE_LIL_BRIMSTONE},
        {CollectibleType.COLLECTIBLE_CAMBION_CONCEPTION},
        {CollectibleType.COLLECTIBLE_DEATHS_LIST, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_DARK_ARTS, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL},
        {CollectibleType.COLLECTIBLE_BOOK_OF_SIN},
        {CollectibleType.COLLECTIBLE_ANIMA_SOLA},
        {CollectibleType.COLLECTIBLE_VENGEFUL_SPIRIT},
        {CollectibleType.COLLECTIBLE_SANGUINE_BOND},
        {CollectibleType.COLLECTIBLE_POUND_OF_FLESH, {PSTAVConstellationType.MERCANTILE}},
        {CollectibleType.COLLECTIBLE_BLOOD_OATH, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_2SPOOKY},
        {CollectibleType.COLLECTIBLE_LOKIS_HORNS},
        {CollectibleType.COLLECTIBLE_GHOST_BABY},
        {CollectibleType.COLLECTIBLE_BLACK_POWDER, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_EMPTY_HEART, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_NECRONOMICON, {PSTAVConstellationType.OCCULT}},
        {CollectibleType.COLLECTIBLE_MONSTER_MANUAL},
        {CollectibleType.COLLECTIBLE_RAZOR_BLADE, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_BLOOD_RIGHTS}
    }
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.DEMONIC)

    ---- OCCULT ----
    tmpItems = {
        {CollectibleType.COLLECTIBLE_BRITTLE_BONES},
        {CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_HOST_HAT},
        {CollectibleType.COLLECTIBLE_DRY_BABY},
        {CollectibleType.COLLECTIBLE_ECHO_CHAMBER},
        {CollectibleType.COLLECTIBLE_SPOON_BENDER},
        {CollectibleType.COLLECTIBLE_TRANSCENDENCE},
        {CollectibleType.COLLECTIBLE_BACKSTABBER},
        {CollectibleType.COLLECTIBLE_CARD_READING, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD},
        {CollectibleType.COLLECTIBLE_SUMPTORIUM},
        {CollectibleType.COLLECTIBLE_RED_KEY, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_CRYSTAL_BALL, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_BONE_SPURS},
        {CollectibleType.COLLECTIBLE_SLIPPED_RIB},
        {CollectibleType.COLLECTIBLE_POINTY_RIB},
        {CollectibleType.COLLECTIBLE_EVIL_CHARM},
        {CollectibleType.COLLECTIBLE_AKELDAMA, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION},
        {CollectibleType.COLLECTIBLE_TAROT_CLOTH},
        {CollectibleType.COLLECTIBLE_SERPENTS_KISS, {PSTAVConstellationType.ELEMENTAL}},
        {CollectibleType.COLLECTIBLE_VOODOO_HEAD},
        {CollectibleType.COLLECTIBLE_MY_REFLECTION, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_INFAMY},
        {CollectibleType.COLLECTIBLE_BLUE_MAP, {PSTAVConstellationType.MERCANTILE}},
        {CollectibleType.COLLECTIBLE_RED_CANDLE, {PSTAVConstellationType.ELEMENTAL}},
        {CollectibleType.COLLECTIBLE_DECK_OF_CARDS, {PSTAVConstellationType.MERCANTILE}},
        {CollectibleType.COLLECTIBLE_JAW_BONE},
        {CollectibleType.COLLECTIBLE_IT_HURTS},
        {CollectibleType.COLLECTIBLE_BETRAYAL},
        {CollectibleType.COLLECTIBLE_LIL_HAUNT},
        {CollectibleType.COLLECTIBLE_CRACKED_ORB},
        {CollectibleType.COLLECTIBLE_CHARM_VAMPIRE},
        {CollectibleType.COLLECTIBLE_YUCK_HEART, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_TELEPATHY_BOOK},
        {CollectibleType.COLLECTIBLE_DULL_RAZOR},
        {CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER, nil, -8}
    }
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.OCCULT)

    ---- MERCANTILE ----
    tmpItems = {
        {CollectibleType.COLLECTIBLE_3_DOLLAR_BILL},
        {CollectibleType.COLLECTIBLE_THERES_OPTIONS},
        {CollectibleType.COLLECTIBLE_MORE_OPTIONS, nil, 5},
        {CollectibleType.COLLECTIBLE_SACK_OF_SACKS},
        {CollectibleType.COLLECTIBLE_KEEPERS_SACK},
        {CollectibleType.COLLECTIBLE_SACK_HEAD},
        {CollectibleType.COLLECTIBLE_HUMBLEING_BUNDLE},
        {CollectibleType.COLLECTIBLE_MR_ME},
        {CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING},
        {CollectibleType.COLLECTIBLE_D100},
        {CollectibleType.COLLECTIBLE_ETERNAL_D6},
        {CollectibleType.COLLECTIBLE_MEMBER_CARD},
        {CollectibleType.COLLECTIBLE_MIDAS_TOUCH},
        {CollectibleType.COLLECTIBLE_STARTER_DECK},
        {CollectibleType.COLLECTIBLE_LIL_CHEST, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER},
        {CollectibleType.COLLECTIBLE_EYE_OF_GREED},
        {CollectibleType.COLLECTIBLE_LUCKY_FOOT, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_MYSTERY_SACK},
        {CollectibleType.COLLECTIBLE_RESTOCK},
        {CollectibleType.COLLECTIBLE_PAY_TO_PLAY},
        {CollectibleType.COLLECTIBLE_DEEP_POCKETS},
        {CollectibleType.COLLECTIBLE_COMPASS, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_STEAM_SALE},
        {CollectibleType.COLLECTIBLE_BOMB_BAG},
        {CollectibleType.COLLECTIBLE_KEEPERS_BOX},
        {CollectibleType.COLLECTIBLE_CROOKED_PENNY},
        {CollectibleType.COLLECTIBLE_D20},
        {CollectibleType.COLLECTIBLE_SACK_OF_PENNIES},
        {CollectibleType.COLLECTIBLE_FANNY_PACK, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_BOGO_BOMBS, nil, 4},
        {CollectibleType.COLLECTIBLE_GREEDS_GULLET},
        {CollectibleType.COLLECTIBLE_PIGGY_BANK},
        {CollectibleType.COLLECTIBLE_BUM_FRIEND},
        {CollectibleType.COLLECTIBLE_BUMBO},
        {CollectibleType.COLLECTIBLE_GOLDEN_RAZOR},
        {CollectibleType.COLLECTIBLE_MAGIC_FINGERS},
        {CollectibleType.COLLECTIBLE_WOODEN_NICKEL},
        {CollectibleType.COLLECTIBLE_MOVING_BOX},
        {CollectibleType.COLLECTIBLE_D10},
        {CollectibleType.COLLECTIBLE_PORTABLE_SLOT, nil, 2},
        {CollectibleType.COLLECTIBLE_COUPON}
    }
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.MERCANTILE)

    ---- ELEMENTAL ----
    tmpItems = {
        {CollectibleType.COLLECTIBLE_BIRDS_EYE},
        {CollectibleType.COLLECTIBLE_MOMS_CONTACTS},
        {CollectibleType.COLLECTIBLE_PLAYDOUGH_COOKIE, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_FRUIT_CAKE},
        {CollectibleType.COLLECTIBLE_JACOBS_LADDER},
        {CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO},
        {CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_URANUS, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_NEPTUNUS, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_SCORPIO, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_TOXIC_SHOCK, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_SINUS_INFECTION, {PSTAVConstellationType.MUNDANE, PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_EXPLOSIVO},
        {CollectibleType.COLLECTIBLE_LODESTONE},
        {CollectibleType.COLLECTIBLE_FIRE_MIND},
        {CollectibleType.COLLECTIBLE_FREEZER_BABY},
        {CollectibleType.COLLECTIBLE_120_VOLT},
        {CollectibleType.COLLECTIBLE_MOMS_RAZOR, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_AQUARIUS, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_PISCES, {PSTAVConstellationType.COSMIC}},
        {CollectibleType.COLLECTIBLE_CONTAGION, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_LACHRYPHAGY, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_ROTTEN_TOMATO},
        {CollectibleType.COLLECTIBLE_IRON_BAR, {PSTAVConstellationType.MUNDANE}},
        {CollectibleType.COLLECTIBLE_FLAT_STONE},
        {CollectibleType.COLLECTIBLE_CANDLE},
        {CollectibleType.COLLECTIBLE_CUBE_BABY},
        {CollectibleType.COLLECTIBLE_GLAUCOMA, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_DEAD_TOOTH, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_COMMON_COLD, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_DEPRESSION},
        {CollectibleType.COLLECTIBLE_ANEMIC, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_ISAACS_TEARS},
        {CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR}
    }
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.ELEMENTAL)

    ---- MUNDANE ----
    tmpItems = {
        {CollectibleType.COLLECTIBLE_EYE_DROPS},
        {CollectibleType.COLLECTIBLE_CAR_BATTERY},
        {CollectibleType.COLLECTIBLE_CHARGED_BABY},
        {CollectibleType.COLLECTIBLE_JUMPER_CABLES},
        {CollectibleType.COLLECTIBLE_ISAACS_TOMB},
        {CollectibleType.COLLECTIBLE_CUPIDS_ARROW},
        {CollectibleType.COLLECTIBLE_CHOCOLATE_MILK},
        {CollectibleType.COLLECTIBLE_LUMP_OF_COAL},
        {CollectibleType.COLLECTIBLE_TOUGH_LOVE},
        {CollectibleType.COLLECTIBLE_RUBBER_CEMENT},
        {CollectibleType.COLLECTIBLE_APPLE},
        {CollectibleType.COLLECTIBLE_LEAD_PENCIL},
        {CollectibleType.COLLECTIBLE_CAMO_UNDIES},
        {CollectibleType.COLLECTIBLE_BROKEN_MODEM},
        {CollectibleType.COLLECTIBLE_DADS_RING},
        {CollectibleType.COLLECTIBLE_EVERYTHING_JAR},
        {CollectibleType.COLLECTIBLE_SMELTER},
        {CollectibleType.COLLECTIBLE_FORTUNE_COOKIE},
        {CollectibleType.COLLECTIBLE_DREAM_CATCHER},
        {CollectibleType.COLLECTIBLE_4_5_VOLT},
        {CollectibleType.COLLECTIBLE_9_VOLT},
        {CollectibleType.COLLECTIBLE_BATTERY},
        {CollectibleType.COLLECTIBLE_SUPLEX},
        {CollectibleType.COLLECTIBLE_TREASURE_MAP},
        {CollectibleType.COLLECTIBLE_MOMS_WIG},
        {CollectibleType.COLLECTIBLE_LOST_CONTACT},
        {CollectibleType.COLLECTIBLE_MOMS_PERFUME},
        {CollectibleType.COLLECTIBLE_BALL_OF_TAR},
        {CollectibleType.COLLECTIBLE_NUMBER_TWO},
        {CollectibleType.COLLECTIBLE_ANALOG_STICK},
        {CollectibleType.COLLECTIBLE_SHOOP_DA_WHOOP},
        {CollectibleType.COLLECTIBLE_WE_NEED_TO_GO_DEEPER},
        {CollectibleType.COLLECTIBLE_JAR_OF_FLIES},
        {CollectibleType.COLLECTIBLE_MOMS_BOX, nil, 4},
        {CollectibleType.COLLECTIBLE_POTATO_PEELER},
        {CollectibleType.COLLECTIBLE_SHARP_STRAW},
        {CollectibleType.COLLECTIBLE_SPRINKLER},
        {CollectibleType.COLLECTIBLE_DIRTY_MIND},
        {CollectibleType.COLLECTIBLE_MAGNETO},
        {CollectibleType.COLLECTIBLE_MOMS_EYESHADOW},
        {CollectibleType.COLLECTIBLE_BROKEN_WATCH},
        {CollectibleType.COLLECTIBLE_MILK},
        {CollectibleType.COLLECTIBLE_SHARD_OF_GLASS},
        {CollectibleType.COLLECTIBLE_SAMSONS_CHAINS},
        {CollectibleType.COLLECTIBLE_NIGHT_LIGHT},
        {CollectibleType.COLLECTIBLE_MARKED},
        {CollectibleType.COLLECTIBLE_FREE_LEMONADE},
        {CollectibleType.COLLECTIBLE_MOMS_BRACELET},
        {CollectibleType.COLLECTIBLE_MEAT_CLEAVER},
        {CollectibleType.COLLECTIBLE_SPIN_TO_WIN},
        {CollectibleType.COLLECTIBLE_MR_BOOM},
        {CollectibleType.COLLECTIBLE_MOMS_BRA},
        {CollectibleType.COLLECTIBLE_HOURGLASS},
        {CollectibleType.COLLECTIBLE_DOCTORS_REMOTE},
        {CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS},
        {CollectibleType.COLLECTIBLE_NOTCHED_AXE},
        {CollectibleType.COLLECTIBLE_HOW_TO_JUMP},
        {CollectibleType.COLLECTIBLE_BOX_OF_SPIDERS, {PSTAVConstellationType.MUTAGENIC}},
        {CollectibleType.COLLECTIBLE_BUTTER_BEAN},
        {CollectibleType.COLLECTIBLE_SCISSORS},
        {CollectibleType.COLLECTIBLE_BOOMERANG},
        {CollectibleType.COLLECTIBLE_MEGA_BEAN},
        {CollectibleType.COLLECTIBLE_TEAR_DETONATOR},
        {CollectibleType.COLLECTIBLE_METRONOME},
        {CollectibleType.COLLECTIBLE_PAUSE},
        {CollectibleType.COLLECTIBLE_BLACK_BEAN},
        {CollectibleType.COLLECTIBLE_LINGER_BEAN},
        {CollectibleType.COLLECTIBLE_POOP},
        {CollectibleType.COLLECTIBLE_MOMS_PAD},
        {CollectibleType.COLLECTIBLE_KAMIKAZE, nil, 2},
        {CollectibleType.COLLECTIBLE_LEMON_MISHAP},
        {CollectibleType.COLLECTIBLE_BEAN},
        {CollectibleType.COLLECTIBLE_THE_JAR},
        {CollectibleType.COLLECTIBLE_ERASER},
        {CollectibleType.COLLECTIBLE_PLACEBO}
    }
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.MUNDANE)

    ---- MUTAGENIC ----
    tmpItems = {
        {CollectibleType.COLLECTIBLE_HEARTBREAK, nil, 15},
        {CollectibleType.COLLECTIBLE_MUCORMYCOSIS},
        {CollectibleType.COLLECTIBLE_WORM_FRIEND},
        {CollectibleType.COLLECTIBLE_FRIEND_FINDER},
        {CollectibleType.COLLECTIBLE_JELLY_BELLY},
        {CollectibleType.COLLECTIBLE_PARASITE},
        {CollectibleType.COLLECTIBLE_PROPTOSIS},
        {CollectibleType.COLLECTIBLE_MUTANT_SPIDER, nil, 5},
        {CollectibleType.COLLECTIBLE_DADDY_LONGLEGS},
        {CollectibleType.COLLECTIBLE_MULLIGAN},
        {CollectibleType.COLLECTIBLE_INFESTATION_2},
        {CollectibleType.COLLECTIBLE_PARASITOID},
        {CollectibleType.COLLECTIBLE_EUTHANASIA},
        {CollectibleType.COLLECTIBLE_LITTLE_HORN},
        {CollectibleType.COLLECTIBLE_INNER_CHILD},
        {CollectibleType.COLLECTIBLE_VANISHING_TWIN},
        {CollectibleType.COLLECTIBLE_HEMOPTYSIS},
        {CollectibleType.COLLECTIBLE_HYPERCOAGULATION},
        {CollectibleType.COLLECTIBLE_SPIDER_BITE},
        {CollectibleType.COLLECTIBLE_CUBE_OF_MEAT},
        {CollectibleType.COLLECTIBLE_MONSTROS_LUNG},
        {CollectibleType.COLLECTIBLE_HIVE_MIND},
        {CollectibleType.COLLECTIBLE_BIG_FAN},
        {CollectibleType.COLLECTIBLE_HALO_OF_FLIES},
        {CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION},
        {CollectibleType.COLLECTIBLE_PEEPER},
        {CollectibleType.COLLECTIBLE_SMART_FLY},
        {CollectibleType.COLLECTIBLE_BLUE_BABYS_ONLY_FRIEND},
        {CollectibleType.COLLECTIBLE_LOST_FLY},
        {CollectibleType.COLLECTIBLE_KIDNEY_STONE},
        {CollectibleType.COLLECTIBLE_POLYDACTYLY},
        {CollectibleType.COLLECTIBLE_LIL_MONSTRO},
        {CollectibleType.COLLECTIBLE_ACID_BABY},
        {CollectibleType.COLLECTIBLE_BUDDY_IN_A_BOX},
        {CollectibleType.COLLECTIBLE_MONGO_BABY},
        {CollectibleType.COLLECTIBLE_LARYNX},
        {CollectibleType.COLLECTIBLE_EYE_SORE},
        {CollectibleType.COLLECTIBLE_CANDY_HEART},
        {CollectibleType.COLLECTIBLE_GIANT_CELL},
        {CollectibleType.COLLECTIBLE_VASCULITIS},
        {CollectibleType.COLLECTIBLE_GNAWED_LEAF},
        {CollectibleType.COLLECTIBLE_PUNCHING_BAG},
        {CollectibleType.COLLECTIBLE_SISSY_LONGLEGS},
        {CollectibleType.COLLECTIBLE_FOREVER_ALONE},
        {CollectibleType.COLLECTIBLE_RAINBOW_BABY},
        {CollectibleType.COLLECTIBLE_E_COLI},
        {CollectibleType.COLLECTIBLE_FRIEND_ZONE},
        {CollectibleType.COLLECTIBLE_GODS_FLESH},
        {CollectibleType.COLLECTIBLE_BURSTING_SACK, nil, 2},
        {CollectibleType.COLLECTIBLE_PAPA_FLY},
        {CollectibleType.COLLECTIBLE_VARICOSE_VEINS},
        {CollectibleType.COLLECTIBLE_FINGER},
        {CollectibleType.COLLECTIBLE_LARGE_ZIT},
        {CollectibleType.COLLECTIBLE_BLOODSHOT_EYE},
        {CollectibleType.COLLECTIBLE_ANGRY_FLY},
        {CollectibleType.COLLECTIBLE_POP},
        {CollectibleType.COLLECTIBLE_TINYTOMA},
        {CollectibleType.COLLECTIBLE_GEMINI},
        {CollectibleType.COLLECTIBLE_WAVY_CAP},
        {CollectibleType.COLLECTIBLE_YUM_HEART},
        {CollectibleType.COLLECTIBLE_SPIDER_BUTT},
        {CollectibleType.COLLECTIBLE_IBS},
        {CollectibleType.COLLECTIBLE_INFESTATION},
        {CollectibleType.COLLECTIBLE_SKATOLE, nil, 4},
        {CollectibleType.COLLECTIBLE_SPIDERBABY},
        {CollectibleType.COLLECTIBLE_ISAACS_HEART},
        {CollectibleType.COLLECTIBLE_OBSESSED_FAN},
        {CollectibleType.COLLECTIBLE_BEST_BUD},
        {CollectibleType.COLLECTIBLE_FLUSH},
        {CollectibleType.COLLECTIBLE_BOBS_BRAIN},
        {CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD}
    }
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.MUTAGENIC)

    ---- COSMIC ----
    tmpItems = {
        {CollectibleType.COLLECTIBLE_PLUTO},
        {CollectibleType.COLLECTIBLE_SAGITTARIUS},
        {CollectibleType.COLLECTIBLE_TRACTOR_BEAM},
        {CollectibleType.COLLECTIBLE_TELEPORT_2},
        {CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS},
        {CollectibleType.COLLECTIBLE_SOL},
        {CollectibleType.COLLECTIBLE_LUNA},
        {CollectibleType.COLLECTIBLE_VENUS},
        {CollectibleType.COLLECTIBLE_SATURNUS},
        {CollectibleType.COLLECTIBLE_ANTI_GRAVITY},
        {CollectibleType.COLLECTIBLE_VIRGO},
        {CollectibleType.COLLECTIBLE_TAURUS},
        {CollectibleType.COLLECTIBLE_ZODIAC},
        {CollectibleType.COLLECTIBLE_LIL_PORTAL},
        {CollectibleType.COLLECTIBLE_BLACK_HOLE},
        {CollectibleType.COLLECTIBLE_TELEKINESIS},
        {CollectibleType.COLLECTIBLE_TINY_PLANET},
        {CollectibleType.COLLECTIBLE_TELEPORT}
    }
    PSTAV_addConstItems(tmpItems, PSTAVConstellationType.COSMIC)
end