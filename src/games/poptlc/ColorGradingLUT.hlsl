#include "Math.hlsl"
#include "Color.hlsl"
#include "Oklab.hlsl"

// Make sure to define these to your value, or set it to 0, so it retrieves the size from the LUT (in some functions)
#ifndef LUT_SIZE
#define LUT_SIZE 16u
#endif
#ifndef LUT_MAX
#define LUT_MAX (LUT_SIZE - 1u)
#endif
#ifndef LUT_3D
#define LUT_3D 0
#endif
// 0 None
// 1 Neutral LUT
// 2 Neutral LUT + bypass extrapolation
#ifndef FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE
#define FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE 0
#endif
#ifndef TEST_LUT_EXTRAPOLATION
#define TEST_LUT_EXTRAPOLATION 0
#endif

#if LUT_3D
#define LUT_TEXTURE_TYPE Texture3D
#else
#define LUT_TEXTURE_TYPE Texture2D
#endif

// NOTE: it's possible to add more of these, like PQ or Log3.
#define LUT_EXTRAPOLATION_TRANSFER_FUNCTION_SRGB 0
#define LUT_EXTRAPOLATION_TRANSFER_FUNCTION_GAMMA_2_2 1
#define DEFAULT_LUT_EXTRAPOLATION_TRANSFER_FUNCTION LUT_EXTRAPOLATION_TRANSFER_FUNCTION_GAMMA_2_2

uint3 ConditionalConvert3DTo2DLUTCoordinates(uint3 Coordinates3D, uint lutSize = LUT_SIZE)
{
#if LUT_3D
  return Coordinates3D;
#else
  return uint3(Coordinates3D.x + (Coordinates3D.z * lutSize), Coordinates3D.y, 0);
#endif
}

float calculateExtrapolationLength(float3 centeringNormal)
{
    // Extrapolation lengths based on type of diagonal
    static const float lengthCubeEdge = 1.0;
    static const float lengthSideDiagonal = sqrt(2.0);
    static const float lengthInternalDiagonal = sqrt(3.0);

    // Unit vectors for each color
    // Cube edge
    float3 cubeEdgeVectors[3] = { float3(1, 0, 0), float3(0, 1, 0), float3(0, 0, 1) };
    // Side diagonal
    float3 sideDiagonalVectors[3] = { normalize(float3(1, 1, 0)), normalize(float3(1, 0, 1)), normalize(float3(0, 1, 1)) };
    // Internal diagonal
    float3 internalDiagonalVector = normalize(float3(1, 1, 1));

    // Measure alignment with each axis
    float dotCubeEdge = max(dot(centeringNormal, cubeEdgeVectors[0]), max(dot(centeringNormal, cubeEdgeVectors[1]), dot(centeringNormal, cubeEdgeVectors[2])));
    float dotSideDiagonal = max(dot(centeringNormal, sideDiagonalVectors[0]), max(dot(centeringNormal, sideDiagonalVectors[1]), dot(centeringNormal, sideDiagonalVectors[2])));
    float dotInternalDiagonal = dot(centeringNormal, internalDiagonalVector);

    // Calculate angles in radians
    float angleCubeEdge = acos(dotCubeEdge);
    float angleSideDiagonal = acos(dotSideDiagonal);
    float angleInternalDiagonal = acos(dotInternalDiagonal);

    // Calculate weights based on angles (cosine values)
    float weightCubeEdge = cos(angleCubeEdge);
    float weightSideDiagonal = cos(angleSideDiagonal);
    float weightInternalDiagonal = cos(angleInternalDiagonal);

    // Combine lengths using weights to get final extrapolation length
    float totalWeight = weightCubeEdge + weightSideDiagonal + weightInternalDiagonal;

    return (lengthCubeEdge * weightCubeEdge + lengthSideDiagonal * weightSideDiagonal + lengthInternalDiagonal * weightInternalDiagonal) / totalWeight;
}

// 0 None
// 1 Reduce saturation and increase brightness until luminance is >= 0
// 2 Clip negative colors (makes luminance >= 0)
// 3 Snap to black
void FixColorGradingLUTNegativeLuminance(inout float3 col, uint type = 1)
{
  if (type <= 0) { return; }

  float luminance = GetLuminance(col.xyz);
  if (luminance < -FLT_MIN)
  {
    if (type == 1)
    {
      // Make the color more "SDR" (less saturated, and thus less beyond Rec.709) until the luminance is not negative anymore (negative luminance means the color was beyond Rec.709 to begin with, unless all components were negative).
      // This is preferrable to simply clipping all negative colors or snapping to black, because it keeps some HDR colors, even if overall it's still "black", luminance wise.
      // This should work even in case "positiveLuminance" was <= 0, as it will simply make the color black.
      float3 positiveColor = max(col.xyz, 0.0);
      float3 negativeColor = min(col.xyz, 0.0);
      float positiveLuminance = GetLuminance(positiveColor);
      float negativeLuminance = GetLuminance(negativeColor);
      float negativePositiveLuminanceRatio = positiveLuminance / -negativeLuminance;
      negativeColor.xyz *= negativePositiveLuminanceRatio;
      col.xyz = positiveColor + negativeColor;
    }
    else if (type == 2)
    {
      // This can break gradients as it snaps colors to brighter ones (it depends on how the displays clips HDR10 or scRGB invalid colors)
      col.xyz = max(col.xyz, 0.0);
    }
    else // if (type >= 3)
    {
      col.xyz = 0.0;
    }
  }
}

// Restores the source color hue through Oklab (this works on colors beyond SDR in brightness and gamut too)
float3 RestoreHue(float3 targetColor, float3 sourceColor, float amount = 0.5)
{
  // Invalid or black colors fail oklab conversions or ab blending so early out
  if (GetLuminance(targetColor) <= FLT_MIN)
  {
    // Optionally we could blend the target towards the source, or towards black, but there's no need until proven otherwise
    return targetColor;
  }

  const float3 targetOklab = linear_srgb_to_oklab(targetColor);
  const float3 targetOklch = oklab_to_oklch(targetOklab);
  const float3 sourceOklab = linear_srgb_to_oklab(sourceColor);

  // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
  // As long as we don't restore the hue to a 100% (which should be avoided), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
  // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
  // and then restore the original chrominance later (white still conserving the original hue direction, so likely spitting out the same color as the original, or one very close to it).
  float3 correctedTargetOklab = float3(targetOklab.x, lerp(targetOklab.yz, sourceOklab.yz, amount));

  // Then restore chrominance
  float3 correctedTargetOklch = oklab_to_oklch(correctedTargetOklab);
  correctedTargetOklch.y = targetOklch.y;

  return oklch_to_linear_srgb(correctedTargetOklch);
}

// Takes any original color (before some post process is applied to it) and re-applies the same transformation the post process had applied to it on a different (but similar) color.
// The images are expected to have roughly the same mid gray.
// It can be used for example to apply any SDR LUT or SDR color correction on an HDR color.
float3 RestorePostProcess(const float3 nonPostProcessedTargetColor, const float3 nonPostProcessedSourceColor, const float3 postProcessedSourceColor, float hueRestoration = 0)
{
  static const float MaxShadowsColor = pow(1.f / 3.f, 2.2f); // The lower this value, the more "accurate" is the restoration (math wise), but also more error prone (e.g. division by zero)

	const float3 postProcessColorRatio = safeDivision(postProcessedSourceColor, nonPostProcessedSourceColor, 1);
	const float3 postProcessColorOffset = postProcessedSourceColor - nonPostProcessedSourceColor;
	const float3 postProcessedRatioColor = nonPostProcessedTargetColor * postProcessColorRatio;
	const float3 postProcessedOffsetColor = nonPostProcessedTargetColor + postProcessColorOffset;
	// Near black, we prefer using the "offset" (sum) pp restoration method, as otherwise any raised black would not work,
	// for example if any zero was shifted to a more raised color, "postProcessColorRatio" would not be able to replicate that shift due to a division by zero.
	float3 newPostProcessedColor = lerp(postProcessedOffsetColor, postProcessedRatioColor, max(saturate(abs(nonPostProcessedTargetColor / MaxShadowsColor)), saturate(abs(nonPostProcessedSourceColor / MaxShadowsColor))));

	// Force keep the original post processed color hue.
  // This often ends up shifting the hue too much, either looking too desaturated or too saturated, mostly because in SDR highlights are all burned to white by LUTs, and by the Vanilla SDR tonemappers.
	if (hueRestoration > 0)
	{
		newPostProcessedColor = RestoreHue(newPostProcessedColor, postProcessedSourceColor, hueRestoration);
	}

	return newPostProcessedColor;
}

