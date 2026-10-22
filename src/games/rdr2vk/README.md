# Red Dead Redemption 2

Use Vulkan and **disable HDR in the game's settings**. When upgrading from the previous `rdr2vk`, **reset existing RenoDX presets**: tone mapper numbering and grading behavior have changed.

## Tonemapping

The mod replaces the SDR tone curve while the scene still contains HDR detail, carries that range through upgraded render textures, and encodes HDR10 only at the final output. It does not inverse-tonemap a completed SDR frame. Game exposure, bloom, vignette, grading masks, and LUT sampling remain in the processing chain.

The main scene variants use two hooks in `tonemap/tonemap.glsl`:

1. **`ApplyToneMap()`**, before the game's SDR encoding and LUTs, selects the original curve, its extension, or an anchor-scaled scene signal for PsychoV.
2. **`ApplyFinalToneMap()`**, after the game's LUTs and dithering, decodes the result, applies mode-specific display mapping and optional film grain, then writes sRGB-encoded BT.709 for subsequent game passes.

| Mode | Setup |
|---|---|
| **Vanilla / 0** | Keeps the original SDR curve and output clamp; bypasses custom final grading and grain. Output still uses the HDR10 proxy. |
| **Vanilla+ / 1** | Extends the original curve above its inflection point with a matching tangent. After LUT processing, applies anchored tonal grading, finite-clip C-infinity rolloff, then anchored saturation grading. |
| **PsychoV / 2** — default | Replaces the curve with an anchor-scaled scene signal, then decodes the game's sRGB-like encoding before applying a cuostomized version of PsychoV31. Input/output anchors and logarithmic contrast derive from the vanilla inflection value and slope. Baseline toe/contrast tuning approximates the vanilla gamma-2.2 display appearance with less shadow crush. |

Vanilla+ grading and rolloff share the linear BT.709 anchor `0.07207985`. Its saturation controls operate in Stockman/CVRL LMS and preserve physiological Yf; highlight detection uses the color before tonal grading. PsychoV handles those controls internally. Both custom modes target `Peak Brightness / Game Brightness` with a finite shoulder clip of `100` in their respective working domains; this is not a final-output hard cap after saturation and effects.

### LUTs and effects

- **LUT bridge (custom modes):** gamma-2.2 decode, max-channel C-infinity compression into SDR range, then re-encode for unchanged packed-LUT sampling and masks. The sampled result is decoded, inverse-scaled, blended by LUT Strength, and re-encoded; zero strength returns the pre-LUT color directly.
- **Weapon wheel:** compresses scene highlights before bounded tint/noise processing and restores their scale before the LUT bridge. This path uses nonnegative RGB.
- **Film grain:** regular BT.709 grain runs after custom display mapping, using normalized scene UVs.
- **Match Vanilla:** selects Vanilla+, resets grading, restores original dithering, and disables added grain. **Preset Off** instead selects Vanilla and restores the original lighting clamp. Both reset game/UI brightness and EOTF settings; Peak Brightness is retained.

## Scene and UI brightness

Let `G` be Game Brightness and `U` be UI Brightness. At the final scene write, `ScaleSceneBrightness()` decodes RGB, multiplies by **`G / U`**, and re-encodes without changing alpha. UI then draws normally. The final proxy decodes the composite, scales by **`U`**, and converts to BT.2020/PQ: unobscured scene pixels receive `(G / U) * U = G`, while UI white maps to `U` nits. The game's encoded-space alpha blending is unchanged.

The brightness helper and proxy use gamma 2.2 when SDR EOTF Emulation is enabled, otherwise sRGB. PsychoV forces that setting off; its earlier `DecodeRDR2Gamma()` is separate from output decoding. The helper preserves signed RGB and values above `1`, and bypasses offscreen writes or equal `G`/`U`.

`OnSceneDraw()` supplies `CUSTOM_IS_SWAPCHAIN_WRITE` using `HasBackBufferRenderTarget()`. Only the following scene shaders use it; arbitrary backbuffer writes are not sufficient proof because the game also reuses the backbuffer clone for temporary blur storage.

| Captured scenario | Scene normalization |
|---|---|
| Gameplay, Dead Eye, journal, map, cinematic camera, photo mode | Final blit `0x1FC46AC9` |
| Pause | Final blit `0x1FC46AC9`; earlier radial effects, blur, LUTs, and artwork stay unscaled |
| Weapon wheel, Eagle Eye, minimap-style chooser, satchel | `0x2B012EDD`, after effects/LUT restoration, only when writing the backbuffer clone |
| Main menu | Neither hook; background/video and UI follow UI Brightness |

Map artwork and offscreen UI textures remain UI-relative. These captures establish steady-state paths, not every transition or photo-mode variant. There is no frame-wide "already scaled" latch.

The scaling helper is in `output/brightness.glsl`; its callers are the scene blit and `tonemap/tm_pause_weapon_wheel_0x2B012EDD.frag.vk.glsl`. `shared.h` configures final output scaling. Its `RENODX_INTERMEDIATE_SCALING` macro does not run automatically in the thin proxy; the two scene hooks explicitly apply the ratio before `swap_chain_proxy_pixel_shader.frag.slang` calls `SwapChainPass()`.