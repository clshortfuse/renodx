#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[147];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[132].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.xy = min(v1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r1.xy = -cb0[136].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.xy = min(v1.xy, r1.xy);
  r1.xyzw = t1.SampleBias(s0_s, r1.xy, cb0[4].x).xyzw;
  r1.xyz = cb0[139].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[139].yzw + r0.xyz;
  if (cb0[146].z > 0) {
    r1.xy = -cb0[146].xy + v1.xy;
    r1.yz = cb0[146].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[145].w * r1.y;
    r1.x = dot(r1.xz, r1.xz);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[146].w * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[145].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb0[145].xyz;
    r1.xyz = r1.xyz * r0.xyz;
  } else {
    r1.xyz = r0.xyz;
  }
  r1.xyz = cb0[137].www * r1.xyz;
  r2.xyz = applyUserTonemapACES(r1.xyz, 2);
  if (cb0[138].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
    r3.xyz = handleUserLUT(r2.xyz, t3, s0_s, cb0[138].xyz);
    r3.xyz = r3.xyz + -r1.xyz;
    r1.xyz = cb0[138].www * r3.xyz + r1.xyz;
    r2.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  r1.xyz = lutShaper(r2.xyz, false, 1);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r1.xyz = cb0[137].zzz * r2.zxy;
  r1.x = floor(r1.x);
  r2.xy = float2(0.5,0.5) * cb0[137].xy;
  r3.yz = r1.yz * cb0[137].xy + r2.xy;
  r3.x = r1.x * cb0[137].y + r3.y;
  r4.xyzw = t2.SampleLevel(s0_s, r3.xz, 0).xyzw;
  r2.x = cb0[137].y;
  r2.y = 0;
  r1.yz = r3.xz + r2.xy;
  r3.xyzw = t2.SampleLevel(s0_s, r1.yz, 0).xyzw;
  r1.x = r2.z * cb0[137].z + -r1.x;
  r1.yzw = r3.xyz + -r4.xyz;
  r1.xyz = r1.xxx * r1.yzw + r4.xyz;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t2, r1.xyz, cb0[137].z + 1u);
  }
  float3 newPeak = renodx::lut::Sample(t2, s0_s, lutShaper((injectedData.toneMapPeakNits / injectedData.toneMapGameNits), false, 1), cb0[137].z + 1u) * injectedData.toneMapGameNits;
  float newPeakY = renodx::color::y::from::BT709(newPeak);
  float ratio = renodx::math::DivideSafe(injectedData.toneMapPeakNits / newPeakY, 1.f);
  if(ratio < 0.985f){
    r1.xyz = rolloff(r1.xyz, ratio);
  }
  r0.w = saturate(r0.w);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}