#include "../common.hlsli"

Texture2D<float4> g_textures2D[] : register(t0, space2);

cbuffer Globals : register(b0, space0) {
  float gMotionBlurScalar;
  float UsingHDR10;
  float HDRPeakNits;
  float SDRPaperWhiteNits;
  float physicsmaterial;
  float4 TexelSize;
  float4 BlueShiftColor;
  float4 BlueShiftParams;
  float ElapsedTime;
  float Frames;
  float Lambda;
  float4 BrightPassValues;
  float White;
  float IntensityBloom;
  float4 brightPassParams;
  float3 LUMINANCE;
  float deSat;
  float4 ConstAdd;
  float4 ColorCorrect;
  float Contrast;
  float4 DofParams;
  float3 NearFarClipPlaneQ;
  float2 NearFarClipPaneScaleAndBias;
  float4x4 gViewProjInverse;
  float Gamma;
  float LowerLimitAdaption;
  float HigherLimitAdaption;
  float distortionFreq;
  float distortionScale;
  float distortionRoll;
  float4 SSAOProjectionParams;
  float4 SSAOTweakParams;
  float4 gScreenSize;
  float ParticleHeatShimmerSeed;
  int FullResMapSampler;
  int FullResMapSamplerSS;
  int RenderMapSampler;
  int RenderMapSamplerSS;
  int RenderMapPointSampler;
  int RenderMapPointSamplerSS;
  int RenderMapBilinearSampler;
  int RenderMapBilinearSamplerSS;
  int RenderMapAnisoSampler;
  int RenderMapAnisoSamplerSS;
  int DepthMapSampler;
  int DepthMapSamplerSS;
  int ToneMapSampler;
  int ToneMapSamplerSS;
  int AdaptedLuminanceMapSampler;
  int AdaptedLuminanceMapSamplerSS;
  int LightGlowTexSampler;
  int LightGlowTexSamplerSS;
  float AdaptedLuminance;
  float2 horzTapOffs[7];
  float2 vertTapOffs[7];
  float4 TexelWeight[16];
  float3 Scale;
  float DustOverlayStrength;
  float SoftDofFalloffPower;
  float SoftDofStrength;
  float DofBackendPull;
  float TotalTime;
  float4 HeatShimmerParams;
  float4 ColorScalar;
  int DOFHelperSampler;
  int DOFHelperSamplerSS;
  int ParticleCompositeSampler;
  int ParticleCompositeSamplerSS;
  int GlowSampler;
  int GlowSamplerSS;
  int GlowSampler2;
  int GlowSampler2SS;
  float DisableVignette;
  float AdditiveReducer;
  float AdditiveReducer2;
  float4 GlowColor2;
  float4 GlowColor;
  float FlareSize;
  int DeathSampler;
  int DeathSamplerSS;
  float DeathMag;
  float DeathDrip;
  float DeathBlood;
  float4 DeathColor;
  float3 DeathEffect;
  float4 InjuryDirections;
  float4 InjuryTimes;
  float4x4 WorldViewProjInverse;
  float AverageHeight;
  float4 LightStreakDirection;
  float4 streakWeights;
  float4 StreakParams;
  float4 DuelColorCorrect;
  float4 DuelConstAdd;
  float DuelEnemyU;
  float DuelEnemyWidth;
  float DueldeSat;
  float DuelContrast;
};

SamplerState g_samplers[] : register(s0, space1);

