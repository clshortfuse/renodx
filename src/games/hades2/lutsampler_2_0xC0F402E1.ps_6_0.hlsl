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
    float max_channel = max(max(max(input_color.r, input_color.g), input_color.b), 1.f);
    _19 /= max_channel;
    float grayscale = renodx::color::y::from::BT709(_19.rgb);
    float lowest_negative_channel = min(0.f, min(_19.r, min(_19.g, _19.b)));
    float distance = grayscale - lowest_negative_channel;
    float ratio = renodx::math::DivideSafe(-lowest_negative_channel, distance, 0.f);
    _19.rgb = lerp(grayscale, _19.rgb, 1.f - ratio);

    _29 = PrevColorGradingLUT.Sample(Sampler, float3((_18 + (_16 * _19.x)), (_18 + (_16 * _19.y)), (_18 + (_16 * _19.z))));
    _29.rgb = lerp(renodx::color::y::from::BT709(_29.rgb), _29.rgb, 1.f + ratio);
    _29.rgb *= max_channel;

    _40 = ColorGradingLUT.Sample(Sampler, float3((_13 + (_11 * _19.x)), (_13 + (_11 * _19.y)), (_13 + (_11 * _19.z))));
    _40.rgb = lerp(renodx::color::y::from::BT709(_40.rgb), _40.rgb, 1.f + ratio);
    _40.rgb *= max_channel;
  }
  SV_Target.x = (_29.x + (Lerp * (_40.x - _29.x)));
  SV_Target.y = (_29.y + (Lerp * (_40.y - _29.y)));
  SV_Target.z = (_29.z + (Lerp * (_40.z - _29.z)));
  SV_Target.w = (_29.w + (Lerp * (_40.w - _29.w)));
  return SV_Target;
}
