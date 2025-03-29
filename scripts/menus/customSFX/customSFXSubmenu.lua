PSTAVessel.customSFXSubmenuID = "customSFX"

local minPitch = 0.5
local maxPitch = 2

function PSTAVessel:initCustomSFXSubmenu()
    local customSFXSubmenu = {
        menuX = 0,
        menuY = 0,
        hoveredChoice = nil,
        hoveredSourceName = nil,
        hoveredSourceMod = nil,
        hoveredButton = nil,

        -- "hurt" or "death"
        sfxMode = "hurt",

        sfxNameCache = {},

        sfxIcon = Sprite("gfx/ui/astralvessel/sfx_icon.anm2", true),
        selectedIcon = Sprite("gfx/ui/astralvessel/loadouts_ui.anm2", true)
    }

    -- Init
    customSFXSubmenu.sfxIcon:SetFrame("Default", 0)
    customSFXSubmenu.selectedIcon:SetFrame("Default", 2)
    customSFXSubmenu.selectedIcon.Color.A = 0.8
    PST.treeScreen.modules.submenusModule.submenus[PSTAVessel.customSFXSubmenuID] = customSFXSubmenu

    function customSFXSubmenu:OnOpen(openData)
        if not openData then return end
        for k, v in pairs(openData) do
            if self[k] ~= nil then self[k] = v end
        end
    end

    function customSFXSubmenu:OnClose()
        PSTAVessel:save()
    end

    function customSFXSubmenu:Update()
        -- Input: Allocate
        if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
            if self.hoveredButton then
                -- SFX mode button
                if self.hoveredButton == "mode" then
                    self.sfxMode = (self.sfxMode == "hurt") and "death" or "hurt"
                    if self.sfxMode == "death" then
                        self.sfxIcon.Color = Color(1, 0.4, 0.4, 1, 0.2)
                    else
                        self.sfxIcon.Color = Color()
                    end
                -- Pitch button (increase)
                elseif self.hoveredButton == "pitch" then
                    PSTAVessel.charHurtPitch = math.min(maxPitch, PSTAVessel.charHurtPitch + 0.1)
                -- Pitch variation button
                elseif self.hoveredButton == "pitchVar" then
                    PSTAVessel.charHurtRandpitch = not PSTAVessel.charHurtRandpitch
                end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            -- Sound effect selection
            elseif self.hoveredChoice then
                if self.sfxMode == "hurt" then
                    PSTAVessel.charHurtSFX = self.hoveredChoice
                elseif self.sfxMode == "death" then
                    PSTAVessel.charDeathSFX = self.hoveredChoice
                end
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            end
        end

        -- Input: Respec
        if PST:isKeybindActive(PSTKeybind.RESPEC_NODE) then
            -- Pitch button (decrease)
            if self.hoveredButton == "pitch" then
                PSTAVessel.charHurtPitch = math.max(minPitch, PSTAVessel.charHurtPitch - 0.1)
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            -- Sound effect testing
            elseif self.hoveredChoice then
                local tmpPitch = PSTAVessel.charHurtPitch
                if PSTAVessel.charHurtRandpitch then
                    tmpPitch = tmpPitch - 0.1 + 0.2 * math.random()
                end
                SFXManager():Play(self.hoveredChoice, 1, 2, false, tmpPitch)
            end
        end
    end

    function customSFXSubmenu:Render(tScreen, submenusModule)
        self.hoveredChoice = nil
        self.hoveredSourceName = nil
        self.hoveredSourceMod = nil
        self.hoveredButton = nil
        local targetTable = PSTAVessel.customHurtSFXList
        if self.sfxMode == "death" then
            targetTable = PSTAVessel.customDeathSFXList
        end

        submenusModule:DrawNodeSubMenu(
            tScreen,
            #targetTable + 5,
            tScreen.camCenterX, tScreen.camCenterY,
            self.menuX, self.menuY,
            "Custom Hurt SFX",
            function()
                for i, targetSFXData in ipairs(targetTable) do
                    local targetSFX = targetSFXData

                    local tmpSourceName = nil
                    local tmpSourceMod = nil
                    if type(targetSFXData) == "table" then
                        targetSFX = targetSFXData[1]
                        tmpSourceName = targetSFXData[2] or "Unknown SFX"
                        tmpSourceMod = targetSFXData[3] or ""
                    end
                    local drawX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local drawY = self.menuY * tScreen.zoomScale + 84 + math.floor((i - 1) / 5) * 32

                    -- Hovered
                    self.sfxIcon.Color.A = 1
                    if self.hoveredChoice == nil then
                        if tScreen.camCenterX > drawX - 16 and tScreen.camCenterX < drawX + 16 and
                        tScreen.camCenterY > drawY - 16 and tScreen.camCenterY < drawY + 16 then
                            self.hoveredChoice = targetSFX
                            self.hoveredSourceName = tmpSourceName
                            self.hoveredSourceMod = tmpSourceMod
                            tScreen.cursorHighlight = true

                            -- Fetch SFX name and cache it
                            if not self.sfxNameCache[targetSFX] then
                                local assigned = false
                                for sfxName, sfxVal in pairs(SoundEffect) do
                                    if sfxVal == targetSFX then
                                        self.sfxNameCache[targetSFX] = sfxName
                                        assigned = true
                                        break
                                    end
                                end
                                if not assigned then
                                    self.sfxNameCache[targetSFX] = self.hoveredSourceName or "Unknown SFX"
                                end
                            end
                        else
                            self.sfxIcon.Color.A = 0.5
                        end
                    else
                        self.sfxIcon.Color.A = 0.5
                    end

                    -- Mod compat icon color
                    if tmpSourceMod then
                        self.sfxIcon.Color.GO = 0.4
                        self.sfxIcon.Color.BO = 0.6
                    else
                        self.sfxIcon.Color.GO = 0
                        self.sfxIcon.Color.BO = 0
                    end

                    local finalDrawX = drawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local finalDrawY = drawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    self.sfxIcon:Render(Vector(finalDrawX, finalDrawY))

                    if (self.sfxMode == "hurt" and PSTAVessel.charHurtSFX == targetSFX) or (self.sfxMode == "death" and PSTAVessel.charDeathSFX == targetSFX) then
                        self.selectedIcon:Render(Vector(finalDrawX, finalDrawY))
                    end
                end
            end
        )

        -- SFX mode button
        local tmpDrawX = self.menuX * tScreen.zoomScale - 74
        local tmpDrawY = self.menuY * tScreen.zoomScale + 40
        local tmpColor = PST.kcolors.WHITE
        if tScreen.camCenterX > tmpDrawX and tScreen.camCenterX < tmpDrawX + 54 and
        tScreen.camCenterY > tmpDrawY and tScreen.camCenterY < tmpDrawY + 15 then
            self.hoveredButton = "mode"
            tScreen.cursorHighlight = true
            tmpColor = PST.kcolors.LIGHTBLUE1
        end
        local tmpStr = "Mode: Hurt"
        if self.sfxMode == "death" then
            tmpStr = "Mode: Death"
        end
        PST.miniFont:DrawString(tmpStr, tmpDrawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, tmpDrawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y, tmpColor)

        -- Pitch button
        tmpDrawX = tmpDrawX + 70
        tmpColor = PST.kcolors.WHITE
        if not self.hoveredButton and tScreen.camCenterX > tmpDrawX and tScreen.camCenterX < tmpDrawX + 36 and
        tScreen.camCenterY > tmpDrawY and tScreen.camCenterY < tmpDrawY + 15 then
            self.hoveredButton = "pitch"
            tScreen.cursorHighlight = true
            tmpColor = PST.kcolors.LIGHTBLUE1
        end
        tmpStr = "Pitch: " .. PSTAVessel.charHurtPitch
        PST.miniFont:DrawString(tmpStr, tmpDrawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, tmpDrawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y, tmpColor)

        -- Pitch variation button
        tmpDrawX = tmpDrawX + 54
        tmpColor = PST.kcolors.RED1
        if PSTAVessel.charHurtRandpitch then
            tmpColor = PST.kcolors.LIGHTBLUE1
        end
        if not self.hoveredButton and tScreen.camCenterX > tmpDrawX and tScreen.camCenterX < tmpDrawX + 24 and
        tScreen.camCenterY > tmpDrawY and tScreen.camCenterY < tmpDrawY + 15 then
            self.hoveredButton = "pitchVar"
            tScreen.cursorHighlight = true
        end
        tmpStr = "Var"
        PST.miniFont:DrawString(tmpStr, tmpDrawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X, tmpDrawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y, tmpColor)

        -- Hovered summon description box
        if self.hoveredChoice then
            local sfxName = self.sfxNameCache[self.hoveredChoice] or self.hoveredSourceName or "Unknown SFX"
            local sfxDesc = {
                "Press Allocate to select this sound effect.",
                "Press Respec to test it, using the current pitch config."
            }
            if self.hoveredSourceMod then
                table.insert(sfxDesc, {"Source mod: " .. self.hoveredSourceMod, PST.kcolors.LIGHTBLUE1})
            end
            tScreen:DrawNodeBox(sfxName, sfxDesc)
        -- Hovered SFX mode button
        elseif self.hoveredButton == "mode" then
            tScreen:DrawNodeBox("SFX Mode", {"Press Allocate to switch between selection of Hurt and Death sound effects."})
        -- Hovered pitch button
        elseif self.hoveredButton == "pitch" then
            tScreen:DrawNodeBox("Pitch", {
                "Press Allocate to increase the pitch.",
                "Press Respec to decrease the pitch."
            })
        -- Hovered pitch variation button
        elseif self.hoveredButton == "pitchVar" then
            local tmpExtra = PSTAVessel.charHurtRandpitch and "ON" or "OFF"
            tScreen:DrawNodeBox("Pitch Variation (" .. tmpExtra .. ")", {
                "Press Allocate to toggle hurt sound pitch variation.",
                "This causes the sound to have a slight random pitch variation when played."
            })
        end
    end
end