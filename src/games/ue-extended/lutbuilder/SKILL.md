---
name: ue-extended-lutbuilder
description: >-
  Inject or port Unreal Engine LUT builder shaders (`lutbuilder_0x*.hlsl`) for the
  ue-extended mod using ProcessLutbuilder, lutbuilderoutput.hlsli, unnamed cbuffers,
  ExpandGamut defaults, SDR LUT weights, and mobile tonemapper skips. The user
  specifies where to look (folder, paths, or hashes); batch edits within that
  lutbuilder scope are fine. Ask only when the lookup location is missing.
argument-hint: "[folder or lutbuilder hash(es)/paths the user pointed at — ask if missing]"
---

# UE-Extended LUT Builder Injection

Shared injection helpers live under `src/games/ue-extended/lutbuilder/` ([lutbuilderoutput.hlsli](lutbuilderoutput.hlsli), [lutbuildercommon.hlsli](lutbuildercommon.hlsli), [scripts/lutbuilder.py](scripts/lutbuilder.py)).

**Scope:** `lutbuilder_0x*.hlsl` only. The user tells you **where to look** (directory, `@` path, hash list, or glob). Work within that lutbuilder scope — including batch edits across every matching file there. Do not pick a folder on your own when the user did not say where.

For generic `src/games/unrealengine/lutbuilders/` work, hand off to the `ue-lutbuilder-injection` skill.

## Before starting — get the lookup location

**Applies to lutbuilder shaders only.** Batch work is allowed once the user has pointed at where to look.

Use an explicit user message, `@`-attached path, or folder they name. If none of that is present, **ask**:

1. **Where to look** — directory, file path(s), hash list, or glob (e.g. `temp/sm6/`, `@src/games/foo/lutbuilder/`, `0x670070BD` + `0x94D26E3A`).
2. **Optional:** which game — for context and include paths, not as a substitute for (1).

If the user says “port lutbuilders” with no location, ask where the files are. Do **not** silently default to `lutbuilder/sm6/`, `temp/`, or “all lutbuilders in the repo”.

Within the user-specified location, process **all** relevant `lutbuilder_0x*.hlsl` files there (batch inject, audit, fix) unless the user narrows the list. Manual dead-code verification still applies **per file** after batch changes.

## Reference shaders

These are **canonical examples in the repo library** (`src/games/ue-extended/lutbuilder/`). Use them to pick SM5 vs SM6, PS vs CS, and LUT count patterns — not as implied targets for every task.

| Target | Reference |
|--------|-----------|
| SM5 (3Dmigoto / named cbuffer, 4 SDR LUTs) | [sm5/lutbuilder_0xCD2A823A.ps_5_x.hlsl](sm5/lutbuilder_0xCD2A823A.ps_5_x.hlsl) |
| SM6 (DXC / named cbuffer, 3 SDR LUTs) | [sm6/lutbuilder_0x670070BD.ps_6_6.hlsl](sm6/lutbuilder_0x670070BD.ps_6_6.hlsl) |
| SM6 minimal HDR / no grading | [sm6/lutbuilder_0xCBCF8905.ps_6_6.hlsl](sm6/lutbuilder_0xCBCF8905.ps_6_6.hlsl) |

Shared helpers live in [lutbuilderoutput.hlsli](lutbuilderoutput.hlsli) and [lutbuildercommon.hlsli](lutbuildercommon.hlsli).

Preflight automation: single script [scripts/lutbuilder.py](scripts/lutbuilder.py) (`check`, `fix-weights`, `convert-temp`). **Scripts check structural wiring only** (undeclared `cb0[N]` slots, missing LUT weights). Blue/tone fingerprint verification is manual — scripts cannot replace step-by-step tracing below.

## Quick flow

