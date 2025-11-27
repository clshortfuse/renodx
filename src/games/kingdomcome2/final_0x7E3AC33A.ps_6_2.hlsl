#include "./shared.h"

Texture2D<float4> Tx2Tx_Source : register(t0);

Texture2D<float4> UITex_Source : register(t1);

cbuffer PER_BATCH : register(b0, space2) {
  float4 HDRParams : packoffset(c000.x);
};

SamplerState Tx2Tx_Sampler : register(s2);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _7 = Tx2Tx_Source.Sample(Tx2Tx_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _12 = UITex_Source.Sample(Tx2Tx_Sampler, float2(TEXCOORD.x, TEXCOORD.y));
  float ui_scale = HDRParams.y;  // 6.8f

  if (RENODX_TONE_MAP_TYPE) {
    ui_scale = 1;
  } else {
    // Vanilla unnecessarily converts to bt2020 in output
    _7.rgb = renodx::color::bt709::from::BT2020(_7.rgb);
  }
  float _19 = _7.r, _22 = _7.g, _25 = _7.b;
  /* float _19 = mad(-0.07283999770879745f, _7.z, mad(-0.5876560211181641f, _7.y, (_7.x * 1.6604959964752197f)));
  float _22 = mad(-0.00834800023585558f, _7.z, mad(1.1328949928283691f, _7.y, (_7.x * -0.12454699724912643f)));
  float _25 = mad(1.118751049041748f, _7.z, mad(-0.10059700161218643f, _7.y, (_7.x * -0.018154000863432884f))); */
  float _31 = 1.0f / (max(_19, max(_22, _25)) + 1.0f);
  float _41 = (pow(_12.x, 2.200000047683716f)) * ui_scale;
  float _42 = (pow(_12.y, 2.200000047683716f)) * ui_scale;
  float _43 = (pow(_12.z, 2.200000047683716f)) * ui_scale;
  float _47 = 1.0f / (max(_41, max(_42, _43)) + 1.0f);
  float _54 = 1.0f - _12.w;
  float _61 = ((_41 * _12.w) * _47) + ((_54 * _19) * _31);
  float _62 = ((_42 * _12.w) * _47) + ((_22 * _54) * _31);
  float _63 = ((_43 * _12.w) * _47) + ((_25 * _54) * _31);
  float _68 = 1.0f / (1.0f - min(max(_61, max(_62, _63)), 0.9998999834060669f));
  SV_Target.x = (_68 * _61);
  SV_Target.y = (_68 * _62);
  SV_Target.z = (_68 * _63);

  if (RENODX_TONE_MAP_TYPE) {
    SV_Target.rgb = renodx::draw::SwapChainPass(SV_Target.rgb);
  }
  SV_Target.w = _7.w;
  return SV_Target;
}
