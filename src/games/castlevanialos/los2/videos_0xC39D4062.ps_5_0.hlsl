#include "../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
cbuffer cb4 : register(b4){
  float4 cb4[236];
}
cbuffer cb3 : register(b3){
  float4 cb3[77];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb4[9].xy * v5.xy;
  r1.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r2.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t3.Sample(s3_s, r0.xy).xyzw;
  r0.z = 1.16412401 * r2.w;
  r0.xy = r1.ww * float2(1.59579504,-0.81347698) + r0.zz;
  r0.yz = r0.ww * float2(-0.391449004,2.01782203) + r0.yz;
  r0.xyz = float3(-0.870655,0.529704988,-1.08166897) + r0.xyz;
  o0.xyz = cb4[8].xyz * r0.xyz;
  o0.w = cb4[8].w;
  o0 = saturate(o0);
  o0.rgb = renodx::color::srgb::Decode(o0.rgb);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
  return;
}