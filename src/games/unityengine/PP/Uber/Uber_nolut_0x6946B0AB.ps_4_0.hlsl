#include "../../tonemap.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[41];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.y = dot(r1.zw, r1.zw);
  r1.xyzw = r1.xyzw * r0.yyyy;
  r1.xyzw = cb0[35].wwww * r1.xyzw * injectedData.fxCA;
  r2.xyzw = t3.SampleLevel(s3_s, float2(0.166666999,0), 0).xyzw;
  r3.xyzw = t3.SampleLevel(s3_s, float2(0.5,0), 0).xyzw;
  r4.xyzw = t3.SampleLevel(s3_s, float2(0.833333015,0), 0).xyzw;
  r0.yz = saturate(v1.xy);
  r0.yz = cb0[26].xx * r0.yz;
  r5.xyzw = t1.SampleLevel(s1_s, r0.yz, 0).xyzw;
  r1.xyzw = saturate(r1.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r6.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s1_s, r1.zw, 0).xyzw;
  r2.w = 1;
  r3.w = 1;
  r6.xyzw = r6.xyzw * r3.xyzw;
  r5.xyzw = r5.xyzw * r2.xyzw + r6.xyzw;
  r4.w = 1;
  r1.xyzw = r1.xyzw * r4.xyzw + r5.xyzw;
  r0.yzw = r3.xyz + r2.xyz;
  r2.xyz = r0.yzw + r4.xyz;
  r2.w = 3;
  r1.xyzw = r1.xyzw / r2.xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r0.xyz = r0.yzw * r0.xxx;
  if (cb0[40].y < 0.5) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx) * min(1.f, injectedData.fxVignette);
    r0.w = cb0[22].x / cb0[22].y;
    r0.w = -1 + r0.w;
    r0.w = cb0[39].w * r0.w + 1;
    r1.x = r1.z * r0.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r0.w = dot(r1.xy, r1.xy);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[39].y * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r1.xyz * r0.xyz;
    r2.x = -1 + r1.w;
    r2.w = r0.w * r2.x + 1;
  } else {
    r3.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
    r3.xyz = float3(1,1,1) + -cb0[37].xyz;
    r3.xyz = r3.www * r3.xyz + cb0[37].xyz;
    r3.xyz = r0.xyz * r3.xyz + -r0.xyz;
    r1.xyz = cb0[40].xxx * r3.xyz + r0.xyz;
    r0.x = -1 + r1.w;
    r2.w = r3.w * r0.x + 1;
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r1.xyz = applyUserNoTonemap(r1.xyz);
  }
  r0.xyz = r1.xyz;
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r1.x = r1.x * 2 + -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r2.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r2.xyz = PostToneMapScale(r2.xyz, true);
  } else {
    r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
  }
  o0.xyzw = r2.xyzw;
  return;
}