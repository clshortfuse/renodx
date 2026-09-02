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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_12;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_14;

layout(location = 2) in vec4 _42;
layout(location = 3) in vec4 _44;
layout(location = 0) out vec4 _47;

void main()
{
    precise float _261 = fp_c3_1._m0[21].z * 960.0;
    float _54 = _261;
    precise float _266 = fp_c3_1._m0[21].w * 540.0;
    float _56 = _266;
    float _58 = floor(_54);
    float _60 = floor(_56);
    float _62 = _42.x;
    float _64 = _42.y;
    float _66 = fma(_58, fp_c1_1._m0[0].x, -0.001041666720993816852569580078125);
    float _68 = fma(_60, fp_c1_1._m0[0].y, -0.00185185181908309459686279296875);
    float _70 = min(_66, _62);
    float _72 = min(_68, _64);
    float _74 = max(_70, fp_c1_1._m0[0].x);
    float _76 = max(_72, fp_c1_1._m0[0].y);
    vec2 _80 = texture(fp_t_tcb_A, vec2(_74, _76)).xy;
    float _82 = _80.x;
    float _84 = _80.y;
    precise float _315 = fp_c3_1._m0[21].z * 1920.0;
    float _86 = _315;
    precise float _319 = fp_c3_1._m0[21].w * 1080.0;
    float _88 = _319;
    float _90 = floor(_86);
    float _92 = floor(_88);
    float _94 = fma(_90, fp_c1_1._m0[0].z, -0.0005208333604969084262847900390625);
    float _96 = fma(_92, fp_c1_1._m0[0].w, -0.000925925909541547298431396484375);
    precise float _336 = _62 + _82;
    float _98 = _336;
    precise float _339 = _64 + _84;
    float _100 = _339;
    float _102 = min(_94, _98);
    float _104 = min(_96, _100);
    float _106 = max(_102, fp_c1_1._m0[0].z);
    float _108 = max(_104, fp_c1_1._m0[0].w);
    vec4 _111 = texture(fp_t_tcb_8, vec2(_106, _108)).xyzw;
    TonemapVanilla(_111);

    float _113 = _111.x;
    float _115 = _111.y;
    float _117 = _111.z;
    float _119 = _111.w;
    float _121 = _44.x;
    float _123 = _44.y;
    float _125 = abs(_113);
    float _127 = log2(_125);
    float _129 = abs(_117);
    float _131 = log2(_129);
    float _133 = abs(_115);
    float _135 = log2(_133);
    precise float _386 = _127 * 0.4545449912548065185546875;
    float _137 = _386;
    precise float _388 = _131 * 0.4545449912548065185546875;
    float _139 = _388;
    precise float _390 = _135 * 0.4545449912548065185546875;
    float _141 = _390;
    float _143 = exp2(_137);
    precise float _396 = _121 + fp_c6_1._m0[0].z;
    float _145 = _396;
    float _147 = exp2(_139);
    precise float _402 = _123 + fp_c6_1._m0[0].w;
    float _149 = _402;
    float _151 = exp2(_141);
    float _153 = fma(_143, 0.9375, 0.03125);
    float _155 = fma(_147, 0.9375, 0.03125);
    float _157 = fma(_151, 0.9375, 0.03125);
    vec3 _161 = texture(fp_t_tcb_12, vec3(_153, _157, _155)).xyz;
    float _163 = _161.x;
    float _165 = _161.y;
    float _167 = _161.z;
    vec4 _169 = textureLod(fp_t_tcb_14, vec2(_145, _149), fp_c6_1._m0[0].x).xyzw;
    float _171 = _169.x;
    float _173 = _169.y;
    float _175 = _169.z;
    float _177 = _169.w;
    float _179 = -_143;
    precise float _446 = _179 + _163;
    float _181 = _446;
    float _183 = -_151;
    precise float _451 = _183 + _165;
    float _185 = _451;
    float _187 = -_147;
    precise float _456 = _187 + _167;
    float _189 = _456;
    float _191 = fma(_181, fp_c5_1._m0[5].y, _143);
    float _193 = fma(_185, fp_c5_1._m0[5].y, _151);
    float _195 = fma(_189, fp_c5_1._m0[5].y, _147);
    precise float _475 = _191 * 1.3703000545501708984375;
    float _197 = _475;
    precise float _477 = _193 * 1.3703000545501708984375;
    float _199 = _477;
    float _201 = abs(_197);
    float _203 = log2(_201);
    precise float _483 = _195 * 1.3703000545501708984375;
    float _205 = _483;
    float _207 = abs(_199);
    float _209 = log2(_207);
    precise float _491 = _177 * fp_c6_1._m0[0].y;
    float _211 = _491;
    float _213 = abs(_205);
    float _215 = log2(_213);
    precise float _498 = _203 * 2.2000000476837158203125;
    float _217 = _498;
    precise float _500 = _209 * 2.2000000476837158203125;
    float _219 = _500;
    precise float _502 = _215 * 2.2000000476837158203125;
    float _221 = _502;
    float _223 = exp2(_217);
    float _225 = exp2(_219);
    bool _229 = _119 >= fp_c1_1._m0[1].x;
    float _231 = float(_229);
    float _233 = exp2(_221);
    precise float _520 = _231 * fp_c5_1._m0[5].x;
    float _235 = _520;
    float _237 = fma(_171, _211, _223);
    float _239 = fma(_173, _211, _225);
    float _241 = fma(_175, _211, _233);
    float _243 = -_235;
    float _245 = fma(_237, _243, _237);
    float _247 = -_235;
    float _249 = fma(_239, _247, _239);
    float _251 = -_235;
    float _253 = fma(_241, _251, _241);
    _47.x = _245;
    _47.y = _249;
    _47.z = _253;
    _47.w = _119;

    ApplyTonemap(_47, _111, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

