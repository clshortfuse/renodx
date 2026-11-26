#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

cbuffer GammaAndClampConsts : register(b0) {
  float g_fLinearGamma : packoffset(c000.x);
  float g_fClampValue : packoffset(c000.y);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 _9 = g_xTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: pass the sampled input straight through; vanilla math kept below for reference
  return float4(_9.rgb, 1.0f);
  // float4 SV_Target;
  // float _13 = abs(_9.x);
  // float _14 = abs(_9.y);
  // float _15 = abs(_9.z);
  // float _16 = log2(_13);
  // float _17 = log2(_14);
  // float _18 = log2(_15);
  // float _19 = _16 * g_fLinearGamma;
  // float _20 = _17 * g_fLinearGamma;
  // float _21 = _18 * g_fLinearGamma;
  // float _22 = exp2(_19);
  // float _23 = exp2(_20);
  // float _24 = exp2(_21);
  // float _25 = max(_22, g_fClampValue);
  // float _26 = max(_23, g_fClampValue);
  // float _27 = max(_24, g_fClampValue);
  // float _28 = max(1.0f, g_fClampValue);
  // SV_Target.x = _25;
  // SV_Target.y = _26;
  // SV_Target.z = _27;
  // SV_Target.w = _28;
  // return SV_Target;
}
