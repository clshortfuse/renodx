#include "./filmiclutbuilder.hlsli"
#include "./lutbuildercommon.hlsli"

float4 ProcessOutputDevice89(float3 untonemapped_ap1, float3 processed, uint outputdevice, UECbufferConfig cb_config) {
  // 7 = Linear output (HDR)
  // 8 = Linear final color, no tone curve (HDR)
  // 9 = Linear final color with tone curve (HDR)

  float3 output;

  // if (outputdevice == 7u) {
  //   float3 pq_output = renodx::color::bt2020::from::AP1(untonemapped_ap1);
  //   output = renodx::color::pq::EncodeSafe(pq_output, RENODX_DIFFUSE_WHITE_NITS);
  // }

  if (outputdevice == 8u) {
    float3 linear_output;
    linear_output = cb_config.ue_colorscale.xyz * renodx::color::bt709::from::AP1(untonemapped_ap1);
    linear_output = ((cb_config.ue_overlaycolor.xyz - linear_output) * cb_config.ue_overlaycolor.w) + linear_output;
    output = linear_output;
  }
  if (outputdevice == 9u) {
    output = processed;
    output = renodx::tonemap::neutwo::PerChannel(output, 1.f);
  }

  return float4((output / 1.05f), 0.f);
}

// No SDR Lut
float4 ProcessLutbuilder(float3 untonemapped_ap1, UECbufferConfig cb_config, float4 SV_Target, uint outputdevice) {
  // The rare game uses linear output for some menus
  // So we will skip everything, and just return untonemapped

  float3 tonemapped;

  ApplyFilmToneMapWithBlueCorrect(untonemapped_ap1, tonemapped, cb_config);

  // float _1161 = mad((WorkingColorSpace.FromAP1[0].z), _1151, mad((WorkingColorSpace.FromAP1[0].y), _1150, ((WorkingColorSpace.FromAP1[0].x) * _1149)));
  // float _1162 = mad((WorkingColorSpace.FromAP1[1].z), _1151, mad((WorkingColorSpace.FromAP1[1].y), _1150, ((WorkingColorSpace.FromAP1[1].x) * _1149)));
  // float _1163 = mad((WorkingColorSpace.FromAP1[2].z), _1151, mad((WorkingColorSpace.FromAP1[2].y), _1150, ((WorkingColorSpace.FromAP1[2].x) * _1149)));
  float3 bt709_tonemapped = renodx::color::bt709::from::AP1(tonemapped);

  float3 scaled = cb_config.ue_colorscale.xyz * (((cb_config.ue_mappingpolynomial.y + (cb_config.ue_mappingpolynomial.x * bt709_tonemapped)) * bt709_tonemapped) + cb_config.ue_mappingpolynomial.z);

  float3 output = ((cb_config.ue_overlaycolor.xyz - scaled) * cb_config.ue_overlaycolor.w) + scaled;

  // Handle linear output device
  bool is_linear = (outputdevice == 8u || outputdevice == 9u);
  if (is_linear) {
    return ProcessOutputDevice89(untonemapped_ap1, output, outputdevice, cb_config);
  }

  return GenerateOutput(output.xyz, untonemapped_ap1, SV_Target, outputdevice);
}

// 1 SDR Lut

float4 ProcessLutbuilder(float3 untonemapped_ap1, SamplerState lut_sampler, Texture2D<float4> lut_texture, UECbufferConfig cb_config, float4 SV_Target, uint outputdevice) {
  float3 tonemapped;

  ApplyFilmToneMapWithBlueCorrect(untonemapped_ap1, tonemapped, cb_config);

  float3 bt709_tonemapped = renodx::color::bt709::from::AP1(tonemapped);

  float3 linear_output;
  SampleLUTUpgradeToneMap(bt709_tonemapped, lut_sampler, lut_texture, linear_output.r, linear_output.g, linear_output.b, cb_config);

  float3 scaled = cb_config.ue_colorscale.xyz * (((cb_config.ue_mappingpolynomial.y + (cb_config.ue_mappingpolynomial.x * linear_output)) * linear_output) + cb_config.ue_mappingpolynomial.z);

  float3 output = ((cb_config.ue_overlaycolor.xyz - scaled) * cb_config.ue_overlaycolor.w) + scaled;

  bool is_linear = (outputdevice == 8u || outputdevice == 9u);
  if (is_linear) {
    return ProcessOutputDevice89(untonemapped_ap1, output, outputdevice, cb_config);
  }

  return GenerateOutput(output.xyz, untonemapped_ap1, SV_Target, outputdevice);
}

