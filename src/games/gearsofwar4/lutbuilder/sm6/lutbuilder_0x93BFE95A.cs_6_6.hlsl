// Far Far West (UE 5.7.4.0)

#include "../lutbuilderoutput.hlsli"

struct FWorkingColorSpaceConstants {
  float4 FWorkingColorSpaceConstants_000[4];
  float4 FWorkingColorSpaceConstants_064[4];
  float4 FWorkingColorSpaceConstants_128[4];
  float4 FWorkingColorSpaceConstants_192[4];
  float4 FWorkingColorSpaceConstants_256[4];
  float4 FWorkingColorSpaceConstants_320[4];
  int FWorkingColorSpaceConstants_384;
};

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

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
  uint cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  uint cb0_043x : packoffset(c043.x);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
};

cbuffer cb1 : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace_000 : packoffset(c000.x);
};

SamplerState s0 : register(s0);

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _22 = 0.5f / cb0_037x;
  float _27 = cb0_037x + -1.0f;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _129;
  float _336;
  float _337;
  float _338;
  float _840;
  float _873;
  float _887;
  float _951;
  float _1142;
  float _1153;
  float _1164;
  float _1307;
  float _1308;
  float _1309;
  float _1320;
  float _1331;
  float _1342;
  if (!((uint)(cb0_043x) == 1)) {
    if (!((uint)(cb0_043x) == 2)) {
      if (!((uint)(cb0_043x) == 3)) {
        bool _40 = ((uint)(cb0_043x) == 4);
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
  float _72 = (exp2((((cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _22)) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _73 = (exp2((((cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _22)) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _74 = (exp2(((float((uint)SV_DispatchThreadID.z) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _336 = _72;
      _337 = _73;
      _338 = _74;
      float _353 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _338, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _337, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _336)));
      float _356 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _338, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _337, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _336)));
      float _359 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _338, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _337, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _336)));
      float _360 = dot(float3(_353, _356, _359), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _364 = (_353 / _360) + -1.0f;
      float _365 = (_356 / _360) + -1.0f;
      float _366 = (_359 / _360) + -1.0f;

      // float _378 = (1.0f - exp2(((_360 * _360) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_364, _365, _366), float3(_364, _365, _366)) * -4.0f));
      float _378 = (1.0f - exp2(((_360 * _360) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_364, _365, _366), float3(_364, _365, _366)) * -4.0f));

      float _394 = ((mad(-0.06368321925401688f, _359, mad(-0.3292922377586365f, _356, (_353 * 1.3704125881195068f))) - _353) * _378) + _353;
      float _395 = ((mad(-0.010861365124583244f, _359, mad(1.0970927476882935f, _356, (_353 * -0.08343357592821121f))) - _356) * _378) + _356;
      float _396 = ((mad(1.2036951780319214f, _359, mad(-0.09862580895423889f, _356, (_353 * -0.02579331398010254f))) - _359) * _378) + _359;
      float _397 = dot(float3(_394, _395, _396), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _411 = cb0_021w + cb0_026w;
      float _425 = cb0_020w * cb0_025w;
      float _439 = cb0_019w * cb0_024w;
      float _453 = cb0_018w * cb0_023w;
      float _467 = cb0_017w * cb0_022w;
      float _471 = _394 - _397;
      float _472 = _395 - _397;
      float _473 = _396 - _397;
      float _530 = saturate(_397 / cb0_037w);
      float _534 = (_530 * _530) * (3.0f - (_530 * 2.0f));
      float _535 = 1.0f - _534;
      float _544 = cb0_021w + cb0_036w;
      float _553 = cb0_020w * cb0_035w;
      float _562 = cb0_019w * cb0_034w;
      float _571 = cb0_018w * cb0_033w;
      float _580 = cb0_017w * cb0_032w;
      float _643 = saturate((_397 - cb0_038x) / (cb0_038y - cb0_038x));
      float _647 = (_643 * _643) * (3.0f - (_643 * 2.0f));
      float _656 = cb0_021w + cb0_031w;
      float _665 = cb0_020w * cb0_030w;
      float _674 = cb0_019w * cb0_029w;
      float _683 = cb0_018w * cb0_028w;
      float _692 = cb0_017w * cb0_027w;
      float _750 = _534 - _647;
      float _761 = ((_647 * (((cb0_021x + cb0_036x) + _544) + (((cb0_020x * cb0_035x) * _553) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _571) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _580) * _471) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _562)))))) + (_535 * (((cb0_021x + cb0_026x) + _411) + (((cb0_020x * cb0_025x) * _425) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _453) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _467) * _471) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _439))))))) + ((((cb0_021x + cb0_031x) + _656) + (((cb0_020x * cb0_030x) * _665) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _683) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _692) * _471) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _674))))) * _750);
      float _763 = ((_647 * (((cb0_021y + cb0_036y) + _544) + (((cb0_020y * cb0_035y) * _553) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _571) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _580) * _472) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _562)))))) + (_535 * (((cb0_021y + cb0_026y) + _411) + (((cb0_020y * cb0_025y) * _425) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _453) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _467) * _472) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _439))))))) + ((((cb0_021y + cb0_031y) + _656) + (((cb0_020y * cb0_030y) * _665) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _683) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _692) * _472) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _674))))) * _750);
      float _765 = ((_647 * (((cb0_021z + cb0_036z) + _544) + (((cb0_020z * cb0_035z) * _553) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _571) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _580) * _473) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _562)))))) + (_535 * (((cb0_021z + cb0_026z) + _411) + (((cb0_020z * cb0_025z) * _425) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _453) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _467) * _473) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _439))))))) + ((((cb0_021z + cb0_031z) + _656) + (((cb0_020z * cb0_030z) * _665) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _683) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _692) * _473) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _674))))) * _750);

      UECbufferConfig cb_config = CreateCbufferConfig();
      cb_config.ue_filmblackclip = cb0_040x;
      cb_config.ue_filmtoe = cb0_039z;
      cb_config.ue_filmshoulder = cb0_039w;
      cb_config.ue_filmslope = cb0_039y;
      cb_config.ue_filmwhiteclip = cb0_040y;
      cb_config.ue_tonecurveammount = cb0_039x;
      cb_config.ue_mappingpolynomial = float3(cb0_041x, cb0_041y, cb0_041z);
      cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
      cb_config.ue_bluecorrection = cb0_038z;
      cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);
      float4 lutweights[2] = { float4(cb0_005x, cb0_005y, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
      cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xy is used

      float4 output = ProcessLutbuilder(float3(_761, _763, _765), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
      u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
      return;

      float _780 = ((mad(0.061360642313957214f, _765, mad(-4.540197551250458e-09f, _763, (_761 * 0.9386394023895264f))) - _761) * cb0_038z) + _761;
      float _781 = ((mad(0.169205904006958f, _765, mad(0.8307942152023315f, _763, (_761 * 6.775371730327606e-08f))) - _763) * cb0_038z) + _763;
      float _782 = (mad(-2.3283064365386963e-10f, _763, (_761 * -9.313225746154785e-10f)) * cb0_038z) + _765;
      float _785 = mad(0.16386905312538147f, _782, mad(0.14067868888378143f, _781, (_780 * 0.6954522132873535f)));
      float _788 = mad(0.0955343246459961f, _782, mad(0.8596711158752441f, _781, (_780 * 0.044794581830501556f)));
      float _791 = mad(1.0015007257461548f, _782, mad(0.004025210160762072f, _781, (_780 * -0.005525882821530104f)));
      float _795 = max(max(_785, _788), _791);
      float _800 = (max(_795, 1.000000013351432e-10f) - max(min(min(_785, _788), _791), 1.000000013351432e-10f)) / max(_795, 0.009999999776482582f);
      float _813 = ((_788 + _785) + _791) + (sqrt((((_791 - _788) * _791) + ((_788 - _785) * _788)) + ((_785 - _791) * _785)) * 1.75f);
      float _814 = _813 * 0.3333333432674408f;
      float _815 = _800 + -0.4000000059604645f;
      float _816 = _815 * 5.0f;
      float _820 = max((1.0f - abs(_815 * 2.5f)), 0.0f);
      float _831 = ((float(((int)(uint)((bool)(_816 > 0.0f))) - ((int)(uint)((bool)(_816 < 0.0f)))) * (1.0f - (_820 * _820))) + 1.0f) * 0.02500000037252903f;
      do {
        if (!(_814 <= 0.0533333346247673f)) {
          if (!(_814 >= 0.1599999964237213f)) {
            _840 = (((0.23999999463558197f / _813) + -0.5f) * _831);
          } else {
            _840 = 0.0f;
          }
        } else {
          _840 = _831;
        }
        float _841 = _840 + 1.0f;
        float _842 = _841 * _785;
        float _843 = _841 * _788;
        float _844 = _841 * _791;
        do {
          if (!((bool)(_842 == _843) && (bool)(_843 == _844))) {
            float _851 = ((_842 * 2.0f) - _843) - _844;
            float _854 = ((_788 - _791) * 1.7320507764816284f) * _841;
            float _856 = atan(_854 / _851);
            bool _859 = (_851 < 0.0f);
            bool _860 = (_851 == 0.0f);
            bool _861 = (_854 >= 0.0f);
            bool _862 = (_854 < 0.0f);
            _873 = select((_861 && _860), 90.0f, select((_862 && _860), -90.0f, (select((_862 && _859), (_856 + -3.1415927410125732f), select((_861 && _859), (_856 + 3.1415927410125732f), _856)) * 57.2957763671875f)));
          } else {
            _873 = 0.0f;
          }
          float _878 = min(max(select((_873 < 0.0f), (_873 + 360.0f), _873), 0.0f), 360.0f);
          do {
            if (_878 < -180.0f) {
              _887 = (_878 + 360.0f);
            } else {
              if (_878 > 180.0f) {
                _887 = (_878 + -360.0f);
              } else {
                _887 = _878;
              }
            }
            float _891 = saturate(1.0f - abs(_887 * 0.014814814552664757f));
            float _895 = (_891 * _891) * (3.0f - (_891 * 2.0f));
            float _901 = ((_895 * _895) * ((_800 * 0.18000000715255737f) * (0.029999999329447746f - _842))) + _842;
            float _911 = max(0.0f, mad(-0.21492856740951538f, _844, mad(-0.2365107536315918f, _843, (_901 * 1.4514392614364624f))));
            float _912 = max(0.0f, mad(-0.09967592358589172f, _844, mad(1.17622971534729f, _843, (_901 * -0.07655377686023712f))));
            float _913 = max(0.0f, mad(0.9977163076400757f, _844, mad(-0.006032449658960104f, _843, (_901 * 0.008316148072481155f))));
            float _914 = dot(float3(_911, _912, _913), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _929 = (cb0_040x + 1.0f) - cb0_039z;
            float _931 = cb0_040y + 1.0f;
            float _933 = _931 - cb0_039w;
            do {
              if (cb0_039z > 0.800000011920929f) {
                _951 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
              } else {
                float _942 = (cb0_040x + 0.18000000715255737f) / _929;
                _951 = (-0.7447274923324585f - ((log2(_942 / (2.0f - _942)) * 0.3465735912322998f) * (_929 / cb0_039y)));
              }
              float _954 = ((1.0f - cb0_039z) / cb0_039y) - _951;
              float _956 = (cb0_039w / cb0_039y) - _954;
              float _960 = log2(lerp(_914, _911, 0.9599999785423279f)) * 0.3010300099849701f;
              float _961 = log2(lerp(_914, _912, 0.9599999785423279f)) * 0.3010300099849701f;
              float _962 = log2(lerp(_914, _913, 0.9599999785423279f)) * 0.3010300099849701f;
              float _966 = cb0_039y * (_960 + _954);
              float _967 = cb0_039y * (_961 + _954);
              float _968 = cb0_039y * (_962 + _954);
              float _969 = _929 * 2.0f;
              float _971 = (cb0_039y * -2.0f) / _929;
              float _972 = _960 - _951;
              float _973 = _961 - _951;
              float _974 = _962 - _951;
              float _993 = _933 * 2.0f;
              float _995 = (cb0_039y * 2.0f) / _933;
              float _1020 = select((_960 < _951), ((_969 / (exp2((_972 * 1.4426950216293335f) * _971) + 1.0f)) - cb0_040x), _966);
              float _1021 = select((_961 < _951), ((_969 / (exp2((_973 * 1.4426950216293335f) * _971) + 1.0f)) - cb0_040x), _967);
              float _1022 = select((_962 < _951), ((_969 / (exp2((_974 * 1.4426950216293335f) * _971) + 1.0f)) - cb0_040x), _968);
              float _1029 = _956 - _951;
              float _1033 = saturate(_972 / _1029);
              float _1034 = saturate(_973 / _1029);
              float _1035 = saturate(_974 / _1029);
              bool _1036 = (_956 < _951);
              float _1040 = select(_1036, (1.0f - _1033), _1033);
              float _1041 = select(_1036, (1.0f - _1034), _1034);
              float _1042 = select(_1036, (1.0f - _1035), _1035);
              float _1061 = (((_1040 * _1040) * (select((_960 > _956), (_931 - (_993 / (exp2(((_960 - _956) * 1.4426950216293335f) * _995) + 1.0f))), _966) - _1020)) * (3.0f - (_1040 * 2.0f))) + _1020;
              float _1062 = (((_1041 * _1041) * (select((_961 > _956), (_931 - (_993 / (exp2(((_961 - _956) * 1.4426950216293335f) * _995) + 1.0f))), _967) - _1021)) * (3.0f - (_1041 * 2.0f))) + _1021;
              float _1063 = (((_1042 * _1042) * (select((_962 > _956), (_931 - (_993 / (exp2(((_962 - _956) * 1.4426950216293335f) * _995) + 1.0f))), _968) - _1022)) * (3.0f - (_1042 * 2.0f))) + _1022;
              float _1064 = dot(float3(_1061, _1062, _1063), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _1084 = (cb0_039x * (max(0.0f, (lerp(_1064, _1061, 0.9300000071525574f))) - _780)) + _780;
              float _1085 = (cb0_039x * (max(0.0f, (lerp(_1064, _1062, 0.9300000071525574f))) - _781)) + _781;
              float _1086 = (cb0_039x * (max(0.0f, (lerp(_1064, _1063, 0.9300000071525574f))) - _782)) + _782;
              float _1102 = ((mad(-0.06537103652954102f, _1086, mad(1.451815478503704e-06f, _1085, (_1084 * 1.065374732017517f))) - _1084) * cb0_038z) + _1084;
              float _1103 = ((mad(-0.20366770029067993f, _1086, mad(1.2036634683609009f, _1085, (_1084 * -2.57161445915699e-07f))) - _1085) * cb0_038z) + _1085;
              float _1104 = ((mad(0.9999996423721313f, _1086, mad(2.0954757928848267e-08f, _1085, (_1084 * 1.862645149230957e-08f))) - _1086) * cb0_038z) + _1086;
              float _1129 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1104, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1103, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1102)))));
              float _1130 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1104, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1103, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1102)))));
              float _1131 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1104, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1103, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1102)))));
              do {
                if (_1129 < 0.0031306699384003878f) {
                  _1142 = (_1129 * 12.920000076293945f);
                } else {
                  _1142 = (((pow(_1129, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                do {
                  if (_1130 < 0.0031306699384003878f) {
                    _1153 = (_1130 * 12.920000076293945f);
                  } else {
                    _1153 = (((pow(_1130, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    if (_1131 < 0.0031306699384003878f) {
                      _1164 = (_1131 * 12.920000076293945f);
                    } else {
                      _1164 = (((pow(_1131, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    float _1168 = (_1153 * 0.9375f) + 0.03125f;
                    float _1175 = _1164 * 15.0f;
                    float _1176 = floor(_1175);
                    float _1177 = _1175 - _1176;
                    float _1179 = (((_1142 * 0.9375f) + 0.03125f) + _1176) * 0.0625f;
                    float4 _1182 = t0.SampleLevel(s0, float2(_1179, _1168), 0.0f);
                    float4 _1187 = t0.SampleLevel(s0, float2((_1179 + 0.0625f), _1168), 0.0f);
                    float _1203 = ((lerp(_1182.x, _1187.x, _1177)) * cb0_005y) + (cb0_005x * _1142);
                    float _1204 = ((lerp(_1182.y, _1187.y, _1177)) * cb0_005y) + (cb0_005x * _1153);
                    float _1205 = ((lerp(_1182.z, _1187.z, _1177)) * cb0_005y) + (cb0_005x * _1164);
                    float _1230 = select((_1203 > 0.040449999272823334f), exp2(log2((abs(_1203) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1203 * 0.07739938050508499f));
                    float _1231 = select((_1204 > 0.040449999272823334f), exp2(log2((abs(_1204) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1204 * 0.07739938050508499f));
                    float _1232 = select((_1205 > 0.040449999272823334f), exp2(log2((abs(_1205) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1205 * 0.07739938050508499f));
                    float _1258 = cb0_016x * (((cb0_041y + (cb0_041x * _1230)) * _1230) + cb0_041z);
                    float _1259 = cb0_016y * (((cb0_041y + (cb0_041x * _1231)) * _1231) + cb0_041z);
                    float _1260 = cb0_016z * (((cb0_041y + (cb0_041x * _1232)) * _1232) + cb0_041z);
                    float _1281 = exp2(log2(max(0.0f, (lerp(_1258, cb0_015x, cb0_015w)))) * cb0_042y);
                    float _1282 = exp2(log2(max(0.0f, (lerp(_1259, cb0_015y, cb0_015w)))) * cb0_042y);
                    float _1283 = exp2(log2(max(0.0f, (lerp(_1260, cb0_015z, cb0_015w)))) * cb0_042y);
                    do {
                      if ((uint)(WorkingColorSpace_000.FWorkingColorSpaceConstants_384) == 0) {
                        float _1290 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1283, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1282, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1281)));
                        float _1293 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1283, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1282, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1281)));
                        float _1296 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1283, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1282, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1281)));
                        _1307 = mad(_53, _1296, mad(_52, _1293, (_1290 * _51)));
                        _1308 = mad(_56, _1296, mad(_55, _1293, (_1290 * _54)));
                        _1309 = mad(_59, _1296, mad(_58, _1293, (_1290 * _57)));
                      } else {
                        _1307 = _1281;
                        _1308 = _1282;
                        _1309 = _1283;
                      }
                      do {
                        if (_1307 < 0.0031306699384003878f) {
                          _1320 = (_1307 * 12.920000076293945f);
                        } else {
                          _1320 = (((pow(_1307, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        do {
                          if (_1308 < 0.0031306699384003878f) {
                            _1331 = (_1308 * 12.920000076293945f);
                          } else {
                            _1331 = (((pow(_1308, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                          }
                          do {
                            if (_1309 < 0.0031306699384003878f) {
                              _1342 = (_1309 * 12.920000076293945f);
                            } else {
                              _1342 = (((pow(_1309, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                            }
                            u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1320 * 0.9523810148239136f), (_1331 * 0.9523810148239136f), (_1342 * 0.9523810148239136f), 0.0f);
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
  bool _110 = ((uint)(cb0_040w) != 0);
  float _112 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _129 = (((((2967800.0f - (_112 * 4607000064.0f)) * _112) + 99.11000061035156f) * _112) + 0.24406300485134125f);
  } else {
    _129 = (((((1901800.0f - (_112 * 2006400000.0f)) * _112) + 247.47999572753906f) * _112) + 0.23703999817371368f);
  }
  float _143 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _150 = cb0_037y * cb0_037y;
  float _153 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_150 * 1.6145605741257896e-07f));
  float _158 = ((_143 * 2.0f) + 4.0f) - (_153 * 8.0f);
  float _159 = (_143 * 3.0f) / _158;
  float _161 = (_153 * 2.0f) / _158;
  bool _162 = (cb0_037y < 4000.0f);
  float _171 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _173 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_150 * 1.5317699909210205f)) / (_171 * _171);
  float _180 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _150;
  float _182 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_150 * 308.60699462890625f)) / (_180 * _180);
  float _184 = rsqrt(dot(float2(_173, _182), float2(_173, _182)));
  float _185 = cb0_037z * 0.05000000074505806f;
  float _188 = ((_185 * _182) * _184) + _143;
  float _191 = _153 - ((_185 * _173) * _184);
  float _196 = (4.0f - (_191 * 8.0f)) + (_188 * 2.0f);
  float _202 = (((_188 * 3.0f) / _196) - _159) + select(_162, _159, _129);
  float _203 = (((_191 * 2.0f) / _196) - _161) + select(_162, _161, (((_129 * 2.869999885559082f) + -0.2750000059604645f) - ((_129 * _129) * 3.0f)));
  float _204 = select(_110, _202, 0.3127000033855438f);
  float _205 = select(_110, _203, 0.32899999618530273f);
  float _206 = select(_110, 0.3127000033855438f, _202);
  float _207 = select(_110, 0.32899999618530273f, _203);
  float _208 = max(_205, 1.000000013351432e-10f);
  float _209 = _204 / _208;
  float _212 = ((1.0f - _204) - _205) / _208;
  float _213 = max(_207, 1.000000013351432e-10f);
  float _214 = _206 / _213;
  float _217 = ((1.0f - _206) - _207) / _213;
  float _236 = mad(-0.16140000522136688f, _217, ((_214 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _212, ((_209 * 0.8950999975204468f) + 0.266400009393692f));
  float _237 = mad(0.03669999912381172f, _217, (1.7135000228881836f - (_214 * 0.7501999735832214f))) / mad(0.03669999912381172f, _212, (1.7135000228881836f - (_209 * 0.7501999735832214f)));
  float _238 = mad(1.0296000242233276f, _217, ((_214 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _212, ((_209 * 0.03889999911189079f) + -0.06849999725818634f));
  float _239 = mad(_237, -0.7501999735832214f, 0.0f);
  float _240 = mad(_237, 1.7135000228881836f, 0.0f);
  float _241 = mad(_237, 0.03669999912381172f, -0.0f);
  float _242 = mad(_238, 0.03889999911189079f, 0.0f);
  float _243 = mad(_238, -0.06849999725818634f, 0.0f);
  float _244 = mad(_238, 1.0296000242233276f, 0.0f);
  float _247 = mad(0.1599626988172531f, _242, mad(-0.1470542997121811f, _239, (_236 * 0.883457362651825f)));
  float _250 = mad(0.1599626988172531f, _243, mad(-0.1470542997121811f, _240, (_236 * 0.26293492317199707f)));
  float _253 = mad(0.1599626988172531f, _244, mad(-0.1470542997121811f, _241, (_236 * -0.15930065512657166f)));
  float _256 = mad(0.04929120093584061f, _242, mad(0.5183603167533875f, _239, (_236 * 0.38695648312568665f)));
  float _259 = mad(0.04929120093584061f, _243, mad(0.5183603167533875f, _240, (_236 * 0.11516613513231277f)));
  float _262 = mad(0.04929120093584061f, _244, mad(0.5183603167533875f, _241, (_236 * -0.0697740763425827f)));
  float _265 = mad(0.9684867262840271f, _242, mad(0.04004279896616936f, _239, (_236 * -0.007634039502590895f)));
  float _268 = mad(0.9684867262840271f, _243, mad(0.04004279896616936f, _240, (_236 * -0.0022720457054674625f)));
  float _271 = mad(0.9684867262840271f, _244, mad(0.04004279896616936f, _241, (_236 * 0.0013765322510153055f)));
  float _274 = mad(_253, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_250, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_247 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _277 = mad(_253, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_250, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_247 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _280 = mad(_253, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_250, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_247 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _283 = mad(_262, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_259, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_256 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _286 = mad(_262, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_259, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_256 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _289 = mad(_262, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_259, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_256 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _292 = mad(_271, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_268, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_265 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _295 = mad(_271, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_268, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_265 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _298 = mad(_271, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_268, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_265 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  _336 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _298, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _289, (_280 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _74, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _295, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _286, (_277 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _73, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _292, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _283, (_274 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))) * _72)));
  _337 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _298, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _289, (_280 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _74, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _295, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _286, (_277 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _73, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _292, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _283, (_274 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))) * _72)));
  _338 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _298, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _289, (_280 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _74, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _295, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _286, (_277 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _73, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _292, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _283, (_274 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))) * _72)));
  float _353 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _338, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _337, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _336)));
  float _356 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _338, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _337, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _336)));
  float _359 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _338, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _337, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _336)));
  float _360 = dot(float3(_353, _356, _359), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _364 = (_353 / _360) + -1.0f;
  float _365 = (_356 / _360) + -1.0f;
  float _366 = (_359 / _360) + -1.0f;

  // float _378 = (1.0f - exp2(((_360 * _360) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_364, _365, _366), float3(_364, _365, _366)) * -4.0f));
  float _378 = (1.0f - exp2(((_360 * _360) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_364, _365, _366), float3(_364, _365, _366)) * -4.0f));

  float _394 = ((mad(-0.06368321925401688f, _359, mad(-0.3292922377586365f, _356, (_353 * 1.3704125881195068f))) - _353) * _378) + _353;
  float _395 = ((mad(-0.010861365124583244f, _359, mad(1.0970927476882935f, _356, (_353 * -0.08343357592821121f))) - _356) * _378) + _356;
  float _396 = ((mad(1.2036951780319214f, _359, mad(-0.09862580895423889f, _356, (_353 * -0.02579331398010254f))) - _359) * _378) + _359;
  float _397 = dot(float3(_394, _395, _396), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _411 = cb0_021w + cb0_026w;
  float _425 = cb0_020w * cb0_025w;
  float _439 = cb0_019w * cb0_024w;
  float _453 = cb0_018w * cb0_023w;
  float _467 = cb0_017w * cb0_022w;
  float _471 = _394 - _397;
  float _472 = _395 - _397;
  float _473 = _396 - _397;
  float _530 = saturate(_397 / cb0_037w);
  float _534 = (_530 * _530) * (3.0f - (_530 * 2.0f));
  float _535 = 1.0f - _534;
  float _544 = cb0_021w + cb0_036w;
  float _553 = cb0_020w * cb0_035w;
  float _562 = cb0_019w * cb0_034w;
  float _571 = cb0_018w * cb0_033w;
  float _580 = cb0_017w * cb0_032w;
  float _643 = saturate((_397 - cb0_038x) / (cb0_038y - cb0_038x));
  float _647 = (_643 * _643) * (3.0f - (_643 * 2.0f));
  float _656 = cb0_021w + cb0_031w;
  float _665 = cb0_020w * cb0_030w;
  float _674 = cb0_019w * cb0_029w;
  float _683 = cb0_018w * cb0_028w;
  float _692 = cb0_017w * cb0_027w;
  float _750 = _534 - _647;
  float _761 = ((_647 * (((cb0_021x + cb0_036x) + _544) + (((cb0_020x * cb0_035x) * _553) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _571) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _580) * _471) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _562)))))) + (_535 * (((cb0_021x + cb0_026x) + _411) + (((cb0_020x * cb0_025x) * _425) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _453) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _467) * _471) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _439))))))) + ((((cb0_021x + cb0_031x) + _656) + (((cb0_020x * cb0_030x) * _665) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _683) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _692) * _471) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _674))))) * _750);
  float _763 = ((_647 * (((cb0_021y + cb0_036y) + _544) + (((cb0_020y * cb0_035y) * _553) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _571) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _580) * _472) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _562)))))) + (_535 * (((cb0_021y + cb0_026y) + _411) + (((cb0_020y * cb0_025y) * _425) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _453) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _467) * _472) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _439))))))) + ((((cb0_021y + cb0_031y) + _656) + (((cb0_020y * cb0_030y) * _665) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _683) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _692) * _472) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _674))))) * _750);
  float _765 = ((_647 * (((cb0_021z + cb0_036z) + _544) + (((cb0_020z * cb0_035z) * _553) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _571) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _580) * _473) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _562)))))) + (_535 * (((cb0_021z + cb0_026z) + _411) + (((cb0_020z * cb0_025z) * _425) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _453) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _467) * _473) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _439))))))) + ((((cb0_021z + cb0_031z) + _656) + (((cb0_020z * cb0_030z) * _665) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _683) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _692) * _473) + _397)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _674))))) * _750);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_040x;
  cb_config.ue_filmtoe = cb0_039z;
  cb_config.ue_filmshoulder = cb0_039w;
  cb_config.ue_filmslope = cb0_039y;
  cb_config.ue_filmwhiteclip = cb0_040y;
  cb_config.ue_tonecurveammount = cb0_039x;
  cb_config.ue_mappingpolynomial = float3(cb0_041x, cb0_041y, cb0_041z);
  cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
  cb_config.ue_bluecorrection = cb0_038z;
  cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xy is used

  float4 output = ProcessLutbuilder(float3(_761, _763, _765), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _780 = ((mad(0.061360642313957214f, _765, mad(-4.540197551250458e-09f, _763, (_761 * 0.9386394023895264f))) - _761) * cb0_038z) + _761;
  float _781 = ((mad(0.169205904006958f, _765, mad(0.8307942152023315f, _763, (_761 * 6.775371730327606e-08f))) - _763) * cb0_038z) + _763;
  float _782 = (mad(-2.3283064365386963e-10f, _763, (_761 * -9.313225746154785e-10f)) * cb0_038z) + _765;
  float _785 = mad(0.16386905312538147f, _782, mad(0.14067868888378143f, _781, (_780 * 0.6954522132873535f)));
  float _788 = mad(0.0955343246459961f, _782, mad(0.8596711158752441f, _781, (_780 * 0.044794581830501556f)));
  float _791 = mad(1.0015007257461548f, _782, mad(0.004025210160762072f, _781, (_780 * -0.005525882821530104f)));
  float _795 = max(max(_785, _788), _791);
  float _800 = (max(_795, 1.000000013351432e-10f) - max(min(min(_785, _788), _791), 1.000000013351432e-10f)) / max(_795, 0.009999999776482582f);
  float _813 = ((_788 + _785) + _791) + (sqrt((((_791 - _788) * _791) + ((_788 - _785) * _788)) + ((_785 - _791) * _785)) * 1.75f);
  float _814 = _813 * 0.3333333432674408f;
  float _815 = _800 + -0.4000000059604645f;
  float _816 = _815 * 5.0f;
  float _820 = max((1.0f - abs(_815 * 2.5f)), 0.0f);
  float _831 = ((float(((int)(uint)((bool)(_816 > 0.0f))) - ((int)(uint)((bool)(_816 < 0.0f)))) * (1.0f - (_820 * _820))) + 1.0f) * 0.02500000037252903f;
  if (!(_814 <= 0.0533333346247673f)) {
    if (!(_814 >= 0.1599999964237213f)) {
      _840 = (((0.23999999463558197f / _813) + -0.5f) * _831);
    } else {
      _840 = 0.0f;
    }
  } else {
    _840 = _831;
  }
  float _841 = _840 + 1.0f;
  float _842 = _841 * _785;
  float _843 = _841 * _788;
  float _844 = _841 * _791;
  if (!((bool)(_842 == _843) && (bool)(_843 == _844))) {
    float _851 = ((_842 * 2.0f) - _843) - _844;
    float _854 = ((_788 - _791) * 1.7320507764816284f) * _841;
    float _856 = atan(_854 / _851);
    bool _859 = (_851 < 0.0f);
    bool _860 = (_851 == 0.0f);
    bool _861 = (_854 >= 0.0f);
    bool _862 = (_854 < 0.0f);
    _873 = select((_861 && _860), 90.0f, select((_862 && _860), -90.0f, (select((_862 && _859), (_856 + -3.1415927410125732f), select((_861 && _859), (_856 + 3.1415927410125732f), _856)) * 57.2957763671875f)));
  } else {
    _873 = 0.0f;
  }
  float _878 = min(max(select((_873 < 0.0f), (_873 + 360.0f), _873), 0.0f), 360.0f);
  if (_878 < -180.0f) {
    _887 = (_878 + 360.0f);
  } else {
    if (_878 > 180.0f) {
      _887 = (_878 + -360.0f);
    } else {
      _887 = _878;
    }
  }
  float _891 = saturate(1.0f - abs(_887 * 0.014814814552664757f));
  float _895 = (_891 * _891) * (3.0f - (_891 * 2.0f));
  float _901 = ((_895 * _895) * ((_800 * 0.18000000715255737f) * (0.029999999329447746f - _842))) + _842;
  float _911 = max(0.0f, mad(-0.21492856740951538f, _844, mad(-0.2365107536315918f, _843, (_901 * 1.4514392614364624f))));
  float _912 = max(0.0f, mad(-0.09967592358589172f, _844, mad(1.17622971534729f, _843, (_901 * -0.07655377686023712f))));
  float _913 = max(0.0f, mad(0.9977163076400757f, _844, mad(-0.006032449658960104f, _843, (_901 * 0.008316148072481155f))));
  float _914 = dot(float3(_911, _912, _913), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _929 = (cb0_040x + 1.0f) - cb0_039z;
  float _931 = cb0_040y + 1.0f;
  float _933 = _931 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _951 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    float _942 = (cb0_040x + 0.18000000715255737f) / _929;
    _951 = (-0.7447274923324585f - ((log2(_942 / (2.0f - _942)) * 0.3465735912322998f) * (_929 / cb0_039y)));
  }
  float _954 = ((1.0f - cb0_039z) / cb0_039y) - _951;
  float _956 = (cb0_039w / cb0_039y) - _954;
  float _960 = log2(lerp(_914, _911, 0.9599999785423279f)) * 0.3010300099849701f;
  float _961 = log2(lerp(_914, _912, 0.9599999785423279f)) * 0.3010300099849701f;
  float _962 = log2(lerp(_914, _913, 0.9599999785423279f)) * 0.3010300099849701f;
  float _966 = cb0_039y * (_960 + _954);
  float _967 = cb0_039y * (_961 + _954);
  float _968 = cb0_039y * (_962 + _954);
  float _969 = _929 * 2.0f;
  float _971 = (cb0_039y * -2.0f) / _929;
  float _972 = _960 - _951;
  float _973 = _961 - _951;
  float _974 = _962 - _951;
  float _993 = _933 * 2.0f;
  float _995 = (cb0_039y * 2.0f) / _933;
  float _1020 = select((_960 < _951), ((_969 / (exp2((_972 * 1.4426950216293335f) * _971) + 1.0f)) - cb0_040x), _966);
  float _1021 = select((_961 < _951), ((_969 / (exp2((_973 * 1.4426950216293335f) * _971) + 1.0f)) - cb0_040x), _967);
  float _1022 = select((_962 < _951), ((_969 / (exp2((_974 * 1.4426950216293335f) * _971) + 1.0f)) - cb0_040x), _968);
  float _1029 = _956 - _951;
  float _1033 = saturate(_972 / _1029);
  float _1034 = saturate(_973 / _1029);
  float _1035 = saturate(_974 / _1029);
  bool _1036 = (_956 < _951);
  float _1040 = select(_1036, (1.0f - _1033), _1033);
  float _1041 = select(_1036, (1.0f - _1034), _1034);
  float _1042 = select(_1036, (1.0f - _1035), _1035);
  float _1061 = (((_1040 * _1040) * (select((_960 > _956), (_931 - (_993 / (exp2(((_960 - _956) * 1.4426950216293335f) * _995) + 1.0f))), _966) - _1020)) * (3.0f - (_1040 * 2.0f))) + _1020;
  float _1062 = (((_1041 * _1041) * (select((_961 > _956), (_931 - (_993 / (exp2(((_961 - _956) * 1.4426950216293335f) * _995) + 1.0f))), _967) - _1021)) * (3.0f - (_1041 * 2.0f))) + _1021;
  float _1063 = (((_1042 * _1042) * (select((_962 > _956), (_931 - (_993 / (exp2(((_962 - _956) * 1.4426950216293335f) * _995) + 1.0f))), _968) - _1022)) * (3.0f - (_1042 * 2.0f))) + _1022;
  float _1064 = dot(float3(_1061, _1062, _1063), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1084 = (cb0_039x * (max(0.0f, (lerp(_1064, _1061, 0.9300000071525574f))) - _780)) + _780;
  float _1085 = (cb0_039x * (max(0.0f, (lerp(_1064, _1062, 0.9300000071525574f))) - _781)) + _781;
  float _1086 = (cb0_039x * (max(0.0f, (lerp(_1064, _1063, 0.9300000071525574f))) - _782)) + _782;
  float _1102 = ((mad(-0.06537103652954102f, _1086, mad(1.451815478503704e-06f, _1085, (_1084 * 1.065374732017517f))) - _1084) * cb0_038z) + _1084;
  float _1103 = ((mad(-0.20366770029067993f, _1086, mad(1.2036634683609009f, _1085, (_1084 * -2.57161445915699e-07f))) - _1085) * cb0_038z) + _1085;
  float _1104 = ((mad(0.9999996423721313f, _1086, mad(2.0954757928848267e-08f, _1085, (_1084 * 1.862645149230957e-08f))) - _1086) * cb0_038z) + _1086;
  float _1129 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1104, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1103, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1102)))));
  float _1130 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1104, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1103, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1102)))));
  float _1131 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1104, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1103, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1102)))));
  if (_1129 < 0.0031306699384003878f) {
    _1142 = (_1129 * 12.920000076293945f);
  } else {
    _1142 = (((pow(_1129, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1130 < 0.0031306699384003878f) {
    _1153 = (_1130 * 12.920000076293945f);
  } else {
    _1153 = (((pow(_1130, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1131 < 0.0031306699384003878f) {
    _1164 = (_1131 * 12.920000076293945f);
  } else {
    _1164 = (((pow(_1131, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1168 = (_1153 * 0.9375f) + 0.03125f;
  float _1175 = _1164 * 15.0f;
  float _1176 = floor(_1175);
  float _1177 = _1175 - _1176;
  float _1179 = (((_1142 * 0.9375f) + 0.03125f) + _1176) * 0.0625f;
  float4 _1182 = t0.SampleLevel(s0, float2(_1179, _1168), 0.0f);
  float4 _1187 = t0.SampleLevel(s0, float2((_1179 + 0.0625f), _1168), 0.0f);
  float _1203 = ((lerp(_1182.x, _1187.x, _1177)) * cb0_005y) + (cb0_005x * _1142);
  float _1204 = ((lerp(_1182.y, _1187.y, _1177)) * cb0_005y) + (cb0_005x * _1153);
  float _1205 = ((lerp(_1182.z, _1187.z, _1177)) * cb0_005y) + (cb0_005x * _1164);
  float _1230 = select((_1203 > 0.040449999272823334f), exp2(log2((abs(_1203) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1203 * 0.07739938050508499f));
  float _1231 = select((_1204 > 0.040449999272823334f), exp2(log2((abs(_1204) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1204 * 0.07739938050508499f));
  float _1232 = select((_1205 > 0.040449999272823334f), exp2(log2((abs(_1205) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1205 * 0.07739938050508499f));
  float _1258 = cb0_016x * (((cb0_041y + (cb0_041x * _1230)) * _1230) + cb0_041z);
  float _1259 = cb0_016y * (((cb0_041y + (cb0_041x * _1231)) * _1231) + cb0_041z);
  float _1260 = cb0_016z * (((cb0_041y + (cb0_041x * _1232)) * _1232) + cb0_041z);
  float _1281 = exp2(log2(max(0.0f, (lerp(_1258, cb0_015x, cb0_015w)))) * cb0_042y);
  float _1282 = exp2(log2(max(0.0f, (lerp(_1259, cb0_015y, cb0_015w)))) * cb0_042y);
  float _1283 = exp2(log2(max(0.0f, (lerp(_1260, cb0_015z, cb0_015w)))) * cb0_042y);
  if ((uint)(WorkingColorSpace_000.FWorkingColorSpaceConstants_384) == 0) {
    float _1290 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1283, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1282, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1281)));
    float _1293 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1283, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1282, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1281)));
    float _1296 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1283, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1282, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1281)));
    _1307 = mad(_53, _1296, mad(_52, _1293, (_1290 * _51)));
    _1308 = mad(_56, _1296, mad(_55, _1293, (_1290 * _54)));
    _1309 = mad(_59, _1296, mad(_58, _1293, (_1290 * _57)));
  } else {
    _1307 = _1281;
    _1308 = _1282;
    _1309 = _1283;
  }
  if (_1307 < 0.0031306699384003878f) {
    _1320 = (_1307 * 12.920000076293945f);
  } else {
    _1320 = (((pow(_1307, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1308 < 0.0031306699384003878f) {
    _1331 = (_1308 * 12.920000076293945f);
  } else {
    _1331 = (((pow(_1308, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1309 < 0.0031306699384003878f) {
    _1342 = (_1309 * 12.920000076293945f);
  } else {
    _1342 = (((pow(_1309, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1320 * 0.9523810148239136f), (_1331 * 0.9523810148239136f), (_1342 * 0.9523810148239136f), 0.0f);
}
