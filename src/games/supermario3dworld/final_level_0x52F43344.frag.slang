// #version 450

// layout(set = 0, binding = 0, std140) uniform support_buffer
// {
//     uint _m0;
//     uint _m1[8];
//     vec4 _m2;
//     vec4 _m3;
//     int _m4;
//     float _m5[73];
//     ivec4 _m6;
//     int _m7;
// } support_buffer_1;

// layout(set = 0, binding = 23, std140) uniform fp_c4
// {
//     vec4 _m0[4096];
// } fp_c4_1;

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_E;
// layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_12;
// layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;

// layout(location = 0) in vec4 _33;
// layout(location = 0) out vec4 _36;

// void main()
// {
//     vec2 uv = _33.xy;

//     vec3 vignetteBase = texture(fp_t_tcb_E, uv).xyz;
//     vec3 vignetteMask = texture(fp_t_tcb_12, uv).xyz;
//     vec4 scene = texture(fp_t_tcb_8, uv);

//     vec3 vignette = fma(vignetteBase, vec3(fp_c4_1._m0[1].z), vec3(fp_c4_1._m0[1].y));
//     vec3 blended = vignette * vignetteMask;
//     vec3 color = fma(scene.xyz, vec3(fp_c4_1._m0[1].x), blended);

//     _36 = vec4(color, scene.w);
// }

#define FINAL_LEVEL
#include "./common.slang"