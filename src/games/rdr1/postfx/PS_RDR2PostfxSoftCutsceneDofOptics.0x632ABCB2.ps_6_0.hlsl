// shader hash: 4c769258f830157a2deb067e0c536bf0

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

// PSRDR2PostfxSoftCutsceneDofOptics()
float4 main(float4 SV_Position: SV_POSITION,
            float4 TEXCOORD0: TEXCOORD0,
            float4 TEXCOORD1: TEXCOORD1,
            float4 TEXCOORD2: TEXCOORD2)
    : SV_Target {
  float _1 = TEXCOORD2.x;
  float _2 = TEXCOORD2.y;
  float _3 = TEXCOORD2.z;
  float _4 = TEXCOORD2.w;
  float _5 = TEXCOORD0.x;
  float _6 = TEXCOORD0.y;

  float _16 = g_textures2D[DepthMapSampler].Sample(g_samplers[DepthMapSamplerSS], TEXCOORD0.xy).x;

  float _18 = NearFarClipPlaneQ.x;
  float _19 = NearFarClipPlaneQ.z;
  float _20 = _18 * _19;
  float _21 = -0.000000 - _20;
  float _22 = _16 - _19;
  float _23 = _21 / _22;
  //   _dx.types.CBufRet.i32 _24 = { _0.ParticleHeatShimmerSeed, _0.FullResMapSampler, _0.FullResMapSamplerSS, _0.RenderMapSampler };  //  cbuffer = $Globals, byte_offset = 400
  int _25 = FullResMapSampler;
  int _26 = FullResMapSamplerSS;
  int _27 = FullResMapSampler;
  int _29 = FullResMapSamplerSS;
  float3 fullResMap = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD0.xy).rgb;
  float _32 = fullResMap.r;
  float _33 = fullResMap.g;
  float _34 = fullResMap.b;

  float4 anisotropicSampler = g_textures2D[RenderMapAnisoSampler].Sample(g_samplers[RenderMapAnisoSamplerSS], TEXCOORD0.xy);
  float _44 = anisotropicSampler.x;
  float _45 = anisotropicSampler.y;
  float _46 = anisotropicSampler.z;
  float _47 = anisotropicSampler.w;
  float _48 = _44 * _44;
  float _49 = _45 * _45;
  float _50 = _46 * _46;

  float _52 = IntensityBloom;
  float _53 = _48 * _52;
  float _54 = _49 * _52;
  float _55 = _50 * _52;
  float _56 = saturate(_47);

  float3 _65 = g_textures2D[RenderMapBilinearSampler].Sample(g_samplers[RenderMapBilinearSamplerSS], TEXCOORD0.xy).rgb;
  float _66 = _65.r;
  float _67 = _65.g;
  float _68 = _65.b;
  float _70 = DofParams.y;
  float _71 = DofParams.x;
  float _72 = DofParams.z;
  float _73 = DofParams.w;
  float _74 = _70 - _23;
  float _75 = abs(_74);
  float _76 = _75 * _71;
  float _77 = saturate(_76);
  bool _78 = (_23 > _72);
  float _79 = _78 ? 0.000000 : _77;
  float _80 = _79 - _73;
  float _81 = 1.00000 - _73;
  float _82 = _80 / _81;
  float _83 = saturate(_82);

  float _85 = SoftDofStrength;
  float _86 = _85 * _83;
  float _87 = max(_86, _56);
  float _88 = _5 + -0.500000;
  float _89 = _6 + -0.500000;
  float _90 = dot(float2(_88, _89), float2(_88, _89));
  float _91 = 1.00000 - _90;
  float _92 = _91 * _91;

  float _94 = DisableVignette;
  float _95 = _92 + _94;
  float _96 = saturate(_95);
  float _97 = 1.00000 - _96;
  float _98 = max(_87, _97);

  float _108 = g_textures2D[AdaptedLuminanceMapSampler].Sample(g_samplers[AdaptedLuminanceMapSamplerSS], float2(0, 0)).x;
  //   _dx.types.CBufRet.f32 _109 = { _0.Gamma, _0.LowerLimitAdaption, _0.HigherLimitAdaption, _0.distortionFreq };  //  cbuffer = $Globals, byte_offset = 320
  float _110 = HigherLimitAdaption;
  float _111 = LowerLimitAdaption;
  float _112 = max(_108, _111);
  float _113 = min(_112, _110);
  float clampedAdaptedLuminance = _113;
  float _114 = _66 - _32;
  float _115 = _67 - _33;
  float _116 = _68 - _34;
  float _117 = _98 * _114;
  float _118 = _98 * _115;
  float _119 = _98 * _116;
  float _120 = _117 + _32;
  float _121 = _118 + _33;
  float _122 = _119 + _34;

  float4 _130 = g_textures2D[GlowSampler].Sample(g_samplers[GlowSamplerSS], TEXCOORD2.xy);
  float _131 = _130.r;
  float _132 = _130.g;
  float _133 = _130.b;
  float _134 = _130.a;
  //   _dx.types.CBufRet.i32 _135 = { _0.GlowSampler, _0.GlowSamplerSS, _0.GlowSampler2, _0.GlowSampler2SS };  //  cbuffer = $Globals, byte_offset = 1040
  int _136 = GlowSampler2;
  int _137 = GlowSampler2SS;
  int _138 = GlowSampler2;
  int _140 = GlowSampler2SS;
  float4 _142 = g_textures2D[GlowSampler2].Sample(g_samplers[GlowSampler2SS], TEXCOORD2.zw);
  float _143 = _142.r;
  float _144 = _142.g;
  float _145 = _142.b;
  float _146 = _142.a;
  float _148 = GlowColor2.x;
  float _149 = GlowColor2.y;
  float _150 = GlowColor2.z;
  float _152 = GlowColor.x;
  float _153 = GlowColor.y;
  float _154 = GlowColor.z;
  float _155 = renodx::color::luma::from::BT601(float3(_120, _121, _122));
  float _156 = 1.00000 - _155;
  float _158 = AdditiveReducer;
  float _159 = AdditiveReducer2;
  float _160 = abs(_156);
  float _161 = log2(_160);
  float _162 = _161 * _158;
  float _163 = _161 * _159;
  float _164 = exp2(_162);
  float _165 = exp2(_163);
  float _166 = _134 * _131;
  float _167 = _166 * _152;
  float _168 = _167 * _164;
  float _169 = _134 * _132;
  float _170 = _169 * _153;
  float _171 = _170 * _164;
  float _172 = _134 * _133;
  float _173 = _172 * _154;
  float _174 = _173 * _164;
  float _175 = _168 + _120;
  float _176 = _171 + _121;
  float _177 = _174 + _122;
  float _178 = _146 * _143;
  float _179 = _178 * _148;
  float _180 = _179 * _165;
  float _181 = _146 * _144;
  float _182 = _181 * _149;
  float _183 = _182 * _165;
  float _184 = _146 * _145;
  float _185 = _184 * _150;
  float _186 = _185 * _165;
  float _187 = _175 + _180;
  float _188 = _176 + _183;
  float _189 = _177 + _186;

  // apply adaptation
  // float _191 = BrightPassValues.z;
  // float _192 = _113 + 0.001;
  // float _193 = _191 / _192;
  float scale = BrightPassValues.z / (clampedAdaptedLuminance + 0.001);
  float _194 = _187 * scale;
  float _195 = scale * _188;
  float _196 = scale * _189;
  float3 color_scaled = float3(_194, _195, _196);

  float _198 = White;
  float _199 = _194 / _198;
  float _200 = _195 / _198;
  float _201 = _196 / _198;
  float _202 = _199 + 1.00000;
  float _203 = _200 + 1.00000;
  float _204 = _201 + 1.00000;
  float _205 = _202 * _194;
  float _206 = _203 * _195;
  float _207 = _204 * _196;
  float _208 = _194 + 1.00000;
  float _209 = _195 + 1.00000;
  float _210 = _196 + 1.00000;
  float _211 = _205 / _208;
  float _212 = _206 / _209;
  float _213 = _207 / _210;

