#include "../shared.h"

Texture2D<float4> g_Color : register(t0);

Texture2D<float4> g_UI : register(t1);

cbuffer Constants : register(b0) {
  float2 g_UvScaleColor : packoffset(c000.x);
  float2 g_UvScaleUI : packoffset(c000.z);
  float2 g_UvOffsetUI : packoffset(c001.x);
  float2 g_Gamma : packoffset(c001.z);
  int g_IsInterpolated : packoffset(c002.x);
  int g_IsHdr : packoffset(c002.y);
  float2 g_HdrValues : packoffset(c002.z);
};

SamplerState g_Sampler : register(s0);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float _11 = g_UvScaleColor.x * TEXCOORD.x;
  float _12 = g_UvScaleColor.y * TEXCOORD.y;
  float _15 = g_UvScaleUI.x * TEXCOORD.x;
  float _16 = g_UvScaleUI.y * TEXCOORD.y;
  float _20 = _15 + g_UvOffsetUI.x;
  float _21 = _16 + g_UvOffsetUI.y;
  float4 _24 = g_Color.SampleLevel(g_Sampler, float2(_11, _12), 0.0f);
  float4 _29 = g_UI.SampleLevel(g_Sampler, float2(_20, _21), 0.0f);
  float _34 = 1.0f - _29.w;
  float _35 = _34 * _24.x;
  float _36 = _34 * _24.y;
  float _37 = _34 * _24.z;
  float _38 = _35 + _29.x;
  float _39 = _36 + _29.y;
  float _40 = _37 + _29.z;
  bool _43 = (g_IsHdr != 0);
  bool _46 = (g_HdrValues.x > 0.0f);
  bool _47 = _43 && _46;
  float _106;
  float _107;
  float _108;
  float _129;
  float _130;
  float _131;
  if (_47) {
    float _50 = log2(_38);
    float _51 = log2(_39);
    float _52 = log2(_40);
#if 1
    float _53 = _50 * RENODX_GAMMA_ADJUST_VALUE;
    float _54 = _51 * RENODX_GAMMA_ADJUST_VALUE;
    float _55 = _52 * RENODX_GAMMA_ADJUST_VALUE;
#else
    float _53 = _50 * g_HdrValues.x;
    float _54 = _51 * g_HdrValues.x;
    float _55 = _52 * g_HdrValues.x;
#endif
    float _56 = exp2(_53);
    float _57 = exp2(_54);
    float _58 = exp2(_55);
    float _59 = g_HdrValues.y * 9.999999747378752e-05f;
    float _60 = _56 * 0.6273999810218811f;
    float _61 = mad(0.3292999863624573f, _57, _60);
    float _62 = mad(0.043299999088048935f, _58, _61);
    float _63 = _56 * 0.06909999996423721f;
    float _64 = mad(0.9194999933242798f, _57, _63);
    float _65 = mad(0.01140000019222498f, _58, _64);
    float _66 = _56 * 0.01640000008046627f;
    float _67 = mad(0.08799999952316284f, _57, _66);
    float _68 = mad(0.8956000208854675f, _58, _67);
    float _69 = _62 * _59;
    float _70 = _65 * _59;
    float _71 = _68 * _59;
    float _72 = log2(_69);
    float _73 = log2(_70);
    float _74 = log2(_71);
    float _75 = _72 * 0.1593017578125f;
    float _76 = _73 * 0.1593017578125f;
    float _77 = _74 * 0.1593017578125f;
    float _78 = exp2(_75);
    float _79 = exp2(_76);
    float _80 = exp2(_77);
    float _81 = _78 * 18.8515625f;
    float _82 = _79 * 18.8515625f;
    float _83 = _80 * 18.8515625f;
    float _84 = _81 + 0.8359375f;
    float _85 = _82 + 0.8359375f;
    float _86 = _83 + 0.8359375f;
    float _87 = _78 * 18.6875f;
    float _88 = _79 * 18.6875f;
    float _89 = _80 * 18.6875f;
    float _90 = _87 + 1.0f;
    float _91 = _88 + 1.0f;
    float _92 = _89 + 1.0f;
    float _93 = _84 / _90;
    float _94 = _85 / _91;
    float _95 = _86 / _92;
    float _96 = log2(_93);
    float _97 = log2(_94);
    float _98 = log2(_95);
    float _99 = _96 * 78.84375f;
    float _100 = _97 * 78.84375f;
    float _101 = _98 * 78.84375f;
    float _102 = exp2(_99);
    float _103 = exp2(_100);
    float _104 = exp2(_101);
    _106 = _102;
    _107 = _103;
    _108 = _104;
  } else {
    _106 = _38;
    _107 = _39;
    _108 = _40;
  }
  float _111 = log2(_106);
  float _112 = log2(_107);
  float _113 = log2(_108);
  float _114 = _111 * g_Gamma.y;
  float _115 = _112 * g_Gamma.y;
  float _116 = _113 * g_Gamma.y;
  float _117 = exp2(_114);
  float _118 = exp2(_115);
  float _119 = exp2(_116);
  float _120 = _117 * g_Gamma.x;
  float _121 = _118 * g_Gamma.x;
  float _122 = _119 * g_Gamma.x;
  bool _123 = (g_IsHdr == 0);
  if (_123) {
    float _125 = saturate(_120);
    float _126 = saturate(_121);
    float _127 = saturate(_122);
    _129 = _125;
    _130 = _126;
    _131 = _127;
  } else {
    _129 = _120;
    _130 = _121;
    _131 = _122;
  }
  SV_Target.x = _129;
  SV_Target.y = _130;
  SV_Target.z = _131;
  SV_Target.w = 1.0f;
  return SV_Target;
}
