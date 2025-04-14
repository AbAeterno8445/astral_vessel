---@param target Entity
---@param damage number
---@param flag DamageFlag
---@param source EntityRef
function PSTAVessel:postDamage(target, damage, flag, source)
    if target then
        if target.Type == EntityType.ENTITY_PLAYER then
            -- Player got hit
        elseif target.Type ~= EntityType.ENTITY_GIDEON then
            -- Fireplace hit
            if target.Type == EntityType.ENTITY_FIREPLACE then
                -- Fireplace destroyed
                if damage >= target.HitPoints then
                    -- Mod: +% damage for the current floor when destroying a fireplace
                    local tmpMod = PST:getTreeSnapshotMod("fireplaceDmgBuff", 0)
                    if tmpMod > 0 and PST:getTreeSnapshotMod("fireplaceDmgBuffProcs", 0) < 15 then
                        PST:addModifiers({
                            fireplaceDmgBuffTotal = tmpMod,
                            fireplaceDmgBuffProcs = 1,
                            damagePerc = tmpMod
                        }, true)
                    end
                end
            end
        end
    end
end