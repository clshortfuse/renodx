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
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_10;

layout(location = 2) in vec4 _38;
layout(location = 0) out vec4 _41;

void main()
{
    precise float _249 = fp_c3_1._m0[21].z * 1920.0;
    float _48 = _249;
    precise float _254 = fp_c3_1._m0[21].w * 1080.0;
    float _50 = _254;
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
    precise float _310 = fp_c3_1._m0[21].x * 480.0;
    float _85 = _310;
    float _87 = _38.w;
    float _89 = floor(_85);
    float _91 = fma(_89, fp_c1_1._m0[0].z, -0.00208333344198763370513916015625);
    float _93 = min(_91, _83);
    precise float _326 = fp_c3_1._m0[21].y * 270.0;
    float _95 = _326;
    float _97 = floor(_95);
    float _99 = fma(_97, fp_c1_1._m0[0].w, -0.0037037036381661891937255859375);
    float _101 = min(_99, _87);
    float _103 = max(_93, fp_c1_1._m0[0].z);
    float _105 = max(_101, fp_c1_1._m0[0].w);
    float _107 = abs(_75);
    float _109 = log2(_107);
    float _111 = abs(_79);
    float _113 = log2(_111);
    float _115 = abs(_77);
    float _117 = log2(_115);
    precise float _359 = _109 * 0.4545449912548065185546875;
    float _119 = _359;
    precise float _361 = _113 * 0.4545449912548065185546875;
    float _121 = _361;
    precise float _363 = _117 * 0.4545449912548065185546875;
    float _123 = _363;
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
    vec3 _147 = texture(fp_t_tcb_10, vec2(_103, _105)).xyz;
    float _149 = _147.x;
    float _151 = _147.y;
    float _153 = _147.z;
    float _155 = -_129;
    precise float _407 = _155 + _143;
    float _157 = _407;
    float _159 = -_125;
    precise float _412 = _159 + _141;
    float _161 = _412;
    float _163 = -_127;
    precise float _417 = _163 + _145;
    float _165 = _417;
    float _167 = fma(_157, fp_c5_1._m0[5].y, _129);
    float _169 = fma(_161, fp_c5_1._m0[5].y, _125);
    float _171 = fma(_165, fp_c5_1._m0[5].y, _127);
    precise float _436 = _167 * 1.3703000545501708984375;
    float _173 = _436;
    precise float _438 = _169 * 1.3703000545501708984375;
    float _175 = _438;
    float _177 = abs(_173);
    float _179 = log2(_177);
    precise float _444 = _171 * 1.3703000545501708984375;
    float _181 = _444;
    float _183 = abs(_175);
    float _185 = log2(_183);
    float _187 = max(_81, 0.5);
    float _189 = abs(_181);
    float _191 = log2(_189);
    precise float _458 = _179 * 2.2000000476837158203125;
    float _193 = _458;
    precise float _460 = _185 * 2.2000000476837158203125;
    float _195 = _460;
    precise float _462 = _191 * 2.2000000476837158203125;
    float _197 = _462;
    float _199 = exp2(_193);
    float _201 = exp2(_195);
    float _203 = -_149;
    float _205 = fma(_187, _203, _149);
    float _207 = exp2(_197);
    bool _211 = _81 >= fp_c1_1._m0[1].x;
    float _213 = float(_211);
    float _215 = -_151;
    float _217 = fma(_187, _215, _151);
    float _219 = -_153;
    float _221 = fma(_187, _219, _153);
    precise float _498 = _213 * fp_c5_1._m0[5].x;
    float _223 = _498;
    float _225 = fma(_187, _199, _217);
    float _227 = fma(_187, _201, _205);
    float _229 = fma(_187, _207, _221);
    float _231 = -_223;
    float _233 = fma(_225, _231, _225);
    float _235 = -_223;
    float _237 = fma(_227, _235, _227);
    float _239 = -_223;
    float _241 = fma(_229, _239, _229);
    _41.x = _237;
    _41.y = _233;
    _41.z = _241;
    _41.w = saturate(_81);

    ApplyTonemap(_41, _73, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

