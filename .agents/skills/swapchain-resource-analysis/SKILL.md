---
name: swapchain-resource-analysis
description: "RenoDX DevKit workflow for tracing swapchain/output passes, SwapChainPass, RGBA8U/UNORM limits, RGBA16F proxy resources, gamma-space float pipelines, HDR10-preferred SDR/HDR output toggles, rare scRGB output encoding, render resources, backbuffer formats, resource upgrades, neutral HDR source preservation, UI/HUD separation, and rejecting inverse-tonemap postprocess approaches. Use when investigating swapchain output, resource formats, final backbuffer shaders, swapchain proxies, AutoHDR/RTX HDR/ReShade FX style inverse tonemap ideas, resource upgrades, or proving where scene HDR data exists before shader-side ToneMapPass work."
argument-hint: "game/frame target, graphics API, suspected final pass/resource, and whether the issue is HDR source proof, proxy/resource upgrade, or inverse-tonemap rejection"
---

# Swapchain and Resource Analysis

Use this skill when the target pass/resource is not proven yet, especially when work starts at final presentation, swapchain output, backbuffer format, or a suspected resource bottleneck. The goal is to trace the render pipeline far enough backward to find real scene/HDR data, prove where destructive SDR mapping happens, and decide whether the fix is shader replacement, resource upgrade, `SwapChainPass`/output-format work, UI separation, or rejection of a postprocess-only approach.

## Related skills and scope

| Need | Use |
|---|---|
| Game folder setup, builds, DevKit launch/linking, metadata, initial scaffold | `setup-game-mod-dev` |
| Proving swapchain/resource formats, final output path, proxy resources, or HDR source location | This skill |
| Editing a proven tonemap/LUT shader target after `untonemapped`/`neutral_sdr`/`graded_sdr` signals are known | `handle-sdr-tonemap-lut` |
| Plotting curves, resource stats, or validation graphs discovered during analysis | `analysis-graphing` |

Do not duplicate setup or shader-math workflow here. Capture only the facts those workflows need.

## Core principle: RenoDX is not inverse tonemapping

RenoDX mods should not be framed as "take the finished SDR frame and inverse-tonemap it." That is the postprocess class of tools such as Microsoft AutoHDR, RTX HDR, and generic ReShade FX filters. Those methods guess missing HDR after the game has already compressed/clipped/graded the image.

RenoDX should instead preserve or recover a real upstream signal:

```text
scene HDR / pre-tonemap composite
-> game exposure, bloom, fades, presentation effects
-> SDR tonemap or hard clip
-> optional LUT/color grade
-> UI/video/composite
-> final output encode / swapchain
```

The preferred RenoDX target is before the destructive SDR step, or at a shader that still receives the upstream signal plus an SDR reference. A final swapchain pass is only a valid target when it still has access to the HDR/pre-SDR resource, handles final color-space/output encode, or is used for verification/UI separation. It is not valid when it only reads the completed SDR backbuffer.

## HDR upgrade model

Treat HDR upgrade work as preservation of range and gamut through the game's real pipeline, followed by an intentional output conversion.

Neutral output is the baseline. Resource upgrades, proxy paths, and swapchain color-space changes should preserve the original SDR art direction while removing proven range/precision limits. Default settings should match the original look as closely as practical. They should not create a default "HDR look" by increasing contrast, saturation, or colorfulness; visual augmentation belongs in explicit sliders or named presets such as `HDR Look`. Rare exceptions need explicit user intent and validation evidence.

| Concept | RenoDX meaning |
|---|---|
| RGBA8U / UNORM limit | Values are confined to `[0, 1]`, cannot carry negative channels for wider-gamut representation, and cap highlights at SDR reference white. |
| Floating-point resource | RGBA16F or similar resources can preserve values above `1.0`, negative channels, smoother gradients, and intermediate post-process precision. |
| Proxy resource | A high-precision intermediate can carry HDR data even when the practical swapchain format is RGB10A2/PQ HDR10 or linear scRGB. A full floating-point swapchain is not always required. |
| Native pipeline compatibility | Many game passes may continue operating in the game's original BT.709/gamma-style domain if the upgraded resources preserve range until the final proxy/output shader. |
| Final output conversion | The final proxy/output shader maps the preserved floating representation to the display path, such as linear scRGB or PQ HDR10. This is forward encoding, not inverse tonemapping. |
| `SwapChainPass` | The shared shader helper `renodx::draw::SwapChainPass(...)` is the standard final proxy/output conversion path when a proven float/intermediate signal reaches presentation. |
| Output preset cbuffer | A per-frame injected preset such as `RENODX_SWAP_CHAIN_OUTPUT_PRESET` / `swap_chain_output_preset` can cheaply select SDR, HDR10, or scRGB behavior without recompiling output shaders. Use named constants in code when available; numeric values are documentation only. |

