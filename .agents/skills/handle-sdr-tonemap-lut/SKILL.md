---
name: handle-sdr-tonemap-lut
description: "RenoDX HLSL/Slang shader workflow for proven shader-side SDR tonemap, hard clip, LUT, color grade, and HDR bridge changes. Use when editing game shaders for neutral-by-default ToneMapPass/RenoDRT, vanilla/0 ToneMapPass user grading, Preset Off vanilla reset, PsychoV17, vanilla midgray/slope or inflection matching, UpgradeToneMap delta, SDR LUT bridges, N2 max-channel reconstruction, gamut compression, hue/saturation clip emulation, internal/user LUTs, or shader-side tonemap/LUT replacements after upstream HDR/SDR signals are identified."
argument-hint: "game shader, proven HDR/SDR signals, and goal, e.g. audit LUT bridge, add PsychoV17, fix hard-clip ToneMapPass, or verify Preset Off"
---

# Handle SDR Tonemap + Optional LUT

Use this skill for RenoDX **shader-side** tonemap/LUT work in HLSL or Slang. Keep the workflow focused on shader changes: finding the right color signal, preserving the vanilla SDR appearance, and choosing a shader bridge into HDR.

RenoDX is not a final-frame inverse-tonemap postprocess. Do not start from the completed SDR swapchain image and expand it with an inverse curve like Microsoft AutoHDR, RTX HDR, or generic ReShade FX. If the target pass/resource or upstream signal is not proven, switch to `swapchain-resource-analysis` first.

Shader-side RenoDX tonemapping is a forward display-mapping decision for a proven upstream signal. It should target user-configurable HDR output levels, preserve the game's intended SDR art direction, and avoid overcoloring or oversaturating the original look.

## Neutral-by-default rule

RenoDX mods should be neutral out of the box. Treat HDR as extending the original game's SDR pipeline limits into a display-referred range, not as permission to redesign the image.

- Preserve vanilla/original SDR contrast, saturation, hue, grade, and presentation effects unless the task explicitly proves a different target.
- Default tonemap/LUT settings should match the original/vanilla look as closely as practical in SDR output mode and keep the same art direction in HDR output mode.
- Use HDR headroom to preserve highlights, bloom, gradients, and gamut that the original pipeline clipped or compressed; do not add contrast or saturation just because the output is HDR.
- Put creative/non-neutral looks behind explicit user settings that default to neutral, or behind named presets such as `HDR Look`; document rare exceptions with validation evidence.
- Reject shader changes whose main visible effect is "more punch" without a proven vanilla reference or user-requested artistic control.
- `ToneMapPass` with `RENODX_TONE_MAP_TYPE == 0` / Vanilla is a valid mode for keeping the game's vanilla process as the tonemap while still allowing user grading controls such as exposure, contrast, and saturation. Do not treat that as the same thing as a full Off preset.
- A Vanilla/0 path may explicitly `saturate` or clamp to emulate the original implicit RGBA8U/UNORM resource write clamp after a resource upgrade. Keep that scoped to vanilla preservation/reset behavior; do not reuse it as an HDR bridge, LUT proxy, or `neutral_sdr` recommendation.
- A Preset Off or equivalent reset should restore true 100% vanilla as closely as practical by disabling custom grading, HDR-look controls, and effect overrides; exact equivalence may be impossible after resource upgrades, but the difference must be intentional and documented.

## Related skills and scope

| Need | Use |
|---|---|
| Find the target pass, prove HDR source location, plan resource upgrades, or handle final `SwapChainPass` output | `swapchain-resource-analysis` |
| Build/link game addon, configure DevKit, create/resume a game folder | `setup-game-mod-dev` |
| Plot tone curves, slopes, LUT residuals, or sampled shader behavior | `analysis-graphing` |

This skill starts after a shader-side target and relevant signals are known. If the task is still about finding those signals, stay in `swapchain-resource-analysis`.

Treat the visible SDR look as a pipeline, not just a curve:

```text
scene / post exposure / bloom / vignette / fade
-> SDR tonemap or hard clip
-> optional user LUT
-> internal/generated LUT or color grade
-> blend masks / strength / scaling
-> output encode
```