0. Use the folder/paths/hashes the user gave; ask if the lookup location is missing (lutbuilders only).
1. Pick the closest reference shader (SM5 vs SM6, PS vs CS, LUT count).
2. Add `#include` for [lutbuilderoutput.hlsli](lutbuilderoutput.hlsli) at the top — adjust `../` depth for **the target file’s directory**, not a fixed `sm5/`/`sm6/` layout.
3. Identify cbuffers from **shader usage**, not packoffset order alone (see below).
4. Apply forced defaults: ExpandGamut `0`, missing BlueCorrection `0`, missing ToneCurveAmount `1`.
5. Force ExpandGamut off in shader math (see below).
6. Inject at **untonemapped AP1** (after color grade, before blue correction / film tonemap), call the correct `ProcessLutbuilder` overload, then `return`.
7. Leave all code after the early `return` untouched (dead vanilla path).
8. Apply regex extras (below) where relevant.
9. Patch every duplicated block in the file, not just the first copy.

## Mobile tonemapper

Some lutbuilders have `bUseMobileTonemapper`. **Completely ignore that path.**

- Do not inject into, patch, or wire mobile-tonemapper branches.
- Inject and return **before** the mobile / desktop fork (see CD2A823A: injection at untonemapped AP1, `return` before `[branch] if (bUseMobileTonemapper != 0)`).
- Do not try to preserve or emulate mobile tonemap behavior.

## Missing cbuffer fields

When the shader has no named field in its cbuffer declaration:

| Field | Force to | Meaning |
|-------|----------|---------|
| `BlueCorrection` | `0.f` | No blue correction |
| `ToneCurveAmount` | `1.f` | No tone-curve attenuation |

Examples:

```hlsl
cb_config.ue_bluecorrection = 0.f;   // shader has no BlueCorrection cbuffer member
cb_config.ue_tonecurveammount = 1.f; // shader has no ToneCurveAmount cbuffer member
```

When named members exist, pass them through normally.

## Unnamed cbuffers (`cb0[N]`)

**Never assume. Always double-check.** Do **not** copy `cb_config` assignments from another hash, from packoffset order, from a batch script template, or by inferring blue/tone as `output_index + 1`.

The `lutbuilder.py convert-temp` helper (optional batch step) strips ue-generic hooks for **user-confirmed** staging files. **`cb0[N]` cbuffers still require per-shader dead-code mapping by hand** before promoting into a game or library folder. There is no supported per-hash mapping table — every slot must be traced in dead code.

### Mandatory verification workflow

1. List every `cb0_*` member **declared** in the shader's `cbuffer cb0` block.
2. Read the **dead code after your early `return`** (vanilla path) and trace each semantic:
   - **Film curve** — find `(cb0_* + 1.0f) - cb0_*` (black/toe) and `cb0_* + 1.0f` (white clip). Compare against [sm6/lutbuilder_0x7A55D23A.cs_6_6.hlsl](sm6/lutbuilder_0x7A55D23A.cs_6_6.hlsl) standard layout only as a *pattern*, not a default map.
   - **Blue correction** — matrix delta multiplied by the same `cb0_*` on all three channels (`cb0[N].xxx * delta + color` or `.zzz`), **before film tonemap** (right after the AP1→working-space dot products). The `0.938639…` dot constants often appear nearby but are optional; the `cb0[N].xxx *` multiply is the reliable fingerprint. Do **not** take the first `cb0_*` after a `0.930000007` lerp — that is usually **ToneCurveAmount**.
   - **ToneCurveAmount** — `(cb0_* * (max(0.0f, (lerp(..., 0.9300000071525574f))) - _xxx)) + _xxx`, or the equivalent `lerp(..., 0.930000007)` then `cb0[N].xxx * r… + base` **before** the next `dot(float3(1.70505154, …)` AP1→709 block. Do **not** confuse with FilmWhiteClip (`cb0_* + 1.0f` in the film block).
   - **MappingPolynomial** — quadratic `(y + (x * t) * t) + z` (channel order varies).
   - **ColorScale** — per-channel multiply before/inside the polynomial.
   - **OverlayColor** — `((cb0_rgb - _graded) * cb0_weight) + _graded` or `lerp(..., cb0_rgb, cb0_weight)`.
   - **Output device** — `if (cb0_* == 0)` switch / compare, not a color-scale channel.
