# Red Dead Redemption 2 (Vulkan)

## Requirements

- Vulkan renderer
- Exclusive Fullscreen
- HDR enabled in Windows and in game
- 64-bit ReShade with addon support

## Tone-mapper defaults

The default **RenoDX (Enhanced)** tone mapper is anchored to RDR2's original tone-curve inflection while using perceptual highlight compression and slightly raised shadows. This is intentional: the more conservative **RenoDX (Vanilla+)** mode with 2.2 EOTF emulation more closely preserves the original look, but can appear excessively crushed.

Use **Preset Off** for the native game path or **Purist** for the Vanilla+ presentation.

## Compiling the shaders

RDR2's Vulkan shaders use the custom SPIR-V entry point `VkMain` instead of `main`. The repository's normal shader build does not compile these GLSL sources, so the committed `.spv` files must be regenerated with the included script before building the addon.

1. Install Vulkan SDK `1.4.313.0` to `C:\VulkanSDK\1.4.313.0\`.
2. Run `compileglsl.cmd` from `src\games\rdr2vk`.
3. Build the `rdr2vk` CMake target normally.

The script finds each immediate subfolder containing `.glsl` files, compiles shader files whose names contain a shader hash, and writes each generated module to that source folder's `compiled` subfolder. Shared include files without a shader hash are reported as skipped.

The script invokes `glslangValidator.exe` with:

```text
-V --target-env vulkan1.3 --source-entrypoint main -e VkMain
```

`--source-entrypoint main` selects the GLSL source function, while `-e VkMain` writes Rockstar's required entry-point name into the generated SPIR-V module.

Full script:

```cmd
@echo off
setlocal EnableDelayedExpansion

set "GLSLANG=C:\VulkanSDK\1.4.313.0\Bin\glslangValidator.exe"

if not exist "%GLSLANG%" (
    echo ERROR: glslangValidator.exe was not found at:
    echo   %GLSLANG%
    echo Install Vulkan SDK 1.4.313.0 or update GLSLANG in this script.
    exit /b 1
)

pushd "%~dp0"

set /A "FOLDER_COUNT=0, COMPILED_COUNT=0, SKIPPED_COUNT=0, FAILED_COUNT=0"

echo Compiling RDR2 Vulkan shaders with SPIR-V entry point VkMain...
echo.

REM Compile every immediate subfolder containing GLSL shaders. Generated SPIR-V
REM is written to a compiled subfolder beside the corresponding shader sources.
for /D %%D in (*) do (
    if exist "%%D\*.glsl" (
        set /A "FOLDER_COUNT+=1"
        set /A "FOLDER_COMPILED=0, FOLDER_SKIPPED=0, FOLDER_FAILED=0"

        echo === %%D ===
        echo Output: %%D\compiled

        if not exist "%%D\compiled" mkdir "%%D\compiled"

        pushd "%%D"
        for %%F in (*.glsl) do (
            echo %%~nF | %SystemRoot%\System32\findstr.exe /R /I "0x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]" >nul
            if errorlevel 1 (
                echo   SKIP    %%F ^(no shader hash in filename^)
                set /A "SKIPPED_COUNT+=1, FOLDER_SKIPPED+=1"
            ) else (
                set "BASE=%%~nF"
                set "OUT_NAME=!BASE:*0x=0x!"
                echo   COMPILE %%F
                "%GLSLANG%" -V --target-env vulkan1.3 --source-entrypoint main -e VkMain -o "compiled\!OUT_NAME!.spv" "%%F"
                if errorlevel 1 (
                    echo   FAILED  %%F
                    set /A "FAILED_COUNT+=1, FOLDER_FAILED+=1"
                ) else (
                    echo   OK      compiled\!OUT_NAME!.spv
                    set /A "COMPILED_COUNT+=1, FOLDER_COMPILED+=1"
                )
            )
        )
        popd

        echo Folder summary: !FOLDER_COMPILED! compiled, !FOLDER_SKIPPED! skipped, !FOLDER_FAILED! failed
        echo.
    )
)

echo === Shader compilation summary ===
echo Folders:  !FOLDER_COUNT!
echo Compiled: !COMPILED_COUNT!
echo Skipped:  !SKIPPED_COUNT!
echo Failed:   !FAILED_COUNT!

popd

if !FAILED_COUNT! GTR 0 exit /b 1
exit /b 0
```