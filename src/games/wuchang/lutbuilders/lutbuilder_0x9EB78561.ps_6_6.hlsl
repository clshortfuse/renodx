// Wuchang: Fallen Feathers

#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  uint output_gamut = cb0_041x;
  uint output_device = cb0_040w;
  float expand_gamut = cb0_036w;
  float4 SV_Target;
  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _16 = TEXCOORD.x + -0.015625f;
  float _17 = TEXCOORD.y + -0.015625f;
  float _20 = float((uint)(int)(SV_RenderTargetArrayIndex));
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _107;
  float _108;
  float _109;
  float _633;
  float _669;
  float _680;
  float _744;
  float _923;
  float _934;
  float _945;
  float _1147;
  float _1148;
  float _1149;
  float _1160;
  float _1171;
  float _1353;
  float _1389;
  float _1400;
  float _1439;
  float _1549;
  float _1623;
  float _1697;
  float _1776;
  float _1777;
  float _1778;
  float _1929;
  float _1965;
  float _1976;
  float _2015;
  float _2125;
  float _2199;
  float _2273;
  float _2352;
  float _2353;
  float _2354;
  float _2531;
  float _2532;
  float _2533;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _30 = (output_gamut == 4);
        _41 = select(_30, 1.0f, 1.7050515413284302f);
        _42 = select(_30, 0.0f, -0.6217905879020691f);
        _43 = select(_30, 0.0f, -0.0832584798336029f);
        _44 = select(_30, 0.0f, -0.13025718927383423f);
        _45 = select(_30, 1.0f, 1.1408027410507202f);
        _46 = select(_30, 0.0f, -0.010548528283834457f);
        _47 = select(_30, 0.0f, -0.024003278464078903f);
        _48 = select(_30, 0.0f, -0.1289687603712082f);
        _49 = select(_30, 1.0f, 1.152971863746643f);
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
      _41 = 1.02579927444458f;
      _42 = -0.020052503794431686f;
      _43 = -0.0057713985443115234f;
      _44 = -0.0022350111976265907f;
      _45 = 1.0045825242996216f;
      _46 = -0.002352306619286537f;
      _47 = -0.005014004185795784f;
      _48 = -0.025293385609984398f;
      _49 = 1.0304402112960815f;
    }
  } else {
    _41 = 1.379158854484558f;
    _42 = -0.3088507056236267f;
    _43 = -0.07034677267074585f;
    _44 = -0.06933528929948807f;
    _45 = 1.0822921991348267f;
    _46 = -0.012962047010660172f;
    _47 = -0.002159259282052517f;
    _48 = -0.045465391129255295f;
    _49 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _60 = exp2(log2(_16 * 1.0322580337524414f) * 0.012683313339948654f);
    float _61 = exp2(log2(_17 * 1.0322580337524414f) * 0.012683313339948654f);
    float _62 = exp2(log2(_20 * 0.032258063554763794f) * 0.012683313339948654f);
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _108 = (exp2(log2(max(0.0f, (_61 + -0.8359375f)) / (18.8515625f - (_61 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _109 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _107 = ((exp2((_16 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _108 = ((exp2((_17 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _109 = ((exp2((_20 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _124 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _109, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _108, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _107)));
  float _127 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _109, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _108, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _107)));
  float _130 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _109, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _108, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _107)));
  float _131 = dot(float3(_124, _127, _130), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _135 = (_124 / _131) + -1.0f;
  float _136 = (_127 / _131) + -1.0f;
  float _137 = (_130 / _131) + -1.0f;
  float _149 = (1.0f - exp2(((_131 * _131) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_135, _136, _137), float3(_135, _136, _137)) * -4.0f));
  float _165 = ((mad(-0.06368283927440643f, _130, mad(-0.32929131388664246f, _127, (_124 * 1.370412826538086f))) - _124) * _149) + _124;
  float _166 = ((mad(-0.010861567221581936f, _130, mad(1.0970908403396606f, _127, (_124 * -0.08343426138162613f))) - _127) * _149) + _127;
  float _167 = ((mad(1.203694462776184f, _130, mad(-0.09862564504146576f, _127, (_124 * -0.02579325996339321f))) - _130) * _149) + _130;
  float _168 = dot(float3(_165, _166, _167), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _182 = cb0_019w + cb0_024w;
  float _196 = cb0_018w * cb0_023w;
  float _210 = cb0_017w * cb0_022w;
  float _224 = cb0_016w * cb0_021w;
  float _238 = cb0_015w * cb0_020w;
  float _242 = _165 - _168;
  float _243 = _166 - _168;
  float _244 = _167 - _168;
  float _302 = saturate(_168 / cb0_035z);
  float _306 = (_302 * _302) * (3.0f - (_302 * 2.0f));
  float _307 = 1.0f - _306;
  float _316 = cb0_019w + cb0_034w;
  float _325 = cb0_018w * cb0_033w;
  float _334 = cb0_017w * cb0_032w;
  float _343 = cb0_016w * cb0_031w;
  float _352 = cb0_015w * cb0_030w;
  float _415 = saturate((_168 - cb0_035w) / (cb0_036x - cb0_035w));
  float _419 = (_415 * _415) * (3.0f - (_415 * 2.0f));
  float _428 = cb0_019w + cb0_029w;
  float _437 = cb0_018w * cb0_028w;
  float _446 = cb0_017w * cb0_027w;
  float _455 = cb0_016w * cb0_026w;
  float _464 = cb0_015w * cb0_025w;
  float _522 = _306 - _419;

  float3 coloroffset1 = float3(_419, _307, _522)
                        * (((cb0_019x + float3(cb0_034x, cb0_024x, cb0_029x)) + float3(_316, _182, _428)) + (((cb0_018x * float3(cb0_033x, cb0_023x, cb0_028x)) * float3(_325, _196, _437)) * SignPow(SignPow(max(0.0f, ((((cb0_015x * float3(cb0_030x, cb0_020x, cb0_025x)) * float3(_352, _238, _464)) * _242) + _168)) * 5.55555534362793f, ((cb0_016x * float3(cb0_031x, cb0_021x, cb0_026x)) * float3(_343, _224, _455))) * 0.18000000715255737f, (1.0f / ((cb0_017x * float3(cb0_032x, cb0_022x, cb0_027x)) * float3(_334, _210, _446))))));
  float _533 = coloroffset1.r + coloroffset1.g + coloroffset1.b;

  float3 coloroffset2 = float3(_419, _307, _522)
                        * (((cb0_019y + float3(cb0_034y, cb0_024y, cb0_029y)) + float3(_316, _182, _428)) + (((cb0_018y * float3(cb0_033y, cb0_023y, cb0_028y)) * float3(_325, _196, _437)) * SignPow(SignPow(max(0.0f, ((((cb0_015y * float3(cb0_030y, cb0_020y, cb0_025y)) * float3(_352, _238, _464)) * _243) + _168)) * 5.55555534362793f, ((cb0_016y * float3(cb0_031y, cb0_021y, cb0_026y)) * float3(_343, _224, _455))) * 0.18000000715255737f, (1.0f / ((cb0_017y * float3(cb0_032y, cb0_022y, cb0_027y)) * float3(_334, _210, _446))))));
  float _535 = coloroffset2.r + coloroffset2.g + coloroffset2.b;

  float3 coloroffset3 = float3(_419, _307, _522)
                        * (((cb0_019z + float3(cb0_034z, cb0_024z, cb0_029z)) + float3(_316, _182, _428)) + (((cb0_018z * float3(cb0_033z, cb0_023z, cb0_028z)) * float3(_325, _196, _437)) * SignPow(SignPow(max(0.0f, ((((cb0_015z * float3(cb0_030z, cb0_020z, cb0_025z)) * float3(_352, _238, _464)) * _244) + _168)) * 5.55555534362793f, ((cb0_016z * float3(cb0_031z, cb0_021z, cb0_026z)) * float3(_343, _224, _455))) * 0.18000000715255737f, (1.0f / ((cb0_017z * float3(cb0_032z, cb0_022z, cb0_027z)) * float3(_334, _210, _446))))));
  float _537 = coloroffset3.r + coloroffset3.g + coloroffset3.b;

  /*   float _533 = ((_419 * (((cb0_019x + cb0_034x) + _316) + (((cb0_018x * cb0_033x) * _325) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _343) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _352) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _334)))))) + (_307 * (((cb0_019x + cb0_024x) + _182) + (((cb0_018x * cb0_023x) * _196) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _224) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _238) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _210))))))) + ((((cb0_019x + cb0_029x) + _428) + (((cb0_018x * cb0_028x) * _437) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _455) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _464) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _446))))) * _522);
    float _535 = ((_419 * (((cb0_019y + cb0_034y) + _316) + (((cb0_018y * cb0_033y) * _325) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _343) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _352) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _334)))))) + (_307 * (((cb0_019y + cb0_024y) + _182) + (((cb0_018y * cb0_023y) * _196) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _224) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _238) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _210))))))) + ((((cb0_019y + cb0_029y) + _428) + (((cb0_018y * cb0_028y) * _437) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _455) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _464) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _446))))) * _522);
    float _537 = ((_419 * (((cb0_019z + cb0_034z) + _316) + (((cb0_018z * cb0_033z) * _325) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _343) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _352) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _334)))))) + (_307 * (((cb0_019z + cb0_024z) + _182) + (((cb0_018z * cb0_023z) * _196) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _224) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _238) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _210))))))) + ((((cb0_019z + cb0_029z) + _428) + (((cb0_018z * cb0_028z) * _437) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _455) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _464) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _446))))) * _522);
   */
  float _573 = ((mad(0.061360642313957214f, _537, mad(-4.540197551250458e-09f, _535, (_533 * 0.9386394023895264f))) - _533) * cb0_036y) + _533;
  float _574 = ((mad(0.169205904006958f, _537, mad(0.8307942152023315f, _535, (_533 * 6.775371730327606e-08f))) - _535) * cb0_036y) + _535;
  float _575 = (mad(-2.3283064365386963e-10f, _535, (_533 * -9.313225746154785e-10f)) * cb0_036y) + _537;
  float _578 = mad(0.16386905312538147f, _575, mad(0.14067868888378143f, _574, (_573 * 0.6954522132873535f)));
  float _581 = mad(0.0955343246459961f, _575, mad(0.8596711158752441f, _574, (_573 * 0.044794581830501556f)));
  float _584 = mad(1.0015007257461548f, _575, mad(0.004025210160762072f, _574, (_573 * -0.005525882821530104f)));
  float _588 = max(max(_578, _581), _584);
  float _593 = (max(_588, 1.000000013351432e-10f) - max(min(min(_578, _581), _584), 1.000000013351432e-10f)) / max(_588, 0.009999999776482582f);
  float _606 = ((_581 + _578) + _584) + (sqrt((((_584 - _581) * _584) + ((_581 - _578) * _581)) + ((_578 - _584) * _578)) * 1.75f);
  float _607 = _606 * 0.3333333432674408f;
  float _608 = _593 + -0.4000000059604645f;
  float _609 = _608 * 5.0f;
  float _613 = max((1.0f - abs(_608 * 2.5f)), 0.0f);
  float _624 = ((float(((int)(uint)((bool)(_609 > 0.0f))) - ((int)(uint)((bool)(_609 < 0.0f)))) * (1.0f - (_613 * _613))) + 1.0f) * 0.02500000037252903f;
  if (!(_607 <= 0.0533333346247673f)) {
    if (!(_607 >= 0.1599999964237213f)) {
      _633 = (((0.23999999463558197f / _606) + -0.5f) * _624);
    } else {
      _633 = 0.0f;
    }
  } else {
    _633 = _624;
  }
  float _634 = _633 + 1.0f;
  float _635 = _634 * _578;
  float _636 = _634 * _581;
  float _637 = _634 * _584;
  if (!((bool)(_635 == _636) && (bool)(_636 == _637))) {
    float _644 = ((_635 * 2.0f) - _636) - _637;
    float _647 = ((_581 - _584) * 1.7320507764816284f) * _634;
    float _649 = atan(_647 / _644);
    bool _652 = (_644 < 0.0f);
    bool _653 = (_644 == 0.0f);
    bool _654 = (_647 >= 0.0f);
    bool _655 = (_647 < 0.0f);
    float _664 = select((_654 && _653), 90.0f, select((_655 && _653), -90.0f, (select((_655 && _652), (_649 + -3.1415927410125732f), select((_654 && _652), (_649 + 3.1415927410125732f), _649)) * 57.2957763671875f)));
    if (_664 < 0.0f) {
      _669 = (_664 + 360.0f);
    } else {
      _669 = _664;
    }
  } else {
    _669 = 0.0f;
  }
  float _671 = min(max(_669, 0.0f), 360.0f);
  if (_671 < -180.0f) {
    _680 = (_671 + 360.0f);
  } else {
    if (_671 > 180.0f) {
      _680 = (_671 + -360.0f);
    } else {
      _680 = _671;
    }
  }
  float _684 = saturate(1.0f - abs(_680 * 0.014814814552664757f));
  float _688 = (_684 * _684) * (3.0f - (_684 * 2.0f));
  float _694 = ((_688 * _688) * ((_593 * 0.18000000715255737f) * (0.029999999329447746f - _635))) + _635;
  float _704 = max(0.0f, mad(-0.21492856740951538f, _637, mad(-0.2365107536315918f, _636, (_694 * 1.4514392614364624f))));
  float _705 = max(0.0f, mad(-0.09967592358589172f, _637, mad(1.17622971534729f, _636, (_694 * -0.07655377686023712f))));
  float _706 = max(0.0f, mad(0.9977163076400757f, _637, mad(-0.006032449658960104f, _636, (_694 * 0.008316148072481155f))));
  float _707 = dot(float3(_704, _705, _706), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _721 = (cb0_037w + 1.0f) - cb0_037y;
  float _724 = cb0_038x + 1.0f;
  float _726 = _724 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _744 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _735 = (cb0_037w + 0.18000000715255737f) / _721;
    _744 = (-0.7447274923324585f - ((log2(_735 / (2.0f - _735)) * 0.3465735912322998f) * (_721 / cb0_037x)));
  }
  float _747 = ((1.0f - cb0_037y) / cb0_037x) - _744;
  float _749 = (cb0_037z / cb0_037x) - _747;
  float3 lerpColor = lerp(_707, float3(_704, _705, _706), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _573, _574, _575);
  float _895 = lerpColor.r, _896 = lerpColor.g, _897 = lerpColor.b;
#else
  float _753 = log2(lerpColor.r) * 0.3010300099849701f;
  float _754 = log2(lerpColor.g) * 0.3010300099849701f;
  float _755 = log2(lerpColor.b) * 0.3010300099849701f;
  float _759 = cb0_037x * (_753 + _747);
  float _760 = cb0_037x * (_754 + _747);
  float _761 = cb0_037x * (_755 + _747);
  float _762 = _721 * 2.0f;
  float _764 = (cb0_037x * -2.0f) / _721;
  float _765 = _753 - _744;
  float _766 = _754 - _744;
  float _767 = _755 - _744;
  float _786 = _726 * 2.0f;
  float _788 = (cb0_037x * 2.0f) / _726;
  float _813 = select((_753 < _744), ((_762 / (exp2((_765 * 1.4426950216293335f) * _764) + 1.0f)) - cb0_037w), _759);
  float _814 = select((_754 < _744), ((_762 / (exp2((_766 * 1.4426950216293335f) * _764) + 1.0f)) - cb0_037w), _760);
  float _815 = select((_755 < _744), ((_762 / (exp2((_767 * 1.4426950216293335f) * _764) + 1.0f)) - cb0_037w), _761);
  float _822 = _749 - _744;
  float _826 = saturate(_765 / _822);
  float _827 = saturate(_766 / _822);
  float _828 = saturate(_767 / _822);
  bool _829 = (_749 < _744);
  float _833 = select(_829, (1.0f - _826), _826);
  float _834 = select(_829, (1.0f - _827), _827);
  float _835 = select(_829, (1.0f - _828), _828);
  float _854 = (((_833 * _833) * (select((_753 > _749), (_724 - (_786 / (exp2(((_753 - _749) * 1.4426950216293335f) * _788) + 1.0f))), _759) - _813)) * (3.0f - (_833 * 2.0f))) + _813;
  float _855 = (((_834 * _834) * (select((_754 > _749), (_724 - (_786 / (exp2(((_754 - _749) * 1.4426950216293335f) * _788) + 1.0f))), _760) - _814)) * (3.0f - (_834 * 2.0f))) + _814;
  float _856 = (((_835 * _835) * (select((_755 > _749), (_724 - (_786 / (exp2(((_755 - _749) * 1.4426950216293335f) * _788) + 1.0f))), _761) - _815)) * (3.0f - (_835 * 2.0f))) + _815;
  float _857 = dot(float3(_854, _855, _856), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _877 = (expand_gamut * (max(0.0f, (lerp(_857, _854, 0.9300000071525574f))) - _573)) + _573;
  float _878 = (expand_gamut * (max(0.0f, (lerp(_857, _855, 0.9300000071525574f))) - _574)) + _574;
  float _879 = (expand_gamut * (max(0.0f, (lerp(_857, _856, 0.9300000071525574f))) - _575)) + _575;
  float _895 = ((mad(-0.06537103652954102f, _879, mad(1.451815478503704e-06f, _878, (_877 * 1.065374732017517f))) - _877) * cb0_036y) + _877;
  float _896 = ((mad(-0.20366770029067993f, _879, mad(1.2036634683609009f, _878, (_877 * -2.57161445915699e-07f))) - _878) * cb0_036y) + _878;
  float _897 = ((mad(0.9999996423721313f, _879, mad(2.0954757928848267e-08f, _878, (_877 * 1.862645149230957e-08f))) - _879) * cb0_036y) + _879;
#endif

  // SetTonemappedAP1(_895, _896, _897);

  float _910 = (max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _897, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _896, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _895)))));
  float _911 = (max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _897, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _896, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _895)))));
  float _912 = (max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _897, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _896, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _895)))));
  /*
  float _910 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _897, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _896, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _895)))));
  float _911 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _897, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _896, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _895)))));
  float _912 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _897, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _896, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _895)))));
  if (_910 < 0.0031306699384003878f) {
    _923 = (_910 * 12.920000076293945f);
  } else {
    _923 = (((pow(_910, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_911 < 0.0031306699384003878f) {
    _934 = (_911 * 12.920000076293945f);
  } else {
    _934 = (((pow(_911, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_912 < 0.0031306699384003878f) {
    _945 = (_912 * 12.920000076293945f);
  } else {
    _945 = (((pow(_912, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _949 = (_934 * 0.9375f) + 0.03125f;
  float _956 = _945 * 15.0f;
  float _957 = floor(_956);
  float _958 = _956 - _957;
  float _960 = (_957 + ((_923 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _963 = t0.Sample(s0, float2(_960, _949));
  float _967 = _960 + 0.0625f;
  float4 _970 = t0.Sample(s0, float2(_967, _949));
  float4 _993 = t1.Sample(s1, float2(_960, _949));
  float4 _999 = t1.Sample(s1, float2(_967, _949));
  float _1018 = max(6.103519990574569e-05f, ((((lerp(_963.x, _970.x, _958)) * cb0_005y) + (cb0_005x * _923)) + ((lerp(_993.x, _999.x, _958)) * cb0_005z)));
  float _1019 = max(6.103519990574569e-05f, ((((lerp(_963.y, _970.y, _958)) * cb0_005y) + (cb0_005x * _934)) + ((lerp(_993.y, _999.y, _958)) * cb0_005z)));
  float _1020 = max(6.103519990574569e-05f, ((((lerp(_963.z, _970.z, _958)) * cb0_005y) + (cb0_005x * _945)) + ((lerp(_993.z, _999.z, _958)) * cb0_005z)));
  float _1042 = select((_1018 > 0.040449999272823334f), exp2(log2((_1018 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1018 * 0.07739938050508499f));
  float _1043 = select((_1019 > 0.040449999272823334f), exp2(log2((_1019 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1019 * 0.07739938050508499f));
  float _1044 = select((_1020 > 0.040449999272823334f), exp2(log2((_1020 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1020 * 0.07739938050508499f)); */
  float3 untonemapped = float3(_910, _911, _912);
  float _1042;
  float _1043;
  float _1044;
  SampleLUTUpgradeToneMap(untonemapped, s0, t0, t1, _1042, _1043, _1044);
  float _1070 = cb0_014x * (((cb0_039y + (cb0_039x * _1042)) * _1042) + cb0_039z);
  float _1071 = cb0_014y * (((cb0_039y + (cb0_039x * _1043)) * _1043) + cb0_039z);
  float _1072 = cb0_014z * (((cb0_039y + (cb0_039x * _1044)) * _1044) + cb0_039z);
  float _1079 = ((cb0_013x - _1070) * cb0_013w) + _1070;
  float _1080 = ((cb0_013y - _1071) * cb0_013w) + _1071;
  float _1081 = ((cb0_013z - _1072) * cb0_013w) + _1072;

  if (GenerateOutput(_1079, _1080, _1081, SV_Target)) {
    return SV_Target;
  }

  float _1082 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _537, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _535, (_533 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1083 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _537, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _535, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _533)));
  float _1084 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _537, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _535, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _533)));
  float _1091 = ((cb0_013x - _1082) * cb0_013w) + _1082;
  float _1092 = ((cb0_013y - _1083) * cb0_013w) + _1083;
  float _1093 = ((cb0_013z - _1084) * cb0_013w) + _1084;
  float _1105 = exp2(log2(max(0.0f, _1079)) * cb0_040y);
  float _1106 = exp2(log2(max(0.0f, _1080)) * cb0_040y);
  float _1107 = exp2(log2(max(0.0f, _1081)) * cb0_040y);

  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1130 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1105)));
        float _1133 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1105)));
        float _1136 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1105)));
        _1147 = mad(_43, _1136, mad(_42, _1133, (_1130 * _41)));
        _1148 = mad(_46, _1136, mad(_45, _1133, (_1130 * _44)));
        _1149 = mad(_49, _1136, mad(_48, _1133, (_1130 * _47)));
      } else {
        _1147 = _1105;
        _1148 = _1106;
        _1149 = _1107;
      }
      do {
        if (_1147 < 0.0031306699384003878f) {
          _1160 = (_1147 * 12.920000076293945f);
        } else {
          _1160 = (((pow(_1147, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1148 < 0.0031306699384003878f) {
            _1171 = (_1148 * 12.920000076293945f);
          } else {
            _1171 = (((pow(_1148, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1149 < 0.0031306699384003878f) {
            _2531 = _1160;
            _2532 = _1171;
            _2533 = (_1149 * 12.920000076293945f);
          } else {
            _2531 = _1160;
            _2532 = _1171;
            _2533 = (((pow(_1149, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1198 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1105)));
      float _1201 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1105)));
      float _1204 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1105)));
      float _1214 = max(6.103519990574569e-05f, mad(_43, _1204, mad(_42, _1201, (_1198 * _41))));
      float _1215 = max(6.103519990574569e-05f, mad(_46, _1204, mad(_45, _1201, (_1198 * _44))));
      float _1216 = max(6.103519990574569e-05f, mad(_49, _1204, mad(_48, _1201, (_1198 * _47))));
      _2531 = min((_1214 * 4.5f), ((exp2(log2(max(_1214, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2532 = min((_1215 * 4.5f), ((exp2(log2(max(_1215, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2533 = min((_1216 * 4.5f), ((exp2(log2(max(_1216, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1293 = cb0_012z * _1091;
        float _1294 = cb0_012z * _1092;
        float _1295 = cb0_012z * _1093;
        float _1298 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1295, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1294, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1293)));
        float _1301 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1295, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1294, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1293)));
        float _1304 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1295, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1294, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1293)));
        float _1308 = max(max(_1298, _1301), _1304);
        float _1313 = (max(_1308, 1.000000013351432e-10f) - max(min(min(_1298, _1301), _1304), 1.000000013351432e-10f)) / max(_1308, 0.009999999776482582f);
        float _1326 = ((_1301 + _1298) + _1304) + (sqrt((((_1304 - _1301) * _1304) + ((_1301 - _1298) * _1301)) + ((_1298 - _1304) * _1298)) * 1.75f);
        float _1327 = _1326 * 0.3333333432674408f;
        float _1328 = _1313 + -0.4000000059604645f;
        float _1329 = _1328 * 5.0f;
        float _1333 = max((1.0f - abs(_1328 * 2.5f)), 0.0f);
        float _1344 = ((float(((int)(uint)((bool)(_1329 > 0.0f))) - ((int)(uint)((bool)(_1329 < 0.0f)))) * (1.0f - (_1333 * _1333))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1327 <= 0.0533333346247673f)) {
            if (!(_1327 >= 0.1599999964237213f)) {
              _1353 = (((0.23999999463558197f / _1326) + -0.5f) * _1344);
            } else {
              _1353 = 0.0f;
            }
          } else {
            _1353 = _1344;
          }
          float _1354 = _1353 + 1.0f;
          float _1355 = _1354 * _1298;
          float _1356 = _1354 * _1301;
          float _1357 = _1354 * _1304;
          do {
            if (!((bool)(_1355 == _1356) && (bool)(_1356 == _1357))) {
              float _1364 = ((_1355 * 2.0f) - _1356) - _1357;
              float _1367 = ((_1301 - _1304) * 1.7320507764816284f) * _1354;
              float _1369 = atan(_1367 / _1364);
              bool _1372 = (_1364 < 0.0f);
              bool _1373 = (_1364 == 0.0f);
              bool _1374 = (_1367 >= 0.0f);
              bool _1375 = (_1367 < 0.0f);
              float _1384 = select((_1374 && _1373), 90.0f, select((_1375 && _1373), -90.0f, (select((_1375 && _1372), (_1369 + -3.1415927410125732f), select((_1374 && _1372), (_1369 + 3.1415927410125732f), _1369)) * 57.2957763671875f)));
              if (_1384 < 0.0f) {
                _1389 = (_1384 + 360.0f);
              } else {
                _1389 = _1384;
              }
            } else {
              _1389 = 0.0f;
            }
            float _1391 = min(max(_1389, 0.0f), 360.0f);
            do {
              if (_1391 < -180.0f) {
                _1400 = (_1391 + 360.0f);
              } else {
                if (_1391 > 180.0f) {
                  _1400 = (_1391 + -360.0f);
                } else {
                  _1400 = _1391;
                }
              }
              do {
                if ((bool)(_1400 > -67.5f) && (bool)(_1400 < 67.5f)) {
                  float _1406 = (_1400 + 67.5f) * 0.029629629105329514f;
                  int _1407 = int(_1406);
                  float _1409 = _1406 - float(_1407);
                  float _1410 = _1409 * _1409;
                  float _1411 = _1410 * _1409;
                  if (_1407 == 3) {
                    _1439 = (((0.1666666716337204f - (_1409 * 0.5f)) + (_1410 * 0.5f)) - (_1411 * 0.1666666716337204f));
                  } else {
                    if (_1407 == 2) {
                      _1439 = ((0.6666666865348816f - _1410) + (_1411 * 0.5f));
                    } else {
                      if (_1407 == 1) {
                        _1439 = (((_1411 * -0.5f) + 0.1666666716337204f) + ((_1410 + _1409) * 0.5f));
                      } else {
                        _1439 = select((_1407 == 0), (_1411 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1439 = 0.0f;
                }
                float _1448 = min(max(((((_1313 * 0.27000001072883606f) * (0.029999999329447746f - _1355)) * _1439) + _1355), 0.0f), 65535.0f);
                float _1449 = min(max(_1356, 0.0f), 65535.0f);
                float _1450 = min(max(_1357, 0.0f), 65535.0f);
                float _1463 = min(max(mad(-0.21492856740951538f, _1450, mad(-0.2365107536315918f, _1449, (_1448 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1464 = min(max(mad(-0.09967592358589172f, _1450, mad(1.17622971534729f, _1449, (_1448 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1465 = min(max(mad(0.9977163076400757f, _1450, mad(-0.006032449658960104f, _1449, (_1448 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1466 = dot(float3(_1463, _1464, _1465), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1477 = log2(max((lerp(_1466, _1463, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1478 = _1477 * 0.3010300099849701f;
                float _1479 = log2(cb0_008x);
                float _1480 = _1479 * 0.3010300099849701f;
                do {
                  if (!(!(_1478 <= _1480))) {
                    _1549 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1487 = log2(cb0_009x);
                    float _1488 = _1487 * 0.3010300099849701f;
                    if ((bool)(_1478 > _1480) && (bool)(_1478 < _1488)) {
                      float _1496 = ((_1477 - _1479) * 0.9030900001525879f) / ((_1487 - _1479) * 0.3010300099849701f);
                      int _1497 = int(_1496);
                      float _1499 = _1496 - float(_1497);
                      float _1501 = _14[_1497];
                      float _1504 = _14[(_1497 + 1)];
                      float _1509 = _1501 * 0.5f;
                      _1549 = dot(float3((_1499 * _1499), _1499, 1.0f), float3(mad((_14[(_1497 + 2)]), 0.5f, mad(_1504, -1.0f, _1509)), (_1504 - _1501), mad(_1504, 0.5f, _1509)));
                    } else {
                      do {
                        if (!(!(_1478 >= _1488))) {
                          float _1518 = log2(cb0_008z);
                          if (_1478 < (_1518 * 0.3010300099849701f)) {
                            float _1526 = ((_1477 - _1487) * 0.9030900001525879f) / ((_1518 - _1487) * 0.3010300099849701f);
                            int _1527 = int(_1526);
                            float _1529 = _1526 - float(_1527);
                            float _1531 = _15[_1527];
                            float _1534 = _15[(_1527 + 1)];
                            float _1539 = _1531 * 0.5f;
                            _1549 = dot(float3((_1529 * _1529), _1529, 1.0f), float3(mad((_15[(_1527 + 2)]), 0.5f, mad(_1534, -1.0f, _1539)), (_1534 - _1531), mad(_1534, 0.5f, _1539)));
                            break;
                          }
                        }
                        _1549 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1553 = log2(max((lerp(_1466, _1464, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1554 = _1553 * 0.3010300099849701f;
                  do {
                    if (!(!(_1554 <= _1480))) {
                      _1623 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1561 = log2(cb0_009x);
                      float _1562 = _1561 * 0.3010300099849701f;
                      if ((bool)(_1554 > _1480) && (bool)(_1554 < _1562)) {
                        float _1570 = ((_1553 - _1479) * 0.9030900001525879f) / ((_1561 - _1479) * 0.3010300099849701f);
                        int _1571 = int(_1570);
                        float _1573 = _1570 - float(_1571);
                        float _1575 = _14[_1571];
                        float _1578 = _14[(_1571 + 1)];
                        float _1583 = _1575 * 0.5f;
                        _1623 = dot(float3((_1573 * _1573), _1573, 1.0f), float3(mad((_14[(_1571 + 2)]), 0.5f, mad(_1578, -1.0f, _1583)), (_1578 - _1575), mad(_1578, 0.5f, _1583)));
                      } else {
                        do {
                          if (!(!(_1554 >= _1562))) {
                            float _1592 = log2(cb0_008z);
                            if (_1554 < (_1592 * 0.3010300099849701f)) {
                              float _1600 = ((_1553 - _1561) * 0.9030900001525879f) / ((_1592 - _1561) * 0.3010300099849701f);
                              int _1601 = int(_1600);
                              float _1603 = _1600 - float(_1601);
                              float _1605 = _15[_1601];
                              float _1608 = _15[(_1601 + 1)];
                              float _1613 = _1605 * 0.5f;
                              _1623 = dot(float3((_1603 * _1603), _1603, 1.0f), float3(mad((_15[(_1601 + 2)]), 0.5f, mad(_1608, -1.0f, _1613)), (_1608 - _1605), mad(_1608, 0.5f, _1613)));
                              break;
                            }
                          }
                          _1623 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1627 = log2(max((lerp(_1466, _1465, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1628 = _1627 * 0.3010300099849701f;
                    do {
                      if (!(!(_1628 <= _1480))) {
                        _1697 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1635 = log2(cb0_009x);
                        float _1636 = _1635 * 0.3010300099849701f;
                        if ((bool)(_1628 > _1480) && (bool)(_1628 < _1636)) {
                          float _1644 = ((_1627 - _1479) * 0.9030900001525879f) / ((_1635 - _1479) * 0.3010300099849701f);
                          int _1645 = int(_1644);
                          float _1647 = _1644 - float(_1645);
                          float _1649 = _14[_1645];
                          float _1652 = _14[(_1645 + 1)];
                          float _1657 = _1649 * 0.5f;
                          _1697 = dot(float3((_1647 * _1647), _1647, 1.0f), float3(mad((_14[(_1645 + 2)]), 0.5f, mad(_1652, -1.0f, _1657)), (_1652 - _1649), mad(_1652, 0.5f, _1657)));
                        } else {
                          do {
                            if (!(!(_1628 >= _1636))) {
                              float _1666 = log2(cb0_008z);
                              if (_1628 < (_1666 * 0.3010300099849701f)) {
                                float _1674 = ((_1627 - _1635) * 0.9030900001525879f) / ((_1666 - _1635) * 0.3010300099849701f);
                                int _1675 = int(_1674);
                                float _1677 = _1674 - float(_1675);
                                float _1679 = _15[_1675];
                                float _1682 = _15[(_1675 + 1)];
                                float _1687 = _1679 * 0.5f;
                                _1697 = dot(float3((_1677 * _1677), _1677, 1.0f), float3(mad((_15[(_1675 + 2)]), 0.5f, mad(_1682, -1.0f, _1687)), (_1682 - _1679), mad(_1682, 0.5f, _1687)));
                                break;
                              }
                            }
                            _1697 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1701 = cb0_008w - cb0_008y;
                      float _1702 = (exp2(_1549 * 3.321928024291992f) - cb0_008y) / _1701;
                      float _1704 = (exp2(_1623 * 3.321928024291992f) - cb0_008y) / _1701;
                      float _1706 = (exp2(_1697 * 3.321928024291992f) - cb0_008y) / _1701;
                      float _1709 = mad(0.15618768334388733f, _1706, mad(0.13400420546531677f, _1704, (_1702 * 0.6624541878700256f)));
                      float _1712 = mad(0.053689517080783844f, _1706, mad(0.6740817427635193f, _1704, (_1702 * 0.2722287178039551f)));
                      float _1715 = mad(1.0103391408920288f, _1706, mad(0.00406073359772563f, _1704, (_1702 * -0.005574649665504694f)));
                      float _1728 = min(max(mad(-0.23642469942569733f, _1715, mad(-0.32480329275131226f, _1712, (_1709 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1729 = min(max(mad(0.016756348311901093f, _1715, mad(1.6153316497802734f, _1712, (_1709 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1730 = min(max(mad(0.9883948564529419f, _1715, mad(-0.008284442126750946f, _1712, (_1709 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1733 = mad(0.15618768334388733f, _1730, mad(0.13400420546531677f, _1729, (_1728 * 0.6624541878700256f)));
                      float _1736 = mad(0.053689517080783844f, _1730, mad(0.6740817427635193f, _1729, (_1728 * 0.2722287178039551f)));
                      float _1739 = mad(1.0103391408920288f, _1730, mad(0.00406073359772563f, _1729, (_1728 * -0.005574649665504694f)));
                      float _1761 = min(max((min(max(mad(-0.23642469942569733f, _1739, mad(-0.32480329275131226f, _1736, (_1733 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1762 = min(max((min(max(mad(0.016756348311901093f, _1739, mad(1.6153316497802734f, _1736, (_1733 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1763 = min(max((min(max(mad(0.9883948564529419f, _1739, mad(-0.008284442126750946f, _1736, (_1733 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1776 = mad(_43, _1763, mad(_42, _1762, (_1761 * _41)));
                          _1777 = mad(_46, _1763, mad(_45, _1762, (_1761 * _44)));
                          _1778 = mad(_49, _1763, mad(_48, _1762, (_1761 * _47)));
                        } else {
                          _1776 = _1761;
                          _1777 = _1762;
                          _1778 = _1763;
                        }
                        float _1788 = exp2(log2(_1776 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1789 = exp2(log2(_1777 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1790 = exp2(log2(_1778 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2531 = exp2(log2((1.0f / ((_1788 * 18.6875f) + 1.0f)) * ((_1788 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2532 = exp2(log2((1.0f / ((_1789 * 18.6875f) + 1.0f)) * ((_1789 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2533 = exp2(log2((1.0f / ((_1790 * 18.6875f) + 1.0f)) * ((_1790 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1869 = cb0_012z * _1091;
          float _1870 = cb0_012z * _1092;
          float _1871 = cb0_012z * _1093;
          float _1874 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1871, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1870, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1869)));
          float _1877 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1871, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1870, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1869)));
          float _1880 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1871, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1870, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1869)));
          float _1884 = max(max(_1874, _1877), _1880);
          float _1889 = (max(_1884, 1.000000013351432e-10f) - max(min(min(_1874, _1877), _1880), 1.000000013351432e-10f)) / max(_1884, 0.009999999776482582f);
          float _1902 = ((_1877 + _1874) + _1880) + (sqrt((((_1880 - _1877) * _1880) + ((_1877 - _1874) * _1877)) + ((_1874 - _1880) * _1874)) * 1.75f);
          float _1903 = _1902 * 0.3333333432674408f;
          float _1904 = _1889 + -0.4000000059604645f;
          float _1905 = _1904 * 5.0f;
          float _1909 = max((1.0f - abs(_1904 * 2.5f)), 0.0f);
          float _1920 = ((float(((int)(uint)((bool)(_1905 > 0.0f))) - ((int)(uint)((bool)(_1905 < 0.0f)))) * (1.0f - (_1909 * _1909))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1903 <= 0.0533333346247673f)) {
              if (!(_1903 >= 0.1599999964237213f)) {
                _1929 = (((0.23999999463558197f / _1902) + -0.5f) * _1920);
              } else {
                _1929 = 0.0f;
              }
            } else {
              _1929 = _1920;
            }
            float _1930 = _1929 + 1.0f;
            float _1931 = _1930 * _1874;
            float _1932 = _1930 * _1877;
            float _1933 = _1930 * _1880;
            do {
              if (!((bool)(_1931 == _1932) && (bool)(_1932 == _1933))) {
                float _1940 = ((_1931 * 2.0f) - _1932) - _1933;
                float _1943 = ((_1877 - _1880) * 1.7320507764816284f) * _1930;
                float _1945 = atan(_1943 / _1940);
                bool _1948 = (_1940 < 0.0f);
                bool _1949 = (_1940 == 0.0f);
                bool _1950 = (_1943 >= 0.0f);
                bool _1951 = (_1943 < 0.0f);
                float _1960 = select((_1950 && _1949), 90.0f, select((_1951 && _1949), -90.0f, (select((_1951 && _1948), (_1945 + -3.1415927410125732f), select((_1950 && _1948), (_1945 + 3.1415927410125732f), _1945)) * 57.2957763671875f)));
                if (_1960 < 0.0f) {
                  _1965 = (_1960 + 360.0f);
                } else {
                  _1965 = _1960;
                }
              } else {
                _1965 = 0.0f;
              }
              float _1967 = min(max(_1965, 0.0f), 360.0f);
              do {
                if (_1967 < -180.0f) {
                  _1976 = (_1967 + 360.0f);
                } else {
                  if (_1967 > 180.0f) {
                    _1976 = (_1967 + -360.0f);
                  } else {
                    _1976 = _1967;
                  }
                }
                do {
                  if ((bool)(_1976 > -67.5f) && (bool)(_1976 < 67.5f)) {
                    float _1982 = (_1976 + 67.5f) * 0.029629629105329514f;
                    int _1983 = int(_1982);
                    float _1985 = _1982 - float(_1983);
                    float _1986 = _1985 * _1985;
                    float _1987 = _1986 * _1985;
                    if (_1983 == 3) {
                      _2015 = (((0.1666666716337204f - (_1985 * 0.5f)) + (_1986 * 0.5f)) - (_1987 * 0.1666666716337204f));
                    } else {
                      if (_1983 == 2) {
                        _2015 = ((0.6666666865348816f - _1986) + (_1987 * 0.5f));
                      } else {
                        if (_1983 == 1) {
                          _2015 = (((_1987 * -0.5f) + 0.1666666716337204f) + ((_1986 + _1985) * 0.5f));
                        } else {
                          _2015 = select((_1983 == 0), (_1987 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2015 = 0.0f;
                  }
                  float _2024 = min(max(((((_1889 * 0.27000001072883606f) * (0.029999999329447746f - _1931)) * _2015) + _1931), 0.0f), 65535.0f);
                  float _2025 = min(max(_1932, 0.0f), 65535.0f);
                  float _2026 = min(max(_1933, 0.0f), 65535.0f);
                  float _2039 = min(max(mad(-0.21492856740951538f, _2026, mad(-0.2365107536315918f, _2025, (_2024 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2040 = min(max(mad(-0.09967592358589172f, _2026, mad(1.17622971534729f, _2025, (_2024 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2041 = min(max(mad(0.9977163076400757f, _2026, mad(-0.006032449658960104f, _2025, (_2024 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2042 = dot(float3(_2039, _2040, _2041), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2053 = log2(max((lerp(_2042, _2039, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2054 = _2053 * 0.3010300099849701f;
                  float _2055 = log2(cb0_008x);
                  float _2056 = _2055 * 0.3010300099849701f;
                  do {
                    if (!(!(_2054 <= _2056))) {
                      _2125 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2063 = log2(cb0_009x);
                      float _2064 = _2063 * 0.3010300099849701f;
                      if ((bool)(_2054 > _2056) && (bool)(_2054 < _2064)) {
                        float _2072 = ((_2053 - _2055) * 0.9030900001525879f) / ((_2063 - _2055) * 0.3010300099849701f);
                        int _2073 = int(_2072);
                        float _2075 = _2072 - float(_2073);
                        float _2077 = _12[_2073];
                        float _2080 = _12[(_2073 + 1)];
                        float _2085 = _2077 * 0.5f;
                        _2125 = dot(float3((_2075 * _2075), _2075, 1.0f), float3(mad((_12[(_2073 + 2)]), 0.5f, mad(_2080, -1.0f, _2085)), (_2080 - _2077), mad(_2080, 0.5f, _2085)));
                      } else {
                        do {
                          if (!(!(_2054 >= _2064))) {
                            float _2094 = log2(cb0_008z);
                            if (_2054 < (_2094 * 0.3010300099849701f)) {
                              float _2102 = ((_2053 - _2063) * 0.9030900001525879f) / ((_2094 - _2063) * 0.3010300099849701f);
                              int _2103 = int(_2102);
                              float _2105 = _2102 - float(_2103);
                              float _2107 = _13[_2103];
                              float _2110 = _13[(_2103 + 1)];
                              float _2115 = _2107 * 0.5f;
                              _2125 = dot(float3((_2105 * _2105), _2105, 1.0f), float3(mad((_13[(_2103 + 2)]), 0.5f, mad(_2110, -1.0f, _2115)), (_2110 - _2107), mad(_2110, 0.5f, _2115)));
                              break;
                            }
                          }
                          _2125 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2129 = log2(max((lerp(_2042, _2040, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2130 = _2129 * 0.3010300099849701f;
                    do {
                      if (!(!(_2130 <= _2056))) {
                        _2199 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2137 = log2(cb0_009x);
                        float _2138 = _2137 * 0.3010300099849701f;
                        if ((bool)(_2130 > _2056) && (bool)(_2130 < _2138)) {
                          float _2146 = ((_2129 - _2055) * 0.9030900001525879f) / ((_2137 - _2055) * 0.3010300099849701f);
                          int _2147 = int(_2146);
                          float _2149 = _2146 - float(_2147);
                          float _2151 = _12[_2147];
                          float _2154 = _12[(_2147 + 1)];
                          float _2159 = _2151 * 0.5f;
                          _2199 = dot(float3((_2149 * _2149), _2149, 1.0f), float3(mad((_12[(_2147 + 2)]), 0.5f, mad(_2154, -1.0f, _2159)), (_2154 - _2151), mad(_2154, 0.5f, _2159)));
                        } else {
                          do {
                            if (!(!(_2130 >= _2138))) {
                              float _2168 = log2(cb0_008z);
                              if (_2130 < (_2168 * 0.3010300099849701f)) {
                                float _2176 = ((_2129 - _2137) * 0.9030900001525879f) / ((_2168 - _2137) * 0.3010300099849701f);
                                int _2177 = int(_2176);
                                float _2179 = _2176 - float(_2177);
                                float _2181 = _13[_2177];
                                float _2184 = _13[(_2177 + 1)];
                                float _2189 = _2181 * 0.5f;
                                _2199 = dot(float3((_2179 * _2179), _2179, 1.0f), float3(mad((_13[(_2177 + 2)]), 0.5f, mad(_2184, -1.0f, _2189)), (_2184 - _2181), mad(_2184, 0.5f, _2189)));
                                break;
                              }
                            }
                            _2199 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2203 = log2(max((lerp(_2042, _2041, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2204 = _2203 * 0.3010300099849701f;
                      do {
                        if (!(!(_2204 <= _2056))) {
                          _2273 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2211 = log2(cb0_009x);
                          float _2212 = _2211 * 0.3010300099849701f;
                          if ((bool)(_2204 > _2056) && (bool)(_2204 < _2212)) {
                            float _2220 = ((_2203 - _2055) * 0.9030900001525879f) / ((_2211 - _2055) * 0.3010300099849701f);
                            int _2221 = int(_2220);
                            float _2223 = _2220 - float(_2221);
                            float _2225 = _12[_2221];
                            float _2228 = _12[(_2221 + 1)];
                            float _2233 = _2225 * 0.5f;
                            _2273 = dot(float3((_2223 * _2223), _2223, 1.0f), float3(mad((_12[(_2221 + 2)]), 0.5f, mad(_2228, -1.0f, _2233)), (_2228 - _2225), mad(_2228, 0.5f, _2233)));
                          } else {
                            do {
                              if (!(!(_2204 >= _2212))) {
                                float _2242 = log2(cb0_008z);
                                if (_2204 < (_2242 * 0.3010300099849701f)) {
                                  float _2250 = ((_2203 - _2211) * 0.9030900001525879f) / ((_2242 - _2211) * 0.3010300099849701f);
                                  int _2251 = int(_2250);
                                  float _2253 = _2250 - float(_2251);
                                  float _2255 = _13[_2251];
                                  float _2258 = _13[(_2251 + 1)];
                                  float _2263 = _2255 * 0.5f;
                                  _2273 = dot(float3((_2253 * _2253), _2253, 1.0f), float3(mad((_13[(_2251 + 2)]), 0.5f, mad(_2258, -1.0f, _2263)), (_2258 - _2255), mad(_2258, 0.5f, _2263)));
                                  break;
                                }
                              }
                              _2273 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2277 = cb0_008w - cb0_008y;
                        float _2278 = (exp2(_2125 * 3.321928024291992f) - cb0_008y) / _2277;
                        float _2280 = (exp2(_2199 * 3.321928024291992f) - cb0_008y) / _2277;
                        float _2282 = (exp2(_2273 * 3.321928024291992f) - cb0_008y) / _2277;
                        float _2285 = mad(0.15618768334388733f, _2282, mad(0.13400420546531677f, _2280, (_2278 * 0.6624541878700256f)));
                        float _2288 = mad(0.053689517080783844f, _2282, mad(0.6740817427635193f, _2280, (_2278 * 0.2722287178039551f)));
                        float _2291 = mad(1.0103391408920288f, _2282, mad(0.00406073359772563f, _2280, (_2278 * -0.005574649665504694f)));
                        float _2304 = min(max(mad(-0.23642469942569733f, _2291, mad(-0.32480329275131226f, _2288, (_2285 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2305 = min(max(mad(0.016756348311901093f, _2291, mad(1.6153316497802734f, _2288, (_2285 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2306 = min(max(mad(0.9883948564529419f, _2291, mad(-0.008284442126750946f, _2288, (_2285 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2309 = mad(0.15618768334388733f, _2306, mad(0.13400420546531677f, _2305, (_2304 * 0.6624541878700256f)));
                        float _2312 = mad(0.053689517080783844f, _2306, mad(0.6740817427635193f, _2305, (_2304 * 0.2722287178039551f)));
                        float _2315 = mad(1.0103391408920288f, _2306, mad(0.00406073359772563f, _2305, (_2304 * -0.005574649665504694f)));
                        float _2337 = min(max((min(max(mad(-0.23642469942569733f, _2315, mad(-0.32480329275131226f, _2312, (_2309 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2338 = min(max((min(max(mad(0.016756348311901093f, _2315, mad(1.6153316497802734f, _2312, (_2309 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2339 = min(max((min(max(mad(0.9883948564529419f, _2315, mad(-0.008284442126750946f, _2312, (_2309 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2352 = mad(_43, _2339, mad(_42, _2338, (_2337 * _41)));
                            _2353 = mad(_46, _2339, mad(_45, _2338, (_2337 * _44)));
                            _2354 = mad(_49, _2339, mad(_48, _2338, (_2337 * _47)));
                          } else {
                            _2352 = _2337;
                            _2353 = _2338;
                            _2354 = _2339;
                          }
                          float _2364 = exp2(log2(_2352 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2365 = exp2(log2(_2353 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2366 = exp2(log2(_2354 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2531 = exp2(log2((1.0f / ((_2364 * 18.6875f) + 1.0f)) * ((_2364 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2532 = exp2(log2((1.0f / ((_2365 * 18.6875f) + 1.0f)) * ((_2365 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2533 = exp2(log2((1.0f / ((_2366 * 18.6875f) + 1.0f)) * ((_2366 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2411 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1093, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1092, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1091)));
            float _2414 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1093, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1092, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1091)));
            float _2417 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1093, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1092, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1091)));
            float _2436 = exp2(log2(mad(_43, _2417, mad(_42, _2414, (_2411 * _41))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2437 = exp2(log2(mad(_46, _2417, mad(_45, _2414, (_2411 * _44))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2438 = exp2(log2(mad(_49, _2417, mad(_48, _2414, (_2411 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2531 = exp2(log2((1.0f / ((_2436 * 18.6875f) + 1.0f)) * ((_2436 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2532 = exp2(log2((1.0f / ((_2437 * 18.6875f) + 1.0f)) * ((_2437 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2533 = exp2(log2((1.0f / ((_2438 * 18.6875f) + 1.0f)) * ((_2438 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2485 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1081, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1080, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1079)));
                float _2488 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1081, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1080, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1079)));
                float _2491 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1081, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1080, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1079)));
                _2531 = mad(_43, _2491, mad(_42, _2488, (_2485 * _41)));
                _2532 = mad(_46, _2491, mad(_45, _2488, (_2485 * _44)));
                _2533 = mad(_49, _2491, mad(_48, _2488, (_2485 * _47)));
              } else {
                float _2504 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1105)));
                float _2507 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1105)));
                float _2510 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1107, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1106, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1105)));
                _2531 = exp2(log2(mad(_43, _2510, mad(_42, _2507, (_2504 * _41)))) * cb0_040z);
                _2532 = exp2(log2(mad(_46, _2510, mad(_45, _2507, (_2504 * _44)))) * cb0_040z);
                _2533 = exp2(log2(mad(_49, _2510, mad(_48, _2507, (_2504 * _47)))) * cb0_040z);
              }
            } else {
              _2531 = _1091;
              _2532 = _1092;
              _2533 = _1093;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2531 * 0.9523810148239136f);
  SV_Target.y = (_2532 * 0.9523810148239136f);
  SV_Target.z = (_2533 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
