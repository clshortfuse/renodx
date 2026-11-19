// HDR-safe bloom input, reconstructed from the stock square-and-divide-by-8 pass.
// This pass writes the half-resolution bloom chain, not the sharp scene image.
sampler2D colorSampler : register(s0);

float4 main(float2 texcoord : TEXCOORD0) : COLOR0
{
    float4 source = tex2D(colorSampler, texcoord);
    float4 decoded = source * source * 0.125f;
        // Preserve the stock response through encoded scene white (1).
        // Above it, replace quadratic growth with a C1 continuous shoulder:
        // linear peak P -> 2*sqrt(P)-1. It never clips HDR to a flat plateau.
        // A single RGB gain preserves chromatic ratios; alpha stays stock.
        float peak = max(max(abs(source.r), abs(source.g)), abs(source.b));
        float hdrPeak = max(peak, 1.0f);
        decoded.rgb *= (2.0f * hdrPeak - 1.0f) / (hdrPeak * hdrPeak);
    return decoded;
}
