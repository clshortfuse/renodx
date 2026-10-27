#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

Texture3D<float4> t40_space15 : register(t40, space15);

Texture2D<float4> t13_space15 : register(t13, space15);

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

cbuffer cb0_space5 : register(b0, space5) {
  float cb0_space5_008x : packoffset(c008.x);
  float cb0_space5_008y : packoffset(c008.y);
  float cb0_space5_008z : packoffset(c008.z);
};

cbuffer cb1_space9 : register(b1, space9) {
  float cb1_space9_034x : packoffset(c034.x);
  float cb1_space9_035z : packoffset(c035.z);
};

cbuffer cb3_space9 : register(b3, space9) {
  float cb3_space9_036y : packoffset(c036.y);
  float cb3_space9_036w : packoffset(c036.w);
  float cb3_space9_037x : packoffset(c037.x);
  float cb3_space9_037y : packoffset(c037.y);
  float cb3_space9_038x : packoffset(c038.x);
  float cb3_space9_038y : packoffset(c038.y);
  float cb3_space9_038z : packoffset(c038.z);
  float cb3_space9_038w : packoffset(c038.w);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s2_space1 : register(s2, space1);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
  float4 SV_Target_2 : SV_Target2;
  float4 SV_Target_3 : SV_Target3;
  float4 SV_Target_4 : SV_Target4;
};

