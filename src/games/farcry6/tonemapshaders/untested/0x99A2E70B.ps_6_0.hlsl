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

Texture3D<float4> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t7 : register(t7);

Texture3D<float2> t8 : register(t8);

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
  float cb2_015x : packoffset(c015.x);
  float cb2_015y : packoffset(c015.y);
  float cb2_015z : packoffset(c015.z);
  float cb2_015w : packoffset(c015.w);
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
  float cb2_020x : packoffset(c020.x);
  float cb2_020y : packoffset(c020.y);
  float cb2_020z : packoffset(c020.z);
  float cb2_020w : packoffset(c020.w);
  float cb2_021x : packoffset(c021.x);
  float cb2_021y : packoffset(c021.y);
  float cb2_021z : packoffset(c021.z);
  float cb2_021w : packoffset(c021.w);
  float cb2_024x : packoffset(c024.x);
  float cb2_024y : packoffset(c024.y);
  float cb2_024z : packoffset(c024.z);
  float cb2_024w : packoffset(c024.w);
  float cb2_025x : packoffset(c025.x);
  float cb2_025y : packoffset(c025.y);
  float cb2_025z : packoffset(c025.z);
  float cb2_026x : packoffset(c026.x);
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
  float _21 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _26 = cb2_015x * TEXCOORD0_centroid.x;
  float _27 = cb2_015y * TEXCOORD0_centroid.y;
  float _30 = _26 + cb2_015z;
  float _31 = _27 + cb2_015w;
  float4 _32 = t7.SampleLevel(s0_space2, float2(_30, _31), 0.0f);
  float _36 = saturate(_32.x);
  float _37 = saturate(_32.z);
  float _40 = cb2_026x * _37;
  float _41 = _36 * 6.283199787139893f;
  float _42 = cos(_41);
  float _43 = sin(_41);
  float _44 = _40 * _42;
  float _45 = _43 * _40;
  float _46 = 1.0f - _32.y;
  float _47 = saturate(_46);
  float _48 = _44 * _47;
  float _49 = _45 * _47;
  float _50 = _48 + TEXCOORD0_centroid.x;
  float _51 = _49 + TEXCOORD0_centroid.y;
  float4 _52 = t1.SampleLevel(s4_space2, float2(_50, _51), 0.0f);
  float _56 = max(_52.x, 0.0f);
  float _57 = max(_52.y, 0.0f);
  float _58 = max(_52.z, 0.0f);
  float _59 = min(_56, 65000.0f);
  float _60 = min(_57, 65000.0f);
  float _61 = min(_58, 65000.0f);
  float4 _62 = t3.SampleLevel(s2_space2, float2(_50, _51), 0.0f);
  float _67 = max(_62.x, 0.0f);
  float _68 = max(_62.y, 0.0f);
  float _69 = max(_62.z, 0.0f);
  float _70 = max(_62.w, 0.0f);
  float _71 = min(_67, 5000.0f);
  float _72 = min(_68, 5000.0f);
  float _73 = min(_69, 5000.0f);
  float _74 = min(_70, 5000.0f);
  float _77 = _21.x * cb0_028z;
  float _78 = _77 + cb0_028x;
  float _79 = cb2_027w / _78;
  float _80 = 1.0f - _79;
  float _81 = abs(_80);
  float _83 = cb2_027y * _81;
  float _85 = _83 - cb2_027z;
  float _86 = saturate(_85);
  float _87 = max(_86, _74);
  float _88 = saturate(_87);
  float4 _89 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _93 = _71 - _59;
  float _94 = _72 - _60;
  float _95 = _73 - _61;
  float _96 = _88 * _93;
  float _97 = _88 * _94;
  float _98 = _88 * _95;
  float _99 = _96 + _59;
  float _100 = _97 + _60;
  float _101 = _98 + _61;
  float _102 = dot(float3(_99, _100, _101), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _106 = t0[0].SExposureData_020;
  float _108 = t0[0].SExposureData_004;
  float _110 = cb2_018x * 0.5f;
  float _111 = _110 * cb2_018y;
  float _112 = _108.x - _111;
  float _113 = cb2_018y * cb2_018x;
  float _114 = 1.0f / _113;
  float _115 = _112 * _114;
  float _116 = _102 / _106.x;
  float _117 = _116 * 5464.01611328125f;
  float _118 = _117 + 9.99999993922529e-09f;
  float _119 = log2(_118);
  float _120 = _119 - _112;
  float _121 = _120 * _114;
  float _122 = saturate(_121);
  float2 _123 = t8.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _122), 0.0f);
  float _126 = max(_123.y, 1.0000000116860974e-07f);
  float _127 = _123.x / _126;
  float _128 = _127 + _115;
  float _129 = _128 / _114;
  float _130 = _129 - _108.x;
  float _131 = -0.0f - _130;
  float _133 = _131 - cb2_027x;
  float _134 = max(0.0f, _133);
  float _136 = cb2_026z * _134;
  float _137 = _130 - cb2_027x;
  float _138 = max(0.0f, _137);
  float _140 = cb2_026w * _138;
  bool _141 = (_130 < 0.0f);
  float _142 = select(_141, _136, _140);
  float _143 = exp2(_142);
  float _144 = _143 * _99;
  float _145 = _143 * _100;
  float _146 = _143 * _101;
  float _151 = cb2_024y * _89.x;
  float _152 = cb2_024z * _89.y;
  float _153 = cb2_024w * _89.z;
  float _154 = _151 + _144;
  float _155 = _152 + _145;
  float _156 = _153 + _146;
  float _161 = _154 * cb2_025x;
  float _162 = _155 * cb2_025y;
  float _163 = _156 * cb2_025z;
  float _164 = dot(float3(_161, _162, _163), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _165 = t0[0].SExposureData_012;
  float _167 = _164 * 5464.01611328125f;
  float _168 = _167 * _165.x;
  float _169 = _168 + 9.99999993922529e-09f;
  float _170 = log2(_169);
  float _171 = _170 + 16.929765701293945f;
  float _172 = _171 * 0.05734497308731079f;
  float _173 = saturate(_172);
  float _174 = _173 * _173;
  float _175 = _173 * 2.0f;
  float _176 = 3.0f - _175;
  float _177 = _174 * _176;
  float _178 = _162 * 0.8450999855995178f;
  float _179 = _163 * 0.14589999616146088f;
  float _180 = _178 + _179;
  float _181 = _180 * 2.4890189170837402f;
  float _182 = _180 * 0.3754962384700775f;
  float _183 = _180 * 2.811495304107666f;
  float _184 = _180 * 5.519708156585693f;
  float _185 = _164 - _181;
  float _186 = _177 * _185;
  float _187 = _186 + _181;
  float _188 = _177 * 0.5f;
  float _189 = _188 + 0.5f;
  float _190 = _189 * _185;
  float _191 = _190 + _181;
  float _192 = _161 - _182;
  float _193 = _162 - _183;
  float _194 = _163 - _184;
  float _195 = _189 * _192;
  float _196 = _189 * _193;
  float _197 = _189 * _194;
  float _198 = _195 + _182;
  float _199 = _196 + _183;
  float _200 = _197 + _184;
  float _201 = 1.0f / _191;
  float _202 = _187 * _201;
  float _203 = _202 * _198;
  float _204 = _202 * _199;
  float _205 = _202 * _200;
  float _209 = cb2_020x * TEXCOORD0_centroid.x;
  float _210 = cb2_020y * TEXCOORD0_centroid.y;
  float _213 = _209 + cb2_020z;
  float _214 = _210 + cb2_020w;
  float _217 = dot(float2(_213, _214), float2(_213, _214));
  float _218 = 1.0f - _217;
  float _219 = saturate(_218);
  float _220 = log2(_219);
  float _221 = _220 * cb2_021w;
  float _222 = exp2(_221);
  float _226 = _203 - cb2_021x;
  float _227 = _204 - cb2_021y;
  float _228 = _205 - cb2_021z;
  float _229 = _226 * _222;
  float _230 = _227 * _222;
  float _231 = _228 * _222;
  float _232 = _229 + cb2_021x;
  float _233 = _230 + cb2_021y;
  float _234 = _231 + cb2_021z;
  float _235 = t0[0].SExposureData_000;
  float _237 = max(_106.x, 0.0010000000474974513f);
  float _238 = 1.0f / _237;
  float _239 = _238 * _235.x;
  bool _242 = ((uint)(cb2_069y) == 0);
  float _248;
  float _249;
  float _250;
  float _304;
  float _305;
  float _306;
  float _351;
  float _352;
  float _353;
  float _398;
  float _399;
  float _400;
  float _401;
  float _448;
  float _449;
  float _450;
  float _475;
  float _476;
  float _477;
  float _578;
  float _579;
  float _580;
  float _605;
  float _617;
  float _645;
  float _657;
  float _669;
  float _670;
  float _671;
  float _698;
  float _699;
  float _700;
  if (!_242) {
    float _244 = _239 * _232;
    float _245 = _239 * _233;
    float _246 = _239 * _234;
    _248 = _244;
    _249 = _245;
    _250 = _246;
  } else {
    _248 = _232;
    _249 = _233;
    _250 = _234;
  }
  float _251 = _248 * 0.6130970120429993f;
  float _252 = mad(0.33952298760414124f, _249, _251);
  float _253 = mad(0.04737899824976921f, _250, _252);
  float _254 = _248 * 0.07019399851560593f;
  float _255 = mad(0.9163540005683899f, _249, _254);
  float _256 = mad(0.013451999984681606f, _250, _255);
  float _257 = _248 * 0.02061600051820278f;
  float _258 = mad(0.10956999659538269f, _249, _257);
  float _259 = mad(0.8698149919509888f, _250, _258);
  float _260 = log2(_253);
  float _261 = log2(_256);
  float _262 = log2(_259);
  float _263 = _260 * 0.04211956635117531f;
  float _264 = _261 * 0.04211956635117531f;
  float _265 = _262 * 0.04211956635117531f;
  float _266 = _263 + 0.6252607107162476f;
  float _267 = _264 + 0.6252607107162476f;
  float _268 = _265 + 0.6252607107162476f;
  float4 _269 = t5.SampleLevel(s2_space2, float3(_266, _267, _268), 0.0f);
  bool _275 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_275 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _279 = cb2_017x * _269.x;
    float _280 = cb2_017x * _269.y;
    float _281 = cb2_017x * _269.z;
    float _283 = _279 + cb2_017y;
    float _284 = _280 + cb2_017y;
    float _285 = _281 + cb2_017y;
    float _286 = exp2(_283);
    float _287 = exp2(_284);
    float _288 = exp2(_285);
    float _289 = _286 + 1.0f;
    float _290 = _287 + 1.0f;
    float _291 = _288 + 1.0f;
    float _292 = 1.0f / _289;
    float _293 = 1.0f / _290;
    float _294 = 1.0f / _291;
    float _296 = cb2_017z * _292;
    float _297 = cb2_017z * _293;
    float _298 = cb2_017z * _294;
    float _300 = _296 + cb2_017w;
    float _301 = _297 + cb2_017w;
    float _302 = _298 + cb2_017w;
    _304 = _300;
    _305 = _301;
    _306 = _302;
  } else {
    _304 = _269.x;
    _305 = _269.y;
    _306 = _269.z;
  }
  float _307 = _304 * 23.0f;
  float _308 = _307 + -14.473931312561035f;
  float _309 = exp2(_308);
  float _310 = _305 * 23.0f;
  float _311 = _310 + -14.473931312561035f;
  float _312 = exp2(_311);
  float _313 = _306 * 23.0f;
  float _314 = _313 + -14.473931312561035f;
  float _315 = exp2(_314);
  float _319 = cb2_004x * TEXCOORD0_centroid.x;
  float _320 = cb2_004y * TEXCOORD0_centroid.y;
  float _323 = _319 + cb2_004z;
  float _324 = _320 + cb2_004w;
  float4 _330 = t6.Sample(s2_space2, float2(_323, _324));
  float _335 = _330.x * cb2_003x;
  float _336 = _330.y * cb2_003y;
  float _337 = _330.z * cb2_003z;
  float _338 = _330.w * cb2_003w;
  float _341 = _338 + cb2_026y;
  float _342 = saturate(_341);
  bool _345 = ((uint)(cb2_069y) == 0);
  if (!_345) {
    float _347 = _335 * _239;
    float _348 = _336 * _239;
    float _349 = _337 * _239;
    _351 = _347;
    _352 = _348;
    _353 = _349;
  } else {
    _351 = _335;
    _352 = _336;
    _353 = _337;
  }
  bool _356 = ((uint)(cb2_028x) == 2);
  bool _357 = ((uint)(cb2_028x) == 3);
  int _358 = (uint)(cb2_028x) & -2;
  bool _359 = (_358 == 2);
  bool _360 = ((uint)(cb2_028x) == 6);
  bool _361 = _359 || _360;
  if (_361) {
    float _363 = _351 * _342;
    float _364 = _352 * _342;
    float _365 = _353 * _342;
    float _366 = _342 * _342;
    _398 = _363;
    _399 = _364;
    _400 = _365;
    _401 = _366;
  } else {
    bool _368 = ((uint)(cb2_028x) == 4);
    if (_368) {
      float _370 = _351 + -1.0f;
      float _371 = _352 + -1.0f;
      float _372 = _353 + -1.0f;
      float _373 = _342 + -1.0f;
      float _374 = _370 * _342;
      float _375 = _371 * _342;
      float _376 = _372 * _342;
      float _377 = _373 * _342;
      float _378 = _374 + 1.0f;
      float _379 = _375 + 1.0f;
      float _380 = _376 + 1.0f;
      float _381 = _377 + 1.0f;
      _398 = _378;
      _399 = _379;
      _400 = _380;
      _401 = _381;
    } else {
      bool _383 = ((uint)(cb2_028x) == 5);
      if (_383) {
        float _385 = _351 + -0.5f;
        float _386 = _352 + -0.5f;
        float _387 = _353 + -0.5f;
        float _388 = _342 + -0.5f;
        float _389 = _385 * _342;
        float _390 = _386 * _342;
        float _391 = _387 * _342;
        float _392 = _388 * _342;
        float _393 = _389 + 0.5f;
        float _394 = _390 + 0.5f;
        float _395 = _391 + 0.5f;
        float _396 = _392 + 0.5f;
        _398 = _393;
        _399 = _394;
        _400 = _395;
        _401 = _396;
      } else {
        _398 = _351;
        _399 = _352;
        _400 = _353;
        _401 = _342;
      }
    }
  }
  if (_356) {
    float _403 = _398 + _309;
    float _404 = _399 + _312;
    float _405 = _400 + _315;
    _448 = _403;
    _449 = _404;
    _450 = _405;
  } else {
    if (_357) {
      float _408 = 1.0f - _398;
      float _409 = 1.0f - _399;
      float _410 = 1.0f - _400;
      float _411 = _408 * _309;
      float _412 = _409 * _312;
      float _413 = _410 * _315;
      float _414 = _411 + _398;
      float _415 = _412 + _399;
      float _416 = _413 + _400;
      _448 = _414;
      _449 = _415;
      _450 = _416;
    } else {
      bool _418 = ((uint)(cb2_028x) == 4);
      if (_418) {
        float _420 = _398 * _309;
        float _421 = _399 * _312;
        float _422 = _400 * _315;
        _448 = _420;
        _449 = _421;
        _450 = _422;
      } else {
        bool _424 = ((uint)(cb2_028x) == 5);
        if (_424) {
          float _426 = _309 * 2.0f;
          float _427 = _426 * _398;
          float _428 = _312 * 2.0f;
          float _429 = _428 * _399;
          float _430 = _315 * 2.0f;
          float _431 = _430 * _400;
          _448 = _427;
          _449 = _429;
          _450 = _431;
        } else {
          if (_360) {
            float _434 = _309 - _398;
            float _435 = _312 - _399;
            float _436 = _315 - _400;
            _448 = _434;
            _449 = _435;
            _450 = _436;
          } else {
            float _438 = _398 - _309;
            float _439 = _399 - _312;
            float _440 = _400 - _315;
            float _441 = _401 * _438;
            float _442 = _401 * _439;
            float _443 = _401 * _440;
            float _444 = _441 + _309;
            float _445 = _442 + _312;
            float _446 = _443 + _315;
            _448 = _444;
            _449 = _445;
            _450 = _446;
          }
        }
      }
    }
  }
  float _456 = cb2_016x - _448;
  float _457 = cb2_016y - _449;
  float _458 = cb2_016z - _450;
  float _459 = _456 * cb2_016w;
  float _460 = _457 * cb2_016w;
  float _461 = _458 * cb2_016w;
  float _462 = _459 + _448;
  float _463 = _460 + _449;
  float _464 = _461 + _450;
  bool _467 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_467 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _471 = cb2_024x * _462;
    float _472 = cb2_024x * _463;
    float _473 = cb2_024x * _464;
    _475 = _471;
    _476 = _472;
    _477 = _473;
  } else {
    _475 = _462;
    _476 = _463;
    _477 = _464;
  }
  float _478 = _475 * 0.9708889722824097f;
  float _479 = mad(0.026962999254465103f, _476, _478);
  float _480 = mad(0.002148000057786703f, _477, _479);
  float _481 = _475 * 0.01088900025933981f;
  float _482 = mad(0.9869629740715027f, _476, _481);
  float _483 = mad(0.002148000057786703f, _477, _482);
  float _484 = mad(0.026962999254465103f, _476, _481);
  float _485 = mad(0.9621480107307434f, _477, _484);
  if (_467) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _490 = cb1_018y * 0.10000000149011612f;
        float _491 = log2(cb1_018z);
        float _492 = _491 + -13.287712097167969f;
        float _493 = _492 * 1.4929734468460083f;
        float _494 = _493 + 18.0f;
        float _495 = exp2(_494);
        float _496 = _495 * 0.18000000715255737f;
        float _497 = abs(_496);
        float _498 = log2(_497);
        float _499 = _498 * 1.5f;
        float _500 = exp2(_499);
        float _501 = _500 * _490;
        float _502 = _501 / cb1_018z;
        float _503 = _502 + -0.07636754959821701f;
        float _504 = _498 * 1.2750000953674316f;
        float _505 = exp2(_504);
        float _506 = _505 * 0.07636754959821701f;
        float _507 = cb1_018y * 0.011232397519052029f;
        float _508 = _507 * _500;
        float _509 = _508 / cb1_018z;
        float _510 = _506 - _509;
        float _511 = _505 + -0.11232396960258484f;
        float _512 = _511 * _490;
        float _513 = _512 / cb1_018z;
        float _514 = _513 * cb1_018z;
        float _515 = abs(_480);
        float _516 = abs(_483);
        float _517 = abs(_485);
        float _518 = log2(_515);
        float _519 = log2(_516);
        float _520 = log2(_517);
        float _521 = _518 * 1.5f;
        float _522 = _519 * 1.5f;
        float _523 = _520 * 1.5f;
        float _524 = exp2(_521);
        float _525 = exp2(_522);
        float _526 = exp2(_523);
        float _527 = _524 * _514;
        float _528 = _525 * _514;
        float _529 = _526 * _514;
        float _530 = _518 * 1.2750000953674316f;
        float _531 = _519 * 1.2750000953674316f;
        float _532 = _520 * 1.2750000953674316f;
        float _533 = exp2(_530);
        float _534 = exp2(_531);
        float _535 = exp2(_532);
        float _536 = _533 * _503;
        float _537 = _534 * _503;
        float _538 = _535 * _503;
        float _539 = _536 + _510;
        float _540 = _537 + _510;
        float _541 = _538 + _510;
        float _542 = _527 / _539;
        float _543 = _528 / _540;
        float _544 = _529 / _541;
        float _545 = _542 * 9.999999747378752e-05f;
        float _546 = _543 * 9.999999747378752e-05f;
        float _547 = _544 * 9.999999747378752e-05f;
        float _548 = 5000.0f / cb1_018y;
        float _549 = _545 * _548;
        float _550 = _546 * _548;
        float _551 = _547 * _548;
        _578 = _549;
        _579 = _550;
        _580 = _551;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_480, _483, _485));
      _578 = tonemapped.x, _579 = tonemapped.y, _580 = tonemapped.z;
    }
      } else {
        float _553 = _480 + 0.020616600289940834f;
        float _554 = _483 + 0.020616600289940834f;
        float _555 = _485 + 0.020616600289940834f;
        float _556 = _553 * _480;
        float _557 = _554 * _483;
        float _558 = _555 * _485;
        float _559 = _556 + -7.456949970219284e-05f;
        float _560 = _557 + -7.456949970219284e-05f;
        float _561 = _558 + -7.456949970219284e-05f;
        float _562 = _480 * 0.9837960004806519f;
        float _563 = _483 * 0.9837960004806519f;
        float _564 = _485 * 0.9837960004806519f;
        float _565 = _562 + 0.4336790144443512f;
        float _566 = _563 + 0.4336790144443512f;
        float _567 = _564 + 0.4336790144443512f;
        float _568 = _565 * _480;
        float _569 = _566 * _483;
        float _570 = _567 * _485;
        float _571 = _568 + 0.24617899954319f;
        float _572 = _569 + 0.24617899954319f;
        float _573 = _570 + 0.24617899954319f;
        float _574 = _559 / _571;
        float _575 = _560 / _572;
        float _576 = _561 / _573;
        _578 = _574;
        _579 = _575;
        _580 = _576;
      }
      float _581 = _578 * 1.6047500371932983f;
      float _582 = mad(-0.5310800075531006f, _579, _581);
      float _583 = mad(-0.07366999983787537f, _580, _582);
      float _584 = _578 * -0.10208000242710114f;
      float _585 = mad(1.1081299781799316f, _579, _584);
      float _586 = mad(-0.006049999967217445f, _580, _585);
      float _587 = _578 * -0.0032599999103695154f;
      float _588 = mad(-0.07275000214576721f, _579, _587);
      float _589 = mad(1.0760200023651123f, _580, _588);
      if (_467) {
        // float _591 = max(_583, 0.0f);
        // float _592 = max(_586, 0.0f);
        // float _593 = max(_589, 0.0f);
        // bool _594 = !(_591 >= 0.0030399328097701073f);
        // if (!_594) {
        //   float _596 = abs(_591);
        //   float _597 = log2(_596);
        //   float _598 = _597 * 0.4166666567325592f;
        //   float _599 = exp2(_598);
        //   float _600 = _599 * 1.0549999475479126f;
        //   float _601 = _600 + -0.054999999701976776f;
        //   _605 = _601;
        // } else {
        //   float _603 = _591 * 12.923210144042969f;
        //   _605 = _603;
        // }
        // bool _606 = !(_592 >= 0.0030399328097701073f);
        // if (!_606) {
        //   float _608 = abs(_592);
        //   float _609 = log2(_608);
        //   float _610 = _609 * 0.4166666567325592f;
        //   float _611 = exp2(_610);
        //   float _612 = _611 * 1.0549999475479126f;
        //   float _613 = _612 + -0.054999999701976776f;
        //   _617 = _613;
        // } else {
        //   float _615 = _592 * 12.923210144042969f;
        //   _617 = _615;
        // }
        // bool _618 = !(_593 >= 0.0030399328097701073f);
        // if (!_618) {
        //   float _620 = abs(_593);
        //   float _621 = log2(_620);
        //   float _622 = _621 * 0.4166666567325592f;
        //   float _623 = exp2(_622);
        //   float _624 = _623 * 1.0549999475479126f;
        //   float _625 = _624 + -0.054999999701976776f;
        //   _698 = _605;
        //   _699 = _617;
        //   _700 = _625;
        // } else {
        //   float _627 = _593 * 12.923210144042969f;
        //   _698 = _605;
        //   _699 = _617;
        //   _700 = _627;
        // }
        _698 = renodx::color::srgb::EncodeSafe(_583);
        _699 = renodx::color::srgb::EncodeSafe(_586);
        _700 = renodx::color::srgb::EncodeSafe(_589);

      } else {
        float _629 = saturate(_583);
        float _630 = saturate(_586);
        float _631 = saturate(_589);
        bool _632 = ((uint)(cb1_018w) == -2);
        if (!_632) {
          bool _634 = !(_629 >= 0.0030399328097701073f);
          if (!_634) {
            float _636 = abs(_629);
            float _637 = log2(_636);
            float _638 = _637 * 0.4166666567325592f;
            float _639 = exp2(_638);
            float _640 = _639 * 1.0549999475479126f;
            float _641 = _640 + -0.054999999701976776f;
            _645 = _641;
          } else {
            float _643 = _629 * 12.923210144042969f;
            _645 = _643;
          }
          bool _646 = !(_630 >= 0.0030399328097701073f);
          if (!_646) {
            float _648 = abs(_630);
            float _649 = log2(_648);
            float _650 = _649 * 0.4166666567325592f;
            float _651 = exp2(_650);
            float _652 = _651 * 1.0549999475479126f;
            float _653 = _652 + -0.054999999701976776f;
            _657 = _653;
          } else {
            float _655 = _630 * 12.923210144042969f;
            _657 = _655;
          }
          bool _658 = !(_631 >= 0.0030399328097701073f);
          if (!_658) {
            float _660 = abs(_631);
            float _661 = log2(_660);
            float _662 = _661 * 0.4166666567325592f;
            float _663 = exp2(_662);
            float _664 = _663 * 1.0549999475479126f;
            float _665 = _664 + -0.054999999701976776f;
            _669 = _645;
            _670 = _657;
            _671 = _665;
          } else {
            float _667 = _631 * 12.923210144042969f;
            _669 = _645;
            _670 = _657;
            _671 = _667;
          }
        } else {
          _669 = _629;
          _670 = _630;
          _671 = _631;
        }
        float _676 = abs(_669);
        float _677 = abs(_670);
        float _678 = abs(_671);
        float _679 = log2(_676);
        float _680 = log2(_677);
        float _681 = log2(_678);
        float _682 = _679 * cb2_000z;
        float _683 = _680 * cb2_000z;
        float _684 = _681 * cb2_000z;
        float _685 = exp2(_682);
        float _686 = exp2(_683);
        float _687 = exp2(_684);
        float _688 = _685 * cb2_000y;
        float _689 = _686 * cb2_000y;
        float _690 = _687 * cb2_000y;
        float _691 = _688 + cb2_000x;
        float _692 = _689 + cb2_000x;
        float _693 = _690 + cb2_000x;
        float _694 = saturate(_691);
        float _695 = saturate(_692);
        float _696 = saturate(_693);
        _698 = _694;
        _699 = _695;
        _700 = _696;
      }
      float _701 = dot(float3(_698, _699, _700), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _698;
      SV_Target.y = _699;
      SV_Target.z = _700;
      SV_Target.w = _701;
      SV_Target_1.x = _701;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
