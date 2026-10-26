#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr_alpha: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

Texture3D<float4> t40_space15 : register(t40, space15);

Texture2D<float4> t13_space15 : register(t13, space15);

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

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
  bool _14 = (SV_IsFrontFace != 0);
  float _33 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _34 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _35 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _36 = select(_14, ATTRIBUTE_NORMAL.x, _33);
  float _37 = select(_14, ATTRIBUTE_NORMAL.y, _34);
  float _38 = select(_14, ATTRIBUTE_NORMAL.z, _35);
  float4 _41 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _43 = _41.x * ATTRIBUTE_VCOLOR.w;
  float _44 = max(_43, 0.0f);
  float _45 = min(1.0f, _44);
  float4 _48 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _50 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _52 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _54 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _58 = cb3_space9_038x * _50.x;
  float _60 = _58 + cb3_space9_038z;
  float _62 = cb3_space9_038y * _52.x;
  float _64 = _62 + cb3_space9_038w;
  float _65 = _54.x + _48.x;
  float _68 = cb3_space9_037x * _65;
  float _69 = _60 * 0.008609036915004253f;
  float _70 = _60 * 0.5600313544273376f;
  float _71 = _68 + _69;
  float _72 = _68 - _69;
  float _73 = _70 + _68;
  float _74 = _64 * 0.11102962493896484f;
  float _75 = _64 * 0.3206271827220917f;
  float _76 = _71 + _74;
  float _77 = _72 - _74;
  float _78 = _73 - _75;
  float _79 = max(_76, 0.0f);
  float _80 = max(_77, 0.0f);
  float _81 = max(_78, 0.0f);
  float _82 = log2(_79);
  float _83 = log2(_80);
  float _84 = log2(_81);
  float _85 = _82 * 0.012683313339948654f;
  float _86 = _83 * 0.012683313339948654f;
  float _87 = _84 * 0.012683313339948654f;
  float _88 = exp2(_85);
  float _89 = exp2(_86);
  float _90 = exp2(_87);
  float _91 = _88 + -0.8359375f;
  float _92 = _89 + -0.8359375f;
  float _93 = _90 + -0.8359375f;
  float _94 = max(0.0f, _91);
  float _95 = max(0.0f, _92);
  float _96 = max(0.0f, _93);
  float _97 = _88 * 18.6875f;
  float _98 = _89 * 18.6875f;
  float _99 = _90 * 18.6875f;
  float _100 = 18.8515625f - _97;
  float _101 = 18.8515625f - _98;
  float _102 = 18.8515625f - _99;
  float _103 = _94 / _100;
  float _104 = _95 / _101;
  float _105 = _96 / _102;
  float _106 = abs(_103);
  float _107 = abs(_104);
  float _108 = abs(_105);
  float _109 = log2(_106);
  float _110 = log2(_107);
  float _111 = log2(_108);
  float _112 = _109 * 6.277394771575928f;
  float _113 = _110 * 6.277394771575928f;
  float _114 = _111 * 6.277394771575928f;
  float _115 = exp2(_112);
  float _116 = exp2(_113);
  float _117 = exp2(_114);
  float _118 = _115 * 3.4366066455841064f;
  float _119 = _115 * 0.791329562664032f;
  float _120 = _116 * 2.5064520835876465f;
  float _121 = _116 * 1.9836004972457886f;
  float _122 = _116 * 0.09891371428966522f;
  float _123 = _118 - _120;
  float _124 = _121 - _119;
  float _125 = _115 * -0.02594989910721779f;
  float _126 = _125 - _122;
  float _127 = _117 * 0.06984542310237885f;
  float _128 = _117 * 0.192270889878273f;
  float _129 = _117 * 1.124863624572754f;
  float _130 = _123 + _127;
  float _131 = _124 - _128;
  float _132 = _126 + _129;
  float _134 = cb3_space9_037y * 368.6400146484375f;
  float _135 = _134 * _130;
  float _136 = _134 * _131;
  float _137 = _134 * _132;
  float _138 = max(_135, 9.999999747378752e-05f);
  float _139 = max(_136, 9.999999747378752e-05f);
  float _140 = max(_137, 9.999999747378752e-05f);
  float _144 = log2(_138);
  float _145 = log2(_139);
  float _146 = log2(_140);
  float _147 = _144 + 9.720000267028809f;
  float _148 = _145 + 9.720000267028809f;
  float _149 = _146 + 9.720000267028809f;
  float _150 = _147 * 0.03030303120613098f;
  float _151 = _148 * 0.03030303120613098f;
  float _152 = _149 * 0.03030303120613098f;
  float _153 = _150 + 0.23496760427951813f;
  float _154 = _151 + 0.23496760427951813f;
  float _155 = _152 + 0.23496760427951813f;
  uint3 _156;
  t40_space15.GetDimensions(_156.x, _156.y, _156.z);
  uint2 _160;
  t13_space15.GetDimensions(_160.x, _160.y);
  uint _162 = _156.x + -1u;
  uint _163 = _156.y + -1u;
  uint _164 = _156.z + -1u;
  float _165 = float((uint)_162);
  float _166 = float((uint)_163);
  float _167 = float((uint)_164);
  float _168 = float((uint)_156.x);
  float _169 = float((uint)_156.y);
  float _170 = float((uint)_156.z);
  float _171 = _165 / _168;
  float _172 = _166 / _169;
  float _173 = _167 / _170;
  float _174 = 0.5f / _168;
  float _175 = 0.5f / _169;
  float _176 = 0.5f / _170;
  float _177 = _171 * _153;
  float _178 = _172 * _154;
  float _179 = _173 * _155;
  float _180 = _174 + _177;
  float _181 = _175 + _178;
  float _182 = _176 + _179;
  float4 _183 = t40_space15.SampleLevel(s2_space1, float3(_180, _181, _182), 0.0f);
  float _186 = exp2(_144);
  float _187 = exp2(_145);
  float _188 = exp2(_146);
  float _189 = _186 * 0.6954522132873535f;
  float _190 = mad(0.14067870378494263f, _187, _189);
  float _191 = mad(0.16386906802654266f, _188, _190);
  float _192 = _186 * 0.044794563204050064f;
  float _193 = mad(0.8596711158752441f, _187, _192);
  float _194 = mad(0.0955343171954155f, _188, _193);
  float _195 = _186 * -0.005525882821530104f;
  float _196 = mad(0.004025210160762072f, _187, _195);
  float _197 = mad(1.0015007257461548f, _188, _196);
  float _198 = _183.x + 1.0f;
  float _199 = _191 * _198;
  float _200 = _194 * _198;
  float _201 = _197 * _198;
  float _202 = _199 + _183.y;
  float _203 = max(_202, 0.0f);
  float _204 = max(_200, 0.0f);
  float _205 = max(_201, 0.0f);
  float _206 = min(_203, 65536.0f);
  float _207 = min(_204, 65536.0f);
  float _208 = min(_205, 65536.0f);
  float _209 = _206 * 1.4514392614364624f;
  float _210 = mad(-0.2365107536315918f, _207, _209);
  float _211 = mad(-0.21492856740951538f, _208, _210);
  float _212 = _206 * -0.07655377686023712f;
  float _213 = mad(1.17622971534729f, _207, _212);
  float _214 = mad(-0.09967592358589172f, _208, _213);
  float _215 = _206 * 0.008316148072481155f;
  float _216 = mad(-0.006032449658960104f, _207, _215);
  float _217 = mad(0.9977163076400757f, _208, _216);
  float _218 = max(_211, 0.0f);
  float _219 = max(_214, 0.0f);
  float _220 = max(_217, 0.0f);
  float _221 = min(_218, 65504.0f);
  float _222 = min(_219, 65504.0f);
  float _223 = min(_220, 65504.0f);
  float _224 = _221 * 0.970889151096344f;
  float _225 = mad(0.026963284239172935f, _222, _224);
  float _226 = mad(0.0021475818939507008f, _223, _225);
  float _227 = _221 * 0.010889154858887196f;
  float _228 = mad(0.9869632720947266f, _222, _227);
  float _229 = mad(0.0021475818939507008f, _223, _228);
  float _230 = mad(0.026963284239172935f, _222, _227);
  float _231 = mad(0.9621475338935852f, _223, _230);
  float _232 = log2(_226);
  float _233 = log2(_229);
  float _234 = log2(_231);
  float _235 = _232 + 17.47393035888672f;
  float _236 = _233 + 17.47393035888672f;
  float _237 = _234 + 17.47393035888672f;
  float _238 = _235 * 0.03030303120613098f;
  float _239 = _236 * 0.03030303120613098f;
  float _240 = _237 * 0.03030303120613098f;
  uint _241 = _160.x + -1u;
  float _242 = float((uint)_241);
  float _243 = float((uint)_160.x);
  float _244 = _242 / _243;
  float _245 = 0.5f / _243;
  float _246 = _238 * _244;
  float _247 = _239 * _244;
  float _248 = _240 * _244;
  float _249 = _246 + _245;
  float _250 = _247 + _245;
  float _251 = _248 + _245;
  float4 _252 = t13_space15.SampleLevel(s2_space1, float2(_249, 0.5f), 0.0f);
  float4 _254 = t13_space15.SampleLevel(s2_space1, float2(_250, 0.5f), 0.0f);
  float4 _256 = t13_space15.SampleLevel(s2_space1, float2(_251, 0.5f), 0.0f);
  float _258 = _252.x * 3.321928024291992f;
  float _259 = _254.x * 3.321928024291992f;
  float _260 = _256.x * 3.321928024291992f;
  float _261 = exp2(_258);
  float _262 = exp2(_259);
  float _263 = exp2(_260);
  float _264 = _261 / cb3_space9_036w;
  float _265 = _262 / cb3_space9_036w;
  float _266 = _263 / cb3_space9_036w;
  bool _267 = (cb3_space9_036y < 500.0f);
  float _305;
  float _306;
  float _307;
  float _357;
  float _365;
  float _373;
  if (_267) {
    float _269 = _264 * 0.6624541878700256f;
    float _270 = mad(0.13400420546531677f, _265, _269);
    float _271 = mad(0.15618768334388733f, _266, _270);
    float _272 = _264 * 0.2722287178039551f;
    float _273 = mad(0.6740817427635193f, _265, _272);
    float _274 = mad(0.053689517080783844f, _266, _273);
    float _275 = _264 * -0.005574649665504694f;
    float _276 = mad(0.00406073359772563f, _265, _275);
    float _277 = mad(1.0103391408920288f, _266, _276);
    float _278 = _274 + _271;
    float _279 = _278 + _277;
    bool _280 = (_279 == 0.0f);
    float _281 = select(_280, 1.000000013351432e-10f, _279);
    float _282 = _271 / _281;
    float _283 = _274 / _281;
    float _284 = max(_274, 0.0f);
    float _285 = log2(_284);
    float _286 = _285 * 0.9811000227928162f;
    float _287 = exp2(_286);
    float _288 = _287 * _282;
    float _289 = max(_283, 1.000000013351432e-10f);
    float _290 = _288 / _289;
    float _291 = 1.0f - _282;
    float _292 = _291 - _283;
    float _293 = _287 * _292;
    float _294 = _293 / _289;
    float _295 = _290 * 1.6410233974456787f;
    float _296 = mad(-0.32480329275131226f, _287, _295);
    float _297 = mad(-0.23642469942569733f, _294, _296);
    float _298 = _290 * -0.663662850856781f;
    float _299 = mad(1.6153316497802734f, _287, _298);
    float _300 = mad(0.016756348311901093f, _294, _299);
    float _301 = _290 * 0.011721894145011902f;
    float _302 = mad(-0.008284442126750946f, _287, _301);
    float _303 = mad(0.9883948564529419f, _294, _302);
    _305 = _297;
    _306 = _300;
    _307 = _303;
  } else {
    _305 = _264;
    _306 = _265;
    _307 = _266;
  }
  float _308 = _305 * 1.6047539710998535f;
  float _309 = mad(-0.5310794711112976f, _306, _308);
  float _310 = mad(-0.07367203384637833f, _307, _309);
  float _311 = _305 * -0.10208318382501602f;
  float _312 = mad(1.108132243156433f, _306, _311);
  float _313 = mad(-0.006051875650882721f, _307, _312);
  float _314 = _305 * -0.0032670421060174704f;
  float _315 = mad(-0.07275524735450745f, _306, _314);
  float _316 = mad(1.0760219097137451f, _307, _315);
  float _317 = max(_310, 0.0f);
  float _318 = max(_313, 0.0f);
  float _319 = max(_316, 0.0f);
  float _320 = _317 * ATTRIBUTE_VCOLOR.x;
  float _321 = _318 * ATTRIBUTE_VCOLOR.y;
  float _322 = _319 * ATTRIBUTE_VCOLOR.z;
  float _323 = abs(_320);
  float _324 = abs(_321);
  float _325 = abs(_322);
  float _326 = log2(_323);
  float _327 = log2(_324);
  float _328 = log2(_325);
  float _329 = _326 * 0.4166666567325592f;
  float _330 = _327 * 0.4166666567325592f;
  float _331 = _328 * 0.4166666567325592f;
  float _332 = exp2(_329);
  float _333 = exp2(_330);
  float _334 = exp2(_331);
  bool _335 = isfinite(_332);
  bool _336 = isfinite(_333);
  bool _337 = isfinite(_334);
  float _338 = _332 * 1.0549999475479126f;
  float _339 = _333 * 1.0549999475479126f;
  float _340 = _334 * 1.0549999475479126f;
  float _341 = _338 + -0.054999999701976776f;
  float _342 = select(_335, _341, 0.9999999403953552f);
  float _343 = _339 + -0.054999999701976776f;
  float _344 = select(_336, _343, 0.9999999403953552f);
  float _345 = _340 + -0.054999999701976776f;
  float _346 = select(_337, _345, 0.9999999403953552f);
  float _347 = _321 * 12.920000076293945f;
  float _348 = _322 * 12.920000076293945f;
  bool _349 = (_320 > 0.0031308000907301903f);
  if (!_349) {
    float _351 = _320 * 12.920000076293945f;
    bool _352 = (_320 < 0.0031308000907301903f);
    if (!_352) {
      bool _354 = (_320 == 0.0031308000907301903f);
      if (_354) {
        _357 = _342;
      } else {
        _357 = 0.0f;
      }
    } else {
      _357 = _351;
    }
  } else {
    _357 = _342;
  }
  bool _358 = (_321 > 0.0031308000907301903f);
  if (!_358) {
    bool _360 = (_321 < 0.0031308000907301903f);
    if (!_360) {
      bool _362 = (_321 == 0.0031308000907301903f);
      if (_362) {
        _365 = _344;
      } else {
        _365 = 0.0f;
      }
    } else {
      _365 = _347;
    }
  } else {
    _365 = _344;
  }
  bool _366 = (_322 > 0.0031308000907301903f);
  if (!_366) {
    bool _368 = (_322 < 0.0031308000907301903f);
    if (!_368) {
      bool _370 = (_322 == 0.0031308000907301903f);
      if (_370) {
        _373 = _346;
      } else {
        _373 = 0.0f;
      }
    } else {
      _373 = _348;
    }
  } else {
    _373 = _346;
  }
  float _374 = dot(float3(_36, _37, _38), float3(_36, _37, _38));
  float _375 = rsqrt(_374);
  float _376 = _375 * _36;
  float _377 = _375 * _37;
  float _378 = _375 * _38;
  float _379 = _45 - cb1_space9_034x;
  bool _380 = (_379 < 0.0f);
  if (_380) discard;
  float _381 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _382 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _383 = _382 + _381;
  float _384 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _385 = _383 + _384;
  float _386 = sqrt(_385);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_147, _148, _149), 1.f);
    _357 = video.r;
    _365 = video.g;
    _373 = video.b;
  }
  float _387 = _357 * cb0_space5_008x;
  float _388 = _365 * cb0_space5_008y;
  float _389 = _373 * cb0_space5_008z;
  float _390 = _378 + -1.0f;
  float _391 = dot(float3(_376, _377, _390), float3(_376, _377, _390));
  float _392 = rsqrt(_391);
  float _393 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _394 = _393 + 0.5f;
  uint _395 = uint(_394);
  uint _396 = _395 % 13;
  float _397 = float((uint)_396);
  float _398 = _397 * 0.03846153989434242f;
  float _399 = _398 + 0.5f;
  bool _400 = (_387 < 0.0f);
  bool _401 = (_388 < 0.0f);
  bool _402 = (_389 < 0.0f);
  float _403 = select(_400, -0.0f, _387);
  float _404 = select(_401, -0.0f, _388);
  float _405 = select(_402, -0.0f, _389);
  float _406 = _376 * 0.5f;
  float _407 = _406 * _392;
  float _408 = _377 * 0.5f;
  float _409 = _408 * _392;
  float _410 = _407 + 0.5f;
  float _411 = _409 + 0.5f;
  SV_Target.x = _410;
  SV_Target.y = _411;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _403;
  SV_Target_2.y = _404;
  SV_Target_2.z = _405;
  SV_Target_2.w = _386;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _399;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
