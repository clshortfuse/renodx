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

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD0: TEXCOORD,
    linear float4 TEXCOORD1: TEXCOORD1,
    linear float4 TEXCOORD2: TEXCOORD2)
    : SV_Target {
  float3 _12 = g_textures2D[RenderMapBilinearSampler].Sample(g_samplers[RenderMapBilinearSamplerSS], TEXCOORD0.xy).rgb;
  float _13 = _12.r;
  float _14 = _12.g;
  float _15 = _12.b;

  float clampedAdaptedLuminance = TEXCOORD1.x;

  // float _17 = BrightPassValues.z;
  // float _18 = clampedAdaptedLuminance + 0.001;
  // float _19 = _17 / _18;

  float scale = BrightPassValues.z / (clampedAdaptedLuminance + 0.001);

  float _20 = scale * _13;
  float _21 = scale * _14;
  float _22 = scale * _15;

  float3 color_scaled = float3(_20, _21, _22);

  float _24 = White;
  float _25 = _20 / _24;
  float _26 = _21 / _24;
  float _27 = _22 / _24;
  float _28 = _25 + 1.00000;
  float _29 = _26 + 1.00000;
  float _30 = _27 + 1.00000;
  float _31 = _28 * _20;
  float _32 = _29 * _21;
  float _33 = _30 * _22;
  float _34 = _20 + 1.00000;
  float _35 = _21 + 1.00000;
  float _36 = _22 + 1.00000;
  float _37 = _31 / _34;
  float _38 = _32 / _35;
  float _39 = _33 / _36;

#if 1  // blended reinhard with untonemapped
  float3 vanillaColor = float3(_37, _38, _39);

  float midGrayScale = RDR1ReinhardMidgrayScale(White);
  float3 untonemapped_scaled = color_scaled * midGrayScale;

  float3 blendedColor = (RENODX_TONE_MAP_TYPE != 0.f) ? lerp(vanillaColor, untonemapped_scaled, saturate(vanillaColor / 0.18f)) : vanillaColor;

  _37 = blendedColor.r;
  _38 = blendedColor.g;
  _39 = blendedColor.b;
#endif

  // Apply Color Correction
  float _41 = ConstAdd.x;
  float _42 = ConstAdd.y;
  float _43 = ConstAdd.z;
  float _44 = _41 + _37;
  float _45 = _42 + _38;
  float _46 = _43 + _39;
  float _48 = ColorCorrect.x;
  float _49 = ColorCorrect.y;
  float _50 = ColorCorrect.z;
  float _51 = _48 * 2.00000;
  float _52 = _51 * _44;
  float _53 = _49 * 2.00000;
  float _54 = _53 * _45;
  float _55 = _50 * 2.00000;
  float _56 = _55 * _46;

  float3 colorCorrected = float3(_52, _54, _56);

  // Apply Desaturation - lerp to luminance
  float blackAndWhite = dot(colorCorrected, LUMINANCE.xyz);
  float3 desaturatedColorHDR = lerp(blackAndWhite, colorCorrected, deSat);

  // Apply Contrast
  // done in SDR, causes broken colors on highlights otherwise
  float3 desaturatedColorSDR;
  if (RENODX_TONE_MAP_TYPE == 0) {
    desaturatedColorSDR = saturate(desaturatedColorHDR);
  } else {
    desaturatedColorSDR = ApplyExponentialRolloffMaxChannel(desaturatedColorHDR);
  }
  float3 contrastedColor = desaturatedColorSDR - (((desaturatedColorSDR * Contrast) * (desaturatedColorSDR - 1.0)) * (desaturatedColorSDR - 0.5));

  float3 outputColor = contrastedColor;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    outputColor = renodx::tonemap::UpgradeToneMap(desaturatedColorHDR, desaturatedColorSDR, outputColor, 1.f);
    outputColor = lerp(blendedColor, outputColor, RENODX_COLOR_GRADE_STRENGTH);
  }

  outputColor = ApplyUserGrading(outputColor);

  float3 gammaEncodedColor = renodx::color::gamma::Encode(max(0, outputColor), 2.2f);
  return float4(gammaEncodedColor, IntensityBloom);
}
