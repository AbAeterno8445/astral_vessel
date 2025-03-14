local faceWheelRad = 60
local faceWheelTotal = 10
local lerpSpeed = 5

local bubbleSpr = Sprite("gfx/ui/astralvessel/selection_bubble.anm2", true)
bubbleSpr.Color.A = 0.6
bubbleSpr:SetFrame("Default", 0)

local blankHeadSpr = Sprite("gfx/ui/astralvessel/head_blank.anm2", true)
blankHeadSpr:Play("Default")

local function PSTAVessel_getWheelItemAng(idx, angleOffset)
    local drawAng = idx * ((2 * math.pi) / faceWheelTotal) + angleOffset
    return drawAng
end

function PSTAVessel:appMenuFaceTabInput(appearanceMenu)
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
        -- LEFT
        local add = -1
        if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            add = -7
        end
        local oldSel = appearanceMenu.faceTabSel
        appearanceMenu.faceTabSel = appearanceMenu.faceTabSel + add
        if appearanceMenu.faceTabSel < 1 then appearanceMenu.faceTabSel = 1 end

        if oldSel ~= appearanceMenu.faceTabSel then
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) then
        -- RIGHT
        local add = 1
        if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            add = 7
        end
        local oldSel = appearanceMenu.faceTabSel
        appearanceMenu.faceTabSel = appearanceMenu.faceTabSel + add
        if appearanceMenu.faceTabSel > #PSTAVessel.facesList then
            appearanceMenu.faceTabSel = #PSTAVessel.facesList
        end

        if oldSel ~= appearanceMenu.faceTabSel then
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
        end
    end
end

local currentAng = PSTAVessel_getWheelItemAng(0, 0)
local targetAng = currentAng
function PSTAVessel:appearanceMenuFaceTab(appearanceMenu, tScreen)
    local tmpDrawX = tScreen.screenW / 2
    local tmpDrawY = tScreen.screenH / 2

    if currentAng ~= targetAng then
        currentAng = currentAng + (targetAng - currentAng) * (lerpSpeed / 30)
        if math.abs(targetAng - currentAng) <= 0.01 then
            currentAng = targetAng
        end
    end
    targetAng = PSTAVessel_getWheelItemAng(appearanceMenu.faceTabSel - 1, 0)

    local totalDrawn = 0
    for i = 1, math.min(appearanceMenu.faceTabSel + faceWheelTotal - 1, #PSTAVessel.facesList) do
        local tmpFace = PSTAVessel.facesList[i]
        if tmpFace then
            if not tmpFace.sprite and tmpFace.path and tmpFace.path ~= "none" then
                tmpFace.sprite = Sprite(tmpFace.path, true)
                tmpFace.sprite:SetFrame("HeadDown", 0)
            end
            if tmpFace.sprite or tmpFace.path == "none" then
                local drawAng = PSTAVessel_getWheelItemAng(totalDrawn, -currentAng)
                local faceX = tmpDrawX + math.cos(drawAng - math.pi * 0.5) * faceWheelRad
                local faceY = tmpDrawY + math.sin(drawAng - math.pi * 0.5) * faceWheelRad

                local tmpAlpha = 1
                if drawAng < 0 then
                    tmpAlpha = 1 - math.abs(drawAng) / (math.pi * 0.3)
                elseif drawAng >= math.pi then
                    tmpAlpha = 1 - (drawAng - math.pi) / (math.pi * 0.5)
                end
                if tmpFace.sprite then
                    tmpFace.sprite.Color.A = math.max(0, tmpAlpha)
                end

                if tmpFace.path ~= "none" then
                    blankHeadSpr.Color.A = tmpFace.sprite.Color.A - 0.3
                    blankHeadSpr:Render(Vector(faceX, faceY - 18))
                    tmpFace.sprite:Render(Vector(faceX, faceY))
                else
                    PST.normalFont:DrawString("None", faceX - 12, faceY - 25, KColor(1, 1, 1, tmpAlpha))
                end

                totalDrawn = totalDrawn + 1
            end
        end
    end

    -- Selected face
    if PSTAVessel.facesList[appearanceMenu.faceTabSel] then
        PSTAVessel.charFace = PSTAVessel.facesList[appearanceMenu.faceTabSel]
    end

    -- Selection bubble
    bubbleSpr:Render(Vector(tmpDrawX, tmpDrawY - faceWheelRad - 18))
end