## Boundaries

- Focus on HLSL/Slang shader changes and shared shader includes.
- Read `shared.h` only to understand shader injection constants/macros used by the shader.
- Put nontrivial reusable shader logic in the game's `common.hlsl`, `common.hlsli`, or an existing nearby purpose-specific `.hlsli` include when that fits the folder pattern.
- Do not turn this into addon UI, C++ plumbing, resource upgrade, CMake, or release workflow guidance.
- If the shader fix requires addon/resource/C++ work, report that as an external requirement instead of expanding this workflow.
- Require a proven shader-side signal such as `untonemapped`, `neutral_sdr`, or `graded_sdr`; if draw/resource analysis is missing, use `swapchain-resource-analysis` first.
- Reject final swapchain/backbuffer inverse tonemapping as a RenoDX strategy. That is AutoHDR/RTX HDR/ReShade FX class postprocessing, not shader-side tonemap replacement.

## Shader rules

- Keep changes local to the game/shader being worked on.
- RenoDRT is `renodx::draw::ToneMapPass(...)`.
- Prefer current `ToneMapPass` methods used in the repo such as Neutwo or Reinhard. Do not recommend Hermite or Daniele as new strategy choices.
- Do not extract helpers for local control flow, one-off math, basic field access, or short condition checks.
- Do move substantial tonemap/LUT bridge functions into a game-local common include instead of pasting large logic blocks into every original shader.
- When modifying decompiled/original shaders, keep edits minimal: capture the needed signal, call a common include helper or small scoped block, then assign the output.
- Clearly mark custom snippets and preserve vanilla logic by leaving it intact or commenting out replaced lines where practical; avoid silently deleting vanilla code.
- Prefer lightly injected snippets in original shaders over broad rewrites.

## Expected output from this skill

Produce these sections:

1. **Detected shader pipeline** - capture point, tonemap/clip, LUTs, encodings, masks, and output.
2. **Shader strategy** - primary HLSL/Slang approach and why.
3. **Fallback/legacy shader path** - what to preserve if replacing is risky.
4. **Shader edit plan** - exact shader files, include files, and injected constants used.
5. **Visual/math validation** - curve, slope, LUT, and screenshot checks.

## Step 1: Discover the shader pipeline

Inspect the relevant shader(s) and nearby shared HLSL/Slang includes. Answer:

| Area | What to identify |
|---|---|
| Local includes | Existing `common.hlsl`, `common.hlsli`, or purpose-specific `.hlsli` files that can hold helper logic. |
| Resource proof | Draw/resource evidence that the shader input is not just final SDR backbuffer color. |
| Capture point | Last useful linear scene value before SDR clamp/tonemap/LUT. |
| Presentation effects | Exposure, fades, bloom, vignette, hero lights, grain, or clip effects already inside the shader. |
| Tonemap | Analytic curve, hard clip/saturate, black-box shader math, or none. |
| LUTs | Internal LUT, generated LUT, optional user LUT, chained LUTs, or custom LUT draw count. |
| Encoding | Linear, sRGB, gamma 2.0/2.2/2.4, packed 2D LUT, or 3D LUT. |
| Sampling | Trilinear, tetrahedral, manual 2D strip, or hardware sample. |
| Blending | Strength scalar, vanilla constant, per-pixel blend mask, or multiple LUT paths. |

## Step 2: Choose the shader reference scope

Use the narrowest reference scope that preserves the intended look.

| Scope | Use when |
|---|---|
| `tonemap-only` | The LUT is unrelated or should remain a separate post-grade bridge. |
| `tonemap-plus-lut` | Final SDR look is defined by tonemap plus LUT. |
| `full-sdr-look` | Effects such as fades, vignette, bloom, masks, or exposure are part of shader presentation. |
| `hard-clip-sdr` | There is no true tonemap; vanilla is saturate/clip plus optional LUT. |
| `unknown-black-box` | No analytic model is reliable; sample or measure shader behavior. |

## Step 3: Identify shader signals

Prefer a linear scene capture before SDR clipping, but keep intentional presentation scaling if it belongs to the vanilla look.

