local accWheelRad = 55
local accWheelTotal = 10
local lerpSpeed = 5

local bubbleSpr = Sprite("gfx/ui/astralvessel/selection_bubble.anm2", true)
bubbleSpr.Color.A = 0.6
bubbleSpr:SetFrame("Default", 0)

local blankHeadSpr = Sprite("gfx/ui/astralvessel/head_blank.anm2", true)
blankHeadSpr:Play("Default")

local function PSTAVessel_getWheelItemAng(idx, angleOffset)
    local drawAng = idx * ((2 * math.pi) / accWheelTotal) + angleOffset
    return drawAng
end

function PSTAVessel:appMenuAccTabInput(appearanceMenu)
    if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT) then
        -- LEFT
        local add = -1
        if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            add = -5
        end
        local oldSel = appearanceMenu.accTabSel
        appearanceMenu.accTabSel = appearanceMenu.accTabSel + add
        if appearanceMenu.accTabSel < 1 then appearanceMenu.accTabSel = 1 end

        if oldSel ~= appearanceMenu.accTabSel then
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
        end
    elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT) then
        -- RIGHT
        local add = 1
        if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            add = 5
        end
        local oldSel = appearanceMenu.accTabSel
        appearanceMenu.accTabSel = appearanceMenu.accTabSel + add
        if appearanceMenu.accTabSel > #PSTAVessel.accessoryList then
            appearanceMenu.accTabSel = #PSTAVessel.accessoryList
        end

        if oldSel ~= appearanceMenu.accTabSel then
            SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
        end
    end

    -- Input: Allocate
    if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
        if PSTAVessel.accessoryList[appearanceMenu.accTabSel] then
            if PSTAVessel:arrHasValue(PSTAVessel.charAccessories, appearanceMenu.accTabSel) then
                for i, tmpAcc in ipairs(PSTAVessel.charAccessories) do
                    if tmpAcc == appearanceMenu.accTabSel then
                        table.remove(PSTAVessel.charAccessories, i)
                        break
                    end
                end
                SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.33, 2, false, 0.9 + 0.2 * math.random())
            elseif #PSTAVessel.charAccessories < PSTAVessel.accessoryLimit then
                table.insert(PSTAVessel.charAccessories, appearanceMenu.accTabSel)
                SFXManager():Play(SoundEffect.SOUND_BAND_AID_PICK_UP, 0.33, 2, false, 0.9 + 0.2 * math.random())
            else
                SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.35)
            end
        else
            SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN, 0.35)
        end
    end

    -- Input: Q
    if PST:isKeybindActive(PSTKeybind.SWITCH_TREE) then
        if #PSTAVessel.charAccessories > 0 then
            for i=appearanceMenu.accTabSel + 1,#PSTAVessel.accessoryList do
                if PSTAVessel:arrHasValue(PSTAVessel.charAccessories, i) then
                    appearanceMenu.accTabSel = i
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
                    break
                end
            end
        end
    end

    -- Input: Shift + Q
    if PST:isKeybindActive(PSTKeybind.TOGGLE_TREE_MODS) then
        if #PSTAVessel.charAccessories > 0 then
            for i=appearanceMenu.accTabSel - 1,1,-1 do
                if PSTAVessel:arrHasValue(PSTAVessel.charAccessories, i) then
                    appearanceMenu.accTabSel = i
                    SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS, 0.7, 2, false, 1.15)
                    break
                end
            end
        end
    end
end

