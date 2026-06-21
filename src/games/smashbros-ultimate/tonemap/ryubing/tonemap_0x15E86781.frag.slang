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
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_16;

layout(location = 2) in vec4 _38;
layout(location = 0) out vec4 _41;

void main()
{
    precise float _263 = fp_c3_1._m0[21].z * 1920.0;
    float _48 = _263;
    precise float _268 = fp_c3_1._m0[21].w * 1080.0;
    float _50 = _268;
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
    precise float _326 = fp_c3_1._m0[21].x * 960.0;
    float _87 = _326;
    float _89 = floor(_87);
    float _91 = fma(_89, fp_c1_1._m0[0].z, -0.001041666720993816852569580078125);
    float _93 = min(_91, _83);
    precise float _340 = fp_c3_1._m0[21].y * 540.0;
    float _95 = _340;
    float _97 = floor(_95);
    float _99 = fma(_97, fp_c1_1._m0[0].w, -0.00185185181908309459686279296875);
    float _101 = min(_99, _85);
    float _103 = max(_93, fp_c1_1._m0[0].z);
    float _105 = max(_101, fp_c1_1._m0[0].w);
    float _107 = abs(_75);
    float _109 = log2(_107);
    float _111 = abs(_79);
    float _113 = log2(_111);
    float _115 = abs(_77);
    float _117 = log2(_115);
    precise float _373 = _109 * 0.4545449912548065185546875;
    float _119 = _373;
    precise float _375 = _113 * 0.4545449912548065185546875;
    float _121 = _375;
    precise float _377 = _117 * 0.4545449912548065185546875;
    float _123 = _377;
    float _125 = exp2(_119);
    float _127 = exp2(_121);
    float _129 = exp2(_123);
    float _131 = fma(_125, 0.9375, 0.03125);
    float _133 = fma(_127, 0.9375, 0.03125);
    float _135 = fma(_129, 0.9375, 0.03125);
    vec3 _139 = texture(fp_t_tcb_12, vec3(_131, _135, _133)).xyz;
    float _141 = _139.x;
    float _143 = _139.y;
    float _145 = _139.z;
    vec3 _147 = texture(fp_t_tcb_16, vec2(_103, _105)).xyz;
    float _149 = _147.x;
    float _151 = _147.y;
    float _153 = _147.z;
    float _155 = -_125;
    precise float _421 = _155 + _141;
    float _157 = _421;
    float _159 = -_129;
    precise float _426 = _159 + _143;
    float _161 = _426;
    float _163 = -_127;
    precise float _431 = _163 + _145;
    float _165 = _431;
    float _167 = fma(_157, fp_c5_1._m0[5].y, _125);
    float _169 = fma(_161, fp_c5_1._m0[5].y, _129);
    float _171 = fma(_165, fp_c5_1._m0[5].y, _127);
    precise float _450 = _167 * 1.3703000545501708984375;
    float _173 = _450;
    precise float _452 = _169 * 1.3703000545501708984375;
    float _175 = _452;
    float _177 = abs(_173);
    float _179 = log2(_177);
    precise float _458 = _171 * 1.3703000545501708984375;
    float _181 = _458;
    float _183 = abs(_175);
    float _185 = log2(_183);
    bool _189 = _81 >= fp_c1_1._m0[1].x;
    float _191 = float(_189);
    float _193 = abs(_181);
    float _195 = log2(_193);
    precise float _477 = _179 * 2.2000000476837158203125;
    float _197 = _477;
    precise float _479 = _185 * 2.2000000476837158203125;
    float _199 = _479;
    precise float _481 = _195 * 2.2000000476837158203125;
    float _201 = _481;
    float _203 = exp2(_197);
    float _205 = exp2(_199);
    precise float _488 = _149 + _151;
    float _207 = _488;
    float _209 = exp2(_201);
    precise float _494 = _191 * fp_c5_1._m0[5].x;
    float _211 = _494;
    precise float _497 = _153 + _207;
    float _213 = _497;
    float _215 = -_211;
    float _217 = fma(_203, _215, _203);
    float _219 = -_211;
    float _221 = fma(_205, _219, _205);
    float _223 = -_209;
    float _225 = fma(_211, _223, _209);
    bool _227 = _213 >= fp_c1_1._m0[1].x;
    float _229 = float(_227);
    precise float _524 = _217 + _149;
    float _231 = _524;
    precise float _527 = _221 + _151;
    float _233 = _527;
    precise float _530 = _225 + _153;
    float _235 = _530;
    precise float _533 = _191 * _229;
    float _237 = _533;
    float _239 = -_217;
    float _241 = fma(_231, 0.5, _239);
    float _243 = -_221;
    float _245 = fma(_233, 0.5, _243);
    float _247 = -_225;
    float _249 = fma(_235, 0.5, _247);
    float _251 = fma(_241, _237, _217);
    float _253 = fma(_245, _237, _221);
    float _255 = fma(_249, _237, _225);
    _41.x = _251;
    _41.y = _253;
    _41.z = _255;
    _41.w = _81;

    ApplyTonemap(_41, _73, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

