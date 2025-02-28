Texture2D<float4> SrcTexture : register(t0);

Texture2D<float4> OCIO_lut1d_0 : register(t1);

Texture3D<float4> OCIO_lut3d_1 : register(t2);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
  float HDRMapping_000z : packoffset(c000.z);
  float HDRMapping_000w : packoffset(c000.w);
  uint HDRMapping_007x : packoffset(c007.x);
};

SamplerState PointBorder : register(s2, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = SrcTexture.SampleLevel(PointBorder, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _19 = (HDRMapping_000x) * 0.009999999776482582f;
  float _20 = _19 * (_13.x);
  float _21 = _19 * (_13.y);
  float _22 = _19 * (_13.z);
  float _23 = _20 * 0.6954519748687744f;
  float _24 = mad(_21, 0.1406790018081665f, _23);
  float _25 = mad(_22, 0.1638689935207367f, _24);
  float _26 = _20 * 0.04479460045695305f;
  float _27 = mad(_21, 0.8596709966659546f, _26);
  float _28 = mad(_22, 0.0955343022942543f, _27);
  float _29 = _20 * -0.00552588002756238f;
  float _30 = mad(_21, 0.004025210160762072f, _29);
  float _31 = mad(_22, 1.0015000104904175f, _30);
  float _32 = abs(_25);
  bool _33 = (_32 > 6.103515625e-05f);
  float _45;
  float _74;
  float _101;
  float _273;
  float _274;
  float _275;
  float _276;
  float _277;
  float _355;
  float _356;
  float _357;
  if (_33) {
    float _35 = min(_32, 65504.0f);
    float _36 = log2(_35);
    float _37 = floor(_36);
    float _38 = exp2(_37);
    float _39 = _35 - _38;
    float _40 = _39 / _38;
    float _41 = dot(float3(_37, _40, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _45 = _41;
  } else {
    float _43 = _32 * 16777216.0f;
    _45 = _43;
  }
  bool _46 = (_25 > 0.0f);
  float _47 = (_46 ? 0.0f : 32768.0f);
  float _48 = _45 + _47;
  float _49 = _48 * 0.00024420025874860585f;
  float _50 = floor(_49);
  float _51 = _50 * 4095.0f;
  float _52 = _48 + 0.5f;
  float _53 = _52 - _51;
  float _54 = _53 * 0.000244140625f;
  float _55 = _50 + 0.5f;
  float _56 = _55 * 0.05882352963089943f;
  float4 _59 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_54, _56), 0.0f);
  float _61 = abs(_28);
  bool _62 = (_61 > 6.103515625e-05f);
  if (_62) {
    float _64 = min(_61, 65504.0f);
    float _65 = log2(_64);
    float _66 = floor(_65);
    float _67 = exp2(_66);
    float _68 = _64 - _67;
    float _69 = _68 / _67;
    float _70 = dot(float3(_66, _69, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _74 = _70;
  } else {
    float _72 = _61 * 16777216.0f;
    _74 = _72;
  }
  bool _75 = (_28 > 0.0f);
  float _76 = (_75 ? 0.0f : 32768.0f);
  float _77 = _74 + _76;
  float _78 = _77 * 0.00024420025874860585f;
  float _79 = floor(_78);
  float _80 = _79 * 4095.0f;
  float _81 = _77 + 0.5f;
  float _82 = _81 - _80;
  float _83 = _82 * 0.000244140625f;
  float _84 = _79 + 0.5f;
  float _85 = _84 * 0.05882352963089943f;
  float4 _86 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_83, _85), 0.0f);
  float _88 = abs(_31);
  bool _89 = (_88 > 6.103515625e-05f);
  if (_89) {
    float _91 = min(_88, 65504.0f);
    float _92 = log2(_91);
    float _93 = floor(_92);
    float _94 = exp2(_93);
    float _95 = _91 - _94;
    float _96 = _95 / _94;
    float _97 = dot(float3(_93, _96, 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
    _101 = _97;
  } else {
    float _99 = _88 * 16777216.0f;
    _101 = _99;
  }
  bool _102 = (_31 > 0.0f);
  float _103 = (_102 ? 0.0f : 32768.0f);
  float _104 = _101 + _103;
  float _105 = _104 * 0.00024420025874860585f;
  float _106 = floor(_105);
  float _107 = _106 * 4095.0f;
  float _108 = _104 + 0.5f;
  float _109 = _108 - _107;
  float _110 = _109 * 0.000244140625f;
  float _111 = _106 + 0.5f;
  float _112 = _111 * 0.05882352963089943f;
  float4 _113 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2(_110, _112), 0.0f);
  float _115 = (_59.x) * 64.0f;
  float _116 = (_86.x) * 64.0f;
  float _117 = (_113.x) * 64.0f;
  float _118 = floor(_115);
  float _119 = floor(_116);
  float _120 = floor(_117);
  float _121 = _115 - _118;
  float _122 = _116 - _119;
  float _123 = _117 - _120;
  float _124 = _120 + 0.5f;
  float _125 = _119 + 0.5f;
  float _126 = _118 + 0.5f;
  float _127 = _124 * 0.015384615398943424f;
  float _128 = _125 * 0.015384615398943424f;
  float _129 = _126 * 0.015384615398943424f;
  float4 _132 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _128, _129), 0.0f);
  float _136 = _127 + 0.015384615398943424f;
  float _137 = _128 + 0.015384615398943424f;
  float _138 = _129 + 0.015384615398943424f;
  float4 _139 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _137, _138), 0.0f);
  bool _143 = !(_121 >= _122);
  if (!_143) {
    bool _145 = !(_122 >= _123);
    if (!_145) {
      float4 _147 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _128, _138), 0.0f);
      float4 _151 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _138), 0.0f);
      float _155 = _121 - _122;
      float _156 = _122 - _123;
      float _157 = (_147.x) * _155;
      float _158 = (_147.y) * _155;
      float _159 = (_147.z) * _155;
      float _160 = (_151.x) * _156;
      float _161 = (_151.y) * _156;
      float _162 = (_151.z) * _156;
      float _163 = _160 + _157;
      float _164 = _161 + _158;
      float _165 = _162 + _159;
      _273 = _163;
      _274 = _164;
      _275 = _165;
      _276 = _121;
      _277 = _123;
    } else {
      bool _167 = !(_121 >= _123);
      if (!_167) {
        float4 _169 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _128, _138), 0.0f);
        float4 _173 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _138), 0.0f);
        float _177 = _121 - _123;
        float _178 = _123 - _122;
        float _179 = (_169.x) * _177;
        float _180 = (_169.y) * _177;
        float _181 = (_169.z) * _177;
        float _182 = (_173.x) * _178;
        float _183 = (_173.y) * _178;
        float _184 = (_173.z) * _178;
        float _185 = _182 + _179;
        float _186 = _183 + _180;
        float _187 = _184 + _181;
        _273 = _185;
        _274 = _186;
        _275 = _187;
        _276 = _121;
        _277 = _122;
      } else {
        float4 _189 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _129), 0.0f);
        float4 _193 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _138), 0.0f);
        float _197 = _123 - _121;
        float _198 = _121 - _122;
        float _199 = (_189.x) * _197;
        float _200 = (_189.y) * _197;
        float _201 = (_189.z) * _197;
        float _202 = (_193.x) * _198;
        float _203 = (_193.y) * _198;
        float _204 = (_193.z) * _198;
        float _205 = _202 + _199;
        float _206 = _203 + _200;
        float _207 = _204 + _201;
        _273 = _205;
        _274 = _206;
        _275 = _207;
        _276 = _123;
        _277 = _122;
      }
    }
  } else {
    bool _209 = !(_122 <= _123);
    if (!_209) {
      float4 _211 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _128, _129), 0.0f);
      float4 _215 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _137, _129), 0.0f);
      float _219 = _123 - _122;
      float _220 = _122 - _121;
      float _221 = (_211.x) * _219;
      float _222 = (_211.y) * _219;
      float _223 = (_211.z) * _219;
      float _224 = (_215.x) * _220;
      float _225 = (_215.y) * _220;
      float _226 = (_215.z) * _220;
      float _227 = _224 + _221;
      float _228 = _225 + _222;
      float _229 = _226 + _223;
      _273 = _227;
      _274 = _228;
      _275 = _229;
      _276 = _123;
      _277 = _121;
    } else {
      bool _231 = !(_121 >= _123);
      if (!_231) {
        float4 _233 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _129), 0.0f);
        float4 _237 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _138), 0.0f);
        float _241 = _122 - _121;
        float _242 = _121 - _123;
        float _243 = (_233.x) * _241;
        float _244 = (_233.y) * _241;
        float _245 = (_233.z) * _241;
        float _246 = (_237.x) * _242;
        float _247 = (_237.y) * _242;
        float _248 = (_237.z) * _242;
        float _249 = _246 + _243;
        float _250 = _247 + _244;
        float _251 = _248 + _245;
        _273 = _249;
        _274 = _250;
        _275 = _251;
        _276 = _122;
        _277 = _123;
      } else {
        float4 _253 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_127, _137, _129), 0.0f);
        float4 _257 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_136, _137, _129), 0.0f);
        float _261 = _122 - _123;
        float _262 = _123 - _121;
        float _263 = (_253.x) * _261;
        float _264 = (_253.y) * _261;
        float _265 = (_253.z) * _261;
        float _266 = (_257.x) * _262;
        float _267 = (_257.y) * _262;
        float _268 = (_257.z) * _262;
        float _269 = _266 + _263;
        float _270 = _267 + _264;
        float _271 = _268 + _265;
        _273 = _269;
        _274 = _270;
        _275 = _271;
        _276 = _122;
        _277 = _121;
      }
    }
  }
  float _278 = 1.0f - _276;
  float _279 = _278 * (_132.x);
  float _280 = _278 * (_132.y);
  float _281 = _278 * (_132.z);
  float _282 = _279 + _273;
  float _283 = _280 + _274;
  float _284 = _281 + _275;
  float _285 = _277 * (_139.x);
  float _286 = _277 * (_139.y);
  float _287 = _277 * (_139.z);
  float _288 = _282 + _285;
  float _289 = _283 + _286;
  float _290 = _284 + _287;
  int _293 = ((uint)(HDRMapping_007x)) & 2;
  bool _294 = (_293 == 0);
  _355 = _288;
  _356 = _289;
  _357 = _290;
  if (!_294) {
    float _297 = (HDRMapping_000z) * 9.999999747378752e-05f;
    float _298 = saturate(_297);
    float _299 = log2(_298);
    float _300 = _299 * 0.1593017578125f;
    float _301 = exp2(_300);
    float _302 = _301 * 18.8515625f;
    float _303 = _302 + 0.8359375f;
    float _304 = _301 * 18.6875f;
    float _305 = _304 + 1.0f;
    float _306 = _303 / _305;
    float _307 = log2(_306);
    float _308 = _307 * 78.84375f;
    float _309 = exp2(_308);
    float _310 = saturate(_309);
    float _312 = (HDRMapping_000w) * 9.999999747378752e-05f;
    float _313 = saturate(_312);
    float _314 = log2(_313);
    float _315 = _314 * 0.1593017578125f;
    float _316 = exp2(_315);
    float _317 = _316 * 18.8515625f;
    float _318 = _317 + 0.8359375f;
    float _319 = _316 * 18.6875f;
    float _320 = _319 + 1.0f;
    float _321 = _318 / _320;
    float _322 = log2(_321);
    float _323 = _322 * 78.84375f;
    float _324 = exp2(_323);
    float _325 = saturate(_324);
    float _326 = _310 - _325;
    float _327 = _288 / _310;
    float _328 = _289 / _310;
    float _329 = _290 / _310;
    float _330 = saturate(_327);
    float _331 = saturate(_328);
    float _332 = saturate(_329);
    float _333 = _330 * _310;
    float _334 = _331 * _310;
    float _335 = _332 * _310;
    float _336 = _330 + _330;
    float _337 = 2.0f - _336;
    float _338 = _337 * _326;
    float _339 = _338 + _333;
    float _340 = _339 * _330;
    float _341 = _331 + _331;
    float _342 = 2.0f - _341;
    float _343 = _342 * _326;
    float _344 = _343 + _334;
    float _345 = _344 * _331;
    float _346 = _332 + _332;
    float _347 = 2.0f - _346;
    float _348 = _347 * _326;
    float _349 = _348 + _335;
    float _350 = _349 * _332;
    float _351 = min(_340, _288);
    float _352 = min(_345, _289);
    float _353 = min(_350, _290);
    _355 = _351;
    _356 = _352;
    _357 = _353;
  }
  SV_Target.x = _355;
  SV_Target.y = _356;
  SV_Target.z = _357;
  SV_Target.w = 1.0f;
  return SV_Target;
}
