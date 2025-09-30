#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 23 10:10:10 2025
// Deband postprocess shader (quad/pixel shader).
// Purpose: sample a small neighborhood around each pixel, compute a local blurred
// average and a residual (difference between center and blur), then decide
// whether to replace the center with the blur or keep detail based on a
// threshold. This reduces banding while preserving edges.

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

// cb1/cb0 contain runtime parameters produced by the injector/game.
cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  // r* temporaries used by the decompiler. We'll comment key ones inline.
  float4 r0, r1, r2, r3, r4, r5, r6, r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  // --- Seed / pseudo-random pattern generator
  // The sequence below deterministically generates per-pixel seeds used to
  // vary sampling offsets. It combines the UV (v1) and cb1 values through
  // chained multiply/add/floor/frac operations to produce several seeds.
  // Constants like 34, 289 and 0.00346020772 appear in many decompiled
  // sampling pattern generators (they are part of an LCG-like permutation).
  r0.xy = float2(1, 1) + v1.xy;
  // base offset from cb1
  r0.z = 1 + cb1[0].y;
  r0.w = r0.x * 34 + 1;
  r0.x = r0.w * r0.x;
  // scale and floor series
  r0.w = 0.00346020772 * r0.x;
  r0.w = floor(r0.w);
  r0.x = -r0.w * 289 + r0.x;
  r0.x = r0.x + r0.y;
  r0.y = r0.x * 34 + 1;
  r0.x = r0.y * r0.x;
  r0.y = 0.00346020772 * r0.x;
  r0.y = floor(r0.y);
  r0.x = -r0.y * 289 + r0.x;
  r0.x = r0.x + r0.z;
  r0.y = r0.x * 34 + 1;
  r0.x = r0.y * r0.x;
  r0.y = 0.00346020772 * r0.x;
  r0.y = floor(r0.y);
  r0.x = -r0.y * 289 + r0.x;
  // Sample the center pixel and use it as the running base (r2).
  // center color
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if (RENODX_SWAP_CHAIN_OUTPUT_DITHER_BITS >= 0.f) {
    o0 = r1;
    return;
  }
  // accumulator / current result
  r2.xyzw = r1.xyzw;
  // Prepare iteration variables. r0.y becomes a per-iteration varying seed.
  r0.y = r0.x;
  // sample loop index starts at 1
  r0.z = 1;

  // --- Sample loop: iterate cb0[3].z times (sample count) and accumulate
  // For each iteration the shader computes a rotated sampling offset and
  // performs several texture samples around the center to form a small blur.
  while (true) {
    // Compare loop counter against configured sample count (decompiler macro)
    r0.w = cmp(asint(cb0[3].z) < (int)r0.z);
    // exit when index >= sample count
    if (r0.w != 0) break;

    // r3.x computed radius-scale per sample from cb0[3].y and loop index
    r0.w = (int)r0.z;
    // radius scale for this sample

    r3.x = cb0[3].y * r0.w;
    // Use a fractional/permute pattern to vary sample angle/phase
    // constant = 1/41 approx. (pattern)
    r3.y = 0.024390243 * r0.y;
    r3.y = frac(r3.y);
    // scaled radius
    r3.x = r3.y * r3.x;
    // More mixing to produce per-sample offsets (LCG-style steps)
    r3.y = r0.y * 34 + 1;
    r3.y = r3.y * r0.y;
    r3.z = 0.00346020772 * r3.y;
    r3.z = floor(r3.z);
    r3.y = -r3.z * 289 + r3.y;
    r3.z = 0.024390243 * r3.y;
    r3.z = frac(r3.z);
    r3.w = r3.y * 34 + 1;
    r3.y = r3.w * r3.y;

    // r3.z now encodes an angle scaled by 2*PI and r3.w holds an additional seed
    // The vector float2(2*PI, 0.00346020772) multiplied by r3.zy forms inputs
    // used by sincos below to produce an oriented sample offset.
    r3.zw = float2(6.28318548, 0.00346020772) * r3.zy;
    r3.w = floor(r3.w);
    r0.y = -r3.w * 289 + r3.y;

    // cb0[2].xy appears to be a per-axis radius multiplier; multiply by r3.xx
    // to get the final radius for the two sample points used below.
    r3.xy = cb0[2].xy * r3.xx;

    // Compute sin/cos of the angle to rotate the sample offset
    sincos(r3.z, r4.x, r5.x);
    // store sin/cos into r6 for reuse (convenience registers)
    // sin
    r6.z = r5.x;
    // cos
    r6.w = r4.x;
    // Build two sample positions rotated by the angle and offset by center UV
    // sample position A
    r3.zw = r3.xy * r6.zw + v1.xy;
    // sample A
    r7.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
    // -cos
    r6.y = -r4.x;
    // sample position B (opposite)
    r3.zw = r3.xy * r6.yz + v1.xy;
    // sample B
    r4.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
    // -sin
    r6.x = -r5.x;
    // positions for two more samples
    r3.xyzw = r3.xyxy * r6.xywx + v1.xyxy;
    // sample C
    r5.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    // Also sample the previous zw pair (another rotated offset)
    // sample D
    r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;

    // Sum the four samples together: r7 (A) + r4 (B) + r5 (C) + r3 (D)
    r4.xyzw = r7.xyzw + r4.xyzw;
    r4.xyzw = r4.xyzw + r5.xyzw;
    r3.xyzw = r4.xyzw + r3.xyzw;

    // Compute the 4-sample average (simple box blur)
    r4.xyzw = float4(0.25, 0.25, 0.25, 0.25) * r3.xyzw;

    // Compute residual: center - blur (this captures high-frequency detail)
    // r3 becomes the residual vector (difference) whereas r4 is the blur
    r3.xyzw = -r3.xyzw * float4(0.25, 0.25, 0.25, 0.25) + r2.xyzw;

    // Threshold calculation: derive a threshold value from per-pixel seed and
    // cb0[3].x (likely a global strength/threshold parameter). The fixed
    // multiplication by 16384 and division scales the seed into a usable range.
    r0.w = 16384 * r0.w;
    r0.w = cb0[3].x / r0.w;

    // r5.xyzw = cmp(abs(r3.xyzw) >= r0.wwww);
    // r5.xyzw = r5.xyzw ? float4(1, 1, 1, 1) : 0;

    // Compare absolute residual against the threshold and build a boolean mask
    // (true where abs(residual) >= threshold). Use an explicit bool4 to avoid
    // implicit float<->bool conversions and deprecated ?: behavior.
    bool4 _mask = (abs(r3.xyzw) >= r0.wwww);
    // Convert boolean mask -> float mask (0/1) per component
    r5.x = _mask.x ? 1.0f : 0.0f;
    r5.y = _mask.y ? 1.0f : 0.0f;
    r5.z = _mask.z ? 1.0f : 0.0f;
    r5.w = _mask.w ? 1.0f : 0.0f;

    // Final blend per-sample: when residual is above threshold keep the
    // residual contribution (preserves detail), otherwise favor the blur.
    // r2 stores the running result for the pixel and is updated each iter.
    r2.xyzw = r5.xyzw * r3.xyzw + r4.xyzw;

    // Next iteration
    r0.z = (int)r0.z + 1;
  }

  // Output the computed color (debanded/filtered result)
  o0.xyzw = r2.xyzw;
  return;
}
