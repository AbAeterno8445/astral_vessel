PSTAVessel.AppearanceMenuID = "appearance"

include("scripts.menus.appearance.appearanceMenuColorTab")
include("scripts.menus.appearance.appearanceMenuHairTab")
include("scripts.menus.appearance.appearanceMenuFaceTab")
include("scripts.menus.appearance.appearanceMenuAccTab")

local layerHierarchy = {
    glow = 1,
    body = 2,
    body0 = 3, body1 = 4,
    head = 5,
    head0 = 6, head1 = 7, head2 = 8, head3 = 9, head4 = 10, head5 = 11,
    top0 = 12,
    extra = 13
}
local function PSTAVessel_layerHierarchySort(a, b)
    return (a[3] or 14) < (b[3] or 14)
end

local charDirs = {"Down", "Left", "Up", "Right"}

function PSTAVessel:initAppearanceMenu()
    local appearanceMenu = {
        BGSprite = Sprite("gfx/ui/astralvessel/tree_bg.anm2", true),
        charSprite = Sprite("gfx/001.000_player.anm2", true),
        currentTab = 1,

        tabs = {"Color", "Hairstyle", "Face", "Accessories"},

        -- Tab vals
        colorTabSel = 1,
        hairTabSel = 1,
        hairTabColorSel = false,
        faceTabSel = 1,
        accTabSel = 1,

        currentCharDir = 1,

        inputOverrides = {
            PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
            PSTKeybind.CENTER_CAMERA, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
            PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE, PSTKeybind.TOGGLE_TREE_MODS
        }
    }
    PST.treeScreen.modules.menuScreensModule.menus[PSTAVessel.AppearanceMenuID] = appearanceMenu

    -- Init
    appearanceMenu.BGSprite:Play("Pixel", true)
    for i=0,14 do
        appearanceMenu.charSprite:ReplaceSpritesheet(i, "gfx/characters/costumes/character_astralvessel.png", true)
    end

    function appearanceMenu:OnOpen()
        self.currentTab = 1
        self.colorTabSel = 1
        self.hairTabSel = 1
        self.faceTabSel = 1
        self.accTabSel = 1

        -- Selected hair from load
        if PSTAVessel.charHair then
            for i, tmpHair in ipairs(PSTAVessel.hairstyles) do
                if tmpHair.path == PSTAVessel.charHair.path and (not PSTAVessel.charHair.variant or (PSTAVessel.charHair.variant and tmpHair.variant == PSTAVessel.charHair.variant)) then
                    self.hairTabSel = i
                    break
                end
            end
        end
        -- Selected face from load
        if PSTAVessel.charFace then
            for i, tmpFace in ipairs(PSTAVessel.facesList) do
                if tmpFace.path == PSTAVessel.charFace.path then
                    self.faceTabSel = i
                    break
                end
            end
        end
    end

    function appearanceMenu:OnClose()
        PSTAVessel:save()
    end

    function appearanceMenu:OnSwitchTab()
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
    end

    function appearanceMenu:OnInput()
        -- Tab-specific inputs
        if self.currentTab == 1 then
            PSTAVessel:appMenuColorTabInput(self)
        elseif self.currentTab == 2 then
            PSTAVessel:appMenuHairTabInput(self)
        elseif self.currentTab == 3 then
            PSTAVessel:appMenuFaceTabInput(self)
        elseif self.currentTab == 4 then
            PSTAVessel:appMenuAccTabInput(self)
        end

        -- Input: Change tab
        if PST:isKeybindActive(PSTKeybind.TREE_TAB) then
            self.hairTabColorSel = false
            self.currentTab = self.currentTab + 1
            if self.currentTab > #self.tabs then self.currentTab = 1 end
            self:OnSwitchTab()
        end

        -- Input: Shift + V, rotate character
        if PST:isKeybindActive(PSTKeybind.CENTER_CAMERA) then
            self.currentCharDir = self.currentCharDir + 1
            if self.currentCharDir > 4 then self.currentCharDir = 1 end
        end

        -- Input: Nums (for tab switching)
        for i=1,#self.tabs do
            if PST:isKeybindActive(PSTKeybind["NUM" .. tostring(i)]) then
                self.currentTab = i
                self:OnSwitchTab()
                break
            end
        end
    end

    function appearanceMenu:Update(tScreen)
        tScreen.hideHUD = true
        tScreen.hideNodes = true
        tScreen.disableCursor = true
    end

    function appearanceMenu:Render(tScreen)
        local tmpDrawX = tScreen.screenW / 2
        local tmpDrawY = tScreen.screenH / 2

        local charDir = charDirs[self.currentCharDir]

        local renderList = {}
        local layerList = {}

        -- Draw character
        self.charSprite.Color = PSTAVessel.charColor
        table.insert(layerList, {self.charSprite, "Head" .. charDir, "head"})
        table.insert(layerList, {self.charSprite, "Walk" .. charDir, "body"})

        -- Render chosen face
        if PSTAVessel.charFace then
            if not PSTAVessel.charFace.sprite and PSTAVessel.charFace.path ~= "none" then
                PSTAVessel.charFace.sprite = Sprite(PSTAVessel.charFace.path, true)
            end
            local pickedFaceSprite = PSTAVessel.charFace.sprite
            if pickedFaceSprite then
                pickedFaceSprite.Color.A = 1
                table.insert(renderList, {pickedFaceSprite, "Head" .. charDir})
            end
        end
        -- Render accessories
        if #PSTAVessel.charAccessories > 0 then
            for _, tmpAccessoryID in ipairs(PSTAVessel.charAccessories) do
                local tmpAcc = PSTAVessel.accessoryMap[tmpAccessoryID]
                if tmpAcc then
                    if not tmpAcc.costumeSprite and not tmpAcc.sprite and not tmpAcc.item then
                        if tmpAcc.path and tmpAcc.path ~= "none" then
                            tmpAcc.sprite = Sprite(tmpAcc.path, true)
                        end
                    elseif tmpAcc.item then
                        local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpAcc.item)
                        if itemCfg then
                            tmpAcc.costumeSprite = Sprite(itemCfg.Costume.Anm2Path, true)
                            tmpAcc.sprite = Sprite("gfx/005.100_collectible.anm2", true)
                            tmpAcc.sprite:Play("ShopIdle")
                            tmpAcc.sprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
                        end
                    end
                    if tmpAcc.costumeSprite then
                        tmpAcc.costumeSprite.Color.A = 1
                        table.insert(renderList, {tmpAcc.costumeSprite, "Walk" .. charDir})
                        table.insert(renderList, {tmpAcc.costumeSprite, "Head" .. charDir})
                    elseif tmpAcc.sprite then
                        tmpAcc.sprite.Color.A = 1
                        table.insert(renderList, {tmpAcc.sprite, "ShopIdle"})
                    end
                end
            end
        end
        -- Render chosen hair
        if PSTAVessel.charHair then
            if not PSTAVessel.charHair.sprite then
                PSTAVessel.charHair.sprite = Sprite(PSTAVessel.charHair.path, true)
                if PSTAVessel.charHair.variant then
                    PSTAVessel.charHair.sprite:ReplaceSpritesheet(0, PSTAVessel.charHair.variant, true)
                end
            end
            local pickedHairSprite = PSTAVessel.charHair.sprite
            if pickedHairSprite then
                pickedHairSprite.Color = PSTAVessel.charHairColor
                table.insert(renderList, {pickedHairSprite, "Head" .. charDir})
            end
        end

        --[[
            1. All sprites to be rendered are added to renderList
            2. Go through all sprites, and for every layer that exists, add an entry to a new layerList, with
            sprite + anim + layer to be rendered
            3. Order layerList based on costume layer hierarchy
            4. Go through the list in order, make all layers but the one to be rendered invisible in the sprite,
            and render the sprite
        ]]
        for _, tmpSpriteData in ipairs(renderList) do
            ---@type Sprite
            local tmpSprite = tmpSpriteData[1]
            for _, tmpLayer in ipairs(tmpSprite:GetAllLayers()) do
                local layerName = tmpLayer:GetName()
                if layerHierarchy[layerName] then
                    table.insert(layerList, {tmpSprite, tmpSpriteData[2], layerName})
                end
            end
        end
        table.sort(layerList, PSTAVessel_layerHierarchySort)
        for _, tmpLayerData in ipairs(layerList) do
            -- Make all layers but the one to be drawn invisible
            local spriteLayers = tmpLayerData[1]:GetAllLayers()
            for _, tmpLayer in ipairs(spriteLayers) do
                tmpLayer:SetVisible(tmpLayer:GetName() == tmpLayerData[3])
            end
            tmpLayerData[1]:SetFrame(tmpLayerData[2], 0)
            tmpLayerData[1]:Render(Vector(tmpDrawX, tmpDrawY))

            -- Return layers to normal
            for _, tmpLayer in ipairs(spriteLayers) do
                tmpLayer:SetVisible(true)
            end
        end

        -- Tab-specific rendering
        if self.currentTab == 1 then
            -- Color tab
            PSTAVessel:appearanceMenuColorTab(self, tScreen)
        elseif self.currentTab == 2 then
            -- Hairstyle tab
            PSTAVessel:appearanceMenuHairTab(self, tScreen)
        elseif self.currentTab == 3 then
            -- Face tab
            PSTAVessel:appearanceMenuFaceTab(self, tScreen)
        elseif self.currentTab == 4 then
            -- Accessories tab
            PSTAVessel:appearanceMenuAccTab(self, tScreen)
        end

        -- HUD: Tabs
        local tabW, tabH = 70, 20
        self.BGSprite.Scale = Vector(tabW, tabH)
        for i, tmpTab in ipairs(self.tabs) do
            local drawX = tScreen.screenW / 2 - (#self.tabs * tabW) / 2 + ((i - 1) * tabW)

            local tmpColor = PST.kcolors.WHITE
            local tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.1, 0.1)
            if i == self.currentTab then
                tmpColor = PST.kcolors.SKY_BLUE
                tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.45, 0.6)
            end
            self.BGSprite.Color = tmpBGColor
            self.BGSprite:Render(Vector(drawX, 0))

            PST.miniFont:DrawString(tmpTab, drawX, 2, tmpColor, tabW, true)
        end
        local tmpStr = "Press TAB or 1 2 3 4 nums to switch tabs | Shift + V to rotate the character preview"
        PST.miniFont:DrawStringScaled(tmpStr, tScreen.screenW / 2 - PST.luaminiFont:GetStringWidth(tmpStr) / 4, tabH, 0.5, 0.5, PST.kcolors.WHITE)
    end
end