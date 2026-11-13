#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr_gradient: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

Texture2D<float4> t29_space15 : register(t29, space15);

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
  bool _14 = (SV_IsFrontFace != 0);
  float _35 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _36 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _41 = -0.0f - ATTRIBUTE_NORMAL.x;
  float _42 = -0.0f - ATTRIBUTE_NORMAL.y;
  float _43 = -0.0f - ATTRIBUTE_NORMAL.z;
  float _44 = select(_14, ATTRIBUTE_NORMAL.x, _41);
  float _45 = select(_14, ATTRIBUTE_NORMAL.y, _42);
  float _46 = select(_14, ATTRIBUTE_NORMAL.z, _43);
  float _47 = _35 + 1.0f;
  float _48 = 1.0f - _36;
  float _49 = _47 * 0.5f;
  float _50 = _48 * 0.5f;
  float4 _53 = t29_space15.SampleBias(s0_space1, float2(_49, _50), cb1_space9_035z, int2(0, 0));
  float _55 = _53.x * ATTRIBUTE_VCOLOR.w;
  float _56 = max(_55, 0.0f);
  float _57 = min(1.0f, _56);
  float4 _62 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _64 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _66 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _68 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _72 = cb3_space9_038x * _64.x;
  float _74 = _72 + cb3_space9_038z;
  float _76 = cb3_space9_038y * _66.x;
  float _78 = _76 + cb3_space9_038w;
  float _79 = _68.x + _62.x;
  float _82 = cb3_space9_037x * _79;
  float _83 = _74 * 0.008609036915004253f;
  float _84 = _74 * 0.5600313544273376f;
  float _85 = _82 + _83;
  float _86 = _82 - _83;
  float _87 = _84 + _82;
  float _88 = _78 * 0.11102962493896484f;
  float _89 = _78 * 0.3206271827220917f;
  float _90 = _85 + _88;
  float _91 = _86 - _88;
  float _92 = _87 - _89;
  float _93 = max(_90, 0.0f);
  float _94 = max(_91, 0.0f);
  float _95 = max(_92, 0.0f);
  float _96 = log2(_93);
  float _97 = log2(_94);
  float _98 = log2(_95);
  float _99 = _96 * 0.012683313339948654f;
  float _100 = _97 * 0.012683313339948654f;
  float _101 = _98 * 0.012683313339948654f;
  float _102 = exp2(_99);
  float _103 = exp2(_100);
  float _104 = exp2(_101);
  float _105 = _102 + -0.8359375f;
  float _106 = _103 + -0.8359375f;
  float _107 = _104 + -0.8359375f;
  float _108 = max(0.0f, _105);
  float _109 = max(0.0f, _106);
  float _110 = max(0.0f, _107);
  float _111 = _102 * 18.6875f;
  float _112 = _103 * 18.6875f;
  float _113 = _104 * 18.6875f;
  float _114 = 18.8515625f - _111;
  float _115 = 18.8515625f - _112;
  float _116 = 18.8515625f - _113;
  float _117 = _108 / _114;
  float _118 = _109 / _115;
  float _119 = _110 / _116;
  float _120 = abs(_117);
  float _121 = abs(_118);
  float _122 = abs(_119);
  float _123 = log2(_120);
  float _124 = log2(_121);
  float _125 = log2(_122);
  float _126 = _123 * 6.277394771575928f;
  float _127 = _124 * 6.277394771575928f;
  float _128 = _125 * 6.277394771575928f;
  float _129 = exp2(_126);
  float _130 = exp2(_127);
  float _131 = exp2(_128);
  float _132 = _129 * 3.4366066455841064f;
  float _133 = _129 * 0.791329562664032f;
  float _134 = _130 * 2.5064520835876465f;
  float _135 = _130 * 1.9836004972457886f;
  float _136 = _130 * 0.09891371428966522f;
  float _137 = _132 - _134;
  float _138 = _135 - _133;
  float _139 = _129 * -0.02594989910721779f;
  float _140 = _139 - _136;
  float _141 = _131 * 0.06984542310237885f;
  float _142 = _131 * 0.192270889878273f;
  float _143 = _131 * 1.124863624572754f;
  float _144 = _137 + _141;
  float _145 = _138 - _142;
  float _146 = _140 + _143;
  float _148 = cb3_space9_037y * 368.6400146484375f;
  float _149 = _148 * _144;
  float _150 = _148 * _145;
  float _151 = _148 * _146;
  float _152 = max(_149, 9.999999747378752e-05f);
  float _153 = max(_150, 9.999999747378752e-05f);
  float _154 = max(_151, 9.999999747378752e-05f);
  float _158 = log2(_152);
  float _159 = log2(_153);
  float _160 = log2(_154);
  float _161 = _158 + 9.720000267028809f;
  float _162 = _159 + 9.720000267028809f;
  float _163 = _160 + 9.720000267028809f;
  float _164 = _161 * 0.03030303120613098f;
  float _165 = _162 * 0.03030303120613098f;
  float _166 = _163 * 0.03030303120613098f;
  float _167 = _164 + 0.23496760427951813f;
  float _168 = _165 + 0.23496760427951813f;
  float _169 = _166 + 0.23496760427951813f;
  uint3 _170;
  t40_space15.GetDimensions(_170.x, _170.y, _170.z);
  uint2 _174;
  t13_space15.GetDimensions(_174.x, _174.y);
  uint _176 = _170.x + -1u;
  uint _177 = _170.y + -1u;
  uint _178 = _170.z + -1u;
  float _179 = float((uint)_176);
  float _180 = float((uint)_177);
  float _181 = float((uint)_178);
  float _182 = float((uint)_170.x);
  float _183 = float((uint)_170.y);
  float _184 = float((uint)_170.z);
  float _185 = _179 / _182;
  float _186 = _180 / _183;
  float _187 = _181 / _184;
  float _188 = 0.5f / _182;
  float _189 = 0.5f / _183;
  float _190 = 0.5f / _184;
  float _191 = _185 * _167;
  float _192 = _186 * _168;
  float _193 = _187 * _169;
  float _194 = _188 + _191;
  float _195 = _189 + _192;
  float _196 = _190 + _193;
  float4 _197 = t40_space15.SampleLevel(s2_space1, float3(_194, _195, _196), 0.0f);
  float _200 = exp2(_158);
  float _201 = exp2(_159);
  float _202 = exp2(_160);
  float _203 = _200 * 0.6954522132873535f;
  float _204 = mad(0.14067870378494263f, _201, _203);
  float _205 = mad(0.16386906802654266f, _202, _204);
  float _206 = _200 * 0.044794563204050064f;
  float _207 = mad(0.8596711158752441f, _201, _206);
  float _208 = mad(0.0955343171954155f, _202, _207);
  float _209 = _200 * -0.005525882821530104f;
  float _210 = mad(0.004025210160762072f, _201, _209);
  float _211 = mad(1.0015007257461548f, _202, _210);
  float _212 = _197.x + 1.0f;
  float _213 = _205 * _212;
  float _214 = _208 * _212;
  float _215 = _211 * _212;
  float _216 = _213 + _197.y;
  float _217 = max(_216, 0.0f);
  float _218 = max(_214, 0.0f);
  float _219 = max(_215, 0.0f);
  float _220 = min(_217, 65536.0f);
  float _221 = min(_218, 65536.0f);
  float _222 = min(_219, 65536.0f);
  float _223 = _220 * 1.4514392614364624f;
  float _224 = mad(-0.2365107536315918f, _221, _223);
  float _225 = mad(-0.21492856740951538f, _222, _224);
  float _226 = _220 * -0.07655377686023712f;
  float _227 = mad(1.17622971534729f, _221, _226);
  float _228 = mad(-0.09967592358589172f, _222, _227);
  float _229 = _220 * 0.008316148072481155f;
  float _230 = mad(-0.006032449658960104f, _221, _229);
  float _231 = mad(0.9977163076400757f, _222, _230);
  float _232 = max(_225, 0.0f);
  float _233 = max(_228, 0.0f);
  float _234 = max(_231, 0.0f);
  float _235 = min(_232, 65504.0f);
  float _236 = min(_233, 65504.0f);
  float _237 = min(_234, 65504.0f);
  float _238 = _235 * 0.970889151096344f;
  float _239 = mad(0.026963284239172935f, _236, _238);
  float _240 = mad(0.0021475818939507008f, _237, _239);
  float _241 = _235 * 0.010889154858887196f;
  float _242 = mad(0.9869632720947266f, _236, _241);
  float _243 = mad(0.0021475818939507008f, _237, _242);
  float _244 = mad(0.026963284239172935f, _236, _241);
  float _245 = mad(0.9621475338935852f, _237, _244);
  float _246 = log2(_240);
  float _247 = log2(_243);
  float _248 = log2(_245);
  float _249 = _246 + 17.47393035888672f;
  float _250 = _247 + 17.47393035888672f;
  float _251 = _248 + 17.47393035888672f;
  float _252 = _249 * 0.03030303120613098f;
  float _253 = _250 * 0.03030303120613098f;
  float _254 = _251 * 0.03030303120613098f;
  uint _255 = _174.x + -1u;
  float _256 = float((uint)_255);
  float _257 = float((uint)_174.x);
  float _258 = _256 / _257;
  float _259 = 0.5f / _257;
  float _260 = _252 * _258;
  float _261 = _253 * _258;
  float _262 = _254 * _258;
  float _263 = _260 + _259;
  float _264 = _261 + _259;
  float _265 = _262 + _259;
  float4 _266 = t13_space15.SampleLevel(s2_space1, float2(_263, 0.5f), 0.0f);
  float4 _268 = t13_space15.SampleLevel(s2_space1, float2(_264, 0.5f), 0.0f);
  float4 _270 = t13_space15.SampleLevel(s2_space1, float2(_265, 0.5f), 0.0f);
  float _272 = _266.x * 3.321928024291992f;
  float _273 = _268.x * 3.321928024291992f;
  float _274 = _270.x * 3.321928024291992f;
  float _275 = exp2(_272);
  float _276 = exp2(_273);
  float _277 = exp2(_274);
  float _278 = _275 / cb3_space9_036w;
  float _279 = _276 / cb3_space9_036w;
  float _280 = _277 / cb3_space9_036w;
  bool _281 = (cb3_space9_036y < 500.0f);
  float _319;
  float _320;
  float _321;
  float _371;
  float _379;
  float _387;
  if (_281) {
    float _283 = _278 * 0.6624541878700256f;
    float _284 = mad(0.13400420546531677f, _279, _283);
    float _285 = mad(0.15618768334388733f, _280, _284);
    float _286 = _278 * 0.2722287178039551f;
    float _287 = mad(0.6740817427635193f, _279, _286);
    float _288 = mad(0.053689517080783844f, _280, _287);
    float _289 = _278 * -0.005574649665504694f;
    float _290 = mad(0.00406073359772563f, _279, _289);
    float _291 = mad(1.0103391408920288f, _280, _290);
    float _292 = _288 + _285;
    float _293 = _292 + _291;
    bool _294 = (_293 == 0.0f);
    float _295 = select(_294, 1.000000013351432e-10f, _293);
    float _296 = _285 / _295;
    float _297 = _288 / _295;
    float _298 = max(_288, 0.0f);
    float _299 = log2(_298);
    float _300 = _299 * 0.9811000227928162f;
    float _301 = exp2(_300);
    float _302 = _301 * _296;
    float _303 = max(_297, 1.000000013351432e-10f);
    float _304 = _302 / _303;
    float _305 = 1.0f - _296;
    float _306 = _305 - _297;
    float _307 = _301 * _306;
    float _308 = _307 / _303;
    float _309 = _304 * 1.6410233974456787f;
    float _310 = mad(-0.32480329275131226f, _301, _309);
    float _311 = mad(-0.23642469942569733f, _308, _310);
    float _312 = _304 * -0.663662850856781f;
    float _313 = mad(1.6153316497802734f, _301, _312);
    float _314 = mad(0.016756348311901093f, _308, _313);
    float _315 = _304 * 0.011721894145011902f;
    float _316 = mad(-0.008284442126750946f, _301, _315);
    float _317 = mad(0.9883948564529419f, _308, _316);
    _319 = _311;
    _320 = _314;
    _321 = _317;
  } else {
    _319 = _278;
    _320 = _279;
    _321 = _280;
  }
  float _322 = _319 * 1.6047539710998535f;
  float _323 = mad(-0.5310794711112976f, _320, _322);
  float _324 = mad(-0.07367203384637833f, _321, _323);
  float _325 = _319 * -0.10208318382501602f;
  float _326 = mad(1.108132243156433f, _320, _325);
  float _327 = mad(-0.006051875650882721f, _321, _326);
  float _328 = _319 * -0.0032670421060174704f;
  float _329 = mad(-0.07275524735450745f, _320, _328);
  float _330 = mad(1.0760219097137451f, _321, _329);
  float _331 = max(_324, 0.0f);
  float _332 = max(_327, 0.0f);
  float _333 = max(_330, 0.0f);
  float _334 = _331 * ATTRIBUTE_VCOLOR.x;
  float _335 = _332 * ATTRIBUTE_VCOLOR.y;
  float _336 = _333 * ATTRIBUTE_VCOLOR.z;
  float _337 = abs(_334);
  float _338 = abs(_335);
  float _339 = abs(_336);
  float _340 = log2(_337);
  float _341 = log2(_338);
  float _342 = log2(_339);
  float _343 = _340 * 0.4166666567325592f;
  float _344 = _341 * 0.4166666567325592f;
  float _345 = _342 * 0.4166666567325592f;
  float _346 = exp2(_343);
  float _347 = exp2(_344);
  float _348 = exp2(_345);
  bool _349 = isfinite(_346);
  bool _350 = isfinite(_347);
  bool _351 = isfinite(_348);
  float _352 = _346 * 1.0549999475479126f;
  float _353 = _347 * 1.0549999475479126f;
  float _354 = _348 * 1.0549999475479126f;
  float _355 = _352 + -0.054999999701976776f;
  float _356 = select(_349, _355, 0.9999999403953552f);
  float _357 = _353 + -0.054999999701976776f;
  float _358 = select(_350, _357, 0.9999999403953552f);
  float _359 = _354 + -0.054999999701976776f;
  float _360 = select(_351, _359, 0.9999999403953552f);
  float _361 = _335 * 12.920000076293945f;
  float _362 = _336 * 12.920000076293945f;
  bool _363 = (_334 > 0.0031308000907301903f);
  if (!_363) {
    float _365 = _334 * 12.920000076293945f;
    bool _366 = (_334 < 0.0031308000907301903f);
    if (!_366) {
      bool _368 = (_334 == 0.0031308000907301903f);
      if (_368) {
        _371 = _356;
      } else {
        _371 = 0.0f;
      }
    } else {
      _371 = _365;
    }
  } else {
    _371 = _356;
  }
  bool _372 = (_335 > 0.0031308000907301903f);
  if (!_372) {
    bool _374 = (_335 < 0.0031308000907301903f);
    if (!_374) {
      bool _376 = (_335 == 0.0031308000907301903f);
      if (_376) {
        _379 = _358;
      } else {
        _379 = 0.0f;
      }
    } else {
      _379 = _361;
    }
  } else {
    _379 = _358;
  }
  bool _380 = (_336 > 0.0031308000907301903f);
  if (!_380) {
    bool _382 = (_336 < 0.0031308000907301903f);
    if (!_382) {
      bool _384 = (_336 == 0.0031308000907301903f);
      if (_384) {
        _387 = _360;
      } else {
        _387 = 0.0f;
      }
    } else {
      _387 = _362;
    }
  } else {
    _387 = _360;
  }
  float _388 = dot(float3(_44, _45, _46), float3(_44, _45, _46));
  float _389 = rsqrt(_388);
  float _390 = _389 * _44;
  float _391 = _389 * _45;
  float _392 = _389 * _46;
  float _393 = _57 - cb1_space9_034x;
  bool _394 = (_393 < 0.0f);
  if (_394) discard;
  float _395 = SV_Position.y * SV_Position.x;
  float _396 = _395 + SV_Position.x;
  int _397 = int(_396);
  int _398 = _397 ^ 123459876;
  int _399 = _398 / 127773;
  uint _400 = _399 * -127773;
  uint _401 = _400 + _398;
  uint _402 = _401 * 16807;
  int _403 = _399 * -2836;
  uint _404 = _402 + _403;
  bool _405 = ((int)_404 < (int)0);
  int _406 = _404 + 2147483647;
  int _407 = select(_405, _406, _404);
  int _408 = _407 / 127773;
  uint _409 = _408 * -127773;
  uint _410 = _407 + _409;
  uint _411 = _410 * 16807;
  int _412 = _408 * -2836;
  uint _413 = _411 + _412;
  bool _414 = ((int)_413 < (int)0);
  int _415 = _413 + 2147483647;
  int _416 = select(_414, _415, _413);
  float _417 = float((int)(_416));
  float _418 = _417 * 4.656612873077393e-10f;
  float _419 = ATTRIBUTE_INSTANCE_PARAMS.w + -1.0f;
  float _420 = _419 + _418;
  bool _421 = (_420 < 0.0f);
  if (_421) discard;
  float _422 = ATTRIBUTE_POSITION_VIEW.x * ATTRIBUTE_POSITION_VIEW.x;
  float _423 = ATTRIBUTE_POSITION_VIEW.y * ATTRIBUTE_POSITION_VIEW.y;
  float _424 = _423 + _422;
  float _425 = ATTRIBUTE_POSITION_VIEW.z * ATTRIBUTE_POSITION_VIEW.z;
  float _426 = _424 + _425;
  float _427 = sqrt(_426);
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_161, _162, _163), 1.f);
    _371 = video.r;
    _379 = video.g;
    _387 = video.b;
  }
  float _428 = _371 * cb0_space5_008x;
  float _429 = _379 * cb0_space5_008y;
  float _430 = _387 * cb0_space5_008z;
  float _431 = _392 + -1.0f;
  float _432 = dot(float3(_390, _391, _431), float3(_390, _391, _431));
  float _433 = rsqrt(_432);
  float _434 = ATTRIBUTE_LIGHT_MASK * 26.0f;
  float _435 = _434 + 0.5f;
  uint _436 = uint(_435);
  uint _437 = _436 % 13;
  float _438 = float((uint)_437);
  float _439 = _438 * 0.03846153989434242f;
  bool _440 = (_428 < 0.0f);
  bool _441 = (_429 < 0.0f);
  bool _442 = (_430 < 0.0f);
  float _443 = select(_440, -0.0f, _428);
  float _444 = select(_441, -0.0f, _429);
  float _445 = select(_442, -0.0f, _430);
  float _446 = _390 * 0.5f;
  float _447 = _446 * _433;
  float _448 = _391 * 0.5f;
  float _449 = _448 * _433;
  float _450 = _447 + 0.5f;
  float _451 = _449 + 0.5f;
  SV_Target.x = _450;
  SV_Target.y = _451;
  SV_Target.z = 0.0f;
  SV_Target.w = 1.0f;
  SV_Target_1.x = 0.5f;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 1.0f;
  SV_Target_1.w = ATTRIBUTE_OBJECT_ID;
  SV_Target_2.x = _443;
  SV_Target_2.y = _444;
  SV_Target_2.z = _445;
  SV_Target_2.w = _427;
  SV_Target_3.x = 0.0f;
  SV_Target_3.y = 0.0f;
  SV_Target_3.z = 0.0f;
  SV_Target_3.w = 0.0019607844296842813f;
  SV_Target_4.x = 0.0f;
  SV_Target_4.y = 0.0f;
  SV_Target_4.z = 0.0f;
  SV_Target_4.w = _439;
  OutputSignature output_signature = {SV_Target, SV_Target_1, SV_Target_2, SV_Target_3, SV_Target_4};
  return output_signature;
}
