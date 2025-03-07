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
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = float2(0,0);
  r0.xyz = t0.Load(r0.xyz).xyz;
  r1.xy = v0.xy * cb0[17].xy + cb1[9].xy;
  r1.xyz = t1.SampleLevel(s6_s, r1.xy, 0).xyz;
  r0.xyz = r0.xyz * cb3[0].yyy + r1.xyz * injectedData.fxBloom;
  r1.xy = cb0[17].xy * v0.xy;
  r2.xyz = t2.SampleLevel(s6_s, r1.xy, 0).xyz;
  r0.xyz = r2.xyz * injectedData.fxLens + r0.xyz;
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.w = r1.y * 599.778992 + r1.x;
  r0.w = cb1[2].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = 959681 * r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * cb1[2].y * injectedData.fxFilmGrain + cb1[2].z;
  r0.xyz = r0.xyz * r0.www;
  } else {
    r0.rgb = applyFilmGrain(r0.rgb, v1);
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