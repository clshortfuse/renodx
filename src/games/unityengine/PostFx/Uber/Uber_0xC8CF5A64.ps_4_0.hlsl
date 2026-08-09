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
  float4 cb0[44];
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

  r0.xyzw = float4(0.0009765625,0.0009765625,0.0009765625,0.0009765625) * cb0[22].xyxy;
  r1.xyzw = -v1.xyyx * r0.xyzw + float4(1,1,1.5,1.5);
  r1.xy = float2(0.660000026,0.660000026) * r1.xy;
  r2.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xy = r1.xy * float2(2,2) + float2(-1,-1);
  r3.xy = float2(1,1) / cb0[22].xy;
  r1.xy = r3.xy * r1.xy;
  r1.xy = saturate(r1.xy * float2(225,225) + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r4.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r1.xyzw = r4.xyzw * r1.zzzz;
  r0.xy = v1.xy * r0.xy;
  r0.zw = v1.yx * r0.zw + float2(0.330000013,0.330000013);
  r4.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.xy = r0.xy * r3.xy;
  r0.xy = saturate(r0.xy * float2(250,250) + v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r5.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
  r0.xyzw = r5.xyzw * r0.zzzz + r1.xyzw;
  r1.xy = r4.yx * float2(2,2) + float2(-1,-1);
  r1.xy = r1.xy * r3.xy;
  r1.xy = saturate(r1.xy * float2(200,200) + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r0.xyzw = r1.xyzw * r4.zzzz + r0.xyzw;
  r1.xy = r2.yx * float2(2,2) + float2(-1,-1);
  r1.xy = r1.xy * r3.xy;
  r1.xy = saturate(r1.xy * float2(175,175) + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r0.xyzw = r1.xyzw * r2.zzzz + r0.xyzw;
  r1.x = 1;
  r1.z = cb0[34].x;
  r1.xyzw = cb0[32].xyxy * r1.xxzz;
  r2.zw = float2(-1,0);
  r2.x = cb0[34].x;
  r3.xyzw = saturate(-r1.xywy * r2.xxwx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t4.Sample(s4_s, r3.xy).xyzw;
  r3.xyzw = t4.Sample(s4_s, r3.zw).xyzw;
  r0.xyzw = r4.xyzw + r0.xyzw;
  r0.xyzw = r3.xyzw * float4(2,2,2,2) + r0.xyzw;
  r3.xy = saturate(-r1.zy * r2.zx + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t4.Sample(s4_s, r3.xy).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r3.xyzw = saturate(r1.zwxw * r2.zwxw + v1.xyxy);
  r4.xyzw = saturate(r1.zywy * r2.zxwx + v1.xyxy);
  r1.xy = saturate(r1.xy * r2.xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r2.xyzw = cb0[26].xxxx * r4.xyzw;
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t4.Sample(s4_s, r3.xy).xyzw;
  r3.xyzw = t4.Sample(s4_s, r3.zw).xyzw;
  r0.xyzw = r4.xyzw * float4(2,2,2,2) + r0.xyzw;
  r4.xy = saturate(v1.xy);
  r4.xy = cb0[26].xx * r4.xy;
  r4.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r0.xyzw = r4.xyzw * float4(4,4,4,4) + r0.xyzw;
  r0.xyzw = r3.xyzw * float4(2,2,2,2) + r0.xyzw;
  r3.xyzw = t4.Sample(s4_s, r2.xy).xyzw;
  r2.xyzw = t4.Sample(s4_s, r2.zw).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = r2.xyzw * float4(2,2,2,2) + r0.xyzw;
  r0.xyzw = r0.xyzw + r1.xyzw;
  r0.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r1.xyz = cb0[35].xyz * r0.xyz;
  r1.w = r0.w;
  r2.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, w1.xy).xyzw;
  r3.xyz = r3.xyz * r2.xxx;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t5.Sample(s5_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz * injectedData.fxLens;
  r0.xyz = r2.xyz * r0.xyz;
  r0.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = cb0[22].xy * v1.xy;
  r1.xy = float2(0.0078125,0.0078125) * r1.xy;
  r1.xyzw = t7.SampleLevel(s7_s, r1.xy, 0).xyzw;
  r1.w = asint(cb0[43].y);
  r1.xyz = r1.www * float3(1.61803401,1.61803401,1.61803401) + r1.xyz;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.xyz = cb0[40].www * r1.xyz;
  r1.xyz = cb0[43].zzz * r1.xyz;
  r0.xyz = r1.xyz * float3(0.00392156886,0.00392156886,0.00392156886) + r0.xyz;
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
  r1.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}