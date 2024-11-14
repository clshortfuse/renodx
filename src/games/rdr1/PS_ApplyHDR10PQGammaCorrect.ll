; shader hash: 6ab04da906c7d842303d3cd48d7ae60f

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
  float4 TEXCOORD;

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

void PS_ApplyHDR10PQGammaCorrect()
{
_label0: 
  InitialiseHandle($Globals); //  index = 0
  float _1 = _IN.TEXCOORD.x;
  float _2 = _IN.TEXCOORD.y;
  _dx.types.CBufRet.i32 _3 = {_0.ParticleHeatShimmerSeed, _0.FullResMapSampler, _0.FullResMapSamplerSS, _0.RenderMapSampler}; //  cbuffer = $Globals, byte_offset = 400
  int _4 = extractvalue _3, 1;
  _dx.types.CBufRet.i32 _5 = {_0.ParticleHeatShimmerSeed, _0.FullResMapSampler, _0.FullResMapSamplerSS, _0.RenderMapSampler}; //  cbuffer = $Globals, byte_offset = 400
  int _6 = extractvalue _5, 2;
  int _7 = _4 + 0;
  InitialiseHandle(g_textures2D[_7]);
  int _9 = _6 + 0;
  InitialiseHandle(g_samplers[_9]);
  _dx.types.ResRet.f32 _11 = g_textures2D[_7].Sample(g_samplers[_9], _1, _2, Offset = {0, 0});
  float _12 = extractvalue _11, 0;
  float _13 = extractvalue _11, 1;
  float _14 = extractvalue _11, 2;
  _dx.types.CBufRet.f32 _15 = {_0.gMotionBlurScalar, _0.UsingHDR10, _0.HDRPeakNits, _0.SDRPaperWhiteNits}; //  cbuffer = $Globals, byte_offset = 0
  float _16 = extractvalue _15, 3;
  float _17 = extractvalue _15, 2;
  float _18 = 500.00000 / _16;
  float _19 = _12 / _18;
  float _20 = _13 / _18;
  float _21 = _14 / _18;
  float _22 = log2(_19);
  float _23 = log2(_20);
  float _24 = log2(_21);
  float _25 = _22 * 2.80000;
  float _26 = _23 * 2.80000;
  float _27 = _24 * 2.80000;
  float _28 = exp2(_25);
  float _29 = exp2(_26);
  float _30 = exp2(_27);
  float _31 = _28 * 0.627402;
  float _32 = mad(0.329292, _29, _31);
  float _33 = mad(0.0433060, _30, _32);
  float _34 = _28 * 0.0690950;
  float _35 = mad(0.919544, _29, _34);
  float _36 = mad(0.0113600, _30, _35);
  float _37 = _28 * 0.0163940;
  float _38 = mad(0.0880280, _29, _37);
  float _39 = mad(0.895578, _30, _38);
  float _40 = _17 * 0.000100000;
  float _41 = _33 * _40;
  float _42 = _36 * _40;
  float _43 = _39 * _40;
  float _44 = log2(_41);
  float _45 = log2(_42);
  float _46 = log2(_43);
  float _47 = _44 * 0.159302;
  float _48 = _45 * 0.159302;
  float _49 = _46 * 0.159302;
  float _50 = exp2(_47);
  float _51 = exp2(_48);
  float _52 = exp2(_49);
  float _53 = _50 * 18.8516;
  float _54 = _51 * 18.8516;
  float _55 = _52 * 18.8516;
  float _56 = _53 + 0.835938;
  float _57 = _54 + 0.835938;
  float _58 = _55 + 0.835938;
  float _59 = _50 * 18.6875;
  float _60 = _51 * 18.6875;
  float _61 = _52 * 18.6875;
  float _62 = _59 + 1.00000;
  float _63 = _60 + 1.00000;
  float _64 = _61 + 1.00000;
  float _65 = _56 / _62;
  float _66 = _57 / _63;
  float _67 = _58 / _64;
  float _68 = log2(_65);
  float _69 = log2(_66);
  float _70 = log2(_67);
  float _71 = _68 * 78.8438;
  float _72 = _69 * 78.8438;
  float _73 = _70 * 78.8438;
  float _74 = exp2(_71);
  float _75 = exp2(_72);
  float _76 = exp2(_73);
  _OUT.SV_Target.x = _74;
  _OUT.SV_Target.y = _75;
  _OUT.SV_Target.z = _76;
  _OUT.SV_Target.w = 1.00000;
  return;
}