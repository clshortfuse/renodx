#ifndef CODWAW_PARTICLE_HDR_HLSL
#define CODWAW_PARTICLE_HDR_HLSL
float WaWSafePositive(float v) {
  return (v == v) ? min(max(v, 0.0f), 65504.0f) : 0.0f;
}
float3 WaWSafePositive(float3 v) {
  return float3(WaWSafePositive(v.r), WaWSafePositive(v.g), WaWSafePositive(v.b));
}
float WaWSafeAlpha(float v) {
  return (v == v) ? saturate(v) : 0.0f;
}
sampler2D colorMapSampler : register(s0);
#ifdef WAW_SOFT_PARTICLE
sampler2D floatZSampler : register(s4);
float4 featherParms : register(c5);
#endif
struct PixelInput {
  float4 color : COLOR0;
  float3 texCoord : TEXCOORD0;
#ifdef WAW_SOFT_PARTICLE
  float4 depthCoord : TEXCOORD1;
#endif
};
float4 main(PixelInput input) : COLOR0 {
  float4 sampleColor = tex2D(colorMapSampler, input.texCoord.xy);
  float alpha = WaWSafeAlpha(sampleColor.a) * WaWSafeAlpha(input.color.a);
#ifdef WAW_SOFT_PARTICLE
  float depth = tex2Dproj(floatZSampler, input.depthCoord).x;
  alpha *= WaWSafeAlpha((abs(depth) - input.texCoord.z) * featherParms.x);
#endif
  float3 rgb = WaWSafePositive(WaWSafePositive(sampleColor.rgb) * WaWSafePositive(input.color.rgb));
#ifndef WAW_STRAIGHT_ALPHA
  rgb *= alpha;
#endif
  return float4(rgb, alpha);
}
#endif
