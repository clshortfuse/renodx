#version 450
#include "./shared.h"
#include "./macleod_boynton.hlsli"

layout(set = 0, binding = 20, std140) uniform fp_c1 {
  vec4 _m0[4096];
}
luminance;

layout(set = 0, binding = 22, std140) uniform fp_c3 {
  vec4 _m0[4096];
}
fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;

layout(location = 0) in vec4 _36;
layout(location = 1) in vec4 scale;
layout(location = 0) out vec4 out;

static const float kHueTransferChromaStart = 0.02;
static const float kHueTransferChromaEnd = 0.12;

void main() {
  vec2 uv = _36.xy;
  vec4 scene = texture(fp_t_tcb_8, uv);
  vec3 bloom = texture(fp_t_tcb_A, uv).xyz * CUSTOM_BLOOM;

  float lutScale = 1;
  if (RENODX_TONE_MAP_TYPE != 0) lutScale = renodx::tonemap::neutwo::ComputeMaxChannelScale(scene.xyz);

  scene *= lutScale;
  bloom *= lutScale;

  // lut
  vec3 sceneScaled = scene.xyz * scale.xyz;
  precise float lumaSeed = sceneScaled.x * 0.29890000820159912109375;
  float luma = fma(sceneScaled.y, luminance._m0[0].x, lumaSeed);
  luma = fma(sceneScaled.z, luminance._m0[0].y, luma);
  float blend = clamp(luma, 0.0, 1.0);
  float invBlend = 1.0 - blend;
  vec3 mixed = sceneScaled + bloom * invBlend;
  vec3 lutCoord = fma(mixed, fp_c3_1._m0[3].x, fp_c3_1._m0[3].y);
  vec3 lutColor = texture(fp_t_tcb_C, lutCoord).xyz;
  lutColor /= lutScale;
  if (RENODX_TONE_MAP_TYPE != 0) lutColor = lerp((sceneScaled + bloom) / lutScale, lutColor, LUT_STRENGTH);
  if (RENODX_TONE_MAP_TYPE == 0) lutColor = saturate(lutColor);
  else lutColor = CorrectHueAndPurityMBBT709WithBT2020(lutColor, saturate(lutColor), RENODX_COLOR_GRADE_STRENGTH * ComputeHueTransferStrength(saturate(lutColor)), RENODX_TONE_MAP_BLOWOUT);

  // colour grade (stupid)
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.tone_map_exposure = RENODX_TONE_MAP_EXPOSURE;
  config.tone_map_highlights = RENODX_TONE_MAP_HIGHLIGHTS;
  config.tone_map_shadows = RENODX_TONE_MAP_SHADOWS;
  config.tone_map_contrast = RENODX_TONE_MAP_CONTRAST;
  config.tone_map_saturation = RENODX_TONE_MAP_SATURATION;
  config.tone_map_blowout = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.tone_map_type = 1;
  //config.highlights = RENODX_TONE_MAP_HIGHLIGHT_SATURATION;
  config.tone_map_flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);

  lutColor = renodx::draw::ToneMapPass(lutColor);



  // tonemap
  float peak = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  if (RENODX_GAMMA_CORRECTION == 1.0) {
    peak = renodx::color::correct::GammaSafe(peak, true);
  }
  if (RENODX_GAMMA_CORRECTION == 2.0) {
    peak = renodx::color::correct::GammaSafe(peak, true, 2.4);
  }

  lutColor = renodx::tonemap::neutwo::PerChannel(lutColor, peak);

  out = vec4(lutColor, scene.w);
  out = renodx::draw::RenderIntermediatePass(out);

}

float ComputeHueTransferStrength(float3 donor) {
  float donor_max = max(donor.r, max(donor.g, donor.b));
  float donor_min = min(donor.r, min(donor.g, donor.b));
  float donor_chroma = renodx::math::DivideSafe(donor_max - donor_min, donor_max, 0.f);
  return smoothstep(kHueTransferChromaStart, kHueTransferChromaEnd, donor_chroma);
}
