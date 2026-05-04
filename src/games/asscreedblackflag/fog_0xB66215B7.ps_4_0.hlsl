#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Nov 20 00:13:11 2025

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


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = InputTextureDepth.SampleLevel(pointSampler_s, v1.xy, 0).x;
  r0.x = g_VolumetricFogConstants.m_LinearZConstants.x + r0.x;
  r0.x = g_VolumetricFogConstants.m_LinearZConstants.y / r0.x;
  r0.x = -g_VolumetricFogConstants.m_StartDistance + r0.x;
  r0.x = saturate(r0.x / g_VolumetricFogConstants.m_Distance);
  r0.x = log2(r0.x);
  r0.x = 0.833333313 * r0.x;
  r0.z = saturate(exp2(r0.x));
  r0.xy = saturate(v1.xy);
  r0.xyz = r0.xyz * float3(0.993749976,0.98888886,0.984375) + float3(0.00312500005,0.00555555569,0.0078125);
  r0.xyzw = InputTexture.SampleLevel(linearSampler_s, r0.xyz, 0).xyzw;
  r0.w = saturate(g_VolumetricFogConstants.m_FogValue * r0.w);
  r1.xyzw = InputTexture2D.SampleLevel(pointSampler_s, v1.xy, 0).xyzw;

  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  r1.xyz = renodx::color::gamma::DecodeSafe(r1.xyz);

  //r0.xyz *= 0.f;

  if (RENODX_TONE_MAP_TYPE != 0) {
    // r0.xyz = FixColorFade(r1.xyz, r0.xyz);
    r0.xyz = -r1.xyz + r0.xyz;
    r0.xyz = (r0.www * CUSTOM_FOG_DENSITY) * r0.xyz + r1.xyz;
  }
  else {
    r0.xyz = -r1.xyz + r0.xyz;
    r0.xyz = r0.www  * r0.xyz + r1.xyz;
  }

  

  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  o0.xyz = renodx::color::gamma::EncodeSafe(r0.xyz);

  o0.w = 1;
  return;
}