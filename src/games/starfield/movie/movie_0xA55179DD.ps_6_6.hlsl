#include "../common.hlsl"
#include "../shared.h"

Texture2D<float> t0_space4 : register(t0, space4);

Texture2D<float> t1_space4 : register(t1, space4);

Texture2D<float> t2_space4 : register(t2, space4);

cbuffer cb0 : register(b0) {
  struct PushConstantWrapper_BinkMovie_Layout {
    int PushConstantWrapper_BinkMovie_Layout_000;
    int PushConstantWrapper_BinkMovie_Layout_004;
  }
stub_PushConstantWrapper_BinkMovie_Layout_000:
  packoffset(c000.x);
};

SamplerState s0_space4 : register(s0, space4);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _11 = t0_space4.Sample(s0_space4, float2(TEXCOORD.x, TEXCOORD.y));
  float _14 = t1_space4.Sample(s0_space4, float2(TEXCOORD.x, TEXCOORD.y));
  float _17 = t2_space4.Sample(s0_space4, float2(TEXCOORD.x, TEXCOORD.y));
  float _19 = _11.x * 1.16412353515625f;
  float _31 = saturate((_19 + -0.8706550598144531f) + (_14.x * 1.595794677734375f));
  float _32 = saturate(((_19 + 0.5297050476074219f) - (_14.x * 0.8134765625f)) - (_17.x * 0.391448974609375f));
  float _33 = saturate((_19 + -1.0816688537597656f) + (_17.x * 2.017822265625f));
  float _73 = max(asfloat(stub_PushConstantWrapper_BinkMovie_Layout_000.PushConstantWrapper_BinkMovie_Layout_004), 0.0010000000474974513f);
  float _83 = (((min(1.0f, (_31 * 99999.9921875f)) * 2.0f) * ((((((((((_31 * 0.07846027612686157f) + -0.2889308035373688f) * _31) + 0.6558289527893066f) * _31) + 0.5206927061080933f) * _31) + 0.033212095499038696f) * _31) + 0.0008656803402118385f)) + -1.0f) * _73;
  float _84 = (((min(1.0f, (_32 * 99999.9921875f)) * 2.0f) * ((((((((((_32 * 0.07846027612686157f) + -0.2889308035373688f) * _32) + 0.6558289527893066f) * _32) + 0.5206927061080933f) * _32) + 0.033212095499038696f) * _32) + 0.0008656803402118385f)) + -1.0f) * _73;
  float _85 = (((min(1.0f, (_33 * 99999.9921875f)) * 2.0f) * ((((((((((_33 * 0.07846027612686157f) + -0.2889308035373688f) * _33) + 0.6558289527893066f) * _33) + 0.5206927061080933f) * _33) + 0.033212095499038696f) * _33) + 0.0008656803402118385f)) + -1.0f) * _73;
  float _90 = (_73 / sqrt((_73 * _73) + 1.0f)) * 2.0f;
  float _112 = 1.0f / max(asfloat(stub_PushConstantWrapper_BinkMovie_Layout_000.PushConstantWrapper_BinkMovie_Layout_000), 0.0010000000474974513f);
  SV_Target.x = max(((exp2(log2((_83 / (sqrt((_83 * _83) + 1.0f) * _90)) + 0.5f) * _112) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f);
  SV_Target.y = max(((exp2(log2((_84 / (sqrt((_84 * _84) + 1.0f) * _90)) + 0.5f) * _112) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f);
  SV_Target.z = max(((exp2(log2((_85 / (sqrt((_85 * _85) + 1.0f) * _90)) + 0.5f) * _112) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f);
  SV_Target.w = 1.0f;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float videoPeak = RENODX_PEAK_WHITE_NITS / (RENODX_DIFFUSE_WHITE_NITS / 203.f);
    SV_Target.rgb = renodx::color::gamma::Decode(SV_Target.rgb, 2.4f);  // 2.4 for BT2446a
    SV_Target.rgb = renodx::tonemap::inverse::bt2446a::BT709(SV_Target.rgb, 100.f, videoPeak);
    SV_Target.rgb /= videoPeak;                                           // Normalize to 1.0f = peak;
    SV_Target.rgb *= RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;  // 1.f = game nits
    SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);  // Gamma Correct
  }

  return SV_Target;
}
