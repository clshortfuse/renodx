#include "../../tonemap.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[147];
}

// Super Yooka-Laylee Kart

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
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
  r2.xy = v1.xy * cb0[140].xy + cb0[140].zw;
  r2.xyzw = t2.SampleBias(s0_s, r2.xy, cb0[4].x).xyzw;
  r2.xyz = cb0[141].xxx * r2.xyz * injectedData.fxLens;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  if (cb0[146].z > 0) {
    r1.xy = -cb0[146].xy + v1.xy;
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
  r0.xyz = cb0[137].www * r0.xyz;
  r1.xyz = applyUserTonemapACES(r0.xyz, 2);
  if (cb0[138].w > 0) {
    r0.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r2.xyz = handleUserLUT(r1.xyz, t4, s0_s, cb0[138].xyz);
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[138].www * r2.xyz + r0.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  r1.xyz = lutShaper(r1.xyz, false, 1);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.xyz = cb0[137].zzz * r1.zxy;
  r0.x = floor(r0.x);
  r1.xy = float2(0.5,0.5) * cb0[137].xy;
  r2.yz = r0.yz * cb0[137].xy + r1.xy;
  r2.x = r0.x * cb0[137].y + r2.y;
  r3.xyzw = t3.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[137].y;
  r1.y = 0;
  r0.yz = r2.xz + r1.xy;
  r2.xyzw = t3.SampleLevel(s0_s, r0.yz, 0).xyzw;
  r0.x = r1.z * cb0[137].z + -r0.x;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t3, r1.xyz, cb0[137].z + 1u);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}