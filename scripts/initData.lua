PSTAVessel.vesselType = Isaac.GetPlayerTypeByName("Astral Vessel")

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
    viperineLash = 0,
    batterySpeedBuff = 0,
    batteryItemElecTear = 0,
    hitBlackHole = 0,
    lightlessMaw = 0,
    secretRoomSpeedBuff = 0,
    lunarScion = 0,
    vesselFliesSpeed = 0,
    poisonHitMucor = 0,
    mutagenicTear = 0,
    causticBite = 0,
    mephitCurseKillBuff = 0,
    playerDmgWindow = 0,
    birthcakeDupe = 0
}
PSTAVessel.firingCooldowns = {
    ritualPurpleFlame = 0,
    singularityFearTears = 0
}
PSTAVessel.updateTrackers = {
    eternalHearts = 0,
    redHearts = 0,
    soulHearts = 0,
    blackHearts = 0,
    rottenHearts = 0,
    primarySlotCharge = 0
}
PSTAVessel.floorFirstUpdate = false
PSTAVessel.roomFirstFire = false

PSTAVessel.carrionMobs = {}
PSTAVessel.fusilladeEmbers = 0
PSTAVessel.fusilladeEmberAng = 0
PSTAVessel.fusilladeEmberDist = 30
PSTAVessel.fusilladeDelay = 70
PSTAVessel.spiralAbilityAng = 0
PSTAVessel.chargeGainProc = 0
PSTAVessel.lightlessMawDmg = 0
PSTAVessel.lightlessMawLuckTears = 0
PSTAVessel.lightlessMawSpeedRange = 0
PSTAVessel.inSolarFireRing = false
PSTAVessel.vesselFliesSpeedBuff = 0
PSTAVessel.roomBlueSpiderDeaths = 0

PSTAVessel.charUnlocks = {}
PSTAVessel.charLoadouts = {}
PSTAVessel.currentLoadout = "1"
PSTAVessel.maxLoadouts = 100
PSTAVessel.accessoryLimit = 5

