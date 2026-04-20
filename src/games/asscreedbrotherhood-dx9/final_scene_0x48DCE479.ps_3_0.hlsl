#include "./common.hlsli"

sampler2D s0 : register(s0);
sampler3D s1 : register(s1);

float4 g_PreLutScale : register(c0);
float4 g_PreLutOffset : register(c1);

struct PS_INPUT {
  float2 texcoord : TEXCOORD0;
};

float4 main(PS_INPUT i) : COLOR {
  float4 output = 0.f;

  float4 sample0 = tex2D(s0, i.texcoord);
  float3 lut_coord = mad(sample0.rgb, g_PreLutScale.xyz, g_PreLutOffset.xyz);

  // Recover gamma-encoded pre-LUT color by inverting the game's scale/offset
  float3 untonemapped_gamma = (lut_coord - g_PreLutOffset.xyz) / g_PreLutScale.xyz;
  float3 untonemapped = renodx::color::gamma::DecodeSafe(saturate(untonemapped_gamma), 2.2f);

  output.a = 0.f;

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    // Vanilla: sample LUT normally, blend with scene grade strength
    float3 lut_sample = tex3D(s1, lut_coord).rgb;
    float3 graded = renodx::color::gamma::DecodeSafe(max(0.f, lut_sample), 2.2f);
    graded = lerp(saturate(untonemapped), graded, RENODX_COLOR_GRADE_STRENGTH);
    output.rgb = renodx::color::gamma::EncodeSafe(max(0.f, graded), 2.2f);
  } else {
    // Custom (Neutwo / RenoDRT): max-channel compression into LUT range, then tonemap
    const float scale = ComputeMaxChCompressionScale(untonemapped);
    const float3 color_sdr = untonemapped * scale;

    // Re-encode compressed color to gamma 2.2 and map to LUT coord space
    float3 color_sdr_gamma = renodx::color::gamma::EncodeSafe(max(0.f, color_sdr), 2.2f);
    float3 new_lut_coord = mad(color_sdr_gamma, g_PreLutScale.xyz, g_PreLutOffset.xyz);

    float3 lut_sample = tex3D(s1, saturate(new_lut_coord)).rgb;
    float3 color_sdr_graded = renodx::color::gamma::DecodeSafe(max(0.f, lut_sample), 2.2f);

    // Apply scene grade strength as linear blend in linear space
    color_sdr_graded = lerp(saturate(color_sdr), color_sdr_graded, RENODX_COLOR_GRADE_STRENGTH);

    // Uncompress
    const float3 color_final = color_sdr_graded / scale;
    output.rgb = renodx::color::gamma::EncodeSafe(max(0.f, color_final), 2.2f);
  }

  output.rgb = ToneMapAndRenderIntermediatePass(output.rgb, i.texcoord);
  return output;
}
