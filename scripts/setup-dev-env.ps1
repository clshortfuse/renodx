<#
.SYNOPSIS
  Prepare a developer environment for RenoDX on Windows.

.DESCRIPTION
  Creates a local `bin` folder and downloads commonly required shader tool binaries
  (example: the DirectX Shader Compiler package with dxc.exe/dxcompiler.dll,
  and Slang) into it if they're missing.
  Checks for the Windows 10/11 SDK and can optionally install it via winget.

.PARAMETER Install
    When specified, the script will perform installs (including attempting to install the Windows 10/11 SDK via winget when necessary).

.PARAMETER Update
    Re-runs version-aware install checks and updates managed tools when the configured package is newer than the installed one.
    Newer local installs are left in place.

.EXAMPLE
    .\setup-dev-env.ps1 -Install

#>

param(
  [string]$Bin,
  [switch]$Install,
  [switch]$Update
)

Set-StrictMode -Version Latest

function Write-Info($m) { Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Write-Warn($m) { Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Write-Err($m) { Write-Host "[ERROR] $m" -ForegroundColor Red }

# determine whether the script should actually perform installs/updates
$doAction = $Install -or $Update
$isDryRun = -not $doAction

# Do not change the caller's current working directory. Determine the bin directory as:
# - if --Bin was provided, use that (resolve relative to caller cwd if needed)
# - otherwise default to the current working directory + 'bin'
if ($PSBoundParameters.ContainsKey('Bin') -and $Bin -and $Bin.Trim().Length -gt 0) {
  try {
    $resolved = Resolve-Path -Path $Bin -ErrorAction SilentlyContinue
    if ($resolved) { $binDir = $resolved.ProviderPath } else { $binDir = Join-Path (Get-Location).Path $Bin }
  } catch { $binDir = Join-Path (Get-Location).Path $Bin }
} else {
  $binDir = Join-Path (Get-Location).Path 'bin'
}

# Helper/module and path variables (no action at top-level)
$modulePath = Join-Path $PSScriptRoot 'helper-module.psm1'
# Normalize bin path to an absolute path (variable setup only)
$binDir = [System.IO.Path]::GetFullPath($binDir)

# Managed tool package versions live here as script-scope constants so they can be bumped in one place.
$script:DXC_VERSION = '1.9.2602'
$script:SLANG_VERSION = '2025.16.1'
$script:THREEDMIGOTO_VERSION = '1.3.16'

$script:ResolvedToolDownloads = @{}

$toolDefinitions = @{
  'dxc' = @{
    ProductName    = 'DirectX Shader Compiler'
    DesiredVersion = $script:DXC_VERSION
    ReleaseRepo    = 'microsoft/DirectXShaderCompiler'
    ReleaseTag     = "v$($script:DXC_VERSION)"
    AssetPattern   = '^dxc_\d{4}_\d{2}_\d{2}\.zip$'
    ExpectedFiles  = @('dxc.exe', 'dxcompiler.dll')
    PrimaryFile    = 'dxc.exe'
    VersionCommand = @('--version')
    VersionPattern = 'dxcompiler\.dll:\s+\d+\.\d+\s+-\s+([0-9]+(?:\.[0-9]+){2,3})'
  }
  'slang' = @{
    ProductName    = 'Slang'
    DesiredVersion = $script:SLANG_VERSION
    Url            = "https://github.com/shader-slang/slang/releases/download/v$($script:SLANG_VERSION)/slang-$($script:SLANG_VERSION)-windows-x86_64.zip"
    ExpectedFiles  = @('slangc.exe')
    PrimaryFile    = 'slangc.exe'
    VersionCommand = @('-version')
    VersionPattern = '([0-9]+(?:\.[0-9]+){2,3})'
  }
  '3dmigoto' = @{
    ProductName    = '3Dmigoto cmd_Decompiler'
    DesiredVersion = $script:THREEDMIGOTO_VERSION
    Url            = "https://github.com/bo3b/3Dmigoto/releases/download/$($script:THREEDMIGOTO_VERSION)/cmd_Decompiler-$($script:THREEDMIGOTO_VERSION).zip"
    ExpectedFiles  = @('cmd_Decompiler.exe')
    PrimaryFile    = 'cmd_Decompiler.exe'
    VersionCommand = @('--version')
    VersionPattern = '([0-9]+(?:\.[0-9]+){2,3})'
  }
}

function Import-HelperModule {
  if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
  } else {
    Write-Warn "Helper module not found: $modulePath. SDK path helper will not be available."
  }
}

function Initialize-BinDir {
  if (-not (Test-Path $binDir)) {
    if (-not $isDryRun) {
      New-Item -Path $binDir -ItemType Directory | Out-Null
    }
  }
}

function Get-ToolDefinition {
  param([string]$Name)

  if (-not $toolDefinitions.ContainsKey($Name)) { return $null }

  return $toolDefinitions[$Name]
}

function Get-GitHubReleaseAssetDownloadInfo {
  param(
    [string]$Repo,
    [string]$Tag,
    [string]$AssetPattern
  )

  $cacheKey = "$Repo|$Tag|$AssetPattern"
  if ($script:ResolvedToolDownloads.ContainsKey($cacheKey)) {
    return $script:ResolvedToolDownloads[$cacheKey]
  }

  $headers = @{
    'User-Agent' = 'renodx-setup'
    'Accept' = 'application/vnd.github+json'
  }
  $releaseApiUrl = "https://api.github.com/repos/$Repo/releases/tags/$Tag"
  $originalSecurityProtocol = [Net.ServicePointManager]::SecurityProtocol

  try {
    if (($originalSecurityProtocol -band [Net.SecurityProtocolType]::Tls12) -eq 0) {
      [Net.ServicePointManager]::SecurityProtocol = $originalSecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    $response = Invoke-WebRequest -Uri $releaseApiUrl -Headers $headers -UseBasicParsing -ErrorAction Stop
    $release = $response.Content | ConvertFrom-Json
    $asset = @($release.assets | Where-Object { $_.name -match $AssetPattern } | Select-Object -First 1)
  } finally {
    [Net.ServicePointManager]::SecurityProtocol = $originalSecurityProtocol
  }

  if ($asset.Count -eq 0) {
    throw "No release asset matched pattern '$AssetPattern' for $Repo tag $Tag"
  }

  $downloadInfo = [pscustomobject]@{
    Url = $asset[0].browser_download_url
    ArchiveName = $asset[0].name
  }
  $script:ResolvedToolDownloads[$cacheKey] = $downloadInfo
  return $downloadInfo
}

function Get-ToolDownloadInfo {
  param([string]$Name)

  $tool = Get-ToolDefinition -Name $Name
  if ($null -eq $tool) { return $null }

  if ($tool.ContainsKey('Url')) {
    return [pscustomobject]@{
      Url = $tool.Url
      ArchiveName = [System.IO.Path]::GetFileName($tool.Url)
    }
  }

  if ($tool.ContainsKey('ReleaseRepo') -and $tool.ContainsKey('ReleaseTag') -and $tool.ContainsKey('AssetPattern')) {
    return Get-GitHubReleaseAssetDownloadInfo -Repo $tool.ReleaseRepo -Tag $tool.ReleaseTag -AssetPattern $tool.AssetPattern
  }

  throw "Tool '$Name' does not define a download URL or release discovery metadata."
}

function Get-ToolExpectedFiles {
  param([string]$Name)

  $tool = Get-ToolDefinition -Name $Name
  if ($null -eq $tool) { return @() }

  return @($tool.ExpectedFiles)
}

function Get-ToolProductName {
  param([string]$Name)

  $tool = Get-ToolDefinition -Name $Name
  if ($null -eq $tool) { return $Name }
  if ($tool.ContainsKey('ProductName')) { return $tool.ProductName }

  return $Name
}

function Get-ToolManagedFilesText {
  param([string]$Name)

  return (@(Get-ToolExpectedFiles -Name $Name) -join ', ')
}

function Get-WindowsSdkVersionText {
  if (Get-Command Get-WindowsSdkLatestBinPath -ErrorAction SilentlyContinue) {
    $versionedBin = Get-WindowsSdkLatestBinPath
    if ($versionedBin) {
      return [System.IO.Path]::GetFileName($versionedBin)
    }
  }

  if (Get-Command Get-WindowsSdkPath -ErrorAction SilentlyContinue) {
    $kitsRoot10 = Get-WindowsSdkPath
  } else {
    $props = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots' -ErrorAction SilentlyContinue
    $kitsRoot10 = $props.KitsRoot10
  }

  if (-not $kitsRoot10) { return $null }

  $binRoot = Join-Path $kitsRoot10 'bin'
  if (-not (Test-Path $binRoot)) { return $null }

  $version = Get-ChildItem -Path $binRoot -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match '^[0-9]' } |
    Sort-Object Name -Descending |
    Select-Object -First 1 -ExpandProperty Name

  return $version
}

function Get-ToolActionDetails {
  param(
    [string]$Name,
    [pscustomobject]$InstalledVersionInfo,
    [pscustomobject]$DesiredVersionInfo,
    [string[]]$MissingFiles = @()
  )

  $verb = 'install'
  $notes = @()

  if (($null -ne $InstalledVersionInfo) -and ($null -ne $DesiredVersionInfo) -and ($InstalledVersionInfo.Version -lt $DesiredVersionInfo.Version)) {
    $verb = 'update'
    $notes += "$($InstalledVersionInfo.Text) -> $($DesiredVersionInfo.Text)"
  }
  if ($MissingFiles.Count -gt 0) {
    $notes += "missing: $($MissingFiles -join ', ')"
  }

  $suffix = ''
  if ($notes.Count -gt 0) {
    $suffix = " ($($notes -join '; '))"
  }

  return [pscustomobject]@{
    Verb = $verb
    Summary = "$(Get-ToolProductName -Name $Name): $(Get-ToolManagedFilesText -Name $Name)$suffix"
  }
}

function Get-ToolMissingFiles {
  param([string]$Name)

  $missing = @()
  foreach ($file in @(Get-ToolExpectedFiles -Name $Name)) {
    if (-not (Test-Path (Join-Path $binDir $file))) { $missing += $file }
  }

  return $missing
}

function Get-ToolStatusLine {
  param([string]$Name)

  $productName = Get-ToolProductName -Name $Name
  $installedVersionInfo = Get-ToolInstalledVersionInfo -Name $Name
  $desiredVersionInfo = Get-ToolDesiredVersionInfo -Name $Name
  $missingFiles = @(Get-ToolMissingFiles -Name $Name)

  if ($null -ne $installedVersionInfo) {
    if (($null -ne $desiredVersionInfo) -and ($installedVersionInfo.Version -lt $desiredVersionInfo.Version)) {
      return "${productName}: $($installedVersionInfo.Text) -> $($desiredVersionInfo.Text) ($(Get-ToolManagedFilesText -Name $Name))"
    }

    if ($missingFiles.Count -gt 0) {
      return "${productName}: $($installedVersionInfo.Text) (missing: $($missingFiles -join ', '))"
    }

    return "${productName}: $($installedVersionInfo.Text)"
  }

  if ($missingFiles.Count -gt 0) {
    if ($null -ne $desiredVersionInfo) {
      return "${productName}: missing -> $($desiredVersionInfo.Text) ($(Get-ToolManagedFilesText -Name $Name))"
    }

    return "${productName}: missing"
  }

  return "${productName}: unknown"
}

function ConvertTo-VersionObject {
  param([string]$Text)

  if (-not $Text) { return $null }

  $match = [regex]::Match($Text, '\d+(?:\.\d+){1,3}')
  if (-not $match.Success) { return $null }

  try {
    return [version]$match.Value
  } catch {
    return $null
  }
}

function Get-ToolDesiredVersionInfo {
  param([string]$Name)

  $tool = Get-ToolDefinition -Name $Name
  if ($null -eq $tool) { return $null }

  $version = ConvertTo-VersionObject -Text $tool.DesiredVersion
  if ($null -eq $version) { return $null }

  return [pscustomobject]@{
    Text    = $tool.DesiredVersion
    Version = $version
  }
}

function Get-ToolInstalledVersionInfo {
  param([string]$Name)

  $tool = Get-ToolDefinition -Name $Name
  if ($null -eq $tool) { return $null }

  $primaryPath = Join-Path $binDir $tool.PrimaryFile
  if (-not (Test-Path $primaryPath)) { return $null }

  try {
    $versionInfo = (Get-Item $primaryPath).VersionInfo
    $fileVersion = ConvertTo-VersionObject -Text $versionInfo.FileVersion
    if ($null -ne $fileVersion) {
      return [pscustomobject]@{
        Text    = $versionInfo.FileVersion
        Version = $fileVersion
        Source  = 'file version'
      }
    }
  } catch {}

  if ($tool.ContainsKey('VersionCommand') -and $tool.ContainsKey('VersionPattern')) {
    try {
      $output = & $primaryPath @($tool.VersionCommand) 2>&1 | Out-String
      $match = [regex]::Match($output, $tool.VersionPattern)
      if ($match.Success) {
        $version = ConvertTo-VersionObject -Text $match.Groups[1].Value
        if ($null -ne $version) {
          return [pscustomobject]@{
            Text    = $match.Groups[1].Value
            Version = $version
            Source  = 'command output'
          }
        }
      }
    } catch {}
  }

  return $null
}

function Test-ToolFilesPresent {
  param([string]$Name)

  $expectedFiles = @(Get-ToolExpectedFiles -Name $Name)
  if ($expectedFiles.Count -eq 0) { return $false }

  return (@(Get-ToolMissingFiles -Name $Name).Count -eq 0)
}

function Install-ToolFromArchive {
  param(
    [string]$Name,
    [string]$ArchivePath
  )

  $zipBasename = [System.IO.Path]::GetFileName($ArchivePath)
  $temp = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())

  try {
    Expand-Archive -Path $ArchivePath -DestinationPath $temp -Force

    if ($Name -eq 'dxc') {
      # CONTRIBUTING: Expand-Archive dxc.zip -> dxc_temp; Copy-Item dxc_temp\bin\x64\* .\bin -Force
      $src = Join-Path $temp 'bin\x64\*'
      try {
        Copy-Item -Path $src -Destination $binDir -Force -ErrorAction Stop
      } catch {
        Write-Warn "Could not copy dxc bin/x64 contents: $($_.Exception.Message)"
        return $false
      }
    } elseif ($Name -eq 'slang') {
      # CONTRIBUTING: Expand-Archive slang.zip -> slang_temp; Copy-Item slang_temp\bin\* .\bin -Force
      $src = Join-Path $temp 'bin\*'
      try {
        Copy-Item -Path $src -Destination $binDir -Force -ErrorAction Stop
      } catch {
        Write-Warn "Could not copy slang bin contents: $($_.Exception.Message)"
        return $false
      }
    } else {
      # Generic fallback: copy discovered .exe files into bin (best-effort locations)
      Get-ChildItem -Path $temp -Recurse -Filter '*.exe' -ErrorAction SilentlyContinue | ForEach-Object {
        $dest = Join-Path $binDir $_.Name
        Copy-Item -Path $_.FullName -Destination $dest -Force
      }
      # Also look for packages that place binaries under 'bin' or 'bin/x64'
      Get-ChildItem -Path $temp -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'bin' } | ForEach-Object {
        Get-ChildItem -Path $_.FullName -Recurse -Filter '*.exe' -ErrorAction SilentlyContinue | ForEach-Object {
          $dest = Join-Path $binDir $_.Name
          Copy-Item -Path $_.FullName -Destination $dest -Force
        }
      }
    }

    # Special-case 3Dmigoto decompiler: copy only cmd_Decompiler.exe
    if ($Name -eq '3dmigoto') {
      try {
        $exeSrc = Get-ChildItem -Path $temp -Recurse -Filter 'cmd_Decompiler.exe' -ErrorAction Stop | Select-Object -First 1
        if ($null -ne $exeSrc) {
          Copy-Item -Path $exeSrc.FullName -Destination (Join-Path $binDir 'cmd_Decompiler.exe') -Force -ErrorAction Stop
        } else {
          Write-Warn "cmd_Decompiler.exe not found in archive for 3dmigoto"
          return $false
        }
      } catch {
        Write-Warn "Failed to copy cmd_Decompiler.exe: $($_.Exception.Message)"
        return $false
      }
    }

    return $true
  } catch {
    Write-Warn "Failed to extract ${zipBasename}: $($_.Exception.Message)"
    return $false
  } finally {
    if (Test-Path $temp) {
      Remove-Item -Path $temp -Recurse -Force -ErrorAction SilentlyContinue
    }
  }
}

