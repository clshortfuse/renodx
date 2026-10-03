# Genshin Impact

DirectX 11, Unity (miHoYo fork). Works with the in-game HDR setting on or off and with
any anti-aliasing option. No manual mode setting: both game paths end in the RenoDX
intermediate encoding and the swapchain proxy does the final HDR10 or scRGB encode.

## Vanilla pipelines

Shared: linear R11G11B10 scene, half-res composite, bloom and exposure in the uberpost
`0xBE195674`. `cb0[20].x` selects the output path.

### SDR mode (in-game HDR off)

1. Uberpost: color matrix, exposure, SDR curve
   `x(1.36x + 0.047) / (x(0.93x + 0.56) + 0.14)`, sRGB approximation encode
   (`1.055 x^(1/2.4) - 0.055`, no linear toe) and the in-game brightness gamma
   `cb0[20].y`, written to an R8G8B8A8_UNORM buffer.
2. Anti-aliasing on 8-bit buffers (SMAA edges, weights, blend, temporal when SMAA is
   selected).
3. Plain copy (`0x1A8F4B01`) to the R8G8B8A8_UNORM_SRGB blit-model swapchain.
4. UI alpha-blended directly onto the swapchain in encoded space.

Menus that hide the world (inventory) are UI-only frames: the first draw is the blurred
world backdrop (`0x1452E357`), captured into an 8-bit buffer when the menu opens.

### HDR mode (in-game HDR on)

1. Uberpost: `scene * 0.01` PQ encoded, sampled through a 32x32x32 R10G10B10A2 LUT,
   written as PQ BT.2020.
2. LUT builder compute shader `0xF609D63C` (not every frame in every scene): color matrix, exposure, SDR
   curve per channel with untonemapped luminance restored, luminance/chroma weighted
   saturation boost, paper white, AP1 max-channel roll-off toward the game's peak, PQ
   BT.2020 encode.
3. Anti-aliasing in PQ space on R10G10B10A2 buffers.
4. Final composite `0xAE711F61`: PQ scene to nits, encoded relative to the game's UI
   paper white, premultiplied UI blend, PQ encode through a 1D LUT into the
   R10G10B10A2 swapchain.

## Mod

- Swapchain output goes through the RenoDX proxy. The game and UI render into an
  R16G16B16A16_FLOAT clone of the back buffer; the proxy writes the final encode
  (Encoding setting) into the real swapchain, which is R10G10B10A2 for HDR10 (default)
  and R16G16B16A16_FLOAT for scRGB.
- R8G8B8A8_TYPELESS render targets at the back buffer aspect ratio upgraded to
  R16G16B16A16_FLOAT, so the SDR uberpost output survives any AA/upscaler and render
  scale.
- `uberpost_0xBE195674.ps_5_0.hlsl`: SDR branch replaced. `Vanilla` replays the game
  curve and brightness gamma; other tone mappers use
  `ToneMapPass(untonemapped, vanilla_sdr)` then the brightness gamma in sRGB-encoded
  space. Output goes through `RenderIntermediatePass`. The HDR branch is vanilla.
- `lutbuilder_0xF609D63C.cs_5_0.hlsl`: `Vanilla` reproduces the game HDR math; other
  tone mappers store the `RenderIntermediatePass` result as PQ nits (intermediate 1.0 =
  UI white nits).
- HDR mode LUT mirror: the game does not dispatch the LUT builder every frame, and a
  build recorded on a deferred context can be replayed with the settings pushed at
  record time, so setting changes would not reliably reach the image. The addon keeps
  its own copy of each game LUT: the builder's `cb0` is copied on the GPU next to every
  game dispatch, the replaced builder renders the addon LUT at present with the current
  settings, and the uberposts that sample the LUT (`0xBE195674`, `0xE3118E31`,
  `0xC225B20B`, `0x7F4102D4`, `0x8691B864`) copy it over the game LUT right before they
  draw. The compute bindings it uses are restored afterwards.
- `final_0xAE711F61.ps_5_0.hlsl`: scene converted to the intermediate encoding, UI blended
  at the RenoDX UI brightness, output left to the swapchain proxy. The game's HDR UI
  brightness constants are ignored.
