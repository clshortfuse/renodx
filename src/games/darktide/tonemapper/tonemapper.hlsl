#include "../shared.h"

#ifndef TONEMAPPER_EXTRA_TEXTURE_COUNT
#define TONEMAPPER_EXTRA_TEXTURE_COUNT 0
#endif

#ifndef TONEMAPPER_USE_BLOOM
#define TONEMAPPER_USE_BLOOM 0
#endif

#ifndef TONEMAPPER_USE_GLARE
#define TONEMAPPER_USE_GLARE 0
#endif

#ifndef TONEMAPPER_USE_COLOR_FILTER
#define TONEMAPPER_USE_COLOR_FILTER 0
#endif

#if defined(TONEMAPPER_LAYOUT_BASE)
// t0 scene, t1 LUT, t2 exposure, t3 bloom, t4 depth
Texture2D<float4> SceneTexture : register(t0);
Texture3D<float4> LutTexture : register(t1);
Texture2D<float> ExposureTexture : register(t2);
Texture2D<float4> BloomTexture : register(t3);
Texture2D<float4> DepthTexture : register(t4);
SamplerState SceneSampler : register(s0);
SamplerState LutSampler : register(s1);
SamplerState BloomSampler : register(s2);
SamplerState DepthSampler : register(s3);
#define TONEMAPPER_AMD_LPM_PACKOFFSET c014.x
#define TONEMAPPER_INPUT_SIZE_PACKOFFSET c013.x
#elif defined(TONEMAPPER_LAYOUT_BASE_REORDERED)
// t0 scene, t1 bloom, t2 LUT, t3 exposure, t4 depth
Texture2D<float4> SceneTexture : register(t0);
Texture2D<float4> BloomTexture : register(t1);
Texture3D<float4> LutTexture : register(t2);
Texture2D<float> ExposureTexture : register(t3);
Texture2D<float4> DepthTexture : register(t4);
SamplerState SceneSampler : register(s0);
SamplerState BloomSampler : register(s1);
SamplerState LutSampler : register(s2);
SamplerState DepthSampler : register(s3);
#define TONEMAPPER_AMD_LPM_PACKOFFSET c012.x
#define TONEMAPPER_INPUT_SIZE_PACKOFFSET c011.x
#elif defined(TONEMAPPER_LAYOUT_EXTRA1)
// t0 scene, t1 extra, t2 LUT, t3 exposure, t4 bloom, t5 depth
Texture2D<float4> SceneTexture : register(t0);
Texture2D<float4> ExtraTexture0 : register(t1);
Texture3D<float4> LutTexture : register(t2);
Texture2D<float> ExposureTexture : register(t3);
Texture2D<float4> BloomTexture : register(t4);
Texture2D<float4> DepthTexture : register(t5);
SamplerState SceneSampler : register(s0);
SamplerState ExtraSampler0 : register(s1);
SamplerState LutSampler : register(s2);
SamplerState BloomSampler : register(s3);
SamplerState DepthSampler : register(s4);
#define TONEMAPPER_AMD_LPM_PACKOFFSET c014.x
#define TONEMAPPER_INPUT_SIZE_PACKOFFSET c013.x
#elif defined(TONEMAPPER_LAYOUT_EXTRA1_REORDERED)
// t0 scene, t1 bloom, t2 extra, t3 LUT, t4 exposure, t5 depth
Texture2D<float4> SceneTexture : register(t0);
Texture2D<float4> BloomTexture : register(t1);
Texture2D<float4> ExtraTexture0 : register(t2);
Texture3D<float4> LutTexture : register(t3);
Texture2D<float> ExposureTexture : register(t4);
Texture2D<float4> DepthTexture : register(t5);
SamplerState SceneSampler : register(s0);
SamplerState BloomSampler : register(s1);
SamplerState ExtraSampler0 : register(s2);
SamplerState LutSampler : register(s3);
SamplerState DepthSampler : register(s4);
#define TONEMAPPER_AMD_LPM_PACKOFFSET c012.x
#define TONEMAPPER_INPUT_SIZE_PACKOFFSET c011.x
#elif defined(TONEMAPPER_LAYOUT_EXTRA2)
// t0 scene, t1 bloom, t2 extra0, t3 extra1, t4 LUT, t5 exposure, t6 depth
Texture2D<float4> SceneTexture : register(t0);
Texture2D<float4> BloomTexture : register(t1);
Texture2D<float4> ExtraTexture0 : register(t2);
Texture2D<float4> ExtraTexture1 : register(t3);
Texture3D<float4> LutTexture : register(t4);
Texture2D<float> ExposureTexture : register(t5);
Texture2D<float4> DepthTexture : register(t6);
SamplerState SceneSampler : register(s0);
SamplerState BloomSampler : register(s1);
SamplerState ExtraSampler0 : register(s2);
SamplerState ExtraSampler1 : register(s3);
SamplerState LutSampler : register(s4);
SamplerState DepthSampler : register(s5);
#define TONEMAPPER_AMD_LPM_PACKOFFSET c012.x
#define TONEMAPPER_INPUT_SIZE_PACKOFFSET c011.x
#elif defined(TONEMAPPER_LAYOUT_MINIMAL_COLOR_FILTER)
// t0 scene, t1 LUT, t2 exposure; c0 includes color filter fields
Texture2D<float4> SceneTexture : register(t0);
Texture3D<float4> LutTexture : register(t1);
Texture2D<float> ExposureTexture : register(t2);
SamplerState SceneSampler : register(s0);
SamplerState LutSampler : register(s1);
#define TONEMAPPER_AMD_LPM_PACKOFFSET c013.x
#elif defined(TONEMAPPER_LAYOUT_MINIMAL)
// t0 scene, t1 LUT, t2 exposure
Texture2D<float4> SceneTexture : register(t0);
Texture3D<float4> LutTexture : register(t1);
Texture2D<float> ExposureTexture : register(t2);
SamplerState SceneSampler : register(s0);
SamplerState LutSampler : register(s1);
#define TONEMAPPER_AMD_LPM_PACKOFFSET c011.x
#else
#error Define a TONEMAPPER_LAYOUT_* permutation before including tonemapper.hlsl.
#endif

