# Unity Uber Shader Modification Guide

Use this guide when converting a dumped Unity `Uber_*.hlsl` shader into a RenoDX replacement and registering it in `addon.cpp`.

## Core rule

Unity Uber shaders have many variants. Do not copy an entire modified shader, fixed constant-buffer indices, texture slots, sampler slots, register counts, channel swizzles, or effect ordering from a single reference.

Treat every shader as a data-flow reconstruction task:

1. Identify what each original block does.
2. Find modified references with matching blocks.
3. Apply RenoDX hooks to those blocks while preserving the new shader's ABI and original feature order.
4. Classify the shader independently for its `addon.cpp` callback.

## 1. Inspect and classify the dumped shader

Before editing, record:

- Shader hash and profile from the filename.
- Texture and sampler registers.
- Constant-buffer sizes and all indices used by post-processing blocks.
- Scene-color sample and its encoding.
- Tonemapper: none, Neutral, ACES, HDR/LogC, or another recognizable operator.
- Internal color-grading LUT texture, layout, shaper, and sampling order.
- User LUT texture and its blend constants.
- Optional effects: lens distortion, chromatic aberration, bloom, vignette, film grain, dithering, bicubic sampling, glare, or UI composition.
- Final output encoding: linear or gamma/sRGB.

Do not infer the variant from the texture count or `cb0` size alone.

### Useful signatures

- Three offset scene samples whose channels are recombined usually indicate chromatic aberration.
- A sampled bloom texture may be squared, alpha-weighted, or bicubically reconstructed before composition.
- A `1024x32` or `256x16` strip and the associated floor/interpolation math usually indicate an internal 3D LUT packed into a 2D texture.
- The original LogC-like shaper math and channel rotations such as `zxy`/`yzx` usually indicate an UberHD grading path.
- `lutShaper(color, false, 1)` is the common regular linear-input Uber grading path.
- Explicit sRGB encoding immediately before the render target indicates gamma output. Do not classify output from the source texture alone.

## 2. Find more than one reference

Search `URP/Uber`, `PP/Uber`, `PostFx/Uber`, `HDRP/Uber`, and recently modified test shaders using distinctive code sequences rather than only filenames.

Prefer references in this order:

1. Same pipeline family and tonemapper.
2. Same LUT shaper and LUT ordering.
3. Same optional effects and sampling method.
4. Same final output encoding.

Use at least two references when possible:

- One matching the color pipeline.
- One matching unusual features such as chromatic aberration, lens distortion, bicubic bloom, film grain, or dithering.

If references disagree, preserve the new shader's original order and semantics rather than choosing the shorter implementation.

## 3. Preserve the shader ABI

Unless the dump is malformed, preserve:

- Entry-point signature and semantics.
- Texture, sampler, and constant-buffer registers.
- Constant-buffer lengths and indices.
- Original texture/sampler pairings.
- Coordinate transforms, distortion calculations, bicubic reconstruction, swizzles, and alpha behavior.
- Discard behavior and render-target alpha.

Remove unused decompiler temporaries only when clearly safe. Decompiled `cmp` expressions may be simplified, but simplification is not required for RenoDX support.

## 4. Include the shared helpers

Add `common.hlsl` before resource declarations. Compute the relative path from the shader's final destination; do not copy the include path blindly.

Examples:

- A shader under `URP/Uber`, `PP/Uber`, `PostFx/Uber`, or `test/yes` normally uses `#include "../../common.hlsl"`.
- A shader directly under `unityengine` normally uses `#include "./common.hlsl"`.

Compile from the final destination so a temporarily valid include does not break after the file is moved.

## 5. Reconstruct the linear scene-color path

Identify the complete scene color before decoding it. For example, a chromatic-aberration variant may assemble red, green, and blue from three different samples. Decode only after those channels have been assembled.

Replace the original explicit sRGB decode with:

`renodx::color::srgb::DecodeSafe(color)`

Use `fastSrgbDecodeSafe` only when the original variant uses the matching fast approximation and its modified sibling confirms that choice. Do not decode a source that is already linear.

Avoid early `saturate` operations on scene color. Keep clamps that are intrinsic to a specific effect, coordinate, mask, or interpolation weight.

## 6. Add effect controls at their native blocks

Only add a field when the corresponding effect exists in the shader.

### Chromatic aberration

Scale the original channel-offset amount by `injectedData.fxCA`. Do not scale lens-distortion coordinates or unrelated offsets.

### Bloom

Preserve the original bloom decode, squaring, bicubic reconstruction, alpha weighting, tint, and blend. Multiply the bloom intensity by `injectedData.fxBloom` before adding it to linear scene color.

Do not assume bloom uses `t1`, a particular sampler, or fixed constant-buffer indices.

### Vignette

Preserve the original shape and color. Apply:

- `min(1.f, injectedData.fxVignette)` to the spatial vignette amount.
- `max(1.f, injectedData.fxVignette)` to the exponent/intensity term.

This preserves the established behavior for reducing and extending the effect.

### Film grain

If native film grain exists, retain it under:

`if (injectedData.fxFilmGrainType == 0.f)`

Scale its native strength by `injectedData.fxFilmGrain`. In the alternate branch use `applyFilmGrain(linearColor, screenUV)`.

Do not add film-grain sampling to a variant that never had native film grain unless specifically requested.

### Dithering

