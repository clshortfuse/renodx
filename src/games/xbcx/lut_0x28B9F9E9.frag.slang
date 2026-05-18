#version 450
#include "./shared.h"

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D rawIn;
layout(set = 2, binding = 129) uniform sampler3D fp_t_tcb_A;

layout(location = 0) in vec4 in;
layout(location = 0) out vec4 out;

void main()
{
    const float kGamma = 1/2.2;

    vec3 raw = texture(rawIn, in.xy).xyz;

    float lutScale = renodx::tonemap::neutwo::ComputeMaxChannelScale(raw);

    if (RENODX_TONE_MAP_TYPE == 0) lutScale = 1;

    raw *= lutScale;

    precise vec3 scaled = raw * fp_c3_1._m0[1].x;
    vec3 clamped = clamp(scaled, 0.0, 1.0);

    precise vec3 gamma_curve = exp2(log2(abs(clamped)) * kGamma);
    vec3 lut_uv = fma(gamma_curve, vec3(fp_c3_1._m0[1].z), vec3(fp_c3_1._m0[1].w));

    vec3 lutOut = texture(fp_t_tcb_A, lut_uv).xyz;

    lutOut /= lutScale;

    //lutOut = renodx::color::gamma::DecodeSafe(lutOut);

    lutOut = lerp(gamma_curve / lutScale, lutOut, LUT_STRENGTH);


    lutOut = renodx::color::srgb::DecodeSafe(lutOut);

    // colour grade (stupid)
    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.tone_map_exposure = RENODX_TONE_MAP_EXPOSURE;
    config.tone_map_highlights = RENODX_TONE_MAP_HIGHLIGHTS;
    config.tone_map_shadows = RENODX_TONE_MAP_SHADOWS;
    config.tone_map_contrast = RENODX_TONE_MAP_CONTRAST;
    config.tone_map_saturation = RENODX_TONE_MAP_SATURATION;
    config.tone_map_blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
    config.tone_map_type = 1;
    // config.highlights = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
    config.tone_map_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);

    lutOut = renodx::draw::ToneMapPass(lutOut, config);

        // Max-channel tonemap to display peak.
    float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    if (RENODX_GAMMA_CORRECTION == 1.0) {
      peak = renodx::color::correct::GammaSafe(peak, true);
    }
    if (RENODX_GAMMA_CORRECTION == 2.0) {
      peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
    }

    lutOut = renodx::tonemap::neutwo::PerChannel(lutOut, peak);

    
    lutOut = renodx::draw::RenderIntermediatePass(lutOut);

    //lutOut = pow(lutOut, 1/2.2);

    out = vec4(lutOut, 1.0);
}

