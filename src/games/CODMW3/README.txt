MW3 x64 - SDR-color HDR bloom (2026-09-19)

Bloom extraction uses the native SDR tint calculation, with HDR brightness
applied as one scalar. Glow and selected particles preserve HDR RGB while
alpha remains bounded. Recognized screen blends become additive during the
selected draw, with native draw hooks restoring the original state afterward.
No bloom on_drawn callback or draw replay is used.

The revised x64 version was confirmed to reach the menu by the user.
Image quality and behavior across all levels remain to be checked.

The six unreferenced legacy headers/helpers were backed up and removed.
Active output shaders, readback/proxy shaders, performance hooks, and shared
helpers remain. Removing uncompiled headers does not change runtime behavior.
Build the CODMW3 target using the existing clang-x64-release preset.
