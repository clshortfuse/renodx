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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_12;

layout(location = 2) in vec4 _38;
layout(location = 0) out vec4 _41;

void main()
{
    precise float _233 = fp_c3_1._m0[21].z * 960.0;
    float _48 = _233;
    precise float _238 = fp_c3_1._m0[21].w * 540.0;
    float _50 = _238;
    float _52 = floor(_48);
    precise float _245 = fp_c3_1._m0[21].z * 1920.0;
    float _54 = _245;
    float _56 = floor(_50);
    precise float _251 = fp_c3_1._m0[21].w * 1080.0;
    float _58 = _251;
    float _60 = floor(_54);
    float _62 = _38.x;
    float _64 = _38.y;
    float _66 = floor(_58);
    float _68 = fma(_52, fp_c1_1._m0[0].x, -0.001041666720993816852569580078125);
    float _70 = fma(_56, fp_c1_1._m0[0].y, -0.00185185181908309459686279296875);
    float _72 = fma(_60, fp_c1_1._m0[0].z, -0.0005208333604969084262847900390625);
    float _74 = fma(_66, fp_c1_1._m0[0].w, -0.000925925909541547298431396484375);
    float _76 = min(_68, _62);
    float _78 = min(_70, _64);
    float _80 = min(_72, _62);
    float _82 = min(_74, _64);
    float _84 = max(_76, fp_c1_1._m0[0].x);
    float _86 = max(_78, fp_c1_1._m0[0].y);
    float _88 = max(_80, fp_c1_1._m0[0].z);
    float _90 = max(_82, fp_c1_1._m0[0].w);
    vec4 _93 = texture(fp_t_tcb_C, vec2(_84, _86)).xyzw;
    float _95 = _93.x;
    float _97 = _93.y;
    float _99 = _93.z;
    float _101 = _93.w;
    vec4 _103 = texture(fp_t_tcb_8, vec2(_88, _90)).xyzw;
    TonemapVanilla(_103);

    float _105 = _103.x;
    float _107 = _103.y;
    float _109 = _103.z;
    float _111 = _103.w;
    float _113 = fma(_101, _105, _95);
    float _115 = fma(_101, _107, _97);
    float _117 = abs(_113);
    float _119 = log2(_117);
    float _121 = fma(_101, _109, _99);
    float _123 = abs(_115);
    float _125 = log2(_123);
    float _127 = abs(_121);
    float _129 = log2(_127);
    precise float _365 = _119 * 0.4545449912548065185546875;
    float _131 = _365;
    precise float _367 = _125 * 0.4545449912548065185546875;
    float _133 = _367;
    precise float _369 = _129 * 0.4545449912548065185546875;
    float _135 = _369;
    float _137 = exp2(_131);
    float _139 = exp2(_133);
    float _141 = exp2(_135);
    float _143 = fma(_137, 0.9375, 0.03125);
    float _145 = fma(_139, 0.9375, 0.03125);
    float _147 = fma(_141, 0.9375, 0.03125);
    vec3 _151 = texture(fp_t_tcb_12, vec3(_143, _145, _147)).xyz;
    float _153 = _151.x;
    float _155 = _151.y;
    float _157 = _151.z;
    float _159 = -_137;
    precise float _401 = _159 + _153;
    float _161 = _401;
    float _163 = -_139;
    precise float _406 = _163 + _155;
    float _165 = _406;
    float _167 = -_141;
    precise float _411 = _167 + _157;
    float _169 = _411;
    float _171 = fma(_161, fp_c5_1._m0[5].y, _137);
    float _173 = fma(_165, fp_c5_1._m0[5].y, _139);
    float _175 = fma(_169, fp_c5_1._m0[5].y, _141);
    precise float _430 = _171 * 1.3703000545501708984375;
    float _177 = _430;
    precise float _432 = _173 * 1.3703000545501708984375;
    float _179 = _432;
    float _181 = abs(_177);
    float _183 = log2(_181);
    precise float _438 = _175 * 1.3703000545501708984375;
    float _185 = _438;
    float _187 = abs(_179);
    float _189 = log2(_187);
    bool _193 = _111 >= fp_c1_1._m0[1].x;
    float _195 = float(_193);
    float _197 = abs(_185);
    float _199 = log2(_197);
    precise float _457 = _183 * 2.2000000476837158203125;
    float _201 = _457;
    precise float _459 = _189 * 2.2000000476837158203125;
    float _203 = _459;
    precise float _461 = _199 * 2.2000000476837158203125;
    float _205 = _461;
    float _207 = exp2(_201);
    float _209 = exp2(_203);
    precise float _469 = _195 * fp_c5_1._m0[5].x;
    float _211 = _469;
    float _213 = exp2(_205);
    float _215 = -_211;
    float _217 = fma(_207, _215, _207);
    float _219 = -_211;
    float _221 = fma(_209, _219, _209);
    float _223 = -_211;
    float _225 = fma(_213, _223, _213);
    _41.x = _217;
    _41.y = _221;
    _41.z = _225;
    _41.w = _111;

    ApplyTonemap(_41, _103, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

