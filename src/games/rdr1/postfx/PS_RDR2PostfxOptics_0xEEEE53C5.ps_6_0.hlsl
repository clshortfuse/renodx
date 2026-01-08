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
  float _1 = TEXCOORD2.x;
  float _2 = TEXCOORD2.y;
  float _3 = TEXCOORD2.z;
  float _4 = TEXCOORD2.w;
  float _5 = TEXCOORD0.x;
  float _6 = TEXCOORD0.y;

  float _16 = g_textures2D[DepthMapSampler].Sample(g_samplers[DepthMapSamplerSS], TEXCOORD0.xy).x;  // fix

  float _18 = NearFarClipPlaneQ.x;
  float _19 = NearFarClipPlaneQ.z;
  float _20 = _18 * _19;
  float _21 = -_20;
  float _22 = _16 - _19;
  float _23 = _21 / _22;

  float4 fullResMap = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD0.xy);  // fix

  float _32 = fullResMap.x;
  float _33 = fullResMap.y;
  float _34 = fullResMap.z;

  float4 _42 = g_textures2D[RenderMapAnisoSampler].Sample(g_samplers[RenderMapAnisoSamplerSS], TEXCOORD0.xy);  // fix
  float _43 = _42.x;
  float _44 = _42.y;
  float _45 = _42.z;
  float _46 = _42.w;

  float _47 = _43 * _43;
  float _48 = _44 * _44;
  float _49 = _45 * _45;
  float _51 = IntensityBloom;
  float _52 = _47 * _51;
  float _53 = _48 * _51;
  float _54 = _49 * _51;
  float _55 = saturate(_46);

  float4 _64 = g_textures2D[RenderMapBilinearSampler].Sample(g_samplers[RenderMapBilinearSamplerSS], TEXCOORD0.xy);  // fix
  float _65 = _64.x;
  float _66 = _64.y;
  float _67 = _64.z;

  float _69 = DofParams.x;
  float _70 = DofParams.y;
  float _71 = _23 - _70;
  float _72 = _71 * _69;
  float _73 = saturate(_72);
  bool _75 = (_23 < DofParams.z);
  float _76 = _75 ? 1.0 : 0.0;
  float _77 = max(_76 * _73, _55);

  float _78 = max(_77, _55);

  float AdaptedLuminance = g_textures2D[AdaptedLuminanceMapSampler].Sample(g_samplers[AdaptedLuminanceMapSamplerSS], float2(0, 0)).x;
  float clampedAdaptedLuminance = clamp(AdaptedLuminance, LowerLimitAdaption, HigherLimitAdaption);

  float _94 = _65 - _32;
  float _95 = _66 - _33;
  float _96 = _67 - _34;

  float _97 = _78 * _94;
  float _98 = _78 * _95;
  float _99 = _78 * _96;
  float _100 = _97 + _32;
  float _101 = _98 + _33;
  float _102 = _99 + _34;

  float4 _110 = g_textures2D[GlowSampler].Sample(g_samplers[GlowSamplerSS], TEXCOORD2.xy);  // fix
  float _111 = _110.x;
  float _112 = _110.y;
  float _113 = _110.z;
  float _114 = _110.w;

  float4 _122 = g_textures2D[GlowSampler2].Sample(g_samplers[GlowSampler2SS], TEXCOORD2.zw);  // fix
  float _123 = _122.x;
  float _124 = _122.y;
  float _125 = _122.z;
  float _126 = _122.w;
  float _136 = 1.010 - renodx::color::luma::from::BT601(float3(_100, _101, _102));
  float _141 = log2(abs(_136));
  float _142 = _141 * AdditiveReducer;
  float _143 = _141 * AdditiveReducer2;
  float _144 = exp2(_142);
  float _145 = exp2(_143);

  float _146 = _114 * _111;
  float _147 = _146 * GlowColor.x;
  float _148 = _147 * _144;
  float _149 = _114 * _112;
  float _150 = _149 * GlowColor.y;
  float _151 = _150 * _144;
  float _152 = _114 * _113;
  float _153 = _152 * GlowColor.z;
  float _154 = _153 * _144;

  float _155 = _148 + _100;
  float _156 = _151 + _101;
  float _157 = _154 + _102;

  float _158 = _126 * _123;
  float _159 = _158 * GlowColor2.x;
  float _160 = _159 * _145;
  float _161 = _126 * _124;
  float _162 = _161 * GlowColor2.y;
  float _163 = _162 * _145;
  float _164 = _126 * _125;
  float _165 = _164 * GlowColor2.z;
  float _166 = _165 * _145;

  float _167 = _155 + _160;
  float _168 = _156 + _163;
  float _169 = _157 + _166;

  // float _171 = BrightPassValues.z;
  // float _172 = clampedAdaptedLuminance + 0.001;
  // float _173 = _171 / _172;
  float scale = BrightPassValues.z / (clampedAdaptedLuminance + 0.001);

  float _174 = _167 * scale;
  float _175 = _168 * scale;
  float _176 = _169 * scale;

  float3 color_scaled = float3(_174, _175, _176);

  float _178 = White;
  float _179 = _174 / _178;
  float _180 = _175 / _178;
  float _181 = _176 / _178;

  float _182 = _179 + 1.000;
  float _183 = _180 + 1.000;
  float _184 = _181 + 1.000;

  float _185 = _182 * _174;
  float _186 = _183 * _175;
  float _187 = _184 * _176;

  float _188 = _174 + 1.000;
  float _189 = _175 + 1.000;
  float _190 = _176 + 1.000;

  float _191 = _185 / _188;
  float _192 = _186 / _189;
  float _193 = _187 / _190;

#if 1  // blended reinhard with untonemapped
  float3 vanillaColor = float3(_191, _192, _193);

  float midGrayScale = RDR1ReinhardMidgrayScale(White);
  float3 untonemapped_scaled = color_scaled * midGrayScale;

  float3 blendedColor = (RENODX_TONE_MAP_TYPE != 0.f) ? lerp(vanillaColor, untonemapped_scaled, saturate(vanillaColor / 0.18f)) : vanillaColor;

  _191 = blendedColor.r;
  _192 = blendedColor.g;
  _193 = blendedColor.b;
#endif

  // apply bloom
  float _194 = _191 + _52;
  float _195 = _192 + _53;
  float _196 = _193 + _54;

  float _198 = ConstAdd.x;
  float _199 = ConstAdd.y;
  float _200 = ConstAdd.z;

  float _201 = _194 + _198;
  float _202 = _195 + _199;
  float _203 = _196 + _200;

  float _205 = ColorCorrect.x * 2.000;
  float _206 = ColorCorrect.y * 2.000;
  float _207 = ColorCorrect.z * 2.000;

  float _209 = _205 * _201;
  float _210 = _206 * _202;
  float _211 = _207 * _203;

  float3 colorCorrected = float3(_209, _210, _211);

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

  float3 gammaEncodedColor = renodx::color::gamma::Encode(max(0, outputColor), 2.2f);

  return float4(gammaEncodedColor, 1.0);
}