Use this model to decide whether the mod needs a shader replacement, a resource format upgrade, a swapchain proxy path, or all three.

## Boundaries

- Focus on DevKit draw/resource/swapchain analysis, render-target format decisions, and resource-upgrade planning.
- Use this before `handle-sdr-tonemap-lut` when the shader capture point is unknown or when a final-output hack is being proposed.
- After a shader-side tonemap/LUT target is proven, switch to `handle-sdr-tonemap-lut` for HLSL/Slang math.
- Keep setup/build/link details in `setup-game-mod-dev` unless they are directly needed to prove resource behavior.
- Do not create a RenoDX strategy that only inverse-tonemaps the final SDR swapchain image.
- Do not treat a fullscreen pass as "the tonemap" until draw inputs prove whether it receives HDR scene data, SDR color, UI, video, or an encoded output.

## Expected output from this skill

Produce these sections:

1. **Pipeline classification** - final output format, swapchain color space, final blit/composite, tonemap/LUT/UI/video positions.
2. **Format/proxy plan** - RGBA8U bottlenecks, RGBA16F/proxy needs, final `SwapChainPass`/RGB10A2/PQ or scRGB output path.
3. **Resource chain** - relevant resources/views, formats, bind flags, copies/resolves, and where values are clipped or preserved.
4. **HDR source proof** - draw/resource evidence for the last usable pre-SDR signal and why it is not merely final SDR output.
5. **Target decision** - shader replacement, resource upgrade, `SwapChainPass`/output encode, UI separation, or explicit rejection.
6. **Handoff plan** - exact shader/resource facts to pass to `handle-sdr-tonemap-lut` or C++ addon work.
7. **Verification checklist** - captures, resource readbacks, format checks, UI/video checks, and final HDR output validation.

## Step 1: Classify the final output path

Start at presentation, but use it as a map anchor rather than the default mod target.

| Area | What to identify |
|---|---|
| Swapchain format | `R8G8B8A8_UNORM`, `R10G10B10A2_UNORM`, `R16G16B16A16_FLOAT`, scRGB, HDR10/PQ, or game-specific proxy. |
| UNORM bottleneck | Any RGBA8U/UNORM pass that caps values to `[0, 1]` or prevents negative channels before HDR-critical work is complete. |
| Proxy state | Whether a high-precision proxy/intermediate exists, where it is created, and whether the swapchain itself is only the final presentation target. |
| Output toggle | Whether the mod needs runtime SDR/HDR output switching and which cbuffer preset or setting drives it. |
| Output color space | SDR sRGB/gamma, scRGB linear, PQ/BT.2020, HDR10 metadata path, or unknown. |
| Final draw | Present blit, resolve, post composite, UI composite, tonemap pass, or copy-only path. |
| Inputs to final draw | HDR scene RT, SDR post-tonemap RT, UI/HUD, video, bloom, previous frame, or only backbuffer. |
| Encode step | sRGB write, gamma pow, PQ encode, scRGB scale, RGBM/packed path, or OS/driver conversion. |
| UI/video position | Before tonemap, after tonemap, separate overlay, or already baked into final SDR. |

If the final draw only samples an SDR/UNORM post-tonemap color buffer, do not design an inverse-tonemap mod from that point. Continue backward.

## Step 2: Work backward through draws and resources

Use DevKit snapshots, draw details, and resource analysis to map the chain from swapchain to scene composite.

1. Inspect the last frame draws first, then step backward through fullscreen passes.
2. For each candidate draw, record:
   - shader hash and stage;
   - input SRVs/UAVs and output RTV/UAVs;
   - resource/view format, dimensions, mips, array slices, and bind flags;
   - whether the resource is copied, resolved, cleared, or reused later;
   - blend state and color-write masks.
