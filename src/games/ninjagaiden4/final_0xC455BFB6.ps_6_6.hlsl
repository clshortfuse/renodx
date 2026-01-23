#include "./include/CBuffers.hlsl"
#include "./shared.h"

Texture2D<float4> texture0 : register(t0);

SamplerState samplerState0 : register(s0);

float4 main(noperspective float4 SV_Position: SV_Position,
            linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 output = 0;

  output = texture0.Sample(samplerState0, TEXCOORD);

  if (hdrEnabled) {

    [branch]
    if (RENODX_TONE_MAP_TYPE) {
      output.xyz = renodx::draw::SwapChainPass(output.rgb);
    } else {
      output.rgb = renodx::color::bt2020::from::BT709(output.rgb);
      output.rgb = renodx::color::pq::Encode(output.rgb, nits);
    }
    
  } else {
    // Prevent division by zero with a small epsilon
    float safeGamma = max(sdrGamma, 0.0001f);
    output.xyz = pow(output.xyz, 1.f / safeGamma);
  }

  return output;
}
