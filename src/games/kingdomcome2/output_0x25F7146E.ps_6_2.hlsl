#include "./shared.h"
#include "./common.hlsl"

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
  _113.rgb *= CalculateExposure(_109.y);  // New Luminance
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
  float _249 = saturate((((((_204 + _208) * _196) + _217) / (((_204 + _202) * _196) + 0.06000000238418579f)) - _238) / _242);
  float _250 = saturate((((((_205 + _208) * _197) + _217) / (((_205 + _202) * _197) + 0.06000000238418579f)) - _238) / _242);
  float _251 = saturate((((((_206 + _208) * _198) + _217) / (((_206 + _202) * _198) + 0.06000000238418579f)) - _238) / _242);
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

  /* float _368 = saturate(exp2(log2((((1.0f - (((1.0f - _303) * 2.0f) * _337)) - _345) * select((_303 < 0.5f), 0.0f, 1.0f)) + _345) * 2.200000047683716f));
  float _369 = saturate(exp2(log2((((1.0f - (((1.0f - _304) * 2.0f) * _337)) - _347) * select((_304 < 0.5f), 0.0f, 1.0f)) + _347) * 2.200000047683716f));
  float _370 = saturate(exp2(log2((((1.0f - (((1.0f - _305) * 2.0f) * _337)) - _349) * select((_305 < 0.5f), 0.0f, 1.0f)) + _349) * 2.200000047683716f)); */
  // Film grain
  float _368 = ((((1.0f - (((1.0f - _303) * 2.0f) * _337)) - _345) * select((_303 < 0.5f), 0.0f, 1.0f)) + _345);
  float _369 = ((((1.0f - (((1.0f - _304) * 2.0f) * _337)) - _347) * select((_304 < 0.5f), 0.0f, 1.0f)) + _347);
  float _370 = ((((1.0f - (((1.0f - _305) * 2.0f) * _337)) - _349) * select((_305 < 0.5f), 0.0f, 1.0f)) + _349);
  float3 color_linear = float3(_368, _369, _370);

  if (RENODX_TONE_MAP_TYPE) {
    color_linear = renodx::color::srgb::DecodeSafe(color_linear);
  } else {
    color_linear = renodx::color::gamma::DecodeSafe(color_linear);
  }
  color_linear = saturate(color_linear);
  _368 = color_linear.r;
  _369 = color_linear.g;
  _370 = color_linear.b;

  // Inverse Hable tonemapper
  float _374 = HDRFilmCurve.x * 0.2199999988079071f;
  float _376 = HDRFilmCurve.y * 0.30000001192092896f;
  float _378 = HDRFilmCurve.z * 0.009999999776482582f;
  float _379 = _374 * _374;
  float _380 = _376 * _376;
  float _381 = HDRFilmCurve.w * HDRFilmCurve.w;
  float _382 = _379 * _381;
  float _384 = _381 * 0.30000001192092896f;
  float _385 = _384 * _379;
  float _391 = ((HDRFilmCurve.w * 0.0066000004298985004f) * HDRFilmCurve.x) * _376;
  float _396 = (_374 * HDRFilmCurve.w) * _376;
  float _397 = _396 * _378;
  float _400 = ((HDRFilmCurve.w * 0.30000001192092896f) * _374) * _376;
  float _402 = (HDRFilmCurve.x * 0.013200000859797001f) * _378;
  float _403 = HDRFilmCurve.x * 0.003960000351071358f;
  float _405 = _378 * (_396 + _382);
  float _408 = (_385 + _403) - (_382 * _378);
  float _414 = (((((_408 - (_385 * _368)) - _397) + _400) - _402) - (_391 * _368)) + (_405 * _368);
  float _421 = (((((_408 - (_385 * _369)) - _397) + _400) - _402) - (_391 * _369)) + (_405 * _369);
  float _428 = (((((_408 - (_385 * _370)) - _397) + _400) - _402) - (_391 * _370)) + (_405 * _370);
  float _434 = ((_374 * _381) * _376) * _378;
  float _436 = (_384 * _374) * _376;
  float _441 = (HDRFilmCurve.w * 0.030000001192092896f) * _380;
  float _447 = (_378 * HDRFilmCurve.w) * _380;
  float _450 = _447 + _434;
  float _456 = (((((((HDRFilmCurve.x * 0.0066000004298985004f) * _381) * _376) + (HDRFilmCurve.y * 0.0005400000954978168f)) - _434) + _441) - _447) - ((HDRFilmCurve.y * 0.018000001087784767f) * _378);
  float _459 = ((_456 - (_436 * _368)) - (_441 * _368)) + (_450 * _368);
  float _463 = ((_456 - (_436 * _369)) - (_441 * _369)) + (_450 * _369);
  float _467 = ((_456 - (_436 * _370)) - (_441 * _370)) + (_450 * _370);
  float _476 = ((((HDRFilmCurve.w * 0.018000001087784767f) * HDRFilmCurve.y) * _378) - ((HDRFilmCurve.w * 0.0005400000954978168f) * HDRFilmCurve.y)) + ((_402 - _403) * _381);
  float _501 = (sqrt((_459 * _459) - (((_368 * 4.0f) * _476) * _414)) - _459) / (_414 * 2.0f);
  float _502 = (sqrt((_463 * _463) - (((_369 * 4.0f) * _476) * _421)) - _463) / (_421 * 2.0f);
  float _503 = (sqrt((_467 * _467) - (((_370 * 4.0f) * _476) * _428)) - _467) / (_428 * 2.0f);

  // WH[DH]: Restore original luminance after clipping by Hable tonemapper
  /* color_bt709 = float3(_501, _502, _503);
  color_bt709 *= _102;
  _501 = color_bt709.r;
  _502 = color_bt709.g;
  _503 = color_bt709.b; */

  float _504 = dot(float3(_191, _192, _193), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  float _514 = ((max(1.0f, (_504 / max(1.0000000116860974e-07f, dot(float3(_501, _502, _503), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f))))) + -1.0f) * (1.0f - (saturate(_504) * 0.30000001192092896f))) + 1.0f;
  float _516 = (_501 * _102) * _514;
  float _518 = (_502 * _102) * _514;
  float _520 = (_503 * _102) * _514;
  /* float _516 = _501 * _514;
  float _518 = _502 * _514;
  float _520 = _503 * _514; */

  float _620 = _516;
  float _621 = _518;
  float _622 = _520;
  if (!RENODX_TONE_MAP_TYPE) {
    // GT tonemapper
    // Sky brightness I think
    float brightness = HDRDisplayParams.x;  // 19.3 by day 10 by night
    float contrast = HDRTonemappingParams.y;
    float shadow = HDRTonemappingParams.w;

    float _530 = ((brightness - contrast) * HDRTonemappingParams.z) / HDRTonemappingParams.x;
    float _531 = _530 + contrast;
    float _535 = brightness - ((_530 * HDRTonemappingParams.x) + contrast);
    float _537 = _516 / contrast;
    float _538 = _518 / contrast;
    float _539 = _520 / contrast;
    float _540 = saturate(_537);
    float _541 = saturate(_538);
    float _542 = saturate(_539);
    float _550 = (_540 * _540) * (3.0f - (_540 * 2.0f));
    float _552 = (_541 * _541) * (3.0f - (_541 * 2.0f));
    float _554 = (_542 * _542) * (3.0f - (_542 * 2.0f));
    float _561 = select((_516 < _531), 0.0f, 1.0f);
    float _562 = select((_518 < _531), 0.0f, 1.0f);
    float _563 = select((_520 < _531), 0.0f, 1.0f);
    float _577 = (-0.0f - ((brightness * HDRTonemappingParams.x) / _535)) / brightness;
    _620 = ((((1.0f - _550) * contrast) * (pow(_537, shadow))) + ((_550 - _561) * (lerp(contrast, _516, HDRTonemappingParams.x)))) + ((brightness - (exp2(((_516 - _531) * 1.4426950216293335f) * _577) * _535)) * _561);
    _621 = ((((1.0f - _552) * contrast) * (pow(_538, shadow))) + ((_552 - _562) * (lerp(contrast, _518, HDRTonemappingParams.x)))) + ((brightness - (exp2(((_518 - _531) * 1.4426950216293335f) * _577) * _535)) * _562);
    _622 = ((((1.0f - _554) * contrast) * (pow(_539, shadow))) + ((_554 - _563) * (lerp(contrast, _520, HDRTonemappingParams.x)))) + ((brightness - (exp2(((_520 - _531) * 1.4426950216293335f) * _577) * _535)) * _563);
  }

  if (RENODX_TONE_MAP_TYPE) {
    SV_Target.rgb = float3(_620, _621, _622);
    SV_Target.rgb = renodx::draw::ToneMapPass(SV_Target.rgb);
    SV_Target.rgb = renodx::draw::RenderIntermediatePass(SV_Target.rgb);
  } else {
    // GamutExpansion
    float _634 = saturate((max(max(_620, _621), _622) + -1.5f) * 0.2222222238779068f);
    float _635 = 1.0f - _634;
    float _642 = (_635 * mad(0.17753799259662628f, _621, (_620 * 0.8224619626998901f))) + (_634 * _620);
    float _643 = (_635 * mad(0.9668058156967163f, _621, (_620 * 0.033194199204444885f))) + (_634 * _621);
    SV_Target.x = mad(-0.22494018077850342f, _643, (_642 * 1.2249401807785034f));
    SV_Target.y = mad(1.042056918144226f, _643, (_642 * -0.04205695539712906f));
    SV_Target.z = mad(1.0982736349105835f, ((_635 * mad(0.9105198979377747f, _622, mad(0.07239740341901779f, _621, (_620 * 0.017082631587982178f)))) + (_634 * _622)), mad(-0.0786360427737236f, _643, (_642 * -0.01963755488395691f)));
  }

  SV_Target.w = 1.0f;
  return SV_Target;
}
