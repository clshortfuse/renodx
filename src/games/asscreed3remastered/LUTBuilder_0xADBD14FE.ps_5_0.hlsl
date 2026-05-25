// ---- Created with 3Dmigoto v1.3.16 on Thu May 14 14:08:22 2026

#include "./common.hlsli"

cbuffer LightingConstscb : register(b8)
{

  struct
  {
    float4 m_LocalCubeMapParams[2];

    struct
    {
      float4 boxMax;
      float4 boxMin;
      float4 innerBlendBoxMax;
      float4 blendBoxMax;
      float4 worldPosition;
      float4x4 worldToLocal;
      uint cubeMapArrayIndex;
      float attenuation;
    } m_LocalCubeMaps[32];

    float4 m_GiAreaTextureBiasScale;
    float4 m_GiAreaVerticalAttenuation;
    float m_GiBounceStrength;
    float m_GlobalCubeMapIntensity;
    float4 m_GlobalLightingScale;
    float m_GiVolumesCount;

    struct
    {
      float4 boxMax;
      float4 boxMin;
      float4 params;
      float4x4 worldToLocal;
    } m_GiVolumes[4];

  } g_LightingConsts : packoffset(c0);

}

cbuffer HDRLightingConstscb : register(b5)
{

  struct
  {
    float RandomSeed;
    float Vignette;
    float FilmGrain;
    float PaperWhite;
    bool UseACESLUT;
    float LDRSplit;
    float2 ExposureParams;
    float4 BloomTint;
  } g_HDR : packoffset(c0);

}

SamplerState Scene_s : register(s0);
SamplerState Exposure_s : register(s1);
SamplerState Bloom_s : register(s2);
SamplerState LutSampler_s : register(s3);
Texture2D<float4> Scene : register(t0);
Texture2D<float4> Exposure : register(t1);
Texture2D<float4> Bloom : register(t2);
Texture3D<float4> AcesLUT : register(t3);


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

  r0.xy = float2(-0.5,-0.5) + v1.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = g_HDR.Vignette * r0.x;
  r0.x = exp2(r0.x);
  r0.yzw = Scene.Sample(Scene_s, v1.xy).xyz;
  r0.yzw = g_LightingConsts.m_GlobalLightingScale.yyy * r0.yzw;
  r1.xyz = Bloom.Sample(Bloom_s, v1.xy).xyz;
  r1.xyz = g_HDR.BloomTint.xyz * r1.xyz;
  r1.w = Exposure.Sample(Exposure_s, float2(0,0)).x;
  r0.yzw = r0.yzw * r1.www + r1.xyz;
  r0.xyz = r0.yzw * r0.xxx;
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0588235296,0.0588235296,0.0588235296) + float3(0.527878284,0.527878284,0.527878284));
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = AcesLUT.SampleLevel(LutSampler_s, r0.xyz, 0).xyz;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = ApplyAC3RLUTBuilderAcesChromaticAberration(
        r0.xyz,
        v1.xy,
        Scene,
        Scene_s,
        Exposure,
        Exposure_s,
        Bloom,
        Bloom_s,
        AcesLUT,
        LutSampler_s,
        g_LightingConsts.m_GlobalLightingScale.y,
        g_HDR.BloomTint.xyz,
        g_HDR.Vignette);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}
