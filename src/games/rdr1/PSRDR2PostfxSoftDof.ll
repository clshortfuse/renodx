; shader hash: 2c005d9eef301d0a900192114a88d0d3

; Pixel Shader, compiled under SM6.0

_dx.types.Handle = type { int8* }
_dx.types.CBufRet.i32 = type { int, int, int, int }
_dx.types.ResRet.f32 = type { float, float, float, float, int }
_dx.types.CBufRet.f32 = type { float, float, float, float }
_"class.Texture2D<vector<float, 4> >" = type { float4, _"class.Texture2D<vector<float, 4> >::mips_type" }
_"class.Texture2D<vector<float, 4> >::mips_type" = type { int }
_"hostlayout.$Globals" = type { float, float, float, float, float, float4, float4, float4, float, float, float, float4, float, float, float4, float3, float, float4, float4, float, float4, float3, float2, float4[4], float, float, float, float, float, float, float4, float4, float4, float, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, int, float, float2[7], float2[7], float4[16], float3, float, float, float, float, float, float4, float4, int, int, int, int, int, int, int, int, float, float, float, float4, float4, float, int, int, float, float, float, float4, float3, float4, float4, float4[4], float, float4, float4, float4, float4, float4, float, float, float, float }
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
};

UNHANDLED RESOURCE TYPE g_samplers[] : register(s0, space1);

