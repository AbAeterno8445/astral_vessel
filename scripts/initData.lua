PSTAVessel.charType = Isaac.GetPlayerTypeByName("Astral Vessel")

PSTAVessel.modCooldowns = {
    lightBeamHit = 0,
    palaChampSwords = 0,
    squeezeBloodStone = 0,
    tempSpeedOnKill = 0,
    roomClearIncubus = 0,
    undeadSummonTears = 0,
    dmgUntilKill = 0,
    poisonVialKillBuff = 0,
    meteorEmber = 0,
    scorpionHitTears = 0,
    ragingEnergy = 0,
    frozenMobTearBuff = 0,
    blizzardSnowstorm = 0,
    viperineLash = 0
}
PSTAVessel.firingCooldowns = {
    ritualPurpleFlame = 0
}
PSTAVessel.updateTrackers = {
    eternalHearts = 0,
    redHearts = 0,
    soulHearts = 0,
    blackHearts = 0
}
PSTAVessel.floorFirstUpdate = false
PSTAVessel.roomFirstFire = false

PSTAVessel.carrionMobs = {}
PSTAVessel.fusilladeEmbers = 0
PSTAVessel.fusilladeEmberAng = 0
PSTAVessel.fusilladeEmberDist = 30
PSTAVessel.fusilladeDelay = 70
PSTAVessel.spiralAbilityAng = 0

PSTAVessel.charUnlocks = {}
PSTAVessel.charLoadouts = {}
PSTAVessel.currentLoadout = "1"
PSTAVessel.maxLoadouts = 15
PSTAVessel.accessoryLimit = 5

-- Character save data (for loadouts)
function PSTAVessel:initCharData()
    PSTAVessel.charColor = Color(1, 1, 1, 1)
    PSTAVessel.charHair = nil
    PSTAVessel.charHairColor = Color(1, 1, 1, 1)
    PSTAVessel.charFace = nil
    PSTAVessel.charAccessories = {}
    PSTAVessel.charStartItems = {}

    PSTAVessel.corpseRaiserChoice = {1, 1, 1}
end
PSTAVessel:initCharData()

PSTAVessel.unlocksData = {
    ["AVesselExtraItem1"] = {
        reqs = {"Mom"},
        desc = "Defeat Mom: +1 item choice.",
        func = function() PSTAVessel.charMaxStartItems = PSTAVessel.charMaxStartItems + 1 end
    },
    ["AVesselLesser1"] = {
        reqs = {CompletionType.MOMS_HEART},
        desc = "Defeat Mom's Heart/It Lives: +1 lesser constellation choice.",
        func = function() PSTAVessel.charMaxConsts[1] = PSTAVessel.charMaxConsts[1] + 1 end
    },
    ["AVesselLesser2"] = {
        reqs = {CompletionType.MEGA_SATAN},
        desc = "Defeat Mega Satan: +1 lesser constellation choice.",
        func = function() PSTAVessel.charMaxConsts[1] = PSTAVessel.charMaxConsts[1] + 1 end
    },
    ["AVesselActives"] = {
        reqs = {CompletionType.BOSS_RUSH},
        desc = "Complete the Boss Rush: Can now pick a starting active item.",
        func = function() PSTAVessel.charActivesAllowed = true end
    },
    ["AVesselQual3"] = {
        reqs = {CompletionType.HUSH .. "hard"},
        desc = "Defeat Hush (hard mode): Can now pick items of up to quality 3.",
        func = function() PSTAVessel.charMaxQuality = 3 end
    },
    ["AVesselExtraItem2"] = {
        reqs = {CompletionType.SATAN .. "hard", CompletionType.LAMB .. "hard"},
        desc = "Defeat Satan (hard mode) + The Lamb (hard mode): +1 item choice.",
        func = function() PSTAVessel.charMaxStartItems = PSTAVessel.charMaxStartItems + 1 end
    },
    ["AVesselGreater1"] = {
        reqs = {CompletionType.ISAAC .. "hard", CompletionType.BLUE_BABY .. "hard"},
        desc = "Defeat Isaac (hard mode) + Blue Baby (hard mode): +1 greater constellation choice.",
        func = function() PSTAVessel.charMaxConsts[2] = PSTAVessel.charMaxConsts[2] + 1 end
    },
    ["AVesselEmpyrean1"] = {
        reqs = {CompletionType.BEAST .. "hard", CompletionType.DELIRIUM .. "hard"},
        desc = "Defeat The Beast (hard mode) + Delirium (hard mode): +1 empyrean constellation choice.",
        func = function() PSTAVessel.charMaxConsts[3] = PSTAVessel.charMaxConsts[3] + 1 end
    },
    ["AVesselTrinkets"] = {
        reqs = {CompletionType.MOTHER .. "hard"},
        desc = "Defeat Mother (hard mode): Can now allocate a starting trinket node.",
        func = function() PSTAVessel.charTrinketsAllowed = true end
    },
    ["AVesselExp1"] = {
        reqs = {CompletionType.ULTRA_GREED},
        desc = "Defeat Ultra Greed: Permanent +10% XP gain with Astral Vessel.",
        func = function() PSTAVessel.charXPBonus = PSTAVessel.charXPBonus + 10 end
    }
}
function PSTAVessel:updateUnlockData()
    PSTAVessel.charMaxStartItems = 2
    PSTAVessel.charMaxQuality = 2
    PSTAVessel.charMaxPerQuality = {4, 4, 3, 2, 1}
    PSTAVessel.charActivesAllowed = false
    PSTAVessel.charTrinketsAllowed = false
    PSTAVessel.charTrinketAlloc = false
    PSTAVessel.charMaxConsts = {2, 1, 1}
    PSTAVessel.charXPBonus = 0

    local gameData = Isaac.GetPersistentGameData()
    for achievementName, tmpData in pairs(PSTAVessel.unlocksData) do
        local achievementID = Isaac.GetAchievementIdByName(achievementName)
        if achievementID ~= -1 and gameData:Unlocked(achievementID) and tmpData.func then
            tmpData.func()
        end
    end
