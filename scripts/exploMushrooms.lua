---@enum PSTAVesselMushType
PSTAVesselMushType = {
    RED = 1,
    BLUE = 2,
    WHITE = 3,
    YELLOW = 4,
    GREEN = 5,
    ORANGE = 6,
    BLACK = 7
}

PSTAVessel.creepMushrooms = {
    [EffectVariant.PLAYER_CREEP_GREEN] = PSTAVesselMushType.GREEN,
    [EffectVariant.PLAYER_CREEP_HOLYWATER] = PSTAVesselMushType.BLUE,
    [EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL] = PSTAVesselMushType.BLUE,
    [EffectVariant.PLAYER_CREEP_LEMON_MISHAP] = PSTAVesselMushType.YELLOW,
    [EffectVariant.PLAYER_CREEP_LEMON_PARTY] = PSTAVesselMushType.YELLOW,
    [EffectVariant.PLAYER_CREEP_RED] = PSTAVesselMushType.RED,
    [EffectVariant.PLAYER_CREEP_BLACK] = PSTAVesselMushType.BLACK,
    [EffectVariant.PLAYER_CREEP_WHITE] = PSTAVesselMushType.WHITE,
    [EffectVariant.PLAYER_CREEP_PUDDLE_MILK] = PSTAVesselMushType.WHITE,
    [33] = PSTAVesselMushType.BLUE -- Aquarius creep
}

local exploMushroomData = {
    -- Red mushrooms: burst of red tears
    [PSTAVesselMushType.RED] = {
        Setup = function(effect)
            effect.Color = Color(1, 0.25, 0.25, 1, 0.3 * math.random())
        end,
        Death = function(effect)
            local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
            poofFX:ToEffect().Color = Color(1, 0, 0, 1, 0.2)
            SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.8, 2, false, 0.8 + 0.4 * math.random())

            local maxTears = 3 + math.random(4)
            for _=1,maxTears do
                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, effect.Position, RandomVector() * (3 + 5 * math.random()), PST:getPlayer())
                newTear:ToTear():AddTearFlags(TearFlags.TEAR_DECELERATE)
                newTear:ToTear().Scale = 0.6 + 0.55 * math.random()
                newTear:ToTear().Height = -20
                newTear:ToTear().FallingSpeed = (-8 - 10 * math.random())
                newTear:ToTear().FallingAcceleration = 0.5 + 0.35 * math.random()
                newTear.CollisionDamage = math.min(40, PST:getPlayer().Damage * 0.75)
            end
        end
    },
    -- Blue mushrooms: burst of ice shards
    [PSTAVesselMushType.BLUE] = {
        Setup = function(effect)
            effect.Color = Color(0.3, 0.45, 1, 1)
        end,
        Death = function(effect)
            local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
            poofFX:ToEffect().Color = Color(0.4, 0.6, 1, 1)
            SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.8, 2, false, 0.8 + 0.4 * math.random())
            SFXManager():Play(SoundEffect.SOUND_FREEZE, 0.7)

            local maxTears = 3 + math.random(4)
            for _=1,maxTears do
                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ICE, 0, effect.Position, RandomVector() * (3 + 5 * math.random()), PST:getPlayer())
                newTear:ToTear():AddTearFlags(TearFlags.TEAR_ICE)
                newTear:ToTear().Scale = 0.5 + 0.3 * math.random()
                newTear:ToTear().Height = -20
                newTear:ToTear().FallingSpeed = (-8 - 10 * math.random())
                newTear:ToTear().FallingAcceleration = 0.5 + 0.35 * math.random()
                newTear.CollisionDamage = math.min(40, PST:getPlayer().Damage * 0.75)
            end
        end
    },
    -- White mushrooms: slow and damage nearby enemies
    [PSTAVesselMushType.WHITE] = {
        Setup = function(effect)
            effect.Color = Color(1, 1, 1, 1, 0.3, 0.3, 0.3)
        end,
        Death = function(effect)
            local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
            poofFX:ToEffect().Color = Color(1, 1, 1, 1, 0.3, 0.3, 0.3)
            SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.8, 2, false, 0.8 + 0.4 * math.random())

            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 100, EntityPartition.ENEMY)
            for _, tmpEnem in ipairs(nearbyEnems) do
                tmpEnem:AddSlowing(EntityRef(PST:getPlayer()), 120, 0.7, Color(0.7, 0.7, 0.7, 1))
                tmpEnem:TakeDamage(math.min(40, PST:getPlayer().Damage), 0, EntityRef(PST:getPlayer()), 0)
            end
        end
    },
    -- Yellow mushrooms: fire a long winded stream of yellow tears
    [PSTAVesselMushType.YELLOW] = {
        Setup = function(effect)
            effect.Color = Color(0.7 + 0.5 * math.random(), 0.7 + 0.5 * math.random(), 0, 1)
        end,
        Death = function(effect)
            local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
            poofFX:ToEffect().Color = Color(1, 1, 0, 1)
            SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.8, 2, false, 0.8 + 0.4 * math.random())

            local maxTears = 6 + math.random(6)
            for _=1,maxTears do
                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, effect.Position, RandomVector() * (5 * math.random()), PST:getPlayer())
                newTear:ToTear().Color = Color(1, 1, 0.25, 1, 0.4, 0.4)
                newTear:ToTear():AddTearFlags(TearFlags.TEAR_DECELERATE)
                newTear:ToTear().Scale = 0.4 + 0.3 * math.random()
                newTear:ToTear().Height = -20
                newTear:ToTear().FallingSpeed = (-20 - 60 * math.random())
                newTear:ToTear().FallingAcceleration = 0.5 + math.random()
                newTear.CollisionDamage = math.min(20, PST:getPlayer().Damage * 0.5)
            end
        end
    },
    -- Green mushrooms: create a long lasting cluster of hovering small poison tears
    [PSTAVesselMushType.GREEN] = {
        Setup = function(effect)
            effect.Color = Color(0.3, 0.7 + 0.5 * math.random(), 0.5, 1)
        end,
        Death = function(effect)
            local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
            poofFX:ToEffect().Color = Color(0, 0, 1, 1)
            SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.8, 2, false, 0.8 + 0.4 * math.random())

            local maxTears = 3 + math.random(4)
            for _=1,maxTears do
                local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, effect.Position, RandomVector() * (1 + 3 * math.random()), PST:getPlayer())
                newTear:ToTear().Color = Color(0.4, 1, 0.4 + 0.2 * math.random(), 0.75)
                newTear:ToTear():AddTearFlags(TearFlags.TEAR_DECELERATE | TearFlags.TEAR_POISON)
                newTear:ToTear().Scale = 0.2 + 0.2 * math.random()
                newTear:ToTear().Height = -5 - 25 * math.random()
                newTear:ToTear().FallingSpeed = -0.1
                newTear:ToTear().FallingAcceleration = -0.1
                newTear.CollisionDamage = math.min(40, PST:getPlayer().Damage * 0.75)

                Isaac.CreateTimer(function()
                    newTear:ToTear().FallingAcceleration = 0.25 + math.random()
                end, 120 + math.floor(120 * math.random()), 1, false)
            end
        end
    },
    -- Orange mushrooms: simple explosion (doesn't damage player)
    [PSTAVesselMushType.ORANGE] = {
        Setup = function(effect)
            effect.Color = Color(1, 0.6, 0.3 * math.random(), 1)
        end,
        Death = function(effect)
            local tmpDmg = math.max(10, math.min(100, PST:getPlayer().Damage * 2))
            local explosionFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, effect.Position, Vector.Zero, PST:getPlayer())
            explosionFX.Color = Color(1, 0.6, 0.3)
            explosionFX.SpriteScale = Vector(0.8, 0.8)

            local nearbyEnems = PSTAVessel:getNearbyNPCs(effect.Position, 80, EntityPartition.ENEMY)
            for _, tmpEnem in ipairs(nearbyEnems) do
                tmpEnem:TakeDamage(tmpDmg, DamageFlag.DAMAGE_EXPLOSION, EntityRef(PST:getPlayer()), 0)
            end
        end
    },
    -- Black mushrooms: shoot a thin black laser towards a random direction
    [PSTAVesselMushType.BLACK] = {
        Setup = function(effect)
            local tmpCol = 0.2 + 0.25 * math.random()
            effect.Color = Color(tmpCol, tmpCol, tmpCol, 1)
        end,
        Death = function(effect)
            local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effect.Position, Vector.Zero, nil)
            poofFX:ToEffect().Color = Color(0.2, 0.2, 0.2, 1)
            SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.8, 2, false, 0.8 + 0.4 * math.random())

            local newLaser = EntityLaser.ShootAngle(LaserVariant.THICK_RED, effect.Position, 360 * math.random(), 20, Vector.Zero, PST:getPlayer())
            newLaser.DisableFollowParent = true
            newLaser:SetScale(0.6)
            newLaser.Color = Color(0.1, 0.2, 0.2, 1)
            newLaser.CollisionDamage = 2 + math.min(10, PST:getPlayer().Damage / 10)
        end
    }
}

