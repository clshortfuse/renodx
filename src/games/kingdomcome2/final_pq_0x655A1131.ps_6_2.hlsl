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
  float ui_scale = HDRParams.y;  // 6.8f

  if (RENODX_TONE_MAP_TYPE) {
    ui_scale = 1;
  }

  float _19 = mad(0.04330600053071976f, _7.z, mad(0.3292919993400574f, _7.y, (_7.x * 0.6274020075798035f)));
  float _22 = mad(0.011359999887645245f, _7.z, mad(0.919543981552124f, _7.y, (_7.x * 0.06909500062465668f)));
  float _25 = mad(0.8955780267715454f, _7.z, mad(0.08802799880504608f, _7.y, (_7.x * 0.016394000500440598f)));
  float _40 = 1.0f / (max(_19, max(_22, _25)) + 1.0f);
  float _50 = exp2(log2(mad(0.04330600053071976f, _12.z, mad(0.3292919993400574f, _12.y, (_12.x * 0.6274020075798035f)))) * 2.200000047683716f) * HDRParams.y;
  float _51 = exp2(log2(mad(0.011359999887645245f, _12.z, mad(0.919543981552124f, _12.y, (_12.x * 0.06909500062465668f)))) * 2.200000047683716f) * HDRParams.y;
  float _52 = exp2(log2(mad(0.8955780267715454f, _12.z, mad(0.08802799880504608f, _12.y, (_12.x * 0.016394000500440598f)))) * 2.200000047683716f) * HDRParams.y;
  float _56 = 1.0f / (max(_50, max(_51, _52)) + 1.0f);
  float _63 = 1.0f - _12.w;
  float _70 = ((_50 * _12.w) * _56) + ((_63 * _19) * _40);
  float _71 = ((_51 * _12.w) * _56) + ((_22 * _63) * _40);
  float _72 = ((_52 * _12.w) * _56) + ((_25 * _63) * _40);
  float _77 = 1.0f / (1.0f - min(max(_70, max(_71, _72)), 0.9998999834060669f));
  if (RENODX_TONE_MAP_TYPE) {
    renodx::draw::Config config = renodx::draw::BuildConfig();
    config.swap_chain_output_preset = renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_HDR10;
    SV_Target.rgb = renodx::draw::SwapChainPass(float3(_70, _71, _72) * _77, config);
  } else {
    float _93 = exp2(log2(abs((_70 * 0.00800000037997961f) * _77)) * 0.1593017578125f);
    float _94 = exp2(log2(abs((_71 * 0.00800000037997961f) * _77)) * 0.1593017578125f);
    float _95 = exp2(log2(abs((_72 * 0.00800000037997961f) * _77)) * 0.1593017578125f);
    SV_Target.x = exp2(log2(((_93 * 18.8515625f) + 0.8359375f) / ((_93 * 18.6875f) + 1.0f)) * 78.84375f);
    SV_Target.y = exp2(log2(((_94 * 18.8515625f) + 0.8359375f) / ((_94 * 18.6875f) + 1.0f)) * 78.84375f);
    SV_Target.z = exp2(log2(((_95 * 18.8515625f) + 0.8359375f) / ((_95 * 18.6875f) + 1.0f)) * 78.84375f);
  }

  SV_Target.w = _7.w;
  return SV_Target;
}