end
PSTAVessel:updateUnlockData()

---- HAIRSTYLE DATA
PSTAVessel.hairstyles = {
    {path="none"},
    {path="gfx/characters/Character_002_MagdaleneHead.anm2"},
    {path="gfx/characters/Character_005_EveHead.anm2"},
    {path="gfx/characters/Character_007_SamsonHead.anm2"},
    {path="gfx/characters/Character_LazarusHair1.anm2"},
    {path="gfx/characters/Character_LilithHair.anm2"},
    {path="gfx/characters/Character_001x_BethanyHead.anm2"},
    {path="gfx/characters/Character_002x_JacobHead.anm2"},
    {path="gfx/characters/Character_003x_EsauHead.anm2"},
    {path="gfx/characters/character_b02_magdalene.anm2"},
    {path="gfx/characters/character_b06_eve.anm2"},
    {path="gfx/characters/character_b15_thesoul.anm2"},
    {path="gfx/characters/217_momswig.anm2"},

    -- Custom
    {path="gfx/characters/hair/astralvessel/hair_guardian.anm2"},
    {path="gfx/characters/hair/astralvessel/hair_venus.anm2"},
    {path="gfx/characters/hair/astralvessel/hair_tlilith.anm2"},
}

function PSTAVessel:addVesselHairstyle(costumePath, variation)
    if type(costumePath) ~= "string" then return end
    local newC = {path = costumePath}
    if variation then newC.variant = variation end
    table.insert(PSTAVessel.hairstyles, newC)
end

-- Add Eden hair variations programmatically
local function PSTAVessel_loadEdenHair()
    for i=1,40 do
        PSTAVessel:addVesselHairstyle(
            "gfx/characters/hair/astralvessel/hair_eden.anm2",
            "gfx/characters/costumes/character_009_edenhair" .. tostring(i) .. ".png"
        )
    end
end
PSTAVessel_loadEdenHair()

