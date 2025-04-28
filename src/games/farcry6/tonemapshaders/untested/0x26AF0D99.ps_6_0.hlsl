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
  float cb2_001x : packoffset(c001.x);
  float cb2_001y : packoffset(c001.y);
  float cb2_001z : packoffset(c001.z);
  float cb2_002x : packoffset(c002.x);
  float cb2_002y : packoffset(c002.y);
  float cb2_002z : packoffset(c002.z);
  float cb2_002w : packoffset(c002.w);
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
  float _366;
  float _367;
  float _368;
  float _413;
  float _414;
  float _415;
  float _416;
  float _463;
  float _464;
  float _465;
  float _490;
  float _491;
  float _492;
  float _642;
  float _679;
  float _680;
  float _681;
  float _710;
  float _711;
  float _712;
  float _793;
  float _794;
  float _795;
  float _801;
  float _802;
  float _803;
  float _817;
  float _818;
  float _819;
  float _844;
  float _856;
  float _884;
  float _896;
  float _908;
  float _909;
  float _910;
  float _937;
  float _938;
  float _939;
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
  float _286 = dot(float3(_279, _282, _285), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _291 = dot(float3(_279, _282, _285), float3(_279, _282, _285));
  float _292 = rsqrt(_291);
  float _293 = _292 * _279;
  float _294 = _292 * _282;
  float _295 = _292 * _285;
  float _296 = cb2_001x - _293;
  float _297 = cb2_001y - _294;
  float _298 = cb2_001z - _295;
  float _299 = dot(float3(_296, _297, _298), float3(_296, _297, _298));
  float _302 = cb2_002z * _299;
  float _304 = _302 + cb2_002w;
  float _305 = saturate(_304);
  float _307 = cb2_002x * _305;
  float _308 = _286 - _279;
  float _309 = _286 - _282;
  float _310 = _286 - _285;
  float _311 = _307 * _308;
  float _312 = _307 * _309;
  float _313 = _307 * _310;
  float _314 = _311 + _279;
  float _315 = _312 + _282;
  float _316 = _313 + _285;
  float _318 = cb2_002y * _305;
  float _319 = 0.10000000149011612f - _314;
  float _320 = 0.10000000149011612f - _315;
  float _321 = 0.10000000149011612f - _316;
  float _322 = _319 * _318;
  float _323 = _320 * _318;
  float _324 = _321 * _318;
  float _325 = _322 + _314;
  float _326 = _323 + _315;
  float _327 = _324 + _316;
  float _328 = saturate(_325);
  float _329 = saturate(_326);
  float _330 = saturate(_327);
  float _334 = cb2_004x * TEXCOORD0_centroid.x;
  float _335 = cb2_004y * TEXCOORD0_centroid.y;
  float _338 = _334 + cb2_004z;
  float _339 = _335 + cb2_004w;
  float4 _345 = t6.Sample(s2_space2, float2(_338, _339));
  float _350 = _345.x * cb2_003x;
  float _351 = _345.y * cb2_003y;
  float _352 = _345.z * cb2_003z;
  float _353 = _345.w * cb2_003w;
  float _356 = _353 + cb2_026y;
  float _357 = saturate(_356);
  bool _360 = ((uint)(cb2_069y) == 0);
  if (!_360) {
    float _362 = _350 * _209;
    float _363 = _351 * _209;
    float _364 = _352 * _209;
    _366 = _362;
    _367 = _363;
    _368 = _364;
  } else {
    _366 = _350;
    _367 = _351;
    _368 = _352;
  }
  bool _371 = ((uint)(cb2_028x) == 2);
  bool _372 = ((uint)(cb2_028x) == 3);
  int _373 = (uint)(cb2_028x) & -2;
  bool _374 = (_373 == 2);
  bool _375 = ((uint)(cb2_028x) == 6);
  bool _376 = _374 || _375;
  if (_376) {
    float _378 = _366 * _357;
    float _379 = _367 * _357;
    float _380 = _368 * _357;
    float _381 = _357 * _357;
    _413 = _378;
    _414 = _379;
    _415 = _380;
    _416 = _381;
  } else {
    bool _383 = ((uint)(cb2_028x) == 4);
    if (_383) {
      float _385 = _366 + -1.0f;
      float _386 = _367 + -1.0f;
      float _387 = _368 + -1.0f;
      float _388 = _357 + -1.0f;
      float _389 = _385 * _357;
      float _390 = _386 * _357;
      float _391 = _387 * _357;
      float _392 = _388 * _357;
      float _393 = _389 + 1.0f;
      float _394 = _390 + 1.0f;
      float _395 = _391 + 1.0f;
      float _396 = _392 + 1.0f;
      _413 = _393;
      _414 = _394;
      _415 = _395;
      _416 = _396;
    } else {
      bool _398 = ((uint)(cb2_028x) == 5);
      if (_398) {
        float _400 = _366 + -0.5f;
        float _401 = _367 + -0.5f;
        float _402 = _368 + -0.5f;
        float _403 = _357 + -0.5f;
        float _404 = _400 * _357;
        float _405 = _401 * _357;
        float _406 = _402 * _357;
        float _407 = _403 * _357;
        float _408 = _404 + 0.5f;
        float _409 = _405 + 0.5f;
        float _410 = _406 + 0.5f;
        float _411 = _407 + 0.5f;
        _413 = _408;
        _414 = _409;
        _415 = _410;
        _416 = _411;
      } else {
        _413 = _366;
        _414 = _367;
        _415 = _368;
        _416 = _357;
      }
    }
  }
  if (_371) {
    float _418 = _413 + _328;
    float _419 = _414 + _329;
    float _420 = _415 + _330;
    _463 = _418;
    _464 = _419;
    _465 = _420;
  } else {
    if (_372) {
      float _423 = 1.0f - _413;
      float _424 = 1.0f - _414;
      float _425 = 1.0f - _415;
      float _426 = _423 * _328;
      float _427 = _424 * _329;
      float _428 = _425 * _330;
      float _429 = _426 + _413;
      float _430 = _427 + _414;
      float _431 = _428 + _415;
      _463 = _429;
      _464 = _430;
      _465 = _431;
    } else {
      bool _433 = ((uint)(cb2_028x) == 4);
      if (_433) {
        float _435 = _413 * _328;
        float _436 = _414 * _329;
        float _437 = _415 * _330;
        _463 = _435;
        _464 = _436;
        _465 = _437;
      } else {
        bool _439 = ((uint)(cb2_028x) == 5);
        if (_439) {
          float _441 = _328 * 2.0f;
          float _442 = _441 * _413;
          float _443 = _329 * 2.0f;
          float _444 = _443 * _414;
          float _445 = _330 * 2.0f;
          float _446 = _445 * _415;
          _463 = _442;
          _464 = _444;
          _465 = _446;
        } else {
          if (_375) {
            float _449 = _328 - _413;
            float _450 = _329 - _414;
            float _451 = _330 - _415;
            _463 = _449;
            _464 = _450;
            _465 = _451;
          } else {
            float _453 = _413 - _328;
            float _454 = _414 - _329;
            float _455 = _415 - _330;
            float _456 = _416 * _453;
            float _457 = _416 * _454;
            float _458 = _416 * _455;
            float _459 = _456 + _328;
            float _460 = _457 + _329;
            float _461 = _458 + _330;
            _463 = _459;
            _464 = _460;
            _465 = _461;
          }
        }
      }
    }
  }
  float _471 = cb2_016x - _463;
  float _472 = cb2_016y - _464;
  float _473 = cb2_016z - _465;
  float _474 = _471 * cb2_016w;
  float _475 = _472 * cb2_016w;
  float _476 = _473 * cb2_016w;
  float _477 = _474 + _463;
  float _478 = _475 + _464;
  float _479 = _476 + _465;
  bool _482 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_482 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _486 = cb2_024x * _477;
    float _487 = cb2_024x * _478;
    float _488 = cb2_024x * _479;
    _490 = _486;
    _491 = _487;
    _492 = _488;
  } else {
    _490 = _477;
    _491 = _478;
    _492 = _479;
  }
  float _495 = _490 * 0.9708889722824097f;
  float _496 = mad(0.026962999254465103f, _491, _495);
  float _497 = mad(0.002148000057786703f, _492, _496);
  float _498 = _490 * 0.01088900025933981f;
  float _499 = mad(0.9869629740715027f, _491, _498);
  float _500 = mad(0.002148000057786703f, _492, _499);
  float _501 = mad(0.026962999254465103f, _491, _498);
  float _502 = mad(0.9621480107307434f, _492, _501);
  float _503 = max(_497, 0.0f);
  float _504 = max(_500, 0.0f);
  float _505 = max(_502, 0.0f);
  float _506 = min(_503, cb2_095y);
  float _507 = min(_504, cb2_095y);
  float _508 = min(_505, cb2_095y);
  bool _511 = ((uint)(cb2_095x) == 0);
  bool _514 = ((uint)(cb2_094w) == 0);
  bool _516 = ((uint)(cb2_094z) == 0);
  bool _518 = ((uint)(cb2_094y) != 0);
  bool _520 = ((uint)(cb2_094x) == 0);
  bool _522 = ((uint)(cb2_069z) != 0);
  float _569 = asfloat((uint)(cb2_075y));
  float _570 = asfloat((uint)(cb2_075z));
  float _571 = asfloat((uint)(cb2_075w));
  float _572 = asfloat((uint)(cb2_074z));
  float _573 = asfloat((uint)(cb2_074w));
  float _574 = asfloat((uint)(cb2_075x));
  float _575 = asfloat((uint)(cb2_073w));
  float _576 = asfloat((uint)(cb2_074x));
  float _577 = asfloat((uint)(cb2_074y));
  float _578 = asfloat((uint)(cb2_077x));
  float _579 = asfloat((uint)(cb2_077y));
  float _580 = asfloat((uint)(cb2_079x));
  float _581 = asfloat((uint)(cb2_079y));
  float _582 = asfloat((uint)(cb2_079z));
  float _583 = asfloat((uint)(cb2_078y));
  float _584 = asfloat((uint)(cb2_078z));
  float _585 = asfloat((uint)(cb2_078w));
  float _586 = asfloat((uint)(cb2_077z));
  float _587 = asfloat((uint)(cb2_077w));
  float _588 = asfloat((uint)(cb2_078x));
  float _589 = asfloat((uint)(cb2_072y));
  float _590 = asfloat((uint)(cb2_072z));
  float _591 = asfloat((uint)(cb2_072w));
  float _592 = asfloat((uint)(cb2_071x));
  float _593 = asfloat((uint)(cb2_071y));
  float _594 = asfloat((uint)(cb2_076x));
  float _595 = asfloat((uint)(cb2_070w));
  float _596 = asfloat((uint)(cb2_070x));
  float _597 = asfloat((uint)(cb2_070y));
  float _598 = asfloat((uint)(cb2_070z));
  float _599 = asfloat((uint)(cb2_073x));
  float _600 = asfloat((uint)(cb2_073y));
  float _601 = asfloat((uint)(cb2_073z));
  float _602 = asfloat((uint)(cb2_071z));
  float _603 = asfloat((uint)(cb2_071w));
  float _604 = asfloat((uint)(cb2_072x));
  float _605 = max(_507, _508);
  float _606 = max(_506, _605);
  float _607 = 1.0f / _606;
  float _608 = _607 * _506;
  float _609 = _607 * _507;
  float _610 = _607 * _508;
  float _611 = abs(_608);
  float _612 = log2(_611);
  float _613 = _612 * _596;
  float _614 = exp2(_613);
  float _615 = abs(_609);
  float _616 = log2(_615);
  float _617 = _616 * _597;
  float _618 = exp2(_617);
  float _619 = abs(_610);
  float _620 = log2(_619);
  float _621 = _620 * _598;
  float _622 = exp2(_621);
  if (_518) {
    float _625 = asfloat((uint)(cb2_076w));
    float _627 = asfloat((uint)(cb2_076z));
    float _629 = asfloat((uint)(cb2_076y));
    float _630 = _627 * _507;
    float _631 = _629 * _506;
    float _632 = _625 * _508;
    float _633 = _631 + _632;
    float _634 = _633 + _630;
    _642 = _634;
  } else {
    float _636 = _603 * _507;
    float _637 = _602 * _506;
    float _638 = _604 * _508;
    float _639 = _636 + _637;
    float _640 = _639 + _638;
    _642 = _640;
  }
  float _643 = abs(_642);
  float _644 = log2(_643);
  float _645 = _644 * _595;
  float _646 = exp2(_645);
  float _647 = log2(_646);
  float _648 = _647 * _594;
  float _649 = exp2(_648);
  float _650 = select(_522, _649, _646);
  float _651 = _650 * _592;
  float _652 = _651 + _593;
  float _653 = 1.0f / _652;
  float _654 = _653 * _646;
  if (_518) {
    if (!_520) {
      float _657 = _614 * _586;
      float _658 = _618 * _587;
      float _659 = _622 * _588;
      float _660 = _658 + _657;
      float _661 = _660 + _659;
      float _662 = _618 * _584;
      float _663 = _614 * _583;
      float _664 = _622 * _585;
      float _665 = _662 + _663;
      float _666 = _665 + _664;
      float _667 = _622 * _582;
      float _668 = _618 * _581;
      float _669 = _614 * _580;
      float _670 = _668 + _669;
      float _671 = _670 + _667;
      float _672 = max(_666, _671);
      float _673 = max(_661, _672);
      float _674 = 1.0f / _673;
      float _675 = _674 * _661;
      float _676 = _674 * _666;
      float _677 = _674 * _671;
      _679 = _675;
      _680 = _676;
      _681 = _677;
    } else {
      _679 = _614;
      _680 = _618;
      _681 = _622;
    }
    float _682 = _679 * _579;
    float _683 = exp2(_682);
    float _684 = _683 * _578;
    float _685 = saturate(_684);
    float _686 = _679 * _578;
    float _687 = _679 - _686;
    float _688 = saturate(_687);
    float _689 = max(_578, _688);
    float _690 = min(_689, _685);
    float _691 = _680 * _579;
    float _692 = exp2(_691);
    float _693 = _692 * _578;
    float _694 = saturate(_693);
    float _695 = _680 * _578;
    float _696 = _680 - _695;
    float _697 = saturate(_696);
    float _698 = max(_578, _697);
    float _699 = min(_698, _694);
    float _700 = _681 * _579;
    float _701 = exp2(_700);
    float _702 = _701 * _578;
    float _703 = saturate(_702);
    float _704 = _681 * _578;
    float _705 = _681 - _704;
    float _706 = saturate(_705);
    float _707 = max(_578, _706);
    float _708 = min(_707, _703);
    _710 = _690;
    _711 = _699;
    _712 = _708;
  } else {
    _710 = _614;
    _711 = _618;
    _712 = _622;
  }
  float _713 = _710 * _602;
  float _714 = _711 * _603;
  float _715 = _714 + _713;
  float _716 = _712 * _604;
  float _717 = _715 + _716;
  float _718 = 1.0f / _717;
  float _719 = _718 * _654;
  float _720 = saturate(_719);
  float _721 = _720 * _710;
  float _722 = saturate(_721);
  float _723 = _720 * _711;
  float _724 = saturate(_723);
  float _725 = _720 * _712;
  float _726 = saturate(_725);
  float _727 = _722 * _589;
  float _728 = _589 - _727;
  float _729 = _724 * _590;
  float _730 = _590 - _729;
  float _731 = _726 * _591;
  float _732 = _591 - _731;
  float _733 = _726 * _604;
  float _734 = _722 * _602;
  float _735 = _724 * _603;
  float _736 = _654 - _734;
  float _737 = _736 - _735;
  float _738 = _737 - _733;
  float _739 = saturate(_738);
  float _740 = _730 * _603;
  float _741 = _728 * _602;
  float _742 = _732 * _604;
  float _743 = _740 + _741;
  float _744 = _743 + _742;
  float _745 = 1.0f / _744;
  float _746 = _745 * _739;
  float _747 = _746 * _728;
  float _748 = _747 + _722;
  float _749 = saturate(_748);
  float _750 = _746 * _730;
  float _751 = _750 + _724;
  float _752 = saturate(_751);
  float _753 = _746 * _732;
  float _754 = _753 + _726;
  float _755 = saturate(_754);
  float _756 = _755 * _604;
  float _757 = _749 * _602;
  float _758 = _752 * _603;
  float _759 = _654 - _757;
  float _760 = _759 - _758;
  float _761 = _760 - _756;
  float _762 = saturate(_761);
  float _763 = _762 * _599;
  float _764 = _763 + _749;
  float _765 = saturate(_764);
  float _766 = _762 * _600;
  float _767 = _766 + _752;
  float _768 = saturate(_767);
  float _769 = _762 * _601;
  float _770 = _769 + _755;
  float _771 = saturate(_770);
  if (!_516) {
    float _773 = _765 * _575;
    float _774 = _768 * _576;
    float _775 = _771 * _577;
    float _776 = _774 + _773;
    float _777 = _776 + _775;
    float _778 = _768 * _573;
    float _779 = _765 * _572;
    float _780 = _771 * _574;
    float _781 = _778 + _779;
    float _782 = _781 + _780;
    float _783 = _771 * _571;
    float _784 = _768 * _570;
    float _785 = _765 * _569;
    float _786 = _784 + _785;
    float _787 = _786 + _783;
    if (!_514) {
      float _789 = saturate(_777);
      float _790 = saturate(_782);
      float _791 = saturate(_787);
      _793 = _791;
      _794 = _790;
      _795 = _789;
    } else {
      _793 = _787;
      _794 = _782;
      _795 = _777;
    }
  } else {
    _793 = _771;
    _794 = _768;
    _795 = _765;
  }
  if (!_511) {
    float _797 = _795 * _575;
    float _798 = _794 * _575;
    float _799 = _793 * _575;
    _801 = _799;
    _802 = _798;
    _803 = _797;
  } else {
    _801 = _793;
    _802 = _794;
    _803 = _795;
  }
  if (_482) {
    float _807 = cb1_018z * 9.999999747378752e-05f;
    float _808 = _807 * _803;
    float _809 = _807 * _802;
    float _810 = _807 * _801;
    float _812 = 5000.0f / cb1_018y;
    float _813 = _808 * _812;
    float _814 = _809 * _812;
    float _815 = _810 * _812;
    _817 = _813;
    _818 = _814;
    _819 = _815;
  } else {
    _817 = _803;
    _818 = _802;
    _819 = _801;
  }
  float _820 = _817 * 1.6047500371932983f;
  float _821 = mad(-0.5310800075531006f, _818, _820);
  float _822 = mad(-0.07366999983787537f, _819, _821);
  float _823 = _817 * -0.10208000242710114f;
  float _824 = mad(1.1081299781799316f, _818, _823);
  float _825 = mad(-0.006049999967217445f, _819, _824);
  float _826 = _817 * -0.0032599999103695154f;
  float _827 = mad(-0.07275000214576721f, _818, _826);
  float _828 = mad(1.0760200023651123f, _819, _827);
  if (_482) {
    // float _830 = max(_822, 0.0f);
    // float _831 = max(_825, 0.0f);
    // float _832 = max(_828, 0.0f);
    // bool _833 = !(_830 >= 0.0030399328097701073f);
    // if (!_833) {
    //   float _835 = abs(_830);
    //   float _836 = log2(_835);
    //   float _837 = _836 * 0.4166666567325592f;
    //   float _838 = exp2(_837);
    //   float _839 = _838 * 1.0549999475479126f;
    //   float _840 = _839 + -0.054999999701976776f;
    //   _844 = _840;
    // } else {
    //   float _842 = _830 * 12.923210144042969f;
    //   _844 = _842;
    // }
    // bool _845 = !(_831 >= 0.0030399328097701073f);
    // if (!_845) {
    //   float _847 = abs(_831);
    //   float _848 = log2(_847);
    //   float _849 = _848 * 0.4166666567325592f;
    //   float _850 = exp2(_849);
    //   float _851 = _850 * 1.0549999475479126f;
    //   float _852 = _851 + -0.054999999701976776f;
    //   _856 = _852;
    // } else {
    //   float _854 = _831 * 12.923210144042969f;
    //   _856 = _854;
    // }
    // bool _857 = !(_832 >= 0.0030399328097701073f);
    // if (!_857) {
    //   float _859 = abs(_832);
    //   float _860 = log2(_859);
    //   float _861 = _860 * 0.4166666567325592f;
    //   float _862 = exp2(_861);
    //   float _863 = _862 * 1.0549999475479126f;
    //   float _864 = _863 + -0.054999999701976776f;
    //   _937 = _844;
    //   _938 = _856;
    //   _939 = _864;
    // } else {
    //   float _866 = _832 * 12.923210144042969f;
    //   _937 = _844;
    //   _938 = _856;
    //   _939 = _866;
    // }
    _937 = renodx::color::srgb::EncodeSafe(_822);
    _938 = renodx::color::srgb::EncodeSafe(_825);
    _939 = renodx::color::srgb::EncodeSafe(_828);

  } else {
    float _868 = saturate(_822);
    float _869 = saturate(_825);
    float _870 = saturate(_828);
    bool _871 = ((uint)(cb1_018w) == -2);
    if (!_871) {
      bool _873 = !(_868 >= 0.0030399328097701073f);
      if (!_873) {
        float _875 = abs(_868);
        float _876 = log2(_875);
        float _877 = _876 * 0.4166666567325592f;
        float _878 = exp2(_877);
        float _879 = _878 * 1.0549999475479126f;
        float _880 = _879 + -0.054999999701976776f;
        _884 = _880;
      } else {
        float _882 = _868 * 12.923210144042969f;
        _884 = _882;
      }
      bool _885 = !(_869 >= 0.0030399328097701073f);
      if (!_885) {
        float _887 = abs(_869);
        float _888 = log2(_887);
        float _889 = _888 * 0.4166666567325592f;
        float _890 = exp2(_889);
        float _891 = _890 * 1.0549999475479126f;
        float _892 = _891 + -0.054999999701976776f;
        _896 = _892;
      } else {
        float _894 = _869 * 12.923210144042969f;
        _896 = _894;
      }
      bool _897 = !(_870 >= 0.0030399328097701073f);
      if (!_897) {
        float _899 = abs(_870);
        float _900 = log2(_899);
        float _901 = _900 * 0.4166666567325592f;
        float _902 = exp2(_901);
        float _903 = _902 * 1.0549999475479126f;
        float _904 = _903 + -0.054999999701976776f;
        _908 = _884;
        _909 = _896;
        _910 = _904;
      } else {
        float _906 = _870 * 12.923210144042969f;
        _908 = _884;
        _909 = _896;
        _910 = _906;
      }
    } else {
      _908 = _868;
      _909 = _869;
      _910 = _870;
    }
    float _915 = abs(_908);
    float _916 = abs(_909);
    float _917 = abs(_910);
    float _918 = log2(_915);
    float _919 = log2(_916);
    float _920 = log2(_917);
    float _921 = _918 * cb2_000z;
    float _922 = _919 * cb2_000z;
    float _923 = _920 * cb2_000z;
    float _924 = exp2(_921);
    float _925 = exp2(_922);
    float _926 = exp2(_923);
    float _927 = _924 * cb2_000y;
    float _928 = _925 * cb2_000y;
    float _929 = _926 * cb2_000y;
    float _930 = _927 + cb2_000x;
    float _931 = _928 + cb2_000x;
    float _932 = _929 + cb2_000x;
    float _933 = saturate(_930);
    float _934 = saturate(_931);
    float _935 = saturate(_932);
    _937 = _933;
    _938 = _934;
    _939 = _935;
  }
  float _940 = dot(float3(_937, _938, _939), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _937;
  SV_Target.y = _938;
  SV_Target.z = _939;
  SV_Target.w = _940;
  SV_Target_1.x = _940;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
