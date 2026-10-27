#include "../tonemap/tonemap.hlsli"

// Post-tonemap material (runtime-only, not in engine.vpp_pc): tone maps its own texture with the global grade/ACES
// LUTs (t30/t40/t13, space15) and writes premultiplied, sRGB-encoded colour into the scene/UI buffer.

Texture2D<float4> t29_space15 : register(t29, space15);

Texture3D<float4> t30_space15 : register(t30, space15);

Texture3D<float4> t40_space15 : register(t40, space15);

Texture2D<float4> t13_space15 : register(t13, space15);

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  struct rl_mipstream_gpu_info {
    int rl_mipstream_gpu_info_000;
    float rl_mipstream_gpu_info_004;
    int2 rl_mipstream_gpu_info_008;
  } globals_000 : packoffset(c000.x);
  float globals_016 : packoffset(c001.x);
  float globals_020 : packoffset(c001.y);
};

cbuffer cb0_space5 : register(b0, space5) {
  float cb0_space5_008x : packoffset(c008.x);
  float cb0_space5_008y : packoffset(c008.y);
  float cb0_space5_008z : packoffset(c008.z);
  float cb0_space5_008w : packoffset(c008.w);
};

cbuffer cb1_space9 : register(b1, space9) {
  float cb1_space9_035z : packoffset(c035.z);
};

