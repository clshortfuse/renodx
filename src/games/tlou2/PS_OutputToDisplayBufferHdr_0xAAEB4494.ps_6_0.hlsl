#include "./common.hlsli"

struct ApplyHdrCodingConstants {
  float pq_scaling;
  float source_gamma;
  float2 source_offset;
};

Texture2D<float4> back_buffer : register(t0);

cbuffer cb0 : register(b0) {
  ApplyHdrCodingConstants apply_hdr_coding_constants : packoffset(c000.x);
};

float4 main(precise noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 gamma_bt709 = back_buffer.Load(int3(
      (int)(uint(apply_hdr_coding_constants.source_offset.x + SV_Position.x)),
      (int)(uint(apply_hdr_coding_constants.source_offset.y + SV_Position.y)),
      0));

  float3 pq_bt2020;
  if (RENODX_TONE_MAP_TYPE == 0.f) {  // Defaults: 2.41 gamma, 302 nits diffuse white
    float linear_bt709_r = pow(gamma_bt709.x, apply_hdr_coding_constants.source_gamma);
    float linear_bt709_g = pow(gamma_bt709.y, apply_hdr_coding_constants.source_gamma);
    float linear_bt709_b = pow(gamma_bt709.z, apply_hdr_coding_constants.source_gamma);
    float pq_scale = apply_hdr_coding_constants.pq_scaling * 10e-05f;
    float bt2020_r_m1 = exp2(log2(mad(0.04331306740641594f, linear_bt709_b, mad(0.3292830288410187f, linear_bt709_g, (linear_bt709_r * 0.6274039149284363f))) * pq_scale) * 0.1593017578125f);
    float bt2020_g_m1 = exp2(log2(mad(0.011362316086888313f, linear_bt709_b, mad(0.9195404052734375f, linear_bt709_g, (linear_bt709_r * 0.06909728795289993f))) * pq_scale) * 0.1593017578125f);
    float bt2020_b_m1 = exp2(log2(mad(0.8955952525138855f, linear_bt709_b, mad(0.08801330626010895f, linear_bt709_g, (linear_bt709_r * 0.016391439363360405f))) * pq_scale) * 0.1593017578125f);
    pq_bt2020.x = exp2(log2(((bt2020_r_m1 * 18.8515625f) + 0.8359375f) / ((bt2020_r_m1 * 18.6875f) + 1.0f)) * 78.84375f);
    pq_bt2020.y = exp2(log2(((bt2020_g_m1 * 18.8515625f) + 0.8359375f) / ((bt2020_g_m1 * 18.6875f) + 1.0f)) * 78.84375f);
    pq_bt2020.z = exp2(log2(((bt2020_b_m1 * 18.8515625f) + 0.8359375f) / ((bt2020_b_m1 * 18.6875f) + 1.0f)) * 78.84375f);
  } else {
    float3 linear_bt709;
    if (RENODX_SDR_EOTF_EMULATION == 1.f) {
      linear_bt709 = renodx::color::gamma::DecodeSafe(gamma_bt709.rgb, 2.2f);
    } else if (RENODX_SDR_EOTF_EMULATION == 2.f) {
      linear_bt709 = renodx::color::gamma::Decode(gamma_bt709.rgb, 2.41f);
    } else {
      linear_bt709 = renodx::color::srgb::Decode(gamma_bt709.rgb);
    }
    float3 linear_bt2020 = renodx::color::bt2020::from::BT709(linear_bt709);
    pq_bt2020 = renodx::color::pq::Encode(linear_bt2020, RENODX_GRAPHICS_WHITE_NITS);
  }

  return float4(pq_bt2020, 1.f);
}
