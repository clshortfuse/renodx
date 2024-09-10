#include "./shared.h"

cbuffer cToneMapParam : register(b0)
{
  float4 cToneMapParam[2] : packoffset(c0);
}

SamplerState sInputS_s : register(s0);
SamplerState sLUTS_s : register(s1);
Texture2D<float4> sInputT : register(t0);
Texture3D<float4> sLUTT : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;

  r0.xyzw = sInputT.Sample(sInputS_s, v1.xy).xyzw;
  
  // skip all this in HDR, we don't want any of that
  if (injectedData.toneMapType == 0) {
    r0.xyz = saturate(r0.xyz);
    r1.xyz = log2(r0.xyz);
    r1.xyz = cToneMapParam[0].www * r1.xyz;
    r0.xyz = exp2(r1.xyz);
    r1.x = cmp(0 < cToneMapParam[0].z);
    if (r1.x != 0) {
      r1.xyz = r0.xyz * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);
      r1.xyz = sLUTT.Sample(sLUTS_s, r1.xyz).xyz;
      r1.xyz = r1.xyz + -r0.xyz;
      r0.xyz = cToneMapParam[0].zzz * r1.xyz + r0.xyz;
    }
  }

  o0.xyzw = r0.xyzw;
  return;
}