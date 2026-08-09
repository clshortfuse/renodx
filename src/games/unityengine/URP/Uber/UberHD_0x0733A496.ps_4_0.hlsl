#include "../../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[144];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  if (cb0[136].x > 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8,8,8) * r2.xyz;
  }
  r1.xyz = cb0[135].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[135].yzw + r0.xyz;
  if (cb0[143].z > 0) {
    r1.xy = -cb0[143].xy + v1.xy;
    r1.yz = cb0[143].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[142].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[143].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[142].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[142].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  if (cb0[134].y > 0) {
    r1.xyzw = t4.SampleBias(s1_s, v1.xy, cb0[5].x).xyzw;
    r0.w = cb0[23].z * r1.x + cb0[23].w;
    r0.w = 1 / r0.w;
    r1.x = cb0[134].y + -cb0[134].x;
    r0.w = -cb0[134].x + r0.w;
    r1.x = 1 / r1.x;
    r0.w = saturate(r1.x * r0.w);
    r1.x = r0.w * -2 + 3;
    r0.w = r0.w * r0.w;
    r0.w = r1.x * r0.w;
    r0.w = cb0[133].w * r0.w;
  } else {
    r0.w = cb0[133].w;
  }
  r0.xyz = cb0[132].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r1.xyz = cb0[132].zzz * r0.xyz;
  r0.y = floor(r1.x);
  r1.xw = float2(0.5,0.5) * cb0[132].xy;
  r1.yz = r1.yz * cb0[132].xy + r1.xw;
  r1.x = r0.y * cb0[132].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[132].y;
  r3.y = 0;
  r1.xy = r3.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r0.x = r0.x * cb0[132].z + -r0.y;
  r1.xyz = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r1.xyz + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.yzx, cb0[132].z + 1u);
  }
  if (r0.w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[133].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = r0.www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}