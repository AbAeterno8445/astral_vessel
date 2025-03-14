function PSTAVessel:onNewRoom()
    if not PST.gameInit then return end

    PSTAVessel.roomFirstFire = false

    local room = Game():GetRoom()
    local roomType = room:GetType()
    local firstVisit = room:IsFirstVisit()

    local player = Isaac.GetPlayer()
    local isVessel = (player:GetPlayerType() == PSTAVessel.charType)

    if isVessel then
        -- Astral Vessel custom color application
        player:GetSprite().Color = PSTAVessel.charColor

        -- Astral Vessel hair color
        if PSTAVessel.charHair then
            for _, tmpCostume in ipairs(PST:getPlayer():GetCostumeSpriteDescs()) do
                local tmpSprite = tmpCostume:GetSprite()
                if tmpSprite and tmpSprite:GetFilename() == PSTAVessel.charHair.path then
                    PSTAVessel.tmpHairSprite = tmpCostume:GetSprite()
                    break
                end
            end
        end

        PSTAVessel:updateHairVariant(player)

        -- Update trackers
        PSTAVessel.updateTrackers.eternalHearts = player:GetEternalHearts()
    end

    -- Versus screen sprite color
    local versusLayers = RoomTransition.GetVersusScreenSprite():GetAllLayers()
    for _,l in ipairs(versusLayers) do
        -- 5: Player Portrait layer
        if l:GetLayerID() == 5 then
            if isVessel then
                l:SetColor(PSTAVessel.charColor)
            else
                l:SetColor(Color(1, 1, 1, 1))
            end
            break
        end
    end

    -- First entry
    if firstVisit then
        -- Angel room
        if roomType == RoomType.ROOM_ANGEL then
            -- Mod: When entering an angel room, % chance to begin the next floor with no curses
            local tmpMod = PST:getTreeSnapshotMod("angelRoomCurseCleanse", 0)
            if tmpMod > 0 and not PST:getTreeSnapshotMod("angelRoomCurseProc", false) and 100 * math.random() < tmpMod then
                PST:addModifiers({ naturalCurseCleanse = 100, angelRoomCurseProc = true }, true)
                PST:createFloatTextFX("Curse Cleanse", Vector.Zero, Color(1, 1, 1, 1), 0.13, 120, true)
            end

        -- Devil room
        elseif roomType == RoomType.ROOM_DEVIL then
            -- Mod: % chance to gain a black heart when entering a devil room, up to 3x per run
            local tmpMod = PST:getTreeSnapshotMod("devilBlackHeart", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("devilBlackHeartProcs", 0) < 3 and 100 * math.random() < tmpMod then
                player:AddBlackHearts(2)
                SFXManager():Play(SoundEffect.SOUND_UNHOLY)
                PST:addModifiers({ devilBlackHeartProcs = 1 }, true)
            end

        -- Treasure room
        elseif roomType == RoomType.ROOM_TREASURE then
            -- Mod: % chance to replace one item in the treasure room with an angel item (no Q4)
            local tmpMod = PST:getTreeSnapshotMod("vesselTreasureAngel", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local roomItems = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
                for _, tmpItem in ipairs(roomItems) do
                    if not PST:arrHasValue(PST.progressionItems, tmpItem.SubType) then
                        local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL)
                        local newCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                        local failsafe = 0
                        while (not newCfg or (newCfg and newCfg.Quality >= 4) or player:HasCollectible(newItem)) and failsafe < 500 do
                            newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_ANGEL)
                            newCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                            failsafe = failsafe + 1
                        end
                        if failsafe < 500 then
                            tmpItem:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem)
                            break
                        end
                    end
                end
            end

            -- Mod: % chance to replace one item in the treasure room with a devil item (no Q4)
            tmpMod = PST:getTreeSnapshotMod("vesselTreasureDevil", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local roomItems = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
                for _, tmpItem in ipairs(roomItems) do
                    if not PST:arrHasValue(PST.progressionItems, tmpItem.SubType) then
                        local newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL)
                        local newCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                        local failsafe = 0
                        while (not newCfg or (newCfg and newCfg.Quality >= 4) or player:HasCollectible(newItem)) and failsafe < 500 do
                            newItem = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_DEVIL)
                            newCfg = Isaac.GetItemConfig():GetCollectible(newItem)
                            failsafe = failsafe + 1
                        end
                        if failsafe < 500 then
                            tmpItem:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem)
                            break
                        end
                    end
                end
            end
        end
    end
end