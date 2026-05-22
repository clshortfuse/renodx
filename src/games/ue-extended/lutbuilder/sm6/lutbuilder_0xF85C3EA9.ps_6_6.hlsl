// Directive 8020

#include "../lutbuilderoutput.hlsli"

Texture3D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
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
  int cb0_042x : packoffset(c042.x);
  int cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  precise noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _12;
  float _17;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _505;
  float _515;
  float _525;
  float _602;
  float _603;
  float _604;
  float _614;
  float _624;
  float _634;
  float _642;
  float _643;
  float _644;
  float _720;
  float _753;
  float _767;
  float _831;
  float _1095;
  float _1096;
  float _1097;
  float _1108;
  float _1119;
  float _1130;
  bool _30;
  float _62;
  float _63;
  float _64;
  float _79;
  float _82;
  float _85;
  float _86;
  float _90;
  float _91;
  float _92;
  float _104;
  float _120;
  float _121;
  float _122;
  float _123;
  float _137;
  float _151;
  float _165;
  float _179;
  float _193;
  float _197;
  float _198;
  float _199;
  float _256;
  float _260;
  float _261;
  float _270;
  float _279;
  float _288;
  float _297;
  float _306;
  float _369;
  float _373;
  float _382;
  float _391;
  float _400;
  float _409;
  float _418;
  float _476;
  float _487;
  float _489;
  float _491;
  float _529;
  float _530;
  float _531;
  float4 _536;
  float4 _544;
  float4 _549;
  float4 _554;
  float _570;
  float _571;
  float _572;
  float _573;
  float _574;
  float _575;
  float _576;
  float _594;
  float _660;
  float _661;
  float _662;
  float _665;
  float _668;
  float _671;
  float _675;
  float _680;
  float _693;
  float _694;
  float _695;
  float _696;
  float _700;
  float _711;
  float _721;
  float _722;
  float _723;
  float _724;
  float _731;
  float _734;
  float _736;
  bool _739;
  bool _740;
  bool _741;
  bool _742;
  float _758;
  float _771;
  float _775;
  float _781;
  float _791;
  float _792;
  float _793;
  float _794;
  float _809;
  float _811;
  float _813;
  float _822;
  float _834;
  float _836;
  float _840;
  float _841;
  float _842;
  float _846;
  float _847;
  float _848;
  float _849;
  float _851;
  float _852;
  float _853;
  float _854;
  float _873;
  float _875;
  float _900;
  float _901;
  float _902;
  float _909;
  float _913;
  float _914;
  float _915;
  bool _916;
  float _920;
  float _921;
  float _922;
  float _941;
  float _942;
  float _943;
  float _944;
  float _964;
  float _965;
  float _966;
  float _982;
  float _983;
  float _984;
  float _1006;
  float _1007;
  float _1008;
  float _1034;
  float _1035;
  float _1036;
  float _1057;
  float _1058;
  float _1059;
  float _1078;
  float _1081;
  float _1084;
  _12 = 0.5f / cb0_035x;
  _17 = cb0_035x + -1.0f;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        _30 = (cb0_041x == 4);
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
  _62 = (exp2((((cb0_035x * (TEXCOORD.x - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _63 = (exp2((((cb0_035x * (TEXCOORD.y - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _64 = (exp2(((float((uint)(uint)(SV_RenderTargetArrayIndex)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _79 = mad((WorkingColorSpace_128[0].z), _64, mad((WorkingColorSpace_128[0].y), _63, ((WorkingColorSpace_128[0].x) * _62)));
  _82 = mad((WorkingColorSpace_128[1].z), _64, mad((WorkingColorSpace_128[1].y), _63, ((WorkingColorSpace_128[1].x) * _62)));
  _85 = mad((WorkingColorSpace_128[2].z), _64, mad((WorkingColorSpace_128[2].y), _63, ((WorkingColorSpace_128[2].x) * _62)));
  _86 = dot(float3(_79, _82, _85), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _90 = (_79 / _86) + -1.0f;
  _91 = (_82 / _86) + -1.0f;
  _92 = (_85 / _86) + -1.0f;
  _104 = (1.0f - exp2(((_86 * _86) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_90, _91, _92), float3(_90, _91, _92)) * -4.0f));
  _120 = ((mad(-0.06368321925401688f, _85, mad(-0.3292922377586365f, _82, (_79 * 1.3704125881195068f))) - _79) * _104) + _79;
  _121 = ((mad(-0.010861365124583244f, _85, mad(1.0970927476882935f, _82, (_79 * -0.08343357592821121f))) - _82) * _104) + _82;
  _122 = ((mad(1.2036951780319214f, _85, mad(-0.09862580895423889f, _82, (_79 * -0.02579331398010254f))) - _85) * _104) + _85;
  _123 = dot(float3(_120, _121, _122), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _137 = cb0_019w + cb0_024w;
  _151 = cb0_018w * cb0_023w;
  _165 = cb0_017w * cb0_022w;
  _179 = cb0_016w * cb0_021w;
  _193 = cb0_015w * cb0_020w;
  _197 = _120 - _123;
  _198 = _121 - _123;
  _199 = _122 - _123;
  _256 = saturate(_123 / cb0_035w);
  _260 = (_256 * _256) * (3.0f - (_256 * 2.0f));
  _261 = 1.0f - _260;
  _270 = cb0_019w + cb0_034w;
  _279 = cb0_018w * cb0_033w;
  _288 = cb0_017w * cb0_032w;
  _297 = cb0_016w * cb0_031w;
  _306 = cb0_015w * cb0_030w;
  _369 = saturate((_123 - cb0_036x) / (cb0_036y - cb0_036x));
  _373 = (_369 * _369) * (3.0f - (_369 * 2.0f));
  _382 = cb0_019w + cb0_029w;
  _391 = cb0_018w * cb0_028w;
  _400 = cb0_017w * cb0_027w;
  _409 = cb0_016w * cb0_026w;
  _418 = cb0_015w * cb0_025w;
  _476 = _260 - _373;
  _487 = ((_373 * (((cb0_019x + cb0_034x) + _270) + (((cb0_018x * cb0_033x) * _279) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _297) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _306) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _288)))))) + (_261 * (((cb0_019x + cb0_024x) + _137) + (((cb0_018x * cb0_023x) * _151) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _179) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _193) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _165))))))) + ((((cb0_019x + cb0_029x) + _382) + (((cb0_018x * cb0_028x) * _391) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _409) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _418) * _197) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _400))))) * _476);
  _489 = ((_373 * (((cb0_019y + cb0_034y) + _270) + (((cb0_018y * cb0_033y) * _279) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _297) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _306) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _288)))))) + (_261 * (((cb0_019y + cb0_024y) + _137) + (((cb0_018y * cb0_023y) * _151) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _179) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _193) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _165))))))) + ((((cb0_019y + cb0_029y) + _382) + (((cb0_018y * cb0_028y) * _391) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _409) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _418) * _198) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _400))))) * _476);
  _491 = ((_373 * (((cb0_019z + cb0_034z) + _270) + (((cb0_018z * cb0_033z) * _279) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _297) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _306) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _288)))))) + (_261 * (((cb0_019z + cb0_024z) + _137) + (((cb0_018z * cb0_023z) * _151) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _179) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _193) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _165))))))) + ((((cb0_019z + cb0_029z) + _382) + (((cb0_018z * cb0_028z) * _391) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _409) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _418) * _199) + _123)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _400))))) * _476);
  if (!(cb0_042x == 0)) {
    if (_487 > 0.0078125f) {
      _505 = ((log2(_487) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _505 = ((_487 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_489 > 0.0078125f) {
      _515 = ((log2(_489) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _515 = ((_489 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_491 > 0.0078125f) {
      _525 = ((log2(_491) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _525 = ((_491 * 10.540237426757812f) + 0.072905533015728f);
    }
    _529 = min(max(_505, 0.0f), 1.0f);
    _530 = min(max(_515, 0.0f), 1.0f);
    _531 = min(max(_525, 0.0f), 1.0f);
    _536 = t0.Sample(s0, float3(_529, _530, _531));
    if (cb0_042y == 1) {
      _544 = t0.Sample(s0, float3((cb0_042z + _529), _530, _531));
      _549 = t0.Sample(s0, float3(_529, (cb0_042z + _530), _531));
      _554 = t0.Sample(s0, float3(_529, _530, (cb0_042z + _531)));
      _570 = saturate(1.0f - abs(_529 - floor(_529)));
      _571 = saturate(1.0f - abs(_530 - floor(_530)));
      _572 = saturate(1.0f - abs(_531 - floor(_531)));
      _573 = dot(float3(_570, _571, _572), float3(1.0f, 1.0f, 1.0f));
      _574 = _570 / _573;
      _575 = _571 / _573;
      _576 = _572 / _573;
      _594 = ((1.0f - _574) - _575) - _576;
      _602 = ((((_575 * _544.x) + (_574 * _536.x)) + (_576 * _549.x)) + (_594 * _554.x));
      _603 = ((((_575 * _544.y) + (_574 * _536.y)) + (_576 * _549.y)) + (_594 * _554.y));
      _604 = ((((_575 * _544.z) + (_574 * _536.z)) + (_576 * _549.z)) + (_594 * _554.z));
    } else {
      _602 = _536.x;
      _603 = _536.y;
      _604 = _536.z;
    }
    if (_602 > 0.155251145362854f) {
      _614 = exp2((_602 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _614 = ((_602 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_603 > 0.155251145362854f) {
      _624 = exp2((_603 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _624 = ((_603 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_604 > 0.155251145362854f) {
      _634 = exp2((_604 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _634 = ((_604 + -0.072905533015728f) * 0.09487452358007431f);
    }
    _642 = min(max(_614, 0.0f), 65504.0f);
    _643 = min(max(_624, 0.0f), 65504.0f);
    _644 = min(max(_634, 0.0f), 65504.0f);
  } else {
    _642 = _487;
    _643 = _489;
    _644 = _491;
  }

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
  float4 output = ProcessLutbuilder(float3(_642, _643, _644), cb_config, SV_Target, 0u);
  SV_Target = output;
  return SV_Target;
  _660 = ((mad(0.061360642313957214f, _644, mad(-4.540197551250458e-09f, _643, (_642 * 0.9386394023895264f))) - _642) * cb0_036z) + _642;
  _661 = ((mad(0.169205904006958f, _644, mad(0.8307942152023315f, _643, (_642 * 6.775371730327606e-08f))) - _643) * cb0_036z) + _643;
  _662 = (mad(-2.3283064365386963e-10f, _643, (_642 * -9.313225746154785e-10f)) * cb0_036z) + _644;
  _665 = mad(0.16386905312538147f, _662, mad(0.14067868888378143f, _661, (_660 * 0.6954522132873535f)));
  _668 = mad(0.0955343246459961f, _662, mad(0.8596711158752441f, _661, (_660 * 0.044794581830501556f)));
  _671 = mad(1.0015007257461548f, _662, mad(0.004025210160762072f, _661, (_660 * -0.005525882821530104f)));
  _675 = max(max(_665, _668), _671);
  _680 = (max(_675, 1.000000013351432e-10f) - max(min(min(_665, _668), _671), 1.000000013351432e-10f)) / max(_675, 0.009999999776482582f);
  _693 = ((_668 + _665) + _671) + (sqrt((((_671 - _668) * _671) + ((_668 - _665) * _668)) + ((_665 - _671) * _665)) * 1.75f);
  _694 = _693 * 0.3333333432674408f;
  _695 = _680 + -0.4000000059604645f;
  _696 = _695 * 5.0f;
  _700 = max((1.0f - abs(_695 * 2.5f)), 0.0f);
  _711 = ((float((int)(((int)(uint)((int)(_696 > 0.0f))) - ((int)(uint)((int)(_696 < 0.0f))))) * (1.0f - (_700 * _700))) + 1.0f) * 0.02500000037252903f;
  if (_694 > 0.0533333346247673f) {
    if (_694 < 0.1599999964237213f) {
      _720 = (((0.23999999463558197f / _693) + -0.5f) * _711);
    } else {
      _720 = 0.0f;
    }
  } else {
    _720 = _711;
  }
  _721 = _720 + 1.0f;
  _722 = _721 * _665;
  _723 = _721 * _668;
  _724 = _721 * _671;
  if (!((_722 == _723) && (_723 == _724))) {
    _731 = ((_722 * 2.0f) - _723) - _724;
    _734 = ((_668 - _671) * 1.7320507764816284f) * _721;
    _736 = atan(_734 / _731);
    _739 = (_731 < 0.0f);
    _740 = (_731 == 0.0f);
    _741 = (_734 >= 0.0f);
    _742 = (_734 < 0.0f);
    _753 = select((_741 && _740), 90.0f, select((_742 && _740), -90.0f, (select((_742 && _739), (_736 + -3.1415927410125732f), select((_741 && _739), (_736 + 3.1415927410125732f), _736)) * 57.2957763671875f)));
  } else {
    _753 = 0.0f;
  }
  _758 = min(max(select((_753 < 0.0f), (_753 + 360.0f), _753), 0.0f), 360.0f);
  if (_758 < -180.0f) {
    _767 = (_758 + 360.0f);
  } else {
    if (_758 > 180.0f) {
      _767 = (_758 + -360.0f);
    } else {
      _767 = _758;
    }
  }
  _771 = saturate(1.0f - abs(_767 * 0.014814814552664757f));
  _775 = (_771 * _771) * (3.0f - (_771 * 2.0f));
  _781 = ((_775 * _775) * ((_680 * 0.18000000715255737f) * (0.029999999329447746f - _722))) + _722;
  _791 = max(0.0f, mad(-0.21492856740951538f, _724, mad(-0.2365107536315918f, _723, (_781 * 1.4514392614364624f))));
  _792 = max(0.0f, mad(-0.09967592358589172f, _724, mad(1.17622971534729f, _723, (_781 * -0.07655377686023712f))));
  _793 = max(0.0f, mad(0.9977163076400757f, _724, mad(-0.006032449658960104f, _723, (_781 * 0.008316148072481155f))));
  _794 = dot(float3(_791, _792, _793), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _809 = (cb0_038x + 1.0f) - cb0_037z;
  _811 = cb0_038y + 1.0f;
  _813 = _811 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _831 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _822 = (cb0_038x + 0.18000000715255737f) / _809;
    _831 = (-0.7447274923324585f - ((log2(_822 / (2.0f - _822)) * 0.3465735912322998f) * (_809 / cb0_037y)));
  }
  _834 = ((1.0f - cb0_037z) / cb0_037y) - _831;
  _836 = (cb0_037w / cb0_037y) - _834;
  _840 = log2(lerp(_794, _791, 0.9599999785423279f)) * 0.3010300099849701f;
  _841 = log2(lerp(_794, _792, 0.9599999785423279f)) * 0.3010300099849701f;
  _842 = log2(lerp(_794, _793, 0.9599999785423279f)) * 0.3010300099849701f;
  _846 = cb0_037y * (_840 + _834);
  _847 = cb0_037y * (_841 + _834);
  _848 = cb0_037y * (_842 + _834);
  _849 = _809 * 2.0f;
  _851 = (cb0_037y * -2.0f) / _809;
  _852 = _840 - _831;
  _853 = _841 - _831;
  _854 = _842 - _831;
  _873 = _813 * 2.0f;
  _875 = (cb0_037y * 2.0f) / _813;
  _900 = select((_840 < _831), ((_849 / (exp2((_852 * 1.4426950216293335f) * _851) + 1.0f)) - cb0_038x), _846);
  _901 = select((_841 < _831), ((_849 / (exp2((_853 * 1.4426950216293335f) * _851) + 1.0f)) - cb0_038x), _847);
  _902 = select((_842 < _831), ((_849 / (exp2((_854 * 1.4426950216293335f) * _851) + 1.0f)) - cb0_038x), _848);
  _909 = _836 - _831;
  _913 = saturate(_852 / _909);
  _914 = saturate(_853 / _909);
  _915 = saturate(_854 / _909);
  _916 = (_836 < _831);
  _920 = select(_916, (1.0f - _913), _913);
  _921 = select(_916, (1.0f - _914), _914);
  _922 = select(_916, (1.0f - _915), _915);
  _941 = (((_920 * _920) * (select((_840 > _836), (_811 - (_873 / (exp2(((_840 - _836) * 1.4426950216293335f) * _875) + 1.0f))), _846) - _900)) * (3.0f - (_920 * 2.0f))) + _900;
  _942 = (((_921 * _921) * (select((_841 > _836), (_811 - (_873 / (exp2(((_841 - _836) * 1.4426950216293335f) * _875) + 1.0f))), _847) - _901)) * (3.0f - (_921 * 2.0f))) + _901;
  _943 = (((_922 * _922) * (select((_842 > _836), (_811 - (_873 / (exp2(((_842 - _836) * 1.4426950216293335f) * _875) + 1.0f))), _848) - _902)) * (3.0f - (_922 * 2.0f))) + _902;
  _944 = dot(float3(_941, _942, _943), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _964 = (cb0_037x * (max(0.0f, (lerp(_944, _941, 0.9300000071525574f))) - _660)) + _660;
  _965 = (cb0_037x * (max(0.0f, (lerp(_944, _942, 0.9300000071525574f))) - _661)) + _661;
  _966 = (cb0_037x * (max(0.0f, (lerp(_944, _943, 0.9300000071525574f))) - _662)) + _662;
  _982 = ((mad(-0.06537103652954102f, _966, mad(1.451815478503704e-06f, _965, (_964 * 1.065374732017517f))) - _964) * cb0_036z) + _964;
  _983 = ((mad(-0.20366770029067993f, _966, mad(1.2036634683609009f, _965, (_964 * -2.57161445915699e-07f))) - _965) * cb0_036z) + _965;
  _984 = ((mad(0.9999996423721313f, _966, mad(2.0954757928848267e-08f, _965, (_964 * 1.862645149230957e-08f))) - _966) * cb0_036z) + _966;
  _1006 = max(0.0f, mad((WorkingColorSpace_192[0].z), _984, mad((WorkingColorSpace_192[0].y), _983, ((WorkingColorSpace_192[0].x) * _982))));
  _1007 = max(0.0f, mad((WorkingColorSpace_192[1].z), _984, mad((WorkingColorSpace_192[1].y), _983, ((WorkingColorSpace_192[1].x) * _982))));
  _1008 = max(0.0f, mad((WorkingColorSpace_192[2].z), _984, mad((WorkingColorSpace_192[2].y), _983, ((WorkingColorSpace_192[2].x) * _982))));
  _1034 = cb0_014x * (((cb0_039y + (cb0_039x * _1006)) * _1006) + cb0_039z);
  _1035 = cb0_014y * (((cb0_039y + (cb0_039x * _1007)) * _1007) + cb0_039z);
  _1036 = cb0_014z * (((cb0_039y + (cb0_039x * _1008)) * _1008) + cb0_039z);
  _1057 = exp2(log2(max(0.0f, (lerp(_1034, cb0_013x, cb0_013w)))) * cb0_040y);
  _1058 = exp2(log2(max(0.0f, (lerp(_1035, cb0_013y, cb0_013w)))) * cb0_040y);
  _1059 = exp2(log2(max(0.0f, (lerp(_1036, cb0_013z, cb0_013w)))) * cb0_040y);
  if (WorkingColorSpace_320 == 0) {
    _1078 = mad((WorkingColorSpace_128[0].z), _1059, mad((WorkingColorSpace_128[0].y), _1058, ((WorkingColorSpace_128[0].x) * _1057)));
    _1081 = mad((WorkingColorSpace_128[1].z), _1059, mad((WorkingColorSpace_128[1].y), _1058, ((WorkingColorSpace_128[1].x) * _1057)));
    _1084 = mad((WorkingColorSpace_128[2].z), _1059, mad((WorkingColorSpace_128[2].y), _1058, ((WorkingColorSpace_128[2].x) * _1057)));
    _1095 = mad(_43, _1084, mad(_42, _1081, (_1078 * _41)));
    _1096 = mad(_46, _1084, mad(_45, _1081, (_1078 * _44)));
    _1097 = mad(_49, _1084, mad(_48, _1081, (_1078 * _47)));
  } else {
    _1095 = _1057;
    _1096 = _1058;
    _1097 = _1059;
  }
  if (_1095 < 0.0031306699384003878f) {
    _1108 = (_1095 * 12.920000076293945f);
  } else {
    _1108 = (((pow(_1095, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1096 < 0.0031306699384003878f) {
    _1119 = (_1096 * 12.920000076293945f);
  } else {
    _1119 = (((pow(_1096, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1097 < 0.0031306699384003878f) {
    _1130 = (_1097 * 12.920000076293945f);
  } else {
    _1130 = (((pow(_1097, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1108 * 0.9523810148239136f);
  SV_Target.y = (_1119 * 0.9523810148239136f);
  SV_Target.z = (_1130 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}