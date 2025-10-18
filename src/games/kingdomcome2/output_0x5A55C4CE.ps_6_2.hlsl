#include "./shared.h"

Texture2D<float4> luminanceTex : register(t1);

Texture2D<float4> sunShaftsTex : register(t6);

Texture2D<float4> vignettingTex : register(t4);

Texture3D<float4> PostAA_Grain : register(t3);

Texture2D<float3> bloomTex : register(t2);

Texture2D<float4> colorChartTex : register(t5);

Texture2D<float3> hdrTex : register(t0);

cbuffer PER_BATCH : register(b0, space3) {
  float4 GrainParams : packoffset(c000.x);
  float4 HDRTonemappingParams : packoffset(c001.x);
  float4 HDRColorBalance : packoffset(c002.x);
  float4 SunShafts_SunCol : packoffset(c003.x);
  float4 HDREyeAdaptation : packoffset(c004.x);
  float4 HDRFilmCurve : packoffset(c005.x);
  float3 HDRBloomColor : packoffset(c006.x);
  float4 HDRDisplayParams : packoffset(c007.x);
  float4 HDRWhiteBalance : packoffset(c008.x);
  float4 PS_ScreenSize : packoffset(c009.x);
  float Time : packoffset(c010.x);
};

SamplerState linearClampSS : register(s7);

