#include "../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = cb0[5].xyxy * float4(0,-0.5,0.5,0.5) + v1.xyxy;
  r1.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s1_s, r0.zw).xyzw;
  r2.xyzw = t0.Sample(s1_s, v1.xy).xyzw;
  r0.x = r2.w + r1.w;
  r0.x = r0.x + r0.w;
  r0.yz = cb0[5].xy * float2(-0.5,0.5) + v1.xy;
  r1.xyzw = t0.Sample(s1_s, r0.yz).xyzw;
  r0.x = r1.w + r0.x;
  r0.x = 0.25 * r0.x;
  r0.x = r0.x * r0.x;
  r0.x = r0.x * cb0[2].w + -cb0[3].x;
  r0.xyz = r2.xyz + r0.xxx;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  r1.xy = float2(0.1,0.2) + v1.xy;
  r1.xy = r1.xy * cb0[2].xy + cb0[2].zz;
  r1.xyzw = t2.Sample(s0_s, r1.xy).xyzw;
  r0.w = -0.5 + r1.x;
  r0.w = (1.0 / 255.0) * r0.w;
  r1.xyzw = t1.Sample(s2_s, w1.xy).xyzw;
  r1.xyz = r1.xyz * cb0[5].zzz * injectedData.fxBloom + r0.www;
  r0.xyz = r1.xyz + r0.xyz;
  o0.xyz = cb0[6].xxx * r0.xyz;
  if(injectedData.countOld == injectedData.countNew){
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = 1;
  return;
}