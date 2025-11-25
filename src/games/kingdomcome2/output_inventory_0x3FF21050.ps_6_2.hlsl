#include "./shared.h"
#include "./common.hlsl"

Texture2D<float4> luminanceTex : register(t1);

Texture2D<float4> sunShaftsTex : register(t6);

Texture2D<float4> vignettingTex : register(t4);

Texture3D<float4> PostAA_Grain : register(t3);

Texture2D<float3> bloomTex : register(t2);

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

  float _19 = HDRFilmCurve.x * 0.2199999988079071f;
  float _21 = HDRFilmCurve.y * 0.30000001192092896f;
  float _23 = HDRFilmCurve.z * 0.009999999776482582f;
  float _24 = _19 * _19;
  float _25 = _21 * _21;
  float _26 = HDRFilmCurve.w * HDRFilmCurve.w;
  float _27 = _24 * _26;
  float _29 = _26 * 0.30000001192092896f;
  float _30 = _29 * _24;
  float _37 = (_19 * HDRFilmCurve.w) * _21;
  float _43 = (HDRFilmCurve.x * 0.013200000859797001f) * _23;
  float _44 = HDRFilmCurve.x * 0.003960000351071358f;
  float _55 = (((((((_30 + _44) - (_27 * _23)) - (_30 * 0.18000000715255737f)) - (_37 * _23)) + (((HDRFilmCurve.w * 0.30000001192092896f) * _19) * _21)) - _43) - ((((HDRFilmCurve.w * 0.0066000004298985004f) * HDRFilmCurve.x) * _21) * 0.18000000715255737f)) + ((_23 * (_37 + _27)) * 0.18000000715255737f);
  float _61 = ((_19 * _26) * _21) * _23;
  float _66 = (HDRFilmCurve.w * 0.030000001192092896f) * _25;
  float _70 = (_23 * HDRFilmCurve.w) * _25;
  float _82 = ((((((((((HDRFilmCurve.x * 0.0066000004298985004f) * _26) * _21) + (HDRFilmCurve.y * 0.0005400000954978168f)) - _61) + _66) - _70) - ((HDRFilmCurve.y * 0.018000001087784767f) * _23)) - (((_29 * _19) * _21) * 0.18000000715255737f)) - (_66 * 0.18000000715255737f)) + ((_70 + _61) * 0.18000000715255737f);
  float _99 = (sqrt((_82 * _82) - (((((((HDRFilmCurve.w * 0.018000001087784767f) * HDRFilmCurve.y) * _23) - ((HDRFilmCurve.w * 0.0005400000954978168f) * HDRFilmCurve.y)) + ((_43 - _44) * _26)) * 0.7200000286102295f) * _55)) - _82) / (_55 * 2.0f);
  float _101 = 0.18000000715255737f / dot(float3(_99, _99, _99), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float4 _102 = vignettingTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float3 _104 = bloomTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float4 _108 = luminanceTex.Load(int3(0, 0, 0));
  float3 _112 = hdrTex.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
  _112.rgb *= CalculateExposure(_108.y);  // New Luminance
  // Special case for inventory
  if (RENODX_TONE_MAP_TYPE) {
    _112.rgb *= 0.5f;
  }
  float4 _116 = sunShaftsTex.Sample(linearClampSS, float2(TEXCOORD_1.x, TEXCOORD_1.y));
  float _130 = ((_116.x * 0.1599999964237213f) * SunShafts_SunCol.x) + _112.x;
  float _131 = ((_116.y * 0.1599999964237213f) * SunShafts_SunCol.y) + _112.y;
  float _132 = ((_116.z * 0.1599999964237213f) * SunShafts_SunCol.z) + _112.z;
  float _155 = (8333.3330078125f / exp2(min(max((log2(_108.y * 3030.30322265625f) - ((HDREyeAdaptation.z * 0.5f) * (min(max((log2((_108.y * 10000.0f) + 1.0f) * 0.3010300099849701f), 0.10000000149011612f), 5.199999809265137f) + -3.0f))), HDREyeAdaptation.x), HDREyeAdaptation.y) - HDREyeAdaptation.w)) * _102.x;
  float _172 = ((saturate(HDRBloomColor.x) * (_104.x - _130)) + _130) * _155;
  float _173 = ((saturate(HDRBloomColor.y) * (_104.y - _131)) + _131) * _155;
  float _174 = ((saturate(HDRBloomColor.z) * (_104.z - _132)) + _132) * _155;
  float _175 = dot(float3(_172, _173, _174), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _190 = ((HDRColorBalance.w * (_172 - _175)) + _175) * HDRColorBalance.x;
  float _191 = ((HDRColorBalance.w * (_173 - _175)) + _175) * HDRColorBalance.y;
  float _192 = (lerp(_175, _174, HDRColorBalance.w)) * HDRColorBalance.z;
  float _195 = max(_190, 0.0f);
  float _196 = max(_191, 0.0f);
  float _197 = max(_192, 0.0f);
  float _199 = HDRFilmCurve.x * 0.2199999988079071f;
  float _201 = HDRFilmCurve.y * 0.30000001192092896f;
  float _203 = _199 * _195;
  float _204 = _199 * _196;
  float _205 = _199 * _197;
  float _206 = _199 * HDRFilmCurve.w;
  float _207 = HDRFilmCurve.y * 0.030000001192092896f;
  float _216 = HDRFilmCurve.z * 0.0020000000949949026f;
  float _237 = HDRFilmCurve.z * 0.03333333134651184f;
  float _241 = ((((_206 + _207) * HDRFilmCurve.w) + _216) / (((_206 + _201) * HDRFilmCurve.w) + 0.06000000238418579f)) - _237;
  float _248 = saturate(saturate((((((_203 + _207) * _195) + _216) / (((_203 + _201) * _195) + 0.06000000238418579f)) - _237) / _241));
  float _249 = saturate(saturate((((((_204 + _207) * _196) + _216) / (((_204 + _201) * _196) + 0.06000000238418579f)) - _237) / _241));
  float _250 = saturate(saturate((((((_205 + _207) * _197) + _216) / (((_205 + _201) * _197) + 0.06000000238418579f)) - _237) / _241));
  float _272 = select((_248 < 0.0031308000907301903f), (_248 * 12.920000076293945f), (((pow(_248, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  float _273 = select((_249 < 0.0031308000907301903f), (_249 * 12.920000076293945f), (((pow(_249, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  float _274 = select((_250 < 0.0031308000907301903f), (_250 * 12.920000076293945f), (((pow(_250, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f));
  float4 _287 = PostAA_Grain.Sample(PostAA_GrainSS, float3(((GrainParams.y * TEXCOORD.x) * (PS_ScreenSize.x / PS_ScreenSize.y)), (GrainParams.y * TEXCOORD.y), (Time * 3.0f)));
  float _292 = GrainParams.x * (_287.x + -0.5f);
  float _293 = _292 + 0.5f;
  float _306 = 0.5f - _292;
  float _314 = (_272 * 2.0f) * _293;
  float _316 = (_273 * 2.0f) * _293;
  float _318 = (_274 * 2.0f) * _293;
  float _337 = ((((1.0f - (((1.0f - _272) * 2.0f) * _306)) - _314) * select((_272 < 0.5f), 0.0f, 1.0f)) + _314);
  float _338 = ((((1.0f - (((1.0f - _273) * 2.0f) * _306)) - _316) * select((_273 < 0.5f), 0.0f, 1.0f)) + _316);
  float _339 = ((((1.0f - (((1.0f - _274) * 2.0f) * _306)) - _318) * select((_274 < 0.5f), 0.0f, 1.0f)) + _318);
  float3 color_linear = float3(_337, _338, _339);

  if (RENODX_TONE_MAP_TYPE) {
    color_linear = renodx::color::srgb::DecodeSafe(color_linear);
  } else {
    color_linear = renodx::color::gamma::DecodeSafe(color_linear);
  }
  color_linear = saturate(color_linear);
  _337 = color_linear.r;
  _338 = color_linear.g;
  _339 = color_linear.b;

  float _343 = HDRFilmCurve.x * 0.2199999988079071f;
  float _345 = HDRFilmCurve.y * 0.30000001192092896f;
  float _347 = HDRFilmCurve.z * 0.009999999776482582f;
  float _348 = _343 * _343;
  float _349 = _345 * _345;
  float _350 = HDRFilmCurve.w * HDRFilmCurve.w;
  float _351 = _348 * _350;
  float _353 = _350 * 0.30000001192092896f;
  float _354 = _353 * _348;
  float _360 = ((HDRFilmCurve.w * 0.0066000004298985004f) * HDRFilmCurve.x) * _345;
  float _365 = (_343 * HDRFilmCurve.w) * _345;
  float _366 = _365 * _347;
  float _369 = ((HDRFilmCurve.w * 0.30000001192092896f) * _343) * _345;
  float _371 = (HDRFilmCurve.x * 0.013200000859797001f) * _347;
  float _372 = HDRFilmCurve.x * 0.003960000351071358f;
  float _374 = _347 * (_365 + _351);
  float _377 = (_354 + _372) - (_351 * _347);
  float _383 = (((((_377 - (_354 * _337)) - _366) + _369) - _371) - (_360 * _337)) + (_374 * _337);
  float _390 = (((((_377 - (_354 * _338)) - _366) + _369) - _371) - (_360 * _338)) + (_374 * _338);
  float _397 = (((((_377 - (_354 * _339)) - _366) + _369) - _371) - (_360 * _339)) + (_374 * _339);
  float _403 = ((_343 * _350) * _345) * _347;
  float _405 = (_353 * _343) * _345;
  float _410 = (HDRFilmCurve.w * 0.030000001192092896f) * _349;
  float _416 = (_347 * HDRFilmCurve.w) * _349;
  float _419 = _416 + _403;
  float _425 = (((((((HDRFilmCurve.x * 0.0066000004298985004f) * _350) * _345) + (HDRFilmCurve.y * 0.0005400000954978168f)) - _403) + _410) - _416) - ((HDRFilmCurve.y * 0.018000001087784767f) * _347);
  float _428 = ((_425 - (_405 * _337)) - (_410 * _337)) + (_419 * _337);
  float _432 = ((_425 - (_405 * _338)) - (_410 * _338)) + (_419 * _338);
  float _436 = ((_425 - (_405 * _339)) - (_410 * _339)) + (_419 * _339);
  float _445 = ((((HDRFilmCurve.w * 0.018000001087784767f) * HDRFilmCurve.y) * _347) - ((HDRFilmCurve.w * 0.0005400000954978168f) * HDRFilmCurve.y)) + ((_371 - _372) * _350);
  float _470 = (sqrt((_428 * _428) - (((_337 * 4.0f) * _445) * _383)) - _428) / (_383 * 2.0f);
  float _471 = (sqrt((_432 * _432) - (((_338 * 4.0f) * _445) * _390)) - _432) / (_390 * 2.0f);
  float _472 = (sqrt((_436 * _436) - (((_339 * 4.0f) * _445) * _397)) - _436) / (_397 * 2.0f);
  float _473 = dot(float3(_190, _191, _192), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _483 = ((max(1.0f, (_473 / max(1.0000000116860974e-07f, dot(float3(_470, _471, _472), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f))))) + -1.0f) * (1.0f - (saturate(_473) * 0.30000001192092896f))) + 1.0f;
  float _485 = (_470 * _101) * _483;
  float _487 = (_471 * _101) * _483;
  float _489 = (_472 * _101) * _483;

  float _589 = _485;
  float _590 = _487;
  float _591 = _489;
  if (!RENODX_TONE_MAP_TYPE) {
    float _499 = ((HDRDisplayParams.x - HDRTonemappingParams.y) * HDRTonemappingParams.z) / HDRTonemappingParams.x;
    float _500 = _499 + HDRTonemappingParams.y;
    float _504 = HDRDisplayParams.x - ((_499 * HDRTonemappingParams.x) + HDRTonemappingParams.y);
    float _506 = _485 / HDRTonemappingParams.y;
    float _507 = _487 / HDRTonemappingParams.y;
    float _508 = _489 / HDRTonemappingParams.y;
    float _509 = saturate(_506);
    float _510 = saturate(_507);
    float _511 = saturate(_508);
    float _519 = (_509 * _509) * (3.0f - (_509 * 2.0f));
    float _521 = (_510 * _510) * (3.0f - (_510 * 2.0f));
    float _523 = (_511 * _511) * (3.0f - (_511 * 2.0f));
    float _530 = select((_485 < _500), 0.0f, 1.0f);
    float _531 = select((_487 < _500), 0.0f, 1.0f);
    float _532 = select((_489 < _500), 0.0f, 1.0f);
    float _546 = (-0.0f - ((HDRDisplayParams.x * HDRTonemappingParams.x) / _504)) / HDRDisplayParams.x;
    float _589 = ((((1.0f - _519) * HDRTonemappingParams.y) * (pow(_506, HDRTonemappingParams.w))) + ((_519 - _530) * (lerp(HDRTonemappingParams.y, _485, HDRTonemappingParams.x)))) + ((HDRDisplayParams.x - (exp2(((_485 - _500) * 1.4426950216293335f) * _546) * _504)) * _530);
    float _590 = ((((1.0f - _521) * HDRTonemappingParams.y) * (pow(_507, HDRTonemappingParams.w))) + ((_521 - _531) * (lerp(HDRTonemappingParams.y, _487, HDRTonemappingParams.x)))) + ((HDRDisplayParams.x - (exp2(((_487 - _500) * 1.4426950216293335f) * _546) * _504)) * _531);
    float _591 = ((((1.0f - _523) * HDRTonemappingParams.y) * (pow(_508, HDRTonemappingParams.w))) + ((_523 - _532) * (lerp(HDRTonemappingParams.y, _489, HDRTonemappingParams.x)))) + ((HDRDisplayParams.x - (exp2(((_489 - _500) * 1.4426950216293335f) * _546) * _504)) * _532);
  }

  if (RENODX_TONE_MAP_TYPE) {
    SV_Target.rgb = float3(_589, _590, _591);
    SV_Target.rgb = renodx::draw::ToneMapPass(SV_Target.rgb);
    SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  } else {
    // GamutExpansion
    float _603 = saturate((max(max(_589, _590), _591) + -1.5f) * 0.2222222238779068f);
    float _604 = 1.0f - _603;
    float _611 = (_604 * mad(0.17753799259662628f, _590, (_589 * 0.8224619626998901f))) + (_603 * _589);
    float _612 = (_604 * mad(0.9668058156967163f, _590, (_589 * 0.033194199204444885f))) + (_603 * _590);
    SV_Target.x = mad(-0.22494018077850342f, _612, (_611 * 1.2249401807785034f));
    SV_Target.y = mad(1.042056918144226f, _612, (_611 * -0.04205695539712906f));
    SV_Target.z = mad(1.0982736349105835f, ((_604 * mad(0.9105198979377747f, _591, mad(0.07239740341901779f, _590, (_589 * 0.017082631587982178f)))) + (_603 * _591)), mad(-0.0786360427737236f, _612, (_611 * -0.01963755488395691f)));
  }
  SV_Target.w = 1.0f;
  return SV_Target;
}
