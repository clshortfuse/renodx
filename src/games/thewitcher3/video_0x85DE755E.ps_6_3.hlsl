#include "./shared.h"

Texture2D<float4> t0[3] : register(t0);

SamplerState s0[3] : register(s0);

float4 main(
  linear float4 COLOR : COLOR,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _6 = t0[0u].Sample(s0[0u], float2(TEXCOORD.x, TEXCOORD.y));
  float _9 = (_6.x + -0.062745101749897f) * 1.1640000343322754f;
  float4 _12 = t0[1u].Sample(s0[1u], float2(TEXCOORD.x, TEXCOORD.y));
  float _14 = _12.x + -0.501960813999176f;
  float4 _17 = t0[2u].Sample(s0[2u], float2(TEXCOORD.x, TEXCOORD.y));
  float _19 = _17.x + -0.501960813999176f;
  SV_Target.x = ((_19 * 1.5959999561309814f) + _9);
  SV_Target.y = ((_9 - (_19 * 0.8130000233650208f)) - (_14 * 0.3919999897480011f));
  SV_Target.z = ((_14 * 2.0169999599456787f) + _9);
  SV_Target.w = COLOR.w;

  // float3 color = saturate(SV_Target.rgb);
  // color = renodx::draw::UpscaleVideoPass(color);
  // SV_Target.rgb = color;

  return SV_Target;
}
