#include "./shared.h"

cbuffer psConstant3 : register(b2)
{
  float3 uRGB : packoffset(c0);
  float tmp : packoffset(c0.w);
  float4 uFlags : packoffset(c1);
  float4 uRGBcol : packoffset(c2);
}

SamplerState smpAlbedo_s : register(s0);
Texture2D<float4> texAlbedo : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : COLOR0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = float3(-0.5,-0.5,-0.5) + v0.xyz;
  r0.xyz = r0.xyz * uRGB.xyz + float3(0.5,0.5,0.5);
  r1.x = cmp(0.000000 == w1.x);
  if (r1.x != 0) {
    r1.xyzw = texAlbedo.Sample(smpAlbedo_s, v1.xy).xyzw;
    r0.w = v0.w;
    r0.xyzw = r1.xyzw * r0.xyzw;
  } else {
    r0.w = v0.w;
  }
  r1.x = cmp(1.000000 == uFlags.y);
  r1.y = cmp(0.000000 == r0.w);
  r1.x = r1.y ? r1.x : 0;
  if (r1.x != 0) discard;
  r1.x = cmp(0 < uRGBcol.w);
  r1.yzw = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r1.yzw = uRGBcol.xyz * r1.yzw;
  r1.yzw = r1.yzw * float3(1.10000002,1.10000002,1.10000002) + float3(0.5,0.5,0.5);
  r0.xyz = r1.xxx ? r1.yzw  * (injectedData.toneMapUINits / injectedData.toneMapGameNits) : r0.xyz;
  o0.xyzw = r0.xyzw;

  //o0.xyz *= injectedData.toneMapUINits / injectedData.toneMapGameNits;  // added
  return;
}