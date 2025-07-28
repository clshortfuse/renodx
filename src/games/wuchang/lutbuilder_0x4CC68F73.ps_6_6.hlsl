// Found in Wuchang, used to be in repo, updated decomp 7/24/25

#include "./common.hlsl"

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
};

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _14 = TEXCOORD.x + -0.015625f;
  float _15 = TEXCOORD.y + -0.015625f;
  float _18 = float((uint)(int)(SV_RenderTargetArrayIndex));
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _105;
  float _106;
  float _107;
  float _631;
  float _667;
  float _678;
  float _742;
  float _921;
  float _932;
  float _943;
  float _1116;
  float _1117;
  float _1118;
  float _1129;
  float _1140;
  float _1322;
  float _1358;
  float _1369;
  float _1408;
  float _1518;
  float _1592;
  float _1666;
  float _1745;
  float _1746;
  float _1747;
  float _1898;
  float _1934;
  float _1945;
  float _1984;
  float _2094;
  float _2168;
  float _2242;
  float _2321;
  float _2322;
  float _2323;
  float _2500;
  float _2501;
  float _2502;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _28 = (cb0_041x == 4);
        _39 = select(_28, 1.0f, 1.7050515413284302f);
        _40 = select(_28, 0.0f, -0.6217905879020691f);
        _41 = select(_28, 0.0f, -0.0832584798336029f);
        _42 = select(_28, 0.0f, -0.13025718927383423f);
        _43 = select(_28, 1.0f, 1.1408027410507202f);
        _44 = select(_28, 0.0f, -0.010548528283834457f);
        _45 = select(_28, 0.0f, -0.024003278464078903f);
        _46 = select(_28, 0.0f, -0.1289687603712082f);
        _47 = select(_28, 1.0f, 1.152971863746643f);
      } else {
        _39 = 0.6954522132873535f;
        _40 = 0.14067870378494263f;
        _41 = 0.16386906802654266f;
        _42 = 0.044794563204050064f;
        _43 = 0.8596711158752441f;
        _44 = 0.0955343171954155f;
        _45 = -0.005525882821530104f;
        _46 = 0.004025210160762072f;
        _47 = 1.0015007257461548f;
      }
    } else {
      _39 = 1.02579927444458f;
      _40 = -0.020052503794431686f;
      _41 = -0.0057713985443115234f;
      _42 = -0.0022350111976265907f;
      _43 = 1.0045825242996216f;
      _44 = -0.002352306619286537f;
      _45 = -0.005014004185795784f;
      _46 = -0.025293385609984398f;
      _47 = 1.0304402112960815f;
    }
  } else {
    _39 = 1.379158854484558f;
    _40 = -0.3088507056236267f;
    _41 = -0.07034677267074585f;
    _42 = -0.06933528929948807f;
    _43 = 1.0822921991348267f;
    _44 = -0.012962047010660172f;
    _45 = -0.002159259282052517f;
    _46 = -0.045465391129255295f;
    _47 = 1.0477596521377563f;
  }
  if ((uint)cb0_040w > (uint)2) {
    float _58 = exp2(log2(_14 * 1.0322580337524414f) * 0.012683313339948654f);
    float _59 = exp2(log2(_15 * 1.0322580337524414f) * 0.012683313339948654f);
    float _60 = exp2(log2(_18 * 0.032258063554763794f) * 0.012683313339948654f);
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _106 = (exp2(log2(max(0.0f, (_59 + -0.8359375f)) / (18.8515625f - (_59 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _105 = ((exp2((_14 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _106 = ((exp2((_15 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _107 = ((exp2((_18 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _122 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _107, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _106, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _105)));
  float _125 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _107, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _106, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _105)));
  float _128 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _107, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _106, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _105)));
  float _129 = dot(float3(_122, _125, _128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_122, _125, _128));

  float _133 = (_122 / _129) + -1.0f;
  float _134 = (_125 / _129) + -1.0f;
  float _135 = (_128 / _129) + -1.0f;
  float _147 = (1.0f - exp2(((_129 * _129) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_133, _134, _135), float3(_133, _134, _135)) * -4.0f));
  float _163 = ((mad(-0.06368283927440643f, _128, mad(-0.32929131388664246f, _125, (_122 * 1.370412826538086f))) - _122) * _147) + _122;
  float _164 = ((mad(-0.010861567221581936f, _128, mad(1.0970908403396606f, _125, (_122 * -0.08343426138162613f))) - _125) * _147) + _125;
  float _165 = ((mad(1.203694462776184f, _128, mad(-0.09862564504146576f, _125, (_122 * -0.02579325996339321f))) - _128) * _147) + _128;
  float _166 = dot(float3(_163, _164, _165), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _180 = cb0_019w + cb0_024w;
  float _194 = cb0_018w * cb0_023w;
  float _208 = cb0_017w * cb0_022w;
  float _222 = cb0_016w * cb0_021w;
  float _236 = cb0_015w * cb0_020w;
  float _240 = _163 - _166;
  float _241 = _164 - _166;
  float _242 = _165 - _166;
  float _300 = saturate(_166 / cb0_035z);
  float _304 = (_300 * _300) * (3.0f - (_300 * 2.0f));
  float _305 = 1.0f - _304;
  float _314 = cb0_019w + cb0_034w;
  float _323 = cb0_018w * cb0_033w;
  float _332 = cb0_017w * cb0_032w;
  float _341 = cb0_016w * cb0_031w;
  float _350 = cb0_015w * cb0_030w;
  float _413 = saturate((_166 - cb0_035w) / (cb0_036x - cb0_035w));
  float _417 = (_413 * _413) * (3.0f - (_413 * 2.0f));
  float _426 = cb0_019w + cb0_029w;
  float _435 = cb0_018w * cb0_028w;
  float _444 = cb0_017w * cb0_027w;
  float _453 = cb0_016w * cb0_026w;
  float _462 = cb0_015w * cb0_025w;
  float _520 = _304 - _417;
  float _531 = ((_417 * (((cb0_019x + cb0_034x) + _314) + (((cb0_018x * cb0_033x) * _323) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _341) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _350) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _332)))))) + (_305 * (((cb0_019x + cb0_024x) + _180) + (((cb0_018x * cb0_023x) * _194) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _222) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _236) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _208))))))) + ((((cb0_019x + cb0_029x) + _426) + (((cb0_018x * cb0_028x) * _435) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _453) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _462) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _444))))) * _520);
  float _533 = ((_417 * (((cb0_019y + cb0_034y) + _314) + (((cb0_018y * cb0_033y) * _323) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _341) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _350) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _332)))))) + (_305 * (((cb0_019y + cb0_024y) + _180) + (((cb0_018y * cb0_023y) * _194) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _222) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _236) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _208))))))) + ((((cb0_019y + cb0_029y) + _426) + (((cb0_018y * cb0_028y) * _435) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _453) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _462) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _444))))) * _520);
  float _535 = ((_417 * (((cb0_019z + cb0_034z) + _314) + (((cb0_018z * cb0_033z) * _323) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _341) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _350) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _332)))))) + (_305 * (((cb0_019z + cb0_024z) + _180) + (((cb0_018z * cb0_023z) * _194) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _222) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _236) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _208))))))) + ((((cb0_019z + cb0_029z) + _426) + (((cb0_018z * cb0_028z) * _435) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _453) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _462) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _444))))) * _520);

  SetUntonemappedAP1(float3(_531, _533, _535));

  float _571 = ((mad(0.061360642313957214f, _535, mad(-4.540197551250458e-09f, _533, (_531 * 0.9386394023895264f))) - _531) * cb0_036y) + _531;
  float _572 = ((mad(0.169205904006958f, _535, mad(0.8307942152023315f, _533, (_531 * 6.775371730327606e-08f))) - _533) * cb0_036y) + _533;
  float _573 = (mad(-2.3283064365386963e-10f, _533, (_531 * -9.313225746154785e-10f)) * cb0_036y) + _535;
  float _576 = mad(0.16386905312538147f, _573, mad(0.14067868888378143f, _572, (_571 * 0.6954522132873535f)));
  float _579 = mad(0.0955343246459961f, _573, mad(0.8596711158752441f, _572, (_571 * 0.044794581830501556f)));
  float _582 = mad(1.0015007257461548f, _573, mad(0.004025210160762072f, _572, (_571 * -0.005525882821530104f)));
  float _586 = max(max(_576, _579), _582);
  float _591 = (max(_586, 1.000000013351432e-10f) - max(min(min(_576, _579), _582), 1.000000013351432e-10f)) / max(_586, 0.009999999776482582f);
  float _604 = ((_579 + _576) + _582) + (sqrt((((_582 - _579) * _582) + ((_579 - _576) * _579)) + ((_576 - _582) * _576)) * 1.75f);
  float _605 = _604 * 0.3333333432674408f;
  float _606 = _591 + -0.4000000059604645f;
  float _607 = _606 * 5.0f;
  float _611 = max((1.0f - abs(_606 * 2.5f)), 0.0f);
  float _622 = ((float((int)(((int)(uint)((bool)(_607 > 0.0f))) - ((int)(uint)((bool)(_607 < 0.0f))))) * (1.0f - (_611 * _611))) + 1.0f) * 0.02500000037252903f;
  if (!(_605 <= 0.0533333346247673f)) {
    if (!(_605 >= 0.1599999964237213f)) {
      _631 = (((0.23999999463558197f / _604) + -0.5f) * _622);
    } else {
      _631 = 0.0f;
    }
  } else {
    _631 = _622;
  }
  float _632 = _631 + 1.0f;
  float _633 = _632 * _576;
  float _634 = _632 * _579;
  float _635 = _632 * _582;
  if (!((bool)(_633 == _634) && (bool)(_634 == _635))) {
    float _642 = ((_633 * 2.0f) - _634) - _635;
    float _645 = ((_579 - _582) * 1.7320507764816284f) * _632;
    float _647 = atan(_645 / _642);
    bool _650 = (_642 < 0.0f);
    bool _651 = (_642 == 0.0f);
    bool _652 = (_645 >= 0.0f);
    bool _653 = (_645 < 0.0f);
    float _662 = select((_652 && _651), 90.0f, select((_653 && _651), -90.0f, (select((_653 && _650), (_647 + -3.1415927410125732f), select((_652 && _650), (_647 + 3.1415927410125732f), _647)) * 57.2957763671875f)));
    if (_662 < 0.0f) {
      _667 = (_662 + 360.0f);
    } else {
      _667 = _662;
    }
  } else {
    _667 = 0.0f;
  }
  float _669 = min(max(_667, 0.0f), 360.0f);
  if (_669 < -180.0f) {
    _678 = (_669 + 360.0f);
  } else {
    if (_669 > 180.0f) {
      _678 = (_669 + -360.0f);
    } else {
      _678 = _669;
    }
  }
  float _682 = saturate(1.0f - abs(_678 * 0.014814814552664757f));
  float _686 = (_682 * _682) * (3.0f - (_682 * 2.0f));
  float _692 = ((_686 * _686) * ((_591 * 0.18000000715255737f) * (0.029999999329447746f - _633))) + _633;
  float _702 = max(0.0f, mad(-0.21492856740951538f, _635, mad(-0.2365107536315918f, _634, (_692 * 1.4514392614364624f))));
  float _703 = max(0.0f, mad(-0.09967592358589172f, _635, mad(1.17622971534729f, _634, (_692 * -0.07655377686023712f))));
  float _704 = max(0.0f, mad(0.9977163076400757f, _635, mad(-0.006032449658960104f, _634, (_692 * 0.008316148072481155f))));
  float _705 = dot(float3(_702, _703, _704), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _719 = (cb0_037w + 1.0f) - cb0_037y;
  float _722 = cb0_038x + 1.0f;
  float _724 = _722 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _742 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _733 = (cb0_037w + 0.18000000715255737f) / _719;
    _742 = (-0.7447274923324585f - ((log2(_733 / (2.0f - _733)) * 0.3465735912322998f) * (_719 / cb0_037x)));
  }
  float _745 = ((1.0f - cb0_037y) / cb0_037x) - _742;
  float _747 = (cb0_037z / cb0_037x) - _745;
  float _751 = log2(lerp(_705, _702, 0.9599999785423279f)) * 0.3010300099849701f;
  float _752 = log2(lerp(_705, _703, 0.9599999785423279f)) * 0.3010300099849701f;
  float _753 = log2(lerp(_705, _704, 0.9599999785423279f)) * 0.3010300099849701f;
  float _757 = cb0_037x * (_751 + _745);
  float _758 = cb0_037x * (_752 + _745);
  float _759 = cb0_037x * (_753 + _745);
  float _760 = _719 * 2.0f;
  float _762 = (cb0_037x * -2.0f) / _719;
  float _763 = _751 - _742;
  float _764 = _752 - _742;
  float _765 = _753 - _742;
  float _784 = _724 * 2.0f;
  float _786 = (cb0_037x * 2.0f) / _724;
  float _811 = select((_751 < _742), ((_760 / (exp2((_763 * 1.4426950216293335f) * _762) + 1.0f)) - cb0_037w), _757);
  float _812 = select((_752 < _742), ((_760 / (exp2((_764 * 1.4426950216293335f) * _762) + 1.0f)) - cb0_037w), _758);
  float _813 = select((_753 < _742), ((_760 / (exp2((_765 * 1.4426950216293335f) * _762) + 1.0f)) - cb0_037w), _759);
  float _820 = _747 - _742;
  float _824 = saturate(_763 / _820);
  float _825 = saturate(_764 / _820);
  float _826 = saturate(_765 / _820);
  bool _827 = (_747 < _742);
  float _831 = select(_827, (1.0f - _824), _824);
  float _832 = select(_827, (1.0f - _825), _825);
  float _833 = select(_827, (1.0f - _826), _826);
  float _852 = (((_831 * _831) * (select((_751 > _747), (_722 - (_784 / (exp2(((_751 - _747) * 1.4426950216293335f) * _786) + 1.0f))), _757) - _811)) * (3.0f - (_831 * 2.0f))) + _811;
  float _853 = (((_832 * _832) * (select((_752 > _747), (_722 - (_784 / (exp2(((_752 - _747) * 1.4426950216293335f) * _786) + 1.0f))), _758) - _812)) * (3.0f - (_832 * 2.0f))) + _812;
  float _854 = (((_833 * _833) * (select((_753 > _747), (_722 - (_784 / (exp2(((_753 - _747) * 1.4426950216293335f) * _786) + 1.0f))), _759) - _813)) * (3.0f - (_833 * 2.0f))) + _813;
  float _855 = dot(float3(_852, _853, _854), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _875 = (cb0_036w * (max(0.0f, (lerp(_855, _852, 0.9300000071525574f))) - _571)) + _571;
  float _876 = (cb0_036w * (max(0.0f, (lerp(_855, _853, 0.9300000071525574f))) - _572)) + _572;
  float _877 = (cb0_036w * (max(0.0f, (lerp(_855, _854, 0.9300000071525574f))) - _573)) + _573;
  float _893 = ((mad(-0.06537103652954102f, _877, mad(1.451815478503704e-06f, _876, (_875 * 1.065374732017517f))) - _875) * cb0_036y) + _875;
  float _894 = ((mad(-0.20366770029067993f, _877, mad(1.2036634683609009f, _876, (_875 * -2.57161445915699e-07f))) - _876) * cb0_036y) + _876;
  float _895 = ((mad(0.9999996423721313f, _877, mad(2.0954757928848267e-08f, _876, (_875 * 1.862645149230957e-08f))) - _877) * cb0_036y) + _877;

  SetTonemappedAP1(_893, _894, _895);

  float _908 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _895, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _894, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _893)))));
  float _909 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _895, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _894, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _893)))));
  float _910 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _895, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _894, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _893)))));
  if (_908 < 0.0031306699384003878f) {
    _921 = (_908 * 12.920000076293945f);
  } else {
    _921 = (((pow(_908, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_909 < 0.0031306699384003878f) {
    _932 = (_909 * 12.920000076293945f);
  } else {
    _932 = (((pow(_909, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_910 < 0.0031306699384003878f) {
    _943 = (_910 * 12.920000076293945f);
  } else {
    _943 = (((pow(_910, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _947 = (_932 * 0.9375f) + 0.03125f;
  float _954 = _943 * 15.0f;
  float _955 = floor(_954);
  float _956 = _954 - _955;
  float _958 = (((_921 * 0.9375f) + 0.03125f) + _955) * 0.0625f;
  float4 _961 = t0.Sample(s0, float2(_958, _947));
  float4 _968 = t0.Sample(s0, float2((_958 + 0.0625f), _947));
  float _987 = max(6.103519990574569e-05f, (((lerp(_961.x, _968.x, _956)) * cb0_005y) + (cb0_005x * _921)));
  float _988 = max(6.103519990574569e-05f, (((lerp(_961.y, _968.y, _956)) * cb0_005y) + (cb0_005x * _932)));
  float _989 = max(6.103519990574569e-05f, (((lerp(_961.z, _968.z, _956)) * cb0_005y) + (cb0_005x * _943)));
  float _1011 = select((_987 > 0.040449999272823334f), exp2(log2((_987 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_987 * 0.07739938050508499f));
  float _1012 = select((_988 > 0.040449999272823334f), exp2(log2((_988 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_988 * 0.07739938050508499f));
  float _1013 = select((_989 > 0.040449999272823334f), exp2(log2((_989 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_989 * 0.07739938050508499f));
  float _1039 = cb0_014x * (((cb0_039y + (cb0_039x * _1011)) * _1011) + cb0_039z);
  float _1040 = cb0_014y * (((cb0_039y + (cb0_039x * _1012)) * _1012) + cb0_039z);
  float _1041 = cb0_014z * (((cb0_039y + (cb0_039x * _1013)) * _1013) + cb0_039z);
  float _1048 = ((cb0_013x - _1039) * cb0_013w) + _1039;
  float _1049 = ((cb0_013y - _1040) * cb0_013w) + _1040;
  float _1050 = ((cb0_013z - _1041) * cb0_013w) + _1041;
  float _1051 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _535, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _533, (_531 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1052 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _535, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _533, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _531)));
  float _1053 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _535, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _533, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _531)));
  float _1060 = ((cb0_013x - _1051) * cb0_013w) + _1051;
  float _1061 = ((cb0_013y - _1052) * cb0_013w) + _1052;
  float _1062 = ((cb0_013z - _1053) * cb0_013w) + _1053;
  float _1074 = exp2(log2(max(0.0f, _1048)) * cb0_040y);
  float _1075 = exp2(log2(max(0.0f, _1049)) * cb0_040y);
  float _1076 = exp2(log2(max(0.0f, _1050)) * cb0_040y);

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    return GenerateOutput(float3(_1074, _1075, _1076), cb0_040w);
  }

  [branch]
  if (cb0_040w == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1099 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1074)));
        float _1102 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1074)));
        float _1105 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1074)));
        _1116 = mad(_41, _1105, mad(_40, _1102, (_1099 * _39)));
        _1117 = mad(_44, _1105, mad(_43, _1102, (_1099 * _42)));
        _1118 = mad(_47, _1105, mad(_46, _1102, (_1099 * _45)));
      } else {
        _1116 = _1074;
        _1117 = _1075;
        _1118 = _1076;
      }
      do {
        if (_1116 < 0.0031306699384003878f) {
          _1129 = (_1116 * 12.920000076293945f);
        } else {
          _1129 = (((pow(_1116, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1117 < 0.0031306699384003878f) {
            _1140 = (_1117 * 12.920000076293945f);
          } else {
            _1140 = (((pow(_1117, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1118 < 0.0031306699384003878f) {
            _2500 = _1129;
            _2501 = _1140;
            _2502 = (_1118 * 12.920000076293945f);
          } else {
            _2500 = _1129;
            _2501 = _1140;
            _2502 = (((pow(_1118, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1167 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1074)));
      float _1170 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1074)));
      float _1173 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1074)));
      float _1183 = max(6.103519990574569e-05f, mad(_41, _1173, mad(_40, _1170, (_1167 * _39))));
      float _1184 = max(6.103519990574569e-05f, mad(_44, _1173, mad(_43, _1170, (_1167 * _42))));
      float _1185 = max(6.103519990574569e-05f, mad(_47, _1173, mad(_46, _1170, (_1167 * _45))));
      _2500 = min((_1183 * 4.5f), ((exp2(log2(max(_1183, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2501 = min((_1184 * 4.5f), ((exp2(log2(max(_1184, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2502 = min((_1185 * 4.5f), ((exp2(log2(max(_1185, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1262 = cb0_012z * _1060;
        float _1263 = cb0_012z * _1061;
        float _1264 = cb0_012z * _1062;
        float _1267 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1264, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1263, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1262)));
        float _1270 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1264, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1263, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1262)));
        float _1273 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1264, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1263, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1262)));
        float _1277 = max(max(_1267, _1270), _1273);
        float _1282 = (max(_1277, 1.000000013351432e-10f) - max(min(min(_1267, _1270), _1273), 1.000000013351432e-10f)) / max(_1277, 0.009999999776482582f);
        float _1295 = ((_1270 + _1267) + _1273) + (sqrt((((_1273 - _1270) * _1273) + ((_1270 - _1267) * _1270)) + ((_1267 - _1273) * _1267)) * 1.75f);
        float _1296 = _1295 * 0.3333333432674408f;
        float _1297 = _1282 + -0.4000000059604645f;
        float _1298 = _1297 * 5.0f;
        float _1302 = max((1.0f - abs(_1297 * 2.5f)), 0.0f);
        float _1313 = ((float((int)(((int)(uint)((bool)(_1298 > 0.0f))) - ((int)(uint)((bool)(_1298 < 0.0f))))) * (1.0f - (_1302 * _1302))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1296 <= 0.0533333346247673f)) {
            if (!(_1296 >= 0.1599999964237213f)) {
              _1322 = (((0.23999999463558197f / _1295) + -0.5f) * _1313);
            } else {
              _1322 = 0.0f;
            }
          } else {
            _1322 = _1313;
          }
          float _1323 = _1322 + 1.0f;
          float _1324 = _1323 * _1267;
          float _1325 = _1323 * _1270;
          float _1326 = _1323 * _1273;
          do {
            if (!((bool)(_1324 == _1325) && (bool)(_1325 == _1326))) {
              float _1333 = ((_1324 * 2.0f) - _1325) - _1326;
              float _1336 = ((_1270 - _1273) * 1.7320507764816284f) * _1323;
              float _1338 = atan(_1336 / _1333);
              bool _1341 = (_1333 < 0.0f);
              bool _1342 = (_1333 == 0.0f);
              bool _1343 = (_1336 >= 0.0f);
              bool _1344 = (_1336 < 0.0f);
              float _1353 = select((_1343 && _1342), 90.0f, select((_1344 && _1342), -90.0f, (select((_1344 && _1341), (_1338 + -3.1415927410125732f), select((_1343 && _1341), (_1338 + 3.1415927410125732f), _1338)) * 57.2957763671875f)));
              if (_1353 < 0.0f) {
                _1358 = (_1353 + 360.0f);
              } else {
                _1358 = _1353;
              }
            } else {
              _1358 = 0.0f;
            }
            float _1360 = min(max(_1358, 0.0f), 360.0f);
            do {
              if (_1360 < -180.0f) {
                _1369 = (_1360 + 360.0f);
              } else {
                if (_1360 > 180.0f) {
                  _1369 = (_1360 + -360.0f);
                } else {
                  _1369 = _1360;
                }
              }
              do {
                if ((bool)(_1369 > -67.5f) && (bool)(_1369 < 67.5f)) {
                  float _1375 = (_1369 + 67.5f) * 0.029629629105329514f;
                  int _1376 = int(_1375);
                  float _1378 = _1375 - float((int)(_1376));
                  float _1379 = _1378 * _1378;
                  float _1380 = _1379 * _1378;
                  if (_1376 == 3) {
                    _1408 = (((0.1666666716337204f - (_1378 * 0.5f)) + (_1379 * 0.5f)) - (_1380 * 0.1666666716337204f));
                  } else {
                    if (_1376 == 2) {
                      _1408 = ((0.6666666865348816f - _1379) + (_1380 * 0.5f));
                    } else {
                      if (_1376 == 1) {
                        _1408 = (((_1380 * -0.5f) + 0.1666666716337204f) + ((_1379 + _1378) * 0.5f));
                      } else {
                        _1408 = select((_1376 == 0), (_1380 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1408 = 0.0f;
                }
                float _1417 = min(max(((((_1282 * 0.27000001072883606f) * (0.029999999329447746f - _1324)) * _1408) + _1324), 0.0f), 65535.0f);
                float _1418 = min(max(_1325, 0.0f), 65535.0f);
                float _1419 = min(max(_1326, 0.0f), 65535.0f);
                float _1432 = min(max(mad(-0.21492856740951538f, _1419, mad(-0.2365107536315918f, _1418, (_1417 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1433 = min(max(mad(-0.09967592358589172f, _1419, mad(1.17622971534729f, _1418, (_1417 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1434 = min(max(mad(0.9977163076400757f, _1419, mad(-0.006032449658960104f, _1418, (_1417 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1435 = dot(float3(_1432, _1433, _1434), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1446 = log2(max((lerp(_1435, _1432, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1447 = _1446 * 0.3010300099849701f;
                float _1448 = log2(cb0_008x);
                float _1449 = _1448 * 0.3010300099849701f;
                do {
                  if (!(!(_1447 <= _1449))) {
                    _1518 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1456 = log2(cb0_009x);
                    float _1457 = _1456 * 0.3010300099849701f;
                    if ((bool)(_1447 > _1449) && (bool)(_1447 < _1457)) {
                      float _1465 = ((_1446 - _1448) * 0.9030900001525879f) / ((_1456 - _1448) * 0.3010300099849701f);
                      int _1466 = int(_1465);
                      float _1468 = _1465 - float((int)(_1466));
                      float _1470 = _12[_1466];
                      float _1473 = _12[(_1466 + 1)];
                      float _1478 = _1470 * 0.5f;
                      _1518 = dot(float3((_1468 * _1468), _1468, 1.0f), float3(mad((_12[(_1466 + 2)]), 0.5f, mad(_1473, -1.0f, _1478)), (_1473 - _1470), mad(_1473, 0.5f, _1478)));
                    } else {
                      do {
                        if (!(!(_1447 >= _1457))) {
                          float _1487 = log2(cb0_008z);
                          if (_1447 < (_1487 * 0.3010300099849701f)) {
                            float _1495 = ((_1446 - _1456) * 0.9030900001525879f) / ((_1487 - _1456) * 0.3010300099849701f);
                            int _1496 = int(_1495);
                            float _1498 = _1495 - float((int)(_1496));
                            float _1500 = _13[_1496];
                            float _1503 = _13[(_1496 + 1)];
                            float _1508 = _1500 * 0.5f;
                            _1518 = dot(float3((_1498 * _1498), _1498, 1.0f), float3(mad((_13[(_1496 + 2)]), 0.5f, mad(_1503, -1.0f, _1508)), (_1503 - _1500), mad(_1503, 0.5f, _1508)));
                            break;
                          }
                        }
                        _1518 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1522 = log2(max((lerp(_1435, _1433, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1523 = _1522 * 0.3010300099849701f;
                  do {
                    if (!(!(_1523 <= _1449))) {
                      _1592 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1530 = log2(cb0_009x);
                      float _1531 = _1530 * 0.3010300099849701f;
                      if ((bool)(_1523 > _1449) && (bool)(_1523 < _1531)) {
                        float _1539 = ((_1522 - _1448) * 0.9030900001525879f) / ((_1530 - _1448) * 0.3010300099849701f);
                        int _1540 = int(_1539);
                        float _1542 = _1539 - float((int)(_1540));
                        float _1544 = _12[_1540];
                        float _1547 = _12[(_1540 + 1)];
                        float _1552 = _1544 * 0.5f;
                        _1592 = dot(float3((_1542 * _1542), _1542, 1.0f), float3(mad((_12[(_1540 + 2)]), 0.5f, mad(_1547, -1.0f, _1552)), (_1547 - _1544), mad(_1547, 0.5f, _1552)));
                      } else {
                        do {
                          if (!(!(_1523 >= _1531))) {
                            float _1561 = log2(cb0_008z);
                            if (_1523 < (_1561 * 0.3010300099849701f)) {
                              float _1569 = ((_1522 - _1530) * 0.9030900001525879f) / ((_1561 - _1530) * 0.3010300099849701f);
                              int _1570 = int(_1569);
                              float _1572 = _1569 - float((int)(_1570));
                              float _1574 = _13[_1570];
                              float _1577 = _13[(_1570 + 1)];
                              float _1582 = _1574 * 0.5f;
                              _1592 = dot(float3((_1572 * _1572), _1572, 1.0f), float3(mad((_13[(_1570 + 2)]), 0.5f, mad(_1577, -1.0f, _1582)), (_1577 - _1574), mad(_1577, 0.5f, _1582)));
                              break;
                            }
                          }
                          _1592 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1596 = log2(max((lerp(_1435, _1434, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1597 = _1596 * 0.3010300099849701f;
                    do {
                      if (!(!(_1597 <= _1449))) {
                        _1666 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1604 = log2(cb0_009x);
                        float _1605 = _1604 * 0.3010300099849701f;
                        if ((bool)(_1597 > _1449) && (bool)(_1597 < _1605)) {
                          float _1613 = ((_1596 - _1448) * 0.9030900001525879f) / ((_1604 - _1448) * 0.3010300099849701f);
                          int _1614 = int(_1613);
                          float _1616 = _1613 - float((int)(_1614));
                          float _1618 = _12[_1614];
                          float _1621 = _12[(_1614 + 1)];
                          float _1626 = _1618 * 0.5f;
                          _1666 = dot(float3((_1616 * _1616), _1616, 1.0f), float3(mad((_12[(_1614 + 2)]), 0.5f, mad(_1621, -1.0f, _1626)), (_1621 - _1618), mad(_1621, 0.5f, _1626)));
                        } else {
                          do {
                            if (!(!(_1597 >= _1605))) {
                              float _1635 = log2(cb0_008z);
                              if (_1597 < (_1635 * 0.3010300099849701f)) {
                                float _1643 = ((_1596 - _1604) * 0.9030900001525879f) / ((_1635 - _1604) * 0.3010300099849701f);
                                int _1644 = int(_1643);
                                float _1646 = _1643 - float((int)(_1644));
                                float _1648 = _13[_1644];
                                float _1651 = _13[(_1644 + 1)];
                                float _1656 = _1648 * 0.5f;
                                _1666 = dot(float3((_1646 * _1646), _1646, 1.0f), float3(mad((_13[(_1644 + 2)]), 0.5f, mad(_1651, -1.0f, _1656)), (_1651 - _1648), mad(_1651, 0.5f, _1656)));
                                break;
                              }
                            }
                            _1666 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1670 = cb0_008w - cb0_008y;
                      float _1671 = (exp2(_1518 * 3.321928024291992f) - cb0_008y) / _1670;
                      float _1673 = (exp2(_1592 * 3.321928024291992f) - cb0_008y) / _1670;
                      float _1675 = (exp2(_1666 * 3.321928024291992f) - cb0_008y) / _1670;
                      float _1678 = mad(0.15618768334388733f, _1675, mad(0.13400420546531677f, _1673, (_1671 * 0.6624541878700256f)));
                      float _1681 = mad(0.053689517080783844f, _1675, mad(0.6740817427635193f, _1673, (_1671 * 0.2722287178039551f)));
                      float _1684 = mad(1.0103391408920288f, _1675, mad(0.00406073359772563f, _1673, (_1671 * -0.005574649665504694f)));
                      float _1697 = min(max(mad(-0.23642469942569733f, _1684, mad(-0.32480329275131226f, _1681, (_1678 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1698 = min(max(mad(0.016756348311901093f, _1684, mad(1.6153316497802734f, _1681, (_1678 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1699 = min(max(mad(0.9883948564529419f, _1684, mad(-0.008284442126750946f, _1681, (_1678 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1702 = mad(0.15618768334388733f, _1699, mad(0.13400420546531677f, _1698, (_1697 * 0.6624541878700256f)));
                      float _1705 = mad(0.053689517080783844f, _1699, mad(0.6740817427635193f, _1698, (_1697 * 0.2722287178039551f)));
                      float _1708 = mad(1.0103391408920288f, _1699, mad(0.00406073359772563f, _1698, (_1697 * -0.005574649665504694f)));
                      float _1730 = min(max((min(max(mad(-0.23642469942569733f, _1708, mad(-0.32480329275131226f, _1705, (_1702 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1731 = min(max((min(max(mad(0.016756348311901093f, _1708, mad(1.6153316497802734f, _1705, (_1702 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1732 = min(max((min(max(mad(0.9883948564529419f, _1708, mad(-0.008284442126750946f, _1705, (_1702 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(cb0_040w == 5)) {
                          _1745 = mad(_41, _1732, mad(_40, _1731, (_1730 * _39)));
                          _1746 = mad(_44, _1732, mad(_43, _1731, (_1730 * _42)));
                          _1747 = mad(_47, _1732, mad(_46, _1731, (_1730 * _45)));
                        } else {
                          _1745 = _1730;
                          _1746 = _1731;
                          _1747 = _1732;
                        }
                        float _1757 = exp2(log2(_1745 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1758 = exp2(log2(_1746 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1759 = exp2(log2(_1747 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2500 = exp2(log2((1.0f / ((_1757 * 18.6875f) + 1.0f)) * ((_1757 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2501 = exp2(log2((1.0f / ((_1758 * 18.6875f) + 1.0f)) * ((_1758 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2502 = exp2(log2((1.0f / ((_1759 * 18.6875f) + 1.0f)) * ((_1759 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1838 = cb0_012z * _1060;
          float _1839 = cb0_012z * _1061;
          float _1840 = cb0_012z * _1062;
          float _1843 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1840, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1839, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1838)));
          float _1846 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1840, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1839, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1838)));
          float _1849 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1840, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1839, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1838)));
          float _1853 = max(max(_1843, _1846), _1849);
          float _1858 = (max(_1853, 1.000000013351432e-10f) - max(min(min(_1843, _1846), _1849), 1.000000013351432e-10f)) / max(_1853, 0.009999999776482582f);
          float _1871 = ((_1846 + _1843) + _1849) + (sqrt((((_1849 - _1846) * _1849) + ((_1846 - _1843) * _1846)) + ((_1843 - _1849) * _1843)) * 1.75f);
          float _1872 = _1871 * 0.3333333432674408f;
          float _1873 = _1858 + -0.4000000059604645f;
          float _1874 = _1873 * 5.0f;
          float _1878 = max((1.0f - abs(_1873 * 2.5f)), 0.0f);
          float _1889 = ((float((int)(((int)(uint)((bool)(_1874 > 0.0f))) - ((int)(uint)((bool)(_1874 < 0.0f))))) * (1.0f - (_1878 * _1878))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1872 <= 0.0533333346247673f)) {
              if (!(_1872 >= 0.1599999964237213f)) {
                _1898 = (((0.23999999463558197f / _1871) + -0.5f) * _1889);
              } else {
                _1898 = 0.0f;
              }
            } else {
              _1898 = _1889;
            }
            float _1899 = _1898 + 1.0f;
            float _1900 = _1899 * _1843;
            float _1901 = _1899 * _1846;
            float _1902 = _1899 * _1849;
            do {
              if (!((bool)(_1900 == _1901) && (bool)(_1901 == _1902))) {
                float _1909 = ((_1900 * 2.0f) - _1901) - _1902;
                float _1912 = ((_1846 - _1849) * 1.7320507764816284f) * _1899;
                float _1914 = atan(_1912 / _1909);
                bool _1917 = (_1909 < 0.0f);
                bool _1918 = (_1909 == 0.0f);
                bool _1919 = (_1912 >= 0.0f);
                bool _1920 = (_1912 < 0.0f);
                float _1929 = select((_1919 && _1918), 90.0f, select((_1920 && _1918), -90.0f, (select((_1920 && _1917), (_1914 + -3.1415927410125732f), select((_1919 && _1917), (_1914 + 3.1415927410125732f), _1914)) * 57.2957763671875f)));
                if (_1929 < 0.0f) {
                  _1934 = (_1929 + 360.0f);
                } else {
                  _1934 = _1929;
                }
              } else {
                _1934 = 0.0f;
              }
              float _1936 = min(max(_1934, 0.0f), 360.0f);
              do {
                if (_1936 < -180.0f) {
                  _1945 = (_1936 + 360.0f);
                } else {
                  if (_1936 > 180.0f) {
                    _1945 = (_1936 + -360.0f);
                  } else {
                    _1945 = _1936;
                  }
                }
                do {
                  if ((bool)(_1945 > -67.5f) && (bool)(_1945 < 67.5f)) {
                    float _1951 = (_1945 + 67.5f) * 0.029629629105329514f;
                    int _1952 = int(_1951);
                    float _1954 = _1951 - float((int)(_1952));
                    float _1955 = _1954 * _1954;
                    float _1956 = _1955 * _1954;
                    if (_1952 == 3) {
                      _1984 = (((0.1666666716337204f - (_1954 * 0.5f)) + (_1955 * 0.5f)) - (_1956 * 0.1666666716337204f));
                    } else {
                      if (_1952 == 2) {
                        _1984 = ((0.6666666865348816f - _1955) + (_1956 * 0.5f));
                      } else {
                        if (_1952 == 1) {
                          _1984 = (((_1956 * -0.5f) + 0.1666666716337204f) + ((_1955 + _1954) * 0.5f));
                        } else {
                          _1984 = select((_1952 == 0), (_1956 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1984 = 0.0f;
                  }
                  float _1993 = min(max(((((_1858 * 0.27000001072883606f) * (0.029999999329447746f - _1900)) * _1984) + _1900), 0.0f), 65535.0f);
                  float _1994 = min(max(_1901, 0.0f), 65535.0f);
                  float _1995 = min(max(_1902, 0.0f), 65535.0f);
                  float _2008 = min(max(mad(-0.21492856740951538f, _1995, mad(-0.2365107536315918f, _1994, (_1993 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2009 = min(max(mad(-0.09967592358589172f, _1995, mad(1.17622971534729f, _1994, (_1993 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2010 = min(max(mad(0.9977163076400757f, _1995, mad(-0.006032449658960104f, _1994, (_1993 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2011 = dot(float3(_2008, _2009, _2010), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2022 = log2(max((lerp(_2011, _2008, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2023 = _2022 * 0.3010300099849701f;
                  float _2024 = log2(cb0_008x);
                  float _2025 = _2024 * 0.3010300099849701f;
                  do {
                    if (!(!(_2023 <= _2025))) {
                      _2094 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2032 = log2(cb0_009x);
                      float _2033 = _2032 * 0.3010300099849701f;
                      if ((bool)(_2023 > _2025) && (bool)(_2023 < _2033)) {
                        float _2041 = ((_2022 - _2024) * 0.9030900001525879f) / ((_2032 - _2024) * 0.3010300099849701f);
                        int _2042 = int(_2041);
                        float _2044 = _2041 - float((int)(_2042));
                        float _2046 = _10[_2042];
                        float _2049 = _10[(_2042 + 1)];
                        float _2054 = _2046 * 0.5f;
                        _2094 = dot(float3((_2044 * _2044), _2044, 1.0f), float3(mad((_10[(_2042 + 2)]), 0.5f, mad(_2049, -1.0f, _2054)), (_2049 - _2046), mad(_2049, 0.5f, _2054)));
                      } else {
                        do {
                          if (!(!(_2023 >= _2033))) {
                            float _2063 = log2(cb0_008z);
                            if (_2023 < (_2063 * 0.3010300099849701f)) {
                              float _2071 = ((_2022 - _2032) * 0.9030900001525879f) / ((_2063 - _2032) * 0.3010300099849701f);
                              int _2072 = int(_2071);
                              float _2074 = _2071 - float((int)(_2072));
                              float _2076 = _11[_2072];
                              float _2079 = _11[(_2072 + 1)];
                              float _2084 = _2076 * 0.5f;
                              _2094 = dot(float3((_2074 * _2074), _2074, 1.0f), float3(mad((_11[(_2072 + 2)]), 0.5f, mad(_2079, -1.0f, _2084)), (_2079 - _2076), mad(_2079, 0.5f, _2084)));
                              break;
                            }
                          }
                          _2094 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2098 = log2(max((lerp(_2011, _2009, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2099 = _2098 * 0.3010300099849701f;
                    do {
                      if (!(!(_2099 <= _2025))) {
                        _2168 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2106 = log2(cb0_009x);
                        float _2107 = _2106 * 0.3010300099849701f;
                        if ((bool)(_2099 > _2025) && (bool)(_2099 < _2107)) {
                          float _2115 = ((_2098 - _2024) * 0.9030900001525879f) / ((_2106 - _2024) * 0.3010300099849701f);
                          int _2116 = int(_2115);
                          float _2118 = _2115 - float((int)(_2116));
                          float _2120 = _10[_2116];
                          float _2123 = _10[(_2116 + 1)];
                          float _2128 = _2120 * 0.5f;
                          _2168 = dot(float3((_2118 * _2118), _2118, 1.0f), float3(mad((_10[(_2116 + 2)]), 0.5f, mad(_2123, -1.0f, _2128)), (_2123 - _2120), mad(_2123, 0.5f, _2128)));
                        } else {
                          do {
                            if (!(!(_2099 >= _2107))) {
                              float _2137 = log2(cb0_008z);
                              if (_2099 < (_2137 * 0.3010300099849701f)) {
                                float _2145 = ((_2098 - _2106) * 0.9030900001525879f) / ((_2137 - _2106) * 0.3010300099849701f);
                                int _2146 = int(_2145);
                                float _2148 = _2145 - float((int)(_2146));
                                float _2150 = _11[_2146];
                                float _2153 = _11[(_2146 + 1)];
                                float _2158 = _2150 * 0.5f;
                                _2168 = dot(float3((_2148 * _2148), _2148, 1.0f), float3(mad((_11[(_2146 + 2)]), 0.5f, mad(_2153, -1.0f, _2158)), (_2153 - _2150), mad(_2153, 0.5f, _2158)));
                                break;
                              }
                            }
                            _2168 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2172 = log2(max((lerp(_2011, _2010, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2173 = _2172 * 0.3010300099849701f;
                      do {
                        if (!(!(_2173 <= _2025))) {
                          _2242 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2180 = log2(cb0_009x);
                          float _2181 = _2180 * 0.3010300099849701f;
                          if ((bool)(_2173 > _2025) && (bool)(_2173 < _2181)) {
                            float _2189 = ((_2172 - _2024) * 0.9030900001525879f) / ((_2180 - _2024) * 0.3010300099849701f);
                            int _2190 = int(_2189);
                            float _2192 = _2189 - float((int)(_2190));
                            float _2194 = _10[_2190];
                            float _2197 = _10[(_2190 + 1)];
                            float _2202 = _2194 * 0.5f;
                            _2242 = dot(float3((_2192 * _2192), _2192, 1.0f), float3(mad((_10[(_2190 + 2)]), 0.5f, mad(_2197, -1.0f, _2202)), (_2197 - _2194), mad(_2197, 0.5f, _2202)));
                          } else {
                            do {
                              if (!(!(_2173 >= _2181))) {
                                float _2211 = log2(cb0_008z);
                                if (_2173 < (_2211 * 0.3010300099849701f)) {
                                  float _2219 = ((_2172 - _2180) * 0.9030900001525879f) / ((_2211 - _2180) * 0.3010300099849701f);
                                  int _2220 = int(_2219);
                                  float _2222 = _2219 - float((int)(_2220));
                                  float _2224 = _11[_2220];
                                  float _2227 = _11[(_2220 + 1)];
                                  float _2232 = _2224 * 0.5f;
                                  _2242 = dot(float3((_2222 * _2222), _2222, 1.0f), float3(mad((_11[(_2220 + 2)]), 0.5f, mad(_2227, -1.0f, _2232)), (_2227 - _2224), mad(_2227, 0.5f, _2232)));
                                  break;
                                }
                              }
                              _2242 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2246 = cb0_008w - cb0_008y;
                        float _2247 = (exp2(_2094 * 3.321928024291992f) - cb0_008y) / _2246;
                        float _2249 = (exp2(_2168 * 3.321928024291992f) - cb0_008y) / _2246;
                        float _2251 = (exp2(_2242 * 3.321928024291992f) - cb0_008y) / _2246;
                        float _2254 = mad(0.15618768334388733f, _2251, mad(0.13400420546531677f, _2249, (_2247 * 0.6624541878700256f)));
                        float _2257 = mad(0.053689517080783844f, _2251, mad(0.6740817427635193f, _2249, (_2247 * 0.2722287178039551f)));
                        float _2260 = mad(1.0103391408920288f, _2251, mad(0.00406073359772563f, _2249, (_2247 * -0.005574649665504694f)));
                        float _2273 = min(max(mad(-0.23642469942569733f, _2260, mad(-0.32480329275131226f, _2257, (_2254 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2274 = min(max(mad(0.016756348311901093f, _2260, mad(1.6153316497802734f, _2257, (_2254 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2275 = min(max(mad(0.9883948564529419f, _2260, mad(-0.008284442126750946f, _2257, (_2254 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2278 = mad(0.15618768334388733f, _2275, mad(0.13400420546531677f, _2274, (_2273 * 0.6624541878700256f)));
                        float _2281 = mad(0.053689517080783844f, _2275, mad(0.6740817427635193f, _2274, (_2273 * 0.2722287178039551f)));
                        float _2284 = mad(1.0103391408920288f, _2275, mad(0.00406073359772563f, _2274, (_2273 * -0.005574649665504694f)));
                        float _2306 = min(max((min(max(mad(-0.23642469942569733f, _2284, mad(-0.32480329275131226f, _2281, (_2278 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2307 = min(max((min(max(mad(0.016756348311901093f, _2284, mad(1.6153316497802734f, _2281, (_2278 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2308 = min(max((min(max(mad(0.9883948564529419f, _2284, mad(-0.008284442126750946f, _2281, (_2278 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 6)) {
                            _2321 = mad(_41, _2308, mad(_40, _2307, (_2306 * _39)));
                            _2322 = mad(_44, _2308, mad(_43, _2307, (_2306 * _42)));
                            _2323 = mad(_47, _2308, mad(_46, _2307, (_2306 * _45)));
                          } else {
                            _2321 = _2306;
                            _2322 = _2307;
                            _2323 = _2308;
                          }
                          float _2333 = exp2(log2(_2321 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2334 = exp2(log2(_2322 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2335 = exp2(log2(_2323 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2500 = exp2(log2((1.0f / ((_2333 * 18.6875f) + 1.0f)) * ((_2333 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2501 = exp2(log2((1.0f / ((_2334 * 18.6875f) + 1.0f)) * ((_2334 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2502 = exp2(log2((1.0f / ((_2335 * 18.6875f) + 1.0f)) * ((_2335 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2380 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1062, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1061, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1060)));
            float _2383 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1062, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1061, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1060)));
            float _2386 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1062, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1061, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1060)));
            float _2405 = exp2(log2(mad(_41, _2386, mad(_40, _2383, (_2380 * _39))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2406 = exp2(log2(mad(_44, _2386, mad(_43, _2383, (_2380 * _42))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2407 = exp2(log2(mad(_47, _2386, mad(_46, _2383, (_2380 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2500 = exp2(log2((1.0f / ((_2405 * 18.6875f) + 1.0f)) * ((_2405 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2501 = exp2(log2((1.0f / ((_2406 * 18.6875f) + 1.0f)) * ((_2406 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2502 = exp2(log2((1.0f / ((_2407 * 18.6875f) + 1.0f)) * ((_2407 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2454 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1050, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1049, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1048)));
                float _2457 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1050, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1049, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1048)));
                float _2460 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1050, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1049, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1048)));
                _2500 = mad(_41, _2460, mad(_40, _2457, (_2454 * _39)));
                _2501 = mad(_44, _2460, mad(_43, _2457, (_2454 * _42)));
                _2502 = mad(_47, _2460, mad(_46, _2457, (_2454 * _45)));
              } else {
                float _2473 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1074)));
                float _2476 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1074)));
                float _2479 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1076, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1075, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1074)));
                _2500 = exp2(log2(mad(_41, _2479, mad(_40, _2476, (_2473 * _39)))) * cb0_040z);
                _2501 = exp2(log2(mad(_44, _2479, mad(_43, _2476, (_2473 * _42)))) * cb0_040z);
                _2502 = exp2(log2(mad(_47, _2479, mad(_46, _2476, (_2473 * _45)))) * cb0_040z);
              }
            } else {
              _2500 = _1060;
              _2501 = _1061;
              _2502 = _1062;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2500 * 0.9523810148239136f);
  SV_Target.y = (_2501 * 0.9523810148239136f);
  SV_Target.z = (_2502 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
