#include "./tonemap.hlsli"
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

#if 1
  float3 output_pq = r0.rgb;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 untonemapped_bt2020 = renodx::color::pq::DecodeSafe(output_pq, 100.f);

    float3 untonemapped_lms = renodx::color::lms::from::BT2020(untonemapped_bt2020);
    if (RENODX_GAMMA_CORRECTION == 0.f) {
      const float3 bt2020_white_lms = renodx::color::lms::from::BT2020(1.f);
      untonemapped_lms = renodx::color::correct::GammaSafe(untonemapped_lms / bt2020_white_lms, true) * bt2020_white_lms;
    }

    float3 tonemapped_lms;
    float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

    // display map in lms to peak then restore untonemapped luminance
    float3 peak_lms = renodx::color::lms::from::BT2020(peak_ratio);
    float3 mid_gray_lms = renodx::color::lms::from::BT2020(0.1f);
    float3 clip_lms = renodx::color::lms::from::BT2020(100.f);
    tonemapped_lms = psycho_ReinhardPiecewise(untonemapped_lms, peak_lms, mid_gray_lms);

    float untonemapped_yf = renodx::color::yf::from::LMS(untonemapped_lms);
    float tonemapped_yf = renodx::color::yf::from::LMS(tonemapped_lms);
    tonemapped_lms *= renodx::math::DivideSafe(untonemapped_yf, tonemapped_yf, 1.f);

    // Apply LMS luminance and purity grading.
    float3 desired_background_state_lms = renodx::color::lms::from::AP1(0.1f);  // output midgray from tonemap was 0.1 in AP1
    float output_mid_gray = renodx::color::yf::from::LMS(desired_background_state_lms);
    tonemapped_lms = ApplyLuminanceGradingLMS(tonemapped_lms,
                                              RENODX_TONE_MAP_EXPOSURE,
                                              RENODX_TONE_MAP_HIGHLIGHTS,
                                              RENODX_TONE_MAP_SHADOWS,
                                              RENODX_TONE_MAP_CONTRAST,
                                              0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
                                              output_mid_gray);
    tonemapped_lms = ApplyPurityGradingLMS(tonemapped_lms,
                                           RENODX_TONE_MAP_SATURATION,
                                           -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f),
                                           RENODX_TONE_MAP_DECHROMA,
                                           desired_background_state_lms);

    float3 tonemapped_bt2020 = max(0, renodx::color::bt2020::from::LMS(tonemapped_lms));

    float max_channel = renodx::math::Max(tonemapped_bt2020);
    float new_max = renodx::tonemap::ReinhardPiecewiseExtended(max_channel, 100.f, peak_ratio, 0.1f);
    new_max = min(new_max, peak_ratio);
    float scale = renodx::math::DivideSafe(new_max, max_channel, 1.f);
    float3 displaymapped_bt2020 = tonemapped_bt2020 * scale;

    output_pq = renodx::color::pq::EncodeSafe(displaymapped_bt2020, RENODX_DIFFUSE_WHITE_NITS);
  }
  r0.rgb = output_pq;
#endif

  r0.w = 1;
  r1.xyzw = float4(0, 0, 0, 1) + -r0.xyzw;
  o0.xyzw = cb0[0].xxxx * r1.xyzw + r0.xyzw;
  return;
}
