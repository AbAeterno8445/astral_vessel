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