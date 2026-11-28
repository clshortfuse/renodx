#include "./shared.h"

float4 CBROPTest__packed0 : register(c1);
float fGUIAlphaMask : register(c2);
float4 fGUIColorScale : register(c3);
float4 fGUIAmbientColor : register(c4);
float fGUISaturation : register(c5);
float4 fGUISaturationParam : register(c6);

sampler2D SSGUI__tGUIBaseMap : register(s0);

struct PS_IN
{
    float4 color     : TEXCOORD0;
    float2 texcoord  : TEXCOORD1;
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

    float mid;
    float expanded;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    mid = (lo + hi) * 0.5;
    expanded = ExpandScalarLikeFinalPass(mid);
    if (expanded < target) lo = mid; else hi = mid;

    return hi;
}

float3 PreCompressUIForFinalHDRPass(float3 linear_color)
{
    linear_color = max(linear_color, 0.0);

    // RenoDX UI / graphics white relative to game diffuse white.
    float ui_white_relative = max(
        1.0,
        RENODX_GRAPHICS_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0)
    );

    // Find the SDR value that will expand to the selected UI white
    // after the final fullscreen HDR pass.
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
    float4 gui = tex2D(SSGUI__tGUIBaseMap, i.texcoord);

    // Original:
    // texld r0, v1, s0
    // mul r0, r0, v0
    gui *= i.color;

    // Original:
    // mad r0, r0, fGUIColorScale, fGUIAmbientColor
    gui = gui * fGUIColorScale + fGUIAmbientColor;

    // Original saturation path:
    // dp3 luminance
    // lrp between original color and luminance
    // cmp based on fGUISaturation
    float luminance = dot(gui.rgb, float3(0.298900008, 0.586600006, 0.114500001));
    float3 saturated_rgb = lerp(gui.rgb, luminance.xxx, fGUISaturationParam.rgb);

    if (fGUISaturation > 0.0)
    {
        gui.rgb = saturated_rgb;
    }

    // Original alpha test:
    // kill when alpha is less/equal to CBROPTest__packed0.x
    if (gui.a <= CBROPTest__packed0.x)
    {
        discard;
    }

    // ------------------------------------------------------------
    // RenoDX white-point aware GUI pre-compression
    //
    // This makes this GUI shader respond to:
    // RENODX_GRAPHICS_WHITE_NITS
    // RENODX_DIFFUSE_WHITE_NITS
    // RENODX_PEAK_WHITE_NITS
    // ------------------------------------------------------------

    gui.rgb = PreCompressUIForFinalHDRPass(gui.rgb);

    // Original linear to sRGB output
    gui.rgb = LinearToSRGB3(gui.rgb);

    return gui;
}