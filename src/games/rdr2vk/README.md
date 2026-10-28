# Red Dead Redemption 2

This mod preserves scene HDR detail through the game's effects and produces HDR10 output, with separate Game Brightness and UI Brightness controls. It does not stretch a finished SDR frame into HDR.

## Quick start

1. Select **Vulkan** in RDR2.
2. Turn **Windows HDR on** and **the game's native HDR off**.
3. Set Peak Brightness for your display, then adjust Game Brightness and UI Brightness separately.
4. If upgrading from an older version with different tone mapper numbers, reset saved RenoDX presets so old values do not select the wrong mode.

| Tone mapper | Purpose |
|---|---|
| Vanilla / 0 | Original SDR curve and lighting limit, carried through HDR10 output. |
| Vanilla+ / 1 | Original darker tones with a smooth HDR highlight extension. |
| PsychoV / 2 — default | Customized PsychoV31, using the original curve as its brightness and contrast reference. |

The game's exposure, bloom, color lookup tables, and grading masks remain in use. Match Vanilla selects Vanilla+, resets grading, restores dithering, and disables added grain. Preset Off selects Vanilla and restores the original lighting limit. Both reset Game/UI Brightness and SDR EOTF Emulation; neither changes Peak Brightness.

## Build and diagnostics

Close RDR2 before building target **`rdr2vk`** with VS Code's CMake integration and the **currently selected toolchain and configuration**. Do not change presets for this rewrite or rebuild a loaded addon. With the current build directory, Release output is `build/Release/renodx-rdr2vk.addon64`; other configurations use their corresponding output directory.

The single switch is **`RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS`** in `diagnostics_config.hpp`. It accepts only `0` or `1` and defaults to **`0`**. At zero, optional histories, locks, stack capture, exception observation, failure scans, native diagnostic hooks, trace writes, and their argument preparation are compiled out. Required rendering hooks and ordinary failure messages remain. Set it to `1` and rebuild only for an investigation; a compiler definition can override the default.

Diagnostics are **observation only**. Both builds forward original native calls and results, including repeated destruction requests. There is no duplicate-destroy blocker. Enabled builds write version-5 traces beside the game executable; see [Architecture](ARCHITECTURE.md#diagnostics-observe-without-repairing).

## Status and checks still required

**The prolonged-play allocation crash remains unresolved.** The architecture rewrite and diagnostics-off build are not a crash fix. Both modes compile with the existing MSVC Release configuration. Local checks cover resource/layout policies, legacy LOAD cache behavior, private-data layout, selection rules, nested submission scopes, and observation-only forwarding through controlled fake originals. Both builds also passed isolated installed-ReShade Vulkan smoke tests with 100 legal buffer-view lifetimes each. The normal build produced no trace and contains no optional diagnostic markers or exception/stack-capture imports. These are not full-game rendering or stability tests.

- Compare unequal and equal Game/UI Brightness in gameplay, FXAA on/off, weapon wheel, pause/map, menus/videos, and HUD-hidden play. Load a save before revealing the HUD; check each slider independently and watch transparency, masks, and highlights.
- Exercise Alt-Tab, minimize/restore, resolution and window-mode changes, VSync/Reflex/buffering changes, loading/fades, and exit/relaunch. Confirm both brightness controls still work after output recreation.
- Check prolonged play, memory trends, and `ReShade.log`, first without DevKit/ReShade effects and then with the usual overlays. Diagnostic timing differs from the normal build. A successful build or small test does not establish crash-free gameplay.

For the CPU/GPU model, ownership, brightness ordering, lifecycle, known limits, and old-to-new function map, read [Architecture](ARCHITECTURE.md).