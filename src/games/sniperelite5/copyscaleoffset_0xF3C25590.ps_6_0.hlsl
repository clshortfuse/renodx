#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

cbuffer ScaleAndOffsetConsts : register(b0) {
  float4 g_xScaleAndOffset : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float _9 = g_xScaleAndOffset.x * SV_Position.x;
  float _10 = g_xScaleAndOffset.y * SV_Position.y;
  float _13 = _9 + g_xScaleAndOffset.z;
  float _14 = _10 + g_xScaleAndOffset.w;
  float4 _15 = g_xTexture.Sample(g_xBilinearClamp, float2(_13, _14));
  // RenoDX: encode with the shared intermediate pass (replaces the manual sRGB encode below)
  float3 encoded = renodx::draw::RenderIntermediatePass(_15.rgb);
  return float4(encoded, _15.w);
  // bool _20 = (_15.x > 0.0031308000907301903f);
  // bool _21 = (_15.y > 0.0031308000907301903f);
  // bool _22 = (_15.z > 0.0031308000907301903f);
  // float _23 = select(_20, 0.0f, 1.0f);
  // float _24 = select(_21, 0.0f, 1.0f);
  // float _25 = select(_22, 0.0f, 1.0f);
  // float _26 = _15.x * 12.920000076293945f;
  // float _27 = _15.y * 12.920000076293945f;
  // float _28 = _15.z * 12.920000076293945f;
  // float _29 = abs(_15.x);
  // float _30 = abs(_15.y);
  // float _31 = abs(_15.z);
  // float _32 = log2(_29);
  // float _33 = log2(_30);
  // float _34 = log2(_31);
  // float _35 = _32 * 0.4166666567325592f;
  // float _36 = _33 * 0.4166666567325592f;
  // float _37 = _34 * 0.4166666567325592f;
  // float _38 = exp2(_35);
  // float _39 = exp2(_36);
  // float _40 = exp2(_37);
  // float _41 = _38 * 1.0549999475479126f;
  // float _42 = _39 * 1.0549999475479126f;
  // float _43 = _40 * 1.0549999475479126f;
  // float _44 = _41 + -0.054999999701976776f;
  // float _45 = _42 + -0.054999999701976776f;
  // float _46 = _43 + -0.054999999701976776f;
  // float _47 = _26 - _44;
  // float _48 = _27 - _45;
  // float _49 = _28 - _46;
  // float _50 = _47 * _23;
  // float _51 = _48 * _24;
  // float _52 = _49 * _25;
  // float _53 = _50 + _44;
  // float _54 = _51 + _45;
  // float _55 = _52 + _46;
  // SV_Target.x = _53;
  // SV_Target.y = _54;
  // SV_Target.z = _55;
  // SV_Target.w = _15.w;
  // return SV_Target;
}
