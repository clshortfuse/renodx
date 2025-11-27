#include "./shared.h"

// Radial Blur
sampler2D ActualFrameSampler : register(s0);

float g_Value : register(c0);   // Intensity of blur mix
float g_Off   : register(c1);   // Vignette offset
float g_Scale : register(c2);   // Radial sampling scale

// Constants baked into the original shader
static const float4 C3 = float4(-0.5, 0.8, 0.2, -0.1);
static const float4 C4 = float4(0, 0, 1, 0.0625);
static const float4 C5 = float4(0.2126, 0.7152, 0.0722, 1.5);
static const float4 C6 = float4(0.33, 0, 0, 0);

static const int SAMPLE_REP = 15;

float4 main(float2 uv : TEXCOORD) : COLOR
{
    //--------------------------------------------------------------------
    // 1. Compute position relative to screen center
    //    (used both for blur direction and vignette strength)
    //--------------------------------------------------------------------
    float2 offsetFromCenter = uv + C3.x;   // uv - 0.5

    //--------------------------------------------------------------------
    // 2. Radial sample accumulation
    //    We sample along the ray from the center toward uv, repeatedly.
    //    Each iteration moves further outward.
    //--------------------------------------------------------------------
    float4 accum = 0.0;

    [unroll]
    for (int i = 0; i < SAMPLE_REP; ++i)
    {
        // Sample position moves outward each iteration
        float2 sampleUV = offsetFromCenter * accum.w;
        sampleUV = sampleUV * -g_Scale + uv;

        float3 s = tex2D(ActualFrameSampler, sampleUV).xyz;

        accum.xyz += s;
        accum.w   += 1.0;  // track sample index (count)
    }

    //--------------------------------------------------------------------
    // 3. Compute distance from the center (radial magnitude)
    //--------------------------------------------------------------------
    float2 sq = abs(offsetFromCenter);
    sq *= sq;
    float distSq = sq.x + sq.y;

    // True radial distance
    float dist = sqrt(distSq);

    //--------------------------------------------------------------------
    // 4. Compute vignette shaping based on distance
    //    This produces two values:
    //        vignetteXY.x → determines blur mix amount
    //        vignetteXY.y → controls edge tint boost
    //--------------------------------------------------------------------
    float2 vignetteXY = dist * C3.y + C3.zw; // *0.8 + (0.2, -0.1)

    //--------------------------------------------------------------------
    // 5. Blur intensity: how much blurred image replaces the original
    //--------------------------------------------------------------------
    float blendBase = vignetteXY.x - g_Off;
    float blendFactor = saturate(blendBase * g_Value);

    //--------------------------------------------------------------------
    // 6. Scale accumulated samples (their total sum) into a usable blur color
    //--------------------------------------------------------------------
    float3 blurColor = accum.xyz * C4.w; // multiply by 1/16

    //--------------------------------------------------------------------
    // 7. Fetch center pixel and blur-lerp
    //--------------------------------------------------------------------
    float3 centerCol = tex2D(ActualFrameSampler, uv).xyz;
    float3 blended = lerp(centerCol, blurColor, blendFactor);

    //--------------------------------------------------------------------
    // 8. Edge tint modulation (makes outer region darker/stronger)
    //--------------------------------------------------------------------
    float edgeStrength = (vignetteXY.y * blendFactor) * C5.w; // *1.5

    //--------------------------------------------------------------------
    // 9. Local luminance (for tinting effect)
    //--------------------------------------------------------------------
    float lum = dot(blended, C5.xyz); // Rec709-ish weighting

    //--------------------------------------------------------------------
    // 10. Compute edge tint direction:
    //     (lum*0.33 - blended) → pushes colors toward darkened neutral
    //--------------------------------------------------------------------
    float3 edgeTint = lum * C6.x - blended;

    //--------------------------------------------------------------------
    // 11. Final mix:
    //     blended → main result
    //     edgeTint * edgeStrength → outer vignette effect
    //--------------------------------------------------------------------
    float3 finalRGB = blended + edgeTint * edgeStrength;

    return float4(finalRGB, 0.0);
}
