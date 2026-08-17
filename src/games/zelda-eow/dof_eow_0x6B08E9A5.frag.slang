#version 450
#include "./shared.h"

layout(set = 0, binding = 24, std140) uniform fp_c5
{
    vec4 _m0[4096];
} fp_c5_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_A;

layout(location = 0) noperspective in vec4 _33;
layout(location = 0) out vec4 out;

void main()
{
    float _43 = _33.y;
    float _45 = _33.x;
    vec3 blur = texture(fp_t_tcb_8, vec2(_45, _43)).xyz;
    float _51 = blur.x;
    float _53 = blur.y;
    float _55 = blur.z;
    vec3 scene = texture(fp_t_tcb_C, vec2(_45, _43)).xyz;
    float _59 = scene.x;
    float _61 = scene.y;
    float _63 = scene.z;
    vec3 _65 = texture(fp_t_tcb_A, vec2(_45, _43)).xyz;
    float _67 = _65.x;
    float _69 = _65.y;
    float _71 = _65.z;
    float _73 = -_43;
    precise float _216 = _73 + 1.0;
    float _75 = _216;
    float _77 = -fp_c5_1._m0[0].x;
    precise float _223 = _45 + _77;
    float _79 = _223;
    float _81 = -fp_c5_1._m0[0].y;
    precise float _229 = _75 + _81;
    float _83 = _229;
    precise float _234 = _79 * fp_c5_1._m0[0].z;
    float _85 = _234;
    float _87 = fma(_83, fp_c5_1._m0[0].w, _85);
    precise float _244 = 1.0 / fp_c5_1._m0[1].x;
    float _89 = _244;
    float _91 = abs(_87);
    precise float _249 = _91 + (-0.0);
    float _93 = _249;
    precise float _252 = _89 * _93;
    float _95 = _252;
    float _97 = clamp(_95, 0.0, 1.0);
    float _99 = fma(_97, -2.0, 3.0);
    precise float _262 = _97 * _97;
    float _101 = _262;
    float _103 = fma(_99, _101, fp_c1_1._m0[0].x);
    float _105 = clamp(_103, 0.0, 1.0);
    precise float _273 = fp_c5_1._m0[1].x * 10.0;
    float _107 = _273;
    precise float _276 = 1.0 / fp_c5_1._m0[1].y;
    float _109 = _276;
    float _111 = log2(_105);
    precise float _281 = _107 * _111;
    float _113 = _281;
    float _115 = exp2(_113);
    float _117 = log2(_115);
    precise float _288 = _109 * _117;
    float _119 = _288;
    precise float _292 = _117 * fp_c5_1._m0[1].y;
    float _121 = _292;
    float _123 = exp2(_119);
    float _125 = exp2(_121);
    float _127 = -_123;
    precise float _300 = _127 + 1.0;
    float _129 = _300;
    precise float _304 = _125 * fp_c5_1._m0[1].z;
    float _131 = _304;
    float _133 = -_125;
    float _135 = -_129;
    precise float _311 = _133 + _135;
    float _137 = _311;
    precise float _313 = _137 + 1.0;
    float _139 = _313;
    precise float _316 = _125 + _139;
    float _141 = _316;
    float _143 = -fp_c5_1._m0[1].z;
    float _145 = fma(_141, _143, _141);
    precise float _327 = _139 * fp_c5_1._m0[1].z;
    float _147 = _327;
    precise float _330 = _129 + _145;
    float _149 = _330;
    precise float _333 = _147 * _51;
    float _151 = _333;
    precise float _336 = _147 * _53;
    float _153 = _336;
    precise float _339 = _147 * _55;
    float _155 = _339;
    float _157 = fma(_149, _59, _151);
    float _159 = fma(_149, _61, _153);
    float _161 = fma(_149, _63, _155);
    float _163 = fma(_131, _67, _157);
    float _165 = fma(_131, _69, _159);
    float _167 = fma(_131, _71, _161);
    out.x = _163;
    out.y = _165;
    out.z = _167;
    out.w = _149;

    out.xyz = lerp(scene, out.xyz, CUSTOM_DOF);
}

