// Jusant

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
  uint cb0_040w : packoffset(c040.w);
  uint cb0_041x : packoffset(c041.x);
};

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
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
  float _12 = TEXCOORD.x + -0.015625f;
  float _13 = TEXCOORD.y + -0.015625f;
  float _16 = float((uint)SV_RenderTargetArrayIndex);
  float _37;
  float _38;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _103;
  float _104;
  float _105;
  float _629;
  float _665;
  float _676;
  float _740;
  float _1008;
  float _1009;
  float _1010;
  float _1021;
  float _1032;
  float _1214;
  float _1250;
  float _1261;
  float _1300;
  float _1410;
  float _1484;
  float _1558;
  float _1637;
  float _1638;
  float _1639;
  float _1790;
  float _1826;
  float _1837;
  float _1876;
  float _1986;
  float _2060;
  float _2134;
  float _2213;
  float _2214;
  float _2215;
  float _2392;
  float _2393;
  float _2394;
  if (!((uint)(cb0_041x) == 1)) {
    if (!((uint)(cb0_041x) == 2)) {
      if (!((uint)(cb0_041x) == 3)) {
        bool _26 = ((uint)(cb0_041x) == 4);
        _37 = select(_26, 1.0f, 1.7050515413284302f);
        _38 = select(_26, 0.0f, -0.6217905879020691f);
        _39 = select(_26, 0.0f, -0.0832584798336029f);
        _40 = select(_26, 0.0f, -0.13025718927383423f);
        _41 = select(_26, 1.0f, 1.1408027410507202f);
        _42 = select(_26, 0.0f, -0.010548528283834457f);
        _43 = select(_26, 0.0f, -0.024003278464078903f);
        _44 = select(_26, 0.0f, -0.1289687603712082f);
        _45 = select(_26, 1.0f, 1.152971863746643f);
      } else {
        _37 = 0.6954522132873535f;
        _38 = 0.14067870378494263f;
        _39 = 0.16386906802654266f;
        _40 = 0.044794563204050064f;
        _41 = 0.8596711158752441f;
        _42 = 0.0955343171954155f;
        _43 = -0.005525882821530104f;
        _44 = 0.004025210160762072f;
        _45 = 1.0015007257461548f;
      }
    } else {
      _37 = 1.02579927444458f;
      _38 = -0.020052503794431686f;
      _39 = -0.0057713985443115234f;
      _40 = -0.0022350111976265907f;
      _41 = 1.0045825242996216f;
      _42 = -0.002352306619286537f;
      _43 = -0.005014004185795784f;
      _44 = -0.025293385609984398f;
      _45 = 1.0304402112960815f;
    }
  } else {
    _37 = 1.379158854484558f;
    _38 = -0.3088507056236267f;
    _39 = -0.07034677267074585f;
    _40 = -0.06933528929948807f;
    _41 = 1.0822921991348267f;
    _42 = -0.012962047010660172f;
    _43 = -0.002159259282052517f;
    _44 = -0.045465391129255295f;
    _45 = 1.0477596521377563f;
  }
  if ((uint)(uint)(cb0_040w) > (uint)2) {
    float _56 = exp2(log2(_12 * 1.0322580337524414f) * 0.012683313339948654f);
    float _57 = exp2(log2(_13 * 1.0322580337524414f) * 0.012683313339948654f);
    float _58 = exp2(log2(_16 * 0.032258063554763794f) * 0.012683313339948654f);
    _103 = (exp2(log2(max(0.0f, (_56 + -0.8359375f)) / (18.8515625f - (_56 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _104 = (exp2(log2(max(0.0f, (_57 + -0.8359375f)) / (18.8515625f - (_57 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _103 = ((exp2((_12 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _104 = ((exp2((_13 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _105 = ((exp2((_16 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _120 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _105, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _104, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _103)));
  float _123 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _105, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _104, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _103)));
  float _126 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _105, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _104, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _103)));
  float _127 = dot(float3(_120, _123, _126), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_120, _123, _126));

  float _131 = (_120 / _127) + -1.0f;
  float _132 = (_123 / _127) + -1.0f;
  float _133 = (_126 / _127) + -1.0f;
  float _145 = (1.0f - exp2(((_127 * _127) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_131, _132, _133), float3(_131, _132, _133)) * -4.0f));
  float _161 = ((mad(-0.06368283927440643f, _126, mad(-0.32929131388664246f, _123, (_120 * 1.370412826538086f))) - _120) * _145) + _120;
  float _162 = ((mad(-0.010861567221581936f, _126, mad(1.0970908403396606f, _123, (_120 * -0.08343426138162613f))) - _123) * _145) + _123;
  float _163 = ((mad(1.203694462776184f, _126, mad(-0.09862564504146576f, _123, (_120 * -0.02579325996339321f))) - _126) * _145) + _126;
  float _164 = dot(float3(_161, _162, _163), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _178 = cb0_019w + cb0_024w;
  float _192 = cb0_018w * cb0_023w;
  float _206 = cb0_017w * cb0_022w;
  float _220 = cb0_016w * cb0_021w;
  float _234 = cb0_015w * cb0_020w;
  float _238 = _161 - _164;
  float _239 = _162 - _164;
  float _240 = _163 - _164;
  float _298 = saturate(_164 / cb0_035z);
  float _302 = (_298 * _298) * (3.0f - (_298 * 2.0f));
  float _303 = 1.0f - _302;
  float _312 = cb0_019w + cb0_034w;
  float _321 = cb0_018w * cb0_033w;
  float _330 = cb0_017w * cb0_032w;
  float _339 = cb0_016w * cb0_031w;
  float _348 = cb0_015w * cb0_030w;
  float _411 = saturate((_164 - cb0_035w) / (cb0_036x - cb0_035w));
  float _415 = (_411 * _411) * (3.0f - (_411 * 2.0f));
  float _424 = cb0_019w + cb0_029w;
  float _433 = cb0_018w * cb0_028w;
  float _442 = cb0_017w * cb0_027w;
  float _451 = cb0_016w * cb0_026w;
  float _460 = cb0_015w * cb0_025w;
  float _518 = _302 - _415;
  float _529 = ((_415 * (((cb0_019x + cb0_034x) + _312) + (((cb0_018x * cb0_033x) * _321) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _339) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _348) * _238) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _330)))))) + (_303 * (((cb0_019x + cb0_024x) + _178) + (((cb0_018x * cb0_023x) * _192) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _220) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _234) * _238) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _206))))))) + ((((cb0_019x + cb0_029x) + _424) + (((cb0_018x * cb0_028x) * _433) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _451) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _460) * _238) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _442))))) * _518);
  float _531 = ((_415 * (((cb0_019y + cb0_034y) + _312) + (((cb0_018y * cb0_033y) * _321) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _339) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _348) * _239) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _330)))))) + (_303 * (((cb0_019y + cb0_024y) + _178) + (((cb0_018y * cb0_023y) * _192) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _220) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _234) * _239) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _206))))))) + ((((cb0_019y + cb0_029y) + _424) + (((cb0_018y * cb0_028y) * _433) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _451) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _460) * _239) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _442))))) * _518);
  float _533 = ((_415 * (((cb0_019z + cb0_034z) + _312) + (((cb0_018z * cb0_033z) * _321) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _339) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _348) * _240) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _330)))))) + (_303 * (((cb0_019z + cb0_024z) + _178) + (((cb0_018z * cb0_023z) * _192) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _220) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _234) * _240) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _206))))))) + ((((cb0_019z + cb0_029z) + _424) + (((cb0_018z * cb0_028z) * _433) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _451) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _460) * _240) + _164)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _442))))) * _518);

  SetUntonemappedAP1(float3(_529, _531, _533));

  float _569 = ((mad(0.061360642313957214f, _533, mad(-4.540197551250458e-09f, _531, (_529 * 0.9386394023895264f))) - _529) * cb0_036y) + _529;
  float _570 = ((mad(0.169205904006958f, _533, mad(0.8307942152023315f, _531, (_529 * 6.775371730327606e-08f))) - _531) * cb0_036y) + _531;
  float _571 = (mad(-2.3283064365386963e-10f, _531, (_529 * -9.313225746154785e-10f)) * cb0_036y) + _533;
  float _574 = mad(0.16386905312538147f, _571, mad(0.14067868888378143f, _570, (_569 * 0.6954522132873535f)));
  float _577 = mad(0.0955343246459961f, _571, mad(0.8596711158752441f, _570, (_569 * 0.044794581830501556f)));
  float _580 = mad(1.0015007257461548f, _571, mad(0.004025210160762072f, _570, (_569 * -0.005525882821530104f)));
  float _584 = max(max(_574, _577), _580);
  float _589 = (max(_584, 1.000000013351432e-10f) - max(min(min(_574, _577), _580), 1.000000013351432e-10f)) / max(_584, 0.009999999776482582f);
  float _602 = ((_577 + _574) + _580) + (sqrt((((_580 - _577) * _580) + ((_577 - _574) * _577)) + ((_574 - _580) * _574)) * 1.75f);
  float _603 = _602 * 0.3333333432674408f;
  float _604 = _589 + -0.4000000059604645f;
  float _605 = _604 * 5.0f;
  float _609 = max((1.0f - abs(_604 * 2.5f)), 0.0f);
  float _620 = ((float(((int)(uint)((bool)(_605 > 0.0f))) - ((int)(uint)((bool)(_605 < 0.0f)))) * (1.0f - (_609 * _609))) + 1.0f) * 0.02500000037252903f;
  if (!(_603 <= 0.0533333346247673f)) {
    if (!(_603 >= 0.1599999964237213f)) {
      _629 = (((0.23999999463558197f / _602) + -0.5f) * _620);
    } else {
      _629 = 0.0f;
    }
  } else {
    _629 = _620;
  }
  float _630 = _629 + 1.0f;
  float _631 = _630 * _574;
  float _632 = _630 * _577;
  float _633 = _630 * _580;
  if (!((bool)(_631 == _632) && (bool)(_632 == _633))) {
    float _640 = ((_631 * 2.0f) - _632) - _633;
    float _643 = ((_577 - _580) * 1.7320507764816284f) * _630;
    float _645 = atan(_643 / _640);
    bool _648 = (_640 < 0.0f);
    bool _649 = (_640 == 0.0f);
    bool _650 = (_643 >= 0.0f);
    bool _651 = (_643 < 0.0f);
    float _660 = select((_650 && _649), 90.0f, select((_651 && _649), -90.0f, (select((_651 && _648), (_645 + -3.1415927410125732f), select((_650 && _648), (_645 + 3.1415927410125732f), _645)) * 57.2957763671875f)));
    if (_660 < 0.0f) {
      _665 = (_660 + 360.0f);
    } else {
      _665 = _660;
    }
  } else {
    _665 = 0.0f;
  }
  float _667 = min(max(_665, 0.0f), 360.0f);
  if (_667 < -180.0f) {
    _676 = (_667 + 360.0f);
  } else {
    if (_667 > 180.0f) {
      _676 = (_667 + -360.0f);
    } else {
      _676 = _667;
    }
  }
  float _680 = saturate(1.0f - abs(_676 * 0.014814814552664757f));
  float _684 = (_680 * _680) * (3.0f - (_680 * 2.0f));
  float _690 = ((_684 * _684) * ((_589 * 0.18000000715255737f) * (0.029999999329447746f - _631))) + _631;
  float _700 = max(0.0f, mad(-0.21492856740951538f, _633, mad(-0.2365107536315918f, _632, (_690 * 1.4514392614364624f))));
  float _701 = max(0.0f, mad(-0.09967592358589172f, _633, mad(1.17622971534729f, _632, (_690 * -0.07655377686023712f))));
  float _702 = max(0.0f, mad(0.9977163076400757f, _633, mad(-0.006032449658960104f, _632, (_690 * 0.008316148072481155f))));
  float _703 = dot(float3(_700, _701, _702), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _717 = (cb0_037w + 1.0f) - cb0_037y;
  float _720 = cb0_038x + 1.0f;
  float _722 = _720 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _740 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _731 = (cb0_037w + 0.18000000715255737f) / _717;
    _740 = (-0.7447274923324585f - ((log2(_731 / (2.0f - _731)) * 0.3465735912322998f) * (_717 / cb0_037x)));
  }
  float _743 = ((1.0f - cb0_037y) / cb0_037x) - _740;
  float _745 = (cb0_037z / cb0_037x) - _743;
  float _749 = log2(lerp(_703, _700, 0.9599999785423279f)) * 0.3010300099849701f;
  float _750 = log2(lerp(_703, _701, 0.9599999785423279f)) * 0.3010300099849701f;
  float _751 = log2(lerp(_703, _702, 0.9599999785423279f)) * 0.3010300099849701f;
  float _755 = cb0_037x * (_749 + _743);
  float _756 = cb0_037x * (_750 + _743);
  float _757 = cb0_037x * (_751 + _743);
  float _758 = _717 * 2.0f;
  float _760 = (cb0_037x * -2.0f) / _717;
  float _761 = _749 - _740;
  float _762 = _750 - _740;
  float _763 = _751 - _740;
  float _782 = _722 * 2.0f;
  float _784 = (cb0_037x * 2.0f) / _722;
  float _809 = select((_749 < _740), ((_758 / (exp2((_761 * 1.4426950216293335f) * _760) + 1.0f)) - cb0_037w), _755);
  float _810 = select((_750 < _740), ((_758 / (exp2((_762 * 1.4426950216293335f) * _760) + 1.0f)) - cb0_037w), _756);
  float _811 = select((_751 < _740), ((_758 / (exp2((_763 * 1.4426950216293335f) * _760) + 1.0f)) - cb0_037w), _757);
  float _818 = _745 - _740;
  float _822 = saturate(_761 / _818);
  float _823 = saturate(_762 / _818);
  float _824 = saturate(_763 / _818);
  bool _825 = (_745 < _740);
  float _829 = select(_825, (1.0f - _822), _822);
  float _830 = select(_825, (1.0f - _823), _823);
  float _831 = select(_825, (1.0f - _824), _824);
  float _850 = (((_829 * _829) * (select((_749 > _745), (_720 - (_782 / (exp2(((_749 - _745) * 1.4426950216293335f) * _784) + 1.0f))), _755) - _809)) * (3.0f - (_829 * 2.0f))) + _809;
  float _851 = (((_830 * _830) * (select((_750 > _745), (_720 - (_782 / (exp2(((_750 - _745) * 1.4426950216293335f) * _784) + 1.0f))), _756) - _810)) * (3.0f - (_830 * 2.0f))) + _810;
  float _852 = (((_831 * _831) * (select((_751 > _745), (_720 - (_782 / (exp2(((_751 - _745) * 1.4426950216293335f) * _784) + 1.0f))), _757) - _811)) * (3.0f - (_831 * 2.0f))) + _811;
  float _853 = dot(float3(_850, _851, _852), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _873 = (cb0_036w * (max(0.0f, (lerp(_853, _850, 0.9300000071525574f))) - _569)) + _569;
  float _874 = (cb0_036w * (max(0.0f, (lerp(_853, _851, 0.9300000071525574f))) - _570)) + _570;
  float _875 = (cb0_036w * (max(0.0f, (lerp(_853, _852, 0.9300000071525574f))) - _571)) + _571;
  float _891 = ((mad(-0.06537103652954102f, _875, mad(1.451815478503704e-06f, _874, (_873 * 1.065374732017517f))) - _873) * cb0_036y) + _873;
  float _892 = ((mad(-0.20366770029067993f, _875, mad(1.2036634683609009f, _874, (_873 * -2.57161445915699e-07f))) - _874) * cb0_036y) + _874;
  float _893 = ((mad(0.9999996423721313f, _875, mad(2.0954757928848267e-08f, _874, (_873 * 1.862645149230957e-08f))) - _875) * cb0_036y) + _875;

  SetTonemappedAP1(_891, _892, _893);

  float _903 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _893, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _892, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _891))));
  float _904 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _893, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _892, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _891))));
  float _905 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _893, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _892, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _891))));
  float _931 = cb0_014x * (((cb0_039y + (cb0_039x * _903)) * _903) + cb0_039z);
  float _932 = cb0_014y * (((cb0_039y + (cb0_039x * _904)) * _904) + cb0_039z);
  float _933 = cb0_014z * (((cb0_039y + (cb0_039x * _905)) * _905) + cb0_039z);
  float _940 = ((cb0_013x - _931) * cb0_013w) + _931;
  float _941 = ((cb0_013y - _932) * cb0_013w) + _932;
  float _942 = ((cb0_013z - _933) * cb0_013w) + _933;
  float _943 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _533, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _531, (_529 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _944 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _533, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _531, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _529)));
  float _945 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _533, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _531, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _529)));
  float _952 = ((cb0_013x - _943) * cb0_013w) + _943;
  float _953 = ((cb0_013y - _944) * cb0_013w) + _944;
  float _954 = ((cb0_013z - _945) * cb0_013w) + _945;
  float _966 = exp2(log2(max(0.0f, _940)) * cb0_040y);
  float _967 = exp2(log2(max(0.0f, _941)) * cb0_040y);
  float _968 = exp2(log2(max(0.0f, _942)) * cb0_040y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_966, _967, _968));
  }

  [branch]
  if ((uint)(cb0_040w) == 0) {
    do {
      if ((uint)(UniformBufferConstants_WorkingColorSpace_320) == 0) {
        float _991 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _966)));
        float _994 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _966)));
        float _997 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _966)));
        _1008 = mad(_39, _997, mad(_38, _994, (_991 * _37)));
        _1009 = mad(_42, _997, mad(_41, _994, (_991 * _40)));
        _1010 = mad(_45, _997, mad(_44, _994, (_991 * _43)));
      } else {
        _1008 = _966;
        _1009 = _967;
        _1010 = _968;
      }
      do {
        if (_1008 < 0.0031306699384003878f) {
          _1021 = (_1008 * 12.920000076293945f);
        } else {
          _1021 = (((pow(_1008, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1009 < 0.0031306699384003878f) {
            _1032 = (_1009 * 12.920000076293945f);
          } else {
            _1032 = (((pow(_1009, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1010 < 0.0031306699384003878f) {
            _2392 = _1021;
            _2393 = _1032;
            _2394 = (_1010 * 12.920000076293945f);
          } else {
            _2392 = _1021;
            _2393 = _1032;
            _2394 = (((pow(_1010, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(cb0_040w) == 1) {
      float _1059 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _966)));
      float _1062 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _966)));
      float _1065 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _966)));
      float _1075 = max(6.103519990574569e-05f, mad(_39, _1065, mad(_38, _1062, (_1059 * _37))));
      float _1076 = max(6.103519990574569e-05f, mad(_42, _1065, mad(_41, _1062, (_1059 * _40))));
      float _1077 = max(6.103519990574569e-05f, mad(_45, _1065, mad(_44, _1062, (_1059 * _43))));
      _2392 = min((_1075 * 4.5f), ((exp2(log2(max(_1075, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2393 = min((_1076 * 4.5f), ((exp2(log2(max(_1076, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2394 = min((_1077 * 4.5f), ((exp2(log2(max(_1077, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(cb0_040w) == 3) || (bool)((uint)(cb0_040w) == 5)) {
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
        float _1154 = cb0_012z * _952;
        float _1155 = cb0_012z * _953;
        float _1156 = cb0_012z * _954;
        float _1159 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1156, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1155, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1154)));
        float _1162 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1156, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1155, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1154)));
        float _1165 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1156, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1155, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1154)));
        float _1169 = max(max(_1159, _1162), _1165);
        float _1174 = (max(_1169, 1.000000013351432e-10f) - max(min(min(_1159, _1162), _1165), 1.000000013351432e-10f)) / max(_1169, 0.009999999776482582f);
        float _1187 = ((_1162 + _1159) + _1165) + (sqrt((((_1165 - _1162) * _1165) + ((_1162 - _1159) * _1162)) + ((_1159 - _1165) * _1159)) * 1.75f);
        float _1188 = _1187 * 0.3333333432674408f;
        float _1189 = _1174 + -0.4000000059604645f;
        float _1190 = _1189 * 5.0f;
        float _1194 = max((1.0f - abs(_1189 * 2.5f)), 0.0f);
        float _1205 = ((float(((int)(uint)((bool)(_1190 > 0.0f))) - ((int)(uint)((bool)(_1190 < 0.0f)))) * (1.0f - (_1194 * _1194))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1188 <= 0.0533333346247673f)) {
            if (!(_1188 >= 0.1599999964237213f)) {
              _1214 = (((0.23999999463558197f / _1187) + -0.5f) * _1205);
            } else {
              _1214 = 0.0f;
            }
          } else {
            _1214 = _1205;
          }
          float _1215 = _1214 + 1.0f;
          float _1216 = _1215 * _1159;
          float _1217 = _1215 * _1162;
          float _1218 = _1215 * _1165;
          do {
            if (!((bool)(_1216 == _1217) && (bool)(_1217 == _1218))) {
              float _1225 = ((_1216 * 2.0f) - _1217) - _1218;
              float _1228 = ((_1162 - _1165) * 1.7320507764816284f) * _1215;
              float _1230 = atan(_1228 / _1225);
              bool _1233 = (_1225 < 0.0f);
              bool _1234 = (_1225 == 0.0f);
              bool _1235 = (_1228 >= 0.0f);
              bool _1236 = (_1228 < 0.0f);
              float _1245 = select((_1235 && _1234), 90.0f, select((_1236 && _1234), -90.0f, (select((_1236 && _1233), (_1230 + -3.1415927410125732f), select((_1235 && _1233), (_1230 + 3.1415927410125732f), _1230)) * 57.2957763671875f)));
              if (_1245 < 0.0f) {
                _1250 = (_1245 + 360.0f);
              } else {
                _1250 = _1245;
              }
            } else {
              _1250 = 0.0f;
            }
            float _1252 = min(max(_1250, 0.0f), 360.0f);
            do {
              if (_1252 < -180.0f) {
                _1261 = (_1252 + 360.0f);
              } else {
                if (_1252 > 180.0f) {
                  _1261 = (_1252 + -360.0f);
                } else {
                  _1261 = _1252;
                }
              }
              do {
                if ((bool)(_1261 > -67.5f) && (bool)(_1261 < 67.5f)) {
                  float _1267 = (_1261 + 67.5f) * 0.029629629105329514f;
                  int _1268 = int(_1267);
                  float _1270 = _1267 - float(_1268);
                  float _1271 = _1270 * _1270;
                  float _1272 = _1271 * _1270;
                  if (_1268 == 3) {
                    _1300 = (((0.1666666716337204f - (_1270 * 0.5f)) + (_1271 * 0.5f)) - (_1272 * 0.1666666716337204f));
                  } else {
                    if (_1268 == 2) {
                      _1300 = ((0.6666666865348816f - _1271) + (_1272 * 0.5f));
                    } else {
                      if (_1268 == 1) {
                        _1300 = (((_1272 * -0.5f) + 0.1666666716337204f) + ((_1271 + _1270) * 0.5f));
                      } else {
                        _1300 = select((_1268 == 0), (_1272 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1300 = 0.0f;
                }
                float _1309 = min(max(((((_1174 * 0.27000001072883606f) * (0.029999999329447746f - _1216)) * _1300) + _1216), 0.0f), 65535.0f);
                float _1310 = min(max(_1217, 0.0f), 65535.0f);
                float _1311 = min(max(_1218, 0.0f), 65535.0f);
                float _1324 = min(max(mad(-0.21492856740951538f, _1311, mad(-0.2365107536315918f, _1310, (_1309 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1325 = min(max(mad(-0.09967592358589172f, _1311, mad(1.17622971534729f, _1310, (_1309 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1326 = min(max(mad(0.9977163076400757f, _1311, mad(-0.006032449658960104f, _1310, (_1309 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1327 = dot(float3(_1324, _1325, _1326), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1338 = log2(max((lerp(_1327, _1324, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1339 = _1338 * 0.3010300099849701f;
                float _1340 = log2(cb0_008x);
                float _1341 = _1340 * 0.3010300099849701f;
                do {
                  if (!(!(_1339 <= _1341))) {
                    _1410 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1348 = log2(cb0_009x);
                    float _1349 = _1348 * 0.3010300099849701f;
                    if ((bool)(_1339 > _1341) && (bool)(_1339 < _1349)) {
                      float _1357 = ((_1338 - _1340) * 0.9030900001525879f) / ((_1348 - _1340) * 0.3010300099849701f);
                      int _1358 = int(_1357);
                      float _1360 = _1357 - float(_1358);
                      float _1362 = _10[_1358];
                      float _1365 = _10[(_1358 + 1)];
                      float _1370 = _1362 * 0.5f;
                      _1410 = dot(float3((_1360 * _1360), _1360, 1.0f), float3(mad((_10[(_1358 + 2)]), 0.5f, mad(_1365, -1.0f, _1370)), (_1365 - _1362), mad(_1365, 0.5f, _1370)));
                    } else {
                      do {
                        if (!(!(_1339 >= _1349))) {
                          float _1379 = log2(cb0_008z);
                          if (_1339 < (_1379 * 0.3010300099849701f)) {
                            float _1387 = ((_1338 - _1348) * 0.9030900001525879f) / ((_1379 - _1348) * 0.3010300099849701f);
                            int _1388 = int(_1387);
                            float _1390 = _1387 - float(_1388);
                            float _1392 = _11[_1388];
                            float _1395 = _11[(_1388 + 1)];
                            float _1400 = _1392 * 0.5f;
                            _1410 = dot(float3((_1390 * _1390), _1390, 1.0f), float3(mad((_11[(_1388 + 2)]), 0.5f, mad(_1395, -1.0f, _1400)), (_1395 - _1392), mad(_1395, 0.5f, _1400)));
                            break;
                          }
                        }
                        _1410 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1414 = log2(max((lerp(_1327, _1325, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1415 = _1414 * 0.3010300099849701f;
                  do {
                    if (!(!(_1415 <= _1341))) {
                      _1484 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1422 = log2(cb0_009x);
                      float _1423 = _1422 * 0.3010300099849701f;
                      if ((bool)(_1415 > _1341) && (bool)(_1415 < _1423)) {
                        float _1431 = ((_1414 - _1340) * 0.9030900001525879f) / ((_1422 - _1340) * 0.3010300099849701f);
                        int _1432 = int(_1431);
                        float _1434 = _1431 - float(_1432);
                        float _1436 = _10[_1432];
                        float _1439 = _10[(_1432 + 1)];
                        float _1444 = _1436 * 0.5f;
                        _1484 = dot(float3((_1434 * _1434), _1434, 1.0f), float3(mad((_10[(_1432 + 2)]), 0.5f, mad(_1439, -1.0f, _1444)), (_1439 - _1436), mad(_1439, 0.5f, _1444)));
                      } else {
                        do {
                          if (!(!(_1415 >= _1423))) {
                            float _1453 = log2(cb0_008z);
                            if (_1415 < (_1453 * 0.3010300099849701f)) {
                              float _1461 = ((_1414 - _1422) * 0.9030900001525879f) / ((_1453 - _1422) * 0.3010300099849701f);
                              int _1462 = int(_1461);
                              float _1464 = _1461 - float(_1462);
                              float _1466 = _11[_1462];
                              float _1469 = _11[(_1462 + 1)];
                              float _1474 = _1466 * 0.5f;
                              _1484 = dot(float3((_1464 * _1464), _1464, 1.0f), float3(mad((_11[(_1462 + 2)]), 0.5f, mad(_1469, -1.0f, _1474)), (_1469 - _1466), mad(_1469, 0.5f, _1474)));
                              break;
                            }
                          }
                          _1484 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1488 = log2(max((lerp(_1327, _1326, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1489 = _1488 * 0.3010300099849701f;
                    do {
                      if (!(!(_1489 <= _1341))) {
                        _1558 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1496 = log2(cb0_009x);
                        float _1497 = _1496 * 0.3010300099849701f;
                        if ((bool)(_1489 > _1341) && (bool)(_1489 < _1497)) {
                          float _1505 = ((_1488 - _1340) * 0.9030900001525879f) / ((_1496 - _1340) * 0.3010300099849701f);
                          int _1506 = int(_1505);
                          float _1508 = _1505 - float(_1506);
                          float _1510 = _10[_1506];
                          float _1513 = _10[(_1506 + 1)];
                          float _1518 = _1510 * 0.5f;
                          _1558 = dot(float3((_1508 * _1508), _1508, 1.0f), float3(mad((_10[(_1506 + 2)]), 0.5f, mad(_1513, -1.0f, _1518)), (_1513 - _1510), mad(_1513, 0.5f, _1518)));
                        } else {
                          do {
                            if (!(!(_1489 >= _1497))) {
                              float _1527 = log2(cb0_008z);
                              if (_1489 < (_1527 * 0.3010300099849701f)) {
                                float _1535 = ((_1488 - _1496) * 0.9030900001525879f) / ((_1527 - _1496) * 0.3010300099849701f);
                                int _1536 = int(_1535);
                                float _1538 = _1535 - float(_1536);
                                float _1540 = _11[_1536];
                                float _1543 = _11[(_1536 + 1)];
                                float _1548 = _1540 * 0.5f;
                                _1558 = dot(float3((_1538 * _1538), _1538, 1.0f), float3(mad((_11[(_1536 + 2)]), 0.5f, mad(_1543, -1.0f, _1548)), (_1543 - _1540), mad(_1543, 0.5f, _1548)));
                                break;
                              }
                            }
                            _1558 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1562 = cb0_008w - cb0_008y;
                      float _1563 = (exp2(_1410 * 3.321928024291992f) - cb0_008y) / _1562;
                      float _1565 = (exp2(_1484 * 3.321928024291992f) - cb0_008y) / _1562;
                      float _1567 = (exp2(_1558 * 3.321928024291992f) - cb0_008y) / _1562;
                      float _1570 = mad(0.15618768334388733f, _1567, mad(0.13400420546531677f, _1565, (_1563 * 0.6624541878700256f)));
                      float _1573 = mad(0.053689517080783844f, _1567, mad(0.6740817427635193f, _1565, (_1563 * 0.2722287178039551f)));
                      float _1576 = mad(1.0103391408920288f, _1567, mad(0.00406073359772563f, _1565, (_1563 * -0.005574649665504694f)));
                      float _1589 = min(max(mad(-0.23642469942569733f, _1576, mad(-0.32480329275131226f, _1573, (_1570 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1590 = min(max(mad(0.016756348311901093f, _1576, mad(1.6153316497802734f, _1573, (_1570 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1591 = min(max(mad(0.9883948564529419f, _1576, mad(-0.008284442126750946f, _1573, (_1570 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1594 = mad(0.15618768334388733f, _1591, mad(0.13400420546531677f, _1590, (_1589 * 0.6624541878700256f)));
                      float _1597 = mad(0.053689517080783844f, _1591, mad(0.6740817427635193f, _1590, (_1589 * 0.2722287178039551f)));
                      float _1600 = mad(1.0103391408920288f, _1591, mad(0.00406073359772563f, _1590, (_1589 * -0.005574649665504694f)));
                      float _1622 = min(max((min(max(mad(-0.23642469942569733f, _1600, mad(-0.32480329275131226f, _1597, (_1594 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1623 = min(max((min(max(mad(0.016756348311901093f, _1600, mad(1.6153316497802734f, _1597, (_1594 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1624 = min(max((min(max(mad(0.9883948564529419f, _1600, mad(-0.008284442126750946f, _1597, (_1594 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(cb0_040w) == 5)) {
                          _1637 = mad(_39, _1624, mad(_38, _1623, (_1622 * _37)));
                          _1638 = mad(_42, _1624, mad(_41, _1623, (_1622 * _40)));
                          _1639 = mad(_45, _1624, mad(_44, _1623, (_1622 * _43)));
                        } else {
                          _1637 = _1622;
                          _1638 = _1623;
                          _1639 = _1624;
                        }
                        float _1649 = exp2(log2(_1637 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1650 = exp2(log2(_1638 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1651 = exp2(log2(_1639 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2392 = exp2(log2((1.0f / ((_1649 * 18.6875f) + 1.0f)) * ((_1649 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2393 = exp2(log2((1.0f / ((_1650 * 18.6875f) + 1.0f)) * ((_1650 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2394 = exp2(log2((1.0f / ((_1651 * 18.6875f) + 1.0f)) * ((_1651 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if (((uint)(cb0_040w) & -3) == 4) {
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
          float _1730 = cb0_012z * _952;
          float _1731 = cb0_012z * _953;
          float _1732 = cb0_012z * _954;
          float _1735 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1732, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1731, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1730)));
          float _1738 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1732, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1731, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1730)));
          float _1741 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1732, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1731, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1730)));
          float _1745 = max(max(_1735, _1738), _1741);
          float _1750 = (max(_1745, 1.000000013351432e-10f) - max(min(min(_1735, _1738), _1741), 1.000000013351432e-10f)) / max(_1745, 0.009999999776482582f);
          float _1763 = ((_1738 + _1735) + _1741) + (sqrt((((_1741 - _1738) * _1741) + ((_1738 - _1735) * _1738)) + ((_1735 - _1741) * _1735)) * 1.75f);
          float _1764 = _1763 * 0.3333333432674408f;
          float _1765 = _1750 + -0.4000000059604645f;
          float _1766 = _1765 * 5.0f;
          float _1770 = max((1.0f - abs(_1765 * 2.5f)), 0.0f);
          float _1781 = ((float(((int)(uint)((bool)(_1766 > 0.0f))) - ((int)(uint)((bool)(_1766 < 0.0f)))) * (1.0f - (_1770 * _1770))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1764 <= 0.0533333346247673f)) {
              if (!(_1764 >= 0.1599999964237213f)) {
                _1790 = (((0.23999999463558197f / _1763) + -0.5f) * _1781);
              } else {
                _1790 = 0.0f;
              }
            } else {
              _1790 = _1781;
            }
            float _1791 = _1790 + 1.0f;
            float _1792 = _1791 * _1735;
            float _1793 = _1791 * _1738;
            float _1794 = _1791 * _1741;
            do {
              if (!((bool)(_1792 == _1793) && (bool)(_1793 == _1794))) {
                float _1801 = ((_1792 * 2.0f) - _1793) - _1794;
                float _1804 = ((_1738 - _1741) * 1.7320507764816284f) * _1791;
                float _1806 = atan(_1804 / _1801);
                bool _1809 = (_1801 < 0.0f);
                bool _1810 = (_1801 == 0.0f);
                bool _1811 = (_1804 >= 0.0f);
                bool _1812 = (_1804 < 0.0f);
                float _1821 = select((_1811 && _1810), 90.0f, select((_1812 && _1810), -90.0f, (select((_1812 && _1809), (_1806 + -3.1415927410125732f), select((_1811 && _1809), (_1806 + 3.1415927410125732f), _1806)) * 57.2957763671875f)));
                if (_1821 < 0.0f) {
                  _1826 = (_1821 + 360.0f);
                } else {
                  _1826 = _1821;
                }
              } else {
                _1826 = 0.0f;
              }
              float _1828 = min(max(_1826, 0.0f), 360.0f);
              do {
                if (_1828 < -180.0f) {
                  _1837 = (_1828 + 360.0f);
                } else {
                  if (_1828 > 180.0f) {
                    _1837 = (_1828 + -360.0f);
                  } else {
                    _1837 = _1828;
                  }
                }
                do {
                  if ((bool)(_1837 > -67.5f) && (bool)(_1837 < 67.5f)) {
                    float _1843 = (_1837 + 67.5f) * 0.029629629105329514f;
                    int _1844 = int(_1843);
                    float _1846 = _1843 - float(_1844);
                    float _1847 = _1846 * _1846;
                    float _1848 = _1847 * _1846;
                    if (_1844 == 3) {
                      _1876 = (((0.1666666716337204f - (_1846 * 0.5f)) + (_1847 * 0.5f)) - (_1848 * 0.1666666716337204f));
                    } else {
                      if (_1844 == 2) {
                        _1876 = ((0.6666666865348816f - _1847) + (_1848 * 0.5f));
                      } else {
                        if (_1844 == 1) {
                          _1876 = (((_1848 * -0.5f) + 0.1666666716337204f) + ((_1847 + _1846) * 0.5f));
                        } else {
                          _1876 = select((_1844 == 0), (_1848 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1876 = 0.0f;
                  }
                  float _1885 = min(max(((((_1750 * 0.27000001072883606f) * (0.029999999329447746f - _1792)) * _1876) + _1792), 0.0f), 65535.0f);
                  float _1886 = min(max(_1793, 0.0f), 65535.0f);
                  float _1887 = min(max(_1794, 0.0f), 65535.0f);
                  float _1900 = min(max(mad(-0.21492856740951538f, _1887, mad(-0.2365107536315918f, _1886, (_1885 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1901 = min(max(mad(-0.09967592358589172f, _1887, mad(1.17622971534729f, _1886, (_1885 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1902 = min(max(mad(0.9977163076400757f, _1887, mad(-0.006032449658960104f, _1886, (_1885 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1903 = dot(float3(_1900, _1901, _1902), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1914 = log2(max((lerp(_1903, _1900, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1915 = _1914 * 0.3010300099849701f;
                  float _1916 = log2(cb0_008x);
                  float _1917 = _1916 * 0.3010300099849701f;
                  do {
                    if (!(!(_1915 <= _1917))) {
                      _1986 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1924 = log2(cb0_009x);
                      float _1925 = _1924 * 0.3010300099849701f;
                      if ((bool)(_1915 > _1917) && (bool)(_1915 < _1925)) {
                        float _1933 = ((_1914 - _1916) * 0.9030900001525879f) / ((_1924 - _1916) * 0.3010300099849701f);
                        int _1934 = int(_1933);
                        float _1936 = _1933 - float(_1934);
                        float _1938 = _8[_1934];
                        float _1941 = _8[(_1934 + 1)];
                        float _1946 = _1938 * 0.5f;
                        _1986 = dot(float3((_1936 * _1936), _1936, 1.0f), float3(mad((_8[(_1934 + 2)]), 0.5f, mad(_1941, -1.0f, _1946)), (_1941 - _1938), mad(_1941, 0.5f, _1946)));
                      } else {
                        do {
                          if (!(!(_1915 >= _1925))) {
                            float _1955 = log2(cb0_008z);
                            if (_1915 < (_1955 * 0.3010300099849701f)) {
                              float _1963 = ((_1914 - _1924) * 0.9030900001525879f) / ((_1955 - _1924) * 0.3010300099849701f);
                              int _1964 = int(_1963);
                              float _1966 = _1963 - float(_1964);
                              float _1968 = _9[_1964];
                              float _1971 = _9[(_1964 + 1)];
                              float _1976 = _1968 * 0.5f;
                              _1986 = dot(float3((_1966 * _1966), _1966, 1.0f), float3(mad((_9[(_1964 + 2)]), 0.5f, mad(_1971, -1.0f, _1976)), (_1971 - _1968), mad(_1971, 0.5f, _1976)));
                              break;
                            }
                          }
                          _1986 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1990 = log2(max((lerp(_1903, _1901, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1991 = _1990 * 0.3010300099849701f;
                    do {
                      if (!(!(_1991 <= _1917))) {
                        _2060 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1998 = log2(cb0_009x);
                        float _1999 = _1998 * 0.3010300099849701f;
                        if ((bool)(_1991 > _1917) && (bool)(_1991 < _1999)) {
                          float _2007 = ((_1990 - _1916) * 0.9030900001525879f) / ((_1998 - _1916) * 0.3010300099849701f);
                          int _2008 = int(_2007);
                          float _2010 = _2007 - float(_2008);
                          float _2012 = _8[_2008];
                          float _2015 = _8[(_2008 + 1)];
                          float _2020 = _2012 * 0.5f;
                          _2060 = dot(float3((_2010 * _2010), _2010, 1.0f), float3(mad((_8[(_2008 + 2)]), 0.5f, mad(_2015, -1.0f, _2020)), (_2015 - _2012), mad(_2015, 0.5f, _2020)));
                        } else {
                          do {
                            if (!(!(_1991 >= _1999))) {
                              float _2029 = log2(cb0_008z);
                              if (_1991 < (_2029 * 0.3010300099849701f)) {
                                float _2037 = ((_1990 - _1998) * 0.9030900001525879f) / ((_2029 - _1998) * 0.3010300099849701f);
                                int _2038 = int(_2037);
                                float _2040 = _2037 - float(_2038);
                                float _2042 = _9[_2038];
                                float _2045 = _9[(_2038 + 1)];
                                float _2050 = _2042 * 0.5f;
                                _2060 = dot(float3((_2040 * _2040), _2040, 1.0f), float3(mad((_9[(_2038 + 2)]), 0.5f, mad(_2045, -1.0f, _2050)), (_2045 - _2042), mad(_2045, 0.5f, _2050)));
                                break;
                              }
                            }
                            _2060 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2064 = log2(max((lerp(_1903, _1902, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2065 = _2064 * 0.3010300099849701f;
                      do {
                        if (!(!(_2065 <= _1917))) {
                          _2134 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2072 = log2(cb0_009x);
                          float _2073 = _2072 * 0.3010300099849701f;
                          if ((bool)(_2065 > _1917) && (bool)(_2065 < _2073)) {
                            float _2081 = ((_2064 - _1916) * 0.9030900001525879f) / ((_2072 - _1916) * 0.3010300099849701f);
                            int _2082 = int(_2081);
                            float _2084 = _2081 - float(_2082);
                            float _2086 = _8[_2082];
                            float _2089 = _8[(_2082 + 1)];
                            float _2094 = _2086 * 0.5f;
                            _2134 = dot(float3((_2084 * _2084), _2084, 1.0f), float3(mad((_8[(_2082 + 2)]), 0.5f, mad(_2089, -1.0f, _2094)), (_2089 - _2086), mad(_2089, 0.5f, _2094)));
                          } else {
                            do {
                              if (!(!(_2065 >= _2073))) {
                                float _2103 = log2(cb0_008z);
                                if (_2065 < (_2103 * 0.3010300099849701f)) {
                                  float _2111 = ((_2064 - _2072) * 0.9030900001525879f) / ((_2103 - _2072) * 0.3010300099849701f);
                                  int _2112 = int(_2111);
                                  float _2114 = _2111 - float(_2112);
                                  float _2116 = _9[_2112];
                                  float _2119 = _9[(_2112 + 1)];
                                  float _2124 = _2116 * 0.5f;
                                  _2134 = dot(float3((_2114 * _2114), _2114, 1.0f), float3(mad((_9[(_2112 + 2)]), 0.5f, mad(_2119, -1.0f, _2124)), (_2119 - _2116), mad(_2119, 0.5f, _2124)));
                                  break;
                                }
                              }
                              _2134 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2138 = cb0_008w - cb0_008y;
                        float _2139 = (exp2(_1986 * 3.321928024291992f) - cb0_008y) / _2138;
                        float _2141 = (exp2(_2060 * 3.321928024291992f) - cb0_008y) / _2138;
                        float _2143 = (exp2(_2134 * 3.321928024291992f) - cb0_008y) / _2138;
                        float _2146 = mad(0.15618768334388733f, _2143, mad(0.13400420546531677f, _2141, (_2139 * 0.6624541878700256f)));
                        float _2149 = mad(0.053689517080783844f, _2143, mad(0.6740817427635193f, _2141, (_2139 * 0.2722287178039551f)));
                        float _2152 = mad(1.0103391408920288f, _2143, mad(0.00406073359772563f, _2141, (_2139 * -0.005574649665504694f)));
                        float _2165 = min(max(mad(-0.23642469942569733f, _2152, mad(-0.32480329275131226f, _2149, (_2146 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2166 = min(max(mad(0.016756348311901093f, _2152, mad(1.6153316497802734f, _2149, (_2146 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2167 = min(max(mad(0.9883948564529419f, _2152, mad(-0.008284442126750946f, _2149, (_2146 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2170 = mad(0.15618768334388733f, _2167, mad(0.13400420546531677f, _2166, (_2165 * 0.6624541878700256f)));
                        float _2173 = mad(0.053689517080783844f, _2167, mad(0.6740817427635193f, _2166, (_2165 * 0.2722287178039551f)));
                        float _2176 = mad(1.0103391408920288f, _2167, mad(0.00406073359772563f, _2166, (_2165 * -0.005574649665504694f)));
                        float _2198 = min(max((min(max(mad(-0.23642469942569733f, _2176, mad(-0.32480329275131226f, _2173, (_2170 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2199 = min(max((min(max(mad(0.016756348311901093f, _2176, mad(1.6153316497802734f, _2173, (_2170 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2200 = min(max((min(max(mad(0.9883948564529419f, _2176, mad(-0.008284442126750946f, _2173, (_2170 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(cb0_040w) == 6)) {
                            _2213 = mad(_39, _2200, mad(_38, _2199, (_2198 * _37)));
                            _2214 = mad(_42, _2200, mad(_41, _2199, (_2198 * _40)));
                            _2215 = mad(_45, _2200, mad(_44, _2199, (_2198 * _43)));
                          } else {
                            _2213 = _2198;
                            _2214 = _2199;
                            _2215 = _2200;
                          }
                          float _2225 = exp2(log2(_2213 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2226 = exp2(log2(_2214 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2227 = exp2(log2(_2215 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2392 = exp2(log2((1.0f / ((_2225 * 18.6875f) + 1.0f)) * ((_2225 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2393 = exp2(log2((1.0f / ((_2226 * 18.6875f) + 1.0f)) * ((_2226 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2394 = exp2(log2((1.0f / ((_2227 * 18.6875f) + 1.0f)) * ((_2227 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if ((uint)(cb0_040w) == 7) {
            float _2272 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _954, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _953, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _952)));
            float _2275 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _954, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _953, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _952)));
            float _2278 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _954, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _953, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _952)));
            float _2297 = exp2(log2(mad(_39, _2278, mad(_38, _2275, (_2272 * _37))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2298 = exp2(log2(mad(_42, _2278, mad(_41, _2275, (_2272 * _40))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2299 = exp2(log2(mad(_45, _2278, mad(_44, _2275, (_2272 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2392 = exp2(log2((1.0f / ((_2297 * 18.6875f) + 1.0f)) * ((_2297 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2393 = exp2(log2((1.0f / ((_2298 * 18.6875f) + 1.0f)) * ((_2298 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2394 = exp2(log2((1.0f / ((_2299 * 18.6875f) + 1.0f)) * ((_2299 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(cb0_040w) == 8)) {
              if ((uint)(cb0_040w) == 9) {
                float _2346 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _942, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _941, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _940)));
                float _2349 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _942, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _941, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _940)));
                float _2352 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _942, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _941, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _940)));
                _2392 = mad(_39, _2352, mad(_38, _2349, (_2346 * _37)));
                _2393 = mad(_42, _2352, mad(_41, _2349, (_2346 * _40)));
                _2394 = mad(_45, _2352, mad(_44, _2349, (_2346 * _43)));
              } else {
                float _2365 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _966)));
                float _2368 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _966)));
                float _2371 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _968, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _967, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _966)));
                _2392 = exp2(log2(mad(_39, _2371, mad(_38, _2368, (_2365 * _37)))) * cb0_040z);
                _2393 = exp2(log2(mad(_42, _2371, mad(_41, _2368, (_2365 * _40)))) * cb0_040z);
                _2394 = exp2(log2(mad(_45, _2371, mad(_44, _2368, (_2365 * _43)))) * cb0_040z);
              }
            } else {
              _2392 = _952;
              _2393 = _953;
              _2394 = _954;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2392 * 0.9523810148239136f);
  SV_Target.y = (_2393 * 0.9523810148239136f);
  SV_Target.z = (_2394 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
