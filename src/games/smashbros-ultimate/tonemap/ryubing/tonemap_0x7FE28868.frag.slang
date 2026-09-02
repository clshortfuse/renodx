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
    precise float _227 = fp_c3_1._m0[21].z * 1920.0;
    float _52 = _227;
    precise float _232 = fp_c3_1._m0[21].w * 1080.0;
    float _54 = _232;
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
    precise float _301 = _93 * 0.4545449912548065185546875;
    float _103 = _301;
    precise float _303 = _97 * 0.4545449912548065185546875;
    float _105 = _303;
    precise float _305 = _101 * 0.4545449912548065185546875;
    float _107 = _305;
    float _109 = exp2(_103);
    precise float _311 = _87 + fp_c6_1._m0[0].z;
    float _111 = _311;
    float _113 = exp2(_105);
    precise float _317 = _89 + fp_c6_1._m0[0].w;
    float _115 = _317;
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
    precise float _361 = _145 + _129;
    float _147 = _361;
    float _149 = -_117;
    precise float _366 = _149 + _131;
    float _151 = _366;
    float _153 = -_113;
    precise float _371 = _153 + _133;
    float _155 = _371;
    float _157 = fma(_147, fp_c5_1._m0[5].y, _109);
    float _159 = fma(_151, fp_c5_1._m0[5].y, _117);
    float _161 = fma(_155, fp_c5_1._m0[5].y, _113);
    precise float _390 = _157 * 1.3703000545501708984375;
    float _163 = _390;
    precise float _392 = _159 * 1.3703000545501708984375;
    float _165 = _392;
    float _167 = abs(_163);
    float _169 = log2(_167);
    precise float _398 = _161 * 1.3703000545501708984375;
    float _171 = _398;
    float _173 = abs(_165);
    float _175 = log2(_173);
    precise float _406 = _143 * fp_c6_1._m0[0].y;
    float _177 = _406;
    float _179 = abs(_171);
    float _181 = log2(_179);
    precise float _413 = _169 * 2.2000000476837158203125;
    float _183 = _413;
    precise float _415 = _175 * 2.2000000476837158203125;
    float _185 = _415;
    precise float _417 = _181 * 2.2000000476837158203125;
    float _187 = _417;
    float _189 = exp2(_183);
    float _191 = exp2(_185);
    bool _195 = _85 >= fp_c1_1._m0[0].z;
    float _197 = float(_195);
    float _199 = exp2(_187);
    precise float _435 = _197 * fp_c5_1._m0[5].x;
    float _201 = _435;
    float _203 = fma(_137, _177, _189);
    float _205 = fma(_139, _177, _191);
    float _207 = fma(_141, _177, _199);
    float _209 = -_201;
    float _211 = fma(_203, _209, _203);
    float _213 = -_201;
    float _215 = fma(_205, _213, _205);
    float _217 = -_201;
    float _219 = fma(_207, _217, _207);
    _45.x = _211;
    _45.y = _215;
    _45.z = _219;
    _45.w = _85;

    ApplyTonemap(_45, _77, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

