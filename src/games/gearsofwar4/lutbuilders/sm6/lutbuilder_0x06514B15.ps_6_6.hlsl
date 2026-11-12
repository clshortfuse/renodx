#include "../../common.hlsl"

// Found in The Casting of Frank Stone

Texture2D<float4> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_008x : packoffset(c008.x);
  float cb0_008y : packoffset(c008.y);
  float cb0_008z : packoffset(c008.z);
  float cb0_008w : packoffset(c008.w);
  float cb0_009x : packoffset(c009.x);
  float cb0_010x : packoffset(c010.x);
  float cb0_010y : packoffset(c010.y);
  float cb0_010z : packoffset(c010.z);
  float cb0_010w : packoffset(c010.w);
  float cb0_011x : packoffset(c011.x);
  float cb0_011y : packoffset(c011.y);
  float cb0_011z : packoffset(c011.z);
  float cb0_011w : packoffset(c011.w);
  float cb0_012x : packoffset(c012.x);
  float cb0_012y : packoffset(c012.y);
  float cb0_012z : packoffset(c012.z);
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
  float cb0_035z : packoffset(c035.z);
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
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
  int cb0_041x : packoffset(c041.x);
  int cb0_042x : packoffset(c042.x);
  int cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
};

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
  float _551;
  float _561;
  float _571;
  float _648;
  float _649;
  float _650;
  float _660;
  float _670;
  float _680;
  float _688;
  float _689;
  float _690;
  float _787;
  float _823;
  float _834;
  float _898;
  float _1077;
  float _1088;
  float _1099;
  float _1272;
  float _1273;
  float _1274;
  float _1285;
  float _1296;
  float _1478;
  float _1514;
  float _1525;
  float _1564;
  float _1674;
  float _1748;
  float _1822;
  float _1901;
  float _1902;
  float _1903;
  float _2054;
  float _2090;
  float _2101;
  float _2140;
  float _2250;
  float _2324;
  float _2398;
  float _2477;
  float _2478;
  float _2479;
  float _2656;
  float _2657;
  float _2658;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _30 = (cb0_041x == 4);
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
  if ((uint)cb0_040w > (uint)2) {
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

  SetUngradedAP1(float3(_124, _127, _130));

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
  float _533 = ((_419 * (((cb0_019x + cb0_034x) + _316) + (((cb0_018x * cb0_033x) * _325) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _343) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _352) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _334)))))) + (_307 * (((cb0_019x + cb0_024x) + _182) + (((cb0_018x * cb0_023x) * _196) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _224) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _238) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _210))))))) + ((((cb0_019x + cb0_029x) + _428) + (((cb0_018x * cb0_028x) * _437) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _455) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _464) * _242) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _446))))) * _522);
  float _535 = ((_419 * (((cb0_019y + cb0_034y) + _316) + (((cb0_018y * cb0_033y) * _325) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _343) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _352) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _334)))))) + (_307 * (((cb0_019y + cb0_024y) + _182) + (((cb0_018y * cb0_023y) * _196) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _224) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _238) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _210))))))) + ((((cb0_019y + cb0_029y) + _428) + (((cb0_018y * cb0_028y) * _437) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _455) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _464) * _243) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _446))))) * _522);
  float _537 = ((_419 * (((cb0_019z + cb0_034z) + _316) + (((cb0_018z * cb0_033z) * _325) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _343) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _352) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _334)))))) + (_307 * (((cb0_019z + cb0_024z) + _182) + (((cb0_018z * cb0_023z) * _196) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _224) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _238) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _210))))))) + ((((cb0_019z + cb0_029z) + _428) + (((cb0_018z * cb0_028z) * _437) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _455) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _464) * _244) + _168)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _446))))) * _522);

  SetUntonemappedAP1(float3(_533, _535, _537));

  if (!(cb0_042x == 0)) {
    do {
      if (_533 > 0.0078125f) {
        _551 = ((log2(_533) + 9.720000267028809f) * 0.05707762390375137f);
      } else {
        _551 = ((_533 * 10.540237426757812f) + 0.072905533015728f);
      }
      do {
        if (_535 > 0.0078125f) {
          _561 = ((log2(_535) + 9.720000267028809f) * 0.05707762390375137f);
        } else {
          _561 = ((_535 * 10.540237426757812f) + 0.072905533015728f);
        }
        do {
          if (_537 > 0.0078125f) {
            _571 = ((log2(_537) + 9.720000267028809f) * 0.05707762390375137f);
          } else {
            _571 = ((_537 * 10.540237426757812f) + 0.072905533015728f);
          }
          float _575 = min(max(_551, 0.0f), 1.0f);
          float _576 = min(max(_561, 0.0f), 1.0f);
          float _577 = min(max(_571, 0.0f), 1.0f);
          float4 _582 = t1.Sample(s1, float3(_575, _576, _577));
          do {
            if (cb0_042y == 1) {
              float4 _590 = t1.Sample(s1, float3((cb0_042z + _575), _576, _577));
              float4 _595 = t1.Sample(s1, float3(_575, (cb0_042z + _576), _577));
              float4 _600 = t1.Sample(s1, float3(_575, _576, (cb0_042z + _577)));
              float _616 = saturate(1.0f - abs(_575 - floor(_575)));
              float _617 = saturate(1.0f - abs(_576 - floor(_576)));
              float _618 = saturate(1.0f - abs(_577 - floor(_577)));
              float _619 = dot(float3(_616, _617, _618), float3(1.0f, 1.0f, 1.0f));
              float _620 = _616 / _619;
              float _621 = _617 / _619;
              float _622 = _618 / _619;
              float _640 = ((1.0f - _620) - _621) - _622;
              _648 = ((((_621 * _590.x) + (_620 * _582.x)) + (_622 * _595.x)) + (_640 * _600.x));
              _649 = ((((_621 * _590.y) + (_620 * _582.y)) + (_622 * _595.y)) + (_640 * _600.y));
              _650 = ((((_621 * _590.z) + (_620 * _582.z)) + (_622 * _595.z)) + (_640 * _600.z));
            } else {
              _648 = _582.x;
              _649 = _582.y;
              _650 = _582.z;
            }
            do {
              if (_648 > 0.155251145362854f) {
                _660 = exp2((_648 * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _660 = ((_648 + -0.072905533015728f) * 0.09487452358007431f);
              }
              do {
                if (_649 > 0.155251145362854f) {
                  _670 = exp2((_649 * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _670 = ((_649 + -0.072905533015728f) * 0.09487452358007431f);
                }
                do {
                  if (_650 > 0.155251145362854f) {
                    _680 = exp2((_650 * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _680 = ((_650 + -0.072905533015728f) * 0.09487452358007431f);
                  }
                  _688 = min(max(_660, 0.0f), 65504.0f);
                  _689 = min(max(_670, 0.0f), 65504.0f);
                  _690 = min(max(_680, 0.0f), 65504.0f);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _688 = _533;
    _689 = _535;
    _690 = _537;
  }
  float _727 = ((mad(0.061360642313957214f, _690, mad(-4.540197551250458e-09f, _689, (_688 * 0.9386394023895264f))) - _688) * cb0_036y) + _688;
  float _728 = ((mad(0.169205904006958f, _690, mad(0.8307942152023315f, _689, (_688 * 6.775371730327606e-08f))) - _689) * cb0_036y) + _689;
  float _729 = (mad(-2.3283064365386963e-10f, _689, (_688 * -9.313225746154785e-10f)) * cb0_036y) + _690;
  float _732 = mad(0.16386905312538147f, _729, mad(0.14067868888378143f, _728, (_727 * 0.6954522132873535f)));
  float _735 = mad(0.0955343246459961f, _729, mad(0.8596711158752441f, _728, (_727 * 0.044794581830501556f)));
  float _738 = mad(1.0015007257461548f, _729, mad(0.004025210160762072f, _728, (_727 * -0.005525882821530104f)));
  float _742 = max(max(_732, _735), _738);
  float _747 = (max(_742, 1.000000013351432e-10f) - max(min(min(_732, _735), _738), 1.000000013351432e-10f)) / max(_742, 0.009999999776482582f);
  float _760 = ((_735 + _732) + _738) + (sqrt((((_738 - _735) * _738) + ((_735 - _732) * _735)) + ((_732 - _738) * _732)) * 1.75f);
  float _761 = _760 * 0.3333333432674408f;
  float _762 = _747 + -0.4000000059604645f;
  float _763 = _762 * 5.0f;
  float _767 = max((1.0f - abs(_762 * 2.5f)), 0.0f);
  float _778 = ((float((int)(((int)(uint)((bool)(_763 > 0.0f))) - ((int)(uint)((bool)(_763 < 0.0f))))) * (1.0f - (_767 * _767))) + 1.0f) * 0.02500000037252903f;
  if (!(_761 <= 0.0533333346247673f)) {
    if (!(_761 >= 0.1599999964237213f)) {
      _787 = (((0.23999999463558197f / _760) + -0.5f) * _778);
    } else {
      _787 = 0.0f;
    }
  } else {
    _787 = _778;
  }
  float _788 = _787 + 1.0f;
  float _789 = _788 * _732;
  float _790 = _788 * _735;
  float _791 = _788 * _738;
  if (!((bool)(_789 == _790) && (bool)(_790 == _791))) {
    float _798 = ((_789 * 2.0f) - _790) - _791;
    float _801 = ((_735 - _738) * 1.7320507764816284f) * _788;
    float _803 = atan(_801 / _798);
    bool _806 = (_798 < 0.0f);
    bool _807 = (_798 == 0.0f);
    bool _808 = (_801 >= 0.0f);
    bool _809 = (_801 < 0.0f);
    float _818 = select((_808 && _807), 90.0f, select((_809 && _807), -90.0f, (select((_809 && _806), (_803 + -3.1415927410125732f), select((_808 && _806), (_803 + 3.1415927410125732f), _803)) * 57.2957763671875f)));
    if (_818 < 0.0f) {
      _823 = (_818 + 360.0f);
    } else {
      _823 = _818;
    }
  } else {
    _823 = 0.0f;
  }
  float _825 = min(max(_823, 0.0f), 360.0f);
  if (_825 < -180.0f) {
    _834 = (_825 + 360.0f);
  } else {
    if (_825 > 180.0f) {
      _834 = (_825 + -360.0f);
    } else {
      _834 = _825;
    }
  }
  float _838 = saturate(1.0f - abs(_834 * 0.014814814552664757f));
  float _842 = (_838 * _838) * (3.0f - (_838 * 2.0f));
  float _848 = ((_842 * _842) * ((_747 * 0.18000000715255737f) * (0.029999999329447746f - _789))) + _789;
  float _858 = max(0.0f, mad(-0.21492856740951538f, _791, mad(-0.2365107536315918f, _790, (_848 * 1.4514392614364624f))));
  float _859 = max(0.0f, mad(-0.09967592358589172f, _791, mad(1.17622971534729f, _790, (_848 * -0.07655377686023712f))));
  float _860 = max(0.0f, mad(0.9977163076400757f, _791, mad(-0.006032449658960104f, _790, (_848 * 0.008316148072481155f))));
  float _861 = dot(float3(_858, _859, _860), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _875 = (cb0_037w + 1.0f) - cb0_037y;
  float _878 = cb0_038x + 1.0f;
  float _880 = _878 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _898 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _889 = (cb0_037w + 0.18000000715255737f) / _875;
    _898 = (-0.7447274923324585f - ((log2(_889 / (2.0f - _889)) * 0.3465735912322998f) * (_875 / cb0_037x)));
  }
  float _901 = ((1.0f - cb0_037y) / cb0_037x) - _898;
  float _903 = (cb0_037z / cb0_037x) - _901;
  float _907 = log2(lerp(_861, _858, 0.9599999785423279f)) * 0.3010300099849701f;
  float _908 = log2(lerp(_861, _859, 0.9599999785423279f)) * 0.3010300099849701f;
  float _909 = log2(lerp(_861, _860, 0.9599999785423279f)) * 0.3010300099849701f;
  float _913 = cb0_037x * (_907 + _901);
  float _914 = cb0_037x * (_908 + _901);
  float _915 = cb0_037x * (_909 + _901);
  float _916 = _875 * 2.0f;
  float _918 = (cb0_037x * -2.0f) / _875;
  float _919 = _907 - _898;
  float _920 = _908 - _898;
  float _921 = _909 - _898;
  float _940 = _880 * 2.0f;
  float _942 = (cb0_037x * 2.0f) / _880;
  float _967 = select((_907 < _898), ((_916 / (exp2((_919 * 1.4426950216293335f) * _918) + 1.0f)) - cb0_037w), _913);
  float _968 = select((_908 < _898), ((_916 / (exp2((_920 * 1.4426950216293335f) * _918) + 1.0f)) - cb0_037w), _914);
  float _969 = select((_909 < _898), ((_916 / (exp2((_921 * 1.4426950216293335f) * _918) + 1.0f)) - cb0_037w), _915);
  float _976 = _903 - _898;
  float _980 = saturate(_919 / _976);
  float _981 = saturate(_920 / _976);
  float _982 = saturate(_921 / _976);
  bool _983 = (_903 < _898);
  float _987 = select(_983, (1.0f - _980), _980);
  float _988 = select(_983, (1.0f - _981), _981);
  float _989 = select(_983, (1.0f - _982), _982);
  float _1008 = (((_987 * _987) * (select((_907 > _903), (_878 - (_940 / (exp2(((_907 - _903) * 1.4426950216293335f) * _942) + 1.0f))), _913) - _967)) * (3.0f - (_987 * 2.0f))) + _967;
  float _1009 = (((_988 * _988) * (select((_908 > _903), (_878 - (_940 / (exp2(((_908 - _903) * 1.4426950216293335f) * _942) + 1.0f))), _914) - _968)) * (3.0f - (_988 * 2.0f))) + _968;
  float _1010 = (((_989 * _989) * (select((_909 > _903), (_878 - (_940 / (exp2(((_909 - _903) * 1.4426950216293335f) * _942) + 1.0f))), _915) - _969)) * (3.0f - (_989 * 2.0f))) + _969;
  float _1011 = dot(float3(_1008, _1009, _1010), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1031 = (cb0_036w * (max(0.0f, (lerp(_1011, _1008, 0.9300000071525574f))) - _727)) + _727;
  float _1032 = (cb0_036w * (max(0.0f, (lerp(_1011, _1009, 0.9300000071525574f))) - _728)) + _728;
  float _1033 = (cb0_036w * (max(0.0f, (lerp(_1011, _1010, 0.9300000071525574f))) - _729)) + _729;
  float _1049 = ((mad(-0.06537103652954102f, _1033, mad(1.451815478503704e-06f, _1032, (_1031 * 1.065374732017517f))) - _1031) * cb0_036y) + _1031;
  float _1050 = ((mad(-0.20366770029067993f, _1033, mad(1.2036634683609009f, _1032, (_1031 * -2.57161445915699e-07f))) - _1032) * cb0_036y) + _1032;
  float _1051 = ((mad(0.9999996423721313f, _1033, mad(2.0954757928848267e-08f, _1032, (_1031 * 1.862645149230957e-08f))) - _1033) * cb0_036y) + _1033;

  SetTonemappedAP1(_1049, _1050, _1051);

  float _1064 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1051, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1050, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1049)))));
  float _1065 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1051, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1050, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1049)))));
  float _1066 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1051, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1050, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1049)))));
  if (_1064 < 0.0031306699384003878f) {
    _1077 = (_1064 * 12.920000076293945f);
  } else {
    _1077 = (((pow(_1064, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1065 < 0.0031306699384003878f) {
    _1088 = (_1065 * 12.920000076293945f);
  } else {
    _1088 = (((pow(_1065, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1066 < 0.0031306699384003878f) {
    _1099 = (_1066 * 12.920000076293945f);
  } else {
    _1099 = (((pow(_1066, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1103 = (_1088 * 0.9375f) + 0.03125f;
  float _1110 = _1099 * 15.0f;
  float _1111 = floor(_1110);
  float _1112 = _1110 - _1111;
  float _1114 = (((_1077 * 0.9375f) + 0.03125f) + _1111) * 0.0625f;
  float4 _1117 = t0.Sample(s0, float2(_1114, _1103));
  float4 _1124 = t0.Sample(s0, float2((_1114 + 0.0625f), _1103));
  float _1143 = max(6.103519990574569e-05f, (((lerp(_1117.x, _1124.x, _1112)) * cb0_005y) + (cb0_005x * _1077)));
  float _1144 = max(6.103519990574569e-05f, (((lerp(_1117.y, _1124.y, _1112)) * cb0_005y) + (cb0_005x * _1088)));
  float _1145 = max(6.103519990574569e-05f, (((lerp(_1117.z, _1124.z, _1112)) * cb0_005y) + (cb0_005x * _1099)));
  float _1167 = select((_1143 > 0.040449999272823334f), exp2(log2((_1143 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1143 * 0.07739938050508499f));
  float _1168 = select((_1144 > 0.040449999272823334f), exp2(log2((_1144 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1144 * 0.07739938050508499f));
  float _1169 = select((_1145 > 0.040449999272823334f), exp2(log2((_1145 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1145 * 0.07739938050508499f));
  float _1195 = cb0_014x * (((cb0_039y + (cb0_039x * _1167)) * _1167) + cb0_039z);
  float _1196 = cb0_014y * (((cb0_039y + (cb0_039x * _1168)) * _1168) + cb0_039z);
  float _1197 = cb0_014z * (((cb0_039y + (cb0_039x * _1169)) * _1169) + cb0_039z);
  float _1204 = ((cb0_013x - _1195) * cb0_013w) + _1195;
  float _1205 = ((cb0_013y - _1196) * cb0_013w) + _1196;
  float _1206 = ((cb0_013z - _1197) * cb0_013w) + _1197;
  float _1207 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _690, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _689, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _688)));
  float _1208 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _690, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _689, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _688)));
  float _1209 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _690, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _689, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _688)));
  float _1216 = ((cb0_013x - _1207) * cb0_013w) + _1207;
  float _1217 = ((cb0_013y - _1208) * cb0_013w) + _1208;
  float _1218 = ((cb0_013z - _1209) * cb0_013w) + _1209;
  float _1230 = exp2(log2(max(0.0f, _1204)) * cb0_040y);
  float _1231 = exp2(log2(max(0.0f, _1205)) * cb0_040y);
  float _1232 = exp2(log2(max(0.0f, _1206)) * cb0_040y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1230, _1231, _1232), cb0_040w);
  }

  [branch]
  if (cb0_040w == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1255 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1230)));
        float _1258 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1230)));
        float _1261 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1230)));
        _1272 = mad(_43, _1261, mad(_42, _1258, (_1255 * _41)));
        _1273 = mad(_46, _1261, mad(_45, _1258, (_1255 * _44)));
        _1274 = mad(_49, _1261, mad(_48, _1258, (_1255 * _47)));
      } else {
        _1272 = _1230;
        _1273 = _1231;
        _1274 = _1232;
      }
      do {
        if (_1272 < 0.0031306699384003878f) {
          _1285 = (_1272 * 12.920000076293945f);
        } else {
          _1285 = (((pow(_1272, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1273 < 0.0031306699384003878f) {
            _1296 = (_1273 * 12.920000076293945f);
          } else {
            _1296 = (((pow(_1273, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1274 < 0.0031306699384003878f) {
            _2656 = _1285;
            _2657 = _1296;
            _2658 = (_1274 * 12.920000076293945f);
          } else {
            _2656 = _1285;
            _2657 = _1296;
            _2658 = (((pow(_1274, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1323 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1230)));
      float _1326 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1230)));
      float _1329 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1230)));
      float _1339 = max(6.103519990574569e-05f, mad(_43, _1329, mad(_42, _1326, (_1323 * _41))));
      float _1340 = max(6.103519990574569e-05f, mad(_46, _1329, mad(_45, _1326, (_1323 * _44))));
      float _1341 = max(6.103519990574569e-05f, mad(_49, _1329, mad(_48, _1326, (_1323 * _47))));
      _2656 = min((_1339 * 4.5f), ((exp2(log2(max(_1339, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2657 = min((_1340 * 4.5f), ((exp2(log2(max(_1340, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2658 = min((_1341 * 4.5f), ((exp2(log2(max(_1341, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1418 = cb0_012z * _1216;
        float _1419 = cb0_012z * _1217;
        float _1420 = cb0_012z * _1218;
        float _1423 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1420, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1419, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1418)));
        float _1426 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1420, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1419, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1418)));
        float _1429 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1420, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1419, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1418)));
        float _1433 = max(max(_1423, _1426), _1429);
        float _1438 = (max(_1433, 1.000000013351432e-10f) - max(min(min(_1423, _1426), _1429), 1.000000013351432e-10f)) / max(_1433, 0.009999999776482582f);
        float _1451 = ((_1426 + _1423) + _1429) + (sqrt((((_1429 - _1426) * _1429) + ((_1426 - _1423) * _1426)) + ((_1423 - _1429) * _1423)) * 1.75f);
        float _1452 = _1451 * 0.3333333432674408f;
        float _1453 = _1438 + -0.4000000059604645f;
        float _1454 = _1453 * 5.0f;
        float _1458 = max((1.0f - abs(_1453 * 2.5f)), 0.0f);
        float _1469 = ((float((int)(((int)(uint)((bool)(_1454 > 0.0f))) - ((int)(uint)((bool)(_1454 < 0.0f))))) * (1.0f - (_1458 * _1458))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1452 <= 0.0533333346247673f)) {
            if (!(_1452 >= 0.1599999964237213f)) {
              _1478 = (((0.23999999463558197f / _1451) + -0.5f) * _1469);
            } else {
              _1478 = 0.0f;
            }
          } else {
            _1478 = _1469;
          }
          float _1479 = _1478 + 1.0f;
          float _1480 = _1479 * _1423;
          float _1481 = _1479 * _1426;
          float _1482 = _1479 * _1429;
          do {
            if (!((bool)(_1480 == _1481) && (bool)(_1481 == _1482))) {
              float _1489 = ((_1480 * 2.0f) - _1481) - _1482;
              float _1492 = ((_1426 - _1429) * 1.7320507764816284f) * _1479;
              float _1494 = atan(_1492 / _1489);
              bool _1497 = (_1489 < 0.0f);
              bool _1498 = (_1489 == 0.0f);
              bool _1499 = (_1492 >= 0.0f);
              bool _1500 = (_1492 < 0.0f);
              float _1509 = select((_1499 && _1498), 90.0f, select((_1500 && _1498), -90.0f, (select((_1500 && _1497), (_1494 + -3.1415927410125732f), select((_1499 && _1497), (_1494 + 3.1415927410125732f), _1494)) * 57.2957763671875f)));
              if (_1509 < 0.0f) {
                _1514 = (_1509 + 360.0f);
              } else {
                _1514 = _1509;
              }
            } else {
              _1514 = 0.0f;
            }
            float _1516 = min(max(_1514, 0.0f), 360.0f);
            do {
              if (_1516 < -180.0f) {
                _1525 = (_1516 + 360.0f);
              } else {
                if (_1516 > 180.0f) {
                  _1525 = (_1516 + -360.0f);
                } else {
                  _1525 = _1516;
                }
              }
              do {
                if ((bool)(_1525 > -67.5f) && (bool)(_1525 < 67.5f)) {
                  float _1531 = (_1525 + 67.5f) * 0.029629629105329514f;
                  int _1532 = int(_1531);
                  float _1534 = _1531 - float((int)(_1532));
                  float _1535 = _1534 * _1534;
                  float _1536 = _1535 * _1534;
                  if (_1532 == 3) {
                    _1564 = (((0.1666666716337204f - (_1534 * 0.5f)) + (_1535 * 0.5f)) - (_1536 * 0.1666666716337204f));
                  } else {
                    if (_1532 == 2) {
                      _1564 = ((0.6666666865348816f - _1535) + (_1536 * 0.5f));
                    } else {
                      if (_1532 == 1) {
                        _1564 = (((_1536 * -0.5f) + 0.1666666716337204f) + ((_1535 + _1534) * 0.5f));
                      } else {
                        _1564 = select((_1532 == 0), (_1536 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1564 = 0.0f;
                }
                float _1573 = min(max(((((_1438 * 0.27000001072883606f) * (0.029999999329447746f - _1480)) * _1564) + _1480), 0.0f), 65535.0f);
                float _1574 = min(max(_1481, 0.0f), 65535.0f);
                float _1575 = min(max(_1482, 0.0f), 65535.0f);
                float _1588 = min(max(mad(-0.21492856740951538f, _1575, mad(-0.2365107536315918f, _1574, (_1573 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1589 = min(max(mad(-0.09967592358589172f, _1575, mad(1.17622971534729f, _1574, (_1573 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1590 = min(max(mad(0.9977163076400757f, _1575, mad(-0.006032449658960104f, _1574, (_1573 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1591 = dot(float3(_1588, _1589, _1590), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1602 = log2(max((lerp(_1591, _1588, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1603 = _1602 * 0.3010300099849701f;
                float _1604 = log2(cb0_008x);
                float _1605 = _1604 * 0.3010300099849701f;
                do {
                  if (!(!(_1603 <= _1605))) {
                    _1674 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1612 = log2(cb0_009x);
                    float _1613 = _1612 * 0.3010300099849701f;
                    if ((bool)(_1603 > _1605) && (bool)(_1603 < _1613)) {
                      float _1621 = ((_1602 - _1604) * 0.9030900001525879f) / ((_1612 - _1604) * 0.3010300099849701f);
                      int _1622 = int(_1621);
                      float _1624 = _1621 - float((int)(_1622));
                      float _1626 = _14[_1622];
                      float _1629 = _14[(_1622 + 1)];
                      float _1634 = _1626 * 0.5f;
                      _1674 = dot(float3((_1624 * _1624), _1624, 1.0f), float3(mad((_14[(_1622 + 2)]), 0.5f, mad(_1629, -1.0f, _1634)), (_1629 - _1626), mad(_1629, 0.5f, _1634)));
                    } else {
                      do {
                        if (!(!(_1603 >= _1613))) {
                          float _1643 = log2(cb0_008z);
                          if (_1603 < (_1643 * 0.3010300099849701f)) {
                            float _1651 = ((_1602 - _1612) * 0.9030900001525879f) / ((_1643 - _1612) * 0.3010300099849701f);
                            int _1652 = int(_1651);
                            float _1654 = _1651 - float((int)(_1652));
                            float _1656 = _15[_1652];
                            float _1659 = _15[(_1652 + 1)];
                            float _1664 = _1656 * 0.5f;
                            _1674 = dot(float3((_1654 * _1654), _1654, 1.0f), float3(mad((_15[(_1652 + 2)]), 0.5f, mad(_1659, -1.0f, _1664)), (_1659 - _1656), mad(_1659, 0.5f, _1664)));
                            break;
                          }
                        }
                        _1674 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1678 = log2(max((lerp(_1591, _1589, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1679 = _1678 * 0.3010300099849701f;
                  do {
                    if (!(!(_1679 <= _1605))) {
                      _1748 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1686 = log2(cb0_009x);
                      float _1687 = _1686 * 0.3010300099849701f;
                      if ((bool)(_1679 > _1605) && (bool)(_1679 < _1687)) {
                        float _1695 = ((_1678 - _1604) * 0.9030900001525879f) / ((_1686 - _1604) * 0.3010300099849701f);
                        int _1696 = int(_1695);
                        float _1698 = _1695 - float((int)(_1696));
                        float _1700 = _14[_1696];
                        float _1703 = _14[(_1696 + 1)];
                        float _1708 = _1700 * 0.5f;
                        _1748 = dot(float3((_1698 * _1698), _1698, 1.0f), float3(mad((_14[(_1696 + 2)]), 0.5f, mad(_1703, -1.0f, _1708)), (_1703 - _1700), mad(_1703, 0.5f, _1708)));
                      } else {
                        do {
                          if (!(!(_1679 >= _1687))) {
                            float _1717 = log2(cb0_008z);
                            if (_1679 < (_1717 * 0.3010300099849701f)) {
                              float _1725 = ((_1678 - _1686) * 0.9030900001525879f) / ((_1717 - _1686) * 0.3010300099849701f);
                              int _1726 = int(_1725);
                              float _1728 = _1725 - float((int)(_1726));
                              float _1730 = _15[_1726];
                              float _1733 = _15[(_1726 + 1)];
                              float _1738 = _1730 * 0.5f;
                              _1748 = dot(float3((_1728 * _1728), _1728, 1.0f), float3(mad((_15[(_1726 + 2)]), 0.5f, mad(_1733, -1.0f, _1738)), (_1733 - _1730), mad(_1733, 0.5f, _1738)));
                              break;
                            }
                          }
                          _1748 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1752 = log2(max((lerp(_1591, _1590, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1753 = _1752 * 0.3010300099849701f;
                    do {
                      if (!(!(_1753 <= _1605))) {
                        _1822 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1760 = log2(cb0_009x);
                        float _1761 = _1760 * 0.3010300099849701f;
                        if ((bool)(_1753 > _1605) && (bool)(_1753 < _1761)) {
                          float _1769 = ((_1752 - _1604) * 0.9030900001525879f) / ((_1760 - _1604) * 0.3010300099849701f);
                          int _1770 = int(_1769);
                          float _1772 = _1769 - float((int)(_1770));
                          float _1774 = _14[_1770];
                          float _1777 = _14[(_1770 + 1)];
                          float _1782 = _1774 * 0.5f;
                          _1822 = dot(float3((_1772 * _1772), _1772, 1.0f), float3(mad((_14[(_1770 + 2)]), 0.5f, mad(_1777, -1.0f, _1782)), (_1777 - _1774), mad(_1777, 0.5f, _1782)));
                        } else {
                          do {
                            if (!(!(_1753 >= _1761))) {
                              float _1791 = log2(cb0_008z);
                              if (_1753 < (_1791 * 0.3010300099849701f)) {
                                float _1799 = ((_1752 - _1760) * 0.9030900001525879f) / ((_1791 - _1760) * 0.3010300099849701f);
                                int _1800 = int(_1799);
                                float _1802 = _1799 - float((int)(_1800));
                                float _1804 = _15[_1800];
                                float _1807 = _15[(_1800 + 1)];
                                float _1812 = _1804 * 0.5f;
                                _1822 = dot(float3((_1802 * _1802), _1802, 1.0f), float3(mad((_15[(_1800 + 2)]), 0.5f, mad(_1807, -1.0f, _1812)), (_1807 - _1804), mad(_1807, 0.5f, _1812)));
                                break;
                              }
                            }
                            _1822 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1826 = cb0_008w - cb0_008y;
                      float _1827 = (exp2(_1674 * 3.321928024291992f) - cb0_008y) / _1826;
                      float _1829 = (exp2(_1748 * 3.321928024291992f) - cb0_008y) / _1826;
                      float _1831 = (exp2(_1822 * 3.321928024291992f) - cb0_008y) / _1826;
                      float _1834 = mad(0.15618768334388733f, _1831, mad(0.13400420546531677f, _1829, (_1827 * 0.6624541878700256f)));
                      float _1837 = mad(0.053689517080783844f, _1831, mad(0.6740817427635193f, _1829, (_1827 * 0.2722287178039551f)));
                      float _1840 = mad(1.0103391408920288f, _1831, mad(0.00406073359772563f, _1829, (_1827 * -0.005574649665504694f)));
                      float _1853 = min(max(mad(-0.23642469942569733f, _1840, mad(-0.32480329275131226f, _1837, (_1834 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1854 = min(max(mad(0.016756348311901093f, _1840, mad(1.6153316497802734f, _1837, (_1834 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1855 = min(max(mad(0.9883948564529419f, _1840, mad(-0.008284442126750946f, _1837, (_1834 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1858 = mad(0.15618768334388733f, _1855, mad(0.13400420546531677f, _1854, (_1853 * 0.6624541878700256f)));
                      float _1861 = mad(0.053689517080783844f, _1855, mad(0.6740817427635193f, _1854, (_1853 * 0.2722287178039551f)));
                      float _1864 = mad(1.0103391408920288f, _1855, mad(0.00406073359772563f, _1854, (_1853 * -0.005574649665504694f)));
                      float _1886 = min(max((min(max(mad(-0.23642469942569733f, _1864, mad(-0.32480329275131226f, _1861, (_1858 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1887 = min(max((min(max(mad(0.016756348311901093f, _1864, mad(1.6153316497802734f, _1861, (_1858 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1888 = min(max((min(max(mad(0.9883948564529419f, _1864, mad(-0.008284442126750946f, _1861, (_1858 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(cb0_040w == 5)) {
                          _1901 = mad(_43, _1888, mad(_42, _1887, (_1886 * _41)));
                          _1902 = mad(_46, _1888, mad(_45, _1887, (_1886 * _44)));
                          _1903 = mad(_49, _1888, mad(_48, _1887, (_1886 * _47)));
                        } else {
                          _1901 = _1886;
                          _1902 = _1887;
                          _1903 = _1888;
                        }
                        float _1913 = exp2(log2(_1901 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1914 = exp2(log2(_1902 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1915 = exp2(log2(_1903 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2656 = exp2(log2((1.0f / ((_1913 * 18.6875f) + 1.0f)) * ((_1913 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2657 = exp2(log2((1.0f / ((_1914 * 18.6875f) + 1.0f)) * ((_1914 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2658 = exp2(log2((1.0f / ((_1915 * 18.6875f) + 1.0f)) * ((_1915 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((cb0_040w & -3) == 4) {
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
          float _1994 = cb0_012z * _1216;
          float _1995 = cb0_012z * _1217;
          float _1996 = cb0_012z * _1218;
          float _1999 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1996, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1995, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1994)));
          float _2002 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1996, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1995, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1994)));
          float _2005 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1996, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1995, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1994)));
          float _2009 = max(max(_1999, _2002), _2005);
          float _2014 = (max(_2009, 1.000000013351432e-10f) - max(min(min(_1999, _2002), _2005), 1.000000013351432e-10f)) / max(_2009, 0.009999999776482582f);
          float _2027 = ((_2002 + _1999) + _2005) + (sqrt((((_2005 - _2002) * _2005) + ((_2002 - _1999) * _2002)) + ((_1999 - _2005) * _1999)) * 1.75f);
          float _2028 = _2027 * 0.3333333432674408f;
          float _2029 = _2014 + -0.4000000059604645f;
          float _2030 = _2029 * 5.0f;
          float _2034 = max((1.0f - abs(_2029 * 2.5f)), 0.0f);
          float _2045 = ((float((int)(((int)(uint)((bool)(_2030 > 0.0f))) - ((int)(uint)((bool)(_2030 < 0.0f))))) * (1.0f - (_2034 * _2034))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2028 <= 0.0533333346247673f)) {
              if (!(_2028 >= 0.1599999964237213f)) {
                _2054 = (((0.23999999463558197f / _2027) + -0.5f) * _2045);
              } else {
                _2054 = 0.0f;
              }
            } else {
              _2054 = _2045;
            }
            float _2055 = _2054 + 1.0f;
            float _2056 = _2055 * _1999;
            float _2057 = _2055 * _2002;
            float _2058 = _2055 * _2005;
            do {
              if (!((bool)(_2056 == _2057) && (bool)(_2057 == _2058))) {
                float _2065 = ((_2056 * 2.0f) - _2057) - _2058;
                float _2068 = ((_2002 - _2005) * 1.7320507764816284f) * _2055;
                float _2070 = atan(_2068 / _2065);
                bool _2073 = (_2065 < 0.0f);
                bool _2074 = (_2065 == 0.0f);
                bool _2075 = (_2068 >= 0.0f);
                bool _2076 = (_2068 < 0.0f);
                float _2085 = select((_2075 && _2074), 90.0f, select((_2076 && _2074), -90.0f, (select((_2076 && _2073), (_2070 + -3.1415927410125732f), select((_2075 && _2073), (_2070 + 3.1415927410125732f), _2070)) * 57.2957763671875f)));
                if (_2085 < 0.0f) {
                  _2090 = (_2085 + 360.0f);
                } else {
                  _2090 = _2085;
                }
              } else {
                _2090 = 0.0f;
              }
              float _2092 = min(max(_2090, 0.0f), 360.0f);
              do {
                if (_2092 < -180.0f) {
                  _2101 = (_2092 + 360.0f);
                } else {
                  if (_2092 > 180.0f) {
                    _2101 = (_2092 + -360.0f);
                  } else {
                    _2101 = _2092;
                  }
                }
                do {
                  if ((bool)(_2101 > -67.5f) && (bool)(_2101 < 67.5f)) {
                    float _2107 = (_2101 + 67.5f) * 0.029629629105329514f;
                    int _2108 = int(_2107);
                    float _2110 = _2107 - float((int)(_2108));
                    float _2111 = _2110 * _2110;
                    float _2112 = _2111 * _2110;
                    if (_2108 == 3) {
                      _2140 = (((0.1666666716337204f - (_2110 * 0.5f)) + (_2111 * 0.5f)) - (_2112 * 0.1666666716337204f));
                    } else {
                      if (_2108 == 2) {
                        _2140 = ((0.6666666865348816f - _2111) + (_2112 * 0.5f));
                      } else {
                        if (_2108 == 1) {
                          _2140 = (((_2112 * -0.5f) + 0.1666666716337204f) + ((_2111 + _2110) * 0.5f));
                        } else {
                          _2140 = select((_2108 == 0), (_2112 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2140 = 0.0f;
                  }
                  float _2149 = min(max(((((_2014 * 0.27000001072883606f) * (0.029999999329447746f - _2056)) * _2140) + _2056), 0.0f), 65535.0f);
                  float _2150 = min(max(_2057, 0.0f), 65535.0f);
                  float _2151 = min(max(_2058, 0.0f), 65535.0f);
                  float _2164 = min(max(mad(-0.21492856740951538f, _2151, mad(-0.2365107536315918f, _2150, (_2149 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2165 = min(max(mad(-0.09967592358589172f, _2151, mad(1.17622971534729f, _2150, (_2149 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2166 = min(max(mad(0.9977163076400757f, _2151, mad(-0.006032449658960104f, _2150, (_2149 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2167 = dot(float3(_2164, _2165, _2166), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2178 = log2(max((lerp(_2167, _2164, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2179 = _2178 * 0.3010300099849701f;
                  float _2180 = log2(cb0_008x);
                  float _2181 = _2180 * 0.3010300099849701f;
                  do {
                    if (!(!(_2179 <= _2181))) {
                      _2250 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2188 = log2(cb0_009x);
                      float _2189 = _2188 * 0.3010300099849701f;
                      if ((bool)(_2179 > _2181) && (bool)(_2179 < _2189)) {
                        float _2197 = ((_2178 - _2180) * 0.9030900001525879f) / ((_2188 - _2180) * 0.3010300099849701f);
                        int _2198 = int(_2197);
                        float _2200 = _2197 - float((int)(_2198));
                        float _2202 = _12[_2198];
                        float _2205 = _12[(_2198 + 1)];
                        float _2210 = _2202 * 0.5f;
                        _2250 = dot(float3((_2200 * _2200), _2200, 1.0f), float3(mad((_12[(_2198 + 2)]), 0.5f, mad(_2205, -1.0f, _2210)), (_2205 - _2202), mad(_2205, 0.5f, _2210)));
                      } else {
                        do {
                          if (!(!(_2179 >= _2189))) {
                            float _2219 = log2(cb0_008z);
                            if (_2179 < (_2219 * 0.3010300099849701f)) {
                              float _2227 = ((_2178 - _2188) * 0.9030900001525879f) / ((_2219 - _2188) * 0.3010300099849701f);
                              int _2228 = int(_2227);
                              float _2230 = _2227 - float((int)(_2228));
                              float _2232 = _13[_2228];
                              float _2235 = _13[(_2228 + 1)];
                              float _2240 = _2232 * 0.5f;
                              _2250 = dot(float3((_2230 * _2230), _2230, 1.0f), float3(mad((_13[(_2228 + 2)]), 0.5f, mad(_2235, -1.0f, _2240)), (_2235 - _2232), mad(_2235, 0.5f, _2240)));
                              break;
                            }
                          }
                          _2250 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2254 = log2(max((lerp(_2167, _2165, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2255 = _2254 * 0.3010300099849701f;
                    do {
                      if (!(!(_2255 <= _2181))) {
                        _2324 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2262 = log2(cb0_009x);
                        float _2263 = _2262 * 0.3010300099849701f;
                        if ((bool)(_2255 > _2181) && (bool)(_2255 < _2263)) {
                          float _2271 = ((_2254 - _2180) * 0.9030900001525879f) / ((_2262 - _2180) * 0.3010300099849701f);
                          int _2272 = int(_2271);
                          float _2274 = _2271 - float((int)(_2272));
                          float _2276 = _12[_2272];
                          float _2279 = _12[(_2272 + 1)];
                          float _2284 = _2276 * 0.5f;
                          _2324 = dot(float3((_2274 * _2274), _2274, 1.0f), float3(mad((_12[(_2272 + 2)]), 0.5f, mad(_2279, -1.0f, _2284)), (_2279 - _2276), mad(_2279, 0.5f, _2284)));
                        } else {
                          do {
                            if (!(!(_2255 >= _2263))) {
                              float _2293 = log2(cb0_008z);
                              if (_2255 < (_2293 * 0.3010300099849701f)) {
                                float _2301 = ((_2254 - _2262) * 0.9030900001525879f) / ((_2293 - _2262) * 0.3010300099849701f);
                                int _2302 = int(_2301);
                                float _2304 = _2301 - float((int)(_2302));
                                float _2306 = _13[_2302];
                                float _2309 = _13[(_2302 + 1)];
                                float _2314 = _2306 * 0.5f;
                                _2324 = dot(float3((_2304 * _2304), _2304, 1.0f), float3(mad((_13[(_2302 + 2)]), 0.5f, mad(_2309, -1.0f, _2314)), (_2309 - _2306), mad(_2309, 0.5f, _2314)));
                                break;
                              }
                            }
                            _2324 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2328 = log2(max((lerp(_2167, _2166, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2329 = _2328 * 0.3010300099849701f;
                      do {
                        if (!(!(_2329 <= _2181))) {
                          _2398 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2336 = log2(cb0_009x);
                          float _2337 = _2336 * 0.3010300099849701f;
                          if ((bool)(_2329 > _2181) && (bool)(_2329 < _2337)) {
                            float _2345 = ((_2328 - _2180) * 0.9030900001525879f) / ((_2336 - _2180) * 0.3010300099849701f);
                            int _2346 = int(_2345);
                            float _2348 = _2345 - float((int)(_2346));
                            float _2350 = _12[_2346];
                            float _2353 = _12[(_2346 + 1)];
                            float _2358 = _2350 * 0.5f;
                            _2398 = dot(float3((_2348 * _2348), _2348, 1.0f), float3(mad((_12[(_2346 + 2)]), 0.5f, mad(_2353, -1.0f, _2358)), (_2353 - _2350), mad(_2353, 0.5f, _2358)));
                          } else {
                            do {
                              if (!(!(_2329 >= _2337))) {
                                float _2367 = log2(cb0_008z);
                                if (_2329 < (_2367 * 0.3010300099849701f)) {
                                  float _2375 = ((_2328 - _2336) * 0.9030900001525879f) / ((_2367 - _2336) * 0.3010300099849701f);
                                  int _2376 = int(_2375);
                                  float _2378 = _2375 - float((int)(_2376));
                                  float _2380 = _13[_2376];
                                  float _2383 = _13[(_2376 + 1)];
                                  float _2388 = _2380 * 0.5f;
                                  _2398 = dot(float3((_2378 * _2378), _2378, 1.0f), float3(mad((_13[(_2376 + 2)]), 0.5f, mad(_2383, -1.0f, _2388)), (_2383 - _2380), mad(_2383, 0.5f, _2388)));
                                  break;
                                }
                              }
                              _2398 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2402 = cb0_008w - cb0_008y;
                        float _2403 = (exp2(_2250 * 3.321928024291992f) - cb0_008y) / _2402;
                        float _2405 = (exp2(_2324 * 3.321928024291992f) - cb0_008y) / _2402;
                        float _2407 = (exp2(_2398 * 3.321928024291992f) - cb0_008y) / _2402;
                        float _2410 = mad(0.15618768334388733f, _2407, mad(0.13400420546531677f, _2405, (_2403 * 0.6624541878700256f)));
                        float _2413 = mad(0.053689517080783844f, _2407, mad(0.6740817427635193f, _2405, (_2403 * 0.2722287178039551f)));
                        float _2416 = mad(1.0103391408920288f, _2407, mad(0.00406073359772563f, _2405, (_2403 * -0.005574649665504694f)));
                        float _2429 = min(max(mad(-0.23642469942569733f, _2416, mad(-0.32480329275131226f, _2413, (_2410 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2430 = min(max(mad(0.016756348311901093f, _2416, mad(1.6153316497802734f, _2413, (_2410 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2431 = min(max(mad(0.9883948564529419f, _2416, mad(-0.008284442126750946f, _2413, (_2410 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2434 = mad(0.15618768334388733f, _2431, mad(0.13400420546531677f, _2430, (_2429 * 0.6624541878700256f)));
                        float _2437 = mad(0.053689517080783844f, _2431, mad(0.6740817427635193f, _2430, (_2429 * 0.2722287178039551f)));
                        float _2440 = mad(1.0103391408920288f, _2431, mad(0.00406073359772563f, _2430, (_2429 * -0.005574649665504694f)));
                        float _2462 = min(max((min(max(mad(-0.23642469942569733f, _2440, mad(-0.32480329275131226f, _2437, (_2434 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2463 = min(max((min(max(mad(0.016756348311901093f, _2440, mad(1.6153316497802734f, _2437, (_2434 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2464 = min(max((min(max(mad(0.9883948564529419f, _2440, mad(-0.008284442126750946f, _2437, (_2434 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 6)) {
                            _2477 = mad(_43, _2464, mad(_42, _2463, (_2462 * _41)));
                            _2478 = mad(_46, _2464, mad(_45, _2463, (_2462 * _44)));
                            _2479 = mad(_49, _2464, mad(_48, _2463, (_2462 * _47)));
                          } else {
                            _2477 = _2462;
                            _2478 = _2463;
                            _2479 = _2464;
                          }
                          float _2489 = exp2(log2(_2477 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2490 = exp2(log2(_2478 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2491 = exp2(log2(_2479 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2656 = exp2(log2((1.0f / ((_2489 * 18.6875f) + 1.0f)) * ((_2489 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2657 = exp2(log2((1.0f / ((_2490 * 18.6875f) + 1.0f)) * ((_2490 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2658 = exp2(log2((1.0f / ((_2491 * 18.6875f) + 1.0f)) * ((_2491 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (cb0_040w == 7) {
            float _2536 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1218, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1217, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1216)));
            float _2539 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1218, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1217, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1216)));
            float _2542 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1218, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1217, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1216)));
            float _2561 = exp2(log2(mad(_43, _2542, mad(_42, _2539, (_2536 * _41))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2562 = exp2(log2(mad(_46, _2542, mad(_45, _2539, (_2536 * _44))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2563 = exp2(log2(mad(_49, _2542, mad(_48, _2539, (_2536 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2656 = exp2(log2((1.0f / ((_2561 * 18.6875f) + 1.0f)) * ((_2561 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2657 = exp2(log2((1.0f / ((_2562 * 18.6875f) + 1.0f)) * ((_2562 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2658 = exp2(log2((1.0f / ((_2563 * 18.6875f) + 1.0f)) * ((_2563 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2610 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1206, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1205, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1204)));
                float _2613 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1206, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1205, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1204)));
                float _2616 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1206, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1205, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1204)));
                _2656 = mad(_43, _2616, mad(_42, _2613, (_2610 * _41)));
                _2657 = mad(_46, _2616, mad(_45, _2613, (_2610 * _44)));
                _2658 = mad(_49, _2616, mad(_48, _2613, (_2610 * _47)));
              } else {
                float _2629 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1230)));
                float _2632 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1230)));
                float _2635 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1230)));
                _2656 = exp2(log2(mad(_43, _2635, mad(_42, _2632, (_2629 * _41)))) * cb0_040z);
                _2657 = exp2(log2(mad(_46, _2635, mad(_45, _2632, (_2629 * _44)))) * cb0_040z);
                _2658 = exp2(log2(mad(_49, _2635, mad(_48, _2632, (_2629 * _47)))) * cb0_040z);
              }
            } else {
              _2656 = _1216;
              _2657 = _1217;
              _2658 = _1218;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2656 * 0.9523810148239136f);
  SV_Target.y = (_2657 * 0.9523810148239136f);
  SV_Target.z = (_2658 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