void PSRDR2PostfxSoftDof()
{
_label0: 
  InitialiseHandle($Globals); //  index = 0
  float _1 = _IN.TEXCOORD0.x;
  float _2 = _IN.TEXCOORD0.y;
  _dx.types.CBufRet.i32 _3 = {_0.ParticleHeatShimmerSeed, _0.FullResMapSampler, _0.FullResMapSamplerSS, _0.RenderMapSampler}; //  cbuffer = $Globals, byte_offset = 400
  int _4 = extractvalue _3, 1;
  int _5 = extractvalue _3, 2;
  int _6 = _4 + 0;
  InitialiseHandle(g_textures2D[_6]);
  int _8 = _5 + 0;
  InitialiseHandle(g_samplers[_8]);
  _dx.types.ResRet.f32 _10 = g_textures2D[_6].Sample(g_samplers[_8], _1, _2, Offset = {0, 0});
  float _11 = extractvalue _10, 0;
  float _12 = extractvalue _10, 1;
  float _13 = extractvalue _10, 2;
  _dx.types.CBufRet.i32 _14 = {_0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler}; //  cbuffer = $Globals, byte_offset = 432
  int _15 = extractvalue _14, 1;
  _dx.types.CBufRet.i32 _16 = {_0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler}; //  cbuffer = $Globals, byte_offset = 432
  int _17 = extractvalue _16, 2;
  int _18 = _15 + 0;
  InitialiseHandle(g_textures2D[_18]);
  int _20 = _17 + 0;
  InitialiseHandle(g_samplers[_20]);
  _dx.types.ResRet.f32 _22 = g_textures2D[_18].Sample(g_samplers[_20], _1, _2, Offset = {0, 0});
  float _23 = extractvalue _22, 0;
  float _24 = extractvalue _22, 1;
  float _25 = extractvalue _22, 2;
  float _26 = extractvalue _22, 3;
  float _27 = _23 * _23;
  float _28 = _24 * _24;
  float _29 = _25 * _25;
  _dx.types.CBufRet.f32 _30 = {_0.White, _0.IntensityBloom, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 112
  float _31 = extractvalue _30, 1;
  float _32 = _27 * _31;
  float _33 = _28 * _31;
  float _34 = _29 * _31;
  float _35 = sat(_26);
  _dx.types.CBufRet.i32 _36 = {_0.RenderMapSamplerSS, _0.RenderMapPointSampler, _0.RenderMapPointSamplerSS, _0.RenderMapBilinearSampler}; //  cbuffer = $Globals, byte_offset = 416
  int _37 = extractvalue _36, 3;
  _dx.types.CBufRet.i32 _38 = {_0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler}; //  cbuffer = $Globals, byte_offset = 432
  int _39 = extractvalue _38, 0;
  int _40 = _37 + 0;
  InitialiseHandle(g_textures2D[_40]);
  int _42 = _39 + 0;
  InitialiseHandle(g_samplers[_42]);
  _dx.types.ResRet.f32 _44 = g_textures2D[_40].Sample(g_samplers[_42], _1, _2, Offset = {0, 0});
  float _45 = extractvalue _44, 0;
  float _46 = extractvalue _44, 1;
  float _47 = extractvalue _44, 2;
  _dx.types.CBufRet.i32 _48 = {_0.DepthMapSamplerSS, _0.ToneMapSampler, _0.ToneMapSamplerSS, _0.AdaptedLuminanceMapSampler}; //  cbuffer = $Globals, byte_offset = 448
  int _49 = extractvalue _48, 3;
  _dx.types.CBufRet.i32 _50 = {_0.AdaptedLuminanceMapSamplerSS, _0.LightGlowTexSampler, _0.LightGlowTexSamplerSS, _0.AdaptedLuminance}; //  cbuffer = $Globals, byte_offset = 464
  int _51 = extractvalue _50, 0;
  int _52 = _49 + 0;
  InitialiseHandle(g_textures2D[_52]);
  int _54 = _51 + 0;
  InitialiseHandle(g_samplers[_54]);
  _dx.types.ResRet.f32 _56 = g_textures2D[_52].Sample(g_samplers[_54], 0.000000, 0.000000, Offset = {0, 0});
  float _57 = extractvalue _56, 0;
  _dx.types.CBufRet.f32 _58 = {_0.Gamma, _0.LowerLimitAdaption, _0.HigherLimitAdaption, _0.distortionFreq}; //  cbuffer = $Globals, byte_offset = 320
  float _59 = extractvalue _58, 2;
  float _60 = extractvalue _58, 1;
  float _61 = max(_57, _60);
  float _62 = min(_61, _59);
  float _63 = _45 - _11;
  float _64 = _46 - _12;
  float _65 = _47 - _13;
  float _66 = _63 * _35;
  float _67 = _64 * _35;
  float _68 = _65 * _35;
  float _69 = _66 + _11;
  float _70 = _67 + _12;
  float _71 = _68 + _13;
  _dx.types.CBufRet.f32 _72 = {_0.BrightPassValues.x, _0.BrightPassValues.y, _0.BrightPassValues.z, _0.BrightPassValues.w}; //  cbuffer = $Globals, byte_offset = 96
  float _73 = extractvalue _72, 2;
  float _74 = _62 + 0.00100000;
  float _75 = _73 / _74;
  float _76 = _75 * _69;
  float _77 = _75 * _70;
  float _78 = _75 * _71;
  _dx.types.CBufRet.f32 _79 = {_0.White, _0.IntensityBloom, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 112
  float _80 = extractvalue _79, 0;
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
  float _96 = _93 + _32;
  float _97 = _94 + _33;
  float _98 = _95 + _34;
  _dx.types.CBufRet.f32 _99 = {_0.ConstAdd.x, _0.ConstAdd.y, _0.ConstAdd.z, _0.ConstAdd.w}; //  cbuffer = $Globals, byte_offset = 160
  float _100 = extractvalue _99, 0;
  float _101 = extractvalue _99, 1;
  float _102 = extractvalue _99, 2;
  float _103 = _96 + _100;
  float _104 = _97 + _101;
  float _105 = _98 + _102;
  _dx.types.CBufRet.f32 _106 = {_0.ColorCorrect.x, _0.ColorCorrect.y, _0.ColorCorrect.z, _0.ColorCorrect.w}; //  cbuffer = $Globals, byte_offset = 176
  float _107 = extractvalue _106, 0;
  float _108 = extractvalue _106, 1;
  float _109 = extractvalue _106, 2;
  float _110 = _107 * 2.00000;
  float _111 = _110 * _103;
  float _112 = _108 * 2.00000;
  float _113 = _112 * _104;
  float _114 = _109 * 2.00000;
  float _115 = _114 * _105;
  float _116 = sat(_111);
  float _117 = sat(_113);
  float _118 = sat(_115);
  _dx.types.CBufRet.f32 _119 = {_0.LUMINANCE.x, _0.LUMINANCE.y, _0.LUMINANCE.z, _0.deSat}; //  cbuffer = $Globals, byte_offset = 144
  float _120 = extractvalue _119, 0;
  float _121 = extractvalue _119, 1;
  float _122 = extractvalue _119, 2;
  float _123 = dot({_116, _117, _118}, {_120, _121, _122});
  float _124 = extractvalue _119, 3;
  float _125 = _116 - _123;
  float _126 = _117 - _123;
  float _127 = _118 - _123;
  float _128 = _124 * _125;
  float _129 = _124 * _126;
  float _130 = _124 * _127;
  float _131 = _128 + _123;
  float _132 = _129 + _123;
  float _133 = _130 + _123;
  _dx.types.CBufRet.f32 _134 = {_0.Contrast, <padding>, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 192
  float _135 = extractvalue _134, 0;
  float _136 = _131 + -1.00000;
  float _137 = _132 + -1.00000;
  float _138 = _133 + -1.00000;
  float _139 = _131 + -0.500000;
  float _140 = _132 + -0.500000;
  float _141 = _133 + -0.500000;
  float _142 = _131 * _135;
  float _143 = _142 * _136;
  float _144 = _143 * _139;
  float _145 = _132 * _135;
  float _146 = _145 * _137;
  float _147 = _146 * _140;
  float _148 = _133 * _135;
  float _149 = _148 * _138;
  float _150 = _149 * _141;
  float _151 = _131 - _144;
  float _152 = _132 - _147;
  float _153 = _133 - _150;
  float _154 = sat(_151);
  float _155 = sat(_152);
  float _156 = sat(_153);
  float _157 = abs(_154);
  float _158 = abs(_155);
  float _159 = abs(_156);
  float _160 = log2(_157);
  float _161 = log2(_158);
  float _162 = log2(_159);
  float _163 = _160 * 0.454545;
  float _164 = _161 * 0.454545;
  float _165 = _162 * 0.454545;
  float _166 = exp2(_163);
  float _167 = exp2(_164);
  float _168 = exp2(_165);
  _OUT.SV_Target.x = _166;
  _OUT.SV_Target.y = _167;
  _OUT.SV_Target.z = _168;
  _OUT.SV_Target.w = 1.00000;
  return;
}