-- Character save data (for loadouts)
function PSTAVessel:initCharData()
    PSTAVessel.charColor = Color(1, 1, 1, 1)
    PSTAVessel.charHair = nil
    PSTAVessel.charHairColor = Color(1, 1, 1, 1)
    PSTAVessel.charFace = nil
    PSTAVessel.charAccessories = {}
    PSTAVessel.charStartItems = {}
    PSTAVessel.charHurtSFX = SoundEffect.SOUND_ISAAC_HURT_GRUNT
    PSTAVessel.charDeathSFX = SoundEffect.SOUND_ISAACDIES
    PSTAVessel.charHurtPitch = 1
    PSTAVessel.charHurtRandpitch = false

    PSTAVessel.corpseRaiserChoice = {1, 1, 1}
    PSTAVessel.weaponsmithType = 0
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
    },
    ["AVesselObols1"] = {
        reqs = {CompletionType.ULTRA_GREEDIER},
        desc = "Defeat Ultra Greedier: Permanent +12% obols dropped with Astral Vessel (expedition runs).",
        func = function() PSTAVessel.charObolBonus = PSTAVessel.charObolBonus + 12 end
    },
    ["AVesselSoul"] = {
        reqs = {
            CompletionType.BEAST .. "hard", CompletionType.BLUE_BABY .. "hard", CompletionType.BOSS_RUSH .. "hard",
            CompletionType.DELIRIUM .. "hard", CompletionType.HUSH .. "hard", CompletionType.ISAAC .. "hard",
            CompletionType.LAMB .. "hard", CompletionType.MEGA_SATAN .. "hard", CompletionType.MOMS_HEART .. "hard",
            CompletionType.MOTHER .. "hard", CompletionType.SATAN .. "hard", CompletionType.ULTRA_GREED,
            CompletionType.ULTRA_GREEDIER
        },
        desc = "Obtain all hard completion marks: Unlock Soul of the Vessel soul stone.",
        func = function() PSTAVessel.soulstoneUnlock = true end
    },
    ["AVesselIngrained"] = {
        reqs = {"lvl100"},
        desc = "Reach level 100: Can now Allocate the 'Ingrained Power' node, which smelts your starting trinket.",
        func = function() PSTAVessel.ingrainedUnlock = true end
    }
}
PSTAVessel.unlocksDisplayOrder = {
    "AVesselExtraItem1", "AVesselLesser1", "AVesselLesser2", "AVesselActives", "AVesselQual3",
    "AVesselExtraItem2", "AVesselGreater1", "AVesselEmpyrean1", "AVesselTrinkets", "AVesselExp1",
    "AVesselObols1", "AVesselSoul", "AVesselIngrained"
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
    PSTAVessel.charObolBonus = 0
    PSTAVessel.soulstoneUnlock = false
    PSTAVessel.ingrainedUnlock = false

    -- Allocation % for constellations to give their full affinity value
    PSTAVessel.charConstAffinityReq = 0.75

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
    {path="gfx/characters/character_b16_bethany.anm2"},
    {path="gfx/characters/217_momswig.anm2"},

    -- Custom
    {path="gfx/characters/hair/astralvessel/hair_guardian.anm2"},
    {path="gfx/characters/hair/astralvessel/hair_venus.anm2"},
    {path="gfx/characters/hair/astralvessel/hair_tlilith.anm2"},
}
PSTAVessel.baseHairCostumePath = "gfx/characters/hair/astralvessel/hair_vessel.anm2"

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
    {path="gfx/characters/accessories/astralvessel/accessory_cainseyepatch.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_cainsbloodeyepatch.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_judasfez.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_tjudasfez.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_keepernoose.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_lostcobwebs.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_apollyonhorns.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_spiderfangs.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_guppyeyes.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_doubleglass.anm2"},
    {path="gfx/characters/n014_Blindfold.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_myreflection.anm2"},
    {item=CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR},
    {path="gfx/characters/accessories/astralvessel/accessory_boom.anm2"},
    --{item=CollectibleType.COLLECTIBLE_WOODEN_SPOON}, -- conflicting head1
    {item=CollectibleType.COLLECTIBLE_BELT},
    {item=CollectibleType.COLLECTIBLE_MOMS_LIPSTICK},
    {item=CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR},
    {item=CollectibleType.COLLECTIBLE_MOMS_HEELS},
    {item=CollectibleType.COLLECTIBLE_LUCKY_FOOT},
    {item=CollectibleType.COLLECTIBLE_CUPIDS_ARROW},
    {item=CollectibleType.COLLECTIBLE_DR_FETUS},
    {path="gfx/characters/accessories/astralvessel/accessory_monocle.anm2"},
    {item=CollectibleType.COLLECTIBLE_STEAM_SALE},
    {item=CollectibleType.COLLECTIBLE_ROSARY},
    {path="gfx/characters/accessories/astralvessel/accessory_themark.anm2"},
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
    {path="gfx/characters/accessories/astralvessel/accessory_mutantspider.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_peeper.anm2"},
    {item=CollectibleType.COLLECTIBLE_BLOODY_LUST},
    {item=CollectibleType.COLLECTIBLE_ANKH},
    {path="gfx/characters/accessories/astralvessel/accessory_catoninetails.anm2"},
    {item=CollectibleType.COLLECTIBLE_MAGIC_8_BALL},
    {item=CollectibleType.COLLECTIBLE_MOMS_COIN_PURSE},
    {path="gfx/characters/accessories/astralvessel/accessory_squeezy.anm2"},
    --{item=CollectibleType.COLLECTIBLE_JESUS_JUICE}, -- conflicting head1
    {path="gfx/characters/accessories/astralvessel/accessory_momseyeshadow.anm2"},
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
    --{item=CollectibleType.COLLECTIBLE_E_COLI}, -- conflicting head1
    --{item=CollectibleType.COLLECTIBLE_BFFS}, -- conflicting head1
    {path="gfx/characters/accessories/astralvessel/accessory_theresoptions.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_moreoptions.anm2"},
    {item=CollectibleType.COLLECTIBLE_FIRE_MIND},
    {item=CollectibleType.COLLECTIBLE_VIRGO},
    {item=CollectibleType.COLLECTIBLE_AQUARIUS},
    {item=CollectibleType.COLLECTIBLE_EVES_MASCARA},
    {item=CollectibleType.COLLECTIBLE_MAGGYS_BOW},
    {item=CollectibleType.COLLECTIBLE_LAZARUS_RAGS},
    {item=CollectibleType.COLLECTIBLE_MOMS_PEARLS},
    {item=CollectibleType.COLLECTIBLE_MR_DOLLY},
    {path="gfx/characters/accessories/astralvessel/accessory_curseofthetower.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_serpentskiss.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_evileye.anm2"},
    {item=CollectibleType.COLLECTIBLE_HEAD_OF_THE_KEEPER},
    {item=CollectibleType.COLLECTIBLE_BINKY},
    {item=CollectibleType.COLLECTIBLE_EYE_OF_GREED},
    --{item=CollectibleType.COLLECTIBLE_SINUS_INFECTION}, -- conflicting head1
    {path="gfx/characters/accessories/astralvessel/accessory_eyeofbelial.anm2"},
    {item=CollectibleType.COLLECTIBLE_ANALOG_STICK},
    {item=CollectibleType.COLLECTIBLE_CAMO_UNDIES},
    {path="gfx/characters/accessories/astralvessel/accessory_eucharist.anm2"},
    {path="gfx/characters/accessories/astralvessel/accessory_largezit.anm2"},
    {item=CollectibleType.COLLECTIBLE_LITTLE_HORN},
    {item=CollectibleType.COLLECTIBLE_SHARP_STRAW},
    {item=CollectibleType.COLLECTIBLE_BOZO},
    {item=CollectibleType.COLLECTIBLE_MERCURIUS},
    {path="gfx/characters/accessories/astralvessel/accessory_marked.anm2"},
}

