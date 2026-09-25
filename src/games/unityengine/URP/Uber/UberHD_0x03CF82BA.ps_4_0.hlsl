#include "../../common.hlsli"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1411];
}

// Plushie from the Sky

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, v1.xy).xyzw;
  if (cb0[1399].x > 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8,8,8) * r2.xyz;
  }
  r1.xyz = cb0[1398].xxx * r1.xyz * CUSTOM_BLOOM;
  r0.xyz = r1.xyz * cb0[1398].yzw + r0.xyz;
  if (cb0[1406].z > 0) {
    r1.xy = -cb0[1406].xy + v1.xy;
    r1.yz = cb0[1406].zz * abs(r1.xy) * min(1.f, CUSTOM_VIGNETTE);
    r1.x = cb0[1405].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[1406].w * r0.w * max(1.f, CUSTOM_VIGNETTE);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[1405].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[1405].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[1396].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if (CUSTOM_LUT_SAMPLE == 0.f) {
  r0.yzw = cb0[1396].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[1396].xy;
  r1.yz = r0.zw * cb0[1396].xy + r1.xy;
  r1.x = r0.y * cb0[1396].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[1396].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[1396].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.yzx, cb0[1396].z + 1u);
  }
  if (cb0[1397].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[1397].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[1397].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  r1.xy = v1.xy * cb0[1410].xy + cb0[1410].zw;
  r1.xyzw = t4.Sample(s1_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = r0.w >= 0 ? 1 : -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}