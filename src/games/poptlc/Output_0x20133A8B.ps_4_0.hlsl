#include "./shared.h"

SamplerState BlitSampler_s : register(s0);
Texture2D<float4> BlitTexture : register(t0);

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  out float4 outColor : SV_Target0)
{
  outColor.xyzw = BlitTexture.Sample(BlitSampler_s, v0.xy).xyzw;
  
  // fix mismatch
  if (injectedData.fixGammaMismatch) {
    float3 colInExcess = outColor.rgb - saturate(outColor.rgb);
    outColor.rgb = pow(renodx::color::srgb::from::BT709(saturate(outColor.rgb)), 2.2);
    outColor.rgb += colInExcess;
  }

  outColor.rgb *= injectedData.toneMapGameNits / 80.f;
  return;
}