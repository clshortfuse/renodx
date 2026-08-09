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
  float4 cb0[41];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[28].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[28].zz + -cb0[29].xy;
  r0.xy = cb0[29].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[28].w > 0) {
    r1.zw = cb0[28].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[28].x * r2.x;
    r2.y = cb0[28].y * r1.x;
    r2.z = min(1, abs(r2.y));
    r2.w = max(1, abs(r2.y));
    r2.w = 1 / r2.w;
    r2.z = r2.z * r2.w;
    r2.w = r2.z * r2.z;
    r3.x = r2.w * 0.0208350997 + -0.0851330012;
    r3.x = r2.w * r3.x + 0.180141002;
    r3.x = r2.w * r3.x + -0.330299497;
    r2.w = r2.w * r3.x + 0.999866009;
    r3.x = r2.z * r2.w;
    r3.x = r3.x * -2 + 1.57079637;
    r3.x = abs(r2.y) > 1 ? r3.x : 0;
    r2.z = r2.z * r2.w + r3.x;
    r2.y = min(1, r2.y);
    r2.y = (r2.y < -r2.y) ? -r2.z : r2.z;
    r2.x = r2.x * r2.y + -1;
    r1.zw = r0.xy * r2.xx + r0.zw;
  }
  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r3.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r2.y = dot(r3.zw, r3.zw);
  r3.xyzw = r3.xyzw * r2.yyyy;
  r3.xyzw = cb0[35].wwww * r3.xyzw * injectedData.fxCA;
  r4.xyzw = t5.SampleLevel(s5_s, float2(0.166666999,0), 0).xyzw;
  r5.xyzw = t5.SampleLevel(s5_s, float2(0.5,0), 0).xyzw;
  r6.xyzw = t5.SampleLevel(s5_s, float2(0.833333015,0), 0).xyzw;
  if (cb0[28].w > 0) {
    r2.yz = cb0[28].xy * r1.xx;
    sincos(r2.y, r7.x, r8.x);
    r2.y = r7.x / r8.x;
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z + -1;
    r2.yz = r0.xy * r2.yy + r0.zw;
  } else {
    r2.w = 1 / r1.x;
    r2.w = cb0[28].x * r2.w;
    r1.x = cb0[28].y * r1.x;
    r7.x = min(1, abs(r1.x));
    r7.y = max(1, abs(r1.x));
    r7.y = 1 / r7.y;
    r7.x = r7.x * r7.y;
    r7.y = r7.x * r7.x;
    r7.z = r7.y * 0.0208350997 + -0.0851330012;
    r7.z = r7.y * r7.z + 0.180141002;
    r7.z = r7.y * r7.z + -0.330299497;
    r7.y = r7.y * r7.z + 0.999866009;
    r7.z = r7.x * r7.y;
    r7.z = r7.z * -2 + 1.57079637;
    r7.z = abs(r1.x) > 1 ? r7.z : 0;
    r7.x = r7.x * r7.y + r7.z;
    r1.x = min(1, r1.x);
    r1.x = (r1.x < -r1.x) ? -r7.x : r7.x;
    r1.x = r2.w * r1.x + -1;
    r2.yz = r0.xy * r1.xx + r0.zw;
  }
  r2.yz = saturate(r2.yz);
  r0.xy = cb0[26].xx * r2.yz;
  r0.xyzw = t1.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r3.xyzw = r3.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r3.xyzw;
  r7.xyzw = r3.xyzw * cb0[28].zzzz + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = r3.xyzw * cb0[28].zzzz + -cb0[29].xyxy;
  r3.xyzw = cb0[29].zwzw * r3.xyzw;
  r1.x = dot(r3.xy, r3.xy);
  r1.x = sqrt(r1.x);
  if (cb0[28].w > 0) {
    r2.yz = cb0[28].xy * r1.xx;
    sincos(r2.y, r8.x, r9.x);
    r2.y = r8.x / r9.x;
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z + -1;
    r2.yz = r3.xy * r2.yy + r7.xy;
  } else {
    r2.w = 1 / r1.x;
    r2.w = cb0[28].x * r2.w;
    r1.x = cb0[28].y * r1.x;
    r8.x = min(1, abs(r1.x));
    r8.y = max(1, abs(r1.x));
    r8.y = 1 / r8.y;
    r8.x = r8.x * r8.y;
    r8.y = r8.x * r8.x;
    r8.z = r8.y * 0.0208350997 + -0.0851330012;
    r8.z = r8.y * r8.z + 0.180141002;
    r8.z = r8.y * r8.z + -0.330299497;
    r8.y = r8.y * r8.z + 0.999866009;
    r8.z = r8.x * r8.y;
    r8.z = r8.z * -2 + 1.57079637;
    r8.z = abs(r1.x) > 1 ? r8.z : 0;
    r8.x = r8.x * r8.y + r8.z;
    r1.x = min(1, r1.x);
    r1.x = (r1.x < -r1.x) ? -r8.x : r8.x;
    r1.x = r2.w * r1.x + -1;
    r2.yz = r3.xy * r1.xx + r7.xy;
  }
  r2.yz = saturate(r2.yz);
  r2.yz = cb0[26].xx * r2.yz;
  r8.xyzw = t1.SampleLevel(s1_s, r2.yz, 0).xyzw;
  r1.x = dot(r3.zw, r3.zw);
  r1.x = sqrt(r1.x);
  if (cb0[28].w > 0) {
    r2.yz = cb0[28].xy * r1.xx;
    sincos(r2.y, r3.x, r7.x);
    r1.y = r3.x / r7.x;
    r2.y = 1 / r2.z;
    r1.y = r1.y * r2.y + -1;
    r2.yz = r3.zw * r1.yy + r7.zw;
  } else {
    r1.y = 1 / r1.x;
    r1.y = cb0[28].x * r1.y;
    r1.x = cb0[28].y * r1.x;
    r2.w = min(1, abs(r1.x));
    r3.x = max(1, abs(r1.x));
    r3.x = 1 / r3.x;
    r2.w = r3.x * r2.w;
    r3.x = r2.w * r2.w;
    r3.y = r3.x * 0.0208350997 + -0.0851330012;
    r3.y = r3.x * r3.y + 0.180141002;
    r3.y = r3.x * r3.y + -0.330299497;
    r3.x = r3.x * r3.y + 0.999866009;
    r3.y = r3.x * r2.w;
    r3.y = r3.y * -2 + 1.57079637;
    r3.y = abs(r1.x) > 1 ? r3.y : 0;
    r2.w = r2.w * r3.x + r3.y;
    r1.x = min(1, r1.x);
    r1.x = (r1.x < -r1.x) ? -r2.w : r2.w;
    r1.x = r1.y * r1.x + -1;
    r2.yz = r3.zw * r1.xx + r7.zw;
  }
  r2.yz = saturate(r2.yz);
  r1.xy = cb0[26].xx * r2.yz;
  r3.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).xyzw;
  r4.w = 1;
  r5.w = 1;
  r7.xyzw = r8.xyzw * r5.xyzw;
  r0.xyzw = r0.xyzw * r4.xyzw + r7.xyzw;
  r6.w = 1;
  r0.xyzw = r3.xyzw * r6.xyzw + r0.xyzw;
  r2.yzw = r5.xyz + r4.xyz;
  r3.xyz = r2.yzw + r6.xyz;
  r3.w = 3;
  r0.xyzw = r0.xyzw / r3.xyzw;
  r0.xyz = r0.xyz * r2.xxx;
  r2.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r1.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r2.xyzy * r1.xxxx + r1.zwzw);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t3.Sample(s3_s, r3.xy).xyzw;
  r3.xyzw = t3.Sample(s3_s, r3.zw).xyzw;
  r3.xyzw = float4(0.25,0.25,0.25,0.25) * r3.xyzw;
  r3.xyzw = r4.xyzw * float4(0.25,0.25,0.25,0.25) + r3.xyzw;
  r2.xyzw = saturate(r2.xwzw * r1.xxxx + r1.zwzw);
  r2.xyzw = cb0[26].xxxx * r2.xyzw;
  r4.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r3.xyzw = r4.xyzw * float4(0.25,0.25,0.25,0.25) + r3.xyzw;
  r2.xyzw = t3.Sample(s3_s, r2.zw).xyzw;
  r2.xyzw = r2.xyzw * float4(0.25,0.25,0.25,0.25) + r3.xyzw;
  r1.xy = r1.zw * cb0[33].xy + cb0[33].zw;
  r3.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r2.xyzw = cb0[34].yyyy * r2.xyzw * injectedData.fxBloom;
  r3.xyz = cb0[34].zzz * r3.xyz * injectedData.fxLens;
  r3.w = 0;
  r4.xyz = cb0[35].xyz * r2.xyz;
  r4.w = r2.w;
  r0.xyzw = r4.xyzw + r0.xyzw;
  r0.xyzw = r3.xyzw * r2.xyzw + r0.xyzw;
  if (cb0[40].y < 0.5) {
    r1.xy = -cb0[38].xy + r1.zw;
    r2.yz = cb0[39].xx * abs(r1.yx) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[22].x / cb0[22].y;
    r1.x = -1 + r1.x;
    r1.x = cb0[39].w * r1.x + 1;
    r2.x = r2.z * r1.x;
    r2.xy = saturate(r2.xy);
    r1.xy = log2(r2.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[39].y * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r2.xyz = float3(1,1,1) + -cb0[37].xyz;
    r2.xyz = r1.xxx * r2.xyz + cb0[37].xyz;
    r2.xyz = r2.xyz * r0.xyz;
    r1.y = -1 + r0.w;
    r2.w = r1.x * r1.y + 1;
  } else {
    r1.xyzw = t7.Sample(s7_s, r1.zw).xyzw;
    r1.x = renodx::color::srgb::DecodeSafe(r1.w);
    r1.yzw = float3(1,1,1) + -cb0[37].xyz;
    r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
    r1.yzw = r0.xyz * r1.yzw + -r0.xyz;
    r2.xyz = cb0[40].xxx * r1.yzw + r0.xyz;
    r0.x = -1 + r0.w;
    r2.w = r1.x * r0.x + 1;
  }
  r0.xyzw = cb0[36].zzzz * r2.xyzw;
  r0.xyz = lutShaper(r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t6.Sample(s6_s, r0.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t6, r0.xyz, 1 / cb0[36].x);
  }
  r0.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
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