local currentAng = PSTAVessel_getWheelItemAng(0, 0)
local targetAng = currentAng
function PSTAVessel:appearanceMenuAccTab(appearanceMenu, tScreen)
    local tmpDrawX = tScreen.screenW / 2
    local tmpDrawY = tScreen.screenH / 2

    if currentAng ~= targetAng then
        currentAng = currentAng + (targetAng - currentAng) * (lerpSpeed / 30)
        if math.abs(targetAng - currentAng) <= 0.01 then
            currentAng = targetAng
        end
    end
    targetAng = PSTAVessel_getWheelItemAng(appearanceMenu.accTabSel - 1, 0)

    local totalDrawn = 0
    local radOff = 0
    for i = 1, math.min(appearanceMenu.accTabSel + accWheelTotal + 4, #PSTAVessel.accessoryList) do
        local tmpAcc = PSTAVessel.accessoryList[i]
        if tmpAcc then
            if not tmpAcc.sprite then
                if tmpAcc.path and tmpAcc.path ~= "none" then
                    tmpAcc.sprite = Sprite(tmpAcc.path, true)
                    tmpAcc.sprite:SetFrame("HeadDown", 0)
                elseif tmpAcc.item then
                    local itemCfg = Isaac.GetItemConfig():GetCollectible(tmpAcc.item)
                    if itemCfg then
                        tmpAcc.costumeSprite = Sprite(itemCfg.Costume.Anm2Path, true)
                        tmpAcc.costumeSprite:Play("HeadDown")
                        tmpAcc.sprite = Sprite("gfx/005.100_collectible.anm2", true)
                        tmpAcc.sprite:Play("ShopIdle")
                        tmpAcc.sprite:ReplaceSpritesheet(1, itemCfg.GfxFileName, true)
                    end
                end
            end
            if tmpAcc.sprite or tmpAcc.path == "none" then
                local drawAng = PSTAVessel_getWheelItemAng(totalDrawn, -currentAng)
                local accX = tmpDrawX + math.cos(drawAng - math.pi * 0.5) * (accWheelRad + radOff)
                local accY = tmpDrawY + math.sin(drawAng - math.pi * 0.5) * (accWheelRad + radOff)

                local tmpAlpha = 1
                if drawAng < 0 then
                    tmpAlpha = 1 - math.abs(drawAng) / (math.pi * 0.3)
                elseif drawAng >= math.pi * 2 then
                    tmpAlpha = 1 - (drawAng - math.pi) / (math.pi * 2.5)
                end
                if drawAng >= math.pi * 0.5 then
                    radOff = math.min(40, radOff + drawAng * 5)
                end
                if tmpAcc.sprite then
                    tmpAcc.sprite.Color.A = math.max(0, tmpAlpha)
                end

                if tmpAcc.path ~= "none" then
                    if not tmpAcc.item then
                        blankHeadSpr.Color.A = tmpAcc.sprite.Color.A - 0.3
                        blankHeadSpr:Render(Vector(accX, accY - 18))
                    end
                    tmpAcc.sprite:Render(Vector(accX, accY))
                else
                    PST.normalFont:DrawString("None", accX - 12, accY - 22, KColor(1, 1, 1, tmpAlpha))
                end

                if PSTAVessel:arrHasValue(PSTAVessel.charAccessories, i) then
                    bubbleSpr.Color.A = tmpAcc.sprite.Color.A
                    bubbleSpr:SetFrame("Default", 1)
                    bubbleSpr:Render(Vector(accX, accY - 18))
                end

                totalDrawn = totalDrawn + 1
            end
        end
    end

    -- Selection bubble
    bubbleSpr.Color.A = 1
    bubbleSpr:SetFrame("Default", 0)
    bubbleSpr:Render(Vector(tmpDrawX, tmpDrawY - accWheelRad - 18))

    -- Accessory counter
    local accCounter = #PSTAVessel.charAccessories .. "/" .. PSTAVessel.accessoryLimit
    local tmpTextX = tmpDrawX - PST.miniFont:GetStringWidth(accCounter) / 2 + 1
    local tmpTextY = tmpDrawY - 50
    local tmpColor = PST.kcolors.BLUE1
    if #PSTAVessel.charAccessories >= PSTAVessel.accessoryLimit then
        tmpColor = PST.kcolors.ANCIENT_ORANGE
    end
    PST.miniFont:DrawString(accCounter, tmpTextX, tmpTextY, tmpColor)

    -- Texts
    local tmpStr = "Accessory layers might not be accurate to in-game display."
    tmpTextX = tmpDrawX - PST.miniFont:GetStringWidth(tmpStr) / 4
    tmpTextY = tmpDrawY + 80
    PST.miniFont:DrawStringScaled(tmpStr, tmpTextX, tmpTextY, 0.5, 0.5, PST.kcolors.WHITE)
    tmpTextY = tmpTextY + 10

    tmpStr = "Bear in mind certain costumes might override each other in-game."
    tmpTextX = tmpDrawX - PST.miniFont:GetStringWidth(tmpStr) / 4
    PST.miniFont:DrawStringScaled(tmpStr, tmpTextX, tmpTextY, 0.5, 0.5, PST.kcolors.WHITE)
    tmpTextY = tmpTextY + 10

    tmpStr = "Press Q / Shift+Q to quickly select next/previous equipped accessory."
    tmpTextX = tmpDrawX - PST.miniFont:GetStringWidth(tmpStr) / 4
    PST.miniFont:DrawStringScaled(tmpStr, tmpTextX, tmpTextY, 0.5, 0.5, PST.kcolors.WHITE)
end