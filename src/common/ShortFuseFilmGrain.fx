#include "ReShade.fxh"

uint seedGen(float2 p) {
  return 19u * p.x + 47u * p.y + 101u;
}

uint wang(uint v) {
  v = (v ^ 61u) ^ (v >> 16u);
  v *= 9u;
  v ^= v >> 4u;
  v *= 0x27d4eb2du;
  v ^= v >> 15u;
  return v;
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
  float result = 3.386477f + (0.08886645f - 3.386477f) / pow(1.f + (scaledX / 2.172591f), 2.240936f);
  return result;
}

// Bartleson
// https://www.imaging.org/common/uploaded%20files/pdfs/Papers/2003/PICS-0-287/8583.pdf
float computeFilmGraininess(float density) {
  float preComputedMin = 7.5857757502918375f;
  if (density < 0)
    return 0;  // Because Luminance can be negative, pow can be unsafe
  float bofDOverC = 0.880f - (0.736f * density) - (0.003f * pow(density, 7.6f));
  return pow(10.f, bofDOverC);
}

float3 computeFilmGrain(float3 color, float2 xy, float seed, float strength, float paperWhite, bool debug) {
  float2 seed2 = seedGen(xy * 43758.5453f + (100.f * seed));
  float hash = wang(wang(seed2.x) + seed2.y);
  float randomNumber = hash / 4294967295.f;

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
  float boost = 1.667f;  // Boost max to 0.05

  float yChange = randomFactor * graininess * strength * boost;
  float3 outputColor = color * (1.f + yChange);

  if (debug) {
    // Output Visualization
    outputColor = abs(yChange);
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

uniform float PAPER_WHITE_NITS < ui_type = "slider";
ui_min = 80;
ui_max = 500;
ui_step = 1;
ui_label = "Paper White Nits";
ui_tooltip = "Brightness of 100% diffuse white (HDR Only)";
> = 203;

uniform float DEBUG_ON < ui_type = "slider";
ui_min = 0;
ui_max = 1;
ui_step = 1;
ui_label = "Debug";
ui_tooltip = "Peak Nits";
> = 0;

uniform float timer < source = "timer"; >;

float3 main(float4 pos : SV_Position, float2 texcoord : TexCoord) : COLOR {
  float3 inputColor = tex2D(ReShade::BackBuffer, texcoord).rgb;
  float3 linearColor = inputColor;
  float3 paperWhite = 1.f;
  switch (BUFFER_COLOR_SPACE) {
    default:
    case 0:
    case 1:
      linearColor = linearColor;
      break;
    case 2:
      paperWhite = PAPER_WHITE_NITS / 203.f;
      break;
    case 3:
      paperWhite = PAPER_WHITE_NITS / 80.f;
      break;
  }

  float3 grainedColor = computeFilmGrain(
    linearColor,
    texcoord.xy,
    frac(timer / 1000.f),
    FILM_GRAIN_STRENGTH / 100.f * 0.05f,
    paperWhite,
    DEBUG_ON == 1.f
  );
  return grainedColor;
  
}

technique ShortFuseFilmGrain {
  pass {
    VertexShader = PostProcessVS;
    PixelShader = main;
  }
}