OutputSignature main(
    noperspective float4 SV_Position : SV_Position,
    linear float4 ATTRIBUTE_POSITION_INTERPOLATED : ATTRIBUTE_POSITION_INTERPOLATED,
    linear float2 UVS_PACKED_ATTR : UVS_PACKED_ATTR,
    linear float ATTRIBUTE_REFLECTION_DIST : ATTRIBUTE_REFLECTION_DIST,
    linear float ATTRIBUTE_OBJECT_ID : ATTRIBUTE_OBJECT_ID,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    linear float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    linear float ATTRIBUTE_LIGHT_MASK : ATTRIBUTE_LIGHT_MASK,
    linear float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    linear float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    linear float3 ATTRIBUTE_POSITION_VIEW : ATTRIBUTE_POSITION_VIEW,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float4 SV_Target_3;
  float4 SV_Target_4;
  bool _13 = (SV_IsFrontFace != 0);
  bool _29 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_29) discard;
  float _34 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _35 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _36 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _37 = select(_13, ATTRIBUTE_NORMAL.x, _34);
  float _38 = select(_13, ATTRIBUTE_NORMAL.y, _35);
  float _39 = select(_13, ATTRIBUTE_NORMAL.z, _36);
  float _40 = max(ATTRIBUTE_VCOLOR.w, 0.0f);
  float _41 = min(1.0f, _40);
  float4 _46 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _48 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _50 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _52 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _56 = cb3_space9_038x * _48.x;
  float _58 = _56 + cb3_space9_038z;
  float _60 = cb3_space9_038y * _50.x;
  float _62 = _60 + cb3_space9_038w;
  float _63 = _52.x + _46.x;
  float _66 = cb3_space9_037x * _63;
  float _67 = _58 * 0.008609036915004253f;
  float _68 = _58 * 0.5600313544273376f;
  float _69 = _66 + _67;
  float _70 = _66 - _67;
  float _71 = _68 + _66;
  float _72 = _62 * 0.11102962493896484f;
  float _73 = _62 * 0.3206271827220917f;
  float _74 = _69 + _72;
  float _75 = _70 - _72;
  float _76 = _71 - _73;
  float _77 = max(_74, 0.0f);
  float _78 = max(_75, 0.0f);
  float _79 = max(_76, 0.0f);
  float _80 = log2(_77);
  float _81 = log2(_78);
  float _82 = log2(_79);
  float _83 = _80 * 0.012683313339948654f;
  float _84 = _81 * 0.012683313339948654f;
  float _85 = _82 * 0.012683313339948654f;
  float _86 = exp2(_83);
  float _87 = exp2(_84);
  float _88 = exp2(_85);
  float _89 = _86 + -0.8359375f;
  float _90 = _87 + -0.8359375f;
  float _91 = _88 + -0.8359375f;
  float _92 = max(0.0f, _89);
  float _93 = max(0.0f, _90);
  float _94 = max(0.0f, _91);
  float _95 = _86 * 18.6875f;
  float _96 = _87 * 18.6875f;
  float _97 = _88 * 18.6875f;
  float _98 = 18.8515625f - _95;
  float _99 = 18.8515625f - _96;
  float _100 = 18.8515625f - _97;
  float _101 = _92 / _98;
  float _102 = _93 / _99;
  float _103 = _94 / _100;
  float _104 = abs(_101);
  float _105 = abs(_102);
  float _106 = abs(_103);
  float _107 = log2(_104);
  float _108 = log2(_105);
  float _109 = log2(_106);
  float _110 = _107 * 6.277394771575928f;
  float _111 = _108 * 6.277394771575928f;
  float _112 = _109 * 6.277394771575928f;
  float _113 = exp2(_110);
  float _114 = exp2(_111);
  float _115 = exp2(_112);
  float _116 = _113 * 3.4366066455841064f;
  float _117 = _113 * 0.791329562664032f;
  float _118 = _114 * 2.5064520835876465f;
  float _119 = _114 * 1.9836004972457886f;
  float _120 = _114 * 0.09891371428966522f;
  float _121 = _116 - _118;
  float _122 = _119 - _117;
  float _123 = _113 * -0.02594989910721779f;
  float _124 = _123 - _120;
  float _125 = _115 * 0.06984542310237885f;
  float _126 = _115 * 0.192270889878273f;
  float _127 = _115 * 1.124863624572754f;
  float _128 = _121 + _125;
  float _129 = _122 - _126;
  float _130 = _124 + _127;
  float _132 = cb3_space9_037y * 368.6400146484375f;
  float _133 = _132 * _128;
  float _134 = _132 * _129;
  float _135 = _132 * _130;
  float _136 = max(_133, 9.999999747378752e-05f);
  float _137 = max(_134, 9.999999747378752e-05f);
  float _138 = max(_135, 9.999999747378752e-05f);
  float _142 = log2(_136);
  float _143 = log2(_137);
  float _144 = log2(_138);
  float _145 = _142 + 9.720000267028809f;
  float _146 = _143 + 9.720000267028809f;
  float _147 = _144 + 9.720000267028809f;
  float _148 = _145 * 0.03030303120613098f;
  float _149 = _146 * 0.03030303120613098f;
  float _150 = _147 * 0.03030303120613098f;
  float _151 = _148 + 0.23496760427951813f;
  float _152 = _149 + 0.23496760427951813f;
  float _153 = _150 + 0.23496760427951813f;
  uint3 _154;
  t40_space15.GetDimensions(_154.x, _154.y, _154.z);
  uint2 _158;
  t13_space15.GetDimensions(_158.x, _158.y);
  uint _160 = _154.x + -1u;
  uint _161 = _154.y + -1u;
  uint _162 = _154.z + -1u;
  float _163 = float((uint)_160);
  float _164 = float((uint)_161);
  float _165 = float((uint)_162);
  float _166 = float((uint)_154.x);
  float _167 = float((uint)_154.y);
  float _168 = float((uint)_154.z);
  float _169 = _163 / _166;
  float _170 = _164 / _167;
  float _171 = _165 / _168;
  float _172 = 0.5f / _166;
  float _173 = 0.5f / _167;
  float _174 = 0.5f / _168;
  float _175 = _169 * _151;
  float _176 = _170 * _152;
  float _177 = _171 * _153;
  float _178 = _172 + _175;
  float _179 = _173 + _176;
  float _180 = _174 + _177;
  float4 _181 = t40_space15.SampleLevel(s2_space1, float3(_178, _179, _180), 0.0f);
  float _184 = exp2(_142);
  float _185 = exp2(_143);
  float _186 = exp2(_144);
  float _187 = _184 * 0.6954522132873535f;
  float _188 = mad(0.14067870378494263f, _185, _187);
  float _189 = mad(0.16386906802654266f, _186, _188);
  float _190 = _184 * 0.044794563204050064f;
  float _191 = mad(0.8596711158752441f, _185, _190);
  float _192 = mad(0.0955343171954155f, _186, _191);
  float _193 = _184 * -0.005525882821530104f;
  float _194 = mad(0.004025210160762072f, _185, _193);
  float _195 = mad(1.0015007257461548f, _186, _194);
  float _196 = _181.x + 1.0f;
  float _197 = _189 * _196;
  float _198 = _192 * _196;
  float _199 = _195 * _196;
  float _200 = _197 + _181.y;
  float _201 = max(_200, 0.0f);
  float _202 = max(_198, 0.0f);
  float _203 = max(_199, 0.0f);
  float _204 = min(_201, 65536.0f);
  float _205 = min(_202, 65536.0f);
  float _206 = min(_203, 65536.0f);
  float _207 = _204 * 1.4514392614364624f;
  float _208 = mad(-0.2365107536315918f, _205, _207);
  float _209 = mad(-0.21492856740951538f, _206, _208);
  float _210 = _204 * -0.07655377686023712f;
  float _211 = mad(1.17622971534729f, _205, _210);
  float _212 = mad(-0.09967592358589172f, _206, _211);
  float _213 = _204 * 0.008316148072481155f;
  float _214 = mad(-0.006032449658960104f, _205, _213);
  float _215 = mad(0.9977163076400757f, _206, _214);
  float _216 = max(_209, 0.0f);
  float _217 = max(_212, 0.0f);
  float _218 = max(_215, 0.0f);
  float _219 = min(_216, 65504.0f);
  float _220 = min(_217, 65504.0f);
  float _221 = min(_218, 65504.0f);
  float _222 = _219 * 0.970889151096344f;
  float _223 = mad(0.026963284239172935f, _220, _222);
  float _224 = mad(0.0021475818939507008f, _221, _223);
  float _225 = _219 * 0.010889154858887196f;
  float _226 = mad(0.9869632720947266f, _220, _225);
  float _227 = mad(0.0021475818939507008f, _221, _226);
  float _228 = mad(0.026963284239172935f, _220, _225);
  float _229 = mad(0.9621475338935852f, _221, _228);
  float _230 = log2(_224);
  float _231 = log2(_227);
  float _232 = log2(_229);
  float _233 = _230 + 17.47393035888672f;
  float _234 = _231 + 17.47393035888672f;
  float _235 = _232 + 17.47393035888672f;
  float _236 = _233 * 0.03030303120613098f;
  float _237 = _234 * 0.03030303120613098f;
  float _238 = _235 * 0.03030303120613098f;
  uint _239 = _158.x + -1u;
  float _240 = float((uint)_239);
  float _241 = float((uint)_158.x);
  float _242 = _240 / _241;
  float _243 = 0.5f / _241;
  float _244 = _236 * _242;
  float _245 = _237 * _242;
  float _246 = _238 * _242;
  float _247 = _244 + _243;
  float _248 = _245 + _243;
  float _249 = _246 + _243;
  float4 _250 = t13_space15.SampleLevel(s2_space1, float2(_247, 0.5f), 0.0f);
  float4 _252 = t13_space15.SampleLevel(s2_space1, float2(_248, 0.5f), 0.0f);
  float4 _254 = t13_space15.SampleLevel(s2_space1, float2(_249, 0.5f), 0.0f);
  float _256 = _250.x * 3.321928024291992f;
  float _257 = _252.x * 3.321928024291992f;
  float _258 = _254.x * 3.321928024291992f;
  float _259 = exp2(_256);
  float _260 = exp2(_257);
  float _261 = exp2(_258);
  float _262 = _259 / cb3_space9_036w;
  float _263 = _260 / cb3_space9_036w;
  float _264 = _261 / cb3_space9_036w;
  bool _265 = (cb3_space9_036y < 500.0f);
  float _303;
  float _304;
  float _305;
  float _355;
  float _363;
  float _371;
  if (_265) {
    float _267 = _262 * 0.6624541878700256f;
    float _268 = mad(0.13400420546531677f, _263, _267);
    float _269 = mad(0.15618768334388733f, _264, _268);
    float _270 = _262 * 0.2722287178039551f;
    float _271 = mad(0.6740817427635193f, _263, _270);
    float _272 = mad(0.053689517080783844f, _264, _271);
    float _273 = _262 * -0.005574649665504694f;
    float _274 = mad(0.00406073359772563f, _263, _273);
    float _275 = mad(1.0103391408920288f, _264, _274);
    float _276 = _272 + _269;
    float _277 = _276 + _275;
    bool _278 = (_277 == 0.0f);
    float _279 = select(_278, 1.000000013351432e-10f, _277);
    float _280 = _269 / _279;
    float _281 = _272 / _279;
    float _282 = max(_272, 0.0f);
    float _283 = log2(_282);
    float _284 = _283 * 0.9811000227928162f;
    float _285 = exp2(_284);
    float _286 = _285 * _280;
    float _287 = max(_281, 1.000000013351432e-10f);
    float _288 = _286 / _287;
    float _289 = 1.0f - _280;
    float _290 = _289 - _281;
    float _291 = _285 * _290;
    float _292 = _291 / _287;
    float _293 = _288 * 1.6410233974456787f;
    float _294 = mad(-0.32480329275131226f, _285, _293);
    float _295 = mad(-0.23642469942569733f, _292, _294);
    float _296 = _288 * -0.663662850856781f;
    float _297 = mad(1.6153316497802734f, _285, _296);
    float _298 = mad(0.016756348311901093f, _292, _297);
    float _299 = _288 * 0.011721894145011902f;
    float _300 = mad(-0.008284442126750946f, _285, _299);
    float _301 = mad(0.9883948564529419f, _292, _300);
    _303 = _295;
    _304 = _298;
    _305 = _301;
  } else {
    _303 = _262;
    _304 = _263;
    _305 = _264;
  }
  float _306 = _303 * 1.6047539710998535f;
  float _307 = mad(-0.5310794711112976f, _304, _306);
  float _308 = mad(-0.07367203384637833f, _305, _307);
  float _309 = _303 * -0.10208318382501602f;
  float _310 = mad(1.108132243156433f, _304, _309);
  float _311 = mad(-0.006051875650882721f, _305, _310);
  float _312 = _303 * -0.0032670421060174704f;
  float _313 = mad(-0.07275524735450745f, _304, _312);
  float _314 = mad(1.0760219097137451f, _305, _313);
  float _315 = max(_308, 0.0f);
  float _316 = max(_311, 0.0f);
  float _317 = max(_314, 0.0f);
  float _318 = _315 * ATTRIBUTE_VCOLOR.x;
  float _319 = _316 * ATTRIBUTE_VCOLOR.y;
  float _320 = _317 * ATTRIBUTE_VCOLOR.z;
  float _321 = abs(_318);
  float _322 = abs(_319);
  float _323 = abs(_320);
  float _324 = log2(_321);
  float _325 = log2(_322);
  float _326 = log2(_323);
  float _327 = _324 * 0.4166666567325592f;
  float _328 = _325 * 0.4166666567325592f;
  float _329 = _326 * 0.4166666567325592f;
  float _330 = exp2(_327);
  float _331 = exp2(_328);
  float _332 = exp2(_329);
  bool _333 = isfinite(_330);
  bool _334 = isfinite(_331);
  bool _335 = isfinite(_332);
  float _336 = _330 * 1.0549999475479126f;
  float _337 = _331 * 1.0549999475479126f;
  float _338 = _332 * 1.0549999475479126f;
  float _339 = _336 + -0.054999999701976776f;
  float _340 = select(_333, _339, 0.9999999403953552f);
  float _341 = _337 + -0.054999999701976776f;
  float _342 = select(_334, _341, 0.9999999403953552f);
  float _343 = _338 + -0.054999999701976776f;
  float _344 = select(_335, _343, 0.9999999403953552f);
  float _345 = _319 * 12.920000076293945f;
  float _346 = _320 * 12.920000076293945f;
  bool _347 = (_318 > 0.0031308000907301903f);
  if (!_347) {
    float _349 = _318 * 12.920000076293945f;
    bool _350 = (_318 < 0.0031308000907301903f);
    if (!_350) {
      bool _352 = (_318 == 0.0031308000907301903f);
      if (_352) {
        _355 = _340;
      } else {
        _355 = 0.0f;
      }
    } else {
      _355 = _349;
    }
  } else {
    _355 = _340;
  }
  bool _356 = (_319 > 0.0031308000907301903f);
  if (!_356) {
    bool _358 = (_319 < 0.0031308000907301903f);
    if (!_358) {
      bool _360 = (_319 == 0.0031308000907301903f);
      if (_360) {
        _363 = _342;
      } else {
        _363 = 0.0f;
      }
    } else {
      _363 = _345;
    }
  } else {
    _363 = _342;
  }
  bool _364 = (_320 > 0.0031308000907301903f);
  if (!_364) {
    bool _366 = (_320 < 0.0031308000907301903f);
    if (!_366) {
      bool _368 = (_320 == 0.0031308000907301903f);
      if (_368) {
        _371 = _344;
      } else {
        _371 = 0.0f;
      }
    } else {
      _371 = _346;
    }
  } else {
    _371 = _344;
  }
  float _372 = dot(float3(_37, _38, _39), float3(_37, _38, _39));
  float _373 = rsqrt(_372);
  float _374 = _373 * _37;
  float _375 = _373 * _38;
  float _376 = _373 * _39;
  float _377 = _41 - cb1_space9_034x;
  bool _378 = (_377 < 0.0f);
  if (_378) discard;
  float _379 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _380 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _381 = _380 + _379;
  float _382 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _383 = _381 + _382;
  float _384 = sqrt(_383);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_145, _146, _147), 1.f);
    _355 = video.r;
    _363 = video.g;
    _371 = video.b;
  }
  float _385 = _355 * cb0_space5_008x;
  float _386 = _363 * cb0_space5_008y;
  float _387 = _371 * cb0_space5_008z;
  float _388 = _376 + -1.0f;
  float _389 = dot(float3(_374, _375, _388), float3(_374, _375, _388));
  float _390 = rsqrt(_389);
  float _391 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _392 = _391 + 0.5f;
  uint _393 = uint(_392);
  uint _394 = _393 % 13;
  float _395 = float((uint)_394);
  float _396 = _395 * 0.03846153989434242f;
  float _397 = _396 + 0.5f;
  bool _398 = (_385 < 0.0f);
  bool _399 = (_386 < 0.0f);
  bool _400 = (_387 < 0.0f);
  float _401 = select(_398, -0.0f, _385);
  float _402 = select(_399, -0.0f, _386);
  float _403 = select(_400, -0.0f, _387);
  float _404 = _374 * 0.5f;
  float _405 = _404 * _390;
  float _406 = _375 * 0.5f;
  float _407 = _406 * _390;
  float _408 = _405 + 0.5f;
  float _409 = _407 + 0.5f;
  SV_Target.x = _408;
  SV_Target.y = _409;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _401;
  SV_Target_2.y = _402;
  SV_Target_2.z = _403;
  SV_Target_2.w = _384;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _397;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