| Signal | Meaning |
|---|---|
| `untonemapped` | Linear scene/HDR source that will feed `ToneMapPass` or PsychoV. |
| `neutral_sdr` | Linear vanilla ungraded SDR/reference baseline, such as an engineered SDR proxy, analytic vanilla tonemap, or neutral LUT-domain reconstruction. |
| `graded_sdr` | Linear vanilla SDR after LUT/color grade/masks. |

`ToneMapPass`, PsychoV, and other tonemappers expect linear input in the shader's proven working color space. Do not feed encoded/gamma/sRGB values into `ToneMapPass`. If a LUT must be sampled in sRGB/gamma space, encode only for the LUT address/sample, then decode the sampled result back to linear before using it as `graded_sdr`, `neutral_sdr`, or tonemapper input.

For hard-clip/no-tonemap shaders, do not turn the HDR source into `neutral_sdr` with a raw hard clip. `ToneMapPass(untonemapped, graded_sdr, neutral_sdr)` uses `neutral_sdr` through `UpgradeToneMap`, so the neutral/reference baseline must be an engineered SDR/LUT-domain proxy, analytic vanilla tonemap, or other proven reference signal. The two-argument `ToneMapPass(untonemapped, graded_sdr)` defaults the neutral path to RenoDRT neutral SDR, which may be wrong for custom vanilla baselines. The Silksong-style repo path is the reference shape for this: keep SDR-like clip controls explicit, build a safe `neutral_sdr`/`graded_sdr`, then call `ToneMapPass(untonemapped, graded_sdr, neutral_sdr)` when that is the right bridge.

Do not assume a hard clip is safe just because it is vanilla. Hard clipping `untonemapped` for an HDR bridge can collapse highlights to white or wrong hues; `ToneMapPass` can then scale that damaged grade back up. A `saturate` on an already-tonemapped value may simply trim small vanilla overflow, and a Vanilla/0 branch may intentionally simulate the original RGBA8U/UNORM resource clamp after an upgrade. Those are not the same issue. Wobbly Life is the warning case: vanilla hard-clip-to-LUT sampling needed max-channel/N2 scaling, gamut compression, and reconstruction to preserve hue and saturation. Silksong goes further when the clip itself is part of the look by emulating hue and saturation clip effects selectively instead of blindly scaling clipped white.

In original/decompiled shaders, prefer a small injection shape:

1. capture `untonemapped`, `neutral_sdr`, or `graded_sdr` near the vanilla signal;
2. leave the vanilla computation readable nearby;
3. replace only the final color assignment or narrow branch with the RenoDX call.

Use [ToneMapPass injection snippets](./snippets/tone_map_pass.hlsl) as starting shapes for proven shader targets. Do not copy them until draw/resource analysis proves the source signals.

## Step 4: Choose the shader HDR strategy

| Strategy | Status | Use when |
|---|---|---|
| `ToneMapPass(untonemapped)` | Preferred | No SDR LUT/grade needs to be preserved. |
| `ToneMapPass(untonemapped, graded_sdr)` | Preferred | A trustworthy graded SDR result exists and default RenoDRT neutral SDR is acceptable. |
| `ToneMapPass(untonemapped, graded_sdr, neutral_sdr)` | Preferred | Custom neutral/reference baseline that is safe for `UpgradeToneMap`; not a raw hard clip of `untonemapped`. |
| `ToneMapPass` with Vanilla/0 config | Valid mode | Keep the game's vanilla process as the tonemap while allowing user grading controls; pair with a true Off preset/reset when no custom grading is requested. |
| `direct-psychov17` | Preferred for PsychoV | User requests PsychoV17 or observer tonemap; handle LUT bridge after PsychoV unless final SDR look is the reference. |
| `extended-vanilla` | Situational | Preserve an analytic vanilla curve shape above SDR range. |
| `tonemap::config::Apply + LUT` | Legacy/compat | One-shot tonemap+LUT texture helper is already wired or low-risk. |
| `UpgradeToneMap delta` | Legacy | Existing luminance-delta bridge must be preserved; avoid as a new default. |

### HDR tonemap output goals

Choose the shader output domain deliberately instead of assuming SDR `0..1` or final swapchain pixels.

