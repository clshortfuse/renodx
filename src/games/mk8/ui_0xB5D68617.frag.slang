#version 450
#include "./shared.h"
#include "./shared.slang"


layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;

layout(location = 0) in vec4 uv;
layout(location = 1) in vec4 scale;
layout(location = 0) out vec4 out;

void main()
{
    vec4 color0 = texture(fp_t_tcb_8, uv.xy);
    vec3 color1 = texture(fp_t_tcb_A, uv.xy).xyz;

    vec3 scaled = color0.xyz * scale.w;
    float blend = fma(scaled.z, fp_c1_1._m0[0].y, fma(scaled.y, fp_c1_1._m0[0].x, scaled.x * 0.29890000820159912109375));
    blend = saturate(blend);
    out = vec4(scaled + color1 * (1.0 - blend), color0.w);
    out.xyz = DisplayMap(out.xyz, true);
}