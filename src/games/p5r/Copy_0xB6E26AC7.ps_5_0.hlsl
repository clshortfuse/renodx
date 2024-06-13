SamplerState diffuseSampler_s : register(s0);
Texture2D<float4> diffuseTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  o0 = diffuseTexture.Sample(diffuseSampler_s, v1.xy);

  return;
}