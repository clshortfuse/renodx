#include "./common.hlsl"

SamplerState yTextureSampler_s : register(s0);
SamplerState crTextureSampler_s : register(s1);
SamplerState cbTextureSampler_s : register(s2);
Texture2D<float4> yTexture : register(t0);
Texture2D<float4> crTexture : register(t1);
Texture2D<float4> cbTexture : register(t2);

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.y = crTexture.Sample(crTextureSampler_s, v1.xy).x;
  r0.z = cbTexture.Sample(cbTextureSampler_s, v1.xy).x;
  r0.x = yTexture.Sample(yTextureSampler_s, v1.xy).x;
  r0.w = 1;
  r1.y = saturate(dot(r0.xyzw, float4(1.16412354, -0.813476563, -0.391448975, 0.529705048)));
  r1.x = saturate(dot(r0.xyw, float3(1.16412354, 1.59579468, -0.87065506)));
  r1.z = saturate(dot(r0.xzw, float3(1.16412354, 2.01782227, -1.08166885)));
  //r1.rgb = InverseToneMap(r1.rgb);
  r0.xyz = log2(r1.xyz);
  r0.xyz = float3(2.20000005,2.20000005,2.20000005) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  //o0.rgb = renodx::color::gamma::DecodeSafe(r1.rgb, 2.2f);
  //o0.rgb = r1.rgb;
  o0.w = 0;
  return;
}
