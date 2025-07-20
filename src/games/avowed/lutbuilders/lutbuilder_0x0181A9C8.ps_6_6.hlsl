// Found in Marvel Rivals

#include "../common.hlsl"

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
  float cb0_035y : packoffset(c035.y);
  float cb0_035z : packoffset(c035.z);
  float cb0_035w : packoffset(c035.w);
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_036w : packoffset(c036.w);
  float cb0_037x : packoffset(c037.x);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  float cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  int cb0_041w : packoffset(c041.w);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  float cb0_043y : packoffset(c043.y);
  int cb0_044x : packoffset(c044.x);
};

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
};

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _10 = 0.5f / cb0_035x;
  float _15 = cb0_035x + -1.0f;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _110;
  float _817;
  float _850;
  float _864;
  float _928;
  float _1181;
  float _1182;
  float _1183;
  float _1194;
  float _1205;
  float _1216;
  if (!(cb0_044x == 1)) {
    if (!(cb0_044x == 2)) {
      if (!(cb0_044x == 3)) {
        bool _28 = (cb0_044x == 4);
        _39 = select(_28, 1.0f, 1.705051064491272f);
        _40 = select(_28, 0.0f, -0.6217921376228333f);
        _41 = select(_28, 0.0f, -0.0832589864730835f);
        _42 = select(_28, 0.0f, -0.13025647401809692f);
        _43 = select(_28, 1.0f, 1.140804648399353f);
        _44 = select(_28, 0.0f, -0.010548308491706848f);
        _45 = select(_28, 0.0f, -0.024003351107239723f);
        _46 = select(_28, 0.0f, -0.1289689838886261f);
        _47 = select(_28, 1.0f, 1.1529725790023804f);
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
      _39 = 1.0258246660232544f;
      _40 = -0.020053181797266006f;
      _41 = -0.005771636962890625f;
      _42 = -0.002234415616840124f;
      _43 = 1.0045864582061768f;
      _44 = -0.002352118492126465f;
      _45 = -0.005013350863009691f;
      _46 = -0.025290070101618767f;
      _47 = 1.0303035974502563f;
    }
  } else {
    _39 = 1.3792141675949097f;
    _40 = -0.30886411666870117f;
    _41 = -0.0703500509262085f;
    _42 = -0.06933490186929703f;
    _43 = 1.08229660987854f;
    _44 = -0.012961871922016144f;
    _45 = -0.0021590073592960835f;
    _46 = -0.0454593189060688f;
    _47 = 1.0476183891296387f;
  }
  float _60 = (exp2((((cb0_035x * (TEXCOORD.x - _10)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _61 = (exp2((((cb0_035x * (TEXCOORD.y - _10)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _62 = (exp2(((float((uint)(int)(SV_RenderTargetArrayIndex)) / _15) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _89 = (cb0_041w != 0);
  float _93 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _110 = (((((2967800.0f - (_93 * 4607000064.0f)) * _93) + 99.11000061035156f) * _93) + 0.24406300485134125f);
  } else {
    _110 = (((((1901800.0f - (_93 * 2006400000.0f)) * _93) + 247.47999572753906f) * _93) + 0.23703999817371368f);
  }
  float _124 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  float _131 = cb0_035y * cb0_035y;
  float _134 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_131 * 1.6145605741257896e-07f));
  float _139 = ((_124 * 2.0f) + 4.0f) - (_134 * 8.0f);
  float _140 = (_124 * 3.0f) / _139;
  float _142 = (_134 * 2.0f) / _139;
  bool _143 = (cb0_035y < 4000.0f);
  float _152 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  float _154 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_131 * 1.5317699909210205f)) / (_152 * _152);
  float _161 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _131;
  float _163 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_131 * 308.60699462890625f)) / (_161 * _161);
  float _165 = rsqrt(dot(float2(_154, _163), float2(_154, _163)));
  float _166 = cb0_035z * 0.05000000074505806f;
  float _169 = ((_166 * _163) * _165) + _124;
  float _172 = _134 - ((_166 * _154) * _165);
  float _177 = (4.0f - (_172 * 8.0f)) + (_169 * 2.0f);
  float _183 = (((_169 * 3.0f) / _177) - _140) + select(_143, _140, _110);
  float _184 = (((_172 * 2.0f) / _177) - _142) + select(_143, _142, (((_110 * 2.869999885559082f) + -0.2750000059604645f) - ((_110 * _110) * 3.0f)));
  float _185 = select(_89, _183, 0.3127000033855438f);
  float _186 = select(_89, _184, 0.32899999618530273f);
  float _187 = select(_89, 0.3127000033855438f, _183);
  float _188 = select(_89, 0.32899999618530273f, _184);
  float _189 = max(_186, 1.000000013351432e-10f);
  float _190 = _185 / _189;
  float _193 = ((1.0f - _185) - _186) / _189;
  float _194 = max(_188, 1.000000013351432e-10f);
  float _195 = _187 / _194;
  float _198 = ((1.0f - _187) - _188) / _194;
  float _217 = mad(-0.16140000522136688f, _198, ((_195 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _193, ((_190 * 0.8950999975204468f) + 0.266400009393692f));
  float _218 = mad(0.03669999912381172f, _198, (1.7135000228881836f - (_195 * 0.7501999735832214f))) / mad(0.03669999912381172f, _193, (1.7135000228881836f - (_190 * 0.7501999735832214f)));
  float _219 = mad(1.0296000242233276f, _198, ((_195 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _193, ((_190 * 0.03889999911189079f) + -0.06849999725818634f));
  float _220 = mad(_218, -0.7501999735832214f, 0.0f);
  float _221 = mad(_218, 1.7135000228881836f, 0.0f);
  float _222 = mad(_218, 0.03669999912381172f, -0.0f);
  float _223 = mad(_219, 0.03889999911189079f, 0.0f);
  float _224 = mad(_219, -0.06849999725818634f, 0.0f);
  float _225 = mad(_219, 1.0296000242233276f, 0.0f);
  float _228 = mad(0.1599626988172531f, _223, mad(-0.1470542997121811f, _220, (_217 * 0.883457362651825f)));
  float _231 = mad(0.1599626988172531f, _224, mad(-0.1470542997121811f, _221, (_217 * 0.26293492317199707f)));
  float _234 = mad(0.1599626988172531f, _225, mad(-0.1470542997121811f, _222, (_217 * -0.15930065512657166f)));
  float _237 = mad(0.04929120093584061f, _223, mad(0.5183603167533875f, _220, (_217 * 0.38695648312568665f)));
  float _240 = mad(0.04929120093584061f, _224, mad(0.5183603167533875f, _221, (_217 * 0.11516613513231277f)));
  float _243 = mad(0.04929120093584061f, _225, mad(0.5183603167533875f, _222, (_217 * -0.0697740763425827f)));
  float _246 = mad(0.9684867262840271f, _223, mad(0.04004279896616936f, _220, (_217 * -0.007634039502590895f)));
  float _249 = mad(0.9684867262840271f, _224, mad(0.04004279896616936f, _221, (_217 * -0.0022720457054674625f)));
  float _252 = mad(0.9684867262840271f, _225, mad(0.04004279896616936f, _222, (_217 * 0.0013765322510153055f)));
  float _255 = mad(_234, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_231, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_228 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _258 = mad(_234, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_231, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_228 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _261 = mad(_234, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_231, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_228 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _264 = mad(_243, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_240, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_237 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _267 = mad(_243, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_240, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_237 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _270 = mad(_243, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_240, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_237 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _273 = mad(_252, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_249, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_246 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _276 = mad(_252, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_249, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_246 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _279 = mad(_252, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_249, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_246 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _309 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _279, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _270, (_261 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _62, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _276, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _267, (_258 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _61, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _273, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _264, (_255 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _60)));
  float _312 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _279, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _270, (_261 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _62, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _276, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _267, (_258 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _61, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _273, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _264, (_255 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _60)));
  float _315 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _279, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _270, (_261 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _62, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _276, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _267, (_258 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _61, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _273, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _264, (_255 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _60)));
  float _330 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _315, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _312, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _309)));
  float _333 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _315, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _312, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _309)));
  float _336 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _315, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _312, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _309)));
  float _337 = dot(float3(_330, _333, _336), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_330, _333, _336));

  float _341 = (_330 / _337) + -1.0f;
  float _342 = (_333 / _337) + -1.0f;
  float _343 = (_336 / _337) + -1.0f;
  float _355 = (1.0f - exp2(((_337 * _337) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_341, _342, _343), float3(_341, _342, _343)) * -4.0f));
  float _371 = ((mad(-0.06368321925401688f, _336, mad(-0.3292922377586365f, _333, (_330 * 1.3704125881195068f))) - _330) * _355) + _330;
  float _372 = ((mad(-0.010861365124583244f, _336, mad(1.0970927476882935f, _333, (_330 * -0.08343357592821121f))) - _333) * _355) + _333;
  float _373 = ((mad(1.2036951780319214f, _336, mad(-0.09862580895423889f, _333, (_330 * -0.02579331398010254f))) - _336) * _355) + _336;
  float _374 = dot(float3(_371, _372, _373), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _388 = cb0_019w + cb0_024w;
  float _402 = cb0_018w * cb0_023w;
  float _416 = cb0_017w * cb0_022w;
  float _430 = cb0_016w * cb0_021w;
  float _444 = cb0_015w * cb0_020w;
  float _448 = _371 - _374;
  float _449 = _372 - _374;
  float _450 = _373 - _374;
  float _507 = saturate(_374 / cb0_035w);
  float _511 = (_507 * _507) * (3.0f - (_507 * 2.0f));
  float _512 = 1.0f - _511;
  float _521 = cb0_019w + cb0_034w;
  float _530 = cb0_018w * cb0_033w;
  float _539 = cb0_017w * cb0_032w;
  float _548 = cb0_016w * cb0_031w;
  float _557 = cb0_015w * cb0_030w;
  float _620 = saturate((_374 - cb0_036x) / (cb0_036y - cb0_036x));
  float _624 = (_620 * _620) * (3.0f - (_620 * 2.0f));
  float _633 = cb0_019w + cb0_029w;
  float _642 = cb0_018w * cb0_028w;
  float _651 = cb0_017w * cb0_027w;
  float _660 = cb0_016w * cb0_026w;
  float _669 = cb0_015w * cb0_025w;
  float _727 = _511 - _624;
  float _738 = ((_624 * (((cb0_019x + cb0_034x) + _521) + (((cb0_018x * cb0_033x) * _530) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _548) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _557) * _448) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _539)))))) + (_512 * (((cb0_019x + cb0_024x) + _388) + (((cb0_018x * cb0_023x) * _402) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _430) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _444) * _448) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _416))))))) + ((((cb0_019x + cb0_029x) + _633) + (((cb0_018x * cb0_028x) * _642) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _660) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _669) * _448) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _651))))) * _727);
  float _740 = ((_624 * (((cb0_019y + cb0_034y) + _521) + (((cb0_018y * cb0_033y) * _530) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _548) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _557) * _449) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _539)))))) + (_512 * (((cb0_019y + cb0_024y) + _388) + (((cb0_018y * cb0_023y) * _402) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _430) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _444) * _449) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _416))))))) + ((((cb0_019y + cb0_029y) + _633) + (((cb0_018y * cb0_028y) * _642) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _660) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _669) * _449) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _651))))) * _727);
  float _742 = ((_624 * (((cb0_019z + cb0_034z) + _521) + (((cb0_018z * cb0_033z) * _530) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _548) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _557) * _450) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _539)))))) + (_512 * (((cb0_019z + cb0_024z) + _388) + (((cb0_018z * cb0_023z) * _402) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _430) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _444) * _450) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _416))))))) + ((((cb0_019z + cb0_029z) + _633) + (((cb0_018z * cb0_028z) * _642) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _660) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _669) * _450) + _374)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _651))))) * _727);

  SetUntonemappedAP1(float3(_738, _740, _742));

  float _757 = ((mad(0.061360642313957214f, _742, mad(-4.540197551250458e-09f, _740, (_738 * 0.9386394023895264f))) - _738) * cb0_036z) + _738;
  float _758 = ((mad(0.169205904006958f, _742, mad(0.8307942152023315f, _740, (_738 * 6.775371730327606e-08f))) - _740) * cb0_036z) + _740;
  float _759 = (mad(-2.3283064365386963e-10f, _740, (_738 * -9.313225746154785e-10f)) * cb0_036z) + _742;
  float _762 = mad(0.16386905312538147f, _759, mad(0.14067868888378143f, _758, (_757 * 0.6954522132873535f)));
  float _765 = mad(0.0955343246459961f, _759, mad(0.8596711158752441f, _758, (_757 * 0.044794581830501556f)));
  float _768 = mad(1.0015007257461548f, _759, mad(0.004025210160762072f, _758, (_757 * -0.005525882821530104f)));
  float _772 = max(max(_762, _765), _768);
  float _777 = (max(_772, 1.000000013351432e-10f) - max(min(min(_762, _765), _768), 1.000000013351432e-10f)) / max(_772, 0.009999999776482582f);
  float _790 = ((_765 + _762) + _768) + (sqrt((((_768 - _765) * _768) + ((_765 - _762) * _765)) + ((_762 - _768) * _762)) * 1.75f);
  float _791 = _790 * 0.3333333432674408f;
  float _792 = _777 + -0.4000000059604645f;
  float _793 = _792 * 5.0f;
  float _797 = max((1.0f - abs(_792 * 2.5f)), 0.0f);
  float _808 = ((float(((int)(uint)((bool)(_793 > 0.0f))) - ((int)(uint)((bool)(_793 < 0.0f)))) * (1.0f - (_797 * _797))) + 1.0f) * 0.02500000037252903f;
  if (!(_791 <= 0.0533333346247673f)) {
    if (!(_791 >= 0.1599999964237213f)) {
      _817 = (((0.23999999463558197f / _790) + -0.5f) * _808);
    } else {
      _817 = 0.0f;
    }
  } else {
    _817 = _808;
  }
  float _818 = _817 + 1.0f;
  float _819 = _818 * _762;
  float _820 = _818 * _765;
  float _821 = _818 * _768;
  if (!((bool)(_819 == _820) && (bool)(_820 == _821))) {
    float _828 = ((_819 * 2.0f) - _820) - _821;
    float _831 = ((_765 - _768) * 1.7320507764816284f) * _818;
    float _833 = atan(_831 / _828);
    bool _836 = (_828 < 0.0f);
    bool _837 = (_828 == 0.0f);
    bool _838 = (_831 >= 0.0f);
    bool _839 = (_831 < 0.0f);
    _850 = select((_838 && _837), 90.0f, select((_839 && _837), -90.0f, (select((_839 && _836), (_833 + -3.1415927410125732f), select((_838 && _836), (_833 + 3.1415927410125732f), _833)) * 57.2957763671875f)));
  } else {
    _850 = 0.0f;
  }
  float _855 = min(max(select((_850 < 0.0f), (_850 + 360.0f), _850), 0.0f), 360.0f);
  if (_855 < -180.0f) {
    _864 = (_855 + 360.0f);
  } else {
    if (_855 > 180.0f) {
      _864 = (_855 + -360.0f);
    } else {
      _864 = _855;
    }
  }
  float _868 = saturate(1.0f - abs(_864 * 0.014814814552664757f));
  float _872 = (_868 * _868) * (3.0f - (_868 * 2.0f));
  float _878 = ((_872 * _872) * ((_777 * 0.18000000715255737f) * (0.029999999329447746f - _819))) + _819;
  float _888 = max(0.0f, mad(-0.21492856740951538f, _821, mad(-0.2365107536315918f, _820, (_878 * 1.4514392614364624f))));
  float _889 = max(0.0f, mad(-0.09967592358589172f, _821, mad(1.17622971534729f, _820, (_878 * -0.07655377686023712f))));
  float _890 = max(0.0f, mad(0.9977163076400757f, _821, mad(-0.006032449658960104f, _820, (_878 * 0.008316148072481155f))));
  float _891 = dot(float3(_888, _889, _890), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _906 = (cb0_041x + 1.0f) - cb0_040z;
  float _908 = cb0_041y + 1.0f;
  float _910 = _908 - cb0_040w;
  if (cb0_040z > 0.800000011920929f) {
    _928 = (((0.8199999928474426f - cb0_040z) / cb0_040y) + -0.7447274923324585f);
  } else {
    float _919 = (cb0_041x + 0.18000000715255737f) / _906;
    _928 = (-0.7447274923324585f - ((log2(_919 / (2.0f - _919)) * 0.3465735912322998f) * (_906 / cb0_040y)));
  }
  float _931 = ((1.0f - cb0_040z) / cb0_040y) - _928;
  float _933 = (cb0_040w / cb0_040y) - _931;
  float _937 = log2(lerp(_891, _888, 0.9599999785423279f)) * 0.3010300099849701f;
  float _938 = log2(lerp(_891, _889, 0.9599999785423279f)) * 0.3010300099849701f;
  float _939 = log2(lerp(_891, _890, 0.9599999785423279f)) * 0.3010300099849701f;
  float _943 = cb0_040y * (_937 + _931);
  float _944 = cb0_040y * (_938 + _931);
  float _945 = cb0_040y * (_939 + _931);
  float _946 = _906 * 2.0f;
  float _948 = (cb0_040y * -2.0f) / _906;
  float _949 = _937 - _928;
  float _950 = _938 - _928;
  float _951 = _939 - _928;
  float _970 = _910 * 2.0f;
  float _972 = (cb0_040y * 2.0f) / _910;
  float _997 = select((_937 < _928), ((_946 / (exp2((_949 * 1.4426950216293335f) * _948) + 1.0f)) - cb0_041x), _943);
  float _998 = select((_938 < _928), ((_946 / (exp2((_950 * 1.4426950216293335f) * _948) + 1.0f)) - cb0_041x), _944);
  float _999 = select((_939 < _928), ((_946 / (exp2((_951 * 1.4426950216293335f) * _948) + 1.0f)) - cb0_041x), _945);
  float _1006 = _933 - _928;
  float _1010 = saturate(_949 / _1006);
  float _1011 = saturate(_950 / _1006);
  float _1012 = saturate(_951 / _1006);
  bool _1013 = (_933 < _928);
  float _1017 = select(_1013, (1.0f - _1010), _1010);
  float _1018 = select(_1013, (1.0f - _1011), _1011);
  float _1019 = select(_1013, (1.0f - _1012), _1012);
  float _1038 = (((_1017 * _1017) * (select((_937 > _933), (_908 - (_970 / (exp2(((_937 - _933) * 1.4426950216293335f) * _972) + 1.0f))), _943) - _997)) * (3.0f - (_1017 * 2.0f))) + _997;
  float _1039 = (((_1018 * _1018) * (select((_938 > _933), (_908 - (_970 / (exp2(((_938 - _933) * 1.4426950216293335f) * _972) + 1.0f))), _944) - _998)) * (3.0f - (_1018 * 2.0f))) + _998;
  float _1040 = (((_1019 * _1019) * (select((_939 > _933), (_908 - (_970 / (exp2(((_939 - _933) * 1.4426950216293335f) * _972) + 1.0f))), _945) - _999)) * (3.0f - (_1019 * 2.0f))) + _999;
  float _1041 = dot(float3(_1038, _1039, _1040), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1062 = (cb0_037x * (max(0.0f, (lerp(_1041, _1038, 0.9300000071525574f))) - _757)) + _757;
  float _1063 = (cb0_037x * (max(0.0f, (lerp(_1041, _1039, 0.9300000071525574f))) - _758)) + _758;
  float _1064 = (cb0_037x * (max(0.0f, (lerp(_1041, _1040, 0.9300000071525574f))) - _759)) + _759;
  float _1080 = ((mad(-0.06537103652954102f, _1064, mad(1.451815478503704e-06f, _1063, (_1062 * 1.065374732017517f))) - _1062) * cb0_036z) + _1062;
  float _1081 = ((mad(-0.20366770029067993f, _1064, mad(1.2036634683609009f, _1063, (_1062 * -2.57161445915699e-07f))) - _1063) * cb0_036z) + _1063;
  float _1082 = ((mad(0.9999996423721313f, _1064, mad(2.0954757928848267e-08f, _1063, (_1062 * 1.862645149230957e-08f))) - _1064) * cb0_036z) + _1064;

  SetTonemappedAP1(_1080, _1081, _1082);

  float _1104 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1082, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1081, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1080))));
  float _1105 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1082, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1081, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1080))));
  float _1106 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1082, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1081, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1080))));
  float _1132 = cb0_014x * (((cb0_042y + (cb0_042x * _1104)) * _1104) + cb0_042z);
  float _1133 = cb0_014y * (((cb0_042y + (cb0_042x * _1105)) * _1105) + cb0_042z);
  float _1134 = cb0_014z * (((cb0_042y + (cb0_042x * _1106)) * _1106) + cb0_042z);
  float _1155 = exp2(log2(max(0.0f, (lerp(_1132, cb0_013x, cb0_013w)))) * cb0_043y);
  float _1156 = exp2(log2(max(0.0f, (lerp(_1133, cb0_013y, cb0_013w)))) * cb0_043y);
  float _1157 = exp2(log2(max(0.0f, (lerp(_1134, cb0_013z, cb0_013w)))) * cb0_043y);

  if (true) {
    return GenerateOutput(float3(_1155, _1156, _1157));
  }

  if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
    float _1164 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1157, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1156, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1155)));
    float _1167 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1157, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1156, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1155)));
    float _1170 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1157, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1156, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1155)));
    _1181 = mad(_41, _1170, mad(_40, _1167, (_1164 * _39)));
    _1182 = mad(_44, _1170, mad(_43, _1167, (_1164 * _42)));
    _1183 = mad(_47, _1170, mad(_46, _1167, (_1164 * _45)));
  } else {
    _1181 = _1155;
    _1182 = _1156;
    _1183 = _1157;
  }
  if (_1181 < 0.0031306699384003878f) {
    _1194 = (_1181 * 12.920000076293945f);
  } else {
    _1194 = (((pow(_1181, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1182 < 0.0031306699384003878f) {
    _1205 = (_1182 * 12.920000076293945f);
  } else {
    _1205 = (((pow(_1182, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1183 < 0.0031306699384003878f) {
    _1216 = (_1183 * 12.920000076293945f);
  } else {
    _1216 = (((pow(_1183, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1194 * 0.9523810148239136f);
  SV_Target.y = (_1205 * 0.9523810148239136f);
  SV_Target.z = (_1216 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
