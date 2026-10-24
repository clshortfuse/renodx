// Shared body of the final output passes (ps_5_0): scene + UI -> display mapping -> BT.2020 PQ (HDR10).
// The Vanilla branch is hand-decompiled from the DevKit disassembly of the original pass.
// Each variant (final_0x*.ps_5_0.hlsl) only differs in how it reads the scene; it calls FinalPass() with it.
//
// Vanilla composites the UI in linear light, runs Frostbite's display-mapping LUT (t9), which is
// near-linear at ~100 nits per unit up to the in-game HDR calibration peak, and PQ-encodes.
// RenoDX keeps that path for Tone Mapper = Vanilla. Otherwise it tone-maps the graded scene to
// Peak Brightness and composites the UI afterwards at UI Brightness.
#pragma once
#include "./shared.h"

cbuffer Constants : register(b0) {
  float2 g_mainTexSize;
  float2 g_mainTexInvSize;
  float2 g_mainTexInvSizeYbyTwoAndThree;
  float2 g_mainTexInvSizeByHalf;
  float2 g_outputTexSize;
  float2 g_outputTexInvSize;
  float4 g_planeWeights;  // x: scene, y: UI color, z: UI alpha
  uint g_CmaskBufferStride;
  uint g_dynamicBranchFlags;  // 1: accessibility, 2: display mapping LUT, 8: UI overlay, 16: watermark
  float2 g_perceptualLutParams_UNUSED;
  float2 g_packFactors;
  float2 g_unpackFactors;
  uint g_frameIndex;
  uint pad0;
  uint pad1;
  uint pad2;
  float colorBlindProtanopiaFactor;
  float colorBlindDeuteranopiaFactor;
  float colorBlindTritanopiaFactor;
  float colorBlindDaltonizeFactor;
  float accessibilityBrightnessFactor;
  float accessibilityContrastFactor;
  float colorBlindDaltonizeContrastFactor;
  float colorBlindDaltonizeBrightnessFactor;
  float colorBlindDaltonizeLightnessFactor;
  float cb_pad0;
  float cb_pad1;
  float cb_pad2;
};

SamplerState g_pointSampler : register(s0);
SamplerState g_linearSampler : register(s1);
SamplerState g_overlaySampler : register(s2);
Texture2D<float4> g_mainTexture : register(t0);
Texture2D<float4> g_overlayTexture : register(t1);
Texture3D<float4> g_displayMappingLutHdr : register(t9);
Texture2D<float4> g_watermarkTexture : register(t10);

static const uint FLAG_ACCESSIBILITY = 1u;
static const uint FLAG_DISPLAY_MAPPING = 2u;
static const uint FLAG_UI_OVERLAY = 8u;
static const uint FLAG_WATERMARK = 16u;
// Frostbite's linear HDR scale: 1.0 = 100 nits (the vanilla PQ encode multiplies by 0.01).
static const float VANILLA_NITS_PER_UNIT = 100.f;

// Vanilla sRGB helpers: the encode takes log2(|c|) but branches on the signed value.
float3 VanillaSrgbEncode(float3 c) {
  float3 encoded = exp2(log2(abs(c)) * (1.f / 2.4f)) * 1.055f - 0.055f;
  return renodx::math::Select(c <= 0.0031308f, c * 12.92f, encoded);
}

float3 VanillaSrgbDecode(float3 c) {
  float3 decoded = exp2(log2((c + 0.055f) * (1.f / 1.055f)) * 2.4f);
  return renodx::math::Select(c <= 0.04045f, c * (1.f / 12.92f), decoded);
}

// Accessibility brightness/contrast and daltonization, verbatim from vanilla.
float3 ApplyAccessibility(float3 color) {
  float3 c = exp2(colorBlindDaltonizeBrightnessFactor) * color;
  c = VanillaSrgbEncode(c) - 0.5f;
  c = VanillaSrgbDecode(c * (accessibilityContrastFactor + 1.f) + 0.5f);

  const float l = dot(c, float3(17.8824f, 43.5161f, 4.11935f));
  const float m = dot(c, float3(3.45565f, 27.1554f, 3.86714f));
  const float s = dot(c, float3(0.0299566f, 0.184309f, 1.46709f));
  const float l_sim = lerp(l, m * 2.02344f - s * 2.52810f, colorBlindProtanopiaFactor);
  const float m_sim = lerp(m, l * 0.494207f + s * 1.24827f, colorBlindDeuteranopiaFactor);
  const float s_sim = lerp(s, l * -0.012245f + m * 0.072034f, colorBlindTritanopiaFactor);
  const float3 simulated = l_sim * float3(0.080944f, -0.010249f, -0.000365f)
                           + m_sim * float3(-0.130504f, 0.054019f, -0.004122f)
                           + s_sim * float3(0.116721f, -0.113615f, 0.693511f);
  float3 error = c - simulated;
  error = float3(0.f, error.y + error.x * 0.7f, error.z + error.x * 0.7f);
  const float3 corrected = saturate(c + error);
  return max(0.f, c + colorBlindDaltonizeFactor * (corrected - c));
}

