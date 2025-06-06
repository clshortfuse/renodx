#include "../common.hlsl"

Texture2D<float4> g_Texture0 : register(t0);

SamplerState s_Sampler0 : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float4 TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _9 = g_Texture0.Sample(s_Sampler0, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  
  SV_Target.x = (_9.x * TEXCOORD.x);
  SV_Target.y = (_9.y * TEXCOORD.y);
  SV_Target.z = (_9.z * TEXCOORD.z);
  SV_Target.w = (saturate(_9.w + max((((_9.y + -0.3529411852359772f) + _9.x) + _9.z), 0.0f)) * TEXCOORD.w);

  return SV_Target;
}
