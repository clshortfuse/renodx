// Preserve native SDR bloom color and shape without extra HDR energy gain.
// Replaces the grayscale DEBUG_VIEW=2 mask without changing native bloom hue.
#include "bloom_hdr.hlsl"
sampler2D colorMapSampler : register(s0);
float4 glowSetup : register(c3);
float4 colorTintBase : register(c5);
float4 colorTintDelta : register(c6);
float4 colorTintQuadraticDelta : register(c7);
float4 colorBias : register(c8);
static const float3 LUMA = float3(0.299f, 0.587f, 0.114f);
struct PixelInput {
  float2 uv0 : TEXCOORD0;
  float2 uv1 : TEXCOORD1;
  float2 uv2 : TEXCOORD2;
  float2 uv3 : TEXCOORD3;
};
float3 ExtractBloom(float2 uv) {
  float3 hdrSource = MW3Positive(tex2D(colorMapSampler, uv).rgb);
  // The original UNORM source defines the game's SDR hue and tint response.
  float3 source = saturate(hdrSource);
  float luminance = dot(source, LUMA);

  float4 tint = colorTintBase + colorTintDelta * luminance;
  float3 gain = tint.rgb + colorTintQuadraticDelta.rgb * luminance * luminance;
  // Retain the original signed tint, bias and interpolation until RT clamping.
  float3 graded = lerp(source, luminance.xxx, tint.a) * gain + colorBias.rgb;
  float mask = MW3Coverage(luminance - glowSetup.x);
  return graded * mask;
}
float4 main(PixelInput input) : COLOR0 {

  float3 bloom = (ExtractBloom(input.uv1) + ExtractBloom(input.uv0)
                + ExtractBloom(input.uv2) + ExtractBloom(input.uv3)) * 0.25f;
  bloom *= glowSetup.y;
  bloom = lerp(bloom, dot(bloom, LUMA).xxx, glowSetup.w);
  // Exact SDR render-target color is the reference, including its clamp.
  float3 sdrBloom = saturate(bloom);
  // The extra HDR gain made broad highlights merge into blobs in some levels.
  return float4(MW3Positive(sdrBloom), 1.0f);
}
