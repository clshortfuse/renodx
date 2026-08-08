#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

// CurrColorTex is bound through its native E5B9G9R9_UFLOAT_PACK32 sampled
// view. Vulkan filtering hardware therefore exposes decoded linear RGB here.
layout(set = 0, binding = 0) uniform sampler2D CurrColorTex;
layout(set = 0, binding = 1, rgba16f) uniform writeonly image2D OutColor;

void main()
{
    ivec2 pixel = ivec2(gl_GlobalInvocationID.xy);

    if (all(lessThan(pixel, imageSize(OutColor))))
    {
        vec3 color = texelFetch(CurrColorTex, pixel, 0).rgb;
        imageStore(OutColor, pixel, vec4(color, 1.0));
    }

}
