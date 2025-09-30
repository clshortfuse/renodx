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
    float max_channel = max(max(max(input_color.r, input_color.g), input_color.b), 1.f);
    _13 /= max_channel;
    float grayscale = renodx::color::y::from::BT709(_13.rgb);
    float lowest_negative_channel = min(0.f, min(_13.r, min(_13.g, _13.b)));
    float distance = grayscale - lowest_negative_channel;
    float ratio = renodx::math::DivideSafe(-lowest_negative_channel, distance, 0.f);
    _13.rgb = lerp(grayscale, _13.rgb, 1.f - ratio);
    _25 = ColorGradingLUT.Sample(Sampler, float3((_12 + (_10 * _13.x)), (_12 + (_10 * _13.y)), (_12 + (_10 * _13.z))));
    _25.rgb = lerp(renodx::color::y::from::BT709(_25.rgb), _25.rgb, 1.f + ratio);
    _25.rgb *= max_channel;
    _13.rgb = input_color;
  }
  SV_Target.x = (_13.x + (Lerp * (_25.x - _13.x)));
  SV_Target.y = (_13.y + (Lerp * (_25.y - _13.y)));
  SV_Target.z = (_13.z + (Lerp * (_25.z - _13.z)));
  SV_Target.w = (_13.w + (Lerp * (_25.w - _13.w)));
  return SV_Target;
}
