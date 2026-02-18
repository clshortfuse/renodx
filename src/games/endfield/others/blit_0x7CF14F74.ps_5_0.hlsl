// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 27 22:02:47 2025
#include "../shared.h"

// Blit shader with RCAS support

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[3];
}

// 3Dmigoto declarations
#define cmp -

// RCAS - Robust Contrast Adaptive Sharpening
float3 ApplyRCAS(
    float3 center_color, float2 tex_coord,
    Texture2D<float4> SamplerFrameBuffer_TEX, SamplerState SamplerFrameBuffer_SMP_s) {
  if (shader_injection.fx_rcas_amount == 0.f) return center_color;  // Skip sharpening if amount is zero

#define ENABLE_NOISE_REMOVAL           1u  // Always good to be enabled
#define ENABLE_NORMALIZATION           1u
#define SHARPENING_NORMALIZATION_POINT 125

  uint width, height;
  SamplerFrameBuffer_TEX.GetDimensions(width, height);
  float2 texel_size = 1.0 / float2(width, height);

  // Algorithm uses minimal 3x3 pixel neighborhood.
  //    b
  //  d e f
  //    h
  float3 b =
      SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(0, -1) * texel_size, 0).rgb;
  float3 d =
      SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(-1, 0) * texel_size, 0).rgb;
  float3 e =
      center_color;
  float3 f =
      SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(1, 0) * texel_size, 0).rgb;
  float3 h =
      SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, tex_coord + float2(0, 1) * texel_size, 0).rgb;

#if ENABLE_NORMALIZATION
  b /= SHARPENING_NORMALIZATION_POINT;
  d /= SHARPENING_NORMALIZATION_POINT;
  e /= SHARPENING_NORMALIZATION_POINT;
  f /= SHARPENING_NORMALIZATION_POINT;
  h /= SHARPENING_NORMALIZATION_POINT;
#endif

  // Immediate constants for peak range.
  static const float2 peakC = float2(1.f, -4.f);

  // Calculate luminance of center and neighbors
  float bLum = renodx::color::y::from::BT709(b);
  float dLum = renodx::color::y::from::BT709(d);
  float eLum = renodx::color::y::from::BT709(e);
  float fLum = renodx::color::y::from::BT709(f);
  float hLum = renodx::color::y::from::BT709(h);

  // Min and max of ring.
  float min4Lum = renodx::math::Min(bLum, dLum, fLum, hLum);
  float max4Lum = renodx::math::Max(bLum, dLum, fLum, hLum);

  // 0.99 found through testing -> see my latest desmos or https://www.desmos.com/calculator/4dyqhishpl
  // this helps reducing massive overshoot that would happen otherwise
  // normal CAS applies a limiter too so that there is no overshoot
  float limited_max4Lum = min(max4Lum, 0.99f);

  float hitMinLum = min4Lum
                    * rcp(4.f * limited_max4Lum);

  float hitMaxLum = (peakC.x - limited_max4Lum)
                    * rcp(4.f * min4Lum + peakC.y);

  float localLobe = max(-hitMinLum, hitMaxLum);

// This is set at the limit of providing unnatural results for sharpening.
// 0.25f - (1.f / 16.f)
#define FSR_RCAS_LIMIT 0.1875f

  float lobe = max(float(-FSR_RCAS_LIMIT),
                   min(localLobe, 0.f))
               * shader_injection.fx_rcas_amount;

#if ENABLE_NOISE_REMOVAL
  float bLuma2x = bLum * 2.f;
  float dLuma2x = dLum * 2.f;
  float eLuma2x = eLum * 2.f;
  float fLuma2x = fLum * 2.f;
  float hLuma2x = hLum * 2.f;
  // Noise detection.
  float nz = 0.25f * bLuma2x
             + 0.25f * dLuma2x
             + 0.25f * fLuma2x
             + 0.25f * hLuma2x
             - eLuma2x;

  float maxLuma2x = renodx::math::Max(renodx::math::Max(bLuma2x, dLuma2x, eLuma2x), fLuma2x, hLuma2x);
  float minLuma2x = renodx::math::Min(renodx::math::Min(bLuma2x, dLuma2x, eLuma2x), fLuma2x, hLuma2x);

  nz = saturate(abs(nz) * rcp(maxLuma2x - minLuma2x));
  nz = -0.5f * nz + 1.f;

  lobe *= nz;
#endif

  // Resolve, which needs the medium precision rcp approximation to avoid visible tonality changes.
  float rcpL = rcp(4.f * lobe + 1.f);

  float pixLum = ((bLum + dLum + hLum + fLum) * lobe + eLum) * rcpL;
  float3 pix = clamp((pixLum / eLum), 0.f, 4.f) * e;

#if ENABLE_NORMALIZATION
  pix *= SHARPENING_NORMALIZATION_POINT;
#endif

  return pix;
}

// Color Calibration: Temperature 6500K → 6750K + magenta offset 0.03

float3 ApplyColorCalibration(float3 color)
{
    float3 adapted;
    adapted.r = dot(color, float3( 1.00113f, -0.00212f, -0.01555f));
    adapted.g = dot(color, float3(-0.00031f,  1.00047f,  0.00113f));
    adapted.b = dot(color, float3(-0.00018f,  0.00445f,  1.03436f));

    float3 lms;
    lms.x = dot(adapted, float3(0.4122214708f, 0.5363325363f, 0.0514459929f));
    lms.y = dot(adapted, float3(0.2119034982f, 0.6806995451f, 0.1073969566f));
    lms.z = dot(adapted, float3(0.0883024619f, 0.2817188376f, 0.6299787005f));

    lms = sign(lms) * pow(abs(lms), 1.0f / 3.0f);

    float3 lab;
    lab.x = dot(lms, float3( 0.2104542553f,  0.7936177850f, -0.0040720468f));
    lab.y = dot(lms, float3( 1.9779984951f, -2.4285922050f,  0.4505937099f));
    lab.z = dot(lms, float3( 0.0259040371f,  0.7827717662f, -0.8086757660f));

    lab.y += 0.0015f;

    lms.x = lab.x + 0.3963377774f * lab.y + 0.2158037573f * lab.z;
    lms.y = lab.x - 0.1055613458f * lab.y - 0.0638541728f * lab.z;
    lms.z = lab.x - 0.0894841775f * lab.y - 1.2914855480f * lab.z;

    lms = lms * lms * lms;

    float3 result;
    result.r = dot(lms, float3( 4.0767416621f, -3.3077115913f,  0.2309699292f));
    result.g = dot(lms, float3(-1.2684380046f,  2.6097574011f, -0.3413193965f));
    result.b = dot(lms, float3(-0.0041960863f, -0.7034186147f,  1.7076147010f));

    return result;
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.SampleLevel(s0_s, v1.xy, cb0[2].x).xyz;
  
  // Apply RCAS sharpening if enabled
  if (shader_injection.fx_rcas_sharpening >= 1.0f) {
    r0.xyz = ApplyRCAS(r0.xyz, v1.xy, t0, s0_s);
  }

  // Apply color calibration (temp 6750K + magenta 0.03) — Tech Test Look
  if (TECH_TEST_LOOK > 0.5f) {
    r0.xyz = ApplyColorCalibration(r0.xyz);
  }
  
  o0.xyz = r0.xyz;
  o0.w = 0;
  return;
}