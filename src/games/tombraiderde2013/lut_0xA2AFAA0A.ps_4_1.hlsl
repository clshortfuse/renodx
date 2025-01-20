#include "./shared.h"

cbuffer DrawableBuffer : register(b1)
{
  float4 FogColor : packoffset(c0);
  float4 DebugColor : packoffset(c1);
  float AlphaThreshold : packoffset(c2);
  float4 __InstancedMaterialOpacity[12] : packoffset(c3);
}

cbuffer InstanceBuffer : register(b5)
{

  struct
  {
    float4 InstanceParams[8];
    float4 ExtendedInstanceParams[16];
  } InstanceParameters[12] : packoffset(c0);

}

SamplerState AttenuationSampler_sampler_s : register(s15);
Texture2D<float4> p_default_Material_42489B849361291_BackBufferTexture_texture : register(t0);
Texture3D<float4> g_Texlut0 : register(t112);
Texture3D<float4> g_Texlut1 : register(t113);
Texture3D<float4> g_Texlut2 : register(t114);


// 3Dmigoto declarations
#define cmp -


void main(
  nointerpolation uint4 v0 : PSIZE0,
  float4 v1 : SV_POSITION0,
  float v2 : SV_ClipDistance0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = (int)v0.x * 24;
  r1.xy = (int2)v1.xy;
  r1.zw = float2(0,0);
  r1.xyz = p_default_Material_42489B849361291_BackBufferTexture_texture.Load(r1.xyz).xyz;

  r0.y = round(InstanceParameters[r0.x].InstanceParams[0].x);
  r0.y = (int)r0.y;
  r0.z = cmp(0 < (int)r0.y);
  // if (r0.z != 0) {
  if (CUSTOM_LUT_STRENGTH != 0 && r0.z != 0) {
    // r2.xyz = log2(r1.xyz);
    // r2.xyz = float3(0.833333313,0.833333313,0.833333313) * r2.xyz;
    // r2.xyz = exp2(r2.xyz);
    r2.xyz = renodx::math::SignPow(r1.rgb, 1.f / 1.2f);

    float3 original = r2.rgb;
    float3 sdr = saturate(renodx::tonemap::renodrt::NeutralSDR(max(0, original)));
    r2.xyz = sdr;

    r3.xyz = g_Texlut0.SampleLevel(AttenuationSampler_sampler_s, r2.xyz, 0).xyz;
    r0.z = cmp(1 < (int)r0.y);
    if (r0.z != 0) {
      r4.xyz = g_Texlut1.SampleLevel(AttenuationSampler_sampler_s, r2.xyz, 0).xyz;
      r4.xyz = r4.xyz + -r3.xyz;
      r3.xyz = InstanceParameters[r0.x].InstanceParams[0].yyy * r4.xyz + r3.xyz;
      r0.y = cmp(2 < (int)r0.y);
      if (r0.y != 0) {
        r0.yzw = g_Texlut2.SampleLevel(AttenuationSampler_sampler_s, r2.xyz, 0).xyz;
        r0.yzw = r0.yzw + -r3.xyz;
        r3.xyz = InstanceParameters[r0.x].InstanceParams[0].zzz * r0.yzw + r3.xyz;
      }
    }

    r3.xyz = renodx::tonemap::UpgradeToneMap(original, sdr, r3.xyz, CUSTOM_LUT_STRENGTH);

    // r0.xyz = log2(r3.xyz);
    // r0.xyz = float3(1.20000005,1.20000005,1.20000005) * r0.xyz;
    // r1.xyz = exp2(r0.xyz);
    r1.rgb = renodx::math::SignPow(r3.xyz, 1.2f);
  }
  r0.x = v0.x;
  r1.w = __InstancedMaterialOpacity[r0.x].x;
  o0.xyzw = r1.xyzw;

  
  o0.w = saturate(o0.w);
  return;
}