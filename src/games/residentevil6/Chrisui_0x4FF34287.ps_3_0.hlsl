#include "./shared.h"

float fGlobalTransparency : register(c1);
float4 CBMaterial__packed0 : register(c2);
float3 fAlbedoColor : register(c3);

sampler2D SSAlbedoMap__tAlbedoMap : register(s0);

struct PS_IN
{
    float4 color      : TEXCOORD0;
    float4 texcoord1  : TEXCOORD1;
    float2 texcoord2  : TEXCOORD2;
};

float LinearToSRGB1(float c)
{
    float lo = c * 12.92;
    float hi = pow(max(c, 0.0), 1.0 / 2.4) * 1.055 - 0.055;
    return (c <= 0.0031308) ? lo : hi;
}

float3 LinearToSRGB3(float3 c)
{
    return float3(
        LinearToSRGB1(c.r),
        LinearToSRGB1(c.g),
        LinearToSRGB1(c.b)
    );
}

// ------------------------------------------------------------
// Match the final full-screen HDR expansion shader
// ------------------------------------------------------------

float ExpandScalarLikeFinalPass(float x)
{
    float highlight = saturate((x - 0.18) / 0.82);
    highlight *= highlight;

    float peak_ratio = max(
        1.0,
        RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0)
    );

    return x * lerp(1.0, peak_ratio, highlight);
}

float InverseExpandScalarLikeFinalPass(float target)
{
    float lo = 0.0;
    float hi = 1.0;

    // Enough iterations for a stable UI clamp without being expensive.
    [unroll]
    for (int step = 0; step < 8; step++)
    {
        float mid = (lo + hi) * 0.5;
        float expanded = ExpandScalarLikeFinalPass(mid);

        if (expanded < target)
        {
            lo = mid;
        }
        else
        {
            hi = mid;
        }
    }

    return hi;
}

float3 PreCompressUIForFinalHDRPass(float3 linear_color)
{
    linear_color = max(linear_color, 0.0);

    // RenoDX UI/graphics white target relative to diffuse white.
    // This makes the shader respond to the RenoDX white point / UI white setting.
    float ui_white_relative = max(
        1.0,
        RENODX_GRAPHICS_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0)
    );

    // Find the SDR-range value that will become the chosen UI white
    // after the final fullscreen HDR expansion pass.
    float allowed_input_peak = InverseExpandScalarLikeFinalPass(ui_white_relative);

    float max_channel = max(max(linear_color.r, linear_color.g), linear_color.b);

    if (max_channel > allowed_input_peak)
    {
        linear_color *= allowed_input_peak / max(max_channel, 0.000001);
    }

    return linear_color;
}

float4 main(PS_IN i) : COLOR
{
    float4 tex = tex2D(SSAlbedoMap__tAlbedoMap, i.texcoord2);

    float4 o;

    // Original alpha path:
    // tex.a * vertex alpha * material alpha * global transparency
    o.a = tex.a * i.color.a * CBMaterial__packed0.w * fGlobalTransparency;

    // Original color path:
    // tex.rgb * fAlbedoColor
    float3 albedo = tex.rgb * fAlbedoColor.rgb;

    // Original material/vertex lighting/color multiplier:
    // pow(CBMaterial.rgb, 2.2) * vertex color.rgb * texcoord1.w
    float3 material_linear = pow(max(CBMaterial__packed0.rgb, 0.0), 2.2);
    float3 multiplier = material_linear * i.color.rgb * i.texcoord1.w;

    // Original shader multiplies albedo by this lighting/color value.
    float3 linear_color = albedo * multiplier;

    // ------------------------------------------------------------
    // RenoDX white-point aware UI/HUD pre-compression
    //
    // This replaces the old hard-coded:
    // const float UI_SDR_WHITE = 0.31;
    //
    // Now the result follows the RenoDX UI/graphics white setting.
    // ------------------------------------------------------------

    linear_color = PreCompressUIForFinalHDRPass(linear_color);

    // ------------------------------------------------------------
    // Original linear to sRGB output
    // ------------------------------------------------------------

    o.rgb = LinearToSRGB3(linear_color);

    return o;
}