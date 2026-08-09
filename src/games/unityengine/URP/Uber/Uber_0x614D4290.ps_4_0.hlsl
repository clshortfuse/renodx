#include "../../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[146];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[142].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[142].zz + -cb0[141].xy;
  r0.xy = cb0[141].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[142].w > 0) {
    r1.zw = cb0[142].xy * r1.xx;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[142].x * r2.x;
    r1.x = cb0[142].y * r1.x;
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
    r2.w = (abs(r1.x) > 1) ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r1.x = min(1, r1.x);
    r1.x = (r1.x < -r1.x) ? -r2.y : r2.y;
    r1.x = r2.x * r1.x + -1;
    r1.zw = r0.xy * r1.xx + r0.zw;
  }
  r0.xy = -cb0[131].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.zw = min(r1.zw, r0.xy);
  r2.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[4].x).xyzw;
  r3.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.z = dot(r3.zw, r3.zw);
  r3.xyzw = r3.xyzw * r0.zzzz;
  r3.xyzw = cb0[143].xxxx * r3.xyzw * injectedData.fxCA;
  r3.xyzw = r3.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r3.xyzw;
  r4.xyzw = r3.xyzw * cb0[142].zzzz + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = r3.xyzw * cb0[142].zzzz + -cb0[141].xyxy;
  r3.xyzw = cb0[141].zwzw * r3.xyzw;
  r0.z = dot(r3.xy, r3.xy);
  r0.z = sqrt(r0.z);
  if (cb0[142].w > 0) {
    r2.yz = cb0[142].xy * r0.zz;
    sincos(r2.y, r1.x, r5.x);
    r0.w = r1.x / r5.x;
    r1.x = 1 / r2.z;
    r0.w = r0.w * r1.x + -1;
    r2.yz = r3.xy * r0.ww + r4.xy;
  } else {
    r0.w = 1 / r0.z;
    r0.w = cb0[142].x * r0.w;
    r0.z = cb0[142].y * r0.z;
    r1.x = min(1, abs(r0.z));
    r2.w = max(1, abs(r0.z));
    r2.w = 1 / r2.w;
    r1.x = r2.w * r1.x;
    r2.w = r1.x * r1.x;
    r5.x = r2.w * 0.0208350997 + -0.0851330012;
    r5.x = r2.w * r5.x + 0.180141002;
    r5.x = r2.w * r5.x + -0.330299497;
    r2.w = r2.w * r5.x + 0.999866009;
    r5.x = r2.w * r1.x;
    r5.x = r5.x * -2 + 1.57079637;
    r5.x = abs(r0.z) > 1 ? r5.x : 0;
    r1.x = r1.x * r2.w + r5.x;
    r0.z = min(1, r0.z);
    r0.z = (r0.z < -r0.z) ? -r1.x : r1.x;
    r0.z = r0.w * r0.z + -1;
    r2.yz = r3.xy * r0.zz + r4.xy;
  }
  r0.zw = min(r2.yz, r0.xy);
  r5.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[4].x).xyzw;
  r0.z = dot(r3.zw, r3.zw);
  r0.z = sqrt(r0.z);
  if (cb0[142].w > 0) {
    r1.xy = cb0[142].xy * r0.zz;
    sincos(r1.x, r1.x, r3.x);
    r0.w = r1.x / r3.x;
    r1.x = 1 / r1.y;
    r0.w = r0.w * r1.x + -1;
    r1.xy = r3.zw * r0.ww + r4.zw;
  } else {
    r0.w = 1 / r0.z;
    r0.w = cb0[142].x * r0.w;
    r0.z = cb0[142].y * r0.z;
    r2.y = min(1, abs(r0.z));
    r2.z = max(1, abs(r0.z));
    r2.z = 1 / r2.z;
    r2.y = r2.y * r2.z;
    r2.z = r2.y * r2.y;
    r2.w = r2.z * 0.0208350997 + -0.0851330012;
    r2.w = r2.z * r2.w + 0.180141002;
    r2.w = r2.z * r2.w + -0.330299497;
    r2.z = r2.z * r2.w + 0.999866009;
    r2.w = r2.y * r2.z;
    r2.w = r2.w * -2 + 1.57079637;
    r2.w = (abs(r0.z) > 1) ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r0.z = min(1, r0.z);
    r0.z = (r0.z < -r0.z) ? -r2.y : r2.y;
    r0.z = r0.w * r0.z + -1;
    r1.xy = r3.zw * r0.zz + r4.zw;
  }
  r0.xy = min(r1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r1.xy = -cb0[135].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.xy = min(r1.zw, r1.xy);
  r3.xyzw = t1.SampleBias(s0_s, r1.xy, cb0[4].x).xyzw;
  r2.yzw = cb0[138].xxx * r3.xyz * injectedData.fxBloom;
  r0.x = r2.x;
  r0.y = r5.y;
  r0.xyz = r2.yzw * cb0[138].yzw + r0.xyz;
  r1.xy = r1.zw * cb0[139].xy + cb0[139].zw;
  r3.xyzw = t2.SampleBias(s0_s, r1.xy, cb0[4].x).xyzw;
  r3.xyz = cb0[140].xxx * r3.xyz * injectedData.fxLens;
  r0.xyz = r3.xyz * r2.yzw + r0.xyz;
  if (cb0[145].z > 0) {
    r1.xy = -cb0[145].xy + r1.zw;
    r1.yz = cb0[145].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[144].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[145].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[144].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[144].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[136].www * r0.xyz;
  if (cb0[137].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t4, s0_s, cb0[137].xyz);
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
  r2.xyzw = t3.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r0.x = cb0[136].y;
  r0.y = 0;
  r0.xy = r1.xz + r0.xy;
  r1.xyzw = t3.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.x = r0.z * cb0[136].z + -r0.w;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t3, r0.xyz, cb0[136].z + 1u);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}