-- Maps accessory IDs to their list entry
PSTAVessel.accessoryMap = {}

-- Generates an unique accessory ID based on entry data (path + item + sourceMod)
function PSTAVessel:getAccessoryID(accessoryData)
    local IDStr
    if accessoryData.path then
        IDStr = tostring(PSTAVessel:strHash(accessoryData.path))
    elseif accessoryData.item then
        local baseStr = (accessoryData.sourceMod ~= nil) and accessoryData.sourceMod or "PSTAVessel"
        IDStr = baseStr .. "_" .. accessoryData.item
    end
    return IDStr
end
-- Maps current accessory list's entries to their unique IDs
function PSTAVessel:updateAccessoryMap()
    PSTAVessel.accessoryMap = {}
    for _, tmpAcc in ipairs(PSTAVessel.accessoryList) do
        local accID = PSTAVessel:getAccessoryID(tmpAcc)
        tmpAcc.ID = accID
        PSTAVessel.accessoryMap[accID] = tmpAcc
    end
end
PSTAVessel:updateAccessoryMap()

---- FACES DATA
PSTAVessel.facesList = {
    {path="none"},
    {path="gfx/characters/faces/astralvessel/face_isaac.anm2"},
    {path="gfx/characters/faces/astralvessel/face_isaac_nocry.anm2"},
    {path="gfx/characters/faces/astralvessel/face_3dollar.anm2"},
    {path="gfx/characters/faces/astralvessel/face_fruitcake.anm2"},
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
    {path="gfx/characters/faces/astralvessel/face_bluebaby.anm2"},
    {path="gfx/characters/faces/astralvessel/face_chemicalpeel.anm2"},
    {path="gfx/characters/faces/astralvessel/face_smb.anm2"},
    {path="gfx/characters/faces/astralvessel/face_balloftar1.anm2"},
    {path="gfx/characters/faces/astralvessel/face_balloftar2.anm2"},
    {path="gfx/characters/faces/astralvessel/face_balloftar3.anm2"},
    {path="gfx/characters/faces/astralvessel/face_terra.anm2"}
}
PSTAVessel.baseFaceCostumePath = "gfx/characters/faces/astralvessel/base/face_vessel.anm2"

include("scripts.constellationsInitData")

