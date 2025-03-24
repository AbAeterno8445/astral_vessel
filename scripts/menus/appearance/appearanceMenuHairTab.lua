local editingColor = false
local tmpInputTimer = 0
local tmpColorList = {"R", "G", "B"}
local selColor = 1

local hairWheelRad = 60
local hairWheelTotal = 10
local lerpSpeed = 5

local bubbleSpr = Sprite("gfx/ui/astralvessel/selection_bubble.anm2", true)
bubbleSpr.Color.A = 0.6
bubbleSpr:SetFrame("Default", 0)

local function PSTAVessel_getWheelItemAng(idx, angleOffset)
    local drawAng = idx * ((2 * math.pi) / hairWheelTotal) + angleOffset
    return drawAng
end

local tmpKColorWhiteFaded = KColor(1, 1, 1, 0.5)

function PSTAVessel:appMenuHairTabInput(appearanceMenu)
    -- Input: Directional keys (tap)
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_UP) then
        -- UP
        if editingColor then
            selColor = selColor - 1
            if selColor <= 0 then selColor = 3 end
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_DOWN) then
        -- DOWN
        if editingColor then
            selColor = selColor + 1
            if selColor > 3 then selColor = 1 end
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
        -- LEFT
        if not editingColor then
            local add = -1
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
                add = -7
            end
            local oldSel = appearanceMenu.hairTabSel
            appearanceMenu.hairTabSel = appearanceMenu.hairTabSel + add
            if appearanceMenu.hairTabSel < 1 then appearanceMenu.hairTabSel = 1 end

            if oldSel ~= appearanceMenu.hairTabSel then
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
            end
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) then
        -- RIGHT
        if not editingColor then
            local add = 1
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
                add = 7
            end
            local oldSel = appearanceMenu.hairTabSel
            appearanceMenu.hairTabSel = appearanceMenu.hairTabSel + add
            if appearanceMenu.hairTabSel > #PSTAVessel.hairstyles then
                appearanceMenu.hairTabSel = #PSTAVessel.hairstyles
            end

            if oldSel ~= appearanceMenu.hairTabSel then
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
            end
        end
    end

    -- Input: Directional keys (held)
    if tmpInputTimer == 0 and editingColor then
        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
            -- LEFT
            local reduce = 0.01
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
                reduce = 0.1
            end
            PSTAVessel.charHairColor[tmpColorList[selColor]] = PSTAVessel.charHairColor[tmpColorList[selColor]] - reduce
            if PSTAVessel.charHairColor[tmpColorList[selColor]] < 0 then
                PSTAVessel.charHairColor[tmpColorList[selColor]] = 0
            end
            tmpInputTimer = 6
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
            -- RIGHT
            local add = 0.01
            if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
                add = 0.1
            end
            PSTAVessel.charHairColor[tmpColorList[selColor]] = PSTAVessel.charHairColor[tmpColorList[selColor]] + add
            if PSTAVessel.charHairColor[tmpColorList[selColor]] > 2 then
                PSTAVessel.charHairColor[tmpColorList[selColor]] = 2
            end
            tmpInputTimer = 6
        end
    end

    -- Input: Q, switch to hair color
    if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
        editingColor = not editingColor
        SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
    end

    if tmpInputTimer > 0 then tmpInputTimer = tmpInputTimer - 1 end
end