// Encode.
// Set "mirrored" to true in case the input can have negative values,
// otherwise we run the non mirrored version that is more optimized but might have worse or broken results.
float3 ColorGradingLUTTransferFunctionIn(float3 col, uint transferFunction, bool mirrored = true)
{
  if (transferFunction == LUT_EXTRAPOLATION_TRANSFER_FUNCTION_SRGB)
  {
    return mirrored ? linear_to_sRGB_gamma_mirrored(col) : linear_to_sRGB_gamma(col);
  }
  else // LUT_EXTRAPOLATION_TRANSFER_FUNCTION_GAMMA_2_2
  {
    return mirrored ? linear_to_gamma_mirrored(col) : linear_to_gamma(col);
  }
}
// Decode.
float3 ColorGradingLUTTransferFunctionOut(float3 col, uint transferFunction, bool mirrored = true)
{
  if (transferFunction == LUT_EXTRAPOLATION_TRANSFER_FUNCTION_SRGB)
  {
    return mirrored ? gamma_sRGB_to_linear_mirrored(col) : gamma_sRGB_to_linear(col);
  }
  else // LUT_EXTRAPOLATION_TRANSFER_FUNCTION_GAMMA_2_2
  {
    return mirrored ? gamma_to_linear_mirrored(col) : gamma_to_linear(col);
  }
}

// Use the LUT input transfer function within 0-1 and the LUT output transfer function beyond 0-1 (e.g. sRGB to gamma 2.2),
// this is because LUTs are baked with a gamma mismatch, but for extrapolation, we might only want to replicate the gamma mismatch within the 0-1 range.
float3 ColorGradingLUTTransferFunctionInCorrected(float3 col, uint transferFunctionIn, uint transferFunctionOut)
{
  if (transferFunctionIn != transferFunctionOut)
  {
    float3 reEncodedColor = ColorGradingLUTTransferFunctionIn(col, transferFunctionOut, true);
    float3 colorInExcess = reEncodedColor - saturate(reEncodedColor);
    return ColorGradingLUTTransferFunctionIn(saturate(col), transferFunctionIn, false) + colorInExcess;
  }
  return ColorGradingLUTTransferFunctionIn(col, transferFunctionIn, true);
}

// This perfectly mirrors "ColorGradingLUTTransferFunctionInCorrected()" (e.g. running this after that results in the original color).
float3 ColorGradingLUTTransferFunctionInCorrectedInverted(float3 col, uint transferFunctionIn, uint transferFunctionOut)
{
  if (transferFunctionIn != transferFunctionOut)
  {
    float3 reEncodedColor = ColorGradingLUTTransferFunctionOut(col, transferFunctionOut, true);
    float3 colorInExcess = reEncodedColor - saturate(reEncodedColor);
    return ColorGradingLUTTransferFunctionOut(saturate(col), transferFunctionIn, false) + colorInExcess;
  }
  return ColorGradingLUTTransferFunctionOut(col, transferFunctionIn, true);
}

// Use the LUT output transfer function within 0-1 and the LUT input transfer function beyond 0-1 (e.g. gamma 2.2 to sRGB),
// this is because LUTs are baked with a gamma mismatch, but we only want to replicate the gamma mismatch within the 0-1 range.
float3 ColorGradingLUTTransferFunctionOutCorrected(float3 col, uint transferFunctionIn, uint transferFunctionOut)
{
  if (transferFunctionIn != transferFunctionOut)
  {
    float3 reEncodedColor = ColorGradingLUTTransferFunctionOut(col, transferFunctionIn, true);
    float3 colorInExcess = reEncodedColor - saturate(reEncodedColor);
    return ColorGradingLUTTransferFunctionOut(saturate(col), transferFunctionOut, false) + colorInExcess;
  }
  return ColorGradingLUTTransferFunctionOut(col, transferFunctionOut, true);
}

// Optimized merged version of "ColorGradingLUTTransferFunctionInCorrected" and "ColorGradingLUTTransferFunctionOutCorrected".
// If "linearTolinear" is true, we assume linear in and out. Otherwise, we assume the input was encoded with "transferFunctionIn" and encode the output with "transferFunctionOut".
void ColorGradingLUTTransferFunctionInOutCorrected(inout float3 col, uint transferFunctionIn, uint transferFunctionOut, bool linearTolinear)
{
    if (transferFunctionIn != transferFunctionOut)
    {
      if (linearTolinear)
      {
        // E.g. decoding sRGB gamma with gamma 2.2 crushes blacks (which is what we want).
  #if 1 // Equivalent branches (this is the most optimized and most accurate)
        float3 colInExcess = col - saturate(col);
        col = ColorGradingLUTTransferFunctionOut(ColorGradingLUTTransferFunctionIn(saturate(col), transferFunctionIn, false), transferFunctionOut, false);
        col += colInExcess;
  #elif 1
        col = ColorGradingLUTTransferFunctionOutCorrected(ColorGradingLUTTransferFunctionIn(col, transferFunctionIn, true), transferFunctionIn, transferFunctionOut);
  #else
        col = ColorGradingLUTTransferFunctionOut(ColorGradingLUTTransferFunctionInCorrected(col, transferFunctionIn, transferFunctionOut), transferFunctionOut, true);
  #endif
      }
      else
      {
        // E.g. encoding "linear sRGB" with gamma 2.2 raises blacks (which is the opposite of what we want), so we do the opposite (encode "linear 2.2" with sRGB gamma).
  #if 1 // Equivalent branches (this is the most optimized and most accurate)
        float3 colInExcess = col - saturate(col);
        col = ColorGradingLUTTransferFunctionIn(ColorGradingLUTTransferFunctionOut(saturate(col), transferFunctionOut, false), transferFunctionIn, false);
        col += colInExcess;
  #elif 1
        col = ColorGradingLUTTransferFunctionIn(ColorGradingLUTTransferFunctionOutCorrected(col, transferFunctionIn, transferFunctionOut), transferFunctionIn, true);
  #else
        col = ColorGradingLUTTransferFunctionInCorrected(ColorGradingLUTTransferFunctionOut(col, transferFunctionOut, true), transferFunctionIn, transferFunctionOut);
  #endif
      }
    }
}

// Corrects transfer function encoded LUT coordinates to return more accurate LUT colors from linear in/out LUTs.
// This expects input coordinates within the 0-1 range (it should not be used to find the extrapolated (out of range) coordinates, but only on valid LUT coordinates).
float3 AdjustLUTCoordinatesForLinearLUT(const float3 clampedLUTCoordinatesGammaSpace, bool highQuality = true, uint lutTransferFunctionIn = DEFAULT_LUT_EXTRAPOLATION_TRANSFER_FUNCTION, bool lutInputLinear = false, bool lutOutputLinear = false, const float3 lutSize = LUT_SIZE, bool specifyLinearSpaceLUTCoordinates = false, float3 clampedLUTCoordinatesLinearSpace = 0)
{
	if (!specifyLinearSpaceLUTCoordinates)
	{
    clampedLUTCoordinatesLinearSpace = ColorGradingLUTTransferFunctionOut(clampedLUTCoordinatesGammaSpace, lutTransferFunctionIn, false);
	}
  if (lutInputLinear)
  {
#if FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE > 0
    if (highQuality && !lutOutputLinear)
    {
      // The "!lutOutputLinear" case would need coordinate adjustments to sample properly, but "linear in gamma out" LUTs don't really exist as they make no sense so we don't account for that case
    }
#endif
    return clampedLUTCoordinatesLinearSpace;
  }
	if (!lutOutputLinear || !highQuality)
	{
		return clampedLUTCoordinatesGammaSpace;
	}
	// if (!lutInputLinear && lutOutputLinear)
#if FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE > 0 // This case will skip LUT sampling so we shouldn't correct the input coordinates
  // Low quality version with no linear input correction
  return clampedLUTCoordinatesGammaSpace;
#else
  // Given that we haven't scaled for the LUT half texel size, we floor and ceil with the LUT size as opposed to the LUT max
  float3 previousLUTCoordinatesGammaSpace = floor(clampedLUTCoordinatesGammaSpace * lutSize) / lutSize;
  float3 nextLUTCoordinatesGammaSpace = ceil(clampedLUTCoordinatesGammaSpace * lutSize) / lutSize;
  float3 previousLUTCoordinatesLinearSpace = ColorGradingLUTTransferFunctionOut(previousLUTCoordinatesGammaSpace, lutTransferFunctionIn, false);
  float3 nextLUTCoordinatesLinearSpace = ColorGradingLUTTransferFunctionOut(nextLUTCoordinatesGammaSpace, lutTransferFunctionIn, false);
  // Every step size is different as it depends on where we are within the transfer function range.
  const float3 stepSize = nextLUTCoordinatesLinearSpace - previousLUTCoordinatesLinearSpace;
  // If "stepSize" is zero (due to the LUT pixel coords being exactly an integer), whether alpha is zero or one won't matter as "previousLUTCoordinatesGammaSpace" and "nextLUTCoordinatesGammaSpace" will be identical.
  const float3 blendAlpha = safeDivision(clampedLUTCoordinatesLinearSpace - previousLUTCoordinatesLinearSpace, stepSize, 1);
  return lerp(previousLUTCoordinatesGammaSpace, nextLUTCoordinatesGammaSpace, blendAlpha);
#endif
}

