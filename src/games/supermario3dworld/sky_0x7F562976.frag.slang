#version 450
#include "./shared.h"

layout(set = 0, binding = 24, std140) uniform fp_c5
{
    vec4 _m0[4096];
} fp_c5_1;

layout(set = 0, binding = 23, std140) uniform fp_c4
{
    vec4 _m0[4096];
} fp_c4_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;

layout(location = 1) noperspective in vec4 _33;
layout(location = 2) in vec4 _35;
layout(location = 0) in vec4 _37;
layout(location = 4) in vec4 _39;
layout(location = 0) out vec4 _42;
layout(location = 2) out vec4 _44;
layout(location = 3) out vec4 out;

void main()
{
 
    vec4 c10 = fp_c5_1._m0[10];
    vec4 c11 = fp_c5_1._m0[11];
    vec4 c16 = fp_c5_1._m0[16];
    vec4 c17 = fp_c5_1._m0[17];
    vec4 c18 = fp_c5_1._m0[18];
    vec4 c19 = fp_c5_1._m0[19];
    vec4 c20 = fp_c5_1._m0[20];
    vec4 c21 = fp_c5_1._m0[21];

    float invZ = 1.0 / _33.z;
    vec2 proj = _33.xy * invZ;
    vec2 uvA = vec2(
        fma(proj.x, c10.x, proj.y * c10.z) + c11.x,
        fma(proj.x, c10.y, proj.y * c10.w) + c11.y
    );

    vec4 texC = texture(fp_t_tcb_C, _35.xy);
    vec4 texA = texture(fp_t_tcb_A, uvA);
    vec4 tex8 = texture(fp_t_tcb_8, _37.xy);

    float atten = saturate(abs(_33.z) / max(fp_c5_1._m0[22].x, 1.0));

    float cAlpha = texC.w * 0.99975502490997314453125;
    float aAlpha = texA.w * atten;
    float t8Alpha = tex8.w;

    float cAlphaPow4 = renodx::math::SafePow(cAlpha, 4.0);
    float aAlphaPow4 = renodx::math::SafePow(aAlpha, 4.0);
    float t8AlphaPow4 = renodx::math::SafePow(t8Alpha, 4.0);

    vec3 mappedC = fma(texC.xyz, c20.xyz - c21.xyz, c21.xyz);

    mappedC = saturate(mappedC);

    vec3 cScaled = mappedC * cAlphaPow4;
    vec3 cBoosted = fma(cScaled, vec3(1024.0), mappedC);

    float blendA = aAlpha * aAlphaPow4;
    float blend8 = t8Alpha * t8AlphaPow4;
    float gate = fma(1.0 - blendA, -blend8, 1.0 - blendA);

    vec3 gated = cBoosted * gate;
    vec3 mappedA = fma(texA.xyz, c18.xyz - c19.xyz, c19.xyz);
    vec3 mixedA = fma(vec3(blendA), mappedA - gated, gated);

    vec3 weighted = mixedA * _39.xyz;
    vec3 mapped8 = fma(tex8.xyz, c16.xyz - c17.xyz, c17.xyz);
    vec3 finalColor = fma(vec3(blend8), mapped8 - weighted, weighted);

    _42 = vec4(0.0);
    _44 = vec4(fp_c4_1._m0[21].x, 0.0, 0.0, 0.0);
    out = vec4(finalColor, 0.0);;
}