3. Every `cb0_*` / `cb0[N].*` in your `cb_config` block and `ProcessLutbuilder` output argument must exist in step 1 **and** appear as `cb0[N].x|y|z|w` in live or dead shader body (not only in the injection block). `lutbuilder.py check` verifies declared `cb0_*` fields match injection usage.
4. If the shader uses a LUT `ProcessLutbuilder` overload (`Samplers_1`, `Textures_1`, …), trace LUT weight slots in dead code and set `cb_config.ue_lutweights` (see SDR LUTs section).
5. Run `python scripts/lutbuilder.py check` — preflight for declared `cb0_*` / `cb0[N].*` fields and missing LUT weights **only**. Blue/tone fingerprints require manual dead-code review per the workflow above.

### Known layout variants (fingerprints in dead code)

These are **examples verified in this repo**, not defaults to apply blindly:

| Fingerprint in dead code | Film black / toe / shoulder / slope / white | ToneCurve | Blue | Mapping | ColorScale | Overlay | Output |
|--------------------------|---------------------------------------------|-----------|------|---------|------------|---------|--------|
| Standard (`7A55D23A`) | `038x` / `037z` / `037w` / `037y` / `038y` | `037x` lerp | `036z` matrix | `039x,y,z` | `014x,y,z` | `013*` | `040w` or named |
| White at `038x` (`F6219091`) | `037w` / `037y` / `037z` / `037x` / `038x` | `036w` lerp | `036y` matrix | `039x,y,z` | `014x,y,z` | `013*` | `040w` |
| Shifted c036 (`4CEC5329`) | `036w` / `036y` / `036z` / `036x` / `037x` | `066z` lerp | `066x` matrix | `026x,y,z` | `042y,z,w` | `043*` | `065z` |
| SPIRV Hogwarts (`47B97270`) | `036w` / `036y` / `036z` / `036x` / `037x` | `067y` after `0.93` | `066w` matrix (pre-film) | `026x,y,z` | `042y,z,w` | `043*` | `065z` |
| Film c040/c041 (`D07B008F`) | `041x` / `040z` / `040w` / `040y` / `041y` | `037x` lerp | `036z` matrix | `042x,y,z` | `014x,y,z` | `013*` | `040w` |
| Film c039/c040 (`3028EBE7`) | `040x` / `039z` / `039w` / `039y` / `040y` | `039x` lerp | `038z` matrix | `041x,y,z` | `014x,y,z` | `013*` | `040w` |
| Extended `074.x` (`425022C1`) | `036w` / `036y` / `036z` / `036x` / `037x` | `075x` after `0.93` | `074z` matrix (pre-film) | `026x,y,z` | `044y,z,w` | `045*` | `074x` |
| Extended `074.z` (`03F2231B`) | `036w` / `036y` / `036z` / `036x` / `037x` | `075z` after `0.93` | `075x` matrix | `026x,y,z` | `051y,z,w` | `052*` | `074z` |
| Film c030/c031, no blue/tone (`18639D8F`) | `030w` / `030y` / `030z` / `030x` / `031x` | *(none — use `1.f`)* | *(none — use `0.f`)* | `020x,y,z` | `036y,z,w` | `037*` | `059z` |

**Extended buffer (`cb0[74]` / `cb0[75]`) — output device component matters.** Blue and tone slots are **not** interchangeable between `asuint(cb0[74].x)` and `asuint(cb0[74].z)` layouts. Read the **output device component** (`074.x` vs `074.z`) first, then trace dead code — **never infer tone/blue from `output_index + 1` alone** (e.g. output at `059.z` does **not** imply blue/tone at `060.*` when the cbuffer ends at `059`).

| Output device | Blue (`ue_bluecorrection`) | Tone (`ue_tonecurveammount`) | Reference |
|---------------|----------------------------|------------------------------|-----------|
| `cb0[74].x` | `cb0[74].z` (pre-film matrix at AP1 dots) | `cb0[75].x` (after `0.930000007` lerp) | [sm5/lutbuilder_0x425022C1.ps_5_x.hlsl](sm5/lutbuilder_0x425022C1.ps_5_x.hlsl) |
| `cb0[74].z` | `cb0[75].x` | `cb0[75].z` | [sm5/lutbuilder_0x03F2231B.ps_5_x.hlsl](sm5/lutbuilder_0x03F2231B.ps_5_x.hlsl) |

