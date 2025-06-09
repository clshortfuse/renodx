// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:43:23 2024

#include "../tonemap.hlsl"

SamplerState SamplerFrameBuffer_SMP_s : register(s6);
SamplerState SamplerDistortion_SMP_s : register(s7);
SamplerState SamplerBloomMap0_SMP_s : register(s8);
SamplerState SamplerQuarterSizeBlur_SMP_s : register(s9);
SamplerState SamplerColourLUT_SMP_s : register(s10);
SamplerState SamplerTargetColourLUT_SMP_s : register(s11);
SamplerState SamplerNoise_SMP_s : register(s12);
SamplerState SamplerToneMapCurve_SMP_s : register(s14);
Texture2D<float4> SamplerFrameBuffer_TEX : register(t6);
Texture2D<float4> SamplerDistortion_TEX : register(t7);
Texture2D<float4> SamplerBloomMap0_TEX : register(t8);
Texture2D<float4> SamplerQuarterSizeBlur_TEX : register(t9);
Texture3D<float4> SamplerColourLUT_TEX : register(t10);
Texture3D<float4> SamplerTargetColourLUT_TEX : register(t11);
Texture2D<float4> SamplerNoise_TEX : register(t12);
Texture2D<float4> SamplerToneMapCurve_TEX : register(t14);


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  GetSceneColorAndTexCoord(
      SamplerDistortion_TEX, SamplerDistortion_SMP_s, SamplerFrameBuffer_TEX,
      SamplerFrameBuffer_SMP_s, v0, r2.rgb, r0.xy);

  r1.rgb = ApplyMotionBlurType2(
      r2.rgb, r0.xy,
      SamplerQuarterSizeBlur_TEX, SamplerQuarterSizeBlur_SMP_s);


  r0.rgb = ApplyBloomType1(r1.rgb, r0.xy, SamplerBloomMap0_TEX, SamplerBloomMap0_SMP_s);

  const float untonemapped_lum = renodx::color::luma::from::BT601(r0.rgb);  // save for reuse

  float3 outputColor = ApplyToneMapVignetteDualLUTs(
      r0.rgb, untonemapped_lum, v1, v2, SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s,
      SamplerTargetColourLUT_TEX, SamplerTargetColourLUT_SMP_s);

  outputColor = ApplyDesaturation(outputColor);

  r0.xyz = EncodeGamma(outputColor);

  r0.rgb = ApplyFilmGrain(r0.rgb, SamplerNoise_TEX, SamplerNoise_SMP_s, v1);
  o0 = FinalizeToneMapOutput(r0.rgb);
  return;
}