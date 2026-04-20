#include "./common.hlsli"

sampler2D sourceSampler : register(s0);
sampler2D additiveBiasSampler : register(s1);

float4 g_ScaleOffsetSkyCoverage : register(c0);
float4 g_ColorTop : register(c1);
float4 g_ColorBottom : register(c2);

struct PS_INPUT {
  float2 texcoord : TEXCOORD0;
};

float4 main(PS_INPUT i) : COLOR {
  const float2 overlay_uv = float2(i.texcoord.x, 1.f - i.texcoord.y);
  float4 overlay = tex2D(additiveBiasSampler, overlay_uv);

  float4 r1 = overlay + 0.5f;
  float4 r0 = (overlay - 0.5f) * g_ScaleOffsetSkyCoverage.x;
  r0 += r0;

  float4 frac_part = frac(r1);
  r1 -= frac_part;

  float4 ramp = r1 * (g_ColorTop - 1.f) + 1.f;
  float4 inv_r1 = 1.f - r1;

  float4 source = tex2D(sourceSampler, i.texcoord);
  float4 combined = r0 * ramp + source;
  float4 additive_term = abs(r0) * inv_r1;

  float gradient_strength = CUSTOM_BLOOM;
  combined = lerp(source, combined, gradient_strength);
  additive_term *= gradient_strength;

  return additive_term * g_ColorBottom + combined;
}
