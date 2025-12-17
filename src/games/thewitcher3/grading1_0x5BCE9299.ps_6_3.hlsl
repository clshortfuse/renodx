#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _13 = max(TEXCOORD.x, CustomPixelConsts_000.x);
  float _14 = max(TEXCOORD.y, CustomPixelConsts_000.y);
  float _15 = min(_13, CustomPixelConsts_000.z);
  float _16 = min(_14, CustomPixelConsts_000.w);

  float4 _17 = t0.Sample(s0, float2(_15, _16));

  float3 ungraded = _17.rgb;
  // float3 ungraded_sdr = CustomGradingSDR(ungraded);
  float4 ungraded_sdr = ColorGradingSDR(ungraded);

  // renodx::lut::Config lut_config = renodx::lut::config::Create();
  // lut_config.lut_sampler = s1;
  // //lut_config.strength = CUSTOM_LUT_STRENGTH;
  // // lut_config.scaling = 1.f;
  // lut_config.size = 64;
  // lut_config.tetrahedral = true;
  // lut_config.type_input = renodx::lut::config::type::GAMMA_2_2;
  // lut_config.type_output = renodx::lut::config::type::GAMMA_2_2;
  // lut_config.recolor = 1.0f;

  // float3 graded_sdr = renodx::lut::(ungraded_sdr.rgb, lut_config, t1);
  // float3 graded_hdr = lerp(ungraded, ColorGradeHDR(float4(graded_sdr, ungraded_sdr.w)), CUSTOM_LUT_STRENGTH);
  // SV_Target.rgb = graded_hdr.rgb;
  // SV_Target.w = _17.w;  

  _17.rgb = ungraded_sdr.rgb;
  //  float _22 = abs(_17.x);
  //  float _23 = abs(_17.y);
  //  float _24 = abs(_17.z);
  //  float _25 = log2(_22);
  //  float _26 = log2(_23);
  //  float _27 = log2(_24);
  //  float _28 = _25 * 0.4545454680919647f;
  //  float _29 = _26 * 0.4545454680919647f;
  //  float _30 = _27 * 0.4545454680919647f;
  //  float _31 = exp2(_28);
  //  float _32 = exp2(_29);
  //  float _33 = exp2(_30);
  float _31 = renodx::color::gamma::EncodeSafe(_17.x);
  float _32 = renodx::color::gamma::EncodeSafe(_17.y);
  float _33 = renodx::color::gamma::EncodeSafe(_17.z);

  float _34 = _33 * 0.99609375f;
  float _35 = _33 * 63.75f;
  float _36 = floor(_35);
  float _37 = _36 * 0.015625f;
  float _38 = _34 + 0.015625f;
  float _39 = _35 - _36;
  float _40 = saturate(_31);
  float _41 = saturate(_32);
  float _42 = saturate(_38);
  float _43 = min(0.9999899864196777f, _42);
  float _44 = _40 + 0.0078125f;
  float _45 = _41 + 0.0078125f;
  float _46 = _44 * 0.99609375f;
  float _47 = _45 * 0.99609375f;
  float _48 = max(_46, 0.015625f);
  float _49 = max(_47, 0.015625f);
  float _50 = min(_48, 0.984375f);
  float _51 = min(_49, 0.984375f);
  float _52 = _43 * 64.0f;
  float _53 = _43 * 8.0f;
  float _54 = floor(_53);
  float _55 = _54 * 8.0f;
  float _56 = _52 - _55;
  float _57 = floor(_56);
  float _58 = _57 + _50;
  float _59 = _58 * 0.125f;
  float _60 = _54 + _51;
  float _61 = _60 * 0.125f;
  float4 _62 = t1.SampleLevel(s1, float2(_59, _61), 0.0f);
  float _66 = saturate(_37);
  float _67 = min(0.9999899864196777f, _66);
  float _68 = _67 * 64.0f;
  float _69 = _67 * 8.0f;
  float _70 = floor(_69);
  float _71 = _70 * 8.0f;
  float _72 = _68 - _71;
  float _73 = floor(_72);
  float _74 = _73 + _50;
  float _75 = _74 * 0.125f;
  float _76 = _70 + _51;
  float _77 = _76 * 0.125f;
  float4 _78 = t1.SampleLevel(s1, float2(_75, _77), 0.0f);
  float _82 = (_62.x) - _78.x;
  float _83 = (_62.y) - _78.y;
  float _84 = (_62.z) - _78.z;
  float _85 = _82 * _39;
  float _86 = _83 * _39;
  float _87 = _84 * _39;
  float _88 = _85 + _78.x;
  float _89 = _86 + _78.y;
  float _90 = _87 + _78.z;

  // float _91 = abs(_88);
  // float _92 = abs(_89);
  // float _93 = abs(_90);
  // float _94 = log2(_91);
  // float _95 = log2(_92);
  // float _96 = log2(_93);
  // float _97 = _94 * 2.200000047683716f;
  // float _98 = _95 * 2.200000047683716f;
  // float _99 = _96 * 2.200000047683716f;
  // float _100 = exp2(_97);
  // float _101 = exp2(_98);
  // float _102 = exp2(_99);
  float _100 = renodx::color::gamma::DecodeSafe(_88);
  float _101 = renodx::color::gamma::DecodeSafe(_89);
  float _102 = renodx::color::gamma::DecodeSafe(_90);
  float _106 = (CustomPixelConsts_016.z) * _100;
  float _107 = (CustomPixelConsts_016.z) * _101;
  float _108 = (CustomPixelConsts_016.z) * _102;
  float _109 = _106 - _17.x;
  float _110 = _107 - _17.y;
  float _111 = _108 - _17.z;
  float _112 = _109 * (CustomPixelConsts_016.y);
  float _113 = _110 * (CustomPixelConsts_016.y);
  float _114 = _111 * (CustomPixelConsts_016.y);
  float _115 = _112 + _17.x;
  float _116 = _113 + _17.y;
  float _117 = _114 + _17.z;
  SV_Target.x = _115;
  SV_Target.y = _116;
  SV_Target.z = _117;
  SV_Target.w = _17.w;

  float3 graded_sdr = SV_Target.rgb;
  // SV_Target.rgb = CustomUpgradeGrading(ungraded, ungraded_sdr, graded_sdr);
  SV_Target.rgb = lerp(ungraded, ColorGradeHDR(float4(SV_Target.rgb, ungraded_sdr.w)), CUSTOM_LUT_STRENGTH);
  return SV_Target;
}
