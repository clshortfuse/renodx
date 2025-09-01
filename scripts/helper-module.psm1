# Return available game targets and recent initial matches from a games directory
function Get-GameTargets {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][string]$GamesDir,
    [int]$RecentCount = 5
  )
  if (-not (Test-Path $GamesDir)) { return $null }
  $gameItems = Get-ChildItem -Path $GamesDir -Directory | Sort-Object -Property LastWriteTime -Descending
  $initialMatches = @($gameItems | Select-Object -First $RecentCount | ForEach-Object { $_.Name })
  $targets = @($gameItems | ForEach-Object { $_.Name } | Sort-Object -Unique)
  return [PSCustomObject]@{ Targets = $targets; InitialMatches = $initialMatches }
}

# Interactive target picker
function Show-TargetPicker {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][string[]]$Targets,
    [Parameter(Mandatory = $true)][string[]]$InitialMatches,
    [Parameter(Mandatory = $true)][string]$RepoRoot,
    [Parameter(Mandatory = $true)][string]$BuildDir,
    [int]$MaxCount = 5
  )

  function Render-Filter {
    param($buffer, $targets, [int]$selectedIndex)
    Clear-Host
    Write-Host "Repository root: $RepoRoot"
    Write-Host "Build directory: $BuildDir`n"

    # Compute matches (case-insensitive)
    if ($buffer -eq "") {
      # show recent 5 folders first for quick selection, but still keep $targets as the master list
      $targetMatches = $InitialMatches
    } else {
      $targetMatches = $targets | Where-Object { $_.IndexOf($buffer, [StringComparison]::InvariantCultureIgnoreCase) -ge 0 }
    }

    # Ensure $targetMatches is always an array of strings even when a single string matches
    if ($targetMatches -is [System.String]) {
      # single string -> make single-element array without splitting into chars
      $targetMatches = , $targetMatches
    } else {
      # coerce to array (no-op if already array)
      $targetMatches = @($targetMatches)
    }


    if (-not $targetMatches -or $targetMatches.Count -eq 0) {
      Write-Host "(no matches)"
    } else {
      # clamp selected index
      if ($selectedIndex -lt 0) { $selectedIndex = 0 }
      if ($selectedIndex -ge $targetMatches.Count) { $selectedIndex = $targetMatches.Count - 1 }

      $limit = [Math]::Min($targetMatches.Count - 1, $MaxCount - 1)
      for ($i = 0; $i -le $limit; $i++) {
        $t = $targetMatches[$i]
        $isSelected = ($i -eq $selectedIndex)

        if ($buffer -and $buffer.Length -gt 0) {
          $ts = [string]$t
          $idx = $ts.IndexOf($buffer, [StringComparison]::InvariantCultureIgnoreCase)
          if ($idx -ge 0) {
            $prefix = $ts.Substring(0, $idx)
            $matchText = $ts.Substring($idx, $buffer.Length)
            $suffix = $ts.Substring($idx + $buffer.Length)

            # selected line: mark with '> ' and use background color
            if ($isSelected) {
              Write-Host -NoNewline "> " -ForegroundColor Yellow -BackgroundColor DarkBlue
              Write-Host -NoNewline $prefix -BackgroundColor DarkBlue -ForegroundColor White
              Write-Host -NoNewline $matchText -ForegroundColor Cyan -BackgroundColor DarkBlue
              Write-Host $suffix -BackgroundColor DarkBlue -ForegroundColor White
            } else {
              Write-Host -NoNewline "  "
              Write-Host -NoNewline $prefix
              Write-Host -NoNewline $matchText -ForegroundColor Cyan
              Write-Host $suffix
            }
            continue
          }
        }
        # fallback: print whole line normally, with selection marker if needed
        if ($isSelected) {
          Write-Host "> " -NoNewline -ForegroundColor Yellow -BackgroundColor DarkBlue
          Write-Host $t -BackgroundColor DarkBlue -ForegroundColor White
          continue;
        }

        # Unmatched line
        Write-Host "  $t"
        
      }
      if ($targetMatches.Count -gt $MaxCount) {
        Write-Host "... ($($targetMatches.Count) matches total)"
      }
    }

    Write-Host -NoNewline "`nFilter: $buffer"
    return $targetMatches
  }

  # Interactive loop: read keys and update filter
  $buffer = ""
  $selectedIndex = 0
  $targetMatches = Render-Filter $buffer $Targets $selectedIndex

  
  while ($true) {
    $key = [System.Console]::ReadKey($true)
    switch ($key.Key) {
      'Enter' {
        # if ($buffer -eq "") {
        #   Write-Host "No filter entered; cancelling." -ForegroundColor Yellow
        #   exit 0
        # }
        # Ensure $targetMatches is always an array of strings even when a single string matches
        if ($targetMatches -is [System.String]) {
          # single string -> make single-element array without splitting into chars
          $targetMatches = , $targetMatches
        } else {
          # coerce to array (no-op if already array)
          $targetMatches = @($targetMatches)
        }
        # choose top match and print it (do not build during prototype)
        if ($targetMatches -and $targetMatches.Count -gt 0 -and $selectedIndex -ge 0) {
          $chosen = [string]$targetMatches[$selectedIndex]
        } else {
          $chosen = $null
        }
        # Return chosen if not empty, else ignore enter press
        if ($chosen -and $chosen.Length -gt 0) {
          return $chosen
        }
      }
      'Escape' {
        return $null;
      }
      'UpArrow' {
        if ($targetMatches -and $targetMatches.Count -gt 0) {
          $selectedIndex = $selectedIndex - 1
          if ($selectedIndex -lt 0) { $selectedIndex = $targetMatches.Count - 1 }
        }
      }
      'DownArrow' {
        if ($targetMatches -and $targetMatches.Count -gt 0) {
          $selectedIndex = $selectedIndex + 1
          if ($selectedIndex -ge $targetMatches.Count) { $selectedIndex = 0 }
        }
      }
      'Backspace' {
        if ($buffer.Length -gt 0) { $buffer = $buffer.Substring(0, $buffer.Length - 1) }
      }
      default {
        # append printable chars only
        $c = $key.KeyChar
        if ($c -and ($c -match '\S')) { $buffer += $c }
      }
    }
    # reset selection to top when filter text changes; keep it otherwise
    if ($key.Key -in @('Backspace') -or ($key.KeyChar -and ($key.KeyChar -match '\S'))) {
      $selectedIndex = 0 
    }
    $targetMatches = Render-Filter $buffer $Targets $selectedIndex

  }
  return $null;
}

