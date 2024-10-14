#include "./DICE.hlsl"
#include "./shared.h"

cbuffer ConstBuf__passData : register(b0) {
  struct GammaAdjustPassData {
    float gamma;
  }
  resourceTables__passData;
}

Texture2D<float4> inputTexture : register(t0);

void main(
    in float4 SV_POSITION: SV_POSITION,
    in float2 TEXCOORD0: TEXCOORD0,
    in float2 TEXCOORD1: TEXCOORD1,
    out float4 SV_TARGET0: SV_TARGET0) {
  uint3 positionAsUint = uint3(uint2(SV_POSITION.xy), 0u);

  float4 inputColor = inputTexture.Load(positionAsUint);

  SV_TARGET0.a = inputColor.a;

  SV_TARGET0.rgb = renodx::color::bt2020::from::PQ(inputColor.rgb);
  SV_TARGET0.rgb = renodx::color::bt709::from::BT2020(SV_TARGET0.rgb / 80.f) * 10000.f;
  if (injectedData.toneMapType != 0) {
    SV_TARGET0.rgb *= injectedData.toneMapUINits / 306.f;
    if (injectedData.toneMapType > 1) {  // DICE tonemap
      DICESettings config = DefaultDICESettings();
      config.Type = 3u;
      config.ShoulderStart = 0.5f;
      SV_TARGET0.rgb = DICETonemap(SV_TARGET0.rgb, injectedData.toneMapPeakNits / 80.f, config);
    }
  }
}