If the fingerprint does not match any row, map field-by-field from dead code and add a comment in the injection block noting the hash-specific layout. **Do not rely on scripts to verify blue/tone fingerprints** — they produce false positives on vanilla film tonemapper code. Always trace manually per SKILL.md workflow

Always disable expand-gamut in the **shader body**, not only in `cb_config`.

### SM5 pattern

Look for the luminance-squared term followed by `ExpandGamut` or `cb0[…].w * r0.w`, then `-4 * r0.w`. We mostly look for the `-4`, but double-check context.

```hlsl
// ExpandGamut set to 0
// r0.w = cb0[36].w * r0.w;
r0.w = 0.f * r0.w;

r0.w = -4 * r0.w;
```

See [sm5/lutbuilder_0x9D920519.ps_5_x.hlsl](sm5/lutbuilder_0x9D920519.ps_5_x.hlsl).

### SM6 pattern

Look for:

```hlsl
(1.0f - exp2(((_L * _L) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(...) * -4.0f))
```

Comment the original line and replace `ExpandGamut` with `0.f`:

```hlsl
// float _161 = (1.0f - exp2(((_143 * _143) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_147, _148, _149), float3(_147, _148, _149)) * -4.0f));
float _161 = (1.0f - exp2(((_143 * _143) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_147, _148, _149), float3(_147, _148, _149)) * -4.0f));
```

See [sm6/lutbuilder_0x2A6D42BB.cs_6_6.hlsl](sm6/lutbuilder_0x2A6D42BB.cs_6_6.hlsl) and [sm6/lutbuilder_0x2231E33C.ps_6_6.hlsl](sm6/lutbuilder_0x2231E33C.ps_6_6.hlsl).

## SDR LUTs and `ue_lutweights`

Some lutbuilders sample external SDR LUT textures. There can be up to **4** LUTs. Count active LUT texture/sampler pairs in the shader, then wire the correct `ProcessLutbuilder` overload from [lutbuilderoutput.hlsli](lutbuilderoutput.hlsli) and pack weights into `cb_config.ue_lutweights`.

**Weight slot count = LUT count + 1** (base/direct path plus each LUT):

| SDR LUTs | Weight components used | `lutweights` packing |
|----------|------------------------|----------------------|
| 0 | — | omit `ue_lutweights` / use no-LUT overload |
| 1 | `xy` | `float4(asfloat(w0), asfloat(w1), 0.f, 0.f)` in `[0]` |
| 2 | `xyz` | `float4(asfloat(w0), asfloat(w1), asfloat(w2), 0.f)` in `[0]` |
| 3 | `xyzw` | `float4(asfloat(w0..w3))` in `[0]` |
| 4 (max) | `xyzw` + `x` | `[0] = float4(w0..w3)`, `[1].x = w4` |

Example (1 LUT, unnamed cbuffer — trace `cb0_005x`/`cb0_005y` in dead LUT lerp):

```hlsl
float4 lutweights[2] = { float4(asfloat(cb0_005x), asfloat(cb0_005y), 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
cb_config.ue_lutweights = lutweights;  // Only lutweights[0].xy is used
```

**Mandatory when using a LUT `ProcessLutbuilder` overload:** if the shader samples a LUT texture (`Textures_1` or `t0`, etc.), the injection block **must** set `cb_config.ue_lutweights` and call the matching LUT overload. Trace weight slots from dead code — two common unnamed patterns:

```hlsl
// Textures_1 / Samplers_1 — dead tail: ((lerp_lut * cb0_005y) + (cb0_005x * direct))
float4 lutweights[2] = { float4(asfloat(cb0_005x), asfloat(cb0_005y), 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
SV_Target = ProcessLutbuilder(..., Samplers_1, Textures_1, cb_config, ...);

// t0 / s0 (Six Days style) — dead tail: ((lerp_lut * cb0_039x) + (cb0_038x * direct))
float4 lutweights[2] = { float4(cb0_038x, cb0_039x, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
SV_Target = ProcessLutbuilder(..., s0, t0, cb_config, ...);
```

