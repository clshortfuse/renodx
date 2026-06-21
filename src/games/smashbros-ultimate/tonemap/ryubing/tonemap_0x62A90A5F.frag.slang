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
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_E;

layout(location = 2) in vec4 _42;
layout(location = 3) in vec4 _44;
layout(location = 0) out vec4 _47;

void main()
{
    precise float _281 = fp_c3_1._m0[21].z * 1920.0;
    float _54 = _281;
    precise float _286 = fp_c3_1._m0[21].w * 1080.0;
    float _56 = _286;
    float _58 = floor(_54);
    float _60 = floor(_56);
    float _62 = _42.x;
    float _64 = _42.y;
    float _66 = fma(_58, fp_c1_1._m0[0].x, -0.0005208333604969084262847900390625);
    float _68 = fma(_60, fp_c1_1._m0[0].y, -0.000925925909541547298431396484375);
    float _70 = min(_66, _62);
    float _72 = min(_68, _64);
    float _74 = max(_70, fp_c1_1._m0[0].x);
    float _76 = max(_72, fp_c1_1._m0[0].y);
    vec4 _79 = texture(fp_t_tcb_8, vec2(_74, _76)).xyzw;
    TonemapVanilla(_79);
    float _81 = _79.x;
    float _83 = _79.y;
    float _85 = _79.z;
    float _87 = _79.w;
    float _89 = _42.z;
    float _91 = _42.w;
    precise float _344 = fp_c3_1._m0[21].x * 480.0;
    float _93 = _344;
    float _95 = floor(_93);
    precise float _350 = fp_c3_1._m0[21].y * 270.0;
    float _97 = _350;
    float _99 = floor(_97);
    float _101 = fma(_95, fp_c1_1._m0[0].z, -0.00208333344198763370513916015625);
    float _103 = _44.y;
    float _105 = fma(_99, fp_c1_1._m0[0].w, -0.0037037036381661891937255859375);
    float _107 = min(_101, _89);
    float _109 = _44.x;
    float _111 = min(_105, _91);
    float _113 = max(_107, fp_c1_1._m0[0].z);
    float _115 = max(_111, fp_c1_1._m0[0].w);
    float _117 = abs(_81);
    float _119 = log2(_117);
    float _121 = abs(_85);
    float _123 = log2(_121);
    float _125 = abs(_83);
    float _127 = log2(_125);
    precise float _395 = _119 * 0.4545449912548065185546875;
    float _129 = _395;
    precise float _397 = _123 * 0.4545449912548065185546875;
    float _131 = _397;
    precise float _399 = _127 * 0.4545449912548065185546875;
    float _133 = _399;
    float _135 = exp2(_129);
    float _137 = exp2(_131);
    float _139 = exp2(_133);
    precise float _409 = _109 + fp_c6_1._m0[0].z;
    float _141 = _409;
    float _143 = fma(_137, 0.9375, 0.03125);
    float _145 = fma(_135, 0.9375, 0.03125);
    float _147 = fma(_139, 0.9375, 0.03125);
    vec3 _151 = texture(fp_t_tcb_12, vec3(_145, _147, _143)).xyz;
    float _153 = _151.x;
    float _155 = _151.y;
    float _157 = _151.z;
    precise float _434 = _103 + fp_c6_1._m0[0].w;
    float _159 = _434;
    vec4 _161 = textureLod(fp_t_tcb_14, vec2(_141, _159), fp_c6_1._m0[0].x).xyzw;
    float _163 = _161.x;
    float _165 = _161.y;
    float _167 = _161.z;
    float _169 = _161.w;
    vec4 _171 = texture(fp_t_tcb_E, vec2(_113, _115)).xyzw;
    float _173 = _171.x;
    float _175 = _171.y;
    float _177 = _171.z;
    float _179 = _171.w;
    float _181 = -_135;
    precise float _469 = _181 + _153;
    float _183 = _469;
    float _185 = -_139;
    precise float _474 = _185 + _155;
    float _187 = _474;
    float _189 = -_137;
    precise float _479 = _189 + _157;
    float _191 = _479;
    float _193 = fma(_183, fp_c5_1._m0[5].y, _135);
    float _195 = fma(_187, fp_c5_1._m0[5].y, _139);
    float _197 = fma(_191, fp_c5_1._m0[5].y, _137);
    precise float _498 = _193 * 1.3703000545501708984375;
    float _199 = _498;
    precise float _500 = _195 * 1.3703000545501708984375;
    float _201 = _500;
    float _203 = abs(_199);
    float _205 = log2(_203);
    precise float _506 = _197 * 1.3703000545501708984375;
    float _207 = _506;
    float _209 = abs(_201);
    float _211 = log2(_209);
    precise float _514 = _169 * fp_c6_1._m0[0].y;
    float _213 = _514;
    float _215 = abs(_207);
    float _217 = log2(_215);
    precise float _521 = _205 * 2.2000000476837158203125;
    float _219 = _521;
    precise float _523 = _211 * 2.2000000476837158203125;
    float _221 = _523;
    precise float _525 = _217 * 2.2000000476837158203125;
    float _223 = _525;
    float _225 = exp2(_219);
    float _227 = exp2(_221);
    bool _231 = _87 >= fp_c1_1._m0[1].x;
    float _233 = float(_231);
    float _235 = exp2(_223);
    float _237 = -_213;
    float _239 = fma(_163, _213, _237);
    float _241 = -_213;
    float _243 = fma(_165, _213, _241);
    float _245 = -_213;
    float _247 = fma(_167, _213, _245);
    float _249 = fma(_225, _179, _173);
    float _251 = fma(_227, _179, _175);
    float _253 = fma(_235, _179, _177);
    precise float _573 = _233 * fp_c5_1._m0[5].x;
    float _255 = _573;
    float _257 = fma(_249, _239, _249);
    float _259 = fma(_251, _243, _251);
    float _261 = fma(_253, _247, _253);
    float _263 = -_255;
    float _265 = fma(_257, _263, _257);
    float _267 = -_255;
    float _269 = fma(_259, _267, _259);
    float _271 = -_255;
    float _273 = fma(_261, _271, _261);
    _47.x = _265;
    _47.y = _269;
    _47.z = _273;
    _47.w = _87;

    ApplyTonemap(_47, _79, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

