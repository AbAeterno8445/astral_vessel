local tmpInputTimer = 0
local tmpColorList = {"R", "G", "B"}
function PSTAVessel:appMenuColorTabInput(appearanceMenu)
    -- Input: Directional keys (tap)
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP) then
        -- UP
        appearanceMenu.colorTabSel = appearanceMenu.colorTabSel - 1
        if appearanceMenu.colorTabSel <= 0 then appearanceMenu.colorTabSel = 3 end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN) then
        -- DOWN
        appearanceMenu.colorTabSel = appearanceMenu.colorTabSel + 1
        if appearanceMenu.colorTabSel > 3 then appearanceMenu.colorTabSel = 1 end
    end

    -- Input: Directional keys (held)
    if tmpInputTimer == 0 then
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
            -- LEFT
            local reduce = 0.01
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
                reduce = 0.1
            end
            PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] = PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] - reduce
            if PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] < 0 then
                PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] = 0
            end
            tmpInputTimer = 6
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
            -- RIGHT
            local add = 0.01
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
                add = 0.1
            end
            PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] = PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] + add
            if PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] > 2 then
                PSTAVessel.charColor[tmpColorList[appearanceMenu.colorTabSel]] = 2
            end
            tmpInputTimer = 6
        end
    end

    if tmpInputTimer > 0 then tmpInputTimer = tmpInputTimer - 1 end
end

-- Appearance Menu - Color tab rendering
function PSTAVessel:appearanceMenuColorTab(appearanceMenu, tScreen)
    local tmpDrawX = tScreen.screenW / 2 - 100
    local tmpDrawY = tScreen.screenH / 2 - 40

    -- Red
    local tmpColor = PST.kcolors.WHITE
    if appearanceMenu.colorTabSel == 1 then
        tmpColor = PST.kcolors.RED1
    end
    PST.normalFont:DrawString("Red: " .. PSTAVessel:getColorStr(PSTAVessel.charColor.R), tmpDrawX, tmpDrawY, tmpColor)
    tmpDrawY = tmpDrawY + 18

    -- Green
    tmpColor = PST.kcolors.WHITE
    if appearanceMenu.colorTabSel == 2 then
        tmpColor = PST.kcolors.GREEN1
    end
    PST.normalFont:DrawString("Green: " .. PSTAVessel:getColorStr(PSTAVessel.charColor.G), tmpDrawX, tmpDrawY, tmpColor)
    tmpDrawY = tmpDrawY + 18

    -- Blue
    tmpColor = PST.kcolors.WHITE
    if appearanceMenu.colorTabSel == 3 then
        tmpColor = PST.kcolors.BLUE1
    end
    PST.normalFont:DrawString("Blue: " .. PSTAVessel:getColorStr(PSTAVessel.charColor.B), tmpDrawX, tmpDrawY, tmpColor)
end