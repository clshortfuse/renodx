#include "./shared.h"

float3 ApplyFakeHDRGain(float3 color, float gainScale, float threshold, float saturationMultiplier)
{
    const float EPSILON = 1e-6;
    const float3 lumaCoeff = float3(0.2126, 0.7152, 0.0722);
    float intensity = gainScale - 1.0;

    // Original luminance + chroma
    float luminanceInput = dot(color, lumaCoeff);
    float3 chromaInput = color - luminanceInput.xxx;
    float chromaInputMagnitude = max(length(chromaInput), EPSILON);

    // --- 1) Smooth exponential threshold mask ---
    float3 gainMask = 1.0 - exp(- (color / max(threshold, EPSILON)));
    gainMask = pow(gainMask, 1.5);

    // The mask for *decreasing* dark areas (Inverse of the gain mask)
    // This allows us to reduce darks (or lift blacks/shadows, depending on application)
    // or simply targets a reduction effect to the areas *not* targeted by the gain.
    float3 reductionMask = 1.0 - gainMask;
    
    // Select which mask to use based on the sign of intensity
    float3 finalMask = (intensity >= 0.0) ? gainMask : reductionMask;

    // This ensures the magnitude is always positive and the effect is explicitly a gain or a reduction.
    float effectMagnitude = abs(intensity);
    float3 changeFactor = effectMagnitude * luminanceInput * finalMask;
 
    // If intensity > 0 (Gain), we ADD the change factor.
    // If intensity < 0 (Darkening), we SUBTRACT the change factor.
    float3 gainMasked = (intensity >= 0.0) ? (color + color * changeFactor) : (color - color * changeFactor);

    // luminance + chroma after gain
    float luminanceGain = dot(gainMasked, lumaCoeff);
    float3 chroma = gainMasked - luminanceGain.xxx;
    float chromaMagnitude = max(length(chroma), EPSILON);

    // --- 3) Apply saturation boost ---
    float3 chromaBoosted = chroma * saturationMultiplier;

    // --- 4) Procedural saturation preservation ---
    // More gainScale = more suppression of boosted saturation
    float gainInfluence = saturate(intensity);

    // Ratio of how much saturation we *should* keep
    float saturationRatio = saturate(chromaInputMagnitude / chromaMagnitude);

    // Blend boosted chroma back toward non-boosted chroma
    float saturationBleed = gainInfluence * (1.0 - saturationRatio);

    float3 chromaFinal = lerp(chromaBoosted, chroma, saturationBleed);

    // --- 5) Recombine ---
    float3 output = luminanceGain.xxx + chromaFinal;

    // --- 6) Soft HDR compression ---
    float maxValueGain = max(max(output.r, output.g), output.b);
    float headroom = max(1.0, maxValueGain * 2.0);
    float compressMul = 1.0 / (1.0 + maxValueGain / (headroom + EPSILON));
    float finalCompressMul = lerp(1.0, compressMul, gainInfluence);
    output *= finalCompressMul;

    return min(max(output, 0.f), 65504.f);
}