local emberSprite = Sprite("gfx/characters/257_firemind.anm2", true)
emberSprite.Scale = Vector(0.5, 0.5)
emberSprite:Play("HeadDown")
local embersAlpha = {}

function PSTAVessel:onRender()
    if not Game():IsPaused() then
        ---@type EntityPlayer
        local player = PST:getPlayer()
        local isEvenFrame = Game():GetFrameCount() % 2 == 0

        -- Meteor embers rendering
        if PSTAVessel.fusilladeEmbers > 0 then
            PSTAVessel.fusilladeEmberAng = PSTAVessel.fusilladeEmberAng + 0.01
            if PSTAVessel.fusilladeEmberAng > math.pi * 2 then
                PSTAVessel.fusilladeEmberAng = math.pi * 2 - PSTAVessel.fusilladeEmberAng
            end
            if isEvenFrame then emberSprite:Update() end

            for i=1,PSTAVessel.fusilladeEmbers do
                local tmpAng = (math.pi * 0.2) * i + PSTAVessel.fusilladeEmberAng
                local tmpPos = player.Position + Vector(math.cos(tmpAng) * PSTAVessel.fusilladeEmberDist, math.sin(tmpAng) * PSTAVessel.fusilladeEmberDist)

                emberSprite.Color.RO = 0
                emberSprite.Color.GO = 0
                emberSprite.Color.BO = 0
                if embersAlpha[i] then
                    emberSprite.Color.RO = embersAlpha[i]
                    emberSprite.Color.GO = embersAlpha[i]
                    emberSprite.Color.BO = embersAlpha[i]
                end
                -- Ember spawn effect
                if PSTAVessel.fusilladeSpawnFrom and PSTAVessel.fusilladeSpawnFrom < i then
                    emberSprite.Color.RO = 1
                    emberSprite.Color.GO = 1
                    emberSprite.Color.BO = 1
                    embersAlpha[i] = 1
                end
                emberSprite:Render(Game():GetRoom():WorldToScreenPosition(tmpPos))

                if embersAlpha[i] and embersAlpha[i] > 0 then
                    embersAlpha[i] = math.max(0, embersAlpha[i] - 0.02)
                end
            end
        end
        PSTAVessel.fusilladeSpawnFrom = nil
    end
end