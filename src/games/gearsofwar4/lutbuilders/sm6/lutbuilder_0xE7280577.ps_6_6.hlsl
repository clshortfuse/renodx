#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
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
  float _12 = 0.5f / cb0_037x;
  float _17 = cb0_037x + -1.0f;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _119;
  float _326;
  float _327;
  float _328;
  float _830;
  float _863;
  float _877;
  float _941;
  float _1132;
  float _1143;
  float _1154;
  float _1311;
  float _1312;
  float _1313;
  float _1324;
  float _1335;
  float _1346;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        bool _30 = (cb0_043x == 4);
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
  float _62 = (exp2((((cb0_037x * (TEXCOORD.x - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _63 = (exp2((((cb0_037x * (TEXCOORD.y - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _64 = (exp2(((float((uint)(int)(SV_RenderTargetArrayIndex)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _326 = _62;
      _327 = _63;
      _328 = _64;
      float _343 = mad((WorkingColorSpace_128[0].z), _328, mad((WorkingColorSpace_128[0].y), _327, ((WorkingColorSpace_128[0].x) * _326)));
      float _346 = mad((WorkingColorSpace_128[1].z), _328, mad((WorkingColorSpace_128[1].y), _327, ((WorkingColorSpace_128[1].x) * _326)));
      float _349 = mad((WorkingColorSpace_128[2].z), _328, mad((WorkingColorSpace_128[2].y), _327, ((WorkingColorSpace_128[2].x) * _326)));
      SetUngradedAP1(float3(_343, _346, _349));

      float _350 = dot(float3(_343, _346, _349), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _354 = (_343 / _350) + -1.0f;
      float _355 = (_346 / _350) + -1.0f;
      float _356 = (_349 / _350) + -1.0f;
      float _368 = (1.0f - exp2(((_350 * _350) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_354, _355, _356), float3(_354, _355, _356)) * -4.0f));
      float _384 = ((mad(-0.06368321925401688f, _349, mad(-0.3292922377586365f, _346, (_343 * 1.3704125881195068f))) - _343) * _368) + _343;
      float _385 = ((mad(-0.010861365124583244f, _349, mad(1.0970927476882935f, _346, (_343 * -0.08343357592821121f))) - _346) * _368) + _346;
      float _386 = ((mad(1.2036951780319214f, _349, mad(-0.09862580895423889f, _346, (_343 * -0.02579331398010254f))) - _349) * _368) + _349;
      float _387 = dot(float3(_384, _385, _386), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _401 = cb0_021w + cb0_026w;
      float _415 = cb0_020w * cb0_025w;
      float _429 = cb0_019w * cb0_024w;
      float _443 = cb0_018w * cb0_023w;
      float _457 = cb0_017w * cb0_022w;
      float _461 = _384 - _387;
      float _462 = _385 - _387;
      float _463 = _386 - _387;
      float _520 = saturate(_387 / cb0_037w);
      float _524 = (_520 * _520) * (3.0f - (_520 * 2.0f));
      float _525 = 1.0f - _524;
      float _534 = cb0_021w + cb0_036w;
      float _543 = cb0_020w * cb0_035w;
      float _552 = cb0_019w * cb0_034w;
      float _561 = cb0_018w * cb0_033w;
      float _570 = cb0_017w * cb0_032w;
      float _633 = saturate((_387 - cb0_038x) / (cb0_038y - cb0_038x));
      float _637 = (_633 * _633) * (3.0f - (_633 * 2.0f));
      float _646 = cb0_021w + cb0_031w;
      float _655 = cb0_020w * cb0_030w;
      float _664 = cb0_019w * cb0_029w;
      float _673 = cb0_018w * cb0_028w;
      float _682 = cb0_017w * cb0_027w;
      float _740 = _524 - _637;
      float _751 = ((_637 * (((cb0_021x + cb0_036x) + _534) + (((cb0_020x * cb0_035x) * _543) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _561) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _570) * _461) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _552)))))) + (_525 * (((cb0_021x + cb0_026x) + _401) + (((cb0_020x * cb0_025x) * _415) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _443) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _457) * _461) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _429))))))) + ((((cb0_021x + cb0_031x) + _646) + (((cb0_020x * cb0_030x) * _655) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _673) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _682) * _461) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _664))))) * _740);
      float _753 = ((_637 * (((cb0_021y + cb0_036y) + _534) + (((cb0_020y * cb0_035y) * _543) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _561) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _570) * _462) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _552)))))) + (_525 * (((cb0_021y + cb0_026y) + _401) + (((cb0_020y * cb0_025y) * _415) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _443) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _457) * _462) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _429))))))) + ((((cb0_021y + cb0_031y) + _646) + (((cb0_020y * cb0_030y) * _655) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _673) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _682) * _462) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _664))))) * _740);
      float _755 = ((_637 * (((cb0_021z + cb0_036z) + _534) + (((cb0_020z * cb0_035z) * _543) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _561) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _570) * _463) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _552)))))) + (_525 * (((cb0_021z + cb0_026z) + _401) + (((cb0_020z * cb0_025z) * _415) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _443) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _457) * _463) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _429))))))) + ((((cb0_021z + cb0_031z) + _646) + (((cb0_020z * cb0_030z) * _655) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _673) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _682) * _463) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _664))))) * _740);
      SetUntonemappedAP1(float3(_751, _753, _755));

      float _770 = ((mad(0.061360642313957214f, _755, mad(-4.540197551250458e-09f, _753, (_751 * 0.9386394023895264f))) - _751) * cb0_038z) + _751;
      float _771 = ((mad(0.169205904006958f, _755, mad(0.8307942152023315f, _753, (_751 * 6.775371730327606e-08f))) - _753) * cb0_038z) + _753;
      float _772 = (mad(-2.3283064365386963e-10f, _753, (_751 * -9.313225746154785e-10f)) * cb0_038z) + _755;
      float _775 = mad(0.16386905312538147f, _772, mad(0.14067868888378143f, _771, (_770 * 0.6954522132873535f)));
      float _778 = mad(0.0955343246459961f, _772, mad(0.8596711158752441f, _771, (_770 * 0.044794581830501556f)));
      float _781 = mad(1.0015007257461548f, _772, mad(0.004025210160762072f, _771, (_770 * -0.005525882821530104f)));
      float _785 = max(max(_775, _778), _781);
      float _790 = (max(_785, 1.000000013351432e-10f) - max(min(min(_775, _778), _781), 1.000000013351432e-10f)) / max(_785, 0.009999999776482582f);
      float _803 = ((_778 + _775) + _781) + (sqrt((((_781 - _778) * _781) + ((_778 - _775) * _778)) + ((_775 - _781) * _775)) * 1.75f);
      float _804 = _803 * 0.3333333432674408f;
      float _805 = _790 + -0.4000000059604645f;
      float _806 = _805 * 5.0f;
      float _810 = max((1.0f - abs(_805 * 2.5f)), 0.0f);
      float _821 = ((float((int)(((int)(uint)((bool)(_806 > 0.0f))) - ((int)(uint)((bool)(_806 < 0.0f))))) * (1.0f - (_810 * _810))) + 1.0f) * 0.02500000037252903f;
      do {
        if (!(_804 <= 0.0533333346247673f)) {
          if (!(_804 >= 0.1599999964237213f)) {
            _830 = (((0.23999999463558197f / _803) + -0.5f) * _821);
          } else {
            _830 = 0.0f;
          }
        } else {
          _830 = _821;
        }
        float _831 = _830 + 1.0f;
        float _832 = _831 * _775;
        float _833 = _831 * _778;
        float _834 = _831 * _781;
        do {
          if (!((bool)(_832 == _833) && (bool)(_833 == _834))) {
            float _841 = ((_832 * 2.0f) - _833) - _834;
            float _844 = ((_778 - _781) * 1.7320507764816284f) * _831;
            float _846 = atan(_844 / _841);
            bool _849 = (_841 < 0.0f);
            bool _850 = (_841 == 0.0f);
            bool _851 = (_844 >= 0.0f);
            bool _852 = (_844 < 0.0f);
            _863 = select((_851 && _850), 90.0f, select((_852 && _850), -90.0f, (select((_852 && _849), (_846 + -3.1415927410125732f), select((_851 && _849), (_846 + 3.1415927410125732f), _846)) * 57.2957763671875f)));
          } else {
            _863 = 0.0f;
          }
          float _868 = min(max(select((_863 < 0.0f), (_863 + 360.0f), _863), 0.0f), 360.0f);
          do {
            if (_868 < -180.0f) {
              _877 = (_868 + 360.0f);
            } else {
              if (_868 > 180.0f) {
                _877 = (_868 + -360.0f);
              } else {
                _877 = _868;
              }
            }
            float _881 = saturate(1.0f - abs(_877 * 0.014814814552664757f));
            float _885 = (_881 * _881) * (3.0f - (_881 * 2.0f));
            float _891 = ((_885 * _885) * ((_790 * 0.18000000715255737f) * (0.029999999329447746f - _832))) + _832;
            float _901 = max(0.0f, mad(-0.21492856740951538f, _834, mad(-0.2365107536315918f, _833, (_891 * 1.4514392614364624f))));
            float _902 = max(0.0f, mad(-0.09967592358589172f, _834, mad(1.17622971534729f, _833, (_891 * -0.07655377686023712f))));
            float _903 = max(0.0f, mad(0.9977163076400757f, _834, mad(-0.006032449658960104f, _833, (_891 * 0.008316148072481155f))));
            float _904 = dot(float3(_901, _902, _903), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _919 = (cb0_040x + 1.0f) - cb0_039z;
            float _921 = cb0_040y + 1.0f;
            float _923 = _921 - cb0_039w;
            do {
              if (cb0_039z > 0.800000011920929f) {
                _941 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
              } else {
                float _932 = (cb0_040x + 0.18000000715255737f) / _919;
                _941 = (-0.7447274923324585f - ((log2(_932 / (2.0f - _932)) * 0.3465735912322998f) * (_919 / cb0_039y)));
              }
              float _944 = ((1.0f - cb0_039z) / cb0_039y) - _941;
              float _946 = (cb0_039w / cb0_039y) - _944;
              float _950 = log2(lerp(_904, _901, 0.9599999785423279f)) * 0.3010300099849701f;
              float _951 = log2(lerp(_904, _902, 0.9599999785423279f)) * 0.3010300099849701f;
              float _952 = log2(lerp(_904, _903, 0.9599999785423279f)) * 0.3010300099849701f;
              float _956 = cb0_039y * (_950 + _944);
              float _957 = cb0_039y * (_951 + _944);
              float _958 = cb0_039y * (_952 + _944);
              float _959 = _919 * 2.0f;
              float _961 = (cb0_039y * -2.0f) / _919;
              float _962 = _950 - _941;
              float _963 = _951 - _941;
              float _964 = _952 - _941;
              float _983 = _923 * 2.0f;
              float _985 = (cb0_039y * 2.0f) / _923;
              float _1010 = select((_950 < _941), ((_959 / (exp2((_962 * 1.4426950216293335f) * _961) + 1.0f)) - cb0_040x), _956);
              float _1011 = select((_951 < _941), ((_959 / (exp2((_963 * 1.4426950216293335f) * _961) + 1.0f)) - cb0_040x), _957);
              float _1012 = select((_952 < _941), ((_959 / (exp2((_964 * 1.4426950216293335f) * _961) + 1.0f)) - cb0_040x), _958);
              float _1019 = _946 - _941;
              float _1023 = saturate(_962 / _1019);
              float _1024 = saturate(_963 / _1019);
              float _1025 = saturate(_964 / _1019);
              bool _1026 = (_946 < _941);
              float _1030 = select(_1026, (1.0f - _1023), _1023);
              float _1031 = select(_1026, (1.0f - _1024), _1024);
              float _1032 = select(_1026, (1.0f - _1025), _1025);
              float _1051 = (((_1030 * _1030) * (select((_950 > _946), (_921 - (_983 / (exp2(((_950 - _946) * 1.4426950216293335f) * _985) + 1.0f))), _956) - _1010)) * (3.0f - (_1030 * 2.0f))) + _1010;
              float _1052 = (((_1031 * _1031) * (select((_951 > _946), (_921 - (_983 / (exp2(((_951 - _946) * 1.4426950216293335f) * _985) + 1.0f))), _957) - _1011)) * (3.0f - (_1031 * 2.0f))) + _1011;
              float _1053 = (((_1032 * _1032) * (select((_952 > _946), (_921 - (_983 / (exp2(((_952 - _946) * 1.4426950216293335f) * _985) + 1.0f))), _958) - _1012)) * (3.0f - (_1032 * 2.0f))) + _1012;
              float _1054 = dot(float3(_1051, _1052, _1053), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _1074 = (cb0_039x * (max(0.0f, (lerp(_1054, _1051, 0.9300000071525574f))) - _770)) + _770;
              float _1075 = (cb0_039x * (max(0.0f, (lerp(_1054, _1052, 0.9300000071525574f))) - _771)) + _771;
              float _1076 = (cb0_039x * (max(0.0f, (lerp(_1054, _1053, 0.9300000071525574f))) - _772)) + _772;
              float _1092 = ((mad(-0.06537103652954102f, _1076, mad(1.451815478503704e-06f, _1075, (_1074 * 1.065374732017517f))) - _1074) * cb0_038z) + _1074;
              float _1093 = ((mad(-0.20366770029067993f, _1076, mad(1.2036634683609009f, _1075, (_1074 * -2.57161445915699e-07f))) - _1075) * cb0_038z) + _1075;
              float _1094 = ((mad(0.9999996423721313f, _1076, mad(2.0954757928848267e-08f, _1075, (_1074 * 1.862645149230957e-08f))) - _1076) * cb0_038z) + _1076;
              SetTonemappedAP1(_1092, _1093, _1094);

              float _1119 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1094, mad((WorkingColorSpace_192[0].y), _1093, ((WorkingColorSpace_192[0].x) * _1092)))));
              float _1120 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1094, mad((WorkingColorSpace_192[1].y), _1093, ((WorkingColorSpace_192[1].x) * _1092)))));
              float _1121 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1094, mad((WorkingColorSpace_192[2].y), _1093, ((WorkingColorSpace_192[2].x) * _1092)))));
              do {
                if (_1119 < 0.0031306699384003878f) {
                  _1132 = (_1119 * 12.920000076293945f);
                } else {
                  _1132 = (((pow(_1119, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                do {
                  if (_1120 < 0.0031306699384003878f) {
                    _1143 = (_1120 * 12.920000076293945f);
                  } else {
                    _1143 = (((pow(_1120, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    if (_1121 < 0.0031306699384003878f) {
                      _1154 = (_1121 * 12.920000076293945f);
                    } else {
                      _1154 = (((pow(_1121, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    float _1158 = (_1143 * 0.9375f) + 0.03125f;
                    float _1165 = _1154 * 15.0f;
                    float _1166 = floor(_1165);
                    float _1167 = _1165 - _1166;
                    float _1169 = (((_1132 * 0.9375f) + 0.03125f) + _1166) * 0.0625f;
                    float4 _1172 = t0.Sample(s0, float2(_1169, _1158));
                    float4 _1179 = t0.Sample(s0, float2((_1169 + 0.0625f), _1158));
                    float _1195 = ((lerp(_1172.x, _1179.x, _1167)) * cb0_005y) + (cb0_005x * _1132);
                    float _1196 = ((lerp(_1172.y, _1179.y, _1167)) * cb0_005y) + (cb0_005x * _1143);
                    float _1197 = ((lerp(_1172.z, _1179.z, _1167)) * cb0_005y) + (cb0_005x * _1154);
                    float _1222 = select((_1195 > 0.040449999272823334f), exp2(log2((abs(_1195) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1195 * 0.07739938050508499f));
                    float _1223 = select((_1196 > 0.040449999272823334f), exp2(log2((abs(_1196) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1196 * 0.07739938050508499f));
                    float _1224 = select((_1197 > 0.040449999272823334f), exp2(log2((abs(_1197) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1197 * 0.07739938050508499f));
                    float _1250 = cb0_016x * (((cb0_041y + (cb0_041x * _1222)) * _1222) + cb0_041z);
                    float _1251 = cb0_016y * (((cb0_041y + (cb0_041x * _1223)) * _1223) + cb0_041z);
                    float _1252 = cb0_016z * (((cb0_041y + (cb0_041x * _1224)) * _1224) + cb0_041z);
                    float _1273 = exp2(log2(max(0.0f, (lerp(_1250, cb0_015x, cb0_015w)))) * cb0_042y);
                    float _1274 = exp2(log2(max(0.0f, (lerp(_1251, cb0_015y, cb0_015w)))) * cb0_042y);
                    float _1275 = exp2(log2(max(0.0f, (lerp(_1252, cb0_015z, cb0_015w)))) * cb0_042y);

                    if (RENODX_TONE_MAP_TYPE != 0.f) {
                      return GenerateOutput(float3(_1273, _1274, _1275), cb0_040w);
                    }
                    do {
                      if (WorkingColorSpace_384 == 0) {
                        float _1294 = mad((WorkingColorSpace_128[0].z), _1275, mad((WorkingColorSpace_128[0].y), _1274, ((WorkingColorSpace_128[0].x) * _1273)));
                        float _1297 = mad((WorkingColorSpace_128[1].z), _1275, mad((WorkingColorSpace_128[1].y), _1274, ((WorkingColorSpace_128[1].x) * _1273)));
                        float _1300 = mad((WorkingColorSpace_128[2].z), _1275, mad((WorkingColorSpace_128[2].y), _1274, ((WorkingColorSpace_128[2].x) * _1273)));
                        _1311 = mad(_43, _1300, mad(_42, _1297, (_1294 * _41)));
                        _1312 = mad(_46, _1300, mad(_45, _1297, (_1294 * _44)));
                        _1313 = mad(_49, _1300, mad(_48, _1297, (_1294 * _47)));
                      } else {
                        _1311 = _1273;
                        _1312 = _1274;
                        _1313 = _1275;
                      }
                      do {
                        if (_1311 < 0.0031306699384003878f) {
                          _1324 = (_1311 * 12.920000076293945f);
                        } else {
                          _1324 = (((pow(_1311, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        do {
                          if (_1312 < 0.0031306699384003878f) {
                            _1335 = (_1312 * 12.920000076293945f);
                          } else {
                            _1335 = (((pow(_1312, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          }
                          do {
                            if (_1313 < 0.0031306699384003878f) {
                              _1346 = (_1313 * 12.920000076293945f);
                            } else {
                              _1346 = (((pow(_1313, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            }
                            SV_Target.x = (_1324 * 0.9523810148239136f);
                            SV_Target.y = (_1335 * 0.9523810148239136f);
                            SV_Target.z = (_1346 * 0.9523810148239136f);
                            SV_Target.w = 0.0f;
                          } while (false);
                        } while (false);
                      } while (false);
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
  bool _100 = (cb0_040w != 0);
  float _102 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _119 = (((((2967800.0f - (_102 * 4607000064.0f)) * _102) + 99.11000061035156f) * _102) + 0.24406300485134125f);
  } else {
    _119 = (((((1901800.0f - (_102 * 2006400000.0f)) * _102) + 247.47999572753906f) * _102) + 0.23703999817371368f);
  }
  float _133 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _140 = cb0_037y * cb0_037y;
  float _143 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_140 * 1.6145605741257896e-07f));
  float _148 = ((_133 * 2.0f) + 4.0f) - (_143 * 8.0f);
  float _149 = (_133 * 3.0f) / _148;
  float _151 = (_143 * 2.0f) / _148;
  bool _152 = (cb0_037y < 4000.0f);
  float _161 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _163 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_140 * 1.5317699909210205f)) / (_161 * _161);
  float _170 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _140;
  float _172 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_140 * 308.60699462890625f)) / (_170 * _170);
  float _174 = rsqrt(dot(float2(_163, _172), float2(_163, _172)));
  float _175 = cb0_037z * 0.05000000074505806f;
  float _178 = ((_175 * _172) * _174) + _133;
  float _181 = _143 - ((_175 * _163) * _174);
  float _186 = (4.0f - (_181 * 8.0f)) + (_178 * 2.0f);
  float _192 = (((_178 * 3.0f) / _186) - _149) + select(_152, _149, _119);
  float _193 = (((_181 * 2.0f) / _186) - _151) + select(_152, _151, (((_119 * 2.869999885559082f) + -0.2750000059604645f) - ((_119 * _119) * 3.0f)));
  float _194 = select(_100, _192, 0.3127000033855438f);
  float _195 = select(_100, _193, 0.32899999618530273f);
  float _196 = select(_100, 0.3127000033855438f, _192);
  float _197 = select(_100, 0.32899999618530273f, _193);
  float _198 = max(_195, 1.000000013351432e-10f);
  float _199 = _194 / _198;
  float _202 = ((1.0f - _194) - _195) / _198;
  float _203 = max(_197, 1.000000013351432e-10f);
  float _204 = _196 / _203;
  float _207 = ((1.0f - _196) - _197) / _203;
  float _226 = mad(-0.16140000522136688f, _207, ((_204 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _202, ((_199 * 0.8950999975204468f) + 0.266400009393692f));
  float _227 = mad(0.03669999912381172f, _207, (1.7135000228881836f - (_204 * 0.7501999735832214f))) / mad(0.03669999912381172f, _202, (1.7135000228881836f - (_199 * 0.7501999735832214f)));
  float _228 = mad(1.0296000242233276f, _207, ((_204 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _202, ((_199 * 0.03889999911189079f) + -0.06849999725818634f));
  float _229 = mad(_227, -0.7501999735832214f, 0.0f);
  float _230 = mad(_227, 1.7135000228881836f, 0.0f);
  float _231 = mad(_227, 0.03669999912381172f, -0.0f);
  float _232 = mad(_228, 0.03889999911189079f, 0.0f);
  float _233 = mad(_228, -0.06849999725818634f, 0.0f);
  float _234 = mad(_228, 1.0296000242233276f, 0.0f);
  float _237 = mad(0.1599626988172531f, _232, mad(-0.1470542997121811f, _229, (_226 * 0.883457362651825f)));
  float _240 = mad(0.1599626988172531f, _233, mad(-0.1470542997121811f, _230, (_226 * 0.26293492317199707f)));
  float _243 = mad(0.1599626988172531f, _234, mad(-0.1470542997121811f, _231, (_226 * -0.15930065512657166f)));
  float _246 = mad(0.04929120093584061f, _232, mad(0.5183603167533875f, _229, (_226 * 0.38695648312568665f)));
  float _249 = mad(0.04929120093584061f, _233, mad(0.5183603167533875f, _230, (_226 * 0.11516613513231277f)));
  float _252 = mad(0.04929120093584061f, _234, mad(0.5183603167533875f, _231, (_226 * -0.0697740763425827f)));
  float _255 = mad(0.9684867262840271f, _232, mad(0.04004279896616936f, _229, (_226 * -0.007634039502590895f)));
  float _258 = mad(0.9684867262840271f, _233, mad(0.04004279896616936f, _230, (_226 * -0.0022720457054674625f)));
  float _261 = mad(0.9684867262840271f, _234, mad(0.04004279896616936f, _231, (_226 * 0.0013765322510153055f)));
  float _264 = mad(_243, (WorkingColorSpace_000[2].x), mad(_240, (WorkingColorSpace_000[1].x), (_237 * (WorkingColorSpace_000[0].x))));
  float _267 = mad(_243, (WorkingColorSpace_000[2].y), mad(_240, (WorkingColorSpace_000[1].y), (_237 * (WorkingColorSpace_000[0].y))));
  float _270 = mad(_243, (WorkingColorSpace_000[2].z), mad(_240, (WorkingColorSpace_000[1].z), (_237 * (WorkingColorSpace_000[0].z))));
  float _273 = mad(_252, (WorkingColorSpace_000[2].x), mad(_249, (WorkingColorSpace_000[1].x), (_246 * (WorkingColorSpace_000[0].x))));
  float _276 = mad(_252, (WorkingColorSpace_000[2].y), mad(_249, (WorkingColorSpace_000[1].y), (_246 * (WorkingColorSpace_000[0].y))));
  float _279 = mad(_252, (WorkingColorSpace_000[2].z), mad(_249, (WorkingColorSpace_000[1].z), (_246 * (WorkingColorSpace_000[0].z))));
  float _282 = mad(_261, (WorkingColorSpace_000[2].x), mad(_258, (WorkingColorSpace_000[1].x), (_255 * (WorkingColorSpace_000[0].x))));
  float _285 = mad(_261, (WorkingColorSpace_000[2].y), mad(_258, (WorkingColorSpace_000[1].y), (_255 * (WorkingColorSpace_000[0].y))));
  float _288 = mad(_261, (WorkingColorSpace_000[2].z), mad(_258, (WorkingColorSpace_000[1].z), (_255 * (WorkingColorSpace_000[0].z))));
  _326 = mad(mad((WorkingColorSpace_064[0].z), _288, mad((WorkingColorSpace_064[0].y), _279, (_270 * (WorkingColorSpace_064[0].x)))), _64, mad(mad((WorkingColorSpace_064[0].z), _285, mad((WorkingColorSpace_064[0].y), _276, (_267 * (WorkingColorSpace_064[0].x)))), _63, (mad((WorkingColorSpace_064[0].z), _282, mad((WorkingColorSpace_064[0].y), _273, (_264 * (WorkingColorSpace_064[0].x)))) * _62)));
  _327 = mad(mad((WorkingColorSpace_064[1].z), _288, mad((WorkingColorSpace_064[1].y), _279, (_270 * (WorkingColorSpace_064[1].x)))), _64, mad(mad((WorkingColorSpace_064[1].z), _285, mad((WorkingColorSpace_064[1].y), _276, (_267 * (WorkingColorSpace_064[1].x)))), _63, (mad((WorkingColorSpace_064[1].z), _282, mad((WorkingColorSpace_064[1].y), _273, (_264 * (WorkingColorSpace_064[1].x)))) * _62)));
  _328 = mad(mad((WorkingColorSpace_064[2].z), _288, mad((WorkingColorSpace_064[2].y), _279, (_270 * (WorkingColorSpace_064[2].x)))), _64, mad(mad((WorkingColorSpace_064[2].z), _285, mad((WorkingColorSpace_064[2].y), _276, (_267 * (WorkingColorSpace_064[2].x)))), _63, (mad((WorkingColorSpace_064[2].z), _282, mad((WorkingColorSpace_064[2].y), _273, (_264 * (WorkingColorSpace_064[2].x)))) * _62)));
  float _343 = mad((WorkingColorSpace_128[0].z), _328, mad((WorkingColorSpace_128[0].y), _327, ((WorkingColorSpace_128[0].x) * _326)));
  float _346 = mad((WorkingColorSpace_128[1].z), _328, mad((WorkingColorSpace_128[1].y), _327, ((WorkingColorSpace_128[1].x) * _326)));
  float _349 = mad((WorkingColorSpace_128[2].z), _328, mad((WorkingColorSpace_128[2].y), _327, ((WorkingColorSpace_128[2].x) * _326)));
  SetUngradedAP1(float3(_343, _346, _349));

  float _350 = dot(float3(_343, _346, _349), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _354 = (_343 / _350) + -1.0f;
  float _355 = (_346 / _350) + -1.0f;
  float _356 = (_349 / _350) + -1.0f;
  float _368 = (1.0f - exp2(((_350 * _350) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_354, _355, _356), float3(_354, _355, _356)) * -4.0f));
  float _384 = ((mad(-0.06368321925401688f, _349, mad(-0.3292922377586365f, _346, (_343 * 1.3704125881195068f))) - _343) * _368) + _343;
  float _385 = ((mad(-0.010861365124583244f, _349, mad(1.0970927476882935f, _346, (_343 * -0.08343357592821121f))) - _346) * _368) + _346;
  float _386 = ((mad(1.2036951780319214f, _349, mad(-0.09862580895423889f, _346, (_343 * -0.02579331398010254f))) - _349) * _368) + _349;
  float _387 = dot(float3(_384, _385, _386), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _401 = cb0_021w + cb0_026w;
  float _415 = cb0_020w * cb0_025w;
  float _429 = cb0_019w * cb0_024w;
  float _443 = cb0_018w * cb0_023w;
  float _457 = cb0_017w * cb0_022w;
  float _461 = _384 - _387;
  float _462 = _385 - _387;
  float _463 = _386 - _387;
  float _520 = saturate(_387 / cb0_037w);
  float _524 = (_520 * _520) * (3.0f - (_520 * 2.0f));
  float _525 = 1.0f - _524;
  float _534 = cb0_021w + cb0_036w;
  float _543 = cb0_020w * cb0_035w;
  float _552 = cb0_019w * cb0_034w;
  float _561 = cb0_018w * cb0_033w;
  float _570 = cb0_017w * cb0_032w;
  float _633 = saturate((_387 - cb0_038x) / (cb0_038y - cb0_038x));
  float _637 = (_633 * _633) * (3.0f - (_633 * 2.0f));
  float _646 = cb0_021w + cb0_031w;
  float _655 = cb0_020w * cb0_030w;
  float _664 = cb0_019w * cb0_029w;
  float _673 = cb0_018w * cb0_028w;
  float _682 = cb0_017w * cb0_027w;
  float _740 = _524 - _637;
  float _751 = ((_637 * (((cb0_021x + cb0_036x) + _534) + (((cb0_020x * cb0_035x) * _543) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _561) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _570) * _461) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _552)))))) + (_525 * (((cb0_021x + cb0_026x) + _401) + (((cb0_020x * cb0_025x) * _415) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _443) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _457) * _461) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _429))))))) + ((((cb0_021x + cb0_031x) + _646) + (((cb0_020x * cb0_030x) * _655) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _673) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _682) * _461) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _664))))) * _740);
  float _753 = ((_637 * (((cb0_021y + cb0_036y) + _534) + (((cb0_020y * cb0_035y) * _543) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _561) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _570) * _462) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _552)))))) + (_525 * (((cb0_021y + cb0_026y) + _401) + (((cb0_020y * cb0_025y) * _415) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _443) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _457) * _462) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _429))))))) + ((((cb0_021y + cb0_031y) + _646) + (((cb0_020y * cb0_030y) * _655) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _673) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _682) * _462) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _664))))) * _740);
  float _755 = ((_637 * (((cb0_021z + cb0_036z) + _534) + (((cb0_020z * cb0_035z) * _543) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _561) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _570) * _463) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _552)))))) + (_525 * (((cb0_021z + cb0_026z) + _401) + (((cb0_020z * cb0_025z) * _415) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _443) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _457) * _463) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _429))))))) + ((((cb0_021z + cb0_031z) + _646) + (((cb0_020z * cb0_030z) * _655) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _673) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _682) * _463) + _387)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _664))))) * _740);
  SetUntonemappedAP1(float3(_751, _753, _755));

  float _770 = ((mad(0.061360642313957214f, _755, mad(-4.540197551250458e-09f, _753, (_751 * 0.9386394023895264f))) - _751) * cb0_038z) + _751;
  float _771 = ((mad(0.169205904006958f, _755, mad(0.8307942152023315f, _753, (_751 * 6.775371730327606e-08f))) - _753) * cb0_038z) + _753;
  float _772 = (mad(-2.3283064365386963e-10f, _753, (_751 * -9.313225746154785e-10f)) * cb0_038z) + _755;
  float _775 = mad(0.16386905312538147f, _772, mad(0.14067868888378143f, _771, (_770 * 0.6954522132873535f)));
  float _778 = mad(0.0955343246459961f, _772, mad(0.8596711158752441f, _771, (_770 * 0.044794581830501556f)));
  float _781 = mad(1.0015007257461548f, _772, mad(0.004025210160762072f, _771, (_770 * -0.005525882821530104f)));
  float _785 = max(max(_775, _778), _781);
  float _790 = (max(_785, 1.000000013351432e-10f) - max(min(min(_775, _778), _781), 1.000000013351432e-10f)) / max(_785, 0.009999999776482582f);
  float _803 = ((_778 + _775) + _781) + (sqrt((((_781 - _778) * _781) + ((_778 - _775) * _778)) + ((_775 - _781) * _775)) * 1.75f);
  float _804 = _803 * 0.3333333432674408f;
  float _805 = _790 + -0.4000000059604645f;
  float _806 = _805 * 5.0f;
  float _810 = max((1.0f - abs(_805 * 2.5f)), 0.0f);
  float _821 = ((float((int)(((int)(uint)((bool)(_806 > 0.0f))) - ((int)(uint)((bool)(_806 < 0.0f))))) * (1.0f - (_810 * _810))) + 1.0f) * 0.02500000037252903f;
  if (!(_804 <= 0.0533333346247673f)) {
    if (!(_804 >= 0.1599999964237213f)) {
      _830 = (((0.23999999463558197f / _803) + -0.5f) * _821);
    } else {
      _830 = 0.0f;
    }
  } else {
    _830 = _821;
  }
  float _831 = _830 + 1.0f;
  float _832 = _831 * _775;
  float _833 = _831 * _778;
  float _834 = _831 * _781;
  if (!((bool)(_832 == _833) && (bool)(_833 == _834))) {
    float _841 = ((_832 * 2.0f) - _833) - _834;
    float _844 = ((_778 - _781) * 1.7320507764816284f) * _831;
    float _846 = atan(_844 / _841);
    bool _849 = (_841 < 0.0f);
    bool _850 = (_841 == 0.0f);
    bool _851 = (_844 >= 0.0f);
    bool _852 = (_844 < 0.0f);
    _863 = select((_851 && _850), 90.0f, select((_852 && _850), -90.0f, (select((_852 && _849), (_846 + -3.1415927410125732f), select((_851 && _849), (_846 + 3.1415927410125732f), _846)) * 57.2957763671875f)));
  } else {
    _863 = 0.0f;
  }
  float _868 = min(max(select((_863 < 0.0f), (_863 + 360.0f), _863), 0.0f), 360.0f);
  if (_868 < -180.0f) {
    _877 = (_868 + 360.0f);
  } else {
    if (_868 > 180.0f) {
      _877 = (_868 + -360.0f);
    } else {
      _877 = _868;
    }
  }
  float _881 = saturate(1.0f - abs(_877 * 0.014814814552664757f));
  float _885 = (_881 * _881) * (3.0f - (_881 * 2.0f));
  float _891 = ((_885 * _885) * ((_790 * 0.18000000715255737f) * (0.029999999329447746f - _832))) + _832;
  float _901 = max(0.0f, mad(-0.21492856740951538f, _834, mad(-0.2365107536315918f, _833, (_891 * 1.4514392614364624f))));
  float _902 = max(0.0f, mad(-0.09967592358589172f, _834, mad(1.17622971534729f, _833, (_891 * -0.07655377686023712f))));
  float _903 = max(0.0f, mad(0.9977163076400757f, _834, mad(-0.006032449658960104f, _833, (_891 * 0.008316148072481155f))));
  float _904 = dot(float3(_901, _902, _903), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _919 = (cb0_040x + 1.0f) - cb0_039z;
  float _921 = cb0_040y + 1.0f;
  float _923 = _921 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _941 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    float _932 = (cb0_040x + 0.18000000715255737f) / _919;
    _941 = (-0.7447274923324585f - ((log2(_932 / (2.0f - _932)) * 0.3465735912322998f) * (_919 / cb0_039y)));
  }
  float _944 = ((1.0f - cb0_039z) / cb0_039y) - _941;
  float _946 = (cb0_039w / cb0_039y) - _944;
  float _950 = log2(lerp(_904, _901, 0.9599999785423279f)) * 0.3010300099849701f;
  float _951 = log2(lerp(_904, _902, 0.9599999785423279f)) * 0.3010300099849701f;
  float _952 = log2(lerp(_904, _903, 0.9599999785423279f)) * 0.3010300099849701f;
  float _956 = cb0_039y * (_950 + _944);
  float _957 = cb0_039y * (_951 + _944);
  float _958 = cb0_039y * (_952 + _944);
  float _959 = _919 * 2.0f;
  float _961 = (cb0_039y * -2.0f) / _919;
  float _962 = _950 - _941;
  float _963 = _951 - _941;
  float _964 = _952 - _941;
  float _983 = _923 * 2.0f;
  float _985 = (cb0_039y * 2.0f) / _923;
  float _1010 = select((_950 < _941), ((_959 / (exp2((_962 * 1.4426950216293335f) * _961) + 1.0f)) - cb0_040x), _956);
  float _1011 = select((_951 < _941), ((_959 / (exp2((_963 * 1.4426950216293335f) * _961) + 1.0f)) - cb0_040x), _957);
  float _1012 = select((_952 < _941), ((_959 / (exp2((_964 * 1.4426950216293335f) * _961) + 1.0f)) - cb0_040x), _958);
  float _1019 = _946 - _941;
  float _1023 = saturate(_962 / _1019);
  float _1024 = saturate(_963 / _1019);
  float _1025 = saturate(_964 / _1019);
  bool _1026 = (_946 < _941);
  float _1030 = select(_1026, (1.0f - _1023), _1023);
  float _1031 = select(_1026, (1.0f - _1024), _1024);
  float _1032 = select(_1026, (1.0f - _1025), _1025);
  float _1051 = (((_1030 * _1030) * (select((_950 > _946), (_921 - (_983 / (exp2(((_950 - _946) * 1.4426950216293335f) * _985) + 1.0f))), _956) - _1010)) * (3.0f - (_1030 * 2.0f))) + _1010;
  float _1052 = (((_1031 * _1031) * (select((_951 > _946), (_921 - (_983 / (exp2(((_951 - _946) * 1.4426950216293335f) * _985) + 1.0f))), _957) - _1011)) * (3.0f - (_1031 * 2.0f))) + _1011;
  float _1053 = (((_1032 * _1032) * (select((_952 > _946), (_921 - (_983 / (exp2(((_952 - _946) * 1.4426950216293335f) * _985) + 1.0f))), _958) - _1012)) * (3.0f - (_1032 * 2.0f))) + _1012;
  float _1054 = dot(float3(_1051, _1052, _1053), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1074 = (cb0_039x * (max(0.0f, (lerp(_1054, _1051, 0.9300000071525574f))) - _770)) + _770;
  float _1075 = (cb0_039x * (max(0.0f, (lerp(_1054, _1052, 0.9300000071525574f))) - _771)) + _771;
  float _1076 = (cb0_039x * (max(0.0f, (lerp(_1054, _1053, 0.9300000071525574f))) - _772)) + _772;
  float _1092 = ((mad(-0.06537103652954102f, _1076, mad(1.451815478503704e-06f, _1075, (_1074 * 1.065374732017517f))) - _1074) * cb0_038z) + _1074;
  float _1093 = ((mad(-0.20366770029067993f, _1076, mad(1.2036634683609009f, _1075, (_1074 * -2.57161445915699e-07f))) - _1075) * cb0_038z) + _1075;
  float _1094 = ((mad(0.9999996423721313f, _1076, mad(2.0954757928848267e-08f, _1075, (_1074 * 1.862645149230957e-08f))) - _1076) * cb0_038z) + _1076;
  SetTonemappedAP1(_1092, _1093, _1094);

  float _1119 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1094, mad((WorkingColorSpace_192[0].y), _1093, ((WorkingColorSpace_192[0].x) * _1092)))));
  float _1120 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1094, mad((WorkingColorSpace_192[1].y), _1093, ((WorkingColorSpace_192[1].x) * _1092)))));
  float _1121 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1094, mad((WorkingColorSpace_192[2].y), _1093, ((WorkingColorSpace_192[2].x) * _1092)))));
  if (_1119 < 0.0031306699384003878f) {
    _1132 = (_1119 * 12.920000076293945f);
  } else {
    _1132 = (((pow(_1119, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1120 < 0.0031306699384003878f) {
    _1143 = (_1120 * 12.920000076293945f);
  } else {
    _1143 = (((pow(_1120, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1121 < 0.0031306699384003878f) {
    _1154 = (_1121 * 12.920000076293945f);
  } else {
    _1154 = (((pow(_1121, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1158 = (_1143 * 0.9375f) + 0.03125f;
  float _1165 = _1154 * 15.0f;
  float _1166 = floor(_1165);
  float _1167 = _1165 - _1166;
  float _1169 = (((_1132 * 0.9375f) + 0.03125f) + _1166) * 0.0625f;
  float4 _1172 = t0.Sample(s0, float2(_1169, _1158));
  float4 _1179 = t0.Sample(s0, float2((_1169 + 0.0625f), _1158));
  float _1195 = ((lerp(_1172.x, _1179.x, _1167)) * cb0_005y) + (cb0_005x * _1132);
  float _1196 = ((lerp(_1172.y, _1179.y, _1167)) * cb0_005y) + (cb0_005x * _1143);
  float _1197 = ((lerp(_1172.z, _1179.z, _1167)) * cb0_005y) + (cb0_005x * _1154);
  float _1222 = select((_1195 > 0.040449999272823334f), exp2(log2((abs(_1195) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1195 * 0.07739938050508499f));
  float _1223 = select((_1196 > 0.040449999272823334f), exp2(log2((abs(_1196) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1196 * 0.07739938050508499f));
  float _1224 = select((_1197 > 0.040449999272823334f), exp2(log2((abs(_1197) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1197 * 0.07739938050508499f));
  float _1250 = cb0_016x * (((cb0_041y + (cb0_041x * _1222)) * _1222) + cb0_041z);
  float _1251 = cb0_016y * (((cb0_041y + (cb0_041x * _1223)) * _1223) + cb0_041z);
  float _1252 = cb0_016z * (((cb0_041y + (cb0_041x * _1224)) * _1224) + cb0_041z);
  float _1273 = exp2(log2(max(0.0f, (lerp(_1250, cb0_015x, cb0_015w)))) * cb0_042y);
  float _1274 = exp2(log2(max(0.0f, (lerp(_1251, cb0_015y, cb0_015w)))) * cb0_042y);
  float _1275 = exp2(log2(max(0.0f, (lerp(_1252, cb0_015z, cb0_015w)))) * cb0_042y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return GenerateOutput(float3(_1273, _1274, _1275), cb0_040w);
  }
  if (WorkingColorSpace_384 == 0) {
    float _1294 = mad((WorkingColorSpace_128[0].z), _1275, mad((WorkingColorSpace_128[0].y), _1274, ((WorkingColorSpace_128[0].x) * _1273)));
    float _1297 = mad((WorkingColorSpace_128[1].z), _1275, mad((WorkingColorSpace_128[1].y), _1274, ((WorkingColorSpace_128[1].x) * _1273)));
    float _1300 = mad((WorkingColorSpace_128[2].z), _1275, mad((WorkingColorSpace_128[2].y), _1274, ((WorkingColorSpace_128[2].x) * _1273)));
    _1311 = mad(_43, _1300, mad(_42, _1297, (_1294 * _41)));
    _1312 = mad(_46, _1300, mad(_45, _1297, (_1294 * _44)));
    _1313 = mad(_49, _1300, mad(_48, _1297, (_1294 * _47)));
  } else {
    _1311 = _1273;
    _1312 = _1274;
    _1313 = _1275;
  }
  if (_1311 < 0.0031306699384003878f) {
    _1324 = (_1311 * 12.920000076293945f);
  } else {
    _1324 = (((pow(_1311, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1312 < 0.0031306699384003878f) {
    _1335 = (_1312 * 12.920000076293945f);
  } else {
    _1335 = (((pow(_1312, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1313 < 0.0031306699384003878f) {
    _1346 = (_1313 * 12.920000076293945f);
  } else {
    _1346 = (((pow(_1313, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1324 * 0.9523810148239136f);
  SV_Target.y = (_1335 * 0.9523810148239136f);
  SV_Target.z = (_1346 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
