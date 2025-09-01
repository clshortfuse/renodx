# deploy-early-access.ps1
# Simple helper: if --target not provided, list available CMake targets (excluding '-shaders').
# If --target is provided ("--target=name" or "--target name"), build that target.

param()

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Resolve-Path (Join-Path $scriptDir "..") | Select-Object -ExpandProperty Path
$buildDir = Join-Path $repoRoot "build"

$targetName = $null
$description = $null
for ($i = 0; $i -lt $args.Count; $i++) {
  $a = $args[$i]
  if ($a -like '--target=*') {
    $targetName = $a.Substring(9)
    continue;
  }
  if ($a -in @('--target', '-target', '-t')) {
    if ($i + 1 -lt $args.Count) { 
      $targetName = $args[$i + 1];
      continue;
    }
  }
  if ($a -like '--description=*') {
    $description = $a.Substring(14)
    continue
  }
  if ($a -in @('--description', '-description', '-d')) {
    if ($i + 1 -lt $args.Count) { 
      $description = $args[$i + 1]; 
      continue
    }
  }
}

if (-not (Test-Path $buildDir)) {
  Write-Host "Build directory not found: $buildDir" -ForegroundColor Yellow
}

# Use the module's helpers for target discovery and interactive picker.
$modulePath = Join-Path $PSScriptRoot 'helper-module.psm1'
if (-not (Test-Path $modulePath)) { Write-Host "Build module not found: $modulePath" -ForegroundColor Red; exit 1 }
Import-Module $modulePath -Force

if (-not $targetName) {
  $gamesDir = Join-Path $repoRoot "src\games"
  if (-not (Test-Path $gamesDir)) {
    Write-Host "No src/games directory found; nothing to list." -ForegroundColor Yellow
    exit 0
  }

  $res = Get-GameTargets -GamesDir $gamesDir -RecentCount 5
  if (-not $res) { Write-Host "No targets found." -ForegroundColor Yellow; exit 0 }

  Write-Host "Interactive filter: type to narrow targets, Backspace to delete, Enter to select the top match, Press Esc to exit.`n"
  # Use the exact script iteration from the module so behavior matches the original.
  $chosen = Show-TargetPicker -Targets $res.Targets -InitialMatches $res.InitialMatches -RepoRoot $repoRoot -BuildDir $buildDir
  if ($chosen) {
    $targetName = $chosen
  } else {
    Write-Host "Cancelled." -ForegroundColor Yellow; exit 0 
  }
}


# Perform Build
#Write-Host "Building target: $targetName`n"
Write-Host

$ret = Invoke-SetupVSDevEnv
if ($ret -ne $TRUE) { 
  Write-Host "Failed to set up VS dev environment."
  exit 1 
}
$rc = Invoke-BuildTarget -TargetName $targetName
if ($rc -ne 0) {
  Write-Host "Build failed with code $rc" -ForegroundColor Red
  exit $rc;
}

# List the output file(s)
$outputFile = "$buildDir\Release\renodx-$targetName.addon64"
if (Test-Path $outputFile) {
  Write-Host "`nBuilt addon: $outputFile" -ForegroundColor Green
} else {
  Write-Host "`nExpected output not found: $outputFile" -ForegroundColor Yellow
}

# Load .env file if present
$envFile = Join-Path $repoRoot '.env'
if (Test-Path $envFile) {
  Write-Host "Loading environment from $envFile"
  Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith('#')) {
      $parts = $line.Split('=', 2)
      if ($parts.Count -eq 2) {
        $key = $parts[0].Trim()
        $value = $parts[1].Trim().Trim('"')
        [System.Environment]::SetEnvironmentVariable($key, $value)
      }
    }
  }
}

$WebhookUrl = $env:RENODX_DISCORD_WEBHOOK_EA
# Send output to Discord webhook if configured
if (-not $WebhookUrl) {
  Write-Host "No RENODX_DISCORD_WEBHOOK_EA environment variable set; skipping webhook upload." -ForegroundColor Yellow
  exit 1;
}

$DiscordUserId = $env:RENODX_DISCORD_USERID
$MentionedUsers = @()
$Author = $null
if ($DiscordUserId) { 
  $Author = "<@${DiscordUserId}>"
  $MentionedUsers += $DiscordUserId
} else {
  $Author = (git config user.name)
}

$Content = "Uploader: $Author"
if ($description) {
  $Content += "`nDescription: $description"
}

$fileToSend = (Test-Path $outputFile) ? $outputFile : (Join-Path $PSScriptRoot 'expectedOutput')
$discordResult = Invoke-DiscordWebhookFile `
  -WebhookUrl $WebhookUrl `
  -FilePath $fileToSend `
  -Content $Content `
  -MentionedUsers $MentionedUsers `
  -Wait

if ($discordResult -ne 0) {
  Write-Host "Failed to send webhook" -ForegroundColor Red
  exit $discordResult
}

Write-Host "Done." -ForegroundColor Green
exit 0