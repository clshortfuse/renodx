# Death Stranding 2 Decompiler Fixes

## Section 1: Sampler Heap Indexing (`ResourceDescriptorHeap`)

### Problem pattern
Some decompiled shaders emit this declaration:

```hlsl
SamplerState _8[] : register(s0, space0);
```

And then sample with it:

```hlsl
float4 c = _13.Sample(_8[6u], uv);
float4 c2 = _12.SampleLevel(_8[17u], uv, 0.0f);
```

### What is wrong
For this shader set, `_8[]` is a decompiler artifact.  
The original shader behavior uses sampler descriptor heap indexing.

### Required fix
1. Keep the fake declaration as a comment (preserve original text):

```hlsl
// SamplerState _8[] : register(s0, space0);
```

2. For every `_8[index]` sampler use, keep the original line as a comment directly above the fixed line.

3. Replace each `_8[index]` sampler argument with:

```hlsl
(SamplerState)ResourceDescriptorHeap[index]
```

4. Keep index and function usage unchanged (`Sample`, `SampleLevel`, helper call arguments, etc.).

### Canonical replacement format
Before:

```hlsl
float4 _163 = _13.Sample(_8[6u], float2(TEXCOORD.x, TEXCOORD.y));
```

After (required format):

```hlsl
// float4 _163 = _13.Sample(_8[6u], float2(TEXCOORD.x, TEXCOORD.y));
float4 _163 = _13.Sample((SamplerState)ResourceDescriptorHeap[6u], float2(TEXCOORD.x, TEXCOORD.y));
```

Before:

```hlsl
float4 _190 = _12.SampleLevel(_8[3u], float2(_182, _183), 0.0f);
```

After (required format):

```hlsl
// float4 _190 = _12.SampleLevel(_8[3u], float2(_182, _183), 0.0f);
float4 _190 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_182, _183), 0.0f);
```

Before:

```hlsl
ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs(_8[17u], _19, ...);
```

After (required format):

```hlsl
// ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs(_8[17u], _19, ...);
ApplyTonemapGamma2LUTAndInverseTonemapDualOutputs((SamplerState)ResourceDescriptorHeap[17u], _19, ...);
```

### Quick checks
Find remaining bad call sites:

```powershell
rg -n "Sample(Level)?\\(_8\\[" src/games/deathstranding2/tonemap
```

Find remaining live declaration:

```powershell
rg -n "^\\s*SamplerState\\s+_8\\[\\]\\s*:\\s*register\\(s0,\\s*space0\\);" src/games/deathstranding2/tonemap
```

Find fixed heap sampler usage:

```powershell
rg -n "\\(SamplerState\\)ResourceDescriptorHeap\\[[0-9]+u\\]" src/games/deathstranding2/tonemap
```

---

## Section 2: Input Signature Fix (Match DXIL `.ll`)

### Problem pattern
Decompiler output may have input semantic/index/order mismatches, e.g.:

```hlsl
struct SPIRV_Cross_Input
{
    float2 TEXCOORD : TEXCOORD1;
    float4 gl_FragCoord : SV_Position;
};
```

### Source of truth
Use the DXIL `.ll` input signature block and entry metadata as authoritative.

For this pass, expected input layout is:
- `SV_Position` at register/input slot 0, `noperspective`
- `TEXCOORD` index 0 (`TEXCOORD0`) at register/input slot 1, `linear`

### Required fix
Use this exact input struct shape:

```hlsl
struct SPIRV_Cross_Input
{
    noperspective float4 gl_FragCoord : SV_Position;
    linear float2 TEXCOORD : TEXCOORD0;
};
```

Keep the handoff in `main(...)` consistent:

```hlsl
gl_FragCoord = stage_input.gl_FragCoord;
TEXCOORD = stage_input.TEXCOORD;
```

### Quick checks
Find wrong semantic index usage:

```powershell
rg -n "TEXCOORD1" src/games/deathstranding2/tonemap
```

