#include "../common.hlsl"

// Found in The Casting of Frank Stone

Texture3D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _14 = TEXCOORD.x + -0.015625f;
  float _15 = TEXCOORD.y + -0.015625f;
  float _18 = float((uint)(int)(SV_RenderTargetArrayIndex));
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _105;
  float _106;
  float _107;
  float _549;
  float _559;
  float _569;
  float _646;
  float _647;
  float _648;
  float _658;
  float _668;
  float _678;
  float _686;
  float _687;
  float _688;
  float _785;
  float _821;
  float _832;
  float _896;
  float _1164;
  float _1165;
  float _1166;
  float _1177;
  float _1188;
  float _1370;
  float _1406;
  float _1417;
  float _1456;
  float _1566;
  float _1640;
  float _1714;
  float _1793;
  float _1794;
  float _1795;
  float _1946;
  float _1982;
  float _1993;
  float _2032;
  float _2142;
  float _2216;
  float _2290;
  float _2369;
  float _2370;
  float _2371;
  float _2548;
  float _2549;
  float _2550;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _28 = (cb0_041x == 4);
        _39 = select(_28, 1.0f, 1.7050515413284302f);
        _40 = select(_28, 0.0f, -0.6217905879020691f);
        _41 = select(_28, 0.0f, -0.0832584798336029f);
        _42 = select(_28, 0.0f, -0.13025718927383423f);
        _43 = select(_28, 1.0f, 1.1408027410507202f);
        _44 = select(_28, 0.0f, -0.010548528283834457f);
        _45 = select(_28, 0.0f, -0.024003278464078903f);
        _46 = select(_28, 0.0f, -0.1289687603712082f);
        _47 = select(_28, 1.0f, 1.152971863746643f);
      } else {
        _39 = 0.6954522132873535f;
        _40 = 0.14067870378494263f;
        _41 = 0.16386906802654266f;
        _42 = 0.044794563204050064f;
        _43 = 0.8596711158752441f;
        _44 = 0.0955343171954155f;
        _45 = -0.005525882821530104f;
        _46 = 0.004025210160762072f;
        _47 = 1.0015007257461548f;
      }
    } else {
      _39 = 1.02579927444458f;
      _40 = -0.020052503794431686f;
      _41 = -0.0057713985443115234f;
      _42 = -0.0022350111976265907f;
      _43 = 1.0045825242996216f;
      _44 = -0.002352306619286537f;
      _45 = -0.005014004185795784f;
      _46 = -0.025293385609984398f;
      _47 = 1.0304402112960815f;
    }
  } else {
    _39 = 1.379158854484558f;
    _40 = -0.3088507056236267f;
    _41 = -0.07034677267074585f;
    _42 = -0.06933528929948807f;
    _43 = 1.0822921991348267f;
    _44 = -0.012962047010660172f;
    _45 = -0.002159259282052517f;
    _46 = -0.045465391129255295f;
    _47 = 1.0477596521377563f;
  }
  if ((uint)cb0_040w > (uint)2) {
    float _58 = exp2(log2(_14 * 1.0322580337524414f) * 0.012683313339948654f);
    float _59 = exp2(log2(_15 * 1.0322580337524414f) * 0.012683313339948654f);
    float _60 = exp2(log2(_18 * 0.032258063554763794f) * 0.012683313339948654f);
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _106 = (exp2(log2(max(0.0f, (_59 + -0.8359375f)) / (18.8515625f - (_59 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _105 = ((exp2((_14 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _106 = ((exp2((_15 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _107 = ((exp2((_18 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _122 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _107, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _106, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _105)));
  float _125 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _107, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _106, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _105)));
  float _128 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _107, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _106, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _105)));
  float _129 = dot(float3(_122, _125, _128), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_122, _125, _128));

  float _133 = (_122 / _129) + -1.0f;
  float _134 = (_125 / _129) + -1.0f;
  float _135 = (_128 / _129) + -1.0f;
  float _147 = (1.0f - exp2(((_129 * _129) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_133, _134, _135), float3(_133, _134, _135)) * -4.0f));
  float _163 = ((mad(-0.06368283927440643f, _128, mad(-0.32929131388664246f, _125, (_122 * 1.370412826538086f))) - _122) * _147) + _122;
  float _164 = ((mad(-0.010861567221581936f, _128, mad(1.0970908403396606f, _125, (_122 * -0.08343426138162613f))) - _125) * _147) + _125;
  float _165 = ((mad(1.203694462776184f, _128, mad(-0.09862564504146576f, _125, (_122 * -0.02579325996339321f))) - _128) * _147) + _128;
  float _166 = dot(float3(_163, _164, _165), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _180 = cb0_019w + cb0_024w;
  float _194 = cb0_018w * cb0_023w;
  float _208 = cb0_017w * cb0_022w;
  float _222 = cb0_016w * cb0_021w;
  float _236 = cb0_015w * cb0_020w;
  float _240 = _163 - _166;
  float _241 = _164 - _166;
  float _242 = _165 - _166;
  float _300 = saturate(_166 / cb0_035z);
  float _304 = (_300 * _300) * (3.0f - (_300 * 2.0f));
  float _305 = 1.0f - _304;
  float _314 = cb0_019w + cb0_034w;
  float _323 = cb0_018w * cb0_033w;
  float _332 = cb0_017w * cb0_032w;
  float _341 = cb0_016w * cb0_031w;
  float _350 = cb0_015w * cb0_030w;
  float _413 = saturate((_166 - cb0_035w) / (cb0_036x - cb0_035w));
  float _417 = (_413 * _413) * (3.0f - (_413 * 2.0f));
  float _426 = cb0_019w + cb0_029w;
  float _435 = cb0_018w * cb0_028w;
  float _444 = cb0_017w * cb0_027w;
  float _453 = cb0_016w * cb0_026w;
  float _462 = cb0_015w * cb0_025w;
  float _520 = _304 - _417;
  float _531 = ((_417 * (((cb0_019x + cb0_034x) + _314) + (((cb0_018x * cb0_033x) * _323) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _341) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _350) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _332)))))) + (_305 * (((cb0_019x + cb0_024x) + _180) + (((cb0_018x * cb0_023x) * _194) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _222) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _236) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _208))))))) + ((((cb0_019x + cb0_029x) + _426) + (((cb0_018x * cb0_028x) * _435) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _453) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _462) * _240) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _444))))) * _520);
  float _533 = ((_417 * (((cb0_019y + cb0_034y) + _314) + (((cb0_018y * cb0_033y) * _323) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _341) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _350) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _332)))))) + (_305 * (((cb0_019y + cb0_024y) + _180) + (((cb0_018y * cb0_023y) * _194) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _222) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _236) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _208))))))) + ((((cb0_019y + cb0_029y) + _426) + (((cb0_018y * cb0_028y) * _435) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _453) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _462) * _241) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _444))))) * _520);
  float _535 = ((_417 * (((cb0_019z + cb0_034z) + _314) + (((cb0_018z * cb0_033z) * _323) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _341) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _350) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _332)))))) + (_305 * (((cb0_019z + cb0_024z) + _180) + (((cb0_018z * cb0_023z) * _194) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _222) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _236) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _208))))))) + ((((cb0_019z + cb0_029z) + _426) + (((cb0_018z * cb0_028z) * _435) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _453) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _462) * _242) + _166)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _444))))) * _520);

  SetUntonemappedAP1(float3(_531, _533, _535));

  if (!(cb0_042x == 0)) {
    do {
      if (_531 > 0.0078125f) {
        _549 = ((log2(_531) + 9.720000267028809f) * 0.05707762390375137f);
      } else {
        _549 = ((_531 * 10.540237426757812f) + 0.072905533015728f);
      }
      do {
        if (_533 > 0.0078125f) {
          _559 = ((log2(_533) + 9.720000267028809f) * 0.05707762390375137f);
        } else {
          _559 = ((_533 * 10.540237426757812f) + 0.072905533015728f);
        }
        do {
          if (_535 > 0.0078125f) {
            _569 = ((log2(_535) + 9.720000267028809f) * 0.05707762390375137f);
          } else {
            _569 = ((_535 * 10.540237426757812f) + 0.072905533015728f);
          }
          float _573 = min(max(_549, 0.0f), 1.0f);
          float _574 = min(max(_559, 0.0f), 1.0f);
          float _575 = min(max(_569, 0.0f), 1.0f);
          float4 _580 = t0.Sample(s0, float3(_573, _574, _575));
          do {
            if (cb0_042y == 1) {
              float4 _588 = t0.Sample(s0, float3((cb0_042z + _573), _574, _575));
              float4 _593 = t0.Sample(s0, float3(_573, (cb0_042z + _574), _575));
              float4 _598 = t0.Sample(s0, float3(_573, _574, (cb0_042z + _575)));
              float _614 = saturate(1.0f - abs(_573 - floor(_573)));
              float _615 = saturate(1.0f - abs(_574 - floor(_574)));
              float _616 = saturate(1.0f - abs(_575 - floor(_575)));
              float _617 = dot(float3(_614, _615, _616), float3(1.0f, 1.0f, 1.0f));
              float _618 = _614 / _617;
              float _619 = _615 / _617;
              float _620 = _616 / _617;
              float _638 = ((1.0f - _618) - _619) - _620;
              _646 = ((((_619 * _588.x) + (_618 * _580.x)) + (_620 * _593.x)) + (_638 * _598.x));
              _647 = ((((_619 * _588.y) + (_618 * _580.y)) + (_620 * _593.y)) + (_638 * _598.y));
              _648 = ((((_619 * _588.z) + (_618 * _580.z)) + (_620 * _593.z)) + (_638 * _598.z));
            } else {
              _646 = _580.x;
              _647 = _580.y;
              _648 = _580.z;
            }
            do {
              if (_646 > 0.155251145362854f) {
                _658 = exp2((_646 * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _658 = ((_646 + -0.072905533015728f) * 0.09487452358007431f);
              }
              do {
                if (_647 > 0.155251145362854f) {
                  _668 = exp2((_647 * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _668 = ((_647 + -0.072905533015728f) * 0.09487452358007431f);
                }
                do {
                  if (_648 > 0.155251145362854f) {
                    _678 = exp2((_648 * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _678 = ((_648 + -0.072905533015728f) * 0.09487452358007431f);
                  }
                  _686 = min(max(_658, 0.0f), 65504.0f);
                  _687 = min(max(_668, 0.0f), 65504.0f);
                  _688 = min(max(_678, 0.0f), 65504.0f);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _686 = _531;
    _687 = _533;
    _688 = _535;
  }

  float _725 = ((mad(0.061360642313957214f, _688, mad(-4.540197551250458e-09f, _687, (_686 * 0.9386394023895264f))) - _686) * cb0_036y) + _686;
  float _726 = ((mad(0.169205904006958f, _688, mad(0.8307942152023315f, _687, (_686 * 6.775371730327606e-08f))) - _687) * cb0_036y) + _687;
  float _727 = (mad(-2.3283064365386963e-10f, _687, (_686 * -9.313225746154785e-10f)) * cb0_036y) + _688;
  float _730 = mad(0.16386905312538147f, _727, mad(0.14067868888378143f, _726, (_725 * 0.6954522132873535f)));
  float _733 = mad(0.0955343246459961f, _727, mad(0.8596711158752441f, _726, (_725 * 0.044794581830501556f)));
  float _736 = mad(1.0015007257461548f, _727, mad(0.004025210160762072f, _726, (_725 * -0.005525882821530104f)));
  float _740 = max(max(_730, _733), _736);
  float _745 = (max(_740, 1.000000013351432e-10f) - max(min(min(_730, _733), _736), 1.000000013351432e-10f)) / max(_740, 0.009999999776482582f);
  float _758 = ((_733 + _730) + _736) + (sqrt((((_736 - _733) * _736) + ((_733 - _730) * _733)) + ((_730 - _736) * _730)) * 1.75f);
  float _759 = _758 * 0.3333333432674408f;
  float _760 = _745 + -0.4000000059604645f;
  float _761 = _760 * 5.0f;
  float _765 = max((1.0f - abs(_760 * 2.5f)), 0.0f);
  float _776 = ((float((int)(((int)(uint)((bool)(_761 > 0.0f))) - ((int)(uint)((bool)(_761 < 0.0f))))) * (1.0f - (_765 * _765))) + 1.0f) * 0.02500000037252903f;
  if (!(_759 <= 0.0533333346247673f)) {
    if (!(_759 >= 0.1599999964237213f)) {
      _785 = (((0.23999999463558197f / _758) + -0.5f) * _776);
    } else {
      _785 = 0.0f;
    }
  } else {
    _785 = _776;
  }
  float _786 = _785 + 1.0f;
  float _787 = _786 * _730;
  float _788 = _786 * _733;
  float _789 = _786 * _736;
  if (!((bool)(_787 == _788) && (bool)(_788 == _789))) {
    float _796 = ((_787 * 2.0f) - _788) - _789;
    float _799 = ((_733 - _736) * 1.7320507764816284f) * _786;
    float _801 = atan(_799 / _796);
    bool _804 = (_796 < 0.0f);
    bool _805 = (_796 == 0.0f);
    bool _806 = (_799 >= 0.0f);
    bool _807 = (_799 < 0.0f);
    float _816 = select((_806 && _805), 90.0f, select((_807 && _805), -90.0f, (select((_807 && _804), (_801 + -3.1415927410125732f), select((_806 && _804), (_801 + 3.1415927410125732f), _801)) * 57.2957763671875f)));
    if (_816 < 0.0f) {
      _821 = (_816 + 360.0f);
    } else {
      _821 = _816;
    }
  } else {
    _821 = 0.0f;
  }
  float _823 = min(max(_821, 0.0f), 360.0f);
  if (_823 < -180.0f) {
    _832 = (_823 + 360.0f);
  } else {
    if (_823 > 180.0f) {
      _832 = (_823 + -360.0f);
    } else {
      _832 = _823;
    }
  }
  float _836 = saturate(1.0f - abs(_832 * 0.014814814552664757f));
  float _840 = (_836 * _836) * (3.0f - (_836 * 2.0f));
  float _846 = ((_840 * _840) * ((_745 * 0.18000000715255737f) * (0.029999999329447746f - _787))) + _787;
  float _856 = max(0.0f, mad(-0.21492856740951538f, _789, mad(-0.2365107536315918f, _788, (_846 * 1.4514392614364624f))));
  float _857 = max(0.0f, mad(-0.09967592358589172f, _789, mad(1.17622971534729f, _788, (_846 * -0.07655377686023712f))));
  float _858 = max(0.0f, mad(0.9977163076400757f, _789, mad(-0.006032449658960104f, _788, (_846 * 0.008316148072481155f))));
  float _859 = dot(float3(_856, _857, _858), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _873 = (cb0_037w + 1.0f) - cb0_037y;
  float _876 = cb0_038x + 1.0f;
  float _878 = _876 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _896 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _887 = (cb0_037w + 0.18000000715255737f) / _873;
    _896 = (-0.7447274923324585f - ((log2(_887 / (2.0f - _887)) * 0.3465735912322998f) * (_873 / cb0_037x)));
  }
  float _899 = ((1.0f - cb0_037y) / cb0_037x) - _896;
  float _901 = (cb0_037z / cb0_037x) - _899;
  float _905 = log2(lerp(_859, _856, 0.9599999785423279f)) * 0.3010300099849701f;
  float _906 = log2(lerp(_859, _857, 0.9599999785423279f)) * 0.3010300099849701f;
  float _907 = log2(lerp(_859, _858, 0.9599999785423279f)) * 0.3010300099849701f;
  float _911 = cb0_037x * (_905 + _899);
  float _912 = cb0_037x * (_906 + _899);
  float _913 = cb0_037x * (_907 + _899);
  float _914 = _873 * 2.0f;
  float _916 = (cb0_037x * -2.0f) / _873;
  float _917 = _905 - _896;
  float _918 = _906 - _896;
  float _919 = _907 - _896;
  float _938 = _878 * 2.0f;
  float _940 = (cb0_037x * 2.0f) / _878;
  float _965 = select((_905 < _896), ((_914 / (exp2((_917 * 1.4426950216293335f) * _916) + 1.0f)) - cb0_037w), _911);
  float _966 = select((_906 < _896), ((_914 / (exp2((_918 * 1.4426950216293335f) * _916) + 1.0f)) - cb0_037w), _912);
  float _967 = select((_907 < _896), ((_914 / (exp2((_919 * 1.4426950216293335f) * _916) + 1.0f)) - cb0_037w), _913);
  float _974 = _901 - _896;
  float _978 = saturate(_917 / _974);
  float _979 = saturate(_918 / _974);
  float _980 = saturate(_919 / _974);
  bool _981 = (_901 < _896);
  float _985 = select(_981, (1.0f - _978), _978);
  float _986 = select(_981, (1.0f - _979), _979);
  float _987 = select(_981, (1.0f - _980), _980);
  float _1006 = (((_985 * _985) * (select((_905 > _901), (_876 - (_938 / (exp2(((_905 - _901) * 1.4426950216293335f) * _940) + 1.0f))), _911) - _965)) * (3.0f - (_985 * 2.0f))) + _965;
  float _1007 = (((_986 * _986) * (select((_906 > _901), (_876 - (_938 / (exp2(((_906 - _901) * 1.4426950216293335f) * _940) + 1.0f))), _912) - _966)) * (3.0f - (_986 * 2.0f))) + _966;
  float _1008 = (((_987 * _987) * (select((_907 > _901), (_876 - (_938 / (exp2(((_907 - _901) * 1.4426950216293335f) * _940) + 1.0f))), _913) - _967)) * (3.0f - (_987 * 2.0f))) + _967;
  float _1009 = dot(float3(_1006, _1007, _1008), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1029 = (cb0_036w * (max(0.0f, (lerp(_1009, _1006, 0.9300000071525574f))) - _725)) + _725;
  float _1030 = (cb0_036w * (max(0.0f, (lerp(_1009, _1007, 0.9300000071525574f))) - _726)) + _726;
  float _1031 = (cb0_036w * (max(0.0f, (lerp(_1009, _1008, 0.9300000071525574f))) - _727)) + _727;
  float _1047 = ((mad(-0.06537103652954102f, _1031, mad(1.451815478503704e-06f, _1030, (_1029 * 1.065374732017517f))) - _1029) * cb0_036y) + _1029;
  float _1048 = ((mad(-0.20366770029067993f, _1031, mad(1.2036634683609009f, _1030, (_1029 * -2.57161445915699e-07f))) - _1030) * cb0_036y) + _1030;
  float _1049 = ((mad(0.9999996423721313f, _1031, mad(2.0954757928848267e-08f, _1030, (_1029 * 1.862645149230957e-08f))) - _1031) * cb0_036y) + _1031;

  SetTonemappedAP1(_1047, _1048, _1049);

  float _1059 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1049, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1048, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1047))));
  float _1060 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1049, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1048, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1047))));
  float _1061 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1049, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1048, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1047))));
  float _1087 = cb0_014x * (((cb0_039y + (cb0_039x * _1059)) * _1059) + cb0_039z);
  float _1088 = cb0_014y * (((cb0_039y + (cb0_039x * _1060)) * _1060) + cb0_039z);
  float _1089 = cb0_014z * (((cb0_039y + (cb0_039x * _1061)) * _1061) + cb0_039z);
  float _1096 = ((cb0_013x - _1087) * cb0_013w) + _1087;
  float _1097 = ((cb0_013y - _1088) * cb0_013w) + _1088;
  float _1098 = ((cb0_013z - _1089) * cb0_013w) + _1089;
  float _1099 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _688, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _687, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _686)));
  float _1100 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _688, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _687, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _686)));
  float _1101 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _688, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _687, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _686)));
  float _1108 = ((cb0_013x - _1099) * cb0_013w) + _1099;
  float _1109 = ((cb0_013y - _1100) * cb0_013w) + _1100;
  float _1110 = ((cb0_013z - _1101) * cb0_013w) + _1101;
  float _1122 = exp2(log2(max(0.0f, _1096)) * cb0_040y);
  float _1123 = exp2(log2(max(0.0f, _1097)) * cb0_040y);
  float _1124 = exp2(log2(max(0.0f, _1098)) * cb0_040y);

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1122, _1123, _1124), cb0_040w);
  }

  [branch]
  if (cb0_040w == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1147 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1122)));
        float _1150 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1122)));
        float _1153 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1122)));
        _1164 = mad(_41, _1153, mad(_40, _1150, (_1147 * _39)));
        _1165 = mad(_44, _1153, mad(_43, _1150, (_1147 * _42)));
        _1166 = mad(_47, _1153, mad(_46, _1150, (_1147 * _45)));
      } else {
        _1164 = _1122;
        _1165 = _1123;
        _1166 = _1124;
      }
      do {
        if (_1164 < 0.0031306699384003878f) {
          _1177 = (_1164 * 12.920000076293945f);
        } else {
          _1177 = (((pow(_1164, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1165 < 0.0031306699384003878f) {
            _1188 = (_1165 * 12.920000076293945f);
          } else {
            _1188 = (((pow(_1165, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1166 < 0.0031306699384003878f) {
            _2548 = _1177;
            _2549 = _1188;
            _2550 = (_1166 * 12.920000076293945f);
          } else {
            _2548 = _1177;
            _2549 = _1188;
            _2550 = (((pow(_1166, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1215 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1122)));
      float _1218 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1122)));
      float _1221 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1122)));
      float _1231 = max(6.103519990574569e-05f, mad(_41, _1221, mad(_40, _1218, (_1215 * _39))));
      float _1232 = max(6.103519990574569e-05f, mad(_44, _1221, mad(_43, _1218, (_1215 * _42))));
      float _1233 = max(6.103519990574569e-05f, mad(_47, _1221, mad(_46, _1218, (_1215 * _45))));
      _2548 = min((_1231 * 4.5f), ((exp2(log2(max(_1231, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2549 = min((_1232 * 4.5f), ((exp2(log2(max(_1232, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2550 = min((_1233 * 4.5f), ((exp2(log2(max(_1233, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1310 = cb0_012z * _1108;
        float _1311 = cb0_012z * _1109;
        float _1312 = cb0_012z * _1110;
        float _1315 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1312, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1311, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1310)));
        float _1318 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1312, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1311, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1310)));
        float _1321 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1312, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1311, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1310)));
        float _1325 = max(max(_1315, _1318), _1321);
        float _1330 = (max(_1325, 1.000000013351432e-10f) - max(min(min(_1315, _1318), _1321), 1.000000013351432e-10f)) / max(_1325, 0.009999999776482582f);
        float _1343 = ((_1318 + _1315) + _1321) + (sqrt((((_1321 - _1318) * _1321) + ((_1318 - _1315) * _1318)) + ((_1315 - _1321) * _1315)) * 1.75f);
        float _1344 = _1343 * 0.3333333432674408f;
        float _1345 = _1330 + -0.4000000059604645f;
        float _1346 = _1345 * 5.0f;
        float _1350 = max((1.0f - abs(_1345 * 2.5f)), 0.0f);
        float _1361 = ((float((int)(((int)(uint)((bool)(_1346 > 0.0f))) - ((int)(uint)((bool)(_1346 < 0.0f))))) * (1.0f - (_1350 * _1350))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1344 <= 0.0533333346247673f)) {
            if (!(_1344 >= 0.1599999964237213f)) {
              _1370 = (((0.23999999463558197f / _1343) + -0.5f) * _1361);
            } else {
              _1370 = 0.0f;
            }
          } else {
            _1370 = _1361;
          }
          float _1371 = _1370 + 1.0f;
          float _1372 = _1371 * _1315;
          float _1373 = _1371 * _1318;
          float _1374 = _1371 * _1321;
          do {
            if (!((bool)(_1372 == _1373) && (bool)(_1373 == _1374))) {
              float _1381 = ((_1372 * 2.0f) - _1373) - _1374;
              float _1384 = ((_1318 - _1321) * 1.7320507764816284f) * _1371;
              float _1386 = atan(_1384 / _1381);
              bool _1389 = (_1381 < 0.0f);
              bool _1390 = (_1381 == 0.0f);
              bool _1391 = (_1384 >= 0.0f);
              bool _1392 = (_1384 < 0.0f);
              float _1401 = select((_1391 && _1390), 90.0f, select((_1392 && _1390), -90.0f, (select((_1392 && _1389), (_1386 + -3.1415927410125732f), select((_1391 && _1389), (_1386 + 3.1415927410125732f), _1386)) * 57.2957763671875f)));
              if (_1401 < 0.0f) {
                _1406 = (_1401 + 360.0f);
              } else {
                _1406 = _1401;
              }
            } else {
              _1406 = 0.0f;
            }
            float _1408 = min(max(_1406, 0.0f), 360.0f);
            do {
              if (_1408 < -180.0f) {
                _1417 = (_1408 + 360.0f);
              } else {
                if (_1408 > 180.0f) {
                  _1417 = (_1408 + -360.0f);
                } else {
                  _1417 = _1408;
                }
              }
              do {
                if ((bool)(_1417 > -67.5f) && (bool)(_1417 < 67.5f)) {
                  float _1423 = (_1417 + 67.5f) * 0.029629629105329514f;
                  int _1424 = int(_1423);
                  float _1426 = _1423 - float((int)(_1424));
                  float _1427 = _1426 * _1426;
                  float _1428 = _1427 * _1426;
                  if (_1424 == 3) {
                    _1456 = (((0.1666666716337204f - (_1426 * 0.5f)) + (_1427 * 0.5f)) - (_1428 * 0.1666666716337204f));
                  } else {
                    if (_1424 == 2) {
                      _1456 = ((0.6666666865348816f - _1427) + (_1428 * 0.5f));
                    } else {
                      if (_1424 == 1) {
                        _1456 = (((_1428 * -0.5f) + 0.1666666716337204f) + ((_1427 + _1426) * 0.5f));
                      } else {
                        _1456 = select((_1424 == 0), (_1428 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1456 = 0.0f;
                }
                float _1465 = min(max(((((_1330 * 0.27000001072883606f) * (0.029999999329447746f - _1372)) * _1456) + _1372), 0.0f), 65535.0f);
                float _1466 = min(max(_1373, 0.0f), 65535.0f);
                float _1467 = min(max(_1374, 0.0f), 65535.0f);
                float _1480 = min(max(mad(-0.21492856740951538f, _1467, mad(-0.2365107536315918f, _1466, (_1465 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1481 = min(max(mad(-0.09967592358589172f, _1467, mad(1.17622971534729f, _1466, (_1465 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1482 = min(max(mad(0.9977163076400757f, _1467, mad(-0.006032449658960104f, _1466, (_1465 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1483 = dot(float3(_1480, _1481, _1482), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1494 = log2(max((lerp(_1483, _1480, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1495 = _1494 * 0.3010300099849701f;
                float _1496 = log2(cb0_008x);
                float _1497 = _1496 * 0.3010300099849701f;
                do {
                  if (!(!(_1495 <= _1497))) {
                    _1566 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1504 = log2(cb0_009x);
                    float _1505 = _1504 * 0.3010300099849701f;
                    if ((bool)(_1495 > _1497) && (bool)(_1495 < _1505)) {
                      float _1513 = ((_1494 - _1496) * 0.9030900001525879f) / ((_1504 - _1496) * 0.3010300099849701f);
                      int _1514 = int(_1513);
                      float _1516 = _1513 - float((int)(_1514));
                      float _1518 = _12[_1514];
                      float _1521 = _12[(_1514 + 1)];
                      float _1526 = _1518 * 0.5f;
                      _1566 = dot(float3((_1516 * _1516), _1516, 1.0f), float3(mad((_12[(_1514 + 2)]), 0.5f, mad(_1521, -1.0f, _1526)), (_1521 - _1518), mad(_1521, 0.5f, _1526)));
                    } else {
                      do {
                        if (!(!(_1495 >= _1505))) {
                          float _1535 = log2(cb0_008z);
                          if (_1495 < (_1535 * 0.3010300099849701f)) {
                            float _1543 = ((_1494 - _1504) * 0.9030900001525879f) / ((_1535 - _1504) * 0.3010300099849701f);
                            int _1544 = int(_1543);
                            float _1546 = _1543 - float((int)(_1544));
                            float _1548 = _13[_1544];
                            float _1551 = _13[(_1544 + 1)];
                            float _1556 = _1548 * 0.5f;
                            _1566 = dot(float3((_1546 * _1546), _1546, 1.0f), float3(mad((_13[(_1544 + 2)]), 0.5f, mad(_1551, -1.0f, _1556)), (_1551 - _1548), mad(_1551, 0.5f, _1556)));
                            break;
                          }
                        }
                        _1566 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1570 = log2(max((lerp(_1483, _1481, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1571 = _1570 * 0.3010300099849701f;
                  do {
                    if (!(!(_1571 <= _1497))) {
                      _1640 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1578 = log2(cb0_009x);
                      float _1579 = _1578 * 0.3010300099849701f;
                      if ((bool)(_1571 > _1497) && (bool)(_1571 < _1579)) {
                        float _1587 = ((_1570 - _1496) * 0.9030900001525879f) / ((_1578 - _1496) * 0.3010300099849701f);
                        int _1588 = int(_1587);
                        float _1590 = _1587 - float((int)(_1588));
                        float _1592 = _12[_1588];
                        float _1595 = _12[(_1588 + 1)];
                        float _1600 = _1592 * 0.5f;
                        _1640 = dot(float3((_1590 * _1590), _1590, 1.0f), float3(mad((_12[(_1588 + 2)]), 0.5f, mad(_1595, -1.0f, _1600)), (_1595 - _1592), mad(_1595, 0.5f, _1600)));
                      } else {
                        do {
                          if (!(!(_1571 >= _1579))) {
                            float _1609 = log2(cb0_008z);
                            if (_1571 < (_1609 * 0.3010300099849701f)) {
                              float _1617 = ((_1570 - _1578) * 0.9030900001525879f) / ((_1609 - _1578) * 0.3010300099849701f);
                              int _1618 = int(_1617);
                              float _1620 = _1617 - float((int)(_1618));
                              float _1622 = _13[_1618];
                              float _1625 = _13[(_1618 + 1)];
                              float _1630 = _1622 * 0.5f;
                              _1640 = dot(float3((_1620 * _1620), _1620, 1.0f), float3(mad((_13[(_1618 + 2)]), 0.5f, mad(_1625, -1.0f, _1630)), (_1625 - _1622), mad(_1625, 0.5f, _1630)));
                              break;
                            }
                          }
                          _1640 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1644 = log2(max((lerp(_1483, _1482, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1645 = _1644 * 0.3010300099849701f;
                    do {
                      if (!(!(_1645 <= _1497))) {
                        _1714 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1652 = log2(cb0_009x);
                        float _1653 = _1652 * 0.3010300099849701f;
                        if ((bool)(_1645 > _1497) && (bool)(_1645 < _1653)) {
                          float _1661 = ((_1644 - _1496) * 0.9030900001525879f) / ((_1652 - _1496) * 0.3010300099849701f);
                          int _1662 = int(_1661);
                          float _1664 = _1661 - float((int)(_1662));
                          float _1666 = _12[_1662];
                          float _1669 = _12[(_1662 + 1)];
                          float _1674 = _1666 * 0.5f;
                          _1714 = dot(float3((_1664 * _1664), _1664, 1.0f), float3(mad((_12[(_1662 + 2)]), 0.5f, mad(_1669, -1.0f, _1674)), (_1669 - _1666), mad(_1669, 0.5f, _1674)));
                        } else {
                          do {
                            if (!(!(_1645 >= _1653))) {
                              float _1683 = log2(cb0_008z);
                              if (_1645 < (_1683 * 0.3010300099849701f)) {
                                float _1691 = ((_1644 - _1652) * 0.9030900001525879f) / ((_1683 - _1652) * 0.3010300099849701f);
                                int _1692 = int(_1691);
                                float _1694 = _1691 - float((int)(_1692));
                                float _1696 = _13[_1692];
                                float _1699 = _13[(_1692 + 1)];
                                float _1704 = _1696 * 0.5f;
                                _1714 = dot(float3((_1694 * _1694), _1694, 1.0f), float3(mad((_13[(_1692 + 2)]), 0.5f, mad(_1699, -1.0f, _1704)), (_1699 - _1696), mad(_1699, 0.5f, _1704)));
                                break;
                              }
                            }
                            _1714 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1718 = cb0_008w - cb0_008y;
                      float _1719 = (exp2(_1566 * 3.321928024291992f) - cb0_008y) / _1718;
                      float _1721 = (exp2(_1640 * 3.321928024291992f) - cb0_008y) / _1718;
                      float _1723 = (exp2(_1714 * 3.321928024291992f) - cb0_008y) / _1718;
                      float _1726 = mad(0.15618768334388733f, _1723, mad(0.13400420546531677f, _1721, (_1719 * 0.6624541878700256f)));
                      float _1729 = mad(0.053689517080783844f, _1723, mad(0.6740817427635193f, _1721, (_1719 * 0.2722287178039551f)));
                      float _1732 = mad(1.0103391408920288f, _1723, mad(0.00406073359772563f, _1721, (_1719 * -0.005574649665504694f)));
                      float _1745 = min(max(mad(-0.23642469942569733f, _1732, mad(-0.32480329275131226f, _1729, (_1726 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1746 = min(max(mad(0.016756348311901093f, _1732, mad(1.6153316497802734f, _1729, (_1726 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1747 = min(max(mad(0.9883948564529419f, _1732, mad(-0.008284442126750946f, _1729, (_1726 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1750 = mad(0.15618768334388733f, _1747, mad(0.13400420546531677f, _1746, (_1745 * 0.6624541878700256f)));
                      float _1753 = mad(0.053689517080783844f, _1747, mad(0.6740817427635193f, _1746, (_1745 * 0.2722287178039551f)));
                      float _1756 = mad(1.0103391408920288f, _1747, mad(0.00406073359772563f, _1746, (_1745 * -0.005574649665504694f)));
                      float _1778 = min(max((min(max(mad(-0.23642469942569733f, _1756, mad(-0.32480329275131226f, _1753, (_1750 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1779 = min(max((min(max(mad(0.016756348311901093f, _1756, mad(1.6153316497802734f, _1753, (_1750 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1780 = min(max((min(max(mad(0.9883948564529419f, _1756, mad(-0.008284442126750946f, _1753, (_1750 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(cb0_040w == 5)) {
                          _1793 = mad(_41, _1780, mad(_40, _1779, (_1778 * _39)));
                          _1794 = mad(_44, _1780, mad(_43, _1779, (_1778 * _42)));
                          _1795 = mad(_47, _1780, mad(_46, _1779, (_1778 * _45)));
                        } else {
                          _1793 = _1778;
                          _1794 = _1779;
                          _1795 = _1780;
                        }
                        float _1805 = exp2(log2(_1793 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1806 = exp2(log2(_1794 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1807 = exp2(log2(_1795 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2548 = exp2(log2((1.0f / ((_1805 * 18.6875f) + 1.0f)) * ((_1805 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2549 = exp2(log2((1.0f / ((_1806 * 18.6875f) + 1.0f)) * ((_1806 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2550 = exp2(log2((1.0f / ((_1807 * 18.6875f) + 1.0f)) * ((_1807 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _10[0] = cb0_010x;
          _10[1] = cb0_010y;
          _10[2] = cb0_010z;
          _10[3] = cb0_010w;
          _10[4] = cb0_012x;
          _10[5] = cb0_012x;
          _11[0] = cb0_011x;
          _11[1] = cb0_011y;
          _11[2] = cb0_011z;
          _11[3] = cb0_011w;
          _11[4] = cb0_012y;
          _11[5] = cb0_012y;
          float _1886 = cb0_012z * _1108;
          float _1887 = cb0_012z * _1109;
          float _1888 = cb0_012z * _1110;
          float _1891 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1888, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1887, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1886)));
          float _1894 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1888, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1887, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1886)));
          float _1897 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1888, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1887, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1886)));
          float _1901 = max(max(_1891, _1894), _1897);
          float _1906 = (max(_1901, 1.000000013351432e-10f) - max(min(min(_1891, _1894), _1897), 1.000000013351432e-10f)) / max(_1901, 0.009999999776482582f);
          float _1919 = ((_1894 + _1891) + _1897) + (sqrt((((_1897 - _1894) * _1897) + ((_1894 - _1891) * _1894)) + ((_1891 - _1897) * _1891)) * 1.75f);
          float _1920 = _1919 * 0.3333333432674408f;
          float _1921 = _1906 + -0.4000000059604645f;
          float _1922 = _1921 * 5.0f;
          float _1926 = max((1.0f - abs(_1921 * 2.5f)), 0.0f);
          float _1937 = ((float((int)(((int)(uint)((bool)(_1922 > 0.0f))) - ((int)(uint)((bool)(_1922 < 0.0f))))) * (1.0f - (_1926 * _1926))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1920 <= 0.0533333346247673f)) {
              if (!(_1920 >= 0.1599999964237213f)) {
                _1946 = (((0.23999999463558197f / _1919) + -0.5f) * _1937);
              } else {
                _1946 = 0.0f;
              }
            } else {
              _1946 = _1937;
            }
            float _1947 = _1946 + 1.0f;
            float _1948 = _1947 * _1891;
            float _1949 = _1947 * _1894;
            float _1950 = _1947 * _1897;
            do {
              if (!((bool)(_1948 == _1949) && (bool)(_1949 == _1950))) {
                float _1957 = ((_1948 * 2.0f) - _1949) - _1950;
                float _1960 = ((_1894 - _1897) * 1.7320507764816284f) * _1947;
                float _1962 = atan(_1960 / _1957);
                bool _1965 = (_1957 < 0.0f);
                bool _1966 = (_1957 == 0.0f);
                bool _1967 = (_1960 >= 0.0f);
                bool _1968 = (_1960 < 0.0f);
                float _1977 = select((_1967 && _1966), 90.0f, select((_1968 && _1966), -90.0f, (select((_1968 && _1965), (_1962 + -3.1415927410125732f), select((_1967 && _1965), (_1962 + 3.1415927410125732f), _1962)) * 57.2957763671875f)));
                if (_1977 < 0.0f) {
                  _1982 = (_1977 + 360.0f);
                } else {
                  _1982 = _1977;
                }
              } else {
                _1982 = 0.0f;
              }
              float _1984 = min(max(_1982, 0.0f), 360.0f);
              do {
                if (_1984 < -180.0f) {
                  _1993 = (_1984 + 360.0f);
                } else {
                  if (_1984 > 180.0f) {
                    _1993 = (_1984 + -360.0f);
                  } else {
                    _1993 = _1984;
                  }
                }
                do {
                  if ((bool)(_1993 > -67.5f) && (bool)(_1993 < 67.5f)) {
                    float _1999 = (_1993 + 67.5f) * 0.029629629105329514f;
                    int _2000 = int(_1999);
                    float _2002 = _1999 - float((int)(_2000));
                    float _2003 = _2002 * _2002;
                    float _2004 = _2003 * _2002;
                    if (_2000 == 3) {
                      _2032 = (((0.1666666716337204f - (_2002 * 0.5f)) + (_2003 * 0.5f)) - (_2004 * 0.1666666716337204f));
                    } else {
                      if (_2000 == 2) {
                        _2032 = ((0.6666666865348816f - _2003) + (_2004 * 0.5f));
                      } else {
                        if (_2000 == 1) {
                          _2032 = (((_2004 * -0.5f) + 0.1666666716337204f) + ((_2003 + _2002) * 0.5f));
                        } else {
                          _2032 = select((_2000 == 0), (_2004 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2032 = 0.0f;
                  }
                  float _2041 = min(max(((((_1906 * 0.27000001072883606f) * (0.029999999329447746f - _1948)) * _2032) + _1948), 0.0f), 65535.0f);
                  float _2042 = min(max(_1949, 0.0f), 65535.0f);
                  float _2043 = min(max(_1950, 0.0f), 65535.0f);
                  float _2056 = min(max(mad(-0.21492856740951538f, _2043, mad(-0.2365107536315918f, _2042, (_2041 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2057 = min(max(mad(-0.09967592358589172f, _2043, mad(1.17622971534729f, _2042, (_2041 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2058 = min(max(mad(0.9977163076400757f, _2043, mad(-0.006032449658960104f, _2042, (_2041 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2059 = dot(float3(_2056, _2057, _2058), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2070 = log2(max((lerp(_2059, _2056, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2071 = _2070 * 0.3010300099849701f;
                  float _2072 = log2(cb0_008x);
                  float _2073 = _2072 * 0.3010300099849701f;
                  do {
                    if (!(!(_2071 <= _2073))) {
                      _2142 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2080 = log2(cb0_009x);
                      float _2081 = _2080 * 0.3010300099849701f;
                      if ((bool)(_2071 > _2073) && (bool)(_2071 < _2081)) {
                        float _2089 = ((_2070 - _2072) * 0.9030900001525879f) / ((_2080 - _2072) * 0.3010300099849701f);
                        int _2090 = int(_2089);
                        float _2092 = _2089 - float((int)(_2090));
                        float _2094 = _10[_2090];
                        float _2097 = _10[(_2090 + 1)];
                        float _2102 = _2094 * 0.5f;
                        _2142 = dot(float3((_2092 * _2092), _2092, 1.0f), float3(mad((_10[(_2090 + 2)]), 0.5f, mad(_2097, -1.0f, _2102)), (_2097 - _2094), mad(_2097, 0.5f, _2102)));
                      } else {
                        do {
                          if (!(!(_2071 >= _2081))) {
                            float _2111 = log2(cb0_008z);
                            if (_2071 < (_2111 * 0.3010300099849701f)) {
                              float _2119 = ((_2070 - _2080) * 0.9030900001525879f) / ((_2111 - _2080) * 0.3010300099849701f);
                              int _2120 = int(_2119);
                              float _2122 = _2119 - float((int)(_2120));
                              float _2124 = _11[_2120];
                              float _2127 = _11[(_2120 + 1)];
                              float _2132 = _2124 * 0.5f;
                              _2142 = dot(float3((_2122 * _2122), _2122, 1.0f), float3(mad((_11[(_2120 + 2)]), 0.5f, mad(_2127, -1.0f, _2132)), (_2127 - _2124), mad(_2127, 0.5f, _2132)));
                              break;
                            }
                          }
                          _2142 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2146 = log2(max((lerp(_2059, _2057, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2147 = _2146 * 0.3010300099849701f;
                    do {
                      if (!(!(_2147 <= _2073))) {
                        _2216 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2154 = log2(cb0_009x);
                        float _2155 = _2154 * 0.3010300099849701f;
                        if ((bool)(_2147 > _2073) && (bool)(_2147 < _2155)) {
                          float _2163 = ((_2146 - _2072) * 0.9030900001525879f) / ((_2154 - _2072) * 0.3010300099849701f);
                          int _2164 = int(_2163);
                          float _2166 = _2163 - float((int)(_2164));
                          float _2168 = _10[_2164];
                          float _2171 = _10[(_2164 + 1)];
                          float _2176 = _2168 * 0.5f;
                          _2216 = dot(float3((_2166 * _2166), _2166, 1.0f), float3(mad((_10[(_2164 + 2)]), 0.5f, mad(_2171, -1.0f, _2176)), (_2171 - _2168), mad(_2171, 0.5f, _2176)));
                        } else {
                          do {
                            if (!(!(_2147 >= _2155))) {
                              float _2185 = log2(cb0_008z);
                              if (_2147 < (_2185 * 0.3010300099849701f)) {
                                float _2193 = ((_2146 - _2154) * 0.9030900001525879f) / ((_2185 - _2154) * 0.3010300099849701f);
                                int _2194 = int(_2193);
                                float _2196 = _2193 - float((int)(_2194));
                                float _2198 = _11[_2194];
                                float _2201 = _11[(_2194 + 1)];
                                float _2206 = _2198 * 0.5f;
                                _2216 = dot(float3((_2196 * _2196), _2196, 1.0f), float3(mad((_11[(_2194 + 2)]), 0.5f, mad(_2201, -1.0f, _2206)), (_2201 - _2198), mad(_2201, 0.5f, _2206)));
                                break;
                              }
                            }
                            _2216 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2220 = log2(max((lerp(_2059, _2058, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2221 = _2220 * 0.3010300099849701f;
                      do {
                        if (!(!(_2221 <= _2073))) {
                          _2290 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2228 = log2(cb0_009x);
                          float _2229 = _2228 * 0.3010300099849701f;
                          if ((bool)(_2221 > _2073) && (bool)(_2221 < _2229)) {
                            float _2237 = ((_2220 - _2072) * 0.9030900001525879f) / ((_2228 - _2072) * 0.3010300099849701f);
                            int _2238 = int(_2237);
                            float _2240 = _2237 - float((int)(_2238));
                            float _2242 = _10[_2238];
                            float _2245 = _10[(_2238 + 1)];
                            float _2250 = _2242 * 0.5f;
                            _2290 = dot(float3((_2240 * _2240), _2240, 1.0f), float3(mad((_10[(_2238 + 2)]), 0.5f, mad(_2245, -1.0f, _2250)), (_2245 - _2242), mad(_2245, 0.5f, _2250)));
                          } else {
                            do {
                              if (!(!(_2221 >= _2229))) {
                                float _2259 = log2(cb0_008z);
                                if (_2221 < (_2259 * 0.3010300099849701f)) {
                                  float _2267 = ((_2220 - _2228) * 0.9030900001525879f) / ((_2259 - _2228) * 0.3010300099849701f);
                                  int _2268 = int(_2267);
                                  float _2270 = _2267 - float((int)(_2268));
                                  float _2272 = _11[_2268];
                                  float _2275 = _11[(_2268 + 1)];
                                  float _2280 = _2272 * 0.5f;
                                  _2290 = dot(float3((_2270 * _2270), _2270, 1.0f), float3(mad((_11[(_2268 + 2)]), 0.5f, mad(_2275, -1.0f, _2280)), (_2275 - _2272), mad(_2275, 0.5f, _2280)));
                                  break;
                                }
                              }
                              _2290 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2294 = cb0_008w - cb0_008y;
                        float _2295 = (exp2(_2142 * 3.321928024291992f) - cb0_008y) / _2294;
                        float _2297 = (exp2(_2216 * 3.321928024291992f) - cb0_008y) / _2294;
                        float _2299 = (exp2(_2290 * 3.321928024291992f) - cb0_008y) / _2294;
                        float _2302 = mad(0.15618768334388733f, _2299, mad(0.13400420546531677f, _2297, (_2295 * 0.6624541878700256f)));
                        float _2305 = mad(0.053689517080783844f, _2299, mad(0.6740817427635193f, _2297, (_2295 * 0.2722287178039551f)));
                        float _2308 = mad(1.0103391408920288f, _2299, mad(0.00406073359772563f, _2297, (_2295 * -0.005574649665504694f)));
                        float _2321 = min(max(mad(-0.23642469942569733f, _2308, mad(-0.32480329275131226f, _2305, (_2302 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2322 = min(max(mad(0.016756348311901093f, _2308, mad(1.6153316497802734f, _2305, (_2302 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2323 = min(max(mad(0.9883948564529419f, _2308, mad(-0.008284442126750946f, _2305, (_2302 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2326 = mad(0.15618768334388733f, _2323, mad(0.13400420546531677f, _2322, (_2321 * 0.6624541878700256f)));
                        float _2329 = mad(0.053689517080783844f, _2323, mad(0.6740817427635193f, _2322, (_2321 * 0.2722287178039551f)));
                        float _2332 = mad(1.0103391408920288f, _2323, mad(0.00406073359772563f, _2322, (_2321 * -0.005574649665504694f)));
                        float _2354 = min(max((min(max(mad(-0.23642469942569733f, _2332, mad(-0.32480329275131226f, _2329, (_2326 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2355 = min(max((min(max(mad(0.016756348311901093f, _2332, mad(1.6153316497802734f, _2329, (_2326 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2356 = min(max((min(max(mad(0.9883948564529419f, _2332, mad(-0.008284442126750946f, _2329, (_2326 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 6)) {
                            _2369 = mad(_41, _2356, mad(_40, _2355, (_2354 * _39)));
                            _2370 = mad(_44, _2356, mad(_43, _2355, (_2354 * _42)));
                            _2371 = mad(_47, _2356, mad(_46, _2355, (_2354 * _45)));
                          } else {
                            _2369 = _2354;
                            _2370 = _2355;
                            _2371 = _2356;
                          }
                          float _2381 = exp2(log2(_2369 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2382 = exp2(log2(_2370 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2383 = exp2(log2(_2371 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2548 = exp2(log2((1.0f / ((_2381 * 18.6875f) + 1.0f)) * ((_2381 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2549 = exp2(log2((1.0f / ((_2382 * 18.6875f) + 1.0f)) * ((_2382 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2550 = exp2(log2((1.0f / ((_2383 * 18.6875f) + 1.0f)) * ((_2383 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2428 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1110, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1109, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1108)));
            float _2431 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1110, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1109, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1108)));
            float _2434 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1110, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1109, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1108)));
            float _2453 = exp2(log2(mad(_41, _2434, mad(_40, _2431, (_2428 * _39))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2454 = exp2(log2(mad(_44, _2434, mad(_43, _2431, (_2428 * _42))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2455 = exp2(log2(mad(_47, _2434, mad(_46, _2431, (_2428 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2548 = exp2(log2((1.0f / ((_2453 * 18.6875f) + 1.0f)) * ((_2453 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2549 = exp2(log2((1.0f / ((_2454 * 18.6875f) + 1.0f)) * ((_2454 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2550 = exp2(log2((1.0f / ((_2455 * 18.6875f) + 1.0f)) * ((_2455 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2502 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1098, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1097, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1096)));
                float _2505 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1098, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1097, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1096)));
                float _2508 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1098, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1097, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1096)));
                _2548 = mad(_41, _2508, mad(_40, _2505, (_2502 * _39)));
                _2549 = mad(_44, _2508, mad(_43, _2505, (_2502 * _42)));
                _2550 = mad(_47, _2508, mad(_46, _2505, (_2502 * _45)));
              } else {
                float _2521 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1122)));
                float _2524 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1122)));
                float _2527 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1124, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1123, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1122)));
                _2548 = exp2(log2(mad(_41, _2527, mad(_40, _2524, (_2521 * _39)))) * cb0_040z);
                _2549 = exp2(log2(mad(_44, _2527, mad(_43, _2524, (_2521 * _42)))) * cb0_040z);
                _2550 = exp2(log2(mad(_47, _2527, mad(_46, _2524, (_2521 * _45)))) * cb0_040z);
              }
            } else {
              _2548 = _1108;
              _2549 = _1109;
              _2550 = _1110;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2548 * 0.9523810148239136f);
  SV_Target.y = (_2549 * 0.9523810148239136f);
  SV_Target.z = (_2550 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
