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
    precise float _251 = fp_c3_1._m0[21].z * 1920.0;
    float _52 = _251;
    precise float _256 = fp_c3_1._m0[21].w * 1080.0;
    float _54 = _256;
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
    precise float _325 = _93 * 0.4545449912548065185546875;
    float _103 = _325;
    precise float _327 = _97 * 0.4545449912548065185546875;
    float _105 = _327;
    precise float _329 = _101 * 0.4545449912548065185546875;
    float _107 = _329;
    float _109 = exp2(_103);
    precise float _335 = _87 + fp_c6_1._m0[0].z;
    float _111 = _335;
    float _113 = exp2(_105);
    precise float _341 = _89 + fp_c6_1._m0[0].w;
    float _115 = _341;
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
    precise float _385 = _145 + _129;
    float _147 = _385;
    float _149 = -_117;
    precise float _390 = _149 + _131;
    float _151 = _390;
    float _153 = fma(_147, fp_c5_1._m0[5].y, _109);
    float _155 = -_113;
    precise float _401 = _155 + _133;
    float _157 = _401;
    float _159 = fma(_151, fp_c5_1._m0[5].y, _117);
    precise float _409 = _153 * 1.3703000545501708984375;
    float _161 = _409;
    float _163 = abs(_161);
    float _165 = log2(_163);
    float _167 = fma(_157, fp_c5_1._m0[5].y, _113);
    precise float _420 = _159 * 1.3703000545501708984375;
    float _169 = _420;
    float _171 = abs(_169);
    float _173 = log2(_171);
    precise float _426 = _167 * 1.3703000545501708984375;
    float _175 = _426;
    float _177 = abs(_175);
    float _179 = log2(_177);
    precise float _433 = _165 * 2.2000000476837158203125;
    float _181 = _433;
    precise float _435 = _173 * 2.2000000476837158203125;
    float _183 = _435;
    float _185 = exp2(_181);
    precise float _439 = _179 * 2.2000000476837158203125;
    float _187 = _439;
    float _189 = exp2(_183);
    float _191 = exp2(_187);
    precise float _447 = _185 * fp_c5_1._m0[0].x;
    float _193 = _447;
    precise float _451 = _185 * fp_c5_1._m0[1].x;
    float _195 = _451;
    precise float _455 = _185 * fp_c5_1._m0[2].x;
    float _197 = _455;
    float _199 = fma(_189, fp_c5_1._m0[0].y, _193);
    float _201 = fma(_189, fp_c5_1._m0[1].y, _195);
    float _203 = fma(_189, fp_c5_1._m0[2].y, _197);
    float _205 = fma(_191, fp_c5_1._m0[0].z, _199);
    float _207 = fma(_191, fp_c5_1._m0[1].z, _201);
    float _209 = fma(_191, fp_c5_1._m0[2].z, _203);
    bool _213 = _85 >= fp_c1_1._m0[0].z;
    float _215 = float(_213);
    precise float _497 = _143 * fp_c6_1._m0[0].y;
    float _217 = _497;
    precise float _501 = _205 + fp_c5_1._m0[0].w;
    float _219 = _501;
    precise float _505 = _207 + fp_c5_1._m0[1].w;
    float _221 = _505;
    precise float _509 = _209 + fp_c5_1._m0[2].w;
    float _223 = _509;
    precise float _513 = _215 * fp_c5_1._m0[5].x;
    float _225 = _513;
    float _227 = fma(_137, _217, _219);
    float _229 = fma(_139, _217, _221);
    float _231 = fma(_141, _217, _223);
    float _233 = -_225;
    float _235 = fma(_227, _233, _227);
    float _237 = -_225;
    float _239 = fma(_229, _237, _229);
    float _241 = -_225;
    float _243 = fma(_231, _241, _231);
    _45.x = _235;
    _45.y = _239;
    _45.z = _243;
    _45.w = _85;

    ApplyTonemap(_45, _77, fp_t_tcb_12, fp_c5_1._m0[5].y);
}

