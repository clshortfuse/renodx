#include "../../common.hlsl"

Texture3D<float4> t7 : register(t7);
Texture2D<float4> t6 : register(t6);
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
  float4 cb0[37];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r0.yz = v1.xy * float2(2,2) + float2(-1,-1);
  r0.w = dot(r0.yz, r0.yz);
  r0.yz = r0.yz * r0.ww;
  r0.yz = cb0[35].ww * r0.yz * injectedData.fxCA;
  r1.xy = cb0[31].zw * -r0.yz;
  r1.xy = float2(0.5,0.5) * r1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = (int)r0.w;
  r0.w = max(3, (int)r0.w);
  r0.w = min(16, (int)r0.w);
  r1.x = (int)r0.w;
  r0.yz = -r0.yz / r1.xx;
  r2.y = 0;
  r3.w = 1;
  r4.xyzw = float4(0,0,0,0);
  r5.xyzw = float4(0,0,0,0);
  r1.yz = v1.xy;
  r1.w = 0;
  while (true) {
    r2.z = cmp((int)r1.w >= (int)r0.w);
    if (r2.z != 0) break;
    r2.z = (int)r1.w;
    r2.z = 0.5 + r2.z;
    r2.x = r2.z / r1.x;
    r2.zw = saturate(r1.yz);
    r2.zw = cb0[26].xx * r2.zw;
    r6.xyzw = t2.SampleLevel(s2_s, r2.zw, 0).xyzw;
    r7.xyzw = t6.SampleLevel(s6_s, r2.xy, 0).xyzw;
    r3.xyz = r7.xyz;
    r4.xyzw = r6.xyzw * r3.xyzw + r4.xyzw;
    r5.xyzw = r5.xyzw + r3.xyzw;
    r1.yz = r1.yz + r0.yz;
    r1.w = (int)r1.w + 1;
  }
  r1.xyzw = r4.xyzw / r5.xyzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.x = 1;
  r0.z = cb0[34].x;
  r0.xyzw = cb0[32].xyxy * r0.xxzz;
  r2.x = cb0[34].x;
  r2.zw = float2(-1,0);
  r3.xy = float2(1,1) / cb0[22].xy;
  r4.xyzw = float4(0.0009765625,0.0009765625,0.0009765625,0.0009765625) * cb0[22].xyxy;
  r3.zw = v1.xy * r4.xy;
  r5.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r3.zw = r5.xy * float2(2,2) + float2(-1,-1);
  r6.xyzw = -v1.xyyx * r4.xyzw + float4(1,1,1.5,1.5);
  r4.xy = float2(0.660000026,0.660000026) * r6.xy;
  r7.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r4.xy = r7.xy * float2(2,2) + float2(-1,-1);
  r4.zw = v1.yx * r4.zw + float2(0.330000013,0.330000013);
  r8.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r4.zw = r8.yx * float2(2,2) + float2(-1,-1);
  r6.xyzw = t0.Sample(s0_s, r6.zw).xyzw;
  r5.xy = r6.yx * float2(2,2) + float2(-1,-1);
  r3.zw = r3.zw * r3.xy;
  r3.zw = saturate(r3.zw * float2(250,250) + v1.xy);
  r3.zw = cb0[26].xx * r3.zw;
  r9.xyzw = t4.Sample(s4_s, r3.zw).xyzw;
  r3.zw = r4.xy * r3.xy;
  r3.zw = saturate(r3.zw * float2(225,225) + v1.xy);
  r3.zw = cb0[26].xx * r3.zw;
  r10.xyzw = t4.Sample(s4_s, r3.zw).xyzw;
  r7.xyzw = r10.xyzw * r7.zzzz;
  r7.xyzw = r9.xyzw * r5.zzzz + r7.xyzw;
  r3.zw = r4.zw * r3.xy;
  r3.zw = saturate(r3.zw * float2(200,200) + v1.xy);
  r3.zw = cb0[26].xx * r3.zw;
  r4.xyzw = t4.Sample(s4_s, r3.zw).xyzw;
  r4.xyzw = r4.xyzw * r8.zzzz + r7.xyzw;
  r3.xy = r5.xy * r3.xy;
  r3.xy = saturate(r3.xy * float2(175,175) + v1.xy);
  r3.xy = cb0[26].xx * r3.xy;
  r3.xyzw = t4.Sample(s4_s, r3.xy).xyzw;
  r3.xyzw = r3.xyzw * r6.zzzz + r4.xyzw;
  r4.xyzw = saturate(-r0.xywy * r2.xxwx + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw + r3.xyzw;
  r4.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r4.xy = saturate(-r0.zy * r2.zx + v1.xy);
  r4.xy = cb0[26].xx * r4.xy;
  r4.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = saturate(r0.zwxw * r2.zwxw + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(2,2,2,2) + r3.xyzw;
  r4.xy = saturate(v1.xy);
  r4.xy = cb0[26].xx * r4.xy;
  r5.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(4,4,4,4) + r3.xyzw;
  r4.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r4.xyzw = saturate(r0.zywy * r2.zxwx + v1.xyxy);
  r4.xyzw = cb0[26].xxxx * r4.xyzw;
  r5.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw + r3.xyzw;
  r4.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.xy = saturate(r0.xy * r2.xx + v1.xy);
  r0.xy = cb0[26].xx * r0.xy;
  r0.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r0.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r0.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t5.Sample(s5_s, r2.xy).xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.xyz = cb0[34].zzz * r2.xyz * injectedData.fxLens;
  r3.xyz = cb0[35].xyz * r0.xyz;
  r3.w = r0.w;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r0.xyz = r2.xyz * r0.xyz;
  r0.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[36].zzzz * r0.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t7.Sample(s7_s, r0.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t7, r0.xyz, 1 / cb0[36].x);
  }
  r0.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r2.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.x = r2.w * 2 + -1;
  r0.y = saturate(r0.x * renodx::math::FLT_MAX + 0.5);
  r0.y = r0.y * 2 + -1;
  r0.x = 1 + -abs(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.y * r0.x;
  r0.xyz = applyDither(r1.xyz, r0.x * 1.0 / 255.0);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}