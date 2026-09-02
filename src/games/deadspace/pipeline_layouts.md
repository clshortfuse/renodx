# Dead Space Pipeline Layout Notes

This file documents the Dead Space (2023) D3D12 root-signature issue that blocked shader-injection sliders.

## Problem

Dead Space replacement shaders read RenoDX slider values from the injected `b13` cbuffer declared in `shared.h`.

The initial failure was not caused by:

- HLSL struct packing.
- C++ default initialization.
- Slider bindings.

The failing path was root-signature matching. RenoDX could mutate a matching game root signature to append the injected `b13` range, but later see that same layout again in its already-mutated form. If the already-mutated layout was not recognized, the non-cloning injection path could miss the modded root parameter and fail to push constants. Shaders then read zero/unbound `b13` data, making sliders appear broken.

## Fix

`pipeline_layouts.hpp` keeps an explicit allowlist and denylist, but also treats an allowlisted layout plus the appended injected `b13` constant range as valid.

This lets already-mutated layouts register and resolve the injected root parameter correctly.

## Required shader injection settings

Dead Space currently uses:

- `renodx::mods::shader::allow_multiple_push_constants = true`
- `renodx::mods::shader::expected_constant_buffer_index = 13`
- `renodx::mods::shader::expected_constant_buffer_space = 0`
- `renodx::mods::shader::force_pipeline_cloning = true`

Do not re-enable `renodx::mods::shader::use_pipeline_layout_cloning`; it was tested and crashed.

## Known layouts

Denied:

- `replacement-candidate-a-after-lutbuilder`
- `replacement-candidate-b-after-lutbuilder`

Allowed:

- `compute-lutbuilder`
- `graphics-colorgrade-composite`
- `graphics-colorgrade-composite-simple`

The names are descriptive labels for observed root-signature shapes, not engine-provided semantic names.

## Injected cbuffer

The injected cbuffer is `b13`.

`shared.h` uses:

- SM5.0: `register(b13)`
- SM5.1+/SM6: `register(b13, space50)`

Dead Space shaders should read cbuffer values through `shared.h` macros such as `TONE_MAP_TYPE`, `RENODX_PEAK_WHITE_NITS`, and `OVERRIDE_GAME_BRIGHTNESS`.

## LUT builder note

The tone-map LUT builders only redraw when the game rebuilds HDR LUTs. Settings that affect those LUT builders mark the LUT state dirty and show a warning until one of these shaders is drawn:

- `0xEC2192B4` / `aces_lutbuilder_0xEC2192B4.cs_5_0.hlsl`
- `0x6F0456CD` / `aces_lutbuilder_2luts_0x6F0456CD.cs_5_0.hlsl`
- `0xD97D273F` / `aces_lutbuilder_3luts_0xD97D273F.cs_5_0.hlsl`

The user-facing instruction is to move the in-game brightness slider back and forth to apply those settings.