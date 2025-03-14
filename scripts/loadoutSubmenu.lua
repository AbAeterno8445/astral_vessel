PSTAVessel.loadoutSubmenuID = "loadouts"

function PSTAVessel:initLoadoutSubmenu()
    local loadoutSubmenu = {
        menuX = 0,
        menuY = 0,
        hoveredLoadoutID = nil,
        loadoutUISprite = Sprite("gfx/ui/astralvessel/loadouts_ui.anm2", true)
    }

    -- Init
    PST.treeScreen.modules.submenusModule.submenus[PSTAVessel.loadoutSubmenuID] = loadoutSubmenu
    loadoutSubmenu.loadoutUISprite:Play("Default")

    function loadoutSubmenu:OnOpen(openData)
        if not openData then return end
        for k, v in pairs(openData) do
            if self[k] ~= nil then self[k] = v end
        end
    end

    function loadoutSubmenu:Update()
        -- Input: Allocate
        if self.hoveredLoadoutID and tostring(self.hoveredLoadoutID) ~= PSTAVessel.currentLoadout then
            if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
                PSTAVessel:saveLoadout()
                PSTAVessel:switchLoadout(tostring(self.hoveredLoadoutID))
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            end
        end
    end

    function loadoutSubmenu:Render(tScreen, submenusModule)
        self.hoveredLoadoutID = nil
        submenusModule:DrawNodeSubMenu(
            tScreen,
            PSTAVessel.maxLoadouts,
            tScreen.camCenterX, tScreen.camCenterY,
            self.menuX, self.menuY,
            "Vessel Loadouts",
            function()
                for i=1,PSTAVessel.maxLoadouts do
                    local tmpLoadout = PSTAVessel.charLoadouts[tostring(i)]
                    local drawX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local drawY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                    self.loadoutUISprite.Color.A = 1
                    -- Hovered
                    if self.hoveredLoadoutID == nil then
                        if tScreen.camCenterX > drawX - 16 and tScreen.camCenterX < drawX + 16 and
                        tScreen.camCenterY > drawY - 16 and tScreen.camCenterY < drawY + 16 then
                            self.hoveredLoadoutID = i
                            tScreen.cursorHighlight = true
                        else
                            self.loadoutUISprite.Color.A = 0.5
                        end
                    else
                        self.loadoutUISprite.Color.A = 0.5
                    end

                    if tmpLoadout or PSTAVessel.currentLoadout == tostring(i) then
                        self.loadoutUISprite:SetFrame("Default", 0)
                    else
                        self.loadoutUISprite:SetFrame("Default", 1)
                    end
                    local finalDrawX = drawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local finalDrawY = drawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    self.loadoutUISprite:Render(Vector(finalDrawX, finalDrawY))

                    PST.miniFont:DrawString(tostring(i), finalDrawX + 7, finalDrawY, PST.kcolors.WHITE)

                    if PSTAVessel.currentLoadout == tostring(i) then
                        self.loadoutUISprite.Color.A = 1
                        self.loadoutUISprite:SetFrame("Default", 2)
                        self.loadoutUISprite:Render(Vector(finalDrawX, finalDrawY))
                    end
                end
            end
        )
    end
end