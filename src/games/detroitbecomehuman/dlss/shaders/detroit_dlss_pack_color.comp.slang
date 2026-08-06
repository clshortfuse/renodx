#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0) uniform sampler2D DlssColor;
layout(set = 0, binding = 1, r32ui) uniform writeonly uimage2D OutColorPass;

float SanitizeColorChannel(float value)
{
    if (isnan(value) || isinf(value))
    {
        return 0.0;
    }
    return clamp(value, 0.0, 65408.0);
}

// This is the exact RGB9E5 encoder used by Detroit's 0xB5506A45 TAA shader.
// Sanitization is performed first so malformed DLSS output cannot overflow the
// exponent construction or propagate non-finite values downstream.
uint PackDetroitRgb9e5(vec3 value)
{
    vec3 color = vec3(
        SanitizeColorChannel(value.r),
        SanitizeColorChannel(value.g),
        SanitizeColorChannel(value.b));

    uint exponent = max(
        0x37800000u,
        floatBitsToUint(max(color.r, max(color.g, color.b))) & 0x7F800000u);
    float bias = uintBitsToFloat(exponent + 0x07800000u);
    uint red = floatBitsToUint(
        uintBitsToFloat(floatBitsToUint(color.r) & 0xFFFF8000u) + bias);
    uint green = floatBitsToUint(
        uintBitsToFloat(floatBitsToUint(color.g) & 0xFFFF8000u) + bias);
    uint blue = floatBitsToUint(
        uintBitsToFloat(floatBitsToUint(color.b) & 0xFFFF8000u) + bias);

    return (((red | (green << 9u)) & 0x0003FFFFu) | (blue << 18u))
        | ((exponent - 0x37800000u) << 4u);
}

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);
    if (any(greaterThanEqual(pixel, imageSize(OutColorPass))))
    {
        return;
    }

    ivec2 output_size = imageSize(OutColorPass);
    ivec2 source_size = textureSize(DlssColor, 0);
    vec3 color;
    if (all(equal(source_size, output_size)))
    {
        // The production DLSS output is already output-sized. Preserve the
        // exact one-texel mapping used by the original adapter.
        color = texelFetch(DlssColor, pixel, 0).rgb;
    }
    else
    {
        // Test-only spatial path: expose the complete prepared current-color
        // image at output resolution without involving NGX. This distinguishes
        // an upstream viewport/composition fault from a DLSS evaluation fault.
        vec2 uv = (vec2(pixel) + vec2(0.5)) / vec2(output_size);
        color = textureLod(DlssColor, uv, 0.0).rgb;
    }
    imageStore(OutColorPass, pixel, uvec4(PackDetroitRgb9e5(color), 0u, 0u, 0u));
}