3. Analyze resource contents before and after suspected destructive passes.
4. Prefer evidence from values/ranges, formats, and shader math together; a resource name or fullscreen triangle alone is not proof.
5. Stop only when you can identify the last useful pre-SDR signal or prove that the game no longer exposes one without earlier resource upgrades.

Useful proof signs for an upstream HDR source:

- float or high-range formats carrying values above SDR white before clamp/encode;
- shader math with exposure, bloom, scene color, or known filmic/hard-clip behavior;
- a later pass clamps/saturates, applies a tone curve, samples a LUT, or writes to UNORM;
- UI/HUD is absent from the candidate source and composited later;
- changing scene exposure/bloom affects the candidate in a physically plausible way instead of merely stretching final SDR pixels.

## Step 3: Identify destructive SDR operations

Classify where information is lost. This determines whether shader replacement is enough or resource upgrades are required.

| Operation | Why it matters |
|---|---|
| `saturate`, `min`, hard clip, UNORM write | Values above SDR range, negative channels, and wider-gamut working values are destroyed. |
| Filmic/ACES/Hable/Reinhard tone curve | HDR dynamic range is compressed into SDR; use shader-side replacement before/at this point. |
| LUT/color grade on SDR input | Grade may need a `graded_sdr` reference or LUT bridge, but it is not an HDR source by itself. |
| Gamma/sRGB encode | Linear-light math after this point is invalid unless decoded, and highlight detail may already be clipped. |
| Dither/quantize/8-bit resolve | Precision is lost; inverse expansion will amplify artifacts. |
| UI/video composite | Must usually stay SDR-shaped and may need a separate path. |
| Copy/resolve to lower format | Upstream shader may be good, but the resource chain needs upgrading. |

## Step 4: Choose a valid RenoDX target

Use the narrowest target that preserves real upstream data.

| Target | Use when | Notes |
|---|---|---|
| Pre-tonemap shader | It receives scene/pre-SDR color and writes SDR. | Preferred handoff to `handle-sdr-tonemap-lut`. |
| Tonemap+grade shader | It has both `untonemapped` and final/graded SDR references. | Use `ToneMapPass(untonemapped, graded_sdr, neutral_sdr)` patterns when appropriate. |
| Resource format upgrade | The right shader exists, but an intermediate RT/copy clamps to SDR/UNORM. | Plan addon-side resource upgrades and verify all aliases/views. |
| Swapchain proxy/output shader | HDR scene is already preserved in a float proxy/intermediate and only final `SwapChainPass` scRGB/PQ/output conversion is missing. | Valid final-pass work, not inverse tonemapping. |
| UI/HUD split | UI is composited before/inside tonemap or contaminated by HDR path. | Keep UI SDR-shaped while scene uses HDR. |
| Reject final-only inverse | Only final SDR backbuffer/color buffer is available. | Report as AutoHDR/RTX HDR/ReShade FX class, not RenoDX. |

The final swapchain pass can be edited only if draw inputs prove it is still part of the real game pipeline. A pass that reads a completed SDR frame and applies an inverse curve is not a RenoDX tonemap replacement.

For new game mods, prefer an HDR10/PQ output path with an SDR/HDR toggle. The internal render/proxy path may still use RGBA16F or similar resources to preserve HDR-critical values, but that does not mean the public output mode should default to scRGB. Treat scRGB as a rare output choice for specific compatibility or integration needs.

### Swapchain proxy conversion checklist

Use a swapchain proxy/output shader only after the resource chain proves a high-precision signal survives to that point.

[Swapchain proxy pixel shader snippet](./snippets/swapchain_proxy_pixel_shader.hlsl) shows the intended thin `SwapChainPass` shape. Treat it as a starting point after proof, not as evidence that final SDR output is a valid HDR source.

