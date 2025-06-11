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
Texture2D<float4> g_texture : register(t0);

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_texture.Sample(g_Sampler_LinearClamp_s, v1.xy).xyzw;
  o0.xyzw = g_color.xyzw * r0.xyzw;
  o0 = saturate(o0);
  o0.rgb = renodx::color::gamma::Decode(o0.rgb, 2.2f);
  o0.rgb = PostToneMapScale(o0.rgb);
  o0.rgb = FinalizeOutput(o0.rgb);
  return;
}