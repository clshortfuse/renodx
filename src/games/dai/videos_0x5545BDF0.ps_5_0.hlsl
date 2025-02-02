#include "./common.hlsl"

SamplerState yTextureSampler_s : register(s0);
SamplerState crTextureSampler_s : register(s1);
SamplerState cbTextureSampler_s : register(s2);
Texture2D<float4> yTexture : register(t0);
Texture2D<float4> crTexture : register(t1);
Texture2D<float4> cbTexture : register(t2);

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.w = 1;
  r1.y = crTexture.Sample(crTextureSampler_s, v2.xy).x;
  r1.z = cbTexture.Sample(cbTextureSampler_s, v2.xy).x;
  r1.x = yTexture.Sample(yTextureSampler_s, v2.xy).x;
  r1.w = 1;
  r0.y = dot(r1.xyzw, float4(1.16412354, -0.813476563, -0.391448975, 0.529705048));
  r0.x = dot(r1.xyw, float3(1.16412354, 1.59579468, -0.87065506));
  r0.z = dot(r1.xzw, float3(1.16412354, 2.01782227, -1.08166885));
  o0.xyzw = v1.xyzw * r0.xyzw;
  o0 = saturate(o0);
  o0.rgb = InverseToneMap(o0.rgb);
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
