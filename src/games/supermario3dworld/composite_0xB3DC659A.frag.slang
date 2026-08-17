// #version 450
// #include "./shared.slang"

// layout(set = 0, binding = 23, std140) uniform fp_c4
// {
//     vec4 _m0[4096];
// } fp_c4_1;

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

// layout(location = 0) in vec4 uv;
// layout(location = 0) out vec4 out;

// void main()
// {
//     vec4 scene = texture(fp_t_tcb_8, uv.xy).xyzw;
//     scene.xyz *= fp_c4_1._m0[1].x;
//     out = scene;
// }

#include "./common.slang"