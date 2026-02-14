#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
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

SamplerState s0 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
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
  float _21[6];
  float _24 = 0.5f / cb0_037x;
  float _29 = cb0_037x + -1.0f;
  float _30 = (cb0_037x * (TEXCOORD.x - _24)) / _29;
  float _31 = (cb0_037x * (TEXCOORD.y - _24)) / _29;
  float _33 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _29;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _119;
  float _120;
  float _121;
  float _176;
  float _383;
  float _384;
  float _385;
  float _908;
  float _941;
  float _955;
  float _1019;
  float _1198;
  float _1209;
  float _1220;
  float _1393;
  float _1394;
  float _1395;
  float _1406;
  float _1417;
  float _1586;
  float _1601;
  float _1616;
  float _1624;
  float _1625;
  float _1626;
  float _1693;
  float _1726;
  float _1740;
  float _1779;
  float _1901;
  float _1987;
  float _2061;
  float _2266;
  float _2281;
  float _2296;
  float _2304;
  float _2305;
  float _2306;
  float _2373;
  float _2406;
  float _2420;
  float _2459;
  float _2581;
  float _2667;
  float _2753;
  float _2968;
  float _2969;
  float _2970;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        bool _42 = (cb0_043x == 4);
        _53 = select(_42, 1.0f, 1.705051064491272f);
        _54 = select(_42, 0.0f, -0.6217921376228333f);
        _55 = select(_42, 0.0f, -0.0832589864730835f);
        _56 = select(_42, 0.0f, -0.13025647401809692f);
        _57 = select(_42, 1.0f, 1.140804648399353f);
        _58 = select(_42, 0.0f, -0.010548308491706848f);
        _59 = select(_42, 0.0f, -0.024003351107239723f);
        _60 = select(_42, 0.0f, -0.1289689838886261f);
        _61 = select(_42, 1.0f, 1.1529725790023804f);
      } else {
        _53 = 0.6954522132873535f;
        _54 = 0.14067870378494263f;
        _55 = 0.16386906802654266f;
        _56 = 0.044794563204050064f;
        _57 = 0.8596711158752441f;
        _58 = 0.0955343171954155f;
        _59 = -0.005525882821530104f;
        _60 = 0.004025210160762072f;
        _61 = 1.0015007257461548f;
      }
    } else {
      _53 = 1.0258246660232544f;
      _54 = -0.020053181797266006f;
      _55 = -0.005771636962890625f;
      _56 = -0.002234415616840124f;
      _57 = 1.0045864582061768f;
      _58 = -0.002352118492126465f;
      _59 = -0.005013350863009691f;
      _60 = -0.025290070101618767f;
      _61 = 1.0303035974502563f;
    }
  } else {
    _53 = 1.3792141675949097f;
    _54 = -0.30886411666870117f;
    _55 = -0.0703500509262085f;
    _56 = -0.06933490186929703f;
    _57 = 1.08229660987854f;
    _58 = -0.012961871922016144f;
    _59 = -0.0021590073592960835f;
    _60 = -0.0454593189060688f;
    _61 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_042w > (uint)2) {
    float _72 = (pow(_30, 0.012683313339948654f));
    float _73 = (pow(_31, 0.012683313339948654f));
    float _74 = (pow(_33, 0.012683313339948654f));
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _119 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_31 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_33 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _383 = _119;
      _384 = _120;
      _385 = _121;
      float _400 = mad((WorkingColorSpace_128[0].z), _385, mad((WorkingColorSpace_128[0].y), _384, ((WorkingColorSpace_128[0].x) * _383)));
      float _403 = mad((WorkingColorSpace_128[1].z), _385, mad((WorkingColorSpace_128[1].y), _384, ((WorkingColorSpace_128[1].x) * _383)));
      float _406 = mad((WorkingColorSpace_128[2].z), _385, mad((WorkingColorSpace_128[2].y), _384, ((WorkingColorSpace_128[2].x) * _383)));
      SetUngradedAP1(float3(_400, _403, _406));

      float _407 = dot(float3(_400, _403, _406), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _411 = (_400 / _407) + -1.0f;
      float _412 = (_403 / _407) + -1.0f;
      float _413 = (_406 / _407) + -1.0f;
      float _425 = (1.0f - exp2(((_407 * _407) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_411, _412, _413), float3(_411, _412, _413)) * -4.0f));
      float _441 = ((mad(-0.06368321925401688f, _406, mad(-0.3292922377586365f, _403, (_400 * 1.3704125881195068f))) - _400) * _425) + _400;
      float _442 = ((mad(-0.010861365124583244f, _406, mad(1.0970927476882935f, _403, (_400 * -0.08343357592821121f))) - _403) * _425) + _403;
      float _443 = ((mad(1.2036951780319214f, _406, mad(-0.09862580895423889f, _403, (_400 * -0.02579331398010254f))) - _406) * _425) + _406;
      float _444 = dot(float3(_441, _442, _443), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _458 = cb0_021w + cb0_026w;
      float _472 = cb0_020w * cb0_025w;
      float _486 = cb0_019w * cb0_024w;
      float _500 = cb0_018w * cb0_023w;
      float _514 = cb0_017w * cb0_022w;
      float _518 = _441 - _444;
      float _519 = _442 - _444;
      float _520 = _443 - _444;
      float _577 = saturate(_444 / cb0_037w);
      float _581 = (_577 * _577) * (3.0f - (_577 * 2.0f));
      float _582 = 1.0f - _581;
      float _591 = cb0_021w + cb0_036w;
      float _600 = cb0_020w * cb0_035w;
      float _609 = cb0_019w * cb0_034w;
      float _618 = cb0_018w * cb0_033w;
      float _627 = cb0_017w * cb0_032w;
      float _690 = saturate((_444 - cb0_038x) / (cb0_038y - cb0_038x));
      float _694 = (_690 * _690) * (3.0f - (_690 * 2.0f));
      float _703 = cb0_021w + cb0_031w;
      float _712 = cb0_020w * cb0_030w;
      float _721 = cb0_019w * cb0_029w;
      float _730 = cb0_018w * cb0_028w;
      float _739 = cb0_017w * cb0_027w;
      float _797 = _581 - _694;
      float _808 = ((_694 * (((cb0_021x + cb0_036x) + _591) + (((cb0_020x * cb0_035x) * _600) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _618) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _627) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _609)))))) + (_582 * (((cb0_021x + cb0_026x) + _458) + (((cb0_020x * cb0_025x) * _472) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _500) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _514) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _486))))))) + ((((cb0_021x + cb0_031x) + _703) + (((cb0_020x * cb0_030x) * _712) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _730) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _739) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _721))))) * _797);
      float _810 = ((_694 * (((cb0_021y + cb0_036y) + _591) + (((cb0_020y * cb0_035y) * _600) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _618) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _627) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _609)))))) + (_582 * (((cb0_021y + cb0_026y) + _458) + (((cb0_020y * cb0_025y) * _472) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _500) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _514) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _486))))))) + ((((cb0_021y + cb0_031y) + _703) + (((cb0_020y * cb0_030y) * _712) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _730) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _739) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _721))))) * _797);
      float _812 = ((_694 * (((cb0_021z + cb0_036z) + _591) + (((cb0_020z * cb0_035z) * _600) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _618) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _627) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _609)))))) + (_582 * (((cb0_021z + cb0_026z) + _458) + (((cb0_020z * cb0_025z) * _472) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _500) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _514) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _486))))))) + ((((cb0_021z + cb0_031z) + _703) + (((cb0_020z * cb0_030z) * _712) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _730) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _739) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _721))))) * _797);
      SetUntonemappedAP1(float3(_808, _810, _812));

      float _848 = ((mad(0.061360642313957214f, _812, mad(-4.540197551250458e-09f, _810, (_808 * 0.9386394023895264f))) - _808) * cb0_038z) + _808;
      float _849 = ((mad(0.169205904006958f, _812, mad(0.8307942152023315f, _810, (_808 * 6.775371730327606e-08f))) - _810) * cb0_038z) + _810;
      float _850 = (mad(-2.3283064365386963e-10f, _810, (_808 * -9.313225746154785e-10f)) * cb0_038z) + _812;
      float _853 = mad(0.16386905312538147f, _850, mad(0.14067868888378143f, _849, (_848 * 0.6954522132873535f)));
      float _856 = mad(0.0955343246459961f, _850, mad(0.8596711158752441f, _849, (_848 * 0.044794581830501556f)));
      float _859 = mad(1.0015007257461548f, _850, mad(0.004025210160762072f, _849, (_848 * -0.005525882821530104f)));
      float _863 = max(max(_853, _856), _859);
      float _868 = (max(_863, 1.000000013351432e-10f) - max(min(min(_853, _856), _859), 1.000000013351432e-10f)) / max(_863, 0.009999999776482582f);
      float _881 = ((_856 + _853) + _859) + (sqrt((((_859 - _856) * _859) + ((_856 - _853) * _856)) + ((_853 - _859) * _853)) * 1.75f);
      float _882 = _881 * 0.3333333432674408f;
      float _883 = _868 + -0.4000000059604645f;
      float _884 = _883 * 5.0f;
      float _888 = max((1.0f - abs(_883 * 2.5f)), 0.0f);
      float _899 = ((float((int)(((int)(uint)((bool)(_884 > 0.0f))) - ((int)(uint)((bool)(_884 < 0.0f))))) * (1.0f - (_888 * _888))) + 1.0f) * 0.02500000037252903f;
      do {
        if (!(_882 <= 0.0533333346247673f)) {
          if (!(_882 >= 0.1599999964237213f)) {
            _908 = (((0.23999999463558197f / _881) + -0.5f) * _899);
          } else {
            _908 = 0.0f;
          }
        } else {
          _908 = _899;
        }
        float _909 = _908 + 1.0f;
        float _910 = _909 * _853;
        float _911 = _909 * _856;
        float _912 = _909 * _859;
        do {
          if (!((bool)(_910 == _911) && (bool)(_911 == _912))) {
            float _919 = ((_910 * 2.0f) - _911) - _912;
            float _922 = ((_856 - _859) * 1.7320507764816284f) * _909;
            float _924 = atan(_922 / _919);
            bool _927 = (_919 < 0.0f);
            bool _928 = (_919 == 0.0f);
            bool _929 = (_922 >= 0.0f);
            bool _930 = (_922 < 0.0f);
            _941 = select((_929 && _928), 90.0f, select((_930 && _928), -90.0f, (select((_930 && _927), (_924 + -3.1415927410125732f), select((_929 && _927), (_924 + 3.1415927410125732f), _924)) * 57.2957763671875f)));
          } else {
            _941 = 0.0f;
          }
          float _946 = min(max(select((_941 < 0.0f), (_941 + 360.0f), _941), 0.0f), 360.0f);
          do {
            if (_946 < -180.0f) {
              _955 = (_946 + 360.0f);
            } else {
              if (_946 > 180.0f) {
                _955 = (_946 + -360.0f);
              } else {
                _955 = _946;
              }
            }
            float _959 = saturate(1.0f - abs(_955 * 0.014814814552664757f));
            float _963 = (_959 * _959) * (3.0f - (_959 * 2.0f));
            float _969 = ((_963 * _963) * ((_868 * 0.18000000715255737f) * (0.029999999329447746f - _910))) + _910;
            float _979 = max(0.0f, mad(-0.21492856740951538f, _912, mad(-0.2365107536315918f, _911, (_969 * 1.4514392614364624f))));
            float _980 = max(0.0f, mad(-0.09967592358589172f, _912, mad(1.17622971534729f, _911, (_969 * -0.07655377686023712f))));
            float _981 = max(0.0f, mad(0.9977163076400757f, _912, mad(-0.006032449658960104f, _911, (_969 * 0.008316148072481155f))));
            float _982 = dot(float3(_979, _980, _981), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _997 = (cb0_040x + 1.0f) - cb0_039z;
            float _999 = cb0_040y + 1.0f;
            float _1001 = _999 - cb0_039w;
            do {
              if (cb0_039z > 0.800000011920929f) {
                _1019 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
              } else {
                float _1010 = (cb0_040x + 0.18000000715255737f) / _997;
                _1019 = (-0.7447274923324585f - ((log2(_1010 / (2.0f - _1010)) * 0.3465735912322998f) * (_997 / cb0_039y)));
              }
              float _1022 = ((1.0f - cb0_039z) / cb0_039y) - _1019;
              float _1024 = (cb0_039w / cb0_039y) - _1022;
              float _1028 = log2(lerp(_982, _979, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1029 = log2(lerp(_982, _980, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1030 = log2(lerp(_982, _981, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1034 = cb0_039y * (_1028 + _1022);
              float _1035 = cb0_039y * (_1029 + _1022);
              float _1036 = cb0_039y * (_1030 + _1022);
              float _1037 = _997 * 2.0f;
              float _1039 = (cb0_039y * -2.0f) / _997;
              float _1040 = _1028 - _1019;
              float _1041 = _1029 - _1019;
              float _1042 = _1030 - _1019;
              float _1061 = _1001 * 2.0f;
              float _1063 = (cb0_039y * 2.0f) / _1001;
              float _1088 = select((_1028 < _1019), ((_1037 / (exp2((_1040 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_040x), _1034);
              float _1089 = select((_1029 < _1019), ((_1037 / (exp2((_1041 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_040x), _1035);
              float _1090 = select((_1030 < _1019), ((_1037 / (exp2((_1042 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_040x), _1036);
              float _1097 = _1024 - _1019;
              float _1101 = saturate(_1040 / _1097);
              float _1102 = saturate(_1041 / _1097);
              float _1103 = saturate(_1042 / _1097);
              bool _1104 = (_1024 < _1019);
              float _1108 = select(_1104, (1.0f - _1101), _1101);
              float _1109 = select(_1104, (1.0f - _1102), _1102);
              float _1110 = select(_1104, (1.0f - _1103), _1103);
              float _1129 = (((_1108 * _1108) * (select((_1028 > _1024), (_999 - (_1061 / (exp2(((_1028 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
              float _1130 = (((_1109 * _1109) * (select((_1029 > _1024), (_999 - (_1061 / (exp2(((_1029 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1035) - _1089)) * (3.0f - (_1109 * 2.0f))) + _1089;
              float _1131 = (((_1110 * _1110) * (select((_1030 > _1024), (_999 - (_1061 / (exp2(((_1030 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1036) - _1090)) * (3.0f - (_1110 * 2.0f))) + _1090;
              float _1132 = dot(float3(_1129, _1130, _1131), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _1152 = (cb0_039x * (max(0.0f, (lerp(_1132, _1129, 0.9300000071525574f))) - _848)) + _848;
              float _1153 = (cb0_039x * (max(0.0f, (lerp(_1132, _1130, 0.9300000071525574f))) - _849)) + _849;
              float _1154 = (cb0_039x * (max(0.0f, (lerp(_1132, _1131, 0.9300000071525574f))) - _850)) + _850;
              float _1170 = ((mad(-0.06537103652954102f, _1154, mad(1.451815478503704e-06f, _1153, (_1152 * 1.065374732017517f))) - _1152) * cb0_038z) + _1152;
              float _1171 = ((mad(-0.20366770029067993f, _1154, mad(1.2036634683609009f, _1153, (_1152 * -2.57161445915699e-07f))) - _1153) * cb0_038z) + _1153;
              float _1172 = ((mad(0.9999996423721313f, _1154, mad(2.0954757928848267e-08f, _1153, (_1152 * 1.862645149230957e-08f))) - _1154) * cb0_038z) + _1154;
              SetTonemappedAP1(_1170, _1171, _1172);

              float _1185 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1172, mad((WorkingColorSpace_192[0].y), _1171, ((WorkingColorSpace_192[0].x) * _1170)))));
              float _1186 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1172, mad((WorkingColorSpace_192[1].y), _1171, ((WorkingColorSpace_192[1].x) * _1170)))));
              float _1187 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1172, mad((WorkingColorSpace_192[2].y), _1171, ((WorkingColorSpace_192[2].x) * _1170)))));
              do {
                if (_1185 < 0.0031306699384003878f) {
                  _1198 = (_1185 * 12.920000076293945f);
                } else {
                  _1198 = (((pow(_1185, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                do {
                  if (_1186 < 0.0031306699384003878f) {
                    _1209 = (_1186 * 12.920000076293945f);
                  } else {
                    _1209 = (((pow(_1186, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    if (_1187 < 0.0031306699384003878f) {
                      _1220 = (_1187 * 12.920000076293945f);
                    } else {
                      _1220 = (((pow(_1187, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    float _1224 = (_1209 * 0.9375f) + 0.03125f;
                    float _1231 = _1220 * 15.0f;
                    float _1232 = floor(_1231);
                    float _1233 = _1231 - _1232;
                    float _1235 = (((_1198 * 0.9375f) + 0.03125f) + _1232) * 0.0625f;
                    float4 _1238 = t0.Sample(s0, float2(_1235, _1224));
                    float4 _1245 = t0.Sample(s0, float2((_1235 + 0.0625f), _1224));
                    float _1261 = ((lerp(_1238.x, _1245.x, _1233)) * cb0_005y) + (cb0_005x * _1198);
                    float _1262 = ((lerp(_1238.y, _1245.y, _1233)) * cb0_005y) + (cb0_005x * _1209);
                    float _1263 = ((lerp(_1238.z, _1245.z, _1233)) * cb0_005y) + (cb0_005x * _1220);
                    float _1288 = select((_1261 > 0.040449999272823334f), exp2(log2((abs(_1261) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1261 * 0.07739938050508499f));
                    float _1289 = select((_1262 > 0.040449999272823334f), exp2(log2((abs(_1262) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1262 * 0.07739938050508499f));
                    float _1290 = select((_1263 > 0.040449999272823334f), exp2(log2((abs(_1263) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1263 * 0.07739938050508499f));
                    float _1316 = cb0_016x * (((cb0_041y + (cb0_041x * _1288)) * _1288) + cb0_041z);
                    float _1317 = cb0_016y * (((cb0_041y + (cb0_041x * _1289)) * _1289) + cb0_041z);
                    float _1318 = cb0_016z * (((cb0_041y + (cb0_041x * _1290)) * _1290) + cb0_041z);
                    float _1325 = ((cb0_015x - _1316) * cb0_015w) + _1316;
                    float _1326 = ((cb0_015y - _1317) * cb0_015w) + _1317;
                    float _1327 = ((cb0_015z - _1318) * cb0_015w) + _1318;
                    float _1328 = cb0_016x * mad((WorkingColorSpace_192[0].z), _812, mad((WorkingColorSpace_192[0].y), _810, (_808 * (WorkingColorSpace_192[0].x))));
                    float _1329 = cb0_016y * mad((WorkingColorSpace_192[1].z), _812, mad((WorkingColorSpace_192[1].y), _810, ((WorkingColorSpace_192[1].x) * _808)));
                    float _1330 = cb0_016z * mad((WorkingColorSpace_192[2].z), _812, mad((WorkingColorSpace_192[2].y), _810, ((WorkingColorSpace_192[2].x) * _808)));
                    float _1337 = ((cb0_015x - _1328) * cb0_015w) + _1328;
                    float _1338 = ((cb0_015y - _1329) * cb0_015w) + _1329;
                    float _1339 = ((cb0_015z - _1330) * cb0_015w) + _1330;
                    float _1351 = exp2(log2(max(0.0f, _1325)) * cb0_042y);
                    float _1352 = exp2(log2(max(0.0f, _1326)) * cb0_042y);
                    float _1353 = exp2(log2(max(0.0f, _1327)) * cb0_042y);

                    if (RENODX_TONE_MAP_TYPE != 0.f) {
                      return GenerateOutput(float3(_1351, _1352, _1353), cb0_042w);
                    }
                    do {
                      [branch]
                      if (cb0_042w == 0) {
                        do {
                          if (WorkingColorSpace_384 == 0) {
                            float _1376 = mad((WorkingColorSpace_128[0].z), _1353, mad((WorkingColorSpace_128[0].y), _1352, ((WorkingColorSpace_128[0].x) * _1351)));
                            float _1379 = mad((WorkingColorSpace_128[1].z), _1353, mad((WorkingColorSpace_128[1].y), _1352, ((WorkingColorSpace_128[1].x) * _1351)));
                            float _1382 = mad((WorkingColorSpace_128[2].z), _1353, mad((WorkingColorSpace_128[2].y), _1352, ((WorkingColorSpace_128[2].x) * _1351)));
                            _1393 = mad(_55, _1382, mad(_54, _1379, (_1376 * _53)));
                            _1394 = mad(_58, _1382, mad(_57, _1379, (_1376 * _56)));
                            _1395 = mad(_61, _1382, mad(_60, _1379, (_1376 * _59)));
                          } else {
                            _1393 = _1351;
                            _1394 = _1352;
                            _1395 = _1353;
                          }
                          do {
                            if (_1393 < 0.0031306699384003878f) {
                              _1406 = (_1393 * 12.920000076293945f);
                            } else {
                              _1406 = (((pow(_1393, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            }
                            do {
                              if (_1394 < 0.0031306699384003878f) {
                                _1417 = (_1394 * 12.920000076293945f);
                              } else {
                                _1417 = (((pow(_1394, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              }
                              if (_1395 < 0.0031306699384003878f) {
                                _2968 = _1406;
                                _2969 = _1417;
                                _2970 = (_1395 * 12.920000076293945f);
                              } else {
                                _2968 = _1406;
                                _2969 = _1417;
                                _2970 = (((pow(_1395, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              }
                            } while (false);
                          } while (false);
                        } while (false);
                      } else {
                        if (cb0_042w == 1) {
                          float _1444 = mad((WorkingColorSpace_128[0].z), _1353, mad((WorkingColorSpace_128[0].y), _1352, ((WorkingColorSpace_128[0].x) * _1351)));
                          float _1447 = mad((WorkingColorSpace_128[1].z), _1353, mad((WorkingColorSpace_128[1].y), _1352, ((WorkingColorSpace_128[1].x) * _1351)));
                          float _1450 = mad((WorkingColorSpace_128[2].z), _1353, mad((WorkingColorSpace_128[2].y), _1352, ((WorkingColorSpace_128[2].x) * _1351)));
                          float _1453 = mad(_55, _1450, mad(_54, _1447, (_1444 * _53)));
                          float _1456 = mad(_58, _1450, mad(_57, _1447, (_1444 * _56)));
                          float _1459 = mad(_61, _1450, mad(_60, _1447, (_1444 * _59)));
                          _2968 = min((_1453 * 4.5f), ((exp2(log2(max(_1453, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                          _2969 = min((_1456 * 4.5f), ((exp2(log2(max(_1456, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                          _2970 = min((_1459 * 4.5f), ((exp2(log2(max(_1459, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                        } else {
                          if ((uint)((uint)((int)(cb0_042w) + -3u)) < (uint)2) {
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
                            float _1534 = cb0_012z * _1337;
                            float _1535 = cb0_012z * _1338;
                            float _1536 = cb0_012z * _1339;
                            float _1539 = mad((WorkingColorSpace_256[0].z), _1536, mad((WorkingColorSpace_256[0].y), _1535, ((WorkingColorSpace_256[0].x) * _1534)));
                            float _1542 = mad((WorkingColorSpace_256[1].z), _1536, mad((WorkingColorSpace_256[1].y), _1535, ((WorkingColorSpace_256[1].x) * _1534)));
                            float _1545 = mad((WorkingColorSpace_256[2].z), _1536, mad((WorkingColorSpace_256[2].y), _1535, ((WorkingColorSpace_256[2].x) * _1534)));
                            float _1548 = mad(-0.21492856740951538f, _1545, mad(-0.2365107536315918f, _1542, (_1539 * 1.4514392614364624f)));
                            float _1551 = mad(-0.09967592358589172f, _1545, mad(1.17622971534729f, _1542, (_1539 * -0.07655377686023712f)));
                            float _1554 = mad(0.9977163076400757f, _1545, mad(-0.006032449658960104f, _1542, (_1539 * 0.008316148072481155f)));
                            float _1556 = max(_1548, max(_1551, _1554));
                            do {
                              if (!(_1556 < 1.000000013351432e-10f)) {
                                if (!(((bool)((bool)(_1539 < 0.0f) || (bool)(_1542 < 0.0f))) || (bool)(_1545 < 0.0f))) {
                                  float _1566 = abs(_1556);
                                  float _1567 = (_1556 - _1548) / _1566;
                                  float _1569 = (_1556 - _1551) / _1566;
                                  float _1571 = (_1556 - _1554) / _1566;
                                  do {
                                    if (!(_1567 < 0.8149999976158142f)) {
                                      float _1574 = _1567 + -0.8149999976158142f;
                                      _1586 = ((_1574 / exp2(log2(exp2(log2(_1574 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                    } else {
                                      _1586 = _1567;
                                    }
                                    do {
                                      if (!(_1569 < 0.8029999732971191f)) {
                                        float _1589 = _1569 + -0.8029999732971191f;
                                        _1601 = ((_1589 / exp2(log2(exp2(log2(_1589 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                      } else {
                                        _1601 = _1569;
                                      }
                                      do {
                                        if (!(_1571 < 0.8799999952316284f)) {
                                          float _1604 = _1571 + -0.8799999952316284f;
                                          _1616 = ((_1604 / exp2(log2(exp2(log2(_1604 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                        } else {
                                          _1616 = _1571;
                                        }
                                        _1624 = (_1556 - (_1566 * _1586));
                                        _1625 = (_1556 - (_1566 * _1601));
                                        _1626 = (_1556 - (_1566 * _1616));
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _1624 = _1548;
                                  _1625 = _1551;
                                  _1626 = _1554;
                                }
                              } else {
                                _1624 = _1548;
                                _1625 = _1551;
                                _1626 = _1554;
                              }
                              float _1642 = ((mad(0.16386906802654266f, _1626, mad(0.14067870378494263f, _1625, (_1624 * 0.6954522132873535f))) - _1539) * cb0_012w) + _1539;
                              float _1643 = ((mad(0.0955343171954155f, _1626, mad(0.8596711158752441f, _1625, (_1624 * 0.044794563204050064f))) - _1542) * cb0_012w) + _1542;
                              float _1644 = ((mad(1.0015007257461548f, _1626, mad(0.004025210160762072f, _1625, (_1624 * -0.005525882821530104f))) - _1545) * cb0_012w) + _1545;
                              float _1648 = max(max(_1642, _1643), _1644);
                              float _1653 = (max(_1648, 1.000000013351432e-10f) - max(min(min(_1642, _1643), _1644), 1.000000013351432e-10f)) / max(_1648, 0.009999999776482582f);
                              float _1666 = ((_1643 + _1642) + _1644) + (sqrt((((_1644 - _1643) * _1644) + ((_1643 - _1642) * _1643)) + ((_1642 - _1644) * _1642)) * 1.75f);
                              float _1667 = _1666 * 0.3333333432674408f;
                              float _1668 = _1653 + -0.4000000059604645f;
                              float _1669 = _1668 * 5.0f;
                              float _1673 = max((1.0f - abs(_1668 * 2.5f)), 0.0f);
                              float _1684 = ((float((int)(((int)(uint)((bool)(_1669 > 0.0f))) - ((int)(uint)((bool)(_1669 < 0.0f))))) * (1.0f - (_1673 * _1673))) + 1.0f) * 0.02500000037252903f;
                              do {
                                if (!(_1667 <= 0.0533333346247673f)) {
                                  if (!(_1667 >= 0.1599999964237213f)) {
                                    _1693 = (((0.23999999463558197f / _1666) + -0.5f) * _1684);
                                  } else {
                                    _1693 = 0.0f;
                                  }
                                } else {
                                  _1693 = _1684;
                                }
                                float _1694 = _1693 + 1.0f;
                                float _1695 = _1694 * _1642;
                                float _1696 = _1694 * _1643;
                                float _1697 = _1694 * _1644;
                                do {
                                  if (!((bool)(_1695 == _1696) && (bool)(_1696 == _1697))) {
                                    float _1704 = ((_1695 * 2.0f) - _1696) - _1697;
                                    float _1707 = ((_1643 - _1644) * 1.7320507764816284f) * _1694;
                                    float _1709 = atan(_1707 / _1704);
                                    bool _1712 = (_1704 < 0.0f);
                                    bool _1713 = (_1704 == 0.0f);
                                    bool _1714 = (_1707 >= 0.0f);
                                    bool _1715 = (_1707 < 0.0f);
                                    _1726 = select((_1714 && _1713), 90.0f, select((_1715 && _1713), -90.0f, (select((_1715 && _1712), (_1709 + -3.1415927410125732f), select((_1714 && _1712), (_1709 + 3.1415927410125732f), _1709)) * 57.2957763671875f)));
                                  } else {
                                    _1726 = 0.0f;
                                  }
                                  float _1731 = min(max(select((_1726 < 0.0f), (_1726 + 360.0f), _1726), 0.0f), 360.0f);
                                  do {
                                    if (_1731 < -180.0f) {
                                      _1740 = (_1731 + 360.0f);
                                    } else {
                                      if (_1731 > 180.0f) {
                                        _1740 = (_1731 + -360.0f);
                                      } else {
                                        _1740 = _1731;
                                      }
                                    }
                                    do {
                                      if ((bool)(_1740 > -67.5f) && (bool)(_1740 < 67.5f)) {
                                        float _1746 = (_1740 + 67.5f) * 0.029629629105329514f;
                                        int _1747 = int(_1746);
                                        float _1749 = _1746 - float((int)(_1747));
                                        float _1750 = _1749 * _1749;
                                        float _1751 = _1750 * _1749;
                                        if (_1747 == 3) {
                                          _1779 = (((0.1666666716337204f - (_1749 * 0.5f)) + (_1750 * 0.5f)) - (_1751 * 0.1666666716337204f));
                                        } else {
                                          if (_1747 == 2) {
                                            _1779 = ((0.6666666865348816f - _1750) + (_1751 * 0.5f));
                                          } else {
                                            if (_1747 == 1) {
                                              _1779 = (((_1751 * -0.5f) + 0.1666666716337204f) + ((_1750 + _1749) * 0.5f));
                                            } else {
                                              _1779 = select((_1747 == 0), (_1751 * 0.1666666716337204f), 0.0f);
                                            }
                                          }
                                        }
                                      } else {
                                        _1779 = 0.0f;
                                      }
                                      float _1788 = min(max(((((_1653 * 0.27000001072883606f) * (0.029999999329447746f - _1695)) * _1779) + _1695), 0.0f), 65535.0f);
                                      float _1789 = min(max(_1696, 0.0f), 65535.0f);
                                      float _1790 = min(max(_1697, 0.0f), 65535.0f);
                                      float _1803 = min(max(mad(-0.21492856740951538f, _1790, mad(-0.2365107536315918f, _1789, (_1788 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                      float _1804 = min(max(mad(-0.09967592358589172f, _1790, mad(1.17622971534729f, _1789, (_1788 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                      float _1805 = min(max(mad(0.9977163076400757f, _1790, mad(-0.006032449658960104f, _1789, (_1788 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                      float _1806 = dot(float3(_1803, _1804, _1805), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                      float _1829 = log2(max((lerp(_1806, _1803, 0.9599999785423279f)), 1.000000013351432e-10f));
                                      float _1830 = _1829 * 0.3010300099849701f;
                                      float _1831 = log2(cb0_008x);
                                      float _1832 = _1831 * 0.3010300099849701f;
                                      do {
                                        if (!(!(_1830 <= _1832))) {
                                          _1901 = (log2(cb0_008y) * 0.3010300099849701f);
                                        } else {
                                          float _1839 = log2(cb0_009x);
                                          float _1840 = _1839 * 0.3010300099849701f;
                                          if ((bool)(_1830 > _1832) && (bool)(_1830 < _1840)) {
                                            float _1848 = ((_1829 - _1831) * 0.9030900001525879f) / ((_1839 - _1831) * 0.3010300099849701f);
                                            int _1849 = int(_1848);
                                            float _1851 = _1848 - float((int)(_1849));
                                            float _1853 = _18[_1849];
                                            float _1856 = _18[(_1849 + 1)];
                                            float _1861 = _1853 * 0.5f;
                                            _1901 = dot(float3((_1851 * _1851), _1851, 1.0f), float3(mad((_18[(_1849 + 2)]), 0.5f, mad(_1856, -1.0f, _1861)), (_1856 - _1853), mad(_1856, 0.5f, _1861)));
                                          } else {
                                            do {
                                              if (!(!(_1830 >= _1840))) {
                                                float _1870 = log2(cb0_008z);
                                                if (_1830 < (_1870 * 0.3010300099849701f)) {
                                                  float _1878 = ((_1829 - _1839) * 0.9030900001525879f) / ((_1870 - _1839) * 0.3010300099849701f);
                                                  int _1879 = int(_1878);
                                                  float _1881 = _1878 - float((int)(_1879));
                                                  float _1883 = _19[_1879];
                                                  float _1886 = _19[(_1879 + 1)];
                                                  float _1891 = _1883 * 0.5f;
                                                  _1901 = dot(float3((_1881 * _1881), _1881, 1.0f), float3(mad((_19[(_1879 + 2)]), 0.5f, mad(_1886, -1.0f, _1891)), (_1886 - _1883), mad(_1886, 0.5f, _1891)));
                                                  break;
                                                }
                                              }
                                              _1901 = (log2(cb0_008w) * 0.3010300099849701f);
                                            } while (false);
                                          }
                                        }
                                        _20[0] = cb0_010x;
                                        _20[1] = cb0_010y;
                                        _20[2] = cb0_010z;
                                        _20[3] = cb0_010w;
                                        _20[4] = cb0_012x;
                                        _20[5] = cb0_012x;
                                        _21[0] = cb0_011x;
                                        _21[1] = cb0_011y;
                                        _21[2] = cb0_011z;
                                        _21[3] = cb0_011w;
                                        _21[4] = cb0_012y;
                                        _21[5] = cb0_012y;
                                        float _1917 = log2(max((lerp(_1806, _1804, 0.9599999785423279f)), 1.000000013351432e-10f));
                                        float _1918 = _1917 * 0.3010300099849701f;
                                        do {
                                          if (!(!(_1918 <= _1832))) {
                                            _1987 = (log2(cb0_008y) * 0.3010300099849701f);
                                          } else {
                                            float _1925 = log2(cb0_009x);
                                            float _1926 = _1925 * 0.3010300099849701f;
                                            if ((bool)(_1918 > _1832) && (bool)(_1918 < _1926)) {
                                              float _1934 = ((_1917 - _1831) * 0.9030900001525879f) / ((_1925 - _1831) * 0.3010300099849701f);
                                              int _1935 = int(_1934);
                                              float _1937 = _1934 - float((int)(_1935));
                                              float _1939 = _20[_1935];
                                              float _1942 = _20[(_1935 + 1)];
                                              float _1947 = _1939 * 0.5f;
                                              _1987 = dot(float3((_1937 * _1937), _1937, 1.0f), float3(mad((_20[(_1935 + 2)]), 0.5f, mad(_1942, -1.0f, _1947)), (_1942 - _1939), mad(_1942, 0.5f, _1947)));
                                            } else {
                                              do {
                                                if (!(!(_1918 >= _1926))) {
                                                  float _1956 = log2(cb0_008z);
                                                  if (_1918 < (_1956 * 0.3010300099849701f)) {
                                                    float _1964 = ((_1917 - _1925) * 0.9030900001525879f) / ((_1956 - _1925) * 0.3010300099849701f);
                                                    int _1965 = int(_1964);
                                                    float _1967 = _1964 - float((int)(_1965));
                                                    float _1969 = _21[_1965];
                                                    float _1972 = _21[(_1965 + 1)];
                                                    float _1977 = _1969 * 0.5f;
                                                    _1987 = dot(float3((_1967 * _1967), _1967, 1.0f), float3(mad((_21[(_1965 + 2)]), 0.5f, mad(_1972, -1.0f, _1977)), (_1972 - _1969), mad(_1972, 0.5f, _1977)));
                                                    break;
                                                  }
                                                }
                                                _1987 = (log2(cb0_008w) * 0.3010300099849701f);
                                              } while (false);
                                            }
                                          }
                                          float _1991 = log2(max((lerp(_1806, _1805, 0.9599999785423279f)), 1.000000013351432e-10f));
                                          float _1992 = _1991 * 0.3010300099849701f;
                                          do {
                                            if (!(!(_1992 <= _1832))) {
                                              _2061 = (log2(cb0_008y) * 0.3010300099849701f);
                                            } else {
                                              float _1999 = log2(cb0_009x);
                                              float _2000 = _1999 * 0.3010300099849701f;
                                              if ((bool)(_1992 > _1832) && (bool)(_1992 < _2000)) {
                                                float _2008 = ((_1991 - _1831) * 0.9030900001525879f) / ((_1999 - _1831) * 0.3010300099849701f);
                                                int _2009 = int(_2008);
                                                float _2011 = _2008 - float((int)(_2009));
                                                float _2013 = _10[_2009];
                                                float _2016 = _10[(_2009 + 1)];
                                                float _2021 = _2013 * 0.5f;
                                                _2061 = dot(float3((_2011 * _2011), _2011, 1.0f), float3(mad((_10[(_2009 + 2)]), 0.5f, mad(_2016, -1.0f, _2021)), (_2016 - _2013), mad(_2016, 0.5f, _2021)));
                                              } else {
                                                do {
                                                  if (!(!(_1992 >= _2000))) {
                                                    float _2030 = log2(cb0_008z);
                                                    if (_1992 < (_2030 * 0.3010300099849701f)) {
                                                      float _2038 = ((_1991 - _1999) * 0.9030900001525879f) / ((_2030 - _1999) * 0.3010300099849701f);
                                                      int _2039 = int(_2038);
                                                      float _2041 = _2038 - float((int)(_2039));
                                                      float _2043 = _11[_2039];
                                                      float _2046 = _11[(_2039 + 1)];
                                                      float _2051 = _2043 * 0.5f;
                                                      _2061 = dot(float3((_2041 * _2041), _2041, 1.0f), float3(mad((_11[(_2039 + 2)]), 0.5f, mad(_2046, -1.0f, _2051)), (_2046 - _2043), mad(_2046, 0.5f, _2051)));
                                                      break;
                                                    }
                                                  }
                                                  _2061 = (log2(cb0_008w) * 0.3010300099849701f);
                                                } while (false);
                                              }
                                            }
                                            float _2065 = cb0_008w - cb0_008y;
                                            float _2066 = (exp2(_1901 * 3.321928024291992f) - cb0_008y) / _2065;
                                            float _2068 = (exp2(_1987 * 3.321928024291992f) - cb0_008y) / _2065;
                                            float _2070 = (exp2(_2061 * 3.321928024291992f) - cb0_008y) / _2065;
                                            float _2073 = mad(0.15618768334388733f, _2070, mad(0.13400420546531677f, _2068, (_2066 * 0.6624541878700256f)));
                                            float _2076 = mad(0.053689517080783844f, _2070, mad(0.6740817427635193f, _2068, (_2066 * 0.2722287178039551f)));
                                            float _2079 = mad(1.0103391408920288f, _2070, mad(0.00406073359772563f, _2068, (_2066 * -0.005574649665504694f)));
                                            float _2092 = min(max(mad(-0.23642469942569733f, _2079, mad(-0.32480329275131226f, _2076, (_2073 * 1.6410233974456787f))), 0.0f), 1.0f);
                                            float _2093 = min(max(mad(0.016756348311901093f, _2079, mad(1.6153316497802734f, _2076, (_2073 * -0.663662850856781f))), 0.0f), 1.0f);
                                            float _2094 = min(max(mad(0.9883948564529419f, _2079, mad(-0.008284442126750946f, _2076, (_2073 * 0.011721894145011902f))), 0.0f), 1.0f);
                                            float _2097 = mad(0.15618768334388733f, _2094, mad(0.13400420546531677f, _2093, (_2092 * 0.6624541878700256f)));
                                            float _2100 = mad(0.053689517080783844f, _2094, mad(0.6740817427635193f, _2093, (_2092 * 0.2722287178039551f)));
                                            float _2103 = mad(1.0103391408920288f, _2094, mad(0.00406073359772563f, _2093, (_2092 * -0.005574649665504694f)));
                                            float _2125 = min(max((min(max(mad(-0.23642469942569733f, _2103, mad(-0.32480329275131226f, _2100, (_2097 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                            float _2126 = min(max((min(max(mad(0.016756348311901093f, _2103, mad(1.6153316497802734f, _2100, (_2097 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                            float _2127 = min(max((min(max(mad(0.9883948564529419f, _2103, mad(-0.008284442126750946f, _2100, (_2097 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                            float _2146 = exp2(log2(mad(_55, _2127, mad(_54, _2126, (_2125 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                            float _2147 = exp2(log2(mad(_58, _2127, mad(_57, _2126, (_2125 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                            float _2148 = exp2(log2(mad(_61, _2127, mad(_60, _2126, (_2125 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                            _2968 = exp2(log2((1.0f / ((_2146 * 18.6875f) + 1.0f)) * ((_2146 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                            _2969 = exp2(log2((1.0f / ((_2147 * 18.6875f) + 1.0f)) * ((_2147 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                            _2970 = exp2(log2((1.0f / ((_2148 * 18.6875f) + 1.0f)) * ((_2148 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
                              float _2214 = cb0_012z * _1337;
                              float _2215 = cb0_012z * _1338;
                              float _2216 = cb0_012z * _1339;
                              float _2219 = mad((WorkingColorSpace_256[0].z), _2216, mad((WorkingColorSpace_256[0].y), _2215, ((WorkingColorSpace_256[0].x) * _2214)));
                              float _2222 = mad((WorkingColorSpace_256[1].z), _2216, mad((WorkingColorSpace_256[1].y), _2215, ((WorkingColorSpace_256[1].x) * _2214)));
                              float _2225 = mad((WorkingColorSpace_256[2].z), _2216, mad((WorkingColorSpace_256[2].y), _2215, ((WorkingColorSpace_256[2].x) * _2214)));
                              float _2228 = mad(-0.21492856740951538f, _2225, mad(-0.2365107536315918f, _2222, (_2219 * 1.4514392614364624f)));
                              float _2231 = mad(-0.09967592358589172f, _2225, mad(1.17622971534729f, _2222, (_2219 * -0.07655377686023712f)));
                              float _2234 = mad(0.9977163076400757f, _2225, mad(-0.006032449658960104f, _2222, (_2219 * 0.008316148072481155f)));
                              float _2236 = max(_2228, max(_2231, _2234));
                              do {
                                if (!(_2236 < 1.000000013351432e-10f)) {
                                  if (!(((bool)((bool)(_2219 < 0.0f) || (bool)(_2222 < 0.0f))) || (bool)(_2225 < 0.0f))) {
                                    float _2246 = abs(_2236);
                                    float _2247 = (_2236 - _2228) / _2246;
                                    float _2249 = (_2236 - _2231) / _2246;
                                    float _2251 = (_2236 - _2234) / _2246;
                                    do {
                                      if (!(_2247 < 0.8149999976158142f)) {
                                        float _2254 = _2247 + -0.8149999976158142f;
                                        _2266 = ((_2254 / exp2(log2(exp2(log2(_2254 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                      } else {
                                        _2266 = _2247;
                                      }
                                      do {
                                        if (!(_2249 < 0.8029999732971191f)) {
                                          float _2269 = _2249 + -0.8029999732971191f;
                                          _2281 = ((_2269 / exp2(log2(exp2(log2(_2269 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                        } else {
                                          _2281 = _2249;
                                        }
                                        do {
                                          if (!(_2251 < 0.8799999952316284f)) {
                                            float _2284 = _2251 + -0.8799999952316284f;
                                            _2296 = ((_2284 / exp2(log2(exp2(log2(_2284 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                          } else {
                                            _2296 = _2251;
                                          }
                                          _2304 = (_2236 - (_2246 * _2266));
                                          _2305 = (_2236 - (_2246 * _2281));
                                          _2306 = (_2236 - (_2246 * _2296));
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } else {
                                    _2304 = _2228;
                                    _2305 = _2231;
                                    _2306 = _2234;
                                  }
                                } else {
                                  _2304 = _2228;
                                  _2305 = _2231;
                                  _2306 = _2234;
                                }
                                float _2322 = ((mad(0.16386906802654266f, _2306, mad(0.14067870378494263f, _2305, (_2304 * 0.6954522132873535f))) - _2219) * cb0_012w) + _2219;
                                float _2323 = ((mad(0.0955343171954155f, _2306, mad(0.8596711158752441f, _2305, (_2304 * 0.044794563204050064f))) - _2222) * cb0_012w) + _2222;
                                float _2324 = ((mad(1.0015007257461548f, _2306, mad(0.004025210160762072f, _2305, (_2304 * -0.005525882821530104f))) - _2225) * cb0_012w) + _2225;
                                float _2328 = max(max(_2322, _2323), _2324);
                                float _2333 = (max(_2328, 1.000000013351432e-10f) - max(min(min(_2322, _2323), _2324), 1.000000013351432e-10f)) / max(_2328, 0.009999999776482582f);
                                float _2346 = ((_2323 + _2322) + _2324) + (sqrt((((_2324 - _2323) * _2324) + ((_2323 - _2322) * _2323)) + ((_2322 - _2324) * _2322)) * 1.75f);
                                float _2347 = _2346 * 0.3333333432674408f;
                                float _2348 = _2333 + -0.4000000059604645f;
                                float _2349 = _2348 * 5.0f;
                                float _2353 = max((1.0f - abs(_2348 * 2.5f)), 0.0f);
                                float _2364 = ((float((int)(((int)(uint)((bool)(_2349 > 0.0f))) - ((int)(uint)((bool)(_2349 < 0.0f))))) * (1.0f - (_2353 * _2353))) + 1.0f) * 0.02500000037252903f;
                                do {
                                  if (!(_2347 <= 0.0533333346247673f)) {
                                    if (!(_2347 >= 0.1599999964237213f)) {
                                      _2373 = (((0.23999999463558197f / _2346) + -0.5f) * _2364);
                                    } else {
                                      _2373 = 0.0f;
                                    }
                                  } else {
                                    _2373 = _2364;
                                  }
                                  float _2374 = _2373 + 1.0f;
                                  float _2375 = _2374 * _2322;
                                  float _2376 = _2374 * _2323;
                                  float _2377 = _2374 * _2324;
                                  do {
                                    if (!((bool)(_2375 == _2376) && (bool)(_2376 == _2377))) {
                                      float _2384 = ((_2375 * 2.0f) - _2376) - _2377;
                                      float _2387 = ((_2323 - _2324) * 1.7320507764816284f) * _2374;
                                      float _2389 = atan(_2387 / _2384);
                                      bool _2392 = (_2384 < 0.0f);
                                      bool _2393 = (_2384 == 0.0f);
                                      bool _2394 = (_2387 >= 0.0f);
                                      bool _2395 = (_2387 < 0.0f);
                                      _2406 = select((_2394 && _2393), 90.0f, select((_2395 && _2393), -90.0f, (select((_2395 && _2392), (_2389 + -3.1415927410125732f), select((_2394 && _2392), (_2389 + 3.1415927410125732f), _2389)) * 57.2957763671875f)));
                                    } else {
                                      _2406 = 0.0f;
                                    }
                                    float _2411 = min(max(select((_2406 < 0.0f), (_2406 + 360.0f), _2406), 0.0f), 360.0f);
                                    do {
                                      if (_2411 < -180.0f) {
                                        _2420 = (_2411 + 360.0f);
                                      } else {
                                        if (_2411 > 180.0f) {
                                          _2420 = (_2411 + -360.0f);
                                        } else {
                                          _2420 = _2411;
                                        }
                                      }
                                      do {
                                        if ((bool)(_2420 > -67.5f) && (bool)(_2420 < 67.5f)) {
                                          float _2426 = (_2420 + 67.5f) * 0.029629629105329514f;
                                          int _2427 = int(_2426);
                                          float _2429 = _2426 - float((int)(_2427));
                                          float _2430 = _2429 * _2429;
                                          float _2431 = _2430 * _2429;
                                          if (_2427 == 3) {
                                            _2459 = (((0.1666666716337204f - (_2429 * 0.5f)) + (_2430 * 0.5f)) - (_2431 * 0.1666666716337204f));
                                          } else {
                                            if (_2427 == 2) {
                                              _2459 = ((0.6666666865348816f - _2430) + (_2431 * 0.5f));
                                            } else {
                                              if (_2427 == 1) {
                                                _2459 = (((_2431 * -0.5f) + 0.1666666716337204f) + ((_2430 + _2429) * 0.5f));
                                              } else {
                                                _2459 = select((_2427 == 0), (_2431 * 0.1666666716337204f), 0.0f);
                                              }
                                            }
                                          }
                                        } else {
                                          _2459 = 0.0f;
                                        }
                                        float _2468 = min(max(((((_2333 * 0.27000001072883606f) * (0.029999999329447746f - _2375)) * _2459) + _2375), 0.0f), 65535.0f);
                                        float _2469 = min(max(_2376, 0.0f), 65535.0f);
                                        float _2470 = min(max(_2377, 0.0f), 65535.0f);
                                        float _2483 = min(max(mad(-0.21492856740951538f, _2470, mad(-0.2365107536315918f, _2469, (_2468 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                        float _2484 = min(max(mad(-0.09967592358589172f, _2470, mad(1.17622971534729f, _2469, (_2468 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                        float _2485 = min(max(mad(0.9977163076400757f, _2470, mad(-0.006032449658960104f, _2469, (_2468 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                        float _2486 = dot(float3(_2483, _2484, _2485), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                        float _2509 = log2(max((lerp(_2486, _2483, 0.9599999785423279f)), 1.000000013351432e-10f));
                                        float _2510 = _2509 * 0.3010300099849701f;
                                        float _2511 = log2(cb0_008x);
                                        float _2512 = _2511 * 0.3010300099849701f;
                                        do {
                                          if (!(!(_2510 <= _2512))) {
                                            _2581 = (log2(cb0_008y) * 0.3010300099849701f);
                                          } else {
                                            float _2519 = log2(cb0_009x);
                                            float _2520 = _2519 * 0.3010300099849701f;
                                            if ((bool)(_2510 > _2512) && (bool)(_2510 < _2520)) {
                                              float _2528 = ((_2509 - _2511) * 0.9030900001525879f) / ((_2519 - _2511) * 0.3010300099849701f);
                                              int _2529 = int(_2528);
                                              float _2531 = _2528 - float((int)(_2529));
                                              float _2533 = _16[_2529];
                                              float _2536 = _16[(_2529 + 1)];
                                              float _2541 = _2533 * 0.5f;
                                              _2581 = dot(float3((_2531 * _2531), _2531, 1.0f), float3(mad((_16[(_2529 + 2)]), 0.5f, mad(_2536, -1.0f, _2541)), (_2536 - _2533), mad(_2536, 0.5f, _2541)));
                                            } else {
                                              do {
                                                if (!(!(_2510 >= _2520))) {
                                                  float _2550 = log2(cb0_008z);
                                                  if (_2510 < (_2550 * 0.3010300099849701f)) {
                                                    float _2558 = ((_2509 - _2519) * 0.9030900001525879f) / ((_2550 - _2519) * 0.3010300099849701f);
                                                    int _2559 = int(_2558);
                                                    float _2561 = _2558 - float((int)(_2559));
                                                    float _2563 = _17[_2559];
                                                    float _2566 = _17[(_2559 + 1)];
                                                    float _2571 = _2563 * 0.5f;
                                                    _2581 = dot(float3((_2561 * _2561), _2561, 1.0f), float3(mad((_17[(_2559 + 2)]), 0.5f, mad(_2566, -1.0f, _2571)), (_2566 - _2563), mad(_2566, 0.5f, _2571)));
                                                    break;
                                                  }
                                                }
                                                _2581 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                          float _2597 = log2(max((lerp(_2486, _2484, 0.9599999785423279f)), 1.000000013351432e-10f));
                                          float _2598 = _2597 * 0.3010300099849701f;
                                          do {
                                            if (!(!(_2598 <= _2512))) {
                                              _2667 = (log2(cb0_008y) * 0.3010300099849701f);
                                            } else {
                                              float _2605 = log2(cb0_009x);
                                              float _2606 = _2605 * 0.3010300099849701f;
                                              if ((bool)(_2598 > _2512) && (bool)(_2598 < _2606)) {
                                                float _2614 = ((_2597 - _2511) * 0.9030900001525879f) / ((_2605 - _2511) * 0.3010300099849701f);
                                                int _2615 = int(_2614);
                                                float _2617 = _2614 - float((int)(_2615));
                                                float _2619 = _12[_2615];
                                                float _2622 = _12[(_2615 + 1)];
                                                float _2627 = _2619 * 0.5f;
                                                _2667 = dot(float3((_2617 * _2617), _2617, 1.0f), float3(mad((_12[(_2615 + 2)]), 0.5f, mad(_2622, -1.0f, _2627)), (_2622 - _2619), mad(_2622, 0.5f, _2627)));
                                              } else {
                                                do {
                                                  if (!(!(_2598 >= _2606))) {
                                                    float _2636 = log2(cb0_008z);
                                                    if (_2598 < (_2636 * 0.3010300099849701f)) {
                                                      float _2644 = ((_2597 - _2605) * 0.9030900001525879f) / ((_2636 - _2605) * 0.3010300099849701f);
                                                      int _2645 = int(_2644);
                                                      float _2647 = _2644 - float((int)(_2645));
                                                      float _2649 = _13[_2645];
                                                      float _2652 = _13[(_2645 + 1)];
                                                      float _2657 = _2649 * 0.5f;
                                                      _2667 = dot(float3((_2647 * _2647), _2647, 1.0f), float3(mad((_13[(_2645 + 2)]), 0.5f, mad(_2652, -1.0f, _2657)), (_2652 - _2649), mad(_2652, 0.5f, _2657)));
                                                      break;
                                                    }
                                                  }
                                                  _2667 = (log2(cb0_008w) * 0.3010300099849701f);
                                                } while (false);
                                              }
                                            }
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
                                            float _2683 = log2(max((lerp(_2486, _2485, 0.9599999785423279f)), 1.000000013351432e-10f));
                                            float _2684 = _2683 * 0.3010300099849701f;
                                            do {
                                              if (!(!(_2684 <= _2512))) {
                                                _2753 = (log2(cb0_008y) * 0.3010300099849701f);
                                              } else {
                                                float _2691 = log2(cb0_009x);
                                                float _2692 = _2691 * 0.3010300099849701f;
                                                if ((bool)(_2684 > _2512) && (bool)(_2684 < _2692)) {
                                                  float _2700 = ((_2683 - _2511) * 0.9030900001525879f) / ((_2691 - _2511) * 0.3010300099849701f);
                                                  int _2701 = int(_2700);
                                                  float _2703 = _2700 - float((int)(_2701));
                                                  float _2705 = _14[_2701];
                                                  float _2708 = _14[(_2701 + 1)];
                                                  float _2713 = _2705 * 0.5f;
                                                  _2753 = dot(float3((_2703 * _2703), _2703, 1.0f), float3(mad((_14[(_2701 + 2)]), 0.5f, mad(_2708, -1.0f, _2713)), (_2708 - _2705), mad(_2708, 0.5f, _2713)));
                                                } else {
                                                  do {
                                                    if (!(!(_2684 >= _2692))) {
                                                      float _2722 = log2(cb0_008z);
                                                      if (_2684 < (_2722 * 0.3010300099849701f)) {
                                                        float _2730 = ((_2683 - _2691) * 0.9030900001525879f) / ((_2722 - _2691) * 0.3010300099849701f);
                                                        int _2731 = int(_2730);
                                                        float _2733 = _2730 - float((int)(_2731));
                                                        float _2735 = _15[_2731];
                                                        float _2738 = _15[(_2731 + 1)];
                                                        float _2743 = _2735 * 0.5f;
                                                        _2753 = dot(float3((_2733 * _2733), _2733, 1.0f), float3(mad((_15[(_2731 + 2)]), 0.5f, mad(_2738, -1.0f, _2743)), (_2738 - _2735), mad(_2738, 0.5f, _2743)));
                                                        break;
                                                      }
                                                    }
                                                    _2753 = (log2(cb0_008w) * 0.3010300099849701f);
                                                  } while (false);
                                                }
                                              }
                                              float _2757 = cb0_008w - cb0_008y;
                                              float _2758 = (exp2(_2581 * 3.321928024291992f) - cb0_008y) / _2757;
                                              float _2760 = (exp2(_2667 * 3.321928024291992f) - cb0_008y) / _2757;
                                              float _2762 = (exp2(_2753 * 3.321928024291992f) - cb0_008y) / _2757;
                                              float _2765 = mad(0.15618768334388733f, _2762, mad(0.13400420546531677f, _2760, (_2758 * 0.6624541878700256f)));
                                              float _2768 = mad(0.053689517080783844f, _2762, mad(0.6740817427635193f, _2760, (_2758 * 0.2722287178039551f)));
                                              float _2771 = mad(1.0103391408920288f, _2762, mad(0.00406073359772563f, _2760, (_2758 * -0.005574649665504694f)));
                                              float _2784 = min(max(mad(-0.23642469942569733f, _2771, mad(-0.32480329275131226f, _2768, (_2765 * 1.6410233974456787f))), 0.0f), 1.0f);
                                              float _2785 = min(max(mad(0.016756348311901093f, _2771, mad(1.6153316497802734f, _2768, (_2765 * -0.663662850856781f))), 0.0f), 1.0f);
                                              float _2786 = min(max(mad(0.9883948564529419f, _2771, mad(-0.008284442126750946f, _2768, (_2765 * 0.011721894145011902f))), 0.0f), 1.0f);
                                              float _2789 = mad(0.15618768334388733f, _2786, mad(0.13400420546531677f, _2785, (_2784 * 0.6624541878700256f)));
                                              float _2792 = mad(0.053689517080783844f, _2786, mad(0.6740817427635193f, _2785, (_2784 * 0.2722287178039551f)));
                                              float _2795 = mad(1.0103391408920288f, _2786, mad(0.00406073359772563f, _2785, (_2784 * -0.005574649665504694f)));
                                              float _2817 = min(max((min(max(mad(-0.23642469942569733f, _2795, mad(-0.32480329275131226f, _2792, (_2789 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                              float _2820 = min(max((min(max(mad(0.016756348311901093f, _2795, mad(1.6153316497802734f, _2792, (_2789 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                              float _2821 = min(max((min(max(mad(0.9883948564529419f, _2795, mad(-0.008284442126750946f, _2792, (_2789 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                              _2968 = mad(-0.0832589864730835f, _2821, mad(-0.6217921376228333f, _2820, (_2817 * 0.0213131383061409f)));
                                              _2969 = mad(-0.010548308491706848f, _2821, mad(1.140804648399353f, _2820, (_2817 * -0.0016282059950754046f)));
                                              _2970 = mad(1.1529725790023804f, _2821, mad(-0.1289689838886261f, _2820, (_2817 * -0.00030004189466126263f)));
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
                                float _2848 = mad((WorkingColorSpace_128[0].z), _1339, mad((WorkingColorSpace_128[0].y), _1338, ((WorkingColorSpace_128[0].x) * _1337)));
                                float _2851 = mad((WorkingColorSpace_128[1].z), _1339, mad((WorkingColorSpace_128[1].y), _1338, ((WorkingColorSpace_128[1].x) * _1337)));
                                float _2854 = mad((WorkingColorSpace_128[2].z), _1339, mad((WorkingColorSpace_128[2].y), _1338, ((WorkingColorSpace_128[2].x) * _1337)));
                                float _2873 = exp2(log2(mad(_55, _2854, mad(_54, _2851, (_2848 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                float _2874 = exp2(log2(mad(_58, _2854, mad(_57, _2851, (_2848 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                float _2875 = exp2(log2(mad(_61, _2854, mad(_60, _2851, (_2848 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                _2968 = exp2(log2((1.0f / ((_2873 * 18.6875f) + 1.0f)) * ((_2873 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                _2969 = exp2(log2((1.0f / ((_2874 * 18.6875f) + 1.0f)) * ((_2874 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                _2970 = exp2(log2((1.0f / ((_2875 * 18.6875f) + 1.0f)) * ((_2875 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                              } else {
                                if (!(cb0_042w == 8)) {
                                  if (cb0_042w == 9) {
                                    float _2922 = mad((WorkingColorSpace_128[0].z), _1327, mad((WorkingColorSpace_128[0].y), _1326, ((WorkingColorSpace_128[0].x) * _1325)));
                                    float _2925 = mad((WorkingColorSpace_128[1].z), _1327, mad((WorkingColorSpace_128[1].y), _1326, ((WorkingColorSpace_128[1].x) * _1325)));
                                    float _2928 = mad((WorkingColorSpace_128[2].z), _1327, mad((WorkingColorSpace_128[2].y), _1326, ((WorkingColorSpace_128[2].x) * _1325)));
                                    _2968 = mad(_55, _2928, mad(_54, _2925, (_2922 * _53)));
                                    _2969 = mad(_58, _2928, mad(_57, _2925, (_2922 * _56)));
                                    _2970 = mad(_61, _2928, mad(_60, _2925, (_2922 * _59)));
                                  } else {
                                    float _2941 = mad((WorkingColorSpace_128[0].z), _1353, mad((WorkingColorSpace_128[0].y), _1352, ((WorkingColorSpace_128[0].x) * _1351)));
                                    float _2944 = mad((WorkingColorSpace_128[1].z), _1353, mad((WorkingColorSpace_128[1].y), _1352, ((WorkingColorSpace_128[1].x) * _1351)));
                                    float _2947 = mad((WorkingColorSpace_128[2].z), _1353, mad((WorkingColorSpace_128[2].y), _1352, ((WorkingColorSpace_128[2].x) * _1351)));
                                    _2968 = exp2(log2(mad(_55, _2947, mad(_54, _2944, (_2941 * _53)))) * cb0_042z);
                                    _2969 = exp2(log2(mad(_58, _2947, mad(_57, _2944, (_2941 * _56)))) * cb0_042z);
                                    _2970 = exp2(log2(mad(_61, _2947, mad(_60, _2944, (_2941 * _59)))) * cb0_042z);
                                  }
                                } else {
                                  _2968 = _1337;
                                  _2969 = _1338;
                                  _2970 = _1339;
                                }
                              }
                            }
                          }
                        }
                      }
                      SV_Target.x = (_2968 * 0.9523810148239136f);
                      SV_Target.y = (_2969 * 0.9523810148239136f);
                      SV_Target.z = (_2970 * 0.9523810148239136f);
                      SV_Target.w = 0.0f;
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  bool _157 = (cb0_040w != 0);
  float _159 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _176 = (((((2967800.0f - (_159 * 4607000064.0f)) * _159) + 99.11000061035156f) * _159) + 0.24406300485134125f);
  } else {
    _176 = (((((1901800.0f - (_159 * 2006400000.0f)) * _159) + 247.47999572753906f) * _159) + 0.23703999817371368f);
  }
  float _190 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _197 = cb0_037y * cb0_037y;
  float _200 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_197 * 1.6145605741257896e-07f));
  float _205 = ((_190 * 2.0f) + 4.0f) - (_200 * 8.0f);
  float _206 = (_190 * 3.0f) / _205;
  float _208 = (_200 * 2.0f) / _205;
  bool _209 = (cb0_037y < 4000.0f);
  float _218 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _220 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_197 * 1.5317699909210205f)) / (_218 * _218);
  float _227 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _197;
  float _229 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_197 * 308.60699462890625f)) / (_227 * _227);
  float _231 = rsqrt(dot(float2(_220, _229), float2(_220, _229)));
  float _232 = cb0_037z * 0.05000000074505806f;
  float _235 = ((_232 * _229) * _231) + _190;
  float _238 = _200 - ((_232 * _220) * _231);
  float _243 = (4.0f - (_238 * 8.0f)) + (_235 * 2.0f);
  float _249 = (((_235 * 3.0f) / _243) - _206) + select(_209, _206, _176);
  float _250 = (((_238 * 2.0f) / _243) - _208) + select(_209, _208, (((_176 * 2.869999885559082f) + -0.2750000059604645f) - ((_176 * _176) * 3.0f)));
  float _251 = select(_157, _249, 0.3127000033855438f);
  float _252 = select(_157, _250, 0.32899999618530273f);
  float _253 = select(_157, 0.3127000033855438f, _249);
  float _254 = select(_157, 0.32899999618530273f, _250);
  float _255 = max(_252, 1.000000013351432e-10f);
  float _256 = _251 / _255;
  float _259 = ((1.0f - _251) - _252) / _255;
  float _260 = max(_254, 1.000000013351432e-10f);
  float _261 = _253 / _260;
  float _264 = ((1.0f - _253) - _254) / _260;
  float _283 = mad(-0.16140000522136688f, _264, ((_261 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _259, ((_256 * 0.8950999975204468f) + 0.266400009393692f));
  float _284 = mad(0.03669999912381172f, _264, (1.7135000228881836f - (_261 * 0.7501999735832214f))) / mad(0.03669999912381172f, _259, (1.7135000228881836f - (_256 * 0.7501999735832214f)));
  float _285 = mad(1.0296000242233276f, _264, ((_261 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _259, ((_256 * 0.03889999911189079f) + -0.06849999725818634f));
  float _286 = mad(_284, -0.7501999735832214f, 0.0f);
  float _287 = mad(_284, 1.7135000228881836f, 0.0f);
  float _288 = mad(_284, 0.03669999912381172f, -0.0f);
  float _289 = mad(_285, 0.03889999911189079f, 0.0f);
  float _290 = mad(_285, -0.06849999725818634f, 0.0f);
  float _291 = mad(_285, 1.0296000242233276f, 0.0f);
  float _294 = mad(0.1599626988172531f, _289, mad(-0.1470542997121811f, _286, (_283 * 0.883457362651825f)));
  float _297 = mad(0.1599626988172531f, _290, mad(-0.1470542997121811f, _287, (_283 * 0.26293492317199707f)));
  float _300 = mad(0.1599626988172531f, _291, mad(-0.1470542997121811f, _288, (_283 * -0.15930065512657166f)));
  float _303 = mad(0.04929120093584061f, _289, mad(0.5183603167533875f, _286, (_283 * 0.38695648312568665f)));
  float _306 = mad(0.04929120093584061f, _290, mad(0.5183603167533875f, _287, (_283 * 0.11516613513231277f)));
  float _309 = mad(0.04929120093584061f, _291, mad(0.5183603167533875f, _288, (_283 * -0.0697740763425827f)));
  float _312 = mad(0.9684867262840271f, _289, mad(0.04004279896616936f, _286, (_283 * -0.007634039502590895f)));
  float _315 = mad(0.9684867262840271f, _290, mad(0.04004279896616936f, _287, (_283 * -0.0022720457054674625f)));
  float _318 = mad(0.9684867262840271f, _291, mad(0.04004279896616936f, _288, (_283 * 0.0013765322510153055f)));
  float _321 = mad(_300, (WorkingColorSpace_000[2].x), mad(_297, (WorkingColorSpace_000[1].x), (_294 * (WorkingColorSpace_000[0].x))));
  float _324 = mad(_300, (WorkingColorSpace_000[2].y), mad(_297, (WorkingColorSpace_000[1].y), (_294 * (WorkingColorSpace_000[0].y))));
  float _327 = mad(_300, (WorkingColorSpace_000[2].z), mad(_297, (WorkingColorSpace_000[1].z), (_294 * (WorkingColorSpace_000[0].z))));
  float _330 = mad(_309, (WorkingColorSpace_000[2].x), mad(_306, (WorkingColorSpace_000[1].x), (_303 * (WorkingColorSpace_000[0].x))));
  float _333 = mad(_309, (WorkingColorSpace_000[2].y), mad(_306, (WorkingColorSpace_000[1].y), (_303 * (WorkingColorSpace_000[0].y))));
  float _336 = mad(_309, (WorkingColorSpace_000[2].z), mad(_306, (WorkingColorSpace_000[1].z), (_303 * (WorkingColorSpace_000[0].z))));
  float _339 = mad(_318, (WorkingColorSpace_000[2].x), mad(_315, (WorkingColorSpace_000[1].x), (_312 * (WorkingColorSpace_000[0].x))));
  float _342 = mad(_318, (WorkingColorSpace_000[2].y), mad(_315, (WorkingColorSpace_000[1].y), (_312 * (WorkingColorSpace_000[0].y))));
  float _345 = mad(_318, (WorkingColorSpace_000[2].z), mad(_315, (WorkingColorSpace_000[1].z), (_312 * (WorkingColorSpace_000[0].z))));
  _383 = mad(mad((WorkingColorSpace_064[0].z), _345, mad((WorkingColorSpace_064[0].y), _336, (_327 * (WorkingColorSpace_064[0].x)))), _121, mad(mad((WorkingColorSpace_064[0].z), _342, mad((WorkingColorSpace_064[0].y), _333, (_324 * (WorkingColorSpace_064[0].x)))), _120, (mad((WorkingColorSpace_064[0].z), _339, mad((WorkingColorSpace_064[0].y), _330, (_321 * (WorkingColorSpace_064[0].x)))) * _119)));
  _384 = mad(mad((WorkingColorSpace_064[1].z), _345, mad((WorkingColorSpace_064[1].y), _336, (_327 * (WorkingColorSpace_064[1].x)))), _121, mad(mad((WorkingColorSpace_064[1].z), _342, mad((WorkingColorSpace_064[1].y), _333, (_324 * (WorkingColorSpace_064[1].x)))), _120, (mad((WorkingColorSpace_064[1].z), _339, mad((WorkingColorSpace_064[1].y), _330, (_321 * (WorkingColorSpace_064[1].x)))) * _119)));
  _385 = mad(mad((WorkingColorSpace_064[2].z), _345, mad((WorkingColorSpace_064[2].y), _336, (_327 * (WorkingColorSpace_064[2].x)))), _121, mad(mad((WorkingColorSpace_064[2].z), _342, mad((WorkingColorSpace_064[2].y), _333, (_324 * (WorkingColorSpace_064[2].x)))), _120, (mad((WorkingColorSpace_064[2].z), _339, mad((WorkingColorSpace_064[2].y), _330, (_321 * (WorkingColorSpace_064[2].x)))) * _119)));
  float _400 = mad((WorkingColorSpace_128[0].z), _385, mad((WorkingColorSpace_128[0].y), _384, ((WorkingColorSpace_128[0].x) * _383)));
  float _403 = mad((WorkingColorSpace_128[1].z), _385, mad((WorkingColorSpace_128[1].y), _384, ((WorkingColorSpace_128[1].x) * _383)));
  float _406 = mad((WorkingColorSpace_128[2].z), _385, mad((WorkingColorSpace_128[2].y), _384, ((WorkingColorSpace_128[2].x) * _383)));
  SetUngradedAP1(float3(_400, _403, _406));

  float _407 = dot(float3(_400, _403, _406), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _411 = (_400 / _407) + -1.0f;
  float _412 = (_403 / _407) + -1.0f;
  float _413 = (_406 / _407) + -1.0f;
  float _425 = (1.0f - exp2(((_407 * _407) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_411, _412, _413), float3(_411, _412, _413)) * -4.0f));
  float _441 = ((mad(-0.06368321925401688f, _406, mad(-0.3292922377586365f, _403, (_400 * 1.3704125881195068f))) - _400) * _425) + _400;
  float _442 = ((mad(-0.010861365124583244f, _406, mad(1.0970927476882935f, _403, (_400 * -0.08343357592821121f))) - _403) * _425) + _403;
  float _443 = ((mad(1.2036951780319214f, _406, mad(-0.09862580895423889f, _403, (_400 * -0.02579331398010254f))) - _406) * _425) + _406;
  float _444 = dot(float3(_441, _442, _443), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _458 = cb0_021w + cb0_026w;
  float _472 = cb0_020w * cb0_025w;
  float _486 = cb0_019w * cb0_024w;
  float _500 = cb0_018w * cb0_023w;
  float _514 = cb0_017w * cb0_022w;
  float _518 = _441 - _444;
  float _519 = _442 - _444;
  float _520 = _443 - _444;
  float _577 = saturate(_444 / cb0_037w);
  float _581 = (_577 * _577) * (3.0f - (_577 * 2.0f));
  float _582 = 1.0f - _581;
  float _591 = cb0_021w + cb0_036w;
  float _600 = cb0_020w * cb0_035w;
  float _609 = cb0_019w * cb0_034w;
  float _618 = cb0_018w * cb0_033w;
  float _627 = cb0_017w * cb0_032w;
  float _690 = saturate((_444 - cb0_038x) / (cb0_038y - cb0_038x));
  float _694 = (_690 * _690) * (3.0f - (_690 * 2.0f));
  float _703 = cb0_021w + cb0_031w;
  float _712 = cb0_020w * cb0_030w;
  float _721 = cb0_019w * cb0_029w;
  float _730 = cb0_018w * cb0_028w;
  float _739 = cb0_017w * cb0_027w;
  float _797 = _581 - _694;
  float _808 = ((_694 * (((cb0_021x + cb0_036x) + _591) + (((cb0_020x * cb0_035x) * _600) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _618) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _627) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _609)))))) + (_582 * (((cb0_021x + cb0_026x) + _458) + (((cb0_020x * cb0_025x) * _472) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _500) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _514) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _486))))))) + ((((cb0_021x + cb0_031x) + _703) + (((cb0_020x * cb0_030x) * _712) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _730) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _739) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _721))))) * _797);
  float _810 = ((_694 * (((cb0_021y + cb0_036y) + _591) + (((cb0_020y * cb0_035y) * _600) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _618) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _627) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _609)))))) + (_582 * (((cb0_021y + cb0_026y) + _458) + (((cb0_020y * cb0_025y) * _472) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _500) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _514) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _486))))))) + ((((cb0_021y + cb0_031y) + _703) + (((cb0_020y * cb0_030y) * _712) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _730) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _739) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _721))))) * _797);
  float _812 = ((_694 * (((cb0_021z + cb0_036z) + _591) + (((cb0_020z * cb0_035z) * _600) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _618) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _627) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _609)))))) + (_582 * (((cb0_021z + cb0_026z) + _458) + (((cb0_020z * cb0_025z) * _472) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _500) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _514) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _486))))))) + ((((cb0_021z + cb0_031z) + _703) + (((cb0_020z * cb0_030z) * _712) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _730) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _739) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _721))))) * _797);
  SetUntonemappedAP1(float3(_808, _810, _812));

  float _848 = ((mad(0.061360642313957214f, _812, mad(-4.540197551250458e-09f, _810, (_808 * 0.9386394023895264f))) - _808) * cb0_038z) + _808;
  float _849 = ((mad(0.169205904006958f, _812, mad(0.8307942152023315f, _810, (_808 * 6.775371730327606e-08f))) - _810) * cb0_038z) + _810;
  float _850 = (mad(-2.3283064365386963e-10f, _810, (_808 * -9.313225746154785e-10f)) * cb0_038z) + _812;
  float _853 = mad(0.16386905312538147f, _850, mad(0.14067868888378143f, _849, (_848 * 0.6954522132873535f)));
  float _856 = mad(0.0955343246459961f, _850, mad(0.8596711158752441f, _849, (_848 * 0.044794581830501556f)));
  float _859 = mad(1.0015007257461548f, _850, mad(0.004025210160762072f, _849, (_848 * -0.005525882821530104f)));
  float _863 = max(max(_853, _856), _859);
  float _868 = (max(_863, 1.000000013351432e-10f) - max(min(min(_853, _856), _859), 1.000000013351432e-10f)) / max(_863, 0.009999999776482582f);
  float _881 = ((_856 + _853) + _859) + (sqrt((((_859 - _856) * _859) + ((_856 - _853) * _856)) + ((_853 - _859) * _853)) * 1.75f);
  float _882 = _881 * 0.3333333432674408f;
  float _883 = _868 + -0.4000000059604645f;
  float _884 = _883 * 5.0f;
  float _888 = max((1.0f - abs(_883 * 2.5f)), 0.0f);
  float _899 = ((float((int)(((int)(uint)((bool)(_884 > 0.0f))) - ((int)(uint)((bool)(_884 < 0.0f))))) * (1.0f - (_888 * _888))) + 1.0f) * 0.02500000037252903f;
  if (!(_882 <= 0.0533333346247673f)) {
    if (!(_882 >= 0.1599999964237213f)) {
      _908 = (((0.23999999463558197f / _881) + -0.5f) * _899);
    } else {
      _908 = 0.0f;
    }
  } else {
    _908 = _899;
  }
  float _909 = _908 + 1.0f;
  float _910 = _909 * _853;
  float _911 = _909 * _856;
  float _912 = _909 * _859;
  if (!((bool)(_910 == _911) && (bool)(_911 == _912))) {
    float _919 = ((_910 * 2.0f) - _911) - _912;
    float _922 = ((_856 - _859) * 1.7320507764816284f) * _909;
    float _924 = atan(_922 / _919);
    bool _927 = (_919 < 0.0f);
    bool _928 = (_919 == 0.0f);
    bool _929 = (_922 >= 0.0f);
    bool _930 = (_922 < 0.0f);
    _941 = select((_929 && _928), 90.0f, select((_930 && _928), -90.0f, (select((_930 && _927), (_924 + -3.1415927410125732f), select((_929 && _927), (_924 + 3.1415927410125732f), _924)) * 57.2957763671875f)));
  } else {
    _941 = 0.0f;
  }
  float _946 = min(max(select((_941 < 0.0f), (_941 + 360.0f), _941), 0.0f), 360.0f);
  if (_946 < -180.0f) {
    _955 = (_946 + 360.0f);
  } else {
    if (_946 > 180.0f) {
      _955 = (_946 + -360.0f);
    } else {
      _955 = _946;
    }
  }
  float _959 = saturate(1.0f - abs(_955 * 0.014814814552664757f));
  float _963 = (_959 * _959) * (3.0f - (_959 * 2.0f));
  float _969 = ((_963 * _963) * ((_868 * 0.18000000715255737f) * (0.029999999329447746f - _910))) + _910;
  float _979 = max(0.0f, mad(-0.21492856740951538f, _912, mad(-0.2365107536315918f, _911, (_969 * 1.4514392614364624f))));
  float _980 = max(0.0f, mad(-0.09967592358589172f, _912, mad(1.17622971534729f, _911, (_969 * -0.07655377686023712f))));
  float _981 = max(0.0f, mad(0.9977163076400757f, _912, mad(-0.006032449658960104f, _911, (_969 * 0.008316148072481155f))));
  float _982 = dot(float3(_979, _980, _981), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _997 = (cb0_040x + 1.0f) - cb0_039z;
  float _999 = cb0_040y + 1.0f;
  float _1001 = _999 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1019 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    float _1010 = (cb0_040x + 0.18000000715255737f) / _997;
    _1019 = (-0.7447274923324585f - ((log2(_1010 / (2.0f - _1010)) * 0.3465735912322998f) * (_997 / cb0_039y)));
  }
  float _1022 = ((1.0f - cb0_039z) / cb0_039y) - _1019;
  float _1024 = (cb0_039w / cb0_039y) - _1022;
  float _1028 = log2(lerp(_982, _979, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1029 = log2(lerp(_982, _980, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1030 = log2(lerp(_982, _981, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1034 = cb0_039y * (_1028 + _1022);
  float _1035 = cb0_039y * (_1029 + _1022);
  float _1036 = cb0_039y * (_1030 + _1022);
  float _1037 = _997 * 2.0f;
  float _1039 = (cb0_039y * -2.0f) / _997;
  float _1040 = _1028 - _1019;
  float _1041 = _1029 - _1019;
  float _1042 = _1030 - _1019;
  float _1061 = _1001 * 2.0f;
  float _1063 = (cb0_039y * 2.0f) / _1001;
  float _1088 = select((_1028 < _1019), ((_1037 / (exp2((_1040 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_040x), _1034);
  float _1089 = select((_1029 < _1019), ((_1037 / (exp2((_1041 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_040x), _1035);
  float _1090 = select((_1030 < _1019), ((_1037 / (exp2((_1042 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_040x), _1036);
  float _1097 = _1024 - _1019;
  float _1101 = saturate(_1040 / _1097);
  float _1102 = saturate(_1041 / _1097);
  float _1103 = saturate(_1042 / _1097);
  bool _1104 = (_1024 < _1019);
  float _1108 = select(_1104, (1.0f - _1101), _1101);
  float _1109 = select(_1104, (1.0f - _1102), _1102);
  float _1110 = select(_1104, (1.0f - _1103), _1103);
  float _1129 = (((_1108 * _1108) * (select((_1028 > _1024), (_999 - (_1061 / (exp2(((_1028 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
  float _1130 = (((_1109 * _1109) * (select((_1029 > _1024), (_999 - (_1061 / (exp2(((_1029 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1035) - _1089)) * (3.0f - (_1109 * 2.0f))) + _1089;
  float _1131 = (((_1110 * _1110) * (select((_1030 > _1024), (_999 - (_1061 / (exp2(((_1030 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1036) - _1090)) * (3.0f - (_1110 * 2.0f))) + _1090;
  float _1132 = dot(float3(_1129, _1130, _1131), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1152 = (cb0_039x * (max(0.0f, (lerp(_1132, _1129, 0.9300000071525574f))) - _848)) + _848;
  float _1153 = (cb0_039x * (max(0.0f, (lerp(_1132, _1130, 0.9300000071525574f))) - _849)) + _849;
  float _1154 = (cb0_039x * (max(0.0f, (lerp(_1132, _1131, 0.9300000071525574f))) - _850)) + _850;
  float _1170 = ((mad(-0.06537103652954102f, _1154, mad(1.451815478503704e-06f, _1153, (_1152 * 1.065374732017517f))) - _1152) * cb0_038z) + _1152;
  float _1171 = ((mad(-0.20366770029067993f, _1154, mad(1.2036634683609009f, _1153, (_1152 * -2.57161445915699e-07f))) - _1153) * cb0_038z) + _1153;
  float _1172 = ((mad(0.9999996423721313f, _1154, mad(2.0954757928848267e-08f, _1153, (_1152 * 1.862645149230957e-08f))) - _1154) * cb0_038z) + _1154;
  SetTonemappedAP1(_1170, _1171, _1172);

  float _1185 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1172, mad((WorkingColorSpace_192[0].y), _1171, ((WorkingColorSpace_192[0].x) * _1170)))));
  float _1186 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1172, mad((WorkingColorSpace_192[1].y), _1171, ((WorkingColorSpace_192[1].x) * _1170)))));
  float _1187 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1172, mad((WorkingColorSpace_192[2].y), _1171, ((WorkingColorSpace_192[2].x) * _1170)))));
  if (_1185 < 0.0031306699384003878f) {
    _1198 = (_1185 * 12.920000076293945f);
  } else {
    _1198 = (((pow(_1185, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1186 < 0.0031306699384003878f) {
    _1209 = (_1186 * 12.920000076293945f);
  } else {
    _1209 = (((pow(_1186, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1187 < 0.0031306699384003878f) {
    _1220 = (_1187 * 12.920000076293945f);
  } else {
    _1220 = (((pow(_1187, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1224 = (_1209 * 0.9375f) + 0.03125f;
  float _1231 = _1220 * 15.0f;
  float _1232 = floor(_1231);
  float _1233 = _1231 - _1232;
  float _1235 = (((_1198 * 0.9375f) + 0.03125f) + _1232) * 0.0625f;
  float4 _1238 = t0.Sample(s0, float2(_1235, _1224));
  float4 _1245 = t0.Sample(s0, float2((_1235 + 0.0625f), _1224));
  float _1261 = ((lerp(_1238.x, _1245.x, _1233)) * cb0_005y) + (cb0_005x * _1198);
  float _1262 = ((lerp(_1238.y, _1245.y, _1233)) * cb0_005y) + (cb0_005x * _1209);
  float _1263 = ((lerp(_1238.z, _1245.z, _1233)) * cb0_005y) + (cb0_005x * _1220);
  float _1288 = select((_1261 > 0.040449999272823334f), exp2(log2((abs(_1261) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1261 * 0.07739938050508499f));
  float _1289 = select((_1262 > 0.040449999272823334f), exp2(log2((abs(_1262) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1262 * 0.07739938050508499f));
  float _1290 = select((_1263 > 0.040449999272823334f), exp2(log2((abs(_1263) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1263 * 0.07739938050508499f));
  float _1316 = cb0_016x * (((cb0_041y + (cb0_041x * _1288)) * _1288) + cb0_041z);
  float _1317 = cb0_016y * (((cb0_041y + (cb0_041x * _1289)) * _1289) + cb0_041z);
  float _1318 = cb0_016z * (((cb0_041y + (cb0_041x * _1290)) * _1290) + cb0_041z);
  float _1325 = ((cb0_015x - _1316) * cb0_015w) + _1316;
  float _1326 = ((cb0_015y - _1317) * cb0_015w) + _1317;
  float _1327 = ((cb0_015z - _1318) * cb0_015w) + _1318;
  float _1328 = cb0_016x * mad((WorkingColorSpace_192[0].z), _812, mad((WorkingColorSpace_192[0].y), _810, (_808 * (WorkingColorSpace_192[0].x))));
  float _1329 = cb0_016y * mad((WorkingColorSpace_192[1].z), _812, mad((WorkingColorSpace_192[1].y), _810, ((WorkingColorSpace_192[1].x) * _808)));
  float _1330 = cb0_016z * mad((WorkingColorSpace_192[2].z), _812, mad((WorkingColorSpace_192[2].y), _810, ((WorkingColorSpace_192[2].x) * _808)));
  float _1337 = ((cb0_015x - _1328) * cb0_015w) + _1328;
  float _1338 = ((cb0_015y - _1329) * cb0_015w) + _1329;
  float _1339 = ((cb0_015z - _1330) * cb0_015w) + _1330;
  float _1351 = exp2(log2(max(0.0f, _1325)) * cb0_042y);
  float _1352 = exp2(log2(max(0.0f, _1326)) * cb0_042y);
  float _1353 = exp2(log2(max(0.0f, _1327)) * cb0_042y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return GenerateOutput(float3(_1351, _1352, _1353), cb0_042w);
  }
  [branch]
  if (cb0_042w == 0) {
    do {
      if (WorkingColorSpace_384 == 0) {
        float _1376 = mad((WorkingColorSpace_128[0].z), _1353, mad((WorkingColorSpace_128[0].y), _1352, ((WorkingColorSpace_128[0].x) * _1351)));
        float _1379 = mad((WorkingColorSpace_128[1].z), _1353, mad((WorkingColorSpace_128[1].y), _1352, ((WorkingColorSpace_128[1].x) * _1351)));
        float _1382 = mad((WorkingColorSpace_128[2].z), _1353, mad((WorkingColorSpace_128[2].y), _1352, ((WorkingColorSpace_128[2].x) * _1351)));
        _1393 = mad(_55, _1382, mad(_54, _1379, (_1376 * _53)));
        _1394 = mad(_58, _1382, mad(_57, _1379, (_1376 * _56)));
        _1395 = mad(_61, _1382, mad(_60, _1379, (_1376 * _59)));
      } else {
        _1393 = _1351;
        _1394 = _1352;
        _1395 = _1353;
      }
      do {
        if (_1393 < 0.0031306699384003878f) {
          _1406 = (_1393 * 12.920000076293945f);
        } else {
          _1406 = (((pow(_1393, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1394 < 0.0031306699384003878f) {
            _1417 = (_1394 * 12.920000076293945f);
          } else {
            _1417 = (((pow(_1394, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1395 < 0.0031306699384003878f) {
            _2968 = _1406;
            _2969 = _1417;
            _2970 = (_1395 * 12.920000076293945f);
          } else {
            _2968 = _1406;
            _2969 = _1417;
            _2970 = (((pow(_1395, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_042w == 1) {
      float _1444 = mad((WorkingColorSpace_128[0].z), _1353, mad((WorkingColorSpace_128[0].y), _1352, ((WorkingColorSpace_128[0].x) * _1351)));
      float _1447 = mad((WorkingColorSpace_128[1].z), _1353, mad((WorkingColorSpace_128[1].y), _1352, ((WorkingColorSpace_128[1].x) * _1351)));
      float _1450 = mad((WorkingColorSpace_128[2].z), _1353, mad((WorkingColorSpace_128[2].y), _1352, ((WorkingColorSpace_128[2].x) * _1351)));
      float _1453 = mad(_55, _1450, mad(_54, _1447, (_1444 * _53)));
      float _1456 = mad(_58, _1450, mad(_57, _1447, (_1444 * _56)));
      float _1459 = mad(_61, _1450, mad(_60, _1447, (_1444 * _59)));
      _2968 = min((_1453 * 4.5f), ((exp2(log2(max(_1453, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2969 = min((_1456 * 4.5f), ((exp2(log2(max(_1456, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2970 = min((_1459 * 4.5f), ((exp2(log2(max(_1459, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((uint)((int)(cb0_042w) + -3u)) < (uint)2) {
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
        float _1534 = cb0_012z * _1337;
        float _1535 = cb0_012z * _1338;
        float _1536 = cb0_012z * _1339;
        float _1539 = mad((WorkingColorSpace_256[0].z), _1536, mad((WorkingColorSpace_256[0].y), _1535, ((WorkingColorSpace_256[0].x) * _1534)));
        float _1542 = mad((WorkingColorSpace_256[1].z), _1536, mad((WorkingColorSpace_256[1].y), _1535, ((WorkingColorSpace_256[1].x) * _1534)));
        float _1545 = mad((WorkingColorSpace_256[2].z), _1536, mad((WorkingColorSpace_256[2].y), _1535, ((WorkingColorSpace_256[2].x) * _1534)));
        float _1548 = mad(-0.21492856740951538f, _1545, mad(-0.2365107536315918f, _1542, (_1539 * 1.4514392614364624f)));
        float _1551 = mad(-0.09967592358589172f, _1545, mad(1.17622971534729f, _1542, (_1539 * -0.07655377686023712f)));
        float _1554 = mad(0.9977163076400757f, _1545, mad(-0.006032449658960104f, _1542, (_1539 * 0.008316148072481155f)));
        float _1556 = max(_1548, max(_1551, _1554));
        do {
          if (!(_1556 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1539 < 0.0f) || (bool)(_1542 < 0.0f))) || (bool)(_1545 < 0.0f))) {
              float _1566 = abs(_1556);
              float _1567 = (_1556 - _1548) / _1566;
              float _1569 = (_1556 - _1551) / _1566;
              float _1571 = (_1556 - _1554) / _1566;
              do {
                if (!(_1567 < 0.8149999976158142f)) {
                  float _1574 = _1567 + -0.8149999976158142f;
                  _1586 = ((_1574 / exp2(log2(exp2(log2(_1574 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1586 = _1567;
                }
                do {
                  if (!(_1569 < 0.8029999732971191f)) {
                    float _1589 = _1569 + -0.8029999732971191f;
                    _1601 = ((_1589 / exp2(log2(exp2(log2(_1589 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1601 = _1569;
                  }
                  do {
                    if (!(_1571 < 0.8799999952316284f)) {
                      float _1604 = _1571 + -0.8799999952316284f;
                      _1616 = ((_1604 / exp2(log2(exp2(log2(_1604 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1616 = _1571;
                    }
                    _1624 = (_1556 - (_1566 * _1586));
                    _1625 = (_1556 - (_1566 * _1601));
                    _1626 = (_1556 - (_1566 * _1616));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1624 = _1548;
              _1625 = _1551;
              _1626 = _1554;
            }
          } else {
            _1624 = _1548;
            _1625 = _1551;
            _1626 = _1554;
          }
          float _1642 = ((mad(0.16386906802654266f, _1626, mad(0.14067870378494263f, _1625, (_1624 * 0.6954522132873535f))) - _1539) * cb0_012w) + _1539;
          float _1643 = ((mad(0.0955343171954155f, _1626, mad(0.8596711158752441f, _1625, (_1624 * 0.044794563204050064f))) - _1542) * cb0_012w) + _1542;
          float _1644 = ((mad(1.0015007257461548f, _1626, mad(0.004025210160762072f, _1625, (_1624 * -0.005525882821530104f))) - _1545) * cb0_012w) + _1545;
          float _1648 = max(max(_1642, _1643), _1644);
          float _1653 = (max(_1648, 1.000000013351432e-10f) - max(min(min(_1642, _1643), _1644), 1.000000013351432e-10f)) / max(_1648, 0.009999999776482582f);
          float _1666 = ((_1643 + _1642) + _1644) + (sqrt((((_1644 - _1643) * _1644) + ((_1643 - _1642) * _1643)) + ((_1642 - _1644) * _1642)) * 1.75f);
          float _1667 = _1666 * 0.3333333432674408f;
          float _1668 = _1653 + -0.4000000059604645f;
          float _1669 = _1668 * 5.0f;
          float _1673 = max((1.0f - abs(_1668 * 2.5f)), 0.0f);
          float _1684 = ((float((int)(((int)(uint)((bool)(_1669 > 0.0f))) - ((int)(uint)((bool)(_1669 < 0.0f))))) * (1.0f - (_1673 * _1673))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1667 <= 0.0533333346247673f)) {
              if (!(_1667 >= 0.1599999964237213f)) {
                _1693 = (((0.23999999463558197f / _1666) + -0.5f) * _1684);
              } else {
                _1693 = 0.0f;
              }
            } else {
              _1693 = _1684;
            }
            float _1694 = _1693 + 1.0f;
            float _1695 = _1694 * _1642;
            float _1696 = _1694 * _1643;
            float _1697 = _1694 * _1644;
            do {
              if (!((bool)(_1695 == _1696) && (bool)(_1696 == _1697))) {
                float _1704 = ((_1695 * 2.0f) - _1696) - _1697;
                float _1707 = ((_1643 - _1644) * 1.7320507764816284f) * _1694;
                float _1709 = atan(_1707 / _1704);
                bool _1712 = (_1704 < 0.0f);
                bool _1713 = (_1704 == 0.0f);
                bool _1714 = (_1707 >= 0.0f);
                bool _1715 = (_1707 < 0.0f);
                _1726 = select((_1714 && _1713), 90.0f, select((_1715 && _1713), -90.0f, (select((_1715 && _1712), (_1709 + -3.1415927410125732f), select((_1714 && _1712), (_1709 + 3.1415927410125732f), _1709)) * 57.2957763671875f)));
              } else {
                _1726 = 0.0f;
              }
              float _1731 = min(max(select((_1726 < 0.0f), (_1726 + 360.0f), _1726), 0.0f), 360.0f);
              do {
                if (_1731 < -180.0f) {
                  _1740 = (_1731 + 360.0f);
                } else {
                  if (_1731 > 180.0f) {
                    _1740 = (_1731 + -360.0f);
                  } else {
                    _1740 = _1731;
                  }
                }
                do {
                  if ((bool)(_1740 > -67.5f) && (bool)(_1740 < 67.5f)) {
                    float _1746 = (_1740 + 67.5f) * 0.029629629105329514f;
                    int _1747 = int(_1746);
                    float _1749 = _1746 - float((int)(_1747));
                    float _1750 = _1749 * _1749;
                    float _1751 = _1750 * _1749;
                    if (_1747 == 3) {
                      _1779 = (((0.1666666716337204f - (_1749 * 0.5f)) + (_1750 * 0.5f)) - (_1751 * 0.1666666716337204f));
                    } else {
                      if (_1747 == 2) {
                        _1779 = ((0.6666666865348816f - _1750) + (_1751 * 0.5f));
                      } else {
                        if (_1747 == 1) {
                          _1779 = (((_1751 * -0.5f) + 0.1666666716337204f) + ((_1750 + _1749) * 0.5f));
                        } else {
                          _1779 = select((_1747 == 0), (_1751 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1779 = 0.0f;
                  }
                  float _1788 = min(max(((((_1653 * 0.27000001072883606f) * (0.029999999329447746f - _1695)) * _1779) + _1695), 0.0f), 65535.0f);
                  float _1789 = min(max(_1696, 0.0f), 65535.0f);
                  float _1790 = min(max(_1697, 0.0f), 65535.0f);
                  float _1803 = min(max(mad(-0.21492856740951538f, _1790, mad(-0.2365107536315918f, _1789, (_1788 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1804 = min(max(mad(-0.09967592358589172f, _1790, mad(1.17622971534729f, _1789, (_1788 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1805 = min(max(mad(0.9977163076400757f, _1790, mad(-0.006032449658960104f, _1789, (_1788 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1806 = dot(float3(_1803, _1804, _1805), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1829 = log2(max((lerp(_1806, _1803, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1830 = _1829 * 0.3010300099849701f;
                  float _1831 = log2(cb0_008x);
                  float _1832 = _1831 * 0.3010300099849701f;
                  do {
                    if (!(!(_1830 <= _1832))) {
                      _1901 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1839 = log2(cb0_009x);
                      float _1840 = _1839 * 0.3010300099849701f;
                      if ((bool)(_1830 > _1832) && (bool)(_1830 < _1840)) {
                        float _1848 = ((_1829 - _1831) * 0.9030900001525879f) / ((_1839 - _1831) * 0.3010300099849701f);
                        int _1849 = int(_1848);
                        float _1851 = _1848 - float((int)(_1849));
                        float _1853 = _18[_1849];
                        float _1856 = _18[(_1849 + 1)];
                        float _1861 = _1853 * 0.5f;
                        _1901 = dot(float3((_1851 * _1851), _1851, 1.0f), float3(mad((_18[(_1849 + 2)]), 0.5f, mad(_1856, -1.0f, _1861)), (_1856 - _1853), mad(_1856, 0.5f, _1861)));
                      } else {
                        do {
                          if (!(!(_1830 >= _1840))) {
                            float _1870 = log2(cb0_008z);
                            if (_1830 < (_1870 * 0.3010300099849701f)) {
                              float _1878 = ((_1829 - _1839) * 0.9030900001525879f) / ((_1870 - _1839) * 0.3010300099849701f);
                              int _1879 = int(_1878);
                              float _1881 = _1878 - float((int)(_1879));
                              float _1883 = _19[_1879];
                              float _1886 = _19[(_1879 + 1)];
                              float _1891 = _1883 * 0.5f;
                              _1901 = dot(float3((_1881 * _1881), _1881, 1.0f), float3(mad((_19[(_1879 + 2)]), 0.5f, mad(_1886, -1.0f, _1891)), (_1886 - _1883), mad(_1886, 0.5f, _1891)));
                              break;
                            }
                          }
                          _1901 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _20[0] = cb0_010x;
                    _20[1] = cb0_010y;
                    _20[2] = cb0_010z;
                    _20[3] = cb0_010w;
                    _20[4] = cb0_012x;
                    _20[5] = cb0_012x;
                    _21[0] = cb0_011x;
                    _21[1] = cb0_011y;
                    _21[2] = cb0_011z;
                    _21[3] = cb0_011w;
                    _21[4] = cb0_012y;
                    _21[5] = cb0_012y;
                    float _1917 = log2(max((lerp(_1806, _1804, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1918 = _1917 * 0.3010300099849701f;
                    do {
                      if (!(!(_1918 <= _1832))) {
                        _1987 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1925 = log2(cb0_009x);
                        float _1926 = _1925 * 0.3010300099849701f;
                        if ((bool)(_1918 > _1832) && (bool)(_1918 < _1926)) {
                          float _1934 = ((_1917 - _1831) * 0.9030900001525879f) / ((_1925 - _1831) * 0.3010300099849701f);
                          int _1935 = int(_1934);
                          float _1937 = _1934 - float((int)(_1935));
                          float _1939 = _20[_1935];
                          float _1942 = _20[(_1935 + 1)];
                          float _1947 = _1939 * 0.5f;
                          _1987 = dot(float3((_1937 * _1937), _1937, 1.0f), float3(mad((_20[(_1935 + 2)]), 0.5f, mad(_1942, -1.0f, _1947)), (_1942 - _1939), mad(_1942, 0.5f, _1947)));
                        } else {
                          do {
                            if (!(!(_1918 >= _1926))) {
                              float _1956 = log2(cb0_008z);
                              if (_1918 < (_1956 * 0.3010300099849701f)) {
                                float _1964 = ((_1917 - _1925) * 0.9030900001525879f) / ((_1956 - _1925) * 0.3010300099849701f);
                                int _1965 = int(_1964);
                                float _1967 = _1964 - float((int)(_1965));
                                float _1969 = _21[_1965];
                                float _1972 = _21[(_1965 + 1)];
                                float _1977 = _1969 * 0.5f;
                                _1987 = dot(float3((_1967 * _1967), _1967, 1.0f), float3(mad((_21[(_1965 + 2)]), 0.5f, mad(_1972, -1.0f, _1977)), (_1972 - _1969), mad(_1972, 0.5f, _1977)));
                                break;
                              }
                            }
                            _1987 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1991 = log2(max((lerp(_1806, _1805, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1992 = _1991 * 0.3010300099849701f;
                      do {
                        if (!(!(_1992 <= _1832))) {
                          _2061 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1999 = log2(cb0_009x);
                          float _2000 = _1999 * 0.3010300099849701f;
                          if ((bool)(_1992 > _1832) && (bool)(_1992 < _2000)) {
                            float _2008 = ((_1991 - _1831) * 0.9030900001525879f) / ((_1999 - _1831) * 0.3010300099849701f);
                            int _2009 = int(_2008);
                            float _2011 = _2008 - float((int)(_2009));
                            float _2013 = _10[_2009];
                            float _2016 = _10[(_2009 + 1)];
                            float _2021 = _2013 * 0.5f;
                            _2061 = dot(float3((_2011 * _2011), _2011, 1.0f), float3(mad((_10[(_2009 + 2)]), 0.5f, mad(_2016, -1.0f, _2021)), (_2016 - _2013), mad(_2016, 0.5f, _2021)));
                          } else {
                            do {
                              if (!(!(_1992 >= _2000))) {
                                float _2030 = log2(cb0_008z);
                                if (_1992 < (_2030 * 0.3010300099849701f)) {
                                  float _2038 = ((_1991 - _1999) * 0.9030900001525879f) / ((_2030 - _1999) * 0.3010300099849701f);
                                  int _2039 = int(_2038);
                                  float _2041 = _2038 - float((int)(_2039));
                                  float _2043 = _11[_2039];
                                  float _2046 = _11[(_2039 + 1)];
                                  float _2051 = _2043 * 0.5f;
                                  _2061 = dot(float3((_2041 * _2041), _2041, 1.0f), float3(mad((_11[(_2039 + 2)]), 0.5f, mad(_2046, -1.0f, _2051)), (_2046 - _2043), mad(_2046, 0.5f, _2051)));
                                  break;
                                }
                              }
                              _2061 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2065 = cb0_008w - cb0_008y;
                        float _2066 = (exp2(_1901 * 3.321928024291992f) - cb0_008y) / _2065;
                        float _2068 = (exp2(_1987 * 3.321928024291992f) - cb0_008y) / _2065;
                        float _2070 = (exp2(_2061 * 3.321928024291992f) - cb0_008y) / _2065;
                        float _2073 = mad(0.15618768334388733f, _2070, mad(0.13400420546531677f, _2068, (_2066 * 0.6624541878700256f)));
                        float _2076 = mad(0.053689517080783844f, _2070, mad(0.6740817427635193f, _2068, (_2066 * 0.2722287178039551f)));
                        float _2079 = mad(1.0103391408920288f, _2070, mad(0.00406073359772563f, _2068, (_2066 * -0.005574649665504694f)));
                        float _2092 = min(max(mad(-0.23642469942569733f, _2079, mad(-0.32480329275131226f, _2076, (_2073 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2093 = min(max(mad(0.016756348311901093f, _2079, mad(1.6153316497802734f, _2076, (_2073 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2094 = min(max(mad(0.9883948564529419f, _2079, mad(-0.008284442126750946f, _2076, (_2073 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2097 = mad(0.15618768334388733f, _2094, mad(0.13400420546531677f, _2093, (_2092 * 0.6624541878700256f)));
                        float _2100 = mad(0.053689517080783844f, _2094, mad(0.6740817427635193f, _2093, (_2092 * 0.2722287178039551f)));
                        float _2103 = mad(1.0103391408920288f, _2094, mad(0.00406073359772563f, _2093, (_2092 * -0.005574649665504694f)));
                        float _2125 = min(max((min(max(mad(-0.23642469942569733f, _2103, mad(-0.32480329275131226f, _2100, (_2097 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2126 = min(max((min(max(mad(0.016756348311901093f, _2103, mad(1.6153316497802734f, _2100, (_2097 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2127 = min(max((min(max(mad(0.9883948564529419f, _2103, mad(-0.008284442126750946f, _2100, (_2097 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2146 = exp2(log2(mad(_55, _2127, mad(_54, _2126, (_2125 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2147 = exp2(log2(mad(_58, _2127, mad(_57, _2126, (_2125 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2148 = exp2(log2(mad(_61, _2127, mad(_60, _2126, (_2125 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2968 = exp2(log2((1.0f / ((_2146 * 18.6875f) + 1.0f)) * ((_2146 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2969 = exp2(log2((1.0f / ((_2147 * 18.6875f) + 1.0f)) * ((_2147 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2970 = exp2(log2((1.0f / ((_2148 * 18.6875f) + 1.0f)) * ((_2148 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2214 = cb0_012z * _1337;
          float _2215 = cb0_012z * _1338;
          float _2216 = cb0_012z * _1339;
          float _2219 = mad((WorkingColorSpace_256[0].z), _2216, mad((WorkingColorSpace_256[0].y), _2215, ((WorkingColorSpace_256[0].x) * _2214)));
          float _2222 = mad((WorkingColorSpace_256[1].z), _2216, mad((WorkingColorSpace_256[1].y), _2215, ((WorkingColorSpace_256[1].x) * _2214)));
          float _2225 = mad((WorkingColorSpace_256[2].z), _2216, mad((WorkingColorSpace_256[2].y), _2215, ((WorkingColorSpace_256[2].x) * _2214)));
          float _2228 = mad(-0.21492856740951538f, _2225, mad(-0.2365107536315918f, _2222, (_2219 * 1.4514392614364624f)));
          float _2231 = mad(-0.09967592358589172f, _2225, mad(1.17622971534729f, _2222, (_2219 * -0.07655377686023712f)));
          float _2234 = mad(0.9977163076400757f, _2225, mad(-0.006032449658960104f, _2222, (_2219 * 0.008316148072481155f)));
          float _2236 = max(_2228, max(_2231, _2234));
          do {
            if (!(_2236 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2219 < 0.0f) || (bool)(_2222 < 0.0f))) || (bool)(_2225 < 0.0f))) {
                float _2246 = abs(_2236);
                float _2247 = (_2236 - _2228) / _2246;
                float _2249 = (_2236 - _2231) / _2246;
                float _2251 = (_2236 - _2234) / _2246;
                do {
                  if (!(_2247 < 0.8149999976158142f)) {
                    float _2254 = _2247 + -0.8149999976158142f;
                    _2266 = ((_2254 / exp2(log2(exp2(log2(_2254 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2266 = _2247;
                  }
                  do {
                    if (!(_2249 < 0.8029999732971191f)) {
                      float _2269 = _2249 + -0.8029999732971191f;
                      _2281 = ((_2269 / exp2(log2(exp2(log2(_2269 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2281 = _2249;
                    }
                    do {
                      if (!(_2251 < 0.8799999952316284f)) {
                        float _2284 = _2251 + -0.8799999952316284f;
                        _2296 = ((_2284 / exp2(log2(exp2(log2(_2284 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2296 = _2251;
                      }
                      _2304 = (_2236 - (_2246 * _2266));
                      _2305 = (_2236 - (_2246 * _2281));
                      _2306 = (_2236 - (_2246 * _2296));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2304 = _2228;
                _2305 = _2231;
                _2306 = _2234;
              }
            } else {
              _2304 = _2228;
              _2305 = _2231;
              _2306 = _2234;
            }
            float _2322 = ((mad(0.16386906802654266f, _2306, mad(0.14067870378494263f, _2305, (_2304 * 0.6954522132873535f))) - _2219) * cb0_012w) + _2219;
            float _2323 = ((mad(0.0955343171954155f, _2306, mad(0.8596711158752441f, _2305, (_2304 * 0.044794563204050064f))) - _2222) * cb0_012w) + _2222;
            float _2324 = ((mad(1.0015007257461548f, _2306, mad(0.004025210160762072f, _2305, (_2304 * -0.005525882821530104f))) - _2225) * cb0_012w) + _2225;
            float _2328 = max(max(_2322, _2323), _2324);
            float _2333 = (max(_2328, 1.000000013351432e-10f) - max(min(min(_2322, _2323), _2324), 1.000000013351432e-10f)) / max(_2328, 0.009999999776482582f);
            float _2346 = ((_2323 + _2322) + _2324) + (sqrt((((_2324 - _2323) * _2324) + ((_2323 - _2322) * _2323)) + ((_2322 - _2324) * _2322)) * 1.75f);
            float _2347 = _2346 * 0.3333333432674408f;
            float _2348 = _2333 + -0.4000000059604645f;
            float _2349 = _2348 * 5.0f;
            float _2353 = max((1.0f - abs(_2348 * 2.5f)), 0.0f);
            float _2364 = ((float((int)(((int)(uint)((bool)(_2349 > 0.0f))) - ((int)(uint)((bool)(_2349 < 0.0f))))) * (1.0f - (_2353 * _2353))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2347 <= 0.0533333346247673f)) {
                if (!(_2347 >= 0.1599999964237213f)) {
                  _2373 = (((0.23999999463558197f / _2346) + -0.5f) * _2364);
                } else {
                  _2373 = 0.0f;
                }
              } else {
                _2373 = _2364;
              }
              float _2374 = _2373 + 1.0f;
              float _2375 = _2374 * _2322;
              float _2376 = _2374 * _2323;
              float _2377 = _2374 * _2324;
              do {
                if (!((bool)(_2375 == _2376) && (bool)(_2376 == _2377))) {
                  float _2384 = ((_2375 * 2.0f) - _2376) - _2377;
                  float _2387 = ((_2323 - _2324) * 1.7320507764816284f) * _2374;
                  float _2389 = atan(_2387 / _2384);
                  bool _2392 = (_2384 < 0.0f);
                  bool _2393 = (_2384 == 0.0f);
                  bool _2394 = (_2387 >= 0.0f);
                  bool _2395 = (_2387 < 0.0f);
                  _2406 = select((_2394 && _2393), 90.0f, select((_2395 && _2393), -90.0f, (select((_2395 && _2392), (_2389 + -3.1415927410125732f), select((_2394 && _2392), (_2389 + 3.1415927410125732f), _2389)) * 57.2957763671875f)));
                } else {
                  _2406 = 0.0f;
                }
                float _2411 = min(max(select((_2406 < 0.0f), (_2406 + 360.0f), _2406), 0.0f), 360.0f);
                do {
                  if (_2411 < -180.0f) {
                    _2420 = (_2411 + 360.0f);
                  } else {
                    if (_2411 > 180.0f) {
                      _2420 = (_2411 + -360.0f);
                    } else {
                      _2420 = _2411;
                    }
                  }
                  do {
                    if ((bool)(_2420 > -67.5f) && (bool)(_2420 < 67.5f)) {
                      float _2426 = (_2420 + 67.5f) * 0.029629629105329514f;
                      int _2427 = int(_2426);
                      float _2429 = _2426 - float((int)(_2427));
                      float _2430 = _2429 * _2429;
                      float _2431 = _2430 * _2429;
                      if (_2427 == 3) {
                        _2459 = (((0.1666666716337204f - (_2429 * 0.5f)) + (_2430 * 0.5f)) - (_2431 * 0.1666666716337204f));
                      } else {
                        if (_2427 == 2) {
                          _2459 = ((0.6666666865348816f - _2430) + (_2431 * 0.5f));
                        } else {
                          if (_2427 == 1) {
                            _2459 = (((_2431 * -0.5f) + 0.1666666716337204f) + ((_2430 + _2429) * 0.5f));
                          } else {
                            _2459 = select((_2427 == 0), (_2431 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2459 = 0.0f;
                    }
                    float _2468 = min(max(((((_2333 * 0.27000001072883606f) * (0.029999999329447746f - _2375)) * _2459) + _2375), 0.0f), 65535.0f);
                    float _2469 = min(max(_2376, 0.0f), 65535.0f);
                    float _2470 = min(max(_2377, 0.0f), 65535.0f);
                    float _2483 = min(max(mad(-0.21492856740951538f, _2470, mad(-0.2365107536315918f, _2469, (_2468 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2484 = min(max(mad(-0.09967592358589172f, _2470, mad(1.17622971534729f, _2469, (_2468 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2485 = min(max(mad(0.9977163076400757f, _2470, mad(-0.006032449658960104f, _2469, (_2468 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2486 = dot(float3(_2483, _2484, _2485), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2509 = log2(max((lerp(_2486, _2483, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2510 = _2509 * 0.3010300099849701f;
                    float _2511 = log2(cb0_008x);
                    float _2512 = _2511 * 0.3010300099849701f;
                    do {
                      if (!(!(_2510 <= _2512))) {
                        _2581 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2519 = log2(cb0_009x);
                        float _2520 = _2519 * 0.3010300099849701f;
                        if ((bool)(_2510 > _2512) && (bool)(_2510 < _2520)) {
                          float _2528 = ((_2509 - _2511) * 0.9030900001525879f) / ((_2519 - _2511) * 0.3010300099849701f);
                          int _2529 = int(_2528);
                          float _2531 = _2528 - float((int)(_2529));
                          float _2533 = _16[_2529];
                          float _2536 = _16[(_2529 + 1)];
                          float _2541 = _2533 * 0.5f;
                          _2581 = dot(float3((_2531 * _2531), _2531, 1.0f), float3(mad((_16[(_2529 + 2)]), 0.5f, mad(_2536, -1.0f, _2541)), (_2536 - _2533), mad(_2536, 0.5f, _2541)));
                        } else {
                          do {
                            if (!(!(_2510 >= _2520))) {
                              float _2550 = log2(cb0_008z);
                              if (_2510 < (_2550 * 0.3010300099849701f)) {
                                float _2558 = ((_2509 - _2519) * 0.9030900001525879f) / ((_2550 - _2519) * 0.3010300099849701f);
                                int _2559 = int(_2558);
                                float _2561 = _2558 - float((int)(_2559));
                                float _2563 = _17[_2559];
                                float _2566 = _17[(_2559 + 1)];
                                float _2571 = _2563 * 0.5f;
                                _2581 = dot(float3((_2561 * _2561), _2561, 1.0f), float3(mad((_17[(_2559 + 2)]), 0.5f, mad(_2566, -1.0f, _2571)), (_2566 - _2563), mad(_2566, 0.5f, _2571)));
                                break;
                              }
                            }
                            _2581 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _2597 = log2(max((lerp(_2486, _2484, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2598 = _2597 * 0.3010300099849701f;
                      do {
                        if (!(!(_2598 <= _2512))) {
                          _2667 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2605 = log2(cb0_009x);
                          float _2606 = _2605 * 0.3010300099849701f;
                          if ((bool)(_2598 > _2512) && (bool)(_2598 < _2606)) {
                            float _2614 = ((_2597 - _2511) * 0.9030900001525879f) / ((_2605 - _2511) * 0.3010300099849701f);
                            int _2615 = int(_2614);
                            float _2617 = _2614 - float((int)(_2615));
                            float _2619 = _12[_2615];
                            float _2622 = _12[(_2615 + 1)];
                            float _2627 = _2619 * 0.5f;
                            _2667 = dot(float3((_2617 * _2617), _2617, 1.0f), float3(mad((_12[(_2615 + 2)]), 0.5f, mad(_2622, -1.0f, _2627)), (_2622 - _2619), mad(_2622, 0.5f, _2627)));
                          } else {
                            do {
                              if (!(!(_2598 >= _2606))) {
                                float _2636 = log2(cb0_008z);
                                if (_2598 < (_2636 * 0.3010300099849701f)) {
                                  float _2644 = ((_2597 - _2605) * 0.9030900001525879f) / ((_2636 - _2605) * 0.3010300099849701f);
                                  int _2645 = int(_2644);
                                  float _2647 = _2644 - float((int)(_2645));
                                  float _2649 = _13[_2645];
                                  float _2652 = _13[(_2645 + 1)];
                                  float _2657 = _2649 * 0.5f;
                                  _2667 = dot(float3((_2647 * _2647), _2647, 1.0f), float3(mad((_13[(_2645 + 2)]), 0.5f, mad(_2652, -1.0f, _2657)), (_2652 - _2649), mad(_2652, 0.5f, _2657)));
                                  break;
                                }
                              }
                              _2667 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
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
                        float _2683 = log2(max((lerp(_2486, _2485, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2684 = _2683 * 0.3010300099849701f;
                        do {
                          if (!(!(_2684 <= _2512))) {
                            _2753 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2691 = log2(cb0_009x);
                            float _2692 = _2691 * 0.3010300099849701f;
                            if ((bool)(_2684 > _2512) && (bool)(_2684 < _2692)) {
                              float _2700 = ((_2683 - _2511) * 0.9030900001525879f) / ((_2691 - _2511) * 0.3010300099849701f);
                              int _2701 = int(_2700);
                              float _2703 = _2700 - float((int)(_2701));
                              float _2705 = _14[_2701];
                              float _2708 = _14[(_2701 + 1)];
                              float _2713 = _2705 * 0.5f;
                              _2753 = dot(float3((_2703 * _2703), _2703, 1.0f), float3(mad((_14[(_2701 + 2)]), 0.5f, mad(_2708, -1.0f, _2713)), (_2708 - _2705), mad(_2708, 0.5f, _2713)));
                            } else {
                              do {
                                if (!(!(_2684 >= _2692))) {
                                  float _2722 = log2(cb0_008z);
                                  if (_2684 < (_2722 * 0.3010300099849701f)) {
                                    float _2730 = ((_2683 - _2691) * 0.9030900001525879f) / ((_2722 - _2691) * 0.3010300099849701f);
                                    int _2731 = int(_2730);
                                    float _2733 = _2730 - float((int)(_2731));
                                    float _2735 = _15[_2731];
                                    float _2738 = _15[(_2731 + 1)];
                                    float _2743 = _2735 * 0.5f;
                                    _2753 = dot(float3((_2733 * _2733), _2733, 1.0f), float3(mad((_15[(_2731 + 2)]), 0.5f, mad(_2738, -1.0f, _2743)), (_2738 - _2735), mad(_2738, 0.5f, _2743)));
                                    break;
                                  }
                                }
                                _2753 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2757 = cb0_008w - cb0_008y;
                          float _2758 = (exp2(_2581 * 3.321928024291992f) - cb0_008y) / _2757;
                          float _2760 = (exp2(_2667 * 3.321928024291992f) - cb0_008y) / _2757;
                          float _2762 = (exp2(_2753 * 3.321928024291992f) - cb0_008y) / _2757;
                          float _2765 = mad(0.15618768334388733f, _2762, mad(0.13400420546531677f, _2760, (_2758 * 0.6624541878700256f)));
                          float _2768 = mad(0.053689517080783844f, _2762, mad(0.6740817427635193f, _2760, (_2758 * 0.2722287178039551f)));
                          float _2771 = mad(1.0103391408920288f, _2762, mad(0.00406073359772563f, _2760, (_2758 * -0.005574649665504694f)));
                          float _2784 = min(max(mad(-0.23642469942569733f, _2771, mad(-0.32480329275131226f, _2768, (_2765 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2785 = min(max(mad(0.016756348311901093f, _2771, mad(1.6153316497802734f, _2768, (_2765 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2786 = min(max(mad(0.9883948564529419f, _2771, mad(-0.008284442126750946f, _2768, (_2765 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2789 = mad(0.15618768334388733f, _2786, mad(0.13400420546531677f, _2785, (_2784 * 0.6624541878700256f)));
                          float _2792 = mad(0.053689517080783844f, _2786, mad(0.6740817427635193f, _2785, (_2784 * 0.2722287178039551f)));
                          float _2795 = mad(1.0103391408920288f, _2786, mad(0.00406073359772563f, _2785, (_2784 * -0.005574649665504694f)));
                          float _2817 = min(max((min(max(mad(-0.23642469942569733f, _2795, mad(-0.32480329275131226f, _2792, (_2789 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2820 = min(max((min(max(mad(0.016756348311901093f, _2795, mad(1.6153316497802734f, _2792, (_2789 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          float _2821 = min(max((min(max(mad(0.9883948564529419f, _2795, mad(-0.008284442126750946f, _2792, (_2789 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          _2968 = mad(-0.0832589864730835f, _2821, mad(-0.6217921376228333f, _2820, (_2817 * 0.0213131383061409f)));
                          _2969 = mad(-0.010548308491706848f, _2821, mad(1.140804648399353f, _2820, (_2817 * -0.0016282059950754046f)));
                          _2970 = mad(1.1529725790023804f, _2821, mad(-0.1289689838886261f, _2820, (_2817 * -0.00030004189466126263f)));
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
            float _2848 = mad((WorkingColorSpace_128[0].z), _1339, mad((WorkingColorSpace_128[0].y), _1338, ((WorkingColorSpace_128[0].x) * _1337)));
            float _2851 = mad((WorkingColorSpace_128[1].z), _1339, mad((WorkingColorSpace_128[1].y), _1338, ((WorkingColorSpace_128[1].x) * _1337)));
            float _2854 = mad((WorkingColorSpace_128[2].z), _1339, mad((WorkingColorSpace_128[2].y), _1338, ((WorkingColorSpace_128[2].x) * _1337)));
            float _2873 = exp2(log2(mad(_55, _2854, mad(_54, _2851, (_2848 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2874 = exp2(log2(mad(_58, _2854, mad(_57, _2851, (_2848 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2875 = exp2(log2(mad(_61, _2854, mad(_60, _2851, (_2848 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2968 = exp2(log2((1.0f / ((_2873 * 18.6875f) + 1.0f)) * ((_2873 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2969 = exp2(log2((1.0f / ((_2874 * 18.6875f) + 1.0f)) * ((_2874 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2970 = exp2(log2((1.0f / ((_2875 * 18.6875f) + 1.0f)) * ((_2875 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                float _2922 = mad((WorkingColorSpace_128[0].z), _1327, mad((WorkingColorSpace_128[0].y), _1326, ((WorkingColorSpace_128[0].x) * _1325)));
                float _2925 = mad((WorkingColorSpace_128[1].z), _1327, mad((WorkingColorSpace_128[1].y), _1326, ((WorkingColorSpace_128[1].x) * _1325)));
                float _2928 = mad((WorkingColorSpace_128[2].z), _1327, mad((WorkingColorSpace_128[2].y), _1326, ((WorkingColorSpace_128[2].x) * _1325)));
                _2968 = mad(_55, _2928, mad(_54, _2925, (_2922 * _53)));
                _2969 = mad(_58, _2928, mad(_57, _2925, (_2922 * _56)));
                _2970 = mad(_61, _2928, mad(_60, _2925, (_2922 * _59)));
              } else {
                float _2941 = mad((WorkingColorSpace_128[0].z), _1353, mad((WorkingColorSpace_128[0].y), _1352, ((WorkingColorSpace_128[0].x) * _1351)));
                float _2944 = mad((WorkingColorSpace_128[1].z), _1353, mad((WorkingColorSpace_128[1].y), _1352, ((WorkingColorSpace_128[1].x) * _1351)));
                float _2947 = mad((WorkingColorSpace_128[2].z), _1353, mad((WorkingColorSpace_128[2].y), _1352, ((WorkingColorSpace_128[2].x) * _1351)));
                _2968 = exp2(log2(mad(_55, _2947, mad(_54, _2944, (_2941 * _53)))) * cb0_042z);
                _2969 = exp2(log2(mad(_58, _2947, mad(_57, _2944, (_2941 * _56)))) * cb0_042z);
                _2970 = exp2(log2(mad(_61, _2947, mad(_60, _2944, (_2941 * _59)))) * cb0_042z);
              }
            } else {
              _2968 = _1337;
              _2969 = _1338;
              _2970 = _1339;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2968 * 0.9523810148239136f);
  SV_Target.y = (_2969 * 0.9523810148239136f);
  SV_Target.z = (_2970 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
