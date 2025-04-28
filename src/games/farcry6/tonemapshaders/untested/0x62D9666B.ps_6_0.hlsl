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
  float _597;
  float _634;
  float _635;
  float _636;
  float _665;
  float _666;
  float _667;
  float _748;
  float _749;
  float _750;
  float _756;
  float _757;
  float _758;
  float _772;
  float _773;
  float _774;
  float _799;
  float _811;
  float _839;
  float _851;
  float _863;
  float _864;
  float _865;
  float _892;
  float _893;
  float _894;
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
  float _450 = _445 * 0.9708889722824097f;
  float _451 = mad(0.026962999254465103f, _446, _450);
  float _452 = mad(0.002148000057786703f, _447, _451);
  float _453 = _445 * 0.01088900025933981f;
  float _454 = mad(0.9869629740715027f, _446, _453);
  float _455 = mad(0.002148000057786703f, _447, _454);
  float _456 = mad(0.026962999254465103f, _446, _453);
  float _457 = mad(0.9621480107307434f, _447, _456);
  float _458 = max(_452, 0.0f);
  float _459 = max(_455, 0.0f);
  float _460 = max(_457, 0.0f);
  float _461 = min(_458, cb2_095y);
  float _462 = min(_459, cb2_095y);
  float _463 = min(_460, cb2_095y);
  bool _466 = ((uint)(cb2_095x) == 0);
  bool _469 = ((uint)(cb2_094w) == 0);
  bool _471 = ((uint)(cb2_094z) == 0);
  bool _473 = ((uint)(cb2_094y) != 0);
  bool _475 = ((uint)(cb2_094x) == 0);
  bool _477 = ((uint)(cb2_069z) != 0);
  float _524 = asfloat((uint)(cb2_075y));
  float _525 = asfloat((uint)(cb2_075z));
  float _526 = asfloat((uint)(cb2_075w));
  float _527 = asfloat((uint)(cb2_074z));
  float _528 = asfloat((uint)(cb2_074w));
  float _529 = asfloat((uint)(cb2_075x));
  float _530 = asfloat((uint)(cb2_073w));
  float _531 = asfloat((uint)(cb2_074x));
  float _532 = asfloat((uint)(cb2_074y));
  float _533 = asfloat((uint)(cb2_077x));
  float _534 = asfloat((uint)(cb2_077y));
  float _535 = asfloat((uint)(cb2_079x));
  float _536 = asfloat((uint)(cb2_079y));
  float _537 = asfloat((uint)(cb2_079z));
  float _538 = asfloat((uint)(cb2_078y));
  float _539 = asfloat((uint)(cb2_078z));
  float _540 = asfloat((uint)(cb2_078w));
  float _541 = asfloat((uint)(cb2_077z));
  float _542 = asfloat((uint)(cb2_077w));
  float _543 = asfloat((uint)(cb2_078x));
  float _544 = asfloat((uint)(cb2_072y));
  float _545 = asfloat((uint)(cb2_072z));
  float _546 = asfloat((uint)(cb2_072w));
  float _547 = asfloat((uint)(cb2_071x));
  float _548 = asfloat((uint)(cb2_071y));
  float _549 = asfloat((uint)(cb2_076x));
  float _550 = asfloat((uint)(cb2_070w));
  float _551 = asfloat((uint)(cb2_070x));
  float _552 = asfloat((uint)(cb2_070y));
  float _553 = asfloat((uint)(cb2_070z));
  float _554 = asfloat((uint)(cb2_073x));
  float _555 = asfloat((uint)(cb2_073y));
  float _556 = asfloat((uint)(cb2_073z));
  float _557 = asfloat((uint)(cb2_071z));
  float _558 = asfloat((uint)(cb2_071w));
  float _559 = asfloat((uint)(cb2_072x));
  float _560 = max(_462, _463);
  float _561 = max(_461, _560);
  float _562 = 1.0f / _561;
  float _563 = _562 * _461;
  float _564 = _562 * _462;
  float _565 = _562 * _463;
  float _566 = abs(_563);
  float _567 = log2(_566);
  float _568 = _567 * _551;
  float _569 = exp2(_568);
  float _570 = abs(_564);
  float _571 = log2(_570);
  float _572 = _571 * _552;
  float _573 = exp2(_572);
  float _574 = abs(_565);
  float _575 = log2(_574);
  float _576 = _575 * _553;
  float _577 = exp2(_576);
  if (_473) {
    float _580 = asfloat((uint)(cb2_076w));
    float _582 = asfloat((uint)(cb2_076z));
    float _584 = asfloat((uint)(cb2_076y));
    float _585 = _582 * _462;
    float _586 = _584 * _461;
    float _587 = _580 * _463;
    float _588 = _586 + _587;
    float _589 = _588 + _585;
    _597 = _589;
  } else {
    float _591 = _558 * _462;
    float _592 = _557 * _461;
    float _593 = _559 * _463;
    float _594 = _591 + _592;
    float _595 = _594 + _593;
    _597 = _595;
  }
  float _598 = abs(_597);
  float _599 = log2(_598);
  float _600 = _599 * _550;
  float _601 = exp2(_600);
  float _602 = log2(_601);
  float _603 = _602 * _549;
  float _604 = exp2(_603);
  float _605 = select(_477, _604, _601);
  float _606 = _605 * _547;
  float _607 = _606 + _548;
  float _608 = 1.0f / _607;
  float _609 = _608 * _601;
  if (_473) {
    if (!_475) {
      float _612 = _569 * _541;
      float _613 = _573 * _542;
      float _614 = _577 * _543;
      float _615 = _613 + _612;
      float _616 = _615 + _614;
      float _617 = _573 * _539;
      float _618 = _569 * _538;
      float _619 = _577 * _540;
      float _620 = _617 + _618;
      float _621 = _620 + _619;
      float _622 = _577 * _537;
      float _623 = _573 * _536;
      float _624 = _569 * _535;
      float _625 = _623 + _624;
      float _626 = _625 + _622;
      float _627 = max(_621, _626);
      float _628 = max(_616, _627);
      float _629 = 1.0f / _628;
      float _630 = _629 * _616;
      float _631 = _629 * _621;
      float _632 = _629 * _626;
      _634 = _630;
      _635 = _631;
      _636 = _632;
    } else {
      _634 = _569;
      _635 = _573;
      _636 = _577;
    }
    float _637 = _634 * _534;
    float _638 = exp2(_637);
    float _639 = _638 * _533;
    float _640 = saturate(_639);
    float _641 = _634 * _533;
    float _642 = _634 - _641;
    float _643 = saturate(_642);
    float _644 = max(_533, _643);
    float _645 = min(_644, _640);
    float _646 = _635 * _534;
    float _647 = exp2(_646);
    float _648 = _647 * _533;
    float _649 = saturate(_648);
    float _650 = _635 * _533;
    float _651 = _635 - _650;
    float _652 = saturate(_651);
    float _653 = max(_533, _652);
    float _654 = min(_653, _649);
    float _655 = _636 * _534;
    float _656 = exp2(_655);
    float _657 = _656 * _533;
    float _658 = saturate(_657);
    float _659 = _636 * _533;
    float _660 = _636 - _659;
    float _661 = saturate(_660);
    float _662 = max(_533, _661);
    float _663 = min(_662, _658);
    _665 = _645;
    _666 = _654;
    _667 = _663;
  } else {
    _665 = _569;
    _666 = _573;
    _667 = _577;
  }
  float _668 = _665 * _557;
  float _669 = _666 * _558;
  float _670 = _669 + _668;
  float _671 = _667 * _559;
  float _672 = _670 + _671;
  float _673 = 1.0f / _672;
  float _674 = _673 * _609;
  float _675 = saturate(_674);
  float _676 = _675 * _665;
  float _677 = saturate(_676);
  float _678 = _675 * _666;
  float _679 = saturate(_678);
  float _680 = _675 * _667;
  float _681 = saturate(_680);
  float _682 = _677 * _544;
  float _683 = _544 - _682;
  float _684 = _679 * _545;
  float _685 = _545 - _684;
  float _686 = _681 * _546;
  float _687 = _546 - _686;
  float _688 = _681 * _559;
  float _689 = _677 * _557;
  float _690 = _679 * _558;
  float _691 = _609 - _689;
  float _692 = _691 - _690;
  float _693 = _692 - _688;
  float _694 = saturate(_693);
  float _695 = _685 * _558;
  float _696 = _683 * _557;
  float _697 = _687 * _559;
  float _698 = _695 + _696;
  float _699 = _698 + _697;
  float _700 = 1.0f / _699;
  float _701 = _700 * _694;
  float _702 = _701 * _683;
  float _703 = _702 + _677;
  float _704 = saturate(_703);
  float _705 = _701 * _685;
  float _706 = _705 + _679;
  float _707 = saturate(_706);
  float _708 = _701 * _687;
  float _709 = _708 + _681;
  float _710 = saturate(_709);
  float _711 = _710 * _559;
  float _712 = _704 * _557;
  float _713 = _707 * _558;
  float _714 = _609 - _712;
  float _715 = _714 - _713;
  float _716 = _715 - _711;
  float _717 = saturate(_716);
  float _718 = _717 * _554;
  float _719 = _718 + _704;
  float _720 = saturate(_719);
  float _721 = _717 * _555;
  float _722 = _721 + _707;
  float _723 = saturate(_722);
  float _724 = _717 * _556;
  float _725 = _724 + _710;
  float _726 = saturate(_725);
  if (!_471) {
    float _728 = _720 * _530;
    float _729 = _723 * _531;
    float _730 = _726 * _532;
    float _731 = _729 + _728;
    float _732 = _731 + _730;
    float _733 = _723 * _528;
    float _734 = _720 * _527;
    float _735 = _726 * _529;
    float _736 = _733 + _734;
    float _737 = _736 + _735;
    float _738 = _726 * _526;
    float _739 = _723 * _525;
    float _740 = _720 * _524;
    float _741 = _739 + _740;
    float _742 = _741 + _738;
    if (!_469) {
      float _744 = saturate(_732);
      float _745 = saturate(_737);
      float _746 = saturate(_742);
      _748 = _746;
      _749 = _745;
      _750 = _744;
    } else {
      _748 = _742;
      _749 = _737;
      _750 = _732;
    }
  } else {
    _748 = _726;
    _749 = _723;
    _750 = _720;
  }
  if (!_466) {
    float _752 = _750 * _530;
    float _753 = _749 * _530;
    float _754 = _748 * _530;
    _756 = _754;
    _757 = _753;
    _758 = _752;
  } else {
    _756 = _748;
    _757 = _749;
    _758 = _750;
  }
  if (_437) {
    float _762 = cb1_018z * 9.999999747378752e-05f;
    float _763 = _762 * _758;
    float _764 = _762 * _757;
    float _765 = _762 * _756;
    float _767 = 5000.0f / cb1_018y;
    float _768 = _763 * _767;
    float _769 = _764 * _767;
    float _770 = _765 * _767;
    _772 = _768;
    _773 = _769;
    _774 = _770;
  } else {
    _772 = _758;
    _773 = _757;
    _774 = _756;
  }
  float _775 = _772 * 1.6047500371932983f;
  float _776 = mad(-0.5310800075531006f, _773, _775);
  float _777 = mad(-0.07366999983787537f, _774, _776);
  float _778 = _772 * -0.10208000242710114f;
  float _779 = mad(1.1081299781799316f, _773, _778);
  float _780 = mad(-0.006049999967217445f, _774, _779);
  float _781 = _772 * -0.0032599999103695154f;
  float _782 = mad(-0.07275000214576721f, _773, _781);
  float _783 = mad(1.0760200023651123f, _774, _782);
  if (_437) {
    // float _785 = max(_777, 0.0f);
    // float _786 = max(_780, 0.0f);
    // float _787 = max(_783, 0.0f);
    // bool _788 = !(_785 >= 0.0030399328097701073f);
    // if (!_788) {
    //   float _790 = abs(_785);
    //   float _791 = log2(_790);
    //   float _792 = _791 * 0.4166666567325592f;
    //   float _793 = exp2(_792);
    //   float _794 = _793 * 1.0549999475479126f;
    //   float _795 = _794 + -0.054999999701976776f;
    //   _799 = _795;
    // } else {
    //   float _797 = _785 * 12.923210144042969f;
    //   _799 = _797;
    // }
    // bool _800 = !(_786 >= 0.0030399328097701073f);
    // if (!_800) {
    //   float _802 = abs(_786);
    //   float _803 = log2(_802);
    //   float _804 = _803 * 0.4166666567325592f;
    //   float _805 = exp2(_804);
    //   float _806 = _805 * 1.0549999475479126f;
    //   float _807 = _806 + -0.054999999701976776f;
    //   _811 = _807;
    // } else {
    //   float _809 = _786 * 12.923210144042969f;
    //   _811 = _809;
    // }
    // bool _812 = !(_787 >= 0.0030399328097701073f);
    // if (!_812) {
    //   float _814 = abs(_787);
    //   float _815 = log2(_814);
    //   float _816 = _815 * 0.4166666567325592f;
    //   float _817 = exp2(_816);
    //   float _818 = _817 * 1.0549999475479126f;
    //   float _819 = _818 + -0.054999999701976776f;
    //   _892 = _799;
    //   _893 = _811;
    //   _894 = _819;
    // } else {
    //   float _821 = _787 * 12.923210144042969f;
    //   _892 = _799;
    //   _893 = _811;
    //   _894 = _821;
    // }
    _892 = renodx::color::srgb::EncodeSafe(_777);
    _893 = renodx::color::srgb::EncodeSafe(_780);
    _894 = renodx::color::srgb::EncodeSafe(_783);

  } else {
    float _823 = saturate(_777);
    float _824 = saturate(_780);
    float _825 = saturate(_783);
    bool _826 = ((uint)(cb1_018w) == -2);
    if (!_826) {
      bool _828 = !(_823 >= 0.0030399328097701073f);
      if (!_828) {
        float _830 = abs(_823);
        float _831 = log2(_830);
        float _832 = _831 * 0.4166666567325592f;
        float _833 = exp2(_832);
        float _834 = _833 * 1.0549999475479126f;
        float _835 = _834 + -0.054999999701976776f;
        _839 = _835;
      } else {
        float _837 = _823 * 12.923210144042969f;
        _839 = _837;
      }
      bool _840 = !(_824 >= 0.0030399328097701073f);
      if (!_840) {
        float _842 = abs(_824);
        float _843 = log2(_842);
        float _844 = _843 * 0.4166666567325592f;
        float _845 = exp2(_844);
        float _846 = _845 * 1.0549999475479126f;
        float _847 = _846 + -0.054999999701976776f;
        _851 = _847;
      } else {
        float _849 = _824 * 12.923210144042969f;
        _851 = _849;
      }
      bool _852 = !(_825 >= 0.0030399328097701073f);
      if (!_852) {
        float _854 = abs(_825);
        float _855 = log2(_854);
        float _856 = _855 * 0.4166666567325592f;
        float _857 = exp2(_856);
        float _858 = _857 * 1.0549999475479126f;
        float _859 = _858 + -0.054999999701976776f;
        _863 = _839;
        _864 = _851;
        _865 = _859;
      } else {
        float _861 = _825 * 12.923210144042969f;
        _863 = _839;
        _864 = _851;
        _865 = _861;
      }
    } else {
      _863 = _823;
      _864 = _824;
      _865 = _825;
    }
    float _870 = abs(_863);
    float _871 = abs(_864);
    float _872 = abs(_865);
    float _873 = log2(_870);
    float _874 = log2(_871);
    float _875 = log2(_872);
    float _876 = _873 * cb2_000z;
    float _877 = _874 * cb2_000z;
    float _878 = _875 * cb2_000z;
    float _879 = exp2(_876);
    float _880 = exp2(_877);
    float _881 = exp2(_878);
    float _882 = _879 * cb2_000y;
    float _883 = _880 * cb2_000y;
    float _884 = _881 * cb2_000y;
    float _885 = _882 + cb2_000x;
    float _886 = _883 + cb2_000x;
    float _887 = _884 + cb2_000x;
    float _888 = saturate(_885);
    float _889 = saturate(_886);
    float _890 = saturate(_887);
    _892 = _888;
    _893 = _889;
    _894 = _890;
  }
  float _895 = dot(float3(_892, _893, _894), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _892;
  SV_Target.y = _893;
  SV_Target.z = _894;
  SV_Target.w = _895;
  SV_Target_1.x = _895;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
