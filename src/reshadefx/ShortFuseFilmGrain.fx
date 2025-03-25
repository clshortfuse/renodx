// https://github.com/crosire/reshade-shaders/blob/slim/REFERENCE.md

#include "ReShade.fxh"

#define COLOR_SPACE_UNKNOWN 0u
#define COLOR_SPACE_SRGB 1u
#define COLOR_SPACE_SCRGB 2u
#define COLOR_SPACE_HDR10_PQ 3u
#define COLOR_SPACE_HDR10_HLG 4u

#if (!defined(BUFFER_COLOR_SPACE) || (BUFFER_COLOR_SPACE == COLOR_SPACE_UNKNOWN) || (BUFFER_COLOR_SPACE == COLOR_SPACE_SRGB))
#define IS_SDR
#else
#define IS_HDR
#endif

// Better random generator
float rand(float2 uv) {
  return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453123);
}

// This is an attempt to replicate Kodak Vision 5242 with (0,3) range:
// Should be channel independent (R/G/B), but just using R curve for now
// Reference target is actually just luminance * 2.046f;
// (0, 0)
// (0.5, 0.22)
// (1.5, 1.08)
// (2.5, 2.01)
// (3.0, 2.3)
float computeFilmDensity(float luminance) {
  float scaledX = luminance * 3.0f;
  float result = 3.386477f + (0.08886645f - 3.386477f) /
                                 pow(1.f + (scaledX / 2.172591f), 2.240936f);
  return result;
}

// Bartleson
// https://www.imaging.org/common/uploaded%20files/pdfs/Papers/2003/PICS-0-287/8583.pdf
float computeFilmGraininess(float density) {
  float preComputedMin = 7.5857757502918375f;
  if (density < 0)
    return 0; // Because Luminance can be negative, pow can be unsafe
  float bofDOverC = 0.880f - (0.736f * density) - (0.003f * pow(density, 7.6f));
  return pow(10.f, bofDOverC);
}

float3 computeFilmGrain(float3 color, float2 xy, float seed, float strength,
                        float paperWhite, bool debug) {
  float randomNumber = rand(xy + seed);

  // Film grain is based on film density
  // Film works in negative, meaning black has no density
  // The greater the film density (lighter), more perceived grain
  // Simplified, grain scales with Y

  // Scaling is not not linear

  float colorY = dot(color, float3(0.2126, 0.7152, 0.0722));
  //
  float adjustedColorY = colorY * (1.f / paperWhite);

  // Emulate density from a chosen film stock (Removed)
  // float density = computeFilmDensity(adjustedColorY);

  // Ideal film density matches 0-3. Skip emulating film stock
  // https://www.mr-alvandi.com/technique/measuring-film-speed.html
  float density = adjustedColorY * 3.f;

  float graininess = computeFilmGraininess(density);
  float randomFactor = (randomNumber * 2.f) - 1.f;
  float boost = 1.667f; // Boost max to 0.05

  float yChange = randomFactor * graininess * strength * boost;
  float3 outputColor = color * (1.f + yChange);

  if (debug) {
    // Output Visualization
    outputColor = abs(yChange) * paperWhite;
  }

  return outputColor;
}

uniform float FILM_GRAIN_STRENGTH < ui_type = "slider";
ui_min = 0;
ui_max = 100;
ui_step = 1;
ui_label = "Strength";
ui_tooltip = "Strength of film grain";
> = 50;

uniform uint SDR_EOTF < ui_type = "combo";
ui_label = "SDR EOTF";
ui_items = "sRGB\0" "2.2\0" "2.4\0";
#ifndef IS_SDR
hidden = true;
#endif
> = 1u;

uniform float DIFFUSE_WHITE_NITS < ui_type = "slider";
ui_min = 80;
ui_max = 500;
ui_step = 1;
ui_label = "Diffuse White Nits";
#ifndef IS_HDR
hidden = true;
#endif
> = 203;

uniform bool DEBUG_ON < ui_type = "slider";
ui_label = "Debug";
> = 0;

uniform float timer < source = "timer";
> ;

