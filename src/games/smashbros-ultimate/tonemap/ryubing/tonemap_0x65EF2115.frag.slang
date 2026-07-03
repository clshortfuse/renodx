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
    precise float _273 = fp_c3_1._m0[21].z * 960.0;
    float _54 = _273;
    precise float _278 = fp_c3_1._m0[21].w * 540.0;
    float _56 = _278;
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
    precise float _327 = fp_c3_1._m0[21].z * 1920.0;
    float _86 = _327;
    precise float _331 = fp_c3_1._m0[21].w * 1080.0;
    float _88 = _331;
    float _90 = floor(_86);
    float _92 = floor(_88);
    float _94 = fma(_90, fp_c1_1._m0[0].z, -0.0005208333604969084262847900390625);
    float _96 = fma(_92, fp_c1_1._m0[0].w, -0.000925925909541547298431396484375);
    precise float _348 = _62 + _82;
    float _98 = _348;
    precise float _351 = _64 + _84;
    float _100 = _351;
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
    precise float _398 = _127 * 0.4545449912548065185546875;
    float _137 = _398;
    precise float _400 = _131 * 0.4545449912548065185546875;
    float _139 = _400;
    precise float _402 = _135 * 0.4545449912548065185546875;
    float _141 = _402;
    float _143 = exp2(_137);
    precise float _408 = _121 + fp_c6_1._m0[0].z;
    float _145 = _408;
    float _147 = exp2(_139);
    precise float _414 = _123 + fp_c6_1._m0[0].w;
    float _149 = _414;
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
    precise float _458 = _179 + _163;
    float _181 = _458;
    float _183 = -_151;
    precise float _463 = _183 + _165;
    float _185 = _463;
    float _187 = -_147;
    precise float _468 = _187 + _167;
    float _189 = _468;
    float _191 = fma(_181, fp_c5_1._m0[5].y, _143);
    float _193 = fma(_185, fp_c5_1._m0[5].y, _151);
    float _195 = fma(_189, fp_c5_1._m0[5].y, _147);
    precise float _487 = _191 * 1.3703000545501708984375;
    float _197 = _487;
    precise float _489 = _193 * 1.3703000545501708984375;
    float _199 = _489;
    float _201 = abs(_197);
    float _203 = log2(_201);
    precise float _495 = _195 * 1.3703000545501708984375;
    float _205 = _495;
    float _207 = abs(_199);
    float _209 = log2(_207);
    precise float _503 = _177 * fp_c6_1._m0[0].y;
    float _211 = _503;
    float _213 = abs(_205);
    float _215 = log2(_213);
    precise float _510 = _203 * 2.2000000476837158203125;
    float _217 = _510;
    precise float _512 = _209 * 2.2000000476837158203125;
    float _219 = _512;
    precise float _514 = _215 * 2.2000000476837158203125;
    float _221 = _514;
    float _223 = exp2(_217);
    float _225 = exp2(_219);
    float _227 = -_211;
    float _229 = fma(_171, _211, _227);
    float _231 = exp2(_221);
    float _233 = -_211;
    float _235 = fma(_173, _211, _233);
    bool _239 = _119 >= fp_c1_1._m0[1].x;
    float _241 = float(_239);
    float _243 = -_211;
    float _245 = fma(_175, _211, _243);
    precise float _550 = _241 * fp_c5_1._m0[5].x;
    float _247 = _550;
    float _249 = fma(_223, _229, _223);
    float _251 = fma(_225, _235, _225);
    float _253 = fma(_231, _245, _231);
    float _255 = -_247;
    float _257 = fma(_249, _255, _249);
    float _259 = -_247;
    float _261 = fma(_251, _259, _251);
    float _263 = -_247;
    float _265 = fma(_253, _263, _253);
    _47.x = _257;
    _47.y = _261;
    _47.z = _265;
    _47.w = _119;

    ApplyTonemap(_47, _111, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

