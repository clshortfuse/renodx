#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
//   float cb0_005z : packoffset(c005.z);
//   float cb0_005w : packoffset(c005.w);
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

SamplerState s2 : register(s2);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _28 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _29 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _32 = float((uint)SV_DispatchThreadID.z);
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _119;
  float _120;
  float _121;
  float _645;
  float _681;
  float _692;
  float _756;
  float _935;
  float _946;
  float _957;
  float _1180;
  float _1181;
  float _1182;
  float _1193;
  float _1204;
  float _1386;
  float _1422;
  float _1433;
  float _1472;
  float _1582;
  float _1656;
  float _1730;
  float _1809;
  float _1810;
  float _1811;
  float _1962;
  float _1998;
  float _2009;
  float _2048;
  float _2158;
  float _2232;
  float _2306;
  float _2385;
  float _2386;
  float _2387;
  float _2564;
  float _2565;
  float _2566;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _42 = (output_gamut == 4);
        _53 = select(_42, 1.0f, 1.7050515413284302f);
        _54 = select(_42, 0.0f, -0.6217905879020691f);
        _55 = select(_42, 0.0f, -0.0832584798336029f);
        _56 = select(_42, 0.0f, -0.13025718927383423f);
        _57 = select(_42, 1.0f, 1.1408027410507202f);
        _58 = select(_42, 0.0f, -0.010548528283834457f);
        _59 = select(_42, 0.0f, -0.024003278464078903f);
        _60 = select(_42, 0.0f, -0.1289687603712082f);
        _61 = select(_42, 1.0f, 1.152971863746643f);
      } else {
        _53 = 0.6954522132873535f;
        _54 = 0.14067870378494263f;
        _55 = 0.16386906802654266f;
        _56 = 0.044794563204050064f;
        _57 = 0.8596711158752441f;
        _58 = 0.0955343171954155f;
        _59 = -0.005525882821530104f;
        _60 = 0.004025210160762072f;
        _61 = 1.0015007257461548f;
      }
    } else {
      _53 = 1.02579927444458f;
      _54 = -0.020052503794431686f;
      _55 = -0.0057713985443115234f;
      _56 = -0.0022350111976265907f;
      _57 = 1.0045825242996216f;
      _58 = -0.002352306619286537f;
      _59 = -0.005014004185795784f;
      _60 = -0.025293385609984398f;
      _61 = 1.0304402112960815f;
    }
  } else {
    _53 = 1.379158854484558f;
    _54 = -0.3088507056236267f;
    _55 = -0.07034677267074585f;
    _56 = -0.06933528929948807f;
    _57 = 1.0822921991348267f;
    _58 = -0.012962047010660172f;
    _59 = -0.002159259282052517f;
    _60 = -0.045465391129255295f;
    _61 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _72 = exp2(log2(_28 * 1.0322580337524414f) * 0.012683313339948654f);
    float _73 = exp2(log2(_29 * 1.0322580337524414f) * 0.012683313339948654f);
    float _74 = exp2(log2(_32 * 0.032258063554763794f) * 0.012683313339948654f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _119 = ((exp2((_28 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_29 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_32 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  float _136 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _121, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _120, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _119)));
  float _139 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _121, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _120, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _119)));
  float _142 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _121, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _120, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _119)));
  float _143 = dot(float3(_136, _139, _142), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _147 = (_136 / _143) + -1.0f;
  float _148 = (_139 / _143) + -1.0f;
  float _149 = (_142 / _143) + -1.0f;
  float _161 = (1.0f - exp2(((_143 * _143) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_147, _148, _149), float3(_147, _148, _149)) * -4.0f));
  float _177 = ((mad(-0.06368283927440643f, _142, mad(-0.32929131388664246f, _139, (_136 * 1.370412826538086f))) - _136) * _161) + _136;
  float _178 = ((mad(-0.010861567221581936f, _142, mad(1.0970908403396606f, _139, (_136 * -0.08343426138162613f))) - _139) * _161) + _139;
  float _179 = ((mad(1.203694462776184f, _142, mad(-0.09862564504146576f, _139, (_136 * -0.02579325996339321f))) - _142) * _161) + _142;
#if 1
  float _545, _547, _549;
  ApplyColorCorrection(
      _177, _178, _179,
      _545, _547, _549,
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
  float _180 = dot(float3(_177, _178, _179), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _194 = cb0_019w + cb0_024w;
  float _208 = cb0_018w * cb0_023w;
  float _222 = cb0_017w * cb0_022w;
  float _236 = cb0_016w * cb0_021w;
  float _250 = cb0_015w * cb0_020w;
  float _254 = _177 - _180;
  float _255 = _178 - _180;
  float _256 = _179 - _180;
  float _314 = saturate(_180 / cb0_035z);
  float _318 = (_314 * _314) * (3.0f - (_314 * 2.0f));
  float _319 = 1.0f - _318;
  float _328 = cb0_019w + cb0_034w;
  float _337 = cb0_018w * cb0_033w;
  float _346 = cb0_017w * cb0_032w;
  float _355 = cb0_016w * cb0_031w;
  float _364 = cb0_015w * cb0_030w;
  float _427 = saturate((_180 - cb0_035w) / (cb0_036x - cb0_035w));
  float _431 = (_427 * _427) * (3.0f - (_427 * 2.0f));
  float _440 = cb0_019w + cb0_029w;
  float _449 = cb0_018w * cb0_028w;
  float _458 = cb0_017w * cb0_027w;
  float _467 = cb0_016w * cb0_026w;
  float _476 = cb0_015w * cb0_025w;
  float _534 = _318 - _431;
  float _545 = ((_431 * (((cb0_019x + cb0_034x) + _328) + (((cb0_018x * cb0_033x) * _337) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _355) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _364) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _346)))))) + (_319 * (((cb0_019x + cb0_024x) + _194) + (((cb0_018x * cb0_023x) * _208) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _236) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _250) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _222))))))) + ((((cb0_019x + cb0_029x) + _440) + (((cb0_018x * cb0_028x) * _449) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _467) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _476) * _254) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _458))))) * _534);
  float _547 = ((_431 * (((cb0_019y + cb0_034y) + _328) + (((cb0_018y * cb0_033y) * _337) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _355) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _364) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _346)))))) + (_319 * (((cb0_019y + cb0_024y) + _194) + (((cb0_018y * cb0_023y) * _208) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _236) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _250) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _222))))))) + ((((cb0_019y + cb0_029y) + _440) + (((cb0_018y * cb0_028y) * _449) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _467) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _476) * _255) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _458))))) * _534);
  float _549 = ((_431 * (((cb0_019z + cb0_034z) + _328) + (((cb0_018z * cb0_033z) * _337) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _355) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _364) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _346)))))) + (_319 * (((cb0_019z + cb0_024z) + _194) + (((cb0_018z * cb0_023z) * _208) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _236) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _250) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _222))))))) + ((((cb0_019z + cb0_029z) + _440) + (((cb0_018z * cb0_028z) * _449) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _467) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _476) * _256) + _180)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _458))))) * _534);
