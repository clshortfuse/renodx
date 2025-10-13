#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
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
//   float cb0_035z : packoffset(c035.z);
//   float cb0_035w : packoffset(c035.w);
//   float cb0_036x : packoffset(c036.x);
//   float cb0_036y : packoffset(c036.y);
//   float expand_gamut : packoffset(c036.z);
//   float cb0_036w : packoffset(c036.w);
//   float cb0_037x : packoffset(c037.x);
//   float cb0_037y : packoffset(c037.y);
//   float cb0_037z : packoffset(c037.z);
//   float cb0_037w : packoffset(c037.w);
//   float cb0_038x : packoffset(c038.x);
//   float cb0_039x : packoffset(c039.x);
//   float cb0_039y : packoffset(c039.y);
//   float cb0_039z : packoffset(c039.z);
//   float cb0_040y : packoffset(c040.y);
//   float cb0_040z : packoffset(c040.z);
//   int output_device : packoffset(c040.w);
//   int output_gamut : packoffset(c041.x);
//   float cb0_042x : packoffset(c042.x);
//   float cb0_042y : packoffset(c042.y);
// };

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
};

SamplerState s0 : register(s0);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _24 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _25 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _28 = float((uint)SV_DispatchThreadID.z);
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _115;
  float _116;
  float _117;
  float _641;
  float _677;
  float _688;
  float _752;
  float _931;
  float _942;
  float _953;
  float _1124;
  float _1125;
  float _1126;
  float _1137;
  float _1148;
  float _1330;
  float _1366;
  float _1377;
  float _1416;
  float _1526;
  float _1600;
  float _1674;
  float _1753;
  float _1754;
  float _1755;
  float _1906;
  float _1942;
  float _1953;
  float _1992;
  float _2102;
  float _2176;
  float _2250;
  float _2329;
  float _2330;
  float _2331;
  float _2508;
  float _2509;
  float _2510;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _38 = (output_gamut == 4);
        _49 = select(_38, 1.0f, 1.7050515413284302f);
        _50 = select(_38, 0.0f, -0.6217905879020691f);
        _51 = select(_38, 0.0f, -0.0832584798336029f);
        _52 = select(_38, 0.0f, -0.13025718927383423f);
        _53 = select(_38, 1.0f, 1.1408027410507202f);
        _54 = select(_38, 0.0f, -0.010548528283834457f);
        _55 = select(_38, 0.0f, -0.024003278464078903f);
        _56 = select(_38, 0.0f, -0.1289687603712082f);
        _57 = select(_38, 1.0f, 1.152971863746643f);
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
      _49 = 1.02579927444458f;
      _50 = -0.020052503794431686f;
      _51 = -0.0057713985443115234f;
      _52 = -0.0022350111976265907f;
      _53 = 1.0045825242996216f;
      _54 = -0.002352306619286537f;
      _55 = -0.005014004185795784f;
      _56 = -0.025293385609984398f;
      _57 = 1.0304402112960815f;
    }
  } else {
    _49 = 1.379158854484558f;
    _50 = -0.3088507056236267f;
    _51 = -0.07034677267074585f;
    _52 = -0.06933528929948807f;
    _53 = 1.0822921991348267f;
    _54 = -0.012962047010660172f;
    _55 = -0.002159259282052517f;
    _56 = -0.045465391129255295f;
    _57 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _68 = exp2(log2(_24 * 1.0322580337524414f) * 0.012683313339948654f);
    float _69 = exp2(log2(_25 * 1.0322580337524414f) * 0.012683313339948654f);
    float _70 = exp2(log2(_28 * 0.032258063554763794f) * 0.012683313339948654f);
    _115 = (exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _116 = (exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _115 = ((exp2((_24 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _116 = ((exp2((_25 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _117 = ((exp2((_28 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  float _132 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _117, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _116, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _115)));
  float _135 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _117, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _116, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _115)));
  float _138 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _117, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _116, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _115)));
  float _139 = dot(float3(_132, _135, _138), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _143 = (_132 / _139) + -1.0f;
  float _144 = (_135 / _139) + -1.0f;
  float _145 = (_138 / _139) + -1.0f;
  float _157 = (1.0f - exp2(((_139 * _139) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_143, _144, _145), float3(_143, _144, _145)) * -4.0f));
  float _173 = ((mad(-0.06368283927440643f, _138, mad(-0.32929131388664246f, _135, (_132 * 1.370412826538086f))) - _132) * _157) + _132;
  float _174 = ((mad(-0.010861567221581936f, _138, mad(1.0970908403396606f, _135, (_132 * -0.08343426138162613f))) - _135) * _157) + _135;
  float _175 = ((mad(1.203694462776184f, _138, mad(-0.09862564504146576f, _135, (_132 * -0.02579325996339321f))) - _138) * _157) + _138;
  float _176 = dot(float3(_173, _174, _175), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _190 = cb0_019w + cb0_024w;
  float _204 = cb0_018w * cb0_023w;
  float _218 = cb0_017w * cb0_022w;
  float _232 = cb0_016w * cb0_021w;
  float _246 = cb0_015w * cb0_020w;
  float _250 = _173 - _176;
  float _251 = _174 - _176;
  float _252 = _175 - _176;
  float _310 = saturate(_176 / cb0_035z);
  float _314 = (_310 * _310) * (3.0f - (_310 * 2.0f));
  float _315 = 1.0f - _314;
  float _324 = cb0_019w + cb0_034w;
  float _333 = cb0_018w * cb0_033w;
  float _342 = cb0_017w * cb0_032w;
  float _351 = cb0_016w * cb0_031w;
  float _360 = cb0_015w * cb0_030w;
  float _423 = saturate((_176 - cb0_035w) / (cb0_036x - cb0_035w));
  float _427 = (_423 * _423) * (3.0f - (_423 * 2.0f));
  float _436 = cb0_019w + cb0_029w;
  float _445 = cb0_018w * cb0_028w;
  float _454 = cb0_017w * cb0_027w;
  float _463 = cb0_016w * cb0_026w;
  float _472 = cb0_015w * cb0_025w;
  float _530 = _314 - _427;
  float _541 = ((_427 * (((cb0_019x + cb0_034x) + _324) + (((cb0_018x * cb0_033x) * _333) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _351) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _360) * _250) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _342)))))) + (_315 * (((cb0_019x + cb0_024x) + _190) + (((cb0_018x * cb0_023x) * _204) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _232) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _246) * _250) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _218))))))) + ((((cb0_019x + cb0_029x) + _436) + (((cb0_018x * cb0_028x) * _445) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _463) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _472) * _250) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _454))))) * _530);
  float _543 = ((_427 * (((cb0_019y + cb0_034y) + _324) + (((cb0_018y * cb0_033y) * _333) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _351) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _360) * _251) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _342)))))) + (_315 * (((cb0_019y + cb0_024y) + _190) + (((cb0_018y * cb0_023y) * _204) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _232) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _246) * _251) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _218))))))) + ((((cb0_019y + cb0_029y) + _436) + (((cb0_018y * cb0_028y) * _445) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _463) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _472) * _251) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _454))))) * _530);
  float _545 = ((_427 * (((cb0_019z + cb0_034z) + _324) + (((cb0_018z * cb0_033z) * _333) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _351) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _360) * _252) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _342)))))) + (_315 * (((cb0_019z + cb0_024z) + _190) + (((cb0_018z * cb0_023z) * _204) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _232) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _246) * _252) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _218))))))) + ((((cb0_019z + cb0_029z) + _436) + (((cb0_018z * cb0_028z) * _445) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _463) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _472) * _252) + _176)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _454))))) * _530);
  float _581 = ((mad(0.061360642313957214f, _545, mad(-4.540197551250458e-09f, _543, (_541 * 0.9386394023895264f))) - _541) * cb0_036y) + _541;
  float _582 = ((mad(0.169205904006958f, _545, mad(0.8307942152023315f, _543, (_541 * 6.775371730327606e-08f))) - _543) * cb0_036y) + _543;
  float _583 = (mad(-2.3283064365386963e-10f, _543, (_541 * -9.313225746154785e-10f)) * cb0_036y) + _545;
  float _586 = mad(0.16386905312538147f, _583, mad(0.14067868888378143f, _582, (_581 * 0.6954522132873535f)));
  float _589 = mad(0.0955343246459961f, _583, mad(0.8596711158752441f, _582, (_581 * 0.044794581830501556f)));
  float _592 = mad(1.0015007257461548f, _583, mad(0.004025210160762072f, _582, (_581 * -0.005525882821530104f)));
  float _596 = max(max(_586, _589), _592);
  float _601 = (max(_596, 1.000000013351432e-10f) - max(min(min(_586, _589), _592), 1.000000013351432e-10f)) / max(_596, 0.009999999776482582f);
  float _614 = ((_589 + _586) + _592) + (sqrt((((_592 - _589) * _592) + ((_589 - _586) * _589)) + ((_586 - _592) * _586)) * 1.75f);
  float _615 = _614 * 0.3333333432674408f;
  float _616 = _601 + -0.4000000059604645f;
  float _617 = _616 * 5.0f;
  float _621 = max((1.0f - abs(_616 * 2.5f)), 0.0f);
  float _632 = ((float((int)(((int)(uint)((bool)(_617 > 0.0f))) - ((int)(uint)((bool)(_617 < 0.0f))))) * (1.0f - (_621 * _621))) + 1.0f) * 0.02500000037252903f;
  if (!(_615 <= 0.0533333346247673f)) {
    if (!(_615 >= 0.1599999964237213f)) {
      _641 = (((0.23999999463558197f / _614) + -0.5f) * _632);
    } else {
      _641 = 0.0f;
    }
  } else {
    _641 = _632;
  }
  float _642 = _641 + 1.0f;
  float _643 = _642 * _586;
  float _644 = _642 * _589;
  float _645 = _642 * _592;
  if (!((bool)(_643 == _644) && (bool)(_644 == _645))) {
    float _652 = ((_643 * 2.0f) - _644) - _645;
    float _655 = ((_589 - _592) * 1.7320507764816284f) * _642;
    float _657 = atan(_655 / _652);
    bool _660 = (_652 < 0.0f);
    bool _661 = (_652 == 0.0f);
    bool _662 = (_655 >= 0.0f);
    bool _663 = (_655 < 0.0f);
    float _672 = select((_662 && _661), 90.0f, select((_663 && _661), -90.0f, (select((_663 && _660), (_657 + -3.1415927410125732f), select((_662 && _660), (_657 + 3.1415927410125732f), _657)) * 57.2957763671875f)));
    if (_672 < 0.0f) {
      _677 = (_672 + 360.0f);
    } else {
      _677 = _672;
    }
  } else {
    _677 = 0.0f;
  }
  float _679 = min(max(_677, 0.0f), 360.0f);
  if (_679 < -180.0f) {
    _688 = (_679 + 360.0f);
  } else {
    if (_679 > 180.0f) {
      _688 = (_679 + -360.0f);
    } else {
      _688 = _679;
    }
  }
  float _692 = saturate(1.0f - abs(_688 * 0.014814814552664757f));
  float _696 = (_692 * _692) * (3.0f - (_692 * 2.0f));
  float _702 = ((_696 * _696) * ((_601 * 0.18000000715255737f) * (0.029999999329447746f - _643))) + _643;
  float _712 = max(0.0f, mad(-0.21492856740951538f, _645, mad(-0.2365107536315918f, _644, (_702 * 1.4514392614364624f))));
  float _713 = max(0.0f, mad(-0.09967592358589172f, _645, mad(1.17622971534729f, _644, (_702 * -0.07655377686023712f))));
  float _714 = max(0.0f, mad(0.9977163076400757f, _645, mad(-0.006032449658960104f, _644, (_702 * 0.008316148072481155f))));
  float _715 = dot(float3(_712, _713, _714), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _729 = (cb0_037w + 1.0f) - cb0_037y;
  float _732 = cb0_038x + 1.0f;
  float _734 = _732 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _752 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _743 = (cb0_037w + 0.18000000715255737f) / _729;
    _752 = (-0.7447274923324585f - ((log2(_743 / (2.0f - _743)) * 0.3465735912322998f) * (_729 / cb0_037x)));
  }
  float _755 = ((1.0f - cb0_037y) / cb0_037x) - _752;
  float _757 = (cb0_037z / cb0_037x) - _755;
  float _761 = log2(lerp(_715, _712, 0.9599999785423279f)) * 0.3010300099849701f;
  float _762 = log2(lerp(_715, _713, 0.9599999785423279f)) * 0.3010300099849701f;
  float _763 = log2(lerp(_715, _714, 0.9599999785423279f)) * 0.3010300099849701f;
  float _767 = cb0_037x * (_761 + _755);
  float _768 = cb0_037x * (_762 + _755);
  float _769 = cb0_037x * (_763 + _755);
  float _770 = _729 * 2.0f;
  float _772 = (cb0_037x * -2.0f) / _729;
  float _773 = _761 - _752;
  float _774 = _762 - _752;
  float _775 = _763 - _752;
  float _794 = _734 * 2.0f;
  float _796 = (cb0_037x * 2.0f) / _734;
  float _821 = select((_761 < _752), ((_770 / (exp2((_773 * 1.4426950216293335f) * _772) + 1.0f)) - cb0_037w), _767);
  float _822 = select((_762 < _752), ((_770 / (exp2((_774 * 1.4426950216293335f) * _772) + 1.0f)) - cb0_037w), _768);
  float _823 = select((_763 < _752), ((_770 / (exp2((_775 * 1.4426950216293335f) * _772) + 1.0f)) - cb0_037w), _769);
  float _830 = _757 - _752;
  float _834 = saturate(_773 / _830);
  float _835 = saturate(_774 / _830);
  float _836 = saturate(_775 / _830);
  bool _837 = (_757 < _752);
  float _841 = select(_837, (1.0f - _834), _834);
  float _842 = select(_837, (1.0f - _835), _835);
  float _843 = select(_837, (1.0f - _836), _836);
  float _862 = (((_841 * _841) * (select((_761 > _757), (_732 - (_794 / (exp2(((_761 - _757) * 1.4426950216293335f) * _796) + 1.0f))), _767) - _821)) * (3.0f - (_841 * 2.0f))) + _821;
  float _863 = (((_842 * _842) * (select((_762 > _757), (_732 - (_794 / (exp2(((_762 - _757) * 1.4426950216293335f) * _796) + 1.0f))), _768) - _822)) * (3.0f - (_842 * 2.0f))) + _822;
  float _864 = (((_843 * _843) * (select((_763 > _757), (_732 - (_794 / (exp2(((_763 - _757) * 1.4426950216293335f) * _796) + 1.0f))), _769) - _823)) * (3.0f - (_843 * 2.0f))) + _823;
  float _865 = dot(float3(_862, _863, _864), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _885 = (cb0_036w * (max(0.0f, (lerp(_865, _862, 0.9300000071525574f))) - _581)) + _581;
  float _886 = (cb0_036w * (max(0.0f, (lerp(_865, _863, 0.9300000071525574f))) - _582)) + _582;
  float _887 = (cb0_036w * (max(0.0f, (lerp(_865, _864, 0.9300000071525574f))) - _583)) + _583;
  float _903 = ((mad(-0.06537103652954102f, _887, mad(1.451815478503704e-06f, _886, (_885 * 1.065374732017517f))) - _885) * cb0_036y) + _885;
  float _904 = ((mad(-0.20366770029067993f, _887, mad(1.2036634683609009f, _886, (_885 * -2.57161445915699e-07f))) - _886) * cb0_036y) + _886;
  float _905 = ((mad(0.9999996423721313f, _887, mad(2.0954757928848267e-08f, _886, (_885 * 1.862645149230957e-08f))) - _887) * cb0_036y) + _887;
  float _918 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _905, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _904, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _903)))));
  float _919 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _905, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _904, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _903)))));
  float _920 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _905, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _904, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _903)))));
  if (_918 < 0.0031306699384003878f) {
    _931 = (_918 * 12.920000076293945f);
  } else {
    _931 = (((pow(_918, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_919 < 0.0031306699384003878f) {
    _942 = (_919 * 12.920000076293945f);
  } else {
    _942 = (((pow(_919, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_920 < 0.0031306699384003878f) {
    _953 = (_920 * 12.920000076293945f);
  } else {
    _953 = (((pow(_920, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _957 = (_942 * 0.9375f) + 0.03125f;
  float _964 = _953 * 15.0f;
  float _965 = floor(_964);
  float _966 = _964 - _965;
  float _968 = (((_931 * 0.9375f) + 0.03125f) + _965) * 0.0625f;
  float4 _971 = t0.SampleLevel(s0, float2(_968, _957), 0.0f);
  float4 _976 = t0.SampleLevel(s0, float2((_968 + 0.0625f), _957), 0.0f);
  float _995 = max(6.103519990574569e-05f, (((lerp(_971.x, _976.x, _966))*cb0_005y) + (cb0_005x * _931)));
  float _996 = max(6.103519990574569e-05f, (((lerp(_971.y, _976.y, _966))*cb0_005y) + (cb0_005x * _942)));
  float _997 = max(6.103519990574569e-05f, (((lerp(_971.z, _976.z, _966))*cb0_005y) + (cb0_005x * _953)));
  float _1019 = select((_995 > 0.040449999272823334f), exp2(log2((_995 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_995 * 0.07739938050508499f));
  float _1020 = select((_996 > 0.040449999272823334f), exp2(log2((_996 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_996 * 0.07739938050508499f));
  float _1021 = select((_997 > 0.040449999272823334f), exp2(log2((_997 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_997 * 0.07739938050508499f));
  float _1047 = cb0_014x * (((cb0_039y + (cb0_039x * _1019)) * _1019) + cb0_039z);
  float _1048 = cb0_014y * (((cb0_039y + (cb0_039x * _1020)) * _1020) + cb0_039z);
  float _1049 = cb0_014z * (((cb0_039y + (cb0_039x * _1021)) * _1021) + cb0_039z);
  float _1056 = ((cb0_013x - _1047) * cb0_013w) + _1047;
  float _1057 = ((cb0_013y - _1048) * cb0_013w) + _1048;
  float _1058 = ((cb0_013z - _1049) * cb0_013w) + _1049;
  float _1059 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _545, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _543, (_541 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1060 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _545, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _543, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _541)));
  float _1061 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _545, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _543, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _541)));
  float _1068 = ((cb0_013x - _1059) * cb0_013w) + _1059;
  float _1069 = ((cb0_013y - _1060) * cb0_013w) + _1060;
  float _1070 = ((cb0_013z - _1061) * cb0_013w) + _1061;
  float _1082 = exp2(log2(max(0.0f, _1056)) * cb0_040y);
  float _1083 = exp2(log2(max(0.0f, _1057)) * cb0_040y);
  float _1084 = exp2(log2(max(0.0f, _1058)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1107 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1082)));
        float _1110 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1082)));
        float _1113 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1082)));
        _1124 = mad(_51, _1113, mad(_50, _1110, (_1107 * _49)));
        _1125 = mad(_54, _1113, mad(_53, _1110, (_1107 * _52)));
        _1126 = mad(_57, _1113, mad(_56, _1110, (_1107 * _55)));
      } else {
        _1124 = _1082;
        _1125 = _1083;
        _1126 = _1084;
      }
      do {
        if (_1124 < 0.0031306699384003878f) {
          _1137 = (_1124 * 12.920000076293945f);
        } else {
          _1137 = (((pow(_1124, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1125 < 0.0031306699384003878f) {
            _1148 = (_1125 * 12.920000076293945f);
          } else {
            _1148 = (((pow(_1125, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1126 < 0.0031306699384003878f) {
            _2508 = _1137;
            _2509 = _1148;
            _2510 = (_1126 * 12.920000076293945f);
          } else {
            _2508 = _1137;
            _2509 = _1148;
            _2510 = (((pow(_1126, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1175 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1082)));
      float _1178 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1082)));
      float _1181 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1082)));
      float _1191 = max(6.103519990574569e-05f, mad(_51, _1181, mad(_50, _1178, (_1175 * _49))));
      float _1192 = max(6.103519990574569e-05f, mad(_54, _1181, mad(_53, _1178, (_1175 * _52))));
      float _1193 = max(6.103519990574569e-05f, mad(_57, _1181, mad(_56, _1178, (_1175 * _55))));
      _2508 = min((_1191 * 4.5f), ((exp2(log2(max(_1191, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2509 = min((_1192 * 4.5f), ((exp2(log2(max(_1192, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2510 = min((_1193 * 4.5f), ((exp2(log2(max(_1193, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
        _13[0] = cb0_010x;
        _13[1] = cb0_010y;
        _13[2] = cb0_010z;
        _13[3] = cb0_010w;
        _13[4] = cb0_012x;
        _13[5] = cb0_012x;
        _14[0] = cb0_011x;
        _14[1] = cb0_011y;
        _14[2] = cb0_011z;
        _14[3] = cb0_011w;
        _14[4] = cb0_012y;
        _14[5] = cb0_012y;
        float _1270 = cb0_012z * _1068;
        float _1271 = cb0_012z * _1069;
        float _1272 = cb0_012z * _1070;
        float _1275 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1272, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1271, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1270)));
        float _1278 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1272, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1271, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1270)));
        float _1281 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1272, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1271, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1270)));
        float _1285 = max(max(_1275, _1278), _1281);
        float _1290 = (max(_1285, 1.000000013351432e-10f) - max(min(min(_1275, _1278), _1281), 1.000000013351432e-10f)) / max(_1285, 0.009999999776482582f);
        float _1303 = ((_1278 + _1275) + _1281) + (sqrt((((_1281 - _1278) * _1281) + ((_1278 - _1275) * _1278)) + ((_1275 - _1281) * _1275)) * 1.75f);
        float _1304 = _1303 * 0.3333333432674408f;
        float _1305 = _1290 + -0.4000000059604645f;
        float _1306 = _1305 * 5.0f;
        float _1310 = max((1.0f - abs(_1305 * 2.5f)), 0.0f);
        float _1321 = ((float((int)(((int)(uint)((bool)(_1306 > 0.0f))) - ((int)(uint)((bool)(_1306 < 0.0f))))) * (1.0f - (_1310 * _1310))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1304 <= 0.0533333346247673f)) {
            if (!(_1304 >= 0.1599999964237213f)) {
              _1330 = (((0.23999999463558197f / _1303) + -0.5f) * _1321);
            } else {
              _1330 = 0.0f;
            }
          } else {
            _1330 = _1321;
          }
          float _1331 = _1330 + 1.0f;
          float _1332 = _1331 * _1275;
          float _1333 = _1331 * _1278;
          float _1334 = _1331 * _1281;
          do {
            if (!((bool)(_1332 == _1333) && (bool)(_1333 == _1334))) {
              float _1341 = ((_1332 * 2.0f) - _1333) - _1334;
              float _1344 = ((_1278 - _1281) * 1.7320507764816284f) * _1331;
              float _1346 = atan(_1344 / _1341);
              bool _1349 = (_1341 < 0.0f);
              bool _1350 = (_1341 == 0.0f);
              bool _1351 = (_1344 >= 0.0f);
              bool _1352 = (_1344 < 0.0f);
              float _1361 = select((_1351 && _1350), 90.0f, select((_1352 && _1350), -90.0f, (select((_1352 && _1349), (_1346 + -3.1415927410125732f), select((_1351 && _1349), (_1346 + 3.1415927410125732f), _1346)) * 57.2957763671875f)));
              if (_1361 < 0.0f) {
                _1366 = (_1361 + 360.0f);
              } else {
                _1366 = _1361;
              }
            } else {
              _1366 = 0.0f;
            }
            float _1368 = min(max(_1366, 0.0f), 360.0f);
            do {
              if (_1368 < -180.0f) {
                _1377 = (_1368 + 360.0f);
              } else {
                if (_1368 > 180.0f) {
                  _1377 = (_1368 + -360.0f);
                } else {
                  _1377 = _1368;
                }
              }
              do {
                if ((bool)(_1377 > -67.5f) && (bool)(_1377 < 67.5f)) {
                  float _1383 = (_1377 + 67.5f) * 0.029629629105329514f;
                  int _1384 = int(_1383);
                  float _1386 = _1383 - float((int)(_1384));
                  float _1387 = _1386 * _1386;
                  float _1388 = _1387 * _1386;
                  if (_1384 == 3) {
                    _1416 = (((0.1666666716337204f - (_1386 * 0.5f)) + (_1387 * 0.5f)) - (_1388 * 0.1666666716337204f));
                  } else {
                    if (_1384 == 2) {
                      _1416 = ((0.6666666865348816f - _1387) + (_1388 * 0.5f));
                    } else {
                      if (_1384 == 1) {
                        _1416 = (((_1388 * -0.5f) + 0.1666666716337204f) + ((_1387 + _1386) * 0.5f));
                      } else {
                        _1416 = select((_1384 == 0), (_1388 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1416 = 0.0f;
                }
                float _1425 = min(max(((((_1290 * 0.27000001072883606f) * (0.029999999329447746f - _1332)) * _1416) + _1332), 0.0f), 65535.0f);
                float _1426 = min(max(_1333, 0.0f), 65535.0f);
                float _1427 = min(max(_1334, 0.0f), 65535.0f);
                float _1440 = min(max(mad(-0.21492856740951538f, _1427, mad(-0.2365107536315918f, _1426, (_1425 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1441 = min(max(mad(-0.09967592358589172f, _1427, mad(1.17622971534729f, _1426, (_1425 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1442 = min(max(mad(0.9977163076400757f, _1427, mad(-0.006032449658960104f, _1426, (_1425 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1443 = dot(float3(_1440, _1441, _1442), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1454 = log2(max((lerp(_1443, _1440, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1455 = _1454 * 0.3010300099849701f;
                float _1456 = log2(cb0_008x);
                float _1457 = _1456 * 0.3010300099849701f;
                do {
                  if (!(!(_1455 <= _1457))) {
                    _1526 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1464 = log2(cb0_009x);
                    float _1465 = _1464 * 0.3010300099849701f;
                    if ((bool)(_1455 > _1457) && (bool)(_1455 < _1465)) {
                      float _1473 = ((_1454 - _1456) * 0.9030900001525879f) / ((_1464 - _1456) * 0.3010300099849701f);
                      int _1474 = int(_1473);
                      float _1476 = _1473 - float((int)(_1474));
                      float _1478 = _13[_1474];
                      float _1481 = _13[(_1474 + 1)];
                      float _1486 = _1478 * 0.5f;
                      _1526 = dot(float3((_1476 * _1476), _1476, 1.0f), float3(mad((_13[(_1474 + 2)]), 0.5f, mad(_1481, -1.0f, _1486)), (_1481 - _1478), mad(_1481, 0.5f, _1486)));
                    } else {
                      do {
                        if (!(!(_1455 >= _1465))) {
                          float _1495 = log2(cb0_008z);
                          if (_1455 < (_1495 * 0.3010300099849701f)) {
                            float _1503 = ((_1454 - _1464) * 0.9030900001525879f) / ((_1495 - _1464) * 0.3010300099849701f);
                            int _1504 = int(_1503);
                            float _1506 = _1503 - float((int)(_1504));
                            float _1508 = _14[_1504];
                            float _1511 = _14[(_1504 + 1)];
                            float _1516 = _1508 * 0.5f;
                            _1526 = dot(float3((_1506 * _1506), _1506, 1.0f), float3(mad((_14[(_1504 + 2)]), 0.5f, mad(_1511, -1.0f, _1516)), (_1511 - _1508), mad(_1511, 0.5f, _1516)));
                            break;
                          }
                        }
                        _1526 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1530 = log2(max((lerp(_1443, _1441, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1531 = _1530 * 0.3010300099849701f;
                  do {
                    if (!(!(_1531 <= _1457))) {
                      _1600 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1538 = log2(cb0_009x);
                      float _1539 = _1538 * 0.3010300099849701f;
                      if ((bool)(_1531 > _1457) && (bool)(_1531 < _1539)) {
                        float _1547 = ((_1530 - _1456) * 0.9030900001525879f) / ((_1538 - _1456) * 0.3010300099849701f);
                        int _1548 = int(_1547);
                        float _1550 = _1547 - float((int)(_1548));
                        float _1552 = _13[_1548];
                        float _1555 = _13[(_1548 + 1)];
                        float _1560 = _1552 * 0.5f;
                        _1600 = dot(float3((_1550 * _1550), _1550, 1.0f), float3(mad((_13[(_1548 + 2)]), 0.5f, mad(_1555, -1.0f, _1560)), (_1555 - _1552), mad(_1555, 0.5f, _1560)));
                      } else {
                        do {
                          if (!(!(_1531 >= _1539))) {
                            float _1569 = log2(cb0_008z);
                            if (_1531 < (_1569 * 0.3010300099849701f)) {
                              float _1577 = ((_1530 - _1538) * 0.9030900001525879f) / ((_1569 - _1538) * 0.3010300099849701f);
                              int _1578 = int(_1577);
                              float _1580 = _1577 - float((int)(_1578));
                              float _1582 = _14[_1578];
                              float _1585 = _14[(_1578 + 1)];
                              float _1590 = _1582 * 0.5f;
                              _1600 = dot(float3((_1580 * _1580), _1580, 1.0f), float3(mad((_14[(_1578 + 2)]), 0.5f, mad(_1585, -1.0f, _1590)), (_1585 - _1582), mad(_1585, 0.5f, _1590)));
                              break;
                            }
                          }
                          _1600 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1604 = log2(max((lerp(_1443, _1442, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1605 = _1604 * 0.3010300099849701f;
                    do {
                      if (!(!(_1605 <= _1457))) {
                        _1674 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1612 = log2(cb0_009x);
                        float _1613 = _1612 * 0.3010300099849701f;
                        if ((bool)(_1605 > _1457) && (bool)(_1605 < _1613)) {
                          float _1621 = ((_1604 - _1456) * 0.9030900001525879f) / ((_1612 - _1456) * 0.3010300099849701f);
                          int _1622 = int(_1621);
                          float _1624 = _1621 - float((int)(_1622));
                          float _1626 = _13[_1622];
                          float _1629 = _13[(_1622 + 1)];
                          float _1634 = _1626 * 0.5f;
                          _1674 = dot(float3((_1624 * _1624), _1624, 1.0f), float3(mad((_13[(_1622 + 2)]), 0.5f, mad(_1629, -1.0f, _1634)), (_1629 - _1626), mad(_1629, 0.5f, _1634)));
                        } else {
                          do {
                            if (!(!(_1605 >= _1613))) {
                              float _1643 = log2(cb0_008z);
                              if (_1605 < (_1643 * 0.3010300099849701f)) {
                                float _1651 = ((_1604 - _1612) * 0.9030900001525879f) / ((_1643 - _1612) * 0.3010300099849701f);
                                int _1652 = int(_1651);
                                float _1654 = _1651 - float((int)(_1652));
                                float _1656 = _14[_1652];
                                float _1659 = _14[(_1652 + 1)];
                                float _1664 = _1656 * 0.5f;
                                _1674 = dot(float3((_1654 * _1654), _1654, 1.0f), float3(mad((_14[(_1652 + 2)]), 0.5f, mad(_1659, -1.0f, _1664)), (_1659 - _1656), mad(_1659, 0.5f, _1664)));
                                break;
                              }
                            }
                            _1674 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1678 = cb0_008w - cb0_008y;
                      float _1679 = (exp2(_1526 * 3.321928024291992f) - cb0_008y) / _1678;
                      float _1681 = (exp2(_1600 * 3.321928024291992f) - cb0_008y) / _1678;
                      float _1683 = (exp2(_1674 * 3.321928024291992f) - cb0_008y) / _1678;
                      float _1686 = mad(0.15618768334388733f, _1683, mad(0.13400420546531677f, _1681, (_1679 * 0.6624541878700256f)));
                      float _1689 = mad(0.053689517080783844f, _1683, mad(0.6740817427635193f, _1681, (_1679 * 0.2722287178039551f)));
                      float _1692 = mad(1.0103391408920288f, _1683, mad(0.00406073359772563f, _1681, (_1679 * -0.005574649665504694f)));
                      float _1705 = min(max(mad(-0.23642469942569733f, _1692, mad(-0.32480329275131226f, _1689, (_1686 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1706 = min(max(mad(0.016756348311901093f, _1692, mad(1.6153316497802734f, _1689, (_1686 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1707 = min(max(mad(0.9883948564529419f, _1692, mad(-0.008284442126750946f, _1689, (_1686 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1710 = mad(0.15618768334388733f, _1707, mad(0.13400420546531677f, _1706, (_1705 * 0.6624541878700256f)));
                      float _1713 = mad(0.053689517080783844f, _1707, mad(0.6740817427635193f, _1706, (_1705 * 0.2722287178039551f)));
                      float _1716 = mad(1.0103391408920288f, _1707, mad(0.00406073359772563f, _1706, (_1705 * -0.005574649665504694f)));
                      float _1738 = min(max((min(max(mad(-0.23642469942569733f, _1716, mad(-0.32480329275131226f, _1713, (_1710 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1739 = min(max((min(max(mad(0.016756348311901093f, _1716, mad(1.6153316497802734f, _1713, (_1710 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1740 = min(max((min(max(mad(0.9883948564529419f, _1716, mad(-0.008284442126750946f, _1713, (_1710 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1753 = mad(_51, _1740, mad(_50, _1739, (_1738 * _49)));
                          _1754 = mad(_54, _1740, mad(_53, _1739, (_1738 * _52)));
                          _1755 = mad(_57, _1740, mad(_56, _1739, (_1738 * _55)));
                        } else {
                          _1753 = _1738;
                          _1754 = _1739;
                          _1755 = _1740;
                        }
                        float _1765 = exp2(log2(_1753 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1766 = exp2(log2(_1754 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1767 = exp2(log2(_1755 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2508 = exp2(log2((1.0f / ((_1765 * 18.6875f) + 1.0f)) * ((_1765 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2509 = exp2(log2((1.0f / ((_1766 * 18.6875f) + 1.0f)) * ((_1766 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2510 = exp2(log2((1.0f / ((_1767 * 18.6875f) + 1.0f)) * ((_1767 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1846 = cb0_012z * _1068;
          float _1847 = cb0_012z * _1069;
          float _1848 = cb0_012z * _1070;
          float _1851 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1848, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1847, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1846)));
          float _1854 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1848, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1847, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1846)));
          float _1857 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1848, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1847, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1846)));
          float _1861 = max(max(_1851, _1854), _1857);
          float _1866 = (max(_1861, 1.000000013351432e-10f) - max(min(min(_1851, _1854), _1857), 1.000000013351432e-10f)) / max(_1861, 0.009999999776482582f);
          float _1879 = ((_1854 + _1851) + _1857) + (sqrt((((_1857 - _1854) * _1857) + ((_1854 - _1851) * _1854)) + ((_1851 - _1857) * _1851)) * 1.75f);
          float _1880 = _1879 * 0.3333333432674408f;
          float _1881 = _1866 + -0.4000000059604645f;
          float _1882 = _1881 * 5.0f;
          float _1886 = max((1.0f - abs(_1881 * 2.5f)), 0.0f);
          float _1897 = ((float((int)(((int)(uint)((bool)(_1882 > 0.0f))) - ((int)(uint)((bool)(_1882 < 0.0f))))) * (1.0f - (_1886 * _1886))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1880 <= 0.0533333346247673f)) {
              if (!(_1880 >= 0.1599999964237213f)) {
                _1906 = (((0.23999999463558197f / _1879) + -0.5f) * _1897);
              } else {
                _1906 = 0.0f;
              }
            } else {
              _1906 = _1897;
            }
            float _1907 = _1906 + 1.0f;
            float _1908 = _1907 * _1851;
            float _1909 = _1907 * _1854;
            float _1910 = _1907 * _1857;
            do {
              if (!((bool)(_1908 == _1909) && (bool)(_1909 == _1910))) {
                float _1917 = ((_1908 * 2.0f) - _1909) - _1910;
                float _1920 = ((_1854 - _1857) * 1.7320507764816284f) * _1907;
                float _1922 = atan(_1920 / _1917);
                bool _1925 = (_1917 < 0.0f);
                bool _1926 = (_1917 == 0.0f);
                bool _1927 = (_1920 >= 0.0f);
                bool _1928 = (_1920 < 0.0f);
                float _1937 = select((_1927 && _1926), 90.0f, select((_1928 && _1926), -90.0f, (select((_1928 && _1925), (_1922 + -3.1415927410125732f), select((_1927 && _1925), (_1922 + 3.1415927410125732f), _1922)) * 57.2957763671875f)));
                if (_1937 < 0.0f) {
                  _1942 = (_1937 + 360.0f);
                } else {
                  _1942 = _1937;
                }
              } else {
                _1942 = 0.0f;
              }
              float _1944 = min(max(_1942, 0.0f), 360.0f);
              do {
                if (_1944 < -180.0f) {
                  _1953 = (_1944 + 360.0f);
                } else {
                  if (_1944 > 180.0f) {
                    _1953 = (_1944 + -360.0f);
                  } else {
                    _1953 = _1944;
                  }
                }
                do {
                  if ((bool)(_1953 > -67.5f) && (bool)(_1953 < 67.5f)) {
                    float _1959 = (_1953 + 67.5f) * 0.029629629105329514f;
                    int _1960 = int(_1959);
                    float _1962 = _1959 - float((int)(_1960));
                    float _1963 = _1962 * _1962;
                    float _1964 = _1963 * _1962;
                    if (_1960 == 3) {
                      _1992 = (((0.1666666716337204f - (_1962 * 0.5f)) + (_1963 * 0.5f)) - (_1964 * 0.1666666716337204f));
                    } else {
                      if (_1960 == 2) {
                        _1992 = ((0.6666666865348816f - _1963) + (_1964 * 0.5f));
                      } else {
                        if (_1960 == 1) {
                          _1992 = (((_1964 * -0.5f) + 0.1666666716337204f) + ((_1963 + _1962) * 0.5f));
                        } else {
                          _1992 = select((_1960 == 0), (_1964 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1992 = 0.0f;
                  }
                  float _2001 = min(max(((((_1866 * 0.27000001072883606f) * (0.029999999329447746f - _1908)) * _1992) + _1908), 0.0f), 65535.0f);
                  float _2002 = min(max(_1909, 0.0f), 65535.0f);
                  float _2003 = min(max(_1910, 0.0f), 65535.0f);
                  float _2016 = min(max(mad(-0.21492856740951538f, _2003, mad(-0.2365107536315918f, _2002, (_2001 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2017 = min(max(mad(-0.09967592358589172f, _2003, mad(1.17622971534729f, _2002, (_2001 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2018 = min(max(mad(0.9977163076400757f, _2003, mad(-0.006032449658960104f, _2002, (_2001 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2019 = dot(float3(_2016, _2017, _2018), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2030 = log2(max((lerp(_2019, _2016, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2031 = _2030 * 0.3010300099849701f;
                  float _2032 = log2(cb0_008x);
                  float _2033 = _2032 * 0.3010300099849701f;
                  do {
                    if (!(!(_2031 <= _2033))) {
                      _2102 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2040 = log2(cb0_009x);
                      float _2041 = _2040 * 0.3010300099849701f;
                      if ((bool)(_2031 > _2033) && (bool)(_2031 < _2041)) {
                        float _2049 = ((_2030 - _2032) * 0.9030900001525879f) / ((_2040 - _2032) * 0.3010300099849701f);
                        int _2050 = int(_2049);
                        float _2052 = _2049 - float((int)(_2050));
                        float _2054 = _11[_2050];
                        float _2057 = _11[(_2050 + 1)];
                        float _2062 = _2054 * 0.5f;
                        _2102 = dot(float3((_2052 * _2052), _2052, 1.0f), float3(mad((_11[(_2050 + 2)]), 0.5f, mad(_2057, -1.0f, _2062)), (_2057 - _2054), mad(_2057, 0.5f, _2062)));
                      } else {
                        do {
                          if (!(!(_2031 >= _2041))) {
                            float _2071 = log2(cb0_008z);
                            if (_2031 < (_2071 * 0.3010300099849701f)) {
                              float _2079 = ((_2030 - _2040) * 0.9030900001525879f) / ((_2071 - _2040) * 0.3010300099849701f);
                              int _2080 = int(_2079);
                              float _2082 = _2079 - float((int)(_2080));
                              float _2084 = _12[_2080];
                              float _2087 = _12[(_2080 + 1)];
                              float _2092 = _2084 * 0.5f;
                              _2102 = dot(float3((_2082 * _2082), _2082, 1.0f), float3(mad((_12[(_2080 + 2)]), 0.5f, mad(_2087, -1.0f, _2092)), (_2087 - _2084), mad(_2087, 0.5f, _2092)));
                              break;
                            }
                          }
                          _2102 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2106 = log2(max((lerp(_2019, _2017, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2107 = _2106 * 0.3010300099849701f;
                    do {
                      if (!(!(_2107 <= _2033))) {
                        _2176 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2114 = log2(cb0_009x);
                        float _2115 = _2114 * 0.3010300099849701f;
                        if ((bool)(_2107 > _2033) && (bool)(_2107 < _2115)) {
                          float _2123 = ((_2106 - _2032) * 0.9030900001525879f) / ((_2114 - _2032) * 0.3010300099849701f);
                          int _2124 = int(_2123);
                          float _2126 = _2123 - float((int)(_2124));
                          float _2128 = _11[_2124];
                          float _2131 = _11[(_2124 + 1)];
                          float _2136 = _2128 * 0.5f;
                          _2176 = dot(float3((_2126 * _2126), _2126, 1.0f), float3(mad((_11[(_2124 + 2)]), 0.5f, mad(_2131, -1.0f, _2136)), (_2131 - _2128), mad(_2131, 0.5f, _2136)));
                        } else {
                          do {
                            if (!(!(_2107 >= _2115))) {
                              float _2145 = log2(cb0_008z);
                              if (_2107 < (_2145 * 0.3010300099849701f)) {
                                float _2153 = ((_2106 - _2114) * 0.9030900001525879f) / ((_2145 - _2114) * 0.3010300099849701f);
                                int _2154 = int(_2153);
                                float _2156 = _2153 - float((int)(_2154));
                                float _2158 = _12[_2154];
                                float _2161 = _12[(_2154 + 1)];
                                float _2166 = _2158 * 0.5f;
                                _2176 = dot(float3((_2156 * _2156), _2156, 1.0f), float3(mad((_12[(_2154 + 2)]), 0.5f, mad(_2161, -1.0f, _2166)), (_2161 - _2158), mad(_2161, 0.5f, _2166)));
                                break;
                              }
                            }
                            _2176 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2180 = log2(max((lerp(_2019, _2018, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2181 = _2180 * 0.3010300099849701f;
                      do {
                        if (!(!(_2181 <= _2033))) {
                          _2250 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2188 = log2(cb0_009x);
                          float _2189 = _2188 * 0.3010300099849701f;
                          if ((bool)(_2181 > _2033) && (bool)(_2181 < _2189)) {
                            float _2197 = ((_2180 - _2032) * 0.9030900001525879f) / ((_2188 - _2032) * 0.3010300099849701f);
                            int _2198 = int(_2197);
                            float _2200 = _2197 - float((int)(_2198));
                            float _2202 = _11[_2198];
                            float _2205 = _11[(_2198 + 1)];
                            float _2210 = _2202 * 0.5f;
                            _2250 = dot(float3((_2200 * _2200), _2200, 1.0f), float3(mad((_11[(_2198 + 2)]), 0.5f, mad(_2205, -1.0f, _2210)), (_2205 - _2202), mad(_2205, 0.5f, _2210)));
                          } else {
                            do {
                              if (!(!(_2181 >= _2189))) {
                                float _2219 = log2(cb0_008z);
                                if (_2181 < (_2219 * 0.3010300099849701f)) {
                                  float _2227 = ((_2180 - _2188) * 0.9030900001525879f) / ((_2219 - _2188) * 0.3010300099849701f);
                                  int _2228 = int(_2227);
                                  float _2230 = _2227 - float((int)(_2228));
                                  float _2232 = _12[_2228];
                                  float _2235 = _12[(_2228 + 1)];
                                  float _2240 = _2232 * 0.5f;
                                  _2250 = dot(float3((_2230 * _2230), _2230, 1.0f), float3(mad((_12[(_2228 + 2)]), 0.5f, mad(_2235, -1.0f, _2240)), (_2235 - _2232), mad(_2235, 0.5f, _2240)));
                                  break;
                                }
                              }
                              _2250 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2254 = cb0_008w - cb0_008y;
                        float _2255 = (exp2(_2102 * 3.321928024291992f) - cb0_008y) / _2254;
                        float _2257 = (exp2(_2176 * 3.321928024291992f) - cb0_008y) / _2254;
                        float _2259 = (exp2(_2250 * 3.321928024291992f) - cb0_008y) / _2254;
                        float _2262 = mad(0.15618768334388733f, _2259, mad(0.13400420546531677f, _2257, (_2255 * 0.6624541878700256f)));
                        float _2265 = mad(0.053689517080783844f, _2259, mad(0.6740817427635193f, _2257, (_2255 * 0.2722287178039551f)));
                        float _2268 = mad(1.0103391408920288f, _2259, mad(0.00406073359772563f, _2257, (_2255 * -0.005574649665504694f)));
                        float _2281 = min(max(mad(-0.23642469942569733f, _2268, mad(-0.32480329275131226f, _2265, (_2262 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2282 = min(max(mad(0.016756348311901093f, _2268, mad(1.6153316497802734f, _2265, (_2262 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2283 = min(max(mad(0.9883948564529419f, _2268, mad(-0.008284442126750946f, _2265, (_2262 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2286 = mad(0.15618768334388733f, _2283, mad(0.13400420546531677f, _2282, (_2281 * 0.6624541878700256f)));
                        float _2289 = mad(0.053689517080783844f, _2283, mad(0.6740817427635193f, _2282, (_2281 * 0.2722287178039551f)));
                        float _2292 = mad(1.0103391408920288f, _2283, mad(0.00406073359772563f, _2282, (_2281 * -0.005574649665504694f)));
                        float _2314 = min(max((min(max(mad(-0.23642469942569733f, _2292, mad(-0.32480329275131226f, _2289, (_2286 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2315 = min(max((min(max(mad(0.016756348311901093f, _2292, mad(1.6153316497802734f, _2289, (_2286 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2316 = min(max((min(max(mad(0.9883948564529419f, _2292, mad(-0.008284442126750946f, _2289, (_2286 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2329 = mad(_51, _2316, mad(_50, _2315, (_2314 * _49)));
                            _2330 = mad(_54, _2316, mad(_53, _2315, (_2314 * _52)));
                            _2331 = mad(_57, _2316, mad(_56, _2315, (_2314 * _55)));
                          } else {
                            _2329 = _2314;
                            _2330 = _2315;
                            _2331 = _2316;
                          }
                          float _2341 = exp2(log2(_2329 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2342 = exp2(log2(_2330 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2343 = exp2(log2(_2331 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2508 = exp2(log2((1.0f / ((_2341 * 18.6875f) + 1.0f)) * ((_2341 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2509 = exp2(log2((1.0f / ((_2342 * 18.6875f) + 1.0f)) * ((_2342 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2510 = exp2(log2((1.0f / ((_2343 * 18.6875f) + 1.0f)) * ((_2343 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2388 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1070, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1069, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1068)));
            float _2391 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1070, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1069, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1068)));
            float _2394 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1070, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1069, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1068)));
            float _2413 = exp2(log2(mad(_51, _2394, mad(_50, _2391, (_2388 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2414 = exp2(log2(mad(_54, _2394, mad(_53, _2391, (_2388 * _52))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2415 = exp2(log2(mad(_57, _2394, mad(_56, _2391, (_2388 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2508 = exp2(log2((1.0f / ((_2413 * 18.6875f) + 1.0f)) * ((_2413 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2509 = exp2(log2((1.0f / ((_2414 * 18.6875f) + 1.0f)) * ((_2414 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2510 = exp2(log2((1.0f / ((_2415 * 18.6875f) + 1.0f)) * ((_2415 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2462 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1058, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1057, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1056)));
                float _2465 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1058, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1057, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1056)));
                float _2468 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1058, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1057, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1056)));
                _2508 = mad(_51, _2468, mad(_50, _2465, (_2462 * _49)));
                _2509 = mad(_54, _2468, mad(_53, _2465, (_2462 * _52)));
                _2510 = mad(_57, _2468, mad(_56, _2465, (_2462 * _55)));
              } else {
                float _2481 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1082)));
                float _2484 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1082)));
                float _2487 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1084, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1083, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1082)));
                _2508 = exp2(log2(mad(_51, _2487, mad(_50, _2484, (_2481 * _49)))) * cb0_040z);
                _2509 = exp2(log2(mad(_54, _2487, mad(_53, _2484, (_2481 * _52)))) * cb0_040z);
                _2510 = exp2(log2(mad(_57, _2487, mad(_56, _2484, (_2481 * _55)))) * cb0_040z);
              }
            } else {
              _2508 = _1068;
              _2509 = _1069;
              _2510 = _1070;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2508 * 0.9523810148239136f), (_2509 * 0.9523810148239136f), (_2510 * 0.9523810148239136f), 0.0f);
}
