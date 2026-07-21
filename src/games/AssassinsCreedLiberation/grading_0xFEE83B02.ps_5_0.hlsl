#include "./common.hlsl"

// Put psychov-22.hlsl here:
//   src/shaders/tonemap/psychov/psychov-22.hlsl
#ifndef RENODX_USE_PSYCHOV22
#define RENODX_USE_PSYCHOV22 1
#endif

#if RENODX_USE_PSYCHOV22
#include "../../shaders/tonemap/psychov/psychov-22.hlsl"
#endif

cbuffer _Globals : register(b0)
{
  float3 g_PreLutScale : packoffset(c128);
  float3 g_PreLutOffset : packoffset(c129);
  float g_Slice : packoffset(c131);
  bool g_AssassinFilterEnabled : packoffset(c132);
  float g_AssassinFilterDesaturateIntensity : packoffset(c133);
  float4 g_AssassinFilterTintOpacity : packoffset(c134);
  float4x4 g_ColourControl : packoffset(c183);
  float g_ColorBalance_R[16] : packoffset(c135);
  float g_ColorBalance_G[16] : packoffset(c151);
  float g_ColorBalance_B[16] : packoffset(c167);
}

SamplerState _sampler_FrameBuffer_s : register(s0);
SamplerState _sampler_ColorBalanceR_s : register(s5);
SamplerState _sampler_ColorBalanceG_s : register(s6);
SamplerState _sampler_ColorBalanceB_s : register(s7);

Texture2D<float4> _texture_FrameBuffer : register(t0);
Texture2D<float4> _texture_ColorBalanceR : register(t5);
Texture2D<float4> _texture_ColorBalanceG : register(t6);
Texture2D<float4> _texture_ColorBalanceB : register(t7);

#define cmp -

#ifndef RENODX_METHOD1_CHROMA_STRENGTH
#define RENODX_METHOD1_CHROMA_STRENGTH 0.90f
#endif

#ifndef RENODX_METHOD1_LUMA_STRENGTH
#define RENODX_METHOD1_LUMA_STRENGTH 0.18f
#endif

#ifndef RENODX_METHOD1_SHADOW_PROTECT
#define RENODX_METHOD1_SHADOW_PROTECT 0.90f
#endif

#ifndef RENODX_METHOD1_HIGHLIGHT_PROTECT
#define RENODX_METHOD1_HIGHLIGHT_PROTECT 9.0f
#endif

#ifndef RENODX_TONE_MAP_TYPE_PSYCHOV22
#define RENODX_TONE_MAP_TYPE_PSYCHOV22 22.0f
#endif

#ifndef RENODX_PSYCHOV22_COMPRESSION
#define RENODX_PSYCHOV22_COMPRESSION 0.0f
#endif

#ifndef RENODX_PSYCHOV22_GAMUT_COMPRESSION
#define RENODX_PSYCHOV22_GAMUT_COMPRESSION 1.0f
#endif

#ifndef RENODX_PSYCHOV22_GAMUT_MODE
#define RENODX_PSYCHOV22_GAMUT_MODE 1.0f
#endif

#ifndef RENODX_PSYCHOV22_CONE_RESPONSE
#define RENODX_PSYCHOV22_CONE_RESPONSE 1.0f
#endif


float SafeFinite1(float v)
{
  // NaN is the only value where v != v.
  v = (v == v) ? v : 0.0f;
  return min(max(v, 0.0f), 65504.0f);
}

float3 SafePositive(float3 c)
{
  return float3(SafeFinite1(c.r), SafeFinite1(c.g), SafeFinite1(c.b));
}

bool IsRenoDRTMode()
{
  return abs(RENODX_TONE_MAP_TYPE - renodx::draw::TONE_MAP_TYPE_RENO_DRT) < 0.5f;
}

bool IsPsychoV22Mode()
{
  return abs(RENODX_TONE_MAP_TYPE - RENODX_TONE_MAP_TYPE_PSYCHOV22) < 0.5f;
}

bool IsCustomHDRMode()
{
  return IsRenoDRTMode() || IsPsychoV22Mode();
}

