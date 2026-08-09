#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[36];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = saturate(v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r1.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.x = dot(r1.zw, r1.zw);
  r1.xyzw = r2.xxxx * r1.xyzw;
  r1.xyzw = cb0[35].wwww * r1.xyzw * injectedData.fxCA;
  r1.xyzw = saturate(r1.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r2.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s1_s, r1.zw, 0).xyzw;
  r3.w = 1;
  r4.xyzw = t3.SampleLevel(s3_s, float2(0.5,0), 0).xyzw;
  r3.xyz = r4.xyz;
  r2.xyzw = r3.xyzw * r2.xyzw;
  r4.w = 1;
  r5.xyzw = t3.SampleLevel(s3_s, float2(0.166666999,0), 0).xyzw;
  r4.xyz = r5.xyz;
  r3.xyz = r4.xyz + r3.xyz;
  r0.xyzw = r0.xyzw * r4.xyzw + r2.xyzw;
  r2.w = 1;
  r4.xyzw = t3.SampleLevel(s3_s, float2(0.833333015,0), 0).xyzw;
  r2.xyz = r4.xyz;
  r3.xyz = r3.xyz + r2.xyz;
  r0.xyzw = r1.xyzw * r2.xyzw + r0.xyzw;
  r3.w = 3;
  r0.xyzw = r0.xyzw / r3.xyzw;
  o0.w = r0.w;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r1.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r1.xxx * r0.xyz;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}