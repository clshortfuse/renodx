#include "./common.hlsl"

Texture3D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[37];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r1.xyz = r1.xyz * r0.xxx;
  r0.xyzw = cb0[36].zzzz * r1.xyzw;
  o0.w = r0.w;
  r0.rgb = lutShaper(r0.rgb);
  r0.xyz = cb0[36].yyy * r0.xyz;
  r0.w = 0.5 * cb0[36].x;
  r0.xyz = r0.xyz * cb0[36].xxx + r0.www;
  r0.xyzw = t3.Sample(s3_s, r0.xyz).xyzw;
  if (injectedData.fxFilmGrain > 0.f) {
    r0.rgb = applyFilmGrain(r0.rgb, w1, injectedData.fxFilmGrainType != 0.f);
  }
  if (injectedData.fxNoise > 0.f) {
    r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
    r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
    r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r0.w = r1.w * 2 + -1;
    r1.x = 1 + -abs(r0.w);
    r0.w = saturate(r0.w * 3.40282347e+38 + 0.5);
    r0.w = r0.w * 2 + -1;
    r1.x = sqrt(r1.x);
    r1.x = 1 + -r1.x;
    r0.w = r1.x * r0.w;
    r0.xyz = r0.www * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r0.xyz;
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  }
  o0.rgb = r0.rgb;
  return;
}
