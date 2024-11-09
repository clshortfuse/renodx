; shader hash: 696934ff3e106cbab9fed2900dae074c

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

void PSRDR2Postfx()
{
_label0: 
  InitialiseHandle($Globals); //  index = 0
  float _1 = _IN.TEXCOORD0.x;
  float _2 = _IN.TEXCOORD0.y;
  _dx.types.CBufRet.i32 _3 = {_0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler}; //  cbuffer = $Globals, byte_offset = 432
  int _4 = extractvalue _3, 3;
  _dx.types.CBufRet.i32 _5 = {_0.DepthMapSamplerSS, _0.ToneMapSampler, _0.ToneMapSamplerSS, _0.AdaptedLuminanceMapSampler}; //  cbuffer = $Globals, byte_offset = 448
  int _6 = extractvalue _5, 0;
  int _7 = _4 + 0;
  InitialiseHandle(g_textures2D[_7]);
  int _9 = _6 + 0;
  InitialiseHandle(g_samplers[_9]);
  _dx.types.ResRet.f32 _11 = g_textures2D[_7].Sample(g_samplers[_9], _1, _2, Offset = {0, 0});
  float _12 = extractvalue _11, 0;
  _dx.types.CBufRet.f32 _13 = {_0.NearFarClipPlaneQ.x, _0.NearFarClipPlaneQ.y, _0.NearFarClipPlaneQ.z, <padding>}; //  cbuffer = $Globals, byte_offset = 224
  float _14 = extractvalue _13, 0;
  float _15 = extractvalue _13, 2;
  float _16 = _14 * _15;
  float _17 = -0.000000 - _16;
  float _18 = _12 - _15;
  float _19 = _17 / _18;
  _dx.types.CBufRet.i32 _20 = {_0.ParticleHeatShimmerSeed, _0.FullResMapSampler, _0.FullResMapSamplerSS, _0.RenderMapSampler}; //  cbuffer = $Globals, byte_offset = 400
  int _21 = extractvalue _20, 1;
  int _22 = extractvalue _20, 2;
  int _23 = _21 + 0;
  InitialiseHandle(g_textures2D[_23]);
  int _25 = _22 + 0;
  InitialiseHandle(g_samplers[_25]);
  _dx.types.ResRet.f32 _27 = g_textures2D[_23].Sample(g_samplers[_25], _1, _2, Offset = {0, 0});
  float _28 = extractvalue _27, 0;
  float _29 = extractvalue _27, 1;
  float _30 = extractvalue _27, 2;
  _dx.types.CBufRet.i32 _31 = {_0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler}; //  cbuffer = $Globals, byte_offset = 432
  int _32 = extractvalue _31, 1;
  int _33 = extractvalue _31, 2;
  int _34 = _32 + 0;
  InitialiseHandle(g_textures2D[_34]);
  int _36 = _33 + 0;
  InitialiseHandle(g_samplers[_36]);
  _dx.types.ResRet.f32 _38 = g_textures2D[_34].Sample(g_samplers[_36], _1, _2, Offset = {0, 0});
  float _39 = extractvalue _38, 0;
  float _40 = extractvalue _38, 1;
  float _41 = extractvalue _38, 2;
  float _42 = extractvalue _38, 3;
  float _43 = _39 * _39;
  float _44 = _40 * _40;
  float _45 = _41 * _41;
  _dx.types.CBufRet.f32 _46 = {_0.White, _0.IntensityBloom, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 112
  float _47 = extractvalue _46, 1;
  float _48 = _43 * _47;
  float _49 = _44 * _47;
  float _50 = _45 * _47;
  float _51 = sat(_42);
  _dx.types.CBufRet.i32 _52 = {_0.RenderMapSamplerSS, _0.RenderMapPointSampler, _0.RenderMapPointSamplerSS, _0.RenderMapBilinearSampler}; //  cbuffer = $Globals, byte_offset = 416
  int _53 = extractvalue _52, 3;
  _dx.types.CBufRet.i32 _54 = {_0.RenderMapBilinearSamplerSS, _0.RenderMapAnisoSampler, _0.RenderMapAnisoSamplerSS, _0.DepthMapSampler}; //  cbuffer = $Globals, byte_offset = 432
  int _55 = extractvalue _54, 0;
  int _56 = _53 + 0;
  InitialiseHandle(g_textures2D[_56]);
  int _58 = _55 + 0;
  InitialiseHandle(g_samplers[_58]);
  _dx.types.ResRet.f32 _60 = g_textures2D[_56].Sample(g_samplers[_58], _1, _2, Offset = {0, 0});
  float _61 = extractvalue _60, 0;
  float _62 = extractvalue _60, 1;
  float _63 = extractvalue _60, 2;
  _dx.types.CBufRet.f32 _64 = {_0.DofParams.x, _0.DofParams.y, _0.DofParams.z, _0.DofParams.w}; //  cbuffer = $Globals, byte_offset = 208
  float _65 = extractvalue _64, 0;
  float _66 = extractvalue _64, 1;
  float _67 = _19 - _66;
  float _68 = _67 * _65;
  float _69 = sat(_68);
  float _70 = extractvalue _64, 2;
  bool _71 = (_19 < _70);
  float _72 = (float)(_71); // unsigned 
  float _73 = _72 * _69;
  float _74 = max(_73, _51);
  _dx.types.CBufRet.i32 _75 = {_0.DepthMapSamplerSS, _0.ToneMapSampler, _0.ToneMapSamplerSS, _0.AdaptedLuminanceMapSampler}; //  cbuffer = $Globals, byte_offset = 448
  int _76 = extractvalue _75, 3;
  _dx.types.CBufRet.i32 _77 = {_0.AdaptedLuminanceMapSamplerSS, _0.LightGlowTexSampler, _0.LightGlowTexSamplerSS, _0.AdaptedLuminance}; //  cbuffer = $Globals, byte_offset = 464
  int _78 = extractvalue _77, 0;
  int _79 = _76 + 0;
  InitialiseHandle(g_textures2D[_79]);
  int _81 = _78 + 0;
  InitialiseHandle(g_samplers[_81]);
  _dx.types.ResRet.f32 _83 = g_textures2D[_79].Sample(g_samplers[_81], 0.000000, 0.000000, Offset = {0, 0});
  float _84 = extractvalue _83, 0;
  _dx.types.CBufRet.f32 _85 = {_0.Gamma, _0.LowerLimitAdaption, _0.HigherLimitAdaption, _0.distortionFreq}; //  cbuffer = $Globals, byte_offset = 320
  float _86 = extractvalue _85, 2;
  float _87 = extractvalue _85, 1;
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
  _dx.types.CBufRet.f32 _99 = {_0.BrightPassValues.x, _0.BrightPassValues.y, _0.BrightPassValues.z, _0.BrightPassValues.w}; //  cbuffer = $Globals, byte_offset = 96
  float _100 = extractvalue _99, 2;
  float _101 = _89 + 0.00100000;
  float _102 = _100 / _101;
  float _103 = _102 * _96;
  float _104 = _102 * _97;
  float _105 = _102 * _98;
  _dx.types.CBufRet.f32 _106 = {_0.White, _0.IntensityBloom, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 112
  float _107 = extractvalue _106, 0;
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
  _dx.types.CBufRet.f32 _126 = {_0.ConstAdd.x, _0.ConstAdd.y, _0.ConstAdd.z, _0.ConstAdd.w}; //  cbuffer = $Globals, byte_offset = 160
  float _127 = extractvalue _126, 0;
  float _128 = extractvalue _126, 1;
  float _129 = extractvalue _126, 2;
  float _130 = _123 + _127;
  float _131 = _124 + _128;
  float _132 = _125 + _129;
  _dx.types.CBufRet.f32 _133 = {_0.ColorCorrect.x, _0.ColorCorrect.y, _0.ColorCorrect.z, _0.ColorCorrect.w}; //  cbuffer = $Globals, byte_offset = 176
  float _134 = extractvalue _133, 0;
  float _135 = extractvalue _133, 1;
  float _136 = extractvalue _133, 2;
  float _137 = _134 * 2.00000;
  float _138 = _137 * _130;
  float _139 = _135 * 2.00000;
  float _140 = _139 * _131;
  float _141 = _136 * 2.00000;
  float _142 = _141 * _132;
  float _143 = sat(_138);
  float _144 = sat(_140);
  float _145 = sat(_142);
  _dx.types.CBufRet.f32 _146 = {_0.LUMINANCE.x, _0.LUMINANCE.y, _0.LUMINANCE.z, _0.deSat}; //  cbuffer = $Globals, byte_offset = 144
  float _147 = extractvalue _146, 0;
  float _148 = extractvalue _146, 1;
  float _149 = extractvalue _146, 2;
  float _150 = dot({_143, _144, _145}, {_147, _148, _149});
  float _151 = extractvalue _146, 3;
  float _152 = _143 - _150;
  float _153 = _144 - _150;
  float _154 = _145 - _150;
  float _155 = _151 * _152;
  float _156 = _151 * _153;
  float _157 = _151 * _154;
  float _158 = _155 + _150;
  float _159 = _156 + _150;
  float _160 = _157 + _150;
  _dx.types.CBufRet.f32 _161 = {_0.Contrast, <padding>, <padding>, <padding>}; //  cbuffer = $Globals, byte_offset = 192
  float _162 = extractvalue _161, 0;
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
  float _181 = sat(_178);
  float _182 = sat(_179);
  float _183 = sat(_180);
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
  _OUT.SV_Target.x = _193;
  _OUT.SV_Target.y = _194;
  _OUT.SV_Target.z = _195;
  _OUT.SV_Target.w = 1.00000;
  return;
}