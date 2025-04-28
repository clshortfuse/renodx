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
  float _557;
  float _558;
  float _559;
  float _584;
  float _596;
  float _624;
  float _636;
  float _648;
  float _649;
  float _650;
  float _677;
  float _678;
  float _679;
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
  float _457 = _454 * 0.9708889722824097f;
  float _458 = mad(0.026962999254465103f, _455, _457);
  float _459 = mad(0.002148000057786703f, _456, _458);
  float _460 = _454 * 0.01088900025933981f;
  float _461 = mad(0.9869629740715027f, _455, _460);
  float _462 = mad(0.002148000057786703f, _456, _461);
  float _463 = mad(0.026962999254465103f, _455, _460);
  float _464 = mad(0.9621480107307434f, _456, _463);
  if (_446) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _469 = cb1_018y * 0.10000000149011612f;
        float _470 = log2(cb1_018z);
        float _471 = _470 + -13.287712097167969f;
        float _472 = _471 * 1.4929734468460083f;
        float _473 = _472 + 18.0f;
        float _474 = exp2(_473);
        float _475 = _474 * 0.18000000715255737f;
        float _476 = abs(_475);
        float _477 = log2(_476);
        float _478 = _477 * 1.5f;
        float _479 = exp2(_478);
        float _480 = _479 * _469;
        float _481 = _480 / cb1_018z;
        float _482 = _481 + -0.07636754959821701f;
        float _483 = _477 * 1.2750000953674316f;
        float _484 = exp2(_483);
        float _485 = _484 * 0.07636754959821701f;
        float _486 = cb1_018y * 0.011232397519052029f;
        float _487 = _486 * _479;
        float _488 = _487 / cb1_018z;
        float _489 = _485 - _488;
        float _490 = _484 + -0.11232396960258484f;
        float _491 = _490 * _469;
        float _492 = _491 / cb1_018z;
        float _493 = _492 * cb1_018z;
        float _494 = abs(_459);
        float _495 = abs(_462);
        float _496 = abs(_464);
        float _497 = log2(_494);
        float _498 = log2(_495);
        float _499 = log2(_496);
        float _500 = _497 * 1.5f;
        float _501 = _498 * 1.5f;
        float _502 = _499 * 1.5f;
        float _503 = exp2(_500);
        float _504 = exp2(_501);
        float _505 = exp2(_502);
        float _506 = _503 * _493;
        float _507 = _504 * _493;
        float _508 = _505 * _493;
        float _509 = _497 * 1.2750000953674316f;
        float _510 = _498 * 1.2750000953674316f;
        float _511 = _499 * 1.2750000953674316f;
        float _512 = exp2(_509);
        float _513 = exp2(_510);
        float _514 = exp2(_511);
        float _515 = _512 * _482;
        float _516 = _513 * _482;
        float _517 = _514 * _482;
        float _518 = _515 + _489;
        float _519 = _516 + _489;
        float _520 = _517 + _489;
        float _521 = _506 / _518;
        float _522 = _507 / _519;
        float _523 = _508 / _520;
        float _524 = _521 * 9.999999747378752e-05f;
        float _525 = _522 * 9.999999747378752e-05f;
        float _526 = _523 * 9.999999747378752e-05f;
        float _527 = 5000.0f / cb1_018y;
        float _528 = _524 * _527;
        float _529 = _525 * _527;
        float _530 = _526 * _527;
        _557 = _528;
        _558 = _529;
        _559 = _530;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_459, _462, _464));
      _557 = tonemapped.x, _558 = tonemapped.y, _559 = tonemapped.z;
    }
      } else {
        float _532 = _459 + 0.020616600289940834f;
        float _533 = _462 + 0.020616600289940834f;
        float _534 = _464 + 0.020616600289940834f;
        float _535 = _532 * _459;
        float _536 = _533 * _462;
        float _537 = _534 * _464;
        float _538 = _535 + -7.456949970219284e-05f;
        float _539 = _536 + -7.456949970219284e-05f;
        float _540 = _537 + -7.456949970219284e-05f;
        float _541 = _459 * 0.9837960004806519f;
        float _542 = _462 * 0.9837960004806519f;
        float _543 = _464 * 0.9837960004806519f;
        float _544 = _541 + 0.4336790144443512f;
        float _545 = _542 + 0.4336790144443512f;
        float _546 = _543 + 0.4336790144443512f;
        float _547 = _544 * _459;
        float _548 = _545 * _462;
        float _549 = _546 * _464;
        float _550 = _547 + 0.24617899954319f;
        float _551 = _548 + 0.24617899954319f;
        float _552 = _549 + 0.24617899954319f;
        float _553 = _538 / _550;
        float _554 = _539 / _551;
        float _555 = _540 / _552;
        _557 = _553;
        _558 = _554;
        _559 = _555;
      }
      float _560 = _557 * 1.6047500371932983f;
      float _561 = mad(-0.5310800075531006f, _558, _560);
      float _562 = mad(-0.07366999983787537f, _559, _561);
      float _563 = _557 * -0.10208000242710114f;
      float _564 = mad(1.1081299781799316f, _558, _563);
      float _565 = mad(-0.006049999967217445f, _559, _564);
      float _566 = _557 * -0.0032599999103695154f;
      float _567 = mad(-0.07275000214576721f, _558, _566);
      float _568 = mad(1.0760200023651123f, _559, _567);
      if (_446) {
        // float _570 = max(_562, 0.0f);
        // float _571 = max(_565, 0.0f);
        // float _572 = max(_568, 0.0f);
        // bool _573 = !(_570 >= 0.0030399328097701073f);
        // if (!_573) {
        //   float _575 = abs(_570);
        //   float _576 = log2(_575);
        //   float _577 = _576 * 0.4166666567325592f;
        //   float _578 = exp2(_577);
        //   float _579 = _578 * 1.0549999475479126f;
        //   float _580 = _579 + -0.054999999701976776f;
        //   _584 = _580;
        // } else {
        //   float _582 = _570 * 12.923210144042969f;
        //   _584 = _582;
        // }
        // bool _585 = !(_571 >= 0.0030399328097701073f);
        // if (!_585) {
        //   float _587 = abs(_571);
        //   float _588 = log2(_587);
        //   float _589 = _588 * 0.4166666567325592f;
        //   float _590 = exp2(_589);
        //   float _591 = _590 * 1.0549999475479126f;
        //   float _592 = _591 + -0.054999999701976776f;
        //   _596 = _592;
        // } else {
        //   float _594 = _571 * 12.923210144042969f;
        //   _596 = _594;
        // }
        // bool _597 = !(_572 >= 0.0030399328097701073f);
        // if (!_597) {
        //   float _599 = abs(_572);
        //   float _600 = log2(_599);
        //   float _601 = _600 * 0.4166666567325592f;
        //   float _602 = exp2(_601);
        //   float _603 = _602 * 1.0549999475479126f;
        //   float _604 = _603 + -0.054999999701976776f;
        //   _677 = _584;
        //   _678 = _596;
        //   _679 = _604;
        // } else {
        //   float _606 = _572 * 12.923210144042969f;
        //   _677 = _584;
        //   _678 = _596;
        //   _679 = _606;
        // }
        _677 = renodx::color::srgb::EncodeSafe(_562);
        _678 = renodx::color::srgb::EncodeSafe(_565);
        _679 = renodx::color::srgb::EncodeSafe(_568);

      } else {
        float _608 = saturate(_562);
        float _609 = saturate(_565);
        float _610 = saturate(_568);
        bool _611 = ((uint)(cb1_018w) == -2);
        if (!_611) {
          bool _613 = !(_608 >= 0.0030399328097701073f);
          if (!_613) {
            float _615 = abs(_608);
            float _616 = log2(_615);
            float _617 = _616 * 0.4166666567325592f;
            float _618 = exp2(_617);
            float _619 = _618 * 1.0549999475479126f;
            float _620 = _619 + -0.054999999701976776f;
            _624 = _620;
          } else {
            float _622 = _608 * 12.923210144042969f;
            _624 = _622;
          }
          bool _625 = !(_609 >= 0.0030399328097701073f);
          if (!_625) {
            float _627 = abs(_609);
            float _628 = log2(_627);
            float _629 = _628 * 0.4166666567325592f;
            float _630 = exp2(_629);
            float _631 = _630 * 1.0549999475479126f;
            float _632 = _631 + -0.054999999701976776f;
            _636 = _632;
          } else {
            float _634 = _609 * 12.923210144042969f;
            _636 = _634;
          }
          bool _637 = !(_610 >= 0.0030399328097701073f);
          if (!_637) {
            float _639 = abs(_610);
            float _640 = log2(_639);
            float _641 = _640 * 0.4166666567325592f;
            float _642 = exp2(_641);
            float _643 = _642 * 1.0549999475479126f;
            float _644 = _643 + -0.054999999701976776f;
            _648 = _624;
            _649 = _636;
            _650 = _644;
          } else {
            float _646 = _610 * 12.923210144042969f;
            _648 = _624;
            _649 = _636;
            _650 = _646;
          }
        } else {
          _648 = _608;
          _649 = _609;
          _650 = _610;
        }
        float _655 = abs(_648);
        float _656 = abs(_649);
        float _657 = abs(_650);
        float _658 = log2(_655);
        float _659 = log2(_656);
        float _660 = log2(_657);
        float _661 = _658 * cb2_000z;
        float _662 = _659 * cb2_000z;
        float _663 = _660 * cb2_000z;
        float _664 = exp2(_661);
        float _665 = exp2(_662);
        float _666 = exp2(_663);
        float _667 = _664 * cb2_000y;
        float _668 = _665 * cb2_000y;
        float _669 = _666 * cb2_000y;
        float _670 = _667 + cb2_000x;
        float _671 = _668 + cb2_000x;
        float _672 = _669 + cb2_000x;
        float _673 = saturate(_670);
        float _674 = saturate(_671);
        float _675 = saturate(_672);
        _677 = _673;
        _678 = _674;
        _679 = _675;
      }
      float _683 = cb2_023x * TEXCOORD0_centroid.x;
      float _684 = cb2_023y * TEXCOORD0_centroid.y;
      float _687 = _683 + cb2_023z;
      float _688 = _684 + cb2_023w;
      float4 _691 = t9.SampleLevel(s0_space2, float2(_687, _688), 0.0f);
      float _693 = _691.x + -0.5f;
      float _694 = _693 * cb2_022x;
      float _695 = _694 + 0.5f;
      float _696 = _695 * 2.0f;
      float _697 = _696 * _677;
      float _698 = _696 * _678;
      float _699 = _696 * _679;
      float _703 = float((uint)(cb2_019z));
      float _704 = float((uint)(cb2_019w));
      float _705 = _703 + SV_Position.x;
      float _706 = _704 + SV_Position.y;
      uint _707 = uint(_705);
      uint _708 = uint(_706);
      uint _711 = cb2_019x + -1u;
      uint _712 = cb2_019y + -1u;
      int _713 = _707 & _711;
      int _714 = _708 & _712;
      float4 _715 = t3.Load(int3(_713, _714, 0));
      float _719 = _715.x * 2.0f;
      float _720 = _715.y * 2.0f;
      float _721 = _715.z * 2.0f;
      float _722 = _719 + -1.0f;
      float _723 = _720 + -1.0f;
      float _724 = _721 + -1.0f;
      float _725 = _722 * _429;
      float _726 = _723 * _429;
      float _727 = _724 * _429;
      float _728 = _725 + _697;
      float _729 = _726 + _698;
      float _730 = _727 + _699;
      float _731 = dot(float3(_728, _729, _730), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _728;
      SV_Target.y = _729;
      SV_Target.z = _730;
      SV_Target.w = _731;
      SV_Target_1.x = _731;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