local currentAng = PSTAVessel_getWheelItemAng(0, 0)
local targetAng = currentAng
function PSTAVessel:appearanceMenuHairTab(appearanceMenu, tScreen)
    local tmpDrawX = tScreen.screenW / 2
    local tmpDrawY = tScreen.screenH / 2

    if currentAng ~= targetAng then
        currentAng = currentAng + (targetAng - currentAng) * (lerpSpeed / 30)
        if math.abs(targetAng - currentAng) <= 0.01 then
            currentAng = targetAng
        end
    end
    targetAng = PSTAVessel_getWheelItemAng(appearanceMenu.hairTabSel - 1, 0)

    local totalDrawn = 0
    for i = 1, math.min(appearanceMenu.hairTabSel + hairWheelTotal - 1, #PSTAVessel.hairstyles) do
        local tmpHair = PSTAVessel.hairstyles[i]
        if tmpHair then
            if not tmpHair.sprite and tmpHair.path and tmpHair.path ~= "none" then
                tmpHair.sprite = Sprite(tmpHair.path, true)
                if tmpHair.variant then
                    tmpHair.sprite:ReplaceSpritesheet(0, tmpHair.variant, true)
                end
                tmpHair.sprite:SetFrame("HeadDown", 0)
            end
            if tmpHair.sprite or tmpHair.path == "none" then
                local drawAng = PSTAVessel_getWheelItemAng(totalDrawn, -currentAng)
                local hairX = tmpDrawX + math.cos(drawAng - math.pi * 0.5) * hairWheelRad
                local hairY = tmpDrawY + math.sin(drawAng - math.pi * 0.5) * hairWheelRad

                local tmpAlpha = 1
                if drawAng < 0 then
                    tmpAlpha = 1 - math.abs(drawAng) / (math.pi * 0.3)
                elseif drawAng >= math.pi then
                    tmpAlpha = 1 - (drawAng - math.pi) / (math.pi * 0.5)
                end
                if tmpHair.sprite then
                    tmpHair.sprite.Color.A = math.max(0, tmpAlpha)
                end

                if tmpHair.path ~= "none" then
                    tmpHair.sprite.Color = Color(1, 1, 1, tmpAlpha)
                    tmpHair.sprite:Render(Vector(hairX, hairY))
                else
                    PST.normalFont:DrawString("None", hairX - 12, hairY - 25, KColor(1, 1, 1, tmpAlpha))
                end

                totalDrawn = totalDrawn + 1
            end
        end
    end

    -- Selected hair
    if PSTAVessel.hairstyles[appearanceMenu.hairTabSel] then
        PSTAVessel.charHair = PSTAVessel.hairstyles[appearanceMenu.hairTabSel]
    end

    -- Display mod source
    if PSTAVessel.charHair.sourceMod then
        local tmpStr = "Hairstyle granted by this mod: " .. PSTAVessel.charHair.sourceMod
        tmpTextX = tmpDrawX - PST.miniFont:GetStringWidth(tmpStr) / 2
        tmpTextY = tmpDrawY + 54
        PST.miniFont:DrawString(tmpStr, tmpTextX, tmpTextY, PST.kcolors.LIGHTBLUE1)
    end

    -- Selection bubble
    bubbleSpr:Render(Vector(tmpDrawX, tmpDrawY - hairWheelRad - 18))

    ---- Hair color edition
    local tmpTextX = tmpDrawX + 120
    local tmpTextY = tmpDrawY - 60


    -- Red
    local tmpColor = editingColor and PST.kcolors.WHITE or tmpKColorWhiteFaded
    if editingColor and selColor == 1 then
        tmpColor = PST.kcolors.RED1
    end
    PST.normalFont:DrawString("Red: " .. PSTAVessel:getColorStr(PSTAVessel.charHairColor.R), tmpTextX, tmpTextY, tmpColor)
    tmpTextY = tmpTextY + 18

    -- Green
    tmpColor = editingColor and PST.kcolors.WHITE or tmpKColorWhiteFaded
    if editingColor and selColor == 2 then
        tmpColor = PST.kcolors.GREEN1
    end
    PST.normalFont:DrawString("Green: " .. PSTAVessel:getColorStr(PSTAVessel.charHairColor.G), tmpTextX, tmpTextY, tmpColor)
    tmpTextY = tmpTextY + 18

    -- Blue
    tmpColor = editingColor and PST.kcolors.WHITE or tmpKColorWhiteFaded
    if editingColor and selColor == 3 then
        tmpColor = PST.kcolors.BLUE1
    end
    PST.normalFont:DrawString("Blue: " .. PSTAVessel:getColorStr(PSTAVessel.charHairColor.B), tmpTextX, tmpTextY, tmpColor)

    local tmpStr = "Press Q to switch between hair and color selection."
    tmpTextX = tmpDrawX - PST.miniFont:GetStringWidth(tmpStr) / 2
    tmpTextY = tmpDrawY + 70
    PST.miniFont:DrawString(tmpStr, tmpTextX, tmpTextY, PST.kcolors.WHITE)
end