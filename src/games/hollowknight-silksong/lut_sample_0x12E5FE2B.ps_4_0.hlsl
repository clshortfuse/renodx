#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep  4 10:46:25 2025
Texture2D<float4> t1 : register(t1);  // 1D-LUT

Texture2D<float4> t0 : register(t0);  // Render

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.yw = float2(0.125, 0.375);
    r1.xyzw = t0.SampleLevel(s1_s, w1.xy, 0).zxyw;
    r0.xz = r1.yz;
    r2.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
    r0.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
    r2.xyz = float3(0, 1, 0) * r2.xyz;
    r0.xyz = r0.xyz * float3(1, 0, 0) + r2.xyz;
    o0.w = r1.w;
    r1.y = 0.625;
    r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
    r0.xyz = r1.xyz * float3(0, 0, 1) + r0.xyz;
    r0.w = dot(r0.xyz, float3(0.219999999, 0.707000017, 0.0710000023));
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = cb0[2].zzz * r0.xyz + r0.www;
    r0.xyz = r0.xyz * cb0[2].xxx + float3(-0.5, -0.5, -0.5);
    o0.xyz = r0.xyz * cb0[2].yyy + float3(0.5, 0.5, 0.5);

    o0 = saturate(o0);

    o0.rgb = renodx::color::srgb::Decode(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
    return;
  }

  float4 sampled_color = t0.SampleLevel(s1_s, w1.xy, 0).rgba;
  o0.a = sampled_color.a;

  float3 gamma_color = sampled_color.rgb;

  float3 untonemapped = renodx::color::srgb::Decode(gamma_color.rgb);

  if (CUSTOM_GRAIN_STRENGTH != 0.f) {
    untonemapped = renodx::effects::ApplyFilmGrain(
        untonemapped,
        v1.xy,
        CUSTOM_RANDOM,
        CUSTOM_GRAIN_STRENGTH * 0.03f,
        1.f);
  }

  float3 neutral_sdr = renodx::tonemap::renodrt::NeutralSDR(untonemapped);

  gamma_color = renodx::color::srgb::Encode(neutral_sdr);

  gamma_color.r = t1.Sample(s1_s, float2(gamma_color.r, 0.125)).r;
  gamma_color.g = t1.Sample(s1_s, float2(gamma_color.g, 0.375)).g;
  gamma_color.b = t1.Sample(s1_s, float2(gamma_color.b, 0.625)).b;
  float luma = dot(gamma_color, float3(0.219999999, 0.707000017, 0.0710000023));
  // Lerp luminance to desaturate
  gamma_color.rgb = lerp(luma, gamma_color.rgb, cb0[2].z);  // 0 = black & white

  // * `((b-a) * t) + a`        = `lerp(a, b, t)`
  // * `(t * (b-a)) + a`        = `lerp(a, b, t)`
  // * `(1-t)*a + t*b`          = `lerp(a, b, t)`
  // * `b*t + (a*(1-t))`        = `lerp(a, b, t)`
  // * `mad((b-a), t, a)`       = `lerp(a, b, t)`
  // * `mad(t, (b-a), a)`       = `lerp(a, b, t)`

  gamma_color = gamma_color * cb0[2].xxx + -0.5;  // Game Brightness Slider
  gamma_color = gamma_color * cb0[2].yyy + 0.5;

  float3 graded_color = renodx::color::srgb::DecodeSafe(gamma_color);

  float3 tonemapped = renodx::draw::ToneMapPass(untonemapped, graded_color, neutral_sdr);

  tonemapped = renodx::color::bt709::clamp::BT2020(tonemapped);

  o0.rgb = renodx::draw::RenderIntermediatePass(tonemapped);
  return;
}
