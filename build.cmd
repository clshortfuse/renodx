cmake --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -SC:/Mods/renodx -Bc:/Mods/renodx/build -G "Visual Studio 17 2022" -T host=x86 -A x64
cmake --build build --config Release --target clean -j 18
cmake --build build --config Release --target ALL_BUILD -j 18
