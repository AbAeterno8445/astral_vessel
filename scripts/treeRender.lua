function PSTAVessel:treeRender()
    if not PST then return end

    -- PST tree screen open
    if PST.treeScreen.open and PST.selectedMenuChar == PSTAVessel.charType then
        -- Input: Allocate
        if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
            local hoveredNode = PST.treeScreen.hoveredNode
            if hoveredNode then
                local alloc = PST:isNodeNameAllocated("Astral Vessel", hoveredNode.name)

                -- Check if allocated within constellation trees
                if not alloc then
                    for _, tmpType in pairs(PSTAVConstellationType) do
                        if PST:isNodeNameAllocated("Astral Vessel " .. tmpType, hoveredNode.name) then
                            alloc = true
                            break
                        end
                    end
                end
                if alloc then
                    -- Vessel-Shaping node, open appearance menu
                    if hoveredNode.name == "Vessel-Shaping" then
                        PST.treeScreen.modules.menuScreensModule:SwitchToMenu(PSTAVessel.AppearanceMenuID)
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    -- Stellar Nexus node, open nexus menu
                    elseif hoveredNode.name == "Stellar Nexus" then
                        PST.treeScreen.modules.menuScreensModule:SwitchToMenu(PSTAVessel.NexusMenuID)
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    -- Vessel Loadouts node, open loadouts submenu
                    elseif hoveredNode.name == "Vessel Loadouts" then
                        PST.treeScreen.modules.submenusModule:SwitchSubmenu(PSTAVessel.loadoutSubmenuID, {
                            menuX = hoveredNode.pos.X * 38,
                            menuY = hoveredNode.pos.Y * 38
                        })
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    -- Corpse Raiser node, open summon choice submenu
                    elseif hoveredNode.name == "Corpse Raiser" then
                        PST.treeScreen.modules.submenusModule:SwitchSubmenu(PSTAVessel.corpseRaiserSubmenuID, {
                            menuX = hoveredNode.pos.X * 38,
                            menuY = hoveredNode.pos.Y * 38
                        })
                        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                    else
                        -- Constellation tree nodes
                        for _, tmpType in pairs(PSTAVConstellationType) do
                            if hoveredNode.name == tmpType .. " Constellations" then
                                PST.treeScreen:switchCurrentTree("Astral Vessel " .. tmpType)
                                PST:updateNodes("Astral Vessel " .. tmpType, true)
                                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

PSTAVessel:AddPriorityCallback(ModCallbacks.MC_MAIN_MENU_RENDER, CallbackPriority.EARLY, PSTAVessel.treeRender)
PSTAVessel:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.EARLY, PSTAVessel.treeRender)

-- Extra rendering (runs after tree screen has been rendered)
function PSTAVessel:treeRenderLate()
    if not PST then return end

    if PST.treeScreen.open and PST.selectedMenuChar == PSTAVessel.charType then
        -- Render constellation affinity while on constellation trees
        for _, tmpType in pairs(PSTAVConstellationType) do
            local tmpTreeName = "Astral Vessel " .. tmpType
            if PST.treeScreen.currentTree == tmpTreeName then
                local affinityNum = PSTAVessel.constelAlloc[tmpType].affinity or 0
                PST.miniFont:DrawString(tmpType .. " Affinity: " .. affinityNum, 8, 50, PSTAVessel.constelKColors[tmpType])
                break
            end
        end
    end
end
PSTAVessel:AddPriorityCallback(ModCallbacks.MC_MAIN_MENU_RENDER, CallbackPriority.LATE, PSTAVessel.treeRenderLate)
PSTAVessel:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE, PSTAVessel.treeRenderLate)