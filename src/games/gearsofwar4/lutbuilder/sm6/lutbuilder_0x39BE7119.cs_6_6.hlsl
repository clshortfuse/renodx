// Found in Blood of Dawnwalker

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
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

SamplerState s1 : register(s1);

SamplerState s2 : register(s2);

SamplerState s3 : register(s3);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  float _23[6];
  float _24[6];
  float _25[6];
  float _26[6];
  float _27[6];
  float _39 = 0.5f / cb0_035x;
  float _44 = cb0_035x + -1.0f;
  float _45 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _39)) / _44;
  float _46 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _39)) / _44;
  float _48 = float((uint)SV_DispatchThreadID.z) / _44;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _73;
  float _74;
  float _75;
  float _76;
  float _134;
  float _135;
  float _136;
  float _184;
  float _912;
  float _945;
  float _959;
  float _1023;
  float _1202;
  float _1213;
  float _1224;
  float _1474;
  float _1475;
  float _1476;
  float _1487;
  float _1498;
  float _1671;
  float _1686;
  float _1701;
  float _1709;
  float _1710;
  float _1711;
  float _1778;
  float _1811;
  float _1825;
  float _1864;
  float _1986;
  float _2066;
  float _2140;
  float _2219;
  float _2220;
  float _2221;
  float _2351;
  float _2366;
  float _2381;
  float _2389;
  float _2390;
  float _2391;
  float _2458;
  float _2491;
  float _2505;
  float _2544;
  float _2666;
  float _2752;
  float _2838;
  float _2917;
  float _2918;
  float _2919;
  float _3096;
  float _3097;
  float _3098;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _57 = (cb0_041x == 4);
        _68 = select(_57, 1.0f, 1.705051064491272f);
        _69 = select(_57, 0.0f, -0.6217921376228333f);
        _70 = select(_57, 0.0f, -0.0832589864730835f);
        _71 = select(_57, 0.0f, -0.13025647401809692f);
        _72 = select(_57, 1.0f, 1.140804648399353f);
        _73 = select(_57, 0.0f, -0.010548308491706848f);
        _74 = select(_57, 0.0f, -0.024003351107239723f);
        _75 = select(_57, 0.0f, -0.1289689838886261f);
        _76 = select(_57, 1.0f, 1.1529725790023804f);
      } else {
        _68 = 0.6954522132873535f;
        _69 = 0.14067870378494263f;
        _70 = 0.16386906802654266f;
        _71 = 0.044794563204050064f;
        _72 = 0.8596711158752441f;
        _73 = 0.0955343171954155f;
        _74 = -0.005525882821530104f;
        _75 = 0.004025210160762072f;
        _76 = 1.0015007257461548f;
      }
    } else {
      _68 = 1.0258246660232544f;
      _69 = -0.020053181797266006f;
      _70 = -0.005771636962890625f;
      _71 = -0.002234415616840124f;
      _72 = 1.0045864582061768f;
      _73 = -0.002352118492126465f;
      _74 = -0.005013350863009691f;
      _75 = -0.025290070101618767f;
      _76 = 1.0303035974502563f;
    }
  } else {
    _68 = 1.3792141675949097f;
    _69 = -0.30886411666870117f;
    _70 = -0.0703500509262085f;
    _71 = -0.06933490186929703f;
    _72 = 1.08229660987854f;
    _73 = -0.012961871922016144f;
    _74 = -0.0021590073592960835f;
    _75 = -0.0454593189060688f;
    _76 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _87 = (pow(_45, 0.012683313339948654f));
    float _88 = (pow(_46, 0.012683313339948654f));
    float _89 = (pow(_48, 0.012683313339948654f));
    _134 = (exp2(log2(max(0.0f, (_87 + -0.8359375f)) / (18.8515625f - (_87 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _135 = (exp2(log2(max(0.0f, (_88 + -0.8359375f)) / (18.8515625f - (_88 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _136 = (exp2(log2(max(0.0f, (_89 + -0.8359375f)) / (18.8515625f - (_89 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _134 = ((exp2((_45 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _135 = ((exp2((_46 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _136 = ((exp2((_48 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _163 = (cb0_038w != 0);
  float _167 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _184 = (((((2967800.0f - (_167 * 4607000064.0f)) * _167) + 99.11000061035156f) * _167) + 0.24406300485134125f);
  } else {
    _184 = (((((1901800.0f - (_167 * 2006400000.0f)) * _167) + 247.47999572753906f) * _167) + 0.23703999817371368f);
  }
  float _198 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  float _205 = cb0_035y * cb0_035y;
  float _208 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_205 * 1.6145605741257896e-07f));
  float _213 = ((_198 * 2.0f) + 4.0f) - (_208 * 8.0f);
  float _214 = (_198 * 3.0f) / _213;
  float _216 = (_208 * 2.0f) / _213;
  bool _217 = (cb0_035y < 4000.0f);
  float _226 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  float _228 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_205 * 1.5317699909210205f)) / (_226 * _226);
  float _235 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _205;
  float _237 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_205 * 308.60699462890625f)) / (_235 * _235);
  float _239 = rsqrt(dot(float2(_228, _237), float2(_228, _237)));
  float _240 = cb0_035z * 0.05000000074505806f;
  float _243 = ((_240 * _237) * _239) + _198;
  float _246 = _208 - ((_240 * _228) * _239);
  float _251 = (4.0f - (_246 * 8.0f)) + (_243 * 2.0f);
  float _257 = (((_243 * 3.0f) / _251) - _214) + select(_217, _214, _184);
  float _258 = (((_246 * 2.0f) / _251) - _216) + select(_217, _216, (((_184 * 2.869999885559082f) + -0.2750000059604645f) - ((_184 * _184) * 3.0f)));
  float _259 = select(_163, _257, 0.3127000033855438f);
  float _260 = select(_163, _258, 0.32899999618530273f);
  float _261 = select(_163, 0.3127000033855438f, _257);
  float _262 = select(_163, 0.32899999618530273f, _258);
  float _263 = max(_260, 1.000000013351432e-10f);
  float _264 = _259 / _263;
  float _267 = ((1.0f - _259) - _260) / _263;
  float _268 = max(_262, 1.000000013351432e-10f);
  float _269 = _261 / _268;
  float _272 = ((1.0f - _261) - _262) / _268;
  float _291 = mad(-0.16140000522136688f, _272, ((_269 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _267, ((_264 * 0.8950999975204468f) + 0.266400009393692f));
  float _292 = mad(0.03669999912381172f, _272, (1.7135000228881836f - (_269 * 0.7501999735832214f))) / mad(0.03669999912381172f, _267, (1.7135000228881836f - (_264 * 0.7501999735832214f)));
  float _293 = mad(1.0296000242233276f, _272, ((_269 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _267, ((_264 * 0.03889999911189079f) + -0.06849999725818634f));
  float _294 = mad(_292, -0.7501999735832214f, 0.0f);
  float _295 = mad(_292, 1.7135000228881836f, 0.0f);
  float _296 = mad(_292, 0.03669999912381172f, -0.0f);
  float _297 = mad(_293, 0.03889999911189079f, 0.0f);
  float _298 = mad(_293, -0.06849999725818634f, 0.0f);
  float _299 = mad(_293, 1.0296000242233276f, 0.0f);
  float _302 = mad(0.1599626988172531f, _297, mad(-0.1470542997121811f, _294, (_291 * 0.883457362651825f)));
  float _305 = mad(0.1599626988172531f, _298, mad(-0.1470542997121811f, _295, (_291 * 0.26293492317199707f)));
  float _308 = mad(0.1599626988172531f, _299, mad(-0.1470542997121811f, _296, (_291 * -0.15930065512657166f)));
  float _311 = mad(0.04929120093584061f, _297, mad(0.5183603167533875f, _294, (_291 * 0.38695648312568665f)));
  float _314 = mad(0.04929120093584061f, _298, mad(0.5183603167533875f, _295, (_291 * 0.11516613513231277f)));
  float _317 = mad(0.04929120093584061f, _299, mad(0.5183603167533875f, _296, (_291 * -0.0697740763425827f)));
  float _320 = mad(0.9684867262840271f, _297, mad(0.04004279896616936f, _294, (_291 * -0.007634039502590895f)));
  float _323 = mad(0.9684867262840271f, _298, mad(0.04004279896616936f, _295, (_291 * -0.0022720457054674625f)));
  float _326 = mad(0.9684867262840271f, _299, mad(0.04004279896616936f, _296, (_291 * 0.0013765322510153055f)));
  float _329 = mad(_308, (WorkingColorSpace_000[2].x), mad(_305, (WorkingColorSpace_000[1].x), (_302 * (WorkingColorSpace_000[0].x))));
  float _332 = mad(_308, (WorkingColorSpace_000[2].y), mad(_305, (WorkingColorSpace_000[1].y), (_302 * (WorkingColorSpace_000[0].y))));
  float _335 = mad(_308, (WorkingColorSpace_000[2].z), mad(_305, (WorkingColorSpace_000[1].z), (_302 * (WorkingColorSpace_000[0].z))));
  float _338 = mad(_317, (WorkingColorSpace_000[2].x), mad(_314, (WorkingColorSpace_000[1].x), (_311 * (WorkingColorSpace_000[0].x))));
  float _341 = mad(_317, (WorkingColorSpace_000[2].y), mad(_314, (WorkingColorSpace_000[1].y), (_311 * (WorkingColorSpace_000[0].y))));
  float _344 = mad(_317, (WorkingColorSpace_000[2].z), mad(_314, (WorkingColorSpace_000[1].z), (_311 * (WorkingColorSpace_000[0].z))));
  float _347 = mad(_326, (WorkingColorSpace_000[2].x), mad(_323, (WorkingColorSpace_000[1].x), (_320 * (WorkingColorSpace_000[0].x))));
  float _350 = mad(_326, (WorkingColorSpace_000[2].y), mad(_323, (WorkingColorSpace_000[1].y), (_320 * (WorkingColorSpace_000[0].y))));
  float _353 = mad(_326, (WorkingColorSpace_000[2].z), mad(_323, (WorkingColorSpace_000[1].z), (_320 * (WorkingColorSpace_000[0].z))));
  float _383 = mad(mad((WorkingColorSpace_064[0].z), _353, mad((WorkingColorSpace_064[0].y), _344, (_335 * (WorkingColorSpace_064[0].x)))), _136, mad(mad((WorkingColorSpace_064[0].z), _350, mad((WorkingColorSpace_064[0].y), _341, (_332 * (WorkingColorSpace_064[0].x)))), _135, (mad((WorkingColorSpace_064[0].z), _347, mad((WorkingColorSpace_064[0].y), _338, (_329 * (WorkingColorSpace_064[0].x)))) * _134)));
  float _386 = mad(mad((WorkingColorSpace_064[1].z), _353, mad((WorkingColorSpace_064[1].y), _344, (_335 * (WorkingColorSpace_064[1].x)))), _136, mad(mad((WorkingColorSpace_064[1].z), _350, mad((WorkingColorSpace_064[1].y), _341, (_332 * (WorkingColorSpace_064[1].x)))), _135, (mad((WorkingColorSpace_064[1].z), _347, mad((WorkingColorSpace_064[1].y), _338, (_329 * (WorkingColorSpace_064[1].x)))) * _134)));
  float _389 = mad(mad((WorkingColorSpace_064[2].z), _353, mad((WorkingColorSpace_064[2].y), _344, (_335 * (WorkingColorSpace_064[2].x)))), _136, mad(mad((WorkingColorSpace_064[2].z), _350, mad((WorkingColorSpace_064[2].y), _341, (_332 * (WorkingColorSpace_064[2].x)))), _135, (mad((WorkingColorSpace_064[2].z), _347, mad((WorkingColorSpace_064[2].y), _338, (_329 * (WorkingColorSpace_064[2].x)))) * _134)));
  float _404 = mad((WorkingColorSpace_128[0].z), _389, mad((WorkingColorSpace_128[0].y), _386, ((WorkingColorSpace_128[0].x) * _383)));
  float _407 = mad((WorkingColorSpace_128[1].z), _389, mad((WorkingColorSpace_128[1].y), _386, ((WorkingColorSpace_128[1].x) * _383)));
  float _410 = mad((WorkingColorSpace_128[2].z), _389, mad((WorkingColorSpace_128[2].y), _386, ((WorkingColorSpace_128[2].x) * _383)));
  float _411 = dot(float3(_404, _407, _410), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _415 = (_404 / _411) + -1.0f;
  float _416 = (_407 / _411) + -1.0f;
  float _417 = (_410 / _411) + -1.0f;
  float _429 = (1.0f - exp2(((_411 * _411) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_415, _416, _417), float3(_415, _416, _417)) * -4.0f));
  float _445 = ((mad(-0.06368321925401688f, _410, mad(-0.3292922377586365f, _407, (_404 * 1.3704125881195068f))) - _404) * _429) + _404;
  float _446 = ((mad(-0.010861365124583244f, _410, mad(1.0970927476882935f, _407, (_404 * -0.08343357592821121f))) - _407) * _429) + _407;
  float _447 = ((mad(1.2036951780319214f, _410, mad(-0.09862580895423889f, _407, (_404 * -0.02579331398010254f))) - _410) * _429) + _410;
  float _448 = dot(float3(_445, _446, _447), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _462 = cb0_019w + cb0_024w;
  float _476 = cb0_018w * cb0_023w;
  float _490 = cb0_017w * cb0_022w;
  float _504 = cb0_016w * cb0_021w;
  float _518 = cb0_015w * cb0_020w;
  float _522 = _445 - _448;
  float _523 = _446 - _448;
  float _524 = _447 - _448;
  float _581 = saturate(_448 / cb0_035w);
  float _585 = (_581 * _581) * (3.0f - (_581 * 2.0f));
  float _586 = 1.0f - _585;
  float _595 = cb0_019w + cb0_034w;
  float _604 = cb0_018w * cb0_033w;
  float _613 = cb0_017w * cb0_032w;
  float _622 = cb0_016w * cb0_031w;
  float _631 = cb0_015w * cb0_030w;
  float _694 = saturate((_448 - cb0_036x) / (cb0_036y - cb0_036x));
  float _698 = (_694 * _694) * (3.0f - (_694 * 2.0f));
  float _707 = cb0_019w + cb0_029w;
  float _716 = cb0_018w * cb0_028w;
  float _725 = cb0_017w * cb0_027w;
  float _734 = cb0_016w * cb0_026w;
  float _743 = cb0_015w * cb0_025w;
  float _801 = _585 - _698;
  float _812 = ((_698 * (((cb0_019x + cb0_034x) + _595) + (((cb0_018x * cb0_033x) * _604) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _622) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _631) * _522) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _613)))))) + (_586 * (((cb0_019x + cb0_024x) + _462) + (((cb0_018x * cb0_023x) * _476) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _504) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _518) * _522) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _490))))))) + ((((cb0_019x + cb0_029x) + _707) + (((cb0_018x * cb0_028x) * _716) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _734) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _743) * _522) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _725))))) * _801);
  float _814 = ((_698 * (((cb0_019y + cb0_034y) + _595) + (((cb0_018y * cb0_033y) * _604) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _622) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _631) * _523) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _613)))))) + (_586 * (((cb0_019y + cb0_024y) + _462) + (((cb0_018y * cb0_023y) * _476) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _504) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _518) * _523) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _490))))))) + ((((cb0_019y + cb0_029y) + _707) + (((cb0_018y * cb0_028y) * _716) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _734) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _743) * _523) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _725))))) * _801);
  float _816 = ((_698 * (((cb0_019z + cb0_034z) + _595) + (((cb0_018z * cb0_033z) * _604) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _622) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _631) * _524) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _613)))))) + (_586 * (((cb0_019z + cb0_024z) + _462) + (((cb0_018z * cb0_023z) * _476) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _504) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _518) * _524) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _490))))))) + ((((cb0_019z + cb0_029z) + _707) + (((cb0_018z * cb0_028z) * _716) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _734) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _743) * _524) + _448)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _725))))) * _801);

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
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyzw + x is used

  float4 output = ProcessLutbuilder(float3(_812, _814, _816), s0, s1, s2, s3, t0, t1, t2, t3, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _852 = ((mad(0.061360642313957214f, _816, mad(-4.540197551250458e-09f, _814, (_812 * 0.9386394023895264f))) - _812) * cb0_036z) + _812;
  float _853 = ((mad(0.169205904006958f, _816, mad(0.8307942152023315f, _814, (_812 * 6.775371730327606e-08f))) - _814) * cb0_036z) + _814;
  float _854 = (mad(-2.3283064365386963e-10f, _814, (_812 * -9.313225746154785e-10f)) * cb0_036z) + _816;
  float _857 = mad(0.16386905312538147f, _854, mad(0.14067868888378143f, _853, (_852 * 0.6954522132873535f)));
  float _860 = mad(0.0955343246459961f, _854, mad(0.8596711158752441f, _853, (_852 * 0.044794581830501556f)));
  float _863 = mad(1.0015007257461548f, _854, mad(0.004025210160762072f, _853, (_852 * -0.005525882821530104f)));
  float _867 = max(max(_857, _860), _863);
  float _872 = (max(_867, 1.000000013351432e-10f) - max(min(min(_857, _860), _863), 1.000000013351432e-10f)) / max(_867, 0.009999999776482582f);
  float _885 = ((_860 + _857) + _863) + (sqrt((((_863 - _860) * _863) + ((_860 - _857) * _860)) + ((_857 - _863) * _857)) * 1.75f);
  float _886 = _885 * 0.3333333432674408f;
  float _887 = _872 + -0.4000000059604645f;
  float _888 = _887 * 5.0f;
  float _892 = max((1.0f - abs(_887 * 2.5f)), 0.0f);
  float _903 = ((float((int)(((int)(uint)((bool)(_888 > 0.0f))) - ((int)(uint)((bool)(_888 < 0.0f))))) * (1.0f - (_892 * _892))) + 1.0f) * 0.02500000037252903f;
  if (!(_886 <= 0.0533333346247673f)) {
    if (!(_886 >= 0.1599999964237213f)) {
      _912 = (((0.23999999463558197f / _885) + -0.5f) * _903);
    } else {
      _912 = 0.0f;
    }
  } else {
    _912 = _903;
  }
  float _913 = _912 + 1.0f;
  float _914 = _913 * _857;
  float _915 = _913 * _860;
  float _916 = _913 * _863;
  if (!((bool)(_914 == _915) && (bool)(_915 == _916))) {
    float _923 = ((_914 * 2.0f) - _915) - _916;
    float _926 = ((_860 - _863) * 1.7320507764816284f) * _913;
    float _928 = atan(_926 / _923);
    bool _931 = (_923 < 0.0f);
    bool _932 = (_923 == 0.0f);
    bool _933 = (_926 >= 0.0f);
    bool _934 = (_926 < 0.0f);
    _945 = select((_933 && _932), 90.0f, select((_934 && _932), -90.0f, (select((_934 && _931), (_928 + -3.1415927410125732f), select((_933 && _931), (_928 + 3.1415927410125732f), _928)) * 57.2957763671875f)));
  } else {
    _945 = 0.0f;
  }
  float _950 = min(max(select((_945 < 0.0f), (_945 + 360.0f), _945), 0.0f), 360.0f);
  if (_950 < -180.0f) {
    _959 = (_950 + 360.0f);
  } else {
    if (_950 > 180.0f) {
      _959 = (_950 + -360.0f);
    } else {
      _959 = _950;
    }
  }
  float _963 = saturate(1.0f - abs(_959 * 0.014814814552664757f));
  float _967 = (_963 * _963) * (3.0f - (_963 * 2.0f));
  float _973 = ((_967 * _967) * ((_872 * 0.18000000715255737f) * (0.029999999329447746f - _914))) + _914;
  float _983 = max(0.0f, mad(-0.21492856740951538f, _916, mad(-0.2365107536315918f, _915, (_973 * 1.4514392614364624f))));
  float _984 = max(0.0f, mad(-0.09967592358589172f, _916, mad(1.17622971534729f, _915, (_973 * -0.07655377686023712f))));
  float _985 = max(0.0f, mad(0.9977163076400757f, _916, mad(-0.006032449658960104f, _915, (_973 * 0.008316148072481155f))));
  float _986 = dot(float3(_983, _984, _985), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1001 = (cb0_038x + 1.0f) - cb0_037z;
  float _1003 = cb0_038y + 1.0f;
  float _1005 = _1003 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1023 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _1014 = (cb0_038x + 0.18000000715255737f) / _1001;
    _1023 = (-0.7447274923324585f - ((log2(_1014 / (2.0f - _1014)) * 0.3465735912322998f) * (_1001 / cb0_037y)));
  }
  float _1026 = ((1.0f - cb0_037z) / cb0_037y) - _1023;
  float _1028 = (cb0_037w / cb0_037y) - _1026;
  float _1032 = log2(lerp(_986, _983, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1033 = log2(lerp(_986, _984, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1034 = log2(lerp(_986, _985, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1038 = cb0_037y * (_1032 + _1026);
  float _1039 = cb0_037y * (_1033 + _1026);
  float _1040 = cb0_037y * (_1034 + _1026);
  float _1041 = _1001 * 2.0f;
  float _1043 = (cb0_037y * -2.0f) / _1001;
  float _1044 = _1032 - _1023;
  float _1045 = _1033 - _1023;
  float _1046 = _1034 - _1023;
  float _1065 = _1005 * 2.0f;
  float _1067 = (cb0_037y * 2.0f) / _1005;
  float _1092 = select((_1032 < _1023), ((_1041 / (exp2((_1044 * 1.4426950216293335f) * _1043) + 1.0f)) - cb0_038x), _1038);
  float _1093 = select((_1033 < _1023), ((_1041 / (exp2((_1045 * 1.4426950216293335f) * _1043) + 1.0f)) - cb0_038x), _1039);
  float _1094 = select((_1034 < _1023), ((_1041 / (exp2((_1046 * 1.4426950216293335f) * _1043) + 1.0f)) - cb0_038x), _1040);
  float _1101 = _1028 - _1023;
  float _1105 = saturate(_1044 / _1101);
  float _1106 = saturate(_1045 / _1101);
  float _1107 = saturate(_1046 / _1101);
  bool _1108 = (_1028 < _1023);
  float _1112 = select(_1108, (1.0f - _1105), _1105);
  float _1113 = select(_1108, (1.0f - _1106), _1106);
  float _1114 = select(_1108, (1.0f - _1107), _1107);
  float _1133 = (((_1112 * _1112) * (select((_1032 > _1028), (_1003 - (_1065 / (exp2(((_1032 - _1028) * 1.4426950216293335f) * _1067) + 1.0f))), _1038) - _1092)) * (3.0f - (_1112 * 2.0f))) + _1092;
  float _1134 = (((_1113 * _1113) * (select((_1033 > _1028), (_1003 - (_1065 / (exp2(((_1033 - _1028) * 1.4426950216293335f) * _1067) + 1.0f))), _1039) - _1093)) * (3.0f - (_1113 * 2.0f))) + _1093;
  float _1135 = (((_1114 * _1114) * (select((_1034 > _1028), (_1003 - (_1065 / (exp2(((_1034 - _1028) * 1.4426950216293335f) * _1067) + 1.0f))), _1040) - _1094)) * (3.0f - (_1114 * 2.0f))) + _1094;
  float _1136 = dot(float3(_1133, _1134, _1135), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1156 = (cb0_037x * (max(0.0f, (lerp(_1136, _1133, 0.9300000071525574f))) - _852)) + _852;
  float _1157 = (cb0_037x * (max(0.0f, (lerp(_1136, _1134, 0.9300000071525574f))) - _853)) + _853;
  float _1158 = (cb0_037x * (max(0.0f, (lerp(_1136, _1135, 0.9300000071525574f))) - _854)) + _854;
  float _1174 = ((mad(-0.06537103652954102f, _1158, mad(1.451815478503704e-06f, _1157, (_1156 * 1.065374732017517f))) - _1156) * cb0_036z) + _1156;
  float _1175 = ((mad(-0.20366770029067993f, _1158, mad(1.2036634683609009f, _1157, (_1156 * -2.57161445915699e-07f))) - _1157) * cb0_036z) + _1157;
  float _1176 = ((mad(0.9999996423721313f, _1158, mad(2.0954757928848267e-08f, _1157, (_1156 * 1.862645149230957e-08f))) - _1158) * cb0_036z) + _1158;
  float _1189 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1176, mad((WorkingColorSpace_192[0].y), _1175, ((WorkingColorSpace_192[0].x) * _1174)))));
  float _1190 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1176, mad((WorkingColorSpace_192[1].y), _1175, ((WorkingColorSpace_192[1].x) * _1174)))));
  float _1191 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1176, mad((WorkingColorSpace_192[2].y), _1175, ((WorkingColorSpace_192[2].x) * _1174)))));
  if (_1189 < 0.0031306699384003878f) {
    _1202 = (_1189 * 12.920000076293945f);
  } else {
    _1202 = (((pow(_1189, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1190 < 0.0031306699384003878f) {
    _1213 = (_1190 * 12.920000076293945f);
  } else {
    _1213 = (((pow(_1190, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1191 < 0.0031306699384003878f) {
    _1224 = (_1191 * 12.920000076293945f);
  } else {
    _1224 = (((pow(_1191, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1228 = (_1213 * 0.9375f) + 0.03125f;
  float _1235 = _1224 * 15.0f;
  float _1236 = floor(_1235);
  float _1237 = _1235 - _1236;
  float _1239 = (_1236 + ((_1202 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1242 = t0.SampleLevel(s0, float2(_1239, _1228), 0.0f);
  float _1246 = _1239 + 0.0625f;
  float4 _1247 = t0.SampleLevel(s0, float2(_1246, _1228), 0.0f);
  float4 _1269 = t1.SampleLevel(s1, float2(_1239, _1228), 0.0f);
  float4 _1273 = t1.SampleLevel(s1, float2(_1246, _1228), 0.0f);
  float4 _1295 = t2.SampleLevel(s2, float2(_1239, _1228), 0.0f);
  float4 _1299 = t2.SampleLevel(s2, float2(_1246, _1228), 0.0f);
  float4 _1322 = t3.SampleLevel(s3, float2(_1239, _1228), 0.0f);
  float4 _1326 = t3.SampleLevel(s3, float2(_1246, _1228), 0.0f);
  float _1345 = max(6.103519990574569e-05f, ((((((lerp(_1242.x, _1247.x, _1237)) * cb0_005y) + (cb0_005x * _1202)) + ((lerp(_1269.x, _1273.x, _1237)) * cb0_005z)) + ((lerp(_1295.x, _1299.x, _1237)) * cb0_005w)) + ((lerp(_1322.x, _1326.x, _1237)) * cb0_006x)));
  float _1346 = max(6.103519990574569e-05f, ((((((lerp(_1242.y, _1247.y, _1237)) * cb0_005y) + (cb0_005x * _1213)) + ((lerp(_1269.y, _1273.y, _1237)) * cb0_005z)) + ((lerp(_1295.y, _1299.y, _1237)) * cb0_005w)) + ((lerp(_1322.y, _1326.y, _1237)) * cb0_006x)));
  float _1347 = max(6.103519990574569e-05f, ((((((lerp(_1242.z, _1247.z, _1237)) * cb0_005y) + (cb0_005x * _1224)) + ((lerp(_1269.z, _1273.z, _1237)) * cb0_005z)) + ((lerp(_1295.z, _1299.z, _1237)) * cb0_005w)) + ((lerp(_1322.z, _1326.z, _1237)) * cb0_006x)));
  float _1369 = select((_1345 > 0.040449999272823334f), exp2(log2((_1345 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1345 * 0.07739938050508499f));
  float _1370 = select((_1346 > 0.040449999272823334f), exp2(log2((_1346 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1346 * 0.07739938050508499f));
  float _1371 = select((_1347 > 0.040449999272823334f), exp2(log2((_1347 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1347 * 0.07739938050508499f));
  float _1397 = cb0_014x * (((cb0_039y + (cb0_039x * _1369)) * _1369) + cb0_039z);
  float _1398 = cb0_014y * (((cb0_039y + (cb0_039x * _1370)) * _1370) + cb0_039z);
  float _1399 = cb0_014z * (((cb0_039y + (cb0_039x * _1371)) * _1371) + cb0_039z);
  float _1406 = ((cb0_013x - _1397) * cb0_013w) + _1397;
  float _1407 = ((cb0_013y - _1398) * cb0_013w) + _1398;
  float _1408 = ((cb0_013z - _1399) * cb0_013w) + _1399;
  float _1409 = cb0_014x * mad((WorkingColorSpace_192[0].z), _816, mad((WorkingColorSpace_192[0].y), _814, (_812 * (WorkingColorSpace_192[0].x))));
  float _1410 = cb0_014y * mad((WorkingColorSpace_192[1].z), _816, mad((WorkingColorSpace_192[1].y), _814, ((WorkingColorSpace_192[1].x) * _812)));
  float _1411 = cb0_014z * mad((WorkingColorSpace_192[2].z), _816, mad((WorkingColorSpace_192[2].y), _814, ((WorkingColorSpace_192[2].x) * _812)));
  float _1418 = ((cb0_013x - _1409) * cb0_013w) + _1409;
  float _1419 = ((cb0_013y - _1410) * cb0_013w) + _1410;
  float _1420 = ((cb0_013z - _1411) * cb0_013w) + _1411;
  float _1432 = exp2(log2(max(0.0f, _1406)) * cb0_040y);
  float _1433 = exp2(log2(max(0.0f, _1407)) * cb0_040y);
  float _1434 = exp2(log2(max(0.0f, _1408)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1457 = mad((WorkingColorSpace_128[0].z), _1434, mad((WorkingColorSpace_128[0].y), _1433, ((WorkingColorSpace_128[0].x) * _1432)));
        float _1460 = mad((WorkingColorSpace_128[1].z), _1434, mad((WorkingColorSpace_128[1].y), _1433, ((WorkingColorSpace_128[1].x) * _1432)));
        float _1463 = mad((WorkingColorSpace_128[2].z), _1434, mad((WorkingColorSpace_128[2].y), _1433, ((WorkingColorSpace_128[2].x) * _1432)));
        _1474 = mad(_70, _1463, mad(_69, _1460, (_1457 * _68)));
        _1475 = mad(_73, _1463, mad(_72, _1460, (_1457 * _71)));
        _1476 = mad(_76, _1463, mad(_75, _1460, (_1457 * _74)));
      } else {
        _1474 = _1432;
        _1475 = _1433;
        _1476 = _1434;
      }
      do {
        if (_1474 < 0.0031306699384003878f) {
          _1487 = (_1474 * 12.920000076293945f);
        } else {
          _1487 = (((pow(_1474, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1475 < 0.0031306699384003878f) {
            _1498 = (_1475 * 12.920000076293945f);
          } else {
            _1498 = (((pow(_1475, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1476 < 0.0031306699384003878f) {
            _3096 = _1487;
            _3097 = _1498;
            _3098 = (_1476 * 12.920000076293945f);
          } else {
            _3096 = _1487;
            _3097 = _1498;
            _3098 = (((pow(_1476, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1525 = mad((WorkingColorSpace_128[0].z), _1434, mad((WorkingColorSpace_128[0].y), _1433, ((WorkingColorSpace_128[0].x) * _1432)));
      float _1528 = mad((WorkingColorSpace_128[1].z), _1434, mad((WorkingColorSpace_128[1].y), _1433, ((WorkingColorSpace_128[1].x) * _1432)));
      float _1531 = mad((WorkingColorSpace_128[2].z), _1434, mad((WorkingColorSpace_128[2].y), _1433, ((WorkingColorSpace_128[2].x) * _1432)));
      float _1541 = max(6.103519990574569e-05f, mad(_70, _1531, mad(_69, _1528, (_1525 * _68))));
      float _1542 = max(6.103519990574569e-05f, mad(_73, _1531, mad(_72, _1528, (_1525 * _71))));
      float _1543 = max(6.103519990574569e-05f, mad(_76, _1531, mad(_75, _1528, (_1525 * _74))));
      _3096 = min((_1541 * 4.5f), ((exp2(log2(max(_1541, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3097 = min((_1542 * 4.5f), ((exp2(log2(max(_1542, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3098 = min((_1543 * 4.5f), ((exp2(log2(max(_1543, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1619 = cb0_012z * _1418;
        float _1620 = cb0_012z * _1419;
        float _1621 = cb0_012z * _1420;
        float _1624 = mad((WorkingColorSpace_256[0].z), _1621, mad((WorkingColorSpace_256[0].y), _1620, ((WorkingColorSpace_256[0].x) * _1619)));
        float _1627 = mad((WorkingColorSpace_256[1].z), _1621, mad((WorkingColorSpace_256[1].y), _1620, ((WorkingColorSpace_256[1].x) * _1619)));
        float _1630 = mad((WorkingColorSpace_256[2].z), _1621, mad((WorkingColorSpace_256[2].y), _1620, ((WorkingColorSpace_256[2].x) * _1619)));
        float _1633 = mad(-0.21492856740951538f, _1630, mad(-0.2365107536315918f, _1627, (_1624 * 1.4514392614364624f)));
        float _1636 = mad(-0.09967592358589172f, _1630, mad(1.17622971534729f, _1627, (_1624 * -0.07655377686023712f)));
        float _1639 = mad(0.9977163076400757f, _1630, mad(-0.006032449658960104f, _1627, (_1624 * 0.008316148072481155f)));
        float _1641 = max(_1633, max(_1636, _1639));
        do {
          if (!(_1641 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1624 < 0.0f) || (bool)(_1627 < 0.0f))) || (bool)(_1630 < 0.0f))) {
              float _1651 = abs(_1641);
              float _1652 = (_1641 - _1633) / _1651;
              float _1654 = (_1641 - _1636) / _1651;
              float _1656 = (_1641 - _1639) / _1651;
              do {
                if (!(_1652 < 0.8149999976158142f)) {
                  float _1659 = _1652 + -0.8149999976158142f;
                  _1671 = ((_1659 / exp2(log2(exp2(log2(_1659 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1671 = _1652;
                }
                do {
                  if (!(_1654 < 0.8029999732971191f)) {
                    float _1674 = _1654 + -0.8029999732971191f;
                    _1686 = ((_1674 / exp2(log2(exp2(log2(_1674 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1686 = _1654;
                  }
                  do {
                    if (!(_1656 < 0.8799999952316284f)) {
                      float _1689 = _1656 + -0.8799999952316284f;
                      _1701 = ((_1689 / exp2(log2(exp2(log2(_1689 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1701 = _1656;
                    }
                    _1709 = (_1641 - (_1651 * _1671));
                    _1710 = (_1641 - (_1651 * _1686));
                    _1711 = (_1641 - (_1651 * _1701));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1709 = _1633;
              _1710 = _1636;
              _1711 = _1639;
            }
          } else {
            _1709 = _1633;
            _1710 = _1636;
            _1711 = _1639;
          }
          float _1727 = ((mad(0.16386906802654266f, _1711, mad(0.14067870378494263f, _1710, (_1709 * 0.6954522132873535f))) - _1624) * cb0_012w) + _1624;
          float _1728 = ((mad(0.0955343171954155f, _1711, mad(0.8596711158752441f, _1710, (_1709 * 0.044794563204050064f))) - _1627) * cb0_012w) + _1627;
          float _1729 = ((mad(1.0015007257461548f, _1711, mad(0.004025210160762072f, _1710, (_1709 * -0.005525882821530104f))) - _1630) * cb0_012w) + _1630;
          float _1733 = max(max(_1727, _1728), _1729);
          float _1738 = (max(_1733, 1.000000013351432e-10f) - max(min(min(_1727, _1728), _1729), 1.000000013351432e-10f)) / max(_1733, 0.009999999776482582f);
          float _1751 = ((_1728 + _1727) + _1729) + (sqrt((((_1729 - _1728) * _1729) + ((_1728 - _1727) * _1728)) + ((_1727 - _1729) * _1727)) * 1.75f);
          float _1752 = _1751 * 0.3333333432674408f;
          float _1753 = _1738 + -0.4000000059604645f;
          float _1754 = _1753 * 5.0f;
          float _1758 = max((1.0f - abs(_1753 * 2.5f)), 0.0f);
          float _1769 = ((float((int)(((int)(uint)((bool)(_1754 > 0.0f))) - ((int)(uint)((bool)(_1754 < 0.0f))))) * (1.0f - (_1758 * _1758))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1752 <= 0.0533333346247673f)) {
              if (!(_1752 >= 0.1599999964237213f)) {
                _1778 = (((0.23999999463558197f / _1751) + -0.5f) * _1769);
              } else {
                _1778 = 0.0f;
              }
            } else {
              _1778 = _1769;
            }
            float _1779 = _1778 + 1.0f;
            float _1780 = _1779 * _1727;
            float _1781 = _1779 * _1728;
            float _1782 = _1779 * _1729;
            do {
              if (!((bool)(_1780 == _1781) && (bool)(_1781 == _1782))) {
                float _1789 = ((_1780 * 2.0f) - _1781) - _1782;
                float _1792 = ((_1728 - _1729) * 1.7320507764816284f) * _1779;
                float _1794 = atan(_1792 / _1789);
                bool _1797 = (_1789 < 0.0f);
                bool _1798 = (_1789 == 0.0f);
                bool _1799 = (_1792 >= 0.0f);
                bool _1800 = (_1792 < 0.0f);
                _1811 = select((_1799 && _1798), 90.0f, select((_1800 && _1798), -90.0f, (select((_1800 && _1797), (_1794 + -3.1415927410125732f), select((_1799 && _1797), (_1794 + 3.1415927410125732f), _1794)) * 57.2957763671875f)));
              } else {
                _1811 = 0.0f;
              }
              float _1816 = min(max(select((_1811 < 0.0f), (_1811 + 360.0f), _1811), 0.0f), 360.0f);
              do {
                if (_1816 < -180.0f) {
                  _1825 = (_1816 + 360.0f);
                } else {
                  if (_1816 > 180.0f) {
                    _1825 = (_1816 + -360.0f);
                  } else {
                    _1825 = _1816;
                  }
                }
                do {
                  if ((bool)(_1825 > -67.5f) && (bool)(_1825 < 67.5f)) {
                    float _1831 = (_1825 + 67.5f) * 0.029629629105329514f;
                    int _1832 = int(_1831);
                    float _1834 = _1831 - float((int)(_1832));
                    float _1835 = _1834 * _1834;
                    float _1836 = _1835 * _1834;
                    if (_1832 == 3) {
                      _1864 = (((0.1666666716337204f - (_1834 * 0.5f)) + (_1835 * 0.5f)) - (_1836 * 0.1666666716337204f));
                    } else {
                      if (_1832 == 2) {
                        _1864 = ((0.6666666865348816f - _1835) + (_1836 * 0.5f));
                      } else {
                        if (_1832 == 1) {
                          _1864 = (((_1836 * -0.5f) + 0.1666666716337204f) + ((_1835 + _1834) * 0.5f));
                        } else {
                          _1864 = select((_1832 == 0), (_1836 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1864 = 0.0f;
                  }
                  float _1873 = min(max(((((_1738 * 0.27000001072883606f) * (0.029999999329447746f - _1780)) * _1864) + _1780), 0.0f), 65535.0f);
                  float _1874 = min(max(_1781, 0.0f), 65535.0f);
                  float _1875 = min(max(_1782, 0.0f), 65535.0f);
                  float _1888 = min(max(mad(-0.21492856740951538f, _1875, mad(-0.2365107536315918f, _1874, (_1873 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1889 = min(max(mad(-0.09967592358589172f, _1875, mad(1.17622971534729f, _1874, (_1873 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1890 = min(max(mad(0.9977163076400757f, _1875, mad(-0.006032449658960104f, _1874, (_1873 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1891 = dot(float3(_1888, _1889, _1890), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _25[0] = cb0_010x;
                  _25[1] = cb0_010y;
                  _25[2] = cb0_010z;
                  _25[3] = cb0_010w;
                  _25[4] = cb0_012x;
                  _25[5] = cb0_012x;
                  _26[0] = cb0_011x;
                  _26[1] = cb0_011y;
                  _26[2] = cb0_011z;
                  _26[3] = cb0_011w;
                  _26[4] = cb0_012y;
                  _26[5] = cb0_012y;
                  float _1914 = log2(max((lerp(_1891, _1888, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1915 = _1914 * 0.3010300099849701f;
                  float _1916 = log2(cb0_008x);
                  float _1917 = _1916 * 0.3010300099849701f;
                  do {
                    if (!(!(_1915 <= _1917))) {
                      _1986 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1924 = log2(cb0_009x);
                      float _1925 = _1924 * 0.3010300099849701f;
                      if ((bool)(_1915 > _1917) && (bool)(_1915 < _1925)) {
                        float _1933 = ((_1914 - _1916) * 0.9030900001525879f) / ((_1924 - _1916) * 0.3010300099849701f);
                        int _1934 = int(_1933);
                        float _1936 = _1933 - float((int)(_1934));
                        float _1938 = _25[_1934];
                        float _1941 = _25[(_1934 + 1)];
                        float _1946 = _1938 * 0.5f;
                        _1986 = dot(float3((_1936 * _1936), _1936, 1.0f), float3(mad((_25[(_1934 + 2)]), 0.5f, mad(_1941, -1.0f, _1946)), (_1941 - _1938), mad(_1941, 0.5f, _1946)));
                      } else {
                        do {
                          if (!(!(_1915 >= _1925))) {
                            float _1955 = log2(cb0_008z);
                            if (_1915 < (_1955 * 0.3010300099849701f)) {
                              float _1963 = ((_1914 - _1924) * 0.9030900001525879f) / ((_1955 - _1924) * 0.3010300099849701f);
                              int _1964 = int(_1963);
                              float _1966 = _1963 - float((int)(_1964));
                              float _1968 = _26[_1964];
                              float _1971 = _26[(_1964 + 1)];
                              float _1976 = _1968 * 0.5f;
                              _1986 = dot(float3((_1966 * _1966), _1966, 1.0f), float3(mad((_26[(_1964 + 2)]), 0.5f, mad(_1971, -1.0f, _1976)), (_1971 - _1968), mad(_1971, 0.5f, _1976)));
                              break;
                            }
                          }
                          _1986 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _27[0] = cb0_011x;
                    _27[1] = cb0_011y;
                    _27[2] = cb0_011z;
                    _27[3] = cb0_011w;
                    _27[4] = cb0_012y;
                    _27[5] = cb0_012y;
                    float _1996 = log2(max((lerp(_1891, _1889, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1997 = _1996 * 0.3010300099849701f;
                    do {
                      if (!(!(_1997 <= _1917))) {
                        _2066 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2004 = log2(cb0_009x);
                        float _2005 = _2004 * 0.3010300099849701f;
                        if ((bool)(_1997 > _1917) && (bool)(_1997 < _2005)) {
                          float _2013 = ((_1996 - _1916) * 0.9030900001525879f) / ((_2004 - _1916) * 0.3010300099849701f);
                          int _2014 = int(_2013);
                          float _2016 = _2013 - float((int)(_2014));
                          float _2018 = _17[_2014];
                          float _2021 = _17[(_2014 + 1)];
                          float _2026 = _2018 * 0.5f;
                          _2066 = dot(float3((_2016 * _2016), _2016, 1.0f), float3(mad((_17[(_2014 + 2)]), 0.5f, mad(_2021, -1.0f, _2026)), (_2021 - _2018), mad(_2021, 0.5f, _2026)));
                        } else {
                          do {
                            if (!(!(_1997 >= _2005))) {
                              float _2035 = log2(cb0_008z);
                              if (_1997 < (_2035 * 0.3010300099849701f)) {
                                float _2043 = ((_1996 - _2004) * 0.9030900001525879f) / ((_2035 - _2004) * 0.3010300099849701f);
                                int _2044 = int(_2043);
                                float _2046 = _2043 - float((int)(_2044));
                                float _2048 = _27[_2044];
                                float _2051 = _27[(_2044 + 1)];
                                float _2056 = _2048 * 0.5f;
                                _2066 = dot(float3((_2046 * _2046), _2046, 1.0f), float3(mad((_27[(_2044 + 2)]), 0.5f, mad(_2051, -1.0f, _2056)), (_2051 - _2048), mad(_2051, 0.5f, _2056)));
                                break;
                              }
                            }
                            _2066 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2070 = log2(max((lerp(_1891, _1890, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2071 = _2070 * 0.3010300099849701f;
                      do {
                        if (!(!(_2071 <= _1917))) {
                          _2140 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2078 = log2(cb0_009x);
                          float _2079 = _2078 * 0.3010300099849701f;
                          if ((bool)(_2071 > _1917) && (bool)(_2071 < _2079)) {
                            float _2087 = ((_2070 - _1916) * 0.9030900001525879f) / ((_2078 - _1916) * 0.3010300099849701f);
                            int _2088 = int(_2087);
                            float _2090 = _2087 - float((int)(_2088));
                            float _2092 = _17[_2088];
                            float _2095 = _17[(_2088 + 1)];
                            float _2100 = _2092 * 0.5f;
                            _2140 = dot(float3((_2090 * _2090), _2090, 1.0f), float3(mad((_17[(_2088 + 2)]), 0.5f, mad(_2095, -1.0f, _2100)), (_2095 - _2092), mad(_2095, 0.5f, _2100)));
                          } else {
                            do {
                              if (!(!(_2071 >= _2079))) {
                                float _2109 = log2(cb0_008z);
                                if (_2071 < (_2109 * 0.3010300099849701f)) {
                                  float _2117 = ((_2070 - _2078) * 0.9030900001525879f) / ((_2109 - _2078) * 0.3010300099849701f);
                                  int _2118 = int(_2117);
                                  float _2120 = _2117 - float((int)(_2118));
                                  float _2122 = _18[_2118];
                                  float _2125 = _18[(_2118 + 1)];
                                  float _2130 = _2122 * 0.5f;
                                  _2140 = dot(float3((_2120 * _2120), _2120, 1.0f), float3(mad((_18[(_2118 + 2)]), 0.5f, mad(_2125, -1.0f, _2130)), (_2125 - _2122), mad(_2125, 0.5f, _2130)));
                                  break;
                                }
                              }
                              _2140 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2144 = cb0_008w - cb0_008y;
                        float _2145 = (exp2(_1986 * 3.321928024291992f) - cb0_008y) / _2144;
                        float _2147 = (exp2(_2066 * 3.321928024291992f) - cb0_008y) / _2144;
                        float _2149 = (exp2(_2140 * 3.321928024291992f) - cb0_008y) / _2144;
                        float _2152 = mad(0.15618768334388733f, _2149, mad(0.13400420546531677f, _2147, (_2145 * 0.6624541878700256f)));
                        float _2155 = mad(0.053689517080783844f, _2149, mad(0.6740817427635193f, _2147, (_2145 * 0.2722287178039551f)));
                        float _2158 = mad(1.0103391408920288f, _2149, mad(0.00406073359772563f, _2147, (_2145 * -0.005574649665504694f)));
                        float _2171 = min(max(mad(-0.23642469942569733f, _2158, mad(-0.32480329275131226f, _2155, (_2152 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2172 = min(max(mad(0.016756348311901093f, _2158, mad(1.6153316497802734f, _2155, (_2152 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2173 = min(max(mad(0.9883948564529419f, _2158, mad(-0.008284442126750946f, _2155, (_2152 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2176 = mad(0.15618768334388733f, _2173, mad(0.13400420546531677f, _2172, (_2171 * 0.6624541878700256f)));
                        float _2179 = mad(0.053689517080783844f, _2173, mad(0.6740817427635193f, _2172, (_2171 * 0.2722287178039551f)));
                        float _2182 = mad(1.0103391408920288f, _2173, mad(0.00406073359772563f, _2172, (_2171 * -0.005574649665504694f)));
                        float _2204 = min(max((min(max(mad(-0.23642469942569733f, _2182, mad(-0.32480329275131226f, _2179, (_2176 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2205 = min(max((min(max(mad(0.016756348311901093f, _2182, mad(1.6153316497802734f, _2179, (_2176 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2206 = min(max((min(max(mad(0.9883948564529419f, _2182, mad(-0.008284442126750946f, _2179, (_2176 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _2219 = mad(_70, _2206, mad(_69, _2205, (_2204 * _68)));
                            _2220 = mad(_73, _2206, mad(_72, _2205, (_2204 * _71)));
                            _2221 = mad(_76, _2206, mad(_75, _2205, (_2204 * _74)));
                          } else {
                            _2219 = _2204;
                            _2220 = _2205;
                            _2221 = _2206;
                          }
                          float _2231 = exp2(log2(_2219 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2232 = exp2(log2(_2220 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2233 = exp2(log2(_2221 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3096 = exp2(log2((1.0f / ((_2231 * 18.6875f) + 1.0f)) * ((_2231 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3097 = exp2(log2((1.0f / ((_2232 * 18.6875f) + 1.0f)) * ((_2232 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3098 = exp2(log2((1.0f / ((_2233 * 18.6875f) + 1.0f)) * ((_2233 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2299 = cb0_012z * _1418;
          float _2300 = cb0_012z * _1419;
          float _2301 = cb0_012z * _1420;
          float _2304 = mad((WorkingColorSpace_256[0].z), _2301, mad((WorkingColorSpace_256[0].y), _2300, ((WorkingColorSpace_256[0].x) * _2299)));
          float _2307 = mad((WorkingColorSpace_256[1].z), _2301, mad((WorkingColorSpace_256[1].y), _2300, ((WorkingColorSpace_256[1].x) * _2299)));
          float _2310 = mad((WorkingColorSpace_256[2].z), _2301, mad((WorkingColorSpace_256[2].y), _2300, ((WorkingColorSpace_256[2].x) * _2299)));
          float _2313 = mad(-0.21492856740951538f, _2310, mad(-0.2365107536315918f, _2307, (_2304 * 1.4514392614364624f)));
          float _2316 = mad(-0.09967592358589172f, _2310, mad(1.17622971534729f, _2307, (_2304 * -0.07655377686023712f)));
          float _2319 = mad(0.9977163076400757f, _2310, mad(-0.006032449658960104f, _2307, (_2304 * 0.008316148072481155f)));
          float _2321 = max(_2313, max(_2316, _2319));
          do {
            if (!(_2321 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2304 < 0.0f) || (bool)(_2307 < 0.0f))) || (bool)(_2310 < 0.0f))) {
                float _2331 = abs(_2321);
                float _2332 = (_2321 - _2313) / _2331;
                float _2334 = (_2321 - _2316) / _2331;
                float _2336 = (_2321 - _2319) / _2331;
                do {
                  if (!(_2332 < 0.8149999976158142f)) {
                    float _2339 = _2332 + -0.8149999976158142f;
                    _2351 = ((_2339 / exp2(log2(exp2(log2(_2339 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2351 = _2332;
                  }
                  do {
                    if (!(_2334 < 0.8029999732971191f)) {
                      float _2354 = _2334 + -0.8029999732971191f;
                      _2366 = ((_2354 / exp2(log2(exp2(log2(_2354 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2366 = _2334;
                    }
                    do {
                      if (!(_2336 < 0.8799999952316284f)) {
                        float _2369 = _2336 + -0.8799999952316284f;
                        _2381 = ((_2369 / exp2(log2(exp2(log2(_2369 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2381 = _2336;
                      }
                      _2389 = (_2321 - (_2331 * _2351));
                      _2390 = (_2321 - (_2331 * _2366));
                      _2391 = (_2321 - (_2331 * _2381));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2389 = _2313;
                _2390 = _2316;
                _2391 = _2319;
              }
            } else {
              _2389 = _2313;
              _2390 = _2316;
              _2391 = _2319;
            }
            float _2407 = ((mad(0.16386906802654266f, _2391, mad(0.14067870378494263f, _2390, (_2389 * 0.6954522132873535f))) - _2304) * cb0_012w) + _2304;
            float _2408 = ((mad(0.0955343171954155f, _2391, mad(0.8596711158752441f, _2390, (_2389 * 0.044794563204050064f))) - _2307) * cb0_012w) + _2307;
            float _2409 = ((mad(1.0015007257461548f, _2391, mad(0.004025210160762072f, _2390, (_2389 * -0.005525882821530104f))) - _2310) * cb0_012w) + _2310;
            float _2413 = max(max(_2407, _2408), _2409);
            float _2418 = (max(_2413, 1.000000013351432e-10f) - max(min(min(_2407, _2408), _2409), 1.000000013351432e-10f)) / max(_2413, 0.009999999776482582f);
            float _2431 = ((_2408 + _2407) + _2409) + (sqrt((((_2409 - _2408) * _2409) + ((_2408 - _2407) * _2408)) + ((_2407 - _2409) * _2407)) * 1.75f);
            float _2432 = _2431 * 0.3333333432674408f;
            float _2433 = _2418 + -0.4000000059604645f;
            float _2434 = _2433 * 5.0f;
            float _2438 = max((1.0f - abs(_2433 * 2.5f)), 0.0f);
            float _2449 = ((float((int)(((int)(uint)((bool)(_2434 > 0.0f))) - ((int)(uint)((bool)(_2434 < 0.0f))))) * (1.0f - (_2438 * _2438))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2432 <= 0.0533333346247673f)) {
                if (!(_2432 >= 0.1599999964237213f)) {
                  _2458 = (((0.23999999463558197f / _2431) + -0.5f) * _2449);
                } else {
                  _2458 = 0.0f;
                }
              } else {
                _2458 = _2449;
              }
              float _2459 = _2458 + 1.0f;
              float _2460 = _2459 * _2407;
              float _2461 = _2459 * _2408;
              float _2462 = _2459 * _2409;
              do {
                if (!((bool)(_2460 == _2461) && (bool)(_2461 == _2462))) {
                  float _2469 = ((_2460 * 2.0f) - _2461) - _2462;
                  float _2472 = ((_2408 - _2409) * 1.7320507764816284f) * _2459;
                  float _2474 = atan(_2472 / _2469);
                  bool _2477 = (_2469 < 0.0f);
                  bool _2478 = (_2469 == 0.0f);
                  bool _2479 = (_2472 >= 0.0f);
                  bool _2480 = (_2472 < 0.0f);
                  _2491 = select((_2479 && _2478), 90.0f, select((_2480 && _2478), -90.0f, (select((_2480 && _2477), (_2474 + -3.1415927410125732f), select((_2479 && _2477), (_2474 + 3.1415927410125732f), _2474)) * 57.2957763671875f)));
                } else {
                  _2491 = 0.0f;
                }
                float _2496 = min(max(select((_2491 < 0.0f), (_2491 + 360.0f), _2491), 0.0f), 360.0f);
                do {
                  if (_2496 < -180.0f) {
                    _2505 = (_2496 + 360.0f);
                  } else {
                    if (_2496 > 180.0f) {
                      _2505 = (_2496 + -360.0f);
                    } else {
                      _2505 = _2496;
                    }
                  }
                  do {
                    if ((bool)(_2505 > -67.5f) && (bool)(_2505 < 67.5f)) {
                      float _2511 = (_2505 + 67.5f) * 0.029629629105329514f;
                      int _2512 = int(_2511);
                      float _2514 = _2511 - float((int)(_2512));
                      float _2515 = _2514 * _2514;
                      float _2516 = _2515 * _2514;
                      if (_2512 == 3) {
                        _2544 = (((0.1666666716337204f - (_2514 * 0.5f)) + (_2515 * 0.5f)) - (_2516 * 0.1666666716337204f));
                      } else {
                        if (_2512 == 2) {
                          _2544 = ((0.6666666865348816f - _2515) + (_2516 * 0.5f));
                        } else {
                          if (_2512 == 1) {
                            _2544 = (((_2516 * -0.5f) + 0.1666666716337204f) + ((_2515 + _2514) * 0.5f));
                          } else {
                            _2544 = select((_2512 == 0), (_2516 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2544 = 0.0f;
                    }
                    float _2553 = min(max(((((_2418 * 0.27000001072883606f) * (0.029999999329447746f - _2460)) * _2544) + _2460), 0.0f), 65535.0f);
                    float _2554 = min(max(_2461, 0.0f), 65535.0f);
                    float _2555 = min(max(_2462, 0.0f), 65535.0f);
                    float _2568 = min(max(mad(-0.21492856740951538f, _2555, mad(-0.2365107536315918f, _2554, (_2553 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2569 = min(max(mad(-0.09967592358589172f, _2555, mad(1.17622971534729f, _2554, (_2553 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2570 = min(max(mad(0.9977163076400757f, _2555, mad(-0.006032449658960104f, _2554, (_2553 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2571 = dot(float3(_2568, _2569, _2570), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    _23[0] = cb0_010x;
                    _23[1] = cb0_010y;
                    _23[2] = cb0_010z;
                    _23[3] = cb0_010w;
                    _23[4] = cb0_012x;
                    _23[5] = cb0_012x;
                    _24[0] = cb0_011x;
                    _24[1] = cb0_011y;
                    _24[2] = cb0_011z;
                    _24[3] = cb0_011w;
                    _24[4] = cb0_012y;
                    _24[5] = cb0_012y;
                    float _2594 = log2(max((lerp(_2571, _2568, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2595 = _2594 * 0.3010300099849701f;
                    float _2596 = log2(cb0_008x);
                    float _2597 = _2596 * 0.3010300099849701f;
                    do {
                      if (!(!(_2595 <= _2597))) {
                        _2666 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2604 = log2(cb0_009x);
                        float _2605 = _2604 * 0.3010300099849701f;
                        if ((bool)(_2595 > _2597) && (bool)(_2595 < _2605)) {
                          float _2613 = ((_2594 - _2596) * 0.9030900001525879f) / ((_2604 - _2596) * 0.3010300099849701f);
                          int _2614 = int(_2613);
                          float _2616 = _2613 - float((int)(_2614));
                          float _2618 = _23[_2614];
                          float _2621 = _23[(_2614 + 1)];
                          float _2626 = _2618 * 0.5f;
                          _2666 = dot(float3((_2616 * _2616), _2616, 1.0f), float3(mad((_23[(_2614 + 2)]), 0.5f, mad(_2621, -1.0f, _2626)), (_2621 - _2618), mad(_2621, 0.5f, _2626)));
                        } else {
                          do {
                            if (!(!(_2595 >= _2605))) {
                              float _2635 = log2(cb0_008z);
                              if (_2595 < (_2635 * 0.3010300099849701f)) {
                                float _2643 = ((_2594 - _2604) * 0.9030900001525879f) / ((_2635 - _2604) * 0.3010300099849701f);
                                int _2644 = int(_2643);
                                float _2646 = _2643 - float((int)(_2644));
                                float _2648 = _24[_2644];
                                float _2651 = _24[(_2644 + 1)];
                                float _2656 = _2648 * 0.5f;
                                _2666 = dot(float3((_2646 * _2646), _2646, 1.0f), float3(mad((_24[(_2644 + 2)]), 0.5f, mad(_2651, -1.0f, _2656)), (_2651 - _2648), mad(_2651, 0.5f, _2656)));
                                break;
                              }
                            }
                            _2666 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2682 = log2(max((lerp(_2571, _2569, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2683 = _2682 * 0.3010300099849701f;
                      do {
                        if (!(!(_2683 <= _2597))) {
                          _2752 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2690 = log2(cb0_009x);
                          float _2691 = _2690 * 0.3010300099849701f;
                          if ((bool)(_2683 > _2597) && (bool)(_2683 < _2691)) {
                            float _2699 = ((_2682 - _2596) * 0.9030900001525879f) / ((_2690 - _2596) * 0.3010300099849701f);
                            int _2700 = int(_2699);
                            float _2702 = _2699 - float((int)(_2700));
                            float _2704 = _19[_2700];
                            float _2707 = _19[(_2700 + 1)];
                            float _2712 = _2704 * 0.5f;
                            _2752 = dot(float3((_2702 * _2702), _2702, 1.0f), float3(mad((_19[(_2700 + 2)]), 0.5f, mad(_2707, -1.0f, _2712)), (_2707 - _2704), mad(_2707, 0.5f, _2712)));
                          } else {
                            do {
                              if (!(!(_2683 >= _2691))) {
                                float _2721 = log2(cb0_008z);
                                if (_2683 < (_2721 * 0.3010300099849701f)) {
                                  float _2729 = ((_2682 - _2690) * 0.9030900001525879f) / ((_2721 - _2690) * 0.3010300099849701f);
                                  int _2730 = int(_2729);
                                  float _2732 = _2729 - float((int)(_2730));
                                  float _2734 = _20[_2730];
                                  float _2737 = _20[(_2730 + 1)];
                                  float _2742 = _2734 * 0.5f;
                                  _2752 = dot(float3((_2732 * _2732), _2732, 1.0f), float3(mad((_20[(_2730 + 2)]), 0.5f, mad(_2737, -1.0f, _2742)), (_2737 - _2734), mad(_2737, 0.5f, _2742)));
                                  break;
                                }
                              }
                              _2752 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2768 = log2(max((lerp(_2571, _2570, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2769 = _2768 * 0.3010300099849701f;
                        do {
                          if (!(!(_2769 <= _2597))) {
                            _2838 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2776 = log2(cb0_009x);
                            float _2777 = _2776 * 0.3010300099849701f;
                            if ((bool)(_2769 > _2597) && (bool)(_2769 < _2777)) {
                              float _2785 = ((_2768 - _2596) * 0.9030900001525879f) / ((_2776 - _2596) * 0.3010300099849701f);
                              int _2786 = int(_2785);
                              float _2788 = _2785 - float((int)(_2786));
                              float _2790 = _21[_2786];
                              float _2793 = _21[(_2786 + 1)];
                              float _2798 = _2790 * 0.5f;
                              _2838 = dot(float3((_2788 * _2788), _2788, 1.0f), float3(mad((_21[(_2786 + 2)]), 0.5f, mad(_2793, -1.0f, _2798)), (_2793 - _2790), mad(_2793, 0.5f, _2798)));
                            } else {
                              do {
                                if (!(!(_2769 >= _2777))) {
                                  float _2807 = log2(cb0_008z);
                                  if (_2769 < (_2807 * 0.3010300099849701f)) {
                                    float _2815 = ((_2768 - _2776) * 0.9030900001525879f) / ((_2807 - _2776) * 0.3010300099849701f);
                                    int _2816 = int(_2815);
                                    float _2818 = _2815 - float((int)(_2816));
                                    float _2820 = _22[_2816];
                                    float _2823 = _22[(_2816 + 1)];
                                    float _2828 = _2820 * 0.5f;
                                    _2838 = dot(float3((_2818 * _2818), _2818, 1.0f), float3(mad((_22[(_2816 + 2)]), 0.5f, mad(_2823, -1.0f, _2828)), (_2823 - _2820), mad(_2823, 0.5f, _2828)));
                                    break;
                                  }
                                }
                                _2838 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2842 = cb0_008w - cb0_008y;
                          float _2843 = (exp2(_2666 * 3.321928024291992f) - cb0_008y) / _2842;
                          float _2845 = (exp2(_2752 * 3.321928024291992f) - cb0_008y) / _2842;
                          float _2847 = (exp2(_2838 * 3.321928024291992f) - cb0_008y) / _2842;
                          float _2850 = mad(0.15618768334388733f, _2847, mad(0.13400420546531677f, _2845, (_2843 * 0.6624541878700256f)));
                          float _2853 = mad(0.053689517080783844f, _2847, mad(0.6740817427635193f, _2845, (_2843 * 0.2722287178039551f)));
                          float _2856 = mad(1.0103391408920288f, _2847, mad(0.00406073359772563f, _2845, (_2843 * -0.005574649665504694f)));
                          float _2869 = min(max(mad(-0.23642469942569733f, _2856, mad(-0.32480329275131226f, _2853, (_2850 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2870 = min(max(mad(0.016756348311901093f, _2856, mad(1.6153316497802734f, _2853, (_2850 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2871 = min(max(mad(0.9883948564529419f, _2856, mad(-0.008284442126750946f, _2853, (_2850 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2874 = mad(0.15618768334388733f, _2871, mad(0.13400420546531677f, _2870, (_2869 * 0.6624541878700256f)));
                          float _2877 = mad(0.053689517080783844f, _2871, mad(0.6740817427635193f, _2870, (_2869 * 0.2722287178039551f)));
                          float _2880 = mad(1.0103391408920288f, _2871, mad(0.00406073359772563f, _2870, (_2869 * -0.005574649665504694f)));
                          float _2902 = min(max((min(max(mad(-0.23642469942569733f, _2880, mad(-0.32480329275131226f, _2877, (_2874 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2903 = min(max((min(max(mad(0.016756348311901093f, _2880, mad(1.6153316497802734f, _2877, (_2874 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2904 = min(max((min(max(mad(0.9883948564529419f, _2880, mad(-0.008284442126750946f, _2877, (_2874 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2917 = mad(_70, _2904, mad(_69, _2903, (_2902 * _68)));
                              _2918 = mad(_73, _2904, mad(_72, _2903, (_2902 * _71)));
                              _2919 = mad(_76, _2904, mad(_75, _2903, (_2902 * _74)));
                            } else {
                              _2917 = _2902;
                              _2918 = _2903;
                              _2919 = _2904;
                            }
                            float _2929 = exp2(log2(_2917 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2930 = exp2(log2(_2918 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2931 = exp2(log2(_2919 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _3096 = exp2(log2((1.0f / ((_2929 * 18.6875f) + 1.0f)) * ((_2929 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3097 = exp2(log2((1.0f / ((_2930 * 18.6875f) + 1.0f)) * ((_2930 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3098 = exp2(log2((1.0f / ((_2931 * 18.6875f) + 1.0f)) * ((_2931 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2976 = mad((WorkingColorSpace_128[0].z), _1420, mad((WorkingColorSpace_128[0].y), _1419, ((WorkingColorSpace_128[0].x) * _1418)));
            float _2979 = mad((WorkingColorSpace_128[1].z), _1420, mad((WorkingColorSpace_128[1].y), _1419, ((WorkingColorSpace_128[1].x) * _1418)));
            float _2982 = mad((WorkingColorSpace_128[2].z), _1420, mad((WorkingColorSpace_128[2].y), _1419, ((WorkingColorSpace_128[2].x) * _1418)));
            float _3001 = exp2(log2(mad(_70, _2982, mad(_69, _2979, (_2976 * _68))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3002 = exp2(log2(mad(_73, _2982, mad(_72, _2979, (_2976 * _71))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _3003 = exp2(log2(mad(_76, _2982, mad(_75, _2979, (_2976 * _74))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3096 = exp2(log2((1.0f / ((_3001 * 18.6875f) + 1.0f)) * ((_3001 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3097 = exp2(log2((1.0f / ((_3002 * 18.6875f) + 1.0f)) * ((_3002 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3098 = exp2(log2((1.0f / ((_3003 * 18.6875f) + 1.0f)) * ((_3003 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _3050 = mad((WorkingColorSpace_128[0].z), _1408, mad((WorkingColorSpace_128[0].y), _1407, ((WorkingColorSpace_128[0].x) * _1406)));
                float _3053 = mad((WorkingColorSpace_128[1].z), _1408, mad((WorkingColorSpace_128[1].y), _1407, ((WorkingColorSpace_128[1].x) * _1406)));
                float _3056 = mad((WorkingColorSpace_128[2].z), _1408, mad((WorkingColorSpace_128[2].y), _1407, ((WorkingColorSpace_128[2].x) * _1406)));
                _3096 = mad(_70, _3056, mad(_69, _3053, (_3050 * _68)));
                _3097 = mad(_73, _3056, mad(_72, _3053, (_3050 * _71)));
                _3098 = mad(_76, _3056, mad(_75, _3053, (_3050 * _74)));
              } else {
                float _3069 = mad((WorkingColorSpace_128[0].z), _1434, mad((WorkingColorSpace_128[0].y), _1433, ((WorkingColorSpace_128[0].x) * _1432)));
                float _3072 = mad((WorkingColorSpace_128[1].z), _1434, mad((WorkingColorSpace_128[1].y), _1433, ((WorkingColorSpace_128[1].x) * _1432)));
                float _3075 = mad((WorkingColorSpace_128[2].z), _1434, mad((WorkingColorSpace_128[2].y), _1433, ((WorkingColorSpace_128[2].x) * _1432)));
                _3096 = exp2(log2(mad(_70, _3075, mad(_69, _3072, (_3069 * _68)))) * cb0_040z);
                _3097 = exp2(log2(mad(_73, _3075, mad(_72, _3072, (_3069 * _71)))) * cb0_040z);
                _3098 = exp2(log2(mad(_76, _3075, mad(_75, _3072, (_3069 * _74)))) * cb0_040z);
              }
            } else {
              _3096 = _1418;
              _3097 = _1419;
              _3098 = _1420;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_3096 * 0.9523810148239136f), (_3097 * 0.9523810148239136f), (_3098 * 0.9523810148239136f), 0.0f);
}
