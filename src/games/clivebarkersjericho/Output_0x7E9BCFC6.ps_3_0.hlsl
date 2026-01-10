#include "./shared.h"

// Tonemapper variant
float4 g_LevelsInMax   : register(c6);
float4 g_LevelsInMin   : register(c5);
float4 g_LevelsOutMax  : register(c8);
float4 g_LevelsOutMin  : register(c7);
float  g_LevelsPow     : register(c9);

float  g_fBloomScale   : register(c1);
float  g_fBrightness   : register(c3);
float  g_fContrast     : register(c4);
float  g_fMiddleGray   : register(c0);
float  g_fStarScale    : register(c2);

sampler2D s0 : register(s0);    // main input
sampler2D s1 : register(s1);    // bloom tex
sampler2D s2 : register(s2);    // star streak tex
sampler2D s3 : register(s3);    // auto exposure 1x1

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    float4 r0, r1;
    float4 o;
    //----------------------------------------------------------
    // AUTO-EXPOSURE
    //----------------------------------------------------------
    // Sample the 1×1 exposure map at UV = 0.5 (center pixel)
    r0 = tex2D(s3, float2(0.5, 0.5));
    r0.w = r0.x + 0.001;
    r0.w = 1.0 / r0.w;
    r0.w *= g_fMiddleGray;
    //----------------------------------------------------------
    // MAIN INPUT * exposure
    //----------------------------------------------------------
    r1 = tex2D(s0, texcoord);   // input color
    r1.xyz = r1.xyz * r0.w;     // exposure applied
    //----------------------------------------------------------
    // ADD STAR STREAK
    //----------------------------------------------------------
    float4 star = tex2D(s2, texcoord);
    r1 = r1 + (star * g_fStarScale * Custom_Star_Dispersion);
    //----------------------------------------------------------
    // ADD BLOOM
    //----------------------------------------------------------
    float4 bloom = tex2D(s1, texcoord);
    r0 = r1 + (bloom * g_fBloomScale * Custom_Bloom);
    //----------------------------------------------------------
    // LEVELS: Input normalization
    //----------------------------------------------------------
    float4 inRange = g_LevelsInMax - g_LevelsInMin;  // denominator
    float4 invInRange = float4(
        1.0 / inRange.x,
        1.0 / inRange.y,
        1.0 / inRange.z,
        1.0 / inRange.w
    );

    r0 = (r0 - g_LevelsInMin) * invInRange;
    //----------------------------------------------------------
    // LEVELS: Output mapping
    //----------------------------------------------------------
    float4 outRange = g_LevelsOutMax - g_LevelsOutMin;
    r0 = lerp(r0, r0 * outRange + g_LevelsOutMin, Custom_Color_Tint2_Intensity);  // apply output range
    //----------------------------------------------------------
    // BRIGHTNESS & CONTRAST
    //----------------------------------------------------------
    r0 = lerp(r0, r0 + g_fBrightness.x, saturate(Custom_Contrast_Intensity));
    r0 = r0 + (-0.5 * Custom_Contrast_Intensity);  // shift around 0.5 before contrast
    r1.w = (0.5 * Custom_Contrast_Intensity);      // 0.5 constant
    float4 unclamped = g_fContrast.x * r0 + r1.w;
    r0 = saturate(g_fContrast.x * r0 + r1.w);  // apply contrast and shift back

    r0.x = log2(r0.x);
    r0.y = log2(r0.y);
    r0.z = log2(r0.z);
    r0.w = log2(r0.w);

    r0 *= g_LevelsPow;

    o.x = exp2(r0.x);
    o.y = exp2(r0.y);
    o.z = exp2(r0.z);
    o.w = exp2(r0.w);
    float4 saturated = o;

    float4 untonemapped_sRGB = max(0, unclamped);
    float4 untonemapped = renodx::color::srgba::Decode(untonemapped_sRGB);
    float3 tonemapped = renodx::tonemap::renodrt::NeutralSDR(untonemapped.rgb);
    float4 tonemapped_sRGB = renodx::color::srgba::Encode(float4(tonemapped.rgb, 1));
    if (RENODX_TONE_MAP_TYPE > 0.f) {
      o.rgb = renodx::draw::ToneMapPass(untonemapped.rgb);
    } else {
      o = renodx::color::srgba::Decode(float4(saturated));
    }
    o.a = renodx::color::y::from::BT709(o.rgb);
    o.rgb = renodx::draw::RenderIntermediatePass(o.rgb);

    return o;
}
