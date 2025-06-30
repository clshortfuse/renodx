#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat Apr 12 00:05:57 2025

cbuffer ShaderP : register(b0)
{

  struct
  {
    float4x3 LinearTransfo;
    float4x3 LinearTransfoZFar;
    float3 ContrastPower;
    float DepthScale;
    float3 ContrastPowerZFar;
    float DepthBias;
  } g_CBuffer : packoffset(c0);

}

SamplerState SGbxClamp_Point_s : register(s0);
Texture2D<float4> TMapColor : register(t0);
Texture2D<float4> TMapDepthInX : register(t1);


// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0)
{
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = g_CBuffer.ContrastPowerZFar.xyz + -g_CBuffer.ContrastPower.xyz;
  r0.w = TMapDepthInX.Sample(SGbxClamp_Point_s, v1.xy).x;
  r0.w = saturate(r0.w * g_CBuffer.DepthScale + g_CBuffer.DepthBias);
  r0.xyz = r0.www * r0.xyz + g_CBuffer.ContrastPower.xyz;

  r1.xyzw = TMapColor.Sample(SGbxClamp_Point_s, v1.xy).xyzw;
  float3 input_color = r1.xyz;
  float3 linear_color = renodx::draw::InvertIntermediatePass(input_color);
  float3 signs = sign(linear_color);
  float3 sdr_color = renodx::tonemap::renodrt::NeutralSDR(linear_color);
  // float3 gamma_color = renodx::color::srgb::Encode(sdr_color);
  // r1.xyz = gamma_color;
  // r1.xyz = RENODX_TONE_MAP_TYPE ? gamma_color : r1.xyz;  // Fix vanilla
  r1.xyz = sdr_color;

  r2.xyz = float3(1, 1, 1) + -r1.xyz;
  r3.xyz = cmp(float3(0.5, 0.5, 0.5) < r1.xyz);
  r1.xyz = r3.xyz ? r2.xyz : r1.xyz;
  o0.w = r1.w;
  r1.xyz = saturate(r1.xyz + r1.xyz);
  //r1.xyz = r1.xyz + r1.xyz;

  // Below is a pow that probably controls the ingame brightness slider
  r1.xyz = log2(r1.xyz);
  r0.xyz = r1.xyz * r0.xyz;  // r0 = exponent and a float3; idk how to safepow it
  r0.xyz = exp2(r0.xyz);

  r1.xyz = float3(0.5, 0.5, 0.5) * r0.xyz;
  r0.xyz = -r0.xyz * float3(0.5, 0.5, 0.5) + float3(1, 1, 1);
  r1.xyz = r3.xyz ? r0.xyz : r1.xyz;
  r1.w = 1;
  r0.x = dot(r1.xyzw, g_CBuffer.LinearTransfoZFar._m00_m10_m20_m30);
  r0.y = dot(r1.xyzw, g_CBuffer.LinearTransfoZFar._m01_m11_m21_m31);
  r0.z = dot(r1.xyzw, g_CBuffer.LinearTransfoZFar._m02_m12_m22_m32);
  r2.x = dot(r1.xyzw, g_CBuffer.LinearTransfo._m00_m10_m20_m30);
  r2.y = dot(r1.xyzw, g_CBuffer.LinearTransfo._m01_m11_m21_m31);
  r2.z = dot(r1.xyzw, g_CBuffer.LinearTransfo._m02_m12_m22_m32);
  r0.xyz = -r2.xyz + r0.xyz;
  o0.xyz = r0.www * r0.xyz + r2.xyz;

  float3 outputColor;

  if (RENODX_TONE_MAP_TYPE >= 1) {
    float3 processed_sdr = signs * o0.rgb;
    outputColor = renodx::tonemap::UpgradeToneMap(linear_color, signs * sdr_color, processed_sdr, RENODX_COLOR_GRADE_STRENGTH_TWO);
  }
  else {
    outputColor = o0.rgb;
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(outputColor);
  return;
}

// void main(
//   float4 v0 : SV_Position0,
//   float2 v1 : TEXCOORD0,
//   out float4 o0 : SV_Target0)
// {
//   float4 r0,r1,r2,r3;
//   uint4 bitmask, uiDest;
//   float4 fDest;

//   r0.xyz = g_CBuffer.ContrastPowerZFar.xyz + -g_CBuffer.ContrastPower.xyz;
//   r0.w = TMapDepthInX.Sample(SGbxClamp_Point_s, v1.xy).x;
//   r0.w = saturate(r0.w * g_CBuffer.DepthScale + g_CBuffer.DepthBias);
//   r0.xyz = r0.www * r0.xyz + g_CBuffer.ContrastPower.xyz;
//   r1.xyzw = TMapColor.Sample(SGbxClamp_Point_s, v1.xy).xyzw;

//   // Grading code expects SDR, so tonemap back to SDR
//   r1.rgb = renodx::draw::InvertIntermediatePass(r1.rgb);
//   float3 ungraded = r1.rgb;
//   if (RENODX_TONE_MAP_TYPE >= 1.f) {
//     // r1.rgb = renodx::tonemap::ReinhardScalable(ungraded, RENODX_PEAK_WHITE_NITS);
//     //r1.rgb = renodx::tonemap::renodrt::NeutralSDR(ungraded);
//   }

//   r2.xyz = float3(1,1,1) + -r1.xyz;
//   r3.xyz = cmp(float3(0.5,0.5,0.5) < r1.xyz);
//   r1.xyz = r3.xyz ? r2.xyz : r1.xyz;
//   o0.w = r1.w;
//   r1.xyz = HDRSaturate(r1.xyz + r1.xyz);

//   r1.xyz = log2(r1.xyz);
//   r0.xyz = r1.xyz * r0.xyz;
//   r0.xyz = exp2(r0.xyz);

//   r1.xyz = float3(0.5,0.5,0.5) * r0.xyz;
//   r0.xyz = -r0.xyz * float3(0.5,0.5,0.5) + float3(1,1,1);
//   r1.xyz = r3.xyz ? r0.xyz : r1.xyz;
//   r1.w = 1;
//   r0.x = dot(r1.xyzw, g_CBuffer.LinearTransfoZFar._m00_m10_m20_m30);
//   r0.y = dot(r1.xyzw, g_CBuffer.LinearTransfoZFar._m01_m11_m21_m31);
//   r0.z = dot(r1.xyzw, g_CBuffer.LinearTransfoZFar._m02_m12_m22_m32);
//   r2.x = dot(r1.xyzw, g_CBuffer.LinearTransfo._m00_m10_m20_m30);
//   r2.y = dot(r1.xyzw, g_CBuffer.LinearTransfo._m01_m11_m21_m31);
//   r2.z = dot(r1.xyzw, g_CBuffer.LinearTransfo._m02_m12_m22_m32);
//   r0.xyz = -r2.xyz + r0.xyz;
//   o0.xyz = r0.www * r0.xyz + r2.xyz;

//   float3 graded_bt709 = o0.xyz;
//   //o0.rgb = CustomTonemap(ungraded, graded_bt709);
//   o0.rgb = renodx::draw::RenderIntermediatePass(graded_bt709);

//   return;
// }