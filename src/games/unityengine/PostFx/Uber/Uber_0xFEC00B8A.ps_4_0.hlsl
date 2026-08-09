#include "../../common.hlsl"

Texture2D<float4> t8 : register(t8);
Texture2D<float4> t7 : register(t7);
Texture3D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s8_s : register(s8);
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[22].xy * v1.xy;
  r0.xy = float2(0.0078125,0.0078125) * r0.xy;
  r0.xyzw = t8.SampleLevel(s8_s, r0.xy, 0).xyzw;
  r0.w = asint(cb0[43].y);
  r0.xyz = r0.www * float3(1.61803401,1.61803401,1.61803401) + r0.xyz;
  r0.xyz = frac(r0.xyz);
  r1.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
  r2.xyzw = t2.Sample(s2_s, w1.xy).xyzw;
  r2.xyz = r2.xyz * r1.xxx;
  r1.x = 1;
  r1.z = cb0[34].x;
  r1.xyzw = cb0[32].xyxy * r1.xxzz;
  r3.x = cb0[34].x;
  r3.zw = float2(-1,0);
  r4.xy = float2(1,1) / cb0[22].xy;
  r5.xyzw = float4(0.0009765625,0.0009765625,0.0009765625,0.0009765625) * cb0[22].xyxy;
  r4.zw = v1.xy * r5.xy;
  r6.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r4.zw = r6.xy * float2(2,2) + float2(-1,-1);
  r7.xyzw = -v1.xyyx * r5.xyzw + float4(1,1,1.5,1.5);
  r5.xy = float2(0.660000026,0.660000026) * r7.xy;
  r8.xyzw = t0.Sample(s0_s, r5.xy).xyzw;
  r5.xy = r8.xy * float2(2,2) + float2(-1,-1);
  r5.zw = v1.yx * r5.zw + float2(0.330000013,0.330000013);
  r9.xyzw = t0.Sample(s0_s, r5.zw).xyzw;
  r5.zw = r9.yx * float2(2,2) + float2(-1,-1);
  r7.xyzw = t0.Sample(s0_s, r7.zw).xyzw;
  r6.xy = r7.yx * float2(2,2) + float2(-1,-1);
  r4.zw = r4.zw * r4.xy;
  r4.zw = saturate(r4.zw * float2(250,250) + v1.xy);
  r4.zw = cb0[26].xx * r4.zw;
  r10.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r4.zw = r5.xy * r4.xy;
  r4.zw = saturate(r4.zw * float2(225,225) + v1.xy);
  r4.zw = cb0[26].xx * r4.zw;
  r11.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r8.xyzw = r11.xyzw * r8.zzzz;
  r8.xyzw = r10.xyzw * r6.zzzz + r8.xyzw;
  r4.zw = r5.zw * r4.xy;
  r4.zw = saturate(r4.zw * float2(200,200) + v1.xy);
  r4.zw = cb0[26].xx * r4.zw;
  r5.xyzw = t4.Sample(s4_s, r4.zw).xyzw;
  r5.xyzw = r5.xyzw * r9.zzzz + r8.xyzw;
  r4.xy = r6.xy * r4.xy;
  r4.xy = saturate(r4.xy * float2(175,175) + v1.xy);
  r4.xy = cb0[26].xx * r4.xy;
  r4.xyzw = t4.Sample(s4_s, r4.xy).xyzw;
  r4.xyzw = r4.xyzw * r7.zzzz + r5.xyzw;
  r5.xyzw = saturate(-r1.xywy * r3.xxwx + v1.xyxy);
  r5.xyzw = cb0[26].xxxx * r5.xyzw;
  r6.xyzw = t4.Sample(s4_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw + r4.xyzw;
  r5.xyzw = t4.Sample(s4_s, r5.zw).xyzw;
  r4.xyzw = r5.xyzw * float4(2,2,2,2) + r4.xyzw;
  r5.xy = saturate(-r1.zy * r3.zx + v1.xy);
  r5.xy = cb0[26].xx * r5.xy;
  r5.xyzw = t4.Sample(s4_s, r5.xy).xyzw;
  r4.xyzw = r5.xyzw + r4.xyzw;
  r5.xyzw = saturate(r1.zwxw * r3.zwxw + v1.xyxy);
  r5.xyzw = cb0[26].xxxx * r5.xyzw;
  r6.xyzw = t4.Sample(s4_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw * float4(2,2,2,2) + r4.xyzw;
  r5.xy = saturate(v1.xy);
  r5.xy = cb0[26].xx * r5.xy;
  r6.xyzw = t4.Sample(s4_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw * float4(4,4,4,4) + r4.xyzw;
  r5.xyzw = t4.Sample(s4_s, r5.zw).xyzw;
  r4.xyzw = r5.xyzw * float4(2,2,2,2) + r4.xyzw;
  r5.xyzw = saturate(r1.zywy * r3.zxwx + v1.xyxy);
  r5.xyzw = cb0[26].xxxx * r5.xyzw;
  r6.xyzw = t4.Sample(s4_s, r5.xy).xyzw;
  r4.xyzw = r6.xyzw + r4.xyzw;
  r5.xyzw = t4.Sample(s4_s, r5.zw).xyzw;
  r4.xyzw = r5.xyzw * float4(2,2,2,2) + r4.xyzw;
  r1.xy = saturate(r1.xy * r3.xx + v1.xy);
  r1.xy = cb0[26].xx * r1.xy;
  r1.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r1.xyzw = r4.xyzw + r1.xyzw;
  r1.xyzw = float4(0.0625,0.0625,0.0625,0.0625) * r1.xyzw;
  r3.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r3.xyzw = t5.Sample(s5_s, r3.xy).xyzw;
  r1.xyzw = cb0[34].yyyy * r1.xyzw * injectedData.fxBloom;
  r3.xyz = cb0[34].zzz * r3.xyz * injectedData.fxLens;
  r4.xyz = cb0[35].xyz * r1.xyz;
  r4.w = r1.w;
  r2.xyzw = r4.xyzw + r2.xyzw;
  r1.xyz = r3.xyz * r1.xyz;
  r1.w = 0;
  r1.xyzw = r2.xyzw + r1.xyzw;
  if (cb0[40].y < 0.5) {
    r2.xy = -cb0[38].xy + v1.xy;
    r2.yz = cb0[39].xx * abs(r2.yx) * min(1.f, injectedData.fxVignette);
    r0.w = cb0[22].x / cb0[22].y;
    r0.w = -1 + r0.w;
    r0.w = cb0[39].w * r0.w + 1;
    r2.x = r2.z * r0.w;
    r2.xy = saturate(r2.xy);
    r2.xy = log2(r2.xy);
    r2.xy = cb0[39].zz * r2.xy;
    r2.xy = exp2(r2.xy);
    r0.w = dot(r2.xy, r2.xy);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[39].y * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r2.x = r0.x * 2 + -1;
    r0.w = r2.x * 0.0392156877 + r0.w;
    r2.xyz = float3(1,1,1) + -cb0[37].xyz;
    r2.xyz = r0.www * r2.xyz + cb0[37].xyz;
    r2.xyz = r2.xyz * r1.xyz;
    r2.w = -1 + r1.w;
    r3.w = r0.w * r2.w + 1;
  } else {
    r4.xyzw = t7.Sample(s7_s, v1.xy).xyzw;
    r0.w = renodx::color::srgb::DecodeSafe(r4.w);
    r2.w = r0.x * 2 + -1;
    r0.w = r2.w * 0.0392156877 + r0.w;
    r4.xyz = float3(1,1,1) + -cb0[37].xyz;
    r4.xyz = r0.www * r4.xyz + cb0[37].xyz;
    r4.xyz = r1.xyz * r4.xyz + -r1.xyz;
    r2.xyz = cb0[40].xxx * r4.xyz + r1.xyz;
    r1.x = -1 + r1.w;
    r3.w = r0.w * r1.x + 1;
  }
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = cb0[40].www * r0.xyz;
  r0.xyz = cb0[43].zzz * r0.xyz;
  r3.xyz = r0.xyz * float3(0.00392156886,0.00392156886,0.00392156886) + r2.xyz;
  r0.xyzw = cb0[36].zzzz * r3.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t6.Sample(s6_s, r0.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t6, r0.xyz, 1 / cb0[36].x);
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
  r0.xyz = applyDither(r1.xyz, r0.x * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}