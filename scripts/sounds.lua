function PSTAVessel:preSFXPlay(SFXID, volume, frameDelay, loop, pitch, pan)
    if Isaac.IsInGame() then
        local isVessel = PST:getPlayer():GetPlayerType() == PSTAVessel.vesselType
        if isVessel then
            -- Custom hurt/death SFX
            if PSTAVessel.modCooldowns.playerDmgWindow > 0 then
                local tmpPitch = PSTAVessel.charHurtPitch
                if PSTAVessel.charHurtRandpitch then
                    tmpPitch = tmpPitch - 0.1 + 0.2 * math.random()
                end
                if SFXID == SoundEffect.SOUND_ISAAC_HURT_GRUNT then
                    return {PSTAVessel.charHurtSFX, volume, frameDelay, loop, tmpPitch, pan}
                elseif SFXID == SoundEffect.SOUND_ISAACDIES then
                    return {PSTAVessel.charDeathSFX, volume, frameDelay, loop, tmpPitch, pan}
                end
            end
        end
    end
end