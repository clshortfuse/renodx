#include "./ui.hlsli"

SamplerState sprite_sampler : register(s0);
SamplerState mask_sampler : register(s1);
Texture2D<float4> sprite_texture : register(t0);
Texture2D<float4> mask_texture : register(t1);

float4 main(float4 position : SV_POSITION, float4 multiply : COLOR0,
            float4 add : COLOR1, float4 uv : TEXCOORD0) : SV_TARGET {
  float4 color = sprite_texture.Sample(sprite_sampler, uv.xy);
  color.a *= mask_texture.Sample(mask_sampler, uv.zw).r;
  return ApplyUIBrightness(color * multiply + add);
}
