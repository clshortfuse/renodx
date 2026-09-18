// BO1 composite with stock low-range contrast and scene-driven HDR highlights.
#include "./shared.h"
sampler2D bloomSampler : register(s0);
sampler2D colorSampler : register(s1);
float4 postFxControl0 : register(c5);
float4 postFxControl1 : register(c6);
float4 postFxControl2 : register(c7);

float3 StockCurve(float3 x)
{
    float3 denominator = x * (x * postFxControl0.x + postFxControl0.y)
        + postFxControl0.z;
    float3 numerator = x * (x * postFxControl1.x + postFxControl1.y)
        + postFxControl1.z;
    return (numerator / denominator + postFxControl2.x) * postFxControl2.y;
}

float4 main(float2 texcoord : TEXCOORD0) : COLOR0
{
    float3 bloom = max(tex2D(bloomSampler, texcoord).rgb * 64.0f, 0.0f);
    if (RENODX_TONE_MAP_TYPE != RENODX_TONE_MAP_TYPE_VANILLA)
    {
        // Treat the glow independently from the sharp scene. Give high
        // bloom energy a soft shoulder; do not fade the faint outer halo.
        // This limits scattered light before the film/display response.
        // This bounds scattered light only, never the source HDR highlight.
        float bloomY = dot(bloom, float3(0.2126f, 0.7152f, 0.0722f));
        float bloomShoulder = 1.0f / (1.0f + bloomY * 0.50f);
        bloom *= bloomShoulder;
    }
    bloom *= max(RENODX_BLOOM_BRIGHTNESS, 0.0f);
    float4 scene = tex2D(colorSampler, texcoord);
    float3 sceneLight = scene.rgb * scene.rgb * 8.0f;
    if (RENODX_TONE_MAP_TYPE == RENODX_TONE_MAP_TYPE_VANILLA)
        return float4(StockCurve(sceneLight + bloom), scene.a);

    // Keep BO1's toe and midtone contrast. Above scene white, continue the
    // decoded stock curve smoothly toward unit scene-light slope.
    // Value and slope agree at the join; highlights remain unbounded.
    const float anchor = 1.0f;
    const float step = 0.001f;
    float gray = max(StockCurve(anchor.xxx).x, 0.0f);
    float lo = max(StockCurve((anchor - step).xxx).x, 0.0f);
    float hi = max(StockCurve((anchor + step).xxx).x, 0.0f);
    float slope = max((hi * hi - lo * lo) / (2.0f * step), 0.000001f);
    float3 light = max(sceneLight + bloom, 0.0f);
    float3 stock = max(StockCurve(min(light, anchor.xxx)), 0.0f);
    float3 excess = max(light - anchor, 0.0f);
    // Recover unit scene-light slope smoothly over the first stop above white.
    // The tangent alone can inherit the nearly flat stock film shoulder.
    float3 extension = excess * slope
        + max(1.0f - slope, 0.0f) * excess * (excess / (1.0f + excess));
    float3 linearColor = stock * stock + extension;
    // The following color-grade shader expects gamma-2 encoded RGB and decodes
    // after grading. Keep that contract; HDR values are not saturated here.
    return float4(sqrt(linearColor), scene.a);
}
