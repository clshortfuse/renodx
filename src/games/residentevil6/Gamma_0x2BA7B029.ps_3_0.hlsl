 #include "./shared.h"

sampler2D SSPoint__tBaseMap : register(s0);
float3 fGamma : register(c1);

float SRGBToLinear1(float c)
{
    float lo = c * 0.07739938;
    float hi = pow((c + 0.055) * 0.9478673, 2.4);
    return (c <= 0.03928) ? lo : hi;
}

float3 SRGBToLinear3(float3 c)
{
    return float3(
        SRGBToLinear1(c.x),
        SRGBToLinear1(c.y),
        SRGBToLinear1(c.z)
    );
}

float3 ApplyGameGamma(float3 c)
{
    c.x = exp2(log2(max(c.x, 0.000001)) * fGamma.x);
    c.y = exp2(log2(max(c.y, 0.000001)) * fGamma.x);
    c.z = exp2(log2(max(c.z, 0.000001)) * fGamma.x);
    return c;
}

float3 ExpandSDRToHDR(float3 c)
{
    float y = renodx::color::y::from::BT709(c);

    // Start expansion above mid gray.
    float highlight = saturate((y - 0.18) / 0.82);
    highlight = highlight * highlight;

    float peak_ratio = max(
        1.0,
        RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0)
    );

    return c * lerp(1.0, peak_ratio, highlight);
}

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
    float4 color = tex2D(SSPoint__tBaseMap, texcoord);

    // Final SDR/gamma frame from the previous passes.
    float3 color_linear = SRGBToLinear3(color.rgb);

    // Preserve the game gamma shader behavior.
    color_linear = ApplyGameGamma(color_linear);

    color_linear = max(color_linear, 0.0);

    if (RENODX_TONE_MAP_TYPE == 0.0)
    {
        color_linear = renodx::color::bt2020::from::BT709(color_linear);
        color.rgb = renodx::draw::RenderIntermediatePass(color_linear);
        return color;
    }

    // Give RenoDRT highlight range to work with.
    color_linear = ExpandSDRToHDR(color_linear);

    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.reno_drt_tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;

    // This is what makes RenoDX tone-map settings actually affect the image.
    color_linear = renodx::draw::ToneMapPass(color_linear, config);

    color_linear = renodx::color::bt2020::from::BT709(color_linear);
    color_linear = max(color_linear, 0.0);

    color.rgb = renodx::draw::RenderIntermediatePass(color_linear);
    return color;
}