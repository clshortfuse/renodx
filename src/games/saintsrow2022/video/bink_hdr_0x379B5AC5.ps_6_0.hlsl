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
    linear float4 ATTRIBUTE_VCOLOR : ATTRIBUTE_VCOLOR,
    float3 ATTRIBUTE_NORMAL : ATTRIBUTE_NORMAL,
    float3 ATTRIBUTE_TANGENT : ATTRIBUTE_TANGENT,
    float3 ATTRIBUTE_BINORMAL : ATTRIBUTE_BINORMAL,
    linear float3 ATTRIBUTE_CAMERA_VECTOR : ATTRIBUTE_CAMERA_VECTOR,
    linear float4 ATTRIBUTE_INSTANCE_PARAMS : ATTRIBUTE_INSTANCE_PARAMS,
    nointerpolation uint SV_IsFrontFace : SV_IsFrontFace) : SV_Target {
  float4 SV_Target;
  float _19 = max(ATTRIBUTE_VCOLOR.w, 0.0f);
  float _20 = min(1.0f, _19);
  float4 _25 = t0.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _27 = t1.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _29 = t2.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float4 _31 = t3.SampleBias(s0_space1, float2(UVS_PACKED_ATTR.x, UVS_PACKED_ATTR.y), cb1_space9_035z, int2(0, 0));
  float _35 = cb3_space9_038x * _27.x;
  float _37 = _35 + cb3_space9_038z;
  float _39 = cb3_space9_038y * _29.x;
  float _41 = _39 + cb3_space9_038w;
  float _42 = _31.x + _25.x;
  float _45 = cb3_space9_037x * _42;
  float _46 = _37 * 0.008609036915004253f;
  float _47 = _37 * 0.5600313544273376f;
  float _48 = _45 + _46;
  float _49 = _45 - _46;
  float _50 = _47 + _45;
  float _51 = _41 * 0.11102962493896484f;
  float _52 = _41 * 0.3206271827220917f;
  float _53 = _48 + _51;
  float _54 = _49 - _51;
  float _55 = _50 - _52;
  float _56 = max(_53, 0.0f);
  float _57 = max(_54, 0.0f);
  float _58 = max(_55, 0.0f);
  float _59 = log2(_56);
  float _60 = log2(_57);
  float _61 = log2(_58);
  float _62 = _59 * 0.012683313339948654f;
  float _63 = _60 * 0.012683313339948654f;
  float _64 = _61 * 0.012683313339948654f;
  float _65 = exp2(_62);
  float _66 = exp2(_63);
  float _67 = exp2(_64);
  float _68 = _65 + -0.8359375f;
  float _69 = _66 + -0.8359375f;
  float _70 = _67 + -0.8359375f;
  float _71 = max(0.0f, _68);
  float _72 = max(0.0f, _69);
  float _73 = max(0.0f, _70);
  float _74 = _65 * 18.6875f;
  float _75 = _66 * 18.6875f;
  float _76 = _67 * 18.6875f;
  float _77 = 18.8515625f - _74;
  float _78 = 18.8515625f - _75;
  float _79 = 18.8515625f - _76;
  float _80 = _71 / _77;
  float _81 = _72 / _78;
  float _82 = _73 / _79;
  float _83 = abs(_80);
  float _84 = abs(_81);
  float _85 = abs(_82);
  float _86 = log2(_83);
  float _87 = log2(_84);
  float _88 = log2(_85);
  float _89 = _86 * 6.277394771575928f;
  float _90 = _87 * 6.277394771575928f;
  float _91 = _88 * 6.277394771575928f;
  float _92 = exp2(_89);
  float _93 = exp2(_90);
  float _94 = exp2(_91);
  float _95 = _92 * 3.4366066455841064f;
  float _96 = _92 * 0.791329562664032f;
  float _97 = _93 * 2.5064520835876465f;
  float _98 = _93 * 1.9836004972457886f;
  float _99 = _93 * 0.09891371428966522f;
  float _100 = _95 - _97;
  float _101 = _98 - _96;
  float _102 = _92 * -0.02594989910721779f;
  float _103 = _102 - _99;
  float _104 = _94 * 0.06984542310237885f;
  float _105 = _94 * 0.192270889878273f;
  float _106 = _94 * 1.124863624572754f;
  float _107 = _100 + _104;
  float _108 = _101 - _105;
  float _109 = _103 + _106;
  float _111 = cb3_space9_037y * 368.6400146484375f;
  float _112 = _111 * _107;
  float _113 = _111 * _108;
  float _114 = _111 * _109;
  float _115 = max(_112, 9.999999747378752e-05f);
  float _116 = max(_113, 9.999999747378752e-05f);
  float _117 = max(_114, 9.999999747378752e-05f);
  float _121 = log2(_115);
  float _122 = log2(_116);
  float _123 = log2(_117);
  float _124 = _121 + 9.720000267028809f;
  float _125 = _122 + 9.720000267028809f;
  float _126 = _123 + 9.720000267028809f;
  float _127 = _124 * 0.03030303120613098f;
  float _128 = _125 * 0.03030303120613098f;
  float _129 = _126 * 0.03030303120613098f;
  float _130 = _127 + 0.23496760427951813f;
  float _131 = _128 + 0.23496760427951813f;
  float _132 = _129 + 0.23496760427951813f;
  uint3 _133;
  t40_space15.GetDimensions(_133.x, _133.y, _133.z);
  uint2 _137;
  t13_space15.GetDimensions(_137.x, _137.y);
  uint _139 = _133.x + -1u;
  uint _140 = _133.y + -1u;
  uint _141 = _133.z + -1u;
  float _142 = float((uint)_139);
  float _143 = float((uint)_140);
  float _144 = float((uint)_141);
  float _145 = float((uint)_133.x);
  float _146 = float((uint)_133.y);
  float _147 = float((uint)_133.z);
  float _148 = _142 / _145;
  float _149 = _143 / _146;
  float _150 = _144 / _147;
  float _151 = 0.5f / _145;
  float _152 = 0.5f / _146;
  float _153 = 0.5f / _147;
  float _154 = _148 * _130;
  float _155 = _149 * _131;
  float _156 = _150 * _132;
  float _157 = _151 + _154;
  float _158 = _152 + _155;
  float _159 = _153 + _156;
  float4 _160 = t40_space15.SampleLevel(s2_space1, float3(_157, _158, _159), 0.0f);
  float _163 = exp2(_121);
  float _164 = exp2(_122);
  float _165 = exp2(_123);
  float _166 = _163 * 0.6954522132873535f;
  float _167 = mad(0.14067870378494263f, _164, _166);
  float _168 = mad(0.16386906802654266f, _165, _167);
  float _169 = _163 * 0.044794563204050064f;
  float _170 = mad(0.8596711158752441f, _164, _169);
  float _171 = mad(0.0955343171954155f, _165, _170);
  float _172 = _163 * -0.005525882821530104f;
  float _173 = mad(0.004025210160762072f, _164, _172);
  float _174 = mad(1.0015007257461548f, _165, _173);
  float _175 = _160.x + 1.0f;
  float _176 = _168 * _175;
  float _177 = _171 * _175;
  float _178 = _174 * _175;
  float _179 = _176 + _160.y;
  float _180 = max(_179, 0.0f);
  float _181 = max(_177, 0.0f);
  float _182 = max(_178, 0.0f);
  float _183 = min(_180, 65536.0f);
  float _184 = min(_181, 65536.0f);
  float _185 = min(_182, 65536.0f);
  float _186 = _183 * 1.4514392614364624f;
  float _187 = mad(-0.2365107536315918f, _184, _186);
  float _188 = mad(-0.21492856740951538f, _185, _187);
  float _189 = _183 * -0.07655377686023712f;
  float _190 = mad(1.17622971534729f, _184, _189);
  float _191 = mad(-0.09967592358589172f, _185, _190);
  float _192 = _183 * 0.008316148072481155f;
  float _193 = mad(-0.006032449658960104f, _184, _192);
  float _194 = mad(0.9977163076400757f, _185, _193);
  float _195 = max(_188, 0.0f);
  float _196 = max(_191, 0.0f);
  float _197 = max(_194, 0.0f);
  float _198 = min(_195, 65504.0f);
  float _199 = min(_196, 65504.0f);
  float _200 = min(_197, 65504.0f);
  float _201 = _198 * 0.970889151096344f;
  float _202 = mad(0.026963284239172935f, _199, _201);
  float _203 = mad(0.0021475818939507008f, _200, _202);
  float _204 = _198 * 0.010889154858887196f;
  float _205 = mad(0.9869632720947266f, _199, _204);
  float _206 = mad(0.0021475818939507008f, _200, _205);
  float _207 = mad(0.026963284239172935f, _199, _204);
  float _208 = mad(0.9621475338935852f, _200, _207);
  float _209 = log2(_203);
  float _210 = log2(_206);
  float _211 = log2(_208);
  float _212 = _209 + 17.47393035888672f;
  float _213 = _210 + 17.47393035888672f;
  float _214 = _211 + 17.47393035888672f;
  float _215 = _212 * 0.03030303120613098f;
  float _216 = _213 * 0.03030303120613098f;
  float _217 = _214 * 0.03030303120613098f;
  uint _218 = _137.x + -1u;
  float _219 = float((uint)_218);
  float _220 = float((uint)_137.x);
  float _221 = _219 / _220;
  float _222 = 0.5f / _220;
  float _223 = _215 * _221;
  float _224 = _216 * _221;
  float _225 = _217 * _221;
  float _226 = _223 + _222;
  float _227 = _224 + _222;
  float _228 = _225 + _222;
  float4 _229 = t13_space15.SampleLevel(s2_space1, float2(_226, 0.5f), 0.0f);
  float4 _231 = t13_space15.SampleLevel(s2_space1, float2(_227, 0.5f), 0.0f);
  float4 _233 = t13_space15.SampleLevel(s2_space1, float2(_228, 0.5f), 0.0f);
  float _235 = _229.x * 3.321928024291992f;
  float _236 = _231.x * 3.321928024291992f;
  float _237 = _233.x * 3.321928024291992f;
  float _238 = exp2(_235);
  float _239 = exp2(_236);
  float _240 = exp2(_237);
  float _241 = _238 / cb3_space9_036w;
  float _242 = _239 / cb3_space9_036w;
  float _243 = _240 / cb3_space9_036w;
  bool _244 = (cb3_space9_036y < 500.0f);
  float _282;
  float _283;
  float _284;
  float _334;
  float _342;
  float _350;
  if (_244) {
    float _246 = _241 * 0.6624541878700256f;
    float _247 = mad(0.13400420546531677f, _242, _246);
    float _248 = mad(0.15618768334388733f, _243, _247);
    float _249 = _241 * 0.2722287178039551f;
    float _250 = mad(0.6740817427635193f, _242, _249);
    float _251 = mad(0.053689517080783844f, _243, _250);
    float _252 = _241 * -0.005574649665504694f;
    float _253 = mad(0.00406073359772563f, _242, _252);
    float _254 = mad(1.0103391408920288f, _243, _253);
    float _255 = _251 + _248;
    float _256 = _255 + _254;
    bool _257 = (_256 == 0.0f);
    float _258 = select(_257, 1.000000013351432e-10f, _256);
    float _259 = _248 / _258;
    float _260 = _251 / _258;
    float _261 = max(_251, 0.0f);
    float _262 = log2(_261);
    float _263 = _262 * 0.9811000227928162f;
    float _264 = exp2(_263);
    float _265 = _264 * _259;
    float _266 = max(_260, 1.000000013351432e-10f);
    float _267 = _265 / _266;
    float _268 = 1.0f - _259;
    float _269 = _268 - _260;
    float _270 = _264 * _269;
    float _271 = _270 / _266;
    float _272 = _267 * 1.6410233974456787f;
    float _273 = mad(-0.32480329275131226f, _264, _272);
    float _274 = mad(-0.23642469942569733f, _271, _273);
    float _275 = _267 * -0.663662850856781f;
    float _276 = mad(1.6153316497802734f, _264, _275);
    float _277 = mad(0.016756348311901093f, _271, _276);
    float _278 = _267 * 0.011721894145011902f;
    float _279 = mad(-0.008284442126750946f, _264, _278);
    float _280 = mad(0.9883948564529419f, _271, _279);
    _282 = _274;
    _283 = _277;
    _284 = _280;
  } else {
    _282 = _241;
    _283 = _242;
    _284 = _243;
  }
  float _285 = _282 * 1.6047539710998535f;
  float _286 = mad(-0.5310794711112976f, _283, _285);
  float _287 = mad(-0.07367203384637833f, _284, _286);
  float _288 = _282 * -0.10208318382501602f;
  float _289 = mad(1.108132243156433f, _283, _288);
  float _290 = mad(-0.006051875650882721f, _284, _289);
  float _291 = _282 * -0.0032670421060174704f;
  float _292 = mad(-0.07275524735450745f, _283, _291);
  float _293 = mad(1.0760219097137451f, _284, _292);
  float _294 = max(_287, 0.0f);
  float _295 = max(_290, 0.0f);
  float _296 = max(_293, 0.0f);
  float _297 = _294 * ATTRIBUTE_VCOLOR.x;
  float _298 = _295 * ATTRIBUTE_VCOLOR.y;
  float _299 = _296 * ATTRIBUTE_VCOLOR.z;
  float _300 = abs(_297);
  float _301 = abs(_298);
  float _302 = abs(_299);
  float _303 = log2(_300);
  float _304 = log2(_301);
  float _305 = log2(_302);
  float _306 = _303 * 0.4166666567325592f;
  float _307 = _304 * 0.4166666567325592f;
  float _308 = _305 * 0.4166666567325592f;
  float _309 = exp2(_306);
  float _310 = exp2(_307);
  float _311 = exp2(_308);
  bool _312 = isfinite(_309);
  bool _313 = isfinite(_310);
  bool _314 = isfinite(_311);
  float _315 = _309 * 1.0549999475479126f;
  float _316 = _310 * 1.0549999475479126f;
  float _317 = _311 * 1.0549999475479126f;
  float _318 = _315 + -0.054999999701976776f;
  float _319 = select(_312, _318, 0.9999999403953552f);
  float _320 = _316 + -0.054999999701976776f;
  float _321 = select(_313, _320, 0.9999999403953552f);
  float _322 = _317 + -0.054999999701976776f;
  float _323 = select(_314, _322, 0.9999999403953552f);
  float _324 = _298 * 12.920000076293945f;
  float _325 = _299 * 12.920000076293945f;
  bool _326 = (_297 > 0.0031308000907301903f);
  if (!_326) {
    float _328 = _297 * 12.920000076293945f;
    bool _329 = (_297 < 0.0031308000907301903f);
    if (!_329) {
      bool _331 = (_297 == 0.0031308000907301903f);
      if (_331) {
        _334 = _319;
      } else {
        _334 = 0.0f;
      }
    } else {
      _334 = _328;
    }
  } else {
    _334 = _319;
  }
  bool _335 = (_298 > 0.0031308000907301903f);
  if (!_335) {
    bool _337 = (_298 < 0.0031308000907301903f);
    if (!_337) {
      bool _339 = (_298 == 0.0031308000907301903f);
      if (_339) {
        _342 = _321;
      } else {
        _342 = 0.0f;
      }
    } else {
      _342 = _324;
    }
  } else {
    _342 = _321;
  }
  bool _343 = (_299 > 0.0031308000907301903f);
  if (!_343) {
    bool _345 = (_299 < 0.0031308000907301903f);
    if (!_345) {
      bool _347 = (_299 == 0.0031308000907301903f);
      if (_347) {
        _350 = _323;
      } else {
        _350 = 0.0f;
      }
    } else {
      _350 = _325;
    }
  } else {
    _350 = _323;
  }
  float _351 = _20 - cb1_space9_034x;
  bool _352 = (_351 < 0.0f);
  if (_352) discard;
  float _358 = _20 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _359 = _358 * cb0_space5_008w;
  [branch] if (SR_TONE_MAP_ACTIVE) {
    float3 video = ApplySaintsRowScene(float3(_124, _125, _126), 1.f);
    _334 = video.r;
    _342 = video.g;
    _350 = video.b;
  }
  float _360 = _334 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _361 = _360 * cb0_space5_008x;
  float _362 = _361 * cb0_space5_008w;
  float _363 = _342 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _364 = _363 * cb0_space5_008y;
  float _365 = _364 * cb0_space5_008w;
  float _366 = _350 * ATTRIBUTE_INSTANCE_PARAMS.w;
  float _367 = _366 * cb0_space5_008z;
  float _368 = _367 * cb0_space5_008w;
  SV_Target.x = _362;
  SV_Target.y = _365;
  SV_Target.z = _368;
  SV_Target.w = _359;
  return SV_Target;
}
