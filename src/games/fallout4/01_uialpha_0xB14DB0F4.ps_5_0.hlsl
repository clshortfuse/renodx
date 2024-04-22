#include "../../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[15];
}

cbuffer cb1 : register(b1) {
  float4 cb1[1];
}

cbuffer cb0 : register(b0) {
  float4 cb0[20];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float4 v1 : TEXCOORD0,
                          float4 v2 : COLOR1,
                                      out float4 o0 : SV_Target0
) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t0.Sample(s0_s, v1.xy).w;
  r0.y = cb1[0].w * r0.x;
  r0.z = cb2[13].w * r0.y;
  r0.y = r0.y * cb2[13].w + -cb2[14].x;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.y = cmp(cb2[14].y < 1);
  if (r0.y != 0) {
    r0.x = cb2[14].y + -r0.x;
    r0.x = cmp(r0.x < 0);
    if (r0.x != 0) discard;
  }
  r0.x = (int)cb0[2].x;
  r0.y = r0.z;
  r0.w = 0;
  r1.x = 0;
  while (true) {
    r1.y = cmp((int)r0.w >= (int)r0.x);
    if (r1.y != 0) break;
    r1.y = cmp(cb0[r0.w + 3].x < 0);
    r1.z = r1.y ? -cb0[r0.w + 3].x : cb0[r0.w + 3].x;
    r1.z = -v1.x + r1.z;
    r2.xy = -cb0[r0.w + 3].zw + v1.xy;
    r1.w = cb0[r0.w + 3].y + -v1.y;
    r1.zw = max(r2.xy, r1.zw);
    r1.z = max(r1.z, r1.w);
    r1.z = -cb0[2].y * r1.z + 1;
    r1.x = max(r1.z, r1.x);
    r1.zw = cb0[r0.w + 3].yw + float2(-0.00249999994, 0.00249999994);
    r1.z = cmp(v1.y >= r1.z);
    r1.y = r1.z ? r1.y : 0;
    r1.z = cmp(r1.w >= v1.y);
    r1.y = r1.z ? r1.y : 0;
    if (r1.y != 0) {
      r1.y = -cb0[r0.w + 3].y + v1.y;
      r1.z = cb0[r0.w + 3].w + -cb0[r0.w + 3].y;
      r1.y = r1.y / r1.z;
      r0.y = r1.y * r0.y;
    }
    r0.w = (int)r0.w + 1;
  }
  r1.x = saturate(r1.x);
  r0.x = r1.x * r0.y;
  o0.w = cb0[2].w * r0.x;
  r0.x = cmp(cb0[2].z != 0.000000);
  r0.yzw = log2(cb0[19].xyz);
  r0.yzw = float3(2.20000005, 2.20000005, 2.20000005) * r0.yzw;
  r0.yzw = exp2(r0.yzw);
  o0.xyz = r0.xxx ? cb0[19].xyz : r0.yzw;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