| Goal | Shader implication |
|---|---|
| User peak nits | Map highlights according to injected/user peak settings instead of hard-targeting SDR reference white. |
| Preserve art direction | Keep the vanilla SDR appearance as the default reference; do not add saturation or extra contrast just because HDR headroom exists. |
| Perceptual mapping | Prefer repo-supported perceptual or display-aware paths when they better preserve contrast/luminance relationships than simple BT.709 channel math. |
| Selective gamma/sRGB compatibility | A shader may need to write gamma/sRGB-shaped HDR values so unmodified UI or later game passes blend correctly; record this as part of the pipeline. |
| Final output conversion | scRGB/PQ/HDR10 encoding usually belongs in the output/proxy path via `renodx::draw::SwapChainPass(...)`; only handle it here if this shader is explicitly the proven final encode shader. |

If the shader being edited is the swapchain proxy pixel shader, keep it thin: sample the proven proxy/intermediate color, call `SwapChainPass`, and drive SDR/HDR10/scRGB selection through the injected output preset cbuffer. Use `swapchain-resource-analysis` for the broader proxy/resource/color-space plan.

### One-shot tonemap + LUT helper

`renodx::tonemap::config::Apply(color_input, tm_config, lut_config, lut_texture)` exists in `src/shaders/tonemap.hlsl`. It applies HDR and SDR tonemaps, samples a LUT, then uses `UpgradeToneMap` for non-vanilla types. Treat it as compatibility shader code, not the modern default.

### Modern graded ToneMapPass path

The preferred graded shader path is in `src/shaders/draw.hlsl`:

- `renodx::draw::ComputeUntonemappedGraded(untonemapped, graded_sdr, neutral_sdr)`
- `renodx::draw::ToneMapPass(untonemapped, graded_sdr, neutral_sdr)`

This still uses delta reconstruction internally, but keeps the bridge localized and feeds the result through the current `ToneMapPass` configuration.

## Step 5: Handle inflection and curve matching

Use inflection matching when the vanilla tonemap has a meaningful knee/pivot and the goal is to preserve local contrast around that knee rather than force output midgray. Do not conflate inflection matching with output-midgray matching; they are different anchors.

| Inflection task | What to do |
|---|---|
| Identify the scalar curve | Find the vanilla scalar curve used for matching, often Hable/Uncharted2-style or another filmic curve. |
| Reuse existing math | Prefer existing inverse, derivative, second derivative, or `Find*Root` functions if they already exist in shader code. |
| Choose the pivot | Prefer analytic second-derivative inflection; otherwise use a documented numeric solve. |
| Compute anchor | `anchor_in = x_inflection`, `anchor_out = V(anchor_in)`. |
| Compute slope | Prefer analytic `V'(anchor_in)`; use finite-difference only when no derivative exists. |
| Convert to PsychoV cone | `cone = anchor_in * V'(anchor_in) / max(anchor_out, epsilon)`. |
| Verify perceptually | Compare in viewer/output space, not only scene-linear input space. |

If the curve has a black offset, flare, or toe crush, include that behavior while measuring vanilla slope. Do not force the HDR replacement or PsychoV path to reproduce unwanted crush unless explicitly requested.

## Step 6: PsychoV17 shader matching options

Only add PsychoV17 when requested or when the game already exposes it. Use `renodx::tonemap::psychov::psychotm_test17(...)`.

| Option | Meaning |
|---|---|
| `anchor-none` | Use PsychoV defaults. |
| `anchor-scene-midgray` | Anchor at scene input `x = 0.18`. |
| `anchor-output-midgray` | Solve vanilla `V(x) = 0.18`; this is usually the correct midgray output match. |
| `anchor-inflection` | Match around the vanilla knee/inflection. |
| `anchor-sampled` | Use measured black-box samples when no analytic vanilla model exists. |
| `slope-off` | Do not match vanilla local slope. |
| `slope-delta` | Use finite-difference slope; acceptable if no derivative exists. |
| `slope-analytic` | Prefer analytic derivative when available. |

For PsychoV cone matching, compute the baseline cone response from the vanilla reference as:

```text
cone = x * V'(x) / V(x)
```

