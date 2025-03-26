PSTAVessel.ChangelogMenuID = "avesselChangelog"
include("scripts.menus.changelog.changelog")

function PSTAVessel:initChangelogMenu()
    local changelogMenu = {
        menuScrollX = 0
    }
    PST.treeScreen.modules.menuScreensModule.menus[PSTAVessel.ChangelogMenuID] = changelogMenu

    function changelogMenu:OnOpen()
        self.menuScrollX = 0
        PSTAVessel.isNewVersion = nil
    end

    function changelogMenu:OnInput()
        local camSpeed = 4
        if PST:isKeybindActive(PSTKeybind.PAN_FASTER, true) then
            camSpeed = 8
        end

        if PST:isKeybindActive(PSTKeybind.TREE_PAN_LEFT, true) then
            -- PAN LEFT
            if self.menuScrollX > 0 then
                self.menuScrollX = math.max(0, self.menuScrollX - camSpeed)
            end
        elseif PST:isKeybindActive(PSTKeybind.TREE_PAN_RIGHT, true) then
            -- PAN RIGHT
            if self.menuScrollX < 100 then
                self.menuScrollX = math.min(100, self.menuScrollX + camSpeed)
            end
        end

        if PST:isKeybindActive(PSTKeybind.CENTER_CAMERA) then
            self.menuScrollX = 0
            PST.treeScreen.modules.menuScreensModule.menuScrollY = 0
        end
    end

    function changelogMenu:Render(tScreen, menuModule)
        tScreen:DrawNodeBox("CHANGELOG", PSTAVessel:getChangelogList(), 8 - self.menuScrollX, 8 + menuModule.menuScrollY, true, 1)
    end
end