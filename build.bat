if exist "./releases/astral vessel/content" rmdir /s /q "./releases/astral vessel/content"
if exist "./releases/astral vessel/resources" rmdir /s /q "./releases/astral vessel/resources"
if exist "./releases/astral vessel/scripts" rmdir /s /q "./releases/astral vessel/scripts"

if not exist "./releases/astral vessel" mkdir "./releases/astral vessel"
if not exist "./releases/astral vessel/resources" mkdir "./releases/astral vessel/resources"
xcopy /s /y /i /exclude:build_exclude.txt "./resources" "./releases/astral vessel/resources/"

if not exist "./releases/astral vessel/scripts" mkdir "./releases/astral vessel/scripts"
xcopy /s /y /i "./scripts" "./releases/astral vessel/scripts/"

if not exist "./releases/astral vessel/content" mkdir "./releases/astral vessel/content"
xcopy /s /y /i "./content" "./releases/astral vessel/content/"

xcopy /y /i "main.lua" "./releases/astral vessel/main.lua"
xcopy /y /i "thumb.png" "./releases/astral vessel/thumb.png"