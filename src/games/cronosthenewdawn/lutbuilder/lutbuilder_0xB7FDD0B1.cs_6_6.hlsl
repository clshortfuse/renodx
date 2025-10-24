#include "./filmiclutbuilder.hlsli"

RWTexture3D<float4> u0 : register(u0);

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _20 = 0.5f / LUTSize;
  float _25 = LUTSize + -1.0f;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _574;
  float _607;
  float _621;
  float _685;
  float _937;
  float _938;
  float _939;
  float _950;
  float _961;
  float _972;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _38 = (OutputGamut == 4);
        _49 = select(_38, 1.0f, 1.705051064491272f);
        _50 = select(_38, 0.0f, -0.6217921376228333f);
        _51 = select(_38, 0.0f, -0.0832589864730835f);
        _52 = select(_38, 0.0f, -0.13025647401809692f);
        _53 = select(_38, 1.0f, 1.140804648399353f);
        _54 = select(_38, 0.0f, -0.010548308491706848f);
        _55 = select(_38, 0.0f, -0.024003351107239723f);
        _56 = select(_38, 0.0f, -0.1289689838886261f);
        _57 = select(_38, 1.0f, 1.1529725790023804f);
      } else {
        _49 = 0.6954522132873535f;
        _50 = 0.14067870378494263f;
        _51 = 0.16386906802654266f;
        _52 = 0.044794563204050064f;
        _53 = 0.8596711158752441f;
        _54 = 0.0955343171954155f;
        _55 = -0.005525882821530104f;
        _56 = 0.004025210160762072f;
        _57 = 1.0015007257461548f;
      }
    } else {
      _49 = 1.0258246660232544f;
      _50 = -0.020053181797266006f;
      _51 = -0.005771636962890625f;
      _52 = -0.002234415616840124f;
      _53 = 1.0045864582061768f;
      _54 = -0.002352118492126465f;
      _55 = -0.005013350863009691f;
      _56 = -0.025290070101618767f;
      _57 = 1.0303035974502563f;
    }
  } else {
    _49 = 1.3792141675949097f;
    _50 = -0.30886411666870117f;
    _51 = -0.0703500509262085f;
    _52 = -0.06933490186929703f;
    _53 = 1.08229660987854f;
    _54 = -0.012961871922016144f;
    _55 = -0.0021590073592960835f;
    _56 = -0.0454593189060688f;
    _57 = 1.0476183891296387f;
  }
  float _70 = (exp2((((LUTSize * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _71 = (exp2((((LUTSize * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _72 = (exp2(((float((uint)SV_DispatchThreadID.z) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _87 = mad((WorkingColorSpace_128[0].z), _72, mad((WorkingColorSpace_128[0].y), _71, ((WorkingColorSpace_128[0].x) * _70)));
  float _90 = mad((WorkingColorSpace_128[1].z), _72, mad((WorkingColorSpace_128[1].y), _71, ((WorkingColorSpace_128[1].x) * _70)));
  float _93 = mad((WorkingColorSpace_128[2].z), _72, mad((WorkingColorSpace_128[2].y), _71, ((WorkingColorSpace_128[2].x) * _70)));
  float _94 = dot(float3(_87, _90, _93), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _98 = (_87 / _94) + -1.0f;
  float _99 = (_90 / _94) + -1.0f;
  float _100 = (_93 / _94) + -1.0f;
  float _112 = (1.0f - exp2(((_94 * _94) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_98, _99, _100), float3(_98, _99, _100)) * -4.0f));
  float _128 = ((mad(-0.06368321925401688f, _93, mad(-0.3292922377586365f, _90, (_87 * 1.3704125881195068f))) - _87) * _112) + _87;
  float _129 = ((mad(-0.010861365124583244f, _93, mad(1.0970927476882935f, _90, (_87 * -0.08343357592821121f))) - _90) * _112) + _90;
  float _130 = ((mad(1.2036951780319214f, _93, mad(-0.09862580895423889f, _90, (_87 * -0.02579331398010254f))) - _93) * _112) + _93;
  float _131 = dot(float3(_128, _129, _130), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float3 WorkingColor = float3(_128, _129, _130);
  WorkingColor = ApplyColorCorrection(WorkingColor,
    ColorSaturation,
    ColorContrast,
    ColorGamma,
    ColorGain,
    ColorOffset,
    ColorSaturationShadows,
    ColorContrastShadows,
    ColorGammaShadows,
    ColorGainShadows,
    ColorOffsetShadows,
    ColorSaturationHighlights,
    ColorContrastHighlights,
    ColorGammaHighlights,
    ColorGainHighlights,
    ColorOffsetHighlights,
    ColorSaturationMidtones,
    ColorContrastMidtones,
    ColorGammaMidtones,
    ColorGainMidtones,
    ColorOffsetMidtones,
    ColorCorrectionShadowsMax,
    ColorCorrectionHighlightsMin,
    ColorCorrectionHighlightsMax);

  float _514 = ((mad(0.061360642313957214f, WorkingColor.b, mad(-4.540197551250458e-09f, WorkingColor.g, (WorkingColor.r * 0.9386394023895264f))) - WorkingColor.r) * BlueCorrection) + WorkingColor.r;
  float _515 = ((mad(0.169205904006958f, WorkingColor.b, mad(0.8307942152023315f, WorkingColor.g, (WorkingColor.r * 6.775371730327606e-08f))) - WorkingColor.g) * BlueCorrection) + WorkingColor.g;
  float _516 = (mad(-2.3283064365386963e-10f, WorkingColor.g, (WorkingColor.r * -9.313225746154785e-10f)) * BlueCorrection) + WorkingColor.b;
  float _519 = mad(0.16386905312538147f, _516, mad(0.14067868888378143f, _515, (_514 * 0.6954522132873535f)));
  float _522 = mad(0.0955343246459961f, _516, mad(0.8596711158752441f, _515, (_514 * 0.044794581830501556f)));
  float _525 = mad(1.0015007257461548f, _516, mad(0.004025210160762072f, _515, (_514 * -0.005525882821530104f)));
  float _529 = max(max(_519, _522), _525);
  float _534 = (max(_529, 1.000000013351432e-10f) - max(min(min(_519, _522), _525), 1.000000013351432e-10f)) / max(_529, 0.009999999776482582f);
  float _547 = ((_522 + _519) + _525) + (sqrt((((_525 - _522) * _525) + ((_522 - _519) * _522)) + ((_519 - _525) * _519)) * 1.75f);
  float _548 = _547 * 0.3333333432674408f;
  float _549 = _534 + -0.4000000059604645f;
  float _550 = _549 * 5.0f;
  float _554 = max((1.0f - abs(_549 * 2.5f)), 0.0f);
  float _565 = ((float((int)(((int)(uint)((bool)(_550 > 0.0f))) - ((int)(uint)((bool)(_550 < 0.0f))))) * (1.0f - (_554 * _554))) + 1.0f) * 0.02500000037252903f;
  if (!(_548 <= 0.0533333346247673f)) {
    if (!(_548 >= 0.1599999964237213f)) {
      _574 = (((0.23999999463558197f / _547) + -0.5f) * _565);
    } else {
      _574 = 0.0f;
    }
  } else {
    _574 = _565;
  }
  float _575 = _574 + 1.0f;
  float _576 = _575 * _519;
  float _577 = _575 * _522;
  float _578 = _575 * _525;
  if (!((bool)(_576 == _577) && (bool)(_577 == _578))) {
    float _585 = ((_576 * 2.0f) - _577) - _578;
    float _588 = ((_522 - _525) * 1.7320507764816284f) * _575;
    float _590 = atan(_588 / _585);
    bool _593 = (_585 < 0.0f);
    bool _594 = (_585 == 0.0f);
    bool _595 = (_588 >= 0.0f);
    bool _596 = (_588 < 0.0f);
    _607 = select((_595 && _594), 90.0f, select((_596 && _594), -90.0f, (select((_596 && _593), (_590 + -3.1415927410125732f), select((_595 && _593), (_590 + 3.1415927410125732f), _590)) * 57.2957763671875f)));
  } else {
    _607 = 0.0f;
  }
  float _612 = min(max(select((_607 < 0.0f), (_607 + 360.0f), _607), 0.0f), 360.0f);
  if (_612 < -180.0f) {
    _621 = (_612 + 360.0f);
  } else {
    if (_612 > 180.0f) {
      _621 = (_612 + -360.0f);
    } else {
      _621 = _612;
    }
  }
  float _625 = saturate(1.0f - abs(_621 * 0.014814814552664757f));
  float _629 = (_625 * _625) * (3.0f - (_625 * 2.0f));
  float _635 = ((_629 * _629) * ((_534 * 0.18000000715255737f) * (0.029999999329447746f - _576))) + _576;
  float _645 = max(0.0f, mad(-0.21492856740951538f, _578, mad(-0.2365107536315918f, _577, (_635 * 1.4514392614364624f))));
  float _646 = max(0.0f, mad(-0.09967592358589172f, _578, mad(1.17622971534729f, _577, (_635 * -0.07655377686023712f))));
  float _647 = max(0.0f, mad(0.9977163076400757f, _578, mad(-0.006032449658960104f, _577, (_635 * 0.008316148072481155f))));
  float _648 = dot(float3(_645, _646, _647), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _663 = (FilmBlackClip + 1.0f) - FilmToe;
  float _665 = FilmWhiteClip + 1.0f;
  float _667 = _665 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _685 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _676 = (FilmBlackClip + 0.18000000715255737f) / _663;
    _685 = (-0.7447274923324585f - ((log2(_676 / (2.0f - _676)) * 0.3465735912322998f) * (_663 / FilmSlope)));
  }
  float _688 = ((1.0f - FilmToe) / FilmSlope) - _685;
  float _690 = (FilmShoulder / FilmSlope) - _688;

  float _836, _837, _838;
  if (is_hdr) {
    float3 lerpColor = lerp(_648, float3(_645, _646, _647), 0.9599999785423279f);
    ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b,
                       _514, _515, _516,
                       _836, _837, _838);
  } else {
  float _694 = log2(lerp(_648, _645, 0.9599999785423279f)) * 0.3010300099849701f;
  float _695 = log2(lerp(_648, _646, 0.9599999785423279f)) * 0.3010300099849701f;
  float _696 = log2(lerp(_648, _647, 0.9599999785423279f)) * 0.3010300099849701f;
  float _700 = FilmSlope * (_694 + _688);
  float _701 = FilmSlope * (_695 + _688);
  float _702 = FilmSlope * (_696 + _688);
  float _703 = _663 * 2.0f;
  float _705 = (FilmSlope * -2.0f) / _663;
  float _706 = _694 - _685;
  float _707 = _695 - _685;
  float _708 = _696 - _685;
  float _727 = _667 * 2.0f;
  float _729 = (FilmSlope * 2.0f) / _667;
  float _754 = select((_694 < _685), ((_703 / (exp2((_706 * 1.4426950216293335f) * _705) + 1.0f)) - FilmBlackClip), _700);
  float _755 = select((_695 < _685), ((_703 / (exp2((_707 * 1.4426950216293335f) * _705) + 1.0f)) - FilmBlackClip), _701);
  float _756 = select((_696 < _685), ((_703 / (exp2((_708 * 1.4426950216293335f) * _705) + 1.0f)) - FilmBlackClip), _702);
  float _763 = _690 - _685;
  float _767 = saturate(_706 / _763);
  float _768 = saturate(_707 / _763);
  float _769 = saturate(_708 / _763);
  bool _770 = (_690 < _685);
  float _774 = select(_770, (1.0f - _767), _767);
  float _775 = select(_770, (1.0f - _768), _768);
  float _776 = select(_770, (1.0f - _769), _769);
  float _795 = (((_774 * _774) * (select((_694 > _690), (_665 - (_727 / (exp2(((_694 - _690) * 1.4426950216293335f) * _729) + 1.0f))), _700) - _754)) * (3.0f - (_774 * 2.0f))) + _754;
  float _796 = (((_775 * _775) * (select((_695 > _690), (_665 - (_727 / (exp2(((_695 - _690) * 1.4426950216293335f) * _729) + 1.0f))), _701) - _755)) * (3.0f - (_775 * 2.0f))) + _755;
  float _797 = (((_776 * _776) * (select((_696 > _690), (_665 - (_727 / (exp2(((_696 - _690) * 1.4426950216293335f) * _729) + 1.0f))), _702) - _756)) * (3.0f - (_776 * 2.0f))) + _756;
  float _798 = dot(float3(_795, _796, _797), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _818 = (ToneCurveAmount * (max(0.0f, (lerp(_798, _795, 0.9300000071525574f))) - _514)) + _514;
  float _819 = (ToneCurveAmount * (max(0.0f, (lerp(_798, _796, 0.9300000071525574f))) - _515)) + _515;
  float _820 = (ToneCurveAmount * (max(0.0f, (lerp(_798, _797, 0.9300000071525574f))) - _516)) + _516;
  _836 = ((mad(-0.06537103652954102f, _820, mad(1.451815478503704e-06f, _819, (_818 * 1.065374732017517f))) - _818) * BlueCorrection) + _818;
  _837 = ((mad(-0.20366770029067993f, _820, mad(1.2036634683609009f, _819, (_818 * -2.57161445915699e-07f))) - _819) * BlueCorrection) + _819;
  _838 = ((mad(0.9999996423721313f, _820, mad(2.0954757928848267e-08f, _819, (_818 * 1.862645149230957e-08f))) - _820) * BlueCorrection) + _820;
  }
  float _860 = mad((WorkingColorSpace_192[0].z), _838, mad((WorkingColorSpace_192[0].y), _837, ((WorkingColorSpace_192[0].x) * _836)));
  float _861 = mad((WorkingColorSpace_192[1].z), _838, mad((WorkingColorSpace_192[1].y), _837, ((WorkingColorSpace_192[1].x) * _836)));
  float _862 = mad((WorkingColorSpace_192[2].z), _838, mad((WorkingColorSpace_192[2].y), _837, ((WorkingColorSpace_192[2].x) * _836)));
  if (!is_hdr) {
    _860 = max(0.0f, _860);
    _861 = max(0.0f, _861);
    _862 = max(0.0f, _862);
  }
  float _888 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _860)) * _860) + MappingPolynomial.z);
  float _889 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _861)) * _861) + MappingPolynomial.z);
  float _890 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _862)) * _862) + MappingPolynomial.z);
  // float _911 = exp2(log2(max(0.0f, (lerp(_888, OverlayColor.x, OverlayColor.w)))) * InverseGamma.y);
  // float _912 = exp2(log2(max(0.0f, (lerp(_889, OverlayColor.y, OverlayColor.w)))) * InverseGamma.y);
  // float _913 = exp2(log2(max(0.0f, (lerp(_890, OverlayColor.z, OverlayColor.w)))) * InverseGamma.y);
  float _x1 = ((OverlayColor.x - _888) * OverlayColor.w) + _888;
  float _y1 = ((OverlayColor.y - _889) * OverlayColor.w) + _889;
  float _z1 = ((OverlayColor.z - _890) * OverlayColor.w) + _890;

  if (GenerateOutput(_x1, _y1, _z1, u0[SV_DispatchThreadID])) {
    return;
  }

  float _x2 = ColorScale.x * mad((WorkingColorSpace_192[0].z), WorkingColor.b, mad((WorkingColorSpace_192[0].y), WorkingColor.g, (WorkingColor.r * (WorkingColorSpace_192[0].x))));
  float _y2 = ColorScale.y * mad((WorkingColorSpace_192[1].z), WorkingColor.b, mad((WorkingColorSpace_192[1].y), WorkingColor.g, ((WorkingColorSpace_192[1].x) * WorkingColor.r)));
  float _z2 = ColorScale.z * mad((WorkingColorSpace_192[2].z), WorkingColor.b, mad((WorkingColorSpace_192[2].y), WorkingColor.g, ((WorkingColorSpace_192[2].x) * WorkingColor.r)));
  float _x3 = ((OverlayColor.x - _x2) * OverlayColor.w) + _x2;
  float _y3 = ((OverlayColor.y - _y2) * OverlayColor.w) + _y2;
  float _z3 = ((OverlayColor.z - _z2) * OverlayColor.w) + _z2;
  float _911 = exp2(log2(max(0.0f, _x1)) * InverseGamma.y);
  float _912 = exp2(log2(max(0.0f, _y1)) * InverseGamma.y);
  float _913 = exp2(log2(max(0.0f, _z1)) * InverseGamma.y);

  if (WorkingColorSpace_320 == 0) {
    float _920 = mad((WorkingColorSpace_128[0].z), _913, mad((WorkingColorSpace_128[0].y), _912, ((WorkingColorSpace_128[0].x) * _911)));
    float _923 = mad((WorkingColorSpace_128[1].z), _913, mad((WorkingColorSpace_128[1].y), _912, ((WorkingColorSpace_128[1].x) * _911)));
    float _926 = mad((WorkingColorSpace_128[2].z), _913, mad((WorkingColorSpace_128[2].y), _912, ((WorkingColorSpace_128[2].x) * _911)));
    _937 = mad(_51, _926, mad(_50, _923, (_920 * _49)));
    _938 = mad(_54, _926, mad(_53, _923, (_920 * _52)));
    _939 = mad(_57, _926, mad(_56, _923, (_920 * _55)));
  } else {
    _937 = _911;
    _938 = _912;
    _939 = _913;
  }
  if (_937 < 0.0031306699384003878f) {
    _950 = (_937 * 12.920000076293945f);
  } else {
    _950 = (((pow(_937, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_938 < 0.0031306699384003878f) {
    _961 = (_938 * 12.920000076293945f);
  } else {
    _961 = (((pow(_938, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_939 < 0.0031306699384003878f) {
    _972 = (_939 * 12.920000076293945f);
  } else {
    _972 = (((pow(_939, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_950 * 0.9523810148239136f), (_961 * 0.9523810148239136f), (_972 * 0.9523810148239136f), 0.0f);
}
