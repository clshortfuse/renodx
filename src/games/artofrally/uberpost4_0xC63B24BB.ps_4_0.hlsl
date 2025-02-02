#include "./common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture3D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[43];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.xyz = r1.xyz * r0.xxx;
  r0.w = cmp(cb0[40].y < 0.5);
  if (r0.w != 0) {
    r1.xy = -cb0[38].xy + v1.xy;
    r1.yz = cb0[39].xx * abs(r1.yx) * min(1, injectedData.fxVignette);
    r0.w = cb0[22].x / cb0[22].y;
    r0.w = -1 + r0.w;
    r0.w = cb0[39].w * r0.w + 1;
    r1.x = r1.z * r0.w;
    r1.xy = saturate(r1.xy);
    r1.xy = log2(r1.xy);
    r1.xy = cb0[39].zz * r1.xy;
    r1.xy = exp2(r1.xy);
    r0.w = dot(r1.xy, r1.xy);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[39].y * r0.w * max(1, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[37].xyz;
    r1.xyz = r1.xyz * r0.xyz;
    r2.x = -1 + r1.w;
    r2.w = r0.w * r2.x + 1;
  } else {
    r3.xyzw = t3.Sample(s3_s, v1.xy).xyzw;
    r0.w = 0.0773993805 * r3.w;
    r3.x = 0.0549999997 + r3.w;
    r3.x = 0.947867334 * r3.x;
    r3.x = max(1.1920929e-07, abs(r3.x));
    r3.x = log2(r3.x);
    r3.x = 2.4000001 * r3.x;
    r3.x = exp2(r3.x);
    r3.y = cmp(0.0404499993 >= r3.w);
    r0.w = r3.y ? r0.w : r3.x;
    r3.xyz = float3(1, 1, 1) + -cb0[37].xyz;
    r3.xyz = r0.www * r3.xyz + cb0[37].xyz;
    r3.xyz = r0.xyz * r3.xyz + -r0.xyz;
    r1.xyz = cb0[40].xxx * r3.xyz + r0.xyz;
    r0.x = -1 + r1.w;
    r2.w = r0.w * r0.x + 1;
  }
  if (injectedData.fxFilmGrainType == 0.f) {
    r0.xy = w1.xy * cb0[41].xy + cb0[41].zw;
    r0.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
    r0.a = renodx::color::y::from::BT709(r1.rgb);
    r0.a = renodx::math::SignSqrt(r0.a);
    r0.w = cb0[40].z * -r0.w + 1;
    r0.xyz = r1.xyz * r0.xyz;
    r0.xyz = cb0[40].www * r0.xyz * injectedData.fxFilmGrain;
    r2.xyz = r0.xyz * r0.www + r1.xyz;
  } else {
    r2.rgb = applyFilmGrain(r1.rgb, w1);
  }
  r0.xyzw = cb0[36].zzzz * r2.xyzw;
  r0.rgb = lutShaper(r0.rgb);
  r0.xyz = cb0[36].yyy * r0.xyz;
  r1.x = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r1.xxx;
  r1.xyzw = t2.Sample(s2_s, r0.xyz).wxyz;
  r0.x = cmp(0.5 < cb0[42].x);
  if (r0.x != 0) {
    r1.x = renodx::color::y::from::BT709(r1.gba);
  } else {
    r1.x = r0.w;
  }
  o0.xyzw = r1.yzwx;
  return;
}
