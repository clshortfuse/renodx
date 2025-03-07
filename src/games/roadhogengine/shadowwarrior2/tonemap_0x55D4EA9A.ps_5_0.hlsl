#include "../common.hlsl"

Texture2D<uint4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
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
  float4 cb0[19];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[17].xy * v0.xy;
  r0.xyz = t2.SampleLevel(s6_s, r0.xy, 0).xyz;
  r1.xy = cb0[18].xy * v0.xy;
  r1.xyz = t3.SampleLevel(s6_s, r1.xy, 0).xyz;
  r1.xyz = float3(-1,-1,-1) + r1.xyz;
  r2.xyz = cb1[0].yyy * r1.xyz + float3(1,1,1);
  r1.xyz = cb1[0].xxx * r1.xyz + float3(1,1,1);
  r3.xy = v0.xy * cb0[17].xy + cb1[9].xy;
  r3.xyz = t1.SampleLevel(s6_s, r3.xy, 0).xyz;
  r1.xyz = r3.xyz * r1.xyz;
  r3.xy = (int2)v0.xy;
  r3.zw = float2(0,0);
  r4.xyz = t0.Load(r3.xyw).xyz;
  r0.w = t4.Load(r3.xyz).y;
  r0.w = (int)r0.w & 34;
  r1.xyz = r4.xyz * cb3[0].yyy + r1.xyz * injectedData.fxBloom;
  r0.xyz = r0.xyz * r2.xyz * injectedData.fxLens + r1.xyz;
  r1.xyz = r0.xyz;
  r1.r = renodx::color::y::from::NTSC1953(r1.rgb);
  r1.xyz = cb1[3].xyz * r1.xxx;
  r0.xyz = r0.xyz * cb1[0].zzz + -r1.xyz;
  r0.xyz = cb1[3].www * r0.xyz + r1.xyz;
  r1.xyz = -cb1[8].xyz + r0.xyz;
  r1.x = abs(r1.x) + abs(r1.y);
  r1.x = r1.x + abs(r1.z);
  r1.x = saturate(cb1[8].w * r1.x);
  r1.g = renodx::color::y::from::NTSC1953(r0.rgb);
  r1.y = saturate(cb1[7].w * r1.y);
  r2.xyz = -cb1[7].xyz + cb1[6].xyz;
  r1.yzw = r1.yyy * r2.xyz + cb1[7].xyz;
  r2.r = renodx::color::y::from::NTSC1953(cb1[6].xyz);
  r1.yzw = -r2.xxx + r1.yzw;
  r1.xyz = r1.xxx * r1.yzw + r2.xxx;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = r0.www ? r4.xyz : r0.xyz;
  r0.w = dot(v1.xy, v1.xy);
  r0.w = saturate(r0.w * cb1[0].w + cb1[1].w);
  r1.x = r0.w * r0.w;
  r0.w = -r0.w * 2 + 3;
  r0.w = r1.x * r0.w;
  r0.w = min(1, r0.w);
  r1.xyz = float3(1,1,1) + -cb1[1].xyz;
  r1.xyz = lerp(1.f, r0.www, injectedData.fxVignette) * r1.xyz + cb1[1].xyz;
  r0.xyz = r1.xyz * r0.xyz;
  o0.rgb = applyUserTonemapACES(r0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb, true);
  o0.w = 1;
  return;
}