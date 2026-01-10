#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 hdr10_parameters1 : packoffset(c0);
  float4 hdr10_parameters2 : packoffset(c1);
  float4 hdr10_parameters3 : packoffset(c2);
  float4 hdr10_parameters4 : packoffset(c3);
  float4 hdr10_parameters5 : packoffset(c4);
  float4 hdr10_parameters6 : packoffset(c5);
  float4 hdr10_parameters7 : packoffset(c6);
  float4 hdr10_parameters8 : packoffset(c7);
  float4 hdr10_parameters9 : packoffset(c8);
  float4 hdr10_parameters10 : packoffset(c9);
  row_major float4x4 m_wvp_prev : packoffset(c10);
  row_major float4x4 m_vp_prev : packoffset(c14);
  float4 ssfx_jitter : packoffset(c18);
  float4 L_hotness : packoffset(c19);
  float4 c_brightness : packoffset(c20);
}

SamplerState smp_rtlinear_s : register(s0);
SamplerState smp_linear_s : register(s1);
Texture2D<float4> s_base0 : register(t0);
Texture2D<float4> s_base1 : register(t1);
Texture2D<float4> s_noise : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,      // Base texture 0 UV coordinates
  float2 w0 : TEXCOORD1,      // Base texture 1 UV coordinates  
  float2 v1 : TEXCOORD2,      // Noise texture UV coordinates
  float4 v2 : COLOR0,         // Color modulation and blend factor
  float4 v3 : COLOR1,         // Saturation control (xyz = weights, w = strength)
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // === BASE COLOR COMPOSITION ===
  // Sample two base textures and add them together
  r0.xyz = s_base0.Sample(smp_rtlinear_s, v0.xy).xyz;
  r1.xyz = s_base1.Sample(smp_rtlinear_s, w0.xy).xyz;
  r0.xyz = r1.xyz + r0.xyz;
  
  // === SATURATION ADJUSTMENT ===
  // Apply saturation control using luminance-based desaturation
  r1.xyz = float3(0.5,0.5,0.5) * r0.xyz;
  r0.w = dot(r1.xyz, v3.xyz);                    // Calculate luminance using custom weights
  r0.xyz = r0.xyz * float3(0.5,0.5,0.5) + -r0.www;
  r0.xyz = v3.www * r0.xyz + r0.www;             // Blend between original and desaturated

  // === NOISE/DITHERING APPLICATION ===
  // Apply noise texture for dithering or film grain effect
  //r1.xyz = s_noise.Sample(smp_linear_s, v1.xy).xyz;
  //r1.xyz = r1.xyz * r0.xyz;                      // Modulate color with noise
  //r2.xyz = r1.xyz + r1.xyz;                      // Double the noise effect
  //r0.xyz = -r1.xyz * float3(2,2,2) + r0.xyz;    // Subtract doubled noise from original
  //r0.xyz = v2.www * r0.xyz + r2.xyz;            // Blend between original and noise-affected color
  
  // === FINAL COLOR ADJUSTMENT ===
  // Apply color modulation and brightness
  r0.xyz = r0.xyz * v2.xyz + c_brightness.xyz;  // Color tint and brightness offset
  r0.xyz = r0.xyz + r0.xyz;                     // Double the final result
  const float3 graded_color_gamma = max(r0.xyz, float3(0,0,0));
  const float3 graded_color_linear = renodx::color::gamma::DecodeSafe(graded_color_gamma, 2.2f);

  float3 output_linear = graded_color_linear;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_linear = renodx::draw::ToneMapPass(graded_color_linear, graded_color_linear);
  } else {
    output_linear = saturate(output_linear);
  }

  o0.xyz = renodx::draw::RenderIntermediatePass(output_linear);
  o0.w = 1;
  return;
}