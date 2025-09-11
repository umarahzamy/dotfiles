# Start total profile timer
$totalTime = [System.Diagnostics.Stopwatch]::StartNew()
$global:ProfileTimings = [System.Collections.Generic.List[object]]::new()

# -----------------------------
# Environment setup
# -----------------------------
$dotEnvDir = $PSScriptRoot
$envFile = Join-Path $dotEnvDir ".env"
  Get-Content $envFile | ForEach-Object {
      if ($_ -match '^\s*$' -or $_ -match '^\s*#') { return }
      Invoke-Expression ('$env:' + $_.Trim())
  }

# Initialize zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# -----------------------------
# Functions & Aliases
# -----------------------------

# Dotfiles management
function dotfiles { 
    git --git-dir=$HOME\dotfiles --work-tree=$HOME @args
}

# Dev server with logging 
function dev-log {
    $LogDir = "./logs"
    $LogFile = "$LogDir/pnpm-dev.log"

    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    pnpm dev 2>&1 | Tee-Object -FilePath $LogFile -Encoding UTF8NoBOM
}

# Check with logging
function check-log {
    $LogDir = "./logs"
    $LogFile = "$LogDir/pnpm-check.log"

    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    pnpm check 2>&1 | Tee-Object -FilePath $LogFile -Encoding UTF8NoBOM
}

# Build with logging
function build-log {
    $LogDir = "./logs"
    $LogFile = "$LogDir/pnpm-build.log"

    New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    pnpm build 2>&1 | Tee-Object -FilePath $LogFile -Encoding UTF8NoBOM
}

Set-Alias dl dev-log
Set-Alias cl check-log
Set-Alias bl build-log

# Autossh like function
function autossh {
    param(
        [Parameter(Mandatory)]
        [string]$SshServer,

        [int]$GraceRetries = 3,
        [int]$MaxDelay = 60,
        [int]$ResetAfterMin = 5
    )

    $tries = 0

    while ($true) {
        $start = Get-Date
        Write-Host ("[{0}] Connecting to {1} ..." -f $start.ToString("yyyy-MM-dd HH:mm:ss"), $SshServer) -ForegroundColor Cyan

        ssh $SshServer

        $stop = Get-Date
        $uptime = $stop - $start
        Write-Host ("[{0}] SSH to {1} ended after {2}s." -f $stop.ToString("yyyy-MM-dd HH:mm:ss"), $SshServer, [int]$uptime.TotalSeconds) -ForegroundColor Yellow

        if ($uptime.TotalMinutes -ge $ResetAfterMin) {
            $tries = 0
            Write-Host ("Connection was stable ({0}m). Resetting counter." -f [int]$uptime.TotalMinutes) -ForegroundColor Green
        }

        Write-Host "Press q to quit, or wait to reconnect..." -ForegroundColor Cyan

        if ($tries -lt $GraceRetries) {
            $delay = 1
        } else {
            $delay = [math]::Pow(2, $tries - $GraceRetries)
            if ($delay -gt $MaxDelay) { $delay = $MaxDelay }
        }

        $left = $delay
        while ($left -gt 0) {
            if ($Host.UI.RawUI.KeyAvailable) {
                $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                if ($key.Character -eq 'q' -or $key.Character -eq 'Q') {
                    Write-Host "Exiting autossh..." -ForegroundColor Red
                    return
                }
            }
            if ($delay -gt 1) {
                Write-Host ("Reconnecting in {0}s..." -f $left) -ForegroundColor DarkGray
            }
            Start-Sleep -Seconds 1
            $left--
        }

        $tries++
    }
}

# -----------------------------
# UI Enhancements
# -----------------------------

# PSReadLine
$sectionTime = [System.Diagnostics.Stopwatch]::StartNew()
Import-Module PSReadLine -ErrorAction SilentlyContinue
if (Get-Module PSReadLine) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows

    Set-PSReadLineKeyHandler -Key Alt+k -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key Alt+j -Function HistorySearchForward
}
$sectionTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{ Section = "PSReadLine"; TimeMS = $sectionTime.ElapsedMilliseconds })

# Terminal Icons
$sectionTime.Restart()
function Invoke-TerminalIcons {
    if (-not (Get-Module Terminal-Icons)) {
        Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    }
    Get-ChildItem @args
}
Set-Alias ls Invoke-TerminalIcons
if (Get-Alias dir -ErrorAction SilentlyContinue) { Remove-Item Alias:\dir -Force }
Set-Alias dir Invoke-TerminalIcons
$sectionTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{ Section = "Terminal-Icons"; TimeMS = $sectionTime.ElapsedMilliseconds })

# Oh-My-Posh
$sectionTime.Restart()
oh-my-posh init pwsh --config $HOME\.config\powershell\plain_customized.omp.json | Invoke-Expression
$sectionTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{ Section = "Oh-My-Posh"; TimeMS = $sectionTime.ElapsedMilliseconds })

# -----------------------------
# Timing display
# -----------------------------
$totalTime.Stop()
$global:ProfileTimings.Add([PSCustomObject]@{ Section = "TOTAL PROFILE TIME"; TimeMS = $totalTime.ElapsedMilliseconds })
$global:ProfileTimings | Format-Table -AutoSize
