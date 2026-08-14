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
    precise float _263 = fp_c3_1._m0[21].z * 1920.0;
    float _52 = _263;
    precise float _268 = fp_c3_1._m0[21].w * 1080.0;
    float _54 = _268;
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
    precise float _337 = _93 * 0.4545449912548065185546875;
    float _103 = _337;
    precise float _339 = _97 * 0.4545449912548065185546875;
    float _105 = _339;
    precise float _341 = _101 * 0.4545449912548065185546875;
    float _107 = _341;
    float _109 = exp2(_103);
    precise float _347 = _87 + fp_c6_1._m0[0].z;
    float _111 = _347;
    float _113 = exp2(_105);
    precise float _353 = _89 + fp_c6_1._m0[0].w;
    float _115 = _353;
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
    precise float _397 = _145 + _129;
    float _147 = _397;
    float _149 = -_117;
    precise float _402 = _149 + _131;
    float _151 = _402;
    float _153 = fma(_147, fp_c5_1._m0[5].y, _109);
    float _155 = -_113;
    precise float _413 = _155 + _133;
    float _157 = _413;
    float _159 = fma(_151, fp_c5_1._m0[5].y, _117);
    precise float _421 = _153 * 1.3703000545501708984375;
    float _161 = _421;
    float _163 = abs(_161);
    float _165 = log2(_163);
    float _167 = fma(_157, fp_c5_1._m0[5].y, _113);
    precise float _432 = _159 * 1.3703000545501708984375;
    float _169 = _432;
    float _171 = abs(_169);
    float _173 = log2(_171);
    precise float _438 = _167 * 1.3703000545501708984375;
    float _175 = _438;
    float _177 = abs(_175);
    float _179 = log2(_177);
    precise float _445 = _165 * 2.2000000476837158203125;
    float _181 = _445;
    precise float _447 = _173 * 2.2000000476837158203125;
    float _183 = _447;
    float _185 = exp2(_181);
    precise float _451 = _179 * 2.2000000476837158203125;
    float _187 = _451;
    float _189 = exp2(_183);
    float _191 = exp2(_187);
    precise float _459 = _185 * fp_c5_1._m0[2].x;
    float _193 = _459;
    precise float _463 = _185 * fp_c5_1._m0[0].x;
    float _195 = _463;
    precise float _467 = _185 * fp_c5_1._m0[1].x;
    float _197 = _467;
    float _199 = fma(_189, fp_c5_1._m0[2].y, _193);
    float _201 = fma(_189, fp_c5_1._m0[0].y, _195);
    float _203 = fma(_189, fp_c5_1._m0[1].y, _197);
    precise float _486 = _143 * fp_c6_1._m0[0].y;
    float _205 = _486;
    float _207 = fma(_191, fp_c5_1._m0[2].z, _199);
    float _209 = fma(_191, fp_c5_1._m0[0].z, _201);
    float _211 = fma(_191, fp_c5_1._m0[1].z, _203);
    float _213 = -_205;
    float _215 = fma(_137, _205, _213);
    float _217 = -_205;
    float _219 = fma(_139, _205, _217);
    bool _223 = _85 >= fp_c1_1._m0[0].z;
    float _225 = float(_223);
    precise float _525 = _207 + fp_c5_1._m0[2].w;
    float _227 = _525;
    precise float _529 = _209 + fp_c5_1._m0[0].w;
    float _229 = _529;
    precise float _533 = _211 + fp_c5_1._m0[1].w;
    float _231 = _533;
    float _233 = -_205;
    float _235 = fma(_141, _205, _233);
    precise float _543 = _225 * fp_c5_1._m0[5].x;
    float _237 = _543;
    float _239 = fma(_229, _215, _229);
    float _241 = fma(_231, _219, _231);
    float _243 = fma(_227, _235, _227);
    float _245 = -_237;
    float _247 = fma(_239, _245, _239);
    float _249 = -_237;
    float _251 = fma(_241, _249, _241);
    float _253 = -_237;
    float _255 = fma(_243, _253, _243);
    _45.x = _247;
    _45.y = _251;
    _45.z = _255;
    _45.w = _85;

    ApplyTonemap(_45, _77, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

