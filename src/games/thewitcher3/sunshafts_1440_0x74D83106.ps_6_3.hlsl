#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb3 : register(b3) {
  float4 CustomPixelConsts_000 : packoffset(c000.x);
  float4 CustomPixelConsts_016 : packoffset(c001.x);
  float4 CustomPixelConsts_032 : packoffset(c002.x);
  float4 CustomPixelConsts_048 : packoffset(c003.x);
  float4 CustomPixelConsts_064 : packoffset(c004.x);
  float4 CustomPixelConsts_080 : packoffset(c005.x);
  float4 CustomPixelConsts_096 : packoffset(c006.x);
  float4 CustomPixelConsts_112 : packoffset(c007.x);
  float4 CustomPixelConsts_128 : packoffset(c008.x);
  float4 CustomPixelConsts_144 : packoffset(c009.x);
  float4 CustomPixelConsts_160 : packoffset(c010.x);
  float4 CustomPixelConsts_176 : packoffset(c011.x);
  float4 CustomPixelConsts_192 : packoffset(c012.x);
  float4 CustomPixelConsts_208 : packoffset(c013.x);
  float4 CustomPixelConsts_224 : packoffset(c014.x);
  float4 CustomPixelConsts_240 : packoffset(c015.x);
  float4 CustomPixelConsts_256 : packoffset(c016.x);
  float4 CustomPixelConsts_272 : packoffset(c017.x);
  float4 CustomPixelConsts_288 : packoffset(c018.x);
  float4 CustomPixelConsts_304 : packoffset(c019.x);
  float4 CustomPixelConsts_320 : packoffset(c020.x);
  float4 CustomPixelConsts_336[4] : packoffset(c021.x);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position
) : SV_Target {
  float4 SV_Target;
  float _21 = float(int(CustomPixelConsts_048.x));
  float _22 = float(int(CustomPixelConsts_048.y));
  float _35 = float(int(SV_Position.x - float(int(CustomPixelConsts_048.z))));
  float _36 = float(int(SV_Position.y - float(int(CustomPixelConsts_048.w))));
  float _37 = _35 + 0.5f;
  float _38 = _36 + 0.5f;
  float _41 = (_37 + _21) / CustomPixelConsts_000.x;
  float _42 = (_38 + _22) / CustomPixelConsts_000.y;
  float _49 = (CustomPixelConsts_032.y + -1.0f) / CustomPixelConsts_000.y;
  float _52 = (CustomPixelConsts_064.x * ((CustomPixelConsts_032.x + -1.0f) / CustomPixelConsts_000.x)) + ((_21 + 0.5f) / CustomPixelConsts_000.x);
  float _53 = (CustomPixelConsts_064.y * _49) + ((_22 + 0.5f) / CustomPixelConsts_000.y);
  float _54 = _52 - _41;
  float _55 = _53 - _42;
  float _63 = rsqrt(dot(float2(_54, _55), float2(_54, _55)));
  float _64 = CustomPixelConsts_080.x * _49;
  float _65 = _64 * _63;
  float _69 = _63 * _55;
  float _70 = CustomPixelConsts_000.x / CustomPixelConsts_000.y;
  float _71 = (_63 * _54) * _70;
  float _75 = sqrt((_71 * _71) + (_69 * _69));
  float _76 = (_65 * _54) / _75;
  float _77 = (_65 * _55) / _75;
  float _78 = _76 * 0.05000000074505806f;
  float _79 = _77 * 0.05000000074505806f;
  bool _86 = (int(CustomPixelConsts_064.z) == 0);
  float _95;
  float _96;
  float _97;
  float _874;
  float _875;
  float _876;
  float _900;
  float _901;
  float _902;
  if (!_86) {
    float _88 = _76 * 0.0024999999441206455f;
    float _89 = _77 * 0.0024999999441206455f;
    _95 = _88;
    _96 = _89;
    _97 = sqrt((_89 * _89) + (_88 * _88));
  } else {
    _95 = _78;
    _96 = _79;
    _97 = sqrt((_79 * _79) + (_78 * _78));
  }
  int _118 = min(min(int((sqrt((_54 * _54) + (_55 * _55)) / _97) + 1.0f), int((select((_95 > 0.0f), ((CustomPixelConsts_032.x + -0.5f) - _37), _35) / (CustomPixelConsts_000.x * abs(_95))) + 1.0f)), int((select((_96 > 0.0f), ((CustomPixelConsts_032.y + -0.5f) - _38), _36) / (CustomPixelConsts_000.y * abs(_96))) + 1.0f));
  float _120 = _42 - _53;
  float _121 = _70 * (_41 - _52);
  float _127 = saturate(sqrt((_121 * _121) + (_120 * _120)) / _64);
  [branch]
  if (_127 < 1.0f) {
    float _131 = select(((int)_118 > (int)0), 1.0f, 0.0f);
    float _133 = select(((int)_118 > (int)1), 1.0f, 0.0f);
    float _134 = _95 + _41;
    float _135 = _96 + _42;
    float _137 = select(((int)_118 > (int)2), 1.0f, 0.0f);
    float _140 = (_95 * 2.0f) + _41;
    float _141 = (_96 * 2.0f) + _42;
    float _143 = select(((int)_118 > (int)3), 1.0f, 0.0f);
    float _146 = (_95 * 3.0f) + _41;
    float _147 = (_96 * 3.0f) + _42;
    float _149 = select(((int)_118 > (int)4), 1.0f, 0.0f);
    float _152 = (_95 * 4.0f) + _41;
    float _153 = (_96 * 4.0f) + _42;
    float _155 = select(((int)_118 > (int)5), 1.0f, 0.0f);
    float _158 = (_95 * 5.0f) + _41;
    float _159 = (_96 * 5.0f) + _42;
    float _161 = select(((int)_118 > (int)6), 1.0f, 0.0f);
    float _164 = (_95 * 6.0f) + _41;
    float _165 = (_96 * 6.0f) + _42;
    float _167 = select(((int)_118 > (int)7), 1.0f, 0.0f);
    float _170 = (_95 * 7.0f) + _41;
    float _171 = (_96 * 7.0f) + _42;
    float _173 = select(((int)_118 > (int)8), 1.0f, 0.0f);
    float _176 = (_95 * 8.0f) + _41;
    float _177 = (_96 * 8.0f) + _42;
    float _179 = select(((int)_118 > (int)9), 1.0f, 0.0f);
    float _182 = (_95 * 9.0f) + _41;
    float _183 = (_96 * 9.0f) + _42;
    float _185 = select(((int)_118 > (int)10), 1.0f, 0.0f);
    float _188 = (_95 * 10.0f) + _41;
    float _189 = (_96 * 10.0f) + _42;
    float _191 = select(((int)_118 > (int)11), 1.0f, 0.0f);
    float _194 = (_95 * 11.0f) + _41;
    float _195 = (_96 * 11.0f) + _42;
    float _197 = select(((int)_118 > (int)12), 1.0f, 0.0f);
    float _200 = (_95 * 12.0f) + _41;
    float _201 = (_96 * 12.0f) + _42;
    float _203 = select(((int)_118 > (int)13), 1.0f, 0.0f);
    float _206 = (_95 * 13.0f) + _41;
    float _207 = (_96 * 13.0f) + _42;
    float _209 = select(((int)_118 > (int)14), 1.0f, 0.0f);
    float _212 = (_95 * 14.0f) + _41;
    float _213 = (_96 * 14.0f) + _42;
    float _215 = select(((int)_118 > (int)15), 1.0f, 0.0f);
    float _218 = (_95 * 15.0f) + _41;
    float _219 = (_96 * 15.0f) + _42;
    float _221 = select(((int)_118 > (int)16), 1.0f, 0.0f);
    float _224 = (_95 * 16.0f) + _41;
    float _225 = (_96 * 16.0f) + _42;
    float _227 = select(((int)_118 > (int)17), 1.0f, 0.0f);
    float _230 = (_95 * 17.0f) + _41;
    float _231 = (_96 * 17.0f) + _42;
    float _233 = select(((int)_118 > (int)18), 1.0f, 0.0f);
    float _236 = (_95 * 18.0f) + _41;
    float _237 = (_96 * 18.0f) + _42;
    float _239 = select(((int)_118 > (int)19), 1.0f, 0.0f);
    float _242 = (_95 * 19.0f) + _41;
    float _243 = (_96 * 19.0f) + _42;
    [branch]
    if (!_86) {
      float4 _245 = t0.SampleLevel(s0, float2(_41, _42), 0.0f);
      float4 _252 = t0.SampleLevel(s0, float2(_134, _135), 0.0f);
      float4 _262 = t0.SampleLevel(s0, float2(_140, _141), 0.0f);
      float4 _272 = t0.SampleLevel(s0, float2(_146, _147), 0.0f);
      float4 _282 = t0.SampleLevel(s0, float2(_152, _153), 0.0f);
      float4 _292 = t0.SampleLevel(s0, float2(_158, _159), 0.0f);
      float4 _302 = t0.SampleLevel(s0, float2(_164, _165), 0.0f);
      float4 _312 = t0.SampleLevel(s0, float2(_170, _171), 0.0f);
      float4 _322 = t0.SampleLevel(s0, float2(_176, _177), 0.0f);
      float4 _332 = t0.SampleLevel(s0, float2(_182, _183), 0.0f);
      float4 _342 = t0.SampleLevel(s0, float2(_188, _189), 0.0f);
      float4 _352 = t0.SampleLevel(s0, float2(_194, _195), 0.0f);
      float4 _362 = t0.SampleLevel(s0, float2(_200, _201), 0.0f);
      float4 _372 = t0.SampleLevel(s0, float2(_206, _207), 0.0f);
      float4 _382 = t0.SampleLevel(s0, float2(_212, _213), 0.0f);
      float4 _392 = t0.SampleLevel(s0, float2(_218, _219), 0.0f);
      float4 _402 = t0.SampleLevel(s0, float2(_224, _225), 0.0f);
      float4 _412 = t0.SampleLevel(s0, float2(_230, _231), 0.0f);
      float4 _422 = t0.SampleLevel(s0, float2(_236, _237), 0.0f);
      float4 _432 = t0.SampleLevel(s0, float2(_242, _243), 0.0f);
      _874 = (((((((((((((((((((((_252.x * _133) + (_245.x * _131)) + (_262.x * _137)) + (_272.x * _143)) + (_282.x * _149)) + (_292.x * _155)) + (_302.x * _161)) + (_312.x * _167)) + (_322.x * _173)) + (_332.x * _179)) + (_342.x * _185)) + (_352.x * _191)) + (_362.x * _197)) + (_372.x * _203)) + (_382.x * _209)) + (_392.x * _215)) + (_402.x * _221)) + (_412.x * _227)) + (_422.x * _233)) + (_432.x * _239)) * CustomPixelConsts_096.x);
      _875 = (((((((((((((((((((((_252.y * _133) + (_245.y * _131)) + (_262.y * _137)) + (_272.y * _143)) + (_282.y * _149)) + (_292.y * _155)) + (_302.y * _161)) + (_312.y * _167)) + (_322.y * _173)) + (_332.y * _179)) + (_342.y * _185)) + (_352.y * _191)) + (_362.y * _197)) + (_372.y * _203)) + (_382.y * _209)) + (_392.y * _215)) + (_402.y * _221)) + (_412.y * _227)) + (_422.y * _233)) + (_432.y * _239)) * CustomPixelConsts_096.y);
      _876 = (((((((((((((((((((((_252.z * _133) + (_245.z * _131)) + (_262.z * _137)) + (_272.z * _143)) + (_282.z * _149)) + (_292.z * _155)) + (_302.z * _161)) + (_312.z * _167)) + (_322.z * _173)) + (_332.z * _179)) + (_342.z * _185)) + (_352.z * _191)) + (_362.z * _197)) + (_372.z * _203)) + (_382.z * _209)) + (_392.z * _215)) + (_402.z * _221)) + (_412.z * _227)) + (_422.z * _233)) + (_432.z * _239)) * CustomPixelConsts_096.z);
    } else {
      float4 _450 = t0.SampleLevel(s0, float2(_41, _42), 0.0f);
      float _454 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_450.x, _450.y, _450.z));
      float _458 = max(0.0f, (_454 - CustomPixelConsts_112.x));
      float _464 = (saturate(CustomPixelConsts_112.y * _458) * _458) / max(9.999999747378752e-05f, _454);
      float4 _471 = t0.SampleLevel(s0, float2(_134, _135), 0.0f);
      float _475 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_471.x, _471.y, _471.z));
      float _477 = max(0.0f, (_475 - CustomPixelConsts_112.x));
      float _482 = (saturate(CustomPixelConsts_112.y * _477) * _477) / max(9.999999747378752e-05f, _475);
      float4 _492 = t0.SampleLevel(s0, float2(_140, _141), 0.0f);
      float _496 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_492.x, _492.y, _492.z));
      float _498 = max(0.0f, (_496 - CustomPixelConsts_112.x));
      float _503 = (saturate(CustomPixelConsts_112.y * _498) * _498) / max(9.999999747378752e-05f, _496);
      float4 _513 = t0.SampleLevel(s0, float2(_146, _147), 0.0f);
      float _517 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_513.x, _513.y, _513.z));
      float _519 = max(0.0f, (_517 - CustomPixelConsts_112.x));
      float _524 = (saturate(CustomPixelConsts_112.y * _519) * _519) / max(9.999999747378752e-05f, _517);
      float4 _534 = t0.SampleLevel(s0, float2(_152, _153), 0.0f);
      float _538 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_534.x, _534.y, _534.z));
      float _540 = max(0.0f, (_538 - CustomPixelConsts_112.x));
      float _545 = (saturate(CustomPixelConsts_112.y * _540) * _540) / max(9.999999747378752e-05f, _538);
      float4 _555 = t0.SampleLevel(s0, float2(_158, _159), 0.0f);
      float _559 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_555.x, _555.y, _555.z));
      float _561 = max(0.0f, (_559 - CustomPixelConsts_112.x));
      float _566 = (saturate(CustomPixelConsts_112.y * _561) * _561) / max(9.999999747378752e-05f, _559);
      float4 _576 = t0.SampleLevel(s0, float2(_164, _165), 0.0f);
      float _580 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_576.x, _576.y, _576.z));
      float _582 = max(0.0f, (_580 - CustomPixelConsts_112.x));
      float _587 = (saturate(CustomPixelConsts_112.y * _582) * _582) / max(9.999999747378752e-05f, _580);
      float4 _597 = t0.SampleLevel(s0, float2(_170, _171), 0.0f);
      float _601 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_597.x, _597.y, _597.z));
      float _603 = max(0.0f, (_601 - CustomPixelConsts_112.x));
      float _608 = (saturate(CustomPixelConsts_112.y * _603) * _603) / max(9.999999747378752e-05f, _601);
      float4 _618 = t0.SampleLevel(s0, float2(_176, _177), 0.0f);
      float _622 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_618.x, _618.y, _618.z));
      float _624 = max(0.0f, (_622 - CustomPixelConsts_112.x));
      float _629 = (saturate(CustomPixelConsts_112.y * _624) * _624) / max(9.999999747378752e-05f, _622);
      float4 _639 = t0.SampleLevel(s0, float2(_182, _183), 0.0f);
      float _643 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_639.x, _639.y, _639.z));
      float _645 = max(0.0f, (_643 - CustomPixelConsts_112.x));
      float _650 = (saturate(CustomPixelConsts_112.y * _645) * _645) / max(9.999999747378752e-05f, _643);
      float4 _660 = t0.SampleLevel(s0, float2(_188, _189), 0.0f);
      float _664 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_660.x, _660.y, _660.z));
      float _666 = max(0.0f, (_664 - CustomPixelConsts_112.x));
      float _671 = (saturate(CustomPixelConsts_112.y * _666) * _666) / max(9.999999747378752e-05f, _664);
      float4 _681 = t0.SampleLevel(s0, float2(_194, _195), 0.0f);
      float _685 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_681.x, _681.y, _681.z));
      float _687 = max(0.0f, (_685 - CustomPixelConsts_112.x));
      float _692 = (saturate(CustomPixelConsts_112.y * _687) * _687) / max(9.999999747378752e-05f, _685);
      float4 _702 = t0.SampleLevel(s0, float2(_200, _201), 0.0f);
      float _706 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_702.x, _702.y, _702.z));
      float _708 = max(0.0f, (_706 - CustomPixelConsts_112.x));
      float _713 = (saturate(CustomPixelConsts_112.y * _708) * _708) / max(9.999999747378752e-05f, _706);
      float4 _723 = t0.SampleLevel(s0, float2(_206, _207), 0.0f);
      float _727 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_723.x, _723.y, _723.z));
      float _729 = max(0.0f, (_727 - CustomPixelConsts_112.x));
      float _734 = (saturate(CustomPixelConsts_112.y * _729) * _729) / max(9.999999747378752e-05f, _727);
      float4 _744 = t0.SampleLevel(s0, float2(_212, _213), 0.0f);
      float _748 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_744.x, _744.y, _744.z));
      float _750 = max(0.0f, (_748 - CustomPixelConsts_112.x));
      float _755 = (saturate(CustomPixelConsts_112.y * _750) * _750) / max(9.999999747378752e-05f, _748);
      float4 _765 = t0.SampleLevel(s0, float2(_218, _219), 0.0f);
      float _769 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_765.x, _765.y, _765.z));
      float _771 = max(0.0f, (_769 - CustomPixelConsts_112.x));
      float _776 = (saturate(CustomPixelConsts_112.y * _771) * _771) / max(9.999999747378752e-05f, _769);
      float4 _786 = t0.SampleLevel(s0, float2(_224, _225), 0.0f);
      float _790 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_786.x, _786.y, _786.z));
      float _792 = max(0.0f, (_790 - CustomPixelConsts_112.x));
      float _797 = (saturate(CustomPixelConsts_112.y * _792) * _792) / max(9.999999747378752e-05f, _790);
      float4 _807 = t0.SampleLevel(s0, float2(_230, _231), 0.0f);
      float _811 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_807.x, _807.y, _807.z));
      float _813 = max(0.0f, (_811 - CustomPixelConsts_112.x));
      float _818 = (saturate(CustomPixelConsts_112.y * _813) * _813) / max(9.999999747378752e-05f, _811);
      float4 _828 = t0.SampleLevel(s0, float2(_236, _237), 0.0f);
      float _832 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_828.x, _828.y, _828.z));
      float _834 = max(0.0f, (_832 - CustomPixelConsts_112.x));
      float _839 = (saturate(CustomPixelConsts_112.y * _834) * _834) / max(9.999999747378752e-05f, _832);
      float4 _849 = t0.SampleLevel(s0, float2(_242, _243), 0.0f);
      float _853 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_849.x, _849.y, _849.z));
      float _857 = max(0.0f, (_853 - CustomPixelConsts_112.x));
      float _863 = (saturate(CustomPixelConsts_112.y * _857) * _857) / max(9.999999747378752e-05f, _853);
      _874 = (((((((((((((((((((((_471.x * _133) * _482) + ((_450.x * _131) * _464)) + ((_492.x * _137) * _503)) + ((_513.x * _143) * _524)) + ((_534.x * _149) * _545)) + ((_555.x * _155) * _566)) + ((_576.x * _161) * _587)) + ((_597.x * _167) * _608)) + ((_618.x * _173) * _629)) + ((_639.x * _179) * _650)) + ((_660.x * _185) * _671)) + ((_681.x * _191) * _692)) + ((_702.x * _197) * _713)) + ((_723.x * _203) * _734)) + ((_744.x * _209) * _755)) + ((_765.x * _215) * _776)) + ((_786.x * _221) * _797)) + ((_807.x * _227) * _818)) + ((_828.x * _233) * _839)) + ((_849.x * _239) * _863));
      _875 = (((((((((((((((((((((_471.y * _133) * _482) + ((_450.y * _131) * _464)) + ((_492.y * _137) * _503)) + ((_513.y * _143) * _524)) + ((_534.y * _149) * _545)) + ((_555.y * _155) * _566)) + ((_576.y * _161) * _587)) + ((_597.y * _167) * _608)) + ((_618.y * _173) * _629)) + ((_639.y * _179) * _650)) + ((_660.y * _185) * _671)) + ((_681.y * _191) * _692)) + ((_702.y * _197) * _713)) + ((_723.y * _203) * _734)) + ((_744.y * _209) * _755)) + ((_765.y * _215) * _776)) + ((_786.y * _221) * _797)) + ((_807.y * _227) * _818)) + ((_828.y * _233) * _839)) + ((_849.y * _239) * _863));
      _876 = (((((((((((((((((((((_471.z * _133) * _482) + ((_450.z * _131) * _464)) + ((_492.z * _137) * _503)) + ((_513.z * _143) * _524)) + ((_534.z * _149) * _545)) + ((_555.z * _155) * _566)) + ((_576.z * _161) * _587)) + ((_597.z * _167) * _608)) + ((_618.z * _173) * _629)) + ((_639.z * _179) * _650)) + ((_660.z * _185) * _671)) + ((_681.z * _191) * _692)) + ((_702.z * _197) * _713)) + ((_723.z * _203) * _734)) + ((_744.z * _209) * _755)) + ((_765.z * _215) * _776)) + ((_786.z * _221) * _797)) + ((_807.z * _227) * _818)) + ((_828.z * _233) * _839)) + ((_849.z * _239) * _863));
    }
    float _877 = _874 * 0.05000000074505806f;
    float _878 = _875 * 0.05000000074505806f;
    float _879 = _876 * 0.05000000074505806f;

    float scale = GetSunshaftScale();
    //scale = 100.f;
    _877 *= scale;
    _878 *= scale;
    _879 *= scale;

    if (!(int(CustomPixelConsts_064.z) == 0)) {
      float _895 = exp2(log2(1.0f - _127) * CustomPixelConsts_080.y) / (((_127 * _127) * CustomPixelConsts_080.z) + 1.0f);

      // // --- START OF CHANGE ---

      // // Original falloff calculation
      // // float _1191 = exp2(log2(1.0f - _127) * CustomPixelConsts_080.y) / (((_127 * _127) * CustomPixelConsts_080.z) + 1.0f);

      // // New falloff logic:
      // // 1. Define a boost to make the sun center brighter. Higher values = brighter center.
      // float brightness_boost = 2.0f;

      // // 2. Define a falloff exponent. Higher values = sharper, more rapid falloff.
      // float falloff_exponent = 30.0f;

      // // 3. Calculate the new falloff factor using a strong power curve.
      // // pow(1.0 - distance, exponent) creates a sharp curve that is 1.0 at the center and drops off quickly.
      // float falloff_factor = pow(1.0f - _127, falloff_exponent);

      // // 4. Apply the boost to the falloff factor.
      // float _895 = falloff_factor * brightness_boost;

      // // --- END OF CHANGE ---

      _900 = (_895 * _877);
      _901 = (_895 * _878);
      _902 = (_895 * _879);
    } else {
      _900 = _877;
      _901 = _878;
      _902 = _879;
    }
  } else {
    _900 = 0.0f;
    _901 = 0.0f;
    _902 = 0.0f;
  }
  SV_Target.x = _900;
  SV_Target.y = _901;
  SV_Target.z = _902;
  SV_Target.w = 1.0f;
  return SV_Target;
}
