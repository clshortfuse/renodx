### Getting Started

RenoDX is an engine for modifying DirectX games. Recommended configuration:

* [VSCode](https://code.visualstudio.com/) - Recommended IDE
* [vs_buildTools.exe](https://aka.ms/vs/17/release/vs_BuildTools.exe) - MSVC 2022 Build Tools
* [cmake](https://cmake.org/download/) - Build System
* [llvm](https://github.com/llvm/llvm-project/releases/) - Used for compiling, linting and formatting
* [ninja](https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages) - For faster building
* [Windows SDK](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/) - Used to build addons and compile HLSL
* [cmd_decompiler.exe](https://github.com/bo3b/3Dmigoto/releases/tag/1.3.16) - Decompiles upto Shader Model 5.0 to HLSL
* [dxil-spirv.exe](https://github.com/HansKristian-Work/dxil-spirv) - Converts Shader Model 6.0 to SPIR-V
* [spirv-cross.exe](https://github.com/KhronosGroup/SPIRV-Cross) - Converts SPIR-V to HLSL
* [DirectXShaderCompiler](https://github.com/microsoft/DirectXShaderCompiler/releases/) - Used to decompile and compile Shader Module 6.x shaders

RenoDX uses the Reshade Addon API meaning [Reshade](https://reshade.me/) is a **core requirement** for RenoDX.

## Initial steps

Clone the repository 

* `git clone git@github.com:clshortfuse/renodx.git`

Update the submodules

* `git submodule update --init --recursive`

Configure the project

* `cmake --preset clang-x64`

Build the project

* `cmake --build --preset clang-x64-release`

----------------

*Note: for 32bit binaries use:*

* `cmake --preset clang-x86`
* `cmake --build --preset clang-x86-release`

----------------

*Note: for MSVC use:*

* `cmake --preset ninja-x64`
* `cmake --build --preset ninja-x64-release`

----------------

*Note: for Visual Studio use:*

* `cmake --preset vs-x64`
* `cmake --build --preset vs-x64-release`


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
