#define SPLATOON2_LUT_VARIANT_5404

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_10;

layout(location = 0) in vec4 _36;
layout(location = 1) in vec4 _38;
layout(location = 0) out vec4 out;

#include "./lut_common.slang"

