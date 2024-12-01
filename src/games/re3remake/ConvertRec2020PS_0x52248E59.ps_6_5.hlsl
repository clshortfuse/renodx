#include "./DICE.hlsl"
#include "./shared.h"

Texture2D<float4> tLinearImage : register(t0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float displayMaxNits : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_004x : packoffset(c004.x);
  float HDRMapping_004y : packoffset(c004.y);
};

SamplerState PointBorder : register(s2, space32);

float4 main(noperspective float4 SV_Position: SV_Position,
            linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f);

#if 1
  DICESettings config = DefaultDICESettings();
  config.Type = 3;
  config.ShoulderStart = 0.46f;
  const float dicePaperWhite = whitePaperNits / renodx::color::srgb::REFERENCE_WHITE;
  const float dicePeakWhite = max(displayMaxNits, whitePaperNits) / renodx::color::srgb::REFERENCE_WHITE;
  bt709Color.rgb = DICETonemap(bt709Color.rgb * dicePaperWhite, dicePeakWhite, config) / dicePaperWhite;
#endif

  float3 bt2020Color =
      renodx::color::bt2020::from::BT709(bt709Color.rgb);

  float3 pqColor = renodx::color::pq::Encode(bt2020Color, whitePaperNits);

  return float4(pqColor, 1.0);
}
