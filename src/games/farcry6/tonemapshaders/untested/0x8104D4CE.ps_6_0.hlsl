#include "../../common.hlsli"
struct SExposureData {
  float SExposureData_000;
  float SExposureData_004;
  float SExposureData_008;
  float SExposureData_012;
  float SExposureData_016;
  float SExposureData_020;
};

StructuredBuffer<SExposureData> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t6 : register(t6);

Texture2D<float4> t7 : register(t7);

Texture3D<float2> t8 : register(t8);

Texture2D<float4> t9 : register(t9);

cbuffer cb0 : register(b0) {
  float cb0_028x : packoffset(c028.x);
  float cb0_028z : packoffset(c028.z);
};

cbuffer cb1 : register(b1) {
  float cb1_018y : packoffset(c018.y);
  float cb1_018z : packoffset(c018.z);
  uint cb1_018w : packoffset(c018.w);
};

cbuffer cb2 : register(b2) {
  float cb2_000x : packoffset(c000.x);
  float cb2_000y : packoffset(c000.y);
  float cb2_000z : packoffset(c000.z);
  float cb2_003x : packoffset(c003.x);
  float cb2_003y : packoffset(c003.y);
  float cb2_003z : packoffset(c003.z);
  float cb2_003w : packoffset(c003.w);
  float cb2_004x : packoffset(c004.x);
  float cb2_004y : packoffset(c004.y);
  float cb2_004z : packoffset(c004.z);
  float cb2_004w : packoffset(c004.w);
  float cb2_016x : packoffset(c016.x);
  float cb2_016y : packoffset(c016.y);
  float cb2_016z : packoffset(c016.z);
  float cb2_016w : packoffset(c016.w);
  float cb2_017x : packoffset(c017.x);
  float cb2_017y : packoffset(c017.y);
  float cb2_017z : packoffset(c017.z);
  float cb2_017w : packoffset(c017.w);
  float cb2_018x : packoffset(c018.x);
  float cb2_018y : packoffset(c018.y);
  uint cb2_019x : packoffset(c019.x);
  uint cb2_019y : packoffset(c019.y);
  uint cb2_019z : packoffset(c019.z);
  uint cb2_019w : packoffset(c019.w);
  float cb2_020x : packoffset(c020.x);
  float cb2_020y : packoffset(c020.y);
  float cb2_020z : packoffset(c020.z);
  float cb2_020w : packoffset(c020.w);
  float cb2_021x : packoffset(c021.x);
  float cb2_021y : packoffset(c021.y);
  float cb2_021z : packoffset(c021.z);
  float cb2_021w : packoffset(c021.w);
  float cb2_022x : packoffset(c022.x);
  float cb2_023x : packoffset(c023.x);
  float cb2_023y : packoffset(c023.y);
  float cb2_023z : packoffset(c023.z);
  float cb2_023w : packoffset(c023.w);
  float cb2_024x : packoffset(c024.x);
  float cb2_024y : packoffset(c024.y);
  float cb2_024z : packoffset(c024.z);
  float cb2_024w : packoffset(c024.w);
  float cb2_025x : packoffset(c025.x);
  float cb2_025y : packoffset(c025.y);
  float cb2_025z : packoffset(c025.z);
  float cb2_025w : packoffset(c025.w);
  float cb2_026y : packoffset(c026.y);
  float cb2_026z : packoffset(c026.z);
  float cb2_026w : packoffset(c026.w);
  float cb2_027x : packoffset(c027.x);
  float cb2_027y : packoffset(c027.y);
  float cb2_027z : packoffset(c027.z);
  float cb2_027w : packoffset(c027.w);
  uint cb2_028x : packoffset(c028.x);
  uint cb2_069y : packoffset(c069.y);
  uint cb2_069z : packoffset(c069.z);
  uint cb2_070x : packoffset(c070.x);
  uint cb2_070y : packoffset(c070.y);
  uint cb2_070z : packoffset(c070.z);
  uint cb2_070w : packoffset(c070.w);
  uint cb2_071x : packoffset(c071.x);
  uint cb2_071y : packoffset(c071.y);
  uint cb2_071z : packoffset(c071.z);
  uint cb2_071w : packoffset(c071.w);
  uint cb2_072x : packoffset(c072.x);
  uint cb2_072y : packoffset(c072.y);
  uint cb2_072z : packoffset(c072.z);
  uint cb2_072w : packoffset(c072.w);
  uint cb2_073x : packoffset(c073.x);
  uint cb2_073y : packoffset(c073.y);
  uint cb2_073z : packoffset(c073.z);
  uint cb2_073w : packoffset(c073.w);
  uint cb2_074x : packoffset(c074.x);
  uint cb2_074y : packoffset(c074.y);
  uint cb2_074z : packoffset(c074.z);
  uint cb2_074w : packoffset(c074.w);
  uint cb2_075x : packoffset(c075.x);
  uint cb2_075y : packoffset(c075.y);
  uint cb2_075z : packoffset(c075.z);
  uint cb2_075w : packoffset(c075.w);
  uint cb2_076x : packoffset(c076.x);
  uint cb2_076y : packoffset(c076.y);
  uint cb2_076z : packoffset(c076.z);
  uint cb2_076w : packoffset(c076.w);
  uint cb2_077x : packoffset(c077.x);
  uint cb2_077y : packoffset(c077.y);
  uint cb2_077z : packoffset(c077.z);
  uint cb2_077w : packoffset(c077.w);
  uint cb2_078x : packoffset(c078.x);
  uint cb2_078y : packoffset(c078.y);
  uint cb2_078z : packoffset(c078.z);
  uint cb2_078w : packoffset(c078.w);
  uint cb2_079x : packoffset(c079.x);
  uint cb2_079y : packoffset(c079.y);
  uint cb2_079z : packoffset(c079.z);
  uint cb2_094x : packoffset(c094.x);
  uint cb2_094y : packoffset(c094.y);
  uint cb2_094z : packoffset(c094.z);
  uint cb2_094w : packoffset(c094.w);
  uint cb2_095x : packoffset(c095.x);
  float cb2_095y : packoffset(c095.y);
};

