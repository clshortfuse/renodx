// ---- Created with 3Dmigoto v1.3.16 on Sat May 16 15:25:08 2026

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
Texture3D<float4> AcesLDRLUT : register(t4);
Texture3D<float4> Ldr2HDRLUT : register(t5);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = Scene.Sample(Scene_s, v1.xy).xyz;
  r0.xyz = g_LightingConsts.m_GlobalLightingScale.yyy * r0.xyz;
  r0.w = Exposure.Sample(Exposure_s, float2(0,0)).x;
  r1.xyz = Bloom.Sample(Bloom_s, v1.xy).xyz;
  r1.xyz = g_HDR.BloomTint.xyz * r1.xyz;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r1.xy = cmp(float2(0,0) != g_HDR.Vignette);
  r1.zw = float2(-0.5,-0.5) + v1.xy;
  r0.w = dot(r1.zw, r1.zw);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = g_HDR.Vignette * r0.w;
  r0.w = exp2(r0.w);
  r2.xyz = r0.xyz * r0.www;
  r0.xyz = r1.xxx ? r2.xyz : r0.xyz;
  if (g_HDR.UseACESLUT != 0) {
    r1.xzw = log2(r0.xyz);
    r1.xzw = saturate(r1.xzw * float3(0.0588235296,0.0588235296,0.0588235296) + float3(0.527878284,0.527878284,0.527878284));
    r1.xzw = r1.xzw * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r2.xyz = AcesLUT.SampleLevel(LutSampler_s, r1.xzw, 0).xyz;
    r0.w = cmp(g_HDR.LDRSplit != 0);
    if (r0.w != 0) {
      r0.w = cmp(0 < g_HDR.LDRSplit);
      r2.w = cmp(v1.x < g_HDR.LDRSplit);
      r3.x = cmp(-g_HDR.LDRSplit < v1.x);
      r0.w = r0.w ? r2.w : r3.x;
      if (r0.w != 0) {
        r1.xzw = AcesLDRLUT.SampleLevel(LutSampler_s, r1.xzw, 0).xyz;
        r1.xzw = saturate(r1.xzw);
        r1.xzw = r1.xzw * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
        r2.xyz = Ldr2HDRLUT.SampleLevel(LutSampler_s, r1.xzw, 0).xyz;
      }
    }
  } else {
    r1.xzw = r0.xyz * float3(0.97709924,0.97709924,0.97709924) + float3(1.46564889,1.46564889,1.46564889);
    r0.xyz = saturate(r0.xyz / r1.xzw);
    r1.xzw = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
    r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r2.xyz = r1.xzw ? r3.xyz : r0.xyz;
  }
  r0.xy = floor(v0.xy);
  r0.xy = (uint2)r0.xy;
  r0.z = (uint)g_HDR.RandomSeed;
  r0.x = mad((int)r0.x, 0x0019660d, (int)r0.y);
  r0.x = (int)r0.x + (int)r0.z;
  r0.y = (int)r0.x ^ 61;
  r0.x = (uint)r0.x >> 16;
  r0.x = (int)r0.x ^ (int)r0.y;
  r0.x = (int)r0.x * 9;
  r0.y = (uint)r0.x >> 4;
  r0.x = (int)r0.y ^ (int)r0.x;
  r0.x = (int)r0.x * 0x27d4eb2d;
  r0.y = (uint)r0.x >> 15;
  r0.x = (int)r0.y ^ (int)r0.x;
  r0.x = (uint)r0.x;
  r0.x = r0.x * 4.65661287e-010 + -1;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r2.xyz = ApplyAC3RLUTBuilderChromaticAberration(
        r2.xyz,
        v1.xy,
        Scene,
        Scene_s,
        Exposure,
        Exposure_s,
        Bloom,
        Bloom_s,
        AcesLUT,
        AcesLDRLUT,
        Ldr2HDRLUT,
        LutSampler_s,
        g_LightingConsts.m_GlobalLightingScale.y,
        g_HDR.BloomTint.xyz,
        g_HDR.Vignette,
        g_HDR.UseACESLUT ? 1.f : 0.f,
        g_HDR.LDRSplit);
  }
  r0.xyz = r0.xxx * g_HDR.FilmGrain + r2.xyz;
  o0.xyz = r1.yyy ? r0.xyz : r2.xyz;
  o0.w = 1;
  return;
}
