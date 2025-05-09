#include "./common.hlsl"

cbuffer _Globals : register(b0) {
  float2 invPixelSize : packoffset(c0);
  float4 depthFactors : packoffset(c1);
  float2 fadeParams : packoffset(c2);
  float4 color : packoffset(c3);
  float4 colorMatrix0 : packoffset(c4);
  float4 colorMatrix1 : packoffset(c5);
  float4 colorMatrix2 : packoffset(c6);
  float exponent : packoffset(c7);
  float4 ironsightsDofParams : packoffset(c8);
  uint4 mainTextureDimensions : packoffset(c9);
  float cubeArrayIndex : packoffset(c10);
  float4 combineTextureWeights[2] : packoffset(c11);
  float4 colorScale : packoffset(c13);
  float2 invTexelSize : packoffset(c14);
  float4 downsampleQuarterZOffset : packoffset(c15);
  int sampleCount : packoffset(c16);
  float filterWidth : packoffset(c16.y);
  float mipLevelSource : packoffset(c16.z);
  float convolveSpecularPower : packoffset(c16.w);
  float convolveBlurRadius : packoffset(c17);
  int convolveSampleCount : packoffset(c17.y);
  float3 dofDepthScaleFactors : packoffset(c18);
  float4 radialBlurScales : packoffset(c19);
  float2 radialBlurCenter : packoffset(c20);
  float4 poissonRadialBlurConstants : packoffset(c21);
  float blendFactor : packoffset(c22);
  float3 tonemapGlareIntensity : packoffset(c22.y);
  float3 filmGrainColorScale : packoffset(c23);
  float4 filmGrainTextureScaleAndOffset : packoffset(c24);
  float3 depthScaleFactors : packoffset(c25);
  float4 dofParams : packoffset(c26);
  float4 dofParams2 : packoffset(c27);
  float4 dofDebugParams : packoffset(c28);
  float3 bloomScale : packoffset(c29);
  float3 invGamma : packoffset(c30);
  float3 luminanceVector : packoffset(c31);
  float3 vignetteParams : packoffset(c32);
  float4 vignetteColor : packoffset(c33);
  float4 chromostereopsisParams : packoffset(c34);
  float4 distortionScaleOffset : packoffset(c35);
}

SamplerState mainTextureSampler_s : register(s0);
SamplerState colorGradingTextureSampler_s : register(s1);
SamplerState distortionTextureSampler_s : register(s2);
SamplerState tonemapBloomTextureSampler_s : register(s3);
SamplerState ironsightsDofTextureSampler_s : register(s4);
Texture2D<float4> mainTexture : register(t0);
Texture3D<float4> colorGradingTexture : register(t1);
Texture2D<float4> distortionTexture : register(t2);
Texture2D<float4> tonemapBloomTexture : register(t3);
Texture2D<float4> ironsightsDofTexture : register(t4);

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = ironsightsDofTexture.Sample(ironsightsDofTextureSampler_s, v2.xy).xyzw;
  r0.xyz = r0.xyz * r0.xyz;
  r0.xyz = ironsightsDofParams.yyy * r0.xyz;
  r1.x = ironsightsDofParams.x * r0.w;
  r0.w = -r0.w * ironsightsDofParams.x + 1;
  r0.xyz = r1.xxx * r0.xyz;
  r1.xy = distortionTexture.Sample(distortionTextureSampler_s, v2.xy).xy;
  r1.xy = r1.xy * distortionScaleOffset.xy + distortionScaleOffset.zw;
  r1.xy = v2.xy + r1.xy;
  float2 screen = r1.xy;
  r2.xyz = mainTexture.Sample(mainTextureSampler_s, r1.xy).xyz;
  r1.xyz = tonemapBloomTexture.Sample(tonemapBloomTextureSampler_s, r1.xy).xyz;
  r0.xyz = r2.xyz * r0.www + r0.xyz;
  r0.xyz = r1.xyz * bloomScale.xyz * injectedData.fxBloom + r0.xyz;
  r0.xyz = colorScale.xyz * r0.xyz;
  r1.xy = float2(-0.5, -0.5) + v2.xy;
  r1.xy = vignetteParams.xy * r1.xy * min(1, injectedData.fxVignette);
  r0.w = dot(r1.xy, r1.xy);
  r0.w = saturate(-r0.w * vignetteColor.w + 1);
  r0.w = log2(r0.w);
  r0.w = vignetteParams.z * r0.w * max(1, injectedData.fxVignette);
  r0.w = exp2(r0.w);
  r0.xyz = r0.xyz * r0.www;
  float3 untonemapped = r0.rgb;
  float midGray = renodx::color::y::from::BT709(renodx::tonemap::HejlDawson(0.18f));
  float3 LUTless = renodx::tonemap::HejlDawson(untonemapped);
  o0.rgb = applyUserTonemap(untonemapped, colorGradingTexture, colorGradingTextureSampler_s, LUTless, midGray);
  if (!injectedData.resScaleCheck) {
  if (injectedData.fxFilmGrain > 0.f) {
    o0.rgb = applyFilmGrain(o0.rgb, screen, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  } else {
    o0.rgb = renodx::color::srgb::EncodeSafe(o0.rgb);
  }
  o0.a = renodx::color::y::from::BT709(o0.rgb);
  return;
}
