local lifebloomFuncs = {
    -- Crimson lifeblooms
    [PSTAVessel.crimsonBloomID] = {
        Attack = function(effect)
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 100, EntityPartition.ENEMY)
            for _, tmpEnem in ipairs(nearbyEnems) do
                tmpEnem:AddCharmed(EntityRef(PST:getPlayer()), 120)
            end
            local pulseFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0, effect.Position, Vector.Zero, nil)
            pulseFX.Color = Color(1, 0, 0.2, 1, 0.4, 0, 0.1)
        end,
        Death = function(effect)
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 100, EntityPartition.ENEMY)
            for _, tmpEnem in ipairs(nearbyEnems) do
                local tmpDmg = 3 + math.min(27, PST:getPlayer().Damage / 2)
                if tmpEnem:GetCharmedCountdown() > 0 then
                    tmpDmg = tmpDmg * 2
                end
                tmpEnem:TakeDamage(tmpDmg, 0, EntityRef(PST:getPlayer()), 0)
            end
            Game():CharmFart(effect.Position, 100, PST:getPlayer())
        end
    },
    -- Azure lifeblooms
    [PSTAVessel.azureBloomID] = {
        Attack = function(effect)
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 100, EntityPartition.ENEMY)
            for _, tpmEnem in ipairs(nearbyEnems) do
                tpmEnem:AddSlowing(EntityRef(PST:getPlayer()), 90, 0.8, Color(0.8, 0.8, 0.8, 1))
            end
            local pulseFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0, effect.Position, Vector.Zero, nil)
            pulseFX.Color = Color(0.6, 0.6, 1, 1)
        end,
        Death = function(effect)
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 1000, EntityPartition.ENEMY)
            for _, tmpEnem in ipairs(nearbyEnems) do
                tmpEnem:AddSlowing(EntityRef(PST:getPlayer()), 120, 0.7, Color(0.8, 0.8, 0.8, 1))
            end
            local pulseFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0, effect.Position, Vector.Zero, nil)
            pulseFX.Color = Color(0.6, 0.6, 1, 1)
            pulseFX.SpriteScale = Vector(2, 2)
        end
    },
    -- Onyx lifeblooms
    [PSTAVessel.onyxBloomID] = {
        Attack = function(effect)
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 100, EntityPartition.ENEMY)
            for _, tpmEnem in ipairs(nearbyEnems) do
                tpmEnem:AddFear(EntityRef(PST:getPlayer()), 100)
            end
            local pulseFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0, effect.Position, Vector.Zero, nil)
            pulseFX.Color = Color(0.1, 0.1, 0.1, 1)
        end,
        Death = function(effect)
            local maxExplosions = 2 + math.random(2)
            local effectPos = Vector(effect.Position.X, effect.Position.Y)
            Isaac.CreateTimer(function()
                Isaac.Explode(effectPos + RandomVector() * 20, PST:getPlayer(), 20 + math.min(30, PST:getPlayer().Damage))
            end, 5, maxExplosions, false)
        end
    },
    -- Calcified lifeblooms
    [PSTAVessel.calcifiedBloomID] = {
        Attack = function(effect)
            ---@type EntityNPC
            local tmpBony = effect:GetData().PST_bloomBony
            if not tmpBony or (tmpBony and not tmpBony:Exists()) then
                local tmpPos = Isaac.GetFreeNearPosition(effect.Position, 20)
                local newBony = Isaac.Spawn(EntityType.ENTITY_BONY, 0, 0, tmpPos, Vector.Zero, PST:getPlayer())
                newBony:AddCharmed(EntityRef(PST:getPlayer()), -1)
                newBony:GetData().PST_bloomBony = true
                effect:GetData().PST_bloomBony = newBony
            end
        end,
        Death = function(effect)
            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 1000, EntityPartition.ENEMY)
            for _, tmpEnem in ipairs(nearbyEnems) do
                tmpEnem:AddFreeze(EntityRef(PST:getPlayer()), 90)
            end
            local pulseFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0, effect.Position, Vector.Zero, nil)
            pulseFX.Color = Color(0.6, 0.6, 0.6, 1)
            pulseFX.SpriteScale = Vector(2, 2)
        end,
        Cooldown = 150
    },
    -- Eternal lifeblooms
    [PSTAVessel.eternalBloomID] = {
        Attack = function(effect)
            local closestEnem = PSTAVessel:getClosestEnemy(effect.Position, 150)
            if closestEnem then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, closestEnem.Position, Vector.Zero, PST:getPlayer())
            end
        end,
        Cooldown = 100
    },
    -- Rotblooms
    [PSTAVessel.rotBloomID] = {
        Attack = function(effect)
            local newCloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, effect.Position, RandomVector() * 10, PST:getPlayer())
            newCloud:GetData().PST_poisonCloudOnDeath = true
            newCloud:ToEffect().Timeout = 90
        end,
        Death = function(effect)
            local maxFlies = 1 + math.random(3)
            PST:getPlayer():AddBlueFlies(maxFlies, PST:getPlayer().Position, nil)
            local pulseFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CROSS_POOF, 0, effect.Position, Vector.Zero, nil)
            pulseFX.Color = Color(0.1, 0.55, 0.1, 1)
        end
    },
    -- Gilded lifeblooms
    [PSTAVessel.gildedBloomID] = {
        Attack = function(effect)
            local maxTears = 6 + math.random(4)
            for i=1,maxTears do
                local tearAng = ((math.pi * 2) / maxTears) * i
                local tearVel = Vector(math.cos(tearAng) * 7, math.sin(tearAng) * 7)
                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.COIN, 0, effect.Position, tearVel, PST:getPlayer())
                newTear:ToTear().Scale = 0.7
                newTear:ToTear():AddTearFlags(TearFlags.TEAR_BOUNCE)
                newTear.CollisionDamage = 3 + math.min(99, PST:getPlayer():GetNumCoins()) / 6
            end
        end,
        Death = function(effect)
            local newPenny = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, effect.Position, RandomVector() * 3, nil)
            newPenny:ToPickup().Timeout = 90
        end
    }
}

