#ifndef SRC_COMMON_LUT_HLSL_
#define SRC_COMMON_LUT_HLSL_

#include "./color.hlsl"
#include "./math.hlsl"

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

float3 sampleLUT(Texture3D<float3> lut, SamplerState samplerState, float3 color, float size = 0) {
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

float3 sampleLUT(Texture2D lut, SamplerState samplerState, float3 color, float3 precompute) {
  float texelSize = precompute.x;
  float slice = precompute.y;
  float maxIndex = precompute.z;

  float zPosition = color.z * maxIndex;
  float zInteger = floor(zPosition);
  float zFraction = zPosition - zInteger;
  float zOffset = zInteger * slice;

  float xOffset = (color.r * maxIndex * texelSize) + (texelSize * 0.5f);

  float yOffset = (color.g * maxIndex * slice) + (slice * 0.5f);

  float2 uv = float2(
    zOffset + xOffset,
    yOffset
  );

  float3 color0 = lut.SampleLevel(samplerState, uv, 0).rgb;
  uv.x += slice;
  float3 color1 = lut.SampleLevel(samplerState, uv, 0).rgb;

  return lerp(color0, color1, zFraction);
}

float3 sampleLUT(Texture2D lut, SamplerState samplerState, float3 color, float size = 0) {
  if (size == 0) {
    // Removed by compiler if specified
    float width;
    float height;
    lut.GetDimensions(width, height);
    size = min(width, height);
  }

  float maxIndex = size - 1.f;
  float slice = 1.f / size;
  float texelSize = slice * slice;

  return sampleLUT(lut, samplerState, color, float3(texelSize, slice, maxIndex));
}

float3 sampleLUT(Texture2D<float3> lut, SamplerState samplerState, float3 color, float3 precompute) {
  float texelSize = precompute.x;
  float slice = precompute.y;
  float maxIndex = precompute.z;

  float zPosition = color.z * maxIndex;
  float zInteger = floor(zPosition);
  float zFraction = zPosition - zInteger;
  float zOffset = zInteger * slice;

  float xOffset = (color.r * maxIndex * texelSize) + (texelSize * 0.5f);

  float yOffset = (color.g * maxIndex * slice) + (slice * 0.5f);

  float2 uv = float2(
    zOffset + xOffset,
    yOffset
  );

  float3 color0 = lut.SampleLevel(samplerState, uv, 0).rgb;
  uv.x += slice;
  float3 color1 = lut.SampleLevel(samplerState, uv, 0).rgb;

  return lerp(color0, color1, zFraction);
}

float3 sampleLUT(Texture2D<float3> lut, SamplerState samplerState, float3 color, float size = 0) {
  if (size == 0) {
    // Removed by compiler if specified
    float width;
    float height;
    lut.GetDimensions(width, height);
    size = min(width, height);
  }

  float maxIndex = size - 1.f;
  float slice = 1.f / size;
  float texelSize = slice * slice;

  return sampleLUT(lut, samplerState, color, float3(texelSize, slice, maxIndex));
}

float3 sampleLUTUnreal(Texture2D lut, SamplerState samplerState, float3 color, float size = 0) {
  if (size == 0) {
    // Removed by compiler if specified
    float width;
    float height;
    lut.GetDimensions(width, height);
    size = min(width, height);
  }
  float slice = 1.f / size;

  float zPosition = color.z * size - 0.5;
  float zInteger = floor(zPosition);
  half fraction = zPosition - zInteger;

  float2 uv = float2(
    (color.r + zInteger) * slice,
    color.g
  );

  float3 color0 = lut.SampleLevel(samplerState, uv, 0).rgb;
  uv.x += slice;
  float3 color1 = lut.SampleLevel(samplerState, uv, 0).rgb;

  return lerp(color0, color1, fraction);
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
  const float inputY = min(targetWhiteY, yFromBT709(inputColor));
  const float colorY = yFromBT709(lutColor);
  const float a = lutWhiteY / targetWhiteY;
  const float b = lerp(1.f, 0.f, strength);
  const float g = inputY;
  const float h = colorY;
  const float newY = h * pow((1.f / a), pow(g / targetWhiteY, b / a));
  lutColor *= (colorY > 0) ? max(colorY, newY) / colorY : 1.f;
  return lutColor;
}

float3 unclampSDRLUT(
  float3 originalGamma,
  float3 blackGamma,
  float3 midGrayGamma,
  float3 whiteGamma,
  float3 neutralGamma
) {
  float3 addedGamma = blackGamma;
  float3 removedGamma = 1.f - min(1.f, whiteGamma);

  float midGrayAvg = (midGrayGamma.r + midGrayGamma.g + midGrayGamma.b) / 3.f;

  // Remove relative to distance to inverse midgray
  float shadowLength = 1.f - midGrayAvg;
  float shadowStop = max(neutralGamma.r, max(neutralGamma.g, neutralGamma.b));
  float3 removeFog = addedGamma * max(0, shadowLength - shadowStop) / shadowLength;

  // Add back relative to distance from midgray
  float highlightsLength = midGrayAvg;
  float highlightsStop = 1.f - min(neutralGamma.r, min(neutralGamma.g, neutralGamma.b));
  float3 liftHighlights = removedGamma * (max(0, highlightsLength - highlightsStop) / highlightsLength);

  float3 unclampedInGamma = max(0, originalGamma - removeFog) + liftHighlights;
  return unclampedInGamma;
}

float3 recolorUnclampedLUT(float3 originalLinear, float3 unclampedLinear) {
  const float3 originalLab = okLabFromBT709(originalLinear);

  float3 retintedLab = okLabFromBT709(unclampedLinear);
  retintedLab[0] = max(0, retintedLab[0]);
  retintedLab[1] = originalLab[1];
  retintedLab[2] = originalLab[2];

  float3 outputLinear = bt709FromOKLab(retintedLab);

  outputLinear = mul(BT709_2_AP1_MAT, outputLinear);  // Convert to AP1
  outputLinear = max(0, outputLinear);                // Clamp to AP1
  outputLinear = mul(AP1_2_BT709_MAT, outputLinear);  // Convert BT709
  return outputLinear;
}

// Sample that allows to go beyond the 0-1 coordinates range through extrapolation.
// It finds the rate of change (acceleration) of the LUT color around the requested clamped coordinates, and guesses what color the sampling would have with the out of range coordinates.
// Extrapolating LUT by re-apply the rate of change has the benefit of consistency. If the LUT has the same color at (e.g.) uv 0.9 0.9 and 1.0 1.0, thus clipping to white or black, the extrapolation will also stay clipped.
// Additionally, if the LUT had inverted colors or highly fluctuating colors, extrapolation would work a lot better than a raw LUT out of range extraction with a luminance multiplier.
// 
// This function does not acknowledge the LUT transfer function nor any specific LUT properties.
// This function allows your to pick whether you want to extrapolate diagonal, horizontal or veretical coordinates.
// Note that this function might return "invalid colors", they could have negative values etc etc, so make sure to clamp them after if you need to.
// This version is for a 2D float4 texture with a single gradient (not a 3D map reprojected in 2D with horizontal/vertical slices), but the logic applies to 3D textures too.
// 
// "unclampedUV" is expected to have been remapped within the range that excludes that last half texels at the edges.
// "extrapolationDirection" 0 is both hor and ver. 1 is hor only. 2 is ver only.
float4 sampleLUTWithExtrapolation(Texture2D<float4> lut, SamplerState samplerState, float2 unclampedUV, const int extrapolationDirection = 0)
{
    // LUT size in texels
    float lutWidth;
    float lutHeight;
    lut.GetDimensions(lutWidth, lutHeight);
    const float2 lutSize = float2(lutWidth, lutHeight);
    const float2 lutMax = lutSize - 1.0;
    const float2 uvScale = lutMax / lutSize; // Also "1-(1/lutSize)"
    const float2 uvOffset = 1.0 / (2.0 * lutSize); // Also "(1/lutSize)/2"
    // The uv distance between the center of one texel and the next one
    const float2 lutTexelRange = 1.0 / lutMax;
    
    // Remap the input coords to also include the last half texels at the edges, essentually working in full 0-1 range,
    // we will re-map them out when sampling, this is essential for proper extrapolation math.
    unclampedUV = (unclampedUV - uvOffset) / uvScale;
    
    const float2 clampedUV = saturate(unclampedUV);
    const float distanceFromUnclampedToClamped = length(unclampedUV - clampedUV);
    const bool uvOutOfRange = distanceFromUnclampedToClamped > FLT_MIN; // Some threshold is needed to avoid divisions by tiny numbers
    
    const float4 clampedSample = lut.Sample(samplerState, (clampedUV * uvScale) + uvOffset).xyzw; // Use "clampedUV" instead of "unclampedUV" as we don't know what kind of sampler was in use here
    
    if (uvOutOfRange && extrapolationDirection >= 0) {
        float2 centeredUV;
        // Diagonal
        if (extrapolationDirection == 0) {
            // Find the direction between the clamped and unclamped coordinates, flip it, and use it to determine
            // where more centered texel for extrapolation is.
            centeredUV = clampedUV - (normalize(unclampedUV - clampedUV) * (1.0 - lutTexelRange));
        }
        // Horizontal or Vertical (use Diagonal if you want both Horizontal and Vertical at the same time)
        else {
            const bool extrapolateHorizontalCoordinates = extrapolationDirection == 0 || extrapolationDirection == 1;
            const bool extrapolateVerticalCoordinates = extrapolationDirection == 0 || extrapolationDirection == 2;
            centeredUV = float2(clampedUV.x >= 0.5 ? max(clampedUV.x - lutTexelRange.x, 0.5) : min(clampedUV.x + lutTexelRange.x, 0.5), clampedUV.y >= 0.5 ? max(clampedUV.y - lutTexelRange.y, 0.5) : min(clampedUV.y + lutTexelRange.y, 0.5));
            centeredUV = float2(extrapolateHorizontalCoordinates ? centeredUV.x : unclampedUV.x, extrapolateVerticalCoordinates ? centeredUV.y : unclampedUV.y);
        }
        
        const float4 centeredSample = lut.Sample(samplerState, (centeredUV * uvScale) + uvOffset).xyzw;
        // Note: if we are only doing "Horizontal" or "Vertical" extrapolation, we could replace this "length()" calculation with a simple subtraction
        const float distanceFromClampedToCentered = length(clampedUV - centeredUV);
        const float extrapolationRatio = distanceFromClampedToCentered == 0.0 ? 0.0 : (distanceFromUnclampedToClamped / distanceFromClampedToCentered);
        const float4 extrapolatedSample = lerp(centeredSample, clampedSample, 1.0 + extrapolationRatio);
        return extrapolatedSample;
    }
    return clampedSample;
}

#endif  // SRC_COMMON_LUT_HLSL_
