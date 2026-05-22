// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
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
  float cb0_038z : packoffset(c038.z);
  float cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_039w : packoffset(c039.w);
  float cb0_040x : packoffset(c040.x);
  float cb0_040y : packoffset(c040.y);
  int cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  int cb0_043x : packoffset(c043.x);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  float4 WorkingColorSpace_320[4] : packoffset(c020.x);
  int WorkingColorSpace_384 : packoffset(c024.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

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
  float _24;
  float _29;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _131;
  float _338;
  float _339;
  float _340;
  float _842;
  float _875;
  float _889;
  float _953;
  float _1144;
  float _1155;
  float _1166;
  float _1335;
  float _1336;
  float _1337;
  float _1348;
  float _1359;
  float _1370;
  bool _42;
  float _74;
  float _75;
  float _76;
  bool _112;
  float _114;
  float _145;
  float _152;
  float _155;
  float _160;
  float _161;
  float _163;
  bool _164;
  float _173;
  float _175;
  float _182;
  float _184;
  float _186;
  float _187;
  float _190;
  float _193;
  float _198;
  float _204;
  float _205;
  float _206;
  float _207;
  float _208;
  float _209;
  float _210;
  float _211;
  float _214;
  float _215;
  float _216;
  float _219;
  float _238;
  float _239;
  float _240;
  float _241;
  float _242;
  float _243;
  float _244;
  float _245;
  float _246;
  float _249;
  float _252;
  float _255;
  float _258;
  float _261;
  float _264;
  float _267;
  float _270;
  float _273;
  float _276;
  float _279;
  float _282;
  float _285;
  float _288;
  float _291;
  float _294;
  float _297;
  float _300;
  float _355;
  float _358;
  float _361;
  float _362;
  float _366;
  float _367;
  float _368;
  float _380;
  float _396;
  float _397;
  float _398;
  float _399;
  float _413;
  float _427;
  float _441;
  float _455;
  float _469;
  float _473;
  float _474;
  float _475;
  float _532;
  float _536;
  float _537;
  float _546;
  float _555;
  float _564;
  float _573;
  float _582;
  float _645;
  float _649;
  float _658;
  float _667;
  float _676;
  float _685;
  float _694;
  float _752;
  float _763;
  float _765;
  float _767;
  float _782;
  float _783;
  float _784;
  float _787;
  float _790;
  float _793;
  float _797;
  float _802;
  float _815;
  float _816;
  float _817;
  float _818;
  float _822;
  float _833;
  float _843;
  float _844;
  float _845;
  float _846;
  float _853;
  float _856;
  float _858;
  bool _861;
  bool _862;
  bool _863;
  bool _864;
  float _880;
  float _893;
  float _897;
  float _903;
  float _913;
  float _914;
  float _915;
  float _916;
  float _931;
  float _933;
  float _935;
  float _944;
  float _956;
  float _958;
  float _962;
  float _963;
  float _964;
  float _968;
  float _969;
  float _970;
  float _971;
  float _973;
  float _974;
  float _975;
  float _976;
  float _995;
  float _997;
  float _1022;
  float _1023;
  float _1024;
  float _1031;
  float _1035;
  float _1036;
  float _1037;
  bool _1038;
  float _1042;
  float _1043;
  float _1044;
  float _1063;
  float _1064;
  float _1065;
  float _1066;
  float _1086;
  float _1087;
  float _1088;
  float _1104;
  float _1105;
  float _1106;
  float _1131;
  float _1132;
  float _1133;
  float _1170;
  float _1177;
  float _1178;
  float _1179;
  float _1181;
  float4 _1184;
  float _1188;
  float4 _1189;
  float4 _1211;
  float4 _1215;
  float _1231;
  float _1232;
  float _1233;
  float _1258;
  float _1259;
  float _1260;
  float _1286;
  float _1287;
  float _1288;
  float _1309;
  float _1310;
  float _1311;
  float _1318;
  float _1321;
  float _1324;
  _24 = 0.5f / cb0_037x;
  _29 = cb0_037x + -1.0f;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _42 = (cb0_043x == 4);
        _53 = select(_42, 1.0f, 1.705051064491272f);
        _54 = select(_42, 0.0f, -0.6217921376228333f);
        _55 = select(_42, 0.0f, -0.0832589864730835f);
        _56 = select(_42, 0.0f, -0.13025647401809692f);
        _57 = select(_42, 1.0f, 1.140804648399353f);
        _58 = select(_42, 0.0f, -0.010548308491706848f);
        _59 = select(_42, 0.0f, -0.024003351107239723f);
        _60 = select(_42, 0.0f, -0.1289689838886261f);
        _61 = select(_42, 1.0f, 1.1529725790023804f);
      } else {
        _53 = 0.6954522132873535f;
        _54 = 0.14067870378494263f;
        _55 = 0.16386906802654266f;
        _56 = 0.044794563204050064f;
        _57 = 0.8596711158752441f;
        _58 = 0.0955343171954155f;
        _59 = -0.005525882821530104f;
        _60 = 0.004025210160762072f;
        _61 = 1.0015007257461548f;
      }
    } else {
      _53 = 1.0258246660232544f;
      _54 = -0.020053181797266006f;
      _55 = -0.005771636962890625f;
      _56 = -0.002234415616840124f;
      _57 = 1.0045864582061768f;
      _58 = -0.002352118492126465f;
      _59 = -0.005013350863009691f;
      _60 = -0.025290070101618767f;
      _61 = 1.0303035974502563f;
    }
  } else {
    _53 = 1.3792141675949097f;
    _54 = -0.30886411666870117f;
    _55 = -0.0703500509262085f;
    _56 = -0.06933490186929703f;
    _57 = 1.08229660987854f;
    _58 = -0.012961871922016144f;
    _59 = -0.0021590073592960835f;
    _60 = -0.0454593189060688f;
    _61 = 1.0476183891296387f;
  }
  _74 = (exp2((((cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _75 = (exp2((((cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _24)) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _76 = (exp2(((float((uint)SV_DispatchThreadID.z) / _29) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _112 = (cb0_040w != 0);
    _114 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _131 = (((((1901800.0f - (_114 * 2006400000.0f)) * _114) + 247.47999572753906f) * _114) + 0.23703999817371368f);
    } else {
      _131 = (((((2967800.0f - (_114 * 4607000064.0f)) * _114) + 99.11000061035156f) * _114) + 0.24406300485134125f);
    }
    _145 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _152 = cb0_037y * cb0_037y;
    _155 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_152 * 1.6145605741257896e-07f));
    _160 = ((_145 * 2.0f) + 4.0f) - (_155 * 8.0f);
    _161 = (_145 * 3.0f) / _160;
    _163 = (_155 * 2.0f) / _160;
    _164 = (cb0_037y < 4000.0f);
    _173 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _175 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_152 * 1.5317699909210205f)) / (_173 * _173);
    _182 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _152;
    _184 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_152 * 308.60699462890625f)) / (_182 * _182);
    _186 = rsqrt(dot(float2(_175, _184), float2(_175, _184)));
    _187 = cb0_037z * 0.05000000074505806f;
    _190 = ((_187 * _184) * _186) + _145;
    _193 = _155 - ((_187 * _175) * _186);
    _198 = (4.0f - (_193 * 8.0f)) + (_190 * 2.0f);
    _204 = (((_190 * 3.0f) / _198) - _161) + select(_164, _161, _131);
    _205 = (((_193 * 2.0f) / _198) - _163) + select(_164, _163, (((_131 * 2.869999885559082f) + -0.2750000059604645f) - ((_131 * _131) * 3.0f)));
    _206 = select(_112, _204, 0.3127000033855438f);
    _207 = select(_112, _205, 0.32899999618530273f);
    _208 = select(_112, 0.3127000033855438f, _204);
    _209 = select(_112, 0.32899999618530273f, _205);
    _210 = max(_207, 1.000000013351432e-10f);
    _211 = _206 / _210;
    _214 = ((1.0f - _206) - _207) / _210;
    _215 = max(_209, 1.000000013351432e-10f);
    _216 = _208 / _215;
    _219 = ((1.0f - _208) - _209) / _215;
    _238 = mad(-0.16140000522136688f, _219, ((_216 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _214, ((_211 * 0.8950999975204468f) + 0.266400009393692f));
    _239 = mad(0.03669999912381172f, _219, (1.7135000228881836f - (_216 * 0.7501999735832214f))) / mad(0.03669999912381172f, _214, (1.7135000228881836f - (_211 * 0.7501999735832214f)));
    _240 = mad(1.0296000242233276f, _219, ((_216 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _214, ((_211 * 0.03889999911189079f) + -0.06849999725818634f));
    _241 = mad(_239, -0.7501999735832214f, 0.0f);
    _242 = mad(_239, 1.7135000228881836f, 0.0f);
    _243 = mad(_239, 0.03669999912381172f, -0.0f);
    _244 = mad(_240, 0.03889999911189079f, 0.0f);
    _245 = mad(_240, -0.06849999725818634f, 0.0f);
    _246 = mad(_240, 1.0296000242233276f, 0.0f);
    _249 = mad(0.1599626988172531f, _244, mad(-0.1470542997121811f, _241, (_238 * 0.883457362651825f)));
    _252 = mad(0.1599626988172531f, _245, mad(-0.1470542997121811f, _242, (_238 * 0.26293492317199707f)));
    _255 = mad(0.1599626988172531f, _246, mad(-0.1470542997121811f, _243, (_238 * -0.15930065512657166f)));
    _258 = mad(0.04929120093584061f, _244, mad(0.5183603167533875f, _241, (_238 * 0.38695648312568665f)));
    _261 = mad(0.04929120093584061f, _245, mad(0.5183603167533875f, _242, (_238 * 0.11516613513231277f)));
    _264 = mad(0.04929120093584061f, _246, mad(0.5183603167533875f, _243, (_238 * -0.0697740763425827f)));
    _267 = mad(0.9684867262840271f, _244, mad(0.04004279896616936f, _241, (_238 * -0.007634039502590895f)));
    _270 = mad(0.9684867262840271f, _245, mad(0.04004279896616936f, _242, (_238 * -0.0022720457054674625f)));
    _273 = mad(0.9684867262840271f, _246, mad(0.04004279896616936f, _243, (_238 * 0.0013765322510153055f)));
    _276 = mad(_255, (WorkingColorSpace_000[2].x), mad(_252, (WorkingColorSpace_000[1].x), (_249 * (WorkingColorSpace_000[0].x))));
    _279 = mad(_255, (WorkingColorSpace_000[2].y), mad(_252, (WorkingColorSpace_000[1].y), (_249 * (WorkingColorSpace_000[0].y))));
    _282 = mad(_255, (WorkingColorSpace_000[2].z), mad(_252, (WorkingColorSpace_000[1].z), (_249 * (WorkingColorSpace_000[0].z))));
    _285 = mad(_264, (WorkingColorSpace_000[2].x), mad(_261, (WorkingColorSpace_000[1].x), (_258 * (WorkingColorSpace_000[0].x))));
    _288 = mad(_264, (WorkingColorSpace_000[2].y), mad(_261, (WorkingColorSpace_000[1].y), (_258 * (WorkingColorSpace_000[0].y))));
    _291 = mad(_264, (WorkingColorSpace_000[2].z), mad(_261, (WorkingColorSpace_000[1].z), (_258 * (WorkingColorSpace_000[0].z))));
    _294 = mad(_273, (WorkingColorSpace_000[2].x), mad(_270, (WorkingColorSpace_000[1].x), (_267 * (WorkingColorSpace_000[0].x))));
    _297 = mad(_273, (WorkingColorSpace_000[2].y), mad(_270, (WorkingColorSpace_000[1].y), (_267 * (WorkingColorSpace_000[0].y))));
    _300 = mad(_273, (WorkingColorSpace_000[2].z), mad(_270, (WorkingColorSpace_000[1].z), (_267 * (WorkingColorSpace_000[0].z))));
    _338 = mad(mad((WorkingColorSpace_064[0].z), _300, mad((WorkingColorSpace_064[0].y), _291, (_282 * (WorkingColorSpace_064[0].x)))), _76, mad(mad((WorkingColorSpace_064[0].z), _297, mad((WorkingColorSpace_064[0].y), _288, (_279 * (WorkingColorSpace_064[0].x)))), _75, (mad((WorkingColorSpace_064[0].z), _294, mad((WorkingColorSpace_064[0].y), _285, (_276 * (WorkingColorSpace_064[0].x)))) * _74)));
    _339 = mad(mad((WorkingColorSpace_064[1].z), _300, mad((WorkingColorSpace_064[1].y), _291, (_282 * (WorkingColorSpace_064[1].x)))), _76, mad(mad((WorkingColorSpace_064[1].z), _297, mad((WorkingColorSpace_064[1].y), _288, (_279 * (WorkingColorSpace_064[1].x)))), _75, (mad((WorkingColorSpace_064[1].z), _294, mad((WorkingColorSpace_064[1].y), _285, (_276 * (WorkingColorSpace_064[1].x)))) * _74)));
    _340 = mad(mad((WorkingColorSpace_064[2].z), _300, mad((WorkingColorSpace_064[2].y), _291, (_282 * (WorkingColorSpace_064[2].x)))), _76, mad(mad((WorkingColorSpace_064[2].z), _297, mad((WorkingColorSpace_064[2].y), _288, (_279 * (WorkingColorSpace_064[2].x)))), _75, (mad((WorkingColorSpace_064[2].z), _294, mad((WorkingColorSpace_064[2].y), _285, (_276 * (WorkingColorSpace_064[2].x)))) * _74)));
  } else {
    _338 = _74;
    _339 = _75;
    _340 = _76;
  }
  _355 = mad((WorkingColorSpace_128[0].z), _340, mad((WorkingColorSpace_128[0].y), _339, ((WorkingColorSpace_128[0].x) * _338)));
  _358 = mad((WorkingColorSpace_128[1].z), _340, mad((WorkingColorSpace_128[1].y), _339, ((WorkingColorSpace_128[1].x) * _338)));
  _361 = mad((WorkingColorSpace_128[2].z), _340, mad((WorkingColorSpace_128[2].y), _339, ((WorkingColorSpace_128[2].x) * _338)));
  _362 = dot(float3(_355, _358, _361), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _366 = (_355 / _362) + -1.0f;
  _367 = (_358 / _362) + -1.0f;
  _368 = (_361 / _362) + -1.0f;
  _380 = (1.0f - exp2(((_362 * _362) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_366, _367, _368), float3(_366, _367, _368)) * -4.0f));
  _396 = ((mad(-0.06368321925401688f, _361, mad(-0.3292922377586365f, _358, (_355 * 1.3704125881195068f))) - _355) * _380) + _355;
  _397 = ((mad(-0.010861365124583244f, _361, mad(1.0970927476882935f, _358, (_355 * -0.08343357592821121f))) - _358) * _380) + _358;
  _398 = ((mad(1.2036951780319214f, _361, mad(-0.09862580895423889f, _358, (_355 * -0.02579331398010254f))) - _361) * _380) + _361;
  _399 = dot(float3(_396, _397, _398), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _413 = cb0_021w + cb0_026w;
  _427 = cb0_020w * cb0_025w;
  _441 = cb0_019w * cb0_024w;
  _455 = cb0_018w * cb0_023w;
  _469 = cb0_017w * cb0_022w;
  _473 = _396 - _399;
  _474 = _397 - _399;
  _475 = _398 - _399;
  _532 = saturate(_399 / cb0_037w);
  _536 = (_532 * _532) * (3.0f - (_532 * 2.0f));
  _537 = 1.0f - _536;
  _546 = cb0_021w + cb0_036w;
  _555 = cb0_020w * cb0_035w;
  _564 = cb0_019w * cb0_034w;
  _573 = cb0_018w * cb0_033w;
  _582 = cb0_017w * cb0_032w;
  _645 = saturate((_399 - cb0_038x) / (cb0_038y - cb0_038x));
  _649 = (_645 * _645) * (3.0f - (_645 * 2.0f));
  _658 = cb0_021w + cb0_031w;
  _667 = cb0_020w * cb0_030w;
  _676 = cb0_019w * cb0_029w;
  _685 = cb0_018w * cb0_028w;
  _694 = cb0_017w * cb0_027w;
  _752 = _536 - _649;
  _763 = ((_649 * (((cb0_021x + cb0_036x) + _546) + (((cb0_020x * cb0_035x) * _555) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _573) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _582) * _473) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _564)))))) + (_537 * (((cb0_021x + cb0_026x) + _413) + (((cb0_020x * cb0_025x) * _427) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _455) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _469) * _473) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _441))))))) + ((((cb0_021x + cb0_031x) + _658) + (((cb0_020x * cb0_030x) * _667) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _685) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _694) * _473) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _676))))) * _752);
  _765 = ((_649 * (((cb0_021y + cb0_036y) + _546) + (((cb0_020y * cb0_035y) * _555) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _573) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _582) * _474) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _564)))))) + (_537 * (((cb0_021y + cb0_026y) + _413) + (((cb0_020y * cb0_025y) * _427) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _455) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _469) * _474) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _441))))))) + ((((cb0_021y + cb0_031y) + _658) + (((cb0_020y * cb0_030y) * _667) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _685) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _694) * _474) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _676))))) * _752);
  _767 = ((_649 * (((cb0_021z + cb0_036z) + _546) + (((cb0_020z * cb0_035z) * _555) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _573) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _582) * _475) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _564)))))) + (_537 * (((cb0_021z + cb0_026z) + _413) + (((cb0_020z * cb0_025z) * _427) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _455) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _469) * _475) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _441))))))) + ((((cb0_021z + cb0_031z) + _658) + (((cb0_020z * cb0_030z) * _667) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _685) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _694) * _475) + _399)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _676))))) * _752);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_040x;
  cb_config.ue_filmtoe = cb0_039z;
  cb_config.ue_filmshoulder = cb0_039w;
  cb_config.ue_filmslope = cb0_039y;
  cb_config.ue_filmwhiteclip = cb0_040y;
  cb_config.ue_tonecurveammount = cb0_039x;
  cb_config.ue_mappingpolynomial = float3(cb0_041x, cb0_041y, cb0_041z);
  cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
  cb_config.ue_bluecorrection = cb0_038z;
  cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;
  float4 output = ProcessLutbuilder(float3(_763, _765, _767), s0, s1, t0, t1, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], 0u);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _782 = ((mad(0.061360642313957214f, _767, mad(-4.540197551250458e-09f, _765, (_763 * 0.9386394023895264f))) - _763) * cb0_038z) + _763;
  _783 = ((mad(0.169205904006958f, _767, mad(0.8307942152023315f, _765, (_763 * 6.775371730327606e-08f))) - _765) * cb0_038z) + _765;
  _784 = (mad(-2.3283064365386963e-10f, _765, (_763 * -9.313225746154785e-10f)) * cb0_038z) + _767;
  _787 = mad(0.16386905312538147f, _784, mad(0.14067868888378143f, _783, (_782 * 0.6954522132873535f)));
  _790 = mad(0.0955343246459961f, _784, mad(0.8596711158752441f, _783, (_782 * 0.044794581830501556f)));
  _793 = mad(1.0015007257461548f, _784, mad(0.004025210160762072f, _783, (_782 * -0.005525882821530104f)));
  _797 = max(max(_787, _790), _793);
  _802 = (max(_797, 1.000000013351432e-10f) - max(min(min(_787, _790), _793), 1.000000013351432e-10f)) / max(_797, 0.009999999776482582f);
  _815 = ((_790 + _787) + _793) + (sqrt((((_793 - _790) * _793) + ((_790 - _787) * _790)) + ((_787 - _793) * _787)) * 1.75f);
  _816 = _815 * 0.3333333432674408f;
  _817 = _802 + -0.4000000059604645f;
  _818 = _817 * 5.0f;
  _822 = max((1.0f - abs(_817 * 2.5f)), 0.0f);
  _833 = ((float((int)(((int)(uint)((int)(_818 > 0.0f))) - ((int)(uint)((int)(_818 < 0.0f))))) * (1.0f - (_822 * _822))) + 1.0f) * 0.02500000037252903f;
  if (_816 > 0.0533333346247673f) {
    if (_816 < 0.1599999964237213f) {
      _842 = (((0.23999999463558197f / _815) + -0.5f) * _833);
    } else {
      _842 = 0.0f;
    }
  } else {
    _842 = _833;
  }
  _843 = _842 + 1.0f;
  _844 = _843 * _787;
  _845 = _843 * _790;
  _846 = _843 * _793;
  if (!((_844 == _845) && (_845 == _846))) {
    _853 = ((_844 * 2.0f) - _845) - _846;
    _856 = ((_790 - _793) * 1.7320507764816284f) * _843;
    _858 = atan(_856 / _853);
    _861 = (_853 < 0.0f);
    _862 = (_853 == 0.0f);
    _863 = (_856 >= 0.0f);
    _864 = (_856 < 0.0f);
    _875 = select((_863 && _862), 90.0f, select((_864 && _862), -90.0f, (select((_864 && _861), (_858 + -3.1415927410125732f), select((_863 && _861), (_858 + 3.1415927410125732f), _858)) * 57.2957763671875f)));
  } else {
    _875 = 0.0f;
  }
  _880 = min(max(select((_875 < 0.0f), (_875 + 360.0f), _875), 0.0f), 360.0f);
  if (_880 < -180.0f) {
    _889 = (_880 + 360.0f);
  } else {
    if (_880 > 180.0f) {
      _889 = (_880 + -360.0f);
    } else {
      _889 = _880;
    }
  }
  _893 = saturate(1.0f - abs(_889 * 0.014814814552664757f));
  _897 = (_893 * _893) * (3.0f - (_893 * 2.0f));
  _903 = ((_897 * _897) * ((_802 * 0.18000000715255737f) * (0.029999999329447746f - _844))) + _844;
  _913 = max(0.0f, mad(-0.21492856740951538f, _846, mad(-0.2365107536315918f, _845, (_903 * 1.4514392614364624f))));
  _914 = max(0.0f, mad(-0.09967592358589172f, _846, mad(1.17622971534729f, _845, (_903 * -0.07655377686023712f))));
  _915 = max(0.0f, mad(0.9977163076400757f, _846, mad(-0.006032449658960104f, _845, (_903 * 0.008316148072481155f))));
  _916 = dot(float3(_913, _914, _915), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _931 = (cb0_040x + 1.0f) - cb0_039z;
  _933 = cb0_040y + 1.0f;
  _935 = _933 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _953 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _944 = (cb0_040x + 0.18000000715255737f) / _931;
    _953 = (-0.7447274923324585f - ((log2(_944 / (2.0f - _944)) * 0.3465735912322998f) * (_931 / cb0_039y)));
  }
  _956 = ((1.0f - cb0_039z) / cb0_039y) - _953;
  _958 = (cb0_039w / cb0_039y) - _956;
  _962 = log2(lerp(_916, _913, 0.9599999785423279f)) * 0.3010300099849701f;
  _963 = log2(lerp(_916, _914, 0.9599999785423279f)) * 0.3010300099849701f;
  _964 = log2(lerp(_916, _915, 0.9599999785423279f)) * 0.3010300099849701f;
  _968 = cb0_039y * (_962 + _956);
  _969 = cb0_039y * (_963 + _956);
  _970 = cb0_039y * (_964 + _956);
  _971 = _931 * 2.0f;
  _973 = (cb0_039y * -2.0f) / _931;
  _974 = _962 - _953;
  _975 = _963 - _953;
  _976 = _964 - _953;
  _995 = _935 * 2.0f;
  _997 = (cb0_039y * 2.0f) / _935;
  _1022 = select((_962 < _953), ((_971 / (exp2((_974 * 1.4426950216293335f) * _973) + 1.0f)) - cb0_040x), _968);
  _1023 = select((_963 < _953), ((_971 / (exp2((_975 * 1.4426950216293335f) * _973) + 1.0f)) - cb0_040x), _969);
  _1024 = select((_964 < _953), ((_971 / (exp2((_976 * 1.4426950216293335f) * _973) + 1.0f)) - cb0_040x), _970);
  _1031 = _958 - _953;
  _1035 = saturate(_974 / _1031);
  _1036 = saturate(_975 / _1031);
  _1037 = saturate(_976 / _1031);
  _1038 = (_958 < _953);
  _1042 = select(_1038, (1.0f - _1035), _1035);
  _1043 = select(_1038, (1.0f - _1036), _1036);
  _1044 = select(_1038, (1.0f - _1037), _1037);
  _1063 = (((_1042 * _1042) * (select((_962 > _958), (_933 - (_995 / (exp2(((_962 - _958) * 1.4426950216293335f) * _997) + 1.0f))), _968) - _1022)) * (3.0f - (_1042 * 2.0f))) + _1022;
  _1064 = (((_1043 * _1043) * (select((_963 > _958), (_933 - (_995 / (exp2(((_963 - _958) * 1.4426950216293335f) * _997) + 1.0f))), _969) - _1023)) * (3.0f - (_1043 * 2.0f))) + _1023;
  _1065 = (((_1044 * _1044) * (select((_964 > _958), (_933 - (_995 / (exp2(((_964 - _958) * 1.4426950216293335f) * _997) + 1.0f))), _970) - _1024)) * (3.0f - (_1044 * 2.0f))) + _1024;
  _1066 = dot(float3(_1063, _1064, _1065), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1086 = (cb0_039x * (max(0.0f, (lerp(_1066, _1063, 0.9300000071525574f))) - _782)) + _782;
  _1087 = (cb0_039x * (max(0.0f, (lerp(_1066, _1064, 0.9300000071525574f))) - _783)) + _783;
  _1088 = (cb0_039x * (max(0.0f, (lerp(_1066, _1065, 0.9300000071525574f))) - _784)) + _784;
  _1104 = ((mad(-0.06537103652954102f, _1088, mad(1.451815478503704e-06f, _1087, (_1086 * 1.065374732017517f))) - _1086) * cb0_038z) + _1086;
  _1105 = ((mad(-0.20366770029067993f, _1088, mad(1.2036634683609009f, _1087, (_1086 * -2.57161445915699e-07f))) - _1087) * cb0_038z) + _1087;
  _1106 = ((mad(0.9999996423721313f, _1088, mad(2.0954757928848267e-08f, _1087, (_1086 * 1.862645149230957e-08f))) - _1088) * cb0_038z) + _1088;
  _1131 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1106, mad((WorkingColorSpace_192[0].y), _1105, ((WorkingColorSpace_192[0].x) * _1104)))));
  _1132 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1106, mad((WorkingColorSpace_192[1].y), _1105, ((WorkingColorSpace_192[1].x) * _1104)))));
  _1133 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1106, mad((WorkingColorSpace_192[2].y), _1105, ((WorkingColorSpace_192[2].x) * _1104)))));
  if (_1131 < 0.0031306699384003878f) {
    _1144 = (_1131 * 12.920000076293945f);
  } else {
    _1144 = (((pow(_1131, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1132 < 0.0031306699384003878f) {
    _1155 = (_1132 * 12.920000076293945f);
  } else {
    _1155 = (((pow(_1132, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1133 < 0.0031306699384003878f) {
    _1166 = (_1133 * 12.920000076293945f);
  } else {
    _1166 = (((pow(_1133, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1170 = (_1155 * 0.9375f) + 0.03125f;
  _1177 = _1166 * 15.0f;
  _1178 = floor(_1177);
  _1179 = _1177 - _1178;
  _1181 = (_1178 + ((_1144 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1184 = t0.SampleLevel(s0, float2(_1181, _1170), 0.0f);
  _1188 = _1181 + 0.0625f;
  _1189 = t0.SampleLevel(s0, float2(_1188, _1170), 0.0f);
  _1211 = t1.SampleLevel(s1, float2(_1181, _1170), 0.0f);
  _1215 = t1.SampleLevel(s1, float2(_1188, _1170), 0.0f);
  _1231 = (((lerp(_1184.x, _1189.x, _1179)) * cb0_005y) + (cb0_005x * _1144)) + ((lerp(_1211.x, _1215.x, _1179)) * cb0_005z);
  _1232 = (((lerp(_1184.y, _1189.y, _1179)) * cb0_005y) + (cb0_005x * _1155)) + ((lerp(_1211.y, _1215.y, _1179)) * cb0_005z);
  _1233 = (((lerp(_1184.z, _1189.z, _1179)) * cb0_005y) + (cb0_005x * _1166)) + ((lerp(_1211.z, _1215.z, _1179)) * cb0_005z);
  _1258 = select((_1231 > 0.040449999272823334f), exp2(log2((abs(_1231) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1231 * 0.07739938050508499f));
  _1259 = select((_1232 > 0.040449999272823334f), exp2(log2((abs(_1232) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1232 * 0.07739938050508499f));
  _1260 = select((_1233 > 0.040449999272823334f), exp2(log2((abs(_1233) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1233 * 0.07739938050508499f));
  _1286 = cb0_016x * (((cb0_041y + (cb0_041x * _1258)) * _1258) + cb0_041z);
  _1287 = cb0_016y * (((cb0_041y + (cb0_041x * _1259)) * _1259) + cb0_041z);
  _1288 = cb0_016z * (((cb0_041y + (cb0_041x * _1260)) * _1260) + cb0_041z);
  _1309 = exp2(log2(max(0.0f, (lerp(_1286, cb0_015x, cb0_015w)))) * cb0_042y);
  _1310 = exp2(log2(max(0.0f, (lerp(_1287, cb0_015y, cb0_015w)))) * cb0_042y);
  _1311 = exp2(log2(max(0.0f, (lerp(_1288, cb0_015z, cb0_015w)))) * cb0_042y);
  if (WorkingColorSpace_384 == 0) {
    _1318 = mad((WorkingColorSpace_128[0].z), _1311, mad((WorkingColorSpace_128[0].y), _1310, ((WorkingColorSpace_128[0].x) * _1309)));
    _1321 = mad((WorkingColorSpace_128[1].z), _1311, mad((WorkingColorSpace_128[1].y), _1310, ((WorkingColorSpace_128[1].x) * _1309)));
    _1324 = mad((WorkingColorSpace_128[2].z), _1311, mad((WorkingColorSpace_128[2].y), _1310, ((WorkingColorSpace_128[2].x) * _1309)));
    _1335 = mad(_55, _1324, mad(_54, _1321, (_1318 * _53)));
    _1336 = mad(_58, _1324, mad(_57, _1321, (_1318 * _56)));
    _1337 = mad(_61, _1324, mad(_60, _1321, (_1318 * _59)));
  } else {
    _1335 = _1309;
    _1336 = _1310;
    _1337 = _1311;
  }
  if (_1335 < 0.0031306699384003878f) {
    _1348 = (_1335 * 12.920000076293945f);
  } else {
    _1348 = (((pow(_1335, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1336 < 0.0031306699384003878f) {
    _1359 = (_1336 * 12.920000076293945f);
  } else {
    _1359 = (((pow(_1336, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1337 < 0.0031306699384003878f) {
    _1370 = (_1337 * 12.920000076293945f);
  } else {
    _1370 = (((pow(_1337, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_1348 * 0.9523810148239136f), (_1359 * 0.9523810148239136f), (_1370 * 0.9523810148239136f), 0.0f);
}