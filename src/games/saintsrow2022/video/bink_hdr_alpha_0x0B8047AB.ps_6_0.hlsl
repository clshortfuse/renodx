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
  float cb0_space5_008w : packoffset(c008.w);
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
  float _35 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _36 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _37 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _38 = select(_14, ATTRIBUTE_NORMAL.x, _35);
  float _39 = select(_14, ATTRIBUTE_NORMAL.y, _36);
  float _40 = select(_14, ATTRIBUTE_NORMAL.z, _37);
  float4 _43 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _45 = _43.x * ATTRIBUTE_VCOLOR.w;
  float _46 = max(_45, 0.0f);
  float _47 = min(1.0f, _46);
  float4 _50 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _52 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _54 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _56 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _60 = cb3_space9_038x * _52.x;
  float _62 = _60 + cb3_space9_038z;
  float _64 = cb3_space9_038y * _54.x;
  float _66 = _64 + cb3_space9_038w;
  float _67 = _56.x + _50.x;
  float _70 = cb3_space9_037x * _67;
  float _71 = _62 * 0.008609036915004253f;
  float _72 = _62 * 0.5600313544273376f;
  float _73 = _70 + _71;
  float _74 = _70 - _71;
  float _75 = _72 + _70;
  float _76 = _66 * 0.11102962493896484f;
  float _77 = _66 * 0.3206271827220917f;
  float _78 = _73 + _76;
  float _79 = _74 - _76;
  float _80 = _75 - _77;
  float _81 = max(_78, 0.0f);
  float _82 = max(_79, 0.0f);
  float _83 = max(_80, 0.0f);
  float _84 = log2(_81);
  float _85 = log2(_82);
  float _86 = log2(_83);
  float _87 = _84 * 0.012683313339948654f;
  float _88 = _85 * 0.012683313339948654f;
  float _89 = _86 * 0.012683313339948654f;
  float _90 = exp2(_87);
  float _91 = exp2(_88);
  float _92 = exp2(_89);
  float _93 = _90 + -0.8359375f;
  float _94 = _91 + -0.8359375f;
  float _95 = _92 + -0.8359375f;
  float _96 = max(0.0f, _93);
  float _97 = max(0.0f, _94);
  float _98 = max(0.0f, _95);
  float _99 = _90 * 18.6875f;
  float _100 = _91 * 18.6875f;
  float _101 = _92 * 18.6875f;
  float _102 = 18.8515625f - _99;
  float _103 = 18.8515625f - _100;
  float _104 = 18.8515625f - _101;
  float _105 = _96 / _102;
  float _106 = _97 / _103;
  float _107 = _98 / _104;
  float _108 = abs(_105);
  float _109 = abs(_106);
  float _110 = abs(_107);
  float _111 = log2(_108);
  float _112 = log2(_109);
  float _113 = log2(_110);
  float _114 = _111 * 6.277394771575928f;
  float _115 = _112 * 6.277394771575928f;
  float _116 = _113 * 6.277394771575928f;
  float _117 = exp2(_114);
  float _118 = exp2(_115);
  float _119 = exp2(_116);
  float _120 = _117 * 3.4366066455841064f;
  float _121 = _117 * 0.791329562664032f;
  float _122 = _118 * 2.5064520835876465f;
  float _123 = _118 * 1.9836004972457886f;
  float _124 = _118 * 0.09891371428966522f;
  float _125 = _120 - _122;
  float _126 = _123 - _121;
  float _127 = _117 * -0.02594989910721779f;
  float _128 = _127 - _124;
  float _129 = _119 * 0.06984542310237885f;
  float _130 = _119 * 0.192270889878273f;
  float _131 = _119 * 1.124863624572754f;
  float _132 = _125 + _129;
  float _133 = _126 - _130;
  float _134 = _128 + _131;
  float _136 = cb3_space9_037y * 368.6400146484375f;
  float _137 = _136 * _132;
  float _138 = _136 * _133;
  float _139 = _136 * _134;
  float _140 = max(_137, 9.999999747378752e-05f);
  float _141 = max(_138, 9.999999747378752e-05f);
  float _142 = max(_139, 9.999999747378752e-05f);
  float _146 = log2(_140);
  float _147 = log2(_141);
  float _148 = log2(_142);
  float _149 = _146 + 9.720000267028809f;
  float _150 = _147 + 9.720000267028809f;
  float _151 = _148 + 9.720000267028809f;
  float _152 = _149 * 0.03030303120613098f;
  float _153 = _150 * 0.03030303120613098f;
  float _154 = _151 * 0.03030303120613098f;
  float _155 = _152 + 0.23496760427951813f;
  float _156 = _153 + 0.23496760427951813f;
  float _157 = _154 + 0.23496760427951813f;
  uint3 _158;
  t40_space15.GetDimensions(_158.x, _158.y, _158.z);
  uint2 _162;
  t13_space15.GetDimensions(_162.x, _162.y);
  uint _164 = _158.x + -1u;
  uint _165 = _158.y + -1u;
  uint _166 = _158.z + -1u;
  float _167 = float((uint)_164);
  float _168 = float((uint)_165);
  float _169 = float((uint)_166);
  float _170 = float((uint)_158.x);
  float _171 = float((uint)_158.y);
  float _172 = float((uint)_158.z);
  float _173 = _167 / _170;
  float _174 = _168 / _171;
  float _175 = _169 / _172;
  float _176 = 0.5f / _170;
  float _177 = 0.5f / _171;
  float _178 = 0.5f / _172;
  float _179 = _173 * _155;
  float _180 = _174 * _156;
  float _181 = _175 * _157;
  float _182 = _176 + _179;
  float _183 = _177 + _180;
  float _184 = _178 + _181;
  float4 _185 = t40_space15.SampleLevel(s2_space1, float3(_182, _183, _184), 0.0f);
  float _188 = exp2(_146);
  float _189 = exp2(_147);
  float _190 = exp2(_148);
  float _191 = _188 * 0.6954522132873535f;
  float _192 = mad(0.14067870378494263f, _189, _191);
  float _193 = mad(0.16386906802654266f, _190, _192);
  float _194 = _188 * 0.044794563204050064f;
  float _195 = mad(0.8596711158752441f, _189, _194);
  float _196 = mad(0.0955343171954155f, _190, _195);
  float _197 = _188 * -0.005525882821530104f;
  float _198 = mad(0.004025210160762072f, _189, _197);
  float _199 = mad(1.0015007257461548f, _190, _198);
  float _200 = _185.x + 1.0f;
  float _201 = _193 * _200;
  float _202 = _196 * _200;
  float _203 = _199 * _200;
  float _204 = _201 + _185.y;
  float _205 = max(_204, 0.0f);
  float _206 = max(_202, 0.0f);
  float _207 = max(_203, 0.0f);
  float _208 = min(_205, 65536.0f);
  float _209 = min(_206, 65536.0f);
  float _210 = min(_207, 65536.0f);
  float _211 = _208 * 1.4514392614364624f;
  float _212 = mad(-0.2365107536315918f, _209, _211);
  float _213 = mad(-0.21492856740951538f, _210, _212);
  float _214 = _208 * -0.07655377686023712f;
  float _215 = mad(1.17622971534729f, _209, _214);
  float _216 = mad(-0.09967592358589172f, _210, _215);
  float _217 = _208 * 0.008316148072481155f;
  float _218 = mad(-0.006032449658960104f, _209, _217);
  float _219 = mad(0.9977163076400757f, _210, _218);
  float _220 = max(_213, 0.0f);
  float _221 = max(_216, 0.0f);
  float _222 = max(_219, 0.0f);
  float _223 = min(_220, 65504.0f);
  float _224 = min(_221, 65504.0f);
  float _225 = min(_222, 65504.0f);
  float _226 = _223 * 0.970889151096344f;
  float _227 = mad(0.026963284239172935f, _224, _226);
  float _228 = mad(0.0021475818939507008f, _225, _227);
  float _229 = _223 * 0.010889154858887196f;
  float _230 = mad(0.9869632720947266f, _224, _229);
  float _231 = mad(0.0021475818939507008f, _225, _230);
  float _232 = mad(0.026963284239172935f, _224, _229);
  float _233 = mad(0.9621475338935852f, _225, _232);
  float _234 = log2(_228);
  float _235 = log2(_231);
  float _236 = log2(_233);
  float _237 = _234 + 17.47393035888672f;
  float _238 = _235 + 17.47393035888672f;
  float _239 = _236 + 17.47393035888672f;
  float _240 = _237 * 0.03030303120613098f;
  float _241 = _238 * 0.03030303120613098f;
  float _242 = _239 * 0.03030303120613098f;
  uint _243 = _162.x + -1u;
  float _244 = float((uint)_243);
  float _245 = float((uint)_162.x);
  float _246 = _244 / _245;
  float _247 = 0.5f / _245;
  float _248 = _240 * _246;
  float _249 = _241 * _246;
  float _250 = _242 * _246;
  float _251 = _248 + _247;
  float _252 = _249 + _247;
  float _253 = _250 + _247;
  float4 _254 = t13_space15.SampleLevel(s2_space1, float2(_251, 0.5f), 0.0f);
  float4 _256 = t13_space15.SampleLevel(s2_space1, float2(_252, 0.5f), 0.0f);
  float4 _258 = t13_space15.SampleLevel(s2_space1, float2(_253, 0.5f), 0.0f);
  float _260 = _254.x * 3.321928024291992f;
  float _261 = _256.x * 3.321928024291992f;
  float _262 = _258.x * 3.321928024291992f;
  float _263 = exp2(_260);
  float _264 = exp2(_261);
  float _265 = exp2(_262);
  float _266 = _263 / cb3_space9_036w;
  float _267 = _264 / cb3_space9_036w;
  float _268 = _265 / cb3_space9_036w;
  bool _269 = (cb3_space9_036y < 500.0f);
  float _307;
  float _308;
  float _309;
  float _359;
  float _367;
  float _375;
  if (_269) {
    float _271 = _266 * 0.6624541878700256f;
    float _272 = mad(0.13400420546531677f, _267, _271);
    float _273 = mad(0.15618768334388733f, _268, _272);
    float _274 = _266 * 0.2722287178039551f;
    float _275 = mad(0.6740817427635193f, _267, _274);
    float _276 = mad(0.053689517080783844f, _268, _275);
    float _277 = _266 * -0.005574649665504694f;
    float _278 = mad(0.00406073359772563f, _267, _277);
    float _279 = mad(1.0103391408920288f, _268, _278);
    float _280 = _276 + _273;
    float _281 = _280 + _279;
    bool _282 = (_281 == 0.0f);
    float _283 = select(_282, 1.000000013351432e-10f, _281);
    float _284 = _273 / _283;
    float _285 = _276 / _283;
    float _286 = max(_276, 0.0f);
    float _287 = log2(_286);
    float _288 = _287 * 0.9811000227928162f;
    float _289 = exp2(_288);
    float _290 = _289 * _284;
    float _291 = max(_285, 1.000000013351432e-10f);
    float _292 = _290 / _291;
    float _293 = 1.0f - _284;
    float _294 = _293 - _285;
    float _295 = _289 * _294;
    float _296 = _295 / _291;
    float _297 = _292 * 1.6410233974456787f;
    float _298 = mad(-0.32480329275131226f, _289, _297);
    float _299 = mad(-0.23642469942569733f, _296, _298);
    float _300 = _292 * -0.663662850856781f;
    float _301 = mad(1.6153316497802734f, _289, _300);
    float _302 = mad(0.016756348311901093f, _296, _301);
    float _303 = _292 * 0.011721894145011902f;
    float _304 = mad(-0.008284442126750946f, _289, _303);
    float _305 = mad(0.9883948564529419f, _296, _304);
    _307 = _299;
    _308 = _302;
    _309 = _305;
  } else {
    _307 = _266;
    _308 = _267;
    _309 = _268;
  }
  float _310 = _307 * 1.6047539710998535f;
  float _311 = mad(-0.5310794711112976f, _308, _310);
  float _312 = mad(-0.07367203384637833f, _309, _311);
  float _313 = _307 * -0.10208318382501602f;
  float _314 = mad(1.108132243156433f, _308, _313);
  float _315 = mad(-0.006051875650882721f, _309, _314);
  float _316 = _307 * -0.0032670421060174704f;
  float _317 = mad(-0.07275524735450745f, _308, _316);
  float _318 = mad(1.0760219097137451f, _309, _317);
  float _319 = max(_312, 0.0f);
  float _320 = max(_315, 0.0f);
  float _321 = max(_318, 0.0f);
  float _322 = _319 * ATTRIBUTE_VCOLOR.x;
  float _323 = _320 * ATTRIBUTE_VCOLOR.y;
  float _324 = _321 * ATTRIBUTE_VCOLOR.z;
  float _325 = abs(_322);
  float _326 = abs(_323);
  float _327 = abs(_324);
  float _328 = log2(_325);
  float _329 = log2(_326);
  float _330 = log2(_327);
  float _331 = _328 * 0.4166666567325592f;
  float _332 = _329 * 0.4166666567325592f;
  float _333 = _330 * 0.4166666567325592f;
  float _334 = exp2(_331);
  float _335 = exp2(_332);
  float _336 = exp2(_333);
  bool _337 = isfinite(_334);
  bool _338 = isfinite(_335);
  bool _339 = isfinite(_336);
  float _340 = _334 * 1.0549999475479126f;
  float _341 = _335 * 1.0549999475479126f;
  float _342 = _336 * 1.0549999475479126f;
  float _343 = _340 + -0.054999999701976776f;
  float _344 = select(_337, _343, 0.9999999403953552f);
  float _345 = _341 + -0.054999999701976776f;
  float _346 = select(_338, _345, 0.9999999403953552f);
  float _347 = _342 + -0.054999999701976776f;
  float _348 = select(_339, _347, 0.9999999403953552f);
  float _349 = _323 * 12.920000076293945f;
  float _350 = _324 * 12.920000076293945f;
  bool _351 = (_322 > 0.0031308000907301903f);
  if (!_351) {
    float _353 = _322 * 12.920000076293945f;
    bool _354 = (_322 < 0.0031308000907301903f);
    if (!_354) {
      bool _356 = (_322 == 0.0031308000907301903f);
      if (_356) {
        _359 = _344;
      } else {
        _359 = 0.0f;
      }
    } else {
      _359 = _353;
    }
  } else {
    _359 = _344;
  }
  bool _360 = (_323 > 0.0031308000907301903f);
  if (!_360) {
    bool _362 = (_323 < 0.0031308000907301903f);
    if (!_362) {
      bool _364 = (_323 == 0.0031308000907301903f);
      if (_364) {
        _367 = _346;
      } else {
        _367 = 0.0f;
      }
    } else {
      _367 = _349;
    }
  } else {
    _367 = _346;
  }
  bool _368 = (_324 > 0.0031308000907301903f);
  if (!_368) {
    bool _370 = (_324 < 0.0031308000907301903f);
    if (!_370) {
      bool _372 = (_324 == 0.0031308000907301903f);
      if (_372) {
        _375 = _348;
      } else {
        _375 = 0.0f;
      }
    } else {
      _375 = _350;
    }
  } else {
    _375 = _348;
  }
  float _376 = dot(float3(_38, _39, _40), float3(_38, _39, _40));
  float _377 = rsqrt(_376);
  float _378 = _377 * _38;
  float _379 = _377 * _39;
  float _380 = _377 * _40;
  float _381 = _47 - cb1_space9_034x;
  bool _382 = (_381 < 0.0f);
  if (_382) discard;
  float _385 = SV_Position.y * SV_Position.x;
  float _386 = _385 + SV_Position.x;
  int _387 = int(_386);
  int _388 = _387 ^ 123459876;
  int _389 = _388 / 127773;
  uint _390 = _389 * -127773;
  uint _391 = _390 + _388;
  uint _392 = _391 * 16807;
  int _393 = _389 * -2836;
  uint _394 = _392 + _393;
  bool _395 = ((int)_394 < (int)0);
  int _396 = _394 + 2147483647;
  int _397 = select(_395, _396, _394);
  int _398 = _397 / 127773;
  uint _399 = _398 * -127773;
  uint _400 = _397 + _399;
  uint _401 = _400 * 16807;
  int _402 = _398 * -2836;
  uint _403 = _401 + _402;
  bool _404 = ((int)_403 < (int)0);
  int _405 = _403 + 2147483647;
  int _406 = select(_404, _405, _403);
  float _407 = float((int)(_406));
  float _408 = _407 * 4.656612873077393e-10f;
  float _409 = cb0_space5_008w + -1.0f;
  float _410 = _409 + _408;
  bool _411 = (_410 < 0.0f);
  if (_411) discard;
  float _412 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _413 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _414 = _413 + _412;
  float _415 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _416 = _414 + _415;
  float _417 = sqrt(_416);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_149, _150, _151), 1.f);
    _359 = video.r;
    _367 = video.g;
    _375 = video.b;
  }
  float _418 = _359 * cb0_space5_008x;
  float _419 = _367 * cb0_space5_008y;
  float _420 = _375 * cb0_space5_008z;
  float _421 = _380 + -1.0f;
  float _422 = dot(float3(_378, _379, _421), float3(_378, _379, _421));
  float _423 = rsqrt(_422);
  float _424 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _425 = _424 + 0.5f;
  uint _426 = uint(_425);
  uint _427 = _426 % 13;
  float _428 = float((uint)_427);
  float _429 = _428 * 0.03846153989434242f;
  bool _430 = (_418 < 0.0f);
  bool _431 = (_419 < 0.0f);
  bool _432 = (_420 < 0.0f);
  float _433 = select(_430, -0.0f, _418);
  float _434 = select(_431, -0.0f, _419);
  float _435 = select(_432, -0.0f, _420);
  float _436 = _378 * 0.5f;
  float _437 = _436 * _423;
  float _438 = _379 * 0.5f;
  float _439 = _438 * _423;
  float _440 = _437 + 0.5f;
  float _441 = _439 + 0.5f;
  SV_Target.x = _440;
  SV_Target.y = _441;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _433;
  SV_Target_2.y = _434;
  SV_Target_2.z = _435;
  SV_Target_2.w = _417;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _429;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
