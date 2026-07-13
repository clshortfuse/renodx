// #version 450

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_10;
// layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;

// layout(location = 0) in vec4 uv;
// layout(location = 1) in vec4 in;
// layout(location = 0) out vec4 out;

// void main()
// {
//     vec3 bloom = texture(fp_t_tcb_10, uv.xy).xyz;
//     vec4 scene = texture(fp_t_tcb_8, uv.xy).xyzw;

//     out.xyz = scene.xyz * in.w + bloom;
//     out.w = scene.w;
// }

#define BLOOM
#define BF
#include "./common.slang"