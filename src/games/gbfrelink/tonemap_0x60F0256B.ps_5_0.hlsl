#include "./shared.h"
#include "./uncharted2extended.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Tue Feb  4 22:33:20 2025

SamplerState g_TextureAdaptLumminanceSampler_s : register(s2);
SamplerState g_TextureBloomSampler_s : register(s3);
SamplerState g_TextureSceneColorHDRSampler_s : register(s4);
Texture2D<float4> g_TextureAdaptLumminance : register(t2);
Texture2D<float4> g_TextureBloom : register(t3);
Texture2D<float4> g_TextureSceneColorHDR : register(t4);


// 3Dmigoto declarations
#define cmp -

float ApplyVanillaToneMap(float untonemapped) {
  float r0, r1, r2;
  r0 = untonemapped;

  r1 = r0 * 0.15 + 0.05;
  r1 = r0 * r1 + 0.004;
  r2 = r0 * 0.15 + 0.5;
  r0 = r0 * r2 + 0.06;
  r0 = r1 / r0;
  r0 = -0.0666666701 + r0;
  r0 *= 1.37906432;

  return r0;
}

float3 ApplyVanillaToneMap(float3 untonemapped) {
  float3 r0, r1, r2;
  r0.rgb = untonemapped;

  r1.xyz = r0.xyz * 0.15 + 0.05;
  r1.xyz = r0.xyz * r1.xyz + 0.004;
  r2.xyz = r0.xyz * 0.15 + 0.5;
  r0.xyz = r0.xyz * r2.xyz + 0.06;
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = -0.0666666701 + r0.xyz;
  r0.rgb *= 1.37906432;

  return r0;
}

float3 Uncharted2Extended(float3 color) {
  float A = 0.15, B = 0.5, C = 0.1, D = 1.0, E = 0.004, F = 0.06;
  float W = 1.37906432;

  float coeffs[6] = { A, B, C, D, E, F };
  float white_precompute = W;

  Uncharted2::Config::Uncharted2ExtendedConfig uc2_config = Uncharted2::Config::CreateUncharted2ExtendedConfig(coeffs, white_precompute);

  float3 outputColor = Uncharted2::ApplyExtended(color, uc2_config);

  return outputColor;
}

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

  [branch]
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r1.xyz = r0.xyz * float3(0.150000006, 0.150000006, 0.150000006) + float3(0.0500000007, 0.0500000007, 0.0500000007);
    r1.xyz = r0.xyz * r1.xyz + float3(0.00400000019, 0.00400000019, 0.00400000019);
    r2.xyz = r0.xyz * float3(0.150000006, 0.150000006, 0.150000006) + float3(0.5, 0.5, 0.5);
    r0.xyz = r0.xyz * r2.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
    r0.xyz = r1.xyz / r0.xyz;
    r0.xyz = float3(-0.0666666701, -0.0666666701, -0.0666666701) + r0.xyz;
  }
  
  r1.xyz = g_TextureBloom.Sample(g_TextureBloomSampler_s, v1.xy).xyz;

  [branch]
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.rgb = r0.rgb;

    o0.rgb = Uncharted2Extended(o0.rgb);
    o0.rgb += r1.rgb * CUSTOM_BLOOM; // bloom

    o0.rgb = min(100.f, o0.rgb);

    renodx::draw::Config draw_config = renodx::draw::BuildConfig();
    draw_config.tone_map_hue_shift = 0.f;
    draw_config.tone_map_hue_correction = 0.f;

    float3 vanilla = saturate(ApplyVanillaToneMap(r0.rgb) + r1.rgb);

    o0.rgb = renodx::color::correct::Hue(o0.rgb, vanilla, RENODX_TONE_MAP_HUE_CORRECTION);

    o0.rgb = renodx::draw::ToneMapPass(o0.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);
    o0.w = 1;
    
    return;
  }

  r0.xyz = saturate(r0.xyz * float3(1.37906432, 1.37906432, 1.37906432) + r1.xyz);

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