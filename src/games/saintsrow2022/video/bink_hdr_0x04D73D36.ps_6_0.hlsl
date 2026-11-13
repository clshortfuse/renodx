#include "../tonemap/tonemap.hlsli"

// rl_default_primitive_bink_hdr: HDR10 Bink video (PQ decode -> AP1) tone mapped with the vanilla ACES chain (t40/t13, space15).
// The RenoDX path replaces the sRGB-encoded result after the discard, before the vanilla tint and alpha.

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
  bool _19 = (ATTRIBUTE_REFLECTION_DIST < 0.0f);
  if (_19) discard;
  float _20 = max(ATTRIBUTE_VCOLOR.w, 0.0f);
  float _21 = min(1.0f, _20);
  float4 _26 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _28 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _30 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _32 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _36 = cb3_space9_038x * _28.x;
  float _38 = _36 + cb3_space9_038z;
  float _40 = cb3_space9_038y * _30.x;
  float _42 = _40 + cb3_space9_038w;
  float _43 = _32.x + _26.x;
  float _46 = cb3_space9_037x * _43;
  float _47 = _38 * 0.008609036915004253f;
  float _48 = _38 * 0.5600313544273376f;
  float _49 = _46 + _47;
  float _50 = _46 - _47;
  float _51 = _48 + _46;
  float _52 = _42 * 0.11102962493896484f;
  float _53 = _42 * 0.3206271827220917f;
  float _54 = _49 + _52;
  float _55 = _50 - _52;
  float _56 = _51 - _53;
  float _57 = max(_54, 0.0f);
  float _58 = max(_55, 0.0f);
  float _59 = max(_56, 0.0f);
  float _60 = log2(_57);
  float _61 = log2(_58);
  float _62 = log2(_59);
  float _63 = _60 * 0.012683313339948654f;
  float _64 = _61 * 0.012683313339948654f;
  float _65 = _62 * 0.012683313339948654f;
  float _66 = exp2(_63);
  float _67 = exp2(_64);
  float _68 = exp2(_65);
  float _69 = _66 + -0.8359375f;
  float _70 = _67 + -0.8359375f;
  float _71 = _68 + -0.8359375f;
  float _72 = max(0.0f, _69);
  float _73 = max(0.0f, _70);
  float _74 = max(0.0f, _71);
  float _75 = _66 * 18.6875f;
  float _76 = _67 * 18.6875f;
  float _77 = _68 * 18.6875f;
  float _78 = 18.8515625f - _75;
  float _79 = 18.8515625f - _76;
  float _80 = 18.8515625f - _77;
  float _81 = _72 / _78;
  float _82 = _73 / _79;
  float _83 = _74 / _80;
  float _84 = abs(_81);
  float _85 = abs(_82);
  float _86 = abs(_83);
  float _87 = log2(_84);
  float _88 = log2(_85);
  float _89 = log2(_86);
  float _90 = _87 * 6.277394771575928f;
  float _91 = _88 * 6.277394771575928f;
  float _92 = _89 * 6.277394771575928f;
  float _93 = exp2(_90);
  float _94 = exp2(_91);
  float _95 = exp2(_92);
  float _96 = _93 * 3.4366066455841064f;
  float _97 = _93 * 0.791329562664032f;
  float _98 = _94 * 2.5064520835876465f;
  float _99 = _94 * 1.9836004972457886f;
  float _100 = _94 * 0.09891371428966522f;
  float _101 = _96 - _98;
  float _102 = _99 - _97;
  float _103 = _93 * -0.02594989910721779f;
  float _104 = _103 - _100;
  float _105 = _95 * 0.06984542310237885f;
  float _106 = _95 * 0.192270889878273f;
  float _107 = _95 * 1.124863624572754f;
  float _108 = _101 + _105;
  float _109 = _102 - _106;
  float _110 = _104 + _107;
  float _112 = cb3_space9_037y * 368.6400146484375f;
  float _113 = _112 * _108;
  float _114 = _112 * _109;
  float _115 = _112 * _110;
  float _116 = max(_113, 9.999999747378752e-05f);
  float _117 = max(_114, 9.999999747378752e-05f);
  float _118 = max(_115, 9.999999747378752e-05f);
  float _122 = log2(_116);
  float _123 = log2(_117);
  float _124 = log2(_118);
  float _125 = _122 + 9.720000267028809f;
  float _126 = _123 + 9.720000267028809f;
  float _127 = _124 + 9.720000267028809f;
  float _128 = _125 * 0.03030303120613098f;
  float _129 = _126 * 0.03030303120613098f;
  float _130 = _127 * 0.03030303120613098f;
  float _131 = _128 + 0.23496760427951813f;
  float _132 = _129 + 0.23496760427951813f;
  float _133 = _130 + 0.23496760427951813f;
  uint3 _134;
  t40_space15.GetDimensions(_134.x, _134.y, _134.z);
  uint2 _138;
  t13_space15.GetDimensions(_138.x, _138.y);
  uint _140 = _134.x + -1u;
  uint _141 = _134.y + -1u;
  uint _142 = _134.z + -1u;
  float _143 = float((uint)_140);
  float _144 = float((uint)_141);
  float _145 = float((uint)_142);
  float _146 = float((uint)_134.x);
  float _147 = float((uint)_134.y);
  float _148 = float((uint)_134.z);
  float _149 = _143 / _146;
  float _150 = _144 / _147;
  float _151 = _145 / _148;
  float _152 = 0.5f / _146;
  float _153 = 0.5f / _147;
  float _154 = 0.5f / _148;
  float _155 = _149 * _131;
  float _156 = _150 * _132;
  float _157 = _151 * _133;
  float _158 = _152 + _155;
  float _159 = _153 + _156;
  float _160 = _154 + _157;
  float4 _161 = t40_space15.SampleLevel(s2_space1, float3(_158, _159, _160), 0.0f);
  float _164 = exp2(_122);
  float _165 = exp2(_123);
  float _166 = exp2(_124);
  float _167 = _164 * 0.6954522132873535f;
  float _168 = mad(0.14067870378494263f, _165, _167);
  float _169 = mad(0.16386906802654266f, _166, _168);
  float _170 = _164 * 0.044794563204050064f;
  float _171 = mad(0.8596711158752441f, _165, _170);
  float _172 = mad(0.0955343171954155f, _166, _171);
  float _173 = _164 * -0.005525882821530104f;
  float _174 = mad(0.004025210160762072f, _165, _173);
  float _175 = mad(1.0015007257461548f, _166, _174);
  float _176 = _161.x + 1.0f;
  float _177 = _169 * _176;
  float _178 = _172 * _176;
  float _179 = _175 * _176;
  float _180 = _177 + _161.y;
  float _181 = max(_180, 0.0f);
  float _182 = max(_178, 0.0f);
  float _183 = max(_179, 0.0f);
  float _184 = min(_181, 65536.0f);
  float _185 = min(_182, 65536.0f);
  float _186 = min(_183, 65536.0f);
  float _187 = _184 * 1.4514392614364624f;
  float _188 = mad(-0.2365107536315918f, _185, _187);
  float _189 = mad(-0.21492856740951538f, _186, _188);
  float _190 = _184 * -0.07655377686023712f;
  float _191 = mad(1.17622971534729f, _185, _190);
  float _192 = mad(-0.09967592358589172f, _186, _191);
  float _193 = _184 * 0.008316148072481155f;
  float _194 = mad(-0.006032449658960104f, _185, _193);
  float _195 = mad(0.9977163076400757f, _186, _194);
  float _196 = max(_189, 0.0f);
  float _197 = max(_192, 0.0f);
  float _198 = max(_195, 0.0f);
  float _199 = min(_196, 65504.0f);
  float _200 = min(_197, 65504.0f);
  float _201 = min(_198, 65504.0f);
  float _202 = _199 * 0.970889151096344f;
  float _203 = mad(0.026963284239172935f, _200, _202);
  float _204 = mad(0.0021475818939507008f, _201, _203);
  float _205 = _199 * 0.010889154858887196f;
  float _206 = mad(0.9869632720947266f, _200, _205);
  float _207 = mad(0.0021475818939507008f, _201, _206);
  float _208 = mad(0.026963284239172935f, _200, _205);
  float _209 = mad(0.9621475338935852f, _201, _208);
  float _210 = log2(_204);
  float _211 = log2(_207);
  float _212 = log2(_209);
  float _213 = _210 + 17.47393035888672f;
  float _214 = _211 + 17.47393035888672f;
  float _215 = _212 + 17.47393035888672f;
  float _216 = _213 * 0.03030303120613098f;
  float _217 = _214 * 0.03030303120613098f;
  float _218 = _215 * 0.03030303120613098f;
  uint _219 = _138.x + -1u;
  float _220 = float((uint)_219);
  float _221 = float((uint)_138.x);
  float _222 = _220 / _221;
  float _223 = 0.5f / _221;
  float _224 = _216 * _222;
  float _225 = _217 * _222;
  float _226 = _218 * _222;
  float _227 = _224 + _223;
  float _228 = _225 + _223;
  float _229 = _226 + _223;
  float4 _230 = t13_space15.SampleLevel(s2_space1, float2(_227, 0.5f), 0.0f);
  float4 _232 = t13_space15.SampleLevel(s2_space1, float2(_228, 0.5f), 0.0f);
  float4 _234 = t13_space15.SampleLevel(s2_space1, float2(_229, 0.5f), 0.0f);
  float _236 = _230.x * 3.321928024291992f;
  float _237 = _232.x * 3.321928024291992f;
  float _238 = _234.x * 3.321928024291992f;
  float _239 = exp2(_236);
  float _240 = exp2(_237);
  float _241 = exp2(_238);
  float _242 = _239 / cb3_space9_036w;
  float _243 = _240 / cb3_space9_036w;
  float _244 = _241 / cb3_space9_036w;
  bool _245 = (cb3_space9_036y < 500.0f);
  float _283;
  float _284;
  float _285;
  float _335;
  float _343;
  float _351;
  if (_245) {
    float _247 = _242 * 0.6624541878700256f;
    float _248 = mad(0.13400420546531677f, _243, _247);
    float _249 = mad(0.15618768334388733f, _244, _248);
    float _250 = _242 * 0.2722287178039551f;
    float _251 = mad(0.6740817427635193f, _243, _250);
    float _252 = mad(0.053689517080783844f, _244, _251);
    float _253 = _242 * -0.005574649665504694f;
    float _254 = mad(0.00406073359772563f, _243, _253);
    float _255 = mad(1.0103391408920288f, _244, _254);
    float _256 = _252 + _249;
    float _257 = _256 + _255;
    bool _258 = (_257 == 0.0f);
    float _259 = select(_258, 1.000000013351432e-10f, _257);
    float _260 = _249 / _259;
    float _261 = _252 / _259;
    float _262 = max(_252, 0.0f);
    float _263 = log2(_262);
    float _264 = _263 * 0.9811000227928162f;
    float _265 = exp2(_264);
    float _266 = _265 * _260;
    float _267 = max(_261, 1.000000013351432e-10f);
    float _268 = _266 / _267;
    float _269 = 1.0f - _260;
    float _270 = _269 - _261;
    float _271 = _265 * _270;
    float _272 = _271 / _267;
    float _273 = _268 * 1.6410233974456787f;
    float _274 = mad(-0.32480329275131226f, _265, _273);
    float _275 = mad(-0.23642469942569733f, _272, _274);
    float _276 = _268 * -0.663662850856781f;
    float _277 = mad(1.6153316497802734f, _265, _276);
    float _278 = mad(0.016756348311901093f, _272, _277);
    float _279 = _268 * 0.011721894145011902f;
    float _280 = mad(-0.008284442126750946f, _265, _279);
    float _281 = mad(0.9883948564529419f, _272, _280);
    _283 = _275;
    _284 = _278;
    _285 = _281;
  } else {
    _283 = _242;
    _284 = _243;
    _285 = _244;
  }
  float _286 = _283 * 1.6047539710998535f;
  float _287 = mad(-0.5310794711112976f, _284, _286);
  float _288 = mad(-0.07367203384637833f, _285, _287);
  float _289 = _283 * -0.10208318382501602f;
  float _290 = mad(1.108132243156433f, _284, _289);
  float _291 = mad(-0.006051875650882721f, _285, _290);
  float _292 = _283 * -0.0032670421060174704f;
  float _293 = mad(-0.07275524735450745f, _284, _292);
  float _294 = mad(1.0760219097137451f, _285, _293);
  float _295 = max(_288, 0.0f);
  float _296 = max(_291, 0.0f);
  float _297 = max(_294, 0.0f);
  float _298 = _295 * ATTRIBUTE_VCOLOR.x;
  float _299 = _296 * ATTRIBUTE_VCOLOR.y;
  float _300 = _297 * ATTRIBUTE_VCOLOR.z;
  float _301 = abs(_298);
  float _302 = abs(_299);
  float _303 = abs(_300);
  float _304 = log2(_301);
  float _305 = log2(_302);
  float _306 = log2(_303);
  float _307 = _304 * 0.4166666567325592f;
  float _308 = _305 * 0.4166666567325592f;
  float _309 = _306 * 0.4166666567325592f;
  float _310 = exp2(_307);
  float _311 = exp2(_308);
  float _312 = exp2(_309);
  bool _313 = isfinite(_310);
  bool _314 = isfinite(_311);
  bool _315 = isfinite(_312);
  float _316 = _310 * 1.0549999475479126f;
  float _317 = _311 * 1.0549999475479126f;
  float _318 = _312 * 1.0549999475479126f;
  float _319 = _316 + -0.054999999701976776f;
  float _320 = select(_313, _319, 0.9999999403953552f);
  float _321 = _317 + -0.054999999701976776f;
  float _322 = select(_314, _321, 0.9999999403953552f);
  float _323 = _318 + -0.054999999701976776f;
  float _324 = select(_315, _323, 0.9999999403953552f);
  float _325 = _299 * 12.920000076293945f;
  float _326 = _300 * 12.920000076293945f;
  bool _327 = (_298 > 0.0031308000907301903f);
  if (!_327) {
    float _329 = _298 * 12.920000076293945f;
    bool _330 = (_298 < 0.0031308000907301903f);
    if (!_330) {
      bool _332 = (_298 == 0.0031308000907301903f);
      if (_332) {
        _335 = _320;
      } else {
        _335 = 0.0f;
      }
    } else {
      _335 = _329;
    }
  } else {
    _335 = _320;
  }
  bool _336 = (_299 > 0.0031308000907301903f);
  if (!_336) {
    bool _338 = (_299 < 0.0031308000907301903f);
    if (!_338) {
      bool _340 = (_299 == 0.0031308000907301903f);
      if (_340) {
        _343 = _322;
      } else {
        _343 = 0.0f;
      }
    } else {
      _343 = _325;
    }
  } else {
    _343 = _322;
  }
  bool _344 = (_300 > 0.0031308000907301903f);
  if (!_344) {
    bool _346 = (_300 < 0.0031308000907301903f);
    if (!_346) {
      bool _348 = (_300 == 0.0031308000907301903f);
      if (_348) {
        _351 = _324;
      } else {
        _351 = 0.0f;
      }
    } else {
      _351 = _326;
    }
  } else {
    _351 = _324;
  }
  float _352 = _21 - cb1_space9_034x;
  bool _353 = (_352 < 0.0f);
  if (_353) discard;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_125, _126, _127), 1.f);
    _335 = video.r;
    _343 = video.g;
    _351 = video.b;
  }
  float _359 = cb0_space5_008x * _335;
  float _360 = cb0_space5_008y * _343;
  float _361 = cb0_space5_008z * _351;
  float _362 = cb0_space5_008w * _21;
  float _363 = _359 * cb0_space5_008w;
  float _364 = _360 * cb0_space5_008w;
  float _365 = _361 * cb0_space5_008w;
  SV_Target.x = _363;
  SV_Target.y = _364;
  SV_Target.z = _365;
  SV_Target.w = _362;
  return SV_Target;
}
