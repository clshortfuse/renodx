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

  r1.xyz = r0.xyz * ColorScale.xyz;
  r2.xyz = ColorScale.xyz;
  r0.xyz = r0.xyz * -r2.xyz + OverlayColor.xyz;
  r0.xyz = ConditionalSaturate(OverlayColor.w * r0.xyz + r1.xyz);
  r1.xyz = ConditionalClipShadows(r0.xyz);  // max(r0.xyz, 0.0001);

  o.rgb = renodx::math::SignPow(r1.rgb, InverseGamma.x);
  o.w = 1;

  o.rgb = saturate(o.rgb);  // clamp to prevent flashbang
  o.rgb = ApplyToneMap(o.rgb, texcoord, false);

  return o;
}
