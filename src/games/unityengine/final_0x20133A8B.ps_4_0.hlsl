#include "./shared.h"

SamplerState BlitSampler_s : register(s0);
Texture2D<float4> BlitTexture : register(t0);

float3 FinalizeOutput(float3 color, bool gamma) {
  [branch]
  if (injectedData.toneMapGammaCorrection == 2.f) {
    color = gamma ? renodx::color::gamma::DecodeSafe(color, 2.4f) : renodx::color::correct::GammaSafe(color, false, 2.4f);
  } else if (injectedData.toneMapGammaCorrection == 1.f) {
    color = gamma ? renodx::color::gamma::DecodeSafe(color, 2.2f) : renodx::color::correct::GammaSafe(color, false, 2.2f);
  } else {
    color = gamma ? renodx::color::srgb::DecodeSafe(color) : color;
  }
  color *= injectedData.toneMapUINits;
  [branch]
  if (injectedData.colorGradeColorSpace == 1.f) {
    color = renodx::color::bt709::from::BT709D93(color);
  } else if (injectedData.colorGradeColorSpace == 2.f) {
    color = renodx::color::bt709::from::ARIBTRB9(color);
  } else if (injectedData.colorGradeColorSpace == 3.f) {
    color = renodx::color::bt709::from::ARIBTRB927MPCD(color);
  } else if (injectedData.colorGradeColorSpace == 4.f) {
    color = renodx::color::bt709::from::BT601NTSCU(color);
  }
  [branch]
  if (injectedData.toneMapType == 0.f) {
    color = renodx::color::bt709::clamp::BT709(color);
    color = min(injectedData.toneMapGameNits, color);
  } else if(injectedData.toneMapType >= 2.f) {
    color = renodx::color::bt709::clamp::BT2020(color);
    color = min(injectedData.toneMapPeakNits, color);
    /*color = renodx::color::bt709::clamp::AP1(color);
    color = renodx::color::bt2020::from::BT709(color);
    float grayscale = renodx::color::y::from::BT2020(color);
    const float MID_GRAY_LINEAR = 1 / (pow(10, 0.75));                          // ~0.18f
    const float MID_GRAY_PERCENT = 0.5f;                                        // 50%
    const float MID_GRAY_GAMMA = log(MID_GRAY_LINEAR) / log(MID_GRAY_PERCENT);  // ~2.49f
    float encode_gamma = MID_GRAY_GAMMA;
    float3 encoded = renodx::color::gamma::EncodeSafe(color, encode_gamma);
    float encoded_gray = renodx::color::gamma::Encode(grayscale, encode_gamma);
    float3 compressed = renodx::color::correct::GamutCompress(encoded, encoded_gray);
    color = renodx::color::gamma::DecodeSafe(compressed, encode_gamma);
    color = renodx::color::bt709::from::BT2020(color);
    float max_channel = max(max(max(color.r, color.g), color.b), injectedData.toneMapPeakNits);
    color *= injectedData.toneMapPeakNits / max_channel;  // Clamp UI or Videos*/
  }
  [branch]
  if(injectedData.processing_use_scrgb == 0.f){
    color = renodx::color::bt2020::from::BT709(color);
    color = renodx::color::pq::EncodeSafe(color, 1.f);
  } else {
    color /= 80.f;
  }
  return color;
}

void main(
    float2 v0: TEXCOORD0,
    float4 v1: SV_POSITION0,
    out float4 o0: SV_Target0) {
  o0.xyzw = BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw;
  if (injectedData.swapchainProxy == 0.f) {
    o0.rgb = FinalizeOutput(o0.rgb, injectedData.gammaSpace != 0.f);
  }
  return;
}
