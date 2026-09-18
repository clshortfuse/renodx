#include "../lutbuilderoutput.hlsli"

// The Expanse: Osiris Reborn beta

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
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
  float cb0_035x : packoffset(c035.x);
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
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  uint cb0_041x : packoffset(c041.x);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _16 = 0.5f / cb0_035x;
  float _21 = cb0_035x + -1.0f;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _570;
  float _603;
  float _617;
  float _681;
  float _872;
  float _883;
  float _894;
  float _1109;
  float _1110;
  float _1111;
  float _1122;
  float _1133;
  float _1144;
  if (!((uint)(cb0_041x) == 1)) {
    if (!((uint)(cb0_041x) == 2)) {
      if (!((uint)(cb0_041x) == 3)) {
        bool _34 = ((uint)(cb0_041x) == 4);
        _45 = select(_34, 1.0f, 1.705051064491272f);
        _46 = select(_34, 0.0f, -0.6217921376228333f);
        _47 = select(_34, 0.0f, -0.0832589864730835f);
        _48 = select(_34, 0.0f, -0.13025647401809692f);
        _49 = select(_34, 1.0f, 1.140804648399353f);
        _50 = select(_34, 0.0f, -0.010548308491706848f);
        _51 = select(_34, 0.0f, -0.024003351107239723f);
        _52 = select(_34, 0.0f, -0.1289689838886261f);
        _53 = select(_34, 1.0f, 1.1529725790023804f);
      } else {
        _45 = 0.6954522132873535f;
        _46 = 0.14067870378494263f;
        _47 = 0.16386906802654266f;
        _48 = 0.044794563204050064f;
        _49 = 0.8596711158752441f;
        _50 = 0.0955343171954155f;
        _51 = -0.005525882821530104f;
        _52 = 0.004025210160762072f;
        _53 = 1.0015007257461548f;
      }
    } else {
      _45 = 1.0258246660232544f;
      _46 = -0.020053181797266006f;
      _47 = -0.005771636962890625f;
      _48 = -0.002234415616840124f;
      _49 = 1.0045864582061768f;
      _50 = -0.002352118492126465f;
      _51 = -0.005013350863009691f;
      _52 = -0.025290070101618767f;
      _53 = 1.0303035974502563f;
    }
  } else {
    _45 = 1.3792141675949097f;
    _46 = -0.30886411666870117f;
    _47 = -0.0703500509262085f;
    _48 = -0.06933490186929703f;
    _49 = 1.08229660987854f;
    _50 = -0.012961871922016144f;
    _51 = -0.0021590073592960835f;
    _52 = -0.0454593189060688f;
    _53 = 1.0476183891296387f;
  }
  float _66 = (exp2((((cb0_035x * (TEXCOORD.x - _16)) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _67 = (exp2((((cb0_035x * (TEXCOORD.y - _16)) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _68 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _21) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _83 = mad((WorkingColorSpace_128[0].z), _68, mad((WorkingColorSpace_128[0].y), _67, ((WorkingColorSpace_128[0].x) * _66)));
  float _86 = mad((WorkingColorSpace_128[1].z), _68, mad((WorkingColorSpace_128[1].y), _67, ((WorkingColorSpace_128[1].x) * _66)));
  float _89 = mad((WorkingColorSpace_128[2].z), _68, mad((WorkingColorSpace_128[2].y), _67, ((WorkingColorSpace_128[2].x) * _66)));
  float _90 = dot(float3(_83, _86, _89), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _94 = (_83 / _90) + -1.0f;
  float _95 = (_86 / _90) + -1.0f;
  float _96 = (_89 / _90) + -1.0f;

  // float _108 = (1.0f - exp2(((_90 * _90) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_94, _95, _96), float3(_94, _95, _96)) * -4.0f));
  float _108 = (1.0f - exp2(((_90 * _90) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_94, _95, _96), float3(_94, _95, _96)) * -4.0f));

  float _124 = ((mad(-0.06368321925401688f, _89, mad(-0.3292922377586365f, _86, (_83 * 1.3704125881195068f))) - _83) * _108) + _83;
  float _125 = ((mad(-0.010861365124583244f, _89, mad(1.0970927476882935f, _86, (_83 * -0.08343357592821121f))) - _86) * _108) + _86;
  float _126 = ((mad(1.2036951780319214f, _89, mad(-0.09862580895423889f, _86, (_83 * -0.02579331398010254f))) - _89) * _108) + _89;
  float _127 = dot(float3(_124, _125, _126), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _141 = cb0_019w + cb0_024w;
  float _155 = cb0_018w * cb0_023w;
  float _169 = cb0_017w * cb0_022w;
  float _183 = cb0_016w * cb0_021w;
  float _197 = cb0_015w * cb0_020w;
  float _201 = _124 - _127;
  float _202 = _125 - _127;
  float _203 = _126 - _127;
  float _260 = saturate(_127 / cb0_035w);
  float _264 = (_260 * _260) * (3.0f - (_260 * 2.0f));
  float _265 = 1.0f - _264;
  float _274 = cb0_019w + cb0_034w;
  float _283 = cb0_018w * cb0_033w;
  float _292 = cb0_017w * cb0_032w;
  float _301 = cb0_016w * cb0_031w;
  float _310 = cb0_015w * cb0_030w;
  float _373 = saturate((_127 - cb0_036x) / (cb0_036y - cb0_036x));
  float _377 = (_373 * _373) * (3.0f - (_373 * 2.0f));
  float _386 = cb0_019w + cb0_029w;
  float _395 = cb0_018w * cb0_028w;
  float _404 = cb0_017w * cb0_027w;
  float _413 = cb0_016w * cb0_026w;
  float _422 = cb0_015w * cb0_025w;
  float _480 = _264 - _377;
  float _491 = ((_377 * (((cb0_019x + cb0_034x) + _274) + (((cb0_018x * cb0_033x) * _283) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _301) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _310) * _201) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _292)))))) + (_265 * (((cb0_019x + cb0_024x) + _141) + (((cb0_018x * cb0_023x) * _155) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _183) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _197) * _201) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _169))))))) + ((((cb0_019x + cb0_029x) + _386) + (((cb0_018x * cb0_028x) * _395) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _413) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _422) * _201) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _404))))) * _480);
  float _493 = ((_377 * (((cb0_019y + cb0_034y) + _274) + (((cb0_018y * cb0_033y) * _283) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _301) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _310) * _202) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _292)))))) + (_265 * (((cb0_019y + cb0_024y) + _141) + (((cb0_018y * cb0_023y) * _155) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _183) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _197) * _202) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _169))))))) + ((((cb0_019y + cb0_029y) + _386) + (((cb0_018y * cb0_028y) * _395) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _413) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _422) * _202) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _404))))) * _480);
  float _495 = ((_377 * (((cb0_019z + cb0_034z) + _274) + (((cb0_018z * cb0_033z) * _283) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _301) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _310) * _203) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _292)))))) + (_265 * (((cb0_019z + cb0_024z) + _141) + (((cb0_018z * cb0_023z) * _155) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _183) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _197) * _203) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _169))))))) + ((((cb0_019z + cb0_029z) + _386) + (((cb0_018z * cb0_028z) * _395) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _413) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _422) * _203) + _127)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _404))))) * _480);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_038x;
  cb_config.ue_filmtoe = cb0_037z;
  cb_config.ue_filmshoulder = cb0_037w;
  cb_config.ue_filmslope = cb0_037y;
  cb_config.ue_filmwhiteclip = cb0_038y;
  cb_config.ue_tonecurveammount = cb0_037x;
  cb_config.ue_mappingpolynomial = float3(cb0_039x, cb0_039y, cb0_039z);
  cb_config.ue_overlaycolor = float4(cb0_013x, cb0_013y, cb0_013z, cb0_013w);
  cb_config.ue_bluecorrection = cb0_036z;
  cb_config.ue_colorscale = float3(cb0_014x, cb0_014y, cb0_014z);
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyzw is used

  SV_Target = ProcessLutbuilder(float3(_491, _493, _495), s0, s1, s2, t0, t1, t2, cb_config, SV_Target, 0u);
  return SV_Target;

  float _510 = ((mad(0.061360642313957214f, _495, mad(-4.540197551250458e-09f, _493, (_491 * 0.9386394023895264f))) - _491) * cb0_036z) + _491;
  float _511 = ((mad(0.169205904006958f, _495, mad(0.8307942152023315f, _493, (_491 * 6.775371730327606e-08f))) - _493) * cb0_036z) + _493;
  float _512 = (mad(-2.3283064365386963e-10f, _493, (_491 * -9.313225746154785e-10f)) * cb0_036z) + _495;
  float _515 = mad(0.16386905312538147f, _512, mad(0.14067868888378143f, _511, (_510 * 0.6954522132873535f)));
  float _518 = mad(0.0955343246459961f, _512, mad(0.8596711158752441f, _511, (_510 * 0.044794581830501556f)));
  float _521 = mad(1.0015007257461548f, _512, mad(0.004025210160762072f, _511, (_510 * -0.005525882821530104f)));
  float _525 = max(max(_515, _518), _521);
  float _530 = (max(_525, 1.000000013351432e-10f) - max(min(min(_515, _518), _521), 1.000000013351432e-10f)) / max(_525, 0.009999999776482582f);
  float _543 = ((_518 + _515) + _521) + (sqrt((((_521 - _518) * _521) + ((_518 - _515) * _518)) + ((_515 - _521) * _515)) * 1.75f);
  float _544 = _543 * 0.3333333432674408f;
  float _545 = _530 + -0.4000000059604645f;
  float _546 = _545 * 5.0f;
  float _550 = max((1.0f - abs(_545 * 2.5f)), 0.0f);
  float _561 = ((float(((int)(uint)((bool)(_546 > 0.0f))) - ((int)(uint)((bool)(_546 < 0.0f)))) * (1.0f - (_550 * _550))) + 1.0f) * 0.02500000037252903f;
  if (!(_544 <= 0.0533333346247673f)) {
    if (!(_544 >= 0.1599999964237213f)) {
      _570 = (((0.23999999463558197f / _543) + -0.5f) * _561);
    } else {
      _570 = 0.0f;
    }
  } else {
    _570 = _561;
  }
  float _571 = _570 + 1.0f;
  float _572 = _571 * _515;
  float _573 = _571 * _518;
  float _574 = _571 * _521;
  if (!((bool)(_572 == _573) && (bool)(_573 == _574))) {
    float _581 = ((_572 * 2.0f) - _573) - _574;
    float _584 = ((_518 - _521) * 1.7320507764816284f) * _571;
    float _586 = atan(_584 / _581);
    bool _589 = (_581 < 0.0f);
    bool _590 = (_581 == 0.0f);
    bool _591 = (_584 >= 0.0f);
    bool _592 = (_584 < 0.0f);
    _603 = select((_591 && _590), 90.0f, select((_592 && _590), -90.0f, (select((_592 && _589), (_586 + -3.1415927410125732f), select((_591 && _589), (_586 + 3.1415927410125732f), _586)) * 57.2957763671875f)));
  } else {
    _603 = 0.0f;
  }
  float _608 = min(max(select((_603 < 0.0f), (_603 + 360.0f), _603), 0.0f), 360.0f);
  if (_608 < -180.0f) {
    _617 = (_608 + 360.0f);
  } else {
    if (_608 > 180.0f) {
      _617 = (_608 + -360.0f);
    } else {
      _617 = _608;
    }
  }
  float _621 = saturate(1.0f - abs(_617 * 0.014814814552664757f));
  float _625 = (_621 * _621) * (3.0f - (_621 * 2.0f));
  float _631 = ((_625 * _625) * ((_530 * 0.18000000715255737f) * (0.029999999329447746f - _572))) + _572;
  float _641 = max(0.0f, mad(-0.21492856740951538f, _574, mad(-0.2365107536315918f, _573, (_631 * 1.4514392614364624f))));
  float _642 = max(0.0f, mad(-0.09967592358589172f, _574, mad(1.17622971534729f, _573, (_631 * -0.07655377686023712f))));
  float _643 = max(0.0f, mad(0.9977163076400757f, _574, mad(-0.006032449658960104f, _573, (_631 * 0.008316148072481155f))));
  float _644 = dot(float3(_641, _642, _643), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _659 = (cb0_038x + 1.0f) - cb0_037z;
  float _661 = cb0_038y + 1.0f;
  float _663 = _661 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _681 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _672 = (cb0_038x + 0.18000000715255737f) / _659;
    _681 = (-0.7447274923324585f - ((log2(_672 / (2.0f - _672)) * 0.3465735912322998f) * (_659 / cb0_037y)));
  }
  float _684 = ((1.0f - cb0_037z) / cb0_037y) - _681;
  float _686 = (cb0_037w / cb0_037y) - _684;
  float _690 = log2(lerp(_644, _641, 0.9599999785423279f)) * 0.3010300099849701f;
  float _691 = log2(lerp(_644, _642, 0.9599999785423279f)) * 0.3010300099849701f;
  float _692 = log2(lerp(_644, _643, 0.9599999785423279f)) * 0.3010300099849701f;
  float _696 = cb0_037y * (_690 + _684);
  float _697 = cb0_037y * (_691 + _684);
  float _698 = cb0_037y * (_692 + _684);
  float _699 = _659 * 2.0f;
  float _701 = (cb0_037y * -2.0f) / _659;
  float _702 = _690 - _681;
  float _703 = _691 - _681;
  float _704 = _692 - _681;
  float _723 = _663 * 2.0f;
  float _725 = (cb0_037y * 2.0f) / _663;
  float _750 = select((_690 < _681), ((_699 / (exp2((_702 * 1.4426950216293335f) * _701) + 1.0f)) - cb0_038x), _696);
  float _751 = select((_691 < _681), ((_699 / (exp2((_703 * 1.4426950216293335f) * _701) + 1.0f)) - cb0_038x), _697);
  float _752 = select((_692 < _681), ((_699 / (exp2((_704 * 1.4426950216293335f) * _701) + 1.0f)) - cb0_038x), _698);
  float _759 = _686 - _681;
  float _763 = saturate(_702 / _759);
  float _764 = saturate(_703 / _759);
  float _765 = saturate(_704 / _759);
  bool _766 = (_686 < _681);
  float _770 = select(_766, (1.0f - _763), _763);
  float _771 = select(_766, (1.0f - _764), _764);
  float _772 = select(_766, (1.0f - _765), _765);
  float _791 = (((_770 * _770) * (select((_690 > _686), (_661 - (_723 / (exp2(((_690 - _686) * 1.4426950216293335f) * _725) + 1.0f))), _696) - _750)) * (3.0f - (_770 * 2.0f))) + _750;
  float _792 = (((_771 * _771) * (select((_691 > _686), (_661 - (_723 / (exp2(((_691 - _686) * 1.4426950216293335f) * _725) + 1.0f))), _697) - _751)) * (3.0f - (_771 * 2.0f))) + _751;
  float _793 = (((_772 * _772) * (select((_692 > _686), (_661 - (_723 / (exp2(((_692 - _686) * 1.4426950216293335f) * _725) + 1.0f))), _698) - _752)) * (3.0f - (_772 * 2.0f))) + _752;
  float _794 = dot(float3(_791, _792, _793), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _814 = (cb0_037x * (max(0.0f, (lerp(_794, _791, 0.9300000071525574f))) - _510)) + _510;
  float _815 = (cb0_037x * (max(0.0f, (lerp(_794, _792, 0.9300000071525574f))) - _511)) + _511;
  float _816 = (cb0_037x * (max(0.0f, (lerp(_794, _793, 0.9300000071525574f))) - _512)) + _512;
  float _832 = ((mad(-0.06537103652954102f, _816, mad(1.451815478503704e-06f, _815, (_814 * 1.065374732017517f))) - _814) * cb0_036z) + _814;
  float _833 = ((mad(-0.20366770029067993f, _816, mad(1.2036634683609009f, _815, (_814 * -2.57161445915699e-07f))) - _815) * cb0_036z) + _815;
  float _834 = ((mad(0.9999996423721313f, _816, mad(2.0954757928848267e-08f, _815, (_814 * 1.862645149230957e-08f))) - _816) * cb0_036z) + _816;
  float _859 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _834, mad((WorkingColorSpace_192[0].y), _833, ((WorkingColorSpace_192[0].x) * _832)))));
  float _860 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _834, mad((WorkingColorSpace_192[1].y), _833, ((WorkingColorSpace_192[1].x) * _832)))));
  float _861 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _834, mad((WorkingColorSpace_192[2].y), _833, ((WorkingColorSpace_192[2].x) * _832)))));
  if (_859 < 0.0031306699384003878f) {
    _872 = (_859 * 12.920000076293945f);
  } else {
    _872 = (((pow(_859, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_860 < 0.0031306699384003878f) {
    _883 = (_860 * 12.920000076293945f);
  } else {
    _883 = (((pow(_860, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_861 < 0.0031306699384003878f) {
    _894 = (_861 * 12.920000076293945f);
  } else {
    _894 = (((pow(_861, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _898 = (_883 * 0.9375f) + 0.03125f;
  float _905 = _894 * 15.0f;
  float _906 = floor(_905);
  float _907 = _905 - _906;
  float _909 = (_906 + ((_872 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _912 = t0.Sample(s0, float2(_909, _898));
  float _916 = _909 + 0.0625f;
  float4 _919 = t0.Sample(s0, float2(_916, _898));
  float4 _942 = t1.Sample(s1, float2(_909, _898));
  float4 _948 = t1.Sample(s1, float2(_916, _898));
  float4 _971 = t2.Sample(s2, float2(_909, _898));
  float4 _977 = t2.Sample(s2, float2(_916, _898));
  float _996 = max(6.103519990574569e-05f, (((((lerp(_912.x, _919.x, _907)) * cb0_005y) + (cb0_005x * _872)) + ((lerp(_942.x, _948.x, _907)) * cb0_005z)) + ((lerp(_971.x, _977.x, _907)) * cb0_005w)));
  float _997 = max(6.103519990574569e-05f, (((((lerp(_912.y, _919.y, _907)) * cb0_005y) + (cb0_005x * _883)) + ((lerp(_942.y, _948.y, _907)) * cb0_005z)) + ((lerp(_971.y, _977.y, _907)) * cb0_005w)));
  float _998 = max(6.103519990574569e-05f, (((((lerp(_912.z, _919.z, _907)) * cb0_005y) + (cb0_005x * _894)) + ((lerp(_942.z, _948.z, _907)) * cb0_005z)) + ((lerp(_971.z, _977.z, _907)) * cb0_005w)));
  float _1020 = select((_996 > 0.040449999272823334f), exp2(log2((_996 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_996 * 0.07739938050508499f));
  float _1021 = select((_997 > 0.040449999272823334f), exp2(log2((_997 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_997 * 0.07739938050508499f));
  float _1022 = select((_998 > 0.040449999272823334f), exp2(log2((_998 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_998 * 0.07739938050508499f));
  float _1048 = cb0_014x * (((cb0_039y + (cb0_039x * _1020)) * _1020) + cb0_039z);
  float _1049 = cb0_014y * (((cb0_039y + (cb0_039x * _1021)) * _1021) + cb0_039z);
  float _1050 = cb0_014z * (((cb0_039y + (cb0_039x * _1022)) * _1022) + cb0_039z);
  float _1071 = exp2(log2(max(0.0f, (lerp(_1048, cb0_013x, cb0_013w)))) * cb0_040y);
  float _1072 = exp2(log2(max(0.0f, (lerp(_1049, cb0_013y, cb0_013w)))) * cb0_040y);
  float _1073 = exp2(log2(max(0.0f, (lerp(_1050, cb0_013z, cb0_013w)))) * cb0_040y);
  if ((uint)(WorkingColorSpace_320) == 0) {
    float _1092 = mad((WorkingColorSpace_128[0].z), _1073, mad((WorkingColorSpace_128[0].y), _1072, ((WorkingColorSpace_128[0].x) * _1071)));
    float _1095 = mad((WorkingColorSpace_128[1].z), _1073, mad((WorkingColorSpace_128[1].y), _1072, ((WorkingColorSpace_128[1].x) * _1071)));
    float _1098 = mad((WorkingColorSpace_128[2].z), _1073, mad((WorkingColorSpace_128[2].y), _1072, ((WorkingColorSpace_128[2].x) * _1071)));
    _1109 = mad(_47, _1098, mad(_46, _1095, (_1092 * _45)));
    _1110 = mad(_50, _1098, mad(_49, _1095, (_1092 * _48)));
    _1111 = mad(_53, _1098, mad(_52, _1095, (_1092 * _51)));
  } else {
    _1109 = _1071;
    _1110 = _1072;
    _1111 = _1073;
  }
  if (_1109 < 0.0031306699384003878f) {
    _1122 = (_1109 * 12.920000076293945f);
  } else {
    _1122 = (((pow(_1109, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1110 < 0.0031306699384003878f) {
    _1133 = (_1110 * 12.920000076293945f);
  } else {
    _1133 = (((pow(_1110, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1111 < 0.0031306699384003878f) {
    _1144 = (_1111 * 12.920000076293945f);
  } else {
    _1144 = (((pow(_1111, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1122 * 0.9523810148239136f);
  SV_Target.y = (_1133 * 0.9523810148239136f);
  SV_Target.z = (_1144 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
