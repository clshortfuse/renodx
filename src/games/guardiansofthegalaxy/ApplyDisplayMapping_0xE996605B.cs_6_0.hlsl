// ApplyDisplayMapping_HDR_LUT_UI_Compute: UI composite + display-mapping LUT (tonemap + PQ) -> R10G10B10A2 HDR10.

#include "./shared.h"
#include "../../shaders/tonemap/psychov/test35.hlsl"
#include "./lilium_rcas.hlsli"

Texture2D<float4> mapSource : register(t0);

Texture3D<float4> mapLUT_HDR : register(t1);

Texture2D<float4> mapUI : register(t5);

RWTexture2D<float4> uavHDR : register(u0);

struct SDisplayMappingConstants {
  float2 vLUTScaleBias;
  float2 vMinPoint;
  float2 vMidPoint;
  float2 vMaxPoint;
  float2 vSlope;
  float2 fEngineGammaCtrl;
  float4 vCoefs[10];
};

// Lilium RCAS tap: clamped to the render area, non-negative.
float3 LoadSharpenTap(int2 coord, int2 lo, int2 hi) {
  return max(mapSource.Load(int3(clamp(coord, lo, hi), 0)).rgb, 0.f);
}

cbuffer _ApplyDisplayMapping : register(b0) {
  uint4 g_viewport : packoffset(c000.x);
  uint4 g_renderArea : packoffset(c001.x);
  SDisplayMappingConstants g_HDR : packoffset(c002.x);
  SDisplayMappingConstants g_SDR : packoffset(c015.x);
};

SamplerState MaterialSamplers[1920] : register(s0);

#include "./aces_sdr.hlsli"

// CUSTOM: PsychoV35 extension. cone/compression are passed in.
float3 PsychoVExtension(float3 bt709, float peak_ratio, float background, float cone, float compression) {
  float3 result = renodx::tonemap::psychov::psychotm_test35(bt709, peak_ratio, 1.f, 1.f, 1.f, 1.f, 1.f,
      1.f, 100.f, 1.f, 1.f, 0, cone, 0.18f, float3(background, background, background), 1.f, 1, 1.f, compression,
      renodx::tonemap::psychov::PSYCHO35_SOURCE_BOUNDARY_BT2020, true);
  if (any(isnan(result))) result = 0.f;
  return result;
}

// PsychoV cone exponent for the neutral curve, fitted to the game's SDR ACES output.
static const float NEUTRAL_CONE = 1.435f;
// PsychoV compression for the neutral curve, fitted to the game's SDR ACES output.
static const float NEUTRAL_COMPRESSION = 0.88f;
// Upper bound on log2(peak_ratio) for the HDR cone/compression fits (6 stops).
static const float HDR_FIT_MAX_STOPS = 6.f;
// HDR cone fit: BASE + l * (SLOPE + CURVE * l), where l = log2(peak_ratio).
static const float HDR_CONE_BASE = 1.417072f;
static const float HDR_CONE_SLOPE = 0.021137f;
static const float HDR_CONE_CURVE = -0.001242f;
// HDR compression fit: BASE + l * (SLOPE + CURVE * l), where l = log2(peak_ratio).
static const float HDR_COMPRESSION_BASE = 0.744693f;
static const float HDR_COMPRESSION_SLOPE = -0.128429f;
static const float HDR_COMPRESSION_CURVE = 0.009955f;
// Peak parameter for the ACES ODT tone map in the HDR-graded branch.
static const float HDR_ACES_ODT_PEAK = 4.8f;

