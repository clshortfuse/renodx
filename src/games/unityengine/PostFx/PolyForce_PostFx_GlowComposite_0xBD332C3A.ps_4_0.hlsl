#include "../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[57];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1;
  r0.z = cb0[55].x;
  r0.xyzw = cb0[54].xyxy * r0.xxzz;
  r1.zw = float2(-1,0);
  r1.x = cb0[55].x;
  r2.xyzw = -r0.xywy * r1.xxwx + w2.xyxy;
  r3.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s1_s, r2.zw).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r3.xyz;
  r3.xy = -r0.zy * r1.zx + w2.xy;
  r3.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = r0.zwxw * r1.zwxw + w2.xyxy;
  r4.xyzw = r0.zywy * r1.zxwx + w2.xyxy;
  r0.xy = r0.xy * r1.xx + w2.xy;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s1_s, r3.zw).xyzw;
  r1.xyz = r1.xyz * float3(2,2,2) + r2.xyz;
  r2.xyzw = t1.Sample(s1_s, w2.xy).xyzw;
  r1.xyz = r2.xyz * float3(4,4,4) + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r2.xyzw = t1.Sample(s1_s, r4.xy).xyzw;
  r3.xyzw = t1.Sample(s1_s, r4.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = r3.xyz * float3(2,2,2) + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[55].yyy * r0.xyz;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.xyz = r0.xyz * float3(0.0625,0.0625,0.0625) + r1.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  o0.w = r1.w;
  o0.xyz = cb0[56].xxx * r0.xyz;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}