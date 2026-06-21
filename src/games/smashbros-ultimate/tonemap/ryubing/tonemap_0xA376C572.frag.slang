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

layout(location = 2) in vec4 _36;
layout(location = 0) out vec4 _39;

void main()
{
    precise float _219 = fp_c3_1._m0[21].z * 1920.0;
    float _46 = _219;
    precise float _224 = fp_c3_1._m0[21].w * 1080.0;
    float _48 = _224;
    float _50 = floor(_46);
    float _52 = floor(_48);
    float _54 = _36.x;
    float _56 = _36.y;
    float _58 = fma(_50, fp_c1_1._m0[0].x, -0.0005208333604969084262847900390625);
    float _60 = fma(_52, fp_c1_1._m0[0].y, -0.000925925909541547298431396484375);
    float _62 = min(_58, _54);
    float _64 = min(_60, _56);
    float _66 = max(_62, fp_c1_1._m0[0].x);
    float _68 = max(_64, fp_c1_1._m0[0].y);
    vec4 _71 = texture(fp_t_tcb_8, vec2(_66, _68)).xyzw;
    TonemapVanilla(_71);
    float _73 = _71.x;
    float _75 = _71.y;
    float _77 = _71.z;
    float _79 = _71.w;
    float _81 = abs(_73);
    float _83 = log2(_81);
    float _85 = abs(_77);
    float _87 = log2(_85);
    float _89 = abs(_75);
    float _91 = log2(_89);
    precise float _289 = _83 * 0.4545449912548065185546875;
    float _93 = _289;
    precise float _291 = _87 * 0.4545449912548065185546875;
    float _95 = _291;
    precise float _293 = _91 * 0.4545449912548065185546875;
    float _97 = _293;
    float _99 = exp2(_93);
    float _101 = exp2(_95);
    float _103 = exp2(_97);
    float _105 = fma(_99, 0.9375, 0.03125);
    float _107 = fma(_101, 0.9375, 0.03125);
    float _109 = fma(_103, 0.9375, 0.03125);
    vec3 _113 = texture(fp_t_tcb_12, vec3(_105, _109, _107)).xyz;
    float _115 = _113.x;
    float _117 = _113.y;
    float _119 = _113.z;
    float _121 = -_99;
    precise float _325 = _121 + _115;
    float _123 = _325;
    float _125 = -_103;
    precise float _330 = _125 + _117;
    float _127 = _330;
    float _129 = fma(_123, fp_c5_1._m0[5].y, _99);
    float _131 = -_101;
    precise float _341 = _131 + _119;
    float _133 = _341;
    float _135 = fma(_127, fp_c5_1._m0[5].y, _103);
    precise float _349 = _129 * 1.3703000545501708984375;
    float _137 = _349;
    float _139 = abs(_137);
    float _141 = log2(_139);
    float _143 = fma(_133, fp_c5_1._m0[5].y, _101);
    precise float _360 = _135 * 1.3703000545501708984375;
    float _145 = _360;
    float _147 = abs(_145);
    float _149 = log2(_147);
    precise float _366 = _143 * 1.3703000545501708984375;
    float _151 = _366;
    float _153 = abs(_151);
    float _155 = log2(_153);
    precise float _373 = _141 * 2.2000000476837158203125;
    float _157 = _373;
    precise float _375 = _149 * 2.2000000476837158203125;
    float _159 = _375;
    float _161 = exp2(_157);
    precise float _379 = _155 * 2.2000000476837158203125;
    float _163 = _379;
    float _165 = exp2(_159);
    float _167 = exp2(_163);
    precise float _387 = _161 * fp_c5_1._m0[0].x;
    float _169 = _387;
    precise float _391 = _161 * fp_c5_1._m0[1].x;
    float _171 = _391;
    precise float _395 = _161 * fp_c5_1._m0[2].x;
    float _173 = _395;
    float _175 = fma(_165, fp_c5_1._m0[0].y, _169);
    float _177 = fma(_165, fp_c5_1._m0[1].y, _171);
    float _179 = fma(_165, fp_c5_1._m0[2].y, _173);
    bool _183 = _79 >= fp_c1_1._m0[0].z;
    float _185 = float(_183);
    float _187 = fma(_167, fp_c5_1._m0[0].z, _175);
    float _189 = fma(_167, fp_c5_1._m0[1].z, _177);
    float _191 = fma(_167, fp_c5_1._m0[2].z, _179);
    precise float _437 = _185 * fp_c5_1._m0[5].x;
    float _193 = _437;
    precise float _441 = _187 + fp_c5_1._m0[0].w;
    float _195 = _441;
    precise float _445 = _189 + fp_c5_1._m0[1].w;
    float _197 = _445;
    precise float _449 = _191 + fp_c5_1._m0[2].w;
    float _199 = _449;
    float _201 = -_193;
    float _203 = fma(_195, _201, _195);
    float _205 = -_193;
    float _207 = fma(_197, _205, _197);
    float _209 = -_193;
    float _211 = fma(_199, _209, _199);
    _39.x = _203;
    _39.y = _207;
    _39.z = _211;
    _39.w = _79;

    ApplyTonemap(_39, _71, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

