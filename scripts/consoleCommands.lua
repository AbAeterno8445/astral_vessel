PSTAVessel.consoleCommands = {
    ["avessel_unlockall"] = {
        desc = "Unlock all of Astral Vessel's locked features",
        compType = AutocompleteType.ACHIEVEMENT,
        func = function(params)
            PSTAVessel:onCompletion("Mom")
            PSTAVessel:onCompletion("Momhard")
            PSTAVessel:onCompletion("lvl100")
            for _, tmpType in pairs(CompletionType) do
                PSTAVessel:onCompletion(tmpType)
                PSTAVessel:onCompletion(tmpType .. "hard")
            end
            print("Astral Vessel - Triggered all completion events.")
        end
    },
    ["avessel_infinity"] = {
        desc = "Astral Vessel - Set all affinities to 100",
        compType = AutocompleteType.DEBUG_FLAG,
        func = function(params)
            for _, tmpType in pairs(PSTAVConstellationType) do
                PSTAVessel.constelAlloc[tmpType].affinity = 100
            end
            print("Astral Vessel - Set all affinities to 100.")
        end
    }
}

function PSTAVessel:initConsoleCMDs()
    for cmdName, cmdData in pairs(PSTAVessel.consoleCommands) do
        Console.RegisterCommand(cmdName, cmdData.desc, cmdName .. " - " .. cmdData.desc, true, cmdData.compType)
    end
end
PSTAVessel:initConsoleCMDs()

function PSTAVessel:onConsoleCMD(CMD, params)
    for cmdName, cmdData in pairs(PSTAVessel.consoleCommands) do
        if CMD == cmdName then cmdData.func(params) end
    end
end