---- ACCESSORIES DATA
PSTAVessel.accessoryList = {
    {path="gfx/characters/accessories/accessory_cainseyepatch.anm2"},
    {path="gfx/characters/accessories/accessory_judasfez.anm2"},
    {path="gfx/characters/accessories/accessory_keepernoose.anm2"},
    {path="gfx/characters/n014_Blindfold.anm2"},
    {item=CollectibleType.COLLECTIBLE_MY_REFLECTION},
    {item=CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR},
    {item=CollectibleType.COLLECTIBLE_BOOM},
    {item=CollectibleType.COLLECTIBLE_WOODEN_SPOON},
    {item=CollectibleType.COLLECTIBLE_BELT},
    {item=CollectibleType.COLLECTIBLE_MOMS_LIPSTICK},
    {item=CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR},
    {item=CollectibleType.COLLECTIBLE_MOMS_HEELS},
    {item=CollectibleType.COLLECTIBLE_LUCKY_FOOT},
    {item=CollectibleType.COLLECTIBLE_CUPIDS_ARROW},
    {item=CollectibleType.COLLECTIBLE_DR_FETUS},
    {path="gfx/characters/accessories/accessory_monocle.anm2"},
    {item=CollectibleType.COLLECTIBLE_STEAM_SALE},
    {item=CollectibleType.COLLECTIBLE_ROSARY},
    {item=CollectibleType.COLLECTIBLE_MARK},
    {item=CollectibleType.COLLECTIBLE_LOKIS_HORNS},
    {item=CollectibleType.COLLECTIBLE_SMALL_ROCK},
    {item=CollectibleType.COLLECTIBLE_SPELUNKER_HAT},
    {item=CollectibleType.COLLECTIBLE_SUPER_BANDAGE},
    {item=CollectibleType.COLLECTIBLE_HALO},
    {item=CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER},
    {item=CollectibleType.COLLECTIBLE_MOMS_CONTACTS},
    {item=CollectibleType.COLLECTIBLE_DEAD_BIRD},
    {item=CollectibleType.COLLECTIBLE_LUMP_OF_COAL},
    {item=CollectibleType.COLLECTIBLE_MOMS_PURSE},
    {item=CollectibleType.COLLECTIBLE_PAGEANT_BOY},
    {item=CollectibleType.COLLECTIBLE_MUTANT_SPIDER},
    {item=CollectibleType.COLLECTIBLE_PEEPER},
    {item=CollectibleType.COLLECTIBLE_BLOODY_LUST},
    {item=CollectibleType.COLLECTIBLE_ANKH},
    {item=CollectibleType.COLLECTIBLE_CAT_O_NINE_TAILS},
    {item=CollectibleType.COLLECTIBLE_MAGIC_8_BALL},
    {item=CollectibleType.COLLECTIBLE_MOMS_COIN_PURSE},
    {item=CollectibleType.COLLECTIBLE_SQUEEZY},
    {item=CollectibleType.COLLECTIBLE_JESUS_JUICE},
    {item=CollectibleType.COLLECTIBLE_MOMS_EYESHADOW},
    {item=CollectibleType.COLLECTIBLE_IRON_BAR},
    {item=CollectibleType.COLLECTIBLE_SHARP_PLUG},
    {item=CollectibleType.COLLECTIBLE_GNAWED_LEAF},
    {item=CollectibleType.COLLECTIBLE_GUPPYS_COLLAR},
    {item=CollectibleType.COLLECTIBLE_LOST_CONTACT},
    {item=CollectibleType.COLLECTIBLE_ANEMIC},
    {item=CollectibleType.COLLECTIBLE_GOAT_HEAD},
    {item=CollectibleType.COLLECTIBLE_OLD_BANDAGE},
    {item=CollectibleType.COLLECTIBLE_BLACK_LOTUS},
    {item=CollectibleType.COLLECTIBLE_STOP_WATCH},
    {item=CollectibleType.COLLECTIBLE_E_COLI},
    {item=CollectibleType.COLLECTIBLE_BFFS},
    {item=CollectibleType.COLLECTIBLE_THERES_OPTIONS},
    {item=CollectibleType.COLLECTIBLE_MORE_OPTIONS},
    {item=CollectibleType.COLLECTIBLE_FIRE_MIND},
    {item=CollectibleType.COLLECTIBLE_VIRGO},
    {item=CollectibleType.COLLECTIBLE_AQUARIUS},
    {item=CollectibleType.COLLECTIBLE_EVES_MASCARA},
    {item=CollectibleType.COLLECTIBLE_MAGGYS_BOW},
    {item=CollectibleType.COLLECTIBLE_LAZARUS_RAGS},
    {item=CollectibleType.COLLECTIBLE_MOMS_PEARLS},
    {item=CollectibleType.COLLECTIBLE_MR_DOLLY},
    {item=CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER},
    {item=CollectibleType.COLLECTIBLE_SERPENTS_KISS},
    {item=CollectibleType.COLLECTIBLE_EVIL_EYE},
    {item=CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER},
    {item=CollectibleType.COLLECTIBLE_BINKY},
    {item=CollectibleType.COLLECTIBLE_EYE_OF_GREED},
    {item=CollectibleType.COLLECTIBLE_SINUS_INFECTION},
    {item=CollectibleType.COLLECTIBLE_EYE_OF_BELIAL},
    {item=CollectibleType.COLLECTIBLE_ANALOG_STICK},
    {item=CollectibleType.COLLECTIBLE_CAMO_UNDIES},
    {item=CollectibleType.COLLECTIBLE_EUCHARIST},
    {item=CollectibleType.COLLECTIBLE_LARGE_ZIT},
    {item=CollectibleType.COLLECTIBLE_LITTLE_HORN},
    {item=CollectibleType.COLLECTIBLE_SHARP_STRAW},
    {item=CollectibleType.COLLECTIBLE_BOZO},
    {item=CollectibleType.COLLECTIBLE_SCHOOLBAG},
    {item=CollectibleType.COLLECTIBLE_MERCURIUS}
}

