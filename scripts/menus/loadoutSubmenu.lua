PSTAVessel.loadoutSubmenuID = "loadouts"

local loadoutsPerPage = 25

function PSTAVessel:initLoadoutSubmenu()
    local loadoutSubmenu = {
        menuX = 0,
        menuY = 0,
        hoveredLoadoutID = nil,
        loadoutUISprite = Sprite("gfx/ui/astralvessel/loadouts_ui.anm2", true),

        invPage = 0
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
        local totalPages = math.ceil(PSTAVessel.maxLoadouts / loadoutsPerPage)
        submenusModule:DrawNodeSubMenu(
            tScreen,
            loadoutsPerPage,
            tScreen.camCenterX, tScreen.camCenterY,
            self.menuX, self.menuY,
            "Vessel Loadouts",
            function()
                for i=1,loadoutsPerPage do
                    local loadoutID = i + self.invPage * loadoutsPerPage
                    local tmpLoadout = PSTAVessel.charLoadouts[tostring(loadoutID)]
                    local drawX = self.menuX * tScreen.zoomScale - 64 + ((i - 1) % 5) * 32
                    local drawY = self.menuY * tScreen.zoomScale + 52 + math.floor((i - 1) / 5) * 32

                    self.loadoutUISprite.Color.A = 1
                    self.loadoutUISprite.Color.R = 1
                    self.loadoutUISprite.Color.G = 1
                    self.loadoutUISprite.Color.B = 1
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

                    if tmpLoadout or PSTAVessel.currentLoadout == tostring(loadoutID) then
                        self.loadoutUISprite:SetFrame("Default", 0)
                        if tmpLoadout.charColor then
                            self.loadoutUISprite.Color.R = tmpLoadout.charColor[1]
                            self.loadoutUISprite.Color.G = tmpLoadout.charColor[2]
                            self.loadoutUISprite.Color.B = tmpLoadout.charColor[3]
                        end
                    else
                        self.loadoutUISprite:SetFrame("Default", 1)
                    end
                    local finalDrawX = drawX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                    local finalDrawY = drawY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y
                    self.loadoutUISprite:Render(Vector(finalDrawX, finalDrawY))

                    PST.miniFont:DrawString(tostring(loadoutID), finalDrawX + 7, finalDrawY, PST.kcolors.WHITE)

                    if PSTAVessel.currentLoadout == tostring(loadoutID) then
                        self.loadoutUISprite.Color.A = 1
                        self.loadoutUISprite:SetFrame("Default", 2)
                        self.loadoutUISprite:Render(Vector(finalDrawX, finalDrawY))
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
                maxItems = PSTAVessel.maxLoadouts
            }
        )

        -- Hovered loadout
        if self.hoveredLoadoutID then
            local loadoutData = PSTAVessel.charLoadouts[tostring(self.hoveredLoadoutID)]
            if loadoutData then
                local newDesc = {}
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
                    local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpItem.item)
                    if itemCfg then
                        local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
                        if itemName == "StringTable::InvalidKey" then itemName = itemCfg.Name end
                        table.insert(newDesc, {"Starting item: " .. itemName, PST.kcolors.LIGHTBLUE1})
                    end
                end
                tScreen:DrawNodeBox("Loadout " .. self.hoveredLoadoutID, newDesc)
            else
                tScreen:DrawNodeBox("Uninitialized Loadout", {"Switching to this loadout will initialize fresh settings on it."})
            end
        end
    end
end