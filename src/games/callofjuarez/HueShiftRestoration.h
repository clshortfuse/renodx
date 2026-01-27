#include "./shared.h"

float3 ApplySDRHueToHDR(float3 hdrColor, float3 sdrColor)
{
    const float3 LumaWeights = float3(0.2126, 0.7152, 0.0722);
    
    // 1. ANCHOR: The input HDR luminance and detail are the priority.
    float targetY = dot(hdrColor, LumaWeights);
    if (targetY <= 1e-6) return hdrColor;

    // 2. CONVERT TO OKLAB (To isolate Hue without touching Luma)
    // Oklab is great here because 'L' is separate from 'ab' (color).
    float3 hdrOklab = renodx::color::oklab::from::BT709(hdrColor);
    float3 sdrOklab = renodx::color::oklab::from::BT709(sdrColor);

    // 3. EXTRACT TARGET HUE
    // We only take the 'Direction' from the SDR.
    float targetHue = atan2(sdrOklab.z, sdrOklab.y);
    
    // We keep the HDR's original 'Chroma' (saturation/detail depth).
    float hdrChroma = length(hdrOklab.yz);

    // 4. RECONSTRUCT WITH ORIGINAL DETAIL
    // We point the HDR's vividness toward the SDR's hue angle.
    float3 rotatedOklab;
    rotatedOklab.x = hdrOklab.x; // Keep HDR perceptual lightness
    rotatedOklab.y = hdrChroma * cos(targetHue);
    rotatedOklab.z = hdrChroma * sin(targetHue);

    // 5. BACK TO RGB
    float3 result = renodx::color::bt709::from::OkLab(rotatedOklab);

    // 6. STRICT ENERGY LOCK
    // This prevents the 'bloom explosion'. We shift the result to match targetY.
    float currentY = dot(result, LumaWeights);
    result += (targetY - currentY);

    // 7. GAMUT RECOVERY (Preserving Detail Peaks)
    // If the rotation pushed a channel into the negatives or past the original peak,
    // we shrink the chroma (desaturate) until it fits. 
    // This is a Luma-neutral mix, so it's 100% stable.
    float maxIn = max(hdrColor.r, max(hdrColor.g, hdrColor.b));
    float maxOut = max(result.r, max(result.g, result.b));
    float minOut = min(result.r, min(result.g, result.b));

    if (maxOut > maxIn || minOut < 0.0f) {
        float3 neutral = targetY.xxx;
        // Find the scale that keeps the texture 'peaks' where they were in the HDR.
        float chromaScale = (maxIn - targetY) / max(maxOut - targetY, 1e-6);
        float floorScale = targetY / max(targetY - minOut, 1e-6);
        
        result = lerp(neutral, result, saturate(min(chromaScale, floorScale)));
    }
    
    // Final lock to ensure no floating point drift
    result += (targetY - dot(result, LumaWeights));

    return max(0, result);
}