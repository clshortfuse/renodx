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

## PsychoV35 and PrismTM

The Tone Mapper setting provides `PsychoV35` (internal ID 30, replacing PsychoV30) and `PrismTM` (31). The saved selection index, `PsychoV30*` setting keys and injected field layout are retained for profile compatibility. `Gears4ToneMapPass` in `common.hlsl` is the single entry point for all LUT builder paths, including `lutbuilders/legacy.hlsl` and `lutbuilder_0xCBCF8905`.

PsychoV35's default Gamut Target is BT.709. Existing profiles retain their saved selection; reset Gamut Target to use the new default, or select BT.709 explicitly.

Both mappers receive the linear graded signal. PsychoV35's ceiling is expressed in the inverse of the later gamma correction so Peak Brightness remains the display target after `RenderIntermediatePass`. A 4000-nit setting provides a 4000-nit ceiling; individual lights still depend on the scene signal and shoulder rolloff. Prism retains its prior peak behavior.

The existing FP16 generated LUT and legacy shoulder extension preserve scene highlights before display mapping. There is no additional highlight gain or completed-frame inverse tonemap. The original bounded grading LUT remains behind the existing HDR grade reconstruction.

Exposure, Highlights, Shadows, Contrast and Saturation apply once before either mapper. Highlight Saturation and Blowout apply after it. Hue Processor, Flare and White Clip remain RenoDRT-only. PsychoV35 exposes Purity, Cone Response, Gamut Compression, Gamut Target and Compression in Intermediate and Advanced settings modes. `prismTM.hlsl` carries the MIT-licensed Prism source and curve.

PsychoV35 receives a nonnegative reconstructed input. An invalid output triplet is replaced with a finite hue-preserving shoulder before the LUT write; a bad LUT cell can otherwise affect many interpolated pixels. This guard is local to Gears 4 and does not change the shared PsychoV implementation.

PsychoV35 receives the legacy path's linear signal after the game color matrix and shadow tint, before the original toe/shoulder. The vanilla curve is retained as the SDR grading reference instead of being extended and then fed through a second display curve. Other mapper modes retain their existing legacy shoulder extension. PsychoV35's own Compression control keeps its original meaning. Its output bypasses the later BT.709 max-channel peak clamp, because valid BT.2020 highlights can exceed that channel bound in the BT.709 representation. Prism retains its existing guard. The selected scene peak and gamma compensation remain in effect.

Live verification on 2026-11-20: the active `0x81222343` LUT builder compiled as SM5.1 and ran with PsychoV35 at a 4000-nit target. The user initially confirmed bright lights looked good and flicker remained absent, then found black blobs. Restoring the prior builder removed them, and the guarded PsychoV35 builder also removed them in the user's test. FP16 output readbacks contained 8,294,400 finite pixels and no NaNs or infinities; live output statistics alone did not detect the reported artifact. These were live frames, not frozen before/after comparisons or measurements that a particular light reached 4000 nits.

Manual checks: after closing the game, build target `gearsofwar4` with `clang-x64-debug`, install `build/Debug/renodx-gearsofwar4.addon64`, and restart without the fixed live-preview wrapper. Select PsychoV35 and Peak Brightness 4000. Compare midtones, bright saturated lights, bloom, fades and UI; test both the current LUT builder and legacy-builder scenes, plus gamma correction Off/2.2/2.4 and the PsychoV35 controls.

## Gears 4 generated LUT input range

The three native Gears 4 LUT builders are `0x299FEA93` (no grading LUT), `0x81222343` (one grading LUT), and `0x4053C583` (two grading LUTs). All use `ExpandGearsLutCoordinates` from `lut_domain.hlsl`. The matching scene lookup shader is `0xB8F11F10`; it applies the inverse mapping before the original 32-cube centering and trilinear sample. The separate bounded grading LUT textures and their blending remain unchanged.

The native log domain ends at a scene input of about 43.708. For custom tone mappers, a quadratic continuation expands that endpoint to 65504. It retains the original first 21 nodes of the 32-cube, joins with unit slope at node 20, and only reallocates the highlight nodes. Vanilla uses the original mapping at both ends. This changes the represented input range rather than multiplying scene brightness or stretching the completed frame.

Both builders and lookup shader must be embedded and installed together. Loading only expanded builders into an older addon gives mismatched coordinates; use the rebuilt addon and restart.

Validation: all four shaders compile as SM5.0 and SM5.1. A float32 simulation over 200,001 coordinates verifies monotonicity and inverse round trips within one float ULP, preserves nodes 0 through 20, and reaches the new endpoint. After rebuilding, verify all three builder variants across levels, strong grading transitions, saturated emissive colors, bloom and fades. Confirm the previous 2541-nit plateau is removed when the scene supplies brighter input; 4000 remains a display ceiling rather than a forced value for every light.

## Final output transport

After the LUT extension was installed, a capture at approximately 3800-nit peak reached 3.787109375 in the gamma-2.2 intermediate (3799.91 nits at 203-nit white), while the final scRGB resource peaked at 33.75 (2700 nits). The final limit persisted with Lilium analysis disabled. The remaining loss is downstream of the generated LUT, not its input-domain endpoint.

For HDR mapper modes, the swapchain proxy uses a 10000-nit transport bound instead of applying the selected scene peak a second time. PsychoV35 still owns the requested display peak in `Gears4ToneMapPass`; the proxy only decodes, scales and encodes the already-mapped signal. This change is local to the proxy shader and does not increase scene exposure or highlight gain.

Vanilla mode restores the original UNORM scene-write clamp in `0xB8F11F10`. The final proxy also bounds the encoded composite to SDR and limits output to the configured graphics white (203 nits by default). This keeps Vanilla in SDR range while retaining the current HDR-capable swapchain; other mapper modes keep their HDR range.

Both lookup and proxy variants compile. Final in-game verification requires rebuilding and installing the addon, restarting, and comparing the intermediate and final maxima again. Check Vanilla with a high Peak Brightness setting: it should remain bounded by SDR white; then switch to PsychoV35 and confirm the HDR highlight range returns.
