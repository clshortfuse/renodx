#include "../../common.hlsl"

// Found in everspace 2

Texture2D<float4> t0 : register(t0);

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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _12 = 0.5f / cb0_035x;
  float _17 = cb0_035x + -1.0f;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _566;
  float _599;
  float _613;
  float _677;
  float _868;
  float _879;
  float _890;
  float _1047;
  float _1048;
  float _1049;
  float _1060;
  float _1071;
  float _1082;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _30 = (cb0_041x == 4);
        _41 = select(_30, 1.0f, 1.705051064491272f);
        _42 = select(_30, 0.0f, -0.6217921376228333f);
        _43 = select(_30, 0.0f, -0.0832589864730835f);
        _44 = select(_30, 0.0f, -0.13025647401809692f);
        _45 = select(_30, 1.0f, 1.140804648399353f);
        _46 = select(_30, 0.0f, -0.010548308491706848f);
        _47 = select(_30, 0.0f, -0.024003351107239723f);
        _48 = select(_30, 0.0f, -0.1289689838886261f);
        _49 = select(_30, 1.0f, 1.1529725790023804f);
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
      _41 = 1.0258246660232544f;
      _42 = -0.020053181797266006f;
      _43 = -0.005771636962890625f;
      _44 = -0.002234415616840124f;
      _45 = 1.0045864582061768f;
      _46 = -0.002352118492126465f;
      _47 = -0.005013350863009691f;
      _48 = -0.025290070101618767f;
      _49 = 1.0303035974502563f;
    }
  } else {
    _41 = 1.3792141675949097f;
    _42 = -0.30886411666870117f;
    _43 = -0.0703500509262085f;
    _44 = -0.06933490186929703f;
    _45 = 1.08229660987854f;
    _46 = -0.012961871922016144f;
    _47 = -0.0021590073592960835f;
    _48 = -0.0454593189060688f;
    _49 = 1.0476183891296387f;
  }
  float _62 = (exp2((((cb0_035x * (TEXCOORD.x - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _63 = (exp2((((cb0_035x * (TEXCOORD.y - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _64 = (exp2(((float((uint)(int)(SV_RenderTargetArrayIndex)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _79 = mad((WorkingColorSpace_128[0].z), _64, mad((WorkingColorSpace_128[0].y), _63, ((WorkingColorSpace_128[0].x) * _62)));
  float _82 = mad((WorkingColorSpace_128[1].z), _64, mad((WorkingColorSpace_128[1].y), _63, ((WorkingColorSpace_128[1].x) * _62)));
  float _85 = mad((WorkingColorSpace_128[2].z), _64, mad((WorkingColorSpace_128[2].y), _63, ((WorkingColorSpace_128[2].x) * _62)));
  float _86 = dot(float3(_79, _82, _85), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_79, _82, _85));

  float _90 = (_79 / _86) + -1.0f;
  float _91 = (_82 / _86) + -1.0f;
  float _92 = (_85 / _86) + -1.0f;
  float _104 = (1.0f - exp2(((_86 * _86) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_90, _91, _92), float3(_90, _91, _92)) * -4.0f));
  float _120 = ((mad(-0.06368321925401688f, _85, mad(-0.3292922377586365f, _82, (_79 * 1.3704125881195068f))) - _79) * _104) + _79;
  float _121 = ((mad(-0.010861365124583244f, _85, mad(1.0970927476882935f, _82, (_79 * -0.08343357592821121f))) - _82) * _104) + _82;
  float _122 = ((mad(1.2036951780319214f, _85, mad(-0.09862580895423889f, _82, (_79 * -0.02579331398010254f))) - _85) * _104) + _85;
  float _123 = dot(float3(_120, _121, _122), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _137 = cb0_019w + cb0_024w;
  float _151 = cb0_018w * cb0_023w;
  float _165 = cb0_017w * cb0_022w;
  float _179 = cb0_016w * cb0_021w;
  float _193 = cb0_015w * cb0_020w;
  float _197 = _120 - _123;
  float _198 = _121 - _123;
  float _199 = _122 - _123;
  float _256 = saturate(_123 / cb0_035w);
  float _260 = (_256 * _256) * (3.0f - (_256 * 2.0f));
  float _261 = 1.0f - _260;
  float _270 = cb0_019w + cb0_034w;
  float _279 = cb0_018w * cb0_033w;
  float _288 = cb0_017w * cb0_032w;
  float _297 = cb0_016w * cb0_031w;
  float _306 = cb0_015w * cb0_030w;
  float _369 = saturate((_123 - cb0_036x) / (cb0_036y - cb0_036x));
  float _373 = (_369 * _369) * (3.0f - (_369 * 2.0f));
  float _382 = cb0_019w + cb0_029w;
  float _391 = cb0_018w * cb0_028w;
  float _400 = cb0_017w * cb0_027w;
  float _409 = cb0_016w * cb0_026w;
  float _418 = cb0_015w * cb0_025w;
  float _476 = _260 - _373;
  float _487 = ((_373 * (((cb0_019x + cb0_034x) + _270) + (((cb0_018x * cb0_033x) * _279) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _297) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _306) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _288)))))) + (_261 * (((cb0_019x + cb0_024x) + _137) + (((cb0_018x * cb0_023x) * _151) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _179) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _193) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _165))))))) + ((((cb0_019x + cb0_029x) + _382) + (((cb0_018x * cb0_028x) * _391) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _409) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _418) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _400))))) * _476);
  float _489 = ((_373 * (((cb0_019y + cb0_034y) + _270) + (((cb0_018y * cb0_033y) * _279) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _297) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _306) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _288)))))) + (_261 * (((cb0_019y + cb0_024y) + _137) + (((cb0_018y * cb0_023y) * _151) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _179) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _193) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _165))))))) + ((((cb0_019y + cb0_029y) + _382) + (((cb0_018y * cb0_028y) * _391) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _409) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _418) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _400))))) * _476);
  float _491 = ((_373 * (((cb0_019z + cb0_034z) + _270) + (((cb0_018z * cb0_033z) * _279) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _297) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _306) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _288)))))) + (_261 * (((cb0_019z + cb0_024z) + _137) + (((cb0_018z * cb0_023z) * _151) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _179) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _193) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _165))))))) + ((((cb0_019z + cb0_029z) + _382) + (((cb0_018z * cb0_028z) * _391) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _409) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _418) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _400))))) * _476);

  SetUntonemappedAP1(float3(_487, _489, _491));

  float _506 = ((mad(0.061360642313957214f, _491, mad(-4.540197551250458e-09f, _489, (_487 * 0.9386394023895264f))) - _487) * cb0_036z) + _487;
  float _507 = ((mad(0.169205904006958f, _491, mad(0.8307942152023315f, _489, (_487 * 6.775371730327606e-08f))) - _489) * cb0_036z) + _489;
  float _508 = (mad(-2.3283064365386963e-10f, _489, (_487 * -9.313225746154785e-10f)) * cb0_036z) + _491;
  float _511 = mad(0.16386905312538147f, _508, mad(0.14067868888378143f, _507, (_506 * 0.6954522132873535f)));
  float _514 = mad(0.0955343246459961f, _508, mad(0.8596711158752441f, _507, (_506 * 0.044794581830501556f)));
  float _517 = mad(1.0015007257461548f, _508, mad(0.004025210160762072f, _507, (_506 * -0.005525882821530104f)));
  float _521 = max(max(_511, _514), _517);
  float _526 = (max(_521, 1.000000013351432e-10f) - max(min(min(_511, _514), _517), 1.000000013351432e-10f)) / max(_521, 0.009999999776482582f);
  float _539 = ((_514 + _511) + _517) + (sqrt((((_517 - _514) * _517) + ((_514 - _511) * _514)) + ((_511 - _517) * _511)) * 1.75f);
  float _540 = _539 * 0.3333333432674408f;
  float _541 = _526 + -0.4000000059604645f;
  float _542 = _541 * 5.0f;
  float _546 = max((1.0f - abs(_541 * 2.5f)), 0.0f);
  float _557 = ((float(((int)(uint)((bool)(_542 > 0.0f))) - ((int)(uint)((bool)(_542 < 0.0f)))) * (1.0f - (_546 * _546))) + 1.0f) * 0.02500000037252903f;
  if (!(_540 <= 0.0533333346247673f)) {
    if (!(_540 >= 0.1599999964237213f)) {
      _566 = (((0.23999999463558197f / _539) + -0.5f) * _557);
    } else {
      _566 = 0.0f;
    }
  } else {
    _566 = _557;
  }
  float _567 = _566 + 1.0f;
  float _568 = _567 * _511;
  float _569 = _567 * _514;
  float _570 = _567 * _517;
  if (!((bool)(_568 == _569) && (bool)(_569 == _570))) {
    float _577 = ((_568 * 2.0f) - _569) - _570;
    float _580 = ((_514 - _517) * 1.7320507764816284f) * _567;
    float _582 = atan(_580 / _577);
    bool _585 = (_577 < 0.0f);
    bool _586 = (_577 == 0.0f);
    bool _587 = (_580 >= 0.0f);
    bool _588 = (_580 < 0.0f);
    _599 = select((_587 && _586), 90.0f, select((_588 && _586), -90.0f, (select((_588 && _585), (_582 + -3.1415927410125732f), select((_587 && _585), (_582 + 3.1415927410125732f), _582)) * 57.2957763671875f)));
  } else {
    _599 = 0.0f;
  }
  float _604 = min(max(select((_599 < 0.0f), (_599 + 360.0f), _599), 0.0f), 360.0f);
  if (_604 < -180.0f) {
    _613 = (_604 + 360.0f);
  } else {
    if (_604 > 180.0f) {
      _613 = (_604 + -360.0f);
    } else {
      _613 = _604;
    }
  }
  float _617 = saturate(1.0f - abs(_613 * 0.014814814552664757f));
  float _621 = (_617 * _617) * (3.0f - (_617 * 2.0f));
  float _627 = ((_621 * _621) * ((_526 * 0.18000000715255737f) * (0.029999999329447746f - _568))) + _568;
  float _637 = max(0.0f, mad(-0.21492856740951538f, _570, mad(-0.2365107536315918f, _569, (_627 * 1.4514392614364624f))));
  float _638 = max(0.0f, mad(-0.09967592358589172f, _570, mad(1.17622971534729f, _569, (_627 * -0.07655377686023712f))));
  float _639 = max(0.0f, mad(0.9977163076400757f, _570, mad(-0.006032449658960104f, _569, (_627 * 0.008316148072481155f))));
  float _640 = dot(float3(_637, _638, _639), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _655 = (cb0_038x + 1.0f) - cb0_037z;
  float _657 = cb0_038y + 1.0f;
  float _659 = _657 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _677 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _668 = (cb0_038x + 0.18000000715255737f) / _655;
    _677 = (-0.7447274923324585f - ((log2(_668 / (2.0f - _668)) * 0.3465735912322998f) * (_655 / cb0_037y)));
  }
  float _680 = ((1.0f - cb0_037z) / cb0_037y) - _677;
  float _682 = (cb0_037w / cb0_037y) - _680;
  float _686 = log2(lerp(_640, _637, 0.9599999785423279f)) * 0.3010300099849701f;
  float _687 = log2(lerp(_640, _638, 0.9599999785423279f)) * 0.3010300099849701f;
  float _688 = log2(lerp(_640, _639, 0.9599999785423279f)) * 0.3010300099849701f;
  float _692 = cb0_037y * (_686 + _680);
  float _693 = cb0_037y * (_687 + _680);
  float _694 = cb0_037y * (_688 + _680);
  float _695 = _655 * 2.0f;
  float _697 = (cb0_037y * -2.0f) / _655;
  float _698 = _686 - _677;
  float _699 = _687 - _677;
  float _700 = _688 - _677;
  float _719 = _659 * 2.0f;
  float _721 = (cb0_037y * 2.0f) / _659;
  float _746 = select((_686 < _677), ((_695 / (exp2((_698 * 1.4426950216293335f) * _697) + 1.0f)) - cb0_038x), _692);
  float _747 = select((_687 < _677), ((_695 / (exp2((_699 * 1.4426950216293335f) * _697) + 1.0f)) - cb0_038x), _693);
  float _748 = select((_688 < _677), ((_695 / (exp2((_700 * 1.4426950216293335f) * _697) + 1.0f)) - cb0_038x), _694);
  float _755 = _682 - _677;
  float _759 = saturate(_698 / _755);
  float _760 = saturate(_699 / _755);
  float _761 = saturate(_700 / _755);
  bool _762 = (_682 < _677);
  float _766 = select(_762, (1.0f - _759), _759);
  float _767 = select(_762, (1.0f - _760), _760);
  float _768 = select(_762, (1.0f - _761), _761);
  float _787 = (((_766 * _766) * (select((_686 > _682), (_657 - (_719 / (exp2(((_686 - _682) * 1.4426950216293335f) * _721) + 1.0f))), _692) - _746)) * (3.0f - (_766 * 2.0f))) + _746;
  float _788 = (((_767 * _767) * (select((_687 > _682), (_657 - (_719 / (exp2(((_687 - _682) * 1.4426950216293335f) * _721) + 1.0f))), _693) - _747)) * (3.0f - (_767 * 2.0f))) + _747;
  float _789 = (((_768 * _768) * (select((_688 > _682), (_657 - (_719 / (exp2(((_688 - _682) * 1.4426950216293335f) * _721) + 1.0f))), _694) - _748)) * (3.0f - (_768 * 2.0f))) + _748;
  float _790 = dot(float3(_787, _788, _789), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _810 = (cb0_037x * (max(0.0f, (lerp(_790, _787, 0.9300000071525574f))) - _506)) + _506;
  float _811 = (cb0_037x * (max(0.0f, (lerp(_790, _788, 0.9300000071525574f))) - _507)) + _507;
  float _812 = (cb0_037x * (max(0.0f, (lerp(_790, _789, 0.9300000071525574f))) - _508)) + _508;
  float _828 = ((mad(-0.06537103652954102f, _812, mad(1.451815478503704e-06f, _811, (_810 * 1.065374732017517f))) - _810) * cb0_036z) + _810;
  float _829 = ((mad(-0.20366770029067993f, _812, mad(1.2036634683609009f, _811, (_810 * -2.57161445915699e-07f))) - _811) * cb0_036z) + _811;
  float _830 = ((mad(0.9999996423721313f, _812, mad(2.0954757928848267e-08f, _811, (_810 * 1.862645149230957e-08f))) - _812) * cb0_036z) + _812;

  SetTonemappedAP1(_828, _829, _830);

  float _855 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _830, mad((WorkingColorSpace_192[0].y), _829, ((WorkingColorSpace_192[0].x) * _828)))));
  float _856 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _830, mad((WorkingColorSpace_192[1].y), _829, ((WorkingColorSpace_192[1].x) * _828)))));
  float _857 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _830, mad((WorkingColorSpace_192[2].y), _829, ((WorkingColorSpace_192[2].x) * _828)))));
  if (_855 < 0.0031306699384003878f) {
    _868 = (_855 * 12.920000076293945f);
  } else {
    _868 = (((pow(_855, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_856 < 0.0031306699384003878f) {
    _879 = (_856 * 12.920000076293945f);
  } else {
    _879 = (((pow(_856, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_857 < 0.0031306699384003878f) {
    _890 = (_857 * 12.920000076293945f);
  } else {
    _890 = (((pow(_857, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _894 = (_879 * 0.9375f) + 0.03125f;
  float _901 = _890 * 15.0f;
  float _902 = floor(_901);
  float _903 = _901 - _902;
  float _905 = (((_868 * 0.9375f) + 0.03125f) + _902) * 0.0625f;
  float4 _908 = t0.Sample(s0, float2(_905, _894));
  float4 _915 = t0.Sample(s0, float2((_905 + 0.0625f), _894));
  float _934 = max(6.103519990574569e-05f, (((lerp(_908.x, _915.x, _903)) * cb0_005y) + (cb0_005x * _868)));
  float _935 = max(6.103519990574569e-05f, (((lerp(_908.y, _915.y, _903)) * cb0_005y) + (cb0_005x * _879)));
  float _936 = max(6.103519990574569e-05f, (((lerp(_908.z, _915.z, _903)) * cb0_005y) + (cb0_005x * _890)));
  float _958 = select((_934 > 0.040449999272823334f), exp2(log2((_934 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_934 * 0.07739938050508499f));
  float _959 = select((_935 > 0.040449999272823334f), exp2(log2((_935 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_935 * 0.07739938050508499f));
  float _960 = select((_936 > 0.040449999272823334f), exp2(log2((_936 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_936 * 0.07739938050508499f));
  float _986 = cb0_014x * (((cb0_039y + (cb0_039x * _958)) * _958) + cb0_039z);
  float _987 = cb0_014y * (((cb0_039y + (cb0_039x * _959)) * _959) + cb0_039z);
  float _988 = cb0_014z * (((cb0_039y + (cb0_039x * _960)) * _960) + cb0_039z);
  float _1009 = exp2(log2(max(0.0f, (lerp(_986, cb0_013x, cb0_013w)))) * cb0_040y);
  float _1010 = exp2(log2(max(0.0f, (lerp(_987, cb0_013y, cb0_013w)))) * cb0_040y);
  float _1011 = exp2(log2(max(0.0f, (lerp(_988, cb0_013z, cb0_013w)))) * cb0_040y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1009, _1010, _1011));
  }

  if (WorkingColorSpace_320 == 0) {
    float _1030 = mad((WorkingColorSpace_128[0].z), _1011, mad((WorkingColorSpace_128[0].y), _1010, ((WorkingColorSpace_128[0].x) * _1009)));
    float _1033 = mad((WorkingColorSpace_128[1].z), _1011, mad((WorkingColorSpace_128[1].y), _1010, ((WorkingColorSpace_128[1].x) * _1009)));
    float _1036 = mad((WorkingColorSpace_128[2].z), _1011, mad((WorkingColorSpace_128[2].y), _1010, ((WorkingColorSpace_128[2].x) * _1009)));
    _1047 = mad(_43, _1036, mad(_42, _1033, (_1030 * _41)));
    _1048 = mad(_46, _1036, mad(_45, _1033, (_1030 * _44)));
    _1049 = mad(_49, _1036, mad(_48, _1033, (_1030 * _47)));
  } else {
    _1047 = _1009;
    _1048 = _1010;
    _1049 = _1011;
  }
  if (_1047 < 0.0031306699384003878f) {
    _1060 = (_1047 * 12.920000076293945f);
  } else {
    _1060 = (((pow(_1047, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1048 < 0.0031306699384003878f) {
    _1071 = (_1048 * 12.920000076293945f);
  } else {
    _1071 = (((pow(_1048, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1049 < 0.0031306699384003878f) {
    _1082 = (_1049 * 12.920000076293945f);
  } else {
    _1082 = (((pow(_1049, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1060 * 0.9523810148239136f);
  SV_Target.y = (_1071 * 0.9523810148239136f);
  SV_Target.z = (_1082 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
