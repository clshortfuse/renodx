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
  float cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_041w : packoffset(c041.w);
  float cb0_042x : packoffset(c042.x);
  int cb0_042z : packoffset(c042.z);
  float cb0_043x : packoffset(c043.x);
  float cb0_043y : packoffset(c043.y);
  float cb0_043z : packoffset(c043.z);
  float cb0_044y : packoffset(c044.y);
  float cb0_044z : packoffset(c044.z);
  int cb0_044w : packoffset(c044.w);
  int cb0_045x : packoffset(c045.x);
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
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
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
  float _21 = 0.5f / cb0_037x;
  float _26 = cb0_037x + -1.0f;
  float _27 = (cb0_037x * (TEXCOORD.x - _21)) / _26;
  float _28 = (cb0_037x * (TEXCOORD.y - _21)) / _26;
  float _30 = float((uint)(int)(SV_RenderTargetArrayIndex)) / _26;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _116;
  float _117;
  float _118;
  float _173;
  float _380;
  float _381;
  float _382;
  float _891;
  float _903;
  float _934;
  float _945;
  float _976;
  float _987;
  float _1133;
  float _1134;
  float _1135;
  float _1146;
  float _1157;
  float _1318;
  float _1333;
  float _1348;
  float _1356;
  float _1357;
  float _1358;
  float _1425;
  float _1458;
  float _1472;
  float _1511;
  float _1633;
  float _1713;
  float _1787;
  float _1992;
  float _2007;
  float _2022;
  float _2030;
  float _2031;
  float _2032;
  float _2099;
  float _2132;
  float _2146;
  float _2185;
  float _2307;
  float _2393;
  float _2479;
  float _2678;
  float _2679;
  float _2680;
  if (!(cb0_045x == 1)) {
    if (!(cb0_045x == 2)) {
      if (!(cb0_045x == 3)) {
        bool _39 = (cb0_045x == 4);
        _50 = select(_39, 1.0f, 1.705051064491272f);
        _51 = select(_39, 0.0f, -0.6217921376228333f);
        _52 = select(_39, 0.0f, -0.0832589864730835f);
        _53 = select(_39, 0.0f, -0.13025647401809692f);
        _54 = select(_39, 1.0f, 1.140804648399353f);
        _55 = select(_39, 0.0f, -0.010548308491706848f);
        _56 = select(_39, 0.0f, -0.024003351107239723f);
        _57 = select(_39, 0.0f, -0.1289689838886261f);
        _58 = select(_39, 1.0f, 1.1529725790023804f);
      } else {
        _50 = 0.6954522132873535f;
        _51 = 0.14067870378494263f;
        _52 = 0.16386906802654266f;
        _53 = 0.044794563204050064f;
        _54 = 0.8596711158752441f;
        _55 = 0.0955343171954155f;
        _56 = -0.005525882821530104f;
        _57 = 0.004025210160762072f;
        _58 = 1.0015007257461548f;
      }
    } else {
      _50 = 1.0258246660232544f;
      _51 = -0.020053181797266006f;
      _52 = -0.005771636962890625f;
      _53 = -0.002234415616840124f;
      _54 = 1.0045864582061768f;
      _55 = -0.002352118492126465f;
      _56 = -0.005013350863009691f;
      _57 = -0.025290070101618767f;
      _58 = 1.0303035974502563f;
    }
  } else {
    _50 = 1.3792141675949097f;
    _51 = -0.30886411666870117f;
    _52 = -0.0703500509262085f;
    _53 = -0.06933490186929703f;
    _54 = 1.08229660987854f;
    _55 = -0.012961871922016144f;
    _56 = -0.0021590073592960835f;
    _57 = -0.0454593189060688f;
    _58 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_044w > (uint)2) {
    float _69 = (pow(_27, 0.012683313339948654f));
    float _70 = (pow(_28, 0.012683313339948654f));
    float _71 = (pow(_30, 0.012683313339948654f));
    _116 = (exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _116 = ((exp2((_27 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _117 = ((exp2((_28 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_30 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _380 = _116;
      _381 = _117;
      _382 = _118;
      float _397 = mad((WorkingColorSpace_128[0].z), _382, mad((WorkingColorSpace_128[0].y), _381, ((WorkingColorSpace_128[0].x) * _380)));
      float _400 = mad((WorkingColorSpace_128[1].z), _382, mad((WorkingColorSpace_128[1].y), _381, ((WorkingColorSpace_128[1].x) * _380)));
      float _403 = mad((WorkingColorSpace_128[2].z), _382, mad((WorkingColorSpace_128[2].y), _381, ((WorkingColorSpace_128[2].x) * _380)));
      SetUngradedAP1(float3(_397, _400, _403));
      float _404 = dot(float3(_397, _400, _403), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _408 = (_397 / _404) + -1.0f;
      float _409 = (_400 / _404) + -1.0f;
      float _410 = (_403 / _404) + -1.0f;
      float _422 = (1.0f - exp2(((_404 * _404) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_408, _409, _410), float3(_408, _409, _410)) * -4.0f));
      float _438 = ((mad(-0.06368321925401688f, _403, mad(-0.3292922377586365f, _400, (_397 * 1.3704125881195068f))) - _397) * _422) + _397;
      float _439 = ((mad(-0.010861365124583244f, _403, mad(1.0970927476882935f, _400, (_397 * -0.08343357592821121f))) - _400) * _422) + _400;
      float _440 = ((mad(1.2036951780319214f, _403, mad(-0.09862580895423889f, _400, (_397 * -0.02579331398010254f))) - _403) * _422) + _403;
      float _441 = dot(float3(_438, _439, _440), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _455 = cb0_021w + cb0_026w;
      float _469 = cb0_020w * cb0_025w;
      float _483 = cb0_019w * cb0_024w;
      float _497 = cb0_018w * cb0_023w;
      float _511 = cb0_017w * cb0_022w;
      float _515 = _438 - _441;
      float _516 = _439 - _441;
      float _517 = _440 - _441;
      float _574 = saturate(_441 / cb0_037w);
      float _578 = (_574 * _574) * (3.0f - (_574 * 2.0f));
      float _579 = 1.0f - _578;
      float _588 = cb0_021w + cb0_036w;
      float _597 = cb0_020w * cb0_035w;
      float _606 = cb0_019w * cb0_034w;
      float _615 = cb0_018w * cb0_033w;
      float _624 = cb0_017w * cb0_032w;
      float _687 = saturate((_441 - cb0_038x) / (cb0_038y - cb0_038x));
      float _691 = (_687 * _687) * (3.0f - (_687 * 2.0f));
      float _700 = cb0_021w + cb0_031w;
      float _709 = cb0_020w * cb0_030w;
      float _718 = cb0_019w * cb0_029w;
      float _727 = cb0_018w * cb0_028w;
      float _736 = cb0_017w * cb0_027w;
      float _794 = _578 - _691;
      float _805 = ((_691 * (((cb0_021x + cb0_036x) + _588) + (((cb0_020x * cb0_035x) * _597) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _615) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _624) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _606)))))) + (_579 * (((cb0_021x + cb0_026x) + _455) + (((cb0_020x * cb0_025x) * _469) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _497) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _511) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _483))))))) + ((((cb0_021x + cb0_031x) + _700) + (((cb0_020x * cb0_030x) * _709) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _727) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _736) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _718))))) * _794);
      float _807 = ((_691 * (((cb0_021y + cb0_036y) + _588) + (((cb0_020y * cb0_035y) * _597) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _615) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _624) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _606)))))) + (_579 * (((cb0_021y + cb0_026y) + _455) + (((cb0_020y * cb0_025y) * _469) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _497) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _511) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _483))))))) + ((((cb0_021y + cb0_031y) + _700) + (((cb0_020y * cb0_030y) * _709) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _727) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _736) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _718))))) * _794);
      float _809 = ((_691 * (((cb0_021z + cb0_036z) + _588) + (((cb0_020z * cb0_035z) * _597) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _615) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _624) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _606)))))) + (_579 * (((cb0_021z + cb0_026z) + _455) + (((cb0_020z * cb0_025z) * _469) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _497) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _511) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _483))))))) + ((((cb0_021z + cb0_031z) + _700) + (((cb0_020z * cb0_030z) * _709) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _727) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _736) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _718))))) * _794);
      float _845 = ((mad(0.061360642313957214f, _809, mad(-4.540197551250458e-09f, _807, (_805 * 0.9386394023895264f))) - _805) * cb0_038z) + _805;
      float _846 = ((mad(0.169205904006958f, _809, mad(0.8307942152023315f, _807, (_805 * 6.775371730327606e-08f))) - _807) * cb0_038z) + _807;
      float _847 = (mad(-2.3283064365386963e-10f, _807, (_805 * -9.313225746154785e-10f)) * cb0_038z) + _809;
      SetUntonemappedAP1(float3(_805, _807, _809));
      float _859 = ((cb0_040w - cb0_041y) * cb0_041z) / cb0_041x;
      float _860 = _845 - cb0_041y;
      float _863 = _845 / cb0_041y;
      float _872 = cb0_040w - ((_859 * cb0_041x) + cb0_041y);
      float _873 = (cb0_040w * cb0_041x) / _872;
      do {
        if (!(_845 <= 0.0f)) {
          if (!(_845 >= cb0_041y)) {
            _891 = (((_863 * _863) * 3.0f) - (_863 * 2.0f));
          } else {
            _891 = 1.0f;
          }
        } else {
          _891 = 0.0f;
        }
        float _893 = _859 + cb0_041y;
        do {
          if (!(_845 <= _893)) {
            if (!(_845 >= ((cb0_041y + 0.0010000000474974513f) + _859))) {
              _903 = ((_845 - _893) * 999.9999389648438f);
            } else {
              _903 = 1.0f;
            }
          } else {
            _903 = 0.0f;
          }
          float _908 = _846 - cb0_041y;
          float _911 = _846 / cb0_041y;
          do {
            if (!(_846 <= 0.0f)) {
              if (!(_846 >= cb0_041y)) {
                _934 = (((_911 * _911) * 3.0f) - (_911 * 2.0f));
              } else {
                _934 = 1.0f;
              }
            } else {
              _934 = 0.0f;
            }
            do {
              if (!(_846 <= _893)) {
                if (!(_846 >= ((cb0_041y + 0.0010000000474974513f) + _859))) {
                  _945 = ((_846 - _893) * 999.9999389648438f);
                } else {
                  _945 = 1.0f;
                }
              } else {
                _945 = 0.0f;
              }
              float _950 = _847 - cb0_041y;
              float _953 = _847 / cb0_041y;
              do {
                if (!(_847 <= 0.0f)) {
                  if (!(_847 >= cb0_041y)) {
                    _976 = (((_953 * _953) * 3.0f) - (_953 * 2.0f));
                  } else {
                    _976 = 1.0f;
                  }
                } else {
                  _976 = 0.0f;
                }
                do {
                  if (!(_847 <= _893)) {
                    if (!(_847 >= ((cb0_041y + 0.0010000000474974513f) + _859))) {
                      _987 = ((_847 - _893) * 999.9999389648438f);
                    } else {
                      _987 = 1.0f;
                    }
                  } else {
                    _987 = 0.0f;
                  }
                  float _1006 = (cb0_039x * (((((1.0f - _891) * (((pow(_863, cb0_042x)) * cb0_041y) + cb0_041w)) - _845) + (_903 * (cb0_040w - (exp2(((-0.0f - ((_860 - _859) * _873)) / cb0_040w) * 1.442694067955017f) * _872)))) + ((_891 - _903) * ((cb0_041x * _860) + cb0_041y)))) + _845;
                  float _1007 = (cb0_039x * (((((1.0f - _934) * (((pow(_911, cb0_042x)) * cb0_041y) + cb0_041w)) - _846) + (_945 * (cb0_040w - (exp2(((-0.0f - ((_908 - _859) * _873)) / cb0_040w) * 1.442694067955017f) * _872)))) + ((_934 - _945) * ((cb0_041x * _908) + cb0_041y)))) + _846;
                  float _1008 = ((((((1.0f - _976) * (((pow(_953, cb0_042x)) * cb0_041y) + cb0_041w)) - _847) + (_987 * (cb0_040w - (exp2(((-0.0f - ((_950 - _859) * _873)) / cb0_040w) * 1.442694067955017f) * _872)))) + ((_976 - _987) * ((cb0_041x * _950) + cb0_041y))) * cb0_039x) + _847;
                  float _1024 = ((mad(-0.06537103652954102f, _1008, mad(1.451815478503704e-06f, _1007, (_1006 * 1.065374732017517f))) - _1006) * cb0_038z) + _1006;
                  float _1025 = ((mad(-0.20366770029067993f, _1008, mad(1.2036634683609009f, _1007, (_1006 * -2.57161445915699e-07f))) - _1007) * cb0_038z) + _1007;
                  float _1026 = ((mad(0.9999996423721313f, _1008, mad(2.0954757928848267e-08f, _1007, (_1006 * 1.862645149230957e-08f))) - _1008) * cb0_038z) + _1008;
                  SetTonemappedAP1(_1024, _1025, _1026);
                  float _1036 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1026, mad((WorkingColorSpace_192[0].y), _1025, ((WorkingColorSpace_192[0].x) * _1024))));
                  float _1037 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1026, mad((WorkingColorSpace_192[1].y), _1025, ((WorkingColorSpace_192[1].x) * _1024))));
                  float _1038 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1026, mad((WorkingColorSpace_192[2].y), _1025, ((WorkingColorSpace_192[2].x) * _1024))));
                  float _1064 = cb0_016x * (((cb0_043y + (cb0_043x * _1036)) * _1036) + cb0_043z);
                  float _1065 = cb0_016y * (((cb0_043y + (cb0_043x * _1037)) * _1037) + cb0_043z);
                  float _1066 = cb0_016z * (((cb0_043y + (cb0_043x * _1038)) * _1038) + cb0_043z);
                  float _1073 = ((cb0_015x - _1064) * cb0_015w) + _1064;
                  float _1074 = ((cb0_015y - _1065) * cb0_015w) + _1065;
                  float _1075 = ((cb0_015z - _1066) * cb0_015w) + _1066;
                  float _1076 = cb0_016x * mad((WorkingColorSpace_192[0].z), _809, mad((WorkingColorSpace_192[0].y), _807, (_805 * (WorkingColorSpace_192[0].x))));
                  float _1077 = cb0_016y * mad((WorkingColorSpace_192[1].z), _809, mad((WorkingColorSpace_192[1].y), _807, ((WorkingColorSpace_192[1].x) * _805)));
                  float _1078 = cb0_016z * mad((WorkingColorSpace_192[2].z), _809, mad((WorkingColorSpace_192[2].y), _807, ((WorkingColorSpace_192[2].x) * _805)));
                  float _1085 = ((cb0_015x - _1076) * cb0_015w) + _1076;
                  float _1086 = ((cb0_015y - _1077) * cb0_015w) + _1077;
                  float _1087 = ((cb0_015z - _1078) * cb0_015w) + _1078;
                  float _1099 = exp2(log2(max(0.0f, _1073)) * cb0_044y);
                  float _1100 = exp2(log2(max(0.0f, _1074)) * cb0_044y);
                  float _1101 = exp2(log2(max(0.0f, _1075)) * cb0_044y);
                  if (RENODX_TONE_MAP_TYPE != 0.f) {
                    return GenerateOutput(float3(_1099, _1100, _1101), cb0_044w);
                  }
                  do {
                    [branch]
                    if (cb0_044w == 0) {
                      do {
                        if (WorkingColorSpace_384 == 0) {
                          float _1116 = mad((WorkingColorSpace_128[0].z), _1101, mad((WorkingColorSpace_128[0].y), _1100, ((WorkingColorSpace_128[0].x) * _1099)));
                          float _1119 = mad((WorkingColorSpace_128[1].z), _1101, mad((WorkingColorSpace_128[1].y), _1100, ((WorkingColorSpace_128[1].x) * _1099)));
                          float _1122 = mad((WorkingColorSpace_128[2].z), _1101, mad((WorkingColorSpace_128[2].y), _1100, ((WorkingColorSpace_128[2].x) * _1099)));
                          _1133 = mad(_52, _1122, mad(_51, _1119, (_1116 * _50)));
                          _1134 = mad(_55, _1122, mad(_54, _1119, (_1116 * _53)));
                          _1135 = mad(_58, _1122, mad(_57, _1119, (_1116 * _56)));
                        } else {
                          _1133 = _1099;
                          _1134 = _1100;
                          _1135 = _1101;
                        }
                        do {
                          if (_1133 < 0.0031306699384003878f) {
                            _1146 = (_1133 * 12.920000076293945f);
                          } else {
                            _1146 = (((pow(_1133, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          }
                          do {
                            if (_1134 < 0.0031306699384003878f) {
                              _1157 = (_1134 * 12.920000076293945f);
                            } else {
                              _1157 = (((pow(_1134, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            }
                            if (_1135 < 0.0031306699384003878f) {
                              _2678 = _1146;
                              _2679 = _1157;
                              _2680 = (_1135 * 12.920000076293945f);
                            } else {
                              _2678 = _1146;
                              _2679 = _1157;
                              _2680 = (((pow(_1135, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            }
                          } while (false);
                        } while (false);
                      } while (false);
                    } else {
                      if (cb0_044w == 1) {
                        float _1176 = mad((WorkingColorSpace_128[0].z), _1101, mad((WorkingColorSpace_128[0].y), _1100, ((WorkingColorSpace_128[0].x) * _1099)));
                        float _1179 = mad((WorkingColorSpace_128[1].z), _1101, mad((WorkingColorSpace_128[1].y), _1100, ((WorkingColorSpace_128[1].x) * _1099)));
                        float _1182 = mad((WorkingColorSpace_128[2].z), _1101, mad((WorkingColorSpace_128[2].y), _1100, ((WorkingColorSpace_128[2].x) * _1099)));
                        float _1185 = mad(_52, _1182, mad(_51, _1179, (_1176 * _50)));
                        float _1188 = mad(_55, _1182, mad(_54, _1179, (_1176 * _53)));
                        float _1191 = mad(_58, _1182, mad(_57, _1179, (_1176 * _56)));
                        _2678 = min((_1185 * 4.5f), ((exp2(log2(max(_1185, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                        _2679 = min((_1188 * 4.5f), ((exp2(log2(max(_1188, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                        _2680 = min((_1191 * 4.5f), ((exp2(log2(max(_1191, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                      } else {
                        if ((uint)((uint)((int)(cb0_044w) + -3u)) < (uint)2) {
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
                          float _1266 = cb0_012z * _1085;
                          float _1267 = cb0_012z * _1086;
                          float _1268 = cb0_012z * _1087;
                          float _1271 = mad((WorkingColorSpace_256[0].z), _1268, mad((WorkingColorSpace_256[0].y), _1267, ((WorkingColorSpace_256[0].x) * _1266)));
                          float _1274 = mad((WorkingColorSpace_256[1].z), _1268, mad((WorkingColorSpace_256[1].y), _1267, ((WorkingColorSpace_256[1].x) * _1266)));
                          float _1277 = mad((WorkingColorSpace_256[2].z), _1268, mad((WorkingColorSpace_256[2].y), _1267, ((WorkingColorSpace_256[2].x) * _1266)));
                          float _1280 = mad(-0.21492856740951538f, _1277, mad(-0.2365107536315918f, _1274, (_1271 * 1.4514392614364624f)));
                          float _1283 = mad(-0.09967592358589172f, _1277, mad(1.17622971534729f, _1274, (_1271 * -0.07655377686023712f)));
                          float _1286 = mad(0.9977163076400757f, _1277, mad(-0.006032449658960104f, _1274, (_1271 * 0.008316148072481155f)));
                          float _1288 = max(_1280, max(_1283, _1286));
                          do {
                            if (!(_1288 < 1.000000013351432e-10f)) {
                              if (!(((bool)((bool)(_1271 < 0.0f) || (bool)(_1274 < 0.0f))) || (bool)(_1277 < 0.0f))) {
                                float _1298 = abs(_1288);
                                float _1299 = (_1288 - _1280) / _1298;
                                float _1301 = (_1288 - _1283) / _1298;
                                float _1303 = (_1288 - _1286) / _1298;
                                do {
                                  if (!(_1299 < 0.8149999976158142f)) {
                                    float _1306 = _1299 + -0.8149999976158142f;
                                    _1318 = ((_1306 / exp2(log2(exp2(log2(_1306 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                  } else {
                                    _1318 = _1299;
                                  }
                                  do {
                                    if (!(_1301 < 0.8029999732971191f)) {
                                      float _1321 = _1301 + -0.8029999732971191f;
                                      _1333 = ((_1321 / exp2(log2(exp2(log2(_1321 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                    } else {
                                      _1333 = _1301;
                                    }
                                    do {
                                      if (!(_1303 < 0.8799999952316284f)) {
                                        float _1336 = _1303 + -0.8799999952316284f;
                                        _1348 = ((_1336 / exp2(log2(exp2(log2(_1336 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                      } else {
                                        _1348 = _1303;
                                      }
                                      _1356 = (_1288 - (_1298 * _1318));
                                      _1357 = (_1288 - (_1298 * _1333));
                                      _1358 = (_1288 - (_1298 * _1348));
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } else {
                                _1356 = _1280;
                                _1357 = _1283;
                                _1358 = _1286;
                              }
                            } else {
                              _1356 = _1280;
                              _1357 = _1283;
                              _1358 = _1286;
                            }
                            float _1374 = ((mad(0.16386906802654266f, _1358, mad(0.14067870378494263f, _1357, (_1356 * 0.6954522132873535f))) - _1271) * cb0_012w) + _1271;
                            float _1375 = ((mad(0.0955343171954155f, _1358, mad(0.8596711158752441f, _1357, (_1356 * 0.044794563204050064f))) - _1274) * cb0_012w) + _1274;
                            float _1376 = ((mad(1.0015007257461548f, _1358, mad(0.004025210160762072f, _1357, (_1356 * -0.005525882821530104f))) - _1277) * cb0_012w) + _1277;
                            float _1380 = max(max(_1374, _1375), _1376);
                            float _1385 = (max(_1380, 1.000000013351432e-10f) - max(min(min(_1374, _1375), _1376), 1.000000013351432e-10f)) / max(_1380, 0.009999999776482582f);
                            float _1398 = ((_1375 + _1374) + _1376) + (sqrt((((_1376 - _1375) * _1376) + ((_1375 - _1374) * _1375)) + ((_1374 - _1376) * _1374)) * 1.75f);
                            float _1399 = _1398 * 0.3333333432674408f;
                            float _1400 = _1385 + -0.4000000059604645f;
                            float _1401 = _1400 * 5.0f;
                            float _1405 = max((1.0f - abs(_1400 * 2.5f)), 0.0f);
                            float _1416 = ((float((int)(((int)(uint)((bool)(_1401 > 0.0f))) - ((int)(uint)((bool)(_1401 < 0.0f))))) * (1.0f - (_1405 * _1405))) + 1.0f) * 0.02500000037252903f;
                            do {
                              if (!(_1399 <= 0.0533333346247673f)) {
                                if (!(_1399 >= 0.1599999964237213f)) {
                                  _1425 = (((0.23999999463558197f / _1398) + -0.5f) * _1416);
                                } else {
                                  _1425 = 0.0f;
                                }
                              } else {
                                _1425 = _1416;
                              }
                              float _1426 = _1425 + 1.0f;
                              float _1427 = _1426 * _1374;
                              float _1428 = _1426 * _1375;
                              float _1429 = _1426 * _1376;
                              do {
                                if (!((bool)(_1427 == _1428) && (bool)(_1428 == _1429))) {
                                  float _1436 = ((_1427 * 2.0f) - _1428) - _1429;
                                  float _1439 = ((_1375 - _1376) * 1.7320507764816284f) * _1426;
                                  float _1441 = atan(_1439 / _1436);
                                  bool _1444 = (_1436 < 0.0f);
                                  bool _1445 = (_1436 == 0.0f);
                                  bool _1446 = (_1439 >= 0.0f);
                                  bool _1447 = (_1439 < 0.0f);
                                  _1458 = select((_1446 && _1445), 90.0f, select((_1447 && _1445), -90.0f, (select((_1447 && _1444), (_1441 + -3.1415927410125732f), select((_1446 && _1444), (_1441 + 3.1415927410125732f), _1441)) * 57.2957763671875f)));
                                } else {
                                  _1458 = 0.0f;
                                }
                                float _1463 = min(max(select((_1458 < 0.0f), (_1458 + 360.0f), _1458), 0.0f), 360.0f);
                                do {
                                  if (_1463 < -180.0f) {
                                    _1472 = (_1463 + 360.0f);
                                  } else {
                                    if (_1463 > 180.0f) {
                                      _1472 = (_1463 + -360.0f);
                                    } else {
                                      _1472 = _1463;
                                    }
                                  }
                                  do {
                                    if ((bool)(_1472 > -67.5f) && (bool)(_1472 < 67.5f)) {
                                      float _1478 = (_1472 + 67.5f) * 0.029629629105329514f;
                                      int _1479 = int(_1478);
                                      float _1481 = _1478 - float((int)(_1479));
                                      float _1482 = _1481 * _1481;
                                      float _1483 = _1482 * _1481;
                                      if (_1479 == 3) {
                                        _1511 = (((0.1666666716337204f - (_1481 * 0.5f)) + (_1482 * 0.5f)) - (_1483 * 0.1666666716337204f));
                                      } else {
                                        if (_1479 == 2) {
                                          _1511 = ((0.6666666865348816f - _1482) + (_1483 * 0.5f));
                                        } else {
                                          if (_1479 == 1) {
                                            _1511 = (((_1483 * -0.5f) + 0.1666666716337204f) + ((_1482 + _1481) * 0.5f));
                                          } else {
                                            _1511 = select((_1479 == 0), (_1483 * 0.1666666716337204f), 0.0f);
                                          }
                                        }
                                      }
                                    } else {
                                      _1511 = 0.0f;
                                    }
                                    float _1520 = min(max(((((_1385 * 0.27000001072883606f) * (0.029999999329447746f - _1427)) * _1511) + _1427), 0.0f), 65535.0f);
                                    float _1521 = min(max(_1428, 0.0f), 65535.0f);
                                    float _1522 = min(max(_1429, 0.0f), 65535.0f);
                                    float _1535 = min(max(mad(-0.21492856740951538f, _1522, mad(-0.2365107536315918f, _1521, (_1520 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                    float _1536 = min(max(mad(-0.09967592358589172f, _1522, mad(1.17622971534729f, _1521, (_1520 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                    float _1537 = min(max(mad(0.9977163076400757f, _1522, mad(-0.006032449658960104f, _1521, (_1520 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                    float _1538 = dot(float3(_1535, _1536, _1537), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                    float _1561 = log2(max((lerp(_1538, _1535, 0.9599999785423279f)), 1.000000013351432e-10f));
                                    float _1562 = _1561 * 0.3010300099849701f;
                                    float _1563 = log2(cb0_008x);
                                    float _1564 = _1563 * 0.3010300099849701f;
                                    do {
                                      if (!(!(_1562 <= _1564))) {
                                        _1633 = (log2(cb0_008y) * 0.3010300099849701f);
                                      } else {
                                        float _1571 = log2(cb0_009x);
                                        float _1572 = _1571 * 0.3010300099849701f;
                                        if ((bool)(_1562 > _1564) && (bool)(_1562 < _1572)) {
                                          float _1580 = ((_1561 - _1563) * 0.9030900001525879f) / ((_1571 - _1563) * 0.3010300099849701f);
                                          int _1581 = int(_1580);
                                          float _1583 = _1580 - float((int)(_1581));
                                          float _1585 = _16[_1581];
                                          float _1588 = _16[(_1581 + 1)];
                                          float _1593 = _1585 * 0.5f;
                                          _1633 = dot(float3((_1583 * _1583), _1583, 1.0f), float3(mad((_16[(_1581 + 2)]), 0.5f, mad(_1588, -1.0f, _1593)), (_1588 - _1585), mad(_1588, 0.5f, _1593)));
                                        } else {
                                          do {
                                            if (!(!(_1562 >= _1572))) {
                                              float _1602 = log2(cb0_008z);
                                              if (_1562 < (_1602 * 0.3010300099849701f)) {
                                                float _1610 = ((_1561 - _1571) * 0.9030900001525879f) / ((_1602 - _1571) * 0.3010300099849701f);
                                                int _1611 = int(_1610);
                                                float _1613 = _1610 - float((int)(_1611));
                                                float _1615 = _17[_1611];
                                                float _1618 = _17[(_1611 + 1)];
                                                float _1623 = _1615 * 0.5f;
                                                _1633 = dot(float3((_1613 * _1613), _1613, 1.0f), float3(mad((_17[(_1611 + 2)]), 0.5f, mad(_1618, -1.0f, _1623)), (_1618 - _1615), mad(_1618, 0.5f, _1623)));
                                                break;
                                              }
                                            }
                                            _1633 = (log2(cb0_008w) * 0.3010300099849701f);
                                          } while (false);
                                        }
                                      }
                                      _18[0] = cb0_011x;
                                      _18[1] = cb0_011y;
                                      _18[2] = cb0_011z;
                                      _18[3] = cb0_011w;
                                      _18[4] = cb0_012y;
                                      _18[5] = cb0_012y;
                                      float _1643 = log2(max((lerp(_1538, _1536, 0.9599999785423279f)), 1.000000013351432e-10f));
                                      float _1644 = _1643 * 0.3010300099849701f;
                                      do {
                                        if (!(!(_1644 <= _1564))) {
                                          _1713 = (log2(cb0_008y) * 0.3010300099849701f);
                                        } else {
                                          float _1651 = log2(cb0_009x);
                                          float _1652 = _1651 * 0.3010300099849701f;
                                          if ((bool)(_1644 > _1564) && (bool)(_1644 < _1652)) {
                                            float _1660 = ((_1643 - _1563) * 0.9030900001525879f) / ((_1651 - _1563) * 0.3010300099849701f);
                                            int _1661 = int(_1660);
                                            float _1663 = _1660 - float((int)(_1661));
                                            float _1665 = _8[_1661];
                                            float _1668 = _8[(_1661 + 1)];
                                            float _1673 = _1665 * 0.5f;
                                            _1713 = dot(float3((_1663 * _1663), _1663, 1.0f), float3(mad((_8[(_1661 + 2)]), 0.5f, mad(_1668, -1.0f, _1673)), (_1668 - _1665), mad(_1668, 0.5f, _1673)));
                                          } else {
                                            do {
                                              if (!(!(_1644 >= _1652))) {
                                                float _1682 = log2(cb0_008z);
                                                if (_1644 < (_1682 * 0.3010300099849701f)) {
                                                  float _1690 = ((_1643 - _1651) * 0.9030900001525879f) / ((_1682 - _1651) * 0.3010300099849701f);
                                                  int _1691 = int(_1690);
                                                  float _1693 = _1690 - float((int)(_1691));
                                                  float _1695 = _18[_1691];
                                                  float _1698 = _18[(_1691 + 1)];
                                                  float _1703 = _1695 * 0.5f;
                                                  _1713 = dot(float3((_1693 * _1693), _1693, 1.0f), float3(mad((_18[(_1691 + 2)]), 0.5f, mad(_1698, -1.0f, _1703)), (_1698 - _1695), mad(_1698, 0.5f, _1703)));
                                                  break;
                                                }
                                              }
                                              _1713 = (log2(cb0_008w) * 0.3010300099849701f);
                                            } while (false);
                                          }
                                        }
                                        float _1717 = log2(max((lerp(_1538, _1537, 0.9599999785423279f)), 1.000000013351432e-10f));
                                        float _1718 = _1717 * 0.3010300099849701f;
                                        do {
                                          if (!(!(_1718 <= _1564))) {
                                            _1787 = (log2(cb0_008y) * 0.3010300099849701f);
                                          } else {
                                            float _1725 = log2(cb0_009x);
                                            float _1726 = _1725 * 0.3010300099849701f;
                                            if ((bool)(_1718 > _1564) && (bool)(_1718 < _1726)) {
                                              float _1734 = ((_1717 - _1563) * 0.9030900001525879f) / ((_1725 - _1563) * 0.3010300099849701f);
                                              int _1735 = int(_1734);
                                              float _1737 = _1734 - float((int)(_1735));
                                              float _1739 = _8[_1735];
                                              float _1742 = _8[(_1735 + 1)];
                                              float _1747 = _1739 * 0.5f;
                                              _1787 = dot(float3((_1737 * _1737), _1737, 1.0f), float3(mad((_8[(_1735 + 2)]), 0.5f, mad(_1742, -1.0f, _1747)), (_1742 - _1739), mad(_1742, 0.5f, _1747)));
                                            } else {
                                              do {
                                                if (!(!(_1718 >= _1726))) {
                                                  float _1756 = log2(cb0_008z);
                                                  if (_1718 < (_1756 * 0.3010300099849701f)) {
                                                    float _1764 = ((_1717 - _1725) * 0.9030900001525879f) / ((_1756 - _1725) * 0.3010300099849701f);
                                                    int _1765 = int(_1764);
                                                    float _1767 = _1764 - float((int)(_1765));
                                                    float _1769 = _9[_1765];
                                                    float _1772 = _9[(_1765 + 1)];
                                                    float _1777 = _1769 * 0.5f;
                                                    _1787 = dot(float3((_1767 * _1767), _1767, 1.0f), float3(mad((_9[(_1765 + 2)]), 0.5f, mad(_1772, -1.0f, _1777)), (_1772 - _1769), mad(_1772, 0.5f, _1777)));
                                                    break;
                                                  }
                                                }
                                                _1787 = (log2(cb0_008w) * 0.3010300099849701f);
                                              } while (false);
                                            }
                                          }
                                          float _1791 = cb0_008w - cb0_008y;
                                          float _1792 = (exp2(_1633 * 3.321928024291992f) - cb0_008y) / _1791;
                                          float _1794 = (exp2(_1713 * 3.321928024291992f) - cb0_008y) / _1791;
                                          float _1796 = (exp2(_1787 * 3.321928024291992f) - cb0_008y) / _1791;
                                          float _1799 = mad(0.15618768334388733f, _1796, mad(0.13400420546531677f, _1794, (_1792 * 0.6624541878700256f)));
                                          float _1802 = mad(0.053689517080783844f, _1796, mad(0.6740817427635193f, _1794, (_1792 * 0.2722287178039551f)));
                                          float _1805 = mad(1.0103391408920288f, _1796, mad(0.00406073359772563f, _1794, (_1792 * -0.005574649665504694f)));
                                          float _1818 = min(max(mad(-0.23642469942569733f, _1805, mad(-0.32480329275131226f, _1802, (_1799 * 1.6410233974456787f))), 0.0f), 1.0f);
                                          float _1819 = min(max(mad(0.016756348311901093f, _1805, mad(1.6153316497802734f, _1802, (_1799 * -0.663662850856781f))), 0.0f), 1.0f);
                                          float _1820 = min(max(mad(0.9883948564529419f, _1805, mad(-0.008284442126750946f, _1802, (_1799 * 0.011721894145011902f))), 0.0f), 1.0f);
                                          float _1823 = mad(0.15618768334388733f, _1820, mad(0.13400420546531677f, _1819, (_1818 * 0.6624541878700256f)));
                                          float _1826 = mad(0.053689517080783844f, _1820, mad(0.6740817427635193f, _1819, (_1818 * 0.2722287178039551f)));
                                          float _1829 = mad(1.0103391408920288f, _1820, mad(0.00406073359772563f, _1819, (_1818 * -0.005574649665504694f)));
                                          float _1851 = min(max((min(max(mad(-0.23642469942569733f, _1829, mad(-0.32480329275131226f, _1826, (_1823 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                          float _1852 = min(max((min(max(mad(0.016756348311901093f, _1829, mad(1.6153316497802734f, _1826, (_1823 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                          float _1853 = min(max((min(max(mad(0.9883948564529419f, _1829, mad(-0.008284442126750946f, _1826, (_1823 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                          float _1872 = exp2(log2(mad(_52, _1853, mad(_51, _1852, (_1851 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                          float _1873 = exp2(log2(mad(_55, _1853, mad(_54, _1852, (_1851 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                          float _1874 = exp2(log2(mad(_58, _1853, mad(_57, _1852, (_1851 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                          _2678 = exp2(log2((1.0f / ((_1872 * 18.6875f) + 1.0f)) * ((_1872 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                          _2679 = exp2(log2((1.0f / ((_1873 * 18.6875f) + 1.0f)) * ((_1873 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                          _2680 = exp2(log2((1.0f / ((_1874 * 18.6875f) + 1.0f)) * ((_1874 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } else {
                          if ((uint)((uint)((int)(cb0_044w) + -5u)) < (uint)2) {
                            float _1940 = cb0_012z * _1085;
                            float _1941 = cb0_012z * _1086;
                            float _1942 = cb0_012z * _1087;
                            float _1945 = mad((WorkingColorSpace_256[0].z), _1942, mad((WorkingColorSpace_256[0].y), _1941, ((WorkingColorSpace_256[0].x) * _1940)));
                            float _1948 = mad((WorkingColorSpace_256[1].z), _1942, mad((WorkingColorSpace_256[1].y), _1941, ((WorkingColorSpace_256[1].x) * _1940)));
                            float _1951 = mad((WorkingColorSpace_256[2].z), _1942, mad((WorkingColorSpace_256[2].y), _1941, ((WorkingColorSpace_256[2].x) * _1940)));
                            float _1954 = mad(-0.21492856740951538f, _1951, mad(-0.2365107536315918f, _1948, (_1945 * 1.4514392614364624f)));
                            float _1957 = mad(-0.09967592358589172f, _1951, mad(1.17622971534729f, _1948, (_1945 * -0.07655377686023712f)));
                            float _1960 = mad(0.9977163076400757f, _1951, mad(-0.006032449658960104f, _1948, (_1945 * 0.008316148072481155f)));
                            float _1962 = max(_1954, max(_1957, _1960));
                            do {
                              if (!(_1962 < 1.000000013351432e-10f)) {
                                if (!(((bool)((bool)(_1945 < 0.0f) || (bool)(_1948 < 0.0f))) || (bool)(_1951 < 0.0f))) {
                                  float _1972 = abs(_1962);
                                  float _1973 = (_1962 - _1954) / _1972;
                                  float _1975 = (_1962 - _1957) / _1972;
                                  float _1977 = (_1962 - _1960) / _1972;
                                  do {
                                    if (!(_1973 < 0.8149999976158142f)) {
                                      float _1980 = _1973 + -0.8149999976158142f;
                                      _1992 = ((_1980 / exp2(log2(exp2(log2(_1980 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                    } else {
                                      _1992 = _1973;
                                    }
                                    do {
                                      if (!(_1975 < 0.8029999732971191f)) {
                                        float _1995 = _1975 + -0.8029999732971191f;
                                        _2007 = ((_1995 / exp2(log2(exp2(log2(_1995 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                      } else {
                                        _2007 = _1975;
                                      }
                                      do {
                                        if (!(_1977 < 0.8799999952316284f)) {
                                          float _2010 = _1977 + -0.8799999952316284f;
                                          _2022 = ((_2010 / exp2(log2(exp2(log2(_2010 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                        } else {
                                          _2022 = _1977;
                                        }
                                        _2030 = (_1962 - (_1972 * _1992));
                                        _2031 = (_1962 - (_1972 * _2007));
                                        _2032 = (_1962 - (_1972 * _2022));
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _2030 = _1954;
                                  _2031 = _1957;
                                  _2032 = _1960;
                                }
                              } else {
                                _2030 = _1954;
                                _2031 = _1957;
                                _2032 = _1960;
                              }
                              float _2048 = ((mad(0.16386906802654266f, _2032, mad(0.14067870378494263f, _2031, (_2030 * 0.6954522132873535f))) - _1945) * cb0_012w) + _1945;
                              float _2049 = ((mad(0.0955343171954155f, _2032, mad(0.8596711158752441f, _2031, (_2030 * 0.044794563204050064f))) - _1948) * cb0_012w) + _1948;
                              float _2050 = ((mad(1.0015007257461548f, _2032, mad(0.004025210160762072f, _2031, (_2030 * -0.005525882821530104f))) - _1951) * cb0_012w) + _1951;
                              float _2054 = max(max(_2048, _2049), _2050);
                              float _2059 = (max(_2054, 1.000000013351432e-10f) - max(min(min(_2048, _2049), _2050), 1.000000013351432e-10f)) / max(_2054, 0.009999999776482582f);
                              float _2072 = ((_2049 + _2048) + _2050) + (sqrt((((_2050 - _2049) * _2050) + ((_2049 - _2048) * _2049)) + ((_2048 - _2050) * _2048)) * 1.75f);
                              float _2073 = _2072 * 0.3333333432674408f;
                              float _2074 = _2059 + -0.4000000059604645f;
                              float _2075 = _2074 * 5.0f;
                              float _2079 = max((1.0f - abs(_2074 * 2.5f)), 0.0f);
                              float _2090 = ((float((int)(((int)(uint)((bool)(_2075 > 0.0f))) - ((int)(uint)((bool)(_2075 < 0.0f))))) * (1.0f - (_2079 * _2079))) + 1.0f) * 0.02500000037252903f;
                              do {
                                if (!(_2073 <= 0.0533333346247673f)) {
                                  if (!(_2073 >= 0.1599999964237213f)) {
                                    _2099 = (((0.23999999463558197f / _2072) + -0.5f) * _2090);
                                  } else {
                                    _2099 = 0.0f;
                                  }
                                } else {
                                  _2099 = _2090;
                                }
                                float _2100 = _2099 + 1.0f;
                                float _2101 = _2100 * _2048;
                                float _2102 = _2100 * _2049;
                                float _2103 = _2100 * _2050;
                                do {
                                  if (!((bool)(_2101 == _2102) && (bool)(_2102 == _2103))) {
                                    float _2110 = ((_2101 * 2.0f) - _2102) - _2103;
                                    float _2113 = ((_2049 - _2050) * 1.7320507764816284f) * _2100;
                                    float _2115 = atan(_2113 / _2110);
                                    bool _2118 = (_2110 < 0.0f);
                                    bool _2119 = (_2110 == 0.0f);
                                    bool _2120 = (_2113 >= 0.0f);
                                    bool _2121 = (_2113 < 0.0f);
                                    _2132 = select((_2120 && _2119), 90.0f, select((_2121 && _2119), -90.0f, (select((_2121 && _2118), (_2115 + -3.1415927410125732f), select((_2120 && _2118), (_2115 + 3.1415927410125732f), _2115)) * 57.2957763671875f)));
                                  } else {
                                    _2132 = 0.0f;
                                  }
                                  float _2137 = min(max(select((_2132 < 0.0f), (_2132 + 360.0f), _2132), 0.0f), 360.0f);
                                  do {
                                    if (_2137 < -180.0f) {
                                      _2146 = (_2137 + 360.0f);
                                    } else {
                                      if (_2137 > 180.0f) {
                                        _2146 = (_2137 + -360.0f);
                                      } else {
                                        _2146 = _2137;
                                      }
                                    }
                                    do {
                                      if ((bool)(_2146 > -67.5f) && (bool)(_2146 < 67.5f)) {
                                        float _2152 = (_2146 + 67.5f) * 0.029629629105329514f;
                                        int _2153 = int(_2152);
                                        float _2155 = _2152 - float((int)(_2153));
                                        float _2156 = _2155 * _2155;
                                        float _2157 = _2156 * _2155;
                                        if (_2153 == 3) {
                                          _2185 = (((0.1666666716337204f - (_2155 * 0.5f)) + (_2156 * 0.5f)) - (_2157 * 0.1666666716337204f));
                                        } else {
                                          if (_2153 == 2) {
                                            _2185 = ((0.6666666865348816f - _2156) + (_2157 * 0.5f));
                                          } else {
                                            if (_2153 == 1) {
                                              _2185 = (((_2157 * -0.5f) + 0.1666666716337204f) + ((_2156 + _2155) * 0.5f));
                                            } else {
                                              _2185 = select((_2153 == 0), (_2157 * 0.1666666716337204f), 0.0f);
                                            }
                                          }
                                        }
                                      } else {
                                        _2185 = 0.0f;
                                      }
                                      float _2194 = min(max(((((_2059 * 0.27000001072883606f) * (0.029999999329447746f - _2101)) * _2185) + _2101), 0.0f), 65535.0f);
                                      float _2195 = min(max(_2102, 0.0f), 65535.0f);
                                      float _2196 = min(max(_2103, 0.0f), 65535.0f);
                                      float _2209 = min(max(mad(-0.21492856740951538f, _2196, mad(-0.2365107536315918f, _2195, (_2194 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                      float _2210 = min(max(mad(-0.09967592358589172f, _2196, mad(1.17622971534729f, _2195, (_2194 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                      float _2211 = min(max(mad(0.9977163076400757f, _2196, mad(-0.006032449658960104f, _2195, (_2194 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                      float _2212 = dot(float3(_2209, _2210, _2211), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                      float _2235 = log2(max((lerp(_2212, _2209, 0.9599999785423279f)), 1.000000013351432e-10f));
                                      float _2236 = _2235 * 0.3010300099849701f;
                                      float _2237 = log2(cb0_008x);
                                      float _2238 = _2237 * 0.3010300099849701f;
                                      do {
                                        if (!(!(_2236 <= _2238))) {
                                          _2307 = (log2(cb0_008y) * 0.3010300099849701f);
                                        } else {
                                          float _2245 = log2(cb0_009x);
                                          float _2246 = _2245 * 0.3010300099849701f;
                                          if ((bool)(_2236 > _2238) && (bool)(_2236 < _2246)) {
                                            float _2254 = ((_2235 - _2237) * 0.9030900001525879f) / ((_2245 - _2237) * 0.3010300099849701f);
                                            int _2255 = int(_2254);
                                            float _2257 = _2254 - float((int)(_2255));
                                            float _2259 = _14[_2255];
                                            float _2262 = _14[(_2255 + 1)];
                                            float _2267 = _2259 * 0.5f;
                                            _2307 = dot(float3((_2257 * _2257), _2257, 1.0f), float3(mad((_14[(_2255 + 2)]), 0.5f, mad(_2262, -1.0f, _2267)), (_2262 - _2259), mad(_2262, 0.5f, _2267)));
                                          } else {
                                            do {
                                              if (!(!(_2236 >= _2246))) {
                                                float _2276 = log2(cb0_008z);
                                                if (_2236 < (_2276 * 0.3010300099849701f)) {
                                                  float _2284 = ((_2235 - _2245) * 0.9030900001525879f) / ((_2276 - _2245) * 0.3010300099849701f);
                                                  int _2285 = int(_2284);
                                                  float _2287 = _2284 - float((int)(_2285));
                                                  float _2289 = _15[_2285];
                                                  float _2292 = _15[(_2285 + 1)];
                                                  float _2297 = _2289 * 0.5f;
                                                  _2307 = dot(float3((_2287 * _2287), _2287, 1.0f), float3(mad((_15[(_2285 + 2)]), 0.5f, mad(_2292, -1.0f, _2297)), (_2292 - _2289), mad(_2292, 0.5f, _2297)));
                                                  break;
                                                }
                                              }
                                              _2307 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                        float _2323 = log2(max((lerp(_2212, _2210, 0.9599999785423279f)), 1.000000013351432e-10f));
                                        float _2324 = _2323 * 0.3010300099849701f;
                                        do {
                                          if (!(!(_2324 <= _2238))) {
                                            _2393 = (log2(cb0_008y) * 0.3010300099849701f);
                                          } else {
                                            float _2331 = log2(cb0_009x);
                                            float _2332 = _2331 * 0.3010300099849701f;
                                            if ((bool)(_2324 > _2238) && (bool)(_2324 < _2332)) {
                                              float _2340 = ((_2323 - _2237) * 0.9030900001525879f) / ((_2331 - _2237) * 0.3010300099849701f);
                                              int _2341 = int(_2340);
                                              float _2343 = _2340 - float((int)(_2341));
                                              float _2345 = _10[_2341];
                                              float _2348 = _10[(_2341 + 1)];
                                              float _2353 = _2345 * 0.5f;
                                              _2393 = dot(float3((_2343 * _2343), _2343, 1.0f), float3(mad((_10[(_2341 + 2)]), 0.5f, mad(_2348, -1.0f, _2353)), (_2348 - _2345), mad(_2348, 0.5f, _2353)));
                                            } else {
                                              do {
                                                if (!(!(_2324 >= _2332))) {
                                                  float _2362 = log2(cb0_008z);
                                                  if (_2324 < (_2362 * 0.3010300099849701f)) {
                                                    float _2370 = ((_2323 - _2331) * 0.9030900001525879f) / ((_2362 - _2331) * 0.3010300099849701f);
                                                    int _2371 = int(_2370);
                                                    float _2373 = _2370 - float((int)(_2371));
                                                    float _2375 = _11[_2371];
                                                    float _2378 = _11[(_2371 + 1)];
                                                    float _2383 = _2375 * 0.5f;
                                                    _2393 = dot(float3((_2373 * _2373), _2373, 1.0f), float3(mad((_11[(_2371 + 2)]), 0.5f, mad(_2378, -1.0f, _2383)), (_2378 - _2375), mad(_2378, 0.5f, _2383)));
                                                    break;
                                                  }
                                                }
                                                _2393 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                          float _2409 = log2(max((lerp(_2212, _2211, 0.9599999785423279f)), 1.000000013351432e-10f));
                                          float _2410 = _2409 * 0.3010300099849701f;
                                          do {
                                            if (!(!(_2410 <= _2238))) {
                                              _2479 = (log2(cb0_008y) * 0.3010300099849701f);
                                            } else {
                                              float _2417 = log2(cb0_009x);
                                              float _2418 = _2417 * 0.3010300099849701f;
                                              if ((bool)(_2410 > _2238) && (bool)(_2410 < _2418)) {
                                                float _2426 = ((_2409 - _2237) * 0.9030900001525879f) / ((_2417 - _2237) * 0.3010300099849701f);
                                                int _2427 = int(_2426);
                                                float _2429 = _2426 - float((int)(_2427));
                                                float _2431 = _12[_2427];
                                                float _2434 = _12[(_2427 + 1)];
                                                float _2439 = _2431 * 0.5f;
                                                _2479 = dot(float3((_2429 * _2429), _2429, 1.0f), float3(mad((_12[(_2427 + 2)]), 0.5f, mad(_2434, -1.0f, _2439)), (_2434 - _2431), mad(_2434, 0.5f, _2439)));
                                              } else {
                                                do {
                                                  if (!(!(_2410 >= _2418))) {
                                                    float _2448 = log2(cb0_008z);
                                                    if (_2410 < (_2448 * 0.3010300099849701f)) {
                                                      float _2456 = ((_2409 - _2417) * 0.9030900001525879f) / ((_2448 - _2417) * 0.3010300099849701f);
                                                      int _2457 = int(_2456);
                                                      float _2459 = _2456 - float((int)(_2457));
                                                      float _2461 = _13[_2457];
                                                      float _2464 = _13[(_2457 + 1)];
                                                      float _2469 = _2461 * 0.5f;
                                                      _2479 = dot(float3((_2459 * _2459), _2459, 1.0f), float3(mad((_13[(_2457 + 2)]), 0.5f, mad(_2464, -1.0f, _2469)), (_2464 - _2461), mad(_2464, 0.5f, _2469)));
                                                      break;
                                                    }
                                                  }
                                                  _2479 = (log2(cb0_008w) * 0.3010300099849701f);
                                                } while (false);
                                              }
                                            }
                                            float _2483 = cb0_008w - cb0_008y;
                                            float _2484 = (exp2(_2307 * 3.321928024291992f) - cb0_008y) / _2483;
                                            float _2486 = (exp2(_2393 * 3.321928024291992f) - cb0_008y) / _2483;
                                            float _2488 = (exp2(_2479 * 3.321928024291992f) - cb0_008y) / _2483;
                                            float _2491 = mad(0.15618768334388733f, _2488, mad(0.13400420546531677f, _2486, (_2484 * 0.6624541878700256f)));
                                            float _2494 = mad(0.053689517080783844f, _2488, mad(0.6740817427635193f, _2486, (_2484 * 0.2722287178039551f)));
                                            float _2497 = mad(1.0103391408920288f, _2488, mad(0.00406073359772563f, _2486, (_2484 * -0.005574649665504694f)));
                                            float _2510 = min(max(mad(-0.23642469942569733f, _2497, mad(-0.32480329275131226f, _2494, (_2491 * 1.6410233974456787f))), 0.0f), 1.0f);
                                            float _2511 = min(max(mad(0.016756348311901093f, _2497, mad(1.6153316497802734f, _2494, (_2491 * -0.663662850856781f))), 0.0f), 1.0f);
                                            float _2512 = min(max(mad(0.9883948564529419f, _2497, mad(-0.008284442126750946f, _2494, (_2491 * 0.011721894145011902f))), 0.0f), 1.0f);
                                            float _2515 = mad(0.15618768334388733f, _2512, mad(0.13400420546531677f, _2511, (_2510 * 0.6624541878700256f)));
                                            float _2518 = mad(0.053689517080783844f, _2512, mad(0.6740817427635193f, _2511, (_2510 * 0.2722287178039551f)));
                                            float _2521 = mad(1.0103391408920288f, _2512, mad(0.00406073359772563f, _2511, (_2510 * -0.005574649665504694f)));
                                            float _2543 = min(max((min(max(mad(-0.23642469942569733f, _2521, mad(-0.32480329275131226f, _2518, (_2515 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                            float _2546 = min(max((min(max(mad(0.016756348311901093f, _2521, mad(1.6153316497802734f, _2518, (_2515 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                            float _2547 = min(max((min(max(mad(0.9883948564529419f, _2521, mad(-0.008284442126750946f, _2518, (_2515 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                            _2678 = mad(-0.0832589864730835f, _2547, mad(-0.6217921376228333f, _2546, (_2543 * 0.0213131383061409f)));
                                            _2679 = mad(-0.010548308491706848f, _2547, mad(1.140804648399353f, _2546, (_2543 * -0.0016282059950754046f)));
                                            _2680 = mad(1.1529725790023804f, _2547, mad(-0.1289689838886261f, _2546, (_2543 * -0.00030004189466126263f)));
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } while (false);
                          } else {
                            if (cb0_044w == 7) {
                              float _2566 = mad((WorkingColorSpace_128[0].z), _1087, mad((WorkingColorSpace_128[0].y), _1086, ((WorkingColorSpace_128[0].x) * _1085)));
                              float _2569 = mad((WorkingColorSpace_128[1].z), _1087, mad((WorkingColorSpace_128[1].y), _1086, ((WorkingColorSpace_128[1].x) * _1085)));
                              float _2572 = mad((WorkingColorSpace_128[2].z), _1087, mad((WorkingColorSpace_128[2].y), _1086, ((WorkingColorSpace_128[2].x) * _1085)));
                              float _2591 = exp2(log2(mad(_52, _2572, mad(_51, _2569, (_2566 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
                              float _2592 = exp2(log2(mad(_55, _2572, mad(_54, _2569, (_2566 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
                              float _2593 = exp2(log2(mad(_58, _2572, mad(_57, _2569, (_2566 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
                              _2678 = exp2(log2((1.0f / ((_2591 * 18.6875f) + 1.0f)) * ((_2591 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                              _2679 = exp2(log2((1.0f / ((_2592 * 18.6875f) + 1.0f)) * ((_2592 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                              _2680 = exp2(log2((1.0f / ((_2593 * 18.6875f) + 1.0f)) * ((_2593 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            } else {
                              if (!(cb0_044w == 8)) {
                                if (cb0_044w == 9) {
                                  float _2632 = mad((WorkingColorSpace_128[0].z), _1075, mad((WorkingColorSpace_128[0].y), _1074, ((WorkingColorSpace_128[0].x) * _1073)));
                                  float _2635 = mad((WorkingColorSpace_128[1].z), _1075, mad((WorkingColorSpace_128[1].y), _1074, ((WorkingColorSpace_128[1].x) * _1073)));
                                  float _2638 = mad((WorkingColorSpace_128[2].z), _1075, mad((WorkingColorSpace_128[2].y), _1074, ((WorkingColorSpace_128[2].x) * _1073)));
                                  _2678 = mad(_52, _2638, mad(_51, _2635, (_2632 * _50)));
                                  _2679 = mad(_55, _2638, mad(_54, _2635, (_2632 * _53)));
                                  _2680 = mad(_58, _2638, mad(_57, _2635, (_2632 * _56)));
                                } else {
                                  float _2651 = mad((WorkingColorSpace_128[0].z), _1101, mad((WorkingColorSpace_128[0].y), _1100, ((WorkingColorSpace_128[0].x) * _1099)));
                                  float _2654 = mad((WorkingColorSpace_128[1].z), _1101, mad((WorkingColorSpace_128[1].y), _1100, ((WorkingColorSpace_128[1].x) * _1099)));
                                  float _2657 = mad((WorkingColorSpace_128[2].z), _1101, mad((WorkingColorSpace_128[2].y), _1100, ((WorkingColorSpace_128[2].x) * _1099)));
                                  _2678 = exp2(log2(mad(_52, _2657, mad(_51, _2654, (_2651 * _50)))) * cb0_044z);
                                  _2679 = exp2(log2(mad(_55, _2657, mad(_54, _2654, (_2651 * _53)))) * cb0_044z);
                                  _2680 = exp2(log2(mad(_58, _2657, mad(_57, _2654, (_2651 * _56)))) * cb0_044z);
                                }
                              } else {
                                _2678 = _1085;
                                _2679 = _1086;
                                _2680 = _1087;
                              }
                            }
                          }
                        }
                      }
                    }
                    SV_Target.x = (_2678 * 0.9523810148239136f);
                    SV_Target.y = (_2679 * 0.9523810148239136f);
                    SV_Target.z = (_2680 * 0.9523810148239136f);
                    SV_Target.w = 0.0f;
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  bool _154 = (cb0_042z != 0);
  float _156 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _173 = (((((2967800.0f - (_156 * 4607000064.0f)) * _156) + 99.11000061035156f) * _156) + 0.24406300485134125f);
  } else {
    _173 = (((((1901800.0f - (_156 * 2006400000.0f)) * _156) + 247.47999572753906f) * _156) + 0.23703999817371368f);
  }
  float _187 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _194 = cb0_037y * cb0_037y;
  float _197 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_194 * 1.6145605741257896e-07f));
  float _202 = ((_187 * 2.0f) + 4.0f) - (_197 * 8.0f);
  float _203 = (_187 * 3.0f) / _202;
  float _205 = (_197 * 2.0f) / _202;
  bool _206 = (cb0_037y < 4000.0f);
  float _215 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _217 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_194 * 1.5317699909210205f)) / (_215 * _215);
  float _224 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _194;
  float _226 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_194 * 308.60699462890625f)) / (_224 * _224);
  float _228 = rsqrt(dot(float2(_217, _226), float2(_217, _226)));
  float _229 = cb0_037z * 0.05000000074505806f;
  float _232 = ((_229 * _226) * _228) + _187;
  float _235 = _197 - ((_229 * _217) * _228);
  float _240 = (4.0f - (_235 * 8.0f)) + (_232 * 2.0f);
  float _246 = (((_232 * 3.0f) / _240) - _203) + select(_206, _203, _173);
  float _247 = (((_235 * 2.0f) / _240) - _205) + select(_206, _205, (((_173 * 2.869999885559082f) + -0.2750000059604645f) - ((_173 * _173) * 3.0f)));
  float _248 = select(_154, _246, 0.3127000033855438f);
  float _249 = select(_154, _247, 0.32899999618530273f);
  float _250 = select(_154, 0.3127000033855438f, _246);
  float _251 = select(_154, 0.32899999618530273f, _247);
  float _252 = max(_249, 1.000000013351432e-10f);
  float _253 = _248 / _252;
  float _256 = ((1.0f - _248) - _249) / _252;
  float _257 = max(_251, 1.000000013351432e-10f);
  float _258 = _250 / _257;
  float _261 = ((1.0f - _250) - _251) / _257;
  float _280 = mad(-0.16140000522136688f, _261, ((_258 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _256, ((_253 * 0.8950999975204468f) + 0.266400009393692f));
  float _281 = mad(0.03669999912381172f, _261, (1.7135000228881836f - (_258 * 0.7501999735832214f))) / mad(0.03669999912381172f, _256, (1.7135000228881836f - (_253 * 0.7501999735832214f)));
  float _282 = mad(1.0296000242233276f, _261, ((_258 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _256, ((_253 * 0.03889999911189079f) + -0.06849999725818634f));
  float _283 = mad(_281, -0.7501999735832214f, 0.0f);
  float _284 = mad(_281, 1.7135000228881836f, 0.0f);
  float _285 = mad(_281, 0.03669999912381172f, -0.0f);
  float _286 = mad(_282, 0.03889999911189079f, 0.0f);
  float _287 = mad(_282, -0.06849999725818634f, 0.0f);
  float _288 = mad(_282, 1.0296000242233276f, 0.0f);
  float _291 = mad(0.1599626988172531f, _286, mad(-0.1470542997121811f, _283, (_280 * 0.883457362651825f)));
  float _294 = mad(0.1599626988172531f, _287, mad(-0.1470542997121811f, _284, (_280 * 0.26293492317199707f)));
  float _297 = mad(0.1599626988172531f, _288, mad(-0.1470542997121811f, _285, (_280 * -0.15930065512657166f)));
  float _300 = mad(0.04929120093584061f, _286, mad(0.5183603167533875f, _283, (_280 * 0.38695648312568665f)));
  float _303 = mad(0.04929120093584061f, _287, mad(0.5183603167533875f, _284, (_280 * 0.11516613513231277f)));
  float _306 = mad(0.04929120093584061f, _288, mad(0.5183603167533875f, _285, (_280 * -0.0697740763425827f)));
  float _309 = mad(0.9684867262840271f, _286, mad(0.04004279896616936f, _283, (_280 * -0.007634039502590895f)));
  float _312 = mad(0.9684867262840271f, _287, mad(0.04004279896616936f, _284, (_280 * -0.0022720457054674625f)));
  float _315 = mad(0.9684867262840271f, _288, mad(0.04004279896616936f, _285, (_280 * 0.0013765322510153055f)));
  float _318 = mad(_297, (WorkingColorSpace_000[2].x), mad(_294, (WorkingColorSpace_000[1].x), (_291 * (WorkingColorSpace_000[0].x))));
  float _321 = mad(_297, (WorkingColorSpace_000[2].y), mad(_294, (WorkingColorSpace_000[1].y), (_291 * (WorkingColorSpace_000[0].y))));
  float _324 = mad(_297, (WorkingColorSpace_000[2].z), mad(_294, (WorkingColorSpace_000[1].z), (_291 * (WorkingColorSpace_000[0].z))));
  float _327 = mad(_306, (WorkingColorSpace_000[2].x), mad(_303, (WorkingColorSpace_000[1].x), (_300 * (WorkingColorSpace_000[0].x))));
  float _330 = mad(_306, (WorkingColorSpace_000[2].y), mad(_303, (WorkingColorSpace_000[1].y), (_300 * (WorkingColorSpace_000[0].y))));
  float _333 = mad(_306, (WorkingColorSpace_000[2].z), mad(_303, (WorkingColorSpace_000[1].z), (_300 * (WorkingColorSpace_000[0].z))));
  float _336 = mad(_315, (WorkingColorSpace_000[2].x), mad(_312, (WorkingColorSpace_000[1].x), (_309 * (WorkingColorSpace_000[0].x))));
  float _339 = mad(_315, (WorkingColorSpace_000[2].y), mad(_312, (WorkingColorSpace_000[1].y), (_309 * (WorkingColorSpace_000[0].y))));
  float _342 = mad(_315, (WorkingColorSpace_000[2].z), mad(_312, (WorkingColorSpace_000[1].z), (_309 * (WorkingColorSpace_000[0].z))));
  _380 = mad(mad((WorkingColorSpace_064[0].z), _342, mad((WorkingColorSpace_064[0].y), _333, (_324 * (WorkingColorSpace_064[0].x)))), _118, mad(mad((WorkingColorSpace_064[0].z), _339, mad((WorkingColorSpace_064[0].y), _330, (_321 * (WorkingColorSpace_064[0].x)))), _117, (mad((WorkingColorSpace_064[0].z), _336, mad((WorkingColorSpace_064[0].y), _327, (_318 * (WorkingColorSpace_064[0].x)))) * _116)));
  _381 = mad(mad((WorkingColorSpace_064[1].z), _342, mad((WorkingColorSpace_064[1].y), _333, (_324 * (WorkingColorSpace_064[1].x)))), _118, mad(mad((WorkingColorSpace_064[1].z), _339, mad((WorkingColorSpace_064[1].y), _330, (_321 * (WorkingColorSpace_064[1].x)))), _117, (mad((WorkingColorSpace_064[1].z), _336, mad((WorkingColorSpace_064[1].y), _327, (_318 * (WorkingColorSpace_064[1].x)))) * _116)));
  _382 = mad(mad((WorkingColorSpace_064[2].z), _342, mad((WorkingColorSpace_064[2].y), _333, (_324 * (WorkingColorSpace_064[2].x)))), _118, mad(mad((WorkingColorSpace_064[2].z), _339, mad((WorkingColorSpace_064[2].y), _330, (_321 * (WorkingColorSpace_064[2].x)))), _117, (mad((WorkingColorSpace_064[2].z), _336, mad((WorkingColorSpace_064[2].y), _327, (_318 * (WorkingColorSpace_064[2].x)))) * _116)));
  float _397 = mad((WorkingColorSpace_128[0].z), _382, mad((WorkingColorSpace_128[0].y), _381, ((WorkingColorSpace_128[0].x) * _380)));
  float _400 = mad((WorkingColorSpace_128[1].z), _382, mad((WorkingColorSpace_128[1].y), _381, ((WorkingColorSpace_128[1].x) * _380)));
  float _403 = mad((WorkingColorSpace_128[2].z), _382, mad((WorkingColorSpace_128[2].y), _381, ((WorkingColorSpace_128[2].x) * _380)));
  SetUngradedAP1(float3(_397, _400, _403));
  float _404 = dot(float3(_397, _400, _403), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _408 = (_397 / _404) + -1.0f;
  float _409 = (_400 / _404) + -1.0f;
  float _410 = (_403 / _404) + -1.0f;
  float _422 = (1.0f - exp2(((_404 * _404) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_408, _409, _410), float3(_408, _409, _410)) * -4.0f));
  float _438 = ((mad(-0.06368321925401688f, _403, mad(-0.3292922377586365f, _400, (_397 * 1.3704125881195068f))) - _397) * _422) + _397;
  float _439 = ((mad(-0.010861365124583244f, _403, mad(1.0970927476882935f, _400, (_397 * -0.08343357592821121f))) - _400) * _422) + _400;
  float _440 = ((mad(1.2036951780319214f, _403, mad(-0.09862580895423889f, _400, (_397 * -0.02579331398010254f))) - _403) * _422) + _403;
  float _441 = dot(float3(_438, _439, _440), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _455 = cb0_021w + cb0_026w;
  float _469 = cb0_020w * cb0_025w;
  float _483 = cb0_019w * cb0_024w;
  float _497 = cb0_018w * cb0_023w;
  float _511 = cb0_017w * cb0_022w;
  float _515 = _438 - _441;
  float _516 = _439 - _441;
  float _517 = _440 - _441;
  float _574 = saturate(_441 / cb0_037w);
  float _578 = (_574 * _574) * (3.0f - (_574 * 2.0f));
  float _579 = 1.0f - _578;
  float _588 = cb0_021w + cb0_036w;
  float _597 = cb0_020w * cb0_035w;
  float _606 = cb0_019w * cb0_034w;
  float _615 = cb0_018w * cb0_033w;
  float _624 = cb0_017w * cb0_032w;
  float _687 = saturate((_441 - cb0_038x) / (cb0_038y - cb0_038x));
  float _691 = (_687 * _687) * (3.0f - (_687 * 2.0f));
  float _700 = cb0_021w + cb0_031w;
  float _709 = cb0_020w * cb0_030w;
  float _718 = cb0_019w * cb0_029w;
  float _727 = cb0_018w * cb0_028w;
  float _736 = cb0_017w * cb0_027w;
  float _794 = _578 - _691;
  float _805 = ((_691 * (((cb0_021x + cb0_036x) + _588) + (((cb0_020x * cb0_035x) * _597) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _615) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _624) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _606)))))) + (_579 * (((cb0_021x + cb0_026x) + _455) + (((cb0_020x * cb0_025x) * _469) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _497) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _511) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _483))))))) + ((((cb0_021x + cb0_031x) + _700) + (((cb0_020x * cb0_030x) * _709) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _727) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _736) * _515) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _718))))) * _794);
  float _807 = ((_691 * (((cb0_021y + cb0_036y) + _588) + (((cb0_020y * cb0_035y) * _597) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _615) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _624) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _606)))))) + (_579 * (((cb0_021y + cb0_026y) + _455) + (((cb0_020y * cb0_025y) * _469) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _497) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _511) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _483))))))) + ((((cb0_021y + cb0_031y) + _700) + (((cb0_020y * cb0_030y) * _709) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _727) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _736) * _516) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _718))))) * _794);
  float _809 = ((_691 * (((cb0_021z + cb0_036z) + _588) + (((cb0_020z * cb0_035z) * _597) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _615) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _624) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _606)))))) + (_579 * (((cb0_021z + cb0_026z) + _455) + (((cb0_020z * cb0_025z) * _469) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _497) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _511) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _483))))))) + ((((cb0_021z + cb0_031z) + _700) + (((cb0_020z * cb0_030z) * _709) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _727) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _736) * _517) + _441)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _718))))) * _794);
  float _845 = ((mad(0.061360642313957214f, _809, mad(-4.540197551250458e-09f, _807, (_805 * 0.9386394023895264f))) - _805) * cb0_038z) + _805;
  float _846 = ((mad(0.169205904006958f, _809, mad(0.8307942152023315f, _807, (_805 * 6.775371730327606e-08f))) - _807) * cb0_038z) + _807;
  float _847 = (mad(-2.3283064365386963e-10f, _807, (_805 * -9.313225746154785e-10f)) * cb0_038z) + _809;
  SetUntonemappedAP1(float3(_805, _807, _809));
  float _859 = ((cb0_040w - cb0_041y) * cb0_041z) / cb0_041x;
  float _860 = _845 - cb0_041y;
  float _863 = _845 / cb0_041y;
  float _872 = cb0_040w - ((_859 * cb0_041x) + cb0_041y);
  float _873 = (cb0_040w * cb0_041x) / _872;
  if (!(_845 <= 0.0f)) {
    if (!(_845 >= cb0_041y)) {
      _891 = (((_863 * _863) * 3.0f) - (_863 * 2.0f));
    } else {
      _891 = 1.0f;
    }
  } else {
    _891 = 0.0f;
  }
  float _893 = _859 + cb0_041y;
  if (!(_845 <= _893)) {
    if (!(_845 >= ((cb0_041y + 0.0010000000474974513f) + _859))) {
      _903 = ((_845 - _893) * 999.9999389648438f);
    } else {
      _903 = 1.0f;
    }
  } else {
    _903 = 0.0f;
  }
  float _908 = _846 - cb0_041y;
  float _911 = _846 / cb0_041y;
  if (!(_846 <= 0.0f)) {
    if (!(_846 >= cb0_041y)) {
      _934 = (((_911 * _911) * 3.0f) - (_911 * 2.0f));
    } else {
      _934 = 1.0f;
    }
  } else {
    _934 = 0.0f;
  }
  if (!(_846 <= _893)) {
    if (!(_846 >= ((cb0_041y + 0.0010000000474974513f) + _859))) {
      _945 = ((_846 - _893) * 999.9999389648438f);
    } else {
      _945 = 1.0f;
    }
  } else {
    _945 = 0.0f;
  }
  float _950 = _847 - cb0_041y;
  float _953 = _847 / cb0_041y;
  if (!(_847 <= 0.0f)) {
    if (!(_847 >= cb0_041y)) {
      _976 = (((_953 * _953) * 3.0f) - (_953 * 2.0f));
    } else {
      _976 = 1.0f;
    }
  } else {
    _976 = 0.0f;
  }
  if (!(_847 <= _893)) {
    if (!(_847 >= ((cb0_041y + 0.0010000000474974513f) + _859))) {
      _987 = ((_847 - _893) * 999.9999389648438f);
    } else {
      _987 = 1.0f;
    }
  } else {
    _987 = 0.0f;
  }
  float _1006 = (cb0_039x * (((((1.0f - _891) * (((pow(_863, cb0_042x)) * cb0_041y) + cb0_041w)) - _845) + (_903 * (cb0_040w - (exp2(((-0.0f - ((_860 - _859) * _873)) / cb0_040w) * 1.442694067955017f) * _872)))) + ((_891 - _903) * ((cb0_041x * _860) + cb0_041y)))) + _845;
  float _1007 = (cb0_039x * (((((1.0f - _934) * (((pow(_911, cb0_042x)) * cb0_041y) + cb0_041w)) - _846) + (_945 * (cb0_040w - (exp2(((-0.0f - ((_908 - _859) * _873)) / cb0_040w) * 1.442694067955017f) * _872)))) + ((_934 - _945) * ((cb0_041x * _908) + cb0_041y)))) + _846;
  float _1008 = ((((((1.0f - _976) * (((pow(_953, cb0_042x)) * cb0_041y) + cb0_041w)) - _847) + (_987 * (cb0_040w - (exp2(((-0.0f - ((_950 - _859) * _873)) / cb0_040w) * 1.442694067955017f) * _872)))) + ((_976 - _987) * ((cb0_041x * _950) + cb0_041y))) * cb0_039x) + _847;
  float _1024 = ((mad(-0.06537103652954102f, _1008, mad(1.451815478503704e-06f, _1007, (_1006 * 1.065374732017517f))) - _1006) * cb0_038z) + _1006;
  float _1025 = ((mad(-0.20366770029067993f, _1008, mad(1.2036634683609009f, _1007, (_1006 * -2.57161445915699e-07f))) - _1007) * cb0_038z) + _1007;
  float _1026 = ((mad(0.9999996423721313f, _1008, mad(2.0954757928848267e-08f, _1007, (_1006 * 1.862645149230957e-08f))) - _1008) * cb0_038z) + _1008;
  SetTonemappedAP1(_1024, _1025, _1026);
  float _1036 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1026, mad((WorkingColorSpace_192[0].y), _1025, ((WorkingColorSpace_192[0].x) * _1024))));
  float _1037 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1026, mad((WorkingColorSpace_192[1].y), _1025, ((WorkingColorSpace_192[1].x) * _1024))));
  float _1038 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1026, mad((WorkingColorSpace_192[2].y), _1025, ((WorkingColorSpace_192[2].x) * _1024))));
  float _1064 = cb0_016x * (((cb0_043y + (cb0_043x * _1036)) * _1036) + cb0_043z);
  float _1065 = cb0_016y * (((cb0_043y + (cb0_043x * _1037)) * _1037) + cb0_043z);
  float _1066 = cb0_016z * (((cb0_043y + (cb0_043x * _1038)) * _1038) + cb0_043z);
  float _1073 = ((cb0_015x - _1064) * cb0_015w) + _1064;
  float _1074 = ((cb0_015y - _1065) * cb0_015w) + _1065;
  float _1075 = ((cb0_015z - _1066) * cb0_015w) + _1066;
  float _1076 = cb0_016x * mad((WorkingColorSpace_192[0].z), _809, mad((WorkingColorSpace_192[0].y), _807, (_805 * (WorkingColorSpace_192[0].x))));
  float _1077 = cb0_016y * mad((WorkingColorSpace_192[1].z), _809, mad((WorkingColorSpace_192[1].y), _807, ((WorkingColorSpace_192[1].x) * _805)));
  float _1078 = cb0_016z * mad((WorkingColorSpace_192[2].z), _809, mad((WorkingColorSpace_192[2].y), _807, ((WorkingColorSpace_192[2].x) * _805)));
  float _1085 = ((cb0_015x - _1076) * cb0_015w) + _1076;
  float _1086 = ((cb0_015y - _1077) * cb0_015w) + _1077;
  float _1087 = ((cb0_015z - _1078) * cb0_015w) + _1078;
  float _1099 = exp2(log2(max(0.0f, _1073)) * cb0_044y);
  float _1100 = exp2(log2(max(0.0f, _1074)) * cb0_044y);
  float _1101 = exp2(log2(max(0.0f, _1075)) * cb0_044y);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return GenerateOutput(float3(_1099, _1100, _1101), cb0_044w);
  }
  [branch]
  if (cb0_044w == 0) {
    do {
      if (WorkingColorSpace_384 == 0) {
        float _1116 = mad((WorkingColorSpace_128[0].z), _1101, mad((WorkingColorSpace_128[0].y), _1100, ((WorkingColorSpace_128[0].x) * _1099)));
        float _1119 = mad((WorkingColorSpace_128[1].z), _1101, mad((WorkingColorSpace_128[1].y), _1100, ((WorkingColorSpace_128[1].x) * _1099)));
        float _1122 = mad((WorkingColorSpace_128[2].z), _1101, mad((WorkingColorSpace_128[2].y), _1100, ((WorkingColorSpace_128[2].x) * _1099)));
        _1133 = mad(_52, _1122, mad(_51, _1119, (_1116 * _50)));
        _1134 = mad(_55, _1122, mad(_54, _1119, (_1116 * _53)));
        _1135 = mad(_58, _1122, mad(_57, _1119, (_1116 * _56)));
      } else {
        _1133 = _1099;
        _1134 = _1100;
        _1135 = _1101;
      }
      do {
        if (_1133 < 0.0031306699384003878f) {
          _1146 = (_1133 * 12.920000076293945f);
        } else {
          _1146 = (((pow(_1133, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1134 < 0.0031306699384003878f) {
            _1157 = (_1134 * 12.920000076293945f);
          } else {
            _1157 = (((pow(_1134, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1135 < 0.0031306699384003878f) {
            _2678 = _1146;
            _2679 = _1157;
            _2680 = (_1135 * 12.920000076293945f);
          } else {
            _2678 = _1146;
            _2679 = _1157;
            _2680 = (((pow(_1135, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_044w == 1) {
      float _1176 = mad((WorkingColorSpace_128[0].z), _1101, mad((WorkingColorSpace_128[0].y), _1100, ((WorkingColorSpace_128[0].x) * _1099)));
      float _1179 = mad((WorkingColorSpace_128[1].z), _1101, mad((WorkingColorSpace_128[1].y), _1100, ((WorkingColorSpace_128[1].x) * _1099)));
      float _1182 = mad((WorkingColorSpace_128[2].z), _1101, mad((WorkingColorSpace_128[2].y), _1100, ((WorkingColorSpace_128[2].x) * _1099)));
      float _1185 = mad(_52, _1182, mad(_51, _1179, (_1176 * _50)));
      float _1188 = mad(_55, _1182, mad(_54, _1179, (_1176 * _53)));
      float _1191 = mad(_58, _1182, mad(_57, _1179, (_1176 * _56)));
      _2678 = min((_1185 * 4.5f), ((exp2(log2(max(_1185, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2679 = min((_1188 * 4.5f), ((exp2(log2(max(_1188, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2680 = min((_1191 * 4.5f), ((exp2(log2(max(_1191, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((uint)((int)(cb0_044w) + -3u)) < (uint)2) {
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
        float _1266 = cb0_012z * _1085;
        float _1267 = cb0_012z * _1086;
        float _1268 = cb0_012z * _1087;
        float _1271 = mad((WorkingColorSpace_256[0].z), _1268, mad((WorkingColorSpace_256[0].y), _1267, ((WorkingColorSpace_256[0].x) * _1266)));
        float _1274 = mad((WorkingColorSpace_256[1].z), _1268, mad((WorkingColorSpace_256[1].y), _1267, ((WorkingColorSpace_256[1].x) * _1266)));
        float _1277 = mad((WorkingColorSpace_256[2].z), _1268, mad((WorkingColorSpace_256[2].y), _1267, ((WorkingColorSpace_256[2].x) * _1266)));
        float _1280 = mad(-0.21492856740951538f, _1277, mad(-0.2365107536315918f, _1274, (_1271 * 1.4514392614364624f)));
        float _1283 = mad(-0.09967592358589172f, _1277, mad(1.17622971534729f, _1274, (_1271 * -0.07655377686023712f)));
        float _1286 = mad(0.9977163076400757f, _1277, mad(-0.006032449658960104f, _1274, (_1271 * 0.008316148072481155f)));
        float _1288 = max(_1280, max(_1283, _1286));
        do {
          if (!(_1288 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1271 < 0.0f) || (bool)(_1274 < 0.0f))) || (bool)(_1277 < 0.0f))) {
              float _1298 = abs(_1288);
              float _1299 = (_1288 - _1280) / _1298;
              float _1301 = (_1288 - _1283) / _1298;
              float _1303 = (_1288 - _1286) / _1298;
              do {
                if (!(_1299 < 0.8149999976158142f)) {
                  float _1306 = _1299 + -0.8149999976158142f;
                  _1318 = ((_1306 / exp2(log2(exp2(log2(_1306 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1318 = _1299;
                }
                do {
                  if (!(_1301 < 0.8029999732971191f)) {
                    float _1321 = _1301 + -0.8029999732971191f;
                    _1333 = ((_1321 / exp2(log2(exp2(log2(_1321 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1333 = _1301;
                  }
                  do {
                    if (!(_1303 < 0.8799999952316284f)) {
                      float _1336 = _1303 + -0.8799999952316284f;
                      _1348 = ((_1336 / exp2(log2(exp2(log2(_1336 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1348 = _1303;
                    }
                    _1356 = (_1288 - (_1298 * _1318));
                    _1357 = (_1288 - (_1298 * _1333));
                    _1358 = (_1288 - (_1298 * _1348));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1356 = _1280;
              _1357 = _1283;
              _1358 = _1286;
            }
          } else {
            _1356 = _1280;
            _1357 = _1283;
            _1358 = _1286;
          }
          float _1374 = ((mad(0.16386906802654266f, _1358, mad(0.14067870378494263f, _1357, (_1356 * 0.6954522132873535f))) - _1271) * cb0_012w) + _1271;
          float _1375 = ((mad(0.0955343171954155f, _1358, mad(0.8596711158752441f, _1357, (_1356 * 0.044794563204050064f))) - _1274) * cb0_012w) + _1274;
          float _1376 = ((mad(1.0015007257461548f, _1358, mad(0.004025210160762072f, _1357, (_1356 * -0.005525882821530104f))) - _1277) * cb0_012w) + _1277;
          float _1380 = max(max(_1374, _1375), _1376);
          float _1385 = (max(_1380, 1.000000013351432e-10f) - max(min(min(_1374, _1375), _1376), 1.000000013351432e-10f)) / max(_1380, 0.009999999776482582f);
          float _1398 = ((_1375 + _1374) + _1376) + (sqrt((((_1376 - _1375) * _1376) + ((_1375 - _1374) * _1375)) + ((_1374 - _1376) * _1374)) * 1.75f);
          float _1399 = _1398 * 0.3333333432674408f;
          float _1400 = _1385 + -0.4000000059604645f;
          float _1401 = _1400 * 5.0f;
          float _1405 = max((1.0f - abs(_1400 * 2.5f)), 0.0f);
          float _1416 = ((float((int)(((int)(uint)((bool)(_1401 > 0.0f))) - ((int)(uint)((bool)(_1401 < 0.0f))))) * (1.0f - (_1405 * _1405))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1399 <= 0.0533333346247673f)) {
              if (!(_1399 >= 0.1599999964237213f)) {
                _1425 = (((0.23999999463558197f / _1398) + -0.5f) * _1416);
              } else {
                _1425 = 0.0f;
              }
            } else {
              _1425 = _1416;
            }
            float _1426 = _1425 + 1.0f;
            float _1427 = _1426 * _1374;
            float _1428 = _1426 * _1375;
            float _1429 = _1426 * _1376;
            do {
              if (!((bool)(_1427 == _1428) && (bool)(_1428 == _1429))) {
                float _1436 = ((_1427 * 2.0f) - _1428) - _1429;
                float _1439 = ((_1375 - _1376) * 1.7320507764816284f) * _1426;
                float _1441 = atan(_1439 / _1436);
                bool _1444 = (_1436 < 0.0f);
                bool _1445 = (_1436 == 0.0f);
                bool _1446 = (_1439 >= 0.0f);
                bool _1447 = (_1439 < 0.0f);
                _1458 = select((_1446 && _1445), 90.0f, select((_1447 && _1445), -90.0f, (select((_1447 && _1444), (_1441 + -3.1415927410125732f), select((_1446 && _1444), (_1441 + 3.1415927410125732f), _1441)) * 57.2957763671875f)));
              } else {
                _1458 = 0.0f;
              }
              float _1463 = min(max(select((_1458 < 0.0f), (_1458 + 360.0f), _1458), 0.0f), 360.0f);
              do {
                if (_1463 < -180.0f) {
                  _1472 = (_1463 + 360.0f);
                } else {
                  if (_1463 > 180.0f) {
                    _1472 = (_1463 + -360.0f);
                  } else {
                    _1472 = _1463;
                  }
                }
                do {
                  if ((bool)(_1472 > -67.5f) && (bool)(_1472 < 67.5f)) {
                    float _1478 = (_1472 + 67.5f) * 0.029629629105329514f;
                    int _1479 = int(_1478);
                    float _1481 = _1478 - float((int)(_1479));
                    float _1482 = _1481 * _1481;
                    float _1483 = _1482 * _1481;
                    if (_1479 == 3) {
                      _1511 = (((0.1666666716337204f - (_1481 * 0.5f)) + (_1482 * 0.5f)) - (_1483 * 0.1666666716337204f));
                    } else {
                      if (_1479 == 2) {
                        _1511 = ((0.6666666865348816f - _1482) + (_1483 * 0.5f));
                      } else {
                        if (_1479 == 1) {
                          _1511 = (((_1483 * -0.5f) + 0.1666666716337204f) + ((_1482 + _1481) * 0.5f));
                        } else {
                          _1511 = select((_1479 == 0), (_1483 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1511 = 0.0f;
                  }
                  float _1520 = min(max(((((_1385 * 0.27000001072883606f) * (0.029999999329447746f - _1427)) * _1511) + _1427), 0.0f), 65535.0f);
                  float _1521 = min(max(_1428, 0.0f), 65535.0f);
                  float _1522 = min(max(_1429, 0.0f), 65535.0f);
                  float _1535 = min(max(mad(-0.21492856740951538f, _1522, mad(-0.2365107536315918f, _1521, (_1520 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1536 = min(max(mad(-0.09967592358589172f, _1522, mad(1.17622971534729f, _1521, (_1520 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1537 = min(max(mad(0.9977163076400757f, _1522, mad(-0.006032449658960104f, _1521, (_1520 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1538 = dot(float3(_1535, _1536, _1537), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1561 = log2(max((lerp(_1538, _1535, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1562 = _1561 * 0.3010300099849701f;
                  float _1563 = log2(cb0_008x);
                  float _1564 = _1563 * 0.3010300099849701f;
                  do {
                    if (!(!(_1562 <= _1564))) {
                      _1633 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1571 = log2(cb0_009x);
                      float _1572 = _1571 * 0.3010300099849701f;
                      if ((bool)(_1562 > _1564) && (bool)(_1562 < _1572)) {
                        float _1580 = ((_1561 - _1563) * 0.9030900001525879f) / ((_1571 - _1563) * 0.3010300099849701f);
                        int _1581 = int(_1580);
                        float _1583 = _1580 - float((int)(_1581));
                        float _1585 = _16[_1581];
                        float _1588 = _16[(_1581 + 1)];
                        float _1593 = _1585 * 0.5f;
                        _1633 = dot(float3((_1583 * _1583), _1583, 1.0f), float3(mad((_16[(_1581 + 2)]), 0.5f, mad(_1588, -1.0f, _1593)), (_1588 - _1585), mad(_1588, 0.5f, _1593)));
                      } else {
                        do {
                          if (!(!(_1562 >= _1572))) {
                            float _1602 = log2(cb0_008z);
                            if (_1562 < (_1602 * 0.3010300099849701f)) {
                              float _1610 = ((_1561 - _1571) * 0.9030900001525879f) / ((_1602 - _1571) * 0.3010300099849701f);
                              int _1611 = int(_1610);
                              float _1613 = _1610 - float((int)(_1611));
                              float _1615 = _17[_1611];
                              float _1618 = _17[(_1611 + 1)];
                              float _1623 = _1615 * 0.5f;
                              _1633 = dot(float3((_1613 * _1613), _1613, 1.0f), float3(mad((_17[(_1611 + 2)]), 0.5f, mad(_1618, -1.0f, _1623)), (_1618 - _1615), mad(_1618, 0.5f, _1623)));
                              break;
                            }
                          }
                          _1633 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _18[0] = cb0_011x;
                    _18[1] = cb0_011y;
                    _18[2] = cb0_011z;
                    _18[3] = cb0_011w;
                    _18[4] = cb0_012y;
                    _18[5] = cb0_012y;
                    float _1643 = log2(max((lerp(_1538, _1536, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1644 = _1643 * 0.3010300099849701f;
                    do {
                      if (!(!(_1644 <= _1564))) {
                        _1713 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1651 = log2(cb0_009x);
                        float _1652 = _1651 * 0.3010300099849701f;
                        if ((bool)(_1644 > _1564) && (bool)(_1644 < _1652)) {
                          float _1660 = ((_1643 - _1563) * 0.9030900001525879f) / ((_1651 - _1563) * 0.3010300099849701f);
                          int _1661 = int(_1660);
                          float _1663 = _1660 - float((int)(_1661));
                          float _1665 = _8[_1661];
                          float _1668 = _8[(_1661 + 1)];
                          float _1673 = _1665 * 0.5f;
                          _1713 = dot(float3((_1663 * _1663), _1663, 1.0f), float3(mad((_8[(_1661 + 2)]), 0.5f, mad(_1668, -1.0f, _1673)), (_1668 - _1665), mad(_1668, 0.5f, _1673)));
                        } else {
                          do {
                            if (!(!(_1644 >= _1652))) {
                              float _1682 = log2(cb0_008z);
                              if (_1644 < (_1682 * 0.3010300099849701f)) {
                                float _1690 = ((_1643 - _1651) * 0.9030900001525879f) / ((_1682 - _1651) * 0.3010300099849701f);
                                int _1691 = int(_1690);
                                float _1693 = _1690 - float((int)(_1691));
                                float _1695 = _18[_1691];
                                float _1698 = _18[(_1691 + 1)];
                                float _1703 = _1695 * 0.5f;
                                _1713 = dot(float3((_1693 * _1693), _1693, 1.0f), float3(mad((_18[(_1691 + 2)]), 0.5f, mad(_1698, -1.0f, _1703)), (_1698 - _1695), mad(_1698, 0.5f, _1703)));
                                break;
                              }
                            }
                            _1713 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1717 = log2(max((lerp(_1538, _1537, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1718 = _1717 * 0.3010300099849701f;
                      do {
                        if (!(!(_1718 <= _1564))) {
                          _1787 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1725 = log2(cb0_009x);
                          float _1726 = _1725 * 0.3010300099849701f;
                          if ((bool)(_1718 > _1564) && (bool)(_1718 < _1726)) {
                            float _1734 = ((_1717 - _1563) * 0.9030900001525879f) / ((_1725 - _1563) * 0.3010300099849701f);
                            int _1735 = int(_1734);
                            float _1737 = _1734 - float((int)(_1735));
                            float _1739 = _8[_1735];
                            float _1742 = _8[(_1735 + 1)];
                            float _1747 = _1739 * 0.5f;
                            _1787 = dot(float3((_1737 * _1737), _1737, 1.0f), float3(mad((_8[(_1735 + 2)]), 0.5f, mad(_1742, -1.0f, _1747)), (_1742 - _1739), mad(_1742, 0.5f, _1747)));
                          } else {
                            do {
                              if (!(!(_1718 >= _1726))) {
                                float _1756 = log2(cb0_008z);
                                if (_1718 < (_1756 * 0.3010300099849701f)) {
                                  float _1764 = ((_1717 - _1725) * 0.9030900001525879f) / ((_1756 - _1725) * 0.3010300099849701f);
                                  int _1765 = int(_1764);
                                  float _1767 = _1764 - float((int)(_1765));
                                  float _1769 = _9[_1765];
                                  float _1772 = _9[(_1765 + 1)];
                                  float _1777 = _1769 * 0.5f;
                                  _1787 = dot(float3((_1767 * _1767), _1767, 1.0f), float3(mad((_9[(_1765 + 2)]), 0.5f, mad(_1772, -1.0f, _1777)), (_1772 - _1769), mad(_1772, 0.5f, _1777)));
                                  break;
                                }
                              }
                              _1787 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1791 = cb0_008w - cb0_008y;
                        float _1792 = (exp2(_1633 * 3.321928024291992f) - cb0_008y) / _1791;
                        float _1794 = (exp2(_1713 * 3.321928024291992f) - cb0_008y) / _1791;
                        float _1796 = (exp2(_1787 * 3.321928024291992f) - cb0_008y) / _1791;
                        float _1799 = mad(0.15618768334388733f, _1796, mad(0.13400420546531677f, _1794, (_1792 * 0.6624541878700256f)));
                        float _1802 = mad(0.053689517080783844f, _1796, mad(0.6740817427635193f, _1794, (_1792 * 0.2722287178039551f)));
                        float _1805 = mad(1.0103391408920288f, _1796, mad(0.00406073359772563f, _1794, (_1792 * -0.005574649665504694f)));
                        float _1818 = min(max(mad(-0.23642469942569733f, _1805, mad(-0.32480329275131226f, _1802, (_1799 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1819 = min(max(mad(0.016756348311901093f, _1805, mad(1.6153316497802734f, _1802, (_1799 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1820 = min(max(mad(0.9883948564529419f, _1805, mad(-0.008284442126750946f, _1802, (_1799 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1823 = mad(0.15618768334388733f, _1820, mad(0.13400420546531677f, _1819, (_1818 * 0.6624541878700256f)));
                        float _1826 = mad(0.053689517080783844f, _1820, mad(0.6740817427635193f, _1819, (_1818 * 0.2722287178039551f)));
                        float _1829 = mad(1.0103391408920288f, _1820, mad(0.00406073359772563f, _1819, (_1818 * -0.005574649665504694f)));
                        float _1851 = min(max((min(max(mad(-0.23642469942569733f, _1829, mad(-0.32480329275131226f, _1826, (_1823 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1852 = min(max((min(max(mad(0.016756348311901093f, _1829, mad(1.6153316497802734f, _1826, (_1823 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1853 = min(max((min(max(mad(0.9883948564529419f, _1829, mad(-0.008284442126750946f, _1826, (_1823 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1872 = exp2(log2(mad(_52, _1853, mad(_51, _1852, (_1851 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1873 = exp2(log2(mad(_55, _1853, mad(_54, _1852, (_1851 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1874 = exp2(log2(mad(_58, _1853, mad(_57, _1852, (_1851 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2678 = exp2(log2((1.0f / ((_1872 * 18.6875f) + 1.0f)) * ((_1872 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2679 = exp2(log2((1.0f / ((_1873 * 18.6875f) + 1.0f)) * ((_1873 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2680 = exp2(log2((1.0f / ((_1874 * 18.6875f) + 1.0f)) * ((_1874 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((uint)((uint)((int)(cb0_044w) + -5u)) < (uint)2) {
          float _1940 = cb0_012z * _1085;
          float _1941 = cb0_012z * _1086;
          float _1942 = cb0_012z * _1087;
          float _1945 = mad((WorkingColorSpace_256[0].z), _1942, mad((WorkingColorSpace_256[0].y), _1941, ((WorkingColorSpace_256[0].x) * _1940)));
          float _1948 = mad((WorkingColorSpace_256[1].z), _1942, mad((WorkingColorSpace_256[1].y), _1941, ((WorkingColorSpace_256[1].x) * _1940)));
          float _1951 = mad((WorkingColorSpace_256[2].z), _1942, mad((WorkingColorSpace_256[2].y), _1941, ((WorkingColorSpace_256[2].x) * _1940)));
          float _1954 = mad(-0.21492856740951538f, _1951, mad(-0.2365107536315918f, _1948, (_1945 * 1.4514392614364624f)));
          float _1957 = mad(-0.09967592358589172f, _1951, mad(1.17622971534729f, _1948, (_1945 * -0.07655377686023712f)));
          float _1960 = mad(0.9977163076400757f, _1951, mad(-0.006032449658960104f, _1948, (_1945 * 0.008316148072481155f)));
          float _1962 = max(_1954, max(_1957, _1960));
          do {
            if (!(_1962 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1945 < 0.0f) || (bool)(_1948 < 0.0f))) || (bool)(_1951 < 0.0f))) {
                float _1972 = abs(_1962);
                float _1973 = (_1962 - _1954) / _1972;
                float _1975 = (_1962 - _1957) / _1972;
                float _1977 = (_1962 - _1960) / _1972;
                do {
                  if (!(_1973 < 0.8149999976158142f)) {
                    float _1980 = _1973 + -0.8149999976158142f;
                    _1992 = ((_1980 / exp2(log2(exp2(log2(_1980 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _1992 = _1973;
                  }
                  do {
                    if (!(_1975 < 0.8029999732971191f)) {
                      float _1995 = _1975 + -0.8029999732971191f;
                      _2007 = ((_1995 / exp2(log2(exp2(log2(_1995 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2007 = _1975;
                    }
                    do {
                      if (!(_1977 < 0.8799999952316284f)) {
                        float _2010 = _1977 + -0.8799999952316284f;
                        _2022 = ((_2010 / exp2(log2(exp2(log2(_2010 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2022 = _1977;
                      }
                      _2030 = (_1962 - (_1972 * _1992));
                      _2031 = (_1962 - (_1972 * _2007));
                      _2032 = (_1962 - (_1972 * _2022));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2030 = _1954;
                _2031 = _1957;
                _2032 = _1960;
              }
            } else {
              _2030 = _1954;
              _2031 = _1957;
              _2032 = _1960;
            }
            float _2048 = ((mad(0.16386906802654266f, _2032, mad(0.14067870378494263f, _2031, (_2030 * 0.6954522132873535f))) - _1945) * cb0_012w) + _1945;
            float _2049 = ((mad(0.0955343171954155f, _2032, mad(0.8596711158752441f, _2031, (_2030 * 0.044794563204050064f))) - _1948) * cb0_012w) + _1948;
            float _2050 = ((mad(1.0015007257461548f, _2032, mad(0.004025210160762072f, _2031, (_2030 * -0.005525882821530104f))) - _1951) * cb0_012w) + _1951;
            float _2054 = max(max(_2048, _2049), _2050);
            float _2059 = (max(_2054, 1.000000013351432e-10f) - max(min(min(_2048, _2049), _2050), 1.000000013351432e-10f)) / max(_2054, 0.009999999776482582f);
            float _2072 = ((_2049 + _2048) + _2050) + (sqrt((((_2050 - _2049) * _2050) + ((_2049 - _2048) * _2049)) + ((_2048 - _2050) * _2048)) * 1.75f);
            float _2073 = _2072 * 0.3333333432674408f;
            float _2074 = _2059 + -0.4000000059604645f;
            float _2075 = _2074 * 5.0f;
            float _2079 = max((1.0f - abs(_2074 * 2.5f)), 0.0f);
            float _2090 = ((float((int)(((int)(uint)((bool)(_2075 > 0.0f))) - ((int)(uint)((bool)(_2075 < 0.0f))))) * (1.0f - (_2079 * _2079))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2073 <= 0.0533333346247673f)) {
                if (!(_2073 >= 0.1599999964237213f)) {
                  _2099 = (((0.23999999463558197f / _2072) + -0.5f) * _2090);
                } else {
                  _2099 = 0.0f;
                }
              } else {
                _2099 = _2090;
              }
              float _2100 = _2099 + 1.0f;
              float _2101 = _2100 * _2048;
              float _2102 = _2100 * _2049;
              float _2103 = _2100 * _2050;
              do {
                if (!((bool)(_2101 == _2102) && (bool)(_2102 == _2103))) {
                  float _2110 = ((_2101 * 2.0f) - _2102) - _2103;
                  float _2113 = ((_2049 - _2050) * 1.7320507764816284f) * _2100;
                  float _2115 = atan(_2113 / _2110);
                  bool _2118 = (_2110 < 0.0f);
                  bool _2119 = (_2110 == 0.0f);
                  bool _2120 = (_2113 >= 0.0f);
                  bool _2121 = (_2113 < 0.0f);
                  _2132 = select((_2120 && _2119), 90.0f, select((_2121 && _2119), -90.0f, (select((_2121 && _2118), (_2115 + -3.1415927410125732f), select((_2120 && _2118), (_2115 + 3.1415927410125732f), _2115)) * 57.2957763671875f)));
                } else {
                  _2132 = 0.0f;
                }
                float _2137 = min(max(select((_2132 < 0.0f), (_2132 + 360.0f), _2132), 0.0f), 360.0f);
                do {
                  if (_2137 < -180.0f) {
                    _2146 = (_2137 + 360.0f);
                  } else {
                    if (_2137 > 180.0f) {
                      _2146 = (_2137 + -360.0f);
                    } else {
                      _2146 = _2137;
                    }
                  }
                  do {
                    if ((bool)(_2146 > -67.5f) && (bool)(_2146 < 67.5f)) {
                      float _2152 = (_2146 + 67.5f) * 0.029629629105329514f;
                      int _2153 = int(_2152);
                      float _2155 = _2152 - float((int)(_2153));
                      float _2156 = _2155 * _2155;
                      float _2157 = _2156 * _2155;
                      if (_2153 == 3) {
                        _2185 = (((0.1666666716337204f - (_2155 * 0.5f)) + (_2156 * 0.5f)) - (_2157 * 0.1666666716337204f));
                      } else {
                        if (_2153 == 2) {
                          _2185 = ((0.6666666865348816f - _2156) + (_2157 * 0.5f));
                        } else {
                          if (_2153 == 1) {
                            _2185 = (((_2157 * -0.5f) + 0.1666666716337204f) + ((_2156 + _2155) * 0.5f));
                          } else {
                            _2185 = select((_2153 == 0), (_2157 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2185 = 0.0f;
                    }
                    float _2194 = min(max(((((_2059 * 0.27000001072883606f) * (0.029999999329447746f - _2101)) * _2185) + _2101), 0.0f), 65535.0f);
                    float _2195 = min(max(_2102, 0.0f), 65535.0f);
                    float _2196 = min(max(_2103, 0.0f), 65535.0f);
                    float _2209 = min(max(mad(-0.21492856740951538f, _2196, mad(-0.2365107536315918f, _2195, (_2194 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2210 = min(max(mad(-0.09967592358589172f, _2196, mad(1.17622971534729f, _2195, (_2194 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2211 = min(max(mad(0.9977163076400757f, _2196, mad(-0.006032449658960104f, _2195, (_2194 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2212 = dot(float3(_2209, _2210, _2211), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2235 = log2(max((lerp(_2212, _2209, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2236 = _2235 * 0.3010300099849701f;
                    float _2237 = log2(cb0_008x);
                    float _2238 = _2237 * 0.3010300099849701f;
                    do {
                      if (!(!(_2236 <= _2238))) {
                        _2307 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2245 = log2(cb0_009x);
                        float _2246 = _2245 * 0.3010300099849701f;
                        if ((bool)(_2236 > _2238) && (bool)(_2236 < _2246)) {
                          float _2254 = ((_2235 - _2237) * 0.9030900001525879f) / ((_2245 - _2237) * 0.3010300099849701f);
                          int _2255 = int(_2254);
                          float _2257 = _2254 - float((int)(_2255));
                          float _2259 = _14[_2255];
                          float _2262 = _14[(_2255 + 1)];
                          float _2267 = _2259 * 0.5f;
                          _2307 = dot(float3((_2257 * _2257), _2257, 1.0f), float3(mad((_14[(_2255 + 2)]), 0.5f, mad(_2262, -1.0f, _2267)), (_2262 - _2259), mad(_2262, 0.5f, _2267)));
                        } else {
                          do {
                            if (!(!(_2236 >= _2246))) {
                              float _2276 = log2(cb0_008z);
                              if (_2236 < (_2276 * 0.3010300099849701f)) {
                                float _2284 = ((_2235 - _2245) * 0.9030900001525879f) / ((_2276 - _2245) * 0.3010300099849701f);
                                int _2285 = int(_2284);
                                float _2287 = _2284 - float((int)(_2285));
                                float _2289 = _15[_2285];
                                float _2292 = _15[(_2285 + 1)];
                                float _2297 = _2289 * 0.5f;
                                _2307 = dot(float3((_2287 * _2287), _2287, 1.0f), float3(mad((_15[(_2285 + 2)]), 0.5f, mad(_2292, -1.0f, _2297)), (_2292 - _2289), mad(_2292, 0.5f, _2297)));
                                break;
                              }
                            }
                            _2307 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _2323 = log2(max((lerp(_2212, _2210, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2324 = _2323 * 0.3010300099849701f;
                      do {
                        if (!(!(_2324 <= _2238))) {
                          _2393 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2331 = log2(cb0_009x);
                          float _2332 = _2331 * 0.3010300099849701f;
                          if ((bool)(_2324 > _2238) && (bool)(_2324 < _2332)) {
                            float _2340 = ((_2323 - _2237) * 0.9030900001525879f) / ((_2331 - _2237) * 0.3010300099849701f);
                            int _2341 = int(_2340);
                            float _2343 = _2340 - float((int)(_2341));
                            float _2345 = _10[_2341];
                            float _2348 = _10[(_2341 + 1)];
                            float _2353 = _2345 * 0.5f;
                            _2393 = dot(float3((_2343 * _2343), _2343, 1.0f), float3(mad((_10[(_2341 + 2)]), 0.5f, mad(_2348, -1.0f, _2353)), (_2348 - _2345), mad(_2348, 0.5f, _2353)));
                          } else {
                            do {
                              if (!(!(_2324 >= _2332))) {
                                float _2362 = log2(cb0_008z);
                                if (_2324 < (_2362 * 0.3010300099849701f)) {
                                  float _2370 = ((_2323 - _2331) * 0.9030900001525879f) / ((_2362 - _2331) * 0.3010300099849701f);
                                  int _2371 = int(_2370);
                                  float _2373 = _2370 - float((int)(_2371));
                                  float _2375 = _11[_2371];
                                  float _2378 = _11[(_2371 + 1)];
                                  float _2383 = _2375 * 0.5f;
                                  _2393 = dot(float3((_2373 * _2373), _2373, 1.0f), float3(mad((_11[(_2371 + 2)]), 0.5f, mad(_2378, -1.0f, _2383)), (_2378 - _2375), mad(_2378, 0.5f, _2383)));
                                  break;
                                }
                              }
                              _2393 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2409 = log2(max((lerp(_2212, _2211, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2410 = _2409 * 0.3010300099849701f;
                        do {
                          if (!(!(_2410 <= _2238))) {
                            _2479 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2417 = log2(cb0_009x);
                            float _2418 = _2417 * 0.3010300099849701f;
                            if ((bool)(_2410 > _2238) && (bool)(_2410 < _2418)) {
                              float _2426 = ((_2409 - _2237) * 0.9030900001525879f) / ((_2417 - _2237) * 0.3010300099849701f);
                              int _2427 = int(_2426);
                              float _2429 = _2426 - float((int)(_2427));
                              float _2431 = _12[_2427];
                              float _2434 = _12[(_2427 + 1)];
                              float _2439 = _2431 * 0.5f;
                              _2479 = dot(float3((_2429 * _2429), _2429, 1.0f), float3(mad((_12[(_2427 + 2)]), 0.5f, mad(_2434, -1.0f, _2439)), (_2434 - _2431), mad(_2434, 0.5f, _2439)));
                            } else {
                              do {
                                if (!(!(_2410 >= _2418))) {
                                  float _2448 = log2(cb0_008z);
                                  if (_2410 < (_2448 * 0.3010300099849701f)) {
                                    float _2456 = ((_2409 - _2417) * 0.9030900001525879f) / ((_2448 - _2417) * 0.3010300099849701f);
                                    int _2457 = int(_2456);
                                    float _2459 = _2456 - float((int)(_2457));
                                    float _2461 = _13[_2457];
                                    float _2464 = _13[(_2457 + 1)];
                                    float _2469 = _2461 * 0.5f;
                                    _2479 = dot(float3((_2459 * _2459), _2459, 1.0f), float3(mad((_13[(_2457 + 2)]), 0.5f, mad(_2464, -1.0f, _2469)), (_2464 - _2461), mad(_2464, 0.5f, _2469)));
                                    break;
                                  }
                                }
                                _2479 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2483 = cb0_008w - cb0_008y;
                          float _2484 = (exp2(_2307 * 3.321928024291992f) - cb0_008y) / _2483;
                          float _2486 = (exp2(_2393 * 3.321928024291992f) - cb0_008y) / _2483;
                          float _2488 = (exp2(_2479 * 3.321928024291992f) - cb0_008y) / _2483;
                          float _2491 = mad(0.15618768334388733f, _2488, mad(0.13400420546531677f, _2486, (_2484 * 0.6624541878700256f)));
                          float _2494 = mad(0.053689517080783844f, _2488, mad(0.6740817427635193f, _2486, (_2484 * 0.2722287178039551f)));
                          float _2497 = mad(1.0103391408920288f, _2488, mad(0.00406073359772563f, _2486, (_2484 * -0.005574649665504694f)));
                          float _2510 = min(max(mad(-0.23642469942569733f, _2497, mad(-0.32480329275131226f, _2494, (_2491 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2511 = min(max(mad(0.016756348311901093f, _2497, mad(1.6153316497802734f, _2494, (_2491 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2512 = min(max(mad(0.9883948564529419f, _2497, mad(-0.008284442126750946f, _2494, (_2491 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2515 = mad(0.15618768334388733f, _2512, mad(0.13400420546531677f, _2511, (_2510 * 0.6624541878700256f)));
                          float _2518 = mad(0.053689517080783844f, _2512, mad(0.6740817427635193f, _2511, (_2510 * 0.2722287178039551f)));
                          float _2521 = mad(1.0103391408920288f, _2512, mad(0.00406073359772563f, _2511, (_2510 * -0.005574649665504694f)));
                          float _2543 = min(max((min(max(mad(-0.23642469942569733f, _2521, mad(-0.32480329275131226f, _2518, (_2515 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2546 = min(max((min(max(mad(0.016756348311901093f, _2521, mad(1.6153316497802734f, _2518, (_2515 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          float _2547 = min(max((min(max(mad(0.9883948564529419f, _2521, mad(-0.008284442126750946f, _2518, (_2515 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          _2678 = mad(-0.0832589864730835f, _2547, mad(-0.6217921376228333f, _2546, (_2543 * 0.0213131383061409f)));
                          _2679 = mad(-0.010548308491706848f, _2547, mad(1.140804648399353f, _2546, (_2543 * -0.0016282059950754046f)));
                          _2680 = mad(1.1529725790023804f, _2547, mad(-0.1289689838886261f, _2546, (_2543 * -0.00030004189466126263f)));
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (cb0_044w == 7) {
            float _2566 = mad((WorkingColorSpace_128[0].z), _1087, mad((WorkingColorSpace_128[0].y), _1086, ((WorkingColorSpace_128[0].x) * _1085)));
            float _2569 = mad((WorkingColorSpace_128[1].z), _1087, mad((WorkingColorSpace_128[1].y), _1086, ((WorkingColorSpace_128[1].x) * _1085)));
            float _2572 = mad((WorkingColorSpace_128[2].z), _1087, mad((WorkingColorSpace_128[2].y), _1086, ((WorkingColorSpace_128[2].x) * _1085)));
            float _2591 = exp2(log2(mad(_52, _2572, mad(_51, _2569, (_2566 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2592 = exp2(log2(mad(_55, _2572, mad(_54, _2569, (_2566 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2593 = exp2(log2(mad(_58, _2572, mad(_57, _2569, (_2566 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2678 = exp2(log2((1.0f / ((_2591 * 18.6875f) + 1.0f)) * ((_2591 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2679 = exp2(log2((1.0f / ((_2592 * 18.6875f) + 1.0f)) * ((_2592 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2680 = exp2(log2((1.0f / ((_2593 * 18.6875f) + 1.0f)) * ((_2593 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_044w == 8)) {
              if (cb0_044w == 9) {
                float _2632 = mad((WorkingColorSpace_128[0].z), _1075, mad((WorkingColorSpace_128[0].y), _1074, ((WorkingColorSpace_128[0].x) * _1073)));
                float _2635 = mad((WorkingColorSpace_128[1].z), _1075, mad((WorkingColorSpace_128[1].y), _1074, ((WorkingColorSpace_128[1].x) * _1073)));
                float _2638 = mad((WorkingColorSpace_128[2].z), _1075, mad((WorkingColorSpace_128[2].y), _1074, ((WorkingColorSpace_128[2].x) * _1073)));
                _2678 = mad(_52, _2638, mad(_51, _2635, (_2632 * _50)));
                _2679 = mad(_55, _2638, mad(_54, _2635, (_2632 * _53)));
                _2680 = mad(_58, _2638, mad(_57, _2635, (_2632 * _56)));
              } else {
                float _2651 = mad((WorkingColorSpace_128[0].z), _1101, mad((WorkingColorSpace_128[0].y), _1100, ((WorkingColorSpace_128[0].x) * _1099)));
                float _2654 = mad((WorkingColorSpace_128[1].z), _1101, mad((WorkingColorSpace_128[1].y), _1100, ((WorkingColorSpace_128[1].x) * _1099)));
                float _2657 = mad((WorkingColorSpace_128[2].z), _1101, mad((WorkingColorSpace_128[2].y), _1100, ((WorkingColorSpace_128[2].x) * _1099)));
                _2678 = exp2(log2(mad(_52, _2657, mad(_51, _2654, (_2651 * _50)))) * cb0_044z);
                _2679 = exp2(log2(mad(_55, _2657, mad(_54, _2654, (_2651 * _53)))) * cb0_044z);
                _2680 = exp2(log2(mad(_58, _2657, mad(_57, _2654, (_2651 * _56)))) * cb0_044z);
              }
            } else {
              _2678 = _1085;
              _2679 = _1086;
              _2680 = _1087;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2678 * 0.9523810148239136f);
  SV_Target.y = (_2679 * 0.9523810148239136f);
  SV_Target.z = (_2680 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  SV_Target = saturate(SV_Target);
  return SV_Target;
}
