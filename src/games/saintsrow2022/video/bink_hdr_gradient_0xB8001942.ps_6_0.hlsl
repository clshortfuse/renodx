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
    linear float ATTRIBUTE_REFLECTION_DIST : ATTRIBUTE_REFLECTION_DIST,
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  bool _23 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_23) discard;
  float _24 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _25 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _26 = _24 + 1.0f;
  float _27 = 1.0f - _25;
  float _28 = _26 * 0.5f;
  float _29 = _27 * 0.5f;
  float4 _32 = t29_space15.SampleBias(s0_space1, float2(_28, _29), cb1_space9_035z, int2(0, 0));
  float _34 = _32.x * ATTRIBUTE_VCOLOR.w;
  float _35 = max(_34, 0.0f);
  float _36 = min(1.0f, _35);
  float4 _41 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _43 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _45 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _47 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _51 = cb3_space9_038x * _43.x;
  float _53 = _51 + cb3_space9_038z;
  float _55 = cb3_space9_038y * _45.x;
  float _57 = _55 + cb3_space9_038w;
  float _58 = _47.x + _41.x;
  float _61 = cb3_space9_037x * _58;
  float _62 = _53 * 0.008609036915004253f;
  float _63 = _53 * 0.5600313544273376f;
  float _64 = _61 + _62;
  float _65 = _61 - _62;
  float _66 = _63 + _61;
  float _67 = _57 * 0.11102962493896484f;
  float _68 = _57 * 0.3206271827220917f;
  float _69 = _64 + _67;
  float _70 = _65 - _67;
  float _71 = _66 - _68;
  float _72 = max(_69, 0.0f);
  float _73 = max(_70, 0.0f);
  float _74 = max(_71, 0.0f);
  float _75 = log2(_72);
  float _76 = log2(_73);
  float _77 = log2(_74);
  float _78 = _75 * 0.012683313339948654f;
  float _79 = _76 * 0.012683313339948654f;
  float _80 = _77 * 0.012683313339948654f;
  float _81 = exp2(_78);
  float _82 = exp2(_79);
  float _83 = exp2(_80);
  float _84 = _81 + -0.8359375f;
  float _85 = _82 + -0.8359375f;
  float _86 = _83 + -0.8359375f;
  float _87 = max(0.0f, _84);
  float _88 = max(0.0f, _85);
  float _89 = max(0.0f, _86);
  float _90 = _81 * 18.6875f;
  float _91 = _82 * 18.6875f;
  float _92 = _83 * 18.6875f;
  float _93 = 18.8515625f - _90;
  float _94 = 18.8515625f - _91;
  float _95 = 18.8515625f - _92;
  float _96 = _87 / _93;
  float _97 = _88 / _94;
  float _98 = _89 / _95;
  float _99 = abs(_96);
  float _100 = abs(_97);
  float _101 = abs(_98);
  float _102 = log2(_99);
  float _103 = log2(_100);
  float _104 = log2(_101);
  float _105 = _102 * 6.277394771575928f;
  float _106 = _103 * 6.277394771575928f;
  float _107 = _104 * 6.277394771575928f;
  float _108 = exp2(_105);
  float _109 = exp2(_106);
  float _110 = exp2(_107);
  float _111 = _108 * 3.4366066455841064f;
  float _112 = _108 * 0.791329562664032f;
  float _113 = _109 * 2.5064520835876465f;
  float _114 = _109 * 1.9836004972457886f;
  float _115 = _109 * 0.09891371428966522f;
  float _116 = _111 - _113;
  float _117 = _114 - _112;
  float _118 = _108 * -0.02594989910721779f;
  float _119 = _118 - _115;
  float _120 = _110 * 0.06984542310237885f;
  float _121 = _110 * 0.192270889878273f;
  float _122 = _110 * 1.124863624572754f;
  float _123 = _116 + _120;
  float _124 = _117 - _121;
  float _125 = _119 + _122;
  float _127 = cb3_space9_037y * 368.6400146484375f;
  float _128 = _127 * _123;
  float _129 = _127 * _124;
  float _130 = _127 * _125;
  float _131 = max(_128, 9.999999747378752e-05f);
  float _132 = max(_129, 9.999999747378752e-05f);
  float _133 = max(_130, 9.999999747378752e-05f);
  float _137 = log2(_131);
  float _138 = log2(_132);
  float _139 = log2(_133);
  float _140 = _137 + 9.720000267028809f;
  float _141 = _138 + 9.720000267028809f;
  float _142 = _139 + 9.720000267028809f;
  float _143 = _140 * 0.03030303120613098f;
  float _144 = _141 * 0.03030303120613098f;
  float _145 = _142 * 0.03030303120613098f;
  float _146 = _143 + 0.23496760427951813f;
  float _147 = _144 + 0.23496760427951813f;
  float _148 = _145 + 0.23496760427951813f;
  uint3 _149;
  t40_space15.GetDimensions(_149.x, _149.y, _149.z);
  uint2 _153;
  t13_space15.GetDimensions(_153.x, _153.y);
  uint _155 = _149.x + -1u;
  uint _156 = _149.y + -1u;
  uint _157 = _149.z + -1u;
  float _158 = float((uint)_155);
  float _159 = float((uint)_156);
  float _160 = float((uint)_157);
  float _161 = float((uint)_149.x);
  float _162 = float((uint)_149.y);
  float _163 = float((uint)_149.z);
  float _164 = _158 / _161;
  float _165 = _159 / _162;
  float _166 = _160 / _163;
  float _167 = 0.5f / _161;
  float _168 = 0.5f / _162;
  float _169 = 0.5f / _163;
  float _170 = _164 * _146;
  float _171 = _165 * _147;
  float _172 = _166 * _148;
  float _173 = _167 + _170;
  float _174 = _168 + _171;
  float _175 = _169 + _172;
  float4 _176 = t40_space15.SampleLevel(s2_space1, float3(_173, _174, _175), 0.0f);
  float _179 = exp2(_137);
  float _180 = exp2(_138);
  float _181 = exp2(_139);
  float _182 = _179 * 0.6954522132873535f;
  float _183 = mad(0.14067870378494263f, _180, _182);
  float _184 = mad(0.16386906802654266f, _181, _183);
  float _185 = _179 * 0.044794563204050064f;
  float _186 = mad(0.8596711158752441f, _180, _185);
  float _187 = mad(0.0955343171954155f, _181, _186);
  float _188 = _179 * -0.005525882821530104f;
  float _189 = mad(0.004025210160762072f, _180, _188);
  float _190 = mad(1.0015007257461548f, _181, _189);
  float _191 = _176.x + 1.0f;
  float _192 = _184 * _191;
  float _193 = _187 * _191;
  float _194 = _190 * _191;
  float _195 = _192 + _176.y;
  float _196 = max(_195, 0.0f);
  float _197 = max(_193, 0.0f);
  float _198 = max(_194, 0.0f);
  float _199 = min(_196, 65536.0f);
  float _200 = min(_197, 65536.0f);
  float _201 = min(_198, 65536.0f);
  float _202 = _199 * 1.4514392614364624f;
  float _203 = mad(-0.2365107536315918f, _200, _202);
  float _204 = mad(-0.21492856740951538f, _201, _203);
  float _205 = _199 * -0.07655377686023712f;
  float _206 = mad(1.17622971534729f, _200, _205);
  float _207 = mad(-0.09967592358589172f, _201, _206);
  float _208 = _199 * 0.008316148072481155f;
  float _209 = mad(-0.006032449658960104f, _200, _208);
  float _210 = mad(0.9977163076400757f, _201, _209);
  float _211 = max(_204, 0.0f);
  float _212 = max(_207, 0.0f);
  float _213 = max(_210, 0.0f);
  float _214 = min(_211, 65504.0f);
  float _215 = min(_212, 65504.0f);
  float _216 = min(_213, 65504.0f);
  float _217 = _214 * 0.970889151096344f;
  float _218 = mad(0.026963284239172935f, _215, _217);
  float _219 = mad(0.0021475818939507008f, _216, _218);
  float _220 = _214 * 0.010889154858887196f;
  float _221 = mad(0.9869632720947266f, _215, _220);
  float _222 = mad(0.0021475818939507008f, _216, _221);
  float _223 = mad(0.026963284239172935f, _215, _220);
  float _224 = mad(0.9621475338935852f, _216, _223);
  float _225 = log2(_219);
  float _226 = log2(_222);
  float _227 = log2(_224);
  float _228 = _225 + 17.47393035888672f;
  float _229 = _226 + 17.47393035888672f;
  float _230 = _227 + 17.47393035888672f;
  float _231 = _228 * 0.03030303120613098f;
  float _232 = _229 * 0.03030303120613098f;
  float _233 = _230 * 0.03030303120613098f;
  uint _234 = _153.x + -1u;
  float _235 = float((uint)_234);
  float _236 = float((uint)_153.x);
  float _237 = _235 / _236;
  float _238 = 0.5f / _236;
  float _239 = _231 * _237;
  float _240 = _232 * _237;
  float _241 = _233 * _237;
  float _242 = _239 + _238;
  float _243 = _240 + _238;
  float _244 = _241 + _238;
  float4 _245 = t13_space15.SampleLevel(s2_space1, float2(_242, 0.5f), 0.0f);
  float4 _247 = t13_space15.SampleLevel(s2_space1, float2(_243, 0.5f), 0.0f);
  float4 _249 = t13_space15.SampleLevel(s2_space1, float2(_244, 0.5f), 0.0f);
  float _251 = _245.x * 3.321928024291992f;
  float _252 = _247.x * 3.321928024291992f;
  float _253 = _249.x * 3.321928024291992f;
  float _254 = exp2(_251);
  float _255 = exp2(_252);
  float _256 = exp2(_253);
  float _257 = _254 / cb3_space9_036w;
  float _258 = _255 / cb3_space9_036w;
  float _259 = _256 / cb3_space9_036w;
  bool _260 = (cb3_space9_036y < 500.0f);
  float _298;
  float _299;
  float _300;
  float _350;
  float _358;
  float _366;
  if (_260) {
    float _262 = _257 * 0.6624541878700256f;
    float _263 = mad(0.13400420546531677f, _258, _262);
    float _264 = mad(0.15618768334388733f, _259, _263);
    float _265 = _257 * 0.2722287178039551f;
    float _266 = mad(0.6740817427635193f, _258, _265);
    float _267 = mad(0.053689517080783844f, _259, _266);
    float _268 = _257 * -0.005574649665504694f;
    float _269 = mad(0.00406073359772563f, _258, _268);
    float _270 = mad(1.0103391408920288f, _259, _269);
    float _271 = _267 + _264;
    float _272 = _271 + _270;
    bool _273 = (_272 == 0.0f);
    float _274 = select(_273, 1.000000013351432e-10f, _272);
    float _275 = _264 / _274;
    float _276 = _267 / _274;
    float _277 = max(_267, 0.0f);
    float _278 = log2(_277);
    float _279 = _278 * 0.9811000227928162f;
    float _280 = exp2(_279);
    float _281 = _280 * _275;
    float _282 = max(_276, 1.000000013351432e-10f);
    float _283 = _281 / _282;
    float _284 = 1.0f - _275;
    float _285 = _284 - _276;
    float _286 = _280 * _285;
    float _287 = _286 / _282;
    float _288 = _283 * 1.6410233974456787f;
    float _289 = mad(-0.32480329275131226f, _280, _288);
    float _290 = mad(-0.23642469942569733f, _287, _289);
    float _291 = _283 * -0.663662850856781f;
    float _292 = mad(1.6153316497802734f, _280, _291);
    float _293 = mad(0.016756348311901093f, _287, _292);
    float _294 = _283 * 0.011721894145011902f;
    float _295 = mad(-0.008284442126750946f, _280, _294);
    float _296 = mad(0.9883948564529419f, _287, _295);
    _298 = _290;
    _299 = _293;
    _300 = _296;
  } else {
    _298 = _257;
    _299 = _258;
    _300 = _259;
  }
  float _301 = _298 * 1.6047539710998535f;
  float _302 = mad(-0.5310794711112976f, _299, _301);
  float _303 = mad(-0.07367203384637833f, _300, _302);
  float _304 = _298 * -0.10208318382501602f;
  float _305 = mad(1.108132243156433f, _299, _304);
  float _306 = mad(-0.006051875650882721f, _300, _305);
  float _307 = _298 * -0.0032670421060174704f;
  float _308 = mad(-0.07275524735450745f, _299, _307);
  float _309 = mad(1.0760219097137451f, _300, _308);
  float _310 = max(_303, 0.0f);
  float _311 = max(_306, 0.0f);
  float _312 = max(_309, 0.0f);
  float _313 = _310 * ATTRIBUTE_VCOLOR.x;
  float _314 = _311 * ATTRIBUTE_VCOLOR.y;
  float _315 = _312 * ATTRIBUTE_VCOLOR.z;
  float _316 = abs(_313);
  float _317 = abs(_314);
  float _318 = abs(_315);
  float _319 = log2(_316);
  float _320 = log2(_317);
  float _321 = log2(_318);
  float _322 = _319 * 0.4166666567325592f;
  float _323 = _320 * 0.4166666567325592f;
  float _324 = _321 * 0.4166666567325592f;
  float _325 = exp2(_322);
  float _326 = exp2(_323);
  float _327 = exp2(_324);
  bool _328 = isfinite(_325);
  bool _329 = isfinite(_326);
  bool _330 = isfinite(_327);
  float _331 = _325 * 1.0549999475479126f;
  float _332 = _326 * 1.0549999475479126f;
  float _333 = _327 * 1.0549999475479126f;
  float _334 = _331 + -0.054999999701976776f;
  float _335 = select(_328, _334, 0.9999999403953552f);
  float _336 = _332 + -0.054999999701976776f;
  float _337 = select(_329, _336, 0.9999999403953552f);
  float _338 = _333 + -0.054999999701976776f;
  float _339 = select(_330, _338, 0.9999999403953552f);
  float _340 = _314 * 12.920000076293945f;
  float _341 = _315 * 12.920000076293945f;
  bool _342 = (_313 > 0.0031308000907301903f);
  if (!_342) {
    float _344 = _313 * 12.920000076293945f;
    bool _345 = (_313 < 0.0031308000907301903f);
    if (!_345) {
      bool _347 = (_313 == 0.0031308000907301903f);
      if (_347) {
        _350 = _335;
      } else {
        _350 = 0.0f;
      }
    } else {
      _350 = _344;
    }
  } else {
    _350 = _335;
  }
  bool _351 = (_314 > 0.0031308000907301903f);
  if (!_351) {
    bool _353 = (_314 < 0.0031308000907301903f);
    if (!_353) {
      bool _355 = (_314 == 0.0031308000907301903f);
      if (_355) {
        _358 = _337;
      } else {
        _358 = 0.0f;
      }
    } else {
      _358 = _340;
    }
  } else {
    _358 = _337;
  }
  bool _359 = (_315 > 0.0031308000907301903f);
  if (!_359) {
    bool _361 = (_315 < 0.0031308000907301903f);
    if (!_361) {
      bool _363 = (_315 == 0.0031308000907301903f);
      if (_363) {
        _366 = _339;
      } else {
        _366 = 0.0f;
      }
    } else {
      _366 = _341;
    }
  } else {
    _366 = _339;
  }
  float _367 = _36 - cb1_space9_034x;
  bool _368 = (_367 < 0.0f);
  if (_368) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_140, _141, _142), 1.f);
    _350 = video.r;
    _358 = video.g;
    _366 = video.b;
  }
  float _374 = cb0_space5_008x * _350;
  float _375 = cb0_space5_008y * _358;
  float _376 = cb0_space5_008z * _366;
  float _377 = cb0_space5_008w * _36;
  float _378 = _374 * cb0_space5_008w;
  float _379 = _375 * cb0_space5_008w;
  float _380 = _376 * cb0_space5_008w;
  SV_Target.x = _378;
  SV_Target.y = _379;
  SV_Target.z = _380;
  SV_Target.w = _377;
  return SV_Target;
}