// Color grading/charts tex lookup. Called "TexColorChart2D()" in Vanilla code.
float3 SampleLUT(LUT_TEXTURE_TYPE lut, SamplerState samplerState, float3 color, uint lutSize = LUT_SIZE, bool tetrahedralInterpolation = false, bool debugLutInputLinear = false, bool debugLutOutputLinear = false, uint debugLutTransferFunctionIn = DEFAULT_LUT_EXTRAPOLATION_TRANSFER_FUNCTION)
{
#if FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE > 0
  // Do not saturate() "color" on purpose
  if (debugLutInputLinear == debugLutOutputLinear)
  {
    return color;
  }
  return debugLutOutputLinear ? ColorGradingLUTTransferFunctionOut(color, debugLutTransferFunctionIn) : ColorGradingLUTTransferFunctionIn(color, debugLutTransferFunctionIn);
#endif // FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE > 0

	const uint chartDimUint = lutSize;
	const float chartDim	= (float)chartDimUint;
	const float chartDimSqr	= chartDim * chartDim;
	const float chartMax	= chartDim - 1.0;
	const uint chartMaxUint = chartDimUint - 1u;

  if (!tetrahedralInterpolation)
  {
#if LUT_3D
    const float scale = chartMax / chartDim;
    const float bias = 0.5 / chartDim;
    
    float3 lookup = saturate(color) * scale + bias;
    
    return lut.Sample(samplerState, lookup).rgb;
#else // !LUT_3D
    const float3 scale = float3(chartMax, chartMax, chartMax) / chartDim;
    const float3 bias = float3(0.5, 0.5, 0.0) / chartDim;

    float3 lookup = saturate(color) * scale + bias;
    
    // convert input color into 2d color chart lookup address
    float slice = lookup.z * chartDim;	
    float sliceFrac = frac(slice);	
    float sliceIdx = slice - sliceFrac;
    
    lookup.x = (lookup.x + sliceIdx) / chartDim;
    
    // lookup adjacent slices
    float3 col0 = lut.Sample(samplerState, lookup.xy).rgb;
    lookup.x += 1.0 / chartDim;
    float3 col1 = lut.Sample(samplerState, lookup.xy).rgb;

    // linearly blend between slices
    return lerp(col0, col1, sliceFrac); // LUMA FT: changed to be a lerp (easier to read)
#endif // LUT_3D
  }
  else // LUMA FT: added tetrahedral LUT interpolation (from Lilium) (note that this ignores the texture sampler) //TODOFT3: to finish it... It's not working
  {
    const float lutTexelOffsetY = 0.5f /  chartDim;
    const float lutTexelOffsetX = 0.5f / chartDimSqr;

    // We need to clip the input coordinates as LUT texture samples below are not clamped.
    const float3 coords = saturate(color) * chartDimSqr; // Pixel coords 

    // floorCoords are on [0,chartMaxUint]
    float3 floorBaseCoords = floor(coords);
    float3 floorNextCoords = min(floorBaseCoords + 1.f, chartMaxUint);

    // indV2 and indV3 are on [0,chartMaxUint]
    float3 indV2;
    float3 indV3;

    // fract is on [0,1]
    float3 fract = frac(coords);

    const float3 v1 = lut.Load(ConditionalConvert3DTo2DLUTCoordinates(floorBaseCoords, chartDimUint)).rgb;
    const float3 v4 = lut.Load(ConditionalConvert3DTo2DLUTCoordinates(floorNextCoords, chartDimUint)).rgb;

    float3 f1, f2, f3, f4;

    [flatten]
    if (fract.r >= fract.g)
    {
      [flatten]
      if (fract.g >= fract.b)  // R > G > B
      {
        indV2 = float3(1.f, 0.f, 0.f);
        indV3 = float3(1.f, 1.f, 0.f);

        f1 = 1.f - fract.r;
        f4 = fract.b;

        f2 = fract.r - fract.g;
        f3 = fract.g - fract.b;
      }
      else [flatten] if (fract.r >= fract.b)  // R > B > G
      {
        indV2 = float3(1.f, 0.f, 0.f);
        indV3 = float3(1.f, 0.f, 1.f);

        f1 = 1.f - fract.r;
        f4 = fract.g;

        f2 = fract.r - fract.b;
        f3 = fract.b - fract.g;
      }
      else  // B > R > G
      {
        indV2 = float3(0.f, 0.f, 1.f);
        indV3 = float3(1.f, 0.f, 1.f);

        f1 = 1.f - fract.b;
        f4 = fract.g;

        f2 = fract.b - fract.r;
        f3 = fract.r - fract.g;
      }
    }
    else
    {
      [flatten]
      if (fract.g <= fract.b)  // B > G > R
      {
        indV2 = float3(0.f, 0.f, 1.f);
        indV3 = float3(0.f, 1.f, 1.f);

        f1 = 1.f - fract.b;
        f4 = fract.r;

        f2 = fract.b - fract.g;
        f3 = fract.g - fract.r;
      }
      else [flatten] if (fract.r >= fract.b)  // G > R > B
      {
        indV2 = float3(0.f, 1.f, 0.f);
        indV3 = float3(1.f, 1.f, 0.f);

        f1 = 1.f - fract.g;
        f4 = fract.b;

        f2 = fract.g - fract.r;
        f3 = fract.r - fract.b;
      }
      else  // G > B > R
      {
        indV2 = float3(0.f, 1.f, 0.f);
        indV3 = float3(0.f, 1.f, 1.f);

        f1 = 1.f - fract.g;
        f4 = fract.r;

        f2 = fract.g - fract.b;
        f3 = fract.b - fract.r;
      }
    }

    indV2 = min(floorBaseCoords + indV2, chartMax);
    indV3 = min(floorBaseCoords + indV3, chartMax);

    const float3 v2 = lut.Load(ConditionalConvert3DTo2DLUTCoordinates(indV2, chartDimUint)).rgb;
    const float3 v3 = lut.Load(ConditionalConvert3DTo2DLUTCoordinates(indV3, chartDimUint)).rgb;

    return (f1 * v1) + (f2 * v2) + (f3 * v3) + (f4 * v4);
  }
}

struct LUTExtrapolationData
{
  // The "HDR" color before or after tonemapping to the display capabilities (preferably before, to have more consistent results), it needs to be in the same range as the vanilla color (0.18 as mid gray), with values beyond 1 being out of vanila range (e.g. HDR as opposed to SDR).
  // In other words, this is the LUT input coordinate (once converted the LUT input transfer function).
  // Note that this can be in any color space (e.g. sRGB, scRGB, Rec.709, Rec.2020, ...), it's agnostic from that.
  float3 inputColor;
  
  // The vanilla color the game would have fed as LUT input (so usually after tonemapping, and SDR), it should roughly be in the 0-1 range (you can optionally manually saturate this to make sure of that).
  // This is optional and only used if "vanillaLUTRestorationAmount" is > 0.
  float3 vanillaInputColor;
};