#if 1  // blended reinhard with untonemapped
  float3 vanillaColor = float3(_211, _212, _213);

  float midGrayScale = RDR1ReinhardMidgrayScale(White);
  float3 untonemapped_scaled = color_scaled * midGrayScale;

  float3 blendedColor = (RENODX_TONE_MAP_TYPE != 0.f) ? lerp(vanillaColor, untonemapped_scaled, saturate(vanillaColor / 0.18f)) : vanillaColor;

  _211 = blendedColor.r;
  _212 = blendedColor.g;
  _213 = blendedColor.b;
#endif

  // Apply Bloom
  float _214 = _211 + _53;
  float _215 = _212 + _54;
  float _216 = _213 + _55;

  float _217 = DisableVignette;
  float _218 = 1.00000 - _217;
  float _219 = _218 * 0.150000;
  float _220 = _219 + 1.00000;
  float _221 = _96 * 0.500000;
  float _222 = _221 + 0.500000;
  float _223 = _220 * _222;

  float _225 = ConstAdd.x;
  float _226 = ConstAdd.y;
  float _227 = ConstAdd.z;
  float _228 = _214 + _225;
  float _229 = _215 + _226;
  float _230 = _216 + _227;
  //   _dx.types.CBufRet.f32 _231 = { _0.ColorCorrect.x, _0.ColorCorrect.y, _0.ColorCorrect.z, _0.ColorCorrect.w };  //  cbuffer = $Globals, byte_offset = 176
  float _232 = ColorCorrect.x;
  float _233 = ColorCorrect.y;
  float _234 = ColorCorrect.z;
  float _235 = _232 * 2.00000;
  float _236 = _235 * _228;
  float _237 = _233 * 2.00000;
  float _238 = _237 * _229;
  float _239 = _234 * 2.00000;
  float _240 = _239 * _230;
  float _241 = (_236);
  float _242 = (_238);
  float _243 = (_240);
  float3 colorCorrected = float3(_236, _238, _240);

  // Apply Desaturation - lerp to luminance
  // float _248 = dot(float3(_241, _242, _243), LUMINANCE.xyz);
  // float _249 = deSat;
  // float _250 = _241 - _248;
  // float _251 = _242 - _248;
  // float _252 = _243 - _248;
  // float _253 = _249 * _250;
  // float _254 = _249 * _251;
  // float _255 = _249 * _252;
  // float _256 = _253 + _248;
  // float _257 = _254 + _248;
  // float _258 = _255 + _248;
  float blackAndWhite = dot(colorCorrected, LUMINANCE.xyz);
  float3 desaturatedColorHDR = lerp(blackAndWhite, colorCorrected, deSat);

  // float _260 = Contrast;
  // float _261 = _256 + -1.00000;
  // float _262 = _257 + -1.00000;
  // float _263 = _258 + -1.00000;
  // float _264 = _256 + -0.500000;
  // float _265 = _257 + -0.500000;
  // float _266 = _258 + -0.500000;
  // float _267 = _256 * _260;
  // float _268 = _267 * _261;
  // float _269 = _268 * _264;
  // float _270 = _257 * _260;
  // float _271 = _270 * _262;
  // float _272 = _271 * _265;
  // float _273 = _258 * _260;
  // float _274 = _273 * _263;
  // float _275 = _274 * _266;
  // float _276 = _256 - _269;
  // float _277 = _257 - _272;
  // float _278 = _258 - _275;
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
