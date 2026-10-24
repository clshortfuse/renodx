# Dragon Age: The Veilguard

Frostbite (2024), D3D12, Steam app `1845910`, `Dragon Age The Veilguard.exe`.

The game outputs HDR10 natively: with in-game HDR on, the swapchain is `r10g10b10a2_unorm` and the final pass writes BT.2020 PQ. The mod replaces only that final pass (`0x4564BB42`, `ps_5_0`). It needs no swapchain or resource upgrade.

## How it works

The final pass composites the UI layer over the graded scene in linear light, applies Frostbite's display-mapping LUT (t9), and PQ-encodes with a ±1/127 dither.

| Tone Mapper | Behavior |
|---|---|
| Vanilla | The original path, including the display-mapping LUT, accessibility and watermark blocks. |
| None, ACES, RenoDRT | Tone maps the graded scene to Peak Brightness with Game Brightness as paper white, then composites the UI at UI Brightness. |

The default Tone Mapper is ACES (Peak Brightness 1000, Game Brightness 105), which tone maps to the display peak with more contrast; **Preset Off restores Vanilla**. On a gray ramp, ACES maps 0.18 to the same 18.9 nits as Vanilla, but 0.01 to 0.11 nits (Vanilla 1.12) and 1.0 to 162 nits (Vanilla 104): deeper shadows and brighter highlights, so dark scenes lose median brightness (Minrathous at night, screenshots with the defaults: median 3.3 nits against 6.3 for RenoDRT and 6.1 for Vanilla, black floor p1 0.004 against 0.18). **RenoDRT** keeps the original look instead: with Gamma Correction Off, measured midtones and shadows match the original (median 6.5 nits against 6.1 for Vanilla, same scene, HDR on) while highlights follow Peak Brightness.

Settings are injected as `b13` in space 0 (`shared.h`). `addon.cpp` sets `expected_constant_buffer_index = 13` because the shader is SM5.0 DXBC; with the default index RenoDX would inject at the first free slot of each root signature and the shader would read zeros. The game's root signatures already have root constants, hence `allow_multiple_push_constants`.

Keep **Gamma Correction** on Off: the scene is already linear HDR, so 2.2 darkens midtones and shadows.

## Shader variants

The game has several variants of the final output pass (`ps_5_0`). The mod replaces the four that write HDR10 PQ. The Render Scale slider decides whether the scene is read directly (100%) or resampled (below 100%), and DLSS Frame Generation decides whether the pass has one render target or two:

| Hash | When | Scene input |
|---|---|---|
| `0x4564BB42` | Render scale 100% (DLSS, FSR, XeSS and no upscaler, seen in the main menu) | `r11g11b10_float`, read directly |
| `0x3998EA61` | Render scale below 100% (seen with DLSS Ultra Performance at 66%) | `r10g10b10a2` with packed half-float bits, resampled with a 4x4 Lanczos filter |
| `0x23DC66B2` | Render scale 100% with DLSS Frame Generation on | `r11g11b10_float`, read directly; two render targets, final image with the UI and the same image without it |
| `0x22E9F0A5` | Render scale below 100% with DLSS Frame Generation on (seen at 66% and 88%) | Same as `0x3998EA61`, with two render targets: the final image with the UI, and the same image without the UI (the HUD-less buffer frame generation reads). Both go through the mod's tone mapping |

All share the same tail (`common.hlsli`): UI composite, accessibility, display-mapping LUT, BT.2020 PQ and dither. Left untouched: the SDR variants (HDR off; `0x4E55D462` seen in the main menu) and three scRGB variants (`0xA0D84CD4`, `0xAA75CF5D`, `0xD45D81E7`) that were not drawn in any case tested. Seen in a DevKit snapshot of the main menu only; gameplay, photo mode, cinematics and pre-rendered video were not traced. With HDR off or an scRGB swapchain the game stays vanilla.

## Observed pipeline (main menu, HDR on)

| Draw | PS | RTV | Role |
|---|---|---|---|
| 1274 | `0x1600E7FD` | `r11g11b10_float` | Scene post and grading: bloom, post-exposure, vignette, grading LUT, film grain. No clamp. |
| 1280–1288 | `0x405625E7`, `0x681D932B`, `0xBD61BD66` | UI layer `r8g8b8a8_unorm_srgb` | UI, premultiplied alpha. |
| 1291 | `0x4564BB42` | `r10g10b10a2_unorm` | Final output: scene + UI, display mapping, BT.2020 PQ, dither. Replaced by this mod. |
| 1292 | — | swapchain | Present copy. |

The scene is HDR before this pass (peaks near 181 linear in the menu). Vanilla display mapping is near-linear at about 100 nits per unit and rolls off above roughly 3000 nits.

## Build

```powershell
cmake --preset clang-x64
cmake --build --preset clang-x64-debug --target dragonage_veilguard
```

Output: `build/Debug/renodx-dragonage_veilguard.addon64`. Copy it next to ReShade (with add-on support) in the game folder.

## Manual verification

- [ ] `ReShade.log` loads `RenoDX` and shows `cbvIndex:13` in `OnInitPipelineLayout`.
- [ ] Tone Mapper "Vanilla" matches a vanilla screenshot of the same scene.
- [ ] None, ACES and RenoDRT change the image; Peak Brightness moves the highlight peak.
- [ ] With Gamma Correction Off, RenoDRT keeps vanilla midtones and shadows.
- [ ] HUD, subtitles and the ability wheel follow UI Brightness independently of Game Brightness.
- [ ] Pre-rendered video and in-engine cinematics: no clipping.
- [ ] DLSS, FSR, XeSS and TAA each use the replaced pass.
- [ ] The mod works without the DevKit addon loaded.
