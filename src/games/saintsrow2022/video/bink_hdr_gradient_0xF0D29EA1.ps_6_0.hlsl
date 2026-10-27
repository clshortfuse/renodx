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

float4 main(
    noperspective float4 SV_Position : SV_Position,
    float4 ATTRIBUTE_POSITION_INTERPOLATED : ATTRIBUTE_POSITION_INTERPOLATED,
    linear float2 UVS_PACKED_ATTR : UVS_PACKED_ATTR,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  float _23 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _24 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _25 = _23 + 1.0f;
  float _26 = 1.0f - _24;
  float _27 = _25 * 0.5f;
  float _28 = _26 * 0.5f;
  float4 _31 = t29_space15.SampleBias(s0_space1, float2(_27, _28), cb1_space9_035z, int2(0, 0));
  float _33 = _31.x * ATTRIBUTE_VCOLOR.w;
  float _34 = max(_33, 0.0f);
  float _35 = min(1.0f, _34);
  float4 _40 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _42 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _44 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _46 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _50 = cb3_space9_038x * _42.x;
  float _52 = _50 + cb3_space9_038z;
  float _54 = cb3_space9_038y * _44.x;
  float _56 = _54 + cb3_space9_038w;
  float _57 = _46.x + _40.x;
  float _60 = cb3_space9_037x * _57;
  float _61 = _52 * 0.008609036915004253f;
  float _62 = _52 * 0.5600313544273376f;
  float _63 = _60 + _61;
  float _64 = _60 - _61;
  float _65 = _62 + _60;
  float _66 = _56 * 0.11102962493896484f;
  float _67 = _56 * 0.3206271827220917f;
  float _68 = _63 + _66;
  float _69 = _64 - _66;
  float _70 = _65 - _67;
  float _71 = max(_68, 0.0f);
  float _72 = max(_69, 0.0f);
  float _73 = max(_70, 0.0f);
  float _74 = log2(_71);
  float _75 = log2(_72);
  float _76 = log2(_73);
  float _77 = _74 * 0.012683313339948654f;
  float _78 = _75 * 0.012683313339948654f;
  float _79 = _76 * 0.012683313339948654f;
  float _80 = exp2(_77);
  float _81 = exp2(_78);
  float _82 = exp2(_79);
  float _83 = _80 + -0.8359375f;
  float _84 = _81 + -0.8359375f;
  float _85 = _82 + -0.8359375f;
  float _86 = max(0.0f, _83);
  float _87 = max(0.0f, _84);
  float _88 = max(0.0f, _85);
  float _89 = _80 * 18.6875f;
  float _90 = _81 * 18.6875f;
  float _91 = _82 * 18.6875f;
  float _92 = 18.8515625f - _89;
  float _93 = 18.8515625f - _90;
  float _94 = 18.8515625f - _91;
  float _95 = _86 / _92;
  float _96 = _87 / _93;
  float _97 = _88 / _94;
  float _98 = abs(_95);
  float _99 = abs(_96);
  float _100 = abs(_97);
  float _101 = log2(_98);
  float _102 = log2(_99);
  float _103 = log2(_100);
  float _104 = _101 * 6.277394771575928f;
  float _105 = _102 * 6.277394771575928f;
  float _106 = _103 * 6.277394771575928f;
  float _107 = exp2(_104);
  float _108 = exp2(_105);
  float _109 = exp2(_106);
  float _110 = _107 * 3.4366066455841064f;
  float _111 = _107 * 0.791329562664032f;
  float _112 = _108 * 2.5064520835876465f;
  float _113 = _108 * 1.9836004972457886f;
  float _114 = _108 * 0.09891371428966522f;
  float _115 = _110 - _112;
  float _116 = _113 - _111;
  float _117 = _107 * -0.02594989910721779f;
  float _118 = _117 - _114;
  float _119 = _109 * 0.06984542310237885f;
  float _120 = _109 * 0.192270889878273f;
  float _121 = _109 * 1.124863624572754f;
  float _122 = _115 + _119;
  float _123 = _116 - _120;
  float _124 = _118 + _121;
  float _126 = cb3_space9_037y * 368.6400146484375f;
  float _127 = _126 * _122;
  float _128 = _126 * _123;
  float _129 = _126 * _124;
  float _130 = max(_127, 9.999999747378752e-05f);
  float _131 = max(_128, 9.999999747378752e-05f);
  float _132 = max(_129, 9.999999747378752e-05f);
  float _136 = log2(_130);
  float _137 = log2(_131);
  float _138 = log2(_132);
  float _139 = _136 + 9.720000267028809f;
  float _140 = _137 + 9.720000267028809f;
  float _141 = _138 + 9.720000267028809f;
  float _142 = _139 * 0.03030303120613098f;
  float _143 = _140 * 0.03030303120613098f;
  float _144 = _141 * 0.03030303120613098f;
  float _145 = _142 + 0.23496760427951813f;
  float _146 = _143 + 0.23496760427951813f;
  float _147 = _144 + 0.23496760427951813f;
  uint3 _148;
  t40_space15.GetDimensions(_148.x, _148.y, _148.z);
  uint2 _152;
  t13_space15.GetDimensions(_152.x, _152.y);
  uint _154 = _148.x + -1u;
  uint _155 = _148.y + -1u;
  uint _156 = _148.z + -1u;
  float _157 = float((uint)_154);
  float _158 = float((uint)_155);
  float _159 = float((uint)_156);
  float _160 = float((uint)_148.x);
  float _161 = float((uint)_148.y);
  float _162 = float((uint)_148.z);
  float _163 = _157 / _160;
  float _164 = _158 / _161;
  float _165 = _159 / _162;
  float _166 = 0.5f / _160;
  float _167 = 0.5f / _161;
  float _168 = 0.5f / _162;
  float _169 = _163 * _145;
  float _170 = _164 * _146;
  float _171 = _165 * _147;
  float _172 = _166 + _169;
  float _173 = _167 + _170;
  float _174 = _168 + _171;
  float4 _175 = t40_space15.SampleLevel(s2_space1, float3(_172, _173, _174), 0.0f);
  float _178 = exp2(_136);
  float _179 = exp2(_137);
  float _180 = exp2(_138);
  float _181 = _178 * 0.6954522132873535f;
  float _182 = mad(0.14067870378494263f, _179, _181);
  float _183 = mad(0.16386906802654266f, _180, _182);
  float _184 = _178 * 0.044794563204050064f;
  float _185 = mad(0.8596711158752441f, _179, _184);
  float _186 = mad(0.0955343171954155f, _180, _185);
  float _187 = _178 * -0.005525882821530104f;
  float _188 = mad(0.004025210160762072f, _179, _187);
  float _189 = mad(1.0015007257461548f, _180, _188);
  float _190 = _175.x + 1.0f;
  float _191 = _183 * _190;
  float _192 = _186 * _190;
  float _193 = _189 * _190;
  float _194 = _191 + _175.y;
  float _195 = max(_194, 0.0f);
  float _196 = max(_192, 0.0f);
  float _197 = max(_193, 0.0f);
  float _198 = min(_195, 65536.0f);
  float _199 = min(_196, 65536.0f);
  float _200 = min(_197, 65536.0f);
  float _201 = _198 * 1.4514392614364624f;
  float _202 = mad(-0.2365107536315918f, _199, _201);
  float _203 = mad(-0.21492856740951538f, _200, _202);
  float _204 = _198 * -0.07655377686023712f;
  float _205 = mad(1.17622971534729f, _199, _204);
  float _206 = mad(-0.09967592358589172f, _200, _205);
  float _207 = _198 * 0.008316148072481155f;
  float _208 = mad(-0.006032449658960104f, _199, _207);
  float _209 = mad(0.9977163076400757f, _200, _208);
  float _210 = max(_203, 0.0f);
  float _211 = max(_206, 0.0f);
  float _212 = max(_209, 0.0f);
  float _213 = min(_210, 65504.0f);
  float _214 = min(_211, 65504.0f);
  float _215 = min(_212, 65504.0f);
  float _216 = _213 * 0.970889151096344f;
  float _217 = mad(0.026963284239172935f, _214, _216);
  float _218 = mad(0.0021475818939507008f, _215, _217);
  float _219 = _213 * 0.010889154858887196f;
  float _220 = mad(0.9869632720947266f, _214, _219);
  float _221 = mad(0.0021475818939507008f, _215, _220);
  float _222 = mad(0.026963284239172935f, _214, _219);
  float _223 = mad(0.9621475338935852f, _215, _222);
  float _224 = log2(_218);
  float _225 = log2(_221);
  float _226 = log2(_223);
  float _227 = _224 + 17.47393035888672f;
  float _228 = _225 + 17.47393035888672f;
  float _229 = _226 + 17.47393035888672f;
  float _230 = _227 * 0.03030303120613098f;
  float _231 = _228 * 0.03030303120613098f;
  float _232 = _229 * 0.03030303120613098f;
  uint _233 = _152.x + -1u;
  float _234 = float((uint)_233);
  float _235 = float((uint)_152.x);
  float _236 = _234 / _235;
  float _237 = 0.5f / _235;
  float _238 = _230 * _236;
  float _239 = _231 * _236;
  float _240 = _232 * _236;
  float _241 = _238 + _237;
  float _242 = _239 + _237;
  float _243 = _240 + _237;
  float4 _244 = t13_space15.SampleLevel(s2_space1, float2(_241, 0.5f), 0.0f);
  float4 _246 = t13_space15.SampleLevel(s2_space1, float2(_242, 0.5f), 0.0f);
  float4 _248 = t13_space15.SampleLevel(s2_space1, float2(_243, 0.5f), 0.0f);
  float _250 = _244.x * 3.321928024291992f;
  float _251 = _246.x * 3.321928024291992f;
  float _252 = _248.x * 3.321928024291992f;
  float _253 = exp2(_250);
  float _254 = exp2(_251);
  float _255 = exp2(_252);
  float _256 = _253 / cb3_space9_036w;
  float _257 = _254 / cb3_space9_036w;
  float _258 = _255 / cb3_space9_036w;
  bool _259 = (cb3_space9_036y < 500.0f);
  float _297;
  float _298;
  float _299;
  float _349;
  float _357;
  float _365;
  if (_259) {
    float _261 = _256 * 0.6624541878700256f;
    float _262 = mad(0.13400420546531677f, _257, _261);
    float _263 = mad(0.15618768334388733f, _258, _262);
    float _264 = _256 * 0.2722287178039551f;
    float _265 = mad(0.6740817427635193f, _257, _264);
    float _266 = mad(0.053689517080783844f, _258, _265);
    float _267 = _256 * -0.005574649665504694f;
    float _268 = mad(0.00406073359772563f, _257, _267);
    float _269 = mad(1.0103391408920288f, _258, _268);
    float _270 = _266 + _263;
    float _271 = _270 + _269;
    bool _272 = (_271 == 0.0f);
    float _273 = select(_272, 1.000000013351432e-10f, _271);
    float _274 = _263 / _273;
    float _275 = _266 / _273;
    float _276 = max(_266, 0.0f);
    float _277 = log2(_276);
    float _278 = _277 * 0.9811000227928162f;
    float _279 = exp2(_278);
    float _280 = _279 * _274;
    float _281 = max(_275, 1.000000013351432e-10f);
    float _282 = _280 / _281;
    float _283 = 1.0f - _274;
    float _284 = _283 - _275;
    float _285 = _279 * _284;
    float _286 = _285 / _281;
    float _287 = _282 * 1.6410233974456787f;
    float _288 = mad(-0.32480329275131226f, _279, _287);
    float _289 = mad(-0.23642469942569733f, _286, _288);
    float _290 = _282 * -0.663662850856781f;
    float _291 = mad(1.6153316497802734f, _279, _290);
    float _292 = mad(0.016756348311901093f, _286, _291);
    float _293 = _282 * 0.011721894145011902f;
    float _294 = mad(-0.008284442126750946f, _279, _293);
    float _295 = mad(0.9883948564529419f, _286, _294);
    _297 = _289;
    _298 = _292;
    _299 = _295;
  } else {
    _297 = _256;
    _298 = _257;
    _299 = _258;
  }
  float _300 = _297 * 1.6047539710998535f;
  float _301 = mad(-0.5310794711112976f, _298, _300);
  float _302 = mad(-0.07367203384637833f, _299, _301);
  float _303 = _297 * -0.10208318382501602f;
  float _304 = mad(1.108132243156433f, _298, _303);
  float _305 = mad(-0.006051875650882721f, _299, _304);
  float _306 = _297 * -0.0032670421060174704f;
  float _307 = mad(-0.07275524735450745f, _298, _306);
  float _308 = mad(1.0760219097137451f, _299, _307);
  float _309 = max(_302, 0.0f);
  float _310 = max(_305, 0.0f);
  float _311 = max(_308, 0.0f);
  float _312 = _309 * ATTRIBUTE_VCOLOR.x;
  float _313 = _310 * ATTRIBUTE_VCOLOR.y;
  float _314 = _311 * ATTRIBUTE_VCOLOR.z;
  float _315 = abs(_312);
  float _316 = abs(_313);
  float _317 = abs(_314);
  float _318 = log2(_315);
  float _319 = log2(_316);
  float _320 = log2(_317);
  float _321 = _318 * 0.4166666567325592f;
  float _322 = _319 * 0.4166666567325592f;
  float _323 = _320 * 0.4166666567325592f;
  float _324 = exp2(_321);
  float _325 = exp2(_322);
  float _326 = exp2(_323);
  bool _327 = isfinite(_324);
  bool _328 = isfinite(_325);
  bool _329 = isfinite(_326);
  float _330 = _324 * 1.0549999475479126f;
  float _331 = _325 * 1.0549999475479126f;
  float _332 = _326 * 1.0549999475479126f;
  float _333 = _330 + -0.054999999701976776f;
  float _334 = select(_327, _333, 0.9999999403953552f);
  float _335 = _331 + -0.054999999701976776f;
  float _336 = select(_328, _335, 0.9999999403953552f);
  float _337 = _332 + -0.054999999701976776f;
  float _338 = select(_329, _337, 0.9999999403953552f);
  float _339 = _313 * 12.920000076293945f;
  float _340 = _314 * 12.920000076293945f;
  bool _341 = (_312 > 0.0031308000907301903f);
  if (!_341) {
    float _343 = _312 * 12.920000076293945f;
    bool _344 = (_312 < 0.0031308000907301903f);
    if (!_344) {
      bool _346 = (_312 == 0.0031308000907301903f);
      if (_346) {
        _349 = _334;
      } else {
        _349 = 0.0f;
      }
    } else {
      _349 = _343;
    }
  } else {
    _349 = _334;
  }
  bool _350 = (_313 > 0.0031308000907301903f);
  if (!_350) {
    bool _352 = (_313 < 0.0031308000907301903f);
    if (!_352) {
      bool _354 = (_313 == 0.0031308000907301903f);
      if (_354) {
        _357 = _336;
      } else {
        _357 = 0.0f;
      }
    } else {
      _357 = _339;
    }
  } else {
    _357 = _336;
  }
  bool _358 = (_314 > 0.0031308000907301903f);
  if (!_358) {
    bool _360 = (_314 < 0.0031308000907301903f);
    if (!_360) {
      bool _362 = (_314 == 0.0031308000907301903f);
      if (_362) {
        _365 = _338;
      } else {
        _365 = 0.0f;
      }
    } else {
      _365 = _340;
    }
  } else {
    _365 = _338;
  }
  float _366 = _35 - cb1_space9_034x;
  bool _367 = (_366 < 0.0f);
  if (_367) discard;
  float _373 = _35 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _374 = _373 * cb0_space5_008w;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_139, _140, _141), 1.f);
    _349 = video.r;
    _357 = video.g;
    _365 = video.b;
  }
  float _375 = _349 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _376 = _375 * cb0_space5_008x;
  float _377 = _376 * cb0_space5_008w;
  float _378 = _357 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _379 = _378 * cb0_space5_008y;
  float _380 = _379 * cb0_space5_008w;
  float _381 = _365 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _382 = _381 * cb0_space5_008z;
  float _383 = _382 * cb0_space5_008w;
  SV_Target.x = _377;
  SV_Target.y = _380;
  SV_Target.z = _383;
  SV_Target.w = _374;
  return SV_Target;
}