cbuffer global_viewport : register(b0) {
  float3 camera_pos : packoffset(c001.x);
  float4 camera_world[4] : packoffset(c010.x);
  float4 camera_view_projection[4][2] : packoffset(c074.x);
};

cbuffer global_environment_settings : register(b1) {
  float tonemap_use_custom : packoffset(c021.w);
  float tonemap_slope : packoffset(c022.x);
  float tonemap_toe : packoffset(c022.y);
  float tonemap_shoulder : packoffset(c022.z);
  float tonemap_black_clip : packoffset(c022.w);
  float tonemap_white_clip : packoffset(c023.x);
};

cbuffer c0 : register(b2) {
  float3 bloom_threshold_offset_falloff : packoffset(c004.x);
  float3 vignette_scale_falloff_opacity : packoffset(c005.x);
  float3 vignette_color : packoffset(c006.x);
  float bloom_enabled : packoffset(c006.w);
  float bloom_glare_enabled : packoffset(c007.x);
  float2 bloom_glare_settings : packoffset(c007.y);
  float light_shafts_enabled : packoffset(c007.w);
  float sun_flare_enabled : packoffset(c008.x);
  float tone_mapping_enabled : packoffset(c008.y);
  float amd_lpm_tone_mapping_enabled : packoffset(c008.z);
  float vignette_enabled : packoffset(c008.w);
  float color_grading_enabled : packoffset(c009.x);
  float grey_scale_enabled : packoffset(c009.y);
  float grey_scale_amount : packoffset(c009.z);
  float3 grey_scale_weights : packoffset(c010.x);
  float mirror_uv : packoffset(c010.w);
#if TONEMAPPER_USE_COLOR_FILTER
  float color_filter_enabled : packoffset(c011.x);
  float4 color_filter_opacity : packoffset(c012.x);
#endif
#if TONEMAPPER_USE_BLOOM
  float2 input_texture1_size : packoffset(TONEMAPPER_INPUT_SIZE_PACKOFFSET);
#endif
  uint4 amd_lpm[4] : packoffset(TONEMAPPER_AMD_LPM_PACKOFFSET);
};

