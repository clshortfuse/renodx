#include "../../shaders/color.hlsl"
#include "./shared.h"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[15];
}

cbuffer cb1 : register(b1) {
  float4 cb1[3];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float4 v1 : TEXCOORD0,
                          float4 v2 : COLOR1,
                                      out float4 o0 : SV_Target0
) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = log2(cb1[0].xw);
  r0.xy = float2(0.454545468, 0.454545468) * r0.xy;
  r0.xy = exp2(r0.xy);
  r0.yz = v1.zz * r0.xy;
  r1.xz = t0.Sample(s0_s, v1.xy).wy;
  r0.w = log2(r1.z);
  r0.w = 0.454545468 * r0.w;
  r0.x = exp2(r0.w);
  r0.xyw = t4.Sample(s4_s, r0.xy).xyz;
  r0.xyw = cb1[1].xxx * r0.xyw;
  r1.z = log2(cb2[13].w);
  r1.z = 0.454545468 * r1.z;
  r1.z = exp2(r1.z);
  r1.y = r1.z * r0.z;
  r0.z = t4.Sample(s4_s, r1.xy).w;
  r1.yzw = cb2[13].xyz * r0.xyw + -r0.xyw;
  r0.xyw = cb1[2].xxx * r1.yzw + r0.xyw;
  r1.y = 1 + -v2.w;
  o0.xyz = r1.yyy * r0.xyw;
  r0.x = -cb2[14].x + r0.z;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = cmp(cb2[14].y < 1);
  if (r0.x != 0) {
    r0.x = cb2[14].y + -r1.x;
    r0.x = cmp(r0.x < 0);
    if (r0.x != 0) discard;
  }
  o0.w = r0.z;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