Find corrected input qualifier pattern:

```powershell
rg -n "noperspective\\s+float4\\s+gl_FragCoord\\s*:\\s*SV_Position|linear\\s+float2\\s+TEXCOORD\\s*:\\s*TEXCOORD0" src/games/deathstranding2/tonemap
```

---

## Section 3: Custom Mod Functions

This section is for replacing repeated decompiled math blocks with mod helper functions from `tonemap/tonemap.hlsli`.

Purpose:
- keep shader edits consistent across passes
- reduce copy/paste error risk in long decompiled blocks
- preserve an easy rollback path using `#if 1` / `#else`

### Function 1: `ApplyTonemapGamma2LUTAndInverseTonemap`

Defined in:
- `src/games/deathstranding2/tonemap/tonemap.hlsli`

What it does:
- tonemap
- gamma2 encode/decode around LUT sample
- inverse tonemap
- writes 3 output channels through `inout` references

When to use:
- when you see the repeated inline block with:
  - `float _X = (-0.0f) - <const>.w;`
  - `SampleLevel(... float3(clamp(sqrt(max(...)))) ... )`
  - `min(_sample * _sample, <const>.x)`
  - inverse-tonemap ternaries writing `frontier_phi_*`

How to integrate (required pattern):
1. Replace only the target inline block with `#if 1` helper call.
2. Keep the original inline block under `#else` unchanged for fallback/reference.
3. Keep output ordering exactly as the original block (channel order matters).

Canonical pattern:

```hlsl
#if 1
ApplyTonemapGamma2LUTAndInverseTonemap(
    (SamplerState)ResourceDescriptorHeap[17u],
    _19,
    _394, _396, _398,
    _26_m0[14u].w,
    _26_m0[14u].x, _26_m0[14u].y, _26_m0[14u].z,
    _26_m0[15u].x, _26_m0[15u].y, _26_m0[15u].z, _26_m0[15u].w,
    _26_m0[18u].x, _26_m0[18u].y,
    frontier_phi_10_11_ladder,
    frontier_phi_10_11_ladder_1,
    frontier_phi_10_11_ladder_2);
#else
// original inline block stays here unchanged
#endif
```

Argument mapping checklist:
- `lut_sampler`: `(SamplerState)ResourceDescriptorHeap[...]` index used by original block
- `Texture3D`: LUT texture resource (example: `_19`)
- input channels: the 3 pre-LUT values from the original block (`_394, _396, _398` in example)
- tonemap constants: `_m0[14u]` and `_m0[15u]` groups (example above)
- LUT range constants: `_m0[18u].x/.y` (example above)
- outputs: same `frontier_phi_*` vars used by replaced block

Channel-order warning:
- many decompiled blocks store outputs in `B, G, R` variable order (not `R, G, B`).
- do not reorder output variables when calling the helper.

### Function 2: `ApplyUserGradingAndToneMapAndScale`

Defined in:
- `src/games/deathstranding2/tonemap/tonemap.hlsli`

What it does:
- applies user grading logic used by the mod
- applies vanilla tonemap-style mapping/scaling path
- writes 3 output channels through `inout` references

When to use:
- when replacing this per-channel pattern:
  - `float _X = (-0.0f) - <const>.x;`
  - `out = (in < pivot) ? ((in * a) + b) : ((_X / (in + c)) + d);`
  - repeated for 3 channels

How to integrate (required pattern):
1. Replace only the target inline block with `#if 1` helper call.
2. Keep the original inline block under `#else` unchanged for fallback/reference.
3. Preserve channel mapping order from original code (`in_r,in_g,in_b` -> `out_r,out_g,out_b`).

Canonical pattern:

