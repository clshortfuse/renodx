// High on Life 2, UE 5.5

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
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
  int cb0_041x : packoffset(c041.x);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _22 = 0.5f / cb0_035x;
  float _27 = cb0_035x + -1.0f;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _576;
  float _609;
  float _623;
  float _687;
  float _878;
  float _889;
  float _900;
  float _1043;
  float _1044;
  float _1045;
  float _1056;
  float _1067;
  float _1078;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _40 = (cb0_041x == 4);
        _51 = select(_40, 1.0f, 1.705051064491272f);
        _52 = select(_40, 0.0f, -0.6217921376228333f);
        _53 = select(_40, 0.0f, -0.0832589864730835f);
        _54 = select(_40, 0.0f, -0.13025647401809692f);
        _55 = select(_40, 1.0f, 1.140804648399353f);
        _56 = select(_40, 0.0f, -0.010548308491706848f);
        _57 = select(_40, 0.0f, -0.024003351107239723f);
        _58 = select(_40, 0.0f, -0.1289689838886261f);
        _59 = select(_40, 1.0f, 1.1529725790023804f);
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
      _51 = 1.0258246660232544f;
      _52 = -0.020053181797266006f;
      _53 = -0.005771636962890625f;
      _54 = -0.002234415616840124f;
      _55 = 1.0045864582061768f;
      _56 = -0.002352118492126465f;
      _57 = -0.005013350863009691f;
      _58 = -0.025290070101618767f;
      _59 = 1.0303035974502563f;
    }
  } else {
    _51 = 1.3792141675949097f;
    _52 = -0.30886411666870117f;
    _53 = -0.0703500509262085f;
    _54 = -0.06933490186929703f;
    _55 = 1.08229660987854f;
    _56 = -0.012961871922016144f;
    _57 = -0.0021590073592960835f;
    _58 = -0.0454593189060688f;
    _59 = 1.0476183891296387f;
  }
  float _72 = (exp2((((cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _22)) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _73 = (exp2((((cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _22)) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _74 = (exp2(((float((uint)SV_DispatchThreadID.z) / _27) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _89 = mad((WorkingColorSpace_128[0].z), _74, mad((WorkingColorSpace_128[0].y), _73, ((WorkingColorSpace_128[0].x) * _72)));
  float _92 = mad((WorkingColorSpace_128[1].z), _74, mad((WorkingColorSpace_128[1].y), _73, ((WorkingColorSpace_128[1].x) * _72)));
  float _95 = mad((WorkingColorSpace_128[2].z), _74, mad((WorkingColorSpace_128[2].y), _73, ((WorkingColorSpace_128[2].x) * _72)));
  float _96 = dot(float3(_89, _92, _95), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _100 = (_89 / _96) + -1.0f;
  float _101 = (_92 / _96) + -1.0f;
  float _102 = (_95 / _96) + -1.0f;

  // float _114 = (1.0f - exp2(((_96 * _96) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_100, _101, _102), float3(_100, _101, _102)) * -4.0f));
  float _114 = (1.0f - exp2(((_96 * _96) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_100, _101, _102), float3(_100, _101, _102)) * -4.0f));

  float _130 = ((mad(-0.06368321925401688f, _95, mad(-0.3292922377586365f, _92, (_89 * 1.3704125881195068f))) - _89) * _114) + _89;
  float _131 = ((mad(-0.010861365124583244f, _95, mad(1.0970927476882935f, _92, (_89 * -0.08343357592821121f))) - _92) * _114) + _92;
  float _132 = ((mad(1.2036951780319214f, _95, mad(-0.09862580895423889f, _92, (_89 * -0.02579331398010254f))) - _95) * _114) + _95;
  float _133 = dot(float3(_130, _131, _132), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _147 = cb0_019w + cb0_024w;
  float _161 = cb0_018w * cb0_023w;
  float _175 = cb0_017w * cb0_022w;
  float _189 = cb0_016w * cb0_021w;
  float _203 = cb0_015w * cb0_020w;
  float _207 = _130 - _133;
  float _208 = _131 - _133;
  float _209 = _132 - _133;
  float _266 = saturate(_133 / cb0_035w);
  float _270 = (_266 * _266) * (3.0f - (_266 * 2.0f));
  float _271 = 1.0f - _270;
  float _280 = cb0_019w + cb0_034w;
  float _289 = cb0_018w * cb0_033w;
  float _298 = cb0_017w * cb0_032w;
  float _307 = cb0_016w * cb0_031w;
  float _316 = cb0_015w * cb0_030w;
  float _379 = saturate((_133 - cb0_036x) / (cb0_036y - cb0_036x));
  float _383 = (_379 * _379) * (3.0f - (_379 * 2.0f));
  float _392 = cb0_019w + cb0_029w;
  float _401 = cb0_018w * cb0_028w;
  float _410 = cb0_017w * cb0_027w;
  float _419 = cb0_016w * cb0_026w;
  float _428 = cb0_015w * cb0_025w;
  float _486 = _270 - _383;
  float _497 = ((_383 * (((cb0_019x + cb0_034x) + _280) + (((cb0_018x * cb0_033x) * _289) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _307) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _316) * _207) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _298)))))) + (_271 * (((cb0_019x + cb0_024x) + _147) + (((cb0_018x * cb0_023x) * _161) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _189) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _203) * _207) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _175))))))) + ((((cb0_019x + cb0_029x) + _392) + (((cb0_018x * cb0_028x) * _401) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _419) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _428) * _207) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _410))))) * _486);
  float _499 = ((_383 * (((cb0_019y + cb0_034y) + _280) + (((cb0_018y * cb0_033y) * _289) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _307) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _316) * _208) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _298)))))) + (_271 * (((cb0_019y + cb0_024y) + _147) + (((cb0_018y * cb0_023y) * _161) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _189) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _203) * _208) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _175))))))) + ((((cb0_019y + cb0_029y) + _392) + (((cb0_018y * cb0_028y) * _401) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _419) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _428) * _208) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _410))))) * _486);
  float _501 = ((_383 * (((cb0_019z + cb0_034z) + _280) + (((cb0_018z * cb0_033z) * _289) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _307) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _316) * _209) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _298)))))) + (_271 * (((cb0_019z + cb0_024z) + _147) + (((cb0_018z * cb0_023z) * _161) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _189) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _203) * _209) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _175))))))) + ((((cb0_019z + cb0_029z) + _392) + (((cb0_018z * cb0_028z) * _401) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _419) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _428) * _209) + _133)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _410))))) * _486);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  //  Lutweights[0].xy

  float4 output = ProcessLutbuilder(float3(_497, _499, _501), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], 3u);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _516 = ((mad(0.061360642313957214f, _501, mad(-4.540197551250458e-09f, _499, (_497 * 0.9386394023895264f))) - _497) * cb0_036z) + _497;
  float _517 = ((mad(0.169205904006958f, _501, mad(0.8307942152023315f, _499, (_497 * 6.775371730327606e-08f))) - _499) * cb0_036z) + _499;
  float _518 = (mad(-2.3283064365386963e-10f, _499, (_497 * -9.313225746154785e-10f)) * cb0_036z) + _501;
  float _521 = mad(0.16386905312538147f, _518, mad(0.14067868888378143f, _517, (_516 * 0.6954522132873535f)));
  float _524 = mad(0.0955343246459961f, _518, mad(0.8596711158752441f, _517, (_516 * 0.044794581830501556f)));
  float _527 = mad(1.0015007257461548f, _518, mad(0.004025210160762072f, _517, (_516 * -0.005525882821530104f)));
  float _531 = max(max(_521, _524), _527);
  float _536 = (max(_531, 1.000000013351432e-10f) - max(min(min(_521, _524), _527), 1.000000013351432e-10f)) / max(_531, 0.009999999776482582f);
  float _549 = ((_524 + _521) + _527) + (sqrt((((_527 - _524) * _527) + ((_524 - _521) * _524)) + ((_521 - _527) * _521)) * 1.75f);
  float _550 = _549 * 0.3333333432674408f;
  float _551 = _536 + -0.4000000059604645f;
  float _552 = _551 * 5.0f;
  float _556 = max((1.0f - abs(_551 * 2.5f)), 0.0f);
  float _567 = ((float((int)(((int)(uint)((bool)(_552 > 0.0f))) - ((int)(uint)((bool)(_552 < 0.0f))))) * (1.0f - (_556 * _556))) + 1.0f) * 0.02500000037252903f;
  if (!(_550 <= 0.0533333346247673f)) {
    if (!(_550 >= 0.1599999964237213f)) {
      _576 = (((0.23999999463558197f / _549) + -0.5f) * _567);
    } else {
      _576 = 0.0f;
    }
  } else {
    _576 = _567;
  }
  float _577 = _576 + 1.0f;
  float _578 = _577 * _521;
  float _579 = _577 * _524;
  float _580 = _577 * _527;
  if (!((bool)(_578 == _579) && (bool)(_579 == _580))) {
    float _587 = ((_578 * 2.0f) - _579) - _580;
    float _590 = ((_524 - _527) * 1.7320507764816284f) * _577;
    float _592 = atan(_590 / _587);
    bool _595 = (_587 < 0.0f);
    bool _596 = (_587 == 0.0f);
    bool _597 = (_590 >= 0.0f);
    bool _598 = (_590 < 0.0f);
    _609 = select((_597 && _596), 90.0f, select((_598 && _596), -90.0f, (select((_598 && _595), (_592 + -3.1415927410125732f), select((_597 && _595), (_592 + 3.1415927410125732f), _592)) * 57.2957763671875f)));
  } else {
    _609 = 0.0f;
  }
  float _614 = min(max(select((_609 < 0.0f), (_609 + 360.0f), _609), 0.0f), 360.0f);
  if (_614 < -180.0f) {
    _623 = (_614 + 360.0f);
  } else {
    if (_614 > 180.0f) {
      _623 = (_614 + -360.0f);
    } else {
      _623 = _614;
    }
  }
  float _627 = saturate(1.0f - abs(_623 * 0.014814814552664757f));
  float _631 = (_627 * _627) * (3.0f - (_627 * 2.0f));
  float _637 = ((_631 * _631) * ((_536 * 0.18000000715255737f) * (0.029999999329447746f - _578))) + _578;
  float _647 = max(0.0f, mad(-0.21492856740951538f, _580, mad(-0.2365107536315918f, _579, (_637 * 1.4514392614364624f))));
  float _648 = max(0.0f, mad(-0.09967592358589172f, _580, mad(1.17622971534729f, _579, (_637 * -0.07655377686023712f))));
  float _649 = max(0.0f, mad(0.9977163076400757f, _580, mad(-0.006032449658960104f, _579, (_637 * 0.008316148072481155f))));
  float _650 = dot(float3(_647, _648, _649), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _665 = (cb0_038x + 1.0f) - cb0_037z;
  float _667 = cb0_038y + 1.0f;
  float _669 = _667 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _687 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _678 = (cb0_038x + 0.18000000715255737f) / _665;
    _687 = (-0.7447274923324585f - ((log2(_678 / (2.0f - _678)) * 0.3465735912322998f) * (_665 / cb0_037y)));
  }
  float _690 = ((1.0f - cb0_037z) / cb0_037y) - _687;
  float _692 = (cb0_037w / cb0_037y) - _690;
  float _696 = log2(lerp(_650, _647, 0.9599999785423279f)) * 0.3010300099849701f;
  float _697 = log2(lerp(_650, _648, 0.9599999785423279f)) * 0.3010300099849701f;
  float _698 = log2(lerp(_650, _649, 0.9599999785423279f)) * 0.3010300099849701f;
  float _702 = cb0_037y * (_696 + _690);
  float _703 = cb0_037y * (_697 + _690);
  float _704 = cb0_037y * (_698 + _690);
  float _705 = _665 * 2.0f;
  float _707 = (cb0_037y * -2.0f) / _665;
  float _708 = _696 - _687;
  float _709 = _697 - _687;
  float _710 = _698 - _687;
  float _729 = _669 * 2.0f;
  float _731 = (cb0_037y * 2.0f) / _669;
  float _756 = select((_696 < _687), ((_705 / (exp2((_708 * 1.4426950216293335f) * _707) + 1.0f)) - cb0_038x), _702);
  float _757 = select((_697 < _687), ((_705 / (exp2((_709 * 1.4426950216293335f) * _707) + 1.0f)) - cb0_038x), _703);
  float _758 = select((_698 < _687), ((_705 / (exp2((_710 * 1.4426950216293335f) * _707) + 1.0f)) - cb0_038x), _704);
  float _765 = _692 - _687;
  float _769 = saturate(_708 / _765);
  float _770 = saturate(_709 / _765);
  float _771 = saturate(_710 / _765);
  bool _772 = (_692 < _687);
  float _776 = select(_772, (1.0f - _769), _769);
  float _777 = select(_772, (1.0f - _770), _770);
  float _778 = select(_772, (1.0f - _771), _771);
  float _797 = (((_776 * _776) * (select((_696 > _692), (_667 - (_729 / (exp2(((_696 - _692) * 1.4426950216293335f) * _731) + 1.0f))), _702) - _756)) * (3.0f - (_776 * 2.0f))) + _756;
  float _798 = (((_777 * _777) * (select((_697 > _692), (_667 - (_729 / (exp2(((_697 - _692) * 1.4426950216293335f) * _731) + 1.0f))), _703) - _757)) * (3.0f - (_777 * 2.0f))) + _757;
  float _799 = (((_778 * _778) * (select((_698 > _692), (_667 - (_729 / (exp2(((_698 - _692) * 1.4426950216293335f) * _731) + 1.0f))), _704) - _758)) * (3.0f - (_778 * 2.0f))) + _758;
  float _800 = dot(float3(_797, _798, _799), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _820 = (cb0_037x * (max(0.0f, (lerp(_800, _797, 0.9300000071525574f))) - _516)) + _516;
  float _821 = (cb0_037x * (max(0.0f, (lerp(_800, _798, 0.9300000071525574f))) - _517)) + _517;
  float _822 = (cb0_037x * (max(0.0f, (lerp(_800, _799, 0.9300000071525574f))) - _518)) + _518;
  float _838 = ((mad(-0.06537103652954102f, _822, mad(1.451815478503704e-06f, _821, (_820 * 1.065374732017517f))) - _820) * cb0_036z) + _820;
  float _839 = ((mad(-0.20366770029067993f, _822, mad(1.2036634683609009f, _821, (_820 * -2.57161445915699e-07f))) - _821) * cb0_036z) + _821;
  float _840 = ((mad(0.9999996423721313f, _822, mad(2.0954757928848267e-08f, _821, (_820 * 1.862645149230957e-08f))) - _822) * cb0_036z) + _822;
  float _865 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _840, mad((WorkingColorSpace_192[0].y), _839, ((WorkingColorSpace_192[0].x) * _838)))));
  float _866 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _840, mad((WorkingColorSpace_192[1].y), _839, ((WorkingColorSpace_192[1].x) * _838)))));
  float _867 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _840, mad((WorkingColorSpace_192[2].y), _839, ((WorkingColorSpace_192[2].x) * _838)))));
  if (_865 < 0.0031306699384003878f) {
    _878 = (_865 * 12.920000076293945f);
  } else {
    _878 = (((pow(_865, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_866 < 0.0031306699384003878f) {
    _889 = (_866 * 12.920000076293945f);
  } else {
    _889 = (((pow(_866, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_867 < 0.0031306699384003878f) {
    _900 = (_867 * 12.920000076293945f);
  } else {
    _900 = (((pow(_867, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _904 = (_889 * 0.9375f) + 0.03125f;
  float _911 = _900 * 15.0f;
  float _912 = floor(_911);
  float _913 = _911 - _912;
  float _915 = (((_878 * 0.9375f) + 0.03125f) + _912) * 0.0625f;
  float4 _918 = t0.SampleLevel(s0, float2(_915, _904), 0.0f);
  float4 _923 = t0.SampleLevel(s0, float2((_915 + 0.0625f), _904), 0.0f);
  float _942 = max(6.103519990574569e-05f, (((lerp(_918.x, _923.x, _913)) * cb0_005y) + (cb0_005x * _878)));
  float _943 = max(6.103519990574569e-05f, (((lerp(_918.y, _923.y, _913)) * cb0_005y) + (cb0_005x * _889)));
  float _944 = max(6.103519990574569e-05f, (((lerp(_918.z, _923.z, _913)) * cb0_005y) + (cb0_005x * _900)));
  float _966 = select((_942 > 0.040449999272823334f), exp2(log2((_942 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_942 * 0.07739938050508499f));
  float _967 = select((_943 > 0.040449999272823334f), exp2(log2((_943 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_943 * 0.07739938050508499f));
  float _968 = select((_944 > 0.040449999272823334f), exp2(log2((_944 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_944 * 0.07739938050508499f));
  float _994 = cb0_014x * (((cb0_039y + (cb0_039x * _966)) * _966) + cb0_039z);
  float _995 = cb0_014y * (((cb0_039y + (cb0_039x * _967)) * _967) + cb0_039z);
  float _996 = cb0_014z * (((cb0_039y + (cb0_039x * _968)) * _968) + cb0_039z);
  float _1017 = exp2(log2(max(0.0f, (lerp(_994, cb0_013x, cb0_013w)))) * cb0_040y);
  float _1018 = exp2(log2(max(0.0f, (lerp(_995, cb0_013y, cb0_013w)))) * cb0_040y);
  float _1019 = exp2(log2(max(0.0f, (lerp(_996, cb0_013z, cb0_013w)))) * cb0_040y);
  if (WorkingColorSpace_320 == 0) {
    float _1026 = mad((WorkingColorSpace_128[0].z), _1019, mad((WorkingColorSpace_128[0].y), _1018, ((WorkingColorSpace_128[0].x) * _1017)));
    float _1029 = mad((WorkingColorSpace_128[1].z), _1019, mad((WorkingColorSpace_128[1].y), _1018, ((WorkingColorSpace_128[1].x) * _1017)));
    float _1032 = mad((WorkingColorSpace_128[2].z), _1019, mad((WorkingColorSpace_128[2].y), _1018, ((WorkingColorSpace_128[2].x) * _1017)));
    _1043 = mad(_53, _1032, mad(_52, _1029, (_1026 * _51)));
    _1044 = mad(_56, _1032, mad(_55, _1029, (_1026 * _54)));
    _1045 = mad(_59, _1032, mad(_58, _1029, (_1026 * _57)));
  } else {
    _1043 = _1017;
    _1044 = _1018;
    _1045 = _1019;
  }
  if (_1043 < 0.0031306699384003878f) {
    _1056 = (_1043 * 12.920000076293945f);
  } else {
    _1056 = (((pow(_1043, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1044 < 0.0031306699384003878f) {
    _1067 = (_1044 * 12.920000076293945f);
  } else {
    _1067 = (((pow(_1044, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1045 < 0.0031306699384003878f) {
    _1078 = (_1045 * 12.920000076293945f);
  } else {
    _1078 = (((pow(_1045, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1056 * 0.9523810148239136f), (_1067 * 0.9523810148239136f), (_1078 * 0.9523810148239136f), 0.0f);
}
