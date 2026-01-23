#include "./filmiclutbuilder.hlsl"

// Found in Expedition 33

struct FWorkingColorSpaceConstants {
  float4 ToXYZ[4];
  float4 FromXYZ[4];
  float4 ToAP1[4];
  float4 FromAP1[4];
  float4 ToAP0[4];
  uint bIsSRGB;
};

Texture2D<float4> Textures_1 : register(t0);

cbuffer WorkingColorSpace : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace : packoffset(c000.x);
};

SamplerState Samplers_1 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  uint output_gamut = OutputGamut;
  uint output_device = OutputDevice;
  float expand_gamut = ExpandGamut;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);
  float4 SV_Target;
  float _12 = 0.5f / LUTSize;
  float _17 = LUTSize + -1.0f;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _566;
  float _599;
  float _613;
  float _677;
  float _868;
  float _879;
  float _890;
  float _1047;
  float _1048;
  float _1049;
  float _1060;
  float _1071;
  float _1082;
  if (!((uint)(output_gamut) == 1)) {
    if (!((uint)(output_gamut) == 2)) {
      if (!((uint)(output_gamut) == 3)) {
        bool _30 = ((uint)(output_gamut) == 4);
        _41 = select(_30, 1.0f, 1.705051064491272f);
        _42 = select(_30, 0.0f, -0.6217921376228333f);
        _43 = select(_30, 0.0f, -0.0832589864730835f);
        _44 = select(_30, 0.0f, -0.13025647401809692f);
        _45 = select(_30, 1.0f, 1.140804648399353f);
        _46 = select(_30, 0.0f, -0.010548308491706848f);
        _47 = select(_30, 0.0f, -0.024003351107239723f);
        _48 = select(_30, 0.0f, -0.1289689838886261f);
        _49 = select(_30, 1.0f, 1.1529725790023804f);
      } else {
        _41 = 0.6954522132873535f;
        _42 = 0.14067870378494263f;
        _43 = 0.16386906802654266f;
        _44 = 0.044794563204050064f;
        _45 = 0.8596711158752441f;
        _46 = 0.0955343171954155f;
        _47 = -0.005525882821530104f;
        _48 = 0.004025210160762072f;
        _49 = 1.0015007257461548f;
      }
    } else {
      _41 = 1.0258246660232544f;
      _42 = -0.020053181797266006f;
      _43 = -0.005771636962890625f;
      _44 = -0.002234415616840124f;
      _45 = 1.0045864582061768f;
      _46 = -0.002352118492126465f;
      _47 = -0.005013350863009691f;
      _48 = -0.025290070101618767f;
      _49 = 1.0303035974502563f;
    }
  } else {
    _41 = 1.3792141675949097f;
    _42 = -0.30886411666870117f;
    _43 = -0.0703500509262085f;
    _44 = -0.06933490186929703f;
    _45 = 1.08229660987854f;
    _46 = -0.012961871922016144f;
    _47 = -0.0021590073592960835f;
    _48 = -0.0454593189060688f;
    _49 = 1.0476183891296387f;
  }
  float _62 = (exp2((((LUTSize * (TEXCOORD.x - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _63 = (exp2((((LUTSize * (TEXCOORD.y - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _64 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _79 = mad((WorkingColorSpace.ToAP1[0].z), _64, mad((WorkingColorSpace.ToAP1[0].y), _63, ((WorkingColorSpace.ToAP1[0].x) * _62)));
  float _82 = mad((WorkingColorSpace.ToAP1[1].z), _64, mad((WorkingColorSpace.ToAP1[1].y), _63, ((WorkingColorSpace.ToAP1[1].x) * _62)));
  float _85 = mad((WorkingColorSpace.ToAP1[2].z), _64, mad((WorkingColorSpace.ToAP1[2].y), _63, ((WorkingColorSpace.ToAP1[2].x) * _62)));
  float _86 = dot(float3(_79, _82, _85), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  // SetUngradedAP1(_79, _82, _85);

  float _90 = (_79 / _86) + -1.0f;
  float _91 = (_82 / _86) + -1.0f;
  float _92 = (_85 / _86) + -1.0f;
  float _104 = (1.0f - exp2(((_86 * _86) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_90, _91, _92), float3(_90, _91, _92)) * -4.0f));
  float _120 = ((mad(-0.06368321925401688f, _85, mad(-0.3292922377586365f, _82, (_79 * 1.3704125881195068f))) - _79) * _104) + _79;
  float _121 = ((mad(-0.010861365124583244f, _85, mad(1.0970927476882935f, _82, (_79 * -0.08343357592821121f))) - _82) * _104) + _82;
  float _122 = ((mad(1.2036951780319214f, _85, mad(-0.09862580895423889f, _82, (_79 * -0.02579331398010254f))) - _85) * _104) + _85;
  float _123 = dot(float3(_120, _121, _122), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _137 = ColorOffset.w + ColorOffsetShadows.w;
  float _151 = ColorGain.w * ColorGainShadows.w;
  float _165 = ColorGamma.w * ColorGammaShadows.w;
  float _179 = ColorContrast.w * ColorContrastShadows.w;
  float _193 = ColorSaturation.w * ColorSaturationShadows.w;
  float _197 = _120 - _123;
  float _198 = _121 - _123;
  float _199 = _122 - _123;
  float _256 = saturate(_123 / ColorCorrectionShadowsMax);
  float _260 = (_256 * _256) * (3.0f - (_256 * 2.0f));
  float _261 = 1.0f - _260;
  float _270 = ColorOffset.w + ColorOffsetHighlights.w;
  float _279 = ColorGain.w * ColorGainHighlights.w;
  float _288 = ColorGamma.w * ColorGammaHighlights.w;
  float _297 = ColorContrast.w * ColorContrastHighlights.w;
  float _306 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _369 = saturate((_123 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _373 = (_369 * _369) * (3.0f - (_369 * 2.0f));
  float _382 = ColorOffset.w + ColorOffsetMidtones.w;
  float _391 = ColorGain.w * ColorGainMidtones.w;
  float _400 = ColorGamma.w * ColorGammaMidtones.w;
  float _409 = ColorContrast.w * ColorContrastMidtones.w;
  float _418 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _476 = _260 - _373;
  float _487 = ((_373 * (((ColorOffset.x + ColorOffsetHighlights.x) + _270) + (((ColorGain.x * ColorGainHighlights.x) * _279) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _297) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _306) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _288)))))) + (_261 * (((ColorOffset.x + ColorOffsetShadows.x) + _137) + (((ColorGain.x * ColorGainShadows.x) * _151) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _179) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _193) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _165))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _382) + (((ColorGain.x * ColorGainMidtones.x) * _391) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _409) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _418) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _400))))) * _476);
  float _489 = ((_373 * (((ColorOffset.y + ColorOffsetHighlights.y) + _270) + (((ColorGain.y * ColorGainHighlights.y) * _279) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _297) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _306) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _288)))))) + (_261 * (((ColorOffset.y + ColorOffsetShadows.y) + _137) + (((ColorGain.y * ColorGainShadows.y) * _151) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _179) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _193) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _165))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _382) + (((ColorGain.y * ColorGainMidtones.y) * _391) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _409) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _418) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _400))))) * _476);
  float _491 = ((_373 * (((ColorOffset.z + ColorOffsetHighlights.z) + _270) + (((ColorGain.z * ColorGainHighlights.z) * _279) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _297) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _306) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _288)))))) + (_261 * (((ColorOffset.z + ColorOffsetShadows.z) + _137) + (((ColorGain.z * ColorGainShadows.z) * _151) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _179) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _193) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _165))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _382) + (((ColorGain.z * ColorGainMidtones.z) * _391) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _409) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _418) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _400))))) * _476);

  // Will cause issues with grayscale scenes if moved above
  // SetUntonemappedAP1(_487, _489, _491);
