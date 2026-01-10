#include "./include/CBuffers.hlsl"
#include "./include/Registers.hlsl"
#include "./shared.h"
#include "./common.hlsl"

float Hash3(float3 v) {
  float3 h = frac(v * 0.1031f);
  h += dot(h, h.zyx + 31.32f);  // Add dot product to ALL components
  return frac((h.x + h.y) * h.z);
}

static const float kLogDynRange = 14.0f;    // how many stops represented
static const float kLogMidGreyLin = 0.18f;  // linear middle grey
static const float kLogMidGreyCode = 444.0f / 1023.0f;

// Linearized from sensor/log-space code values
float3 LogToLinear(float3 logColor) {
  float3 offset = logColor - kLogMidGreyCode;

  // Rewritten exponent form but identical math
  float3 scale = exp2(offset * kLogDynRange);
  return scale * kLogMidGreyLin;
}

float3 LinearToLog(float3 linColor) {
  float3 logLin = log2(max(linColor, 1e-20f));
  float3 code = (logLin - log2(kLogMidGreyLin)) / kLogDynRange + kLogMidGreyCode;
  return saturate(code);
}

float4 Tonemap(
    float4 SV_POSITION: SV_Position,
    float2 input: TEXCOORD) {
  float4 output = 0;
  float exposure = 1.f;     // eyeAdaptation.Load( uint3(0,0,0) ).x;
  float invExposure = 1.f;  // / exposure;

  float2 screenUV = input.xy;

  // Film Grain - Compute film grain noise and pixel jitter
  float grain = 1.0f;
  if (g_useFilmGrain != 0.0f) {
    // Film Grain Noise
    float2 grainUV = (screenUV + float2(g_FilmGrainRandomUVOffset_U, g_FilmGrainRandomUVOffset_V)) * g_FilmGrainScale;
    grain = Hash3(grainUV.xyx);
    // UE4s film grain pixel jitter
    screenUV += (1.0f - grain * grain) * g_FilmGrainJitter * float2(-0.5f, 0.5f);  // in UE4, offset is diagonal
  }

#if defined(USE_CHROMATIC_ABERRATION) || defined(USE_VIGNETTE)
  float2 centeredUV = screenUV - 0.5f;
#endif

#if defined(USE_CHROMATIC_ABERRATION)
  // Compute radial distortion vector for chromatic separation
  float2 aspectCorrectedPos = centeredUV * float2(1.0f, g_CAReciprocalAspectRatio);
  float radiusSq = dot(aspectCorrectedPos, aspectCorrectedPos);
  float aberrationMask = saturate(radiusSq - g_CAStartOffset) * g_CAIntensity;
  float2 aberrationOffset = centeredUV * float2(1.0f, g_CAReciprocalAspectRatio * g_CAAspectRatio) * aberrationMask;

  // Sample each channel at offset UVs to simulate lens dispersion
  float2 uvGreen = screenUV - aberrationOffset * g_CAGreenChannelShiftingFactor;
  float2 uvBlue = screenUV - aberrationOffset * g_CABlueChannelShiftingFactor;

  output.r = texture0.Sample(samplerState0, screenUV).r * exposure
             + texture1.Sample(samplerState0, screenUV).r * invExposure;

  output.g = texture0.Sample(samplerState0, uvGreen).g * exposure
             + texture1.Sample(samplerState0, uvGreen).g * invExposure;

  output.b = texture0.Sample(samplerState0, uvBlue).b * exposure
             + texture1.Sample(samplerState0, uvBlue).b * invExposure;

  output.a = texture0.Sample(samplerState0, screenUV).a
             + texture1.Sample(samplerState0, screenUV).a;
#else
  output += texture0.Sample(samplerState0, screenUV) * exposure
            + texture1.Sample(samplerState0, screenUV) * invExposure;
#endif

#if defined(USE_VIGNETTE)
  // Compute falloff shape blending circle and squircle
  float2 vignetteCoord = centeredUV * float2(1.0f, g_vignetteReciprocalAspectRatio);
  float2 coordSq = vignetteCoord * vignetteCoord;

  float circularFalloff = coordSq.x + coordSq.y;
  float squircularFalloff = length(coordSq);
  float falloffRadius = lerp(squircularFalloff, circularFalloff, g_vignetteRoundness) * g_vignetteOffset;

  float falloffMask = pow(rsqrt(1.0f + falloffRadius), g_vignetteSmoothness);
  falloffMask = lerp(1.0f, falloffMask, g_vignetteColor.a);

  // Blend toward vignette color in darkened regions
  output.rgb = lerp(g_vignetteColor.rgb, output.rgb * falloffMask, falloffMask);
#endif

  // Sample a prebaked LUT
  // Seems to always use this
  if (g_useTonemap_LUT != 0.0f || true) {
    float3 ungraded_bt709 = output.rgb;
    float3 logColor = LinearToLog(output.rgb + LogToLinear(0));
    float3 scale = (g_lutResolution - 1.0f) / g_lutResolution;
    float3 offset = 1.0f / (2.0f * g_lutResolution);
    float3 tonemapCorrectedLinear = lutTexture.Sample(samplerState1, scale * logColor + offset).rgb;
    if (RENODX_TONE_MAP_TYPE) {
      // tonemapCorrectedLinear = renodx::color::bt709::from::AP1(tonemapCorrectedLinear);
      tonemapCorrectedLinear = extractColorGradeAndApplyTonemap(ungraded_bt709, tonemapCorrectedLinear);
    }
    output.rgb = tonemapCorrectedLinear;
  }
  // else
  // // Evaluate tonemap in realtime
  // {
  //   // output.rgb = evaluateCurve(output.rgb);
  // }

  // Film Grain - Apply film grain noise
  if (g_useFilmGrain != 0.0f) {
    [branch]
    if (CUSTOM_FILM_GRAIN_TYPE) {
      output.rgb = renodx::effects::ApplyFilmGrain(
          output.rgb,
          screenUV,
          grain,
          g_FilmGrainIntensity * 0.03,
          1.f);
    } else {
      float luminanceGrain = (grain - 0.5f) * g_FilmGrainIntensity + 1.0f;
      output *= luminanceGrain;
    }
  }

  [branch]
  if (RENODX_TONE_MAP_TYPE) {
    output.rgb = renodx::draw::RenderIntermediatePass(output.rgb);
  }
  return max(output, float4(0, 0, 0, output.w));
}
