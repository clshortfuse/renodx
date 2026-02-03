# Indiana Jones and the Great Circle
## How to build
1. Install VulkanSDK `1.4.313.0` to `C:\VulkanSDK\1.4.313.0\`.
2. Run this cmd from `src\games\indygreatcircle` to generate the `.spv` files from the `.glsl` files:
   ```cmd
   @echo off
   setlocal EnableDelayedExpansion

   REM Path to glslangValidator from Vulkan SDK
   set "GLSLANG=C:\VulkanSDK\1.4.313.0\Bin\glslangValidator.exe"

   REM Target output subdirectory
   set "TARGET_DIR=compiled"

   REM Ensure the target directory exists
   if not exist "%TARGET_DIR%" (
       mkdir "%TARGET_DIR%"
   )

   REM Look for all .glsl files in the current folder
   for %%F in (*.glsl) do (
       set "BASE=%%~nF"
       set "OUT_NAME=!BASE!"
       if not "!BASE:0x=!"=="!BASE!" set "OUT_NAME=!BASE:*0x=0x!"
       echo Compiling %%F
       "%GLSLANG%" -V --target-env vulkan1.3 -o "%TARGET_DIR%\!OUT_NAME!.spv" "%%F"
       if errorlevel 1 (
           echo Failed to compile %%F
       ) else (
           echo Output: "%TARGET_DIR%\!OUT_NAME!.spv"
       )
   )
   ```
3. Run CMake build as usual.
