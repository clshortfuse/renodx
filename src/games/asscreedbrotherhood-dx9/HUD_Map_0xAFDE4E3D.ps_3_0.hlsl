#include "./common.hlsli"

sampler2D BaseTexture_0 : register(s0);
sampler2D AlphaTexture_1 : register(s1);

float4 ConstantColor_2 : register(c128);
float4 ConstantTileRatio_9 : register(c129);
float4 ConstantTileOffset_11 : register(c130);

struct PS_INPUT {
  float2 texcoord : TEXCOORD0;
  float4 color : COLOR0;
};

float4 main(PS_INPUT i) : COLOR {
  float2 alpha_uv = float2(i.texcoord.x, 1.f - i.texcoord.y);
  alpha_uv = mad(alpha_uv, ConstantTileRatio_9.xy, ConstantTileOffset_11.xy);

  float4 alpha_sample = tex2D(AlphaTexture_1, alpha_uv);
  float4 base_sample = tex2D(BaseTexture_0, i.texcoord);
  base_sample.a *= alpha_sample.a;

  float4 color_scale = ConstantColor_2 * i.color;
  float4 output = base_sample * color_scale;
  output.rgb = ScaleUiBrightness(output.rgb);
  return output;
}
