#include "../../common.hlsl"

cbuffer cb0 : register(b0) {
  float cb0_008x : packoffset(c008.x);
  float cb0_008y : packoffset(c008.y);
  float cb0_008z : packoffset(c008.z);
  float cb0_008w : packoffset(c008.w);
  float cb0_009x : packoffset(c009.x);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
  float cb0_012x : packoffset(c012.x);
  float cb0_012y : packoffset(c012.y);
  float cb0_012z : packoffset(c012.z);
  float cb0_012w : packoffset(c012.w);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
  float cb0_017x : packoffset(c017.x);
  float cb0_017y : packoffset(c017.y);
  float cb0_017z : packoffset(c017.z);
  float cb0_017w : packoffset(c017.w);
  float cb0_018x : packoffset(c018.x);
  float cb0_018y : packoffset(c018.y);
  float cb0_018z : packoffset(c018.z);
  float cb0_018w : packoffset(c018.w);
  float cb0_019x : packoffset(c019.x);
  float cb0_019y : packoffset(c019.y);
  float cb0_019z : packoffset(c019.z);
  float cb0_019w : packoffset(c019.w);
  float cb0_020x : packoffset(c020.x);
  float cb0_020y : packoffset(c020.y);
  float cb0_020z : packoffset(c020.z);
  float cb0_020w : packoffset(c020.w);
  float cb0_021x : packoffset(c021.x);
  float cb0_021y : packoffset(c021.y);
  float cb0_021z : packoffset(c021.z);
  float cb0_021w : packoffset(c021.w);
  float cb0_022x : packoffset(c022.x);
  float cb0_022y : packoffset(c022.y);
  float cb0_022z : packoffset(c022.z);
  float cb0_022w : packoffset(c022.w);
  float cb0_023x : packoffset(c023.x);
  float cb0_023y : packoffset(c023.y);
  float cb0_023z : packoffset(c023.z);
  float cb0_023w : packoffset(c023.w);
  float cb0_024x : packoffset(c024.x);
  float cb0_024y : packoffset(c024.y);
  float cb0_024z : packoffset(c024.z);
  float cb0_024w : packoffset(c024.w);
  float cb0_025x : packoffset(c025.x);
  float cb0_025y : packoffset(c025.y);
  float cb0_025z : packoffset(c025.z);
  float cb0_025w : packoffset(c025.w);
  float cb0_026x : packoffset(c026.x);
  float cb0_026y : packoffset(c026.y);
  float cb0_026z : packoffset(c026.z);
  float cb0_026w : packoffset(c026.w);
  float cb0_027x : packoffset(c027.x);
  float cb0_027y : packoffset(c027.y);
  float cb0_027z : packoffset(c027.z);
  float cb0_027w : packoffset(c027.w);
  float cb0_028x : packoffset(c028.x);
  float cb0_028y : packoffset(c028.y);
  float cb0_028z : packoffset(c028.z);
  float cb0_028w : packoffset(c028.w);
  float cb0_029x : packoffset(c029.x);
  float cb0_029y : packoffset(c029.y);
  float cb0_029z : packoffset(c029.z);
  float cb0_029w : packoffset(c029.w);
  float cb0_030x : packoffset(c030.x);
  float cb0_030y : packoffset(c030.y);
  float cb0_030z : packoffset(c030.z);
  float cb0_030w : packoffset(c030.w);
  float cb0_031x : packoffset(c031.x);
  float cb0_031y : packoffset(c031.y);
  float cb0_031z : packoffset(c031.z);
  float cb0_031w : packoffset(c031.w);
  float cb0_032x : packoffset(c032.x);
  float cb0_032y : packoffset(c032.y);
  float cb0_032z : packoffset(c032.z);
  float cb0_032w : packoffset(c032.w);
  float cb0_033x : packoffset(c033.x);
  float cb0_033y : packoffset(c033.y);
  float cb0_033z : packoffset(c033.z);
  float cb0_033w : packoffset(c033.w);
  float cb0_034x : packoffset(c034.x);
  float cb0_034y : packoffset(c034.y);
  float cb0_034z : packoffset(c034.z);
  float cb0_034w : packoffset(c034.w);
  float cb0_035x : packoffset(c035.x);
  float cb0_035y : packoffset(c035.y);
  float cb0_035z : packoffset(c035.z);
  float cb0_035w : packoffset(c035.w);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  float cb0_038z : packoffset(c038.z);
  float cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_039w : packoffset(c039.w);
  float cb0_040x : packoffset(c040.x);
  float cb0_040y : packoffset(c040.y);
  int cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  int cb0_042w : packoffset(c042.w);
  int cb0_043x : packoffset(c043.x);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  float4 WorkingColorSpace_320[4] : packoffset(c020.x);
  int WorkingColorSpace_384 : packoffset(c024.x);
};

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
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
  float _22 = 0.5f / cb0_037x;
  float _27 = cb0_037x + -1.0f;
  float _28 = (cb0_037x * (TEXCOORD.x - _22)) / _27;
  float _29 = (cb0_037x * (TEXCOORD.y - _22)) / _27;
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
  float _174;
  float _381;
  float _382;
  float _383;
  float _906;
  float _939;
  float _953;
  float _1017;
  float _1285;
  float _1286;
  float _1287;
  float _1298;
  float _1309;
  float _1478;
  float _1493;
  float _1508;
  float _1516;
  float _1517;
  float _1518;
  float _1585;
  float _1618;
  float _1632;
  float _1671;
  float _1793;
  float _1879;
  float _1953;
  float _2158;
  float _2173;
  float _2188;
  float _2196;
  float _2197;
  float _2198;
  float _2265;
  float _2298;
  float _2312;
  float _2351;
  float _2473;
  float _2559;
  float _2645;
  float _2860;
  float _2861;
  float _2862;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        bool _40 = (cb0_043x == 4);
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
  if ((uint)cb0_042w > (uint)2) {
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
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _381 = _117;
      _382 = _118;
      _383 = _119;
      float _398 = mad((WorkingColorSpace_128[0].z), _383, mad((WorkingColorSpace_128[0].y), _382, ((WorkingColorSpace_128[0].x) * _381)));
      float _401 = mad((WorkingColorSpace_128[1].z), _383, mad((WorkingColorSpace_128[1].y), _382, ((WorkingColorSpace_128[1].x) * _381)));
      float _404 = mad((WorkingColorSpace_128[2].z), _383, mad((WorkingColorSpace_128[2].y), _382, ((WorkingColorSpace_128[2].x) * _381)));
      SetUngradedAP1(float3(_398, _401, _404));

      float _405 = dot(float3(_398, _401, _404), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _409 = (_398 / _405) + -1.0f;
      float _410 = (_401 / _405) + -1.0f;
      float _411 = (_404 / _405) + -1.0f;
      float _423 = (1.0f - exp2(((_405 * _405) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_409, _410, _411), float3(_409, _410, _411)) * -4.0f));
      float _439 = ((mad(-0.06368321925401688f, _404, mad(-0.3292922377586365f, _401, (_398 * 1.3704125881195068f))) - _398) * _423) + _398;
      float _440 = ((mad(-0.010861365124583244f, _404, mad(1.0970927476882935f, _401, (_398 * -0.08343357592821121f))) - _401) * _423) + _401;
      float _441 = ((mad(1.2036951780319214f, _404, mad(-0.09862580895423889f, _401, (_398 * -0.02579331398010254f))) - _404) * _423) + _404;
      float _442 = dot(float3(_439, _440, _441), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _456 = cb0_021w + cb0_026w;
      float _470 = cb0_020w * cb0_025w;
      float _484 = cb0_019w * cb0_024w;
      float _498 = cb0_018w * cb0_023w;
      float _512 = cb0_017w * cb0_022w;
      float _516 = _439 - _442;
      float _517 = _440 - _442;
      float _518 = _441 - _442;
      float _575 = saturate(_442 / cb0_037w);
      float _579 = (_575 * _575) * (3.0f - (_575 * 2.0f));
      float _580 = 1.0f - _579;
      float _589 = cb0_021w + cb0_036w;
      float _598 = cb0_020w * cb0_035w;
      float _607 = cb0_019w * cb0_034w;
      float _616 = cb0_018w * cb0_033w;
      float _625 = cb0_017w * cb0_032w;
      float _688 = saturate((_442 - cb0_038x) / (cb0_038y - cb0_038x));
      float _692 = (_688 * _688) * (3.0f - (_688 * 2.0f));
      float _701 = cb0_021w + cb0_031w;
      float _710 = cb0_020w * cb0_030w;
      float _719 = cb0_019w * cb0_029w;
      float _728 = cb0_018w * cb0_028w;
      float _737 = cb0_017w * cb0_027w;
      float _795 = _579 - _692;
      float _806 = ((_692 * (((cb0_021x + cb0_036x) + _589) + (((cb0_020x * cb0_035x) * _598) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _616) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _625) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _607)))))) + (_580 * (((cb0_021x + cb0_026x) + _456) + (((cb0_020x * cb0_025x) * _470) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _498) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _512) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _484))))))) + ((((cb0_021x + cb0_031x) + _701) + (((cb0_020x * cb0_030x) * _710) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _728) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _737) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _719))))) * _795);
      float _808 = ((_692 * (((cb0_021y + cb0_036y) + _589) + (((cb0_020y * cb0_035y) * _598) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _616) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _625) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _607)))))) + (_580 * (((cb0_021y + cb0_026y) + _456) + (((cb0_020y * cb0_025y) * _470) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _498) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _512) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _484))))))) + ((((cb0_021y + cb0_031y) + _701) + (((cb0_020y * cb0_030y) * _710) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _728) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _737) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _719))))) * _795);
      float _810 = ((_692 * (((cb0_021z + cb0_036z) + _589) + (((cb0_020z * cb0_035z) * _598) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _616) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _625) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _607)))))) + (_580 * (((cb0_021z + cb0_026z) + _456) + (((cb0_020z * cb0_025z) * _470) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _498) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _512) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _484))))))) + ((((cb0_021z + cb0_031z) + _701) + (((cb0_020z * cb0_030z) * _710) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _728) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _737) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _719))))) * _795);
      SetUntonemappedAP1(float3(_806, _808, _810));

      float _846 = ((mad(0.061360642313957214f, _810, mad(-4.540197551250458e-09f, _808, (_806 * 0.9386394023895264f))) - _806) * cb0_038z) + _806;
      float _847 = ((mad(0.169205904006958f, _810, mad(0.8307942152023315f, _808, (_806 * 6.775371730327606e-08f))) - _808) * cb0_038z) + _808;
      float _848 = (mad(-2.3283064365386963e-10f, _808, (_806 * -9.313225746154785e-10f)) * cb0_038z) + _810;
      float _851 = mad(0.16386905312538147f, _848, mad(0.14067868888378143f, _847, (_846 * 0.6954522132873535f)));
      float _854 = mad(0.0955343246459961f, _848, mad(0.8596711158752441f, _847, (_846 * 0.044794581830501556f)));
      float _857 = mad(1.0015007257461548f, _848, mad(0.004025210160762072f, _847, (_846 * -0.005525882821530104f)));
      float _861 = max(max(_851, _854), _857);
      float _866 = (max(_861, 1.000000013351432e-10f) - max(min(min(_851, _854), _857), 1.000000013351432e-10f)) / max(_861, 0.009999999776482582f);
      float _879 = ((_854 + _851) + _857) + (sqrt((((_857 - _854) * _857) + ((_854 - _851) * _854)) + ((_851 - _857) * _851)) * 1.75f);
      float _880 = _879 * 0.3333333432674408f;
      float _881 = _866 + -0.4000000059604645f;
      float _882 = _881 * 5.0f;
      float _886 = max((1.0f - abs(_881 * 2.5f)), 0.0f);
      float _897 = ((float((int)(((int)(uint)((bool)(_882 > 0.0f))) - ((int)(uint)((bool)(_882 < 0.0f))))) * (1.0f - (_886 * _886))) + 1.0f) * 0.02500000037252903f;
      do {
        if (!(_880 <= 0.0533333346247673f)) {
          if (!(_880 >= 0.1599999964237213f)) {
            _906 = (((0.23999999463558197f / _879) + -0.5f) * _897);
          } else {
            _906 = 0.0f;
          }
        } else {
          _906 = _897;
        }
        float _907 = _906 + 1.0f;
        float _908 = _907 * _851;
        float _909 = _907 * _854;
        float _910 = _907 * _857;
        do {
          if (!((bool)(_908 == _909) && (bool)(_909 == _910))) {
            float _917 = ((_908 * 2.0f) - _909) - _910;
            float _920 = ((_854 - _857) * 1.7320507764816284f) * _907;
            float _922 = atan(_920 / _917);
            bool _925 = (_917 < 0.0f);
            bool _926 = (_917 == 0.0f);
            bool _927 = (_920 >= 0.0f);
            bool _928 = (_920 < 0.0f);
            _939 = select((_927 && _926), 90.0f, select((_928 && _926), -90.0f, (select((_928 && _925), (_922 + -3.1415927410125732f), select((_927 && _925), (_922 + 3.1415927410125732f), _922)) * 57.2957763671875f)));
          } else {
            _939 = 0.0f;
          }
          float _944 = min(max(select((_939 < 0.0f), (_939 + 360.0f), _939), 0.0f), 360.0f);
          do {
            if (_944 < -180.0f) {
              _953 = (_944 + 360.0f);
            } else {
              if (_944 > 180.0f) {
                _953 = (_944 + -360.0f);
              } else {
                _953 = _944;
              }
            }
            float _957 = saturate(1.0f - abs(_953 * 0.014814814552664757f));
            float _961 = (_957 * _957) * (3.0f - (_957 * 2.0f));
            float _967 = ((_961 * _961) * ((_866 * 0.18000000715255737f) * (0.029999999329447746f - _908))) + _908;
            float _977 = max(0.0f, mad(-0.21492856740951538f, _910, mad(-0.2365107536315918f, _909, (_967 * 1.4514392614364624f))));
            float _978 = max(0.0f, mad(-0.09967592358589172f, _910, mad(1.17622971534729f, _909, (_967 * -0.07655377686023712f))));
            float _979 = max(0.0f, mad(0.9977163076400757f, _910, mad(-0.006032449658960104f, _909, (_967 * 0.008316148072481155f))));
            float _980 = dot(float3(_977, _978, _979), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _995 = (cb0_040x + 1.0f) - cb0_039z;
            float _997 = cb0_040y + 1.0f;
            float _999 = _997 - cb0_039w;
            do {
              if (cb0_039z > 0.800000011920929f) {
                _1017 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
              } else {
                float _1008 = (cb0_040x + 0.18000000715255737f) / _995;
                _1017 = (-0.7447274923324585f - ((log2(_1008 / (2.0f - _1008)) * 0.3465735912322998f) * (_995 / cb0_039y)));
              }
              float _1020 = ((1.0f - cb0_039z) / cb0_039y) - _1017;
              float _1022 = (cb0_039w / cb0_039y) - _1020;
              float _1026 = log2(lerp(_980, _977, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1027 = log2(lerp(_980, _978, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1028 = log2(lerp(_980, _979, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1032 = cb0_039y * (_1026 + _1020);
              float _1033 = cb0_039y * (_1027 + _1020);
              float _1034 = cb0_039y * (_1028 + _1020);
              float _1035 = _995 * 2.0f;
              float _1037 = (cb0_039y * -2.0f) / _995;
              float _1038 = _1026 - _1017;
              float _1039 = _1027 - _1017;
              float _1040 = _1028 - _1017;
              float _1059 = _999 * 2.0f;
              float _1061 = (cb0_039y * 2.0f) / _999;
              float _1086 = select((_1026 < _1017), ((_1035 / (exp2((_1038 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1032);
              float _1087 = select((_1027 < _1017), ((_1035 / (exp2((_1039 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1033);
              float _1088 = select((_1028 < _1017), ((_1035 / (exp2((_1040 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1034);
              float _1095 = _1022 - _1017;
              float _1099 = saturate(_1038 / _1095);
              float _1100 = saturate(_1039 / _1095);
              float _1101 = saturate(_1040 / _1095);
              bool _1102 = (_1022 < _1017);
              float _1106 = select(_1102, (1.0f - _1099), _1099);
              float _1107 = select(_1102, (1.0f - _1100), _1100);
              float _1108 = select(_1102, (1.0f - _1101), _1101);
              float _1127 = (((_1106 * _1106) * (select((_1026 > _1022), (_997 - (_1059 / (exp2(((_1026 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1032) - _1086)) * (3.0f - (_1106 * 2.0f))) + _1086;
              float _1128 = (((_1107 * _1107) * (select((_1027 > _1022), (_997 - (_1059 / (exp2(((_1027 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
              float _1129 = (((_1108 * _1108) * (select((_1028 > _1022), (_997 - (_1059 / (exp2(((_1028 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
              float _1130 = dot(float3(_1127, _1128, _1129), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _1150 = (cb0_039x * (max(0.0f, (lerp(_1130, _1127, 0.9300000071525574f))) - _846)) + _846;
              float _1151 = (cb0_039x * (max(0.0f, (lerp(_1130, _1128, 0.9300000071525574f))) - _847)) + _847;
              float _1152 = (cb0_039x * (max(0.0f, (lerp(_1130, _1129, 0.9300000071525574f))) - _848)) + _848;
              float _1168 = ((mad(-0.06537103652954102f, _1152, mad(1.451815478503704e-06f, _1151, (_1150 * 1.065374732017517f))) - _1150) * cb0_038z) + _1150;
              float _1169 = ((mad(-0.20366770029067993f, _1152, mad(1.2036634683609009f, _1151, (_1150 * -2.57161445915699e-07f))) - _1151) * cb0_038z) + _1151;
              float _1170 = ((mad(0.9999996423721313f, _1152, mad(2.0954757928848267e-08f, _1151, (_1150 * 1.862645149230957e-08f))) - _1152) * cb0_038z) + _1152;
              SetTonemappedAP1(_1168, _1169, _1170);

              float _1180 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1170, mad((WorkingColorSpace_192[0].y), _1169, ((WorkingColorSpace_192[0].x) * _1168))));
              float _1181 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1170, mad((WorkingColorSpace_192[1].y), _1169, ((WorkingColorSpace_192[1].x) * _1168))));
              float _1182 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1170, mad((WorkingColorSpace_192[2].y), _1169, ((WorkingColorSpace_192[2].x) * _1168))));
              float _1208 = cb0_016x * (((cb0_041y + (cb0_041x * _1180)) * _1180) + cb0_041z);
              float _1209 = cb0_016y * (((cb0_041y + (cb0_041x * _1181)) * _1181) + cb0_041z);
              float _1210 = cb0_016z * (((cb0_041y + (cb0_041x * _1182)) * _1182) + cb0_041z);
              float _1217 = ((cb0_015x - _1208) * cb0_015w) + _1208;
              float _1218 = ((cb0_015y - _1209) * cb0_015w) + _1209;
              float _1219 = ((cb0_015z - _1210) * cb0_015w) + _1210;
              float _1220 = cb0_016x * mad((WorkingColorSpace_192[0].z), _810, mad((WorkingColorSpace_192[0].y), _808, (_806 * (WorkingColorSpace_192[0].x))));
              float _1221 = cb0_016y * mad((WorkingColorSpace_192[1].z), _810, mad((WorkingColorSpace_192[1].y), _808, ((WorkingColorSpace_192[1].x) * _806)));
              float _1222 = cb0_016z * mad((WorkingColorSpace_192[2].z), _810, mad((WorkingColorSpace_192[2].y), _808, ((WorkingColorSpace_192[2].x) * _806)));
              float _1229 = ((cb0_015x - _1220) * cb0_015w) + _1220;
              float _1230 = ((cb0_015y - _1221) * cb0_015w) + _1221;
              float _1231 = ((cb0_015z - _1222) * cb0_015w) + _1222;
              float _1243 = exp2(log2(max(0.0f, _1217)) * cb0_042y);
              float _1244 = exp2(log2(max(0.0f, _1218)) * cb0_042y);
              float _1245 = exp2(log2(max(0.0f, _1219)) * cb0_042y);

              if (RENODX_TONE_MAP_TYPE != 0.f) {
                return GenerateOutput(float3(_1243, _1244, _1245), cb0_042w);
              }
              do {
                [branch]
                if (cb0_042w == 0) {
                  do {
                    if (WorkingColorSpace_384 == 0) {
                      float _1268 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
                      float _1271 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
                      float _1274 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
                      _1285 = mad(_53, _1274, mad(_52, _1271, (_1268 * _51)));
                      _1286 = mad(_56, _1274, mad(_55, _1271, (_1268 * _54)));
                      _1287 = mad(_59, _1274, mad(_58, _1271, (_1268 * _57)));
                    } else {
                      _1285 = _1243;
                      _1286 = _1244;
                      _1287 = _1245;
                    }
                    do {
                      if (_1285 < 0.0031306699384003878f) {
                        _1298 = (_1285 * 12.920000076293945f);
                      } else {
                        _1298 = (((pow(_1285, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        if (_1286 < 0.0031306699384003878f) {
                          _1309 = (_1286 * 12.920000076293945f);
                        } else {
                          _1309 = (((pow(_1286, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        if (_1287 < 0.0031306699384003878f) {
                          _2860 = _1298;
                          _2861 = _1309;
                          _2862 = (_1287 * 12.920000076293945f);
                        } else {
                          _2860 = _1298;
                          _2861 = _1309;
                          _2862 = (((pow(_1287, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  if (cb0_042w == 1) {
                    float _1336 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
                    float _1339 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
                    float _1342 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
                    float _1345 = mad(_53, _1342, mad(_52, _1339, (_1336 * _51)));
                    float _1348 = mad(_56, _1342, mad(_55, _1339, (_1336 * _54)));
                    float _1351 = mad(_59, _1342, mad(_58, _1339, (_1336 * _57)));
                    _2860 = min((_1345 * 4.5f), ((exp2(log2(max(_1345, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                    _2861 = min((_1348 * 4.5f), ((exp2(log2(max(_1348, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                    _2862 = min((_1351 * 4.5f), ((exp2(log2(max(_1351, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                  } else {
                    if ((uint)((uint)((int)(cb0_042w) + -3u)) < (uint)2) {
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
                      float _1426 = cb0_012z * _1229;
                      float _1427 = cb0_012z * _1230;
                      float _1428 = cb0_012z * _1231;
                      float _1431 = mad((WorkingColorSpace_256[0].z), _1428, mad((WorkingColorSpace_256[0].y), _1427, ((WorkingColorSpace_256[0].x) * _1426)));
                      float _1434 = mad((WorkingColorSpace_256[1].z), _1428, mad((WorkingColorSpace_256[1].y), _1427, ((WorkingColorSpace_256[1].x) * _1426)));
                      float _1437 = mad((WorkingColorSpace_256[2].z), _1428, mad((WorkingColorSpace_256[2].y), _1427, ((WorkingColorSpace_256[2].x) * _1426)));
                      float _1440 = mad(-0.21492856740951538f, _1437, mad(-0.2365107536315918f, _1434, (_1431 * 1.4514392614364624f)));
                      float _1443 = mad(-0.09967592358589172f, _1437, mad(1.17622971534729f, _1434, (_1431 * -0.07655377686023712f)));
                      float _1446 = mad(0.9977163076400757f, _1437, mad(-0.006032449658960104f, _1434, (_1431 * 0.008316148072481155f)));
                      float _1448 = max(_1440, max(_1443, _1446));
                      do {
                        if (!(_1448 < 1.000000013351432e-10f)) {
                          if (!(((bool)((bool)(_1431 < 0.0f) || (bool)(_1434 < 0.0f))) || (bool)(_1437 < 0.0f))) {
                            float _1458 = abs(_1448);
                            float _1459 = (_1448 - _1440) / _1458;
                            float _1461 = (_1448 - _1443) / _1458;
                            float _1463 = (_1448 - _1446) / _1458;
                            do {
                              if (!(_1459 < 0.8149999976158142f)) {
                                float _1466 = _1459 + -0.8149999976158142f;
                                _1478 = ((_1466 / exp2(log2(exp2(log2(_1466 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                              } else {
                                _1478 = _1459;
                              }
                              do {
                                if (!(_1461 < 0.8029999732971191f)) {
                                  float _1481 = _1461 + -0.8029999732971191f;
                                  _1493 = ((_1481 / exp2(log2(exp2(log2(_1481 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                } else {
                                  _1493 = _1461;
                                }
                                do {
                                  if (!(_1463 < 0.8799999952316284f)) {
                                    float _1496 = _1463 + -0.8799999952316284f;
                                    _1508 = ((_1496 / exp2(log2(exp2(log2(_1496 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                  } else {
                                    _1508 = _1463;
                                  }
                                  _1516 = (_1448 - (_1458 * _1478));
                                  _1517 = (_1448 - (_1458 * _1493));
                                  _1518 = (_1448 - (_1458 * _1508));
                                } while (false);
                              } while (false);
                            } while (false);
                          } else {
                            _1516 = _1440;
                            _1517 = _1443;
                            _1518 = _1446;
                          }
                        } else {
                          _1516 = _1440;
                          _1517 = _1443;
                          _1518 = _1446;
                        }
                        float _1534 = ((mad(0.16386906802654266f, _1518, mad(0.14067870378494263f, _1517, (_1516 * 0.6954522132873535f))) - _1431) * cb0_012w) + _1431;
                        float _1535 = ((mad(0.0955343171954155f, _1518, mad(0.8596711158752441f, _1517, (_1516 * 0.044794563204050064f))) - _1434) * cb0_012w) + _1434;
                        float _1536 = ((mad(1.0015007257461548f, _1518, mad(0.004025210160762072f, _1517, (_1516 * -0.005525882821530104f))) - _1437) * cb0_012w) + _1437;
                        float _1540 = max(max(_1534, _1535), _1536);
                        float _1545 = (max(_1540, 1.000000013351432e-10f) - max(min(min(_1534, _1535), _1536), 1.000000013351432e-10f)) / max(_1540, 0.009999999776482582f);
                        float _1558 = ((_1535 + _1534) + _1536) + (sqrt((((_1536 - _1535) * _1536) + ((_1535 - _1534) * _1535)) + ((_1534 - _1536) * _1534)) * 1.75f);
                        float _1559 = _1558 * 0.3333333432674408f;
                        float _1560 = _1545 + -0.4000000059604645f;
                        float _1561 = _1560 * 5.0f;
                        float _1565 = max((1.0f - abs(_1560 * 2.5f)), 0.0f);
                        float _1576 = ((float((int)(((int)(uint)((bool)(_1561 > 0.0f))) - ((int)(uint)((bool)(_1561 < 0.0f))))) * (1.0f - (_1565 * _1565))) + 1.0f) * 0.02500000037252903f;
                        do {
                          if (!(_1559 <= 0.0533333346247673f)) {
                            if (!(_1559 >= 0.1599999964237213f)) {
                              _1585 = (((0.23999999463558197f / _1558) + -0.5f) * _1576);
                            } else {
                              _1585 = 0.0f;
                            }
                          } else {
                            _1585 = _1576;
                          }
                          float _1586 = _1585 + 1.0f;
                          float _1587 = _1586 * _1534;
                          float _1588 = _1586 * _1535;
                          float _1589 = _1586 * _1536;
                          do {
                            if (!((bool)(_1587 == _1588) && (bool)(_1588 == _1589))) {
                              float _1596 = ((_1587 * 2.0f) - _1588) - _1589;
                              float _1599 = ((_1535 - _1536) * 1.7320507764816284f) * _1586;
                              float _1601 = atan(_1599 / _1596);
                              bool _1604 = (_1596 < 0.0f);
                              bool _1605 = (_1596 == 0.0f);
                              bool _1606 = (_1599 >= 0.0f);
                              bool _1607 = (_1599 < 0.0f);
                              _1618 = select((_1606 && _1605), 90.0f, select((_1607 && _1605), -90.0f, (select((_1607 && _1604), (_1601 + -3.1415927410125732f), select((_1606 && _1604), (_1601 + 3.1415927410125732f), _1601)) * 57.2957763671875f)));
                            } else {
                              _1618 = 0.0f;
                            }
                            float _1623 = min(max(select((_1618 < 0.0f), (_1618 + 360.0f), _1618), 0.0f), 360.0f);
                            do {
                              if (_1623 < -180.0f) {
                                _1632 = (_1623 + 360.0f);
                              } else {
                                if (_1623 > 180.0f) {
                                  _1632 = (_1623 + -360.0f);
                                } else {
                                  _1632 = _1623;
                                }
                              }
                              do {
                                if ((bool)(_1632 > -67.5f) && (bool)(_1632 < 67.5f)) {
                                  float _1638 = (_1632 + 67.5f) * 0.029629629105329514f;
                                  int _1639 = int(_1638);
                                  float _1641 = _1638 - float((int)(_1639));
                                  float _1642 = _1641 * _1641;
                                  float _1643 = _1642 * _1641;
                                  if (_1639 == 3) {
                                    _1671 = (((0.1666666716337204f - (_1641 * 0.5f)) + (_1642 * 0.5f)) - (_1643 * 0.1666666716337204f));
                                  } else {
                                    if (_1639 == 2) {
                                      _1671 = ((0.6666666865348816f - _1642) + (_1643 * 0.5f));
                                    } else {
                                      if (_1639 == 1) {
                                        _1671 = (((_1643 * -0.5f) + 0.1666666716337204f) + ((_1642 + _1641) * 0.5f));
                                      } else {
                                        _1671 = select((_1639 == 0), (_1643 * 0.1666666716337204f), 0.0f);
                                      }
                                    }
                                  }
                                } else {
                                  _1671 = 0.0f;
                                }
                                float _1680 = min(max(((((_1545 * 0.27000001072883606f) * (0.029999999329447746f - _1587)) * _1671) + _1587), 0.0f), 65535.0f);
                                float _1681 = min(max(_1588, 0.0f), 65535.0f);
                                float _1682 = min(max(_1589, 0.0f), 65535.0f);
                                float _1695 = min(max(mad(-0.21492856740951538f, _1682, mad(-0.2365107536315918f, _1681, (_1680 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                float _1696 = min(max(mad(-0.09967592358589172f, _1682, mad(1.17622971534729f, _1681, (_1680 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                float _1697 = min(max(mad(0.9977163076400757f, _1682, mad(-0.006032449658960104f, _1681, (_1680 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                float _1698 = dot(float3(_1695, _1696, _1697), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                float _1721 = log2(max((lerp(_1698, _1695, 0.9599999785423279f)), 1.000000013351432e-10f));
                                float _1722 = _1721 * 0.3010300099849701f;
                                float _1723 = log2(cb0_008x);
                                float _1724 = _1723 * 0.3010300099849701f;
                                do {
                                  if (!(!(_1722 <= _1724))) {
                                    _1793 = (log2(cb0_008y) * 0.3010300099849701f);
                                  } else {
                                    float _1731 = log2(cb0_009x);
                                    float _1732 = _1731 * 0.3010300099849701f;
                                    if ((bool)(_1722 > _1724) && (bool)(_1722 < _1732)) {
                                      float _1740 = ((_1721 - _1723) * 0.9030900001525879f) / ((_1731 - _1723) * 0.3010300099849701f);
                                      int _1741 = int(_1740);
                                      float _1743 = _1740 - float((int)(_1741));
                                      float _1745 = _16[_1741];
                                      float _1748 = _16[(_1741 + 1)];
                                      float _1753 = _1745 * 0.5f;
                                      _1793 = dot(float3((_1743 * _1743), _1743, 1.0f), float3(mad((_16[(_1741 + 2)]), 0.5f, mad(_1748, -1.0f, _1753)), (_1748 - _1745), mad(_1748, 0.5f, _1753)));
                                    } else {
                                      do {
                                        if (!(!(_1722 >= _1732))) {
                                          float _1762 = log2(cb0_008z);
                                          if (_1722 < (_1762 * 0.3010300099849701f)) {
                                            float _1770 = ((_1721 - _1731) * 0.9030900001525879f) / ((_1762 - _1731) * 0.3010300099849701f);
                                            int _1771 = int(_1770);
                                            float _1773 = _1770 - float((int)(_1771));
                                            float _1775 = _17[_1771];
                                            float _1778 = _17[(_1771 + 1)];
                                            float _1783 = _1775 * 0.5f;
                                            _1793 = dot(float3((_1773 * _1773), _1773, 1.0f), float3(mad((_17[(_1771 + 2)]), 0.5f, mad(_1778, -1.0f, _1783)), (_1778 - _1775), mad(_1778, 0.5f, _1783)));
                                            break;
                                          }
                                        }
                                        _1793 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                  float _1809 = log2(max((lerp(_1698, _1696, 0.9599999785423279f)), 1.000000013351432e-10f));
                                  float _1810 = _1809 * 0.3010300099849701f;
                                  do {
                                    if (!(!(_1810 <= _1724))) {
                                      _1879 = (log2(cb0_008y) * 0.3010300099849701f);
                                    } else {
                                      float _1817 = log2(cb0_009x);
                                      float _1818 = _1817 * 0.3010300099849701f;
                                      if ((bool)(_1810 > _1724) && (bool)(_1810 < _1818)) {
                                        float _1826 = ((_1809 - _1723) * 0.9030900001525879f) / ((_1817 - _1723) * 0.3010300099849701f);
                                        int _1827 = int(_1826);
                                        float _1829 = _1826 - float((int)(_1827));
                                        float _1831 = _18[_1827];
                                        float _1834 = _18[(_1827 + 1)];
                                        float _1839 = _1831 * 0.5f;
                                        _1879 = dot(float3((_1829 * _1829), _1829, 1.0f), float3(mad((_18[(_1827 + 2)]), 0.5f, mad(_1834, -1.0f, _1839)), (_1834 - _1831), mad(_1834, 0.5f, _1839)));
                                      } else {
                                        do {
                                          if (!(!(_1810 >= _1818))) {
                                            float _1848 = log2(cb0_008z);
                                            if (_1810 < (_1848 * 0.3010300099849701f)) {
                                              float _1856 = ((_1809 - _1817) * 0.9030900001525879f) / ((_1848 - _1817) * 0.3010300099849701f);
                                              int _1857 = int(_1856);
                                              float _1859 = _1856 - float((int)(_1857));
                                              float _1861 = _19[_1857];
                                              float _1864 = _19[(_1857 + 1)];
                                              float _1869 = _1861 * 0.5f;
                                              _1879 = dot(float3((_1859 * _1859), _1859, 1.0f), float3(mad((_19[(_1857 + 2)]), 0.5f, mad(_1864, -1.0f, _1869)), (_1864 - _1861), mad(_1864, 0.5f, _1869)));
                                              break;
                                            }
                                          }
                                          _1879 = (log2(cb0_008w) * 0.3010300099849701f);
                                        } while (false);
                                      }
                                    }
                                    float _1883 = log2(max((lerp(_1698, _1697, 0.9599999785423279f)), 1.000000013351432e-10f));
                                    float _1884 = _1883 * 0.3010300099849701f;
                                    do {
                                      if (!(!(_1884 <= _1724))) {
                                        _1953 = (log2(cb0_008y) * 0.3010300099849701f);
                                      } else {
                                        float _1891 = log2(cb0_009x);
                                        float _1892 = _1891 * 0.3010300099849701f;
                                        if ((bool)(_1884 > _1724) && (bool)(_1884 < _1892)) {
                                          float _1900 = ((_1883 - _1723) * 0.9030900001525879f) / ((_1891 - _1723) * 0.3010300099849701f);
                                          int _1901 = int(_1900);
                                          float _1903 = _1900 - float((int)(_1901));
                                          float _1905 = _8[_1901];
                                          float _1908 = _8[(_1901 + 1)];
                                          float _1913 = _1905 * 0.5f;
                                          _1953 = dot(float3((_1903 * _1903), _1903, 1.0f), float3(mad((_8[(_1901 + 2)]), 0.5f, mad(_1908, -1.0f, _1913)), (_1908 - _1905), mad(_1908, 0.5f, _1913)));
                                        } else {
                                          do {
                                            if (!(!(_1884 >= _1892))) {
                                              float _1922 = log2(cb0_008z);
                                              if (_1884 < (_1922 * 0.3010300099849701f)) {
                                                float _1930 = ((_1883 - _1891) * 0.9030900001525879f) / ((_1922 - _1891) * 0.3010300099849701f);
                                                int _1931 = int(_1930);
                                                float _1933 = _1930 - float((int)(_1931));
                                                float _1935 = _9[_1931];
                                                float _1938 = _9[(_1931 + 1)];
                                                float _1943 = _1935 * 0.5f;
                                                _1953 = dot(float3((_1933 * _1933), _1933, 1.0f), float3(mad((_9[(_1931 + 2)]), 0.5f, mad(_1938, -1.0f, _1943)), (_1938 - _1935), mad(_1938, 0.5f, _1943)));
                                                break;
                                              }
                                            }
                                            _1953 = (log2(cb0_008w) * 0.3010300099849701f);
                                          } while (false);
                                        }
                                      }
                                      float _1957 = cb0_008w - cb0_008y;
                                      float _1958 = (exp2(_1793 * 3.321928024291992f) - cb0_008y) / _1957;
                                      float _1960 = (exp2(_1879 * 3.321928024291992f) - cb0_008y) / _1957;
                                      float _1962 = (exp2(_1953 * 3.321928024291992f) - cb0_008y) / _1957;
                                      float _1965 = mad(0.15618768334388733f, _1962, mad(0.13400420546531677f, _1960, (_1958 * 0.6624541878700256f)));
                                      float _1968 = mad(0.053689517080783844f, _1962, mad(0.6740817427635193f, _1960, (_1958 * 0.2722287178039551f)));
                                      float _1971 = mad(1.0103391408920288f, _1962, mad(0.00406073359772563f, _1960, (_1958 * -0.005574649665504694f)));
                                      float _1984 = min(max(mad(-0.23642469942569733f, _1971, mad(-0.32480329275131226f, _1968, (_1965 * 1.6410233974456787f))), 0.0f), 1.0f);
                                      float _1985 = min(max(mad(0.016756348311901093f, _1971, mad(1.6153316497802734f, _1968, (_1965 * -0.663662850856781f))), 0.0f), 1.0f);
                                      float _1986 = min(max(mad(0.9883948564529419f, _1971, mad(-0.008284442126750946f, _1968, (_1965 * 0.011721894145011902f))), 0.0f), 1.0f);
                                      float _1989 = mad(0.15618768334388733f, _1986, mad(0.13400420546531677f, _1985, (_1984 * 0.6624541878700256f)));
                                      float _1992 = mad(0.053689517080783844f, _1986, mad(0.6740817427635193f, _1985, (_1984 * 0.2722287178039551f)));
                                      float _1995 = mad(1.0103391408920288f, _1986, mad(0.00406073359772563f, _1985, (_1984 * -0.005574649665504694f)));
                                      float _2017 = min(max((min(max(mad(-0.23642469942569733f, _1995, mad(-0.32480329275131226f, _1992, (_1989 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                      float _2018 = min(max((min(max(mad(0.016756348311901093f, _1995, mad(1.6153316497802734f, _1992, (_1989 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                      float _2019 = min(max((min(max(mad(0.9883948564529419f, _1995, mad(-0.008284442126750946f, _1992, (_1989 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                      float _2038 = exp2(log2(mad(_53, _2019, mad(_52, _2018, (_2017 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      float _2039 = exp2(log2(mad(_56, _2019, mad(_55, _2018, (_2017 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      float _2040 = exp2(log2(mad(_59, _2019, mad(_58, _2018, (_2017 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      _2860 = exp2(log2((1.0f / ((_2038 * 18.6875f) + 1.0f)) * ((_2038 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                      _2861 = exp2(log2((1.0f / ((_2039 * 18.6875f) + 1.0f)) * ((_2039 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                      _2862 = exp2(log2((1.0f / ((_2040 * 18.6875f) + 1.0f)) * ((_2040 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      if ((uint)((uint)((int)(cb0_042w) + -5u)) < (uint)2) {
                        float _2106 = cb0_012z * _1229;
                        float _2107 = cb0_012z * _1230;
                        float _2108 = cb0_012z * _1231;
                        float _2111 = mad((WorkingColorSpace_256[0].z), _2108, mad((WorkingColorSpace_256[0].y), _2107, ((WorkingColorSpace_256[0].x) * _2106)));
                        float _2114 = mad((WorkingColorSpace_256[1].z), _2108, mad((WorkingColorSpace_256[1].y), _2107, ((WorkingColorSpace_256[1].x) * _2106)));
                        float _2117 = mad((WorkingColorSpace_256[2].z), _2108, mad((WorkingColorSpace_256[2].y), _2107, ((WorkingColorSpace_256[2].x) * _2106)));
                        float _2120 = mad(-0.21492856740951538f, _2117, mad(-0.2365107536315918f, _2114, (_2111 * 1.4514392614364624f)));
                        float _2123 = mad(-0.09967592358589172f, _2117, mad(1.17622971534729f, _2114, (_2111 * -0.07655377686023712f)));
                        float _2126 = mad(0.9977163076400757f, _2117, mad(-0.006032449658960104f, _2114, (_2111 * 0.008316148072481155f)));
                        float _2128 = max(_2120, max(_2123, _2126));
                        do {
                          if (!(_2128 < 1.000000013351432e-10f)) {
                            if (!(((bool)((bool)(_2111 < 0.0f) || (bool)(_2114 < 0.0f))) || (bool)(_2117 < 0.0f))) {
                              float _2138 = abs(_2128);
                              float _2139 = (_2128 - _2120) / _2138;
                              float _2141 = (_2128 - _2123) / _2138;
                              float _2143 = (_2128 - _2126) / _2138;
                              do {
                                if (!(_2139 < 0.8149999976158142f)) {
                                  float _2146 = _2139 + -0.8149999976158142f;
                                  _2158 = ((_2146 / exp2(log2(exp2(log2(_2146 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                } else {
                                  _2158 = _2139;
                                }
                                do {
                                  if (!(_2141 < 0.8029999732971191f)) {
                                    float _2161 = _2141 + -0.8029999732971191f;
                                    _2173 = ((_2161 / exp2(log2(exp2(log2(_2161 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                  } else {
                                    _2173 = _2141;
                                  }
                                  do {
                                    if (!(_2143 < 0.8799999952316284f)) {
                                      float _2176 = _2143 + -0.8799999952316284f;
                                      _2188 = ((_2176 / exp2(log2(exp2(log2(_2176 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                    } else {
                                      _2188 = _2143;
                                    }
                                    _2196 = (_2128 - (_2138 * _2158));
                                    _2197 = (_2128 - (_2138 * _2173));
                                    _2198 = (_2128 - (_2138 * _2188));
                                  } while (false);
                                } while (false);
                              } while (false);
                            } else {
                              _2196 = _2120;
                              _2197 = _2123;
                              _2198 = _2126;
                            }
                          } else {
                            _2196 = _2120;
                            _2197 = _2123;
                            _2198 = _2126;
                          }
                          float _2214 = ((mad(0.16386906802654266f, _2198, mad(0.14067870378494263f, _2197, (_2196 * 0.6954522132873535f))) - _2111) * cb0_012w) + _2111;
                          float _2215 = ((mad(0.0955343171954155f, _2198, mad(0.8596711158752441f, _2197, (_2196 * 0.044794563204050064f))) - _2114) * cb0_012w) + _2114;
                          float _2216 = ((mad(1.0015007257461548f, _2198, mad(0.004025210160762072f, _2197, (_2196 * -0.005525882821530104f))) - _2117) * cb0_012w) + _2117;
                          float _2220 = max(max(_2214, _2215), _2216);
                          float _2225 = (max(_2220, 1.000000013351432e-10f) - max(min(min(_2214, _2215), _2216), 1.000000013351432e-10f)) / max(_2220, 0.009999999776482582f);
                          float _2238 = ((_2215 + _2214) + _2216) + (sqrt((((_2216 - _2215) * _2216) + ((_2215 - _2214) * _2215)) + ((_2214 - _2216) * _2214)) * 1.75f);
                          float _2239 = _2238 * 0.3333333432674408f;
                          float _2240 = _2225 + -0.4000000059604645f;
                          float _2241 = _2240 * 5.0f;
                          float _2245 = max((1.0f - abs(_2240 * 2.5f)), 0.0f);
                          float _2256 = ((float((int)(((int)(uint)((bool)(_2241 > 0.0f))) - ((int)(uint)((bool)(_2241 < 0.0f))))) * (1.0f - (_2245 * _2245))) + 1.0f) * 0.02500000037252903f;
                          do {
                            if (!(_2239 <= 0.0533333346247673f)) {
                              if (!(_2239 >= 0.1599999964237213f)) {
                                _2265 = (((0.23999999463558197f / _2238) + -0.5f) * _2256);
                              } else {
                                _2265 = 0.0f;
                              }
                            } else {
                              _2265 = _2256;
                            }
                            float _2266 = _2265 + 1.0f;
                            float _2267 = _2266 * _2214;
                            float _2268 = _2266 * _2215;
                            float _2269 = _2266 * _2216;
                            do {
                              if (!((bool)(_2267 == _2268) && (bool)(_2268 == _2269))) {
                                float _2276 = ((_2267 * 2.0f) - _2268) - _2269;
                                float _2279 = ((_2215 - _2216) * 1.7320507764816284f) * _2266;
                                float _2281 = atan(_2279 / _2276);
                                bool _2284 = (_2276 < 0.0f);
                                bool _2285 = (_2276 == 0.0f);
                                bool _2286 = (_2279 >= 0.0f);
                                bool _2287 = (_2279 < 0.0f);
                                _2298 = select((_2286 && _2285), 90.0f, select((_2287 && _2285), -90.0f, (select((_2287 && _2284), (_2281 + -3.1415927410125732f), select((_2286 && _2284), (_2281 + 3.1415927410125732f), _2281)) * 57.2957763671875f)));
                              } else {
                                _2298 = 0.0f;
                              }
                              float _2303 = min(max(select((_2298 < 0.0f), (_2298 + 360.0f), _2298), 0.0f), 360.0f);
                              do {
                                if (_2303 < -180.0f) {
                                  _2312 = (_2303 + 360.0f);
                                } else {
                                  if (_2303 > 180.0f) {
                                    _2312 = (_2303 + -360.0f);
                                  } else {
                                    _2312 = _2303;
                                  }
                                }
                                do {
                                  if ((bool)(_2312 > -67.5f) && (bool)(_2312 < 67.5f)) {
                                    float _2318 = (_2312 + 67.5f) * 0.029629629105329514f;
                                    int _2319 = int(_2318);
                                    float _2321 = _2318 - float((int)(_2319));
                                    float _2322 = _2321 * _2321;
                                    float _2323 = _2322 * _2321;
                                    if (_2319 == 3) {
                                      _2351 = (((0.1666666716337204f - (_2321 * 0.5f)) + (_2322 * 0.5f)) - (_2323 * 0.1666666716337204f));
                                    } else {
                                      if (_2319 == 2) {
                                        _2351 = ((0.6666666865348816f - _2322) + (_2323 * 0.5f));
                                      } else {
                                        if (_2319 == 1) {
                                          _2351 = (((_2323 * -0.5f) + 0.1666666716337204f) + ((_2322 + _2321) * 0.5f));
                                        } else {
                                          _2351 = select((_2319 == 0), (_2323 * 0.1666666716337204f), 0.0f);
                                        }
                                      }
                                    }
                                  } else {
                                    _2351 = 0.0f;
                                  }
                                  float _2360 = min(max(((((_2225 * 0.27000001072883606f) * (0.029999999329447746f - _2267)) * _2351) + _2267), 0.0f), 65535.0f);
                                  float _2361 = min(max(_2268, 0.0f), 65535.0f);
                                  float _2362 = min(max(_2269, 0.0f), 65535.0f);
                                  float _2375 = min(max(mad(-0.21492856740951538f, _2362, mad(-0.2365107536315918f, _2361, (_2360 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                  float _2376 = min(max(mad(-0.09967592358589172f, _2362, mad(1.17622971534729f, _2361, (_2360 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                  float _2377 = min(max(mad(0.9977163076400757f, _2362, mad(-0.006032449658960104f, _2361, (_2360 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                  float _2378 = dot(float3(_2375, _2376, _2377), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                  float _2401 = log2(max((lerp(_2378, _2375, 0.9599999785423279f)), 1.000000013351432e-10f));
                                  float _2402 = _2401 * 0.3010300099849701f;
                                  float _2403 = log2(cb0_008x);
                                  float _2404 = _2403 * 0.3010300099849701f;
                                  do {
                                    if (!(!(_2402 <= _2404))) {
                                      _2473 = (log2(cb0_008y) * 0.3010300099849701f);
                                    } else {
                                      float _2411 = log2(cb0_009x);
                                      float _2412 = _2411 * 0.3010300099849701f;
                                      if ((bool)(_2402 > _2404) && (bool)(_2402 < _2412)) {
                                        float _2420 = ((_2401 - _2403) * 0.9030900001525879f) / ((_2411 - _2403) * 0.3010300099849701f);
                                        int _2421 = int(_2420);
                                        float _2423 = _2420 - float((int)(_2421));
                                        float _2425 = _14[_2421];
                                        float _2428 = _14[(_2421 + 1)];
                                        float _2433 = _2425 * 0.5f;
                                        _2473 = dot(float3((_2423 * _2423), _2423, 1.0f), float3(mad((_14[(_2421 + 2)]), 0.5f, mad(_2428, -1.0f, _2433)), (_2428 - _2425), mad(_2428, 0.5f, _2433)));
                                      } else {
                                        do {
                                          if (!(!(_2402 >= _2412))) {
                                            float _2442 = log2(cb0_008z);
                                            if (_2402 < (_2442 * 0.3010300099849701f)) {
                                              float _2450 = ((_2401 - _2411) * 0.9030900001525879f) / ((_2442 - _2411) * 0.3010300099849701f);
                                              int _2451 = int(_2450);
                                              float _2453 = _2450 - float((int)(_2451));
                                              float _2455 = _15[_2451];
                                              float _2458 = _15[(_2451 + 1)];
                                              float _2463 = _2455 * 0.5f;
                                              _2473 = dot(float3((_2453 * _2453), _2453, 1.0f), float3(mad((_15[(_2451 + 2)]), 0.5f, mad(_2458, -1.0f, _2463)), (_2458 - _2455), mad(_2458, 0.5f, _2463)));
                                              break;
                                            }
                                          }
                                          _2473 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                    float _2489 = log2(max((lerp(_2378, _2376, 0.9599999785423279f)), 1.000000013351432e-10f));
                                    float _2490 = _2489 * 0.3010300099849701f;
                                    do {
                                      if (!(!(_2490 <= _2404))) {
                                        _2559 = (log2(cb0_008y) * 0.3010300099849701f);
                                      } else {
                                        float _2497 = log2(cb0_009x);
                                        float _2498 = _2497 * 0.3010300099849701f;
                                        if ((bool)(_2490 > _2404) && (bool)(_2490 < _2498)) {
                                          float _2506 = ((_2489 - _2403) * 0.9030900001525879f) / ((_2497 - _2403) * 0.3010300099849701f);
                                          int _2507 = int(_2506);
                                          float _2509 = _2506 - float((int)(_2507));
                                          float _2511 = _10[_2507];
                                          float _2514 = _10[(_2507 + 1)];
                                          float _2519 = _2511 * 0.5f;
                                          _2559 = dot(float3((_2509 * _2509), _2509, 1.0f), float3(mad((_10[(_2507 + 2)]), 0.5f, mad(_2514, -1.0f, _2519)), (_2514 - _2511), mad(_2514, 0.5f, _2519)));
                                        } else {
                                          do {
                                            if (!(!(_2490 >= _2498))) {
                                              float _2528 = log2(cb0_008z);
                                              if (_2490 < (_2528 * 0.3010300099849701f)) {
                                                float _2536 = ((_2489 - _2497) * 0.9030900001525879f) / ((_2528 - _2497) * 0.3010300099849701f);
                                                int _2537 = int(_2536);
                                                float _2539 = _2536 - float((int)(_2537));
                                                float _2541 = _11[_2537];
                                                float _2544 = _11[(_2537 + 1)];
                                                float _2549 = _2541 * 0.5f;
                                                _2559 = dot(float3((_2539 * _2539), _2539, 1.0f), float3(mad((_11[(_2537 + 2)]), 0.5f, mad(_2544, -1.0f, _2549)), (_2544 - _2541), mad(_2544, 0.5f, _2549)));
                                                break;
                                              }
                                            }
                                            _2559 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                      float _2575 = log2(max((lerp(_2378, _2377, 0.9599999785423279f)), 1.000000013351432e-10f));
                                      float _2576 = _2575 * 0.3010300099849701f;
                                      do {
                                        if (!(!(_2576 <= _2404))) {
                                          _2645 = (log2(cb0_008y) * 0.3010300099849701f);
                                        } else {
                                          float _2583 = log2(cb0_009x);
                                          float _2584 = _2583 * 0.3010300099849701f;
                                          if ((bool)(_2576 > _2404) && (bool)(_2576 < _2584)) {
                                            float _2592 = ((_2575 - _2403) * 0.9030900001525879f) / ((_2583 - _2403) * 0.3010300099849701f);
                                            int _2593 = int(_2592);
                                            float _2595 = _2592 - float((int)(_2593));
                                            float _2597 = _12[_2593];
                                            float _2600 = _12[(_2593 + 1)];
                                            float _2605 = _2597 * 0.5f;
                                            _2645 = dot(float3((_2595 * _2595), _2595, 1.0f), float3(mad((_12[(_2593 + 2)]), 0.5f, mad(_2600, -1.0f, _2605)), (_2600 - _2597), mad(_2600, 0.5f, _2605)));
                                          } else {
                                            do {
                                              if (!(!(_2576 >= _2584))) {
                                                float _2614 = log2(cb0_008z);
                                                if (_2576 < (_2614 * 0.3010300099849701f)) {
                                                  float _2622 = ((_2575 - _2583) * 0.9030900001525879f) / ((_2614 - _2583) * 0.3010300099849701f);
                                                  int _2623 = int(_2622);
                                                  float _2625 = _2622 - float((int)(_2623));
                                                  float _2627 = _13[_2623];
                                                  float _2630 = _13[(_2623 + 1)];
                                                  float _2635 = _2627 * 0.5f;
                                                  _2645 = dot(float3((_2625 * _2625), _2625, 1.0f), float3(mad((_13[(_2623 + 2)]), 0.5f, mad(_2630, -1.0f, _2635)), (_2630 - _2627), mad(_2630, 0.5f, _2635)));
                                                  break;
                                                }
                                              }
                                              _2645 = (log2(cb0_008w) * 0.3010300099849701f);
                                            } while (false);
                                          }
                                        }
                                        float _2649 = cb0_008w - cb0_008y;
                                        float _2650 = (exp2(_2473 * 3.321928024291992f) - cb0_008y) / _2649;
                                        float _2652 = (exp2(_2559 * 3.321928024291992f) - cb0_008y) / _2649;
                                        float _2654 = (exp2(_2645 * 3.321928024291992f) - cb0_008y) / _2649;
                                        float _2657 = mad(0.15618768334388733f, _2654, mad(0.13400420546531677f, _2652, (_2650 * 0.6624541878700256f)));
                                        float _2660 = mad(0.053689517080783844f, _2654, mad(0.6740817427635193f, _2652, (_2650 * 0.2722287178039551f)));
                                        float _2663 = mad(1.0103391408920288f, _2654, mad(0.00406073359772563f, _2652, (_2650 * -0.005574649665504694f)));
                                        float _2676 = min(max(mad(-0.23642469942569733f, _2663, mad(-0.32480329275131226f, _2660, (_2657 * 1.6410233974456787f))), 0.0f), 1.0f);
                                        float _2677 = min(max(mad(0.016756348311901093f, _2663, mad(1.6153316497802734f, _2660, (_2657 * -0.663662850856781f))), 0.0f), 1.0f);
                                        float _2678 = min(max(mad(0.9883948564529419f, _2663, mad(-0.008284442126750946f, _2660, (_2657 * 0.011721894145011902f))), 0.0f), 1.0f);
                                        float _2681 = mad(0.15618768334388733f, _2678, mad(0.13400420546531677f, _2677, (_2676 * 0.6624541878700256f)));
                                        float _2684 = mad(0.053689517080783844f, _2678, mad(0.6740817427635193f, _2677, (_2676 * 0.2722287178039551f)));
                                        float _2687 = mad(1.0103391408920288f, _2678, mad(0.00406073359772563f, _2677, (_2676 * -0.005574649665504694f)));
                                        float _2709 = min(max((min(max(mad(-0.23642469942569733f, _2687, mad(-0.32480329275131226f, _2684, (_2681 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                        float _2712 = min(max((min(max(mad(0.016756348311901093f, _2687, mad(1.6153316497802734f, _2684, (_2681 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                        float _2713 = min(max((min(max(mad(0.9883948564529419f, _2687, mad(-0.008284442126750946f, _2684, (_2681 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                        _2860 = mad(-0.0832589864730835f, _2713, mad(-0.6217921376228333f, _2712, (_2709 * 0.0213131383061409f)));
                                        _2861 = mad(-0.010548308491706848f, _2713, mad(1.140804648399353f, _2712, (_2709 * -0.0016282059950754046f)));
                                        _2862 = mad(1.1529725790023804f, _2713, mad(-0.1289689838886261f, _2712, (_2709 * -0.00030004189466126263f)));
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } else {
                        if (cb0_042w == 7) {
                          float _2740 = mad((WorkingColorSpace_128[0].z), _1231, mad((WorkingColorSpace_128[0].y), _1230, ((WorkingColorSpace_128[0].x) * _1229)));
                          float _2743 = mad((WorkingColorSpace_128[1].z), _1231, mad((WorkingColorSpace_128[1].y), _1230, ((WorkingColorSpace_128[1].x) * _1229)));
                          float _2746 = mad((WorkingColorSpace_128[2].z), _1231, mad((WorkingColorSpace_128[2].y), _1230, ((WorkingColorSpace_128[2].x) * _1229)));
                          float _2765 = exp2(log2(mad(_53, _2746, mad(_52, _2743, (_2740 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2766 = exp2(log2(mad(_56, _2746, mad(_55, _2743, (_2740 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2767 = exp2(log2(mad(_59, _2746, mad(_58, _2743, (_2740 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2860 = exp2(log2((1.0f / ((_2765 * 18.6875f) + 1.0f)) * ((_2765 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2861 = exp2(log2((1.0f / ((_2766 * 18.6875f) + 1.0f)) * ((_2766 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2862 = exp2(log2((1.0f / ((_2767 * 18.6875f) + 1.0f)) * ((_2767 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } else {
                          if (!(cb0_042w == 8)) {
                            if (cb0_042w == 9) {
                              float _2814 = mad((WorkingColorSpace_128[0].z), _1219, mad((WorkingColorSpace_128[0].y), _1218, ((WorkingColorSpace_128[0].x) * _1217)));
                              float _2817 = mad((WorkingColorSpace_128[1].z), _1219, mad((WorkingColorSpace_128[1].y), _1218, ((WorkingColorSpace_128[1].x) * _1217)));
                              float _2820 = mad((WorkingColorSpace_128[2].z), _1219, mad((WorkingColorSpace_128[2].y), _1218, ((WorkingColorSpace_128[2].x) * _1217)));
                              _2860 = mad(_53, _2820, mad(_52, _2817, (_2814 * _51)));
                              _2861 = mad(_56, _2820, mad(_55, _2817, (_2814 * _54)));
                              _2862 = mad(_59, _2820, mad(_58, _2817, (_2814 * _57)));
                            } else {
                              float _2833 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
                              float _2836 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
                              float _2839 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
                              _2860 = exp2(log2(mad(_53, _2839, mad(_52, _2836, (_2833 * _51)))) * cb0_042z);
                              _2861 = exp2(log2(mad(_56, _2839, mad(_55, _2836, (_2833 * _54)))) * cb0_042z);
                              _2862 = exp2(log2(mad(_59, _2839, mad(_58, _2836, (_2833 * _57)))) * cb0_042z);
                            }
                          } else {
                            _2860 = _1229;
                            _2861 = _1230;
                            _2862 = _1231;
                          }
                        }
                      }
                    }
                  }
                }
                SV_Target.x = (_2860 * 0.9523810148239136f);
                SV_Target.y = (_2861 * 0.9523810148239136f);
                SV_Target.z = (_2862 * 0.9523810148239136f);
                SV_Target.w = 0.0f;
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  bool _155 = (cb0_040w != 0);
  float _157 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _174 = (((((2967800.0f - (_157 * 4607000064.0f)) * _157) + 99.11000061035156f) * _157) + 0.24406300485134125f);
  } else {
    _174 = (((((1901800.0f - (_157 * 2006400000.0f)) * _157) + 247.47999572753906f) * _157) + 0.23703999817371368f);
  }
  float _188 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _195 = cb0_037y * cb0_037y;
  float _198 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_195 * 1.6145605741257896e-07f));
  float _203 = ((_188 * 2.0f) + 4.0f) - (_198 * 8.0f);
  float _204 = (_188 * 3.0f) / _203;
  float _206 = (_198 * 2.0f) / _203;
  bool _207 = (cb0_037y < 4000.0f);
  float _216 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _218 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_195 * 1.5317699909210205f)) / (_216 * _216);
  float _225 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _195;
  float _227 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_195 * 308.60699462890625f)) / (_225 * _225);
  float _229 = rsqrt(dot(float2(_218, _227), float2(_218, _227)));
  float _230 = cb0_037z * 0.05000000074505806f;
  float _233 = ((_230 * _227) * _229) + _188;
  float _236 = _198 - ((_230 * _218) * _229);
  float _241 = (4.0f - (_236 * 8.0f)) + (_233 * 2.0f);
  float _247 = (((_233 * 3.0f) / _241) - _204) + select(_207, _204, _174);
  float _248 = (((_236 * 2.0f) / _241) - _206) + select(_207, _206, (((_174 * 2.869999885559082f) + -0.2750000059604645f) - ((_174 * _174) * 3.0f)));
  float _249 = select(_155, _247, 0.3127000033855438f);
  float _250 = select(_155, _248, 0.32899999618530273f);
  float _251 = select(_155, 0.3127000033855438f, _247);
  float _252 = select(_155, 0.32899999618530273f, _248);
  float _253 = max(_250, 1.000000013351432e-10f);
  float _254 = _249 / _253;
  float _257 = ((1.0f - _249) - _250) / _253;
  float _258 = max(_252, 1.000000013351432e-10f);
  float _259 = _251 / _258;
  float _262 = ((1.0f - _251) - _252) / _258;
  float _281 = mad(-0.16140000522136688f, _262, ((_259 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _257, ((_254 * 0.8950999975204468f) + 0.266400009393692f));
  float _282 = mad(0.03669999912381172f, _262, (1.7135000228881836f - (_259 * 0.7501999735832214f))) / mad(0.03669999912381172f, _257, (1.7135000228881836f - (_254 * 0.7501999735832214f)));
  float _283 = mad(1.0296000242233276f, _262, ((_259 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _257, ((_254 * 0.03889999911189079f) + -0.06849999725818634f));
  float _284 = mad(_282, -0.7501999735832214f, 0.0f);
  float _285 = mad(_282, 1.7135000228881836f, 0.0f);
  float _286 = mad(_282, 0.03669999912381172f, -0.0f);
  float _287 = mad(_283, 0.03889999911189079f, 0.0f);
  float _288 = mad(_283, -0.06849999725818634f, 0.0f);
  float _289 = mad(_283, 1.0296000242233276f, 0.0f);
  float _292 = mad(0.1599626988172531f, _287, mad(-0.1470542997121811f, _284, (_281 * 0.883457362651825f)));
  float _295 = mad(0.1599626988172531f, _288, mad(-0.1470542997121811f, _285, (_281 * 0.26293492317199707f)));
  float _298 = mad(0.1599626988172531f, _289, mad(-0.1470542997121811f, _286, (_281 * -0.15930065512657166f)));
  float _301 = mad(0.04929120093584061f, _287, mad(0.5183603167533875f, _284, (_281 * 0.38695648312568665f)));
  float _304 = mad(0.04929120093584061f, _288, mad(0.5183603167533875f, _285, (_281 * 0.11516613513231277f)));
  float _307 = mad(0.04929120093584061f, _289, mad(0.5183603167533875f, _286, (_281 * -0.0697740763425827f)));
  float _310 = mad(0.9684867262840271f, _287, mad(0.04004279896616936f, _284, (_281 * -0.007634039502590895f)));
  float _313 = mad(0.9684867262840271f, _288, mad(0.04004279896616936f, _285, (_281 * -0.0022720457054674625f)));
  float _316 = mad(0.9684867262840271f, _289, mad(0.04004279896616936f, _286, (_281 * 0.0013765322510153055f)));
  float _319 = mad(_298, (WorkingColorSpace_000[2].x), mad(_295, (WorkingColorSpace_000[1].x), (_292 * (WorkingColorSpace_000[0].x))));
  float _322 = mad(_298, (WorkingColorSpace_000[2].y), mad(_295, (WorkingColorSpace_000[1].y), (_292 * (WorkingColorSpace_000[0].y))));
  float _325 = mad(_298, (WorkingColorSpace_000[2].z), mad(_295, (WorkingColorSpace_000[1].z), (_292 * (WorkingColorSpace_000[0].z))));
  float _328 = mad(_307, (WorkingColorSpace_000[2].x), mad(_304, (WorkingColorSpace_000[1].x), (_301 * (WorkingColorSpace_000[0].x))));
  float _331 = mad(_307, (WorkingColorSpace_000[2].y), mad(_304, (WorkingColorSpace_000[1].y), (_301 * (WorkingColorSpace_000[0].y))));
  float _334 = mad(_307, (WorkingColorSpace_000[2].z), mad(_304, (WorkingColorSpace_000[1].z), (_301 * (WorkingColorSpace_000[0].z))));
  float _337 = mad(_316, (WorkingColorSpace_000[2].x), mad(_313, (WorkingColorSpace_000[1].x), (_310 * (WorkingColorSpace_000[0].x))));
  float _340 = mad(_316, (WorkingColorSpace_000[2].y), mad(_313, (WorkingColorSpace_000[1].y), (_310 * (WorkingColorSpace_000[0].y))));
  float _343 = mad(_316, (WorkingColorSpace_000[2].z), mad(_313, (WorkingColorSpace_000[1].z), (_310 * (WorkingColorSpace_000[0].z))));
  _381 = mad(mad((WorkingColorSpace_064[0].z), _343, mad((WorkingColorSpace_064[0].y), _334, (_325 * (WorkingColorSpace_064[0].x)))), _119, mad(mad((WorkingColorSpace_064[0].z), _340, mad((WorkingColorSpace_064[0].y), _331, (_322 * (WorkingColorSpace_064[0].x)))), _118, (mad((WorkingColorSpace_064[0].z), _337, mad((WorkingColorSpace_064[0].y), _328, (_319 * (WorkingColorSpace_064[0].x)))) * _117)));
  _382 = mad(mad((WorkingColorSpace_064[1].z), _343, mad((WorkingColorSpace_064[1].y), _334, (_325 * (WorkingColorSpace_064[1].x)))), _119, mad(mad((WorkingColorSpace_064[1].z), _340, mad((WorkingColorSpace_064[1].y), _331, (_322 * (WorkingColorSpace_064[1].x)))), _118, (mad((WorkingColorSpace_064[1].z), _337, mad((WorkingColorSpace_064[1].y), _328, (_319 * (WorkingColorSpace_064[1].x)))) * _117)));
  _383 = mad(mad((WorkingColorSpace_064[2].z), _343, mad((WorkingColorSpace_064[2].y), _334, (_325 * (WorkingColorSpace_064[2].x)))), _119, mad(mad((WorkingColorSpace_064[2].z), _340, mad((WorkingColorSpace_064[2].y), _331, (_322 * (WorkingColorSpace_064[2].x)))), _118, (mad((WorkingColorSpace_064[2].z), _337, mad((WorkingColorSpace_064[2].y), _328, (_319 * (WorkingColorSpace_064[2].x)))) * _117)));
  float _398 = mad((WorkingColorSpace_128[0].z), _383, mad((WorkingColorSpace_128[0].y), _382, ((WorkingColorSpace_128[0].x) * _381)));
  float _401 = mad((WorkingColorSpace_128[1].z), _383, mad((WorkingColorSpace_128[1].y), _382, ((WorkingColorSpace_128[1].x) * _381)));
  float _404 = mad((WorkingColorSpace_128[2].z), _383, mad((WorkingColorSpace_128[2].y), _382, ((WorkingColorSpace_128[2].x) * _381)));
  SetUngradedAP1(float3(_398, _401, _404));

  float _405 = dot(float3(_398, _401, _404), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _409 = (_398 / _405) + -1.0f;
  float _410 = (_401 / _405) + -1.0f;
  float _411 = (_404 / _405) + -1.0f;
  float _423 = (1.0f - exp2(((_405 * _405) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_409, _410, _411), float3(_409, _410, _411)) * -4.0f));
  float _439 = ((mad(-0.06368321925401688f, _404, mad(-0.3292922377586365f, _401, (_398 * 1.3704125881195068f))) - _398) * _423) + _398;
  float _440 = ((mad(-0.010861365124583244f, _404, mad(1.0970927476882935f, _401, (_398 * -0.08343357592821121f))) - _401) * _423) + _401;
  float _441 = ((mad(1.2036951780319214f, _404, mad(-0.09862580895423889f, _401, (_398 * -0.02579331398010254f))) - _404) * _423) + _404;
  float _442 = dot(float3(_439, _440, _441), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _456 = cb0_021w + cb0_026w;
  float _470 = cb0_020w * cb0_025w;
  float _484 = cb0_019w * cb0_024w;
  float _498 = cb0_018w * cb0_023w;
  float _512 = cb0_017w * cb0_022w;
  float _516 = _439 - _442;
  float _517 = _440 - _442;
  float _518 = _441 - _442;
  float _575 = saturate(_442 / cb0_037w);
  float _579 = (_575 * _575) * (3.0f - (_575 * 2.0f));
  float _580 = 1.0f - _579;
  float _589 = cb0_021w + cb0_036w;
  float _598 = cb0_020w * cb0_035w;
  float _607 = cb0_019w * cb0_034w;
  float _616 = cb0_018w * cb0_033w;
  float _625 = cb0_017w * cb0_032w;
  float _688 = saturate((_442 - cb0_038x) / (cb0_038y - cb0_038x));
  float _692 = (_688 * _688) * (3.0f - (_688 * 2.0f));
  float _701 = cb0_021w + cb0_031w;
  float _710 = cb0_020w * cb0_030w;
  float _719 = cb0_019w * cb0_029w;
  float _728 = cb0_018w * cb0_028w;
  float _737 = cb0_017w * cb0_027w;
  float _795 = _579 - _692;
  float _806 = ((_692 * (((cb0_021x + cb0_036x) + _589) + (((cb0_020x * cb0_035x) * _598) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _616) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _625) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _607)))))) + (_580 * (((cb0_021x + cb0_026x) + _456) + (((cb0_020x * cb0_025x) * _470) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _498) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _512) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _484))))))) + ((((cb0_021x + cb0_031x) + _701) + (((cb0_020x * cb0_030x) * _710) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _728) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _737) * _516) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _719))))) * _795);
  float _808 = ((_692 * (((cb0_021y + cb0_036y) + _589) + (((cb0_020y * cb0_035y) * _598) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _616) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _625) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _607)))))) + (_580 * (((cb0_021y + cb0_026y) + _456) + (((cb0_020y * cb0_025y) * _470) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _498) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _512) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _484))))))) + ((((cb0_021y + cb0_031y) + _701) + (((cb0_020y * cb0_030y) * _710) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _728) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _737) * _517) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _719))))) * _795);
  float _810 = ((_692 * (((cb0_021z + cb0_036z) + _589) + (((cb0_020z * cb0_035z) * _598) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _616) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _625) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _607)))))) + (_580 * (((cb0_021z + cb0_026z) + _456) + (((cb0_020z * cb0_025z) * _470) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _498) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _512) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _484))))))) + ((((cb0_021z + cb0_031z) + _701) + (((cb0_020z * cb0_030z) * _710) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _728) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _737) * _518) + _442)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _719))))) * _795);
  SetUntonemappedAP1(float3(_806, _808, _810));

  float _846 = ((mad(0.061360642313957214f, _810, mad(-4.540197551250458e-09f, _808, (_806 * 0.9386394023895264f))) - _806) * cb0_038z) + _806;
  float _847 = ((mad(0.169205904006958f, _810, mad(0.8307942152023315f, _808, (_806 * 6.775371730327606e-08f))) - _808) * cb0_038z) + _808;
  float _848 = (mad(-2.3283064365386963e-10f, _808, (_806 * -9.313225746154785e-10f)) * cb0_038z) + _810;
  float _851 = mad(0.16386905312538147f, _848, mad(0.14067868888378143f, _847, (_846 * 0.6954522132873535f)));
  float _854 = mad(0.0955343246459961f, _848, mad(0.8596711158752441f, _847, (_846 * 0.044794581830501556f)));
  float _857 = mad(1.0015007257461548f, _848, mad(0.004025210160762072f, _847, (_846 * -0.005525882821530104f)));
  float _861 = max(max(_851, _854), _857);
  float _866 = (max(_861, 1.000000013351432e-10f) - max(min(min(_851, _854), _857), 1.000000013351432e-10f)) / max(_861, 0.009999999776482582f);
  float _879 = ((_854 + _851) + _857) + (sqrt((((_857 - _854) * _857) + ((_854 - _851) * _854)) + ((_851 - _857) * _851)) * 1.75f);
  float _880 = _879 * 0.3333333432674408f;
  float _881 = _866 + -0.4000000059604645f;
  float _882 = _881 * 5.0f;
  float _886 = max((1.0f - abs(_881 * 2.5f)), 0.0f);
  float _897 = ((float((int)(((int)(uint)((bool)(_882 > 0.0f))) - ((int)(uint)((bool)(_882 < 0.0f))))) * (1.0f - (_886 * _886))) + 1.0f) * 0.02500000037252903f;
  if (!(_880 <= 0.0533333346247673f)) {
    if (!(_880 >= 0.1599999964237213f)) {
      _906 = (((0.23999999463558197f / _879) + -0.5f) * _897);
    } else {
      _906 = 0.0f;
    }
  } else {
    _906 = _897;
  }
  float _907 = _906 + 1.0f;
  float _908 = _907 * _851;
  float _909 = _907 * _854;
  float _910 = _907 * _857;
  if (!((bool)(_908 == _909) && (bool)(_909 == _910))) {
    float _917 = ((_908 * 2.0f) - _909) - _910;
    float _920 = ((_854 - _857) * 1.7320507764816284f) * _907;
    float _922 = atan(_920 / _917);
    bool _925 = (_917 < 0.0f);
    bool _926 = (_917 == 0.0f);
    bool _927 = (_920 >= 0.0f);
    bool _928 = (_920 < 0.0f);
    _939 = select((_927 && _926), 90.0f, select((_928 && _926), -90.0f, (select((_928 && _925), (_922 + -3.1415927410125732f), select((_927 && _925), (_922 + 3.1415927410125732f), _922)) * 57.2957763671875f)));
  } else {
    _939 = 0.0f;
  }
  float _944 = min(max(select((_939 < 0.0f), (_939 + 360.0f), _939), 0.0f), 360.0f);
  if (_944 < -180.0f) {
    _953 = (_944 + 360.0f);
  } else {
    if (_944 > 180.0f) {
      _953 = (_944 + -360.0f);
    } else {
      _953 = _944;
    }
  }
  float _957 = saturate(1.0f - abs(_953 * 0.014814814552664757f));
  float _961 = (_957 * _957) * (3.0f - (_957 * 2.0f));
  float _967 = ((_961 * _961) * ((_866 * 0.18000000715255737f) * (0.029999999329447746f - _908))) + _908;
  float _977 = max(0.0f, mad(-0.21492856740951538f, _910, mad(-0.2365107536315918f, _909, (_967 * 1.4514392614364624f))));
  float _978 = max(0.0f, mad(-0.09967592358589172f, _910, mad(1.17622971534729f, _909, (_967 * -0.07655377686023712f))));
  float _979 = max(0.0f, mad(0.9977163076400757f, _910, mad(-0.006032449658960104f, _909, (_967 * 0.008316148072481155f))));
  float _980 = dot(float3(_977, _978, _979), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _995 = (cb0_040x + 1.0f) - cb0_039z;
  float _997 = cb0_040y + 1.0f;
  float _999 = _997 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1017 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    float _1008 = (cb0_040x + 0.18000000715255737f) / _995;
    _1017 = (-0.7447274923324585f - ((log2(_1008 / (2.0f - _1008)) * 0.3465735912322998f) * (_995 / cb0_039y)));
  }
  float _1020 = ((1.0f - cb0_039z) / cb0_039y) - _1017;
  float _1022 = (cb0_039w / cb0_039y) - _1020;
  float _1026 = log2(lerp(_980, _977, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1027 = log2(lerp(_980, _978, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1028 = log2(lerp(_980, _979, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1032 = cb0_039y * (_1026 + _1020);
  float _1033 = cb0_039y * (_1027 + _1020);
  float _1034 = cb0_039y * (_1028 + _1020);
  float _1035 = _995 * 2.0f;
  float _1037 = (cb0_039y * -2.0f) / _995;
  float _1038 = _1026 - _1017;
  float _1039 = _1027 - _1017;
  float _1040 = _1028 - _1017;
  float _1059 = _999 * 2.0f;
  float _1061 = (cb0_039y * 2.0f) / _999;
  float _1086 = select((_1026 < _1017), ((_1035 / (exp2((_1038 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1032);
  float _1087 = select((_1027 < _1017), ((_1035 / (exp2((_1039 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1033);
  float _1088 = select((_1028 < _1017), ((_1035 / (exp2((_1040 * 1.4426950216293335f) * _1037) + 1.0f)) - cb0_040x), _1034);
  float _1095 = _1022 - _1017;
  float _1099 = saturate(_1038 / _1095);
  float _1100 = saturate(_1039 / _1095);
  float _1101 = saturate(_1040 / _1095);
  bool _1102 = (_1022 < _1017);
  float _1106 = select(_1102, (1.0f - _1099), _1099);
  float _1107 = select(_1102, (1.0f - _1100), _1100);
  float _1108 = select(_1102, (1.0f - _1101), _1101);
  float _1127 = (((_1106 * _1106) * (select((_1026 > _1022), (_997 - (_1059 / (exp2(((_1026 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1032) - _1086)) * (3.0f - (_1106 * 2.0f))) + _1086;
  float _1128 = (((_1107 * _1107) * (select((_1027 > _1022), (_997 - (_1059 / (exp2(((_1027 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
  float _1129 = (((_1108 * _1108) * (select((_1028 > _1022), (_997 - (_1059 / (exp2(((_1028 - _1022) * 1.4426950216293335f) * _1061) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
  float _1130 = dot(float3(_1127, _1128, _1129), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1150 = (cb0_039x * (max(0.0f, (lerp(_1130, _1127, 0.9300000071525574f))) - _846)) + _846;
  float _1151 = (cb0_039x * (max(0.0f, (lerp(_1130, _1128, 0.9300000071525574f))) - _847)) + _847;
  float _1152 = (cb0_039x * (max(0.0f, (lerp(_1130, _1129, 0.9300000071525574f))) - _848)) + _848;
  float _1168 = ((mad(-0.06537103652954102f, _1152, mad(1.451815478503704e-06f, _1151, (_1150 * 1.065374732017517f))) - _1150) * cb0_038z) + _1150;
  float _1169 = ((mad(-0.20366770029067993f, _1152, mad(1.2036634683609009f, _1151, (_1150 * -2.57161445915699e-07f))) - _1151) * cb0_038z) + _1151;
  float _1170 = ((mad(0.9999996423721313f, _1152, mad(2.0954757928848267e-08f, _1151, (_1150 * 1.862645149230957e-08f))) - _1152) * cb0_038z) + _1152;
  SetTonemappedAP1(_1168, _1169, _1170);

  float _1180 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1170, mad((WorkingColorSpace_192[0].y), _1169, ((WorkingColorSpace_192[0].x) * _1168))));
  float _1181 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1170, mad((WorkingColorSpace_192[1].y), _1169, ((WorkingColorSpace_192[1].x) * _1168))));
  float _1182 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1170, mad((WorkingColorSpace_192[2].y), _1169, ((WorkingColorSpace_192[2].x) * _1168))));
  float _1208 = cb0_016x * (((cb0_041y + (cb0_041x * _1180)) * _1180) + cb0_041z);
  float _1209 = cb0_016y * (((cb0_041y + (cb0_041x * _1181)) * _1181) + cb0_041z);
  float _1210 = cb0_016z * (((cb0_041y + (cb0_041x * _1182)) * _1182) + cb0_041z);
  float _1217 = ((cb0_015x - _1208) * cb0_015w) + _1208;
  float _1218 = ((cb0_015y - _1209) * cb0_015w) + _1209;
  float _1219 = ((cb0_015z - _1210) * cb0_015w) + _1210;
  float _1220 = cb0_016x * mad((WorkingColorSpace_192[0].z), _810, mad((WorkingColorSpace_192[0].y), _808, (_806 * (WorkingColorSpace_192[0].x))));
  float _1221 = cb0_016y * mad((WorkingColorSpace_192[1].z), _810, mad((WorkingColorSpace_192[1].y), _808, ((WorkingColorSpace_192[1].x) * _806)));
  float _1222 = cb0_016z * mad((WorkingColorSpace_192[2].z), _810, mad((WorkingColorSpace_192[2].y), _808, ((WorkingColorSpace_192[2].x) * _806)));
  float _1229 = ((cb0_015x - _1220) * cb0_015w) + _1220;
  float _1230 = ((cb0_015y - _1221) * cb0_015w) + _1221;
  float _1231 = ((cb0_015z - _1222) * cb0_015w) + _1222;
  float _1243 = exp2(log2(max(0.0f, _1217)) * cb0_042y);
  float _1244 = exp2(log2(max(0.0f, _1218)) * cb0_042y);
  float _1245 = exp2(log2(max(0.0f, _1219)) * cb0_042y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return GenerateOutput(float3(_1243, _1244, _1245), cb0_042w);
  }
  [branch]
  if (cb0_042w == 0) {
    do {
      if (WorkingColorSpace_384 == 0) {
        float _1268 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
        float _1271 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
        float _1274 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
        _1285 = mad(_53, _1274, mad(_52, _1271, (_1268 * _51)));
        _1286 = mad(_56, _1274, mad(_55, _1271, (_1268 * _54)));
        _1287 = mad(_59, _1274, mad(_58, _1271, (_1268 * _57)));
      } else {
        _1285 = _1243;
        _1286 = _1244;
        _1287 = _1245;
      }
      do {
        if (_1285 < 0.0031306699384003878f) {
          _1298 = (_1285 * 12.920000076293945f);
        } else {
          _1298 = (((pow(_1285, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1286 < 0.0031306699384003878f) {
            _1309 = (_1286 * 12.920000076293945f);
          } else {
            _1309 = (((pow(_1286, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1287 < 0.0031306699384003878f) {
            _2860 = _1298;
            _2861 = _1309;
            _2862 = (_1287 * 12.920000076293945f);
          } else {
            _2860 = _1298;
            _2861 = _1309;
            _2862 = (((pow(_1287, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_042w == 1) {
      float _1336 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
      float _1339 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
      float _1342 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
      float _1345 = mad(_53, _1342, mad(_52, _1339, (_1336 * _51)));
      float _1348 = mad(_56, _1342, mad(_55, _1339, (_1336 * _54)));
      float _1351 = mad(_59, _1342, mad(_58, _1339, (_1336 * _57)));
      _2860 = min((_1345 * 4.5f), ((exp2(log2(max(_1345, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2861 = min((_1348 * 4.5f), ((exp2(log2(max(_1348, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2862 = min((_1351 * 4.5f), ((exp2(log2(max(_1351, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((uint)((int)(cb0_042w) + -3u)) < (uint)2) {
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
        float _1426 = cb0_012z * _1229;
        float _1427 = cb0_012z * _1230;
        float _1428 = cb0_012z * _1231;
        float _1431 = mad((WorkingColorSpace_256[0].z), _1428, mad((WorkingColorSpace_256[0].y), _1427, ((WorkingColorSpace_256[0].x) * _1426)));
        float _1434 = mad((WorkingColorSpace_256[1].z), _1428, mad((WorkingColorSpace_256[1].y), _1427, ((WorkingColorSpace_256[1].x) * _1426)));
        float _1437 = mad((WorkingColorSpace_256[2].z), _1428, mad((WorkingColorSpace_256[2].y), _1427, ((WorkingColorSpace_256[2].x) * _1426)));
        float _1440 = mad(-0.21492856740951538f, _1437, mad(-0.2365107536315918f, _1434, (_1431 * 1.4514392614364624f)));
        float _1443 = mad(-0.09967592358589172f, _1437, mad(1.17622971534729f, _1434, (_1431 * -0.07655377686023712f)));
        float _1446 = mad(0.9977163076400757f, _1437, mad(-0.006032449658960104f, _1434, (_1431 * 0.008316148072481155f)));
        float _1448 = max(_1440, max(_1443, _1446));
        do {
          if (!(_1448 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1431 < 0.0f) || (bool)(_1434 < 0.0f))) || (bool)(_1437 < 0.0f))) {
              float _1458 = abs(_1448);
              float _1459 = (_1448 - _1440) / _1458;
              float _1461 = (_1448 - _1443) / _1458;
              float _1463 = (_1448 - _1446) / _1458;
              do {
                if (!(_1459 < 0.8149999976158142f)) {
                  float _1466 = _1459 + -0.8149999976158142f;
                  _1478 = ((_1466 / exp2(log2(exp2(log2(_1466 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1478 = _1459;
                }
                do {
                  if (!(_1461 < 0.8029999732971191f)) {
                    float _1481 = _1461 + -0.8029999732971191f;
                    _1493 = ((_1481 / exp2(log2(exp2(log2(_1481 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1493 = _1461;
                  }
                  do {
                    if (!(_1463 < 0.8799999952316284f)) {
                      float _1496 = _1463 + -0.8799999952316284f;
                      _1508 = ((_1496 / exp2(log2(exp2(log2(_1496 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1508 = _1463;
                    }
                    _1516 = (_1448 - (_1458 * _1478));
                    _1517 = (_1448 - (_1458 * _1493));
                    _1518 = (_1448 - (_1458 * _1508));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1516 = _1440;
              _1517 = _1443;
              _1518 = _1446;
            }
          } else {
            _1516 = _1440;
            _1517 = _1443;
            _1518 = _1446;
          }
          float _1534 = ((mad(0.16386906802654266f, _1518, mad(0.14067870378494263f, _1517, (_1516 * 0.6954522132873535f))) - _1431) * cb0_012w) + _1431;
          float _1535 = ((mad(0.0955343171954155f, _1518, mad(0.8596711158752441f, _1517, (_1516 * 0.044794563204050064f))) - _1434) * cb0_012w) + _1434;
          float _1536 = ((mad(1.0015007257461548f, _1518, mad(0.004025210160762072f, _1517, (_1516 * -0.005525882821530104f))) - _1437) * cb0_012w) + _1437;
          float _1540 = max(max(_1534, _1535), _1536);
          float _1545 = (max(_1540, 1.000000013351432e-10f) - max(min(min(_1534, _1535), _1536), 1.000000013351432e-10f)) / max(_1540, 0.009999999776482582f);
          float _1558 = ((_1535 + _1534) + _1536) + (sqrt((((_1536 - _1535) * _1536) + ((_1535 - _1534) * _1535)) + ((_1534 - _1536) * _1534)) * 1.75f);
          float _1559 = _1558 * 0.3333333432674408f;
          float _1560 = _1545 + -0.4000000059604645f;
          float _1561 = _1560 * 5.0f;
          float _1565 = max((1.0f - abs(_1560 * 2.5f)), 0.0f);
          float _1576 = ((float((int)(((int)(uint)((bool)(_1561 > 0.0f))) - ((int)(uint)((bool)(_1561 < 0.0f))))) * (1.0f - (_1565 * _1565))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1559 <= 0.0533333346247673f)) {
              if (!(_1559 >= 0.1599999964237213f)) {
                _1585 = (((0.23999999463558197f / _1558) + -0.5f) * _1576);
              } else {
                _1585 = 0.0f;
              }
            } else {
              _1585 = _1576;
            }
            float _1586 = _1585 + 1.0f;
            float _1587 = _1586 * _1534;
            float _1588 = _1586 * _1535;
            float _1589 = _1586 * _1536;
            do {
              if (!((bool)(_1587 == _1588) && (bool)(_1588 == _1589))) {
                float _1596 = ((_1587 * 2.0f) - _1588) - _1589;
                float _1599 = ((_1535 - _1536) * 1.7320507764816284f) * _1586;
                float _1601 = atan(_1599 / _1596);
                bool _1604 = (_1596 < 0.0f);
                bool _1605 = (_1596 == 0.0f);
                bool _1606 = (_1599 >= 0.0f);
                bool _1607 = (_1599 < 0.0f);
                _1618 = select((_1606 && _1605), 90.0f, select((_1607 && _1605), -90.0f, (select((_1607 && _1604), (_1601 + -3.1415927410125732f), select((_1606 && _1604), (_1601 + 3.1415927410125732f), _1601)) * 57.2957763671875f)));
              } else {
                _1618 = 0.0f;
              }
              float _1623 = min(max(select((_1618 < 0.0f), (_1618 + 360.0f), _1618), 0.0f), 360.0f);
              do {
                if (_1623 < -180.0f) {
                  _1632 = (_1623 + 360.0f);
                } else {
                  if (_1623 > 180.0f) {
                    _1632 = (_1623 + -360.0f);
                  } else {
                    _1632 = _1623;
                  }
                }
                do {
                  if ((bool)(_1632 > -67.5f) && (bool)(_1632 < 67.5f)) {
                    float _1638 = (_1632 + 67.5f) * 0.029629629105329514f;
                    int _1639 = int(_1638);
                    float _1641 = _1638 - float((int)(_1639));
                    float _1642 = _1641 * _1641;
                    float _1643 = _1642 * _1641;
                    if (_1639 == 3) {
                      _1671 = (((0.1666666716337204f - (_1641 * 0.5f)) + (_1642 * 0.5f)) - (_1643 * 0.1666666716337204f));
                    } else {
                      if (_1639 == 2) {
                        _1671 = ((0.6666666865348816f - _1642) + (_1643 * 0.5f));
                      } else {
                        if (_1639 == 1) {
                          _1671 = (((_1643 * -0.5f) + 0.1666666716337204f) + ((_1642 + _1641) * 0.5f));
                        } else {
                          _1671 = select((_1639 == 0), (_1643 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1671 = 0.0f;
                  }
                  float _1680 = min(max(((((_1545 * 0.27000001072883606f) * (0.029999999329447746f - _1587)) * _1671) + _1587), 0.0f), 65535.0f);
                  float _1681 = min(max(_1588, 0.0f), 65535.0f);
                  float _1682 = min(max(_1589, 0.0f), 65535.0f);
                  float _1695 = min(max(mad(-0.21492856740951538f, _1682, mad(-0.2365107536315918f, _1681, (_1680 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1696 = min(max(mad(-0.09967592358589172f, _1682, mad(1.17622971534729f, _1681, (_1680 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1697 = min(max(mad(0.9977163076400757f, _1682, mad(-0.006032449658960104f, _1681, (_1680 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1698 = dot(float3(_1695, _1696, _1697), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1721 = log2(max((lerp(_1698, _1695, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1722 = _1721 * 0.3010300099849701f;
                  float _1723 = log2(cb0_008x);
                  float _1724 = _1723 * 0.3010300099849701f;
                  do {
                    if (!(!(_1722 <= _1724))) {
                      _1793 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1731 = log2(cb0_009x);
                      float _1732 = _1731 * 0.3010300099849701f;
                      if ((bool)(_1722 > _1724) && (bool)(_1722 < _1732)) {
                        float _1740 = ((_1721 - _1723) * 0.9030900001525879f) / ((_1731 - _1723) * 0.3010300099849701f);
                        int _1741 = int(_1740);
                        float _1743 = _1740 - float((int)(_1741));
                        float _1745 = _16[_1741];
                        float _1748 = _16[(_1741 + 1)];
                        float _1753 = _1745 * 0.5f;
                        _1793 = dot(float3((_1743 * _1743), _1743, 1.0f), float3(mad((_16[(_1741 + 2)]), 0.5f, mad(_1748, -1.0f, _1753)), (_1748 - _1745), mad(_1748, 0.5f, _1753)));
                      } else {
                        do {
                          if (!(!(_1722 >= _1732))) {
                            float _1762 = log2(cb0_008z);
                            if (_1722 < (_1762 * 0.3010300099849701f)) {
                              float _1770 = ((_1721 - _1731) * 0.9030900001525879f) / ((_1762 - _1731) * 0.3010300099849701f);
                              int _1771 = int(_1770);
                              float _1773 = _1770 - float((int)(_1771));
                              float _1775 = _17[_1771];
                              float _1778 = _17[(_1771 + 1)];
                              float _1783 = _1775 * 0.5f;
                              _1793 = dot(float3((_1773 * _1773), _1773, 1.0f), float3(mad((_17[(_1771 + 2)]), 0.5f, mad(_1778, -1.0f, _1783)), (_1778 - _1775), mad(_1778, 0.5f, _1783)));
                              break;
                            }
                          }
                          _1793 = (log2(cb0_008w) * 0.3010300099849701f);
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
                    float _1809 = log2(max((lerp(_1698, _1696, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1810 = _1809 * 0.3010300099849701f;
                    do {
                      if (!(!(_1810 <= _1724))) {
                        _1879 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1817 = log2(cb0_009x);
                        float _1818 = _1817 * 0.3010300099849701f;
                        if ((bool)(_1810 > _1724) && (bool)(_1810 < _1818)) {
                          float _1826 = ((_1809 - _1723) * 0.9030900001525879f) / ((_1817 - _1723) * 0.3010300099849701f);
                          int _1827 = int(_1826);
                          float _1829 = _1826 - float((int)(_1827));
                          float _1831 = _18[_1827];
                          float _1834 = _18[(_1827 + 1)];
                          float _1839 = _1831 * 0.5f;
                          _1879 = dot(float3((_1829 * _1829), _1829, 1.0f), float3(mad((_18[(_1827 + 2)]), 0.5f, mad(_1834, -1.0f, _1839)), (_1834 - _1831), mad(_1834, 0.5f, _1839)));
                        } else {
                          do {
                            if (!(!(_1810 >= _1818))) {
                              float _1848 = log2(cb0_008z);
                              if (_1810 < (_1848 * 0.3010300099849701f)) {
                                float _1856 = ((_1809 - _1817) * 0.9030900001525879f) / ((_1848 - _1817) * 0.3010300099849701f);
                                int _1857 = int(_1856);
                                float _1859 = _1856 - float((int)(_1857));
                                float _1861 = _19[_1857];
                                float _1864 = _19[(_1857 + 1)];
                                float _1869 = _1861 * 0.5f;
                                _1879 = dot(float3((_1859 * _1859), _1859, 1.0f), float3(mad((_19[(_1857 + 2)]), 0.5f, mad(_1864, -1.0f, _1869)), (_1864 - _1861), mad(_1864, 0.5f, _1869)));
                                break;
                              }
                            }
                            _1879 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1883 = log2(max((lerp(_1698, _1697, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1884 = _1883 * 0.3010300099849701f;
                      do {
                        if (!(!(_1884 <= _1724))) {
                          _1953 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1891 = log2(cb0_009x);
                          float _1892 = _1891 * 0.3010300099849701f;
                          if ((bool)(_1884 > _1724) && (bool)(_1884 < _1892)) {
                            float _1900 = ((_1883 - _1723) * 0.9030900001525879f) / ((_1891 - _1723) * 0.3010300099849701f);
                            int _1901 = int(_1900);
                            float _1903 = _1900 - float((int)(_1901));
                            float _1905 = _8[_1901];
                            float _1908 = _8[(_1901 + 1)];
                            float _1913 = _1905 * 0.5f;
                            _1953 = dot(float3((_1903 * _1903), _1903, 1.0f), float3(mad((_8[(_1901 + 2)]), 0.5f, mad(_1908, -1.0f, _1913)), (_1908 - _1905), mad(_1908, 0.5f, _1913)));
                          } else {
                            do {
                              if (!(!(_1884 >= _1892))) {
                                float _1922 = log2(cb0_008z);
                                if (_1884 < (_1922 * 0.3010300099849701f)) {
                                  float _1930 = ((_1883 - _1891) * 0.9030900001525879f) / ((_1922 - _1891) * 0.3010300099849701f);
                                  int _1931 = int(_1930);
                                  float _1933 = _1930 - float((int)(_1931));
                                  float _1935 = _9[_1931];
                                  float _1938 = _9[(_1931 + 1)];
                                  float _1943 = _1935 * 0.5f;
                                  _1953 = dot(float3((_1933 * _1933), _1933, 1.0f), float3(mad((_9[(_1931 + 2)]), 0.5f, mad(_1938, -1.0f, _1943)), (_1938 - _1935), mad(_1938, 0.5f, _1943)));
                                  break;
                                }
                              }
                              _1953 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1957 = cb0_008w - cb0_008y;
                        float _1958 = (exp2(_1793 * 3.321928024291992f) - cb0_008y) / _1957;
                        float _1960 = (exp2(_1879 * 3.321928024291992f) - cb0_008y) / _1957;
                        float _1962 = (exp2(_1953 * 3.321928024291992f) - cb0_008y) / _1957;
                        float _1965 = mad(0.15618768334388733f, _1962, mad(0.13400420546531677f, _1960, (_1958 * 0.6624541878700256f)));
                        float _1968 = mad(0.053689517080783844f, _1962, mad(0.6740817427635193f, _1960, (_1958 * 0.2722287178039551f)));
                        float _1971 = mad(1.0103391408920288f, _1962, mad(0.00406073359772563f, _1960, (_1958 * -0.005574649665504694f)));
                        float _1984 = min(max(mad(-0.23642469942569733f, _1971, mad(-0.32480329275131226f, _1968, (_1965 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1985 = min(max(mad(0.016756348311901093f, _1971, mad(1.6153316497802734f, _1968, (_1965 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1986 = min(max(mad(0.9883948564529419f, _1971, mad(-0.008284442126750946f, _1968, (_1965 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1989 = mad(0.15618768334388733f, _1986, mad(0.13400420546531677f, _1985, (_1984 * 0.6624541878700256f)));
                        float _1992 = mad(0.053689517080783844f, _1986, mad(0.6740817427635193f, _1985, (_1984 * 0.2722287178039551f)));
                        float _1995 = mad(1.0103391408920288f, _1986, mad(0.00406073359772563f, _1985, (_1984 * -0.005574649665504694f)));
                        float _2017 = min(max((min(max(mad(-0.23642469942569733f, _1995, mad(-0.32480329275131226f, _1992, (_1989 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2018 = min(max((min(max(mad(0.016756348311901093f, _1995, mad(1.6153316497802734f, _1992, (_1989 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2019 = min(max((min(max(mad(0.9883948564529419f, _1995, mad(-0.008284442126750946f, _1992, (_1989 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2038 = exp2(log2(mad(_53, _2019, mad(_52, _2018, (_2017 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2039 = exp2(log2(mad(_56, _2019, mad(_55, _2018, (_2017 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2040 = exp2(log2(mad(_59, _2019, mad(_58, _2018, (_2017 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2860 = exp2(log2((1.0f / ((_2038 * 18.6875f) + 1.0f)) * ((_2038 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2861 = exp2(log2((1.0f / ((_2039 * 18.6875f) + 1.0f)) * ((_2039 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2862 = exp2(log2((1.0f / ((_2040 * 18.6875f) + 1.0f)) * ((_2040 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((uint)((uint)((int)(cb0_042w) + -5u)) < (uint)2) {
          float _2106 = cb0_012z * _1229;
          float _2107 = cb0_012z * _1230;
          float _2108 = cb0_012z * _1231;
          float _2111 = mad((WorkingColorSpace_256[0].z), _2108, mad((WorkingColorSpace_256[0].y), _2107, ((WorkingColorSpace_256[0].x) * _2106)));
          float _2114 = mad((WorkingColorSpace_256[1].z), _2108, mad((WorkingColorSpace_256[1].y), _2107, ((WorkingColorSpace_256[1].x) * _2106)));
          float _2117 = mad((WorkingColorSpace_256[2].z), _2108, mad((WorkingColorSpace_256[2].y), _2107, ((WorkingColorSpace_256[2].x) * _2106)));
          float _2120 = mad(-0.21492856740951538f, _2117, mad(-0.2365107536315918f, _2114, (_2111 * 1.4514392614364624f)));
          float _2123 = mad(-0.09967592358589172f, _2117, mad(1.17622971534729f, _2114, (_2111 * -0.07655377686023712f)));
          float _2126 = mad(0.9977163076400757f, _2117, mad(-0.006032449658960104f, _2114, (_2111 * 0.008316148072481155f)));
          float _2128 = max(_2120, max(_2123, _2126));
          do {
            if (!(_2128 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2111 < 0.0f) || (bool)(_2114 < 0.0f))) || (bool)(_2117 < 0.0f))) {
                float _2138 = abs(_2128);
                float _2139 = (_2128 - _2120) / _2138;
                float _2141 = (_2128 - _2123) / _2138;
                float _2143 = (_2128 - _2126) / _2138;
                do {
                  if (!(_2139 < 0.8149999976158142f)) {
                    float _2146 = _2139 + -0.8149999976158142f;
                    _2158 = ((_2146 / exp2(log2(exp2(log2(_2146 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2158 = _2139;
                  }
                  do {
                    if (!(_2141 < 0.8029999732971191f)) {
                      float _2161 = _2141 + -0.8029999732971191f;
                      _2173 = ((_2161 / exp2(log2(exp2(log2(_2161 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2173 = _2141;
                    }
                    do {
                      if (!(_2143 < 0.8799999952316284f)) {
                        float _2176 = _2143 + -0.8799999952316284f;
                        _2188 = ((_2176 / exp2(log2(exp2(log2(_2176 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2188 = _2143;
                      }
                      _2196 = (_2128 - (_2138 * _2158));
                      _2197 = (_2128 - (_2138 * _2173));
                      _2198 = (_2128 - (_2138 * _2188));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2196 = _2120;
                _2197 = _2123;
                _2198 = _2126;
              }
            } else {
              _2196 = _2120;
              _2197 = _2123;
              _2198 = _2126;
            }
            float _2214 = ((mad(0.16386906802654266f, _2198, mad(0.14067870378494263f, _2197, (_2196 * 0.6954522132873535f))) - _2111) * cb0_012w) + _2111;
            float _2215 = ((mad(0.0955343171954155f, _2198, mad(0.8596711158752441f, _2197, (_2196 * 0.044794563204050064f))) - _2114) * cb0_012w) + _2114;
            float _2216 = ((mad(1.0015007257461548f, _2198, mad(0.004025210160762072f, _2197, (_2196 * -0.005525882821530104f))) - _2117) * cb0_012w) + _2117;
            float _2220 = max(max(_2214, _2215), _2216);
            float _2225 = (max(_2220, 1.000000013351432e-10f) - max(min(min(_2214, _2215), _2216), 1.000000013351432e-10f)) / max(_2220, 0.009999999776482582f);
            float _2238 = ((_2215 + _2214) + _2216) + (sqrt((((_2216 - _2215) * _2216) + ((_2215 - _2214) * _2215)) + ((_2214 - _2216) * _2214)) * 1.75f);
            float _2239 = _2238 * 0.3333333432674408f;
            float _2240 = _2225 + -0.4000000059604645f;
            float _2241 = _2240 * 5.0f;
            float _2245 = max((1.0f - abs(_2240 * 2.5f)), 0.0f);
            float _2256 = ((float((int)(((int)(uint)((bool)(_2241 > 0.0f))) - ((int)(uint)((bool)(_2241 < 0.0f))))) * (1.0f - (_2245 * _2245))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2239 <= 0.0533333346247673f)) {
                if (!(_2239 >= 0.1599999964237213f)) {
                  _2265 = (((0.23999999463558197f / _2238) + -0.5f) * _2256);
                } else {
                  _2265 = 0.0f;
                }
              } else {
                _2265 = _2256;
              }
              float _2266 = _2265 + 1.0f;
              float _2267 = _2266 * _2214;
              float _2268 = _2266 * _2215;
              float _2269 = _2266 * _2216;
              do {
                if (!((bool)(_2267 == _2268) && (bool)(_2268 == _2269))) {
                  float _2276 = ((_2267 * 2.0f) - _2268) - _2269;
                  float _2279 = ((_2215 - _2216) * 1.7320507764816284f) * _2266;
                  float _2281 = atan(_2279 / _2276);
                  bool _2284 = (_2276 < 0.0f);
                  bool _2285 = (_2276 == 0.0f);
                  bool _2286 = (_2279 >= 0.0f);
                  bool _2287 = (_2279 < 0.0f);
                  _2298 = select((_2286 && _2285), 90.0f, select((_2287 && _2285), -90.0f, (select((_2287 && _2284), (_2281 + -3.1415927410125732f), select((_2286 && _2284), (_2281 + 3.1415927410125732f), _2281)) * 57.2957763671875f)));
                } else {
                  _2298 = 0.0f;
                }
                float _2303 = min(max(select((_2298 < 0.0f), (_2298 + 360.0f), _2298), 0.0f), 360.0f);
                do {
                  if (_2303 < -180.0f) {
                    _2312 = (_2303 + 360.0f);
                  } else {
                    if (_2303 > 180.0f) {
                      _2312 = (_2303 + -360.0f);
                    } else {
                      _2312 = _2303;
                    }
                  }
                  do {
                    if ((bool)(_2312 > -67.5f) && (bool)(_2312 < 67.5f)) {
                      float _2318 = (_2312 + 67.5f) * 0.029629629105329514f;
                      int _2319 = int(_2318);
                      float _2321 = _2318 - float((int)(_2319));
                      float _2322 = _2321 * _2321;
                      float _2323 = _2322 * _2321;
                      if (_2319 == 3) {
                        _2351 = (((0.1666666716337204f - (_2321 * 0.5f)) + (_2322 * 0.5f)) - (_2323 * 0.1666666716337204f));
                      } else {
                        if (_2319 == 2) {
                          _2351 = ((0.6666666865348816f - _2322) + (_2323 * 0.5f));
                        } else {
                          if (_2319 == 1) {
                            _2351 = (((_2323 * -0.5f) + 0.1666666716337204f) + ((_2322 + _2321) * 0.5f));
                          } else {
                            _2351 = select((_2319 == 0), (_2323 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2351 = 0.0f;
                    }
                    float _2360 = min(max(((((_2225 * 0.27000001072883606f) * (0.029999999329447746f - _2267)) * _2351) + _2267), 0.0f), 65535.0f);
                    float _2361 = min(max(_2268, 0.0f), 65535.0f);
                    float _2362 = min(max(_2269, 0.0f), 65535.0f);
                    float _2375 = min(max(mad(-0.21492856740951538f, _2362, mad(-0.2365107536315918f, _2361, (_2360 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2376 = min(max(mad(-0.09967592358589172f, _2362, mad(1.17622971534729f, _2361, (_2360 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2377 = min(max(mad(0.9977163076400757f, _2362, mad(-0.006032449658960104f, _2361, (_2360 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2378 = dot(float3(_2375, _2376, _2377), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2401 = log2(max((lerp(_2378, _2375, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2402 = _2401 * 0.3010300099849701f;
                    float _2403 = log2(cb0_008x);
                    float _2404 = _2403 * 0.3010300099849701f;
                    do {
                      if (!(!(_2402 <= _2404))) {
                        _2473 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2411 = log2(cb0_009x);
                        float _2412 = _2411 * 0.3010300099849701f;
                        if ((bool)(_2402 > _2404) && (bool)(_2402 < _2412)) {
                          float _2420 = ((_2401 - _2403) * 0.9030900001525879f) / ((_2411 - _2403) * 0.3010300099849701f);
                          int _2421 = int(_2420);
                          float _2423 = _2420 - float((int)(_2421));
                          float _2425 = _14[_2421];
                          float _2428 = _14[(_2421 + 1)];
                          float _2433 = _2425 * 0.5f;
                          _2473 = dot(float3((_2423 * _2423), _2423, 1.0f), float3(mad((_14[(_2421 + 2)]), 0.5f, mad(_2428, -1.0f, _2433)), (_2428 - _2425), mad(_2428, 0.5f, _2433)));
                        } else {
                          do {
                            if (!(!(_2402 >= _2412))) {
                              float _2442 = log2(cb0_008z);
                              if (_2402 < (_2442 * 0.3010300099849701f)) {
                                float _2450 = ((_2401 - _2411) * 0.9030900001525879f) / ((_2442 - _2411) * 0.3010300099849701f);
                                int _2451 = int(_2450);
                                float _2453 = _2450 - float((int)(_2451));
                                float _2455 = _15[_2451];
                                float _2458 = _15[(_2451 + 1)];
                                float _2463 = _2455 * 0.5f;
                                _2473 = dot(float3((_2453 * _2453), _2453, 1.0f), float3(mad((_15[(_2451 + 2)]), 0.5f, mad(_2458, -1.0f, _2463)), (_2458 - _2455), mad(_2458, 0.5f, _2463)));
                                break;
                              }
                            }
                            _2473 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _2489 = log2(max((lerp(_2378, _2376, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2490 = _2489 * 0.3010300099849701f;
                      do {
                        if (!(!(_2490 <= _2404))) {
                          _2559 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2497 = log2(cb0_009x);
                          float _2498 = _2497 * 0.3010300099849701f;
                          if ((bool)(_2490 > _2404) && (bool)(_2490 < _2498)) {
                            float _2506 = ((_2489 - _2403) * 0.9030900001525879f) / ((_2497 - _2403) * 0.3010300099849701f);
                            int _2507 = int(_2506);
                            float _2509 = _2506 - float((int)(_2507));
                            float _2511 = _10[_2507];
                            float _2514 = _10[(_2507 + 1)];
                            float _2519 = _2511 * 0.5f;
                            _2559 = dot(float3((_2509 * _2509), _2509, 1.0f), float3(mad((_10[(_2507 + 2)]), 0.5f, mad(_2514, -1.0f, _2519)), (_2514 - _2511), mad(_2514, 0.5f, _2519)));
                          } else {
                            do {
                              if (!(!(_2490 >= _2498))) {
                                float _2528 = log2(cb0_008z);
                                if (_2490 < (_2528 * 0.3010300099849701f)) {
                                  float _2536 = ((_2489 - _2497) * 0.9030900001525879f) / ((_2528 - _2497) * 0.3010300099849701f);
                                  int _2537 = int(_2536);
                                  float _2539 = _2536 - float((int)(_2537));
                                  float _2541 = _11[_2537];
                                  float _2544 = _11[(_2537 + 1)];
                                  float _2549 = _2541 * 0.5f;
                                  _2559 = dot(float3((_2539 * _2539), _2539, 1.0f), float3(mad((_11[(_2537 + 2)]), 0.5f, mad(_2544, -1.0f, _2549)), (_2544 - _2541), mad(_2544, 0.5f, _2549)));
                                  break;
                                }
                              }
                              _2559 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2575 = log2(max((lerp(_2378, _2377, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2576 = _2575 * 0.3010300099849701f;
                        do {
                          if (!(!(_2576 <= _2404))) {
                            _2645 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2583 = log2(cb0_009x);
                            float _2584 = _2583 * 0.3010300099849701f;
                            if ((bool)(_2576 > _2404) && (bool)(_2576 < _2584)) {
                              float _2592 = ((_2575 - _2403) * 0.9030900001525879f) / ((_2583 - _2403) * 0.3010300099849701f);
                              int _2593 = int(_2592);
                              float _2595 = _2592 - float((int)(_2593));
                              float _2597 = _12[_2593];
                              float _2600 = _12[(_2593 + 1)];
                              float _2605 = _2597 * 0.5f;
                              _2645 = dot(float3((_2595 * _2595), _2595, 1.0f), float3(mad((_12[(_2593 + 2)]), 0.5f, mad(_2600, -1.0f, _2605)), (_2600 - _2597), mad(_2600, 0.5f, _2605)));
                            } else {
                              do {
                                if (!(!(_2576 >= _2584))) {
                                  float _2614 = log2(cb0_008z);
                                  if (_2576 < (_2614 * 0.3010300099849701f)) {
                                    float _2622 = ((_2575 - _2583) * 0.9030900001525879f) / ((_2614 - _2583) * 0.3010300099849701f);
                                    int _2623 = int(_2622);
                                    float _2625 = _2622 - float((int)(_2623));
                                    float _2627 = _13[_2623];
                                    float _2630 = _13[(_2623 + 1)];
                                    float _2635 = _2627 * 0.5f;
                                    _2645 = dot(float3((_2625 * _2625), _2625, 1.0f), float3(mad((_13[(_2623 + 2)]), 0.5f, mad(_2630, -1.0f, _2635)), (_2630 - _2627), mad(_2630, 0.5f, _2635)));
                                    break;
                                  }
                                }
                                _2645 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2649 = cb0_008w - cb0_008y;
                          float _2650 = (exp2(_2473 * 3.321928024291992f) - cb0_008y) / _2649;
                          float _2652 = (exp2(_2559 * 3.321928024291992f) - cb0_008y) / _2649;
                          float _2654 = (exp2(_2645 * 3.321928024291992f) - cb0_008y) / _2649;
                          float _2657 = mad(0.15618768334388733f, _2654, mad(0.13400420546531677f, _2652, (_2650 * 0.6624541878700256f)));
                          float _2660 = mad(0.053689517080783844f, _2654, mad(0.6740817427635193f, _2652, (_2650 * 0.2722287178039551f)));
                          float _2663 = mad(1.0103391408920288f, _2654, mad(0.00406073359772563f, _2652, (_2650 * -0.005574649665504694f)));
                          float _2676 = min(max(mad(-0.23642469942569733f, _2663, mad(-0.32480329275131226f, _2660, (_2657 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2677 = min(max(mad(0.016756348311901093f, _2663, mad(1.6153316497802734f, _2660, (_2657 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2678 = min(max(mad(0.9883948564529419f, _2663, mad(-0.008284442126750946f, _2660, (_2657 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2681 = mad(0.15618768334388733f, _2678, mad(0.13400420546531677f, _2677, (_2676 * 0.6624541878700256f)));
                          float _2684 = mad(0.053689517080783844f, _2678, mad(0.6740817427635193f, _2677, (_2676 * 0.2722287178039551f)));
                          float _2687 = mad(1.0103391408920288f, _2678, mad(0.00406073359772563f, _2677, (_2676 * -0.005574649665504694f)));
                          float _2709 = min(max((min(max(mad(-0.23642469942569733f, _2687, mad(-0.32480329275131226f, _2684, (_2681 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2712 = min(max((min(max(mad(0.016756348311901093f, _2687, mad(1.6153316497802734f, _2684, (_2681 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          float _2713 = min(max((min(max(mad(0.9883948564529419f, _2687, mad(-0.008284442126750946f, _2684, (_2681 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          _2860 = mad(-0.0832589864730835f, _2713, mad(-0.6217921376228333f, _2712, (_2709 * 0.0213131383061409f)));
                          _2861 = mad(-0.010548308491706848f, _2713, mad(1.140804648399353f, _2712, (_2709 * -0.0016282059950754046f)));
                          _2862 = mad(1.1529725790023804f, _2713, mad(-0.1289689838886261f, _2712, (_2709 * -0.00030004189466126263f)));
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (cb0_042w == 7) {
            float _2740 = mad((WorkingColorSpace_128[0].z), _1231, mad((WorkingColorSpace_128[0].y), _1230, ((WorkingColorSpace_128[0].x) * _1229)));
            float _2743 = mad((WorkingColorSpace_128[1].z), _1231, mad((WorkingColorSpace_128[1].y), _1230, ((WorkingColorSpace_128[1].x) * _1229)));
            float _2746 = mad((WorkingColorSpace_128[2].z), _1231, mad((WorkingColorSpace_128[2].y), _1230, ((WorkingColorSpace_128[2].x) * _1229)));
            float _2765 = exp2(log2(mad(_53, _2746, mad(_52, _2743, (_2740 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2766 = exp2(log2(mad(_56, _2746, mad(_55, _2743, (_2740 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2767 = exp2(log2(mad(_59, _2746, mad(_58, _2743, (_2740 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2860 = exp2(log2((1.0f / ((_2765 * 18.6875f) + 1.0f)) * ((_2765 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2861 = exp2(log2((1.0f / ((_2766 * 18.6875f) + 1.0f)) * ((_2766 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2862 = exp2(log2((1.0f / ((_2767 * 18.6875f) + 1.0f)) * ((_2767 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                float _2814 = mad((WorkingColorSpace_128[0].z), _1219, mad((WorkingColorSpace_128[0].y), _1218, ((WorkingColorSpace_128[0].x) * _1217)));
                float _2817 = mad((WorkingColorSpace_128[1].z), _1219, mad((WorkingColorSpace_128[1].y), _1218, ((WorkingColorSpace_128[1].x) * _1217)));
                float _2820 = mad((WorkingColorSpace_128[2].z), _1219, mad((WorkingColorSpace_128[2].y), _1218, ((WorkingColorSpace_128[2].x) * _1217)));
                _2860 = mad(_53, _2820, mad(_52, _2817, (_2814 * _51)));
                _2861 = mad(_56, _2820, mad(_55, _2817, (_2814 * _54)));
                _2862 = mad(_59, _2820, mad(_58, _2817, (_2814 * _57)));
              } else {
                float _2833 = mad((WorkingColorSpace_128[0].z), _1245, mad((WorkingColorSpace_128[0].y), _1244, ((WorkingColorSpace_128[0].x) * _1243)));
                float _2836 = mad((WorkingColorSpace_128[1].z), _1245, mad((WorkingColorSpace_128[1].y), _1244, ((WorkingColorSpace_128[1].x) * _1243)));
                float _2839 = mad((WorkingColorSpace_128[2].z), _1245, mad((WorkingColorSpace_128[2].y), _1244, ((WorkingColorSpace_128[2].x) * _1243)));
                _2860 = exp2(log2(mad(_53, _2839, mad(_52, _2836, (_2833 * _51)))) * cb0_042z);
                _2861 = exp2(log2(mad(_56, _2839, mad(_55, _2836, (_2833 * _54)))) * cb0_042z);
                _2862 = exp2(log2(mad(_59, _2839, mad(_58, _2836, (_2833 * _57)))) * cb0_042z);
              }
            } else {
              _2860 = _1229;
              _2861 = _1230;
              _2862 = _1231;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2860 * 0.9523810148239136f);
  SV_Target.y = (_2861 * 0.9523810148239136f);
  SV_Target.z = (_2862 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
