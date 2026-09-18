#ifndef MW3_BLOOM_LEGACY_SAFE_HLSL
#define MW3_BLOOM_LEGACY_SAFE_HLSL

// WaW-style protection for legacy bloom blend inputs only.
// Do not apply this normalization to the HDR scene/output shaders.
float MW3BloomFinite(float value) {
    value = (value == value) ? value : 0.0f;
    return clamp(value, 0.0f, 65504.0f);
}

float3 MW3BloomNormalize(float3 color) {
    color = float3(MW3BloomFinite(color.r),
                   MW3BloomFinite(color.g),
                   MW3BloomFinite(color.b));
    return color / max(1.0f, max(color.r, max(color.g, color.b)));
}

// Same bounded-strength curve used by WaW. RGB ratios stay unchanged.
float3 MW3BloomStrength(float3 color, float strength) {
    color = MW3BloomNormalize(color);
    strength = MW3BloomFinite(strength);
    float peak = max(color.r, max(color.g, color.b));
    if (peak <= 1e-6f || strength <= 0.0f) return 0.0f.xxx;
    float newPeak = (strength <= 1.0f)
        ? peak * strength
        : 1.0f - pow(max(1.0f - peak, 0.0f), strength);
    return MW3BloomNormalize(color * (newPeak / peak));
}

#endif
