#include "./common.hlsl"

cbuffer _Globals : register(b0){
  float _g_fBrightness : packoffset(c0);
  float _g_fContrast : packoffset(c1);
  float _g_fGamma : packoffset(c2);
  float4 _g_vDiffuseColor : packoffset(c3);
}
SamplerState _g_sSlot0_s : register(s0);
SamplerState _g_sSlot1_s : register(s1);
SamplerState _g_sSlot2_s : register(s2);
Texture2D<float4> _TMP14 : register(t0);
Texture2D<float4> _TMP15 : register(t1);
Texture2D<float4> _TMP16 : register(t2);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = _TMP14.Sample(_g_sSlot0_s, v1.xy).w;
  r0.z = _TMP15.Sample(_g_sSlot1_s, v1.xy).w;
  r1.x = _TMP16.Sample(_g_sSlot2_s, v1.xy).w;
  r0.yw = r1.xx;
  r0.xyzw = float4(-0.0627451017,-0.501960814,-0.501960814,-0.501960814) + r0.xyzw;
  r1.xyz = float3(1.16438353,1.59602666,0.391762257) * r0.xyz;
  r0.x = r0.x * 1.16438353 + -r1.z;
  r2.y = -r0.w * 0.812967598 + r0.x;
  r2.z = r0.z * 2.01723218 + r1.x;
  r2.x = r1.x + r1.y;
  r0.xyz = _g_vDiffuseColor.xyz * r2.xyz;
  r0.xyz = max(float3(0.0009765625,0.0009765625,0.0009765625), r0.xyz);
  o0.xyz = r0.xyz;
  o0.w = _g_vDiffuseColor.w;
  o0 = saturate(o0);
  o0.rgb = renodx::color::gamma::Decode(o0.rgb, 2.2f);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}