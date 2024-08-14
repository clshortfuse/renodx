// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 11 16:49:32 2024
// Main UI shader

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 WhiteColorInterpolationRGBA : packoffset(c0);
  float4 BlackColorInterpolationRGBA : packoffset(c1);
  float SaturationScale : packoffset(c2);
  float vATest : packoffset(c2.y);
}

SamplerState __smpsStage0_s : register(s0);
Texture2D<float4> sStage0 : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = sStage0.Sample(__smpsStage0_s, v2.xy).xyzw;
  r1.xyzw = v1.xyzw * r0.xyzw;
  r0.w = cmp(r1.w < vATest);
  if (r0.w != 0) discard;
  r2.xyz = WhiteColorInterpolationRGBA.xyz * WhiteColorInterpolationRGBA.xyz;
  r3.xyz = BlackColorInterpolationRGBA.xyz * BlackColorInterpolationRGBA.xyz;
  r0.xyz = -r0.xyz * v1.xyz + float3(1,1,1);
  r0.xyz = r3.xyz * r0.xyz;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298909992,0.586610019,0.114480004));
  r0.xyz = r0.xyz + -r0.www;
  o0.xyz = SaturationScale * r0.xyz + r0.www;
  o0.w = r1.w;
  
    o0.rgb = renodx::math::SafePow(o0.rgb, 2.2f); //2.2 gamma correction
    o0.rgb *= injectedData.toneMapUINits / injectedData.toneMapGameNits; //Ratio of UI:Game brightness
    o0.rgb = renodx::math::SafePow(o0.rgb, 1/2.2); //Inverse 2.2 gamma
  
  
  return;
}