#include "./shared.h"

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
  float4 SV_Target;

  float _1 = TEXCOORD0.x;
  float _2 = TEXCOORD0.y;


  // Depth Map
  int _4 = DepthMapSampler;
  int _6 = DepthMapSamplerSS;
  int _7 = _4 + 0;
  int _9 = _6 + 0;
  float4 _11 = g_textures2D[_7].Sample(g_samplers[_9], float2(_1, _2));  //  // _dx.types.ResRet.f32 _11 = g_textures2D[_7].Sample(g_samplers[_9], _1, _2, Offset = { 0, 0 });
  float _12 = _11.x;

  // Near Far Clip
  float _14 = NearFarClipPlaneQ.x;
  float _15 = NearFarClipPlaneQ.z;
  float _16 = _14 * _15;
  float _17 = -0.000000 - _16;
  float _18 = _12 - _15;
  float _19 = _17 / _18;

  
  // Full Res Map
  int _21 = FullResMapSampler;
  int _22 = FullResMapSamplerSS;
  int _23 = _21 + 0;
  int _25 = _22 + 0;
  float4 _27 = g_textures2D[_23].Sample(g_samplers[_25], float2(_1, _2));  // _dx.types.ResRet.f32 _27 = g_textures2D[_23].Sample(g_samplers[_25], _1, _2, Offset = { 0, 0 });
  float _28 = _27.r;
  float _29 = _27.g;
  float _30 = _27.b;

  // Anisotropic Sampler
  int _32 = RenderMapAnisoSampler;
  int _33 = RenderMapAnisoSamplerSS;
  int _34 = _32 + 0;
  int _36 = _33 + 0;
  float4 _38 = g_textures2D[_34].Sample(g_samplers[_36], float2(_1, _2));  // _dx.types.ResRet.f32 _38 = g_textures2D[_34].Sample(g_samplers[_36], _1, _2, Offset = { 0, 0 });
  float _39 = _38.x;
  float _40 = _38.y;
  float _41 = _38.z;
  float _42 = _38.w;
  float _43 = _39 * _39;
  float _44 = _40 * _40;
  float _45 = _41 * _41;

  // Bloom
  float _47 = IntensityBloom;
  float _48 = _43 * _47;
  float _49 = _44 * _47;
  float _50 = _45 * _47;
  float _51 = saturate(_42);

  // Bilinear Sampler / DoF
  int _53 = RenderMapBilinearSampler;
  int _55 = RenderMapBilinearSamplerSS;
  int _56 = _53 + 0;
  int _58 = _55 + 0;
  float4 _60 = g_textures2D[_56].Sample(g_samplers[_58], float2(_1, _2));  // _dx.types.ResRet.f32 _60 = g_textures2D[_56].Sample(g_samplers[_58], _1, _2, Offset = { 0, 0 });
  float _61 = _60.x;
  float _62 = _60.y;
  float _63 = _60.z;
  float _65 = DofParams.x;
  float _66 = DofParams.y;
  float _67 = _19 - _66;
  float _68 = _67 * _65;
  float _69 = saturate(_68);
  float _70 = DofParams.z;
  bool _71 = (_19 < _70);
  float _72 = (float)(_71);  // unsigned
  float _73 = _72 * _69;
  float _74 = max(_73, _51);

  // Eye Adaptation
  int _76 = AdaptedLuminanceMapSampler;
  int _78 = AdaptedLuminanceMapSamplerSS;
  int _79 = _76 + 0;
  int _81 = _78 + 0;
  float4 _83 = g_textures2D[_79].Sample(g_samplers[_81], float2(0.0, 0.0));  // _dx.types.ResRet.f32 _83 = g_textures2D[_79].Sample(g_samplers[_81], 0.000000, 0.000000, Offset = { 0, 0 });
  float _84 = _83.x;
  float _86 = HigherLimitAdaption;
  float _87 = LowerLimitAdaption;
  float _88 = max(_84, _87);
  float _89 = min(_88, _86);
  float _90 = _61 - _28;
  float _91 = _62 - _29;
  float _92 = _63 - _30;
  float _93 = _74 * _90;
  float _94 = _74 * _91;
  float _95 = _74 * _92;
  float _96 = _93 + _28;
  float _97 = _94 + _29;
  float _98 = _95 + _30;

  // tonemap
  float _100 = BrightPassValues.z;  // extractvalue _99, 2
  float _101 = _89 + 0.00100000;
  float _102 = _100 / _101;
  float _103 = _102 * _96;
  float _104 = _102 * _97;
  float _105 = _102 * _98;
  float _107 = White;
  float _108 = _103 / _107;
  float _109 = _104 / _107;
  float _110 = _105 / _107;
  float _111 = _108 + 1.00000;
  float _112 = _109 + 1.00000;
  float _113 = _110 + 1.00000;
  float _114 = _111 * _103;
  float _115 = _112 * _104;
  float _116 = _113 * _105;
  float _117 = _103 + 1.00000;
  float _118 = _104 + 1.00000;
  float _119 = _105 + 1.00000;
  float _120 = _114 / _117;
  float _121 = _115 / _118;
  float _122 = _116 / _119;
  float _123 = _120 + _48;
  float _124 = _121 + _49;
  float _125 = _122 + _50;

  // Const Add + Color Correct
  float _127 = ConstAdd.x;
  float _128 = ConstAdd.y;
  float _129 = ConstAdd.z;
  float _130 = _123 + _127;
  float _131 = _124 + _128;
  float _132 = _125 + _129;
  float _134 = ColorCorrect.x;
  float _135 = ColorCorrect.y;
  float _136 = ColorCorrect.z;
  float _137 = _134 * 2.00000;
  float _138 = _137 * _130;
  float _139 = _135 * 2.00000;
  float _140 = _139 * _131;
  float _141 = _136 * 2.00000;
  float _142 = _141 * _132;

  float3 hdrColor = float3(_138, _140, _142);

  // removing these saturates causes weird colors
  float _143 = saturate(_138);
  float _144 = saturate(_140);
  float _145 = saturate(_142);

  float _147 = LUMINANCE.x;
  float _148 = LUMINANCE.y;
  float _149 = LUMINANCE.z;
  float _150 = dot(float3(_143, _144, _145), float3(_147, _148, _149));
  float _151 = deSat;
  float _152 = _143 - _150;
  float _153 = _144 - _150;
  float _154 = _145 - _150;
  float _155 = _151 * _152;
  float _156 = _151 * _153;
  float _157 = _151 * _154;
  float _158 = _155 + _150;
  float _159 = _156 + _150;
  float _160 = _157 + _150;

  // Contrast
  float _162 = Contrast;
  float _163 = _158 + -1.00000;
  float _164 = _159 + -1.00000;
  float _165 = _160 + -1.00000;
  float _166 = _158 + -0.500000;
  float _167 = _159 + -0.500000;
  float _168 = _160 + -0.500000;
  float _169 = _158 * _162;
  float _170 = _169 * _163;
  float _171 = _170 * _166;
  float _172 = _159 * _162;
  float _173 = _172 * _164;
  float _174 = _173 * _167;
  float _175 = _160 * _162;
  float _176 = _175 * _165;
  float _177 = _176 * _168;
  float _178 = _158 - _171;
  float _179 = _159 - _174;
  float _180 = _160 - _177;

#if 1  // use upgradetonemap() to recover highlight detail
  float3 upgradedColor = renodx::tonemap::UpgradeToneMap(hdrColor, saturate(hdrColor), float3(_178, _179, _180), 1.f);
  _178 = upgradedColor.r;
  _179 = upgradedColor.g;
  _180 = upgradedColor.b;
#endif

  float _181 = max(0, _178);  // float _181 = saturate(_178);
  float _182 = max(0, _179);  // float _182 = saturate(_179);
  float _183 = max(0, _180);  // float _183 = saturate(_180);

  float _184 = abs(_181);
  float _185 = abs(_182);
  float _186 = abs(_183);
  float _187 = log2(_184);
  float _188 = log2(_185);
  float _189 = log2(_186);
  float _190 = _187 * 0.454545;
  float _191 = _188 * 0.454545;
  float _192 = _189 * 0.454545;
  float _193 = exp2(_190);
  float _194 = exp2(_191);
  float _195 = exp2(_192);
  SV_Target.x = _193;
  SV_Target.y = _194;
  SV_Target.z = _195;
  SV_Target.w = 1.00000;
  return SV_Target;
}
