#include "./shared.h"

// Damage Vignette, tint and Venas overlay
sampler2D ActualFrameSampler : register(s0);
sampler2D VenasSampler       : register(s1);

float g_Value  : register(c0); // red vignette intensity
float g_Closed : register(c1); // base mask control
float g_Power  : register(c2); // mask exponent factor
float g_Hit    : register(c3); // hit/additional mask modulation

// Constants controlling radial falloff and tint
static const float4 VIGNETTE_TWEAKS    = float4(0.0, 0.263157904, -50.0, 1.0); // small radial shaping tweaks
static const float4 VIGNETTE_PARAMS    = float4(-0.5, 3.8, 4.0, 0.2);           // uv offset and base scaling
static const float4 TINT_FACTORS       = float4(0.6, 0.3, 0.4, 0.1);             // tint multipliers

float4 main(float2 uv : TEXCOORD0) : COLOR0
{
    // -----------------------
    // Working registers / samples
    // -----------------------
    float4 venasSample       = 0.0;  // Venas texture sample + modulation
    float4 frameSample       = 0.0;  // Actual frame color sample
    float4 radialWork        = 0.0;  // UV offsets, squared values, and intermediate mask values
    float4 auxValues         = 0.0;  // auxiliary temporaries

    // -----------------------
    // Base mask computation
    // -----------------------
    float baseMask = g_Closed * (-VIGNETTE_PARAMS.y) + VIGNETTE_PARAMS.z;
    baseMask = g_Power * (-VIGNETTE_PARAMS.w) + baseMask;

    radialWork.z = max(baseMask, VIGNETTE_TWEAKS.x); // keep original data-flow
    auxValues.xy = VIGNETTE_TWEAKS.xy;

    float maskMod = saturate(radialWork.z * auxValues.y - g_Hit);

    // -----------------------
    // Venas sample & UV radial offset
    // -----------------------
    venasSample = tex2D(VenasSampler, uv);
    maskMod = -maskMod + venasSample.w; // modulate mask by Venas alpha

    float2 uvOffset = uv + VIGNETTE_PARAMS.x;
    uvOffset = abs(uvOffset);
    uvOffset *= uvOffset;           // square each component
    radialWork.xy = uvOffset;       // store squared offsets

    // -----------------------
    // Radial shaping (non-linear curve) & inverse sqrt
    // -----------------------
    float shapedMask = saturate(maskMod * VIGNETTE_TWEAKS.z);
    shapedMask = shapedMask * (-shapedMask) + VIGNETTE_TWEAKS.w;

    float invSqrtDist = rsqrt(radialWork.x + radialWork.y);
    venasSample *= shapedMask;

    radialWork.w = 1.0 / invSqrtDist;
    float powMask = pow(radialWork.w, radialWork.z);

    // -----------------------
    // Auxiliary factors for final mask
    // -----------------------
    auxValues.w = g_Power * (-VIGNETTE_PARAMS.x) - VIGNETTE_PARAMS.x;
    auxValues.z = radialWork.w * (-VIGNETTE_PARAMS.x) - VIGNETTE_PARAMS.x;

    float maskScalar = powMask * auxValues.w;
    radialWork.w = maskScalar; // preserve placement for logic consistency

    // -----------------------
    // Sample frame and compute tint delta
    // -----------------------
    frameSample = tex2D(ActualFrameSampler, uv);
    float3 tintColor = frameSample.rgb * float3(TINT_FACTORS.x, TINT_FACTORS.y, TINT_FACTORS.y)
                       + float3(TINT_FACTORS.z, TINT_FACTORS.w, TINT_FACTORS.w);  
    float frameLum = dot(frameSample.rgb, float3(0.2126, 0.7152, 0.0722));
    float tintLum = dot(tintColor, float3(0.2126, 0.7152, 0.0722));
    float lumScale = (tintLum > 0) ? (frameLum / tintLum) : 1.0;
    float3 tintDelta = tintColor - frameSample.rgb;
    if (RENODX_TONE_MAP_TYPE > 0.f) {
            tintDelta *= lumScale;
            // Compute a scaling factor that **limits the change so bright channels don’t exceed original peak**
            float3 safeDelta = tintDelta;
            // Prevent tint from lowering any channel:
            safeDelta = max(safeDelta, float3(0.0, 0.0, 0.0));
            // Apply mask:
            safeDelta *= saturate(radialWork.w * g_Value * 2.0 + VIGNETTE_TWEAKS.x);
            frameSample.rgb += safeDelta;
        } else {
            frameSample.rgb += tintDelta;
        }
    // -----------------------
    // Combine Venas contribution
    // -----------------------
    venasSample *= auxValues.z;
    auxValues.w += g_Hit;

    // -----------------------
    // Final output
    // -----------------------
    float4 finalColor = venasSample * auxValues.w + float4(frameSample.rgb, 1.0);
    return finalColor;
}
