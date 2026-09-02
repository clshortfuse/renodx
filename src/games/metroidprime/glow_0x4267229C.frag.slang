#version 450
#include "./shared.h"
#include "./shared.slang"

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) noperspective in vec4 in_uv;
layout(location = 0) out vec4 out;

void main()
{
    vec4 texel = texture(fp_t_tcb_8, in_uv.xy);

    if (RENODX_TONE_MAP_TYPE == 0) texel / (texel + 1.0);
    out = texel;
    out.w = texel.w;
    
    out.xyz = ApplyColorGrade(out.xyz);
    out = renodx::draw::RenderIntermediatePass(out);
}

