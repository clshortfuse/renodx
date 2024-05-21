#include "ReShade.fxh"

float srgbFromLinear(float channel) {
  return (channel <= 0.0031308f)
         ? (channel * 12.92f)
         : (1.055f * pow(channel, 1.f / 2.4f) - 0.055f);
}

float3 srgbFromLinear(float3 color) {
  return float3(
    srgbFromLinear(color.r),
    srgbFromLinear(color.g),
    srgbFromLinear(color.b)
  );
}

float3 main(float4 pos : SV_Position, float2 texcoord : TexCoord) : COLOR {
  float3 inputColor = tex2D(ReShade::BackBuffer, texcoord).rgb;
  if (BUFFER_COLOR_SPACE > 1) return inputColor; // Skip HDR
  float3 linearColor = pow(inputColor, 2.4f);
  float3 gammaColor = srgbFromLinear(linearColor);
  return gammaColor;
}

technique ShortFuseBT1886ForSRGB {
  pass {
    VertexShader = PostProcessVS;
    PixelShader = main;
  }
}
