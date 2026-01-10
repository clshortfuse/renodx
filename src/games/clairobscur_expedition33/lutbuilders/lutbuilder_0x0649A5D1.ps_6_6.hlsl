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
  float _112;
  float _819;
  float _852;
  float _866;
  float _930;
  float _1121;
  float _1132;
  float _1143;
  float _1300;
  float _1301;
  float _1302;
  float _1313;
  float _1324;
  float _1335;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _30 = (output_gamut == 4);
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
  float _64 = (exp2(((float((uint)(int)(SV_RenderTargetArrayIndex)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _91 = (bIsTemperatureWhiteBalance != 0);
  float _95 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _112 = (((((2967800.0f - (_95 * 4607000064.0f)) * _95) + 99.11000061035156f) * _95) + 0.24406300485134125f);
  } else {
    _112 = (((((1901800.0f - (_95 * 2006400000.0f)) * _95) + 247.47999572753906f) * _95) + 0.23703999817371368f);
  }
  float _126 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _133 = WhiteTemp * WhiteTemp;
  float _136 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_133 * 1.6145605741257896e-07f));
  float _141 = ((_126 * 2.0f) + 4.0f) - (_136 * 8.0f);
  float _142 = (_126 * 3.0f) / _141;
  float _144 = (_136 * 2.0f) / _141;
  bool _145 = (WhiteTemp < 4000.0f);
  float _154 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _156 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_133 * 1.5317699909210205f)) / (_154 * _154);
  float _163 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _133;
  float _165 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_133 * 308.60699462890625f)) / (_163 * _163);
  float _167 = rsqrt(dot(float2(_156, _165), float2(_156, _165)));
  float _168 = WhiteTint * 0.05000000074505806f;
  float _171 = ((_168 * _165) * _167) + _126;
  float _174 = _136 - ((_168 * _156) * _167);
  float _179 = (4.0f - (_174 * 8.0f)) + (_171 * 2.0f);
  float _185 = (((_171 * 3.0f) / _179) - _142) + select(_145, _142, _112);
  float _186 = (((_174 * 2.0f) / _179) - _144) + select(_145, _144, (((_112 * 2.869999885559082f) + -0.2750000059604645f) - ((_112 * _112) * 3.0f)));
  float _187 = select(_91, _185, 0.3127000033855438f);
  float _188 = select(_91, _186, 0.32899999618530273f);
  float _189 = select(_91, 0.3127000033855438f, _185);
  float _190 = select(_91, 0.32899999618530273f, _186);
  float _191 = max(_188, 1.000000013351432e-10f);
  float _192 = _187 / _191;
  float _195 = ((1.0f - _187) - _188) / _191;
  float _196 = max(_190, 1.000000013351432e-10f);
  float _197 = _189 / _196;
  float _200 = ((1.0f - _189) - _190) / _196;
  float _219 = mad(-0.16140000522136688f, _200, ((_197 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _195, ((_192 * 0.8950999975204468f) + 0.266400009393692f));
  float _220 = mad(0.03669999912381172f, _200, (1.7135000228881836f - (_197 * 0.7501999735832214f))) / mad(0.03669999912381172f, _195, (1.7135000228881836f - (_192 * 0.7501999735832214f)));
  float _221 = mad(1.0296000242233276f, _200, ((_197 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _195, ((_192 * 0.03889999911189079f) + -0.06849999725818634f));
  float _222 = mad(_220, -0.7501999735832214f, 0.0f);
  float _223 = mad(_220, 1.7135000228881836f, 0.0f);
  float _224 = mad(_220, 0.03669999912381172f, -0.0f);
  float _225 = mad(_221, 0.03889999911189079f, 0.0f);
  float _226 = mad(_221, -0.06849999725818634f, 0.0f);
  float _227 = mad(_221, 1.0296000242233276f, 0.0f);
  float _230 = mad(0.1599626988172531f, _225, mad(-0.1470542997121811f, _222, (_219 * 0.883457362651825f)));
  float _233 = mad(0.1599626988172531f, _226, mad(-0.1470542997121811f, _223, (_219 * 0.26293492317199707f)));
  float _236 = mad(0.1599626988172531f, _227, mad(-0.1470542997121811f, _224, (_219 * -0.15930065512657166f)));
  float _239 = mad(0.04929120093584061f, _225, mad(0.5183603167533875f, _222, (_219 * 0.38695648312568665f)));
  float _242 = mad(0.04929120093584061f, _226, mad(0.5183603167533875f, _223, (_219 * 0.11516613513231277f)));
  float _245 = mad(0.04929120093584061f, _227, mad(0.5183603167533875f, _224, (_219 * -0.0697740763425827f)));
  float _248 = mad(0.9684867262840271f, _225, mad(0.04004279896616936f, _222, (_219 * -0.007634039502590895f)));
  float _251 = mad(0.9684867262840271f, _226, mad(0.04004279896616936f, _223, (_219 * -0.0022720457054674625f)));
  float _254 = mad(0.9684867262840271f, _227, mad(0.04004279896616936f, _224, (_219 * 0.0013765322510153055f)));
  float _257 = mad(_236, (WorkingColorSpace.ToXYZ[2].x), mad(_233, (WorkingColorSpace.ToXYZ[1].x), (_230 * (WorkingColorSpace.ToXYZ[0].x))));
  float _260 = mad(_236, (WorkingColorSpace.ToXYZ[2].y), mad(_233, (WorkingColorSpace.ToXYZ[1].y), (_230 * (WorkingColorSpace.ToXYZ[0].y))));
  float _263 = mad(_236, (WorkingColorSpace.ToXYZ[2].z), mad(_233, (WorkingColorSpace.ToXYZ[1].z), (_230 * (WorkingColorSpace.ToXYZ[0].z))));
  float _266 = mad(_245, (WorkingColorSpace.ToXYZ[2].x), mad(_242, (WorkingColorSpace.ToXYZ[1].x), (_239 * (WorkingColorSpace.ToXYZ[0].x))));
  float _269 = mad(_245, (WorkingColorSpace.ToXYZ[2].y), mad(_242, (WorkingColorSpace.ToXYZ[1].y), (_239 * (WorkingColorSpace.ToXYZ[0].y))));
  float _272 = mad(_245, (WorkingColorSpace.ToXYZ[2].z), mad(_242, (WorkingColorSpace.ToXYZ[1].z), (_239 * (WorkingColorSpace.ToXYZ[0].z))));
  float _275 = mad(_254, (WorkingColorSpace.ToXYZ[2].x), mad(_251, (WorkingColorSpace.ToXYZ[1].x), (_248 * (WorkingColorSpace.ToXYZ[0].x))));
  float _278 = mad(_254, (WorkingColorSpace.ToXYZ[2].y), mad(_251, (WorkingColorSpace.ToXYZ[1].y), (_248 * (WorkingColorSpace.ToXYZ[0].y))));
  float _281 = mad(_254, (WorkingColorSpace.ToXYZ[2].z), mad(_251, (WorkingColorSpace.ToXYZ[1].z), (_248 * (WorkingColorSpace.ToXYZ[0].z))));
  float _311 = mad(mad((WorkingColorSpace.FromXYZ[0].z), _281, mad((WorkingColorSpace.FromXYZ[0].y), _272, (_263 * (WorkingColorSpace.FromXYZ[0].x)))), _64, mad(mad((WorkingColorSpace.FromXYZ[0].z), _278, mad((WorkingColorSpace.FromXYZ[0].y), _269, (_260 * (WorkingColorSpace.FromXYZ[0].x)))), _63, (mad((WorkingColorSpace.FromXYZ[0].z), _275, mad((WorkingColorSpace.FromXYZ[0].y), _266, (_257 * (WorkingColorSpace.FromXYZ[0].x)))) * _62)));
  float _314 = mad(mad((WorkingColorSpace.FromXYZ[1].z), _281, mad((WorkingColorSpace.FromXYZ[1].y), _272, (_263 * (WorkingColorSpace.FromXYZ[1].x)))), _64, mad(mad((WorkingColorSpace.FromXYZ[1].z), _278, mad((WorkingColorSpace.FromXYZ[1].y), _269, (_260 * (WorkingColorSpace.FromXYZ[1].x)))), _63, (mad((WorkingColorSpace.FromXYZ[1].z), _275, mad((WorkingColorSpace.FromXYZ[1].y), _266, (_257 * (WorkingColorSpace.FromXYZ[1].x)))) * _62)));
  float _317 = mad(mad((WorkingColorSpace.FromXYZ[2].z), _281, mad((WorkingColorSpace.FromXYZ[2].y), _272, (_263 * (WorkingColorSpace.FromXYZ[2].x)))), _64, mad(mad((WorkingColorSpace.FromXYZ[2].z), _278, mad((WorkingColorSpace.FromXYZ[2].y), _269, (_260 * (WorkingColorSpace.FromXYZ[2].x)))), _63, (mad((WorkingColorSpace.FromXYZ[2].z), _275, mad((WorkingColorSpace.FromXYZ[2].y), _266, (_257 * (WorkingColorSpace.FromXYZ[2].x)))) * _62)));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _332 = mad((WorkingColorSpace.ToAP1[0].z), _317, mad((WorkingColorSpace.ToAP1[0].y), _314, ((WorkingColorSpace.ToAP1[0].x) * _311)));
  float _335 = mad((WorkingColorSpace.ToAP1[1].z), _317, mad((WorkingColorSpace.ToAP1[1].y), _314, ((WorkingColorSpace.ToAP1[1].x) * _311)));
  float _338 = mad((WorkingColorSpace.ToAP1[2].z), _317, mad((WorkingColorSpace.ToAP1[2].y), _314, ((WorkingColorSpace.ToAP1[2].x) * _311)));
  float _339 = dot(float3(_332, _335, _338), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  // SetUngradedAP1(_332, _335, _338);

  float _343 = (_332 / _339) + -1.0f;
  float _344 = (_335 / _339) + -1.0f;
  float _345 = (_338 / _339) + -1.0f;
  float _357 = (1.0f - exp2(((_339 * _339) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_343, _344, _345), float3(_343, _344, _345)) * -4.0f));
  float _373 = ((mad(-0.06368321925401688f, _338, mad(-0.3292922377586365f, _335, (_332 * 1.3704125881195068f))) - _332) * _357) + _332;
  float _374 = ((mad(-0.010861365124583244f, _338, mad(1.0970927476882935f, _335, (_332 * -0.08343357592821121f))) - _335) * _357) + _335;
  float _375 = ((mad(1.2036951780319214f, _338, mad(-0.09862580895423889f, _335, (_332 * -0.02579331398010254f))) - _338) * _357) + _338;
  float _376 = dot(float3(_373, _374, _375), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _390 = ColorOffset.w + ColorOffsetShadows.w;
  float _404 = ColorGain.w * ColorGainShadows.w;
  float _418 = ColorGamma.w * ColorGammaShadows.w;
  float _432 = ColorContrast.w * ColorContrastShadows.w;
  float _446 = ColorSaturation.w * ColorSaturationShadows.w;
  float _450 = _373 - _376;
  float _451 = _374 - _376;
  float _452 = _375 - _376;
  float _509 = saturate(_376 / ColorCorrectionShadowsMax);
  float _513 = (_509 * _509) * (3.0f - (_509 * 2.0f));
  float _514 = 1.0f - _513;
  float _523 = ColorOffset.w + ColorOffsetHighlights.w;
  float _532 = ColorGain.w * ColorGainHighlights.w;
  float _541 = ColorGamma.w * ColorGammaHighlights.w;
  float _550 = ColorContrast.w * ColorContrastHighlights.w;
  float _559 = ColorSaturation.w * ColorSaturationHighlights.w;
  float _622 = saturate((_376 - ColorCorrectionHighlightsMin) / (ColorCorrectionHighlightsMax - ColorCorrectionHighlightsMin));
  float _626 = (_622 * _622) * (3.0f - (_622 * 2.0f));
  float _635 = ColorOffset.w + ColorOffsetMidtones.w;
  float _644 = ColorGain.w * ColorGainMidtones.w;
  float _653 = ColorGamma.w * ColorGammaMidtones.w;
  float _662 = ColorContrast.w * ColorContrastMidtones.w;
  float _671 = ColorSaturation.w * ColorSaturationMidtones.w;
  float _729 = _513 - _626;
  float _740 = ((_626 * (((ColorOffset.x + ColorOffsetHighlights.x) + _523) + (((ColorGain.x * ColorGainHighlights.x) * _532) * exp2(log2(exp2(((ColorContrast.x * ColorContrastHighlights.x) * _550) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationHighlights.x) * _559) * _450) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaHighlights.x) * _541)))))) + (_514 * (((ColorOffset.x + ColorOffsetShadows.x) + _390) + (((ColorGain.x * ColorGainShadows.x) * _404) * exp2(log2(exp2(((ColorContrast.x * ColorContrastShadows.x) * _432) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationShadows.x) * _446) * _450) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaShadows.x) * _418))))))) + ((((ColorOffset.x + ColorOffsetMidtones.x) + _635) + (((ColorGain.x * ColorGainMidtones.x) * _644) * exp2(log2(exp2(((ColorContrast.x * ColorContrastMidtones.x) * _662) * log2(max(0.0f, ((((ColorSaturation.x * ColorSaturationMidtones.x) * _671) * _450) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.x * ColorGammaMidtones.x) * _653))))) * _729);
  float _742 = ((_626 * (((ColorOffset.y + ColorOffsetHighlights.y) + _523) + (((ColorGain.y * ColorGainHighlights.y) * _532) * exp2(log2(exp2(((ColorContrast.y * ColorContrastHighlights.y) * _550) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationHighlights.y) * _559) * _451) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaHighlights.y) * _541)))))) + (_514 * (((ColorOffset.y + ColorOffsetShadows.y) + _390) + (((ColorGain.y * ColorGainShadows.y) * _404) * exp2(log2(exp2(((ColorContrast.y * ColorContrastShadows.y) * _432) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationShadows.y) * _446) * _451) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaShadows.y) * _418))))))) + ((((ColorOffset.y + ColorOffsetMidtones.y) + _635) + (((ColorGain.y * ColorGainMidtones.y) * _644) * exp2(log2(exp2(((ColorContrast.y * ColorContrastMidtones.y) * _662) * log2(max(0.0f, ((((ColorSaturation.y * ColorSaturationMidtones.y) * _671) * _451) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.y * ColorGammaMidtones.y) * _653))))) * _729);
  float _744 = ((_626 * (((ColorOffset.z + ColorOffsetHighlights.z) + _523) + (((ColorGain.z * ColorGainHighlights.z) * _532) * exp2(log2(exp2(((ColorContrast.z * ColorContrastHighlights.z) * _550) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationHighlights.z) * _559) * _452) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaHighlights.z) * _541)))))) + (_514 * (((ColorOffset.z + ColorOffsetShadows.z) + _390) + (((ColorGain.z * ColorGainShadows.z) * _404) * exp2(log2(exp2(((ColorContrast.z * ColorContrastShadows.z) * _432) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationShadows.z) * _446) * _452) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaShadows.z) * _418))))))) + ((((ColorOffset.z + ColorOffsetMidtones.z) + _635) + (((ColorGain.z * ColorGainMidtones.z) * _644) * exp2(log2(exp2(((ColorContrast.z * ColorContrastMidtones.z) * _662) * log2(max(0.0f, ((((ColorSaturation.z * ColorSaturationMidtones.z) * _671) * _452) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((ColorGamma.z * ColorGammaMidtones.z) * _653))))) * _729);

  // Will cause issues with grayscale scenes if moved above
  // SetUntonemappedAP1(_740, _742, _744);
#if 1  // begin FilmToneMap with BlueCorrect
  float _1081, _1082, _1083;
  ApplyFilmToneMapWithBlueCorrect(_740, _742, _744,
                                  _1081, _1082, _1083);
#else

  float _759 = ((mad(0.061360642313957214f, _744, mad(-4.540197551250458e-09f, _742, (_740 * 0.9386394023895264f))) - _740) * BlueCorrection) + _740;
  float _760 = ((mad(0.169205904006958f, _744, mad(0.8307942152023315f, _742, (_740 * 6.775371730327606e-08f))) - _742) * BlueCorrection) + _742;
  float _761 = (mad(-2.3283064365386963e-10f, _742, (_740 * -9.313225746154785e-10f)) * BlueCorrection) + _744;
  float _764 = mad(0.16386905312538147f, _761, mad(0.14067868888378143f, _760, (_759 * 0.6954522132873535f)));
  float _767 = mad(0.0955343246459961f, _761, mad(0.8596711158752441f, _760, (_759 * 0.044794581830501556f)));
  float _770 = mad(1.0015007257461548f, _761, mad(0.004025210160762072f, _760, (_759 * -0.005525882821530104f)));
  float _774 = max(max(_764, _767), _770);
  float _779 = (max(_774, 1.000000013351432e-10f) - max(min(min(_764, _767), _770), 1.000000013351432e-10f)) / max(_774, 0.009999999776482582f);
  float _792 = ((_767 + _764) + _770) + (sqrt((((_770 - _767) * _770) + ((_767 - _764) * _767)) + ((_764 - _770) * _764)) * 1.75f);
  float _793 = _792 * 0.3333333432674408f;
  float _794 = _779 + -0.4000000059604645f;
  float _795 = _794 * 5.0f;
  float _799 = max((1.0f - abs(_794 * 2.5f)), 0.0f);
  float _810 = ((float(((int)(uint)((bool)(_795 > 0.0f))) - ((int)(uint)((bool)(_795 < 0.0f)))) * (1.0f - (_799 * _799))) + 1.0f) * 0.02500000037252903f;
  if (!(_793 <= 0.0533333346247673f)) {
    if (!(_793 >= 0.1599999964237213f)) {
      _819 = (((0.23999999463558197f / _792) + -0.5f) * _810);
    } else {
      _819 = 0.0f;
    }
  } else {
    _819 = _810;
  }
  float _820 = _819 + 1.0f;
  float _821 = _820 * _764;
  float _822 = _820 * _767;
  float _823 = _820 * _770;
  if (!((bool)(_821 == _822) && (bool)(_822 == _823))) {
    float _830 = ((_821 * 2.0f) - _822) - _823;
    float _833 = ((_767 - _770) * 1.7320507764816284f) * _820;
    float _835 = atan(_833 / _830);
    bool _838 = (_830 < 0.0f);
    bool _839 = (_830 == 0.0f);
    bool _840 = (_833 >= 0.0f);
    bool _841 = (_833 < 0.0f);
    _852 = select((_840 && _839), 90.0f, select((_841 && _839), -90.0f, (select((_841 && _838), (_835 + -3.1415927410125732f), select((_840 && _838), (_835 + 3.1415927410125732f), _835)) * 57.2957763671875f)));
  } else {
    _852 = 0.0f;
  }
  float _857 = min(max(select((_852 < 0.0f), (_852 + 360.0f), _852), 0.0f), 360.0f);
  if (_857 < -180.0f) {
    _866 = (_857 + 360.0f);
  } else {
    if (_857 > 180.0f) {
      _866 = (_857 + -360.0f);
    } else {
      _866 = _857;
    }
  }
  float _870 = saturate(1.0f - abs(_866 * 0.014814814552664757f));
  float _874 = (_870 * _870) * (3.0f - (_870 * 2.0f));
  float _880 = ((_874 * _874) * ((_779 * 0.18000000715255737f) * (0.029999999329447746f - _821))) + _821;
  float _890 = max(0.0f, mad(-0.21492856740951538f, _823, mad(-0.2365107536315918f, _822, (_880 * 1.4514392614364624f))));
  float _891 = max(0.0f, mad(-0.09967592358589172f, _823, mad(1.17622971534729f, _822, (_880 * -0.07655377686023712f))));
  float _892 = max(0.0f, mad(0.9977163076400757f, _823, mad(-0.006032449658960104f, _822, (_880 * 0.008316148072481155f))));
  float _893 = dot(float3(_890, _891, _892), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float3 lerpColor = lerp(_893, float3(_890, _891, _892), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _759, _760, _761);
  float _1081 = lerpColor.r, _1082 = lerpColor.g, _1083 = lerpColor.b;
#else
  float _908 = (FilmBlackClip + 1.0f) - FilmToe;
  float _910 = FilmWhiteClip + 1.0f;
  float _912 = _910 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _930 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _921 = (FilmBlackClip + 0.18000000715255737f) / _908;
    _930 = (-0.7447274923324585f - ((log2(_921 / (2.0f - _921)) * 0.3465735912322998f) * (_908 / FilmSlope)));
  }
  float _933 = ((1.0f - FilmToe) / FilmSlope) - _930;
  float _935 = (FilmShoulder / FilmSlope) - _933;
  float _939 = log2(lerp(_893, _890, 0.9599999785423279f)) * 0.3010300099849701f;
  float _940 = log2(lerp(_893, _891, 0.9599999785423279f)) * 0.3010300099849701f;
  float _941 = log2(lerp(_893, _892, 0.9599999785423279f)) * 0.3010300099849701f;
  float _945 = FilmSlope * (_939 + _933);
  float _946 = FilmSlope * (_940 + _933);
  float _947 = FilmSlope * (_941 + _933);
  float _948 = _908 * 2.0f;
  float _950 = (FilmSlope * -2.0f) / _908;
  float _951 = _939 - _930;
  float _952 = _940 - _930;
  float _953 = _941 - _930;
  float _972 = _912 * 2.0f;
  float _974 = (FilmSlope * 2.0f) / _912;
  float _999 = select((_939 < _930), ((_948 / (exp2((_951 * 1.4426950216293335f) * _950) + 1.0f)) - FilmBlackClip), _945);
  float _1000 = select((_940 < _930), ((_948 / (exp2((_952 * 1.4426950216293335f) * _950) + 1.0f)) - FilmBlackClip), _946);
  float _1001 = select((_941 < _930), ((_948 / (exp2((_953 * 1.4426950216293335f) * _950) + 1.0f)) - FilmBlackClip), _947);
  float _1008 = _935 - _930;
  float _1012 = saturate(_951 / _1008);
  float _1013 = saturate(_952 / _1008);
  float _1014 = saturate(_953 / _1008);
  bool _1015 = (_935 < _930);
  float _1019 = select(_1015, (1.0f - _1012), _1012);
  float _1020 = select(_1015, (1.0f - _1013), _1013);
  float _1021 = select(_1015, (1.0f - _1014), _1014);
  float _1040 = (((_1019 * _1019) * (select((_939 > _935), (_910 - (_972 / (exp2(((_939 - _935) * 1.4426950216293335f) * _974) + 1.0f))), _945) - _999)) * (3.0f - (_1019 * 2.0f))) + _999;
  float _1041 = (((_1020 * _1020) * (select((_940 > _935), (_910 - (_972 / (exp2(((_940 - _935) * 1.4426950216293335f) * _974) + 1.0f))), _946) - _1000)) * (3.0f - (_1020 * 2.0f))) + _1000;
  float _1042 = (((_1021 * _1021) * (select((_941 > _935), (_910 - (_972 / (exp2(((_941 - _935) * 1.4426950216293335f) * _974) + 1.0f))), _947) - _1001)) * (3.0f - (_1021 * 2.0f))) + _1001;
  float _1043 = dot(float3(_1040, _1041, _1042), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1063 = (ToneCurveAmount * (max(0.0f, (lerp(_1043, _1040, 0.9300000071525574f))) - _759)) + _759;
  float _1064 = (ToneCurveAmount * (max(0.0f, (lerp(_1043, _1041, 0.9300000071525574f))) - _760)) + _760;
  float _1065 = (ToneCurveAmount * (max(0.0f, (lerp(_1043, _1042, 0.9300000071525574f))) - _761)) + _761;
  float _1081 = ((mad(-0.06537103652954102f, _1065, mad(1.451815478503704e-06f, _1064, (_1063 * 1.065374732017517f))) - _1063) * BlueCorrection) + _1063;
  float _1082 = ((mad(-0.20366770029067993f, _1065, mad(1.2036634683609009f, _1064, (_1063 * -2.57161445915699e-07f))) - _1064) * BlueCorrection) + _1064;
  float _1083 = ((mad(0.9999996423721313f, _1065, mad(2.0954757928848267e-08f, _1064, (_1063 * 1.862645149230957e-08f))) - _1065) * BlueCorrection) + _1065;
#endif

#endif
  // SetTonemappedAP1(_1081, _1082, _1083);

  /* float _1108 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[0].z), _1083, mad((WorkingColorSpace.FromAP1[0].y), _1082, ((WorkingColorSpace.FromAP1[0].x) * _1081)))));
  float _1109 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[1].z), _1083, mad((WorkingColorSpace.FromAP1[1].y), _1082, ((WorkingColorSpace.FromAP1[1].x) * _1081)))));
  float _1110 = saturate(max(0.0f, mad((WorkingColorSpace.FromAP1[2].z), _1083, mad((WorkingColorSpace.FromAP1[2].y), _1082, ((WorkingColorSpace.FromAP1[2].x) * _1081)))));
  if (_1108 < 0.0031306699384003878f) {
    _1121 = (_1108 * 12.920000076293945f);
  } else {
    _1121 = (((pow(_1108, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1109 < 0.0031306699384003878f) {
    _1132 = (_1109 * 12.920000076293945f);
  } else {
    _1132 = (((pow(_1109, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1110 < 0.0031306699384003878f) {
    _1143 = (_1110 * 12.920000076293945f);
  } else {
    _1143 = (((pow(_1110, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1147 = (_1132 * 0.9375f) + 0.03125f;
  float _1154 = _1143 * 15.0f;
  float _1155 = floor(_1154);
  float _1156 = _1154 - _1155;
  float _1158 = (((_1121 * 0.9375f) + 0.03125f) + _1155) * 0.0625f;
  float4 _1161 = Textures_1.Sample(Samplers_1, float2(_1158, _1147));
  float4 _1168 = Textures_1.Sample(Samplers_1, float2((_1158 + 0.0625f), _1147));
  float _1187 = max(6.103519990574569e-05f, (((lerp(_1161.x, _1168.x, _1156)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1121)));
  float _1188 = max(6.103519990574569e-05f, (((lerp(_1161.y, _1168.y, _1156)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1132)));
  float _1189 = max(6.103519990574569e-05f, (((lerp(_1161.z, _1168.z, _1156)) * (LUTWeights[0].y)) + ((LUTWeights[0].x) * _1143)));
  float _1211 = select((_1187 > 0.040449999272823334f), exp2(log2((_1187 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1187 * 0.07739938050508499f));
  float _1212 = select((_1188 > 0.040449999272823334f), exp2(log2((_1188 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1188 * 0.07739938050508499f));
  float _1213 = select((_1189 > 0.040449999272823334f), exp2(log2((_1189 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1189 * 0.07739938050508499f)); */

  float3 untonemapped_bt709 = renodx::color::bt709::from::AP1(float3(_1081, _1082, _1083));
  float _1211;
  float _1212;
  float _1213;
  SampleLUTUpgradeToneMap(untonemapped_bt709, Samplers_1, Textures_1, _1211, _1212, _1213);

  float _1239 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1211)) * _1211) + MappingPolynomial.z);
  float _1240 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1212)) * _1212) + MappingPolynomial.z);
  float _1241 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1213)) * _1213) + MappingPolynomial.z);
  // Separate the lerp results into individual variables
  float _1265 = lerp(_1239, OverlayColor.x, OverlayColor.w);
  float _1266 = lerp(_1240, OverlayColor.y, OverlayColor.w);
  float _1267 = lerp(_1241, OverlayColor.z, OverlayColor.w);

  if (GenerateOutput(_1265, _1266, _1267, SV_Target, is_hdr)) {
    return SV_Target;
  }

  // Apply gamma correction to each component
  float _1262 = exp2(log2(max(0.0f, _1265)) * InverseGamma.y);
  float _1263 = exp2(log2(max(0.0f, _1266)) * InverseGamma.y);
  float _1264 = exp2(log2(max(0.0f, _1267)) * InverseGamma.y);

  if (WorkingColorSpace.bIsSRGB == 0) {
    float _1283 = mad((WorkingColorSpace.ToAP1[0].z), _1264, mad((WorkingColorSpace.ToAP1[0].y), _1263, ((WorkingColorSpace.ToAP1[0].x) * _1262)));
    float _1286 = mad((WorkingColorSpace.ToAP1[1].z), _1264, mad((WorkingColorSpace.ToAP1[1].y), _1263, ((WorkingColorSpace.ToAP1[1].x) * _1262)));
    float _1289 = mad((WorkingColorSpace.ToAP1[2].z), _1264, mad((WorkingColorSpace.ToAP1[2].y), _1263, ((WorkingColorSpace.ToAP1[2].x) * _1262)));
    _1300 = mad(_43, _1289, mad(_42, _1286, (_1283 * _41)));
    _1301 = mad(_46, _1289, mad(_45, _1286, (_1283 * _44)));
    _1302 = mad(_49, _1289, mad(_48, _1286, (_1283 * _47)));
  } else {
    _1300 = _1262;
    _1301 = _1263;
    _1302 = _1264;
  }
  if (_1300 < 0.0031306699384003878f) {
    _1313 = (_1300 * 12.920000076293945f);
  } else {
    _1313 = (((pow(_1300, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1301 < 0.0031306699384003878f) {
    _1324 = (_1301 * 12.920000076293945f);
  } else {
    _1324 = (((pow(_1301, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1302 < 0.0031306699384003878f) {
    _1335 = (_1302 * 12.920000076293945f);
  } else {
    _1335 = (((pow(_1302, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1313 * 0.9523810148239136f);
  SV_Target.y = (_1324 * 0.9523810148239136f);
  SV_Target.z = (_1335 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
