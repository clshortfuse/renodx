# Gears of War 4 — UE Extended migration

This project replaces the previous Unreal Engine/PsychoV30 addon base with UE Extended from marat569/renodx, pinned to commit `377ce8a59d6371b29c5ccfe9f0157af2536408bf`.

Upstream: https://github.com/marat569/renodx/tree/377ce8a59d6371b29c5ccfe9f0157af2536408bf/src/games/ue-extended

## Installation

1. Close Gears of War 4.
2. Back up the addon currently installed with the game.
3. Replace that addon with `renodx-gearsofwar4.addon64`, using the same ReShade installation and addon location as your working mod. Load only one RenoDX addon for the game.
4. Start the game and open the RenoDX settings. The title is `RenoDX - Gears of War 4 (UE Extended)`.
5. Start with `UE Filmic Extended (HDR)` and set Peak Brightness for your display. The default Upgrade Path is On, for upgrading the game's SDR rendering to HDR. Keep the same working Windows HDR/ReShade setup you used previously.

Settings are stored under `renodx-gearsofwar4-ue-extended` and its preset sections. Old `renodx` settings are not imported because their tone-mapper values mean different things. The old PsychoV30 option is retained in the source backup, not in this UE Extended build.

## Changes

- Imported UE Extended's addon, shared shader constants, filmic tone mapping, LUT processing, output/composite shaders, and swap-chain proxies.
- The three Gears shaders live in `lutbuilder/sm5/lutbuilder_0x*.ps_5_x.hlsl`, include `../lutbuilderoutput.hlsli`, and follow the neighboring UE Extended shaders: `CreateCbufferConfig()`, explicit field assignments, LUT-weight arrays where needed, `ProcessLutbuilder`, then an early return. `common.hlsli` is included through the shared LUT pipeline. There is no Gears wrapper.
- Ported the three supplied Gears LUT builders: `0x299FEA93` (no external LUT), `0x81222343` (one external LUT), and `0x4053C583` (two external LUTs).
- Mapped Gears' film slope/toe/shoulder/black clip/white clip, LUT weights, mapping polynomial, color scale, and overlay into UE Extended's configuration.
- Converted the pre-tone-map BT.709 color to AP1 explicitly. The preceding old hook called that value AP1 even though the subsequent shader matrix converts BT.709 to AP0.
- The shared UE Extended pipeline now handles both tone-mapper selections. Original Gears shader instructions remain after the early return as a reference. Removed custom brightness-validity gating and two-LUT startup/black-probe discards from the active path to match the other UE Extended LUT builders. This changes startup and SDR-selection behavior and needs in-game verification.
- Fixed the imported single-LUT sampling helper to use the supplied game sampler rather than the null sampler in the default LUT configuration.
- Added four upstream Psycho22 color helper functions privately in `lutbuilder/ue_extended_compat.hlsli`; the local RenoDX library lacks these functions. No shared RenoDX source files were changed.
- Removed an upstream duplicate addon-unregister call.

The complete generic UE Extended shader collection is included. Its other-game shader filtering remains intact. Features such as grain, sharpening, and UI hiding depend on a matching output/composite shader and are not guaranteed to work in Gears merely because their controls appear.

## Validation and limits

Built as a 64-bit Release addon against the existing local RenoDX checkout, including shader-model 5.0 and 5.1 versions of all three Gears shaders. Build warnings remain in upstream code (deprecated interfaces and shader potential-initialization warnings).

The targeted UE Extended cbuffer/LUT-weight checker passes for all three shaders. This has not been tested inside Gears of War 4. The reported crushed blacks are not confirmed fixed; removing the custom black-probe discard only removes one nonstandard behavior. Check the opening menus, gameplay, cutscenes, HUD brightness, dark transitions, and HDR highlights before treating it as a release. Compare the same scene with the original mod. Additional shader captures or resource-upgrade settings may be needed if a game pass is missing or highlights clip. No game installation or ReShade configuration was modified by this migration.

## Source and rollback

The source archive is an overlay for the existing RenoDX repository, not a standalone copy of the entire repository. Its `src/games/gearsofwar4` directory replaces the previous directory. Do not merge old proxy shaders or `shared.h` into the new directory.

The backup archive contains the original nine source files exactly as they were before migration. To roll back the project, replace `src/games/gearsofwar4` with that backup and rebuild. For immediate in-game rollback, restore the installed addon backup made before installation.

Build from a Visual Studio x64 developer shell in the RenoDX root:

```
cmake --build build --config Release --target gearsofwar4 -j 8
```

This machine's CMake build cache was updated to use Visual Studio's bundled Ninja because the previously configured WinGet Ninja was inaccessible. The compiler and CMake source configuration were unchanged.