float3 ApplyPsychoV22HDRTonemap(float3 hdrColor)
{
  hdrColor = SafePositive(hdrColor);

#if RENODX_USE_PSYCHOV22
  float peakValue = max(
    RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0f),
    1.0f
  );

  int gamutMode = (RENODX_PSYCHOV22_GAMUT_MODE > 0.5f) ? 1 : 0;

  hdrColor = renodx::tonemap::psychov::psychotm_test22(
    hdrColor,
    peakValue,
    RENODX_TONE_MAP_EXPOSURE,
    RENODX_TONE_MAP_HIGHLIGHTS,
    RENODX_TONE_MAP_SHADOWS,
    RENODX_TONE_MAP_CONTRAST,
    RENODX_TONE_MAP_SATURATION,
    1.0f,                                  // bleaching_intensity, reserved
    100.0f,                                // clip_point, reserved
    RENODX_TONE_MAP_HUE_CORRECTION,
    1.0f,                                  // adaptation_contrast, deprecated
    0,                                     // white_curve_mode, deprecated
    RENODX_PSYCHOV22_CONE_RESPONSE,        // cone_response_exponent
    0.18f.xxx,                             // current adaptive state / anchor-in
    0.18f.xxx,                             // desired background state / anchor-out
    RENODX_PSYCHOV22_GAMUT_COMPRESSION,
    gamutMode,
    1.0f,                                  // adaptive_normalization, deprecated
    RENODX_PSYCHOV22_COMPRESSION           // 0.0 = auto
  );
#endif

  return SafePositive(hdrColor);
}

float SafeScale(float s)
{
  return max(s, 0.000001f);
}

float3 SafeScale3(float3 v)
{
  return max(v, float3(0.000001f, 0.000001f, 0.000001f));
}

float SDRLuma(float3 color)
{
  return dot(color, float3(0.2126f, 0.7152f, 0.0722f));
}

float Max3(float3 v)
{
  return max(max(v.r, v.g), v.b);
}

float3 ClampAssassinRange(float3 color)
{
  return saturate(color);
}

float3 ApplyAssassinFilterGamma(float3 colorGamma)
{
  float4 r0, r1, r2, r3, r4;

  r0.xyz = saturate(colorGamma);

  if (g_AssassinFilterEnabled != 0)
  {
    r0.w = dot(r0.xyz, float3(0.212599993f, 0.715200007f, 0.0722000003f));

    r1.xyz = r0.www + -r0.xyz;
    r1.xyz = g_AssassinFilterDesaturateIntensity * r1.xyz + r0.xyz;
    r1.xyz = ClampAssassinRange(r1.xyz);

    r2.xyz = g_AssassinFilterTintOpacity.xyz * r1.xyz;
    r2.xyz = r2.xyz * r0.xyz;
    r2.xyz = r2.xyz + r2.xyz;
    r2.xyz = ClampAssassinRange(r2.xyz);

    r3.xyz = float3(1.0f, 1.0f, 1.0f) + -r0.xyz;
    r3.xyz = r3.xyz + r3.xyz;

    r1.xyz = -r1.xyz * g_AssassinFilterTintOpacity.xyz + float3(1.0f, 1.0f, 1.0f);
    r1.xyz = -r3.xyz * r1.xyz + float3(1.0f, 1.0f, 1.0f);
    r1.xyz = ClampAssassinRange(r1.xyz);

    r3.xyz = cmp(r0.xyz < float3(0.5f, 0.5f, 0.5f));

    r4.xyz = r3.xyz ? float3(1.0f, 1.0f, 1.0f) : float3(0.0f, 0.0f, 0.0f);
    r3.xyz = r3.xyz ? float3(0.0f, 0.0f, 0.0f) : float3(1.0f, 1.0f, 1.0f);

    r1.xyz = r3.xyz * r1.xyz;
    r1.xyz = r2.xyz * r4.xyz + r1.xyz;
    r1.xyz = r1.xyz + -r0.xyz;

    r0.xyz = g_AssassinFilterTintOpacity.www * r1.xyz + r0.xyz;
  }

  return saturate(r0.xyz);
}

float3 ApplyGameLUTAndGradeVanilla(float3 inputGamma)
{
  float4 r0, r1;

  r0.xyz = saturate(inputGamma);
  r0.xyz = r0.xyz * g_PreLutScale.xyz + g_PreLutOffset.xyz;
  r0.xyz = saturate(r0.xyz);
  r0.w = 0.5f;

  r1.x = _texture_ColorBalanceR.SampleLevel(_sampler_ColorBalanceR_s, r0.xw, 0).x;
  r1.y = _texture_ColorBalanceG.SampleLevel(_sampler_ColorBalanceG_s, r0.yw, 0).x;
  r1.z = _texture_ColorBalanceB.SampleLevel(_sampler_ColorBalanceB_s, r0.zw, 0).x;
  r1.w = 1.0f;

  r0.x = dot(r1.xyzw, g_ColourControl._m00_m10_m20_m30);
  r0.y = dot(r1.xyzw, g_ColourControl._m01_m11_m21_m31);
  r0.z = dot(r1.xyzw, g_ColourControl._m02_m12_m22_m32);

  r0.xyz = saturate(r0.xyz);
  r0.xyz = ApplyAssassinFilterGamma(r0.xyz);

  return saturate(r0.xyz);
}