where `x` is the anchor input and `V(x)` is the anchor output.

## Step 7: LUT shader bridge options

Classify LUT handling before choosing a bridge.

Use [SDR LUT bridge snippets](./snippets/sdr_lut_bridge.hlsl) as starting shapes for proven SDR LUT paths that need gamut compression, max-channel preservation, and reconstruction around a vanilla LUT sample.

Do not treat every committed LUT example as current best practice or every LUT as SDR. A game may have a high-quality older bridge, a compatibility-only `UpgradeToneMap` path, an analytic post-tonemap grade with no LUT, or a PQ/HDR/log LUT domain that must be sampled in its real domain. Keep WIP investigations in scratch notes until their final domain and bridge are stable.

Most vanilla SDR LUTs are sampled in sRGB/gamma-encoded space and return encoded values. Linear LUT input is extremely rare and must be proven from shader math, resource naming, or measured behavior. Do not pass encoded LUT inputs or outputs directly into `ToneMapPass`; decode them before tonemapping or reconstruction.

LUT centering, half-texel offsets, packed 2D strip addressing, and edge handling are sampling/addressing fidelity details, not the vanilla color grade itself. Preserve or deliberately replace them so the same LUT cells are sampled, but do not treat “centering” as a grade or as proof that the HDR bridge is correct.

"Going to SDR" for a LUT means building a deliberate neutral SDR/LUT-domain proxy, not blindly clipping HDR to `[0, 1]`. Valid paths include RenoDRT neutral SDR, max-channel/N2 compression, adaptive-D65 gamut compression, gamma-gamut compression, smooth clamp, or a proven vanilla bounded signal. After the LUT sample, reconstruct the HDR/reference signal or pass the sampled grade as `graded_sdr` with the matching `neutral_sdr`.

When auditing a vanilla LUT path, inspect the code immediately before the LUT sample. A log shaper followed by `saturate`, `min(max(...), 1)`, or equivalent is a hard SDR LUT-domain clip even if the sampled result is later passed as `graded_sdr`. A small `saturate` after a proven tonemap may only trim overflow, and a Vanilla/0 path may intentionally restore an original RGBA8U/UNORM resource clamp, but a hard clip of `untonemapped`/HDR before the LUT is not a valid HDR bridge. In that case, two-argument `ToneMapPass(untonemapped, graded_sdr)` usually compares against the wrong neutral; fix it with a safe LUT-domain proxy/reconstruction path, or with three-argument `ToneMapPass` only when `neutral_sdr` is the same engineered/proven reference baseline used for the grade. Do not use a raw hard clip of `untonemapped` as that proof.

For vanilla hard-clip-to-LUT games, the bridge must also answer what happens to saturated highlights before the LUT. If the vanilla clip turns HDR color into white or shifts hue, passing a raw clipped value through `ToneMapPass` only preserves and scales that damage. Wobbly Life-style max-channel plus gamut compression/reconstruction and Silksong-style hue/saturation clip emulation are examples of engineering around that problem while still respecting the vanilla LUT/effect intent.

Use `renodx::lut::Config` and `renodx::lut::Sample`/`SampleTetrahedral` when replacing or generalizing LUT sampling so input/output domains, size/precompute, strength, scaling, and sampling choice are explicit. Direct `Texture.Sample` is also valid when preserving exact packed/offset vanilla addressing, but document why `renodx::lut::Sample` is not equivalent. If a game has a meaningful LUT/color-grade pass, treat simple raw sampling as a prompt to check what options were left on the table, not as a final bridge by itself.

