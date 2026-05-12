// High on Life 2, UE 5.5

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _15[6];
  float _16[6];
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
  float _38 = 0.5f / cb0_035x;
  float _43 = cb0_035x + -1.0f;
  float _44 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _38)) / _43;
  float _45 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _38)) / _43;
  float _47 = float((uint)SV_DispatchThreadID.z) / _43;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _73;
  float _74;
  float _75;
  float _133;
  float _134;
  float _135;
  float _183;
  float _911;
  float _944;
  float _958;
  float _1022;
  float _1201;
  float _1212;
  float _1223;
  float _1446;
  float _1447;
  float _1448;
  float _1459;
  float _1470;
  float _1643;
  float _1658;
  float _1673;
  float _1681;
  float _1682;
  float _1683;
  float _1750;
  float _1783;
  float _1797;
  float _1836;
  float _1958;
  float _2044;
  float _2118;
  float _2197;
  float _2198;
  float _2199;
  float _2329;
  float _2344;
  float _2359;
  float _2367;
  float _2368;
  float _2369;
  float _2436;
  float _2469;
  float _2483;
  float _2522;
  float _2644;
  float _2730;
  float _2816;
  float _2895;
  float _2896;
  float _2897;
  float _3074;
  float _3075;
  float _3076;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _56 = (cb0_041x == 4);
        _67 = select(_56, 1.0f, 1.705051064491272f);
        _68 = select(_56, 0.0f, -0.6217921376228333f);
        _69 = select(_56, 0.0f, -0.0832589864730835f);
        _70 = select(_56, 0.0f, -0.13025647401809692f);
        _71 = select(_56, 1.0f, 1.140804648399353f);
        _72 = select(_56, 0.0f, -0.010548308491706848f);
        _73 = select(_56, 0.0f, -0.024003351107239723f);
        _74 = select(_56, 0.0f, -0.1289689838886261f);
        _75 = select(_56, 1.0f, 1.1529725790023804f);
      } else {
        _67 = 0.6954522132873535f;
        _68 = 0.14067870378494263f;
        _69 = 0.16386906802654266f;
        _70 = 0.044794563204050064f;
        _71 = 0.8596711158752441f;
        _72 = 0.0955343171954155f;
        _73 = -0.005525882821530104f;
        _74 = 0.004025210160762072f;
        _75 = 1.0015007257461548f;
      }
    } else {
      _67 = 1.0258246660232544f;
      _68 = -0.020053181797266006f;
      _69 = -0.005771636962890625f;
      _70 = -0.002234415616840124f;
      _71 = 1.0045864582061768f;
      _72 = -0.002352118492126465f;
      _73 = -0.005013350863009691f;
      _74 = -0.025290070101618767f;
      _75 = 1.0303035974502563f;
    }
  } else {
    _67 = 1.3792141675949097f;
    _68 = -0.30886411666870117f;
    _69 = -0.0703500509262085f;
    _70 = -0.06933490186929703f;
    _71 = 1.08229660987854f;
    _72 = -0.012961871922016144f;
    _73 = -0.0021590073592960835f;
    _74 = -0.0454593189060688f;
    _75 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _86 = (pow(_44, 0.012683313339948654f));
    float _87 = (pow(_45, 0.012683313339948654f));
    float _88 = (pow(_47, 0.012683313339948654f));
    _133 = (exp2(log2(max(0.0f, (_86 + -0.8359375f)) / (18.8515625f - (_86 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _134 = (exp2(log2(max(0.0f, (_87 + -0.8359375f)) / (18.8515625f - (_87 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _135 = (exp2(log2(max(0.0f, (_88 + -0.8359375f)) / (18.8515625f - (_88 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _133 = ((exp2((_44 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _134 = ((exp2((_45 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _135 = ((exp2((_47 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _162 = (cb0_038w != 0);
  float _166 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _183 = (((((2967800.0f - (_166 * 4607000064.0f)) * _166) + 99.11000061035156f) * _166) + 0.24406300485134125f);
  } else {
    _183 = (((((1901800.0f - (_166 * 2006400000.0f)) * _166) + 247.47999572753906f) * _166) + 0.23703999817371368f);
  }
  float _197 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  float _204 = cb0_035y * cb0_035y;
  float _207 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_204 * 1.6145605741257896e-07f));
  float _212 = ((_197 * 2.0f) + 4.0f) - (_207 * 8.0f);
  float _213 = (_197 * 3.0f) / _212;
  float _215 = (_207 * 2.0f) / _212;
  bool _216 = (cb0_035y < 4000.0f);
  float _225 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  float _227 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_204 * 1.5317699909210205f)) / (_225 * _225);
  float _234 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _204;
  float _236 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_204 * 308.60699462890625f)) / (_234 * _234);
  float _238 = rsqrt(dot(float2(_227, _236), float2(_227, _236)));
  float _239 = cb0_035z * 0.05000000074505806f;
  float _242 = ((_239 * _236) * _238) + _197;
  float _245 = _207 - ((_239 * _227) * _238);
  float _250 = (4.0f - (_245 * 8.0f)) + (_242 * 2.0f);
  float _256 = (((_242 * 3.0f) / _250) - _213) + select(_216, _213, _183);
  float _257 = (((_245 * 2.0f) / _250) - _215) + select(_216, _215, (((_183 * 2.869999885559082f) + -0.2750000059604645f) - ((_183 * _183) * 3.0f)));
  float _258 = select(_162, _256, 0.3127000033855438f);
  float _259 = select(_162, _257, 0.32899999618530273f);
  float _260 = select(_162, 0.3127000033855438f, _256);
  float _261 = select(_162, 0.32899999618530273f, _257);
  float _262 = max(_259, 1.000000013351432e-10f);
  float _263 = _258 / _262;
  float _266 = ((1.0f - _258) - _259) / _262;
  float _267 = max(_261, 1.000000013351432e-10f);
  float _268 = _260 / _267;
  float _271 = ((1.0f - _260) - _261) / _267;
  float _290 = mad(-0.16140000522136688f, _271, ((_268 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _266, ((_263 * 0.8950999975204468f) + 0.266400009393692f));
  float _291 = mad(0.03669999912381172f, _271, (1.7135000228881836f - (_268 * 0.7501999735832214f))) / mad(0.03669999912381172f, _266, (1.7135000228881836f - (_263 * 0.7501999735832214f)));
  float _292 = mad(1.0296000242233276f, _271, ((_268 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _266, ((_263 * 0.03889999911189079f) + -0.06849999725818634f));
  float _293 = mad(_291, -0.7501999735832214f, 0.0f);
  float _294 = mad(_291, 1.7135000228881836f, 0.0f);
  float _295 = mad(_291, 0.03669999912381172f, -0.0f);
  float _296 = mad(_292, 0.03889999911189079f, 0.0f);
  float _297 = mad(_292, -0.06849999725818634f, 0.0f);
  float _298 = mad(_292, 1.0296000242233276f, 0.0f);
  float _301 = mad(0.1599626988172531f, _296, mad(-0.1470542997121811f, _293, (_290 * 0.883457362651825f)));
  float _304 = mad(0.1599626988172531f, _297, mad(-0.1470542997121811f, _294, (_290 * 0.26293492317199707f)));
  float _307 = mad(0.1599626988172531f, _298, mad(-0.1470542997121811f, _295, (_290 * -0.15930065512657166f)));
  float _310 = mad(0.04929120093584061f, _296, mad(0.5183603167533875f, _293, (_290 * 0.38695648312568665f)));
  float _313 = mad(0.04929120093584061f, _297, mad(0.5183603167533875f, _294, (_290 * 0.11516613513231277f)));
  float _316 = mad(0.04929120093584061f, _298, mad(0.5183603167533875f, _295, (_290 * -0.0697740763425827f)));
  float _319 = mad(0.9684867262840271f, _296, mad(0.04004279896616936f, _293, (_290 * -0.007634039502590895f)));
  float _322 = mad(0.9684867262840271f, _297, mad(0.04004279896616936f, _294, (_290 * -0.0022720457054674625f)));
  float _325 = mad(0.9684867262840271f, _298, mad(0.04004279896616936f, _295, (_290 * 0.0013765322510153055f)));
  float _328 = mad(_307, (WorkingColorSpace_000[2].x), mad(_304, (WorkingColorSpace_000[1].x), (_301 * (WorkingColorSpace_000[0].x))));
  float _331 = mad(_307, (WorkingColorSpace_000[2].y), mad(_304, (WorkingColorSpace_000[1].y), (_301 * (WorkingColorSpace_000[0].y))));
  float _334 = mad(_307, (WorkingColorSpace_000[2].z), mad(_304, (WorkingColorSpace_000[1].z), (_301 * (WorkingColorSpace_000[0].z))));
  float _337 = mad(_316, (WorkingColorSpace_000[2].x), mad(_313, (WorkingColorSpace_000[1].x), (_310 * (WorkingColorSpace_000[0].x))));
  float _340 = mad(_316, (WorkingColorSpace_000[2].y), mad(_313, (WorkingColorSpace_000[1].y), (_310 * (WorkingColorSpace_000[0].y))));
  float _343 = mad(_316, (WorkingColorSpace_000[2].z), mad(_313, (WorkingColorSpace_000[1].z), (_310 * (WorkingColorSpace_000[0].z))));
  float _346 = mad(_325, (WorkingColorSpace_000[2].x), mad(_322, (WorkingColorSpace_000[1].x), (_319 * (WorkingColorSpace_000[0].x))));
  float _349 = mad(_325, (WorkingColorSpace_000[2].y), mad(_322, (WorkingColorSpace_000[1].y), (_319 * (WorkingColorSpace_000[0].y))));
  float _352 = mad(_325, (WorkingColorSpace_000[2].z), mad(_322, (WorkingColorSpace_000[1].z), (_319 * (WorkingColorSpace_000[0].z))));
  float _382 = mad(mad((WorkingColorSpace_064[0].z), _352, mad((WorkingColorSpace_064[0].y), _343, (_334 * (WorkingColorSpace_064[0].x)))), _135, mad(mad((WorkingColorSpace_064[0].z), _349, mad((WorkingColorSpace_064[0].y), _340, (_331 * (WorkingColorSpace_064[0].x)))), _134, (mad((WorkingColorSpace_064[0].z), _346, mad((WorkingColorSpace_064[0].y), _337, (_328 * (WorkingColorSpace_064[0].x)))) * _133)));
  float _385 = mad(mad((WorkingColorSpace_064[1].z), _352, mad((WorkingColorSpace_064[1].y), _343, (_334 * (WorkingColorSpace_064[1].x)))), _135, mad(mad((WorkingColorSpace_064[1].z), _349, mad((WorkingColorSpace_064[1].y), _340, (_331 * (WorkingColorSpace_064[1].x)))), _134, (mad((WorkingColorSpace_064[1].z), _346, mad((WorkingColorSpace_064[1].y), _337, (_328 * (WorkingColorSpace_064[1].x)))) * _133)));
  float _388 = mad(mad((WorkingColorSpace_064[2].z), _352, mad((WorkingColorSpace_064[2].y), _343, (_334 * (WorkingColorSpace_064[2].x)))), _135, mad(mad((WorkingColorSpace_064[2].z), _349, mad((WorkingColorSpace_064[2].y), _340, (_331 * (WorkingColorSpace_064[2].x)))), _134, (mad((WorkingColorSpace_064[2].z), _346, mad((WorkingColorSpace_064[2].y), _337, (_328 * (WorkingColorSpace_064[2].x)))) * _133)));
  float _403 = mad((WorkingColorSpace_128[0].z), _388, mad((WorkingColorSpace_128[0].y), _385, ((WorkingColorSpace_128[0].x) * _382)));
  float _406 = mad((WorkingColorSpace_128[1].z), _388, mad((WorkingColorSpace_128[1].y), _385, ((WorkingColorSpace_128[1].x) * _382)));
  float _409 = mad((WorkingColorSpace_128[2].z), _388, mad((WorkingColorSpace_128[2].y), _385, ((WorkingColorSpace_128[2].x) * _382)));
  float _410 = dot(float3(_403, _406, _409), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _414 = (_403 / _410) + -1.0f;
  float _415 = (_406 / _410) + -1.0f;
  float _416 = (_409 / _410) + -1.0f;

  // float _428 = (1.0f - exp2(((_410 * _410) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_414, _415, _416), float3(_414, _415, _416)) * -4.0f));
  float _428 = (1.0f - exp2(((_410 * _410) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_414, _415, _416), float3(_414, _415, _416)) * -4.0f));

  float _444 = ((mad(-0.06368321925401688f, _409, mad(-0.3292922377586365f, _406, (_403 * 1.3704125881195068f))) - _403) * _428) + _403;
  float _445 = ((mad(-0.010861365124583244f, _409, mad(1.0970927476882935f, _406, (_403 * -0.08343357592821121f))) - _406) * _428) + _406;
  float _446 = ((mad(1.2036951780319214f, _409, mad(-0.09862580895423889f, _406, (_403 * -0.02579331398010254f))) - _409) * _428) + _409;
  float _447 = dot(float3(_444, _445, _446), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _461 = cb0_019w + cb0_024w;
  float _475 = cb0_018w * cb0_023w;
  float _489 = cb0_017w * cb0_022w;
  float _503 = cb0_016w * cb0_021w;
  float _517 = cb0_015w * cb0_020w;
  float _521 = _444 - _447;
  float _522 = _445 - _447;
  float _523 = _446 - _447;
  float _580 = saturate(_447 / cb0_035w);
  float _584 = (_580 * _580) * (3.0f - (_580 * 2.0f));
  float _585 = 1.0f - _584;
  float _594 = cb0_019w + cb0_034w;
  float _603 = cb0_018w * cb0_033w;
  float _612 = cb0_017w * cb0_032w;
  float _621 = cb0_016w * cb0_031w;
  float _630 = cb0_015w * cb0_030w;
  float _693 = saturate((_447 - cb0_036x) / (cb0_036y - cb0_036x));
  float _697 = (_693 * _693) * (3.0f - (_693 * 2.0f));
  float _706 = cb0_019w + cb0_029w;
  float _715 = cb0_018w * cb0_028w;
  float _724 = cb0_017w * cb0_027w;
  float _733 = cb0_016w * cb0_026w;
  float _742 = cb0_015w * cb0_025w;
  float _800 = _584 - _697;
  float _811 = ((_697 * (((cb0_019x + cb0_034x) + _594) + (((cb0_018x * cb0_033x) * _603) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _621) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _630) * _521) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _612)))))) + (_585 * (((cb0_019x + cb0_024x) + _461) + (((cb0_018x * cb0_023x) * _475) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _503) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _517) * _521) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _489))))))) + ((((cb0_019x + cb0_029x) + _706) + (((cb0_018x * cb0_028x) * _715) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _733) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _742) * _521) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _724))))) * _800);
  float _813 = ((_697 * (((cb0_019y + cb0_034y) + _594) + (((cb0_018y * cb0_033y) * _603) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _621) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _630) * _522) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _612)))))) + (_585 * (((cb0_019y + cb0_024y) + _461) + (((cb0_018y * cb0_023y) * _475) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _503) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _517) * _522) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _489))))))) + ((((cb0_019y + cb0_029y) + _706) + (((cb0_018y * cb0_028y) * _715) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _733) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _742) * _522) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _724))))) * _800);
  float _815 = ((_697 * (((cb0_019z + cb0_034z) + _594) + (((cb0_018z * cb0_033z) * _603) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _621) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _630) * _523) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _612)))))) + (_585 * (((cb0_019z + cb0_024z) + _461) + (((cb0_018z * cb0_023z) * _475) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _503) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _517) * _523) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _489))))))) + ((((cb0_019z + cb0_029z) + _706) + (((cb0_018z * cb0_028z) * _715) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _733) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _742) * _523) + _447)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _724))))) * _800);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  //  Lutweights[0].xyzw is used

  float4 output = ProcessLutbuilder(float3(_811, _813, _815), s0, s1, s2, t0, t1, t2, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _851 = ((mad(0.061360642313957214f, _815, mad(-4.540197551250458e-09f, _813, (_811 * 0.9386394023895264f))) - _811) * cb0_036z) + _811;
  float _852 = ((mad(0.169205904006958f, _815, mad(0.8307942152023315f, _813, (_811 * 6.775371730327606e-08f))) - _813) * cb0_036z) + _813;
  float _853 = (mad(-2.3283064365386963e-10f, _813, (_811 * -9.313225746154785e-10f)) * cb0_036z) + _815;
  float _856 = mad(0.16386905312538147f, _853, mad(0.14067868888378143f, _852, (_851 * 0.6954522132873535f)));
  float _859 = mad(0.0955343246459961f, _853, mad(0.8596711158752441f, _852, (_851 * 0.044794581830501556f)));
  float _862 = mad(1.0015007257461548f, _853, mad(0.004025210160762072f, _852, (_851 * -0.005525882821530104f)));
  float _866 = max(max(_856, _859), _862);
  float _871 = (max(_866, 1.000000013351432e-10f) - max(min(min(_856, _859), _862), 1.000000013351432e-10f)) / max(_866, 0.009999999776482582f);
  float _884 = ((_859 + _856) + _862) + (sqrt((((_862 - _859) * _862) + ((_859 - _856) * _859)) + ((_856 - _862) * _856)) * 1.75f);
  float _885 = _884 * 0.3333333432674408f;
  float _886 = _871 + -0.4000000059604645f;
  float _887 = _886 * 5.0f;
  float _891 = max((1.0f - abs(_886 * 2.5f)), 0.0f);
  float _902 = ((float((int)(((int)(uint)((bool)(_887 > 0.0f))) - ((int)(uint)((bool)(_887 < 0.0f))))) * (1.0f - (_891 * _891))) + 1.0f) * 0.02500000037252903f;
  if (!(_885 <= 0.0533333346247673f)) {
    if (!(_885 >= 0.1599999964237213f)) {
      _911 = (((0.23999999463558197f / _884) + -0.5f) * _902);
    } else {
      _911 = 0.0f;
    }
  } else {
    _911 = _902;
  }
  float _912 = _911 + 1.0f;
  float _913 = _912 * _856;
  float _914 = _912 * _859;
  float _915 = _912 * _862;
  if (!((bool)(_913 == _914) && (bool)(_914 == _915))) {
    float _922 = ((_913 * 2.0f) - _914) - _915;
    float _925 = ((_859 - _862) * 1.7320507764816284f) * _912;
    float _927 = atan(_925 / _922);
    bool _930 = (_922 < 0.0f);
    bool _931 = (_922 == 0.0f);
    bool _932 = (_925 >= 0.0f);
    bool _933 = (_925 < 0.0f);
    _944 = select((_932 && _931), 90.0f, select((_933 && _931), -90.0f, (select((_933 && _930), (_927 + -3.1415927410125732f), select((_932 && _930), (_927 + 3.1415927410125732f), _927)) * 57.2957763671875f)));
  } else {
    _944 = 0.0f;
  }
  float _949 = min(max(select((_944 < 0.0f), (_944 + 360.0f), _944), 0.0f), 360.0f);
  if (_949 < -180.0f) {
    _958 = (_949 + 360.0f);
  } else {
    if (_949 > 180.0f) {
      _958 = (_949 + -360.0f);
    } else {
      _958 = _949;
    }
  }
  float _962 = saturate(1.0f - abs(_958 * 0.014814814552664757f));
  float _966 = (_962 * _962) * (3.0f - (_962 * 2.0f));
  float _972 = ((_966 * _966) * ((_871 * 0.18000000715255737f) * (0.029999999329447746f - _913))) + _913;
  float _982 = max(0.0f, mad(-0.21492856740951538f, _915, mad(-0.2365107536315918f, _914, (_972 * 1.4514392614364624f))));
  float _983 = max(0.0f, mad(-0.09967592358589172f, _915, mad(1.17622971534729f, _914, (_972 * -0.07655377686023712f))));
  float _984 = max(0.0f, mad(0.9977163076400757f, _915, mad(-0.006032449658960104f, _914, (_972 * 0.008316148072481155f))));
  float _985 = dot(float3(_982, _983, _984), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1000 = (cb0_038x + 1.0f) - cb0_037z;
  float _1002 = cb0_038y + 1.0f;
  float _1004 = _1002 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1022 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _1013 = (cb0_038x + 0.18000000715255737f) / _1000;
    _1022 = (-0.7447274923324585f - ((log2(_1013 / (2.0f - _1013)) * 0.3465735912322998f) * (_1000 / cb0_037y)));
  }
  float _1025 = ((1.0f - cb0_037z) / cb0_037y) - _1022;
  float _1027 = (cb0_037w / cb0_037y) - _1025;
  float _1031 = log2(lerp(_985, _982, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1032 = log2(lerp(_985, _983, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1033 = log2(lerp(_985, _984, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1037 = cb0_037y * (_1031 + _1025);
  float _1038 = cb0_037y * (_1032 + _1025);
  float _1039 = cb0_037y * (_1033 + _1025);
  float _1040 = _1000 * 2.0f;
  float _1042 = (cb0_037y * -2.0f) / _1000;
  float _1043 = _1031 - _1022;
  float _1044 = _1032 - _1022;
  float _1045 = _1033 - _1022;
  float _1064 = _1004 * 2.0f;
  float _1066 = (cb0_037y * 2.0f) / _1004;
  float _1091 = select((_1031 < _1022), ((_1040 / (exp2((_1043 * 1.4426950216293335f) * _1042) + 1.0f)) - cb0_038x), _1037);
  float _1092 = select((_1032 < _1022), ((_1040 / (exp2((_1044 * 1.4426950216293335f) * _1042) + 1.0f)) - cb0_038x), _1038);
  float _1093 = select((_1033 < _1022), ((_1040 / (exp2((_1045 * 1.4426950216293335f) * _1042) + 1.0f)) - cb0_038x), _1039);
  float _1100 = _1027 - _1022;
  float _1104 = saturate(_1043 / _1100);
  float _1105 = saturate(_1044 / _1100);
  float _1106 = saturate(_1045 / _1100);
  bool _1107 = (_1027 < _1022);
  float _1111 = select(_1107, (1.0f - _1104), _1104);
  float _1112 = select(_1107, (1.0f - _1105), _1105);
  float _1113 = select(_1107, (1.0f - _1106), _1106);
  float _1132 = (((_1111 * _1111) * (select((_1031 > _1027), (_1002 - (_1064 / (exp2(((_1031 - _1027) * 1.4426950216293335f) * _1066) + 1.0f))), _1037) - _1091)) * (3.0f - (_1111 * 2.0f))) + _1091;
  float _1133 = (((_1112 * _1112) * (select((_1032 > _1027), (_1002 - (_1064 / (exp2(((_1032 - _1027) * 1.4426950216293335f) * _1066) + 1.0f))), _1038) - _1092)) * (3.0f - (_1112 * 2.0f))) + _1092;
  float _1134 = (((_1113 * _1113) * (select((_1033 > _1027), (_1002 - (_1064 / (exp2(((_1033 - _1027) * 1.4426950216293335f) * _1066) + 1.0f))), _1039) - _1093)) * (3.0f - (_1113 * 2.0f))) + _1093;
  float _1135 = dot(float3(_1132, _1133, _1134), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1155 = (cb0_037x * (max(0.0f, (lerp(_1135, _1132, 0.9300000071525574f))) - _851)) + _851;
  float _1156 = (cb0_037x * (max(0.0f, (lerp(_1135, _1133, 0.9300000071525574f))) - _852)) + _852;
  float _1157 = (cb0_037x * (max(0.0f, (lerp(_1135, _1134, 0.9300000071525574f))) - _853)) + _853;
  float _1173 = ((mad(-0.06537103652954102f, _1157, mad(1.451815478503704e-06f, _1156, (_1155 * 1.065374732017517f))) - _1155) * cb0_036z) + _1155;
  float _1174 = ((mad(-0.20366770029067993f, _1157, mad(1.2036634683609009f, _1156, (_1155 * -2.57161445915699e-07f))) - _1156) * cb0_036z) + _1156;
  float _1175 = ((mad(0.9999996423721313f, _1157, mad(2.0954757928848267e-08f, _1156, (_1155 * 1.862645149230957e-08f))) - _1157) * cb0_036z) + _1157;
  float _1188 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1175, mad((WorkingColorSpace_192[0].y), _1174, ((WorkingColorSpace_192[0].x) * _1173)))));
  float _1189 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1175, mad((WorkingColorSpace_192[1].y), _1174, ((WorkingColorSpace_192[1].x) * _1173)))));
  float _1190 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1175, mad((WorkingColorSpace_192[2].y), _1174, ((WorkingColorSpace_192[2].x) * _1173)))));
  if (_1188 < 0.0031306699384003878f) {
    _1201 = (_1188 * 12.920000076293945f);
  } else {
    _1201 = (((pow(_1188, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1189 < 0.0031306699384003878f) {
    _1212 = (_1189 * 12.920000076293945f);
  } else {
    _1212 = (((pow(_1189, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1190 < 0.0031306699384003878f) {
    _1223 = (_1190 * 12.920000076293945f);
  } else {
    _1223 = (((pow(_1190, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1227 = (_1212 * 0.9375f) + 0.03125f;
  float _1234 = _1223 * 15.0f;
  float _1235 = floor(_1234);
  float _1236 = _1234 - _1235;
  float _1238 = (_1235 + ((_1201 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1241 = t0.SampleLevel(s0, float2(_1238, _1227), 0.0f);
  float _1245 = _1238 + 0.0625f;
  float4 _1246 = t0.SampleLevel(s0, float2(_1245, _1227), 0.0f);
  float4 _1268 = t1.SampleLevel(s1, float2(_1238, _1227), 0.0f);
  float4 _1272 = t1.SampleLevel(s1, float2(_1245, _1227), 0.0f);
  float4 _1294 = t2.SampleLevel(s2, float2(_1238, _1227), 0.0f);
  float4 _1298 = t2.SampleLevel(s2, float2(_1245, _1227), 0.0f);
  float _1317 = max(6.103519990574569e-05f, (((((lerp(_1241.x, _1246.x, _1236)) * cb0_005y) + (cb0_005x * _1201)) + ((lerp(_1268.x, _1272.x, _1236)) * cb0_005z)) + ((lerp(_1294.x, _1298.x, _1236)) * cb0_005w)));
  float _1318 = max(6.103519990574569e-05f, (((((lerp(_1241.y, _1246.y, _1236)) * cb0_005y) + (cb0_005x * _1212)) + ((lerp(_1268.y, _1272.y, _1236)) * cb0_005z)) + ((lerp(_1294.y, _1298.y, _1236)) * cb0_005w)));
  float _1319 = max(6.103519990574569e-05f, (((((lerp(_1241.z, _1246.z, _1236)) * cb0_005y) + (cb0_005x * _1223)) + ((lerp(_1268.z, _1272.z, _1236)) * cb0_005z)) + ((lerp(_1294.z, _1298.z, _1236)) * cb0_005w)));
  float _1341 = select((_1317 > 0.040449999272823334f), exp2(log2((_1317 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1317 * 0.07739938050508499f));
  float _1342 = select((_1318 > 0.040449999272823334f), exp2(log2((_1318 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1318 * 0.07739938050508499f));
  float _1343 = select((_1319 > 0.040449999272823334f), exp2(log2((_1319 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1319 * 0.07739938050508499f));
  float _1369 = cb0_014x * (((cb0_039y + (cb0_039x * _1341)) * _1341) + cb0_039z);
  float _1370 = cb0_014y * (((cb0_039y + (cb0_039x * _1342)) * _1342) + cb0_039z);
  float _1371 = cb0_014z * (((cb0_039y + (cb0_039x * _1343)) * _1343) + cb0_039z);
  float _1378 = ((cb0_013x - _1369) * cb0_013w) + _1369;
  float _1379 = ((cb0_013y - _1370) * cb0_013w) + _1370;
  float _1380 = ((cb0_013z - _1371) * cb0_013w) + _1371;
  float _1381 = cb0_014x * mad((WorkingColorSpace_192[0].z), _815, mad((WorkingColorSpace_192[0].y), _813, (_811 * (WorkingColorSpace_192[0].x))));
  float _1382 = cb0_014y * mad((WorkingColorSpace_192[1].z), _815, mad((WorkingColorSpace_192[1].y), _813, ((WorkingColorSpace_192[1].x) * _811)));
  float _1383 = cb0_014z * mad((WorkingColorSpace_192[2].z), _815, mad((WorkingColorSpace_192[2].y), _813, ((WorkingColorSpace_192[2].x) * _811)));
  float _1390 = ((cb0_013x - _1381) * cb0_013w) + _1381;
  float _1391 = ((cb0_013y - _1382) * cb0_013w) + _1382;
  float _1392 = ((cb0_013z - _1383) * cb0_013w) + _1383;
  float _1404 = exp2(log2(max(0.0f, _1378)) * cb0_040y);
  float _1405 = exp2(log2(max(0.0f, _1379)) * cb0_040y);
  float _1406 = exp2(log2(max(0.0f, _1380)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1429 = mad((WorkingColorSpace_128[0].z), _1406, mad((WorkingColorSpace_128[0].y), _1405, ((WorkingColorSpace_128[0].x) * _1404)));
        float _1432 = mad((WorkingColorSpace_128[1].z), _1406, mad((WorkingColorSpace_128[1].y), _1405, ((WorkingColorSpace_128[1].x) * _1404)));
        float _1435 = mad((WorkingColorSpace_128[2].z), _1406, mad((WorkingColorSpace_128[2].y), _1405, ((WorkingColorSpace_128[2].x) * _1404)));
        _1446 = mad(_69, _1435, mad(_68, _1432, (_1429 * _67)));
        _1447 = mad(_72, _1435, mad(_71, _1432, (_1429 * _70)));
        _1448 = mad(_75, _1435, mad(_74, _1432, (_1429 * _73)));
      } else {
        _1446 = _1404;
        _1447 = _1405;
        _1448 = _1406;
      }
      do {
        if (_1446 < 0.0031306699384003878f) {
          _1459 = (_1446 * 12.920000076293945f);
        } else {
          _1459 = (((pow(_1446, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1447 < 0.0031306699384003878f) {
            _1470 = (_1447 * 12.920000076293945f);
          } else {
            _1470 = (((pow(_1447, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1448 < 0.0031306699384003878f) {
            _3074 = _1459;
            _3075 = _1470;
            _3076 = (_1448 * 12.920000076293945f);
          } else {
            _3074 = _1459;
            _3075 = _1470;
            _3076 = (((pow(_1448, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1497 = mad((WorkingColorSpace_128[0].z), _1406, mad((WorkingColorSpace_128[0].y), _1405, ((WorkingColorSpace_128[0].x) * _1404)));
      float _1500 = mad((WorkingColorSpace_128[1].z), _1406, mad((WorkingColorSpace_128[1].y), _1405, ((WorkingColorSpace_128[1].x) * _1404)));
      float _1503 = mad((WorkingColorSpace_128[2].z), _1406, mad((WorkingColorSpace_128[2].y), _1405, ((WorkingColorSpace_128[2].x) * _1404)));
      float _1513 = max(6.103519990574569e-05f, mad(_69, _1503, mad(_68, _1500, (_1497 * _67))));
      float _1514 = max(6.103519990574569e-05f, mad(_72, _1503, mad(_71, _1500, (_1497 * _70))));
      float _1515 = max(6.103519990574569e-05f, mad(_75, _1503, mad(_74, _1500, (_1497 * _73))));
      _3074 = min((_1513 * 4.5f), ((exp2(log2(max(_1513, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3075 = min((_1514 * 4.5f), ((exp2(log2(max(_1514, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3076 = min((_1515 * 4.5f), ((exp2(log2(max(_1515, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1591 = cb0_012z * _1390;
        float _1592 = cb0_012z * _1391;
        float _1593 = cb0_012z * _1392;
        float _1596 = mad((WorkingColorSpace_256[0].z), _1593, mad((WorkingColorSpace_256[0].y), _1592, ((WorkingColorSpace_256[0].x) * _1591)));
        float _1599 = mad((WorkingColorSpace_256[1].z), _1593, mad((WorkingColorSpace_256[1].y), _1592, ((WorkingColorSpace_256[1].x) * _1591)));
        float _1602 = mad((WorkingColorSpace_256[2].z), _1593, mad((WorkingColorSpace_256[2].y), _1592, ((WorkingColorSpace_256[2].x) * _1591)));
        float _1605 = mad(-0.21492856740951538f, _1602, mad(-0.2365107536315918f, _1599, (_1596 * 1.4514392614364624f)));
        float _1608 = mad(-0.09967592358589172f, _1602, mad(1.17622971534729f, _1599, (_1596 * -0.07655377686023712f)));
        float _1611 = mad(0.9977163076400757f, _1602, mad(-0.006032449658960104f, _1599, (_1596 * 0.008316148072481155f)));
        float _1613 = max(_1605, max(_1608, _1611));
        do {
          if (!(_1613 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1596 < 0.0f) || (bool)(_1599 < 0.0f))) || (bool)(_1602 < 0.0f))) {
              float _1623 = abs(_1613);
              float _1624 = (_1613 - _1605) / _1623;
              float _1626 = (_1613 - _1608) / _1623;
              float _1628 = (_1613 - _1611) / _1623;
              do {
                if (!(_1624 < 0.8149999976158142f)) {
                  float _1631 = _1624 + -0.8149999976158142f;
                  _1643 = ((_1631 / exp2(log2(exp2(log2(_1631 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1643 = _1624;
                }
                do {
                  if (!(_1626 < 0.8029999732971191f)) {
                    float _1646 = _1626 + -0.8029999732971191f;
                    _1658 = ((_1646 / exp2(log2(exp2(log2(_1646 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1658 = _1626;
                  }
                  do {
                    if (!(_1628 < 0.8799999952316284f)) {
                      float _1661 = _1628 + -0.8799999952316284f;
                      _1673 = ((_1661 / exp2(log2(exp2(log2(_1661 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1673 = _1628;
                    }
                    _1681 = (_1613 - (_1623 * _1643));
                    _1682 = (_1613 - (_1623 * _1658));
                    _1683 = (_1613 - (_1623 * _1673));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1681 = _1605;
              _1682 = _1608;
              _1683 = _1611;
            }
          } else {
            _1681 = _1605;
            _1682 = _1608;
            _1683 = _1611;
          }
          float _1699 = ((mad(0.16386906802654266f, _1683, mad(0.14067870378494263f, _1682, (_1681 * 0.6954522132873535f))) - _1596) * cb0_012w) + _1596;
          float _1700 = ((mad(0.0955343171954155f, _1683, mad(0.8596711158752441f, _1682, (_1681 * 0.044794563204050064f))) - _1599) * cb0_012w) + _1599;
          float _1701 = ((mad(1.0015007257461548f, _1683, mad(0.004025210160762072f, _1682, (_1681 * -0.005525882821530104f))) - _1602) * cb0_012w) + _1602;
          float _1705 = max(max(_1699, _1700), _1701);
          float _1710 = (max(_1705, 1.000000013351432e-10f) - max(min(min(_1699, _1700), _1701), 1.000000013351432e-10f)) / max(_1705, 0.009999999776482582f);
          float _1723 = ((_1700 + _1699) + _1701) + (sqrt((((_1701 - _1700) * _1701) + ((_1700 - _1699) * _1700)) + ((_1699 - _1701) * _1699)) * 1.75f);
          float _1724 = _1723 * 0.3333333432674408f;
          float _1725 = _1710 + -0.4000000059604645f;
          float _1726 = _1725 * 5.0f;
          float _1730 = max((1.0f - abs(_1725 * 2.5f)), 0.0f);
          float _1741 = ((float((int)(((int)(uint)((bool)(_1726 > 0.0f))) - ((int)(uint)((bool)(_1726 < 0.0f))))) * (1.0f - (_1730 * _1730))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1724 <= 0.0533333346247673f)) {
              if (!(_1724 >= 0.1599999964237213f)) {
                _1750 = (((0.23999999463558197f / _1723) + -0.5f) * _1741);
              } else {
                _1750 = 0.0f;
              }
            } else {
              _1750 = _1741;
            }
            float _1751 = _1750 + 1.0f;
            float _1752 = _1751 * _1699;
            float _1753 = _1751 * _1700;
            float _1754 = _1751 * _1701;
            do {
              if (!((bool)(_1752 == _1753) && (bool)(_1753 == _1754))) {
                float _1761 = ((_1752 * 2.0f) - _1753) - _1754;
                float _1764 = ((_1700 - _1701) * 1.7320507764816284f) * _1751;
                float _1766 = atan(_1764 / _1761);
                bool _1769 = (_1761 < 0.0f);
                bool _1770 = (_1761 == 0.0f);
                bool _1771 = (_1764 >= 0.0f);
                bool _1772 = (_1764 < 0.0f);
                _1783 = select((_1771 && _1770), 90.0f, select((_1772 && _1770), -90.0f, (select((_1772 && _1769), (_1766 + -3.1415927410125732f), select((_1771 && _1769), (_1766 + 3.1415927410125732f), _1766)) * 57.2957763671875f)));
              } else {
                _1783 = 0.0f;
              }
              float _1788 = min(max(select((_1783 < 0.0f), (_1783 + 360.0f), _1783), 0.0f), 360.0f);
              do {
                if (_1788 < -180.0f) {
                  _1797 = (_1788 + 360.0f);
                } else {
                  if (_1788 > 180.0f) {
                    _1797 = (_1788 + -360.0f);
                  } else {
                    _1797 = _1788;
                  }
                }
                do {
                  if ((bool)(_1797 > -67.5f) && (bool)(_1797 < 67.5f)) {
                    float _1803 = (_1797 + 67.5f) * 0.029629629105329514f;
                    int _1804 = int(_1803);
                    float _1806 = _1803 - float((int)(_1804));
                    float _1807 = _1806 * _1806;
                    float _1808 = _1807 * _1806;
                    if (_1804 == 3) {
                      _1836 = (((0.1666666716337204f - (_1806 * 0.5f)) + (_1807 * 0.5f)) - (_1808 * 0.1666666716337204f));
                    } else {
                      if (_1804 == 2) {
                        _1836 = ((0.6666666865348816f - _1807) + (_1808 * 0.5f));
                      } else {
                        if (_1804 == 1) {
                          _1836 = (((_1808 * -0.5f) + 0.1666666716337204f) + ((_1807 + _1806) * 0.5f));
                        } else {
                          _1836 = select((_1804 == 0), (_1808 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1836 = 0.0f;
                  }
                  float _1845 = min(max(((((_1710 * 0.27000001072883606f) * (0.029999999329447746f - _1752)) * _1836) + _1752), 0.0f), 65535.0f);
                  float _1846 = min(max(_1753, 0.0f), 65535.0f);
                  float _1847 = min(max(_1754, 0.0f), 65535.0f);
                  float _1860 = min(max(mad(-0.21492856740951538f, _1847, mad(-0.2365107536315918f, _1846, (_1845 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1861 = min(max(mad(-0.09967592358589172f, _1847, mad(1.17622971534729f, _1846, (_1845 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1862 = min(max(mad(0.9977163076400757f, _1847, mad(-0.006032449658960104f, _1846, (_1845 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1863 = dot(float3(_1860, _1861, _1862), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1886 = log2(max((lerp(_1863, _1860, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1887 = _1886 * 0.3010300099849701f;
                  float _1888 = log2(cb0_008x);
                  float _1889 = _1888 * 0.3010300099849701f;
                  do {
                    if (!(!(_1887 <= _1889))) {
                      _1958 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1896 = log2(cb0_009x);
                      float _1897 = _1896 * 0.3010300099849701f;
                      if ((bool)(_1887 > _1889) && (bool)(_1887 < _1897)) {
                        float _1905 = ((_1886 - _1888) * 0.9030900001525879f) / ((_1896 - _1888) * 0.3010300099849701f);
                        int _1906 = int(_1905);
                        float _1908 = _1905 - float((int)(_1906));
                        float _1910 = _23[_1906];
                        float _1913 = _23[(_1906 + 1)];
                        float _1918 = _1910 * 0.5f;
                        _1958 = dot(float3((_1908 * _1908), _1908, 1.0f), float3(mad((_23[(_1906 + 2)]), 0.5f, mad(_1913, -1.0f, _1918)), (_1913 - _1910), mad(_1913, 0.5f, _1918)));
                      } else {
                        do {
                          if (!(!(_1887 >= _1897))) {
                            float _1927 = log2(cb0_008z);
                            if (_1887 < (_1927 * 0.3010300099849701f)) {
                              float _1935 = ((_1886 - _1896) * 0.9030900001525879f) / ((_1927 - _1896) * 0.3010300099849701f);
                              int _1936 = int(_1935);
                              float _1938 = _1935 - float((int)(_1936));
                              float _1940 = _24[_1936];
                              float _1943 = _24[(_1936 + 1)];
                              float _1948 = _1940 * 0.5f;
                              _1958 = dot(float3((_1938 * _1938), _1938, 1.0f), float3(mad((_24[(_1936 + 2)]), 0.5f, mad(_1943, -1.0f, _1948)), (_1943 - _1940), mad(_1943, 0.5f, _1948)));
                              break;
                            }
                          }
                          _1958 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
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
                    float _1974 = log2(max((lerp(_1863, _1861, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1975 = _1974 * 0.3010300099849701f;
                    do {
                      if (!(!(_1975 <= _1889))) {
                        _2044 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1982 = log2(cb0_009x);
                        float _1983 = _1982 * 0.3010300099849701f;
                        if ((bool)(_1975 > _1889) && (bool)(_1975 < _1983)) {
                          float _1991 = ((_1974 - _1888) * 0.9030900001525879f) / ((_1982 - _1888) * 0.3010300099849701f);
                          int _1992 = int(_1991);
                          float _1994 = _1991 - float((int)(_1992));
                          float _1996 = _25[_1992];
                          float _1999 = _25[(_1992 + 1)];
                          float _2004 = _1996 * 0.5f;
                          _2044 = dot(float3((_1994 * _1994), _1994, 1.0f), float3(mad((_25[(_1992 + 2)]), 0.5f, mad(_1999, -1.0f, _2004)), (_1999 - _1996), mad(_1999, 0.5f, _2004)));
                        } else {
                          do {
                            if (!(!(_1975 >= _1983))) {
                              float _2013 = log2(cb0_008z);
                              if (_1975 < (_2013 * 0.3010300099849701f)) {
                                float _2021 = ((_1974 - _1982) * 0.9030900001525879f) / ((_2013 - _1982) * 0.3010300099849701f);
                                int _2022 = int(_2021);
                                float _2024 = _2021 - float((int)(_2022));
                                float _2026 = _26[_2022];
                                float _2029 = _26[(_2022 + 1)];
                                float _2034 = _2026 * 0.5f;
                                _2044 = dot(float3((_2024 * _2024), _2024, 1.0f), float3(mad((_26[(_2022 + 2)]), 0.5f, mad(_2029, -1.0f, _2034)), (_2029 - _2026), mad(_2029, 0.5f, _2034)));
                                break;
                              }
                            }
                            _2044 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2048 = log2(max((lerp(_1863, _1862, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2049 = _2048 * 0.3010300099849701f;
                      do {
                        if (!(!(_2049 <= _1889))) {
                          _2118 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2056 = log2(cb0_009x);
                          float _2057 = _2056 * 0.3010300099849701f;
                          if ((bool)(_2049 > _1889) && (bool)(_2049 < _2057)) {
                            float _2065 = ((_2048 - _1888) * 0.9030900001525879f) / ((_2056 - _1888) * 0.3010300099849701f);
                            int _2066 = int(_2065);
                            float _2068 = _2065 - float((int)(_2066));
                            float _2070 = _15[_2066];
                            float _2073 = _15[(_2066 + 1)];
                            float _2078 = _2070 * 0.5f;
                            _2118 = dot(float3((_2068 * _2068), _2068, 1.0f), float3(mad((_15[(_2066 + 2)]), 0.5f, mad(_2073, -1.0f, _2078)), (_2073 - _2070), mad(_2073, 0.5f, _2078)));
                          } else {
                            do {
                              if (!(!(_2049 >= _2057))) {
                                float _2087 = log2(cb0_008z);
                                if (_2049 < (_2087 * 0.3010300099849701f)) {
                                  float _2095 = ((_2048 - _2056) * 0.9030900001525879f) / ((_2087 - _2056) * 0.3010300099849701f);
                                  int _2096 = int(_2095);
                                  float _2098 = _2095 - float((int)(_2096));
                                  float _2100 = _16[_2096];
                                  float _2103 = _16[(_2096 + 1)];
                                  float _2108 = _2100 * 0.5f;
                                  _2118 = dot(float3((_2098 * _2098), _2098, 1.0f), float3(mad((_16[(_2096 + 2)]), 0.5f, mad(_2103, -1.0f, _2108)), (_2103 - _2100), mad(_2103, 0.5f, _2108)));
                                  break;
                                }
                              }
                              _2118 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2122 = cb0_008w - cb0_008y;
                        float _2123 = (exp2(_1958 * 3.321928024291992f) - cb0_008y) / _2122;
                        float _2125 = (exp2(_2044 * 3.321928024291992f) - cb0_008y) / _2122;
                        float _2127 = (exp2(_2118 * 3.321928024291992f) - cb0_008y) / _2122;
                        float _2130 = mad(0.15618768334388733f, _2127, mad(0.13400420546531677f, _2125, (_2123 * 0.6624541878700256f)));
                        float _2133 = mad(0.053689517080783844f, _2127, mad(0.6740817427635193f, _2125, (_2123 * 0.2722287178039551f)));
                        float _2136 = mad(1.0103391408920288f, _2127, mad(0.00406073359772563f, _2125, (_2123 * -0.005574649665504694f)));
                        float _2149 = min(max(mad(-0.23642469942569733f, _2136, mad(-0.32480329275131226f, _2133, (_2130 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2150 = min(max(mad(0.016756348311901093f, _2136, mad(1.6153316497802734f, _2133, (_2130 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2151 = min(max(mad(0.9883948564529419f, _2136, mad(-0.008284442126750946f, _2133, (_2130 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2154 = mad(0.15618768334388733f, _2151, mad(0.13400420546531677f, _2150, (_2149 * 0.6624541878700256f)));
                        float _2157 = mad(0.053689517080783844f, _2151, mad(0.6740817427635193f, _2150, (_2149 * 0.2722287178039551f)));
                        float _2160 = mad(1.0103391408920288f, _2151, mad(0.00406073359772563f, _2150, (_2149 * -0.005574649665504694f)));
                        float _2182 = min(max((min(max(mad(-0.23642469942569733f, _2160, mad(-0.32480329275131226f, _2157, (_2154 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2183 = min(max((min(max(mad(0.016756348311901093f, _2160, mad(1.6153316497802734f, _2157, (_2154 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2184 = min(max((min(max(mad(0.9883948564529419f, _2160, mad(-0.008284442126750946f, _2157, (_2154 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _2197 = mad(_69, _2184, mad(_68, _2183, (_2182 * _67)));
                            _2198 = mad(_72, _2184, mad(_71, _2183, (_2182 * _70)));
                            _2199 = mad(_75, _2184, mad(_74, _2183, (_2182 * _73)));
                          } else {
                            _2197 = _2182;
                            _2198 = _2183;
                            _2199 = _2184;
                          }
                          float _2209 = exp2(log2(_2197 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2210 = exp2(log2(_2198 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2211 = exp2(log2(_2199 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3074 = exp2(log2((1.0f / ((_2209 * 18.6875f) + 1.0f)) * ((_2209 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3075 = exp2(log2((1.0f / ((_2210 * 18.6875f) + 1.0f)) * ((_2210 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3076 = exp2(log2((1.0f / ((_2211 * 18.6875f) + 1.0f)) * ((_2211 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2277 = cb0_012z * _1390;
          float _2278 = cb0_012z * _1391;
          float _2279 = cb0_012z * _1392;
          float _2282 = mad((WorkingColorSpace_256[0].z), _2279, mad((WorkingColorSpace_256[0].y), _2278, ((WorkingColorSpace_256[0].x) * _2277)));
          float _2285 = mad((WorkingColorSpace_256[1].z), _2279, mad((WorkingColorSpace_256[1].y), _2278, ((WorkingColorSpace_256[1].x) * _2277)));
          float _2288 = mad((WorkingColorSpace_256[2].z), _2279, mad((WorkingColorSpace_256[2].y), _2278, ((WorkingColorSpace_256[2].x) * _2277)));
          float _2291 = mad(-0.21492856740951538f, _2288, mad(-0.2365107536315918f, _2285, (_2282 * 1.4514392614364624f)));
          float _2294 = mad(-0.09967592358589172f, _2288, mad(1.17622971534729f, _2285, (_2282 * -0.07655377686023712f)));
          float _2297 = mad(0.9977163076400757f, _2288, mad(-0.006032449658960104f, _2285, (_2282 * 0.008316148072481155f)));
          float _2299 = max(_2291, max(_2294, _2297));
          do {
            if (!(_2299 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2282 < 0.0f) || (bool)(_2285 < 0.0f))) || (bool)(_2288 < 0.0f))) {
                float _2309 = abs(_2299);
                float _2310 = (_2299 - _2291) / _2309;
                float _2312 = (_2299 - _2294) / _2309;
                float _2314 = (_2299 - _2297) / _2309;
                do {
                  if (!(_2310 < 0.8149999976158142f)) {
                    float _2317 = _2310 + -0.8149999976158142f;
                    _2329 = ((_2317 / exp2(log2(exp2(log2(_2317 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2329 = _2310;
                  }
                  do {
                    if (!(_2312 < 0.8029999732971191f)) {
                      float _2332 = _2312 + -0.8029999732971191f;
                      _2344 = ((_2332 / exp2(log2(exp2(log2(_2332 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2344 = _2312;
                    }
                    do {
                      if (!(_2314 < 0.8799999952316284f)) {
                        float _2347 = _2314 + -0.8799999952316284f;
                        _2359 = ((_2347 / exp2(log2(exp2(log2(_2347 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2359 = _2314;
                      }
                      _2367 = (_2299 - (_2309 * _2329));
                      _2368 = (_2299 - (_2309 * _2344));
                      _2369 = (_2299 - (_2309 * _2359));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2367 = _2291;
                _2368 = _2294;
                _2369 = _2297;
              }
            } else {
              _2367 = _2291;
              _2368 = _2294;
              _2369 = _2297;
            }
            float _2385 = ((mad(0.16386906802654266f, _2369, mad(0.14067870378494263f, _2368, (_2367 * 0.6954522132873535f))) - _2282) * cb0_012w) + _2282;
            float _2386 = ((mad(0.0955343171954155f, _2369, mad(0.8596711158752441f, _2368, (_2367 * 0.044794563204050064f))) - _2285) * cb0_012w) + _2285;
            float _2387 = ((mad(1.0015007257461548f, _2369, mad(0.004025210160762072f, _2368, (_2367 * -0.005525882821530104f))) - _2288) * cb0_012w) + _2288;
            float _2391 = max(max(_2385, _2386), _2387);
            float _2396 = (max(_2391, 1.000000013351432e-10f) - max(min(min(_2385, _2386), _2387), 1.000000013351432e-10f)) / max(_2391, 0.009999999776482582f);
            float _2409 = ((_2386 + _2385) + _2387) + (sqrt((((_2387 - _2386) * _2387) + ((_2386 - _2385) * _2386)) + ((_2385 - _2387) * _2385)) * 1.75f);
            float _2410 = _2409 * 0.3333333432674408f;
            float _2411 = _2396 + -0.4000000059604645f;
            float _2412 = _2411 * 5.0f;
            float _2416 = max((1.0f - abs(_2411 * 2.5f)), 0.0f);
            float _2427 = ((float((int)(((int)(uint)((bool)(_2412 > 0.0f))) - ((int)(uint)((bool)(_2412 < 0.0f))))) * (1.0f - (_2416 * _2416))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2410 <= 0.0533333346247673f)) {
                if (!(_2410 >= 0.1599999964237213f)) {
                  _2436 = (((0.23999999463558197f / _2409) + -0.5f) * _2427);
                } else {
                  _2436 = 0.0f;
                }
              } else {
                _2436 = _2427;
              }
              float _2437 = _2436 + 1.0f;
              float _2438 = _2437 * _2385;
              float _2439 = _2437 * _2386;
              float _2440 = _2437 * _2387;
              do {
                if (!((bool)(_2438 == _2439) && (bool)(_2439 == _2440))) {
                  float _2447 = ((_2438 * 2.0f) - _2439) - _2440;
                  float _2450 = ((_2386 - _2387) * 1.7320507764816284f) * _2437;
                  float _2452 = atan(_2450 / _2447);
                  bool _2455 = (_2447 < 0.0f);
                  bool _2456 = (_2447 == 0.0f);
                  bool _2457 = (_2450 >= 0.0f);
                  bool _2458 = (_2450 < 0.0f);
                  _2469 = select((_2457 && _2456), 90.0f, select((_2458 && _2456), -90.0f, (select((_2458 && _2455), (_2452 + -3.1415927410125732f), select((_2457 && _2455), (_2452 + 3.1415927410125732f), _2452)) * 57.2957763671875f)));
                } else {
                  _2469 = 0.0f;
                }
                float _2474 = min(max(select((_2469 < 0.0f), (_2469 + 360.0f), _2469), 0.0f), 360.0f);
                do {
                  if (_2474 < -180.0f) {
                    _2483 = (_2474 + 360.0f);
                  } else {
                    if (_2474 > 180.0f) {
                      _2483 = (_2474 + -360.0f);
                    } else {
                      _2483 = _2474;
                    }
                  }
                  do {
                    if ((bool)(_2483 > -67.5f) && (bool)(_2483 < 67.5f)) {
                      float _2489 = (_2483 + 67.5f) * 0.029629629105329514f;
                      int _2490 = int(_2489);
                      float _2492 = _2489 - float((int)(_2490));
                      float _2493 = _2492 * _2492;
                      float _2494 = _2493 * _2492;
                      if (_2490 == 3) {
                        _2522 = (((0.1666666716337204f - (_2492 * 0.5f)) + (_2493 * 0.5f)) - (_2494 * 0.1666666716337204f));
                      } else {
                        if (_2490 == 2) {
                          _2522 = ((0.6666666865348816f - _2493) + (_2494 * 0.5f));
                        } else {
                          if (_2490 == 1) {
                            _2522 = (((_2494 * -0.5f) + 0.1666666716337204f) + ((_2493 + _2492) * 0.5f));
                          } else {
                            _2522 = select((_2490 == 0), (_2494 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2522 = 0.0f;
                    }
                    float _2531 = min(max(((((_2396 * 0.27000001072883606f) * (0.029999999329447746f - _2438)) * _2522) + _2438), 0.0f), 65535.0f);
                    float _2532 = min(max(_2439, 0.0f), 65535.0f);
                    float _2533 = min(max(_2440, 0.0f), 65535.0f);
                    float _2546 = min(max(mad(-0.21492856740951538f, _2533, mad(-0.2365107536315918f, _2532, (_2531 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2547 = min(max(mad(-0.09967592358589172f, _2533, mad(1.17622971534729f, _2532, (_2531 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2548 = min(max(mad(0.9977163076400757f, _2533, mad(-0.006032449658960104f, _2532, (_2531 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2549 = dot(float3(_2546, _2547, _2548), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2572 = log2(max((lerp(_2549, _2546, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2573 = _2572 * 0.3010300099849701f;
                    float _2574 = log2(cb0_008x);
                    float _2575 = _2574 * 0.3010300099849701f;
                    do {
                      if (!(!(_2573 <= _2575))) {
                        _2644 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2582 = log2(cb0_009x);
                        float _2583 = _2582 * 0.3010300099849701f;
                        if ((bool)(_2573 > _2575) && (bool)(_2573 < _2583)) {
                          float _2591 = ((_2572 - _2574) * 0.9030900001525879f) / ((_2582 - _2574) * 0.3010300099849701f);
                          int _2592 = int(_2591);
                          float _2594 = _2591 - float((int)(_2592));
                          float _2596 = _21[_2592];
                          float _2599 = _21[(_2592 + 1)];
                          float _2604 = _2596 * 0.5f;
                          _2644 = dot(float3((_2594 * _2594), _2594, 1.0f), float3(mad((_21[(_2592 + 2)]), 0.5f, mad(_2599, -1.0f, _2604)), (_2599 - _2596), mad(_2599, 0.5f, _2604)));
                        } else {
                          do {
                            if (!(!(_2573 >= _2583))) {
                              float _2613 = log2(cb0_008z);
                              if (_2573 < (_2613 * 0.3010300099849701f)) {
                                float _2621 = ((_2572 - _2582) * 0.9030900001525879f) / ((_2613 - _2582) * 0.3010300099849701f);
                                int _2622 = int(_2621);
                                float _2624 = _2621 - float((int)(_2622));
                                float _2626 = _22[_2622];
                                float _2629 = _22[(_2622 + 1)];
                                float _2634 = _2626 * 0.5f;
                                _2644 = dot(float3((_2624 * _2624), _2624, 1.0f), float3(mad((_22[(_2622 + 2)]), 0.5f, mad(_2629, -1.0f, _2634)), (_2629 - _2626), mad(_2629, 0.5f, _2634)));
                                break;
                              }
                            }
                            _2644 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2660 = log2(max((lerp(_2549, _2547, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2661 = _2660 * 0.3010300099849701f;
                      do {
                        if (!(!(_2661 <= _2575))) {
                          _2730 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2668 = log2(cb0_009x);
                          float _2669 = _2668 * 0.3010300099849701f;
                          if ((bool)(_2661 > _2575) && (bool)(_2661 < _2669)) {
                            float _2677 = ((_2660 - _2574) * 0.9030900001525879f) / ((_2668 - _2574) * 0.3010300099849701f);
                            int _2678 = int(_2677);
                            float _2680 = _2677 - float((int)(_2678));
                            float _2682 = _17[_2678];
                            float _2685 = _17[(_2678 + 1)];
                            float _2690 = _2682 * 0.5f;
                            _2730 = dot(float3((_2680 * _2680), _2680, 1.0f), float3(mad((_17[(_2678 + 2)]), 0.5f, mad(_2685, -1.0f, _2690)), (_2685 - _2682), mad(_2685, 0.5f, _2690)));
                          } else {
                            do {
                              if (!(!(_2661 >= _2669))) {
                                float _2699 = log2(cb0_008z);
                                if (_2661 < (_2699 * 0.3010300099849701f)) {
                                  float _2707 = ((_2660 - _2668) * 0.9030900001525879f) / ((_2699 - _2668) * 0.3010300099849701f);
                                  int _2708 = int(_2707);
                                  float _2710 = _2707 - float((int)(_2708));
                                  float _2712 = _18[_2708];
                                  float _2715 = _18[(_2708 + 1)];
                                  float _2720 = _2712 * 0.5f;
                                  _2730 = dot(float3((_2710 * _2710), _2710, 1.0f), float3(mad((_18[(_2708 + 2)]), 0.5f, mad(_2715, -1.0f, _2720)), (_2715 - _2712), mad(_2715, 0.5f, _2720)));
                                  break;
                                }
                              }
                              _2730 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2746 = log2(max((lerp(_2549, _2548, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2747 = _2746 * 0.3010300099849701f;
                        do {
                          if (!(!(_2747 <= _2575))) {
                            _2816 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2754 = log2(cb0_009x);
                            float _2755 = _2754 * 0.3010300099849701f;
                            if ((bool)(_2747 > _2575) && (bool)(_2747 < _2755)) {
                              float _2763 = ((_2746 - _2574) * 0.9030900001525879f) / ((_2754 - _2574) * 0.3010300099849701f);
                              int _2764 = int(_2763);
                              float _2766 = _2763 - float((int)(_2764));
                              float _2768 = _19[_2764];
                              float _2771 = _19[(_2764 + 1)];
                              float _2776 = _2768 * 0.5f;
                              _2816 = dot(float3((_2766 * _2766), _2766, 1.0f), float3(mad((_19[(_2764 + 2)]), 0.5f, mad(_2771, -1.0f, _2776)), (_2771 - _2768), mad(_2771, 0.5f, _2776)));
                            } else {
                              do {
                                if (!(!(_2747 >= _2755))) {
                                  float _2785 = log2(cb0_008z);
                                  if (_2747 < (_2785 * 0.3010300099849701f)) {
                                    float _2793 = ((_2746 - _2754) * 0.9030900001525879f) / ((_2785 - _2754) * 0.3010300099849701f);
                                    int _2794 = int(_2793);
                                    float _2796 = _2793 - float((int)(_2794));
                                    float _2798 = _20[_2794];
                                    float _2801 = _20[(_2794 + 1)];
                                    float _2806 = _2798 * 0.5f;
                                    _2816 = dot(float3((_2796 * _2796), _2796, 1.0f), float3(mad((_20[(_2794 + 2)]), 0.5f, mad(_2801, -1.0f, _2806)), (_2801 - _2798), mad(_2801, 0.5f, _2806)));
                                    break;
                                  }
                                }
                                _2816 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2820 = cb0_008w - cb0_008y;
                          float _2821 = (exp2(_2644 * 3.321928024291992f) - cb0_008y) / _2820;
                          float _2823 = (exp2(_2730 * 3.321928024291992f) - cb0_008y) / _2820;
                          float _2825 = (exp2(_2816 * 3.321928024291992f) - cb0_008y) / _2820;
                          float _2828 = mad(0.15618768334388733f, _2825, mad(0.13400420546531677f, _2823, (_2821 * 0.6624541878700256f)));
                          float _2831 = mad(0.053689517080783844f, _2825, mad(0.6740817427635193f, _2823, (_2821 * 0.2722287178039551f)));
                          float _2834 = mad(1.0103391408920288f, _2825, mad(0.00406073359772563f, _2823, (_2821 * -0.005574649665504694f)));
                          float _2847 = min(max(mad(-0.23642469942569733f, _2834, mad(-0.32480329275131226f, _2831, (_2828 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2848 = min(max(mad(0.016756348311901093f, _2834, mad(1.6153316497802734f, _2831, (_2828 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2849 = min(max(mad(0.9883948564529419f, _2834, mad(-0.008284442126750946f, _2831, (_2828 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2852 = mad(0.15618768334388733f, _2849, mad(0.13400420546531677f, _2848, (_2847 * 0.6624541878700256f)));
                          float _2855 = mad(0.053689517080783844f, _2849, mad(0.6740817427635193f, _2848, (_2847 * 0.2722287178039551f)));
                          float _2858 = mad(1.0103391408920288f, _2849, mad(0.00406073359772563f, _2848, (_2847 * -0.005574649665504694f)));
                          float _2880 = min(max((min(max(mad(-0.23642469942569733f, _2858, mad(-0.32480329275131226f, _2855, (_2852 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2881 = min(max((min(max(mad(0.016756348311901093f, _2858, mad(1.6153316497802734f, _2855, (_2852 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2882 = min(max((min(max(mad(0.9883948564529419f, _2858, mad(-0.008284442126750946f, _2855, (_2852 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2895 = mad(_69, _2882, mad(_68, _2881, (_2880 * _67)));
                              _2896 = mad(_72, _2882, mad(_71, _2881, (_2880 * _70)));
                              _2897 = mad(_75, _2882, mad(_74, _2881, (_2880 * _73)));
                            } else {
                              _2895 = _2880;
                              _2896 = _2881;
                              _2897 = _2882;
                            }
                            float _2907 = exp2(log2(_2895 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2908 = exp2(log2(_2896 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2909 = exp2(log2(_2897 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _3074 = exp2(log2((1.0f / ((_2907 * 18.6875f) + 1.0f)) * ((_2907 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3075 = exp2(log2((1.0f / ((_2908 * 18.6875f) + 1.0f)) * ((_2908 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3076 = exp2(log2((1.0f / ((_2909 * 18.6875f) + 1.0f)) * ((_2909 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2954 = mad((WorkingColorSpace_128[0].z), _1392, mad((WorkingColorSpace_128[0].y), _1391, ((WorkingColorSpace_128[0].x) * _1390)));
            float _2957 = mad((WorkingColorSpace_128[1].z), _1392, mad((WorkingColorSpace_128[1].y), _1391, ((WorkingColorSpace_128[1].x) * _1390)));
            float _2960 = mad((WorkingColorSpace_128[2].z), _1392, mad((WorkingColorSpace_128[2].y), _1391, ((WorkingColorSpace_128[2].x) * _1390)));
            float _2979 = exp2(log2(mad(_69, _2960, mad(_68, _2957, (_2954 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2980 = exp2(log2(mad(_72, _2960, mad(_71, _2957, (_2954 * _70))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2981 = exp2(log2(mad(_75, _2960, mad(_74, _2957, (_2954 * _73))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3074 = exp2(log2((1.0f / ((_2979 * 18.6875f) + 1.0f)) * ((_2979 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3075 = exp2(log2((1.0f / ((_2980 * 18.6875f) + 1.0f)) * ((_2980 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3076 = exp2(log2((1.0f / ((_2981 * 18.6875f) + 1.0f)) * ((_2981 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _3028 = mad((WorkingColorSpace_128[0].z), _1380, mad((WorkingColorSpace_128[0].y), _1379, ((WorkingColorSpace_128[0].x) * _1378)));
                float _3031 = mad((WorkingColorSpace_128[1].z), _1380, mad((WorkingColorSpace_128[1].y), _1379, ((WorkingColorSpace_128[1].x) * _1378)));
                float _3034 = mad((WorkingColorSpace_128[2].z), _1380, mad((WorkingColorSpace_128[2].y), _1379, ((WorkingColorSpace_128[2].x) * _1378)));
                _3074 = mad(_69, _3034, mad(_68, _3031, (_3028 * _67)));
                _3075 = mad(_72, _3034, mad(_71, _3031, (_3028 * _70)));
                _3076 = mad(_75, _3034, mad(_74, _3031, (_3028 * _73)));
              } else {
                float _3047 = mad((WorkingColorSpace_128[0].z), _1406, mad((WorkingColorSpace_128[0].y), _1405, ((WorkingColorSpace_128[0].x) * _1404)));
                float _3050 = mad((WorkingColorSpace_128[1].z), _1406, mad((WorkingColorSpace_128[1].y), _1405, ((WorkingColorSpace_128[1].x) * _1404)));
                float _3053 = mad((WorkingColorSpace_128[2].z), _1406, mad((WorkingColorSpace_128[2].y), _1405, ((WorkingColorSpace_128[2].x) * _1404)));
                _3074 = exp2(log2(mad(_69, _3053, mad(_68, _3050, (_3047 * _67)))) * cb0_040z);
                _3075 = exp2(log2(mad(_72, _3053, mad(_71, _3050, (_3047 * _70)))) * cb0_040z);
                _3076 = exp2(log2(mad(_75, _3053, mad(_74, _3050, (_3047 * _73)))) * cb0_040z);
              }
            } else {
              _3074 = _1390;
              _3075 = _1391;
              _3076 = _1392;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_3074 * 0.9523810148239136f), (_3075 * 0.9523810148239136f), (_3076 * 0.9523810148239136f), 0.0f);
}