Do not wire cbuffers or LUT weights from another hash. See [sm6/lutbuilder_0x94D26E3A.ps_6_6.hlsl](sm6/lutbuilder_0x94D26E3A.ps_6_6.hlsl), [sm6/lutbuilder_0x8B981EB3.ps_6_0.hlsl](sm6/lutbuilder_0x8B981EB3.ps_6_0.hlsl), and [sm6/lutbuilder_0x33247499.ps_6_6.hlsl](sm6/lutbuilder_0x33247499.ps_6_6.hlsl).

Example (4 LUTs, named array — CD2A823A):

```hlsl
float4 lutweights[2] = {
  float4(asfloat(LUTWeights[0]), asfloat(LUTWeights[1]), asfloat(LUTWeights[2]), asfloat(LUTWeights[3])),
  float4(0.f, 0.f, 0.f, 0.f)
};
cb_config.ue_lutweights = lutweights;
o0 = ProcessLutbuilder(untonemapped_ap1, Samplers_1_s, Samplers_2_s, Samplers_3_s, Textures_1, Textures_2, Textures_3, cb_config, o0, OutputDevice);
```

For 3 LUTs (670070BD), trace `LUTWeights[0].x/y/z/w` against `Textures_1..3` sample lerps and call the 3-LUT `ProcessLutbuilder` overload with three samplers/textures.

## Injection anchor

Capture **untonemapped AP1** after color grading, immediately before blue correction / film tonemap:

```hlsl
float3 untonemapped_ap1 = r0.xyz; // or SM6 _795/_797/_799 triplet

UECbufferConfig cb_config = CreateCbufferConfig();
// ... fill cb_config ...

o0 = ProcessLutbuilder(...); // PS SM5
return;

// SM6 PS example:
SV_Target = ProcessLutbuilder(float3(_795, _797, _799), cb_config, SV_Target, OutputDevice);
return SV_Target;
```

Optional AP1 debug hooks when using the SM6 DXC style with `common.hlsl` paths: `SetUngradedAP1` after AP1 triplet creation, `SetTonemappedAP1` after film tonemap — see 670070BD. Prefer `ProcessLutbuilder` + early `return` as the primary ue-extended path.

## Remove ue-generic injection code

When porting shaders copied from `unrealengine` (ue-generic), strip all of this:

- `#include "../../common.hlsl"`
- `SetUngradedAP1`, `SetUntonemappedAP1`, `SetTonemappedAP1`
- `if (RENODX_TONE_MAP_TYPE != 0)` / `GenerateOutput(...)` override returns
- `GetOutputConfig`, `ToneMapPass`, `RenderIntermediatePass` early paths

Replace with `#include` to [lutbuilderoutput.hlsli](lutbuilderoutput.hlsli) (path relative to the **target shader file**) and `ProcessLutbuilder` at untonemapped AP1.

## Minimal HDR-only lutbuilders

Some hashes (e.g. `CBCF8905`, `18639D8F`) have no BlueCorrection/ToneCurveAmount cbuffers in dead code — only film (optional), mapping, overlay, and output device.

- Inject after AP1 triplet is formed from linear/PQ input, before vanilla film-curve / RRT math (or after color grading when present).
- Use the no-LUT `ProcessLutbuilder` overload unless dead code shows SDR LUT lerps.
- Force `cb_config.ue_bluecorrection = 0.f` and `cb_config.ue_tonecurveammount = 1.f` when dead code has **no** blue matrix (`0.938639…` dots) and **no** `cb0[*]` multiply after `0.930000007`.
- Leave other `cb_config` fields at `CreateCbufferConfig()` defaults unless the dead tail exposes usable film params.

## Scripts

All automation lives in one file: [scripts/lutbuilder.py](scripts/lutbuilder.py). Run from repo root.

| Subcommand | Purpose |
|------------|---------|
| `check` | Preflight on **user-confirmed paths** (default: all shaders under `src/games/ue-extended/lutbuilder/sm5|sm6`) — declared `cb0_*`, undeclared bracket `cb0[N].*` in injection, missing SDR LUT weights/overloads. **Blue/tone fingerprints require manual verification.** |
| `fix-weights [--fix]` | Report or auto-insert `ue_lutweights` + LUT `ProcessLutbuilder` overload when dead code allows (same path scope as `check`) |
| `convert-temp` | Optional batch: convert files the user placed in `src/games/ue-extended/temp/sm6/` (named cbuffers only; `cb0_*` needs manual mapping) |

