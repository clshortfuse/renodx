#version 450
#include "./shared.slang"

layout(set = 1, binding = 3, std140) uniform ufBlock {
  ivec4 uf_remappedPS[1];
  vec4 uf_fragCoordScale;
}
_295;

layout(set = 1, binding = 2) uniform sampler2D textureUnitPS2;
layout(set = 1, binding = 0) uniform sampler2D textureUnitPS0;
layout(set = 1, binding = 1) uniform sampler3D textureUnitPS1;

layout(location = 0) in vec4 passParameterSem0;
layout(location = 1) in vec4 passParameterSem1;
layout(location = 0) out vec4 out;

void main() {
  vec4 p0 = passParameterSem0;
  vec4 p1 = passParameterSem1;

  vec4 addTex = texture(textureUnitPS2, p1.xy);
  vec3 baseColor = texture(textureUnitPS0, p1.xy).xyz;
  vec3 scaledAdd = p0.w * addTex.xyz;
#ifdef ALT
  float blendFactor = 1.0 - saturate(renodx::color::luma::from::BT601(scaledAdd));
  baseColor *= blendFactor;
  #endif
  vec3 mixedColor = baseColor + scaledAdd;

  vec3 color = HejlDawson::Apply(mixedColor);
  color = renodx::color::gamma::DecodeSafe(color);
  color = lerp(saturate(mixedColor), color, TONEMAP_STRENGTH);
  color = lut(color);
  [branch]
  if (RENODX_TONE_MAP_TYPE == 3) {
    vec3 hdr = HejlDawson::ApplyExtended(mixedColor, 2.2f);
    hdr = lerp(mixedColor, hdr, TONEMAP_STRENGTH);
    hdr = lut(hdr, true);
    color = ColourCorrect(hdr, color);
  }
  if (RENODX_TONE_MAP_TYPE != 6) {
    color = ApplyColorGrade(color);
    out = vec4(color, addTex.w);
    out.xyz = DisplayMap(out.xyz);
    out = renodx::draw::RenderIntermediatePass(out);
  }
  if (RENODX_TONE_MAP_TYPE == 6) {
    color = renodx::tonemap::psychov::psychotm_test22(
        mixedColor,
        getPeak(),
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT,
        100.f,
        1.f,
        1.f,
        1,
        max(0.f, CUSTOM_CONE_RESPONSE),
        0.1413f,
        0.18f,
        1.f,
        1,
        1.f,
        1);
    color = lut(color, true, true);
    color = renodx::draw::RenderIntermediatePass(color);
    out = vec4(color, addTex.w);
  }
}

float3 lut(float3 color, bool is_hdr = false, bool is_bt2020 = false) {
  float custom_gamut_compression_scale;
  float3 custom_adaptive_state_lms = renodx::color::lms::from::BT709(max(0.18f, renodx::math::FLT_EPSILON));
  [branch]
  if (is_bt2020) {
    custom_gamut_compression_scale = renodx::color::gamut::ComputeGamutCompressionScaleBT709AdaptiveD65(color, custom_adaptive_state_lms, 1.f);
  } else {
    custom_gamut_compression_scale = 1.f;
  }
  float max_channel_scale;
  [branch]
  if (is_hdr) {
    max_channel_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(color);
  } else {
    max_channel_scale = 1.f;
  }

  float lutScale = intBitsToFloat(_295.uf_remappedPS[0].x);
  float lutBias = intBitsToFloat(_295.uf_remappedPS[0].y);
  vec3 lutCoord = color * max_channel_scale * lutScale + lutBias;
  vec3 lutColor = texture(textureUnitPS1, lutCoord).xyz;
  [branch]
  if (custom_gamut_compression_scale != 1.f) {
    lutColor = renodx::color::gamut::GamutDecompressBT709AdaptiveD65(lutColor, custom_adaptive_state_lms, custom_gamut_compression_scale);
  } else {
    // noop
  }
  return lerp(color, lutColor / max_channel_scale, LUT_STRENGTH);
}
