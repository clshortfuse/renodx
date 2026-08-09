#include "../../common.hlsl"

Texture2D<float4> t7 : register(t7);
Texture3D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s7_s : register(s7);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[42];
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

  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[35].wwww * r0.xyzw * injectedData.fxCA;
  r0.xyzw = saturate(r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r1.xyzw = t1.SampleLevel(s1_s, r0.zw, 0).xyzw;
  r0.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r2.w = 1;
  r3.xyzw = t5.SampleLevel(s5_s, float2(0.5,0), 0).xyzw;
  r2.xyz = r3.xyz;
  r0.xyzw = r2.xyzw * r0.xyzw;
  r3.xy = saturate(v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r4.xyzw = t1.SampleLevel(s1_s, r3.xy, 0).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r5.w = 1;
  r6.xyzw = t5.SampleLevel(s5_s, float2(0.166666999,0), 0).xyzw;
  r5.xyz = r6.xyz;
  r2.xyz = r5.xyz + r2.xyz;
  r0.xyzw = r4.xyzw * r5.xyzw + r0.xyzw;
  r4.w = 1;
  r5.xyzw = t5.SampleLevel(s5_s, float2(0.833333015,0), 0).xyzw;
  r4.xyz = r5.xyz;
  r2.xyz = r4.xyz + r2.xyz;
  r0.xyzw = r1.xyzw * r4.xyzw + r0.xyzw;
  r2.w = 3;
  r0.xyzw = r0.xyzw / r2.xyzw;
  r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r2.xxx * r1.xyz;
  r1.xyzw = float4(1,1,-1,0) * cb0[32].xyxy;
  r2.xyzw = saturate(-r1.xywy * cb0[34].xxxx + v1.xyxy);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r4.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(2,2,2,2) + r4.xyzw;
  r4.xy = saturate(-r1.zy * cb0[34].xx + v1.xy);
  r4.xy = cb0[26].xx * r4.xy;
  r4.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r4.xyzw = saturate(r1.zwxw * cb0[34].xxxx + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t3.Sample(s3_s, r4.xy).xyzw;
  r4.xyzw = t3.Sample(s3_s, r4.zw).xyzw;
  r2.xyzw = r5.xyzw * float4(2,2,2,2) + r2.xyzw;
  r2.xyzw = r3.xyzw * float4(4,4,4,4) + r2.xyzw;
  r2.xyzw = r4.xyzw * float4(2,2,2,2) + r2.xyzw;
  r3.xyzw = saturate(r1.zywy * cb0[34].xxxx + v1.xyxy);
  r1.xy = saturate(r1.xy * cb0[34].xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t3.Sample(s3_s, r1.xy).xyzw;
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r2.xyzw = r3.xyzw * float4(2,2,2,2) + r2.xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = cb0[34].yyyy * r1.xyzw * injectedData.fxBloom;
  r2.xyzw = float4(0.0625,0.0625,0.0625,1) * r1.xyzw;
  r1.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r1.xyzw;
  r3.xyz = cb0[35].xyz * r2.xyz;
  r3.w = 0.0625 * r2.w;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz * injectedData.fxLens;
  r2.w = 0;
  r0.xyzw = r2.xyzw * r1.xyzw + r0.xyzw;
  if (injectedData.fxFilmGrainType == 0.f) {
  r1.x = renodx::color::y::from::BT709(saturate(r0.xyz));
  r1.x = sqrt(r1.x);
  r1.x = cb0[40].z * -r1.x + 1;
  r1.yz = w1.xy * cb0[41].xy + cb0[41].zw;
  r2.xyzw = t7.Sample(s7_s, r1.yz).xyzw;
  r1.yzw = r2.xyz * r0.xyz;
  r1.yzw = cb0[40].www * r1.yzw * injectedData.fxFilmGrain;
  r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  r0.xyzw = cb0[36].zzzz * r0.xyzw;
  o0.w = r0.w;
  r0.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r0.w = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r0.www;
  r0.xyzw = t6.Sample(s6_s, r0.xyz).xyzw;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t6, r0.xyz, 1 / cb0[36].x);
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