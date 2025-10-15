#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
//   float cb0_005z : packoffset(c005.z);
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

SamplerState s1 : register(s1);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _26 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _27 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _30 = float((uint)SV_DispatchThreadID.z);
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _117;
  float _118;
  float _119;
  float _643;
  float _679;
  float _690;
  float _754;
  float _933;
  float _944;
  float _955;
  float _1152;
  float _1153;
  float _1154;
  float _1165;
  float _1176;
  float _1358;
  float _1394;
  float _1405;
  float _1444;
  float _1554;
  float _1628;
  float _1702;
  float _1781;
  float _1782;
  float _1783;
  float _1934;
  float _1970;
  float _1981;
  float _2020;
  float _2130;
  float _2204;
  float _2278;
  float _2357;
  float _2358;
  float _2359;
  float _2536;
  float _2537;
  float _2538;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _40 = (output_gamut == 4);
        _51 = select(_40, 1.0f, 1.7050515413284302f);
        _52 = select(_40, 0.0f, -0.6217905879020691f);
        _53 = select(_40, 0.0f, -0.0832584798336029f);
        _54 = select(_40, 0.0f, -0.13025718927383423f);
        _55 = select(_40, 1.0f, 1.1408027410507202f);
        _56 = select(_40, 0.0f, -0.010548528283834457f);
        _57 = select(_40, 0.0f, -0.024003278464078903f);
        _58 = select(_40, 0.0f, -0.1289687603712082f);
        _59 = select(_40, 1.0f, 1.152971863746643f);
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
      _51 = 1.02579927444458f;
      _52 = -0.020052503794431686f;
      _53 = -0.0057713985443115234f;
      _54 = -0.0022350111976265907f;
      _55 = 1.0045825242996216f;
      _56 = -0.002352306619286537f;
      _57 = -0.005014004185795784f;
      _58 = -0.025293385609984398f;
      _59 = 1.0304402112960815f;
    }
  } else {
    _51 = 1.379158854484558f;
    _52 = -0.3088507056236267f;
    _53 = -0.07034677267074585f;
    _54 = -0.06933528929948807f;
    _55 = 1.0822921991348267f;
    _56 = -0.012962047010660172f;
    _57 = -0.002159259282052517f;
    _58 = -0.045465391129255295f;
    _59 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _70 = exp2(log2(_26 * 1.0322580337524414f) * 0.012683313339948654f);
    float _71 = exp2(log2(_27 * 1.0322580337524414f) * 0.012683313339948654f);
    float _72 = exp2(log2(_30 * 0.032258063554763794f) * 0.012683313339948654f);
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _117 = ((exp2((_26 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_27 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_30 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  float _134 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _119, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _118, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _117)));
  float _137 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _119, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _118, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _117)));
  float _140 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _119, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _118, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _117)));
  float _141 = dot(float3(_134, _137, _140), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _145 = (_134 / _141) + -1.0f;
  float _146 = (_137 / _141) + -1.0f;
  float _147 = (_140 / _141) + -1.0f;
  float _159 = (1.0f - exp2(((_141 * _141) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_145, _146, _147), float3(_145, _146, _147)) * -4.0f));
  float _175 = ((mad(-0.06368283927440643f, _140, mad(-0.32929131388664246f, _137, (_134 * 1.370412826538086f))) - _134) * _159) + _134;
  float _176 = ((mad(-0.010861567221581936f, _140, mad(1.0970908403396606f, _137, (_134 * -0.08343426138162613f))) - _137) * _159) + _137;
  float _177 = ((mad(1.203694462776184f, _140, mad(-0.09862564504146576f, _137, (_134 * -0.02579325996339321f))) - _140) * _159) + _140;

#if 1
  float _543;
  float _545;
  float _547;
  ApplyColorCorrection(
      _175, _176, _177,
      _543, _545, _547,
      ColorSaturation,
      ColorContrast,
      ColorGamma,
      ColorGain,
      ColorOffset,
      ColorSaturationShadows,
      ColorContrastShadows,
      ColorGammaShadows,
      ColorGainShadows,
      ColorOffsetShadows,
      ColorSaturationHighlights,
      ColorContrastHighlights,
      ColorGammaHighlights,
      ColorGainHighlights,
      ColorOffsetHighlights,
      ColorSaturationMidtones,
      ColorContrastMidtones,
      ColorGammaMidtones,
      ColorGainMidtones,
      ColorOffsetMidtones,
      ColorCorrectionShadowsMax,
      ColorCorrectionHighlightsMin,
      ColorCorrectionHighlightsMax);
#else
  float _178 = dot(float3(_175, _176, _177), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _192 = cb0_019w + cb0_024w;
  float _206 = cb0_018w * cb0_023w;
  float _220 = cb0_017w * cb0_022w;
  float _234 = cb0_016w * cb0_021w;
  float _248 = cb0_015w * cb0_020w;
  float _252 = _175 - _178;
  float _253 = _176 - _178;
  float _254 = _177 - _178;
  float _312 = saturate(_178 / cb0_035z);
  float _316 = (_312 * _312) * (3.0f - (_312 * 2.0f));
  float _317 = 1.0f - _316;
  float _326 = cb0_019w + cb0_034w;
  float _335 = cb0_018w * cb0_033w;
  float _344 = cb0_017w * cb0_032w;
  float _353 = cb0_016w * cb0_031w;
  float _362 = cb0_015w * cb0_030w;
  float _425 = saturate((_178 - cb0_035w) / (cb0_036x - cb0_035w));
  float _429 = (_425 * _425) * (3.0f - (_425 * 2.0f));
  float _438 = cb0_019w + cb0_029w;
  float _447 = cb0_018w * cb0_028w;
  float _456 = cb0_017w * cb0_027w;
  float _465 = cb0_016w * cb0_026w;
  float _474 = cb0_015w * cb0_025w;
  float _532 = _316 - _429;
  float _543 = ((_429 * (((cb0_019x + cb0_034x) + _326) + (((cb0_018x * cb0_033x) * _335) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _353) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _362) * _252) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _344)))))) + (_317 * (((cb0_019x + cb0_024x) + _192) + (((cb0_018x * cb0_023x) * _206) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _234) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _248) * _252) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _220))))))) + ((((cb0_019x + cb0_029x) + _438) + (((cb0_018x * cb0_028x) * _447) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _465) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _474) * _252) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _456))))) * _532);
  float _545 = ((_429 * (((cb0_019y + cb0_034y) + _326) + (((cb0_018y * cb0_033y) * _335) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _353) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _362) * _253) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _344)))))) + (_317 * (((cb0_019y + cb0_024y) + _192) + (((cb0_018y * cb0_023y) * _206) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _234) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _248) * _253) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _220))))))) + ((((cb0_019y + cb0_029y) + _438) + (((cb0_018y * cb0_028y) * _447) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _465) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _474) * _253) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _456))))) * _532);
  float _547 = ((_429 * (((cb0_019z + cb0_034z) + _326) + (((cb0_018z * cb0_033z) * _335) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _353) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _362) * _254) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _344)))))) + (_317 * (((cb0_019z + cb0_024z) + _192) + (((cb0_018z * cb0_023z) * _206) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _234) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _248) * _254) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _220))))))) + ((((cb0_019z + cb0_029z) + _438) + (((cb0_018z * cb0_028z) * _447) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _465) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _474) * _254) + _178)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _456))))) * _532);
