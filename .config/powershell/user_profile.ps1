# Start total profile timer
$totalTime = [System.Diagnostics.Stopwatch]::StartNew()

# Initialize timings collection
$global:ProfileTimings = [System.Collections.Generic.List[object]]::new()

# PostgreSQL Password File Setup
$env:PGPASSFILE = "$HOME\.pgpass"

# Function definitions
function dotfiles { 
    git --git-dir=$HOME\dotfiles --work-tree=$HOME @args
}

$sectionTime = [System.Diagnostics.Stopwatch]::StartNew()
# PSReadLine
Import-Module PSReadLine -ErrorAction SilentlyContinue
if (Get-Module PSReadLine) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
}
$sectionTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{
    Section = "PSReadLine"
    TimeMS = $sectionTime.ElapsedMilliseconds
})

# Terminal Icons
$sectionTime.Restart()
function Invoke-TerminalIcons {
    if (-not (Get-Module Terminal-Icons)) {
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue  # ← Loads HERE on first use
    }
    Get-ChildItem @args
}
Set-Alias ls Invoke-TerminalIcons
if (Get-Alias dir -ErrorAction SilentlyContinue) {
    Remove-Item Alias:\dir -Force
}
Set-Alias dir Invoke-TerminalIcons
$sectionTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{
    Section = "Terminal-Icons"
    TimeMS = $sectionTime.ElapsedMilliseconds
})

# Oh-My-Posh
$sectionTime.Restart()
oh-my-posh init pwsh --config $HOME\.config\powershell\plain_customized.omp.json | Invoke-Expression
$sectionTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{
    Section = "Oh-My-Posh"
    TimeMS = $sectionTime.ElapsedMilliseconds
})

# Display timings
$totalTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{
    Section = "TOTAL PROFILE TIME"
    TimeMS = $totalTime.ElapsedMilliseconds
})

$global:ProfileTimings | Format-Table -AutoSize
