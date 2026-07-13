// #version 450
// #include "./shared.slang"

// layout(set = 0, binding = 23, std140) uniform fp_c4 {
//   vec4 _m0[4096];
// }
// fp_c4_1;

// layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
// layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_10;

// layout(location = 0) in vec4 uv;
// layout(location = 0) out vec4 out;

// void main() {
//   float scale = fp_c4_1._m0[1].x;
//   vec4 scene = texture(fp_t_tcb_8, uv.xy).xyzw;
//   vec3 bloom = texture(fp_t_tcb_10, uv.xy).xyz;
//   bloom *= CUSTOM_BLOOM;
//   vec3 color = scene.xyz * scale + bloom;
//   color = ApplyColorGrade(color);
//   color = DisplayMap(color);
//   color = renodx::draw::RenderIntermediatePass(color);
//   out.xyz = color;
// }

#define BLOOM
#include "./common.slang"