// 2 SDR Luts

float4 ProcessLutbuilder(float3 untonemapped_ap1, SamplerState lut_sampler1, SamplerState lut_sampler2, Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, UECbufferConfig cb_config, float4 SV_Target, uint outputdevice) {
  float3 tonemapped;

  ApplyFilmToneMapWithBlueCorrect(untonemapped_ap1, tonemapped, cb_config);

  float3 bt709_tonemapped = renodx::color::bt709::from::AP1(tonemapped);

  float3 linear_output;
  Sample2LUTsUpgradeToneMap(bt709_tonemapped, lut_sampler1, lut_sampler2, lut_texture1, lut_texture2, linear_output.r, linear_output.g, linear_output.b, cb_config);

  float3 scaled = cb_config.ue_colorscale.xyz * (((cb_config.ue_mappingpolynomial.y + (cb_config.ue_mappingpolynomial.x * linear_output)) * linear_output) + cb_config.ue_mappingpolynomial.z);

  float3 output = ((cb_config.ue_overlaycolor.xyz - scaled) * cb_config.ue_overlaycolor.w) + scaled;

  bool is_linear = (outputdevice == 8u || outputdevice == 9u);
  if (is_linear) {
    return ProcessOutputDevice89(untonemapped_ap1, output, outputdevice, cb_config);
  }

  return GenerateOutput(output.xyz, untonemapped_ap1, SV_Target, outputdevice);
}

// 3 SDR Luts

float4 ProcessLutbuilder(float3 untonemapped_ap1, SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, UECbufferConfig cb_config, float4 SV_Target, uint outputdevice) {
  float3 tonemapped;

  ApplyFilmToneMapWithBlueCorrect(untonemapped_ap1, tonemapped, cb_config);

  float3 bt709_tonemapped = renodx::color::bt709::from::AP1(tonemapped);

  float3 linear_output;
  Sample3LUTsUpgradeToneMap(bt709_tonemapped, lut_sampler1, lut_sampler2, lut_sampler3, lut_texture1, lut_texture2, lut_texture3, linear_output.r, linear_output.g, linear_output.b, cb_config);

  float3 scaled = cb_config.ue_colorscale.xyz * (((cb_config.ue_mappingpolynomial.y + (cb_config.ue_mappingpolynomial.x * linear_output)) * linear_output) + cb_config.ue_mappingpolynomial.z);

  float3 output = ((cb_config.ue_overlaycolor.xyz - scaled) * cb_config.ue_overlaycolor.w) + scaled;

  bool is_linear = (outputdevice == 8u || outputdevice == 9u);
  if (is_linear) {
    return ProcessOutputDevice89(untonemapped_ap1, output, outputdevice, cb_config);
  }

  return GenerateOutput(output.xyz, untonemapped_ap1, SV_Target, outputdevice);
}

// 4 SDR luts

float4 ProcessLutbuilder(float3 untonemapped_ap1, SamplerState lut_sampler1, SamplerState lut_sampler2, SamplerState lut_sampler3, SamplerState lut_sampler4, Texture2D<float4> lut_texture1, Texture2D<float4> lut_texture2, Texture2D<float4> lut_texture3, Texture2D<float4> lut_texture4, UECbufferConfig cb_config, float4 SV_Target, uint outputdevice) {
  float3 tonemapped;

  ApplyFilmToneMapWithBlueCorrect(untonemapped_ap1, tonemapped, cb_config);

  float3 bt709_tonemapped = renodx::color::bt709::from::AP1(tonemapped);

  float3 linear_output;
  Sample4LUTsUpgradeToneMap(bt709_tonemapped, lut_sampler1, lut_sampler2, lut_sampler3, lut_sampler4, lut_texture1, lut_texture2, lut_texture3, lut_texture4, linear_output.r, linear_output.g, linear_output.b, cb_config);

  float3 scaled = cb_config.ue_colorscale.xyz * (((cb_config.ue_mappingpolynomial.y + (cb_config.ue_mappingpolynomial.x * linear_output)) * linear_output) + cb_config.ue_mappingpolynomial.z);

  float3 output = ((cb_config.ue_overlaycolor.xyz - scaled) * cb_config.ue_overlaycolor.w) + scaled;

  bool is_linear = (outputdevice == 8u || outputdevice == 9u);
  if (is_linear) {
    return ProcessOutputDevice89(untonemapped_ap1, output, outputdevice, cb_config);
  }

  return GenerateOutput(output.xyz, untonemapped_ap1, SV_Target, outputdevice);
}
