#include "../../tonemap.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[162];
}

// MOUSE: P.I. For Hire

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.zw = r0.xy * cb0[151].zz + float2(0.5,0.5);
  r0.xy = r0.xy * cb0[151].zz + -cb0[150].xy;
  r0.xy = cb0[150].zw * r0.xy;
  r1.x = dot(r0.xy, r0.xy);
  r1.x = sqrt(r1.x);
  if (cb0[151].w > 0) {
    r1.z = cb0[151].x * r1.x;
    sincos(r1.z, r2.x, r3.x);
    r1.z = r2.x / r3.x;
    r1.w = r1.x * cb0[151].y + 6.10351563e-005;
    r1.w = 1 / r1.w;
    r1.z = r1.z * r1.w + -1;
    r1.zw = r0.xy * r1.zz + r0.zw;
  } else {
    r2.x = 1 / r1.x;
    r2.x = cb0[151].x * r2.x;
    r1.x = cb0[151].y * r1.x;
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
  r0.xy = -cb0[138].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.zw = min(r1.zw, r0.xy);
  r2.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[4].x).xyzw;
  r3.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r0.z = dot(r3.zw, r3.zw);
  r3.xyzw = r3.xyzw * r0.zzzz;
  r3.xyzw = cb0[152].xxxx * r3.xyzw * injectedData.fxCA;
  r3.xyzw = r3.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r3.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r3.xyzw;
  r4.xyzw = r3.xyzw * cb0[151].zzzz + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = r3.xyzw * cb0[151].zzzz + -cb0[150].xyxy;
  r3.xyzw = cb0[150].zwzw * r3.xyzw;
  r0.z = dot(r3.xy, r3.xy);
  r0.z = sqrt(r0.z);
  if (cb0[151].w > 0) {
    r0.w = cb0[151].x * r0.z;
    sincos(r0.w, r1.x, r5.x);
    r0.w = r1.x / r5.x;
    r1.x = r0.z * cb0[151].y + 6.10351563e-005;
    r1.x = 1 / r1.x;
    r0.w = r0.w * r1.x + -1;
    r2.yz = r3.xy * r0.ww + r4.xy;
  } else {
    r0.w = 1 / r0.z;
    r0.w = cb0[151].x * r0.w;
    r0.z = cb0[151].y * r0.z;
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
    r0.z = r0.z < -r0.z ? -r1.x : r1.x;
    r0.z = r0.w * r0.z + -1;
    r2.yz = r3.xy * r0.zz + r4.xy;
  }
  r0.zw = min(r2.yz, r0.xy);
  r5.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[4].x).xyzw;
  r0.z = dot(r3.zw, r3.zw);
  r0.z = sqrt(r0.z);
  if (cb0[151].w > 0) {
    r0.w = cb0[151].x * r0.z;
    sincos(r0.w, r1.x, r3.x);
    r0.w = r1.x / r3.x;
    r1.x = r0.z * cb0[151].y + 6.10351563e-005;
    r1.x = 1 / r1.x;
    r0.w = r0.w * r1.x + -1;
    r1.xy = r3.zw * r0.ww + r4.zw;
  } else {
    r0.w = 1 / r0.z;
    r0.w = cb0[151].x * r0.w;
    r0.z = cb0[151].y * r0.z;
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
    r2.w = abs(r0.z) > 1 ? r2.w : 0;
    r2.y = r2.y * r2.z + r2.w;
    r0.z = min(1, r0.z);
    r0.z = r0.z < -r0.z ? -r2.y : r2.y;
    r0.z = r0.w * r0.z + -1;
    r1.xy = r3.zw * r0.zz + r4.zw;
  }
  r0.xy = min(r1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  if (cb0[154].z > 0) {
    r1.xy = -cb0[154].xy + r1.zw;
    r3.yz = cb0[154].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r3.x = cb0[153].w * r3.y;
    r0.w = dot(r3.xz, r3.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[154].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r2.yzw = float3(1,1,1) + -cb0[153].xyz;
    r2.yzw = r0.www * r2.yzw + cb0[153].xyz;
    r0.x = r2.x;
    r0.y = r5.y;
    r0.xyz = r0.xyz * r2.yzw;
  } else {
    r0.x = r2.x;
    r0.y = r5.y;
  }
  r0.xyz = cb0[145].www * r0.xyz;
  r0.xyz = applyUserTonemapNeutral(r0.xyz);
  if (cb0[146].w > 0) {
    r2.xyz = fastSrgbEncodeSafe(r0.xyz);
    r3.xyz = handleUserLUT(r0.xyz, t2, s0_s, cb0[146].xyz, 1);
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = cb0[146].www * r3.xyz + r2.xyz;
    r0.xyz = fastSrgbDecodeSafe(r2.xyz);
  }
  r0.xyz = lutShaper(r0.xyz, false, 1);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyw = cb0[145].zzz * r0.xyz;
  r0.w = floor(r0.w);
  r1.xy = float2(0.5,0.5) * cb0[145].xy;
  r2.yz = r0.xy * cb0[145].xy + r1.xy;
  r2.x = r0.w * cb0[145].y + r2.y;
  r3.xyzw = t1.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r0.x = cb0[145].y;
  r0.y = 0;
  r0.xy = r2.xz + r0.xy;
  r2.xyzw = t1.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.x = r0.z * cb0[145].z + -r0.w;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t1, r0.xyz, cb0[145].z + 1u);
  }
  r1.xyzw = t4.SampleBias(s0_s, r1.zw, cb0[4].x).xyzw;
  r0.w = renodx::color::y::from::BT709(r0.xyz);
  r1.yzw = renodx::color::arri::logc::c1000::Encode(r0.xyz, false);
  r1.yzw = r1.yzw + float3(-0.4135884, -0.4135884, -0.4135884);
  r1.yzw = r1.yzw * cb0[160].zzz + float3(0.4135884, 0.4135884, 0.4135884);
  r1.yzw = renodx::color::arri::logc::c1000::Decode(r1.yzw, false);
  r1.yzw = r1.yzw - r0.www;
  r1.yzw = cb0[160].yyy * r1.yzw + r0.www;
  r2.x = 1 + -cb0[160].x;
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = r2.xxx * r0.xyz + r0.www;
  r0.xyz = r0.xyz + -r1.yzw;
  r0.xyz = r1.xxx * r0.xyz + r1.yzw;
  r0.w = cb0[161].x * cb0[161].y;
  r1.xyz = r1.xxx + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  float3 newPeak = renodx::lut::Sample(t1, s0_s, lutShaper((injectedData.toneMapPeakNits / injectedData.toneMapGameNits), false, 1), cb0[145].z + 1u) * injectedData.toneMapGameNits;
  float3 encodedNewPeak = renodx::color::arri::logc::c1000::Encode(newPeak, false);
  encodedNewPeak = encodedNewPeak + float3(-0.4135884,-0.4135884,-0.4135884);
  encodedNewPeak = encodedNewPeak * cb0[160].zzz + float3(0.4135884, 0.4135884, 0.4135884);
  newPeak = renodx::color::arri::logc::c1000::Decode(encodedNewPeak, false);
  float newPeakY = renodx::color::y::from::BT709(newPeak);
  float ratio = renodx::math::DivideSafe(injectedData.toneMapPeakNits / newPeakY, 1.f);
  if(ratio < 0.985f){
    r0.xyz = rolloff(r0.xyz, ratio);
  }
  r1.xy = v1.xy * cb0[158].xy + cb0[158].zw;
  r1.xyzw = t3.SampleBias(s1_s, r1.xy, cb0[4].x).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = r0.w >= 0 ? 1 : -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * 1.0 / 255.0);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}