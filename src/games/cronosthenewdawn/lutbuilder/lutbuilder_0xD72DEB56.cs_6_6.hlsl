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
  float _9[6];
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _32 = 0.5f / LUTSize;
  float _37 = LUTSize + -1.0f;
  float _38 = (LUTSize * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _32)) / _37;
  float _39 = (LUTSize * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _32)) / _37;
  float _41 = float((uint)SV_DispatchThreadID.z) / _37;
  float _61;
  float _62;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _127;
  float _128;
  float _129;
  float _177;
  float _905;
  float _938;
  float _952;
  float _1016;
  float _1284;
  float _1285;
  float _1286;
  float _1297;
  float _1308;
  float _1481;
  float _1496;
  float _1511;
  float _1519;
  float _1520;
  float _1521;
  float _1588;
  float _1621;
  float _1635;
  float _1674;
  float _1796;
  float _1882;
  float _1956;
  float _2035;
  float _2036;
  float _2037;
  float _2167;
  float _2182;
  float _2197;
  float _2205;
  float _2206;
  float _2207;
  float _2274;
  float _2307;
  float _2321;
  float _2360;
  float _2482;
  float _2568;
  float _2654;
  float _2733;
  float _2734;
  float _2735;
  float _2912;
  float _2913;
  float _2914;
  if (!(OutputGamut == 1)) {
    if (!(OutputGamut == 2)) {
      if (!(OutputGamut == 3)) {
        bool _50 = (OutputGamut == 4);
        _61 = select(_50, 1.0f, 1.705051064491272f);
        _62 = select(_50, 0.0f, -0.6217921376228333f);
        _63 = select(_50, 0.0f, -0.0832589864730835f);
        _64 = select(_50, 0.0f, -0.13025647401809692f);
        _65 = select(_50, 1.0f, 1.140804648399353f);
        _66 = select(_50, 0.0f, -0.010548308491706848f);
        _67 = select(_50, 0.0f, -0.024003351107239723f);
        _68 = select(_50, 0.0f, -0.1289689838886261f);
        _69 = select(_50, 1.0f, 1.1529725790023804f);
      } else {
        _61 = 0.6954522132873535f;
        _62 = 0.14067870378494263f;
        _63 = 0.16386906802654266f;
        _64 = 0.044794563204050064f;
        _65 = 0.8596711158752441f;
        _66 = 0.0955343171954155f;
        _67 = -0.005525882821530104f;
        _68 = 0.004025210160762072f;
        _69 = 1.0015007257461548f;
      }
    } else {
      _61 = 1.0258246660232544f;
      _62 = -0.020053181797266006f;
      _63 = -0.005771636962890625f;
      _64 = -0.002234415616840124f;
      _65 = 1.0045864582061768f;
      _66 = -0.002352118492126465f;
      _67 = -0.005013350863009691f;
      _68 = -0.025290070101618767f;
      _69 = 1.0303035974502563f;
    }
  } else {
    _61 = 1.3792141675949097f;
    _62 = -0.30886411666870117f;
    _63 = -0.0703500509262085f;
    _64 = -0.06933490186929703f;
    _65 = 1.08229660987854f;
    _66 = -0.012961871922016144f;
    _67 = -0.0021590073592960835f;
    _68 = -0.0454593189060688f;
    _69 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)OutputDevice > (uint)2) {
    float _80 = (pow(_38, 0.012683313339948654f));
    float _81 = (pow(_39, 0.012683313339948654f));
    float _82 = (pow(_41, 0.012683313339948654f));
    _127 = (exp2(log2(max(0.0f, (_80 + -0.8359375f)) / (18.8515625f - (_80 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _128 = (exp2(log2(max(0.0f, (_81 + -0.8359375f)) / (18.8515625f - (_81 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _127 = ((exp2((_38 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _128 = ((exp2((_39 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _129 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _156 = (bIsTemperatureWhiteBalance != 0);
  float _160 = 0.9994439482688904f / WhiteTemp;
  if (!(!((WhiteTemp * 1.0005563497543335f) <= 7000.0f))) {
    _177 = (((((2967800.0f - (_160 * 4607000064.0f)) * _160) + 99.11000061035156f) * _160) + 0.24406300485134125f);
  } else {
    _177 = (((((1901800.0f - (_160 * 2006400000.0f)) * _160) + 247.47999572753906f) * _160) + 0.23703999817371368f);
  }
  float _191 = ((((WhiteTemp * 1.2864121856637212e-07f) + 0.00015411825734190643f) * WhiteTemp) + 0.8601177334785461f) / ((((WhiteTemp * 7.081451371959702e-07f) + 0.0008424202096648514f) * WhiteTemp) + 1.0f);
  float _198 = WhiteTemp * WhiteTemp;
  float _201 = ((((WhiteTemp * 4.204816761443908e-08f) + 4.228062607580796e-05f) * WhiteTemp) + 0.31739872694015503f) / ((1.0f - (WhiteTemp * 2.8974181986995973e-05f)) + (_198 * 1.6145605741257896e-07f));
  float _206 = ((_191 * 2.0f) + 4.0f) - (_201 * 8.0f);
  float _207 = (_191 * 3.0f) / _206;
  float _209 = (_201 * 2.0f) / _206;
  bool _210 = (WhiteTemp < 4000.0f);
  float _219 = ((WhiteTemp + 1189.6199951171875f) * WhiteTemp) + 1412139.875f;
  float _221 = ((-1137581184.0f - (WhiteTemp * 1916156.25f)) - (_198 * 1.5317699909210205f)) / (_219 * _219);
  float _228 = (6193636.0f - (WhiteTemp * 179.45599365234375f)) + _198;
  float _230 = ((1974715392.0f - (WhiteTemp * 705674.0f)) - (_198 * 308.60699462890625f)) / (_228 * _228);
  float _232 = rsqrt(dot(float2(_221, _230), float2(_221, _230)));
  float _233 = WhiteTint * 0.05000000074505806f;
  float _236 = ((_233 * _230) * _232) + _191;
  float _239 = _201 - ((_233 * _221) * _232);
  float _244 = (4.0f - (_239 * 8.0f)) + (_236 * 2.0f);
  float _250 = (((_236 * 3.0f) / _244) - _207) + select(_210, _207, _177);
  float _251 = (((_239 * 2.0f) / _244) - _209) + select(_210, _209, (((_177 * 2.869999885559082f) + -0.2750000059604645f) - ((_177 * _177) * 3.0f)));
  float _252 = select(_156, _250, 0.3127000033855438f);
  float _253 = select(_156, _251, 0.32899999618530273f);
  float _254 = select(_156, 0.3127000033855438f, _250);
  float _255 = select(_156, 0.32899999618530273f, _251);
  float _256 = max(_253, 1.000000013351432e-10f);
  float _257 = _252 / _256;
  float _260 = ((1.0f - _252) - _253) / _256;
  float _261 = max(_255, 1.000000013351432e-10f);
  float _262 = _254 / _261;
  float _265 = ((1.0f - _254) - _255) / _261;
  float _284 = mad(-0.16140000522136688f, _265, ((_262 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _260, ((_257 * 0.8950999975204468f) + 0.266400009393692f));
  float _285 = mad(0.03669999912381172f, _265, (1.7135000228881836f - (_262 * 0.7501999735832214f))) / mad(0.03669999912381172f, _260, (1.7135000228881836f - (_257 * 0.7501999735832214f)));
  float _286 = mad(1.0296000242233276f, _265, ((_262 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _260, ((_257 * 0.03889999911189079f) + -0.06849999725818634f));
  float _287 = mad(_285, -0.7501999735832214f, 0.0f);
  float _288 = mad(_285, 1.7135000228881836f, 0.0f);
  float _289 = mad(_285, 0.03669999912381172f, -0.0f);
  float _290 = mad(_286, 0.03889999911189079f, 0.0f);
  float _291 = mad(_286, -0.06849999725818634f, 0.0f);
  float _292 = mad(_286, 1.0296000242233276f, 0.0f);
  float _295 = mad(0.1599626988172531f, _290, mad(-0.1470542997121811f, _287, (_284 * 0.883457362651825f)));
  float _298 = mad(0.1599626988172531f, _291, mad(-0.1470542997121811f, _288, (_284 * 0.26293492317199707f)));
  float _301 = mad(0.1599626988172531f, _292, mad(-0.1470542997121811f, _289, (_284 * -0.15930065512657166f)));
  float _304 = mad(0.04929120093584061f, _290, mad(0.5183603167533875f, _287, (_284 * 0.38695648312568665f)));
  float _307 = mad(0.04929120093584061f, _291, mad(0.5183603167533875f, _288, (_284 * 0.11516613513231277f)));
  float _310 = mad(0.04929120093584061f, _292, mad(0.5183603167533875f, _289, (_284 * -0.0697740763425827f)));
  float _313 = mad(0.9684867262840271f, _290, mad(0.04004279896616936f, _287, (_284 * -0.007634039502590895f)));
  float _316 = mad(0.9684867262840271f, _291, mad(0.04004279896616936f, _288, (_284 * -0.0022720457054674625f)));
  float _319 = mad(0.9684867262840271f, _292, mad(0.04004279896616936f, _289, (_284 * 0.0013765322510153055f)));
  float _322 = mad(_301, (WorkingColorSpace_000[2].x), mad(_298, (WorkingColorSpace_000[1].x), (_295 * (WorkingColorSpace_000[0].x))));
  float _325 = mad(_301, (WorkingColorSpace_000[2].y), mad(_298, (WorkingColorSpace_000[1].y), (_295 * (WorkingColorSpace_000[0].y))));
  float _328 = mad(_301, (WorkingColorSpace_000[2].z), mad(_298, (WorkingColorSpace_000[1].z), (_295 * (WorkingColorSpace_000[0].z))));
  float _331 = mad(_310, (WorkingColorSpace_000[2].x), mad(_307, (WorkingColorSpace_000[1].x), (_304 * (WorkingColorSpace_000[0].x))));
  float _334 = mad(_310, (WorkingColorSpace_000[2].y), mad(_307, (WorkingColorSpace_000[1].y), (_304 * (WorkingColorSpace_000[0].y))));
  float _337 = mad(_310, (WorkingColorSpace_000[2].z), mad(_307, (WorkingColorSpace_000[1].z), (_304 * (WorkingColorSpace_000[0].z))));
  float _340 = mad(_319, (WorkingColorSpace_000[2].x), mad(_316, (WorkingColorSpace_000[1].x), (_313 * (WorkingColorSpace_000[0].x))));
  float _343 = mad(_319, (WorkingColorSpace_000[2].y), mad(_316, (WorkingColorSpace_000[1].y), (_313 * (WorkingColorSpace_000[0].y))));
  float _346 = mad(_319, (WorkingColorSpace_000[2].z), mad(_316, (WorkingColorSpace_000[1].z), (_313 * (WorkingColorSpace_000[0].z))));
  float _376 = mad(mad((WorkingColorSpace_064[0].z), _346, mad((WorkingColorSpace_064[0].y), _337, (_328 * (WorkingColorSpace_064[0].x)))), _129, mad(mad((WorkingColorSpace_064[0].z), _343, mad((WorkingColorSpace_064[0].y), _334, (_325 * (WorkingColorSpace_064[0].x)))), _128, (mad((WorkingColorSpace_064[0].z), _340, mad((WorkingColorSpace_064[0].y), _331, (_322 * (WorkingColorSpace_064[0].x)))) * _127)));
  float _379 = mad(mad((WorkingColorSpace_064[1].z), _346, mad((WorkingColorSpace_064[1].y), _337, (_328 * (WorkingColorSpace_064[1].x)))), _129, mad(mad((WorkingColorSpace_064[1].z), _343, mad((WorkingColorSpace_064[1].y), _334, (_325 * (WorkingColorSpace_064[1].x)))), _128, (mad((WorkingColorSpace_064[1].z), _340, mad((WorkingColorSpace_064[1].y), _331, (_322 * (WorkingColorSpace_064[1].x)))) * _127)));
  float _382 = mad(mad((WorkingColorSpace_064[2].z), _346, mad((WorkingColorSpace_064[2].y), _337, (_328 * (WorkingColorSpace_064[2].x)))), _129, mad(mad((WorkingColorSpace_064[2].z), _343, mad((WorkingColorSpace_064[2].y), _334, (_325 * (WorkingColorSpace_064[2].x)))), _128, (mad((WorkingColorSpace_064[2].z), _340, mad((WorkingColorSpace_064[2].y), _331, (_322 * (WorkingColorSpace_064[2].x)))) * _127)));
  float _397 = mad((WorkingColorSpace_128[0].z), _382, mad((WorkingColorSpace_128[0].y), _379, ((WorkingColorSpace_128[0].x) * _376)));
  float _400 = mad((WorkingColorSpace_128[1].z), _382, mad((WorkingColorSpace_128[1].y), _379, ((WorkingColorSpace_128[1].x) * _376)));
  float _403 = mad((WorkingColorSpace_128[2].z), _382, mad((WorkingColorSpace_128[2].y), _379, ((WorkingColorSpace_128[2].x) * _376)));
  float _404 = dot(float3(_397, _400, _403), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _408 = (_397 / _404) + -1.0f;
  float _409 = (_400 / _404) + -1.0f;
  float _410 = (_403 / _404) + -1.0f;
  float _422 = (1.0f - exp2(((_404 * _404) * -4.0f) * ExpandGamut)) * (1.0f - exp2(dot(float3(_408, _409, _410), float3(_408, _409, _410)) * -4.0f));
  float _438 = ((mad(-0.06368321925401688f, _403, mad(-0.3292922377586365f, _400, (_397 * 1.3704125881195068f))) - _397) * _422) + _397;
  float _439 = ((mad(-0.010861365124583244f, _403, mad(1.0970927476882935f, _400, (_397 * -0.08343357592821121f))) - _400) * _422) + _400;
  float _440 = ((mad(1.2036951780319214f, _403, mad(-0.09862580895423889f, _400, (_397 * -0.02579331398010254f))) - _403) * _422) + _403;
  float _441 = dot(float3(_438, _439, _440), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float3 WorkingColor = float3(_438, _439, _440);
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

  float _845 = ((mad(0.061360642313957214f, WorkingColor.b, mad(-4.540197551250458e-09f, WorkingColor.g, (WorkingColor.r * 0.9386394023895264f))) - WorkingColor.r) * BlueCorrection) + WorkingColor.r;
  float _846 = ((mad(0.169205904006958f, WorkingColor.b, mad(0.8307942152023315f, WorkingColor.g, (WorkingColor.r * 6.775371730327606e-08f))) - WorkingColor.g) * BlueCorrection) + WorkingColor.g;
  float _847 = (mad(-2.3283064365386963e-10f, WorkingColor.g, (WorkingColor.r * -9.313225746154785e-10f)) * BlueCorrection) + WorkingColor.b;
  float _850 = mad(0.16386905312538147f, _847, mad(0.14067868888378143f, _846, (_845 * 0.6954522132873535f)));
  float _853 = mad(0.0955343246459961f, _847, mad(0.8596711158752441f, _846, (_845 * 0.044794581830501556f)));
  float _856 = mad(1.0015007257461548f, _847, mad(0.004025210160762072f, _846, (_845 * -0.005525882821530104f)));
  float _860 = max(max(_850, _853), _856);
  float _865 = (max(_860, 1.000000013351432e-10f) - max(min(min(_850, _853), _856), 1.000000013351432e-10f)) / max(_860, 0.009999999776482582f);
  float _878 = ((_853 + _850) + _856) + (sqrt((((_856 - _853) * _856) + ((_853 - _850) * _853)) + ((_850 - _856) * _850)) * 1.75f);
  float _879 = _878 * 0.3333333432674408f;
  float _880 = _865 + -0.4000000059604645f;
  float _881 = _880 * 5.0f;
  float _885 = max((1.0f - abs(_880 * 2.5f)), 0.0f);
  float _896 = ((float((int)(((int)(uint)((bool)(_881 > 0.0f))) - ((int)(uint)((bool)(_881 < 0.0f))))) * (1.0f - (_885 * _885))) + 1.0f) * 0.02500000037252903f;
  if (!(_879 <= 0.0533333346247673f)) {
    if (!(_879 >= 0.1599999964237213f)) {
      _905 = (((0.23999999463558197f / _878) + -0.5f) * _896);
    } else {
      _905 = 0.0f;
    }
  } else {
    _905 = _896;
  }
  float _906 = _905 + 1.0f;
  float _907 = _906 * _850;
  float _908 = _906 * _853;
  float _909 = _906 * _856;
  if (!((bool)(_907 == _908) && (bool)(_908 == _909))) {
    float _916 = ((_907 * 2.0f) - _908) - _909;
    float _919 = ((_853 - _856) * 1.7320507764816284f) * _906;
    float _921 = atan(_919 / _916);
    bool _924 = (_916 < 0.0f);
    bool _925 = (_916 == 0.0f);
    bool _926 = (_919 >= 0.0f);
    bool _927 = (_919 < 0.0f);
    _938 = select((_926 && _925), 90.0f, select((_927 && _925), -90.0f, (select((_927 && _924), (_921 + -3.1415927410125732f), select((_926 && _924), (_921 + 3.1415927410125732f), _921)) * 57.2957763671875f)));
  } else {
    _938 = 0.0f;
  }
  float _943 = min(max(select((_938 < 0.0f), (_938 + 360.0f), _938), 0.0f), 360.0f);
  if (_943 < -180.0f) {
    _952 = (_943 + 360.0f);
  } else {
    if (_943 > 180.0f) {
      _952 = (_943 + -360.0f);
    } else {
      _952 = _943;
    }
  }
  float _956 = saturate(1.0f - abs(_952 * 0.014814814552664757f));
  float _960 = (_956 * _956) * (3.0f - (_956 * 2.0f));
  float _966 = ((_960 * _960) * ((_865 * 0.18000000715255737f) * (0.029999999329447746f - _907))) + _907;
  float _976 = max(0.0f, mad(-0.21492856740951538f, _909, mad(-0.2365107536315918f, _908, (_966 * 1.4514392614364624f))));
  float _977 = max(0.0f, mad(-0.09967592358589172f, _909, mad(1.17622971534729f, _908, (_966 * -0.07655377686023712f))));
  float _978 = max(0.0f, mad(0.9977163076400757f, _909, mad(-0.006032449658960104f, _908, (_966 * 0.008316148072481155f))));
  float _979 = dot(float3(_976, _977, _978), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _994 = (FilmBlackClip + 1.0f) - FilmToe;
  float _996 = FilmWhiteClip + 1.0f;
  float _998 = _996 - FilmShoulder;
  if (FilmToe > 0.800000011920929f) {
    _1016 = (((0.8199999928474426f - FilmToe) / FilmSlope) + -0.7447274923324585f);
  } else {
    float _1007 = (FilmBlackClip + 0.18000000715255737f) / _994;
    _1016 = (-0.7447274923324585f - ((log2(_1007 / (2.0f - _1007)) * 0.3465735912322998f) * (_994 / FilmSlope)));
  }
  float _1019 = ((1.0f - FilmToe) / FilmSlope) - _1016;
  float _1021 = (FilmShoulder / FilmSlope) - _1019;

  float _1167, _1168, _1169;
  if (is_hdr) {
    float3 lerpColor = lerp(_979, float3(_976, _977, _978), 0.9599999785423279f);
    ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b,
                       _845, _846, _847,
                       _1167, _1168, _1169);
  } else {
  float _1025 = log2(lerp(_979, _976, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1026 = log2(lerp(_979, _977, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1027 = log2(lerp(_979, _978, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1031 = FilmSlope * (_1025 + _1019);
  float _1032 = FilmSlope * (_1026 + _1019);
  float _1033 = FilmSlope * (_1027 + _1019);
  float _1034 = _994 * 2.0f;
  float _1036 = (FilmSlope * -2.0f) / _994;
  float _1037 = _1025 - _1016;
  float _1038 = _1026 - _1016;
  float _1039 = _1027 - _1016;
  float _1058 = _998 * 2.0f;
  float _1060 = (FilmSlope * 2.0f) / _998;
  float _1085 = select((_1025 < _1016), ((_1034 / (exp2((_1037 * 1.4426950216293335f) * _1036) + 1.0f)) - FilmBlackClip), _1031);
  float _1086 = select((_1026 < _1016), ((_1034 / (exp2((_1038 * 1.4426950216293335f) * _1036) + 1.0f)) - FilmBlackClip), _1032);
  float _1087 = select((_1027 < _1016), ((_1034 / (exp2((_1039 * 1.4426950216293335f) * _1036) + 1.0f)) - FilmBlackClip), _1033);
  float _1094 = _1021 - _1016;
  float _1098 = saturate(_1037 / _1094);
  float _1099 = saturate(_1038 / _1094);
  float _1100 = saturate(_1039 / _1094);
  bool _1101 = (_1021 < _1016);
  float _1105 = select(_1101, (1.0f - _1098), _1098);
  float _1106 = select(_1101, (1.0f - _1099), _1099);
  float _1107 = select(_1101, (1.0f - _1100), _1100);
  float _1126 = (((_1105 * _1105) * (select((_1025 > _1021), (_996 - (_1058 / (exp2(((_1025 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1031) - _1085)) * (3.0f - (_1105 * 2.0f))) + _1085;
  float _1127 = (((_1106 * _1106) * (select((_1026 > _1021), (_996 - (_1058 / (exp2(((_1026 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1032) - _1086)) * (3.0f - (_1106 * 2.0f))) + _1086;
  float _1128 = (((_1107 * _1107) * (select((_1027 > _1021), (_996 - (_1058 / (exp2(((_1027 - _1021) * 1.4426950216293335f) * _1060) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
  float _1129 = dot(float3(_1126, _1127, _1128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1149 = (ToneCurveAmount * (max(0.0f, (lerp(_1129, _1126, 0.9300000071525574f))) - _845)) + _845;
  float _1150 = (ToneCurveAmount * (max(0.0f, (lerp(_1129, _1127, 0.9300000071525574f))) - _846)) + _846;
  float _1151 = (ToneCurveAmount * (max(0.0f, (lerp(_1129, _1128, 0.9300000071525574f))) - _847)) + _847;
  _1167 = ((mad(-0.06537103652954102f, _1151, mad(1.451815478503704e-06f, _1150, (_1149 * 1.065374732017517f))) - _1149) * BlueCorrection) + _1149;
  _1168 = ((mad(-0.20366770029067993f, _1151, mad(1.2036634683609009f, _1150, (_1149 * -2.57161445915699e-07f))) - _1150) * BlueCorrection) + _1150;
  _1169 = ((mad(0.9999996423721313f, _1151, mad(2.0954757928848267e-08f, _1150, (_1149 * 1.862645149230957e-08f))) - _1151) * BlueCorrection) + _1151;
  }
  float _1179 = mad((WorkingColorSpace_192[0].z), _1169, mad((WorkingColorSpace_192[0].y), _1168, ((WorkingColorSpace_192[0].x) * _1167)));
  float _1180 = mad((WorkingColorSpace_192[1].z), _1169, mad((WorkingColorSpace_192[1].y), _1168, ((WorkingColorSpace_192[1].x) * _1167)));
  float _1181 = mad((WorkingColorSpace_192[2].z), _1169, mad((WorkingColorSpace_192[2].y), _1168, ((WorkingColorSpace_192[2].x) * _1167)));
  if (!is_hdr) {
    _1179 = max(0.0f, _1179);
    _1180 = max(0.0f, _1180);
    _1181 = max(0.0f, _1181);
  }
  float _1207 = ColorScale.x * (((MappingPolynomial.y + (MappingPolynomial.x * _1179)) * _1179) + MappingPolynomial.z);
  float _1208 = ColorScale.y * (((MappingPolynomial.y + (MappingPolynomial.x * _1180)) * _1180) + MappingPolynomial.z);
  float _1209 = ColorScale.z * (((MappingPolynomial.y + (MappingPolynomial.x * _1181)) * _1181) + MappingPolynomial.z);
  float _1216 = ((OverlayColor.x - _1207) * OverlayColor.w) + _1207;
  float _1217 = ((OverlayColor.y - _1208) * OverlayColor.w) + _1208;
  float _1218 = ((OverlayColor.z - _1209) * OverlayColor.w) + _1209;

  if (GenerateOutput(_1216, _1217, _1218, u0[SV_DispatchThreadID])) {
    return;
  }
  
  float _1219 = ColorScale.x * mad((WorkingColorSpace_192[0].z), WorkingColor.b, mad((WorkingColorSpace_192[0].y), WorkingColor.g, (WorkingColor.r * (WorkingColorSpace_192[0].x))));
  float _1220 = ColorScale.y * mad((WorkingColorSpace_192[1].z), WorkingColor.b, mad((WorkingColorSpace_192[1].y), WorkingColor.g, ((WorkingColorSpace_192[1].x) * WorkingColor.r)));
  float _1221 = ColorScale.z * mad((WorkingColorSpace_192[2].z), WorkingColor.b, mad((WorkingColorSpace_192[2].y), WorkingColor.g, ((WorkingColorSpace_192[2].x) * WorkingColor.r)));
  float _1228 = ((OverlayColor.x - _1219) * OverlayColor.w) + _1219;
  float _1229 = ((OverlayColor.y - _1220) * OverlayColor.w) + _1220;
  float _1230 = ((OverlayColor.z - _1221) * OverlayColor.w) + _1221;
  float _1242 = exp2(log2(max(0.0f, _1216)) * InverseGamma.y);
  float _1243 = exp2(log2(max(0.0f, _1217)) * InverseGamma.y);
  float _1244 = exp2(log2(max(0.0f, _1218)) * InverseGamma.y);
  [branch]
  if (OutputDevice == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1267 = mad((WorkingColorSpace_128[0].z), _1244, mad((WorkingColorSpace_128[0].y), _1243, ((WorkingColorSpace_128[0].x) * _1242)));
        float _1270 = mad((WorkingColorSpace_128[1].z), _1244, mad((WorkingColorSpace_128[1].y), _1243, ((WorkingColorSpace_128[1].x) * _1242)));
        float _1273 = mad((WorkingColorSpace_128[2].z), _1244, mad((WorkingColorSpace_128[2].y), _1243, ((WorkingColorSpace_128[2].x) * _1242)));
        _1284 = mad(_63, _1273, mad(_62, _1270, (_1267 * _61)));
        _1285 = mad(_66, _1273, mad(_65, _1270, (_1267 * _64)));
        _1286 = mad(_69, _1273, mad(_68, _1270, (_1267 * _67)));
      } else {
        _1284 = _1242;
        _1285 = _1243;
        _1286 = _1244;
      }
      do {
        if (_1284 < 0.0031306699384003878f) {
          _1297 = (_1284 * 12.920000076293945f);
        } else {
          _1297 = (((pow(_1284, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1285 < 0.0031306699384003878f) {
            _1308 = (_1285 * 12.920000076293945f);
          } else {
            _1308 = (((pow(_1285, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1286 < 0.0031306699384003878f) {
            _2912 = _1297;
            _2913 = _1308;
            _2914 = (_1286 * 12.920000076293945f);
          } else {
            _2912 = _1297;
            _2913 = _1308;
            _2914 = (((pow(_1286, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (OutputDevice == 1) {
      float _1335 = mad((WorkingColorSpace_128[0].z), _1244, mad((WorkingColorSpace_128[0].y), _1243, ((WorkingColorSpace_128[0].x) * _1242)));
      float _1338 = mad((WorkingColorSpace_128[1].z), _1244, mad((WorkingColorSpace_128[1].y), _1243, ((WorkingColorSpace_128[1].x) * _1242)));
      float _1341 = mad((WorkingColorSpace_128[2].z), _1244, mad((WorkingColorSpace_128[2].y), _1243, ((WorkingColorSpace_128[2].x) * _1242)));
      float _1351 = max(6.103519990574569e-05f, mad(_63, _1341, mad(_62, _1338, (_1335 * _61))));
      float _1352 = max(6.103519990574569e-05f, mad(_66, _1341, mad(_65, _1338, (_1335 * _64))));
      float _1353 = max(6.103519990574569e-05f, mad(_69, _1341, mad(_68, _1338, (_1335 * _67))));
      _2912 = min((_1351 * 4.5f), ((exp2(log2(max(_1351, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2913 = min((_1352 * 4.5f), ((exp2(log2(max(_1352, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2914 = min((_1353 * 4.5f), ((exp2(log2(max(_1353, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(OutputDevice == 3) || (bool)(OutputDevice == 5)) {
        _9[0] = ACESCoefsLow_0.x;
        _9[1] = ACESCoefsLow_0.y;
        _9[2] = ACESCoefsLow_0.z;
        _9[3] = ACESCoefsLow_0.w;
        _9[4] = ACESCoefsLow_4;
        _9[5] = ACESCoefsLow_4;
        _10[0] = ACESCoefsHigh_0.x;
        _10[1] = ACESCoefsHigh_0.y;
        _10[2] = ACESCoefsHigh_0.z;
        _10[3] = ACESCoefsHigh_0.w;
        _10[4] = ACESCoefsHigh_4;
        _10[5] = ACESCoefsHigh_4;
        float _1429 = ACESSceneColorMultiplier * _1228;
        float _1430 = ACESSceneColorMultiplier * _1229;
        float _1431 = ACESSceneColorMultiplier * _1230;
        float _1434 = mad((WorkingColorSpace_256[0].z), _1431, mad((WorkingColorSpace_256[0].y), _1430, ((WorkingColorSpace_256[0].x) * _1429)));
        float _1437 = mad((WorkingColorSpace_256[1].z), _1431, mad((WorkingColorSpace_256[1].y), _1430, ((WorkingColorSpace_256[1].x) * _1429)));
        float _1440 = mad((WorkingColorSpace_256[2].z), _1431, mad((WorkingColorSpace_256[2].y), _1430, ((WorkingColorSpace_256[2].x) * _1429)));
        float _1443 = mad(-0.21492856740951538f, _1440, mad(-0.2365107536315918f, _1437, (_1434 * 1.4514392614364624f)));
        float _1446 = mad(-0.09967592358589172f, _1440, mad(1.17622971534729f, _1437, (_1434 * -0.07655377686023712f)));
        float _1449 = mad(0.9977163076400757f, _1440, mad(-0.006032449658960104f, _1437, (_1434 * 0.008316148072481155f)));
        float _1451 = max(_1443, max(_1446, _1449));
        do {
          if (!(_1451 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1434 < 0.0f) || (bool)(_1437 < 0.0f))) || (bool)(_1440 < 0.0f))) {
              float _1461 = abs(_1451);
              float _1462 = (_1451 - _1443) / _1461;
              float _1464 = (_1451 - _1446) / _1461;
              float _1466 = (_1451 - _1449) / _1461;
              do {
                if (!(_1462 < 0.8149999976158142f)) {
                  float _1469 = _1462 + -0.8149999976158142f;
                  _1481 = ((_1469 / exp2(log2(exp2(log2(_1469 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1481 = _1462;
                }
                do {
                  if (!(_1464 < 0.8029999732971191f)) {
                    float _1484 = _1464 + -0.8029999732971191f;
                    _1496 = ((_1484 / exp2(log2(exp2(log2(_1484 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1496 = _1464;
                  }
                  do {
                    if (!(_1466 < 0.8799999952316284f)) {
                      float _1499 = _1466 + -0.8799999952316284f;
                      _1511 = ((_1499 / exp2(log2(exp2(log2(_1499 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1511 = _1466;
                    }
                    _1519 = (_1451 - (_1461 * _1481));
                    _1520 = (_1451 - (_1461 * _1496));
                    _1521 = (_1451 - (_1461 * _1511));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1519 = _1443;
              _1520 = _1446;
              _1521 = _1449;
            }
          } else {
            _1519 = _1443;
            _1520 = _1446;
            _1521 = _1449;
          }
          float _1537 = ((mad(0.16386906802654266f, _1521, mad(0.14067870378494263f, _1520, (_1519 * 0.6954522132873535f))) - _1434) * ACESGamutCompression) + _1434;
          float _1538 = ((mad(0.0955343171954155f, _1521, mad(0.8596711158752441f, _1520, (_1519 * 0.044794563204050064f))) - _1437) * ACESGamutCompression) + _1437;
          float _1539 = ((mad(1.0015007257461548f, _1521, mad(0.004025210160762072f, _1520, (_1519 * -0.005525882821530104f))) - _1440) * ACESGamutCompression) + _1440;
          float _1543 = max(max(_1537, _1538), _1539);
          float _1548 = (max(_1543, 1.000000013351432e-10f) - max(min(min(_1537, _1538), _1539), 1.000000013351432e-10f)) / max(_1543, 0.009999999776482582f);
          float _1561 = ((_1538 + _1537) + _1539) + (sqrt((((_1539 - _1538) * _1539) + ((_1538 - _1537) * _1538)) + ((_1537 - _1539) * _1537)) * 1.75f);
          float _1562 = _1561 * 0.3333333432674408f;
          float _1563 = _1548 + -0.4000000059604645f;
          float _1564 = _1563 * 5.0f;
          float _1568 = max((1.0f - abs(_1563 * 2.5f)), 0.0f);
          float _1579 = ((float((int)(((int)(uint)((bool)(_1564 > 0.0f))) - ((int)(uint)((bool)(_1564 < 0.0f))))) * (1.0f - (_1568 * _1568))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1562 <= 0.0533333346247673f)) {
              if (!(_1562 >= 0.1599999964237213f)) {
                _1588 = (((0.23999999463558197f / _1561) + -0.5f) * _1579);
              } else {
                _1588 = 0.0f;
              }
            } else {
              _1588 = _1579;
            }
            float _1589 = _1588 + 1.0f;
            float _1590 = _1589 * _1537;
            float _1591 = _1589 * _1538;
            float _1592 = _1589 * _1539;
            do {
              if (!((bool)(_1590 == _1591) && (bool)(_1591 == _1592))) {
                float _1599 = ((_1590 * 2.0f) - _1591) - _1592;
                float _1602 = ((_1538 - _1539) * 1.7320507764816284f) * _1589;
                float _1604 = atan(_1602 / _1599);
                bool _1607 = (_1599 < 0.0f);
                bool _1608 = (_1599 == 0.0f);
                bool _1609 = (_1602 >= 0.0f);
                bool _1610 = (_1602 < 0.0f);
                _1621 = select((_1609 && _1608), 90.0f, select((_1610 && _1608), -90.0f, (select((_1610 && _1607), (_1604 + -3.1415927410125732f), select((_1609 && _1607), (_1604 + 3.1415927410125732f), _1604)) * 57.2957763671875f)));
              } else {
                _1621 = 0.0f;
              }
              float _1626 = min(max(select((_1621 < 0.0f), (_1621 + 360.0f), _1621), 0.0f), 360.0f);
              do {
                if (_1626 < -180.0f) {
                  _1635 = (_1626 + 360.0f);
                } else {
                  if (_1626 > 180.0f) {
                    _1635 = (_1626 + -360.0f);
                  } else {
                    _1635 = _1626;
                  }
                }
                do {
                  if ((bool)(_1635 > -67.5f) && (bool)(_1635 < 67.5f)) {
                    float _1641 = (_1635 + 67.5f) * 0.029629629105329514f;
                    int _1642 = int(_1641);
                    float _1644 = _1641 - float((int)(_1642));
                    float _1645 = _1644 * _1644;
                    float _1646 = _1645 * _1644;
                    if (_1642 == 3) {
                      _1674 = (((0.1666666716337204f - (_1644 * 0.5f)) + (_1645 * 0.5f)) - (_1646 * 0.1666666716337204f));
                    } else {
                      if (_1642 == 2) {
                        _1674 = ((0.6666666865348816f - _1645) + (_1646 * 0.5f));
                      } else {
                        if (_1642 == 1) {
                          _1674 = (((_1646 * -0.5f) + 0.1666666716337204f) + ((_1645 + _1644) * 0.5f));
                        } else {
                          _1674 = select((_1642 == 0), (_1646 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1674 = 0.0f;
                  }
                  float _1683 = min(max(((((_1548 * 0.27000001072883606f) * (0.029999999329447746f - _1590)) * _1674) + _1590), 0.0f), 65535.0f);
                  float _1684 = min(max(_1591, 0.0f), 65535.0f);
                  float _1685 = min(max(_1592, 0.0f), 65535.0f);
                  float _1698 = min(max(mad(-0.21492856740951538f, _1685, mad(-0.2365107536315918f, _1684, (_1683 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1699 = min(max(mad(-0.09967592358589172f, _1685, mad(1.17622971534729f, _1684, (_1683 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1700 = min(max(mad(0.9977163076400757f, _1685, mad(-0.006032449658960104f, _1684, (_1683 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1701 = dot(float3(_1698, _1699, _1700), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _17[0] = ACESCoefsLow_0.x;
                  _17[1] = ACESCoefsLow_0.y;
                  _17[2] = ACESCoefsLow_0.z;
                  _17[3] = ACESCoefsLow_0.w;
                  _17[4] = ACESCoefsLow_4;
                  _17[5] = ACESCoefsLow_4;
                  _18[0] = ACESCoefsHigh_0.x;
                  _18[1] = ACESCoefsHigh_0.y;
                  _18[2] = ACESCoefsHigh_0.z;
                  _18[3] = ACESCoefsHigh_0.w;
                  _18[4] = ACESCoefsHigh_4;
                  _18[5] = ACESCoefsHigh_4;
                  float _1724 = log2(max((lerp(_1701, _1698, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1725 = _1724 * 0.3010300099849701f;
                  float _1726 = log2(ACESMinMaxData.x);
                  float _1727 = _1726 * 0.3010300099849701f;
                  do {
                    if (!(!(_1725 <= _1727))) {
                      _1796 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                    } else {
                      float _1734 = log2(ACESMidData.x);
                      float _1735 = _1734 * 0.3010300099849701f;
                      if ((bool)(_1725 > _1727) && (bool)(_1725 < _1735)) {
                        float _1743 = ((_1724 - _1726) * 0.9030900001525879f) / ((_1734 - _1726) * 0.3010300099849701f);
                        int _1744 = int(_1743);
                        float _1746 = _1743 - float((int)(_1744));
                        float _1748 = _17[_1744];
                        float _1751 = _17[(_1744 + 1)];
                        float _1756 = _1748 * 0.5f;
                        _1796 = dot(float3((_1746 * _1746), _1746, 1.0f), float3(mad((_17[(_1744 + 2)]), 0.5f, mad(_1751, -1.0f, _1756)), (_1751 - _1748), mad(_1751, 0.5f, _1756)));
                      } else {
                        do {
                          if (!(!(_1725 >= _1735))) {
                            float _1765 = log2(ACESMinMaxData.z);
                            if (_1725 < (_1765 * 0.3010300099849701f)) {
                              float _1773 = ((_1724 - _1734) * 0.9030900001525879f) / ((_1765 - _1734) * 0.3010300099849701f);
                              int _1774 = int(_1773);
                              float _1776 = _1773 - float((int)(_1774));
                              float _1778 = _18[_1774];
                              float _1781 = _18[(_1774 + 1)];
                              float _1786 = _1778 * 0.5f;
                              _1796 = dot(float3((_1776 * _1776), _1776, 1.0f), float3(mad((_18[(_1774 + 2)]), 0.5f, mad(_1781, -1.0f, _1786)), (_1781 - _1778), mad(_1781, 0.5f, _1786)));
                              break;
                            }
                          }
                          _1796 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _19[0] = ACESCoefsLow_0.x;
                    _19[1] = ACESCoefsLow_0.y;
                    _19[2] = ACESCoefsLow_0.z;
                    _19[3] = ACESCoefsLow_0.w;
                    _19[4] = ACESCoefsLow_4;
                    _19[5] = ACESCoefsLow_4;
                    _20[0] = ACESCoefsHigh_0.x;
                    _20[1] = ACESCoefsHigh_0.y;
                    _20[2] = ACESCoefsHigh_0.z;
                    _20[3] = ACESCoefsHigh_0.w;
                    _20[4] = ACESCoefsHigh_4;
                    _20[5] = ACESCoefsHigh_4;
                    float _1812 = log2(max((lerp(_1701, _1699, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1813 = _1812 * 0.3010300099849701f;
                    do {
                      if (!(!(_1813 <= _1727))) {
                        _1882 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _1820 = log2(ACESMidData.x);
                        float _1821 = _1820 * 0.3010300099849701f;
                        if ((bool)(_1813 > _1727) && (bool)(_1813 < _1821)) {
                          float _1829 = ((_1812 - _1726) * 0.9030900001525879f) / ((_1820 - _1726) * 0.3010300099849701f);
                          int _1830 = int(_1829);
                          float _1832 = _1829 - float((int)(_1830));
                          float _1834 = _19[_1830];
                          float _1837 = _19[(_1830 + 1)];
                          float _1842 = _1834 * 0.5f;
                          _1882 = dot(float3((_1832 * _1832), _1832, 1.0f), float3(mad((_19[(_1830 + 2)]), 0.5f, mad(_1837, -1.0f, _1842)), (_1837 - _1834), mad(_1837, 0.5f, _1842)));
                        } else {
                          do {
                            if (!(!(_1813 >= _1821))) {
                              float _1851 = log2(ACESMinMaxData.z);
                              if (_1813 < (_1851 * 0.3010300099849701f)) {
                                float _1859 = ((_1812 - _1820) * 0.9030900001525879f) / ((_1851 - _1820) * 0.3010300099849701f);
                                int _1860 = int(_1859);
                                float _1862 = _1859 - float((int)(_1860));
                                float _1864 = _20[_1860];
                                float _1867 = _20[(_1860 + 1)];
                                float _1872 = _1864 * 0.5f;
                                _1882 = dot(float3((_1862 * _1862), _1862, 1.0f), float3(mad((_20[(_1860 + 2)]), 0.5f, mad(_1867, -1.0f, _1872)), (_1867 - _1864), mad(_1867, 0.5f, _1872)));
                                break;
                              }
                            }
                            _1882 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1886 = log2(max((lerp(_1701, _1700, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1887 = _1886 * 0.3010300099849701f;
                      do {
                        if (!(!(_1887 <= _1727))) {
                          _1956 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _1894 = log2(ACESMidData.x);
                          float _1895 = _1894 * 0.3010300099849701f;
                          if ((bool)(_1887 > _1727) && (bool)(_1887 < _1895)) {
                            float _1903 = ((_1886 - _1726) * 0.9030900001525879f) / ((_1894 - _1726) * 0.3010300099849701f);
                            int _1904 = int(_1903);
                            float _1906 = _1903 - float((int)(_1904));
                            float _1908 = _9[_1904];
                            float _1911 = _9[(_1904 + 1)];
                            float _1916 = _1908 * 0.5f;
                            _1956 = dot(float3((_1906 * _1906), _1906, 1.0f), float3(mad((_9[(_1904 + 2)]), 0.5f, mad(_1911, -1.0f, _1916)), (_1911 - _1908), mad(_1911, 0.5f, _1916)));
                          } else {
                            do {
                              if (!(!(_1887 >= _1895))) {
                                float _1925 = log2(ACESMinMaxData.z);
                                if (_1887 < (_1925 * 0.3010300099849701f)) {
                                  float _1933 = ((_1886 - _1894) * 0.9030900001525879f) / ((_1925 - _1894) * 0.3010300099849701f);
                                  int _1934 = int(_1933);
                                  float _1936 = _1933 - float((int)(_1934));
                                  float _1938 = _10[_1934];
                                  float _1941 = _10[(_1934 + 1)];
                                  float _1946 = _1938 * 0.5f;
                                  _1956 = dot(float3((_1936 * _1936), _1936, 1.0f), float3(mad((_10[(_1934 + 2)]), 0.5f, mad(_1941, -1.0f, _1946)), (_1941 - _1938), mad(_1941, 0.5f, _1946)));
                                  break;
                                }
                              }
                              _1956 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1960 = ACESMinMaxData.w - ACESMinMaxData.y;
                        float _1961 = (exp2(_1796 * 3.321928024291992f) - ACESMinMaxData.y) / _1960;
                        float _1963 = (exp2(_1882 * 3.321928024291992f) - ACESMinMaxData.y) / _1960;
                        float _1965 = (exp2(_1956 * 3.321928024291992f) - ACESMinMaxData.y) / _1960;
                        float _1968 = mad(0.15618768334388733f, _1965, mad(0.13400420546531677f, _1963, (_1961 * 0.6624541878700256f)));
                        float _1971 = mad(0.053689517080783844f, _1965, mad(0.6740817427635193f, _1963, (_1961 * 0.2722287178039551f)));
                        float _1974 = mad(1.0103391408920288f, _1965, mad(0.00406073359772563f, _1963, (_1961 * -0.005574649665504694f)));
                        float _1987 = min(max(mad(-0.23642469942569733f, _1974, mad(-0.32480329275131226f, _1971, (_1968 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1988 = min(max(mad(0.016756348311901093f, _1974, mad(1.6153316497802734f, _1971, (_1968 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1989 = min(max(mad(0.9883948564529419f, _1974, mad(-0.008284442126750946f, _1971, (_1968 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1992 = mad(0.15618768334388733f, _1989, mad(0.13400420546531677f, _1988, (_1987 * 0.6624541878700256f)));
                        float _1995 = mad(0.053689517080783844f, _1989, mad(0.6740817427635193f, _1988, (_1987 * 0.2722287178039551f)));
                        float _1998 = mad(1.0103391408920288f, _1989, mad(0.00406073359772563f, _1988, (_1987 * -0.005574649665504694f)));
                        float _2020 = min(max((min(max(mad(-0.23642469942569733f, _1998, mad(-0.32480329275131226f, _1995, (_1992 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2021 = min(max((min(max(mad(0.016756348311901093f, _1998, mad(1.6153316497802734f, _1995, (_1992 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        float _2022 = min(max((min(max(mad(0.9883948564529419f, _1998, mad(-0.008284442126750946f, _1995, (_1992 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                        do {
                          if (!(OutputDevice == 5)) {
                            _2035 = mad(_63, _2022, mad(_62, _2021, (_2020 * _61)));
                            _2036 = mad(_66, _2022, mad(_65, _2021, (_2020 * _64)));
                            _2037 = mad(_69, _2022, mad(_68, _2021, (_2020 * _67)));
                          } else {
                            _2035 = _2020;
                            _2036 = _2021;
                            _2037 = _2022;
                          }
                          float _2047 = exp2(log2(_2035 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2048 = exp2(log2(_2036 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2049 = exp2(log2(_2037 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2912 = exp2(log2((1.0f / ((_2047 * 18.6875f) + 1.0f)) * ((_2047 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2913 = exp2(log2((1.0f / ((_2048 * 18.6875f) + 1.0f)) * ((_2048 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2914 = exp2(log2((1.0f / ((_2049 * 18.6875f) + 1.0f)) * ((_2049 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((OutputDevice & -3) == 4) {
          float _2115 = ACESSceneColorMultiplier * _1228;
          float _2116 = ACESSceneColorMultiplier * _1229;
          float _2117 = ACESSceneColorMultiplier * _1230;
          float _2120 = mad((WorkingColorSpace_256[0].z), _2117, mad((WorkingColorSpace_256[0].y), _2116, ((WorkingColorSpace_256[0].x) * _2115)));
          float _2123 = mad((WorkingColorSpace_256[1].z), _2117, mad((WorkingColorSpace_256[1].y), _2116, ((WorkingColorSpace_256[1].x) * _2115)));
          float _2126 = mad((WorkingColorSpace_256[2].z), _2117, mad((WorkingColorSpace_256[2].y), _2116, ((WorkingColorSpace_256[2].x) * _2115)));
          float _2129 = mad(-0.21492856740951538f, _2126, mad(-0.2365107536315918f, _2123, (_2120 * 1.4514392614364624f)));
          float _2132 = mad(-0.09967592358589172f, _2126, mad(1.17622971534729f, _2123, (_2120 * -0.07655377686023712f)));
          float _2135 = mad(0.9977163076400757f, _2126, mad(-0.006032449658960104f, _2123, (_2120 * 0.008316148072481155f)));
          float _2137 = max(_2129, max(_2132, _2135));
          do {
            if (!(_2137 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2120 < 0.0f) || (bool)(_2123 < 0.0f))) || (bool)(_2126 < 0.0f))) {
                float _2147 = abs(_2137);
                float _2148 = (_2137 - _2129) / _2147;
                float _2150 = (_2137 - _2132) / _2147;
                float _2152 = (_2137 - _2135) / _2147;
                do {
                  if (!(_2148 < 0.8149999976158142f)) {
                    float _2155 = _2148 + -0.8149999976158142f;
                    _2167 = ((_2155 / exp2(log2(exp2(log2(_2155 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2167 = _2148;
                  }
                  do {
                    if (!(_2150 < 0.8029999732971191f)) {
                      float _2170 = _2150 + -0.8029999732971191f;
                      _2182 = ((_2170 / exp2(log2(exp2(log2(_2170 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2182 = _2150;
                    }
                    do {
                      if (!(_2152 < 0.8799999952316284f)) {
                        float _2185 = _2152 + -0.8799999952316284f;
                        _2197 = ((_2185 / exp2(log2(exp2(log2(_2185 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2197 = _2152;
                      }
                      _2205 = (_2137 - (_2147 * _2167));
                      _2206 = (_2137 - (_2147 * _2182));
                      _2207 = (_2137 - (_2147 * _2197));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2205 = _2129;
                _2206 = _2132;
                _2207 = _2135;
              }
            } else {
              _2205 = _2129;
              _2206 = _2132;
              _2207 = _2135;
            }
            float _2223 = ((mad(0.16386906802654266f, _2207, mad(0.14067870378494263f, _2206, (_2205 * 0.6954522132873535f))) - _2120) * ACESGamutCompression) + _2120;
            float _2224 = ((mad(0.0955343171954155f, _2207, mad(0.8596711158752441f, _2206, (_2205 * 0.044794563204050064f))) - _2123) * ACESGamutCompression) + _2123;
            float _2225 = ((mad(1.0015007257461548f, _2207, mad(0.004025210160762072f, _2206, (_2205 * -0.005525882821530104f))) - _2126) * ACESGamutCompression) + _2126;
            float _2229 = max(max(_2223, _2224), _2225);
            float _2234 = (max(_2229, 1.000000013351432e-10f) - max(min(min(_2223, _2224), _2225), 1.000000013351432e-10f)) / max(_2229, 0.009999999776482582f);
            float _2247 = ((_2224 + _2223) + _2225) + (sqrt((((_2225 - _2224) * _2225) + ((_2224 - _2223) * _2224)) + ((_2223 - _2225) * _2223)) * 1.75f);
            float _2248 = _2247 * 0.3333333432674408f;
            float _2249 = _2234 + -0.4000000059604645f;
            float _2250 = _2249 * 5.0f;
            float _2254 = max((1.0f - abs(_2249 * 2.5f)), 0.0f);
            float _2265 = ((float((int)(((int)(uint)((bool)(_2250 > 0.0f))) - ((int)(uint)((bool)(_2250 < 0.0f))))) * (1.0f - (_2254 * _2254))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2248 <= 0.0533333346247673f)) {
                if (!(_2248 >= 0.1599999964237213f)) {
                  _2274 = (((0.23999999463558197f / _2247) + -0.5f) * _2265);
                } else {
                  _2274 = 0.0f;
                }
              } else {
                _2274 = _2265;
              }
              float _2275 = _2274 + 1.0f;
              float _2276 = _2275 * _2223;
              float _2277 = _2275 * _2224;
              float _2278 = _2275 * _2225;
              do {
                if (!((bool)(_2276 == _2277) && (bool)(_2277 == _2278))) {
                  float _2285 = ((_2276 * 2.0f) - _2277) - _2278;
                  float _2288 = ((_2224 - _2225) * 1.7320507764816284f) * _2275;
                  float _2290 = atan(_2288 / _2285);
                  bool _2293 = (_2285 < 0.0f);
                  bool _2294 = (_2285 == 0.0f);
                  bool _2295 = (_2288 >= 0.0f);
                  bool _2296 = (_2288 < 0.0f);
                  _2307 = select((_2295 && _2294), 90.0f, select((_2296 && _2294), -90.0f, (select((_2296 && _2293), (_2290 + -3.1415927410125732f), select((_2295 && _2293), (_2290 + 3.1415927410125732f), _2290)) * 57.2957763671875f)));
                } else {
                  _2307 = 0.0f;
                }
                float _2312 = min(max(select((_2307 < 0.0f), (_2307 + 360.0f), _2307), 0.0f), 360.0f);
                do {
                  if (_2312 < -180.0f) {
                    _2321 = (_2312 + 360.0f);
                  } else {
                    if (_2312 > 180.0f) {
                      _2321 = (_2312 + -360.0f);
                    } else {
                      _2321 = _2312;
                    }
                  }
                  do {
                    if ((bool)(_2321 > -67.5f) && (bool)(_2321 < 67.5f)) {
                      float _2327 = (_2321 + 67.5f) * 0.029629629105329514f;
                      int _2328 = int(_2327);
                      float _2330 = _2327 - float((int)(_2328));
                      float _2331 = _2330 * _2330;
                      float _2332 = _2331 * _2330;
                      if (_2328 == 3) {
                        _2360 = (((0.1666666716337204f - (_2330 * 0.5f)) + (_2331 * 0.5f)) - (_2332 * 0.1666666716337204f));
                      } else {
                        if (_2328 == 2) {
                          _2360 = ((0.6666666865348816f - _2331) + (_2332 * 0.5f));
                        } else {
                          if (_2328 == 1) {
                            _2360 = (((_2332 * -0.5f) + 0.1666666716337204f) + ((_2331 + _2330) * 0.5f));
                          } else {
                            _2360 = select((_2328 == 0), (_2332 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2360 = 0.0f;
                    }
                    float _2369 = min(max(((((_2234 * 0.27000001072883606f) * (0.029999999329447746f - _2276)) * _2360) + _2276), 0.0f), 65535.0f);
                    float _2370 = min(max(_2277, 0.0f), 65535.0f);
                    float _2371 = min(max(_2278, 0.0f), 65535.0f);
                    float _2384 = min(max(mad(-0.21492856740951538f, _2371, mad(-0.2365107536315918f, _2370, (_2369 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2385 = min(max(mad(-0.09967592358589172f, _2371, mad(1.17622971534729f, _2370, (_2369 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2386 = min(max(mad(0.9977163076400757f, _2371, mad(-0.006032449658960104f, _2370, (_2369 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2387 = dot(float3(_2384, _2385, _2386), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    _15[0] = ACESCoefsLow_0.x;
                    _15[1] = ACESCoefsLow_0.y;
                    _15[2] = ACESCoefsLow_0.z;
                    _15[3] = ACESCoefsLow_0.w;
                    _15[4] = ACESCoefsLow_4;
                    _15[5] = ACESCoefsLow_4;
                    _16[0] = ACESCoefsHigh_0.x;
                    _16[1] = ACESCoefsHigh_0.y;
                    _16[2] = ACESCoefsHigh_0.z;
                    _16[3] = ACESCoefsHigh_0.w;
                    _16[4] = ACESCoefsHigh_4;
                    _16[5] = ACESCoefsHigh_4;
                    float _2410 = log2(max((lerp(_2387, _2384, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2411 = _2410 * 0.3010300099849701f;
                    float _2412 = log2(ACESMinMaxData.x);
                    float _2413 = _2412 * 0.3010300099849701f;
                    do {
                      if (!(!(_2411 <= _2413))) {
                        _2482 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                      } else {
                        float _2420 = log2(ACESMidData.x);
                        float _2421 = _2420 * 0.3010300099849701f;
                        if ((bool)(_2411 > _2413) && (bool)(_2411 < _2421)) {
                          float _2429 = ((_2410 - _2412) * 0.9030900001525879f) / ((_2420 - _2412) * 0.3010300099849701f);
                          int _2430 = int(_2429);
                          float _2432 = _2429 - float((int)(_2430));
                          float _2434 = _15[_2430];
                          float _2437 = _15[(_2430 + 1)];
                          float _2442 = _2434 * 0.5f;
                          _2482 = dot(float3((_2432 * _2432), _2432, 1.0f), float3(mad((_15[(_2430 + 2)]), 0.5f, mad(_2437, -1.0f, _2442)), (_2437 - _2434), mad(_2437, 0.5f, _2442)));
                        } else {
                          do {
                            if (!(!(_2411 >= _2421))) {
                              float _2451 = log2(ACESMinMaxData.z);
                              if (_2411 < (_2451 * 0.3010300099849701f)) {
                                float _2459 = ((_2410 - _2420) * 0.9030900001525879f) / ((_2451 - _2420) * 0.3010300099849701f);
                                int _2460 = int(_2459);
                                float _2462 = _2459 - float((int)(_2460));
                                float _2464 = _16[_2460];
                                float _2467 = _16[(_2460 + 1)];
                                float _2472 = _2464 * 0.5f;
                                _2482 = dot(float3((_2462 * _2462), _2462, 1.0f), float3(mad((_16[(_2460 + 2)]), 0.5f, mad(_2467, -1.0f, _2472)), (_2467 - _2464), mad(_2467, 0.5f, _2472)));
                                break;
                              }
                            }
                            _2482 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      _11[0] = ACESCoefsLow_0.x;
                      _11[1] = ACESCoefsLow_0.y;
                      _11[2] = ACESCoefsLow_0.z;
                      _11[3] = ACESCoefsLow_0.w;
                      _11[4] = ACESCoefsLow_4;
                      _11[5] = ACESCoefsLow_4;
                      _12[0] = ACESCoefsHigh_0.x;
                      _12[1] = ACESCoefsHigh_0.y;
                      _12[2] = ACESCoefsHigh_0.z;
                      _12[3] = ACESCoefsHigh_0.w;
                      _12[4] = ACESCoefsHigh_4;
                      _12[5] = ACESCoefsHigh_4;
                      float _2498 = log2(max((lerp(_2387, _2385, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2499 = _2498 * 0.3010300099849701f;
                      do {
                        if (!(!(_2499 <= _2413))) {
                          _2568 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                        } else {
                          float _2506 = log2(ACESMidData.x);
                          float _2507 = _2506 * 0.3010300099849701f;
                          if ((bool)(_2499 > _2413) && (bool)(_2499 < _2507)) {
                            float _2515 = ((_2498 - _2412) * 0.9030900001525879f) / ((_2506 - _2412) * 0.3010300099849701f);
                            int _2516 = int(_2515);
                            float _2518 = _2515 - float((int)(_2516));
                            float _2520 = _11[_2516];
                            float _2523 = _11[(_2516 + 1)];
                            float _2528 = _2520 * 0.5f;
                            _2568 = dot(float3((_2518 * _2518), _2518, 1.0f), float3(mad((_11[(_2516 + 2)]), 0.5f, mad(_2523, -1.0f, _2528)), (_2523 - _2520), mad(_2523, 0.5f, _2528)));
                          } else {
                            do {
                              if (!(!(_2499 >= _2507))) {
                                float _2537 = log2(ACESMinMaxData.z);
                                if (_2499 < (_2537 * 0.3010300099849701f)) {
                                  float _2545 = ((_2498 - _2506) * 0.9030900001525879f) / ((_2537 - _2506) * 0.3010300099849701f);
                                  int _2546 = int(_2545);
                                  float _2548 = _2545 - float((int)(_2546));
                                  float _2550 = _12[_2546];
                                  float _2553 = _12[(_2546 + 1)];
                                  float _2558 = _2550 * 0.5f;
                                  _2568 = dot(float3((_2548 * _2548), _2548, 1.0f), float3(mad((_12[(_2546 + 2)]), 0.5f, mad(_2553, -1.0f, _2558)), (_2553 - _2550), mad(_2553, 0.5f, _2558)));
                                  break;
                                }
                              }
                              _2568 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        _13[0] = ACESCoefsLow_0.x;
                        _13[1] = ACESCoefsLow_0.y;
                        _13[2] = ACESCoefsLow_0.z;
                        _13[3] = ACESCoefsLow_0.w;
                        _13[4] = ACESCoefsLow_4;
                        _13[5] = ACESCoefsLow_4;
                        _14[0] = ACESCoefsHigh_0.x;
                        _14[1] = ACESCoefsHigh_0.y;
                        _14[2] = ACESCoefsHigh_0.z;
                        _14[3] = ACESCoefsHigh_0.w;
                        _14[4] = ACESCoefsHigh_4;
                        _14[5] = ACESCoefsHigh_4;
                        float _2584 = log2(max((lerp(_2387, _2386, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2585 = _2584 * 0.3010300099849701f;
                        do {
                          if (!(!(_2585 <= _2413))) {
                            _2654 = (log2(ACESMinMaxData.y) * 0.3010300099849701f);
                          } else {
                            float _2592 = log2(ACESMidData.x);
                            float _2593 = _2592 * 0.3010300099849701f;
                            if ((bool)(_2585 > _2413) && (bool)(_2585 < _2593)) {
                              float _2601 = ((_2584 - _2412) * 0.9030900001525879f) / ((_2592 - _2412) * 0.3010300099849701f);
                              int _2602 = int(_2601);
                              float _2604 = _2601 - float((int)(_2602));
                              float _2606 = _13[_2602];
                              float _2609 = _13[(_2602 + 1)];
                              float _2614 = _2606 * 0.5f;
                              _2654 = dot(float3((_2604 * _2604), _2604, 1.0f), float3(mad((_13[(_2602 + 2)]), 0.5f, mad(_2609, -1.0f, _2614)), (_2609 - _2606), mad(_2609, 0.5f, _2614)));
                            } else {
                              do {
                                if (!(!(_2585 >= _2593))) {
                                  float _2623 = log2(ACESMinMaxData.z);
                                  if (_2585 < (_2623 * 0.3010300099849701f)) {
                                    float _2631 = ((_2584 - _2592) * 0.9030900001525879f) / ((_2623 - _2592) * 0.3010300099849701f);
                                    int _2632 = int(_2631);
                                    float _2634 = _2631 - float((int)(_2632));
                                    float _2636 = _14[_2632];
                                    float _2639 = _14[(_2632 + 1)];
                                    float _2644 = _2636 * 0.5f;
                                    _2654 = dot(float3((_2634 * _2634), _2634, 1.0f), float3(mad((_14[(_2632 + 2)]), 0.5f, mad(_2639, -1.0f, _2644)), (_2639 - _2636), mad(_2639, 0.5f, _2644)));
                                    break;
                                  }
                                }
                                _2654 = (log2(ACESMinMaxData.w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2658 = ACESMinMaxData.w - ACESMinMaxData.y;
                          float _2659 = (exp2(_2482 * 3.321928024291992f) - ACESMinMaxData.y) / _2658;
                          float _2661 = (exp2(_2568 * 3.321928024291992f) - ACESMinMaxData.y) / _2658;
                          float _2663 = (exp2(_2654 * 3.321928024291992f) - ACESMinMaxData.y) / _2658;
                          float _2666 = mad(0.15618768334388733f, _2663, mad(0.13400420546531677f, _2661, (_2659 * 0.6624541878700256f)));
                          float _2669 = mad(0.053689517080783844f, _2663, mad(0.6740817427635193f, _2661, (_2659 * 0.2722287178039551f)));
                          float _2672 = mad(1.0103391408920288f, _2663, mad(0.00406073359772563f, _2661, (_2659 * -0.005574649665504694f)));
                          float _2685 = min(max(mad(-0.23642469942569733f, _2672, mad(-0.32480329275131226f, _2669, (_2666 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2686 = min(max(mad(0.016756348311901093f, _2672, mad(1.6153316497802734f, _2669, (_2666 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2687 = min(max(mad(0.9883948564529419f, _2672, mad(-0.008284442126750946f, _2669, (_2666 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2690 = mad(0.15618768334388733f, _2687, mad(0.13400420546531677f, _2686, (_2685 * 0.6624541878700256f)));
                          float _2693 = mad(0.053689517080783844f, _2687, mad(0.6740817427635193f, _2686, (_2685 * 0.2722287178039551f)));
                          float _2696 = mad(1.0103391408920288f, _2687, mad(0.00406073359772563f, _2686, (_2685 * -0.005574649665504694f)));
                          float _2718 = min(max((min(max(mad(-0.23642469942569733f, _2696, mad(-0.32480329275131226f, _2693, (_2690 * 1.6410233974456787f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2719 = min(max((min(max(mad(0.016756348311901093f, _2696, mad(1.6153316497802734f, _2693, (_2690 * -0.663662850856781f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          float _2720 = min(max((min(max(mad(0.9883948564529419f, _2696, mad(-0.008284442126750946f, _2693, (_2690 * 0.011721894145011902f))), 0.0f), 65535.0f) * ACESMinMaxData.w), 0.0f), 65535.0f);
                          do {
                            if (!(OutputDevice == 6)) {
                              _2733 = mad(_63, _2720, mad(_62, _2719, (_2718 * _61)));
                              _2734 = mad(_66, _2720, mad(_65, _2719, (_2718 * _64)));
                              _2735 = mad(_69, _2720, mad(_68, _2719, (_2718 * _67)));
                            } else {
                              _2733 = _2718;
                              _2734 = _2719;
                              _2735 = _2720;
                            }
                            float _2745 = exp2(log2(_2733 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2746 = exp2(log2(_2734 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2747 = exp2(log2(_2735 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2912 = exp2(log2((1.0f / ((_2745 * 18.6875f) + 1.0f)) * ((_2745 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2913 = exp2(log2((1.0f / ((_2746 * 18.6875f) + 1.0f)) * ((_2746 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2914 = exp2(log2((1.0f / ((_2747 * 18.6875f) + 1.0f)) * ((_2747 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (OutputDevice == 7) {
            float _2792 = mad((WorkingColorSpace_128[0].z), _1230, mad((WorkingColorSpace_128[0].y), _1229, ((WorkingColorSpace_128[0].x) * _1228)));
            float _2795 = mad((WorkingColorSpace_128[1].z), _1230, mad((WorkingColorSpace_128[1].y), _1229, ((WorkingColorSpace_128[1].x) * _1228)));
            float _2798 = mad((WorkingColorSpace_128[2].z), _1230, mad((WorkingColorSpace_128[2].y), _1229, ((WorkingColorSpace_128[2].x) * _1228)));
            float _2817 = exp2(log2(mad(_63, _2798, mad(_62, _2795, (_2792 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2818 = exp2(log2(mad(_66, _2798, mad(_65, _2795, (_2792 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2819 = exp2(log2(mad(_69, _2798, mad(_68, _2795, (_2792 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2912 = exp2(log2((1.0f / ((_2817 * 18.6875f) + 1.0f)) * ((_2817 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2913 = exp2(log2((1.0f / ((_2818 * 18.6875f) + 1.0f)) * ((_2818 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2914 = exp2(log2((1.0f / ((_2819 * 18.6875f) + 1.0f)) * ((_2819 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(OutputDevice == 8)) {
              if (OutputDevice == 9) {
                float _2866 = mad((WorkingColorSpace_128[0].z), _1218, mad((WorkingColorSpace_128[0].y), _1217, ((WorkingColorSpace_128[0].x) * _1216)));
                float _2869 = mad((WorkingColorSpace_128[1].z), _1218, mad((WorkingColorSpace_128[1].y), _1217, ((WorkingColorSpace_128[1].x) * _1216)));
                float _2872 = mad((WorkingColorSpace_128[2].z), _1218, mad((WorkingColorSpace_128[2].y), _1217, ((WorkingColorSpace_128[2].x) * _1216)));
                _2912 = mad(_63, _2872, mad(_62, _2869, (_2866 * _61)));
                _2913 = mad(_66, _2872, mad(_65, _2869, (_2866 * _64)));
                _2914 = mad(_69, _2872, mad(_68, _2869, (_2866 * _67)));
              } else {
                float _2885 = mad((WorkingColorSpace_128[0].z), _1244, mad((WorkingColorSpace_128[0].y), _1243, ((WorkingColorSpace_128[0].x) * _1242)));
                float _2888 = mad((WorkingColorSpace_128[1].z), _1244, mad((WorkingColorSpace_128[1].y), _1243, ((WorkingColorSpace_128[1].x) * _1242)));
                float _2891 = mad((WorkingColorSpace_128[2].z), _1244, mad((WorkingColorSpace_128[2].y), _1243, ((WorkingColorSpace_128[2].x) * _1242)));
                _2912 = exp2(log2(mad(_63, _2891, mad(_62, _2888, (_2885 * _61)))) * InverseGamma.z);
                _2913 = exp2(log2(mad(_66, _2891, mad(_65, _2888, (_2885 * _64)))) * InverseGamma.z);
                _2914 = exp2(log2(mad(_69, _2891, mad(_68, _2888, (_2885 * _67)))) * InverseGamma.z);
              }
            } else {
              _2912 = _1228;
              _2913 = _1229;
              _2914 = _1230;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2912 * 0.9523810148239136f), (_2913 * 0.9523810148239136f), (_2914 * 0.9523810148239136f), 0.0f);
}
