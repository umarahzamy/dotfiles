# PostgreSQL Password File Setup
$env:PGPASSFILE = "$HOME\.pgpass"

# Lightweight profile - only loads modules/themes
function wtwl {
    wt -w 0 split-pane -H -s 0.3 -p "PowerShell" -d "$PWD" `; split-pane -V -p "PowerShell" -d "$PWD" `; focus-pane -t 0
}

# PSReadLine (command line enhancements)
Import-Module PSReadLine -ErrorAction SilentlyContinue
if (Get-Module PSReadLine) {
  Set-PSReadLineOption -PredictionSource History
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -EditMode Windows
}

# Terminal Icons (pretty file listings)
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# Posh-Git (git status in prompt)
Import-Module posh-git -ErrorAction SilentlyContinue

# Oh-My-Posh (prompt theme)
oh-my-posh init pwsh --config $HOME\.config\powershell\nordcustom_v.2.omp.json | Invoke-Expression

