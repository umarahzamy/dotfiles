# Simple Scoop and App Installer with Registry Imports

# Install Scoop if not present
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

# Install Git if not present
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..." -ForegroundColor Yellow
    scoop install git
    git config --global credential.helper manager
    
    # Import Git registry settings
    reg import "$env:USERPROFILE\scoop\apps\git\current\install-context.reg"
    reg import "$env:USERPROFILE\scoop\apps\git\current\install-file-associations.reg"
    reg import "$env:USERPROFILE\scoop\apps\7zip\current\install-context.reg"
}

# Add required buckets
scoop bucket add main
scoop bucket rm extras
scoop bucket add extras
scoop bucket rm versions
scoop bucket add versions
scoop bucket rm nerd-fonts
scoop bucket add nerd-fonts

# Update Scoop
Write-Host "Updating Scoop..." -ForegroundColor Yellow
scoop update

# Core dev tools
scoop install main/gcc
scoop install versions/python311
scoop install versions/nodejs20
scoop install main/pnpm
scoop install versions/postgresql16

# Terminal improvements
scoop install main/pwsh
scoop install main/oh-my-posh
scoop install extras/windows-terminal
scoop install main/fzf

# Dev utilities
scoop install main/neovim
scoop install extras/lazygit
scoop install main/ripgrep
scoop install main/fd
scoop install main/modd

# System tools
scoop install extras/curl
scoop install main/sudo
scoop install main/which

# Monitoring
scoop install extras/hwmonitor
scoop install extras/trafficmonitor

# Fonts
scoop install nerd-fonts/JetBrainsMono-NF

# Misc apps
scoop install versions/lightshot
scoop install extras/winrar

# Import registry files
reg import "$env:USERPROFILE\scoop\apps\pwsh\current\install-explorer-context.reg"
reg import "$env:USERPROFILE\scoop\apps\pwsh\current\install-file-context.reg"
reg import "$env:USERPROFILE\scoop\apps\python311\current\install-pep-514.reg"
reg import "$env:USERPROFILE\scoop\apps\windows-terminal\current\install-context.reg"

# Import Module 
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Import-Module Terminal-Icons

# Update to point .config
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Set-Content -Path $PROFILE.CurrentUserCurrentHost -Value ". `$env:USERPROFILE\.config\powershell\user_profile.ps1" -Force

# Setup LazyVim
# required
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

# optional but recommended
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak

git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim

Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force

Write-Host "All done! Launching Neovim..." -ForegroundColor Green
nvim