struct LUTExtrapolationSettings
{
  // Set to 0 to find it automatically
  uint lutSize;
  // Is the input color we pass in linear or encoded with a transfer function?
  // If false, the color is expectred to the in the "transferFunctionIn" space.
  bool inputLinear;
  // Does the LUT take linear or transfer function encoded input coordinates/colors?
  bool lutInputLinear;
  // Does the LUT output linear or transfer function encoded colors?
  bool lutOutputLinear;
  // Do we expect this function to output linear or transfer function encoded colors?
  bool outputLinear;
  // What transfer function the LUT used for its input coordinates, if it wasn't linear ("lutInputLinear" false)?
  // Note that this might still be used even if the LUT is linear in input, because the extrapolation logic needs to happen in perceptual space.
  uint transferFunctionIn;
  // What transfer function the LUT used for its output colors, if it wasn't linear ("lutOutputLinear" false)?
  // Note that if this is different from "transferFunctionIn", it doesn't mean that the LUT also directly applies a gamma mismatch within its colors (e.g. for an input of 0.1 it would could still return 0.1),
  // but that the LUT output color was intended to be visualized on a display that used this transfer function.
  // Leave this equal to "transferFunctionIn" if you want to completely ignore any possible transfer function mismatch correction (in case "lutInputLinear" and "lutOutputLinear" were true).
  // If this is different from "transferFunctionIn", then the code will apply a transfer function correction, even if the input or output are linear.
  // Many games use the sRGB transfer function for LUT input, but then they theoretically output gamma 2.2 (as they were developed on and for gamma 2.2 displays),
  // thus their gamma needs to be corrected for that, whether "outputLinear" was true not (set this to "LUT_EXTRAPOLATION_TRANSFER_FUNCTION_GAMMA_2_2" to do the classic SDR gamma correction).
  // The transfer function correction only applies in the LUT range (0-1) and is ignored for colors out of range,
  // given that the transfer function mismatch in out of range values can go wild, and also because in the vanilla version the would have been clipped anyway
  // (this behaviour assumes both input and output were in the 0-1 range, which might not be true depending on the LUT transfer functions, but it's true in the ones we support).
  uint transferFunctionOut;
  // 0 Basic sampling
  // 1 Linear corrected sampling (if "lutOutputLinear" is false this is equal to "0", but if true, the LUT input coordinates need to be adjusted with the inverse of the transfer function, otherwise even a neutral LUT would shift colors that didn't fall precisely on a LUT texel)
  // 2 Linear corrected sampling + tetrahedral interpolation
  uint samplingQuality;
  // Basically an inverse LUT intensity setting.
  // How much we blend back towards the "neutral" LUT color (the unclamped source color (e.g. HDR)).
  // This has the same limitations of "inputTonemapToPeakWhiteNits" and should be used and not used in the same cases.
  // It's generally not suggested to use it as basically it undoes the LUT extrapolation, but if you have LUTs not far from being neutral,
  // you might set this to a smallish value and get better results (e.g. better hues).
  float neutralLUTRestorationAmount;
  // How much we blend back towards the vanilla LUT color (or hue).
  // It can be used to restore some of the vanilla hues on bright (or not bright) colors.
  // This adds one sample per pixel.
  float vanillaLUTRestorationAmount;

  // Enable or disable LUT extrapolation.
  // Use "neutralLUTRestorationAmount" to control the extrapolation intensity
  // (it wouldn't make sense to only partially extrapolate without scaling back the color intensity, otherwise LUT extrapolation would have an output range smaller than its input range).
  bool enableExtrapolation;
  // 0 Low (likely results in major hue shifts) (2 fixed samples per pixel)
  // 1 High (no major hue shifts) (1 fixed sample + 3 optional samples per pixel)
  // 2 Extreme (no major hue shifts, more accurately preserves the rate of change towards the edges of the original LUT (see "extrapolationQuality"), though it's often unnecessary) (1 fixed sample + 6 optional samples per pixel)
  uint extrapolationQuality;
  // LUT extrapolation works by taking more centered samples starting from the "clipped" LUT coordinates (in case the native ones were out of range).
  // This determines how much we go backwards towards the LUT center.
  // The value is supposed to be > 0 and <= 1, with 1 mapping to 50% centering (we shouldn't do any more than that or the extrapolation would not be accurate).
  // The smaller this value, the more "accurate" extrapolation will be, respecting more lawfully the way the LUT changed around its edges (as long as it ends up mapped beyond the first texel center).
  // The higher the value, the "smoother" the extrapolation will be, with gradients possibly looking nicer.
  float backwardsAmount;
  // What white level does the LUT have for its input coordinates (e.g. what's the expected brightness of an input color of 1 1 1?).
  // This value doesn't directly scale the brightness of the output but affects the logic of some internal math (e.g. tonemapping and transfer functions).
  // Ideally it would be set to the same brightness the developers of the LUTs had their screen set to, some good values for SDR LUTs are 80, 100 or 203.
  // Given that this is used as a scaler for PQ, using the Rec.709 white level of 100 nits is a good start, as that maps to ~50% of the PQ range.
  float whiteLevelNits;
  // If our input color was too high (and thus out of range, (e.g. beyond 0-1)), we can temporarily tonemap it to avoid the LUT extrapolation math going wild (e.g. too saturated, or hue shifted),
  // this is especially useful in the following conditions:
  //  -With LUTs that change colors a lot in brightness, especially towards the edges
  //  -When using lower "extrapolationQuality" modes
  //  -When feeding in an untonemapped input color (with values that can possibly go very high)
  // This should not be used in the following conditions:
  //  -With LUTs that change colors a lot in hue and saturation (it might still work)
  //  -With LUTs that at "clipped" (LUTs that reach their peak per axis values before its latest texel)
  //  -With LUTs that invert colors (the tonemapping logic isn't compatible with it increasingly higher input colors mapping to increasingly lower output colors)
  // This is relative to the "whiteLevelNits" and needs to be greater than it.
  // Tonemapping is disabled if this is <= 0.
  float inputTonemapToPeakWhiteNits;
  // How much we blend back towards the "clipped" LUT color.
  // This is different from the vanilla color, as it's sourced from the new (e.g. HDR) input color, but clipped the the LUT input coordinates range (0-1).
  // It can be used to hide some of the weird hues generated from too aggressive extrapolation (e.g. for overly bright input colors, or for the lower "extrapolationQuality" modes).
  float clampedLUTRestorationAmount;
  // LUT extrapolation can generate invalid colors (colors with a negative luminance) if the input color had values below 0,
  // this fixes them in the best possible way without altering their hue wherever possible.
  bool fixExtrapolationInvalidColors;
};

LUTExtrapolationData DefaultLUTExtrapolationData()
{
  LUTExtrapolationData data;
  data.vanillaInputColor = 0;
  return data;
}

LUTExtrapolationSettings DefaultLUTExtrapolationSettings()
{
  LUTExtrapolationSettings settings;
  settings.lutSize = LUT_SIZE;
  settings.inputLinear = true;
  settings.lutInputLinear = false;
  settings.lutOutputLinear = false;
  settings.outputLinear = true;
  settings.transferFunctionIn = DEFAULT_LUT_EXTRAPOLATION_TRANSFER_FUNCTION;
  settings.transferFunctionOut = DEFAULT_LUT_EXTRAPOLATION_TRANSFER_FUNCTION;
  settings.samplingQuality = 1;
  settings.neutralLUTRestorationAmount = 0;
  settings.vanillaLUTRestorationAmount = 0;
  settings.enableExtrapolation = true;
  settings.extrapolationQuality = 1;
  settings.backwardsAmount = 0.5;
  settings.whiteLevelNits = Rec709_WhiteLevelNits;
  settings.inputTonemapToPeakWhiteNits = 0;
  settings.clampedLUTRestorationAmount = 0;
  settings.fixExtrapolationInvalidColors = true;
  return settings;
}

