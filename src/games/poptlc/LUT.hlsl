#include "./shared.h"
#include "./ColorGradingLUT.hlsl"
#include "./DICE.hlsl"

cbuffer cb0 : register(b0)
{
  float4 cb0[145];
}

#if 0 // Duplicate
// Takes any original color (before some post process is applied to it) and re-applies the same transformation the post process had applied to it on a different (but similar) color.
// The images are expected to have roughly the same mid gray.
// It can be used for example to apply any SDR LUT or SDR color correction on an HDR color.
float3 RestorePostProcess(const float3 nonPostProcessedTargetColor, const float3 nonPostProcessedSourceColor, const float3 postProcessedSourceColor)
{
  static const float MaxShadowsColor = pow(1.f / 3.f, 2.2f); // The lower this value, the more "accurate" is the restoration (math wise), but also more error prone (e.g. division by zero)

    const float3 postProcessColorRatio = safeDivision(postProcessedSourceColor, nonPostProcessedSourceColor, 1);
    const float3 postProcessColorOffset = postProcessedSourceColor - nonPostProcessedSourceColor;
    const float3 postProcessedRatioColor = nonPostProcessedTargetColor * postProcessColorRatio;
    const float3 postProcessedOffsetColor = nonPostProcessedTargetColor + postProcessColorOffset;
    // Near black, we prefer using the "offset" (sum) pp restoration method, as otherwise any raised black would not work,
    // for example if any zero was shifted to a more raised color, "postProcessColorRatio" would not be able to replicate that shift due to a division by zero.
    float3 newPostProcessedColor = lerp(postProcessedOffsetColor, postProcessedRatioColor, max(saturate(abs(nonPostProcessedTargetColor / MaxShadowsColor)), saturate(abs(nonPostProcessedSourceColor / MaxShadowsColor))));
    return newPostProcessedColor;
}

// Restores the source color hue through Oklab (this works on colors beyond SDR in brightness and gamut too)
float3 RestoreHue(float3 targetColor, float3 sourceColor, float amount = 0.5)
{
  const float3 targetOklab = renodx::color::oklab::from::BT709(targetColor);
  const float3 targetOklch = renodx::color::oklch::from::OkLab(targetOklab);
  const float3 sourceOklab = renodx::color::oklab::from::BT709(sourceColor);

  // First correct both hue and chrominance at the same time (oklab a and b determine both, they are the color xy coordinates basically).
  // As long as we don't restore the hue to a 100% (which should be avoided), this will always work perfectly even if the source color is pure white (or black, any "hueless" and "chromaless" color).
  // This method also works on white source colors because the center of the oklab ab diagram is a "white hue", thus we'd simply blend towards white (but never flipping beyond it (e.g. from positive to negative coordinates)),
  // and then restore the original chrominance later (white still conserving the original hue direction).
  float3 correctedTargetOklab = float3(targetOklab.x, lerp(targetOklab.yz, sourceOklab.yz, amount));

  // Then restore chrominance
  float3 correctedTargetOklch = renodx::color::oklch::from::OkLab(correctedTargetOklab);
  correctedTargetOklch.y = targetOklch.y;

  return renodx::color::bt709::from::OkLCh(correctedTargetOklch);
}
#endif

