# Genshin Impact

DirectX 11, Unity (miHoYo fork). Requires Windows HDR and the in-game HDR setting on;
works with any anti-aliasing option. The final composites write the RenoDX intermediate
encoding and the swapchain proxy does the final HDR10 or scRGB encode.

With in-game HDR off the image stays vanilla and the add-on shows a notice. The SDR
path tone maps inside the uberpost, and the game ships a separate uberpost variant for
every region grading, weather and camera keyword combination (more than 1000 in the
shader cache), so it cannot be replaced shader by shader. In HDR mode all of them sample
one LUT and end in one final composite.

## Vanilla HDR pipeline

1. Uberpost (linear R11G11B10 scene, half-res composite, bloom, exposure): `scene * 0.01`
   PQ encoded, sampled through a 32x32x32 R10G10B10A2 LUT, written as PQ BT.2020.
   `cb0[20].x` selects this path; the SDR path applies the curve below inline.
2. LUT builder compute shader `0xF609D63C` (not every frame in every scene): color
   matrix, exposure, SDR curve `x(1.36x + 0.047) / (x(0.93x + 0.56) + 0.14)` per channel
   with untonemapped luminance restored, luminance/chroma weighted saturation boost,
   paper white, AP1 max-channel roll-off toward the game's peak, PQ BT.2020 encode.
3. Anti-aliasing in PQ space on R10G10B10A2 buffers.
4. Final composite `0xAE711F61`: PQ scene to nits, encoded relative to the game's UI
   paper white, premultiplied UI blend, PQ encode through a 1D LUT into the
   R10G10B10A2 swapchain.

Menus that hide the world (inventory) are UI-only frames: the first draw is the blurred
world backdrop (`0x1452E357`).

## Mod

- Swapchain output goes through the RenoDX proxy. The game and UI render into an
  R16G16B16A16_FLOAT clone of the back buffer; the proxy writes the final encode
  (Encoding setting) into the real swapchain, which is R10G10B10A2 for HDR10 (default)
  and R16G16B16A16_FLOAT for scRGB.
- `lutbuilder_0xF609D63C.cs_5_0.hlsl`: `Vanilla` reproduces the game HDR math; other
  tone mappers store the `RenderIntermediatePass` result as PQ nits (intermediate 1.0 =
  UI white nits).
- LUT mirror: the game does not dispatch the LUT builder every frame, and a build
  recorded on a deferred context can be replayed with the settings pushed at record
  time, so setting changes would not reliably reach the image. The addon keeps its own
  copy of each game LUT: the builder's `cb0` is copied on the GPU next to every game
  dispatch, the replaced builder renders the addon LUT at present with the current
  settings, and the addon LUT is copied over the game LUT whenever a pixel shader binds
  the game LUT's SRV. The compute bindings it uses are restored afterwards. Matching
  the bind covers every uberpost variant (seen so far: `0xBE195674`, `0xE3118E31`,
  `0xC225B20B`, `0x7F4102D4`, `0x8691B864`, `0xE61A4A0F`, `0xD9BEA088`).
- `final_0xAE711F61.ps_5_0.hlsl`: scene converted to the intermediate encoding, UI blended
  at the RenoDX UI brightness, output left to the swapchain proxy. The game's HDR UI
  brightness constants are ignored.
- `final_0x0B519C4E.ps_5_0.hlsl`: the composite variant used when two cameras are on
  screen (for example underwater). It blends two PQ scenes through screen-space quad
  masks, then composites like `0xAE711F61`. Unreplaced, it writes PQ straight into the
  float back buffer and the image looks washed out.
- `common.hlsli`: vanilla curve and the shared scene + UI composite.
- In-game HDR detection: frames that draw either final composite mark HDR as on; after
  120 frames without one the notice is shown and ReShade Before UI stays out of the way.
- `swapchain_proxy_revert_state` is required. Genshin caches bound pipeline state
  across frames; without it the first UI draw of a menu frame (the blurred backdrop,
  `0x1452E357`) inherits the proxy vertex stage and shows screen UVs as a
  black/red/green/yellow gradient.

- ReShade Before UI (setting, on by default): ReShade effects render on the game image
  before UI with any AA option. Effects run on the real back buffer in the output
  encoding (HDR10 or scRGB), so HDR-aware effects such as Lilium's compile and see
  display-encoded data; the result is decoded back before the UI is drawn. The
  composites write the scene only, effects render, then the UI buffer (pixel slot 0,
  recorded from `push_descriptors`) is blended with `ui_composite_pixel_shader` using
  ONE / SRC_ALPHA blending. Frames whose first back buffer draw is UI (inventory) skip
  effects. Effect toggler add-ons (REST) that call `render_effects` earlier in the frame
  take ReShade's once-per-frame render and must be disabled.

- Add-on load order: the swapchain proxy writes the final image to the back buffer in
  ReShade's `present` event, and ReShade runs `present` callbacks in add-on load order
  (file name order). Add-ons that read the presented frame in that event, such as the
  RenoDX DLSS add-on (DLSS-NR, Present stage), must load after this one, otherwise the
  proxy overwrites their output. Rename this add-on so it sorts first, for example
  `renodx-agenshin.addon64`.

## Build

```bash
cmake --build build --config RelWithDebInfo --target genshin
```

Output: `build/RelWithDebInfo/renodx-genshin.addon64`. Generated shader headers land in
`build/genshin.include/embed/`.

## Manual verification

1. Windows HDR on, ReShade with addon support in `Genshin Impact game/`, copy
   `renodx-genshin.addon64` next to `GenshinImpact.exe`, restart the game.
2. In-game HDR on: LUT builder and composites replaced. Changing the tone mapper or a
   slider changes the image right away in Mondstadt, Dragonspine (uberpost `0x8691B864`),
   past Liyue (`0xE61A4A0F`) and underwater (composite `0x0B519C4E`). The log shows
   `genshin::CopyLutMirrors(game LUT bound, mirror copied)` once.
3. Open the inventory: the backdrop is the blurred world, not a colored gradient.
4. Switch AA between SMAA, FSR and off: output keeps HDR highlights in each mode.
5. ReShade Before UI on, REST disabled, a visible effect enabled: with SMAA, FSR and AA
   off, the effect applies to the world but not to HUD, menus or the inventory.
   HDR-aware effects (Lilium) compile.
6. In-game HDR off: the RenoDX settings show the "In-game HDR is off" notice.
