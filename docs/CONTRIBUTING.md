### Getting Started

RenoDX is an engine for modifying DirectX games. Recommended configuration:

* [VSCode](https://code.visualstudio.com/) - Recommended IDE
* [vs_buildTools.exe](https://aka.ms/vs/17/release/vs_BuildTools.exe) - MSVC 2022 Build Tools
* [cmake](https://cmake.org/download/) - Build System
* [llvm](https://github.com/llvm/llvm-project/releases/) - Used for linting and formatting
* [ninja](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages) - For faster building
* [dxc.exe](https://github.com/microsoft/DirectXShaderCompiler/releases) - Compiles Shader Model 6.0+
* [fxc.exe](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/) - Compiles Shader Model 3.0 - 5.x
* [cmd_decompiler.exe](https://github.com/bo3b/3Dmigoto/releases/tag/1.3.16) - Decompiles upto Shader Model 5.0 to HLSL
* [dxil-spirv.exe](https://github.com/HansKristian-Work/dxil-spirv) - Converts Shader Model 6.0 to SPIR-V
* [spirv-cross.exe](https://github.com/KhronosGroup/SPIRV-Cross) - Converts SPIR-V to HLSL

RenoDX uses the Reshade Addon API meaning [Reshade](https://reshade.me/) is a **core requirement** for RenoDX.

## Initial steps

Clone the repository 

* `git clone git@github.com:clshortfuse/renodx.git`

Update the submodules

* `git submodule update --init --recursive`

Configure project to use compile to the `./build` directory.

* `cmake -B build -S . -G "Visual Studio 17 2022" -T host=x86 -A x64`

Build the project

* `cmake --build build --config Release --target ALL_BUILD -j 18`

----------------

*Note: for 32bit binaries use:*

* `cmake -B build32 -S . -G "Visual Studio 17 2022" -T host=x86 -A Win32`
* `cmake --build build32 --config Release --target ALL_BUILD -j 18`


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

To simplify creating a new mod, the `src/games/template` exists to be copied to start work on a new mod.