SamplerState PostAA_GrainSS : register(s8);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float4 TEXCOORD: TEXCOORD,
    linear float4 TEXCOORD_1: TEXCOORD1) : SV_Target {
  float4 SV_Target;
  float3 color_bt2020;
  float3 color_bt709;

  float _20 = HDRFilmCurve.x * 0.2199999988079071f;
  float _22 = HDRFilmCurve.y * 0.30000001192092896f;
  float _24 = HDRFilmCurve.z * 0.009999999776482582f;
  float _25 = _20 * _20;
  float _26 = _22 * _22;
  float _27 = HDRFilmCurve.w * HDRFilmCurve.w;
  float _28 = _25 * _27;
  float _30 = _27 * 0.30000001192092896f;
  float _31 = _30 * _25;
  float _38 = (_20 * HDRFilmCurve.w) * _22;
  float _44 = (HDRFilmCurve.x * 0.013200000859797001f) * _24;
  float _45 = HDRFilmCurve.x * 0.003960000351071358f;
  float _56 = (((((((_31 + _45) - (_28 * _24)) - (_31 * 0.18000000715255737f)) - (_38 * _24)) + (((HDRFilmCurve.w * 0.30000001192092896f) * _20) * _22)) - _44) - ((((HDRFilmCurve.w * 0.0066000004298985004f) * HDRFilmCurve.x) * _22) * 0.18000000715255737f)) + ((_24 * (_38 + _28)) * 0.18000000715255737f);
  float _62 = ((_20 * _27) * _22) * _24;
  float _67 = (HDRFilmCurve.w * 0.030000001192092896f) * _26;
  float _71 = (_24 * HDRFilmCurve.w) * _26;
  float _83 = ((((((((((HDRFilmCurve.x * 0.0066000004298985004f) * _27) * _22) + (HDRFilmCurve.y * 0.0005400000954978168f)) - _62) + _67) - _71) - ((HDRFilmCurve.y * 0.018000001087784767f) * _24)) - (((_30 * _20) * _22) * 0.18000000715255737f)) - (_67 * 0.18000000715255737f)) + ((_71 + _62) * 0.18000000715255737f);
  float _100 = (sqrt((_83 * _83) - (((((((HDRFilmCurve.w * 0.018000001087784767f) * HDRFilmCurve.y) * _24) - ((HDRFilmCurve.w * 0.0005400000954978168f) * HDRFilmCurve.y)) + ((_44 - _45) * _27)) * 0.7200000286102295f) * _56)) - _83) / (_56 * 2.0f);
  float _102 = 0.18000000715255737f / dot(float3(_100, _100, _100), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float4 _103 = vignettingTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float3 _105 = bloomTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float4 _109 = luminanceTex.Load(int3(0, 0, 0));
  float3 _113 = hdrTex.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  float4 _117 = sunShaftsTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float _131 = ((_117.x * 0.1599999964237213f) * SunShafts_SunCol.x) + _113.x;
  float _132 = ((_117.y * 0.1599999964237213f) * SunShafts_SunCol.y) + _113.y;
  float _133 = ((_117.z * 0.1599999964237213f) * SunShafts_SunCol.z) + _113.z;
  float _156 = (8333.3330078125f / exp2(min(max((log2(_109.y * 3030.30322265625f) - ((HDREyeAdaptation.z * 0.5f) * (min(max((log2((_109.y * 10000.0f) + 1.0f) * 0.3010300099849701f), 0.10000000149011612f), 5.199999809265137f) + -3.0f))), HDREyeAdaptation.x), HDREyeAdaptation.y) - HDREyeAdaptation.w)) * _103.x;
  float _173 = ((saturate(HDRBloomColor.x) * (_105.x - _131)) + _131) * _156;
  float _174 = ((saturate(HDRBloomColor.y) * (_105.y - _132)) + _132) * _156;
  float _175 = ((saturate(HDRBloomColor.z) * (_105.z - _133)) + _133) * _156;
  float _176 = dot(float3(_173, _174, _175), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _191 = ((HDRColorBalance.w * (_173 - _176)) + _176) * HDRColorBalance.x;
  float _192 = ((HDRColorBalance.w * (_174 - _176)) + _176) * HDRColorBalance.y;
  float _193 = (lerp(_176, _175, HDRColorBalance.w)) * HDRColorBalance.z;
  float _196 = max(_191, 0.0f);
  float _197 = max(_192, 0.0f);
  float _198 = max(_193, 0.0f);
  float _200 = HDRFilmCurve.x * 0.2199999988079071f;
  float _202 = HDRFilmCurve.y * 0.30000001192092896f;
  float _204 = _200 * _196;
  float _205 = _200 * _197;
  float _206 = _200 * _198;
  float _207 = _200 * HDRFilmCurve.w;
  float _208 = HDRFilmCurve.y * 0.030000001192092896f;
  float _217 = HDRFilmCurve.z * 0.0020000000949949026f;
  float _238 = HDRFilmCurve.z * 0.03333333134651184f;
  float _242 = ((((_207 + _208) * HDRFilmCurve.w) + _217) / (((_207 + _202) * HDRFilmCurve.w) + 0.06000000238418579f)) - _238;
  float _249 = saturate(saturate((((((_204 + _208) * _196) + _217) / (((_204 + _202) * _196) + 0.06000000238418579f)) - _238) / _242));
  float _250 = saturate(saturate((((((_205 + _208) * _197) + _217) / (((_205 + _202) * _197) + 0.06000000238418579f)) - _238) / _242));
  float _251 = saturate(saturate((((((_206 + _208) * _198) + _217) / (((_206 + _202) * _198) + 0.06000000238418579f)) - _238) / _242));
  float _281 = (saturate(select((_250 < 0.0031308000907301903f), (_250 * 12.920000076293945f), (((pow(_250, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f))) * 0.9375f) + 0.03125f;
  float _282 = saturate(select((_251 < 0.0031308000907301903f), (_251 * 12.920000076293945f), (((pow(_251, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f))) * 15.0f;
  float _283 = frac(_282);
  float _287 = ((((saturate(select((_249 < 0.0031308000907301903f), (_249 * 12.920000076293945f), (((pow(_249, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f))) * 0.9375f) + 0.03125f) - _283) + _282) * 0.0625f;
  float4 _288 = colorChartTex.Sample(linearClampSS, float2(_287, _281));
  float4 _293 = colorChartTex.Sample(linearClampSS, float2((_287 + 0.0625f), _281));
  float _303 = ((_293.x - _288.x) * _283) + _288.x;
  float _304 = ((_293.y - _288.y) * _283) + _288.y;
  float _305 = ((_293.z - _288.z) * _283) + _288.z;
  float4 _318 = PostAA_Grain.Sample(PostAA_GrainSS, float3(((GrainParams.y * TEXCOORD.x) * (PS_ScreenSize.x / PS_ScreenSize.y)), (GrainParams.y * TEXCOORD.y), (Time * 3.0f)));
  float _323 = GrainParams.x * (_318.x + -0.5f);
  float _324 = _323 + 0.5f;
  float _337 = 0.5f - _323;
  float _345 = (_303 * 2.0f) * _324;
  float _347 = (_304 * 2.0f) * _324;
  float _349 = (_305 * 2.0f) * _324;
  float _356 = (((1.0f - (((1.0f - _303) * 2.0f) * _337)) - _345) * select((_303 < 0.5f), 0.0f, 1.0f)) + _345;
  float _357 = (((1.0f - (((1.0f - _304) * 2.0f) * _337)) - _347) * select((_304 < 0.5f), 0.0f, 1.0f)) + _347;
  float _358 = (((1.0f - (((1.0f - _305) * 2.0f) * _337)) - _349) * select((_305 < 0.5f), 0.0f, 1.0f)) + _349;
  float _372 = HDRWhiteBalance.x * mad(0.008926319889724255f, _358, mad(0.5499410033226013f, _357, (_356 * 0.39040499925613403f)));
  float _373 = HDRWhiteBalance.y * mad(0.0013577500358223915f, _358, mad(0.9631720185279846f, _357, (_356 * 0.07084160298109055f)));
  float _374 = HDRWhiteBalance.z * mad(0.9362450242042542f, _358, mad(0.1280210018157959f, _357, (_356 * 0.02310819923877716f)));
  /* float _393 = saturate(exp2(log2(mad(-0.024891000241041183f, _374, mad(-1.628790020942688f, _373, (_372 * 2.8584699630737305f)))) * 2.200000047683716f));
  float _394 = saturate(exp2(log2(mad(0.00032428099075332284f, _374, mad(1.1582000255584717f, _373, (_372 * -0.21018199622631073f)))) * 2.200000047683716f));
  float _395 = saturate(exp2(log2(mad(1.0686700344085693f, _374, mad(-0.11816900223493576f, _373, (_372 * -0.041811998933553696f)))) * 2.200000047683716f));
   */
  float _393 = (mad(-0.024891000241041183f, _374, mad(-1.628790020942688f, _373, (_372 * 2.8584699630737305f))));
  float _394 = (mad(0.00032428099075332284f, _374, mad(1.1582000255584717f, _373, (_372 * -0.21018199622631073f))));
  float _395 = (mad(1.0686700344085693f, _374, mad(-0.11816900223493576f, _373, (_372 * -0.041811998933553696f))));

  float3 color_linear = float3(_393, _394, _395);

  if (RENODX_TONE_MAP_TYPE) {
    color_linear = renodx::color::srgb::DecodeSafe(color_linear);
  } else {
    color_linear = renodx::color::gamma::DecodeSafe(color_linear);
  }
  color_linear = saturate(color_linear);
  _393 = color_linear.r;
  _394 = color_linear.g;
  _395 = color_linear.b;

  float _399 = HDRFilmCurve.x * 0.2199999988079071f;
  float _401 = HDRFilmCurve.y * 0.30000001192092896f;
  float _403 = HDRFilmCurve.z * 0.009999999776482582f;
  float _404 = _399 * _399;
  float _405 = _401 * _401;
  float _406 = HDRFilmCurve.w * HDRFilmCurve.w;
  float _407 = _404 * _406;
  float _409 = _406 * 0.30000001192092896f;
  float _410 = _409 * _404;
  float _416 = ((HDRFilmCurve.w * 0.0066000004298985004f) * HDRFilmCurve.x) * _401;
  float _421 = (_399 * HDRFilmCurve.w) * _401;
  float _422 = _421 * _403;
  float _425 = ((HDRFilmCurve.w * 0.30000001192092896f) * _399) * _401;
  float _427 = (HDRFilmCurve.x * 0.013200000859797001f) * _403;
  float _428 = HDRFilmCurve.x * 0.003960000351071358f;
  float _430 = _403 * (_421 + _407);
  float _433 = (_410 + _428) - (_407 * _403);
  float _439 = (((((_433 - (_410 * _393)) - _422) + _425) - _427) - (_416 * _393)) + (_430 * _393);
  float _446 = (((((_433 - (_410 * _394)) - _422) + _425) - _427) - (_416 * _394)) + (_430 * _394);
  float _453 = (((((_433 - (_410 * _395)) - _422) + _425) - _427) - (_416 * _395)) + (_430 * _395);
  float _459 = ((_399 * _406) * _401) * _403;
  float _461 = (_409 * _399) * _401;
  float _466 = (HDRFilmCurve.w * 0.030000001192092896f) * _405;
  float _472 = (_403 * HDRFilmCurve.w) * _405;
  float _475 = _472 + _459;
  float _481 = (((((((HDRFilmCurve.x * 0.0066000004298985004f) * _406) * _401) + (HDRFilmCurve.y * 0.0005400000954978168f)) - _459) + _466) - _472) - ((HDRFilmCurve.y * 0.018000001087784767f) * _403);
  float _484 = ((_481 - (_461 * _393)) - (_466 * _393)) + (_475 * _393);
  float _488 = ((_481 - (_461 * _394)) - (_466 * _394)) + (_475 * _394);
  float _492 = ((_481 - (_461 * _395)) - (_466 * _395)) + (_475 * _395);
  float _501 = ((((HDRFilmCurve.w * 0.018000001087784767f) * HDRFilmCurve.y) * _403) - ((HDRFilmCurve.w * 0.0005400000954978168f) * HDRFilmCurve.y)) + ((_427 - _428) * _406);
  float _526 = (sqrt((_484 * _484) - (((_393 * 4.0f) * _501) * _439)) - _484) / (_439 * 2.0f);
  float _527 = (sqrt((_488 * _488) - (((_394 * 4.0f) * _501) * _446)) - _488) / (_446 * 2.0f);
  float _528 = (sqrt((_492 * _492) - (((_395 * 4.0f) * _501) * _453)) - _492) / (_453 * 2.0f);
  float _529 = dot(float3(_191, _192, _193), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _539 = ((max(1.0f, (_529 / max(1.0000000116860974e-07f, dot(float3(_526, _527, _528), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f))))) + -1.0f) * (1.0f - (saturate(_529) * 0.30000001192092896f))) + 1.0f;
  float _541 = (_526 * _102) * _539;
  float _543 = (_527 * _102) * _539;
  float _545 = (_528 * _102) * _539;

  color_bt2020 = renodx::color::bt2020::from::BT709(float3(_541, _543, _545));
  if (RENODX_TONE_MAP_TYPE) {
    _541 = color_bt2020.r;
    _543 = color_bt2020.g;
    _545 = color_bt2020.b;
  }
  float _555 = ((HDRDisplayParams.x - HDRTonemappingParams.y) * HDRTonemappingParams.z) / HDRTonemappingParams.x;
  float _556 = _555 + HDRTonemappingParams.y;
  float _560 = HDRDisplayParams.x - ((_555 * HDRTonemappingParams.x) + HDRTonemappingParams.y);
  float _562 = _541 / HDRTonemappingParams.y;
  float _563 = _543 / HDRTonemappingParams.y;
  float _564 = _545 / HDRTonemappingParams.y;
  float _565 = saturate(_562);
  float _566 = saturate(_563);
  float _567 = saturate(_564);
  float _575 = (_565 * _565) * (3.0f - (_565 * 2.0f));
  float _577 = (_566 * _566) * (3.0f - (_566 * 2.0f));
  float _579 = (_567 * _567) * (3.0f - (_567 * 2.0f));
  float _586 = select((_541 < _556), 0.0f, 1.0f);
  float _587 = select((_543 < _556), 0.0f, 1.0f);
  float _588 = select((_545 < _556), 0.0f, 1.0f);
  float _602 = (-0.0f - ((HDRDisplayParams.x * HDRTonemappingParams.x) / _560)) / HDRDisplayParams.x;
  float _645 = ((((1.0f - _575) * HDRTonemappingParams.y) * (pow(_562, HDRTonemappingParams.w))) + ((_575 - _586) * (lerp(HDRTonemappingParams.y, _541, HDRTonemappingParams.x)))) + ((HDRDisplayParams.x - (exp2(((_541 - _556) * 1.4426950216293335f) * _602) * _560)) * _586);
  float _646 = ((((1.0f - _577) * HDRTonemappingParams.y) * (pow(_563, HDRTonemappingParams.w))) + ((_577 - _587) * (lerp(HDRTonemappingParams.y, _543, HDRTonemappingParams.x)))) + ((HDRDisplayParams.x - (exp2(((_543 - _556) * 1.4426950216293335f) * _602) * _560)) * _587);
  float _647 = ((((1.0f - _579) * HDRTonemappingParams.y) * (pow(_564, HDRTonemappingParams.w))) + ((_579 - _588) * (lerp(HDRTonemappingParams.y, _545, HDRTonemappingParams.x)))) + ((HDRDisplayParams.x - (exp2(((_545 - _556) * 1.4426950216293335f) * _602) * _560)) * _588);
  color_bt709 = renodx::color::bt709::from::BT2020(float3(_645, _646, _647));
  if (RENODX_TONE_MAP_TYPE) {
    _645 = color_bt709.r;
    _646 = color_bt709.g;
    _647 = color_bt709.b;
  }

  // GamutExpansion
  if (RENODX_TONE_MAP_TYPE) {
    SV_Target.rgb = float3(_645, _646, _647);
    SV_Target.rgb = renodx::draw::ToneMapPass(SV_Target.rgb);
    SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  } else {
    float _659 = saturate((max(max(_645, _646), _647) + -1.5f) * 0.2222222238779068f);
    float _660 = 1.0f - _659;
    float _667 = (_660 * mad(0.17753799259662628f, _646, (_645 * 0.8224619626998901f))) + (_659 * _645);
    float _668 = (_660 * mad(0.9668058156967163f, _646, (_645 * 0.033194199204444885f))) + (_659 * _646);
    SV_Target.x = mad(-0.22494018077850342f, _668, (_667 * 1.2249401807785034f));
    SV_Target.y = mad(1.042056918144226f, _668, (_667 * -0.04205695539712906f));
    SV_Target.z = mad(1.0982736349105835f, ((_660 * mad(0.9105198979377747f, _647, mad(0.07239740341901779f, _646, (_645 * 0.017082631587982178f)))) + (_659 * _647)), mad(-0.0786360427737236f, _668, (_667 * -0.01963755488395691f)));
  }
  SV_Target.w = 1.0f;
  return SV_Target;
}
