#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 15 21:16:03 2024

cbuffer HDRDisplayMappingCB : register(b0) {
  float _NitsForPaperWhite : packoffset(c0);
  uint _DisplayCurve : packoffset(c0.y);
  float _SoftShoulderStart : packoffset(c0.z);
  float _MaxBrightnessOfTV : packoffset(c0.w);
  float _MaxBrightnessOfHDRScene : packoffset(c1);
  float _ColorGamutExpansion : packoffset(c1.y);
}

SamplerState _Sampler0_s : register(s0);
Texture2D<float4> _MainTex : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _MainTex.Sample(_Sampler0_s, v1.xy).xyzw;
  o0.w = r0.w;

  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), 2.2f);  // linearize

  if (RENODX_TONE_MAP_TYPE == 0) {
    float3 bt709 = r0.xyz;

    // highlight‑driven weight: 0 at 2.0, 1 at 10.0
    float max_rgb = renodx::math::Max(bt709);
    float highlight_weight = saturate((max_rgb - 2.0f) / 8.f);

    // BT.709 -> expanded gamut (stronger)
    const float3x3 expanded_high_mat = {
      { 0.710796118f, 0.247670293f, 0.0415336005f },
      { 0.0434204005f, 0.943510771f, 0.0130687999f },
      { -0.00108149997f, 0.0272474997f, 0.973834097f }
    };

    // BT.709 -> expanded gamut (weaker)
    const float3x3 expanded_low_mat = {
      { 0.627403975f, 0.329281986f, 0.0433136001f },
      { 0.0457456f, 0.941776991f, 0.0124771995f },
      { -0.00121054996f, 0.0176040996f, 0.983606994f }
    };

    float3 expanded_high = mul(expanded_high_mat, bt709);
    float3 expanded_low = mul(expanded_low_mat, bt709);
    // apply stronger gamut expansion to highlights
    float3 expanded = lerp(expanded_low, expanded_high, highlight_weight);

    float3 bt2020 = renodx::color::bt2020::from::BT709(bt709);

    // slider blends expanded result with standard BT.2020
    bt2020 = lerp(bt2020, expanded, _ColorGamutExpansion);

    r0.rgb = renodx::color::pq::Encode(abs(bt2020), _NitsForPaperWhite);
  } else {
    if (RENODX_TONE_MAP_TYPE == 3.f) {
      r0.rgb = max(0, r0.rgb);
    }
    r0.xyz = renodx::color::bt2020::from::BT709(r0.xyz);
    r0.rgb *= RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_TONE_MAP_TYPE == 2.f) {
      r0.rgb = min(r0.rgb, RENODX_PEAK_WHITE_NITS);
    }
    r0.xyz = renodx::color::pq::EncodeSafe(r0.xyz, 1.f);
  }
  o0.xyz = r0.xyz;
  return;
}