float3 SampleLUT(LUT_TEXTURE_TYPE lut, SamplerState samplerState, float3 encodedCoordinates, LUTExtrapolationSettings settings, bool forceOutputLinear = false, bool specifyLinearColor = false, float3 linearCoordinates = 0)
{
  const bool highQualityLUTCoordinateAdjustments = settings.samplingQuality >= 1;
  const bool tetrahedralInterpolation = settings.samplingQuality >= 2;
  
  float3 sampleCoordinates = AdjustLUTCoordinatesForLinearLUT(encodedCoordinates, highQualityLUTCoordinateAdjustments, settings.transferFunctionIn, settings.lutInputLinear, settings.lutOutputLinear, settings.lutSize, specifyLinearColor, linearCoordinates);
  float3 color = SampleLUT(lut, samplerState, sampleCoordinates, settings.lutSize, tetrahedralInterpolation, settings.lutInputLinear, settings.lutOutputLinear, settings.transferFunctionIn);
  // We appply the transfer function even beyond 0-1 as if the color comes from a linear LUT, it shouldn't already have any kind of gamma correction applied to it (gamma correction runs later).
  if (!settings.lutOutputLinear && forceOutputLinear)
  {
			return ColorGradingLUTTransferFunctionOut(color, settings.transferFunctionIn, true);
  }
  return color;
}

