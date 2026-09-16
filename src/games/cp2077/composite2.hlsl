#include "./injectedBuffer.hlsl"

void composite2_vignette(in float in_r, in float in_g, in float in_b,
                         inout float out_r, inout float out_g, inout float out_b) {
  out_r = lerp(in_r, out_r, injectedData.fxVignette);
  out_g = lerp(in_g, out_g, injectedData.fxVignette);
  out_b = lerp(in_b, out_b, injectedData.fxVignette);
}

void composite2_draw_graph_start() {
}

void composite2_sample(Texture3D<float3> textureLUT[3], SamplerState sampler0,
                       in float4 cb6_6u, in float4 cb6_12u, in uint selector,
                       in float in_r, in float in_g, in float in_b,
                       inout float out_r, inout float out_g, inout float out_b) {
  uint useLUT1 = min((asuint(cb6_12u).x & selector), 1u);
  uint useLUT2 = min((asuint(cb6_12u).y & selector), 1u);
  uint useLUT3 = min((asuint(cb6_12u).z & selector), 1u);
  bool useLUT = false;
  uint lutStrength = 0u;
  uint lutIndex = 0u;
  if (useLUT1 != 0u) {
    useLUT = true;
    lutIndex = 0u;
    lutStrength = useLUT1;
  } else if (useLUT2 != 0u) {
    useLUT = true;
    lutIndex = 1u;
    lutStrength = useLUT2;
  } else if (useLUT3 != 0u) {
    useLUT = true;
    lutIndex = 2u;
    lutStrength = useLUT3;
  }

  float3 color = float3(in_r, in_g, in_b);
  if (useLUT) {
    float3 lut_color;

    if (CUSTOM_SAMPLING_ENCODE_PQ) {
      float3 pqColor = renodx::color::pq::Encode(color, 100.f);  // reset scale to 0-1 for 0-10000 nits
      lut_color = renodx::lut::SampleTetrahedral(textureLUT[lutIndex], pqColor).rgb;
      // lut_color = renodx::lut::Sample(textureLUT[lutIndex], sampler0, pqColor).rgb;

    } else {
      // cb6[6u].x 0.05888671
      // cb6[6u].y 0.59765625
      float3 lutInputColor = (cb6_6u.x * log2(color)) + cb6_6u.y;
      lut_color = textureLUT[lutIndex].SampleLevel(sampler0, lutInputColor, 0.0f).rgb;
    }

    if (CUSTOM_SAMPLING_DECODE_PQ) {
      lut_color = sign(lut_color) * renodx::color::pq::Decode(abs(lut_color), 100.f);
    }
    color = lerp(color, lut_color, float(lutStrength));
  }
  out_r = color.r;
  out_g = color.g;
  out_b = color.b;
}

void composite2_sample(Texture3D<float3> textureLUT[3], SamplerState sampler0,
                       in float4 cb6_6u, in float4 cb6_12u, in uint selector,
                       in float in_r, in float in_g, in float in_b,
                       inout float out_r, inout float out_g, inout float out_b,
                       float2 position, Texture2D<float3> texture) {
  [branch]
  if (CUSTOM_DRAW_GRAPH) {
    renodx::debug::graph::Config graph_config = renodx::debug::graph::DrawStart(
        position.xy,
        float3(in_r, in_g, in_b),
        texture, RENODX_PEAK_WHITE_NITS, 100.f);
    composite2_sample(textureLUT, sampler0, cb6_6u, cb6_12u, selector, graph_config.color.r, graph_config.color.g, graph_config.color.b, out_r, out_g, out_b);
    float3 scaled = renodx::debug::graph::DrawEnd(float3(out_r, out_g, out_b), graph_config);
    out_r = scaled.r;
    out_g = scaled.g;
    out_b = scaled.b;
  } else {
    composite2_sample(textureLUT, sampler0, cb6_6u, cb6_12u, selector, in_r, in_g, in_b, out_r, out_g, out_b);
  }
}

void composite2_global(in float4 global_values,
                       inout float out_r, inout float out_g, inout float out_b) {
  // out_r *= lerp(1.f, global_values.w, injectedData.processingGlobalGain);
  // out_g *= lerp(1.f, global_values.w, injectedData.processingGlobalGain);
  // out_b *= lerp(1.f, global_values.w, injectedData.processingGlobalGain);

  // out_r += global_values.r * injectedData.processingGlobalLift;
  // out_g += global_values.g * injectedData.processingGlobalLift;
  // out_b += global_values.b * injectedData.processingGlobalLift;

  out_r *= global_values.w;
  out_g *= global_values.w;
  out_b *= global_values.w;

  out_r += global_values.r;
  out_g += global_values.g;
  out_b += global_values.b;
}
