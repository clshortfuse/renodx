// #version 450
// #include "../shared.slang"

// layout(set = 1, binding = 2, std140) uniform ufBlock
// {
//   ivec4 uf_remappedPS[1];
//   vec4 uf_fragCoordScale;
// } _89;

// layout(set = 1, binding = 0) uniform sampler2D fp_t_tcb_8;
// layout(set = 1, binding = 1) uniform sampler2D fp_t_tcb_10;

// layout(location = 0) in vec4 uv;
// layout(location = 0) out vec4 out;

// void main() {
//   float scale = intBitsToFloat(_89.uf_remappedPS[0].x);
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