- Prefer `renodx::draw::SwapChainPass(...)` in the proxy pixel shader when the final pass is just the shared output conversion for a proven intermediate signal.
- Drive `SwapChainPass` with a compact injected preset when the mod exposes an SDR/HDR output mode. In current shared shader code the preset mapping is `-1` none, `0` SDR, `1` HDR10, `2` scRGB; prefer named constants/macros over raw numbers when editing shader code.
- Prefer the HDR10 preset for HDR mode and the SDR preset for SDR mode. Use the scRGB preset only when a concrete compatibility or integration requirement needs it.
- Treat HDR10 swapchain selection as a facilitator for the feature, not proof that the frame is HDR. Coordinate target format, DXGI color space, `SwapChainPass` preset, and user output mode together.
- For an SDR/HDR toggle on an HDR10-capable path, the SDR mode may still use the upgraded/proxy machinery but should select the SDR preset and SDR color space; HDR mode should select the HDR10 preset and HDR10 color space.
- For a scRGB path, select the scRGB preset and extended linear color space when the target format/proxy path is float/scRGB-compatible.
- Prefer a RGBA16F or equivalent proxy/intermediate for HDR-critical rendering when RGBA8U would clip values or quantize gradients.
- Do not require a floating-point swapchain just because the working pipeline is floating-point; the proxy can encode into RGB10A2/PQ HDR10 or linear scRGB at the end.
- Preserve the game's expected gamma or sRGB-domain behavior where practical, then handle known gamma mismatches in the final proxy/output shader.
- Convert deliberately to the final display representation: linear scRGB for wide-gamut linear HDR paths, or PQ/HDR10 for HDR10 paths.
- Keep the proxy shader focused on format/color-space encoding and final scaling. Do not hide a final-SDR inverse tonemap inside it.
- Verify whether UI/HUD/video are already composited into the proxy input; if so, separate or independently scale them before final output when possible.

### Output preset and color-space synchronization

When a mod supports an SDR/HDR output toggle, the swapchain state and shader preset must move together.

| Output mode | Typical shader preset | Typical swapchain/color-space state | Notes |
|---|---|---|---|
| SDR | `SWAP_CHAIN_OUTPUT_PRESET_SDR` / `0` | SDR/sRGB color space, even if the proxy path remains enabled. | Keep SDR output available for compatibility and comparisons. |
| HDR10 | `SWAP_CHAIN_OUTPUT_PRESET_HDR10` / `1` | RGB10A2-style target with HDR10/ST2084 color space. | PQ encode happens in `SwapChainPass`; do not inverse-tonemap SDR. |
| scRGB | `SWAP_CHAIN_OUTPUT_PRESET_SCRGB` / `2` | Float/scRGB-compatible path with extended linear color space. | Rare path for frame generation, integrations, or compatibility cases that specifically need RGBA16F/scRGB behavior. |

Prefer a cbuffer-driven preset for per-frame toggles because it is cheap, works with one proxy shader, and can be updated from `OnPresent` after the mod knows the current user output mode and swapchain target. Avoid baking the user's SDR/HDR choice into static shader variants unless the game already requires separate output shaders.

[Swapchain output sync snippet](./snippets/swapchain_output_sync.cpp) shows the C++ runtime pattern used by high-quality addons: update the injected output preset and queue the matching swapchain color space together during presentation.

Keep `SwapChainPass` work here scoped to output conversion and runtime state synchronization. If the next task is changing a proven game tonemap/LUT shader, hand off to `handle-sdr-tonemap-lut`; if the next task is wiring the addon/build/deploy path, hand off to `setup-game-mod-dev`.

## Step 5: Plan resource upgrades carefully

When the analysis proves a format/resource bottleneck, plan addon work around the actual resource lifetime.

- Upgrade every relevant create/copy/resolve alias in the chain, not just the final view that looked clipped.
- Preserve dimensions, mips, arrays, sample count, bind flags, clear values, and typeless compatibility unless the change is required and verified.
- Track SRV/RTV/UAV view formats separately from resource formats.
- Verify barriers/states and copy paths still make sense after a format upgrade.
- Confirm the upgraded format actually preserves values above `1.0`, negative channels when needed, and reduced banding through the relevant post-process chain.
- Re-check all consumers of the upgraded resource, especially UI/video/composite passes that may expect SDR or UNORM.
- Use clone/hotswap only as a DevKit proof; move proven upgrades and shader registrations into the game addon before treating the mod as real.
- Capture original and upgraded resource outputs at the same draw before judging the visual result.

