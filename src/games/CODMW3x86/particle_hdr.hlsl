#ifndef MW3_PARTICLE_HDR_HLSL
#define MW3_PARTICLE_HDR_HLSL
#include "bloom_hdr.hlsl"
sampler2D colorMapSampler : register(s0);
sampler2D floatZSampler : register(s4);
float4 featherParms : register(c3);
struct PixelInput {
  float4 color : COLOR0;
  float3 uv : TEXCOORD0;
  float4 depthCoord : TEXCOORD1;
};
float4 main(PixelInput input) : COLOR0 {
  float depth = tex2Dproj(floatZSampler, input.depthCoord).x;
  // MW3 uses abs(abs(depth) * c3.x - effectDepth), unlike WaW's feather.
  float feather = MW3Coverage(abs(abs(depth) * featherParms.x - input.uv.z));
  float4 sampled = tex2D(colorMapSampler, input.uv.xy);
  float alpha = MW3Coverage(sampled.a * input.color.a) * feather;
  float3 rgb = MW3Positive(sampled.rgb * input.color.rgb);
#ifdef MW3_PARTICLE_SQUARED
  rgb = MW3Positive(rgb * rgb);
#endif
#ifndef MW3_PARTICLE_STRAIGHT_ALPHA
  rgb *= alpha;
#endif
  return float4(rgb, alpha);
}
#endif
