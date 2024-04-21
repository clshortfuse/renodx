#include "../common/color.hlsl"
#include "./shared.h"

Texture2D<float4> t7 : register(t7);

TextureCube<float4> t5 : register(t5);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s7_s : register(s7);

SamplerState s5_s : register(s5);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[15];
}

cbuffer cb1 : register(b1) {
  float4 cb1[4];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float4 v1 : TEXCOORD0,
                          float4 v2 : TEXCOORD4,
                                      float4 v3 : TEXCOORD7,
                                                  float4 v4 : TEXCOORD8,
                                                              float3 v5 : TEXCOORD9,
                                                                          float4 v6 : COLOR1,
                                                                                      out float4 o0 : SV_Target0
) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.w = v1.z * r0.w;
  r1.xyz = r0.xyz;
  r1.xyzw = cb1[0].xyzw * r1.xyzw;
  r0.xyz = t1.Sample(s1_s, v1.xy).xyw;
  r0.xy = r0.xy * float2(2, 2) + float2(-1, -1);
  r2.x = dot(r0.xy, r0.xy);
  r2.x = min(1, r2.x);
  r2.x = 1 + -r2.x;
  r2.x = sqrt(r2.x);
  r2.yzw = v4.xyz * r0.yyy;
  r2.yzw = v3.xyz * r0.xxx + r2.yzw;
  r2.xyz = v5.xyz * r2.xxx + r2.yzw;
  r0.x = dot(r2.xyz, r2.xyz);
  r0.x = rsqrt(r0.x);
  r2.xyz = r2.xyz * r0.xxx;
  r0.x = dot(r2.xyz, v2.xyz);
  r0.x = r0.x + r0.x;
  r2.xyz = r0.xxx * r2.xyz + -v2.xyz;
  r2.xyz = -r2.xyz;
  r2.xyz = t5.Sample(s5_s, r2.xyz).xyz;
  r2.xyz = cb1[3].xxx * r2.xyz;
  r0.xyz = r2.xyz * r0.zzz;
  r2.x = t7.Sample(s7_s, v1.xy).x;
  r0.xyz = r0.xyz * r2.xxx + r1.xyz;
  r1.xyz = cb2[13].xyz * r0.xyz + -r0.xyz;
  r0.xyz = cb1[2].xxx * r1.xyz + r0.xyz;
  r1.x = cb2[13].w * r1.w;
  r1.y = 1 + -v6.w;
  o0.xyz = r1.yyy * r0.xyz;
  r0.x = r1.w * cb2[13].w + -cb2[14].x;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.x = cmp(cb2[14].y < 1);
  if (r0.x != 0) {
    r0.x = cb2[14].y + -r0.w;
    r0.x = cmp(r0.x < 0);
    if (r0.x != 0) discard;
  }
  o0.w = r1.x;

  o0.rgb = saturate(o0.rgb);
  o0.rgb = injectedData.toneMapGammaCorrection ? pow(o0.rgb, 2.2f) : linearFromSRGB(o0.rgb);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
