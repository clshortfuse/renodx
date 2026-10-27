#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr_gradient_alpha: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

Texture2D<float4> t29_space15 : register(t29, space15);

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
  bool _15 = (SV_IsFrontFace != 0);
  float _36 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _37 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _42 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _43 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _44 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _45 = select(_15, ATTRIBUTE_NORMAL.x, _42);
  float _46 = select(_15, ATTRIBUTE_NORMAL.y, _43);
  float _47 = select(_15, ATTRIBUTE_NORMAL.z, _44);
  float _48 = _36 + 1.0f;
  float _49 = 1.0f - _37;
  float _50 = _48 * 0.5f;
  float _51 = _49 * 0.5f;
  float4 _54 = t29_space15.SampleBias(s0_space1, float2(_50, _51), cb1_space9_035z, int2(0, 0));
  float4 _58 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _60 = _54.x * ATTRIBUTE_VCOLOR.w;
  float _61 = _60 * _58.x;
  float _62 = max(_61, 0.0f);
  float _63 = min(1.0f, _62);
  float4 _66 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _68 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _70 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _72 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _76 = cb3_space9_038x * _68.x;
  float _78 = _76 + cb3_space9_038z;
  float _80 = cb3_space9_038y * _70.x;
  float _82 = _80 + cb3_space9_038w;
  float _83 = _72.x + _66.x;
  float _86 = cb3_space9_037x * _83;
  float _87 = _78 * 0.008609036915004253f;
  float _88 = _78 * 0.5600313544273376f;
  float _89 = _86 + _87;
  float _90 = _86 - _87;
  float _91 = _88 + _86;
  float _92 = _82 * 0.11102962493896484f;
  float _93 = _82 * 0.3206271827220917f;
  float _94 = _89 + _92;
  float _95 = _90 - _92;
  float _96 = _91 - _93;
  float _97 = max(_94, 0.0f);
  float _98 = max(_95, 0.0f);
  float _99 = max(_96, 0.0f);
  float _100 = log2(_97);
  float _101 = log2(_98);
  float _102 = log2(_99);
  float _103 = _100 * 0.012683313339948654f;
  float _104 = _101 * 0.012683313339948654f;
  float _105 = _102 * 0.012683313339948654f;
  float _106 = exp2(_103);
  float _107 = exp2(_104);
  float _108 = exp2(_105);
  float _109 = _106 + -0.8359375f;
  float _110 = _107 + -0.8359375f;
  float _111 = _108 + -0.8359375f;
  float _112 = max(0.0f, _109);
  float _113 = max(0.0f, _110);
  float _114 = max(0.0f, _111);
  float _115 = _106 * 18.6875f;
  float _116 = _107 * 18.6875f;
  float _117 = _108 * 18.6875f;
  float _118 = 18.8515625f - _115;
  float _119 = 18.8515625f - _116;
  float _120 = 18.8515625f - _117;
  float _121 = _112 / _118;
  float _122 = _113 / _119;
  float _123 = _114 / _120;
  float _124 = abs(_121);
  float _125 = abs(_122);
  float _126 = abs(_123);
  float _127 = log2(_124);
  float _128 = log2(_125);
  float _129 = log2(_126);
  float _130 = _127 * 6.277394771575928f;
  float _131 = _128 * 6.277394771575928f;
  float _132 = _129 * 6.277394771575928f;
  float _133 = exp2(_130);
  float _134 = exp2(_131);
  float _135 = exp2(_132);
  float _136 = _133 * 3.4366066455841064f;
  float _137 = _133 * 0.791329562664032f;
  float _138 = _134 * 2.5064520835876465f;
  float _139 = _134 * 1.9836004972457886f;
  float _140 = _134 * 0.09891371428966522f;
  float _141 = _136 - _138;
  float _142 = _139 - _137;
  float _143 = _133 * -0.02594989910721779f;
  float _144 = _143 - _140;
  float _145 = _135 * 0.06984542310237885f;
  float _146 = _135 * 0.192270889878273f;
  float _147 = _135 * 1.124863624572754f;
  float _148 = _141 + _145;
  float _149 = _142 - _146;
  float _150 = _144 + _147;
  float _152 = cb3_space9_037y * 368.6400146484375f;
  float _153 = _152 * _148;
  float _154 = _152 * _149;
  float _155 = _152 * _150;
  float _156 = max(_153, 9.999999747378752e-05f);
  float _157 = max(_154, 9.999999747378752e-05f);
  float _158 = max(_155, 9.999999747378752e-05f);
  float _162 = log2(_156);
  float _163 = log2(_157);
  float _164 = log2(_158);
  float _165 = _162 + 9.720000267028809f;
  float _166 = _163 + 9.720000267028809f;
  float _167 = _164 + 9.720000267028809f;
  float _168 = _165 * 0.03030303120613098f;
  float _169 = _166 * 0.03030303120613098f;
  float _170 = _167 * 0.03030303120613098f;
  float _171 = _168 + 0.23496760427951813f;
  float _172 = _169 + 0.23496760427951813f;
  float _173 = _170 + 0.23496760427951813f;
  uint3 _174;
  t40_space15.GetDimensions(_174.x, _174.y, _174.z);
  uint2 _178;
  t13_space15.GetDimensions(_178.x, _178.y);
  uint _180 = _174.x + -1u;
  uint _181 = _174.y + -1u;
  uint _182 = _174.z + -1u;
  float _183 = float((uint)_180);
  float _184 = float((uint)_181);
  float _185 = float((uint)_182);
  float _186 = float((uint)_174.x);
  float _187 = float((uint)_174.y);
  float _188 = float((uint)_174.z);
  float _189 = _183 / _186;
  float _190 = _184 / _187;
  float _191 = _185 / _188;
  float _192 = 0.5f / _186;
  float _193 = 0.5f / _187;
  float _194 = 0.5f / _188;
  float _195 = _189 * _171;
  float _196 = _190 * _172;
  float _197 = _191 * _173;
  float _198 = _192 + _195;
  float _199 = _193 + _196;
  float _200 = _194 + _197;
  float4 _201 = t40_space15.SampleLevel(s2_space1, float3(_198, _199, _200), 0.0f);
  float _204 = exp2(_162);
  float _205 = exp2(_163);
  float _206 = exp2(_164);
  float _207 = _204 * 0.6954522132873535f;
  float _208 = mad(0.14067870378494263f, _205, _207);
  float _209 = mad(0.16386906802654266f, _206, _208);
  float _210 = _204 * 0.044794563204050064f;
  float _211 = mad(0.8596711158752441f, _205, _210);
  float _212 = mad(0.0955343171954155f, _206, _211);
  float _213 = _204 * -0.005525882821530104f;
  float _214 = mad(0.004025210160762072f, _205, _213);
  float _215 = mad(1.0015007257461548f, _206, _214);
  float _216 = _201.x + 1.0f;
  float _217 = _209 * _216;
  float _218 = _212 * _216;
  float _219 = _215 * _216;
  float _220 = _217 + _201.y;
  float _221 = max(_220, 0.0f);
  float _222 = max(_218, 0.0f);
  float _223 = max(_219, 0.0f);
  float _224 = min(_221, 65536.0f);
  float _225 = min(_222, 65536.0f);
  float _226 = min(_223, 65536.0f);
  float _227 = _224 * 1.4514392614364624f;
  float _228 = mad(-0.2365107536315918f, _225, _227);
  float _229 = mad(-0.21492856740951538f, _226, _228);
  float _230 = _224 * -0.07655377686023712f;
  float _231 = mad(1.17622971534729f, _225, _230);
  float _232 = mad(-0.09967592358589172f, _226, _231);
  float _233 = _224 * 0.008316148072481155f;
  float _234 = mad(-0.006032449658960104f, _225, _233);
  float _235 = mad(0.9977163076400757f, _226, _234);
  float _236 = max(_229, 0.0f);
  float _237 = max(_232, 0.0f);
  float _238 = max(_235, 0.0f);
  float _239 = min(_236, 65504.0f);
  float _240 = min(_237, 65504.0f);
  float _241 = min(_238, 65504.0f);
  float _242 = _239 * 0.970889151096344f;
  float _243 = mad(0.026963284239172935f, _240, _242);
  float _244 = mad(0.0021475818939507008f, _241, _243);
  float _245 = _239 * 0.010889154858887196f;
  float _246 = mad(0.9869632720947266f, _240, _245);
  float _247 = mad(0.0021475818939507008f, _241, _246);
  float _248 = mad(0.026963284239172935f, _240, _245);
  float _249 = mad(0.9621475338935852f, _241, _248);
  float _250 = log2(_244);
  float _251 = log2(_247);
  float _252 = log2(_249);
  float _253 = _250 + 17.47393035888672f;
  float _254 = _251 + 17.47393035888672f;
  float _255 = _252 + 17.47393035888672f;
  float _256 = _253 * 0.03030303120613098f;
  float _257 = _254 * 0.03030303120613098f;
  float _258 = _255 * 0.03030303120613098f;
  uint _259 = _178.x + -1u;
  float _260 = float((uint)_259);
  float _261 = float((uint)_178.x);
  float _262 = _260 / _261;
  float _263 = 0.5f / _261;
  float _264 = _256 * _262;
  float _265 = _257 * _262;
  float _266 = _258 * _262;
  float _267 = _264 + _263;
  float _268 = _265 + _263;
  float _269 = _266 + _263;
  float4 _270 = t13_space15.SampleLevel(s2_space1, float2(_267, 0.5f), 0.0f);
  float4 _272 = t13_space15.SampleLevel(s2_space1, float2(_268, 0.5f), 0.0f);
  float4 _274 = t13_space15.SampleLevel(s2_space1, float2(_269, 0.5f), 0.0f);
  float _276 = _270.x * 3.321928024291992f;
  float _277 = _272.x * 3.321928024291992f;
  float _278 = _274.x * 3.321928024291992f;
  float _279 = exp2(_276);
  float _280 = exp2(_277);
  float _281 = exp2(_278);
  float _282 = _279 / cb3_space9_036w;
  float _283 = _280 / cb3_space9_036w;
  float _284 = _281 / cb3_space9_036w;
  bool _285 = (cb3_space9_036y < 500.0f);
  float _323;
  float _324;
  float _325;
  float _375;
  float _383;
  float _391;
  if (_285) {
    float _287 = _282 * 0.6624541878700256f;
    float _288 = mad(0.13400420546531677f, _283, _287);
    float _289 = mad(0.15618768334388733f, _284, _288);
    float _290 = _282 * 0.2722287178039551f;
    float _291 = mad(0.6740817427635193f, _283, _290);
    float _292 = mad(0.053689517080783844f, _284, _291);
    float _293 = _282 * -0.005574649665504694f;
    float _294 = mad(0.00406073359772563f, _283, _293);
    float _295 = mad(1.0103391408920288f, _284, _294);
    float _296 = _292 + _289;
    float _297 = _296 + _295;
    bool _298 = (_297 == 0.0f);
    float _299 = select(_298, 1.000000013351432e-10f, _297);
    float _300 = _289 / _299;
    float _301 = _292 / _299;
    float _302 = max(_292, 0.0f);
    float _303 = log2(_302);
    float _304 = _303 * 0.9811000227928162f;
    float _305 = exp2(_304);
    float _306 = _305 * _300;
    float _307 = max(_301, 1.000000013351432e-10f);
    float _308 = _306 / _307;
    float _309 = 1.0f - _300;
    float _310 = _309 - _301;
    float _311 = _305 * _310;
    float _312 = _311 / _307;
    float _313 = _308 * 1.6410233974456787f;
    float _314 = mad(-0.32480329275131226f, _305, _313);
    float _315 = mad(-0.23642469942569733f, _312, _314);
    float _316 = _308 * -0.663662850856781f;
    float _317 = mad(1.6153316497802734f, _305, _316);
    float _318 = mad(0.016756348311901093f, _312, _317);
    float _319 = _308 * 0.011721894145011902f;
    float _320 = mad(-0.008284442126750946f, _305, _319);
    float _321 = mad(0.9883948564529419f, _312, _320);
    _323 = _315;
    _324 = _318;
    _325 = _321;
  } else {
    _323 = _282;
    _324 = _283;
    _325 = _284;
  }
  float _326 = _323 * 1.6047539710998535f;
  float _327 = mad(-0.5310794711112976f, _324, _326);
  float _328 = mad(-0.07367203384637833f, _325, _327);
  float _329 = _323 * -0.10208318382501602f;
  float _330 = mad(1.108132243156433f, _324, _329);
  float _331 = mad(-0.006051875650882721f, _325, _330);
  float _332 = _323 * -0.0032670421060174704f;
  float _333 = mad(-0.07275524735450745f, _324, _332);
  float _334 = mad(1.0760219097137451f, _325, _333);
  float _335 = max(_328, 0.0f);
  float _336 = max(_331, 0.0f);
  float _337 = max(_334, 0.0f);
  float _338 = _335 * ATTRIBUTE_VCOLOR.x;
  float _339 = _336 * ATTRIBUTE_VCOLOR.y;
  float _340 = _337 * ATTRIBUTE_VCOLOR.z;
  float _341 = abs(_338);
  float _342 = abs(_339);
  float _343 = abs(_340);
  float _344 = log2(_341);
  float _345 = log2(_342);
  float _346 = log2(_343);
  float _347 = _344 * 0.4166666567325592f;
  float _348 = _345 * 0.4166666567325592f;
  float _349 = _346 * 0.4166666567325592f;
  float _350 = exp2(_347);
  float _351 = exp2(_348);
  float _352 = exp2(_349);
  bool _353 = isfinite(_350);
  bool _354 = isfinite(_351);
  bool _355 = isfinite(_352);
  float _356 = _350 * 1.0549999475479126f;
  float _357 = _351 * 1.0549999475479126f;
  float _358 = _352 * 1.0549999475479126f;
  float _359 = _356 + -0.054999999701976776f;
  float _360 = select(_353, _359, 0.9999999403953552f);
  float _361 = _357 + -0.054999999701976776f;
  float _362 = select(_354, _361, 0.9999999403953552f);
  float _363 = _358 + -0.054999999701976776f;
  float _364 = select(_355, _363, 0.9999999403953552f);
  float _365 = _339 * 12.920000076293945f;
  float _366 = _340 * 12.920000076293945f;
  bool _367 = (_338 > 0.0031308000907301903f);
  if (!_367) {
    float _369 = _338 * 12.920000076293945f;
    bool _370 = (_338 < 0.0031308000907301903f);
    if (!_370) {
      bool _372 = (_338 == 0.0031308000907301903f);
      if (_372) {
        _375 = _360;
      } else {
        _375 = 0.0f;
      }
    } else {
      _375 = _369;
    }
  } else {
    _375 = _360;
  }
  bool _376 = (_339 > 0.0031308000907301903f);
  if (!_376) {
    bool _378 = (_339 < 0.0031308000907301903f);
    if (!_378) {
      bool _380 = (_339 == 0.0031308000907301903f);
      if (_380) {
        _383 = _362;
      } else {
        _383 = 0.0f;
      }
    } else {
      _383 = _365;
    }
  } else {
    _383 = _362;
  }
  bool _384 = (_340 > 0.0031308000907301903f);
  if (!_384) {
    bool _386 = (_340 < 0.0031308000907301903f);
    if (!_386) {
      bool _388 = (_340 == 0.0031308000907301903f);
      if (_388) {
        _391 = _364;
      } else {
        _391 = 0.0f;
      }
    } else {
      _391 = _366;
    }
  } else {
    _391 = _364;
  }
  float _392 = dot(float3(_45, _46, _47), float3(_45, _46, _47));
  float _393 = rsqrt(_392);
  float _394 = _393 * _45;
  float _395 = _393 * _46;
  float _396 = _393 * _47;
  float _397 = _63 - cb1_space9_034x;
  bool _398 = (_397 < 0.0f);
  if (_398) discard;
  float _399 = SV_Position.y * SV_Position.x;
  float _400 = _399 + SV_Position.x;
  int _401 = int(_400);
  int _402 = _401 ^ 123459876;
  int _403 = _402 / 127773;
  uint _404 = _403 * -127773;
  uint _405 = _404 + _402;
  uint _406 = _405 * 16807;
  int _407 = _403 * -2836;
  uint _408 = _406 + _407;
  bool _409 = ((int)_408 < (int)0);
  int _410 = _408 + 2147483647;
  int _411 = select(_409, _410, _408);
  int _412 = _411 / 127773;
  uint _413 = _412 * -127773;
  uint _414 = _411 + _413;
  uint _415 = _414 * 16807;
  int _416 = _412 * -2836;
  uint _417 = _415 + _416;
  bool _418 = ((int)_417 < (int)0);
  int _419 = _417 + 2147483647;
  int _420 = select(_418, _419, _417);
  float _421 = float((int)(_420));
  float _422 = _421 * 4.656612873077393e-10f;
  float _423 = ATTRIBUTE_INSTANCE_PARAMS.w + -1.0f;
  float _424 = _423 + _422;
  bool _425 = (_424 < 0.0f);
  if (_425) discard;
  float _426 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _427 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _428 = _427 + _426;
  float _429 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _430 = _428 + _429;
  float _431 = sqrt(_430);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_165, _166, _167), 1.f);
    _375 = video.r;
    _383 = video.g;
    _391 = video.b;
  }
  float _432 = _375 * cb0_space5_008x;
  float _433 = _383 * cb0_space5_008y;
  float _434 = _391 * cb0_space5_008z;
  float _435 = _396 + -1.0f;
  float _436 = dot(float3(_394, _395, _435), float3(_394, _395, _435));
  float _437 = rsqrt(_436);
  float _438 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _439 = _438 + 0.5f;
  uint _440 = uint(_439);
  uint _441 = _440 % 13;
  float _442 = float((uint)_441);
  float _443 = _442 * 0.03846153989434242f;
  bool _444 = (_432 < 0.0f);
  bool _445 = (_433 < 0.0f);
  bool _446 = (_434 < 0.0f);
  float _447 = select(_444, -0.0f, _432);
  float _448 = select(_445, -0.0f, _433);
  float _449 = select(_446, -0.0f, _434);
  float _450 = _394 * 0.5f;
  float _451 = _450 * _437;
  float _452 = _395 * 0.5f;
  float _453 = _452 * _437;
  float _454 = _451 + 0.5f;
  float _455 = _453 + 0.5f;
  SV_Target.x = _454;
  SV_Target.y = _455;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _447;
  SV_Target_2.y = _448;
  SV_Target_2.z = _449;
  SV_Target_2.w = _431;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _443;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