#endif

#if 1  // begin FilmToneMap with BlueCorrect
  float _907, _908, _909;
  ApplyFilmToneMapWithBlueCorrect(_545, _547, _549,
                                  _907, _908, _909);
#else
  float _585 = ((mad(0.061360642313957214f, _549, mad(-4.540197551250458e-09f, _547, (_545 * 0.9386394023895264f))) - _545) * cb0_036y) + _545;
  float _586 = ((mad(0.169205904006958f, _549, mad(0.8307942152023315f, _547, (_545 * 6.775371730327606e-08f))) - _547) * cb0_036y) + _547;
  float _587 = (mad(-2.3283064365386963e-10f, _547, (_545 * -9.313225746154785e-10f)) * cb0_036y) + _549;
  float _590 = mad(0.16386905312538147f, _587, mad(0.14067868888378143f, _586, (_585 * 0.6954522132873535f)));
  float _593 = mad(0.0955343246459961f, _587, mad(0.8596711158752441f, _586, (_585 * 0.044794581830501556f)));
  float _596 = mad(1.0015007257461548f, _587, mad(0.004025210160762072f, _586, (_585 * -0.005525882821530104f)));
  float _600 = max(max(_590, _593), _596);
  float _605 = (max(_600, 1.000000013351432e-10f) - max(min(min(_590, _593), _596), 1.000000013351432e-10f)) / max(_600, 0.009999999776482582f);
  float _618 = ((_593 + _590) + _596) + (sqrt((((_596 - _593) * _596) + ((_593 - _590) * _593)) + ((_590 - _596) * _590)) * 1.75f);
  float _619 = _618 * 0.3333333432674408f;
  float _620 = _605 + -0.4000000059604645f;
  float _621 = _620 * 5.0f;
  float _625 = max((1.0f - abs(_620 * 2.5f)), 0.0f);
  float _636 = ((float((int)(((int)(uint)((bool)(_621 > 0.0f))) - ((int)(uint)((bool)(_621 < 0.0f))))) * (1.0f - (_625 * _625))) + 1.0f) * 0.02500000037252903f;
  if (!(_619 <= 0.0533333346247673f)) {
    if (!(_619 >= 0.1599999964237213f)) {
      _645 = (((0.23999999463558197f / _618) + -0.5f) * _636);
    } else {
      _645 = 0.0f;
    }
  } else {
    _645 = _636;
  }
  float _646 = _645 + 1.0f;
  float _647 = _646 * _590;
  float _648 = _646 * _593;
  float _649 = _646 * _596;
  if (!((bool)(_647 == _648) && (bool)(_648 == _649))) {
    float _656 = ((_647 * 2.0f) - _648) - _649;
    float _659 = ((_593 - _596) * 1.7320507764816284f) * _646;
    float _661 = atan(_659 / _656);
    bool _664 = (_656 < 0.0f);
    bool _665 = (_656 == 0.0f);
    bool _666 = (_659 >= 0.0f);
    bool _667 = (_659 < 0.0f);
    float _676 = select((_666 && _665), 90.0f, select((_667 && _665), -90.0f, (select((_667 && _664), (_661 + -3.1415927410125732f), select((_666 && _664), (_661 + 3.1415927410125732f), _661)) * 57.2957763671875f)));
    if (_676 < 0.0f) {
      _681 = (_676 + 360.0f);
    } else {
      _681 = _676;
    }
  } else {
    _681 = 0.0f;
  }
  float _683 = min(max(_681, 0.0f), 360.0f);
  if (_683 < -180.0f) {
    _692 = (_683 + 360.0f);
  } else {
    if (_683 > 180.0f) {
      _692 = (_683 + -360.0f);
    } else {
      _692 = _683;
    }
  }
  float _696 = saturate(1.0f - abs(_692 * 0.014814814552664757f));
  float _700 = (_696 * _696) * (3.0f - (_696 * 2.0f));
  float _706 = ((_700 * _700) * ((_605 * 0.18000000715255737f) * (0.029999999329447746f - _647))) + _647;
  float _716 = max(0.0f, mad(-0.21492856740951538f, _649, mad(-0.2365107536315918f, _648, (_706 * 1.4514392614364624f))));
  float _717 = max(0.0f, mad(-0.09967592358589172f, _649, mad(1.17622971534729f, _648, (_706 * -0.07655377686023712f))));
  float _718 = max(0.0f, mad(0.9977163076400757f, _649, mad(-0.006032449658960104f, _648, (_706 * 0.008316148072481155f))));
  float _719 = dot(float3(_716, _717, _718), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _765 = (lerp(_719, _716, 0.9599999785423279f));
  float _766 = (lerp(_719, _717, 0.9599999785423279f));
  float _767 = (lerp(_719, _718, 0.9599999785423279f));

#if 1
  float _907, _908, _909;
  ApplyFilmicToneMap(_765, _766, _767,
                     _585, _586, _587,
                     _907, _908, _909);
#else
  _765 = log2(_765) * 0.3010300099849701f;
  _766 = log2(_766) * 0.3010300099849701f;
  _767 = log2(_767) * 0.3010300099849701f;

  float _733 = (cb0_037w + 1.0f) - cb0_037y;
  float _736 = cb0_038x + 1.0f;
  float _738 = _736 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _756 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _747 = (cb0_037w + 0.18000000715255737f) / _733;
    _756 = (-0.7447274923324585f - ((log2(_747 / (2.0f - _747)) * 0.3465735912322998f) * (_733 / cb0_037x)));
  }
  float _759 = ((1.0f - cb0_037y) / cb0_037x) - _756;
  float _761 = (cb0_037z / cb0_037x) - _759;
  float _771 = cb0_037x * (_765 + _759);
  float _772 = cb0_037x * (_766 + _759);
  float _773 = cb0_037x * (_767 + _759);
  float _774 = _733 * 2.0f;
  float _776 = (cb0_037x * -2.0f) / _733;
  float _777 = _765 - _756;
  float _778 = _766 - _756;
  float _779 = _767 - _756;
  float _798 = _738 * 2.0f;
  float _800 = (cb0_037x * 2.0f) / _738;
  float _825 = select((_765 < _756), ((_774 / (exp2((_777 * 1.4426950216293335f) * _776) + 1.0f)) - cb0_037w), _771);
  float _826 = select((_766 < _756), ((_774 / (exp2((_778 * 1.4426950216293335f) * _776) + 1.0f)) - cb0_037w), _772);
  float _827 = select((_767 < _756), ((_774 / (exp2((_779 * 1.4426950216293335f) * _776) + 1.0f)) - cb0_037w), _773);
  float _834 = _761 - _756;
  float _838 = saturate(_777 / _834);
  float _839 = saturate(_778 / _834);
  float _840 = saturate(_779 / _834);
  bool _841 = (_761 < _756);
  float _845 = select(_841, (1.0f - _838), _838);
  float _846 = select(_841, (1.0f - _839), _839);
  float _847 = select(_841, (1.0f - _840), _840);
  float _866 = (((_845 * _845) * (select((_765 > _761), (_736 - (_798 / (exp2(((_765 - _761) * 1.4426950216293335f) * _800) + 1.0f))), _771) - _825)) * (3.0f - (_845 * 2.0f))) + _825;
  float _867 = (((_846 * _846) * (select((_766 > _761), (_736 - (_798 / (exp2(((_766 - _761) * 1.4426950216293335f) * _800) + 1.0f))), _772) - _826)) * (3.0f - (_846 * 2.0f))) + _826;
  float _868 = (((_847 * _847) * (select((_767 > _761), (_736 - (_798 / (exp2(((_767 - _761) * 1.4426950216293335f) * _800) + 1.0f))), _773) - _827)) * (3.0f - (_847 * 2.0f))) + _827;
  float _869 = dot(float3(_866, _867, _868), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _889 = (cb0_036w * (max(0.0f, (lerp(_869, _866, 0.9300000071525574f))) - _585)) + _585;
  float _890 = (cb0_036w * (max(0.0f, (lerp(_869, _867, 0.9300000071525574f))) - _586)) + _586;
  float _891 = (cb0_036w * (max(0.0f, (lerp(_869, _868, 0.9300000071525574f))) - _587)) + _587;
  float _907 = ((mad(-0.06537103652954102f, _891, mad(1.451815478503704e-06f, _890, (_889 * 1.065374732017517f))) - _889) * cb0_036y) + _889;
  float _908 = ((mad(-0.20366770029067993f, _891, mad(1.2036634683609009f, _890, (_889 * -2.57161445915699e-07f))) - _890) * cb0_036y) + _890;
  float _909 = ((mad(0.9999996423721313f, _891, mad(2.0954757928848267e-08f, _890, (_889 * 1.862645149230957e-08f))) - _891) * cb0_036y) + _891;
#endif

#endif  // end FilmToneMap with BlueCorrect

  float _922 = ((mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _909, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _908, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _907)))));
  float _923 = ((mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _909, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _908, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _907)))));
  float _924 = ((mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _909, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _908, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _907)))));
