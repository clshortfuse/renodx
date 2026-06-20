#version 450
#include "./shared.h"

layout(set = 0, binding = 24, std140) uniform fp_c5
{
    vec4 _m0[4096];
} fp_c5_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_E;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_A;

layout(location = 0) noperspective in vec4 _35;
layout(location = 0) out vec4 out;

void main()
{
    float _45 = _35.y;
    float _47 = _35.x;
    float _49 = -_45;
    precise float _359 = _49 + 1.0;
    float _51 = _359;
    bool _55 = _51 < fp_c5_1._m0[0].y;
    float _57 = 0.0;
    float _59 = _51;
    float _61 = _45;
    if (_55)
    {
        float _63 = textureLod(fp_t_tcb_E, vec2(_47, _45), 0.0).x;
        _57 = _63;
    }
    float _65 = _57;
    vec3 blur = texture(fp_t_tcb_8, vec2(_47, _45)).xyz;
    float _71 = blur.x;
    float _73 = blur.y;
    float _75 = blur.z;
    float _77 = 0.0;
    float _79 = _65;
    if (!_55)
    {
        float _81 = -fp_c5_1._m0[0].x;
        precise float _401 = _47 + _81;
        float _83 = _401;
        _77 = _83;
    }
    float _85 = _77;
    float _87 = 0.0;
    float _89 = _85;
    if (!_55)
    {
        float _91 = -fp_c5_1._m0[0].y;
        precise float _414 = _51 + _91;
        float _93 = _414;
        _87 = _93;
    }
    float _95 = _87;
    float _97 = 0.0;
    float _99 = _95;
    if (_55)
    {
        _97 = fp_c5_1._m0[3].w;
    }
    float _101 = _97;
    float _103 = 0.0;
    float _105 = _101;
    if (!_55)
    {
        _103 = fp_c5_1._m0[1].x;
    }
    float _107 = _103;
    float _109 = 0.0;
    float _111 = _107;
    if (_55)
    {
        precise float _438 = 1.0 / _101;
        float _113 = _438;
        _109 = _113;
    }
    float _115 = _109;
    if (!_55)
    {
        precise float _449 = _85 * fp_c5_1._m0[0].z;
        float _117 = _449;
        _89 = _117;
    }
    float _119 = _89;
    float _121 = 0.0;
    float _123 = _119;
    if (!_55)
    {
        precise float _458 = 1.0 / _107;
        float _125 = _458;
        _121 = _125;
    }
    float _127 = _121;
    if (_55)
    {
        float _129 = -_101;
        precise float _469 = _129 + fp_c5_1._m0[0].y;
        float _131 = _469;
        _123 = _131;
    }
    float _133 = _123;
    float _135 = _133;
    if (!_55)
    {
        float _137 = fma(_95, fp_c5_1._m0[0].w, _133);
        _99 = _137;
    }
    float _139 = _99;
    float _141 = _139;
    if (_55)
    {
        float _143 = -_133;
        precise float _493 = _51 + _143;
        float _145 = _493;
        _135 = _145;
    }
    float _147 = _135;
    float _149 = _147;
    if (!_55)
    {
        float _151 = abs(_139);
        precise float _505 = _151 + (-0.0);
        float _153 = _505;
        _141 = _153;
    }
    float _155 = _141;
    float _157 = _155;
    if (_55)
    {
        float _159 = max(0.0, _147);
        _149 = _159;
    }
    float _161 = _149;
    if (!_55)
    {
        precise float _522 = _127 * _155;
        float _163 = _522;
        float _165 = clamp(_163, 0.0, 1.0);
        _59 = _165;
    }
    float _167 = _59;
    float _169 = _167;
    if (!_55)
    {
        _157 = 3.0;
    }
    float _171 = _157;
    float _173 = 0.0;
    float _175 = _171;
    if (_55)
    {
        precise float _540 = _161 * _115;
        float _177 = _540;
        _173 = _177;
    }
    float _179 = _173;
    vec3 scene = texture(fp_t_tcb_C, vec2(_47, _45)).xyz;
    float _183 = scene.x;
    float _185 = scene.y;
    float _187 = scene.z;
    float _189 = _179;
    if (!_55)
    {
        float _191 = fma(_167, -2.0, _171);
        _175 = _191;
    }
    float _193 = _175;
    if (!_55)
    {
        precise float _572 = _167 * _167;
        float _195 = _572;
        _169 = _195;
    }
    float _197 = _169;
    float _199 = 0.0;
    if (!_55)
    {
        float _201 = fma(_193, _197, fp_c1_1._m0[0].x);
        float _203 = clamp(_201, 0.0, 1.0);
        _199 = _203;
    }
    float _205 = _199;
    vec3 _207 = texture(fp_t_tcb_A, vec2(_47, _45)).xyz;
    float _209 = _207.x;
    float _211 = _207.y;
    float _213 = _207.z;
    float _215 = _205;
    if (_55)
    {
        _105 = fp_c5_1._m0[2].y;
    }
    float _217 = _105;
    float _219 = _217;
    if (!_55)
    {
        float _221 = log2(_205);
        _219 = _221;
    }
    float _223 = _219;
    float _225 = _223;
    if (!_55)
    {
        precise float _623 = _107 * 10.0;
        float _227 = _623;
        _111 = _227;
    }
    float _229 = _111;
    float _231 = _229;
    if (!_55)
    {
        _189 = fp_c5_1._m0[1].z;
    }
    float _233 = _189;
    float _235 = _233;
    if (!_55)
    {
        precise float _641 = _229 * _223;
        float _237 = _641;
        _231 = _237;
    }
    float _239 = _231;
    if (!_55)
    {
        _225 = _239;
    }
    float _241 = _225;
    float _243 = _241;
    if (!_55)
    {
        float _245 = exp2(_241);
        _61 = _245;
    }
    float _247 = _61;
    precise float _662 = 1.0 / fp_c5_1._m0[1].y;
    float _249 = _662;
    float _251 = _247;
    if (_55)
    {
        precise float _669 = _65 + fp_c5_1._m0[2].x;
        float _253 = _669;
        _79 = _253;
    }
    float _255 = _79;
    float _257 = _255;
    if (_55)
    {
        precise float _677 = 1.0 / _255;
        float _259 = _677;
        _257 = _259;
    }
    float _261 = _257;
    if (_55)
    {
        float _263 = -fp_c5_1._m0[3].x;
        float _265 = fma(_261, _241, _263);
        _243 = _265;
    }
    float _267 = _243;
    float _269 = _267;
    if (_55)
    {
        precise float _699 = _267 * fp_c5_1._m0[3].y;
        float _271 = _699;
        float _273 = clamp(_271, 0.0, 1.0);
        _269 = _273;
    }
    float _275 = _269;
    float _277 = _275;
    if (_55)
    {
        float _279 = log2(_275);
        _277 = _279;
    }
    float _281 = _277;
    if (_55)
    {
        precise float _718 = _281 * fp_c5_1._m0[3].z;
        float _283 = _718;
        _215 = _283;
    }
    float _285 = _215;
    float _287 = _285;
    if (_55)
    {
        float _289 = exp2(_285);
        _251 = _289;
    }
    float _291 = _251;
    if (_55)
    {
        _287 = fp_c5_1._m0[1].w;
    }
    float _293 = _287;
    float _295 = abs(_291);
    float _297 = log2(_295);
    if (_55)
    {
        float _299 = -_293;
        float _301 = fma(_233, _299, fp_c5_1._m0[1].w);
        _235 = _301;
    }
    float _303 = _235;
    precise float _754 = _249 * _297;
    float _305 = _754;
    precise float _758 = _297 * fp_c5_1._m0[1].y;
    float _307 = _758;
    float _309 = exp2(_305);
    float _311 = exp2(_307);
    float _313 = -_303;
    float _315 = fma(_309, _313, _309);
    float _317 = -_311;
    precise float _773 = _309 + _317;
    float _319 = _773;
    float _321 = -_309;
    precise float _778 = _321 + _315;
    float _323 = _778;
    precise float _781 = _311 * _303;
    float _325 = _781;
    precise float _784 = _319 * _303;
    float _327 = _784;
    precise float _786 = _323 + 1.0;
    float _329 = _786;
    precise float _789 = _71 * _327;
    float _331 = _789;
    precise float _792 = _73 * _327;
    float _333 = _792;
    precise float _795 = _75 * _327;
    float _335 = _795;
    float _337 = fma(_329, _183, _331);
    float _339 = fma(_329, _185, _333);
    float _341 = fma(_329, _187, _335);
    float _343 = fma(_209, _325, _337);
    float _345 = fma(_211, _325, _339);
    float _347 = fma(_213, _325, _341);
    out.x = _343;
    out.y = _345;
    out.z = _347;
    out.w = _329;

    out.xyz = lerp(scene, out.xyz, CUSTOM_DOF);
}

