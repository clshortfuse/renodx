Texture2D<float4> OCIO_lut1d_0 : register(t0);

Texture3D<float4> OCIO_lut3d_1 : register(t1);

RWTexture3D<float4> OutLUT : register(u0);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_007x : packoffset(c007.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

[numthreads(8, 8, 8)]
void main(uint3 SV_DispatchThreadID: SV_DispatchThreadID) {
  float _11 = float((uint)(SV_DispatchThreadID.x));
  float _12 = float((uint)(SV_DispatchThreadID.y));
  float _13 = float((uint)(SV_DispatchThreadID.z));
  float _14 = _11 * 0.01587301678955555f;
  float _15 = _12 * 0.01587301678955555f;
  float _16 = _13 * 0.01587301678955555f;
  bool _17 = !(_14 <= -0.3013699948787689f);
  float _30;
  float _44;
  float _58;
  float _81;
  float _110;
  float _137;
  float _309;
  float _310;
  float _311;
  float _312;
  float _313;
  float _392;
  float _393;
  float _394;
  if (!_17) {
    float _19 = _11 * 0.2780952751636505f;
    float _20 = _19 + -8.720000267028809f;
    float _21 = exp2(_20);
    float _22 = _21 + -3.0517578125e-05f;
    _30 = _22;
  } else {
    bool _24 = (_14 < 1.468000054359436f);
    _30 = 65504.0f;
    if (_24) {
      float _26 = _11 * 0.2780952751636505f;
      float _27 = _26 + -9.720000267028809f;
      float _28 = exp2(_27);
      _30 = _28;
    }
  }
  bool _31 = !(_15 <= -0.3013699948787689f);
  if (!_31) {
    float _33 = _12 * 0.2780952751636505f;
    float _34 = _33 + -8.720000267028809f;
    float _35 = exp2(_34);
    float _36 = _35 + -3.0517578125e-05f;
    _44 = _36;
  } else {
    bool _38 = (_15 < 1.468000054359436f);
    _44 = 65504.0f;
    if (_38) {
      float _40 = _12 * 0.2780952751636505f;
      float _41 = _40 + -9.720000267028809f;
      float _42 = exp2(_41);
      _44 = _42;
    }
  }
  bool _45 = !(_16 <= -0.3013699948787689f);
  if (!_45) {
    float _47 = _13 * 0.2780952751636505f;
    float _48 = _47 + -8.720000267028809f;
    float _49 = exp2(_48);
    float _50 = _49 + -3.0517578125e-05f;
    _58 = _50;
  } else {
    bool _52 = (_16 < 1.468000054359436f);
    _58 = 65504.0f;
    if (_52) {
      float _54 = _13 * 0.2780952751636505f;
      float _55 = _54 + -9.720000267028809f;
      float _56 = exp2(_55);
      _58 = _56;
    }
  }
  float _59 = _30 * 0.6954519748687744f;
  float _60 = mad(_44, 0.1406790018081665f, _59);
  float _61 = mad(_58, 0.1638689935207367f, _60);
  float _62 = _30 * 0.04479460045695305f;
  float _63 = mad(_44, 0.8596709966659546f, _62);
  float _64 = mad(_58, 0.0955343022942543f, _63);
  float _65 = _30 * -0.00552588002756238f;
  float _66 = mad(_44, 0.004025210160762072f, _65);
  float _67 = mad(_58, 1.0015000104904175f, _66);
  float _68 = abs(_61);
  bool _69 = (_68 > 6.103515625e-05f);
  if (_69) {
    float _71 = min(_68, 65504.0f);
    float _72 = log2(_71);
    float _73 = floor(_72);
    float _74 = exp2(_73);
    float _75 = _71 - _74;
    float _76 = _75 / _74;
    float _77 = dot(float3(_73, _76, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _81 = _77;
  } else {
    float _79 = _68 * 16777216.0f;
    _81 = _79;
  }
  bool _82 = (_61 > 0.0f);
  float _83 = (_82 ? 0.0f : 32768.0f);
  float _84 = _81 + _83;
  float _85 = _84 * 0.00024420025874860585f;
  float _86 = floor(_85);
  float _87 = _86 * 4095.0f;
  float _88 = _84 + 0.5f;
  float _89 = _88 - _87;
  float _90 = _89 * 0.000244140625f;
  float _91 = _86 + 0.5f;
  float _92 = _91 * 0.05882352963089943f;
  float4 _95 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_90, _92), 0.0f);
  float _97 = abs(_64);
  bool _98 = (_97 > 6.103515625e-05f);
  if (_98) {
    float _100 = min(_97, 65504.0f);
    float _101 = log2(_100);
    float _102 = floor(_101);
    float _103 = exp2(_102);
    float _104 = _100 - _103;
    float _105 = _104 / _103;
    float _106 = dot(float3(_102, _105, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _110 = _106;
  } else {
    float _108 = _97 * 16777216.0f;
    _110 = _108;
  }
  bool _111 = (_64 > 0.0f);
  float _112 = (_111 ? 0.0f : 32768.0f);
  float _113 = _110 + _112;
  float _114 = _113 * 0.00024420025874860585f;
  float _115 = floor(_114);
  float _116 = _115 * 4095.0f;
  float _117 = _113 + 0.5f;
  float _118 = _117 - _116;
  float _119 = _118 * 0.000244140625f;
  float _120 = _115 + 0.5f;
  float _121 = _120 * 0.05882352963089943f;
  float4 _122 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_119, _121), 0.0f);
  float _124 = abs(_67);
  bool _125 = (_124 > 6.103515625e-05f);
  if (_125) {
    float _127 = min(_124, 65504.0f);
    float _128 = log2(_127);
    float _129 = floor(_128);
    float _130 = exp2(_129);
    float _131 = _127 - _130;
    float _132 = _131 / _130;
    float _133 = dot(float3(_129, _132, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _137 = _133;
  } else {
    float _135 = _124 * 16777216.0f;
    _137 = _135;
  }
  bool _138 = (_67 > 0.0f);
  float _139 = (_138 ? 0.0f : 32768.0f);
  float _140 = _137 + _139;
  float _141 = _140 * 0.00024420025874860585f;
  float _142 = floor(_141);
  float _143 = _142 * 4095.0f;
  float _144 = _140 + 0.5f;
  float _145 = _144 - _143;
  float _146 = _145 * 0.000244140625f;
  float _147 = _142 + 0.5f;
  float _148 = _147 * 0.05882352963089943f;
  float4 _149 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_146, _148), 0.0f);
  float _151 = (_95.x) * 64.0f;
  float _152 = (_122.x) * 64.0f;
  float _153 = (_149.x) * 64.0f;
  float _154 = floor(_151);
  float _155 = floor(_152);
  float _156 = floor(_153);
  float _157 = _151 - _154;
  float _158 = _152 - _155;
  float _159 = _153 - _156;
  float _160 = _156 + 0.5f;
  float _161 = _155 + 0.5f;
  float _162 = _154 + 0.5f;
  float _163 = _160 * 0.015384615398943424f;
  float _164 = _161 * 0.015384615398943424f;
  float _165 = _162 * 0.015384615398943424f;
  float4 _168 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _165), 0.0f);
  float _172 = _163 + 0.015384615398943424f;
  float _173 = _164 + 0.015384615398943424f;
  float _174 = _165 + 0.015384615398943424f;
  float4 _175 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _174), 0.0f);
  bool _179 = !(_157 >= _158);
  if (!_179) {
    bool _181 = !(_158 >= _159);
    if (!_181) {
      float4 _183 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _174), 0.0f);
      float4 _187 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _174), 0.0f);
      float _191 = _157 - _158;
      float _192 = _158 - _159;
      float _193 = (_183.x) * _191;
      float _194 = (_183.y) * _191;
      float _195 = (_183.z) * _191;
      float _196 = (_187.x) * _192;
      float _197 = (_187.y) * _192;
      float _198 = (_187.z) * _192;
      float _199 = _196 + _193;
      float _200 = _197 + _194;
      float _201 = _198 + _195;
      _309 = _199;
      _310 = _200;
      _311 = _201;
      _312 = _157;
      _313 = _159;
    } else {
      bool _203 = !(_157 >= _159);
      if (!_203) {
        float4 _205 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _174), 0.0f);
        float4 _209 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _174), 0.0f);
        float _213 = _157 - _159;
        float _214 = _159 - _158;
        float _215 = (_205.x) * _213;
        float _216 = (_205.y) * _213;
        float _217 = (_205.z) * _213;
        float _218 = (_209.x) * _214;
        float _219 = (_209.y) * _214;
        float _220 = (_209.z) * _214;
        float _221 = _218 + _215;
        float _222 = _219 + _216;
        float _223 = _220 + _217;
        _309 = _221;
        _310 = _222;
        _311 = _223;
        _312 = _157;
        _313 = _158;
      } else {
        float4 _225 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _165), 0.0f);
        float4 _229 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _174), 0.0f);
        float _233 = _159 - _157;
        float _234 = _157 - _158;
        float _235 = (_225.x) * _233;
        float _236 = (_225.y) * _233;
        float _237 = (_225.z) * _233;
        float _238 = (_229.x) * _234;
        float _239 = (_229.y) * _234;
        float _240 = (_229.z) * _234;
        float _241 = _238 + _235;
        float _242 = _239 + _236;
        float _243 = _240 + _237;
        _309 = _241;
        _310 = _242;
        _311 = _243;
        _312 = _159;
        _313 = _158;
      }
    }
  } else {
    bool _245 = !(_158 <= _159);
    if (!_245) {
      float4 _247 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _165), 0.0f);
      float4 _251 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _165), 0.0f);
      float _255 = _159 - _158;
      float _256 = _158 - _157;
      float _257 = (_247.x) * _255;
      float _258 = (_247.y) * _255;
      float _259 = (_247.z) * _255;
      float _260 = (_251.x) * _256;
      float _261 = (_251.y) * _256;
      float _262 = (_251.z) * _256;
      float _263 = _260 + _257;
      float _264 = _261 + _258;
      float _265 = _262 + _259;
      _309 = _263;
      _310 = _264;
      _311 = _265;
      _312 = _159;
      _313 = _157;
    } else {
      bool _267 = !(_157 >= _159);
      if (!_267) {
        float4 _269 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _165), 0.0f);
        float4 _273 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _174), 0.0f);
        float _277 = _158 - _157;
        float _278 = _157 - _159;
        float _279 = (_269.x) * _277;
        float _280 = (_269.y) * _277;
        float _281 = (_269.z) * _277;
        float _282 = (_273.x) * _278;
        float _283 = (_273.y) * _278;
        float _284 = (_273.z) * _278;
        float _285 = _282 + _279;
        float _286 = _283 + _280;
        float _287 = _284 + _281;
        _309 = _285;
        _310 = _286;
        _311 = _287;
        _312 = _158;
        _313 = _159;
      } else {
        float4 _289 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _165), 0.0f);
        float4 _293 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _165), 0.0f);
        float _297 = _158 - _159;
        float _298 = _159 - _157;
        float _299 = (_289.x) * _297;
        float _300 = (_289.y) * _297;
        float _301 = (_289.z) * _297;
        float _302 = (_293.x) * _298;
        float _303 = (_293.y) * _298;
        float _304 = (_293.z) * _298;
        float _305 = _302 + _299;
        float _306 = _303 + _300;
        float _307 = _304 + _301;
        _309 = _305;
        _310 = _306;
        _311 = _307;
        _312 = _158;
        _313 = _157;
      }
    }
  }
  float _314 = 1.0f - _312;
  float _315 = _314 * (_168.x);
  float _316 = _314 * (_168.y);
  float _317 = _314 * (_168.z);
  float _318 = _315 + _309;
  float _319 = _316 + _310;
  float _320 = _317 + _311;
  float _321 = _313 * (_175.x);
  float _322 = _313 * (_175.y);
  float _323 = _313 * (_175.z);
  float _324 = _318 + _321;
  float _325 = _319 + _322;
  float _326 = _320 + _323;
  int _329 = ((uint)(HDRMapping_007x)) & 2;
  bool _330 = (_329 == 0);
  _392 = _324;
  _393 = _325;
  _394 = _326;
  if (!_330) {
    float _334 = (HDRMapping_000z) * 9.999999747378752e-05f;
    float _335 = saturate(_334);
    float _336 = log2(_335);
    float _337 = _336 * 0.1593017578125f;
    float _338 = exp2(_337);
    float _339 = _338 * 18.8515625f;
    float _340 = _339 + 0.8359375f;
    float _341 = _338 * 18.6875f;
    float _342 = _341 + 1.0f;
    float _343 = _340 / _342;
    float _344 = log2(_343);
    float _345 = _344 * 78.84375f;
    float _346 = exp2(_345);
    float _347 = saturate(_346);
    float _349 = (HDRMapping_000w) * 9.999999747378752e-05f;
    float _350 = saturate(_349);
    float _351 = log2(_350);
    float _352 = _351 * 0.1593017578125f;
    float _353 = exp2(_352);
    float _354 = _353 * 18.8515625f;
    float _355 = _354 + 0.8359375f;
    float _356 = _353 * 18.6875f;
    float _357 = _356 + 1.0f;
    float _358 = _355 / _357;
    float _359 = log2(_358);
    float _360 = _359 * 78.84375f;
    float _361 = exp2(_360);
    float _362 = saturate(_361);
    float _363 = _347 - _362;
    float _364 = _324 / _347;
    float _365 = _325 / _347;
    float _366 = _326 / _347;
    float _367 = saturate(_364);
    float _368 = saturate(_365);
    float _369 = saturate(_366);
    float _370 = _367 * _347;
    float _371 = _368 * _347;
    float _372 = _369 * _347;
    float _373 = _367 + _367;
    float _374 = 2.0f - _373;
    float _375 = _374 * _363;
    float _376 = _375 + _370;
    float _377 = _376 * _367;
    float _378 = _368 + _368;
    float _379 = 2.0f - _378;
    float _380 = _379 * _363;
    float _381 = _380 + _371;
    float _382 = _381 * _368;
    float _383 = _369 + _369;
    float _384 = 2.0f - _383;
    float _385 = _384 * _363;
    float _386 = _385 + _372;
    float _387 = _386 * _369;
    float _388 = min(_377, _324);
    float _389 = min(_382, _325);
    float _390 = min(_387, _326);
    _392 = _388;
    _393 = _389;
    _394 = _390;
  }
  OutLUT[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4(_392, _393, _394, 1.0f);
}
