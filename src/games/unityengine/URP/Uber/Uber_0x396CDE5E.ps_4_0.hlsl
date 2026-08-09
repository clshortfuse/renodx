#include "../../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[148];
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[131].xy * float2(0.5, 0.5) + cb0[28].xy;
  r0.xy = min(v1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r2.xy = -cb0[135].xy * float2(0.5, 0.5) + cb0[28].xy;
  r2.xy = min(v1.xy, r2.xy);
  r2.xyzw = t1.SampleBias(s0_s, r2.xy, cb0[4].x).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = cb0[138].xxx * r2.xyz * injectedData.fxBloom;
  r2.xyz = cb0[138].yzw * r2.xyz;
  r0.xyz = r0.xyz * r1.xyz + r2.xyz;
  if (cb0[145].z > 0) {
    r1.xy = -cb0[145].xy + v1.xy;
    r1.yz = cb0[145].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[144].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[145].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[144].xyz;
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
    r1.xy = float2(0.5, 0.5) * cb0[136].xy;
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
  if (injectedData.fxFilmGrainType == 0.f) {
    r1.xy = v1.xy * cb0[147].xy + cb0[147].zw;
    r1.xyzw = t2.SampleBias(s1_s, r1.xy, cb0[4].x).xyzw;
    r0.w = -0.5 + r1.w;
    r0.w = r0.w + r0.w;
    r1.x = renodx::color::y::from::BT709(saturate(r0.xyz));
    r1.x = sqrt(r1.x);
    r1.x = cb0[146].y * -r1.x + 1;
    r1.yzw = r0.xyz * r0.www;
    r1.yzw = cb0[146].xxx * r1.yzw * injectedData.fxFilmGrain;
    r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
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
