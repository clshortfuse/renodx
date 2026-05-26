#version 450
#include "./shared.h"

layout(set = 0, binding = 28, std140) uniform fp_c9
{
    vec4 _m0[4096];
} fp_c9_1;

layout(set = 0, binding = 33, std140) uniform fp_c14
{
    vec4 _m0[4096];
} fp_c14_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_22;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_10;

layout(location = 1) in vec4 _31;
layout(location = 0) in vec4 _33;
layout(location = 4) in vec4 _35;
layout(location = 3) in vec4 _37;
layout(location = 2) in vec4 _41;
layout(location = 0) out vec4 out;

void main()
{
    vec2 uvMain = _31.xy;
    vec2 uvMask = _31.zw;
    vec2 maskSample = texture(fp_t_tcb_22, uvMask).yw;

    float alphaScale = _35.x;
    float alphaInput = _33.w;
    float alphaMasked = clamp(alphaInput * maskSample.y, 0.0, 1.0) * alphaScale;
    if (alphaMasked <= fp_c9_1._m0[94].z) {
        discard;
    }

    float invProjW = 1.0 / (_37.w * gl_FragCoord.w);
    vec2 reprojUv = vec2(_37.x * gl_FragCoord.w, _37.y * gl_FragCoord.w) * invProjW;
    float sceneDepth = texture(fp_t_tcb_10, reprojUv).x;
    float pixelDepth = _37.z * (1.0 / _37.w);
    if (pixelDepth >= sceneDepth) {
        discard;
    }

    float alphaOut = fma(alphaMasked, fp_c14_1._m0[49].x, fp_c14_1._m0[49].y);
    float sampleZ = texture(fp_t_tcb_22, _41.xy).z;
    float sampleX = texture(fp_t_tcb_22, uvMain).x;

    out.x = sampleX * _33.x;
    out.y = _33.y * maskSample.x;
    out.z = sampleZ * _33.z;
    out.w = alphaOut;
    if (RENODX_TONE_MAP_TYPE == 0) out.xyz = saturate(out.xyz);
    //out.xyz = renodx::draw::InvertIntermediatePass(out.xyz);
    float peakRatio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    [branch]
    if (RENODX_GAMMA_CORRECTION != 0.f) {
      peakRatio = renodx::color::correct::Gamma(
          peakRatio,
          true,
          renodx::math::Select(RENODX_GAMMA_CORRECTION == 1.f, 2.2f, 2.4f));
    }

    out.xyz = renodx::tonemap::neutwo::PerChannel(out.xyz, peakRatio);
}

