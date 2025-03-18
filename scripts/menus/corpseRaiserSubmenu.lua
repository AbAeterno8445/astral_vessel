PSTAVessel.corpseRaiserSubmenuID = "loadouts"

function PSTAVessel:initCorpseRaiserSubmenu()
    local corpseRaiserSubmenu = {
        menuX = 0,
        menuY = 0,
        hoveredChoice = nil,

        bubbleSpr = Sprite("gfx/ui/astralvessel/selection_bubble.anm2", true)
    }

    -- Init
    corpseRaiserSubmenu.bubbleSpr.Scale = Vector(0.75, 0.75)
    corpseRaiserSubmenu.bubbleSpr.Color.A = 0.75
    corpseRaiserSubmenu.bubbleSpr:SetFrame("Default", 1)
    PST.treeScreen.modules.submenusModule.submenus[PSTAVessel.corpseRaiserSubmenuID] = corpseRaiserSubmenu

    function corpseRaiserSubmenu:OnOpen(openData)
        if not openData then return end
        for k, v in pairs(openData) do
            if self[k] ~= nil then self[k] = v end
        end
    end

    function corpseRaiserSubmenu:Update()
        -- Input: Allocate
        if PST:isKeybindActive(PSTKeybind.ALLOCATE_NODE) then
            if self.hoveredChoice then
                PSTAVessel.corpseRaiserChoice[self.hoveredChoice[1]] = self.hoveredChoice[2]
                SFXManager():Play(SoundEffect.SOUND_BUTTON_PRESS)
            end
        end
    end

    local corpseRaiserTitles = {
        "Floors 5 and below",
        "Floors 9 and below",
        "Floors 10+"
    }
    local summonSpriteCache = {}
    function corpseRaiserSubmenu:Render(tScreen, submenusModule)
        self.hoveredChoice = nil
        local totalChoices = #PSTAVessel.corpseRaiserSummons1 + #PSTAVessel.corpseRaiserSummons2 + #PSTAVessel.corpseRaiserSummons3
        submenusModule:DrawNodeSubMenu(
            tScreen,
            totalChoices + 15,
            tScreen.camCenterX, tScreen.camCenterY,
            self.menuX, self.menuY,
            "Summon Choices",
            function()
                -- Choices: Floors 5 and below
                local tmpDrawX = self.menuX * tScreen.zoomScale - 80 - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                local tmpDrawY = self.menuY * tScreen.zoomScale + 32 - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y

                for summonTier=1,3 do
                    PST.miniFont:DrawString(corpseRaiserTitles[summonTier], tmpDrawX, tmpDrawY, PST.kcolors.LIGHTBLUE1)
                    tmpDrawY = tmpDrawY + 50

                    local targetList = PSTAVessel["corpseRaiserSummons" .. summonTier]
                    for i=1,#targetList do
                        local tmpSummon = targetList[i]
                        local summonCfg = EntityConfig.GetEntity(tmpSummon[1], tmpSummon[2])
                        if summonCfg then
                            if not summonSpriteCache[tmpSummon[1]] then summonSpriteCache[tmpSummon[1]] = {} end
                            if not summonSpriteCache[tmpSummon[1]][tmpSummon[2]] then
                                local newSprite = Sprite(summonCfg:GetAnm2Path(), true)
                                newSprite.Scale = Vector(0.5, 0.5)
                                summonSpriteCache[tmpSummon[1]][tmpSummon[2]] = newSprite
                            end
                            local summonSprite = summonSpriteCache[tmpSummon[1]][tmpSummon[2]]
                            if summonSprite then
                                local spriteX = tmpDrawX + 12 + ((i - 1) % 5) * 32
                                local spriteY = tmpDrawY - 14 + math.floor((i - 1) / 5) * 32

                                -- Hovered
                                summonSprite.Color.A = 1
                                if self.hoveredChoice == nil then
                                    local camCenterXOff = tScreen.camCenterX - tScreen.treeCamera.X - tScreen.camZoomOffset.X
                                    local camCenterYOff = tScreen.camCenterY - tScreen.treeCamera.Y - tScreen.camZoomOffset.Y + 9
                                    if camCenterXOff > spriteX - 16 and camCenterXOff < spriteX + 16 and
                                    camCenterYOff > spriteY - 16 and camCenterYOff < spriteY + 16 then
                                        self.hoveredChoice = {summonTier, i}
                                        tScreen.cursorHighlight = true
                                        summonSprite.Color.A = 2
                                    end
                                end

                                if tmpSummon[4] then
                                    for _, tmpAnim in ipairs(tmpSummon[4]) do
                                        summonSprite:SetFrame(tmpAnim, 0)
                                        summonSprite:Render(Vector(spriteX, spriteY))
                                    end
                                else
                                    summonSprite:SetFrame("WalkDown", 0)
                                    summonSprite:Render(Vector(spriteX, spriteY))
                                    summonSprite:SetFrame("HeadWalkDown", 0)
                                    summonSprite:Render(Vector(spriteX, spriteY))
                                end

                                -- Selected
                                if PSTAVessel.corpseRaiserChoice[summonTier] == i then
                                    self.bubbleSpr:Render(Vector(spriteX, spriteY - 7))
                                end

                                -- Max summons #
                                PST.luaminiFont:DrawString(tmpSummon[3], spriteX + 6, spriteY - 4, PST.kcolors.LIGHTBLUE1)
                            end
                        end
                    end
                end
            end
        )

        -- Hovered summon description box
        if self.hoveredChoice then
            local summonData = PSTAVessel["corpseRaiserSummons" .. self.hoveredChoice[1]][self.hoveredChoice[2]]
            if summonData then
                local summonCfg = EntityConfig.GetEntity(summonData[1], summonData[2])
                if summonCfg then
                    local mobName = Isaac.GetLocalizedString("Entities", summonCfg:GetName(), "en")
                    if mobName == "StringTable::InvalidKey" then mobName = "Unknown Entity" end

                    local mobDesc = {
                        "Maximum summons: " .. summonData[3],
                        "Press Allocate to select this summon for " .. corpseRaiserTitles[self.hoveredChoice[1]]
                    }
                    tScreen:DrawNodeBox(mobName, mobDesc)
                end
            end
        end
    end
end