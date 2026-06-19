#version 450
#include "./shared.h"

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 1) noperspective in vec4 uv0;
layout(location = 0) noperspective in vec4 uv1;
layout(location = 2) noperspective in vec4 uv2;
layout(location = 3) noperspective in vec4 uv3;
layout(location = 4) noperspective in vec4 uv4;
layout(location = 0) out vec4 out;

// void main()
// {
//     // Sample textures at 5 coordinates
//     vec4 s0 = textureLod(fp_t_tcb_8, uv0.xy, 0.0);
//     vec4 s1 = textureLod(fp_t_tcb_8, uv1.xy, 0.0);
//     vec4 s2 = textureLod(fp_t_tcb_8, uv2.xy, 0.0);
//     vec4 s3 = textureLod(fp_t_tcb_8, uv3.xy, 0.0);
//     vec4 s4 = textureLod(fp_t_tcb_8, uv4.xy, 0.0);
    
//     // Full weighted blur result.
//     vec4 weights = vec4(uv0.z, uv1.z, uv2.z, uv3.z);
//     vec4 blurred = mat4(s0, s1, s2, s3) * weights + s4 * uv4.z;

//     out = blurred;
// }

// 0.00 = center sample only / no blur from this pass
// 1.00 = vanilla
// 2.00 = exaggerated blur contribution

void main()
{
  vec4 s0 = textureLod(fp_t_tcb_8, uv0.xy, 0.0);
  vec4 s1 = textureLod(fp_t_tcb_8, uv1.xy, 0.0);
  vec4 s2 = textureLod(fp_t_tcb_8, uv2.xy, 0.0);
  vec4 s3 = textureLod(fp_t_tcb_8, uv3.xy, 0.0);
  vec4 s4 = textureLod(fp_t_tcb_8, uv4.xy, 0.0);

  vec4 vanilla = mat4(s0, s1, s2, s3) * vec4(uv0.z, uv1.z, uv2.z, uv3.z)
                 + s4 * uv4.z;

  // Change this after identifying the real center tap.
  vec4 center = s4;

  out = mix(center, vanilla, CUSTOM_DOF);
}