function Invoke-SetupVSDevEnv {
  
  $VsWherePath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"

  Write-Host "Setting up Visual Studio developer environment..." -ForegroundColor Cyan

  # Locate vswhere: prefer provided path, then PATH
  if (-not (Test-Path $VsWherePath)) {
    $cmdInfo = Get-Command vswhere.exe -ErrorAction SilentlyContinue
    if ($cmdInfo) { $VsWherePath = $cmdInfo.Source } else { $VsWherePath = 'vswhere.exe' }
  }
  Write-Host "Using vswhere at: $VsWherePath" -ForegroundColor DarkCyan

  # Run vswhere to find an installation with VC tools
  try {
    $inst = & $VsWherePath -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>$null | Select-Object -First 1
  } catch {
    $inst = $null
  }

  # Fallback: try common Program Files Visual Studio folders
  if (-not $inst -or $inst -eq '') {
    $candidates = Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft Visual Studio\*" -Directory -ErrorAction SilentlyContinue | Sort-Object Name -Descending
    if ($candidates -and $candidates.Count -gt 0) { $inst = $candidates[0].FullName }
  }

  if (-not $inst -or $inst -eq '') {
    Write-Host "No Visual Studio installation found (vswhere + fallback failed)." -ForegroundColor Yellow
    return $false
  }

  Write-Host "Found Visual Studio installation: $inst" -ForegroundColor Green

  # Prefer VsDevCmd, fallback to vcvars64
  $vsDevCmd = Join-Path $inst 'Common7\Tools\VsDevCmd.bat'
  if (-not (Test-Path $vsDevCmd)) {
    $vcvars = Join-Path $inst 'VC\Auxiliary\Build\vcvars64.bat'
    if (Test-Path $vcvars) { $vsDevCmd = $vcvars } else { Write-Host "VsDevCmd/vcvars not found in install." -ForegroundColor Yellow; return $false }
  }

  Write-Host "Running developer batch: $vsDevCmd" -ForegroundColor DarkCyan

  # Run the batch in cmd and then 'set' to dump environment; capture the output
  $cmd = "`"$vsDevCmd`" -arch=amd64 -host_arch=amd64 && set"
  try {
    $raw = & cmd /c $cmd 2>&1
  } catch {
    Write-Host "Failed to execute developer batch: $_" -ForegroundColor Red
    return $false
  }

  if (-not $raw -or $raw.Count -eq 0) {
    Write-Host "Developer batch produced no output." -ForegroundColor Yellow
    return $false
  }

  # Parse NAME=VALUE lines and import into current env
  $capturedPath = $null
  foreach ($line in $raw) {
    if ($line -and $line -match '^(.*?)=(.*)$') {
      $name = $matches[1]
      $value = $matches[2]
      if ($name -eq 'PATH') { $capturedPath = $value; continue }
      try { Set-Item -Path ("env:" + $name) -Value $value -ErrorAction SilentlyContinue } catch { }
    }
  }

  if ($capturedPath) { $env:PATH = "$capturedPath;$env:PATH" }

  # Verify tool availability
  if (Get-Command cl.exe -ErrorAction SilentlyContinue) { Write-Host "MSVC toolchain found on PATH." -ForegroundColor Green; return $true }
  if (Get-Command clang-cl.exe -ErrorAction SilentlyContinue) { Write-Host "clang-cl found on PATH." -ForegroundColor Green; return $true }

  Write-Host "Developer tools not detected after setup." -ForegroundColor Yellow
  return $false
}

function Invoke-BuildTarget {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][string]$TargetName
  )

  Write-Host "Invoking build: cmake --build --preset clang-x64-release --target $TargetName" -ForegroundColor Green
  try {
    # Stream stdout/stderr live while collecting lines for a tail on error
    $lines = [System.Collections.Generic.List[string]]::new()
    & cmake --build --preset clang-x64-release --target "$TargetName" 2>&1 | ForEach-Object { $lines.Add($_); Write-Host $_ }
    $code = $LASTEXITCODE
    if ($code -ne 0) {
      Write-Error "cmake exited with code $code"
      Write-Host "`n--- Build log tail (last 200 lines) ---`n"
      $lines | Select-Object -Last 200 | ForEach-Object { Write-Host $_ }
    }
    return $code
  } catch {
    Write-Error "Failed to run cmake build for target '$TargetName': $_"
    return 1
  }
}

# Send a file (and optional content/embeds) to a Discord webhook.
function Invoke-DiscordWebhookFile {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][string]$WebhookUrl,
    [Parameter(Mandatory = $true)][string]$FilePath,
    [string]$Content = '',
    [object[]]$Embeds = @(),
    [string]$Username = $null,
    [string]$AvatarUrl = $null,
    [object[]]$MentionedUsers = @(),
    [switch]$Wait
  )

  if (-not (Test-Path $FilePath)) { Write-Error "File not found: $FilePath"; return 1 }

  # prepare payload_json and attachments[] per Discord API: attachments refer to files[n] by id
  $filename = [System.IO.Path]::GetFileName($FilePath)
  # sanitize filename to ASCII alphanumeric, underscores, dashes, dots
  $safeFilename = ($filename -replace '[^A-Za-z0-9_.-]', '_')

  $payload = @{}
  if ($Content) { $payload.content = $Content }
  if ($Embeds -and $Embeds.Count -gt 0) { $payload.embeds = $Embeds }
  if ($Username) { $payload.username = $Username }
  if ($AvatarUrl) { $payload.avatar_url = $AvatarUrl }
  if ($MentionedUsers -and $MentionedUsers.Count -gt 0) {
    $payload.allowed_mentions = @{ users = $MentionedUsers }
  }

  # attachments array: id must match files[n] index
  $payload.attachments = @(@{ id = 0; filename = $safeFilename })

  # avoid ambiguous variable expansion (PowerShell may parse $WebhookUrl? as a variable name)
  $uri = if ($Wait) { "${WebhookUrl}?wait=true" } else { $WebhookUrl }
  $json = ConvertTo-Json $payload -Depth 10

  try {
    $boundary = [System.Guid]::NewGuid().ToString()
    $LF = "`r`n"
    $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
    $fileContent = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetString($fileBytes)

    $bodyBuilder = New-Object System.Text.StringBuilder

    # payload_json part
    $bodyBuilder.Append("--$boundary$LF") | Out-Null
    $bodyBuilder.Append('Content-Disposition: form-data; name="payload_json"' + $LF) | Out-Null
    $bodyBuilder.Append('Content-Type: application/json' + $LF + $LF) | Out-Null
    $bodyBuilder.Append($json + $LF) | Out-Null

    # file part
    $bodyBuilder.Append("--$boundary$LF") | Out-Null
    $bodyBuilder.Append("Content-Disposition: form-data; name=`"files[0]`"; filename=`"$safeFilename`"$LF") | Out-Null
    $bodyBuilder.Append("Content-Type: application/octet-stream$LF$LF") | Out-Null
    $bodyBuilder.Append($fileContent + $LF) | Out-Null

    # end boundary
    $bodyBuilder.Append("--$boundary--$LF") | Out-Null

    $bodyBytes = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($bodyBuilder.ToString())

    $headers = @{
      "User-Agent"   = "renodx-webhook"
      "Content-Type" = "multipart/form-data; boundary=$boundary"
    }

    Write-Host "Uploading to webhook..." -ForegroundColor DarkCyan

    if ($PSVersionTable.PSVersion.Major -ge 7) {
      $response = Invoke-WebRequest -Uri $uri -Method Post -Headers $headers -Body $bodyBytes -UseBasicParsing -SkipHttpErrorCheck
    } else {
      Write-Warning "PowerShell 7 or greater is recommended for optimal webhook upload compatibility."
      $response = Invoke-WebRequest -Uri $uri -Method Post -Headers $headers -Body $bodyBytes -UseBasicParsing
    }
    
    if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300) {
      return 0
    } else {
      Write-Host "Webhook POST failed with HTTP code $($response.StatusCode)" -ForegroundColor Red
      Write-Host $response.Content -ForegroundColor Red
      return 1
    }
  } catch {
    Write-Error "Failed to send webhook via Invoke-WebRequest: $_"
    return 1
  }
  
}



Export-ModuleMember -Function Invoke-SetupVSDevEnv, Invoke-BuildTarget, Get-GameTargets, Show-TargetPicker, Invoke-DiscordWebhookFile
