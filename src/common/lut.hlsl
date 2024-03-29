#include "./color.hlsl"

// https://www.glowybits.com/blog/2016/12/21/ifl_iss_hdr_1/
float ColorGradeSmoothClamp(float x) {
  const float u = 0.525;
  float q = (2.0 - u - 1.0 / u + x * (2.0 + 2.0 / u - x / u)) / 4.0;
  return (abs(1.0 - x) < u) ? q : saturate(x);
}

float3 centerLutTexel(float3 color, float size) {
  float scale = (size - 1.f) / size;
  float offset = 1.f / (2.f * size);
  return scale * color + offset;
}

float3 sampleLUT(Texture3D lut, SamplerState samplerState, float3 color, float size = 0) {
  if (size == 0) {
    // Removed by compiler if specified
    float width;
    float height;
    float depth;
    lut.GetDimensions(width, height, depth);
    size = height;
  }

  float3 position = centerLutTexel(color, size);

  return lut.SampleLevel(samplerState, position, 0.0f).rgb;
}

float3 sampleLUT(Texture2D lut, SamplerState samplerState, float3 color, float size = 0) {
  if (size == 0) {
    // Removed by compiler if specified
    float width;
    float height;
    lut.GetDimensions(width, height);
    size = min(width, height);
  }
  float zPosition = color.z * size - 0.5;
  float zInteger = floor(zPosition);
  half fraction = zPosition - zInteger;

  float slice = 1.f / size;
  float2 uv = float2(
    (color.x + zInteger) * slice,
    color.y
  );

  float3 color0 = lut.SampleLevel(samplerState, uv, 0).rgb;

  uv.x += slice;
  float3 color1 = lut.SampleLevel(samplerState, uv, 0).rgb;

  return lerp(color0, color1, fraction);
}

// Untested
float3 loadLUT(float3 color, Texture2D lut, float size = 0) {
  if (size == 0) {
    // Removed by compiler if specified
    float width;
    float height;
    lut.GetDimensions(width, height);
    size = min(width, height);
  }

  float positionMax = size - 1.f;

  float3 texelFirst = floor(color * positionMax);
  float3 texelSecond = ceil(color * positionMax);

  float3 texelFirstUV = float3(
    texelSecond.z * positionMax + texelFirst.x,
    texelFirst.y,
    0
  );
  float3 texelSecondUV = float3(
    texelSecond.z * positionMax + texelSecond.x,
    texelSecond.y,
    0
  );

  float3 color0 = lut.Load(texelFirstUV).rgb;
  float3 color1 = lut.Load(texelSecondUV).rgb;
  return lerp(color0, color1, frac(color * positionMax));
}

float3 lutCorrectionBlack(float3 inputColor, float3 lutColor, float lutBlackY, float strength) {
  const float inputY = yFromBT709(inputColor);
  const float colorY = yFromBT709(lutColor);
  const float a = lutBlackY;
  const float b = lerp(0, lutBlackY, strength);
  const float g = inputY;
  const float h = colorY;
  const float newY = h - pow(lutBlackY, pow(1.f + g, b / a));
  lutColor *= (colorY > 0) ? min(colorY, newY) / colorY : 1.f;
  return lutColor;
}

float3 lutCorrectionWhite(float3 inputColor, float3 lutColor, float lutWhiteY, float targetWhiteY, float strength) {
  const float inputY = yFromBT709(inputColor);
  const float colorY = yFromBT709(lutColor);
  const float a = lutWhiteY / targetWhiteY;
  const float b = lerp(1.f, 0.f, strength);
  const float g = inputY;
  const float h = colorY;
  const float newY = h * pow((1.f / a), pow(g / targetWhiteY, b / a));
  lutColor *= (colorY > 0) ? max(colorY, newY) / colorY : 1.f;
  return lutColor;
}
