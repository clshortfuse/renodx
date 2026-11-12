#include "./finite.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Mon Jun 15 22:59:37 2026

cbuffer VolumetricFogConstantscb : register(b2)
{
  struct
  {
    float4x4 m_ViewToWorldMatrix;
    float4 m_ReverseProjectionParams1;
    float4 m_ReverseProjectionParams2;
    float m_CurrentTime;
    float m_DeltaTime;
    float m_StartDistance;
    float3 m_EyePosition;
    float3 m_EyeXAxis;
    float3 m_EyeYAxis;
    float3 m_EyeZAxis;
    float m_Distance;
    float m_VerticalFalloffHeight;
    float m_NoiseFrequency;
    float m_NoiseIntensity;
    float m_ApplyExponent;
    float m_Falloff;
    float m_FogValue;
    float m_DistanceScale;
    float3 m_FogColor;
    float3 m_FogColorSunOpposite;
    float3 m_FogColorAmbient;
    float3 m_SunDirection;
    float3 m_FogReferenceTranslation;
    int m_PointLightsNum;
    float4 m_WorldLightmapParameters;
    float4 m_WorldLightmapParameters2;
    float4 m_WorldLightmapParameters3;
    float4 m_WorldLightmapUVParameters;
    float4 m_PointLightsPositions[16];
    float4 m_PointLightsColors[16];
    float4 m_LinearZConstants;
  } g_VolumetricFogConstants : packoffset(c0);
}

SamplerState pointSampler_s : register(s0);
SamplerState linearSampler_s : register(s1);

Texture3D<float4> InputTexture : register(t0);
Texture2D<float4> InputTexture2D : register(t1);
Texture2D<float> InputTextureDepth : register(t2);

float4 main(float4 position : SV_Position0, float2 uv : TEXCOORD0) : SV_Target0 {
  float depth = RogueFinite(InputTextureDepth.SampleLevel(pointSampler_s, uv, 0));
  float2 linear_z = g_VolumetricFogConstants.m_LinearZConstants.xy;
  float linear_depth = RogueFinite(linear_z.y) / RogueSafeDenominator(depth + RogueFinite(linear_z.x));
  float fog_depth = saturate((linear_depth - RogueFinite(g_VolumetricFogConstants.m_StartDistance))
      / RogueSafeDenominator(g_VolumetricFogConstants.m_Distance));
  float3 volume_uv = float3(saturate(uv), pow(fog_depth, 0.833333313f))
      * float3(0.993749976f, 0.98888886f, 0.984375f)
      + float3(0.00312500005f, 0.00555555569f, 0.0078125f);

  float4 fog = InputTexture.SampleLevel(linearSampler_s, volume_uv, 0);
  fog = RogueIsFinite(fog) ? fog : 0.f;
  float weight = saturate(fog.a * RogueFinite(g_VolumetricFogConstants.m_FogValue));
  float3 source = clamp(RogueFinite(InputTexture2D.SampleLevel(pointSampler_s, uv, 0).rgb), 0.f, ROGUE_FP16_MAX);
  float3 scene = pow(source, 2.2f);
  float3 combined = max(lerp(scene, fog.rgb, weight), 0.f);
  return float4(min(pow(combined, 1.f / 2.2f), ROGUE_FP16_MAX), 1.f);
}
