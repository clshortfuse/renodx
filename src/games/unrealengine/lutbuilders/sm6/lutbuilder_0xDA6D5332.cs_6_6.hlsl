// Found in Silent Hill 2

#include "../../common.hlsl"

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
  float cb0_013x : packoffset(c013.x);
  float cb0_013y : packoffset(c013.y);
  float cb0_013z : packoffset(c013.z);
  float cb0_013w : packoffset(c013.w);
  float cb0_014x : packoffset(c014.x);
  float cb0_014y : packoffset(c014.y);
  float cb0_014z : packoffset(c014.z);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
  float cb0_016w : packoffset(c016.w);
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
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
  int cb0_041x : packoffset(c041.x);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
};

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
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
  float _22 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _23 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _26 = float((uint)SV_DispatchThreadID.z);
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _113;
  float _114;
  float _115;
  float _639;
  float _675;
  float _686;
  float _750;
  float _1018;
  float _1019;
  float _1020;
  float _1031;
  float _1042;
  float _1224;
  float _1260;
  float _1271;
  float _1310;
  float _1420;
  float _1494;
  float _1568;
  float _1647;
  float _1648;
  float _1649;
  float _1800;
  float _1836;
  float _1847;
  float _1886;
  float _1996;
  float _2070;
  float _2144;
  float _2223;
  float _2224;
  float _2225;
  float _2402;
  float _2403;
  float _2404;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _36 = (cb0_041x == 4);
        _47 = select(_36, 1.0f, 1.7050515413284302f);
        _48 = select(_36, 0.0f, -0.6217905879020691f);
        _49 = select(_36, 0.0f, -0.0832584798336029f);
        _50 = select(_36, 0.0f, -0.13025718927383423f);
        _51 = select(_36, 1.0f, 1.1408027410507202f);
        _52 = select(_36, 0.0f, -0.010548528283834457f);
        _53 = select(_36, 0.0f, -0.024003278464078903f);
        _54 = select(_36, 0.0f, -0.1289687603712082f);
        _55 = select(_36, 1.0f, 1.152971863746643f);
      } else {
        _47 = 0.6954522132873535f;
        _48 = 0.14067870378494263f;
        _49 = 0.16386906802654266f;
        _50 = 0.044794563204050064f;
        _51 = 0.8596711158752441f;
        _52 = 0.0955343171954155f;
        _53 = -0.005525882821530104f;
        _54 = 0.004025210160762072f;
        _55 = 1.0015007257461548f;
      }
    } else {
      _47 = 1.02579927444458f;
      _48 = -0.020052503794431686f;
      _49 = -0.0057713985443115234f;
      _50 = -0.0022350111976265907f;
      _51 = 1.0045825242996216f;
      _52 = -0.002352306619286537f;
      _53 = -0.005014004185795784f;
      _54 = -0.025293385609984398f;
      _55 = 1.0304402112960815f;
    }
  } else {
    _47 = 1.379158854484558f;
    _48 = -0.3088507056236267f;
    _49 = -0.07034677267074585f;
    _50 = -0.06933528929948807f;
    _51 = 1.0822921991348267f;
    _52 = -0.012962047010660172f;
    _53 = -0.002159259282052517f;
    _54 = -0.045465391129255295f;
    _55 = 1.0477596521377563f;
  }
  if ((uint)cb0_040w > (uint)2) {
    float _66 = exp2(log2(_22 * 1.0322580337524414f) * 0.012683313339948654f);
    float _67 = exp2(log2(_23 * 1.0322580337524414f) * 0.012683313339948654f);
    float _68 = exp2(log2(_26 * 0.032258063554763794f) * 0.012683313339948654f);
    _113 = (exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _114 = (exp2(log2(max(0.0f, (_67 + -0.8359375f)) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _115 = (exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _113 = ((exp2((_22 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _114 = ((exp2((_23 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _115 = ((exp2((_26 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _130 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _115, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _114, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _113)));
  float _133 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _115, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _114, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _113)));
  float _136 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _115, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _114, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _113)));
  float _137 = dot(float3(_130, _133, _136), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  
  
  SetUngradedAP1(float3(_130, _133, _136));
  
  
  float _141 = (_130 / _137) + -1.0f;
  float _142 = (_133 / _137) + -1.0f;
  float _143 = (_136 / _137) + -1.0f;
  float _155 = (1.0f - exp2(((_137 * _137) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_141, _142, _143), float3(_141, _142, _143)) * -4.0f));
  float _171 = ((mad(-0.06368283927440643f, _136, mad(-0.32929131388664246f, _133, (_130 * 1.370412826538086f))) - _130) * _155) + _130;
  float _172 = ((mad(-0.010861567221581936f, _136, mad(1.0970908403396606f, _133, (_130 * -0.08343426138162613f))) - _133) * _155) + _133;
  float _173 = ((mad(1.203694462776184f, _136, mad(-0.09862564504146576f, _133, (_130 * -0.02579325996339321f))) - _136) * _155) + _136;
  float _174 = dot(float3(_171, _172, _173), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _188 = cb0_019w + cb0_024w;
  float _202 = cb0_018w * cb0_023w;
  float _216 = cb0_017w * cb0_022w;
  float _230 = cb0_016w * cb0_021w;
  float _244 = cb0_015w * cb0_020w;
  float _248 = _171 - _174;
  float _249 = _172 - _174;
  float _250 = _173 - _174;
  float _308 = saturate(_174 / cb0_035z);
  float _312 = (_308 * _308) * (3.0f - (_308 * 2.0f));
  float _313 = 1.0f - _312;
  float _322 = cb0_019w + cb0_034w;
  float _331 = cb0_018w * cb0_033w;
  float _340 = cb0_017w * cb0_032w;
  float _349 = cb0_016w * cb0_031w;
  float _358 = cb0_015w * cb0_030w;
  float _421 = saturate((_174 - cb0_035w) / (cb0_036x - cb0_035w));
  float _425 = (_421 * _421) * (3.0f - (_421 * 2.0f));
  float _434 = cb0_019w + cb0_029w;
  float _443 = cb0_018w * cb0_028w;
  float _452 = cb0_017w * cb0_027w;
  float _461 = cb0_016w * cb0_026w;
  float _470 = cb0_015w * cb0_025w;
  float _528 = _312 - _425;
  float _539 = ((_425 * (((cb0_019x + cb0_034x) + _322) + (((cb0_018x * cb0_033x) * _331) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _349) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _358) * _248) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _340)))))) + (_313 * (((cb0_019x + cb0_024x) + _188) + (((cb0_018x * cb0_023x) * _202) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _230) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _244) * _248) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _216))))))) + ((((cb0_019x + cb0_029x) + _434) + (((cb0_018x * cb0_028x) * _443) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _461) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _470) * _248) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _452))))) * _528);
  float _541 = ((_425 * (((cb0_019y + cb0_034y) + _322) + (((cb0_018y * cb0_033y) * _331) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _349) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _358) * _249) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _340)))))) + (_313 * (((cb0_019y + cb0_024y) + _188) + (((cb0_018y * cb0_023y) * _202) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _230) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _244) * _249) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _216))))))) + ((((cb0_019y + cb0_029y) + _434) + (((cb0_018y * cb0_028y) * _443) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _461) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _470) * _249) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _452))))) * _528);
  float _543 = ((_425 * (((cb0_019z + cb0_034z) + _322) + (((cb0_018z * cb0_033z) * _331) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _349) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _358) * _250) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _340)))))) + (_313 * (((cb0_019z + cb0_024z) + _188) + (((cb0_018z * cb0_023z) * _202) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _230) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _244) * _250) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _216))))))) + ((((cb0_019z + cb0_029z) + _434) + (((cb0_018z * cb0_028z) * _443) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _461) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _470) * _250) + _174)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _452))))) * _528);
  
  
  SetUntonemappedAP1(float3(_539, _541, _543));

  
  float _579 = ((mad(0.061360642313957214f, _543, mad(-4.540197551250458e-09f, _541, (_539 * 0.9386394023895264f))) - _539) * cb0_036y) + _539;
  float _580 = ((mad(0.169205904006958f, _543, mad(0.8307942152023315f, _541, (_539 * 6.775371730327606e-08f))) - _541) * cb0_036y) + _541;
  float _581 = (mad(-2.3283064365386963e-10f, _541, (_539 * -9.313225746154785e-10f)) * cb0_036y) + _543;
  float _584 = mad(0.16386905312538147f, _581, mad(0.14067868888378143f, _580, (_579 * 0.6954522132873535f)));
  float _587 = mad(0.0955343246459961f, _581, mad(0.8596711158752441f, _580, (_579 * 0.044794581830501556f)));
  float _590 = mad(1.0015007257461548f, _581, mad(0.004025210160762072f, _580, (_579 * -0.005525882821530104f)));
  float _594 = max(max(_584, _587), _590);
  float _599 = (max(_594, 1.000000013351432e-10f) - max(min(min(_584, _587), _590), 1.000000013351432e-10f)) / max(_594, 0.009999999776482582f);
  float _612 = ((_587 + _584) + _590) + (sqrt((((_590 - _587) * _590) + ((_587 - _584) * _587)) + ((_584 - _590) * _584)) * 1.75f);
  float _613 = _612 * 0.3333333432674408f;
  float _614 = _599 + -0.4000000059604645f;
  float _615 = _614 * 5.0f;
  float _619 = max((1.0f - abs(_614 * 2.5f)), 0.0f);
  float _630 = ((float((int)(((int)(uint)((bool)(_615 > 0.0f))) - ((int)(uint)((bool)(_615 < 0.0f))))) * (1.0f - (_619 * _619))) + 1.0f) * 0.02500000037252903f;
  if (!(_613 <= 0.0533333346247673f)) {
    if (!(_613 >= 0.1599999964237213f)) {
      _639 = (((0.23999999463558197f / _612) + -0.5f) * _630);
    } else {
      _639 = 0.0f;
    }
  } else {
    _639 = _630;
  }
  float _640 = _639 + 1.0f;
  float _641 = _640 * _584;
  float _642 = _640 * _587;
  float _643 = _640 * _590;
  if (!((bool)(_641 == _642) && (bool)(_642 == _643))) {
    float _650 = ((_641 * 2.0f) - _642) - _643;
    float _653 = ((_587 - _590) * 1.7320507764816284f) * _640;
    float _655 = atan(_653 / _650);
    bool _658 = (_650 < 0.0f);
    bool _659 = (_650 == 0.0f);
    bool _660 = (_653 >= 0.0f);
    bool _661 = (_653 < 0.0f);
    float _670 = select((_660 && _659), 90.0f, select((_661 && _659), -90.0f, (select((_661 && _658), (_655 + -3.1415927410125732f), select((_660 && _658), (_655 + 3.1415927410125732f), _655)) * 57.2957763671875f)));
    if (_670 < 0.0f) {
      _675 = (_670 + 360.0f);
    } else {
      _675 = _670;
    }
  } else {
    _675 = 0.0f;
  }
  float _677 = min(max(_675, 0.0f), 360.0f);
  if (_677 < -180.0f) {
    _686 = (_677 + 360.0f);
  } else {
    if (_677 > 180.0f) {
      _686 = (_677 + -360.0f);
    } else {
      _686 = _677;
    }
  }
  float _690 = saturate(1.0f - abs(_686 * 0.014814814552664757f));
  float _694 = (_690 * _690) * (3.0f - (_690 * 2.0f));
  float _700 = ((_694 * _694) * ((_599 * 0.18000000715255737f) * (0.029999999329447746f - _641))) + _641;
  float _710 = max(0.0f, mad(-0.21492856740951538f, _643, mad(-0.2365107536315918f, _642, (_700 * 1.4514392614364624f))));
  float _711 = max(0.0f, mad(-0.09967592358589172f, _643, mad(1.17622971534729f, _642, (_700 * -0.07655377686023712f))));
  float _712 = max(0.0f, mad(0.9977163076400757f, _643, mad(-0.006032449658960104f, _642, (_700 * 0.008316148072481155f))));
  float _713 = dot(float3(_710, _711, _712), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _727 = (cb0_037w + 1.0f) - cb0_037y;
  float _730 = cb0_038x + 1.0f;
  float _732 = _730 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _750 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _741 = (cb0_037w + 0.18000000715255737f) / _727;
    _750 = (-0.7447274923324585f - ((log2(_741 / (2.0f - _741)) * 0.3465735912322998f) * (_727 / cb0_037x)));
  }
  float _753 = ((1.0f - cb0_037y) / cb0_037x) - _750;
  float _755 = (cb0_037z / cb0_037x) - _753;
  float _759 = log2(lerp(_713, _710, 0.9599999785423279f)) * 0.3010300099849701f;
  float _760 = log2(lerp(_713, _711, 0.9599999785423279f)) * 0.3010300099849701f;
  float _761 = log2(lerp(_713, _712, 0.9599999785423279f)) * 0.3010300099849701f;
  float _765 = cb0_037x * (_759 + _753);
  float _766 = cb0_037x * (_760 + _753);
  float _767 = cb0_037x * (_761 + _753);
  float _768 = _727 * 2.0f;
  float _770 = (cb0_037x * -2.0f) / _727;
  float _771 = _759 - _750;
  float _772 = _760 - _750;
  float _773 = _761 - _750;
  float _792 = _732 * 2.0f;
  float _794 = (cb0_037x * 2.0f) / _732;
  float _819 = select((_759 < _750), ((_768 / (exp2((_771 * 1.4426950216293335f) * _770) + 1.0f)) - cb0_037w), _765);
  float _820 = select((_760 < _750), ((_768 / (exp2((_772 * 1.4426950216293335f) * _770) + 1.0f)) - cb0_037w), _766);
  float _821 = select((_761 < _750), ((_768 / (exp2((_773 * 1.4426950216293335f) * _770) + 1.0f)) - cb0_037w), _767);
  float _828 = _755 - _750;
  float _832 = saturate(_771 / _828);
  float _833 = saturate(_772 / _828);
  float _834 = saturate(_773 / _828);
  bool _835 = (_755 < _750);
  float _839 = select(_835, (1.0f - _832), _832);
  float _840 = select(_835, (1.0f - _833), _833);
  float _841 = select(_835, (1.0f - _834), _834);
  float _860 = (((_839 * _839) * (select((_759 > _755), (_730 - (_792 / (exp2(((_759 - _755) * 1.4426950216293335f) * _794) + 1.0f))), _765) - _819)) * (3.0f - (_839 * 2.0f))) + _819;
  float _861 = (((_840 * _840) * (select((_760 > _755), (_730 - (_792 / (exp2(((_760 - _755) * 1.4426950216293335f) * _794) + 1.0f))), _766) - _820)) * (3.0f - (_840 * 2.0f))) + _820;
  float _862 = (((_841 * _841) * (select((_761 > _755), (_730 - (_792 / (exp2(((_761 - _755) * 1.4426950216293335f) * _794) + 1.0f))), _767) - _821)) * (3.0f - (_841 * 2.0f))) + _821;
  float _863 = dot(float3(_860, _861, _862), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _883 = (cb0_036w * (max(0.0f, (lerp(_863, _860, 0.9300000071525574f))) - _579)) + _579;
  float _884 = (cb0_036w * (max(0.0f, (lerp(_863, _861, 0.9300000071525574f))) - _580)) + _580;
  float _885 = (cb0_036w * (max(0.0f, (lerp(_863, _862, 0.9300000071525574f))) - _581)) + _581;
  float _901 = ((mad(-0.06537103652954102f, _885, mad(1.451815478503704e-06f, _884, (_883 * 1.065374732017517f))) - _883) * cb0_036y) + _883;
  float _902 = ((mad(-0.20366770029067993f, _885, mad(1.2036634683609009f, _884, (_883 * -2.57161445915699e-07f))) - _884) * cb0_036y) + _884;
  float _903 = ((mad(0.9999996423721313f, _885, mad(2.0954757928848267e-08f, _884, (_883 * 1.862645149230957e-08f))) - _885) * cb0_036y) + _885;
  
  
  SetTonemappedAP1(_901, _902, _903);

  
  float _913 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _903, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _902, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _901))));
  float _914 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _903, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _902, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _901))));
  float _915 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _903, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _902, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _901))));
  float _941 = cb0_014x * (((cb0_039y + (cb0_039x * _913)) * _913) + cb0_039z);
  float _942 = cb0_014y * (((cb0_039y + (cb0_039x * _914)) * _914) + cb0_039z);
  float _943 = cb0_014z * (((cb0_039y + (cb0_039x * _915)) * _915) + cb0_039z);
  float _950 = ((cb0_013x - _941) * cb0_013w) + _941;
  float _951 = ((cb0_013y - _942) * cb0_013w) + _942;
  float _952 = ((cb0_013z - _943) * cb0_013w) + _943;
  float _953 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _543, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _541, (_539 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _954 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _543, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _541, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _539)));
  float _955 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _543, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _541, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _539)));
  float _962 = ((cb0_013x - _953) * cb0_013w) + _953;
  float _963 = ((cb0_013y - _954) * cb0_013w) + _954;
  float _964 = ((cb0_013z - _955) * cb0_013w) + _955;
  float _976 = exp2(log2(max(0.0f, _950)) * cb0_040y);
  float _977 = exp2(log2(max(0.0f, _951)) * cb0_040y);
  float _978 = exp2(log2(max(0.0f, _952)) * cb0_040y);
  
  if (RENODX_TONE_MAP_TYPE != 0) {
    u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = GenerateOutput(float3(_976, _977, _978), cb0_040w);
    return;
  }
  
  [branch]
  if (cb0_040w == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1001 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _976)));
        float _1004 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _976)));
        float _1007 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _976)));
        _1018 = mad(_49, _1007, mad(_48, _1004, (_1001 * _47)));
        _1019 = mad(_52, _1007, mad(_51, _1004, (_1001 * _50)));
        _1020 = mad(_55, _1007, mad(_54, _1004, (_1001 * _53)));
      } else {
        _1018 = _976;
        _1019 = _977;
        _1020 = _978;
      }
      do {
        if (_1018 < 0.0031306699384003878f) {
          _1031 = (_1018 * 12.920000076293945f);
        } else {
          _1031 = (((pow(_1018, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1019 < 0.0031306699384003878f) {
            _1042 = (_1019 * 12.920000076293945f);
          } else {
            _1042 = (((pow(_1019, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1020 < 0.0031306699384003878f) {
            _2402 = _1031;
            _2403 = _1042;
            _2404 = (_1020 * 12.920000076293945f);
          } else {
            _2402 = _1031;
            _2403 = _1042;
            _2404 = (((pow(_1020, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1069 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _976)));
      float _1072 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _976)));
      float _1075 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _976)));
      float _1085 = max(6.103519990574569e-05f, mad(_49, _1075, mad(_48, _1072, (_1069 * _47))));
      float _1086 = max(6.103519990574569e-05f, mad(_52, _1075, mad(_51, _1072, (_1069 * _50))));
      float _1087 = max(6.103519990574569e-05f, mad(_55, _1075, mad(_54, _1072, (_1069 * _53))));
      _2402 = min((_1085 * 4.5f), ((exp2(log2(max(_1085, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2403 = min((_1086 * 4.5f), ((exp2(log2(max(_1086, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2404 = min((_1087 * 4.5f), ((exp2(log2(max(_1087, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
        _11[0] = cb0_010x;
        _11[1] = cb0_010y;
        _11[2] = cb0_010z;
        _11[3] = cb0_010w;
        _11[4] = cb0_012x;
        _11[5] = cb0_012x;
        _12[0] = cb0_011x;
        _12[1] = cb0_011y;
        _12[2] = cb0_011z;
        _12[3] = cb0_011w;
        _12[4] = cb0_012y;
        _12[5] = cb0_012y;
        float _1164 = cb0_012z * _962;
        float _1165 = cb0_012z * _963;
        float _1166 = cb0_012z * _964;
        float _1169 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1166, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1165, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1164)));
        float _1172 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1166, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1165, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1164)));
        float _1175 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1166, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1165, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1164)));
        float _1179 = max(max(_1169, _1172), _1175);
        float _1184 = (max(_1179, 1.000000013351432e-10f) - max(min(min(_1169, _1172), _1175), 1.000000013351432e-10f)) / max(_1179, 0.009999999776482582f);
        float _1197 = ((_1172 + _1169) + _1175) + (sqrt((((_1175 - _1172) * _1175) + ((_1172 - _1169) * _1172)) + ((_1169 - _1175) * _1169)) * 1.75f);
        float _1198 = _1197 * 0.3333333432674408f;
        float _1199 = _1184 + -0.4000000059604645f;
        float _1200 = _1199 * 5.0f;
        float _1204 = max((1.0f - abs(_1199 * 2.5f)), 0.0f);
        float _1215 = ((float((int)(((int)(uint)((bool)(_1200 > 0.0f))) - ((int)(uint)((bool)(_1200 < 0.0f))))) * (1.0f - (_1204 * _1204))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1198 <= 0.0533333346247673f)) {
            if (!(_1198 >= 0.1599999964237213f)) {
              _1224 = (((0.23999999463558197f / _1197) + -0.5f) * _1215);
            } else {
              _1224 = 0.0f;
            }
          } else {
            _1224 = _1215;
          }
          float _1225 = _1224 + 1.0f;
          float _1226 = _1225 * _1169;
          float _1227 = _1225 * _1172;
          float _1228 = _1225 * _1175;
          do {
            if (!((bool)(_1226 == _1227) && (bool)(_1227 == _1228))) {
              float _1235 = ((_1226 * 2.0f) - _1227) - _1228;
              float _1238 = ((_1172 - _1175) * 1.7320507764816284f) * _1225;
              float _1240 = atan(_1238 / _1235);
              bool _1243 = (_1235 < 0.0f);
              bool _1244 = (_1235 == 0.0f);
              bool _1245 = (_1238 >= 0.0f);
              bool _1246 = (_1238 < 0.0f);
              float _1255 = select((_1245 && _1244), 90.0f, select((_1246 && _1244), -90.0f, (select((_1246 && _1243), (_1240 + -3.1415927410125732f), select((_1245 && _1243), (_1240 + 3.1415927410125732f), _1240)) * 57.2957763671875f)));
              if (_1255 < 0.0f) {
                _1260 = (_1255 + 360.0f);
              } else {
                _1260 = _1255;
              }
            } else {
              _1260 = 0.0f;
            }
            float _1262 = min(max(_1260, 0.0f), 360.0f);
            do {
              if (_1262 < -180.0f) {
                _1271 = (_1262 + 360.0f);
              } else {
                if (_1262 > 180.0f) {
                  _1271 = (_1262 + -360.0f);
                } else {
                  _1271 = _1262;
                }
              }
              do {
                if ((bool)(_1271 > -67.5f) && (bool)(_1271 < 67.5f)) {
                  float _1277 = (_1271 + 67.5f) * 0.029629629105329514f;
                  int _1278 = int(_1277);
                  float _1280 = _1277 - float((int)(_1278));
                  float _1281 = _1280 * _1280;
                  float _1282 = _1281 * _1280;
                  if (_1278 == 3) {
                    _1310 = (((0.1666666716337204f - (_1280 * 0.5f)) + (_1281 * 0.5f)) - (_1282 * 0.1666666716337204f));
                  } else {
                    if (_1278 == 2) {
                      _1310 = ((0.6666666865348816f - _1281) + (_1282 * 0.5f));
                    } else {
                      if (_1278 == 1) {
                        _1310 = (((_1282 * -0.5f) + 0.1666666716337204f) + ((_1281 + _1280) * 0.5f));
                      } else {
                        _1310 = select((_1278 == 0), (_1282 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1310 = 0.0f;
                }
                float _1319 = min(max(((((_1184 * 0.27000001072883606f) * (0.029999999329447746f - _1226)) * _1310) + _1226), 0.0f), 65535.0f);
                float _1320 = min(max(_1227, 0.0f), 65535.0f);
                float _1321 = min(max(_1228, 0.0f), 65535.0f);
                float _1334 = min(max(mad(-0.21492856740951538f, _1321, mad(-0.2365107536315918f, _1320, (_1319 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1335 = min(max(mad(-0.09967592358589172f, _1321, mad(1.17622971534729f, _1320, (_1319 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1336 = min(max(mad(0.9977163076400757f, _1321, mad(-0.006032449658960104f, _1320, (_1319 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1337 = dot(float3(_1334, _1335, _1336), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1348 = log2(max((lerp(_1337, _1334, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1349 = _1348 * 0.3010300099849701f;
                float _1350 = log2(cb0_008x);
                float _1351 = _1350 * 0.3010300099849701f;
                do {
                  if (!(!(_1349 <= _1351))) {
                    _1420 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1358 = log2(cb0_009x);
                    float _1359 = _1358 * 0.3010300099849701f;
                    if ((bool)(_1349 > _1351) && (bool)(_1349 < _1359)) {
                      float _1367 = ((_1348 - _1350) * 0.9030900001525879f) / ((_1358 - _1350) * 0.3010300099849701f);
                      int _1368 = int(_1367);
                      float _1370 = _1367 - float((int)(_1368));
                      float _1372 = _11[_1368];
                      float _1375 = _11[(_1368 + 1)];
                      float _1380 = _1372 * 0.5f;
                      _1420 = dot(float3((_1370 * _1370), _1370, 1.0f), float3(mad((_11[(_1368 + 2)]), 0.5f, mad(_1375, -1.0f, _1380)), (_1375 - _1372), mad(_1375, 0.5f, _1380)));
                    } else {
                      do {
                        if (!(!(_1349 >= _1359))) {
                          float _1389 = log2(cb0_008z);
                          if (_1349 < (_1389 * 0.3010300099849701f)) {
                            float _1397 = ((_1348 - _1358) * 0.9030900001525879f) / ((_1389 - _1358) * 0.3010300099849701f);
                            int _1398 = int(_1397);
                            float _1400 = _1397 - float((int)(_1398));
                            float _1402 = _12[_1398];
                            float _1405 = _12[(_1398 + 1)];
                            float _1410 = _1402 * 0.5f;
                            _1420 = dot(float3((_1400 * _1400), _1400, 1.0f), float3(mad((_12[(_1398 + 2)]), 0.5f, mad(_1405, -1.0f, _1410)), (_1405 - _1402), mad(_1405, 0.5f, _1410)));
                            break;
                          }
                        }
                        _1420 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1424 = log2(max((lerp(_1337, _1335, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1425 = _1424 * 0.3010300099849701f;
                  do {
                    if (!(!(_1425 <= _1351))) {
                      _1494 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1432 = log2(cb0_009x);
                      float _1433 = _1432 * 0.3010300099849701f;
                      if ((bool)(_1425 > _1351) && (bool)(_1425 < _1433)) {
                        float _1441 = ((_1424 - _1350) * 0.9030900001525879f) / ((_1432 - _1350) * 0.3010300099849701f);
                        int _1442 = int(_1441);
                        float _1444 = _1441 - float((int)(_1442));
                        float _1446 = _11[_1442];
                        float _1449 = _11[(_1442 + 1)];
                        float _1454 = _1446 * 0.5f;
                        _1494 = dot(float3((_1444 * _1444), _1444, 1.0f), float3(mad((_11[(_1442 + 2)]), 0.5f, mad(_1449, -1.0f, _1454)), (_1449 - _1446), mad(_1449, 0.5f, _1454)));
                      } else {
                        do {
                          if (!(!(_1425 >= _1433))) {
                            float _1463 = log2(cb0_008z);
                            if (_1425 < (_1463 * 0.3010300099849701f)) {
                              float _1471 = ((_1424 - _1432) * 0.9030900001525879f) / ((_1463 - _1432) * 0.3010300099849701f);
                              int _1472 = int(_1471);
                              float _1474 = _1471 - float((int)(_1472));
                              float _1476 = _12[_1472];
                              float _1479 = _12[(_1472 + 1)];
                              float _1484 = _1476 * 0.5f;
                              _1494 = dot(float3((_1474 * _1474), _1474, 1.0f), float3(mad((_12[(_1472 + 2)]), 0.5f, mad(_1479, -1.0f, _1484)), (_1479 - _1476), mad(_1479, 0.5f, _1484)));
                              break;
                            }
                          }
                          _1494 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1498 = log2(max((lerp(_1337, _1336, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1499 = _1498 * 0.3010300099849701f;
                    do {
                      if (!(!(_1499 <= _1351))) {
                        _1568 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1506 = log2(cb0_009x);
                        float _1507 = _1506 * 0.3010300099849701f;
                        if ((bool)(_1499 > _1351) && (bool)(_1499 < _1507)) {
                          float _1515 = ((_1498 - _1350) * 0.9030900001525879f) / ((_1506 - _1350) * 0.3010300099849701f);
                          int _1516 = int(_1515);
                          float _1518 = _1515 - float((int)(_1516));
                          float _1520 = _11[_1516];
                          float _1523 = _11[(_1516 + 1)];
                          float _1528 = _1520 * 0.5f;
                          _1568 = dot(float3((_1518 * _1518), _1518, 1.0f), float3(mad((_11[(_1516 + 2)]), 0.5f, mad(_1523, -1.0f, _1528)), (_1523 - _1520), mad(_1523, 0.5f, _1528)));
                        } else {
                          do {
                            if (!(!(_1499 >= _1507))) {
                              float _1537 = log2(cb0_008z);
                              if (_1499 < (_1537 * 0.3010300099849701f)) {
                                float _1545 = ((_1498 - _1506) * 0.9030900001525879f) / ((_1537 - _1506) * 0.3010300099849701f);
                                int _1546 = int(_1545);
                                float _1548 = _1545 - float((int)(_1546));
                                float _1550 = _12[_1546];
                                float _1553 = _12[(_1546 + 1)];
                                float _1558 = _1550 * 0.5f;
                                _1568 = dot(float3((_1548 * _1548), _1548, 1.0f), float3(mad((_12[(_1546 + 2)]), 0.5f, mad(_1553, -1.0f, _1558)), (_1553 - _1550), mad(_1553, 0.5f, _1558)));
                                break;
                              }
                            }
                            _1568 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1572 = cb0_008w - cb0_008y;
                      float _1573 = (exp2(_1420 * 3.321928024291992f) - cb0_008y) / _1572;
                      float _1575 = (exp2(_1494 * 3.321928024291992f) - cb0_008y) / _1572;
                      float _1577 = (exp2(_1568 * 3.321928024291992f) - cb0_008y) / _1572;
                      float _1580 = mad(0.15618768334388733f, _1577, mad(0.13400420546531677f, _1575, (_1573 * 0.6624541878700256f)));
                      float _1583 = mad(0.053689517080783844f, _1577, mad(0.6740817427635193f, _1575, (_1573 * 0.2722287178039551f)));
                      float _1586 = mad(1.0103391408920288f, _1577, mad(0.00406073359772563f, _1575, (_1573 * -0.005574649665504694f)));
                      float _1599 = min(max(mad(-0.23642469942569733f, _1586, mad(-0.32480329275131226f, _1583, (_1580 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1600 = min(max(mad(0.016756348311901093f, _1586, mad(1.6153316497802734f, _1583, (_1580 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1601 = min(max(mad(0.9883948564529419f, _1586, mad(-0.008284442126750946f, _1583, (_1580 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1604 = mad(0.15618768334388733f, _1601, mad(0.13400420546531677f, _1600, (_1599 * 0.6624541878700256f)));
                      float _1607 = mad(0.053689517080783844f, _1601, mad(0.6740817427635193f, _1600, (_1599 * 0.2722287178039551f)));
                      float _1610 = mad(1.0103391408920288f, _1601, mad(0.00406073359772563f, _1600, (_1599 * -0.005574649665504694f)));
                      float _1632 = min(max((min(max(mad(-0.23642469942569733f, _1610, mad(-0.32480329275131226f, _1607, (_1604 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1633 = min(max((min(max(mad(0.016756348311901093f, _1610, mad(1.6153316497802734f, _1607, (_1604 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1634 = min(max((min(max(mad(0.9883948564529419f, _1610, mad(-0.008284442126750946f, _1607, (_1604 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(cb0_040w == 5)) {
                          _1647 = mad(_49, _1634, mad(_48, _1633, (_1632 * _47)));
                          _1648 = mad(_52, _1634, mad(_51, _1633, (_1632 * _50)));
                          _1649 = mad(_55, _1634, mad(_54, _1633, (_1632 * _53)));
                        } else {
                          _1647 = _1632;
                          _1648 = _1633;
                          _1649 = _1634;
                        }
                        float _1659 = exp2(log2(_1647 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1660 = exp2(log2(_1648 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1661 = exp2(log2(_1649 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2402 = exp2(log2((1.0f / ((_1659 * 18.6875f) + 1.0f)) * ((_1659 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2403 = exp2(log2((1.0f / ((_1660 * 18.6875f) + 1.0f)) * ((_1660 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2404 = exp2(log2((1.0f / ((_1661 * 18.6875f) + 1.0f)) * ((_1661 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((cb0_040w & -3) == 4) {
          _9[0] = cb0_010x;
          _9[1] = cb0_010y;
          _9[2] = cb0_010z;
          _9[3] = cb0_010w;
          _9[4] = cb0_012x;
          _9[5] = cb0_012x;
          _10[0] = cb0_011x;
          _10[1] = cb0_011y;
          _10[2] = cb0_011z;
          _10[3] = cb0_011w;
          _10[4] = cb0_012y;
          _10[5] = cb0_012y;
          float _1740 = cb0_012z * _962;
          float _1741 = cb0_012z * _963;
          float _1742 = cb0_012z * _964;
          float _1745 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1742, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1741, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1740)));
          float _1748 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1742, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1741, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1740)));
          float _1751 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1742, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1741, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1740)));
          float _1755 = max(max(_1745, _1748), _1751);
          float _1760 = (max(_1755, 1.000000013351432e-10f) - max(min(min(_1745, _1748), _1751), 1.000000013351432e-10f)) / max(_1755, 0.009999999776482582f);
          float _1773 = ((_1748 + _1745) + _1751) + (sqrt((((_1751 - _1748) * _1751) + ((_1748 - _1745) * _1748)) + ((_1745 - _1751) * _1745)) * 1.75f);
          float _1774 = _1773 * 0.3333333432674408f;
          float _1775 = _1760 + -0.4000000059604645f;
          float _1776 = _1775 * 5.0f;
          float _1780 = max((1.0f - abs(_1775 * 2.5f)), 0.0f);
          float _1791 = ((float((int)(((int)(uint)((bool)(_1776 > 0.0f))) - ((int)(uint)((bool)(_1776 < 0.0f))))) * (1.0f - (_1780 * _1780))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1774 <= 0.0533333346247673f)) {
              if (!(_1774 >= 0.1599999964237213f)) {
                _1800 = (((0.23999999463558197f / _1773) + -0.5f) * _1791);
              } else {
                _1800 = 0.0f;
              }
            } else {
              _1800 = _1791;
            }
            float _1801 = _1800 + 1.0f;
            float _1802 = _1801 * _1745;
            float _1803 = _1801 * _1748;
            float _1804 = _1801 * _1751;
            do {
              if (!((bool)(_1802 == _1803) && (bool)(_1803 == _1804))) {
                float _1811 = ((_1802 * 2.0f) - _1803) - _1804;
                float _1814 = ((_1748 - _1751) * 1.7320507764816284f) * _1801;
                float _1816 = atan(_1814 / _1811);
                bool _1819 = (_1811 < 0.0f);
                bool _1820 = (_1811 == 0.0f);
                bool _1821 = (_1814 >= 0.0f);
                bool _1822 = (_1814 < 0.0f);
                float _1831 = select((_1821 && _1820), 90.0f, select((_1822 && _1820), -90.0f, (select((_1822 && _1819), (_1816 + -3.1415927410125732f), select((_1821 && _1819), (_1816 + 3.1415927410125732f), _1816)) * 57.2957763671875f)));
                if (_1831 < 0.0f) {
                  _1836 = (_1831 + 360.0f);
                } else {
                  _1836 = _1831;
                }
              } else {
                _1836 = 0.0f;
              }
              float _1838 = min(max(_1836, 0.0f), 360.0f);
              do {
                if (_1838 < -180.0f) {
                  _1847 = (_1838 + 360.0f);
                } else {
                  if (_1838 > 180.0f) {
                    _1847 = (_1838 + -360.0f);
                  } else {
                    _1847 = _1838;
                  }
                }
                do {
                  if ((bool)(_1847 > -67.5f) && (bool)(_1847 < 67.5f)) {
                    float _1853 = (_1847 + 67.5f) * 0.029629629105329514f;
                    int _1854 = int(_1853);
                    float _1856 = _1853 - float((int)(_1854));
                    float _1857 = _1856 * _1856;
                    float _1858 = _1857 * _1856;
                    if (_1854 == 3) {
                      _1886 = (((0.1666666716337204f - (_1856 * 0.5f)) + (_1857 * 0.5f)) - (_1858 * 0.1666666716337204f));
                    } else {
                      if (_1854 == 2) {
                        _1886 = ((0.6666666865348816f - _1857) + (_1858 * 0.5f));
                      } else {
                        if (_1854 == 1) {
                          _1886 = (((_1858 * -0.5f) + 0.1666666716337204f) + ((_1857 + _1856) * 0.5f));
                        } else {
                          _1886 = select((_1854 == 0), (_1858 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1886 = 0.0f;
                  }
                  float _1895 = min(max(((((_1760 * 0.27000001072883606f) * (0.029999999329447746f - _1802)) * _1886) + _1802), 0.0f), 65535.0f);
                  float _1896 = min(max(_1803, 0.0f), 65535.0f);
                  float _1897 = min(max(_1804, 0.0f), 65535.0f);
                  float _1910 = min(max(mad(-0.21492856740951538f, _1897, mad(-0.2365107536315918f, _1896, (_1895 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1911 = min(max(mad(-0.09967592358589172f, _1897, mad(1.17622971534729f, _1896, (_1895 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1912 = min(max(mad(0.9977163076400757f, _1897, mad(-0.006032449658960104f, _1896, (_1895 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1913 = dot(float3(_1910, _1911, _1912), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1924 = log2(max((lerp(_1913, _1910, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1925 = _1924 * 0.3010300099849701f;
                  float _1926 = log2(cb0_008x);
                  float _1927 = _1926 * 0.3010300099849701f;
                  do {
                    if (!(!(_1925 <= _1927))) {
                      _1996 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1934 = log2(cb0_009x);
                      float _1935 = _1934 * 0.3010300099849701f;
                      if ((bool)(_1925 > _1927) && (bool)(_1925 < _1935)) {
                        float _1943 = ((_1924 - _1926) * 0.9030900001525879f) / ((_1934 - _1926) * 0.3010300099849701f);
                        int _1944 = int(_1943);
                        float _1946 = _1943 - float((int)(_1944));
                        float _1948 = _9[_1944];
                        float _1951 = _9[(_1944 + 1)];
                        float _1956 = _1948 * 0.5f;
                        _1996 = dot(float3((_1946 * _1946), _1946, 1.0f), float3(mad((_9[(_1944 + 2)]), 0.5f, mad(_1951, -1.0f, _1956)), (_1951 - _1948), mad(_1951, 0.5f, _1956)));
                      } else {
                        do {
                          if (!(!(_1925 >= _1935))) {
                            float _1965 = log2(cb0_008z);
                            if (_1925 < (_1965 * 0.3010300099849701f)) {
                              float _1973 = ((_1924 - _1934) * 0.9030900001525879f) / ((_1965 - _1934) * 0.3010300099849701f);
                              int _1974 = int(_1973);
                              float _1976 = _1973 - float((int)(_1974));
                              float _1978 = _10[_1974];
                              float _1981 = _10[(_1974 + 1)];
                              float _1986 = _1978 * 0.5f;
                              _1996 = dot(float3((_1976 * _1976), _1976, 1.0f), float3(mad((_10[(_1974 + 2)]), 0.5f, mad(_1981, -1.0f, _1986)), (_1981 - _1978), mad(_1981, 0.5f, _1986)));
                              break;
                            }
                          }
                          _1996 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2000 = log2(max((lerp(_1913, _1911, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2001 = _2000 * 0.3010300099849701f;
                    do {
                      if (!(!(_2001 <= _1927))) {
                        _2070 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2008 = log2(cb0_009x);
                        float _2009 = _2008 * 0.3010300099849701f;
                        if ((bool)(_2001 > _1927) && (bool)(_2001 < _2009)) {
                          float _2017 = ((_2000 - _1926) * 0.9030900001525879f) / ((_2008 - _1926) * 0.3010300099849701f);
                          int _2018 = int(_2017);
                          float _2020 = _2017 - float((int)(_2018));
                          float _2022 = _9[_2018];
                          float _2025 = _9[(_2018 + 1)];
                          float _2030 = _2022 * 0.5f;
                          _2070 = dot(float3((_2020 * _2020), _2020, 1.0f), float3(mad((_9[(_2018 + 2)]), 0.5f, mad(_2025, -1.0f, _2030)), (_2025 - _2022), mad(_2025, 0.5f, _2030)));
                        } else {
                          do {
                            if (!(!(_2001 >= _2009))) {
                              float _2039 = log2(cb0_008z);
                              if (_2001 < (_2039 * 0.3010300099849701f)) {
                                float _2047 = ((_2000 - _2008) * 0.9030900001525879f) / ((_2039 - _2008) * 0.3010300099849701f);
                                int _2048 = int(_2047);
                                float _2050 = _2047 - float((int)(_2048));
                                float _2052 = _10[_2048];
                                float _2055 = _10[(_2048 + 1)];
                                float _2060 = _2052 * 0.5f;
                                _2070 = dot(float3((_2050 * _2050), _2050, 1.0f), float3(mad((_10[(_2048 + 2)]), 0.5f, mad(_2055, -1.0f, _2060)), (_2055 - _2052), mad(_2055, 0.5f, _2060)));
                                break;
                              }
                            }
                            _2070 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2074 = log2(max((lerp(_1913, _1912, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2075 = _2074 * 0.3010300099849701f;
                      do {
                        if (!(!(_2075 <= _1927))) {
                          _2144 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2082 = log2(cb0_009x);
                          float _2083 = _2082 * 0.3010300099849701f;
                          if ((bool)(_2075 > _1927) && (bool)(_2075 < _2083)) {
                            float _2091 = ((_2074 - _1926) * 0.9030900001525879f) / ((_2082 - _1926) * 0.3010300099849701f);
                            int _2092 = int(_2091);
                            float _2094 = _2091 - float((int)(_2092));
                            float _2096 = _9[_2092];
                            float _2099 = _9[(_2092 + 1)];
                            float _2104 = _2096 * 0.5f;
                            _2144 = dot(float3((_2094 * _2094), _2094, 1.0f), float3(mad((_9[(_2092 + 2)]), 0.5f, mad(_2099, -1.0f, _2104)), (_2099 - _2096), mad(_2099, 0.5f, _2104)));
                          } else {
                            do {
                              if (!(!(_2075 >= _2083))) {
                                float _2113 = log2(cb0_008z);
                                if (_2075 < (_2113 * 0.3010300099849701f)) {
                                  float _2121 = ((_2074 - _2082) * 0.9030900001525879f) / ((_2113 - _2082) * 0.3010300099849701f);
                                  int _2122 = int(_2121);
                                  float _2124 = _2121 - float((int)(_2122));
                                  float _2126 = _10[_2122];
                                  float _2129 = _10[(_2122 + 1)];
                                  float _2134 = _2126 * 0.5f;
                                  _2144 = dot(float3((_2124 * _2124), _2124, 1.0f), float3(mad((_10[(_2122 + 2)]), 0.5f, mad(_2129, -1.0f, _2134)), (_2129 - _2126), mad(_2129, 0.5f, _2134)));
                                  break;
                                }
                              }
                              _2144 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2148 = cb0_008w - cb0_008y;
                        float _2149 = (exp2(_1996 * 3.321928024291992f) - cb0_008y) / _2148;
                        float _2151 = (exp2(_2070 * 3.321928024291992f) - cb0_008y) / _2148;
                        float _2153 = (exp2(_2144 * 3.321928024291992f) - cb0_008y) / _2148;
                        float _2156 = mad(0.15618768334388733f, _2153, mad(0.13400420546531677f, _2151, (_2149 * 0.6624541878700256f)));
                        float _2159 = mad(0.053689517080783844f, _2153, mad(0.6740817427635193f, _2151, (_2149 * 0.2722287178039551f)));
                        float _2162 = mad(1.0103391408920288f, _2153, mad(0.00406073359772563f, _2151, (_2149 * -0.005574649665504694f)));
                        float _2175 = min(max(mad(-0.23642469942569733f, _2162, mad(-0.32480329275131226f, _2159, (_2156 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2176 = min(max(mad(0.016756348311901093f, _2162, mad(1.6153316497802734f, _2159, (_2156 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2177 = min(max(mad(0.9883948564529419f, _2162, mad(-0.008284442126750946f, _2159, (_2156 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2180 = mad(0.15618768334388733f, _2177, mad(0.13400420546531677f, _2176, (_2175 * 0.6624541878700256f)));
                        float _2183 = mad(0.053689517080783844f, _2177, mad(0.6740817427635193f, _2176, (_2175 * 0.2722287178039551f)));
                        float _2186 = mad(1.0103391408920288f, _2177, mad(0.00406073359772563f, _2176, (_2175 * -0.005574649665504694f)));
                        float _2208 = min(max((min(max(mad(-0.23642469942569733f, _2186, mad(-0.32480329275131226f, _2183, (_2180 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2209 = min(max((min(max(mad(0.016756348311901093f, _2186, mad(1.6153316497802734f, _2183, (_2180 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2210 = min(max((min(max(mad(0.9883948564529419f, _2186, mad(-0.008284442126750946f, _2183, (_2180 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 6)) {
                            _2223 = mad(_49, _2210, mad(_48, _2209, (_2208 * _47)));
                            _2224 = mad(_52, _2210, mad(_51, _2209, (_2208 * _50)));
                            _2225 = mad(_55, _2210, mad(_54, _2209, (_2208 * _53)));
                          } else {
                            _2223 = _2208;
                            _2224 = _2209;
                            _2225 = _2210;
                          }
                          float _2235 = exp2(log2(_2223 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2236 = exp2(log2(_2224 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2237 = exp2(log2(_2225 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2402 = exp2(log2((1.0f / ((_2235 * 18.6875f) + 1.0f)) * ((_2235 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2403 = exp2(log2((1.0f / ((_2236 * 18.6875f) + 1.0f)) * ((_2236 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2404 = exp2(log2((1.0f / ((_2237 * 18.6875f) + 1.0f)) * ((_2237 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (cb0_040w == 7) {
            float _2282 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _964, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _963, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _962)));
            float _2285 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _964, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _963, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _962)));
            float _2288 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _964, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _963, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _962)));
            float _2307 = exp2(log2(mad(_49, _2288, mad(_48, _2285, (_2282 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2308 = exp2(log2(mad(_52, _2288, mad(_51, _2285, (_2282 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2309 = exp2(log2(mad(_55, _2288, mad(_54, _2285, (_2282 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2402 = exp2(log2((1.0f / ((_2307 * 18.6875f) + 1.0f)) * ((_2307 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2403 = exp2(log2((1.0f / ((_2308 * 18.6875f) + 1.0f)) * ((_2308 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2404 = exp2(log2((1.0f / ((_2309 * 18.6875f) + 1.0f)) * ((_2309 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2356 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _952, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _951, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _950)));
                float _2359 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _952, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _951, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _950)));
                float _2362 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _952, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _951, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _950)));
                _2402 = mad(_49, _2362, mad(_48, _2359, (_2356 * _47)));
                _2403 = mad(_52, _2362, mad(_51, _2359, (_2356 * _50)));
                _2404 = mad(_55, _2362, mad(_54, _2359, (_2356 * _53)));
              } else {
                float _2375 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _976)));
                float _2378 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _976)));
                float _2381 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _978, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _977, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _976)));
                _2402 = exp2(log2(mad(_49, _2381, mad(_48, _2378, (_2375 * _47)))) * cb0_040z);
                _2403 = exp2(log2(mad(_52, _2381, mad(_51, _2378, (_2375 * _50)))) * cb0_040z);
                _2404 = exp2(log2(mad(_55, _2381, mad(_54, _2378, (_2375 * _53)))) * cb0_040z);
              }
            } else {
              _2402 = _962;
              _2403 = _963;
              _2404 = _964;
            }
          }
        }
      }
    }
  }
  
  // u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2402 * 0.9523810148239136f), (_2403 * 0.9523810148239136f), (_2404 * 0.9523810148239136f), 0.0f);

  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = saturate(float4((_2402 * 0.9523810148239136f), (_2403 * 0.9523810148239136f), (_2404 * 0.9523810148239136f), 0.0f));
}