function Install-Tools {
  $actionCount = 0

  # Tools to ensure in bin.
  foreach ($name in @('dxc', 'slang', '3dmigoto')) {
    $tool = Get-ToolDefinition -Name $name
    if ($null -eq $tool) { continue }

    $missingFiles = @(Get-ToolMissingFiles -Name $name)
    $hasExpectedFiles = ($missingFiles.Count -eq 0)
    $primaryPath = Join-Path $binDir $tool.PrimaryFile
    $installedVersionInfo = Get-ToolInstalledVersionInfo -Name $name
    $desiredVersionInfo = Get-ToolDesiredVersionInfo -Name $name
    $needsInstall = -not $hasExpectedFiles
    $actionReason = $null

    if ($hasExpectedFiles) {
      if (($null -ne $installedVersionInfo) -and ($null -ne $desiredVersionInfo)) {
        $comparison = $installedVersionInfo.Version.CompareTo($desiredVersionInfo.Version)
        if ($comparison -gt 0) {
          continue
        }
        if ($comparison -eq 0) {
          continue
        }

        $needsInstall = $true
        $actionReason = "installed version $($installedVersionInfo.Text) is older than configured $($desiredVersionInfo.Text)"
      } else {
        Write-Warn "Could not determine installed version for tool '$name'; leaving existing files in place to avoid downgrading."
        continue
      }
    } else {
      if ($missingFiles.Count -gt 0) {
        $actionReason = "missing files: $($missingFiles -join ', ')"
      }

      if ((Test-Path $primaryPath) -and ($null -eq $installedVersionInfo)) {
        Write-Warn "Tool '$name' is missing files, but the installed version could not be determined from $primaryPath. Skipping install to avoid downgrading an unknown local version."
        continue
      }

      if (($null -ne $installedVersionInfo) -and ($null -ne $desiredVersionInfo)) {
        $comparison = $installedVersionInfo.Version.CompareTo($desiredVersionInfo.Version)
        if ($comparison -gt 0) {
          Write-Warn "Tool '$name' is missing files ($($missingFiles -join ', ')), but installed version $($installedVersionInfo.Text) is newer than configured $($desiredVersionInfo.Text). Skipping install to avoid downgrading."
          continue
        }
        if ($comparison -lt 0) {
          $actionReason = "installed version $($installedVersionInfo.Text) is older than configured $($desiredVersionInfo.Text); missing files: $($missingFiles -join ', ')"
        }
      }
    }

    if (-not $needsInstall) {
      continue
    }

    $actionDetails = Get-ToolActionDetails -Name $name -InstalledVersionInfo $installedVersionInfo -DesiredVersionInfo $desiredVersionInfo -MissingFiles $missingFiles
    $actionCount += 1

    if ($isDryRun) {
      continue
    }

    try {
      $downloadInfo = Get-ToolDownloadInfo -Name $name
    } catch {
      Write-Warn "Could not resolve download information for tool '$name': $($_.Exception.Message)"
      continue
    }

    # Preserve the downloaded ZIP basename (versioned) while keeping a logical tool name for branching.
    # Download into the OS temp folder first; only move the ZIP into ./bin on successful processing.
    $zipBasename = $downloadInfo.ArchiveName
    $tempDownload = Join-Path $env:TEMP $zipBasename
    $finalTarget = Join-Path $binDir $zipBasename
    $hasCachedArchive = Test-Path $finalTarget
    $needsDownload = -not $hasCachedArchive

    $archivePath = $finalTarget
    $downloadedNow = $false

    $progressVerb = if ($actionDetails.Verb -eq 'update') { 'Updating' } else { 'Installing' }
    Write-Info "$progressVerb $($actionDetails.Summary)"

    if ($needsDownload) {
      try {
        Invoke-WebRequest -Uri $downloadInfo.Url -OutFile $tempDownload -UseBasicParsing -ErrorAction Stop
        $archivePath = $tempDownload
        $downloadedNow = $true
      } catch {
        Write-Warn "Failed to download ${zipBasename}: $($_.Exception.Message)"
        continue
      }
    }

    $installSucceeded = $true
    if ($needsInstall) {
      $installSucceeded = Install-ToolFromArchive -Name $name -ArchivePath $archivePath
    }

    if ($downloadedNow) {
      if ($installSucceeded) {
        try {
          Move-Item -Path $tempDownload -Destination $finalTarget -Force
        } catch {
          Write-Warn "Could not move ${zipBasename} into ${binDir}: $($_.Exception.Message)"
        }
      } elseif (Test-Path $tempDownload) {
        try {
          Remove-Item -Path $tempDownload -Force -ErrorAction SilentlyContinue
        } catch {}
      }
    }
  }

  return $actionCount
}

