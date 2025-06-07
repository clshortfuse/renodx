#include "./common.hlsl"

cbuffer cbMaterial : register(b1){
  float4 g_location0 : packoffset(c0);
  float4 g_location1 : packoffset(c1);
  float4 g_location2 : packoffset(c2);
  float4 g_location3 : packoffset(c3);
  float4 g_uv0 : packoffset(c4);
  float4 g_uv1 : packoffset(c5);
  float4 g_uv2 : packoffset(c6);
  float4 g_uv3 : packoffset(c7);
  float4 g_color : packoffset(c8);
  float g_threshold : packoffset(c9);
}
SamplerState g_Sampler_LinearClamp_s : register(s1);
Texture2D<float4> g_textureVideo0 : register(t0);
Texture2D<float4> g_textureVideo1 : register(t1);

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cmp(v1.xy >= float2(0,0));
  r0.zw = cmp(float2(1,1) >= v1.xy);
  r0.xyzw = r0.xyzw ? float4(1,1,1,1) : 0;
  r0.xy = r0.xy * r0.zw;
  r0.w = r0.x * r0.y;
  r1.x = g_textureVideo0.Sample(g_Sampler_LinearClamp_s, v1.xy).x;
  r1.yz = g_textureVideo1.Sample(g_Sampler_LinearClamp_s, v1.xy).xy;
  r1.xyz = r1.xyz * float3(1.125,0.871999979,1.23000002) + float3(-0.0625,-0.43599999,-0.61500001);
  r0.x = dot(r1.xz, float2(1,1.13982999));
  r0.y = dot(r1.xyz, float3(1,-0.394650012,-0.580600023));
  r0.z = dot(r1.xy, float2(1,2.03210998));
  o0.xyzw = g_color.xyzw * r0.xyzw;
  o0 = saturate(o0);
  o0.rgb = InverseToneMap(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}