#include "./shared.h"

float Max(float x, float y, float z) {
  return max(x, max(y, z));
}

float Max(float x, float y, float z, float w) {
  return max(x, max(y, max(z, w)));
}

float Min(float x, float y, float z) {
  return min(x, min(y, z));
}

float Min(float x, float y, float z, float w) {
  return min(x, min(y, min(z, w)));
}

// from Lilium (Adjusted by Ritsu so might contain bugs)
float3 ApplyCAS(
    Texture2D<float4> SrcImage,
    uint3 center_coords) {
  float3 center_color = SrcImage.Load(center_coords).rgb;
  if (CUSTOM_SHARPNESS == 0.f) return center_color;  // Skip sharpening if amount is zero

#define ENABLE_NORMALIZATION           1u
#define SHARPENING_NORMALIZATION_POINT 125.f  // Normalize luminance (scRGB 1 = 80 & 80 * 125 = 10000)
#define InvertIntermediate             1u     // Street Fighter 6 specific

  float3 a = SrcImage.Load(center_coords + uint3(-1u, -1u, 0u)).rgb;
  float3 b = SrcImage.Load(center_coords + uint3(0u, -1u, 0u)).rgb;
  float3 c = SrcImage.Load(center_coords + uint3(1u, -1u, 0u)).rgb;

  float3 d = SrcImage.Load(center_coords + uint3(-1u, 0u, 0u)).rgb;
  float3 e = center_color;
  float3 f = SrcImage.Load(center_coords + uint3(1u, 0u, 0u)).rgb;

  float3 g = SrcImage.Load(center_coords + uint3(-1u, 1u, 0u)).rgb;
  float3 h = SrcImage.Load(center_coords + uint3(0u, 1u, 0u)).rgb;
  float3 i = SrcImage.Load(center_coords + uint3(1u, 1u, 0u)).rgb;

#if InvertIntermediate
  a = renodx::draw::InvertIntermediatePass(a);
  b = renodx::draw::InvertIntermediatePass(b);
  c = renodx::draw::InvertIntermediatePass(c);

  d = renodx::draw::InvertIntermediatePass(d);
  e = renodx::draw::InvertIntermediatePass(e);
  f = renodx::draw::InvertIntermediatePass(f);

  g = renodx::draw::InvertIntermediatePass(g);
  h = renodx::draw::InvertIntermediatePass(h);
  i = renodx::draw::InvertIntermediatePass(i);
#endif

  // Calculate luminance of center and neighbors
  float aLum = renodx::color::y::from::BT709(a);
  float bLum = renodx::color::y::from::BT709(b);
  float cLum = renodx::color::y::from::BT709(c);

  float dLum = renodx::color::y::from::BT709(d);
  float eLum = renodx::color::y::from::BT709(e);
  float fLum = renodx::color::y::from::BT709(f);

  float gLum = renodx::color::y::from::BT709(g);
  float hLum = renodx::color::y::from::BT709(h);
  float iLum = renodx::color::y::from::BT709(i);

#if ENABLE_NORMALIZATION
  aLum /= SHARPENING_NORMALIZATION_POINT;
  bLum /= SHARPENING_NORMALIZATION_POINT;
  cLum /= SHARPENING_NORMALIZATION_POINT;

  dLum /= SHARPENING_NORMALIZATION_POINT;
  eLum /= SHARPENING_NORMALIZATION_POINT;
  fLum /= SHARPENING_NORMALIZATION_POINT;

  gLum /= SHARPENING_NORMALIZATION_POINT;
  hLum /= SHARPENING_NORMALIZATION_POINT;
  iLum /= SHARPENING_NORMALIZATION_POINT;
#endif

  // Soft min and max.
  //  a b c             b
  //  d e f * 0.5  +  d e f * 0.5
  //  g h i             h
  // These are 2.0x bigger (factored out the extra multiply).
  // Min and max of ring.
  float minLum = Min(Min(dLum, eLum, fLum), bLum, hLum);
  float maxLum = Max(Max(dLum, eLum, fLum), bLum, hLum);

  minLum += Min(Min(minLum, aLum, cLum), gLum, iLum);
  maxLum += Max(Max(maxLum, aLum, cLum), gLum, iLum);

  // Smooth minimum distance to signal limit divided by smooth max.
  float rcpMaxLum = rcp(maxLum);

  // Shaping amount of sharpening.
  float amplifyLum = sqrt(saturate(min(minLum, 2.f - maxLum) * rcpMaxLum));

  // Filter shape.
  //  0 w 0
  //  w 1 w
  //  0 w 0

  float weight = amplifyLum * CUSTOM_SHARPNESS;

  float rcpWeight = rcp(4.f * weight + 1.f);

  float outputLum = ((bLum + dLum + fLum + hLum) * weight + eLum) * rcpWeight;

  float3 output = max(outputLum / eLum, 0.f) * e;

#if InvertIntermediate
  output = renodx::draw::RenderIntermediatePass(output);
#endif

  return output;
}
