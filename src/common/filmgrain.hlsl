
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

float3 computeFilmGrain(float3 color, float2 xy, float seed, float strength, float paperWhite = 1.f, bool debug = false) {
  float randomNumber = rand(xy + seed);

  // Film grain is based on film density
  // Film works in negative, meaning black has no density
  // The greater the film density (lighter), more perceived grain
  // Simplified, grain scales with Y

  // Scaling is not not linear

  float colorY = dot(color, float3(0.2126390039920806884765625f, 0.715168654918670654296875f, 0.072192318737506866455078125f));
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
