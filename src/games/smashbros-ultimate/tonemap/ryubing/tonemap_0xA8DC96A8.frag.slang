#version 450

#include "../common.slang"

layout(set = 0, binding = 0, std140) uniform support_buffer
{
    uint _m0;
    uint _m1[8];
    vec4 _m2;
    vec4 _m3;
    int _m4;
    float _m5[73];
    ivec4 _m6;
    int _m7;
} support_buffer_1;

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 0, binding = 24, std140) uniform fp_c5
{
    vec4 _m0[4096];
} fp_c5_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler3D fp_t_tcb_12;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_E;

layout(location = 2) in vec4 _38;
layout(location = 0) out vec4 _41;

void main()
{
    precise float _261 = fp_c3_1._m0[21].z * 1920.0;
    float _48 = _261;
    precise float _266 = fp_c3_1._m0[21].w * 1080.0;
    float _50 = _266;
    float _52 = floor(_48);
    float _54 = floor(_50);
    float _56 = _38.x;
    float _58 = _38.y;
    float _60 = fma(_52, fp_c1_1._m0[0].x, -0.0005208333604969084262847900390625);
    float _62 = fma(_54, fp_c1_1._m0[0].y, -0.000925925909541547298431396484375);
    float _64 = min(_60, _56);
    float _66 = min(_62, _58);
    float _68 = max(_64, fp_c1_1._m0[0].x);
    float _70 = max(_66, fp_c1_1._m0[0].y);
    vec4 _73 = texture(fp_t_tcb_8, vec2(_68, _70)).xyzw;
    TonemapVanilla(_73);
    float _75 = _73.x;
    float _77 = _73.y;
    float _79 = _73.z;
    float _81 = _73.w;
    float _83 = _38.z;
    float _85 = _38.w;
    precise float _324 = fp_c3_1._m0[21].x * 480.0;
    float _87 = _324;
    float _89 = floor(_87);
    float _91 = fma(_89, fp_c1_1._m0[0].z, -0.00208333344198763370513916015625);
    float _93 = min(_91, _83);
    precise float _338 = fp_c3_1._m0[21].y * 270.0;
    float _95 = _338;
    float _97 = floor(_95);
    float _99 = fma(_97, fp_c1_1._m0[0].w, -0.0037037036381661891937255859375);
    float _101 = min(_99, _85);
    float _103 = max(_101, fp_c1_1._m0[0].w);
    float _105 = abs(_75);
    float _107 = log2(_105);
    float _109 = abs(_79);
    float _111 = log2(_109);
    float _113 = abs(_77);
    float _115 = log2(_113);
    precise float _367 = _107 * 0.4545449912548065185546875;
    float _117 = _367;
    precise float _369 = _111 * 0.4545449912548065185546875;
    float _119 = _369;
    precise float _371 = _115 * 0.4545449912548065185546875;
    float _121 = _371;
    float _123 = exp2(_117);
    float _125 = exp2(_119);
    float _127 = max(_93, fp_c1_1._m0[0].z);
    float _129 = exp2(_121);
    float _131 = fma(_123, 0.9375, 0.03125);
    float _133 = fma(_125, 0.9375, 0.03125);
    float _135 = fma(_129, 0.9375, 0.03125);
    vec3 _139 = texture(fp_t_tcb_12, vec3(_131, _135, _133)).xyz;
    float _141 = _139.x;
    float _143 = _139.y;
    float _145 = _139.z;
    vec4 _147 = texture(fp_t_tcb_E, vec2(_127, _103)).xyzw;
    float _149 = _147.x;
    float _151 = _147.y;
    float _153 = _147.z;
    float _155 = _147.w;
    float _157 = -_123;
    precise float _421 = _157 + _141;
    float _159 = _421;
    float _161 = -_129;
    precise float _426 = _161 + _143;
    float _163 = _426;
    float _165 = fma(_159, fp_c5_1._m0[5].y, _123);
    float _167 = fma(_163, fp_c5_1._m0[5].y, _129);
    float _169 = -_125;
    precise float _442 = _169 + _145;
    float _171 = _442;
    precise float _445 = _165 * 1.3703000545501708984375;
    float _173 = _445;
    float _175 = abs(_173);
    float _177 = log2(_175);
    precise float _451 = _167 * 1.3703000545501708984375;
    float _179 = _451;
    float _181 = fma(_171, fp_c5_1._m0[5].y, _125);
    float _183 = abs(_179);
    float _185 = log2(_183);
    precise float _462 = _181 * 1.3703000545501708984375;
    float _187 = _462;
    float _189 = abs(_187);
    float _191 = log2(_189);
    precise float _469 = _177 * 2.2000000476837158203125;
    float _193 = _469;
    precise float _471 = _185 * 2.2000000476837158203125;
    float _195 = _471;
    float _197 = exp2(_193);
    precise float _475 = _191 * 2.2000000476837158203125;
    float _199 = _475;
    float _201 = exp2(_195);
    float _203 = exp2(_199);
    precise float _483 = _197 * fp_c5_1._m0[0].x;
    float _205 = _483;
    precise float _487 = _197 * fp_c5_1._m0[1].x;
    float _207 = _487;
    precise float _491 = _197 * fp_c5_1._m0[2].x;
    float _209 = _491;
    float _211 = fma(_201, fp_c5_1._m0[0].y, _205);
    float _213 = fma(_201, fp_c5_1._m0[1].y, _207);
    float _215 = fma(_201, fp_c5_1._m0[2].y, _209);
    float _217 = fma(_203, fp_c5_1._m0[0].z, _211);
    float _219 = fma(_203, fp_c5_1._m0[1].z, _213);
    float _221 = fma(_203, fp_c5_1._m0[2].z, _215);
    bool _225 = _81 >= fp_c1_1._m0[1].x;
    float _227 = float(_225);
    precise float _533 = _217 + fp_c5_1._m0[0].w;
    float _229 = _533;
    precise float _537 = _219 + fp_c5_1._m0[1].w;
    float _231 = _537;
    precise float _541 = _221 + fp_c5_1._m0[2].w;
    float _233 = _541;
    precise float _545 = _227 * fp_c5_1._m0[5].x;
    float _235 = _545;
    float _237 = fma(_229, _155, _149);
    float _239 = fma(_231, _155, _151);
    float _241 = fma(_233, _155, _153);
    float _243 = -_235;
    float _245 = fma(_237, _243, _237);
    float _247 = -_235;
    float _249 = fma(_239, _247, _239);
    float _251 = -_235;
    float _253 = fma(_241, _251, _241);
    _41.x = _245;
    _41.y = _249;
    _41.z = _253;
    _41.w = _81;

    ApplyTonemap(_41, _73, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