PSTAVessel.knifeItems = {
    CollectibleType.COLLECTIBLE_MOMS_KNIFE, CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER, CollectibleType.COLLECTIBLE_BACKSTABBER,
    CollectibleType.COLLECTIBLE_KNIFE_PIECE_1, CollectibleType.COLLECTIBLE_KNIFE_PIECE_2, CollectibleType.COLLECTIBLE_BETRAYAL,
    CollectibleType.COLLECTIBLE_VENTRICLE_RAZOR, CollectibleType.COLLECTIBLE_DARK_ARTS, CollectibleType.COLLECTIBLE_POINTY_RIB
}
PSTAVessel.batteryItems = {
    CollectibleType.COLLECTIBLE_BATTERY_PACK, CollectibleType.COLLECTIBLE_4_5_VOLT, CollectibleType.COLLECTIBLE_BATTERY,
    CollectibleType.COLLECTIBLE_9_VOLT, CollectibleType.COLLECTIBLE_CAR_BATTERY, CollectibleType.COLLECTIBLE_CHARGED_BABY,
    CollectibleType.COLLECTIBLE_JUMPER_CABLES, CollectibleType.COLLECTIBLE_JACOBS_LADDER
}
-- Up to Q3
PSTAVessel.mushroomItemsQ3 = {
    CollectibleType.COLLECTIBLE_WAVY_CAP, CollectibleType.COLLECTIBLE_1UP, CollectibleType.COLLECTIBLE_MINI_MUSH,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN, CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE, CollectibleType.COLLECTIBLE_BLUE_CAP,
    CollectibleType.COLLECTIBLE_GODS_FLESH
}

PSTAVessel.flyFriendsList = {
    {EntityType.ENTITY_SUCKER, 0}, {EntityType.ENTITY_SUCKER, 1}, {EntityType.ENTITY_SUCKER, 3}, {EntityType.ENTITY_BOOMFLY, 1},
    {EntityType.ENTITY_BOOMFLY, 3}, {EntityType.ENTITY_BOOMFLY, 3, 1}, {EntityType.ENTITY_FLY_L2, 0}, {EntityType.ENTITY_FULL_FLY, 0},
    {EntityType.ENTITY_MOTER, 0}
}
PSTAVessel.flyFamiliars = {
    FamiliarVariant.FLY_ORBITAL, FamiliarVariant.BOT_FLY, FamiliarVariant.PSY_FLY, FamiliarVariant.LOST_FLY, FamiliarVariant.PAPA_FLY,
    FamiliarVariant.ANGRY_FLY, FamiliarVariant.SMART_FLY, FamiliarVariant.SWARM_FLY_ORBITAL
}

PSTAVessel.crimsonBloomID = Isaac.GetEntityVariantByName("Crimson Bloom")
PSTAVessel.azureBloomID = Isaac.GetEntityVariantByName("Azure Bloom")
PSTAVessel.onyxBloomID = Isaac.GetEntityVariantByName("Onyx Bloom")
PSTAVessel.calcifiedBloomID = Isaac.GetEntityVariantByName("Calcified Bloom")
PSTAVessel.eternalBloomID = Isaac.GetEntityVariantByName("Eternal Bloom")
PSTAVessel.rotBloomID = Isaac.GetEntityVariantByName("Rotbloom")
PSTAVessel.gildedBloomID = Isaac.GetEntityVariantByName("Gilded Bloom")
PSTAVessel.lifebloomsList = {
    PSTAVessel.crimsonBloomID, PSTAVessel.azureBloomID, PSTAVessel.onyxBloomID, PSTAVessel.calcifiedBloomID, PSTAVessel.eternalBloomID,
    PSTAVessel.rotBloomID, PSTAVessel.gildedBloomID
}
PSTAVessel.exploMushroomID = Isaac.GetEntityVariantByName("Vessel Mushroom")

PSTAVessel.lunarScionMoonlightID = Isaac.GetEntityVariantByName("Lunar Scion Moonlight")
PSTAVessel.solarScionFireRingID = Isaac.GetEntityVariantByName("Solar Scion Fire Ring")

PSTAVessel.vesselSoulstoneID = Isaac.GetCardIdByName("SoulOfTheVessel")

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

