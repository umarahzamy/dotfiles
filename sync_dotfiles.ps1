Copy-Item -Path "$env:USERPROFILE\dotfiles\nvim\lua\*" -Destination "$env:LOCALAPPDATA\nvim\lua" -Recurse -Force

Copy-Item -Path "$env:USERPROFILE\dotfiles\powershell\*" -Destination "$env:USERPROFILE\.config\powershell" -Force

Copy-Item -Path "$env:USERPROFILE\dotfiles\wezterm\*" -Destination "$env:USERPROFILE\.config\wezterm" -Recurse -Force

Copy-Item -Path "$env:USERPROFILE\dotfiles\windows-terminal\*" -Destination "$env:USERPROFILE\scoop\apps\windows-terminal\current\settings" -Recurse -Force
