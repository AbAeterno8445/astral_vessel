PSTAVessel.NexusMenuID = "stellarNexus"

local tabCols = 5
local itemCols = 8
local maxDescLineLen = 150

function PSTAVessel:initNexusMenu()
    local nexusMenu = {
        BGSprite = Sprite("gfx/ui/astralvessel/tree_bg.anm2", true),
        itemSprite = Sprite("gfx/005.100_collectible.anm2", true),
        bubbleSprite = Sprite("gfx/ui/astralvessel/selection_bubble.anm2", true),
        beamSprite = Sprite("gfx/ui/astralvessel/ui_beams.anm2", true),

        currentTab = 1,
        tabs = {
            PSTAVConstellationType.DIVINE, PSTAVConstellationType.DEMONIC, PSTAVConstellationType.OCCULT, PSTAVConstellationType.MERCANTILE,
            PSTAVConstellationType.ELEMENTAL, PSTAVConstellationType.COSMIC, PSTAVConstellationType.MUTAGENIC, PSTAVConstellationType.MUNDANE
        },

        hoveredItem = nil,

        -- Selected starting item # from the left 'inventory' menu
        invSelected = nil,

        -- Camera control
        camera = Vector.Zero,
        cameraSpeed = 3,
        camCenterX = Isaac.GetScreenWidth() / 2,
        camCenterY = Isaac.GetScreenHeight() / 2,

        inputOverrides = {
            PSTKeybind.TREE_PAN_DOWN, PSTKeybind.TREE_PAN_LEFT, PSTKeybind.TREE_PAN_RIGHT, PSTKeybind.TREE_PAN_UP,
            PSTKeybind.CENTER_CAMERA, PSTKeybind.PAN_FASTER, PSTKeybind.TREE_TAB,
            PSTKeybind.ALLOCATE_NODE, PSTKeybind.RESPEC_NODE, PSTKeybind.SWITCH_TREE, PSTKeybind.TOGGLE_TREE_MODS
        }
    }
    PST.treeScreen.modules.menuScreensModule.menus[PSTAVessel.NexusMenuID] = nexusMenu

    -- Init
    nexusMenu.BGSprite:Play("Pixel", true)
    nexusMenu.itemSprite:Play("ShopIdle", true)
    nexusMenu.bubbleSprite:SetFrame("Default", 0)
    nexusMenu.beamSprite:SetFrame("Default", 0)

    function nexusMenu:DrawUIBox(x, y, w, h)
        self.BGSprite.Scale.X = w
        self.BGSprite.Scale.Y = h
        self.BGSprite:Render(Vector(x, y))

        -- Top decor beam
        local linkBeam = Beam(self.beamSprite, 0, false, false)
        local startPos = Vector(x, y)
        local endPos = Vector(x + w, y)
        linkBeam:Add(startPos, 0)
        linkBeam:Add(endPos, 129)
        linkBeam:Render()

        -- Left decor beam
        startPos = Vector(x, y)
        endPos = Vector(x, y + h)
        linkBeam:Add(startPos, 0)
        linkBeam:Add(endPos, 129)
        linkBeam:Render()

        -- Right decor beam
        startPos = Vector(x + w, y + h)
        endPos = Vector(x + w, y)
        linkBeam:Add(startPos, 0)
        linkBeam:Add(endPos, 129)
        linkBeam:Render()

        -- Bottom decor beam
        startPos = Vector(x + w, y + h)
        endPos = Vector(x, y + h)
        linkBeam:Add(startPos, 0)
        linkBeam:Add(endPos, 129)
        linkBeam:Render()
    end

    function nexusMenu:OnOpen()
        self.invSelected = nil
        self.camera = Vector.Zero
    end

    function nexusMenu:OnClose()
        PSTAVessel:save()
    end

    function nexusMenu:OnSwitchTab()
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
    end

    function nexusMenu:OnInput()
        local currentType = self.tabs[self.currentTab]
        local totalItemsLen = 0
        for i=0,3 do
            totalItemsLen = totalItemsLen + #PSTAVessel.constelItems[currentType]["Q" .. i]
        end

        -- Input: Faster panning
        if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            self.cameraSpeed = 8
        else
            self.cameraSpeed = 3
        end
        -- Input: Directional keys/buttons
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP, true) then
            -- UP
            if not self.invSelected then
                if self.camera.Y > -2000 then
                    self.camera.Y = self.camera.Y - self.cameraSpeed
                end
            end
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN, true) then
            -- DOWN
            if not self.invSelected then
                if self.camera.Y < 2000 then
                    self.camera.Y = self.camera.Y + self.cameraSpeed
                end
            end
        end
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
            -- LEFT
            if not self.invSelected then
                if self.camera.X > -2000 then
                    self.camera.X = self.camera.X - self.cameraSpeed
                end
            end
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
            -- RIGHT
            if not self.invSelected then
                if self.camera.X < 2000 then
                    self.camera.X = self.camera.X + self.cameraSpeed
                end
            end
        end

        -- Input: Directional keys (tap)
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP) then
            -- UP
            if self.invSelected then
                self.invSelected = self.invSelected - 1
                if self.invSelected <= 0 then self.invSelected = 4 end
            end
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN) then
            -- DOWN
            if self.invSelected then
                self.invSelected = self.invSelected + 1
                if self.invSelected > 4 then self.invSelected = 1 end
            end
        end

        -- Input: Allocate
        if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
            -- Attempt to purchase hovered item with the current type's affinity
            if self.hoveredItem then
                local itemCost = PSTAVessel.constelItemCosts[self.hoveredItem.item]
                local availableAff = (PSTAVessel.constelAlloc[currentType].affinity or 0) - (PSTAVessel.constelAlloc[currentType].spent or 0)

                -- Conditions: Can afford
                local canAfford = availableAff >= itemCost
                -- Can pick active items
                local canActive = not self.hoveredItem.active or (self.hoveredItem.active and PSTAVessel.charActivesAllowed and not PSTAVessel:charHasStartingActive())
                -- Can pick items of this quality
                local canQuality = self.hoveredItem.qual <= PSTAVessel.charMaxQuality
                local canQualityMax = PSTAVessel:charGetQualStartingQuant(self.hoveredItem.qual) < PSTAVessel.charMaxPerQuality[self.hoveredItem.qual + 1]
                -- Whether starting item limit is reached
                local canPick = #PSTAVessel.charStartItems < PSTAVessel.charMaxStartItems

                if canAfford and canActive and canQuality and canQualityMax and canPick and not PSTAVessel:charHasStartingItem(self.hoveredItem.item) then
                    table.insert(PSTAVessel.charStartItems, {
                        item = self.hoveredItem.item,
                        active = self.hoveredItem.active,
                        spent = itemCost,
                        spentType = currentType,
                        qual = self.hoveredItem.qual
                    })
                    if not PSTAVessel.constelAlloc[currentType].spent then PSTAVessel.constelAlloc[currentType].spent = 0 end
                    PSTAVessel.constelAlloc[currentType].spent = PSTAVessel.constelAlloc[currentType].spent + itemCost
                    SFXManager():Play(SoundEffect["SOUND_POWERUP" .. math.max(1, math.min(3, self.hoveredItem.qual))], 0.8)
                else
                    SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.8)
                end
            end
        end

        -- Input: Respec
        if PST:isKeybindActive(PSTKeybind.RESPEC_NODE) then
            -- Attempt to refund hovered item if it was purchased with the current type's affinity
            local tmpItem = self.hoveredItem
            if self.invSelected then tmpItem = PSTAVessel.charStartItems[self.invSelected] end

            if tmpItem then
                local removeIdx = nil
                if not self.invSelected then
                    for i, startItem in ipairs(PSTAVessel.charStartItems) do
                        if tmpItem.item == startItem.item and startItem.spentType == currentType then
                            removeIdx = i
                            PSTAVessel.constelAlloc[currentType].spent = math.max(0, PSTAVessel.constelAlloc[currentType].spent - startItem.spent)
                            break
                        end
                    end
                else
                    local spentType = tmpItem.spentType
                    PSTAVessel.constelAlloc[spentType].spent = math.max(0, PSTAVessel.constelAlloc[spentType].spent - tmpItem.spent)
                    removeIdx = self.invSelected
                end
                if removeIdx then
                    table.remove(PSTAVessel.charStartItems, removeIdx)
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
                end
            end
        end

        -- Input: Switch Tree
        if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
            if not self.invSelected then self.invSelected = 1
            else self.invSelected = nil end
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.8, 2, false, 1.15)
        end

        -- Input: Center camera
        if PST:isKeybindActive(PSTKeybind.CENTER_CAMERA) then
            self.camera = Vector.Zero
        end

        -- Input: Change tab
        if PST:isKeybindActive(PSTKeybind.TREE_TAB) then
            self.currentTab = self.currentTab + 1
            if self.currentTab > #self.tabs then self.currentTab = 1 end
            self:OnSwitchTab()
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

    function nexusMenu:Update(tScreen)
        tScreen.hideHUD = true
        tScreen.hideNodes = true
        tScreen.disableCursor = true
        self.hoveredItem = nil
    end

    function nexusMenu:Render(tScreen)
        local tmpDrawX = self.camCenterX - self.camera.X
        local tmpDrawY = self.camCenterY - self.camera.Y

        local currentType = self.tabs[self.currentTab]
        local qualDrawX = tmpDrawX - 200
        local qualDrawY = tmpDrawY - 80
        local drawnTotal = 0
        for qual=0,3 do
            -- Draw items
            local tmpItemList = PSTAVessel.constelItems[currentType]["Q" .. qual]
            local drawn = 0
            for i, tmpItem in ipairs(tmpItemList) do
                local itemX = qualDrawX + 18 + ((i - 1) % itemCols) * 36
                local itemY = qualDrawY + 42 + math.floor((i - 1) / itemCols) * 36
                self.itemSprite:ReplaceSpritesheet(1, tmpItem.gfx, true)
                self.itemSprite.Color.A = 1
                if (tmpItem.active and not PSTAVessel.charActivesAllowed) or (qual > PSTAVessel.charMaxQuality) then
                    self.itemSprite.Color.A = 0.4
                end

                -- Selected
                if PSTAVessel:charHasStartingItem(tmpItem.item) then
                    self.bubbleSprite:SetFrame("Default", 1)
                    self.bubbleSprite:Render(Vector(itemX, itemY - 7))
                end

                -- Hovered
                local tmpSize = 16
                if self.camCenterX >= itemX - tmpSize and self.camCenterX <= itemX + tmpSize and
                self.camCenterY >= itemY - tmpSize - 9 and self.camCenterY <= itemY + tmpSize - 9 then
                    self.hoveredItem = tmpItem
                    if self.itemSprite.Color.A == 1 then
                        self.itemSprite.Color.A = 1.5
                    end
                    tScreen.cursorHighlight = true
                end

                self.itemSprite:Render(Vector(itemX, itemY))
                drawn = i

                drawnTotal = drawnTotal + 1
            end
            if drawn > 0 then
                PST.miniFont:DrawString("Q" .. qual .. " Items:", qualDrawX, qualDrawY, PST.kcolors.WHITE)
                qualDrawY = qualDrawY + 54 + 42 * math.floor((drawn - 1) / itemCols)
            end
        end

        -- Cursor
        if self.hoveredItem then
            tScreen.cursorSprite:Play("Clicked", true)
        else
            tScreen.cursorSprite:Play("Idle", true)
        end
        tScreen.cursorSprite:Render(Vector(self.camCenterX, self.camCenterY))

        -- Hovered item description
        if self.hoveredItem then
            -- Afinity cost
            local tmpCost = PSTAVessel.constelItemCosts[self.hoveredItem.item] or 2
            -- EID description
            if EID then
                local desc = EID:getDescriptionObj(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, self.hoveredItem.item, nil, false)

                -- Create full description table
                local origLines = PSTAVessel:strSplit(desc.Description, '#')
                local tmpLines = {}
                -- Split lines that are too long
                for _, tmpLine in ipairs(origLines) do
                    while #tmpLine > maxDescLineLen do
                        local cutPos = tmpLine:sub(1, maxDescLineLen):match(".*%s()")
                        if cutPos then
                            table.insert(tmpLines, tmpLine:sub(1, cutPos - 1))
                            tmpLine = tmpLine:sub(cutPos + 1)
                        else
                            table.insert(tmpLine, tmpLine:sub(1, maxDescLineLen))
                            tmpLine = tmpLine:sub(maxDescLineLen + 1)
                        end
                    end
                    if #tmpLine > 0 then
                        table.insert(tmpLines, tmpLine)
                    end
                end

                table.insert(tmpLines, 1, desc.Name .. " {{Quality" .. self.hoveredItem.qual .. "}}")
                -- Active item
                local tmpItemTypeStr = ""
                if self.hoveredItem.active then
                    tmpItemTypeStr = "{{Battery}}{{ColorYellow}}Active "
                end
                -- All constellation types for the item
                tmpItemTypeStr = tmpItemTypeStr .. "{{AVessel" .. currentType .. "}}" .. currentType
                for _, tmpIType in ipairs(self.hoveredItem.types) do
                    if tmpIType ~= currentType then
                        local tmpTypeColor = "{{AVessel" .. tmpIType .. "}}"
                        tmpItemTypeStr = tmpItemTypeStr .. tmpTypeColor .. " " .. tmpIType
                    end
                end
                table.insert(tmpLines, 2, tmpItemTypeStr)
                -- Source mod
                if self.hoveredItem.sourceMod then
                    table.insert(tmpLines, 2, "{{ColorTransform}}Source mod: " .. self.hoveredItem.sourceMod)
                end

                if not PSTAVessel:charHasStartingItem(self.hoveredItem.item) then
                    -- Afinity cost
                    local tmpColorStr = "{{AVessel" .. currentType .. "}}"
                    local canAfford = (tmpCost <= (PSTAVessel.constelAlloc[currentType].affinity or 0) - (PSTAVessel.constelAlloc[currentType].spent or 0))
                    if not canAfford then
                        tmpColorStr = "{{ColorError}}"
                    end
                    table.insert(tmpLines, tmpColorStr .. "Cost: " .. tmpCost .. " " .. currentType .. " Affinity.")

                    -- Whether you can pick active items
                    local hasStartingActive = self.hoveredItem.active and PSTAVessel:charHasStartingActive()
                    local canActive = not self.hoveredItem.active or (self.hoveredItem.active and PSTAVessel.charActivesAllowed)
                    if not canActive then
                        table.insert(tmpLines, "{{ColorError}}Active items are locked.")
                    elseif hasStartingActive then
                        table.insert(tmpLines, "{{ColorError}}You already have an active item selected!")
                    end

                    -- Whether you can pick items of this quality
                    local qual = self.hoveredItem.qual
                    local canQuality = qual <= PSTAVessel.charMaxQuality
                    if not canQuality then
                        table.insert(tmpLines, "{{ColorError}}Quality " .. qual .. " items are locked.")
                    end

                    -- Whether max items of this quality have been picked
                    local canQualityMax = PSTAVessel:charGetQualStartingQuant(qual) < PSTAVessel.charMaxPerQuality[qual + 1]
                    if not canQualityMax then
                        table.insert(tmpLines, "{{ColorError}}Maximum quality " .. qual .. " items selected.")
                    end

                    -- Whether starting item limit is reached
                    local canPick = #PSTAVessel.charStartItems < PSTAVessel.charMaxStartItems
                    if not canPick then
                        table.insert(tmpLines, "{{ColorError}}You have reached the max amount of starting items!")
                    end

                    if canAfford and canPick and canActive and canQuality and canQualityMax and not hasStartingActive then
                        table.insert(tmpLines, "Press Allocate to add this item to your starting items loadout.")
                    end
                else
                    -- Item already picked
                    table.insert(tmpLines, "Press Respec to remove this item from your starting loadout.")
                end

                -- Get longest line to get BG width
                local longestLine = 0
                for _, tmpLine in ipairs(tmpLines) do
                    local lineNoMarkup = tmpLine:gsub("{{.-}}", "")
                    local lineTotalMarkups = 0
                    for _ in tmpLine:gmatch("{{.-}}") do
                        lineTotalMarkups = lineTotalMarkups + 1
                    end
                    local lineWidth = EID:getStrWidth(lineNoMarkup) + lineTotalMarkups * 11
                    if lineWidth > longestLine then longestLine = lineWidth end
                end
                self.BGSprite.Color = Color(0.3, 0.3, 0.3, 1)
                self:DrawUIBox(
                    self.camCenterX - longestLine / 4 - 2,
                    self.camCenterY + 10,
                    longestLine / 2 + 4,
                    2 + #tmpLines * 8
                )

                -- Render description
                for j, tmpLine in ipairs(tmpLines) do
                    local oldScale = EID.Scale
                    EID.Scale = 0.5
                    EID:renderString(
                        tmpLine,
                        Vector(self.camCenterX - longestLine / 4, self.camCenterY + 12 + (j - 1) * 8),
                        Vector(EID.Scale, EID.Scale),
                        PST.kcolors.WHITE
                    )
                    EID.Scale = oldScale
                end
            -- Default, non-EID description
            else
                local tmpDesc = {}
                table.insert(tmpDesc, "Quality: " .. self.hoveredItem.qual)
                table.insert(tmpDesc, {"Cost: " .. tmpCost .. " " .. currentType .. " Affinity.", PSTAVessel.constelKColors[currentType]})
                tScreen:DrawNodeBox(self.hoveredItem.name or "Unknown Item", tmpDesc)
            end
        end

        -- HUD: Affinity + Spent
        local affinityNum = PSTAVessel.constelAlloc[currentType].affinity or 0
        PST.miniFont:DrawString(currentType .. " Affinity: " .. affinityNum, 8, 32, PSTAVessel.constelKColors[currentType])

        local spentNum = PSTAVessel.constelAlloc[currentType].spent or 0
        PST.miniFont:DrawString("Available: " .. affinityNum - spentNum, 8, 48, PSTAVessel.constelKColors[currentType])

        -- HUD: Tabs
        local tabW, tabH = 70, 20
        self.BGSprite.Scale = Vector(tabW, tabH)
        local i = 1
        for _, tmpType in pairs(self.tabs) do
            local drawX = tScreen.screenW / 2 - (math.min(tabCols, #self.tabs - math.floor((i - 1) / tabCols) * tabCols) * tabW) / 2 + ((i - 1) % tabCols) * tabW
            local drawY = 2 + math.floor((i - 1) / tabCols) * tabH

            local tmpColor = PST.kcolors.WHITE
            local tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.1, 0.1)
            if i == self.currentTab then
                tmpColor = PSTAVessel.constelKColors[tmpType]
                tmpBGColor = Color(1, 1, 1, 1, 0.1, 0.45, 0.6)
            end
            self.BGSprite.Color = tmpBGColor
            self.BGSprite:Render(Vector(drawX, drawY - 2))

            PST.miniFont:DrawString(tmpType, drawX, drawY, tmpColor, tabW, true)
            i = i + 1
        end
        local tmpStr = "Press TAB or 1 2 3 ... nums to switch tabs"
        PST.miniFont:DrawStringScaled(tmpStr, tScreen.screenW / 2 - PST.luaminiFont:GetStringWidth(tmpStr) / 4, tabH * 2, 0.5, 0.5, PST.kcolors.WHITE)

        tmpStr = "Press Q to toggle between starting item selection and main view"
        PST.miniFont:DrawStringScaled(tmpStr, tScreen.screenW / 2 - PST.luaminiFont:GetStringWidth(tmpStr) / 4, tScreen.screenH - 14, 0.5, 0.5, PST.kcolors.WHITE)

        -- HUD: Selected items + bubbles
        self.BGSprite.Color = Color(0, 0, 0, 1)
        self:DrawUIBox(8, 70, 24, 90)
        for itemIdx=1,4 do
            local startItem = PSTAVessel.charStartItems[itemIdx]
            local tmpFrame = 0
            if startItem then
                tmpFrame = 1
            end
            if itemIdx > PSTAVessel.charMaxStartItems then
                tmpFrame = 2
            end
            local startItemX = 20
            local startItemY = 82 + (itemIdx - 1) * 22
            local isSelected = (self.invSelected == itemIdx)

            self.bubbleSprite.Color.A = 1
            if isSelected then
                self.bubbleSprite.Color.A = 2
            end
            self.bubbleSprite:SetFrame("Default", tmpFrame)
            self.bubbleSprite.Scale = Vector(0.5, 0.5)
            self.bubbleSprite:Render(Vector(startItemX, startItemY))
            self.bubbleSprite.Scale = Vector.One

            local tmpDescX = startItemX + 17
            local tmpDescY = startItemY - 8
            if startItem then
                local itemCfg = Isaac.GetItemConfig():GetCollectible(startItem.item)
                if itemCfg then
                    self.itemSprite.Color.A = 1
                    self.itemSprite.Scale = Vector(0.5, 0.5)
                    self.itemSprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
                    self.itemSprite:Render(Vector(startItemX, startItemY + 4))
                    self.itemSprite.Scale = Vector.One
                end

                if isSelected then
                    local itemDesc = {
                        "Obtained with: " .. startItem.spent .. " " .. startItem.spentType .. " Affinity.",
                        "Press Respec to refund this item choice."
                    }
                    local itemName = Isaac.GetLocalizedString("Items", itemCfg.Name, "en")
		            if itemName == "StringTable::InvalidKey" then itemName = "Unknown Item" end
                    tScreen:DrawNodeBox(itemName, itemDesc, tmpDescX, tmpDescY, true)
                end
            end

            if isSelected and not startItem then
                if itemIdx <= PSTAVessel.charMaxStartItems then
                    tScreen:DrawNodeBox("Empty Slot", {"Empty starting item slot."}, tmpDescX, tmpDescY, true)
                else
                    tScreen:DrawNodeBox("Locked Slot", {{"Locked starting item slot. Check the Unlocks node in the main tree for more info.", PST.kcolors.RED1}}, tmpDescX, tmpDescY, true)
                end
            end
        end
    end
end