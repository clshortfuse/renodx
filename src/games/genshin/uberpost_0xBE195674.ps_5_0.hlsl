#include "./common.hlsli"

// Genshin Impact uberpost: half-res composite, bloom, exposure, then either
// SDR tone map + encode (cb0[20].x <= 0.5) or PQ encode + HDR LUT (HDR mode).
// Output: R8G8B8A8_UNORM in SDR mode, feeding AA/upscaling, a copy to the
// swapchain and UI drawn directly on the swapchain.
// RenoDX: the SDR branch is replaced to write the RenoDX intermediate encoding;
// the HDR branch is untouched (its LUT is handled by the LUT builder).
// Original bytecode decompiled with 3Dmigoto, cleaned up and annotated.

Texture2D<float4> t0 : register(t0);  // scene
Texture2D<float4> t1 : register(t1);  // half-res color
Texture2D<float4> t2 : register(t2);  // half-res alpha
Texture2D<float4> t3 : register(t3);  // bloom
Texture3D<float4> t4 : register(t4);  // HDR LUT (HDR mode only)
Texture2D<float4> t5 : register(t5);  // overlay mask
Texture2D<float4> t6 : register(t6);  // auto exposure

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);
SamplerState s4_s : register(s4);
SamplerState s5_s : register(s5);

cbuffer cb0 : register(b0) {
  float4 cb0[105];
}

// cb0[20].x    HDR output enabled
// cb0[20].y    in-game brightness gamma (SDR)
// cb0[22].xyz  tone map enabled, bloom intensity, exposure
// cb0[98].x    auto exposure blend
// cb0[99..101] color grading matrix rows
// cb0[104].x   write luma to alpha

// Vanilla SDR output encode: sRGB approximation without the linear toe,
// followed by the in-game brightness gamma.
float3 VanillaSDREncode(float3 color, float brightness_gamma) {
  color = max(0.f, 1.055f * pow(max(0.f, color), 1.f / 2.4f) - 0.055f);
  return pow(color, brightness_gamma);
}

// In-game brightness gamma applied to linear HDR color, in sRGB-encoded space
// like vanilla, extended above 1.0.
float3 ApplyBrightnessGamma(float3 color, float brightness_gamma) {
  float3 encoded = renodx::color::srgb::EncodeSafe(color);
  encoded = renodx::math::CopySign(pow(abs(encoded), brightness_gamma), encoded);
  return renodx::color::srgb::DecodeSafe(encoded);
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;

  r0.xyz = t0.Sample(s0_s, v1.xy).xyz;
  r1.xyz = t1.Sample(s3_s, v1.xy).xyz;
  r0.w = t2.Sample(s4_s, v1.xy).x;
  r0.xyz = r0.w * (r1.xyz - r0.xyz) + r0.xyz;
  r0.xyz = t3.Sample(s1_s, v1.xy).xyz * cb0[22].y + r0.xyz;

  const bool auto_exposure = 0 < cb0[98].x;
  if (auto_exposure) {
    float exposure = t6.Load(int3(0, 0, 0)).x;
    r0.xyz *= cb0[98].x * (exposure - 1) + 1;
  }

  const bool sdr_output = 0.5 >= cb0[20].x;
  if (sdr_output) {
    float3 graded = cb0[99].xyz * r0.x + cb0[100].xyz * r0.y + cb0[101].xyz * r0.z;
    float exposure = auto_exposure ? (cb0[98].x * (1 - cb0[22].z) + cb0[22].z) : cb0[22].z;
    const bool tone_map_enabled = 0 != cb0[22].x;

    float3 untonemapped = tone_map_enabled ? (graded * exposure) : graded;
    float3 sdr_color = tone_map_enabled ? VanillaToneMap(untonemapped) : saturate(graded);

    // Vanilla:
    // r0.xyz = VanillaSDREncode(sdr_color, cb0[20].y);

    // RenoDX: linear result, then the RenoDX intermediate encoding so UI blends on top
    float3 color;
    if (RENODX_TONE_MAP_TYPE == 0.f) {
      color = renodx::color::srgb::Decode(VanillaSDREncode(sdr_color, cb0[20].y));
    } else {
      color = tone_map_enabled
                  ? renodx::draw::ToneMapPass(untonemapped, sdr_color)
                  : renodx::draw::ToneMapPass(untonemapped);
      color = ApplyBrightnessGamma(color, cb0[20].y);
    }
    r0.xyz = renodx::draw::RenderIntermediatePass(color);
  }

  o0.w = (0.5 < cb0[104].x) ? dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003)) : 0;

  // Dither
  r0.w = frac(52.9829178 * frac(dot(v0.xy, float2(0.0671105608, 0.00583714992))));
  r0.xyz = (r0.w * 2 - 0.5) * 0.00392156886 + r0.xyz;

  if (!sdr_output) {
    // HDR mode: PQ encode (scene 1.0 = 100 nits), sample the LUT built by 0xF609D63C
    r1.xyz = renodx::color::pq::Encode(max(0, r0.xyz), 100.f);
    r0.xyz = t4.Sample(s5_s, r1.xyz * 0.96875 + 0.015625).xyz;
  }

  if (0.5 < cb0[25].x) {
    // Overlay mask (elemental sight, outlines)
    r1.xyz = t5.Sample(s2_s, v1.xy).xyz;
    if (cb0[25].y < 0.5) {
      r2.xy = 9.99999809 * r1.xy;
      r1.yw = saturate(r1.xy * -9.99999809 + 5.99999905);
      r0.w = 0.5 - min(0.5, cb0[26].x);
      r0.w = saturate(r0.w * -9.99999809 + r2.x);
      r0.w = cb0[30].w * (r1.y * r0.w);
      r2.xzw = r0.w * (cb0[30].xyz - r0.xyz) + r0.xyz;
      r0.w = 0.5 - min(0.5, cb0[27].x);
      r0.w = saturate(r0.w * -9.99999809 + r2.y);
      r0.w = cb0[31].w * (r1.w * r0.w);
      r2.xyz = r0.w * (cb0[31].xyz - r2.xzw) + r2.xzw;
      r0.w = 9.99999809 * r1.z;
      r1.y = saturate(r1.z * -9.99999809 + 5.99999905);
      r1.z = 0.5 - min(0.5, cb0[28].x);
      r0.w = saturate(r1.z * -9.99999809 + r0.w);
      r0.w = cb0[32].w * (r1.y * r0.w);
      o0.xyz = r0.w * (cb0[32].xyz - r2.xyz) + r2.xyz;
    } else {
      r1.yz = (floor(cb0[24].zw * v1.xy) + 0.5) * cb0[24].xy;
      r1.yz = t5.Sample(s2_s, r1.yz).zw;
      r1.yz = floor(r1.yz * 255 + 0.5) * 0.125 - 1;
      r2.xy = min(31, max(0, r1.zy));
      r1.yz = (r1.yz >= 0) ? 1 : 0;
      uint index_a = (uint)r2.x;
      uint index_b = (uint)r2.y;
      r2.xzw = r1.z * (cb0[index_a + 66].xyz - r0.xyz) + r0.xyz;
      r0.w = saturate(0.300000012 + r1.x);
      r0.w = r0.w * r0.w * r1.y;
      r0.w = saturate(r0.w * 5 - 1);
      o0.xyz = r0.w * (cb0[index_b + 34].xyz - r2.xzw) + r2.xzw;
    }
  } else {
    o0.xyz = r0.xyz;
  }
}
