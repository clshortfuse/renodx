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

Texture3D<float2> t7 : register(t7);

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
  float _19 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float4 _21 = t1.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _25 = max(_21.x, 0.0f);
  float _26 = max(_21.y, 0.0f);
  float _27 = max(_21.z, 0.0f);
  float _28 = min(_25, 65000.0f);
  float _29 = min(_26, 65000.0f);
  float _30 = min(_27, 65000.0f);
  float4 _31 = t3.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _36 = max(_31.x, 0.0f);
  float _37 = max(_31.y, 0.0f);
  float _38 = max(_31.z, 0.0f);
  float _39 = max(_31.w, 0.0f);
  float _40 = min(_36, 5000.0f);
  float _41 = min(_37, 5000.0f);
  float _42 = min(_38, 5000.0f);
  float _43 = min(_39, 5000.0f);
  float _46 = _19.x * cb0_028z;
  float _47 = _46 + cb0_028x;
  float _48 = cb2_027w / _47;
  float _49 = 1.0f - _48;
  float _50 = abs(_49);
  float _52 = cb2_027y * _50;
  float _54 = _52 - cb2_027z;
  float _55 = saturate(_54);
  float _56 = max(_55, _43);
  float _57 = saturate(_56);
  float4 _58 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _62 = _40 - _28;
  float _63 = _41 - _29;
  float _64 = _42 - _30;
  float _65 = _57 * _62;
  float _66 = _57 * _63;
  float _67 = _57 * _64;
  float _68 = _65 + _28;
  float _69 = _66 + _29;
  float _70 = _67 + _30;
  float _71 = dot(float3(_68, _69, _70), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _75 = t0[0].SExposureData_020;
  float _77 = t0[0].SExposureData_004;
  float _79 = cb2_018x * 0.5f;
  float _80 = _79 * cb2_018y;
  float _81 = _77.x - _80;
  float _82 = cb2_018y * cb2_018x;
  float _83 = 1.0f / _82;
  float _84 = _81 * _83;
  float _85 = _71 / _75.x;
  float _86 = _85 * 5464.01611328125f;
  float _87 = _86 + 9.99999993922529e-09f;
  float _88 = log2(_87);
  float _89 = _88 - _81;
  float _90 = _89 * _83;
  float _91 = saturate(_90);
  float2 _92 = t7.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _91), 0.0f);
  float _95 = max(_92.y, 1.0000000116860974e-07f);
  float _96 = _92.x / _95;
  float _97 = _96 + _84;
  float _98 = _97 / _83;
  float _99 = _98 - _77.x;
  float _100 = -0.0f - _99;
  float _102 = _100 - cb2_027x;
  float _103 = max(0.0f, _102);
  float _106 = cb2_026z * _103;
  float _107 = _99 - cb2_027x;
  float _108 = max(0.0f, _107);
  float _110 = cb2_026w * _108;
  bool _111 = (_99 < 0.0f);
  float _112 = select(_111, _106, _110);
  float _113 = exp2(_112);
  float _114 = _113 * _68;
  float _115 = _113 * _69;
  float _116 = _113 * _70;
  float _121 = cb2_024y * _58.x;
  float _122 = cb2_024z * _58.y;
  float _123 = cb2_024w * _58.z;
  float _124 = _121 + _114;
  float _125 = _122 + _115;
  float _126 = _123 + _116;
  float _131 = _124 * cb2_025x;
  float _132 = _125 * cb2_025y;
  float _133 = _126 * cb2_025z;
  float _134 = dot(float3(_131, _132, _133), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _135 = t0[0].SExposureData_012;
  float _137 = _134 * 5464.01611328125f;
  float _138 = _137 * _135.x;
  float _139 = _138 + 9.99999993922529e-09f;
  float _140 = log2(_139);
  float _141 = _140 + 16.929765701293945f;
  float _142 = _141 * 0.05734497308731079f;
  float _143 = saturate(_142);
  float _144 = _143 * _143;
  float _145 = _143 * 2.0f;
  float _146 = 3.0f - _145;
  float _147 = _144 * _146;
  float _148 = _132 * 0.8450999855995178f;
  float _149 = _133 * 0.14589999616146088f;
  float _150 = _148 + _149;
  float _151 = _150 * 2.4890189170837402f;
  float _152 = _150 * 0.3754962384700775f;
  float _153 = _150 * 2.811495304107666f;
  float _154 = _150 * 5.519708156585693f;
  float _155 = _134 - _151;
  float _156 = _147 * _155;
  float _157 = _156 + _151;
  float _158 = _147 * 0.5f;
  float _159 = _158 + 0.5f;
  float _160 = _159 * _155;
  float _161 = _160 + _151;
  float _162 = _131 - _152;
  float _163 = _132 - _153;
  float _164 = _133 - _154;
  float _165 = _159 * _162;
  float _166 = _159 * _163;
  float _167 = _159 * _164;
  float _168 = _165 + _152;
  float _169 = _166 + _153;
  float _170 = _167 + _154;
  float _171 = 1.0f / _161;
  float _172 = _157 * _171;
  float _173 = _172 * _168;
  float _174 = _172 * _169;
  float _175 = _172 * _170;
  float _179 = cb2_020x * TEXCOORD0_centroid.x;
  float _180 = cb2_020y * TEXCOORD0_centroid.y;
  float _183 = _179 + cb2_020z;
  float _184 = _180 + cb2_020w;
  float _187 = dot(float2(_183, _184), float2(_183, _184));
  float _188 = 1.0f - _187;
  float _189 = saturate(_188);
  float _190 = log2(_189);
  float _191 = _190 * cb2_021w;
  float _192 = exp2(_191);
  float _196 = _173 - cb2_021x;
  float _197 = _174 - cb2_021y;
  float _198 = _175 - cb2_021z;
  float _199 = _196 * _192;
  float _200 = _197 * _192;
  float _201 = _198 * _192;
  float _202 = _199 + cb2_021x;
  float _203 = _200 + cb2_021y;
  float _204 = _201 + cb2_021z;
  float _205 = t0[0].SExposureData_000;
  float _207 = max(_75.x, 0.0010000000474974513f);
  float _208 = 1.0f / _207;
  float _209 = _208 * _205.x;
  bool _212 = ((uint)(cb2_069y) == 0);
  float _218;
  float _219;
  float _220;
  float _274;
  float _275;
  float _276;
  float _321;
  float _322;
  float _323;
  float _368;
  float _369;
  float _370;
  float _371;
  float _418;
  float _419;
  float _420;
  float _445;
  float _446;
  float _447;
  float _548;
  float _549;
  float _550;
  float _575;
  float _587;
  float _615;
  float _627;
  float _639;
  float _640;
  float _641;
  float _668;
  float _669;
  float _670;
  if (!_212) {
    float _214 = _209 * _202;
    float _215 = _209 * _203;
    float _216 = _209 * _204;
    _218 = _214;
    _219 = _215;
    _220 = _216;
  } else {
    _218 = _202;
    _219 = _203;
    _220 = _204;
  }
  float _221 = _218 * 0.6130970120429993f;
  float _222 = mad(0.33952298760414124f, _219, _221);
  float _223 = mad(0.04737899824976921f, _220, _222);
  float _224 = _218 * 0.07019399851560593f;
  float _225 = mad(0.9163540005683899f, _219, _224);
  float _226 = mad(0.013451999984681606f, _220, _225);
  float _227 = _218 * 0.02061600051820278f;
  float _228 = mad(0.10956999659538269f, _219, _227);
  float _229 = mad(0.8698149919509888f, _220, _228);
  float _230 = log2(_223);
  float _231 = log2(_226);
  float _232 = log2(_229);
  float _233 = _230 * 0.04211956635117531f;
  float _234 = _231 * 0.04211956635117531f;
  float _235 = _232 * 0.04211956635117531f;
  float _236 = _233 + 0.6252607107162476f;
  float _237 = _234 + 0.6252607107162476f;
  float _238 = _235 + 0.6252607107162476f;
  float4 _239 = t5.SampleLevel(s2_space2, float3(_236, _237, _238), 0.0f);
  bool _245 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_245 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _249 = cb2_017x * _239.x;
    float _250 = cb2_017x * _239.y;
    float _251 = cb2_017x * _239.z;
    float _253 = _249 + cb2_017y;
    float _254 = _250 + cb2_017y;
    float _255 = _251 + cb2_017y;
    float _256 = exp2(_253);
    float _257 = exp2(_254);
    float _258 = exp2(_255);
    float _259 = _256 + 1.0f;
    float _260 = _257 + 1.0f;
    float _261 = _258 + 1.0f;
    float _262 = 1.0f / _259;
    float _263 = 1.0f / _260;
    float _264 = 1.0f / _261;
    float _266 = cb2_017z * _262;
    float _267 = cb2_017z * _263;
    float _268 = cb2_017z * _264;
    float _270 = _266 + cb2_017w;
    float _271 = _267 + cb2_017w;
    float _272 = _268 + cb2_017w;
    _274 = _270;
    _275 = _271;
    _276 = _272;
  } else {
    _274 = _239.x;
    _275 = _239.y;
    _276 = _239.z;
  }
  float _277 = _274 * 23.0f;
  float _278 = _277 + -14.473931312561035f;
  float _279 = exp2(_278);
  float _280 = _275 * 23.0f;
  float _281 = _280 + -14.473931312561035f;
  float _282 = exp2(_281);
  float _283 = _276 * 23.0f;
  float _284 = _283 + -14.473931312561035f;
  float _285 = exp2(_284);
  float _289 = cb2_004x * TEXCOORD0_centroid.x;
  float _290 = cb2_004y * TEXCOORD0_centroid.y;
  float _293 = _289 + cb2_004z;
  float _294 = _290 + cb2_004w;
  float4 _300 = t6.Sample(s2_space2, float2(_293, _294));
  float _305 = _300.x * cb2_003x;
  float _306 = _300.y * cb2_003y;
  float _307 = _300.z * cb2_003z;
  float _308 = _300.w * cb2_003w;
  float _311 = _308 + cb2_026y;
  float _312 = saturate(_311);
  bool _315 = ((uint)(cb2_069y) == 0);
  if (!_315) {
    float _317 = _305 * _209;
    float _318 = _306 * _209;
    float _319 = _307 * _209;
    _321 = _317;
    _322 = _318;
    _323 = _319;
  } else {
    _321 = _305;
    _322 = _306;
    _323 = _307;
  }
  bool _326 = ((uint)(cb2_028x) == 2);
  bool _327 = ((uint)(cb2_028x) == 3);
  int _328 = (uint)(cb2_028x) & -2;
  bool _329 = (_328 == 2);
  bool _330 = ((uint)(cb2_028x) == 6);
  bool _331 = _329 || _330;
  if (_331) {
    float _333 = _321 * _312;
    float _334 = _322 * _312;
    float _335 = _323 * _312;
    float _336 = _312 * _312;
    _368 = _333;
    _369 = _334;
    _370 = _335;
    _371 = _336;
  } else {
    bool _338 = ((uint)(cb2_028x) == 4);
    if (_338) {
      float _340 = _321 + -1.0f;
      float _341 = _322 + -1.0f;
      float _342 = _323 + -1.0f;
      float _343 = _312 + -1.0f;
      float _344 = _340 * _312;
      float _345 = _341 * _312;
      float _346 = _342 * _312;
      float _347 = _343 * _312;
      float _348 = _344 + 1.0f;
      float _349 = _345 + 1.0f;
      float _350 = _346 + 1.0f;
      float _351 = _347 + 1.0f;
      _368 = _348;
      _369 = _349;
      _370 = _350;
      _371 = _351;
    } else {
      bool _353 = ((uint)(cb2_028x) == 5);
      if (_353) {
        float _355 = _321 + -0.5f;
        float _356 = _322 + -0.5f;
        float _357 = _323 + -0.5f;
        float _358 = _312 + -0.5f;
        float _359 = _355 * _312;
        float _360 = _356 * _312;
        float _361 = _357 * _312;
        float _362 = _358 * _312;
        float _363 = _359 + 0.5f;
        float _364 = _360 + 0.5f;
        float _365 = _361 + 0.5f;
        float _366 = _362 + 0.5f;
        _368 = _363;
        _369 = _364;
        _370 = _365;
        _371 = _366;
      } else {
        _368 = _321;
        _369 = _322;
        _370 = _323;
        _371 = _312;
      }
    }
  }
  if (_326) {
    float _373 = _368 + _279;
    float _374 = _369 + _282;
    float _375 = _370 + _285;
    _418 = _373;
    _419 = _374;
    _420 = _375;
  } else {
    if (_327) {
      float _378 = 1.0f - _368;
      float _379 = 1.0f - _369;
      float _380 = 1.0f - _370;
      float _381 = _378 * _279;
      float _382 = _379 * _282;
      float _383 = _380 * _285;
      float _384 = _381 + _368;
      float _385 = _382 + _369;
      float _386 = _383 + _370;
      _418 = _384;
      _419 = _385;
      _420 = _386;
    } else {
      bool _388 = ((uint)(cb2_028x) == 4);
      if (_388) {
        float _390 = _368 * _279;
        float _391 = _369 * _282;
        float _392 = _370 * _285;
        _418 = _390;
        _419 = _391;
        _420 = _392;
      } else {
        bool _394 = ((uint)(cb2_028x) == 5);
        if (_394) {
          float _396 = _279 * 2.0f;
          float _397 = _396 * _368;
          float _398 = _282 * 2.0f;
          float _399 = _398 * _369;
          float _400 = _285 * 2.0f;
          float _401 = _400 * _370;
          _418 = _397;
          _419 = _399;
          _420 = _401;
        } else {
          if (_330) {
            float _404 = _279 - _368;
            float _405 = _282 - _369;
            float _406 = _285 - _370;
            _418 = _404;
            _419 = _405;
            _420 = _406;
          } else {
            float _408 = _368 - _279;
            float _409 = _369 - _282;
            float _410 = _370 - _285;
            float _411 = _371 * _408;
            float _412 = _371 * _409;
            float _413 = _371 * _410;
            float _414 = _411 + _279;
            float _415 = _412 + _282;
            float _416 = _413 + _285;
            _418 = _414;
            _419 = _415;
            _420 = _416;
          }
        }
      }
    }
  }
  float _426 = cb2_016x - _418;
  float _427 = cb2_016y - _419;
  float _428 = cb2_016z - _420;
  float _429 = _426 * cb2_016w;
  float _430 = _427 * cb2_016w;
  float _431 = _428 * cb2_016w;
  float _432 = _429 + _418;
  float _433 = _430 + _419;
  float _434 = _431 + _420;
  bool _437 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_437 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _441 = cb2_024x * _432;
    float _442 = cb2_024x * _433;
    float _443 = cb2_024x * _434;
    _445 = _441;
    _446 = _442;
    _447 = _443;
  } else {
    _445 = _432;
    _446 = _433;
    _447 = _434;
  }
  float _448 = _445 * 0.9708889722824097f;
  float _449 = mad(0.026962999254465103f, _446, _448);
  float _450 = mad(0.002148000057786703f, _447, _449);
  float _451 = _445 * 0.01088900025933981f;
  float _452 = mad(0.9869629740715027f, _446, _451);
  float _453 = mad(0.002148000057786703f, _447, _452);
  float _454 = mad(0.026962999254465103f, _446, _451);
  float _455 = mad(0.9621480107307434f, _447, _454);
  if (_437) {
    if (RENODX_TONE_MAP_TYPE == 0.f) {
        float _460 = cb1_018y * 0.10000000149011612f;
        float _461 = log2(cb1_018z);
        float _462 = _461 + -13.287712097167969f;
        float _463 = _462 * 1.4929734468460083f;
        float _464 = _463 + 18.0f;
        float _465 = exp2(_464);
        float _466 = _465 * 0.18000000715255737f;
        float _467 = abs(_466);
        float _468 = log2(_467);
        float _469 = _468 * 1.5f;
        float _470 = exp2(_469);
        float _471 = _470 * _460;
        float _472 = _471 / cb1_018z;
        float _473 = _472 + -0.07636754959821701f;
        float _474 = _468 * 1.2750000953674316f;
        float _475 = exp2(_474);
        float _476 = _475 * 0.07636754959821701f;
        float _477 = cb1_018y * 0.011232397519052029f;
        float _478 = _477 * _470;
        float _479 = _478 / cb1_018z;
        float _480 = _476 - _479;
        float _481 = _475 + -0.11232396960258484f;
        float _482 = _481 * _460;
        float _483 = _482 / cb1_018z;
        float _484 = _483 * cb1_018z;
        float _485 = abs(_450);
        float _486 = abs(_453);
        float _487 = abs(_455);
        float _488 = log2(_485);
        float _489 = log2(_486);
        float _490 = log2(_487);
        float _491 = _488 * 1.5f;
        float _492 = _489 * 1.5f;
        float _493 = _490 * 1.5f;
        float _494 = exp2(_491);
        float _495 = exp2(_492);
        float _496 = exp2(_493);
        float _497 = _494 * _484;
        float _498 = _495 * _484;
        float _499 = _496 * _484;
        float _500 = _488 * 1.2750000953674316f;
        float _501 = _489 * 1.2750000953674316f;
        float _502 = _490 * 1.2750000953674316f;
        float _503 = exp2(_500);
        float _504 = exp2(_501);
        float _505 = exp2(_502);
        float _506 = _503 * _473;
        float _507 = _504 * _473;
        float _508 = _505 * _473;
        float _509 = _506 + _480;
        float _510 = _507 + _480;
        float _511 = _508 + _480;
        float _512 = _497 / _509;
        float _513 = _498 / _510;
        float _514 = _499 / _511;
        float _515 = _512 * 9.999999747378752e-05f;
        float _516 = _513 * 9.999999747378752e-05f;
        float _517 = _514 * 9.999999747378752e-05f;
        float _518 = 5000.0f / cb1_018y;
        float _519 = _515 * _518;
        float _520 = _516 * _518;
        float _521 = _517 * _518;
        _548 = _519;
        _549 = _520;
        _550 = _521;
    } else {
      float3 tonemapped = ApplyCustomToneMap(float3(_450, _453, _455));
      _548 = tonemapped.x, _549 = tonemapped.y, _550 = tonemapped.z;
    }
      } else {
        float _523 = _450 + 0.020616600289940834f;
        float _524 = _453 + 0.020616600289940834f;
        float _525 = _455 + 0.020616600289940834f;
        float _526 = _523 * _450;
        float _527 = _524 * _453;
        float _528 = _525 * _455;
        float _529 = _526 + -7.456949970219284e-05f;
        float _530 = _527 + -7.456949970219284e-05f;
        float _531 = _528 + -7.456949970219284e-05f;
        float _532 = _450 * 0.9837960004806519f;
        float _533 = _453 * 0.9837960004806519f;
        float _534 = _455 * 0.9837960004806519f;
        float _535 = _532 + 0.4336790144443512f;
        float _536 = _533 + 0.4336790144443512f;
        float _537 = _534 + 0.4336790144443512f;
        float _538 = _535 * _450;
        float _539 = _536 * _453;
        float _540 = _537 * _455;
        float _541 = _538 + 0.24617899954319f;
        float _542 = _539 + 0.24617899954319f;
        float _543 = _540 + 0.24617899954319f;
        float _544 = _529 / _541;
        float _545 = _530 / _542;
        float _546 = _531 / _543;
        _548 = _544;
        _549 = _545;
        _550 = _546;
      }
      float _551 = _548 * 1.6047500371932983f;
      float _552 = mad(-0.5310800075531006f, _549, _551);
      float _553 = mad(-0.07366999983787537f, _550, _552);
      float _554 = _548 * -0.10208000242710114f;
      float _555 = mad(1.1081299781799316f, _549, _554);
      float _556 = mad(-0.006049999967217445f, _550, _555);
      float _557 = _548 * -0.0032599999103695154f;
      float _558 = mad(-0.07275000214576721f, _549, _557);
      float _559 = mad(1.0760200023651123f, _550, _558);
      if (_437) {
        // float _561 = max(_553, 0.0f);
        // float _562 = max(_556, 0.0f);
        // float _563 = max(_559, 0.0f);
        // bool _564 = !(_561 >= 0.0030399328097701073f);
        // if (!_564) {
        //   float _566 = abs(_561);
        //   float _567 = log2(_566);
        //   float _568 = _567 * 0.4166666567325592f;
        //   float _569 = exp2(_568);
        //   float _570 = _569 * 1.0549999475479126f;
        //   float _571 = _570 + -0.054999999701976776f;
        //   _575 = _571;
        // } else {
        //   float _573 = _561 * 12.923210144042969f;
        //   _575 = _573;
        // }
        // bool _576 = !(_562 >= 0.0030399328097701073f);
        // if (!_576) {
        //   float _578 = abs(_562);
        //   float _579 = log2(_578);
        //   float _580 = _579 * 0.4166666567325592f;
        //   float _581 = exp2(_580);
        //   float _582 = _581 * 1.0549999475479126f;
        //   float _583 = _582 + -0.054999999701976776f;
        //   _587 = _583;
        // } else {
        //   float _585 = _562 * 12.923210144042969f;
        //   _587 = _585;
        // }
        // bool _588 = !(_563 >= 0.0030399328097701073f);
        // if (!_588) {
        //   float _590 = abs(_563);
        //   float _591 = log2(_590);
        //   float _592 = _591 * 0.4166666567325592f;
        //   float _593 = exp2(_592);
        //   float _594 = _593 * 1.0549999475479126f;
        //   float _595 = _594 + -0.054999999701976776f;
        //   _668 = _575;
        //   _669 = _587;
        //   _670 = _595;
        // } else {
        //   float _597 = _563 * 12.923210144042969f;
        //   _668 = _575;
        //   _669 = _587;
        //   _670 = _597;
        // }
        _668 = renodx::color::srgb::EncodeSafe(_553);
        _669 = renodx::color::srgb::EncodeSafe(_556);
        _670 = renodx::color::srgb::EncodeSafe(_559);

      } else {
        float _599 = saturate(_553);
        float _600 = saturate(_556);
        float _601 = saturate(_559);
        bool _602 = ((uint)(cb1_018w) == -2);
        if (!_602) {
          bool _604 = !(_599 >= 0.0030399328097701073f);
          if (!_604) {
            float _606 = abs(_599);
            float _607 = log2(_606);
            float _608 = _607 * 0.4166666567325592f;
            float _609 = exp2(_608);
            float _610 = _609 * 1.0549999475479126f;
            float _611 = _610 + -0.054999999701976776f;
            _615 = _611;
          } else {
            float _613 = _599 * 12.923210144042969f;
            _615 = _613;
          }
          bool _616 = !(_600 >= 0.0030399328097701073f);
          if (!_616) {
            float _618 = abs(_600);
            float _619 = log2(_618);
            float _620 = _619 * 0.4166666567325592f;
            float _621 = exp2(_620);
            float _622 = _621 * 1.0549999475479126f;
            float _623 = _622 + -0.054999999701976776f;
            _627 = _623;
          } else {
            float _625 = _600 * 12.923210144042969f;
            _627 = _625;
          }
          bool _628 = !(_601 >= 0.0030399328097701073f);
          if (!_628) {
            float _630 = abs(_601);
            float _631 = log2(_630);
            float _632 = _631 * 0.4166666567325592f;
            float _633 = exp2(_632);
            float _634 = _633 * 1.0549999475479126f;
            float _635 = _634 + -0.054999999701976776f;
            _639 = _615;
            _640 = _627;
            _641 = _635;
          } else {
            float _637 = _601 * 12.923210144042969f;
            _639 = _615;
            _640 = _627;
            _641 = _637;
          }
        } else {
          _639 = _599;
          _640 = _600;
          _641 = _601;
        }
        float _646 = abs(_639);
        float _647 = abs(_640);
        float _648 = abs(_641);
        float _649 = log2(_646);
        float _650 = log2(_647);
        float _651 = log2(_648);
        float _652 = _649 * cb2_000z;
        float _653 = _650 * cb2_000z;
        float _654 = _651 * cb2_000z;
        float _655 = exp2(_652);
        float _656 = exp2(_653);
        float _657 = exp2(_654);
        float _658 = _655 * cb2_000y;
        float _659 = _656 * cb2_000y;
        float _660 = _657 * cb2_000y;
        float _661 = _658 + cb2_000x;
        float _662 = _659 + cb2_000x;
        float _663 = _660 + cb2_000x;
        float _664 = saturate(_661);
        float _665 = saturate(_662);
        float _666 = saturate(_663);
        _668 = _664;
        _669 = _665;
        _670 = _666;
      }
      float _671 = dot(float3(_668, _669, _670), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
      SV_Target.x = _668;
      SV_Target.y = _669;
      SV_Target.z = _670;
      SV_Target.w = _671;
      SV_Target_1.x = _671;
      SV_Target_1.y = 0.0f;
      SV_Target_1.z = 0.0f;
      SV_Target_1.w = 0.0f;
      OutputSignature output_signature = { SV_Target, SV_Target_1 };
      return output_signature;
}
