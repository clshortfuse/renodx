#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -cb0[138].xyxy * float4(0.5,0.5,0.5,0.5) + cb0[28].xyxy;
  r1.xy = min(v1.xy, r0.zw);
  r1.xyzw = t0.SampleBias(s0_s, r1.xy, cb0[4].x).xyzw;
  r2.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.y = dot(r2.zw, r2.zw);
  r2.xyzw = r2.xyzw * r1.yyyy;
  r2.xyzw = cb0[152].xxxx * r2.xyzw * injectedData.fxCA;
  r2.xyzw = r2.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r0.xyzw = min(r2.xyzw, r0.xyzw);
  r2.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[4].x).xyzw;
  if (cb0[154].z > 0) {
    r1.yz = -cb0[154].xy + v1.xy;
    r3.yz = cb0[154].zz * abs(r1.yz) * min(1.f, injectedData.fxVignette);
    r3.x = cb0[153].w * r3.y;
    r0.w = dot(r3.xz, r3.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[154].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.yzw = float3(1,1,1) + -cb0[153].xyz;
    r1.yzw = r0.www * r1.yzw + cb0[153].xyz;
    r0.x = r1.x;
    r0.y = r2.y;
    r0.xyz = r0.xyz * r1.yzw;
  } else {
    r0.x = r1.x;
    r0.y = r2.y;
  }
  r0.xyz = cb0[145].www * r0.xyz;
  r0.xyz = applyUserTonemapNeutral(r0.xyz);
  if (cb0[146].w > 0) {
    r1.xyz = fastSrgbEncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t2, s0_s, cb0[146].xyz, 1);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[146].www * r2.xyz + r1.xyz;
    r0.xyz = fastSrgbDecodeSafe(r1.xyz);
  }
  r0.xyz = lutShaper(r0.xyz, false, 1);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyw = cb0[145].zzz * r0.xyz;
  r0.w = floor(r0.w);
  r1.xy = float2(0.5,0.5) * cb0[145].xy;
  r1.yz = r0.xy * cb0[145].xy + r1.xy;
  r1.x = r0.w * cb0[145].y + r1.y;
  r2.xyzw = t1.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r0.x = cb0[145].y;
  r0.y = 0;
  r0.xy = r1.xz + r0.xy;
  r1.xyzw = t1.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.x = r0.z * cb0[145].z + -r0.w;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t1, r0.xyz, cb0[145].z + 1u);
  }
  r1.xyzw = t3.SampleBias(s0_s, v1.xy, cb0[4].x).xyzw;
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
  encodedNewPeak = encodedNewPeak + float3(-0.4135884, -0.4135884, -0.4135884);
  encodedNewPeak = encodedNewPeak * cb0[160].zzz + float3(0.4135884, 0.4135884, 0.4135884);
  newPeak = renodx::color::arri::logc::c1000::Decode(encodedNewPeak, false);
  float newPeakY = renodx::color::y::from::BT709(newPeak);
  float ratio = renodx::math::DivideSafe(injectedData.toneMapPeakNits / newPeakY, 1.f);
  if (ratio < 0.985f) {
    r0.xyz = rolloff(r0.xyz, ratio);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}