```powershell
python src/games/ue-extended/lutbuilder/scripts/lutbuilder.py check
python src/games/ue-extended/lutbuilder/scripts/lutbuilder.py fix-weights
python src/games/ue-extended/lutbuilder/scripts/lutbuilder.py fix-weights --fix
python src/games/ue-extended/lutbuilder/scripts/lutbuilder.py convert-temp
```

**Scripts check structural wiring only.** They cannot verify blue/tone fingerprints (false positives on vanilla film tonemapper code). Always verify the live injection block against dead code before marking a shader done.

## Staging new shaders

The user names where lutbuilder files live. Typical flows:

1. User points at a folder (game tree, `temp/`, shared `lutbuilder/` library, etc.).
2. Batch inject or convert every `lutbuilder_0x*.hlsl` in that location (if that is what they asked for).
3. Manual dead-code review **per shader** (every `cb_config` slot + output device) → `lutbuilder.py check` → optional `fix-weights --fix` → manual review again.

Do **not** promote shaders whose `check` structural wiring reports are still failing unless you have verified and fixed the injection. Blue/tone fingerprints require manual verification — do not rely on script output for those.

Optional named-cbuffer batch shortcut when the user directs files to `src/games/ue-extended/temp/sm6/`: `convert-temp` → manual review per file → `check` → optional `fix-weights --fix`.

## Regex extras

Apply to decompiled SM5-style bool/`cmp` code after injection scaffolding is in place.

**Find**

```regex
(\s+)if \((cb\d+\[\d+\]\.)(x|y|z|w)+ ([!=]= 0\) \{)
```

**Replace**

```
$1[branch]
$1if (asuint($2$3) $4
```

**Find**

```regex
= (cb\d+\[\d+\]\.)(x|y|z|w)+ \?
```

**Replace**

```
= (asuint($1$2) != 0u) ?
```

## Validation

### Mandatory manual checks (every shader)

1. Read dead code **after** the early `return` — trace every `cb_config.ue_*` field to the exact `cb0_*` / named cbuffer slot used there.
2. **LUT weights:** search dead code for the SDR LUT blend fingerprint — `((lerp(...) * WEIGHT_LUT) + (WEIGHT_DIRECT * ...))`. Common slots:
   - `cb0_005x` direct + `cb0_005y` LUT (`Textures_1` or `t0` 2D)
   - `cb0_038x` direct + `cb0_039x` LUT (`t0`/`s0` Six Days style)
   - `cb0_038x`/`cb0_039x`/`cb0_040x` for 2-LUT `t0`/`t1`
   - named `LUTWeights[n]` when declared
3. If step 2 finds the fingerprint → injection **must** set `ue_lutweights` **and** call the matching LUT `ProcessLutbuilder` overload (`Samplers_1, Textures_1` or `s0, t0`, etc.).
4. If the only texture is `Texture3D<float4> t0` with `float3` sample coords → **no** `ue_lutweights` (internal 3D LUT volume, not SDR LUT blend).
5. Confirm every wired `cb0_*` / `cb0[N].*` appears in the shader's `cbuffer cb0` declaration **and** in live/dead body code (`check` wiring audit).
6. When dead code has no blue matrix and no post-`0.93` tone multiply, confirm `ue_bluecorrection = 0.f` and `ue_tonecurveammount = 1.f`.

From repo root (after manual review of **the files you edited**):

```powershell
rg -n "ProcessLutbuilder|ExpandGamut set to 0| \* 0\.f\)|ue_bluecorrection|ue_tonecurveammount|ue_lutweights" <user-confirmed-paths>
python src/games/ue-extended/lutbuilder/scripts/lutbuilder.py check
```

`check` scans the shared `lutbuilder/sm5|sm6` library by default; if work lived elsewhere, rely on manual review and targeted `rg` on those paths.

For duplicated decompiler blocks, confirm ExpandGamut forcing and injection exist in **every** copy.
