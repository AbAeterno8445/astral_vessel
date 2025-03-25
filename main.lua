PSTAVessel = RegisterMod("PST_AV", 1)
PSTAVessel.version = "0.1.1"

include("scripts.utility")
include("scripts.initData")
include("scripts.saveData")
include("scripts.initTrees")
include("scripts.menus.appearance.appearanceMenu")
include("scripts.menus.nexus.nexusMenu")
include("scripts.menus.loadoutSubmenu")
include("scripts.menus.corpseRaiserSubmenu")
include("scripts.modCompat")

include("scripts.costumes")
include("scripts.treeRender")
include("scripts.onNewRun")
include("scripts.onNewRoom")
include("scripts.onDeath")
include("scripts.onDamage")
include("scripts.postDamage")
include("scripts.onNewLevel")
include("scripts.onCache")
include("scripts.onUpdate")
include("scripts.onRoomClear")
include("scripts.useItems")
include("scripts.pickups")
include("scripts.shops")
include("scripts.slots")
include("scripts.entities")
include("scripts.rendering")
include("scripts.useCardsPills")
include("scripts.consoleCommands")

local initFlag = false
function PSTAVessel:initMod()
    -- Init mod once
    if initFlag then return end
    initFlag = true

    if not PST then
        print("Could not initialize Astral Vessel: missing Passive Skill Trees mod.")
        return
    end

    -- Soul stone init
    PST.playerSoulstones[PSTAVessel.vesselType] = PSTAVessel.vesselSoulstoneID

    PSTAVessel:initVesselTree()
    PSTAVessel:initAppearanceMenu()
    PSTAVessel:initNexusMenu()
    PSTAVessel:initLoadoutSubmenu()
    PSTAVessel:initCorpseRaiserSubmenu()
    PSTAVessel:initModCompat()
    print("Initialized Astral Vessel v" .. PSTAVessel.version)

    -- EID
    if EID then
        -- Constellation type colors
        for _, tmpType in pairs(PSTAVConstellationType) do
            EID:addColor("AVessel" .. tmpType, PSTAVessel.constelKColors[tmpType])
        end

        -- Soul of the Vessel soul stone
        if PSTAVessel.vesselSoulstoneID ~= -1 then
            EID:addCard(
                PSTAVessel.vesselSoulstoneID,
                "Triggers a random Sidereal Meridion's effect.#Generates 200 energy for your selected Meridion.#You can see Sidereal Meridions' effects in the Sidereal Tree once unlocked."
            )
        end
    end

    -- Init callbacks
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, PSTAVessel.onNewRun)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, PSTAVessel.onNewRoom)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, PSTAVessel.postPlayerUpdate)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_UPDATE, PSTAVessel.onUpdate)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, PSTAVessel.tearUpdate)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_COMPLETION_EVENT, PSTAVessel.onCompletion)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, PSTAVessel.onDeath)
    PSTAVessel:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, PSTAVessel.onDamage)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, PSTAVessel.postDamage)
    PSTAVessel:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, PSTAVessel.prePickup)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, PSTAVessel.onPickup)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED, PSTAVessel.onNewLevel)
    PSTAVessel:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PSTAVessel.onCache)
    PSTAVessel:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, PSTAVessel.onRoomClear)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, PSTAVessel.onShopPurchase)
    PSTAVessel:AddCallback(ModCallbacks.MC_NPC_UPDATE, PSTAVessel.onNPCUpdate)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, PSTAVessel.effectUpdate)
    PSTAVessel:AddCallback(ModCallbacks.MC_USE_ITEM, PSTAVessel.onUseItem)
    PSTAVessel:AddCallback(ModCallbacks.MC_USE_CARD, PSTAVessel.onUseCard)
    PSTAVessel:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, PSTAVessel.preSlotCollision)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, PSTAVessel.onSlotUpdate)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, PSTAVessel.onPickupUpdate)
    PSTAVessel:AddCallback(ModCallbacks.MC_PLAYER_GET_HEALTH_TYPE, PSTAVessel.playerHealthType)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_RENDER, PSTAVessel.onRender)

    -- Entity debug
    --[[PSTAVessel:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(self, entityType, variant, subtype)
        local tmpType = entityType
        for typeName, typeID in pairs(EntityType) do
            if typeID == entityType then
                tmpType = typeName
                break
            end
        end
        local tmpVariant = variant
        if entityType == EntityType.ENTITY_EFFECT then
            for fxName, fxID in pairs(EffectVariant) do
                if fxID == variant then
                    tmpVariant = fxName
                    break
                end
            end
        end
        print("Entity Spawn:", tmpType, tmpVariant, subtype)
    end)]]
end
PSTAVessel:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, PSTAVessel.initMod)

-- Re-init on luamod (PST already present)
if PST and not initFlag then
    PSTAVessel:initMod()
    PSTAVessel:load()
end

PSTAVessel:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, PSTAVessel.load)
PSTAVessel:AddCallback(ModCallbacks.MC_EXECUTE_CMD, PSTAVessel.onConsoleCMD)