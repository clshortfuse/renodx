#include "../../common.hlsl"

Texture3D<float4> t4 : register(t4);
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
  float4 cb0[37];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
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
  r0.yz = float2(-0.5,-0.5) + v1.xy;
  r5.xy = r0.yz * cb0[28].zz + float2(0.5,0.5);
  r0.yz = r0.yz * cb0[28].zz + -cb0[29].xy;
  r0.yz = cb0[29].zw * r0.yz;
  r0.w = dot(r0.yz, r0.yz);
  r0.w = sqrt(r0.w);
  if (cb0[28].w > 0) {
    r6.xy = cb0[28].xy * r0.ww;
    sincos(r6.x, r6.x, r7.x);
    r5.w = r6.x / r7.x;
    r6.x = 1 / r6.y;
    r5.w = r5.w * r6.x + -1;
    r6.xy = r0.yz * r5.ww + r5.xy;
  } else {
    r5.w = 1 / r0.w;
    r5.w = cb0[28].x * r5.w;
    r0.w = cb0[28].y * r0.w;
    r6.z = min(1, abs(r0.w));
    r6.w = max(1, abs(r0.w));
    r6.w = 1 / r6.w;
    r6.z = r6.z * r6.w;
    r6.w = r6.z * r6.z;
    r7.x = r6.w * 0.0208350997 + -0.0851330012;
    r7.x = r6.w * r7.x + 0.180141002;
    r7.x = r6.w * r7.x + -0.330299497;
    r6.w = r6.w * r7.x + 0.999866009;
    r7.x = r6.z * r6.w;
    r7.x = r7.x * -2 + 1.57079637;
    r7.x = (abs(r0.w) > 1) ? r7.x : 0;
    r6.z = r6.z * r6.w + r7.x;
    r0.w = min(1, r0.w);
    r0.w = (r0.w < -r0.w) ? -r6.z : r6.z;
    r0.w = r5.w * r0.w + -1;
    r6.xy = r0.yz * r0.ww + r5.xy;
  }
  r6.xy = saturate(r6.xy);
  r0.yz = cb0[26].xx * r6.xy;
  r6.xyzw = t1.SampleLevel(s1_s, r0.yz, 0).xyzw;
  r1.xyzw = r1.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r7.xyzw = r1.xyzw * cb0[28].zzzz + float4(0.5,0.5,0.5,0.5);
  r1.xyzw = r1.xyzw * cb0[28].zzzz + -cb0[29].xyxy;
  r1.xyzw = cb0[29].zwzw * r1.xyzw;
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  if (cb0[28].w > 0) {
    r0.zw = cb0[28].xy * r0.yy;
    sincos(r0.z, r5.x, r8.x);
    r0.z = r5.x / r8.x;
    r0.w = 1 / r0.w;
    r0.z = r0.z * r0.w + -1;
    r0.zw = r1.xy * r0.zz + r7.xy;
  } else {
    r5.x = 1 / r0.y;
    r5.x = cb0[28].x * r5.x;
    r0.y = cb0[28].y * r0.y;
    r5.y = min(1, abs(r0.y));
    r5.w = max(1, abs(r0.y));
    r5.w = 1 / r5.w;
    r5.y = r5.y * r5.w;
    r5.w = r5.y * r5.y;
    r8.x = r5.w * 0.0208350997 + -0.0851330012;
    r8.x = r5.w * r8.x + 0.180141002;
    r8.x = r5.w * r8.x + -0.330299497;
    r5.w = r5.w * r8.x + 0.999866009;
    r8.x = r5.y * r5.w;
    r8.x = r8.x * -2 + 1.57079637;
    r8.x = (abs(r0.y) > 1) ? r8.x : 0;
    r5.y = r5.y * r5.w + r8.x;
    r0.y = min(1, r0.y);
    r0.y = (r0.y < -r0.y) ? -r5.y : r5.y;
    r0.y = r5.x * r0.y + -1;
    r0.zw = r1.xy * r0.yy + r7.xy;
  }
  r0.zw = saturate(r0.zw);
  r0.yz = cb0[26].xx * r0.zw;
  r8.xyzw = t1.SampleLevel(s1_s, r0.yz, 0).xyzw;
  r0.y = dot(r1.zw, r1.zw);
  r0.y = sqrt(r0.y);
  if (cb0[28].w > 0) {
    r0.zw = cb0[28].xy * r0.yy;
    sincos(r0.z, r1.x, r5.x);
    r0.z = r1.x / r5.x;
    r0.w = 1 / r0.w;
    r0.z = r0.z * r0.w + -1;
    r0.zw = r1.zw * r0.zz + r7.zw;
  } else {
    r1.x = 1 / r0.y;
    r1.x = cb0[28].x * r1.x;
    r0.y = cb0[28].y * r0.y;
    r1.y = min(1, abs(r0.y));
    r5.x = max(1, abs(r0.y));
    r5.x = 1 / r5.x;
    r1.y = r5.x * r1.y;
    r5.x = r1.y * r1.y;
    r5.y = r5.x * 0.0208350997 + -0.0851330012;
    r5.y = r5.x * r5.y + 0.180141002;
    r5.y = r5.x * r5.y + -0.330299497;
    r5.x = r5.x * r5.y + 0.999866009;
    r5.y = r5.x * r1.y;
    r5.y = r5.y * -2 + 1.57079637;
    r5.y = (abs(r0.y) > 1) ? r5.y : 0;
    r1.y = r1.y * r5.x + r5.y;
    r0.y = min(1, r0.y);
    r0.y = (r0.y < -r0.y) ? -r1.y : r1.y;
    r0.y = r1.x * r0.y + -1;
    r0.zw = r1.zw * r0.yy + r7.zw;
  }
  r0.zw = saturate(r0.zw);
  r0.yz = cb0[26].xx * r0.zw;
  r1.xyzw = t1.SampleLevel(s1_s, r0.yz, 0).xyzw;
  r2.w = 1;
  r3.w = 1;
  r5.xyzw = r8.xyzw * r3.xyzw;
  r5.xyzw = r6.xyzw * r2.xyzw + r5.xyzw;
  r4.w = 1;
  r1.xyzw = r1.xyzw * r4.xyzw + r5.xyzw;
  r0.yzw = r3.xyz + r2.xyz;
  r2.xyz = r0.yzw + r4.xyz;
  r2.w = 3;
  r1.xyzw = r1.xyzw / r2.xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r1.xyz = r0.yzw * r0.xxx;
  r0.xyzw = cb0[36].zzzz * r1.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t4.Sample(s4_s, r0.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t4, r0.xyz, 1 / cb0[36].x);
  }
  r0.xyz = r1.xyz;
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.x = r1.w * 2 + -1;
  r1.y = saturate(r1.x * renodx::math::FLT_MAX + 0.5);
  r1.y = r1.y * 2 + -1;
  r1.x = 1 + -abs(r1.x);
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r1.x = r1.y * r1.x;
  r0.xyz = applyDither(r0.xyz, r1.x * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}