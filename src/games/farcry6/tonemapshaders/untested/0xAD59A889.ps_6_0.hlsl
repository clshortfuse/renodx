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

Texture2D<float4> t8 : register(t8);

Texture3D<float2> t9 : register(t9);

Texture2D<float4> t10 : register(t10);

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
  float _25 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _30 = cb2_015x * TEXCOORD0_centroid.x;
  float _31 = cb2_015y * TEXCOORD0_centroid.y;
  float _34 = _30 + cb2_015z;
  float _35 = _31 + cb2_015w;
  float4 _36 = t8.SampleLevel(s0_space2, float2(_34, _35), 0.0f);
  float _40 = saturate(_36.x);
  float _41 = saturate(_36.z);
  float _44 = cb2_026x * _41;
  float _45 = _40 * 6.283199787139893f;
  float _46 = cos(_45);
  float _47 = sin(_45);
  float _48 = _44 * _46;
  float _49 = _47 * _44;
  float _50 = 1.0f - _36.y;
  float _51 = saturate(_50);
  float _52 = _48 * _51;
  float _53 = _49 * _51;
  float _54 = _52 + TEXCOORD0_centroid.x;
  float _55 = _53 + TEXCOORD0_centroid.y;
  float4 _56 = t1.SampleLevel(s4_space2, float2(_54, _55), 0.0f);
  float _60 = max(_56.x, 0.0f);
  float _61 = max(_56.y, 0.0f);
  float _62 = max(_56.z, 0.0f);
  float _63 = min(_60, 65000.0f);
  float _64 = min(_61, 65000.0f);
  float _65 = min(_62, 65000.0f);
  float4 _66 = t4.SampleLevel(s2_space2, float2(_54, _55), 0.0f);
  float _71 = max(_66.x, 0.0f);
  float _72 = max(_66.y, 0.0f);
  float _73 = max(_66.z, 0.0f);
  float _74 = max(_66.w, 0.0f);
  float _75 = min(_71, 5000.0f);
  float _76 = min(_72, 5000.0f);
  float _77 = min(_73, 5000.0f);
  float _78 = min(_74, 5000.0f);
  float _81 = _25.x * cb0_028z;
  float _82 = _81 + cb0_028x;
  float _83 = cb2_027w / _82;
  float _84 = 1.0f - _83;
  float _85 = abs(_84);
  float _87 = cb2_027y * _85;
  float _89 = _87 - cb2_027z;
  float _90 = saturate(_89);
  float _91 = max(_90, _78);
  float _92 = saturate(_91);
  float4 _93 = t5.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _97 = _75 - _63;
  float _98 = _76 - _64;
  float _99 = _77 - _65;
  float _100 = _92 * _97;
  float _101 = _92 * _98;
  float _102 = _92 * _99;
  float _103 = _100 + _63;
  float _104 = _101 + _64;
  float _105 = _102 + _65;
  float _106 = dot(float3(_103, _104, _105), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _110 = t0[0].SExposureData_020;
  float _112 = t0[0].SExposureData_004;
  float _114 = cb2_018x * 0.5f;
  float _115 = _114 * cb2_018y;
  float _116 = _112.x - _115;
  float _117 = cb2_018y * cb2_018x;
  float _118 = 1.0f / _117;
  float _119 = _116 * _118;
  float _120 = _106 / _110.x;
  float _121 = _120 * 5464.01611328125f;
  float _122 = _121 + 9.99999993922529e-09f;
  float _123 = log2(_122);
  float _124 = _123 - _116;
  float _125 = _124 * _118;
  float _126 = saturate(_125);
  float2 _127 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _126), 0.0f);
  float _130 = max(_127.y, 1.0000000116860974e-07f);
  float _131 = _127.x / _130;
  float _132 = _131 + _119;
  float _133 = _132 / _118;
  float _134 = _133 - _112.x;
  float _135 = -0.0f - _134;
  float _137 = _135 - cb2_027x;
  float _138 = max(0.0f, _137);
  float _140 = cb2_026z * _138;
  float _141 = _134 - cb2_027x;
  float _142 = max(0.0f, _141);
  float _144 = cb2_026w * _142;
  bool _145 = (_134 < 0.0f);
  float _146 = select(_145, _140, _144);
  float _147 = exp2(_146);
  float _148 = _147 * _103;
  float _149 = _147 * _104;
  float _150 = _147 * _105;
  float _155 = cb2_024y * _93.x;
  float _156 = cb2_024z * _93.y;
  float _157 = cb2_024w * _93.z;
  float _158 = _155 + _148;
  float _159 = _156 + _149;
  float _160 = _157 + _150;
  float _165 = _158 * cb2_025x;
  float _166 = _159 * cb2_025y;
  float _167 = _160 * cb2_025z;
  float _168 = dot(float3(_165, _166, _167), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _169 = t0[0].SExposureData_012;
  float _171 = _168 * 5464.01611328125f;
  float _172 = _171 * _169.x;
  float _173 = _172 + 9.99999993922529e-09f;
  float _174 = log2(_173);
  float _175 = _174 + 16.929765701293945f;
  float _176 = _175 * 0.05734497308731079f;
  float _177 = saturate(_176);
  float _178 = _177 * _177;
  float _179 = _177 * 2.0f;
  float _180 = 3.0f - _179;
  float _181 = _178 * _180;
  float _182 = _166 * 0.8450999855995178f;
  float _183 = _167 * 0.14589999616146088f;
  float _184 = _182 + _183;
  float _185 = _184 * 2.4890189170837402f;
  float _186 = _184 * 0.3754962384700775f;
  float _187 = _184 * 2.811495304107666f;
  float _188 = _184 * 5.519708156585693f;
  float _189 = _168 - _185;
  float _190 = _181 * _189;
  float _191 = _190 + _185;
  float _192 = _181 * 0.5f;
  float _193 = _192 + 0.5f;
  float _194 = _193 * _189;
  float _195 = _194 + _185;
  float _196 = _165 - _186;
  float _197 = _166 - _187;
  float _198 = _167 - _188;
  float _199 = _193 * _196;
  float _200 = _193 * _197;
  float _201 = _193 * _198;
  float _202 = _199 + _186;
  float _203 = _200 + _187;
  float _204 = _201 + _188;
  float _205 = 1.0f / _195;
  float _206 = _191 * _205;
  float _207 = _206 * _202;
  float _208 = _206 * _203;
  float _209 = _206 * _204;
  float _213 = cb2_020x * TEXCOORD0_centroid.x;
  float _214 = cb2_020y * TEXCOORD0_centroid.y;
  float _217 = _213 + cb2_020z;
  float _218 = _214 + cb2_020w;
  float _221 = dot(float2(_217, _218), float2(_217, _218));
  float _222 = 1.0f - _221;
  float _223 = saturate(_222);
  float _224 = log2(_223);
  float _225 = _224 * cb2_021w;
  float _226 = exp2(_225);
  float _230 = _207 - cb2_021x;
  float _231 = _208 - cb2_021y;
  float _232 = _209 - cb2_021z;
  float _233 = _230 * _226;
  float _234 = _231 * _226;
  float _235 = _232 * _226;
  float _236 = _233 + cb2_021x;
  float _237 = _234 + cb2_021y;
  float _238 = _235 + cb2_021z;
  float _239 = t0[0].SExposureData_000;
  float _241 = max(_110.x, 0.0010000000474974513f);
  float _242 = 1.0f / _241;
  float _243 = _242 * _239.x;
  bool _246 = ((uint)(cb2_069y) == 0);
  float _252;
  float _253;
  float _254;
  float _308;
  float _309;
  float _310;
  float _356;
  float _357;
  float _358;
  float _403;
  float _404;
  float _405;
  float _406;
  float _455;
  float _456;
  float _457;
  float _458;
  float _483;
  float _484;
  float _485;
  float _635;
  float _672;
  float _673;
  float _674;
  float _703;
  float _704;
  float _705;
  float _786;
  float _787;
  float _788;
  float _794;
  float _795;
  float _796;
  float _810;
  float _811;
  float _812;
  float _837;
  float _849;
  float _877;
  float _889;
  float _901;
  float _902;
  float _903;
  float _930;
  float _931;
  float _932;
  if (!_246) {
    float _248 = _243 * _236;
    float _249 = _243 * _237;
    float _250 = _243 * _238;
    _252 = _248;
    _253 = _249;
    _254 = _250;
  } else {
    _252 = _236;
    _253 = _237;
    _254 = _238;
  }
  float _255 = _252 * 0.6130970120429993f;
  float _256 = mad(0.33952298760414124f, _253, _255);
  float _257 = mad(0.04737899824976921f, _254, _256);
  float _258 = _252 * 0.07019399851560593f;
  float _259 = mad(0.9163540005683899f, _253, _258);
  float _260 = mad(0.013451999984681606f, _254, _259);
  float _261 = _252 * 0.02061600051820278f;
  float _262 = mad(0.10956999659538269f, _253, _261);
  float _263 = mad(0.8698149919509888f, _254, _262);
  float _264 = log2(_257);
  float _265 = log2(_260);
  float _266 = log2(_263);
  float _267 = _264 * 0.04211956635117531f;
  float _268 = _265 * 0.04211956635117531f;
  float _269 = _266 * 0.04211956635117531f;
  float _270 = _267 + 0.6252607107162476f;
  float _271 = _268 + 0.6252607107162476f;
  float _272 = _269 + 0.6252607107162476f;
  float4 _273 = t6.SampleLevel(s2_space2, float3(_270, _271, _272), 0.0f);
  bool _279 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_279 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _283 = cb2_017x * _273.x;
    float _284 = cb2_017x * _273.y;
    float _285 = cb2_017x * _273.z;
    float _287 = _283 + cb2_017y;
    float _288 = _284 + cb2_017y;
    float _289 = _285 + cb2_017y;
    float _290 = exp2(_287);
    float _291 = exp2(_288);
    float _292 = exp2(_289);
    float _293 = _290 + 1.0f;
    float _294 = _291 + 1.0f;
    float _295 = _292 + 1.0f;
    float _296 = 1.0f / _293;
    float _297 = 1.0f / _294;
    float _298 = 1.0f / _295;
    float _300 = cb2_017z * _296;
    float _301 = cb2_017z * _297;
    float _302 = cb2_017z * _298;
    float _304 = _300 + cb2_017w;
    float _305 = _301 + cb2_017w;
    float _306 = _302 + cb2_017w;
    _308 = _304;
    _309 = _305;
    _310 = _306;
  } else {
    _308 = _273.x;
    _309 = _273.y;
    _310 = _273.z;
  }
  float _311 = _308 * 23.0f;
  float _312 = _311 + -14.473931312561035f;
  float _313 = exp2(_312);
  float _314 = _309 * 23.0f;
  float _315 = _314 + -14.473931312561035f;
  float _316 = exp2(_315);
  float _317 = _310 * 23.0f;
  float _318 = _317 + -14.473931312561035f;
  float _319 = exp2(_318);
  float _324 = cb2_004x * TEXCOORD0_centroid.x;
  float _325 = cb2_004y * TEXCOORD0_centroid.y;
  float _328 = _324 + cb2_004z;
  float _329 = _325 + cb2_004w;
  float4 _335 = t7.Sample(s2_space2, float2(_328, _329));
  float _340 = _335.x * cb2_003x;
  float _341 = _335.y * cb2_003y;
  float _342 = _335.z * cb2_003z;
  float _343 = _335.w * cb2_003w;
  float _346 = _343 + cb2_026y;
  float _347 = saturate(_346);
  bool _350 = ((uint)(cb2_069y) == 0);
  if (!_350) {
    float _352 = _340 * _243;
    float _353 = _341 * _243;
    float _354 = _342 * _243;
    _356 = _352;
    _357 = _353;
    _358 = _354;
  } else {
    _356 = _340;
    _357 = _341;
    _358 = _342;
  }
  bool _361 = ((uint)(cb2_028x) == 2);
  bool _362 = ((uint)(cb2_028x) == 3);
  int _363 = (uint)(cb2_028x) & -2;
  bool _364 = (_363 == 2);
  bool _365 = ((uint)(cb2_028x) == 6);
  bool _366 = _364 || _365;
  if (_366) {
    float _368 = _356 * _347;
    float _369 = _357 * _347;
    float _370 = _358 * _347;
    float _371 = _347 * _347;
    _403 = _368;
    _404 = _369;
    _405 = _370;
    _406 = _371;
  } else {
    bool _373 = ((uint)(cb2_028x) == 4);
    if (_373) {
      float _375 = _356 + -1.0f;
      float _376 = _357 + -1.0f;
      float _377 = _358 + -1.0f;
      float _378 = _347 + -1.0f;
      float _379 = _375 * _347;
      float _380 = _376 * _347;
      float _381 = _377 * _347;
      float _382 = _378 * _347;
      float _383 = _379 + 1.0f;
      float _384 = _380 + 1.0f;
      float _385 = _381 + 1.0f;
      float _386 = _382 + 1.0f;
      _403 = _383;
      _404 = _384;
      _405 = _385;
      _406 = _386;
    } else {
      bool _388 = ((uint)(cb2_028x) == 5);
      if (_388) {
        float _390 = _356 + -0.5f;
        float _391 = _357 + -0.5f;
        float _392 = _358 + -0.5f;
        float _393 = _347 + -0.5f;
        float _394 = _390 * _347;
        float _395 = _391 * _347;
        float _396 = _392 * _347;
        float _397 = _393 * _347;
        float _398 = _394 + 0.5f;
        float _399 = _395 + 0.5f;
        float _400 = _396 + 0.5f;
        float _401 = _397 + 0.5f;
        _403 = _398;
        _404 = _399;
        _405 = _400;
        _406 = _401;
      } else {
        _403 = _356;
        _404 = _357;
        _405 = _358;
        _406 = _347;
      }
    }
  }
  if (_361) {
    float _408 = _403 + _313;
    float _409 = _404 + _316;
    float _410 = _405 + _319;
    _455 = _408;
    _456 = _409;
    _457 = _410;
    _458 = cb2_025w;
  } else {
    if (_362) {
      float _413 = 1.0f - _403;
      float _414 = 1.0f - _404;
      float _415 = 1.0f - _405;
      float _416 = _413 * _313;
      float _417 = _414 * _316;
      float _418 = _415 * _319;
      float _419 = _416 + _403;
      float _420 = _417 + _404;
      float _421 = _418 + _405;
      _455 = _419;
      _456 = _420;
      _457 = _421;
      _458 = cb2_025w;
    } else {
      bool _423 = ((uint)(cb2_028x) == 4);
      if (_423) {
        float _425 = _403 * _313;
        float _426 = _404 * _316;
        float _427 = _405 * _319;
        _455 = _425;
        _456 = _426;
        _457 = _427;
        _458 = cb2_025w;
      } else {
        bool _429 = ((uint)(cb2_028x) == 5);
        if (_429) {
          float _431 = _313 * 2.0f;
          float _432 = _431 * _403;
          float _433 = _316 * 2.0f;
          float _434 = _433 * _404;
          float _435 = _319 * 2.0f;
          float _436 = _435 * _405;
          _455 = _432;
          _456 = _434;
          _457 = _436;
          _458 = cb2_025w;
        } else {
          if (_365) {
            float _439 = _313 - _403;
            float _440 = _316 - _404;
            float _441 = _319 - _405;
            _455 = _439;
            _456 = _440;
            _457 = _441;
            _458 = cb2_025w;
          } else {
            float _443 = _403 - _313;
            float _444 = _404 - _316;
            float _445 = _405 - _319;
            float _446 = _406 * _443;
            float _447 = _406 * _444;
            float _448 = _406 * _445;
            float _449 = _446 + _313;
            float _450 = _447 + _316;
            float _451 = _448 + _319;
            float _452 = 1.0f - _406;
            float _453 = _452 * cb2_025w;
            _455 = _449;
            _456 = _450;
            _457 = _451;
            _458 = _453;
          }
        }
      }
    }
  }
  float _464 = cb2_016x - _455;
  float _465 = cb2_016y - _456;
  float _466 = cb2_016z - _457;
  float _467 = _464 * cb2_016w;
  float _468 = _465 * cb2_016w;
  float _469 = _466 * cb2_016w;
  float _470 = _467 + _455;
  float _471 = _468 + _456;
  float _472 = _469 + _457;
  bool _475 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_475 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _479 = cb2_024x * _470;
    float _480 = cb2_024x * _471;
    float _481 = cb2_024x * _472;
    _483 = _479;
    _484 = _480;
    _485 = _481;
  } else {
    _483 = _470;
    _484 = _471;
    _485 = _472;
  }
  float _488 = _483 * 0.9708889722824097f;
  float _489 = mad(0.026962999254465103f, _484, _488);
  float _490 = mad(0.002148000057786703f, _485, _489);
  float _491 = _483 * 0.01088900025933981f;
  float _492 = mad(0.9869629740715027f, _484, _491);
  float _493 = mad(0.002148000057786703f, _485, _492);
  float _494 = mad(0.026962999254465103f, _484, _491);
  float _495 = mad(0.9621480107307434f, _485, _494);
  float _496 = max(_490, 0.0f);
  float _497 = max(_493, 0.0f);
  float _498 = max(_495, 0.0f);
  float _499 = min(_496, cb2_095y);
  float _500 = min(_497, cb2_095y);
  float _501 = min(_498, cb2_095y);
  bool _504 = ((uint)(cb2_095x) == 0);
  bool _507 = ((uint)(cb2_094w) == 0);
  bool _509 = ((uint)(cb2_094z) == 0);
  bool _511 = ((uint)(cb2_094y) != 0);
  bool _513 = ((uint)(cb2_094x) == 0);
  bool _515 = ((uint)(cb2_069z) != 0);
  float _562 = asfloat((uint)(cb2_075y));
  float _563 = asfloat((uint)(cb2_075z));
  float _564 = asfloat((uint)(cb2_075w));
  float _565 = asfloat((uint)(cb2_074z));
  float _566 = asfloat((uint)(cb2_074w));
  float _567 = asfloat((uint)(cb2_075x));
  float _568 = asfloat((uint)(cb2_073w));
  float _569 = asfloat((uint)(cb2_074x));
  float _570 = asfloat((uint)(cb2_074y));
  float _571 = asfloat((uint)(cb2_077x));
  float _572 = asfloat((uint)(cb2_077y));
  float _573 = asfloat((uint)(cb2_079x));
  float _574 = asfloat((uint)(cb2_079y));
  float _575 = asfloat((uint)(cb2_079z));
  float _576 = asfloat((uint)(cb2_078y));
  float _577 = asfloat((uint)(cb2_078z));
  float _578 = asfloat((uint)(cb2_078w));
  float _579 = asfloat((uint)(cb2_077z));
  float _580 = asfloat((uint)(cb2_077w));
  float _581 = asfloat((uint)(cb2_078x));
  float _582 = asfloat((uint)(cb2_072y));
  float _583 = asfloat((uint)(cb2_072z));
  float _584 = asfloat((uint)(cb2_072w));
  float _585 = asfloat((uint)(cb2_071x));
  float _586 = asfloat((uint)(cb2_071y));
  float _587 = asfloat((uint)(cb2_076x));
  float _588 = asfloat((uint)(cb2_070w));
  float _589 = asfloat((uint)(cb2_070x));
  float _590 = asfloat((uint)(cb2_070y));
  float _591 = asfloat((uint)(cb2_070z));
  float _592 = asfloat((uint)(cb2_073x));
  float _593 = asfloat((uint)(cb2_073y));
  float _594 = asfloat((uint)(cb2_073z));
  float _595 = asfloat((uint)(cb2_071z));
  float _596 = asfloat((uint)(cb2_071w));
  float _597 = asfloat((uint)(cb2_072x));
  float _598 = max(_500, _501);
  float _599 = max(_499, _598);
  float _600 = 1.0f / _599;
  float _601 = _600 * _499;
  float _602 = _600 * _500;
  float _603 = _600 * _501;
  float _604 = abs(_601);
  float _605 = log2(_604);
  float _606 = _605 * _589;
  float _607 = exp2(_606);
  float _608 = abs(_602);
  float _609 = log2(_608);
  float _610 = _609 * _590;
  float _611 = exp2(_610);
  float _612 = abs(_603);
  float _613 = log2(_612);
  float _614 = _613 * _591;
  float _615 = exp2(_614);
  if (_511) {
    float _618 = asfloat((uint)(cb2_076w));
    float _620 = asfloat((uint)(cb2_076z));
    float _622 = asfloat((uint)(cb2_076y));
    float _623 = _620 * _500;
    float _624 = _622 * _499;
    float _625 = _618 * _501;
    float _626 = _624 + _625;
    float _627 = _626 + _623;
    _635 = _627;
  } else {
    float _629 = _596 * _500;
    float _630 = _595 * _499;
    float _631 = _597 * _501;
    float _632 = _629 + _630;
    float _633 = _632 + _631;
    _635 = _633;
  }
  float _636 = abs(_635);
  float _637 = log2(_636);
  float _638 = _637 * _588;
  float _639 = exp2(_638);
  float _640 = log2(_639);
  float _641 = _640 * _587;
  float _642 = exp2(_641);
  float _643 = select(_515, _642, _639);
  float _644 = _643 * _585;
  float _645 = _644 + _586;
  float _646 = 1.0f / _645;
  float _647 = _646 * _639;
  if (_511) {
    if (!_513) {
      float _650 = _607 * _579;
      float _651 = _611 * _580;
      float _652 = _615 * _581;
      float _653 = _651 + _650;
      float _654 = _653 + _652;
      float _655 = _611 * _577;
      float _656 = _607 * _576;
      float _657 = _615 * _578;
      float _658 = _655 + _656;
      float _659 = _658 + _657;
      float _660 = _615 * _575;
      float _661 = _611 * _574;
      float _662 = _607 * _573;
      float _663 = _661 + _662;
      float _664 = _663 + _660;
      float _665 = max(_659, _664);
      float _666 = max(_654, _665);
      float _667 = 1.0f / _666;
      float _668 = _667 * _654;
      float _669 = _667 * _659;
      float _670 = _667 * _664;
      _672 = _668;
      _673 = _669;
      _674 = _670;
    } else {
      _672 = _607;
      _673 = _611;
      _674 = _615;
    }
    float _675 = _672 * _572;
    float _676 = exp2(_675);
    float _677 = _676 * _571;
    float _678 = saturate(_677);
    float _679 = _672 * _571;
    float _680 = _672 - _679;
    float _681 = saturate(_680);
    float _682 = max(_571, _681);
    float _683 = min(_682, _678);
    float _684 = _673 * _572;
    float _685 = exp2(_684);
    float _686 = _685 * _571;
    float _687 = saturate(_686);
    float _688 = _673 * _571;
    float _689 = _673 - _688;
    float _690 = saturate(_689);
    float _691 = max(_571, _690);
    float _692 = min(_691, _687);
    float _693 = _674 * _572;
    float _694 = exp2(_693);
    float _695 = _694 * _571;
    float _696 = saturate(_695);
    float _697 = _674 * _571;
    float _698 = _674 - _697;
    float _699 = saturate(_698);
    float _700 = max(_571, _699);
    float _701 = min(_700, _696);
    _703 = _683;
    _704 = _692;
    _705 = _701;
  } else {
    _703 = _607;
    _704 = _611;
    _705 = _615;
  }
  float _706 = _703 * _595;
  float _707 = _704 * _596;
  float _708 = _707 + _706;
  float _709 = _705 * _597;
  float _710 = _708 + _709;
  float _711 = 1.0f / _710;
  float _712 = _711 * _647;
  float _713 = saturate(_712);
  float _714 = _713 * _703;
  float _715 = saturate(_714);
  float _716 = _713 * _704;
  float _717 = saturate(_716);
  float _718 = _713 * _705;
  float _719 = saturate(_718);
  float _720 = _715 * _582;
  float _721 = _582 - _720;
  float _722 = _717 * _583;
  float _723 = _583 - _722;
  float _724 = _719 * _584;
  float _725 = _584 - _724;
  float _726 = _719 * _597;
  float _727 = _715 * _595;
  float _728 = _717 * _596;
  float _729 = _647 - _727;
  float _730 = _729 - _728;
  float _731 = _730 - _726;
  float _732 = saturate(_731);
  float _733 = _723 * _596;
  float _734 = _721 * _595;
  float _735 = _725 * _597;
  float _736 = _733 + _734;
  float _737 = _736 + _735;
  float _738 = 1.0f / _737;
  float _739 = _738 * _732;
  float _740 = _739 * _721;
  float _741 = _740 + _715;
  float _742 = saturate(_741);
  float _743 = _739 * _723;
  float _744 = _743 + _717;
  float _745 = saturate(_744);
  float _746 = _739 * _725;
  float _747 = _746 + _719;
  float _748 = saturate(_747);
  float _749 = _748 * _597;
  float _750 = _742 * _595;
  float _751 = _745 * _596;
  float _752 = _647 - _750;
  float _753 = _752 - _751;
  float _754 = _753 - _749;
  float _755 = saturate(_754);
  float _756 = _755 * _592;
  float _757 = _756 + _742;
  float _758 = saturate(_757);
  float _759 = _755 * _593;
  float _760 = _759 + _745;
  float _761 = saturate(_760);
  float _762 = _755 * _594;
  float _763 = _762 + _748;
  float _764 = saturate(_763);
  if (!_509) {
    float _766 = _758 * _568;
    float _767 = _761 * _569;
    float _768 = _764 * _570;
    float _769 = _767 + _766;
    float _770 = _769 + _768;
    float _771 = _761 * _566;
    float _772 = _758 * _565;
    float _773 = _764 * _567;
    float _774 = _771 + _772;
    float _775 = _774 + _773;
    float _776 = _764 * _564;
    float _777 = _761 * _563;
    float _778 = _758 * _562;
    float _779 = _777 + _778;
    float _780 = _779 + _776;
    if (!_507) {
      float _782 = saturate(_770);
      float _783 = saturate(_775);
      float _784 = saturate(_780);
      _786 = _784;
      _787 = _783;
      _788 = _782;
    } else {
      _786 = _780;
      _787 = _775;
      _788 = _770;
    }
  } else {
    _786 = _764;
    _787 = _761;
    _788 = _758;
  }
  if (!_504) {
    float _790 = _788 * _568;
    float _791 = _787 * _568;
    float _792 = _786 * _568;
    _794 = _792;
    _795 = _791;
    _796 = _790;
  } else {
    _794 = _786;
    _795 = _787;
    _796 = _788;
  }
  if (_475) {
    float _800 = cb1_018z * 9.999999747378752e-05f;
    float _801 = _800 * _796;
    float _802 = _800 * _795;
    float _803 = _800 * _794;
    float _805 = 5000.0f / cb1_018y;
    float _806 = _801 * _805;
    float _807 = _802 * _805;
    float _808 = _803 * _805;
    _810 = _806;
    _811 = _807;
    _812 = _808;
  } else {
    _810 = _796;
    _811 = _795;
    _812 = _794;
  }
  float _813 = _810 * 1.6047500371932983f;
  float _814 = mad(-0.5310800075531006f, _811, _813);
  float _815 = mad(-0.07366999983787537f, _812, _814);
  float _816 = _810 * -0.10208000242710114f;
  float _817 = mad(1.1081299781799316f, _811, _816);
  float _818 = mad(-0.006049999967217445f, _812, _817);
  float _819 = _810 * -0.0032599999103695154f;
  float _820 = mad(-0.07275000214576721f, _811, _819);
  float _821 = mad(1.0760200023651123f, _812, _820);
  if (_475) {
    // float _823 = max(_815, 0.0f);
    // float _824 = max(_818, 0.0f);
    // float _825 = max(_821, 0.0f);
    // bool _826 = !(_823 >= 0.0030399328097701073f);
    // if (!_826) {
    //   float _828 = abs(_823);
    //   float _829 = log2(_828);
    //   float _830 = _829 * 0.4166666567325592f;
    //   float _831 = exp2(_830);
    //   float _832 = _831 * 1.0549999475479126f;
    //   float _833 = _832 + -0.054999999701976776f;
    //   _837 = _833;
    // } else {
    //   float _835 = _823 * 12.923210144042969f;
    //   _837 = _835;
    // }
    // bool _838 = !(_824 >= 0.0030399328097701073f);
    // if (!_838) {
    //   float _840 = abs(_824);
    //   float _841 = log2(_840);
    //   float _842 = _841 * 0.4166666567325592f;
    //   float _843 = exp2(_842);
    //   float _844 = _843 * 1.0549999475479126f;
    //   float _845 = _844 + -0.054999999701976776f;
    //   _849 = _845;
    // } else {
    //   float _847 = _824 * 12.923210144042969f;
    //   _849 = _847;
    // }
    // bool _850 = !(_825 >= 0.0030399328097701073f);
    // if (!_850) {
    //   float _852 = abs(_825);
    //   float _853 = log2(_852);
    //   float _854 = _853 * 0.4166666567325592f;
    //   float _855 = exp2(_854);
    //   float _856 = _855 * 1.0549999475479126f;
    //   float _857 = _856 + -0.054999999701976776f;
    //   _930 = _837;
    //   _931 = _849;
    //   _932 = _857;
    // } else {
    //   float _859 = _825 * 12.923210144042969f;
    //   _930 = _837;
    //   _931 = _849;
    //   _932 = _859;
    // }
    _930 = renodx::color::srgb::EncodeSafe(_815);
    _931 = renodx::color::srgb::EncodeSafe(_818);
    _932 = renodx::color::srgb::EncodeSafe(_821);

  } else {
    float _861 = saturate(_815);
    float _862 = saturate(_818);
    float _863 = saturate(_821);
    bool _864 = ((uint)(cb1_018w) == -2);
    if (!_864) {
      bool _866 = !(_861 >= 0.0030399328097701073f);
      if (!_866) {
        float _868 = abs(_861);
        float _869 = log2(_868);
        float _870 = _869 * 0.4166666567325592f;
        float _871 = exp2(_870);
        float _872 = _871 * 1.0549999475479126f;
        float _873 = _872 + -0.054999999701976776f;
        _877 = _873;
      } else {
        float _875 = _861 * 12.923210144042969f;
        _877 = _875;
      }
      bool _878 = !(_862 >= 0.0030399328097701073f);
      if (!_878) {
        float _880 = abs(_862);
        float _881 = log2(_880);
        float _882 = _881 * 0.4166666567325592f;
        float _883 = exp2(_882);
        float _884 = _883 * 1.0549999475479126f;
        float _885 = _884 + -0.054999999701976776f;
        _889 = _885;
      } else {
        float _887 = _862 * 12.923210144042969f;
        _889 = _887;
      }
      bool _890 = !(_863 >= 0.0030399328097701073f);
      if (!_890) {
        float _892 = abs(_863);
        float _893 = log2(_892);
        float _894 = _893 * 0.4166666567325592f;
        float _895 = exp2(_894);
        float _896 = _895 * 1.0549999475479126f;
        float _897 = _896 + -0.054999999701976776f;
        _901 = _877;
        _902 = _889;
        _903 = _897;
      } else {
        float _899 = _863 * 12.923210144042969f;
        _901 = _877;
        _902 = _889;
        _903 = _899;
      }
    } else {
      _901 = _861;
      _902 = _862;
      _903 = _863;
    }
    float _908 = abs(_901);
    float _909 = abs(_902);
    float _910 = abs(_903);
    float _911 = log2(_908);
    float _912 = log2(_909);
    float _913 = log2(_910);
    float _914 = _911 * cb2_000z;
    float _915 = _912 * cb2_000z;
    float _916 = _913 * cb2_000z;
    float _917 = exp2(_914);
    float _918 = exp2(_915);
    float _919 = exp2(_916);
    float _920 = _917 * cb2_000y;
    float _921 = _918 * cb2_000y;
    float _922 = _919 * cb2_000y;
    float _923 = _920 + cb2_000x;
    float _924 = _921 + cb2_000x;
    float _925 = _922 + cb2_000x;
    float _926 = saturate(_923);
    float _927 = saturate(_924);
    float _928 = saturate(_925);
    _930 = _926;
    _931 = _927;
    _932 = _928;
  }
  float _936 = cb2_023x * TEXCOORD0_centroid.x;
  float _937 = cb2_023y * TEXCOORD0_centroid.y;
  float _940 = _936 + cb2_023z;
  float _941 = _937 + cb2_023w;
  float4 _944 = t10.SampleLevel(s0_space2, float2(_940, _941), 0.0f);
  float _946 = _944.x + -0.5f;
  float _947 = _946 * cb2_022x;
  float _948 = _947 + 0.5f;
  float _949 = _948 * 2.0f;
  float _950 = _949 * _930;
  float _951 = _949 * _931;
  float _952 = _949 * _932;
  float _956 = float((uint)(cb2_019z));
  float _957 = float((uint)(cb2_019w));
  float _958 = _956 + SV_Position.x;
  float _959 = _957 + SV_Position.y;
  uint _960 = uint(_958);
  uint _961 = uint(_959);
  uint _964 = cb2_019x + -1u;
  uint _965 = cb2_019y + -1u;
  int _966 = _960 & _964;
  int _967 = _961 & _965;
  float4 _968 = t3.Load(int3(_966, _967, 0));
  float _972 = _968.x * 2.0f;
  float _973 = _968.y * 2.0f;
  float _974 = _968.z * 2.0f;
  float _975 = _972 + -1.0f;
  float _976 = _973 + -1.0f;
  float _977 = _974 + -1.0f;
  float _978 = _975 * _458;
  float _979 = _976 * _458;
  float _980 = _977 * _458;
  float _981 = _978 + _950;
  float _982 = _979 + _951;
  float _983 = _980 + _952;
  float _984 = dot(float3(_981, _982, _983), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _981;
  SV_Target.y = _982;
  SV_Target.z = _983;
  SV_Target.w = _984;
  SV_Target_1.x = _984;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
