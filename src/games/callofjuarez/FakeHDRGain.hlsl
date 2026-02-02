#include "./shared.h"

namespace FakeHDRGain {
        // Helpers
        static const float EPSILON = 1e-6;

        float GetLuminance(float3 color) { return renodx::color::y::from::BT709(color); }
        float GetLuminance(float color) { return color; }

        float GetMax(float3 color) { return max(color.r, max(color.g, color.b)); }
        float GetMax(float color) { return color; }

        float3 ApplyFakeHDRGain(float3 color, float gainScale, float threshold, float saturationMultiplier) {
          float intensity = gainScale - 1.0;
          float luminanceInput = GetLuminance(color);
          // Masking (Luminance-based to prevent hue shift)
          float maskBase = 1.0 - exp(-(luminanceInput / max(threshold, EPSILON)));
          float gainMask = pow(abs(maskBase), 1.5);
          float finalMask = (intensity >= 0.0) ? gainMask : (1.0 - gainMask);
          // Gain Application
          float effectFactor = abs(intensity) * finalMask;
          float3 gainMasked = (intensity >= 0.0) ? (color * (1.0 + effectFactor)) : (color * (1.0 - effectFactor));
          // Procedural Saturation (Restoring your original logic)
          float luminanceGain = GetLuminance(gainMasked);
          float3 chromaOriginal = color - luminanceInput;
          float3 chromaGained = gainMasked - luminanceGain;
          float chromaOriginalMag = length(chromaOriginal);
          float chromaGainedMag = max(length(chromaGained), EPSILON);
          // Boost the chroma
          float3 chromaBoosted = chromaGained * saturationMultiplier;
          // Ratio of original vs new chroma magnitude determines how much "stretch" happened
          float saturationRatio = saturate(chromaOriginalMag / chromaGainedMag);
          // As gain intensity increases, we bleed back to the unboosted chroma
          // to prevent the "clipping/neon" look
          float gainInfluence = saturate(intensity);
          float saturationBleed = gainInfluence * (1.0 - saturationRatio);
          float3 chromaFinal = lerp(chromaBoosted, chromaGained, saturationBleed);
          float3 output = luminanceGain + chromaFinal;
          // Anchor-Based Soft HDR Compression
          float maxRGB = GetMax(output);
          if (maxRGB > 1.0 && intensity > 0.0) {
            // Only compress the delta above 1.0 to prevent midtone dimming
            float ratio = (maxRGB - 1.0) / max(maxRGB, EPSILON);
            float compression = 1.0 / (1.0 + (ratio * gainInfluence));
            output = lerp(output, output * compression, saturate(maxRGB - 1.0));
          }

          return clamp(output, 0.0, 65504.0);
    }

    float Apply(float color, float gainScale, float threshold, float saturationMultiplier) {
    return ApplyFakeHDRGain(color.xxx, gainScale, threshold, saturationMultiplier).x;
    }
    float2 Apply(float2 color, float gainScale, float threshold, float saturationMultiplier) {
    return float2(Apply(color.x, gainScale, threshold, saturationMultiplier), color.y);
    }
    float3 Apply(float3 color, float gainScale, float threshold, float saturationMultiplier) {
    return ApplyFakeHDRGain(color, gainScale, threshold, saturationMultiplier);
    }
    float4 Apply(float4 color, float gainScale, float threshold, float saturationMultiplier) {
    return float4(ApplyFakeHDRGain(color.rgb, gainScale, threshold, saturationMultiplier), color.a);
    }
}  // namespace FakeHDRGain