Keep the original noise sample and triangular-noise reconstruction, but replace the encoded add/decode sequence with:

`applyDither(linearColor, dither * (1.0 / 255.0))`

The helper applies `injectedData.fxNoise`. Pass the correct encoding argument if the color at that point is not linear.

## 7. Preserve LUT type and ordering

User LUT and internal color-grading LUT order varies between Unity versions. Preserve the original order.

### User LUT

Replace the native user-LUT sampling block with `handleUserLUT`, using the exact original LUT texture, sampler, precompute constants, encoding, and blend factor.

Typical sRGB path:

1. Encode the current linear color with `renodx::color::srgb::EncodeSafe`.
2. Call `handleUserLUT(linearColor, texture, sampler, precompute)`.
3. Preserve the original blend factor.
4. Decode the blended result with `renodx::color::srgb::DecodeSafe`.

Some variants require the fast-sRGB overload or a different encoding argument. Match the original encoding and a verified sibling.

### Internal LUT shaper

Use the shaper corresponding to the original shader:

- Regular Uber linear grading commonly uses `lutShaper(color, false, 1)`.
- UberHD LogC/PQ grading commonly uses default `lutShaper(color)` and may require channel rotations before and after shaping.
- ACES, Neutral, PostFX, and HDRP variants may use different shapers or tonemapping order. Follow matching files from that family.

Never remove a channel rotation merely to make the LUT code look like another variant.

### Internal LUT sampling

Preserve the native packed-2D interpolation under:

`if (injectedData.colorGradeLUTSampling == 0.f)`

In the alternate branch use `renodx::lut::SampleTetrahedral` with:

- The exact internal LUT texture.
- The correctly shaped color and channel order.
- The original cube size, commonly `sizeConstant + 1u`.

Do not use the user-LUT texture for internal LUT sampling or vice versa.

## 8. Handle final output exactly once

Determine whether the original shader writes linear or gamma output before replacing its final encode.

For a gamma-output shader:

```hlsl
if (injectedData.countOld == injectedData.countNew) {
  color = PostToneMapScale(color, true);
} else {
  color = renodx::color::srgb::EncodeSafe(color);
}
```

For a linear-output shader:

```hlsl
if (injectedData.countOld == injectedData.countNew) {
  color = PostToneMapScale(color);
}
```

Some pipelines require a different fallback. Match the same pipeline family. Prevent double encoding: after `PostToneMapScale(color, true)`, do not apply another sRGB encode.

## 9. Select the `addon.cpp` callback independently

Register the shader hash once in the appropriate section of the shader map.

Choose both axes independently:

| Color pipeline | Linear output | Gamma output |
| --- | --- | --- |
| Regular URP/PP Uber | `UberLinearOnDraw` | `UberGammaOnDraw` |
| UberHD LogC/PQ | `UberHDLinearOnDraw` | `UberHDGammaOnDraw` |
| Neutral tonemapper | `UberNeutralLinearOnDraw` | `UberNeutralGammaOnDraw` |
| ACES tonemapper | `UberACESLinearOnDraw` | `UberACESGammaOnDraw` |
| PostFX Stack | `UberPFXLinearOnDraw` | `UberPFXGammaOnDraw` |
| HDRP compute Uber | Use the matching `UberHDRPOnDraw` pattern |

`UberHD` describes the grading/shaper path; `Gamma` describes final output encoding. One does not imply the other.

If output encoding cannot be proven, compare the original final math and matching siblings before registering. Use `UberHDOnDraw` only when its less-specific behavior is intentionally required.

Keep regular Uber registrations with regular Uber entries, HD registrations in the HD section, Neutral registrations in the Neutral section, and ACES registrations in the ACES section.

## 10. Validate every variant

After editing:

1. Check editor diagnostics for the shader.
2. Compile the shader with the repository's configured compiler and production flags for its filename/profile.
3. Compile from the shader's final path to validate the include.
4. Confirm every original resource register still exists and no new register collision was introduced.
5. Search `addon.cpp` for the hash and confirm exactly one active registration.
6. Run `git diff --check` on the shader and `addon.cpp`.
7. Review the final diff for accidental deletion of variant-specific effects or swizzles.

For `ps_4_0` replacements, the repository commonly invokes FXC with a `ps_5_0` compiler target while defining `__SHADER_TARGET_MAJOR=4` and `__SHADER_TARGET_MINOR=0`. Prefer the generated CMake target or mirror the current `CMakeLists.txt` flags rather than inventing a command.

Compilation proves syntax and resource compatibility, not color correctness. If runtime captures are available, also verify SDR, HDR, native/user LUT, disabled effects, and alternate film-grain/LUT-sampling settings.

## Final checklist

- [ ] Correct relative `common.hlsl` include.
- [ ] ABI, registers, samplers, constants, and output alpha preserved.
- [ ] Scene color decoded at the correct point.
- [ ] No unintended HDR clamp remains.
- [ ] Variant-specific distortion, CA, and bicubic logic preserved.
- [ ] Bloom, vignette, film grain, and dither fields added only where applicable.
- [ ] User and internal LUT textures are not confused.
- [ ] LUT shaper, channel order, and LUT ordering match the original variant.
- [ ] Tetrahedral branch uses the correct texture, color, and size.
- [ ] Final scaling uses the correct linear/gamma mode without double encoding.
- [ ] Hash registered once with the correct family and output callback.
- [ ] Shader compiles and the diff passes validation.
