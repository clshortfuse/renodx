#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Fri Dec 26 12:55:04 2025
Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[7];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: SV_POSITION0, float2 v1: TEXCOORD0,
          out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  bool need_inverse = (CUSTOM_CUSTOM_LUT_COUNT != 1);

  r0.xy = cb0[5].zw + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if (need_inverse) {
    r0.xyzw = renodx::draw::InvertIntermediatePass(r0.xyzw);
    r0.xyzw = renodx::color::srgb::EncodeSafe(r0.xyzw);
  }
  r0.xyz = cb0[6].www * r0.xyz;
  r1.xy = -cb0[5].zw + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if (need_inverse) {
    r1.xyzw = renodx::draw::InvertIntermediatePass(r1.xyzw);
    r1.xyzw = renodx::color::srgb::EncodeSafe(r1.xyzw);
  }

  r0.xyz = r1.xyz * cb0[6].www + r0.xyz;
  r1.xy = cb0[6].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if (need_inverse) {
    r1.xyzw = renodx::draw::InvertIntermediatePass(r1.xyzw);
    r1.xyzw = renodx::color::srgb::EncodeSafe(r1.xyzw);
  }
  r0.xyz = r1.xyz * cb0[6].www + r0.xyz;
  r1.xy = -cb0[6].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if (need_inverse) {
    r1.xyzw = renodx::draw::InvertIntermediatePass(r1.xyzw);
    r1.xyzw = renodx::color::srgb::EncodeSafe(r1.xyzw);
  }
  r0.xyz = r1.xyz * cb0[6].www + r0.xyz;

  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if (need_inverse) {
    r1.xyzw = renodx::draw::InvertIntermediatePass(r1.xyzw);
    r1.xyzw = renodx::color::srgb::EncodeSafe(r1.xyzw);
  }

  float3 render = r1.rgb;

  r0.xyz = r1.xyz * cb0[6].zzz + -r0.xyz;

  float3 untonemapped_gamma = r0.xyz;

  o0.w = r1.w;
  // 1/sqrt(3) ≈ 0.57735026919 — used to normalize the (1,1,1) direction
  // project r0.zxy onto the normalized (1,1,1) axis (component along that axis)
  r1.xyz = float3(0.57735002, 0.57735002, 0.57735002) * r0.zxy;
  // compute residual (original vector minus its projection) — yields perp component
  r1.xyz = r0.zxy * float3(0.57735002, 0.57735002, 0.57735002) + -r1.zxy;
  // PI/180 = 0.0174532924 — convert degrees to radians
  r0.w = 0.0174532924 * cb0[4].x;  // angle in radians
  sincos(r0.w, r2.x, r3.x);        // r2.x = sin(angle), r3.x = cos(angle)
  // apply sin to the perpendicular component
  r1.xyz = r2.xxx * r1.xyz;
  // combine cos*original + sin*perp => rotate original around (1,1,1)-like axis
  r1.xyz = r0.xyz * r3.xxx + r1.xyz;
  // compute scalar projection of r0 onto the normalized (1,1,1) vector (luma-like term)
  r0.x = dot(float3(0.57735002, 0.57735002, 0.57735002), r0.xyz);
  // scale by 1/sqrt(3) again (final normalized component magnitude)
  r0.x = 0.57735002 * r0.x;
  r0.y = 1 + -r3.x;
  r0.xyz = r0.xxx * r0.yyy + r1.xyz;
  r0.xyz = float3(-0.5, -0.5, -0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[4].www + float3(0.5, 0.5, 0.5);
  r1.xyz = cb0[4].zzz * r0.xyz;
  r0.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.xyz = r0.xyz * cb0[4].zzz + -r0.www;
  r0.xyz = cb0[4].yyy * r0.xyz + r0.www;
  r1.xyz = r0.xyz * cb0[5].xxx + cb0[5].yyy;

  if (RENODX_TONE_MAP_TYPE != 0.f && CUSTOM_CUSTOM_LUT_COUNT != 1) {
    float3 input_color = r1.xyz;
    // linearize
    float3 linear_color = renodx::color::srgb::DecodeSafe(input_color);

    float linear_grayscale = renodx::color::convert::Luminance(linear_color, 0);
    const float MID_GRAY_LINEAR = 1 / (pow(10, 0.75));                          // ~0.18f
    const float MID_GRAY_PERCENT = 0.5f;                                        // 50%
    const float MID_GRAY_GAMMA = log(MID_GRAY_LINEAR) / log(MID_GRAY_PERCENT);  // ~2.49f
    float encode_gamma = MID_GRAY_GAMMA;
    float3 encoded = renodx::color::gamma::EncodeSafe(linear_color, encode_gamma);
    float encoded_grayscale = renodx::color::gamma::Encode(linear_grayscale, encode_gamma);
    float compression_scale = renodx::color::correct::ComputeGamutCompressionScale(encoded, encoded_grayscale);
    float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_grayscale, compression_scale);
    linear_color = renodx::color::gamma::DecodeSafe(compressed, encode_gamma);
    r1.xyz = renodx::color::srgb::EncodeSafe(linear_color);

    float max_channel = renodx::math::Max(r1.rgb);
    float new_scale = renodx::tonemap::ReinhardScalable(
        max_channel,
        1.0,
        0,
        0.5f,
        0.5f);

    // new_scale = min(new_scale, max_max_channel);
    float final_scale = max_channel != 0 ? new_scale / max_channel : 1.f;

    float old_scale = 1.f / max_channel;

    r1.rgb *= final_scale;
    r1.xyz = t1.Sample(s1_s, r1.xyz).xyz;
    r1.xyz /= final_scale;

    linear_grayscale = renodx::color::convert::Luminance(linear_color, 0);
    linear_color = renodx::color::srgb::DecodeSafe(r1.xyz);
    encoded = renodx::color::gamma::EncodeSafe(linear_color, encode_gamma);
    encoded_grayscale = renodx::color::gamma::Encode(linear_grayscale, encode_gamma);
    float3 decompressed = renodx::color::correct::GamutDecompress(encoded, encoded_grayscale, compression_scale);
    r1.xyz = renodx::color::gamma::DecodeSafe(decompressed, encode_gamma);
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);

    r1.xyz = r1.xyz * cb0[3].xyz;

    o0.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

    return;
  }
  untonemapped_gamma = r1.xyz;

  float3 untonemapped = renodx::color::srgb::Decode(untonemapped_gamma.rgb);

  float3 neutral_sdr = lerp(
      renodx::tonemap::renodrt::NeutralSDR(untonemapped),        // Luminance
      renodx::tonemap::ExponentialRollOff(untonemapped, 0.75f),  // Per channel
      0.5f);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r1.xyz = renodx::color::srgb::Encode(neutral_sdr);
  }

  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  // r1.xyz = r1.xyz + -r0.xyz;
  // r0.xyz = cb0[2].xxx * r1.xyz + r0.xyz;
  r0.xyz = lerp(r0.xyz, r1.xyz, cb0[2].x);
  o0.xyz = cb0[3].xyz * r0.xyz;
  float3 graded_color_gamma = o0.rgb;
  float3 graded_color = renodx::color::srgb::DecodeSafe(graded_color_gamma);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = graded_color;
  } else {
    float3 neutral_sdr_gamma = renodx::color::srgb::EncodeSafe(neutral_sdr);
    neutral_sdr_gamma *= cb0[3].xyz;
    untonemapped_gamma *= cb0[3].xyz;

    untonemapped = renodx::color::srgb::DecodeSafe(untonemapped_gamma);
    neutral_sdr = renodx::color::srgb::DecodeSafe(neutral_sdr_gamma);

    float3 final_color = renodx::draw::ToneMapPass(untonemapped, graded_color, neutral_sdr);
    o0.rgb = final_color;
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}
