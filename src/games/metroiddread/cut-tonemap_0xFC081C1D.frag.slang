#version 450
#include "./shared.h"
#include "./shared.slang"

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

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_14;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_12;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 _35;
layout(location = 0) out vec4 _38;

vec3 ApplyTonemap(vec3 hdr, bool useHdrPath = false)
{
    const float kBiasA = 0.589999973773956298828125;
    const float kBiasB = 0.02999999932944774627685546875;
    const float kLumaR = 0.2989999949932098388671875;
    const float kHdrBlendStart = 1.0;
    const float kHdrBlendEnd = 4.0;

    vec3 curve = fma(hdr, fp_c1_1._m0[0].x, kBiasA);
    vec3 toe = fma(hdr, fp_c1_1._m0[0].z, kBiasB);
    vec3 denom = fma(hdr, curve, fp_c1_1._m0[0].y);
    vec3 mappedSdr = saturate((hdr * toe) * (1.0 / denom));

    vec3 toneMapped = mappedSdr;
    if (useHdrPath) {
        vec3 mappedHdr = (hdr * toe) * (1.0 / denom);
        float hdrPeak = renodx::math::Max(hdr);
        float hdrBlend = smoothstep(kHdrBlendStart, kHdrBlendEnd, hdrPeak);
        toneMapped = mix(mappedHdr, hdr, hdrBlend);
    }

    float mixWeight = fma(toneMapped.z, fp_c1_1._m0[1].x, fma(toneMapped.y, fp_c1_1._m0[0].w, toneMapped.x * kLumaR));
    float logMix = log2(mixWeight);

    vec3 blend = fma(mixWeight, -fp_c3_1._m0[2].xyz, toneMapped);
    vec3 add = mixWeight * fp_c3_1._m0[2].xyz;
    float blendAmount = saturate(exp2(logMix * fp_c3_1._m0[2].w));
    return fma(blend, blendAmount, add);
}

void main()
{
    bool useHdrPath = (RENODX_TONE_MAP_TYPE != 0.f);

    vec2 uv = _35.xy;
    float lutBand = floor(uv.x * fp_c3_1._m0[11].x);

    float lutU = saturate(uv.x * fp_c3_1._m0[11].x * fp_c3_1._m0[10].z);
    float lutV = saturate(uv.y * fp_c3_1._m0[11].y * fp_c3_1._m0[10].w);

    vec3 lutA = texture(fp_t_tcb_14, vec2(lutU, lutV)).xyz;
    vec3 lutB = texture(fp_t_tcb_C, vec2(lutU, lutV)).xyz;
    vec3 blendTex = texture(fp_t_tcb_12, uv).xyz;
    vec3 base = texture(fp_t_tcb_8, uv).xyz;

    // Cutscene-only addition: fp_t_tcb_12 modulates LUT contribution before exposure.
    vec3 lutSum = lutA + lutB;
    vec3 hdrInput = fma(lutSum * blendTex, fp_c3_1._m0[3].y, lutSum) + base;

    float exposure = exp2(fp_c3_1._m0[0].x);
    vec3 hdr = exposure * hdrInput;
    vec3 output = ApplyTonemap(hdr, useHdrPath);

    if (useHdrPath) output = MetroidCorrect(output, ApplyTonemap(hdr));

    vec3 offsetFilm = output + fp_c3_1._m0[1].x;
    vec3 postCurveMapped = fma(offsetFilm - vec3(1.5), fp_c3_1._m0[0].w, vec3(0.5));
    vec3 postCurveInput = useHdrPath ? max(postCurveMapped, 0.0) : saturate(postCurveMapped);

    float gammaBase = fp_c3_1._m0[0].y * 0.454545438289642333984375;
    vec3 curved = exp2(gammaBase.xxx * log2(postCurveInput));

    float halfRadius = 0.5 * fp_c3_1._m0[7].z;
    float invHalfRadius = 1.0 / halfRadius;
    vec2 centeredUv = (uv - halfRadius.xx) * invHalfRadius;
    float radial = fma(fp_c3_1._m0[7].y - fp_c3_1._m0[7].x, length(centeredUv), fp_c3_1._m0[7].x);

    float invLift = 1.0 / saturate(1.0 - fp_c3_1._m0[6].y);
    vec3 lifted = (curved - fp_c3_1._m0[6].x) * invLift;

    vec3 radialBlend = lifted * (1.0 - radial);
    vec3 edgeBlend = lifted * (1.0 - fp_c3_1._m0[7].w);
    vec3 gradedSpatial = fma(radialBlend, fp_c3_1._m0[7].w, edgeBlend);

    float vignetteInv = 1.0 / (fp_c3_1._m0[4].y + 9.9999997473787516355514526367188e-05);
    vec3 vignette = gradedSpatial * vignetteInv;

    float phase = fma(uv.y * fp_c3_1._m0[10].y, 1.0 / fp_c3_1._m0[9].x, -(fp_c3_1._m0[8].x * fp_c3_1._m0[9].z * 6.280000209808349609375));
    float scanline = sin(phase) * fp_c3_1._m0[9].y;

    float vignetteMix = clamp(fma(vignette.z, fp_c1_1._m0[1].w, fma(vignette.y, fp_c1_1._m0[1].w, vignette.x * 0.3300000131130218505859375)), 0.0, 1.0);

    float grainSeedY = roundEven(uv.y * 8000.0);
    float grainSeedX = roundEven(uv.x * 8000.0);
    float fracCell = fp_c3_1._m0[8].x - floor(fp_c3_1._m0[8].x);
    float grainHash = fma(fma(grainSeedY, fp_c1_1._m0[1].y, fracCell), fp_c1_1._m0[1].z, fma(grainSeedX, fp_c1_1._m0[1].y, fracCell));
    float noise = sin(grainHash) * 493013.0;
    float noiseFrac = noise - floor(noise);

    float stripeMask = clamp(fma(fma(floor(lutBand * 0.5), -2.0, lutBand), 1.0, fp_c3_1._m0[9].w), 0.0, 1.0);
    float jitterScale = fma(vignetteMix, -fp_c3_1._m0[4].x, fp_c3_1._m0[4].x);

    vec3 jitteredRaw = gradedSpatial - (jitterScale * noiseFrac).xxx;
    vec3 jittered = useHdrPath ? max(jitteredRaw, 0.0) : clamp(jitteredRaw, 0.0, 1.0);
    output = fma(jittered, stripeMask.xxx, scanline.xxx);
    output = renodx::color::gamma::DecodeSafe(output, 2.2);
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.f) {
        peak = renodx::color::correct::GammaSafe(peak, true);
    }
    if (RENODX_GAMMA_CORRECTION == 2.f) {
        peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
    }

    output = renodx::tonemap::neutwo::PerChannel(output, peak);
    
    _38.xyz = renodx::draw::RenderIntermediatePass(output);
    _38.w = 0.0;
}

