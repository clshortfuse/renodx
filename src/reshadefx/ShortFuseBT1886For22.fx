#include "ReShade.fxh"

float3 main(float4 pos : SV_Position, float2 texcoord : TexCoord) : COLOR {
  float3 inputColor = tex2D(ReShade::BackBuffer, texcoord).rgb;
  if (BUFFER_COLOR_SPACE > 1) return inputColor; // Skip HDR
  return inputColor = pow(inputColor, 2.4f/2.2f);
}

technique ShortFuseBT1886For22 {
  pass {
    VertexShader = PostProcessVS;
    PixelShader = main;
  }
}
