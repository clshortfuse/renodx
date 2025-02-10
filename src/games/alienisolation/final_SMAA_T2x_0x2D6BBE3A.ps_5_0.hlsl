#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:05 2024

SamplerState PointSampler_s : register(s1);
Texture2D<float4> colorTex : register(t0);
Texture2D<float4> colorTexPrev : register(t2);
Texture2D<float4> velocityTex : register(t4);
Texture2D<float4> velocityMagnitudePrevTex : register(t11);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = velocityTex.Sample(PointSampler_s, v1.xy).xy;
  r0.z = dot(-r0.xy, -r0.xy);
  r0.xy = v1.xy + -r0.xy;
  r1.xyzw = colorTexPrev.Sample(PointSampler_s, r0.xy).xyzw;
  r0.x = sqrt(r0.z);
  r0.y = velocityMagnitudePrevTex.Sample(PointSampler_s, v1.xy).x;
  r0.x = r0.x + -r0.y;
  r0.x = sqrt(abs(r0.x));
  r0.x = 0.00400000019 + -r0.x;
  r0.x = r0.x * 30 + 1;
  r2.xyzw = colorTex.Sample(PointSampler_s, v1.xy).xyzw;
  r0.y = max(r2.w, r1.w);
  r1.xyz = -r2.xyz + r1.xyz;
  r0.y = saturate(4 * r0.y);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.x = saturate(-r0.z * r0.y + r0.x);
  r0.x = 0.5 * r0.x;
  r0.xyz = r0.xxx * r1.xyz + r2.xyz;

  // skip sRGB encoding as image is not linearized from resource views
  o0.rgb = r0.rgb;  // o0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
  o0.w = 0;
  return;
}
