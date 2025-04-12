#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

void main(
    float4 v0: SV_POSITION0,
    float4 v1: COLOR0,
    float4 v2: TEXCOORD0,
    float4 v3: TEXCOORD1,
    float4 v4: TEXCOORD2,
    out float4 o0: SV_Target0) {
  float4 r0, r1;

  // Quantize UI alpha to 8-bit precision
  r0.w = round(v1.w * 255.0) / 255.0;

  // Sample game scene and apply additive UI bias
  r1 = t0.Sample(s0_s, v2.xy);
  r1 += cb0[3];

  // Multiply sampled scene by UI color
  r0.xyz = v1.xyz;
  r0 *= r1;

  // Output final UI color with premultiplied alpha
  o0.rgb = r0.rgb * r0.w;
  o0.a = r0.w;

  o0.rgb = UIScale(o0.rgb);
}