cbuffer cb3_space9 : register(b3, space9) {
  float cb3_space9_036y : packoffset(c036.y);
  float cb3_space9_036w : packoffset(c036.w);
  float cb3_space9_039x : packoffset(c039.x);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s1_space1 : register(s1, space1);

SamplerState s2_space1 : register(s2, space1);

float4 main(
    noperspective float4 SV_Position : SV_Position,
    float4 ATTRIBUTE_POSITION_INTERPOLATED : ATTRIBUTE_POSITION_INTERPOLATED,
    linear float2 UVS_PACKED_ATTR : UVS_PACKED_ATTR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  float _19 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _20 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _21 = _19 + 1.0f;
  float _22 = 1.0f - _20;
  float _23 = _21 * 0.5f;
  float _24 = _22 * 0.5f;
  float4 _27 = t29_space15.SampleBias(s1_space1, float2(_23, _24), cb1_space9_035z, int2(0, 0));
  float _29 = max(_27.x, 0.0f);
  float _30 = min(1.0f, _29);
  float4 _33 = t0.SampleBias(s1_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _42 = cb3_space9_039x * _33.x;
  float _43 = cb3_space9_039x * _33.y;
  float _44 = cb3_space9_039x * _33.z;
  float _45 = _42 * 0.6430370807647705f;
  float _46 = mad(0.31118518114089966f, _43, _45);
  float _47 = mad(0.04577704519033432f, _44, _46);
  float _48 = _42 * 0.059270311146974564f;
  float _49 = mad(0.9314354062080383f, _43, _48);
  float _50 = mad(0.009296739473938942f, _44, _49);
  float _51 = _42 * 0.0059599666856229305f;
  float _52 = mad(0.06392385065555573f, _43, _51);
  float _53 = mad(0.9301166534423828f, _44, _52);
  float _54 = log2(_47);
  float _55 = log2(_50);
  float _56 = log2(_53);
  float _57 = _54 + 9.720000267028809f;
  float _58 = _55 + 9.720000267028809f;
  float _59 = _56 + 9.720000267028809f;
  float _60 = _57 * 0.05707762390375137f;
  float _61 = _58 * 0.05707762390375137f;
  float _62 = _59 * 0.05707762390375137f;
  float _63 = -0.0f - _60;
  float _64 = -0.0f - _61;
  float _65 = -0.0f - _62;
  bool _68 = !(globals_016 == 0.0f);
  float _70 = dot(float3(_33.x, _33.y, _33.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _71 = max(_70, 1.000000013351432e-10f);
  float _72 = log2(_71);
  float _73 = _72 + 9.720000267028809f;
  float _74 = _73 * 0.05707762390375137f;
  bool _75 = (_74 < 0.0f);
  float _84;
  float _143;
  float _186;
  float _187;
  float _188;
  float _356;
  float _357;
  float _358;
  float _405;
  float _413;
  float _421;
  [branch] if (_68) {
    if (_75) {
      float _78 = -0.0f - _74;
      _84 = _78;
    } else {
      bool _80 = (_74 > 1.0f);
      if (_80) {
        float _82 = 1.0f - _74;
        _84 = _82;
      } else {
        _84 = 0.0f;
      }
    }
    float _85 = _84 + _60;
    float _86 = _84 + _61;
    float _87 = _84 + _62;
    float _88 = saturate(_85);
    float _89 = saturate(_86);
    float _90 = saturate(_87);
    uint2 _91;
    t1.GetDimensions(_91.x, _91.y);
    float _93 = float((uint)_91.y);
    float _94 = _93 + -1.0f;
    float _95 = _94 / _93;
    float _96 = 0.5f / _93;
    float _97 = _95 * _88;
    float _98 = _95 * _89;
    float _99 = _95 * _90;
    float _100 = _97 + _96;
    float _101 = _98 + _96;
    float _102 = _99 + _96;
    float _103 = _102 * _93;
    float _104 = _103 + -0.5f;
    float _105 = floor(_104);
    float _106 = _105 + 1.0f;
    float _107 = _104 - _105;
    float _108 = _105 + _100;
    float _109 = _108 / _93;
    float _110 = _106 + _100;
    float _111 = _110 / _93;
    float4 _112 = t1.Sample(s0_space1, float2(_109, _101));
    float4 _116 = t1.Sample(s0_space1, float2(_111, _101));
    float _120 = _116.x - _112.x;
    float _121 = _116.y - _112.y;
    float _122 = _116.z - _112.z;
    float _123 = _120 * _107;
    float _124 = _121 * _107;
    float _125 = _122 * _107;
    float _126 = _63 - _84;
    float _127 = _126 + _112.x;
    float _128 = _127 + _123;
    float _129 = _64 - _84;
    float _130 = _129 + _112.y;
    float _131 = _130 + _124;
    float _132 = _65 - _84;
    float _133 = _132 + _112.z;
    float _134 = _133 + _125;
    _186 = _128;
    _187 = _131;
    _188 = _134;
  }
  else {
    if (_75) {
      float _137 = -0.0f - _74;
      _143 = _137;
    } else {
      bool _139 = (_74 > 1.0f);
      if (_139) {
        float _141 = 1.0f - _74;
        _143 = _141;
      } else {
        _143 = 0.0f;
      }
    }
    float _144 = _143 + _60;
    float _145 = _143 + _61;
    float _146 = _143 + _62;
    float _147 = saturate(_144);
    float _148 = saturate(_145);
    float _149 = saturate(_146);
    uint3 _150;
    t30_space15.GetDimensions(_150.x, _150.y, _150.z);
    uint _154 = _150.x + -1u;
    uint _155 = _150.y + -1u;
    uint _156 = _150.z + -1u;
    float _157 = float((uint)_154);
    float _158 = float((uint)_155);
    float _159 = float((uint)_156);
    float _160 = float((uint)_150.x);
    float _161 = float((uint)_150.y);
    float _162 = float((uint)_150.z);
    float _163 = _157 / _160;
    float _164 = _158 / _161;
    float _165 = _159 / _162;
    float _166 = 0.5f / _160;
    float _167 = 0.5f / _161;
    float _168 = 0.5f / _162;
    float _169 = _163 * _147;
    float _170 = _164 * _148;
    float _171 = _165 * _149;
    float _172 = _166 + _169;
    float _173 = _167 + _170;
    float _174 = _168 + _171;
    float4 _175 = t30_space15.Sample(s0_space1, float3(_172, _173, _174));
    float _179 = _63 - _143;
    float _180 = _179 + _175.x;
    float _181 = _64 - _143;
    float _182 = _181 + _175.y;
    float _183 = _65 - _143;
    float _184 = _183 + _175.z;
    _186 = _180;
    _187 = _182;
    _188 = _184;
  }
  float _189 = _188 * globals_020;
  float _190 = _187 * globals_020;
  float _191 = _186 * globals_020;
  float _192 = _191 + _60;
  float _193 = _190 + _61;
  float _194 = _189 + _62;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float alpha = cb0_space5_008w * _30;
    return float4(ApplySaintsRowScene(float3(_192, _193, _194) * 17.52f, float3(cb0_space5_008x, cb0_space5_008y, cb0_space5_008z)) * alpha, alpha);
  }
  float _195 = _192 * 0.5309091210365295f;
  float _196 = _193 * 0.5309091210365295f;
  float _197 = _194 * 0.5309091210365295f;
  float _198 = _195 + 0.23496760427951813f;
  float _199 = _196 + 0.23496760427951813f;
  float _200 = _197 + 0.23496760427951813f;
  uint3 _201;
  t40_space15.GetDimensions(_201.x, _201.y, _201.z);
  uint2 _205;
  t13_space15.GetDimensions(_205.x, _205.y);
  uint _207 = _201.x + -1u;
  uint _208 = _201.y + -1u;
  uint _209 = _201.z + -1u;
  float _210 = float((uint)_207);
  float _211 = float((uint)_208);
  float _212 = float((uint)_209);
  float _213 = float((uint)_201.x);
  float _214 = float((uint)_201.y);
  float _215 = float((uint)_201.z);
  float _216 = _210 / _213;
  float _217 = _211 / _214;
  float _218 = _212 / _215;
  float _219 = 0.5f / _213;
  float _220 = 0.5f / _214;
  float _221 = 0.5f / _215;
  float _222 = _216 * _198;
  float _223 = _217 * _199;
  float _224 = _218 * _200;
  float _225 = _219 + _222;
  float _226 = _220 + _223;
  float _227 = _221 + _224;
  float4 _228 = t40_space15.SampleLevel(s2_space1, float3(_225, _226, _227), 0.0f);
  float _231 = _192 * 17.520000457763672f;
  float _232 = _193 * 17.520000457763672f;
  float _233 = _194 * 17.520000457763672f;
  float _234 = _231 + -9.719999313354492f;
  float _235 = _232 + -9.719999313354492f;
  float _236 = _233 + -9.719999313354492f;
  float _237 = exp2(_234);
  float _238 = exp2(_235);
  float _239 = exp2(_236);
  float _240 = _237 * 0.6954522132873535f;
  float _241 = mad(0.14067870378494263f, _238, _240);
  float _242 = mad(0.16386906802654266f, _239, _241);
  float _243 = _237 * 0.044794563204050064f;
  float _244 = mad(0.8596711158752441f, _238, _243);
  float _245 = mad(0.0955343171954155f, _239, _244);
  float _246 = _237 * -0.005525882821530104f;
  float _247 = mad(0.004025210160762072f, _238, _246);
  float _248 = mad(1.0015007257461548f, _239, _247);
  float _249 = _228.x + 1.0f;
  float _250 = _242 * _249;
  float _251 = _245 * _249;
  float _252 = _248 * _249;
  float _253 = _250 + _228.y;
  float _254 = max(_253, 0.0f);
  float _255 = max(_251, 0.0f);
  float _256 = max(_252, 0.0f);
  float _257 = min(_254, 65536.0f);
  float _258 = min(_255, 65536.0f);
  float _259 = min(_256, 65536.0f);
  float _260 = _257 * 1.4514392614364624f;
  float _261 = mad(-0.2365107536315918f, _258, _260);
  float _262 = mad(-0.21492856740951538f, _259, _261);
  float _263 = _257 * -0.07655377686023712f;
  float _264 = mad(1.17622971534729f, _258, _263);
  float _265 = mad(-0.09967592358589172f, _259, _264);
  float _266 = _257 * 0.008316148072481155f;
  float _267 = mad(-0.006032449658960104f, _258, _266);
  float _268 = mad(0.9977163076400757f, _259, _267);
  float _269 = max(_262, 0.0f);
  float _270 = max(_265, 0.0f);
  float _271 = max(_268, 0.0f);
  float _272 = min(_269, 65504.0f);
  float _273 = min(_270, 65504.0f);
  float _274 = min(_271, 65504.0f);
  float _275 = _272 * 0.970889151096344f;
  float _276 = mad(0.026963284239172935f, _273, _275);
  float _277 = mad(0.0021475818939507008f, _274, _276);
  float _278 = _272 * 0.010889154858887196f;
  float _279 = mad(0.9869632720947266f, _273, _278);
  float _280 = mad(0.0021475818939507008f, _274, _279);
  float _281 = mad(0.026963284239172935f, _273, _278);
  float _282 = mad(0.9621475338935852f, _274, _281);
  float _283 = log2(_277);
  float _284 = log2(_280);
  float _285 = log2(_282);
  float _286 = _283 + 17.47393035888672f;
  float _287 = _284 + 17.47393035888672f;
  float _288 = _285 + 17.47393035888672f;
  float _289 = _286 * 0.03030303120613098f;
  float _290 = _287 * 0.03030303120613098f;
  float _291 = _288 * 0.03030303120613098f;
  uint _292 = _205.x + -1u;
  float _293 = float((uint)_292);
  float _294 = float((uint)_205.x);
  float _295 = _293 / _294;
  float _296 = 0.5f / _294;
  float _297 = _289 * _295;
  float _298 = _290 * _295;
  float _299 = _291 * _295;
  float _300 = _297 + _296;
  float _301 = _298 + _296;
  float _302 = _299 + _296;
  float4 _303 = t13_space15.SampleLevel(s2_space1, float2(_300, 0.5f), 0.0f);
  float4 _305 = t13_space15.SampleLevel(s2_space1, float2(_301, 0.5f), 0.0f);
  float4 _307 = t13_space15.SampleLevel(s2_space1, float2(_302, 0.5f), 0.0f);
  float _309 = _303.x * 3.321928024291992f;
  float _310 = _305.x * 3.321928024291992f;
  float _311 = _307.x * 3.321928024291992f;
  float _312 = exp2(_309);
  float _313 = exp2(_310);
  float _314 = exp2(_311);
  float _315 = _312 / cb3_space9_036w;
  float _316 = _313 / cb3_space9_036w;
  float _317 = _314 / cb3_space9_036w;
  bool _318 = (cb3_space9_036y < 500.0f);
  if (_318) {
    float _320 = _315 * 0.6624541878700256f;
    float _321 = mad(0.13400420546531677f, _316, _320);
    float _322 = mad(0.15618768334388733f, _317, _321);
    float _323 = _315 * 0.2722287178039551f;
    float _324 = mad(0.6740817427635193f, _316, _323);
    float _325 = mad(0.053689517080783844f, _317, _324);
    float _326 = _315 * -0.005574649665504694f;
    float _327 = mad(0.00406073359772563f, _316, _326);
    float _328 = mad(1.0103391408920288f, _317, _327);
    float _329 = _325 + _322;
    float _330 = _329 + _328;
    bool _331 = (_330 == 0.0f);
    float _332 = select(_331, 1.000000013351432e-10f, _330);
    float _333 = _322 / _332;
    float _334 = _325 / _332;
    float _335 = max(_325, 0.0f);
    float _336 = log2(_335);
    float _337 = _336 * 0.9811000227928162f;
    float _338 = exp2(_337);
    float _339 = _338 * _333;
    float _340 = max(_334, 1.000000013351432e-10f);
    float _341 = _339 / _340;
    float _342 = 1.0f - _333;
    float _343 = _342 - _334;
    float _344 = _338 * _343;
    float _345 = _344 / _340;
    float _346 = _341 * 1.6410233974456787f;
    float _347 = mad(-0.32480329275131226f, _338, _346);
    float _348 = mad(-0.23642469942569733f, _345, _347);
    float _349 = _341 * -0.663662850856781f;
    float _350 = mad(1.6153316497802734f, _338, _349);
    float _351 = mad(0.016756348311901093f, _345, _350);
    float _352 = _341 * 0.011721894145011902f;
    float _353 = mad(-0.008284442126750946f, _338, _352);
    float _354 = mad(0.9883948564529419f, _345, _353);
    _356 = _348;
    _357 = _351;
    _358 = _354;
  } else {
    _356 = _315;
    _357 = _316;
    _358 = _317;
  }
  float _359 = _356 * 1.6047539710998535f;
  float _360 = mad(-0.5310794711112976f, _357, _359);
  float _361 = mad(-0.07367203384637833f, _358, _360);
  float _362 = _356 * -0.10208318382501602f;
  float _363 = mad(1.108132243156433f, _357, _362);
  float _364 = mad(-0.006051875650882721f, _358, _363);
  float _365 = _356 * -0.0032670421060174704f;
  float _366 = mad(-0.07275524735450745f, _357, _365);
  float _367 = mad(1.0760219097137451f, _358, _366);
  float _368 = max(_361, 0.0f);
  float _369 = max(_364, 0.0f);
  float _370 = max(_367, 0.0f);
  float _371 = abs(_368);
  float _372 = abs(_369);
  float _373 = abs(_370);
  float _374 = log2(_371);
  float _375 = log2(_372);
  float _376 = log2(_373);
  float _377 = _374 * 0.4166666567325592f;
  float _378 = _375 * 0.4166666567325592f;
  float _379 = _376 * 0.4166666567325592f;
  float _380 = exp2(_377);
  float _381 = exp2(_378);
  float _382 = exp2(_379);
  bool _383 = isfinite(_380);
  bool _384 = isfinite(_381);
  bool _385 = isfinite(_382);
  float _386 = _380 * 1.0549999475479126f;
  float _387 = _381 * 1.0549999475479126f;
  float _388 = _382 * 1.0549999475479126f;
  float _389 = _386 + -0.054999999701976776f;
  float _390 = select(_383, _389, 0.9999999403953552f);
  float _391 = _387 + -0.054999999701976776f;
  float _392 = select(_384, _391, 0.9999999403953552f);
  float _393 = _388 + -0.054999999701976776f;
  float _394 = select(_385, _393, 0.9999999403953552f);
  float _395 = _369 * 12.920000076293945f;
  float _396 = _370 * 12.920000076293945f;
  bool _397 = (_368 > 0.0031308000907301903f);
  if (!_397) {
    float _399 = _368 * 12.920000076293945f;
    bool _400 = (_368 < 0.0031308000907301903f);
    if (!_400) {
      bool _402 = (_368 == 0.0031308000907301903f);
      if (_402) {
        _405 = _390;
      } else {
        _405 = 0.0f;
      }
    } else {
      _405 = _399;
    }
  } else {
    _405 = _390;
  }
  bool _406 = (_369 > 0.0031308000907301903f);
  if (!_406) {
    bool _408 = (_369 < 0.0031308000907301903f);
    if (!_408) {
      bool _410 = (_369 == 0.0031308000907301903f);
      if (_410) {
        _413 = _392;
      } else {
        _413 = 0.0f;
      }
    } else {
      _413 = _395;
    }
  } else {
    _413 = _392;
  }
  bool _414 = (_370 > 0.0031308000907301903f);
  if (!_414) {
    bool _416 = (_370 < 0.0031308000907301903f);
    if (!_416) {
      bool _418 = (_370 == 0.0031308000907301903f);
      if (_418) {
        _421 = _394;
      } else {
        _421 = 0.0f;
      }
    } else {
      _421 = _396;
    }
  } else {
    _421 = _394;
  }
  float _427 = cb0_space5_008x * _405;
  float _428 = cb0_space5_008y * _413;
  float _429 = cb0_space5_008z * _421;
  float _430 = cb0_space5_008w * _30;
  float _431 = _427 * _430;
  float _432 = _428 * _430;
  float _433 = _429 * _430;
  SV_Target.x = _431;
  SV_Target.y = _432;
  SV_Target.z = _433;
  SV_Target.w = _430;
  return SV_Target;
}
