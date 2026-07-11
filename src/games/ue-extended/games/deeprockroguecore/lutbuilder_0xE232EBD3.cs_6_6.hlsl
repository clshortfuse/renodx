// Deep Rock Galactic: Rogue Core

#include "../../lutbuilder/lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
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

SamplerState s2 : register(s2);

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
  float _26;
  float _31;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _133;
  float _340;
  float _341;
  float _342;
  float _844;
  float _877;
  float _891;
  float _955;
  float _1146;
  float _1157;
  float _1168;
  float _1363;
  float _1364;
  float _1365;
  float _1376;
  float _1387;
  float _1398;
  bool _44;
  float _76;
  float _77;
  float _78;
  bool _114;
  float _116;
  float _147;
  float _154;
  float _157;
  float _162;
  float _163;
  float _165;
  bool _166;
  float _175;
  float _177;
  float _184;
  float _186;
  float _188;
  float _189;
  float _192;
  float _195;
  float _200;
  float _206;
  float _207;
  float _208;
  float _209;
  float _210;
  float _211;
  float _212;
  float _213;
  float _216;
  float _217;
  float _218;
  float _221;
  float _240;
  float _241;
  float _242;
  float _243;
  float _244;
  float _245;
  float _246;
  float _247;
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
  float _284;
  float _287;
  float _290;
  float _293;
  float _296;
  float _299;
  float _302;
  float _357;
  float _360;
  float _363;
  float _364;
  float _368;
  float _369;
  float _370;
  float _382;
  float _398;
  float _399;
  float _400;
  float _401;
  float _415;
  float _429;
  float _443;
  float _457;
  float _471;
  float _475;
  float _476;
  float _477;
  float _534;
  float _538;
  float _539;
  float _548;
  float _557;
  float _566;
  float _575;
  float _584;
  float _647;
  float _651;
  float _660;
  float _669;
  float _678;
  float _687;
  float _696;
  float _754;
  float _765;
  float _767;
  float _769;
  float _784;
  float _785;
  float _786;
  float _789;
  float _792;
  float _795;
  float _799;
  float _804;
  float _817;
  float _818;
  float _819;
  float _820;
  float _824;
  float _835;
  float _845;
  float _846;
  float _847;
  float _848;
  float _855;
  float _858;
  float _860;
  bool _863;
  bool _864;
  bool _865;
  bool _866;
  float _882;
  float _895;
  float _899;
  float _905;
  float _915;
  float _916;
  float _917;
  float _918;
  float _933;
  float _935;
  float _937;
  float _946;
  float _958;
  float _960;
  float _964;
  float _965;
  float _966;
  float _970;
  float _971;
  float _972;
  float _973;
  float _975;
  float _976;
  float _977;
  float _978;
  float _997;
  float _999;
  float _1024;
  float _1025;
  float _1026;
  float _1033;
  float _1037;
  float _1038;
  float _1039;
  bool _1040;
  float _1044;
  float _1045;
  float _1046;
  float _1065;
  float _1066;
  float _1067;
  float _1068;
  float _1088;
  float _1089;
  float _1090;
  float _1106;
  float _1107;
  float _1108;
  float _1133;
  float _1134;
  float _1135;
  float _1172;
  float _1179;
  float _1180;
  float _1181;
  float _1183;
  float4 _1186;
  float _1190;
  float4 _1191;
  float4 _1213;
  float4 _1217;
  float4 _1239;
  float4 _1243;
  float _1259;
  float _1260;
  float _1261;
  float _1286;
  float _1287;
  float _1288;
  float _1314;
  float _1315;
  float _1316;
  float _1337;
  float _1338;
  float _1339;
  float _1346;
  float _1349;
  float _1352;
  _26 = 0.5f / cb0_037x;
  _31 = cb0_037x + -1.0f;
  if (!(cb0_043x == 1)) {
    if (!(cb0_043x == 2)) {
      if (!(cb0_043x == 3)) {
        _44 = (cb0_043x == 4);
        _55 = select(_44, 1.0f, 1.705051064491272f);
        _56 = select(_44, 0.0f, -0.6217921376228333f);
        _57 = select(_44, 0.0f, -0.0832589864730835f);
        _58 = select(_44, 0.0f, -0.13025647401809692f);
        _59 = select(_44, 1.0f, 1.140804648399353f);
        _60 = select(_44, 0.0f, -0.010548308491706848f);
        _61 = select(_44, 0.0f, -0.024003351107239723f);
        _62 = select(_44, 0.0f, -0.1289689838886261f);
        _63 = select(_44, 1.0f, 1.1529725790023804f);
      } else {
        _55 = 0.6954522132873535f;
        _56 = 0.14067870378494263f;
        _57 = 0.16386906802654266f;
        _58 = 0.044794563204050064f;
        _59 = 0.8596711158752441f;
        _60 = 0.0955343171954155f;
        _61 = -0.005525882821530104f;
        _62 = 0.004025210160762072f;
        _63 = 1.0015007257461548f;
      }
    } else {
      _55 = 1.0258246660232544f;
      _56 = -0.020053181797266006f;
      _57 = -0.005771636962890625f;
      _58 = -0.002234415616840124f;
      _59 = 1.0045864582061768f;
      _60 = -0.002352118492126465f;
      _61 = -0.005013350863009691f;
      _62 = -0.025290070101618767f;
      _63 = 1.0303035974502563f;
    }
  } else {
    _55 = 1.3792141675949097f;
    _56 = -0.30886411666870117f;
    _57 = -0.0703500509262085f;
    _58 = -0.06933490186929703f;
    _59 = 1.08229660987854f;
    _60 = -0.012961871922016144f;
    _61 = -0.0021590073592960835f;
    _62 = -0.0454593189060688f;
    _63 = 1.0476183891296387f;
  }
  _76 = (exp2((((cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _26)) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _77 = (exp2((((cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _26)) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  _78 = (exp2(((float((uint)SV_DispatchThreadID.z) / _31) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  [branch]
  if ((abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f) | (abs(cb0_037z) > 9.99999993922529e-09f)) {
    _114 = (cb0_040w != 0);
    _116 = 0.9994439482688904f / cb0_037y;
    if ((cb0_037y * 1.0005563497543335f) > 7000.0f) {
      _133 = (((((1901800.0f - (_116 * 2006400000.0f)) * _116) + 247.47999572753906f) * _116) + 0.23703999817371368f);
    } else {
      _133 = (((((2967800.0f - (_116 * 4607000064.0f)) * _116) + 99.11000061035156f) * _116) + 0.24406300485134125f);
    }
    _147 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
    _154 = cb0_037y * cb0_037y;
    _157 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_154 * 1.6145605741257896e-07f));
    _162 = ((_147 * 2.0f) + 4.0f) - (_157 * 8.0f);
    _163 = (_147 * 3.0f) / _162;
    _165 = (_157 * 2.0f) / _162;
    _166 = (cb0_037y < 4000.0f);
    _175 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
    _177 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_154 * 1.5317699909210205f)) / (_175 * _175);
    _184 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _154;
    _186 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_154 * 308.60699462890625f)) / (_184 * _184);
    _188 = rsqrt(dot(float2(_177, _186), float2(_177, _186)));
    _189 = cb0_037z * 0.05000000074505806f;
    _192 = ((_189 * _186) * _188) + _147;
    _195 = _157 - ((_189 * _177) * _188);
    _200 = (4.0f - (_195 * 8.0f)) + (_192 * 2.0f);
    _206 = (((_192 * 3.0f) / _200) - _163) + select(_166, _163, _133);
    _207 = (((_195 * 2.0f) / _200) - _165) + select(_166, _165, (((_133 * 2.869999885559082f) + -0.2750000059604645f) - ((_133 * _133) * 3.0f)));
    _208 = select(_114, _206, 0.3127000033855438f);
    _209 = select(_114, _207, 0.32899999618530273f);
    _210 = select(_114, 0.3127000033855438f, _206);
    _211 = select(_114, 0.32899999618530273f, _207);
    _212 = max(_209, 1.000000013351432e-10f);
    _213 = _208 / _212;
    _216 = ((1.0f - _208) - _209) / _212;
    _217 = max(_211, 1.000000013351432e-10f);
    _218 = _210 / _217;
    _221 = ((1.0f - _210) - _211) / _217;
    _240 = mad(-0.16140000522136688f, _221, ((_218 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _216, ((_213 * 0.8950999975204468f) + 0.266400009393692f));
    _241 = mad(0.03669999912381172f, _221, (1.7135000228881836f - (_218 * 0.7501999735832214f))) / mad(0.03669999912381172f, _216, (1.7135000228881836f - (_213 * 0.7501999735832214f)));
    _242 = mad(1.0296000242233276f, _221, ((_218 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _216, ((_213 * 0.03889999911189079f) + -0.06849999725818634f));
    _243 = mad(_241, -0.7501999735832214f, 0.0f);
    _244 = mad(_241, 1.7135000228881836f, 0.0f);
    _245 = mad(_241, 0.03669999912381172f, -0.0f);
    _246 = mad(_242, 0.03889999911189079f, 0.0f);
    _247 = mad(_242, -0.06849999725818634f, 0.0f);
    _248 = mad(_242, 1.0296000242233276f, 0.0f);
    _251 = mad(0.1599626988172531f, _246, mad(-0.1470542997121811f, _243, (_240 * 0.883457362651825f)));
    _254 = mad(0.1599626988172531f, _247, mad(-0.1470542997121811f, _244, (_240 * 0.26293492317199707f)));
    _257 = mad(0.1599626988172531f, _248, mad(-0.1470542997121811f, _245, (_240 * -0.15930065512657166f)));
    _260 = mad(0.04929120093584061f, _246, mad(0.5183603167533875f, _243, (_240 * 0.38695648312568665f)));
    _263 = mad(0.04929120093584061f, _247, mad(0.5183603167533875f, _244, (_240 * 0.11516613513231277f)));
    _266 = mad(0.04929120093584061f, _248, mad(0.5183603167533875f, _245, (_240 * -0.0697740763425827f)));
    _269 = mad(0.9684867262840271f, _246, mad(0.04004279896616936f, _243, (_240 * -0.007634039502590895f)));
    _272 = mad(0.9684867262840271f, _247, mad(0.04004279896616936f, _244, (_240 * -0.0022720457054674625f)));
    _275 = mad(0.9684867262840271f, _248, mad(0.04004279896616936f, _245, (_240 * 0.0013765322510153055f)));
    _278 = mad(_257, (WorkingColorSpace_000[2].x), mad(_254, (WorkingColorSpace_000[1].x), (_251 * (WorkingColorSpace_000[0].x))));
    _281 = mad(_257, (WorkingColorSpace_000[2].y), mad(_254, (WorkingColorSpace_000[1].y), (_251 * (WorkingColorSpace_000[0].y))));
    _284 = mad(_257, (WorkingColorSpace_000[2].z), mad(_254, (WorkingColorSpace_000[1].z), (_251 * (WorkingColorSpace_000[0].z))));
    _287 = mad(_266, (WorkingColorSpace_000[2].x), mad(_263, (WorkingColorSpace_000[1].x), (_260 * (WorkingColorSpace_000[0].x))));
    _290 = mad(_266, (WorkingColorSpace_000[2].y), mad(_263, (WorkingColorSpace_000[1].y), (_260 * (WorkingColorSpace_000[0].y))));
    _293 = mad(_266, (WorkingColorSpace_000[2].z), mad(_263, (WorkingColorSpace_000[1].z), (_260 * (WorkingColorSpace_000[0].z))));
    _296 = mad(_275, (WorkingColorSpace_000[2].x), mad(_272, (WorkingColorSpace_000[1].x), (_269 * (WorkingColorSpace_000[0].x))));
    _299 = mad(_275, (WorkingColorSpace_000[2].y), mad(_272, (WorkingColorSpace_000[1].y), (_269 * (WorkingColorSpace_000[0].y))));
    _302 = mad(_275, (WorkingColorSpace_000[2].z), mad(_272, (WorkingColorSpace_000[1].z), (_269 * (WorkingColorSpace_000[0].z))));
    _340 = mad(mad((WorkingColorSpace_064[0].z), _302, mad((WorkingColorSpace_064[0].y), _293, (_284 * (WorkingColorSpace_064[0].x)))), _78, mad(mad((WorkingColorSpace_064[0].z), _299, mad((WorkingColorSpace_064[0].y), _290, (_281 * (WorkingColorSpace_064[0].x)))), _77, (mad((WorkingColorSpace_064[0].z), _296, mad((WorkingColorSpace_064[0].y), _287, (_278 * (WorkingColorSpace_064[0].x)))) * _76)));
    _341 = mad(mad((WorkingColorSpace_064[1].z), _302, mad((WorkingColorSpace_064[1].y), _293, (_284 * (WorkingColorSpace_064[1].x)))), _78, mad(mad((WorkingColorSpace_064[1].z), _299, mad((WorkingColorSpace_064[1].y), _290, (_281 * (WorkingColorSpace_064[1].x)))), _77, (mad((WorkingColorSpace_064[1].z), _296, mad((WorkingColorSpace_064[1].y), _287, (_278 * (WorkingColorSpace_064[1].x)))) * _76)));
    _342 = mad(mad((WorkingColorSpace_064[2].z), _302, mad((WorkingColorSpace_064[2].y), _293, (_284 * (WorkingColorSpace_064[2].x)))), _78, mad(mad((WorkingColorSpace_064[2].z), _299, mad((WorkingColorSpace_064[2].y), _290, (_281 * (WorkingColorSpace_064[2].x)))), _77, (mad((WorkingColorSpace_064[2].z), _296, mad((WorkingColorSpace_064[2].y), _287, (_278 * (WorkingColorSpace_064[2].x)))) * _76)));
  } else {
    _340 = _76;
    _341 = _77;
    _342 = _78;
  }
  _357 = mad((WorkingColorSpace_128[0].z), _342, mad((WorkingColorSpace_128[0].y), _341, ((WorkingColorSpace_128[0].x) * _340)));
  _360 = mad((WorkingColorSpace_128[1].z), _342, mad((WorkingColorSpace_128[1].y), _341, ((WorkingColorSpace_128[1].x) * _340)));
  _363 = mad((WorkingColorSpace_128[2].z), _342, mad((WorkingColorSpace_128[2].y), _341, ((WorkingColorSpace_128[2].x) * _340)));
  _364 = dot(float3(_357, _360, _363), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _368 = (_357 / _364) + -1.0f;
  _369 = (_360 / _364) + -1.0f;
  _370 = (_363 / _364) + -1.0f;
  _382 = (1.0f - exp2(((_364 * _364) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_368, _369, _370), float3(_368, _369, _370)) * -4.0f));
  _398 = ((mad(-0.06368321925401688f, _363, mad(-0.3292922377586365f, _360, (_357 * 1.3704125881195068f))) - _357) * _382) + _357;
  _399 = ((mad(-0.010861365124583244f, _363, mad(1.0970927476882935f, _360, (_357 * -0.08343357592821121f))) - _360) * _382) + _360;
  _400 = ((mad(1.2036951780319214f, _363, mad(-0.09862580895423889f, _360, (_357 * -0.02579331398010254f))) - _363) * _382) + _363;
  _401 = dot(float3(_398, _399, _400), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _415 = cb0_021w + cb0_026w;
  _429 = cb0_020w * cb0_025w;
  _443 = cb0_019w * cb0_024w;
  _457 = cb0_018w * cb0_023w;
  _471 = cb0_017w * cb0_022w;
  _475 = _398 - _401;
  _476 = _399 - _401;
  _477 = _400 - _401;
  _534 = saturate(_401 / cb0_037w);
  _538 = (_534 * _534) * (3.0f - (_534 * 2.0f));
  _539 = 1.0f - _538;
  _548 = cb0_021w + cb0_036w;
  _557 = cb0_020w * cb0_035w;
  _566 = cb0_019w * cb0_034w;
  _575 = cb0_018w * cb0_033w;
  _584 = cb0_017w * cb0_032w;
  _647 = saturate((_401 - cb0_038x) / (cb0_038y - cb0_038x));
  _651 = (_647 * _647) * (3.0f - (_647 * 2.0f));
  _660 = cb0_021w + cb0_031w;
  _669 = cb0_020w * cb0_030w;
  _678 = cb0_019w * cb0_029w;
  _687 = cb0_018w * cb0_028w;
  _696 = cb0_017w * cb0_027w;
  _754 = _538 - _651;
  _765 = ((_651 * (((cb0_021x + cb0_036x) + _548) + (((cb0_020x * cb0_035x) * _557) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _575) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _584) * _475) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _566)))))) + (_539 * (((cb0_021x + cb0_026x) + _415) + (((cb0_020x * cb0_025x) * _429) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _457) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _471) * _475) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _443))))))) + ((((cb0_021x + cb0_031x) + _660) + (((cb0_020x * cb0_030x) * _669) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _687) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _696) * _475) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _678))))) * _754);
  _767 = ((_651 * (((cb0_021y + cb0_036y) + _548) + (((cb0_020y * cb0_035y) * _557) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _575) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _584) * _476) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _566)))))) + (_539 * (((cb0_021y + cb0_026y) + _415) + (((cb0_020y * cb0_025y) * _429) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _457) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _471) * _476) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _443))))))) + ((((cb0_021y + cb0_031y) + _660) + (((cb0_020y * cb0_030y) * _669) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _687) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _696) * _476) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _678))))) * _754);
  _769 = ((_651 * (((cb0_021z + cb0_036z) + _548) + (((cb0_020z * cb0_035z) * _557) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _575) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _584) * _477) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _566)))))) + (_539 * (((cb0_021z + cb0_026z) + _415) + (((cb0_020z * cb0_025z) * _429) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _457) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _471) * _477) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _443))))))) + ((((cb0_021z + cb0_031z) + _660) + (((cb0_020z * cb0_030z) * _669) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _687) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _696) * _477) + _401)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _678))))) * _754);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;
  float4 output = ProcessLutbuilder(float3(_765, _767, _769), s0, s1, s2, t0, t1, t2, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], 0u);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  _784 = ((mad(0.061360642313957214f, _769, mad(-4.540197551250458e-09f, _767, (_765 * 0.9386394023895264f))) - _765) * cb0_038z) + _765;
  _785 = ((mad(0.169205904006958f, _769, mad(0.8307942152023315f, _767, (_765 * 6.775371730327606e-08f))) - _767) * cb0_038z) + _767;
  _786 = (mad(-2.3283064365386963e-10f, _767, (_765 * -9.313225746154785e-10f)) * cb0_038z) + _769;
  _789 = mad(0.16386905312538147f, _786, mad(0.14067868888378143f, _785, (_784 * 0.6954522132873535f)));
  _792 = mad(0.0955343246459961f, _786, mad(0.8596711158752441f, _785, (_784 * 0.044794581830501556f)));
  _795 = mad(1.0015007257461548f, _786, mad(0.004025210160762072f, _785, (_784 * -0.005525882821530104f)));
  _799 = max(max(_789, _792), _795);
  _804 = (max(_799, 1.000000013351432e-10f) - max(min(min(_789, _792), _795), 1.000000013351432e-10f)) / max(_799, 0.009999999776482582f);
  _817 = ((_792 + _789) + _795) + (sqrt((((_795 - _792) * _795) + ((_792 - _789) * _792)) + ((_789 - _795) * _789)) * 1.75f);
  _818 = _817 * 0.3333333432674408f;
  _819 = _804 + -0.4000000059604645f;
  _820 = _819 * 5.0f;
  _824 = max((1.0f - abs(_819 * 2.5f)), 0.0f);
  _835 = ((float((int)(((int)(uint)((int)(_820 > 0.0f))) - ((int)(uint)((int)(_820 < 0.0f))))) * (1.0f - (_824 * _824))) + 1.0f) * 0.02500000037252903f;
  if (_818 > 0.0533333346247673f) {
    if (_818 < 0.1599999964237213f) {
      _844 = (((0.23999999463558197f / _817) + -0.5f) * _835);
    } else {
      _844 = 0.0f;
    }
  } else {
    _844 = _835;
  }
  _845 = _844 + 1.0f;
  _846 = _845 * _789;
  _847 = _845 * _792;
  _848 = _845 * _795;
  if (!((_846 == _847) && (_847 == _848))) {
    _855 = ((_846 * 2.0f) - _847) - _848;
    _858 = ((_792 - _795) * 1.7320507764816284f) * _845;
    _860 = atan(_858 / _855);
    _863 = (_855 < 0.0f);
    _864 = (_855 == 0.0f);
    _865 = (_858 >= 0.0f);
    _866 = (_858 < 0.0f);
    _877 = select((_865 && _864), 90.0f, select((_866 && _864), -90.0f, (select((_866 && _863), (_860 + -3.1415927410125732f), select((_865 && _863), (_860 + 3.1415927410125732f), _860)) * 57.2957763671875f)));
  } else {
    _877 = 0.0f;
  }
  _882 = min(max(select((_877 < 0.0f), (_877 + 360.0f), _877), 0.0f), 360.0f);
  if (_882 < -180.0f) {
    _891 = (_882 + 360.0f);
  } else {
    if (_882 > 180.0f) {
      _891 = (_882 + -360.0f);
    } else {
      _891 = _882;
    }
  }
  _895 = saturate(1.0f - abs(_891 * 0.014814814552664757f));
  _899 = (_895 * _895) * (3.0f - (_895 * 2.0f));
  _905 = ((_899 * _899) * ((_804 * 0.18000000715255737f) * (0.029999999329447746f - _846))) + _846;
  _915 = max(0.0f, mad(-0.21492856740951538f, _848, mad(-0.2365107536315918f, _847, (_905 * 1.4514392614364624f))));
  _916 = max(0.0f, mad(-0.09967592358589172f, _848, mad(1.17622971534729f, _847, (_905 * -0.07655377686023712f))));
  _917 = max(0.0f, mad(0.9977163076400757f, _848, mad(-0.006032449658960104f, _847, (_905 * 0.008316148072481155f))));
  _918 = dot(float3(_915, _916, _917), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _933 = (cb0_040x + 1.0f) - cb0_039z;
  _935 = cb0_040y + 1.0f;
  _937 = _935 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _955 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    _946 = (cb0_040x + 0.18000000715255737f) / _933;
    _955 = (-0.7447274923324585f - ((log2(_946 / (2.0f - _946)) * 0.3465735912322998f) * (_933 / cb0_039y)));
  }
  _958 = ((1.0f - cb0_039z) / cb0_039y) - _955;
  _960 = (cb0_039w / cb0_039y) - _958;
  _964 = log2(lerp(_918, _915, 0.9599999785423279f)) * 0.3010300099849701f;
  _965 = log2(lerp(_918, _916, 0.9599999785423279f)) * 0.3010300099849701f;
  _966 = log2(lerp(_918, _917, 0.9599999785423279f)) * 0.3010300099849701f;
  _970 = cb0_039y * (_964 + _958);
  _971 = cb0_039y * (_965 + _958);
  _972 = cb0_039y * (_966 + _958);
  _973 = _933 * 2.0f;
  _975 = (cb0_039y * -2.0f) / _933;
  _976 = _964 - _955;
  _977 = _965 - _955;
  _978 = _966 - _955;
  _997 = _937 * 2.0f;
  _999 = (cb0_039y * 2.0f) / _937;
  _1024 = select((_964 < _955), ((_973 / (exp2((_976 * 1.4426950216293335f) * _975) + 1.0f)) - cb0_040x), _970);
  _1025 = select((_965 < _955), ((_973 / (exp2((_977 * 1.4426950216293335f) * _975) + 1.0f)) - cb0_040x), _971);
  _1026 = select((_966 < _955), ((_973 / (exp2((_978 * 1.4426950216293335f) * _975) + 1.0f)) - cb0_040x), _972);
  _1033 = _960 - _955;
  _1037 = saturate(_976 / _1033);
  _1038 = saturate(_977 / _1033);
  _1039 = saturate(_978 / _1033);
  _1040 = (_960 < _955);
  _1044 = select(_1040, (1.0f - _1037), _1037);
  _1045 = select(_1040, (1.0f - _1038), _1038);
  _1046 = select(_1040, (1.0f - _1039), _1039);
  _1065 = (((_1044 * _1044) * (select((_964 > _960), (_935 - (_997 / (exp2(((_964 - _960) * 1.4426950216293335f) * _999) + 1.0f))), _970) - _1024)) * (3.0f - (_1044 * 2.0f))) + _1024;
  _1066 = (((_1045 * _1045) * (select((_965 > _960), (_935 - (_997 / (exp2(((_965 - _960) * 1.4426950216293335f) * _999) + 1.0f))), _971) - _1025)) * (3.0f - (_1045 * 2.0f))) + _1025;
  _1067 = (((_1046 * _1046) * (select((_966 > _960), (_935 - (_997 / (exp2(((_966 - _960) * 1.4426950216293335f) * _999) + 1.0f))), _972) - _1026)) * (3.0f - (_1046 * 2.0f))) + _1026;
  _1068 = dot(float3(_1065, _1066, _1067), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  _1088 = (cb0_039x * (max(0.0f, (lerp(_1068, _1065, 0.9300000071525574f))) - _784)) + _784;
  _1089 = (cb0_039x * (max(0.0f, (lerp(_1068, _1066, 0.9300000071525574f))) - _785)) + _785;
  _1090 = (cb0_039x * (max(0.0f, (lerp(_1068, _1067, 0.9300000071525574f))) - _786)) + _786;
  _1106 = ((mad(-0.06537103652954102f, _1090, mad(1.451815478503704e-06f, _1089, (_1088 * 1.065374732017517f))) - _1088) * cb0_038z) + _1088;
  _1107 = ((mad(-0.20366770029067993f, _1090, mad(1.2036634683609009f, _1089, (_1088 * -2.57161445915699e-07f))) - _1089) * cb0_038z) + _1089;
  _1108 = ((mad(0.9999996423721313f, _1090, mad(2.0954757928848267e-08f, _1089, (_1088 * 1.862645149230957e-08f))) - _1090) * cb0_038z) + _1090;
  _1133 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1108, mad((WorkingColorSpace_192[0].y), _1107, ((WorkingColorSpace_192[0].x) * _1106)))));
  _1134 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1108, mad((WorkingColorSpace_192[1].y), _1107, ((WorkingColorSpace_192[1].x) * _1106)))));
  _1135 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1108, mad((WorkingColorSpace_192[2].y), _1107, ((WorkingColorSpace_192[2].x) * _1106)))));
  if (_1133 < 0.0031306699384003878f) {
    _1146 = (_1133 * 12.920000076293945f);
  } else {
    _1146 = (((pow(_1133, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1134 < 0.0031306699384003878f) {
    _1157 = (_1134 * 12.920000076293945f);
  } else {
    _1157 = (((pow(_1134, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1135 < 0.0031306699384003878f) {
    _1168 = (_1135 * 12.920000076293945f);
  } else {
    _1168 = (((pow(_1135, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  _1172 = (_1157 * 0.9375f) + 0.03125f;
  _1179 = _1168 * 15.0f;
  _1180 = floor(_1179);
  _1181 = _1179 - _1180;
  _1183 = (_1180 + ((_1146 * 0.9375f) + 0.03125f)) * 0.0625f;
  _1186 = t0.SampleLevel(s0, float2(_1183, _1172), 0.0f);
  _1190 = _1183 + 0.0625f;
  _1191 = t0.SampleLevel(s0, float2(_1190, _1172), 0.0f);
  _1213 = t1.SampleLevel(s1, float2(_1183, _1172), 0.0f);
  _1217 = t1.SampleLevel(s1, float2(_1190, _1172), 0.0f);
  _1239 = t2.SampleLevel(s2, float2(_1183, _1172), 0.0f);
  _1243 = t2.SampleLevel(s2, float2(_1190, _1172), 0.0f);
  _1259 = ((((lerp(_1186.x, _1191.x, _1181)) * cb0_005y) + (cb0_005x * _1146)) + ((lerp(_1213.x, _1217.x, _1181)) * cb0_005z)) + ((lerp(_1239.x, _1243.x, _1181)) * cb0_005w);
  _1260 = ((((lerp(_1186.y, _1191.y, _1181)) * cb0_005y) + (cb0_005x * _1157)) + ((lerp(_1213.y, _1217.y, _1181)) * cb0_005z)) + ((lerp(_1239.y, _1243.y, _1181)) * cb0_005w);
  _1261 = ((((lerp(_1186.z, _1191.z, _1181)) * cb0_005y) + (cb0_005x * _1168)) + ((lerp(_1213.z, _1217.z, _1181)) * cb0_005z)) + ((lerp(_1239.z, _1243.z, _1181)) * cb0_005w);
  _1286 = select((_1259 > 0.040449999272823334f), exp2(log2((abs(_1259) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1259 * 0.07739938050508499f));
  _1287 = select((_1260 > 0.040449999272823334f), exp2(log2((abs(_1260) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1260 * 0.07739938050508499f));
  _1288 = select((_1261 > 0.040449999272823334f), exp2(log2((abs(_1261) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1261 * 0.07739938050508499f));
  _1314 = cb0_016x * (((cb0_041y + (cb0_041x * _1286)) * _1286) + cb0_041z);
  _1315 = cb0_016y * (((cb0_041y + (cb0_041x * _1287)) * _1287) + cb0_041z);
  _1316 = cb0_016z * (((cb0_041y + (cb0_041x * _1288)) * _1288) + cb0_041z);
  _1337 = exp2(log2(max(0.0f, (lerp(_1314, cb0_015x, cb0_015w)))) * cb0_042y);
  _1338 = exp2(log2(max(0.0f, (lerp(_1315, cb0_015y, cb0_015w)))) * cb0_042y);
  _1339 = exp2(log2(max(0.0f, (lerp(_1316, cb0_015z, cb0_015w)))) * cb0_042y);
  if (WorkingColorSpace_384 == 0) {
    _1346 = mad((WorkingColorSpace_128[0].z), _1339, mad((WorkingColorSpace_128[0].y), _1338, ((WorkingColorSpace_128[0].x) * _1337)));
    _1349 = mad((WorkingColorSpace_128[1].z), _1339, mad((WorkingColorSpace_128[1].y), _1338, ((WorkingColorSpace_128[1].x) * _1337)));
    _1352 = mad((WorkingColorSpace_128[2].z), _1339, mad((WorkingColorSpace_128[2].y), _1338, ((WorkingColorSpace_128[2].x) * _1337)));
    _1363 = mad(_57, _1352, mad(_56, _1349, (_1346 * _55)));
    _1364 = mad(_60, _1352, mad(_59, _1349, (_1346 * _58)));
    _1365 = mad(_63, _1352, mad(_62, _1349, (_1346 * _61)));
  } else {
    _1363 = _1337;
    _1364 = _1338;
    _1365 = _1339;
  }
  if (_1363 < 0.0031306699384003878f) {
    _1376 = (_1363 * 12.920000076293945f);
  } else {
    _1376 = (((pow(_1363, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1364 < 0.0031306699384003878f) {
    _1387 = (_1364 * 12.920000076293945f);
  } else {
    _1387 = (((pow(_1364, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1365 < 0.0031306699384003878f) {
    _1398 = (_1365 * 12.920000076293945f);
  } else {
    _1398 = (((pow(_1365, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  u0[int3((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y), (int)(SV_DispatchThreadID.z))] = float4((_1376 * 0.9523810148239136f), (_1387 * 0.9523810148239136f), (_1398 * 0.9523810148239136f), 0.0f);
}