#if 1
  float _1075, _1076, _1077;
  Sample3LUTsUpgradeToneMap(
      float3(_922, _923, _924),
      s0, s1, s2,
      t0, t1, t2,
      _1075, _1076, _1077);
#else
  if (_922 < 0.0031306699384003878f) {
    _935 = (_922 * 12.920000076293945f);
  } else {
    _935 = (((pow(_922, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_923 < 0.0031306699384003878f) {
    _946 = (_923 * 12.920000076293945f);
  } else {
    _946 = (((pow(_923, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_924 < 0.0031306699384003878f) {
    _957 = (_924 * 12.920000076293945f);
  } else {
    _957 = (((pow(_924, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _961 = (_946 * 0.9375f) + 0.03125f;
  float _968 = _957 * 15.0f;
  float _969 = floor(_968);
  float _970 = _968 - _969;
  float _972 = (_969 + ((_935 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _975 = t0.SampleLevel(s0, float2(_972, _961), 0.0f);
  float _979 = _972 + 0.0625f;
  float4 _980 = t0.SampleLevel(s0, float2(_979, _961), 0.0f);
  float4 _1002 = t1.SampleLevel(s1, float2(_972, _961), 0.0f);
  float4 _1006 = t1.SampleLevel(s1, float2(_979, _961), 0.0f);
  float4 _1028 = t2.SampleLevel(s2, float2(_972, _961), 0.0f);
  float4 _1032 = t2.SampleLevel(s2, float2(_979, _961), 0.0f);
  float _1051 = max(6.103519990574569e-05f, (((((lerp(_975.x, _980.x, _970))*cb0_005y) + (cb0_005x * _935)) + ((lerp(_1002.x, _1006.x, _970))*cb0_005z)) + ((lerp(_1028.x, _1032.x, _970))*cb0_005w)));
  float _1052 = max(6.103519990574569e-05f, (((((lerp(_975.y, _980.y, _970))*cb0_005y) + (cb0_005x * _946)) + ((lerp(_1002.y, _1006.y, _970))*cb0_005z)) + ((lerp(_1028.y, _1032.y, _970))*cb0_005w)));
  float _1053 = max(6.103519990574569e-05f, (((((lerp(_975.z, _980.z, _970))*cb0_005y) + (cb0_005x * _957)) + ((lerp(_1002.z, _1006.z, _970))*cb0_005z)) + ((lerp(_1028.z, _1032.z, _970))*cb0_005w)));
  float _1075 = select((_1051 > 0.040449999272823334f), exp2(log2((_1051 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1051 * 0.07739938050508499f));
  float _1076 = select((_1052 > 0.040449999272823334f), exp2(log2((_1052 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1052 * 0.07739938050508499f));
  float _1077 = select((_1053 > 0.040449999272823334f), exp2(log2((_1053 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1053 * 0.07739938050508499f));
#endif

  float _1103 = cb0_014x * (((cb0_039y + (cb0_039x * _1075)) * _1075) + cb0_039z);
  float _1104 = cb0_014y * (((cb0_039y + (cb0_039x * _1076)) * _1076) + cb0_039z);
  float _1105 = cb0_014z * (((cb0_039y + (cb0_039x * _1077)) * _1077) + cb0_039z);
  float _1112 = ((cb0_013x - _1103) * cb0_013w) + _1103;
  float _1113 = ((cb0_013y - _1104) * cb0_013w) + _1104;
  float _1114 = ((cb0_013z - _1105) * cb0_013w) + _1105;

  if (GenerateOutput(_1112, _1113, _1114, u0[SV_DispatchThreadID])) {
    return;
  }

  float _1115 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _549, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _547, (_545 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1116 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _549, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _547, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _545)));
  float _1117 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _549, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _547, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _545)));
  float _1124 = ((cb0_013x - _1115) * cb0_013w) + _1115;
  float _1125 = ((cb0_013y - _1116) * cb0_013w) + _1116;
  float _1126 = ((cb0_013z - _1117) * cb0_013w) + _1117;
  float _1138 = exp2(log2(max(0.0f, _1112)) * cb0_040y);
  float _1139 = exp2(log2(max(0.0f, _1113)) * cb0_040y);
  float _1140 = exp2(log2(max(0.0f, _1114)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1163 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1138)));
        float _1166 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1138)));
        float _1169 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1138)));
        _1180 = mad(_55, _1169, mad(_54, _1166, (_1163 * _53)));
        _1181 = mad(_58, _1169, mad(_57, _1166, (_1163 * _56)));
        _1182 = mad(_61, _1169, mad(_60, _1166, (_1163 * _59)));
      } else {
        _1180 = _1138;
        _1181 = _1139;
        _1182 = _1140;
      }
      do {
        if (_1180 < 0.0031306699384003878f) {
          _1193 = (_1180 * 12.920000076293945f);
        } else {
          _1193 = (((pow(_1180, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1181 < 0.0031306699384003878f) {
            _1204 = (_1181 * 12.920000076293945f);
          } else {
            _1204 = (((pow(_1181, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1182 < 0.0031306699384003878f) {
            _2564 = _1193;
            _2565 = _1204;
            _2566 = (_1182 * 12.920000076293945f);
          } else {
            _2564 = _1193;
            _2565 = _1204;
            _2566 = (((pow(_1182, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1231 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1138)));
      float _1234 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1138)));
      float _1237 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1138)));
      float _1247 = max(6.103519990574569e-05f, mad(_55, _1237, mad(_54, _1234, (_1231 * _53))));
      float _1248 = max(6.103519990574569e-05f, mad(_58, _1237, mad(_57, _1234, (_1231 * _56))));
      float _1249 = max(6.103519990574569e-05f, mad(_61, _1237, mad(_60, _1234, (_1231 * _59))));
      _2564 = min((_1247 * 4.5f), ((exp2(log2(max(_1247, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2565 = min((_1248 * 4.5f), ((exp2(log2(max(_1248, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2566 = min((_1249 * 4.5f), ((exp2(log2(max(_1249, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
        _17[0] = cb0_010x;
        _17[1] = cb0_010y;
        _17[2] = cb0_010z;
        _17[3] = cb0_010w;
        _17[4] = cb0_012x;
        _17[5] = cb0_012x;
        _18[0] = cb0_011x;
        _18[1] = cb0_011y;
        _18[2] = cb0_011z;
        _18[3] = cb0_011w;
        _18[4] = cb0_012y;
        _18[5] = cb0_012y;
        float _1326 = cb0_012z * _1124;
        float _1327 = cb0_012z * _1125;
        float _1328 = cb0_012z * _1126;
        float _1331 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1328, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1327, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1326)));
        float _1334 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1328, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1327, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1326)));
        float _1337 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1328, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1327, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1326)));
        float _1341 = max(max(_1331, _1334), _1337);
        float _1346 = (max(_1341, 1.000000013351432e-10f) - max(min(min(_1331, _1334), _1337), 1.000000013351432e-10f)) / max(_1341, 0.009999999776482582f);
        float _1359 = ((_1334 + _1331) + _1337) + (sqrt((((_1337 - _1334) * _1337) + ((_1334 - _1331) * _1334)) + ((_1331 - _1337) * _1331)) * 1.75f);
        float _1360 = _1359 * 0.3333333432674408f;
        float _1361 = _1346 + -0.4000000059604645f;
        float _1362 = _1361 * 5.0f;
        float _1366 = max((1.0f - abs(_1361 * 2.5f)), 0.0f);
        float _1377 = ((float((int)(((int)(uint)((bool)(_1362 > 0.0f))) - ((int)(uint)((bool)(_1362 < 0.0f))))) * (1.0f - (_1366 * _1366))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1360 <= 0.0533333346247673f)) {
            if (!(_1360 >= 0.1599999964237213f)) {
              _1386 = (((0.23999999463558197f / _1359) + -0.5f) * _1377);
            } else {
              _1386 = 0.0f;
            }
          } else {
            _1386 = _1377;
          }
          float _1387 = _1386 + 1.0f;
          float _1388 = _1387 * _1331;
          float _1389 = _1387 * _1334;
          float _1390 = _1387 * _1337;
          do {
            if (!((bool)(_1388 == _1389) && (bool)(_1389 == _1390))) {
              float _1397 = ((_1388 * 2.0f) - _1389) - _1390;
              float _1400 = ((_1334 - _1337) * 1.7320507764816284f) * _1387;
              float _1402 = atan(_1400 / _1397);
              bool _1405 = (_1397 < 0.0f);
              bool _1406 = (_1397 == 0.0f);
              bool _1407 = (_1400 >= 0.0f);
              bool _1408 = (_1400 < 0.0f);
              float _1417 = select((_1407 && _1406), 90.0f, select((_1408 && _1406), -90.0f, (select((_1408 && _1405), (_1402 + -3.1415927410125732f), select((_1407 && _1405), (_1402 + 3.1415927410125732f), _1402)) * 57.2957763671875f)));
              if (_1417 < 0.0f) {
                _1422 = (_1417 + 360.0f);
              } else {
                _1422 = _1417;
              }
            } else {
              _1422 = 0.0f;
            }
            float _1424 = min(max(_1422, 0.0f), 360.0f);
            do {
              if (_1424 < -180.0f) {
                _1433 = (_1424 + 360.0f);
              } else {
                if (_1424 > 180.0f) {
                  _1433 = (_1424 + -360.0f);
                } else {
                  _1433 = _1424;
                }
              }
              do {
                if ((bool)(_1433 > -67.5f) && (bool)(_1433 < 67.5f)) {
                  float _1439 = (_1433 + 67.5f) * 0.029629629105329514f;
                  int _1440 = int(_1439);
                  float _1442 = _1439 - float((int)(_1440));
                  float _1443 = _1442 * _1442;
                  float _1444 = _1443 * _1442;
                  if (_1440 == 3) {
                    _1472 = (((0.1666666716337204f - (_1442 * 0.5f)) + (_1443 * 0.5f)) - (_1444 * 0.1666666716337204f));
                  } else {
                    if (_1440 == 2) {
                      _1472 = ((0.6666666865348816f - _1443) + (_1444 * 0.5f));
                    } else {
                      if (_1440 == 1) {
                        _1472 = (((_1444 * -0.5f) + 0.1666666716337204f) + ((_1443 + _1442) * 0.5f));
                      } else {
                        _1472 = select((_1440 == 0), (_1444 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1472 = 0.0f;
                }
                float _1481 = min(max(((((_1346 * 0.27000001072883606f) * (0.029999999329447746f - _1388)) * _1472) + _1388), 0.0f), 65535.0f);
                float _1482 = min(max(_1389, 0.0f), 65535.0f);
                float _1483 = min(max(_1390, 0.0f), 65535.0f);
                float _1496 = min(max(mad(-0.21492856740951538f, _1483, mad(-0.2365107536315918f, _1482, (_1481 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1497 = min(max(mad(-0.09967592358589172f, _1483, mad(1.17622971534729f, _1482, (_1481 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1498 = min(max(mad(0.9977163076400757f, _1483, mad(-0.006032449658960104f, _1482, (_1481 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1499 = dot(float3(_1496, _1497, _1498), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1510 = log2(max((lerp(_1499, _1496, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1511 = _1510 * 0.3010300099849701f;
                float _1512 = log2(cb0_008x);
                float _1513 = _1512 * 0.3010300099849701f;
                do {
                  if (!(!(_1511 <= _1513))) {
                    _1582 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1520 = log2(cb0_009x);
                    float _1521 = _1520 * 0.3010300099849701f;
                    if ((bool)(_1511 > _1513) && (bool)(_1511 < _1521)) {
                      float _1529 = ((_1510 - _1512) * 0.9030900001525879f) / ((_1520 - _1512) * 0.3010300099849701f);
                      int _1530 = int(_1529);
                      float _1532 = _1529 - float((int)(_1530));
                      float _1534 = _17[_1530];
                      float _1537 = _17[(_1530 + 1)];
                      float _1542 = _1534 * 0.5f;
                      _1582 = dot(float3((_1532 * _1532), _1532, 1.0f), float3(mad((_17[(_1530 + 2)]), 0.5f, mad(_1537, -1.0f, _1542)), (_1537 - _1534), mad(_1537, 0.5f, _1542)));
                    } else {
                      do {
                        if (!(!(_1511 >= _1521))) {
                          float _1551 = log2(cb0_008z);
                          if (_1511 < (_1551 * 0.3010300099849701f)) {
                            float _1559 = ((_1510 - _1520) * 0.9030900001525879f) / ((_1551 - _1520) * 0.3010300099849701f);
                            int _1560 = int(_1559);
                            float _1562 = _1559 - float((int)(_1560));
                            float _1564 = _18[_1560];
                            float _1567 = _18[(_1560 + 1)];
                            float _1572 = _1564 * 0.5f;
                            _1582 = dot(float3((_1562 * _1562), _1562, 1.0f), float3(mad((_18[(_1560 + 2)]), 0.5f, mad(_1567, -1.0f, _1572)), (_1567 - _1564), mad(_1567, 0.5f, _1572)));
                            break;
                          }
                        }
                        _1582 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1586 = log2(max((lerp(_1499, _1497, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1587 = _1586 * 0.3010300099849701f;
                  do {
                    if (!(!(_1587 <= _1513))) {
                      _1656 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1594 = log2(cb0_009x);
                      float _1595 = _1594 * 0.3010300099849701f;
                      if ((bool)(_1587 > _1513) && (bool)(_1587 < _1595)) {
                        float _1603 = ((_1586 - _1512) * 0.9030900001525879f) / ((_1594 - _1512) * 0.3010300099849701f);
                        int _1604 = int(_1603);
                        float _1606 = _1603 - float((int)(_1604));
                        float _1608 = _17[_1604];
                        float _1611 = _17[(_1604 + 1)];
                        float _1616 = _1608 * 0.5f;
                        _1656 = dot(float3((_1606 * _1606), _1606, 1.0f), float3(mad((_17[(_1604 + 2)]), 0.5f, mad(_1611, -1.0f, _1616)), (_1611 - _1608), mad(_1611, 0.5f, _1616)));
                      } else {
                        do {
                          if (!(!(_1587 >= _1595))) {
                            float _1625 = log2(cb0_008z);
                            if (_1587 < (_1625 * 0.3010300099849701f)) {
                              float _1633 = ((_1586 - _1594) * 0.9030900001525879f) / ((_1625 - _1594) * 0.3010300099849701f);
                              int _1634 = int(_1633);
                              float _1636 = _1633 - float((int)(_1634));
                              float _1638 = _18[_1634];
                              float _1641 = _18[(_1634 + 1)];
                              float _1646 = _1638 * 0.5f;
                              _1656 = dot(float3((_1636 * _1636), _1636, 1.0f), float3(mad((_18[(_1634 + 2)]), 0.5f, mad(_1641, -1.0f, _1646)), (_1641 - _1638), mad(_1641, 0.5f, _1646)));
                              break;
                            }
                          }
                          _1656 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1660 = log2(max((lerp(_1499, _1498, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1661 = _1660 * 0.3010300099849701f;
                    do {
                      if (!(!(_1661 <= _1513))) {
                        _1730 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1668 = log2(cb0_009x);
                        float _1669 = _1668 * 0.3010300099849701f;
                        if ((bool)(_1661 > _1513) && (bool)(_1661 < _1669)) {
                          float _1677 = ((_1660 - _1512) * 0.9030900001525879f) / ((_1668 - _1512) * 0.3010300099849701f);
                          int _1678 = int(_1677);
                          float _1680 = _1677 - float((int)(_1678));
                          float _1682 = _17[_1678];
                          float _1685 = _17[(_1678 + 1)];
                          float _1690 = _1682 * 0.5f;
                          _1730 = dot(float3((_1680 * _1680), _1680, 1.0f), float3(mad((_17[(_1678 + 2)]), 0.5f, mad(_1685, -1.0f, _1690)), (_1685 - _1682), mad(_1685, 0.5f, _1690)));
                        } else {
                          do {
                            if (!(!(_1661 >= _1669))) {
                              float _1699 = log2(cb0_008z);
                              if (_1661 < (_1699 * 0.3010300099849701f)) {
                                float _1707 = ((_1660 - _1668) * 0.9030900001525879f) / ((_1699 - _1668) * 0.3010300099849701f);
                                int _1708 = int(_1707);
                                float _1710 = _1707 - float((int)(_1708));
                                float _1712 = _18[_1708];
                                float _1715 = _18[(_1708 + 1)];
                                float _1720 = _1712 * 0.5f;
                                _1730 = dot(float3((_1710 * _1710), _1710, 1.0f), float3(mad((_18[(_1708 + 2)]), 0.5f, mad(_1715, -1.0f, _1720)), (_1715 - _1712), mad(_1715, 0.5f, _1720)));
                                break;
                              }
                            }
                            _1730 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1734 = cb0_008w - cb0_008y;
                      float _1735 = (exp2(_1582 * 3.321928024291992f) - cb0_008y) / _1734;
                      float _1737 = (exp2(_1656 * 3.321928024291992f) - cb0_008y) / _1734;
                      float _1739 = (exp2(_1730 * 3.321928024291992f) - cb0_008y) / _1734;
                      float _1742 = mad(0.15618768334388733f, _1739, mad(0.13400420546531677f, _1737, (_1735 * 0.6624541878700256f)));
                      float _1745 = mad(0.053689517080783844f, _1739, mad(0.6740817427635193f, _1737, (_1735 * 0.2722287178039551f)));
                      float _1748 = mad(1.0103391408920288f, _1739, mad(0.00406073359772563f, _1737, (_1735 * -0.005574649665504694f)));
                      float _1761 = min(max(mad(-0.23642469942569733f, _1748, mad(-0.32480329275131226f, _1745, (_1742 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1762 = min(max(mad(0.016756348311901093f, _1748, mad(1.6153316497802734f, _1745, (_1742 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1763 = min(max(mad(0.9883948564529419f, _1748, mad(-0.008284442126750946f, _1745, (_1742 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1766 = mad(0.15618768334388733f, _1763, mad(0.13400420546531677f, _1762, (_1761 * 0.6624541878700256f)));
                      float _1769 = mad(0.053689517080783844f, _1763, mad(0.6740817427635193f, _1762, (_1761 * 0.2722287178039551f)));
                      float _1772 = mad(1.0103391408920288f, _1763, mad(0.00406073359772563f, _1762, (_1761 * -0.005574649665504694f)));
                      float _1794 = min(max((min(max(mad(-0.23642469942569733f, _1772, mad(-0.32480329275131226f, _1769, (_1766 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1795 = min(max((min(max(mad(0.016756348311901093f, _1772, mad(1.6153316497802734f, _1769, (_1766 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1796 = min(max((min(max(mad(0.9883948564529419f, _1772, mad(-0.008284442126750946f, _1769, (_1766 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1809 = mad(_55, _1796, mad(_54, _1795, (_1794 * _53)));
                          _1810 = mad(_58, _1796, mad(_57, _1795, (_1794 * _56)));
                          _1811 = mad(_61, _1796, mad(_60, _1795, (_1794 * _59)));
                        } else {
                          _1809 = _1794;
                          _1810 = _1795;
                          _1811 = _1796;
                        }
                        float _1821 = exp2(log2(_1809 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1822 = exp2(log2(_1810 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1823 = exp2(log2(_1811 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2564 = exp2(log2((1.0f / ((_1821 * 18.6875f) + 1.0f)) * ((_1821 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2565 = exp2(log2((1.0f / ((_1822 * 18.6875f) + 1.0f)) * ((_1822 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2566 = exp2(log2((1.0f / ((_1823 * 18.6875f) + 1.0f)) * ((_1823 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1902 = cb0_012z * _1124;
          float _1903 = cb0_012z * _1125;
          float _1904 = cb0_012z * _1126;
          float _1907 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1904, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1903, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1902)));
          float _1910 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1904, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1903, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1902)));
          float _1913 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1904, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1903, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1902)));
          float _1917 = max(max(_1907, _1910), _1913);
          float _1922 = (max(_1917, 1.000000013351432e-10f) - max(min(min(_1907, _1910), _1913), 1.000000013351432e-10f)) / max(_1917, 0.009999999776482582f);
          float _1935 = ((_1910 + _1907) + _1913) + (sqrt((((_1913 - _1910) * _1913) + ((_1910 - _1907) * _1910)) + ((_1907 - _1913) * _1907)) * 1.75f);
          float _1936 = _1935 * 0.3333333432674408f;
          float _1937 = _1922 + -0.4000000059604645f;
          float _1938 = _1937 * 5.0f;
          float _1942 = max((1.0f - abs(_1937 * 2.5f)), 0.0f);
          float _1953 = ((float((int)(((int)(uint)((bool)(_1938 > 0.0f))) - ((int)(uint)((bool)(_1938 < 0.0f))))) * (1.0f - (_1942 * _1942))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1936 <= 0.0533333346247673f)) {
              if (!(_1936 >= 0.1599999964237213f)) {
                _1962 = (((0.23999999463558197f / _1935) + -0.5f) * _1953);
              } else {
                _1962 = 0.0f;
              }
            } else {
              _1962 = _1953;
            }
            float _1963 = _1962 + 1.0f;
            float _1964 = _1963 * _1907;
            float _1965 = _1963 * _1910;
            float _1966 = _1963 * _1913;
            do {
              if (!((bool)(_1964 == _1965) && (bool)(_1965 == _1966))) {
                float _1973 = ((_1964 * 2.0f) - _1965) - _1966;
                float _1976 = ((_1910 - _1913) * 1.7320507764816284f) * _1963;
                float _1978 = atan(_1976 / _1973);
                bool _1981 = (_1973 < 0.0f);
                bool _1982 = (_1973 == 0.0f);
                bool _1983 = (_1976 >= 0.0f);
                bool _1984 = (_1976 < 0.0f);
                float _1993 = select((_1983 && _1982), 90.0f, select((_1984 && _1982), -90.0f, (select((_1984 && _1981), (_1978 + -3.1415927410125732f), select((_1983 && _1981), (_1978 + 3.1415927410125732f), _1978)) * 57.2957763671875f)));
                if (_1993 < 0.0f) {
                  _1998 = (_1993 + 360.0f);
                } else {
                  _1998 = _1993;
                }
              } else {
                _1998 = 0.0f;
              }
              float _2000 = min(max(_1998, 0.0f), 360.0f);
              do {
                if (_2000 < -180.0f) {
                  _2009 = (_2000 + 360.0f);
                } else {
                  if (_2000 > 180.0f) {
                    _2009 = (_2000 + -360.0f);
                  } else {
                    _2009 = _2000;
                  }
                }
                do {
                  if ((bool)(_2009 > -67.5f) && (bool)(_2009 < 67.5f)) {
                    float _2015 = (_2009 + 67.5f) * 0.029629629105329514f;
                    int _2016 = int(_2015);
                    float _2018 = _2015 - float((int)(_2016));
                    float _2019 = _2018 * _2018;
                    float _2020 = _2019 * _2018;
                    if (_2016 == 3) {
                      _2048 = (((0.1666666716337204f - (_2018 * 0.5f)) + (_2019 * 0.5f)) - (_2020 * 0.1666666716337204f));
                    } else {
                      if (_2016 == 2) {
                        _2048 = ((0.6666666865348816f - _2019) + (_2020 * 0.5f));
                      } else {
                        if (_2016 == 1) {
                          _2048 = (((_2020 * -0.5f) + 0.1666666716337204f) + ((_2019 + _2018) * 0.5f));
                        } else {
                          _2048 = select((_2016 == 0), (_2020 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2048 = 0.0f;
                  }
                  float _2057 = min(max(((((_1922 * 0.27000001072883606f) * (0.029999999329447746f - _1964)) * _2048) + _1964), 0.0f), 65535.0f);
                  float _2058 = min(max(_1965, 0.0f), 65535.0f);
                  float _2059 = min(max(_1966, 0.0f), 65535.0f);
                  float _2072 = min(max(mad(-0.21492856740951538f, _2059, mad(-0.2365107536315918f, _2058, (_2057 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2073 = min(max(mad(-0.09967592358589172f, _2059, mad(1.17622971534729f, _2058, (_2057 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2074 = min(max(mad(0.9977163076400757f, _2059, mad(-0.006032449658960104f, _2058, (_2057 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2075 = dot(float3(_2072, _2073, _2074), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2086 = log2(max((lerp(_2075, _2072, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2087 = _2086 * 0.3010300099849701f;
                  float _2088 = log2(cb0_008x);
                  float _2089 = _2088 * 0.3010300099849701f;
                  do {
                    if (!(!(_2087 <= _2089))) {
                      _2158 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2096 = log2(cb0_009x);
                      float _2097 = _2096 * 0.3010300099849701f;
                      if ((bool)(_2087 > _2089) && (bool)(_2087 < _2097)) {
                        float _2105 = ((_2086 - _2088) * 0.9030900001525879f) / ((_2096 - _2088) * 0.3010300099849701f);
                        int _2106 = int(_2105);
                        float _2108 = _2105 - float((int)(_2106));
                        float _2110 = _15[_2106];
                        float _2113 = _15[(_2106 + 1)];
                        float _2118 = _2110 * 0.5f;
                        _2158 = dot(float3((_2108 * _2108), _2108, 1.0f), float3(mad((_15[(_2106 + 2)]), 0.5f, mad(_2113, -1.0f, _2118)), (_2113 - _2110), mad(_2113, 0.5f, _2118)));
                      } else {
                        do {
                          if (!(!(_2087 >= _2097))) {
                            float _2127 = log2(cb0_008z);
                            if (_2087 < (_2127 * 0.3010300099849701f)) {
                              float _2135 = ((_2086 - _2096) * 0.9030900001525879f) / ((_2127 - _2096) * 0.3010300099849701f);
                              int _2136 = int(_2135);
                              float _2138 = _2135 - float((int)(_2136));
                              float _2140 = _16[_2136];
                              float _2143 = _16[(_2136 + 1)];
                              float _2148 = _2140 * 0.5f;
                              _2158 = dot(float3((_2138 * _2138), _2138, 1.0f), float3(mad((_16[(_2136 + 2)]), 0.5f, mad(_2143, -1.0f, _2148)), (_2143 - _2140), mad(_2143, 0.5f, _2148)));
                              break;
                            }
                          }
                          _2158 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2162 = log2(max((lerp(_2075, _2073, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2163 = _2162 * 0.3010300099849701f;
                    do {
                      if (!(!(_2163 <= _2089))) {
                        _2232 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2170 = log2(cb0_009x);
                        float _2171 = _2170 * 0.3010300099849701f;
                        if ((bool)(_2163 > _2089) && (bool)(_2163 < _2171)) {
                          float _2179 = ((_2162 - _2088) * 0.9030900001525879f) / ((_2170 - _2088) * 0.3010300099849701f);
                          int _2180 = int(_2179);
                          float _2182 = _2179 - float((int)(_2180));
                          float _2184 = _15[_2180];
                          float _2187 = _15[(_2180 + 1)];
                          float _2192 = _2184 * 0.5f;
                          _2232 = dot(float3((_2182 * _2182), _2182, 1.0f), float3(mad((_15[(_2180 + 2)]), 0.5f, mad(_2187, -1.0f, _2192)), (_2187 - _2184), mad(_2187, 0.5f, _2192)));
                        } else {
                          do {
                            if (!(!(_2163 >= _2171))) {
                              float _2201 = log2(cb0_008z);
                              if (_2163 < (_2201 * 0.3010300099849701f)) {
                                float _2209 = ((_2162 - _2170) * 0.9030900001525879f) / ((_2201 - _2170) * 0.3010300099849701f);
                                int _2210 = int(_2209);
                                float _2212 = _2209 - float((int)(_2210));
                                float _2214 = _16[_2210];
                                float _2217 = _16[(_2210 + 1)];
                                float _2222 = _2214 * 0.5f;
                                _2232 = dot(float3((_2212 * _2212), _2212, 1.0f), float3(mad((_16[(_2210 + 2)]), 0.5f, mad(_2217, -1.0f, _2222)), (_2217 - _2214), mad(_2217, 0.5f, _2222)));
                                break;
                              }
                            }
                            _2232 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2236 = log2(max((lerp(_2075, _2074, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2237 = _2236 * 0.3010300099849701f;
                      do {
                        if (!(!(_2237 <= _2089))) {
                          _2306 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2244 = log2(cb0_009x);
                          float _2245 = _2244 * 0.3010300099849701f;
                          if ((bool)(_2237 > _2089) && (bool)(_2237 < _2245)) {
                            float _2253 = ((_2236 - _2088) * 0.9030900001525879f) / ((_2244 - _2088) * 0.3010300099849701f);
                            int _2254 = int(_2253);
                            float _2256 = _2253 - float((int)(_2254));
                            float _2258 = _15[_2254];
                            float _2261 = _15[(_2254 + 1)];
                            float _2266 = _2258 * 0.5f;
                            _2306 = dot(float3((_2256 * _2256), _2256, 1.0f), float3(mad((_15[(_2254 + 2)]), 0.5f, mad(_2261, -1.0f, _2266)), (_2261 - _2258), mad(_2261, 0.5f, _2266)));
                          } else {
                            do {
                              if (!(!(_2237 >= _2245))) {
                                float _2275 = log2(cb0_008z);
                                if (_2237 < (_2275 * 0.3010300099849701f)) {
                                  float _2283 = ((_2236 - _2244) * 0.9030900001525879f) / ((_2275 - _2244) * 0.3010300099849701f);
                                  int _2284 = int(_2283);
                                  float _2286 = _2283 - float((int)(_2284));
                                  float _2288 = _16[_2284];
                                  float _2291 = _16[(_2284 + 1)];
                                  float _2296 = _2288 * 0.5f;
                                  _2306 = dot(float3((_2286 * _2286), _2286, 1.0f), float3(mad((_16[(_2284 + 2)]), 0.5f, mad(_2291, -1.0f, _2296)), (_2291 - _2288), mad(_2291, 0.5f, _2296)));
                                  break;
                                }
                              }
                              _2306 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2310 = cb0_008w - cb0_008y;
                        float _2311 = (exp2(_2158 * 3.321928024291992f) - cb0_008y) / _2310;
                        float _2313 = (exp2(_2232 * 3.321928024291992f) - cb0_008y) / _2310;
                        float _2315 = (exp2(_2306 * 3.321928024291992f) - cb0_008y) / _2310;
                        float _2318 = mad(0.15618768334388733f, _2315, mad(0.13400420546531677f, _2313, (_2311 * 0.6624541878700256f)));
                        float _2321 = mad(0.053689517080783844f, _2315, mad(0.6740817427635193f, _2313, (_2311 * 0.2722287178039551f)));
                        float _2324 = mad(1.0103391408920288f, _2315, mad(0.00406073359772563f, _2313, (_2311 * -0.005574649665504694f)));
                        float _2337 = min(max(mad(-0.23642469942569733f, _2324, mad(-0.32480329275131226f, _2321, (_2318 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2338 = min(max(mad(0.016756348311901093f, _2324, mad(1.6153316497802734f, _2321, (_2318 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2339 = min(max(mad(0.9883948564529419f, _2324, mad(-0.008284442126750946f, _2321, (_2318 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2342 = mad(0.15618768334388733f, _2339, mad(0.13400420546531677f, _2338, (_2337 * 0.6624541878700256f)));
                        float _2345 = mad(0.053689517080783844f, _2339, mad(0.6740817427635193f, _2338, (_2337 * 0.2722287178039551f)));
                        float _2348 = mad(1.0103391408920288f, _2339, mad(0.00406073359772563f, _2338, (_2337 * -0.005574649665504694f)));
                        float _2370 = min(max((min(max(mad(-0.23642469942569733f, _2348, mad(-0.32480329275131226f, _2345, (_2342 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2371 = min(max((min(max(mad(0.016756348311901093f, _2348, mad(1.6153316497802734f, _2345, (_2342 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2372 = min(max((min(max(mad(0.9883948564529419f, _2348, mad(-0.008284442126750946f, _2345, (_2342 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2385 = mad(_55, _2372, mad(_54, _2371, (_2370 * _53)));
                            _2386 = mad(_58, _2372, mad(_57, _2371, (_2370 * _56)));
                            _2387 = mad(_61, _2372, mad(_60, _2371, (_2370 * _59)));
                          } else {
                            _2385 = _2370;
                            _2386 = _2371;
                            _2387 = _2372;
                          }
                          float _2397 = exp2(log2(_2385 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2398 = exp2(log2(_2386 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2399 = exp2(log2(_2387 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2564 = exp2(log2((1.0f / ((_2397 * 18.6875f) + 1.0f)) * ((_2397 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2565 = exp2(log2((1.0f / ((_2398 * 18.6875f) + 1.0f)) * ((_2398 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2566 = exp2(log2((1.0f / ((_2399 * 18.6875f) + 1.0f)) * ((_2399 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2444 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1126, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1125, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1124)));
            float _2447 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1126, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1125, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1124)));
            float _2450 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1126, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1125, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1124)));
            float _2469 = exp2(log2(mad(_55, _2450, mad(_54, _2447, (_2444 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2470 = exp2(log2(mad(_58, _2450, mad(_57, _2447, (_2444 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2471 = exp2(log2(mad(_61, _2450, mad(_60, _2447, (_2444 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2564 = exp2(log2((1.0f / ((_2469 * 18.6875f) + 1.0f)) * ((_2469 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2565 = exp2(log2((1.0f / ((_2470 * 18.6875f) + 1.0f)) * ((_2470 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2566 = exp2(log2((1.0f / ((_2471 * 18.6875f) + 1.0f)) * ((_2471 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2518 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1114, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1113, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1112)));
                float _2521 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1114, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1113, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1112)));
                float _2524 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1114, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1113, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1112)));
                _2564 = mad(_55, _2524, mad(_54, _2521, (_2518 * _53)));
                _2565 = mad(_58, _2524, mad(_57, _2521, (_2518 * _56)));
                _2566 = mad(_61, _2524, mad(_60, _2521, (_2518 * _59)));
              } else {
                float _2537 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1138)));
                float _2540 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1138)));
                float _2543 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1140, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1139, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1138)));
                _2564 = exp2(log2(mad(_55, _2543, mad(_54, _2540, (_2537 * _53)))) * cb0_040z);
                _2565 = exp2(log2(mad(_58, _2543, mad(_57, _2540, (_2537 * _56)))) * cb0_040z);
                _2566 = exp2(log2(mad(_61, _2543, mad(_60, _2540, (_2537 * _59)))) * cb0_040z);
              }
            } else {
              _2564 = _1124;
              _2565 = _1125;
              _2566 = _1126;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2564 * 0.9523810148239136f), (_2565 * 0.9523810148239136f), (_2566 * 0.9523810148239136f), 0.0f);
}
