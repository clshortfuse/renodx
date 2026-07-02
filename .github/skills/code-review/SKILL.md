---
name: code-review
description: "RenoDX pull request code review checklist for HDR/SDR matching, neutral defaults, tonemap/LUT shaders, SDR LUT clipping/domain mistakes, renodx::lut tooling, SwapChainPass, HDR10-preferred SDR/HDR output toggles, rare scRGB paths, resource upgrades, inverse-tonemap rejection, vanilla look preservation, actionable review comments, mod PR scope hygiene, unrelated core files, and sensible commits. Use when performing Copilot code review."
---

# RenoDX Code Review Skill

Use this skill when reviewing RenoDX pull requests. Apply it together with root `AGENTS.md`, the nearest nested `AGENTS.md`, `.agents/skills/swapchain-resource-analysis/SKILL.md`, and `.agents/skills/handle-sdr-tonemap-lut/SKILL.md` when relevant.

## Review stance

Copilot review should comment when a PR is technically buildable but violates RenoDX HDR behavior. Do not let a PR pass silently just because it compiles if the mod changes the default look, clips HDR through SDR, or treats the final swapchain frame as an HDR source.

Review comments should be helpful and actionable: name the risky behavior, explain the missing proof or invariant, and suggest a concrete RenoDX pattern to employ. Mentioning another mod can be useful when pointing to a specific file, bridge, or technique, but do not assume every existing mod is high quality or treat a mod name as proof by itself.

Every Copilot code review must include a `RenoDX review checklist` section in the review body. Do not leave a review without the checklist. Mark each relevant item as `Pass`, `Needs comment`, or `N/A`; leave actionable comments for every `Needs comment` item.

## Required review checklist

- PR scope and commits are tidy: mod PRs are mostly target game/mod changes plus required shared support.
- Review comments are helpful: each issue explains the risky behavior or missing proof and suggests a concrete RenoDX pattern.
- Defaults preserve the original/vanilla look as closely as practical; extra HDR look, contrast, saturation, or brightness is opt-in.
- Preset Off/reset and Vanilla/0 behavior are clear; Vanilla/0 is not treated as full Off if grading/effects remain active.
- The PR does not implement final-frame inverse tonemapping from a completed SDR swapchain/backbuffer.
- Tonemap/LUT shaders prove the `untonemapped`, `neutral_sdr`, and `graded_sdr` signals used by `ToneMapPass` or `UpgradeToneMap`.
- `ToneMapPass`, PsychoV, and other tonemappers receive linear input; encoded/gamma/sRGB values are decoded before tonemapping.
- Vanilla LUT paths prove their domain, sampling, masks/strength/scaling, and HDR bridge/reconstruction strategy.
- Hard clips, `saturate`, UNORM writes, or lower-format copies do not destroy HDR range before HDR-critical work is complete, except scoped Vanilla/0 resource-clamp emulation.
- `SwapChainPass` is only final output encoding for a proven intermediate, not hidden tonemap replacement, LUT reconstruction, or inverse SDR expansion.
- Output mode prefers HDR10/PQ with an SDR/HDR toggle; scRGB is used only for rare, justified compatibility or integration cases.

## Must-comment issues

Leave a review comment when changed code does any of the following:

