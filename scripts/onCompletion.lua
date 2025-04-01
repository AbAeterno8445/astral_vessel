-- Completion events tracking and unlocks
function PSTAVessel:onCompletion(event, noHard)
    ---@type EntityPlayer
    local player = PST:getPlayer()
    if player and player:GetPlayerType() == PSTAVessel.vesselType then
        PSTAVessel.charUnlocks[event] = true
        if Game():IsHardMode() and not noHard then
            PSTAVessel.charUnlocks[event .. "hard"] = true
        end

        local gameData = Isaac.GetPersistentGameData()
        for achievementName, tmpData in pairs(PSTAVessel.unlocksData) do
            local achievementID = Isaac.GetAchievementIdByName(achievementName)
            if achievementID ~= -1 and not gameData:Unlocked(achievementID) then
                local allUnlocked = true
                for _, tmpUnlock in ipairs(tmpData.reqs) do
                    if not PSTAVessel.charUnlocks[tmpUnlock] then
                        allUnlocked = false
                        break
                    end
                end
                if allUnlocked then
                    gameData:TryUnlock(achievementID)
                end
            end
        end

        -- Mod: upgrade side weapon to random ancient of its type when defeating Mom's Heart/It Lives
        if PST:getTreeSnapshotMod("sideWepAncientUpgrade", false) and event == CompletionType.MOMS_HEART then
            local wepData = PST:getTreeSnapshotMod("vesselSideWeapon", nil)
            if wepData and wepData.rarity ~= PSTAstralWepRarity.ANCIENT then
                local newWeapon = PST:createAstralWep(wepData.type, PSTAstralWepRarity.ANCIENT, wepData.tier)
                PST:astralWepForgeImprint(newWeapon, wepData)
                PST.modData.treeModSnapshot.vesselSideWeapon = newWeapon
                PST:astralWepApplyMods(newWeapon)

                SFXManager():Play(PSTAVessel.SFXSmithy, 0.8, 2, false, 0.85 + 0.3 * math.random())
                PST:createFloatTextFX("Side weapon upgraded to Ancient!", Vector.Zero, Color(1, 0.7, 0.35), 0.1, 150, true)
            end
        end

        PSTAVessel:save()
        PSTAVessel:updateUnlockData()
    end
end