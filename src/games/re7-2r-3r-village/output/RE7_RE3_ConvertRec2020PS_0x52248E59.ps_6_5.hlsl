#include "../common.hlsli"

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
  const float diffuse_white = whitePaperNits;

  float3 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f).rgb;
#if GAMMA_CORRECTION
  bt709Color = GammaCorrectHuePreserving(bt709Color);
#endif

  float3 bt2020Color = max(0.f, renodx::color::bt2020::from::BT709(bt709Color.rgb));

#if 1
  bt2020Color = ApplyDisplayMap(bt2020Color, diffuse_white, displayMaxNits);
#endif

  float3 pqColor = renodx::color::pq::Encode(bt2020Color, diffuse_white);

  return float4(pqColor, 1.0);
}
