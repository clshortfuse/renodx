#include "./common.hlsli"

float3 ColorScale : register(c0);
float InverseGamma : register(c5);
float4 OverlayColor : register(c4);
sampler2D SceneColorTexture : register(s0);

float4 main(float2 texcoord: TEXCOORD)
    : COLOR {
  float4 o;

  float4 r0;
  float3 r1;
  float3 r2;
  r0 = tex2D(SceneColorTexture, texcoord);

  float3 input = r0.rgb;

  r0.rgb = lerp(r0.xyz * ColorScale.xyz, OverlayColor.xyz, OverlayColor.w);

  r0.xyz = ConditionalSaturate(r0.rgb);
  r1.xyz = ConditionalClipShadows(r0.xyz);  // max(r0.xyz, 0.0001);

  float3 linear_color = r1.rgb;
  o.rgb = renodx::math::SignPow(linear_color, InverseGamma.x);
  o.w = 1;

  o.rgb = saturate(o.rgb);  // clamp to prevent flashbang
  o.rgb = ApplyToneMap(o.rgb, texcoord, SceneColorTexture, false);

  return o;
}
