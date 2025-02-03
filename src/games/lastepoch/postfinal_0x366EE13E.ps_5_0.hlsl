#include "./common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0) {
  float4 cb0[29];
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

  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  o0.w = r1.w;
  if (injectedData.fxFilmGrain > 0.f) {
    r1.rgb = applyFilmGrain(r1.rgb, w1.xy, injectedData.fxFilmGrainType != 0.f);
  }
  if (injectedData.fxNoise > 0.f) {
    r0.xy = v1.xy * cb0[28].xy + cb0[28].zw;
    r0.x = t0.Sample(s0_s, r0.xy).w;
    r0.x = r0.x * 2 + -1;
    r0.y = 1 + -abs(r0.x);
    r0.x = saturate(r0.x * 3.40282347e+38 + 0.5);
    r0.x = r0.x * 2 + -1;
    r0.y = sqrt(r0.y);
    r0.y = 1 + -r0.y;
    r0.x = r0.x * r0.y;
    r1.rgb = renodx::color::srgb::EncodeSafe(r1.rgb);
    r1.rgb = r0.rrr * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r1.rgb;
    r1.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
  }
  r1.rgb = PostToneMapScale(r1.rgb);
  o0.xyz = r1.xyz;
  return;
}
