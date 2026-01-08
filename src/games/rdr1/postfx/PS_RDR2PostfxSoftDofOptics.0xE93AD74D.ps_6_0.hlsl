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

  float3 fullResMap = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD0.xy).rgb;
  float _15 = fullResMap.r;
  float _16 = fullResMap.g;
  float _17 = fullResMap.b;

  int _22 = RenderMapAnisoSampler;
  int _24 = RenderMapAnisoSamplerSS;
  float4 _26 = g_textures2D[RenderMapAnisoSampler].Sample(g_samplers[RenderMapAnisoSamplerSS], TEXCOORD0.xy);
  float _27 = _26.x;
  float _28 = _26.y;
  float _29 = _26.z;
  float _30 = _26.w;
  float _31 = _27 * _27;
  float _32 = _28 * _28;
  float _33 = _29 * _29;

  float _35 = IntensityBloom;
  float _36 = _31 * _35;
  float _37 = _32 * _35;
  float _38 = _33 * _35;
  float _39 = saturate(_30);

  float3 _48 = g_textures2D[RenderMapBilinearSampler].Sample(g_samplers[RenderMapBilinearSamplerSS], TEXCOORD0.xy).rgb;
  float _49 = _48.r;
  float _50 = _48.g;
  float _51 = _48.b;

  float _61 = g_textures2D[AdaptedLuminanceMapSampler].Sample(g_samplers[AdaptedLuminanceMapSamplerSS], float2(0, 0)).x;
  float _63 = HigherLimitAdaption;
  float _64 = LowerLimitAdaption;
  float _65 = max(_61, _64);
  float _66 = min(_65, _63);
  float clampedAdaptedLuminance = _66;
  float _67 = _49 - _15;
  float _68 = _50 - _16;
  float _69 = _51 - _17;
  float _70 = _67 * _39;
  float _71 = _68 * _39;
  float _72 = _69 * _39;
  float _73 = _70 + _15;
  float _74 = _71 + _16;
  float _75 = _72 + _17;

  float4 _83 = g_textures2D[GlowSampler].Sample(g_samplers[GlowSamplerSS], TEXCOORD2.xy);
  float _84 = _83.x;
  float _85 = _83.y;
  float _86 = _83.z;
  float _87 = _83.w;

  float4 _95 = g_textures2D[GlowSampler2].Sample(g_samplers[GlowSampler2SS], TEXCOORD2.zw);
  float _96 = _95.x;
  float _97 = _95.y;
  float _98 = _95.z;
  float _99 = _95.w;
  float _101 = GlowColor2.x;
  float _102 = GlowColor2.y;
  float _103 = GlowColor2.z;
  float _105 = GlowColor.x;
  float _106 = GlowColor.y;
  float _107 = GlowColor.z;
  float _108 = renodx::color::luma::from::BT601(float3(_73, _74, _75));  // float _108 = dot( { _73, _74, _75 }, { 0.299000, 0.587000, 0.114000 });
  float _109 = 1.00000 - _108;

  float _111 = AdditiveReducer;
  float _112 = AdditiveReducer2;
  float _113 = abs(_109);
  float _114 = log2(_113);
  float _115 = _114 * _111;
  float _116 = _114 * _112;
  float _117 = exp2(_115);
  float _118 = exp2(_116);
  float _119 = _87 * _84;
  float _120 = _119 * _105;
  float _121 = _120 * _117;
  float _122 = _87 * _85;
  float _123 = _122 * _106;
  float _124 = _123 * _117;
  float _125 = _87 * _86;
  float _126 = _125 * _107;
  float _127 = _126 * _117;
  float _128 = _121 + _73;
  float _129 = _124 + _74;
  float _130 = _127 + _75;
  float _131 = _99 * _96;
  float _132 = _131 * _101;
  float _133 = _132 * _118;
  float _134 = _99 * _97;
  float _135 = _134 * _102;
  float _136 = _135 * _118;
  float _137 = _99 * _98;
  float _138 = _137 * _103;
  float _139 = _138 * _118;
  float _140 = _128 + _133;
  float _141 = _129 + _136;
  float _142 = _130 + _139;

  // float _144 = BrightPassValues.z;
  // float _145 = _66 + 0.001;
  // float _146 = _144 / _145;
  float scale = BrightPassValues.z / (clampedAdaptedLuminance + 0.001);
  float _147 = _140 * scale;
  float _148 = scale * _141;
  float _149 = scale * _142;
  float3 color_scaled = float3(_147, _148, _149);

  float _151 = White;
  float _152 = _147 / _151;
  float _153 = _148 / _151;
  float _154 = _149 / _151;
  float _155 = _152 + 1.00000;
  float _156 = _153 + 1.00000;
  float _157 = _154 + 1.00000;
  float _158 = _155 * _147;
  float _159 = _156 * _148;
  float _160 = _157 * _149;
  float _161 = _147 + 1.00000;
  float _162 = _148 + 1.00000;
  float _163 = _149 + 1.00000;
  float _164 = _158 / _161;
  float _165 = _159 / _162;
  float _166 = _160 / _163;

#if 1  // blended reinhard with untonemapped
  float3 vanillaColor = float3(_164, _165, _166);

  float midGrayScale = RDR1ReinhardMidgrayScale(White);
  float3 untonemapped_scaled = color_scaled * midGrayScale;

  float3 blendedColor = (RENODX_TONE_MAP_TYPE != 0.f) ? lerp(vanillaColor, untonemapped_scaled, saturate(vanillaColor / 0.18f)) : vanillaColor;

  _164 = blendedColor.r;
  _165 = blendedColor.g;
  _166 = blendedColor.b;
#endif

  // Apply Bloom
  float _167 = _164 + _36;
  float _168 = _165 + _37;
  float _169 = _166 + _38;

  // Apply Color Correction
  float _171 = ConstAdd.x;
  float _172 = ConstAdd.y;
  float _173 = ConstAdd.z;
  float _174 = _167 + _171;
  float _175 = _168 + _172;
  float _176 = _169 + _173;
  float _178 = ColorCorrect.x;
  float _179 = ColorCorrect.y;
  float _180 = ColorCorrect.z;
  float _181 = _178 * 2.00000;
  float _182 = _181 * _174;
  float _183 = _179 * 2.00000;
  float _184 = _183 * _175;
  float _185 = _180 * 2.00000;
  float _186 = _185 * _176;
  float3 colorCorrected = float3(_182, _184, _186);

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
