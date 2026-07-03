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

layout(set = 0, binding = 25, std140) uniform fp_c6
{
    vec4 _m0[4096];
} fp_c6_1;

layout(set = 0, binding = 24, std140) uniform fp_c5
{
    vec4 _m0[4096];
} fp_c5_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler3D fp_t_tcb_12;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_14;

layout(location = 2) in vec4 _40;
layout(location = 3) in vec4 _42;
layout(location = 0) out vec4 _45;

void main()
{
    precise float _239 = fp_c3_1._m0[21].z * 1920.0;
    float _52 = _239;
    precise float _244 = fp_c3_1._m0[21].w * 1080.0;
    float _54 = _244;
    float _56 = floor(_52);
    float _58 = floor(_54);
    float _60 = _40.x;
    float _62 = _40.y;
    float _64 = fma(_56, fp_c1_1._m0[0].x, -0.0005208333604969084262847900390625);
    float _66 = fma(_58, fp_c1_1._m0[0].y, -0.000925925909541547298431396484375);
    float _68 = min(_64, _60);
    float _70 = min(_66, _62);
    float _72 = max(_68, fp_c1_1._m0[0].x);
    float _74 = max(_70, fp_c1_1._m0[0].y);
    vec4 _77 = texture(fp_t_tcb_8, vec2(_72, _74)).xyzw;
    TonemapVanilla(_77);
    float _79 = _77.x;
    float _81 = _77.y;
    float _83 = _77.z;
    float _85 = _77.w;
    float _87 = _42.x;
    float _89 = _42.y;
    float _91 = abs(_79);
    float _93 = log2(_91);
    float _95 = abs(_83);
    float _97 = log2(_95);
    float _99 = abs(_81);
    float _101 = log2(_99);
    precise float _313 = _93 * 0.4545449912548065185546875;
    float _103 = _313;
    precise float _315 = _97 * 0.4545449912548065185546875;
    float _105 = _315;
    precise float _317 = _101 * 0.4545449912548065185546875;
    float _107 = _317;
    float _109 = exp2(_103);
    precise float _323 = _87 + fp_c6_1._m0[0].z;
    float _111 = _323;
    float _113 = exp2(_105);
    precise float _329 = _89 + fp_c6_1._m0[0].w;
    float _115 = _329;
    float _117 = exp2(_107);
    float _119 = fma(_109, 0.9375, 0.03125);
    float _121 = fma(_113, 0.9375, 0.03125);
    float _123 = fma(_117, 0.9375, 0.03125);
    vec3 _127 = texture(fp_t_tcb_12, vec3(_119, _123, _121)).xyz;
    float _129 = _127.x;
    float _131 = _127.y;
    float _133 = _127.z;
    vec4 _135 = textureLod(fp_t_tcb_14, vec2(_111, _115), fp_c6_1._m0[0].x).xyzw;
    float _137 = _135.x;
    float _139 = _135.y;
    float _141 = _135.z;
    float _143 = _135.w;
    float _145 = -_109;
    precise float _373 = _145 + _129;
    float _147 = _373;
    float _149 = -_117;
    precise float _378 = _149 + _131;
    float _151 = _378;
    float _153 = -_113;
    precise float _383 = _153 + _133;
    float _155 = _383;
    float _157 = fma(_147, fp_c5_1._m0[5].y, _109);
    float _159 = fma(_151, fp_c5_1._m0[5].y, _117);
    float _161 = fma(_155, fp_c5_1._m0[5].y, _113);
    precise float _402 = _157 * 1.3703000545501708984375;
    float _163 = _402;
    precise float _404 = _159 * 1.3703000545501708984375;
    float _165 = _404;
    float _167 = abs(_163);
    float _169 = log2(_167);
    precise float _410 = _161 * 1.3703000545501708984375;
    float _171 = _410;
    float _173 = abs(_165);
    float _175 = log2(_173);
    precise float _418 = _143 * fp_c6_1._m0[0].y;
    float _177 = _418;
    float _179 = abs(_171);
    float _181 = log2(_179);
    precise float _425 = _169 * 2.2000000476837158203125;
    float _183 = _425;
    precise float _427 = _175 * 2.2000000476837158203125;
    float _185 = _427;
    precise float _429 = _181 * 2.2000000476837158203125;
    float _187 = _429;
    float _189 = exp2(_183);
    float _191 = exp2(_185);
    float _193 = -_177;
    float _195 = fma(_137, _177, _193);
    float _197 = exp2(_187);
    float _199 = -_177;
    float _201 = fma(_139, _177, _199);
    bool _205 = _85 >= fp_c1_1._m0[0].z;
    float _207 = float(_205);
    float _209 = -_177;
    float _211 = fma(_141, _177, _209);
    precise float _465 = _207 * fp_c5_1._m0[5].x;
    float _213 = _465;
    float _215 = fma(_189, _195, _189);
    float _217 = fma(_191, _201, _191);
    float _219 = fma(_197, _211, _197);
    float _221 = -_213;
    float _223 = fma(_215, _221, _215);
    float _225 = -_213;
    float _227 = fma(_217, _225, _217);
    float _229 = -_213;
    float _231 = fma(_219, _229, _219);
    _45.x = _223;
    _45.y = _227;
    _45.z = _231;
    _45.w = _85;

    ApplyTonemap(_45, _77, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

