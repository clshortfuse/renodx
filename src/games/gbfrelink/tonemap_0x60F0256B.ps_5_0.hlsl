#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.16 on Tue Feb  4 22:33:20 2025

SamplerState g_TextureAdaptLumminanceSampler_s : register(s2);
SamplerState g_TextureBloomSampler_s : register(s3);
SamplerState g_TextureSceneColorHDRSampler_s : register(s4);
Texture2D<float4> g_TextureAdaptLumminance : register(t2);
Texture2D<float4> g_TextureBloom : register(t3);
Texture2D<float4> g_TextureSceneColorHDR : register(t4);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = g_TextureSceneColorHDR.Sample(g_TextureSceneColorHDRSampler_s, v1.xy).xyz;
  r1.xyz = (int3)r0.xyz & int3(0x7f800000,0x7f800000,0x7f800000);
  r1.xyz = cmp((int3)r1.xyz == int3(0x7f800000,0x7f800000,0x7f800000));
  r0.w = (int)r1.y | (int)r1.x;
  r0.w = (int)r1.z | (int)r0.w;
  
  r0.xyz = r0.www ? float3(1000000,1000000,1000000) : r0.xyz;
  
  r0.w = g_TextureAdaptLumminance.Sample(g_TextureAdaptLumminanceSampler_s, float2(0.5,0.5)).x;
  r0.xyz = r0.www * r0.xyz;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.xyz = r0.xyz * float3(0.150000006, 0.150000006, 0.150000006) + float3(0.0500000007, 0.0500000007, 0.0500000007);
    r1.xyz = r0.xyz * r1.xyz + float3(0.00400000019, 0.00400000019, 0.00400000019);
    r2.xyz = r0.xyz * float3(0.150000006, 0.150000006, 0.150000006) + float3(0.5, 0.5, 0.5);
    r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = float3(-0.0666666701, -0.0666666701, -0.0666666701) + r0.xyz;
  }
  
  r1.xyz = g_TextureBloom.Sample(g_TextureBloomSampler_s, v1.xy).xyz;

  //r0.xyz = saturate(r0.xyz * float3(1.37906432, 1.37906432, 1.37906432) + r1.xyz);
  r0.xyz = (r0.xyz * float3(1.37906432,1.37906432,1.37906432) + r1.xyz);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // custom
    r0.rgb /= 1.37906432f;
    o0.rgb = r0.rgb / 203.f * 80.f;

    r0.rgb = renodx::draw::ToneMapPass(o0.rgb);

    o0.rgb = renodx::draw::RenderIntermediatePass(r0.rgb);

    o0.w = 1;

    return;
  }

  r0.rgb = saturate(r0.rgb);

  o0.rgb = renodx::draw::RenderIntermediatePass(r0.rgb);
  o0.w = 1;

  return;
  
  r1.xyz = log2(r0.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  o0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  o0.w = 1;
  return;
}