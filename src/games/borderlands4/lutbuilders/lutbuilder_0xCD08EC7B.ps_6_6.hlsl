//Found in Borderlands 4

#include "./filmiclutbuilder.hlsli"

// cbuffer cb0 : register(b0) {
//   float cb0_008x : packoffset(c008.x);
//   float cb0_008y : packoffset(c008.y);
//   float cb0_008z : packoffset(c008.z);
//   float cb0_008w : packoffset(c008.w);
//   float cb0_009x : packoffset(c009.x);
//   float cb0_010x : packoffset(c010.x);
//   float cb0_010y : packoffset(c010.y);
//   float cb0_010z : packoffset(c010.z);
//   float cb0_010w : packoffset(c010.w);
//   float cb0_011x : packoffset(c011.x);
//   float cb0_011y : packoffset(c011.y);
//   float cb0_011z : packoffset(c011.z);
//   float cb0_011w : packoffset(c011.w);
//   float cb0_012x : packoffset(c012.x);
//   float cb0_012y : packoffset(c012.y);
//   float cb0_012z : packoffset(c012.z);
//   float cb0_012w : packoffset(c012.w);
//   float cb0_013x : packoffset(c013.x);
//   float cb0_013y : packoffset(c013.y);
//   float cb0_013z : packoffset(c013.z);
//   float cb0_013w : packoffset(c013.w);
//   float cb0_014x : packoffset(c014.x);
//   float cb0_014y : packoffset(c014.y);
//   float cb0_014z : packoffset(c014.z);
//   float cb0_015x : packoffset(c015.x);
//   float cb0_015y : packoffset(c015.y);
//   float cb0_015z : packoffset(c015.z);
//   float cb0_015w : packoffset(c015.w);
//   float cb0_016x : packoffset(c016.x);
//   float cb0_016y : packoffset(c016.y);
//   float cb0_016z : packoffset(c016.z);
//   float cb0_016w : packoffset(c016.w);
//   float cb0_017x : packoffset(c017.x);
//   float cb0_017y : packoffset(c017.y);
//   float cb0_017z : packoffset(c017.z);
//   float cb0_017w : packoffset(c017.w);
//   float cb0_018x : packoffset(c018.x);
//   float cb0_018y : packoffset(c018.y);
//   float cb0_018z : packoffset(c018.z);
//   float cb0_018w : packoffset(c018.w);
//   float cb0_019x : packoffset(c019.x);
//   float cb0_019y : packoffset(c019.y);
//   float cb0_019z : packoffset(c019.z);
//   float cb0_019w : packoffset(c019.w);
//   float cb0_020x : packoffset(c020.x);
//   float cb0_020y : packoffset(c020.y);
//   float cb0_020z : packoffset(c020.z);
//   float cb0_020w : packoffset(c020.w);
//   float cb0_021x : packoffset(c021.x);
//   float cb0_021y : packoffset(c021.y);
//   float cb0_021z : packoffset(c021.z);
//   float cb0_021w : packoffset(c021.w);
//   float cb0_022x : packoffset(c022.x);
//   float cb0_022y : packoffset(c022.y);
//   float cb0_022z : packoffset(c022.z);
//   float cb0_022w : packoffset(c022.w);
//   float cb0_023x : packoffset(c023.x);
//   float cb0_023y : packoffset(c023.y);
//   float cb0_023z : packoffset(c023.z);
//   float cb0_023w : packoffset(c023.w);
//   float cb0_024x : packoffset(c024.x);
//   float cb0_024y : packoffset(c024.y);
//   float cb0_024z : packoffset(c024.z);
//   float cb0_024w : packoffset(c024.w);
//   float cb0_025x : packoffset(c025.x);
//   float cb0_025y : packoffset(c025.y);
//   float cb0_025z : packoffset(c025.z);
//   float cb0_025w : packoffset(c025.w);
//   float cb0_026x : packoffset(c026.x);
//   float cb0_026y : packoffset(c026.y);
//   float cb0_026z : packoffset(c026.z);
//   float cb0_026w : packoffset(c026.w);
//   float cb0_027x : packoffset(c027.x);
//   float cb0_027y : packoffset(c027.y);
//   float cb0_027z : packoffset(c027.z);
//   float cb0_027w : packoffset(c027.w);
//   float cb0_028x : packoffset(c028.x);
//   float cb0_028y : packoffset(c028.y);
//   float cb0_028z : packoffset(c028.z);
//   float cb0_028w : packoffset(c028.w);
//   float cb0_029x : packoffset(c029.x);
//   float cb0_029y : packoffset(c029.y);
//   float cb0_029z : packoffset(c029.z);
//   float cb0_029w : packoffset(c029.w);
//   float cb0_030x : packoffset(c030.x);
//   float cb0_030y : packoffset(c030.y);
//   float cb0_030z : packoffset(c030.z);
//   float cb0_030w : packoffset(c030.w);
//   float cb0_031x : packoffset(c031.x);
//   float cb0_031y : packoffset(c031.y);
//   float cb0_031z : packoffset(c031.z);
//   float cb0_031w : packoffset(c031.w);
//   float cb0_032x : packoffset(c032.x);
//   float cb0_032y : packoffset(c032.y);
//   float cb0_032z : packoffset(c032.z);
//   float cb0_032w : packoffset(c032.w);
//   float cb0_033x : packoffset(c033.x);
//   float cb0_033y : packoffset(c033.y);
//   float cb0_033z : packoffset(c033.z);
//   float cb0_033w : packoffset(c033.w);
//   float cb0_034x : packoffset(c034.x);
//   float cb0_034y : packoffset(c034.y);
//   float cb0_034z : packoffset(c034.z);
//   float cb0_034w : packoffset(c034.w);
//   float cb0_035x : packoffset(c035.x);
//   float cb0_035w : packoffset(c035.w);
//   float cb0_036x : packoffset(c036.x);
//   float cb0_036y : packoffset(c036.y);
//   float cb0_036z : packoffset(c036.z);
//   float cb0_036w : packoffset(c036.w);
//   float cb0_037x : packoffset(c037.x);
//   float cb0_037y : packoffset(c037.y);
//   float cb0_037z : packoffset(c037.z);
//   float cb0_037w : packoffset(c037.w);
//   float cb0_038x : packoffset(c038.x);
//   float cb0_038y : packoffset(c038.y);
//   float cb0_039x : packoffset(c039.x);
//   float cb0_039y : packoffset(c039.y);
//   float cb0_040x : packoffset(c040.x);
//   float cb0_040y : packoffset(c040.y);
//   float cb0_040z : packoffset(c040.z);
//   float cb0_041y : packoffset(c041.y);
//   float cb0_041z : packoffset(c041.z);
//   int cb0_041w : packoffset(c041.w);
//   int cb0_042x : packoffset(c042.x);
// };

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  uint output_gamut = cb0_042x;
  uint output_device = cb0_041w;
  float expand_gamut = cb0_036w;
  //bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 SV_Target;
  float _8[6];
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
  float _22 = 0.5f / cb0_035x;
  float _27 = cb0_035x + -1.0f;
  float _28 = (cb0_035x * (TEXCOORD.x - _22)) / _27;
  float _29 = (cb0_035x * (TEXCOORD.y - _22)) / _27;
  float _31 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _27;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _117;
  float _118;
  float _119;
  float _642;
  float _675;
  float _689;
  float _753;
  float _1021;
  float _1022;
  float _1023;
  float _1034;
  float _1045;
  float _1218;
  float _1233;
  float _1248;
  float _1256;
  float _1257;
  float _1258;
  float _1325;
  float _1358;
  float _1372;
  float _1411;
  float _1533;
  float _1619;
  float _1693;
  float _1772;
  float _1773;
  float _1774;
  float _1944;
  float _1959;
  float _1974;
  float _1982;
  float _1983;
  float _1984;
  float _2051;
  float _2084;
  float _2098;
  float _2137;
  float _2259;
  float _2345;
  float _2431;
  float _2510;
  float _2511;
  float _2512;
  float _2729;
  float _2730;
  float _2731;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _40 = (output_gamut == 4);
        _51 = select(_40, 1.0f, 1.705051064491272f);
        _52 = select(_40, 0.0f, -0.6217921376228333f);
        _53 = select(_40, 0.0f, -0.0832589864730835f);
        _54 = select(_40, 0.0f, -0.13025647401809692f);
        _55 = select(_40, 1.0f, 1.140804648399353f);
        _56 = select(_40, 0.0f, -0.010548308491706848f);
        _57 = select(_40, 0.0f, -0.024003351107239723f);
        _58 = select(_40, 0.0f, -0.1289689838886261f);
        _59 = select(_40, 1.0f, 1.1529725790023804f);
      } else {
        _51 = 0.6954522132873535f;
        _52 = 0.14067870378494263f;
        _53 = 0.16386906802654266f;
        _54 = 0.044794563204050064f;
        _55 = 0.8596711158752441f;
        _56 = 0.0955343171954155f;
        _57 = -0.005525882821530104f;
        _58 = 0.004025210160762072f;
        _59 = 1.0015007257461548f;
      }
    } else {
      _51 = 1.0258246660232544f;
      _52 = -0.020053181797266006f;
      _53 = -0.005771636962890625f;
      _54 = -0.002234415616840124f;
      _55 = 1.0045864582061768f;
      _56 = -0.002352118492126465f;
      _57 = -0.005013350863009691f;
      _58 = -0.025290070101618767f;
      _59 = 1.0303035974502563f;
    }
  } else {
    _51 = 1.3792141675949097f;
    _52 = -0.30886411666870117f;
    _53 = -0.0703500509262085f;
    _54 = -0.06933490186929703f;
    _55 = 1.08229660987854f;
    _56 = -0.012961871922016144f;
    _57 = -0.0021590073592960835f;
    _58 = -0.0454593189060688f;
    _59 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)output_device > (uint)2) {
    float _70 = (pow(_28, 0.012683313339948654f));
    float _71 = (pow(_29, 0.012683313339948654f));
    float _72 = (pow(_31, 0.012683313339948654f));
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _117 = ((exp2((_28 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_29 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _134 = mad((WorkingColorSpace_128[0].z), _119, mad((WorkingColorSpace_128[0].y), _118, ((WorkingColorSpace_128[0].x) * _117)));
  float _137 = mad((WorkingColorSpace_128[1].z), _119, mad((WorkingColorSpace_128[1].y), _118, ((WorkingColorSpace_128[1].x) * _117)));
  float _140 = mad((WorkingColorSpace_128[2].z), _119, mad((WorkingColorSpace_128[2].y), _118, ((WorkingColorSpace_128[2].x) * _117)));
  float _141 = dot(float3(_134, _137, _140), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _145 = (_134 / _141) + -1.0f;
  float _146 = (_137 / _141) + -1.0f;
  float _147 = (_140 / _141) + -1.0f;
  float _159 = (1.0f - exp2(((_141 * _141) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_145, _146, _147), float3(_145, _146, _147)) * -4.0f));
  float _175 = ((mad(-0.06368321925401688f, _140, mad(-0.3292922377586365f, _137, (_134 * 1.3704125881195068f))) - _134) * _159) + _134;
  float _176 = ((mad(-0.010861365124583244f, _140, mad(1.0970927476882935f, _137, (_134 * -0.08343357592821121f))) - _137) * _159) + _137;
  float _177 = ((mad(1.2036951780319214f, _140, mad(-0.09862580895423889f, _137, (_134 * -0.02579331398010254f))) - _140) * _159) + _140;
  float _178 = dot(float3(_175, _176, _177), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _192 = cb0_019w + cb0_024w;
  float _206 = cb0_018w * cb0_023w;
  float _220 = cb0_017w * cb0_022w;
  float _234 = cb0_016w * cb0_021w;
  float _248 = cb0_015w * cb0_020w;
  float _252 = _175 - _178;
  float _253 = _176 - _178;
  float _254 = _177 - _178;
  float _311 = saturate(_178 / cb0_035w);
  float _315 = (_311 * _311) * (3.0f - (_311 * 2.0f));
  float _316 = 1.0f - _315;
  float _325 = cb0_019w + cb0_034w;
  float _334 = cb0_018w * cb0_033w;
  float _343 = cb0_017w * cb0_032w;
  float _352 = cb0_016w * cb0_031w;
  float _361 = cb0_015w * cb0_030w;
  float _424 = saturate((_178 - cb0_036x) / (cb0_036y - cb0_036x));
  float _428 = (_424 * _424) * (3.0f - (_424 * 2.0f));
  float _437 = cb0_019w + cb0_029w;
  float _446 = cb0_018w * cb0_028w;
  float _455 = cb0_017w * cb0_027w;
  float _464 = cb0_016w * cb0_026w;
  float _473 = cb0_015w * cb0_025w;
  float _531 = _315 - _428;
  float _542 = ((_428 * (((cb0_019x + cb0_034x) + _325) + (((cb0_018x * cb0_033x) * _334) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _352) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _361) * _252) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _343)))))) + (_316 * (((cb0_019x + cb0_024x) + _192) + (((cb0_018x * cb0_023x) * _206) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _234) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _248) * _252) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _220))))))) + ((((cb0_019x + cb0_029x) + _437) + (((cb0_018x * cb0_028x) * _446) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _464) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _473) * _252) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _455))))) * _531);
  float _544 = ((_428 * (((cb0_019y + cb0_034y) + _325) + (((cb0_018y * cb0_033y) * _334) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _352) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _361) * _253) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _343)))))) + (_316 * (((cb0_019y + cb0_024y) + _192) + (((cb0_018y * cb0_023y) * _206) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _234) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _248) * _253) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _220))))))) + ((((cb0_019y + cb0_029y) + _437) + (((cb0_018y * cb0_028y) * _446) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _464) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _473) * _253) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _455))))) * _531);
  float _546 = ((_428 * (((cb0_019z + cb0_034z) + _325) + (((cb0_018z * cb0_033z) * _334) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _352) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _361) * _254) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _343)))))) + (_316 * (((cb0_019z + cb0_024z) + _192) + (((cb0_018z * cb0_023z) * _206) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _234) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _248) * _254) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _220))))))) + ((((cb0_019z + cb0_029z) + _437) + (((cb0_018z * cb0_028z) * _446) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _464) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _473) * _254) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _455))))) * _531);

  //UntonemappedAP1

  float _582 = ((mad(0.061360642313957214f, _546, mad(-4.540197551250458e-09f, _544, (_542 * 0.9386394023895264f))) - _542) * cb0_036z) + _542;
  float _583 = ((mad(0.169205904006958f, _546, mad(0.8307942152023315f, _544, (_542 * 6.775371730327606e-08f))) - _544) * cb0_036z) + _544;
  float _584 = (mad(-2.3283064365386963e-10f, _544, (_542 * -9.313225746154785e-10f)) * cb0_036z) + _546;
  float _587 = mad(0.16386905312538147f, _584, mad(0.14067868888378143f, _583, (_582 * 0.6954522132873535f)));
  float _590 = mad(0.0955343246459961f, _584, mad(0.8596711158752441f, _583, (_582 * 0.044794581830501556f)));
  float _593 = mad(1.0015007257461548f, _584, mad(0.004025210160762072f, _583, (_582 * -0.005525882821530104f)));
  float _597 = max(max(_587, _590), _593);
  float _602 = (max(_597, 1.000000013351432e-10f) - max(min(min(_587, _590), _593), 1.000000013351432e-10f)) / max(_597, 0.009999999776482582f);
  float _615 = ((_590 + _587) + _593) + (sqrt((((_593 - _590) * _593) + ((_590 - _587) * _590)) + ((_587 - _593) * _587)) * 1.75f);
  float _616 = _615 * 0.3333333432674408f;
  float _617 = _602 + -0.4000000059604645f;
  float _618 = _617 * 5.0f;
  float _622 = max((1.0f - abs(_617 * 2.5f)), 0.0f);
  float _633 = ((float((int)(((int)(uint)((bool)(_618 > 0.0f))) - ((int)(uint)((bool)(_618 < 0.0f))))) * (1.0f - (_622 * _622))) + 1.0f) * 0.02500000037252903f;
  if (!(_616 <= 0.0533333346247673f)) {
    if (!(_616 >= 0.1599999964237213f)) {
      _642 = (((0.23999999463558197f / _615) + -0.5f) * _633);
    } else {
      _642 = 0.0f;
    }
  } else {
    _642 = _633;
  }
  float _643 = _642 + 1.0f;
  float _644 = _643 * _587;
  float _645 = _643 * _590;
  float _646 = _643 * _593;
  if (!((bool)(_644 == _645) && (bool)(_645 == _646))) {
    float _653 = ((_644 * 2.0f) - _645) - _646;
    float _656 = ((_590 - _593) * 1.7320507764816284f) * _643;
    float _658 = atan(_656 / _653);
    bool _661 = (_653 < 0.0f);
    bool _662 = (_653 == 0.0f);
    bool _663 = (_656 >= 0.0f);
    bool _664 = (_656 < 0.0f);
    _675 = select((_663 && _662), 90.0f, select((_664 && _662), -90.0f, (select((_664 && _661), (_658 + -3.1415927410125732f), select((_663 && _661), (_658 + 3.1415927410125732f), _658)) * 57.2957763671875f)));
  } else {
    _675 = 0.0f;
  }
  float _680 = min(max(select((_675 < 0.0f), (_675 + 360.0f), _675), 0.0f), 360.0f);
  if (_680 < -180.0f) {
    _689 = (_680 + 360.0f);
  } else {
    if (_680 > 180.0f) {
      _689 = (_680 + -360.0f);
    } else {
      _689 = _680;
    }
  }
  float _693 = saturate(1.0f - abs(_689 * 0.014814814552664757f));
  float _697 = (_693 * _693) * (3.0f - (_693 * 2.0f));
  float _703 = ((_697 * _697) * ((_602 * 0.18000000715255737f) * (0.029999999329447746f - _644))) + _644;
  float _713 = max(0.0f, mad(-0.21492856740951538f, _646, mad(-0.2365107536315918f, _645, (_703 * 1.4514392614364624f))));
  float _714 = max(0.0f, mad(-0.09967592358589172f, _646, mad(1.17622971534729f, _645, (_703 * -0.07655377686023712f))));
  float _715 = max(0.0f, mad(0.9977163076400757f, _646, mad(-0.006032449658960104f, _645, (_703 * 0.008316148072481155f))));
  float _716 = dot(float3(_713, _714, _715), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _731 = (cb0_038x + 1.0f) - cb0_037z;
  float _733 = cb0_038y + 1.0f;
  float _735 = _733 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _753 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _744 = (cb0_038x + 0.18000000715255737f) / _731;
    _753 = (-0.7447274923324585f - ((log2(_744 / (2.0f - _744)) * 0.3465735912322998f) * (_731 / cb0_037y)));
  }
  float _756 = ((1.0f - cb0_037z) / cb0_037y) - _753;
  float _758 = (cb0_037w / cb0_037y) - _756;

  float3 lerpColor = lerp(_716, float3(_713, _714, _715), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _582, _583, _584);
  float _904 = lerpColor.r, _905 = lerpColor.g, _906 = lerpColor.b;
