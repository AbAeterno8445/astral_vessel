function PSTAVessel:getChangelogList()
    local changelog = {
        "",

        "v0.2.14",
        "- Additional compatibility for Foks' Booster Pack mod items, and new items from Reverie: MGO.",
        "- The \"Gold-Bound\" node (Greed mercantile constellation) now has the following lines:",
        "   \"Lose a coin heart when entering the second floor.\",",
        "   \"You can only have up to 4 coin hearts.\"",
        "- Changed the \"Gold Heart On Penny Pickup\" nodes to \"Gold Heart On Room Completion\" in the Greed mercantile constellation.",
        "- Constellation effects that spawn clots no longer drain your hearts.",
        "- Disabled Reverie's \"Vicious Curse\" from starting items.",
        "- Fixed error when starting a new savefile and Astral Vessel was uninitialized.",
        "- Fixed occasional error when familiars dealt damage.",
        "- Fixed \"Rune On Secret Rooms\" nodes triggering every time you re-entered a visited secret room, instead of just the first time.",
        "- Fixed Cat's-Eye Prism Ancient Jewel not transforming you into Guppy if any starting items were selected.",
        "- Fixed allocation of main constellation nodes not updating total allocations properly.",
        "- Fixed lesser constellation main nodes staying available regardless of allocation status in certain circumstances.",
        "",

        "v0.2.13",
        "- Additional compatibility for Pudding and Wakaba mod items, and new items from Reverie: MGO.",
        "- Changed internal ID for the quality 3 items unlock achievement, in an attempt to fix initialization failure.",
        "- Slight optimizations to on-hit and on-death functions.",
        "- Black hole damage ticks no longer trigger on-hit effects.",
        "",

        "v0.2.12",
        "- Fixed error that could occur if any achievement failed to initialize.",
        "",

        "v0.2.11",
        "- Updated how unlocks are checked, which should also fix the 'all completion marks' unlock not working.",
        "- Fixed Birthright effect triggering again on item pedestals that didn't get an item cycle.",
        "",

        "v0.2.10",
        "- Added XP nodes and a Coalescing Soul node cluster to Astral Vessel's main tree.",
        "",

        "v0.2.9",
        "- Fixed loadouts past page 1 not selecting the correct ID.",
        "",

        "v0.2.8",
        "- Fixed potential error when initializing base starting items.",
        "",

        "v0.2.7",
        "- Adjusted \"Soul Hearts On Kill\" and \"Beam Of Light On Hit\" modifiers from the Seraph divine constellation.",
        "- Unlocking all hard completion marks with Vessel now additionally grants +1 greater constellation choice.",
        "- Fixed starting bomb nodes not granting affinity for the Ember elemental constellation.",
        "",

        "v0.2.6",
        "- Additional compatibility for the Birthcake Rebaked mod, granting the Birthcake trinket an unique effect for Vessel.",
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