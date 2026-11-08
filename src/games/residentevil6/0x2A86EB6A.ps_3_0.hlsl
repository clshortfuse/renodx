#include "./bloom.hlsli"

float4 CBHDRFactor__packed0 : register(c1);
float4 CBBloomFilter__packed0 : register(c2);
sampler2D SSPoint__tBaseMap : register(s0);

float4 main(float2 texcoord : TEXCOORD0) : COLOR0 {
  float4 packed = tex2D(SSPoint__tBaseMap, texcoord);
  // The two preceding downsample passes store the normalization in alpha.
  float3 color = max(DecodeGameSRGB(packed.rgb) * (CBHDRFactor__packed0.w * CBHDRFactor__packed0.z)
      / max(packed.a, 1.e-6f), 0.f);
  float peak = UseSceneHDR() ? RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS : 1.f;
  return float4(ExtractGameBloom(color, CBBloomFilter__packed0.w, peak), 1.f);
}
