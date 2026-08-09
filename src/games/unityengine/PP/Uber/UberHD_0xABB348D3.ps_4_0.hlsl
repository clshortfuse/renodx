#include "../../common.hlsl"

Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[48];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = cb0[47].zzzz * r0.xyzw;
  r1.xyz = lutShaper(r0.xyz);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r1.xyz = cb0[47].yyy * r1.xyz;
  r1.w = 0.5 * cb0[47].x;
  r1.xyz = r1.xyz * cb0[47].xxx + r1.www;
  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t1, r1.xyz, 1 / cb0[47].x);
  }
  r0.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  r1.xyzw = float4(0.0973,0.103,0.1099,0.1031) * v0.xyyx;
  r1.xyzw = frac(r1.xyzw);
  r2.xyzw = float4(19.19,19.19,19.19,19.19) + r1.zxwy;
  r2.x = dot(r1.wyxz, r2.xyzw);
  r1.xyzw = r2.xxxx + r1.xyzw;
  r2.xyzw = r1.wwyx + r1.yxxz;
  r1.xyzw = r2.xyzw * r1.xyzw;
  r1.xyzw = frac(r1.xyzw);
  r0.xyzw = r1.xyzw * (1.0 / 255.0) * injectedData.fxNoise + r0.xyzw;
  r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = asint(cb0[41].w) == 1 ? PostToneMapScale(r1.xyz) : PostToneMapScale(r1.xyz, true);
  } else {
    r0.xyz = asint(cb0[41].w) == 1 ? r1.xyz : r0.xyz;
  }
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  return;
}