-- Effect update for lifebloom flowers
---@param effect EntityEffect
function PSTAVessel:effectLifebloomUpdate(effect)
    local bloomFuncs = lifebloomFuncs[effect.Variant]
    -- Growing phase
    if not effect:GetData().PST_bloomGrown then
        if not effect:GetData().PST_bloomGrowing then
            effect:GetSprite():Play("Growing", true)
            effect:GetSprite().PlaybackSpeed = 0.5
            effect:GetSprite().Scale = Vector(0.7, 0.7)
            effect:GetData().PST_bloomAttackCD = math.random(bloomFuncs.Cooldown or 50)
            effect:GetData().PST_bloomGrowing = true
        elseif effect:GetSprite():IsFinished() then
            effect:GetSprite():Play("Idle", true)
            effect:GetSprite().PlaybackSpeed = 1
            effect:GetData().PST_bloomGrown = true
        end
    elseif not effect:GetData().PST_bloomDying then
        -- Attacks
        if not effect:GetData().PST_bloomAttacking then
            if effect:GetData().PST_bloomAttackCD > 0 then
                effect:GetData().PST_bloomAttackCD = effect:GetData().PST_bloomAttackCD - 1
                -- Faster cooldown for Eternal blooms if player is nearby
                if effect.Variant == PSTAVessel.eternalBloomID and effect.Position:Distance(PST:getPlayer().Position) <= 80 then
                    effect:GetData().PST_bloomAttackCD = effect:GetData().PST_bloomAttackCD - 1
                end
                if effect:GetData().PST_bloomAttackCD <= 0 then
                    effect:GetSprite():Play("Attack", true)
                    effect:GetData().PST_bloomAttackCD = bloomFuncs.Cooldown or 50
                    effect:GetData().PST_bloomAttacking = true
                end
            end
        elseif effect:GetSprite():IsEventTriggered("Attack") then
            -- Attack effect
            if bloomFuncs and bloomFuncs.Attack then
                bloomFuncs.Attack(effect)
            end
        elseif effect:GetData().PST_bloomAttacking and effect:GetSprite():IsFinished() then
            effect:GetSprite():Play("Idle", true)
            effect:GetData().PST_bloomAttacking = false
        end

        -- Stepped on by enemy
        if Game():GetFrameCount() % 10 == 0 then
            if PST:getRoom():GetAliveEnemiesCount() == 0 then
                -- Disappear on room clear
                --effect:GetSprite():Play("Step", true)
                --effect:GetData().PST_bloomDying = true
            elseif effect.Variant ~= PSTAVessel.eternalBloomID then
                local getClosestEnem = PSTAVessel:getClosestEnemy(effect.Position, 10)
                if getClosestEnem and not getClosestEnem:IsFlying() then
                    -- On-step effect
                    if bloomFuncs and bloomFuncs.Death then
                        bloomFuncs.Death(effect)
                    end
                    effect:GetSprite():Play("Step", true)
                    effect:GetData().PST_bloomDying = true
                end
            end
        end
    elseif effect:GetSprite():IsFinished() then
        effect:Remove()
    end
end