#if 1  // begin FilmToneMap with BlueCorrect
  float _828, _829, _830;
  ApplyFilmToneMapWithBlueCorrect(_487, _489, _491,
                                  _828, _829, _830);

#else

  float _506 = ((mad(0.061360642313957214f, _491, mad(-4.540197551250458e-09f, _489, (_487 * 0.9386394023895264f))) - _487) * BlueCorrection) + _487;
  float _507 = ((mad(0.169205904006958f, _491, mad(0.8307942152023315f, _489, (_487 * 6.775371730327606e-08f))) - _489) * BlueCorrection) + _489;
  float _508 = (mad(-2.3283064365386963e-10f, _489, (_487 * -9.313225746154785e-10f)) * BlueCorrection) + _491;
  float _511 = mad(0.16386905312538147f, _508, mad(0.14067868888378143f, _507, (_506 * 0.6954522132873535f)));
  float _514 = mad(0.0955343246459961f, _508, mad(0.8596711158752441f, _507, (_506 * 0.044794581830501556f)));
  float _517 = mad(1.0015007257461548f, _508, mad(0.004025210160762072f, _507, (_506 * -0.005525882821530104f)));
  float _521 = max(max(_511, _514), _517);
  float _526 = (max(_521, 1.000000013351432e-10f) - max(min(min(_511, _514), _517), 1.000000013351432e-10f)) / max(_521, 0.009999999776482582f);
  float _539 = ((_514 + _511) + _517) + (sqrt((((_517 - _514) * _517) + ((_514 - _511) * _514)) + ((_511 - _517) * _511)) * 1.75f);
  float _540 = _539 * 0.3333333432674408f;
  float _541 = _526 + -0.4000000059604645f;
  float _542 = _541 * 5.0f;
  float _546 = max((1.0f - abs(_541 * 2.5f)), 0.0f);
  float _557 = ((float(((int)(uint)((bool)(_542 > 0.0f))) - ((int)(uint)((bool)(_542 < 0.0f)))) * (1.0f - (_546 * _546))) + 1.0f) * 0.02500000037252903f;
  if (!(_540 <= 0.0533333346247673f)) {
    if (!(_540 >= 0.1599999964237213f)) {
      _566 = (((0.23999999463558197f / _539) + -0.5f) * _557);
    } else {
      _566 = 0.0f;
    }
  } else {
    _566 = _557;
  }
  float _567 = _566 + 1.0f;
  float _568 = _567 * _511;
  float _569 = _567 * _514;
  float _570 = _567 * _517;
  if (!((bool)(_568 == _569) && (bool)(_569 == _570))) {
    float _577 = ((_568 * 2.0f) - _569) - _570;
    float _580 = ((_514 - _517) * 1.7320507764816284f) * _567;
    float _582 = atan(_580 / _577);
    bool _585 = (_577 < 0.0f);
    bool _586 = (_577 == 0.0f);
    bool _587 = (_580 >= 0.0f);
    bool _588 = (_580 < 0.0f);
    _599 = select((_587 && _586), 90.0f, select((_588 && _586), -90.0f, (select((_588 && _585), (_582 + -3.1415927410125732f), select((_587 && _585), (_582 + 3.1415927410125732f), _582)) * 57.2957763671875f)));
  } else {
    _599 = 0.0f;
  }
  float _604 = min(max(select((_599 < 0.0f), (_599 + 360.0f), _599), 0.0f), 360.0f);
  if (_604 < -180.0f) {
    _613 = (_604 + 360.0f);
  } else {
    if (_604 > 180.0f) {
      _613 = (_604 + -360.0f);
    } else {
      _613 = _604;
    }
  }
  float _617 = saturate(1.0f - abs(_613 * 0.014814814552664757f));
  float _621 = (_617 * _617) * (3.0f - (_617 * 2.0f));
  float _627 = ((_621 * _621) * ((_526 * 0.18000000715255737f) * (0.029999999329447746f - _568))) + _568;
  float _637 = max(0.0f, mad(-0.21492856740951538f, _570, mad(-0.2365107536315918f, _569, (_627 * 1.4514392614364624f))));
  float _638 = max(0.0f, mad(-0.09967592358589172f, _570, mad(1.17622971534729f, _569, (_627 * -0.07655377686023712f))));
  float _639 = max(0.0f, mad(0.9977163076400757f, _570, mad(-0.006032449658960104f, _569, (_627 * 0.008316148072481155f))));
  float _640 = dot(float3(_637, _638, _639), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _655 = (FilmBlackClip + 1.0f) - FilmToe;
  float _657 = FilmWhiteClip + 1.0f;
  float _659 = _657 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _677 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _668 = (FilmBlackClip + 0.18000000715255737f) / _655;
    _677 = (-0.7447274923324585f - ((log2(_668 / (2.0f - _668)) * 0.3465735912322998f) * (_655 / FilmSlope)));
  }
  float _680 = ((1.0f - FilmToe) / FilmSlope) - _677;
  float _682 = (FilmShoulder / FilmSlope) - _680;
  float3 lerpColor = lerp(_640, float3(_637, _638, _639), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _506, _507, _508);
  float _828 = lerpColor.r, _829 = lerpColor.g, _830 = lerpColor.b;
