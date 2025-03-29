local tonicTimer = 0

-- Extra rendering (runs after tree screen has been rendered)
function PSTAVessel:treeRenderLate()
    if not PST then return end

    if PST.treeScreen.open and PST.selectedMenuChar == PSTAVessel.vesselType then
        -- Render constellation affinity while on constellation trees
        for _, tmpType in pairs(PSTAVConstellationType) do
            local tmpTreeName = "Astral Vessel " .. tmpType
            if PST.treeScreen.currentTree == tmpTreeName then
                local affinityNum = PSTAVessel.constelAlloc[tmpType].affinity or 0
                PST.miniFont:DrawString(tmpType .. " Affinity: " .. affinityNum, 8, 50, PSTAVessel.constelKColors[tmpType])
                break
            end
        end

        -- Tonic Of Forgetfulness
        local hoveredNode = PST.treeScreen.hoveredNode
        if hoveredNode and PST:isNodeAllocated(PST.treeScreen.currentTree, hoveredNode.id) and
        hoveredNode.reqs and hoveredNode.reqs.vesselTonic then
            local tonicTree = "Astral Vessel " .. hoveredNode.reqs.vesselTonic
            if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE, true) then
                tonicTimer = tonicTimer + 1
                if tonicTimer <= 180 and tonicTimer % 60 == 0 then
                    SFXManager():Play(SoundEffect.SOUND_1UP)
                    if tonicTimer == 180 then
                        local allocNodes = 0
                        local tmpTree = PST.trees[tonicTree]
                        for nodeID, nodeData in pairs(tmpTree) do
                            if not (nodeData.reqs and nodeData.reqs.noSP) and PST:isNodeAllocated(tonicTree, nodeID) then
                                allocNodes = allocNodes + 1
                            end
                        end
                        if PST.modData.respecPoints >= allocNodes or PST.debugOptions.infRespec then
                            if not PST.debugOptions.infRespec then
                                PST.modData.respecPoints = PST.modData.respecPoints - allocNodes
                                PST.modData.charData["Astral Vessel"].skillPoints = PST.modData.charData["Astral Vessel"].skillPoints + allocNodes
                            end
                            for nodeID, _ in pairs(PST.modData.treeNodes[tonicTree]) do
                                PST.modData.treeNodes[tonicTree][nodeID] = 0
                            end
                            PSTAVessel:calcConstellationAffinities()
                            PSTAVessel:save()
                            SFXManager():Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE)
                        else
                            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
                        end
                    end
                end
            else
                tonicTimer = 0
            end
        end
    end
end
PSTAVessel:AddPriorityCallback(ModCallbacks.MC_MAIN_MENU_RENDER, CallbackPriority.LATE, PSTAVessel.treeRenderLate)
PSTAVessel:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE, PSTAVessel.treeRenderLate)