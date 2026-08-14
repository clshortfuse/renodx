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
    precise float _237 = fp_c3_1._m0[21].z * 1920.0;
    float _48 = _237;
    precise float _242 = fp_c3_1._m0[21].w * 1080.0;
    float _50 = _242;
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
    precise float _300 = fp_c3_1._m0[21].x * 480.0;
    float _87 = _300;
    float _89 = floor(_87);
    float _91 = fma(_89, fp_c1_1._m0[0].z, -0.00208333344198763370513916015625);
    float _93 = min(_91, _83);
    precise float _314 = fp_c3_1._m0[21].y * 270.0;
    float _95 = _314;
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
    precise float _343 = _107 * 0.4545449912548065185546875;
    float _117 = _343;
    precise float _345 = _111 * 0.4545449912548065185546875;
    float _119 = _345;
    precise float _347 = _115 * 0.4545449912548065185546875;
    float _121 = _347;
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
    precise float _397 = _157 + _141;
    float _159 = _397;
    float _161 = -_129;
    precise float _402 = _161 + _143;
    float _163 = _402;
    float _165 = -_125;
    precise float _407 = _165 + _145;
    float _167 = _407;
    float _169 = fma(_159, fp_c5_1._m0[5].y, _123);
    float _171 = fma(_163, fp_c5_1._m0[5].y, _129);
    float _173 = fma(_167, fp_c5_1._m0[5].y, _125);
    precise float _426 = _169 * 1.3703000545501708984375;
    float _175 = _426;
    precise float _428 = _171 * 1.3703000545501708984375;
    float _177 = _428;
    float _179 = abs(_175);
    float _181 = log2(_179);
    precise float _434 = _173 * 1.3703000545501708984375;
    float _183 = _434;
    float _185 = abs(_177);
    float _187 = log2(_185);
    float _189 = abs(_183);
    float _191 = log2(_189);
    precise float _445 = _181 * 2.2000000476837158203125;
    float _193 = _445;
    precise float _447 = _187 * 2.2000000476837158203125;
    float _195 = _447;
    precise float _449 = _191 * 2.2000000476837158203125;
    float _197 = _449;
    float _199 = exp2(_193);
    float _201 = exp2(_195);
    bool _205 = _81 >= fp_c1_1._m0[1].x;
    float _207 = float(_205);
    float _209 = exp2(_197);
    precise float _467 = _207 * fp_c5_1._m0[5].x;
    float _211 = _467;
    float _213 = fma(_199, _155, _149);
    float _215 = fma(_201, _155, _151);
    float _217 = fma(_209, _155, _153);
    float _219 = -_211;
    float _221 = fma(_213, _219, _213);
    float _223 = -_211;
    float _225 = fma(_215, _223, _215);
    float _227 = -_211;
    float _229 = fma(_217, _227, _217);
    _41.x = _221;
    _41.y = _225;
    _41.z = _229;
    _41.w = _81;

    ApplyTonemap(_41, _73, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

