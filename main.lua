PSTAVessel = RegisterMod("PST_AV", 1)
PSTAVessel.version = "1.0"

include("scripts.utility")
include("scripts.initData")
include("scripts.saveData")
include("scripts.initTrees")
include("scripts.menus.appearance.appearanceMenu")
include("scripts.menus.nexus.nexusMenu")
include("scripts.loadoutSubmenu")

include("scripts.costumes")
include("scripts.onRender")
include("scripts.onNewRun")
include("scripts.onNewRoom")
include("scripts.onDeath")
include("scripts.onDamage")
include("scripts.onNewLevel")
include("scripts.onCache")
include("scripts.onUpdate")
include("scripts.onRoomClear")
include("scripts.useItems")
include("scripts.pickups")
include("scripts.shops")
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

    PSTAVessel:initVesselTree()
    PSTAVessel:initAppearanceMenu()
    PSTAVessel:initNexusMenu()
    PSTAVessel:initLoadoutSubmenu()
    print("Initialized Astral Vessel v" .. PSTAVessel.version)

    -- EID
    if EID then
        -- Constellation type colors
        for _, tmpType in pairs(PSTAVConstellationType) do
            EID:addColor("AVessel" .. tmpType, PSTAVessel.constelKColors[tmpType])
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
    PSTAVessel:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, PSTAVessel.prePickup)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, PSTAVessel.onPickup)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED, PSTAVessel.onNewLevel)
    PSTAVessel:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, PSTAVessel.onCache)
    PSTAVessel:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, PSTAVessel.onRoomClear)
    PSTAVessel:AddCallback(ModCallbacks.MC_POST_PICKUP_SHOP_PURCHASE, PSTAVessel.onShopPurchase)
    PSTAVessel:AddCallback(ModCallbacks.MC_USE_ITEM, PSTAVessel.onUseItem)

    PSTAVessel:load()
end
PSTAVessel:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, PSTAVessel.initMod)

-- Re-init on luamod (PST already present)
if PST and not initFlag then
    PSTAVessel:initMod()
end

PSTAVessel:AddCallback(ModCallbacks.MC_POST_SAVESLOT_LOAD, PSTAVessel.load)
PSTAVessel:AddCallback(ModCallbacks.MC_EXECUTE_CMD, PSTAVessel.onConsoleCMD)

--[[ Modifiers TODO list



]]--