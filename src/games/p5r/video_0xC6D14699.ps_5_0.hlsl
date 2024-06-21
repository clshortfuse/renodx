#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

SamplerState samp0_s : register(s0);
Texture2D<float4> texY : register(t0);
Texture2D<float4> texU : register(t1);
Texture2D<float4> texV : register(t2);

#define cmp -

void main(float4 v0 : SV_POSITION0, float4 v1 : COLOR0, float2 v2 : TEXCOORD0, out float4 o0 : SV_TARGET0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = texY.Sample(samp0_s, v2.xy).x;
  r0.y = texU.Sample(samp0_s, v2.xy).x;
  r0.z = texV.Sample(samp0_s, v2.xy).x;
  r0.x = r0.x;
  r0.y = r0.y;
  r0.z = r0.z;
  r0.w = 1;
  r1.xyzw = float4(-0.0627451017, -0.501960814, -0.501960814, -0);
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = float4(1.16438353, 0, 1.59602678, 0);
  r2.xyzw = float4(1.16438353, -0.391607136, -0.812812507, 0);
  r3.xyzw = float4(1.16438353, 2.01723218, 0, 0);
  r4.xyzw = float4(0, 0, 0, 1);
  r1.x = dot(r1.xyzw, r0.xyzw);
  r1.y = dot(r2.xyzw, r0.xyzw);
  r1.z = dot(r3.xyzw, r0.xyzw);
  r1.w = dot(r4.xyzw, r0.xyzw);
  o0.xyzw = v1.xyzw * r1.xyzw;
  o0 = max(0, o0);

  o0.rgb = pow(o0.rgb, 2.2f);
  if (injectedData.toneMapType >= 1.f) {
    float scaling = injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
    float videoPeak = 203.f * scaling;
    o0.rgb = bt2446a_inverse_tonemapping_bt709(o0.rgb, 100.f / scaling, videoPeak);
    o0.rgb /= videoPeak;  // Normalize to 1.0
    o0.rgb *= injectedData.toneMapPeakNits / injectedData.toneMapUINits;
  } else {
    o0.rgb *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  }
  o0.rgb = sign(o0.rgb) * pow(abs(o0.rgb), 1.f / 2.2f);

  return;
}
