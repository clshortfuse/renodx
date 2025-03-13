#include "./common.hlsl"

SamplerState RenderMapPointSampler_s : register(s1);
Texture2D<float4> RenderMapPointSampler : register(t1);

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    float4 v2: COLOR0,
    out float4 o0: SV_Target0) {
  float4 r0;

  r0.xyz = RenderMapPointSampler.Sample(RenderMapPointSampler_s, v1.xy).xyz;
  o0.xyz = v2.xyz * r0.xyz;
  o0.w = v2.w;

  o0.rgb = PostFXScale(o0.rgb);
  return;
}
