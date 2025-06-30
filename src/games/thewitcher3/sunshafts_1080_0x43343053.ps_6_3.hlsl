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
  float _78 = _76 * 0.0625f;
  float _79 = _77 * 0.0625f;
  bool _86 = (int(CustomPixelConsts_064.z) == 0);
  float _95;
  float _96;
  float _97;
  float _723;
  float _724;
  float _725;
  float _744;
  float _745;
  float _746;
  if (!_86) {
    float _88 = _76 * 0.00390625f;
    float _89 = _77 * 0.00390625f;
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
    [branch]
    if (!_86) {
      float4 _221 = t0.SampleLevel(s0, float2(_41, _42), 0.0f);
      float4 _228 = t0.SampleLevel(s0, float2(_134, _135), 0.0f);
      float4 _238 = t0.SampleLevel(s0, float2(_140, _141), 0.0f);
      float4 _248 = t0.SampleLevel(s0, float2(_146, _147), 0.0f);
      float4 _258 = t0.SampleLevel(s0, float2(_152, _153), 0.0f);
      float4 _268 = t0.SampleLevel(s0, float2(_158, _159), 0.0f);
      float4 _278 = t0.SampleLevel(s0, float2(_164, _165), 0.0f);
      float4 _288 = t0.SampleLevel(s0, float2(_170, _171), 0.0f);
      float4 _298 = t0.SampleLevel(s0, float2(_176, _177), 0.0f);
      float4 _308 = t0.SampleLevel(s0, float2(_182, _183), 0.0f);
      float4 _318 = t0.SampleLevel(s0, float2(_188, _189), 0.0f);
      float4 _328 = t0.SampleLevel(s0, float2(_194, _195), 0.0f);
      float4 _338 = t0.SampleLevel(s0, float2(_200, _201), 0.0f);
      float4 _348 = t0.SampleLevel(s0, float2(_206, _207), 0.0f);
      float4 _358 = t0.SampleLevel(s0, float2(_212, _213), 0.0f);
      float4 _368 = t0.SampleLevel(s0, float2(_218, _219), 0.0f);
      _723 = (((((((((((((((((_228.x * _133) + (_221.x * _131)) + (_238.x * _137)) + (_248.x * _143)) + (_258.x * _149)) + (_268.x * _155)) + (_278.x * _161)) + (_288.x * _167)) + (_298.x * _173)) + (_308.x * _179)) + (_318.x * _185)) + (_328.x * _191)) + (_338.x * _197)) + (_348.x * _203)) + (_358.x * _209)) + (_368.x * _215)) * CustomPixelConsts_096.x);
      _724 = (((((((((((((((((_228.y * _133) + (_221.y * _131)) + (_238.y * _137)) + (_248.y * _143)) + (_258.y * _149)) + (_268.y * _155)) + (_278.y * _161)) + (_288.y * _167)) + (_298.y * _173)) + (_308.y * _179)) + (_318.y * _185)) + (_328.y * _191)) + (_338.y * _197)) + (_348.y * _203)) + (_358.y * _209)) + (_368.y * _215)) * CustomPixelConsts_096.y);
      _725 = (((((((((((((((((_228.z * _133) + (_221.z * _131)) + (_238.z * _137)) + (_248.z * _143)) + (_258.z * _149)) + (_268.z * _155)) + (_278.z * _161)) + (_288.z * _167)) + (_298.z * _173)) + (_308.z * _179)) + (_318.z * _185)) + (_328.z * _191)) + (_338.z * _197)) + (_348.z * _203)) + (_358.z * _209)) + (_368.z * _215)) * CustomPixelConsts_096.z);
    } else {
      float4 _386 = t0.SampleLevel(s0, float2(_41, _42), 0.0f);
      float _390 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_386.x, _386.y, _386.z));
      float _394 = max(0.0f, (_390 - CustomPixelConsts_112.x));
      float _400 = (saturate(CustomPixelConsts_112.y * _394) * _394) / max(9.999999747378752e-05f, _390);
      float4 _407 = t0.SampleLevel(s0, float2(_134, _135), 0.0f);
      float _411 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_407.x, _407.y, _407.z));
      float _413 = max(0.0f, (_411 - CustomPixelConsts_112.x));
      float _418 = (saturate(CustomPixelConsts_112.y * _413) * _413) / max(9.999999747378752e-05f, _411);
      float4 _428 = t0.SampleLevel(s0, float2(_140, _141), 0.0f);
      float _432 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_428.x, _428.y, _428.z));
      float _434 = max(0.0f, (_432 - CustomPixelConsts_112.x));
      float _439 = (saturate(CustomPixelConsts_112.y * _434) * _434) / max(9.999999747378752e-05f, _432);
      float4 _449 = t0.SampleLevel(s0, float2(_146, _147), 0.0f);
      float _453 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_449.x, _449.y, _449.z));
      float _455 = max(0.0f, (_453 - CustomPixelConsts_112.x));
      float _460 = (saturate(CustomPixelConsts_112.y * _455) * _455) / max(9.999999747378752e-05f, _453);
      float4 _470 = t0.SampleLevel(s0, float2(_152, _153), 0.0f);
      float _474 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_470.x, _470.y, _470.z));
      float _476 = max(0.0f, (_474 - CustomPixelConsts_112.x));
      float _481 = (saturate(CustomPixelConsts_112.y * _476) * _476) / max(9.999999747378752e-05f, _474);
      float4 _491 = t0.SampleLevel(s0, float2(_158, _159), 0.0f);
      float _495 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_491.x, _491.y, _491.z));
      float _497 = max(0.0f, (_495 - CustomPixelConsts_112.x));
      float _502 = (saturate(CustomPixelConsts_112.y * _497) * _497) / max(9.999999747378752e-05f, _495);
      float4 _512 = t0.SampleLevel(s0, float2(_164, _165), 0.0f);
      float _516 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_512.x, _512.y, _512.z));
      float _518 = max(0.0f, (_516 - CustomPixelConsts_112.x));
      float _523 = (saturate(CustomPixelConsts_112.y * _518) * _518) / max(9.999999747378752e-05f, _516);
      float4 _533 = t0.SampleLevel(s0, float2(_170, _171), 0.0f);
      float _537 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_533.x, _533.y, _533.z));
      float _539 = max(0.0f, (_537 - CustomPixelConsts_112.x));
      float _544 = (saturate(CustomPixelConsts_112.y * _539) * _539) / max(9.999999747378752e-05f, _537);
      float4 _554 = t0.SampleLevel(s0, float2(_176, _177), 0.0f);
      float _558 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_554.x, _554.y, _554.z));
      float _560 = max(0.0f, (_558 - CustomPixelConsts_112.x));
      float _565 = (saturate(CustomPixelConsts_112.y * _560) * _560) / max(9.999999747378752e-05f, _558);
      float4 _575 = t0.SampleLevel(s0, float2(_182, _183), 0.0f);
      float _579 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_575.x, _575.y, _575.z));
      float _581 = max(0.0f, (_579 - CustomPixelConsts_112.x));
      float _586 = (saturate(CustomPixelConsts_112.y * _581) * _581) / max(9.999999747378752e-05f, _579);
      float4 _596 = t0.SampleLevel(s0, float2(_188, _189), 0.0f);
      float _600 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_596.x, _596.y, _596.z));
      float _602 = max(0.0f, (_600 - CustomPixelConsts_112.x));
      float _607 = (saturate(CustomPixelConsts_112.y * _602) * _602) / max(9.999999747378752e-05f, _600);
      float4 _617 = t0.SampleLevel(s0, float2(_194, _195), 0.0f);
      float _621 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_617.x, _617.y, _617.z));
      float _623 = max(0.0f, (_621 - CustomPixelConsts_112.x));
      float _628 = (saturate(CustomPixelConsts_112.y * _623) * _623) / max(9.999999747378752e-05f, _621);
      float4 _638 = t0.SampleLevel(s0, float2(_200, _201), 0.0f);
      float _642 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_638.x, _638.y, _638.z));
      float _644 = max(0.0f, (_642 - CustomPixelConsts_112.x));
      float _649 = (saturate(CustomPixelConsts_112.y * _644) * _644) / max(9.999999747378752e-05f, _642);
      float4 _659 = t0.SampleLevel(s0, float2(_206, _207), 0.0f);
      float _663 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_659.x, _659.y, _659.z));
      float _665 = max(0.0f, (_663 - CustomPixelConsts_112.x));
      float _670 = (saturate(CustomPixelConsts_112.y * _665) * _665) / max(9.999999747378752e-05f, _663);
      float4 _680 = t0.SampleLevel(s0, float2(_212, _213), 0.0f);
      float _684 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_680.x, _680.y, _680.z));
      float _686 = max(0.0f, (_684 - CustomPixelConsts_112.x));
      float _691 = (saturate(CustomPixelConsts_112.y * _686) * _686) / max(9.999999747378752e-05f, _684);
      float4 _701 = t0.SampleLevel(s0, float2(_218, _219), 0.0f);
      float _705 = dot(float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f), float3(_701.x, _701.y, _701.z));
      float _707 = max(0.0f, (_705 - CustomPixelConsts_112.x));
      float _712 = (saturate(CustomPixelConsts_112.y * _707) * _707) / max(9.999999747378752e-05f, _705);
      _723 = (((((((((((((((((_407.x * _133) * _418) + ((_386.x * _131) * _400)) + ((_428.x * _137) * _439)) + ((_449.x * _143) * _460)) + ((_470.x * _149) * _481)) + ((_491.x * _155) * _502)) + ((_512.x * _161) * _523)) + ((_533.x * _167) * _544)) + ((_554.x * _173) * _565)) + ((_575.x * _179) * _586)) + ((_596.x * _185) * _607)) + ((_617.x * _191) * _628)) + ((_638.x * _197) * _649)) + ((_659.x * _203) * _670)) + ((_680.x * _209) * _691)) + ((_701.x * _215) * _712));
      _724 = (((((((((((((((((_407.y * _133) * _418) + ((_386.y * _131) * _400)) + ((_428.y * _137) * _439)) + ((_449.y * _143) * _460)) + ((_470.y * _149) * _481)) + ((_491.y * _155) * _502)) + ((_512.y * _161) * _523)) + ((_533.y * _167) * _544)) + ((_554.y * _173) * _565)) + ((_575.y * _179) * _586)) + ((_596.y * _185) * _607)) + ((_617.y * _191) * _628)) + ((_638.y * _197) * _649)) + ((_659.y * _203) * _670)) + ((_680.y * _209) * _691)) + ((_701.y * _215) * _712));
      _725 = (((((((((((((((((_407.z * _133) * _418) + ((_386.z * _131) * _400)) + ((_428.z * _137) * _439)) + ((_449.z * _143) * _460)) + ((_470.z * _149) * _481)) + ((_491.z * _155) * _502)) + ((_512.z * _161) * _523)) + ((_533.z * _167) * _544)) + ((_554.z * _173) * _565)) + ((_575.z * _179) * _586)) + ((_596.z * _185) * _607)) + ((_617.z * _191) * _628)) + ((_638.z * _197) * _649)) + ((_659.z * _203) * _670)) + ((_680.z * _209) * _691)) + ((_701.z * _215) * _712));
    
    }
    float _726 = _723 * 0.0625f;
    float _727 = _724 * 0.0625f;
    float _728 = _725 * 0.0625f;

    float scale = GetSunshaftScale();
    // scale = 100.f;
    _726 *= scale;
    _727 *= scale;
    _728 *= scale;

    if (!_86) {
      float _739 = exp2(log2(1.0f - _127) * CustomPixelConsts_080.y) / (((_127 * _127) * CustomPixelConsts_080.z) + 1.0f);
      _744 = (_739 * _726);
      _745 = (_739 * _727);
      _746 = (_739 * _728);
    } else {
      _744 = _726;
      _745 = _727;
      _746 = _728;
    }
  } else {
    _744 = 0.0f;
    _745 = 0.0f;
    _746 = 0.0f;
  }
  SV_Target.x = _744;
  SV_Target.y = _745;
  SV_Target.z = _746;
  SV_Target.w = 1.0f;
  return SV_Target;
}