```hlsl
#if 1
ApplyUserGradingAndToneMapAndScale(
    _513, _516, _519,
    _26_m0[14u].y, _26_m0[14u].z,
    _26_m0[15u].z,
    _26_m0[16u].x, _26_m0[16u].y, _26_m0[16u].z,
    _527, _529, _531);
#else
float _541 = (-0.0f) - _26_m0[16u].x;
_527 = (_513 < _26_m0[15u].z) ? ((_513 * _26_m0[14u].y) + _26_m0[14u].z) : ((_541 / (_513 + _26_m0[16u].y)) + _26_m0[16u].z);
_529 = (_516 < _26_m0[15u].z) ? ((_516 * _26_m0[14u].y) + _26_m0[14u].z) : ((_541 / (_516 + _26_m0[16u].y)) + _26_m0[16u].z);
_531 = (_519 < _26_m0[15u].z) ? ((_519 * _26_m0[14u].y) + _26_m0[14u].z) : ((_541 / (_519 + _26_m0[16u].y)) + _26_m0[16u].z);
#endif
```

Argument mapping checklist:
- inputs: 3 scalar channels from the source block (`_513, _516, _519` in example)
- linear-branch params: `a`, `b` (example: `_26_m0[14u].y`, `_26_m0[14u].z`)
- pivot: `pivot` (example: `_26_m0[15u].z`)
- reciprocal-branch params: `x`, `c`, `d` (example: `_26_m0[16u].x/.y/.z`)
- outputs: the same 3 destination vars used by replaced block (`_527, _529, _531`)

### Function 3: PQ Conversion Helpers (`PQFromBT709` vs `PQFromBT709FinalWithGammaCorrection`)

Defined in:
- `src/games/deathstranding2/common.hlsli` (included via `tonemap/tonemap.hlsli`)

What they do:
- convert BT709 RGB to PQ
- replace repeated decompiled `exp2(log2(abs(mad(...))))` + PQ shaping blocks
- write `pq_r`, `pq_g`, `pq_b` through `out` references

Critical selection rule (required):
1. Helper choice is pipeline-position dependent and is user-controlled.
2. Do not auto-pick helper when replacing a PQ block.
3. If user did not explicitly specify helper, ask:
   `Should this replacement use PQFromBT709 or PQFromBT709FinalWithGammaCorrection?`

How to integrate (required pattern):
1. Replace only the target inline block with `#if 1` helper call.
2. Keep original inline code under `#else` unchanged for fallback/reference.
3. Pass BT709 inputs to helper in RGB order (`x, y, z`) even if decompiled temporaries are shuffled.
4. Preserve original destination channel mapping exactly (do not assume `R,G,B` destination order).

Canonical replacement:

```hlsl
#if 1
float pq_r;
float pq_g;
float pq_b;
<PQ_HELPER>(
    in_r, in_g, in_b,
    pq_m1, diffuse_white,
    pq_r, pq_g, pq_b);
// map to original destination order here
#else
// original inline block stays here unchanged
#endif
```

Known channel-mapping examples:

```hlsl
// Example A (FinalWithGammaCorrection helper)
PQFromBT709FinalWithGammaCorrection(_737, _738, _739, _26_m0[8u].x, _26_m0[8u].y, pq_r, pq_g, pq_b);
frontier_phi_23_19_ladder   = pq_b;
frontier_phi_23_19_ladder_1 = pq_g;
frontier_phi_23_19_ladder_2 = pq_r;

// Example B (FinalWithGammaCorrection helper)
PQFromBT709FinalWithGammaCorrection(_727, _729, _731, _26_m0[8u].x, _26_m0[8u].y, pq_r, pq_g, pq_b);
frontier_phi_32_26_ladder   = pq_r;
frontier_phi_32_26_ladder_1 = pq_b;
frontier_phi_32_26_ladder_2 = pq_g;

// Example C (PQFromBT709 helper)
PQFromBT709(_800, _802, _804, _40_m0[18u].x, _40_m0[18u].y, pq_r, pq_g, pq_b);
frontier_phi_32_26_ladder   = pq_r;
frontier_phi_32_26_ladder_1 = pq_b;
frontier_phi_32_26_ladder_2 = pq_g;
```
