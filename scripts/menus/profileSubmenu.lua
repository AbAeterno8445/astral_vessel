PSTAVessel.profileSubmenuID = "profiles"

local profilesPerPage = 25

function PSTAVessel:initProfileSubmenu()
    local profileSubmenu = {
        menuX = 0,
        menuY = 0,
        hoveredProfileID = nil,
        profileUISprite = Sprite("gfx/ui/astralvessel/profiles_ui.anm2", true),

        profDeleteTimer = 0,

        invPage = 0
    }

    -- Init
    PST.treeScreen.modules.submenusModule.submenus[PSTAVessel.profileSubmenuID] = profileSubmenu
    profileSubmenu.profileUISprite:Play("Default")

    function profileSubmenu:OnOpen(openData)
        if not openData then return end
        self.hoveredProfileID = nil
        for k, v in pairs(openData) do
            if self[k] ~= nil then self[k] = v end
        end
    end

    function profileSubmenu:Update()
        if self.hoveredProfileID then
            local profID = tostring(self.hoveredProfileID)
            -- Input: Allocate
            if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
                if not Isaac.IsInGame() then
                    PSTAVessel:saveLoadout()
                    if profID ~= PSTAVessel.currentProfile then
                        PSTAVessel:switchProfile(profID)
                    else
                        PSTAVessel:switchProfile(nil)
                    end
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
                end
            end

            -- Input: Respec (delete hovered profile)
            if PSTAVessel.charProfiles[profID] then
                if PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) then
                    self.profDeleteTimer = self.profDeleteTimer + 1
                    if self.profDeleteTimer % 60 == 0 then
                        SFXManager():Play(SoundEffect.SOUND_1UP)
                    end
                    if self.profDeleteTimer == 300 then
                        if PSTAVessel.currentProfile == profID then
                            PSTAVessel:switchProfile(nil)
                        end
                        PST:deleteCharProfile("Astral Vessel", profID)
                        PSTAVessel.charProfiles[profID] = nil
                        SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
                    end
                else
                    self.profDeleteTimer = 0
                end
            end
        end
    end

    function profileSubmenu:Render(tScreen, submenusModule)
        self.hoveredProfileID = nil
        local totalPages = math.ceil(PSTAVessel.maxProfiles / profilesPerPage)
        submenusModule:DrawNodeSubMenu(
            tScreen,
            profilesPerPage,
            tScreen.camCenterX, tScreen.camCenterY,
            self.menuX, self.menuY,
            "Vessel Profiles",
            function()
                for i=1,profilesPerPage do
                    local profileID = i + self.invPage * profilesPerPage
                    local tmpProfile = PSTAVessel.charProfiles[tostring(profileID)]
                    local drawX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local drawY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                    self.profileUISprite.Color.A = 1
                    self.profileUISprite.Color.R = 1
                    self.profileUISprite.Color.G = 1
                    self.profileUISprite.Color.B = 1
                    -- Hovered
                    if self.hoveredProfileID == nil then
                        if tScreen.camCenterX > drawX - 16 and tScreen.camCenterX < drawX + 16 and
                        tScreen.camCenterY > drawY - 16 and tScreen.camCenterY < drawY + 16 then
                            self.hoveredProfileID = profileID
                            tScreen.cursorHighlight = true
                        else
                            self.profileUISprite.Color.A = 0.5
                        end
                    else
                        self.profileUISprite.Color.A = 0.5
                    end

                    if tmpProfile or PSTAVessel.currentProfile == tostring(profileID) then
                        self.profileUISprite:SetFrame("Default", 0)
                    else
                        self.profileUISprite:SetFrame("Default", 1)
                    end
                    local finalDrawX = drawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local finalDrawY = drawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    self.profileUISprite:Render(Vector(finalDrawX, finalDrawY))

                    PST.miniFont:DrawString(tostring(profileID), finalDrawX + 7, finalDrawY, PST.kcolors.WHITE)

                    if PSTAVessel.currentProfile == tostring(profileID) then
                        self.profileUISprite.Color.A = 1
                        self.profileUISprite:SetFrame("Default", 2)
                        self.profileUISprite:Render(Vector(finalDrawX, finalDrawY))
                    end
                end
            end,
            {
                prevFunc = function()
                    self.invPage = math.max(0, self.invPage - 1)
                end,
                prevDisabled = self.invPage == 0,
                nextFunc = function()
                    self.invPage = math.min(totalPages - 1, self.invPage + 1)
                end,
                nextDisabled = self.invPage >= totalPages - 1,
                maxItems = PSTAVessel.maxProfiles
            }
        )

        -- Hovered profile
        if self.hoveredProfileID then
            local profileData = PSTAVessel.charProfiles[tostring(self.hoveredProfileID)]
            if profileData then
                local newDesc = {}
                if profileData.currentLoadout then
                    local profCharData = PST.modData.charData["Astral Vessel (Profile " .. tostring(self.hoveredProfileID) .. ")"]
                    if profCharData then
                        table.insert(newDesc, {"Level: " .. profCharData.level, PST.kcolors.LIGHTBLUE1})
                        table.insert(newDesc, {"Skill Points: " .. profCharData.skillPoints, PST.kcolors.LIGHTBLUE1})
                        table.insert(newDesc, {"Unlocks: " .. PSTAVessel:GetUnlocksCount(profileData.charUnlocks), PST.kcolors.LIGHTBLUE1})
                    end

                    table.insert(newDesc, "Selected Loadout: " .. profileData.currentLoadout)
                    local loadoutData = profileData.charLoadouts[tostring(profileData.currentLoadout)]
                    if loadoutData then
                        -- Display affinities (if saved)
                        if loadoutData.constAffinities then
                            local affInit = false
                            for tmpType, tmpAff in pairs(loadoutData.constAffinities) do
                                if tmpAff > 0 then
                                    if not affInit then
                                        table.insert(newDesc, "Affinities:")
                                        affInit = true
                                    end
                                    table.insert(newDesc, {"   " .. tmpType .. ": " .. tmpAff, PSTAVessel.constelKColors[tmpType]})
                                end
                            end
                        end
                        -- Display starting items
                        for _, tmpItem in ipairs(loadoutData.charStartItems) do
                            if tmpItem.item then
                                local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem.item)
                                if itemCfg then
                                    local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
                                    if itemName == "StringTable::InvalidKey" then itemName = itemCfg.Name end
                                    table.insert(newDesc, {"Starting item: " .. itemName, PST.kcolors.LIGHTBLUE1})
                                end
                            end
                        end
                    end
                end
                local isCurrentProfile = (PSTAVessel.currentProfile == self.hoveredProfileID)
                if Isaac.IsInGame() then
                    table.insert(newDesc, {"Currently in a run, cannot switch profiles!", PST.kcolors.LIGHTRED1})
                elseif isCurrentProfile then
                    table.insert(newDesc, "Press Allocate to switch to the character's default data.")
                else
                    table.insert(newDesc, "Press Allocate to switch to this profile.")
                end
                -- Profile deletion info
                local profDeleteTimerStr = ""
                if PST:isKeybindActive(PSTKeybind.RESPEC_NODE, true) then
                    profDeleteTimerStr = " (" .. math.max(0, 5 - math.floor(self.profDeleteTimer / 60)) .. ")"
                end
                table.insert(newDesc, {"Press and hold Respec for 5 seconds to DELETE this profile's data!" .. profDeleteTimerStr, PST.kcolors.ANCIENT_ORANGE})
                tScreen:DrawNodeBox("Profile " .. self.hoveredProfileID, newDesc)
            else
                local newDesc = {
                    "Switching to this profile will initialize fresh progress on it."
                }
                if Isaac.IsInGame() then
                    table.insert(newDesc, {"Currently in a run, cannot switch profiles!", PST.kcolors.LIGHTRED1})
                end
                tScreen:DrawNodeBox("Uninitialized Profile", newDesc)
            end
        end
    end
end