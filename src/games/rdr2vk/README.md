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

Close RDR2 before building target **`rdr2vk`** with VS Code's CMake integration and the selected toolchain and configuration. Release output is `build/Release/renodx-rdr2vk.addon64`; other configurations use their corresponding output directory. The addon uses the repository's existing build rules and shared code; no game-specific CMake changes or local test files are required.

The optional crash recorder is controlled by **`RDR2VK_ENABLE_LIFETIME_DIAGNOSTICS`** in `diagnostics_config.hpp`. It accepts only `0` or `1` and defaults to **`0`**. At zero, the compiler leaves out the recorder's history, locks, call stacks, exception observer, failure scans, extra Vulkan hooks, and file writes. The rendering code and ordinary failure messages remain. Set it to `1` and rebuild only when investigating a problem; a compiler definition can override the default.

Diagnostics are **observation only**. Both builds forward original native calls and results, including repeated destruction requests. There is no duplicate-destroy blocker. Enabled builds write version-5 traces beside the game executable; see [Architecture](ARCHITECTURE.md#diagnostics-observe-without-repairing).

## Status and checks still required

**The crash after prolonged play remains unresolved.** The current fixes do not establish its cause. Both recorder settings compile with the existing MSVC Release configuration. The recorder defaults to off; its report text is absent from the normal addon and present in the recorder-enabled addon. Compilation and local checks are not proof of correct pixels or crash-free gameplay.

- Compare unequal and equal Game/UI Brightness in gameplay, FXAA on/off, weapon wheel, pause/map, menus/videos, and HUD-hidden play. Load a save before revealing the HUD; check each slider independently and watch transparency, masks, and highlights.
- Exercise Alt-Tab, minimize/restore, resolution and window-mode changes, VSync/Reflex/buffering changes, loading/fades, and exit/relaunch. Confirm both brightness controls still work after output recreation.
- Check prolonged play, memory trends, and `ReShade.log`, first without DevKit/ReShade effects and then with the usual overlays. Diagnostic timing differs from the normal build. A successful build or small test does not establish crash-free gameplay.

For the CPU/GPU model, ownership, brightness ordering, lifecycle, known limits, and old-to-new function map, read [Architecture](ARCHITECTURE.md).

## Compatibility report under investigation

The direct R11G11B10F-to-RGBA16F scene upgrade is intentionally enabled only on NVIDIA. The RGBA16F copy used for drawing to the backbuffer and the final HDR10 conversion are separate parts of the mod. An unchanged R11G11B10F texture alone does not prove SDR clipping, because that format can already store values above SDR white.

One user reported missing HDR range and a Game Brightness control that did not work on an **AMD Radeon RX 7700S with the Epic Games Store edition**, even though the grading controls worked. Their later trace includes an older addon build, DevKit loaded first, and OptiScaler confirmed by the user. HDR10 output selection works in that trace, but the resource data is insufficient to prove that scene detail reaches the final output without clipping. A separate NVIDIA/Epic success report weakens a storefront-only explanation; the different GPU, driver, addon build, settings, and OptiScaler configuration have not been tested separately. Neither AMD nor OptiScaler is established as the cause.

To compare affected and unaffected systems, record the exact addon, game, ReShade, driver, and OptiScaler versions; the storefront; anti-aliasing and render settings; addon load order; and whether Windows HDR and native game HDR are on. Change one factor at a time and include a log and resource capture with this addon loaded. Do not remove the NVIDIA restriction or claim a compatibility fix from these reports alone.

## Changes in this update

- Restore the tracked Vulkan pipeline bindings as well as the other drawing state after the pre-UI brightness pass.
- Prevent pending submission data from restoring scene-source handles that resource destruction has already removed.
- Create and check final-output samplers during setup, before publishing output state. Existing render-pass cleanup owns successful samplers, so no shared renderer change is needed.
- Let the optional recorder capture access violations during active native view creation or destruction, including invalid jumps outside the driver module. Observation never suppresses the original call or handles the exception.