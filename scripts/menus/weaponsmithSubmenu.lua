PSTAVessel.weaponsmithSubmenuID = "vesselWeaponsmith"

function PSTAVessel:initWeaponsmithSubmenu()
    local weaponsmithSubmenu = {
        menuX = 0,
        menuY = 0,
        hoveredType = nil,

        totalWeaponTypes = 15,

        weaponSprite = Sprite("gfx/ui/skilltrees/nodes/astral_weapons.anm2", true),
        selectedIcon = Sprite("gfx/ui/astralvessel/loadouts_ui.anm2", true)
    }

    -- Init
    weaponsmithSubmenu.selectedIcon:SetFrame("Default", 2)
    weaponsmithSubmenu.selectedIcon.Color.A = 0.8
    PST.treeScreen.modules.submenusModule.submenus[PSTAVessel.weaponsmithSubmenuID] = weaponsmithSubmenu

    function weaponsmithSubmenu:OnOpen(openData)
        if not openData then return end
        for k, v in pairs(openData) do
            if self[k] ~= nil then self[k] = v end
        end

        self.totalWeaponTypes = 0
        for _ in pairs(PSTAstralWepType) do
            self.totalWeaponTypes = self.totalWeaponTypes + 1
        end
    end

    function weaponsmithSubmenu:OnClose()
        PSTAVessel:save()
    end

    function weaponsmithSubmenu:Update()
        -- Input: Allocate
        if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
            if self.hoveredType then
                PSTAVessel.weaponsmithType = self.hoveredType
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            end
        end
    end

    function weaponsmithSubmenu:Render(tScreen, submenusModule)
        self.hoveredType = nil
        submenusModule:DrawNodeSubMenu(
            tScreen,
            self.totalWeaponTypes + 5,
            tScreen.camCenterX, tScreen.camCenterY,
            self.menuX, self.menuY,
            "Side Weapon Type",
            function()
                for i=1,self.totalWeaponTypes do
                    local drawX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local drawY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 40
                    local isSelected = (PSTAVessel.weaponsmithType == i - 1)

                    -- Hovered
                    if self.hoveredType == nil then
                        if tScreen.camCenterX > drawX - 16 and tScreen.camCenterX < drawX + 16 and
                        tScreen.camCenterY > drawY - 16 and tScreen.camCenterY < drawY + 16 then
                            self.hoveredType = i - 1
                            tScreen.cursorHighlight = true
                        else
                            self.weaponSprite.Color.A = 0.5
                        end
                    else
                        self.weaponSprite.Color.A = 0.5
                    end

                    local finalDrawX = drawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local finalDrawY = drawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    local renderWepData = {
                        type = i - 1,
                        rarity = PSTAstralWepRarity.NORMAL
                    }
                    PST:renderAstralWepAt(renderWepData, self.weaponSprite, finalDrawX, finalDrawY)
                    self.weaponSprite.Color.A = 1

                    if isSelected then
                        self.selectedIcon:Render(Vector(finalDrawX, finalDrawY))
                    end
                end
            end
        )

        -- Hovered weapon type
        if self.hoveredType ~= nil then
            local wepDesc = {}
            local wepName = "Unknown Weapon Type"
            local wepData = PST.astralWepData[self.hoveredType]
            if wepData then
                wepName = wepData.name

                -- Implicit modifier data
                if wepData.implicitMod then
                    table.insert(wepDesc, "Implicit modifier:")

                    local impRolls = wepData.implicitMod.rollsFunc(0)
                    for tmpTgtRoll, tmpRollVal in pairs(impRolls) do
                        impRolls[tmpTgtRoll] = tmpRollVal
                    end
                    local targetDesc = wepData.implicitMod.description
                    if type(targetDesc) == "table" then
                        for _, tmpLine in ipairs(targetDesc) do
                            table.insert(wepDesc, PST:formatString("   " .. tmpLine, impRolls))
                        end
                    else
                        table.insert(wepDesc, PST:formatString("   " .. targetDesc, impRolls))
                    end
                end
            end
            tScreen:DrawNodeBox(wepName, wepDesc)
        end
    end
end