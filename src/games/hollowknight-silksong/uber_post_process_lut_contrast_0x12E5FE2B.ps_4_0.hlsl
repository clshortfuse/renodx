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

  [branch]
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

  } else {
    float4 sampled_color = t0.SampleLevel(s1_s, w1.xy, 0).rgba;
    o0.a = sampled_color.a;

    float3 gamma_color = sampled_color.rgb;

    float3 untonemapped = renodx::color::srgb::Decode(gamma_color.rgb);

    float3 neutral_sdr = lerp(
        renodx::tonemap::renodrt::NeutralSDR(untonemapped),        // Luminance
        renodx::tonemap::ExponentialRollOff(untonemapped, 0.75f),  // Per channel
        CUSTOM_SATURATION_CLIP);

    bool hue_correct = (CUSTOM_HUE_CLIP != 1.f);
    float compression_scale = 1.f;
    [branch]
    if (hue_correct) {
      neutral_sdr = renodx::color::correct::Hue(neutral_sdr, untonemapped, 1.f - CUSTOM_HUE_CLIP);
    }

    float3 neutral_gamma = renodx::color::srgb::EncodeSafe(neutral_sdr);

    float max_channel = max(max(max(neutral_gamma.r, neutral_gamma.g), neutral_gamma.b), 1.f);
    float3 lut_input_color = neutral_gamma / max_channel;
    gamma_color = lut_input_color;

    [branch]
    if (hue_correct) {
      float grayscale = renodx::color::y::from::BT709(gamma_color.rgb);
      compression_scale = renodx::color::correct::ComputeGamutCompressionScale(gamma_color.rgb, grayscale);
      gamma_color = renodx::color::correct::GamutCompress(gamma_color, grayscale, compression_scale);
    }

    gamma_color.r = t1.Sample(s0_s, float2(gamma_color.r, 0.125)).r;
    gamma_color.g = t1.Sample(s0_s, float2(gamma_color.g, 0.375)).g;
    gamma_color.b = t1.Sample(s0_s, float2(gamma_color.b, 0.625)).b;

    [branch]
    if (hue_correct) {
      gamma_color = renodx::color::correct::GamutDecompress(gamma_color, compression_scale);
    }

    gamma_color = gamma_color * max_channel;
    float luma = dot(gamma_color, float3(0.219999999, 0.707000017, 0.0710000023));
    gamma_color.rgb = lerp(luma, gamma_color.rgb, cb0[2].z);  // 0 = black & white
    gamma_color = gamma_color * cb0[2].xxx;                   // Game Brightness Slider
    gamma_color = lerp(0.5f, gamma_color, cb0[2].yyy);        // (b-a) * t + a  = lerp(a, b, t)

    float3 graded_color = renodx::color::srgb::DecodeSafe(gamma_color);

    o0.rgb = renodx::draw::ToneMapPass(untonemapped, graded_color, neutral_sdr);

    [branch]
    if (CUSTOM_GRAIN_STRENGTH != 0.f) {
      o0.rgb = renodx::effects::ApplyFilmGrain(
          o0.rgb,
          v1.xy,
          CUSTOM_RANDOM,
          CUSTOM_GRAIN_STRENGTH * 0.03f,
          1.f);
    }
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}
