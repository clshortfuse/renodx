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
          float3 output = (intensity >= 0.0) ? (color * (1.0 + effectFactor)) : (color * (1.0 - effectFactor));
          // Extract the luminance of the newly gained color
          float lumaGained = GetLuminance(output);
          // Calculate saturation: move the color away from its own luminance
          float3 saturated = lumaGained + (output - lumaGained) * saturationMultiplier;
          // Saturation boosts often shift luminance. We force it back to 'lumaGained'.
          float lumaAfterSat = GetLuminance(saturated);
          float lumaCoeff = lumaGained / max(lumaAfterSat, EPSILON);
          output = saturated * lumaCoeff;
          // Anchor-Based Soft HDR Compression
          float maxRGB = GetMax(output);
          if (maxRGB > 1.0 && intensity > 0.0) {
            float gainInfluence = saturate(intensity);
            // Only compress highlights above SDR (1.0)
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