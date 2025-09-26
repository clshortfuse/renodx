#include "./shared.h"

Texture2D<float4> Texture : register(t0, space2);

Texture2D<float4> Base : register(t3, space1);

cbuffer BloomCombine : register(b1, space1) {
  float BloomIntensity : packoffset(c000.x);
  float BaseIntensity : packoffset(c000.y);
  float BloomSaturation : packoffset(c000.z);
  float BaseSaturation : packoffset(c000.w);
};

SamplerState Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 COLOR: COLOR,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _7 = Texture.Sample(Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _11 = Base.Sample(Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    float _17 = dot(float3(_7.x, _7.y, _7.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
    float _28 = BloomIntensity * (_17 + (BloomSaturation * (_7.x - _17)));
    float _29 = BloomIntensity * (_17 + (BloomSaturation * (_7.y - _17)));
    float _30 = BloomIntensity * (_17 + (BloomSaturation * (_7.z - _17)));
    float _32 = dot(float3(_11.x, _11.y, _11.z), float3(0.30000001192092896f, 0.5899999737739563f, 0.10999999940395355f));
    SV_Target.x = (_28 + ((_32 + (BaseSaturation * (_11.x - _32))) * ((1.0f - min(max(_28, 0.0f), 1.0f)) * BaseIntensity)));
    SV_Target.y = (_29 + ((_32 + (BaseSaturation * (_11.y - _32))) * ((1.0f - min(max(_29, 0.0f), 1.0f)) * BaseIntensity)));
    SV_Target.z = (_30 + ((_32 + (BaseSaturation * (_11.z - _32))) * ((1.0f - min(max(_30, 0.0f), 1.0f)) * BaseIntensity)));
  } else {
    // * `((b-a) * t) + a`        = `lerp(a, b, t)`
    float bloom_grayscale = renodx::color::y::from::BT709(_7.rgb);
    float3 bloom_saturated = lerp(bloom_grayscale, _7.rgb, BloomSaturation);
    float3 bloom_boosted = bloom_saturated * BloomIntensity;
    float3 base_grayscale = renodx::color::y::from::BT709(_11.rgb);
    float3 base_saturated = lerp(base_grayscale, _11.rgb, BaseSaturation);
    // Tries vanilla tries to balance between 0 and 1, just allow going over 1
    float3 base_boosted = base_saturated * 1.f * BaseIntensity;
    SV_Target.rgb = base_boosted + bloom_boosted * CUSTOM_BLOOM;
  }
  SV_Target.w = 1.0f;
  return SV_Target;
}
