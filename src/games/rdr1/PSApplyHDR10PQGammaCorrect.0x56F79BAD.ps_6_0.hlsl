#include "./shared.h"

Texture2D<float4> g_textures2D[] : register(t0, space2);
SamplerState g_samplers[] : register(s0, space1);

cbuffer Globals : register(b0, space0) {
  float gMotionBlurScalar;
  float UsingHDR10;
  float HDRPeakNits;
  float SDRPaperWhiteNits;
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
  int FullResMapSampler;
  int FullResMapSamplerSS;
  int RenderMapSampler;
  int RenderMapSamplerSS;
  int AdaptedLuminanceMapSampler;
  int AdaptedLuminanceMapSamplerSS;
  int ToneMapSampler;
  int ToneMapSamplerSS;
  int LightGlowTexSampler;
  int LightGlowTexSamplerSS;
  float AdaptedLuminance;
  float2 horzTapOffs[7];
  float2 vertTapOffs[7];
  float4 TexelWeight[16];
  float Scale;
  float zoomIntensity;
  float shockIntensity;
  float shockAmplitude;
  float reticleOffset;
  float4 SharpParams;
};

// PS_ApplyHDR10PQGammaCorrect
float4 main(
    float4 SV_Position: SV_Position,
    float4 TEXCOORD: TEXCOORD)
    : SV_Target {
  float gameNits = HDRPeakNits;
  if (HDRPeakNits == 196.0) gameNits = 203.0;  // Round slider up to BT.2408 reference white
  float UINits = SDRPaperWhiteNits;            // 500 = 1.0 scale

  float3 fullResMap = g_textures2D[FullResMapSampler].Sample(g_samplers[FullResMapSamplerSS], TEXCOORD.xy).rgb;
  float _12 = fullResMap.r;
  float _13 = fullResMap.g;
  float _14 = fullResMap.b;

  float _18 = 500.0 / UINits;
  float _19 = _12 / _18;
  float _20 = _13 / _18;
  float _21 = _14 / _18;
  float _22 = log2(_19);
  float _23 = log2(_20);
  float _24 = log2(_21);
  float _25 = _22 * 2.8;
  float _26 = _23 * 2.8;
  float _27 = _24 * 2.8;
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
  float _40 = gameNits / 10000.0;
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

  float3 pqEncodedColor = float3(_74, _75, _76);
  return float4(pqEncodedColor, 1.0);
}
