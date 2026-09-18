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

// 3Dmigoto declarations
#define cmp -

#ifndef RENODX_NAN_FIX_EPSILON
#define RENODX_NAN_FIX_EPSILON 1e-6
#endif

#ifndef RENODX_FLOAT_MAX
#define RENODX_FLOAT_MAX 65504.0
#endif

float SafeFloat(float v)
{
  return (v == v && abs(v) < RENODX_FLOAT_MAX) ? v : 0.0;
}

float2 SafeFloat2(float2 v)
{
  return float2(
    SafeFloat(v.x),
    SafeFloat(v.y)
  );
}

float3 SafeFloat3(float3 v)
{
  return float3(
    SafeFloat(v.x),
    SafeFloat(v.y),
    SafeFloat(v.z)
  );
}

float4 SafeFloat4(float4 v)
{
  return float4(
    SafeFloat(v.x),
    SafeFloat(v.y),
    SafeFloat(v.z),
    SafeFloat(v.w)
  );
}

float SafePositive(float v)
{
  return max(SafeFloat(v), 0.0);
}

float3 SafePositive3(float3 v)
{
  v = SafeFloat3(v);
  return max(v, 0.0.xxx);
}

float SafeDenom(float v)
{
  v = SafeFloat(v);
  return max(abs(v), RENODX_NAN_FIX_EPSILON);
}

float SafeLog2Input(float v)
{
  return max(SafePositive(v), RENODX_NAN_FIX_EPSILON);
}

float3 SafeLog2Input3(float3 v)
{
  v = SafePositive3(v);
  return max(v, RENODX_NAN_FIX_EPSILON.xxx);
}

float SafeExp2(float v)
{
  v = SafeFloat(v);
  return SafeFloat(exp2(v));
}

float3 SafeExp2_3(float3 v)
{
  v = SafeFloat3(v);
  return SafeFloat3(exp2(v));
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = SafeFloat(InputTextureDepth.SampleLevel(pointSampler_s, v1.xy, 0).x);

  r0.x = SafeFloat(g_VolumetricFogConstants.m_LinearZConstants.x) + r0.x;
  r0.x = SafeFloat(g_VolumetricFogConstants.m_LinearZConstants.y) / SafeDenom(r0.x);
  r0.x = -SafeFloat(g_VolumetricFogConstants.m_StartDistance) + r0.x;
  r0.x = saturate(r0.x / SafeDenom(g_VolumetricFogConstants.m_Distance));

  r0.x = log2(SafeLog2Input(r0.x));
  r0.x = 0.833333313 * SafeFloat(r0.x);
  r0.z = saturate(SafeExp2(r0.x));

  r0.xy = saturate(SafeFloat2(v1.xy));

  r0.xyz =
    r0.xyz * float3(0.993749976, 0.98888886, 0.984375) +
    float3(0.00312500005, 0.00555555569, 0.0078125);

  r0.xyz = saturate(SafeFloat3(r0.xyz));

  r0.xyzw = SafeFloat4(InputTexture.SampleLevel(linearSampler_s, r0.xyz, 0).xyzw);

  r0.xyz = SafePositive3(r0.xyz);
  r0.w = saturate(SafeFloat(g_VolumetricFogConstants.m_FogValue) * SafePositive(r0.w));

  r1.xyz = SafePositive3(InputTexture2D.SampleLevel(pointSampler_s, v1.xy, 0).xyz);

  r1.xyz = log2(SafeLog2Input3(r1.xyz));
  r1.xyz = float3(2.20000005, 2.20000005, 2.20000005) * SafeFloat3(r1.xyz);
  r1.xyz = SafePositive3(SafeExp2_3(r1.xyz));

  r0.xyz = -r1.xyz + r0.xyz;
  r0.xyz = r0.www * r0.xyz + r1.xyz;

  r0.xyz = SafePositive3(r0.xyz);

  r0.xyz = log2(SafeLog2Input3(r0.xyz));
  r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * SafeFloat3(r0.xyz);

  o0.xyz = SafePositive3(SafeExp2_3(r0.xyz));
  o0.w = 1.0;

  return;
}