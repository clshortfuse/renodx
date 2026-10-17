#include "./shared.h"
Texture2D<float3> sceneTexture : register(t0);

Texture2D<float4> overlayTexture : register(t1);

SamplerState sceneSampler : register(s0);

SamplerState overlaySampler : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float3 _7 = sceneTexture.Sample(sceneSampler, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _11 = overlayTexture.Sample(overlaySampler, float2(TEXCOORD.x, TEXCOORD.y));
  float _20 = (_11.w * _7.x) + _11.x;
  float _21 = (_11.w * _7.y) + _11.y;
  float _22 = (_11.w * _7.z) + _11.z;

  // SV_Target.x = select((_20 < 0.0031308000907301903f), (_20 * 12.920000076293945f), (((pow(_20, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  // SV_Target.y = select((_21 < 0.0031308000907301903f), (_21 * 12.920000076293945f), (((pow(_21, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  // SV_Target.z = select((_22 < 0.0031308000907301903f), (_22 * 12.920000076293945f), (((pow(_22, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  SV_Target.x = _20;
  SV_Target.y = _21;
  SV_Target.z = _22;
  SV_Target.w = (1.0f - _11.w);

  SV_Target.rgb = renodx::draw::SwapChainPass(SV_Target.rgb);
  return SV_Target;
}
