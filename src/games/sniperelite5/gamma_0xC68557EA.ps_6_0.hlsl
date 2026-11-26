#include "./shared.h"

Texture2D<float4> g_xTexture : register(t0);

cbuffer GammaConsts : register(b0) {
  float g_fGamma : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _8 = g_xTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: pass the linear HDR input straight through; vanilla gamma/sRGB kept below for reference
  if (g_fGamma == 1.0f) {
    return float4(_8.rgb, 1.0f);
  }
  float3 linear_color = renodx::draw::InvertIntermediatePass(_8.rgb);
  linear_color = select(and(linear_color > 0.0f, linear_color < 1.0f), pow(linear_color, g_fGamma), linear_color);
  return float4(renodx::draw::RenderIntermediatePass(linear_color), 1.0f);
  // float _21 = exp2(log2(abs(_8.x)) * g_fGamma);
  // float _22 = exp2(log2(abs(_8.y)) * g_fGamma);
  // float _23 = exp2(log2(abs(_8.z)) * g_fGamma);
  // float _48 = (exp2(log2(abs(_21)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
  // float _49 = (exp2(log2(abs(_22)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
  // float _50 = (exp2(log2(abs(_23)) * 0.4166666567325592f) * 1.0549999475479126f) + -0.054999999701976776f;
  // SV_Target.x = ((((_21 * 12.920000076293945f) - _48) * select((_21 > 0.0031308000907301903f), 0.0f, 1.0f)) + _48);
  // SV_Target.y = ((((_22 * 12.920000076293945f) - _49) * select((_22 > 0.0031308000907301903f), 0.0f, 1.0f)) + _49);
  // SV_Target.z = ((((_23 * 12.920000076293945f) - _50) * select((_23 > 0.0031308000907301903f), 0.0f, 1.0f)) + _50);
  // SV_Target.w = 1.0f;
  // return SV_Target;
}