// PSRDR2Postfx()
float4 main(float4 SV_Position: SV_POSITION,
            float4 TEXCOORD0: TEXCOORD0,
            float4 TEXCOORD1: TEXCOORD1,
            float4 TEXCOORD2: TEXCOORD2)
    : SV_Target {
  // Anisotropic Sampler - DoF & Bloom
  float4 anisotropicSampler = g_textures2D[RenderMapAnisoSampler].Sample(g_samplers[RenderMapAnisoSamplerSS], TEXCOORD0.xy);

  // Full Res Map Sampler - Scene Texture
  float3 fullResMap = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD0.xy).rgb;

  // Depth of Field (DoF) - Combines DoFMap and fullResMap
  float3 DoFMap = g_textures2D[RenderMapBilinearSampler].Sample(g_samplers[RenderMapBilinearSamplerSS], TEXCOORD0.xy).rgb;
  float depthMap = g_textures2D[DepthMapSampler].Sample(g_samplers[DepthMapSamplerSS], TEXCOORD0.xy).x;
  float nearFarClipPlane = (-(NearFarClipPlaneQ.x * NearFarClipPlaneQ.z)) / (depthMap - NearFarClipPlaneQ.z);
  float dofDepthDiff = nearFarClipPlane - DofParams.y;
  float dofFocusFactor = saturate(dofDepthDiff * DofParams.x);
  bool isBlurred = (nearFarClipPlane < DofParams.z);
  float blurBlendFactor = max(isBlurred * dofFocusFactor, saturate(anisotropicSampler.w));
  float3 sceneColor = lerp(fullResMap, DoFMap, blurBlendFactor);

  // Eye Adaptation + Tonemap - Reinhard Extended
  float adaptedLuminance = g_textures2D[AdaptedLuminanceMapSampler].Sample(g_samplers[AdaptedLuminanceMapSamplerSS], float2(0.0, 0.0)).x;
  float clampedAdaptedLuminance = clamp(adaptedLuminance, LowerLimitAdaption, HigherLimitAdaption);
  float scale = (BrightPassValues.z / (clampedAdaptedLuminance + 0.001));
  float3 color_scaled = sceneColor * scale;
  float3 color_scaled_over_white_plus_one = (color_scaled / White) + 1;
  float3 tonemappedColor = (color_scaled_over_white_plus_one * color_scaled) / (color_scaled + 1);

#if 1  // blended reinhard with untonemapped
  float3 vanillaColor = tonemappedColor;

  float midGrayScale = RDR1ReinhardMidgrayScale(White);
  float3 untonemapped_scaled = color_scaled * midGrayScale;

  float3 blendedColor = (RENODX_TONE_MAP_TYPE != 0.f) ? lerp(vanillaColor, untonemapped_scaled, saturate(vanillaColor / 0.18f)) : vanillaColor;

  tonemappedColor = blendedColor;
#endif

  // Apply Bloom
  float3 bloom = anisotropicSampler.rgb * anisotropicSampler.rgb;
  float3 scaledBloom = IntensityBloom * bloom;
  float3 bloomedColor = tonemappedColor + scaledBloom;

  // Apply Color Correction
  float3 colorCorrected = (ColorCorrect.rgb * 2.0) * (bloomedColor + ConstAdd.xyz);

  // Apply Desaturation - lerp to luminance
  float blackAndWhite = dot(colorCorrected, LUMINANCE.xyz);
  float3 desaturatedColorHDR = lerp(blackAndWhite, colorCorrected, deSat);

  // Apply Contrast
  // done in SDR, causes broken colors on highlights otherwise
  float3 desaturatedColorSDR;
  if (RENODX_TONE_MAP_TYPE == 0) {
    desaturatedColorSDR = saturate(desaturatedColorHDR);
  } else {
    desaturatedColorSDR = ApplyExponentialRolloffMaxChannel(max(0.f, desaturatedColorHDR));
  }
  float3 contrastedColor = desaturatedColorSDR - (((desaturatedColorSDR * Contrast) * (desaturatedColorSDR - 1.0)) * (desaturatedColorSDR - 0.5));

  float3 outputColor = contrastedColor;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    outputColor = renodx::tonemap::UpgradeToneMap(desaturatedColorHDR, desaturatedColorSDR, outputColor, 1.f);
    outputColor = lerp(blendedColor, outputColor, RENODX_COLOR_GRADE_STRENGTH);
  }

  outputColor = ApplyUserGrading(outputColor);

  // allowing negatives adds no wcg while causing artifacts in pause menu
  float3 gammaEncodedColor = renodx::color::gamma::Encode(max(0, outputColor), 2.2f);

  return float4(gammaEncodedColor, 1.0);
}