function Test-WindowsSdk {
  # Returns $true if SDK appears installed or was handled, $false otherwise
  # Use helper module function if available
  function Get-WindowsSdkInstalled {
    if (Get-Command Get-WindowsSdkPath -ErrorAction SilentlyContinue) {
      $path = Get-WindowsSdkPath
      return ([bool]$path)
    }
    $sdkKey = 'HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots'
    if (Test-Path $sdkKey) { return $true }
    return $false
  }

  function Get-FxcFromSdkCandidate {
    if (Get-Command Get-WindowsSdkLatestBinPath -ErrorAction SilentlyContinue) {
      $versionedBin = Get-WindowsSdkLatestBinPath
      if ($versionedBin) {
        $candidate = Join-Path $versionedBin 'x64\fxc.exe'
        if (-not (Test-Path $candidate)) { $candidate = Join-Path $versionedBin 'x86\fxc.exe' }
        if (Test-Path $candidate) { return $candidate }
      }
    }

    if (Get-Command Get-WindowsSdkPath -ErrorAction SilentlyContinue) { $kitsRoot10 = Get-WindowsSdkPath } else { $props = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Kits\Installed Roots' -ErrorAction SilentlyContinue; $kitsRoot10 = $props.KitsRoot10 }
    if (-not $kitsRoot10) { return $null }
    $binRoot = Join-Path $kitsRoot10 'bin'
    if (-not (Test-Path $binRoot)) { return $null }

    $versions = Get-ChildItem -Path $binRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '^[0-9]' } | Sort-Object Name -Descending
    foreach ($v in $versions) {
      $candidate = Join-Path $v.FullName 'x64\fxc.exe'
      if (-not (Test-Path $candidate)) { $candidate = Join-Path $v.FullName 'x86\fxc.exe' }
      if (Test-Path $candidate) { return $candidate }
    }
    return $null
  }

  function Copy-FxcFromSdk {
    param(
      [string]$Destination,
      [bool]$DryRun = $true
    )

    $candidate = Get-FxcFromSdkCandidate
    if (-not $candidate) { return $false }

    if ($DryRun) {
      return $true
    }

    try {
      Copy-Item -Path $candidate -Destination (Join-Path $Destination 'fxc.exe') -Force -ErrorAction Stop
      return $true
    } catch {
      Write-Warn "Failed to copy fxc.exe from ${candidate}: $($_.Exception.Message)"
      return $false
    }
  }

  if (Get-WindowsSdkInstalled) {
    if (-not (Test-Path (Join-Path $binDir 'fxc.exe'))) {
      if (-not (Copy-FxcFromSdk -Destination $binDir -DryRun:$isDryRun)) {
        Write-Warn 'fxc.exe could not be found in the Windows SDK.'
      }
    }
    return $true
  } else {
    if ($isDryRun) { return $false }
    Write-Warn 'Windows SDK not found.'
    if ($Install) { Install-WindowsSdk -DryRun:$isDryRun; return $false } else { Write-Warn 'Windows SDK installation is only attempted with -Install.'; return $false }
  }
}

