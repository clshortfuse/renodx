// High on Life 2, UE 5.5

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

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
  float cb0_012w : packoffset(c012.w);
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
  float cb0_037y : packoffset(c037.y);
  float cb0_037z : packoffset(c037.z);
  float cb0_037w : packoffset(c037.w);
  float cb0_038x : packoffset(c038.x);
  float cb0_038y : packoffset(c038.y);
  int cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
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
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  float _34 = 0.5f / cb0_035x;
  float _39 = cb0_035x + -1.0f;
  float _40 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _34)) / _39;
  float _41 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _34)) / _39;
  float _43 = float((uint)SV_DispatchThreadID.z) / _39;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _129;
  float _130;
  float _131;
  float _179;
  float _907;
  float _940;
  float _954;
  float _1018;
  float _1197;
  float _1208;
  float _1219;
  float _1390;
  float _1391;
  float _1392;
  float _1403;
  float _1414;
  float _1587;
  float _1602;
  float _1617;
  float _1625;
  float _1626;
  float _1627;
  float _1694;
  float _1727;
  float _1741;
  float _1780;
  float _1902;
  float _1988;
  float _2062;
  float _2141;
  float _2142;
  float _2143;
  float _2273;
  float _2288;
  float _2303;
  float _2311;
  float _2312;
  float _2313;
  float _2380;
  float _2413;
  float _2427;
  float _2466;
  float _2588;
  float _2674;
  float _2760;
  float _2839;
  float _2840;
  float _2841;
  float _3018;
  float _3019;
  float _3020;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _52 = (cb0_041x == 4);
        _63 = select(_52, 1.0f, 1.705051064491272f);
        _64 = select(_52, 0.0f, -0.6217921376228333f);
        _65 = select(_52, 0.0f, -0.0832589864730835f);
        _66 = select(_52, 0.0f, -0.13025647401809692f);
        _67 = select(_52, 1.0f, 1.140804648399353f);
        _68 = select(_52, 0.0f, -0.010548308491706848f);
        _69 = select(_52, 0.0f, -0.024003351107239723f);
        _70 = select(_52, 0.0f, -0.1289689838886261f);
        _71 = select(_52, 1.0f, 1.1529725790023804f);
      } else {
        _63 = 0.6954522132873535f;
        _64 = 0.14067870378494263f;
        _65 = 0.16386906802654266f;
        _66 = 0.044794563204050064f;
        _67 = 0.8596711158752441f;
        _68 = 0.0955343171954155f;
        _69 = -0.005525882821530104f;
        _70 = 0.004025210160762072f;
        _71 = 1.0015007257461548f;
      }
    } else {
      _63 = 1.0258246660232544f;
      _64 = -0.020053181797266006f;
      _65 = -0.005771636962890625f;
      _66 = -0.002234415616840124f;
      _67 = 1.0045864582061768f;
      _68 = -0.002352118492126465f;
      _69 = -0.005013350863009691f;
      _70 = -0.025290070101618767f;
      _71 = 1.0303035974502563f;
    }
  } else {
    _63 = 1.3792141675949097f;
    _64 = -0.30886411666870117f;
    _65 = -0.0703500509262085f;
    _66 = -0.06933490186929703f;
    _67 = 1.08229660987854f;
    _68 = -0.012961871922016144f;
    _69 = -0.0021590073592960835f;
    _70 = -0.0454593189060688f;
    _71 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _82 = (pow(_40, 0.012683313339948654f));
    float _83 = (pow(_41, 0.012683313339948654f));
    float _84 = (pow(_43, 0.012683313339948654f));
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _130 = (exp2(log2(max(0.0f, (_83 + -0.8359375f)) / (18.8515625f - (_83 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _131 = (exp2(log2(max(0.0f, (_84 + -0.8359375f)) / (18.8515625f - (_84 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _129 = ((exp2((_40 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _130 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _131 = ((exp2((_43 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _158 = (cb0_038w != 0);
  float _162 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _179 = (((((2967800.0f - (_162 * 4607000064.0f)) * _162) + 99.11000061035156f) * _162) + 0.24406300485134125f);
  } else {
    _179 = (((((1901800.0f - (_162 * 2006400000.0f)) * _162) + 247.47999572753906f) * _162) + 0.23703999817371368f);
  }
  float _193 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  float _200 = cb0_035y * cb0_035y;
  float _203 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_200 * 1.6145605741257896e-07f));
  float _208 = ((_193 * 2.0f) + 4.0f) - (_203 * 8.0f);
  float _209 = (_193 * 3.0f) / _208;
  float _211 = (_203 * 2.0f) / _208;
  bool _212 = (cb0_035y < 4000.0f);
  float _221 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  float _223 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_200 * 1.5317699909210205f)) / (_221 * _221);
  float _230 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _200;
  float _232 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_200 * 308.60699462890625f)) / (_230 * _230);
  float _234 = rsqrt(dot(float2(_223, _232), float2(_223, _232)));
  float _235 = cb0_035z * 0.05000000074505806f;
  float _238 = ((_235 * _232) * _234) + _193;
  float _241 = _203 - ((_235 * _223) * _234);
  float _246 = (4.0f - (_241 * 8.0f)) + (_238 * 2.0f);
  float _252 = (((_238 * 3.0f) / _246) - _209) + select(_212, _209, _179);
  float _253 = (((_241 * 2.0f) / _246) - _211) + select(_212, _211, (((_179 * 2.869999885559082f) + -0.2750000059604645f) - ((_179 * _179) * 3.0f)));
  float _254 = select(_158, _252, 0.3127000033855438f);
  float _255 = select(_158, _253, 0.32899999618530273f);
  float _256 = select(_158, 0.3127000033855438f, _252);
  float _257 = select(_158, 0.32899999618530273f, _253);
  float _258 = max(_255, 1.000000013351432e-10f);
  float _259 = _254 / _258;
  float _262 = ((1.0f - _254) - _255) / _258;
  float _263 = max(_257, 1.000000013351432e-10f);
  float _264 = _256 / _263;
  float _267 = ((1.0f - _256) - _257) / _263;
  float _286 = mad(-0.16140000522136688f, _267, ((_264 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _262, ((_259 * 0.8950999975204468f) + 0.266400009393692f));
  float _287 = mad(0.03669999912381172f, _267, (1.7135000228881836f - (_264 * 0.7501999735832214f))) / mad(0.03669999912381172f, _262, (1.7135000228881836f - (_259 * 0.7501999735832214f)));
  float _288 = mad(1.0296000242233276f, _267, ((_264 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _262, ((_259 * 0.03889999911189079f) + -0.06849999725818634f));
  float _289 = mad(_287, -0.7501999735832214f, 0.0f);
  float _290 = mad(_287, 1.7135000228881836f, 0.0f);
  float _291 = mad(_287, 0.03669999912381172f, -0.0f);
  float _292 = mad(_288, 0.03889999911189079f, 0.0f);
  float _293 = mad(_288, -0.06849999725818634f, 0.0f);
  float _294 = mad(_288, 1.0296000242233276f, 0.0f);
  float _297 = mad(0.1599626988172531f, _292, mad(-0.1470542997121811f, _289, (_286 * 0.883457362651825f)));
  float _300 = mad(0.1599626988172531f, _293, mad(-0.1470542997121811f, _290, (_286 * 0.26293492317199707f)));
  float _303 = mad(0.1599626988172531f, _294, mad(-0.1470542997121811f, _291, (_286 * -0.15930065512657166f)));
  float _306 = mad(0.04929120093584061f, _292, mad(0.5183603167533875f, _289, (_286 * 0.38695648312568665f)));
  float _309 = mad(0.04929120093584061f, _293, mad(0.5183603167533875f, _290, (_286 * 0.11516613513231277f)));
  float _312 = mad(0.04929120093584061f, _294, mad(0.5183603167533875f, _291, (_286 * -0.0697740763425827f)));
  float _315 = mad(0.9684867262840271f, _292, mad(0.04004279896616936f, _289, (_286 * -0.007634039502590895f)));
  float _318 = mad(0.9684867262840271f, _293, mad(0.04004279896616936f, _290, (_286 * -0.0022720457054674625f)));
  float _321 = mad(0.9684867262840271f, _294, mad(0.04004279896616936f, _291, (_286 * 0.0013765322510153055f)));
  float _324 = mad(_303, (WorkingColorSpace_000[2].x), mad(_300, (WorkingColorSpace_000[1].x), (_297 * (WorkingColorSpace_000[0].x))));
  float _327 = mad(_303, (WorkingColorSpace_000[2].y), mad(_300, (WorkingColorSpace_000[1].y), (_297 * (WorkingColorSpace_000[0].y))));
  float _330 = mad(_303, (WorkingColorSpace_000[2].z), mad(_300, (WorkingColorSpace_000[1].z), (_297 * (WorkingColorSpace_000[0].z))));
  float _333 = mad(_312, (WorkingColorSpace_000[2].x), mad(_309, (WorkingColorSpace_000[1].x), (_306 * (WorkingColorSpace_000[0].x))));
  float _336 = mad(_312, (WorkingColorSpace_000[2].y), mad(_309, (WorkingColorSpace_000[1].y), (_306 * (WorkingColorSpace_000[0].y))));
  float _339 = mad(_312, (WorkingColorSpace_000[2].z), mad(_309, (WorkingColorSpace_000[1].z), (_306 * (WorkingColorSpace_000[0].z))));
  float _342 = mad(_321, (WorkingColorSpace_000[2].x), mad(_318, (WorkingColorSpace_000[1].x), (_315 * (WorkingColorSpace_000[0].x))));
  float _345 = mad(_321, (WorkingColorSpace_000[2].y), mad(_318, (WorkingColorSpace_000[1].y), (_315 * (WorkingColorSpace_000[0].y))));
  float _348 = mad(_321, (WorkingColorSpace_000[2].z), mad(_318, (WorkingColorSpace_000[1].z), (_315 * (WorkingColorSpace_000[0].z))));
  float _378 = mad(mad((WorkingColorSpace_064[0].z), _348, mad((WorkingColorSpace_064[0].y), _339, (_330 * (WorkingColorSpace_064[0].x)))), _131, mad(mad((WorkingColorSpace_064[0].z), _345, mad((WorkingColorSpace_064[0].y), _336, (_327 * (WorkingColorSpace_064[0].x)))), _130, (mad((WorkingColorSpace_064[0].z), _342, mad((WorkingColorSpace_064[0].y), _333, (_324 * (WorkingColorSpace_064[0].x)))) * _129)));
  float _381 = mad(mad((WorkingColorSpace_064[1].z), _348, mad((WorkingColorSpace_064[1].y), _339, (_330 * (WorkingColorSpace_064[1].x)))), _131, mad(mad((WorkingColorSpace_064[1].z), _345, mad((WorkingColorSpace_064[1].y), _336, (_327 * (WorkingColorSpace_064[1].x)))), _130, (mad((WorkingColorSpace_064[1].z), _342, mad((WorkingColorSpace_064[1].y), _333, (_324 * (WorkingColorSpace_064[1].x)))) * _129)));
  float _384 = mad(mad((WorkingColorSpace_064[2].z), _348, mad((WorkingColorSpace_064[2].y), _339, (_330 * (WorkingColorSpace_064[2].x)))), _131, mad(mad((WorkingColorSpace_064[2].z), _345, mad((WorkingColorSpace_064[2].y), _336, (_327 * (WorkingColorSpace_064[2].x)))), _130, (mad((WorkingColorSpace_064[2].z), _342, mad((WorkingColorSpace_064[2].y), _333, (_324 * (WorkingColorSpace_064[2].x)))) * _129)));
  float _399 = mad((WorkingColorSpace_128[0].z), _384, mad((WorkingColorSpace_128[0].y), _381, ((WorkingColorSpace_128[0].x) * _378)));
  float _402 = mad((WorkingColorSpace_128[1].z), _384, mad((WorkingColorSpace_128[1].y), _381, ((WorkingColorSpace_128[1].x) * _378)));
  float _405 = mad((WorkingColorSpace_128[2].z), _384, mad((WorkingColorSpace_128[2].y), _381, ((WorkingColorSpace_128[2].x) * _378)));
  float _406 = dot(float3(_399, _402, _405), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _410 = (_399 / _406) + -1.0f;
  float _411 = (_402 / _406) + -1.0f;
  float _412 = (_405 / _406) + -1.0f;

  // float _424 = (1.0f - exp2(((_406 * _406) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_410, _411, _412), float3(_410, _411, _412)) * -4.0f));
  float _424 = (1.0f - exp2(((_406 * _406) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_410, _411, _412), float3(_410, _411, _412)) * -4.0f));

  float _440 = ((mad(-0.06368321925401688f, _405, mad(-0.3292922377586365f, _402, (_399 * 1.3704125881195068f))) - _399) * _424) + _399;
  float _441 = ((mad(-0.010861365124583244f, _405, mad(1.0970927476882935f, _402, (_399 * -0.08343357592821121f))) - _402) * _424) + _402;
  float _442 = ((mad(1.2036951780319214f, _405, mad(-0.09862580895423889f, _402, (_399 * -0.02579331398010254f))) - _405) * _424) + _405;
  float _443 = dot(float3(_440, _441, _442), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _457 = cb0_019w + cb0_024w;
  float _471 = cb0_018w * cb0_023w;
  float _485 = cb0_017w * cb0_022w;
  float _499 = cb0_016w * cb0_021w;
  float _513 = cb0_015w * cb0_020w;
  float _517 = _440 - _443;
  float _518 = _441 - _443;
  float _519 = _442 - _443;
  float _576 = saturate(_443 / cb0_035w);
  float _580 = (_576 * _576) * (3.0f - (_576 * 2.0f));
  float _581 = 1.0f - _580;
  float _590 = cb0_019w + cb0_034w;
  float _599 = cb0_018w * cb0_033w;
  float _608 = cb0_017w * cb0_032w;
  float _617 = cb0_016w * cb0_031w;
  float _626 = cb0_015w * cb0_030w;
  float _689 = saturate((_443 - cb0_036x) / (cb0_036y - cb0_036x));
  float _693 = (_689 * _689) * (3.0f - (_689 * 2.0f));
  float _702 = cb0_019w + cb0_029w;
  float _711 = cb0_018w * cb0_028w;
  float _720 = cb0_017w * cb0_027w;
  float _729 = cb0_016w * cb0_026w;
  float _738 = cb0_015w * cb0_025w;
  float _796 = _580 - _693;
  float _807 = ((_693 * (((cb0_019x + cb0_034x) + _590) + (((cb0_018x * cb0_033x) * _599) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _617) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _626) * _517) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _608)))))) + (_581 * (((cb0_019x + cb0_024x) + _457) + (((cb0_018x * cb0_023x) * _471) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _499) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _513) * _517) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _485))))))) + ((((cb0_019x + cb0_029x) + _702) + (((cb0_018x * cb0_028x) * _711) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _729) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _738) * _517) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _720))))) * _796);
  float _809 = ((_693 * (((cb0_019y + cb0_034y) + _590) + (((cb0_018y * cb0_033y) * _599) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _617) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _626) * _518) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _608)))))) + (_581 * (((cb0_019y + cb0_024y) + _457) + (((cb0_018y * cb0_023y) * _471) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _499) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _513) * _518) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _485))))))) + ((((cb0_019y + cb0_029y) + _702) + (((cb0_018y * cb0_028y) * _711) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _729) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _738) * _518) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _720))))) * _796);
  float _811 = ((_693 * (((cb0_019z + cb0_034z) + _590) + (((cb0_018z * cb0_033z) * _599) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _617) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _626) * _519) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _608)))))) + (_581 * (((cb0_019z + cb0_024z) + _457) + (((cb0_018z * cb0_023z) * _471) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _499) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _513) * _519) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _485))))))) + ((((cb0_019z + cb0_029z) + _702) + (((cb0_018z * cb0_028z) * _711) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _729) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _738) * _519) + _443)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _720))))) * _796);

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
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xy is used

  float4 output = ProcessLutbuilder(float3(_807, _809, _811), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _847 = ((mad(0.061360642313957214f, _811, mad(-4.540197551250458e-09f, _809, (_807 * 0.9386394023895264f))) - _807) * cb0_036z) + _807;
  float _848 = ((mad(0.169205904006958f, _811, mad(0.8307942152023315f, _809, (_807 * 6.775371730327606e-08f))) - _809) * cb0_036z) + _809;
  float _849 = (mad(-2.3283064365386963e-10f, _809, (_807 * -9.313225746154785e-10f)) * cb0_036z) + _811;
  float _852 = mad(0.16386905312538147f, _849, mad(0.14067868888378143f, _848, (_847 * 0.6954522132873535f)));
  float _855 = mad(0.0955343246459961f, _849, mad(0.8596711158752441f, _848, (_847 * 0.044794581830501556f)));
  float _858 = mad(1.0015007257461548f, _849, mad(0.004025210160762072f, _848, (_847 * -0.005525882821530104f)));
  float _862 = max(max(_852, _855), _858);
  float _867 = (max(_862, 1.000000013351432e-10f) - max(min(min(_852, _855), _858), 1.000000013351432e-10f)) / max(_862, 0.009999999776482582f);
  float _880 = ((_855 + _852) + _858) + (sqrt((((_858 - _855) * _858) + ((_855 - _852) * _855)) + ((_852 - _858) * _852)) * 1.75f);
  float _881 = _880 * 0.3333333432674408f;
  float _882 = _867 + -0.4000000059604645f;
  float _883 = _882 * 5.0f;
  float _887 = max((1.0f - abs(_882 * 2.5f)), 0.0f);
  float _898 = ((float((int)(((int)(uint)((bool)(_883 > 0.0f))) - ((int)(uint)((bool)(_883 < 0.0f))))) * (1.0f - (_887 * _887))) + 1.0f) * 0.02500000037252903f;
  if (!(_881 <= 0.0533333346247673f)) {
    if (!(_881 >= 0.1599999964237213f)) {
      _907 = (((0.23999999463558197f / _880) + -0.5f) * _898);
    } else {
      _907 = 0.0f;
    }
  } else {
    _907 = _898;
  }
  float _908 = _907 + 1.0f;
  float _909 = _908 * _852;
  float _910 = _908 * _855;
  float _911 = _908 * _858;
  if (!((bool)(_909 == _910) && (bool)(_910 == _911))) {
    float _918 = ((_909 * 2.0f) - _910) - _911;
    float _921 = ((_855 - _858) * 1.7320507764816284f) * _908;
    float _923 = atan(_921 / _918);
    bool _926 = (_918 < 0.0f);
    bool _927 = (_918 == 0.0f);
    bool _928 = (_921 >= 0.0f);
    bool _929 = (_921 < 0.0f);
    _940 = select((_928 && _927), 90.0f, select((_929 && _927), -90.0f, (select((_929 && _926), (_923 + -3.1415927410125732f), select((_928 && _926), (_923 + 3.1415927410125732f), _923)) * 57.2957763671875f)));
  } else {
    _940 = 0.0f;
  }
  float _945 = min(max(select((_940 < 0.0f), (_940 + 360.0f), _940), 0.0f), 360.0f);
  if (_945 < -180.0f) {
    _954 = (_945 + 360.0f);
  } else {
    if (_945 > 180.0f) {
      _954 = (_945 + -360.0f);
    } else {
      _954 = _945;
    }
  }
  float _958 = saturate(1.0f - abs(_954 * 0.014814814552664757f));
  float _962 = (_958 * _958) * (3.0f - (_958 * 2.0f));
  float _968 = ((_962 * _962) * ((_867 * 0.18000000715255737f) * (0.029999999329447746f - _909))) + _909;
  float _978 = max(0.0f, mad(-0.21492856740951538f, _911, mad(-0.2365107536315918f, _910, (_968 * 1.4514392614364624f))));
  float _979 = max(0.0f, mad(-0.09967592358589172f, _911, mad(1.17622971534729f, _910, (_968 * -0.07655377686023712f))));
  float _980 = max(0.0f, mad(0.9977163076400757f, _911, mad(-0.006032449658960104f, _910, (_968 * 0.008316148072481155f))));
  float _981 = dot(float3(_978, _979, _980), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _996 = (cb0_038x + 1.0f) - cb0_037z;
  float _998 = cb0_038y + 1.0f;
  float _1000 = _998 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1018 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _1009 = (cb0_038x + 0.18000000715255737f) / _996;
    _1018 = (-0.7447274923324585f - ((log2(_1009 / (2.0f - _1009)) * 0.3465735912322998f) * (_996 / cb0_037y)));
  }
  float _1021 = ((1.0f - cb0_037z) / cb0_037y) - _1018;
  float _1023 = (cb0_037w / cb0_037y) - _1021;
  float _1027 = log2(lerp(_981, _978, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1028 = log2(lerp(_981, _979, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1029 = log2(lerp(_981, _980, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1033 = cb0_037y * (_1027 + _1021);
  float _1034 = cb0_037y * (_1028 + _1021);
  float _1035 = cb0_037y * (_1029 + _1021);
  float _1036 = _996 * 2.0f;
  float _1038 = (cb0_037y * -2.0f) / _996;
  float _1039 = _1027 - _1018;
  float _1040 = _1028 - _1018;
  float _1041 = _1029 - _1018;
  float _1060 = _1000 * 2.0f;
  float _1062 = (cb0_037y * 2.0f) / _1000;
  float _1087 = select((_1027 < _1018), ((_1036 / (exp2((_1039 * 1.4426950216293335f) * _1038) + 1.0f)) - cb0_038x), _1033);
  float _1088 = select((_1028 < _1018), ((_1036 / (exp2((_1040 * 1.4426950216293335f) * _1038) + 1.0f)) - cb0_038x), _1034);
  float _1089 = select((_1029 < _1018), ((_1036 / (exp2((_1041 * 1.4426950216293335f) * _1038) + 1.0f)) - cb0_038x), _1035);
  float _1096 = _1023 - _1018;
  float _1100 = saturate(_1039 / _1096);
  float _1101 = saturate(_1040 / _1096);
  float _1102 = saturate(_1041 / _1096);
  bool _1103 = (_1023 < _1018);
  float _1107 = select(_1103, (1.0f - _1100), _1100);
  float _1108 = select(_1103, (1.0f - _1101), _1101);
  float _1109 = select(_1103, (1.0f - _1102), _1102);
  float _1128 = (((_1107 * _1107) * (select((_1027 > _1023), (_998 - (_1060 / (exp2(((_1027 - _1023) * 1.4426950216293335f) * _1062) + 1.0f))), _1033) - _1087)) * (3.0f - (_1107 * 2.0f))) + _1087;
  float _1129 = (((_1108 * _1108) * (select((_1028 > _1023), (_998 - (_1060 / (exp2(((_1028 - _1023) * 1.4426950216293335f) * _1062) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
  float _1130 = (((_1109 * _1109) * (select((_1029 > _1023), (_998 - (_1060 / (exp2(((_1029 - _1023) * 1.4426950216293335f) * _1062) + 1.0f))), _1035) - _1089)) * (3.0f - (_1109 * 2.0f))) + _1089;
  float _1131 = dot(float3(_1128, _1129, _1130), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1151 = (cb0_037x * (max(0.0f, (lerp(_1131, _1128, 0.9300000071525574f))) - _847)) + _847;
  float _1152 = (cb0_037x * (max(0.0f, (lerp(_1131, _1129, 0.9300000071525574f))) - _848)) + _848;
  float _1153 = (cb0_037x * (max(0.0f, (lerp(_1131, _1130, 0.9300000071525574f))) - _849)) + _849;
  float _1169 = ((mad(-0.06537103652954102f, _1153, mad(1.451815478503704e-06f, _1152, (_1151 * 1.065374732017517f))) - _1151) * cb0_036z) + _1151;
  float _1170 = ((mad(-0.20366770029067993f, _1153, mad(1.2036634683609009f, _1152, (_1151 * -2.57161445915699e-07f))) - _1152) * cb0_036z) + _1152;
  float _1171 = ((mad(0.9999996423721313f, _1153, mad(2.0954757928848267e-08f, _1152, (_1151 * 1.862645149230957e-08f))) - _1153) * cb0_036z) + _1153;
  float _1184 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1171, mad((WorkingColorSpace_192[0].y), _1170, ((WorkingColorSpace_192[0].x) * _1169)))));
  float _1185 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1171, mad((WorkingColorSpace_192[1].y), _1170, ((WorkingColorSpace_192[1].x) * _1169)))));
  float _1186 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1171, mad((WorkingColorSpace_192[2].y), _1170, ((WorkingColorSpace_192[2].x) * _1169)))));
  if (_1184 < 0.0031306699384003878f) {
    _1197 = (_1184 * 12.920000076293945f);
  } else {
    _1197 = (((pow(_1184, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1185 < 0.0031306699384003878f) {
    _1208 = (_1185 * 12.920000076293945f);
  } else {
    _1208 = (((pow(_1185, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1186 < 0.0031306699384003878f) {
    _1219 = (_1186 * 12.920000076293945f);
  } else {
    _1219 = (((pow(_1186, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1223 = (_1208 * 0.9375f) + 0.03125f;
  float _1230 = _1219 * 15.0f;
  float _1231 = floor(_1230);
  float _1232 = _1230 - _1231;
  float _1234 = (((_1197 * 0.9375f) + 0.03125f) + _1231) * 0.0625f;
  float4 _1237 = t0.SampleLevel(s0, float2(_1234, _1223), 0.0f);
  float4 _1242 = t0.SampleLevel(s0, float2((_1234 + 0.0625f), _1223), 0.0f);
  float _1261 = max(6.103519990574569e-05f, (((lerp(_1237.x, _1242.x, _1232)) * cb0_005y) + (cb0_005x * _1197)));
  float _1262 = max(6.103519990574569e-05f, (((lerp(_1237.y, _1242.y, _1232)) * cb0_005y) + (cb0_005x * _1208)));
  float _1263 = max(6.103519990574569e-05f, (((lerp(_1237.z, _1242.z, _1232)) * cb0_005y) + (cb0_005x * _1219)));
  float _1285 = select((_1261 > 0.040449999272823334f), exp2(log2((_1261 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1261 * 0.07739938050508499f));
  float _1286 = select((_1262 > 0.040449999272823334f), exp2(log2((_1262 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1262 * 0.07739938050508499f));
  float _1287 = select((_1263 > 0.040449999272823334f), exp2(log2((_1263 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1263 * 0.07739938050508499f));
  float _1313 = cb0_014x * (((cb0_039y + (cb0_039x * _1285)) * _1285) + cb0_039z);
  float _1314 = cb0_014y * (((cb0_039y + (cb0_039x * _1286)) * _1286) + cb0_039z);
  float _1315 = cb0_014z * (((cb0_039y + (cb0_039x * _1287)) * _1287) + cb0_039z);
  float _1322 = ((cb0_013x - _1313) * cb0_013w) + _1313;
  float _1323 = ((cb0_013y - _1314) * cb0_013w) + _1314;
  float _1324 = ((cb0_013z - _1315) * cb0_013w) + _1315;
  float _1325 = cb0_014x * mad((WorkingColorSpace_192[0].z), _811, mad((WorkingColorSpace_192[0].y), _809, (_807 * (WorkingColorSpace_192[0].x))));
  float _1326 = cb0_014y * mad((WorkingColorSpace_192[1].z), _811, mad((WorkingColorSpace_192[1].y), _809, ((WorkingColorSpace_192[1].x) * _807)));
  float _1327 = cb0_014z * mad((WorkingColorSpace_192[2].z), _811, mad((WorkingColorSpace_192[2].y), _809, ((WorkingColorSpace_192[2].x) * _807)));
  float _1334 = ((cb0_013x - _1325) * cb0_013w) + _1325;
  float _1335 = ((cb0_013y - _1326) * cb0_013w) + _1326;
  float _1336 = ((cb0_013z - _1327) * cb0_013w) + _1327;
  float _1348 = exp2(log2(max(0.0f, _1322)) * cb0_040y);
  float _1349 = exp2(log2(max(0.0f, _1323)) * cb0_040y);
  float _1350 = exp2(log2(max(0.0f, _1324)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1373 = mad((WorkingColorSpace_128[0].z), _1350, mad((WorkingColorSpace_128[0].y), _1349, ((WorkingColorSpace_128[0].x) * _1348)));
        float _1376 = mad((WorkingColorSpace_128[1].z), _1350, mad((WorkingColorSpace_128[1].y), _1349, ((WorkingColorSpace_128[1].x) * _1348)));
        float _1379 = mad((WorkingColorSpace_128[2].z), _1350, mad((WorkingColorSpace_128[2].y), _1349, ((WorkingColorSpace_128[2].x) * _1348)));
        _1390 = mad(_65, _1379, mad(_64, _1376, (_1373 * _63)));
        _1391 = mad(_68, _1379, mad(_67, _1376, (_1373 * _66)));
        _1392 = mad(_71, _1379, mad(_70, _1376, (_1373 * _69)));
      } else {
        _1390 = _1348;
        _1391 = _1349;
        _1392 = _1350;
      }
      do {
        if (_1390 < 0.0031306699384003878f) {
          _1403 = (_1390 * 12.920000076293945f);
        } else {
          _1403 = (((pow(_1390, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1391 < 0.0031306699384003878f) {
            _1414 = (_1391 * 12.920000076293945f);
          } else {
            _1414 = (((pow(_1391, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1392 < 0.0031306699384003878f) {
            _3018 = _1403;
            _3019 = _1414;
            _3020 = (_1392 * 12.920000076293945f);
          } else {
            _3018 = _1403;
            _3019 = _1414;
            _3020 = (((pow(_1392, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1441 = mad((WorkingColorSpace_128[0].z), _1350, mad((WorkingColorSpace_128[0].y), _1349, ((WorkingColorSpace_128[0].x) * _1348)));
      float _1444 = mad((WorkingColorSpace_128[1].z), _1350, mad((WorkingColorSpace_128[1].y), _1349, ((WorkingColorSpace_128[1].x) * _1348)));
      float _1447 = mad((WorkingColorSpace_128[2].z), _1350, mad((WorkingColorSpace_128[2].y), _1349, ((WorkingColorSpace_128[2].x) * _1348)));
      float _1457 = max(6.103519990574569e-05f, mad(_65, _1447, mad(_64, _1444, (_1441 * _63))));
      float _1458 = max(6.103519990574569e-05f, mad(_68, _1447, mad(_67, _1444, (_1441 * _66))));
      float _1459 = max(6.103519990574569e-05f, mad(_71, _1447, mad(_70, _1444, (_1441 * _69))));
      _3018 = min((_1457 * 4.5f), ((exp2(log2(max(_1457, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3019 = min((_1458 * 4.5f), ((exp2(log2(max(_1458, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3020 = min((_1459 * 4.5f), ((exp2(log2(max(_1459, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
        _11[0] = cb0_010x;
        _11[1] = cb0_010y;
        _11[2] = cb0_010z;
        _11[3] = cb0_010w;
        _11[4] = cb0_012x;
        _11[5] = cb0_012x;
        _12[0] = cb0_011x;
        _12[1] = cb0_011y;
        _12[2] = cb0_011z;
        _12[3] = cb0_011w;
        _12[4] = cb0_012y;
        _12[5] = cb0_012y;
        float _1535 = cb0_012z * _1334;
        float _1536 = cb0_012z * _1335;
        float _1537 = cb0_012z * _1336;
        float _1540 = mad((WorkingColorSpace_256[0].z), _1537, mad((WorkingColorSpace_256[0].y), _1536, ((WorkingColorSpace_256[0].x) * _1535)));
        float _1543 = mad((WorkingColorSpace_256[1].z), _1537, mad((WorkingColorSpace_256[1].y), _1536, ((WorkingColorSpace_256[1].x) * _1535)));
        float _1546 = mad((WorkingColorSpace_256[2].z), _1537, mad((WorkingColorSpace_256[2].y), _1536, ((WorkingColorSpace_256[2].x) * _1535)));
        float _1549 = mad(-0.21492856740951538f, _1546, mad(-0.2365107536315918f, _1543, (_1540 * 1.4514392614364624f)));
        float _1552 = mad(-0.09967592358589172f, _1546, mad(1.17622971534729f, _1543, (_1540 * -0.07655377686023712f)));
        float _1555 = mad(0.9977163076400757f, _1546, mad(-0.006032449658960104f, _1543, (_1540 * 0.008316148072481155f)));
        float _1557 = max(_1549, max(_1552, _1555));
        do {
          if (!(_1557 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1540 < 0.0f) || (bool)(_1543 < 0.0f))) || (bool)(_1546 < 0.0f))) {
              float _1567 = abs(_1557);
              float _1568 = (_1557 - _1549) / _1567;
              float _1570 = (_1557 - _1552) / _1567;
              float _1572 = (_1557 - _1555) / _1567;
              do {
                if (!(_1568 < 0.8149999976158142f)) {
                  float _1575 = _1568 + -0.8149999976158142f;
                  _1587 = ((_1575 / exp2(log2(exp2(log2(_1575 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1587 = _1568;
                }
                do {
                  if (!(_1570 < 0.8029999732971191f)) {
                    float _1590 = _1570 + -0.8029999732971191f;
                    _1602 = ((_1590 / exp2(log2(exp2(log2(_1590 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1602 = _1570;
                  }
                  do {
                    if (!(_1572 < 0.8799999952316284f)) {
                      float _1605 = _1572 + -0.8799999952316284f;
                      _1617 = ((_1605 / exp2(log2(exp2(log2(_1605 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1617 = _1572;
                    }
                    _1625 = (_1557 - (_1567 * _1587));
                    _1626 = (_1557 - (_1567 * _1602));
                    _1627 = (_1557 - (_1567 * _1617));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1625 = _1549;
              _1626 = _1552;
              _1627 = _1555;
            }
          } else {
            _1625 = _1549;
            _1626 = _1552;
            _1627 = _1555;
          }
          float _1643 = ((mad(0.16386906802654266f, _1627, mad(0.14067870378494263f, _1626, (_1625 * 0.6954522132873535f))) - _1540) * cb0_012w) + _1540;
          float _1644 = ((mad(0.0955343171954155f, _1627, mad(0.8596711158752441f, _1626, (_1625 * 0.044794563204050064f))) - _1543) * cb0_012w) + _1543;
          float _1645 = ((mad(1.0015007257461548f, _1627, mad(0.004025210160762072f, _1626, (_1625 * -0.005525882821530104f))) - _1546) * cb0_012w) + _1546;
          float _1649 = max(max(_1643, _1644), _1645);
          float _1654 = (max(_1649, 1.000000013351432e-10f) - max(min(min(_1643, _1644), _1645), 1.000000013351432e-10f)) / max(_1649, 0.009999999776482582f);
          float _1667 = ((_1644 + _1643) + _1645) + (sqrt((((_1645 - _1644) * _1645) + ((_1644 - _1643) * _1644)) + ((_1643 - _1645) * _1643)) * 1.75f);
          float _1668 = _1667 * 0.3333333432674408f;
          float _1669 = _1654 + -0.4000000059604645f;
          float _1670 = _1669 * 5.0f;
          float _1674 = max((1.0f - abs(_1669 * 2.5f)), 0.0f);
          float _1685 = ((float((int)(((int)(uint)((bool)(_1670 > 0.0f))) - ((int)(uint)((bool)(_1670 < 0.0f))))) * (1.0f - (_1674 * _1674))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1668 <= 0.0533333346247673f)) {
              if (!(_1668 >= 0.1599999964237213f)) {
                _1694 = (((0.23999999463558197f / _1667) + -0.5f) * _1685);
              } else {
                _1694 = 0.0f;
              }
            } else {
              _1694 = _1685;
            }
            float _1695 = _1694 + 1.0f;
            float _1696 = _1695 * _1643;
            float _1697 = _1695 * _1644;
            float _1698 = _1695 * _1645;
            do {
              if (!((bool)(_1696 == _1697) && (bool)(_1697 == _1698))) {
                float _1705 = ((_1696 * 2.0f) - _1697) - _1698;
                float _1708 = ((_1644 - _1645) * 1.7320507764816284f) * _1695;
                float _1710 = atan(_1708 / _1705);
                bool _1713 = (_1705 < 0.0f);
                bool _1714 = (_1705 == 0.0f);
                bool _1715 = (_1708 >= 0.0f);
                bool _1716 = (_1708 < 0.0f);
                _1727 = select((_1715 && _1714), 90.0f, select((_1716 && _1714), -90.0f, (select((_1716 && _1713), (_1710 + -3.1415927410125732f), select((_1715 && _1713), (_1710 + 3.1415927410125732f), _1710)) * 57.2957763671875f)));
              } else {
                _1727 = 0.0f;
              }
              float _1732 = min(max(select((_1727 < 0.0f), (_1727 + 360.0f), _1727), 0.0f), 360.0f);
              do {
                if (_1732 < -180.0f) {
                  _1741 = (_1732 + 360.0f);
                } else {
                  if (_1732 > 180.0f) {
                    _1741 = (_1732 + -360.0f);
                  } else {
                    _1741 = _1732;
                  }
                }
                do {
                  if ((bool)(_1741 > -67.5f) && (bool)(_1741 < 67.5f)) {
                    float _1747 = (_1741 + 67.5f) * 0.029629629105329514f;
                    int _1748 = int(_1747);
                    float _1750 = _1747 - float((int)(_1748));
                    float _1751 = _1750 * _1750;
                    float _1752 = _1751 * _1750;
                    if (_1748 == 3) {
                      _1780 = (((0.1666666716337204f - (_1750 * 0.5f)) + (_1751 * 0.5f)) - (_1752 * 0.1666666716337204f));
                    } else {
                      if (_1748 == 2) {
                        _1780 = ((0.6666666865348816f - _1751) + (_1752 * 0.5f));
                      } else {
                        if (_1748 == 1) {
                          _1780 = (((_1752 * -0.5f) + 0.1666666716337204f) + ((_1751 + _1750) * 0.5f));
                        } else {
                          _1780 = select((_1748 == 0), (_1752 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1780 = 0.0f;
                  }
                  float _1789 = min(max(((((_1654 * 0.27000001072883606f) * (0.029999999329447746f - _1696)) * _1780) + _1696), 0.0f), 65535.0f);
                  float _1790 = min(max(_1697, 0.0f), 65535.0f);
                  float _1791 = min(max(_1698, 0.0f), 65535.0f);
                  float _1804 = min(max(mad(-0.21492856740951538f, _1791, mad(-0.2365107536315918f, _1790, (_1789 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1805 = min(max(mad(-0.09967592358589172f, _1791, mad(1.17622971534729f, _1790, (_1789 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1806 = min(max(mad(0.9977163076400757f, _1791, mad(-0.006032449658960104f, _1790, (_1789 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1807 = dot(float3(_1804, _1805, _1806), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _19[0] = cb0_010x;
                  _19[1] = cb0_010y;
                  _19[2] = cb0_010z;
                  _19[3] = cb0_010w;
                  _19[4] = cb0_012x;
                  _19[5] = cb0_012x;
                  _20[0] = cb0_011x;
                  _20[1] = cb0_011y;
                  _20[2] = cb0_011z;
                  _20[3] = cb0_011w;
                  _20[4] = cb0_012y;
                  _20[5] = cb0_012y;
                  float _1830 = log2(max((lerp(_1807, _1804, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1831 = _1830 * 0.3010300099849701f;
                  float _1832 = log2(cb0_008x);
                  float _1833 = _1832 * 0.3010300099849701f;
                  do {
                    if (!(!(_1831 <= _1833))) {
                      _1902 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1840 = log2(cb0_009x);
                      float _1841 = _1840 * 0.3010300099849701f;
                      if ((bool)(_1831 > _1833) && (bool)(_1831 < _1841)) {
                        float _1849 = ((_1830 - _1832) * 0.9030900001525879f) / ((_1840 - _1832) * 0.3010300099849701f);
                        int _1850 = int(_1849);
                        float _1852 = _1849 - float((int)(_1850));
                        float _1854 = _19[_1850];
                        float _1857 = _19[(_1850 + 1)];
                        float _1862 = _1854 * 0.5f;
                        _1902 = dot(float3((_1852 * _1852), _1852, 1.0f), float3(mad((_19[(_1850 + 2)]), 0.5f, mad(_1857, -1.0f, _1862)), (_1857 - _1854), mad(_1857, 0.5f, _1862)));
                      } else {
                        do {
                          if (!(!(_1831 >= _1841))) {
                            float _1871 = log2(cb0_008z);
                            if (_1831 < (_1871 * 0.3010300099849701f)) {
                              float _1879 = ((_1830 - _1840) * 0.9030900001525879f) / ((_1871 - _1840) * 0.3010300099849701f);
                              int _1880 = int(_1879);
                              float _1882 = _1879 - float((int)(_1880));
                              float _1884 = _20[_1880];
                              float _1887 = _20[(_1880 + 1)];
                              float _1892 = _1884 * 0.5f;
                              _1902 = dot(float3((_1882 * _1882), _1882, 1.0f), float3(mad((_20[(_1880 + 2)]), 0.5f, mad(_1887, -1.0f, _1892)), (_1887 - _1884), mad(_1887, 0.5f, _1892)));
                              break;
                            }
                          }
                          _1902 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _21[0] = cb0_010x;
                    _21[1] = cb0_010y;
                    _21[2] = cb0_010z;
                    _21[3] = cb0_010w;
                    _21[4] = cb0_012x;
                    _21[5] = cb0_012x;
                    _22[0] = cb0_011x;
                    _22[1] = cb0_011y;
                    _22[2] = cb0_011z;
                    _22[3] = cb0_011w;
                    _22[4] = cb0_012y;
                    _22[5] = cb0_012y;
                    float _1918 = log2(max((lerp(_1807, _1805, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1919 = _1918 * 0.3010300099849701f;
                    do {
                      if (!(!(_1919 <= _1833))) {
                        _1988 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1926 = log2(cb0_009x);
                        float _1927 = _1926 * 0.3010300099849701f;
                        if ((bool)(_1919 > _1833) && (bool)(_1919 < _1927)) {
                          float _1935 = ((_1918 - _1832) * 0.9030900001525879f) / ((_1926 - _1832) * 0.3010300099849701f);
                          int _1936 = int(_1935);
                          float _1938 = _1935 - float((int)(_1936));
                          float _1940 = _21[_1936];
                          float _1943 = _21[(_1936 + 1)];
                          float _1948 = _1940 * 0.5f;
                          _1988 = dot(float3((_1938 * _1938), _1938, 1.0f), float3(mad((_21[(_1936 + 2)]), 0.5f, mad(_1943, -1.0f, _1948)), (_1943 - _1940), mad(_1943, 0.5f, _1948)));
                        } else {
                          do {
                            if (!(!(_1919 >= _1927))) {
                              float _1957 = log2(cb0_008z);
                              if (_1919 < (_1957 * 0.3010300099849701f)) {
                                float _1965 = ((_1918 - _1926) * 0.9030900001525879f) / ((_1957 - _1926) * 0.3010300099849701f);
                                int _1966 = int(_1965);
                                float _1968 = _1965 - float((int)(_1966));
                                float _1970 = _22[_1966];
                                float _1973 = _22[(_1966 + 1)];
                                float _1978 = _1970 * 0.5f;
                                _1988 = dot(float3((_1968 * _1968), _1968, 1.0f), float3(mad((_22[(_1966 + 2)]), 0.5f, mad(_1973, -1.0f, _1978)), (_1973 - _1970), mad(_1973, 0.5f, _1978)));
                                break;
                              }
                            }
                            _1988 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1992 = log2(max((lerp(_1807, _1806, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1993 = _1992 * 0.3010300099849701f;
                      do {
                        if (!(!(_1993 <= _1833))) {
                          _2062 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2000 = log2(cb0_009x);
                          float _2001 = _2000 * 0.3010300099849701f;
                          if ((bool)(_1993 > _1833) && (bool)(_1993 < _2001)) {
                            float _2009 = ((_1992 - _1832) * 0.9030900001525879f) / ((_2000 - _1832) * 0.3010300099849701f);
                            int _2010 = int(_2009);
                            float _2012 = _2009 - float((int)(_2010));
                            float _2014 = _11[_2010];
                            float _2017 = _11[(_2010 + 1)];
                            float _2022 = _2014 * 0.5f;
                            _2062 = dot(float3((_2012 * _2012), _2012, 1.0f), float3(mad((_11[(_2010 + 2)]), 0.5f, mad(_2017, -1.0f, _2022)), (_2017 - _2014), mad(_2017, 0.5f, _2022)));
                          } else {
                            do {
                              if (!(!(_1993 >= _2001))) {
                                float _2031 = log2(cb0_008z);
                                if (_1993 < (_2031 * 0.3010300099849701f)) {
                                  float _2039 = ((_1992 - _2000) * 0.9030900001525879f) / ((_2031 - _2000) * 0.3010300099849701f);
                                  int _2040 = int(_2039);
                                  float _2042 = _2039 - float((int)(_2040));
                                  float _2044 = _12[_2040];
                                  float _2047 = _12[(_2040 + 1)];
                                  float _2052 = _2044 * 0.5f;
                                  _2062 = dot(float3((_2042 * _2042), _2042, 1.0f), float3(mad((_12[(_2040 + 2)]), 0.5f, mad(_2047, -1.0f, _2052)), (_2047 - _2044), mad(_2047, 0.5f, _2052)));
                                  break;
                                }
                              }
                              _2062 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2066 = cb0_008w - cb0_008y;
                        float _2067 = (exp2(_1902 * 3.321928024291992f) - cb0_008y) / _2066;
                        float _2069 = (exp2(_1988 * 3.321928024291992f) - cb0_008y) / _2066;
                        float _2071 = (exp2(_2062 * 3.321928024291992f) - cb0_008y) / _2066;
                        float _2074 = mad(0.15618768334388733f, _2071, mad(0.13400420546531677f, _2069, (_2067 * 0.6624541878700256f)));
                        float _2077 = mad(0.053689517080783844f, _2071, mad(0.6740817427635193f, _2069, (_2067 * 0.2722287178039551f)));
                        float _2080 = mad(1.0103391408920288f, _2071, mad(0.00406073359772563f, _2069, (_2067 * -0.005574649665504694f)));
                        float _2093 = min(max(mad(-0.23642469942569733f, _2080, mad(-0.32480329275131226f, _2077, (_2074 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2094 = min(max(mad(0.016756348311901093f, _2080, mad(1.6153316497802734f, _2077, (_2074 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2095 = min(max(mad(0.9883948564529419f, _2080, mad(-0.008284442126750946f, _2077, (_2074 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2098 = mad(0.15618768334388733f, _2095, mad(0.13400420546531677f, _2094, (_2093 * 0.6624541878700256f)));
                        float _2101 = mad(0.053689517080783844f, _2095, mad(0.6740817427635193f, _2094, (_2093 * 0.2722287178039551f)));
                        float _2104 = mad(1.0103391408920288f, _2095, mad(0.00406073359772563f, _2094, (_2093 * -0.005574649665504694f)));
                        float _2126 = min(max((min(max(mad(-0.23642469942569733f, _2104, mad(-0.32480329275131226f, _2101, (_2098 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2127 = min(max((min(max(mad(0.016756348311901093f, _2104, mad(1.6153316497802734f, _2101, (_2098 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2128 = min(max((min(max(mad(0.9883948564529419f, _2104, mad(-0.008284442126750946f, _2101, (_2098 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _2141 = mad(_65, _2128, mad(_64, _2127, (_2126 * _63)));
                            _2142 = mad(_68, _2128, mad(_67, _2127, (_2126 * _66)));
                            _2143 = mad(_71, _2128, mad(_70, _2127, (_2126 * _69)));
                          } else {
                            _2141 = _2126;
                            _2142 = _2127;
                            _2143 = _2128;
                          }
                          float _2153 = exp2(log2(_2141 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2154 = exp2(log2(_2142 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2155 = exp2(log2(_2143 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3018 = exp2(log2((1.0f / ((_2153 * 18.6875f) + 1.0f)) * ((_2153 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3019 = exp2(log2((1.0f / ((_2154 * 18.6875f) + 1.0f)) * ((_2154 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3020 = exp2(log2((1.0f / ((_2155 * 18.6875f) + 1.0f)) * ((_2155 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
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
          float _2221 = cb0_012z * _1334;
          float _2222 = cb0_012z * _1335;
          float _2223 = cb0_012z * _1336;
          float _2226 = mad((WorkingColorSpace_256[0].z), _2223, mad((WorkingColorSpace_256[0].y), _2222, ((WorkingColorSpace_256[0].x) * _2221)));
          float _2229 = mad((WorkingColorSpace_256[1].z), _2223, mad((WorkingColorSpace_256[1].y), _2222, ((WorkingColorSpace_256[1].x) * _2221)));
          float _2232 = mad((WorkingColorSpace_256[2].z), _2223, mad((WorkingColorSpace_256[2].y), _2222, ((WorkingColorSpace_256[2].x) * _2221)));
          float _2235 = mad(-0.21492856740951538f, _2232, mad(-0.2365107536315918f, _2229, (_2226 * 1.4514392614364624f)));
          float _2238 = mad(-0.09967592358589172f, _2232, mad(1.17622971534729f, _2229, (_2226 * -0.07655377686023712f)));
          float _2241 = mad(0.9977163076400757f, _2232, mad(-0.006032449658960104f, _2229, (_2226 * 0.008316148072481155f)));
          float _2243 = max(_2235, max(_2238, _2241));
          do {
            if (!(_2243 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2226 < 0.0f) || (bool)(_2229 < 0.0f))) || (bool)(_2232 < 0.0f))) {
                float _2253 = abs(_2243);
                float _2254 = (_2243 - _2235) / _2253;
                float _2256 = (_2243 - _2238) / _2253;
                float _2258 = (_2243 - _2241) / _2253;
                do {
                  if (!(_2254 < 0.8149999976158142f)) {
                    float _2261 = _2254 + -0.8149999976158142f;
                    _2273 = ((_2261 / exp2(log2(exp2(log2(_2261 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2273 = _2254;
                  }
                  do {
                    if (!(_2256 < 0.8029999732971191f)) {
                      float _2276 = _2256 + -0.8029999732971191f;
                      _2288 = ((_2276 / exp2(log2(exp2(log2(_2276 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2288 = _2256;
                    }
                    do {
                      if (!(_2258 < 0.8799999952316284f)) {
                        float _2291 = _2258 + -0.8799999952316284f;
                        _2303 = ((_2291 / exp2(log2(exp2(log2(_2291 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2303 = _2258;
                      }
                      _2311 = (_2243 - (_2253 * _2273));
                      _2312 = (_2243 - (_2253 * _2288));
                      _2313 = (_2243 - (_2253 * _2303));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2311 = _2235;
                _2312 = _2238;
                _2313 = _2241;
              }
            } else {
              _2311 = _2235;
              _2312 = _2238;
              _2313 = _2241;
            }
            float _2329 = ((mad(0.16386906802654266f, _2313, mad(0.14067870378494263f, _2312, (_2311 * 0.6954522132873535f))) - _2226) * cb0_012w) + _2226;
            float _2330 = ((mad(0.0955343171954155f, _2313, mad(0.8596711158752441f, _2312, (_2311 * 0.044794563204050064f))) - _2229) * cb0_012w) + _2229;
            float _2331 = ((mad(1.0015007257461548f, _2313, mad(0.004025210160762072f, _2312, (_2311 * -0.005525882821530104f))) - _2232) * cb0_012w) + _2232;
            float _2335 = max(max(_2329, _2330), _2331);
            float _2340 = (max(_2335, 1.000000013351432e-10f) - max(min(min(_2329, _2330), _2331), 1.000000013351432e-10f)) / max(_2335, 0.009999999776482582f);
            float _2353 = ((_2330 + _2329) + _2331) + (sqrt((((_2331 - _2330) * _2331) + ((_2330 - _2329) * _2330)) + ((_2329 - _2331) * _2329)) * 1.75f);
            float _2354 = _2353 * 0.3333333432674408f;
            float _2355 = _2340 + -0.4000000059604645f;
            float _2356 = _2355 * 5.0f;
            float _2360 = max((1.0f - abs(_2355 * 2.5f)), 0.0f);
            float _2371 = ((float((int)(((int)(uint)((bool)(_2356 > 0.0f))) - ((int)(uint)((bool)(_2356 < 0.0f))))) * (1.0f - (_2360 * _2360))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2354 <= 0.0533333346247673f)) {
                if (!(_2354 >= 0.1599999964237213f)) {
                  _2380 = (((0.23999999463558197f / _2353) + -0.5f) * _2371);
                } else {
                  _2380 = 0.0f;
                }
              } else {
                _2380 = _2371;
              }
              float _2381 = _2380 + 1.0f;
              float _2382 = _2381 * _2329;
              float _2383 = _2381 * _2330;
              float _2384 = _2381 * _2331;
              do {
                if (!((bool)(_2382 == _2383) && (bool)(_2383 == _2384))) {
                  float _2391 = ((_2382 * 2.0f) - _2383) - _2384;
                  float _2394 = ((_2330 - _2331) * 1.7320507764816284f) * _2381;
                  float _2396 = atan(_2394 / _2391);
                  bool _2399 = (_2391 < 0.0f);
                  bool _2400 = (_2391 == 0.0f);
                  bool _2401 = (_2394 >= 0.0f);
                  bool _2402 = (_2394 < 0.0f);
                  _2413 = select((_2401 && _2400), 90.0f, select((_2402 && _2400), -90.0f, (select((_2402 && _2399), (_2396 + -3.1415927410125732f), select((_2401 && _2399), (_2396 + 3.1415927410125732f), _2396)) * 57.2957763671875f)));
                } else {
                  _2413 = 0.0f;
                }
                float _2418 = min(max(select((_2413 < 0.0f), (_2413 + 360.0f), _2413), 0.0f), 360.0f);
                do {
                  if (_2418 < -180.0f) {
                    _2427 = (_2418 + 360.0f);
                  } else {
                    if (_2418 > 180.0f) {
                      _2427 = (_2418 + -360.0f);
                    } else {
                      _2427 = _2418;
                    }
                  }
                  do {
                    if ((bool)(_2427 > -67.5f) && (bool)(_2427 < 67.5f)) {
                      float _2433 = (_2427 + 67.5f) * 0.029629629105329514f;
                      int _2434 = int(_2433);
                      float _2436 = _2433 - float((int)(_2434));
                      float _2437 = _2436 * _2436;
                      float _2438 = _2437 * _2436;
                      if (_2434 == 3) {
                        _2466 = (((0.1666666716337204f - (_2436 * 0.5f)) + (_2437 * 0.5f)) - (_2438 * 0.1666666716337204f));
                      } else {
                        if (_2434 == 2) {
                          _2466 = ((0.6666666865348816f - _2437) + (_2438 * 0.5f));
                        } else {
                          if (_2434 == 1) {
                            _2466 = (((_2438 * -0.5f) + 0.1666666716337204f) + ((_2437 + _2436) * 0.5f));
                          } else {
                            _2466 = select((_2434 == 0), (_2438 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2466 = 0.0f;
                    }
                    float _2475 = min(max(((((_2340 * 0.27000001072883606f) * (0.029999999329447746f - _2382)) * _2466) + _2382), 0.0f), 65535.0f);
                    float _2476 = min(max(_2383, 0.0f), 65535.0f);
                    float _2477 = min(max(_2384, 0.0f), 65535.0f);
                    float _2490 = min(max(mad(-0.21492856740951538f, _2477, mad(-0.2365107536315918f, _2476, (_2475 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2491 = min(max(mad(-0.09967592358589172f, _2477, mad(1.17622971534729f, _2476, (_2475 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2492 = min(max(mad(0.9977163076400757f, _2477, mad(-0.006032449658960104f, _2476, (_2475 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2493 = dot(float3(_2490, _2491, _2492), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    _17[0] = cb0_010x;
                    _17[1] = cb0_010y;
                    _17[2] = cb0_010z;
                    _17[3] = cb0_010w;
                    _17[4] = cb0_012x;
                    _17[5] = cb0_012x;
                    _18[0] = cb0_011x;
                    _18[1] = cb0_011y;
                    _18[2] = cb0_011z;
                    _18[3] = cb0_011w;
                    _18[4] = cb0_012y;
                    _18[5] = cb0_012y;
                    float _2516 = log2(max((lerp(_2493, _2490, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2517 = _2516 * 0.3010300099849701f;
                    float _2518 = log2(cb0_008x);
                    float _2519 = _2518 * 0.3010300099849701f;
                    do {
                      if (!(!(_2517 <= _2519))) {
                        _2588 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2526 = log2(cb0_009x);
                        float _2527 = _2526 * 0.3010300099849701f;
                        if ((bool)(_2517 > _2519) && (bool)(_2517 < _2527)) {
                          float _2535 = ((_2516 - _2518) * 0.9030900001525879f) / ((_2526 - _2518) * 0.3010300099849701f);
                          int _2536 = int(_2535);
                          float _2538 = _2535 - float((int)(_2536));
                          float _2540 = _17[_2536];
                          float _2543 = _17[(_2536 + 1)];
                          float _2548 = _2540 * 0.5f;
                          _2588 = dot(float3((_2538 * _2538), _2538, 1.0f), float3(mad((_17[(_2536 + 2)]), 0.5f, mad(_2543, -1.0f, _2548)), (_2543 - _2540), mad(_2543, 0.5f, _2548)));
                        } else {
                          do {
                            if (!(!(_2517 >= _2527))) {
                              float _2557 = log2(cb0_008z);
                              if (_2517 < (_2557 * 0.3010300099849701f)) {
                                float _2565 = ((_2516 - _2526) * 0.9030900001525879f) / ((_2557 - _2526) * 0.3010300099849701f);
                                int _2566 = int(_2565);
                                float _2568 = _2565 - float((int)(_2566));
                                float _2570 = _18[_2566];
                                float _2573 = _18[(_2566 + 1)];
                                float _2578 = _2570 * 0.5f;
                                _2588 = dot(float3((_2568 * _2568), _2568, 1.0f), float3(mad((_18[(_2566 + 2)]), 0.5f, mad(_2573, -1.0f, _2578)), (_2573 - _2570), mad(_2573, 0.5f, _2578)));
                                break;
                              }
                            }
                            _2588 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      _13[0] = cb0_010x;
                      _13[1] = cb0_010y;
                      _13[2] = cb0_010z;
                      _13[3] = cb0_010w;
                      _13[4] = cb0_012x;
                      _13[5] = cb0_012x;
                      _14[0] = cb0_011x;
                      _14[1] = cb0_011y;
                      _14[2] = cb0_011z;
                      _14[3] = cb0_011w;
                      _14[4] = cb0_012y;
                      _14[5] = cb0_012y;
                      float _2604 = log2(max((lerp(_2493, _2491, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2605 = _2604 * 0.3010300099849701f;
                      do {
                        if (!(!(_2605 <= _2519))) {
                          _2674 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2612 = log2(cb0_009x);
                          float _2613 = _2612 * 0.3010300099849701f;
                          if ((bool)(_2605 > _2519) && (bool)(_2605 < _2613)) {
                            float _2621 = ((_2604 - _2518) * 0.9030900001525879f) / ((_2612 - _2518) * 0.3010300099849701f);
                            int _2622 = int(_2621);
                            float _2624 = _2621 - float((int)(_2622));
                            float _2626 = _13[_2622];
                            float _2629 = _13[(_2622 + 1)];
                            float _2634 = _2626 * 0.5f;
                            _2674 = dot(float3((_2624 * _2624), _2624, 1.0f), float3(mad((_13[(_2622 + 2)]), 0.5f, mad(_2629, -1.0f, _2634)), (_2629 - _2626), mad(_2629, 0.5f, _2634)));
                          } else {
                            do {
                              if (!(!(_2605 >= _2613))) {
                                float _2643 = log2(cb0_008z);
                                if (_2605 < (_2643 * 0.3010300099849701f)) {
                                  float _2651 = ((_2604 - _2612) * 0.9030900001525879f) / ((_2643 - _2612) * 0.3010300099849701f);
                                  int _2652 = int(_2651);
                                  float _2654 = _2651 - float((int)(_2652));
                                  float _2656 = _14[_2652];
                                  float _2659 = _14[(_2652 + 1)];
                                  float _2664 = _2656 * 0.5f;
                                  _2674 = dot(float3((_2654 * _2654), _2654, 1.0f), float3(mad((_14[(_2652 + 2)]), 0.5f, mad(_2659, -1.0f, _2664)), (_2659 - _2656), mad(_2659, 0.5f, _2664)));
                                  break;
                                }
                              }
                              _2674 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        _15[0] = cb0_010x;
                        _15[1] = cb0_010y;
                        _15[2] = cb0_010z;
                        _15[3] = cb0_010w;
                        _15[4] = cb0_012x;
                        _15[5] = cb0_012x;
                        _16[0] = cb0_011x;
                        _16[1] = cb0_011y;
                        _16[2] = cb0_011z;
                        _16[3] = cb0_011w;
                        _16[4] = cb0_012y;
                        _16[5] = cb0_012y;
                        float _2690 = log2(max((lerp(_2493, _2492, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2691 = _2690 * 0.3010300099849701f;
                        do {
                          if (!(!(_2691 <= _2519))) {
                            _2760 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2698 = log2(cb0_009x);
                            float _2699 = _2698 * 0.3010300099849701f;
                            if ((bool)(_2691 > _2519) && (bool)(_2691 < _2699)) {
                              float _2707 = ((_2690 - _2518) * 0.9030900001525879f) / ((_2698 - _2518) * 0.3010300099849701f);
                              int _2708 = int(_2707);
                              float _2710 = _2707 - float((int)(_2708));
                              float _2712 = _15[_2708];
                              float _2715 = _15[(_2708 + 1)];
                              float _2720 = _2712 * 0.5f;
                              _2760 = dot(float3((_2710 * _2710), _2710, 1.0f), float3(mad((_15[(_2708 + 2)]), 0.5f, mad(_2715, -1.0f, _2720)), (_2715 - _2712), mad(_2715, 0.5f, _2720)));
                            } else {
                              do {
                                if (!(!(_2691 >= _2699))) {
                                  float _2729 = log2(cb0_008z);
                                  if (_2691 < (_2729 * 0.3010300099849701f)) {
                                    float _2737 = ((_2690 - _2698) * 0.9030900001525879f) / ((_2729 - _2698) * 0.3010300099849701f);
                                    int _2738 = int(_2737);
                                    float _2740 = _2737 - float((int)(_2738));
                                    float _2742 = _16[_2738];
                                    float _2745 = _16[(_2738 + 1)];
                                    float _2750 = _2742 * 0.5f;
                                    _2760 = dot(float3((_2740 * _2740), _2740, 1.0f), float3(mad((_16[(_2738 + 2)]), 0.5f, mad(_2745, -1.0f, _2750)), (_2745 - _2742), mad(_2745, 0.5f, _2750)));
                                    break;
                                  }
                                }
                                _2760 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2764 = cb0_008w - cb0_008y;
                          float _2765 = (exp2(_2588 * 3.321928024291992f) - cb0_008y) / _2764;
                          float _2767 = (exp2(_2674 * 3.321928024291992f) - cb0_008y) / _2764;
                          float _2769 = (exp2(_2760 * 3.321928024291992f) - cb0_008y) / _2764;
                          float _2772 = mad(0.15618768334388733f, _2769, mad(0.13400420546531677f, _2767, (_2765 * 0.6624541878700256f)));
                          float _2775 = mad(0.053689517080783844f, _2769, mad(0.6740817427635193f, _2767, (_2765 * 0.2722287178039551f)));
                          float _2778 = mad(1.0103391408920288f, _2769, mad(0.00406073359772563f, _2767, (_2765 * -0.005574649665504694f)));
                          float _2791 = min(max(mad(-0.23642469942569733f, _2778, mad(-0.32480329275131226f, _2775, (_2772 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2792 = min(max(mad(0.016756348311901093f, _2778, mad(1.6153316497802734f, _2775, (_2772 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2793 = min(max(mad(0.9883948564529419f, _2778, mad(-0.008284442126750946f, _2775, (_2772 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2796 = mad(0.15618768334388733f, _2793, mad(0.13400420546531677f, _2792, (_2791 * 0.6624541878700256f)));
                          float _2799 = mad(0.053689517080783844f, _2793, mad(0.6740817427635193f, _2792, (_2791 * 0.2722287178039551f)));
                          float _2802 = mad(1.0103391408920288f, _2793, mad(0.00406073359772563f, _2792, (_2791 * -0.005574649665504694f)));
                          float _2824 = min(max((min(max(mad(-0.23642469942569733f, _2802, mad(-0.32480329275131226f, _2799, (_2796 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2825 = min(max((min(max(mad(0.016756348311901093f, _2802, mad(1.6153316497802734f, _2799, (_2796 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2826 = min(max((min(max(mad(0.9883948564529419f, _2802, mad(-0.008284442126750946f, _2799, (_2796 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2839 = mad(_65, _2826, mad(_64, _2825, (_2824 * _63)));
                              _2840 = mad(_68, _2826, mad(_67, _2825, (_2824 * _66)));
                              _2841 = mad(_71, _2826, mad(_70, _2825, (_2824 * _69)));
                            } else {
                              _2839 = _2824;
                              _2840 = _2825;
                              _2841 = _2826;
                            }
                            float _2851 = exp2(log2(_2839 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2852 = exp2(log2(_2840 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2853 = exp2(log2(_2841 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _3018 = exp2(log2((1.0f / ((_2851 * 18.6875f) + 1.0f)) * ((_2851 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3019 = exp2(log2((1.0f / ((_2852 * 18.6875f) + 1.0f)) * ((_2852 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3020 = exp2(log2((1.0f / ((_2853 * 18.6875f) + 1.0f)) * ((_2853 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          } while (false);
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
            float _2898 = mad((WorkingColorSpace_128[0].z), _1336, mad((WorkingColorSpace_128[0].y), _1335, ((WorkingColorSpace_128[0].x) * _1334)));
            float _2901 = mad((WorkingColorSpace_128[1].z), _1336, mad((WorkingColorSpace_128[1].y), _1335, ((WorkingColorSpace_128[1].x) * _1334)));
            float _2904 = mad((WorkingColorSpace_128[2].z), _1336, mad((WorkingColorSpace_128[2].y), _1335, ((WorkingColorSpace_128[2].x) * _1334)));
            float _2923 = exp2(log2(mad(_65, _2904, mad(_64, _2901, (_2898 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2924 = exp2(log2(mad(_68, _2904, mad(_67, _2901, (_2898 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2925 = exp2(log2(mad(_71, _2904, mad(_70, _2901, (_2898 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3018 = exp2(log2((1.0f / ((_2923 * 18.6875f) + 1.0f)) * ((_2923 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3019 = exp2(log2((1.0f / ((_2924 * 18.6875f) + 1.0f)) * ((_2924 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3020 = exp2(log2((1.0f / ((_2925 * 18.6875f) + 1.0f)) * ((_2925 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2972 = mad((WorkingColorSpace_128[0].z), _1324, mad((WorkingColorSpace_128[0].y), _1323, ((WorkingColorSpace_128[0].x) * _1322)));
                float _2975 = mad((WorkingColorSpace_128[1].z), _1324, mad((WorkingColorSpace_128[1].y), _1323, ((WorkingColorSpace_128[1].x) * _1322)));
                float _2978 = mad((WorkingColorSpace_128[2].z), _1324, mad((WorkingColorSpace_128[2].y), _1323, ((WorkingColorSpace_128[2].x) * _1322)));
                _3018 = mad(_65, _2978, mad(_64, _2975, (_2972 * _63)));
                _3019 = mad(_68, _2978, mad(_67, _2975, (_2972 * _66)));
                _3020 = mad(_71, _2978, mad(_70, _2975, (_2972 * _69)));
              } else {
                float _2991 = mad((WorkingColorSpace_128[0].z), _1350, mad((WorkingColorSpace_128[0].y), _1349, ((WorkingColorSpace_128[0].x) * _1348)));
                float _2994 = mad((WorkingColorSpace_128[1].z), _1350, mad((WorkingColorSpace_128[1].y), _1349, ((WorkingColorSpace_128[1].x) * _1348)));
                float _2997 = mad((WorkingColorSpace_128[2].z), _1350, mad((WorkingColorSpace_128[2].y), _1349, ((WorkingColorSpace_128[2].x) * _1348)));
                _3018 = exp2(log2(mad(_65, _2997, mad(_64, _2994, (_2991 * _63)))) * cb0_040z);
                _3019 = exp2(log2(mad(_68, _2997, mad(_67, _2994, (_2991 * _66)))) * cb0_040z);
                _3020 = exp2(log2(mad(_71, _2997, mad(_70, _2994, (_2991 * _69)))) * cb0_040z);
              }
            } else {
              _3018 = _1334;
              _3019 = _1335;
              _3020 = _1336;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_3018 * 0.9523810148239136f), (_3019 * 0.9523810148239136f), (_3020 * 0.9523810148239136f), 0.0f);
}
