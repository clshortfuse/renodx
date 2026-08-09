#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[143];
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
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (cb0[142].z > 0) {
    r1.xy = -cb0[142].xy + v1.xy;
    r1.yz = cb0[142].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[141].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[142].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[141].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[141].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[132].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[132].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[132].xy;
  r1.yz = r0.zw * cb0[132].xy + r1.xy;
  r1.x = r0.y * cb0[132].y + r1.y;
  r2.xyzw = t1.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[132].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t1.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[132].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t1, r0.yzx, cb0[132].z + 1u);
  }
  if (cb0[133].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t2, s0_s, cb0[133].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[133].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
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