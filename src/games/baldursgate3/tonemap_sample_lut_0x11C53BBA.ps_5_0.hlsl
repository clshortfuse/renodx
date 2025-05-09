#include "./common.hlsli"
Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0, 0);
  r0.xyz = t0.Load(r0.xyz).xyz;

  float3 pre_encoded_color = r0.rgb;
  r0.w = cmp(asint(cb0[0].z) >= 20);
  if (r0.w != 0) {  //   if (r0.w != 0) {
    r0.w = cmp(asint(cb0[0].z) == 21);
    if (r0.w != 0) {
      r0.w = max(r0.y, r0.z);
      r0.w = max(r0.x, r0.w);
      r1.xyz = r0.www + -r0.xyz;
      r1.xyz = r1.xyz / abs(r0.www);
      r2.xyz = cmp(float3(0.814999998, 0.802999973, 1) >= r1.xyz);
      r3.xyz = r2.xyz ? float3(1, 1, 1) : float3(0.327301919, 0.285938054, 0);
      r2.xyz = (int3)r2.xyz | int3(-1, -1, 0);
      r4.xyz = float3(-0.814999998, -0.802999973, -1) + r1.xyz;
      r4.xyz = r4.xyz / r3.xyz;
      r2.xyz = r2.xyz ? r4.xyz : 0;
      r4.xyz = cmp(float3(0, 0, 0) < r2.xyz);
      r5.xyz = log2(abs(r2.xyz));
      r5.xyz = float3(1.20000005, 1.20000005, 1.20000005) * r5.xyz;
      r5.xyz = exp2(r5.xyz);
      r4.xyz = r4.xyz ? r5.xyz : 0;
      r5.xyz = cmp(r1.xyz < float3(0.814999998, 0.802999973, 1));
      r2.xyz = r3.xyz * r2.xyz;
      r3.xyz = float3(1, 1, 1) + r4.xyz;
      r3.xyz = log2(r3.xyz);
      r3.xyz = float3(0.833333313, 0.833333313, 0.833333313) * r3.xyz;
      r3.xyz = exp2(r3.xyz);
      r2.xyz = r2.xyz / r3.xyz;
      r2.xyz = float3(0.814999998, 0.802999973, 1) + r2.xyz;
      r1.xyz = r5.xyz ? r1.xyz : r2.xyz;
      r0.xyz = -r1.xyz * abs(r0.www) + r0.www;
    }
    r1.xyz = max(float3(0, 0, 0), r0.xyz);
    r2.xyz = cmp(float3(3.05175781e-05, 3.05175781e-05, 3.05175781e-05) >= r1.xyz);
    r3.xyz = r1.xyz * float3(0.5, 0.5, 0.5) + float3(1.52587891e-05, 1.52587891e-05, 1.52587891e-05);
    r1.xyz = r2.xyz ? r3.xyz : r1.xyz;
    r1.xyz = log2(r1.xyz);
    r1.xyz = float3(9.72000027, 9.72000027, 9.72000027) + r1.xyz;
    r1.xyz = saturate(float3(0.0570776239, 0.0570776239, 0.0570776239) * r1.xyz);
  } else {
    r1.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 10000.f / cb0[0].y);
  }
  r0.xyz = t1.SampleLevel(s0_s, r1.xyz, 0).xyz;  // tonemapping

#if RENODX_TONE_MAP_TYPE
  r0.rgb = renodx::color::pq::DecodeSafe(r0.rgb, 100.f);

  r0.rgb = renodx::color::bt709::from::BT2020(r0.rgb);
  if (!RENODX_GAMMA_CORRECTION) {
    r0.rgb = renodx::color::correct::GammaSafe(r0.rgb, true, 2.2f);
  }
  r0.rgb = renodx::color::grade::UserColorGrading(
      r0.rgb,
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      0.f);
  r0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);

  float shoulder_start = 0.5f;
  float3 untonemapped = max(0, r0.rgb);
  r0.rgb = exp2(renodx::tonemap::ExponentialRollOff(log2(untonemapped * RENODX_DIFFUSE_WHITE_NITS), log2(RENODX_PEAK_WHITE_NITS * RENODX_TONE_MAP_SHOULDER_START), log2(RENODX_PEAK_WHITE_NITS))) / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_TONE_MAP_HUE_CORRECTION != 0.f) {
    r0.rgb = renodx::color::bt709::from::BT2020(r0.rgb);
    r0.rgb = renodx::color::correct::Hue(r0.rgb, renodx::color::bt709::from::BT2020(untonemapped), RENODX_TONE_MAP_HUE_CORRECTION);
    r0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
  }
  r0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, RENODX_DIFFUSE_WHITE_NITS);
#endif

  r0.w = 1;
  r1.xyzw = float4(0, 0, 0, 1) + -r0.xyzw;
  o0.xyzw = cb0[0].xxxx * r1.xyzw + r0.xyzw;
  return;
}