PSTAVessel.customHurtSFXList = {
    SoundEffect.SOUND_ISAAC_HURT_GRUNT, SoundEffect.SOUND_BABY_HURT, SoundEffect.SOUND_CUTE_GRUNT, SoundEffect.SOUND_FAMINE_GRUNT,
    SoundEffect.SOUND_MONSTER_GRUNT_4, SoundEffect.SOUND_MONSTER_GRUNT_5, SoundEffect.SOUND_SPIDER_SPIT_ROAR, SoundEffect.SOUND_BOSS_LITE_ROAR,
    SoundEffect.SOUND_WEIRD_WORM_SPIT, SoundEffect.SOUND_ULTRA_GREED_SPIT, SoundEffect.SOUND_LARYNX_SCREAM_LO, SoundEffect.SOUND_LITTLE_HORN_COUGH,
    SoundEffect.SOUND_WHEEZY_COUGH, SoundEffect.SOUND_BUMBINO_SNAP_OUT, SoundEffect.SOUND_GLASS_BREAK, SoundEffect.SOUND_POT_BREAK_2,
    SoundEffect.SOUND_BONE_BREAK, SoundEffect.SOUND_WOOD_PLANK_BREAK, SoundEffect.SOUND_DOGMA_TV_BREAK, SoundEffect.SOUND_ROCK_CRUMBLE,
    SoundEffect.SOUND_CHILD_HAPPY_ROAR_SHORT, SoundEffect.SOUND_BISHOP_HIT, SoundEffect.SOUND_BULB_FLASH, SoundEffect.SOUND_EDEN_GLITCH,
    SoundEffect.SOUND_JELLY_BOUNCE, SoundEffect.SOUND_POISON_HURT, SoundEffect.SOUND_LIGHTBOLT_CHARGE,
    {Isaac.GetSoundIdByName("Siren Hurt (PSTAVessel)"), "Siren Hit", "PST (unreleased)"}
}
PSTAVessel.customDeathSFXList = {
    SoundEffect.SOUND_ISAACDIES, SoundEffect.SOUND_SPIDER_COUGH, SoundEffect.SOUND_DOGMA_SCREAM, SoundEffect.SOUND_LARYNX_SCREAM_HI,
    SoundEffect.SOUND_LARYNX_SCREAM_MED, SoundEffect.SOUND_THE_FORSAKEN_SCREAM, SoundEffect.SOUND_DOGMA_DEATH, SoundEffect.SOUND_PESTILENCE_DEATH,
    SoundEffect.SOUND_GOODEATH, SoundEffect.SOUND_FAMINE_DEATH_2, SoundEffect.SOUND_MEATY_DEATHS, SoundEffect.SOUND_BUMBINO_DEATH,
    SoundEffect.SOUND_POT_BREAK_2, SoundEffect.SOUND_MIRROR_BREAK, SoundEffect.SOUND_ROCK_CRUMBLE, SoundEffect.SOUND_INHALE,
    SoundEffect.SOUND_BULB_FLASH, SoundEffect.SOUND_ANGEL_BEAM
}

PSTAVessel.SFXSmithy = Isaac.GetSoundIdByName("Astral Vessel Smith")

-- Birthcake mod compat - effect descriptions and rates (% per affinity point)
PSTAVessel.vesselBirthcakeEffectData = {
    [PSTAVConstellationType.DIVINE] = { desc = "Divine: {{totalAff}}% chance to convert dropped hearts into eternal hearts.", rate = 0.12},
    [PSTAVConstellationType.DEMONIC] = { desc = "Demonic: {{totalAff}}% chance to convert dropped hearts into black hearts.", rate = 0.12},
    [PSTAVConstellationType.OCCULT] = { desc = "Occult: {{totalAff}}% chance to convert dropped hearts into bone hearts.", rate = 0.12},
    [PSTAVConstellationType.MERCANTILE] = { desc = "Mercantile: {{totalAff}}% chance to convert dropped hearts into gold hearts.", rate = 0.12},
    [PSTAVConstellationType.MUNDANE] = { desc = "Mundane: {{totalAff}}% chance to duplicate normal {{Coin}}{{Key}}{{Bomb}}{{Heart}} drops. 0.33 second cooldown.", rate = 0.2},
    [PSTAVConstellationType.MUTAGENIC] = { desc = "Mutagenic: {{totalAff}}% chance to convert dropped hearts into rotten hearts.", rate = 0.12},
    [PSTAVConstellationType.ELEMENTAL] = { desc = "Elemental: {{totalAff}}% chance to regain 1 charge when using active items.", rate = 1},
    [PSTAVConstellationType.COSMIC] = { desc = "Cosmic: +{{totalAff}}% planetarium chance.", rate = 0.1}
}