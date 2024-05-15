cmake --build build --config Release --target ALL_BUILD -j 18

add shader:
"C:/Program Files (x86)/Windows Kits/10/bin/10.0.22621.0/x64/fxc.exe" "C:/Users/Musa/Documents/Programming Projects/renodx/src/games/fallout76/0x3C8AF2C9.hlsl" -T ps_5_0 /Gec /O3 /Qstrip_reflect -E main -Fo "C:/Users/Musa/Documents/Programming Projects/renodx/build/embed/0x3C8AF2C9.cso"
cd build
"C:\Users\Musa\Documents\Programming Projects\renodx\build\Release\embedfile.exe" "C:/Users/Musa/Documents/Programming Projects/renodx/build/embed/0x3C8AF2C9.cso" 0x3C8AF2C9
cd ..

rename shader:
cmake -S . -B build -G "Visual Studio 17 2022" -T host=x86 -A x64