#endif

  float _583 = ((mad(0.061360642313957214f, _547, mad(-4.540197551250458e-09f, _545, (_543 * 0.9386394023895264f))) - _543) * cb0_036y) + _543;
  float _584 = ((mad(0.169205904006958f, _547, mad(0.8307942152023315f, _545, (_543 * 6.775371730327606e-08f))) - _545) * cb0_036y) + _545;
  float _585 = (mad(-2.3283064365386963e-10f, _545, (_543 * -9.313225746154785e-10f)) * cb0_036y) + _547;
  float _588 = mad(0.16386905312538147f, _585, mad(0.14067868888378143f, _584, (_583 * 0.6954522132873535f)));
  float _591 = mad(0.0955343246459961f, _585, mad(0.8596711158752441f, _584, (_583 * 0.044794581830501556f)));
  float _594 = mad(1.0015007257461548f, _585, mad(0.004025210160762072f, _584, (_583 * -0.005525882821530104f)));
  float _598 = max(max(_588, _591), _594);
  float _603 = (max(_598, 1.000000013351432e-10f) - max(min(min(_588, _591), _594), 1.000000013351432e-10f)) / max(_598, 0.009999999776482582f);
  float _616 = ((_591 + _588) + _594) + (sqrt((((_594 - _591) * _594) + ((_591 - _588) * _591)) + ((_588 - _594) * _588)) * 1.75f);
  float _617 = _616 * 0.3333333432674408f;
  float _618 = _603 + -0.4000000059604645f;
  float _619 = _618 * 5.0f;
  float _623 = max((1.0f - abs(_618 * 2.5f)), 0.0f);
  float _634 = ((float((int)(((int)(uint)((bool)(_619 > 0.0f))) - ((int)(uint)((bool)(_619 < 0.0f))))) * (1.0f - (_623 * _623))) + 1.0f) * 0.02500000037252903f;
  if (!(_617 <= 0.0533333346247673f)) {
    if (!(_617 >= 0.1599999964237213f)) {
      _643 = (((0.23999999463558197f / _616) + -0.5f) * _634);
    } else {
      _643 = 0.0f;
    }
  } else {
    _643 = _634;
  }
  float _644 = _643 + 1.0f;
  float _645 = _644 * _588;
  float _646 = _644 * _591;
  float _647 = _644 * _594;
  if (!((bool)(_645 == _646) && (bool)(_646 == _647))) {
    float _654 = ((_645 * 2.0f) - _646) - _647;
    float _657 = ((_591 - _594) * 1.7320507764816284f) * _644;
    float _659 = atan(_657 / _654);
    bool _662 = (_654 < 0.0f);
    bool _663 = (_654 == 0.0f);
    bool _664 = (_657 >= 0.0f);
    bool _665 = (_657 < 0.0f);
    float _674 = select((_664 && _663), 90.0f, select((_665 && _663), -90.0f, (select((_665 && _662), (_659 + -3.1415927410125732f), select((_664 && _662), (_659 + 3.1415927410125732f), _659)) * 57.2957763671875f)));
    if (_674 < 0.0f) {
      _679 = (_674 + 360.0f);
    } else {
      _679 = _674;
    }
  } else {
    _679 = 0.0f;
  }
  float _681 = min(max(_679, 0.0f), 360.0f);
  if (_681 < -180.0f) {
    _690 = (_681 + 360.0f);
  } else {
    if (_681 > 180.0f) {
      _690 = (_681 + -360.0f);
    } else {
      _690 = _681;
    }
  }
  float _694 = saturate(1.0f - abs(_690 * 0.014814814552664757f));
  float _698 = (_694 * _694) * (3.0f - (_694 * 2.0f));
  float _704 = ((_698 * _698) * ((_603 * 0.18000000715255737f) * (0.029999999329447746f - _645))) + _645;
  float _714 = max(0.0f, mad(-0.21492856740951538f, _647, mad(-0.2365107536315918f, _646, (_704 * 1.4514392614364624f))));
  float _715 = max(0.0f, mad(-0.09967592358589172f, _647, mad(1.17622971534729f, _646, (_704 * -0.07655377686023712f))));
  float _716 = max(0.0f, mad(0.9977163076400757f, _647, mad(-0.006032449658960104f, _646, (_704 * 0.008316148072481155f))));
  float _717 = dot(float3(_714, _715, _716), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _763 = (lerp(_717, _714, 0.9599999785423279f));
  float _764 = (lerp(_717, _715, 0.9599999785423279f));
  float _765 = (lerp(_717, _716, 0.9599999785423279f));

#if 1
  float _905, _906, _907;
  ApplyFilmicToneMap(_763, _764, _765,
                     _583, _584, _585,
                     _905, _906, _907);
#else
  _763 = log2(_763) * 0.3010300099849701f;
  _764 = log2(_764) * 0.3010300099849701f;
  _765 = log2(_765) * 0.3010300099849701f;

  float _731 = (cb0_037w + 1.0f) - cb0_037y;
  float _734 = cb0_038x + 1.0f;
  float _736 = _734 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _754 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _745 = (cb0_037w + 0.18000000715255737f) / _731;
    _754 = (-0.7447274923324585f - ((log2(_745 / (2.0f - _745)) * 0.3465735912322998f) * (_731 / cb0_037x)));
  }
  float _757 = ((1.0f - cb0_037y) / cb0_037x) - _754;
  float _759 = (cb0_037z / cb0_037x) - _757;
  float _769 = cb0_037x * (_763 + _757);
  float _770 = cb0_037x * (_764 + _757);
  float _771 = cb0_037x * (_765 + _757);
  float _772 = _731 * 2.0f;
  float _774 = (cb0_037x * -2.0f) / _731;
  float _775 = _763 - _754;
  float _776 = _764 - _754;
  float _777 = _765 - _754;
  float _796 = _736 * 2.0f;
  float _798 = (cb0_037x * 2.0f) / _736;
  float _823 = select((_763 < _754), ((_772 / (exp2((_775 * 1.4426950216293335f) * _774) + 1.0f)) - cb0_037w), _769);
  float _824 = select((_764 < _754), ((_772 / (exp2((_776 * 1.4426950216293335f) * _774) + 1.0f)) - cb0_037w), _770);
  float _825 = select((_765 < _754), ((_772 / (exp2((_777 * 1.4426950216293335f) * _774) + 1.0f)) - cb0_037w), _771);
  float _832 = _759 - _754;
  float _836 = saturate(_775 / _832);
  float _837 = saturate(_776 / _832);
  float _838 = saturate(_777 / _832);
  bool _839 = (_759 < _754);
  float _843 = select(_839, (1.0f - _836), _836);
  float _844 = select(_839, (1.0f - _837), _837);
  float _845 = select(_839, (1.0f - _838), _838);
  float _864 = (((_843 * _843) * (select((_763 > _759), (_734 - (_796 / (exp2(((_763 - _759) * 1.4426950216293335f) * _798) + 1.0f))), _769) - _823)) * (3.0f - (_843 * 2.0f))) + _823;
  float _865 = (((_844 * _844) * (select((_764 > _759), (_734 - (_796 / (exp2(((_764 - _759) * 1.4426950216293335f) * _798) + 1.0f))), _770) - _824)) * (3.0f - (_844 * 2.0f))) + _824;
  float _866 = (((_845 * _845) * (select((_765 > _759), (_734 - (_796 / (exp2(((_765 - _759) * 1.4426950216293335f) * _798) + 1.0f))), _771) - _825)) * (3.0f - (_845 * 2.0f))) + _825;
  float _867 = dot(float3(_864, _865, _866), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _887 = (cb0_036w * (max(0.0f, (lerp(_867, _864, 0.9300000071525574f))) - _583)) + _583;
  float _888 = (cb0_036w * (max(0.0f, (lerp(_867, _865, 0.9300000071525574f))) - _584)) + _584;
  float _889 = (cb0_036w * (max(0.0f, (lerp(_867, _866, 0.9300000071525574f))) - _585)) + _585;
  float _905 = ((mad(-0.06537103652954102f, _889, mad(1.451815478503704e-06f, _888, (_887 * 1.065374732017517f))) - _887) * cb0_036y) + _887;
  float _906 = ((mad(-0.20366770029067993f, _889, mad(1.2036634683609009f, _888, (_887 * -2.57161445915699e-07f))) - _888) * cb0_036y) + _888;
  float _907 = ((mad(0.9999996423721313f, _889, mad(2.0954757928848267e-08f, _888, (_887 * 1.862645149230957e-08f))) - _889) * cb0_036y) + _889;
#endif

  float _920 = ((mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _907, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _906, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _905)))));
  float _921 = ((mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _907, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _906, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _905)))));
  float _922 = ((mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _907, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _906, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _905)))));