- Makes the default output more contrasty, more saturated, brighter, or more stylized than vanilla without an explicit opt-in slider or named preset such as `HDR Look`.
- Uses HDR headroom as a reason to redesign the image instead of matching the original/vanilla look as closely as practical at default settings.
- Starts from the completed SDR swapchain/backbuffer and applies an inverse curve, peak-nits multiplier, AutoHDR/RTX HDR/ReShade-style expansion, or similar final-frame heuristic.
- Feeds an SDR LUT from a hard-clipped/log-shaped HDR or pre-LUT scene signal (`saturate`, `min(max(...), 1)`) and then uses the sampled LUT result as output or `graded_sdr` without a matching explicit `neutral_sdr` or reconstruction. Two-argument `ToneMapPass(untonemapped, graded_sdr)` is not enough proof when the LUT input was a different clipped SDR baseline.
- Treats a hard clip or `saturate` neutral as a complete LUT bridge when the clip collapses saturated highlights to white or wrong hues. For visible hard-clip-to-LUT behavior, expect Wobbly Life-style max-channel/gamut compression and reconstruction or Silksong-style selective hue/saturation clip emulation.
- Leaves a game LUT as an afterthought: a raw sample, skipped LUT, or unchanged sampler path may be valid vanilla preservation, but review should check for missing LUT-domain proof, `renodx::lut::Config` setup, strength/scaling, masks/blends, SDR bridge, or HDR reconstruction.
- Assumes a raw LUT sample is enough when the vanilla path uses packed 2D sampling, tetrahedral sampling, masks, strength, scaling, generated LUTs, user LUTs, sRGB/gamma domains, PQ/HDR/log domains, or multiple LUT draws.
- Assumes a vanilla SDR LUT uses linear input without proof. Most vanilla LUTs are sRGB/gamma-domain; encoded values must not be fed directly into `ToneMapPass` or any tonemapper.
- Uses raw `saturate(untonemapped)` or an equivalent hard clip of the HDR source as `neutral_sdr`, a LUT bridge, or proof that a hard-clip/no-tonemap path is handled. This does not include a Vanilla/0 path deliberately emulating the original RGBA8U/UNORM resource clamp after a resource upgrade.
- Feeds encoded/gamma/sRGB color into `ToneMapPass`, PsychoV, or another tonemapper instead of decoding to linear first.
- Treats `ToneMapPass` with `RENODX_TONE_MAP_TYPE == 0` / Vanilla as a full Off preset while user grading, HDR-look controls, or custom effect overrides remain active.
- Replaces a real upstream signal with `ToneMapPass` or PsychoV without preserving required vanilla presentation effects such as exposure, bloom, fades, vignette, LUT masks, grade strength, or output-domain expectations.
- Adds `saturate`, `min`/`max`, UNORM resolves, or lower-format copies before HDR-critical work is complete, destroying values above SDR white, negative channels, or precision. Do not confuse this with a vanilla `saturate` after an already-tonemapped value that only trims small overflow, or a Vanilla/0 path that restores the original RGBA8U/UNORM clip after a resource upgrade.
- Uses `SwapChainPass` on a final SDR buffer as if it proves HDR. `SwapChainPass` is valid final encoding only after a high-precision intermediate or real pre-SDR signal is proven.
- Defaults to scRGB or a floating-point swapchain output without a rare-case justification, or omits an SDR/HDR output toggle when an HDR10/PQ path is viable. A float proxy/intermediate is not by itself a reason to expose scRGB as the primary output mode.
- Lets unrelated files creep into a mod PR: scratch files, generated/debug artifacts, unrelated global CMake/CI/vendor changes, core/shared utility edits without a clear dependency, or changes from another game/mod. Multiple commits are fine, but the PR and each commit group should be coherent and reviewable.

## Expected review evidence

Prefer comments that identify the missing proof or preservation step:

- Which signal is the real `untonemapped`, `neutral_sdr`, or `graded_sdr` source?
- Where does vanilla clamp, tonemap, LUT, color grade, or encode to SDR?
- Does the default path match original SDR black, midgray, highlight rolloff, saturation, and grade?
- Is visual augmentation opt-in through sliders/presets, or baked into the baseline?
- Does the LUT bridge compress/map to the LUT's SDR domain instead of simply clipping, then preserve the vanilla LUT result while reconstructing HDR/reference range?
- Immediately before each vanilla LUT sample, is the input hard-clipped by `saturate`, `min(max(...), 1)`, or an equivalent log shaper? If so, does the PR avoid raw hard clip as a `neutral_sdr` substitute and instead use an engineered LUT-domain proxy, reconstruction path, or proven reference baseline?
- Is the `saturate` before/after a tonemap or inside Vanilla/0 resource-clamp emulation? Trimming small overflow after a vanilla tonemap or preserving the original RGBA8U/UNORM clamp in Vanilla/0 is expected; clipping `untonemapped`/HDR before a LUT or `ToneMapPass` is the problem.
- If hard clipping feeds a LUT, what preserves hue and saturation that would otherwise clip to white or wrong hues: max-channel/N2 scaling, gamut compression, selective hue/saturation clip emulation, or another proven bridge?
- Does replacement LUT sampling use `renodx::lut::Config`/`renodx::lut::Sample` or explicitly justify direct `Texture.Sample` to preserve exact vanilla addressing?
- Is LUT centering/half-texel/packed-strip addressing preserved as sampling fidelity without being mistaken for the vanilla grade itself?
- Are LUT inputs/outputs in their proven domain, usually sRGB/gamma for vanilla SDR LUTs, and decoded back to linear before `ToneMapPass`?
- If `ToneMapPass` runs with Vanilla/0, is that intentionally using the vanilla process as the tonemap while allowing user grading, and is there a Preset Off/reset path to true vanilla as closely as practical?
- If the PR uses PsychoV on a game with a LUT, does it use a modern bridge like Starfield/Wobbly Life: move PsychoV output into neutral SDR/LUT space, apply the grade, then reconstruct before final output?
- Do resource formats preserve values above `1.0`, negative channels when needed, and precision until final output?
- If another mod is cited as an example, is the cited pattern specific and relevant, rather than implying the whole mod is authoritative?
- Does the output path prefer HDR10 with a clear SDR/HDR toggle, synchronized color space, and injected output preset? If scRGB is used, what rare compatibility or integration reason requires it?
- Does the changed-file list match the PR's mod scope? Are core/shared files, generated files, scratch/debug artifacts, and unrelated game folders justified by the implementation?
- Are multiple commits sensibly organized by topic, or do they mix unrelated cleanup/core changes with the mod work?