SamplerState s0_space2 : register(s0, space2);

SamplerState s2_space2 : register(s2, space2);

SamplerState s4_space2 : register(s4, space2);

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
  linear float2 TEXCOORD0_centroid : TEXCOORD0_centroid,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_IsFrontFace : SV_IsFrontFace
) {
  float4 SV_Target;
  float4 SV_Target_1;
  float _24 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _26 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _30 = max(_26.x, 0.0f);
  float _31 = max(_26.y, 0.0f);
  float _32 = max(_26.z, 0.0f);
  float _33 = min(_30, 65000.0f);
  float _34 = min(_31, 65000.0f);
  float _35 = min(_32, 65000.0f);
  float4 _36 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _41 = max(_36.x, 0.0f);
  float _42 = max(_36.y, 0.0f);
  float _43 = max(_36.z, 0.0f);
  float _44 = max(_36.w, 0.0f);
  float _45 = min(_41, 5000.0f);
  float _46 = min(_42, 5000.0f);
  float _47 = min(_43, 5000.0f);
  float _48 = min(_44, 5000.0f);
  float _51 = _24.x * cb0_028z;
  float _52 = _51 + cb0_028x;
  float _53 = cb2_027w / _52;
  float _54 = 1.0f - _53;
  float _55 = abs(_54);
  float _57 = cb2_027y * _55;
  float _59 = _57 - cb2_027z;
  float _60 = saturate(_59);
  float _61 = max(_60, _48);
  float _62 = saturate(_61);
  float4 _63 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _67 = _45 - _33;
  float _68 = _46 - _34;
  float _69 = _47 - _35;
  float _70 = _62 * _67;
  float _71 = _62 * _68;
  float _72 = _62 * _69;
  float _73 = _70 + _33;
  float _74 = _71 + _34;
  float _75 = _72 + _35;
  float _76 = dot(float3(_73, _74, _75), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _80 = t0[0].SExposureData_020;
  float _82 = t0[0].SExposureData_004;
  float _84 = cb2_018x * 0.5f;
  float _85 = _84 * cb2_018y;
  float _86 = _82.x - _85;
  float _87 = cb2_018y * cb2_018x;
  float _88 = 1.0f / _87;
  float _89 = _86 * _88;
  float _90 = _76 / _80.x;
  float _91 = _90 * 5464.01611328125f;
  float _92 = _91 + 9.99999993922529e-09f;
  float _93 = log2(_92);
  float _94 = _93 - _86;
  float _95 = _94 * _88;
  float _96 = saturate(_95);
  float2 _97 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _96), 0.0f);
  float _100 = max(_97.y, 1.0000000116860974e-07f);
  float _101 = _97.x / _100;
  float _102 = _101 + _89;
  float _103 = _102 / _88;
  float _104 = _103 - _82.x;
  float _105 = -0.0f - _104;
  float _107 = _105 - cb2_027x;
  float _108 = max(0.0f, _107);
  float _111 = cb2_026z * _108;
  float _112 = _104 - cb2_027x;
  float _113 = max(0.0f, _112);
  float _115 = cb2_026w * _113;
  bool _116 = (_104 < 0.0f);
  float _117 = select(_116, _111, _115);
  float _118 = exp2(_117);
  float _119 = _118 * _73;
  float _120 = _118 * _74;
  float _121 = _118 * _75;
  float _126 = cb2_024y * _63.x;
  float _127 = cb2_024z * _63.y;
  float _128 = cb2_024w * _63.z;
  float _129 = _126 + _119;
  float _130 = _127 + _120;
  float _131 = _128 + _121;
  float _136 = _129 * cb2_025x;
  float _137 = _130 * cb2_025y;
  float _138 = _131 * cb2_025z;
  float _139 = dot(float3(_136, _137, _138), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _140 = t0[0].SExposureData_012;
  float _142 = _139 * 5464.01611328125f;
  float _143 = _142 * _140.x;
  float _144 = _143 + 9.99999993922529e-09f;
  float _145 = log2(_144);
  float _146 = _145 + 16.929765701293945f;
  float _147 = _146 * 0.05734497308731079f;
  float _148 = saturate(_147);
  float _149 = _148 * _148;
  float _150 = _148 * 2.0f;
  float _151 = 3.0f - _150;
  float _152 = _149 * _151;
  float _153 = _137 * 0.8450999855995178f;
  float _154 = _138 * 0.14589999616146088f;
  float _155 = _153 + _154;
  float _156 = _155 * 2.4890189170837402f;
  float _157 = _155 * 0.3754962384700775f;
  float _158 = _155 * 2.811495304107666f;
  float _159 = _155 * 5.519708156585693f;
  float _160 = _139 - _156;
  float _161 = _152 * _160;
  float _162 = _161 + _156;
  float _163 = _152 * 0.5f;
  float _164 = _163 + 0.5f;
  float _165 = _164 * _160;
  float _166 = _165 + _156;
  float _167 = _136 - _157;
  float _168 = _137 - _158;
  float _169 = _138 - _159;
  float _170 = _164 * _167;
  float _171 = _164 * _168;
  float _172 = _164 * _169;
  float _173 = _170 + _157;
  float _174 = _171 + _158;
  float _175 = _172 + _159;
  float _176 = 1.0f / _166;
  float _177 = _162 * _176;
  float _178 = _177 * _173;
  float _179 = _177 * _174;
  float _180 = _177 * _175;
  float _184 = cb2_020x * TEXCOORD0_centroid.x;
  float _185 = cb2_020y * TEXCOORD0_centroid.y;
  float _188 = _184 + cb2_020z;
  float _189 = _185 + cb2_020w;
  float _192 = dot(float2(_188, _189), float2(_188, _189));
  float _193 = 1.0f - _192;
  float _194 = saturate(_193);
  float _195 = log2(_194);
  float _196 = _195 * cb2_021w;
  float _197 = exp2(_196);
  float _201 = _178 - cb2_021x;
  float _202 = _179 - cb2_021y;
  float _203 = _180 - cb2_021z;
  float _204 = _201 * _197;
  float _205 = _202 * _197;
  float _206 = _203 * _197;
  float _207 = _204 + cb2_021x;
  float _208 = _205 + cb2_021y;
  float _209 = _206 + cb2_021z;
  float _210 = t0[0].SExposureData_000;
  float _212 = max(_80.x, 0.0010000000474974513f);
  float _213 = 1.0f / _212;
  float _214 = _213 * _210.x;
  bool _217 = ((uint)(cb2_069y) == 0);
  float _223;
  float _224;
  float _225;
  float _279;
  float _280;
  float _281;
  float _327;
  float _328;
  float _329;
  float _374;
  float _375;
  float _376;
  float _377;
  float _426;
  float _427;
  float _428;
  float _429;
  float _454;
  float _455;
  float _456;
  float _606;
  float _643;
  float _644;
  float _645;
  float _674;
  float _675;
  float _676;
  float _757;
  float _758;
  float _759;
  float _765;
  float _766;
  float _767;
  float _781;
  float _782;
  float _783;
  float _808;
  float _820;
  float _848;
  float _860;
  float _872;
  float _873;
  float _874;
  float _901;
  float _902;
  float _903;
  if (!_217) {
    float _219 = _214 * _207;
    float _220 = _214 * _208;
    float _221 = _214 * _209;
    _223 = _219;
    _224 = _220;
    _225 = _221;
  } else {
    _223 = _207;
    _224 = _208;
    _225 = _209;
  }
  float _226 = _223 * 0.6130970120429993f;
  float _227 = mad(0.33952298760414124f, _224, _226);
  float _228 = mad(0.04737899824976921f, _225, _227);
  float _229 = _223 * 0.07019399851560593f;
  float _230 = mad(0.9163540005683899f, _224, _229);
  float _231 = mad(0.013451999984681606f, _225, _230);
  float _232 = _223 * 0.02061600051820278f;
  float _233 = mad(0.10956999659538269f, _224, _232);
  float _234 = mad(0.8698149919509888f, _225, _233);
  float _235 = log2(_228);
  float _236 = log2(_231);
  float _237 = log2(_234);
  float _238 = _235 * 0.04211956635117531f;
  float _239 = _236 * 0.04211956635117531f;
  float _240 = _237 * 0.04211956635117531f;
  float _241 = _238 + 0.6252607107162476f;
  float _242 = _239 + 0.6252607107162476f;
  float _243 = _240 + 0.6252607107162476f;
  float4 _244 = t6.SampleLevel(s2_space2, float3(_241, _242, _243), 0.0f);
  bool _250 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_250 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _254 = cb2_017x * _244.x;
    float _255 = cb2_017x * _244.y;
    float _256 = cb2_017x * _244.z;
    float _258 = _254 + cb2_017y;
    float _259 = _255 + cb2_017y;
    float _260 = _256 + cb2_017y;
    float _261 = exp2(_258);
    float _262 = exp2(_259);
    float _263 = exp2(_260);
    float _264 = _261 + 1.0f;
    float _265 = _262 + 1.0f;
    float _266 = _263 + 1.0f;
    float _267 = 1.0f / _264;
    float _268 = 1.0f / _265;
    float _269 = 1.0f / _266;
    float _271 = cb2_017z * _267;
    float _272 = cb2_017z * _268;
    float _273 = cb2_017z * _269;
    float _275 = _271 + cb2_017w;
    float _276 = _272 + cb2_017w;
    float _277 = _273 + cb2_017w;
    _279 = _275;
    _280 = _276;
    _281 = _277;
  } else {
    _279 = _244.x;
    _280 = _244.y;
    _281 = _244.z;
  }
  float _282 = _279 * 23.0f;
  float _283 = _282 + -14.473931312561035f;
  float _284 = exp2(_283);
  float _285 = _280 * 23.0f;
  float _286 = _285 + -14.473931312561035f;
  float _287 = exp2(_286);
  float _288 = _281 * 23.0f;
  float _289 = _288 + -14.473931312561035f;
  float _290 = exp2(_289);
  float _295 = cb2_004x * TEXCOORD0_centroid.x;
  float _296 = cb2_004y * TEXCOORD0_centroid.y;
  float _299 = _295 + cb2_004z;
  float _300 = _296 + cb2_004w;
  float4 _306 = t7.Sample(s2_space2, float2(_299, _300));
  float _311 = _306.x * cb2_003x;
  float _312 = _306.y * cb2_003y;
  float _313 = _306.z * cb2_003z;
  float _314 = _306.w * cb2_003w;
  float _317 = _314 + cb2_026y;
  float _318 = saturate(_317);
  bool _321 = ((uint)(cb2_069y) == 0);
  if (!_321) {
    float _323 = _311 * _214;
    float _324 = _312 * _214;
    float _325 = _313 * _214;
    _327 = _323;
    _328 = _324;
    _329 = _325;
  } else {
    _327 = _311;
    _328 = _312;
    _329 = _313;
  }
  bool _332 = ((uint)(cb2_028x) == 2);
  bool _333 = ((uint)(cb2_028x) == 3);
  int _334 = (uint)(cb2_028x) & -2;
  bool _335 = (_334 == 2);
  bool _336 = ((uint)(cb2_028x) == 6);
  bool _337 = _335 || _336;
  if (_337) {
    float _339 = _327 * _318;
    float _340 = _328 * _318;
    float _341 = _329 * _318;
    float _342 = _318 * _318;
    _374 = _339;
    _375 = _340;
    _376 = _341;
    _377 = _342;
  } else {
    bool _344 = ((uint)(cb2_028x) == 4);
    if (_344) {
      float _346 = _327 + -1.0f;
      float _347 = _328 + -1.0f;
      float _348 = _329 + -1.0f;
      float _349 = _318 + -1.0f;
      float _350 = _346 * _318;
      float _351 = _347 * _318;
      float _352 = _348 * _318;
      float _353 = _349 * _318;
      float _354 = _350 + 1.0f;
      float _355 = _351 + 1.0f;
      float _356 = _352 + 1.0f;
      float _357 = _353 + 1.0f;
      _374 = _354;
      _375 = _355;
      _376 = _356;
      _377 = _357;
    } else {
      bool _359 = ((uint)(cb2_028x) == 5);
      if (_359) {
        float _361 = _327 + -0.5f;
        float _362 = _328 + -0.5f;
        float _363 = _329 + -0.5f;
        float _364 = _318 + -0.5f;
        float _365 = _361 * _318;
        float _366 = _362 * _318;
        float _367 = _363 * _318;
        float _368 = _364 * _318;
        float _369 = _365 + 0.5f;
        float _370 = _366 + 0.5f;
        float _371 = _367 + 0.5f;
        float _372 = _368 + 0.5f;
        _374 = _369;
        _375 = _370;
        _376 = _371;
        _377 = _372;
      } else {
        _374 = _327;
        _375 = _328;
        _376 = _329;
        _377 = _318;
      }
    }
  }
  if (_332) {
    float _379 = _374 + _284;
    float _380 = _375 + _287;
    float _381 = _376 + _290;
    _426 = _379;
    _427 = _380;
    _428 = _381;
    _429 = cb2_025w;
  } else {
    if (_333) {
      float _384 = 1.0f - _374;
      float _385 = 1.0f - _375;
      float _386 = 1.0f - _376;
      float _387 = _384 * _284;
      float _388 = _385 * _287;
      float _389 = _386 * _290;
      float _390 = _387 + _374;
      float _391 = _388 + _375;
      float _392 = _389 + _376;
      _426 = _390;
      _427 = _391;
      _428 = _392;
      _429 = cb2_025w;
    } else {
      bool _394 = ((uint)(cb2_028x) == 4);
      if (_394) {
        float _396 = _374 * _284;
        float _397 = _375 * _287;
        float _398 = _376 * _290;
        _426 = _396;
        _427 = _397;
        _428 = _398;
        _429 = cb2_025w;
      } else {
        bool _400 = ((uint)(cb2_028x) == 5);
        if (_400) {
          float _402 = _284 * 2.0f;
          float _403 = _402 * _374;
          float _404 = _287 * 2.0f;
          float _405 = _404 * _375;
          float _406 = _290 * 2.0f;
          float _407 = _406 * _376;
          _426 = _403;
          _427 = _405;
          _428 = _407;
          _429 = cb2_025w;
        } else {
          if (_336) {
            float _410 = _284 - _374;
            float _411 = _287 - _375;
            float _412 = _290 - _376;
            _426 = _410;
            _427 = _411;
            _428 = _412;
            _429 = cb2_025w;
          } else {
            float _414 = _374 - _284;
            float _415 = _375 - _287;
            float _416 = _376 - _290;
            float _417 = _377 * _414;
            float _418 = _377 * _415;
            float _419 = _377 * _416;
            float _420 = _417 + _284;
            float _421 = _418 + _287;
            float _422 = _419 + _290;
            float _423 = 1.0f - _377;
            float _424 = _423 * cb2_025w;
            _426 = _420;
            _427 = _421;
            _428 = _422;
            _429 = _424;
          }
        }
      }
    }
  }
  float _435 = cb2_016x - _426;
  float _436 = cb2_016y - _427;
  float _437 = cb2_016z - _428;
  float _438 = _435 * cb2_016w;
  float _439 = _436 * cb2_016w;
  float _440 = _437 * cb2_016w;
  float _441 = _438 + _426;
  float _442 = _439 + _427;
  float _443 = _440 + _428;
  bool _446 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_446 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _450 = cb2_024x * _441;
    float _451 = cb2_024x * _442;
    float _452 = cb2_024x * _443;
    _454 = _450;
    _455 = _451;
    _456 = _452;
  } else {
    _454 = _441;
    _455 = _442;
    _456 = _443;
  }
  float _459 = _454 * 0.9708889722824097f;
  float _460 = mad(0.026962999254465103f, _455, _459);
  float _461 = mad(0.002148000057786703f, _456, _460);
  float _462 = _454 * 0.01088900025933981f;
  float _463 = mad(0.9869629740715027f, _455, _462);
  float _464 = mad(0.002148000057786703f, _456, _463);
  float _465 = mad(0.026962999254465103f, _455, _462);
  float _466 = mad(0.9621480107307434f, _456, _465);
  float _467 = max(_461, 0.0f);
  float _468 = max(_464, 0.0f);
  float _469 = max(_466, 0.0f);
  float _470 = min(_467, cb2_095y);
  float _471 = min(_468, cb2_095y);
  float _472 = min(_469, cb2_095y);
  bool _475 = ((uint)(cb2_095x) == 0);
  bool _478 = ((uint)(cb2_094w) == 0);
  bool _480 = ((uint)(cb2_094z) == 0);
  bool _482 = ((uint)(cb2_094y) != 0);
  bool _484 = ((uint)(cb2_094x) == 0);
  bool _486 = ((uint)(cb2_069z) != 0);
  float _533 = asfloat((uint)(cb2_075y));
  float _534 = asfloat((uint)(cb2_075z));
  float _535 = asfloat((uint)(cb2_075w));
  float _536 = asfloat((uint)(cb2_074z));
  float _537 = asfloat((uint)(cb2_074w));
  float _538 = asfloat((uint)(cb2_075x));
  float _539 = asfloat((uint)(cb2_073w));
  float _540 = asfloat((uint)(cb2_074x));
  float _541 = asfloat((uint)(cb2_074y));
  float _542 = asfloat((uint)(cb2_077x));
  float _543 = asfloat((uint)(cb2_077y));
  float _544 = asfloat((uint)(cb2_079x));
  float _545 = asfloat((uint)(cb2_079y));
  float _546 = asfloat((uint)(cb2_079z));
  float _547 = asfloat((uint)(cb2_078y));
  float _548 = asfloat((uint)(cb2_078z));
  float _549 = asfloat((uint)(cb2_078w));
  float _550 = asfloat((uint)(cb2_077z));
  float _551 = asfloat((uint)(cb2_077w));
  float _552 = asfloat((uint)(cb2_078x));
  float _553 = asfloat((uint)(cb2_072y));
  float _554 = asfloat((uint)(cb2_072z));
  float _555 = asfloat((uint)(cb2_072w));
  float _556 = asfloat((uint)(cb2_071x));
  float _557 = asfloat((uint)(cb2_071y));
  float _558 = asfloat((uint)(cb2_076x));
  float _559 = asfloat((uint)(cb2_070w));
  float _560 = asfloat((uint)(cb2_070x));
  float _561 = asfloat((uint)(cb2_070y));
  float _562 = asfloat((uint)(cb2_070z));
  float _563 = asfloat((uint)(cb2_073x));
  float _564 = asfloat((uint)(cb2_073y));
  float _565 = asfloat((uint)(cb2_073z));
  float _566 = asfloat((uint)(cb2_071z));
  float _567 = asfloat((uint)(cb2_071w));
  float _568 = asfloat((uint)(cb2_072x));
  float _569 = max(_471, _472);
  float _570 = max(_470, _569);
  float _571 = 1.0f / _570;
  float _572 = _571 * _470;
  float _573 = _571 * _471;
  float _574 = _571 * _472;
  float _575 = abs(_572);
  float _576 = log2(_575);
  float _577 = _576 * _560;
  float _578 = exp2(_577);
  float _579 = abs(_573);
  float _580 = log2(_579);
  float _581 = _580 * _561;
  float _582 = exp2(_581);
  float _583 = abs(_574);
  float _584 = log2(_583);
  float _585 = _584 * _562;
  float _586 = exp2(_585);
  if (_482) {
    float _589 = asfloat((uint)(cb2_076w));
    float _591 = asfloat((uint)(cb2_076z));
    float _593 = asfloat((uint)(cb2_076y));
    float _594 = _591 * _471;
    float _595 = _593 * _470;
    float _596 = _589 * _472;
    float _597 = _595 + _596;
    float _598 = _597 + _594;
    _606 = _598;
  } else {
    float _600 = _567 * _471;
    float _601 = _566 * _470;
    float _602 = _568 * _472;
    float _603 = _600 + _601;
    float _604 = _603 + _602;
    _606 = _604;
  }
  float _607 = abs(_606);
  float _608 = log2(_607);
  float _609 = _608 * _559;
  float _610 = exp2(_609);
  float _611 = log2(_610);
  float _612 = _611 * _558;
  float _613 = exp2(_612);
  float _614 = select(_486, _613, _610);
  float _615 = _614 * _556;
  float _616 = _615 + _557;
  float _617 = 1.0f / _616;
  float _618 = _617 * _610;
  if (_482) {
    if (!_484) {
      float _621 = _578 * _550;
      float _622 = _582 * _551;
      float _623 = _586 * _552;
      float _624 = _622 + _621;
      float _625 = _624 + _623;
      float _626 = _582 * _548;
      float _627 = _578 * _547;
      float _628 = _586 * _549;
      float _629 = _626 + _627;
      float _630 = _629 + _628;
      float _631 = _586 * _546;
      float _632 = _582 * _545;
      float _633 = _578 * _544;
      float _634 = _632 + _633;
      float _635 = _634 + _631;
      float _636 = max(_630, _635);
      float _637 = max(_625, _636);
      float _638 = 1.0f / _637;
      float _639 = _638 * _625;
      float _640 = _638 * _630;
      float _641 = _638 * _635;
      _643 = _639;
      _644 = _640;
      _645 = _641;
    } else {
      _643 = _578;
      _644 = _582;
      _645 = _586;
    }
    float _646 = _643 * _543;
    float _647 = exp2(_646);
    float _648 = _647 * _542;
    float _649 = saturate(_648);
    float _650 = _643 * _542;
    float _651 = _643 - _650;
    float _652 = saturate(_651);
    float _653 = max(_542, _652);
    float _654 = min(_653, _649);
    float _655 = _644 * _543;
    float _656 = exp2(_655);
    float _657 = _656 * _542;
    float _658 = saturate(_657);
    float _659 = _644 * _542;
    float _660 = _644 - _659;
    float _661 = saturate(_660);
    float _662 = max(_542, _661);
    float _663 = min(_662, _658);
    float _664 = _645 * _543;
    float _665 = exp2(_664);
    float _666 = _665 * _542;
    float _667 = saturate(_666);
    float _668 = _645 * _542;
    float _669 = _645 - _668;
    float _670 = saturate(_669);
    float _671 = max(_542, _670);
    float _672 = min(_671, _667);
    _674 = _654;
    _675 = _663;
    _676 = _672;
  } else {
    _674 = _578;
    _675 = _582;
    _676 = _586;
  }
  float _677 = _674 * _566;
  float _678 = _675 * _567;
  float _679 = _678 + _677;
  float _680 = _676 * _568;
  float _681 = _679 + _680;
  float _682 = 1.0f / _681;
  float _683 = _682 * _618;
  float _684 = saturate(_683);
  float _685 = _684 * _674;
  float _686 = saturate(_685);
  float _687 = _684 * _675;
  float _688 = saturate(_687);
  float _689 = _684 * _676;
  float _690 = saturate(_689);
  float _691 = _686 * _553;
  float _692 = _553 - _691;
  float _693 = _688 * _554;
  float _694 = _554 - _693;
  float _695 = _690 * _555;
  float _696 = _555 - _695;
  float _697 = _690 * _568;
  float _698 = _686 * _566;
  float _699 = _688 * _567;
  float _700 = _618 - _698;
  float _701 = _700 - _699;
  float _702 = _701 - _697;
  float _703 = saturate(_702);
  float _704 = _694 * _567;
  float _705 = _692 * _566;
  float _706 = _696 * _568;
  float _707 = _704 + _705;
  float _708 = _707 + _706;
  float _709 = 1.0f / _708;
  float _710 = _709 * _703;
  float _711 = _710 * _692;
  float _712 = _711 + _686;
  float _713 = saturate(_712);
  float _714 = _710 * _694;
  float _715 = _714 + _688;
  float _716 = saturate(_715);
  float _717 = _710 * _696;
  float _718 = _717 + _690;
  float _719 = saturate(_718);
  float _720 = _719 * _568;
  float _721 = _713 * _566;
  float _722 = _716 * _567;
  float _723 = _618 - _721;
  float _724 = _723 - _722;
  float _725 = _724 - _720;
  float _726 = saturate(_725);
  float _727 = _726 * _563;
  float _728 = _727 + _713;
  float _729 = saturate(_728);
  float _730 = _726 * _564;
  float _731 = _730 + _716;
  float _732 = saturate(_731);
  float _733 = _726 * _565;
  float _734 = _733 + _719;
  float _735 = saturate(_734);
  if (!_480) {
    float _737 = _729 * _539;
    float _738 = _732 * _540;
    float _739 = _735 * _541;
    float _740 = _738 + _737;
    float _741 = _740 + _739;
    float _742 = _732 * _537;
    float _743 = _729 * _536;
    float _744 = _735 * _538;
    float _745 = _742 + _743;
    float _746 = _745 + _744;
    float _747 = _735 * _535;
    float _748 = _732 * _534;
    float _749 = _729 * _533;
    float _750 = _748 + _749;
    float _751 = _750 + _747;
    if (!_478) {
      float _753 = saturate(_741);
      float _754 = saturate(_746);
      float _755 = saturate(_751);
      _757 = _755;
      _758 = _754;
      _759 = _753;
    } else {
      _757 = _751;
      _758 = _746;
      _759 = _741;
    }
  } else {
    _757 = _735;
    _758 = _732;
    _759 = _729;
  }
  if (!_475) {
    float _761 = _759 * _539;
    float _762 = _758 * _539;
    float _763 = _757 * _539;
    _765 = _763;
    _766 = _762;
    _767 = _761;
  } else {
    _765 = _757;
    _766 = _758;
    _767 = _759;
  }
  if (_446) {
    float _771 = cb1_018z * 9.999999747378752e-05f;
    float _772 = _771 * _767;
    float _773 = _771 * _766;
    float _774 = _771 * _765;
    float _776 = 5000.0f / cb1_018y;
    float _777 = _772 * _776;
    float _778 = _773 * _776;
    float _779 = _774 * _776;
    _781 = _777;
    _782 = _778;
    _783 = _779;
  } else {
    _781 = _767;
    _782 = _766;
    _783 = _765;
  }
  float _784 = _781 * 1.6047500371932983f;
  float _785 = mad(-0.5310800075531006f, _782, _784);
  float _786 = mad(-0.07366999983787537f, _783, _785);
  float _787 = _781 * -0.10208000242710114f;
  float _788 = mad(1.1081299781799316f, _782, _787);
  float _789 = mad(-0.006049999967217445f, _783, _788);
  float _790 = _781 * -0.0032599999103695154f;
  float _791 = mad(-0.07275000214576721f, _782, _790);
  float _792 = mad(1.0760200023651123f, _783, _791);
  if (_446) {
    // float _794 = max(_786, 0.0f);
    // float _795 = max(_789, 0.0f);
    // float _796 = max(_792, 0.0f);
    // bool _797 = !(_794 >= 0.0030399328097701073f);
    // if (!_797) {
    //   float _799 = abs(_794);
    //   float _800 = log2(_799);
    //   float _801 = _800 * 0.4166666567325592f;
    //   float _802 = exp2(_801);
    //   float _803 = _802 * 1.0549999475479126f;
    //   float _804 = _803 + -0.054999999701976776f;
    //   _808 = _804;
    // } else {
    //   float _806 = _794 * 12.923210144042969f;
    //   _808 = _806;
    // }
    // bool _809 = !(_795 >= 0.0030399328097701073f);
    // if (!_809) {
    //   float _811 = abs(_795);
    //   float _812 = log2(_811);
    //   float _813 = _812 * 0.4166666567325592f;
    //   float _814 = exp2(_813);
    //   float _815 = _814 * 1.0549999475479126f;
    //   float _816 = _815 + -0.054999999701976776f;
    //   _820 = _816;
    // } else {
    //   float _818 = _795 * 12.923210144042969f;
    //   _820 = _818;
    // }
    // bool _821 = !(_796 >= 0.0030399328097701073f);
    // if (!_821) {
    //   float _823 = abs(_796);
    //   float _824 = log2(_823);
    //   float _825 = _824 * 0.4166666567325592f;
    //   float _826 = exp2(_825);
    //   float _827 = _826 * 1.0549999475479126f;
    //   float _828 = _827 + -0.054999999701976776f;
    //   _901 = _808;
    //   _902 = _820;
    //   _903 = _828;
    // } else {
    //   float _830 = _796 * 12.923210144042969f;
    //   _901 = _808;
    //   _902 = _820;
    //   _903 = _830;
    // }
    _901 = renodx::color::srgb::EncodeSafe(_786);
    _902 = renodx::color::srgb::EncodeSafe(_789);
    _903 = renodx::color::srgb::EncodeSafe(_792);

  } else {
    float _832 = saturate(_786);
    float _833 = saturate(_789);
    float _834 = saturate(_792);
    bool _835 = ((uint)(cb1_018w) == -2);
    if (!_835) {
      bool _837 = !(_832 >= 0.0030399328097701073f);
      if (!_837) {
        float _839 = abs(_832);
        float _840 = log2(_839);
        float _841 = _840 * 0.4166666567325592f;
        float _842 = exp2(_841);
        float _843 = _842 * 1.0549999475479126f;
        float _844 = _843 + -0.054999999701976776f;
        _848 = _844;
      } else {
        float _846 = _832 * 12.923210144042969f;
        _848 = _846;
      }
      bool _849 = !(_833 >= 0.0030399328097701073f);
      if (!_849) {
        float _851 = abs(_833);
        float _852 = log2(_851);
        float _853 = _852 * 0.4166666567325592f;
        float _854 = exp2(_853);
        float _855 = _854 * 1.0549999475479126f;
        float _856 = _855 + -0.054999999701976776f;
        _860 = _856;
      } else {
        float _858 = _833 * 12.923210144042969f;
        _860 = _858;
      }
      bool _861 = !(_834 >= 0.0030399328097701073f);
      if (!_861) {
        float _863 = abs(_834);
        float _864 = log2(_863);
        float _865 = _864 * 0.4166666567325592f;
        float _866 = exp2(_865);
        float _867 = _866 * 1.0549999475479126f;
        float _868 = _867 + -0.054999999701976776f;
        _872 = _848;
        _873 = _860;
        _874 = _868;
      } else {
        float _870 = _834 * 12.923210144042969f;
        _872 = _848;
        _873 = _860;
        _874 = _870;
      }
    } else {
      _872 = _832;
      _873 = _833;
      _874 = _834;
    }
    float _879 = abs(_872);
    float _880 = abs(_873);
    float _881 = abs(_874);
    float _882 = log2(_879);
    float _883 = log2(_880);
    float _884 = log2(_881);
    float _885 = _882 * cb2_000z;
    float _886 = _883 * cb2_000z;
    float _887 = _884 * cb2_000z;
    float _888 = exp2(_885);
    float _889 = exp2(_886);
    float _890 = exp2(_887);
    float _891 = _888 * cb2_000y;
    float _892 = _889 * cb2_000y;
    float _893 = _890 * cb2_000y;
    float _894 = _891 + cb2_000x;
    float _895 = _892 + cb2_000x;
    float _896 = _893 + cb2_000x;
    float _897 = saturate(_894);
    float _898 = saturate(_895);
    float _899 = saturate(_896);
    _901 = _897;
    _902 = _898;
    _903 = _899;
  }
  float _907 = cb2_023x * TEXCOORD0_centroid.x;
  float _908 = cb2_023y * TEXCOORD0_centroid.y;
  float _911 = _907 + cb2_023z;
  float _912 = _908 + cb2_023w;
  float4 _915 = t9.SampleLevel(s0_space2, float2(_911, _912), 0.0f);
  float _917 = _915.x + -0.5f;
  float _918 = _917 * cb2_022x;
  float _919 = _918 + 0.5f;
  float _920 = _919 * 2.0f;
  float _921 = _920 * _901;
  float _922 = _920 * _902;
  float _923 = _920 * _903;
  float _927 = float((uint)(cb2_019z));
  float _928 = float((uint)(cb2_019w));
  float _929 = _927 + SV_Position.x;
  float _930 = _928 + SV_Position.y;
  uint _931 = uint(_929);
  uint _932 = uint(_930);
  uint _935 = cb2_019x + -1u;
  uint _936 = cb2_019y + -1u;
  int _937 = _931 & _935;
  int _938 = _932 & _936;
  float4 _939 = t3.Load(int3(_937, _938, 0));
  float _943 = _939.x * 2.0f;
  float _944 = _939.y * 2.0f;
  float _945 = _939.z * 2.0f;
  float _946 = _943 + -1.0f;
  float _947 = _944 + -1.0f;
  float _948 = _945 + -1.0f;
  float _949 = _946 * _429;
  float _950 = _947 * _429;
  float _951 = _948 * _429;
  float _952 = _949 + _921;
  float _953 = _950 + _922;
  float _954 = _951 + _923;
  float _955 = dot(float3(_952, _953, _954), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _952;
  SV_Target.y = _953;
  SV_Target.z = _954;
  SV_Target.w = _955;
  SV_Target_1.x = _955;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
