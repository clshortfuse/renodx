#include "./tonemap.hlsl"

SamplerState SamplerFrameBuffer_SMP_s : register(s6);
SamplerState SamplerDistortion_SMP_s : register(s7);
SamplerState SamplerBloomMap0_SMP_s : register(s8);
SamplerState SamplerQuarterSizeBlur_SMP_s : register(s9);
SamplerState SamplerColourLUT_SMP_s : register(s10);
SamplerState SamplerNoise_SMP_s : register(s12);
SamplerState SamplerToneMapCurve_SMP_s : register(s14);
Texture2D<float4> SamplerFrameBuffer_TEX : register(t6);
Texture2D<float4> SamplerDistortion_TEX : register(t7);
Texture2D<float4> SamplerBloomMap0_TEX : register(t8);
Texture2D<float4> SamplerQuarterSizeBlur_TEX : register(t9);
Texture3D<float4> SamplerColourLUT_TEX : register(t10);
Texture2D<float4> SamplerNoise_TEX : register(t12);
Texture2D<float4> SamplerToneMapCurve_TEX : register(t14);

void main(
    float4 v0: TEXCOORD0,
    float4 v1: TEXCOORD1,
    float4 v2: SV_Position0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  GetSceneColorAndTexCoord(
      SamplerDistortion_TEX, SamplerDistortion_SMP_s, SamplerFrameBuffer_TEX,
      SamplerFrameBuffer_SMP_s, v0, r2.rgb, r0.xy);

  // float3 mainTex = r2.xyz;

  // motion blur
  r1.xyz = HDR_EncodeScale.www * r2.xyz;
  r2.xyzw = SamplerQuarterSizeBlur_TEX.Sample(SamplerQuarterSizeBlur_SMP_s, r0.xy).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = HDR_EncodeScale2.zzz * r2.xyz;
  r0.z = sqrt(r2.w);
  r0.z = rp_parameter_ps[3].x * r0.z;
  r2.xyz = r2.xyz * float3(4, 4, 4) + -r1.xyz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;

  r0.rgb = ApplyBloom(r1.rgb, r0.xy, SamplerBloomMap0_TEX, SamplerBloomMap0_SMP_s);

  float3 untonemapped = r0.xyz;
  const float untonemappedLum = renodx::color::luma::from::BT601(untonemapped);  // save for reuse

  float3 outputColor = ApplyToneMapVignetteLUT(
      untonemapped, untonemappedLum, v1, v2, SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

  outputColor = ApplyDesaturation(outputColor);

  // ignore user gamma, force 2.2
  r0.xyz = renodx::color::gamma::EncodeSafe(outputColor, 2.2f);  //  r0.xyz = pow(r0.xyz, OutputGamma.xxx);

  // film grain
  r0.rgb = applyFilmGrain(r0.rgb, SamplerNoise_TEX, SamplerNoise_SMP_s, v1);

  r0.xyz = (r0.xyz * rp_parameter_ps[0].xxx + rp_parameter_ps[0].yyy);  // r0.xyz = saturate(r0.xyz * rp_parameter_ps[0].xxx + rp_parameter_ps[0].yyy);
  o0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.xyz = r0.xyz;

  return;
}
