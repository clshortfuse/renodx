param(
    [Parameter(Mandatory)][ValidateSet('x86', 'x64')][string]$Arch,
    [Parameter(Mandatory)][string]$ReShadeLoader
)
$ErrorActionPreference = 'Stop'
# Run in a matching Visual Studio developer PowerShell, after building the addon.
# The harness writes profiles and logs only in this isolated build subdirectory.
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../../..')).Path
$buildName = if ($Arch -eq 'x86') { 'build32' } else { 'build' }
$suffix = if ($Arch -eq 'x86') { '32' } else { '64' }
$testDirectory = Join-Path $repoRoot "$buildName/generic-opengl-smoke"
New-Item -ItemType Directory -Force $testDirectory | Out-Null
Copy-Item -LiteralPath (Join-Path $repoRoot "$buildName/Debug/renodx-generic_opengl.addon$suffix") -Destination $testDirectory
Copy-Item -LiteralPath $ReShadeLoader -Destination (Join-Path $testDirectory 'opengl32.dll')
Push-Location $testDirectory
try {
    & cl /nologo /std:c++20 /EHsc /MD /Fe:smoke.exe /Fo:smoke.obj (Join-Path $PSScriptRoot 'smoke.cpp') /link user32.lib gdi32.lib opengl32.lib
    if ($LASTEXITCODE -ne 0) { throw 'Smoke program compilation failed' }
    foreach ($mode in @('replace', 'clamp', 'capture', 'hdr', 'nohooks', 'parameters-local', 'parameters-env')) {
        $hook = if ($mode -eq 'nohooks') { 0 } else { 1 }
        "[INSTALL]`nHookDirectX=$hook" | Set-Content ReShade.ini
        & .\smoke.exe $mode *> "$mode.log"
        $testExit = $LASTEXITCODE
        Get-Content "$mode.log"
        Copy-Item ReShade.log "$mode-reshade.log"
        if ($testExit -ne 0) { throw "$Arch $mode failed ($testExit). See $testDirectory" }
        if ($mode -eq 'nohooks' -and !(Select-String -Quiet -Path ReShade.log -Pattern 'HDR proxy disabled:')) {
            throw 'Missing DirectX hook guard did not report disabling HDR'
        }
    }
} finally {
    Pop-Location
}
