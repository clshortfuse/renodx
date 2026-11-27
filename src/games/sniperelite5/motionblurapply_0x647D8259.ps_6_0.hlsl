#include "./shared.h"

Texture2D<float4> g_xUserTexture0 : register(t3);

Texture2D<float4> g_xUserTexture1 : register(t4);

SamplerState g_xPointClamp : register(s1);

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = g_xUserTexture0.Sample(g_xPointClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _11 = g_xUserTexture1.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: motion blur strength slider scales the blend weight (saturates at 25%)
  float blend = _11.w * saturate(CUSTOM_MOTION_BLUR * 4.0f);
  SV_Target.x = (lerp(_7.x, _11.x, blend));
  SV_Target.y = (lerp(_7.y, _11.y, blend));
  SV_Target.z = (lerp(_7.z, _11.z, blend));
  SV_Target.w = 1.0f;
  return SV_Target;
}
