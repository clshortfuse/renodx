#include "./shared.h"

float fGlobalTransparency : register(c1);
float4 CBMaterial__packed0 : register(c2);
float3 fAlbedoColor : register(c3);

float4 CBFog__packed0 : register(c4);
float4 CBFog__packed1 : register(c5);
float4 CBFog__packed2 : register(c6);
float4 CBFog__packed4 : register(c7);

sampler2D SSAlbedoMap__tAlbedoMap : register(s0);

struct PS_IN
{
    float4 color0    : COLOR0;     // v0, only .y used by fog
    float4 texcoord  : TEXCOORD0;  // v1
    float4 texcoord1 : TEXCOORD1;  // v2, only .w used
    float4 texcoord2 : TEXCOORD2;  // v3, only .y used by fog
    float2 texcoord3 : TEXCOORD3;  // v4.xy, texture UV
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
    float ui_white_relative = max(
        1.0,
        RENODX_GRAPHICS_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0)
    );

    // Find the SDR input limit that will land near the chosen UI white
    // after the final HDR expansion pass.
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
    float4 tex = tex2D(SSAlbedoMap__tAlbedoMap, i.texcoord3);

    float4 o;

    // ------------------------------------------------------------
    // Original alpha path
    // ------------------------------------------------------------
    //
    // Assembly:
    // tex.a * v1.w * CBMaterial.w * fGlobalTransparency

    o.a = tex.a * i.texcoord.w * CBMaterial__packed0.w * fGlobalTransparency;

    // ------------------------------------------------------------
    // Original base material path
    // ------------------------------------------------------------

    float3 albedo = tex.rgb * fAlbedoColor.rgb;

    // Assembly:
    // pow(CBMaterial.rgb, 2.2)
    float3 material_linear = pow(max(CBMaterial__packed0.rgb, 0.0), 2.2);

    // Assembly:
    // material_linear * v1.rgb * v2.w
    float3 vertex_material = material_linear * i.texcoord.rgb * i.texcoord1.w;

    // Assembly:
    // r0.xyz = albedo * vertex_material
    float3 base_color = albedo * vertex_material;

    // ------------------------------------------------------------
    // Original fog / extra lighting path
    // ------------------------------------------------------------

    // Assembly:
    // r0.w = c7.w * c7.x
    // r1.xzw = r0.w * r1
    float fog_scale = CBFog__packed4.w * CBFog__packed4.x;
    float3 fog_material = vertex_material * fog_scale;

    // First fog factor:
    // add -c5.z, v0.y
    // mul_sat by c5.w
    // multiply by c4.w
    float fog_factor_a = saturate((i.color0.y - CBFog__packed1.z) * CBFog__packed1.w);
    fog_factor_a *= CBFog__packed0.w;

    // r2.x = 1.0 - fog_factor_a * c7.y
    float fog_weight_a = 1.0 - fog_factor_a * CBFog__packed4.y;

    // r2.yzw = fog_factor_a * c7.y * c4.xyz
    float3 fog_color_a = fog_factor_a * CBFog__packed4.y * CBFog__packed0.xyz;

    // Second fog factor:
    // add -c5.x, v3.y
    // mul_sat by c5.y
    // multiply by c6.w
    float fog_factor_b = saturate((i.texcoord2.y - CBFog__packed1.x) * CBFog__packed1.y);
    fog_factor_b *= CBFog__packed2.w;

    // r1.y = 1.0 - fog_factor_b * c7.z
    float fog_weight_b = 1.0 - fog_factor_b * CBFog__packed4.z;

    // r3 = lerp(fog_color_a, c6.rgb, fog_factor_b * c7.z)
    float fog_lerp_b = fog_factor_b * CBFog__packed4.z;
    float3 fog_color = lerp(fog_color_a, CBFog__packed2.rgb, fog_lerp_b);

    // Assembly:
    // r1.xyz = r2.x * r1.y + r1.xzww
    // min r2.xyz, r1, 1
    float fog_mix = fog_weight_a * fog_weight_b;
    float3 fog_multiplier = min(fog_material + fog_mix.xxx, 1.0);

    // Assembly:
    // mad r0.xyz, r0, r2, r3
    float3 linear_color = base_color * fog_multiplier + fog_color;

    // ------------------------------------------------------------
    // RenoDX white-point aware pre-compression
    // ------------------------------------------------------------

    linear_color = PreCompressUIForFinalHDRPass(linear_color);

    // ------------------------------------------------------------
    // Original linear to sRGB output
    // ------------------------------------------------------------

    o.rgb = LinearToSRGB3(linear_color);

    return o;
}