static const float EPS = 6.0999998822808266e-05f;
static const float3 BT709_Y =
    float3(0.2126999944448471f, 0.7152000069618225f, 0.07209999859333038f);

float Luma709(float3 color) { return dot(color, BT709_Y); }

float4 CubicFilter(float t) {
  float t2 = t * t;
  float t3 = t2 * t;
  return float4(((-0.5f * t + 1.0f) * t - 0.5f) * t,
                (1.5f * t - 2.5f) * t2 + 1.0f,
                ((-1.5f * t + 2.0f) * t + 0.5f) * t, (0.5f * t - 0.5f) * t2);
}

float3 SampleBloomBicubic(float2 uv) {
#if TONEMAPPER_USE_BLOOM
  float2 pixel = uv * input_texture1_size - 0.5f;
  float2 base = floor(pixel);
  float2 f = pixel - base;
  float4 wx = CubicFilter(f.x);
  float4 wy = CubicFilter(f.y);
  float3 color = 0.0f.xxx;
  [unroll] for (int y = 0; y < 4; ++y) {
    [unroll] for (int x = 0; x < 4; ++x) {
      color += BloomTexture
                   .Sample(BloomSampler, (base + float2(x - 1, y - 1) + 0.5f) /
                                             input_texture1_size)
                   .rgb *
               wx[x] * wy[y];
    }
  }
  return color;
#else
  return 0.0f.xxx;
#endif
}

float3 BloomAdd(float3 bloom_color) {
  return bloom_color /
         max(bloom_threshold_offset_falloff.y - Luma709(bloom_color), EPS);
}

float2 ProjectWorldToScreen(float3 world_position,
                            bool use_primary_projection) {
  float4 row_x = use_primary_projection ? camera_view_projection[0][0]
                                        : camera_view_projection[2][0];
  float4 row_y = use_primary_projection ? camera_view_projection[0][1]
                                        : camera_view_projection[2][1];
  float4 row_w = use_primary_projection ? camera_view_projection[1][1]
                                        : camera_view_projection[3][1];
  float4 world = float4(world_position, 1.0f);
  float2 ndc = float2(dot(world, row_x), dot(world, row_y)) / dot(world, row_w);
  return float2((ndc.x * 0.5f) + 0.5f, 0.5f - (ndc.y * 0.5f));
}

float3 AddBloomGlare(float3 color, float2 uv, float4 projected_position) {
#if TONEMAPPER_USE_GLARE
  if (bloom_glare_enabled == 0.0f)
    return color;
  int encoded_depth = asint(DepthTexture.Sample(DepthSampler, uv).x);
  float depth = asfloat(encoded_depth & 2147483647);
  bool use_primary_projection = (((uint)encoded_depth >> 31) == 0u);
  float3 camera_y =
      float3(camera_world[0].y, camera_world[1].y, camera_world[2].y);
  float3 world_position =
      camera_pos + ((projected_position.xyz / projected_position.w) * depth) -
      (camera_y * depth * bloom_glare_settings.y);
  float2 glare_uv =
      ProjectWorldToScreen(world_position, use_primary_projection);
  float2 edge_fade =
      saturate((abs(glare_uv - 0.5f.xx) - 0.5f.xx) * -3.3333332538604736f);
  edge_fade = edge_fade * edge_fade * (3.0f.xx - (2.0f.xx * edge_fade));
  color += BloomAdd(SampleBloomBicubic(glare_uv)) * bloom_glare_settings.x *
           edge_fade.x * edge_fade.y;
#endif
  return color;
}

float3 TonemapSimpleFilmic(float3 color) {
  return saturate(
      ((color * 2.509999990463257f + 0.029999999329447746f) * color) /
      (((color * 2.430000066757202f + 0.5899999737739563f) * color) +
       0.14000000059604645f));
}

