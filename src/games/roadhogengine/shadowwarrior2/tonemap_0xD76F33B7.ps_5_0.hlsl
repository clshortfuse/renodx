#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
cbuffer cb1 : register(b1){
  float4 cb1[10];
}
cbuffer cb3 : register(b3){
  float4 cb3[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[18];
}

void main(
  float4 v0 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v0.xy * cb0[17].xy + cb1[9].xy;
  r0.xyz = t1.SampleLevel(s6_s, r0.xy, 0).xyz;
  r1.xyzw = v0.xyxy * cb0[17].xyxy + -cb1[4].xyxy;
  r2.xy = cb0[17].xy * v0.xy;
  r1.xyzw = cb1[4].zzww * r1.xyzw + r2.xyxy;
  r2.xyz = t2.SampleLevel(s6_s, r2.xy, 0).xyz;
  r0.w = t0.SampleLevel(s6_s, r1.xy, 0).y;
  r1.x = t0.SampleLevel(s6_s, r1.zw, 0).z;
  r3.xy = (int2)v0.xy;
  r3.zw = float2(0,0);
  r1.yzw = t0.Load(r3.xyz).xyz;
  r2.w = -r1.z + r0.w;
  r2.w = 0.0500000007 * abs(r2.w);
  r2.w = min(1, r2.w);
  r3.x = r1.z + -r0.w;
  r1.z = r2.w * r3.x + r0.w;
  r0.w = r1.x + -r1.w;
  r0.w = 0.0500000007 * abs(r0.w);
  r0.w = min(1, r0.w);
  r2.w = r1.w + -r1.x;
  r1.w = r0.w * r2.w + r1.x;
  r0.xyz = r1.yzw * cb3[0].yyy + r0.xyz * injectedData.fxBloom;
  r0.xyz = r0.xyz + r2.xyz * injectedData.fxLens;
  r1.xyz = r0.xyz;
  r0.a = renodx::color::y::from::NTSC1953(r1.rgb);
  r1.xyz = cb1[3].xyz * r0.www;
  r0.xyz = r0.xyz * cb1[0].zzz + -r1.xyz;
  r0.xyz = cb1[3].www * r0.xyz + r1.xyz;
  r0.a = renodx::color::y::from::NTSC1953(r0.rgb);
  r0.w = saturate(cb1[7].w * r0.w);
  r1.xyz = -cb1[7].xyz + cb1[6].xyz;
  r1.xyz = r0.www * r1.xyz + cb1[7].xyz;
  r0.xyz = r1.xyz * r0.xyz;
  o0.rgb = applyUserTonemapACES(r0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb, true);
  o0.w = 1;
  return;
}