#include "./ui.hlsli"

cbuffer cbSurfRideFp : register(b0) {
  float4 g_TexColorOffset : packoffset(c0);
  float4 g_SdfParam : packoffset(c1);
}

SamplerState sprite_sampler : register(s0);
Texture2D<float4> sprite_texture : register(t0);

float4 main(float4 position : SV_POSITION, float4 multiply : COLOR0,
            float4 add : COLOR1, float4 uv : TEXCOORD0) : SV_TARGET {
  float4 color = sprite_texture.Sample(sprite_sampler, uv.xy);
  color.a = saturate(g_TexColorOffset.a + color.a);
  return ApplyUIBrightness(color * multiply + add);
}
