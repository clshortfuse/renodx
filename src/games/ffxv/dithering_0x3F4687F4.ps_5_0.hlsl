// ---- Created with 3Dmigoto v1.3.16 on Fri May 30 13:09:53 2025
#include "common.hlsl"
#include "shared.h"

cbuffer COLOR_FILTER_PARMS : register(b0)
{
  float WhiteX : packoffset(c0);
  float WhiteY : packoffset(c0.y);
  float WhiteZ : packoffset(c0.z);
  float HighRange : packoffset(c0.w);
  float TenPowLogHighRangePlusContrastMinusOne : packoffset(c1);
  float TenPowDispositionTimesTwoPowHighRange_PlusOne_Log_Inverse : packoffset(c1.y);
  float ZeroSlopeByTenPowDispositionPlusOne : packoffset(c1.z);
  float Param_n37 : packoffset(c1.w);
  float Param_n46 : packoffset(c2);
  float Param_n49 : packoffset(c2.y);
  float rotM : packoffset(c2.z);
  float rotY : packoffset(c2.w);
  float rotG : packoffset(c3);
  float rotB : packoffset(c3.y);
  float sAllsMExp2 : packoffset(c3.z);
  float sAllsYExp2 : packoffset(c3.w);
  float sAllsGExp2 : packoffset(c4);
  float sAllsBExp2 : packoffset(c4.y);
  float scAllscM : packoffset(c4.z);
  float scAllscY : packoffset(c4.w);
  float scAllscG : packoffset(c5);
  float scAllscB : packoffset(c5.y);
  float sM0Final : packoffset(c5.z);
  float sM1Final : packoffset(c5.w);
  float sM2Final : packoffset(c6);
  float sM3Final : packoffset(c6.y);
  float sM4Final : packoffset(c6.z);
  float sY0Final : packoffset(c6.w);
  float sY1Final : packoffset(c7);
  float sY2Final : packoffset(c7.y);
  float sY3Final : packoffset(c7.z);
  float sY4Final : packoffset(c7.w);
  float sG0Final : packoffset(c8);
  float sG1Final : packoffset(c8.y);
  float sG2Final : packoffset(c8.z);
  float sG3Final : packoffset(c8.w);
  float sG4Final : packoffset(c9);
  float sB0Final : packoffset(c9.y);
  float sB1Final : packoffset(c9.z);
  float sB2Final : packoffset(c9.w);
  float sB3Final : packoffset(c10);
  float sB4Final : packoffset(c10.y);
  bool CAT : packoffset(c10.z);
  bool HDR : packoffset(c10.w);
  bool Gamma : packoffset(c11);
  bool Dither : packoffset(c11.y);
  bool EnabledToneCurve : packoffset(c11.z);
  bool EnabledHue : packoffset(c11.w);
  bool EnabledSaturationALL : packoffset(c12);
  bool EnabledSaturation : packoffset(c12.y);
  bool EnabledSaturationClamp : packoffset(c12.z);
  bool EnabledSaturationByKido : packoffset(c12.w);
  bool EnabledTemporalAACheckerboard : packoffset(c13);
  float HDRGamutRatio : packoffset(c13.y);
  float ToneCurveInterpolation : packoffset(c13.z);
}

SamplerState g_sSampler_s : register(s0);
Texture2D<float4> g_tTex : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_tTex.SampleLevel(g_sSampler_s, v1.xy, 0).xyzw;

  if (HDR != 0) {
    // BT2020 -> BT709?
    // r1.x = dot(r0.xyz, float3(0.627399981,0.329299986,0.0432999991));
    // r1.y = dot(r0.xyz, float3(0.0691,0.919499993,0.0114000002));
    // r1.z = dot(r0.xyz, float3(0.0164000001,0.0879999995,0.895600021));
    r0.xyz = r0.xyz;
  };

  // srgb conversion
  // r1.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  // r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  // r3.xyz = log2(r0.xyz);
  // r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
  // r3.xyz = exp2(r3.xyz);
  // r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r1.xyz = r1.xyz ? r2.xyz : r3.xyz;

  // r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r0.xyz = Gamma ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;

  // dithering?
  r0.xyz = float3(256,256,256) * r0.xyz;
  r1.xyz = frac(r0.xyz);
  r2.xyzw = (int4)v0.xyxy;
  r3.xy = (int2)r2.zw & int2(1,1);
  r2.xyzw = (uint4)r2.xyzw >> int4(1,1,2,2);
  r2.xyzw = (int4)r2.xyzw & int4(1,1,1,1);
  r1.w = (int)r3.y ^ (int)r3.x;
  r4.xyzw = (int4)r2.yyww ^ (int4)r2.xxzz;
  r3.z = (int)r3.y & (int)r3.x;
  r5.xy = (int2)r2.yw & (int2)r2.xz;
  r3.xy = (int2)r1.ww * (int2)r3.xy;
  r2.xyzw = (int4)r2.zwxy * (int4)r4.zwxy;
  r3.xy = (int2)r3.xy * int2(2,3);
  r1.w = (int)r3.y + (int)r3.x;
  r1.w = mad((int)r3.z, 1, (int)r1.w);
  r2.zw = (int2)r2.zw * int2(2,3);
  r2.z = (int)r2.w + (int)r2.z;
  r2.z = mad((int)r5.x, 1, (int)r2.z);
  r1.w = (uint)r1.w << 2;
  r1.w = (int)r2.z + (int)r1.w;
  r2.x = (uint)r2.x << 1;
  r1.w = mad((int)r1.w, 4, (int)r2.x);
  r1.w = mad((int)r2.y, 3, (int)r1.w);
  r1.w = (int)r5.y + (int)r1.w;
  r1.xyz = float3(64,64,64) * r1.xyz;
  r1.xyz = (uint3)r1.xyz;
  r1.xyz = cmp((uint3)r1.www < (uint3)r1.xyz);
  r1.xyz = r1.xyz ? float3(1,1,1) : 0;
  r0.xyz = floor(r0.xyz);
  r0.xyz = r0.xyz + r1.xyz;
  o0.xyz = float3(0.00390625,0.00390625,0.00390625) * r0.xyz;

  o0.xyz = Gamma ? renodx::color::srgb::DecodeSafe(o0.xyz) : r0.xyz;

  o0.w = r0.w;
  return;
}