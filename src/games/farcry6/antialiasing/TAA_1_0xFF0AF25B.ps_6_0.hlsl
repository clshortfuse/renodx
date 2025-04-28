#include "../shared.h"

Texture2D<float2> t0 : register(t0);

Texture2D<float2> t1 : register(t1);

Texture2D<float4> t2 : register(t2);  // scene color

Texture2D<float4> t3 : register(t3);  // also scene, previous frame?

Texture2D<float4> t4 : register(t4);  // also scene, previous frame?

Texture2D<float> t5 : register(t5);

Texture2D<float> t6 : register(t6);

cbuffer cb0 : register(b0) {
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
};

SamplerState s2_space2 : register(s2, space2);

SamplerState s5_space2 : register(s5, space2);

// clang-format off
#define INFINITY +1.#INF
// clang-format on

float4 main(
    linear float2 TEXCOORD0_centroid: TEXCOORD0_centroid,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_IsFrontFace: SV_IsFrontFace)
    : SV_Target {
  float4 SV_Target;
  SV_Target.x = 0.0f;
  SV_Target.y = 0.0f;
  SV_Target.z = 0.0f;
  SV_Target.w = 0.0f;
  float2 _13 = t0.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _16 = _13.x + -0.49803921580314636f;
  float _17 = _16 * 2.0f;
  bool _18 = (_17 < -0.6687403321266174f);
  float _37;
  float _60;
  float _180;
  float _202;
  if (_18) {
    float _20 = _16 * 4.830047130584717f;
    float _21 = _20 + 1.415023684501648f;
    _37 = _21;
  } else {
    bool _23 = (_17 < 0.6687403321266174f);
    if (_23) {
      float _25 = _16 * INFINITY;
      float _26 = _25 + 0.5f;
      float _27 = saturate(_26);
      float _28 = _27 * 2.0f;
      float _29 = _28 + -1.0f;
      float _30 = _17 * _17;
      float _31 = _30 * _30;
      float _32 = _31 * _29;
      _37 = _32;
    } else {
      float _34 = _16 * 4.830047130584717f;
      float _35 = _34 + -1.415023684501648f;
      _37 = _35;
    }
  }
  float _38 = _37 * 0.10000000149011612f;
  float _39 = _13.y + -0.49803921580314636f;
  float _40 = _39 * 2.0f;
  bool _41 = (_40 < -0.6687403321266174f);
  if (_41) {
    float _43 = _39 * 4.830047130584717f;
    float _44 = _43 + 1.415023684501648f;
    _60 = _44;
  } else {
    bool _46 = (_40 < 0.6687403321266174f);
    if (_46) {
      float _48 = _39 * INFINITY;
      float _49 = _48 + 0.5f;
      float _50 = saturate(_49);
      float _51 = _50 * 2.0f;
      float _52 = _51 + -1.0f;
      float _53 = _40 * _40;
      float _54 = _53 * _53;
      float _55 = _54 * _52;
      _60 = _55;
    } else {
      float _57 = _39 * 4.830047130584717f;
      float _58 = _57 + -1.415023684501648f;
      _60 = _58;
    }
  }
  float _61 = _60 * 0.10000000149011612f;

  // Sample the scene
  float4 _62 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(-1, -1));
  float4 _66 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(0, -1));
  float4 _70 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(1, -1));
  float4 _74 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(-1, 0));
  float4 _78 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _82 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(1, 0));
  float4 _86 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(-1, 1));
  float4 _90 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(0, 1));
  float4 _94 = t2.SampleLevel(s5_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f, int2(1, 1));

  // do TAA in BT.2020
  // _62.rgb = renodx::color::bt2020::from::BT709(_62.rgb);
  // _66.rgb = renodx::color::bt2020::from::BT709(_66.rgb);
  // _70.rgb = renodx::color::bt2020::from::BT709(_70.rgb);
  // _74.rgb = renodx::color::bt2020::from::BT709(_74.rgb);
  // _78.rgb = renodx::color::bt2020::from::BT709(_78.rgb);
  // _82.rgb = renodx::color::bt2020::from::BT709(_82.rgb);
  // _86.rgb = renodx::color::bt2020::from::BT709(_86.rgb);
  // _90.rgb = renodx::color::bt2020::from::BT709(_90.rgb);
  // _94.rgb = renodx::color::bt2020::from::BT709(_94.rgb);

  float _98 = min(_90.x, _94.x);
  float _99 = min(_86.x, _98);
  float _100 = min(_90.y, _94.y);
  float _101 = min(_86.y, _100);
  float _102 = min(_90.z, _94.z);
  float _103 = min(_86.z, _102);
  float _104 = min(_82.x, _99);
  float _105 = min(_78.x, _104);
  float _106 = min(_82.y, _101);
  float _107 = min(_78.y, _106);
  float _108 = min(_82.z, _103);
  float _109 = min(_78.z, _108);
  float _110 = min(_74.x, _105);
  float _111 = min(_70.x, _110);
  float _112 = min(_74.y, _107);
  float _113 = min(_70.y, _112);
  float _114 = min(_74.z, _109);
  float _115 = min(_70.z, _114);
  float _116 = min(_66.x, _111);
  float _117 = min(_62.x, _116);
  float _118 = min(_66.y, _113);
  float _119 = min(_62.y, _118);
  float _120 = min(_66.z, _115);
  float _121 = min(_62.z, _120);
  float _122 = max(_90.x, _94.x);
  float _123 = max(_86.x, _122);
  float _124 = max(_90.y, _94.y);
  float _125 = max(_86.y, _124);
  float _126 = max(_90.z, _94.z);
  float _127 = max(_86.z, _126);
  float _128 = max(_82.x, _123);
  float _129 = max(_78.x, _128);
  float _130 = max(_82.y, _125);
  float _131 = max(_78.y, _130);
  float _132 = max(_82.z, _127);
  float _133 = max(_78.z, _132);
  float _134 = max(_74.x, _129);
  float _135 = max(_70.x, _134);
  float _136 = max(_74.y, _131);
  float _137 = max(_70.y, _136);
  float _138 = max(_74.z, _133);
  float _139 = max(_70.z, _138);
  float _140 = max(_66.x, _135);
  float _141 = max(_62.x, _140);
  float _142 = max(_66.y, _137);
  float _143 = max(_62.y, _142);
  float _144 = max(_66.z, _139);
  float _145 = max(_62.z, _144);
  float _146 = _38 + TEXCOORD0_centroid.x;
  float _147 = _61 + TEXCOORD0_centroid.y;

  // Sample the previous frame?
  float4 _148 = t3.SampleLevel(s2_space2, float2(_146, _147), 0.0f);  // also scene, previous frame?
  float4 _152 = t4.SampleLevel(s2_space2, float2(_146, _147), 0.0f);  // also scene, previous frame? grayscale

  // do TAA in BT.2020
  // _148.rgb = renodx::color::bt2020::from::BT709(_148.rgb);
  // _152.rgb = renodx::color::bt2020::from::BT709(_152.rgb);

  float2 _156 = t1.SampleLevel(s2_space2, float2(_146, _147), 0.0f);
  float _159 = _156.x + -0.49803921580314636f;
  float _160 = _159 * 2.0f;
  bool _161 = (_160 < -0.6687403321266174f);
  if (_161) {
    float _163 = _159 * 4.830047130584717f;
    float _164 = _163 + 1.415023684501648f;
    _180 = _164;
  } else {
    bool _166 = (_160 < 0.6687403321266174f);
    if (_166) {
      float _168 = _159 * INFINITY;
      float _169 = _168 + 0.5f;
      float _170 = saturate(_169);
      float _171 = _170 * 2.0f;
      float _172 = _171 + -1.0f;
      float _173 = _160 * _160;
      float _174 = _173 * _173;
      float _175 = _174 * _172;
      _180 = _175;
    } else {
      float _177 = _159 * 4.830047130584717f;
      float _178 = _177 + -1.415023684501648f;
      _180 = _178;
    }
  }
  float _181 = _156.y + -0.49803921580314636f;
  float _182 = _181 * 2.0f;
  bool _183 = (_182 < -0.6687403321266174f);
  if (_183) {
    float _185 = _181 * 4.830047130584717f;
    float _186 = _185 + 1.415023684501648f;
    _202 = _186;
  } else {
    bool _188 = (_182 < 0.6687403321266174f);
    if (_188) {
      float _190 = _181 * INFINITY;
      float _191 = _190 + 0.5f;
      float _192 = saturate(_191);
      float _193 = _192 * 2.0f;
      float _194 = _193 + -1.0f;
      float _195 = _182 * _182;
      float _196 = _195 * _195;
      float _197 = _196 * _194;
      _202 = _197;
    } else {
      float _199 = _181 * 4.830047130584717f;
      float _200 = _199 + -1.415023684501648f;
      _202 = _200;
    }
  }
  float _203 = _180 - _37;
  float _204 = _203 * 0.10000000149011612f;
  float _205 = _202 - _60;
  float _206 = _205 * 0.10000000149011612f;
  float _207 = _204 * _204;
  float _208 = _206 * _206;
  float _209 = _208 + _207;
  float _210 = sqrt(_209);
  float _211 = _210 * 32.0f;
  float _212 = 1.0f - _211;
  float _213 = saturate(_212);
  float _214 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _216 = t6.SampleLevel(s2_space2, float2(_146, _147), 0.0f);
  float _218 = max(_214.x, _216.x);
  float _219 = _213 - _218;
  float _220 = saturate(_219);
  float _221 = _141 - _117;
  float _222 = _143 - _119;
  float _223 = _145 - _121;
  float _226 = cb0_011x * _221;
  float _227 = cb0_011x * _222;
  float _228 = cb0_011x * _223;
  float _229 = _117 - _226;
  float _230 = _119 - _227;
  float _231 = _121 - _228;

  float _232 = max(_229, 0.0f);
  float _233 = max(_230, 0.0f);
  float _234 = max(_231, 0.0f);
  // float _232 = (_229);
  // float _233 = (_230);
  // float _234 = (_231);

  float _235 = _232 - _152.x;
  float _236 = _233 - _152.y;
  float _237 = _234 - _152.z;
  float _238 = saturate(_235);
  float _239 = saturate(_236);
  float _240 = saturate(_237);
  float _241 = _152.x - _141;
  float _242 = _241 - _226;
  float _243 = _152.y - _143;
  float _244 = _243 - _227;
  float _245 = _152.z - _145;
  float _246 = _245 - _228;
  float _247 = saturate(_242);
  float _248 = saturate(_244);
  float _249 = saturate(_246);
  float _250 = _247 + _238;
  float _251 = _248 + _239;
  float _252 = _249 + _240;
  float _253 = max(_152.x, _117);
  float _254 = max(_152.y, _119);
  float _255 = max(_152.z, _121);
  float _256 = min(_141, _253);
  float _257 = min(_143, _254);
  float _258 = min(_145, _255);
  float _259 = max(_148.x, _117);
  float _260 = max(_148.y, _119);
  float _261 = max(_148.z, _121);
  float _262 = min(_141, _259);
  float _263 = min(_143, _260);
  float _264 = min(_145, _261);
  float _265 = _78.x - _152.x;
  float _266 = _78.y - _152.y;
  float _267 = _78.z - _152.z;
  float _268 = abs(_265);
  float _269 = abs(_266);
  float _270 = abs(_267);
  float _271 = _268 * _268;
  float _272 = _269 * _269;
  float _273 = _272 + _271;
  float _274 = _270 * _270;
  float _275 = _273 + _274;
  float _276 = sqrt(_275);
  float _277 = _250 * _250;
  float _278 = _251 * _251;
  float _279 = _278 + _277;
  float _280 = _252 * _252;
  float _281 = _279 + _280;
  float _282 = sqrt(_281);
  float _285 = cb0_011z * _276;
  float _286 = cb0_011w * _282;
  float _287 = _285 - _286;
  float _288 = max(_287, 0.0f);
  float _289 = _288 + 0.0010000000474974513f;
  float _290 = 1.0f / _289;
  float _291 = saturate(_290);
  float _293 = max(cb0_011y, _291);
  bool _294 = (_146 > 1.0f);
  bool _295 = (_146 < 0.0f);
  bool _296 = _295 || _294;
  bool _297 = (_147 > 1.0f);
  bool _298 = _296 || _297;
  bool _299 = (_147 < 0.0f);
  bool _300 = _299 || _298;
  float _301 = _293 + 1.0f;
  float _302 = select(_300, 2.0f, _301);
  float _303 = _302 - _220;
  float _304 = saturate(_303);

  // squaring the color values?
  // float _305 = _78.x * _78.x;
  // float _306 = _78.y * _78.y;
  // float _307 = _78.z * _78.z;
  // float _308 = _256 * _256;
  // float _309 = _257 * _257;
  // float _310 = _258 * _258;
  // float _311 = _262 * _262;
  // float _312 = _263 * _263;
  // float _313 = _264 * _264;
  float _305 = sign(_78.x) * (abs(_78.x) * abs(_78.x));
  float _306 = sign(_78.y) * abs(_78.y) * abs(_78.y);
  float _307 = sign(_78.z) * abs(_78.z) * abs(_78.z);
  float _308 = sign(_256) * abs(_256) * abs(_256);
  float _309 = sign(_257) * abs(_257) * abs(_257);
  float _310 = sign(_258) * abs(_258) * abs(_258);
  float _311 = sign(_262) * abs(_262) * abs(_262);
  float _312 = sign(_263) * abs(_263) * abs(_263);
  float _313 = sign(_264) * abs(_264) * abs(_264);

  float _314 = select(_300, 0.0f, 0.5f);
  float _315 = _314 * _220;
  float _316 = _311 - _305;
  float _317 = _312 - _306;
  float _318 = _313 - _307;
  float _319 = _316 * _315;
  float _320 = _317 * _315;
  float _321 = _318 * _315;
  float _322 = _319 + _305;
  float _323 = _320 + _306;
  float _324 = _321 + _307;
  float _325 = _304 * _322;
  float _326 = _304 * _323;
  float _327 = _304 * _324;
  float _328 = 1.0f - _304;
  float _329 = _308 * _328;
  float _330 = _309 * _328;
  float _331 = _310 * _328;
  float _332 = _329 + _325;
  float _333 = _330 + _326;
  float _334 = _331 + _327;

  // float _335 = sqrt(_332);
  // float _336 = sqrt(_333);
  // float _337 = sqrt(_334);
  float _335 = renodx::math::SignSqrt(_332);
  float _336 = renodx::math::SignSqrt(_333);
  float _337 = renodx::math::SignSqrt(_334);

  SV_Target.x = _335;
  SV_Target.y = _336;
  SV_Target.z = _337;
  SV_Target.w = 1.0f;

  // SV_Target.rgb = renodx::color::bt709::from::BT2020(SV_Target.rgb);

  return SV_Target;
}
