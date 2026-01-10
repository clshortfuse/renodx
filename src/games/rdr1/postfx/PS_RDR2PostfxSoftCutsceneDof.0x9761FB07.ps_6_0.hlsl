// shader hash : e7d616a26f49bfe3b3f320ee074c357e

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

// PSRDR2PostfxSoftCutsceneDof()
float4 main(float4 SV_Position: SV_POSITION,
            float4 TEXCOORD0: TEXCOORD0,
            float4 TEXCOORD1: TEXCOORD1,
            float4 TEXCOORD2: TEXCOORD2)
    : SV_Target {
  float _1 = TEXCOORD0.x;
  float _2 = TEXCOORD0.y;

  float _12 = g_textures2D[DepthMapSampler].Sample(g_samplers[DepthMapSamplerSS], TEXCOORD0.xy).x;
  float _14 = NearFarClipPlaneQ.x;
  float _15 = NearFarClipPlaneQ.z;
  float _16 = _14 * _15;
  float _17 = -0.000000 - _16;
  float _18 = _12 - _15;
  float _19 = _17 / _18;

  float3 fullResMap = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD0.xy).rgb;
  float _28 = fullResMap.r;
  float _29 = fullResMap.g;
  float _30 = fullResMap.b;

  float4 anisotropicSampler = g_textures2D[RenderMapAnisoSampler].Sample(g_samplers[RenderMapAnisoSamplerSS], TEXCOORD0.xy);
  float _40 = anisotropicSampler.x;
  float _41 = anisotropicSampler.y;
  float _42 = anisotropicSampler.z;
  float _43 = anisotropicSampler.w;
  float _44 = _40 * _40;
  float _45 = _41 * _41;
  float _46 = _42 * _42;
  // _dx.types.CBufRet.f32 _47 = { _0.White, _0.IntensityBloom, <padding>, <padding> };  //  cbuffer = $Globals, byte_offset = 112
  float _48 = IntensityBloom;
  float _49 = _44 * _48;
  float _50 = _45 * _48;
  float _51 = _46 * _48;
  float _52 = saturate(_43);
  // _dx.types.CBufRet.i32 _53 = { _0.RenderMapSamplerSS, _0.RenderMapPointSampler, _0.RenderMapPointSamplerSS, _0.RenderMapBilinearSampler };  //  cbuffer = $Globals, byte_offset = 416
  int _54 = RenderMapBilinearSampler;
  // _dx.types.CBufRet.i32 _55 = { _0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler };  //  cbuffer = $Globals, byte_offset = 432
  int _56 = RenderMapBilinearSamplerSS;
  int _57 = RenderMapBilinearSampler;
  // InitialiseHandle(g_textures2D[_57]);
  int _59 = RenderMapBilinearSamplerSS;
  // InitialiseHandle(g_samplers[_59]);
  float3 _61 = g_textures2D[RenderMapBilinearSampler].Sample(g_samplers[RenderMapBilinearSamplerSS], TEXCOORD0.xy).rgb;
  float _62 = _61.r;
  float _63 = _61.g;
  float _64 = _61.b;
  // _dx.types.CBufRet.f32 _65 = { _0.DofParams.x, _0.DofParams.y, _0.DofParams.z, _0.DofParams.w };  //  cbuffer = $Globals, byte_offset = 208
  float _66 = DofParams.y;
  float _67 = DofParams.x;
  float _68 = DofParams.z;
  float _69 = DofParams.w;
  float _70 = _66 - _19;
  float _71 = abs(_70);
  float _72 = _71 * _67;
  float _73 = saturate(_72);
  bool _74 = (_19 > _68);
  float _75 = _74 ? 0.000000 : _73;
  float _76 = _75 - _69;
  float _77 = 1.00000 - _69;
  float _78 = _76 / _77;
  float _79 = saturate(_78);
  // _dx.types.CBufRet.f32 _80 = { _0.SoftDofFalloffPower, _0.SoftDofStrength, _0.DofBackendPull, _0.TotalTime };  //  cbuffer = $Globals, byte_offset = 976
  float _81 = SoftDofStrength;
  float _82 = _81 * _79;
  float _83 = max(_82, _52);
  float _84 = _1 + -0.500000;
  float _85 = _2 + -0.500000;
  float _86 = dot(float2(_84, _85), float2(_84, _85));
  float _87 = 1.00000 - _86;
  float _88 = _87 * _87;
  // _dx.types.CBufRet.f32 _89 = { _0.DisableVignette, _0.AdditiveReducer, _0.AdditiveReducer2, <padding> };  //  cbuffer = $Globals, byte_offset = 1056
  float _90 = DisableVignette;
  float _91 = _88 + _90;
  float _92 = saturate(_91);
  float _93 = 1.00000 - _92;
  float _94 = max(_83, _93);

  float _104 = g_textures2D[AdaptedLuminanceMapSampler].Sample(g_samplers[AdaptedLuminanceMapSamplerSS], float2(0, 0)).x;
  // _dx.types.CBufRet.f32 _105 = { _0.Gamma, _0.LowerLimitAdaption, _0.HigherLimitAdaption, _0.distortionFreq };  //  cbuffer = $Globals, byte_offset = 320
  float _106 = HigherLimitAdaption;
  float _107 = LowerLimitAdaption;
  float _108 = max(_104, _107);
  float _109 = min(_108, _106);
  float clampedAdaptedLuminance = _109;
  float _110 = _62 - _28;
  float _111 = _63 - _29;
  float _112 = _64 - _30;
  float _113 = _94 * _110;
  float _114 = _94 * _111;
  float _115 = _94 * _112;
  float _116 = _113 + _28;
  float _117 = _114 + _29;
  float _118 = _115 + _30;

  // apply adaptation
  // float _120 = BrightPassValues.z;
  // float _121 = _109 + 0.001;
  // float _122 = _120 / _121;
  float scale = BrightPassValues.z / (clampedAdaptedLuminance + 0.001);
  float _123 = scale * _116;
  float _124 = scale * _117;
  float _125 = scale * _118;
  float3 color_scaled = float3(_123, _124, _125);

  float _127 = White;
  float _128 = _123 / _127;
  float _129 = _124 / _127;
  float _130 = _125 / _127;
  float _131 = _128 + 1.00000;
  float _132 = _129 + 1.00000;
  float _133 = _130 + 1.00000;
  float _134 = _131 * _123;
  float _135 = _132 * _124;
  float _136 = _133 * _125;
  float _137 = _123 + 1.00000;
  float _138 = _124 + 1.00000;
  float _139 = _125 + 1.00000;
  float _140 = _134 / _137;
  float _141 = _135 / _138;
  float _142 = _136 / _139;

