#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Thu Sep 05 23:49:44 2024
Buffer<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[53];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  uint v3 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.xy = min(cb2[22].zw, r0.xy);
  r0.xyz = t0.Sample(s0_s, r0.xy).xyz;
  r1.xyz = (int3)r0.xyz & int3(0x7f800000,0x7f800000,0x7f800000);
  r1.xyz = cmp((int3)r1.xyz != int3(0x7f800000,0x7f800000,0x7f800000));
  r0.xyz = r1.xyz ? r0.xyz : float3(65000,65000,65000);
  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), cb3[0].xxx);
  r0.w = t1.Load(float4(1,1,1,1)).x;
  r1.x = t1.Load(float4(2,2,2,2)).x;
  r1.xyz = r0.xyz * r0.www + r1.xxx;
  r1.xyz = max(float3(9.99999975e-006,9.99999975e-006,9.99999975e-006), r1.xyz);
  r0.xyz = r0.xyz / r1.xyz;
  r0.w = max(r0.y, r0.z);
  r0.w = max(r0.x, r0.w);
  r0.w = max(9.99999975e-006, r0.w);
  r0.xyz = r0.xyz / r0.www;
  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), cb3[0].yyy);
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r1.w = -cb3[0].w * cb3[1].x + r0.w;
  r1.w = max(0, r1.w);
  r1.w = cb3[0].z * r1.w;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  if (injectedData.toneMapType == 0) {
    r0.xyz = max(float3(0,0,0), r0.xyz); // clamp to bt.709
    r0.xyz = min(cb3[1].xxx, r0.xyz);    // cap luminance
  }
  r0.xyz = r0.xyz / cb3[1].xxx;
  r0.xyz = sign(r0.xyz) * pow(abs(r0.xyz), cb3[1].yyy);
  o0.xyz = cb3[1].xxx * r0.xyz;
    
  o0.xyz = renodx::color::grade::UserColorGrading(
        o0.xyz,
        injectedData.colorGradeExposure,
        injectedData.colorGradeHighlights,
        injectedData.colorGradeShadows,
        injectedData.colorGradeContrast,
        1.f,
        0.f,
        0.f);

  return;
}