#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[141];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[21].x).xyzw;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[21].x).xyzw;
  if (cb0[133].x > 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8,8,8) * r2.xyz;
  }
  r1.xyz = cb0[132].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[132].yzw + r0.xyz;
  if (cb0[140].z > 0) {
    r1.xy = -cb0[140].xy + v1.xy;
    r1.yz = cb0[140].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[139].w * r1.y;
    r1.x = dot(r1.xz, r1.xz);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[140].w * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[139].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb0[139].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[130].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.xyz = cb0[130].zzz * r0.xyz;
  r0.y = floor(r1.x);
  r1.xw = float2(0.5,0.5) * cb0[130].xy;
  r1.yz = r1.yz * cb0[130].xy + r1.xw;
  r1.x = r0.y * cb0[130].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[130].y;
  r3.y = 0;
  r1.xy = r3.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r0.x = r0.x * cb0[130].z + -r0.y;
  r1.xyz = r1.xyz + -r2.xyz;
  r1.xyz = r0.xxx * r1.xyz + r2.xyz;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t2, r0.yzx, cb0[130].z + 1u);
  }
  if (cb0[131].w > 0) {
    r0.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r2.xyz = handleUserLUT(r1.xyz, t3, s0_s, cb0[131].xyz);
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[131].www * r2.xyz + r0.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  r0.x = r1.x + r1.y;
  r0.x = r0.x + r1.z;
  r0.x = 0.333333343 * r0.x;
  r1.w = max(r0.w, r0.x);
  if (injectedData.countOld == injectedData.countNew) {
    r1.xyz = PostToneMapScale(r1.xyz);
  }
  o0.xyzw = r1.xyzw;
  return;
}