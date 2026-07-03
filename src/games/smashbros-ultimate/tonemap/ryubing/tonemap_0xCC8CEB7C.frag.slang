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
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_E;

layout(location = 2) in vec4 _40;
layout(location = 0) out vec4 _43;

void main()
{
    precise float _275 = fp_c3_1._m0[21].z * 960.0;
    float _50 = _275;
    precise float _280 = fp_c3_1._m0[21].w * 540.0;
    float _52 = _280;
    float _54 = floor(_50);
    precise float _287 = fp_c3_1._m0[21].z * 1920.0;
    float _56 = _287;
    float _58 = floor(_52);
    precise float _293 = fp_c3_1._m0[21].w * 1080.0;
    float _60 = _293;
    float _62 = floor(_56);
    float _64 = _40.x;
    float _66 = _40.y;
    float _68 = floor(_60);
    float _70 = fma(_54, fp_c1_1._m0[0].x, -0.001041666720993816852569580078125);
    float _72 = fma(_62, fp_c1_1._m0[0].z, -0.0005208333604969084262847900390625);
    float _74 = fma(_58, fp_c1_1._m0[0].y, -0.00185185181908309459686279296875);
    float _76 = fma(_68, fp_c1_1._m0[0].w, -0.000925925909541547298431396484375);
    float _78 = min(_70, _64);
    float _80 = min(_74, _66);
    float _82 = min(_72, _64);
    float _84 = min(_76, _66);
    float _86 = max(_78, fp_c1_1._m0[0].x);
    float _88 = max(_80, fp_c1_1._m0[0].y);
    float _90 = max(_82, fp_c1_1._m0[0].z);
    float _92 = max(_84, fp_c1_1._m0[0].w);
    vec4 _95 = texture(fp_t_tcb_C, vec2(_86, _88)).xyzw;
    float _97 = _95.x;
    float _99 = _95.y;
    float _101 = _95.z;
    float _103 = _95.w;
    vec4 _105 = texture(fp_t_tcb_8, vec2(_90, _92)).xyzw;
    TonemapVanilla(_105);
    float _107 = _105.x;
    float _109 = _105.y;
    float _111 = _105.z;
    float _113 = _105.w;
    float _115 = _40.z;
    precise float _386 = fp_c3_1._m0[21].x * 480.0;
    float _117 = _386;
    float _119 = floor(_117);
    float _121 = fma(_119, fp_c1_1._m0[1].y, -0.00208333344198763370513916015625);
    float _123 = min(_121, _115);
    float _125 = fma(_103, _107, _97);
    float _127 = _40.w;
    float _129 = fma(_103, _111, _101);
    float _131 = abs(_125);
    float _133 = log2(_131);
    float _135 = fma(_103, _109, _99);
    float _137 = abs(_129);
    float _139 = log2(_137);
    float _141 = abs(_135);
    float _143 = log2(_141);
    precise float _425 = _133 * 0.4545449912548065185546875;
    float _145 = _425;
    precise float _427 = _139 * 0.4545449912548065185546875;
    float _147 = _427;
    precise float _429 = _143 * 0.4545449912548065185546875;
    float _149 = _429;
    float _151 = exp2(_145);
    float _153 = exp2(_147);
    float _155 = exp2(_149);
    float _157 = fma(_151, 0.9375, 0.03125);
    float _159 = fma(_153, 0.9375, 0.03125);
    float _161 = fma(_155, 0.9375, 0.03125);
    vec3 _165 = texture(fp_t_tcb_12, vec3(_157, _161, _159)).xyz;
    float _167 = _165.x;
    float _169 = _165.y;
    float _171 = _165.z;
    precise float _460 = fp_c3_1._m0[21].y * 270.0;
    float _173 = _460;
    float _175 = floor(_173);
    float _177 = fma(_175, fp_c1_1._m0[1].z, -0.0037037036381661891937255859375);
    float _179 = min(_177, _127);
    float _181 = max(_123, fp_c1_1._m0[1].y);
    float _183 = max(_179, fp_c1_1._m0[1].z);
    vec4 _185 = texture(fp_t_tcb_E, vec2(_181, _183)).xyzw;
    float _187 = _185.x;
    float _189 = _185.y;
    float _191 = _185.z;
    float _193 = _185.w;
    float _195 = -_151;
    precise float _497 = _195 + _167;
    float _197 = _497;
    float _199 = -_155;
    precise float _502 = _199 + _169;
    float _201 = _502;
    float _203 = -_153;
    precise float _507 = _203 + _171;
    float _205 = _507;
    float _207 = fma(_197, fp_c5_1._m0[5].y, _151);
    float _209 = fma(_201, fp_c5_1._m0[5].y, _155);
    float _211 = fma(_205, fp_c5_1._m0[5].y, _153);
    precise float _526 = _207 * 1.3703000545501708984375;
    float _213 = _526;
    precise float _528 = _209 * 1.3703000545501708984375;
    float _215 = _528;
    float _217 = abs(_213);
    float _219 = log2(_217);
    precise float _534 = _211 * 1.3703000545501708984375;
    float _221 = _534;
    float _223 = abs(_215);
    float _225 = log2(_223);
    float _227 = abs(_221);
    float _229 = log2(_227);
    precise float _545 = _219 * 2.2000000476837158203125;
    float _231 = _545;
    precise float _547 = _225 * 2.2000000476837158203125;
    float _233 = _547;
    precise float _549 = _229 * 2.2000000476837158203125;
    float _235 = _549;
    float _237 = exp2(_231);
    float _239 = exp2(_233);
    bool _243 = _113 >= fp_c1_1._m0[1].x;
    float _245 = float(_243);
    float _247 = exp2(_235);
    precise float _567 = _245 * fp_c5_1._m0[5].x;
    float _249 = _567;
    float _251 = fma(_237, _193, _187);
    float _253 = fma(_239, _193, _189);
    float _255 = fma(_247, _193, _191);
    float _257 = -_249;
    float _259 = fma(_251, _257, _251);
    float _261 = -_249;
    float _263 = fma(_253, _261, _253);
    float _265 = -_249;
    float _267 = fma(_255, _265, _255);
    _43.x = _259;
    _43.y = _263;
    _43.z = _267;
    _43.w = _113;

    ApplyTonemap(_43, _105, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

