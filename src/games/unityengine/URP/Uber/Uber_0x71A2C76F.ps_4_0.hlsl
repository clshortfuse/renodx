#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
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
  r1.xy = -cb0[135].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.xy = min(v1.xy, r1.xy);
  r1.xyzw = t1.SampleBias(s0_s, r1.xy, cb0[4].x).xyzw;
  r1.xyz = cb0[138].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[138].yzw + r0.xyz;
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
  r1.xyz = cb0[136].www * r1.xyz;
  if (cb0[137].w > 0) {
    r2.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r3.xyz = cb0[137].zzz * r2.zxy;
    r1.w = floor(r3.x);
    r3.xw = float2(0.5,0.5) * cb0[137].xy;
    r3.yz = r3.yz * cb0[137].xy + r3.xw;
    r3.x = r1.w * cb0[137].y + r3.y;
    r4.xyzw = t3.SampleLevel(s0_s, r3.xz, 0).xyzw;
    r5.x = cb0[137].y;
    r5.y = 0;
    r3.xy = r5.xy + r3.xz;
    r3.xyzw = t3.SampleLevel(s0_s, r3.xy, 0).xyzw;
    r1.w = r2.z * cb0[137].z + -r1.w;
    r3.xyz = r3.xyz + -r4.xyz;
    r3.xyz = r1.www * r3.xyz + r4.xyz;
    r3.xyz = handleUserLUT(r1.xyz, t3, s0_s, cb0[137].xyz);
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = cb0[137].www * r3.xyz + r2.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r2.xyz);
  }
  r1.xyz = lutShaper(r1.xyz, false, 1);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.xyw = cb0[136].zzz * r1.xyz;
  r1.w = floor(r1.w);
  r2.xy = float2(0.5,0.5) * cb0[136].xy;
  r2.yz = r1.xy * cb0[136].xy + r2.xy;
  r2.x = r1.w * cb0[136].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[136].y;
  r1.y = 0;
  r1.xy = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r1.x = r1.z * cb0[136].z + -r1.w;
  r1.yzw = r2.xyz + -r3.xyz;
  r1.xyz = r1.xxx * r1.yzw + r3.xyz;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t2, r1.xyz, cb0[136].z + 1u);
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