#if 1  // blended reinhard with untonemapped
  float3 vanillaColor = float3(_140, _141, _142);

  float midGrayScale = RDR1ReinhardMidgrayScale(White);
  float3 untonemapped_scaled = color_scaled * midGrayScale;

  float3 blendedColor = (RENODX_TONE_MAP_TYPE != 0.f) ? lerp(vanillaColor, untonemapped_scaled, saturate(vanillaColor / 0.18f)) : vanillaColor;

  _140 = blendedColor.r;
  _141 = blendedColor.g;
  _142 = blendedColor.b;
#endif

  // Apply Bloom
  float _143 = _140 + _49;
  float _144 = _141 + _50;
  float _145 = _142 + _51;

  float _147 = DisableVignette;
  float _148 = 1.00000 - _147;
  float _149 = _148 * 0.150000;
  float _150 = _149 + 1.00000;
  float _151 = _92 * 0.500000;
  float _152 = _151 + 0.500000;
  float _153 = _150 * _152;

  float _155 = ConstAdd.x;
  float _156 = ConstAdd.y;
  float _157 = ConstAdd.z;
  float _158 = _143 + _155;
  float _159 = _144 + _156;
  float _160 = _145 + _157;

  // Apply Color Correction
  float _162 = ColorCorrect.x;
  float _163 = ColorCorrect.y;
  float _164 = ColorCorrect.z;
  float _165 = _162 * 2.00000;
  float _166 = _165 * _158;
  float _167 = _163 * 2.00000;
  float _168 = _167 * _159;
  float _169 = _164 * 2.00000;
  float _170 = _169 * _160;
  float3 colorCorrected = float3(_166, _168, _170);

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