// Watermark, applied in sRGB / YCbCr, verbatim from vanilla.
float3 ApplyWatermark(float3 color, float2 pixel_yx) {
  float3 encoded = VanillaSrgbEncode(color);
  const float3 mark = g_watermarkTexture.SampleLevel(g_linearSampler, trunc(pixel_yx.yx) * g_outputTexInvSize, 0).rgb;
  const float y = dot(encoded, float3(0.299f, 0.587f, 0.114f));
  float cb = dot(encoded, float3(-0.1687f, -0.3313f, 0.5f));
  float cr = dot(encoded, float3(0.5f, -0.4187f, -0.0813f));
  const float weight = saturate(mark.x + mark.y + mark.z);
  cb += weight * (mark.y * 0.5f - frac(cb * 18.f)) * (1.f / 18.f);
  cr += weight * (mark.z * 0.5f - frac(cr * 18.f)) * (1.f / 18.f);
  const float3 marked = float3(y + 1.402f * cr, y - 0.34414f * cb - 0.71414f * cr, y + 1.772f * cb);
  encoded = encoded * (1.f - weight) + weight * marked;
  return VanillaSrgbDecode(encoded);
}

// `scene` is the graded scene, already multiplied by g_planeWeights.x (1.0 = 100 nits).
// `with_ui` false gives the same picture without the UI composite (the HUD-less output frame generation reads).
float4 FinalPass(float2 uv, float3 scene, bool with_ui) {
  const float4 ui = g_overlayTexture.SampleLevel(g_overlaySampler, uv, 0);  // premultiplied, sRGB-decoded by the view
  const uint flags = g_dynamicBranchFlags & (with_ui ? 0xFFFFFFFFu : ~FLAG_UI_OVERLAY);
  const float2 pixel_yx = uv.yx * g_outputTexSize.yx;

  float3 output_nits;
  [branch]
  if (RENODX_TONE_MAP_TYPE == renodx::draw::TONE_MAP_TYPE_VANILLA) {
    float3 color = scene;
    if (flags & FLAG_UI_OVERLAY) {
      color = color * (1.f - ui.a * g_planeWeights.z) + ui.rgb * g_planeWeights.y;
    }
    if (flags & FLAG_ACCESSIBILITY) color = ApplyAccessibility(color);
    if (flags & FLAG_WATERMARK) color = ApplyWatermark(color, pixel_yx);
    if (flags & FLAG_DISPLAY_MAPPING) {
      const float3 lut_coord = f32tof16(min(max(color, 0.f), 65504.f)) * (1.f / 32768.f) + (1.f / 64.f);
      color = g_displayMappingLutHdr.SampleLevel(g_linearSampler, lut_coord, 0).rgb;
    }
    output_nits = color * VANILLA_NITS_PER_UNIT;
  } else {
    // The graded scene is already HDR (Frostbite grades in log space in 0x1600E7FD), so there is no
    // SDR grade to carry over: tone-map the scene directly. 1.0 = Game Brightness nits.
    float3 color = scene;
    if (flags & FLAG_ACCESSIBILITY) color = ApplyAccessibility(color);
    if (flags & FLAG_WATERMARK) color = ApplyWatermark(color, pixel_yx);
    output_nits = renodx::draw::ToneMapPass(color) * RENODX_DIFFUSE_WHITE_NITS;

    if (flags & FLAG_UI_OVERLAY) {
      float3 ui_linear = ui.rgb;
      [branch]
      if (CUSTOM_UI_EOTF_EMULATION != 0.f) {
        ui_linear = renodx::color::correct::GammaSafe(ui_linear);
      }
      output_nits = output_nits * (1.f - ui.a * g_planeWeights.z) + ui_linear * RENODX_GRAPHICS_WHITE_NITS;
    }
  }

  // BT.709 -> BT.2020, PQ (1.0 = 10000 nits), then vanilla's +-1/127 dither (golden-ratio frame offset).
  float3 pq = renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(output_nits), 1.f);

  const float2 p = trunc(pixel_yx);  // (y, x)
  const float frame_offset = float(g_frameIndex) * 1.618034f;
  float3 noise;
  noise.x = frac(frac(dot(float2(p.x + 447.059021f, p.y + 447.059021f), float2(-0.067111f, -0.005837f))) * 52.982918f + frame_offset);
  noise.y = frac(frac(dot(float2(p.y + 475.000214f, p.x + 475.000214f), float2(-0.067111f, 0.005837f))) * 52.982918f + frame_offset);
  noise.z = frac(frac(dot(float2(p.x + 502.941406f, p.y + 502.941406f), float2(0.067111f, -0.005837f))) * 52.982918f + frame_offset);
  pq += (noise * 2.f - 1.f) * (1.f / 127.f);

  return float4(max(pq, 0.f), 1.f);
}

// The variants the game uses with DLSS Frame Generation write two targets: the final image with the UI, and the same
// picture without it (the HUD-less colour buffer frame generation reads). Both go through the same tone mapping.
struct FinalOutputs {
  float4 with_ui : SV_Target0;
  float4 hud_less : SV_Target1;
};

FinalOutputs FinalPassWithHudLess(float2 uv, float3 scene) {
  FinalOutputs outputs;
  outputs.with_ui = FinalPass(uv, scene, true);
  outputs.hud_less = FinalPass(uv, scene, false);
  return outputs;
}
