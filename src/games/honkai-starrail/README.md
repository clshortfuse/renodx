# Honkai: Star Rail

RenoDX mod for Honkai: Star Rail (DirectX 11, miHoYo Unity fork). The game has no
native HDR output, so the mod upgrades its SDR path.

## Render path

Captured with the RenoDX DevKit on an R8G8B8A8_UNORM flip swapchain:

1. Scene and bloom render into R11G11B10_FLOAT buffers.
2. The LUT builder `0x12F5D245` renders a 32x32x32 LUT as a 1024x32
   R16G16B16A16_FLOAT strip. It only runs when grading changes. Input is a log
   encoding of the scene; output is linear BT.709 from the game's grading and an
   ACES-like segmented spline (at most 1.0).
3. An uberpost adds bloom, vignette and grain, samples the LUT and sRGB encodes
   into an R8G8B8A8_TYPELESS buffer at the back buffer size. Four variants exist:
   `0x93121324` (title screen, open world), `0x318A9DF6` (loading screens),
   `0xB2079998` (main menu) and `0x1AC9F8BC` (character ultimates).
4. UI is alpha-blended straight onto that buffer.
5. A plain blit `0x20133A8B` copies the buffer to the swapchain.

## What the mod changes

- Swapchain proxy with resource cloning. R8G8B8A8_TYPELESS render targets at the
  back buffer aspect ratio are upgraded to R16G16B16A16_FLOAT, which covers the
  uberpost output and the UI drawn on it.
- `lutbuilder_0x12F5D245.ps_5_0.hlsl`: keeps the vanilla grading. `Vanilla` stores the
  vanilla spline; other tone mappers store `ToneMapPass(untonemapped, vanilla)`.
- `uberpost*.ps_5_0.hlsl`: the sRGB encode is replaced with `RenderIntermediatePass`,
  so UI blends on top in the intermediate encoding and the proxy encodes HDR10.
- ReShade Before UI (setting, on by default): effects render right after the
  uberpost on the real back buffer in the output encoding (HDR10 or scRGB), so
  HDR-aware effects compile and see display-encoded data. The scene is encoded
  into the back buffer in `reshade_begin_effects` and decoded back with
  `effects_decode_pixel_shader` in `reshade_finish_effects`. Frames that reach the
  final blit without an uberpost skip effects. Effect toggler add-ons (REST) that
  call `render_effects` earlier in the frame take ReShade's once-per-frame render
  and must be disabled.
- Add-on load order: the swapchain proxy writes the final image in ReShade's
  `present` event, which runs in add-on load order (file name order). Add-ons that
  read the presented frame there, such as the RenoDX DLSS add-on, must load after
  this one; rename this add-on so it sorts first if needed.

## Build

```bash
cmake --build build --config RelWithDebInfo --target honkai-starrail
```

Output: `build/RelWithDebInfo/renodx-honkai-starrail.addon64`.

## Manual verification

1. Windows HDR on, ReShade with add-on support next to `StarRail.exe`, copy the
   add-on there, restart the game.
2. The ReShade log shows the swapchain created as R10G10B10A2 and the LUT builder
   and uberpost replaced. A DevKit snapshot shows the uberpost target upgraded and
   highlights above 1.0 in its float clone.
3. Tone Mapper `Vanilla` matches the unmodded SDR image at UI brightness.
4. Main menu, loading screens and an ultimate keep HDR output.
5. ReShade Before UI on, REST disabled, a visible effect enabled: the effect applies
   to the world but not to HUD or menus.
