// 0xBDF6C074: eye adaptation. out = prev + (new - prev) * rate, rate = 1 - exp2(-2.623168 * t).

#include "./common.hlsli"  // RenoDX

cbuffer cb0 : register(b0)
{
  float4 g_TimeParam : packoffset(c65);
}

SamplerState sampDif0_sampler_s : register(s0);
SamplerState sampDif1_sampler_s : register(s1);
Texture2D<float4> sampDif0_NedSmpignorenametexture : register(t0);
Texture2D<float4> sampDif1_NedSmpignorenametexture : register(t1);

void main(
  out float4 o0 : SV_Target0)
{
  float rate = 1.0 - exp2(-2.623168 * g_TimeParam.x);
  float prev = sampDif0_NedSmpignorenametexture.Sample(sampDif0_sampler_s, float2(0.5, 0.5)).x;
  float next = sampDif1_NedSmpignorenametexture.Sample(sampDif1_sampler_s, float2(0.5, 0.5)).x;
  // RenoDX: Custom mode adapts at a per-direction speed (brighter/darker); 0 freezes.
  if (shader_injection.sg_auto_exposure == 2.f) {
    float speed = next > prev ? shader_injection.sg_ae_speed_brighter : shader_injection.sg_ae_speed_darker;
    rate = 1.0 - exp2(-2.623168 * g_TimeParam.x * speed);
  }

  float value = (next - prev) * rate + prev;
  o0.xyz = min(float3(65504, 65504, 65504), value.xxx);
  o0.w = 1;
}
