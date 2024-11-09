; shader hash: d47f248a467a56e9fd73b2bed8cdba65

; Pixel Shader, compiled under SM6.0

_dx.types.Handle = type { int8* }
_dx.types.CBufRet.i32 = type { int, int, int, int }
_dx.types.ResRet.f32 = type { float, float, float, float, int }
_dx.types.CBufRet.f32 = type { float, float, float, float }
_"class.Texture2D<vector<float, 4> >" = type { float4, _"class.Texture2D<vector<float, 4> >::mips_type" }
_"class.Texture2D<vector<float, 4> >::mips_type" = type { int }
_"hostlayout.$Globals" = type { float, float, float, float, float, float4, float4, float4, float, float, float, float4, float, float, float4, float3, float, float4, float4, float, float4, float3, float2, float4[4], float, float, float, float, float, float, float4, float4, float4, float, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, float, float2[7], float2[7], float4[16], float3, float, float, float, float, float, float4, float4, int, int, int, int, int, int, int, int, float, float, float, float4, float4, float, int, int, float, float, float, float4, float3, float4, float4, float4[4], float, float4, float4, float4, float4, float4, float, float, float, float, float2[16], float, float, float, float, float4 }
_struct.SamplerState = type { int }

Inputs
  float4 SV_Position;
  float4 TEXCOORD0;
  float4 TEXCOORD1;
  float4 TEXCOORD2;

Outputs
  float4 SV_Target;

Texture2D<float4> g_textures2D[] : register(t0, space2);

cbuffer $Globals : register(b0, space0)
{
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
  float2 tap16[16];
  float zoomIntensity;
  float shockIntensity;
  float shockAmplitude;
  float reticleOffset;
  float4 SharpParams;
};

UNHANDLED RESOURCE TYPE g_samplers[] : register(s0, space1);

void PSMiniAdapt()
{
_label0: 
  InitialiseHandle($Globals); //  index = 0
  float _1 = _IN.TEXCOORD1.x;
  float _2 = _IN.TEXCOORD0.x;
  float _3 = _IN.TEXCOORD0.y;
  _dx.types.CBufRet.i32 _4 = {_0.RenderMapSamplerSS, _0.RenderMapPointSampler, _0.RenderMapPointSamplerSS, _0.RenderMapBilinearSampler}; //  cbuffer = $Globals, byte_offset = 416
  int _5 = extractvalue _4, 3;
  _dx.types.CBufRet.i32 _6 = {_0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler}; //  cbuffer = $Globals, byte_offset = 432
  int _7 = extractvalue _6, 0;
  int _8 = _5 + 0;
  InitialiseHandle(g_textures2D[_8]);
  int _10 = _7 + 0;
  InitialiseHandle(g_samplers[_10]);
  _dx.types.ResRet.f32 _12 = g_textures2D[_8].Sample(g_samplers[_10], _2, _3, Offset = {0, 0});
  float _13 = extractvalue _12, 0;
  float _14 = extractvalue _12, 1;
  float _15 = extractvalue _12, 2;
  _dx.types.CBufRet.f32 _16 = {_0.BrightPassValues.x, _0.BrightPassValues.y, _0.BrightPassValues.z, _0.BrightPassValues.w}; //  cbuffer = $Globals, byte_offset = 96
  float _17 = extractvalue _16, 2;
  float _18 = _1 + 0.00100000;
  float _19 = _17 / _18;
  float _20 = _19 * _13;
  float _21 = _19 * _14;
  float _22 = _19 * _15;
  _dx.types.CBufRet.f32 _23 = {_0.White, _0.IntensityBloom, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 112
  float _24 = extractvalue _23, 0;
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
  _dx.types.CBufRet.f32 _40 = {_0.ConstAdd.x, _0.ConstAdd.y, _0.ConstAdd.z, _0.ConstAdd.w}; //  cbuffer = $Globals, byte_offset = 160
  float _41 = extractvalue _40, 0;
  float _42 = extractvalue _40, 1;
  float _43 = extractvalue _40, 2;
  float _44 = _41 + _37;
  float _45 = _42 + _38;
  float _46 = _43 + _39;
  _dx.types.CBufRet.f32 _47 = {_0.ColorCorrect.x, _0.ColorCorrect.y, _0.ColorCorrect.z, _0.ColorCorrect.w}; //  cbuffer = $Globals, byte_offset = 176
  float _48 = extractvalue _47, 0;
  float _49 = extractvalue _47, 1;
  float _50 = extractvalue _47, 2;
  float _51 = _48 * 2.00000;
  float _52 = _51 * _44;
  float _53 = _49 * 2.00000;
  float _54 = _53 * _45;
  float _55 = _50 * 2.00000;
  float _56 = _55 * _46;
  float _57 = sat(_52);
  float _58 = sat(_54);
  float _59 = sat(_56);
  _dx.types.CBufRet.f32 _60 = {_0.LUMINANCE.x, _0.LUMINANCE.y, _0.LUMINANCE.z, _0.deSat}; //  cbuffer = $Globals, byte_offset = 144
  float _61 = extractvalue _60, 0;
  float _62 = extractvalue _60, 1;
  float _63 = extractvalue _60, 2;
  float _64 = dot({_57, _58, _59}, {_61, _62, _63});
  float _65 = extractvalue _60, 3;
  float _66 = _57 - _64;
  float _67 = _58 - _64;
  float _68 = _59 - _64;
  float _69 = _65 * _66;
  float _70 = _65 * _67;
  float _71 = _65 * _68;
  float _72 = _69 + _64;
  float _73 = _70 + _64;
  float _74 = _71 + _64;
  _dx.types.CBufRet.f32 _75 = {_0.Contrast, <padding>, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 192
  float _76 = extractvalue _75, 0;
  float _77 = _72 + -1.00000;
  float _78 = _73 + -1.00000;
  float _79 = _74 + -1.00000;
  float _80 = _72 + -0.500000;
  float _81 = _73 + -0.500000;
  float _82 = _74 + -0.500000;
  float _83 = _72 * _76;
  float _84 = _83 * _77;
  float _85 = _84 * _80;
  float _86 = _73 * _76;
  float _87 = _86 * _78;
  float _88 = _87 * _81;
  float _89 = _74 * _76;
  float _90 = _89 * _79;
  float _91 = _90 * _82;
  float _92 = _72 - _85;
  float _93 = _73 - _88;
  float _94 = _74 - _91;
  float _95 = sat(_92);
  float _96 = sat(_93);
  float _97 = sat(_94);
  float _98 = abs(_95);
  float _99 = abs(_96);
  float _100 = abs(_97);
  float _101 = log2(_98);
  float _102 = log2(_99);
  float _103 = log2(_100);
  float _104 = _101 * 0.454545;
  float _105 = _102 * 0.454545;
  float _106 = _103 * 0.454545;
  float _107 = exp2(_104);
  float _108 = exp2(_105);
  float _109 = exp2(_106);
  float _110 = extractvalue _23, 1;
  _OUT.SV_Target.x = _107;
  _OUT.SV_Target.y = _108;
  _OUT.SV_Target.z = _109;
  _OUT.SV_Target.w = _110;
  return;
}