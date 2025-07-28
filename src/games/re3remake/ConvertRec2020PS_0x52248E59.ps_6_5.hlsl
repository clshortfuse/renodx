#include "./common.hlsli"

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
  float3 bt709Color = tLinearImage.SampleLevel(PointBorder, TEXCOORD.xy, 0.0f).rgb;
#if 0
  bt709Color = renodx::color::correct::GammaSafe(bt709Color);
#else
  bt709Color = GammaCorrectHuePreserving(bt709Color);
#endif

  float3 bt2020Color = max(0.f, renodx::color::bt2020::from::BT709(bt709Color.rgb));

#if 1
  const float diffuse_nits = whitePaperNits;
  const float peak_nits = max(displayMaxNits, whitePaperNits);
  const float rolloff_start = peak_nits * 0.33f;
  const float rolloff_modulation = 1.33f;
  bt2020Color = exp2(ExponentialRollOff(log2(bt2020Color * diffuse_nits), log2(rolloff_start), log2(peak_nits), rolloff_modulation)) / diffuse_nits;
#endif

  float3 pqColor = renodx::color::pq::Encode(bt2020Color, whitePaperNits);

  return float4(pqColor, 1.0);
}
