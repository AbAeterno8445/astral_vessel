function PSTAVessel:onNewRoom()
    if not PST.gameInit then return end

    PSTAVessel.roomFirstFire = false
    PSTAVessel.roomBlueSpiderDeaths = 0

    local room = Game():GetRoom()
    local roomType = room:GetType()
    local firstVisit = room:IsFirstVisit()

    ---@type EntityPlayer
    local player = PST:getPlayer()
    local isVessel = (player:GetPlayerType() == PSTAVessel.vesselType)

    if isVessel then
        -- Astral Vessel hair color
        local charHair = PST:getTreeSnapshotMod("vesselHair", nil)
        if charHair then
            for _, tmpCostume in ipairs(PST:getPlayer():GetCostumeSpriteDescs()) do
                local tmpSprite = tmpCostume:GetSprite()
                if tmpSprite and tmpSprite:GetFilename() == PSTAVessel.baseHairCostumePath then
                    PSTAVessel.tmpHairSprite = tmpCostume:GetSprite()
                    break
                end
            end
        end

        PSTAVessel:updateHairAndFace(player)

        -- Update trackers
        PSTAVessel.updateTrackers.eternalHearts = player:GetEternalHearts()
        PSTAVessel.updateTrackers.redHearts = player:GetHearts()
        PSTAVessel.updateTrackers.soulHearts = player:GetSoulHearts()
        PSTAVessel.updateTrackers.blackHearts = PSTAVessel:GetBlackHeartCount(player)
        PSTAVessel.updateTrackers.rottenHearts = player:GetRottenHearts()
        PSTAVessel.updateTrackers.primarySlotCharge = player:GetTotalActiveCharge(ActiveSlot.SLOT_PRIMARY)
    end

    -- Versus screen sprite color
    local versusLayers = RoomTransition.GetVersusScreenSprite():GetAllLayers()
    for _,tmpLayer in ipairs(versusLayers) do
        -- 5: Player Portrait layer
        if tmpLayer:GetLayerID() == 5 then
            if isVessel then
                tmpLayer:SetColor(PSTAVessel:getRunVesselColor())
            else
                tmpLayer:SetColor(Color(1, 1, 1, 1))
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

            -- Astral Angle node (Dark Gambler occult constellation)
            if PST:getTreeSnapshotMod("astralAngle", false) and PST:getTreeSnapshotMod("astralAngleSpawns", 0) < 2 then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_REVERSE_STARS, tmpPos, Vector.Zero, nil)
                PST:addModifiers({ astralAngleSpawns = 1 }, true)
            end
            if PST:getTreeSnapshotMod("astralAngleProc", 0) > 0 then
                local tmpChance = 0.5 - PST:getTreeSnapshotMod("astralAngleKeep") / 100
                if math.random() < tmpChance then
                    local tmpItems = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
                    for _, tmpItem in ipairs(tmpItems) do
                        if not PSTAVessel:arrHasValue(PST.progressionItems, tmpItem.SubType) then
                            tmpItem:Remove()
                        end
                    end
                end
                PST:addModifiers({ astralAngleProc = -1 }, true)
            end

            -- Mod: % chance for a random item in treasure rooms to cycle between it and a glitch item
            tmpMod = PST:getTreeSnapshotMod("treasureGlitch", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local roomItems = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
                for _, tmpItem in ipairs(roomItems) do
                    if not PSTAVessel:arrHasValue(PST.progressionItems, tmpItem.SubType) then
                        local newGlitchItem = ProceduralItemManager.CreateProceduralItem(math.random(100000), 0)
                        tmpItem:ToPickup():AddCollectibleCycle(newGlitchItem)
                        break
                    end
                end
            end

            -- Mod: Spacefarer min speed
            if PST:getTreeSnapshotMod("spacefarerMinSpd", 0) > 0 then
                PST:addModifiers({ spacefarerMinSpdProc = true }, true)
                PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
            end

            -- Mod: % chance for treasure rooms to additionally contain a Telescope Lens, up to twice per run
            tmpMod = PST:getTreeSnapshotMod("treasureTeleLens", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("treasureTeleLensProcs", 0) < 2 and 100 * math.random() < tmpMod then
                local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 40)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_TELESCOPE_LENS, tmpPos, Vector.Zero, nil)
                PST:addModifiers({ treasureTeleLensProcs = 1 }, true)
            end

            -- Mod: % chance for a random item in treasure rooms to cycle between it and a familiar item
            tmpMod = PST:getTreeSnapshotMod("treasureFamItem", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local roomItems = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)
                for _, tmpItem in ipairs(roomItems) do
                    if not PSTAVessel:arrHasValue(PST.progressionItems, tmpItem.SubType) then
                        local tmpFamList = {table.unpack(PST.songOfTheFewFamiliars, PST.sirenDissonanceFamiliars)}
                        local newFamItem = Game():GetItemPool():GetCollectibleFromList(tmpFamList)
                        tmpItem:ToPickup():AddCollectibleCycle(newFamItem)
                        break
                    end
                end
            end
        -- Curse Room
        elseif roomType == RoomType.ROOM_CURSE then
            -- Mod: % chance for the curse room to contain an additional red chest
            local tmpMod = PST:getTreeSnapshotMod("curseRoomRedChest", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 20)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_REDCHEST, 0, tmpPos, Vector.Zero, nil)
                SFXManager():Play(SoundEffect.SOUND_CHEST_DROP)
            end

            -- Mod: % chance for the curse room to contain an additional black heart
            tmpMod = PST:getTreeSnapshotMod("curseRoomBlackHeart", 0)
            if tmpMod > 0 and 100 * math.random() < tmpMod then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 20)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_BLACK, tmpPos, Vector.Zero, nil)
            end
        -- Secret Room
        elseif roomType == RoomType.ROOM_SECRET then
            -- Mod: % chance for secret rooms to additionally contain a Black Lotus, up to twice per run
            local tmpMod = PST:getTreeSnapshotMod("secretBlackLotus", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("secretBlackLotusProcs", 0) < 2 and 100 * math.random() < tmpMod then
                local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BLACK_LOTUS, tmpPos, Vector.Zero, nil)
                PST:addModifiers({ secretBlackLotusProcs = 1 }, true)
            end

            -- Mod: +% speed for 50 seconds when first entering a secret room
            tmpMod = PST:getTreeSnapshotMod("secretRoomSpeedBuff", 0)
            if tmpMod > 0 then
                if PSTAVessel.modCooldowns.secretRoomSpeedBuff == 0 then
                    PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
                end
                PSTAVessel.modCooldowns.secretRoomSpeedBuff = 1500
            end

            -- Mod: % chance for secret rooms to additionally contain a blue item, up to twice per run
            tmpMod = PST:getTreeSnapshotMod("secretRoomBlueItem", 0)
            if tmpMod > 0 and PST:getTreeSnapshotMod("secretRoomBlueItemProcs", 0) < 2 and 100 * math.random() < tmpMod then
                local newItem = Game():GetItemPool():GetCollectibleFromList(PST.blueItemPool)
                if newItem ~= CollectibleType.COLLECTIBLE_BREAKFAST then
                    local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, tmpPos, Vector.Zero, nil)
                    PST:addModifiers({ secretRoomBlueItemProcs = 1 }, true)
                end
            end

            -- Lunar Scion node (Moon cosmic constellation)
            if PST:getTreeSnapshotMod("lunarScion", false) then
                PST:addModifiers({ lunarScionExtras = 1 }, true)
                if PSTAVessel.modCooldowns.lunarScion > 0 then
                    PST:updateCacheDelayed()
                end
            end
        -- Super Secret Room
        elseif roomType == RoomType.ROOM_SUPERSECRET then
            -- Mod: % chance for super secret rooms to additionally contain an Eden's blessing, once per run
            local tmpMod = PST:getTreeSnapshotMod("superSecretEdenBlessing", 0)
            if tmpMod > 0 and not PST:getTreeSnapshotMod("superSecretEdenBlessingProc", false) and 100 * math.random() < tmpMod then
                local tmpPos = room:FindFreePickupSpawnPosition(room:GetCenterPos(), 20, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_EDENS_BLESSING, tmpPos, Vector.Zero, nil)
                PST:addModifiers({ superSecretEdenBlessingProc = true }, true)
            end
        -- Red Room
        elseif PST:inRedRoom() then
            -- Mod: +% to a random stat for the current floor when first entering a red room
            local tmpMod = PST:getTreeSnapshotMod("redRoomRandStat", 0)
            if tmpMod > 0 then
                local randStat = PST:getRandomStat()
                PST:addModifiers({
                    [randStat .. "Perc"] = tmpMod,
                    ["redRoomRandStat" .. randStat] = tmpMod
                }, true)
            end
        end

        -- Mod: % chance to spawn a random rune or soul stone when first entering a secret room
        tmpMod = PST:getTreeSnapshotMod("secretRoomRune", 0)
        if tmpMod > 0 and (roomType == RoomType.ROOM_SECRET or roomType == RoomType.ROOM_SUPERSECRET or roomType == RoomType.ROOM_ULTRASECRET) then
            local soulChance = 0.15
            if roomType == RoomType.ROOM_SUPERSECRET then
                tmpMod = tmpMod * 2
                soulChance = 0.3
            elseif roomType == RoomType.ROOM_ULTRASECRET then
                tmpMod = tmpMod * 4
                soulChance = 0.5
            end
            if 100 * math.random() < tmpMod then
                local tmpPos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 40)
                if math.random() < soulChance then
                    -- Random Soulstone
                    local newSoulstone = PST:getMatchingSoulstone(nil)
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, newSoulstone, tmpPos, Vector.Zero, nil)
                else
                    -- Random Rune
                    local newRune = PST.allRune[math.random(#PST.allRunes)]
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, newRune, tmpPos, Vector.Zero, nil)
                end
            end
        end
    end

    -- Mod: % chance to gain up to 1/2 lost heart in the room when killing enemies
    if PST:getTreeSnapshotMod("daggerHeartOnKillProc", false) then
        PST:addModifiers({
            daggerHeartOnKill_red = false,
            daggerHeartOnKill_soul = false,
            daggerHeartOnKill_black = false,
            daggerHeartOnKill_eternal = false,
            daggerHeartOnKillProc = true
        }, false)
    end

    -- Corpse Raiser node - ephemeral mod (Necromancer occult constellation)
    -- Carrion Harvest node (Ritualist occult constellation)
    if PST:getTreeSnapshotMod("corpseRaiserEphemeral", false) or PST:getTreeSnapshotMod("carrionHarvest", false) then
        local tmpEntities = Isaac.GetRoomEntities()
        for _, tmpEnt in ipairs(tmpEntities) do
            local tmpNPC = tmpEnt:ToNPC()
            if tmpNPC and (PST:getEntData(tmpNPC).PST_corpseRaised or PST:getEntData(tmpNPC).PST_carrionHarvestMob) then
                tmpNPC:Remove()
            end
        end
    end

    -- Mod: +% damage until you kill a monster in the room
    if PST:getTreeSnapshotMod("dmgUntilKillProc", false) then
        PST:addModifiers({ dmgUntilKillProc = false }, true)
        PSTAVessel.modCooldowns.dmgUntilKill = 0
        PST:updateCacheDelayed(CacheFlag.CACHE_DAMAGE)
    end

    -- Carrion Harvest node (Ritualist occult constellation)
    if PST:getTreeSnapshotMod("carrionHarvest", false) then
        PST:addModifiers({ carrionHarvestHits = { value = 3, set = true } }, true)
    end

    -- Mod: % chance to replace dropped basic pickups with sacks
    if PST:getTreeSnapshotMod("pickupSacksProcs", 0) > 0 then
        PST:addModifiers({ pickupSacksProcs = { value = 0, set = true } }, true)
    end

    -- Life Insured node (God Of Fortune mercantile constellation)
    if PST:getTreeSnapshotMod("lifeInsuredProc", false) then
        PST:addModifiers({ lifeInsuredProc = false }, true)
    end

    -- Calcified Lifeblooms node (Flower mundane constellation) - Remove spawned friendly bonies
    if PST:getTreeSnapshotMod("calcifiedLifeblooms", false) then
        local tmpBonies = Isaac.FindByType(EntityType.ENTITY_BONY, 0, 0)
        for i=#tmpBonies,1,-1 do
            local tmpBony = tmpBonies[i]
            if PST:getEntData(tmpBony).PST_bloomBony then
                tmpBony:Remove()
            end
        end
    end

    -- Lunar Scion node (Moon cosmic constellation)
    if PST:getTreeSnapshotMod("lunarScionProcs", 0) > 0 then
        PST:addModifiers({ lunarScionProcs = { value = 0, set = true } }, true)
    end

    -- Solar Scion node (Sun cosmic constellation)
    if PST:getTreeSnapshotMod("solarScionProcs", 0) > 0 then
        PST:addModifiers({ solarScionProcs = { value = 0, set = true } }, true)
    end

    -- Mod: +% all stats while in a boss or boss rush room
    local tmpMod = PST:getTreeSnapshotMod("bossRoomAllstatPerc", 0)
    if tmpMod > 0 then
        local isBossRoom = (roomType == RoomType.ROOM_BOSS or roomType == RoomType.ROOM_BOSSRUSH)
        if isBossRoom and not PST:getTreeSnapshotMod("bossRoomAllstatPercProc", false) then
            PST:addModifiers({ allstatsPerc = tmpMod, bossRoomAllstatPercProc = true }, true)
        elseif not isBossRoom and PST:getTreeSnapshotMod("bossRoomAllstatPercProc", false) then
            PST:addModifiers({ allstatsPerc = -tmpMod, bossRoomAllstatPercProc = false }, true)
        end
    end

    -- Mod: % chance to spawn a clot on kill
    if PST:getTreeSnapshotMod("vesselClotOnKillProcs", 0) > 0 then
        PST:addModifiers({ vesselClotOnKillProcs = { value = 0, set = true } }, true)
    end

    -- Mod: +% temporary speed per blue fly you have, up to 20%
    tmpMod = PST:getTreeSnapshotMod("vesselFliesSpeed", 0)
    if tmpMod > 0 and room:GetAliveEnemiesCount() > 0 then
        PSTAVessel.vesselFliesSpeedBuff = math.min(20, tmpMod * #Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLUE_FLY, 0))
        if PSTAVessel.modCooldowns.vesselFliesSpeed == 0 then
            PST:updateCacheDelayed(CacheFlag.CACHE_SPEED)
        end
        PSTAVessel.modCooldowns.vesselFliesSpeed = 240
    end

    -- Mod: whenever a blue spider spawns, % chance to spawn an additional one
    if PST:getTreeSnapshotMod("spiderDupeProcs", 0) > 0 then
        PST:addModifiers({ spiderDupeProcs = { value = 0, set = true } }, true)
    end

    -- Mod: % chance to create an associated dip familiar when destroying poop
    if PST:getTreeSnapshotMod("poopDipProcs", 0) > 0 then
        PST:addModifiers({ poopDipProcs = { value = 0, set = true } }, true)
    end

    -- Mod: create exploding mushrooms when entering a room with monsters
    tmpMod = PST:getTreeSnapshotMod("exploShrooms", 0)
    if tmpMod > 0 and room:GetAliveEnemiesCount() > 0 then
        for _=1,tmpMod do
            local tmpPos = room:FindFreePickupSpawnPosition(room:GetRandomPosition(20), 20)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, PSTAVessel.exploMushroomID, PSTAVesselMushType.ORANGE, tmpPos, Vector.Zero, nil)
        end
    end

    -- Mod: % chance to drop a rotten heart from you when losing rotten hearts
    if PST:getTreeSnapshotMod("dupeRottenOnHitProcs", 0) > 0 then
        PST:addModifiers({ dupeRottenOnHitProcs = { value = 0, set = true } }, true)
    end

    -- Mod: killing enemies has a % chance to spawn a leprosy orbital
    if PST:getTreeSnapshotMod("leprosyOrbitalProcs", 0) > 0 then
        PST:addModifiers({ leprosyOrbitalProcs = { value = 0, set = true } }, true)
    end

    -- Mod: % chance for blue flies to turn into a blue locust for the current room on death
    if PST:getTreeSnapshotMod("blueFlyLocustProcs", 0) > 0 then
        PST:addModifiers({ blueFlyLocustProcs = { value = 0, set = true } }, true)
    end

    -- Suzerain Of Flies node (Dragonfly mutagenic constellation) - remove spawned swarm flies
    if PST:getTreeSnapshotMod("suzerainSwarmProc", false) then
        local swarmFlies = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.SWARM_FLY_ORBITAL)
        for _, tmpFly in ipairs(swarmFlies) do
            if PST:getEntData(tmpFly).PST_suzerainSwarmFly then
                tmpFly:Remove()
            end
        end
        PST:addModifiers({ suzerainSwarmProc = false }, true)
    end
end