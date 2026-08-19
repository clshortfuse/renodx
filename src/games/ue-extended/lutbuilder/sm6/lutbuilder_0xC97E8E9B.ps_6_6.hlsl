#include "../lutbuilderoutput.hlsli"

// The Expanse: Osiris Reborn beta

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
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

SamplerState s3 : register(s3);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _18 = 0.5f / cb0_035x;
  float _23 = cb0_035x + -1.0f;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _572;
  float _605;
  float _619;
  float _683;
  float _874;
  float _885;
  float _896;
  float _1140;
  float _1141;
  float _1142;
  float _1153;
  float _1164;
  float _1175;
  if (!((uint)(cb0_041x) == 1)) {
    if (!((uint)(cb0_041x) == 2)) {
      if (!((uint)(cb0_041x) == 3)) {
        bool _36 = ((uint)(cb0_041x) == 4);
        _47 = select(_36, 1.0f, 1.705051064491272f);
        _48 = select(_36, 0.0f, -0.6217921376228333f);
        _49 = select(_36, 0.0f, -0.0832589864730835f);
        _50 = select(_36, 0.0f, -0.13025647401809692f);
        _51 = select(_36, 1.0f, 1.140804648399353f);
        _52 = select(_36, 0.0f, -0.010548308491706848f);
        _53 = select(_36, 0.0f, -0.024003351107239723f);
        _54 = select(_36, 0.0f, -0.1289689838886261f);
        _55 = select(_36, 1.0f, 1.1529725790023804f);
      } else {
        _47 = 0.6954522132873535f;
        _48 = 0.14067870378494263f;
        _49 = 0.16386906802654266f;
        _50 = 0.044794563204050064f;
        _51 = 0.8596711158752441f;
        _52 = 0.0955343171954155f;
        _53 = -0.005525882821530104f;
        _54 = 0.004025210160762072f;
        _55 = 1.0015007257461548f;
      }
    } else {
      _47 = 1.0258246660232544f;
      _48 = -0.020053181797266006f;
      _49 = -0.005771636962890625f;
      _50 = -0.002234415616840124f;
      _51 = 1.0045864582061768f;
      _52 = -0.002352118492126465f;
      _53 = -0.005013350863009691f;
      _54 = -0.025290070101618767f;
      _55 = 1.0303035974502563f;
    }
  } else {
    _47 = 1.3792141675949097f;
    _48 = -0.30886411666870117f;
    _49 = -0.0703500509262085f;
    _50 = -0.06933490186929703f;
    _51 = 1.08229660987854f;
    _52 = -0.012961871922016144f;
    _53 = -0.0021590073592960835f;
    _54 = -0.0454593189060688f;
    _55 = 1.0476183891296387f;
  }
  float _68 = (exp2((((cb0_035x * (TEXCOORD.x - _18)) / _23) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _69 = (exp2((((cb0_035x * (TEXCOORD.y - _18)) / _23) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _70 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _23) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _85 = mad((WorkingColorSpace_128[0].z), _70, mad((WorkingColorSpace_128[0].y), _69, ((WorkingColorSpace_128[0].x) * _68)));
  float _88 = mad((WorkingColorSpace_128[1].z), _70, mad((WorkingColorSpace_128[1].y), _69, ((WorkingColorSpace_128[1].x) * _68)));
  float _91 = mad((WorkingColorSpace_128[2].z), _70, mad((WorkingColorSpace_128[2].y), _69, ((WorkingColorSpace_128[2].x) * _68)));
  float _92 = dot(float3(_85, _88, _91), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _96 = (_85 / _92) + -1.0f;
  float _97 = (_88 / _92) + -1.0f;
  float _98 = (_91 / _92) + -1.0f;

  // float _110 = (1.0f - exp2(((_92 * _92) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_96, _97, _98), float3(_96, _97, _98)) * -4.0f));
  float _110 = (1.0f - exp2(((_92 * _92) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_96, _97, _98), float3(_96, _97, _98)) * -4.0f));

  float _126 = ((mad(-0.06368321925401688f, _91, mad(-0.3292922377586365f, _88, (_85 * 1.3704125881195068f))) - _85) * _110) + _85;
  float _127 = ((mad(-0.010861365124583244f, _91, mad(1.0970927476882935f, _88, (_85 * -0.08343357592821121f))) - _88) * _110) + _88;
  float _128 = ((mad(1.2036951780319214f, _91, mad(-0.09862580895423889f, _88, (_85 * -0.02579331398010254f))) - _91) * _110) + _91;
  float _129 = dot(float3(_126, _127, _128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _143 = cb0_019w + cb0_024w;
  float _157 = cb0_018w * cb0_023w;
  float _171 = cb0_017w * cb0_022w;
  float _185 = cb0_016w * cb0_021w;
  float _199 = cb0_015w * cb0_020w;
  float _203 = _126 - _129;
  float _204 = _127 - _129;
  float _205 = _128 - _129;
  float _262 = saturate(_129 / cb0_035w);
  float _266 = (_262 * _262) * (3.0f - (_262 * 2.0f));
  float _267 = 1.0f - _266;
  float _276 = cb0_019w + cb0_034w;
  float _285 = cb0_018w * cb0_033w;
  float _294 = cb0_017w * cb0_032w;
  float _303 = cb0_016w * cb0_031w;
  float _312 = cb0_015w * cb0_030w;
  float _375 = saturate((_129 - cb0_036x) / (cb0_036y - cb0_036x));
  float _379 = (_375 * _375) * (3.0f - (_375 * 2.0f));
  float _388 = cb0_019w + cb0_029w;
  float _397 = cb0_018w * cb0_028w;
  float _406 = cb0_017w * cb0_027w;
  float _415 = cb0_016w * cb0_026w;
  float _424 = cb0_015w * cb0_025w;
  float _482 = _266 - _379;
  float _493 = ((_379 * (((cb0_019x + cb0_034x) + _276) + (((cb0_018x * cb0_033x) * _285) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _303) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _312) * _203) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _294)))))) + (_267 * (((cb0_019x + cb0_024x) + _143) + (((cb0_018x * cb0_023x) * _157) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _185) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _199) * _203) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _171))))))) + ((((cb0_019x + cb0_029x) + _388) + (((cb0_018x * cb0_028x) * _397) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _415) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _424) * _203) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _406))))) * _482);
  float _495 = ((_379 * (((cb0_019y + cb0_034y) + _276) + (((cb0_018y * cb0_033y) * _285) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _303) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _312) * _204) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _294)))))) + (_267 * (((cb0_019y + cb0_024y) + _143) + (((cb0_018y * cb0_023y) * _157) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _185) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _199) * _204) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _171))))))) + ((((cb0_019y + cb0_029y) + _388) + (((cb0_018y * cb0_028y) * _397) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _415) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _424) * _204) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _406))))) * _482);
  float _497 = ((_379 * (((cb0_019z + cb0_034z) + _276) + (((cb0_018z * cb0_033z) * _285) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _303) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _312) * _205) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _294)))))) + (_267 * (((cb0_019z + cb0_024z) + _143) + (((cb0_018z * cb0_023z) * _157) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _185) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _199) * _205) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _171))))))) + ((((cb0_019z + cb0_029z) + _388) + (((cb0_018z * cb0_028z) * _397) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _415) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _424) * _205) + _129)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _406))))) * _482);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(cb0_006x, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Lutweights[0].xyzw and Lutweights[1].x are used

  SV_Target = ProcessLutbuilder(float3(_493, _495, _497), s0, s1, s2, s3, t0, t1, t2, t3, cb_config, SV_Target, 0u);
  return SV_Target;

  float _512 = ((mad(0.061360642313957214f, _497, mad(-4.540197551250458e-09f, _495, (_493 * 0.9386394023895264f))) - _493) * cb0_036z) + _493;
  float _513 = ((mad(0.169205904006958f, _497, mad(0.8307942152023315f, _495, (_493 * 6.775371730327606e-08f))) - _495) * cb0_036z) + _495;
  float _514 = (mad(-2.3283064365386963e-10f, _495, (_493 * -9.313225746154785e-10f)) * cb0_036z) + _497;
  float _517 = mad(0.16386905312538147f, _514, mad(0.14067868888378143f, _513, (_512 * 0.6954522132873535f)));
  float _520 = mad(0.0955343246459961f, _514, mad(0.8596711158752441f, _513, (_512 * 0.044794581830501556f)));
  float _523 = mad(1.0015007257461548f, _514, mad(0.004025210160762072f, _513, (_512 * -0.005525882821530104f)));
  float _527 = max(max(_517, _520), _523);
  float _532 = (max(_527, 1.000000013351432e-10f) - max(min(min(_517, _520), _523), 1.000000013351432e-10f)) / max(_527, 0.009999999776482582f);
  float _545 = ((_520 + _517) + _523) + (sqrt((((_523 - _520) * _523) + ((_520 - _517) * _520)) + ((_517 - _523) * _517)) * 1.75f);
  float _546 = _545 * 0.3333333432674408f;
  float _547 = _532 + -0.4000000059604645f;
  float _548 = _547 * 5.0f;
  float _552 = max((1.0f - abs(_547 * 2.5f)), 0.0f);
  float _563 = ((float(((int)(uint)((bool)(_548 > 0.0f))) - ((int)(uint)((bool)(_548 < 0.0f)))) * (1.0f - (_552 * _552))) + 1.0f) * 0.02500000037252903f;
  if (!(_546 <= 0.0533333346247673f)) {
    if (!(_546 >= 0.1599999964237213f)) {
      _572 = (((0.23999999463558197f / _545) + -0.5f) * _563);
    } else {
      _572 = 0.0f;
    }
  } else {
    _572 = _563;
  }
  float _573 = _572 + 1.0f;
  float _574 = _573 * _517;
  float _575 = _573 * _520;
  float _576 = _573 * _523;
  if (!((bool)(_574 == _575) && (bool)(_575 == _576))) {
    float _583 = ((_574 * 2.0f) - _575) - _576;
    float _586 = ((_520 - _523) * 1.7320507764816284f) * _573;
    float _588 = atan(_586 / _583);
    bool _591 = (_583 < 0.0f);
    bool _592 = (_583 == 0.0f);
    bool _593 = (_586 >= 0.0f);
    bool _594 = (_586 < 0.0f);
    _605 = select((_593 && _592), 90.0f, select((_594 && _592), -90.0f, (select((_594 && _591), (_588 + -3.1415927410125732f), select((_593 && _591), (_588 + 3.1415927410125732f), _588)) * 57.2957763671875f)));
  } else {
    _605 = 0.0f;
  }
  float _610 = min(max(select((_605 < 0.0f), (_605 + 360.0f), _605), 0.0f), 360.0f);
  if (_610 < -180.0f) {
    _619 = (_610 + 360.0f);
  } else {
    if (_610 > 180.0f) {
      _619 = (_610 + -360.0f);
    } else {
      _619 = _610;
    }
  }
  float _623 = saturate(1.0f - abs(_619 * 0.014814814552664757f));
  float _627 = (_623 * _623) * (3.0f - (_623 * 2.0f));
  float _633 = ((_627 * _627) * ((_532 * 0.18000000715255737f) * (0.029999999329447746f - _574))) + _574;
  float _643 = max(0.0f, mad(-0.21492856740951538f, _576, mad(-0.2365107536315918f, _575, (_633 * 1.4514392614364624f))));
  float _644 = max(0.0f, mad(-0.09967592358589172f, _576, mad(1.17622971534729f, _575, (_633 * -0.07655377686023712f))));
  float _645 = max(0.0f, mad(0.9977163076400757f, _576, mad(-0.006032449658960104f, _575, (_633 * 0.008316148072481155f))));
  float _646 = dot(float3(_643, _644, _645), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _661 = (cb0_038x + 1.0f) - cb0_037z;
  float _663 = cb0_038y + 1.0f;
  float _665 = _663 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _683 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _674 = (cb0_038x + 0.18000000715255737f) / _661;
    _683 = (-0.7447274923324585f - ((log2(_674 / (2.0f - _674)) * 0.3465735912322998f) * (_661 / cb0_037y)));
  }
  float _686 = ((1.0f - cb0_037z) / cb0_037y) - _683;
  float _688 = (cb0_037w / cb0_037y) - _686;
  float _692 = log2(lerp(_646, _643, 0.9599999785423279f)) * 0.3010300099849701f;
  float _693 = log2(lerp(_646, _644, 0.9599999785423279f)) * 0.3010300099849701f;
  float _694 = log2(lerp(_646, _645, 0.9599999785423279f)) * 0.3010300099849701f;
  float _698 = cb0_037y * (_692 + _686);
  float _699 = cb0_037y * (_693 + _686);
  float _700 = cb0_037y * (_694 + _686);
  float _701 = _661 * 2.0f;
  float _703 = (cb0_037y * -2.0f) / _661;
  float _704 = _692 - _683;
  float _705 = _693 - _683;
  float _706 = _694 - _683;
  float _725 = _665 * 2.0f;
  float _727 = (cb0_037y * 2.0f) / _665;
  float _752 = select((_692 < _683), ((_701 / (exp2((_704 * 1.4426950216293335f) * _703) + 1.0f)) - cb0_038x), _698);
  float _753 = select((_693 < _683), ((_701 / (exp2((_705 * 1.4426950216293335f) * _703) + 1.0f)) - cb0_038x), _699);
  float _754 = select((_694 < _683), ((_701 / (exp2((_706 * 1.4426950216293335f) * _703) + 1.0f)) - cb0_038x), _700);
  float _761 = _688 - _683;
  float _765 = saturate(_704 / _761);
  float _766 = saturate(_705 / _761);
  float _767 = saturate(_706 / _761);
  bool _768 = (_688 < _683);
  float _772 = select(_768, (1.0f - _765), _765);
  float _773 = select(_768, (1.0f - _766), _766);
  float _774 = select(_768, (1.0f - _767), _767);
  float _793 = (((_772 * _772) * (select((_692 > _688), (_663 - (_725 / (exp2(((_692 - _688) * 1.4426950216293335f) * _727) + 1.0f))), _698) - _752)) * (3.0f - (_772 * 2.0f))) + _752;
  float _794 = (((_773 * _773) * (select((_693 > _688), (_663 - (_725 / (exp2(((_693 - _688) * 1.4426950216293335f) * _727) + 1.0f))), _699) - _753)) * (3.0f - (_773 * 2.0f))) + _753;
  float _795 = (((_774 * _774) * (select((_694 > _688), (_663 - (_725 / (exp2(((_694 - _688) * 1.4426950216293335f) * _727) + 1.0f))), _700) - _754)) * (3.0f - (_774 * 2.0f))) + _754;
  float _796 = dot(float3(_793, _794, _795), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _816 = (cb0_037x * (max(0.0f, (lerp(_796, _793, 0.9300000071525574f))) - _512)) + _512;
  float _817 = (cb0_037x * (max(0.0f, (lerp(_796, _794, 0.9300000071525574f))) - _513)) + _513;
  float _818 = (cb0_037x * (max(0.0f, (lerp(_796, _795, 0.9300000071525574f))) - _514)) + _514;
  float _834 = ((mad(-0.06537103652954102f, _818, mad(1.451815478503704e-06f, _817, (_816 * 1.065374732017517f))) - _816) * cb0_036z) + _816;
  float _835 = ((mad(-0.20366770029067993f, _818, mad(1.2036634683609009f, _817, (_816 * -2.57161445915699e-07f))) - _817) * cb0_036z) + _817;
  float _836 = ((mad(0.9999996423721313f, _818, mad(2.0954757928848267e-08f, _817, (_816 * 1.862645149230957e-08f))) - _818) * cb0_036z) + _818;
  float _861 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _836, mad((WorkingColorSpace_192[0].y), _835, ((WorkingColorSpace_192[0].x) * _834)))));
  float _862 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _836, mad((WorkingColorSpace_192[1].y), _835, ((WorkingColorSpace_192[1].x) * _834)))));
  float _863 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _836, mad((WorkingColorSpace_192[2].y), _835, ((WorkingColorSpace_192[2].x) * _834)))));
  if (_861 < 0.0031306699384003878f) {
    _874 = (_861 * 12.920000076293945f);
  } else {
    _874 = (((pow(_861, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_862 < 0.0031306699384003878f) {
    _885 = (_862 * 12.920000076293945f);
  } else {
    _885 = (((pow(_862, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_863 < 0.0031306699384003878f) {
    _896 = (_863 * 12.920000076293945f);
  } else {
    _896 = (((pow(_863, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _900 = (_885 * 0.9375f) + 0.03125f;
  float _907 = _896 * 15.0f;
  float _908 = floor(_907);
  float _909 = _907 - _908;
  float _911 = (_908 + ((_874 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _914 = t0.Sample(s0, float2(_911, _900));
  float _918 = _911 + 0.0625f;
  float4 _921 = t0.Sample(s0, float2(_918, _900));
  float4 _944 = t1.Sample(s1, float2(_911, _900));
  float4 _950 = t1.Sample(s1, float2(_918, _900));
  float4 _973 = t2.Sample(s2, float2(_911, _900));
  float4 _979 = t2.Sample(s2, float2(_918, _900));
  float4 _1002 = t3.Sample(s3, float2(_911, _900));
  float4 _1008 = t3.Sample(s3, float2(_918, _900));
  float _1027 = max(6.103519990574569e-05f, ((((((lerp(_914.x, _921.x, _909)) * cb0_005y) + (cb0_005x * _874)) + ((lerp(_944.x, _950.x, _909)) * cb0_005z)) + ((lerp(_973.x, _979.x, _909)) * cb0_005w)) + ((lerp(_1002.x, _1008.x, _909)) * cb0_006x)));
  float _1028 = max(6.103519990574569e-05f, ((((((lerp(_914.y, _921.y, _909)) * cb0_005y) + (cb0_005x * _885)) + ((lerp(_944.y, _950.y, _909)) * cb0_005z)) + ((lerp(_973.y, _979.y, _909)) * cb0_005w)) + ((lerp(_1002.y, _1008.y, _909)) * cb0_006x)));
  float _1029 = max(6.103519990574569e-05f, ((((((lerp(_914.z, _921.z, _909)) * cb0_005y) + (cb0_005x * _896)) + ((lerp(_944.z, _950.z, _909)) * cb0_005z)) + ((lerp(_973.z, _979.z, _909)) * cb0_005w)) + ((lerp(_1002.z, _1008.z, _909)) * cb0_006x)));
  float _1051 = select((_1027 > 0.040449999272823334f), exp2(log2((_1027 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1027 * 0.07739938050508499f));
  float _1052 = select((_1028 > 0.040449999272823334f), exp2(log2((_1028 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1028 * 0.07739938050508499f));
  float _1053 = select((_1029 > 0.040449999272823334f), exp2(log2((_1029 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1029 * 0.07739938050508499f));
  float _1079 = cb0_014x * (((cb0_039y + (cb0_039x * _1051)) * _1051) + cb0_039z);
  float _1080 = cb0_014y * (((cb0_039y + (cb0_039x * _1052)) * _1052) + cb0_039z);
  float _1081 = cb0_014z * (((cb0_039y + (cb0_039x * _1053)) * _1053) + cb0_039z);
  float _1102 = exp2(log2(max(0.0f, (lerp(_1079, cb0_013x, cb0_013w)))) * cb0_040y);
  float _1103 = exp2(log2(max(0.0f, (lerp(_1080, cb0_013y, cb0_013w)))) * cb0_040y);
  float _1104 = exp2(log2(max(0.0f, (lerp(_1081, cb0_013z, cb0_013w)))) * cb0_040y);
  if ((uint)(WorkingColorSpace_320) == 0) {
    float _1123 = mad((WorkingColorSpace_128[0].z), _1104, mad((WorkingColorSpace_128[0].y), _1103, ((WorkingColorSpace_128[0].x) * _1102)));
    float _1126 = mad((WorkingColorSpace_128[1].z), _1104, mad((WorkingColorSpace_128[1].y), _1103, ((WorkingColorSpace_128[1].x) * _1102)));
    float _1129 = mad((WorkingColorSpace_128[2].z), _1104, mad((WorkingColorSpace_128[2].y), _1103, ((WorkingColorSpace_128[2].x) * _1102)));
    _1140 = mad(_49, _1129, mad(_48, _1126, (_1123 * _47)));
    _1141 = mad(_52, _1129, mad(_51, _1126, (_1123 * _50)));
    _1142 = mad(_55, _1129, mad(_54, _1126, (_1123 * _53)));
  } else {
    _1140 = _1102;
    _1141 = _1103;
    _1142 = _1104;
  }
  if (_1140 < 0.0031306699384003878f) {
    _1153 = (_1140 * 12.920000076293945f);
  } else {
    _1153 = (((pow(_1140, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1141 < 0.0031306699384003878f) {
    _1164 = (_1141 * 12.920000076293945f);
  } else {
    _1164 = (((pow(_1141, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1142 < 0.0031306699384003878f) {
    _1175 = (_1142 * 12.920000076293945f);
  } else {
    _1175 = (((pow(_1142, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1153 * 0.9523810148239136f);
  SV_Target.y = (_1164 * 0.9523810148239136f);
  SV_Target.z = (_1175 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
