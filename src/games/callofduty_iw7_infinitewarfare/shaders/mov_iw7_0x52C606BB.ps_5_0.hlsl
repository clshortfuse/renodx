// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 17 18:33:51 2025
#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb2[0].xy * v1.xy;
  r1.y = t2.Sample(s2_s, r0.xy).x;
  r1.z = t3.Sample(s3_s, r0.xy).x;
  r1.x = t1.Sample(s1_s, r0.xy).x;
  r0.w = t4.Sample(s4_s, r0.xy).x;
  r1.w = 1;
  r0.y = dot(float4(1,-0.714139998,-0.344139993,0.531215072), r1.xyzw);
  r0.x = dot(float3(1,1.40199995,-0.703749001), r1.xyw);
  r0.z = dot(float3(1,1.77199996,-0.889474511), r1.xzw);

  // r0.xyz = renodx::color::srgb::Decode(r0.xyz);
  r0.xyz = saturate(r0.xyz);
  r0.xyz = renodx::draw::UpscaleVideoPass(r0.xyz);
  // r0.xyz = PumboAutoHDR(r0.xyz);

  o0.xyzw = v2.xyzw * r0.xyzw;

  // o0.xyz = renodx::draw::UpscaleVideoPass(o0.xyz);
  return;
}