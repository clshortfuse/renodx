#include "./shared.h"
#include "./DICE.hlsl"

cbuffer ConstBuf__passData : register(b0)
{
  struct GammaAdjustPassData
  {
    float gamma;
  } resourceTables__passData;
}

Texture2D<float4> inputTexture : register(t0);


void main
(
  in  float4 SV_POSITION : SV_POSITION,
  in  float2 TEXCOORD0   : TEXCOORD0,
  in  float2 TEXCOORD1   : TEXCOORD1,
  out float4 SV_TARGET0  : SV_TARGET0
)
{
  uint3 positionAsUint = uint3(uint2(SV_POSITION.xy), 0u);
  
  float4 inputColor = inputTexture.Load(positionAsUint);
  
  SV_TARGET0 = float4(pow(inputColor.rgb, resourceTables__passData.gamma), inputColor.a);
  
  if (injectedData.toneMapType) {
    // PQ to BT.2020 for paper white scaling 
    SV_TARGET0.rgb = renodx::color::bt2020::from::PQ(SV_TARGET0.rgb);
    SV_TARGET0.rgb *= injectedData.toneMapGameNits/310.f;

    // tonemap
    SV_TARGET0.rgb = renodx::color::bt709::from::BT2020(SV_TARGET0.rgb * 10000.f);
    float3 untonemapped = SV_TARGET0.rgb;
    DICESettings config = DefaultDICESettings();
    config.Type = 3u;
    config.ShoulderStart = 0.5f;
    SV_TARGET0.rgb = DICETonemap(SV_TARGET0.rgb, injectedData.toneMapPeakNits, config);
    SV_TARGET0.rgb = renodx::color::bt2020::from::BT709(SV_TARGET0.rgb / 10000.f);
    // end tonemap

    SV_TARGET0.rgb = renodx::color::pq::from::BT2020(SV_TARGET0.rgb);
  }


}