namespace srgb {
float Encode(float channel) {
  return (channel <= 0.0031308f) ? (channel * 12.92f)
                                 : (1.055f * pow(channel, 1.f / 2.4f) - 0.055f);
}
float3 Encode(float3 color) {
  return float3(Encode(color.r), Encode(color.g), Encode(color.b));
}

float Decode(float channel) {
  return (channel <= 0.04045f) ? (channel / 12.92f)
                               : pow((channel + 0.055f) / 1.055f, 2.4f);
}
float3 Decode(float3 color) {
  return float3(Decode(color.r), Decode(color.g), Decode(color.b));
}
}

namespace gamma {
float3 Encode(float3 color, float gamma = 2.2f) {
  return pow(color, 1.f / gamma);
}

float3 Decode(float3 color, float gamma = 2.2f) { return pow(color, gamma); }
}

namespace pq {
static const float M1 = 2610.f / 16384.f;          // 0.1593017578125f;
static const float M2 = 128.f * (2523.f / 4096.f); // 78.84375f;
static const float C1 = 3424.f / 4096.f;           // 0.8359375f;
static const float C2 = 32.f * (2413.f / 4096.f);  // 18.8515625f;
static const float C3 = 32.f * (2392.f / 4096.f);  // 18.6875f;

float3 Encode(float3 color, float scaling = 10000.f) {
  color *= (scaling / 10000.f);
  float3 y_m1 = pow(color, M1);
  return pow((C1 + C2 * y_m1) / (1.f + C3 * y_m1), M2);
}

float3 Decode(float3 color, float scaling = 10000.f) {
  float3 e_m12 = pow(color, 1.f / M2);
  float3 out_color = pow(max(0, e_m12 - C1) / (C2 - C3 * e_m12), 1.f / M1);
  return out_color * (10000.f / scaling);
}
}

float3 main(float4 pos: SV_Position, float2 texcoord: TexCoord) : COLOR {
  const float3 input_color = tex2D(ReShade::BackBuffer, texcoord).rgb;
  float3 linear_color = input_color;
  switch (BUFFER_COLOR_SPACE) {
  default:
  case COLOR_SPACE_UNKNOWN:
  case COLOR_SPACE_SRGB:
    switch (SDR_EOTF) {
    case 0u:
      linear_color = srgb::Decode(input_color);
      break;
    default:
    case 1u:
      linear_color = gamma::Decode(input_color);
      break;
    case 2u:
      linear_color = gamma::Decode(input_color, 2.4f);
      break;
    }
    break;
  case COLOR_SPACE_SCRGB:
    linear_color = input_color / DIFFUSE_WHITE_NITS * 80.f;
    break;
  case COLOR_SPACE_HDR10_PQ:
    linear_color = pq::Decode(input_color, DIFFUSE_WHITE_NITS);
    break;
  }

  float3 grained_color = computeFilmGrain(
      linear_color, texcoord.xy, frac(timer / 1000.f),
      FILM_GRAIN_STRENGTH * 0.02f * 0.03f, 1.f, DEBUG_ON == 1.f);

  float3 output_color = grained_color;

  switch (BUFFER_COLOR_SPACE) {
  default:
  case COLOR_SPACE_UNKNOWN:
  case COLOR_SPACE_SRGB:
    switch (SDR_EOTF) {
    case 0u:
      output_color = srgb::Encode(output_color);
      break;
    default:
    case 1u:
      output_color = gamma::Encode(output_color);
      break;
    case 2u:
      output_color = gamma::Encode(output_color, 2.4f);
      break;
    }
    break;
  case COLOR_SPACE_SCRGB:
    output_color = output_color * DIFFUSE_WHITE_NITS / 80.f;
    break;
  case COLOR_SPACE_HDR10_PQ:
    output_color = pq::Encode(output_color, DIFFUSE_WHITE_NITS);
    break;
  }

  return output_color;
}

technique ShortFuseFilmGrain {
  pass {
    VertexShader = PostProcessVS;
    PixelShader = main;
  }
}
