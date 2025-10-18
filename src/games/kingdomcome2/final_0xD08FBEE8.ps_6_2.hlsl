#include "./shared.h"

Texture2D<float4> Tx2Tx_Source : register(t0);

Texture2D<float4> UITex_Source : register(t1);

cbuffer PER_BATCH : register(b0, space2) {
  float4 HDRParams : packoffset(c000.x);
};

SamplerState Tx2Tx_Sampler : register(s2);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _7 = Tx2Tx_Source.Sample(Tx2Tx_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _12 = UITex_Source.Sample(Tx2Tx_Sampler, float2(TEXCOORD.x, TEXCOORD.y));

  float _22 = 1.0f / (max(_7.x, max(_7.y, _7.z)) + 1.0f);
  float ui_scale = HDRParams.y;  // 6.8f

  if (RENODX_TONE_MAP_TYPE) {
    ui_scale = 1;
  }
  float _32 = (pow(_12.x, 2.200000047683716f)) * ui_scale;
  float _33 = (pow(_12.y, 2.200000047683716f)) * ui_scale;
  float _34 = (pow(_12.z, 2.200000047683716f)) * ui_scale;
  float _38 = 1.0f / (max(_32, max(_33, _34)) + 1.0f);
  float _45 = 1.0f - _12.w;
  float _52 = ((_32 * _12.w) * _38) + ((_45 * _7.x) * _22);
  float _53 = ((_33 * _12.w) * _38) + ((_45 * _7.y) * _22);
  float _54 = ((_34 * _12.w) * _38) + ((_45 * _7.z) * _22);
  float _59 = 1.0f / (1.0f - min(max(_52, max(_53, _54)), 0.9998999834060669f));
  SV_Target.x = (_59 * _52);
  SV_Target.y = (_59 * _53);
  SV_Target.z = (_59 * _54);

  if (RENODX_TONE_MAP_TYPE) {
    SV_Target.rgb = renodx::draw::SwapChainPass(SV_Target.rgb);
  }
  SV_Target.w = _7.w;
  return SV_Target;
}
