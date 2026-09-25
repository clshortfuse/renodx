#include "../../common.hlsli"

Texture2D<float4> t5 : register(t5);
Texture3D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[47];
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

  r0.xyzw = cb0[0].xyxy * float4(v1, w1);
  r0.xyzw = min(cb0[0].zwzw, r0.xyzw);
  r1.x = t1.Sample(s1_s, r0.xy).x;
  r2.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r2.xyz = r2.xyz * r1.xxx;
  r1.xyzw = float4(1,1,-1,0) * cb0[35].xyxy;
  r3.xyzw = saturate(-r1.xywy * cb0[37].xxxx + v1.xyxy);
  r3.xyzw = cb0[29].xxxx * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r3.xyzw = r3.xyzw * float4(2,2,2,2) + r4.xyzw;
  r0.zw = saturate(-r1.zy * cb0[37].xx + v1.xy);
  r0.zw = cb0[29].xx * r0.zw;
  r4.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r4.xyzw = saturate(r1.zwxw * cb0[37].xxxx + v1.xyxy);
  r4.xyzw = cb0[29].xxxx * r4.xyzw;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.zw = saturate(v1.xy);
  r0.zw = cb0[29].xx * r0.zw;
  r5.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r3.xyzw = r5.xyzw * float4(4,4,4,4) + r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r4.xyzw = saturate(r1.zywy * cb0[37].xxxx + v1.xyxy);
  r4.xyzw = cb0[29].xxxx * r4.xyzw;
  r5.xyzw = t2.Sample(s2_s, r4.xy).xyzw;
  r3.xyzw = r5.xyzw + r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r4.zw).xyzw;
  r3.xyzw = r4.xyzw * float4(2,2,2,2) + r3.xyzw;
  r0.zw = saturate(r1.xy * cb0[37].xx + v1.xy);
  r0.zw = cb0[29].xx * r0.zw;
  r1.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r1.xyzw = r3.xyzw + r1.xyzw;
  r1.xyzw = cb0[37].yyyy * r1.xyzw * CUSTOM_BLOOM;
  r0.zw = v1.xy * cb0[36].xy + cb0[36].zw;
  r0.zw = cb0[0].xy * r0.zw;
  r0.zw = min(cb0[0].zw, r0.zw);
  r3.xyz = t3.Sample(s3_s, r0.zw).xyz;
  r4.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r3.xyz = cb0[37].zzz * r3.xyz * CUSTOM_LENS;
  r1.xyzw = float4(0.0625,0.0625,0.0625,1) * r1.xyzw;
  r5.xyz = cb0[38].xyz * r1.xyz;
  r5.w = 0.0625 * r1.w;
  r1.xyzw = r5.xyzw + r2.xyzw;
  r2.xyz = r3.xyz * r4.xyz;
  r2.w = 0;
  r1.xyzw = r2.xyzw + r1.xyzw;
  if (cb0[43].z < 0.5) {
    r0.zw = -cb0[41].xy + v1.xy;
    r2.yz = cb0[42].xx * abs(r0.wz) * min(1.f, CUSTOM_VIGNETTE);
    r0.z = cb0[25].x / cb0[25].y;
    r0.z = -1 + r0.z;
    r0.z = cb0[42].w * r0.z + 1;
    r2.x = r2.z * r0.z;
    r2.xy = saturate(r2.xy);
    r0.zw = log2(r2.xy);
    r0.zw = cb0[42].zz * r0.zw;
    r0.zw = exp2(r0.zw);
    r0.z = dot(r0.zw, r0.zw);
    r0.z = 1 + -r0.z;
    r0.z = max(0, r0.z);
    r0.z = log2(r0.z);
    r0.z = cb0[42].y * r0.z * max(1.f, CUSTOM_VIGNETTE);
    r0.z = exp2(r0.z);
    r2.xyz = float3(1,1,1) + -cb0[40].xyz;
    r2.xyz = r0.zzz * r2.xyz + cb0[40].xyz;
    r2.xyz = r2.xyz * r1.xyz;
    r0.w = -1 + r1.w;
    r2.w = r0.z * r0.w + 1;
  } else {
    r0.x = t5.Sample(s5_s, r0.xy).w;
    r0.x = renodx::color::srgb::DecodeSafe(r0.x);
    r0.yzw = float3(1,1,1) + -cb0[40].xyz;
    r0.yzw = r0.xxx * r0.yzw + cb0[40].xyz;
    r0.yzw = r1.xyz * r0.yzw + -r1.xyz;
    r2.xyz = cb0[43].yyy * r0.yzw + r1.xyz;
    r0.y = -1 + r1.w;
    r2.w = r0.x * r0.y + 1;
  }
  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.x = r0.x * 0.720000029 + -0.800000012;
  r0.x = saturate(-1.83715463 * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.z = r0.y * r0.x;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r0.x = r0.y * r0.x + -1;
  r0.x = -r0.x * 0.200000003 + 1;
  r0.x = max(1, r0.x);
  r0.xyw = r1.xyz * r0.xxx + float3(0.5,0.5,0.5);
  r0.xyz = r0.xyw * r0.zzz + -r2.xyz;
  r0.w = 0;
  r0.xyzw = cb0[43].xxxx * r0.xyzw + r2.xyzw;
  r0.xyzw = cb0[39].zzzz * r0.wxyz;
  r1.xyz = lutShaper(r0.yzw);
  if (CUSTOM_LUT_SAMPLE == 0.f) {
  r1.xyz = cb0[39].yyy * r1.xyz;
  r1.w = 0.5 * cb0[39].x;
  r1.xyz = r1.xyz * cb0[39].xxx + r1.www;
  r0.yzw = t4.Sample(s4_s, r1.xyz).xyz;
  } else {
    r0.yzw = renodx::lut::SampleTetrahedral(t4, r1.xyz, 1 / cb0[39].x);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.yzw = GradeAndDisplayMap(r0.yzw);
  }
  if (cb0[46].x > 0.5) {
    r0.x = renodx::color::y::from::BT709(saturate(r0.yzw));
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.yzw = PostToneMapScale(r0.yzw);
  }
  o0.xyzw = r0.yzwx;
  return;
}