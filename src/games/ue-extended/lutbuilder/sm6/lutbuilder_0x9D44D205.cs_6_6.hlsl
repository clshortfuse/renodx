// High on Life 2, UE 5.5

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
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
  float _23[6];
  float _35 = 0.5f / cb0_035x;
  float _40 = cb0_035x + -1.0f;
  float _41 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _35)) / _40;
  float _42 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _35)) / _40;
  float _44 = float((uint)SV_DispatchThreadID.z) / _40;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _130;
  float _131;
  float _132;
  float _180;
  float _908;
  float _941;
  float _955;
  float _1019;
  float _1198;
  float _1209;
  float _1220;
  float _1417;
  float _1418;
  float _1419;
  float _1430;
  float _1441;
  float _1614;
  float _1629;
  float _1644;
  float _1652;
  float _1653;
  float _1654;
  float _1721;
  float _1754;
  float _1768;
  float _1807;
  float _1929;
  float _2009;
  float _2083;
  float _2162;
  float _2163;
  float _2164;
  float _2294;
  float _2309;
  float _2324;
  float _2332;
  float _2333;
  float _2334;
  float _2401;
  float _2434;
  float _2448;
  float _2487;
  float _2609;
  float _2695;
  float _2781;
  float _2860;
  float _2861;
  float _2862;
  float _3039;
  float _3040;
  float _3041;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _53 = (cb0_041x == 4);
        _64 = select(_53, 1.0f, 1.705051064491272f);
        _65 = select(_53, 0.0f, -0.6217921376228333f);
        _66 = select(_53, 0.0f, -0.0832589864730835f);
        _67 = select(_53, 0.0f, -0.13025647401809692f);
        _68 = select(_53, 1.0f, 1.140804648399353f);
        _69 = select(_53, 0.0f, -0.010548308491706848f);
        _70 = select(_53, 0.0f, -0.024003351107239723f);
        _71 = select(_53, 0.0f, -0.1289689838886261f);
        _72 = select(_53, 1.0f, 1.1529725790023804f);
      } else {
        _64 = 0.6954522132873535f;
        _65 = 0.14067870378494263f;
        _66 = 0.16386906802654266f;
        _67 = 0.044794563204050064f;
        _68 = 0.8596711158752441f;
        _69 = 0.0955343171954155f;
        _70 = -0.005525882821530104f;
        _71 = 0.004025210160762072f;
        _72 = 1.0015007257461548f;
      }
    } else {
      _64 = 1.0258246660232544f;
      _65 = -0.020053181797266006f;
      _66 = -0.005771636962890625f;
      _67 = -0.002234415616840124f;
      _68 = 1.0045864582061768f;
      _69 = -0.002352118492126465f;
      _70 = -0.005013350863009691f;
      _71 = -0.025290070101618767f;
      _72 = 1.0303035974502563f;
    }
  } else {
    _64 = 1.3792141675949097f;
    _65 = -0.30886411666870117f;
    _66 = -0.0703500509262085f;
    _67 = -0.06933490186929703f;
    _68 = 1.08229660987854f;
    _69 = -0.012961871922016144f;
    _70 = -0.0021590073592960835f;
    _71 = -0.0454593189060688f;
    _72 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _83 = (pow(_41, 0.012683313339948654f));
    float _84 = (pow(_42, 0.012683313339948654f));
    float _85 = (pow(_44, 0.012683313339948654f));
    _130 = (exp2(log2(max(0.0f, (_83 + -0.8359375f)) / (18.8515625f - (_83 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _131 = (exp2(log2(max(0.0f, (_84 + -0.8359375f)) / (18.8515625f - (_84 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _132 = (exp2(log2(max(0.0f, (_85 + -0.8359375f)) / (18.8515625f - (_85 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _130 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _131 = ((exp2((_42 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _132 = ((exp2((_44 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _159 = (cb0_038w != 0);
  float _163 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _180 = (((((2967800.0f - (_163 * 4607000064.0f)) * _163) + 99.11000061035156f) * _163) + 0.24406300485134125f);
  } else {
    _180 = (((((1901800.0f - (_163 * 2006400000.0f)) * _163) + 247.47999572753906f) * _163) + 0.23703999817371368f);
  }
  float _194 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  float _201 = cb0_035y * cb0_035y;
  float _204 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_201 * 1.6145605741257896e-07f));
  float _209 = ((_194 * 2.0f) + 4.0f) - (_204 * 8.0f);
  float _210 = (_194 * 3.0f) / _209;
  float _212 = (_204 * 2.0f) / _209;
  bool _213 = (cb0_035y < 4000.0f);
  float _222 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  float _224 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_201 * 1.5317699909210205f)) / (_222 * _222);
  float _231 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _201;
  float _233 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_201 * 308.60699462890625f)) / (_231 * _231);
  float _235 = rsqrt(dot(float2(_224, _233), float2(_224, _233)));
  float _236 = cb0_035z * 0.05000000074505806f;
  float _239 = ((_236 * _233) * _235) + _194;
  float _242 = _204 - ((_236 * _224) * _235);
  float _247 = (4.0f - (_242 * 8.0f)) + (_239 * 2.0f);
  float _253 = (((_239 * 3.0f) / _247) - _210) + select(_213, _210, _180);
  float _254 = (((_242 * 2.0f) / _247) - _212) + select(_213, _212, (((_180 * 2.869999885559082f) + -0.2750000059604645f) - ((_180 * _180) * 3.0f)));
  float _255 = select(_159, _253, 0.3127000033855438f);
  float _256 = select(_159, _254, 0.32899999618530273f);
  float _257 = select(_159, 0.3127000033855438f, _253);
  float _258 = select(_159, 0.32899999618530273f, _254);
  float _259 = max(_256, 1.000000013351432e-10f);
  float _260 = _255 / _259;
  float _263 = ((1.0f - _255) - _256) / _259;
  float _264 = max(_258, 1.000000013351432e-10f);
  float _265 = _257 / _264;
  float _268 = ((1.0f - _257) - _258) / _264;
  float _287 = mad(-0.16140000522136688f, _268, ((_265 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _263, ((_260 * 0.8950999975204468f) + 0.266400009393692f));
  float _288 = mad(0.03669999912381172f, _268, (1.7135000228881836f - (_265 * 0.7501999735832214f))) / mad(0.03669999912381172f, _263, (1.7135000228881836f - (_260 * 0.7501999735832214f)));
  float _289 = mad(1.0296000242233276f, _268, ((_265 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _263, ((_260 * 0.03889999911189079f) + -0.06849999725818634f));
  float _290 = mad(_288, -0.7501999735832214f, 0.0f);
  float _291 = mad(_288, 1.7135000228881836f, 0.0f);
  float _292 = mad(_288, 0.03669999912381172f, -0.0f);
  float _293 = mad(_289, 0.03889999911189079f, 0.0f);
  float _294 = mad(_289, -0.06849999725818634f, 0.0f);
  float _295 = mad(_289, 1.0296000242233276f, 0.0f);
  float _298 = mad(0.1599626988172531f, _293, mad(-0.1470542997121811f, _290, (_287 * 0.883457362651825f)));
  float _301 = mad(0.1599626988172531f, _294, mad(-0.1470542997121811f, _291, (_287 * 0.26293492317199707f)));
  float _304 = mad(0.1599626988172531f, _295, mad(-0.1470542997121811f, _292, (_287 * -0.15930065512657166f)));
  float _307 = mad(0.04929120093584061f, _293, mad(0.5183603167533875f, _290, (_287 * 0.38695648312568665f)));
  float _310 = mad(0.04929120093584061f, _294, mad(0.5183603167533875f, _291, (_287 * 0.11516613513231277f)));
  float _313 = mad(0.04929120093584061f, _295, mad(0.5183603167533875f, _292, (_287 * -0.0697740763425827f)));
  float _316 = mad(0.9684867262840271f, _293, mad(0.04004279896616936f, _290, (_287 * -0.007634039502590895f)));
  float _319 = mad(0.9684867262840271f, _294, mad(0.04004279896616936f, _291, (_287 * -0.0022720457054674625f)));
  float _322 = mad(0.9684867262840271f, _295, mad(0.04004279896616936f, _292, (_287 * 0.0013765322510153055f)));
  float _325 = mad(_304, (WorkingColorSpace_000[2].x), mad(_301, (WorkingColorSpace_000[1].x), (_298 * (WorkingColorSpace_000[0].x))));
  float _328 = mad(_304, (WorkingColorSpace_000[2].y), mad(_301, (WorkingColorSpace_000[1].y), (_298 * (WorkingColorSpace_000[0].y))));
  float _331 = mad(_304, (WorkingColorSpace_000[2].z), mad(_301, (WorkingColorSpace_000[1].z), (_298 * (WorkingColorSpace_000[0].z))));
  float _334 = mad(_313, (WorkingColorSpace_000[2].x), mad(_310, (WorkingColorSpace_000[1].x), (_307 * (WorkingColorSpace_000[0].x))));
  float _337 = mad(_313, (WorkingColorSpace_000[2].y), mad(_310, (WorkingColorSpace_000[1].y), (_307 * (WorkingColorSpace_000[0].y))));
  float _340 = mad(_313, (WorkingColorSpace_000[2].z), mad(_310, (WorkingColorSpace_000[1].z), (_307 * (WorkingColorSpace_000[0].z))));
  float _343 = mad(_322, (WorkingColorSpace_000[2].x), mad(_319, (WorkingColorSpace_000[1].x), (_316 * (WorkingColorSpace_000[0].x))));
  float _346 = mad(_322, (WorkingColorSpace_000[2].y), mad(_319, (WorkingColorSpace_000[1].y), (_316 * (WorkingColorSpace_000[0].y))));
  float _349 = mad(_322, (WorkingColorSpace_000[2].z), mad(_319, (WorkingColorSpace_000[1].z), (_316 * (WorkingColorSpace_000[0].z))));
  float _379 = mad(mad((WorkingColorSpace_064[0].z), _349, mad((WorkingColorSpace_064[0].y), _340, (_331 * (WorkingColorSpace_064[0].x)))), _132, mad(mad((WorkingColorSpace_064[0].z), _346, mad((WorkingColorSpace_064[0].y), _337, (_328 * (WorkingColorSpace_064[0].x)))), _131, (mad((WorkingColorSpace_064[0].z), _343, mad((WorkingColorSpace_064[0].y), _334, (_325 * (WorkingColorSpace_064[0].x)))) * _130)));
  float _382 = mad(mad((WorkingColorSpace_064[1].z), _349, mad((WorkingColorSpace_064[1].y), _340, (_331 * (WorkingColorSpace_064[1].x)))), _132, mad(mad((WorkingColorSpace_064[1].z), _346, mad((WorkingColorSpace_064[1].y), _337, (_328 * (WorkingColorSpace_064[1].x)))), _131, (mad((WorkingColorSpace_064[1].z), _343, mad((WorkingColorSpace_064[1].y), _334, (_325 * (WorkingColorSpace_064[1].x)))) * _130)));
  float _385 = mad(mad((WorkingColorSpace_064[2].z), _349, mad((WorkingColorSpace_064[2].y), _340, (_331 * (WorkingColorSpace_064[2].x)))), _132, mad(mad((WorkingColorSpace_064[2].z), _346, mad((WorkingColorSpace_064[2].y), _337, (_328 * (WorkingColorSpace_064[2].x)))), _131, (mad((WorkingColorSpace_064[2].z), _343, mad((WorkingColorSpace_064[2].y), _334, (_325 * (WorkingColorSpace_064[2].x)))) * _130)));
  float _400 = mad((WorkingColorSpace_128[0].z), _385, mad((WorkingColorSpace_128[0].y), _382, ((WorkingColorSpace_128[0].x) * _379)));
  float _403 = mad((WorkingColorSpace_128[1].z), _385, mad((WorkingColorSpace_128[1].y), _382, ((WorkingColorSpace_128[1].x) * _379)));
  float _406 = mad((WorkingColorSpace_128[2].z), _385, mad((WorkingColorSpace_128[2].y), _382, ((WorkingColorSpace_128[2].x) * _379)));
  float _407 = dot(float3(_400, _403, _406), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _411 = (_400 / _407) + -1.0f;
  float _412 = (_403 / _407) + -1.0f;
  float _413 = (_406 / _407) + -1.0f;

  // float _425 = (1.0f - exp2(((_407 * _407) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_411, _412, _413), float3(_411, _412, _413)) * -4.0f));
  float _425 = (1.0f - exp2(((_407 * _407) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_411, _412, _413), float3(_411, _412, _413)) * -4.0f));

  float _441 = ((mad(-0.06368321925401688f, _406, mad(-0.3292922377586365f, _403, (_400 * 1.3704125881195068f))) - _400) * _425) + _400;
  float _442 = ((mad(-0.010861365124583244f, _406, mad(1.0970927476882935f, _403, (_400 * -0.08343357592821121f))) - _403) * _425) + _403;
  float _443 = ((mad(1.2036951780319214f, _406, mad(-0.09862580895423889f, _403, (_400 * -0.02579331398010254f))) - _406) * _425) + _406;
  float _444 = dot(float3(_441, _442, _443), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _458 = cb0_019w + cb0_024w;
  float _472 = cb0_018w * cb0_023w;
  float _486 = cb0_017w * cb0_022w;
  float _500 = cb0_016w * cb0_021w;
  float _514 = cb0_015w * cb0_020w;
  float _518 = _441 - _444;
  float _519 = _442 - _444;
  float _520 = _443 - _444;
  float _577 = saturate(_444 / cb0_035w);
  float _581 = (_577 * _577) * (3.0f - (_577 * 2.0f));
  float _582 = 1.0f - _581;
  float _591 = cb0_019w + cb0_034w;
  float _600 = cb0_018w * cb0_033w;
  float _609 = cb0_017w * cb0_032w;
  float _618 = cb0_016w * cb0_031w;
  float _627 = cb0_015w * cb0_030w;
  float _690 = saturate((_444 - cb0_036x) / (cb0_036y - cb0_036x));
  float _694 = (_690 * _690) * (3.0f - (_690 * 2.0f));
  float _703 = cb0_019w + cb0_029w;
  float _712 = cb0_018w * cb0_028w;
  float _721 = cb0_017w * cb0_027w;
  float _730 = cb0_016w * cb0_026w;
  float _739 = cb0_015w * cb0_025w;
  float _797 = _581 - _694;
  float _808 = ((_694 * (((cb0_019x + cb0_034x) + _591) + (((cb0_018x * cb0_033x) * _600) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _618) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _627) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _609)))))) + (_582 * (((cb0_019x + cb0_024x) + _458) + (((cb0_018x * cb0_023x) * _472) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _500) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _514) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _486))))))) + ((((cb0_019x + cb0_029x) + _703) + (((cb0_018x * cb0_028x) * _712) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _730) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _739) * _518) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _721))))) * _797);
  float _810 = ((_694 * (((cb0_019y + cb0_034y) + _591) + (((cb0_018y * cb0_033y) * _600) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _618) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _627) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _609)))))) + (_582 * (((cb0_019y + cb0_024y) + _458) + (((cb0_018y * cb0_023y) * _472) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _500) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _514) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _486))))))) + ((((cb0_019y + cb0_029y) + _703) + (((cb0_018y * cb0_028y) * _712) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _730) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _739) * _519) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _721))))) * _797);
  float _812 = ((_694 * (((cb0_019z + cb0_034z) + _591) + (((cb0_018z * cb0_033z) * _600) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _618) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _627) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _609)))))) + (_582 * (((cb0_019z + cb0_024z) + _458) + (((cb0_018z * cb0_023z) * _472) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _500) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _514) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _486))))))) + ((((cb0_019z + cb0_029z) + _703) + (((cb0_018z * cb0_028z) * _712) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _730) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _739) * _520) + _444)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _721))))) * _797);

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
  cb_config.ue_lutweights = lutweights;  //  Lutweights[0].xyz is used

  float4 output = ProcessLutbuilder(float3(_808, _810, _812), s0, s1, t0, t1, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _848 = ((mad(0.061360642313957214f, _812, mad(-4.540197551250458e-09f, _810, (_808 * 0.9386394023895264f))) - _808) * cb0_036z) + _808;
  float _849 = ((mad(0.169205904006958f, _812, mad(0.8307942152023315f, _810, (_808 * 6.775371730327606e-08f))) - _810) * cb0_036z) + _810;
  float _850 = (mad(-2.3283064365386963e-10f, _810, (_808 * -9.313225746154785e-10f)) * cb0_036z) + _812;
  float _853 = mad(0.16386905312538147f, _850, mad(0.14067868888378143f, _849, (_848 * 0.6954522132873535f)));
  float _856 = mad(0.0955343246459961f, _850, mad(0.8596711158752441f, _849, (_848 * 0.044794581830501556f)));
  float _859 = mad(1.0015007257461548f, _850, mad(0.004025210160762072f, _849, (_848 * -0.005525882821530104f)));
  float _863 = max(max(_853, _856), _859);
  float _868 = (max(_863, 1.000000013351432e-10f) - max(min(min(_853, _856), _859), 1.000000013351432e-10f)) / max(_863, 0.009999999776482582f);
  float _881 = ((_856 + _853) + _859) + (sqrt((((_859 - _856) * _859) + ((_856 - _853) * _856)) + ((_853 - _859) * _853)) * 1.75f);
  float _882 = _881 * 0.3333333432674408f;
  float _883 = _868 + -0.4000000059604645f;
  float _884 = _883 * 5.0f;
  float _888 = max((1.0f - abs(_883 * 2.5f)), 0.0f);
  float _899 = ((float((int)(((int)(uint)((bool)(_884 > 0.0f))) - ((int)(uint)((bool)(_884 < 0.0f))))) * (1.0f - (_888 * _888))) + 1.0f) * 0.02500000037252903f;
  if (!(_882 <= 0.0533333346247673f)) {
    if (!(_882 >= 0.1599999964237213f)) {
      _908 = (((0.23999999463558197f / _881) + -0.5f) * _899);
    } else {
      _908 = 0.0f;
    }
  } else {
    _908 = _899;
  }
  float _909 = _908 + 1.0f;
  float _910 = _909 * _853;
  float _911 = _909 * _856;
  float _912 = _909 * _859;
  if (!((bool)(_910 == _911) && (bool)(_911 == _912))) {
    float _919 = ((_910 * 2.0f) - _911) - _912;
    float _922 = ((_856 - _859) * 1.7320507764816284f) * _909;
    float _924 = atan(_922 / _919);
    bool _927 = (_919 < 0.0f);
    bool _928 = (_919 == 0.0f);
    bool _929 = (_922 >= 0.0f);
    bool _930 = (_922 < 0.0f);
    _941 = select((_929 && _928), 90.0f, select((_930 && _928), -90.0f, (select((_930 && _927), (_924 + -3.1415927410125732f), select((_929 && _927), (_924 + 3.1415927410125732f), _924)) * 57.2957763671875f)));
  } else {
    _941 = 0.0f;
  }
  float _946 = min(max(select((_941 < 0.0f), (_941 + 360.0f), _941), 0.0f), 360.0f);
  if (_946 < -180.0f) {
    _955 = (_946 + 360.0f);
  } else {
    if (_946 > 180.0f) {
      _955 = (_946 + -360.0f);
    } else {
      _955 = _946;
    }
  }
  float _959 = saturate(1.0f - abs(_955 * 0.014814814552664757f));
  float _963 = (_959 * _959) * (3.0f - (_959 * 2.0f));
  float _969 = ((_963 * _963) * ((_868 * 0.18000000715255737f) * (0.029999999329447746f - _910))) + _910;
  float _979 = max(0.0f, mad(-0.21492856740951538f, _912, mad(-0.2365107536315918f, _911, (_969 * 1.4514392614364624f))));
  float _980 = max(0.0f, mad(-0.09967592358589172f, _912, mad(1.17622971534729f, _911, (_969 * -0.07655377686023712f))));
  float _981 = max(0.0f, mad(0.9977163076400757f, _912, mad(-0.006032449658960104f, _911, (_969 * 0.008316148072481155f))));
  float _982 = dot(float3(_979, _980, _981), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _997 = (cb0_038x + 1.0f) - cb0_037z;
  float _999 = cb0_038y + 1.0f;
  float _1001 = _999 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1019 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _1010 = (cb0_038x + 0.18000000715255737f) / _997;
    _1019 = (-0.7447274923324585f - ((log2(_1010 / (2.0f - _1010)) * 0.3465735912322998f) * (_997 / cb0_037y)));
  }
  float _1022 = ((1.0f - cb0_037z) / cb0_037y) - _1019;
  float _1024 = (cb0_037w / cb0_037y) - _1022;
  float _1028 = log2(lerp(_982, _979, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1029 = log2(lerp(_982, _980, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1030 = log2(lerp(_982, _981, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1034 = cb0_037y * (_1028 + _1022);
  float _1035 = cb0_037y * (_1029 + _1022);
  float _1036 = cb0_037y * (_1030 + _1022);
  float _1037 = _997 * 2.0f;
  float _1039 = (cb0_037y * -2.0f) / _997;
  float _1040 = _1028 - _1019;
  float _1041 = _1029 - _1019;
  float _1042 = _1030 - _1019;
  float _1061 = _1001 * 2.0f;
  float _1063 = (cb0_037y * 2.0f) / _1001;
  float _1088 = select((_1028 < _1019), ((_1037 / (exp2((_1040 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_038x), _1034);
  float _1089 = select((_1029 < _1019), ((_1037 / (exp2((_1041 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_038x), _1035);
  float _1090 = select((_1030 < _1019), ((_1037 / (exp2((_1042 * 1.4426950216293335f) * _1039) + 1.0f)) - cb0_038x), _1036);
  float _1097 = _1024 - _1019;
  float _1101 = saturate(_1040 / _1097);
  float _1102 = saturate(_1041 / _1097);
  float _1103 = saturate(_1042 / _1097);
  bool _1104 = (_1024 < _1019);
  float _1108 = select(_1104, (1.0f - _1101), _1101);
  float _1109 = select(_1104, (1.0f - _1102), _1102);
  float _1110 = select(_1104, (1.0f - _1103), _1103);
  float _1129 = (((_1108 * _1108) * (select((_1028 > _1024), (_999 - (_1061 / (exp2(((_1028 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1034) - _1088)) * (3.0f - (_1108 * 2.0f))) + _1088;
  float _1130 = (((_1109 * _1109) * (select((_1029 > _1024), (_999 - (_1061 / (exp2(((_1029 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1035) - _1089)) * (3.0f - (_1109 * 2.0f))) + _1089;
  float _1131 = (((_1110 * _1110) * (select((_1030 > _1024), (_999 - (_1061 / (exp2(((_1030 - _1024) * 1.4426950216293335f) * _1063) + 1.0f))), _1036) - _1090)) * (3.0f - (_1110 * 2.0f))) + _1090;
  float _1132 = dot(float3(_1129, _1130, _1131), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1152 = (cb0_037x * (max(0.0f, (lerp(_1132, _1129, 0.9300000071525574f))) - _848)) + _848;
  float _1153 = (cb0_037x * (max(0.0f, (lerp(_1132, _1130, 0.9300000071525574f))) - _849)) + _849;
  float _1154 = (cb0_037x * (max(0.0f, (lerp(_1132, _1131, 0.9300000071525574f))) - _850)) + _850;
  float _1170 = ((mad(-0.06537103652954102f, _1154, mad(1.451815478503704e-06f, _1153, (_1152 * 1.065374732017517f))) - _1152) * cb0_036z) + _1152;
  float _1171 = ((mad(-0.20366770029067993f, _1154, mad(1.2036634683609009f, _1153, (_1152 * -2.57161445915699e-07f))) - _1153) * cb0_036z) + _1153;
  float _1172 = ((mad(0.9999996423721313f, _1154, mad(2.0954757928848267e-08f, _1153, (_1152 * 1.862645149230957e-08f))) - _1154) * cb0_036z) + _1154;
  float _1185 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1172, mad((WorkingColorSpace_192[0].y), _1171, ((WorkingColorSpace_192[0].x) * _1170)))));
  float _1186 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1172, mad((WorkingColorSpace_192[1].y), _1171, ((WorkingColorSpace_192[1].x) * _1170)))));
  float _1187 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1172, mad((WorkingColorSpace_192[2].y), _1171, ((WorkingColorSpace_192[2].x) * _1170)))));
  if (_1185 < 0.0031306699384003878f) {
    _1198 = (_1185 * 12.920000076293945f);
  } else {
    _1198 = (((pow(_1185, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1186 < 0.0031306699384003878f) {
    _1209 = (_1186 * 12.920000076293945f);
  } else {
    _1209 = (((pow(_1186, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1187 < 0.0031306699384003878f) {
    _1220 = (_1187 * 12.920000076293945f);
  } else {
    _1220 = (((pow(_1187, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1224 = (_1209 * 0.9375f) + 0.03125f;
  float _1231 = _1220 * 15.0f;
  float _1232 = floor(_1231);
  float _1233 = _1231 - _1232;
  float _1235 = (_1232 + ((_1198 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1238 = t0.SampleLevel(s0, float2(_1235, _1224), 0.0f);
  float _1242 = _1235 + 0.0625f;
  float4 _1243 = t0.SampleLevel(s0, float2(_1242, _1224), 0.0f);
  float4 _1265 = t1.SampleLevel(s1, float2(_1235, _1224), 0.0f);
  float4 _1269 = t1.SampleLevel(s1, float2(_1242, _1224), 0.0f);
  float _1288 = max(6.103519990574569e-05f, ((((lerp(_1238.x, _1243.x, _1233)) * cb0_005y) + (cb0_005x * _1198)) + ((lerp(_1265.x, _1269.x, _1233)) * cb0_005z)));
  float _1289 = max(6.103519990574569e-05f, ((((lerp(_1238.y, _1243.y, _1233)) * cb0_005y) + (cb0_005x * _1209)) + ((lerp(_1265.y, _1269.y, _1233)) * cb0_005z)));
  float _1290 = max(6.103519990574569e-05f, ((((lerp(_1238.z, _1243.z, _1233)) * cb0_005y) + (cb0_005x * _1220)) + ((lerp(_1265.z, _1269.z, _1233)) * cb0_005z)));
  float _1312 = select((_1288 > 0.040449999272823334f), exp2(log2((_1288 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1288 * 0.07739938050508499f));
  float _1313 = select((_1289 > 0.040449999272823334f), exp2(log2((_1289 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1289 * 0.07739938050508499f));
  float _1314 = select((_1290 > 0.040449999272823334f), exp2(log2((_1290 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1290 * 0.07739938050508499f));
  float _1340 = cb0_014x * (((cb0_039y + (cb0_039x * _1312)) * _1312) + cb0_039z);
  float _1341 = cb0_014y * (((cb0_039y + (cb0_039x * _1313)) * _1313) + cb0_039z);
  float _1342 = cb0_014z * (((cb0_039y + (cb0_039x * _1314)) * _1314) + cb0_039z);
  float _1349 = ((cb0_013x - _1340) * cb0_013w) + _1340;
  float _1350 = ((cb0_013y - _1341) * cb0_013w) + _1341;
  float _1351 = ((cb0_013z - _1342) * cb0_013w) + _1342;
  float _1352 = cb0_014x * mad((WorkingColorSpace_192[0].z), _812, mad((WorkingColorSpace_192[0].y), _810, (_808 * (WorkingColorSpace_192[0].x))));
  float _1353 = cb0_014y * mad((WorkingColorSpace_192[1].z), _812, mad((WorkingColorSpace_192[1].y), _810, ((WorkingColorSpace_192[1].x) * _808)));
  float _1354 = cb0_014z * mad((WorkingColorSpace_192[2].z), _812, mad((WorkingColorSpace_192[2].y), _810, ((WorkingColorSpace_192[2].x) * _808)));
  float _1361 = ((cb0_013x - _1352) * cb0_013w) + _1352;
  float _1362 = ((cb0_013y - _1353) * cb0_013w) + _1353;
  float _1363 = ((cb0_013z - _1354) * cb0_013w) + _1354;
  float _1375 = exp2(log2(max(0.0f, _1349)) * cb0_040y);
  float _1376 = exp2(log2(max(0.0f, _1350)) * cb0_040y);
  float _1377 = exp2(log2(max(0.0f, _1351)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1400 = mad((WorkingColorSpace_128[0].z), _1377, mad((WorkingColorSpace_128[0].y), _1376, ((WorkingColorSpace_128[0].x) * _1375)));
        float _1403 = mad((WorkingColorSpace_128[1].z), _1377, mad((WorkingColorSpace_128[1].y), _1376, ((WorkingColorSpace_128[1].x) * _1375)));
        float _1406 = mad((WorkingColorSpace_128[2].z), _1377, mad((WorkingColorSpace_128[2].y), _1376, ((WorkingColorSpace_128[2].x) * _1375)));
        _1417 = mad(_66, _1406, mad(_65, _1403, (_1400 * _64)));
        _1418 = mad(_69, _1406, mad(_68, _1403, (_1400 * _67)));
        _1419 = mad(_72, _1406, mad(_71, _1403, (_1400 * _70)));
      } else {
        _1417 = _1375;
        _1418 = _1376;
        _1419 = _1377;
      }
      do {
        if (_1417 < 0.0031306699384003878f) {
          _1430 = (_1417 * 12.920000076293945f);
        } else {
          _1430 = (((pow(_1417, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1418 < 0.0031306699384003878f) {
            _1441 = (_1418 * 12.920000076293945f);
          } else {
            _1441 = (((pow(_1418, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1419 < 0.0031306699384003878f) {
            _3039 = _1430;
            _3040 = _1441;
            _3041 = (_1419 * 12.920000076293945f);
          } else {
            _3039 = _1430;
            _3040 = _1441;
            _3041 = (((pow(_1419, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1468 = mad((WorkingColorSpace_128[0].z), _1377, mad((WorkingColorSpace_128[0].y), _1376, ((WorkingColorSpace_128[0].x) * _1375)));
      float _1471 = mad((WorkingColorSpace_128[1].z), _1377, mad((WorkingColorSpace_128[1].y), _1376, ((WorkingColorSpace_128[1].x) * _1375)));
      float _1474 = mad((WorkingColorSpace_128[2].z), _1377, mad((WorkingColorSpace_128[2].y), _1376, ((WorkingColorSpace_128[2].x) * _1375)));
      float _1484 = max(6.103519990574569e-05f, mad(_66, _1474, mad(_65, _1471, (_1468 * _64))));
      float _1485 = max(6.103519990574569e-05f, mad(_69, _1474, mad(_68, _1471, (_1468 * _67))));
      float _1486 = max(6.103519990574569e-05f, mad(_72, _1474, mad(_71, _1471, (_1468 * _70))));
      _3039 = min((_1484 * 4.5f), ((exp2(log2(max(_1484, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3040 = min((_1485 * 4.5f), ((exp2(log2(max(_1485, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _3041 = min((_1486 * 4.5f), ((exp2(log2(max(_1486, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
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
        float _1562 = cb0_012z * _1361;
        float _1563 = cb0_012z * _1362;
        float _1564 = cb0_012z * _1363;
        float _1567 = mad((WorkingColorSpace_256[0].z), _1564, mad((WorkingColorSpace_256[0].y), _1563, ((WorkingColorSpace_256[0].x) * _1562)));
        float _1570 = mad((WorkingColorSpace_256[1].z), _1564, mad((WorkingColorSpace_256[1].y), _1563, ((WorkingColorSpace_256[1].x) * _1562)));
        float _1573 = mad((WorkingColorSpace_256[2].z), _1564, mad((WorkingColorSpace_256[2].y), _1563, ((WorkingColorSpace_256[2].x) * _1562)));
        float _1576 = mad(-0.21492856740951538f, _1573, mad(-0.2365107536315918f, _1570, (_1567 * 1.4514392614364624f)));
        float _1579 = mad(-0.09967592358589172f, _1573, mad(1.17622971534729f, _1570, (_1567 * -0.07655377686023712f)));
        float _1582 = mad(0.9977163076400757f, _1573, mad(-0.006032449658960104f, _1570, (_1567 * 0.008316148072481155f)));
        float _1584 = max(_1576, max(_1579, _1582));
        do {
          if (!(_1584 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1567 < 0.0f) || (bool)(_1570 < 0.0f))) || (bool)(_1573 < 0.0f))) {
              float _1594 = abs(_1584);
              float _1595 = (_1584 - _1576) / _1594;
              float _1597 = (_1584 - _1579) / _1594;
              float _1599 = (_1584 - _1582) / _1594;
              do {
                if (!(_1595 < 0.8149999976158142f)) {
                  float _1602 = _1595 + -0.8149999976158142f;
                  _1614 = ((_1602 / exp2(log2(exp2(log2(_1602 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1614 = _1595;
                }
                do {
                  if (!(_1597 < 0.8029999732971191f)) {
                    float _1617 = _1597 + -0.8029999732971191f;
                    _1629 = ((_1617 / exp2(log2(exp2(log2(_1617 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1629 = _1597;
                  }
                  do {
                    if (!(_1599 < 0.8799999952316284f)) {
                      float _1632 = _1599 + -0.8799999952316284f;
                      _1644 = ((_1632 / exp2(log2(exp2(log2(_1632 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1644 = _1599;
                    }
                    _1652 = (_1584 - (_1594 * _1614));
                    _1653 = (_1584 - (_1594 * _1629));
                    _1654 = (_1584 - (_1594 * _1644));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1652 = _1576;
              _1653 = _1579;
              _1654 = _1582;
            }
          } else {
            _1652 = _1576;
            _1653 = _1579;
            _1654 = _1582;
          }
          float _1670 = ((mad(0.16386906802654266f, _1654, mad(0.14067870378494263f, _1653, (_1652 * 0.6954522132873535f))) - _1567) * cb0_012w) + _1567;
          float _1671 = ((mad(0.0955343171954155f, _1654, mad(0.8596711158752441f, _1653, (_1652 * 0.044794563204050064f))) - _1570) * cb0_012w) + _1570;
          float _1672 = ((mad(1.0015007257461548f, _1654, mad(0.004025210160762072f, _1653, (_1652 * -0.005525882821530104f))) - _1573) * cb0_012w) + _1573;
          float _1676 = max(max(_1670, _1671), _1672);
          float _1681 = (max(_1676, 1.000000013351432e-10f) - max(min(min(_1670, _1671), _1672), 1.000000013351432e-10f)) / max(_1676, 0.009999999776482582f);
          float _1694 = ((_1671 + _1670) + _1672) + (sqrt((((_1672 - _1671) * _1672) + ((_1671 - _1670) * _1671)) + ((_1670 - _1672) * _1670)) * 1.75f);
          float _1695 = _1694 * 0.3333333432674408f;
          float _1696 = _1681 + -0.4000000059604645f;
          float _1697 = _1696 * 5.0f;
          float _1701 = max((1.0f - abs(_1696 * 2.5f)), 0.0f);
          float _1712 = ((float((int)(((int)(uint)((bool)(_1697 > 0.0f))) - ((int)(uint)((bool)(_1697 < 0.0f))))) * (1.0f - (_1701 * _1701))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1695 <= 0.0533333346247673f)) {
              if (!(_1695 >= 0.1599999964237213f)) {
                _1721 = (((0.23999999463558197f / _1694) + -0.5f) * _1712);
              } else {
                _1721 = 0.0f;
              }
            } else {
              _1721 = _1712;
            }
            float _1722 = _1721 + 1.0f;
            float _1723 = _1722 * _1670;
            float _1724 = _1722 * _1671;
            float _1725 = _1722 * _1672;
            do {
              if (!((bool)(_1723 == _1724) && (bool)(_1724 == _1725))) {
                float _1732 = ((_1723 * 2.0f) - _1724) - _1725;
                float _1735 = ((_1671 - _1672) * 1.7320507764816284f) * _1722;
                float _1737 = atan(_1735 / _1732);
                bool _1740 = (_1732 < 0.0f);
                bool _1741 = (_1732 == 0.0f);
                bool _1742 = (_1735 >= 0.0f);
                bool _1743 = (_1735 < 0.0f);
                _1754 = select((_1742 && _1741), 90.0f, select((_1743 && _1741), -90.0f, (select((_1743 && _1740), (_1737 + -3.1415927410125732f), select((_1742 && _1740), (_1737 + 3.1415927410125732f), _1737)) * 57.2957763671875f)));
              } else {
                _1754 = 0.0f;
              }
              float _1759 = min(max(select((_1754 < 0.0f), (_1754 + 360.0f), _1754), 0.0f), 360.0f);
              do {
                if (_1759 < -180.0f) {
                  _1768 = (_1759 + 360.0f);
                } else {
                  if (_1759 > 180.0f) {
                    _1768 = (_1759 + -360.0f);
                  } else {
                    _1768 = _1759;
                  }
                }
                do {
                  if ((bool)(_1768 > -67.5f) && (bool)(_1768 < 67.5f)) {
                    float _1774 = (_1768 + 67.5f) * 0.029629629105329514f;
                    int _1775 = int(_1774);
                    float _1777 = _1774 - float((int)(_1775));
                    float _1778 = _1777 * _1777;
                    float _1779 = _1778 * _1777;
                    if (_1775 == 3) {
                      _1807 = (((0.1666666716337204f - (_1777 * 0.5f)) + (_1778 * 0.5f)) - (_1779 * 0.1666666716337204f));
                    } else {
                      if (_1775 == 2) {
                        _1807 = ((0.6666666865348816f - _1778) + (_1779 * 0.5f));
                      } else {
                        if (_1775 == 1) {
                          _1807 = (((_1779 * -0.5f) + 0.1666666716337204f) + ((_1778 + _1777) * 0.5f));
                        } else {
                          _1807 = select((_1775 == 0), (_1779 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1807 = 0.0f;
                  }
                  float _1816 = min(max(((((_1681 * 0.27000001072883606f) * (0.029999999329447746f - _1723)) * _1807) + _1723), 0.0f), 65535.0f);
                  float _1817 = min(max(_1724, 0.0f), 65535.0f);
                  float _1818 = min(max(_1725, 0.0f), 65535.0f);
                  float _1831 = min(max(mad(-0.21492856740951538f, _1818, mad(-0.2365107536315918f, _1817, (_1816 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1832 = min(max(mad(-0.09967592358589172f, _1818, mad(1.17622971534729f, _1817, (_1816 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1833 = min(max(mad(0.9977163076400757f, _1818, mad(-0.006032449658960104f, _1817, (_1816 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1834 = dot(float3(_1831, _1832, _1833), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1857 = log2(max((lerp(_1834, _1831, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1858 = _1857 * 0.3010300099849701f;
                  float _1859 = log2(cb0_008x);
                  float _1860 = _1859 * 0.3010300099849701f;
                  do {
                    if (!(!(_1858 <= _1860))) {
                      _1929 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1867 = log2(cb0_009x);
                      float _1868 = _1867 * 0.3010300099849701f;
                      if ((bool)(_1858 > _1860) && (bool)(_1858 < _1868)) {
                        float _1876 = ((_1857 - _1859) * 0.9030900001525879f) / ((_1867 - _1859) * 0.3010300099849701f);
                        int _1877 = int(_1876);
                        float _1879 = _1876 - float((int)(_1877));
                        float _1881 = _21[_1877];
                        float _1884 = _21[(_1877 + 1)];
                        float _1889 = _1881 * 0.5f;
                        _1929 = dot(float3((_1879 * _1879), _1879, 1.0f), float3(mad((_21[(_1877 + 2)]), 0.5f, mad(_1884, -1.0f, _1889)), (_1884 - _1881), mad(_1884, 0.5f, _1889)));
                      } else {
                        do {
                          if (!(!(_1858 >= _1868))) {
                            float _1898 = log2(cb0_008z);
                            if (_1858 < (_1898 * 0.3010300099849701f)) {
                              float _1906 = ((_1857 - _1867) * 0.9030900001525879f) / ((_1898 - _1867) * 0.3010300099849701f);
                              int _1907 = int(_1906);
                              float _1909 = _1906 - float((int)(_1907));
                              float _1911 = _22[_1907];
                              float _1914 = _22[(_1907 + 1)];
                              float _1919 = _1911 * 0.5f;
                              _1929 = dot(float3((_1909 * _1909), _1909, 1.0f), float3(mad((_22[(_1907 + 2)]), 0.5f, mad(_1914, -1.0f, _1919)), (_1914 - _1911), mad(_1914, 0.5f, _1919)));
                              break;
                            }
                          }
                          _1929 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _23[0] = cb0_011x;
                    _23[1] = cb0_011y;
                    _23[2] = cb0_011z;
                    _23[3] = cb0_011w;
                    _23[4] = cb0_012y;
                    _23[5] = cb0_012y;
                    float _1939 = log2(max((lerp(_1834, _1832, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1940 = _1939 * 0.3010300099849701f;
                    do {
                      if (!(!(_1940 <= _1860))) {
                        _2009 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1947 = log2(cb0_009x);
                        float _1948 = _1947 * 0.3010300099849701f;
                        if ((bool)(_1940 > _1860) && (bool)(_1940 < _1948)) {
                          float _1956 = ((_1939 - _1859) * 0.9030900001525879f) / ((_1947 - _1859) * 0.3010300099849701f);
                          int _1957 = int(_1956);
                          float _1959 = _1956 - float((int)(_1957));
                          float _1961 = _15[_1957];
                          float _1964 = _15[(_1957 + 1)];
                          float _1969 = _1961 * 0.5f;
                          _2009 = dot(float3((_1959 * _1959), _1959, 1.0f), float3(mad((_15[(_1957 + 2)]), 0.5f, mad(_1964, -1.0f, _1969)), (_1964 - _1961), mad(_1964, 0.5f, _1969)));
                        } else {
                          do {
                            if (!(!(_1940 >= _1948))) {
                              float _1978 = log2(cb0_008z);
                              if (_1940 < (_1978 * 0.3010300099849701f)) {
                                float _1986 = ((_1939 - _1947) * 0.9030900001525879f) / ((_1978 - _1947) * 0.3010300099849701f);
                                int _1987 = int(_1986);
                                float _1989 = _1986 - float((int)(_1987));
                                float _1991 = _23[_1987];
                                float _1994 = _23[(_1987 + 1)];
                                float _1999 = _1991 * 0.5f;
                                _2009 = dot(float3((_1989 * _1989), _1989, 1.0f), float3(mad((_23[(_1987 + 2)]), 0.5f, mad(_1994, -1.0f, _1999)), (_1994 - _1991), mad(_1994, 0.5f, _1999)));
                                break;
                              }
                            }
                            _2009 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2013 = log2(max((lerp(_1834, _1833, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2014 = _2013 * 0.3010300099849701f;
                      do {
                        if (!(!(_2014 <= _1860))) {
                          _2083 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2021 = log2(cb0_009x);
                          float _2022 = _2021 * 0.3010300099849701f;
                          if ((bool)(_2014 > _1860) && (bool)(_2014 < _2022)) {
                            float _2030 = ((_2013 - _1859) * 0.9030900001525879f) / ((_2021 - _1859) * 0.3010300099849701f);
                            int _2031 = int(_2030);
                            float _2033 = _2030 - float((int)(_2031));
                            float _2035 = _15[_2031];
                            float _2038 = _15[(_2031 + 1)];
                            float _2043 = _2035 * 0.5f;
                            _2083 = dot(float3((_2033 * _2033), _2033, 1.0f), float3(mad((_15[(_2031 + 2)]), 0.5f, mad(_2038, -1.0f, _2043)), (_2038 - _2035), mad(_2038, 0.5f, _2043)));
                          } else {
                            do {
                              if (!(!(_2014 >= _2022))) {
                                float _2052 = log2(cb0_008z);
                                if (_2014 < (_2052 * 0.3010300099849701f)) {
                                  float _2060 = ((_2013 - _2021) * 0.9030900001525879f) / ((_2052 - _2021) * 0.3010300099849701f);
                                  int _2061 = int(_2060);
                                  float _2063 = _2060 - float((int)(_2061));
                                  float _2065 = _16[_2061];
                                  float _2068 = _16[(_2061 + 1)];
                                  float _2073 = _2065 * 0.5f;
                                  _2083 = dot(float3((_2063 * _2063), _2063, 1.0f), float3(mad((_16[(_2061 + 2)]), 0.5f, mad(_2068, -1.0f, _2073)), (_2068 - _2065), mad(_2068, 0.5f, _2073)));
                                  break;
                                }
                              }
                              _2083 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2087 = cb0_008w - cb0_008y;
                        float _2088 = (exp2(_1929 * 3.321928024291992f) - cb0_008y) / _2087;
                        float _2090 = (exp2(_2009 * 3.321928024291992f) - cb0_008y) / _2087;
                        float _2092 = (exp2(_2083 * 3.321928024291992f) - cb0_008y) / _2087;
                        float _2095 = mad(0.15618768334388733f, _2092, mad(0.13400420546531677f, _2090, (_2088 * 0.6624541878700256f)));
                        float _2098 = mad(0.053689517080783844f, _2092, mad(0.6740817427635193f, _2090, (_2088 * 0.2722287178039551f)));
                        float _2101 = mad(1.0103391408920288f, _2092, mad(0.00406073359772563f, _2090, (_2088 * -0.005574649665504694f)));
                        float _2114 = min(max(mad(-0.23642469942569733f, _2101, mad(-0.32480329275131226f, _2098, (_2095 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2115 = min(max(mad(0.016756348311901093f, _2101, mad(1.6153316497802734f, _2098, (_2095 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2116 = min(max(mad(0.9883948564529419f, _2101, mad(-0.008284442126750946f, _2098, (_2095 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2119 = mad(0.15618768334388733f, _2116, mad(0.13400420546531677f, _2115, (_2114 * 0.6624541878700256f)));
                        float _2122 = mad(0.053689517080783844f, _2116, mad(0.6740817427635193f, _2115, (_2114 * 0.2722287178039551f)));
                        float _2125 = mad(1.0103391408920288f, _2116, mad(0.00406073359772563f, _2115, (_2114 * -0.005574649665504694f)));
                        float _2147 = min(max((min(max(mad(-0.23642469942569733f, _2125, mad(-0.32480329275131226f, _2122, (_2119 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2148 = min(max((min(max(mad(0.016756348311901093f, _2125, mad(1.6153316497802734f, _2122, (_2119 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2149 = min(max((min(max(mad(0.9883948564529419f, _2125, mad(-0.008284442126750946f, _2122, (_2119 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _2162 = mad(_66, _2149, mad(_65, _2148, (_2147 * _64)));
                            _2163 = mad(_69, _2149, mad(_68, _2148, (_2147 * _67)));
                            _2164 = mad(_72, _2149, mad(_71, _2148, (_2147 * _70)));
                          } else {
                            _2162 = _2147;
                            _2163 = _2148;
                            _2164 = _2149;
                          }
                          float _2174 = exp2(log2(_2162 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2175 = exp2(log2(_2163 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2176 = exp2(log2(_2164 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _3039 = exp2(log2((1.0f / ((_2174 * 18.6875f) + 1.0f)) * ((_2174 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3040 = exp2(log2((1.0f / ((_2175 * 18.6875f) + 1.0f)) * ((_2175 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _3041 = exp2(log2((1.0f / ((_2176 * 18.6875f) + 1.0f)) * ((_2176 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2242 = cb0_012z * _1361;
          float _2243 = cb0_012z * _1362;
          float _2244 = cb0_012z * _1363;
          float _2247 = mad((WorkingColorSpace_256[0].z), _2244, mad((WorkingColorSpace_256[0].y), _2243, ((WorkingColorSpace_256[0].x) * _2242)));
          float _2250 = mad((WorkingColorSpace_256[1].z), _2244, mad((WorkingColorSpace_256[1].y), _2243, ((WorkingColorSpace_256[1].x) * _2242)));
          float _2253 = mad((WorkingColorSpace_256[2].z), _2244, mad((WorkingColorSpace_256[2].y), _2243, ((WorkingColorSpace_256[2].x) * _2242)));
          float _2256 = mad(-0.21492856740951538f, _2253, mad(-0.2365107536315918f, _2250, (_2247 * 1.4514392614364624f)));
          float _2259 = mad(-0.09967592358589172f, _2253, mad(1.17622971534729f, _2250, (_2247 * -0.07655377686023712f)));
          float _2262 = mad(0.9977163076400757f, _2253, mad(-0.006032449658960104f, _2250, (_2247 * 0.008316148072481155f)));
          float _2264 = max(_2256, max(_2259, _2262));
          do {
            if (!(_2264 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2247 < 0.0f) || (bool)(_2250 < 0.0f))) || (bool)(_2253 < 0.0f))) {
                float _2274 = abs(_2264);
                float _2275 = (_2264 - _2256) / _2274;
                float _2277 = (_2264 - _2259) / _2274;
                float _2279 = (_2264 - _2262) / _2274;
                do {
                  if (!(_2275 < 0.8149999976158142f)) {
                    float _2282 = _2275 + -0.8149999976158142f;
                    _2294 = ((_2282 / exp2(log2(exp2(log2(_2282 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2294 = _2275;
                  }
                  do {
                    if (!(_2277 < 0.8029999732971191f)) {
                      float _2297 = _2277 + -0.8029999732971191f;
                      _2309 = ((_2297 / exp2(log2(exp2(log2(_2297 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2309 = _2277;
                    }
                    do {
                      if (!(_2279 < 0.8799999952316284f)) {
                        float _2312 = _2279 + -0.8799999952316284f;
                        _2324 = ((_2312 / exp2(log2(exp2(log2(_2312 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2324 = _2279;
                      }
                      _2332 = (_2264 - (_2274 * _2294));
                      _2333 = (_2264 - (_2274 * _2309));
                      _2334 = (_2264 - (_2274 * _2324));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2332 = _2256;
                _2333 = _2259;
                _2334 = _2262;
              }
            } else {
              _2332 = _2256;
              _2333 = _2259;
              _2334 = _2262;
            }
            float _2350 = ((mad(0.16386906802654266f, _2334, mad(0.14067870378494263f, _2333, (_2332 * 0.6954522132873535f))) - _2247) * cb0_012w) + _2247;
            float _2351 = ((mad(0.0955343171954155f, _2334, mad(0.8596711158752441f, _2333, (_2332 * 0.044794563204050064f))) - _2250) * cb0_012w) + _2250;
            float _2352 = ((mad(1.0015007257461548f, _2334, mad(0.004025210160762072f, _2333, (_2332 * -0.005525882821530104f))) - _2253) * cb0_012w) + _2253;
            float _2356 = max(max(_2350, _2351), _2352);
            float _2361 = (max(_2356, 1.000000013351432e-10f) - max(min(min(_2350, _2351), _2352), 1.000000013351432e-10f)) / max(_2356, 0.009999999776482582f);
            float _2374 = ((_2351 + _2350) + _2352) + (sqrt((((_2352 - _2351) * _2352) + ((_2351 - _2350) * _2351)) + ((_2350 - _2352) * _2350)) * 1.75f);
            float _2375 = _2374 * 0.3333333432674408f;
            float _2376 = _2361 + -0.4000000059604645f;
            float _2377 = _2376 * 5.0f;
            float _2381 = max((1.0f - abs(_2376 * 2.5f)), 0.0f);
            float _2392 = ((float((int)(((int)(uint)((bool)(_2377 > 0.0f))) - ((int)(uint)((bool)(_2377 < 0.0f))))) * (1.0f - (_2381 * _2381))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2375 <= 0.0533333346247673f)) {
                if (!(_2375 >= 0.1599999964237213f)) {
                  _2401 = (((0.23999999463558197f / _2374) + -0.5f) * _2392);
                } else {
                  _2401 = 0.0f;
                }
              } else {
                _2401 = _2392;
              }
              float _2402 = _2401 + 1.0f;
              float _2403 = _2402 * _2350;
              float _2404 = _2402 * _2351;
              float _2405 = _2402 * _2352;
              do {
                if (!((bool)(_2403 == _2404) && (bool)(_2404 == _2405))) {
                  float _2412 = ((_2403 * 2.0f) - _2404) - _2405;
                  float _2415 = ((_2351 - _2352) * 1.7320507764816284f) * _2402;
                  float _2417 = atan(_2415 / _2412);
                  bool _2420 = (_2412 < 0.0f);
                  bool _2421 = (_2412 == 0.0f);
                  bool _2422 = (_2415 >= 0.0f);
                  bool _2423 = (_2415 < 0.0f);
                  _2434 = select((_2422 && _2421), 90.0f, select((_2423 && _2421), -90.0f, (select((_2423 && _2420), (_2417 + -3.1415927410125732f), select((_2422 && _2420), (_2417 + 3.1415927410125732f), _2417)) * 57.2957763671875f)));
                } else {
                  _2434 = 0.0f;
                }
                float _2439 = min(max(select((_2434 < 0.0f), (_2434 + 360.0f), _2434), 0.0f), 360.0f);
                do {
                  if (_2439 < -180.0f) {
                    _2448 = (_2439 + 360.0f);
                  } else {
                    if (_2439 > 180.0f) {
                      _2448 = (_2439 + -360.0f);
                    } else {
                      _2448 = _2439;
                    }
                  }
                  do {
                    if ((bool)(_2448 > -67.5f) && (bool)(_2448 < 67.5f)) {
                      float _2454 = (_2448 + 67.5f) * 0.029629629105329514f;
                      int _2455 = int(_2454);
                      float _2457 = _2454 - float((int)(_2455));
                      float _2458 = _2457 * _2457;
                      float _2459 = _2458 * _2457;
                      if (_2455 == 3) {
                        _2487 = (((0.1666666716337204f - (_2457 * 0.5f)) + (_2458 * 0.5f)) - (_2459 * 0.1666666716337204f));
                      } else {
                        if (_2455 == 2) {
                          _2487 = ((0.6666666865348816f - _2458) + (_2459 * 0.5f));
                        } else {
                          if (_2455 == 1) {
                            _2487 = (((_2459 * -0.5f) + 0.1666666716337204f) + ((_2458 + _2457) * 0.5f));
                          } else {
                            _2487 = select((_2455 == 0), (_2459 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2487 = 0.0f;
                    }
                    float _2496 = min(max(((((_2361 * 0.27000001072883606f) * (0.029999999329447746f - _2403)) * _2487) + _2403), 0.0f), 65535.0f);
                    float _2497 = min(max(_2404, 0.0f), 65535.0f);
                    float _2498 = min(max(_2405, 0.0f), 65535.0f);
                    float _2511 = min(max(mad(-0.21492856740951538f, _2498, mad(-0.2365107536315918f, _2497, (_2496 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2512 = min(max(mad(-0.09967592358589172f, _2498, mad(1.17622971534729f, _2497, (_2496 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2513 = min(max(mad(0.9977163076400757f, _2498, mad(-0.006032449658960104f, _2497, (_2496 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2514 = dot(float3(_2511, _2512, _2513), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2537 = log2(max((lerp(_2514, _2511, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2538 = _2537 * 0.3010300099849701f;
                    float _2539 = log2(cb0_008x);
                    float _2540 = _2539 * 0.3010300099849701f;
                    do {
                      if (!(!(_2538 <= _2540))) {
                        _2609 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2547 = log2(cb0_009x);
                        float _2548 = _2547 * 0.3010300099849701f;
                        if ((bool)(_2538 > _2540) && (bool)(_2538 < _2548)) {
                          float _2556 = ((_2537 - _2539) * 0.9030900001525879f) / ((_2547 - _2539) * 0.3010300099849701f);
                          int _2557 = int(_2556);
                          float _2559 = _2556 - float((int)(_2557));
                          float _2561 = _19[_2557];
                          float _2564 = _19[(_2557 + 1)];
                          float _2569 = _2561 * 0.5f;
                          _2609 = dot(float3((_2559 * _2559), _2559, 1.0f), float3(mad((_19[(_2557 + 2)]), 0.5f, mad(_2564, -1.0f, _2569)), (_2564 - _2561), mad(_2564, 0.5f, _2569)));
                        } else {
                          do {
                            if (!(!(_2538 >= _2548))) {
                              float _2578 = log2(cb0_008z);
                              if (_2538 < (_2578 * 0.3010300099849701f)) {
                                float _2586 = ((_2537 - _2547) * 0.9030900001525879f) / ((_2578 - _2547) * 0.3010300099849701f);
                                int _2587 = int(_2586);
                                float _2589 = _2586 - float((int)(_2587));
                                float _2591 = _20[_2587];
                                float _2594 = _20[(_2587 + 1)];
                                float _2599 = _2591 * 0.5f;
                                _2609 = dot(float3((_2589 * _2589), _2589, 1.0f), float3(mad((_20[(_2587 + 2)]), 0.5f, mad(_2594, -1.0f, _2599)), (_2594 - _2591), mad(_2594, 0.5f, _2599)));
                                break;
                              }
                            }
                            _2609 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _2625 = log2(max((lerp(_2514, _2512, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2626 = _2625 * 0.3010300099849701f;
                      do {
                        if (!(!(_2626 <= _2540))) {
                          _2695 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2633 = log2(cb0_009x);
                          float _2634 = _2633 * 0.3010300099849701f;
                          if ((bool)(_2626 > _2540) && (bool)(_2626 < _2634)) {
                            float _2642 = ((_2625 - _2539) * 0.9030900001525879f) / ((_2633 - _2539) * 0.3010300099849701f);
                            int _2643 = int(_2642);
                            float _2645 = _2642 - float((int)(_2643));
                            float _2647 = _13[_2643];
                            float _2650 = _13[(_2643 + 1)];
                            float _2655 = _2647 * 0.5f;
                            _2695 = dot(float3((_2645 * _2645), _2645, 1.0f), float3(mad((_13[(_2643 + 2)]), 0.5f, mad(_2650, -1.0f, _2655)), (_2650 - _2647), mad(_2650, 0.5f, _2655)));
                          } else {
                            do {
                              if (!(!(_2626 >= _2634))) {
                                float _2664 = log2(cb0_008z);
                                if (_2626 < (_2664 * 0.3010300099849701f)) {
                                  float _2672 = ((_2625 - _2633) * 0.9030900001525879f) / ((_2664 - _2633) * 0.3010300099849701f);
                                  int _2673 = int(_2672);
                                  float _2675 = _2672 - float((int)(_2673));
                                  float _2677 = _14[_2673];
                                  float _2680 = _14[(_2673 + 1)];
                                  float _2685 = _2677 * 0.5f;
                                  _2695 = dot(float3((_2675 * _2675), _2675, 1.0f), float3(mad((_14[(_2673 + 2)]), 0.5f, mad(_2680, -1.0f, _2685)), (_2680 - _2677), mad(_2680, 0.5f, _2685)));
                                  break;
                                }
                              }
                              _2695 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2711 = log2(max((lerp(_2514, _2513, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2712 = _2711 * 0.3010300099849701f;
                        do {
                          if (!(!(_2712 <= _2540))) {
                            _2781 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2719 = log2(cb0_009x);
                            float _2720 = _2719 * 0.3010300099849701f;
                            if ((bool)(_2712 > _2540) && (bool)(_2712 < _2720)) {
                              float _2728 = ((_2711 - _2539) * 0.9030900001525879f) / ((_2719 - _2539) * 0.3010300099849701f);
                              int _2729 = int(_2728);
                              float _2731 = _2728 - float((int)(_2729));
                              float _2733 = _17[_2729];
                              float _2736 = _17[(_2729 + 1)];
                              float _2741 = _2733 * 0.5f;
                              _2781 = dot(float3((_2731 * _2731), _2731, 1.0f), float3(mad((_17[(_2729 + 2)]), 0.5f, mad(_2736, -1.0f, _2741)), (_2736 - _2733), mad(_2736, 0.5f, _2741)));
                            } else {
                              do {
                                if (!(!(_2712 >= _2720))) {
                                  float _2750 = log2(cb0_008z);
                                  if (_2712 < (_2750 * 0.3010300099849701f)) {
                                    float _2758 = ((_2711 - _2719) * 0.9030900001525879f) / ((_2750 - _2719) * 0.3010300099849701f);
                                    int _2759 = int(_2758);
                                    float _2761 = _2758 - float((int)(_2759));
                                    float _2763 = _18[_2759];
                                    float _2766 = _18[(_2759 + 1)];
                                    float _2771 = _2763 * 0.5f;
                                    _2781 = dot(float3((_2761 * _2761), _2761, 1.0f), float3(mad((_18[(_2759 + 2)]), 0.5f, mad(_2766, -1.0f, _2771)), (_2766 - _2763), mad(_2766, 0.5f, _2771)));
                                    break;
                                  }
                                }
                                _2781 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2785 = cb0_008w - cb0_008y;
                          float _2786 = (exp2(_2609 * 3.321928024291992f) - cb0_008y) / _2785;
                          float _2788 = (exp2(_2695 * 3.321928024291992f) - cb0_008y) / _2785;
                          float _2790 = (exp2(_2781 * 3.321928024291992f) - cb0_008y) / _2785;
                          float _2793 = mad(0.15618768334388733f, _2790, mad(0.13400420546531677f, _2788, (_2786 * 0.6624541878700256f)));
                          float _2796 = mad(0.053689517080783844f, _2790, mad(0.6740817427635193f, _2788, (_2786 * 0.2722287178039551f)));
                          float _2799 = mad(1.0103391408920288f, _2790, mad(0.00406073359772563f, _2788, (_2786 * -0.005574649665504694f)));
                          float _2812 = min(max(mad(-0.23642469942569733f, _2799, mad(-0.32480329275131226f, _2796, (_2793 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2813 = min(max(mad(0.016756348311901093f, _2799, mad(1.6153316497802734f, _2796, (_2793 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2814 = min(max(mad(0.9883948564529419f, _2799, mad(-0.008284442126750946f, _2796, (_2793 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2817 = mad(0.15618768334388733f, _2814, mad(0.13400420546531677f, _2813, (_2812 * 0.6624541878700256f)));
                          float _2820 = mad(0.053689517080783844f, _2814, mad(0.6740817427635193f, _2813, (_2812 * 0.2722287178039551f)));
                          float _2823 = mad(1.0103391408920288f, _2814, mad(0.00406073359772563f, _2813, (_2812 * -0.005574649665504694f)));
                          float _2845 = min(max((min(max(mad(-0.23642469942569733f, _2823, mad(-0.32480329275131226f, _2820, (_2817 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2846 = min(max((min(max(mad(0.016756348311901093f, _2823, mad(1.6153316497802734f, _2820, (_2817 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2847 = min(max((min(max(mad(0.9883948564529419f, _2823, mad(-0.008284442126750946f, _2820, (_2817 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2860 = mad(_66, _2847, mad(_65, _2846, (_2845 * _64)));
                              _2861 = mad(_69, _2847, mad(_68, _2846, (_2845 * _67)));
                              _2862 = mad(_72, _2847, mad(_71, _2846, (_2845 * _70)));
                            } else {
                              _2860 = _2845;
                              _2861 = _2846;
                              _2862 = _2847;
                            }
                            float _2872 = exp2(log2(_2860 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2873 = exp2(log2(_2861 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2874 = exp2(log2(_2862 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _3039 = exp2(log2((1.0f / ((_2872 * 18.6875f) + 1.0f)) * ((_2872 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3040 = exp2(log2((1.0f / ((_2873 * 18.6875f) + 1.0f)) * ((_2873 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _3041 = exp2(log2((1.0f / ((_2874 * 18.6875f) + 1.0f)) * ((_2874 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2919 = mad((WorkingColorSpace_128[0].z), _1363, mad((WorkingColorSpace_128[0].y), _1362, ((WorkingColorSpace_128[0].x) * _1361)));
            float _2922 = mad((WorkingColorSpace_128[1].z), _1363, mad((WorkingColorSpace_128[1].y), _1362, ((WorkingColorSpace_128[1].x) * _1361)));
            float _2925 = mad((WorkingColorSpace_128[2].z), _1363, mad((WorkingColorSpace_128[2].y), _1362, ((WorkingColorSpace_128[2].x) * _1361)));
            float _2944 = exp2(log2(mad(_66, _2925, mad(_65, _2922, (_2919 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2945 = exp2(log2(mad(_69, _2925, mad(_68, _2922, (_2919 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2946 = exp2(log2(mad(_72, _2925, mad(_71, _2922, (_2919 * _70))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _3039 = exp2(log2((1.0f / ((_2944 * 18.6875f) + 1.0f)) * ((_2944 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3040 = exp2(log2((1.0f / ((_2945 * 18.6875f) + 1.0f)) * ((_2945 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _3041 = exp2(log2((1.0f / ((_2946 * 18.6875f) + 1.0f)) * ((_2946 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2993 = mad((WorkingColorSpace_128[0].z), _1351, mad((WorkingColorSpace_128[0].y), _1350, ((WorkingColorSpace_128[0].x) * _1349)));
                float _2996 = mad((WorkingColorSpace_128[1].z), _1351, mad((WorkingColorSpace_128[1].y), _1350, ((WorkingColorSpace_128[1].x) * _1349)));
                float _2999 = mad((WorkingColorSpace_128[2].z), _1351, mad((WorkingColorSpace_128[2].y), _1350, ((WorkingColorSpace_128[2].x) * _1349)));
                _3039 = mad(_66, _2999, mad(_65, _2996, (_2993 * _64)));
                _3040 = mad(_69, _2999, mad(_68, _2996, (_2993 * _67)));
                _3041 = mad(_72, _2999, mad(_71, _2996, (_2993 * _70)));
              } else {
                float _3012 = mad((WorkingColorSpace_128[0].z), _1377, mad((WorkingColorSpace_128[0].y), _1376, ((WorkingColorSpace_128[0].x) * _1375)));
                float _3015 = mad((WorkingColorSpace_128[1].z), _1377, mad((WorkingColorSpace_128[1].y), _1376, ((WorkingColorSpace_128[1].x) * _1375)));
                float _3018 = mad((WorkingColorSpace_128[2].z), _1377, mad((WorkingColorSpace_128[2].y), _1376, ((WorkingColorSpace_128[2].x) * _1375)));
                _3039 = exp2(log2(mad(_66, _3018, mad(_65, _3015, (_3012 * _64)))) * cb0_040z);
                _3040 = exp2(log2(mad(_69, _3018, mad(_68, _3015, (_3012 * _67)))) * cb0_040z);
                _3041 = exp2(log2(mad(_72, _3018, mad(_71, _3015, (_3012 * _70)))) * cb0_040z);
              }
            } else {
              _3039 = _1361;
              _3040 = _1362;
              _3041 = _1363;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_3039 * 0.9523810148239136f), (_3040 * 0.9523810148239136f), (_3041 * 0.9523810148239136f), 0.0f);
}
