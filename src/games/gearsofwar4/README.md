# Gears of War 4: reload-bar HDR clamp

The reload-bar flare is drawn by pixel shader `0x6AB99DA7` after the scene's tonemap pass, directly into the FP16 swapchain clone. It samples textures reflected as `WarfareHUD_main` and `HUD_Passover`. The main HUD shader `0xAEABF0A0` already bounds its output; the separate flare material did not.

`0x6AB99DA7.ps_5_0.hlsl` retains the original material, texture sampling, fog/debug logic, opacity and output signatures. It saturates the final material RGBA before assigning SV_Target0 and calculating SV_Target2, retaining the original 0.782608688 secondary-output multiplier. This restores the SDR UI range before HDR composition. The scene tonemapper, LUT and brightness controls are unchanged.

Verification on 2026-11-02:

- FXC Shader Model 5.0 compilation passed.
- DevKit confirmed the replacement compiled and was active for `0x6AB99DA7`.
- The user reproduced the reload animation and confirmed: "Fixed now".
- A post-change 3840x2160 FP16 composite readback contained only finite values. Scene RGB elsewhere still exceeded 1, so the UI clamp did not collapse the frame to SDR range.
- Live captures were taken during changing gameplay; no frozen-frame equivalence or measured 10,000-nit before/after reduction is claimed.

## Live deployment

The Microsoft Store process exposes its DevKit pipe in its AppContainer namespace. The session connected using the full observed pipe path under `\\.\pipe\Sessions\4\AppContainerNamedObjects\...\renodx-devkit-mcp-13600`. The process ID and namespace must be rediscovered after restart.

This process could not read the repository tools path. The shader was compiled locally and live-loaded as HLSL from the accessible folder:

`C:/ReshadeUWP/renodx-dev/gears4-ui-fix/live`

That live directory contains only the edited hash shader. Original bytecode and captures stay in its parent investigation directory. The previous empty ToolsPath setting was restored. The authoritative source is this game folder's hash-named HLSL.

## Embedding and manual checks

The existing addon uses `__ALL_CUSTOM_SHADERS`, so the new hash shader enters its generated shader table when CMake rediscovers and builds the target. After closing the game, rebuild target `gearsofwar4` with the existing Clang configuration. Inspect `build/gearsofwar4.include/embed/0x6AB99DA7.h` and the generated shader index. This session did not rebuild or replace the loaded addon DLL.

After installing the rebuilt addon and restarting, check normal reload, active-reload success/failure, the flare crossing the timing window, weapon switching, and UI Brightness. Confirm normal scene highlights and fades are retained. The captured material was a post-scene HUD draw; other unobserved material variants need separate verification if a different UI effect flashes.

## PsychoV30 and PrismTM

The Tone Mapper setting adds `PsychoV30` (internal ID 30) and `PrismTM` (31). The saved Vanilla and RenoDRT selections are unchanged. `Gears4ToneMapPass` in `common.hlsl` is the single entry point for all LUT builder paths, including `lutbuilders/legacy.hlsl` and `lutbuilder_0xCBCF8905`.

Both mappers receive the linear graded signal and the true Peak Brightness relative to Game Brightness. Gamma correction stays after the tone map, in `RenderIntermediatePass`. Unlike RenoDRT, the peak is not compensated for that later correction, so with Gamma Correction at 2.2 the top of the range lands below the slider: 1000 becomes about 928 nits and 3500 about 2998 nits.

Exposure, Highlights, Shadows, Contrast and Saturation apply once before either mapper. Highlight Saturation and Blowout apply after it. Hue Processor, Flare and White Clip remain RenoDRT-only. `PsychoV30` also adds Purity, Cone Response, Gamut Compression, Gamut Target and Compression, shown in Intermediate and Advanced settings modes. `prismTM.hlsl` carries the MIT-licensed Prism source and curve.

Manual checks: build target `gearsofwar4`, restart the game, select each mapper in Intermediate settings mode, and move each PsychoV30 slider. Compare midtones, bright saturated lights and the top of the range against RenoDRT. Test both the current LUT builder and any legacy-builder scene.