| LUT/grade class | Current handling |
|---|---|
| SDR sRGB/gamma LUT | Compress HDR BT.709 to a neutral SDR LUT-domain proxy, encode for the LUT if required, sample the vanilla LUT, decode the result, then reconstruct back to HDR scene/reference. Hades II is a compact reference; Wobbly Life shows why hard-clip-to-LUT paths need hue/saturation-safe compression and reconstruction. |
| SDR LUT with masks/effects | Preserve blend masks, strength, scaling, and effect textures instead of only sampling the LUT. Starfield is the reference for this shape. |
| Unity internal/user LUT after clip | Capture post-exposure/fade-scaled scene before vanilla clip/LUT, branch around the vanilla SDR path for custom HDR, preserve optional user LUT and generated internal LUT, then reconstruct to the proven output domain. Hello Kitty Island Adventure is the active-workspace reference for this shape. |
| Hard-clip + 1D LUT | Preserve SDR-like clipping controls, build explicit `neutral_sdr` and `graded_sdr`, sample the 1D LUT in the proven encoded domain, then use the three-argument `ToneMapPass`. Hollow Knight: Silksong is the reference for selective hue and saturation clip emulation around this shape. |
| PsychoV + SDR LUT | Compute the PsychoV HDR result, compress it into neutral SDR/LUT space with max-channel and/or gamut compression, apply vanilla LUT/effects, then reconstruct HDR/reference range. Starfield and Wobbly Life are modern references for this shape. |
| Analytic post-tonemap grade | Do not invent a LUT bridge. Treat the analytic grade result as `graded_sdr` and feed `ToneMapPass(untonemapped, graded_sdr)` when appropriate. GTA V Enhanced is the reference for this shape. |
| Linear/PQ/HDR/log LUT | Prove the domain, then configure `renodx::lut::Config` or dump/analyze the LUT. Linear LUT input is rare; Valheim and XF Extreme Formula show why forcing SDR assumptions is wrong. |
| Legacy compatibility bridge | Keep if already working, but do not prefer direct `UpgradeToneMap` for new work when graded `ToneMapPass` / `ComputeUntonemappedGraded` is viable. |
| Older committed mod path | Use as evidence of a solved game constraint, not as a generic template. Check age and nearby newer mods before promoting it to skill guidance. |

| Option | Meaning |
|---|---|
| `no-lut` | No LUT preservation. |
| `sample-existing-lut` | Use the game's actual LUT result as `graded_sdr`. |
| `internal-lut` | Preserve generated/internal game LUT. |
| `user-lut` | Preserve optional user LUT, usually controlled by constants. |
| `multi-lut` | Multiple LUT draws, chained LUTs, or tracked custom LUT count. |
| `lut-blend-mask` | Preserve per-pixel masks or blend factors. |
| `lut-strength` | Respect shader-side LUT strength. |
| `lut-scaling` | Respect shader-side HDR reconstruction scaling. |
| `trilinear` | Standard LUT sampling when it matches vanilla or an explicit user/config option. |
| `tetrahedral` | Use when vanilla or existing mod path expects tetrahedral sampling. |
| `manual-2d-strip` | Preserve packed 2D LUT sampling when direct `renodx::lut::Sample` is not equivalent. |

## Step 8: SDR/HDR reconstruction shader options

| Bridge | Status | Use when |
|---|---|---|
| `direct-sdr` | Simple | SDR values are bounded and gamut-safe. |
| `neutral-sdr-baseline` | Preferred | `ToneMapPass(untonemapped, graded_sdr, neutral_sdr)` can preserve the grade. |
| `n2-max-channel` | Preferred | HDR must be compressed through an SDR LUT while preserving peak/max-channel ratio. |
| `luminance-scale` | Situational | Luminance-preserving reconstruction is enough. |
| `per-channel-scale` | Situational | Per-channel preservation is desired and hue shifts are acceptable. |
| `adaptive-d65-gamut` | Preferred for saturated HDR | Compress/decompress BT.709 against an adaptive D65 state around the LUT. |
| `gamma-gamut` | Legacy/situational | Gamma-domain compression/decompression already exists. |
| `smooth-clamp` | Situational | Hable/Uncharted-style SDR LUT bridge needs smooth clipping behavior. |
| `UpgradeToneMap-delta` | Legacy | Preserve old luminance-delta behavior; avoid new default if better bridge exists. |

## Step 9: Scratch graph and image analysis

Use scratch graphs/images only to guide shader math. Keep artifacts in a temporary path and do not add them to the repo unless requested. Use `analysis-graphing` for the actual plotting conventions and reusable plot workflow.

Useful graph patterns for this workflow:

