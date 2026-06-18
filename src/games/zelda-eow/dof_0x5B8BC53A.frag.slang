#version 450
#include "./shared.h"

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 1) noperspective in vec4 _21;
layout(location = 0) noperspective in vec4 _23;
layout(location = 2) noperspective in vec4 _25;
layout(location = 3) noperspective in vec4 _27;
layout(location = 4) noperspective in vec4 _29;
layout(location = 0) out vec4 _32;

void main()
{
    // Sample textures at 5 coordinates
    vec4 s0 = textureLod(fp_t_tcb_8, _21.xy, 0.0);
    vec4 s1 = textureLod(fp_t_tcb_8, _23.xy, 0.0);
    vec4 s2 = textureLod(fp_t_tcb_8, _25.xy, 0.0);
    vec4 s3 = textureLod(fp_t_tcb_8, _27.xy, 0.0);
    vec4 s4 = textureLod(fp_t_tcb_8, _29.xy, 0.0);
    
    // Full weighted blur result.
    vec4 weights = vec4(_21.z, _23.z, _25.z, _27.z);
    vec4 blurred = mat4(s0, s1, s2, s3) * weights + s4 * _29.z;

    // 0.0 = baseline tap (least blur this pass can provide), 1.0 = full kernel blur.
    const float dof_strength = 1.0;
    _32 = mix(s0, blurred, dof_strength);
}