float3 TonemapAmdLpm(float3 color) {
  float3 safe_color = max(color, 0.0f.xxx);
  float maximum_channel = max(max(safe_color.x, safe_color.y), safe_color.z);
  if (maximum_channel <= 0.0f)
    return 0.0f.xxx;
  float3 lpm_a = asfloat(uint3(amd_lpm[2].y, amd_lpm[2].z, amd_lpm[2].w));
  float3 lpm_b = asfloat(uint3(amd_lpm[1].z, amd_lpm[1].w, amd_lpm[2].x));
  float3 powered_color =
      exp2(log2(safe_color / maximum_channel) *
           asfloat(uint3(amd_lpm[0].x, amd_lpm[0].y, amd_lpm[0].z)));
  float powered_luma =
      exp2(log2(max(dot(safe_color, lpm_b), EPS)) * asfloat(amd_lpm[0].w));
  float compressed_luma =
      powered_luma /
      ((powered_luma * asfloat(amd_lpm[1].x)) + asfloat(amd_lpm[1].y));
  float3 compressed_color = saturate(
      (compressed_luma / max(dot(powered_color, lpm_b), EPS)) * powered_color);
  float3 remaining_color = lpm_a * (1.0f.xxx - compressed_color);
  float remaining_luma =
      saturate(compressed_luma - dot(compressed_color, lpm_b)) /
      max(dot(remaining_color, lpm_b), EPS);
  float3 shaped_color =
      saturate((remaining_luma * remaining_color) + compressed_color);
  float shaped_luma = saturate(compressed_luma - dot(shaped_color, lpm_b));
  return saturate(
      (shaped_luma * asfloat(uint3(amd_lpm[3].x, amd_lpm[3].y, amd_lpm[3].z))) +
      shaped_color);
}

float3 TonemapCustomFilmic(float3 color) {
  float3 aces = float3(
      mad(0.16386905312538147f, color.z,
          mad(0.14067868888378143f, color.y, color.x * 0.6954522132873535f)),
      mad(0.0955343246459961f, color.z,
          mad(0.8596711158752441f, color.y, color.x * 0.044794581830501556f)),
      mad(1.0015007257461548f, color.z,
          mad(0.004025210160762072f, color.y,
              color.x * -0.005525882821530104f)));
  float luma =
      dot(max(aces, 0.0f.xxx), float3(0.2722287178039551f, 0.6740817427635193f,
                                      0.053689517080783844f));
  float3 working = max(aces, EPS.xxx);
  float toe_scale = 1.0f - tonemap_toe;
  float toe_black = toe_scale + tonemap_black_clip;
  float shoulder_white = (1.0f - tonemap_shoulder) + tonemap_white_clip;
  float toe_match =
      (tonemap_toe > 0.800000011920929f)
          ? (((0.8199999928474426f - tonemap_toe) / tonemap_slope) -
             0.7447274923324585f)
          : (-0.7447274923324585f -
             ((log2(((tonemap_black_clip + 0.18000000715255737f) / toe_black) /
                    (2.0f - ((tonemap_black_clip + 0.18000000715255737f) /
                             toe_black))) *
               0.3465735912322998f) *
              (toe_black / tonemap_slope)));
  float linear_start = (toe_scale / tonemap_slope) - toe_match;
  float shoulder_start = (tonemap_shoulder / tonemap_slope) - linear_start;
  float3 log_color =
      log2(lerp(luma.xxx, working, 0.9599999785423279f)) * 0.3010300099849701f;
  float3 linear_section = (log_color + linear_start) * tonemap_slope;
  float3 toe_section = (toe_black * 2.0f /
                        (exp2(((log_color - toe_match) * 1.4426950216293335f) *
                              ((tonemap_slope * -2.0f) / toe_black)) +
                         1.0f)) -
                       tonemap_black_clip;
  float3 shoulder_section =
      (tonemap_white_clip + 1.0f) -
      ((shoulder_white * 2.0f) /
       (exp2(((log_color - shoulder_start) * 1.4426950216293335f) *
             ((tonemap_slope * 2.0f) / shoulder_white)) +
        1.0f));
  float3 curve = select(log_color < toe_match.xxx, toe_section, linear_section);
  float3 shoulder_blend =
      saturate((log_color - toe_match) / (shoulder_start - toe_match));
  shoulder_blend = (shoulder_start < toe_match) ? (1.0f.xxx - shoulder_blend)
                                                : shoulder_blend;
  shoulder_blend =
      shoulder_blend * shoulder_blend * (3.0f.xxx - shoulder_blend * 2.0f);
  curve = lerp(
      curve,
      select(log_color > shoulder_start.xxx, shoulder_section, linear_section),
      shoulder_blend);
  float curve_luma = dot(curve, float3(0.2722287178039551f, 0.6740817427635193f,
                                       0.053689517080783844f));
  return max(0.0f.xxx, lerp(curve_luma.xxx, curve, 0.9300000071525574f));
}