float3 ApplyMethod1LUTDifference(
  float3 sdrNoLutLinear,
  float3 sdrLutGamma,
  float3 hdrBaseLinear)
{
  float3 sdrBase = max(sdrNoLutLinear, 0.0f);
  float3 sdrLut = renodx::color::gamma::DecodeSafe(max(sdrLutGamma, 0.0f));
  float3 hdrBase = max(hdrBaseLinear, 0.0f);

  float sdrBaseY = SDRLuma(sdrBase);
  float sdrLutY = SDRLuma(sdrLut);

  float3 rgbRatio = sdrLut / SafeScale3(sdrBase);
  rgbRatio = clamp(
    rgbRatio,
    float3(0.25f, 0.25f, 0.25f),
    float3(4.00f, 4.00f, 4.00f)
  );

  float lumaRatio = sdrLutY / SafeScale(sdrBaseY);
  lumaRatio = clamp(lumaRatio, 0.65f, 1.35f);

  float3 chromaRatio = rgbRatio / SafeScale(lumaRatio);
  chromaRatio = clamp(
    chromaRatio,
    float3(0.50f, 0.50f, 0.50f),
    float3(2.00f, 2.00f, 2.00f)
  );

  float hdrY = SDRLuma(hdrBase);
  float hdrMax = Max3(hdrBase);

  float ratioReliability = smoothstep(0.010f, 0.080f, sdrBaseY);
  float shadowProtect = 1.0f - smoothstep(0.015f, 0.100f, hdrY);
  float highlightProtect = smoothstep(0.550f, 1.100f, hdrMax);

  float chromaStrength = RENODX_METHOD1_CHROMA_STRENGTH * ratioReliability;
  float lumaStrength = RENODX_METHOD1_LUMA_STRENGTH * ratioReliability;

  lumaRatio = lerp(lumaRatio, 1.0f, shadowProtect * RENODX_METHOD1_SHADOW_PROTECT);
  lumaRatio = lerp(lumaRatio, max(lumaRatio, 1.0f), highlightProtect * RENODX_METHOD1_HIGHLIGHT_PROTECT);

  float3 color = hdrBase;
  color *= lerp(float3(1.0f, 1.0f, 1.0f), chromaRatio, chromaStrength);
  color *= lerp(1.0f, lumaRatio, lumaStrength);

  float colorMax = Max3(color);
  float preservePeakScale = hdrMax / SafeScale(colorMax);
  preservePeakScale = max(preservePeakScale, 1.0f);

  color *= lerp(1.0f, preservePeakScale, highlightProtect * RENODX_METHOD1_HIGHLIGHT_PROTECT);

  return max(color, 0.0f);
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float3 sceneGamma = _texture_FrameBuffer.Sample(_sampler_FrameBuffer_s, v1.xy).xyz;

  if (!IsCustomHDRMode())
  {
    float3 colorSDR = ApplyGameLUTAndGradeVanilla(sceneGamma);

    o0.rgb = saturate(colorSDR);
    o0.a = 1.0f;
    return;
  }

  float3 ungradedColor = renodx::color::gamma::DecodeSafe(max(sceneGamma, 0.0f));

  ungradedColor = PreTonemapSliders(ungradedColor);

  float3 sdrColor = CustomGradingBegin(ungradedColor);
  float3 lutInputGamma = renodx::color::gamma::EncodeSafe(max(sdrColor, 0.0f));

  float3 vanillaLutGamma = ApplyGameLUTAndGradeVanilla(lutInputGamma);

  float3 hdrBaseColor = CustomGradingEnd(
    ungradedColor,
    sdrColor,
    sdrColor
  );

  float3 outputColor = ApplyMethod1LUTDifference(
    sdrColor,
    vanillaLutGamma,
    hdrBaseColor
  );

  if (IsPsychoV22Mode())
  {
    outputColor = ApplyPsychoV22HDRTonemap(outputColor);
  }
  else
  {
    outputColor = HDRDisplayMap(outputColor);
  }

  outputColor = PostTonemapSliders(outputColor);
  outputColor = max(outputColor, 0.0f);

  o0.rgb = renodx::draw::RenderIntermediatePass(outputColor);
  o0.a = 1.0f;
  return;
}