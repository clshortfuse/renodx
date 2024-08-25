#include "./shared.h"
#include "./hueHelper.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Aug 15 21:16:03 2024

cbuffer HDRDisplayMappingCB : register(b0)
{
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
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = _MainTex.Sample(_Sampler0_s, v1.xy).xyzw;
  o0.w = r0.w;

  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), 2.2f);  // linearize

  if (injectedData.toneMapType == 0) {
    // bt2020 conversion + gamut expansion
    r0.w = max(r0.x, r0.y);
    r0.w = max(r0.w, r0.z);
    r0.w = -2 + r0.w;
    r0.w = saturate(0.125 * r0.w);
    r1.x = dot(float3(0.710796118,0.247670293,0.0415336005), r0.xyz);
    r1.y = dot(float3(0.0434204005,0.943510771,0.0130687999), r0.xyz);
    r1.z = dot(float3(-0.00108149997,0.0272474997,0.973834097), r0.xyz);
    r1.xyz = r1.xyz * r0.www;
    r0.w = 1 + -r0.w;
    r2.x = dot(float3(0.627403975,0.329281986,0.0433136001), r0.xyz);
    r2.y = dot(float3(0.0457456,0.941776991,0.0124771995), r0.xyz);
    r2.z = dot(float3(-0.00121054996,0.0176040996,0.983606994), r0.xyz);
    r1.xyz = r0.www * r2.xyz + r1.xyz;
    r1.xyz = _ColorGamutExpansion * r1.xyz;
    r0.w = 1 + -_ColorGamutExpansion;
    r2.x = dot(float3(0.627403975,0.329281986,0.0433136001), r0.xyz);
    r2.y = dot(float3(0.0690969974,0.919539988,0.0113612004), r0.xyz);
    r2.z = dot(float3(0.0163915996,0.088013202,0.895595014), r0.xyz);
    r0.xyz = r0.www * r2.xyz + r1.xyz;

    // paper white + pq encoding
    r0.w = 9.99999975e-005 * _NitsForPaperWhite;
    r0.xyz = r0.xyz * r0.www;
    r0.xyz = pow(abs(r0.xyz), 0.1593017578125f);
    r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
    r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = pow(r0.xyz, 78.84375f);
  } else {
    if (injectedData.toneMapType != 1) {
      const float paperWhite = injectedData.toneMapGameNits / renodx::color::srgb::REFERENCE_WHITE;
      r0.xyz *= paperWhite;
      const float peakWhite = injectedData.toneMapPeakNits / renodx::color::srgb::REFERENCE_WHITE;
      const float highlightsShoulderStart = paperWhite;  // Don't tonemap the "SDR" range (in luminance), we want to keep it looking as it used to look in SDR
      r0.xyz = renodx::tonemap::dice::BT709(r0.xyz, peakWhite, highlightsShoulderStart);
      r0.xyz /= paperWhite;
    }
    r0.xyz = Hue(r0.xyz, injectedData.toneMapHueCorrection);
    r0.xyz = renodx::color::bt2020::from::BT709(r0.xyz);
    r0.xyz = renodx::color::pq::from::BT2020((r0.xyz * injectedData.toneMapGameNits) / 10000.f);
  }
  o0.xyz = r0.xyz;
  return;
}