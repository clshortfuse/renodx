#include "../../common.hlsl"

struct FWorkingColorSpaceConstants {
  float4 FWorkingColorSpaceConstants_000[4];
  float4 FWorkingColorSpaceConstants_064[4];
  float4 FWorkingColorSpaceConstants_128[4];
  float4 FWorkingColorSpaceConstants_192[4];
  float4 FWorkingColorSpaceConstants_256[4];
  float4 FWorkingColorSpaceConstants_320[4];
  int FWorkingColorSpaceConstants_384;
};


RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
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
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
};

cbuffer cb1 : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace_000 : packoffset(c000.x);
};

[numthreads(4, 4, 4)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _20 = 0.5f / cb0_037x;
  float _25 = cb0_037x + -1.0f;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _127;
  float _334;
  float _335;
  float _336;
  float _838;
  float _871;
  float _885;
  float _949;
  float _1201;
  float _1202;
  float _1203;
  float _1214;
  float _1225;
  float _1236;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        bool _38 = (cb0_043x == 4);
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
  float _70 = (exp2((((cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _71 = (exp2((((cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _72 = (exp2(((float((uint)SV_DispatchThreadID.z) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _334 = _70;
      _335 = _71;
      _336 = _72;
      float _351 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _336, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _335, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _334)));
      float _354 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _336, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _335, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _334)));
      float _357 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _336, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _335, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _334)));
      SetUngradedAP1(float3(_351, _354, _357));
      float _358 = dot(float3(_351, _354, _357), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _362 = (_351 / _358) + -1.0f;
      float _363 = (_354 / _358) + -1.0f;
      float _364 = (_357 / _358) + -1.0f;
      float _376 = (1.0f - exp2(((_358 * _358) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_362, _363, _364), float3(_362, _363, _364)) * -4.0f));
      float _392 = ((mad(-0.06368321925401688f, _357, mad(-0.3292922377586365f, _354, (_351 * 1.3704125881195068f))) - _351) * _376) + _351;
      float _393 = ((mad(-0.010861365124583244f, _357, mad(1.0970927476882935f, _354, (_351 * -0.08343357592821121f))) - _354) * _376) + _354;
      float _394 = ((mad(1.2036951780319214f, _357, mad(-0.09862580895423889f, _354, (_351 * -0.02579331398010254f))) - _357) * _376) + _357;
      float _395 = dot(float3(_392, _393, _394), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _409 = cb0_021w + cb0_026w;
      float _423 = cb0_020w * cb0_025w;
      float _437 = cb0_019w * cb0_024w;
      float _451 = cb0_018w * cb0_023w;
      float _465 = cb0_017w * cb0_022w;
      float _469 = _392 - _395;
      float _470 = _393 - _395;
      float _471 = _394 - _395;
      float _528 = saturate(_395 / cb0_037w);
      float _532 = (_528 * _528) * (3.0f - (_528 * 2.0f));
      float _533 = 1.0f - _532;
      float _542 = cb0_021w + cb0_036w;
      float _551 = cb0_020w * cb0_035w;
      float _560 = cb0_019w * cb0_034w;
      float _569 = cb0_018w * cb0_033w;
      float _578 = cb0_017w * cb0_032w;
      float _641 = saturate((_395 - cb0_038x) / (cb0_038y - cb0_038x));
      float _645 = (_641 * _641) * (3.0f - (_641 * 2.0f));
      float _654 = cb0_021w + cb0_031w;
      float _663 = cb0_020w * cb0_030w;
      float _672 = cb0_019w * cb0_029w;
      float _681 = cb0_018w * cb0_028w;
      float _690 = cb0_017w * cb0_027w;
      float _748 = _532 - _645;
      float _759 = ((_645 * (((cb0_021x + cb0_036x) + _542) + (((cb0_020x * cb0_035x) * _551) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _569) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _578) * _469) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _560)))))) + (_533 * (((cb0_021x + cb0_026x) + _409) + (((cb0_020x * cb0_025x) * _423) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _451) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _465) * _469) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _437))))))) + ((((cb0_021x + cb0_031x) + _654) + (((cb0_020x * cb0_030x) * _663) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _681) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _690) * _469) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _672))))) * _748);
      float _761 = ((_645 * (((cb0_021y + cb0_036y) + _542) + (((cb0_020y * cb0_035y) * _551) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _569) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _578) * _470) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _560)))))) + (_533 * (((cb0_021y + cb0_026y) + _409) + (((cb0_020y * cb0_025y) * _423) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _451) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _465) * _470) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _437))))))) + ((((cb0_021y + cb0_031y) + _654) + (((cb0_020y * cb0_030y) * _663) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _681) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _690) * _470) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _672))))) * _748);
      float _763 = ((_645 * (((cb0_021z + cb0_036z) + _542) + (((cb0_020z * cb0_035z) * _551) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _569) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _578) * _471) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _560)))))) + (_533 * (((cb0_021z + cb0_026z) + _409) + (((cb0_020z * cb0_025z) * _423) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _451) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _465) * _471) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _437))))))) + ((((cb0_021z + cb0_031z) + _654) + (((cb0_020z * cb0_030z) * _663) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _681) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _690) * _471) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _672))))) * _748);
      SetUntonemappedAP1(float3(_759, _761, _763));
      float _778 = ((mad(0.061360642313957214f, _763, mad(-4.540197551250458e-09f, _761, (_759 * 0.9386394023895264f))) - _759) * cb0_038z) + _759;
      float _779 = ((mad(0.169205904006958f, _763, mad(0.8307942152023315f, _761, (_759 * 6.775371730327606e-08f))) - _761) * cb0_038z) + _761;
      float _780 = (mad(-2.3283064365386963e-10f, _761, (_759 * -9.313225746154785e-10f)) * cb0_038z) + _763;
      float _783 = mad(0.16386905312538147f, _780, mad(0.14067868888378143f, _779, (_778 * 0.6954522132873535f)));
      float _786 = mad(0.0955343246459961f, _780, mad(0.8596711158752441f, _779, (_778 * 0.044794581830501556f)));
      float _789 = mad(1.0015007257461548f, _780, mad(0.004025210160762072f, _779, (_778 * -0.005525882821530104f)));
      float _793 = max(max(_783, _786), _789);
      float _798 = (max(_793, 1.000000013351432e-10f) - max(min(min(_783, _786), _789), 1.000000013351432e-10f)) / max(_793, 0.009999999776482582f);
      float _811 = ((_786 + _783) + _789) + (sqrt((((_789 - _786) * _789) + ((_786 - _783) * _786)) + ((_783 - _789) * _783)) * 1.75f);
      float _812 = _811 * 0.3333333432674408f;
      float _813 = _798 + -0.4000000059604645f;
      float _814 = _813 * 5.0f;
      float _818 = max((1.0f - abs(_813 * 2.5f)), 0.0f);
      float _829 = ((float((int)(((int)(uint)((bool)(_814 > 0.0f))) - ((int)(uint)((bool)(_814 < 0.0f))))) * (1.0f - (_818 * _818))) + 1.0f) * 0.02500000037252903f;
      do {
        if (!(_812 <= 0.0533333346247673f)) {
          if (!(_812 >= 0.1599999964237213f)) {
            _838 = (((0.23999999463558197f / _811) + -0.5f) * _829);
          } else {
            _838 = 0.0f;
          }
        } else {
          _838 = _829;
        }
        float _839 = _838 + 1.0f;
        float _840 = _839 * _783;
        float _841 = _839 * _786;
        float _842 = _839 * _789;
        do {
          if (!((bool)(_840 == _841) && (bool)(_841 == _842))) {
            float _849 = ((_840 * 2.0f) - _841) - _842;
            float _852 = ((_786 - _789) * 1.7320507764816284f) * _839;
            float _854 = atan(_852 / _849);
            bool _857 = (_849 < 0.0f);
            bool _858 = (_849 == 0.0f);
            bool _859 = (_852 >= 0.0f);
            bool _860 = (_852 < 0.0f);
            _871 = select((_859 && _858), 90.0f, select((_860 && _858), -90.0f, (select((_860 && _857), (_854 + -3.1415927410125732f), select((_859 && _857), (_854 + 3.1415927410125732f), _854)) * 57.2957763671875f)));
          } else {
            _871 = 0.0f;
          }
          float _876 = min(max(select((_871 < 0.0f), (_871 + 360.0f), _871), 0.0f), 360.0f);
          do {
            if (_876 < -180.0f) {
              _885 = (_876 + 360.0f);
            } else {
              if (_876 > 180.0f) {
                _885 = (_876 + -360.0f);
              } else {
                _885 = _876;
              }
            }
            float _889 = saturate(1.0f - abs(_885 * 0.014814814552664757f));
            float _893 = (_889 * _889) * (3.0f - (_889 * 2.0f));
            float _899 = ((_893 * _893) * ((_798 * 0.18000000715255737f) * (0.029999999329447746f - _840))) + _840;
            float _909 = max(0.0f, mad(-0.21492856740951538f, _842, mad(-0.2365107536315918f, _841, (_899 * 1.4514392614364624f))));
            float _910 = max(0.0f, mad(-0.09967592358589172f, _842, mad(1.17622971534729f, _841, (_899 * -0.07655377686023712f))));
            float _911 = max(0.0f, mad(0.9977163076400757f, _842, mad(-0.006032449658960104f, _841, (_899 * 0.008316148072481155f))));
            float _912 = dot(float3(_909, _910, _911), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _927 = (cb0_040x + 1.0f) - cb0_039z;
            float _929 = cb0_040y + 1.0f;
            float _931 = _929 - cb0_039w;
            do {
              if (cb0_039z > 0.800000011920929f) {
                _949 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
              } else {
                float _940 = (cb0_040x + 0.18000000715255737f) / _927;
                _949 = (-0.7447274923324585f - ((log2(_940 / (2.0f - _940)) * 0.3465735912322998f) * (_927 / cb0_039y)));
              }
              float _952 = ((1.0f - cb0_039z) / cb0_039y) - _949;
              float _954 = (cb0_039w / cb0_039y) - _952;
              float _958 = log2(lerp(_912, _909, 0.9599999785423279f)) * 0.3010300099849701f;
              float _959 = log2(lerp(_912, _910, 0.9599999785423279f)) * 0.3010300099849701f;
              float _960 = log2(lerp(_912, _911, 0.9599999785423279f)) * 0.3010300099849701f;
              float _964 = cb0_039y * (_958 + _952);
              float _965 = cb0_039y * (_959 + _952);
              float _966 = cb0_039y * (_960 + _952);
              float _967 = _927 * 2.0f;
              float _969 = (cb0_039y * -2.0f) / _927;
              float _970 = _958 - _949;
              float _971 = _959 - _949;
              float _972 = _960 - _949;
              float _991 = _931 * 2.0f;
              float _993 = (cb0_039y * 2.0f) / _931;
              float _1018 = select((_958 < _949), ((_967 / (exp2((_970 * 1.4426950216293335f) * _969) + 1.0f)) - cb0_040x), _964);
              float _1019 = select((_959 < _949), ((_967 / (exp2((_971 * 1.4426950216293335f) * _969) + 1.0f)) - cb0_040x), _965);
              float _1020 = select((_960 < _949), ((_967 / (exp2((_972 * 1.4426950216293335f) * _969) + 1.0f)) - cb0_040x), _966);
              float _1027 = _954 - _949;
              float _1031 = saturate(_970 / _1027);
              float _1032 = saturate(_971 / _1027);
              float _1033 = saturate(_972 / _1027);
              bool _1034 = (_954 < _949);
              float _1038 = select(_1034, (1.0f - _1031), _1031);
              float _1039 = select(_1034, (1.0f - _1032), _1032);
              float _1040 = select(_1034, (1.0f - _1033), _1033);
              float _1059 = (((_1038 * _1038) * (select((_958 > _954), (_929 - (_991 / (exp2(((_958 - _954) * 1.4426950216293335f) * _993) + 1.0f))), _964) - _1018)) * (3.0f - (_1038 * 2.0f))) + _1018;
              float _1060 = (((_1039 * _1039) * (select((_959 > _954), (_929 - (_991 / (exp2(((_959 - _954) * 1.4426950216293335f) * _993) + 1.0f))), _965) - _1019)) * (3.0f - (_1039 * 2.0f))) + _1019;
              float _1061 = (((_1040 * _1040) * (select((_960 > _954), (_929 - (_991 / (exp2(((_960 - _954) * 1.4426950216293335f) * _993) + 1.0f))), _966) - _1020)) * (3.0f - (_1040 * 2.0f))) + _1020;
              float _1062 = dot(float3(_1059, _1060, _1061), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _1082 = (cb0_039x * (max(0.0f, (lerp(_1062, _1059, 0.9300000071525574f))) - _778)) + _778;
              float _1083 = (cb0_039x * (max(0.0f, (lerp(_1062, _1060, 0.9300000071525574f))) - _779)) + _779;
              float _1084 = (cb0_039x * (max(0.0f, (lerp(_1062, _1061, 0.9300000071525574f))) - _780)) + _780;
              float _1100 = ((mad(-0.06537103652954102f, _1084, mad(1.451815478503704e-06f, _1083, (_1082 * 1.065374732017517f))) - _1082) * cb0_038z) + _1082;
              float _1101 = ((mad(-0.20366770029067993f, _1084, mad(1.2036634683609009f, _1083, (_1082 * -2.57161445915699e-07f))) - _1083) * cb0_038z) + _1083;
              float _1102 = ((mad(0.9999996423721313f, _1084, mad(2.0954757928848267e-08f, _1083, (_1082 * 1.862645149230957e-08f))) - _1084) * cb0_038z) + _1084;
              SetTonemappedAP1(_1100, _1101, _1102);
              float _1124 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1102, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1101, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1100))));
              float _1125 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1102, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1101, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1100))));
              float _1126 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1102, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1101, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1100))));
              float _1152 = cb0_016x * (((cb0_041y + (cb0_041x * _1124)) * _1124) + cb0_041z);
              float _1153 = cb0_016y * (((cb0_041y + (cb0_041x * _1125)) * _1125) + cb0_041z);
              float _1154 = cb0_016z * (((cb0_041y + (cb0_041x * _1126)) * _1126) + cb0_041z);
              float _1175 = exp2(log2(max(0.0f, (lerp(_1152, cb0_015x, cb0_015w)))) * cb0_042y);
              float _1176 = exp2(log2(max(0.0f, (lerp(_1153, cb0_015y, cb0_015w)))) * cb0_042y);
              float _1177 = exp2(log2(max(0.0f, (lerp(_1154, cb0_015z, cb0_015w)))) * cb0_042y);
              if (RENODX_TONE_MAP_TYPE != 0) {
                u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = GenerateOutput(float3(_1175, _1176, _1177), cb0_040w);
                return;
              }
              do {
                if (WorkingColorSpace_000.FWorkingColorSpaceConstants_384 == 0) {
                  float _1184 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1177, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1176, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1175)));
                  float _1187 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1177, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1176, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1175)));
                  float _1190 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1177, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1176, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1175)));
                  _1201 = mad(_51, _1190, mad(_50, _1187, (_1184 * _49)));
                  _1202 = mad(_54, _1190, mad(_53, _1187, (_1184 * _52)));
                  _1203 = mad(_57, _1190, mad(_56, _1187, (_1184 * _55)));
                } else {
                  _1201 = _1175;
                  _1202 = _1176;
                  _1203 = _1177;
                }
                do {
                  if (_1201 < 0.0031306699384003878f) {
                    _1214 = (_1201 * 12.920000076293945f);
                  } else {
                    _1214 = (((pow(_1201, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    if (_1202 < 0.0031306699384003878f) {
                      _1225 = (_1202 * 12.920000076293945f);
                    } else {
                      _1225 = (((pow(_1202, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    do {
                      if (_1203 < 0.0031306699384003878f) {
                        _1236 = (_1203 * 12.920000076293945f);
                      } else {
                        _1236 = (((pow(_1203, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = saturate(float4((_1214 * 0.9523810148239136f), (_1225 * 0.9523810148239136f), (_1236 * 0.9523810148239136f), 0.0f));
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
  bool _108 = (cb0_040w != 0);
  float _110 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _127 = (((((2967800.0f - (_110 * 4607000064.0f)) * _110) + 99.11000061035156f) * _110) + 0.24406300485134125f);
  } else {
    _127 = (((((1901800.0f - (_110 * 2006400000.0f)) * _110) + 247.47999572753906f) * _110) + 0.23703999817371368f);
  }
  float _141 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _148 = cb0_037y * cb0_037y;
  float _151 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_148 * 1.6145605741257896e-07f));
  float _156 = ((_141 * 2.0f) + 4.0f) - (_151 * 8.0f);
  float _157 = (_141 * 3.0f) / _156;
  float _159 = (_151 * 2.0f) / _156;
  bool _160 = (cb0_037y < 4000.0f);
  float _169 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _171 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_148 * 1.5317699909210205f)) / (_169 * _169);
  float _178 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _148;
  float _180 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_148 * 308.60699462890625f)) / (_178 * _178);
  float _182 = rsqrt(dot(float2(_171, _180), float2(_171, _180)));
  float _183 = cb0_037z * 0.05000000074505806f;
  float _186 = ((_183 * _180) * _182) + _141;
  float _189 = _151 - ((_183 * _171) * _182);
  float _194 = (4.0f - (_189 * 8.0f)) + (_186 * 2.0f);
  float _200 = (((_186 * 3.0f) / _194) - _157) + select(_160, _157, _127);
  float _201 = (((_189 * 2.0f) / _194) - _159) + select(_160, _159, (((_127 * 2.869999885559082f) + -0.2750000059604645f) - ((_127 * _127) * 3.0f)));
  float _202 = select(_108, _200, 0.3127000033855438f);
  float _203 = select(_108, _201, 0.32899999618530273f);
  float _204 = select(_108, 0.3127000033855438f, _200);
  float _205 = select(_108, 0.32899999618530273f, _201);
  float _206 = max(_203, 1.000000013351432e-10f);
  float _207 = _202 / _206;
  float _210 = ((1.0f - _202) - _203) / _206;
  float _211 = max(_205, 1.000000013351432e-10f);
  float _212 = _204 / _211;
  float _215 = ((1.0f - _204) - _205) / _211;
  float _234 = mad(-0.16140000522136688f, _215, ((_212 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _210, ((_207 * 0.8950999975204468f) + 0.266400009393692f));
  float _235 = mad(0.03669999912381172f, _215, (1.7135000228881836f - (_212 * 0.7501999735832214f))) / mad(0.03669999912381172f, _210, (1.7135000228881836f - (_207 * 0.7501999735832214f)));
  float _236 = mad(1.0296000242233276f, _215, ((_212 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _210, ((_207 * 0.03889999911189079f) + -0.06849999725818634f));
  float _237 = mad(_235, -0.7501999735832214f, 0.0f);
  float _238 = mad(_235, 1.7135000228881836f, 0.0f);
  float _239 = mad(_235, 0.03669999912381172f, -0.0f);
  float _240 = mad(_236, 0.03889999911189079f, 0.0f);
  float _241 = mad(_236, -0.06849999725818634f, 0.0f);
  float _242 = mad(_236, 1.0296000242233276f, 0.0f);
  float _245 = mad(0.1599626988172531f, _240, mad(-0.1470542997121811f, _237, (_234 * 0.883457362651825f)));
  float _248 = mad(0.1599626988172531f, _241, mad(-0.1470542997121811f, _238, (_234 * 0.26293492317199707f)));
  float _251 = mad(0.1599626988172531f, _242, mad(-0.1470542997121811f, _239, (_234 * -0.15930065512657166f)));
  float _254 = mad(0.04929120093584061f, _240, mad(0.5183603167533875f, _237, (_234 * 0.38695648312568665f)));
  float _257 = mad(0.04929120093584061f, _241, mad(0.5183603167533875f, _238, (_234 * 0.11516613513231277f)));
  float _260 = mad(0.04929120093584061f, _242, mad(0.5183603167533875f, _239, (_234 * -0.0697740763425827f)));
  float _263 = mad(0.9684867262840271f, _240, mad(0.04004279896616936f, _237, (_234 * -0.007634039502590895f)));
  float _266 = mad(0.9684867262840271f, _241, mad(0.04004279896616936f, _238, (_234 * -0.0022720457054674625f)));
  float _269 = mad(0.9684867262840271f, _242, mad(0.04004279896616936f, _239, (_234 * 0.0013765322510153055f)));
  float _272 = mad(_251, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_248, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_245 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _275 = mad(_251, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_248, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_245 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _278 = mad(_251, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_248, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_245 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _281 = mad(_260, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_257, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_254 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _284 = mad(_260, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_257, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_254 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _287 = mad(_260, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_257, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_254 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _290 = mad(_269, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_266, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_263 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _293 = mad(_269, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_266, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_263 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _296 = mad(_269, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_266, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_263 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  _334 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _296, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _287, (_278 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _72, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _293, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _284, (_275 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _71, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _290, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _281, (_272 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))) * _70)));
  _335 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _296, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _287, (_278 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _72, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _293, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _284, (_275 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _71, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _290, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _281, (_272 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))) * _70)));
  _336 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _296, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _287, (_278 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _72, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _293, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _284, (_275 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _71, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _290, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _281, (_272 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))) * _70)));
  float _351 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _336, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _335, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _334)));
  float _354 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _336, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _335, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _334)));
  float _357 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _336, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _335, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _334)));
  SetUngradedAP1(float3(_351, _354, _357));
  float _358 = dot(float3(_351, _354, _357), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _362 = (_351 / _358) + -1.0f;
  float _363 = (_354 / _358) + -1.0f;
  float _364 = (_357 / _358) + -1.0f;
  float _376 = (1.0f - exp2(((_358 * _358) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_362, _363, _364), float3(_362, _363, _364)) * -4.0f));
  float _392 = ((mad(-0.06368321925401688f, _357, mad(-0.3292922377586365f, _354, (_351 * 1.3704125881195068f))) - _351) * _376) + _351;
  float _393 = ((mad(-0.010861365124583244f, _357, mad(1.0970927476882935f, _354, (_351 * -0.08343357592821121f))) - _354) * _376) + _354;
  float _394 = ((mad(1.2036951780319214f, _357, mad(-0.09862580895423889f, _354, (_351 * -0.02579331398010254f))) - _357) * _376) + _357;
  float _395 = dot(float3(_392, _393, _394), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _409 = cb0_021w + cb0_026w;
  float _423 = cb0_020w * cb0_025w;
  float _437 = cb0_019w * cb0_024w;
  float _451 = cb0_018w * cb0_023w;
  float _465 = cb0_017w * cb0_022w;
  float _469 = _392 - _395;
  float _470 = _393 - _395;
  float _471 = _394 - _395;
  float _528 = saturate(_395 / cb0_037w);
  float _532 = (_528 * _528) * (3.0f - (_528 * 2.0f));
  float _533 = 1.0f - _532;
  float _542 = cb0_021w + cb0_036w;
  float _551 = cb0_020w * cb0_035w;
  float _560 = cb0_019w * cb0_034w;
  float _569 = cb0_018w * cb0_033w;
  float _578 = cb0_017w * cb0_032w;
  float _641 = saturate((_395 - cb0_038x) / (cb0_038y - cb0_038x));
  float _645 = (_641 * _641) * (3.0f - (_641 * 2.0f));
  float _654 = cb0_021w + cb0_031w;
  float _663 = cb0_020w * cb0_030w;
  float _672 = cb0_019w * cb0_029w;
  float _681 = cb0_018w * cb0_028w;
  float _690 = cb0_017w * cb0_027w;
  float _748 = _532 - _645;
  float _759 = ((_645 * (((cb0_021x + cb0_036x) + _542) + (((cb0_020x * cb0_035x) * _551) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _569) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _578) * _469) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _560)))))) + (_533 * (((cb0_021x + cb0_026x) + _409) + (((cb0_020x * cb0_025x) * _423) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _451) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _465) * _469) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _437))))))) + ((((cb0_021x + cb0_031x) + _654) + (((cb0_020x * cb0_030x) * _663) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _681) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _690) * _469) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _672))))) * _748);
  float _761 = ((_645 * (((cb0_021y + cb0_036y) + _542) + (((cb0_020y * cb0_035y) * _551) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _569) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _578) * _470) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _560)))))) + (_533 * (((cb0_021y + cb0_026y) + _409) + (((cb0_020y * cb0_025y) * _423) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _451) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _465) * _470) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _437))))))) + ((((cb0_021y + cb0_031y) + _654) + (((cb0_020y * cb0_030y) * _663) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _681) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _690) * _470) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _672))))) * _748);
  float _763 = ((_645 * (((cb0_021z + cb0_036z) + _542) + (((cb0_020z * cb0_035z) * _551) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _569) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _578) * _471) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _560)))))) + (_533 * (((cb0_021z + cb0_026z) + _409) + (((cb0_020z * cb0_025z) * _423) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _451) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _465) * _471) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _437))))))) + ((((cb0_021z + cb0_031z) + _654) + (((cb0_020z * cb0_030z) * _663) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _681) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _690) * _471) + _395)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _672))))) * _748);
  SetUntonemappedAP1(float3(_759, _761, _763));
  float _778 = ((mad(0.061360642313957214f, _763, mad(-4.540197551250458e-09f, _761, (_759 * 0.9386394023895264f))) - _759) * cb0_038z) + _759;
  float _779 = ((mad(0.169205904006958f, _763, mad(0.8307942152023315f, _761, (_759 * 6.775371730327606e-08f))) - _761) * cb0_038z) + _761;
  float _780 = (mad(-2.3283064365386963e-10f, _761, (_759 * -9.313225746154785e-10f)) * cb0_038z) + _763;
  float _783 = mad(0.16386905312538147f, _780, mad(0.14067868888378143f, _779, (_778 * 0.6954522132873535f)));
  float _786 = mad(0.0955343246459961f, _780, mad(0.8596711158752441f, _779, (_778 * 0.044794581830501556f)));
  float _789 = mad(1.0015007257461548f, _780, mad(0.004025210160762072f, _779, (_778 * -0.005525882821530104f)));
  float _793 = max(max(_783, _786), _789);
  float _798 = (max(_793, 1.000000013351432e-10f) - max(min(min(_783, _786), _789), 1.000000013351432e-10f)) / max(_793, 0.009999999776482582f);
  float _811 = ((_786 + _783) + _789) + (sqrt((((_789 - _786) * _789) + ((_786 - _783) * _786)) + ((_783 - _789) * _783)) * 1.75f);
  float _812 = _811 * 0.3333333432674408f;
  float _813 = _798 + -0.4000000059604645f;
  float _814 = _813 * 5.0f;
  float _818 = max((1.0f - abs(_813 * 2.5f)), 0.0f);
  float _829 = ((float((int)(((int)(uint)((bool)(_814 > 0.0f))) - ((int)(uint)((bool)(_814 < 0.0f))))) * (1.0f - (_818 * _818))) + 1.0f) * 0.02500000037252903f;
  if (!(_812 <= 0.0533333346247673f)) {
    if (!(_812 >= 0.1599999964237213f)) {
      _838 = (((0.23999999463558197f / _811) + -0.5f) * _829);
    } else {
      _838 = 0.0f;
    }
  } else {
    _838 = _829;
  }
  float _839 = _838 + 1.0f;
  float _840 = _839 * _783;
  float _841 = _839 * _786;
  float _842 = _839 * _789;
  if (!((bool)(_840 == _841) && (bool)(_841 == _842))) {
    float _849 = ((_840 * 2.0f) - _841) - _842;
    float _852 = ((_786 - _789) * 1.7320507764816284f) * _839;
    float _854 = atan(_852 / _849);
    bool _857 = (_849 < 0.0f);
    bool _858 = (_849 == 0.0f);
    bool _859 = (_852 >= 0.0f);
    bool _860 = (_852 < 0.0f);
    _871 = select((_859 && _858), 90.0f, select((_860 && _858), -90.0f, (select((_860 && _857), (_854 + -3.1415927410125732f), select((_859 && _857), (_854 + 3.1415927410125732f), _854)) * 57.2957763671875f)));
  } else {
    _871 = 0.0f;
  }
  float _876 = min(max(select((_871 < 0.0f), (_871 + 360.0f), _871), 0.0f), 360.0f);
  if (_876 < -180.0f) {
    _885 = (_876 + 360.0f);
  } else {
    if (_876 > 180.0f) {
      _885 = (_876 + -360.0f);
    } else {
      _885 = _876;
    }
  }
  float _889 = saturate(1.0f - abs(_885 * 0.014814814552664757f));
  float _893 = (_889 * _889) * (3.0f - (_889 * 2.0f));
  float _899 = ((_893 * _893) * ((_798 * 0.18000000715255737f) * (0.029999999329447746f - _840))) + _840;
  float _909 = max(0.0f, mad(-0.21492856740951538f, _842, mad(-0.2365107536315918f, _841, (_899 * 1.4514392614364624f))));
  float _910 = max(0.0f, mad(-0.09967592358589172f, _842, mad(1.17622971534729f, _841, (_899 * -0.07655377686023712f))));
  float _911 = max(0.0f, mad(0.9977163076400757f, _842, mad(-0.006032449658960104f, _841, (_899 * 0.008316148072481155f))));
  float _912 = dot(float3(_909, _910, _911), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _927 = (cb0_040x + 1.0f) - cb0_039z;
  float _929 = cb0_040y + 1.0f;
  float _931 = _929 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _949 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    float _940 = (cb0_040x + 0.18000000715255737f) / _927;
    _949 = (-0.7447274923324585f - ((log2(_940 / (2.0f - _940)) * 0.3465735912322998f) * (_927 / cb0_039y)));
  }
  float _952 = ((1.0f - cb0_039z) / cb0_039y) - _949;
  float _954 = (cb0_039w / cb0_039y) - _952;
  float _958 = log2(lerp(_912, _909, 0.9599999785423279f)) * 0.3010300099849701f;
  float _959 = log2(lerp(_912, _910, 0.9599999785423279f)) * 0.3010300099849701f;
  float _960 = log2(lerp(_912, _911, 0.9599999785423279f)) * 0.3010300099849701f;
  float _964 = cb0_039y * (_958 + _952);
  float _965 = cb0_039y * (_959 + _952);
  float _966 = cb0_039y * (_960 + _952);
  float _967 = _927 * 2.0f;
  float _969 = (cb0_039y * -2.0f) / _927;
  float _970 = _958 - _949;
  float _971 = _959 - _949;
  float _972 = _960 - _949;
  float _991 = _931 * 2.0f;
  float _993 = (cb0_039y * 2.0f) / _931;
  float _1018 = select((_958 < _949), ((_967 / (exp2((_970 * 1.4426950216293335f) * _969) + 1.0f)) - cb0_040x), _964);
  float _1019 = select((_959 < _949), ((_967 / (exp2((_971 * 1.4426950216293335f) * _969) + 1.0f)) - cb0_040x), _965);
  float _1020 = select((_960 < _949), ((_967 / (exp2((_972 * 1.4426950216293335f) * _969) + 1.0f)) - cb0_040x), _966);
  float _1027 = _954 - _949;
  float _1031 = saturate(_970 / _1027);
  float _1032 = saturate(_971 / _1027);
  float _1033 = saturate(_972 / _1027);
  bool _1034 = (_954 < _949);
  float _1038 = select(_1034, (1.0f - _1031), _1031);
  float _1039 = select(_1034, (1.0f - _1032), _1032);
  float _1040 = select(_1034, (1.0f - _1033), _1033);
  float _1059 = (((_1038 * _1038) * (select((_958 > _954), (_929 - (_991 / (exp2(((_958 - _954) * 1.4426950216293335f) * _993) + 1.0f))), _964) - _1018)) * (3.0f - (_1038 * 2.0f))) + _1018;
  float _1060 = (((_1039 * _1039) * (select((_959 > _954), (_929 - (_991 / (exp2(((_959 - _954) * 1.4426950216293335f) * _993) + 1.0f))), _965) - _1019)) * (3.0f - (_1039 * 2.0f))) + _1019;
  float _1061 = (((_1040 * _1040) * (select((_960 > _954), (_929 - (_991 / (exp2(((_960 - _954) * 1.4426950216293335f) * _993) + 1.0f))), _966) - _1020)) * (3.0f - (_1040 * 2.0f))) + _1020;
  float _1062 = dot(float3(_1059, _1060, _1061), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1082 = (cb0_039x * (max(0.0f, (lerp(_1062, _1059, 0.9300000071525574f))) - _778)) + _778;
  float _1083 = (cb0_039x * (max(0.0f, (lerp(_1062, _1060, 0.9300000071525574f))) - _779)) + _779;
  float _1084 = (cb0_039x * (max(0.0f, (lerp(_1062, _1061, 0.9300000071525574f))) - _780)) + _780;
  float _1100 = ((mad(-0.06537103652954102f, _1084, mad(1.451815478503704e-06f, _1083, (_1082 * 1.065374732017517f))) - _1082) * cb0_038z) + _1082;
  float _1101 = ((mad(-0.20366770029067993f, _1084, mad(1.2036634683609009f, _1083, (_1082 * -2.57161445915699e-07f))) - _1083) * cb0_038z) + _1083;
  float _1102 = ((mad(0.9999996423721313f, _1084, mad(2.0954757928848267e-08f, _1083, (_1082 * 1.862645149230957e-08f))) - _1084) * cb0_038z) + _1084;
  SetTonemappedAP1(_1100, _1101, _1102);
  float _1124 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1102, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1101, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1100))));
  float _1125 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1102, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1101, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1100))));
  float _1126 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1102, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1101, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1100))));
  float _1152 = cb0_016x * (((cb0_041y + (cb0_041x * _1124)) * _1124) + cb0_041z);
  float _1153 = cb0_016y * (((cb0_041y + (cb0_041x * _1125)) * _1125) + cb0_041z);
  float _1154 = cb0_016z * (((cb0_041y + (cb0_041x * _1126)) * _1126) + cb0_041z);
  float _1175 = exp2(log2(max(0.0f, (lerp(_1152, cb0_015x, cb0_015w)))) * cb0_042y);
  float _1176 = exp2(log2(max(0.0f, (lerp(_1153, cb0_015y, cb0_015w)))) * cb0_042y);
  float _1177 = exp2(log2(max(0.0f, (lerp(_1154, cb0_015z, cb0_015w)))) * cb0_042y);
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = GenerateOutput(float3(_1175, _1176, _1177), cb0_040w);
    return;
  }
  if (WorkingColorSpace_000.FWorkingColorSpaceConstants_384 == 0) {
    float _1184 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1177, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1176, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1175)));
    float _1187 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1177, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1176, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1175)));
    float _1190 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1177, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1176, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1175)));
    _1201 = mad(_51, _1190, mad(_50, _1187, (_1184 * _49)));
    _1202 = mad(_54, _1190, mad(_53, _1187, (_1184 * _52)));
    _1203 = mad(_57, _1190, mad(_56, _1187, (_1184 * _55)));
  } else {
    _1201 = _1175;
    _1202 = _1176;
    _1203 = _1177;
  }
  if (_1201 < 0.0031306699384003878f) {
    _1214 = (_1201 * 12.920000076293945f);
  } else {
    _1214 = (((pow(_1201, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1202 < 0.0031306699384003878f) {
    _1225 = (_1202 * 12.920000076293945f);
  } else {
    _1225 = (((pow(_1202, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1203 < 0.0031306699384003878f) {
    _1236 = (_1203 * 12.920000076293945f);
  } else {
    _1236 = (((pow(_1203, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = saturate(float4((_1214 * 0.9523810148239136f), (_1225 * 0.9523810148239136f), (_1236 * 0.9523810148239136f), 0.0f));
}
