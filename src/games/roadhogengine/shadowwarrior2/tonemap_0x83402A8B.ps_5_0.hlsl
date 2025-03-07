#include "../common.hlsl"

Texture2D<uint4> t4 : register(t4);
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
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[17].xy * v0.xy;
  r0.xyw = t2.SampleLevel(s6_s, r0.xy, 0).xyz;
  r1.xy = v0.xy * cb0[17].xy + cb1[9].xy;
  r1.xyz = t1.SampleLevel(s6_s, r1.xy, 0).xyz;
  r2.xy = (int2)v0.xy;
  r2.zw = float2(0,0);
  r3.xyz = t0.Load(r2.xyw).xyz;
  r1.w = t4.Load(r2.xyz).y;
  r1.w = (int)r1.w & 34;
  r1.xyz = r3.xyz * cb3[0].yyy + r1.xyz * injectedData.fxBloom;
  r0.xyw = r1.xyz + r0.xyw * injectedData.fxLens;
  if (injectedData.fxFilmGrainType == 0.f) {
  r1.xy = cb0[17].xy * v0.xy;
  r0.z = r1.y * 599.778992 + r1.x;
  r0.z = cb1[2].x + r0.z;
  r0.z = sin(r0.z);
  r0.z = 959681 * r0.z;
  r0.z = frac(r0.z);
  r0.z = r0.z * cb1[2].y * injectedData.fxFilmGrain + cb1[2].z;
  r0.xyz = r0.xyw * r0.zzz;
  } else {
    r0.rgb = applyFilmGrain(r0.rga, v1);
  }
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
  r0.xyz = r1.www ? r3.xyz : r0.xyz;
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