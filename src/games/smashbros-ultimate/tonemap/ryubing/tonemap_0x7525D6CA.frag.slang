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
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_E;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_14;

layout(location = 2) in vec4 _42;
layout(location = 3) in vec4 _44;
layout(location = 0) out vec4 _47;

void main()
{
    precise float _293 = fp_c3_1._m0[21].z * 1920.0;
    float _54 = _293;
    precise float _298 = fp_c3_1._m0[21].w * 1080.0;
    float _56 = _298;
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
    float _89 = _42.w;
    float _91 = _42.z;
    precise float _356 = fp_c3_1._m0[21].x * 480.0;
    float _93 = _356;
    float _95 = floor(_93);
    precise float _362 = fp_c3_1._m0[21].y * 270.0;
    float _97 = _362;
    float _99 = floor(_97);
    float _101 = fma(_95, fp_c1_1._m0[0].z, -0.00208333344198763370513916015625);
    float _103 = _44.y;
    float _105 = fma(_99, fp_c1_1._m0[0].w, -0.0037037036381661891937255859375);
    float _107 = min(_105, _89);
    float _109 = min(_101, _91);
    float _111 = _44.x;
    float _113 = max(_109, fp_c1_1._m0[0].z);
    float _115 = abs(_81);
    float _117 = log2(_115);
    float _119 = abs(_85);
    float _121 = log2(_119);
    float _123 = abs(_83);
    float _125 = log2(_123);
    precise float _403 = _117 * 0.4545449912548065185546875;
    float _127 = _403;
    precise float _405 = _121 * 0.4545449912548065185546875;
    float _129 = _405;
    precise float _407 = _125 * 0.4545449912548065185546875;
    float _131 = _407;
    float _133 = exp2(_127);
    float _135 = exp2(_129);
    float _137 = exp2(_131);
    precise float _417 = _103 + fp_c6_1._m0[0].w;
    float _139 = _417;
    float _141 = fma(_135, 0.9375, 0.03125);
    float _143 = fma(_133, 0.9375, 0.03125);
    float _145 = fma(_137, 0.9375, 0.03125);
    vec3 _149 = texture(fp_t_tcb_12, vec3(_143, _145, _141)).xyz;
    float _151 = _149.x;
    float _153 = _149.y;
    float _155 = _149.z;
    precise float _442 = _111 + fp_c6_1._m0[0].z;
    float _157 = _442;
    float _159 = max(_107, fp_c1_1._m0[0].w);
    vec4 _161 = texture(fp_t_tcb_E, vec2(_113, _159)).xyzw;
    float _163 = _161.x;
    float _165 = _161.y;
    float _167 = _161.z;
    float _169 = _161.w;
    vec4 _171 = textureLod(fp_t_tcb_14, vec2(_157, _139), fp_c6_1._m0[0].x).xyzw;
    float _173 = _171.x;
    float _175 = _171.y;
    float _177 = _171.z;
    float _179 = _171.w;
    float _181 = -_133;
    precise float _481 = _181 + _151;
    float _183 = _481;
    float _185 = -_137;
    precise float _486 = _185 + _153;
    float _187 = _486;
    float _189 = fma(_183, fp_c5_1._m0[5].y, _133);
    float _191 = fma(_187, fp_c5_1._m0[5].y, _137);
    float _193 = -_135;
    precise float _502 = _193 + _155;
    float _195 = _502;
    precise float _505 = _189 * 1.3703000545501708984375;
    float _197 = _505;
    float _199 = abs(_197);
    float _201 = log2(_199);
    precise float _511 = _191 * 1.3703000545501708984375;
    float _203 = _511;
    float _205 = fma(_195, fp_c5_1._m0[5].y, _135);
    float _207 = abs(_203);
    float _209 = log2(_207);
    precise float _522 = _205 * 1.3703000545501708984375;
    float _211 = _522;
    float _213 = abs(_211);
    float _215 = log2(_213);
    precise float _529 = _201 * 2.2000000476837158203125;
    float _217 = _529;
    precise float _531 = _209 * 2.2000000476837158203125;
    float _219 = _531;
    float _221 = exp2(_217);
    precise float _535 = _215 * 2.2000000476837158203125;
    float _223 = _535;
    float _225 = exp2(_219);
    float _227 = exp2(_223);
    precise float _543 = _221 * fp_c5_1._m0[0].x;
    float _229 = _543;
    precise float _547 = _221 * fp_c5_1._m0[1].x;
    float _231 = _547;
    precise float _551 = _221 * fp_c5_1._m0[2].x;
    float _233 = _551;
    float _235 = fma(_225, fp_c5_1._m0[0].y, _229);
    float _237 = fma(_225, fp_c5_1._m0[1].y, _231);
    float _239 = fma(_225, fp_c5_1._m0[2].y, _233);
    float _241 = fma(_227, fp_c5_1._m0[0].z, _235);
    float _243 = fma(_227, fp_c5_1._m0[1].z, _237);
    float _245 = fma(_227, fp_c5_1._m0[2].z, _239);
    precise float _585 = _241 + fp_c5_1._m0[0].w;
    float _247 = _585;
    precise float _589 = _243 + fp_c5_1._m0[1].w;
    float _249 = _589;
    precise float _593 = _245 + fp_c5_1._m0[2].w;
    float _251 = _593;
    bool _255 = _87 >= fp_c1_1._m0[1].x;
    float _257 = float(_255);
    precise float _605 = _179 * fp_c6_1._m0[0].y;
    float _259 = _605;
    float _261 = fma(_247, _169, _163);
    float _263 = fma(_249, _169, _165);
    float _265 = fma(_251, _169, _167);
    precise float _621 = _257 * fp_c5_1._m0[5].x;
    float _267 = _621;
    float _269 = fma(_173, _259, _261);
    float _271 = fma(_175, _259, _263);
    float _273 = fma(_177, _259, _265);
    float _275 = -_267;
    float _277 = fma(_269, _275, _269);
    float _279 = -_267;
    float _281 = fma(_271, _279, _271);
    float _283 = -_267;
    float _285 = fma(_273, _283, _273);
    _47.x = _277;
    _47.y = _281;
    _47.z = _285;
    _47.w = _87;

    ApplyTonemap(_47, _79, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

