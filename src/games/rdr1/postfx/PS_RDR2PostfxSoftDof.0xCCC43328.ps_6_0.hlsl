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

float4 main(float4 SV_Position: SV_POSITION,
            float4 TEXCOORD0: TEXCOORD0,
            float4 TEXCOORD1: TEXCOORD1,
            float4 TEXCOORD2: TEXCOORD2)
    : SV_Target {
  float _1 = TEXCOORD0.x;
  float _2 = TEXCOORD0.y;

  float3 fullResMap = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD0.xy).rgb;
  float _11 = fullResMap.r;
  float _12 = fullResMap.g;
  float _13 = fullResMap.b;

  float4 anisotropicSampler = g_textures2D[RenderMapAnisoSampler].Sample(g_samplers[RenderMapAnisoSamplerSS], TEXCOORD0.xy);
  float _23 = anisotropicSampler.r;
  float _24 = anisotropicSampler.g;
  float _25 = anisotropicSampler.b;
  float _27 = _23 * _23;
  float _28 = _24 * _24;
  float _29 = _25 * _25;
  float _31 = IntensityBloom;
  float _32 = _27 * _31;
  float _33 = _28 * _31;
  float _34 = _29 * _31;
  float _35 = saturate(anisotropicSampler.w);

  float3 DoFMap = g_textures2D[RenderMapBilinearSampler].Sample(g_samplers[RenderMapBilinearSamplerSS], TEXCOORD0.xy).rgb;
  float _45 = DoFMap.r;
  float _46 = DoFMap.g;
  float _47 = DoFMap.b;

  float adaptedLuminance = g_textures2D[AdaptedLuminanceMapSampler].Sample(g_samplers[AdaptedLuminanceMapSamplerSS], float2(0, 0)).x;
  float _57 = adaptedLuminance;
  float _59 = HigherLimitAdaption;
  float _60 = LowerLimitAdaption;
  float _61 = max(_57, _60);
  float _62 = min(_61, _59);
  float clampedAdaptedLuminance = _62;
  float _63 = _45 - _11;
  float _64 = _46 - _12;
  float _65 = _47 - _13;
  float _66 = _63 * _35;
  float _67 = _64 * _35;
  float _68 = _65 * _35;
  float _69 = _66 + _11;
  float _70 = _67 + _12;
  float _71 = _68 + _13;

  // float _73 = BrightPassValues.z;
  // float _74 = _62 + 0.001;
  // float _75 = _73 / _74;
  float scale = BrightPassValues.z / (clampedAdaptedLuminance + 0.001);
  float _76 = scale * _69;
  float _77 = scale * _70;
  float _78 = scale * _71;
  float3 color_scaled = float3(_76, _77, _78);

  float _80 = White;
  float _81 = _76 / _80;
  float _82 = _77 / _80;
  float _83 = _78 / _80;
  float _84 = _81 + 1.00000;
  float _85 = _82 + 1.00000;
  float _86 = _83 + 1.00000;
  float _87 = _84 * _76;
  float _88 = _85 * _77;
  float _89 = _86 * _78;
  float _90 = _76 + 1.00000;
  float _91 = _77 + 1.00000;
  float _92 = _78 + 1.00000;
  float _93 = _87 / _90;
  float _94 = _88 / _91;
  float _95 = _89 / _92;

#if 1  // blended reinhard with untonemapped
  float3 vanillaColor = float3(_93, _94, _95);

  float midGrayScale = RDR1ReinhardMidgrayScale(White);
  float3 untonemapped_scaled = color_scaled * midGrayScale;

  float3 blendedColor = (RENODX_TONE_MAP_TYPE != 0.f) ? lerp(vanillaColor, untonemapped_scaled, saturate(vanillaColor / 0.18f)) : vanillaColor;

  _93 = blendedColor.r;
  _94 = blendedColor.g;
  _95 = blendedColor.b;
#endif

  // Apply Bloom
  float _96 = _93 + _32;
  float _97 = _94 + _33;
  float _98 = _95 + _34;

  float _100 = ConstAdd.x;
  float _101 = ConstAdd.y;
  float _102 = ConstAdd.z;
  float _103 = _96 + _100;
  float _104 = _97 + _101;
  float _105 = _98 + _102;
  float _107 = ColorCorrect.x;
  float _108 = ColorCorrect.y;
  float _109 = ColorCorrect.z;
  float _110 = _107 * 2.00000;
  float _111 = _110 * _103;
  float _112 = _108 * 2.00000;
  float _113 = _112 * _104;
  float _114 = _109 * 2.00000;
  float _115 = _114 * _105;
  float _116 = (_111);
  float _117 = (_113);
  float _118 = (_115);

  float3 colorCorrected = float3(_111, _113, _115);

  // Apply Desaturation - lerp to luminance
  float blackAndWhite = dot(colorCorrected, float3(LUMINANCE.x, LUMINANCE.y, LUMINANCE.z));
  float3 desaturatedColorHDR = lerp(blackAndWhite, colorCorrected, deSat);

  // Apply Contrast - done in SDR
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
