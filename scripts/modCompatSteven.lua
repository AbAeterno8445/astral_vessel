local tfStevenAffinityDialogues = {
    [PSTAVConstellationType.DIVINE] = {
        {
            "aligned with the heavens are you? hmm...",
            "always found it interesting",
            "just how many kills you 'good-doers' rack up",
            "well, here's to more deaths under your belt"
        }
    },
    [PSTAVConstellationType.DEMONIC] = {
        {
            "another demon, yeah?",
            "so tell me, what's your gimmick?",
            "lasers? toxic blood? hellfire?",
            "or perhaps, something like *this*"
        }
    },
    [PSTAVConstellationType.OCCULT] = {
        {
            "do you ever stop and think...",
            "rituals are kinda lame?",
            "something about this ancient art",
            "of pretending to know what's happening"
        },
        {
            "ritualist...",
            "you ever manage to summon...",
            "anything other than bad luck?"
        }
    },
    [PSTAVConstellationType.MERCANTILE] = {
        {
            "wherever do you keep all those coins?",
            "wait, don't tell me",
            "i don't really want to know"
        },
        {
            "i bet your idea of a hard day's work",
            "is just counting your coins",
            "...perhaps you'd like a taste",
            "of some real hard work"
        }
    },
    [PSTAVConstellationType.MUNDANE] = {
        {
            "...",
            "...",
            "...it's like staring at drying paint",
            "perhaps you'd like to spice it up a smidge?"
        }
    },
    [PSTAVConstellationType.MUTAGENIC] = {
        {
            "eugh, grotesque...",
            "whatever happened to you?",
            "perhaps you'd like to search",
            "for some kind of cure here?"
        }
    },
    [PSTAVConstellationType.ELEMENTAL] = {
        {
            "mastery over the elements...",
            "something about this phrase",
            "makes it sound so unimpressive to me",
            "but i'm sure your talents won't go to waste",
            "where you're going next"
        }
    },
    [PSTAVConstellationType.COSMIC] = {
        {
            "spacefarer, you seem to be far from home",
            "but i'm sure you're used to it",
            "how about a journey...",
            "that takes you even farther from home"
        }
    }
}
local tfStevenEmpyreanDialogues = {
    ["Necromancer"] = {
        {
            "so you're a necromancer?",
            "can you revive my faith in humanity?",
            "hehehe...",
            "oh",
            "i made myself sad"
        }
    },
    ["Volcano"] = {
        {
            "please tell me you're not too spicy",
            "if you're like jalapeno spicy, i can handle that",
            "but if you're like one of those hot sauces",
            "with a name like 'satan's piss' or whatever",
            "...this is gonna suck"
        }
    },
    ["Flower"] = {
        {
            "great, you're making my allergies act up",
            "i keep wanting to sneeze...",
            "but i just can't get myself to",
            "ah.... ahhh... AHHHH..."
        }
    },
    ["Moon"] = {
        {
            "shhhh",
            "it's a secret to everybody"
        }
    },
    ["Paladin"] = {
        {
            "oh, a paladin?",
            "i can respect that",
            "im more of a spellcaster player myself",
            "mostly because i can't hold a sword"
        }
    },
    ["Sun"] = {
        {
            "future's so bright i gotta wear shades!",
            "...",
            "that's a lie",
            "the future's actually pretty dismal"
        }
    },
    ["Singularity"] = {
        {
            "that's your best black hole?",
            "weak",
            "watch this"
        }
    },
    ["Archdemon"] = {
        {
            "uhhhhhhhhhh",
            "let's, uh, make this quick...",
            "i have to... go... uhhhh",
            "iron my lawn?",
            "ohgodpleasedonthurtme"
        }
    },
    ["God of Wealth"] = {
        {
            "god of wealth huh?",
            "are you like midas?",
            "do you turn everything into gold?",
            "no matter where you go...",
            "you probably drive inflation through the roof",
            "in short, this is your fault"
        }
    },
    ["Blizzard"] = {
        {
            "you know the best way to prevent brain freeze?",
            "press your tongue against the roof of your mouth",
            "wait",
            "why am i telling YOU this"
        }
    },
    ["Abomination"] = {
        {
            "come on, hideous monster",
            "do your worst"
        }
    },
    ["Baphomet"] = {
        {
            "hey there... cliff-faced as usual, i see",
            "...wait",
            "wait wait wait no",
            "this is the wrong script",
            "dammit... there goes my bonus"
        }
    }
}

function PSTAVessel:initFutureStevenDialogue()
    if TheFuture then
        local tfStevenDialogues = {
            {"ouch... you hurt to look at",
            "it's like i'm simultaneously staring",
            "at everything and nothing",
            "...",
            "are you ai generated or something"},
            {"you...",
            "you reek of stardust",
            "...",
            "i don't have the greatest feeling about this one..."}
        }
        for _, tmpType in pairs(PSTAVConstellationType) do
            local tmpAff = PSTAVessel.constelAlloc[tmpType].affinity
            if tmpAff and tmpAff >= 30 and tfStevenAffinityDialogues[tmpType] then
                -- Clean default lines
                tfStevenDialogues = {}
                for _, tmpLines in pairs(tfStevenAffinityDialogues[tmpType]) do
                    table.insert(tfStevenDialogues, tmpLines)
                end
            end
            for constName, _ in pairs(PSTAVessel.constelAlloc[tmpType]) do
                if tfStevenEmpyreanDialogues[constName] then
                    for _, tmpLines in ipairs(tfStevenEmpyreanDialogues[constName]) do
                        table.insert(tfStevenDialogues, tmpLines)
                    end
                end
            end
        end
        if PST.modData.charData["Astral Vessel"].level >= 100 then
            table.insert(tfStevenDialogues, {
                "that world-weary look...",
                "like you've seen it all, and more",
                "well, i highly doubt...",
                "any of that was *this* cool"
            })
        end
        TheFuture.ModdedCharacterDialogue["Astral Vessel"] = tfStevenDialogues[math.random(#tfStevenDialogues)]
    end
end