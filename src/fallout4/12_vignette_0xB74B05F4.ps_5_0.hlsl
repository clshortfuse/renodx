#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float2 v1 : TEXCOORD0,
                          out float4 o0 : SV_Target0
) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = t1.Sample(s1_s, v1.xy).xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.yz = -cb2[1].xy * float2(0.5, 0.5) + v1.xy;
  r0.y = dot(r0.yz, r0.yz);
  r0.xy = sqrt(r0.xy);
  r0.y = saturate(r0.y * 0.100000001 + -0.0179999992);
  r0.y = r0.x * r0.y;
  r0.y = cmp(r0.y < 0.00100000005);
  r0.zw = min(cb2[1].xy, v1.xy);
  r1.xy = t1.Sample(s1_s, r0.zw).xy;
  r2.xyz = t0.Sample(s0_s, r0.zw).xyz;
  const float3 inputColor = r2.xyz;

  if (r0.y != 0) {
    o0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
    return;
  }
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  r0.x = r0.x + -r0.y;
  r0.x = saturate(-abs(r0.x) * cb2[0].z + 1);
  r0.yzw = r2.xyz * r0.xxx;
  r0.yzw = float3(4, 4, 4) * r0.yzw;
  r0.x = r0.x * 4 + 0.00100000005;
  o0.xyz = r0.yzw / r0.xxx;
  o0.w = 1;

  o0.xyz = lerp(inputColor, o0.xyz, injectedData.fxVignette);
  return;
}