function PSTAVessel:testFunc()
    local tmpPos = Game():GetRoom():GetCenterPos()
    local poofFX = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tmpPos, Vector.Zero, nil)
    poofFX:ToEffect().Color = Color(1, 0, 0, 1, 0.2)
    SFXManager():Play(SoundEffect.SOUND_MUSHROOM_POOF, 0.8, 2, false, 0.8 + 0.4 * math.random())

    local maxTears = 4 + math.random(5)
    for _=1,maxTears do
        local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, tmpPos, RandomVector() * (3 + 2 * math.random()), PST:getPlayer())
        newTear:ToTear():AddTearFlags(TearFlags.TEAR_DECELERATE)
        newTear:ToTear().Scale = 0.6 + 0.55 * math.random()
        newTear:ToTear().Height = -20
        newTear:ToTear().FallingSpeed = (-8 - 10 * math.random())
        newTear:ToTear().FallingAcceleration = 0.5
        newTear.CollisionDamage = math.min(40, PST:getPlayer().Damage / 2)
    end
end

---@param effect EntityEffect
function PSTAVessel:exploMushroomUpdate(effect)
    -- Init setup
    if not effect:GetData().PST_exploMushroomSetup then
        -- Init random type if undefined
        if effect.SubType == 0 then
            effect.SubType = math.random(7)
        end
        local mushData = exploMushroomData[effect.SubType]
        if mushData and mushData.Setup then
            mushData.Setup(effect)
        end
        -- Random sprite
        effect:GetSprite():Play("Mush" .. math.random(7), true)
        effect:GetSprite().PlaybackSpeed = 0.5 + 0.25 * math.random()
        effect.SpriteScale = Vector(0.4 + 0.25 * math.random(), 0.4 + 0.25 * math.random())

        effect:GetData().PST_exploMushroomSetup = true
    else
        -- Death
        if effect:GetSprite():IsFinished() then
            local mushData = exploMushroomData[effect.SubType]
            if mushData and mushData.Death then
                mushData.Death(effect)
            end
            effect:Remove()
        end
    end
end