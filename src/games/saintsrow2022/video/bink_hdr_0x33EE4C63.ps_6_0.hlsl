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
    linear float ATTRIBUTE_OBJECT_ID : ATTRIBUTE_OBJECT_ID,
    linear float ATTRIBUTE_LIGHT_MASK : ATTRIBUTE_LIGHT_MASK,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    linear float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    linear float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    linear float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
    linear float3 ATTRIBUTE_POSITION_VIEW : ATTRIBUTE_POSITION_VIEW,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float4 SV_Target_3;
  float4 SV_Target_4;
  bool _13 = (SV_IsFrontFace != 0);
  float _35 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _36 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _37 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _38 = select(_13, ATTRIBUTE_NORMAL.x, _35);
  float _39 = select(_13, ATTRIBUTE_NORMAL.y, _36);
  float _40 = select(_13, ATTRIBUTE_NORMAL.z, _37);
  float _41 = max(ATTRIBUTE_VCOLOR.w, 0.0f);
  float _42 = min(1.0f, _41);
  float4 _47 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _49 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _51 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _53 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _57 = cb3_space9_038x * _49.x;
  float _59 = _57 + cb3_space9_038z;
  float _61 = cb3_space9_038y * _51.x;
  float _63 = _61 + cb3_space9_038w;
  float _64 = _53.x + _47.x;
  float _67 = cb3_space9_037x * _64;
  float _68 = _59 * 0.008609036915004253f;
  float _69 = _59 * 0.5600313544273376f;
  float _70 = _67 + _68;
  float _71 = _67 - _68;
  float _72 = _69 + _67;
  float _73 = _63 * 0.11102962493896484f;
  float _74 = _63 * 0.3206271827220917f;
  float _75 = _70 + _73;
  float _76 = _71 - _73;
  float _77 = _72 - _74;
  float _78 = max(_75, 0.0f);
  float _79 = max(_76, 0.0f);
  float _80 = max(_77, 0.0f);
  float _81 = log2(_78);
  float _82 = log2(_79);
  float _83 = log2(_80);
  float _84 = _81 * 0.012683313339948654f;
  float _85 = _82 * 0.012683313339948654f;
  float _86 = _83 * 0.012683313339948654f;
  float _87 = exp2(_84);
  float _88 = exp2(_85);
  float _89 = exp2(_86);
  float _90 = _87 + -0.8359375f;
  float _91 = _88 + -0.8359375f;
  float _92 = _89 + -0.8359375f;
  float _93 = max(0.0f, _90);
  float _94 = max(0.0f, _91);
  float _95 = max(0.0f, _92);
  float _96 = _87 * 18.6875f;
  float _97 = _88 * 18.6875f;
  float _98 = _89 * 18.6875f;
  float _99 = 18.8515625f - _96;
  float _100 = 18.8515625f - _97;
  float _101 = 18.8515625f - _98;
  float _102 = _93 / _99;
  float _103 = _94 / _100;
  float _104 = _95 / _101;
  float _105 = abs(_102);
  float _106 = abs(_103);
  float _107 = abs(_104);
  float _108 = log2(_105);
  float _109 = log2(_106);
  float _110 = log2(_107);
  float _111 = _108 * 6.277394771575928f;
  float _112 = _109 * 6.277394771575928f;
  float _113 = _110 * 6.277394771575928f;
  float _114 = exp2(_111);
  float _115 = exp2(_112);
  float _116 = exp2(_113);
  float _117 = _114 * 3.4366066455841064f;
  float _118 = _114 * 0.791329562664032f;
  float _119 = _115 * 2.5064520835876465f;
  float _120 = _115 * 1.9836004972457886f;
  float _121 = _115 * 0.09891371428966522f;
  float _122 = _117 - _119;
  float _123 = _120 - _118;
  float _124 = _114 * -0.02594989910721779f;
  float _125 = _124 - _121;
  float _126 = _116 * 0.06984542310237885f;
  float _127 = _116 * 0.192270889878273f;
  float _128 = _116 * 1.124863624572754f;
  float _129 = _122 + _126;
  float _130 = _123 - _127;
  float _131 = _125 + _128;
  float _133 = cb3_space9_037y * 368.6400146484375f;
  float _134 = _133 * _129;
  float _135 = _133 * _130;
  float _136 = _133 * _131;
  float _137 = max(_134, 9.999999747378752e-05f);
  float _138 = max(_135, 9.999999747378752e-05f);
  float _139 = max(_136, 9.999999747378752e-05f);
  float _143 = log2(_137);
  float _144 = log2(_138);
  float _145 = log2(_139);
  float _146 = _143 + 9.720000267028809f;
  float _147 = _144 + 9.720000267028809f;
  float _148 = _145 + 9.720000267028809f;
  float _149 = _146 * 0.03030303120613098f;
  float _150 = _147 * 0.03030303120613098f;
  float _151 = _148 * 0.03030303120613098f;
  float _152 = _149 + 0.23496760427951813f;
  float _153 = _150 + 0.23496760427951813f;
  float _154 = _151 + 0.23496760427951813f;
  uint3 _155;
  t40_space15.GetDimensions(_155.x, _155.y, _155.z);
  uint2 _159;
  t13_space15.GetDimensions(_159.x, _159.y);
  uint _161 = _155.x + -1u;
  uint _162 = _155.y + -1u;
  uint _163 = _155.z + -1u;
  float _164 = float((uint)_161);
  float _165 = float((uint)_162);
  float _166 = float((uint)_163);
  float _167 = float((uint)_155.x);
  float _168 = float((uint)_155.y);
  float _169 = float((uint)_155.z);
  float _170 = _164 / _167;
  float _171 = _165 / _168;
  float _172 = _166 / _169;
  float _173 = 0.5f / _167;
  float _174 = 0.5f / _168;
  float _175 = 0.5f / _169;
  float _176 = _170 * _152;
  float _177 = _171 * _153;
  float _178 = _172 * _154;
  float _179 = _173 + _176;
  float _180 = _174 + _177;
  float _181 = _175 + _178;
  float4 _182 = t40_space15.SampleLevel(s2_space1, float3(_179, _180, _181), 0.0f);
  float _185 = exp2(_143);
  float _186 = exp2(_144);
  float _187 = exp2(_145);
  float _188 = _185 * 0.6954522132873535f;
  float _189 = mad(0.14067870378494263f, _186, _188);
  float _190 = mad(0.16386906802654266f, _187, _189);
  float _191 = _185 * 0.044794563204050064f;
  float _192 = mad(0.8596711158752441f, _186, _191);
  float _193 = mad(0.0955343171954155f, _187, _192);
  float _194 = _185 * -0.005525882821530104f;
  float _195 = mad(0.004025210160762072f, _186, _194);
  float _196 = mad(1.0015007257461548f, _187, _195);
  float _197 = _182.x + 1.0f;
  float _198 = _190 * _197;
  float _199 = _193 * _197;
  float _200 = _196 * _197;
  float _201 = _198 + _182.y;
  float _202 = max(_201, 0.0f);
  float _203 = max(_199, 0.0f);
  float _204 = max(_200, 0.0f);
  float _205 = min(_202, 65536.0f);
  float _206 = min(_203, 65536.0f);
  float _207 = min(_204, 65536.0f);
  float _208 = _205 * 1.4514392614364624f;
  float _209 = mad(-0.2365107536315918f, _206, _208);
  float _210 = mad(-0.21492856740951538f, _207, _209);
  float _211 = _205 * -0.07655377686023712f;
  float _212 = mad(1.17622971534729f, _206, _211);
  float _213 = mad(-0.09967592358589172f, _207, _212);
  float _214 = _205 * 0.008316148072481155f;
  float _215 = mad(-0.006032449658960104f, _206, _214);
  float _216 = mad(0.9977163076400757f, _207, _215);
  float _217 = max(_210, 0.0f);
  float _218 = max(_213, 0.0f);
  float _219 = max(_216, 0.0f);
  float _220 = min(_217, 65504.0f);
  float _221 = min(_218, 65504.0f);
  float _222 = min(_219, 65504.0f);
  float _223 = _220 * 0.970889151096344f;
  float _224 = mad(0.026963284239172935f, _221, _223);
  float _225 = mad(0.0021475818939507008f, _222, _224);
  float _226 = _220 * 0.010889154858887196f;
  float _227 = mad(0.9869632720947266f, _221, _226);
  float _228 = mad(0.0021475818939507008f, _222, _227);
  float _229 = mad(0.026963284239172935f, _221, _226);
  float _230 = mad(0.9621475338935852f, _222, _229);
  float _231 = log2(_225);
  float _232 = log2(_228);
  float _233 = log2(_230);
  float _234 = _231 + 17.47393035888672f;
  float _235 = _232 + 17.47393035888672f;
  float _236 = _233 + 17.47393035888672f;
  float _237 = _234 * 0.03030303120613098f;
  float _238 = _235 * 0.03030303120613098f;
  float _239 = _236 * 0.03030303120613098f;
  uint _240 = _159.x + -1u;
  float _241 = float((uint)_240);
  float _242 = float((uint)_159.x);
  float _243 = _241 / _242;
  float _244 = 0.5f / _242;
  float _245 = _237 * _243;
  float _246 = _238 * _243;
  float _247 = _239 * _243;
  float _248 = _245 + _244;
  float _249 = _246 + _244;
  float _250 = _247 + _244;
  float4 _251 = t13_space15.SampleLevel(s2_space1, float2(_248, 0.5f), 0.0f);
  float4 _253 = t13_space15.SampleLevel(s2_space1, float2(_249, 0.5f), 0.0f);
  float4 _255 = t13_space15.SampleLevel(s2_space1, float2(_250, 0.5f), 0.0f);
  float _257 = _251.x * 3.321928024291992f;
  float _258 = _253.x * 3.321928024291992f;
  float _259 = _255.x * 3.321928024291992f;
  float _260 = exp2(_257);
  float _261 = exp2(_258);
  float _262 = exp2(_259);
  float _263 = _260 / cb3_space9_036w;
  float _264 = _261 / cb3_space9_036w;
  float _265 = _262 / cb3_space9_036w;
  bool _266 = (cb3_space9_036y < 500.0f);
  float _304;
  float _305;
  float _306;
  float _356;
  float _364;
  float _372;
  if (_266) {
    float _268 = _263 * 0.6624541878700256f;
    float _269 = mad(0.13400420546531677f, _264, _268);
    float _270 = mad(0.15618768334388733f, _265, _269);
    float _271 = _263 * 0.2722287178039551f;
    float _272 = mad(0.6740817427635193f, _264, _271);
    float _273 = mad(0.053689517080783844f, _265, _272);
    float _274 = _263 * -0.005574649665504694f;
    float _275 = mad(0.00406073359772563f, _264, _274);
    float _276 = mad(1.0103391408920288f, _265, _275);
    float _277 = _273 + _270;
    float _278 = _277 + _276;
    bool _279 = (_278 == 0.0f);
    float _280 = select(_279, 1.000000013351432e-10f, _278);
    float _281 = _270 / _280;
    float _282 = _273 / _280;
    float _283 = max(_273, 0.0f);
    float _284 = log2(_283);
    float _285 = _284 * 0.9811000227928162f;
    float _286 = exp2(_285);
    float _287 = _286 * _281;
    float _288 = max(_282, 1.000000013351432e-10f);
    float _289 = _287 / _288;
    float _290 = 1.0f - _281;
    float _291 = _290 - _282;
    float _292 = _286 * _291;
    float _293 = _292 / _288;
    float _294 = _289 * 1.6410233974456787f;
    float _295 = mad(-0.32480329275131226f, _286, _294);
    float _296 = mad(-0.23642469942569733f, _293, _295);
    float _297 = _289 * -0.663662850856781f;
    float _298 = mad(1.6153316497802734f, _286, _297);
    float _299 = mad(0.016756348311901093f, _293, _298);
    float _300 = _289 * 0.011721894145011902f;
    float _301 = mad(-0.008284442126750946f, _286, _300);
    float _302 = mad(0.9883948564529419f, _293, _301);
    _304 = _296;
    _305 = _299;
    _306 = _302;
  } else {
    _304 = _263;
    _305 = _264;
    _306 = _265;
  }
  float _307 = _304 * 1.6047539710998535f;
  float _308 = mad(-0.5310794711112976f, _305, _307);
  float _309 = mad(-0.07367203384637833f, _306, _308);
  float _310 = _304 * -0.10208318382501602f;
  float _311 = mad(1.108132243156433f, _305, _310);
  float _312 = mad(-0.006051875650882721f, _306, _311);
  float _313 = _304 * -0.0032670421060174704f;
  float _314 = mad(-0.07275524735450745f, _305, _313);
  float _315 = mad(1.0760219097137451f, _306, _314);
  float _316 = max(_309, 0.0f);
  float _317 = max(_312, 0.0f);
  float _318 = max(_315, 0.0f);
  float _319 = _316 * ATTRIBUTE_VCOLOR.x;
  float _320 = _317 * ATTRIBUTE_VCOLOR.y;
  float _321 = _318 * ATTRIBUTE_VCOLOR.z;
  float _322 = abs(_319);
  float _323 = abs(_320);
  float _324 = abs(_321);
  float _325 = log2(_322);
  float _326 = log2(_323);
  float _327 = log2(_324);
  float _328 = _325 * 0.4166666567325592f;
  float _329 = _326 * 0.4166666567325592f;
  float _330 = _327 * 0.4166666567325592f;
  float _331 = exp2(_328);
  float _332 = exp2(_329);
  float _333 = exp2(_330);
  bool _334 = isfinite(_331);
  bool _335 = isfinite(_332);
  bool _336 = isfinite(_333);
  float _337 = _331 * 1.0549999475479126f;
  float _338 = _332 * 1.0549999475479126f;
  float _339 = _333 * 1.0549999475479126f;
  float _340 = _337 + -0.054999999701976776f;
  float _341 = select(_334, _340, 0.9999999403953552f);
  float _342 = _338 + -0.054999999701976776f;
  float _343 = select(_335, _342, 0.9999999403953552f);
  float _344 = _339 + -0.054999999701976776f;
  float _345 = select(_336, _344, 0.9999999403953552f);
  float _346 = _320 * 12.920000076293945f;
  float _347 = _321 * 12.920000076293945f;
  bool _348 = (_319 > 0.0031308000907301903f);
  if (!_348) {
    float _350 = _319 * 12.920000076293945f;
    bool _351 = (_319 < 0.0031308000907301903f);
    if (!_351) {
      bool _353 = (_319 == 0.0031308000907301903f);
      if (_353) {
        _356 = _341;
      } else {
        _356 = 0.0f;
      }
    } else {
      _356 = _350;
    }
  } else {
    _356 = _341;
  }
  bool _357 = (_320 > 0.0031308000907301903f);
  if (!_357) {
    bool _359 = (_320 < 0.0031308000907301903f);
    if (!_359) {
      bool _361 = (_320 == 0.0031308000907301903f);
      if (_361) {
        _364 = _343;
      } else {
        _364 = 0.0f;
      }
    } else {
      _364 = _346;
    }
  } else {
    _364 = _343;
  }
  bool _365 = (_321 > 0.0031308000907301903f);
  if (!_365) {
    bool _367 = (_321 < 0.0031308000907301903f);
    if (!_367) {
      bool _369 = (_321 == 0.0031308000907301903f);
      if (_369) {
        _372 = _345;
      } else {
        _372 = 0.0f;
      }
    } else {
      _372 = _347;
    }
  } else {
    _372 = _345;
  }
  float _373 = dot(float3(_38, _39, _40), float3(_38, _39, _40));
  float _374 = rsqrt(_373);
  float _375 = _374 * _38;
  float _376 = _374 * _39;
  float _377 = _374 * _40;
  float _378 = _42 - cb1_space9_034x;
  bool _379 = (_378 < 0.0f);
  if (_379) discard;
  float _380 = SV_Position.y * SV_Position.x;
  float _381 = _380 + SV_Position.x;
  int _382 = int(_381);
  int _383 = _382 ^ 123459876;
  int _384 = _383 / 127773;
  uint _385 = _384 * -127773;
  uint _386 = _385 + _383;
  uint _387 = _386 * 16807;
  int _388 = _384 * -2836;
  uint _389 = _387 + _388;
  bool _390 = ((int)_389 < (int)0);
  int _391 = _389 + 2147483647;
  int _392 = select(_390, _391, _389);
  int _393 = _392 / 127773;
  uint _394 = _393 * -127773;
  uint _395 = _392 + _394;
  uint _396 = _395 * 16807;
  int _397 = _393 * -2836;
  uint _398 = _396 + _397;
  bool _399 = ((int)_398 < (int)0);
  int _400 = _398 + 2147483647;
  int _401 = select(_399, _400, _398);
  float _402 = float((int)(_401));
  float _403 = _402 * 4.656612873077393e-10f;
  float _404 = ATTRIBUTE_INSTANCE_PARAMS.w + -1.0f;
  float _405 = _404 + _403;
  bool _406 = (_405 < 0.0f);
  if (_406) discard;
  float _407 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _408 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _409 = _408 + _407;
  float _410 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _411 = _409 + _410;
  float _412 = sqrt(_411);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_146, _147, _148), 1.f);
    _356 = video.r;
    _364 = video.g;
    _372 = video.b;
  }
  float _413 = _356 * cb0_space5_008x;
  float _414 = _364 * cb0_space5_008y;
  float _415 = _372 * cb0_space5_008z;
  float _416 = _377 + -1.0f;
  float _417 = dot(float3(_375, _376, _416), float3(_375, _376, _416));
  float _418 = rsqrt(_417);
  float _419 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _420 = _419 + 0.5f;
  uint _421 = uint(_420);
  uint _422 = _421 % 13;
  float _423 = float((uint)_422);
  float _424 = _423 * 0.03846153989434242f;
  bool _425 = (_413 < 0.0f);
  bool _426 = (_414 < 0.0f);
  bool _427 = (_415 < 0.0f);
  float _428 = select(_425, -0.0f, _413);
  float _429 = select(_426, -0.0f, _414);
  float _430 = select(_427, -0.0f, _415);
  float _431 = _375 * 0.5f;
  float _432 = _431 * _418;
  float _433 = _376 * 0.5f;
  float _434 = _433 * _418;
  float _435 = _432 + 0.5f;
  float _436 = _434 + 0.5f;
  SV_Target.x = _435;
  SV_Target.y = _436;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _428;
  SV_Target_2.y = _429;
  SV_Target_2.z = _430;
  SV_Target_2.w = _412;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _424;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
