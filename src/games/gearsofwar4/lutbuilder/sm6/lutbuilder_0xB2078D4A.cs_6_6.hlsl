// From Halo Campaign Evolved

#include "../lutbuilderoutput.hlsli"

RWTexture3D<float4> u0 : register(u0);

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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _20;
  float _25;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _120;
  float _827;
  float _860;
  float _874;
  float _938;
  float _1190;
  float _1191;
  float _1192;
  float _1203;
  float _1214;
  float _1225;
  bool _38;
  float _70;
  float _71;
  float _72;
  bool _99;
  float _103;
  float _134;
  float _141;
  float _144;
  float _149;
  float _150;
  float _152;
  bool _153;
  float _162;
  float _164;
  float _171;
  float _173;
  float _175;
  float _176;
  float _179;
  float _182;
  float _187;
  float _193;
  float _194;
  float _195;
  float _196;
  float _197;
  float _198;
  float _199;
  float _200;
  float _203;
  float _204;
  float _205;
  float _208;
  float _227;
  float _228;
  float _229;
  float _230;
  float _231;
  float _232;
  float _233;
  float _234;
  float _235;
  float _238;
  float _241;
  float _244;
  float _247;
  float _250;
  float _253;
  float _256;
  float _259;
  float _262;
  float _265;
  float _268;
  float _271;
  float _274;
  float _277;
  float _280;
  float _283;
  float _286;
  float _289;
  float _319;
  float _322;
  float _325;
  float _340;
  float _343;
  float _346;
  float _347;
  float _351;
  float _352;
  float _353;
  float _365;
  float _381;
  float _382;
  float _383;
  float _384;
  float _398;
  float _412;
  float _426;
  float _440;
  float _454;
  float _458;
  float _459;
  float _460;
  float _517;
  float _521;
  float _522;
  float _531;
  float _540;
  float _549;
  float _558;
  float _567;
  float _630;
  float _634;
  float _643;
  float _652;
  float _661;
  float _670;
  float _679;
  float _737;
  float _748;
  float _750;
  float _752;
  float _767;
  float _768;
  float _769;
  float _772;
  float _775;
  float _778;
  float _782;
  float _787;
  float _800;
  float _801;
  float _802;
  float _803;
  float _807;
  float _818;
  float _828;
  float _829;
  float _830;
  float _831;
  float _838;
  float _841;
  float _843;
  bool _846;
  bool _847;
  bool _848;
  bool _849;
  float _865;
  float _878;
  float _882;
  float _888;
  float _898;
  float _899;
  float _900;
  float _901;
  float _916;
  float _918;
  float _920;
  float _929;
  float _941;
  float _943;
  float _947;
  float _948;
  float _949;
  float _953;
  float _954;
  float _955;
  float _956;
  float _958;
  float _959;
  float _960;
  float _961;
  float _980;
  float _982;
  float _1007;
  float _1008;
  float _1009;
  float _1016;
  float _1020;
  float _1021;
  float _1022;
  bool _1023;
  float _1027;
  float _1028;
  float _1029;
  float _1048;
  float _1049;
  float _1050;
  float _1051;
  float _1071;
  float _1072;
  float _1073;
  float _1089;
  float _1090;
  float _1091;
  float _1113;
  float _1114;
  float _1115;
  float _1141;
  float _1142;
  float _1143;
  float _1164;
  float _1165;
  float _1166;
  float _1173;
  float _1176;
  float _1179;
  _20 = 0.5f / cb0_035x;
  _25 = cb0_035x + -1.0f;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        _38 = (cb0_041x == 4);
        _49 = select(_38, 1.0f, 1.705051064491272f);
        _50 = select(_38, 0.0f, -0.6217921376228333f);
        _51 = select(_38, 0.0f, -0.0832589864730835f);
        _52 = select(_38, 0.0f, -0.13025647401809692f);
        _53 = select(_38, 1.0f, 1.140804648399353f);
        _54 = select(_38, 0.0f, -0.010548308491706848f);
        _55 = select(_38, 0.0f, -0.024003351107239723f);
        _56 = select(_38, 0.0f, -0.1289689838886261f);
        _57 = select(_38, 1.0f, 1.1529725790023804f);
      } else {
        _49 = 0.6954522132873535f;
        _50 = 0.14067870378494263f;
        _51 = 0.16386906802654266f;
        _52 = 0.044794563204050064f;
        _53 = 0.8596711158752441f;
        _54 = 0.0955343171954155f;
        _55 = -0.005525882821530104f;
        _56 = 0.004025210160762072f;
        _57 = 1.0015007257461548f;
      }
    } else {
      _49 = 1.0258246660232544f;
      _50 = -0.020053181797266006f;
      _51 = -0.005771636962890625f;
      _52 = -0.002234415616840124f;
      _53 = 1.0045864582061768f;
      _54 = -0.002352118492126465f;
      _55 = -0.005013350863009691f;
      _56 = -0.025290070101618767f;
      _57 = 1.0303035974502563f;
    }
  } else {
    _49 = 1.3792141675949097f;
    _50 = -0.30886411666870117f;
    _51 = -0.0703500509262085f;
    _52 = -0.06933490186929703f;
    _53 = 1.08229660987854f;
    _54 = -0.012961871922016144f;
    _55 = -0.0021590073592960835f;
    _56 = -0.0454593189060688f;
    _57 = 1.0476183891296387f;
  }
  _70 = (exp2((((cb0_035x * ((cb0_042x * (((float)((uint)SV_DispatchThreadID.x)) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _71 = (exp2((((cb0_035x * ((cb0_042y * (((float)((uint)SV_DispatchThreadID.y)) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _72 = (exp2(((((float)((uint)SV_DispatchThreadID.z)) / _25) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _99 = (cb0_038w != 0);
  _103 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _120 = (((((2967800.0f - (_103 * 4607000064.0f)) * _103) + 99.11000061035156f) * _103) + 0.24406300485134125f);
  } else {
    _120 = (((((1901800.0f - (_103 * 2006400000.0f)) * _103) + 247.47999572753906f) * _103) + 0.23703999817371368f);
  }
  _134 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  _141 = cb0_035y * cb0_035y;
  _144 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_141 * 1.6145605741257896e-07f));
  _149 = ((_134 * 2.0f) + 4.0f) - (_144 * 8.0f);
  _150 = (_134 * 3.0f) / _149;
  _152 = (_144 * 2.0f) / _149;
  _153 = (cb0_035y < 4000.0f);
  _162 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  _164 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_141 * 1.5317699909210205f)) / (_162 * _162);
  _171 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _141;
  _173 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_141 * 308.60699462890625f)) / (_171 * _171);
  _175 = rsqrt(dot(float2(_164, _173), float2(_164, _173)));
  _176 = cb0_035z * 0.05000000074505806f;
  _179 = ((_176 * _173) * _175) + _134;
  _182 = _144 - ((_176 * _164) * _175);
  _187 = (4.0f - (_182 * 8.0f)) + (_179 * 2.0f);
  _193 = (((_179 * 3.0f) / _187) - _150) + select(_153, _150, _120);
  _194 = (((_182 * 2.0f) / _187) - _152) + select(_153, _152, (((_120 * 2.869999885559082f) + -0.2750000059604645f) - ((_120 * _120) * 3.0f)));
  _195 = select(_99, _193, 0.3127000033855438f);
  _196 = select(_99, _194, 0.32899999618530273f);
  _197 = select(_99, 0.3127000033855438f, _193);
  _198 = select(_99, 0.32899999618530273f, _194);
  _199 = max(_196, 1.000000013351432e-10f);
  _200 = _195 / _199;
  _203 = ((1.0f - _195) - _196) / _199;
  _204 = max(_198, 1.000000013351432e-10f);
  _205 = _197 / _204;
  _208 = ((1.0f - _197) - _198) / _204;
  _227 = mad(-0.16140000522136688f, _208, ((_205 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _203, ((_200 * 0.8950999975204468f) + 0.266400009393692f));
  _228 = mad(0.03669999912381172f, _208, (1.7135000228881836f - (_205 * 0.7501999735832214f))) / mad(0.03669999912381172f, _203, (1.7135000228881836f - (_200 * 0.7501999735832214f)));
  _229 = mad(1.0296000242233276f, _208, ((_205 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _203, ((_200 * 0.03889999911189079f) + -0.06849999725818634f));
  _230 = mad(_228, -0.7501999735832214f, 0.0f);
  _231 = mad(_228, 1.7135000228881836f, 0.0f);
  _232 = mad(_228, 0.03669999912381172f, -0.0f);
  _233 = mad(_229, 0.03889999911189079f, 0.0f);
  _234 = mad(_229, -0.06849999725818634f, 0.0f);
  _235 = mad(_229, 1.0296000242233276f, 0.0f);
  _238 = mad(0.1599626988172531f, _233, mad(-0.1470542997121811f, _230, (_227 * 0.883457362651825f)));
  _241 = mad(0.1599626988172531f, _234, mad(-0.1470542997121811f, _231, (_227 * 0.26293492317199707f)));
  _244 = mad(0.1599626988172531f, _235, mad(-0.1470542997121811f, _232, (_227 * -0.15930065512657166f)));
  _247 = mad(0.04929120093584061f, _233, mad(0.5183603167533875f, _230, (_227 * 0.38695648312568665f)));
  _250 = mad(0.04929120093584061f, _234, mad(0.5183603167533875f, _231, (_227 * 0.11516613513231277f)));
  _253 = mad(0.04929120093584061f, _235, mad(0.5183603167533875f, _232, (_227 * -0.0697740763425827f)));
  _256 = mad(0.9684867262840271f, _233, mad(0.04004279896616936f, _230, (_227 * -0.007634039502590895f)));
  _259 = mad(0.9684867262840271f, _234, mad(0.04004279896616936f, _231, (_227 * -0.0022720457054674625f)));
  _262 = mad(0.9684867262840271f, _235, mad(0.04004279896616936f, _232, (_227 * 0.0013765322510153055f)));
  _265 = mad(_244, (WorkingColorSpace_000[2].x), mad(_241, (WorkingColorSpace_000[1].x), (_238 * (WorkingColorSpace_000[0].x))));
  _268 = mad(_244, (WorkingColorSpace_000[2].y), mad(_241, (WorkingColorSpace_000[1].y), (_238 * (WorkingColorSpace_000[0].y))));
  _271 = mad(_244, (WorkingColorSpace_000[2].z), mad(_241, (WorkingColorSpace_000[1].z), (_238 * (WorkingColorSpace_000[0].z))));
  _274 = mad(_253, (WorkingColorSpace_000[2].x), mad(_250, (WorkingColorSpace_000[1].x), (_247 * (WorkingColorSpace_000[0].x))));
  _277 = mad(_253, (WorkingColorSpace_000[2].y), mad(_250, (WorkingColorSpace_000[1].y), (_247 * (WorkingColorSpace_000[0].y))));
  _280 = mad(_253, (WorkingColorSpace_000[2].z), mad(_250, (WorkingColorSpace_000[1].z), (_247 * (WorkingColorSpace_000[0].z))));
  _283 = mad(_262, (WorkingColorSpace_000[2].x), mad(_259, (WorkingColorSpace_000[1].x), (_256 * (WorkingColorSpace_000[0].x))));
  _286 = mad(_262, (WorkingColorSpace_000[2].y), mad(_259, (WorkingColorSpace_000[1].y), (_256 * (WorkingColorSpace_000[0].y))));
  _289 = mad(_262, (WorkingColorSpace_000[2].z), mad(_259, (WorkingColorSpace_000[1].z), (_256 * (WorkingColorSpace_000[0].z))));
  _319 = mad(mad((WorkingColorSpace_064[0].z), _289, mad((WorkingColorSpace_064[0].y), _280, (_271 * (WorkingColorSpace_064[0].x)))), _72, mad(mad((WorkingColorSpace_064[0].z), _286, mad((WorkingColorSpace_064[0].y), _277, (_268 * (WorkingColorSpace_064[0].x)))), _71, (mad((WorkingColorSpace_064[0].z), _283, mad((WorkingColorSpace_064[0].y), _274, (_265 * (WorkingColorSpace_064[0].x)))) * _70)));
  _322 = mad(mad((WorkingColorSpace_064[1].z), _289, mad((WorkingColorSpace_064[1].y), _280, (_271 * (WorkingColorSpace_064[1].x)))), _72, mad(mad((WorkingColorSpace_064[1].z), _286, mad((WorkingColorSpace_064[1].y), _277, (_268 * (WorkingColorSpace_064[1].x)))), _71, (mad((WorkingColorSpace_064[1].z), _283, mad((WorkingColorSpace_064[1].y), _274, (_265 * (WorkingColorSpace_064[1].x)))) * _70)));
  _325 = mad(mad((WorkingColorSpace_064[2].z), _289, mad((WorkingColorSpace_064[2].y), _280, (_271 * (WorkingColorSpace_064[2].x)))), _72, mad(mad((WorkingColorSpace_064[2].z), _286, mad((WorkingColorSpace_064[2].y), _277, (_268 * (WorkingColorSpace_064[2].x)))), _71, (mad((WorkingColorSpace_064[2].z), _283, mad((WorkingColorSpace_064[2].y), _274, (_265 * (WorkingColorSpace_064[2].x)))) * _70)));
  _340 = mad((WorkingColorSpace_128[0].z), _325, mad((WorkingColorSpace_128[0].y), _322, ((WorkingColorSpace_128[0].x) * _319)));
  _343 = mad((WorkingColorSpace_128[1].z), _325, mad((WorkingColorSpace_128[1].y), _322, ((WorkingColorSpace_128[1].x) * _319)));
  _346 = mad((WorkingColorSpace_128[2].z), _325, mad((WorkingColorSpace_128[2].y), _322, ((WorkingColorSpace_128[2].x) * _319)));
  _347 = dot(float3(_340, _343, _346), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _351 = (_340 / _347) + -1.0f;
  _352 = (_343 / _347) + -1.0f;
  _353 = (_346 / _347) + -1.0f;
  // ExpandGamut set to 0
  _365 = (1.0f - exp2(((_347 * _347) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_351, _352, _353), float3(_351, _352, _353)) * -4.0f));
  _381 = ((mad(-0.06368321925401688f, _346, mad(-0.3292922377586365f, _343, (_340 * 1.3704125881195068f))) - _340) * _365) + _340;
  _382 = ((mad(-0.010861365124583244f, _346, mad(1.0970927476882935f, _343, (_340 * -0.08343357592821121f))) - _343) * _365) + _343;
  _383 = ((mad(1.2036951780319214f, _346, mad(-0.09862580895423889f, _343, (_340 * -0.02579331398010254f))) - _346) * _365) + _346;
  _384 = dot(float3(_381, _382, _383), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _398 = cb0_019w + cb0_024w;
  _412 = cb0_018w * cb0_023w;
  _426 = cb0_017w * cb0_022w;
  _440 = cb0_016w * cb0_021w;
  _454 = cb0_015w * cb0_020w;
  _458 = _381 - _384;
  _459 = _382 - _384;
  _460 = _383 - _384;
  _517 = saturate(_384 / cb0_035w);
  _521 = (_517 * _517) * (3.0f - (_517 * 2.0f));
  _522 = 1.0f - _521;
  _531 = cb0_019w + cb0_034w;
  _540 = cb0_018w * cb0_033w;
  _549 = cb0_017w * cb0_032w;
  _558 = cb0_016w * cb0_031w;
  _567 = cb0_015w * cb0_030w;
  _630 = saturate((_384 - cb0_036x) / (cb0_036y - cb0_036x));
  _634 = (_630 * _630) * (3.0f - (_630 * 2.0f));
  _643 = cb0_019w + cb0_029w;
  _652 = cb0_018w * cb0_028w;
  _661 = cb0_017w * cb0_027w;
  _670 = cb0_016w * cb0_026w;
  _679 = cb0_015w * cb0_025w;
  _737 = _521 - _634;
  _748 = ((_634 * (((cb0_019x + cb0_034x) + _531) + (((cb0_018x * cb0_033x) * _540) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _558) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _567) * _458) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _549)))))) + (_522 * (((cb0_019x + cb0_024x) + _398) + (((cb0_018x * cb0_023x) * _412) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _440) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _454) * _458) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _426))))))) + ((((cb0_019x + cb0_029x) + _643) + (((cb0_018x * cb0_028x) * _652) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _670) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _679) * _458) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _661))))) * _737);
  _750 = ((_634 * (((cb0_019y + cb0_034y) + _531) + (((cb0_018y * cb0_033y) * _540) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _558) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _567) * _459) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _549)))))) + (_522 * (((cb0_019y + cb0_024y) + _398) + (((cb0_018y * cb0_023y) * _412) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _440) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _454) * _459) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _426))))))) + ((((cb0_019y + cb0_029y) + _643) + (((cb0_018y * cb0_028y) * _652) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _670) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _679) * _459) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _661))))) * _737);
  _752 = ((_634 * (((cb0_019z + cb0_034z) + _531) + (((cb0_018z * cb0_033z) * _540) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _558) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _567) * _460) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _549)))))) + (_522 * (((cb0_019z + cb0_024z) + _398) + (((cb0_018z * cb0_023z) * _412) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _440) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _454) * _460) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _426))))))) + ((((cb0_019z + cb0_029z) + _643) + (((cb0_018z * cb0_028z) * _652) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _670) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _679) * _460) + _384)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _661))))) * _737);
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

  float4 output = ProcessLutbuilder(float3(_748, _750, _752), cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], 3u);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _767 = ((mad(0.061360642313957214f, _752, mad(-4.540197551250458e-09f, _750, (_748 * 0.9386394023895264f))) - _748) * cb0_036z) + _748;
  _768 = ((mad(0.169205904006958f, _752, mad(0.8307942152023315f, _750, (_748 * 6.775371730327606e-08f))) - _750) * cb0_036z) + _750;
  _769 = (mad(-2.3283064365386963e-10f, _750, (_748 * -9.313225746154785e-10f)) * cb0_036z) + _752;
  _772 = mad(0.16386905312538147f, _769, mad(0.14067868888378143f, _768, (_767 * 0.6954522132873535f)));
  _775 = mad(0.0955343246459961f, _769, mad(0.8596711158752441f, _768, (_767 * 0.044794581830501556f)));
  _778 = mad(1.0015007257461548f, _769, mad(0.004025210160762072f, _768, (_767 * -0.005525882821530104f)));
  _782 = max(max(_772, _775), _778);
  _787 = (max(_782, 1.000000013351432e-10f) - max(min(min(_772, _775), _778), 1.000000013351432e-10f)) / max(_782, 0.009999999776482582f);
  _800 = ((_775 + _772) + _778) + (sqrt((((_778 - _775) * _778) + ((_775 - _772) * _775)) + ((_772 - _778) * _772)) * 1.75f);
  _801 = _800 * 0.3333333432674408f;
  _802 = _787 + -0.4000000059604645f;
  _803 = _802 * 5.0f;
  _807 = max((1.0f - abs(_802 * 2.5f)), 0.0f);
  _818 = ((float((int)(((int)(uint)((int)(_803 > 0.0f))) - ((int)(uint)((int)(_803 < 0.0f))))) * (1.0f - (_807 * _807))) + 1.0f) * 0.02500000037252903f;
  if (!(_801 <= 0.0533333346247673f)) {
    if (!(_801 >= 0.1599999964237213f)) {
      _827 = (((0.23999999463558197f / _800) + -0.5f) * _818);
    } else {
      _827 = 0.0f;
    }
  } else {
    _827 = _818;
  }
  _828 = _827 + 1.0f;
  _829 = _828 * _772;
  _830 = _828 * _775;
  _831 = _828 * _778;
  if (!((_829 == _830) && (_830 == _831))) {
    _838 = ((_829 * 2.0f) - _830) - _831;
    _841 = ((_775 - _778) * 1.7320507764816284f) * _828;
    _843 = atan(_841 / _838);
    _846 = (_838 < 0.0f);
    _847 = (_838 == 0.0f);
    _848 = (_841 >= 0.0f);
    _849 = (_841 < 0.0f);
    _860 = select((_848 && _847), 90.0f, select((_849 && _847), -90.0f, (select((_849 && _846), (_843 + -3.1415927410125732f), select((_848 && _846), (_843 + 3.1415927410125732f), _843)) * 57.2957763671875f)));
  } else {
    _860 = 0.0f;
  }
  _865 = min(max(select((_860 < 0.0f), (_860 + 360.0f), _860), 0.0f), 360.0f);
  if (_865 < -180.0f) {
    _874 = (_865 + 360.0f);
  } else {
    if (_865 > 180.0f) {
      _874 = (_865 + -360.0f);
    } else {
      _874 = _865;
    }
  }
  _878 = saturate(1.0f - abs(_874 * 0.014814814552664757f));
  _882 = (_878 * _878) * (3.0f - (_878 * 2.0f));
  _888 = ((_882 * _882) * ((_787 * 0.18000000715255737f) * (0.029999999329447746f - _829))) + _829;
  _898 = max(0.0f, mad(-0.21492856740951538f, _831, mad(-0.2365107536315918f, _830, (_888 * 1.4514392614364624f))));
  _899 = max(0.0f, mad(-0.09967592358589172f, _831, mad(1.17622971534729f, _830, (_888 * -0.07655377686023712f))));
  _900 = max(0.0f, mad(0.9977163076400757f, _831, mad(-0.006032449658960104f, _830, (_888 * 0.008316148072481155f))));
  _901 = dot(float3(_898, _899, _900), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _916 = (cb0_038x + 1.0f) - cb0_037z;
  _918 = cb0_038y + 1.0f;
  _920 = _918 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _938 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _929 = (cb0_038x + 0.18000000715255737f) / _916;
    _938 = (-0.7447274923324585f - ((log2(_929 / (2.0f - _929)) * 0.3465735912322998f) * (_916 / cb0_037y)));
  }
  _941 = ((1.0f - cb0_037z) / cb0_037y) - _938;
  _943 = (cb0_037w / cb0_037y) - _941;
  _947 = log2(lerp(_901, _898, 0.9599999785423279f)) * 0.3010300099849701f;
  _948 = log2(lerp(_901, _899, 0.9599999785423279f)) * 0.3010300099849701f;
  _949 = log2(lerp(_901, _900, 0.9599999785423279f)) * 0.3010300099849701f;
  _953 = cb0_037y * (_947 + _941);
  _954 = cb0_037y * (_948 + _941);
  _955 = cb0_037y * (_949 + _941);
  _956 = _916 * 2.0f;
  _958 = (cb0_037y * -2.0f) / _916;
  _959 = _947 - _938;
  _960 = _948 - _938;
  _961 = _949 - _938;
  _980 = _920 * 2.0f;
  _982 = (cb0_037y * 2.0f) / _920;
  _1007 = select((_947 < _938), ((_956 / (exp2((_959 * 1.4426950216293335f) * _958) + 1.0f)) - cb0_038x), _953);
  _1008 = select((_948 < _938), ((_956 / (exp2((_960 * 1.4426950216293335f) * _958) + 1.0f)) - cb0_038x), _954);
  _1009 = select((_949 < _938), ((_956 / (exp2((_961 * 1.4426950216293335f) * _958) + 1.0f)) - cb0_038x), _955);
  _1016 = _943 - _938;
  _1020 = saturate(_959 / _1016);
  _1021 = saturate(_960 / _1016);
  _1022 = saturate(_961 / _1016);
  _1023 = (_943 < _938);
  _1027 = select(_1023, (1.0f - _1020), _1020);
  _1028 = select(_1023, (1.0f - _1021), _1021);
  _1029 = select(_1023, (1.0f - _1022), _1022);
  _1048 = (((_1027 * _1027) * (select((_947 > _943), (_918 - (_980 / (exp2(((_947 - _943) * 1.4426950216293335f) * _982) + 1.0f))), _953) - _1007)) * (3.0f - (_1027 * 2.0f))) + _1007;
  _1049 = (((_1028 * _1028) * (select((_948 > _943), (_918 - (_980 / (exp2(((_948 - _943) * 1.4426950216293335f) * _982) + 1.0f))), _954) - _1008)) * (3.0f - (_1028 * 2.0f))) + _1008;
  _1050 = (((_1029 * _1029) * (select((_949 > _943), (_918 - (_980 / (exp2(((_949 - _943) * 1.4426950216293335f) * _982) + 1.0f))), _955) - _1009)) * (3.0f - (_1029 * 2.0f))) + _1009;
  _1051 = dot(float3(_1048, _1049, _1050), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1071 = (cb0_037x * (max(0.0f, (lerp(_1051, _1048, 0.9300000071525574f))) - _767)) + _767;
  _1072 = (cb0_037x * (max(0.0f, (lerp(_1051, _1049, 0.9300000071525574f))) - _768)) + _768;
  _1073 = (cb0_037x * (max(0.0f, (lerp(_1051, _1050, 0.9300000071525574f))) - _769)) + _769;
  _1089 = ((mad(-0.06537103652954102f, _1073, mad(1.451815478503704e-06f, _1072, (_1071 * 1.065374732017517f))) - _1071) * cb0_036z) + _1071;
  _1090 = ((mad(-0.20366770029067993f, _1073, mad(1.2036634683609009f, _1072, (_1071 * -2.57161445915699e-07f))) - _1072) * cb0_036z) + _1072;
  _1091 = ((mad(0.9999996423721313f, _1073, mad(2.0954757928848267e-08f, _1072, (_1071 * 1.862645149230957e-08f))) - _1073) * cb0_036z) + _1073;
  _1113 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1091, mad((WorkingColorSpace_192[0].y), _1090, ((WorkingColorSpace_192[0].x) * _1089))));
  _1114 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1091, mad((WorkingColorSpace_192[1].y), _1090, ((WorkingColorSpace_192[1].x) * _1089))));
  _1115 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1091, mad((WorkingColorSpace_192[2].y), _1090, ((WorkingColorSpace_192[2].x) * _1089))));
  _1141 = cb0_014x * (((cb0_039y + (cb0_039x * _1113)) * _1113) + cb0_039z);
  _1142 = cb0_014y * (((cb0_039y + (cb0_039x * _1114)) * _1114) + cb0_039z);
  _1143 = cb0_014z * (((cb0_039y + (cb0_039x * _1115)) * _1115) + cb0_039z);
  _1164 = exp2(log2(max(0.0f, (lerp(_1141, cb0_013x, cb0_013w)))) * cb0_040y);
  _1165 = exp2(log2(max(0.0f, (lerp(_1142, cb0_013y, cb0_013w)))) * cb0_040y);
  _1166 = exp2(log2(max(0.0f, (lerp(_1143, cb0_013z, cb0_013w)))) * cb0_040y);
  if (WorkingColorSpace_320 == 0) {
    _1173 = mad((WorkingColorSpace_128[0].z), _1166, mad((WorkingColorSpace_128[0].y), _1165, ((WorkingColorSpace_128[0].x) * _1164)));
    _1176 = mad((WorkingColorSpace_128[1].z), _1166, mad((WorkingColorSpace_128[1].y), _1165, ((WorkingColorSpace_128[1].x) * _1164)));
    _1179 = mad((WorkingColorSpace_128[2].z), _1166, mad((WorkingColorSpace_128[2].y), _1165, ((WorkingColorSpace_128[2].x) * _1164)));
    _1190 = mad(_51, _1179, mad(_50, _1176, (_1173 * _49)));
    _1191 = mad(_54, _1179, mad(_53, _1176, (_1173 * _52)));
    _1192 = mad(_57, _1179, mad(_56, _1176, (_1173 * _55)));
  } else {
    _1190 = _1164;
    _1191 = _1165;
    _1192 = _1166;
  }
  if (_1190 < 0.0031306699384003878f) {
    _1203 = (_1190 * 12.920000076293945f);
  } else {
    _1203 = (((pow(_1190, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1191 < 0.0031306699384003878f) {
    _1214 = (_1191 * 12.920000076293945f);
  } else {
    _1214 = (((pow(_1191, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1192 < 0.0031306699384003878f) {
    _1225 = (_1192 * 12.920000076293945f);
  } else {
    _1225 = (((pow(_1192, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_1203 * 0.9523810148239136f), (_1214 * 0.9523810148239136f), (_1225 * 0.9523810148239136f), 0.0f);
}