function Install-WindowsSdk {
  param(
    [bool]$DryRun = $true
  )

  if ($DryRun) { Write-Info 'Would attempt to install Windows SDK via winget (dry-run).' ; return }

  # Attempt to install via winget
  if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Info 'Attempting to install Windows SDK via winget...'
    try {
      winget install --id Microsoft.WindowsSDK -e --silent
      Write-Info 'winget install returned. Verify installation or re-run this script.'
    } catch {
      Write-Warn "winget install failed: $($_.Exception.Message)"
    }
  } else {
    Write-Warn 'winget not available. Please install the Windows SDK manually or enable winget.'
  }
}

### Script root: minimal orchestration
# Install or report tools
# Install or report tools
Import-HelperModule
Initialize-BinDir
# Ensure Windows SDK / fxc.exe (needed early for fxc.exe copy)
[void](Test-WindowsSdk)

function Get-MissingCoreToolFiles {
  param(
    [string[]]$Required = @('dxc.exe', 'dxcompiler.dll', 'slangc.exe', 'cmd_Decompiler.exe', 'fxc.exe')
  )

  $missing = @()
  foreach ($exe in $Required) {
    if (-not (Test-Path (Join-Path $binDir $exe))) { $missing += $exe }
  }

  return $missing
}

$toolActionCount = Install-Tools
$missingCoreFiles = @(Get-MissingCoreToolFiles)
$setupComplete = ($missingCoreFiles.Count -eq 0)
$sdkVersion = Get-WindowsSdkVersionText
$needsFxcCopy = ($missingCoreFiles -contains 'fxc.exe')

