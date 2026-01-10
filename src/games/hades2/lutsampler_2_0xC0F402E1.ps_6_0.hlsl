#include "./shared.h"

Texture2D<float4> Texture : register(t0, space2);

Texture3D<float4> ColorGradingLUT : register(t6, space1);

Texture3D<float4> PrevColorGradingLUT : register(t8, space1);

cbuffer ColorGradingv2 : register(b1, space1) {
  float PrevLUTSize : packoffset(c000.x);
  float LUTSize : packoffset(c000.y);
  float Lerp : packoffset(c000.z);
};

SamplerState Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 COLOR: COLOR,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _11 = (LUTSize + -1.0f) / LUTSize;
  float _13 = 1.0f / (LUTSize * 2.0f);
  float _16 = (PrevLUTSize + -1.0f) / PrevLUTSize;
  float _18 = 1.0f / (PrevLUTSize * 2.0f);
  float4 _19 = Texture.Sample(Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  // float4 _29 = PrevColorGradingLUT.Sample(Sampler, float3((_18 + (_16 * _19.x)), (_18 + (_16 * _19.y)), (_18 + (_16 * _19.z))));
  // float4 _40 = ColorGradingLUT.Sample(Sampler, float3((_13 + (_11 * _19.x)), (_13 + (_11 * _19.y)), (_13 + (_11 * _19.z))));
  float4 _29;
  float4 _40;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _19 = saturate(_19);
    _29 = PrevColorGradingLUT.Sample(Sampler, float3((_18 + (_16 * _19.x)), (_18 + (_16 * _19.y)), (_18 + (_16 * _19.z))));
    _40 = ColorGradingLUT.Sample(Sampler, float3((_13 + (_11 * _19.x)), (_13 + (_11 * _19.y)), (_13 + (_11 * _19.z))));
  } else {
    float3 input_color = _19.rgb;

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
    _19.rgb = renodx::color::srgb::EncodeSafe(linear_color);

    // Find max channel to normalize input to never be above 1
    float max_channel = max(max(max(_19.r, _19.g), _19.b), 1.f);
    _19 /= max_channel;

    // Perform sample
    _29 = PrevColorGradingLUT.Sample(Sampler, float3((_18 + (_16 * _19.x)), (_18 + (_16 * _19.y)), (_18 + (_16 * _19.z))));
    _29.rgb *= max_channel;

    linear_grayscale = renodx::color::convert::Luminance(linear_color, 0);
    linear_color = renodx::color::srgb::DecodeSafe(_29.rgb);
    encoded = renodx::color::gamma::EncodeSafe(linear_color, encode_gamma);
    encoded_grayscale = renodx::color::gamma::Encode(linear_grayscale, encode_gamma);
    float3 decompressed = renodx::color::correct::GamutDecompress(encoded, encoded_grayscale, compression_scale);
    _29.rgb = renodx::color::gamma::DecodeSafe(decompressed, encode_gamma);
    _29.rgb = renodx::color::srgb::EncodeSafe(_29.rgb);

    _40 = ColorGradingLUT.Sample(Sampler, float3((_13 + (_11 * _19.x)), (_13 + (_11 * _19.y)), (_13 + (_11 * _19.z))));
    _40.rgb *= max_channel;

    linear_grayscale = renodx::color::convert::Luminance(linear_color, 0);
    linear_color = renodx::color::srgb::DecodeSafe(_40.rgb);
    encoded = renodx::color::gamma::EncodeSafe(linear_color, encode_gamma);
    encoded_grayscale = renodx::color::gamma::Encode(linear_grayscale, encode_gamma);
    decompressed = renodx::color::correct::GamutDecompress(encoded, encoded_grayscale, compression_scale);
    _40.rgb = renodx::color::gamma::DecodeSafe(decompressed, encode_gamma);
    _40.rgb = renodx::color::srgb::EncodeSafe(_40.rgb);
  }
  SV_Target.x = (_29.x + (Lerp * (_40.x - _29.x)));
  SV_Target.y = (_29.y + (Lerp * (_40.y - _29.y)));
  SV_Target.z = (_29.z + (Lerp * (_40.z - _29.z)));
  SV_Target.w = (_29.w + (Lerp * (_40.w - _29.w)));
  return SV_Target;
}
