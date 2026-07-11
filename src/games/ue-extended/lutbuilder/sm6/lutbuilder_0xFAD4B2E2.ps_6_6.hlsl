#include "../lutbuilderoutput.hlsli"

// The Expanse: Osiris Reborn beta

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _14 = 0.5f / cb0_035x;
  float _19 = cb0_035x + -1.0f;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _568;
  float _601;
  float _615;
  float _679;
  float _870;
  float _881;
  float _892;
  float _1078;
  float _1079;
  float _1080;
  float _1091;
  float _1102;
  float _1113;
  if (!((uint)(cb0_041x) == 1)) {
    if (!((uint)(cb0_041x) == 2)) {
      if (!((uint)(cb0_041x) == 3)) {
        bool _32 = ((uint)(cb0_041x) == 4);
        _43 = select(_32, 1.0f, 1.705051064491272f);
        _44 = select(_32, 0.0f, -0.6217921376228333f);
        _45 = select(_32, 0.0f, -0.0832589864730835f);
        _46 = select(_32, 0.0f, -0.13025647401809692f);
        _47 = select(_32, 1.0f, 1.140804648399353f);
        _48 = select(_32, 0.0f, -0.010548308491706848f);
        _49 = select(_32, 0.0f, -0.024003351107239723f);
        _50 = select(_32, 0.0f, -0.1289689838886261f);
        _51 = select(_32, 1.0f, 1.1529725790023804f);
      } else {
        _43 = 0.6954522132873535f;
        _44 = 0.14067870378494263f;
        _45 = 0.16386906802654266f;
        _46 = 0.044794563204050064f;
        _47 = 0.8596711158752441f;
        _48 = 0.0955343171954155f;
        _49 = -0.005525882821530104f;
        _50 = 0.004025210160762072f;
        _51 = 1.0015007257461548f;
      }
    } else {
      _43 = 1.0258246660232544f;
      _44 = -0.020053181797266006f;
      _45 = -0.005771636962890625f;
      _46 = -0.002234415616840124f;
      _47 = 1.0045864582061768f;
      _48 = -0.002352118492126465f;
      _49 = -0.005013350863009691f;
      _50 = -0.025290070101618767f;
      _51 = 1.0303035974502563f;
    }
  } else {
    _43 = 1.3792141675949097f;
    _44 = -0.30886411666870117f;
    _45 = -0.0703500509262085f;
    _46 = -0.06933490186929703f;
    _47 = 1.08229660987854f;
    _48 = -0.012961871922016144f;
    _49 = -0.0021590073592960835f;
    _50 = -0.0454593189060688f;
    _51 = 1.0476183891296387f;
  }
  float _64 = (exp2((((cb0_035x * (TEXCOORD.x - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _65 = (exp2((((cb0_035x * (TEXCOORD.y - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _66 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _81 = mad((WorkingColorSpace_128[0].z), _66, mad((WorkingColorSpace_128[0].y), _65, ((WorkingColorSpace_128[0].x) * _64)));
  float _84 = mad((WorkingColorSpace_128[1].z), _66, mad((WorkingColorSpace_128[1].y), _65, ((WorkingColorSpace_128[1].x) * _64)));
  float _87 = mad((WorkingColorSpace_128[2].z), _66, mad((WorkingColorSpace_128[2].y), _65, ((WorkingColorSpace_128[2].x) * _64)));
  float _88 = dot(float3(_81, _84, _87), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _92 = (_81 / _88) + -1.0f;
  float _93 = (_84 / _88) + -1.0f;
  float _94 = (_87 / _88) + -1.0f;

  // float _106 = (1.0f - exp2(((_88 * _88) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_92, _93, _94), float3(_92, _93, _94)) * -4.0f));
  float _106 = (1.0f - exp2(((_88 * _88) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_92, _93, _94), float3(_92, _93, _94)) * -4.0f));

  float _122 = ((mad(-0.06368321925401688f, _87, mad(-0.3292922377586365f, _84, (_81 * 1.3704125881195068f))) - _81) * _106) + _81;
  float _123 = ((mad(-0.010861365124583244f, _87, mad(1.0970927476882935f, _84, (_81 * -0.08343357592821121f))) - _84) * _106) + _84;
  float _124 = ((mad(1.2036951780319214f, _87, mad(-0.09862580895423889f, _84, (_81 * -0.02579331398010254f))) - _87) * _106) + _87;
  float _125 = dot(float3(_122, _123, _124), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _139 = cb0_019w + cb0_024w;
  float _153 = cb0_018w * cb0_023w;
  float _167 = cb0_017w * cb0_022w;
  float _181 = cb0_016w * cb0_021w;
  float _195 = cb0_015w * cb0_020w;
  float _199 = _122 - _125;
  float _200 = _123 - _125;
  float _201 = _124 - _125;
  float _258 = saturate(_125 / cb0_035w);
  float _262 = (_258 * _258) * (3.0f - (_258 * 2.0f));
  float _263 = 1.0f - _262;
  float _272 = cb0_019w + cb0_034w;
  float _281 = cb0_018w * cb0_033w;
  float _290 = cb0_017w * cb0_032w;
  float _299 = cb0_016w * cb0_031w;
  float _308 = cb0_015w * cb0_030w;
  float _371 = saturate((_125 - cb0_036x) / (cb0_036y - cb0_036x));
  float _375 = (_371 * _371) * (3.0f - (_371 * 2.0f));
  float _384 = cb0_019w + cb0_029w;
  float _393 = cb0_018w * cb0_028w;
  float _402 = cb0_017w * cb0_027w;
  float _411 = cb0_016w * cb0_026w;
  float _420 = cb0_015w * cb0_025w;
  float _478 = _262 - _375;
  float _489 = ((_375 * (((cb0_019x + cb0_034x) + _272) + (((cb0_018x * cb0_033x) * _281) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _299) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _308) * _199) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _290)))))) + (_263 * (((cb0_019x + cb0_024x) + _139) + (((cb0_018x * cb0_023x) * _153) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _181) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _195) * _199) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _167))))))) + ((((cb0_019x + cb0_029x) + _384) + (((cb0_018x * cb0_028x) * _393) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _411) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _420) * _199) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _402))))) * _478);
  float _491 = ((_375 * (((cb0_019y + cb0_034y) + _272) + (((cb0_018y * cb0_033y) * _281) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _299) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _308) * _200) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _290)))))) + (_263 * (((cb0_019y + cb0_024y) + _139) + (((cb0_018y * cb0_023y) * _153) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _181) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _195) * _200) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _167))))))) + ((((cb0_019y + cb0_029y) + _384) + (((cb0_018y * cb0_028y) * _393) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _411) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _420) * _200) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _402))))) * _478);
  float _493 = ((_375 * (((cb0_019z + cb0_034z) + _272) + (((cb0_018z * cb0_033z) * _281) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _299) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _308) * _201) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _290)))))) + (_263 * (((cb0_019z + cb0_024z) + _139) + (((cb0_018z * cb0_023z) * _153) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _181) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _195) * _201) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _167))))))) + ((((cb0_019z + cb0_029z) + _384) + (((cb0_018z * cb0_028z) * _393) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _411) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _420) * _201) + _125)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _402))))) * _478);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyz is used

  SV_Target = ProcessLutbuilder(float3(_489, _491, _493), s0, s1, t0, t1, cb_config, SV_Target, 0u);
  return SV_Target;

  float _508 = ((mad(0.061360642313957214f, _493, mad(-4.540197551250458e-09f, _491, (_489 * 0.9386394023895264f))) - _489) * cb0_036z) + _489;
  float _509 = ((mad(0.169205904006958f, _493, mad(0.8307942152023315f, _491, (_489 * 6.775371730327606e-08f))) - _491) * cb0_036z) + _491;
  float _510 = (mad(-2.3283064365386963e-10f, _491, (_489 * -9.313225746154785e-10f)) * cb0_036z) + _493;
  float _513 = mad(0.16386905312538147f, _510, mad(0.14067868888378143f, _509, (_508 * 0.6954522132873535f)));
  float _516 = mad(0.0955343246459961f, _510, mad(0.8596711158752441f, _509, (_508 * 0.044794581830501556f)));
  float _519 = mad(1.0015007257461548f, _510, mad(0.004025210160762072f, _509, (_508 * -0.005525882821530104f)));
  float _523 = max(max(_513, _516), _519);
  float _528 = (max(_523, 1.000000013351432e-10f) - max(min(min(_513, _516), _519), 1.000000013351432e-10f)) / max(_523, 0.009999999776482582f);
  float _541 = ((_516 + _513) + _519) + (sqrt((((_519 - _516) * _519) + ((_516 - _513) * _516)) + ((_513 - _519) * _513)) * 1.75f);
  float _542 = _541 * 0.3333333432674408f;
  float _543 = _528 + -0.4000000059604645f;
  float _544 = _543 * 5.0f;
  float _548 = max((1.0f - abs(_543 * 2.5f)), 0.0f);
  float _559 = ((float(((int)(uint)((bool)(_544 > 0.0f))) - ((int)(uint)((bool)(_544 < 0.0f)))) * (1.0f - (_548 * _548))) + 1.0f) * 0.02500000037252903f;
  if (!(_542 <= 0.0533333346247673f)) {
    if (!(_542 >= 0.1599999964237213f)) {
      _568 = (((0.23999999463558197f / _541) + -0.5f) * _559);
    } else {
      _568 = 0.0f;
    }
  } else {
    _568 = _559;
  }
  float _569 = _568 + 1.0f;
  float _570 = _569 * _513;
  float _571 = _569 * _516;
  float _572 = _569 * _519;
  if (!((bool)(_570 == _571) && (bool)(_571 == _572))) {
    float _579 = ((_570 * 2.0f) - _571) - _572;
    float _582 = ((_516 - _519) * 1.7320507764816284f) * _569;
    float _584 = atan(_582 / _579);
    bool _587 = (_579 < 0.0f);
    bool _588 = (_579 == 0.0f);
    bool _589 = (_582 >= 0.0f);
    bool _590 = (_582 < 0.0f);
    _601 = select((_589 && _588), 90.0f, select((_590 && _588), -90.0f, (select((_590 && _587), (_584 + -3.1415927410125732f), select((_589 && _587), (_584 + 3.1415927410125732f), _584)) * 57.2957763671875f)));
  } else {
    _601 = 0.0f;
  }
  float _606 = min(max(select((_601 < 0.0f), (_601 + 360.0f), _601), 0.0f), 360.0f);
  if (_606 < -180.0f) {
    _615 = (_606 + 360.0f);
  } else {
    if (_606 > 180.0f) {
      _615 = (_606 + -360.0f);
    } else {
      _615 = _606;
    }
  }
  float _619 = saturate(1.0f - abs(_615 * 0.014814814552664757f));
  float _623 = (_619 * _619) * (3.0f - (_619 * 2.0f));
  float _629 = ((_623 * _623) * ((_528 * 0.18000000715255737f) * (0.029999999329447746f - _570))) + _570;
  float _639 = max(0.0f, mad(-0.21492856740951538f, _572, mad(-0.2365107536315918f, _571, (_629 * 1.4514392614364624f))));
  float _640 = max(0.0f, mad(-0.09967592358589172f, _572, mad(1.17622971534729f, _571, (_629 * -0.07655377686023712f))));
  float _641 = max(0.0f, mad(0.9977163076400757f, _572, mad(-0.006032449658960104f, _571, (_629 * 0.008316148072481155f))));
  float _642 = dot(float3(_639, _640, _641), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _657 = (cb0_038x + 1.0f) - cb0_037z;
  float _659 = cb0_038y + 1.0f;
  float _661 = _659 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _679 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _670 = (cb0_038x + 0.18000000715255737f) / _657;
    _679 = (-0.7447274923324585f - ((log2(_670 / (2.0f - _670)) * 0.3465735912322998f) * (_657 / cb0_037y)));
  }
  float _682 = ((1.0f - cb0_037z) / cb0_037y) - _679;
  float _684 = (cb0_037w / cb0_037y) - _682;
  float _688 = log2(lerp(_642, _639, 0.9599999785423279f)) * 0.3010300099849701f;
  float _689 = log2(lerp(_642, _640, 0.9599999785423279f)) * 0.3010300099849701f;
  float _690 = log2(lerp(_642, _641, 0.9599999785423279f)) * 0.3010300099849701f;
  float _694 = cb0_037y * (_688 + _682);
  float _695 = cb0_037y * (_689 + _682);
  float _696 = cb0_037y * (_690 + _682);
  float _697 = _657 * 2.0f;
  float _699 = (cb0_037y * -2.0f) / _657;
  float _700 = _688 - _679;
  float _701 = _689 - _679;
  float _702 = _690 - _679;
  float _721 = _661 * 2.0f;
  float _723 = (cb0_037y * 2.0f) / _661;
  float _748 = select((_688 < _679), ((_697 / (exp2((_700 * 1.4426950216293335f) * _699) + 1.0f)) - cb0_038x), _694);
  float _749 = select((_689 < _679), ((_697 / (exp2((_701 * 1.4426950216293335f) * _699) + 1.0f)) - cb0_038x), _695);
  float _750 = select((_690 < _679), ((_697 / (exp2((_702 * 1.4426950216293335f) * _699) + 1.0f)) - cb0_038x), _696);
  float _757 = _684 - _679;
  float _761 = saturate(_700 / _757);
  float _762 = saturate(_701 / _757);
  float _763 = saturate(_702 / _757);
  bool _764 = (_684 < _679);
  float _768 = select(_764, (1.0f - _761), _761);
  float _769 = select(_764, (1.0f - _762), _762);
  float _770 = select(_764, (1.0f - _763), _763);
  float _789 = (((_768 * _768) * (select((_688 > _684), (_659 - (_721 / (exp2(((_688 - _684) * 1.4426950216293335f) * _723) + 1.0f))), _694) - _748)) * (3.0f - (_768 * 2.0f))) + _748;
  float _790 = (((_769 * _769) * (select((_689 > _684), (_659 - (_721 / (exp2(((_689 - _684) * 1.4426950216293335f) * _723) + 1.0f))), _695) - _749)) * (3.0f - (_769 * 2.0f))) + _749;
  float _791 = (((_770 * _770) * (select((_690 > _684), (_659 - (_721 / (exp2(((_690 - _684) * 1.4426950216293335f) * _723) + 1.0f))), _696) - _750)) * (3.0f - (_770 * 2.0f))) + _750;
  float _792 = dot(float3(_789, _790, _791), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _812 = (cb0_037x * (max(0.0f, (lerp(_792, _789, 0.9300000071525574f))) - _508)) + _508;
  float _813 = (cb0_037x * (max(0.0f, (lerp(_792, _790, 0.9300000071525574f))) - _509)) + _509;
  float _814 = (cb0_037x * (max(0.0f, (lerp(_792, _791, 0.9300000071525574f))) - _510)) + _510;
  float _830 = ((mad(-0.06537103652954102f, _814, mad(1.451815478503704e-06f, _813, (_812 * 1.065374732017517f))) - _812) * cb0_036z) + _812;
  float _831 = ((mad(-0.20366770029067993f, _814, mad(1.2036634683609009f, _813, (_812 * -2.57161445915699e-07f))) - _813) * cb0_036z) + _813;
  float _832 = ((mad(0.9999996423721313f, _814, mad(2.0954757928848267e-08f, _813, (_812 * 1.862645149230957e-08f))) - _814) * cb0_036z) + _814;
  float _857 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _832, mad((WorkingColorSpace_192[0].y), _831, ((WorkingColorSpace_192[0].x) * _830)))));
  float _858 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _832, mad((WorkingColorSpace_192[1].y), _831, ((WorkingColorSpace_192[1].x) * _830)))));
  float _859 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _832, mad((WorkingColorSpace_192[2].y), _831, ((WorkingColorSpace_192[2].x) * _830)))));
  if (_857 < 0.0031306699384003878f) {
    _870 = (_857 * 12.920000076293945f);
  } else {
    _870 = (((pow(_857, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_858 < 0.0031306699384003878f) {
    _881 = (_858 * 12.920000076293945f);
  } else {
    _881 = (((pow(_858, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_859 < 0.0031306699384003878f) {
    _892 = (_859 * 12.920000076293945f);
  } else {
    _892 = (((pow(_859, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _896 = (_881 * 0.9375f) + 0.03125f;
  float _903 = _892 * 15.0f;
  float _904 = floor(_903);
  float _905 = _903 - _904;
  float _907 = (_904 + ((_870 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _910 = t0.Sample(s0, float2(_907, _896));
  float _914 = _907 + 0.0625f;
  float4 _917 = t0.Sample(s0, float2(_914, _896));
  float4 _940 = t1.Sample(s1, float2(_907, _896));
  float4 _946 = t1.Sample(s1, float2(_914, _896));
  float _965 = max(6.103519990574569e-05f, ((((lerp(_910.x, _917.x, _905)) * cb0_005y) + (cb0_005x * _870)) + ((lerp(_940.x, _946.x, _905)) * cb0_005z)));
  float _966 = max(6.103519990574569e-05f, ((((lerp(_910.y, _917.y, _905)) * cb0_005y) + (cb0_005x * _881)) + ((lerp(_940.y, _946.y, _905)) * cb0_005z)));
  float _967 = max(6.103519990574569e-05f, ((((lerp(_910.z, _917.z, _905)) * cb0_005y) + (cb0_005x * _892)) + ((lerp(_940.z, _946.z, _905)) * cb0_005z)));
  float _989 = select((_965 > 0.040449999272823334f), exp2(log2((_965 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_965 * 0.07739938050508499f));
  float _990 = select((_966 > 0.040449999272823334f), exp2(log2((_966 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_966 * 0.07739938050508499f));
  float _991 = select((_967 > 0.040449999272823334f), exp2(log2((_967 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_967 * 0.07739938050508499f));
  float _1017 = cb0_014x * (((cb0_039y + (cb0_039x * _989)) * _989) + cb0_039z);
  float _1018 = cb0_014y * (((cb0_039y + (cb0_039x * _990)) * _990) + cb0_039z);
  float _1019 = cb0_014z * (((cb0_039y + (cb0_039x * _991)) * _991) + cb0_039z);
  float _1040 = exp2(log2(max(0.0f, (lerp(_1017, cb0_013x, cb0_013w)))) * cb0_040y);
  float _1041 = exp2(log2(max(0.0f, (lerp(_1018, cb0_013y, cb0_013w)))) * cb0_040y);
  float _1042 = exp2(log2(max(0.0f, (lerp(_1019, cb0_013z, cb0_013w)))) * cb0_040y);
  if ((uint)(WorkingColorSpace_320) == 0) {
    float _1061 = mad((WorkingColorSpace_128[0].z), _1042, mad((WorkingColorSpace_128[0].y), _1041, ((WorkingColorSpace_128[0].x) * _1040)));
    float _1064 = mad((WorkingColorSpace_128[1].z), _1042, mad((WorkingColorSpace_128[1].y), _1041, ((WorkingColorSpace_128[1].x) * _1040)));
    float _1067 = mad((WorkingColorSpace_128[2].z), _1042, mad((WorkingColorSpace_128[2].y), _1041, ((WorkingColorSpace_128[2].x) * _1040)));
    _1078 = mad(_45, _1067, mad(_44, _1064, (_1061 * _43)));
    _1079 = mad(_48, _1067, mad(_47, _1064, (_1061 * _46)));
    _1080 = mad(_51, _1067, mad(_50, _1064, (_1061 * _49)));
  } else {
    _1078 = _1040;
    _1079 = _1041;
    _1080 = _1042;
  }
  if (_1078 < 0.0031306699384003878f) {
    _1091 = (_1078 * 12.920000076293945f);
  } else {
    _1091 = (((pow(_1078, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1079 < 0.0031306699384003878f) {
    _1102 = (_1079 * 12.920000076293945f);
  } else {
    _1102 = (((pow(_1079, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1080 < 0.0031306699384003878f) {
    _1113 = (_1080 * 12.920000076293945f);
  } else {
    _1113 = (((pow(_1080, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1091 * 0.9523810148239136f);
  SV_Target.y = (_1102 * 0.9523810148239136f);
  SV_Target.z = (_1113 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