if ($isDryRun) {
  if ($toolActionCount -gt 0) {
    $toolChangeLabel = if ($toolActionCount -eq 1) { '1 managed tool change is available.' } else { "$toolActionCount managed tool changes are available." }
    if ($needsFxcCopy) {
      Write-Info "Preview mode. $toolChangeLabel fxc.exe also needs to be copied into ${binDir}."
    } elseif (-not $sdkVersion) {
      Write-Info "Preview mode. $toolChangeLabel Windows SDK is also missing."
    } else {
      Write-Info "Preview mode. $toolChangeLabel"
    }
  } elseif ($needsFxcCopy) {
    Write-Info "Preview mode. Managed tools already match the configured versions; fxc.exe still needs to be copied into ${binDir}."
  } elseif (-not $sdkVersion) {
    Write-Info "Preview mode. Managed tools already match the configured versions; Windows SDK is missing."
  } else {
    Write-Info "Preview mode. Managed tools already match the configured versions."
  }

  if ($sdkVersion) {
    if ($needsFxcCopy) {
      Write-Info "Windows SDK: $sdkVersion (fxc.exe not yet in ${binDir})"
    } else {
      Write-Info "Windows SDK: $sdkVersion"
    }
  } else {
    Write-Info "Windows SDK: missing"
  }

  foreach ($name in @('dxc', 'slang', '3dmigoto')) {
    Write-Info (Get-ToolStatusLine -Name $name)
  }

  if ($toolActionCount -gt 0 -and -not $sdkVersion) {
    Write-Info "Next: use -Update to apply the managed tool changes above, or -Install to also attempt Windows SDK installation."
  } elseif ($toolActionCount -gt 0 -and $needsFxcCopy) {
    Write-Info "Next: use -Update or -Install to apply the managed tool changes above and copy fxc.exe from the installed Windows SDK."
  } elseif ($toolActionCount -gt 0) {
    Write-Info "Next: use -Update to apply the managed tool changes above."
  } elseif (-not $sdkVersion) {
    Write-Info "Next: use -Install to attempt Windows SDK installation."
  } elseif ($needsFxcCopy) {
    Write-Info "Next: use -Update or -Install to copy fxc.exe from the installed Windows SDK into ${binDir}."
  } else {
    Write-Info "Next: no changes needed. Re-run with -Update after bumping tool versions, or use -Bin <path> to inspect another tool directory."
  }
} elseif ($setupComplete -and $toolActionCount -eq 0) {
  Write-Info "No tool file changes needed."
} elseif (-not $setupComplete -and -not $isDryRun) {
  Write-Warn "Missing core tool files in ${binDir}: $($missingCoreFiles -join ', ')"
  Write-Warn "Dev environment setup incomplete. The script could not provide all required files; review the warnings above for the failing tool or download step."
}
