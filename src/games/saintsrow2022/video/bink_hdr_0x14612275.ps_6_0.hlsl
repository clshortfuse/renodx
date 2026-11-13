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
    linear float3 ATTRIBUTE_POSITION_VIEW : ATTRIBUTE_POSITION_VIEW,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float4 SV_Target_3;
  float4 SV_Target_4;
  bool _13 = (SV_IsFrontFace != 0);
  float _32 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _33 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _34 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _35 = select(_13, ATTRIBUTE_NORMAL.x, _32);
  float _36 = select(_13, ATTRIBUTE_NORMAL.y, _33);
  float _37 = select(_13, ATTRIBUTE_NORMAL.z, _34);
  float _38 = max(ATTRIBUTE_VCOLOR.w, 0.0f);
  float _39 = min(1.0f, _38);
  float4 _44 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _46 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _48 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _50 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _54 = cb3_space9_038x * _46.x;
  float _56 = _54 + cb3_space9_038z;
  float _58 = cb3_space9_038y * _48.x;
  float _60 = _58 + cb3_space9_038w;
  float _61 = _50.x + _44.x;
  float _64 = cb3_space9_037x * _61;
  float _65 = _56 * 0.008609036915004253f;
  float _66 = _56 * 0.5600313544273376f;
  float _67 = _64 + _65;
  float _68 = _64 - _65;
  float _69 = _66 + _64;
  float _70 = _60 * 0.11102962493896484f;
  float _71 = _60 * 0.3206271827220917f;
  float _72 = _67 + _70;
  float _73 = _68 - _70;
  float _74 = _69 - _71;
  float _75 = max(_72, 0.0f);
  float _76 = max(_73, 0.0f);
  float _77 = max(_74, 0.0f);
  float _78 = log2(_75);
  float _79 = log2(_76);
  float _80 = log2(_77);
  float _81 = _78 * 0.012683313339948654f;
  float _82 = _79 * 0.012683313339948654f;
  float _83 = _80 * 0.012683313339948654f;
  float _84 = exp2(_81);
  float _85 = exp2(_82);
  float _86 = exp2(_83);
  float _87 = _84 + -0.8359375f;
  float _88 = _85 + -0.8359375f;
  float _89 = _86 + -0.8359375f;
  float _90 = max(0.0f, _87);
  float _91 = max(0.0f, _88);
  float _92 = max(0.0f, _89);
  float _93 = _84 * 18.6875f;
  float _94 = _85 * 18.6875f;
  float _95 = _86 * 18.6875f;
  float _96 = 18.8515625f - _93;
  float _97 = 18.8515625f - _94;
  float _98 = 18.8515625f - _95;
  float _99 = _90 / _96;
  float _100 = _91 / _97;
  float _101 = _92 / _98;
  float _102 = abs(_99);
  float _103 = abs(_100);
  float _104 = abs(_101);
  float _105 = log2(_102);
  float _106 = log2(_103);
  float _107 = log2(_104);
  float _108 = _105 * 6.277394771575928f;
  float _109 = _106 * 6.277394771575928f;
  float _110 = _107 * 6.277394771575928f;
  float _111 = exp2(_108);
  float _112 = exp2(_109);
  float _113 = exp2(_110);
  float _114 = _111 * 3.4366066455841064f;
  float _115 = _111 * 0.791329562664032f;
  float _116 = _112 * 2.5064520835876465f;
  float _117 = _112 * 1.9836004972457886f;
  float _118 = _112 * 0.09891371428966522f;
  float _119 = _114 - _116;
  float _120 = _117 - _115;
  float _121 = _111 * -0.02594989910721779f;
  float _122 = _121 - _118;
  float _123 = _113 * 0.06984542310237885f;
  float _124 = _113 * 0.192270889878273f;
  float _125 = _113 * 1.124863624572754f;
  float _126 = _119 + _123;
  float _127 = _120 - _124;
  float _128 = _122 + _125;
  float _130 = cb3_space9_037y * 368.6400146484375f;
  float _131 = _130 * _126;
  float _132 = _130 * _127;
  float _133 = _130 * _128;
  float _134 = max(_131, 9.999999747378752e-05f);
  float _135 = max(_132, 9.999999747378752e-05f);
  float _136 = max(_133, 9.999999747378752e-05f);
  float _140 = log2(_134);
  float _141 = log2(_135);
  float _142 = log2(_136);
  float _143 = _140 + 9.720000267028809f;
  float _144 = _141 + 9.720000267028809f;
  float _145 = _142 + 9.720000267028809f;
  float _146 = _143 * 0.03030303120613098f;
  float _147 = _144 * 0.03030303120613098f;
  float _148 = _145 * 0.03030303120613098f;
  float _149 = _146 + 0.23496760427951813f;
  float _150 = _147 + 0.23496760427951813f;
  float _151 = _148 + 0.23496760427951813f;
  uint3 _152;
  t40_space15.GetDimensions(_152.x, _152.y, _152.z);
  uint2 _156;
  t13_space15.GetDimensions(_156.x, _156.y);
  uint _158 = _152.x + -1u;
  uint _159 = _152.y + -1u;
  uint _160 = _152.z + -1u;
  float _161 = float((uint)_158);
  float _162 = float((uint)_159);
  float _163 = float((uint)_160);
  float _164 = float((uint)_152.x);
  float _165 = float((uint)_152.y);
  float _166 = float((uint)_152.z);
  float _167 = _161 / _164;
  float _168 = _162 / _165;
  float _169 = _163 / _166;
  float _170 = 0.5f / _164;
  float _171 = 0.5f / _165;
  float _172 = 0.5f / _166;
  float _173 = _167 * _149;
  float _174 = _168 * _150;
  float _175 = _169 * _151;
  float _176 = _170 + _173;
  float _177 = _171 + _174;
  float _178 = _172 + _175;
  float4 _179 = t40_space15.SampleLevel(s2_space1, float3(_176, _177, _178), 0.0f);
  float _182 = exp2(_140);
  float _183 = exp2(_141);
  float _184 = exp2(_142);
  float _185 = _182 * 0.6954522132873535f;
  float _186 = mad(0.14067870378494263f, _183, _185);
  float _187 = mad(0.16386906802654266f, _184, _186);
  float _188 = _182 * 0.044794563204050064f;
  float _189 = mad(0.8596711158752441f, _183, _188);
  float _190 = mad(0.0955343171954155f, _184, _189);
  float _191 = _182 * -0.005525882821530104f;
  float _192 = mad(0.004025210160762072f, _183, _191);
  float _193 = mad(1.0015007257461548f, _184, _192);
  float _194 = _179.x + 1.0f;
  float _195 = _187 * _194;
  float _196 = _190 * _194;
  float _197 = _193 * _194;
  float _198 = _195 + _179.y;
  float _199 = max(_198, 0.0f);
  float _200 = max(_196, 0.0f);
  float _201 = max(_197, 0.0f);
  float _202 = min(_199, 65536.0f);
  float _203 = min(_200, 65536.0f);
  float _204 = min(_201, 65536.0f);
  float _205 = _202 * 1.4514392614364624f;
  float _206 = mad(-0.2365107536315918f, _203, _205);
  float _207 = mad(-0.21492856740951538f, _204, _206);
  float _208 = _202 * -0.07655377686023712f;
  float _209 = mad(1.17622971534729f, _203, _208);
  float _210 = mad(-0.09967592358589172f, _204, _209);
  float _211 = _202 * 0.008316148072481155f;
  float _212 = mad(-0.006032449658960104f, _203, _211);
  float _213 = mad(0.9977163076400757f, _204, _212);
  float _214 = max(_207, 0.0f);
  float _215 = max(_210, 0.0f);
  float _216 = max(_213, 0.0f);
  float _217 = min(_214, 65504.0f);
  float _218 = min(_215, 65504.0f);
  float _219 = min(_216, 65504.0f);
  float _220 = _217 * 0.970889151096344f;
  float _221 = mad(0.026963284239172935f, _218, _220);
  float _222 = mad(0.0021475818939507008f, _219, _221);
  float _223 = _217 * 0.010889154858887196f;
  float _224 = mad(0.9869632720947266f, _218, _223);
  float _225 = mad(0.0021475818939507008f, _219, _224);
  float _226 = mad(0.026963284239172935f, _218, _223);
  float _227 = mad(0.9621475338935852f, _219, _226);
  float _228 = log2(_222);
  float _229 = log2(_225);
  float _230 = log2(_227);
  float _231 = _228 + 17.47393035888672f;
  float _232 = _229 + 17.47393035888672f;
  float _233 = _230 + 17.47393035888672f;
  float _234 = _231 * 0.03030303120613098f;
  float _235 = _232 * 0.03030303120613098f;
  float _236 = _233 * 0.03030303120613098f;
  uint _237 = _156.x + -1u;
  float _238 = float((uint)_237);
  float _239 = float((uint)_156.x);
  float _240 = _238 / _239;
  float _241 = 0.5f / _239;
  float _242 = _234 * _240;
  float _243 = _235 * _240;
  float _244 = _236 * _240;
  float _245 = _242 + _241;
  float _246 = _243 + _241;
  float _247 = _244 + _241;
  float4 _248 = t13_space15.SampleLevel(s2_space1, float2(_245, 0.5f), 0.0f);
  float4 _250 = t13_space15.SampleLevel(s2_space1, float2(_246, 0.5f), 0.0f);
  float4 _252 = t13_space15.SampleLevel(s2_space1, float2(_247, 0.5f), 0.0f);
  float _254 = _248.x * 3.321928024291992f;
  float _255 = _250.x * 3.321928024291992f;
  float _256 = _252.x * 3.321928024291992f;
  float _257 = exp2(_254);
  float _258 = exp2(_255);
  float _259 = exp2(_256);
  float _260 = _257 / cb3_space9_036w;
  float _261 = _258 / cb3_space9_036w;
  float _262 = _259 / cb3_space9_036w;
  bool _263 = (cb3_space9_036y < 500.0f);
  float _301;
  float _302;
  float _303;
  float _353;
  float _361;
  float _369;
  if (_263) {
    float _265 = _260 * 0.6624541878700256f;
    float _266 = mad(0.13400420546531677f, _261, _265);
    float _267 = mad(0.15618768334388733f, _262, _266);
    float _268 = _260 * 0.2722287178039551f;
    float _269 = mad(0.6740817427635193f, _261, _268);
    float _270 = mad(0.053689517080783844f, _262, _269);
    float _271 = _260 * -0.005574649665504694f;
    float _272 = mad(0.00406073359772563f, _261, _271);
    float _273 = mad(1.0103391408920288f, _262, _272);
    float _274 = _270 + _267;
    float _275 = _274 + _273;
    bool _276 = (_275 == 0.0f);
    float _277 = select(_276, 1.000000013351432e-10f, _275);
    float _278 = _267 / _277;
    float _279 = _270 / _277;
    float _280 = max(_270, 0.0f);
    float _281 = log2(_280);
    float _282 = _281 * 0.9811000227928162f;
    float _283 = exp2(_282);
    float _284 = _283 * _278;
    float _285 = max(_279, 1.000000013351432e-10f);
    float _286 = _284 / _285;
    float _287 = 1.0f - _278;
    float _288 = _287 - _279;
    float _289 = _283 * _288;
    float _290 = _289 / _285;
    float _291 = _286 * 1.6410233974456787f;
    float _292 = mad(-0.32480329275131226f, _283, _291);
    float _293 = mad(-0.23642469942569733f, _290, _292);
    float _294 = _286 * -0.663662850856781f;
    float _295 = mad(1.6153316497802734f, _283, _294);
    float _296 = mad(0.016756348311901093f, _290, _295);
    float _297 = _286 * 0.011721894145011902f;
    float _298 = mad(-0.008284442126750946f, _283, _297);
    float _299 = mad(0.9883948564529419f, _290, _298);
    _301 = _293;
    _302 = _296;
    _303 = _299;
  } else {
    _301 = _260;
    _302 = _261;
    _303 = _262;
  }
  float _304 = _301 * 1.6047539710998535f;
  float _305 = mad(-0.5310794711112976f, _302, _304);
  float _306 = mad(-0.07367203384637833f, _303, _305);
  float _307 = _301 * -0.10208318382501602f;
  float _308 = mad(1.108132243156433f, _302, _307);
  float _309 = mad(-0.006051875650882721f, _303, _308);
  float _310 = _301 * -0.0032670421060174704f;
  float _311 = mad(-0.07275524735450745f, _302, _310);
  float _312 = mad(1.0760219097137451f, _303, _311);
  float _313 = max(_306, 0.0f);
  float _314 = max(_309, 0.0f);
  float _315 = max(_312, 0.0f);
  float _316 = _313 * ATTRIBUTE_VCOLOR.x;
  float _317 = _314 * ATTRIBUTE_VCOLOR.y;
  float _318 = _315 * ATTRIBUTE_VCOLOR.z;
  float _319 = abs(_316);
  float _320 = abs(_317);
  float _321 = abs(_318);
  float _322 = log2(_319);
  float _323 = log2(_320);
  float _324 = log2(_321);
  float _325 = _322 * 0.4166666567325592f;
  float _326 = _323 * 0.4166666567325592f;
  float _327 = _324 * 0.4166666567325592f;
  float _328 = exp2(_325);
  float _329 = exp2(_326);
  float _330 = exp2(_327);
  bool _331 = isfinite(_328);
  bool _332 = isfinite(_329);
  bool _333 = isfinite(_330);
  float _334 = _328 * 1.0549999475479126f;
  float _335 = _329 * 1.0549999475479126f;
  float _336 = _330 * 1.0549999475479126f;
  float _337 = _334 + -0.054999999701976776f;
  float _338 = select(_331, _337, 0.9999999403953552f);
  float _339 = _335 + -0.054999999701976776f;
  float _340 = select(_332, _339, 0.9999999403953552f);
  float _341 = _336 + -0.054999999701976776f;
  float _342 = select(_333, _341, 0.9999999403953552f);
  float _343 = _317 * 12.920000076293945f;
  float _344 = _318 * 12.920000076293945f;
  bool _345 = (_316 > 0.0031308000907301903f);
  if (!_345) {
    float _347 = _316 * 12.920000076293945f;
    bool _348 = (_316 < 0.0031308000907301903f);
    if (!_348) {
      bool _350 = (_316 == 0.0031308000907301903f);
      if (_350) {
        _353 = _338;
      } else {
        _353 = 0.0f;
      }
    } else {
      _353 = _347;
    }
  } else {
    _353 = _338;
  }
  bool _354 = (_317 > 0.0031308000907301903f);
  if (!_354) {
    bool _356 = (_317 < 0.0031308000907301903f);
    if (!_356) {
      bool _358 = (_317 == 0.0031308000907301903f);
      if (_358) {
        _361 = _340;
      } else {
        _361 = 0.0f;
      }
    } else {
      _361 = _343;
    }
  } else {
    _361 = _340;
  }
  bool _362 = (_318 > 0.0031308000907301903f);
  if (!_362) {
    bool _364 = (_318 < 0.0031308000907301903f);
    if (!_364) {
      bool _366 = (_318 == 0.0031308000907301903f);
      if (_366) {
        _369 = _342;
      } else {
        _369 = 0.0f;
      }
    } else {
      _369 = _344;
    }
  } else {
    _369 = _342;
  }
  float _370 = dot(float3(_35, _36, _37), float3(_35, _36, _37));
  float _371 = rsqrt(_370);
  float _372 = _371 * _35;
  float _373 = _371 * _36;
  float _374 = _371 * _37;
  float _375 = _39 - cb1_space9_034x;
  bool _376 = (_375 < 0.0f);
  if (_376) discard;
  float _377 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _378 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _379 = _378 + _377;
  float _380 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _381 = _379 + _380;
  float _382 = sqrt(_381);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_143, _144, _145), 1.f);
    _353 = video.r;
    _361 = video.g;
    _369 = video.b;
  }
  float _383 = _353 * cb0_space5_008x;
  float _384 = _361 * cb0_space5_008y;
  float _385 = _369 * cb0_space5_008z;
  float _386 = _374 + -1.0f;
  float _387 = dot(float3(_372, _373, _386), float3(_372, _373, _386));
  float _388 = rsqrt(_387);
  float _389 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _390 = _389 + 0.5f;
  uint _391 = uint(_390);
  uint _392 = _391 % 13;
  float _393 = float((uint)_392);
  float _394 = _393 * 0.03846153989434242f;
  float _395 = _394 + 0.5f;
  bool _396 = (_383 < 0.0f);
  bool _397 = (_384 < 0.0f);
  bool _398 = (_385 < 0.0f);
  float _399 = select(_396, -0.0f, _383);
  float _400 = select(_397, -0.0f, _384);
  float _401 = select(_398, -0.0f, _385);
  float _402 = _372 * 0.5f;
  float _403 = _402 * _388;
  float _404 = _373 * 0.5f;
  float _405 = _404 * _388;
  float _406 = _403 + 0.5f;
  float _407 = _405 + 0.5f;
  SV_Target.x = _406;
  SV_Target.y = _407;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _399;
  SV_Target_2.y = _400;
  SV_Target_2.z = _401;
  SV_Target_2.w = _382;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _395;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
