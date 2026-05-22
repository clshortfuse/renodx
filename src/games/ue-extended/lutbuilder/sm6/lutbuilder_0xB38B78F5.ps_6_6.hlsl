// Directive 8020

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture3D<float4> t1 : register(t1);

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

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  precise noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _14;
  float _19;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _114;
  float _760;
  float _770;
  float _780;
  float _857;
  float _858;
  float _859;
  float _869;
  float _879;
  float _889;
  float _897;
  float _898;
  float _899;
  float _975;
  float _1008;
  float _1022;
  float _1086;
  float _1277;
  float _1288;
  float _1299;
  float _1456;
  float _1457;
  float _1458;
  float _1469;
  float _1480;
  float _1491;
  bool _32;
  float _64;
  float _65;
  float _66;
  bool _93;
  float _97;
  float _128;
  float _135;
  float _138;
  float _143;
  float _144;
  float _146;
  bool _147;
  float _156;
  float _158;
  float _165;
  float _167;
  float _169;
  float _170;
  float _173;
  float _176;
  float _181;
  float _187;
  float _188;
  float _189;
  float _190;
  float _191;
  float _192;
  float _193;
  float _194;
  float _197;
  float _198;
  float _199;
  float _202;
  float _221;
  float _222;
  float _223;
  float _224;
  float _225;
  float _226;
  float _227;
  float _228;
  float _229;
  float _232;
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
  float _313;
  float _316;
  float _319;
  float _334;
  float _337;
  float _340;
  float _341;
  float _345;
  float _346;
  float _347;
  float _359;
  float _375;
  float _376;
  float _377;
  float _378;
  float _392;
  float _406;
  float _420;
  float _434;
  float _448;
  float _452;
  float _453;
  float _454;
  float _511;
  float _515;
  float _516;
  float _525;
  float _534;
  float _543;
  float _552;
  float _561;
  float _624;
  float _628;
  float _637;
  float _646;
  float _655;
  float _664;
  float _673;
  float _731;
  float _742;
  float _744;
  float _746;
  float _784;
  float _785;
  float _786;
  float4 _791;
  float4 _799;
  float4 _804;
  float4 _809;
  float _825;
  float _826;
  float _827;
  float _828;
  float _829;
  float _830;
  float _831;
  float _849;
  float _915;
  float _916;
  float _917;
  float _920;
  float _923;
  float _926;
  float _930;
  float _935;
  float _948;
  float _949;
  float _950;
  float _951;
  float _955;
  float _966;
  float _976;
  float _977;
  float _978;
  float _979;
  float _986;
  float _989;
  float _991;
  bool _994;
  bool _995;
  bool _996;
  bool _997;
  float _1013;
  float _1026;
  float _1030;
  float _1036;
  float _1046;
  float _1047;
  float _1048;
  float _1049;
  float _1064;
  float _1066;
  float _1068;
  float _1077;
  float _1089;
  float _1091;
  float _1095;
  float _1096;
  float _1097;
  float _1101;
  float _1102;
  float _1103;
  float _1104;
  float _1106;
  float _1107;
  float _1108;
  float _1109;
  float _1128;
  float _1130;
  float _1155;
  float _1156;
  float _1157;
  float _1164;
  float _1168;
  float _1169;
  float _1170;
  bool _1171;
  float _1175;
  float _1176;
  float _1177;
  float _1196;
  float _1197;
  float _1198;
  float _1199;
  float _1219;
  float _1220;
  float _1221;
  float _1237;
  float _1238;
  float _1239;
  float _1264;
  float _1265;
  float _1266;
  float _1303;
  float _1310;
  float _1311;
  float _1312;
  float _1314;
  float4 _1317;
  float4 _1324;
  float _1343;
  float _1344;
  float _1345;
  float _1367;
  float _1368;
  float _1369;
  float _1395;
  float _1396;
  float _1397;
  float _1418;
  float _1419;
  float _1420;
  float _1439;
  float _1442;
  float _1445;
  _14 = 0.5f / cb0_035x;
  _19 = cb0_035x + -1.0f;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        _32 = (cb0_041x == 4);
        _43 = select(_32, 1.0f, 1.705051064491272f);
        _44 = select(_32, 0.0f, -0.6217921376228333f);
        _45 = select(_32, 0.0f, -0.0832589864730835f);
        _46 = select(_32, 0.0f, -0.13025647401809692f);
        _47 = select(_32, 1.0f, 1.140804648399353f);
        _48 = select(_32, 0.0f, -0.010548308491706848f);
        _49 = select(_32, 0.0f, -0.024003351107239723f);
        _50 = select(_32, 0.0f, -0.1289689838886261f);
        _51 = select(_32, 1.0f, 1.1529725790023804f);
      } else {
        _43 = 0.6954522132873535f;
        _44 = 0.14067870378494263f;
        _45 = 0.16386906802654266f;
        _46 = 0.044794563204050064f;
        _47 = 0.8596711158752441f;
        _48 = 0.0955343171954155f;
        _49 = -0.005525882821530104f;
        _50 = 0.004025210160762072f;
        _51 = 1.0015007257461548f;
      }
    } else {
      _43 = 1.0258246660232544f;
      _44 = -0.020053181797266006f;
      _45 = -0.005771636962890625f;
      _46 = -0.002234415616840124f;
      _47 = 1.0045864582061768f;
      _48 = -0.002352118492126465f;
      _49 = -0.005013350863009691f;
      _50 = -0.025290070101618767f;
      _51 = 1.0303035974502563f;
    }
  } else {
    _43 = 1.3792141675949097f;
    _44 = -0.30886411666870117f;
    _45 = -0.0703500509262085f;
    _46 = -0.06933490186929703f;
    _47 = 1.08229660987854f;
    _48 = -0.012961871922016144f;
    _49 = -0.0021590073592960835f;
    _50 = -0.0454593189060688f;
    _51 = 1.0476183891296387f;
  }
  _64 = (exp2((((cb0_035x * (TEXCOORD.x - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _65 = (exp2((((cb0_035x * (TEXCOORD.y - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _66 = (exp2(((float((uint)(uint)(SV_RenderTargetArrayIndex)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _93 = (cb0_038w != 0);
  _97 = 0.9994439482688904f / cb0_035y;
  if ((cb0_035y * 1.0005563497543335f) > 7000.0f) {
    _114 = (((((1901800.0f - (_97 * 2006400000.0f)) * _97) + 247.47999572753906f) * _97) + 0.23703999817371368f);
  } else {
    _114 = (((((2967800.0f - (_97 * 4607000064.0f)) * _97) + 99.11000061035156f) * _97) + 0.24406300485134125f);
  }
  _128 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  _135 = cb0_035y * cb0_035y;
  _138 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_135 * 1.6145605741257896e-07f));
  _143 = ((_128 * 2.0f) + 4.0f) - (_138 * 8.0f);
  _144 = (_128 * 3.0f) / _143;
  _146 = (_138 * 2.0f) / _143;
  _147 = (cb0_035y < 4000.0f);
  _156 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  _158 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_135 * 1.5317699909210205f)) / (_156 * _156);
  _165 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _135;
  _167 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_135 * 308.60699462890625f)) / (_165 * _165);
  _169 = rsqrt(dot(float2(_158, _167), float2(_158, _167)));
  _170 = cb0_035z * 0.05000000074505806f;
  _173 = ((_170 * _167) * _169) + _128;
  _176 = _138 - ((_170 * _158) * _169);
  _181 = (4.0f - (_176 * 8.0f)) + (_173 * 2.0f);
  _187 = (((_173 * 3.0f) / _181) - _144) + select(_147, _144, _114);
  _188 = (((_176 * 2.0f) / _181) - _146) + select(_147, _146, (((_114 * 2.869999885559082f) + -0.2750000059604645f) - ((_114 * _114) * 3.0f)));
  _189 = select(_93, _187, 0.3127000033855438f);
  _190 = select(_93, _188, 0.32899999618530273f);
  _191 = select(_93, 0.3127000033855438f, _187);
  _192 = select(_93, 0.32899999618530273f, _188);
  _193 = max(_190, 1.000000013351432e-10f);
  _194 = _189 / _193;
  _197 = ((1.0f - _189) - _190) / _193;
  _198 = max(_192, 1.000000013351432e-10f);
  _199 = _191 / _198;
  _202 = ((1.0f - _191) - _192) / _198;
  _221 = mad(-0.16140000522136688f, _202, ((_199 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _197, ((_194 * 0.8950999975204468f) + 0.266400009393692f));
  _222 = mad(0.03669999912381172f, _202, (1.7135000228881836f - (_199 * 0.7501999735832214f))) / mad(0.03669999912381172f, _197, (1.7135000228881836f - (_194 * 0.7501999735832214f)));
  _223 = mad(1.0296000242233276f, _202, ((_199 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _197, ((_194 * 0.03889999911189079f) + -0.06849999725818634f));
  _224 = mad(_222, -0.7501999735832214f, 0.0f);
  _225 = mad(_222, 1.7135000228881836f, 0.0f);
  _226 = mad(_222, 0.03669999912381172f, -0.0f);
  _227 = mad(_223, 0.03889999911189079f, 0.0f);
  _228 = mad(_223, -0.06849999725818634f, 0.0f);
  _229 = mad(_223, 1.0296000242233276f, 0.0f);
  _232 = mad(0.1599626988172531f, _227, mad(-0.1470542997121811f, _224, (_221 * 0.883457362651825f)));
  _235 = mad(0.1599626988172531f, _228, mad(-0.1470542997121811f, _225, (_221 * 0.26293492317199707f)));
  _238 = mad(0.1599626988172531f, _229, mad(-0.1470542997121811f, _226, (_221 * -0.15930065512657166f)));
  _241 = mad(0.04929120093584061f, _227, mad(0.5183603167533875f, _224, (_221 * 0.38695648312568665f)));
  _244 = mad(0.04929120093584061f, _228, mad(0.5183603167533875f, _225, (_221 * 0.11516613513231277f)));
  _247 = mad(0.04929120093584061f, _229, mad(0.5183603167533875f, _226, (_221 * -0.0697740763425827f)));
  _250 = mad(0.9684867262840271f, _227, mad(0.04004279896616936f, _224, (_221 * -0.007634039502590895f)));
  _253 = mad(0.9684867262840271f, _228, mad(0.04004279896616936f, _225, (_221 * -0.0022720457054674625f)));
  _256 = mad(0.9684867262840271f, _229, mad(0.04004279896616936f, _226, (_221 * 0.0013765322510153055f)));
  _259 = mad(_238, (WorkingColorSpace_000[2].x), mad(_235, (WorkingColorSpace_000[1].x), (_232 * (WorkingColorSpace_000[0].x))));
  _262 = mad(_238, (WorkingColorSpace_000[2].y), mad(_235, (WorkingColorSpace_000[1].y), (_232 * (WorkingColorSpace_000[0].y))));
  _265 = mad(_238, (WorkingColorSpace_000[2].z), mad(_235, (WorkingColorSpace_000[1].z), (_232 * (WorkingColorSpace_000[0].z))));
  _268 = mad(_247, (WorkingColorSpace_000[2].x), mad(_244, (WorkingColorSpace_000[1].x), (_241 * (WorkingColorSpace_000[0].x))));
  _271 = mad(_247, (WorkingColorSpace_000[2].y), mad(_244, (WorkingColorSpace_000[1].y), (_241 * (WorkingColorSpace_000[0].y))));
  _274 = mad(_247, (WorkingColorSpace_000[2].z), mad(_244, (WorkingColorSpace_000[1].z), (_241 * (WorkingColorSpace_000[0].z))));
  _277 = mad(_256, (WorkingColorSpace_000[2].x), mad(_253, (WorkingColorSpace_000[1].x), (_250 * (WorkingColorSpace_000[0].x))));
  _280 = mad(_256, (WorkingColorSpace_000[2].y), mad(_253, (WorkingColorSpace_000[1].y), (_250 * (WorkingColorSpace_000[0].y))));
  _283 = mad(_256, (WorkingColorSpace_000[2].z), mad(_253, (WorkingColorSpace_000[1].z), (_250 * (WorkingColorSpace_000[0].z))));
  _313 = mad(mad((WorkingColorSpace_064[0].z), _283, mad((WorkingColorSpace_064[0].y), _274, (_265 * (WorkingColorSpace_064[0].x)))), _66, mad(mad((WorkingColorSpace_064[0].z), _280, mad((WorkingColorSpace_064[0].y), _271, (_262 * (WorkingColorSpace_064[0].x)))), _65, (mad((WorkingColorSpace_064[0].z), _277, mad((WorkingColorSpace_064[0].y), _268, (_259 * (WorkingColorSpace_064[0].x)))) * _64)));
  _316 = mad(mad((WorkingColorSpace_064[1].z), _283, mad((WorkingColorSpace_064[1].y), _274, (_265 * (WorkingColorSpace_064[1].x)))), _66, mad(mad((WorkingColorSpace_064[1].z), _280, mad((WorkingColorSpace_064[1].y), _271, (_262 * (WorkingColorSpace_064[1].x)))), _65, (mad((WorkingColorSpace_064[1].z), _277, mad((WorkingColorSpace_064[1].y), _268, (_259 * (WorkingColorSpace_064[1].x)))) * _64)));
  _319 = mad(mad((WorkingColorSpace_064[2].z), _283, mad((WorkingColorSpace_064[2].y), _274, (_265 * (WorkingColorSpace_064[2].x)))), _66, mad(mad((WorkingColorSpace_064[2].z), _280, mad((WorkingColorSpace_064[2].y), _271, (_262 * (WorkingColorSpace_064[2].x)))), _65, (mad((WorkingColorSpace_064[2].z), _277, mad((WorkingColorSpace_064[2].y), _268, (_259 * (WorkingColorSpace_064[2].x)))) * _64)));
  _334 = mad((WorkingColorSpace_128[0].z), _319, mad((WorkingColorSpace_128[0].y), _316, ((WorkingColorSpace_128[0].x) * _313)));
  _337 = mad((WorkingColorSpace_128[1].z), _319, mad((WorkingColorSpace_128[1].y), _316, ((WorkingColorSpace_128[1].x) * _313)));
  _340 = mad((WorkingColorSpace_128[2].z), _319, mad((WorkingColorSpace_128[2].y), _316, ((WorkingColorSpace_128[2].x) * _313)));
  _341 = dot(float3(_334, _337, _340), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _345 = (_334 / _341) + -1.0f;
  _346 = (_337 / _341) + -1.0f;
  _347 = (_340 / _341) + -1.0f;
  _359 = (1.0f - exp2(((_341 * _341) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_345, _346, _347), float3(_345, _346, _347)) * -4.0f));
  _375 = ((mad(-0.06368321925401688f, _340, mad(-0.3292922377586365f, _337, (_334 * 1.3704125881195068f))) - _334) * _359) + _334;
  _376 = ((mad(-0.010861365124583244f, _340, mad(1.0970927476882935f, _337, (_334 * -0.08343357592821121f))) - _337) * _359) + _337;
  _377 = ((mad(1.2036951780319214f, _340, mad(-0.09862580895423889f, _337, (_334 * -0.02579331398010254f))) - _340) * _359) + _340;
  _378 = dot(float3(_375, _376, _377), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _392 = cb0_019w + cb0_024w;
  _406 = cb0_018w * cb0_023w;
  _420 = cb0_017w * cb0_022w;
  _434 = cb0_016w * cb0_021w;
  _448 = cb0_015w * cb0_020w;
  _452 = _375 - _378;
  _453 = _376 - _378;
  _454 = _377 - _378;
  _511 = saturate(_378 / cb0_035w);
  _515 = (_511 * _511) * (3.0f - (_511 * 2.0f));
  _516 = 1.0f - _515;
  _525 = cb0_019w + cb0_034w;
  _534 = cb0_018w * cb0_033w;
  _543 = cb0_017w * cb0_032w;
  _552 = cb0_016w * cb0_031w;
  _561 = cb0_015w * cb0_030w;
  _624 = saturate((_378 - cb0_036x) / (cb0_036y - cb0_036x));
  _628 = (_624 * _624) * (3.0f - (_624 * 2.0f));
  _637 = cb0_019w + cb0_029w;
  _646 = cb0_018w * cb0_028w;
  _655 = cb0_017w * cb0_027w;
  _664 = cb0_016w * cb0_026w;
  _673 = cb0_015w * cb0_025w;
  _731 = _515 - _628;
  _742 = ((_628 * (((cb0_019x + cb0_034x) + _525) + (((cb0_018x * cb0_033x) * _534) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _552) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _561) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _543)))))) + (_516 * (((cb0_019x + cb0_024x) + _392) + (((cb0_018x * cb0_023x) * _406) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _434) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _448) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _420))))))) + ((((cb0_019x + cb0_029x) + _637) + (((cb0_018x * cb0_028x) * _646) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _664) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _673) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _655))))) * _731);
  _744 = ((_628 * (((cb0_019y + cb0_034y) + _525) + (((cb0_018y * cb0_033y) * _534) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _552) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _561) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _543)))))) + (_516 * (((cb0_019y + cb0_024y) + _392) + (((cb0_018y * cb0_023y) * _406) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _434) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _448) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _420))))))) + ((((cb0_019y + cb0_029y) + _637) + (((cb0_018y * cb0_028y) * _646) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _664) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _673) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _655))))) * _731);
  _746 = ((_628 * (((cb0_019z + cb0_034z) + _525) + (((cb0_018z * cb0_033z) * _534) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _552) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _561) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _543)))))) + (_516 * (((cb0_019z + cb0_024z) + _392) + (((cb0_018z * cb0_023z) * _406) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _434) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _448) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _420))))))) + ((((cb0_019z + cb0_029z) + _637) + (((cb0_018z * cb0_028z) * _646) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _664) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _673) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _655))))) * _731);
  if (!(cb0_042x == 0)) {
    if (_742 > 0.0078125f) {
      _760 = ((log2(_742) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _760 = ((_742 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_744 > 0.0078125f) {
      _770 = ((log2(_744) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _770 = ((_744 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_746 > 0.0078125f) {
      _780 = ((log2(_746) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _780 = ((_746 * 10.540237426757812f) + 0.072905533015728f);
    }
    _784 = min(max(_760, 0.0f), 1.0f);
    _785 = min(max(_770, 0.0f), 1.0f);
    _786 = min(max(_780, 0.0f), 1.0f);
    _791 = t1.Sample(s1, float3(_784, _785, _786));
    if (cb0_042y == 1) {
      _799 = t1.Sample(s1, float3((cb0_042z + _784), _785, _786));
      _804 = t1.Sample(s1, float3(_784, (cb0_042z + _785), _786));
      _809 = t1.Sample(s1, float3(_784, _785, (cb0_042z + _786)));
      _825 = saturate(1.0f - abs(_784 - floor(_784)));
      _826 = saturate(1.0f - abs(_785 - floor(_785)));
      _827 = saturate(1.0f - abs(_786 - floor(_786)));
      _828 = dot(float3(_825, _826, _827), float3(1.0f, 1.0f, 1.0f));
      _829 = _825 / _828;
      _830 = _826 / _828;
      _831 = _827 / _828;
      _849 = ((1.0f - _829) - _830) - _831;
      _857 = ((((_830 * _799.x) + (_829 * _791.x)) + (_831 * _804.x)) + (_849 * _809.x));
      _858 = ((((_830 * _799.y) + (_829 * _791.y)) + (_831 * _804.y)) + (_849 * _809.y));
      _859 = ((((_830 * _799.z) + (_829 * _791.z)) + (_831 * _804.z)) + (_849 * _809.z));
    } else {
      _857 = _791.x;
      _858 = _791.y;
      _859 = _791.z;
    }
    if (_857 > 0.155251145362854f) {
      _869 = exp2((_857 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _869 = ((_857 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_858 > 0.155251145362854f) {
      _879 = exp2((_858 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _879 = ((_858 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_859 > 0.155251145362854f) {
      _889 = exp2((_859 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _889 = ((_859 + -0.072905533015728f) * 0.09487452358007431f);
    }
    _897 = min(max(_869, 0.0f), 65504.0f);
    _898 = min(max(_879, 0.0f), 65504.0f);
    _899 = min(max(_889, 0.0f), 65504.0f);
  } else {
    _897 = _742;
    _898 = _744;
    _899 = _746;
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
  float4 output = ProcessLutbuilder(float3(_897, _898, _899), cb_config, SV_Target, 0u);
  SV_Target = output;
  return SV_Target;
  _915 = ((mad(0.061360642313957214f, _899, mad(-4.540197551250458e-09f, _898, (_897 * 0.9386394023895264f))) - _897) * cb0_036z) + _897;
  _916 = ((mad(0.169205904006958f, _899, mad(0.8307942152023315f, _898, (_897 * 6.775371730327606e-08f))) - _898) * cb0_036z) + _898;
  _917 = (mad(-2.3283064365386963e-10f, _898, (_897 * -9.313225746154785e-10f)) * cb0_036z) + _899;
  _920 = mad(0.16386905312538147f, _917, mad(0.14067868888378143f, _916, (_915 * 0.6954522132873535f)));
  _923 = mad(0.0955343246459961f, _917, mad(0.8596711158752441f, _916, (_915 * 0.044794581830501556f)));
  _926 = mad(1.0015007257461548f, _917, mad(0.004025210160762072f, _916, (_915 * -0.005525882821530104f)));
  _930 = max(max(_920, _923), _926);
  _935 = (max(_930, 1.000000013351432e-10f) - max(min(min(_920, _923), _926), 1.000000013351432e-10f)) / max(_930, 0.009999999776482582f);
  _948 = ((_923 + _920) + _926) + (sqrt((((_926 - _923) * _926) + ((_923 - _920) * _923)) + ((_920 - _926) * _920)) * 1.75f);
  _949 = _948 * 0.3333333432674408f;
  _950 = _935 + -0.4000000059604645f;
  _951 = _950 * 5.0f;
  _955 = max((1.0f - abs(_950 * 2.5f)), 0.0f);
  _966 = ((float((int)(((int)(uint)((int)(_951 > 0.0f))) - ((int)(uint)((int)(_951 < 0.0f))))) * (1.0f - (_955 * _955))) + 1.0f) * 0.02500000037252903f;
  if (_949 > 0.0533333346247673f) {
    if (_949 < 0.1599999964237213f) {
      _975 = (((0.23999999463558197f / _948) + -0.5f) * _966);
    } else {
      _975 = 0.0f;
    }
  } else {
    _975 = _966;
  }
  _976 = _975 + 1.0f;
  _977 = _976 * _920;
  _978 = _976 * _923;
  _979 = _976 * _926;
  if (!((_977 == _978) && (_978 == _979))) {
    _986 = ((_977 * 2.0f) - _978) - _979;
    _989 = ((_923 - _926) * 1.7320507764816284f) * _976;
    _991 = atan(_989 / _986);
    _994 = (_986 < 0.0f);
    _995 = (_986 == 0.0f);
    _996 = (_989 >= 0.0f);
    _997 = (_989 < 0.0f);
    _1008 = select((_996 && _995), 90.0f, select((_997 && _995), -90.0f, (select((_997 && _994), (_991 + -3.1415927410125732f), select((_996 && _994), (_991 + 3.1415927410125732f), _991)) * 57.2957763671875f)));
  } else {
    _1008 = 0.0f;
  }
  _1013 = min(max(select((_1008 < 0.0f), (_1008 + 360.0f), _1008), 0.0f), 360.0f);
  if (_1013 < -180.0f) {
    _1022 = (_1013 + 360.0f);
  } else {
    if (_1013 > 180.0f) {
      _1022 = (_1013 + -360.0f);
    } else {
      _1022 = _1013;
    }
  }
  _1026 = saturate(1.0f - abs(_1022 * 0.014814814552664757f));
  _1030 = (_1026 * _1026) * (3.0f - (_1026 * 2.0f));
  _1036 = ((_1030 * _1030) * ((_935 * 0.18000000715255737f) * (0.029999999329447746f - _977))) + _977;
  _1046 = max(0.0f, mad(-0.21492856740951538f, _979, mad(-0.2365107536315918f, _978, (_1036 * 1.4514392614364624f))));
  _1047 = max(0.0f, mad(-0.09967592358589172f, _979, mad(1.17622971534729f, _978, (_1036 * -0.07655377686023712f))));
  _1048 = max(0.0f, mad(0.9977163076400757f, _979, mad(-0.006032449658960104f, _978, (_1036 * 0.008316148072481155f))));
  _1049 = dot(float3(_1046, _1047, _1048), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1064 = (cb0_038x + 1.0f) - cb0_037z;
  _1066 = cb0_038y + 1.0f;
  _1068 = _1066 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1086 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _1077 = (cb0_038x + 0.18000000715255737f) / _1064;
    _1086 = (-0.7447274923324585f - ((log2(_1077 / (2.0f - _1077)) * 0.3465735912322998f) * (_1064 / cb0_037y)));
  }
  _1089 = ((1.0f - cb0_037z) / cb0_037y) - _1086;
  _1091 = (cb0_037w / cb0_037y) - _1089;
  _1095 = log2(lerp(_1049, _1046, 0.9599999785423279f)) * 0.3010300099849701f;
  _1096 = log2(lerp(_1049, _1047, 0.9599999785423279f)) * 0.3010300099849701f;
  _1097 = log2(lerp(_1049, _1048, 0.9599999785423279f)) * 0.3010300099849701f;
  _1101 = cb0_037y * (_1095 + _1089);
  _1102 = cb0_037y * (_1096 + _1089);
  _1103 = cb0_037y * (_1097 + _1089);
  _1104 = _1064 * 2.0f;
  _1106 = (cb0_037y * -2.0f) / _1064;
  _1107 = _1095 - _1086;
  _1108 = _1096 - _1086;
  _1109 = _1097 - _1086;
  _1128 = _1068 * 2.0f;
  _1130 = (cb0_037y * 2.0f) / _1068;
  _1155 = select((_1095 < _1086), ((_1104 / (exp2((_1107 * 1.4426950216293335f) * _1106) + 1.0f)) - cb0_038x), _1101);
  _1156 = select((_1096 < _1086), ((_1104 / (exp2((_1108 * 1.4426950216293335f) * _1106) + 1.0f)) - cb0_038x), _1102);
  _1157 = select((_1097 < _1086), ((_1104 / (exp2((_1109 * 1.4426950216293335f) * _1106) + 1.0f)) - cb0_038x), _1103);
  _1164 = _1091 - _1086;
  _1168 = saturate(_1107 / _1164);
  _1169 = saturate(_1108 / _1164);
  _1170 = saturate(_1109 / _1164);
  _1171 = (_1091 < _1086);
  _1175 = select(_1171, (1.0f - _1168), _1168);
  _1176 = select(_1171, (1.0f - _1169), _1169);
  _1177 = select(_1171, (1.0f - _1170), _1170);
  _1196 = (((_1175 * _1175) * (select((_1095 > _1091), (_1066 - (_1128 / (exp2(((_1095 - _1091) * 1.4426950216293335f) * _1130) + 1.0f))), _1101) - _1155)) * (3.0f - (_1175 * 2.0f))) + _1155;
  _1197 = (((_1176 * _1176) * (select((_1096 > _1091), (_1066 - (_1128 / (exp2(((_1096 - _1091) * 1.4426950216293335f) * _1130) + 1.0f))), _1102) - _1156)) * (3.0f - (_1176 * 2.0f))) + _1156;
  _1198 = (((_1177 * _1177) * (select((_1097 > _1091), (_1066 - (_1128 / (exp2(((_1097 - _1091) * 1.4426950216293335f) * _1130) + 1.0f))), _1103) - _1157)) * (3.0f - (_1177 * 2.0f))) + _1157;
  _1199 = dot(float3(_1196, _1197, _1198), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1219 = (cb0_037x * (max(0.0f, (lerp(_1199, _1196, 0.9300000071525574f))) - _915)) + _915;
  _1220 = (cb0_037x * (max(0.0f, (lerp(_1199, _1197, 0.9300000071525574f))) - _916)) + _916;
  _1221 = (cb0_037x * (max(0.0f, (lerp(_1199, _1198, 0.9300000071525574f))) - _917)) + _917;
  _1237 = ((mad(-0.06537103652954102f, _1221, mad(1.451815478503704e-06f, _1220, (_1219 * 1.065374732017517f))) - _1219) * cb0_036z) + _1219;
  _1238 = ((mad(-0.20366770029067993f, _1221, mad(1.2036634683609009f, _1220, (_1219 * -2.57161445915699e-07f))) - _1220) * cb0_036z) + _1220;
  _1239 = ((mad(0.9999996423721313f, _1221, mad(2.0954757928848267e-08f, _1220, (_1219 * 1.862645149230957e-08f))) - _1221) * cb0_036z) + _1221;
  _1264 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1239, mad((WorkingColorSpace_192[0].y), _1238, ((WorkingColorSpace_192[0].x) * _1237)))));
  _1265 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1239, mad((WorkingColorSpace_192[1].y), _1238, ((WorkingColorSpace_192[1].x) * _1237)))));
  _1266 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1239, mad((WorkingColorSpace_192[2].y), _1238, ((WorkingColorSpace_192[2].x) * _1237)))));
  if (_1264 < 0.0031306699384003878f) {
    _1277 = (_1264 * 12.920000076293945f);
  } else {
    _1277 = (((pow(_1264, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1265 < 0.0031306699384003878f) {
    _1288 = (_1265 * 12.920000076293945f);
  } else {
    _1288 = (((pow(_1265, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1266 < 0.0031306699384003878f) {
    _1299 = (_1266 * 12.920000076293945f);
  } else {
    _1299 = (((pow(_1266, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1303 = (_1288 * 0.9375f) + 0.03125f;
  _1310 = _1299 * 15.0f;
  _1311 = floor(_1310);
  _1312 = _1310 - _1311;
  _1314 = (((_1277 * 0.9375f) + 0.03125f) + _1311) * 0.0625f;
  _1317 = t0.Sample(s0, float2(_1314, _1303));
  _1324 = t0.Sample(s0, float2((_1314 + 0.0625f), _1303));
  _1343 = max(6.103519990574569e-05f, (((lerp(_1317.x, _1324.x, _1312)) * cb0_005y) + (cb0_005x * _1277)));
  _1344 = max(6.103519990574569e-05f, (((lerp(_1317.y, _1324.y, _1312)) * cb0_005y) + (cb0_005x * _1288)));
  _1345 = max(6.103519990574569e-05f, (((lerp(_1317.z, _1324.z, _1312)) * cb0_005y) + (cb0_005x * _1299)));
  _1367 = select((_1343 > 0.040449999272823334f), exp2(log2((_1343 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1343 * 0.07739938050508499f));
  _1368 = select((_1344 > 0.040449999272823334f), exp2(log2((_1344 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1344 * 0.07739938050508499f));
  _1369 = select((_1345 > 0.040449999272823334f), exp2(log2((_1345 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1345 * 0.07739938050508499f));
  _1395 = cb0_014x * (((cb0_039y + (cb0_039x * _1367)) * _1367) + cb0_039z);
  _1396 = cb0_014y * (((cb0_039y + (cb0_039x * _1368)) * _1368) + cb0_039z);
  _1397 = cb0_014z * (((cb0_039y + (cb0_039x * _1369)) * _1369) + cb0_039z);
  _1418 = exp2(log2(max(0.0f, (lerp(_1395, cb0_013x, cb0_013w)))) * cb0_040y);
  _1419 = exp2(log2(max(0.0f, (lerp(_1396, cb0_013y, cb0_013w)))) * cb0_040y);
  _1420 = exp2(log2(max(0.0f, (lerp(_1397, cb0_013z, cb0_013w)))) * cb0_040y);
  if (WorkingColorSpace_320 == 0) {
    _1439 = mad((WorkingColorSpace_128[0].z), _1420, mad((WorkingColorSpace_128[0].y), _1419, ((WorkingColorSpace_128[0].x) * _1418)));
    _1442 = mad((WorkingColorSpace_128[1].z), _1420, mad((WorkingColorSpace_128[1].y), _1419, ((WorkingColorSpace_128[1].x) * _1418)));
    _1445 = mad((WorkingColorSpace_128[2].z), _1420, mad((WorkingColorSpace_128[2].y), _1419, ((WorkingColorSpace_128[2].x) * _1418)));
    _1456 = mad(_45, _1445, mad(_44, _1442, (_1439 * _43)));
    _1457 = mad(_48, _1445, mad(_47, _1442, (_1439 * _46)));
    _1458 = mad(_51, _1445, mad(_50, _1442, (_1439 * _49)));
  } else {
    _1456 = _1418;
    _1457 = _1419;
    _1458 = _1420;
  }
  if (_1456 < 0.0031306699384003878f) {
    _1469 = (_1456 * 12.920000076293945f);
  } else {
    _1469 = (((pow(_1456, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1457 < 0.0031306699384003878f) {
    _1480 = (_1457 * 12.920000076293945f);
  } else {
    _1480 = (((pow(_1457, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1458 < 0.0031306699384003878f) {
    _1491 = (_1458 * 12.920000076293945f);
  } else {
    _1491 = (((pow(_1458, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1469 * 0.9523810148239136f);
  SV_Target.y = (_1480 * 0.9523810148239136f);
  SV_Target.z = (_1491 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}