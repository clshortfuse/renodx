// Directive 8020

#include "../lutbuilderoutput.hlsli"

Texture3D<float4> t0 : register(t0);

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

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  precise noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  float4 SV_Target;
  float _12;
  float _17;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _112;
  float _758;
  float _768;
  float _778;
  float _855;
  float _856;
  float _857;
  float _867;
  float _877;
  float _887;
  float _895;
  float _896;
  float _897;
  float _973;
  float _1006;
  float _1020;
  float _1084;
  float _1348;
  float _1349;
  float _1350;
  float _1361;
  float _1372;
  float _1383;
  bool _30;
  float _62;
  float _63;
  float _64;
  bool _91;
  float _95;
  float _126;
  float _133;
  float _136;
  float _141;
  float _142;
  float _144;
  bool _145;
  float _154;
  float _156;
  float _163;
  float _165;
  float _167;
  float _168;
  float _171;
  float _174;
  float _179;
  float _185;
  float _186;
  float _187;
  float _188;
  float _189;
  float _190;
  float _191;
  float _192;
  float _195;
  float _196;
  float _197;
  float _200;
  float _219;
  float _220;
  float _221;
  float _222;
  float _223;
  float _224;
  float _225;
  float _226;
  float _227;
  float _230;
  float _233;
  float _236;
  float _239;
  float _242;
  float _245;
  float _248;
  float _251;
  float _254;
  float _257;
  float _260;
  float _263;
  float _266;
  float _269;
  float _272;
  float _275;
  float _278;
  float _281;
  float _311;
  float _314;
  float _317;
  float _332;
  float _335;
  float _338;
  float _339;
  float _343;
  float _344;
  float _345;
  float _357;
  float _373;
  float _374;
  float _375;
  float _376;
  float _390;
  float _404;
  float _418;
  float _432;
  float _446;
  float _450;
  float _451;
  float _452;
  float _509;
  float _513;
  float _514;
  float _523;
  float _532;
  float _541;
  float _550;
  float _559;
  float _622;
  float _626;
  float _635;
  float _644;
  float _653;
  float _662;
  float _671;
  float _729;
  float _740;
  float _742;
  float _744;
  float _782;
  float _783;
  float _784;
  float4 _789;
  float4 _797;
  float4 _802;
  float4 _807;
  float _823;
  float _824;
  float _825;
  float _826;
  float _827;
  float _828;
  float _829;
  float _847;
  float _913;
  float _914;
  float _915;
  float _918;
  float _921;
  float _924;
  float _928;
  float _933;
  float _946;
  float _947;
  float _948;
  float _949;
  float _953;
  float _964;
  float _974;
  float _975;
  float _976;
  float _977;
  float _984;
  float _987;
  float _989;
  bool _992;
  bool _993;
  bool _994;
  bool _995;
  float _1011;
  float _1024;
  float _1028;
  float _1034;
  float _1044;
  float _1045;
  float _1046;
  float _1047;
  float _1062;
  float _1064;
  float _1066;
  float _1075;
  float _1087;
  float _1089;
  float _1093;
  float _1094;
  float _1095;
  float _1099;
  float _1100;
  float _1101;
  float _1102;
  float _1104;
  float _1105;
  float _1106;
  float _1107;
  float _1126;
  float _1128;
  float _1153;
  float _1154;
  float _1155;
  float _1162;
  float _1166;
  float _1167;
  float _1168;
  bool _1169;
  float _1173;
  float _1174;
  float _1175;
  float _1194;
  float _1195;
  float _1196;
  float _1197;
  float _1217;
  float _1218;
  float _1219;
  float _1235;
  float _1236;
  float _1237;
  float _1259;
  float _1260;
  float _1261;
  float _1287;
  float _1288;
  float _1289;
  float _1310;
  float _1311;
  float _1312;
  float _1331;
  float _1334;
  float _1337;
  _12 = 0.5f / cb0_035x;
  _17 = cb0_035x + -1.0f;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        _30 = (cb0_041x == 4);
        _41 = select(_30, 1.0f, 1.705051064491272f);
        _42 = select(_30, 0.0f, -0.6217921376228333f);
        _43 = select(_30, 0.0f, -0.0832589864730835f);
        _44 = select(_30, 0.0f, -0.13025647401809692f);
        _45 = select(_30, 1.0f, 1.140804648399353f);
        _46 = select(_30, 0.0f, -0.010548308491706848f);
        _47 = select(_30, 0.0f, -0.024003351107239723f);
        _48 = select(_30, 0.0f, -0.1289689838886261f);
        _49 = select(_30, 1.0f, 1.1529725790023804f);
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
      _41 = 1.0258246660232544f;
      _42 = -0.020053181797266006f;
      _43 = -0.005771636962890625f;
      _44 = -0.002234415616840124f;
      _45 = 1.0045864582061768f;
      _46 = -0.002352118492126465f;
      _47 = -0.005013350863009691f;
      _48 = -0.025290070101618767f;
      _49 = 1.0303035974502563f;
    }
  } else {
    _41 = 1.3792141675949097f;
    _42 = -0.30886411666870117f;
    _43 = -0.0703500509262085f;
    _44 = -0.06933490186929703f;
    _45 = 1.08229660987854f;
    _46 = -0.012961871922016144f;
    _47 = -0.0021590073592960835f;
    _48 = -0.0454593189060688f;
    _49 = 1.0476183891296387f;
  }
  _62 = (exp2((((cb0_035x * (TEXCOORD.x - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _63 = (exp2((((cb0_035x * (TEXCOORD.y - _12)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _64 = (exp2(((float((uint)(uint)(SV_RenderTargetArrayIndex)) / _17) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _91 = (cb0_038w != 0);
  _95 = 0.9994439482688904f / cb0_035y;
  if ((cb0_035y * 1.0005563497543335f) > 7000.0f) {
    _112 = (((((1901800.0f - (_95 * 2006400000.0f)) * _95) + 247.47999572753906f) * _95) + 0.23703999817371368f);
  } else {
    _112 = (((((2967800.0f - (_95 * 4607000064.0f)) * _95) + 99.11000061035156f) * _95) + 0.24406300485134125f);
  }
  _126 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  _133 = cb0_035y * cb0_035y;
  _136 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_133 * 1.6145605741257896e-07f));
  _141 = ((_126 * 2.0f) + 4.0f) - (_136 * 8.0f);
  _142 = (_126 * 3.0f) / _141;
  _144 = (_136 * 2.0f) / _141;
  _145 = (cb0_035y < 4000.0f);
  _154 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  _156 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_133 * 1.5317699909210205f)) / (_154 * _154);
  _163 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _133;
  _165 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_133 * 308.60699462890625f)) / (_163 * _163);
  _167 = rsqrt(dot(float2(_156, _165), float2(_156, _165)));
  _168 = cb0_035z * 0.05000000074505806f;
  _171 = ((_168 * _165) * _167) + _126;
  _174 = _136 - ((_168 * _156) * _167);
  _179 = (4.0f - (_174 * 8.0f)) + (_171 * 2.0f);
  _185 = (((_171 * 3.0f) / _179) - _142) + select(_145, _142, _112);
  _186 = (((_174 * 2.0f) / _179) - _144) + select(_145, _144, (((_112 * 2.869999885559082f) + -0.2750000059604645f) - ((_112 * _112) * 3.0f)));
  _187 = select(_91, _185, 0.3127000033855438f);
  _188 = select(_91, _186, 0.32899999618530273f);
  _189 = select(_91, 0.3127000033855438f, _185);
  _190 = select(_91, 0.32899999618530273f, _186);
  _191 = max(_188, 1.000000013351432e-10f);
  _192 = _187 / _191;
  _195 = ((1.0f - _187) - _188) / _191;
  _196 = max(_190, 1.000000013351432e-10f);
  _197 = _189 / _196;
  _200 = ((1.0f - _189) - _190) / _196;
  _219 = mad(-0.16140000522136688f, _200, ((_197 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _195, ((_192 * 0.8950999975204468f) + 0.266400009393692f));
  _220 = mad(0.03669999912381172f, _200, (1.7135000228881836f - (_197 * 0.7501999735832214f))) / mad(0.03669999912381172f, _195, (1.7135000228881836f - (_192 * 0.7501999735832214f)));
  _221 = mad(1.0296000242233276f, _200, ((_197 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _195, ((_192 * 0.03889999911189079f) + -0.06849999725818634f));
  _222 = mad(_220, -0.7501999735832214f, 0.0f);
  _223 = mad(_220, 1.7135000228881836f, 0.0f);
  _224 = mad(_220, 0.03669999912381172f, -0.0f);
  _225 = mad(_221, 0.03889999911189079f, 0.0f);
  _226 = mad(_221, -0.06849999725818634f, 0.0f);
  _227 = mad(_221, 1.0296000242233276f, 0.0f);
  _230 = mad(0.1599626988172531f, _225, mad(-0.1470542997121811f, _222, (_219 * 0.883457362651825f)));
  _233 = mad(0.1599626988172531f, _226, mad(-0.1470542997121811f, _223, (_219 * 0.26293492317199707f)));
  _236 = mad(0.1599626988172531f, _227, mad(-0.1470542997121811f, _224, (_219 * -0.15930065512657166f)));
  _239 = mad(0.04929120093584061f, _225, mad(0.5183603167533875f, _222, (_219 * 0.38695648312568665f)));
  _242 = mad(0.04929120093584061f, _226, mad(0.5183603167533875f, _223, (_219 * 0.11516613513231277f)));
  _245 = mad(0.04929120093584061f, _227, mad(0.5183603167533875f, _224, (_219 * -0.0697740763425827f)));
  _248 = mad(0.9684867262840271f, _225, mad(0.04004279896616936f, _222, (_219 * -0.007634039502590895f)));
  _251 = mad(0.9684867262840271f, _226, mad(0.04004279896616936f, _223, (_219 * -0.0022720457054674625f)));
  _254 = mad(0.9684867262840271f, _227, mad(0.04004279896616936f, _224, (_219 * 0.0013765322510153055f)));
  _257 = mad(_236, (WorkingColorSpace_000[2].x), mad(_233, (WorkingColorSpace_000[1].x), (_230 * (WorkingColorSpace_000[0].x))));
  _260 = mad(_236, (WorkingColorSpace_000[2].y), mad(_233, (WorkingColorSpace_000[1].y), (_230 * (WorkingColorSpace_000[0].y))));
  _263 = mad(_236, (WorkingColorSpace_000[2].z), mad(_233, (WorkingColorSpace_000[1].z), (_230 * (WorkingColorSpace_000[0].z))));
  _266 = mad(_245, (WorkingColorSpace_000[2].x), mad(_242, (WorkingColorSpace_000[1].x), (_239 * (WorkingColorSpace_000[0].x))));
  _269 = mad(_245, (WorkingColorSpace_000[2].y), mad(_242, (WorkingColorSpace_000[1].y), (_239 * (WorkingColorSpace_000[0].y))));
  _272 = mad(_245, (WorkingColorSpace_000[2].z), mad(_242, (WorkingColorSpace_000[1].z), (_239 * (WorkingColorSpace_000[0].z))));
  _275 = mad(_254, (WorkingColorSpace_000[2].x), mad(_251, (WorkingColorSpace_000[1].x), (_248 * (WorkingColorSpace_000[0].x))));
  _278 = mad(_254, (WorkingColorSpace_000[2].y), mad(_251, (WorkingColorSpace_000[1].y), (_248 * (WorkingColorSpace_000[0].y))));
  _281 = mad(_254, (WorkingColorSpace_000[2].z), mad(_251, (WorkingColorSpace_000[1].z), (_248 * (WorkingColorSpace_000[0].z))));
  _311 = mad(mad((WorkingColorSpace_064[0].z), _281, mad((WorkingColorSpace_064[0].y), _272, (_263 * (WorkingColorSpace_064[0].x)))), _64, mad(mad((WorkingColorSpace_064[0].z), _278, mad((WorkingColorSpace_064[0].y), _269, (_260 * (WorkingColorSpace_064[0].x)))), _63, (mad((WorkingColorSpace_064[0].z), _275, mad((WorkingColorSpace_064[0].y), _266, (_257 * (WorkingColorSpace_064[0].x)))) * _62)));
  _314 = mad(mad((WorkingColorSpace_064[1].z), _281, mad((WorkingColorSpace_064[1].y), _272, (_263 * (WorkingColorSpace_064[1].x)))), _64, mad(mad((WorkingColorSpace_064[1].z), _278, mad((WorkingColorSpace_064[1].y), _269, (_260 * (WorkingColorSpace_064[1].x)))), _63, (mad((WorkingColorSpace_064[1].z), _275, mad((WorkingColorSpace_064[1].y), _266, (_257 * (WorkingColorSpace_064[1].x)))) * _62)));
  _317 = mad(mad((WorkingColorSpace_064[2].z), _281, mad((WorkingColorSpace_064[2].y), _272, (_263 * (WorkingColorSpace_064[2].x)))), _64, mad(mad((WorkingColorSpace_064[2].z), _278, mad((WorkingColorSpace_064[2].y), _269, (_260 * (WorkingColorSpace_064[2].x)))), _63, (mad((WorkingColorSpace_064[2].z), _275, mad((WorkingColorSpace_064[2].y), _266, (_257 * (WorkingColorSpace_064[2].x)))) * _62)));
  _332 = mad((WorkingColorSpace_128[0].z), _317, mad((WorkingColorSpace_128[0].y), _314, ((WorkingColorSpace_128[0].x) * _311)));
  _335 = mad((WorkingColorSpace_128[1].z), _317, mad((WorkingColorSpace_128[1].y), _314, ((WorkingColorSpace_128[1].x) * _311)));
  _338 = mad((WorkingColorSpace_128[2].z), _317, mad((WorkingColorSpace_128[2].y), _314, ((WorkingColorSpace_128[2].x) * _311)));
  _339 = dot(float3(_332, _335, _338), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _343 = (_332 / _339) + -1.0f;
  _344 = (_335 / _339) + -1.0f;
  _345 = (_338 / _339) + -1.0f;
  _357 = (1.0f - exp2(((_339 * _339) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_343, _344, _345), float3(_343, _344, _345)) * -4.0f));
  _373 = ((mad(-0.06368321925401688f, _338, mad(-0.3292922377586365f, _335, (_332 * 1.3704125881195068f))) - _332) * _357) + _332;
  _374 = ((mad(-0.010861365124583244f, _338, mad(1.0970927476882935f, _335, (_332 * -0.08343357592821121f))) - _335) * _357) + _335;
  _375 = ((mad(1.2036951780319214f, _338, mad(-0.09862580895423889f, _335, (_332 * -0.02579331398010254f))) - _338) * _357) + _338;
  _376 = dot(float3(_373, _374, _375), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _390 = cb0_019w + cb0_024w;
  _404 = cb0_018w * cb0_023w;
  _418 = cb0_017w * cb0_022w;
  _432 = cb0_016w * cb0_021w;
  _446 = cb0_015w * cb0_020w;
  _450 = _373 - _376;
  _451 = _374 - _376;
  _452 = _375 - _376;
  _509 = saturate(_376 / cb0_035w);
  _513 = (_509 * _509) * (3.0f - (_509 * 2.0f));
  _514 = 1.0f - _513;
  _523 = cb0_019w + cb0_034w;
  _532 = cb0_018w * cb0_033w;
  _541 = cb0_017w * cb0_032w;
  _550 = cb0_016w * cb0_031w;
  _559 = cb0_015w * cb0_030w;
  _622 = saturate((_376 - cb0_036x) / (cb0_036y - cb0_036x));
  _626 = (_622 * _622) * (3.0f - (_622 * 2.0f));
  _635 = cb0_019w + cb0_029w;
  _644 = cb0_018w * cb0_028w;
  _653 = cb0_017w * cb0_027w;
  _662 = cb0_016w * cb0_026w;
  _671 = cb0_015w * cb0_025w;
  _729 = _513 - _626;
  _740 = ((_626 * (((cb0_019x + cb0_034x) + _523) + (((cb0_018x * cb0_033x) * _532) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _550) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _559) * _450) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _541)))))) + (_514 * (((cb0_019x + cb0_024x) + _390) + (((cb0_018x * cb0_023x) * _404) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _432) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _446) * _450) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _418))))))) + ((((cb0_019x + cb0_029x) + _635) + (((cb0_018x * cb0_028x) * _644) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _662) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _671) * _450) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _653))))) * _729);
  _742 = ((_626 * (((cb0_019y + cb0_034y) + _523) + (((cb0_018y * cb0_033y) * _532) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _550) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _559) * _451) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _541)))))) + (_514 * (((cb0_019y + cb0_024y) + _390) + (((cb0_018y * cb0_023y) * _404) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _432) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _446) * _451) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _418))))))) + ((((cb0_019y + cb0_029y) + _635) + (((cb0_018y * cb0_028y) * _644) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _662) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _671) * _451) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _653))))) * _729);
  _744 = ((_626 * (((cb0_019z + cb0_034z) + _523) + (((cb0_018z * cb0_033z) * _532) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _550) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _559) * _452) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _541)))))) + (_514 * (((cb0_019z + cb0_024z) + _390) + (((cb0_018z * cb0_023z) * _404) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _432) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _446) * _452) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _418))))))) + ((((cb0_019z + cb0_029z) + _635) + (((cb0_018z * cb0_028z) * _644) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _662) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _671) * _452) + _376)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _653))))) * _729);
  if (!(cb0_042x == 0)) {
    if (_740 > 0.0078125f) {
      _758 = ((log2(_740) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _758 = ((_740 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_742 > 0.0078125f) {
      _768 = ((log2(_742) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _768 = ((_742 * 10.540237426757812f) + 0.072905533015728f);
    }
    if (_744 > 0.0078125f) {
      _778 = ((log2(_744) + 9.720000267028809f) * 0.05707762390375137f);
    } else {
      _778 = ((_744 * 10.540237426757812f) + 0.072905533015728f);
    }
    _782 = min(max(_758, 0.0f), 1.0f);
    _783 = min(max(_768, 0.0f), 1.0f);
    _784 = min(max(_778, 0.0f), 1.0f);
    _789 = t0.Sample(s0, float3(_782, _783, _784));
    if (cb0_042y == 1) {
      _797 = t0.Sample(s0, float3((cb0_042z + _782), _783, _784));
      _802 = t0.Sample(s0, float3(_782, (cb0_042z + _783), _784));
      _807 = t0.Sample(s0, float3(_782, _783, (cb0_042z + _784)));
      _823 = saturate(1.0f - abs(_782 - floor(_782)));
      _824 = saturate(1.0f - abs(_783 - floor(_783)));
      _825 = saturate(1.0f - abs(_784 - floor(_784)));
      _826 = dot(float3(_823, _824, _825), float3(1.0f, 1.0f, 1.0f));
      _827 = _823 / _826;
      _828 = _824 / _826;
      _829 = _825 / _826;
      _847 = ((1.0f - _827) - _828) - _829;
      _855 = ((((_828 * _797.x) + (_827 * _789.x)) + (_829 * _802.x)) + (_847 * _807.x));
      _856 = ((((_828 * _797.y) + (_827 * _789.y)) + (_829 * _802.y)) + (_847 * _807.y));
      _857 = ((((_828 * _797.z) + (_827 * _789.z)) + (_829 * _802.z)) + (_847 * _807.z));
    } else {
      _855 = _789.x;
      _856 = _789.y;
      _857 = _789.z;
    }
    if (_855 > 0.155251145362854f) {
      _867 = exp2((_855 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _867 = ((_855 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_856 > 0.155251145362854f) {
      _877 = exp2((_856 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _877 = ((_856 + -0.072905533015728f) * 0.09487452358007431f);
    }
    if (_857 > 0.155251145362854f) {
      _887 = exp2((_857 * 17.520000457763672f) + -9.720000267028809f);
    } else {
      _887 = ((_857 + -0.072905533015728f) * 0.09487452358007431f);
    }
    _895 = min(max(_867, 0.0f), 65504.0f);
    _896 = min(max(_877, 0.0f), 65504.0f);
    _897 = min(max(_887, 0.0f), 65504.0f);
  } else {
    _895 = _740;
    _896 = _742;
    _897 = _744;
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
  float4 output = ProcessLutbuilder(float3(_895, _896, _897), cb_config, SV_Target, 0u);
  SV_Target = output;
  return SV_Target;
  _913 = ((mad(0.061360642313957214f, _897, mad(-4.540197551250458e-09f, _896, (_895 * 0.9386394023895264f))) - _895) * cb0_036z) + _895;
  _914 = ((mad(0.169205904006958f, _897, mad(0.8307942152023315f, _896, (_895 * 6.775371730327606e-08f))) - _896) * cb0_036z) + _896;
  _915 = (mad(-2.3283064365386963e-10f, _896, (_895 * -9.313225746154785e-10f)) * cb0_036z) + _897;
  _918 = mad(0.16386905312538147f, _915, mad(0.14067868888378143f, _914, (_913 * 0.6954522132873535f)));
  _921 = mad(0.0955343246459961f, _915, mad(0.8596711158752441f, _914, (_913 * 0.044794581830501556f)));
  _924 = mad(1.0015007257461548f, _915, mad(0.004025210160762072f, _914, (_913 * -0.005525882821530104f)));
  _928 = max(max(_918, _921), _924);
  _933 = (max(_928, 1.000000013351432e-10f) - max(min(min(_918, _921), _924), 1.000000013351432e-10f)) / max(_928, 0.009999999776482582f);
  _946 = ((_921 + _918) + _924) + (sqrt((((_924 - _921) * _924) + ((_921 - _918) * _921)) + ((_918 - _924) * _918)) * 1.75f);
  _947 = _946 * 0.3333333432674408f;
  _948 = _933 + -0.4000000059604645f;
  _949 = _948 * 5.0f;
  _953 = max((1.0f - abs(_948 * 2.5f)), 0.0f);
  _964 = ((float((int)(((int)(uint)((int)(_949 > 0.0f))) - ((int)(uint)((int)(_949 < 0.0f))))) * (1.0f - (_953 * _953))) + 1.0f) * 0.02500000037252903f;
  if (_947 > 0.0533333346247673f) {
    if (_947 < 0.1599999964237213f) {
      _973 = (((0.23999999463558197f / _946) + -0.5f) * _964);
    } else {
      _973 = 0.0f;
    }
  } else {
    _973 = _964;
  }
  _974 = _973 + 1.0f;
  _975 = _974 * _918;
  _976 = _974 * _921;
  _977 = _974 * _924;
  if (!((_975 == _976) && (_976 == _977))) {
    _984 = ((_975 * 2.0f) - _976) - _977;
    _987 = ((_921 - _924) * 1.7320507764816284f) * _974;
    _989 = atan(_987 / _984);
    _992 = (_984 < 0.0f);
    _993 = (_984 == 0.0f);
    _994 = (_987 >= 0.0f);
    _995 = (_987 < 0.0f);
    _1006 = select((_994 && _993), 90.0f, select((_995 && _993), -90.0f, (select((_995 && _992), (_989 + -3.1415927410125732f), select((_994 && _992), (_989 + 3.1415927410125732f), _989)) * 57.2957763671875f)));
  } else {
    _1006 = 0.0f;
  }
  _1011 = min(max(select((_1006 < 0.0f), (_1006 + 360.0f), _1006), 0.0f), 360.0f);
  if (_1011 < -180.0f) {
    _1020 = (_1011 + 360.0f);
  } else {
    if (_1011 > 180.0f) {
      _1020 = (_1011 + -360.0f);
    } else {
      _1020 = _1011;
    }
  }
  _1024 = saturate(1.0f - abs(_1020 * 0.014814814552664757f));
  _1028 = (_1024 * _1024) * (3.0f - (_1024 * 2.0f));
  _1034 = ((_1028 * _1028) * ((_933 * 0.18000000715255737f) * (0.029999999329447746f - _975))) + _975;
  _1044 = max(0.0f, mad(-0.21492856740951538f, _977, mad(-0.2365107536315918f, _976, (_1034 * 1.4514392614364624f))));
  _1045 = max(0.0f, mad(-0.09967592358589172f, _977, mad(1.17622971534729f, _976, (_1034 * -0.07655377686023712f))));
  _1046 = max(0.0f, mad(0.9977163076400757f, _977, mad(-0.006032449658960104f, _976, (_1034 * 0.008316148072481155f))));
  _1047 = dot(float3(_1044, _1045, _1046), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1062 = (cb0_038x + 1.0f) - cb0_037z;
  _1064 = cb0_038y + 1.0f;
  _1066 = _1064 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _1084 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    _1075 = (cb0_038x + 0.18000000715255737f) / _1062;
    _1084 = (-0.7447274923324585f - ((log2(_1075 / (2.0f - _1075)) * 0.3465735912322998f) * (_1062 / cb0_037y)));
  }
  _1087 = ((1.0f - cb0_037z) / cb0_037y) - _1084;
  _1089 = (cb0_037w / cb0_037y) - _1087;
  _1093 = log2(lerp(_1047, _1044, 0.9599999785423279f)) * 0.3010300099849701f;
  _1094 = log2(lerp(_1047, _1045, 0.9599999785423279f)) * 0.3010300099849701f;
  _1095 = log2(lerp(_1047, _1046, 0.9599999785423279f)) * 0.3010300099849701f;
  _1099 = cb0_037y * (_1093 + _1087);
  _1100 = cb0_037y * (_1094 + _1087);
  _1101 = cb0_037y * (_1095 + _1087);
  _1102 = _1062 * 2.0f;
  _1104 = (cb0_037y * -2.0f) / _1062;
  _1105 = _1093 - _1084;
  _1106 = _1094 - _1084;
  _1107 = _1095 - _1084;
  _1126 = _1066 * 2.0f;
  _1128 = (cb0_037y * 2.0f) / _1066;
  _1153 = select((_1093 < _1084), ((_1102 / (exp2((_1105 * 1.4426950216293335f) * _1104) + 1.0f)) - cb0_038x), _1099);
  _1154 = select((_1094 < _1084), ((_1102 / (exp2((_1106 * 1.4426950216293335f) * _1104) + 1.0f)) - cb0_038x), _1100);
  _1155 = select((_1095 < _1084), ((_1102 / (exp2((_1107 * 1.4426950216293335f) * _1104) + 1.0f)) - cb0_038x), _1101);
  _1162 = _1089 - _1084;
  _1166 = saturate(_1105 / _1162);
  _1167 = saturate(_1106 / _1162);
  _1168 = saturate(_1107 / _1162);
  _1169 = (_1089 < _1084);
  _1173 = select(_1169, (1.0f - _1166), _1166);
  _1174 = select(_1169, (1.0f - _1167), _1167);
  _1175 = select(_1169, (1.0f - _1168), _1168);
  _1194 = (((_1173 * _1173) * (select((_1093 > _1089), (_1064 - (_1126 / (exp2(((_1093 - _1089) * 1.4426950216293335f) * _1128) + 1.0f))), _1099) - _1153)) * (3.0f - (_1173 * 2.0f))) + _1153;
  _1195 = (((_1174 * _1174) * (select((_1094 > _1089), (_1064 - (_1126 / (exp2(((_1094 - _1089) * 1.4426950216293335f) * _1128) + 1.0f))), _1100) - _1154)) * (3.0f - (_1174 * 2.0f))) + _1154;
  _1196 = (((_1175 * _1175) * (select((_1095 > _1089), (_1064 - (_1126 / (exp2(((_1095 - _1089) * 1.4426950216293335f) * _1128) + 1.0f))), _1101) - _1155)) * (3.0f - (_1175 * 2.0f))) + _1155;
  _1197 = dot(float3(_1194, _1195, _1196), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1217 = (cb0_037x * (max(0.0f, (lerp(_1197, _1194, 0.9300000071525574f))) - _913)) + _913;
  _1218 = (cb0_037x * (max(0.0f, (lerp(_1197, _1195, 0.9300000071525574f))) - _914)) + _914;
  _1219 = (cb0_037x * (max(0.0f, (lerp(_1197, _1196, 0.9300000071525574f))) - _915)) + _915;
  _1235 = ((mad(-0.06537103652954102f, _1219, mad(1.451815478503704e-06f, _1218, (_1217 * 1.065374732017517f))) - _1217) * cb0_036z) + _1217;
  _1236 = ((mad(-0.20366770029067993f, _1219, mad(1.2036634683609009f, _1218, (_1217 * -2.57161445915699e-07f))) - _1218) * cb0_036z) + _1218;
  _1237 = ((mad(0.9999996423721313f, _1219, mad(2.0954757928848267e-08f, _1218, (_1217 * 1.862645149230957e-08f))) - _1219) * cb0_036z) + _1219;
  _1259 = max(0.0f, mad((WorkingColorSpace_192[0].z), _1237, mad((WorkingColorSpace_192[0].y), _1236, ((WorkingColorSpace_192[0].x) * _1235))));
  _1260 = max(0.0f, mad((WorkingColorSpace_192[1].z), _1237, mad((WorkingColorSpace_192[1].y), _1236, ((WorkingColorSpace_192[1].x) * _1235))));
  _1261 = max(0.0f, mad((WorkingColorSpace_192[2].z), _1237, mad((WorkingColorSpace_192[2].y), _1236, ((WorkingColorSpace_192[2].x) * _1235))));
  _1287 = cb0_014x * (((cb0_039y + (cb0_039x * _1259)) * _1259) + cb0_039z);
  _1288 = cb0_014y * (((cb0_039y + (cb0_039x * _1260)) * _1260) + cb0_039z);
  _1289 = cb0_014z * (((cb0_039y + (cb0_039x * _1261)) * _1261) + cb0_039z);
  _1310 = exp2(log2(max(0.0f, (lerp(_1287, cb0_013x, cb0_013w)))) * cb0_040y);
  _1311 = exp2(log2(max(0.0f, (lerp(_1288, cb0_013y, cb0_013w)))) * cb0_040y);
  _1312 = exp2(log2(max(0.0f, (lerp(_1289, cb0_013z, cb0_013w)))) * cb0_040y);
  if (WorkingColorSpace_320 == 0) {
    _1331 = mad((WorkingColorSpace_128[0].z), _1312, mad((WorkingColorSpace_128[0].y), _1311, ((WorkingColorSpace_128[0].x) * _1310)));
    _1334 = mad((WorkingColorSpace_128[1].z), _1312, mad((WorkingColorSpace_128[1].y), _1311, ((WorkingColorSpace_128[1].x) * _1310)));
    _1337 = mad((WorkingColorSpace_128[2].z), _1312, mad((WorkingColorSpace_128[2].y), _1311, ((WorkingColorSpace_128[2].x) * _1310)));
    _1348 = mad(_43, _1337, mad(_42, _1334, (_1331 * _41)));
    _1349 = mad(_46, _1337, mad(_45, _1334, (_1331 * _44)));
    _1350 = mad(_49, _1337, mad(_48, _1334, (_1331 * _47)));
  } else {
    _1348 = _1310;
    _1349 = _1311;
    _1350 = _1312;
  }
  if (_1348 < 0.0031306699384003878f) {
    _1361 = (_1348 * 12.920000076293945f);
  } else {
    _1361 = (((pow(_1348, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1349 < 0.0031306699384003878f) {
    _1372 = (_1349 * 12.920000076293945f);
  } else {
    _1372 = (((pow(_1349, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1350 < 0.0031306699384003878f) {
    _1383 = (_1350 * 12.920000076293945f);
  } else {
    _1383 = (((pow(_1350, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1361 * 0.9523810148239136f);
  SV_Target.y = (_1372 * 0.9523810148239136f);
  SV_Target.z = (_1383 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}