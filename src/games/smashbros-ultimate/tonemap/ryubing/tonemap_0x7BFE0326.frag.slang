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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_12;

layout(location = 2) in vec4 _38;
layout(location = 0) out vec4 _41;

void main()
{
    precise float _229 = fp_c3_1._m0[21].z * 960.0;
    float _48 = _229;
    precise float _234 = fp_c3_1._m0[21].w * 540.0;
    float _50 = _234;
    float _52 = floor(_48);
    float _54 = floor(_50);
    float _56 = _38.x;
    float _58 = _38.y;
    float _60 = fma(_52, fp_c1_1._m0[0].x, -0.001041666720993816852569580078125);
    float _62 = fma(_54, fp_c1_1._m0[0].y, -0.00185185181908309459686279296875);
    float _64 = min(_60, _56);
    float _66 = min(_62, _58);
    float _68 = max(_64, fp_c1_1._m0[0].x);
    float _70 = max(_66, fp_c1_1._m0[0].y);
    vec2 _74 = texture(fp_t_tcb_A, vec2(_68, _70)).xy;
    float _76 = _74.x;
    float _78 = _74.y;
    precise float _283 = fp_c3_1._m0[21].z * 1920.0;
    float _80 = _283;
    precise float _287 = fp_c3_1._m0[21].w * 1080.0;
    float _82 = _287;
    float _84 = floor(_80);
    float _86 = floor(_82);
    float _88 = fma(_84, fp_c1_1._m0[0].z, -0.0005208333604969084262847900390625);
    float _90 = fma(_86, fp_c1_1._m0[0].w, -0.000925925909541547298431396484375);
    precise float _304 = _56 + _76;
    float _92 = _304;
    precise float _307 = _58 + _78;
    float _94 = _307;
    float _96 = min(_88, _92);
    float _98 = min(_90, _94);
    float _100 = max(_96, fp_c1_1._m0[0].z);
    float _102 = max(_98, fp_c1_1._m0[0].w);
    vec4 _105 = texture(fp_t_tcb_8, vec2(_100, _102)).xyzw;
    TonemapVanilla(_105);
    float _107 = _105.x;
    float _109 = _105.y;
    float _111 = _105.z;
    float _113 = _105.w;
    float _115 = abs(_107);
    float _117 = log2(_115);
    float _119 = abs(_111);
    float _121 = log2(_119);
    float _123 = abs(_109);
    float _125 = log2(_123);
    precise float _350 = _117 * 0.4545449912548065185546875;
    float _127 = _350;
    precise float _352 = _121 * 0.4545449912548065185546875;
    float _129 = _352;
    precise float _354 = _125 * 0.4545449912548065185546875;
    float _131 = _354;
    float _133 = exp2(_127);
    float _135 = exp2(_129);
    float _137 = exp2(_131);
    float _139 = fma(_133, 0.9375, 0.03125);
    float _141 = fma(_135, 0.9375, 0.03125);
    float _143 = fma(_137, 0.9375, 0.03125);
    vec3 _147 = texture(fp_t_tcb_12, vec3(_139, _143, _141)).xyz;
    float _149 = _147.x;
    float _151 = _147.y;
    float _153 = _147.z;
    float _155 = -_133;
    precise float _386 = _155 + _149;
    float _157 = _386;
    float _159 = -_137;
    precise float _391 = _159 + _151;
    float _161 = _391;
    float _163 = -_135;
    precise float _396 = _163 + _153;
    float _165 = _396;
    float _167 = fma(_157, fp_c5_1._m0[5].y, _133);
    float _169 = fma(_161, fp_c5_1._m0[5].y, _137);
    float _171 = fma(_165, fp_c5_1._m0[5].y, _135);
    precise float _415 = _167 * 1.3703000545501708984375;
    float _173 = _415;
    precise float _417 = _169 * 1.3703000545501708984375;
    float _175 = _417;
    float _177 = abs(_173);
    float _179 = log2(_177);
    precise float _423 = _171 * 1.3703000545501708984375;
    float _181 = _423;
    float _183 = abs(_175);
    float _185 = log2(_183);
    bool _189 = _113 >= fp_c1_1._m0[1].x;
    float _191 = float(_189);
    float _193 = abs(_181);
    float _195 = log2(_193);
    precise float _442 = _179 * 2.2000000476837158203125;
    float _197 = _442;
    precise float _444 = _185 * 2.2000000476837158203125;
    float _199 = _444;
    precise float _446 = _195 * 2.2000000476837158203125;
    float _201 = _446;
    float _203 = exp2(_197);
    float _205 = exp2(_199);
    precise float _454 = _191 * fp_c5_1._m0[5].x;
    float _207 = _454;
    float _209 = exp2(_201);
    float _211 = -_207;
    float _213 = fma(_203, _211, _203);
    float _215 = -_207;
    float _217 = fma(_205, _215, _205);
    float _219 = -_207;
    float _221 = fma(_209, _219, _209);
    _41.x = _213;
    _41.y = _217;
    _41.z = _221;
    _41.w = _113;

    ApplyTonemap(_41, _105, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