float3 ApplyVanillaTonemap(float3 hdr_color) {
  if (tone_mapping_enabled == 0.0f)
    return hdr_color;
  if (amd_lpm_tone_mapping_enabled != 0.0f)
    return TonemapAmdLpm(hdr_color);
  if (tonemap_use_custom != 0.0f)
    return TonemapCustomFilmic(hdr_color);
  return TonemapSimpleFilmic(hdr_color);
}

float3 ApplyLatePost(float3 linear_sdr, float2 uv) {
  float3 color = renodx::color::gamma::Encode(max(linear_sdr, 0.0f.xxx));
  float2 centered_uv = uv - 0.5f.xx;
  float vignette_exponent =
      (vignette_scale_falloff_opacity.y * 1.4427000284194946f) +
      1.4427000284194946f;
  float vignette_mask =
      1.0f - saturate(exp2((vignette_exponent *
                            (1.0f - dot(centered_uv, centered_uv))) -
                           vignette_exponent) *
                      vignette_scale_falloff_opacity.x);
  color = lerp(
      color, (1.0f.xxx - ((1.0f.xxx - vignette_color) * vignette_mask)) * color,
      vignette_enabled * vignette_scale_falloff_opacity.z);
#if TONEMAPPER_USE_COLOR_FILTER
  if (color_filter_enabled != 0.0f)
    color =
        lerp(color, color * color_filter_opacity.yzw, color_filter_opacity.x);
#endif
  if (grey_scale_enabled != 0.0f)
    color = lerp(color, max(dot(color, grey_scale_weights), 0.0f).xxx,
                 grey_scale_amount);
  if (color_grading_enabled != 0.0f)
    color = lerp(color, renodx::lut::SampleTetrahedral(LutTexture, color, 16u),
                 color_grading_enabled);
  return renodx::color::srgb::DecodeSafe(color);
}

float3 PsychoVTest17(float3 untonemapped_bt709, float mid_gray_scale,
                     float current_average = 0.18f,
                     float target_average = 0.18f, bool is_sdr = false,
                     float psychov_cone_response_baseline = 1.f) {
  float calculated_peak =
      is_sdr ? 1.f : (RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);

  float3 bt709_scene = untonemapped_bt709;

  bool has_valid_anchor = (current_average > 0.f) && (target_average > 0.f);
  float anchor_boost =
      has_valid_anchor ? (target_average / current_average) : 1.f;
  [branch] if (has_valid_anchor) { bt709_scene *= anchor_boost; }

  bt709_scene *= mid_gray_scale;
  [branch] if (has_valid_anchor) { bt709_scene /= anchor_boost; }

  float anchor_in = has_valid_anchor ? current_average : target_average;
  float anchor_out = target_average;
  float psychov_cone_response = max(0.f, psychov_cone_response_baseline);

  return renodx::tonemap::psychov::psychotm_test17(
      bt709_scene, calculated_peak, RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST, RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT, 100.f, 1.f, 1.f, 1, psychov_cone_response,
      anchor_in.xxx, anchor_out.xxx, 1.f, is_sdr ? 0 : 1);
}