| Artifact type | Use |
|---|---|
| Anchor comparison | Compare output-midgray, inflection, and sampled anchors. |
| Viewer-space stop plot | Plot `log2(output / 0.18)` to compare perceived output shifts. |
| Gain/loss plot | Compare candidate output against vanilla output across stops. |
| Slope/derivative plot | Verify local slope or slope ratio near midgray/knee/inflection. |
| Gamma/EOTF check | Verify whether the shader path is linear, sRGB, gamma 2.2, gamma 2.4, or BT.1886-like. |
| LUT bridge image | Compare neutral LUT, strong LUT, user LUT on/off, and saturated emissive colors. |

Prefer compact scripts and clearly named temporary files. Do not make scratch artifacts part of the shader change unless the user asks.

## RenoDX shader reference examples

Use these as references, not as templates to copy blindly. A committed mod can be high quality and still preserve older practices because it solved a specific game at a specific time; prefer newer recurring patterns for new work unless the game constraints match the older path. Active workspace examples are useful for current pattern language, but verify their tracked/WIP status before presenting them as committed guidance.

| Game | Useful shader pattern |
|---|---|
| `starfield` | PsychoV17 vanilla output-midgray/slope matching; LUT strength/scaling/sampling/blend mask; N2/adaptive-D65 SDR grade bridge. |
| `gtav-enhanced` | Hable/Uncharted analytic derivative and inflection anchor for PsychoV17; analytic post-tonemap grade preserved as `graded_sdr`, not an SDR LUT bridge. |
| `batmanak` | Uncharted2 extended/extrapolate path, LUT strength/sampling, smooth clamp. |
| `wobblylife` | SDR LUT Bridge shader paths; max-channel N2 for main LUT; gamma-gamut or Adaptive D65 gamut bridge for custom LUT draws. |
| `hellokittyislandadventure` | Unity-style scene composite path; branch before vanilla `saturate`/user/internal LUTs, preserve post-exposure/fade, bridge through optional user LUT and generated internal LUT, then write a linear upgraded intermediate. |
| `hollowknight-silksong` | SDR-like clipping controls; hard clip/no-tonemap style path; 1D LUT bridge with max-channel sRGB input; explicit `neutral_sdr` and `graded_sdr` feed three-argument `ToneMapPass`. |
| `valheim` | PQ LUT encode/decode, neutral SDR LUT sampling, and legacy `UpgradeToneMap` bridge. |
| `acecombat7` | LUT builder and output LUT shaders with SRGB/PQ sampling plus `UpgradeToneMap` compatibility. |
| `angerfoot` | Unity-style LUT shaper, generated LUT variants, and tetrahedral LUT sampling across post shaders. |
| `xfextremeformula` | ARRI/log LUT input, LUT strength/scaling/tetrahedral controls, and graded `ToneMapPass` bridge. |

## Shader validation checklist

- Compare vanilla SDR and custom HDR around black, midgray, highlight rolloff, and saturated colors.
- Verify user peak settings affect scene highlights intentionally and do not simply scale completed SDR pixels.
- Check that perceptual/gamut handling preserves the intended look rather than overcoloring or oversaturating it.
- Check that default settings match the original look as closely as practical, with creative contrast/saturation changes disabled unless explicitly requested, exposed through sliders, or selected through a named preset such as `HDR Look`.
- Verify any gamma/sRGB-shaped HDR output is intentional and compatible with later UI/composite/output passes.
- For inflection matching, verify the chosen pivot, derivative source, and output-space behavior.
- For PsychoV matching, verify the anchor (`V(x)=0.18` or inflection) and slope source in viewer/output space when possible.
- For LUT bridges, test neutral LUT, strong LUT, user LUT on/off, and saturated emissive colors.
- For SDR LUT bridges, verify the path compresses/maps to SDR LUT space instead of only clipping, samples in the proven LUT domain, then reconstructs HDR/reference range or feeds a graded `ToneMapPass` path.
- Check UI/HUD/video/menu shader paths separately if the edited shader can affect them.
- Reject the change if validation shows the shader only expands completed SDR swapchain output instead of using a real pre-SDR or graded shader signal.
- If compilation/build is needed, use the smallest existing validation path; do not expand this skill into C++ or addon workflow.
