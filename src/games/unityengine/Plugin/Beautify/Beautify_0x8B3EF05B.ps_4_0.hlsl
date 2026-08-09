#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[24];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xw = float2(0,0);
  r0.yz = cb0[2].yx;
  r1.xyzw = v1.xyxy + r0.zwxy;
  r0.xyzw = v1.xyxy + -r0.xyzw;
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.x = renodx::color::y::from::NTSC1953(r1.xyz);
  r1.y = renodx::color::y::from::NTSC1953(r2.xyz);
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.x = renodx::color::y::from::NTSC1953(r0.xyz);
  r0.y = renodx::color::y::from::NTSC1953(r2.xyz);
  r0.z = min(r1.y, r0.y);
  r0.y = max(r1.y, r0.y);
  r0.y = max(r0.y, r0.x);
  r0.x = min(r0.z, r0.x);
  r0.x = min(r0.x, r1.x);
  r0.y = max(r0.y, r1.x);
  r0.x = -9.99999997e-07 + r0.x;
  r0.z = r0.y + -r0.x;
  r0.z = saturate(cb0[9].w / r0.z);
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.x = r0.w * 2 + -r0.x;
  r0.x = r0.x + -r0.y;
  r0.x = r0.x * r0.z;
  r0.x = cb0[9].x * r0.x;
  r0.x = max(-cb0[9].z, r0.x);
  r0.x = min(cb0[9].z, r0.x);
  r0.x = 1 + r0.x;
  r2.xyz = saturate(r1.xyz);
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r3.xyz = r2.yxx * r1.xyz;
  r2.xyz = r3.xyz * r2.zzy;
  r2.xyz = r2.xyz * cb0[7].www + float3(1,1,1);
  r1.xyz = r2.xyz * r1.xyz;
  o0.w = r1.w;
  r0.y = renodx::color::y::from::NTSC1953(r1.xyz);
  r0.y = 9.99999975e-05 + r0.y;
  r0.y = r0.w / r0.y;
  r1.xyz = r1.xyz * r0.yyy;
  r2.xyzw = t1.Sample(s3_s, v1.xy).xyzw;
  r2.xyz = cb0[15].xxx * r2.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * r0.xxx + r2.xyz;
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.w = 0.5 + -cb0[14].z;
  r1.xyz = saturate(r1.xyz * cb0[14].www + r1.www);
  r2.xyzw = t3.Sample(s1_s, w1.xy).xyzw;
  r1.xyz = r2.xyz * r1.xyz;
  r0.xyz = r1.xyz * cb0[14].yyy * injectedData.fxLens + r0.xyz;
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.y = min(r0.y, r0.z);
  r1.y = min(r1.y, r0.x);
  r1.x = saturate(r1.x + -r1.y);
  r1.x = 1 + -r1.x;
  r1.x = cb0[7].z * r1.x;
  r1.y = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.yzw = -r1.yyy + r0.xyz;
  r1.xyz = r1.xxx * r1.yzw + float3(1,1,1);
  r0.xyz = r1.xyz * r0.xyz;
  r1.xyz = r0.xyz * cb0[12].xyz + -r0.xyz;
  r0.xyz = cb0[12].www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[7].yyy + float3(0.5,0.5,0.5);
  r0.xyz = cb0[7].xxx * r0.xyz;
  r1.xyz = r0.www * cb0[18].xyz + -r0.xyz;
  r2.xy = -cb0[17].xy + w1.xy;
  r2.z = cb0[19].x * r2.y;
  r0.w = dot(r2.xz, r2.xz);
  r0.w = saturate(cb0[18].w * r0.w + cb0[23].z);
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xy = cb1[6].xy * v1.xy;
  r0.w = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r0.www;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = cb0[10].xxx * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}