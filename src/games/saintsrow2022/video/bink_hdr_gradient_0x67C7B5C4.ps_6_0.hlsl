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
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  float _22 = ATTRIBUTE_POSITION_INTERPOLATED.x / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _23 = ATTRIBUTE_POSITION_INTERPOLATED.y / ATTRIBUTE_POSITION_INTERPOLATED.w;
  float _24 = _22 + 1.0f;
  float _25 = 1.0f - _23;
  float _26 = _24 * 0.5f;
  float _27 = _25 * 0.5f;
  float4 _30 = t29_space15.SampleBias(s0_space1, float2(_26, _27), cb1_space9_035z, int2(0, 0));
  float _32 = _30.x * ATTRIBUTE_VCOLOR.w;
  float _33 = max(_32, 0.0f);
  float _34 = min(1.0f, _33);
  float4 _39 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _41 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _43 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _45 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _49 = cb3_space9_038x * _41.x;
  float _51 = _49 + cb3_space9_038z;
  float _53 = cb3_space9_038y * _43.x;
  float _55 = _53 + cb3_space9_038w;
  float _56 = _45.x + _39.x;
  float _59 = cb3_space9_037x * _56;
  float _60 = _51 * 0.008609036915004253f;
  float _61 = _51 * 0.5600313544273376f;
  float _62 = _59 + _60;
  float _63 = _59 - _60;
  float _64 = _61 + _59;
  float _65 = _55 * 0.11102962493896484f;
  float _66 = _55 * 0.3206271827220917f;
  float _67 = _62 + _65;
  float _68 = _63 - _65;
  float _69 = _64 - _66;
  float _70 = max(_67, 0.0f);
  float _71 = max(_68, 0.0f);
  float _72 = max(_69, 0.0f);
  float _73 = log2(_70);
  float _74 = log2(_71);
  float _75 = log2(_72);
  float _76 = _73 * 0.012683313339948654f;
  float _77 = _74 * 0.012683313339948654f;
  float _78 = _75 * 0.012683313339948654f;
  float _79 = exp2(_76);
  float _80 = exp2(_77);
  float _81 = exp2(_78);
  float _82 = _79 + -0.8359375f;
  float _83 = _80 + -0.8359375f;
  float _84 = _81 + -0.8359375f;
  float _85 = max(0.0f, _82);
  float _86 = max(0.0f, _83);
  float _87 = max(0.0f, _84);
  float _88 = _79 * 18.6875f;
  float _89 = _80 * 18.6875f;
  float _90 = _81 * 18.6875f;
  float _91 = 18.8515625f - _88;
  float _92 = 18.8515625f - _89;
  float _93 = 18.8515625f - _90;
  float _94 = _85 / _91;
  float _95 = _86 / _92;
  float _96 = _87 / _93;
  float _97 = abs(_94);
  float _98 = abs(_95);
  float _99 = abs(_96);
  float _100 = log2(_97);
  float _101 = log2(_98);
  float _102 = log2(_99);
  float _103 = _100 * 6.277394771575928f;
  float _104 = _101 * 6.277394771575928f;
  float _105 = _102 * 6.277394771575928f;
  float _106 = exp2(_103);
  float _107 = exp2(_104);
  float _108 = exp2(_105);
  float _109 = _106 * 3.4366066455841064f;
  float _110 = _106 * 0.791329562664032f;
  float _111 = _107 * 2.5064520835876465f;
  float _112 = _107 * 1.9836004972457886f;
  float _113 = _107 * 0.09891371428966522f;
  float _114 = _109 - _111;
  float _115 = _112 - _110;
  float _116 = _106 * -0.02594989910721779f;
  float _117 = _116 - _113;
  float _118 = _108 * 0.06984542310237885f;
  float _119 = _108 * 0.192270889878273f;
  float _120 = _108 * 1.124863624572754f;
  float _121 = _114 + _118;
  float _122 = _115 - _119;
  float _123 = _117 + _120;
  float _125 = cb3_space9_037y * 368.6400146484375f;
  float _126 = _125 * _121;
  float _127 = _125 * _122;
  float _128 = _125 * _123;
  float _129 = max(_126, 9.999999747378752e-05f);
  float _130 = max(_127, 9.999999747378752e-05f);
  float _131 = max(_128, 9.999999747378752e-05f);
  float _135 = log2(_129);
  float _136 = log2(_130);
  float _137 = log2(_131);
  float _138 = _135 + 9.720000267028809f;
  float _139 = _136 + 9.720000267028809f;
  float _140 = _137 + 9.720000267028809f;
  float _141 = _138 * 0.03030303120613098f;
  float _142 = _139 * 0.03030303120613098f;
  float _143 = _140 * 0.03030303120613098f;
  float _144 = _141 + 0.23496760427951813f;
  float _145 = _142 + 0.23496760427951813f;
  float _146 = _143 + 0.23496760427951813f;
  uint3 _147;
  t40_space15.GetDimensions(_147.x, _147.y, _147.z);
  uint2 _151;
  t13_space15.GetDimensions(_151.x, _151.y);
  uint _153 = _147.x + -1u;
  uint _154 = _147.y + -1u;
  uint _155 = _147.z + -1u;
  float _156 = float((uint)_153);
  float _157 = float((uint)_154);
  float _158 = float((uint)_155);
  float _159 = float((uint)_147.x);
  float _160 = float((uint)_147.y);
  float _161 = float((uint)_147.z);
  float _162 = _156 / _159;
  float _163 = _157 / _160;
  float _164 = _158 / _161;
  float _165 = 0.5f / _159;
  float _166 = 0.5f / _160;
  float _167 = 0.5f / _161;
  float _168 = _162 * _144;
  float _169 = _163 * _145;
  float _170 = _164 * _146;
  float _171 = _165 + _168;
  float _172 = _166 + _169;
  float _173 = _167 + _170;
  float4 _174 = t40_space15.SampleLevel(s2_space1, float3(_171, _172, _173), 0.0f);
  float _177 = exp2(_135);
  float _178 = exp2(_136);
  float _179 = exp2(_137);
  float _180 = _177 * 0.6954522132873535f;
  float _181 = mad(0.14067870378494263f, _178, _180);
  float _182 = mad(0.16386906802654266f, _179, _181);
  float _183 = _177 * 0.044794563204050064f;
  float _184 = mad(0.8596711158752441f, _178, _183);
  float _185 = mad(0.0955343171954155f, _179, _184);
  float _186 = _177 * -0.005525882821530104f;
  float _187 = mad(0.004025210160762072f, _178, _186);
  float _188 = mad(1.0015007257461548f, _179, _187);
  float _189 = _174.x + 1.0f;
  float _190 = _182 * _189;
  float _191 = _185 * _189;
  float _192 = _188 * _189;
  float _193 = _190 + _174.y;
  float _194 = max(_193, 0.0f);
  float _195 = max(_191, 0.0f);
  float _196 = max(_192, 0.0f);
  float _197 = min(_194, 65536.0f);
  float _198 = min(_195, 65536.0f);
  float _199 = min(_196, 65536.0f);
  float _200 = _197 * 1.4514392614364624f;
  float _201 = mad(-0.2365107536315918f, _198, _200);
  float _202 = mad(-0.21492856740951538f, _199, _201);
  float _203 = _197 * -0.07655377686023712f;
  float _204 = mad(1.17622971534729f, _198, _203);
  float _205 = mad(-0.09967592358589172f, _199, _204);
  float _206 = _197 * 0.008316148072481155f;
  float _207 = mad(-0.006032449658960104f, _198, _206);
  float _208 = mad(0.9977163076400757f, _199, _207);
  float _209 = max(_202, 0.0f);
  float _210 = max(_205, 0.0f);
  float _211 = max(_208, 0.0f);
  float _212 = min(_209, 65504.0f);
  float _213 = min(_210, 65504.0f);
  float _214 = min(_211, 65504.0f);
  float _215 = _212 * 0.970889151096344f;
  float _216 = mad(0.026963284239172935f, _213, _215);
  float _217 = mad(0.0021475818939507008f, _214, _216);
  float _218 = _212 * 0.010889154858887196f;
  float _219 = mad(0.9869632720947266f, _213, _218);
  float _220 = mad(0.0021475818939507008f, _214, _219);
  float _221 = mad(0.026963284239172935f, _213, _218);
  float _222 = mad(0.9621475338935852f, _214, _221);
  float _223 = log2(_217);
  float _224 = log2(_220);
  float _225 = log2(_222);
  float _226 = _223 + 17.47393035888672f;
  float _227 = _224 + 17.47393035888672f;
  float _228 = _225 + 17.47393035888672f;
  float _229 = _226 * 0.03030303120613098f;
  float _230 = _227 * 0.03030303120613098f;
  float _231 = _228 * 0.03030303120613098f;
  uint _232 = _151.x + -1u;
  float _233 = float((uint)_232);
  float _234 = float((uint)_151.x);
  float _235 = _233 / _234;
  float _236 = 0.5f / _234;
  float _237 = _229 * _235;
  float _238 = _230 * _235;
  float _239 = _231 * _235;
  float _240 = _237 + _236;
  float _241 = _238 + _236;
  float _242 = _239 + _236;
  float4 _243 = t13_space15.SampleLevel(s2_space1, float2(_240, 0.5f), 0.0f);
  float4 _245 = t13_space15.SampleLevel(s2_space1, float2(_241, 0.5f), 0.0f);
  float4 _247 = t13_space15.SampleLevel(s2_space1, float2(_242, 0.5f), 0.0f);
  float _249 = _243.x * 3.321928024291992f;
  float _250 = _245.x * 3.321928024291992f;
  float _251 = _247.x * 3.321928024291992f;
  float _252 = exp2(_249);
  float _253 = exp2(_250);
  float _254 = exp2(_251);
  float _255 = _252 / cb3_space9_036w;
  float _256 = _253 / cb3_space9_036w;
  float _257 = _254 / cb3_space9_036w;
  bool _258 = (cb3_space9_036y < 500.0f);
  float _296;
  float _297;
  float _298;
  float _348;
  float _356;
  float _364;
  if (_258) {
    float _260 = _255 * 0.6624541878700256f;
    float _261 = mad(0.13400420546531677f, _256, _260);
    float _262 = mad(0.15618768334388733f, _257, _261);
    float _263 = _255 * 0.2722287178039551f;
    float _264 = mad(0.6740817427635193f, _256, _263);
    float _265 = mad(0.053689517080783844f, _257, _264);
    float _266 = _255 * -0.005574649665504694f;
    float _267 = mad(0.00406073359772563f, _256, _266);
    float _268 = mad(1.0103391408920288f, _257, _267);
    float _269 = _265 + _262;
    float _270 = _269 + _268;
    bool _271 = (_270 == 0.0f);
    float _272 = select(_271, 1.000000013351432e-10f, _270);
    float _273 = _262 / _272;
    float _274 = _265 / _272;
    float _275 = max(_265, 0.0f);
    float _276 = log2(_275);
    float _277 = _276 * 0.9811000227928162f;
    float _278 = exp2(_277);
    float _279 = _278 * _273;
    float _280 = max(_274, 1.000000013351432e-10f);
    float _281 = _279 / _280;
    float _282 = 1.0f - _273;
    float _283 = _282 - _274;
    float _284 = _278 * _283;
    float _285 = _284 / _280;
    float _286 = _281 * 1.6410233974456787f;
    float _287 = mad(-0.32480329275131226f, _278, _286);
    float _288 = mad(-0.23642469942569733f, _285, _287);
    float _289 = _281 * -0.663662850856781f;
    float _290 = mad(1.6153316497802734f, _278, _289);
    float _291 = mad(0.016756348311901093f, _285, _290);
    float _292 = _281 * 0.011721894145011902f;
    float _293 = mad(-0.008284442126750946f, _278, _292);
    float _294 = mad(0.9883948564529419f, _285, _293);
    _296 = _288;
    _297 = _291;
    _298 = _294;
  } else {
    _296 = _255;
    _297 = _256;
    _298 = _257;
  }
  float _299 = _296 * 1.6047539710998535f;
  float _300 = mad(-0.5310794711112976f, _297, _299);
  float _301 = mad(-0.07367203384637833f, _298, _300);
  float _302 = _296 * -0.10208318382501602f;
  float _303 = mad(1.108132243156433f, _297, _302);
  float _304 = mad(-0.006051875650882721f, _298, _303);
  float _305 = _296 * -0.0032670421060174704f;
  float _306 = mad(-0.07275524735450745f, _297, _305);
  float _307 = mad(1.0760219097137451f, _298, _306);
  float _308 = max(_301, 0.0f);
  float _309 = max(_304, 0.0f);
  float _310 = max(_307, 0.0f);
  float _311 = _308 * ATTRIBUTE_VCOLOR.x;
  float _312 = _309 * ATTRIBUTE_VCOLOR.y;
  float _313 = _310 * ATTRIBUTE_VCOLOR.z;
  float _314 = abs(_311);
  float _315 = abs(_312);
  float _316 = abs(_313);
  float _317 = log2(_314);
  float _318 = log2(_315);
  float _319 = log2(_316);
  float _320 = _317 * 0.4166666567325592f;
  float _321 = _318 * 0.4166666567325592f;
  float _322 = _319 * 0.4166666567325592f;
  float _323 = exp2(_320);
  float _324 = exp2(_321);
  float _325 = exp2(_322);
  bool _326 = isfinite(_323);
  bool _327 = isfinite(_324);
  bool _328 = isfinite(_325);
  float _329 = _323 * 1.0549999475479126f;
  float _330 = _324 * 1.0549999475479126f;
  float _331 = _325 * 1.0549999475479126f;
  float _332 = _329 + -0.054999999701976776f;
  float _333 = select(_326, _332, 0.9999999403953552f);
  float _334 = _330 + -0.054999999701976776f;
  float _335 = select(_327, _334, 0.9999999403953552f);
  float _336 = _331 + -0.054999999701976776f;
  float _337 = select(_328, _336, 0.9999999403953552f);
  float _338 = _312 * 12.920000076293945f;
  float _339 = _313 * 12.920000076293945f;
  bool _340 = (_311 > 0.0031308000907301903f);
  if (!_340) {
    float _342 = _311 * 12.920000076293945f;
    bool _343 = (_311 < 0.0031308000907301903f);
    if (!_343) {
      bool _345 = (_311 == 0.0031308000907301903f);
      if (_345) {
        _348 = _333;
      } else {
        _348 = 0.0f;
      }
    } else {
      _348 = _342;
    }
  } else {
    _348 = _333;
  }
  bool _349 = (_312 > 0.0031308000907301903f);
  if (!_349) {
    bool _351 = (_312 < 0.0031308000907301903f);
    if (!_351) {
      bool _353 = (_312 == 0.0031308000907301903f);
      if (_353) {
        _356 = _335;
      } else {
        _356 = 0.0f;
      }
    } else {
      _356 = _338;
    }
  } else {
    _356 = _335;
  }
  bool _357 = (_313 > 0.0031308000907301903f);
  if (!_357) {
    bool _359 = (_313 < 0.0031308000907301903f);
    if (!_359) {
      bool _361 = (_313 == 0.0031308000907301903f);
      if (_361) {
        _364 = _337;
      } else {
        _364 = 0.0f;
      }
    } else {
      _364 = _339;
    }
  } else {
    _364 = _337;
  }
  float _365 = _34 - cb1_space9_034x;
  bool _366 = (_365 < 0.0f);
  if (_366) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_138, _139, _140), 1.f);
    _348 = video.r;
    _356 = video.g;
    _364 = video.b;
  }
  float _372 = cb0_space5_008x * _348;
  float _373 = cb0_space5_008y * _356;
  float _374 = cb0_space5_008z * _364;
  float _375 = cb0_space5_008w * _34;
  float _376 = _372 * cb0_space5_008w;
  float _377 = _373 * cb0_space5_008w;
  float _378 = _374 * cb0_space5_008w;
  SV_Target.x = _376;
  SV_Target.y = _377;
  SV_Target.z = _378;
  SV_Target.w = _375;
  return SV_Target;
}
