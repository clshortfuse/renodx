// #version 450
// #include "./shared.slang"

// layout(set = 0, binding = 23, std140) uniform fp_c4 {
//   vec4 _m0[4096];
// }
// fp_c4_1;

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_E;
// layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_10;
// layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_12;
// layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_8;

// layout(location = 0) in vec4 uv;
// layout(location = 0) out vec4 out;

// void main() {
//   vec3 vignette = texture(fp_t_tcb_E, uv.xy).xyz;
//   vec3 bloom = texture(fp_t_tcb_10, uv.xy).xyz;
//   vec3 effect = texture(fp_t_tcb_12, uv.xy).xyz;
//   vec4 scene = texture(fp_t_tcb_8, uv.xy).xyzw;
//   vec3 thing = vignette * fp_c4_1._m0[1].z + fp_c4_1._m0[1].y;
//   vec3 thing2 = thing * effect + bloom;
//   vec3 thing3 = scene.xyz * fp_c4_1._m0[1].x + thing2;
//   out.xyz = thing3;
//   out.w = scene.w;
// }

#define BLOOM
#define VIGNETTE
#include "./common.slang"