[numthreads(16, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float3 color = 0.f;
  if (((bool)((bool)((uint)(uint)(SV_DispatchThreadID.x) < (uint)g_viewport.z) && (bool)((uint)(uint)(SV_DispatchThreadID.y) < (uint)g_viewport.w))) && ((bool)((bool)((uint)(uint)(SV_DispatchThreadID.x) >= (uint)g_viewport.x) && (bool)((uint)(uint)(SV_DispatchThreadID.y) >= (uint)g_viewport.y)))) {
    if (((bool)((bool)((uint)(uint)(SV_DispatchThreadID.x) < (uint)g_renderArea.z) && (bool)((uint)(uint)(SV_DispatchThreadID.y) < (uint)g_renderArea.w))) && ((bool)((bool)((uint)(uint)(SV_DispatchThreadID.x) >= (uint)g_renderArea.x) && (bool)((uint)(uint)(SV_DispatchThreadID.y) >= (uint)g_renderArea.y)))) {
      float4 scene_input = mapSource.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
      float4 ui_input = mapUI.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
      if (RENODX_SHARPNESS > 0.f) {
        int2 pix = int2(SV_DispatchThreadID.xy);
        int2 lo = int2(g_renderArea.xy);
        int2 hi = int2(g_renderArea.zw) - 1;
        scene_input.rgb = ApplyLiliumRCAS(
            LoadSharpenTap(pix + int2(0, -1), lo, hi), LoadSharpenTap(pix + int2(-1, 0), lo, hi),
            max(scene_input.rgb, 0.f),
            LoadSharpenTap(pix + int2(1, 0), lo, hi), LoadSharpenTap(pix + int2(0, 1), lo, hi),
            RENODX_SHARPNESS, max(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, 1.f));
      }
      if (RENODX_PEAK_WHITE_NITS <= 0.f || RENODX_TONE_MAP_TYPE == 0.f || RENODX_HDR_OUTPUT == 0.f) {
        float4 _74 = mapLUT_HDR.SampleLevel(MaterialSamplers[1u], float3(((log2((mad(0.04575581103563309f, ui_input.z, mad(0.3411155045032501f, ui_input.y, (ui_input.x * 0.6130499243736267f))) * 2.7699999809265137f) + (ui_input.w * scene_input.x)) * g_HDR.vLUTScaleBias.x) + g_HDR.vLUTScaleBias.y), ((log2((mad(0.011935809627175331f, ui_input.z, mad(0.9180729389190674f, ui_input.y, (ui_input.x * 0.07000420987606049f))) * 2.7699999809265137f) + (ui_input.w * scene_input.y)) * g_HDR.vLUTScaleBias.x) + g_HDR.vLUTScaleBias.y), ((log2((mad(0.8729248642921448f, ui_input.z, mad(0.10678841918706894f, ui_input.y, (ui_input.x * 0.02049521915614605f))) * 2.7699999809265137f) + (ui_input.w * scene_input.z)) * g_HDR.vLUTScaleBias.x) + g_HDR.vLUTScaleBias.y)), 0.0f);
        color = _74.rgb;
      } else {
        // CUSTOM: SDR is the exact game ACES 1.0 (AP1 scene). NEUTRAL_CONE / NEUTRAL_COMPRESSION are fitted to that SDR
        // neutral curve. Below -1 stops output = SDR, blended to the PsychoV extension by +2 stops.
        // Above SDR mid-gray, colour comes from per-channel ACES (RRT + SSTS with the shoulder at peak, as the game's own
        // HDR transform); luminance comes from PsychoV. No over-peak whitening.
        float peak_ratio = max(RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS) / RENODX_DIFFUSE_WHITE_NITS;
        float3 scene = max(scene_input.rgb, 0.f);
        if (RENODX_TONE_MAP_EXPOSURE <= 0.f) {
          scene = 0.f;
        } else {
          scene = renodx::color::grade::UserColorGrading(scene, RENODX_TONE_MAP_EXPOSURE, RENODX_TONE_MAP_HIGHLIGHTS, RENODX_TONE_MAP_SHADOWS, RENODX_TONE_MAP_CONTRAST, RENODX_TONE_MAP_SATURATION);
        }
        float3 rgb_pre = GameAcesRRT(scene);
        float3 sdr = GameAcesODT(rgb_pre, g_SDR);
        float sdr_mid = GameAcesODT(GameAcesRRT(0.18f), g_SDR).x;
        float3 untonemapped = mul(renodx::color::AP1_TO_BT709_MAT, mul(renodx::tonemap::aces::ODT_SAT_MAT, rgb_pre));
        // CUSTOM: Hue clip emulation ported from zelda-oot-oz scene_tonemap.slangi, using the game SDR as the reference.
        if (RENODX_TONE_MAP_HUE_CLIP > 0.f) {
          float3 magnitude = abs(untonemapped);
          float3 reference = sdr;
          float reference_min = renodx::math::Min(reference);
          float reference_range = renodx::math::Max(reference) - reference_min;
          bool reference_neutral = reference_range == 0.f;
          float3 transferred = renodx::math::Rescale(
              reference - reference_min, 0.f,
              renodx::math::Select(reference_neutral, 1.f, reference_range),
              renodx::math::Min(magnitude), renodx::math::Max(magnitude));
          transferred = renodx::math::CopySign(transferred, untonemapped);
          transferred = renodx::math::Select(reference_neutral, untonemapped, transferred);
          float3 bent = lerp(untonemapped, transferred, RENODX_TONE_MAP_HUE_CLIP);
          float original_y = renodx::color::y::from::BT709(untonemapped);
          float bent_y = renodx::color::y::from::BT709(bent);
          if (original_y > 0.f && bent_y > 0.f) {
            untonemapped = bent * (original_y / bent_y);
          }
        }
        float hdr_l = clamp(log2(peak_ratio), 0.f, HDR_FIT_MAX_STOPS);
        // CUSTOM: fitted to the game's ACES RRT + SSTS shoulder at peak, mid matched to the SDR;
        // replaces the SDR shoulder stretched to peak, which pinned highlights near peak.
        float hdr_cone = HDR_CONE_BASE + hdr_l * (HDR_CONE_SLOPE + HDR_CONE_CURVE * hdr_l);
        float hdr_compression = HDR_COMPRESSION_BASE + hdr_l * (HDR_COMPRESSION_SLOPE + HDR_COMPRESSION_CURVE * hdr_l);
        float3 hdr = PsychoVExtension(untonemapped, peak_ratio, sdr_mid, hdr_cone, hdr_compression);
        float3 neutral = PsychoVExtension(untonemapped, 1.f, sdr_mid, NEUTRAL_CONE, NEUTRAL_COMPRESSION);

        float yh = renodx::color::y::from::BT709(hdr);
        float yn = renodx::color::y::from::BT709(neutral);
        float yg = renodx::color::y::from::BT709(sdr);
        float ratio = yh < yn ? yh / yn : (yg > 0.f ? (yg + max(yh - yn, 0.f)) / yg : 0.f);
        float t = saturate((log2(max(yn, 1e-7f) / sdr_mid) + 1.f) / 3.f);
        float w = t * t * t * (t * (t * 6.f - 15.f) + 10.f);
        ratio = 1.f + (ratio - 1.f) * w;
        float3 hdr_aces = mul(renodx::color::AP1_TO_BT709_MAT, renodx::tonemap::aces::ODTToneMap(rgb_pre, 0.0001f, HDR_ACES_ODT_PEAK * peak_ratio / sdr_mid));
        float yw = renodx::color::y::from::BT709(hdr_aces);
        float3 graded = lerp(sdr, yw > 0.f ? hdr_aces * (yg / yw) : sdr, w) * ratio;
        float3 tm709 = lerp(hdr, graded, RENODX_TONE_MAP_SDR_COLOR);
        // CUSTOM: gamma correction is for the sRGB UI only; applying it to the composite made scene brightness depend on UI brightness.
        float3 ui = ui_input.rgb;
        if (RENODX_GAMMA_CORRECTION != 0) {
          float coverage = 1.f - ui_input.w;
          if (coverage > 0.f) ui = renodx::color::correct::GammaSafe(ui / coverage, false, 2.2f) * coverage;
        }
        float3 composite = tm709 * (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS) * ui_input.w + ui;
        float3 out_nits = mul(renodx::color::BT709_TO_BT2020_MAT, composite) * RENODX_GRAPHICS_WHITE_NITS;
        float max_nits = max(out_nits.r, max(out_nits.g, out_nits.b));
        if (max_nits > RENODX_PEAK_WHITE_NITS) out_nits *= RENODX_PEAK_WHITE_NITS / max_nits;
        if (any(isnan(out_nits))) out_nits = 0.f;
        color = renodx::color::pq::EncodeSafe(out_nits, 1.f);
      }
    }
    uavHDR[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(color, 0.0f);
  }
}
