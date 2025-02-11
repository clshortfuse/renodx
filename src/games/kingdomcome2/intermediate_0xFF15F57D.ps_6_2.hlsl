#include "./common.hlsl"

Texture2D<float4> Tx2Tx_Source : register(t0);

SamplerState Tx2Tx_Sampler : register(s1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _5 = Tx2Tx_Source.Sample(Tx2Tx_Sampler, float2((TEXCOORD.x), (TEXCOORD.y)));

  SV_Target.x = (_5.x);
  SV_Target.y = (_5.y);
  SV_Target.z = (_5.z);
  SV_Target.w = (_5.w);
  return SV_Target;
}
