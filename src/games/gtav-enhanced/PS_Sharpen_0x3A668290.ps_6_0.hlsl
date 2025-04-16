#include "./shared.h"

Texture2D<float4> t12_space1 : register(t12, space1);

cbuffer cb9_space1 : register(b9, space1) {
  float4 SharpenParams_000 : packoffset(c000.x);
};

SamplerState s1_space1 : register(s1, space1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _9 = t12_space1.Sample(s1_space1, float2(TEXCOORD.x, (TEXCOORD.y - SharpenParams_000.z)));
  float4 _17 = t12_space1.Sample(s1_space1, float2((TEXCOORD.x - SharpenParams_000.y), TEXCOORD.y));
  float4 _22 = t12_space1.Sample(s1_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _30 = t12_space1.Sample(s1_space1, float2((SharpenParams_000.y + TEXCOORD.x), TEXCOORD.y));
  float4 _38 = t12_space1.Sample(s1_space1, float2(TEXCOORD.x, (SharpenParams_000.z + TEXCOORD.y)));

  // Move to BT2020 to retain colorspace
  _9.rgb = renodx::color::bt2020::from::BT709(_9.rgb);
  _17.rgb = renodx::color::bt2020::from::BT709(_17.rgb);
  _22.rgb = renodx::color::bt2020::from::BT709(_22.rgb);
  _30.rgb = renodx::color::bt2020::from::BT709(_30.rgb);
  _38.rgb = renodx::color::bt2020::from::BT709(_38.rgb);

  SV_Target.x = max((((((((-0.0f - _9.x) - _17.x) + (_22.x * 4.0f)) - _30.x) - _38.x) * SharpenParams_000.x) + _22.x), 0.0f);
  SV_Target.y = max((((((((-0.0f - _9.y) - _17.y) + (_22.y * 4.0f)) - _30.y) - _38.y) * SharpenParams_000.x) + _22.y), 0.0f);
  SV_Target.z = max((((((((-0.0f - _9.z) - _17.z) + (_22.z * 4.0f)) - _30.z) - _38.z) * SharpenParams_000.x) + _22.z), 0.0f);
  SV_Target.w = max((((((((-0.0f - _9.w) - _17.w) + (_22.w * 4.0f)) - _30.w) - _38.w) * SharpenParams_000.x) + _22.w), 0.0f);

  SV_Target.rgb = renodx::color::bt709::from::BT2020(SV_Target.rgb);

  return SV_Target;
}
