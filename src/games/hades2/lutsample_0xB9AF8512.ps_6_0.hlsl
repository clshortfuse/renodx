#include "./shared.h"

Texture2D<float4> Texture : register(t0, space2);

Texture3D<float4> ColorGradingLUT : register(t6, space1);

cbuffer ColorGrading : register(b1, space1) {
  float LUTSize : packoffset(c000.x);
  float Lerp : packoffset(c000.y);
};

SamplerState Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 COLOR: COLOR,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _10 = (LUTSize + -1.0f) / LUTSize;
  float _12 = 1.0f / (LUTSize * 2.0f);
  float4 _13 = Texture.Sample(Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  // float4 _25 = ColorGradingLUT.Sample(Sampler, float3((_12 + (_10 * _13.x)), (_12 + (_10 * _13.y)), (_12 + (_10 * _13.z))));
  float4 _25;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    _13 = saturate(_13);
    _25 = ColorGradingLUT.Sample(Sampler, float3((_12 + (_10 * _13.x)), (_12 + (_10 * _13.y)), (_12 + (_10 * _13.z))));
  } else {
    float3 input_color = _13.rgb;
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
    _13.rgb = renodx::color::srgb::EncodeSafe(linear_color);

    float max_channel = max(max(max(_13.r, _13.g), _13.b), 1.f);
    _13 /= max_channel;

    _25 = ColorGradingLUT.Sample(Sampler, float3((_12 + (_10 * _13.x)), (_12 + (_10 * _13.y)), (_12 + (_10 * _13.z))));
    _25.rgb *= max_channel;

    linear_grayscale = renodx::color::convert::Luminance(linear_color, 0);
    linear_color = renodx::color::srgb::DecodeSafe(_25.rgb);
    encoded = renodx::color::gamma::EncodeSafe(linear_color, encode_gamma);
    encoded_grayscale = renodx::color::gamma::Encode(linear_grayscale, encode_gamma);
    float3 decompressed = renodx::color::correct::GamutDecompress(encoded, encoded_grayscale, compression_scale);
    _25.rgb = renodx::color::gamma::DecodeSafe(decompressed, encode_gamma);
    _25.rgb = renodx::color::srgb::EncodeSafe(_25.rgb);

    _13.rgb = input_color;
  }
  SV_Target.x = (_13.x + (Lerp * (_25.x - _13.x)));
  SV_Target.y = (_13.y + (Lerp * (_25.y - _13.y)));
  SV_Target.z = (_13.z + (Lerp * (_25.z - _13.z)));
  SV_Target.w = (_13.w + (Lerp * (_25.w - _13.w)));
  return SV_Target;
}