- `final_0x0B519C4E.ps_5_0.hlsl`: the composite variant used when two cameras are on
  screen (for example underwater). It blends two PQ scenes through screen-space quad
  masks, then composites like `0xAE711F61`. Unreplaced, it writes PQ straight into the
  float back buffer and the image looks washed out.
- `common.hlsli`: vanilla curve and the shared HDR scene + UI composite.
- `swapchain_proxy_revert_state` is required. Genshin caches bound pipeline state
  across frames; without it the first UI draw of a menu frame (the blurred backdrop,
  `0x1452E357`) inherits the proxy vertex stage and shows screen UVs as a
  black/red/green/yellow gradient.
- The back-buffer-ratio R8G8B8A8_TYPELESS upgrade also matches Genshin's deferred
  G-buffers (render resolution, written and read through sRGB views). They hold
  values outside 0..1 that 8-bit storage clamps; upgraded, the lighting pass reads
  them unclamped and emissive materials blow up (glitchy TCG card borders). The
  addon keeps any upgraded resource accessed through an sRGB view on its original
  8-bit texture. Post-processing, AA and UI buffers use UNORM views and stay float.

- ReShade Before UI (setting, on by default): ReShade effects render on the game image
  before UI in both modes and with any AA option. Effects run on the real back buffer in
  the output encoding (HDR10 or scRGB), so HDR-aware effects such as Lilium's compile and
  see display-encoded data; the result is decoded back before the UI is drawn.
  SDR mode renders them after the scene copy `0x1A8F4B01` (callback-only entry). HDR
  mode makes `0xAE711F61` write the scene only, renders effects, then blends the UI
  buffer (pixel slot 0, recorded from `push_descriptors`) with
  `ui_composite_pixel_shader` using ONE / SRC_ALPHA blending. Frames whose first back
  buffer draw is UI (inventory) skip effects. Effect toggler add-ons (REST) that call
  `render_effects` earlier in the frame take ReShade's once-per-frame render and must
  be disabled.

- Add-on load order: the swapchain proxy writes the final image to the back buffer in
  ReShade's `present` event, and ReShade runs `present` callbacks in add-on load order
  (file name order). Add-ons that read the presented frame in that event, such as the
  RenoDX DLSS add-on (DLSS-NR, Present stage), must load after this one, otherwise the
  proxy overwrites their output. Rename this add-on so it sorts first, for example
  `renodx-agenshin.addon64`.

Uberpost variants other than `0xBE195674` are not replaced. The known one is
`0xE3118E31` (same shader without the half-res composite), used by the menu and
character screen camera; its scene path stays vanilla SDR shown at UI brightness.

## Build

```bash
cmake --build build --config RelWithDebInfo --target genshin
```

Output: `build/RelWithDebInfo/renodx-genshin.addon64`. Generated shader headers land in
`build/genshin.include/embed/`.

## Manual verification

1. Windows HDR on, ReShade with addon support in `Genshin Impact game/`, copy
   `renodx-genshin.addon64` next to `GenshinImpact.exe`, restart the game.
2. In-game HDR off: the ReShade log shows the swapchain created as R10G10B10A2
   (HDR10 encoding). A DevKit snapshot shows the uberpost `0xBE195674` replaced and its
   target upgraded. Read HDR values from the back buffer RTV with the clone preferred;
   highlights exceed 1.0.
3. Open the inventory with in-game HDR off: the backdrop is the blurred world, not a
   colored gradient.
4. Switch AA between SMAA, FSR and off: output keeps HDR highlights in each mode.
5. In-game HDR on: LUT builder and composite replaced, image matches the SDR mode look
   at the same RenoDX settings.
   Changing the tone mapper or a slider changes the image right away, including in
   Dragonspine (uberpost `0x8691B864`) and underwater.
6. Tone Mapper `Vanilla` in SDR mode matches the unmodded SDR image at UI brightness.
7. ReShade Before UI on, REST disabled, a visible effect enabled: in SDR and HDR mode
   with SMAA, FSR and AA off, the effect applies to the world but not to HUD, menus or
   the inventory. HDR-aware effects (Lilium) compile in both modes.
