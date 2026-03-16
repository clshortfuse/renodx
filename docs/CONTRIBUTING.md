### Getting Started

RenoDX is an engine for modifying DirectX games. Recommended configuration:

* [VSCode](https://code.visualstudio.com/) - Recommended IDE
* [vs_buildTools.exe](https://aka.ms/vs/17/release/vs_BuildTools.exe) - MSVC 2022 Build Tools
* [cmake](https://cmake.org/download/) - Build System
* [llvm](https://github.com/llvm/llvm-project/releases/) - Used for compiling, linting and formatting
* [ninja](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages) - For faster building
* [Windows SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/) - Used to build addons and compile HLSL. Minimum supported version: `10.0.26100.0`
* [DirectXShaderCompiler](https://github.com/microsoft/DirectXShaderCompiler/releases/) - Provides `dxc.exe` and `dxcompiler.dll` for Shader Model 6.x compilation, decompilation, and devkit tooling. `dxil.dll` may also be present depending on the DXC release.
* [cmd_decompiler.exe](https://github.com/bo3b/3Dmigoto/releases/tag/1.3.16) - Decompiles upto Shader Model 5.0 to HLSL
* [slangc.exe](https://github.com/shader-slang/slang/releases) - Compiles .slang files for DXBC, DXIL, and SPIR-V



RenoDX uses the Reshade Addon API meaning [Reshade](https://reshade.me/) is a **core requirement** for RenoDX.

## Setup (CLI)

[Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) or [fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) the repository:

* `git clone https://github.com/clshortfuse/renodx.git`

Bootstrap helper binaries from the repo root. The recommended path is the setup script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1 -Update
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1 -Install
powershell -ExecutionPolicy Bypass -File .\scripts\setup-dev-env.ps1 -Bin .\bin -Install
```

- The default invocation is a preview. It does not change files. Instead it reports the Windows SDK version it found and the current versus configured versions for the managed toolchain components.
- `-Install` creates `.\bin` when needed, applies managed tool installs or updates, attempts Windows SDK installation when the SDK is missing, and copies `fxc.exe` into `.\bin` when the SDK is already installed.
- Use `-Bin` when running the script outside the repo root. The default `bin` path is relative to the current working directory, not the script directory.
- `-Update` re-runs the same version-aware checks and applies managed tool installs or updates without attempting Windows SDK installation. If the SDK is already installed, it can still copy `fxc.exe` into `.\bin`.
- The script will not downgrade a newer local managed tool install. It updates only when the configured package is newer than the installed one. It does not currently force-refresh same-version cached tool archives.
- When you use the in-game devkit overlay or MCP workflow, point `devkit_set_tools_path` at this same `.\bin` directory if the game ships conflicting `dxcompiler.dll` or `dxil.dll` files.

Manual tool setup is still supported if you prefer to manage `.\bin` yourself.

* `mkdir bin`
* `curl -L -o dxc.zip https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.9.2602/dxc_2026_02_20.zip`
* `curl -L -o slang.zip https://github.com/shader-slang/slang/releases/download/v2025.16.1/slang-2025.16.1-windows-x86_64.zip`
* `curl -L -o cmd_Decompiler-1.3.16.zip https://github.com/bo3b/3Dmigoto/releases/download/1.3.16/cmd_Decompiler-1.3.16.zip`
* `powershell -Command "Expand-Archive -Path dxc.zip -DestinationPath dxc_temp -Force; Copy-Item dxc_temp\bin\x64\* .\bin -Force; Remove-Item dxc_temp -Recurse -Force"`
* `powershell -Command "Expand-Archive -Path slang.zip -DestinationPath slang_temp -Force; Copy-Item slang_temp\bin\* .\bin -Force; Remove-Item slang_temp -Recurse -Force"`
* `powershell -Command "Expand-Archive -Path cmd_Decompiler-1.3.16.zip -DestinationPath 3dmigoto_temp -Force; Copy-Item (Get-ChildItem 3dmigoto_temp -Recurse -Filter cmd_Decompiler.exe | Select-Object -First 1).FullName .\bin\cmd_Decompiler.exe -Force; Remove-Item 3dmigoto_temp -Recurse -Force"`
* `del dxc.zip`
* `del slang.zip`
* `del cmd_Decompiler-1.3.16.zip`

Install the Windows SDK if it is not already present. The setup script will attempt this automatically when run with `-Install`, or you can do it manually:

* `winget install --id Microsoft.WindowsSDK -e --silent`

Use Windows SDK `10.0.26100.0` or newer. `fxc.exe` comes from the Windows SDK. CMake can find it in the SDK install path, and the setup script will also copy it into `.\bin` when it can. The DXC package should provide `dxc.exe` together with `dxcompiler.dll`; some DXC releases also ship `dxil.dll`, which is fine to keep alongside them in `.\bin`, especially for devkit/MCP workflows. `slangc.exe` and `cmd_Decompiler.exe` are also expected there unless you have an equivalent toolchain arrangement of your own.

Update the submodules

* `git submodule update --init --recursive`

Configure the project

* `cmake --preset clang-x64`

Build the project

* `cmake --build --preset clang-x64-release`

Build the live inspection tooling

* `cmake --build --preset clang-x64-debug --target devkit`

----------------

*Note: for 32bit binaries use:*

* `cmake --preset clang-x86`
* `cmake --build --preset clang-x86-release --target generic`

----------------

*Note: for MSVC use:*

* `cmake --preset ninja-x64`
* `cmake --build --preset ninja-x64-release --target generic`

----------------

*Note: for Visual Studio use:*

* `cmake --preset vs-x64`
* `cmake --build --preset vs-x64-release --target generic`

### Automated configuration

Every folder inside `src/games/` is considered a game mod. The `CMakeList.txt` file will perform the following steps:

* Search for `C:/Program Files (x86)/Windows Kits/10` for locations of `fxc.exe` and `dxc.exe`
* Search `src/games/**/*.hlsl` for shader HLSL files that have following format `{CRC32}.{TARGET}.hlsl` (`.`):
  * shader CRC32 in hex formatted as `0xC0DEC0DE`
  * shader target including `{TYPE}_{MAJOR}_{MINOR}` (eg: `ps_6_6`)
  * the `hlsl` extension
* Associate each shader file with an output `embed/{CRC32}.h`
* Search for `src/games/**/addon.cpp` and associate a target based on the folder name with the output being `renodx-{target}.addon64` (or `.addon32` if targetted Win32)
* Add `src/devkit/addon.cpp` as a target.


### Building a mod

To simplify creating a new mod, the `src/games/generic` exists to be copied to start work on a new mod.
