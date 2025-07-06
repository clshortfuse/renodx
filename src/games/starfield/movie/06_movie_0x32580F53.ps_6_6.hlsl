#include "../common.hlsl"
#include "../shared.h"

Texture2D<float> t0 : register(t0, space8);

Texture2D<float> t1 : register(t1, space8);

Texture2D<float> t2 : register(t2, space8);

cbuffer cb0 : register(b0) {
  uint cb0_000x : packoffset(c000.x);
  uint cb0_000y : packoffset(c000.y);
};

SamplerState s0 : register(s0, space8);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float _19 = ((t0.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)))).x) * 1.16412353515625f;
  float _27 = (_19 + -0.8706550598144531f) + (((t1.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)))).x) * 1.595794677734375f);
  float _28 = ((_19 - (((t1.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)))).x) * 0.8134765625f)) - (((t2.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)))).x) * 0.391448974609375f)) + 0.5297050476074219f;
  float _30 = (_19 + -1.0816688537597656f) + (((t2.Sample(s0, float2((TEXCOORD.x), (TEXCOORD.y)))).x) * 2.017822265625f);
  float _70 = max((asfloat(((uint)(cb0_000y)))), 0.0010000000474974513f);
  float _80 = ((((min(1.0f, (_27 * 99999.9921875f))) * 2.0f) * ((((((((((_27 * 0.07846027612686157f) + -0.2889308035373688f) * _27) + 0.6558289527893066f) * _27) + 0.5206927061080933f) * _27) + 0.033212095499038696f) * _27) + 0.0008656803402118385f)) + -1.0f) * _70;
  float _81 = ((((min(1.0f, (_28 * 99999.9921875f))) * 2.0f) * ((((((((((_28 * 0.07846027612686157f) + -0.2889308035373688f) * _28) + 0.6558289527893066f) * _28) + 0.5206927061080933f) * _28) + 0.033212095499038696f) * _28) + 0.0008656803402118385f)) + -1.0f) * _70;
  float _82 = ((((min(1.0f, (_30 * 99999.9921875f))) * 2.0f) * ((((((((((_30 * 0.07846027612686157f) + -0.2889308035373688f) * _30) + 0.6558289527893066f) * _30) + 0.5206927061080933f) * _30) + 0.033212095499038696f) * _30) + 0.0008656803402118385f)) + -1.0f) * _70;
  float _87 = (_70 / (sqrt(((_70 * _70) + 1.0f)))) * 2.0f;
  float _109 = 1.0f / (max((asfloat(((uint)(cb0_000x)))), 0.0010000000474974513f));

  SV_Target.x = (max((((exp2(((log2(((_80 / ((sqrt(((_80 * _80) + 1.0f))) * _87)) + 0.5f))) * _109))) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f));
  SV_Target.y = (max((((exp2(((log2(((_81 / ((sqrt(((_81 * _81) + 1.0f))) * _87)) + 0.5f))) * _109))) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f));
  SV_Target.z = (max((((exp2(((log2(((_82 / ((sqrt(((_82 * _82) + 1.0f))) * _87)) + 0.5f))) * _109))) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f));
  SV_Target.w = 1.0f;

  if (injectedData.toneMapType != 0.f) {
    float videoPeak =
        injectedData.toneMapPeakNits / (injectedData.toneMapGameNits / 203.f);
    SV_Target.rgb = renodx::color::gamma::Decode(SV_Target.rgb, 2.4f);  // 2.4 for BT2446a
    SV_Target.rgb = renodx::tonemap::inverse::bt2446a::BT709(SV_Target.rgb, 100.f, videoPeak);
    SV_Target.rgb /= videoPeak;                                                    // Normalize to 1.0f = peak;
    SV_Target.rgb *= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;  // 1.f = game nits
    SV_Target.rgb = PostToneMapScale(SV_Target.rgb);                               // Gamma Correct
  }
  return SV_Target;
}
