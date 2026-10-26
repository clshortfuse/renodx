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
  float4 _21 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _23 = _21.x * ATTRIBUTE_VCOLOR.w;
  float _24 = max(_23, 0.0f);
  float _25 = min(1.0f, _24);
  float4 _28 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _30 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _32 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _34 = t4.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _38 = cb3_space9_038x * _30.x;
  float _40 = _38 + cb3_space9_038z;
  float _42 = cb3_space9_038y * _32.x;
  float _44 = _42 + cb3_space9_038w;
  float _45 = _34.x + _28.x;
  float _48 = cb3_space9_037x * _45;
  float _49 = _40 * 0.008609036915004253f;
  float _50 = _40 * 0.5600313544273376f;
  float _51 = _48 + _49;
  float _52 = _48 - _49;
  float _53 = _50 + _48;
  float _54 = _44 * 0.11102962493896484f;
  float _55 = _44 * 0.3206271827220917f;
  float _56 = _51 + _54;
  float _57 = _52 - _54;
  float _58 = _53 - _55;
  float _59 = max(_56, 0.0f);
  float _60 = max(_57, 0.0f);
  float _61 = max(_58, 0.0f);
  float _62 = log2(_59);
  float _63 = log2(_60);
  float _64 = log2(_61);
  float _65 = _62 * 0.012683313339948654f;
  float _66 = _63 * 0.012683313339948654f;
  float _67 = _64 * 0.012683313339948654f;
  float _68 = exp2(_65);
  float _69 = exp2(_66);
  float _70 = exp2(_67);
  float _71 = _68 + -0.8359375f;
  float _72 = _69 + -0.8359375f;
  float _73 = _70 + -0.8359375f;
  float _74 = max(0.0f, _71);
  float _75 = max(0.0f, _72);
  float _76 = max(0.0f, _73);
  float _77 = _68 * 18.6875f;
  float _78 = _69 * 18.6875f;
  float _79 = _70 * 18.6875f;
  float _80 = 18.8515625f - _77;
  float _81 = 18.8515625f - _78;
  float _82 = 18.8515625f - _79;
  float _83 = _74 / _80;
  float _84 = _75 / _81;
  float _85 = _76 / _82;
  float _86 = abs(_83);
  float _87 = abs(_84);
  float _88 = abs(_85);
  float _89 = log2(_86);
  float _90 = log2(_87);
  float _91 = log2(_88);
  float _92 = _89 * 6.277394771575928f;
  float _93 = _90 * 6.277394771575928f;
  float _94 = _91 * 6.277394771575928f;
  float _95 = exp2(_92);
  float _96 = exp2(_93);
  float _97 = exp2(_94);
  float _98 = _95 * 3.4366066455841064f;
  float _99 = _95 * 0.791329562664032f;
  float _100 = _96 * 2.5064520835876465f;
  float _101 = _96 * 1.9836004972457886f;
  float _102 = _96 * 0.09891371428966522f;
  float _103 = _98 - _100;
  float _104 = _101 - _99;
  float _105 = _95 * -0.02594989910721779f;
  float _106 = _105 - _102;
  float _107 = _97 * 0.06984542310237885f;
  float _108 = _97 * 0.192270889878273f;
  float _109 = _97 * 1.124863624572754f;
  float _110 = _103 + _107;
  float _111 = _104 - _108;
  float _112 = _106 + _109;
  float _114 = cb3_space9_037y * 368.6400146484375f;
  float _115 = _114 * _110;
  float _116 = _114 * _111;
  float _117 = _114 * _112;
  float _118 = max(_115, 9.999999747378752e-05f);
  float _119 = max(_116, 9.999999747378752e-05f);
  float _120 = max(_117, 9.999999747378752e-05f);
  float _124 = log2(_118);
  float _125 = log2(_119);
  float _126 = log2(_120);
  float _127 = _124 + 9.720000267028809f;
  float _128 = _125 + 9.720000267028809f;
  float _129 = _126 + 9.720000267028809f;
  float _130 = _127 * 0.03030303120613098f;
  float _131 = _128 * 0.03030303120613098f;
  float _132 = _129 * 0.03030303120613098f;
  float _133 = _130 + 0.23496760427951813f;
  float _134 = _131 + 0.23496760427951813f;
  float _135 = _132 + 0.23496760427951813f;
  uint3 _136;
  t40_space15.GetDimensions(_136.x, _136.y, _136.z);
  uint2 _140;
  t13_space15.GetDimensions(_140.x, _140.y);
  uint _142 = _136.x + -1u;
  uint _143 = _136.y + -1u;
  uint _144 = _136.z + -1u;
  float _145 = float((uint)_142);
  float _146 = float((uint)_143);
  float _147 = float((uint)_144);
  float _148 = float((uint)_136.x);
  float _149 = float((uint)_136.y);
  float _150 = float((uint)_136.z);
  float _151 = _145 / _148;
  float _152 = _146 / _149;
  float _153 = _147 / _150;
  float _154 = 0.5f / _148;
  float _155 = 0.5f / _149;
  float _156 = 0.5f / _150;
  float _157 = _151 * _133;
  float _158 = _152 * _134;
  float _159 = _153 * _135;
  float _160 = _154 + _157;
  float _161 = _155 + _158;
  float _162 = _156 + _159;
  float4 _163 = t40_space15.SampleLevel(s2_space1, float3(_160, _161, _162), 0.0f);
  float _166 = exp2(_124);
  float _167 = exp2(_125);
  float _168 = exp2(_126);
  float _169 = _166 * 0.6954522132873535f;
  float _170 = mad(0.14067870378494263f, _167, _169);
  float _171 = mad(0.16386906802654266f, _168, _170);
  float _172 = _166 * 0.044794563204050064f;
  float _173 = mad(0.8596711158752441f, _167, _172);
  float _174 = mad(0.0955343171954155f, _168, _173);
  float _175 = _166 * -0.005525882821530104f;
  float _176 = mad(0.004025210160762072f, _167, _175);
  float _177 = mad(1.0015007257461548f, _168, _176);
  float _178 = _163.x + 1.0f;
  float _179 = _171 * _178;
  float _180 = _174 * _178;
  float _181 = _177 * _178;
  float _182 = _179 + _163.y;
  float _183 = max(_182, 0.0f);
  float _184 = max(_180, 0.0f);
  float _185 = max(_181, 0.0f);
  float _186 = min(_183, 65536.0f);
  float _187 = min(_184, 65536.0f);
  float _188 = min(_185, 65536.0f);
  float _189 = _186 * 1.4514392614364624f;
  float _190 = mad(-0.2365107536315918f, _187, _189);
  float _191 = mad(-0.21492856740951538f, _188, _190);
  float _192 = _186 * -0.07655377686023712f;
  float _193 = mad(1.17622971534729f, _187, _192);
  float _194 = mad(-0.09967592358589172f, _188, _193);
  float _195 = _186 * 0.008316148072481155f;
  float _196 = mad(-0.006032449658960104f, _187, _195);
  float _197 = mad(0.9977163076400757f, _188, _196);
  float _198 = max(_191, 0.0f);
  float _199 = max(_194, 0.0f);
  float _200 = max(_197, 0.0f);
  float _201 = min(_198, 65504.0f);
  float _202 = min(_199, 65504.0f);
  float _203 = min(_200, 65504.0f);
  float _204 = _201 * 0.970889151096344f;
  float _205 = mad(0.026963284239172935f, _202, _204);
  float _206 = mad(0.0021475818939507008f, _203, _205);
  float _207 = _201 * 0.010889154858887196f;
  float _208 = mad(0.9869632720947266f, _202, _207);
  float _209 = mad(0.0021475818939507008f, _203, _208);
  float _210 = mad(0.026963284239172935f, _202, _207);
  float _211 = mad(0.9621475338935852f, _203, _210);
  float _212 = log2(_206);
  float _213 = log2(_209);
  float _214 = log2(_211);
  float _215 = _212 + 17.47393035888672f;
  float _216 = _213 + 17.47393035888672f;
  float _217 = _214 + 17.47393035888672f;
  float _218 = _215 * 0.03030303120613098f;
  float _219 = _216 * 0.03030303120613098f;
  float _220 = _217 * 0.03030303120613098f;
  uint _221 = _140.x + -1u;
  float _222 = float((uint)_221);
  float _223 = float((uint)_140.x);
  float _224 = _222 / _223;
  float _225 = 0.5f / _223;
  float _226 = _218 * _224;
  float _227 = _219 * _224;
  float _228 = _220 * _224;
  float _229 = _226 + _225;
  float _230 = _227 + _225;
  float _231 = _228 + _225;
  float4 _232 = t13_space15.SampleLevel(s2_space1, float2(_229, 0.5f), 0.0f);
  float4 _234 = t13_space15.SampleLevel(s2_space1, float2(_230, 0.5f), 0.0f);
  float4 _236 = t13_space15.SampleLevel(s2_space1, float2(_231, 0.5f), 0.0f);
  float _238 = _232.x * 3.321928024291992f;
  float _239 = _234.x * 3.321928024291992f;
  float _240 = _236.x * 3.321928024291992f;
  float _241 = exp2(_238);
  float _242 = exp2(_239);
  float _243 = exp2(_240);
  float _244 = _241 / cb3_space9_036w;
  float _245 = _242 / cb3_space9_036w;
  float _246 = _243 / cb3_space9_036w;
  bool _247 = (cb3_space9_036y < 500.0f);
  float _285;
  float _286;
  float _287;
  float _337;
  float _345;
  float _353;
  if (_247) {
    float _249 = _244 * 0.6624541878700256f;
    float _250 = mad(0.13400420546531677f, _245, _249);
    float _251 = mad(0.15618768334388733f, _246, _250);
    float _252 = _244 * 0.2722287178039551f;
    float _253 = mad(0.6740817427635193f, _245, _252);
    float _254 = mad(0.053689517080783844f, _246, _253);
    float _255 = _244 * -0.005574649665504694f;
    float _256 = mad(0.00406073359772563f, _245, _255);
    float _257 = mad(1.0103391408920288f, _246, _256);
    float _258 = _254 + _251;
    float _259 = _258 + _257;
    bool _260 = (_259 == 0.0f);
    float _261 = select(_260, 1.000000013351432e-10f, _259);
    float _262 = _251 / _261;
    float _263 = _254 / _261;
    float _264 = max(_254, 0.0f);
    float _265 = log2(_264);
    float _266 = _265 * 0.9811000227928162f;
    float _267 = exp2(_266);
    float _268 = _267 * _262;
    float _269 = max(_263, 1.000000013351432e-10f);
    float _270 = _268 / _269;
    float _271 = 1.0f - _262;
    float _272 = _271 - _263;
    float _273 = _267 * _272;
    float _274 = _273 / _269;
    float _275 = _270 * 1.6410233974456787f;
    float _276 = mad(-0.32480329275131226f, _267, _275);
    float _277 = mad(-0.23642469942569733f, _274, _276);
    float _278 = _270 * -0.663662850856781f;
    float _279 = mad(1.6153316497802734f, _267, _278);
    float _280 = mad(0.016756348311901093f, _274, _279);
    float _281 = _270 * 0.011721894145011902f;
    float _282 = mad(-0.008284442126750946f, _267, _281);
    float _283 = mad(0.9883948564529419f, _274, _282);
    _285 = _277;
    _286 = _280;
    _287 = _283;
  } else {
    _285 = _244;
    _286 = _245;
    _287 = _246;
  }
  float _288 = _285 * 1.6047539710998535f;
  float _289 = mad(-0.5310794711112976f, _286, _288);
  float _290 = mad(-0.07367203384637833f, _287, _289);
  float _291 = _285 * -0.10208318382501602f;
  float _292 = mad(1.108132243156433f, _286, _291);
  float _293 = mad(-0.006051875650882721f, _287, _292);
  float _294 = _285 * -0.0032670421060174704f;
  float _295 = mad(-0.07275524735450745f, _286, _294);
  float _296 = mad(1.0760219097137451f, _287, _295);
  float _297 = max(_290, 0.0f);
  float _298 = max(_293, 0.0f);
  float _299 = max(_296, 0.0f);
  float _300 = _297 * ATTRIBUTE_VCOLOR.x;
  float _301 = _298 * ATTRIBUTE_VCOLOR.y;
  float _302 = _299 * ATTRIBUTE_VCOLOR.z;
  float _303 = abs(_300);
  float _304 = abs(_301);
  float _305 = abs(_302);
  float _306 = log2(_303);
  float _307 = log2(_304);
  float _308 = log2(_305);
  float _309 = _306 * 0.4166666567325592f;
  float _310 = _307 * 0.4166666567325592f;
  float _311 = _308 * 0.4166666567325592f;
  float _312 = exp2(_309);
  float _313 = exp2(_310);
  float _314 = exp2(_311);
  bool _315 = isfinite(_312);
  bool _316 = isfinite(_313);
  bool _317 = isfinite(_314);
  float _318 = _312 * 1.0549999475479126f;
  float _319 = _313 * 1.0549999475479126f;
  float _320 = _314 * 1.0549999475479126f;
  float _321 = _318 + -0.054999999701976776f;
  float _322 = select(_315, _321, 0.9999999403953552f);
  float _323 = _319 + -0.054999999701976776f;
  float _324 = select(_316, _323, 0.9999999403953552f);
  float _325 = _320 + -0.054999999701976776f;
  float _326 = select(_317, _325, 0.9999999403953552f);
  float _327 = _301 * 12.920000076293945f;
  float _328 = _302 * 12.920000076293945f;
  bool _329 = (_300 > 0.0031308000907301903f);
  if (!_329) {
    float _331 = _300 * 12.920000076293945f;
    bool _332 = (_300 < 0.0031308000907301903f);
    if (!_332) {
      bool _334 = (_300 == 0.0031308000907301903f);
      if (_334) {
        _337 = _322;
      } else {
        _337 = 0.0f;
      }
    } else {
      _337 = _331;
    }
  } else {
    _337 = _322;
  }
  bool _338 = (_301 > 0.0031308000907301903f);
  if (!_338) {
    bool _340 = (_301 < 0.0031308000907301903f);
    if (!_340) {
      bool _342 = (_301 == 0.0031308000907301903f);
      if (_342) {
        _345 = _324;
      } else {
        _345 = 0.0f;
      }
    } else {
      _345 = _327;
    }
  } else {
    _345 = _324;
  }
  bool _346 = (_302 > 0.0031308000907301903f);
  if (!_346) {
    bool _348 = (_302 < 0.0031308000907301903f);
    if (!_348) {
      bool _350 = (_302 == 0.0031308000907301903f);
      if (_350) {
        _353 = _326;
      } else {
        _353 = 0.0f;
      }
    } else {
      _353 = _328;
    }
  } else {
    _353 = _326;
  }
  float _354 = _25 - cb1_space9_034x;
  bool _355 = (_354 < 0.0f);
  if (_355) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_127, _128, _129), 1.f);
    _337 = video.r;
    _345 = video.g;
    _353 = video.b;
  }
  float _361 = cb0_space5_008x * _337;
  float _362 = cb0_space5_008y * _345;
  float _363 = cb0_space5_008z * _353;
  float _364 = cb0_space5_008w * _25;
  float _365 = _361 * cb0_space5_008w;
  float _366 = _362 * cb0_space5_008w;
  float _367 = _363 * cb0_space5_008w;
  SV_Target.x = _365;
  SV_Target.y = _366;
  SV_Target.z = _367;
  SV_Target.w = _364;
  return SV_Target;
}
