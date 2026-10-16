#include "../common.hlsli"

float4 FinalizeUI(float4 color) {
  color = max(0, color);

  color.rgb = GammaDecode(color.rgb);
  color.rgb *= RENODX_INTERMEDIATE_SCALING;
  color.rgb = GammaEncode(color.rgb);

  return color;
}
