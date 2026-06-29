#include "./common.hlsli"

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
    if (CUSTOM_SDR_GAMUT_COMPRESSION == WOBBLY_SDR_GAMUT_COMPRESSION_ADAPTIVE_D65) {
      WobblyMaxChannelSdrState sdr_state = WobblyCompressToSdrMaxChannel(
          renodx::color::srgb::DecodeSafe(r1.xyz));
      r1.xyz = renodx::color::srgb::EncodeSafe(sdr_state.neutral_sdr_bt709);

      r1.xyz = t1.Sample(s1_s, r1.xyz).xyz;
      r1.xyz = renodx::color::srgb::EncodeSafe(WobblyReconstructFromSdrMaxChannel(
          renodx::color::srgb::DecodeSafe(r1.xyz),
          sdr_state));
    } else {
      WobblyGammaGamutCompressionState gamut_state;
      float3 linear_color = WobblyCompressGammaGamutForLut(
          renodx::color::srgb::DecodeSafe(r1.xyz),
          gamut_state);
      r1.xyz = renodx::color::srgb::EncodeSafe(linear_color);

      float new_scale = WobblyComputeMaxChannelSdrScale(r1.rgb);

      r1.rgb *= new_scale;
      r1.xyz = t1.Sample(s1_s, r1.xyz).xyz;
      r1.xyz = renodx::math::DivideSafe(r1.xyz, float3(new_scale, new_scale, new_scale), r1.xyz);

      linear_color = renodx::color::srgb::DecodeSafe(r1.xyz);
      r1.xyz = WobblyDecompressGammaGamutFromLut(linear_color, gamut_state);
      r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    }

    r1.xyz = r1.xyz * cb0[3].xyz;

    o0.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
    // o0.rgb = linear_color;
    o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

    return;
  }
  untonemapped_gamma = r1.xyz;

  float3 untonemapped = renodx::color::srgb::Decode(untonemapped_gamma.rgb);

  WobblyMaxChannelSdrState sdr_state = WobblyCompressToSdrMaxChannel(untonemapped);
  float3 neutral_sdr = sdr_state.neutral_sdr_bt709;

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
    float3 untonemapped_graded = WobblyReconstructFromSdrMaxChannel(graded_color, sdr_state);
    o0.rgb = WobblyApplyOutputToneMap(untonemapped_graded);
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}