#if 1
  float _1047, _1048, _1049;
  Sample2LUTsUpgradeToneMap(
      float3(_920, _921, _922),
      s0, s1,
      t0, t1,
      _1047, _1048, _1049);
#else
  if (_920 < 0.0031306699384003878f) {
    _933 = (_920 * 12.920000076293945f);
  } else {
    _933 = (((pow(_920, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_921 < 0.0031306699384003878f) {
    _944 = (_921 * 12.920000076293945f);
  } else {
    _944 = (((pow(_921, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_922 < 0.0031306699384003878f) {
    _955 = (_922 * 12.920000076293945f);
  } else {
    _955 = (((pow(_922, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _959 = (_944 * 0.9375f) + 0.03125f;
  float _966 = _955 * 15.0f;
  float _967 = floor(_966);
  float _968 = _966 - _967;
  float _970 = (_967 + ((_933 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _973 = t0.SampleLevel(s0, float2(_970, _959), 0.0f);
  float _977 = _970 + 0.0625f;
  float4 _978 = t0.SampleLevel(s0, float2(_977, _959), 0.0f);
  float4 _1000 = t1.SampleLevel(s1, float2(_970, _959), 0.0f);
  float4 _1004 = t1.SampleLevel(s1, float2(_977, _959), 0.0f);
  float _1023 = max(6.103519990574569e-05f, ((((lerp(_973.x, _978.x, _968))*cb0_005y) + (cb0_005x * _933)) + ((lerp(_1000.x, _1004.x, _968))*cb0_005z)));
  float _1024 = max(6.103519990574569e-05f, ((((lerp(_973.y, _978.y, _968))*cb0_005y) + (cb0_005x * _944)) + ((lerp(_1000.y, _1004.y, _968))*cb0_005z)));
  float _1025 = max(6.103519990574569e-05f, ((((lerp(_973.z, _978.z, _968))*cb0_005y) + (cb0_005x * _955)) + ((lerp(_1000.z, _1004.z, _968))*cb0_005z)));
  float _1047 = select((_1023 > 0.040449999272823334f), exp2(log2((_1023 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1023 * 0.07739938050508499f));
  float _1048 = select((_1024 > 0.040449999272823334f), exp2(log2((_1024 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1024 * 0.07739938050508499f));
  float _1049 = select((_1025 > 0.040449999272823334f), exp2(log2((_1025 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1025 * 0.07739938050508499f));
#endif

  float _1075 = cb0_014x * (((cb0_039y + (cb0_039x * _1047)) * _1047) + cb0_039z);
  float _1076 = cb0_014y * (((cb0_039y + (cb0_039x * _1048)) * _1048) + cb0_039z);
  float _1077 = cb0_014z * (((cb0_039y + (cb0_039x * _1049)) * _1049) + cb0_039z);
  float _1084 = ((cb0_013x - _1075) * cb0_013w) + _1075;
  float _1085 = ((cb0_013y - _1076) * cb0_013w) + _1076;
  float _1086 = ((cb0_013z - _1077) * cb0_013w) + _1077;

  if (GenerateOutput(_1084, _1085, _1086, u0[SV_DispatchThreadID])) {
    return;
  }

  float _1087 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _547, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _545, (_543 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1088 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _547, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _545, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _543)));
  float _1089 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _547, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _545, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _543)));
  float _1096 = ((cb0_013x - _1087) * cb0_013w) + _1087;
  float _1097 = ((cb0_013y - _1088) * cb0_013w) + _1088;
  float _1098 = ((cb0_013z - _1089) * cb0_013w) + _1089;
  float _1110 = exp2(log2(max(0.0f, _1084)) * cb0_040y);
  float _1111 = exp2(log2(max(0.0f, _1085)) * cb0_040y);
  float _1112 = exp2(log2(max(0.0f, _1086)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1135 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1110)));
        float _1138 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1110)));
        float _1141 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1110)));
        _1152 = mad(_53, _1141, mad(_52, _1138, (_1135 * _51)));
        _1153 = mad(_56, _1141, mad(_55, _1138, (_1135 * _54)));
        _1154 = mad(_59, _1141, mad(_58, _1138, (_1135 * _57)));
      } else {
        _1152 = _1110;
        _1153 = _1111;
        _1154 = _1112;
      }
      do {
        if (_1152 < 0.0031306699384003878f) {
          _1165 = (_1152 * 12.920000076293945f);
        } else {
          _1165 = (((pow(_1152, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1153 < 0.0031306699384003878f) {
            _1176 = (_1153 * 12.920000076293945f);
          } else {
            _1176 = (((pow(_1153, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1154 < 0.0031306699384003878f) {
            _2536 = _1165;
            _2537 = _1176;
            _2538 = (_1154 * 12.920000076293945f);
          } else {
            _2536 = _1165;
            _2537 = _1176;
            _2538 = (((pow(_1154, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1203 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1110)));
      float _1206 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1110)));
      float _1209 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1110)));
      float _1219 = max(6.103519990574569e-05f, mad(_53, _1209, mad(_52, _1206, (_1203 * _51))));
      float _1220 = max(6.103519990574569e-05f, mad(_56, _1209, mad(_55, _1206, (_1203 * _54))));
      float _1221 = max(6.103519990574569e-05f, mad(_59, _1209, mad(_58, _1206, (_1203 * _57))));
      _2536 = min((_1219 * 4.5f), ((exp2(log2(max(_1219, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2537 = min((_1220 * 4.5f), ((exp2(log2(max(_1220, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2538 = min((_1221 * 4.5f), ((exp2(log2(max(_1221, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
        _15[0] = cb0_010x;
        _15[1] = cb0_010y;
        _15[2] = cb0_010z;
        _15[3] = cb0_010w;
        _15[4] = cb0_012x;
        _15[5] = cb0_012x;
        _16[0] = cb0_011x;
        _16[1] = cb0_011y;
        _16[2] = cb0_011z;
        _16[3] = cb0_011w;
        _16[4] = cb0_012y;
        _16[5] = cb0_012y;
        float _1298 = cb0_012z * _1096;
        float _1299 = cb0_012z * _1097;
        float _1300 = cb0_012z * _1098;
        float _1303 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1300, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1299, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1298)));
        float _1306 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1300, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1299, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1298)));
        float _1309 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1300, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1299, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1298)));
        float _1313 = max(max(_1303, _1306), _1309);
        float _1318 = (max(_1313, 1.000000013351432e-10f) - max(min(min(_1303, _1306), _1309), 1.000000013351432e-10f)) / max(_1313, 0.009999999776482582f);
        float _1331 = ((_1306 + _1303) + _1309) + (sqrt((((_1309 - _1306) * _1309) + ((_1306 - _1303) * _1306)) + ((_1303 - _1309) * _1303)) * 1.75f);
        float _1332 = _1331 * 0.3333333432674408f;
        float _1333 = _1318 + -0.4000000059604645f;
        float _1334 = _1333 * 5.0f;
        float _1338 = max((1.0f - abs(_1333 * 2.5f)), 0.0f);
        float _1349 = ((float((int)(((int)(uint)((bool)(_1334 > 0.0f))) - ((int)(uint)((bool)(_1334 < 0.0f))))) * (1.0f - (_1338 * _1338))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1332 <= 0.0533333346247673f)) {
            if (!(_1332 >= 0.1599999964237213f)) {
              _1358 = (((0.23999999463558197f / _1331) + -0.5f) * _1349);
            } else {
              _1358 = 0.0f;
            }
          } else {
            _1358 = _1349;
          }
          float _1359 = _1358 + 1.0f;
          float _1360 = _1359 * _1303;
          float _1361 = _1359 * _1306;
          float _1362 = _1359 * _1309;
          do {
            if (!((bool)(_1360 == _1361) && (bool)(_1361 == _1362))) {
              float _1369 = ((_1360 * 2.0f) - _1361) - _1362;
              float _1372 = ((_1306 - _1309) * 1.7320507764816284f) * _1359;
              float _1374 = atan(_1372 / _1369);
              bool _1377 = (_1369 < 0.0f);
              bool _1378 = (_1369 == 0.0f);
              bool _1379 = (_1372 >= 0.0f);
              bool _1380 = (_1372 < 0.0f);
              float _1389 = select((_1379 && _1378), 90.0f, select((_1380 && _1378), -90.0f, (select((_1380 && _1377), (_1374 + -3.1415927410125732f), select((_1379 && _1377), (_1374 + 3.1415927410125732f), _1374)) * 57.2957763671875f)));
              if (_1389 < 0.0f) {
                _1394 = (_1389 + 360.0f);
              } else {
                _1394 = _1389;
              }
            } else {
              _1394 = 0.0f;
            }
            float _1396 = min(max(_1394, 0.0f), 360.0f);
            do {
              if (_1396 < -180.0f) {
                _1405 = (_1396 + 360.0f);
              } else {
                if (_1396 > 180.0f) {
                  _1405 = (_1396 + -360.0f);
                } else {
                  _1405 = _1396;
                }
              }
              do {
                if ((bool)(_1405 > -67.5f) && (bool)(_1405 < 67.5f)) {
                  float _1411 = (_1405 + 67.5f) * 0.029629629105329514f;
                  int _1412 = int(_1411);
                  float _1414 = _1411 - float((int)(_1412));
                  float _1415 = _1414 * _1414;
                  float _1416 = _1415 * _1414;
                  if (_1412 == 3) {
                    _1444 = (((0.1666666716337204f - (_1414 * 0.5f)) + (_1415 * 0.5f)) - (_1416 * 0.1666666716337204f));
                  } else {
                    if (_1412 == 2) {
                      _1444 = ((0.6666666865348816f - _1415) + (_1416 * 0.5f));
                    } else {
                      if (_1412 == 1) {
                        _1444 = (((_1416 * -0.5f) + 0.1666666716337204f) + ((_1415 + _1414) * 0.5f));
                      } else {
                        _1444 = select((_1412 == 0), (_1416 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1444 = 0.0f;
                }
                float _1453 = min(max(((((_1318 * 0.27000001072883606f) * (0.029999999329447746f - _1360)) * _1444) + _1360), 0.0f), 65535.0f);
                float _1454 = min(max(_1361, 0.0f), 65535.0f);
                float _1455 = min(max(_1362, 0.0f), 65535.0f);
                float _1468 = min(max(mad(-0.21492856740951538f, _1455, mad(-0.2365107536315918f, _1454, (_1453 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1469 = min(max(mad(-0.09967592358589172f, _1455, mad(1.17622971534729f, _1454, (_1453 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1470 = min(max(mad(0.9977163076400757f, _1455, mad(-0.006032449658960104f, _1454, (_1453 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1471 = dot(float3(_1468, _1469, _1470), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1482 = log2(max((lerp(_1471, _1468, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1483 = _1482 * 0.3010300099849701f;
                float _1484 = log2(cb0_008x);
                float _1485 = _1484 * 0.3010300099849701f;
                do {
                  if (!(!(_1483 <= _1485))) {
                    _1554 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1492 = log2(cb0_009x);
                    float _1493 = _1492 * 0.3010300099849701f;
                    if ((bool)(_1483 > _1485) && (bool)(_1483 < _1493)) {
                      float _1501 = ((_1482 - _1484) * 0.9030900001525879f) / ((_1492 - _1484) * 0.3010300099849701f);
                      int _1502 = int(_1501);
                      float _1504 = _1501 - float((int)(_1502));
                      float _1506 = _15[_1502];
                      float _1509 = _15[(_1502 + 1)];
                      float _1514 = _1506 * 0.5f;
                      _1554 = dot(float3((_1504 * _1504), _1504, 1.0f), float3(mad((_15[(_1502 + 2)]), 0.5f, mad(_1509, -1.0f, _1514)), (_1509 - _1506), mad(_1509, 0.5f, _1514)));
                    } else {
                      do {
                        if (!(!(_1483 >= _1493))) {
                          float _1523 = log2(cb0_008z);
                          if (_1483 < (_1523 * 0.3010300099849701f)) {
                            float _1531 = ((_1482 - _1492) * 0.9030900001525879f) / ((_1523 - _1492) * 0.3010300099849701f);
                            int _1532 = int(_1531);
                            float _1534 = _1531 - float((int)(_1532));
                            float _1536 = _16[_1532];
                            float _1539 = _16[(_1532 + 1)];
                            float _1544 = _1536 * 0.5f;
                            _1554 = dot(float3((_1534 * _1534), _1534, 1.0f), float3(mad((_16[(_1532 + 2)]), 0.5f, mad(_1539, -1.0f, _1544)), (_1539 - _1536), mad(_1539, 0.5f, _1544)));
                            break;
                          }
                        }
                        _1554 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1558 = log2(max((lerp(_1471, _1469, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1559 = _1558 * 0.3010300099849701f;
                  do {
                    if (!(!(_1559 <= _1485))) {
                      _1628 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1566 = log2(cb0_009x);
                      float _1567 = _1566 * 0.3010300099849701f;
                      if ((bool)(_1559 > _1485) && (bool)(_1559 < _1567)) {
                        float _1575 = ((_1558 - _1484) * 0.9030900001525879f) / ((_1566 - _1484) * 0.3010300099849701f);
                        int _1576 = int(_1575);
                        float _1578 = _1575 - float((int)(_1576));
                        float _1580 = _15[_1576];
                        float _1583 = _15[(_1576 + 1)];
                        float _1588 = _1580 * 0.5f;
                        _1628 = dot(float3((_1578 * _1578), _1578, 1.0f), float3(mad((_15[(_1576 + 2)]), 0.5f, mad(_1583, -1.0f, _1588)), (_1583 - _1580), mad(_1583, 0.5f, _1588)));
                      } else {
                        do {
                          if (!(!(_1559 >= _1567))) {
                            float _1597 = log2(cb0_008z);
                            if (_1559 < (_1597 * 0.3010300099849701f)) {
                              float _1605 = ((_1558 - _1566) * 0.9030900001525879f) / ((_1597 - _1566) * 0.3010300099849701f);
                              int _1606 = int(_1605);
                              float _1608 = _1605 - float((int)(_1606));
                              float _1610 = _16[_1606];
                              float _1613 = _16[(_1606 + 1)];
                              float _1618 = _1610 * 0.5f;
                              _1628 = dot(float3((_1608 * _1608), _1608, 1.0f), float3(mad((_16[(_1606 + 2)]), 0.5f, mad(_1613, -1.0f, _1618)), (_1613 - _1610), mad(_1613, 0.5f, _1618)));
                              break;
                            }
                          }
                          _1628 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1632 = log2(max((lerp(_1471, _1470, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1633 = _1632 * 0.3010300099849701f;
                    do {
                      if (!(!(_1633 <= _1485))) {
                        _1702 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1640 = log2(cb0_009x);
                        float _1641 = _1640 * 0.3010300099849701f;
                        if ((bool)(_1633 > _1485) && (bool)(_1633 < _1641)) {
                          float _1649 = ((_1632 - _1484) * 0.9030900001525879f) / ((_1640 - _1484) * 0.3010300099849701f);
                          int _1650 = int(_1649);
                          float _1652 = _1649 - float((int)(_1650));
                          float _1654 = _15[_1650];
                          float _1657 = _15[(_1650 + 1)];
                          float _1662 = _1654 * 0.5f;
                          _1702 = dot(float3((_1652 * _1652), _1652, 1.0f), float3(mad((_15[(_1650 + 2)]), 0.5f, mad(_1657, -1.0f, _1662)), (_1657 - _1654), mad(_1657, 0.5f, _1662)));
                        } else {
                          do {
                            if (!(!(_1633 >= _1641))) {
                              float _1671 = log2(cb0_008z);
                              if (_1633 < (_1671 * 0.3010300099849701f)) {
                                float _1679 = ((_1632 - _1640) * 0.9030900001525879f) / ((_1671 - _1640) * 0.3010300099849701f);
                                int _1680 = int(_1679);
                                float _1682 = _1679 - float((int)(_1680));
                                float _1684 = _16[_1680];
                                float _1687 = _16[(_1680 + 1)];
                                float _1692 = _1684 * 0.5f;
                                _1702 = dot(float3((_1682 * _1682), _1682, 1.0f), float3(mad((_16[(_1680 + 2)]), 0.5f, mad(_1687, -1.0f, _1692)), (_1687 - _1684), mad(_1687, 0.5f, _1692)));
                                break;
                              }
                            }
                            _1702 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1706 = cb0_008w - cb0_008y;
                      float _1707 = (exp2(_1554 * 3.321928024291992f) - cb0_008y) / _1706;
                      float _1709 = (exp2(_1628 * 3.321928024291992f) - cb0_008y) / _1706;
                      float _1711 = (exp2(_1702 * 3.321928024291992f) - cb0_008y) / _1706;
                      float _1714 = mad(0.15618768334388733f, _1711, mad(0.13400420546531677f, _1709, (_1707 * 0.6624541878700256f)));
                      float _1717 = mad(0.053689517080783844f, _1711, mad(0.6740817427635193f, _1709, (_1707 * 0.2722287178039551f)));
                      float _1720 = mad(1.0103391408920288f, _1711, mad(0.00406073359772563f, _1709, (_1707 * -0.005574649665504694f)));
                      float _1733 = min(max(mad(-0.23642469942569733f, _1720, mad(-0.32480329275131226f, _1717, (_1714 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1734 = min(max(mad(0.016756348311901093f, _1720, mad(1.6153316497802734f, _1717, (_1714 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1735 = min(max(mad(0.9883948564529419f, _1720, mad(-0.008284442126750946f, _1717, (_1714 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1738 = mad(0.15618768334388733f, _1735, mad(0.13400420546531677f, _1734, (_1733 * 0.6624541878700256f)));
                      float _1741 = mad(0.053689517080783844f, _1735, mad(0.6740817427635193f, _1734, (_1733 * 0.2722287178039551f)));
                      float _1744 = mad(1.0103391408920288f, _1735, mad(0.00406073359772563f, _1734, (_1733 * -0.005574649665504694f)));
                      float _1766 = min(max((min(max(mad(-0.23642469942569733f, _1744, mad(-0.32480329275131226f, _1741, (_1738 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1767 = min(max((min(max(mad(0.016756348311901093f, _1744, mad(1.6153316497802734f, _1741, (_1738 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1768 = min(max((min(max(mad(0.9883948564529419f, _1744, mad(-0.008284442126750946f, _1741, (_1738 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1781 = mad(_53, _1768, mad(_52, _1767, (_1766 * _51)));
                          _1782 = mad(_56, _1768, mad(_55, _1767, (_1766 * _54)));
                          _1783 = mad(_59, _1768, mad(_58, _1767, (_1766 * _57)));
                        } else {
                          _1781 = _1766;
                          _1782 = _1767;
                          _1783 = _1768;
                        }
                        float _1793 = exp2(log2(_1781 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1794 = exp2(log2(_1782 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1795 = exp2(log2(_1783 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2536 = exp2(log2((1.0f / ((_1793 * 18.6875f) + 1.0f)) * ((_1793 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2537 = exp2(log2((1.0f / ((_1794 * 18.6875f) + 1.0f)) * ((_1794 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2538 = exp2(log2((1.0f / ((_1795 * 18.6875f) + 1.0f)) * ((_1795 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1874 = cb0_012z * _1096;
          float _1875 = cb0_012z * _1097;
          float _1876 = cb0_012z * _1098;
          float _1879 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1876, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1875, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1874)));
          float _1882 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1876, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1875, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1874)));
          float _1885 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1876, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1875, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1874)));
          float _1889 = max(max(_1879, _1882), _1885);
          float _1894 = (max(_1889, 1.000000013351432e-10f) - max(min(min(_1879, _1882), _1885), 1.000000013351432e-10f)) / max(_1889, 0.009999999776482582f);
          float _1907 = ((_1882 + _1879) + _1885) + (sqrt((((_1885 - _1882) * _1885) + ((_1882 - _1879) * _1882)) + ((_1879 - _1885) * _1879)) * 1.75f);
          float _1908 = _1907 * 0.3333333432674408f;
          float _1909 = _1894 + -0.4000000059604645f;
          float _1910 = _1909 * 5.0f;
          float _1914 = max((1.0f - abs(_1909 * 2.5f)), 0.0f);
          float _1925 = ((float((int)(((int)(uint)((bool)(_1910 > 0.0f))) - ((int)(uint)((bool)(_1910 < 0.0f))))) * (1.0f - (_1914 * _1914))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1908 <= 0.0533333346247673f)) {
              if (!(_1908 >= 0.1599999964237213f)) {
                _1934 = (((0.23999999463558197f / _1907) + -0.5f) * _1925);
              } else {
                _1934 = 0.0f;
              }
            } else {
              _1934 = _1925;
            }
            float _1935 = _1934 + 1.0f;
            float _1936 = _1935 * _1879;
            float _1937 = _1935 * _1882;
            float _1938 = _1935 * _1885;
            do {
              if (!((bool)(_1936 == _1937) && (bool)(_1937 == _1938))) {
                float _1945 = ((_1936 * 2.0f) - _1937) - _1938;
                float _1948 = ((_1882 - _1885) * 1.7320507764816284f) * _1935;
                float _1950 = atan(_1948 / _1945);
                bool _1953 = (_1945 < 0.0f);
                bool _1954 = (_1945 == 0.0f);
                bool _1955 = (_1948 >= 0.0f);
                bool _1956 = (_1948 < 0.0f);
                float _1965 = select((_1955 && _1954), 90.0f, select((_1956 && _1954), -90.0f, (select((_1956 && _1953), (_1950 + -3.1415927410125732f), select((_1955 && _1953), (_1950 + 3.1415927410125732f), _1950)) * 57.2957763671875f)));
                if (_1965 < 0.0f) {
                  _1970 = (_1965 + 360.0f);
                } else {
                  _1970 = _1965;
                }
              } else {
                _1970 = 0.0f;
              }
              float _1972 = min(max(_1970, 0.0f), 360.0f);
              do {
                if (_1972 < -180.0f) {
                  _1981 = (_1972 + 360.0f);
                } else {
                  if (_1972 > 180.0f) {
                    _1981 = (_1972 + -360.0f);
                  } else {
                    _1981 = _1972;
                  }
                }
                do {
                  if ((bool)(_1981 > -67.5f) && (bool)(_1981 < 67.5f)) {
                    float _1987 = (_1981 + 67.5f) * 0.029629629105329514f;
                    int _1988 = int(_1987);
                    float _1990 = _1987 - float((int)(_1988));
                    float _1991 = _1990 * _1990;
                    float _1992 = _1991 * _1990;
                    if (_1988 == 3) {
                      _2020 = (((0.1666666716337204f - (_1990 * 0.5f)) + (_1991 * 0.5f)) - (_1992 * 0.1666666716337204f));
                    } else {
                      if (_1988 == 2) {
                        _2020 = ((0.6666666865348816f - _1991) + (_1992 * 0.5f));
                      } else {
                        if (_1988 == 1) {
                          _2020 = (((_1992 * -0.5f) + 0.1666666716337204f) + ((_1991 + _1990) * 0.5f));
                        } else {
                          _2020 = select((_1988 == 0), (_1992 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2020 = 0.0f;
                  }
                  float _2029 = min(max(((((_1894 * 0.27000001072883606f) * (0.029999999329447746f - _1936)) * _2020) + _1936), 0.0f), 65535.0f);
                  float _2030 = min(max(_1937, 0.0f), 65535.0f);
                  float _2031 = min(max(_1938, 0.0f), 65535.0f);
                  float _2044 = min(max(mad(-0.21492856740951538f, _2031, mad(-0.2365107536315918f, _2030, (_2029 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2045 = min(max(mad(-0.09967592358589172f, _2031, mad(1.17622971534729f, _2030, (_2029 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2046 = min(max(mad(0.9977163076400757f, _2031, mad(-0.006032449658960104f, _2030, (_2029 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2047 = dot(float3(_2044, _2045, _2046), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2058 = log2(max((lerp(_2047, _2044, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2059 = _2058 * 0.3010300099849701f;
                  float _2060 = log2(cb0_008x);
                  float _2061 = _2060 * 0.3010300099849701f;
                  do {
                    if (!(!(_2059 <= _2061))) {
                      _2130 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2068 = log2(cb0_009x);
                      float _2069 = _2068 * 0.3010300099849701f;
                      if ((bool)(_2059 > _2061) && (bool)(_2059 < _2069)) {
                        float _2077 = ((_2058 - _2060) * 0.9030900001525879f) / ((_2068 - _2060) * 0.3010300099849701f);
                        int _2078 = int(_2077);
                        float _2080 = _2077 - float((int)(_2078));
                        float _2082 = _13[_2078];
                        float _2085 = _13[(_2078 + 1)];
                        float _2090 = _2082 * 0.5f;
                        _2130 = dot(float3((_2080 * _2080), _2080, 1.0f), float3(mad((_13[(_2078 + 2)]), 0.5f, mad(_2085, -1.0f, _2090)), (_2085 - _2082), mad(_2085, 0.5f, _2090)));
                      } else {
                        do {
                          if (!(!(_2059 >= _2069))) {
                            float _2099 = log2(cb0_008z);
                            if (_2059 < (_2099 * 0.3010300099849701f)) {
                              float _2107 = ((_2058 - _2068) * 0.9030900001525879f) / ((_2099 - _2068) * 0.3010300099849701f);
                              int _2108 = int(_2107);
                              float _2110 = _2107 - float((int)(_2108));
                              float _2112 = _14[_2108];
                              float _2115 = _14[(_2108 + 1)];
                              float _2120 = _2112 * 0.5f;
                              _2130 = dot(float3((_2110 * _2110), _2110, 1.0f), float3(mad((_14[(_2108 + 2)]), 0.5f, mad(_2115, -1.0f, _2120)), (_2115 - _2112), mad(_2115, 0.5f, _2120)));
                              break;
                            }
                          }
                          _2130 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2134 = log2(max((lerp(_2047, _2045, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2135 = _2134 * 0.3010300099849701f;
                    do {
                      if (!(!(_2135 <= _2061))) {
                        _2204 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2142 = log2(cb0_009x);
                        float _2143 = _2142 * 0.3010300099849701f;
                        if ((bool)(_2135 > _2061) && (bool)(_2135 < _2143)) {
                          float _2151 = ((_2134 - _2060) * 0.9030900001525879f) / ((_2142 - _2060) * 0.3010300099849701f);
                          int _2152 = int(_2151);
                          float _2154 = _2151 - float((int)(_2152));
                          float _2156 = _13[_2152];
                          float _2159 = _13[(_2152 + 1)];
                          float _2164 = _2156 * 0.5f;
                          _2204 = dot(float3((_2154 * _2154), _2154, 1.0f), float3(mad((_13[(_2152 + 2)]), 0.5f, mad(_2159, -1.0f, _2164)), (_2159 - _2156), mad(_2159, 0.5f, _2164)));
                        } else {
                          do {
                            if (!(!(_2135 >= _2143))) {
                              float _2173 = log2(cb0_008z);
                              if (_2135 < (_2173 * 0.3010300099849701f)) {
                                float _2181 = ((_2134 - _2142) * 0.9030900001525879f) / ((_2173 - _2142) * 0.3010300099849701f);
                                int _2182 = int(_2181);
                                float _2184 = _2181 - float((int)(_2182));
                                float _2186 = _14[_2182];
                                float _2189 = _14[(_2182 + 1)];
                                float _2194 = _2186 * 0.5f;
                                _2204 = dot(float3((_2184 * _2184), _2184, 1.0f), float3(mad((_14[(_2182 + 2)]), 0.5f, mad(_2189, -1.0f, _2194)), (_2189 - _2186), mad(_2189, 0.5f, _2194)));
                                break;
                              }
                            }
                            _2204 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2208 = log2(max((lerp(_2047, _2046, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2209 = _2208 * 0.3010300099849701f;
                      do {
                        if (!(!(_2209 <= _2061))) {
                          _2278 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2216 = log2(cb0_009x);
                          float _2217 = _2216 * 0.3010300099849701f;
                          if ((bool)(_2209 > _2061) && (bool)(_2209 < _2217)) {
                            float _2225 = ((_2208 - _2060) * 0.9030900001525879f) / ((_2216 - _2060) * 0.3010300099849701f);
                            int _2226 = int(_2225);
                            float _2228 = _2225 - float((int)(_2226));
                            float _2230 = _13[_2226];
                            float _2233 = _13[(_2226 + 1)];
                            float _2238 = _2230 * 0.5f;
                            _2278 = dot(float3((_2228 * _2228), _2228, 1.0f), float3(mad((_13[(_2226 + 2)]), 0.5f, mad(_2233, -1.0f, _2238)), (_2233 - _2230), mad(_2233, 0.5f, _2238)));
                          } else {
                            do {
                              if (!(!(_2209 >= _2217))) {
                                float _2247 = log2(cb0_008z);
                                if (_2209 < (_2247 * 0.3010300099849701f)) {
                                  float _2255 = ((_2208 - _2216) * 0.9030900001525879f) / ((_2247 - _2216) * 0.3010300099849701f);
                                  int _2256 = int(_2255);
                                  float _2258 = _2255 - float((int)(_2256));
                                  float _2260 = _14[_2256];
                                  float _2263 = _14[(_2256 + 1)];
                                  float _2268 = _2260 * 0.5f;
                                  _2278 = dot(float3((_2258 * _2258), _2258, 1.0f), float3(mad((_14[(_2256 + 2)]), 0.5f, mad(_2263, -1.0f, _2268)), (_2263 - _2260), mad(_2263, 0.5f, _2268)));
                                  break;
                                }
                              }
                              _2278 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2282 = cb0_008w - cb0_008y;
                        float _2283 = (exp2(_2130 * 3.321928024291992f) - cb0_008y) / _2282;
                        float _2285 = (exp2(_2204 * 3.321928024291992f) - cb0_008y) / _2282;
                        float _2287 = (exp2(_2278 * 3.321928024291992f) - cb0_008y) / _2282;
                        float _2290 = mad(0.15618768334388733f, _2287, mad(0.13400420546531677f, _2285, (_2283 * 0.6624541878700256f)));
                        float _2293 = mad(0.053689517080783844f, _2287, mad(0.6740817427635193f, _2285, (_2283 * 0.2722287178039551f)));
                        float _2296 = mad(1.0103391408920288f, _2287, mad(0.00406073359772563f, _2285, (_2283 * -0.005574649665504694f)));
                        float _2309 = min(max(mad(-0.23642469942569733f, _2296, mad(-0.32480329275131226f, _2293, (_2290 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2310 = min(max(mad(0.016756348311901093f, _2296, mad(1.6153316497802734f, _2293, (_2290 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2311 = min(max(mad(0.9883948564529419f, _2296, mad(-0.008284442126750946f, _2293, (_2290 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2314 = mad(0.15618768334388733f, _2311, mad(0.13400420546531677f, _2310, (_2309 * 0.6624541878700256f)));
                        float _2317 = mad(0.053689517080783844f, _2311, mad(0.6740817427635193f, _2310, (_2309 * 0.2722287178039551f)));
                        float _2320 = mad(1.0103391408920288f, _2311, mad(0.00406073359772563f, _2310, (_2309 * -0.005574649665504694f)));
                        float _2342 = min(max((min(max(mad(-0.23642469942569733f, _2320, mad(-0.32480329275131226f, _2317, (_2314 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2343 = min(max((min(max(mad(0.016756348311901093f, _2320, mad(1.6153316497802734f, _2317, (_2314 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2344 = min(max((min(max(mad(0.9883948564529419f, _2320, mad(-0.008284442126750946f, _2317, (_2314 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2357 = mad(_53, _2344, mad(_52, _2343, (_2342 * _51)));
                            _2358 = mad(_56, _2344, mad(_55, _2343, (_2342 * _54)));
                            _2359 = mad(_59, _2344, mad(_58, _2343, (_2342 * _57)));
                          } else {
                            _2357 = _2342;
                            _2358 = _2343;
                            _2359 = _2344;
                          }
                          float _2369 = exp2(log2(_2357 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2370 = exp2(log2(_2358 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2371 = exp2(log2(_2359 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2536 = exp2(log2((1.0f / ((_2369 * 18.6875f) + 1.0f)) * ((_2369 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2537 = exp2(log2((1.0f / ((_2370 * 18.6875f) + 1.0f)) * ((_2370 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2538 = exp2(log2((1.0f / ((_2371 * 18.6875f) + 1.0f)) * ((_2371 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2416 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1098, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1097, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1096)));
            float _2419 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1098, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1097, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1096)));
            float _2422 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1098, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1097, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1096)));
            float _2441 = exp2(log2(mad(_53, _2422, mad(_52, _2419, (_2416 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2442 = exp2(log2(mad(_56, _2422, mad(_55, _2419, (_2416 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2443 = exp2(log2(mad(_59, _2422, mad(_58, _2419, (_2416 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2536 = exp2(log2((1.0f / ((_2441 * 18.6875f) + 1.0f)) * ((_2441 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2537 = exp2(log2((1.0f / ((_2442 * 18.6875f) + 1.0f)) * ((_2442 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2538 = exp2(log2((1.0f / ((_2443 * 18.6875f) + 1.0f)) * ((_2443 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2490 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1086, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1085, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1084)));
                float _2493 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1086, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1085, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1084)));
                float _2496 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1086, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1085, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1084)));
                _2536 = mad(_53, _2496, mad(_52, _2493, (_2490 * _51)));
                _2537 = mad(_56, _2496, mad(_55, _2493, (_2490 * _54)));
                _2538 = mad(_59, _2496, mad(_58, _2493, (_2490 * _57)));
              } else {
                float _2509 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1110)));
                float _2512 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1110)));
                float _2515 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1112, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1111, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1110)));
                _2536 = exp2(log2(mad(_53, _2515, mad(_52, _2512, (_2509 * _51)))) * cb0_040z);
                _2537 = exp2(log2(mad(_56, _2515, mad(_55, _2512, (_2509 * _54)))) * cb0_040z);
                _2538 = exp2(log2(mad(_59, _2515, mad(_58, _2512, (_2509 * _57)))) * cb0_040z);
              }
            } else {
              _2536 = _1096;
              _2537 = _1097;
              _2538 = _1098;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2536 * 0.9523810148239136f), (_2537 * 0.9523810148239136f), (_2538 * 0.9523810148239136f), 0.0f);
}