## Correct directions to suggest

- Use `renodx::draw::ToneMapPass(untonemapped, graded_sdr, neutral_sdr)` when the vanilla neutral baseline must be explicit.
- Use `ComputeUntonemappedGraded(...)` or a current graded `ToneMapPass` path instead of direct legacy `UpgradeToneMap` when viable.
- If the vanilla LUT path hard-clips or log-shapes into SDR, do not accept `saturate(untonemapped)` as `neutral_sdr`; use a safe LUT-domain proxy/reconstruction path, or a three-argument `ToneMapPass` only when `neutral_sdr` is an engineered/proven reference baseline that matches the grade path.
- Do not rely on hard clip alone when it damages hue/saturation before a LUT; use max-channel/N2 plus gamut compression/reconstruction where appropriate, or selectively emulate vanilla hue/saturation clip effects when those effects are intentional.
- Use `ToneMapPass` with tone map type Vanilla/0 when the game's vanilla process should remain the tonemap and RenoDX only supplies optional user grading; provide a Preset Off or equivalent reset that disables custom grading/effects and returns as close to true vanilla as resource upgrades allow.
- Keep explicit RGBA8U/UNORM clamp emulation scoped to Vanilla/0 or Preset Off preservation paths; do not reuse that clipped value as `neutral_sdr`, a LUT proxy, or a non-vanilla HDR bridge.
- For SDR LUTs, compress the proven HDR/reference signal into a neutral SDR/LUT-domain proxy, sample the vanilla LUT in its real domain, usually sRGB/gamma, preserve masks/strength/scaling, decode to linear when needed, then reconstruct or feed a graded `ToneMapPass` path.
- Preserve LUT centering/addressing as sampling fidelity, but review grading and HDR bridge correctness separately.
- Decode encoded/gamma values before `ToneMapPass`, PsychoV, or any tonemapper; encode only for a proven encoded LUT domain or output path.
- For modern PsychoV paths on LUT-heavy games, follow the Starfield/Wobbly Life shape: compute the PsychoV HDR result, compress it into neutral SDR/LUT space with max-channel and/or gamut compression, apply the vanilla LUT/effects, then reconstruct HDR/reference range before final output.
- When referencing another mod, point to the specific pattern being recommended, such as a max-channel/gamut-compressed LUT bridge or selective clip-emulation path, and explain why that pattern fits this PR. Do not ask authors to copy a mod wholesale.
- Prefer `renodx::lut::Config` with explicit `type_input`, `type_output`, size/precompute, strength/scaling, and sampling selection; use direct texture sampling only when matching a proven vanilla packed/offset path.
- For simple games without meaningful LUT/effect complexity, a straightforward graded `ToneMapPass` path can still be the right answer.
- Move final scRGB/PQ/HDR10 conversion to a thin proxy/output shader using `renodx::draw::SwapChainPass(...)` only after source/resource proof.
- Prefer HDR10/PQ output with an SDR/HDR toggle using the swapchain-resource-analysis output preset synchronization pattern. Keep scRGB available only for rare cases that need it, such as a specific integration or compatibility requirement.
- Keep creative controls default-neutral and expose non-neutral looks as sliders or presets rather than baseline behavior.
- Keep mod PRs focused on the relevant game/mod plus required shared support. Ask to split unrelated core, CI, vendor, cleanup, or other-game changes into separate PRs, and keep commits tidy enough that each commit has a clear purpose.