float3 CompressPsychoVForSdrLut(float3 psychov_hdr,
                                float vanilla_midgray_output,
                                out float3 adaptive_state_lms,
                                out float gamut_compression_scale,
                                out float n2_scale) {
  adaptive_state_lms = renodx::color::lms::from::BT709(
      max(vanilla_midgray_output.xxx, renodx::math::FLT_EPSILON.xxx));
  gamut_compression_scale =
      renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(
          psychov_hdr, adaptive_state_lms, 1.f);
  float3 psychov_hdr_compressed =
      renodx::color::gamut::GamutCompressBT709AdaptiveD65(
          psychov_hdr, adaptive_state_lms, gamut_compression_scale);
  n2_scale =
      renodx::tonemap::neutwo::ComputeMaxChannelScale(psychov_hdr_compressed);
  return psychov_hdr_compressed * n2_scale.xxx;
}

float3 DecompressPsychoVAfterSdrLut(float3 sdr_output_linear,
                                    float3 adaptive_state_lms,
                                    float gamut_compression_scale,
                                    float n2_scale) {
  float3 graded_hdr_compressed = renodx::math::DivideSafe(
      sdr_output_linear, n2_scale.xxx, sdr_output_linear);
  return renodx::color::gamut::GamutDecompressBT709AdaptiveD65(
      graded_hdr_compressed, adaptive_state_lms, gamut_compression_scale);
}

float4 main(precise noperspective float4 SV_Position : SV_Position,
            linear float2 TEXCOORD : TEXCOORD,
            linear float4 TEXCOORD_1 : TEXCOORD1)
    : SV_Target {
  float4 scene_sample = SceneTexture.Sample(SceneSampler, TEXCOORD);
  float exposure = ExposureTexture.Load(int3(0, 0, 0)).x;
  float3 exposed_scene_color = scene_sample.rgb * exposure;
  float3 hdr_color = exposed_scene_color;
#if TONEMAPPER_USE_GLARE
  hdr_color = AddBloomGlare(hdr_color, TEXCOORD, TEXCOORD_1);
#endif
#if TONEMAPPER_USE_BLOOM
  hdr_color += BloomAdd(SampleBloomBicubic(TEXCOORD));
#endif
#if TONEMAPPER_EXTRA_TEXTURE_COUNT >= 1
  hdr_color += ExtraTexture0.Sample(ExtraSampler0, TEXCOORD).rgb;
#endif
#if TONEMAPPER_EXTRA_TEXTURE_COUNT >= 2
  hdr_color += ExtraTexture1.Sample(ExtraSampler1, TEXCOORD).rgb;
#endif

  float3 output = hdr_color;

  if (RENODX_TONE_MAP_TYPE) {
    float vanilla_midgray_output = Luma709(ApplyVanillaTonemap(0.18f.xxx));
    float3 psychov_hdr =
        PsychoVTest17(hdr_color, 1.f, 0.18f, 0.18f, false, 1.25f);

    float3 psychov_adaptive_state_lms;
    float psychov_gamut_compression_scale;
    float n2_scale;
    float3 psychov_sdr_input = CompressPsychoVForSdrLut(
        psychov_hdr, vanilla_midgray_output, psychov_adaptive_state_lms,
        psychov_gamut_compression_scale, n2_scale);

    float3 psychov_sdr_output_linear =
        ApplyLatePost(psychov_sdr_input, TEXCOORD);
    float3 psychov_hdr_output = DecompressPsychoVAfterSdrLut(
        psychov_sdr_output_linear, psychov_adaptive_state_lms,
        psychov_gamut_compression_scale, n2_scale);
    output = psychov_hdr_output;
  } else {
    output = ApplyVanillaTonemap(hdr_color);
    output = ApplyLatePost(output, TEXCOORD);
    // output = renodx::draw::ToneMapPass(hdr_color.rgb, output);
  }
  return float4(renodx::draw::RenderIntermediatePass(output), scene_sample.a);
}