## Step 6: Handoff to shader-side tonemap/LUT work

Once a shader target is proven, pass these facts into `handle-sdr-tonemap-lut`:

| Fact | Why the shader workflow needs it |
|---|---|
| `untonemapped` signal | The real scene/pre-SDR color feeding RenoDRT/PsychoV. |
| `neutral_sdr` signal | Vanilla neutral baseline, especially for hard-clip/no-tonemap games. |
| `graded_sdr` signal | SDR after LUT/color grade/masks when preserving final SDR look. |
| Resource formats | Needed to know where values are linear, clipped, encoded, or quantized. |
| LUT/color grade location | Determines whether the grade is a reference, a bridge, or unrelated. |
| UI/HUD/video position | Prevents accidental HDR expansion of SDR overlays. |
| Output encode | Determines whether shader writes linear HDR, scRGB, PQ, or engine-native color. |
| UI/render scaling | Determines whether game render and UI need independent brightness/scaling before final composition. |
| Output preset source | The setting/cbuffer field that selects SDR, HDR10, or scRGB for `SwapChainPass`. |

If any of these facts are missing because the only known signal is final SDR output, continue resource analysis instead of inventing an inverse.

## Validation checklist

- Prove the candidate source with resource readback before replacement.
- Compare original vs baseline replacement at the same draw before custom HDR changes.
- Show where values above SDR white exist or explain why resource upgrade is required to preserve them.
- Show whether the chain needs negative-channel support for wider-gamut output or only luminance headroom above `1.0`.
- Verify UI/HUD/video/menu paths do not get unintended inverse-tonemap expansion.
- Verify any proxy/output shader performs only intentional gamma/scRGB/PQ conversion and final scaling.
- Verify the default output remains neutral against the vanilla SDR reference; extra contrast/saturation must be opt-in through sliders or named presets, not baked into the resource/output path.
- Verify the SDR/HDR toggle updates both the injected output preset and the swapchain color space/target state.
- Verify scene highlights respond to game exposure/bloom/settings as upstream data, not as final-frame heuristics.
- Verify the final swapchain/output mode and color space match the selected RenoDX mode.
- Document any rejected final-only approach explicitly as "not RenoDX; postprocess inverse tonemap class."

## Common anti-patterns

| Anti-pattern | Why to reject it | Correct direction |
|---|---|---|
| Fullscreen ReShade-style inverse curve on final SDR | Reconstructs guessed HDR after clipping/compression. | Find the pre-tonemap shader/resource. |
| Editing only the Present/backbuffer pass | Usually sees UI/video and finished SDR, not scene HDR. | Work backward through draw inputs. |
| Calling an inverse ACES/Reinhard curve "tonemapping" | Tonemapping is the forward HDR-to-display mapping; inverse expansion is a heuristic. | Replace or extend the actual forward tonemap. |
| Multiplying final SDR by peak nits | Brightens SDR and expands artifacts; it does not recover lost highlights. | Preserve HDR before SDR encode or upgrade the clamped resource. |
| Treating a LUT as the HDR source | SDR LUT output is a grade/reference, not scene dynamic range. | Use LUT as `graded_sdr` or bridge around it. |
| Ignoring UI/HUD/video | Postprocess inverse tonemap over-expands overlays and menus. | Separate or preserve SDR overlay paths. |
| No original resource capture | Visual screenshots alone cannot prove the source domain. | Analyze resources and baseline replacements. |

## Committed RenoDX swapchain examples

Use these as references for concepts, not copy-paste templates.

| Game | Useful swapchain/output pattern |
|---|---|
| `starfield` | Uses a thin proxy pixel shader around `renodx::draw::SwapChainPass(t0.Sample(...))`, an injected `swap_chain_output_preset` cbuffer value for SDR/HDR10/scRGB output selection, and runtime color-space synchronization so HDR10 can facilitate the output feature while SDR mode remains available. |

## Useful references

- `docs/DEVKIT_MCP.md` - DevKit/MCP draw, shader, and resource inspection workflow.
- `setup-game-mod-dev` - local build, DevKit, game-folder link, dump/decompile, and baseline setup.
- `handle-sdr-tonemap-lut` - shader-side RenoDRT/PsychoV/LUT bridge once a valid target is proven.
