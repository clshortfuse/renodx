#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Sun Feb 22 01:32:30 2026

cbuffer _Globals : register(b0)
{
  float cameraNearTimesFar : packoffset(c0);
  float cameraFarMinusNear : packoffset(c0.y);
  float4 cameraNearFar : packoffset(c1);
  float timeSeed : packoffset(c2);
}

SamplerState LinearClampSampler_s : register(s9);
Texture2D<float4> texColor : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy;
  texColor.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.zw = fDest.xy;
  r0.z = r0.z;
  r0.w = r0.w;
  r1.x = 1 / r0.z;
  r1.y = 1 / r0.w;
  r0.z = frac(timeSeed);
  r0.zw = r0.xy + r0.zz;
  r1.z = dot(r0.zw, float2(12.9898005,78.2330017));
  r1.z = sin(r1.z);
  r1.z = 43758.5469 * r1.z;
  r2.x = frac(r1.z);
  r0.z = dot(float2(23.1406918,2.66514421), r0.zw);
  r0.z = 256 * r0.z;
  r0.z = 1.00000001e-07 + r0.z;
  r0.w = 123456792 / r0.z;
  r1.z = -r0.w;
  r1.w = max(r1.z, r0.w);
  r0.w = cmp(r0.w >= r1.z);
  r1.z = frac(r1.w);
  r1.w = -r1.z;
  r0.w = r0.w ? r1.z : r1.w;
  r0.z = r0.w * r0.z;
  r0.z = cos(r0.z);
  r2.y = frac(r0.z);
  r2.x = r2.x;
  r2.y = r2.y;
  r2.xy = r2.xy;
  r0.zw = float2(31,31) * r2.xy;
  r1.zw = float2(-15,-15);
  r0.zw = r1.zw + r0.zw;
  r2.xyzw = texColor.Sample(LinearClampSampler_s, v1.xy).xyzw;
  r0.zw = r0.zw * r1.xy;
  r0.xy = r0.xy + r0.zw;
  r0.xyzw = texColor.Sample(LinearClampSampler_s, r0.xy).xyzw;
  r1.xyz = -r0.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r3.xyz = -r1.xyz;
  r1.xyz = max(r3.xyz, r1.xyz);
  r1.x = r1.x + r1.y;
  r1.x = r1.x + r1.z;
  r1.x = cmp(r1.x < 0.0235294122);
  o0.xyzw = r1.xxxx ? r0.xyzw : r2.xyzw;

  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  o0.rgb = FilmGrain(o0.rgb, v1.xy);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}