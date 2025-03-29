function PSTAVessel:getChangelogList()
    local changelog = {
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