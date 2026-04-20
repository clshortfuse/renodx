#include "./common.hlsli"

sampler2D s0 : register(s0);
float4 g_ConstColor : register(c128);
float4 g_ConstColorAdd : register(c129);

struct PS_INPUT {
  float2 texcoord : TEXCOORD0;
};

float4 main(PS_INPUT i) : COLOR {
  float4 sample0 = tex2D(s0, i.texcoord);
  float4 output = mad(sample0, g_ConstColor, g_ConstColorAdd);
  output.rgb = ScaleUiBrightness(output.rgb);
  return output;
}
