#include "./common.hlsl"

SamplerState _g_sSceneTexLinearClamp_s : register(s0);
Texture2D<float4> _TMP18 : register(t0);

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  r0 = applySharpen(_TMP18, _g_sSceneTexLinearClamp_s, v1, injectedData.fxSharpen);
  if (injectedData.fxFilmGrain > 0.f) {
    r0.rgb = applyFilmGrain(r0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(r0.rgb);
  o0.w = r0.w;
  return;
}