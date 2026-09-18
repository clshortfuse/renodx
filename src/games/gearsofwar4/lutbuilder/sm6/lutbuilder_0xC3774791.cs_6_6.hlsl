// Found in Blood of Dawnwalker

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

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

SamplerState s1 : register(s1);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _24 = 0.5f / cb0_035x;
  float _29 = cb0_035x + -1.0f;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _578;
  float _611;
  float _625;
  float _689;
  float _880;
  float _891;
  float _902;
  float _1071;
  float _1072;
  float _1073;
  float _1084;
  float _1095;
  float _1106;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _42 = (cb0_041x == 4);
        _53 = select(_42, 1.0f, 1.705051064491272f);
        _54 = select(_42, 0.0f, -0.6217921376228333f);
        _55 = select(_42, 0.0f, -0.0832589864730835f);
        _56 = select(_42, 0.0f, -0.13025647401809692f);
        _57 = select(_42, 1.0f, 1.140804648399353f);
        _58 = select(_42, 0.0f, -0.010548308491706848f);
        _59 = select(_42, 0.0f, -0.024003351107239723f);
        _60 = select(_42, 0.0f, -0.1289689838886261f);
        _61 = select(_42, 1.0f, 1.1529725790023804f);
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
      _53 = 1.0258246660232544f;
      _54 = -0.020053181797266006f;
      _55 = -0.005771636962890625f;
      _56 = -0.002234415616840124f;
      _57 = 1.0045864582061768f;
      _58 = -0.002352118492126465f;
      _59 = -0.005013350863009691f;
      _60 = -0.025290070101618767f;
      _61 = 1.0303035974502563f;
    }
  } else {
    _53 = 1.3792141675949097f;
    _54 = -0.30886411666870117f;
    _55 = -0.0703500509262085f;
    _56 = -0.06933490186929703f;
    _57 = 1.08229660987854f;
    _58 = -0.012961871922016144f;
    _59 = -0.0021590073592960835f;
    _60 = -0.0454593189060688f;
    _61 = 1.0476183891296387f;
  }
  float _74 = (exp2((((cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _75 = (exp2((((cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _76 = (exp2(((float((uint)SV_DispatchThreadID.z) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _91 = mad((WorkingColorSpace_128[0].z), _76, mad((WorkingColorSpace_128[0].y), _75, ((WorkingColorSpace_128[0].x) * _74)));
  float _94 = mad((WorkingColorSpace_128[1].z), _76, mad((WorkingColorSpace_128[1].y), _75, ((WorkingColorSpace_128[1].x) * _74)));
  float _97 = mad((WorkingColorSpace_128[2].z), _76, mad((WorkingColorSpace_128[2].y), _75, ((WorkingColorSpace_128[2].x) * _74)));
  float _98 = dot(float3(_91, _94, _97), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _102 = (_91 / _98) + -1.0f;
  float _103 = (_94 / _98) + -1.0f;
  float _104 = (_97 / _98) + -1.0f;
  float _116 = (1.0f - exp2(((_98 * _98) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_102, _103, _104), float3(_102, _103, _104)) * -4.0f));
  float _132 = ((mad(-0.06368321925401688f, _97, mad(-0.3292922377586365f, _94, (_91 * 1.3704125881195068f))) - _91) * _116) + _91;
  float _133 = ((mad(-0.010861365124583244f, _97, mad(1.0970927476882935f, _94, (_91 * -0.08343357592821121f))) - _94) * _116) + _94;
  float _134 = ((mad(1.2036951780319214f, _97, mad(-0.09862580895423889f, _94, (_91 * -0.02579331398010254f))) - _97) * _116) + _97;
  float _135 = dot(float3(_132, _133, _134), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _149 = cb0_019w + cb0_024w;
  float _163 = cb0_018w * cb0_023w;
  float _177 = cb0_017w * cb0_022w;
  float _191 = cb0_016w * cb0_021w;
  float _205 = cb0_015w * cb0_020w;
  float _209 = _132 - _135;
  float _210 = _133 - _135;
  float _211 = _134 - _135;
  float _268 = saturate(_135 / cb0_035w);
  float _272 = (_268 * _268) * (3.0f - (_268 * 2.0f));
  float _273 = 1.0f - _272;
  float _282 = cb0_019w + cb0_034w;
  float _291 = cb0_018w * cb0_033w;
  float _300 = cb0_017w * cb0_032w;
  float _309 = cb0_016w * cb0_031w;
  float _318 = cb0_015w * cb0_030w;
  float _381 = saturate((_135 - cb0_036x) / (cb0_036y - cb0_036x));
  float _385 = (_381 * _381) * (3.0f - (_381 * 2.0f));
  float _394 = cb0_019w + cb0_029w;
  float _403 = cb0_018w * cb0_028w;
  float _412 = cb0_017w * cb0_027w;
  float _421 = cb0_016w * cb0_026w;
  float _430 = cb0_015w * cb0_025w;
  float _488 = _272 - _385;
  float _499 = ((_385 * (((cb0_019x + cb0_034x) + _282) + (((cb0_018x * cb0_033x) * _291) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _309) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _318) * _209) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _300)))))) + (_273 * (((cb0_019x + cb0_024x) + _149) + (((cb0_018x * cb0_023x) * _163) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _191) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _205) * _209) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _177))))))) + ((((cb0_019x + cb0_029x) + _394) + (((cb0_018x * cb0_028x) * _403) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _421) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _430) * _209) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _412))))) * _488);
  float _501 = ((_385 * (((cb0_019y + cb0_034y) + _282) + (((cb0_018y * cb0_033y) * _291) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _309) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _318) * _210) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _300)))))) + (_273 * (((cb0_019y + cb0_024y) + _149) + (((cb0_018y * cb0_023y) * _163) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _191) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _205) * _210) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _177))))))) + ((((cb0_019y + cb0_029y) + _394) + (((cb0_018y * cb0_028y) * _403) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _421) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _430) * _210) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _412))))) * _488);
  float _503 = ((_385 * (((cb0_019z + cb0_034z) + _282) + (((cb0_018z * cb0_033z) * _291) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _309) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _318) * _211) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _300)))))) + (_273 * (((cb0_019z + cb0_024z) + _149) + (((cb0_018z * cb0_023z) * _163) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _191) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _205) * _211) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _177))))))) + ((((cb0_019z + cb0_029z) + _394) + (((cb0_018z * cb0_028z) * _403) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _421) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _430) * _211) + _135)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _412))))) * _488);

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
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyz  is used

  float4 output = ProcessLutbuilder(float3(_499, _501, _503), s0, s1, t0, t1, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], 0u);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _518 = ((mad(0.061360642313957214f, _503, mad(-4.540197551250458e-09f, _501, (_499 * 0.9386394023895264f))) - _499) * cb0_036z) + _499;
  float _519 = ((mad(0.169205904006958f, _503, mad(0.8307942152023315f, _501, (_499 * 6.775371730327606e-08f))) - _501) * cb0_036z) + _501;
  float _520 = (mad(-2.3283064365386963e-10f, _501, (_499 * -9.313225746154785e-10f)) * cb0_036z) + _503;
  float _523 = mad(0.16386905312538147f, _520, mad(0.14067868888378143f, _519, (_518 * 0.6954522132873535f)));
  float _526 = mad(0.0955343246459961f, _520, mad(0.8596711158752441f, _519, (_518 * 0.044794581830501556f)));
  float _529 = mad(1.0015007257461548f, _520, mad(0.004025210160762072f, _519, (_518 * -0.005525882821530104f)));
  float _533 = max(max(_523, _526), _529);
  float _538 = (max(_533, 1.000000013351432e-10f) - max(min(min(_523, _526), _529), 1.000000013351432e-10f)) / max(_533, 0.009999999776482582f);
  float _551 = ((_526 + _523) + _529) + (sqrt((((_529 - _526) * _529) + ((_526 - _523) * _526)) + ((_523 - _529) * _523)) * 1.75f);
  float _552 = _551 * 0.3333333432674408f;
  float _553 = _538 + -0.4000000059604645f;
  float _554 = _553 * 5.0f;
  float _558 = max((1.0f - abs(_553 * 2.5f)), 0.0f);
  float _569 = ((float((int)(((int)(uint)((bool)(_554 > 0.0f))) - ((int)(uint)((bool)(_554 < 0.0f))))) * (1.0f - (_558 * _558))) + 1.0f) * 0.02500000037252903f;
  if (!(_552 <= 0.0533333346247673f)) {
    if (!(_552 >= 0.1599999964237213f)) {
      _578 = (((0.23999999463558197f / _551) + -0.5f) * _569);
    } else {
      _578 = 0.0f;
    }
  } else {
    _578 = _569;
  }
  float _579 = _578 + 1.0f;
  float _580 = _579 * _523;
  float _581 = _579 * _526;
  float _582 = _579 * _529;
  if (!((bool)(_580 == _581) && (bool)(_581 == _582))) {
    float _589 = ((_580 * 2.0f) - _581) - _582;
    float _592 = ((_526 - _529) * 1.7320507764816284f) * _579;
    float _594 = atan(_592 / _589);
    bool _597 = (_589 < 0.0f);
    bool _598 = (_589 == 0.0f);
    bool _599 = (_592 >= 0.0f);
    bool _600 = (_592 < 0.0f);
    _611 = select((_599 && _598), 90.0f, select((_600 && _598), -90.0f, (select((_600 && _597), (_594 + -3.1415927410125732f), select((_599 && _597), (_594 + 3.1415927410125732f), _594)) * 57.2957763671875f)));
  } else {
    _611 = 0.0f;
  }
  float _616 = min(max(select((_611 < 0.0f), (_611 + 360.0f), _611), 0.0f), 360.0f);
  if (_616 < -180.0f) {
    _625 = (_616 + 360.0f);
  } else {
    if (_616 > 180.0f) {
      _625 = (_616 + -360.0f);
    } else {
      _625 = _616;
    }
  }
  float _629 = saturate(1.0f - abs(_625 * 0.014814814552664757f));
  float _633 = (_629 * _629) * (3.0f - (_629 * 2.0f));
  float _639 = ((_633 * _633) * ((_538 * 0.18000000715255737f) * (0.029999999329447746f - _580))) + _580;
  float _649 = max(0.0f, mad(-0.21492856740951538f, _582, mad(-0.2365107536315918f, _581, (_639 * 1.4514392614364624f))));
  float _650 = max(0.0f, mad(-0.09967592358589172f, _582, mad(1.17622971534729f, _581, (_639 * -0.07655377686023712f))));
  float _651 = max(0.0f, mad(0.9977163076400757f, _582, mad(-0.006032449658960104f, _581, (_639 * 0.008316148072481155f))));
  float _652 = dot(float3(_649, _650, _651), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _667 = (cb0_038x + 1.0f) - cb0_037z;
  float _669 = cb0_038y + 1.0f;
  float _671 = _669 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _689 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _680 = (cb0_038x + 0.18000000715255737f) / _667;
    _689 = (-0.7447274923324585f - ((log2(_680 / (2.0f - _680)) * 0.3465735912322998f) * (_667 / cb0_037y)));
  }
  float _692 = ((1.0f - cb0_037z) / cb0_037y) - _689;
  float _694 = (cb0_037w / cb0_037y) - _692;
  float _698 = log2(lerp(_652, _649, 0.9599999785423279f)) * 0.3010300099849701f;
  float _699 = log2(lerp(_652, _650, 0.9599999785423279f)) * 0.3010300099849701f;
  float _700 = log2(lerp(_652, _651, 0.9599999785423279f)) * 0.3010300099849701f;
  float _704 = cb0_037y * (_698 + _692);
  float _705 = cb0_037y * (_699 + _692);
  float _706 = cb0_037y * (_700 + _692);
  float _707 = _667 * 2.0f;
  float _709 = (cb0_037y * -2.0f) / _667;
  float _710 = _698 - _689;
  float _711 = _699 - _689;
  float _712 = _700 - _689;
  float _731 = _671 * 2.0f;
  float _733 = (cb0_037y * 2.0f) / _671;
  float _758 = select((_698 < _689), ((_707 / (exp2((_710 * 1.4426950216293335f) * _709) + 1.0f)) - cb0_038x), _704);
  float _759 = select((_699 < _689), ((_707 / (exp2((_711 * 1.4426950216293335f) * _709) + 1.0f)) - cb0_038x), _705);
  float _760 = select((_700 < _689), ((_707 / (exp2((_712 * 1.4426950216293335f) * _709) + 1.0f)) - cb0_038x), _706);
  float _767 = _694 - _689;
  float _771 = saturate(_710 / _767);
  float _772 = saturate(_711 / _767);
  float _773 = saturate(_712 / _767);
  bool _774 = (_694 < _689);
  float _778 = select(_774, (1.0f - _771), _771);
  float _779 = select(_774, (1.0f - _772), _772);
  float _780 = select(_774, (1.0f - _773), _773);
  float _799 = (((_778 * _778) * (select((_698 > _694), (_669 - (_731 / (exp2(((_698 - _694) * 1.4426950216293335f) * _733) + 1.0f))), _704) - _758)) * (3.0f - (_778 * 2.0f))) + _758;
  float _800 = (((_779 * _779) * (select((_699 > _694), (_669 - (_731 / (exp2(((_699 - _694) * 1.4426950216293335f) * _733) + 1.0f))), _705) - _759)) * (3.0f - (_779 * 2.0f))) + _759;
  float _801 = (((_780 * _780) * (select((_700 > _694), (_669 - (_731 / (exp2(((_700 - _694) * 1.4426950216293335f) * _733) + 1.0f))), _706) - _760)) * (3.0f - (_780 * 2.0f))) + _760;
  float _802 = dot(float3(_799, _800, _801), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _822 = (cb0_037x * (max(0.0f, (lerp(_802, _799, 0.9300000071525574f))) - _518)) + _518;
  float _823 = (cb0_037x * (max(0.0f, (lerp(_802, _800, 0.9300000071525574f))) - _519)) + _519;
  float _824 = (cb0_037x * (max(0.0f, (lerp(_802, _801, 0.9300000071525574f))) - _520)) + _520;
  float _840 = ((mad(-0.06537103652954102f, _824, mad(1.451815478503704e-06f, _823, (_822 * 1.065374732017517f))) - _822) * cb0_036z) + _822;
  float _841 = ((mad(-0.20366770029067993f, _824, mad(1.2036634683609009f, _823, (_822 * -2.57161445915699e-07f))) - _823) * cb0_036z) + _823;
  float _842 = ((mad(0.9999996423721313f, _824, mad(2.0954757928848267e-08f, _823, (_822 * 1.862645149230957e-08f))) - _824) * cb0_036z) + _824;
  float _867 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _842, mad((WorkingColorSpace_192[0].y), _841, ((WorkingColorSpace_192[0].x) * _840)))));
  float _868 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _842, mad((WorkingColorSpace_192[1].y), _841, ((WorkingColorSpace_192[1].x) * _840)))));
  float _869 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _842, mad((WorkingColorSpace_192[2].y), _841, ((WorkingColorSpace_192[2].x) * _840)))));
  if (_867 < 0.0031306699384003878f) {
    _880 = (_867 * 12.920000076293945f);
  } else {
    _880 = (((pow(_867, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_868 < 0.0031306699384003878f) {
    _891 = (_868 * 12.920000076293945f);
  } else {
    _891 = (((pow(_868, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_869 < 0.0031306699384003878f) {
    _902 = (_869 * 12.920000076293945f);
  } else {
    _902 = (((pow(_869, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _906 = (_891 * 0.9375f) + 0.03125f;
  float _913 = _902 * 15.0f;
  float _914 = floor(_913);
  float _915 = _913 - _914;
  float _917 = (_914 + ((_880 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _920 = t0.SampleLevel(s0, float2(_917, _906), 0.0f);
  float _924 = _917 + 0.0625f;
  float4 _925 = t0.SampleLevel(s0, float2(_924, _906), 0.0f);
  float4 _947 = t1.SampleLevel(s1, float2(_917, _906), 0.0f);
  float4 _951 = t1.SampleLevel(s1, float2(_924, _906), 0.0f);
  float _970 = max(6.103519990574569e-05f, ((((lerp(_920.x, _925.x, _915)) * cb0_005y) + (cb0_005x * _880)) + ((lerp(_947.x, _951.x, _915)) * cb0_005z)));
  float _971 = max(6.103519990574569e-05f, ((((lerp(_920.y, _925.y, _915)) * cb0_005y) + (cb0_005x * _891)) + ((lerp(_947.y, _951.y, _915)) * cb0_005z)));
  float _972 = max(6.103519990574569e-05f, ((((lerp(_920.z, _925.z, _915)) * cb0_005y) + (cb0_005x * _902)) + ((lerp(_947.z, _951.z, _915)) * cb0_005z)));
  float _994 = select((_970 > 0.040449999272823334f), exp2(log2((_970 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_970 * 0.07739938050508499f));
  float _995 = select((_971 > 0.040449999272823334f), exp2(log2((_971 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_971 * 0.07739938050508499f));
  float _996 = select((_972 > 0.040449999272823334f), exp2(log2((_972 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_972 * 0.07739938050508499f));
  float _1022 = cb0_014x * (((cb0_039y + (cb0_039x * _994)) * _994) + cb0_039z);
  float _1023 = cb0_014y * (((cb0_039y + (cb0_039x * _995)) * _995) + cb0_039z);
  float _1024 = cb0_014z * (((cb0_039y + (cb0_039x * _996)) * _996) + cb0_039z);
  float _1045 = exp2(log2(max(0.0f, (lerp(_1022, cb0_013x, cb0_013w)))) * cb0_040y);
  float _1046 = exp2(log2(max(0.0f, (lerp(_1023, cb0_013y, cb0_013w)))) * cb0_040y);
  float _1047 = exp2(log2(max(0.0f, (lerp(_1024, cb0_013z, cb0_013w)))) * cb0_040y);
  if (WorkingColorSpace_320 == 0) {
    float _1054 = mad((WorkingColorSpace_128[0].z), _1047, mad((WorkingColorSpace_128[0].y), _1046, ((WorkingColorSpace_128[0].x) * _1045)));
    float _1057 = mad((WorkingColorSpace_128[1].z), _1047, mad((WorkingColorSpace_128[1].y), _1046, ((WorkingColorSpace_128[1].x) * _1045)));
    float _1060 = mad((WorkingColorSpace_128[2].z), _1047, mad((WorkingColorSpace_128[2].y), _1046, ((WorkingColorSpace_128[2].x) * _1045)));
    _1071 = mad(_55, _1060, mad(_54, _1057, (_1054 * _53)));
    _1072 = mad(_58, _1060, mad(_57, _1057, (_1054 * _56)));
    _1073 = mad(_61, _1060, mad(_60, _1057, (_1054 * _59)));
  } else {
    _1071 = _1045;
    _1072 = _1046;
    _1073 = _1047;
  }
  if (_1071 < 0.0031306699384003878f) {
    _1084 = (_1071 * 12.920000076293945f);
  } else {
    _1084 = (((pow(_1071, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1072 < 0.0031306699384003878f) {
    _1095 = (_1072 * 12.920000076293945f);
  } else {
    _1095 = (((pow(_1072, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1073 < 0.0031306699384003878f) {
    _1106 = (_1073 * 12.920000076293945f);
  } else {
    _1106 = (((pow(_1073, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_1084 * 0.9523810148239136f), (_1095 * 0.9523810148239136f), (_1106 * 0.9523810148239136f), 0.0f);
}
