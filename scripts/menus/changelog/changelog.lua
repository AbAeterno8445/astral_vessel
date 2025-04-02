function PSTAVessel:getChangelogList()
    local changelog = {
        "",

        "v0.2.6",
        "- Added missing blurb for Vessel's Birthright.",
        "- Fixed switching loadouts with different tree types allocated potentially returning more skill points than intended.",
        "",

        "v0.2.5",
        "- Additional compatibility for the Doki Doki Repentance! mod, and Reverie/Reverie MGO costumes and custom hurt/death SFX.",
        "- Added the \"Blacksmith\" empyrean mundane constellation.",
        "- Added a Birthright effect to Astral Vessel: \"Non-progression item pedestals have a chance to cycle between its item and a",
        "random item from a constellation pool you have affinity in. Higher affinity grants that type a higher chance to be picked.\"",
        "- Added Modeling Clay as a starting trinket option, under the 'Instability' lesser cosmic constellation.",
        "",

        "v0.2.4",
        "- Additional compatibility for the Rebekah, Daydream All Day and Sweet Halloween mods.",
        "- Accessories using the 'head0' and 'head1' layers have been disabled as these are currently incompatible with the face/hair.",
        "- Adjusted face rendering code for better layer compatibility (such as with Andromeda eyes).",
        "- Fixed error caused by the \"+% to the lowest stat\" modifier.",
        "",

        "v0.2.3",
        "- Additional compatibility for the Balatro Jokers, Potato Pack 1, Red Baby and Heaven's Call mods.",
        "- Added some custom hurt/death SFX from Revelations and Retribution.",
        "- Support for accessories/hairstyles from the following mods: Samael, Mastema, Martha of Bethany, Bael, Arachna, Sheriff.",
        "- Support for mod Mushroom items, and Fly familiars (Suzerain Of Flies mutagenic node).",
        "- Starting items can no longer grant pickups, such as +5 bombs. Other effects from these items still apply.",
        "- Bomb effect items (nancy bombs, bob's curse, etc.) are now available as starting items.",
        "- Fixed a few accessories not being applied in-game.",
        "- Fixed accessory layer conflicts not showing up for non-item accessories (displayed on a blank head).",
        "- Fixed Vessel completion events triggering with any character.",
        "",

        "v0.2.2",
        "- Fixed error on Mephit constellation when hitting enemies afflicted with Hemoptysis' curse.",
        "",

        "v0.2.1",
        "- Fix Siren Hit sfx not playing.",
        "",

        "v0.2.0",
        "- Public beta release.",
        "",

        "v0.1.3",
        "- Added the following constellations: Choir (Divine), Mephit and Siren (Demonic), Self (Mundane), Rune and Lithomancer (Cosmic).",
        "- Added a free 'Custom Hurt Sound' node to Vessel's main tree, which allows you to customize on-hit and on-death sound effects.",
        "- Added a free 'Tonic Of Forgetfulness' node to all constellation trees. This node allows respeccing the entire tree in one go.",
        "- Support for Preyn's Collection mods (thanks wookywok!).",
        "- Implemented the Mutagenic constellation tree.",
        "- Increased max loadouts to 100, and added pagination to the loadouts submenu.",
        "- Improved loadouts display to show affinities + starting items on hover, as well as tinting the sprite to that loadout's character color.",
        "- Further tweaking of saving/loading system to prevent cases of skillpoints going negative or over the character's level.",
        "- Adjusted how accessories are saved to prevent unintentional shifting when adding/removing mods or future compat.",
        "- Further addition of various costumes and custom SFX.",
        "- Fixed starting trinket nodes not locking other trinket nodes on allocation.",
        "",

        "v0.1.2",
        "- Added Steven NPC (The Future mod) phrases for Vessel.",
        "- Questionnaire (Lost and Forgotten trinket) now drops obols for Vessel.",
        "- Fixed constellation trees not being initialized properly when launching the game.",
        "",

        "v0.1.1",
        "- Paladin constellation's \"Sword On Champion Hit\" sword projectiles now accelerate.",
        "- Adjusted savedata loading on fresh savefile.",
        "- Fixed \"% chance for enemies to drop a vanishing 1/2 heart on death\" modifiers not working (Vampire constellation).",
        "- Fixed constellation node changes not triggering a save.",
        "",

        "v0.1.0",
        "- Initial upload.",
    }

    for idx, tmpLine in ipairs(changelog) do
        if type(tmpLine) == "string" and tmpLine:sub(2) == PSTAVessel.version then
            ---@diagnostic disable-next-line: assign-type-mismatch
            changelog[idx] = {tmpLine .. " (Current)", KColor(0.7, 1, 0.9, 1)}
        end
    end
    return changelog
end