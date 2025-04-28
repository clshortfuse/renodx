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

Texture2D<float4> t8 : register(t8);

Texture3D<float2> t9 : register(t9);

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
  float cb2_005x : packoffset(c005.x);
  float cb2_006x : packoffset(c006.x);
  float cb2_006y : packoffset(c006.y);
  float cb2_006z : packoffset(c006.z);
  float cb2_006w : packoffset(c006.w);
  float cb2_007x : packoffset(c007.x);
  float cb2_007y : packoffset(c007.y);
  float cb2_007z : packoffset(c007.z);
  float cb2_007w : packoffset(c007.w);
  float cb2_008x : packoffset(c008.x);
  float cb2_008y : packoffset(c008.y);
  float cb2_008z : packoffset(c008.z);
  float cb2_008w : packoffset(c008.w);
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
  float _22 = t2.SampleLevel(s4_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _27 = cb2_015x * TEXCOORD0_centroid.x;
  float _28 = cb2_015y * TEXCOORD0_centroid.y;
  float _31 = _27 + cb2_015z;
  float _32 = _28 + cb2_015w;
  float4 _33 = t8.SampleLevel(s0_space2, float2(_31, _32), 0.0f);
  float _37 = saturate(_33.x);
  float _38 = saturate(_33.z);
  float _41 = cb2_026x * _38;
  float _42 = _37 * 6.283199787139893f;
  float _43 = cos(_42);
  float _44 = sin(_42);
  float _45 = _41 * _43;
  float _46 = _44 * _41;
  float _47 = 1.0f - _33.y;
  float _48 = saturate(_47);
  float _49 = _45 * _48;
  float _50 = _46 * _48;
  float _51 = _49 + TEXCOORD0_centroid.x;
  float _52 = _50 + TEXCOORD0_centroid.y;
  float4 _53 = t1.SampleLevel(s4_space2, float2(_51, _52), 0.0f);
  float _57 = max(_53.x, 0.0f);
  float _58 = max(_53.y, 0.0f);
  float _59 = max(_53.z, 0.0f);
  float _60 = min(_57, 65000.0f);
  float _61 = min(_58, 65000.0f);
  float _62 = min(_59, 65000.0f);
  float4 _63 = t3.SampleLevel(s2_space2, float2(_51, _52), 0.0f);
  float _68 = max(_63.x, 0.0f);
  float _69 = max(_63.y, 0.0f);
  float _70 = max(_63.z, 0.0f);
  float _71 = max(_63.w, 0.0f);
  float _72 = min(_68, 5000.0f);
  float _73 = min(_69, 5000.0f);
  float _74 = min(_70, 5000.0f);
  float _75 = min(_71, 5000.0f);
  float _78 = _22.x * cb0_028z;
  float _79 = _78 + cb0_028x;
  float _80 = cb2_027w / _79;
  float _81 = 1.0f - _80;
  float _82 = abs(_81);
  float _84 = cb2_027y * _82;
  float _86 = _84 - cb2_027z;
  float _87 = saturate(_86);
  float _88 = max(_87, _75);
  float _89 = saturate(_88);
  float _93 = cb2_006x * _51;
  float _94 = cb2_006y * _52;
  float _97 = _93 + cb2_006z;
  float _98 = _94 + cb2_006w;
  float _102 = cb2_007x * _51;
  float _103 = cb2_007y * _52;
  float _106 = _102 + cb2_007z;
  float _107 = _103 + cb2_007w;
  float _111 = cb2_008x * _51;
  float _112 = cb2_008y * _52;
  float _115 = _111 + cb2_008z;
  float _116 = _112 + cb2_008w;
  float4 _117 = t1.SampleLevel(s2_space2, float2(_97, _98), 0.0f);
  float _119 = max(_117.x, 0.0f);
  float _120 = min(_119, 65000.0f);
  float4 _121 = t1.SampleLevel(s2_space2, float2(_106, _107), 0.0f);
  float _123 = max(_121.y, 0.0f);
  float _124 = min(_123, 65000.0f);
  float4 _125 = t1.SampleLevel(s2_space2, float2(_115, _116), 0.0f);
  float _127 = max(_125.z, 0.0f);
  float _128 = min(_127, 65000.0f);
  float4 _129 = t3.SampleLevel(s2_space2, float2(_97, _98), 0.0f);
  float _131 = max(_129.x, 0.0f);
  float _132 = min(_131, 5000.0f);
  float4 _133 = t3.SampleLevel(s2_space2, float2(_106, _107), 0.0f);
  float _135 = max(_133.y, 0.0f);
  float _136 = min(_135, 5000.0f);
  float4 _137 = t3.SampleLevel(s2_space2, float2(_115, _116), 0.0f);
  float _139 = max(_137.z, 0.0f);
  float _140 = min(_139, 5000.0f);
  float4 _141 = t6.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _147 = cb2_005x * _141.x;
  float _148 = cb2_005x * _141.y;
  float _149 = cb2_005x * _141.z;
  float _150 = _120 - _60;
  float _151 = _124 - _61;
  float _152 = _128 - _62;
  float _153 = _147 * _150;
  float _154 = _148 * _151;
  float _155 = _149 * _152;
  float _156 = _153 + _60;
  float _157 = _154 + _61;
  float _158 = _155 + _62;
  float _159 = _132 - _72;
  float _160 = _136 - _73;
  float _161 = _140 - _74;
  float _162 = _147 * _159;
  float _163 = _148 * _160;
  float _164 = _149 * _161;
  float _165 = _162 + _72;
  float _166 = _163 + _73;
  float _167 = _164 + _74;
  float4 _168 = t4.SampleLevel(s2_space2, float2(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y), 0.0f);
  float _172 = _165 - _156;
  float _173 = _166 - _157;
  float _174 = _167 - _158;
  float _175 = _172 * _89;
  float _176 = _173 * _89;
  float _177 = _174 * _89;
  float _178 = _175 + _156;
  float _179 = _176 + _157;
  float _180 = _177 + _158;
  float _181 = dot(float3(_178, _179, _180), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _185 = t0[0].SExposureData_020;
  float _187 = t0[0].SExposureData_004;
  float _189 = cb2_018x * 0.5f;
  float _190 = _189 * cb2_018y;
  float _191 = _187.x - _190;
  float _192 = cb2_018y * cb2_018x;
  float _193 = 1.0f / _192;
  float _194 = _191 * _193;
  float _195 = _181 / _185.x;
  float _196 = _195 * 5464.01611328125f;
  float _197 = _196 + 9.99999993922529e-09f;
  float _198 = log2(_197);
  float _199 = _198 - _191;
  float _200 = _199 * _193;
  float _201 = saturate(_200);
  float2 _202 = t9.SampleLevel(s2_space2, float3(TEXCOORD0_centroid.x, TEXCOORD0_centroid.y, _201), 0.0f);
  float _205 = max(_202.y, 1.0000000116860974e-07f);
  float _206 = _202.x / _205;
  float _207 = _206 + _194;
  float _208 = _207 / _193;
  float _209 = _208 - _187.x;
  float _210 = -0.0f - _209;
  float _212 = _210 - cb2_027x;
  float _213 = max(0.0f, _212);
  float _215 = cb2_026z * _213;
  float _216 = _209 - cb2_027x;
  float _217 = max(0.0f, _216);
  float _219 = cb2_026w * _217;
  bool _220 = (_209 < 0.0f);
  float _221 = select(_220, _215, _219);
  float _222 = exp2(_221);
  float _223 = _222 * _178;
  float _224 = _222 * _179;
  float _225 = _222 * _180;
  float _230 = cb2_024y * _168.x;
  float _231 = cb2_024z * _168.y;
  float _232 = cb2_024w * _168.z;
  float _233 = _230 + _223;
  float _234 = _231 + _224;
  float _235 = _232 + _225;
  float _240 = _233 * cb2_025x;
  float _241 = _234 * cb2_025y;
  float _242 = _235 * cb2_025z;
  float _243 = dot(float3(_240, _241, _242), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _244 = t0[0].SExposureData_012;
  float _246 = _243 * 5464.01611328125f;
  float _247 = _246 * _244.x;
  float _248 = _247 + 9.99999993922529e-09f;
  float _249 = log2(_248);
  float _250 = _249 + 16.929765701293945f;
  float _251 = _250 * 0.05734497308731079f;
  float _252 = saturate(_251);
  float _253 = _252 * _252;
  float _254 = _252 * 2.0f;
  float _255 = 3.0f - _254;
  float _256 = _253 * _255;
  float _257 = _241 * 0.8450999855995178f;
  float _258 = _242 * 0.14589999616146088f;
  float _259 = _257 + _258;
  float _260 = _259 * 2.4890189170837402f;
  float _261 = _259 * 0.3754962384700775f;
  float _262 = _259 * 2.811495304107666f;
  float _263 = _259 * 5.519708156585693f;
  float _264 = _243 - _260;
  float _265 = _256 * _264;
  float _266 = _265 + _260;
  float _267 = _256 * 0.5f;
  float _268 = _267 + 0.5f;
  float _269 = _268 * _264;
  float _270 = _269 + _260;
  float _271 = _240 - _261;
  float _272 = _241 - _262;
  float _273 = _242 - _263;
  float _274 = _268 * _271;
  float _275 = _268 * _272;
  float _276 = _268 * _273;
  float _277 = _274 + _261;
  float _278 = _275 + _262;
  float _279 = _276 + _263;
  float _280 = 1.0f / _270;
  float _281 = _266 * _280;
  float _282 = _281 * _277;
  float _283 = _281 * _278;
  float _284 = _281 * _279;
  float _288 = cb2_020x * TEXCOORD0_centroid.x;
  float _289 = cb2_020y * TEXCOORD0_centroid.y;
  float _292 = _288 + cb2_020z;
  float _293 = _289 + cb2_020w;
  float _296 = dot(float2(_292, _293), float2(_292, _293));
  float _297 = 1.0f - _296;
  float _298 = saturate(_297);
  float _299 = log2(_298);
  float _300 = _299 * cb2_021w;
  float _301 = exp2(_300);
  float _305 = _282 - cb2_021x;
  float _306 = _283 - cb2_021y;
  float _307 = _284 - cb2_021z;
  float _308 = _305 * _301;
  float _309 = _306 * _301;
  float _310 = _307 * _301;
  float _311 = _308 + cb2_021x;
  float _312 = _309 + cb2_021y;
  float _313 = _310 + cb2_021z;
  float _314 = t0[0].SExposureData_000;
  float _316 = max(_185.x, 0.0010000000474974513f);
  float _317 = 1.0f / _316;
  float _318 = _317 * _314.x;
  bool _321 = ((uint)(cb2_069y) == 0);
  float _327;
  float _328;
  float _329;
  float _383;
  float _384;
  float _385;
  float _430;
  float _431;
  float _432;
  float _477;
  float _478;
  float _479;
  float _480;
  float _527;
  float _528;
  float _529;
  float _554;
  float _555;
  float _556;
  float _706;
  float _743;
  float _744;
  float _745;
  float _774;
  float _775;
  float _776;
  float _857;
  float _858;
  float _859;
  float _865;
  float _866;
  float _867;
  float _881;
  float _882;
  float _883;
  float _908;
  float _920;
  float _948;
  float _960;
  float _972;
  float _973;
  float _974;
  float _1001;
  float _1002;
  float _1003;
  if (!_321) {
    float _323 = _318 * _311;
    float _324 = _318 * _312;
    float _325 = _318 * _313;
    _327 = _323;
    _328 = _324;
    _329 = _325;
  } else {
    _327 = _311;
    _328 = _312;
    _329 = _313;
  }
  float _330 = _327 * 0.6130970120429993f;
  float _331 = mad(0.33952298760414124f, _328, _330);
  float _332 = mad(0.04737899824976921f, _329, _331);
  float _333 = _327 * 0.07019399851560593f;
  float _334 = mad(0.9163540005683899f, _328, _333);
  float _335 = mad(0.013451999984681606f, _329, _334);
  float _336 = _327 * 0.02061600051820278f;
  float _337 = mad(0.10956999659538269f, _328, _336);
  float _338 = mad(0.8698149919509888f, _329, _337);
  float _339 = log2(_332);
  float _340 = log2(_335);
  float _341 = log2(_338);
  float _342 = _339 * 0.04211956635117531f;
  float _343 = _340 * 0.04211956635117531f;
  float _344 = _341 * 0.04211956635117531f;
  float _345 = _342 + 0.6252607107162476f;
  float _346 = _343 + 0.6252607107162476f;
  float _347 = _344 + 0.6252607107162476f;
  float4 _348 = t5.SampleLevel(s2_space2, float3(_345, _346, _347), 0.0f);
  bool _354 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_354 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _358 = cb2_017x * _348.x;
    float _359 = cb2_017x * _348.y;
    float _360 = cb2_017x * _348.z;
    float _362 = _358 + cb2_017y;
    float _363 = _359 + cb2_017y;
    float _364 = _360 + cb2_017y;
    float _365 = exp2(_362);
    float _366 = exp2(_363);
    float _367 = exp2(_364);
    float _368 = _365 + 1.0f;
    float _369 = _366 + 1.0f;
    float _370 = _367 + 1.0f;
    float _371 = 1.0f / _368;
    float _372 = 1.0f / _369;
    float _373 = 1.0f / _370;
    float _375 = cb2_017z * _371;
    float _376 = cb2_017z * _372;
    float _377 = cb2_017z * _373;
    float _379 = _375 + cb2_017w;
    float _380 = _376 + cb2_017w;
    float _381 = _377 + cb2_017w;
    _383 = _379;
    _384 = _380;
    _385 = _381;
  } else {
    _383 = _348.x;
    _384 = _348.y;
    _385 = _348.z;
  }
  float _386 = _383 * 23.0f;
  float _387 = _386 + -14.473931312561035f;
  float _388 = exp2(_387);
  float _389 = _384 * 23.0f;
  float _390 = _389 + -14.473931312561035f;
  float _391 = exp2(_390);
  float _392 = _385 * 23.0f;
  float _393 = _392 + -14.473931312561035f;
  float _394 = exp2(_393);
  float _398 = cb2_004x * TEXCOORD0_centroid.x;
  float _399 = cb2_004y * TEXCOORD0_centroid.y;
  float _402 = _398 + cb2_004z;
  float _403 = _399 + cb2_004w;
  float4 _409 = t7.Sample(s2_space2, float2(_402, _403));
  float _414 = _409.x * cb2_003x;
  float _415 = _409.y * cb2_003y;
  float _416 = _409.z * cb2_003z;
  float _417 = _409.w * cb2_003w;
  float _420 = _417 + cb2_026y;
  float _421 = saturate(_420);
  bool _424 = ((uint)(cb2_069y) == 0);
  if (!_424) {
    float _426 = _414 * _318;
    float _427 = _415 * _318;
    float _428 = _416 * _318;
    _430 = _426;
    _431 = _427;
    _432 = _428;
  } else {
    _430 = _414;
    _431 = _415;
    _432 = _416;
  }
  bool _435 = ((uint)(cb2_028x) == 2);
  bool _436 = ((uint)(cb2_028x) == 3);
  int _437 = (uint)(cb2_028x) & -2;
  bool _438 = (_437 == 2);
  bool _439 = ((uint)(cb2_028x) == 6);
  bool _440 = _438 || _439;
  if (_440) {
    float _442 = _430 * _421;
    float _443 = _431 * _421;
    float _444 = _432 * _421;
    float _445 = _421 * _421;
    _477 = _442;
    _478 = _443;
    _479 = _444;
    _480 = _445;
  } else {
    bool _447 = ((uint)(cb2_028x) == 4);
    if (_447) {
      float _449 = _430 + -1.0f;
      float _450 = _431 + -1.0f;
      float _451 = _432 + -1.0f;
      float _452 = _421 + -1.0f;
      float _453 = _449 * _421;
      float _454 = _450 * _421;
      float _455 = _451 * _421;
      float _456 = _452 * _421;
      float _457 = _453 + 1.0f;
      float _458 = _454 + 1.0f;
      float _459 = _455 + 1.0f;
      float _460 = _456 + 1.0f;
      _477 = _457;
      _478 = _458;
      _479 = _459;
      _480 = _460;
    } else {
      bool _462 = ((uint)(cb2_028x) == 5);
      if (_462) {
        float _464 = _430 + -0.5f;
        float _465 = _431 + -0.5f;
        float _466 = _432 + -0.5f;
        float _467 = _421 + -0.5f;
        float _468 = _464 * _421;
        float _469 = _465 * _421;
        float _470 = _466 * _421;
        float _471 = _467 * _421;
        float _472 = _468 + 0.5f;
        float _473 = _469 + 0.5f;
        float _474 = _470 + 0.5f;
        float _475 = _471 + 0.5f;
        _477 = _472;
        _478 = _473;
        _479 = _474;
        _480 = _475;
      } else {
        _477 = _430;
        _478 = _431;
        _479 = _432;
        _480 = _421;
      }
    }
  }
  if (_435) {
    float _482 = _477 + _388;
    float _483 = _478 + _391;
    float _484 = _479 + _394;
    _527 = _482;
    _528 = _483;
    _529 = _484;
  } else {
    if (_436) {
      float _487 = 1.0f - _477;
      float _488 = 1.0f - _478;
      float _489 = 1.0f - _479;
      float _490 = _487 * _388;
      float _491 = _488 * _391;
      float _492 = _489 * _394;
      float _493 = _490 + _477;
      float _494 = _491 + _478;
      float _495 = _492 + _479;
      _527 = _493;
      _528 = _494;
      _529 = _495;
    } else {
      bool _497 = ((uint)(cb2_028x) == 4);
      if (_497) {
        float _499 = _477 * _388;
        float _500 = _478 * _391;
        float _501 = _479 * _394;
        _527 = _499;
        _528 = _500;
        _529 = _501;
      } else {
        bool _503 = ((uint)(cb2_028x) == 5);
        if (_503) {
          float _505 = _388 * 2.0f;
          float _506 = _505 * _477;
          float _507 = _391 * 2.0f;
          float _508 = _507 * _478;
          float _509 = _394 * 2.0f;
          float _510 = _509 * _479;
          _527 = _506;
          _528 = _508;
          _529 = _510;
        } else {
          if (_439) {
            float _513 = _388 - _477;
            float _514 = _391 - _478;
            float _515 = _394 - _479;
            _527 = _513;
            _528 = _514;
            _529 = _515;
          } else {
            float _517 = _477 - _388;
            float _518 = _478 - _391;
            float _519 = _479 - _394;
            float _520 = _480 * _517;
            float _521 = _480 * _518;
            float _522 = _480 * _519;
            float _523 = _520 + _388;
            float _524 = _521 + _391;
            float _525 = _522 + _394;
            _527 = _523;
            _528 = _524;
            _529 = _525;
          }
        }
      }
    }
  }
  float _535 = cb2_016x - _527;
  float _536 = cb2_016y - _528;
  float _537 = cb2_016z - _529;
  float _538 = _535 * cb2_016w;
  float _539 = _536 * cb2_016w;
  float _540 = _537 * cb2_016w;
  float _541 = _538 + _527;
  float _542 = _539 + _528;
  float _543 = _540 + _529;
  bool _546 = ((int)(uint)(cb1_018w) > (int)-1);
  if (_546 && RENODX_TONE_MAP_TYPE == 0.f) {
    float _550 = cb2_024x * _541;
    float _551 = cb2_024x * _542;
    float _552 = cb2_024x * _543;
    _554 = _550;
    _555 = _551;
    _556 = _552;
  } else {
    _554 = _541;
    _555 = _542;
    _556 = _543;
  }
  float _559 = _554 * 0.9708889722824097f;
  float _560 = mad(0.026962999254465103f, _555, _559);
  float _561 = mad(0.002148000057786703f, _556, _560);
  float _562 = _554 * 0.01088900025933981f;
  float _563 = mad(0.9869629740715027f, _555, _562);
  float _564 = mad(0.002148000057786703f, _556, _563);
  float _565 = mad(0.026962999254465103f, _555, _562);
  float _566 = mad(0.9621480107307434f, _556, _565);
  float _567 = max(_561, 0.0f);
  float _568 = max(_564, 0.0f);
  float _569 = max(_566, 0.0f);
  float _570 = min(_567, cb2_095y);
  float _571 = min(_568, cb2_095y);
  float _572 = min(_569, cb2_095y);
  bool _575 = ((uint)(cb2_095x) == 0);
  bool _578 = ((uint)(cb2_094w) == 0);
  bool _580 = ((uint)(cb2_094z) == 0);
  bool _582 = ((uint)(cb2_094y) != 0);
  bool _584 = ((uint)(cb2_094x) == 0);
  bool _586 = ((uint)(cb2_069z) != 0);
  float _633 = asfloat((uint)(cb2_075y));
  float _634 = asfloat((uint)(cb2_075z));
  float _635 = asfloat((uint)(cb2_075w));
  float _636 = asfloat((uint)(cb2_074z));
  float _637 = asfloat((uint)(cb2_074w));
  float _638 = asfloat((uint)(cb2_075x));
  float _639 = asfloat((uint)(cb2_073w));
  float _640 = asfloat((uint)(cb2_074x));
  float _641 = asfloat((uint)(cb2_074y));
  float _642 = asfloat((uint)(cb2_077x));
  float _643 = asfloat((uint)(cb2_077y));
  float _644 = asfloat((uint)(cb2_079x));
  float _645 = asfloat((uint)(cb2_079y));
  float _646 = asfloat((uint)(cb2_079z));
  float _647 = asfloat((uint)(cb2_078y));
  float _648 = asfloat((uint)(cb2_078z));
  float _649 = asfloat((uint)(cb2_078w));
  float _650 = asfloat((uint)(cb2_077z));
  float _651 = asfloat((uint)(cb2_077w));
  float _652 = asfloat((uint)(cb2_078x));
  float _653 = asfloat((uint)(cb2_072y));
  float _654 = asfloat((uint)(cb2_072z));
  float _655 = asfloat((uint)(cb2_072w));
  float _656 = asfloat((uint)(cb2_071x));
  float _657 = asfloat((uint)(cb2_071y));
  float _658 = asfloat((uint)(cb2_076x));
  float _659 = asfloat((uint)(cb2_070w));
  float _660 = asfloat((uint)(cb2_070x));
  float _661 = asfloat((uint)(cb2_070y));
  float _662 = asfloat((uint)(cb2_070z));
  float _663 = asfloat((uint)(cb2_073x));
  float _664 = asfloat((uint)(cb2_073y));
  float _665 = asfloat((uint)(cb2_073z));
  float _666 = asfloat((uint)(cb2_071z));
  float _667 = asfloat((uint)(cb2_071w));
  float _668 = asfloat((uint)(cb2_072x));
  float _669 = max(_571, _572);
  float _670 = max(_570, _669);
  float _671 = 1.0f / _670;
  float _672 = _671 * _570;
  float _673 = _671 * _571;
  float _674 = _671 * _572;
  float _675 = abs(_672);
  float _676 = log2(_675);
  float _677 = _676 * _660;
  float _678 = exp2(_677);
  float _679 = abs(_673);
  float _680 = log2(_679);
  float _681 = _680 * _661;
  float _682 = exp2(_681);
  float _683 = abs(_674);
  float _684 = log2(_683);
  float _685 = _684 * _662;
  float _686 = exp2(_685);
  if (_582) {
    float _689 = asfloat((uint)(cb2_076w));
    float _691 = asfloat((uint)(cb2_076z));
    float _693 = asfloat((uint)(cb2_076y));
    float _694 = _691 * _571;
    float _695 = _693 * _570;
    float _696 = _689 * _572;
    float _697 = _695 + _696;
    float _698 = _697 + _694;
    _706 = _698;
  } else {
    float _700 = _667 * _571;
    float _701 = _666 * _570;
    float _702 = _668 * _572;
    float _703 = _700 + _701;
    float _704 = _703 + _702;
    _706 = _704;
  }
  float _707 = abs(_706);
  float _708 = log2(_707);
  float _709 = _708 * _659;
  float _710 = exp2(_709);
  float _711 = log2(_710);
  float _712 = _711 * _658;
  float _713 = exp2(_712);
  float _714 = select(_586, _713, _710);
  float _715 = _714 * _656;
  float _716 = _715 + _657;
  float _717 = 1.0f / _716;
  float _718 = _717 * _710;
  if (_582) {
    if (!_584) {
      float _721 = _678 * _650;
      float _722 = _682 * _651;
      float _723 = _686 * _652;
      float _724 = _722 + _721;
      float _725 = _724 + _723;
      float _726 = _682 * _648;
      float _727 = _678 * _647;
      float _728 = _686 * _649;
      float _729 = _726 + _727;
      float _730 = _729 + _728;
      float _731 = _686 * _646;
      float _732 = _682 * _645;
      float _733 = _678 * _644;
      float _734 = _732 + _733;
      float _735 = _734 + _731;
      float _736 = max(_730, _735);
      float _737 = max(_725, _736);
      float _738 = 1.0f / _737;
      float _739 = _738 * _725;
      float _740 = _738 * _730;
      float _741 = _738 * _735;
      _743 = _739;
      _744 = _740;
      _745 = _741;
    } else {
      _743 = _678;
      _744 = _682;
      _745 = _686;
    }
    float _746 = _743 * _643;
    float _747 = exp2(_746);
    float _748 = _747 * _642;
    float _749 = saturate(_748);
    float _750 = _743 * _642;
    float _751 = _743 - _750;
    float _752 = saturate(_751);
    float _753 = max(_642, _752);
    float _754 = min(_753, _749);
    float _755 = _744 * _643;
    float _756 = exp2(_755);
    float _757 = _756 * _642;
    float _758 = saturate(_757);
    float _759 = _744 * _642;
    float _760 = _744 - _759;
    float _761 = saturate(_760);
    float _762 = max(_642, _761);
    float _763 = min(_762, _758);
    float _764 = _745 * _643;
    float _765 = exp2(_764);
    float _766 = _765 * _642;
    float _767 = saturate(_766);
    float _768 = _745 * _642;
    float _769 = _745 - _768;
    float _770 = saturate(_769);
    float _771 = max(_642, _770);
    float _772 = min(_771, _767);
    _774 = _754;
    _775 = _763;
    _776 = _772;
  } else {
    _774 = _678;
    _775 = _682;
    _776 = _686;
  }
  float _777 = _774 * _666;
  float _778 = _775 * _667;
  float _779 = _778 + _777;
  float _780 = _776 * _668;
  float _781 = _779 + _780;
  float _782 = 1.0f / _781;
  float _783 = _782 * _718;
  float _784 = saturate(_783);
  float _785 = _784 * _774;
  float _786 = saturate(_785);
  float _787 = _784 * _775;
  float _788 = saturate(_787);
  float _789 = _784 * _776;
  float _790 = saturate(_789);
  float _791 = _786 * _653;
  float _792 = _653 - _791;
  float _793 = _788 * _654;
  float _794 = _654 - _793;
  float _795 = _790 * _655;
  float _796 = _655 - _795;
  float _797 = _790 * _668;
  float _798 = _786 * _666;
  float _799 = _788 * _667;
  float _800 = _718 - _798;
  float _801 = _800 - _799;
  float _802 = _801 - _797;
  float _803 = saturate(_802);
  float _804 = _794 * _667;
  float _805 = _792 * _666;
  float _806 = _796 * _668;
  float _807 = _804 + _805;
  float _808 = _807 + _806;
  float _809 = 1.0f / _808;
  float _810 = _809 * _803;
  float _811 = _810 * _792;
  float _812 = _811 + _786;
  float _813 = saturate(_812);
  float _814 = _810 * _794;
  float _815 = _814 + _788;
  float _816 = saturate(_815);
  float _817 = _810 * _796;
  float _818 = _817 + _790;
  float _819 = saturate(_818);
  float _820 = _819 * _668;
  float _821 = _813 * _666;
  float _822 = _816 * _667;
  float _823 = _718 - _821;
  float _824 = _823 - _822;
  float _825 = _824 - _820;
  float _826 = saturate(_825);
  float _827 = _826 * _663;
  float _828 = _827 + _813;
  float _829 = saturate(_828);
  float _830 = _826 * _664;
  float _831 = _830 + _816;
  float _832 = saturate(_831);
  float _833 = _826 * _665;
  float _834 = _833 + _819;
  float _835 = saturate(_834);
  if (!_580) {
    float _837 = _829 * _639;
    float _838 = _832 * _640;
    float _839 = _835 * _641;
    float _840 = _838 + _837;
    float _841 = _840 + _839;
    float _842 = _832 * _637;
    float _843 = _829 * _636;
    float _844 = _835 * _638;
    float _845 = _842 + _843;
    float _846 = _845 + _844;
    float _847 = _835 * _635;
    float _848 = _832 * _634;
    float _849 = _829 * _633;
    float _850 = _848 + _849;
    float _851 = _850 + _847;
    if (!_578) {
      float _853 = saturate(_841);
      float _854 = saturate(_846);
      float _855 = saturate(_851);
      _857 = _855;
      _858 = _854;
      _859 = _853;
    } else {
      _857 = _851;
      _858 = _846;
      _859 = _841;
    }
  } else {
    _857 = _835;
    _858 = _832;
    _859 = _829;
  }
  if (!_575) {
    float _861 = _859 * _639;
    float _862 = _858 * _639;
    float _863 = _857 * _639;
    _865 = _863;
    _866 = _862;
    _867 = _861;
  } else {
    _865 = _857;
    _866 = _858;
    _867 = _859;
  }
  if (_546) {
    float _871 = cb1_018z * 9.999999747378752e-05f;
    float _872 = _871 * _867;
    float _873 = _871 * _866;
    float _874 = _871 * _865;
    float _876 = 5000.0f / cb1_018y;
    float _877 = _872 * _876;
    float _878 = _873 * _876;
    float _879 = _874 * _876;
    _881 = _877;
    _882 = _878;
    _883 = _879;
  } else {
    _881 = _867;
    _882 = _866;
    _883 = _865;
  }
  float _884 = _881 * 1.6047500371932983f;
  float _885 = mad(-0.5310800075531006f, _882, _884);
  float _886 = mad(-0.07366999983787537f, _883, _885);
  float _887 = _881 * -0.10208000242710114f;
  float _888 = mad(1.1081299781799316f, _882, _887);
  float _889 = mad(-0.006049999967217445f, _883, _888);
  float _890 = _881 * -0.0032599999103695154f;
  float _891 = mad(-0.07275000214576721f, _882, _890);
  float _892 = mad(1.0760200023651123f, _883, _891);
  if (_546) {
    // float _894 = max(_886, 0.0f);
    // float _895 = max(_889, 0.0f);
    // float _896 = max(_892, 0.0f);
    // bool _897 = !(_894 >= 0.0030399328097701073f);
    // if (!_897) {
    //   float _899 = abs(_894);
    //   float _900 = log2(_899);
    //   float _901 = _900 * 0.4166666567325592f;
    //   float _902 = exp2(_901);
    //   float _903 = _902 * 1.0549999475479126f;
    //   float _904 = _903 + -0.054999999701976776f;
    //   _908 = _904;
    // } else {
    //   float _906 = _894 * 12.923210144042969f;
    //   _908 = _906;
    // }
    // bool _909 = !(_895 >= 0.0030399328097701073f);
    // if (!_909) {
    //   float _911 = abs(_895);
    //   float _912 = log2(_911);
    //   float _913 = _912 * 0.4166666567325592f;
    //   float _914 = exp2(_913);
    //   float _915 = _914 * 1.0549999475479126f;
    //   float _916 = _915 + -0.054999999701976776f;
    //   _920 = _916;
    // } else {
    //   float _918 = _895 * 12.923210144042969f;
    //   _920 = _918;
    // }
    // bool _921 = !(_896 >= 0.0030399328097701073f);
    // if (!_921) {
    //   float _923 = abs(_896);
    //   float _924 = log2(_923);
    //   float _925 = _924 * 0.4166666567325592f;
    //   float _926 = exp2(_925);
    //   float _927 = _926 * 1.0549999475479126f;
    //   float _928 = _927 + -0.054999999701976776f;
    //   _1001 = _908;
    //   _1002 = _920;
    //   _1003 = _928;
    // } else {
    //   float _930 = _896 * 12.923210144042969f;
    //   _1001 = _908;
    //   _1002 = _920;
    //   _1003 = _930;
    // }
    _1001 = renodx::color::srgb::EncodeSafe(_886);
    _1002 = renodx::color::srgb::EncodeSafe(_889);
    _1003 = renodx::color::srgb::EncodeSafe(_892);

  } else {
    float _932 = saturate(_886);
    float _933 = saturate(_889);
    float _934 = saturate(_892);
    bool _935 = ((uint)(cb1_018w) == -2);
    if (!_935) {
      bool _937 = !(_932 >= 0.0030399328097701073f);
      if (!_937) {
        float _939 = abs(_932);
        float _940 = log2(_939);
        float _941 = _940 * 0.4166666567325592f;
        float _942 = exp2(_941);
        float _943 = _942 * 1.0549999475479126f;
        float _944 = _943 + -0.054999999701976776f;
        _948 = _944;
      } else {
        float _946 = _932 * 12.923210144042969f;
        _948 = _946;
      }
      bool _949 = !(_933 >= 0.0030399328097701073f);
      if (!_949) {
        float _951 = abs(_933);
        float _952 = log2(_951);
        float _953 = _952 * 0.4166666567325592f;
        float _954 = exp2(_953);
        float _955 = _954 * 1.0549999475479126f;
        float _956 = _955 + -0.054999999701976776f;
        _960 = _956;
      } else {
        float _958 = _933 * 12.923210144042969f;
        _960 = _958;
      }
      bool _961 = !(_934 >= 0.0030399328097701073f);
      if (!_961) {
        float _963 = abs(_934);
        float _964 = log2(_963);
        float _965 = _964 * 0.4166666567325592f;
        float _966 = exp2(_965);
        float _967 = _966 * 1.0549999475479126f;
        float _968 = _967 + -0.054999999701976776f;
        _972 = _948;
        _973 = _960;
        _974 = _968;
      } else {
        float _970 = _934 * 12.923210144042969f;
        _972 = _948;
        _973 = _960;
        _974 = _970;
      }
    } else {
      _972 = _932;
      _973 = _933;
      _974 = _934;
    }
    float _979 = abs(_972);
    float _980 = abs(_973);
    float _981 = abs(_974);
    float _982 = log2(_979);
    float _983 = log2(_980);
    float _984 = log2(_981);
    float _985 = _982 * cb2_000z;
    float _986 = _983 * cb2_000z;
    float _987 = _984 * cb2_000z;
    float _988 = exp2(_985);
    float _989 = exp2(_986);
    float _990 = exp2(_987);
    float _991 = _988 * cb2_000y;
    float _992 = _989 * cb2_000y;
    float _993 = _990 * cb2_000y;
    float _994 = _991 + cb2_000x;
    float _995 = _992 + cb2_000x;
    float _996 = _993 + cb2_000x;
    float _997 = saturate(_994);
    float _998 = saturate(_995);
    float _999 = saturate(_996);
    _1001 = _997;
    _1002 = _998;
    _1003 = _999;
  }
  float _1004 = dot(float3(_1001, _1002, _1003), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  SV_Target.x = _1001;
  SV_Target.y = _1002;
  SV_Target.z = _1003;
  SV_Target.w = _1004;
  SV_Target_1.x = _1004;
  SV_Target_1.y = 0.0f;
  SV_Target_1.z = 0.0f;
  SV_Target_1.w = 0.0f;
  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
