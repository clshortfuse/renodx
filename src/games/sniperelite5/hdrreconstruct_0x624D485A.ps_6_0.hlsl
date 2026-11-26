#include "./shared.h"
Texture2D<float4> g_xTexture : register(t0);

cbuffer HDRReconstructionParams : register(b0) {
  float4 gxConstantControllingLerpFractorForPerChannelReconstruction : packoffset(c000.x);
  float gfPaperWhiteNits : packoffset(c001.x);
  float gfMaxReconstructedNits : packoffset(c001.y);
  float gfGamma : packoffset(c001.z);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 _6 = g_xTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  // RenoDX: pass the sampled input straight through; vanilla math kept below for reference
  if (gfGamma == 1.0f) {
    return float4(_6.rgb, 1.0f);
  }
  float3 linear_color = renodx::draw::InvertIntermediatePass(_6.rgb);
  linear_color = select(and(linear_color > 0.0f, linear_color < 1.0f), pow(linear_color, gfGamma), linear_color);
  return float4(renodx::draw::RenderIntermediatePass(linear_color), 1.0f);
  // float4 SV_Target;
  // float _10 = 1.000100016593933f - _6.x;
  // float _11 = 1.000100016593933f - _6.y;
  // float _12 = 1.000100016593933f - _6.z;
  // float _13 = _6.x / _10;
  // float _14 = _6.y / _11;
  // float _15 = _6.z / _12;
  // float _19 = gfMaxReconstructedNits / gfPaperWhiteNits;
  // float _20 = _19 + -1.0f;
  // float _21 = _19 / _20;
  // float _22 = _21 * 0.5f;
  // float _23 = _21 + -0.5f;
  // float _24 = _22 / _23;
  // float _25 = 1.0f - _24;
  // float _26 = _21 * _6.x;
  // float _27 = _21 * _6.y;
  // float _28 = _21 * _6.z;
  // float _29 = _21 - _6.x;
  // float _30 = _21 - _6.y;
  // float _31 = _21 - _6.z;
  // float _32 = _26 / _29;
  // float _33 = _27 / _30;
  // float _34 = _28 / _31;
  // float _35 = _25 + _32;
  // float _36 = _33 + _25;
  // float _37 = _34 + _25;
  // bool _38 = (_6.x > 0.5f);
  // bool _39 = (_6.y > 0.5f);
  // bool _40 = (_6.z > 0.5f);
  // float _41 = select(_38, _35, _13);
  // float _42 = select(_39, _36, _14);
  // float _43 = select(_40, _37, _15);
  // float _44 = dot(float3(_6.x, _6.y, _6.z), float3(0.27000001072883606f, 0.6700000166893005f, 0.05999999865889549f));
  // float _45 = 1.000100016593933f - _44;
  // float _46 = _44 / _45;
  // float _47 = _21 * _44;
  // float _48 = _21 - _44;
  // float _49 = _47 / _48;
  // float _50 = _25 + _49;
  // bool _51 = (_44 > 0.5f);
  // float _52 = select(_51, _50, _46);
  // float _53 = _44 + 9.999999747378752e-05f;
  // float _54 = _6.x / _53;
  // float _55 = _6.y / _53;
  // float _56 = _6.z / _53;
  // float _57 = _52 * _54;
  // float _58 = _55 * _52;
  // float _59 = _56 * _52;
  // float _64 = _41 - _57;
  // float _65 = _42 - _58;
  // float _66 = _43 - _59;
  // float _67 = gxConstantControllingLerpFractorForPerChannelReconstruction.x * _64;
  // float _68 = gxConstantControllingLerpFractorForPerChannelReconstruction.y * _65;
  // float _69 = gxConstantControllingLerpFractorForPerChannelReconstruction.z * _66;
  // float _70 = _67 + _57;
  // float _71 = _68 + _58;
  // float _72 = _69 + _59;
  // float _73 = _70 * 0.6273999810218811f;
  // float _74 = mad(0.3292999863624573f, _71, _73);
  // float _75 = mad(0.043299999088048935f, _72, _74);
  // float _76 = _70 * 0.06909999996423721f;
  // float _77 = mad(0.9194999933242798f, _71, _76);
  // float _78 = mad(0.01140000019222498f, _72, _77);
  // float _79 = _70 * 0.01640000008046627f;
  // float _80 = mad(0.08799999952316284f, _71, _79);
  // float _81 = mad(0.8956000208854675f, _72, _80);
  // float _83 = gfPaperWhiteNits * _75;
  // float _84 = gfPaperWhiteNits * _78;
  // float _85 = gfPaperWhiteNits * _81;
  // bool _86 = (_83 >= 0.0f);
  // bool _87 = (_84 >= 0.0f);
  // bool _88 = (_85 >= 0.0f);
  // bool _89 = (_83 < 300.0f);
  // bool _90 = (_84 < 300.0f);
  // bool _91 = (_85 < 300.0f);
  // bool _92 = _86 && _89;
  // bool _93 = _87 && _90;
  // bool _94 = _88 && _91;
  // float _95 = _83 * 0.0033333334140479565f;
  // float _96 = _84 * 0.0033333334140479565f;
  // float _97 = _85 * 0.0033333334140479565f;
  // float _98 = _83 * 0.04306666925549507f;
  // float _99 = _84 * 0.04306666925549507f;
  // float _100 = _85 * 0.04306666925549507f;
  // float _101 = abs(_96);
  // float _102 = abs(_97);
  // float _103 = log2(_101);
  // float _104 = log2(_102);
  // float _105 = _103 * 0.4166666567325592f;
  // float _106 = _104 * 0.4166666567325592f;
  // float _107 = exp2(_105);
  // float _108 = exp2(_106);
  // float _109 = _107 * 1.0549999475479126f;
  // float _110 = _108 * 1.0549999475479126f;
  // float _111 = _109 + -0.054999999701976776f;
  // float _112 = _110 + -0.054999999701976776f;
  // bool _113 = !(_95 <= 0.0031308000907301903f);
  // bool _114 = !(_96 <= 0.0031308000907301903f);
  // bool _115 = !(_97 <= 0.0031308000907301903f);
  // float _124;
  // float _127;
  // float _130;
  // float _151;
  // float _154;
  // float _157;
  // [branch]
  // if (_113) {
  //   float _117 = abs(_95);
  //   float _118 = log2(_117);
  //   float _119 = _118 * 0.4166666567325592f;
  //   float _120 = exp2(_119);
  //   float _121 = _120 * 1.0549999475479126f;
  //   float _122 = _121 + -0.054999999701976776f;
  //   _124 = _122;
  // } else {
  //   _124 = _98;
  // }
  // [branch]
  // if (_114) {
  //   _127 = _111;
  // } else {
  //   _127 = _99;
  // }
  // [branch]
  // if (_115) {
  //   _130 = _112;
  // } else {
  //   _130 = _100;
  // }
  // float _131 = abs(_124);
  // float _132 = abs(_127);
  // float _133 = abs(_130);
  // float _134 = log2(_131);
  // float _135 = log2(_132);
  // float _136 = log2(_133);
  // float _137 = _134 * gfGamma;
  // float _138 = _135 * gfGamma;
  // float _139 = _136 * gfGamma;
  // float _140 = exp2(_137);
  // float _141 = exp2(_138);
  // float _142 = exp2(_139);
  // float _143 = _140 * 300.0f;
  // float _144 = _141 * 300.0f;
  // float _145 = _142 * 300.0f;
  // float _146 = _143 / gfPaperWhiteNits;
  // float _147 = _144 / gfPaperWhiteNits;
  // float _148 = _145 / gfPaperWhiteNits;
  // [branch]
  // if (!_92) {
  //   _151 = _75;
  // } else {
  //   _151 = _146;
  // }
  // [branch]
  // if (!_93) {
  //   _154 = _78;
  // } else {
  //   _154 = _147;
  // }
  // [branch]
  // if (!_94) {
  //   _157 = _81;
  // } else {
  //   _157 = _148;
  // }
  // float _158 = _151 * 9.999999747378752e-05f;
  // float _159 = _158 * gfPaperWhiteNits;
  // float _160 = _154 * 9.999999747378752e-05f;
  // float _161 = _160 * gfPaperWhiteNits;
  // float _162 = _157 * 9.999999747378752e-05f;
  // float _163 = _162 * gfPaperWhiteNits;
  // float _164 = gfPaperWhiteNits * 9.999999747378752e-05f;
  // float _165 = abs(_159);
  // float _166 = abs(_161);
  // float _167 = abs(_163);
  // float _168 = log2(_165);
  // float _169 = log2(_166);
  // float _170 = log2(_167);
  // float _171 = _168 * 0.1593017578125f;
  // float _172 = _169 * 0.1593017578125f;
  // float _173 = _170 * 0.1593017578125f;
  // float _174 = exp2(_171);
  // float _175 = exp2(_172);
  // float _176 = exp2(_173);
  // float _177 = _174 * 18.8515625f;
  // float _178 = _175 * 18.8515625f;
  // float _179 = _176 * 18.8515625f;
  // float _180 = _177 + 0.8359375f;
  // float _181 = _178 + 0.8359375f;
  // float _182 = _179 + 0.8359375f;
  // float _183 = _174 * 18.6875f;
  // float _184 = _175 * 18.6875f;
  // float _185 = _176 * 18.6875f;
  // float _186 = _183 + 1.0f;
  // float _187 = _184 + 1.0f;
  // float _188 = _185 + 1.0f;
  // float _189 = _180 / _186;
  // float _190 = _181 / _187;
  // float _191 = _182 / _188;
  // float _192 = log2(_189);
  // float _193 = log2(_190);
  // float _194 = log2(_191);
  // float _195 = _192 * 78.84375f;
  // float _196 = _193 * 78.84375f;
  // float _197 = _194 * 78.84375f;
  // float _198 = exp2(_195);
  // float _199 = exp2(_196);
  // float _200 = exp2(_197);
  // SV_Target.x = _198;
  // SV_Target.y = _199;
  // SV_Target.z = _200;
  // SV_Target.w = _164;
  // return SV_Target;
}
