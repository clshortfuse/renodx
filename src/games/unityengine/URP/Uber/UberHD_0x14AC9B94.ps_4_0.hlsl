#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[146];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[131].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.xy = min(v1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  if (cb0[145].z > 0) {
    r1.xy = -cb0[145].xy + v1.xy;
    r1.yz = cb0[145].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[144].w * r1.y;
    r1.x = dot(r1.xz, r1.xz);
    r1.x = 1 + -r1.x;
    r1.x = max(0, r1.x);
    r1.x = log2(r1.x);
    r1.x = cb0[145].w * r1.x * max(1.f, injectedData.fxVignette);
    r1.x = exp2(r1.x);
    r1.yzw = float3(1,1,1) + -cb0[144].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb0[144].xyz;
    r1.xyz = r1.xyz * r0.xyz;
  } else {
    r1.xyz = r0.xyz;
  }
  r1.xyz = cb0[136].www * r1.zxy;
  r1.yzx = lutShaper(r1.yzx);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r1.yzw = cb0[136].zzz * r1.xyz;
  r1.y = floor(r1.y);
  r2.xy = float2(0.5,0.5) * cb0[136].xy;
  r2.yz = r1.zw * cb0[136].xy + r2.xy;
  r2.x = r1.y * cb0[136].y + r2.y;
  r3.xyzw = t1.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r4.x = cb0[136].y;
  r4.y = 0;
  r1.zw = r4.xy + r2.xz;
  r2.xyzw = t1.SampleLevel(s0_s, r1.zw, 0).xyzw;
  r1.x = r1.x * cb0[136].z + -r1.y;
  r1.yzw = r2.xyz + -r3.xyz;
  r1.xyz = r1.xxx * r1.yzw + r3.xyz;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t1, r1.yzx, cb0[136].z + 1u);
  }
  if (cb0[137].w > 0) {
    r2.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r3.xyz = handleUserLUT(r1.xyz, t2, s0_s, cb0[137].xyz);
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = cb0[137].www * r3.xyz + r2.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  }
  r1.w = saturate(r0.w);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  return;
}