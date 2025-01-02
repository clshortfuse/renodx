#include "./common.hlsl"
#include "./shared.h"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) {
  float4 cb1[8];
}

cbuffer cb0 : register(b0) {
  float4 cb0[10];
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
float4 sampleLUTWithExtrapolation(Texture2D<float4> lut, SamplerState samplerState, float2 unclampedUV, const int extrapolationDirection = 0) {
  // LUT size in texels
  float lutWidth;
  float lutHeight;
  lut.GetDimensions(lutWidth, lutHeight);
  const float2 lutSize = float2(lutWidth, lutHeight);
  const float2 lutMax = lutSize - 1.0;
  const float2 uvScale = lutMax / lutSize;        // Also "1-(1/lutSize)"
  const float2 uvOffset = 1.0 / (2.0 * lutSize);  // Also "(1/lutSize)/2"
  // The uv distance between the center of one texel and the next one
  const float2 lutTexelRange = 1.0 / lutMax;

  // Remap the input coords to also include the last half texels at the edges, essentually working in full 0-1 range,
  // we will re-map them out when sampling, this is essential for proper extrapolation math.
  unclampedUV = (unclampedUV - uvOffset) / uvScale;

  const float2 clampedUV = saturate(unclampedUV);
  const float distanceFromUnclampedToClamped = length(unclampedUV - clampedUV);
  const bool uvOutOfRange = distanceFromUnclampedToClamped > renodx::math::FLT_MIN;  // Some threshold is needed to avoid divisions by tiny numbers

  const float4 clampedSample = lut.Sample(samplerState, (clampedUV * uvScale) + uvOffset).xyzw;  // Use "clampedUV" instead of "unclampedUV" as we don't know what kind of sampler was in use here

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
#if 1  // Lerp in gamma space, this seems to look better for this game (the whole rendering is in gamma space, never linearized), and the "extrapolationRatio" is in gamma space too
    const float4 extrapolatedSample = lerp(centeredSample, clampedSample, 1.0 + extrapolationRatio);
#else  // Lerp in linear space to make it more "accurate"
    const float4 extrapolatedSample = lerp(pow(centeredSample, 2.2), pow(clampedSample, 2.2), 1.0 + extrapolationRatio);
    extrapolatedSample = pow(abs(extrapolatedSample), 1.0 / 2.2) * sign(extrapolatedSample);
#endif
    return extrapolatedSample;
  }
  return clampedSample;
}

void main(float4 v0: SV_POSITION0, float2 v1: TEXCOORD0, float2 w1: TEXCOORD1, out float4 outColor: SV_Target0) {
  const bool vanilla = false;  // Turn on for vanilla behaviour
  const bool extrapolateLUTsMethod = vanilla ? -1 : 1;

  const float4 sceneColor = t0.Sample(s0_s, v1.xy).xyzw;
  
  float lutWidth;
  float lutHeight;
  t4.GetDimensions(lutWidth, lutHeight);
  float xScale = (lutWidth - 1.f) / lutWidth;
  float xOffset = 1.f / (2.f * lutWidth);
  if (vanilla) {
    xScale = 1.0;
    xOffset = 0.0;
  }

  // These are some hardcoded y offsets because the LUTs are designed that way.
  // We remap the LUT horizontal coordinates to account (and exclude) the half texels at the edges.
  float2 lutCoordsBlue = float2((sceneColor.z * xScale) + xOffset, 0.625);
  float2 lutCoordsRed = float2((sceneColor.x * xScale) + xOffset, 0.125);
  float2 lutCoordsGreen = float2((sceneColor.y * xScale) + xOffset, 0.375);

  // Some color map (it seems to be all white except the first row being grey)
  float3 lutA = sampleLUTWithExtrapolation(t4, s4_s, lutCoordsBlue, extrapolateLUTsMethod).xyz * float3(0, 0, 1);  // Only keep "blue"
  lutA += sampleLUTWithExtrapolation(t4, s4_s, lutCoordsRed, extrapolateLUTsMethod).xyz * float3(1, 0, 0);         // Only keep "red"
  lutA += sampleLUTWithExtrapolation(t4, s4_s, lutCoordsGreen, extrapolateLUTsMethod).xyz * float3(0, 1, 0);       // Only keep "green"

  t1.GetDimensions(lutWidth, lutHeight);
  xScale = (lutWidth - 1.f) / lutWidth;
  xOffset = 1.f / (2.f * lutWidth);
  if (vanilla) {
    xScale = 1.0;
    xOffset = 0.0;
  }

  lutCoordsBlue = float2((sceneColor.z * xScale) + xOffset, 0.625);
  lutCoordsRed = float2((sceneColor.x * xScale) + xOffset, 0.125);
  lutCoordsGreen = float2((sceneColor.y * xScale) + xOffset, 0.375);

  // Some color map (a black to white horizontal gradient, with the first row being grey)
  float3 lutB = sampleLUTWithExtrapolation(t1, s2_s, lutCoordsBlue, extrapolateLUTsMethod).xyz * float3(0, 0, 1);  // Only keep "blue"
  lutB += sampleLUTWithExtrapolation(t1, s2_s, lutCoordsRed, extrapolateLUTsMethod).xyz * float3(1, 0, 0);         // Only keep "red"
  lutB += sampleLUTWithExtrapolation(t1, s2_s, lutCoordsGreen, extrapolateLUTsMethod).xyz * float3(0, 1, 0);       // Only keep "green"

  float depth = t2.Sample(s1_s, w1.xy).x;  // Depth (0-1?)
  depth = cb1[7].x * depth + cb1[7].y;     // Near-Far plane adjustment
  float depthInverse = 1.0 / depth;
  float3 fogColor = t3.Sample(s3_s, float2(depthInverse, 0.5)).xyz;  // Depth map (fog color per distance) (the second (y) coordinate is not used as the texture is 1px vertically)
  float3 fogColorLutted = lerp(lutB, lutA, fogColor.xxx);
  float3 someFogVar3 = cb0[3].xyz * fogColorLutted;
  float2 someFogVar1 = someFogVar3.xx + someFogVar3.yz;
  float someFogVar2 = someFogVar3.y * someFogVar1.y;
  float someFogVar4 = (fogColorLutted.z * cb0[3].z) + someFogVar1.x;
  someFogVar2 = sqrt(someFogVar2);
  someFogVar2 = dot(cb0[3].ww, someFogVar2.xx);
  someFogVar2 = someFogVar4 + someFogVar2;
  outColor.xyz = lerp(someFogVar2.xxx, fogColorLutted, cb0[9].xxx);  // Fade to (or away from) color
  outColor.w = sceneColor.w;

  // Tonemapping might also help to fix some scenes that end burning through the UI, possibly because the scene (background) had extremely high values
  if (injectedData.toneMapType == 1) {  // Exponential Rolloff
    outColor.rgb = applyExponentialToneMap(outColor.rgb);
  } else {  // Vanilla, no tonemap, just clipping
    outColor.rgb = saturate(outColor.rgb);
  }
  // Leave output in gamma space and with a paper white of 80 nits even for HDR so we can blend in the UI just like in SDR (in gamma space) and linearize with an extra pass added at the end.

  return;
}
