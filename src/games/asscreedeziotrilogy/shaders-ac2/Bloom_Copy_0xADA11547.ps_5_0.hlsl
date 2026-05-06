#include ".././common.hlsli"

// Hand-decompiled from DXBC. This is a bloom / sun-flare / lens-glare
// overlay shader. The pipeline:
//   1. Linear distance falloff from anchor point cb4[20] to world pos v6,
//      saturated between cb4[146] (near) and cb4[147] (far).
//   2. Front-face vs back-face decides whether to use the view direction
//      (v9) verbatim or scaled by -cb4[102]; dot it with light direction
//      (v10) to get a cosine.
//   3. pow(|cos|, cb4[148]) drives a two-step lerp: first against
//      cb4[149] (curve adjust) then against cb4[150] (smoothstep).
//   4. Sample t0 and t1 via two independent 2D affine UV transforms
//      (cb4[136..137] and cb4[139..140]). Bit-normalize each sample
//      against cb3[44..47].
//   5. Alpha-blend the two samples by cb4[142], then lerp the alpha
//      result against the t1 grayscale by cb4[143].
//   6. Final scalar = composite * cb4[151] * cb4[152] * power-curve *
//      vertex-alpha * distance-falloff, gated against a cb4[144]/cb4[145]
//      range and discarded when the quantized alpha falls below cb3[8].z.

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb4 : register(b4) {
  float4 cb4[236];
}

cbuffer cb3 : register(b3) {
  float4 cb3[77];
}

// Bit-reinterpreted mask + set, mirroring DXBC `and r, r, m` then `or r, r, s`.
float4 BitNorm(float4 c, float4 mask, float4 set) {
  return asfloat((asuint(c) & asuint(mask)) | asuint(set));
}

// rsqrt of a sum-of-squares with a zero-length guard. The DXBC pattern is
// rsq + ieq-against-+inf + and; this is the readable HLSL equivalent.
float SafeRsqDot(float3 v) {
  float d = dot(v, v);
  return (d > 0.f) ? rsqrt(d) : 0.f;
}