---- FACES DATA
PSTAVessel.facesList = {
    {path="none"},
    {path="gfx/characters/faces/astralvessel/face_isaac.anm2"},
    {path="gfx/characters/faces/astralvessel/face_isaac_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_3dollar.anm2"},
    {path="gfx/characters/faces/astralvessel/face_chaos.anm2"},
    {path="gfx/characters/faces/astralvessel/face_chaos_nobrows.anm2"},
    {path="gfx/characters/faces/astralvessel/face_euthanasia.anm2"},
    {path="gfx/characters/faces/astralvessel/face_exp.anm2"},
    {path="gfx/characters/faces/astralvessel/face_godsflesh.anm2"},
    {path="gfx/characters/faces/astralvessel/face_foundpills.anm2"},
    {path="gfx/characters/faces/astralvessel/face_happy.anm2"},
    {path="gfx/characters/faces/astralvessel/face_happy_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_venus.anm2"},
    {path="gfx/characters/faces/astralvessel/face_knockout.anm2"},
    {path="gfx/characters/faces/astralvessel/face_knockout_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_luna.anm2"},
    {path="gfx/characters/faces/astralvessel/face_luna_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_maxhead.anm2"},
    {path="gfx/characters/faces/astralvessel/face_maxhead_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_maxhead_eyeonly.anm2"},
    {path="gfx/characters/faces/astralvessel/face_mindhead.anm2"},
    {path="gfx/characters/faces/astralvessel/face_polyphemus.anm2"},
    {path="gfx/characters/faces/astralvessel/face_polyphemus_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_roidrage.anm2"},
    {path="gfx/characters/faces/astralvessel/face_roidrage_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_sosig.anm2"},
    {path="gfx/characters/faces/astralvessel/face_speedball.anm2"},
    {path="gfx/characters/faces/astralvessel/face_spoonbender.anm2"},
    {path="gfx/characters/faces/astralvessel/face_spoonbender_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_taurus.anm2"},
    {path="gfx/characters/faces/astralvessel/face_taurus_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_thewiz.anm2"},
    {path="gfx/characters/faces/astralvessel/face_vampire.anm2"},
    {path="gfx/characters/faces/astralvessel/face_vampire_noblood.anm2"},
    -- {path="gfx/characters/faces/astralvessel/face_dads_dip.anm2"}, -- FIEND FOLIO
    -- TODO: blue baby face
    -- TODO: check ouija board
    -- TODO: chemical peel?
    -- TODO: check delirious eye-only?
    -- TODO: smb super fan
    -- TODO: ball of tar
}

include("scripts.constellationsInitData")

PSTAVessel.knifeItems = {
    CollectibleType.COLLECTIBLE_MOMS_KNIFE, CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER, CollectibleType.COLLECTIBLE_BACKSTABBER,
    CollectibleType.COLLECTIBLE_KNIFE_PIECE_1, CollectibleType.COLLECTIBLE_KNIFE_PIECE_2, CollectibleType.COLLECTIBLE_BETRAYAL,
    CollectibleType.COLLECTIBLE_VENTRICLE_RAZOR, CollectibleType.COLLECTIBLE_DARK_ARTS, CollectibleType.COLLECTIBLE_POINTY_RIB
}

-- Corpse Raiser summon choices {entity type, variant, max summons, {anim1, anim2, ...}}
PSTAVessel.corpseRaiserSummons1 = { -- Floors 5 and below
    {EntityType.ENTITY_BONY, 0, 5},
    {EntityType.ENTITY_CHARGER, 3, 4, {"Move Hori"}},
    {EntityType.ENTITY_CLICKETY_CLACK, 0, 2}
}
PSTAVessel.corpseRaiserSummons2 = { -- Floors 9 and below
    {EntityType.ENTITY_BONY, 0, 8},
    {EntityType.ENTITY_BLACK_BONY, 0, 4},
    {EntityType.ENTITY_CHARGER, 3, 8, {"Move Hori"}},
    {EntityType.ENTITY_CLICKETY_CLACK, 0, 3},
    {EntityType.ENTITY_REVENANT, 0, 2}
}
PSTAVessel.corpseRaiserSummons3 = { -- Floors 10+
    {EntityType.ENTITY_BONY, 0, 11},
    {EntityType.ENTITY_BLACK_BONY, 0, 6},
    {EntityType.ENTITY_BONY, 1, 2},
    {EntityType.ENTITY_CHARGER, 3, 11, {"Move Hori"}},
    {EntityType.ENTITY_CLICKETY_CLACK, 0, 5},
    {EntityType.ENTITY_REVENANT, 0, 3}
}