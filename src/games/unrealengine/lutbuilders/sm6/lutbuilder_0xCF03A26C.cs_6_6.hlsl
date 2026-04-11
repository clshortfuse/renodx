// Found in Samson
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
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
};

cbuffer cb1 : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace_000 : packoffset(c000.x);
};

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
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
  float _32 = 0.5f / cb0_037x;
  float _37 = cb0_037x + -1.0f;
  float _38 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _32)) / _37;
  float _39 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _32)) / _37;
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
  float _184;
  float _391;
  float _392;
  float _393;
  float _916;
  float _949;
  float _963;
  float _1027;
  float _1295;
  float _1296;
  float _1297;
  float _1308;
  float _1319;
  float _1482;
  float _1497;
  float _1512;
  float _1520;
  float _1521;
  float _1522;
  float _1589;
  float _1622;
  float _1636;
  float _1675;
  float _1797;
  float _1877;
  float _1963;
  float _2168;
  float _2183;
  float _2198;
  float _2206;
  float _2207;
  float _2208;
  float _2275;
  float _2308;
  float _2322;
  float _2361;
  float _2483;
  float _2569;
  float _2655;
  float _2870;
  float _2871;
  float _2872;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        bool _50 = (cb0_043x == 4);
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
  if ((uint)cb0_042w > (uint)2) {
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
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _391 = _127;
      _392 = _128;
      _393 = _129;
      float _408 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _393, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _392, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _391)));
      float _411 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _393, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _392, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _391)));
      float _414 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _393, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _392, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _391)));

      SetUngradedAP1(float3(_408, _411, _414));

      float _415 = dot(float3(_408, _411, _414), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _419 = (_408 / _415) + -1.0f;
      float _420 = (_411 / _415) + -1.0f;
      float _421 = (_414 / _415) + -1.0f;
      float _433 = (1.0f - exp2(((_415 * _415) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_419, _420, _421), float3(_419, _420, _421)) * -4.0f));
      float _449 = ((mad(-0.06368321925401688f, _414, mad(-0.3292922377586365f, _411, (_408 * 1.3704125881195068f))) - _408) * _433) + _408;
      float _450 = ((mad(-0.010861365124583244f, _414, mad(1.0970927476882935f, _411, (_408 * -0.08343357592821121f))) - _411) * _433) + _411;
      float _451 = ((mad(1.2036951780319214f, _414, mad(-0.09862580895423889f, _411, (_408 * -0.02579331398010254f))) - _414) * _433) + _414;
      float _452 = dot(float3(_449, _450, _451), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _466 = cb0_021w + cb0_026w;
      float _480 = cb0_020w * cb0_025w;
      float _494 = cb0_019w * cb0_024w;
      float _508 = cb0_018w * cb0_023w;
      float _522 = cb0_017w * cb0_022w;
      float _526 = _449 - _452;
      float _527 = _450 - _452;
      float _528 = _451 - _452;
      float _585 = saturate(_452 / cb0_037w);
      float _589 = (_585 * _585) * (3.0f - (_585 * 2.0f));
      float _590 = 1.0f - _589;
      float _599 = cb0_021w + cb0_036w;
      float _608 = cb0_020w * cb0_035w;
      float _617 = cb0_019w * cb0_034w;
      float _626 = cb0_018w * cb0_033w;
      float _635 = cb0_017w * cb0_032w;
      float _698 = saturate((_452 - cb0_038x) / (cb0_038y - cb0_038x));
      float _702 = (_698 * _698) * (3.0f - (_698 * 2.0f));
      float _711 = cb0_021w + cb0_031w;
      float _720 = cb0_020w * cb0_030w;
      float _729 = cb0_019w * cb0_029w;
      float _738 = cb0_018w * cb0_028w;
      float _747 = cb0_017w * cb0_027w;
      float _805 = _589 - _702;
      float _816 = ((_702 * (((cb0_021x + cb0_036x) + _599) + (((cb0_020x * cb0_035x) * _608) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _626) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _635) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _617)))))) + (_590 * (((cb0_021x + cb0_026x) + _466) + (((cb0_020x * cb0_025x) * _480) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _508) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _522) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _494))))))) + ((((cb0_021x + cb0_031x) + _711) + (((cb0_020x * cb0_030x) * _720) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _738) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _747) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _729))))) * _805);
      float _818 = ((_702 * (((cb0_021y + cb0_036y) + _599) + (((cb0_020y * cb0_035y) * _608) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _626) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _635) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _617)))))) + (_590 * (((cb0_021y + cb0_026y) + _466) + (((cb0_020y * cb0_025y) * _480) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _508) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _522) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _494))))))) + ((((cb0_021y + cb0_031y) + _711) + (((cb0_020y * cb0_030y) * _720) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _738) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _747) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _729))))) * _805);
      float _820 = ((_702 * (((cb0_021z + cb0_036z) + _599) + (((cb0_020z * cb0_035z) * _608) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _626) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _635) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _617)))))) + (_590 * (((cb0_021z + cb0_026z) + _466) + (((cb0_020z * cb0_025z) * _480) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _508) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _522) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _494))))))) + ((((cb0_021z + cb0_031z) + _711) + (((cb0_020z * cb0_030z) * _720) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _738) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _747) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _729))))) * _805);

      SetUntonemappedAP1(float3(_816, _818, _820));

      float _856 = ((mad(0.061360642313957214f, _820, mad(-4.540197551250458e-09f, _818, (_816 * 0.9386394023895264f))) - _816) * cb0_038z) + _816;
      float _857 = ((mad(0.169205904006958f, _820, mad(0.8307942152023315f, _818, (_816 * 6.775371730327606e-08f))) - _818) * cb0_038z) + _818;
      float _858 = (mad(-2.3283064365386963e-10f, _818, (_816 * -9.313225746154785e-10f)) * cb0_038z) + _820;
      float _861 = mad(0.16386905312538147f, _858, mad(0.14067868888378143f, _857, (_856 * 0.6954522132873535f)));
      float _864 = mad(0.0955343246459961f, _858, mad(0.8596711158752441f, _857, (_856 * 0.044794581830501556f)));
      float _867 = mad(1.0015007257461548f, _858, mad(0.004025210160762072f, _857, (_856 * -0.005525882821530104f)));
      float _871 = max(max(_861, _864), _867);
      float _876 = (max(_871, 1.000000013351432e-10f) - max(min(min(_861, _864), _867), 1.000000013351432e-10f)) / max(_871, 0.009999999776482582f);
      float _889 = ((_864 + _861) + _867) + (sqrt((((_867 - _864) * _867) + ((_864 - _861) * _864)) + ((_861 - _867) * _861)) * 1.75f);
      float _890 = _889 * 0.3333333432674408f;
      float _891 = _876 + -0.4000000059604645f;
      float _892 = _891 * 5.0f;
      float _896 = max((1.0f - abs(_891 * 2.5f)), 0.0f);
      float _907 = ((float((int)(((int)(uint)((bool)(_892 > 0.0f))) - ((int)(uint)((bool)(_892 < 0.0f))))) * (1.0f - (_896 * _896))) + 1.0f) * 0.02500000037252903f;
      do {
        if (!(_890 <= 0.0533333346247673f)) {
          if (!(_890 >= 0.1599999964237213f)) {
            _916 = (((0.23999999463558197f / _889) + -0.5f) * _907);
          } else {
            _916 = 0.0f;
          }
        } else {
          _916 = _907;
        }
        float _917 = _916 + 1.0f;
        float _918 = _917 * _861;
        float _919 = _917 * _864;
        float _920 = _917 * _867;
        do {
          if (!((bool)(_918 == _919) && (bool)(_919 == _920))) {
            float _927 = ((_918 * 2.0f) - _919) - _920;
            float _930 = ((_864 - _867) * 1.7320507764816284f) * _917;
            float _932 = atan(_930 / _927);
            bool _935 = (_927 < 0.0f);
            bool _936 = (_927 == 0.0f);
            bool _937 = (_930 >= 0.0f);
            bool _938 = (_930 < 0.0f);
            _949 = select((_937 && _936), 90.0f, select((_938 && _936), -90.0f, (select((_938 && _935), (_932 + -3.1415927410125732f), select((_937 && _935), (_932 + 3.1415927410125732f), _932)) * 57.2957763671875f)));
          } else {
            _949 = 0.0f;
          }
          float _954 = min(max(select((_949 < 0.0f), (_949 + 360.0f), _949), 0.0f), 360.0f);
          do {
            if (_954 < -180.0f) {
              _963 = (_954 + 360.0f);
            } else {
              if (_954 > 180.0f) {
                _963 = (_954 + -360.0f);
              } else {
                _963 = _954;
              }
            }
            float _967 = saturate(1.0f - abs(_963 * 0.014814814552664757f));
            float _971 = (_967 * _967) * (3.0f - (_967 * 2.0f));
            float _977 = ((_971 * _971) * ((_876 * 0.18000000715255737f) * (0.029999999329447746f - _918))) + _918;
            float _987 = max(0.0f, mad(-0.21492856740951538f, _920, mad(-0.2365107536315918f, _919, (_977 * 1.4514392614364624f))));
            float _988 = max(0.0f, mad(-0.09967592358589172f, _920, mad(1.17622971534729f, _919, (_977 * -0.07655377686023712f))));
            float _989 = max(0.0f, mad(0.9977163076400757f, _920, mad(-0.006032449658960104f, _919, (_977 * 0.008316148072481155f))));
            float _990 = dot(float3(_987, _988, _989), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _1005 = (cb0_040x + 1.0f) - cb0_039z;
            float _1007 = cb0_040y + 1.0f;
            float _1009 = _1007 - cb0_039w;
            do {
              if (cb0_039z > 0.800000011920929f) {
                _1027 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
              } else {
                float _1018 = (cb0_040x + 0.18000000715255737f) / _1005;
                _1027 = (-0.7447274923324585f - ((log2(_1018 / (2.0f - _1018)) * 0.3465735912322998f) * (_1005 / cb0_039y)));
              }
              float _1030 = ((1.0f - cb0_039z) / cb0_039y) - _1027;
              float _1032 = (cb0_039w / cb0_039y) - _1030;
              float _1036 = log2(lerp(_990, _987, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1037 = log2(lerp(_990, _988, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1038 = log2(lerp(_990, _989, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1042 = cb0_039y * (_1036 + _1030);
              float _1043 = cb0_039y * (_1037 + _1030);
              float _1044 = cb0_039y * (_1038 + _1030);
              float _1045 = _1005 * 2.0f;
              float _1047 = (cb0_039y * -2.0f) / _1005;
              float _1048 = _1036 - _1027;
              float _1049 = _1037 - _1027;
              float _1050 = _1038 - _1027;
              float _1069 = _1009 * 2.0f;
              float _1071 = (cb0_039y * 2.0f) / _1009;
              float _1096 = select((_1036 < _1027), ((_1045 / (exp2((_1048 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1042);
              float _1097 = select((_1037 < _1027), ((_1045 / (exp2((_1049 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1043);
              float _1098 = select((_1038 < _1027), ((_1045 / (exp2((_1050 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1044);
              float _1105 = _1032 - _1027;
              float _1109 = saturate(_1048 / _1105);
              float _1110 = saturate(_1049 / _1105);
              float _1111 = saturate(_1050 / _1105);
              bool _1112 = (_1032 < _1027);
              float _1116 = select(_1112, (1.0f - _1109), _1109);
              float _1117 = select(_1112, (1.0f - _1110), _1110);
              float _1118 = select(_1112, (1.0f - _1111), _1111);
              float _1137 = (((_1116 * _1116) * (select((_1036 > _1032), (_1007 - (_1069 / (exp2(((_1036 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1042) - _1096)) * (3.0f - (_1116 * 2.0f))) + _1096;
              float _1138 = (((_1117 * _1117) * (select((_1037 > _1032), (_1007 - (_1069 / (exp2(((_1037 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1043) - _1097)) * (3.0f - (_1117 * 2.0f))) + _1097;
              float _1139 = (((_1118 * _1118) * (select((_1038 > _1032), (_1007 - (_1069 / (exp2(((_1038 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1044) - _1098)) * (3.0f - (_1118 * 2.0f))) + _1098;
              float _1140 = dot(float3(_1137, _1138, _1139), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _1160 = (cb0_039x * (max(0.0f, (lerp(_1140, _1137, 0.9300000071525574f))) - _856)) + _856;
              float _1161 = (cb0_039x * (max(0.0f, (lerp(_1140, _1138, 0.9300000071525574f))) - _857)) + _857;
              float _1162 = (cb0_039x * (max(0.0f, (lerp(_1140, _1139, 0.9300000071525574f))) - _858)) + _858;
              float _1178 = ((mad(-0.06537103652954102f, _1162, mad(1.451815478503704e-06f, _1161, (_1160 * 1.065374732017517f))) - _1160) * cb0_038z) + _1160;
              float _1179 = ((mad(-0.20366770029067993f, _1162, mad(1.2036634683609009f, _1161, (_1160 * -2.57161445915699e-07f))) - _1161) * cb0_038z) + _1161;
              float _1180 = ((mad(0.9999996423721313f, _1162, mad(2.0954757928848267e-08f, _1161, (_1160 * 1.862645149230957e-08f))) - _1162) * cb0_038z) + _1162;

              SetTonemappedAP1(_1178, _1179, _1180);

              float _1190 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1180, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1179, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1178))));
              float _1191 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1180, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1179, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1178))));
              float _1192 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1180, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1179, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1178))));
              float _1218 = cb0_016x * (((cb0_041y + (cb0_041x * _1190)) * _1190) + cb0_041z);
              float _1219 = cb0_016y * (((cb0_041y + (cb0_041x * _1191)) * _1191) + cb0_041z);
              float _1220 = cb0_016z * (((cb0_041y + (cb0_041x * _1192)) * _1192) + cb0_041z);
              float _1227 = ((cb0_015x - _1218) * cb0_015w) + _1218;
              float _1228 = ((cb0_015y - _1219) * cb0_015w) + _1219;
              float _1229 = ((cb0_015z - _1220) * cb0_015w) + _1220;
              float _1230 = cb0_016x * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _820, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _818, (_816 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x))));
              float _1231 = cb0_016y * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _820, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _818, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _816)));
              float _1232 = cb0_016z * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _820, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _818, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _816)));
              float _1239 = ((cb0_015x - _1230) * cb0_015w) + _1230;
              float _1240 = ((cb0_015y - _1231) * cb0_015w) + _1231;
              float _1241 = ((cb0_015z - _1232) * cb0_015w) + _1232;
              float _1253 = exp2(log2(max(0.0f, _1227)) * cb0_042y);
              float _1254 = exp2(log2(max(0.0f, _1228)) * cb0_042y);
              float _1255 = exp2(log2(max(0.0f, _1229)) * cb0_042y);

              if (RENODX_TONE_MAP_TYPE != 0) {
                u0[SV_DispatchThreadID] = GenerateOutput(float3(_1253, _1254, _1255), cb0_042w);
                return;
              }

              do {
                [branch]
                if (cb0_042w == 0) {
                  do {
                    if (WorkingColorSpace_000.FWorkingColorSpaceConstants_384 == 0) {
                      float _1278 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1253)));
                      float _1281 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1253)));
                      float _1284 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1253)));
                      _1295 = mad(_63, _1284, mad(_62, _1281, (_1278 * _61)));
                      _1296 = mad(_66, _1284, mad(_65, _1281, (_1278 * _64)));
                      _1297 = mad(_69, _1284, mad(_68, _1281, (_1278 * _67)));
                    } else {
                      _1295 = _1253;
                      _1296 = _1254;
                      _1297 = _1255;
                    }
                    do {
                      if (_1295 < 0.0031306699384003878f) {
                        _1308 = (_1295 * 12.920000076293945f);
                      } else {
                        _1308 = (((pow(_1295, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                      }
                      do {
                        if (_1296 < 0.0031306699384003878f) {
                          _1319 = (_1296 * 12.920000076293945f);
                        } else {
                          _1319 = (((pow(_1296, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                        if (_1297 < 0.0031306699384003878f) {
                          _2870 = _1308;
                          _2871 = _1319;
                          _2872 = (_1297 * 12.920000076293945f);
                        } else {
                          _2870 = _1308;
                          _2871 = _1319;
                          _2872 = (((pow(_1297, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                        }
                      } while (false);
                    } while (false);
                  } while (false);
                } else {
                  if (cb0_042w == 1) {
                    float _1346 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1253)));
                    float _1349 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1253)));
                    float _1352 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1253)));
                    float _1355 = mad(_63, _1352, mad(_62, _1349, (_1346 * _61)));
                    float _1358 = mad(_66, _1352, mad(_65, _1349, (_1346 * _64)));
                    float _1361 = mad(_69, _1352, mad(_68, _1349, (_1346 * _67)));
                    _2870 = min((_1355 * 4.5f), ((exp2(log2(max(_1355, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                    _2871 = min((_1358 * 4.5f), ((exp2(log2(max(_1358, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                    _2872 = min((_1361 * 4.5f), ((exp2(log2(max(_1361, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                  } else {
                    if ((uint)((uint)((int)(cb0_042w) + -3u)) < (uint)2) {
                      _9[0] = cb0_010x;
                      _9[1] = cb0_010y;
                      _9[2] = cb0_010z;
                      _9[3] = cb0_010w;
                      _9[4] = cb0_012x;
                      _9[5] = cb0_012x;
                      float _1430 = cb0_012z * _1239;
                      float _1431 = cb0_012z * _1240;
                      float _1432 = cb0_012z * _1241;
                      float _1435 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _1432, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _1431, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _1430)));
                      float _1438 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _1432, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _1431, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _1430)));
                      float _1441 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _1432, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _1431, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _1430)));
                      float _1444 = mad(-0.21492856740951538f, _1441, mad(-0.2365107536315918f, _1438, (_1435 * 1.4514392614364624f)));
                      float _1447 = mad(-0.09967592358589172f, _1441, mad(1.17622971534729f, _1438, (_1435 * -0.07655377686023712f)));
                      float _1450 = mad(0.9977163076400757f, _1441, mad(-0.006032449658960104f, _1438, (_1435 * 0.008316148072481155f)));
                      float _1452 = max(_1444, max(_1447, _1450));
                      do {
                        if (!(_1452 < 1.000000013351432e-10f)) {
                          if (!(((bool)((bool)(_1435 < 0.0f) || (bool)(_1438 < 0.0f))) || (bool)(_1441 < 0.0f))) {
                            float _1462 = abs(_1452);
                            float _1463 = (_1452 - _1444) / _1462;
                            float _1465 = (_1452 - _1447) / _1462;
                            float _1467 = (_1452 - _1450) / _1462;
                            do {
                              if (!(_1463 < 0.8149999976158142f)) {
                                float _1470 = _1463 + -0.8149999976158142f;
                                _1482 = ((_1470 / exp2(log2(exp2(log2(_1470 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                              } else {
                                _1482 = _1463;
                              }
                              do {
                                if (!(_1465 < 0.8029999732971191f)) {
                                  float _1485 = _1465 + -0.8029999732971191f;
                                  _1497 = ((_1485 / exp2(log2(exp2(log2(_1485 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                } else {
                                  _1497 = _1465;
                                }
                                do {
                                  if (!(_1467 < 0.8799999952316284f)) {
                                    float _1500 = _1467 + -0.8799999952316284f;
                                    _1512 = ((_1500 / exp2(log2(exp2(log2(_1500 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                  } else {
                                    _1512 = _1467;
                                  }
                                  _1520 = (_1452 - (_1462 * _1482));
                                  _1521 = (_1452 - (_1462 * _1497));
                                  _1522 = (_1452 - (_1462 * _1512));
                                } while (false);
                              } while (false);
                            } while (false);
                          } else {
                            _1520 = _1444;
                            _1521 = _1447;
                            _1522 = _1450;
                          }
                        } else {
                          _1520 = _1444;
                          _1521 = _1447;
                          _1522 = _1450;
                        }
                        float _1538 = ((mad(0.16386906802654266f, _1522, mad(0.14067870378494263f, _1521, (_1520 * 0.6954522132873535f))) - _1435) * cb0_012w) + _1435;
                        float _1539 = ((mad(0.0955343171954155f, _1522, mad(0.8596711158752441f, _1521, (_1520 * 0.044794563204050064f))) - _1438) * cb0_012w) + _1438;
                        float _1540 = ((mad(1.0015007257461548f, _1522, mad(0.004025210160762072f, _1521, (_1520 * -0.005525882821530104f))) - _1441) * cb0_012w) + _1441;
                        float _1544 = max(max(_1538, _1539), _1540);
                        float _1549 = (max(_1544, 1.000000013351432e-10f) - max(min(min(_1538, _1539), _1540), 1.000000013351432e-10f)) / max(_1544, 0.009999999776482582f);
                        float _1562 = ((_1539 + _1538) + _1540) + (sqrt((((_1540 - _1539) * _1540) + ((_1539 - _1538) * _1539)) + ((_1538 - _1540) * _1538)) * 1.75f);
                        float _1563 = _1562 * 0.3333333432674408f;
                        float _1564 = _1549 + -0.4000000059604645f;
                        float _1565 = _1564 * 5.0f;
                        float _1569 = max((1.0f - abs(_1564 * 2.5f)), 0.0f);
                        float _1580 = ((float((int)(((int)(uint)((bool)(_1565 > 0.0f))) - ((int)(uint)((bool)(_1565 < 0.0f))))) * (1.0f - (_1569 * _1569))) + 1.0f) * 0.02500000037252903f;
                        do {
                          if (!(_1563 <= 0.0533333346247673f)) {
                            if (!(_1563 >= 0.1599999964237213f)) {
                              _1589 = (((0.23999999463558197f / _1562) + -0.5f) * _1580);
                            } else {
                              _1589 = 0.0f;
                            }
                          } else {
                            _1589 = _1580;
                          }
                          float _1590 = _1589 + 1.0f;
                          float _1591 = _1590 * _1538;
                          float _1592 = _1590 * _1539;
                          float _1593 = _1590 * _1540;
                          do {
                            if (!((bool)(_1591 == _1592) && (bool)(_1592 == _1593))) {
                              float _1600 = ((_1591 * 2.0f) - _1592) - _1593;
                              float _1603 = ((_1539 - _1540) * 1.7320507764816284f) * _1590;
                              float _1605 = atan(_1603 / _1600);
                              bool _1608 = (_1600 < 0.0f);
                              bool _1609 = (_1600 == 0.0f);
                              bool _1610 = (_1603 >= 0.0f);
                              bool _1611 = (_1603 < 0.0f);
                              _1622 = select((_1610 && _1609), 90.0f, select((_1611 && _1609), -90.0f, (select((_1611 && _1608), (_1605 + -3.1415927410125732f), select((_1610 && _1608), (_1605 + 3.1415927410125732f), _1605)) * 57.2957763671875f)));
                            } else {
                              _1622 = 0.0f;
                            }
                            float _1627 = min(max(select((_1622 < 0.0f), (_1622 + 360.0f), _1622), 0.0f), 360.0f);
                            do {
                              if (_1627 < -180.0f) {
                                _1636 = (_1627 + 360.0f);
                              } else {
                                if (_1627 > 180.0f) {
                                  _1636 = (_1627 + -360.0f);
                                } else {
                                  _1636 = _1627;
                                }
                              }
                              do {
                                if ((bool)(_1636 > -67.5f) && (bool)(_1636 < 67.5f)) {
                                  float _1642 = (_1636 + 67.5f) * 0.029629629105329514f;
                                  int _1643 = int(_1642);
                                  float _1645 = _1642 - float((int)(_1643));
                                  float _1646 = _1645 * _1645;
                                  float _1647 = _1646 * _1645;
                                  if (_1643 == 3) {
                                    _1675 = (((0.1666666716337204f - (_1645 * 0.5f)) + (_1646 * 0.5f)) - (_1647 * 0.1666666716337204f));
                                  } else {
                                    if (_1643 == 2) {
                                      _1675 = ((0.6666666865348816f - _1646) + (_1647 * 0.5f));
                                    } else {
                                      if (_1643 == 1) {
                                        _1675 = (((_1647 * -0.5f) + 0.1666666716337204f) + ((_1646 + _1645) * 0.5f));
                                      } else {
                                        _1675 = select((_1643 == 0), (_1647 * 0.1666666716337204f), 0.0f);
                                      }
                                    }
                                  }
                                } else {
                                  _1675 = 0.0f;
                                }
                                float _1684 = min(max(((((_1549 * 0.27000001072883606f) * (0.029999999329447746f - _1591)) * _1675) + _1591), 0.0f), 65535.0f);
                                float _1685 = min(max(_1592, 0.0f), 65535.0f);
                                float _1686 = min(max(_1593, 0.0f), 65535.0f);
                                float _1699 = min(max(mad(-0.21492856740951538f, _1686, mad(-0.2365107536315918f, _1685, (_1684 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                float _1700 = min(max(mad(-0.09967592358589172f, _1686, mad(1.17622971534729f, _1685, (_1684 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                float _1701 = min(max(mad(0.9977163076400757f, _1686, mad(-0.006032449658960104f, _1685, (_1684 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                float _1702 = dot(float3(_1699, _1700, _1701), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                float _1725 = log2(max((lerp(_1702, _1699, 0.9599999785423279f)), 1.000000013351432e-10f));
                                float _1726 = _1725 * 0.3010300099849701f;
                                float _1727 = log2(cb0_008x);
                                float _1728 = _1727 * 0.3010300099849701f;
                                do {
                                  if (!(!(_1726 <= _1728))) {
                                    _1797 = (log2(cb0_008y) * 0.3010300099849701f);
                                  } else {
                                    float _1735 = log2(cb0_009x);
                                    float _1736 = _1735 * 0.3010300099849701f;
                                    if ((bool)(_1726 > _1728) && (bool)(_1726 < _1736)) {
                                      float _1744 = ((_1725 - _1727) * 0.9030900001525879f) / ((_1735 - _1727) * 0.3010300099849701f);
                                      int _1745 = int(_1744);
                                      float _1747 = _1744 - float((int)(_1745));
                                      float _1749 = _16[_1745];
                                      float _1752 = _16[(_1745 + 1)];
                                      float _1757 = _1749 * 0.5f;
                                      _1797 = dot(float3((_1747 * _1747), _1747, 1.0f), float3(mad((_16[(_1745 + 2)]), 0.5f, mad(_1752, -1.0f, _1757)), (_1752 - _1749), mad(_1752, 0.5f, _1757)));
                                    } else {
                                      do {
                                        if (!(!(_1726 >= _1736))) {
                                          float _1766 = log2(cb0_008z);
                                          if (_1726 < (_1766 * 0.3010300099849701f)) {
                                            float _1774 = ((_1725 - _1735) * 0.9030900001525879f) / ((_1766 - _1735) * 0.3010300099849701f);
                                            int _1775 = int(_1774);
                                            float _1777 = _1774 - float((int)(_1775));
                                            float _1779 = _17[_1775];
                                            float _1782 = _17[(_1775 + 1)];
                                            float _1787 = _1779 * 0.5f;
                                            _1797 = dot(float3((_1777 * _1777), _1777, 1.0f), float3(mad((_17[(_1775 + 2)]), 0.5f, mad(_1782, -1.0f, _1787)), (_1782 - _1779), mad(_1782, 0.5f, _1787)));
                                            break;
                                          }
                                        }
                                        _1797 = (log2(cb0_008w) * 0.3010300099849701f);
                                      } while (false);
                                    }
                                  }
                                  _18[0] = cb0_011x;
                                  _18[1] = cb0_011y;
                                  _18[2] = cb0_011z;
                                  _18[3] = cb0_011w;
                                  _18[4] = cb0_012y;
                                  _18[5] = cb0_012y;
                                  float _1807 = log2(max((lerp(_1702, _1700, 0.9599999785423279f)), 1.000000013351432e-10f));
                                  float _1808 = _1807 * 0.3010300099849701f;
                                  do {
                                    if (!(!(_1808 <= _1728))) {
                                      _1877 = (log2(cb0_008y) * 0.3010300099849701f);
                                    } else {
                                      float _1815 = log2(cb0_009x);
                                      float _1816 = _1815 * 0.3010300099849701f;
                                      if ((bool)(_1808 > _1728) && (bool)(_1808 < _1816)) {
                                        float _1824 = ((_1807 - _1727) * 0.9030900001525879f) / ((_1815 - _1727) * 0.3010300099849701f);
                                        int _1825 = int(_1824);
                                        float _1827 = _1824 - float((int)(_1825));
                                        float _1829 = _9[_1825];
                                        float _1832 = _9[(_1825 + 1)];
                                        float _1837 = _1829 * 0.5f;
                                        _1877 = dot(float3((_1827 * _1827), _1827, 1.0f), float3(mad((_9[(_1825 + 2)]), 0.5f, mad(_1832, -1.0f, _1837)), (_1832 - _1829), mad(_1832, 0.5f, _1837)));
                                      } else {
                                        do {
                                          if (!(!(_1808 >= _1816))) {
                                            float _1846 = log2(cb0_008z);
                                            if (_1808 < (_1846 * 0.3010300099849701f)) {
                                              float _1854 = ((_1807 - _1815) * 0.9030900001525879f) / ((_1846 - _1815) * 0.3010300099849701f);
                                              int _1855 = int(_1854);
                                              float _1857 = _1854 - float((int)(_1855));
                                              float _1859 = _18[_1855];
                                              float _1862 = _18[(_1855 + 1)];
                                              float _1867 = _1859 * 0.5f;
                                              _1877 = dot(float3((_1857 * _1857), _1857, 1.0f), float3(mad((_18[(_1855 + 2)]), 0.5f, mad(_1862, -1.0f, _1867)), (_1862 - _1859), mad(_1862, 0.5f, _1867)));
                                              break;
                                            }
                                          }
                                          _1877 = (log2(cb0_008w) * 0.3010300099849701f);
                                        } while (false);
                                      }
                                    }
                                    _19[0] = cb0_010x;
                                    _19[1] = cb0_010y;
                                    _19[2] = cb0_010z;
                                    _19[3] = cb0_010w;
                                    _19[4] = cb0_012x;
                                    _19[5] = cb0_012x;
                                    _20[0] = cb0_011x;
                                    _20[1] = cb0_011y;
                                    _20[2] = cb0_011z;
                                    _20[3] = cb0_011w;
                                    _20[4] = cb0_012y;
                                    _20[5] = cb0_012y;
                                    float _1893 = log2(max((lerp(_1702, _1701, 0.9599999785423279f)), 1.000000013351432e-10f));
                                    float _1894 = _1893 * 0.3010300099849701f;
                                    do {
                                      if (!(!(_1894 <= _1728))) {
                                        _1963 = (log2(cb0_008y) * 0.3010300099849701f);
                                      } else {
                                        float _1901 = log2(cb0_009x);
                                        float _1902 = _1901 * 0.3010300099849701f;
                                        if ((bool)(_1894 > _1728) && (bool)(_1894 < _1902)) {
                                          float _1910 = ((_1893 - _1727) * 0.9030900001525879f) / ((_1901 - _1727) * 0.3010300099849701f);
                                          int _1911 = int(_1910);
                                          float _1913 = _1910 - float((int)(_1911));
                                          float _1915 = _19[_1911];
                                          float _1918 = _19[(_1911 + 1)];
                                          float _1923 = _1915 * 0.5f;
                                          _1963 = dot(float3((_1913 * _1913), _1913, 1.0f), float3(mad((_19[(_1911 + 2)]), 0.5f, mad(_1918, -1.0f, _1923)), (_1918 - _1915), mad(_1918, 0.5f, _1923)));
                                        } else {
                                          do {
                                            if (!(!(_1894 >= _1902))) {
                                              float _1932 = log2(cb0_008z);
                                              if (_1894 < (_1932 * 0.3010300099849701f)) {
                                                float _1940 = ((_1893 - _1901) * 0.9030900001525879f) / ((_1932 - _1901) * 0.3010300099849701f);
                                                int _1941 = int(_1940);
                                                float _1943 = _1940 - float((int)(_1941));
                                                float _1945 = _20[_1941];
                                                float _1948 = _20[(_1941 + 1)];
                                                float _1953 = _1945 * 0.5f;
                                                _1963 = dot(float3((_1943 * _1943), _1943, 1.0f), float3(mad((_20[(_1941 + 2)]), 0.5f, mad(_1948, -1.0f, _1953)), (_1948 - _1945), mad(_1948, 0.5f, _1953)));
                                                break;
                                              }
                                            }
                                            _1963 = (log2(cb0_008w) * 0.3010300099849701f);
                                          } while (false);
                                        }
                                      }
                                      float _1967 = cb0_008w - cb0_008y;
                                      float _1968 = (exp2(_1797 * 3.321928024291992f) - cb0_008y) / _1967;
                                      float _1970 = (exp2(_1877 * 3.321928024291992f) - cb0_008y) / _1967;
                                      float _1972 = (exp2(_1963 * 3.321928024291992f) - cb0_008y) / _1967;
                                      float _1975 = mad(0.15618768334388733f, _1972, mad(0.13400420546531677f, _1970, (_1968 * 0.6624541878700256f)));
                                      float _1978 = mad(0.053689517080783844f, _1972, mad(0.6740817427635193f, _1970, (_1968 * 0.2722287178039551f)));
                                      float _1981 = mad(1.0103391408920288f, _1972, mad(0.00406073359772563f, _1970, (_1968 * -0.005574649665504694f)));
                                      float _1994 = min(max(mad(-0.23642469942569733f, _1981, mad(-0.32480329275131226f, _1978, (_1975 * 1.6410233974456787f))), 0.0f), 1.0f);
                                      float _1995 = min(max(mad(0.016756348311901093f, _1981, mad(1.6153316497802734f, _1978, (_1975 * -0.663662850856781f))), 0.0f), 1.0f);
                                      float _1996 = min(max(mad(0.9883948564529419f, _1981, mad(-0.008284442126750946f, _1978, (_1975 * 0.011721894145011902f))), 0.0f), 1.0f);
                                      float _1999 = mad(0.15618768334388733f, _1996, mad(0.13400420546531677f, _1995, (_1994 * 0.6624541878700256f)));
                                      float _2002 = mad(0.053689517080783844f, _1996, mad(0.6740817427635193f, _1995, (_1994 * 0.2722287178039551f)));
                                      float _2005 = mad(1.0103391408920288f, _1996, mad(0.00406073359772563f, _1995, (_1994 * -0.005574649665504694f)));
                                      float _2027 = min(max((min(max(mad(-0.23642469942569733f, _2005, mad(-0.32480329275131226f, _2002, (_1999 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                      float _2028 = min(max((min(max(mad(0.016756348311901093f, _2005, mad(1.6153316497802734f, _2002, (_1999 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                      float _2029 = min(max((min(max(mad(0.9883948564529419f, _2005, mad(-0.008284442126750946f, _2002, (_1999 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                      float _2048 = exp2(log2(mad(_63, _2029, mad(_62, _2028, (_2027 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      float _2049 = exp2(log2(mad(_66, _2029, mad(_65, _2028, (_2027 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      float _2050 = exp2(log2(mad(_69, _2029, mad(_68, _2028, (_2027 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                      _2870 = exp2(log2((1.0f / ((_2048 * 18.6875f) + 1.0f)) * ((_2048 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                      _2871 = exp2(log2((1.0f / ((_2049 * 18.6875f) + 1.0f)) * ((_2049 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                      _2872 = exp2(log2((1.0f / ((_2050 * 18.6875f) + 1.0f)) * ((_2050 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
                        float _2116 = cb0_012z * _1239;
                        float _2117 = cb0_012z * _1240;
                        float _2118 = cb0_012z * _1241;
                        float _2121 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _2118, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _2117, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _2116)));
                        float _2124 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _2118, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _2117, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _2116)));
                        float _2127 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _2118, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _2117, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _2116)));
                        float _2130 = mad(-0.21492856740951538f, _2127, mad(-0.2365107536315918f, _2124, (_2121 * 1.4514392614364624f)));
                        float _2133 = mad(-0.09967592358589172f, _2127, mad(1.17622971534729f, _2124, (_2121 * -0.07655377686023712f)));
                        float _2136 = mad(0.9977163076400757f, _2127, mad(-0.006032449658960104f, _2124, (_2121 * 0.008316148072481155f)));
                        float _2138 = max(_2130, max(_2133, _2136));
                        do {
                          if (!(_2138 < 1.000000013351432e-10f)) {
                            if (!(((bool)((bool)(_2121 < 0.0f) || (bool)(_2124 < 0.0f))) || (bool)(_2127 < 0.0f))) {
                              float _2148 = abs(_2138);
                              float _2149 = (_2138 - _2130) / _2148;
                              float _2151 = (_2138 - _2133) / _2148;
                              float _2153 = (_2138 - _2136) / _2148;
                              do {
                                if (!(_2149 < 0.8149999976158142f)) {
                                  float _2156 = _2149 + -0.8149999976158142f;
                                  _2168 = ((_2156 / exp2(log2(exp2(log2(_2156 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                } else {
                                  _2168 = _2149;
                                }
                                do {
                                  if (!(_2151 < 0.8029999732971191f)) {
                                    float _2171 = _2151 + -0.8029999732971191f;
                                    _2183 = ((_2171 / exp2(log2(exp2(log2(_2171 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                  } else {
                                    _2183 = _2151;
                                  }
                                  do {
                                    if (!(_2153 < 0.8799999952316284f)) {
                                      float _2186 = _2153 + -0.8799999952316284f;
                                      _2198 = ((_2186 / exp2(log2(exp2(log2(_2186 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                    } else {
                                      _2198 = _2153;
                                    }
                                    _2206 = (_2138 - (_2148 * _2168));
                                    _2207 = (_2138 - (_2148 * _2183));
                                    _2208 = (_2138 - (_2148 * _2198));
                                  } while (false);
                                } while (false);
                              } while (false);
                            } else {
                              _2206 = _2130;
                              _2207 = _2133;
                              _2208 = _2136;
                            }
                          } else {
                            _2206 = _2130;
                            _2207 = _2133;
                            _2208 = _2136;
                          }
                          float _2224 = ((mad(0.16386906802654266f, _2208, mad(0.14067870378494263f, _2207, (_2206 * 0.6954522132873535f))) - _2121) * cb0_012w) + _2121;
                          float _2225 = ((mad(0.0955343171954155f, _2208, mad(0.8596711158752441f, _2207, (_2206 * 0.044794563204050064f))) - _2124) * cb0_012w) + _2124;
                          float _2226 = ((mad(1.0015007257461548f, _2208, mad(0.004025210160762072f, _2207, (_2206 * -0.005525882821530104f))) - _2127) * cb0_012w) + _2127;
                          float _2230 = max(max(_2224, _2225), _2226);
                          float _2235 = (max(_2230, 1.000000013351432e-10f) - max(min(min(_2224, _2225), _2226), 1.000000013351432e-10f)) / max(_2230, 0.009999999776482582f);
                          float _2248 = ((_2225 + _2224) + _2226) + (sqrt((((_2226 - _2225) * _2226) + ((_2225 - _2224) * _2225)) + ((_2224 - _2226) * _2224)) * 1.75f);
                          float _2249 = _2248 * 0.3333333432674408f;
                          float _2250 = _2235 + -0.4000000059604645f;
                          float _2251 = _2250 * 5.0f;
                          float _2255 = max((1.0f - abs(_2250 * 2.5f)), 0.0f);
                          float _2266 = ((float((int)(((int)(uint)((bool)(_2251 > 0.0f))) - ((int)(uint)((bool)(_2251 < 0.0f))))) * (1.0f - (_2255 * _2255))) + 1.0f) * 0.02500000037252903f;
                          do {
                            if (!(_2249 <= 0.0533333346247673f)) {
                              if (!(_2249 >= 0.1599999964237213f)) {
                                _2275 = (((0.23999999463558197f / _2248) + -0.5f) * _2266);
                              } else {
                                _2275 = 0.0f;
                              }
                            } else {
                              _2275 = _2266;
                            }
                            float _2276 = _2275 + 1.0f;
                            float _2277 = _2276 * _2224;
                            float _2278 = _2276 * _2225;
                            float _2279 = _2276 * _2226;
                            do {
                              if (!((bool)(_2277 == _2278) && (bool)(_2278 == _2279))) {
                                float _2286 = ((_2277 * 2.0f) - _2278) - _2279;
                                float _2289 = ((_2225 - _2226) * 1.7320507764816284f) * _2276;
                                float _2291 = atan(_2289 / _2286);
                                bool _2294 = (_2286 < 0.0f);
                                bool _2295 = (_2286 == 0.0f);
                                bool _2296 = (_2289 >= 0.0f);
                                bool _2297 = (_2289 < 0.0f);
                                _2308 = select((_2296 && _2295), 90.0f, select((_2297 && _2295), -90.0f, (select((_2297 && _2294), (_2291 + -3.1415927410125732f), select((_2296 && _2294), (_2291 + 3.1415927410125732f), _2291)) * 57.2957763671875f)));
                              } else {
                                _2308 = 0.0f;
                              }
                              float _2313 = min(max(select((_2308 < 0.0f), (_2308 + 360.0f), _2308), 0.0f), 360.0f);
                              do {
                                if (_2313 < -180.0f) {
                                  _2322 = (_2313 + 360.0f);
                                } else {
                                  if (_2313 > 180.0f) {
                                    _2322 = (_2313 + -360.0f);
                                  } else {
                                    _2322 = _2313;
                                  }
                                }
                                do {
                                  if ((bool)(_2322 > -67.5f) && (bool)(_2322 < 67.5f)) {
                                    float _2328 = (_2322 + 67.5f) * 0.029629629105329514f;
                                    int _2329 = int(_2328);
                                    float _2331 = _2328 - float((int)(_2329));
                                    float _2332 = _2331 * _2331;
                                    float _2333 = _2332 * _2331;
                                    if (_2329 == 3) {
                                      _2361 = (((0.1666666716337204f - (_2331 * 0.5f)) + (_2332 * 0.5f)) - (_2333 * 0.1666666716337204f));
                                    } else {
                                      if (_2329 == 2) {
                                        _2361 = ((0.6666666865348816f - _2332) + (_2333 * 0.5f));
                                      } else {
                                        if (_2329 == 1) {
                                          _2361 = (((_2333 * -0.5f) + 0.1666666716337204f) + ((_2332 + _2331) * 0.5f));
                                        } else {
                                          _2361 = select((_2329 == 0), (_2333 * 0.1666666716337204f), 0.0f);
                                        }
                                      }
                                    }
                                  } else {
                                    _2361 = 0.0f;
                                  }
                                  float _2370 = min(max(((((_2235 * 0.27000001072883606f) * (0.029999999329447746f - _2277)) * _2361) + _2277), 0.0f), 65535.0f);
                                  float _2371 = min(max(_2278, 0.0f), 65535.0f);
                                  float _2372 = min(max(_2279, 0.0f), 65535.0f);
                                  float _2385 = min(max(mad(-0.21492856740951538f, _2372, mad(-0.2365107536315918f, _2371, (_2370 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                  float _2386 = min(max(mad(-0.09967592358589172f, _2372, mad(1.17622971534729f, _2371, (_2370 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                  float _2387 = min(max(mad(0.9977163076400757f, _2372, mad(-0.006032449658960104f, _2371, (_2370 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                  float _2388 = dot(float3(_2385, _2386, _2387), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                  float _2411 = log2(max((lerp(_2388, _2385, 0.9599999785423279f)), 1.000000013351432e-10f));
                                  float _2412 = _2411 * 0.3010300099849701f;
                                  float _2413 = log2(cb0_008x);
                                  float _2414 = _2413 * 0.3010300099849701f;
                                  do {
                                    if (!(!(_2412 <= _2414))) {
                                      _2483 = (log2(cb0_008y) * 0.3010300099849701f);
                                    } else {
                                      float _2421 = log2(cb0_009x);
                                      float _2422 = _2421 * 0.3010300099849701f;
                                      if ((bool)(_2412 > _2414) && (bool)(_2412 < _2422)) {
                                        float _2430 = ((_2411 - _2413) * 0.9030900001525879f) / ((_2421 - _2413) * 0.3010300099849701f);
                                        int _2431 = int(_2430);
                                        float _2433 = _2430 - float((int)(_2431));
                                        float _2435 = _10[_2431];
                                        float _2438 = _10[(_2431 + 1)];
                                        float _2443 = _2435 * 0.5f;
                                        _2483 = dot(float3((_2433 * _2433), _2433, 1.0f), float3(mad((_10[(_2431 + 2)]), 0.5f, mad(_2438, -1.0f, _2443)), (_2438 - _2435), mad(_2438, 0.5f, _2443)));
                                      } else {
                                        do {
                                          if (!(!(_2412 >= _2422))) {
                                            float _2452 = log2(cb0_008z);
                                            if (_2412 < (_2452 * 0.3010300099849701f)) {
                                              float _2460 = ((_2411 - _2421) * 0.9030900001525879f) / ((_2452 - _2421) * 0.3010300099849701f);
                                              int _2461 = int(_2460);
                                              float _2463 = _2460 - float((int)(_2461));
                                              float _2465 = _11[_2461];
                                              float _2468 = _11[(_2461 + 1)];
                                              float _2473 = _2465 * 0.5f;
                                              _2483 = dot(float3((_2463 * _2463), _2463, 1.0f), float3(mad((_11[(_2461 + 2)]), 0.5f, mad(_2468, -1.0f, _2473)), (_2468 - _2465), mad(_2468, 0.5f, _2473)));
                                              break;
                                            }
                                          }
                                          _2483 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                    float _2499 = log2(max((lerp(_2388, _2386, 0.9599999785423279f)), 1.000000013351432e-10f));
                                    float _2500 = _2499 * 0.3010300099849701f;
                                    do {
                                      if (!(!(_2500 <= _2414))) {
                                        _2569 = (log2(cb0_008y) * 0.3010300099849701f);
                                      } else {
                                        float _2507 = log2(cb0_009x);
                                        float _2508 = _2507 * 0.3010300099849701f;
                                        if ((bool)(_2500 > _2414) && (bool)(_2500 < _2508)) {
                                          float _2516 = ((_2499 - _2413) * 0.9030900001525879f) / ((_2507 - _2413) * 0.3010300099849701f);
                                          int _2517 = int(_2516);
                                          float _2519 = _2516 - float((int)(_2517));
                                          float _2521 = _12[_2517];
                                          float _2524 = _12[(_2517 + 1)];
                                          float _2529 = _2521 * 0.5f;
                                          _2569 = dot(float3((_2519 * _2519), _2519, 1.0f), float3(mad((_12[(_2517 + 2)]), 0.5f, mad(_2524, -1.0f, _2529)), (_2524 - _2521), mad(_2524, 0.5f, _2529)));
                                        } else {
                                          do {
                                            if (!(!(_2500 >= _2508))) {
                                              float _2538 = log2(cb0_008z);
                                              if (_2500 < (_2538 * 0.3010300099849701f)) {
                                                float _2546 = ((_2499 - _2507) * 0.9030900001525879f) / ((_2538 - _2507) * 0.3010300099849701f);
                                                int _2547 = int(_2546);
                                                float _2549 = _2546 - float((int)(_2547));
                                                float _2551 = _13[_2547];
                                                float _2554 = _13[(_2547 + 1)];
                                                float _2559 = _2551 * 0.5f;
                                                _2569 = dot(float3((_2549 * _2549), _2549, 1.0f), float3(mad((_13[(_2547 + 2)]), 0.5f, mad(_2554, -1.0f, _2559)), (_2554 - _2551), mad(_2554, 0.5f, _2559)));
                                                break;
                                              }
                                            }
                                            _2569 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                      float _2585 = log2(max((lerp(_2388, _2387, 0.9599999785423279f)), 1.000000013351432e-10f));
                                      float _2586 = _2585 * 0.3010300099849701f;
                                      do {
                                        if (!(!(_2586 <= _2414))) {
                                          _2655 = (log2(cb0_008y) * 0.3010300099849701f);
                                        } else {
                                          float _2593 = log2(cb0_009x);
                                          float _2594 = _2593 * 0.3010300099849701f;
                                          if ((bool)(_2586 > _2414) && (bool)(_2586 < _2594)) {
                                            float _2602 = ((_2585 - _2413) * 0.9030900001525879f) / ((_2593 - _2413) * 0.3010300099849701f);
                                            int _2603 = int(_2602);
                                            float _2605 = _2602 - float((int)(_2603));
                                            float _2607 = _14[_2603];
                                            float _2610 = _14[(_2603 + 1)];
                                            float _2615 = _2607 * 0.5f;
                                            _2655 = dot(float3((_2605 * _2605), _2605, 1.0f), float3(mad((_14[(_2603 + 2)]), 0.5f, mad(_2610, -1.0f, _2615)), (_2610 - _2607), mad(_2610, 0.5f, _2615)));
                                          } else {
                                            do {
                                              if (!(!(_2586 >= _2594))) {
                                                float _2624 = log2(cb0_008z);
                                                if (_2586 < (_2624 * 0.3010300099849701f)) {
                                                  float _2632 = ((_2585 - _2593) * 0.9030900001525879f) / ((_2624 - _2593) * 0.3010300099849701f);
                                                  int _2633 = int(_2632);
                                                  float _2635 = _2632 - float((int)(_2633));
                                                  float _2637 = _15[_2633];
                                                  float _2640 = _15[(_2633 + 1)];
                                                  float _2645 = _2637 * 0.5f;
                                                  _2655 = dot(float3((_2635 * _2635), _2635, 1.0f), float3(mad((_15[(_2633 + 2)]), 0.5f, mad(_2640, -1.0f, _2645)), (_2640 - _2637), mad(_2640, 0.5f, _2645)));
                                                  break;
                                                }
                                              }
                                              _2655 = (log2(cb0_008w) * 0.3010300099849701f);
                                            } while (false);
                                          }
                                        }
                                        float _2659 = cb0_008w - cb0_008y;
                                        float _2660 = (exp2(_2483 * 3.321928024291992f) - cb0_008y) / _2659;
                                        float _2662 = (exp2(_2569 * 3.321928024291992f) - cb0_008y) / _2659;
                                        float _2664 = (exp2(_2655 * 3.321928024291992f) - cb0_008y) / _2659;
                                        float _2667 = mad(0.15618768334388733f, _2664, mad(0.13400420546531677f, _2662, (_2660 * 0.6624541878700256f)));
                                        float _2670 = mad(0.053689517080783844f, _2664, mad(0.6740817427635193f, _2662, (_2660 * 0.2722287178039551f)));
                                        float _2673 = mad(1.0103391408920288f, _2664, mad(0.00406073359772563f, _2662, (_2660 * -0.005574649665504694f)));
                                        float _2686 = min(max(mad(-0.23642469942569733f, _2673, mad(-0.32480329275131226f, _2670, (_2667 * 1.6410233974456787f))), 0.0f), 1.0f);
                                        float _2687 = min(max(mad(0.016756348311901093f, _2673, mad(1.6153316497802734f, _2670, (_2667 * -0.663662850856781f))), 0.0f), 1.0f);
                                        float _2688 = min(max(mad(0.9883948564529419f, _2673, mad(-0.008284442126750946f, _2670, (_2667 * 0.011721894145011902f))), 0.0f), 1.0f);
                                        float _2691 = mad(0.15618768334388733f, _2688, mad(0.13400420546531677f, _2687, (_2686 * 0.6624541878700256f)));
                                        float _2694 = mad(0.053689517080783844f, _2688, mad(0.6740817427635193f, _2687, (_2686 * 0.2722287178039551f)));
                                        float _2697 = mad(1.0103391408920288f, _2688, mad(0.00406073359772563f, _2687, (_2686 * -0.005574649665504694f)));
                                        float _2719 = min(max((min(max(mad(-0.23642469942569733f, _2697, mad(-0.32480329275131226f, _2694, (_2691 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                        float _2722 = min(max((min(max(mad(0.016756348311901093f, _2697, mad(1.6153316497802734f, _2694, (_2691 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                        float _2723 = min(max((min(max(mad(0.9883948564529419f, _2697, mad(-0.008284442126750946f, _2694, (_2691 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                        _2870 = mad(-0.0832589864730835f, _2723, mad(-0.6217921376228333f, _2722, (_2719 * 0.0213131383061409f)));
                                        _2871 = mad(-0.010548308491706848f, _2723, mad(1.140804648399353f, _2722, (_2719 * -0.0016282059950754046f)));
                                        _2872 = mad(1.1529725790023804f, _2723, mad(-0.1289689838886261f, _2722, (_2719 * -0.00030004189466126263f)));
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
                          float _2750 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1241, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1240, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1239)));
                          float _2753 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1241, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1240, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1239)));
                          float _2756 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1241, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1240, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1239)));
                          float _2775 = exp2(log2(mad(_63, _2756, mad(_62, _2753, (_2750 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2776 = exp2(log2(mad(_66, _2756, mad(_65, _2753, (_2750 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2777 = exp2(log2(mad(_69, _2756, mad(_68, _2753, (_2750 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2870 = exp2(log2((1.0f / ((_2775 * 18.6875f) + 1.0f)) * ((_2775 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2871 = exp2(log2((1.0f / ((_2776 * 18.6875f) + 1.0f)) * ((_2776 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2872 = exp2(log2((1.0f / ((_2777 * 18.6875f) + 1.0f)) * ((_2777 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } else {
                          if (!(cb0_042w == 8)) {
                            if (cb0_042w == 9) {
                              float _2824 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1229, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1228, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1227)));
                              float _2827 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1229, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1228, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1227)));
                              float _2830 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1229, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1228, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1227)));
                              _2870 = mad(_63, _2830, mad(_62, _2827, (_2824 * _61)));
                              _2871 = mad(_66, _2830, mad(_65, _2827, (_2824 * _64)));
                              _2872 = mad(_69, _2830, mad(_68, _2827, (_2824 * _67)));
                            } else {
                              float _2843 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1253)));
                              float _2846 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1253)));
                              float _2849 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1253)));
                              _2870 = exp2(log2(mad(_63, _2849, mad(_62, _2846, (_2843 * _61)))) * cb0_042z);
                              _2871 = exp2(log2(mad(_66, _2849, mad(_65, _2846, (_2843 * _64)))) * cb0_042z);
                              _2872 = exp2(log2(mad(_69, _2849, mad(_68, _2846, (_2843 * _67)))) * cb0_042z);
                            }
                          } else {
                            _2870 = _1239;
                            _2871 = _1240;
                            _2872 = _1241;
                          }
                        }
                      }
                    }
                  }
                }
                u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2870 * 0.9523810148239136f), (_2871 * 0.9523810148239136f), (_2872 * 0.9523810148239136f), 0.0f);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  bool _165 = (cb0_040w != 0);
  float _167 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _184 = (((((2967800.0f - (_167 * 4607000064.0f)) * _167) + 99.11000061035156f) * _167) + 0.24406300485134125f);
  } else {
    _184 = (((((1901800.0f - (_167 * 2006400000.0f)) * _167) + 247.47999572753906f) * _167) + 0.23703999817371368f);
  }
  float _198 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _205 = cb0_037y * cb0_037y;
  float _208 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_205 * 1.6145605741257896e-07f));
  float _213 = ((_198 * 2.0f) + 4.0f) - (_208 * 8.0f);
  float _214 = (_198 * 3.0f) / _213;
  float _216 = (_208 * 2.0f) / _213;
  bool _217 = (cb0_037y < 4000.0f);
  float _226 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _228 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_205 * 1.5317699909210205f)) / (_226 * _226);
  float _235 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _205;
  float _237 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_205 * 308.60699462890625f)) / (_235 * _235);
  float _239 = rsqrt(dot(float2(_228, _237), float2(_228, _237)));
  float _240 = cb0_037z * 0.05000000074505806f;
  float _243 = ((_240 * _237) * _239) + _198;
  float _246 = _208 - ((_240 * _228) * _239);
  float _251 = (4.0f - (_246 * 8.0f)) + (_243 * 2.0f);
  float _257 = (((_243 * 3.0f) / _251) - _214) + select(_217, _214, _184);
  float _258 = (((_246 * 2.0f) / _251) - _216) + select(_217, _216, (((_184 * 2.869999885559082f) + -0.2750000059604645f) - ((_184 * _184) * 3.0f)));
  float _259 = select(_165, _257, 0.3127000033855438f);
  float _260 = select(_165, _258, 0.32899999618530273f);
  float _261 = select(_165, 0.3127000033855438f, _257);
  float _262 = select(_165, 0.32899999618530273f, _258);
  float _263 = max(_260, 1.000000013351432e-10f);
  float _264 = _259 / _263;
  float _267 = ((1.0f - _259) - _260) / _263;
  float _268 = max(_262, 1.000000013351432e-10f);
  float _269 = _261 / _268;
  float _272 = ((1.0f - _261) - _262) / _268;
  float _291 = mad(-0.16140000522136688f, _272, ((_269 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _267, ((_264 * 0.8950999975204468f) + 0.266400009393692f));
  float _292 = mad(0.03669999912381172f, _272, (1.7135000228881836f - (_269 * 0.7501999735832214f))) / mad(0.03669999912381172f, _267, (1.7135000228881836f - (_264 * 0.7501999735832214f)));
  float _293 = mad(1.0296000242233276f, _272, ((_269 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _267, ((_264 * 0.03889999911189079f) + -0.06849999725818634f));
  float _294 = mad(_292, -0.7501999735832214f, 0.0f);
  float _295 = mad(_292, 1.7135000228881836f, 0.0f);
  float _296 = mad(_292, 0.03669999912381172f, -0.0f);
  float _297 = mad(_293, 0.03889999911189079f, 0.0f);
  float _298 = mad(_293, -0.06849999725818634f, 0.0f);
  float _299 = mad(_293, 1.0296000242233276f, 0.0f);
  float _302 = mad(0.1599626988172531f, _297, mad(-0.1470542997121811f, _294, (_291 * 0.883457362651825f)));
  float _305 = mad(0.1599626988172531f, _298, mad(-0.1470542997121811f, _295, (_291 * 0.26293492317199707f)));
  float _308 = mad(0.1599626988172531f, _299, mad(-0.1470542997121811f, _296, (_291 * -0.15930065512657166f)));
  float _311 = mad(0.04929120093584061f, _297, mad(0.5183603167533875f, _294, (_291 * 0.38695648312568665f)));
  float _314 = mad(0.04929120093584061f, _298, mad(0.5183603167533875f, _295, (_291 * 0.11516613513231277f)));
  float _317 = mad(0.04929120093584061f, _299, mad(0.5183603167533875f, _296, (_291 * -0.0697740763425827f)));
  float _320 = mad(0.9684867262840271f, _297, mad(0.04004279896616936f, _294, (_291 * -0.007634039502590895f)));
  float _323 = mad(0.9684867262840271f, _298, mad(0.04004279896616936f, _295, (_291 * -0.0022720457054674625f)));
  float _326 = mad(0.9684867262840271f, _299, mad(0.04004279896616936f, _296, (_291 * 0.0013765322510153055f)));
  float _329 = mad(_308, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_305, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_302 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _332 = mad(_308, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_305, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_302 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _335 = mad(_308, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_305, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_302 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _338 = mad(_317, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_314, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_311 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _341 = mad(_317, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_314, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_311 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _344 = mad(_317, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_314, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_311 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _347 = mad(_326, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_323, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_320 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _350 = mad(_326, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_323, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_320 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _353 = mad(_326, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_323, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_320 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  _391 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _353, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _344, (_335 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _129, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _350, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _341, (_332 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _128, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _338, (_329 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))) * _127)));
  _392 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _353, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _344, (_335 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _129, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _350, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _341, (_332 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _128, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _338, (_329 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))) * _127)));
  _393 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _353, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _344, (_335 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _129, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _350, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _341, (_332 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _128, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _338, (_329 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))) * _127)));
  float _408 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _393, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _392, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _391)));
  float _411 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _393, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _392, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _391)));
  float _414 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _393, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _392, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _391)));

  SetUngradedAP1(float3(_408, _411, _414));

  float _415 = dot(float3(_408, _411, _414), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _419 = (_408 / _415) + -1.0f;
  float _420 = (_411 / _415) + -1.0f;
  float _421 = (_414 / _415) + -1.0f;
  float _433 = (1.0f - exp2(((_415 * _415) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_419, _420, _421), float3(_419, _420, _421)) * -4.0f));
  float _449 = ((mad(-0.06368321925401688f, _414, mad(-0.3292922377586365f, _411, (_408 * 1.3704125881195068f))) - _408) * _433) + _408;
  float _450 = ((mad(-0.010861365124583244f, _414, mad(1.0970927476882935f, _411, (_408 * -0.08343357592821121f))) - _411) * _433) + _411;
  float _451 = ((mad(1.2036951780319214f, _414, mad(-0.09862580895423889f, _411, (_408 * -0.02579331398010254f))) - _414) * _433) + _414;
  float _452 = dot(float3(_449, _450, _451), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _466 = cb0_021w + cb0_026w;
  float _480 = cb0_020w * cb0_025w;
  float _494 = cb0_019w * cb0_024w;
  float _508 = cb0_018w * cb0_023w;
  float _522 = cb0_017w * cb0_022w;
  float _526 = _449 - _452;
  float _527 = _450 - _452;
  float _528 = _451 - _452;
  float _585 = saturate(_452 / cb0_037w);
  float _589 = (_585 * _585) * (3.0f - (_585 * 2.0f));
  float _590 = 1.0f - _589;
  float _599 = cb0_021w + cb0_036w;
  float _608 = cb0_020w * cb0_035w;
  float _617 = cb0_019w * cb0_034w;
  float _626 = cb0_018w * cb0_033w;
  float _635 = cb0_017w * cb0_032w;
  float _698 = saturate((_452 - cb0_038x) / (cb0_038y - cb0_038x));
  float _702 = (_698 * _698) * (3.0f - (_698 * 2.0f));
  float _711 = cb0_021w + cb0_031w;
  float _720 = cb0_020w * cb0_030w;
  float _729 = cb0_019w * cb0_029w;
  float _738 = cb0_018w * cb0_028w;
  float _747 = cb0_017w * cb0_027w;
  float _805 = _589 - _702;
  float _816 = ((_702 * (((cb0_021x + cb0_036x) + _599) + (((cb0_020x * cb0_035x) * _608) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _626) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _635) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _617)))))) + (_590 * (((cb0_021x + cb0_026x) + _466) + (((cb0_020x * cb0_025x) * _480) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _508) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _522) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _494))))))) + ((((cb0_021x + cb0_031x) + _711) + (((cb0_020x * cb0_030x) * _720) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _738) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _747) * _526) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _729))))) * _805);
  float _818 = ((_702 * (((cb0_021y + cb0_036y) + _599) + (((cb0_020y * cb0_035y) * _608) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _626) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _635) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _617)))))) + (_590 * (((cb0_021y + cb0_026y) + _466) + (((cb0_020y * cb0_025y) * _480) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _508) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _522) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _494))))))) + ((((cb0_021y + cb0_031y) + _711) + (((cb0_020y * cb0_030y) * _720) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _738) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _747) * _527) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _729))))) * _805);
  float _820 = ((_702 * (((cb0_021z + cb0_036z) + _599) + (((cb0_020z * cb0_035z) * _608) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _626) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _635) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _617)))))) + (_590 * (((cb0_021z + cb0_026z) + _466) + (((cb0_020z * cb0_025z) * _480) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _508) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _522) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _494))))))) + ((((cb0_021z + cb0_031z) + _711) + (((cb0_020z * cb0_030z) * _720) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _738) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _747) * _528) + _452)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _729))))) * _805);

  SetUntonemappedAP1(float3(_816, _818, _820));

  float _856 = ((mad(0.061360642313957214f, _820, mad(-4.540197551250458e-09f, _818, (_816 * 0.9386394023895264f))) - _816) * cb0_038z) + _816;
  float _857 = ((mad(0.169205904006958f, _820, mad(0.8307942152023315f, _818, (_816 * 6.775371730327606e-08f))) - _818) * cb0_038z) + _818;
  float _858 = (mad(-2.3283064365386963e-10f, _818, (_816 * -9.313225746154785e-10f)) * cb0_038z) + _820;
  float _861 = mad(0.16386905312538147f, _858, mad(0.14067868888378143f, _857, (_856 * 0.6954522132873535f)));
  float _864 = mad(0.0955343246459961f, _858, mad(0.8596711158752441f, _857, (_856 * 0.044794581830501556f)));
  float _867 = mad(1.0015007257461548f, _858, mad(0.004025210160762072f, _857, (_856 * -0.005525882821530104f)));
  float _871 = max(max(_861, _864), _867);
  float _876 = (max(_871, 1.000000013351432e-10f) - max(min(min(_861, _864), _867), 1.000000013351432e-10f)) / max(_871, 0.009999999776482582f);
  float _889 = ((_864 + _861) + _867) + (sqrt((((_867 - _864) * _867) + ((_864 - _861) * _864)) + ((_861 - _867) * _861)) * 1.75f);
  float _890 = _889 * 0.3333333432674408f;
  float _891 = _876 + -0.4000000059604645f;
  float _892 = _891 * 5.0f;
  float _896 = max((1.0f - abs(_891 * 2.5f)), 0.0f);
  float _907 = ((float((int)(((int)(uint)((bool)(_892 > 0.0f))) - ((int)(uint)((bool)(_892 < 0.0f))))) * (1.0f - (_896 * _896))) + 1.0f) * 0.02500000037252903f;
  if (!(_890 <= 0.0533333346247673f)) {
    if (!(_890 >= 0.1599999964237213f)) {
      _916 = (((0.23999999463558197f / _889) + -0.5f) * _907);
    } else {
      _916 = 0.0f;
    }
  } else {
    _916 = _907;
  }
  float _917 = _916 + 1.0f;
  float _918 = _917 * _861;
  float _919 = _917 * _864;
  float _920 = _917 * _867;
  if (!((bool)(_918 == _919) && (bool)(_919 == _920))) {
    float _927 = ((_918 * 2.0f) - _919) - _920;
    float _930 = ((_864 - _867) * 1.7320507764816284f) * _917;
    float _932 = atan(_930 / _927);
    bool _935 = (_927 < 0.0f);
    bool _936 = (_927 == 0.0f);
    bool _937 = (_930 >= 0.0f);
    bool _938 = (_930 < 0.0f);
    _949 = select((_937 && _936), 90.0f, select((_938 && _936), -90.0f, (select((_938 && _935), (_932 + -3.1415927410125732f), select((_937 && _935), (_932 + 3.1415927410125732f), _932)) * 57.2957763671875f)));
  } else {
    _949 = 0.0f;
  }
  float _954 = min(max(select((_949 < 0.0f), (_949 + 360.0f), _949), 0.0f), 360.0f);
  if (_954 < -180.0f) {
    _963 = (_954 + 360.0f);
  } else {
    if (_954 > 180.0f) {
      _963 = (_954 + -360.0f);
    } else {
      _963 = _954;
    }
  }
  float _967 = saturate(1.0f - abs(_963 * 0.014814814552664757f));
  float _971 = (_967 * _967) * (3.0f - (_967 * 2.0f));
  float _977 = ((_971 * _971) * ((_876 * 0.18000000715255737f) * (0.029999999329447746f - _918))) + _918;
  float _987 = max(0.0f, mad(-0.21492856740951538f, _920, mad(-0.2365107536315918f, _919, (_977 * 1.4514392614364624f))));
  float _988 = max(0.0f, mad(-0.09967592358589172f, _920, mad(1.17622971534729f, _919, (_977 * -0.07655377686023712f))));
  float _989 = max(0.0f, mad(0.9977163076400757f, _920, mad(-0.006032449658960104f, _919, (_977 * 0.008316148072481155f))));
  float _990 = dot(float3(_987, _988, _989), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1005 = (cb0_040x + 1.0f) - cb0_039z;
  float _1007 = cb0_040y + 1.0f;
  float _1009 = _1007 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1027 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    float _1018 = (cb0_040x + 0.18000000715255737f) / _1005;
    _1027 = (-0.7447274923324585f - ((log2(_1018 / (2.0f - _1018)) * 0.3465735912322998f) * (_1005 / cb0_039y)));
  }
  float _1030 = ((1.0f - cb0_039z) / cb0_039y) - _1027;
  float _1032 = (cb0_039w / cb0_039y) - _1030;
  float _1036 = log2(lerp(_990, _987, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1037 = log2(lerp(_990, _988, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1038 = log2(lerp(_990, _989, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1042 = cb0_039y * (_1036 + _1030);
  float _1043 = cb0_039y * (_1037 + _1030);
  float _1044 = cb0_039y * (_1038 + _1030);
  float _1045 = _1005 * 2.0f;
  float _1047 = (cb0_039y * -2.0f) / _1005;
  float _1048 = _1036 - _1027;
  float _1049 = _1037 - _1027;
  float _1050 = _1038 - _1027;
  float _1069 = _1009 * 2.0f;
  float _1071 = (cb0_039y * 2.0f) / _1009;
  float _1096 = select((_1036 < _1027), ((_1045 / (exp2((_1048 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1042);
  float _1097 = select((_1037 < _1027), ((_1045 / (exp2((_1049 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1043);
  float _1098 = select((_1038 < _1027), ((_1045 / (exp2((_1050 * 1.4426950216293335f) * _1047) + 1.0f)) - cb0_040x), _1044);
  float _1105 = _1032 - _1027;
  float _1109 = saturate(_1048 / _1105);
  float _1110 = saturate(_1049 / _1105);
  float _1111 = saturate(_1050 / _1105);
  bool _1112 = (_1032 < _1027);
  float _1116 = select(_1112, (1.0f - _1109), _1109);
  float _1117 = select(_1112, (1.0f - _1110), _1110);
  float _1118 = select(_1112, (1.0f - _1111), _1111);
  float _1137 = (((_1116 * _1116) * (select((_1036 > _1032), (_1007 - (_1069 / (exp2(((_1036 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1042) - _1096)) * (3.0f - (_1116 * 2.0f))) + _1096;
  float _1138 = (((_1117 * _1117) * (select((_1037 > _1032), (_1007 - (_1069 / (exp2(((_1037 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1043) - _1097)) * (3.0f - (_1117 * 2.0f))) + _1097;
  float _1139 = (((_1118 * _1118) * (select((_1038 > _1032), (_1007 - (_1069 / (exp2(((_1038 - _1032) * 1.4426950216293335f) * _1071) + 1.0f))), _1044) - _1098)) * (3.0f - (_1118 * 2.0f))) + _1098;
  float _1140 = dot(float3(_1137, _1138, _1139), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1160 = (cb0_039x * (max(0.0f, (lerp(_1140, _1137, 0.9300000071525574f))) - _856)) + _856;
  float _1161 = (cb0_039x * (max(0.0f, (lerp(_1140, _1138, 0.9300000071525574f))) - _857)) + _857;
  float _1162 = (cb0_039x * (max(0.0f, (lerp(_1140, _1139, 0.9300000071525574f))) - _858)) + _858;
  float _1178 = ((mad(-0.06537103652954102f, _1162, mad(1.451815478503704e-06f, _1161, (_1160 * 1.065374732017517f))) - _1160) * cb0_038z) + _1160;
  float _1179 = ((mad(-0.20366770029067993f, _1162, mad(1.2036634683609009f, _1161, (_1160 * -2.57161445915699e-07f))) - _1161) * cb0_038z) + _1161;
  float _1180 = ((mad(0.9999996423721313f, _1162, mad(2.0954757928848267e-08f, _1161, (_1160 * 1.862645149230957e-08f))) - _1162) * cb0_038z) + _1162;

  SetTonemappedAP1(_1178, _1179, _1180);

  float _1190 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1180, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1179, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1178))));
  float _1191 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1180, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1179, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1178))));
  float _1192 = max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1180, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1179, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1178))));
  float _1218 = cb0_016x * (((cb0_041y + (cb0_041x * _1190)) * _1190) + cb0_041z);
  float _1219 = cb0_016y * (((cb0_041y + (cb0_041x * _1191)) * _1191) + cb0_041z);
  float _1220 = cb0_016z * (((cb0_041y + (cb0_041x * _1192)) * _1192) + cb0_041z);
  float _1227 = ((cb0_015x - _1218) * cb0_015w) + _1218;
  float _1228 = ((cb0_015y - _1219) * cb0_015w) + _1219;
  float _1229 = ((cb0_015z - _1220) * cb0_015w) + _1220;
  float _1230 = cb0_016x * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _820, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _818, (_816 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x))));
  float _1231 = cb0_016y * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _820, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _818, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _816)));
  float _1232 = cb0_016z * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _820, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _818, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _816)));
  float _1239 = ((cb0_015x - _1230) * cb0_015w) + _1230;
  float _1240 = ((cb0_015y - _1231) * cb0_015w) + _1231;
  float _1241 = ((cb0_015z - _1232) * cb0_015w) + _1232;
  float _1253 = exp2(log2(max(0.0f, _1227)) * cb0_042y);
  float _1254 = exp2(log2(max(0.0f, _1228)) * cb0_042y);
  float _1255 = exp2(log2(max(0.0f, _1229)) * cb0_042y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[SV_DispatchThreadID] = GenerateOutput(float3(_1253, _1254, _1255), cb0_042w);
    return;
  }

  [branch]
  if (cb0_042w == 0) {
    do {
      if (WorkingColorSpace_000.FWorkingColorSpaceConstants_384 == 0) {
        float _1278 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1253)));
        float _1281 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1253)));
        float _1284 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1253)));
        _1295 = mad(_63, _1284, mad(_62, _1281, (_1278 * _61)));
        _1296 = mad(_66, _1284, mad(_65, _1281, (_1278 * _64)));
        _1297 = mad(_69, _1284, mad(_68, _1281, (_1278 * _67)));
      } else {
        _1295 = _1253;
        _1296 = _1254;
        _1297 = _1255;
      }
      do {
        if (_1295 < 0.0031306699384003878f) {
          _1308 = (_1295 * 12.920000076293945f);
        } else {
          _1308 = (((pow(_1295, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1296 < 0.0031306699384003878f) {
            _1319 = (_1296 * 12.920000076293945f);
          } else {
            _1319 = (((pow(_1296, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1297 < 0.0031306699384003878f) {
            _2870 = _1308;
            _2871 = _1319;
            _2872 = (_1297 * 12.920000076293945f);
          } else {
            _2870 = _1308;
            _2871 = _1319;
            _2872 = (((pow(_1297, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_042w == 1) {
      float _1346 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1253)));
      float _1349 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1253)));
      float _1352 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1253)));
      float _1355 = mad(_63, _1352, mad(_62, _1349, (_1346 * _61)));
      float _1358 = mad(_66, _1352, mad(_65, _1349, (_1346 * _64)));
      float _1361 = mad(_69, _1352, mad(_68, _1349, (_1346 * _67)));
      _2870 = min((_1355 * 4.5f), ((exp2(log2(max(_1355, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2871 = min((_1358 * 4.5f), ((exp2(log2(max(_1358, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2872 = min((_1361 * 4.5f), ((exp2(log2(max(_1361, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((uint)((int)(cb0_042w) + -3u)) < (uint)2) {
        _9[0] = cb0_010x;
        _9[1] = cb0_010y;
        _9[2] = cb0_010z;
        _9[3] = cb0_010w;
        _9[4] = cb0_012x;
        _9[5] = cb0_012x;
        float _1430 = cb0_012z * _1239;
        float _1431 = cb0_012z * _1240;
        float _1432 = cb0_012z * _1241;
        float _1435 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _1432, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _1431, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _1430)));
        float _1438 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _1432, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _1431, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _1430)));
        float _1441 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _1432, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _1431, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _1430)));
        float _1444 = mad(-0.21492856740951538f, _1441, mad(-0.2365107536315918f, _1438, (_1435 * 1.4514392614364624f)));
        float _1447 = mad(-0.09967592358589172f, _1441, mad(1.17622971534729f, _1438, (_1435 * -0.07655377686023712f)));
        float _1450 = mad(0.9977163076400757f, _1441, mad(-0.006032449658960104f, _1438, (_1435 * 0.008316148072481155f)));
        float _1452 = max(_1444, max(_1447, _1450));
        do {
          if (!(_1452 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1435 < 0.0f) || (bool)(_1438 < 0.0f))) || (bool)(_1441 < 0.0f))) {
              float _1462 = abs(_1452);
              float _1463 = (_1452 - _1444) / _1462;
              float _1465 = (_1452 - _1447) / _1462;
              float _1467 = (_1452 - _1450) / _1462;
              do {
                if (!(_1463 < 0.8149999976158142f)) {
                  float _1470 = _1463 + -0.8149999976158142f;
                  _1482 = ((_1470 / exp2(log2(exp2(log2(_1470 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1482 = _1463;
                }
                do {
                  if (!(_1465 < 0.8029999732971191f)) {
                    float _1485 = _1465 + -0.8029999732971191f;
                    _1497 = ((_1485 / exp2(log2(exp2(log2(_1485 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1497 = _1465;
                  }
                  do {
                    if (!(_1467 < 0.8799999952316284f)) {
                      float _1500 = _1467 + -0.8799999952316284f;
                      _1512 = ((_1500 / exp2(log2(exp2(log2(_1500 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1512 = _1467;
                    }
                    _1520 = (_1452 - (_1462 * _1482));
                    _1521 = (_1452 - (_1462 * _1497));
                    _1522 = (_1452 - (_1462 * _1512));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1520 = _1444;
              _1521 = _1447;
              _1522 = _1450;
            }
          } else {
            _1520 = _1444;
            _1521 = _1447;
            _1522 = _1450;
          }
          float _1538 = ((mad(0.16386906802654266f, _1522, mad(0.14067870378494263f, _1521, (_1520 * 0.6954522132873535f))) - _1435) * cb0_012w) + _1435;
          float _1539 = ((mad(0.0955343171954155f, _1522, mad(0.8596711158752441f, _1521, (_1520 * 0.044794563204050064f))) - _1438) * cb0_012w) + _1438;
          float _1540 = ((mad(1.0015007257461548f, _1522, mad(0.004025210160762072f, _1521, (_1520 * -0.005525882821530104f))) - _1441) * cb0_012w) + _1441;
          float _1544 = max(max(_1538, _1539), _1540);
          float _1549 = (max(_1544, 1.000000013351432e-10f) - max(min(min(_1538, _1539), _1540), 1.000000013351432e-10f)) / max(_1544, 0.009999999776482582f);
          float _1562 = ((_1539 + _1538) + _1540) + (sqrt((((_1540 - _1539) * _1540) + ((_1539 - _1538) * _1539)) + ((_1538 - _1540) * _1538)) * 1.75f);
          float _1563 = _1562 * 0.3333333432674408f;
          float _1564 = _1549 + -0.4000000059604645f;
          float _1565 = _1564 * 5.0f;
          float _1569 = max((1.0f - abs(_1564 * 2.5f)), 0.0f);
          float _1580 = ((float((int)(((int)(uint)((bool)(_1565 > 0.0f))) - ((int)(uint)((bool)(_1565 < 0.0f))))) * (1.0f - (_1569 * _1569))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1563 <= 0.0533333346247673f)) {
              if (!(_1563 >= 0.1599999964237213f)) {
                _1589 = (((0.23999999463558197f / _1562) + -0.5f) * _1580);
              } else {
                _1589 = 0.0f;
              }
            } else {
              _1589 = _1580;
            }
            float _1590 = _1589 + 1.0f;
            float _1591 = _1590 * _1538;
            float _1592 = _1590 * _1539;
            float _1593 = _1590 * _1540;
            do {
              if (!((bool)(_1591 == _1592) && (bool)(_1592 == _1593))) {
                float _1600 = ((_1591 * 2.0f) - _1592) - _1593;
                float _1603 = ((_1539 - _1540) * 1.7320507764816284f) * _1590;
                float _1605 = atan(_1603 / _1600);
                bool _1608 = (_1600 < 0.0f);
                bool _1609 = (_1600 == 0.0f);
                bool _1610 = (_1603 >= 0.0f);
                bool _1611 = (_1603 < 0.0f);
                _1622 = select((_1610 && _1609), 90.0f, select((_1611 && _1609), -90.0f, (select((_1611 && _1608), (_1605 + -3.1415927410125732f), select((_1610 && _1608), (_1605 + 3.1415927410125732f), _1605)) * 57.2957763671875f)));
              } else {
                _1622 = 0.0f;
              }
              float _1627 = min(max(select((_1622 < 0.0f), (_1622 + 360.0f), _1622), 0.0f), 360.0f);
              do {
                if (_1627 < -180.0f) {
                  _1636 = (_1627 + 360.0f);
                } else {
                  if (_1627 > 180.0f) {
                    _1636 = (_1627 + -360.0f);
                  } else {
                    _1636 = _1627;
                  }
                }
                do {
                  if ((bool)(_1636 > -67.5f) && (bool)(_1636 < 67.5f)) {
                    float _1642 = (_1636 + 67.5f) * 0.029629629105329514f;
                    int _1643 = int(_1642);
                    float _1645 = _1642 - float((int)(_1643));
                    float _1646 = _1645 * _1645;
                    float _1647 = _1646 * _1645;
                    if (_1643 == 3) {
                      _1675 = (((0.1666666716337204f - (_1645 * 0.5f)) + (_1646 * 0.5f)) - (_1647 * 0.1666666716337204f));
                    } else {
                      if (_1643 == 2) {
                        _1675 = ((0.6666666865348816f - _1646) + (_1647 * 0.5f));
                      } else {
                        if (_1643 == 1) {
                          _1675 = (((_1647 * -0.5f) + 0.1666666716337204f) + ((_1646 + _1645) * 0.5f));
                        } else {
                          _1675 = select((_1643 == 0), (_1647 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1675 = 0.0f;
                  }
                  float _1684 = min(max(((((_1549 * 0.27000001072883606f) * (0.029999999329447746f - _1591)) * _1675) + _1591), 0.0f), 65535.0f);
                  float _1685 = min(max(_1592, 0.0f), 65535.0f);
                  float _1686 = min(max(_1593, 0.0f), 65535.0f);
                  float _1699 = min(max(mad(-0.21492856740951538f, _1686, mad(-0.2365107536315918f, _1685, (_1684 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1700 = min(max(mad(-0.09967592358589172f, _1686, mad(1.17622971534729f, _1685, (_1684 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1701 = min(max(mad(0.9977163076400757f, _1686, mad(-0.006032449658960104f, _1685, (_1684 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1702 = dot(float3(_1699, _1700, _1701), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1725 = log2(max((lerp(_1702, _1699, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1726 = _1725 * 0.3010300099849701f;
                  float _1727 = log2(cb0_008x);
                  float _1728 = _1727 * 0.3010300099849701f;
                  do {
                    if (!(!(_1726 <= _1728))) {
                      _1797 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1735 = log2(cb0_009x);
                      float _1736 = _1735 * 0.3010300099849701f;
                      if ((bool)(_1726 > _1728) && (bool)(_1726 < _1736)) {
                        float _1744 = ((_1725 - _1727) * 0.9030900001525879f) / ((_1735 - _1727) * 0.3010300099849701f);
                        int _1745 = int(_1744);
                        float _1747 = _1744 - float((int)(_1745));
                        float _1749 = _16[_1745];
                        float _1752 = _16[(_1745 + 1)];
                        float _1757 = _1749 * 0.5f;
                        _1797 = dot(float3((_1747 * _1747), _1747, 1.0f), float3(mad((_16[(_1745 + 2)]), 0.5f, mad(_1752, -1.0f, _1757)), (_1752 - _1749), mad(_1752, 0.5f, _1757)));
                      } else {
                        do {
                          if (!(!(_1726 >= _1736))) {
                            float _1766 = log2(cb0_008z);
                            if (_1726 < (_1766 * 0.3010300099849701f)) {
                              float _1774 = ((_1725 - _1735) * 0.9030900001525879f) / ((_1766 - _1735) * 0.3010300099849701f);
                              int _1775 = int(_1774);
                              float _1777 = _1774 - float((int)(_1775));
                              float _1779 = _17[_1775];
                              float _1782 = _17[(_1775 + 1)];
                              float _1787 = _1779 * 0.5f;
                              _1797 = dot(float3((_1777 * _1777), _1777, 1.0f), float3(mad((_17[(_1775 + 2)]), 0.5f, mad(_1782, -1.0f, _1787)), (_1782 - _1779), mad(_1782, 0.5f, _1787)));
                              break;
                            }
                          }
                          _1797 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _18[0] = cb0_011x;
                    _18[1] = cb0_011y;
                    _18[2] = cb0_011z;
                    _18[3] = cb0_011w;
                    _18[4] = cb0_012y;
                    _18[5] = cb0_012y;
                    float _1807 = log2(max((lerp(_1702, _1700, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1808 = _1807 * 0.3010300099849701f;
                    do {
                      if (!(!(_1808 <= _1728))) {
                        _1877 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1815 = log2(cb0_009x);
                        float _1816 = _1815 * 0.3010300099849701f;
                        if ((bool)(_1808 > _1728) && (bool)(_1808 < _1816)) {
                          float _1824 = ((_1807 - _1727) * 0.9030900001525879f) / ((_1815 - _1727) * 0.3010300099849701f);
                          int _1825 = int(_1824);
                          float _1827 = _1824 - float((int)(_1825));
                          float _1829 = _9[_1825];
                          float _1832 = _9[(_1825 + 1)];
                          float _1837 = _1829 * 0.5f;
                          _1877 = dot(float3((_1827 * _1827), _1827, 1.0f), float3(mad((_9[(_1825 + 2)]), 0.5f, mad(_1832, -1.0f, _1837)), (_1832 - _1829), mad(_1832, 0.5f, _1837)));
                        } else {
                          do {
                            if (!(!(_1808 >= _1816))) {
                              float _1846 = log2(cb0_008z);
                              if (_1808 < (_1846 * 0.3010300099849701f)) {
                                float _1854 = ((_1807 - _1815) * 0.9030900001525879f) / ((_1846 - _1815) * 0.3010300099849701f);
                                int _1855 = int(_1854);
                                float _1857 = _1854 - float((int)(_1855));
                                float _1859 = _18[_1855];
                                float _1862 = _18[(_1855 + 1)];
                                float _1867 = _1859 * 0.5f;
                                _1877 = dot(float3((_1857 * _1857), _1857, 1.0f), float3(mad((_18[(_1855 + 2)]), 0.5f, mad(_1862, -1.0f, _1867)), (_1862 - _1859), mad(_1862, 0.5f, _1867)));
                                break;
                              }
                            }
                            _1877 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      _19[0] = cb0_010x;
                      _19[1] = cb0_010y;
                      _19[2] = cb0_010z;
                      _19[3] = cb0_010w;
                      _19[4] = cb0_012x;
                      _19[5] = cb0_012x;
                      _20[0] = cb0_011x;
                      _20[1] = cb0_011y;
                      _20[2] = cb0_011z;
                      _20[3] = cb0_011w;
                      _20[4] = cb0_012y;
                      _20[5] = cb0_012y;
                      float _1893 = log2(max((lerp(_1702, _1701, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1894 = _1893 * 0.3010300099849701f;
                      do {
                        if (!(!(_1894 <= _1728))) {
                          _1963 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1901 = log2(cb0_009x);
                          float _1902 = _1901 * 0.3010300099849701f;
                          if ((bool)(_1894 > _1728) && (bool)(_1894 < _1902)) {
                            float _1910 = ((_1893 - _1727) * 0.9030900001525879f) / ((_1901 - _1727) * 0.3010300099849701f);
                            int _1911 = int(_1910);
                            float _1913 = _1910 - float((int)(_1911));
                            float _1915 = _19[_1911];
                            float _1918 = _19[(_1911 + 1)];
                            float _1923 = _1915 * 0.5f;
                            _1963 = dot(float3((_1913 * _1913), _1913, 1.0f), float3(mad((_19[(_1911 + 2)]), 0.5f, mad(_1918, -1.0f, _1923)), (_1918 - _1915), mad(_1918, 0.5f, _1923)));
                          } else {
                            do {
                              if (!(!(_1894 >= _1902))) {
                                float _1932 = log2(cb0_008z);
                                if (_1894 < (_1932 * 0.3010300099849701f)) {
                                  float _1940 = ((_1893 - _1901) * 0.9030900001525879f) / ((_1932 - _1901) * 0.3010300099849701f);
                                  int _1941 = int(_1940);
                                  float _1943 = _1940 - float((int)(_1941));
                                  float _1945 = _20[_1941];
                                  float _1948 = _20[(_1941 + 1)];
                                  float _1953 = _1945 * 0.5f;
                                  _1963 = dot(float3((_1943 * _1943), _1943, 1.0f), float3(mad((_20[(_1941 + 2)]), 0.5f, mad(_1948, -1.0f, _1953)), (_1948 - _1945), mad(_1948, 0.5f, _1953)));
                                  break;
                                }
                              }
                              _1963 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1967 = cb0_008w - cb0_008y;
                        float _1968 = (exp2(_1797 * 3.321928024291992f) - cb0_008y) / _1967;
                        float _1970 = (exp2(_1877 * 3.321928024291992f) - cb0_008y) / _1967;
                        float _1972 = (exp2(_1963 * 3.321928024291992f) - cb0_008y) / _1967;
                        float _1975 = mad(0.15618768334388733f, _1972, mad(0.13400420546531677f, _1970, (_1968 * 0.6624541878700256f)));
                        float _1978 = mad(0.053689517080783844f, _1972, mad(0.6740817427635193f, _1970, (_1968 * 0.2722287178039551f)));
                        float _1981 = mad(1.0103391408920288f, _1972, mad(0.00406073359772563f, _1970, (_1968 * -0.005574649665504694f)));
                        float _1994 = min(max(mad(-0.23642469942569733f, _1981, mad(-0.32480329275131226f, _1978, (_1975 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1995 = min(max(mad(0.016756348311901093f, _1981, mad(1.6153316497802734f, _1978, (_1975 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1996 = min(max(mad(0.9883948564529419f, _1981, mad(-0.008284442126750946f, _1978, (_1975 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1999 = mad(0.15618768334388733f, _1996, mad(0.13400420546531677f, _1995, (_1994 * 0.6624541878700256f)));
                        float _2002 = mad(0.053689517080783844f, _1996, mad(0.6740817427635193f, _1995, (_1994 * 0.2722287178039551f)));
                        float _2005 = mad(1.0103391408920288f, _1996, mad(0.00406073359772563f, _1995, (_1994 * -0.005574649665504694f)));
                        float _2027 = min(max((min(max(mad(-0.23642469942569733f, _2005, mad(-0.32480329275131226f, _2002, (_1999 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2028 = min(max((min(max(mad(0.016756348311901093f, _2005, mad(1.6153316497802734f, _2002, (_1999 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2029 = min(max((min(max(mad(0.9883948564529419f, _2005, mad(-0.008284442126750946f, _2002, (_1999 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2048 = exp2(log2(mad(_63, _2029, mad(_62, _2028, (_2027 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2049 = exp2(log2(mad(_66, _2029, mad(_65, _2028, (_2027 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2050 = exp2(log2(mad(_69, _2029, mad(_68, _2028, (_2027 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2870 = exp2(log2((1.0f / ((_2048 * 18.6875f) + 1.0f)) * ((_2048 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2871 = exp2(log2((1.0f / ((_2049 * 18.6875f) + 1.0f)) * ((_2049 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2872 = exp2(log2((1.0f / ((_2050 * 18.6875f) + 1.0f)) * ((_2050 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2116 = cb0_012z * _1239;
          float _2117 = cb0_012z * _1240;
          float _2118 = cb0_012z * _1241;
          float _2121 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _2118, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _2117, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _2116)));
          float _2124 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _2118, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _2117, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _2116)));
          float _2127 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _2118, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _2117, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _2116)));
          float _2130 = mad(-0.21492856740951538f, _2127, mad(-0.2365107536315918f, _2124, (_2121 * 1.4514392614364624f)));
          float _2133 = mad(-0.09967592358589172f, _2127, mad(1.17622971534729f, _2124, (_2121 * -0.07655377686023712f)));
          float _2136 = mad(0.9977163076400757f, _2127, mad(-0.006032449658960104f, _2124, (_2121 * 0.008316148072481155f)));
          float _2138 = max(_2130, max(_2133, _2136));
          do {
            if (!(_2138 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2121 < 0.0f) || (bool)(_2124 < 0.0f))) || (bool)(_2127 < 0.0f))) {
                float _2148 = abs(_2138);
                float _2149 = (_2138 - _2130) / _2148;
                float _2151 = (_2138 - _2133) / _2148;
                float _2153 = (_2138 - _2136) / _2148;
                do {
                  if (!(_2149 < 0.8149999976158142f)) {
                    float _2156 = _2149 + -0.8149999976158142f;
                    _2168 = ((_2156 / exp2(log2(exp2(log2(_2156 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2168 = _2149;
                  }
                  do {
                    if (!(_2151 < 0.8029999732971191f)) {
                      float _2171 = _2151 + -0.8029999732971191f;
                      _2183 = ((_2171 / exp2(log2(exp2(log2(_2171 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2183 = _2151;
                    }
                    do {
                      if (!(_2153 < 0.8799999952316284f)) {
                        float _2186 = _2153 + -0.8799999952316284f;
                        _2198 = ((_2186 / exp2(log2(exp2(log2(_2186 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2198 = _2153;
                      }
                      _2206 = (_2138 - (_2148 * _2168));
                      _2207 = (_2138 - (_2148 * _2183));
                      _2208 = (_2138 - (_2148 * _2198));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2206 = _2130;
                _2207 = _2133;
                _2208 = _2136;
              }
            } else {
              _2206 = _2130;
              _2207 = _2133;
              _2208 = _2136;
            }
            float _2224 = ((mad(0.16386906802654266f, _2208, mad(0.14067870378494263f, _2207, (_2206 * 0.6954522132873535f))) - _2121) * cb0_012w) + _2121;
            float _2225 = ((mad(0.0955343171954155f, _2208, mad(0.8596711158752441f, _2207, (_2206 * 0.044794563204050064f))) - _2124) * cb0_012w) + _2124;
            float _2226 = ((mad(1.0015007257461548f, _2208, mad(0.004025210160762072f, _2207, (_2206 * -0.005525882821530104f))) - _2127) * cb0_012w) + _2127;
            float _2230 = max(max(_2224, _2225), _2226);
            float _2235 = (max(_2230, 1.000000013351432e-10f) - max(min(min(_2224, _2225), _2226), 1.000000013351432e-10f)) / max(_2230, 0.009999999776482582f);
            float _2248 = ((_2225 + _2224) + _2226) + (sqrt((((_2226 - _2225) * _2226) + ((_2225 - _2224) * _2225)) + ((_2224 - _2226) * _2224)) * 1.75f);
            float _2249 = _2248 * 0.3333333432674408f;
            float _2250 = _2235 + -0.4000000059604645f;
            float _2251 = _2250 * 5.0f;
            float _2255 = max((1.0f - abs(_2250 * 2.5f)), 0.0f);
            float _2266 = ((float((int)(((int)(uint)((bool)(_2251 > 0.0f))) - ((int)(uint)((bool)(_2251 < 0.0f))))) * (1.0f - (_2255 * _2255))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2249 <= 0.0533333346247673f)) {
                if (!(_2249 >= 0.1599999964237213f)) {
                  _2275 = (((0.23999999463558197f / _2248) + -0.5f) * _2266);
                } else {
                  _2275 = 0.0f;
                }
              } else {
                _2275 = _2266;
              }
              float _2276 = _2275 + 1.0f;
              float _2277 = _2276 * _2224;
              float _2278 = _2276 * _2225;
              float _2279 = _2276 * _2226;
              do {
                if (!((bool)(_2277 == _2278) && (bool)(_2278 == _2279))) {
                  float _2286 = ((_2277 * 2.0f) - _2278) - _2279;
                  float _2289 = ((_2225 - _2226) * 1.7320507764816284f) * _2276;
                  float _2291 = atan(_2289 / _2286);
                  bool _2294 = (_2286 < 0.0f);
                  bool _2295 = (_2286 == 0.0f);
                  bool _2296 = (_2289 >= 0.0f);
                  bool _2297 = (_2289 < 0.0f);
                  _2308 = select((_2296 && _2295), 90.0f, select((_2297 && _2295), -90.0f, (select((_2297 && _2294), (_2291 + -3.1415927410125732f), select((_2296 && _2294), (_2291 + 3.1415927410125732f), _2291)) * 57.2957763671875f)));
                } else {
                  _2308 = 0.0f;
                }
                float _2313 = min(max(select((_2308 < 0.0f), (_2308 + 360.0f), _2308), 0.0f), 360.0f);
                do {
                  if (_2313 < -180.0f) {
                    _2322 = (_2313 + 360.0f);
                  } else {
                    if (_2313 > 180.0f) {
                      _2322 = (_2313 + -360.0f);
                    } else {
                      _2322 = _2313;
                    }
                  }
                  do {
                    if ((bool)(_2322 > -67.5f) && (bool)(_2322 < 67.5f)) {
                      float _2328 = (_2322 + 67.5f) * 0.029629629105329514f;
                      int _2329 = int(_2328);
                      float _2331 = _2328 - float((int)(_2329));
                      float _2332 = _2331 * _2331;
                      float _2333 = _2332 * _2331;
                      if (_2329 == 3) {
                        _2361 = (((0.1666666716337204f - (_2331 * 0.5f)) + (_2332 * 0.5f)) - (_2333 * 0.1666666716337204f));
                      } else {
                        if (_2329 == 2) {
                          _2361 = ((0.6666666865348816f - _2332) + (_2333 * 0.5f));
                        } else {
                          if (_2329 == 1) {
                            _2361 = (((_2333 * -0.5f) + 0.1666666716337204f) + ((_2332 + _2331) * 0.5f));
                          } else {
                            _2361 = select((_2329 == 0), (_2333 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2361 = 0.0f;
                    }
                    float _2370 = min(max(((((_2235 * 0.27000001072883606f) * (0.029999999329447746f - _2277)) * _2361) + _2277), 0.0f), 65535.0f);
                    float _2371 = min(max(_2278, 0.0f), 65535.0f);
                    float _2372 = min(max(_2279, 0.0f), 65535.0f);
                    float _2385 = min(max(mad(-0.21492856740951538f, _2372, mad(-0.2365107536315918f, _2371, (_2370 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2386 = min(max(mad(-0.09967592358589172f, _2372, mad(1.17622971534729f, _2371, (_2370 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2387 = min(max(mad(0.9977163076400757f, _2372, mad(-0.006032449658960104f, _2371, (_2370 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2388 = dot(float3(_2385, _2386, _2387), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2411 = log2(max((lerp(_2388, _2385, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2412 = _2411 * 0.3010300099849701f;
                    float _2413 = log2(cb0_008x);
                    float _2414 = _2413 * 0.3010300099849701f;
                    do {
                      if (!(!(_2412 <= _2414))) {
                        _2483 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2421 = log2(cb0_009x);
                        float _2422 = _2421 * 0.3010300099849701f;
                        if ((bool)(_2412 > _2414) && (bool)(_2412 < _2422)) {
                          float _2430 = ((_2411 - _2413) * 0.9030900001525879f) / ((_2421 - _2413) * 0.3010300099849701f);
                          int _2431 = int(_2430);
                          float _2433 = _2430 - float((int)(_2431));
                          float _2435 = _10[_2431];
                          float _2438 = _10[(_2431 + 1)];
                          float _2443 = _2435 * 0.5f;
                          _2483 = dot(float3((_2433 * _2433), _2433, 1.0f), float3(mad((_10[(_2431 + 2)]), 0.5f, mad(_2438, -1.0f, _2443)), (_2438 - _2435), mad(_2438, 0.5f, _2443)));
                        } else {
                          do {
                            if (!(!(_2412 >= _2422))) {
                              float _2452 = log2(cb0_008z);
                              if (_2412 < (_2452 * 0.3010300099849701f)) {
                                float _2460 = ((_2411 - _2421) * 0.9030900001525879f) / ((_2452 - _2421) * 0.3010300099849701f);
                                int _2461 = int(_2460);
                                float _2463 = _2460 - float((int)(_2461));
                                float _2465 = _11[_2461];
                                float _2468 = _11[(_2461 + 1)];
                                float _2473 = _2465 * 0.5f;
                                _2483 = dot(float3((_2463 * _2463), _2463, 1.0f), float3(mad((_11[(_2461 + 2)]), 0.5f, mad(_2468, -1.0f, _2473)), (_2468 - _2465), mad(_2468, 0.5f, _2473)));
                                break;
                              }
                            }
                            _2483 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _2499 = log2(max((lerp(_2388, _2386, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2500 = _2499 * 0.3010300099849701f;
                      do {
                        if (!(!(_2500 <= _2414))) {
                          _2569 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2507 = log2(cb0_009x);
                          float _2508 = _2507 * 0.3010300099849701f;
                          if ((bool)(_2500 > _2414) && (bool)(_2500 < _2508)) {
                            float _2516 = ((_2499 - _2413) * 0.9030900001525879f) / ((_2507 - _2413) * 0.3010300099849701f);
                            int _2517 = int(_2516);
                            float _2519 = _2516 - float((int)(_2517));
                            float _2521 = _12[_2517];
                            float _2524 = _12[(_2517 + 1)];
                            float _2529 = _2521 * 0.5f;
                            _2569 = dot(float3((_2519 * _2519), _2519, 1.0f), float3(mad((_12[(_2517 + 2)]), 0.5f, mad(_2524, -1.0f, _2529)), (_2524 - _2521), mad(_2524, 0.5f, _2529)));
                          } else {
                            do {
                              if (!(!(_2500 >= _2508))) {
                                float _2538 = log2(cb0_008z);
                                if (_2500 < (_2538 * 0.3010300099849701f)) {
                                  float _2546 = ((_2499 - _2507) * 0.9030900001525879f) / ((_2538 - _2507) * 0.3010300099849701f);
                                  int _2547 = int(_2546);
                                  float _2549 = _2546 - float((int)(_2547));
                                  float _2551 = _13[_2547];
                                  float _2554 = _13[(_2547 + 1)];
                                  float _2559 = _2551 * 0.5f;
                                  _2569 = dot(float3((_2549 * _2549), _2549, 1.0f), float3(mad((_13[(_2547 + 2)]), 0.5f, mad(_2554, -1.0f, _2559)), (_2554 - _2551), mad(_2554, 0.5f, _2559)));
                                  break;
                                }
                              }
                              _2569 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2585 = log2(max((lerp(_2388, _2387, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2586 = _2585 * 0.3010300099849701f;
                        do {
                          if (!(!(_2586 <= _2414))) {
                            _2655 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2593 = log2(cb0_009x);
                            float _2594 = _2593 * 0.3010300099849701f;
                            if ((bool)(_2586 > _2414) && (bool)(_2586 < _2594)) {
                              float _2602 = ((_2585 - _2413) * 0.9030900001525879f) / ((_2593 - _2413) * 0.3010300099849701f);
                              int _2603 = int(_2602);
                              float _2605 = _2602 - float((int)(_2603));
                              float _2607 = _14[_2603];
                              float _2610 = _14[(_2603 + 1)];
                              float _2615 = _2607 * 0.5f;
                              _2655 = dot(float3((_2605 * _2605), _2605, 1.0f), float3(mad((_14[(_2603 + 2)]), 0.5f, mad(_2610, -1.0f, _2615)), (_2610 - _2607), mad(_2610, 0.5f, _2615)));
                            } else {
                              do {
                                if (!(!(_2586 >= _2594))) {
                                  float _2624 = log2(cb0_008z);
                                  if (_2586 < (_2624 * 0.3010300099849701f)) {
                                    float _2632 = ((_2585 - _2593) * 0.9030900001525879f) / ((_2624 - _2593) * 0.3010300099849701f);
                                    int _2633 = int(_2632);
                                    float _2635 = _2632 - float((int)(_2633));
                                    float _2637 = _15[_2633];
                                    float _2640 = _15[(_2633 + 1)];
                                    float _2645 = _2637 * 0.5f;
                                    _2655 = dot(float3((_2635 * _2635), _2635, 1.0f), float3(mad((_15[(_2633 + 2)]), 0.5f, mad(_2640, -1.0f, _2645)), (_2640 - _2637), mad(_2640, 0.5f, _2645)));
                                    break;
                                  }
                                }
                                _2655 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2659 = cb0_008w - cb0_008y;
                          float _2660 = (exp2(_2483 * 3.321928024291992f) - cb0_008y) / _2659;
                          float _2662 = (exp2(_2569 * 3.321928024291992f) - cb0_008y) / _2659;
                          float _2664 = (exp2(_2655 * 3.321928024291992f) - cb0_008y) / _2659;
                          float _2667 = mad(0.15618768334388733f, _2664, mad(0.13400420546531677f, _2662, (_2660 * 0.6624541878700256f)));
                          float _2670 = mad(0.053689517080783844f, _2664, mad(0.6740817427635193f, _2662, (_2660 * 0.2722287178039551f)));
                          float _2673 = mad(1.0103391408920288f, _2664, mad(0.00406073359772563f, _2662, (_2660 * -0.005574649665504694f)));
                          float _2686 = min(max(mad(-0.23642469942569733f, _2673, mad(-0.32480329275131226f, _2670, (_2667 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2687 = min(max(mad(0.016756348311901093f, _2673, mad(1.6153316497802734f, _2670, (_2667 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2688 = min(max(mad(0.9883948564529419f, _2673, mad(-0.008284442126750946f, _2670, (_2667 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2691 = mad(0.15618768334388733f, _2688, mad(0.13400420546531677f, _2687, (_2686 * 0.6624541878700256f)));
                          float _2694 = mad(0.053689517080783844f, _2688, mad(0.6740817427635193f, _2687, (_2686 * 0.2722287178039551f)));
                          float _2697 = mad(1.0103391408920288f, _2688, mad(0.00406073359772563f, _2687, (_2686 * -0.005574649665504694f)));
                          float _2719 = min(max((min(max(mad(-0.23642469942569733f, _2697, mad(-0.32480329275131226f, _2694, (_2691 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2722 = min(max((min(max(mad(0.016756348311901093f, _2697, mad(1.6153316497802734f, _2694, (_2691 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          float _2723 = min(max((min(max(mad(0.9883948564529419f, _2697, mad(-0.008284442126750946f, _2694, (_2691 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          _2870 = mad(-0.0832589864730835f, _2723, mad(-0.6217921376228333f, _2722, (_2719 * 0.0213131383061409f)));
                          _2871 = mad(-0.010548308491706848f, _2723, mad(1.140804648399353f, _2722, (_2719 * -0.0016282059950754046f)));
                          _2872 = mad(1.1529725790023804f, _2723, mad(-0.1289689838886261f, _2722, (_2719 * -0.00030004189466126263f)));
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
            float _2750 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1241, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1240, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1239)));
            float _2753 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1241, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1240, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1239)));
            float _2756 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1241, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1240, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1239)));
            float _2775 = exp2(log2(mad(_63, _2756, mad(_62, _2753, (_2750 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2776 = exp2(log2(mad(_66, _2756, mad(_65, _2753, (_2750 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2777 = exp2(log2(mad(_69, _2756, mad(_68, _2753, (_2750 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2870 = exp2(log2((1.0f / ((_2775 * 18.6875f) + 1.0f)) * ((_2775 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2871 = exp2(log2((1.0f / ((_2776 * 18.6875f) + 1.0f)) * ((_2776 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2872 = exp2(log2((1.0f / ((_2777 * 18.6875f) + 1.0f)) * ((_2777 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_042w == 8)) {
              if (cb0_042w == 9) {
                float _2824 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1229, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1228, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1227)));
                float _2827 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1229, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1228, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1227)));
                float _2830 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1229, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1228, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1227)));
                _2870 = mad(_63, _2830, mad(_62, _2827, (_2824 * _61)));
                _2871 = mad(_66, _2830, mad(_65, _2827, (_2824 * _64)));
                _2872 = mad(_69, _2830, mad(_68, _2827, (_2824 * _67)));
              } else {
                float _2843 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1253)));
                float _2846 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1253)));
                float _2849 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1255, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1254, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1253)));
                _2870 = exp2(log2(mad(_63, _2849, mad(_62, _2846, (_2843 * _61)))) * cb0_042z);
                _2871 = exp2(log2(mad(_66, _2849, mad(_65, _2846, (_2843 * _64)))) * cb0_042z);
                _2872 = exp2(log2(mad(_69, _2849, mad(_68, _2846, (_2843 * _67)))) * cb0_042z);
              }
            } else {
              _2870 = _1239;
              _2871 = _1240;
              _2872 = _1241;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2870 * 0.9523810148239136f), (_2871 * 0.9523810148239136f), (_2872 * 0.9523810148239136f), 0.0f);
}
