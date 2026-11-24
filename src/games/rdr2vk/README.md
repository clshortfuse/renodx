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

## Build

Close RDR2 before building target **`rdr2vk`**. Release output is `build/Release/renodx-rdr2vk.addon64`. No game-specific CMake changes are needed.

To investigate a crash, load the separate **`rdr2vkprobe`** add-on beside the mod or with ReShade alone; see its [README](../../addons/rdr2vkprobe/README.md). The mod itself contains no recording code.

For how the mod works inside, read [Architecture](ARCHITECTURE.md).

## Status

**Crash after prolonged play.** The mod leaked memory every frame. At each present it asked ReShade for the swapchain's images; ReShade answers with `vkGetSwapchainImagesKHR`, and the Steam overlay's Vulkan layer creates a semaphore on every such call and never destroys it. Process memory and Windows kernel memory grew until the game exited. The mod no longer asks, and in a loaded save both now stay level. That this leak caused the crash is likely but not proven: the crash was recorded on NVIDIA driver 621.01 and did not reproduce on 621.14 even with the leak present. The crash's last step is confirmed: once the driver refuses to create a buffer view, the game reuses an old handle, destroys it a second time, and the driver crashes.

Still to check in the game:

- Unequal and equal Game/UI Brightness in gameplay, FXAA on/off, weapon wheel, pause/map, menus/videos, and HUD-hidden play. Load a save before revealing the HUD; check each slider on its own and watch transparency, masks, and highlights.
- Alt-Tab, minimize/restore, resolution and window-mode changes, VSync/Reflex/buffering changes, loading/fades, and exit/relaunch. Both brightness controls must still work after the output is recreated.
- Prolonged play with the usual overlays and effects, watching memory and `ReShade.log`.

## Compatibility report under investigation

The direct R11G11B10F-to-RGBA16F scene upgrade is intentionally enabled only on NVIDIA. The RGBA16F copy used for drawing to the backbuffer and the final HDR10 conversion are separate parts of the mod. An unchanged R11G11B10F texture alone does not prove SDR clipping, because that format can already store values above SDR white.

One user reported missing HDR range and a Game Brightness control that did not work on an **AMD Radeon RX 7700S with the Epic Games Store edition**, even though the grading controls worked. Their later trace includes an older addon build, DevKit loaded first, and OptiScaler confirmed by the user. HDR10 output selection works in that trace, but the resource data is insufficient to prove that scene detail reaches the final output without clipping. A separate NVIDIA/Epic success report weakens a storefront-only explanation; the different GPU, driver, addon build, settings, and OptiScaler configuration have not been tested separately. Neither AMD nor OptiScaler is established as the cause.

To compare affected and unaffected systems, record the exact addon, game, ReShade, driver, and OptiScaler versions; the storefront; anti-aliasing and render settings; addon load order; and whether Windows HDR and native game HDR are on. Change one factor at a time and include a log and resource capture with this addon loaded. Do not remove the NVIDIA restriction or claim a compatibility fix from these reports alone.

## Changes in this update

- Fix the per-frame memory leak described under Status. The final output pass now draws to the backbuffer recorded when the swapchain was set up.
- Move the crash recorder out of the mod into the `rdr2vkprobe` add-on. The mod no longer has a recorder switch.