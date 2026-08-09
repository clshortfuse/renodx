#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[139];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[136].xxxx * r0.xyzw * injectedData.fxCA;
  r1.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r2.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[19].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[19].x).xyzw;
  r3.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  if (cb0[131].x > 0) {
    r1.yzw = r3.xyz * r3.www;
    r3.xyz = float3(8,8,8) * r1.yzw;
  }
  r1.yzw = cb0[130].xxx * r3.xyz * injectedData.fxBloom;
  r0.x = r1.x;
  r0.y = r2.y;
  r0.xyz = r1.yzw * cb0[130].yzw + r0.xyz;
  if (cb0[138].z > 0) {
    r1.xy = -cb0[138].xy + v1.xy;
    r1.yz = cb0[138].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[137].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[138].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[137].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[137].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[128].www * r0.xyz;
  r1.xyz = applyUserTonemapACES(r0.xyz, 1);
  if (cb0[129].w > 0) {
    r0.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r2.xyz = handleUserLUT(r1.xyz, t3, s0_s, cb0[129].xyz);
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[129].www * r2.xyz + r0.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  r1.xyz = lutShaper(r1.xyz, false, 1);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[128].zzz * r1.zxy;
  r0.x = floor(r0.x);
  r1.xy = float2(0.5,0.5) * cb0[128].xy;
  r2.yz = r0.yz * cb0[128].xy + r1.xy;
  r2.x = r0.x * cb0[128].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[128].y;
  r1.y = 0;
  r0.yz = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r0.yz, 0).xyzw;
  r0.x = r1.z * cb0[128].z + -r0.x;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r1.xyz, cb0[128].z + 1u);
  }
  float3 newPeak = renodx::lut::Sample(t2, s0_s, lutShaper((injectedData.toneMapPeakNits / injectedData.toneMapGameNits), false, 1), cb0[128].z + 1u) * injectedData.toneMapGameNits;
  float newPeakY = renodx::color::y::from::BT709(newPeak);
  float ratio = renodx::math::DivideSafe(injectedData.toneMapPeakNits / newPeakY, 1.f);
  if(ratio < 0.985f){
    r0.xyz = rolloff(r0.xyz, ratio);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}