float3 LUTShader(float2 inCoords, Texture2D<float4> SourceTexture, Texture2D<float4> BloomTexture, Texture2D<float4> InternalGradingLUT, SamplerState sampler0)
{
  float3 outColor;

  const float sampleBias = cb0[21].x; // Expected to be zero, though it could be used by the game to do a very ugly game blur effect
  float3 sceneColor = SourceTexture.SampleBias(sampler0, inCoords.xy, sampleBias).rgb;
  const float3 bloomColor = BloomTexture.SampleBias(sampler0, inCoords.xy, sampleBias).rgb;

  const float bloomStrength = cb0[142].z; // Expected to be > 0 and < 1
  sceneColor += bloomColor * bloomStrength;

  const float exposure = cb0[130].w;
  sceneColor *= exposure;

  float3 postLutColor;

  if (injectedData.lutExtrapolation) {
    LUTExtrapolationData extrapolationData = DefaultLUTExtrapolationData();
    extrapolationData.inputColor = sceneColor.rgb;
  
    LUTExtrapolationSettings extrapolationSettings = DefaultLUTExtrapolationSettings();
    extrapolationSettings.lutSize = round(1.0 / cb0[130].y);
    // Empirically found value for Prey. Anything less will be too compressed, anything more won't have a noticieable effect.
    // This helps keep the extrapolated LUT colors at bay, avoiding them being overly saturated or overly desaturated.
    // At this point, Prey can have colors with brightness beyond 35000 nits, so obviously they need compressing.
    //extrapolationSettings.inputTonemapToPeakWhiteNits = 1000.0; // Relative to "extrapolationSettings.whiteLevelNits" // NOT NEEDED UNTIL PROVEN OTHERWISE
    // Empirically found value for Prey. This helps to desaturate extrapolated colors more towards their Vanilla (HDR tonemapper but clipped) counterpart, often resulting in a more pleasing and consistent look.
    // This can sometimes look worse, but this value is balanced to avoid hue shifts.
    //extrapolationSettings.clampedLUTRestorationAmount = 1.0 / 4.0; // NOT NEEDED UNTIL PROVEN OTHERWISE
    extrapolationSettings.inputLinear = true;
    extrapolationSettings.lutInputLinear = true;
    extrapolationSettings.lutOutputLinear = true;
    extrapolationSettings.outputLinear = true;
  
    postLutColor = SampleLUTWithExtrapolation(InternalGradingLUT, sampler0, extrapolationData, extrapolationSettings);
  } else {
    // This code looks weird, but it is the standard 2D LUT sampling math, just done with a slightly different order for the math
    const float lutMax = cb0[130].z; // The 3D LUT max: "LUT_SIZE - 1"
    const float2 lutInvSize = cb0[130].xy; // The 3D LUT size (before unwrapping it): "1 / LUT_SIZE", likely equal in value on x and y
    const float2 lutCoordsOffset = float2(0.5, 0.5) * lutInvSize; // The uv bias: "0.5 / LUT_SIZE"
    float3 lutTempCoords3D = saturate(sceneColor) * lutMax;
    float2 lutCoords2D = (lutTempCoords3D.xy * lutInvSize) + lutCoordsOffset;
    float lutSliceIdx = floor(lutTempCoords3D.z);
    // Offset the horizontal axis by the index of z (blue) slice
    lutCoords2D.x += lutSliceIdx * lutInvSize.y;
    float lutSliceFrac = lutTempCoords3D.z - lutSliceIdx;
    float3 lutColor1 = InternalGradingLUT.SampleLevel(sampler0, lutCoords2D, 0).rgb;
    // Sample the next slice
    float3 lutColor2 = InternalGradingLUT.SampleLevel(sampler0, lutCoords2D + float2(lutInvSize.y, 0), 0).rgb;
    // Blend the two slices with the z (blue) ratio
    postLutColor = lerp(lutColor1, lutColor2, lutSliceFrac);
  }
  
  // RenoDX modifications
  if (injectedData.toneMapType == 0) {
    outColor.rgb = postLutColor;
  } else {
    if (injectedData.lutExtrapolation) {
        outColor.rgb = postLutColor.rgb;
    } else {
        outColor.rgb = RestorePostProcess(sceneColor, saturate(sceneColor), postLutColor);
    }

    if (injectedData.toneMapType == 2) {
      DICESettings config = DefaultDICESettings();
      config.Type = 3;
      config.ShoulderStart = injectedData.diceShoulderStart;

      float dicePaperWhite = injectedData.toneMapGameNits / 80.f;
      float dicePeakWhite = injectedData.toneMapPeakNits / 80.f;
      outColor.rgb = DICETonemap(outColor.rgb * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;

      if (injectedData.hueCorrectionStrength > 0.f) {
        outColor.rgb = RestoreHue(outColor.rgb, postLutColor, injectedData.hueCorrectionStrength);
      }
    }
  }

  return outColor;
}