#else
  float _686 = log2(lerp(_640, _637, 0.9599999785423279f)) * 0.3010300099849701f;
  float _687 = log2(lerp(_640, _638, 0.9599999785423279f)) * 0.3010300099849701f;
  float _688 = log2(lerp(_640, _639, 0.9599999785423279f)) * 0.3010300099849701f;
  float _692 = FilmSlope * (_686 + _680);
  float _693 = FilmSlope * (_687 + _680);
  float _694 = FilmSlope * (_688 + _680);
  float _695 = _655 * 2.0f;
  float _697 = (FilmSlope * -2.0f) / _655;
  float _698 = _686 - _677;
  float _699 = _687 - _677;
  float _700 = _688 - _677;
  float _719 = _659 * 2.0f;
  float _721 = (FilmSlope * 2.0f) / _659;
  float _746 = select((_686 < _677), ((_695 / (exp2((_698 * 1.4426950216293335f) * _697) + 1.0f)) - FilmBlackClip), _692);
  float _747 = select((_687 < _677), ((_695 / (exp2((_699 * 1.4426950216293335f) * _697) + 1.0f)) - FilmBlackClip), _693);
  float _748 = select((_688 < _677), ((_695 / (exp2((_700 * 1.4426950216293335f) * _697) + 1.0f)) - FilmBlackClip), _694);
  float _755 = _682 - _677;
  float _759 = saturate(_698 / _755);
  float _760 = saturate(_699 / _755);
  float _761 = saturate(_700 / _755);
  bool _762 = (_682 < _677);
  float _766 = select(_762, (1.0f - _759), _759);
  float _767 = select(_762, (1.0f - _760), _760);
  float _768 = select(_762, (1.0f - _761), _761);
  float _787 = (((_766 * _766) * (select((_686 > _682), (_657 - (_719 / (exp2(((_686 - _682) * 1.4426950216293335f) * _721) + 1.0f))), _692) - _746)) * (3.0f - (_766 * 2.0f))) + _746;
  float _788 = (((_767 * _767) * (select((_687 > _682), (_657 - (_719 / (exp2(((_687 - _682) * 1.4426950216293335f) * _721) + 1.0f))), _693) - _747)) * (3.0f - (_767 * 2.0f))) + _747;
  float _789 = (((_768 * _768) * (select((_688 > _682), (_657 - (_719 / (exp2(((_688 - _682) * 1.4426950216293335f) * _721) + 1.0f))), _694) - _748)) * (3.0f - (_768 * 2.0f))) + _748;
  float _790 = dot(float3(_787, _788, _789), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _810 = (ToneCurveAmount * (max(0.0f, (lerp(_790, _787, 0.9300000071525574f))) - _506)) + _506;
  float _811 = (ToneCurveAmount * (max(0.0f, (lerp(_790, _788, 0.9300000071525574f))) - _507)) + _507;
  float _812 = (ToneCurveAmount * (max(0.0f, (lerp(_790, _789, 0.9300000071525574f))) - _508)) + _508;
  float _828 = ((mad(-0.06537103652954102f, _812, mad(1.451815478503704e-06f, _811, (_810 * 1.065374732017517f))) - _810) * BlueCorrection) + _810;
  float _829 = ((mad(-0.20366770029067993f, _812, mad(1.2036634683609009f, _811, (_810 * -2.57161445915699e-07f))) - _811) * BlueCorrection) + _811;
  float _830 = ((mad(0.9999996423721313f, _812, mad(2.0954757928848267e-08f, _811, (_810 * 1.862645149230957e-08f))) - _812) * BlueCorrection) + _812;
#endif

#endif
  // SetTonemappedAP1(_828, _829, _830);

  // Remove max(0)
  float _855 = mad((WorkingColorSpace.FromAP1[0].z), _830, mad((WorkingColorSpace.FromAP1[0].y), _829, ((WorkingColorSpace.FromAP1[0].x) * _828)));
  float _856 = mad((WorkingColorSpace.FromAP1[1].z), _830, mad((WorkingColorSpace.FromAP1[1].y), _829, ((WorkingColorSpace.FromAP1[1].x) * _828)));
  float _857 = mad((WorkingColorSpace.FromAP1[2].z), _830, mad((WorkingColorSpace.FromAP1[2].y), _829, ((WorkingColorSpace.FromAP1[2].x) * _828)));
  /* if (_855 < 0.0031306699384003878f) {
    _868 = (_855 * 12.920000076293945f);
  } else {
    _868 = (((pow(_855, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_856 < 0.0031306699384003878f) {
    _879 = (_856 * 12.920000076293945f);
  } else {
    _879 = (((pow(_856, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_857 < 0.0031306699384003878f) {
    _890 = (_857 * 12.920000076293945f);
  } else {
    _890 = (((pow(_857, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _894 = (_879 * 0.9375f) + 0.03125f;
  float _901 = _890 * 15.0f;
  float _902 = floor(_901);
  float _903 = _901 - _902;
  float _905 = (((_868 * 0.9375f) + 0.03125f) + _902) * 0.0625f;
  float4 _908 = Textures_1.Sample(Samplers_1, float2(_905, _894));
  float4 _915 = Textures_1.Sample(Samplers_1, float2((_905 + 0.0625f), _894));
  float _934 = max(6.103519990574569e-05f, (((lerp(_908.x, _915.x, _903)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _868)));
  float _935 = max(6.103519990574569e-05f, (((lerp(_908.y, _915.y, _903)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _879)));
  float _936 = max(6.103519990574569e-05f, (((lerp(_908.z, _915.z, _903)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _890)));
  float _958 = select((_934 > 0.040449999272823334f), exp2(log2((_934 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_934 * 0.07739938050508499f));
  float _959 = select((_935 > 0.040449999272823334f), exp2(log2((_935 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_935 * 0.07739938050508499f));
  float _960 = select((_936 > 0.040449999272823334f), exp2(log2((_936 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_936 * 0.07739938050508499f)); */

  float3 untonemapped = float3(_855, _856, _857);
  float _958;
  float _959;
  float _960;
  SampleLUTUpgradeToneMap(untonemapped, Samplers_1, Textures_1, _958, _959, _960);

  float _986 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _958)) * _958) + MappingPolynomial.z);
  float _987 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _959)) * _959) + MappingPolynomial.z);
  float _988 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _960)) * _960) + MappingPolynomial.z);

  // Separate the lerp into their own temporaries, keeping the max in the final expressions.
  float _lerpR = lerp(_986, OverlayColor.x, OverlayColor.w);
  float _lerpG = lerp(_987, OverlayColor.y, OverlayColor.w);
  float _lerpB = lerp(_988, OverlayColor.z, OverlayColor.w);

  if (GenerateOutput(_lerpR, _lerpG, _lerpB, SV_Target, is_hdr)) {
    return SV_Target;
  }

  float _1009 = exp2(log2(max(0.0f, _lerpR)) * InverseGamma.y);
  float _1010 = exp2(log2(max(0.0f, _lerpG)) * InverseGamma.y);
  float _1011 = exp2(log2(max(0.0f, _lerpB)) * InverseGamma.y);

  if ((uint)(WorkingColorSpace.bIsSRGB) == 0) {
    float _1030 = mad((WorkingColorSpace.ToAP1[0].z), _1011, mad((WorkingColorSpace.ToAP1[0].y), _1010, ((WorkingColorSpace.ToAP1[0].x) * _1009)));
    float _1033 = mad((WorkingColorSpace.ToAP1[1].z), _1011, mad((WorkingColorSpace.ToAP1[1].y), _1010, ((WorkingColorSpace.ToAP1[1].x) * _1009)));
    float _1036 = mad((WorkingColorSpace.ToAP1[2].z), _1011, mad((WorkingColorSpace.ToAP1[2].y), _1010, ((WorkingColorSpace.ToAP1[2].x) * _1009)));
    _1047 = mad(_43, _1036, mad(_42, _1033, (_1030 * _41)));
    _1048 = mad(_46, _1036, mad(_45, _1033, (_1030 * _44)));
    _1049 = mad(_49, _1036, mad(_48, _1033, (_1030 * _47)));
  } else {
    _1047 = _1009;
    _1048 = _1010;
    _1049 = _1011;
  }
  if (_1047 < 0.0031306699384003878f) {
    _1060 = (_1047 * 12.920000076293945f);
  } else {
    _1060 = (((pow(_1047, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1048 < 0.0031306699384003878f) {
    _1071 = (_1048 * 12.920000076293945f);
  } else {
    _1071 = (((pow(_1048, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1049 < 0.0031306699384003878f) {
    _1082 = (_1049 * 12.920000076293945f);
  } else {
    _1082 = (((pow(_1049, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1060 * 0.9523810148239136f);
  SV_Target.y = (_1071 * 0.9523810148239136f);
  SV_Target.z = (_1082 * 0.9523810148239136f);

  SV_Target.w = 0.0f;
  return SV_Target;
}
