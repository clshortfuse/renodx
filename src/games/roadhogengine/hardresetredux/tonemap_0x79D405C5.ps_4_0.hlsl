#include "../common.hlsl"

Texture2D<float4> t12 : register(t12);
SamplerState s7_s : register(s7);
cbuffer cb1 : register(b1){
  float4 cb1[13];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb1[0].xy + cb1[0].zw;
  r0.xyzw = t12.SampleLevel(s7_s, r0.xy, 0).xyzw;
  r0.xyz = float3(4,4,4) * r0.xyz;
  r0.rgb = 1.06504106f * r0.rgb;
  if (injectedData.toneMapType == 0.f) {
    r0.rgb = saturate(r0.rgb);
  }
  r0.a = renodx::color::y::from::BT709(r0.rgb);
  r0.xyz = -cb1[12].xyz * r0.www + r0.xyz;
  r1.xyz = cb1[12].xyz * r0.www;
  r0.xyz = cb1[9].zzz * r0.xyz + r1.xyz;
  o0.a = renodx::color::y::from::BT709(r0.rgb);
  o0.xyz = r0.xyz;
  o0.rgb = applyUserTonemap(o0.rgb, v1, false);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}