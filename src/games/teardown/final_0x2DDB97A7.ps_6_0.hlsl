#include "./common.hlsl"

Texture2D<float4> uMain : register(t16);
SamplerState MinMagMipNearestWrapEdge : register(s7);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _5 = uMain.Sample(MinMagMipNearestWrapEdge, float2(TEXCOORD.x, TEXCOORD.y));
  _5.rgb = FinalizeOutput(_5.rgb);
  SV_Target.x = _5.x;
  SV_Target.y = _5.y;
  SV_Target.z = _5.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