void main(
    float4 v0 : SV_POSITION0,
    float4 v1 : TEXCOORD8,
    linear centroid float4 v2 : COLOR0,
    float4 v3 : COLOR1,
    float4 v4 : TEXCOORD9,
    float4 v5 : TEXCOORD0,
    float4 v6 : TEXCOORD1,
    float4 v7 : TEXCOORD2,
    float4 v8 : TEXCOORD3,
    float4 v9 : TEXCOORD4,
    float4 v10 : TEXCOORD5,
    float4 v11 : TEXCOORD6,
    float4 v12 : TEXCOORD7,
    uint v13 : SV_IsFrontFace,
    out float4 o0 : SV_TARGET0) {
  float4 r0 = 0.f;
  float4 r1 = 0.f;
  float4 r3 = 0.f;
  float4 r4 = 0.f;
  float4 r5 = 0.f;

  // 1) Distance from anchor cb4[20] to world position v6, then linear
  // falloff between cb4[146] (near) and cb4[147] (far), saturated.
  r0.x = length(cb4[20].xyz - v6.xyz);
  r0.x = saturate((r0.x - cb4[146].x) * renodx::math::DivideSafe(1.f, cb4[147].x - cb4[146].x));

  // 2) Front-face -> +1, back-face -> -1.
  float face_sign = v13 ? 1.f : -1.f;
  r0.y = (face_sign >= 0.f) ? 1.f : -1.f;

  // Normalize view direction (v9), zero on degenerate input.
  r1.xyz = v9.xyz * SafeRsqDot(v9.xyz);

  // r3.xyz = -cb4[102].x * normalize(v9).
  r3.xyz = r1.xyz * -cb4[102].x;

  // Per-channel select: pick the unscaled normal on back-face
  // (-r0.y >= 0), else the cb4[102]-flipped one.
  bool back_face = (-r0.y) >= 0.f;
  r0.y = back_face ? r1.x : r3.x;
  r0.z = back_face ? r1.y : r3.y;
  r0.w = back_face ? r1.z : r3.z;

  // Normalize light direction (v10).
  r1.xyz = v10.xyz * SafeRsqDot(v10.xyz);

  // cosine = dot(adjusted view, light).
  r0.y = dot(r0.yzw, r1.xyz);

  // 3) pow(|cos|, cb4[148]) using log-mul-exp; NaN -> 0.
  r4.x = log2(abs(r0.y)) * cb4[148].x;
  r4.x = isnan(r4.x) ? 0.f : r4.x;
  r1.x = exp2(r4.x);

  // r0.y = cb4[149] * (pow_result - 1) + 1
  r0.y = cb4[149].x * (r1.x - 1.f) + 1.f;
  // r0.z = 1 - saturate(r0.y)
  r0.z = 1.f - saturate(r0.y);
  // r1.y = lerp(r0.y, r0.z, cb4[150])  (smoothstep between curve and inverse)
  r1.y = cb4[150].x * (r0.z - r0.y) + r0.y;

  // 4) Build homogeneous UV (u, v, 1) for two affine transforms.
  r0.yzw = float3(v5.x, v5.y, 1.f);

  // First UV transform via cb4[136], cb4[137]; sample t0; bit-normalize.
  r3.x = dot(r0.yzw, cb4[136].xyz);
  r3.y = dot(r0.yzw, cb4[137].xyz);
  r3 = t0.Sample(s0_s, r3.xy);
  r3 = BitNorm(r3, cb3[44], cb3[45]);

  // Second UV transform via cb4[139], cb4[140]; sample t1; bit-normalize.
  r4.x = dot(r0.yzw, cb4[139].xyz);
  r4.y = dot(r0.yzw, cb4[140].xyz);
  r4 = t1.Sample(s1_s, r4.xy);
  r4 = BitNorm(r4, cb3[46], cb3[47]);

  // 5) Alpha blend t0.a -> t1.a by cb4[142].
  r0.y = cb4[142].x * (r4.w - r3.w) + r3.w;
  // Grayscale of t1.rgb (0.33 weights — note the slight off from BT.601).
  r0.z = dot(float3(0.33f, 0.33f, 0.33f), r4.xyz);
  // Lerp alpha-blend result toward grayscale by cb4[143].
  r1.z = cb4[143].x * (r0.z - r0.y) + r0.y;

  // 6) Composite scale and gates.
  r0.x = r0.x * (r1.z * cb4[151].x) * r1.y * v2.w;

  // Range gate: clamp by cb4[145] (lower) and cb4[144] (upper).
  r0.y = 1.f - r1.z;
  r0.z = saturate(r1.z - cb4[145].x);
  r0.w = r1.x - cb4[144].x;
  r0.y = saturate(r0.y - r0.w);
  r0.x = r0.x * min(r0.z, r0.y);

  // Final scaling: cb4[151] * cb4[152] * power-curve.
  r0.y = cb4[151].x * cb4[152].x * r1.y;

  r5 = r0.x * r0.y;

  // Alpha-threshold discard: pixel dies when the alpha (quantized to 0-255)
  // falls below cb3[8].z. Matches DXBC: ftou(r5.w*255 + 0.0001) < cb3[8].z.
  uint alpha_q = (uint)(r5.w * 255.f + 0.0001f);
  if (alpha_q < (uint)cb3[8].z) discard;

  // Bloom was authored against an 8-bit destination — saturate matches the
  // original implicit hardware clamp so the additive overlay can't ride
  // past SDR white into HDR peak when the RT is upgraded to R16F.
  o0.rgb = 1.f - exp2(-max(r5.rgb, 0.f));
  o0.a = 1.f - exp2(-max(r5.a, 0.f));
}
