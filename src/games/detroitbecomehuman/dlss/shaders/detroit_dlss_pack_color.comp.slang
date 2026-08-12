#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0) uniform sampler2D DlssColor;
layout(set = 0, binding = 1, r32ui) uniform writeonly uimage2D OutColorPass;
layout(push_constant) uniform PackConstantsBlock
{
    // Preserve Detroit/RenoDX compute push constants at bytes 0..111.
    vec4 reserved[7];
    vec2 reservedTail;
    vec2 values;
} PackConstants;

float SanitizeColorChannel(float value)
{
    if (isnan(value) || isinf(value))
    {
        return 0.0;
    }
    return clamp(value, 0.0, 65408.0);
}

vec3 SanitizeColor(vec3 value)
{
    return vec3(
        SanitizeColorChannel(value.r),
        SanitizeColorChannel(value.g),
        SanitizeColorChannel(value.b));
}

float SceneLuma(vec3 color)
{
    return dot(
        color,
        vec3(
            0.2125999927520751953125,
            0.715200006961822509765625,
            0.072200000286102294921875));
}

vec3 LoadDlssColor(ivec2 coordinate, ivec2 maximum_coordinate)
{
    return SanitizeColor(
        texelFetch(
            DlssColor,
            clamp(coordinate, ivec2(0), maximum_coordinate),
            0).rgb);
}

vec3 ApplyDlaaRcas(
    ivec2 coordinate,
    vec3 center,
    float sharpening,
    float normalization)
{
    const ivec2 maximum_coordinate =
        max(textureSize(DlssColor, 0) - ivec2(1), ivec2(0));
    const vec3 north = LoadDlssColor(
        coordinate + ivec2(0, -1), maximum_coordinate);
    const vec3 west = LoadDlssColor(
        coordinate + ivec2(-1, 0), maximum_coordinate);
    const vec3 east = LoadDlssColor(
        coordinate + ivec2(1, 0), maximum_coordinate);
    const vec3 south = LoadDlssColor(
        coordinate + ivec2(0, 1), maximum_coordinate);

    const float inverse_normalization = 1.0 / normalization;
    const float north_luma = SceneLuma(north) * inverse_normalization;
    const float west_luma = SceneLuma(west) * inverse_normalization;
    const float center_luma = SceneLuma(center) * inverse_normalization;
    const float east_luma = SceneLuma(east) * inverse_normalization;
    const float south_luma = SceneLuma(south) * inverse_normalization;

    const float minimum_ring_luma =
        min(min(north_luma, west_luma), min(east_luma, south_luma));
    const float maximum_ring_luma =
        max(max(north_luma, west_luma), max(east_luma, south_luma));
    const float limited_maximum_luma = min(maximum_ring_luma, 0.99);
    const float epsilon = 1.0e-6;
    const float hit_minimum = minimum_ring_luma
        / max(4.0 * limited_maximum_luma, epsilon);
    float hit_maximum_denominator = 4.0 * minimum_ring_luma - 4.0;
    if (abs(hit_maximum_denominator) < epsilon)
    {
        hit_maximum_denominator =
            hit_maximum_denominator < 0.0 ? -epsilon : epsilon;
    }
    const float hit_maximum =
        (1.0 - limited_maximum_luma) / hit_maximum_denominator;
    float lobe = max(
        -0.1875,
        min(max(-hit_minimum, hit_maximum), 0.0));
    lobe *= sharpening;

    float noise =
        0.25 * (north_luma + west_luma + east_luma + south_luma)
        - center_luma;
    const float maximum_luma = max(
        max(max(north_luma, west_luma), max(center_luma, east_luma)),
        south_luma);
    const float minimum_luma = min(
        min(min(north_luma, west_luma), min(center_luma, east_luma)),
        south_luma);
    noise = clamp(
        abs(noise) / max(maximum_luma - minimum_luma, epsilon),
        0.0,
        1.0);
    lobe *= 1.0 - 0.5 * noise;

    const float reciprocal_weight = 1.0 / (4.0 * lobe + 1.0);
    const float sharpened_luma =
        ((north_luma + west_luma + east_luma + south_luma) * lobe
         + center_luma)
        * reciprocal_weight;
    const float luma_ratio = center_luma > epsilon
        ? sharpened_luma / center_luma
        : 1.0;
    return center * clamp(luma_ratio, 0.0, 4.0);
}

// This is the exact RGB9E5 encoder used by Detroit's 0xB5506A45 TAA shader.
// Sanitization is performed first so malformed DLSS output cannot overflow the
// exponent construction or propagate non-finite values downstream.
uint PackDetroitRgb9e5(vec3 value)
{
    vec3 color = SanitizeColor(value);

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
    if (!all(equal(source_size, output_size)))
    {
        return;
    }
    // Production NGX output is always output-sized. Preserve its exact
    // one-texel mapping when encoding Detroit's native RGB9E5 storage image.
    vec3 color = texelFetch(DlssColor, pixel, 0).rgb;
    const float sharpening = PackConstants.values.x;
    if (sharpening > 0.0)
    {
        color = ApplyDlaaRcas(
            pixel,
            SanitizeColor(color),
            sharpening,
            PackConstants.values.y);
    }
    imageStore(OutColorPass, pixel, uvec4(PackDetroitRgb9e5(color), 0u, 0u, 0u));
}