// LUT sample that allows to go beyond the 0-1 coordinates range through extrapolation.
// It finds the rate of change (acceleration) of the LUT color around the requested clamped coordinates, and guesses what color the sampling would have with the out of range coordinates.
// Extrapolating LUT by re-apply the rate of change has the benefit of consistency. If the LUT has the same color at (e.g.) uv 0.9 0.9 0.9 and 1.0 1.0 1.0, thus clipping to white (or black) earlier, the extrapolation will also stay clipped, preserving the artistic intention.
// Additionally, if the LUT had inverted colors or highly fluctuating colors or very hues shifted colors, extrapolation would work a lot better than a raw LUT out of range extraction with a luminance multiplier (or other similar simpler techniques).
// 
// This function allows the LUT to be in linear or transfer function encoded (e.g. gamma space) on input coordinates and output color separately.
// LUTs are expected to be of equal size on each axis (once unwrapped from 2D to 3D).
// LUT extrapolation works best on LUTs that are NOT "clipped" around their edges (e.g. if the 3 last texels on the red axis all map to 255 (in 8bit), LUT extrapolation would either end up also clipping (which was likely not intended in the vanilla LUT and would look bad in HDR), or extrapolating values after a clipped gradient, thus ending up with a gradient like 254 255 255 255 256)
float3 SampleLUTWithExtrapolation(LUT_TEXTURE_TYPE lut, SamplerState samplerState, LUTExtrapolationData data /*= DefaultLUTExtrapolationData()*/, LUTExtrapolationSettings settings /*= DefaultLUTExtrapolationSettings()*/)
{
	float3 lutMax3D;
	if (settings.lutSize == 0)
	{
		// LUT size in texels
		float lutWidth;
		float lutHeight;
#if LUT_3D
		float lutDepth;
		lut.GetDimensions(lutWidth, lutHeight, lutDepth);
		const float3 lutSize3D = float3(lutWidth, lutHeight, lutDepth);
#else
		lut.GetDimensions(lutWidth, lutHeight);
		lutWidth = sqrt(lutWidth); // 2D LUTs usually extend horizontally
		const float3 lutSize3D = float3(lutWidth, lutWidth, lutHeight);
#endif
		settings.lutSize = lutHeight;
		lutMax3D = lutSize3D - 1.0;
	}
	else
	{
		lutMax3D = settings.lutSize - 1u;
	}
	// The uv distance between the center of one texel and the next one (this is before applying the uv bias and scaling later on, that's done when sampling)
	float3 lutTexelRange = 1.0 / settings.lutSize;

  // Theoretically these input colors match the output of a "neutral" LUT, so we call like that for clarity
	float3 neutralLUTColorLinear = data.inputColor;
	float3 neutralLUTColorTransferFunctionEncoded = data.inputColor;
	float3 neutralVanillaColorLinear = data.vanillaInputColor;
	float3 neutralVanillaColorTransferFunctionEncoded = data.vanillaInputColor;

  // Here we need to pick an encoding for the 0-1 range, and one for the range beyond that.
  // For example, sRGB gamma doesn't really make sense beyond the 0-1 range (especially below 0), so it's not exactly compatible with scRGB colors (that go to negative values to represent colors beyond sRGB),
	// but either way, whether we use gamma 2.2 or sRGB encoding beyond the 0-1 range doesn't make that much difference, as neither of the two choices are "correct" or great,
	// using 2.2 might be a bit closer to human perception below 0 than sRGB, while sRGB might be closer to human perception beyond 1 than 2.2, so we can pick whatever is best for your case to increase the quality of extrapolation.
	// We still need to apply gamma correction on output anyway, this doesn't really influence that, it just makes parts of the extrapolation more perception friendly.
  // At the moment we simply use the LUT in transfer function for the whole range, as it's simple and tests shows it works fine.
	if (settings.inputLinear)
	{
#if 0 //TODOFT4: mess around with applying gamma correction here, maybe 2.2 works better than sRGB beyond 0-1 now that we do PQ extrapolation. Below too (take else branch, it changes random stuff)
		neutralLUTColorTransferFunctionEncoded = ColorGradingLUTTransferFunctionInCorrected(neutralLUTColorLinear, settings.transferFunctionIn, settings.transferFunctionOut);
		neutralVanillaColorTransferFunctionEncoded = ColorGradingLUTTransferFunctionInCorrected(neutralVanillaColorLinear, settings.transferFunctionIn, settings.transferFunctionOut);
#else
		neutralLUTColorTransferFunctionEncoded = ColorGradingLUTTransferFunctionIn(neutralLUTColorLinear, settings.transferFunctionIn);
		neutralVanillaColorTransferFunctionEncoded = ColorGradingLUTTransferFunctionIn(neutralVanillaColorLinear, settings.transferFunctionIn);
#endif
	}
	else
	{
#if 0
		neutralLUTColorLinear = ColorGradingLUTTransferFunctionOutCorrected(neutralLUTColorTransferFunctionEncoded, settings.transferFunctionIn, settings.transferFunctionOut);
		neutralVanillaColorLinear = ColorGradingLUTTransferFunctionOutCorrected(neutralVanillaColorTransferFunctionEncoded, settings.transferFunctionIn, settings.transferFunctionOut);
#else
		neutralLUTColorLinear = ColorGradingLUTTransferFunctionOut(neutralLUTColorTransferFunctionEncoded, settings.transferFunctionIn);
		neutralVanillaColorLinear = ColorGradingLUTTransferFunctionOut(neutralVanillaColorTransferFunctionEncoded, settings.transferFunctionIn);
#endif
	}
	const float3 clampedNeutralLUTColorLinear = saturate(neutralLUTColorLinear);

  // Whether the LUT takes linear inputs or not, we encode the input coordinates with the specified input transfer function,
  // so we can later use the perceptual space UVs to run some extrapolation logic.
  // These LUT coordinates are in the 0-1 range (or beyond that), without acknowleding the lut size or lut max (like the half texel around each edge).
	// We purposely don't use "neutralLUTColorLinearTonemapped" here as we want the raw input color.
	const float3 unclampedUV = neutralLUTColorTransferFunctionEncoded;
	const float3 clampedUV = saturate(unclampedUV);
	const float distanceFromUnclampedToClampedUV = length(unclampedUV - clampedUV);
  //TODOFT4: verify this doesn't cause black dots in output due to normalizing smallish vectors (in quality mode 0)
	const bool uvOutOfRange = distanceFromUnclampedToClampedUV > FLT_MIN; // Some threshold is needed to avoid divisions by tiny numbers
  const bool doExtrapolation = settings.enableExtrapolation && uvOutOfRange;
  // The current working space of this function (all colors samples from LUTs need to be in this space, whether they natively already were or not).
  // All rgb colors within the extrapolation branch need to be in linear space (and so are the ones that will come out of it)
	bool lutOutputLinear = settings.lutOutputLinear || doExtrapolation;

  // Use "clampedUV" instead of "unclampedUV" as we don't know what kind of sampler was in use here (it's probably clamped)
	float3 clampedSample = SampleLUT(lut, samplerState, clampedUV, settings, lutOutputLinear, true, clampedNeutralLUTColorLinear);
  float3 outputSample = clampedSample;
  
	if (doExtrapolation)
	{
    float3 neutralLUTColorLinearTonemapped = neutralLUTColorLinear;
    float3 neutralLUTColorLinearTonemappedRestoreRatio = 1;
    // Tonemap colors beyond the 0-1 range (we don't touch colors within the 0-1 range), tonemapping will be inverted later
    if (settings.inputTonemapToPeakWhiteNits > 0)
    {
      const float maxExtrapolationColor = max((settings.inputTonemapToPeakWhiteNits / settings.whiteLevelNits) - 1.0, FLT_MIN);
      const float3 neutralLUTColorInExcessLinear = neutralLUTColorLinear - clampedNeutralLUTColorLinear;
      // Tonemap it with a basic Reinhard (we could do something better but it likely wouldn't improve the results much)
// We can either tonemap by channel or by max channel. Tonemapping by luminance here isn't a good idea because we are interested in reducing the range to a specific max channel value.
#if 1 // By max channel (hue conserving (at least in the color in excess of 0-1), but has inconsistent results depending on the luminance)
      float normalizedNeutralLUTColorInExcessLinear = max3(abs(neutralLUTColorInExcessLinear / maxExtrapolationColor));
      float normalizedNeutralLUTColorInExcessLinearTonemapped = normalizedNeutralLUTColorInExcessLinear / (normalizedNeutralLUTColorInExcessLinear + 1);
      float normalizedNeutralLUTColorInExcessLinearRestoreRatio = safeDivision(normalizedNeutralLUTColorInExcessLinearTonemapped, normalizedNeutralLUTColorInExcessLinear, 1);
      float3 neutralLUTColorInExcessLinearTonemapped = neutralLUTColorInExcessLinear * normalizedNeutralLUTColorInExcessLinearRestoreRatio;
      neutralLUTColorLinearTonemappedRestoreRatio = safeDivision(1.0, normalizedNeutralLUTColorInExcessLinearRestoreRatio, 1);
#else // By channel
      float3 normalizedNeutralLUTColorInExcessLinear = abs(neutralLUTColorInExcessLinear / maxExtrapolationColor);
      float3 neutralLUTColorInExcessLinearTonemapped = (normalizedNeutralLUTColorInExcessLinear / (normalizedNeutralLUTColorInExcessLinear + 1)) * maxExtrapolationColor * sign(neutralLUTColorInExcessLinear);
      neutralLUTColorLinearTonemappedRestoreRatio = safeDivision(neutralLUTColorInExcessLinear, neutralLUTColorInExcessLinearTonemapped, 1);
#endif
      neutralLUTColorLinearTonemapped = clampedNeutralLUTColorLinear + neutralLUTColorInExcessLinearTonemapped;
    }

    // While "centering" the UVs, we need to go backwards by a specific amount.
    // Going back 50% (e.g. from LUT coordinates 1 to 0.5, or 0 to 0.5) can be too much, so we should generally keep it lower than that.
    // Anything lower than 25% will be more accurate but prone to extrapolation looking more aggressive.
		float backwardsAmount = settings.backwardsAmount * 0.5;
// Extrapolation shouldn't run with a "backwards amount" smaller than half a texel, otherwise it will be like sampling the edge coordinates again.
// This is already explained in the settings description so we disabled the safety check.
#if 0
    if (backwardsAmount < lutTexelRange)
    {
      backwardsAmount = lutTexelRange;
    }
#endif

		const float PQNormalizationFactor = HDR10_MaxWhiteNits / settings.whiteLevelNits;

		float3 clampedUV_PQ = Linear_to_PQ(clampedNeutralLUTColorLinear / PQNormalizationFactor); // "clampedNeutralLUTColorLinear" is equal to "ColorGradingLUTTransferFunctionOut(clampedUV, settings.transferFunctionIn, false)"
		float3 unclampedTonemappedUV_PQ = Linear_to_PQ(neutralLUTColorLinearTonemapped / PQNormalizationFactor, 3);
		float3 clampedSample_PQ = Linear_to_PQ(clampedSample / PQNormalizationFactor);

		float3 extrapolatedSample;

#if DEVELOPMENT && 1
    bool oklab = LumaSettings.DevSetting06 >= 0.5;
#else
    bool oklab = false;
#endif

    // Here we do the actual extrapolation logic, which is relatively different depending on the quality mode.
    // LUT extrapolation lerping is best run in perceptual color space instead of linear space.
    // We settled for using PQ after long tests, here's a comparison of all of them: 
    // -PQ allows for a very wide range, it's relatively cheap, and simple to use.
    // -sRGB or gamma 2.2 falters in the range beyond 1, as they were made for SDR.
    // -Oklab/Oklch or Darktable UCS can work, but they seem to break on very bright colors, and are harder to control
    //  (it's hard to find the actual ratio of change for the extrapolation, they easily create invalid colors or broken gradients, and their hue is very hard to control).
    // -Linear just can't work for LUT extrapolation, because it would act very differently depending on the extrapolation direction (e.g. beyond 1 or below 0), given that it's not adjusted by perceptual
    //  (e.g.1 the extrapolation strength between -0.01 and 0.01 or 0.99 and 1.01 would be massively different, even if both of them have the same offset)
		//  (e.g.2 if the LUT sampling coordinates are 1.1, we'd want to extrapolate ~10% more color, but in linear space it would be a lot less than that, thus the peak brightness would be compressed a lot more than it should).
		if (settings.extrapolationQuality <= 0 || oklab)
		{
		  static const float lutDiagonalLength = sqrt(3.0);

      // Find the direction between the clamped and unclamped coordinates, flip it, and use it to determine how much we go backwards when taking the centered sample.
      // For example, if our "centeringNormal" is -1 -1 -1, we'd want to go backwards by our fixed amount, but multiplied by sqrt(3) (the lenght of a cube internal diagonal),
      // while of -1 -1 0, we'd only want to go back by sqrt(2) (the length of a side diagonal), etc etc. This helps keep the centering results consistent independently of their "angle".
		  const float3 centeringNormal = normalize(unclampedUV - clampedUV); // This should always be valid as "unclampedUV" and guaranteed to be different from "clampedUV".
#if 1 // 100% accurate version (not too expensive)
      const float lutBackwardsDiagonalMultiplier = getDistanceFromCubeEdge(centeringNormal);
#elif 0 // Musa's version. Might be cheaper but it currently doesn't seem to work.
      const float lutBackwardsDiagonalMultiplier = calculateExtrapolationLength(abs(centeringNormal)); //TODOFT: delete?
#elif 0 // Approximate cheaper version (it's almost identical)
      const float lutBackwardsDiagonalAlpha = (1.0 - max3(abs(centeringNormal))) / (1.0 - (1.0 / lutDiagonalLength));
      const float lutBackwardsDiagonalMultiplier = lerp(1.0, lutDiagonalLength, lutBackwardsDiagonalAlpha);
#else // Disabled, but can be enabled for a performance boost, ultimately this doesn't make that much difference
      const float lutBackwardsDiagonalMultiplier = 1.0;
#endif

			const float3 centeredUV = clampedUV - (normalize(unclampedUV - clampedUV) * backwardsAmount * lutBackwardsDiagonalMultiplier);
			float3 centeredSample = SampleLUT(lut, samplerState, centeredUV, settings, lutOutputLinear);
			float3 centeredSample_PQ = Linear_to_PQ(centeredSample / PQNormalizationFactor);
			float3 centeredUV_PQ = Linear_to_PQ(ColorGradingLUTTransferFunctionOut(centeredUV, settings.transferFunctionIn, false) / PQNormalizationFactor);

			const float distanceFromUnclampedToClampedUV_PQ = length(unclampedTonemappedUV_PQ - clampedUV_PQ);
			const float distanceFromClampedToCenteredUV_PQ = length(clampedUV_PQ - centeredUV_PQ);
			const float extrapolationRatio = safeDivision(distanceFromUnclampedToClampedUV_PQ, distanceFromClampedToCenteredUV_PQ, 0);
			extrapolatedSample = PQ_to_Linear(lerp(centeredSample_PQ, clampedSample_PQ, 1.0 + extrapolationRatio), 3) * PQNormalizationFactor;
		}
		else if (settings.extrapolationQuality >= 1)
		{
      // We always run the UV centering logic in the vanilla transfer function space (e.g. sRGB), not PQ, as all these transfer functions are reliable enough within the 0-1 range.
			float3 centeredUV = clampedUV + (backwardsAmount * (clampedUV >= 0.5 ? -1 : 1));
			float3 centeredSamples[3] = { clampedSample, clampedSample, clampedSample };
			float3 centeredSamplesPQ[3] = { clampedSample_PQ, clampedSample_PQ, clampedSample_PQ };

#if 1
      const bool secondSampleLessCentered = backwardsAmount > (0.25 + FLT_MIN);
			float backwardsAmount_2 = secondSampleLessCentered ? (backwardsAmount / 2) : (backwardsAmount * 2); // Go in the most sensible direction
			float3 centeredUV_2 = clampedUV + (backwardsAmount_2 * (clampedUV >= 0.5 ? -1 : 1));
#else // This might be more accurate, though it might be more aggressive, and fails to extrapolate properly in case the user set "backwardsAmount" was too close to "lutTexelRange", or if the LUT clipped to the max value before its edges.
      const bool secondSampleLessCentered = backwardsAmount > lutTexelRange;
			float backwardsAmount_2 = secondSampleLessCentered ? lutTexelRange : (backwardsAmount * 2);
			float3 centeredUV_2 = clampedUV + (backwardsAmount_2 * (clampedUV >= 0.5 ? -1 : 1));
#endif
			float3 centeredSamples_2[3] = { clampedSample, clampedSample, clampedSample };
			float3 centeredSamplesPQ_2[3] = { clampedSample_PQ, clampedSample_PQ, clampedSample_PQ };

      // Swap them to avoid having to write more branches below,
      // the second (2) sample is always meant to be closer to the edges (less centered).
      if (settings.extrapolationQuality >= 2 && !secondSampleLessCentered)
      {
        float3 tempCenteredUV = centeredUV;
        centeredUV = centeredUV_2;
        centeredUV_2 = tempCenteredUV;
      }

			for (uint i = 0; i < 3; i++)
			{
				if (unclampedUV[i] != clampedUV[i])
				{
					float3 localCenteredUV = float3(i == 0 ? centeredUV.r : clampedUV.r, i == 1 ? centeredUV.g : clampedUV.g, i == 2 ? centeredUV.b : clampedUV.b);
					centeredSamples[i] = SampleLUT(lut, samplerState, localCenteredUV, settings, lutOutputLinear);
					centeredSamplesPQ[i] = Linear_to_PQ(centeredSamples[i] / PQNormalizationFactor);

          // The highest quality takes more samples and then "averages" them later
					if (settings.extrapolationQuality >= 2)
					{
						localCenteredUV = float3(i == 0 ? centeredUV_2.r : clampedUV.r, i == 1 ? centeredUV_2.g : clampedUV.g, i == 2 ? centeredUV_2.b : clampedUV.b);
						centeredSamples_2[i] = SampleLUT(lut, samplerState, localCenteredUV, settings, lutOutputLinear);
						centeredSamplesPQ_2[i] = Linear_to_PQ(centeredSamples_2[i] / PQNormalizationFactor);
					}
				}
			}

			float3 centeredUV_PQ = Linear_to_PQ(ColorGradingLUTTransferFunctionOut(centeredUV, settings.transferFunctionIn, false) / PQNormalizationFactor);
      // Find the "velocity", or "rate of change" of the color.
      // This isn't simply an offset, it's an offset (the lut sample colors difference) normalized by another offset (the uv coordinates difference),
      // so it's basically the speed with which color changes at this point in the LUT.
			float3 rgbRatioSpeed = safeDivision(clampedSample_PQ - float3(centeredSamplesPQ[0][0], centeredSamplesPQ[1][1], centeredSamplesPQ[2][2]), clampedUV_PQ - centeredUV_PQ);
      float3 rgbRatioAcceleration = 0;
      // High quality: use two extrapolation samples per channel
      // Note that it would be possibly to do the same thing with 3+ channels too, but further samples would have diminishing returns and not help at all in 99% of cases.
			if (settings.extrapolationQuality >= 2) //TODOFT4: try acc concept again!
			{
				float3 centeredUV_PQ_2 = Linear_to_PQ(ColorGradingLUTTransferFunctionOut(centeredUV_2, settings.transferFunctionIn, false) / PQNormalizationFactor);
#if 1
        // Find the acceleration of each color channel as the LUT coordinates move towards the (external) edge.
        // The second (2) sample is always more external, so it's "newer" if we consider time.
        float3 centered2ToCenteredUVOffset = centeredUV_PQ_2 - centeredUV_PQ;
        float3 clampedToCentered2UVOffset = clampedUV_PQ - centeredUV_PQ_2;
			  rgbRatioSpeed = safeDivision(float3(centeredSamplesPQ_2[0][0], centeredSamplesPQ_2[1][1], centeredSamplesPQ_2[2][2]) - float3(centeredSamplesPQ[0][0], centeredSamplesPQ[1][1], centeredSamplesPQ[2][2]), centered2ToCenteredUVOffset);
				float3 rgbRatioSpeed_2 = safeDivision(clampedSample_PQ - float3(centeredSamplesPQ_2[0][0], centeredSamplesPQ_2[1][1], centeredSamplesPQ_2[2][2]), clampedToCentered2UVOffset);
#if 1 // Best version, though it's very aggressive
        rgbRatioAcceleration = safeDivision(rgbRatioSpeed_2 - rgbRatioSpeed, clampedToCentered2UVOffset - centered2ToCenteredUVOffset);
        rgbRatioSpeed = rgbRatioSpeed_2; // Set the latest velocity we found as the final velocity (this is the velocity we'll start from at the edge of the LUT, before adding acceleration)
#elif 1
        // Make an approximate prediction of what the next speed will be, based on the previous two samples
        rgbRatioSpeed = rgbRatioSpeed_2 + (rgbRatioSpeed_2 - rgbRatioSpeed);
#elif 1
        // Find the average of the two speeds, hoping they were going in roughly the same direction (otherwise this might make extrapolation go towards an incorrect direction)
				rgbRatioSpeed = lerp(rgbRatioSpeed, rgbRatioSpeed_2, 0.5);
#endif
#else // Smoother fallback case that doesn't use acceleration
        // Find the mid point between the two centered samples we had, to smooth out any inconsistencies and have a result that is closer to what would be expected by the ratio of change around the LUT edges.
        float3 centeredSamplesPQAverage = lerp(float3(centeredSamplesPQ[0][0], centeredSamplesPQ[1][1], centeredSamplesPQ[2][2]), float3(centeredSamplesPQ_2[0][0], centeredSamplesPQ_2[1][1], centeredSamplesPQ_2[2][2]), 0.5);
        float3 centeredUV_PQAverage = lerp(centeredUV_PQ, centeredUV_PQ_2, 0.5);
				rgbRatioSpeed = safeDivision(clampedSample_PQ - centeredSamplesPQAverage, clampedUV_PQ - centeredUV_PQAverage);
#endif
			}
      
      // Find the actual extrapolation "time", we'll travel away from the LUT edge for this "duration"
			float3 extrapolationRatio = unclampedTonemappedUV_PQ - clampedUV_PQ;

      // Calculate the final extrapolation offset (a "distance") from "speed" and "time"
			float3 extrapolatedOffset = rgbRatioSpeed * extrapolationRatio;
      // Higher quality modes use "acceleration" as opposed to "speed" only
      if (settings.extrapolationQuality >= 2)
			{
        // We are using the basic "distance from acceleration" formula "(v*t) + (0.5*a*t*t)".
        extrapolatedOffset = (rgbRatioSpeed * extrapolationRatio) + (0.5 * rgbRatioAcceleration * extrapolationRatio * extrapolationRatio);
      }
			extrapolatedSample = PQ_to_Linear(clampedSample_PQ + extrapolatedOffset, 3) * PQNormalizationFactor;
		}

    // Apply the inverse of the original tonemap ratio on the new out of range values (this time they are not necessary out the values beyond 0-1, but the values beyond the clamped/vanilla sample).
    // We don't directly apply the inverse tonemapper formula here as that would make no sense.
#if 1 // Optional optimization in case "inputTonemapToPeakWhiteNits" was static (or not...)
		if (settings.inputTonemapToPeakWhiteNits > 0)
#endif
		{
#if 1
      // Try to (partially) consider the new ratio for colors beyond 1, comparing the pre and post LUT (extrapolation) values.
      // For example, if after LUT extrapolation red has been massively compressed, we wouldn't want to apply the inverse of the original tonemapper up to a 100%, or red might go too bright again.
      // Given this is about ratios and perception, it might arguably be better done in PQ space, but given the original tonemapper above was done in linear, for the sake of simplicity we also do this in linear.
			float3 extrapolationRatio = safeDivision(extrapolatedSample - clampedSample, neutralLUTColorLinearTonemapped - saturate(neutralLUTColorLinearTonemapped), 1);
      // To avoid too crazy results, we limit the min/max influence the extrapolation can have on the tonemap restoration. The higher the value, the more accurate and tolerant the results (theoretically, in reality they might cause outlier values).
      static const float maxExtrapolationInfluence = 2.5; // Note: expose parameter if needed
			extrapolatedSample = clampedSample + ((extrapolatedSample - clampedSample) * lerp(1, neutralLUTColorLinearTonemappedRestoreRatio, clamp(extrapolationRatio, 1.0 / maxExtrapolationInfluence, maxExtrapolationInfluence)));
#else // Simpler and faster implementation that doesn't account for the LUT extrapolation ratio of change when applying the inverse of the original tonemap ratio.
			extrapolatedSample = clampedSample + ((extrapolatedSample - clampedSample) * neutralLUTColorLinearTonemappedRestoreRatio);
#endif
		}

    // See the setting description for more information
		if (settings.clampedLUTRestorationAmount > 0)
		{
#if 1
      // Restore the extrapolated sample luminance onto the clamped sample, so we keep the clamped hue and saturation while maintaining the extrapolated luminance.
      float extrapolatedSampleLuminance = GetLuminance(extrapolatedSample);
      float clampedSampleLuminance = GetLuminance(clampedSample);
      float3 extrapolatedClampedSample = clampedSample * max(safeDivision(extrapolatedSampleLuminance, clampedSampleLuminance, 1), 0.0);
#else // Disabled as this can have random results
      float3 unclampedUV_PQ = Linear_to_PQ(neutralLUTColorLinear / PQNormalizationFactor, 3); // "neutralLUTColorLinear" is equal to "ColorGradingLUTTransferFunctionOut(unclampedUV, settings.transferFunctionIn, true)"
			float3 extrapolationRatio = unclampedUV_PQ - clampedUV_PQ;
      // Restore the original unclamped color offset on the clamped sample in PQ space (so it's more perceptually accurate).
      // Note that this will cause hue shifts and possibly very random results, it only works on neutral LUTs.
      // This code is not far from "neutralLUTRestorationAmount".
      // Near black we opt for a sum as opposed to a multiplication, to avoid failing to restore the ratio when the source number is zero.
			float3 extrapolatedClampedSample = PQ_to_Linear(lerp(clampedSample_PQ + extrapolationRatio, clampedSample_PQ * (1.0 + extrapolationRatio), saturate(abs(clampedSample_PQ))), 3) * PQNormalizationFactor;
#endif
			extrapolatedSample = lerp(extrapolatedSample, extrapolatedClampedSample, settings.clampedLUTRestorationAmount);
		}
    
#if 0 // Moved outside of the LUT extrapolation path to apply on all LUT samples, thus avoiding breaking gradients.
    // See the setting description for more information
		if (settings.vanillaLUTRestorationAmount > 0)
		{
			// This is more conservative of Vanilla (e.g. SDR) and can prevent some unexpected extrapolated colors, but it also looks more flat (desaturated).
			float3 vanillaSample = SampleLUT(lut, samplerState, saturate(neutralVanillaColorTransferFunctionEncoded), settings, lutOutputLinear, true, saturate(neutralVanillaColorLinear));
      float extrapolatedSampleLuminance = GetLuminance(extrapolatedSample);
      float vanillaSampleLuminance = GetLuminance(clampedSample);
			float3 extrapolatedVanillaSample = vanillaSample * max(safeDivision(extrapolatedSampleLuminance, vanillaSampleLuminance, 1), 0.0);
			// To avoid this causing incontiguous gradients (because it's only done in the active extrapolation branch),
      // we only do it for colors that move away "enough" from the LUT range (0-1).
      // Theoretically we could just run the vanilla LUT restoration in the non extrapolation branch too, but that would likely look lame.
			extrapolatedSample = lerp(extrapolatedSample, extrapolatedVanillaSample, settings.vanillaLUTRestorationAmount * saturate(abs(extrapolatedSample - clampedSample) / MidGray)); // Note: parametrize the "MidGray" divisor if needed 
		}
#endif

		// We can optionally leave or fix negative luminances colors here in case they were generated by the extrapolation, everything works by channel in Prey, not much is done by luminance, so this isn't needed until proven otherwise
		if (settings.fixExtrapolationInvalidColors) //TODOFT4: test more: does this reduce HDR colors!?
		{
      FixColorGradingLUTNegativeLuminance(extrapolatedSample);
		}

		outputSample = extrapolatedSample;
#if FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE == 2
		outputSample = neutralLUTColorLinear;
#endif // FORCE_NEUTRAL_COLOR_GRADING_LUT_TYPE == 2
#if TEST_LUT_EXTRAPOLATION
		outputSample = 0;
#endif // TEST_LUT_EXTRAPOLATION
	}

  // See the setting description for more information
  // We purposely do this one before "vanillaLUTRestorationAmount", otherwise we'd undo its effects.
  if (settings.neutralLUTRestorationAmount > 0)
	{
    if (!lutOutputLinear)
    {
			outputSample = ColorGradingLUTTransferFunctionOut(outputSample, settings.transferFunctionIn, true);
      lutOutputLinear = true;
    }
    outputSample = lerp(outputSample, neutralLUTColorLinear, settings.neutralLUTRestorationAmount);
  }
  
  // See the setting description for more information
	if (settings.vanillaLUTRestorationAmount > 0)
	{
    // Note that if the vanilla game had UNORM8 LUTs but for our mod they were modified to be FLOAT16, then maybe we'd want to saturate "vanillaSample", but it's not really needed until proved otherwise
		float3 vanillaSample = SampleLUT(lut, samplerState, saturate(neutralVanillaColorTransferFunctionEncoded), settings, true, true, saturate(neutralVanillaColorLinear));
    if (!lutOutputLinear)
    {
			outputSample = ColorGradingLUTTransferFunctionOut(outputSample, settings.transferFunctionIn, true);
      lutOutputLinear = true;
    }
    outputSample = RestoreHue(outputSample, vanillaSample, settings.vanillaLUTRestorationAmount);
	}

  // If the input and output transfer functions are different, this will perform a transfer function correction (e.g. the typical SDR gamma mismatch: game encoded with gamma sRGB and was decode with gamma 2.2).
  // The best place to do "gamma correction" after LUT sampling and after extrapolation.
  // Most LUTs don't have enough precision (samples) near black to withstand baking in correction.
	// LUT extrapolation is also more correct when run in sRGB gamma, as that's the LUT "native" gamma, correction should still be computed later, only in the 0-1 range.
	// Encoding (gammification): sRGB (from 2.2) crushes blacks, 2.2 (from sRGB) raises blacks.
	// Decoding (linearization): sRGB (from 2.2) raises blacks, 2.2 (from sRGB) crushes blacks.
	if (!lutOutputLinear && settings.outputLinear)
	{
		outputSample.xyz = ColorGradingLUTTransferFunctionOutCorrected(outputSample.xyz, settings.transferFunctionIn, settings.transferFunctionOut);
	}
	else if (lutOutputLinear && !settings.outputLinear)
	{
		if (settings.transferFunctionIn != settings.transferFunctionOut)
		{
		  outputSample.xyz = ColorGradingLUTTransferFunctionIn(outputSample.xyz, settings.transferFunctionIn, true);
      ColorGradingLUTTransferFunctionInOutCorrected(outputSample.xyz, settings.transferFunctionIn, settings.transferFunctionOut, false);
		}
    else //TODOFT4: all "ENABLE_GAMMA_CORRECTION", "POST_PROCESS_SPACE_TYPE" "linear"... branches/defines
    {
		  outputSample.xyz = ColorGradingLUTTransferFunctionIn(outputSample.xyz, settings.transferFunctionOut, true);
    }
	}
	else if (lutOutputLinear && settings.outputLinear)
	{
    ColorGradingLUTTransferFunctionInOutCorrected(outputSample.xyz, settings.transferFunctionIn, settings.transferFunctionOut, true);
	}
	else if (!lutOutputLinear && !settings.outputLinear)
	{
    ColorGradingLUTTransferFunctionInOutCorrected(outputSample.xyz, settings.transferFunctionIn, settings.transferFunctionOut, false);
	}
	return outputSample;
}
