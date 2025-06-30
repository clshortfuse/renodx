#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 15:39:53 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[5];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(cb0[3].w < 0);
  if (r0.x != 0) {
    r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
    r1.xyz = float3(1,1,1) / cb0[3].xyz;
    r1.xyz = float3(255,255,255) * r1.xyz;
    r2.xyz = ceil(r1.xyz);
    r1.xyz = floor(r1.xyz);
    r1.xyz = r2.xyz / r1.xyz;
    r0.xyz = r0.xyz / cb0[3].xyz;
    r0.w = asint(cb0[4].w);
    r2.xy = cb0[4].xy * v0.xy;
    r2.xy = r2.xy / cb0[4].zz;
    r2.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
    r1.w = r2.x * 2 + -1;
    r0.w = -1 + r0.w;
    r0.w = r1.w / r0.w;
    r0.xyz = r0.xyz + r0.www;
    r0.xyz = float3(255,255,255) * r0.xyz;
    r0.xyz = floor(r0.xyz);
    r0.xyz = r0.xyz * r1.xyz;
    r0.xyz = cb0[3].xyz * r0.xyz;
    o0.xyz = float3(0.00392156886,0.00392156886,0.00392156886) * r0.xyz;
    o0.w = 1;
    return;
  }
  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.x = dot(r0.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.y = 1 / cb0[3].w;
  r0.y = 255 * r0.y;
  r0.z = ceil(r0.y);
  r0.y = floor(r0.y);
  r0.y = r0.z / r0.y;
  r0.x = r0.x / cb0[3].w;
  r0.z = asint(cb0[4].w);
  r1.xy = cb0[4].xy * v0.xy;
  r1.xy = r1.xy / cb0[4].zz;
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.x * 2 + -1;
  r0.z = -1 + r0.z;
  r0.z = r0.w / r0.z;
  r0.x = r0.x + r0.z;
  r0.x = 255 * r0.x;
  r0.x = floor(r0.x);
  r0.x = r0.x * r0.y;
  r0.x = cb0[3].w * r0.x;
  o0.xyz = float3(0.00392156886,0.00392156886,0.00392156886) * r0.xxx;
  o0.w = 1;

  //o0.rgb = renodx::draw::RenderIntermediatePass(renodx::color::srgb::Encode(o0.rgb));

  return;
}