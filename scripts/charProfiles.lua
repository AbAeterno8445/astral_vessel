-- Create and initialize new character profile
function PSTAVessel:createCharacterProfile(profileName)
    if PSTAVessel.charProfiles[profileName] then
        return false
    end

    local newProfile = {
        name = profileName,
        charLoadouts = {},
        currentLoadout = "1",
        charUnlocks = {}
    }
    PSTAVessel.charProfiles[profileName] = newProfile
    return true
end

-- Returns "Astral Vessel" if no profile is selected, or the full profile charData name
function PSTAVessel:getCharProfName(profName)
    local tmpName = "Astral Vessel"
    if PSTAVessel.currentProfile then
        tmpName = tmpName .. " (Profile " .. (profName or PSTAVessel.currentProfile) .. ")"
    end
    return tmpName
end

-- Get currently selected character profile
function PSTAVessel:getCurrentProfile()
    if PSTAVessel.currentProfile and PSTAVessel.charProfiles[PSTAVessel.currentProfile] then
        return PSTAVessel.charProfiles[PSTAVessel.currentProfile]
    end
    return nil
end

-- Switch to the given profile, swapping character progress
---@param newProfile string|nil New profile ID string to switch to. Use nil to return to default data
function PSTAVessel:switchProfile(newProfile)
    print("[Astral Vessel] Switching to profile:", newProfile)
    PSTAVessel.currentProfile = newProfile
    if newProfile ~= nil then
        if not PSTAVessel:getCurrentProfile() then
            PSTAVessel:initCharData()
            PSTAVessel:createCharacterProfile(newProfile)
            PST:initCharProfile("Astral Vessel", newProfile)
            PSTAVessel:switchLoadout("1", true)
        else
            PSTAVessel:switchLoadout(PSTAVessel:getCurrentProfile().currentLoadout or "1", true)
        end
    else
        PSTAVessel:switchLoadout(PSTAVessel.currentLoadout, true)
    end
    PST:selectCharProfile("Astral Vessel", newProfile)
    PSTAVessel:resetUnlocks()
    PSTAVessel:updateUnlockData(true)
    PSTAVessel:calcConstellationAffinities()
end