#else
  float _762 = log2(lerp(_716, _713, 0.9599999785423279f)) * 0.3010300099849701f;
  float _763 = log2(lerp(_716, _714, 0.9599999785423279f)) * 0.3010300099849701f;
  float _764 = log2(lerp(_716, _715, 0.9599999785423279f)) * 0.3010300099849701f;
  float _768 = cb0_037y * (_762 + _756);
  float _769 = cb0_037y * (_763 + _756);
  float _770 = cb0_037y * (_764 + _756);
  float _771 = _731 * 2.0f;
  float _773 = (cb0_037y * -2.0f) / _731;
  float _774 = _762 - _753;
  float _775 = _763 - _753;
  float _776 = _764 - _753;
  float _795 = _735 * 2.0f;
  float _797 = (cb0_037y * 2.0f) / _735;
  float _822 = select((_762 < _753), ((_771 / (exp2((_774 * 1.4426950216293335f) * _773) + 1.0f)) - cb0_038x), _768);
  float _823 = select((_763 < _753), ((_771 / (exp2((_775 * 1.4426950216293335f) * _773) + 1.0f)) - cb0_038x), _769);
  float _824 = select((_764 < _753), ((_771 / (exp2((_776 * 1.4426950216293335f) * _773) + 1.0f)) - cb0_038x), _770);
  float _831 = _758 - _753;
  float _835 = saturate(_774 / _831);
  float _836 = saturate(_775 / _831);
  float _837 = saturate(_776 / _831);
  bool _838 = (_758 < _753);
  float _842 = select(_838, (1.0f - _835), _835);
  float _843 = select(_838, (1.0f - _836), _836);
  float _844 = select(_838, (1.0f - _837), _837);
  float _863 = (((_842 * _842) * (select((_762 > _758), (_733 - (_795 / (exp2(((_762 - _758) * 1.4426950216293335f) * _797) + 1.0f))), _768) - _822)) * (3.0f - (_842 * 2.0f))) + _822;
  float _864 = (((_843 * _843) * (select((_763 > _758), (_733 - (_795 / (exp2(((_763 - _758) * 1.4426950216293335f) * _797) + 1.0f))), _769) - _823)) * (3.0f - (_843 * 2.0f))) + _823;
  float _865 = (((_844 * _844) * (select((_764 > _758), (_733 - (_795 / (exp2(((_764 - _758) * 1.4426950216293335f) * _797) + 1.0f))), _770) - _824)) * (3.0f - (_844 * 2.0f))) + _824;
  float _866 = dot(float3(_863, _864, _865), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _886 = (cb0_037x * (max(0.0f, (lerp(_866, _863, 0.9300000071525574f))) - _582)) + _582;
  float _887 = (cb0_037x * (max(0.0f, (lerp(_866, _864, 0.9300000071525574f))) - _583)) + _583;
  float _888 = (cb0_037x * (max(0.0f, (lerp(_866, _865, 0.9300000071525574f))) - _584)) + _584;
  float _904 = ((mad(-0.06537103652954102f, _888, mad(1.451815478503704e-06f, _887, (_886 * 1.065374732017517f))) - _886) * cb0_036z) + _886;
  float _905 = ((mad(-0.20366770029067993f, _888, mad(1.2036634683609009f, _887, (_886 * -2.57161445915699e-07f))) - _887) * cb0_036z) + _887;
  float _906 = ((mad(0.9999996423721313f, _888, mad(2.0954757928848267e-08f, _887, (_886 * 1.862645149230957e-08f))) - _888) * cb0_036z) + _888;
#endif

  //TonemappedAP1

  float _916 = mad((WorkingColorSpace_192[0].z), _906, mad((WorkingColorSpace_192[0].y), _905, ((WorkingColorSpace_192[0].x) * _904)));
  float _917 = mad((WorkingColorSpace_192[1].z), _906, mad((WorkingColorSpace_192[1].y), _905, ((WorkingColorSpace_192[1].x) * _904)));
  float _918 = mad((WorkingColorSpace_192[2].z), _906, mad((WorkingColorSpace_192[2].y), _905, ((WorkingColorSpace_192[2].x) * _904)));

  //_916 = max(0, _916);
  //_917 = max(0, _917);
  //_918 = max(0, _918);
  
  float _944 = cb0_014x * (((cb0_040y + (cb0_040x * _916)) * _916) + cb0_040z);
  float _945 = cb0_014y * (((cb0_040y + (cb0_040x * _917)) * _917) + cb0_040z);
  float _946 = cb0_014z * (((cb0_040y + (cb0_040x * _918)) * _918) + cb0_040z);
  float _953 = ((cb0_013x - _944) * cb0_013w) + _944;
  float _954 = ((cb0_013y - _945) * cb0_013w) + _945;
  float _955 = ((cb0_013z - _946) * cb0_013w) + _946;

  if (GenerateOutput(_953, _954, _955, SV_Target)) {
    return SV_Target;
  }

  float _956 = cb0_014x * mad((WorkingColorSpace_192[0].z), _546, mad((WorkingColorSpace_192[0].y), _544, (_542 * (WorkingColorSpace_192[0].x))));
  float _957 = cb0_014y * mad((WorkingColorSpace_192[1].z), _546, mad((WorkingColorSpace_192[1].y), _544, ((WorkingColorSpace_192[1].x) * _542)));
  float _958 = cb0_014z * mad((WorkingColorSpace_192[2].z), _546, mad((WorkingColorSpace_192[2].y), _544, ((WorkingColorSpace_192[2].x) * _542)));
  float _965 = ((cb0_013x - _956) * cb0_013w) + _956;
  float _966 = ((cb0_013y - _957) * cb0_013w) + _957;
  float _967 = ((cb0_013z - _958) * cb0_013w) + _958;
  float _979 = exp2(log2(max(0.0f, _953)) * cb0_041y);
  float _980 = exp2(log2(max(0.0f, _954)) * cb0_041y);
  float _981 = exp2(log2(max(0.0f, _955)) * cb0_041y);

  [branch]
  if (output_device == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1004 = mad((WorkingColorSpace_128[0].z), _981, mad((WorkingColorSpace_128[0].y), _980, ((WorkingColorSpace_128[0].x) * _979)));
        float _1007 = mad((WorkingColorSpace_128[1].z), _981, mad((WorkingColorSpace_128[1].y), _980, ((WorkingColorSpace_128[1].x) * _979)));
        float _1010 = mad((WorkingColorSpace_128[2].z), _981, mad((WorkingColorSpace_128[2].y), _980, ((WorkingColorSpace_128[2].x) * _979)));
        _1021 = mad(_53, _1010, mad(_52, _1007, (_1004 * _51)));
        _1022 = mad(_56, _1010, mad(_55, _1007, (_1004 * _54)));
        _1023 = mad(_59, _1010, mad(_58, _1007, (_1004 * _57)));
      } else {
        _1021 = _979;
        _1022 = _980;
        _1023 = _981;
      }
      do {
        if (_1021 < 0.0031306699384003878f) {
          _1034 = (_1021 * 12.920000076293945f);
        } else {
          _1034 = (((pow(_1021, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1022 < 0.0031306699384003878f) {
            _1045 = (_1022 * 12.920000076293945f);
          } else {
            _1045 = (((pow(_1022, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1023 < 0.0031306699384003878f) {
            _2729 = _1034;
            _2730 = _1045;
            _2731 = (_1023 * 12.920000076293945f);
          } else {
            _2729 = _1034;
            _2730 = _1045;
            _2731 = (((pow(_1023, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1072 = mad((WorkingColorSpace_128[0].z), _981, mad((WorkingColorSpace_128[0].y), _980, ((WorkingColorSpace_128[0].x) * _979)));
      float _1075 = mad((WorkingColorSpace_128[1].z), _981, mad((WorkingColorSpace_128[1].y), _980, ((WorkingColorSpace_128[1].x) * _979)));
      float _1078 = mad((WorkingColorSpace_128[2].z), _981, mad((WorkingColorSpace_128[2].y), _980, ((WorkingColorSpace_128[2].x) * _979)));
      float _1088 = max(6.103519990574569e-05f, mad(_53, _1078, mad(_52, _1075, (_1072 * _51))));
      float _1089 = max(6.103519990574569e-05f, mad(_56, _1078, mad(_55, _1075, (_1072 * _54))));
      float _1090 = max(6.103519990574569e-05f, mad(_59, _1078, mad(_58, _1075, (_1072 * _57))));
      _2729 = min((_1088 * 4.5f), ((exp2(log2(max(_1088, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2730 = min((_1089 * 4.5f), ((exp2(log2(max(_1089, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2731 = min((_1090 * 4.5f), ((exp2(log2(max(_1090, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
        _8[0] = cb0_010x;
        _8[1] = cb0_010y;
        _8[2] = cb0_010z;
        _8[3] = cb0_010w;
        _8[4] = cb0_012x;
        _8[5] = cb0_012x;
        _9[0] = cb0_011x;
        _9[1] = cb0_011y;
        _9[2] = cb0_011z;
        _9[3] = cb0_011w;
        _9[4] = cb0_012y;
        _9[5] = cb0_012y;
        float _1166 = cb0_012z * _965;
        float _1167 = cb0_012z * _966;
        float _1168 = cb0_012z * _967;
        float _1171 = mad((WorkingColorSpace_256[0].z), _1168, mad((WorkingColorSpace_256[0].y), _1167, ((WorkingColorSpace_256[0].x) * _1166)));
        float _1174 = mad((WorkingColorSpace_256[1].z), _1168, mad((WorkingColorSpace_256[1].y), _1167, ((WorkingColorSpace_256[1].x) * _1166)));
        float _1177 = mad((WorkingColorSpace_256[2].z), _1168, mad((WorkingColorSpace_256[2].y), _1167, ((WorkingColorSpace_256[2].x) * _1166)));
        float _1180 = mad(-0.21492856740951538f, _1177, mad(-0.2365107536315918f, _1174, (_1171 * 1.4514392614364624f)));
        float _1183 = mad(-0.09967592358589172f, _1177, mad(1.17622971534729f, _1174, (_1171 * -0.07655377686023712f)));
        float _1186 = mad(0.9977163076400757f, _1177, mad(-0.006032449658960104f, _1174, (_1171 * 0.008316148072481155f)));
        float _1188 = max(_1180, max(_1183, _1186));
        do {
          if (!(_1188 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1171 < 0.0f) || (bool)(_1174 < 0.0f))) || (bool)(_1177 < 0.0f))) {
              float _1198 = abs(_1188);
              float _1199 = (_1188 - _1180) / _1198;
              float _1201 = (_1188 - _1183) / _1198;
              float _1203 = (_1188 - _1186) / _1198;
              do {
                if (!(_1199 < 0.8149999976158142f)) {
                  float _1206 = _1199 + -0.8149999976158142f;
                  _1218 = ((_1206 / exp2(log2(exp2(log2(_1206 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1218 = _1199;
                }
                do {
                  if (!(_1201 < 0.8029999732971191f)) {
                    float _1221 = _1201 + -0.8029999732971191f;
                    _1233 = ((_1221 / exp2(log2(exp2(log2(_1221 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1233 = _1201;
                  }
                  do {
                    if (!(_1203 < 0.8799999952316284f)) {
                      float _1236 = _1203 + -0.8799999952316284f;
                      _1248 = ((_1236 / exp2(log2(exp2(log2(_1236 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1248 = _1203;
                    }
                    _1256 = (_1188 - (_1198 * _1218));
                    _1257 = (_1188 - (_1198 * _1233));
                    _1258 = (_1188 - (_1198 * _1248));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1256 = _1180;
              _1257 = _1183;
              _1258 = _1186;
            }
          } else {
            _1256 = _1180;
            _1257 = _1183;
            _1258 = _1186;
          }
          float _1274 = ((mad(0.16386906802654266f, _1258, mad(0.14067870378494263f, _1257, (_1256 * 0.6954522132873535f))) - _1171) * cb0_012w) + _1171;
          float _1275 = ((mad(0.0955343171954155f, _1258, mad(0.8596711158752441f, _1257, (_1256 * 0.044794563204050064f))) - _1174) * cb0_012w) + _1174;
          float _1276 = ((mad(1.0015007257461548f, _1258, mad(0.004025210160762072f, _1257, (_1256 * -0.005525882821530104f))) - _1177) * cb0_012w) + _1177;
          float _1280 = max(max(_1274, _1275), _1276);
          float _1285 = (max(_1280, 1.000000013351432e-10f) - max(min(min(_1274, _1275), _1276), 1.000000013351432e-10f)) / max(_1280, 0.009999999776482582f);
          float _1298 = ((_1275 + _1274) + _1276) + (sqrt((((_1276 - _1275) * _1276) + ((_1275 - _1274) * _1275)) + ((_1274 - _1276) * _1274)) * 1.75f);
          float _1299 = _1298 * 0.3333333432674408f;
          float _1300 = _1285 + -0.4000000059604645f;
          float _1301 = _1300 * 5.0f;
          float _1305 = max((1.0f - abs(_1300 * 2.5f)), 0.0f);
          float _1316 = ((float((int)(((int)(uint)((bool)(_1301 > 0.0f))) - ((int)(uint)((bool)(_1301 < 0.0f))))) * (1.0f - (_1305 * _1305))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1299 <= 0.0533333346247673f)) {
              if (!(_1299 >= 0.1599999964237213f)) {
                _1325 = (((0.23999999463558197f / _1298) + -0.5f) * _1316);
              } else {
                _1325 = 0.0f;
              }
            } else {
              _1325 = _1316;
            }
            float _1326 = _1325 + 1.0f;
            float _1327 = _1326 * _1274;
            float _1328 = _1326 * _1275;
            float _1329 = _1326 * _1276;
            do {
              if (!((bool)(_1327 == _1328) && (bool)(_1328 == _1329))) {
                float _1336 = ((_1327 * 2.0f) - _1328) - _1329;
                float _1339 = ((_1275 - _1276) * 1.7320507764816284f) * _1326;
                float _1341 = atan(_1339 / _1336);
                bool _1344 = (_1336 < 0.0f);
                bool _1345 = (_1336 == 0.0f);
                bool _1346 = (_1339 >= 0.0f);
                bool _1347 = (_1339 < 0.0f);
                _1358 = select((_1346 && _1345), 90.0f, select((_1347 && _1345), -90.0f, (select((_1347 && _1344), (_1341 + -3.1415927410125732f), select((_1346 && _1344), (_1341 + 3.1415927410125732f), _1341)) * 57.2957763671875f)));
              } else {
                _1358 = 0.0f;
              }
              float _1363 = min(max(select((_1358 < 0.0f), (_1358 + 360.0f), _1358), 0.0f), 360.0f);
              do {
                if (_1363 < -180.0f) {
                  _1372 = (_1363 + 360.0f);
                } else {
                  if (_1363 > 180.0f) {
                    _1372 = (_1363 + -360.0f);
                  } else {
                    _1372 = _1363;
                  }
                }
                do {
                  if ((bool)(_1372 > -67.5f) && (bool)(_1372 < 67.5f)) {
                    float _1378 = (_1372 + 67.5f) * 0.029629629105329514f;
                    int _1379 = int(_1378);
                    float _1381 = _1378 - float((int)(_1379));
                    float _1382 = _1381 * _1381;
                    float _1383 = _1382 * _1381;
                    if (_1379 == 3) {
                      _1411 = (((0.1666666716337204f - (_1381 * 0.5f)) + (_1382 * 0.5f)) - (_1383 * 0.1666666716337204f));
                    } else {
                      if (_1379 == 2) {
                        _1411 = ((0.6666666865348816f - _1382) + (_1383 * 0.5f));
                      } else {
                        if (_1379 == 1) {
                          _1411 = (((_1383 * -0.5f) + 0.1666666716337204f) + ((_1382 + _1381) * 0.5f));
                        } else {
                          _1411 = select((_1379 == 0), (_1383 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1411 = 0.0f;
                  }
                  float _1420 = min(max(((((_1285 * 0.27000001072883606f) * (0.029999999329447746f - _1327)) * _1411) + _1327), 0.0f), 65535.0f);
                  float _1421 = min(max(_1328, 0.0f), 65535.0f);
                  float _1422 = min(max(_1329, 0.0f), 65535.0f);
                  float _1435 = min(max(mad(-0.21492856740951538f, _1422, mad(-0.2365107536315918f, _1421, (_1420 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1436 = min(max(mad(-0.09967592358589172f, _1422, mad(1.17622971534729f, _1421, (_1420 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1437 = min(max(mad(0.9977163076400757f, _1422, mad(-0.006032449658960104f, _1421, (_1420 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1438 = dot(float3(_1435, _1436, _1437), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _16[0] = cb0_010x;
                  _16[1] = cb0_010y;
                  _16[2] = cb0_010z;
                  _16[3] = cb0_010w;
                  _16[4] = cb0_012x;
                  _16[5] = cb0_012x;
                  _17[0] = cb0_011x;
                  _17[1] = cb0_011y;
                  _17[2] = cb0_011z;
                  _17[3] = cb0_011w;
                  _17[4] = cb0_012y;
                  _17[5] = cb0_012y;
                  float _1461 = log2(max((lerp(_1438, _1435, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1462 = _1461 * 0.3010300099849701f;
                  float _1463 = log2(cb0_008x);
                  float _1464 = _1463 * 0.3010300099849701f;
                  do {
                    if (!(!(_1462 <= _1464))) {
                      _1533 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1471 = log2(cb0_009x);
                      float _1472 = _1471 * 0.3010300099849701f;
                      if ((bool)(_1462 > _1464) && (bool)(_1462 < _1472)) {
                        float _1480 = ((_1461 - _1463) * 0.9030900001525879f) / ((_1471 - _1463) * 0.3010300099849701f);
                        int _1481 = int(_1480);
                        float _1483 = _1480 - float((int)(_1481));
                        float _1485 = _16[_1481];
                        float _1488 = _16[(_1481 + 1)];
                        float _1493 = _1485 * 0.5f;
                        _1533 = dot(float3((_1483 * _1483), _1483, 1.0f), float3(mad((_16[(_1481 + 2)]), 0.5f, mad(_1488, -1.0f, _1493)), (_1488 - _1485), mad(_1488, 0.5f, _1493)));
                      } else {
                        do {
                          if (!(!(_1462 >= _1472))) {
                            float _1502 = log2(cb0_008z);
                            if (_1462 < (_1502 * 0.3010300099849701f)) {
                              float _1510 = ((_1461 - _1471) * 0.9030900001525879f) / ((_1502 - _1471) * 0.3010300099849701f);
                              int _1511 = int(_1510);
                              float _1513 = _1510 - float((int)(_1511));
                              float _1515 = _17[_1511];
                              float _1518 = _17[(_1511 + 1)];
                              float _1523 = _1515 * 0.5f;
                              _1533 = dot(float3((_1513 * _1513), _1513, 1.0f), float3(mad((_17[(_1511 + 2)]), 0.5f, mad(_1518, -1.0f, _1523)), (_1518 - _1515), mad(_1518, 0.5f, _1523)));
                              break;
                            }
                          }
                          _1533 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _18[0] = cb0_010x;
                    _18[1] = cb0_010y;
                    _18[2] = cb0_010z;
                    _18[3] = cb0_010w;
                    _18[4] = cb0_012x;
                    _18[5] = cb0_012x;
                    _19[0] = cb0_011x;
                    _19[1] = cb0_011y;
                    _19[2] = cb0_011z;
                    _19[3] = cb0_011w;
                    _19[4] = cb0_012y;
                    _19[5] = cb0_012y;
                    float _1549 = log2(max((lerp(_1438, _1436, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1550 = _1549 * 0.3010300099849701f;
                    do {
                      if (!(!(_1550 <= _1464))) {
                        _1619 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1557 = log2(cb0_009x);
                        float _1558 = _1557 * 0.3010300099849701f;
                        if ((bool)(_1550 > _1464) && (bool)(_1550 < _1558)) {
                          float _1566 = ((_1549 - _1463) * 0.9030900001525879f) / ((_1557 - _1463) * 0.3010300099849701f);
                          int _1567 = int(_1566);
                          float _1569 = _1566 - float((int)(_1567));
                          float _1571 = _18[_1567];
                          float _1574 = _18[(_1567 + 1)];
                          float _1579 = _1571 * 0.5f;
                          _1619 = dot(float3((_1569 * _1569), _1569, 1.0f), float3(mad((_18[(_1567 + 2)]), 0.5f, mad(_1574, -1.0f, _1579)), (_1574 - _1571), mad(_1574, 0.5f, _1579)));
                        } else {
                          do {
                            if (!(!(_1550 >= _1558))) {
                              float _1588 = log2(cb0_008z);
                              if (_1550 < (_1588 * 0.3010300099849701f)) {
                                float _1596 = ((_1549 - _1557) * 0.9030900001525879f) / ((_1588 - _1557) * 0.3010300099849701f);
                                int _1597 = int(_1596);
                                float _1599 = _1596 - float((int)(_1597));
                                float _1601 = _19[_1597];
                                float _1604 = _19[(_1597 + 1)];
                                float _1609 = _1601 * 0.5f;
                                _1619 = dot(float3((_1599 * _1599), _1599, 1.0f), float3(mad((_19[(_1597 + 2)]), 0.5f, mad(_1604, -1.0f, _1609)), (_1604 - _1601), mad(_1604, 0.5f, _1609)));
                                break;
                              }
                            }
                            _1619 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1623 = log2(max((lerp(_1438, _1437, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1624 = _1623 * 0.3010300099849701f;
                      do {
                        if (!(!(_1624 <= _1464))) {
                          _1693 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1631 = log2(cb0_009x);
                          float _1632 = _1631 * 0.3010300099849701f;
                          if ((bool)(_1624 > _1464) && (bool)(_1624 < _1632)) {
                            float _1640 = ((_1623 - _1463) * 0.9030900001525879f) / ((_1631 - _1463) * 0.3010300099849701f);
                            int _1641 = int(_1640);
                            float _1643 = _1640 - float((int)(_1641));
                            float _1645 = _8[_1641];
                            float _1648 = _8[(_1641 + 1)];
                            float _1653 = _1645 * 0.5f;
                            _1693 = dot(float3((_1643 * _1643), _1643, 1.0f), float3(mad((_8[(_1641 + 2)]), 0.5f, mad(_1648, -1.0f, _1653)), (_1648 - _1645), mad(_1648, 0.5f, _1653)));
                          } else {
                            do {
                              if (!(!(_1624 >= _1632))) {
                                float _1662 = log2(cb0_008z);
                                if (_1624 < (_1662 * 0.3010300099849701f)) {
                                  float _1670 = ((_1623 - _1631) * 0.9030900001525879f) / ((_1662 - _1631) * 0.3010300099849701f);
                                  int _1671 = int(_1670);
                                  float _1673 = _1670 - float((int)(_1671));
                                  float _1675 = _9[_1671];
                                  float _1678 = _9[(_1671 + 1)];
                                  float _1683 = _1675 * 0.5f;
                                  _1693 = dot(float3((_1673 * _1673), _1673, 1.0f), float3(mad((_9[(_1671 + 2)]), 0.5f, mad(_1678, -1.0f, _1683)), (_1678 - _1675), mad(_1678, 0.5f, _1683)));
                                  break;
                                }
                              }
                              _1693 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1697 = cb0_008w - cb0_008y;
                        float _1698 = (exp2(_1533 * 3.321928024291992f) - cb0_008y) / _1697;
                        float _1700 = (exp2(_1619 * 3.321928024291992f) - cb0_008y) / _1697;
                        float _1702 = (exp2(_1693 * 3.321928024291992f) - cb0_008y) / _1697;
                        float _1705 = mad(0.15618768334388733f, _1702, mad(0.13400420546531677f, _1700, (_1698 * 0.6624541878700256f)));
                        float _1708 = mad(0.053689517080783844f, _1702, mad(0.6740817427635193f, _1700, (_1698 * 0.2722287178039551f)));
                        float _1711 = mad(1.0103391408920288f, _1702, mad(0.00406073359772563f, _1700, (_1698 * -0.005574649665504694f)));
                        float _1724 = min(max(mad(-0.23642469942569733f, _1711, mad(-0.32480329275131226f, _1708, (_1705 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1725 = min(max(mad(0.016756348311901093f, _1711, mad(1.6153316497802734f, _1708, (_1705 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1726 = min(max(mad(0.9883948564529419f, _1711, mad(-0.008284442126750946f, _1708, (_1705 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1729 = mad(0.15618768334388733f, _1726, mad(0.13400420546531677f, _1725, (_1724 * 0.6624541878700256f)));
                        float _1732 = mad(0.053689517080783844f, _1726, mad(0.6740817427635193f, _1725, (_1724 * 0.2722287178039551f)));
                        float _1735 = mad(1.0103391408920288f, _1726, mad(0.00406073359772563f, _1725, (_1724 * -0.005574649665504694f)));
                        float _1757 = min(max((min(max(mad(-0.23642469942569733f, _1735, mad(-0.32480329275131226f, _1732, (_1729 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1758 = min(max((min(max(mad(0.016756348311901093f, _1735, mad(1.6153316497802734f, _1732, (_1729 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1759 = min(max((min(max(mad(0.9883948564529419f, _1735, mad(-0.008284442126750946f, _1732, (_1729 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 5)) {
                            _1772 = mad(_53, _1759, mad(_52, _1758, (_1757 * _51)));
                            _1773 = mad(_56, _1759, mad(_55, _1758, (_1757 * _54)));
                            _1774 = mad(_59, _1759, mad(_58, _1758, (_1757 * _57)));
                          } else {
                            _1772 = _1757;
                            _1773 = _1758;
                            _1774 = _1759;
                          }
                          float _1784 = exp2(log2(_1772 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1785 = exp2(log2(_1773 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1786 = exp2(log2(_1774 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1811 = exp2(log2((1.0f / ((_1784 * 18.6875f) + 1.0f)) * ((_1784 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          float _1812 = exp2(log2((1.0f / ((_1785 * 18.6875f) + 1.0f)) * ((_1785 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          float _1813 = exp2(log2((1.0f / ((_1786 * 18.6875f) + 1.0f)) * ((_1786 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          float _1820 = 1000.0f - cb0_039x;
                          float _1824 = saturate((_1811 - cb0_039x) / _1820);
                          float _1825 = saturate((_1812 - cb0_039x) / _1820);
                          float _1826 = saturate((_1813 - cb0_039x) / _1820);
                          float _1827 = 1.0f - _1824;
                          float _1828 = 1.0f - _1825;
                          float _1829 = 1.0f - _1826;
                          float _1833 = _1824 * cb0_039y;
                          float _1834 = _1825 * cb0_039y;
                          float _1835 = _1826 * cb0_039y;
                          _2729 = select((_1811 > cb0_039x), min(((((_1827 * cb0_039x) + _1833) * _1827) + _1833), _1811), _1811);
                          _2730 = select((_1812 > cb0_039x), min(((((_1828 * cb0_039x) + _1834) * _1828) + _1834), _1812), _1812);
                          _2731 = select((_1813 > cb0_039x), min(((((_1829 * cb0_039x) + _1835) * _1829) + _1835), _1813), _1813);
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
        if ((output_device & -3) == 4) {
          float _1892 = cb0_012z * _965;
          float _1893 = cb0_012z * _966;
          float _1894 = cb0_012z * _967;
          float _1897 = mad((WorkingColorSpace_256[0].z), _1894, mad((WorkingColorSpace_256[0].y), _1893, ((WorkingColorSpace_256[0].x) * _1892)));
          float _1900 = mad((WorkingColorSpace_256[1].z), _1894, mad((WorkingColorSpace_256[1].y), _1893, ((WorkingColorSpace_256[1].x) * _1892)));
          float _1903 = mad((WorkingColorSpace_256[2].z), _1894, mad((WorkingColorSpace_256[2].y), _1893, ((WorkingColorSpace_256[2].x) * _1892)));
          float _1906 = mad(-0.21492856740951538f, _1903, mad(-0.2365107536315918f, _1900, (_1897 * 1.4514392614364624f)));
          float _1909 = mad(-0.09967592358589172f, _1903, mad(1.17622971534729f, _1900, (_1897 * -0.07655377686023712f)));
          float _1912 = mad(0.9977163076400757f, _1903, mad(-0.006032449658960104f, _1900, (_1897 * 0.008316148072481155f)));
          float _1914 = max(_1906, max(_1909, _1912));
          do {
            if (!(_1914 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1897 < 0.0f) || (bool)(_1900 < 0.0f))) || (bool)(_1903 < 0.0f))) {
                float _1924 = abs(_1914);
                float _1925 = (_1914 - _1906) / _1924;
                float _1927 = (_1914 - _1909) / _1924;
                float _1929 = (_1914 - _1912) / _1924;
                do {
                  if (!(_1925 < 0.8149999976158142f)) {
                    float _1932 = _1925 + -0.8149999976158142f;
                    _1944 = ((_1932 / exp2(log2(exp2(log2(_1932 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1944 = _1925;
                  }
                  do {
                    if (!(_1927 < 0.8029999732971191f)) {
                      float _1947 = _1927 + -0.8029999732971191f;
                      _1959 = ((_1947 / exp2(log2(exp2(log2(_1947 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _1959 = _1927;
                    }
                    do {
                      if (!(_1929 < 0.8799999952316284f)) {
                        float _1962 = _1929 + -0.8799999952316284f;
                        _1974 = ((_1962 / exp2(log2(exp2(log2(_1962 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _1974 = _1929;
                      }
                      _1982 = (_1914 - (_1924 * _1944));
                      _1983 = (_1914 - (_1924 * _1959));
                      _1984 = (_1914 - (_1924 * _1974));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _1982 = _1906;
                _1983 = _1909;
                _1984 = _1912;
              }
            } else {
              _1982 = _1906;
              _1983 = _1909;
              _1984 = _1912;
            }
            float _2000 = ((mad(0.16386906802654266f, _1984, mad(0.14067870378494263f, _1983, (_1982 * 0.6954522132873535f))) - _1897) * cb0_012w) + _1897;
            float _2001 = ((mad(0.0955343171954155f, _1984, mad(0.8596711158752441f, _1983, (_1982 * 0.044794563204050064f))) - _1900) * cb0_012w) + _1900;
            float _2002 = ((mad(1.0015007257461548f, _1984, mad(0.004025210160762072f, _1983, (_1982 * -0.005525882821530104f))) - _1903) * cb0_012w) + _1903;
            float _2006 = max(max(_2000, _2001), _2002);
            float _2011 = (max(_2006, 1.000000013351432e-10f) - max(min(min(_2000, _2001), _2002), 1.000000013351432e-10f)) / max(_2006, 0.009999999776482582f);
            float _2024 = ((_2001 + _2000) + _2002) + (sqrt((((_2002 - _2001) * _2002) + ((_2001 - _2000) * _2001)) + ((_2000 - _2002) * _2000)) * 1.75f);
            float _2025 = _2024 * 0.3333333432674408f;
            float _2026 = _2011 + -0.4000000059604645f;
            float _2027 = _2026 * 5.0f;
            float _2031 = max((1.0f - abs(_2026 * 2.5f)), 0.0f);
            float _2042 = ((float((int)(((int)(uint)((bool)(_2027 > 0.0f))) - ((int)(uint)((bool)(_2027 < 0.0f))))) * (1.0f - (_2031 * _2031))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2025 <= 0.0533333346247673f)) {
                if (!(_2025 >= 0.1599999964237213f)) {
                  _2051 = (((0.23999999463558197f / _2024) + -0.5f) * _2042);
                } else {
                  _2051 = 0.0f;
                }
              } else {
                _2051 = _2042;
              }
              float _2052 = _2051 + 1.0f;
              float _2053 = _2052 * _2000;
              float _2054 = _2052 * _2001;
              float _2055 = _2052 * _2002;
              do {
                if (!((bool)(_2053 == _2054) && (bool)(_2054 == _2055))) {
                  float _2062 = ((_2053 * 2.0f) - _2054) - _2055;
                  float _2065 = ((_2001 - _2002) * 1.7320507764816284f) * _2052;
                  float _2067 = atan(_2065 / _2062);
                  bool _2070 = (_2062 < 0.0f);
                  bool _2071 = (_2062 == 0.0f);
                  bool _2072 = (_2065 >= 0.0f);
                  bool _2073 = (_2065 < 0.0f);
                  _2084 = select((_2072 && _2071), 90.0f, select((_2073 && _2071), -90.0f, (select((_2073 && _2070), (_2067 + -3.1415927410125732f), select((_2072 && _2070), (_2067 + 3.1415927410125732f), _2067)) * 57.2957763671875f)));
                } else {
                  _2084 = 0.0f;
                }
                float _2089 = min(max(select((_2084 < 0.0f), (_2084 + 360.0f), _2084), 0.0f), 360.0f);
                do {
                  if (_2089 < -180.0f) {
                    _2098 = (_2089 + 360.0f);
                  } else {
                    if (_2089 > 180.0f) {
                      _2098 = (_2089 + -360.0f);
                    } else {
                      _2098 = _2089;
                    }
                  }
                  do {
                    if ((bool)(_2098 > -67.5f) && (bool)(_2098 < 67.5f)) {
                      float _2104 = (_2098 + 67.5f) * 0.029629629105329514f;
                      int _2105 = int(_2104);
                      float _2107 = _2104 - float((int)(_2105));
                      float _2108 = _2107 * _2107;
                      float _2109 = _2108 * _2107;
                      if (_2105 == 3) {
                        _2137 = (((0.1666666716337204f - (_2107 * 0.5f)) + (_2108 * 0.5f)) - (_2109 * 0.1666666716337204f));
                      } else {
                        if (_2105 == 2) {
                          _2137 = ((0.6666666865348816f - _2108) + (_2109 * 0.5f));
                        } else {
                          if (_2105 == 1) {
                            _2137 = (((_2109 * -0.5f) + 0.1666666716337204f) + ((_2108 + _2107) * 0.5f));
                          } else {
                            _2137 = select((_2105 == 0), (_2109 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2137 = 0.0f;
                    }
                    float _2146 = min(max(((((_2011 * 0.27000001072883606f) * (0.029999999329447746f - _2053)) * _2137) + _2053), 0.0f), 65535.0f);
                    float _2147 = min(max(_2054, 0.0f), 65535.0f);
                    float _2148 = min(max(_2055, 0.0f), 65535.0f);
                    float _2161 = min(max(mad(-0.21492856740951538f, _2148, mad(-0.2365107536315918f, _2147, (_2146 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2162 = min(max(mad(-0.09967592358589172f, _2148, mad(1.17622971534729f, _2147, (_2146 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2163 = min(max(mad(0.9977163076400757f, _2148, mad(-0.006032449658960104f, _2147, (_2146 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2164 = dot(float3(_2161, _2162, _2163), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    _14[0] = cb0_010x;
                    _14[1] = cb0_010y;
                    _14[2] = cb0_010z;
                    _14[3] = cb0_010w;
                    _14[4] = cb0_012x;
                    _14[5] = cb0_012x;
                    _15[0] = cb0_011x;
                    _15[1] = cb0_011y;
                    _15[2] = cb0_011z;
                    _15[3] = cb0_011w;
                    _15[4] = cb0_012y;
                    _15[5] = cb0_012y;
                    float _2187 = log2(max((lerp(_2164, _2161, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2188 = _2187 * 0.3010300099849701f;
                    float _2189 = log2(cb0_008x);
                    float _2190 = _2189 * 0.3010300099849701f;
                    do {
                      if (!(!(_2188 <= _2190))) {
                        _2259 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2197 = log2(cb0_009x);
                        float _2198 = _2197 * 0.3010300099849701f;
                        if ((bool)(_2188 > _2190) && (bool)(_2188 < _2198)) {
                          float _2206 = ((_2187 - _2189) * 0.9030900001525879f) / ((_2197 - _2189) * 0.3010300099849701f);
                          int _2207 = int(_2206);
                          float _2209 = _2206 - float((int)(_2207));
                          float _2211 = _14[_2207];
                          float _2214 = _14[(_2207 + 1)];
                          float _2219 = _2211 * 0.5f;
                          _2259 = dot(float3((_2209 * _2209), _2209, 1.0f), float3(mad((_14[(_2207 + 2)]), 0.5f, mad(_2214, -1.0f, _2219)), (_2214 - _2211), mad(_2214, 0.5f, _2219)));
                        } else {
                          do {
                            if (!(!(_2188 >= _2198))) {
                              float _2228 = log2(cb0_008z);
                              if (_2188 < (_2228 * 0.3010300099849701f)) {
                                float _2236 = ((_2187 - _2197) * 0.9030900001525879f) / ((_2228 - _2197) * 0.3010300099849701f);
                                int _2237 = int(_2236);
                                float _2239 = _2236 - float((int)(_2237));
                                float _2241 = _15[_2237];
                                float _2244 = _15[(_2237 + 1)];
                                float _2249 = _2241 * 0.5f;
                                _2259 = dot(float3((_2239 * _2239), _2239, 1.0f), float3(mad((_15[(_2237 + 2)]), 0.5f, mad(_2244, -1.0f, _2249)), (_2244 - _2241), mad(_2244, 0.5f, _2249)));
                                break;
                              }
                            }
                            _2259 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      _10[0] = cb0_010x;
                      _10[1] = cb0_010y;
                      _10[2] = cb0_010z;
                      _10[3] = cb0_010w;
                      _10[4] = cb0_012x;
                      _10[5] = cb0_012x;
                      _11[0] = cb0_011x;
                      _11[1] = cb0_011y;
                      _11[2] = cb0_011z;
                      _11[3] = cb0_011w;
                      _11[4] = cb0_012y;
                      _11[5] = cb0_012y;
                      float _2275 = log2(max((lerp(_2164, _2162, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2276 = _2275 * 0.3010300099849701f;
                      do {
                        if (!(!(_2276 <= _2190))) {
                          _2345 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2283 = log2(cb0_009x);
                          float _2284 = _2283 * 0.3010300099849701f;
                          if ((bool)(_2276 > _2190) && (bool)(_2276 < _2284)) {
                            float _2292 = ((_2275 - _2189) * 0.9030900001525879f) / ((_2283 - _2189) * 0.3010300099849701f);
                            int _2293 = int(_2292);
                            float _2295 = _2292 - float((int)(_2293));
                            float _2297 = _10[_2293];
                            float _2300 = _10[(_2293 + 1)];
                            float _2305 = _2297 * 0.5f;
                            _2345 = dot(float3((_2295 * _2295), _2295, 1.0f), float3(mad((_10[(_2293 + 2)]), 0.5f, mad(_2300, -1.0f, _2305)), (_2300 - _2297), mad(_2300, 0.5f, _2305)));
                          } else {
                            do {
                              if (!(!(_2276 >= _2284))) {
                                float _2314 = log2(cb0_008z);
                                if (_2276 < (_2314 * 0.3010300099849701f)) {
                                  float _2322 = ((_2275 - _2283) * 0.9030900001525879f) / ((_2314 - _2283) * 0.3010300099849701f);
                                  int _2323 = int(_2322);
                                  float _2325 = _2322 - float((int)(_2323));
                                  float _2327 = _11[_2323];
                                  float _2330 = _11[(_2323 + 1)];
                                  float _2335 = _2327 * 0.5f;
                                  _2345 = dot(float3((_2325 * _2325), _2325, 1.0f), float3(mad((_11[(_2323 + 2)]), 0.5f, mad(_2330, -1.0f, _2335)), (_2330 - _2327), mad(_2330, 0.5f, _2335)));
                                  break;
                                }
                              }
                              _2345 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        _12[0] = cb0_010x;
                        _12[1] = cb0_010y;
                        _12[2] = cb0_010z;
                        _12[3] = cb0_010w;
                        _12[4] = cb0_012x;
                        _12[5] = cb0_012x;
                        _13[0] = cb0_011x;
                        _13[1] = cb0_011y;
                        _13[2] = cb0_011z;
                        _13[3] = cb0_011w;
                        _13[4] = cb0_012y;
                        _13[5] = cb0_012y;
                        float _2361 = log2(max((lerp(_2164, _2163, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2362 = _2361 * 0.3010300099849701f;
                        do {
                          if (!(!(_2362 <= _2190))) {
                            _2431 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2369 = log2(cb0_009x);
                            float _2370 = _2369 * 0.3010300099849701f;
                            if ((bool)(_2362 > _2190) && (bool)(_2362 < _2370)) {
                              float _2378 = ((_2361 - _2189) * 0.9030900001525879f) / ((_2369 - _2189) * 0.3010300099849701f);
                              int _2379 = int(_2378);
                              float _2381 = _2378 - float((int)(_2379));
                              float _2383 = _12[_2379];
                              float _2386 = _12[(_2379 + 1)];
                              float _2391 = _2383 * 0.5f;
                              _2431 = dot(float3((_2381 * _2381), _2381, 1.0f), float3(mad((_12[(_2379 + 2)]), 0.5f, mad(_2386, -1.0f, _2391)), (_2386 - _2383), mad(_2386, 0.5f, _2391)));
                            } else {
                              do {
                                if (!(!(_2362 >= _2370))) {
                                  float _2400 = log2(cb0_008z);
                                  if (_2362 < (_2400 * 0.3010300099849701f)) {
                                    float _2408 = ((_2361 - _2369) * 0.9030900001525879f) / ((_2400 - _2369) * 0.3010300099849701f);
                                    int _2409 = int(_2408);
                                    float _2411 = _2408 - float((int)(_2409));
                                    float _2413 = _13[_2409];
                                    float _2416 = _13[(_2409 + 1)];
                                    float _2421 = _2413 * 0.5f;
                                    _2431 = dot(float3((_2411 * _2411), _2411, 1.0f), float3(mad((_13[(_2409 + 2)]), 0.5f, mad(_2416, -1.0f, _2421)), (_2416 - _2413), mad(_2416, 0.5f, _2421)));
                                    break;
                                  }
                                }
                                _2431 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2435 = cb0_008w - cb0_008y;
                          float _2436 = (exp2(_2259 * 3.321928024291992f) - cb0_008y) / _2435;
                          float _2438 = (exp2(_2345 * 3.321928024291992f) - cb0_008y) / _2435;
                          float _2440 = (exp2(_2431 * 3.321928024291992f) - cb0_008y) / _2435;
                          float _2443 = mad(0.15618768334388733f, _2440, mad(0.13400420546531677f, _2438, (_2436 * 0.6624541878700256f)));
                          float _2446 = mad(0.053689517080783844f, _2440, mad(0.6740817427635193f, _2438, (_2436 * 0.2722287178039551f)));
                          float _2449 = mad(1.0103391408920288f, _2440, mad(0.00406073359772563f, _2438, (_2436 * -0.005574649665504694f)));
                          float _2462 = min(max(mad(-0.23642469942569733f, _2449, mad(-0.32480329275131226f, _2446, (_2443 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2463 = min(max(mad(0.016756348311901093f, _2449, mad(1.6153316497802734f, _2446, (_2443 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2464 = min(max(mad(0.9883948564529419f, _2449, mad(-0.008284442126750946f, _2446, (_2443 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2467 = mad(0.15618768334388733f, _2464, mad(0.13400420546531677f, _2463, (_2462 * 0.6624541878700256f)));
                          float _2470 = mad(0.053689517080783844f, _2464, mad(0.6740817427635193f, _2463, (_2462 * 0.2722287178039551f)));
                          float _2473 = mad(1.0103391408920288f, _2464, mad(0.00406073359772563f, _2463, (_2462 * -0.005574649665504694f)));
                          float _2495 = min(max((min(max(mad(-0.23642469942569733f, _2473, mad(-0.32480329275131226f, _2470, (_2467 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2496 = min(max((min(max(mad(0.016756348311901093f, _2473, mad(1.6153316497802734f, _2470, (_2467 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2497 = min(max((min(max(mad(0.9883948564529419f, _2473, mad(-0.008284442126750946f, _2470, (_2467 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(output_device == 6)) {
                              _2510 = mad(_53, _2497, mad(_52, _2496, (_2495 * _51)));
                              _2511 = mad(_56, _2497, mad(_55, _2496, (_2495 * _54)));
                              _2512 = mad(_59, _2497, mad(_58, _2496, (_2495 * _57)));
                            } else {
                              _2510 = _2495;
                              _2511 = _2496;
                              _2512 = _2497;
                            }
                            float _2522 = exp2(log2(_2510 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2523 = exp2(log2(_2511 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2524 = exp2(log2(_2512 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2549 = exp2(log2((1.0f / ((_2522 * 18.6875f) + 1.0f)) * ((_2522 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            float _2550 = exp2(log2((1.0f / ((_2523 * 18.6875f) + 1.0f)) * ((_2523 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            float _2551 = exp2(log2((1.0f / ((_2524 * 18.6875f) + 1.0f)) * ((_2524 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            float _2558 = 2000.0f - cb0_039x;
                            float _2562 = saturate((_2549 - cb0_039x) / _2558);
                            float _2563 = saturate((_2550 - cb0_039x) / _2558);
                            float _2564 = saturate((_2551 - cb0_039x) / _2558);
                            float _2565 = 1.0f - _2562;
                            float _2566 = 1.0f - _2563;
                            float _2567 = 1.0f - _2564;
                            float _2571 = _2562 * cb0_039y;
                            float _2572 = _2563 * cb0_039y;
                            float _2573 = _2564 * cb0_039y;
                            _2729 = select((_2549 > cb0_039x), min(((((_2565 * cb0_039x) + _2571) * _2565) + _2571), _2549), _2549);
                            _2730 = select((_2550 > cb0_039x), min(((((_2566 * cb0_039x) + _2572) * _2566) + _2572), _2550), _2550);
                            _2731 = select((_2551 > cb0_039x), min(((((_2567 * cb0_039x) + _2573) * _2567) + _2573), _2551), _2551);
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
          if (output_device == 7) {
            float _2609 = mad((WorkingColorSpace_128[0].z), _967, mad((WorkingColorSpace_128[0].y), _966, ((WorkingColorSpace_128[0].x) * _965)));
            float _2612 = mad((WorkingColorSpace_128[1].z), _967, mad((WorkingColorSpace_128[1].y), _966, ((WorkingColorSpace_128[1].x) * _965)));
            float _2615 = mad((WorkingColorSpace_128[2].z), _967, mad((WorkingColorSpace_128[2].y), _966, ((WorkingColorSpace_128[2].x) * _965)));
            float _2634 = exp2(log2(mad(_53, _2615, mad(_52, _2612, (_2609 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2635 = exp2(log2(mad(_56, _2615, mad(_55, _2612, (_2609 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2636 = exp2(log2(mad(_59, _2615, mad(_58, _2612, (_2609 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2729 = exp2(log2((1.0f / ((_2634 * 18.6875f) + 1.0f)) * ((_2634 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2730 = exp2(log2((1.0f / ((_2635 * 18.6875f) + 1.0f)) * ((_2635 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2731 = exp2(log2((1.0f / ((_2636 * 18.6875f) + 1.0f)) * ((_2636 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2683 = mad((WorkingColorSpace_128[0].z), _955, mad((WorkingColorSpace_128[0].y), _954, ((WorkingColorSpace_128[0].x) * _953)));
                float _2686 = mad((WorkingColorSpace_128[1].z), _955, mad((WorkingColorSpace_128[1].y), _954, ((WorkingColorSpace_128[1].x) * _953)));
                float _2689 = mad((WorkingColorSpace_128[2].z), _955, mad((WorkingColorSpace_128[2].y), _954, ((WorkingColorSpace_128[2].x) * _953)));
                _2729 = mad(_53, _2689, mad(_52, _2686, (_2683 * _51)));
                _2730 = mad(_56, _2689, mad(_55, _2686, (_2683 * _54)));
                _2731 = mad(_59, _2689, mad(_58, _2686, (_2683 * _57)));
              } else {
                float _2702 = mad((WorkingColorSpace_128[0].z), _981, mad((WorkingColorSpace_128[0].y), _980, ((WorkingColorSpace_128[0].x) * _979)));
                float _2705 = mad((WorkingColorSpace_128[1].z), _981, mad((WorkingColorSpace_128[1].y), _980, ((WorkingColorSpace_128[1].x) * _979)));
                float _2708 = mad((WorkingColorSpace_128[2].z), _981, mad((WorkingColorSpace_128[2].y), _980, ((WorkingColorSpace_128[2].x) * _979)));
                _2729 = exp2(log2(mad(_53, _2708, mad(_52, _2705, (_2702 * _51)))) * cb0_041z);
                _2730 = exp2(log2(mad(_56, _2708, mad(_55, _2705, (_2702 * _54)))) * cb0_041z);
                _2731 = exp2(log2(mad(_59, _2708, mad(_58, _2705, (_2702 * _57)))) * cb0_041z);
              }
            } else {
              _2729 = _965;
              _2730 = _966;
              _2731 = _967;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2729 * 0.9523810148239136f);
  SV_Target.y = (_2730 * 0.9523810148239136f);
  SV_Target.z = (_2731 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
