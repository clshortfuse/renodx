#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[147];
}

// Hymer 2000

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[143].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[143].zz + -cb0[142].xy;
  r0.xy = cb0[142].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[143].w > 0) {
    r1.zw = cb0[143].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[143].x * r2.x;
    r1.x = cb0[143].y * r1.x;
    r2.y = min(1, abs(r1.x));
    r2.z = max(1, abs(r1.x));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = abs(r1.x) > 1 ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r1.x = min(1, r1.x);
    r1.x = r1.x < -r1.x ? -r2.y : r2.y;
    r1.x = r2.x * r1.x + -1;
    r1.zw = r0.xy * r1.xx + r0.zw;
  }
  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[144].xxxx * r0.xyzw * injectedData.fxCA;
  r2.xy = -cb0[131].xy * float2(0.5,0.5) + cb0[28].xy;
  r2.zw = min(r2.xy, r1.zw);
  r3.xyzw = t0.SampleBias(s0_s, r2.zw, cb0[4].x).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r0.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r0.xyzw;
  r4.xyzw = r0.xyzw * cb0[143].zzzz + float4(0.5,0.5,0.5,0.5);
  r0.xyzw = r0.xyzw * cb0[143].zzzz + -cb0[142].xyxy;
  r0.xyzw = cb0[142].zwzw * r0.xyzw;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[143].w > 0) {
    r2.zw = cb0[143].xy * r1.xx;
    sincos(r2.z, r5.x, r6.x);
    r2.z = r5.x / r6.x;
    r2.w = 1 / r2.w;
    r2.z = r2.z * r2.w + -1;
    r2.zw = r0.xy * r2.zz + r4.xy;
  } else {
    r3.y = 1 / r1.x;
    r3.y = cb0[143].x * r3.y;
    r1.x = cb0[143].y * r1.x;
    r3.z = min(1, abs(r1.x));
    r3.w = max(1, abs(r1.x));
    r3.w = 1 / r3.w;
    r3.z = r3.z * r3.w;
    r3.w = r3.z * r3.z;
    r5.x = r3.w * 0.0208350997 + -0.0851330012;
    r5.x = r3.w * r5.x + 0.180141002;
    r5.x = r3.w * r5.x + -0.330299497;
    r3.w = r3.w * r5.x + 0.999866009;
    r5.x = r3.z * r3.w;
    r5.x = r5.x * -2 + 1.57079637;
    r5.x = abs(r1.x) > 1 ? r5.x : 0;
    r3.z = r3.z * r3.w + r5.x;
    r1.x = min(1, r1.x);
    r1.x = r1.x < -r1.x ? -r3.z : r3.z;
    r1.x = r3.y * r1.x + -1;
    r2.zw = r0.xy * r1.xx + r4.xy;
  }
  r0.xy = min(r2.zw, r2.xy);
  r5.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r0.x = dot(r0.zw, r0.zw);
  r0.x = sqrt(r0.x);
  if (cb0[143].w > 0) {
    r1.xy = cb0[143].xy * r0.xx;
    sincos(r1.x, r1.x, r4.x);
    r0.y = r1.x / r4.x;
    r1.x = 1 / r1.y;
    r0.y = r0.y * r1.x + -1;
    r1.xy = r0.zw * r0.yy + r4.zw;
  } else {
    r0.y = 1 / r0.x;
    r0.y = cb0[143].x * r0.y;
    r0.x = cb0[143].y * r0.x;
    r2.z = min(1, abs(r0.x));
    r2.w = max(1, abs(r0.x));
    r2.w = 1 / r2.w;
    r2.z = r2.z * r2.w;
    r2.w = r2.z * r2.z;
    r3.y = r2.w * 0.0208350997 + -0.0851330012;
    r3.y = r2.w * r3.y + 0.180141002;
    r3.y = r2.w * r3.y + -0.330299497;
    r2.w = r2.w * r3.y + 0.999866009;
    r3.y = r2.z * r2.w;
    r3.y = r3.y * -2 + 1.57079637;
    r3.y = abs(r0.x) > 1 ? r3.y : 0;
    r2.z = r2.z * r2.w + r3.y;
    r0.x = min(1, r0.x);
    r0.x = r0.x < -r0.x ? -r2.z : r2.z;
    r0.x = r0.y * r0.x + -1;
    r1.xy = r0.zw * r0.xx + r4.zw;
  }
  r0.xy = min(r1.xy, r2.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r2.xyz = renodx::color::srgb::DecodeSafe(float3(r3.x, r5.y, r0.z));
  r0.xy = -cb0[135].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.xy = min(r1.zw, r0.xy);
  r0.xyzw = t1.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r0.xyz = r0.xyz * r0.xyz;
  if (cb0[139].x > 0) {
    r3.xyz = r0.xyz * r0.www;
    r0.xyz = float3(8,8,8) * r3.xyz;
  }
  r0.xyz = cb0[138].xxx * r0.xyz * injectedData.fxBloom;
  r0.xyz = r0.xyz * cb0[138].yzw + r2.xyz;
  if (cb0[146].z > 0) {
    r1.xy = -cb0[146].xy + r1.zw;
    r1.yz = cb0[146].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[145].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[146].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[145].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[145].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[136].www * r0.xyz;
  if (cb0[137].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[137].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[137].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  r0.xyz = lutShaper(r0.xyz, false, 1);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyw = cb0[136].zzz * r0.xyz;
  r0.w = floor(r0.w);
  r1.xy = float2(0.5,0.5) * cb0[136].xy;
  r1.yz = r0.xy * cb0[136].xy + r1.xy;
  r1.x = r0.w * cb0[136].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r0.x = cb0[136].y;
  r0.y = 0;
  r0.xy = r1.xz + r0.xy;
  r1.xyzw = t2.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.x = r0.z * cb0[136].z + -r0.w;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.xyz, cb0[136].z + 1u);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}