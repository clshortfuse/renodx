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
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
    linear float3 ATTRIBUTE_POSITION_VIEW : ATTRIBUTE_POSITION_VIEW,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) {
  float4 SV_Target;
  float4 SV_Target_1;
  float4 SV_Target_2;
  float4 SV_Target_3;
  float4 SV_Target_4;
  bool _14 = (SV_IsFrontFace != 0);
  float _36 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _37 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _38 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _39 = select(_14, ATTRIBUTE_NORMAL.x, _36);
  float _40 = select(_14, ATTRIBUTE_NORMAL.y, _37);
  float _41 = select(_14, ATTRIBUTE_NORMAL.z, _38);
  float4 _44 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _46 = _44.x * ATTRIBUTE_VCOLOR.w;
  float _47 = max(_46, 0.0f);
  float _48 = min(1.0f, _47);
  float4 _51 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _53 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _55 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _57 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _61 = cb3_space9_038x * _53.x;
  float _63 = _61 + cb3_space9_038z;
  float _65 = cb3_space9_038y * _55.x;
  float _67 = _65 + cb3_space9_038w;
  float _68 = _57.x + _51.x;
  float _71 = cb3_space9_037x * _68;
  float _72 = _63 * 0.008609036915004253f;
  float _73 = _63 * 0.5600313544273376f;
  float _74 = _71 + _72;
  float _75 = _71 - _72;
  float _76 = _73 + _71;
  float _77 = _67 * 0.11102962493896484f;
  float _78 = _67 * 0.3206271827220917f;
  float _79 = _74 + _77;
  float _80 = _75 - _77;
  float _81 = _76 - _78;
  float _82 = max(_79, 0.0f);
  float _83 = max(_80, 0.0f);
  float _84 = max(_81, 0.0f);
  float _85 = log2(_82);
  float _86 = log2(_83);
  float _87 = log2(_84);
  float _88 = _85 * 0.012683313339948654f;
  float _89 = _86 * 0.012683313339948654f;
  float _90 = _87 * 0.012683313339948654f;
  float _91 = exp2(_88);
  float _92 = exp2(_89);
  float _93 = exp2(_90);
  float _94 = _91 + -0.8359375f;
  float _95 = _92 + -0.8359375f;
  float _96 = _93 + -0.8359375f;
  float _97 = max(0.0f, _94);
  float _98 = max(0.0f, _95);
  float _99 = max(0.0f, _96);
  float _100 = _91 * 18.6875f;
  float _101 = _92 * 18.6875f;
  float _102 = _93 * 18.6875f;
  float _103 = 18.8515625f - _100;
  float _104 = 18.8515625f - _101;
  float _105 = 18.8515625f - _102;
  float _106 = _97 / _103;
  float _107 = _98 / _104;
  float _108 = _99 / _105;
  float _109 = abs(_106);
  float _110 = abs(_107);
  float _111 = abs(_108);
  float _112 = log2(_109);
  float _113 = log2(_110);
  float _114 = log2(_111);
  float _115 = _112 * 6.277394771575928f;
  float _116 = _113 * 6.277394771575928f;
  float _117 = _114 * 6.277394771575928f;
  float _118 = exp2(_115);
  float _119 = exp2(_116);
  float _120 = exp2(_117);
  float _121 = _118 * 3.4366066455841064f;
  float _122 = _118 * 0.791329562664032f;
  float _123 = _119 * 2.5064520835876465f;
  float _124 = _119 * 1.9836004972457886f;
  float _125 = _119 * 0.09891371428966522f;
  float _126 = _121 - _123;
  float _127 = _124 - _122;
  float _128 = _118 * -0.02594989910721779f;
  float _129 = _128 - _125;
  float _130 = _120 * 0.06984542310237885f;
  float _131 = _120 * 0.192270889878273f;
  float _132 = _120 * 1.124863624572754f;
  float _133 = _126 + _130;
  float _134 = _127 - _131;
  float _135 = _129 + _132;
  float _137 = cb3_space9_037y * 368.6400146484375f;
  float _138 = _137 * _133;
  float _139 = _137 * _134;
  float _140 = _137 * _135;
  float _141 = max(_138, 9.999999747378752e-05f);
  float _142 = max(_139, 9.999999747378752e-05f);
  float _143 = max(_140, 9.999999747378752e-05f);
  float _147 = log2(_141);
  float _148 = log2(_142);
  float _149 = log2(_143);
  float _150 = _147 + 9.720000267028809f;
  float _151 = _148 + 9.720000267028809f;
  float _152 = _149 + 9.720000267028809f;
  float _153 = _150 * 0.03030303120613098f;
  float _154 = _151 * 0.03030303120613098f;
  float _155 = _152 * 0.03030303120613098f;
  float _156 = _153 + 0.23496760427951813f;
  float _157 = _154 + 0.23496760427951813f;
  float _158 = _155 + 0.23496760427951813f;
  uint3 _159;
  t40_space15.GetDimensions(_159.x, _159.y, _159.z);
  uint2 _163;
  t13_space15.GetDimensions(_163.x, _163.y);
  uint _165 = _159.x + -1u;
  uint _166 = _159.y + -1u;
  uint _167 = _159.z + -1u;
  float _168 = float((uint)_165);
  float _169 = float((uint)_166);
  float _170 = float((uint)_167);
  float _171 = float((uint)_159.x);
  float _172 = float((uint)_159.y);
  float _173 = float((uint)_159.z);
  float _174 = _168 / _171;
  float _175 = _169 / _172;
  float _176 = _170 / _173;
  float _177 = 0.5f / _171;
  float _178 = 0.5f / _172;
  float _179 = 0.5f / _173;
  float _180 = _174 * _156;
  float _181 = _175 * _157;
  float _182 = _176 * _158;
  float _183 = _177 + _180;
  float _184 = _178 + _181;
  float _185 = _179 + _182;
  float4 _186 = t40_space15.SampleLevel(s2_space1, float3(_183, _184, _185), 0.0f);
  float _189 = exp2(_147);
  float _190 = exp2(_148);
  float _191 = exp2(_149);
  float _192 = _189 * 0.6954522132873535f;
  float _193 = mad(0.14067870378494263f, _190, _192);
  float _194 = mad(0.16386906802654266f, _191, _193);
  float _195 = _189 * 0.044794563204050064f;
  float _196 = mad(0.8596711158752441f, _190, _195);
  float _197 = mad(0.0955343171954155f, _191, _196);
  float _198 = _189 * -0.005525882821530104f;
  float _199 = mad(0.004025210160762072f, _190, _198);
  float _200 = mad(1.0015007257461548f, _191, _199);
  float _201 = _186.x + 1.0f;
  float _202 = _194 * _201;
  float _203 = _197 * _201;
  float _204 = _200 * _201;
  float _205 = _202 + _186.y;
  float _206 = max(_205, 0.0f);
  float _207 = max(_203, 0.0f);
  float _208 = max(_204, 0.0f);
  float _209 = min(_206, 65536.0f);
  float _210 = min(_207, 65536.0f);
  float _211 = min(_208, 65536.0f);
  float _212 = _209 * 1.4514392614364624f;
  float _213 = mad(-0.2365107536315918f, _210, _212);
  float _214 = mad(-0.21492856740951538f, _211, _213);
  float _215 = _209 * -0.07655377686023712f;
  float _216 = mad(1.17622971534729f, _210, _215);
  float _217 = mad(-0.09967592358589172f, _211, _216);
  float _218 = _209 * 0.008316148072481155f;
  float _219 = mad(-0.006032449658960104f, _210, _218);
  float _220 = mad(0.9977163076400757f, _211, _219);
  float _221 = max(_214, 0.0f);
  float _222 = max(_217, 0.0f);
  float _223 = max(_220, 0.0f);
  float _224 = min(_221, 65504.0f);
  float _225 = min(_222, 65504.0f);
  float _226 = min(_223, 65504.0f);
  float _227 = _224 * 0.970889151096344f;
  float _228 = mad(0.026963284239172935f, _225, _227);
  float _229 = mad(0.0021475818939507008f, _226, _228);
  float _230 = _224 * 0.010889154858887196f;
  float _231 = mad(0.9869632720947266f, _225, _230);
  float _232 = mad(0.0021475818939507008f, _226, _231);
  float _233 = mad(0.026963284239172935f, _225, _230);
  float _234 = mad(0.9621475338935852f, _226, _233);
  float _235 = log2(_229);
  float _236 = log2(_232);
  float _237 = log2(_234);
  float _238 = _235 + 17.47393035888672f;
  float _239 = _236 + 17.47393035888672f;
  float _240 = _237 + 17.47393035888672f;
  float _241 = _238 * 0.03030303120613098f;
  float _242 = _239 * 0.03030303120613098f;
  float _243 = _240 * 0.03030303120613098f;
  uint _244 = _163.x + -1u;
  float _245 = float((uint)_244);
  float _246 = float((uint)_163.x);
  float _247 = _245 / _246;
  float _248 = 0.5f / _246;
  float _249 = _241 * _247;
  float _250 = _242 * _247;
  float _251 = _243 * _247;
  float _252 = _249 + _248;
  float _253 = _250 + _248;
  float _254 = _251 + _248;
  float4 _255 = t13_space15.SampleLevel(s2_space1, float2(_252, 0.5f), 0.0f);
  float4 _257 = t13_space15.SampleLevel(s2_space1, float2(_253, 0.5f), 0.0f);
  float4 _259 = t13_space15.SampleLevel(s2_space1, float2(_254, 0.5f), 0.0f);
  float _261 = _255.x * 3.321928024291992f;
  float _262 = _257.x * 3.321928024291992f;
  float _263 = _259.x * 3.321928024291992f;
  float _264 = exp2(_261);
  float _265 = exp2(_262);
  float _266 = exp2(_263);
  float _267 = _264 / cb3_space9_036w;
  float _268 = _265 / cb3_space9_036w;
  float _269 = _266 / cb3_space9_036w;
  bool _270 = (cb3_space9_036y < 500.0f);
  float _308;
  float _309;
  float _310;
  float _360;
  float _368;
  float _376;
  if (_270) {
    float _272 = _267 * 0.6624541878700256f;
    float _273 = mad(0.13400420546531677f, _268, _272);
    float _274 = mad(0.15618768334388733f, _269, _273);
    float _275 = _267 * 0.2722287178039551f;
    float _276 = mad(0.6740817427635193f, _268, _275);
    float _277 = mad(0.053689517080783844f, _269, _276);
    float _278 = _267 * -0.005574649665504694f;
    float _279 = mad(0.00406073359772563f, _268, _278);
    float _280 = mad(1.0103391408920288f, _269, _279);
    float _281 = _277 + _274;
    float _282 = _281 + _280;
    bool _283 = (_282 == 0.0f);
    float _284 = select(_283, 1.000000013351432e-10f, _282);
    float _285 = _274 / _284;
    float _286 = _277 / _284;
    float _287 = max(_277, 0.0f);
    float _288 = log2(_287);
    float _289 = _288 * 0.9811000227928162f;
    float _290 = exp2(_289);
    float _291 = _290 * _285;
    float _292 = max(_286, 1.000000013351432e-10f);
    float _293 = _291 / _292;
    float _294 = 1.0f - _285;
    float _295 = _294 - _286;
    float _296 = _290 * _295;
    float _297 = _296 / _292;
    float _298 = _293 * 1.6410233974456787f;
    float _299 = mad(-0.32480329275131226f, _290, _298);
    float _300 = mad(-0.23642469942569733f, _297, _299);
    float _301 = _293 * -0.663662850856781f;
    float _302 = mad(1.6153316497802734f, _290, _301);
    float _303 = mad(0.016756348311901093f, _297, _302);
    float _304 = _293 * 0.011721894145011902f;
    float _305 = mad(-0.008284442126750946f, _290, _304);
    float _306 = mad(0.9883948564529419f, _297, _305);
    _308 = _300;
    _309 = _303;
    _310 = _306;
  } else {
    _308 = _267;
    _309 = _268;
    _310 = _269;
  }
  float _311 = _308 * 1.6047539710998535f;
  float _312 = mad(-0.5310794711112976f, _309, _311);
  float _313 = mad(-0.07367203384637833f, _310, _312);
  float _314 = _308 * -0.10208318382501602f;
  float _315 = mad(1.108132243156433f, _309, _314);
  float _316 = mad(-0.006051875650882721f, _310, _315);
  float _317 = _308 * -0.0032670421060174704f;
  float _318 = mad(-0.07275524735450745f, _309, _317);
  float _319 = mad(1.0760219097137451f, _310, _318);
  float _320 = max(_313, 0.0f);
  float _321 = max(_316, 0.0f);
  float _322 = max(_319, 0.0f);
  float _323 = _320 * ATTRIBUTE_VCOLOR.x;
  float _324 = _321 * ATTRIBUTE_VCOLOR.y;
  float _325 = _322 * ATTRIBUTE_VCOLOR.z;
  float _326 = abs(_323);
  float _327 = abs(_324);
  float _328 = abs(_325);
  float _329 = log2(_326);
  float _330 = log2(_327);
  float _331 = log2(_328);
  float _332 = _329 * 0.4166666567325592f;
  float _333 = _330 * 0.4166666567325592f;
  float _334 = _331 * 0.4166666567325592f;
  float _335 = exp2(_332);
  float _336 = exp2(_333);
  float _337 = exp2(_334);
  bool _338 = isfinite(_335);
  bool _339 = isfinite(_336);
  bool _340 = isfinite(_337);
  float _341 = _335 * 1.0549999475479126f;
  float _342 = _336 * 1.0549999475479126f;
  float _343 = _337 * 1.0549999475479126f;
  float _344 = _341 + -0.054999999701976776f;
  float _345 = select(_338, _344, 0.9999999403953552f);
  float _346 = _342 + -0.054999999701976776f;
  float _347 = select(_339, _346, 0.9999999403953552f);
  float _348 = _343 + -0.054999999701976776f;
  float _349 = select(_340, _348, 0.9999999403953552f);
  float _350 = _324 * 12.920000076293945f;
  float _351 = _325 * 12.920000076293945f;
  bool _352 = (_323 > 0.0031308000907301903f);
  if (!_352) {
    float _354 = _323 * 12.920000076293945f;
    bool _355 = (_323 < 0.0031308000907301903f);
    if (!_355) {
      bool _357 = (_323 == 0.0031308000907301903f);
      if (_357) {
        _360 = _345;
      } else {
        _360 = 0.0f;
      }
    } else {
      _360 = _354;
    }
  } else {
    _360 = _345;
  }
  bool _361 = (_324 > 0.0031308000907301903f);
  if (!_361) {
    bool _363 = (_324 < 0.0031308000907301903f);
    if (!_363) {
      bool _365 = (_324 == 0.0031308000907301903f);
      if (_365) {
        _368 = _347;
      } else {
        _368 = 0.0f;
      }
    } else {
      _368 = _350;
    }
  } else {
    _368 = _347;
  }
  bool _369 = (_325 > 0.0031308000907301903f);
  if (!_369) {
    bool _371 = (_325 < 0.0031308000907301903f);
    if (!_371) {
      bool _373 = (_325 == 0.0031308000907301903f);
      if (_373) {
        _376 = _349;
      } else {
        _376 = 0.0f;
      }
    } else {
      _376 = _351;
    }
  } else {
    _376 = _349;
  }
  float _377 = dot(float3(_39, _40, _41), float3(_39, _40, _41));
  float _378 = rsqrt(_377);
  float _379 = _378 * _39;
  float _380 = _378 * _40;
  float _381 = _378 * _41;
  float _382 = _48 - cb1_space9_034x;
  bool _383 = (_382 < 0.0f);
  if (_383) discard;
  float _384 = SV_Position.y * SV_Position.x;
  float _385 = _384 + SV_Position.x;
  int _386 = int(_385);
  int _387 = _386 ^ 123459876;
  int _388 = _387 / 127773;
  uint _389 = _388 * -127773;
  uint _390 = _389 + _387;
  uint _391 = _390 * 16807;
  int _392 = _388 * -2836;
  uint _393 = _391 + _392;
  bool _394 = ((int)_393 < (int)0);
  int _395 = _393 + 2147483647;
  int _396 = select(_394, _395, _393);
  int _397 = _396 / 127773;
  uint _398 = _397 * -127773;
  uint _399 = _396 + _398;
  uint _400 = _399 * 16807;
  int _401 = _397 * -2836;
  uint _402 = _400 + _401;
  bool _403 = ((int)_402 < (int)0);
  int _404 = _402 + 2147483647;
  int _405 = select(_403, _404, _402);
  float _406 = float((int)(_405));
  float _407 = _406 * 4.656612873077393e-10f;
  float _408 = ATTRIBUTE_INSTANCE_PARAMS.w + -1.0f;
  float _409 = _408 + _407;
  bool _410 = (_409 < 0.0f);
  if (_410) discard;
  float _411 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _412 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _413 = _412 + _411;
  float _414 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _415 = _413 + _414;
  float _416 = sqrt(_415);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_150, _151, _152), 1.f);
    _360 = video.r;
    _368 = video.g;
    _376 = video.b;
  }
  float _417 = _360 * cb0_space5_008x;
  float _418 = _368 * cb0_space5_008y;
  float _419 = _376 * cb0_space5_008z;
  float _420 = _381 + -1.0f;
  float _421 = dot(float3(_379, _380, _420), float3(_379, _380, _420));
  float _422 = rsqrt(_421);
  float _423 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _424 = _423 + 0.5f;
  uint _425 = uint(_424);
  uint _426 = _425 % 13;
  float _427 = float((uint)_426);
  float _428 = _427 * 0.03846153989434242f;
  bool _429 = (_417 < 0.0f);
  bool _430 = (_418 < 0.0f);
  bool _431 = (_419 < 0.0f);
  float _432 = select(_429, -0.0f, _417);
  float _433 = select(_430, -0.0f, _418);
  float _434 = select(_431, -0.0f, _419);
  float _435 = _379 * 0.5f;
  float _436 = _435 * _422;
  float _437 = _380 * 0.5f;
  float _438 = _437 * _422;
  float _439 = _436 + 0.5f;
  float _440 = _438 + 0.5f;
  SV_Target.x = _439;
  SV_Target.y = _440;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _432;
  SV_Target_2.y = _433;
  SV_Target_2.z = _434;
  SV_Target_2.w = _416;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _428;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
