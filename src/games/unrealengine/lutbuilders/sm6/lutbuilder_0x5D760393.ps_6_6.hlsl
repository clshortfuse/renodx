#include "../../common.hlsl"

cbuffer cb0 : register(b0) {
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
  uint cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  uint cb0_040w : packoffset(c040.w);
  uint cb0_041x : packoffset(c041.x);
};

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float UniformBufferConstants_WorkingColorSpace_000x : packoffset(c000.x);
  float UniformBufferConstants_WorkingColorSpace_000y : packoffset(c000.y);
  float UniformBufferConstants_WorkingColorSpace_000z : packoffset(c000.z);
  float UniformBufferConstants_WorkingColorSpace_001x : packoffset(c001.x);
  float UniformBufferConstants_WorkingColorSpace_001y : packoffset(c001.y);
  float UniformBufferConstants_WorkingColorSpace_001z : packoffset(c001.z);
  float UniformBufferConstants_WorkingColorSpace_002x : packoffset(c002.x);
  float UniformBufferConstants_WorkingColorSpace_002y : packoffset(c002.y);
  float UniformBufferConstants_WorkingColorSpace_002z : packoffset(c002.z);
  float UniformBufferConstants_WorkingColorSpace_004x : packoffset(c004.x);
  float UniformBufferConstants_WorkingColorSpace_004y : packoffset(c004.y);
  float UniformBufferConstants_WorkingColorSpace_004z : packoffset(c004.z);
  float UniformBufferConstants_WorkingColorSpace_005x : packoffset(c005.x);
  float UniformBufferConstants_WorkingColorSpace_005y : packoffset(c005.y);
  float UniformBufferConstants_WorkingColorSpace_005z : packoffset(c005.z);
  float UniformBufferConstants_WorkingColorSpace_006x : packoffset(c006.x);
  float UniformBufferConstants_WorkingColorSpace_006y : packoffset(c006.y);
  float UniformBufferConstants_WorkingColorSpace_006z : packoffset(c006.z);
  float UniformBufferConstants_WorkingColorSpace_008x : packoffset(c008.x);
  float UniformBufferConstants_WorkingColorSpace_008y : packoffset(c008.y);
  float UniformBufferConstants_WorkingColorSpace_008z : packoffset(c008.z);
  float UniformBufferConstants_WorkingColorSpace_009x : packoffset(c009.x);
  float UniformBufferConstants_WorkingColorSpace_009y : packoffset(c009.y);
  float UniformBufferConstants_WorkingColorSpace_009z : packoffset(c009.z);
  float UniformBufferConstants_WorkingColorSpace_010x : packoffset(c010.x);
  float UniformBufferConstants_WorkingColorSpace_010y : packoffset(c010.y);
  float UniformBufferConstants_WorkingColorSpace_010z : packoffset(c010.z);
  float UniformBufferConstants_WorkingColorSpace_012x : packoffset(c012.x);
  float UniformBufferConstants_WorkingColorSpace_012y : packoffset(c012.y);
  float UniformBufferConstants_WorkingColorSpace_012z : packoffset(c012.z);
  float UniformBufferConstants_WorkingColorSpace_013x : packoffset(c013.x);
  float UniformBufferConstants_WorkingColorSpace_013y : packoffset(c013.y);
  float UniformBufferConstants_WorkingColorSpace_013z : packoffset(c013.z);
  float UniformBufferConstants_WorkingColorSpace_014x : packoffset(c014.x);
  float UniformBufferConstants_WorkingColorSpace_014y : packoffset(c014.y);
  float UniformBufferConstants_WorkingColorSpace_014z : packoffset(c014.z);
  float UniformBufferConstants_WorkingColorSpace_016x : packoffset(c016.x);
  float UniformBufferConstants_WorkingColorSpace_016y : packoffset(c016.y);
  float UniformBufferConstants_WorkingColorSpace_016z : packoffset(c016.z);
  float UniformBufferConstants_WorkingColorSpace_017x : packoffset(c017.x);
  float UniformBufferConstants_WorkingColorSpace_017y : packoffset(c017.y);
  float UniformBufferConstants_WorkingColorSpace_017z : packoffset(c017.z);
  float UniformBufferConstants_WorkingColorSpace_018x : packoffset(c018.x);
  float UniformBufferConstants_WorkingColorSpace_018y : packoffset(c018.y);
  float UniformBufferConstants_WorkingColorSpace_018z : packoffset(c018.z);
  uint UniformBufferConstants_WorkingColorSpace_020x : packoffset(c020.x);
};

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  float4 SV_Target;
  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _14 = 0.5f / (cb0_035x);
  float _19 = (cb0_035x) + -1.0f;
  float _20 = ((cb0_035x) * ((TEXCOORD.x) - _14)) / _19;
  float _21 = ((cb0_035x) * ((TEXCOORD.y) - _14)) / _19;
  float _23 = (float((uint)(SV_RenderTargetArrayIndex))) / _19;
  float _43 = 1.379158854484558f;
  float _44 = -0.3088507056236267f;
  float _45 = -0.07034677267074585f;
  float _46 = -0.06933528929948807f;
  float _47 = 1.0822921991348267f;
  float _48 = -0.012962047010660172f;
  float _49 = -0.002159259282052517f;
  float _50 = -0.045465391129255295f;
  float _51 = 1.0477596521377563f;
  float _109;
  float _110;
  float _111;
  float _159;
  float _887;
  float _920;
  float _934;
  float _998;
  float _1266;
  float _1267;
  float _1268;
  float _1279;
  float _1290;
  float _1470;
  float _1503;
  float _1517;
  float _1556;
  float _1666;
  float _1740;
  float _1814;
  float _1893;
  float _1894;
  float _1895;
  float _2044;
  float _2077;
  float _2091;
  float _2130;
  float _2240;
  float _2314;
  float _2388;
  float _2467;
  float _2468;
  float _2469;
  float _2646;
  float _2647;
  float _2648;
  if (!((((uint)(cb0_041x)) == 1))) {
    _43 = 1.02579927444458f;
    _44 = -0.020052503794431686f;
    _45 = -0.0057713985443115234f;
    _46 = -0.0022350111976265907f;
    _47 = 1.0045825242996216f;
    _48 = -0.002352306619286537f;
    _49 = -0.005014004185795784f;
    _50 = -0.025293385609984398f;
    _51 = 1.0304402112960815f;
    if (!((((uint)(cb0_041x)) == 2))) {
      _43 = 0.6954522132873535f;
      _44 = 0.14067870378494263f;
      _45 = 0.16386906802654266f;
      _46 = 0.044794563204050064f;
      _47 = 0.8596711158752441f;
      _48 = 0.0955343171954155f;
      _49 = -0.005525882821530104f;
      _50 = 0.004025210160762072f;
      _51 = 1.0015007257461548f;
      if (!((((uint)(cb0_041x)) == 3))) {
        bool _32 = (((uint)(cb0_041x)) == 4);
        _43 = ((_32 ? 1.0f : 1.7050515413284302f));
        _44 = ((_32 ? 0.0f : -0.6217905879020691f));
        _45 = ((_32 ? 0.0f : -0.0832584798336029f));
        _46 = ((_32 ? 0.0f : -0.13025718927383423f));
        _47 = ((_32 ? 1.0f : 1.1408027410507202f));
        _48 = ((_32 ? 0.0f : -0.010548528283834457f));
        _49 = ((_32 ? 0.0f : -0.024003278464078903f));
        _50 = ((_32 ? 0.0f : -0.1289687603712082f));
        _51 = ((_32 ? 1.0f : 1.152971863746643f));
      }
    }
  }
  if (((((uint)(cb0_040w)) > 2))) {
    float _62 = exp2(((log2(_20)) * 0.012683313339948654f));
    float _63 = exp2(((log2(_21)) * 0.012683313339948654f));
    float _64 = exp2(((log2(_23)) * 0.012683313339948654f));
    _109 = ((exp2(((log2(((max(0.0f, (_62 + -0.8359375f))) / (18.8515625f - (_62 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
    _110 = ((exp2(((log2(((max(0.0f, (_63 + -0.8359375f))) / (18.8515625f - (_63 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
    _111 = ((exp2(((log2(((max(0.0f, (_64 + -0.8359375f))) / (18.8515625f - (_64 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
  } else {
    _109 = (((exp2(((_20 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
    _110 = (((exp2(((_21 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
    _111 = (((exp2(((_23 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _138 = (((uint)(cb0_038w)) != 0);
  float _142 = 0.9994439482688904f / (cb0_035y);
  if (!(!(((cb0_035y) * 1.0005563497543335f) <= 7000.0f))) {
    _159 = (((((2967800.0f - (_142 * 4607000064.0f)) * _142) + 99.11000061035156f) * _142) + 0.24406300485134125f);
  } else {
    _159 = (((((1901800.0f - (_142 * 2006400000.0f)) * _142) + 247.47999572753906f) * _142) + 0.23703999817371368f);
  }
  float _173 = (((((cb0_035y) * 1.2864121856637212e-07f) + 0.00015411825734190643f) * (cb0_035y)) + 0.8601177334785461f) / (((((cb0_035y) * 7.081451371959702e-07f) + 0.0008424202096648514f) * (cb0_035y)) + 1.0f);
  float _180 = (cb0_035y) * (cb0_035y);
  float _183 = (((((cb0_035y) * 4.204816761443908e-08f) + 4.228062607580796e-05f) * (cb0_035y)) + 0.31739872694015503f) / ((1.0f - ((cb0_035y) * 2.8974181986995973e-05f)) + (_180 * 1.6145605741257896e-07f));
  float _188 = ((_173 * 2.0f) + 4.0f) - (_183 * 8.0f);
  float _189 = (_173 * 3.0f) / _188;
  float _191 = (_183 * 2.0f) / _188;
  bool _192 = ((cb0_035y) < 4000.0f);
  float _201 = (((cb0_035y) + 1189.6199951171875f) * (cb0_035y)) + 1412139.875f;
  float _203 = ((-1137581184.0f - ((cb0_035y) * 1916156.25f)) - (_180 * 1.5317699909210205f)) / (_201 * _201);
  float _210 = (6193636.0f - ((cb0_035y) * 179.45599365234375f)) + _180;
  float _212 = ((1974715392.0f - ((cb0_035y) * 705674.0f)) - (_180 * 308.60699462890625f)) / (_210 * _210);
  float _214 = rsqrt((dot(float2(_203, _212), float2(_203, _212))));
  float _215 = (cb0_035z) * 0.05000000074505806f;
  float _218 = ((_215 * _212) * _214) + _173;
  float _221 = _183 - ((_215 * _203) * _214);
  float _226 = (4.0f - (_221 * 8.0f)) + (_218 * 2.0f);
  float _232 = (((_218 * 3.0f) / _226) - _189) + ((_192 ? _189 : _159));
  float _233 = (((_221 * 2.0f) / _226) - _191) + ((_192 ? _191 : (((_159 * 2.869999885559082f) + -0.2750000059604645f) - ((_159 * _159) * 3.0f))));
  float _234 = (_138 ? _232 : 0.3127000033855438f);
  float _235 = (_138 ? _233 : 0.32899999618530273f);
  float _236 = (_138 ? 0.3127000033855438f : _232);
  float _237 = (_138 ? 0.32899999618530273f : _233);
  float _238 = max(_235, 1.000000013351432e-10f);
  float _239 = _234 / _238;
  float _242 = ((1.0f - _234) - _235) / _238;
  float _243 = max(_237, 1.000000013351432e-10f);
  float _244 = _236 / _243;
  float _247 = ((1.0f - _236) - _237) / _243;
  float _266 = (mad(-0.16140000522136688f, _247, ((_244 * 0.8950999975204468f) + 0.266400009393692f))) / (mad(-0.16140000522136688f, _242, ((_239 * 0.8950999975204468f) + 0.266400009393692f)));
  float _267 = (mad(0.03669999912381172f, _247, (1.7135000228881836f - (_244 * 0.7501999735832214f)))) / (mad(0.03669999912381172f, _242, (1.7135000228881836f - (_239 * 0.7501999735832214f))));
  float _268 = (mad(1.0296000242233276f, _247, ((_244 * 0.03889999911189079f) + -0.06849999725818634f))) / (mad(1.0296000242233276f, _242, ((_239 * 0.03889999911189079f) + -0.06849999725818634f)));
  float _269 = mad(_267, -0.7501999735832214f, 0.0f);
  float _270 = mad(_267, 1.7135000228881836f, 0.0f);
  float _271 = mad(_267, 0.03669999912381172f, -0.0f);
  float _272 = mad(_268, 0.03889999911189079f, 0.0f);
  float _273 = mad(_268, -0.06849999725818634f, 0.0f);
  float _274 = mad(_268, 1.0296000242233276f, 0.0f);
  float _277 = mad(0.1599626988172531f, _272, (mad(-0.1470542997121811f, _269, (_266 * 0.883457362651825f))));
  float _280 = mad(0.1599626988172531f, _273, (mad(-0.1470542997121811f, _270, (_266 * 0.26293492317199707f))));
  float _283 = mad(0.1599626988172531f, _274, (mad(-0.1470542997121811f, _271, (_266 * -0.15930065512657166f))));
  float _286 = mad(0.04929120093584061f, _272, (mad(0.5183603167533875f, _269, (_266 * 0.38695648312568665f))));
  float _289 = mad(0.04929120093584061f, _273, (mad(0.5183603167533875f, _270, (_266 * 0.11516613513231277f))));
  float _292 = mad(0.04929120093584061f, _274, (mad(0.5183603167533875f, _271, (_266 * -0.0697740763425827f))));
  float _295 = mad(0.9684867262840271f, _272, (mad(0.04004279896616936f, _269, (_266 * -0.007634039502590895f))));
  float _298 = mad(0.9684867262840271f, _273, (mad(0.04004279896616936f, _270, (_266 * -0.0022720457054674625f))));
  float _301 = mad(0.9684867262840271f, _274, (mad(0.04004279896616936f, _271, (_266 * 0.0013765322510153055f))));
  float _304 = mad(_283, (UniformBufferConstants_WorkingColorSpace_002x), (mad(_280, (UniformBufferConstants_WorkingColorSpace_001x), (_277 * (UniformBufferConstants_WorkingColorSpace_000x)))));
  float _307 = mad(_283, (UniformBufferConstants_WorkingColorSpace_002y), (mad(_280, (UniformBufferConstants_WorkingColorSpace_001y), (_277 * (UniformBufferConstants_WorkingColorSpace_000y)))));
  float _310 = mad(_283, (UniformBufferConstants_WorkingColorSpace_002z), (mad(_280, (UniformBufferConstants_WorkingColorSpace_001z), (_277 * (UniformBufferConstants_WorkingColorSpace_000z)))));
  float _313 = mad(_292, (UniformBufferConstants_WorkingColorSpace_002x), (mad(_289, (UniformBufferConstants_WorkingColorSpace_001x), (_286 * (UniformBufferConstants_WorkingColorSpace_000x)))));
  float _316 = mad(_292, (UniformBufferConstants_WorkingColorSpace_002y), (mad(_289, (UniformBufferConstants_WorkingColorSpace_001y), (_286 * (UniformBufferConstants_WorkingColorSpace_000y)))));
  float _319 = mad(_292, (UniformBufferConstants_WorkingColorSpace_002z), (mad(_289, (UniformBufferConstants_WorkingColorSpace_001z), (_286 * (UniformBufferConstants_WorkingColorSpace_000z)))));
  float _322 = mad(_301, (UniformBufferConstants_WorkingColorSpace_002x), (mad(_298, (UniformBufferConstants_WorkingColorSpace_001x), (_295 * (UniformBufferConstants_WorkingColorSpace_000x)))));
  float _325 = mad(_301, (UniformBufferConstants_WorkingColorSpace_002y), (mad(_298, (UniformBufferConstants_WorkingColorSpace_001y), (_295 * (UniformBufferConstants_WorkingColorSpace_000y)))));
  float _328 = mad(_301, (UniformBufferConstants_WorkingColorSpace_002z), (mad(_298, (UniformBufferConstants_WorkingColorSpace_001z), (_295 * (UniformBufferConstants_WorkingColorSpace_000z)))));
  float _358 = mad((mad((UniformBufferConstants_WorkingColorSpace_004z), _328, (mad((UniformBufferConstants_WorkingColorSpace_004y), _319, (_310 * (UniformBufferConstants_WorkingColorSpace_004x)))))), _111, (mad((mad((UniformBufferConstants_WorkingColorSpace_004z), _325, (mad((UniformBufferConstants_WorkingColorSpace_004y), _316, (_307 * (UniformBufferConstants_WorkingColorSpace_004x)))))), _110, ((mad((UniformBufferConstants_WorkingColorSpace_004z), _322, (mad((UniformBufferConstants_WorkingColorSpace_004y), _313, (_304 * (UniformBufferConstants_WorkingColorSpace_004x)))))) * _109))));
  float _361 = mad((mad((UniformBufferConstants_WorkingColorSpace_005z), _328, (mad((UniformBufferConstants_WorkingColorSpace_005y), _319, (_310 * (UniformBufferConstants_WorkingColorSpace_005x)))))), _111, (mad((mad((UniformBufferConstants_WorkingColorSpace_005z), _325, (mad((UniformBufferConstants_WorkingColorSpace_005y), _316, (_307 * (UniformBufferConstants_WorkingColorSpace_005x)))))), _110, ((mad((UniformBufferConstants_WorkingColorSpace_005z), _322, (mad((UniformBufferConstants_WorkingColorSpace_005y), _313, (_304 * (UniformBufferConstants_WorkingColorSpace_005x)))))) * _109))));
  float _364 = mad((mad((UniformBufferConstants_WorkingColorSpace_006z), _328, (mad((UniformBufferConstants_WorkingColorSpace_006y), _319, (_310 * (UniformBufferConstants_WorkingColorSpace_006x)))))), _111, (mad((mad((UniformBufferConstants_WorkingColorSpace_006z), _325, (mad((UniformBufferConstants_WorkingColorSpace_006y), _316, (_307 * (UniformBufferConstants_WorkingColorSpace_006x)))))), _110, ((mad((UniformBufferConstants_WorkingColorSpace_006z), _322, (mad((UniformBufferConstants_WorkingColorSpace_006y), _313, (_304 * (UniformBufferConstants_WorkingColorSpace_006x)))))) * _109))));
  float _379 = mad((UniformBufferConstants_WorkingColorSpace_008z), _364, (mad((UniformBufferConstants_WorkingColorSpace_008y), _361, ((UniformBufferConstants_WorkingColorSpace_008x)*_358))));
  float _382 = mad((UniformBufferConstants_WorkingColorSpace_009z), _364, (mad((UniformBufferConstants_WorkingColorSpace_009y), _361, ((UniformBufferConstants_WorkingColorSpace_009x)*_358))));
  float _385 = mad((UniformBufferConstants_WorkingColorSpace_010z), _364, (mad((UniformBufferConstants_WorkingColorSpace_010y), _361, ((UniformBufferConstants_WorkingColorSpace_010x)*_358))));
  float _386 = dot(float3(_379, _382, _385), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_379, _382, _385));

  float _390 = (_379 / _386) + -1.0f;
  float _391 = (_382 / _386) + -1.0f;
  float _392 = (_385 / _386) + -1.0f;
  float _404 = (1.0f - (exp2((((_386 * _386) * -4.0f) * (cb0_036w))))) * (1.0f - (exp2(((dot(float3(_390, _391, _392), float3(_390, _391, _392))) * -4.0f))));
  float _420 = (((mad(-0.06368283927440643f, _385, (mad(-0.32929131388664246f, _382, (_379 * 1.370412826538086f))))) - _379) * _404) + _379;
  float _421 = (((mad(-0.010861567221581936f, _385, (mad(1.0970908403396606f, _382, (_379 * -0.08343426138162613f))))) - _382) * _404) + _382;
  float _422 = (((mad(1.203694462776184f, _385, (mad(-0.09862564504146576f, _382, (_379 * -0.02579325996339321f))))) - _385) * _404) + _385;
  float _423 = dot(float3(_420, _421, _422), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _437 = (cb0_019w) + (cb0_024w);
  float _451 = (cb0_018w) * (cb0_023w);
  float _465 = (cb0_017w) * (cb0_022w);
  float _479 = (cb0_016w) * (cb0_021w);
  float _493 = (cb0_015w) * (cb0_020w);
  float _497 = _420 - _423;
  float _498 = _421 - _423;
  float _499 = _422 - _423;
  float _556 = saturate((_423 / (cb0_035w)));
  float _560 = (_556 * _556) * (3.0f - (_556 * 2.0f));
  float _561 = 1.0f - _560;
  float _570 = (cb0_019w) + (cb0_034w);
  float _579 = (cb0_018w) * (cb0_033w);
  float _588 = (cb0_017w) * (cb0_032w);
  float _597 = (cb0_016w) * (cb0_031w);
  float _606 = (cb0_015w) * (cb0_030w);
  float _669 = saturate(((_423 - (cb0_036x)) / ((cb0_036y) - (cb0_036x))));
  float _673 = (_669 * _669) * (3.0f - (_669 * 2.0f));
  float _682 = (cb0_019w) + (cb0_029w);
  float _691 = (cb0_018w) * (cb0_028w);
  float _700 = (cb0_017w) * (cb0_027w);
  float _709 = (cb0_016w) * (cb0_026w);
  float _718 = (cb0_015w) * (cb0_025w);
  float _776 = _560 - _673;
  float _787 = ((_673 * ((((cb0_019x) + (cb0_034x)) + _570) + ((((cb0_018x) * (cb0_033x)) * _579) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_031x)) * _597) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_030x)) * _606) * _497) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_032x)) * _588)))))))) + (_561 * ((((cb0_019x) + (cb0_024x)) + _437) + ((((cb0_018x) * (cb0_023x)) * _451) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_021x)) * _479) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_020x)) * _493) * _497) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_022x)) * _465))))))))) + (((((cb0_019x) + (cb0_029x)) + _682) + ((((cb0_018x) * (cb0_028x)) * _691) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_026x)) * _709) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_025x)) * _718) * _497) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_027x)) * _700))))))) * _776);
  float _789 = ((_673 * ((((cb0_019y) + (cb0_034y)) + _570) + ((((cb0_018y) * (cb0_033y)) * _579) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_031y)) * _597) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_030y)) * _606) * _498) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_032y)) * _588)))))))) + (_561 * ((((cb0_019y) + (cb0_024y)) + _437) + ((((cb0_018y) * (cb0_023y)) * _451) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_021y)) * _479) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_020y)) * _493) * _498) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_022y)) * _465))))))))) + (((((cb0_019y) + (cb0_029y)) + _682) + ((((cb0_018y) * (cb0_028y)) * _691) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_026y)) * _709) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_025y)) * _718) * _498) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_027y)) * _700))))))) * _776);
  float _791 = ((_673 * ((((cb0_019z) + (cb0_034z)) + _570) + ((((cb0_018z) * (cb0_033z)) * _579) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_031z)) * _597) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_030z)) * _606) * _499) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_032z)) * _588)))))))) + (_561 * ((((cb0_019z) + (cb0_024z)) + _437) + ((((cb0_018z) * (cb0_023z)) * _451) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_021z)) * _479) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_020z)) * _493) * _499) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_022z)) * _465))))))))) + (((((cb0_019z) + (cb0_029z)) + _682) + ((((cb0_018z) * (cb0_028z)) * _691) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_026z)) * _709) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_025z)) * _718) * _499) + _423))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_027z)) * _700))))))) * _776);

  SetUntonemappedAP1(float3(_787, _789, _791));

  float _827 = (((mad(0.061360642313957214f, _791, (mad(-4.540197551250458e-09f, _789, (_787 * 0.9386394023895264f))))) - _787) * (cb0_036z)) + _787;
  float _828 = (((mad(0.169205904006958f, _791, (mad(0.8307942152023315f, _789, (_787 * 6.775371730327606e-08f))))) - _789) * (cb0_036z)) + _789;
  float _829 = ((mad(-2.3283064365386963e-10f, _789, (_787 * -9.313225746154785e-10f))) * (cb0_036z)) + _791;
  float _832 = mad(0.16386905312538147f, _829, (mad(0.14067868888378143f, _828, (_827 * 0.6954522132873535f))));
  float _835 = mad(0.0955343246459961f, _829, (mad(0.8596711158752441f, _828, (_827 * 0.044794581830501556f))));
  float _838 = mad(1.0015007257461548f, _829, (mad(0.004025210160762072f, _828, (_827 * -0.005525882821530104f))));
  float _842 = max((max(_832, _835)), _838);
  float _847 = ((max(_842, 1.000000013351432e-10f)) - (max((min((min(_832, _835)), _838)), 1.000000013351432e-10f))) / (max(_842, 0.009999999776482582f));
  float _860 = ((_835 + _832) + _838) + ((sqrt(((((_838 - _835) * _838) + ((_835 - _832) * _835)) + ((_832 - _838) * _832)))) * 1.75f);
  float _861 = _860 * 0.3333333432674408f;
  float _862 = _847 + -0.4000000059604645f;
  float _863 = _862 * 5.0f;
  float _867 = max((1.0f - (abs((_862 * 2.5f)))), 0.0f);
  float _878 = (((float(((int(((bool)((_863 > 0.0f))))) - (int(((bool)((_863 < 0.0f)))))))) * (1.0f - (_867 * _867))) + 1.0f) * 0.02500000037252903f;
  _887 = _878;
  if ((!(_861 <= 0.0533333346247673f))) {
    _887 = 0.0f;
    if ((!(_861 >= 0.1599999964237213f))) {
      _887 = (((0.23999999463558197f / _860) + -0.5f) * _878);
    }
  }
  float _888 = _887 + 1.0f;
  float _889 = _888 * _832;
  float _890 = _888 * _835;
  float _891 = _888 * _838;
  _920 = 0.0f;
  if (!(((bool)((_889 == _890))) && ((bool)((_890 == _891))))) {
    float _898 = ((_889 * 2.0f) - _890) - _891;
    float _901 = ((_835 - _838) * 1.7320507764816284f) * _888;
    float _903 = atan((_901 / _898));
    bool _906 = (_898 < 0.0f);
    bool _907 = (_898 == 0.0f);
    bool _908 = (_901 >= 0.0f);
    bool _909 = (_901 < 0.0f);
    _920 = ((((bool)(_908 && _907)) ? 90.0f : ((((bool)(_909 && _907)) ? -90.0f : (((((bool)(_909 && _906)) ? (_903 + -3.1415927410125732f) : ((((bool)(_908 && _906)) ? (_903 + 3.1415927410125732f) : _903)))) * 57.2957763671875f)))));
  }
  float _925 = min((max(((((bool)((_920 < 0.0f))) ? (_920 + 360.0f) : _920)), 0.0f)), 360.0f);
  if (((_925 < -180.0f))) {
    _934 = (_925 + 360.0f);
  } else {
    _934 = _925;
    if (((_925 > 180.0f))) {
      _934 = (_925 + -360.0f);
    }
  }
  float _938 = saturate((1.0f - (abs((_934 * 0.014814814552664757f)))));
  float _942 = (_938 * _938) * (3.0f - (_938 * 2.0f));
  float _948 = ((_942 * _942) * ((_847 * 0.18000000715255737f) * (0.029999999329447746f - _889))) + _889;
  float _958 = max(0.0f, (mad(-0.21492856740951538f, _891, (mad(-0.2365107536315918f, _890, (_948 * 1.4514392614364624f))))));
  float _959 = max(0.0f, (mad(-0.09967592358589172f, _891, (mad(1.17622971534729f, _890, (_948 * -0.07655377686023712f))))));
  float _960 = max(0.0f, (mad(0.9977163076400757f, _891, (mad(-0.006032449658960104f, _890, (_948 * 0.008316148072481155f))))));
  float _961 = dot(float3(_958, _959, _960), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _976 = ((cb0_038x) + 1.0f) - (cb0_037z);
  float _978 = (cb0_038y) + 1.0f;
  float _980 = _978 - (cb0_037w);
  if ((((cb0_037z) > 0.800000011920929f))) {
    _998 = (((0.8199999928474426f - (cb0_037z)) / (cb0_037y)) + -0.7447274923324585f);
  } else {
    float _989 = ((cb0_038x) + 0.18000000715255737f) / _976;
    _998 = (-0.7447274923324585f - (((log2((_989 / (2.0f - _989)))) * 0.3465735912322998f) * (_976 / (cb0_037y))));
  }
  float _1001 = ((1.0f - (cb0_037z)) / (cb0_037y)) - _998;
  float _1003 = ((cb0_037w) / (cb0_037y)) - _1001;
  float _1007 = (log2((((_958 - _961) * 0.9599999785423279f) + _961))) * 0.3010300099849701f;
  float _1008 = (log2((((_959 - _961) * 0.9599999785423279f) + _961))) * 0.3010300099849701f;
  float _1009 = (log2((((_960 - _961) * 0.9599999785423279f) + _961))) * 0.3010300099849701f;
  float _1013 = (cb0_037y) * (_1007 + _1001);
  float _1014 = (cb0_037y) * (_1008 + _1001);
  float _1015 = (cb0_037y) * (_1009 + _1001);
  float _1016 = _976 * 2.0f;
  float _1018 = ((cb0_037y) * -2.0f) / _976;
  float _1019 = _1007 - _998;
  float _1020 = _1008 - _998;
  float _1021 = _1009 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = ((cb0_037y) * 2.0f) / _980;
  float _1067 = (((bool)((_1007 < _998))) ? ((_1016 / ((exp2(((_1019 * 1.4426950216293335f) * _1018))) + 1.0f)) - (cb0_038x)) : _1013);
  float _1068 = (((bool)((_1008 < _998))) ? ((_1016 / ((exp2(((_1020 * 1.4426950216293335f) * _1018))) + 1.0f)) - (cb0_038x)) : _1014);
  float _1069 = (((bool)((_1009 < _998))) ? ((_1016 / ((exp2(((_1021 * 1.4426950216293335f) * _1018))) + 1.0f)) - (cb0_038x)) : _1015);
  float _1076 = _1003 - _998;
  float _1080 = saturate((_1019 / _1076));
  float _1081 = saturate((_1020 / _1076));
  float _1082 = saturate((_1021 / _1076));
  bool _1083 = (_1003 < _998);
  float _1087 = (_1083 ? (1.0f - _1080) : _1080);
  float _1088 = (_1083 ? (1.0f - _1081) : _1081);
  float _1089 = (_1083 ? (1.0f - _1082) : _1082);
  float _1108 = (((_1087 * _1087) * (((((bool)((_1007 > _1003))) ? (_978 - (_1040 / ((exp2((((_1007 - _1003) * 1.4426950216293335f) * _1042))) + 1.0f))) : _1013)) - _1067)) * (3.0f - (_1087 * 2.0f))) + _1067;
  float _1109 = (((_1088 * _1088) * (((((bool)((_1008 > _1003))) ? (_978 - (_1040 / ((exp2((((_1008 - _1003) * 1.4426950216293335f) * _1042))) + 1.0f))) : _1014)) - _1068)) * (3.0f - (_1088 * 2.0f))) + _1068;
  float _1110 = (((_1089 * _1089) * (((((bool)((_1009 > _1003))) ? (_978 - (_1040 / ((exp2((((_1009 - _1003) * 1.4426950216293335f) * _1042))) + 1.0f))) : _1015)) - _1069)) * (3.0f - (_1089 * 2.0f))) + _1069;
  float _1111 = dot(float3(_1108, _1109, _1110), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1131 = ((cb0_037x) * ((max(0.0f, (((_1108 - _1111) * 0.9300000071525574f) + _1111))) - _827)) + _827;
  float _1132 = ((cb0_037x) * ((max(0.0f, (((_1109 - _1111) * 0.9300000071525574f) + _1111))) - _828)) + _828;
  float _1133 = ((cb0_037x) * ((max(0.0f, (((_1110 - _1111) * 0.9300000071525574f) + _1111))) - _829)) + _829;
  float _1149 = (((mad(-0.06537103652954102f, _1133, (mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))))) - _1131) * (cb0_036z)) + _1131;
  float _1150 = (((mad(-0.20366770029067993f, _1133, (mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))))) - _1132) * (cb0_036z)) + _1132;
  float _1151 = (((mad(0.9999996423721313f, _1133, (mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))))) - _1133) * (cb0_036z)) + _1133;

  SetTonemappedAP1(_1149, _1150, _1151);

  float _1161 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_012z), _1151, (mad((UniformBufferConstants_WorkingColorSpace_012y), _1150, ((UniformBufferConstants_WorkingColorSpace_012x)*_1149))))));
  float _1162 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_013z), _1151, (mad((UniformBufferConstants_WorkingColorSpace_013y), _1150, ((UniformBufferConstants_WorkingColorSpace_013x)*_1149))))));
  float _1163 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_014z), _1151, (mad((UniformBufferConstants_WorkingColorSpace_014y), _1150, ((UniformBufferConstants_WorkingColorSpace_014x)*_1149))))));
  float _1189 = (cb0_014x) * ((((cb0_039y) + ((cb0_039x)*_1161)) * _1161) + (cb0_039z));
  float _1190 = (cb0_014y) * ((((cb0_039y) + ((cb0_039x)*_1162)) * _1162) + (cb0_039z));
  float _1191 = (cb0_014z) * ((((cb0_039y) + ((cb0_039x)*_1163)) * _1163) + (cb0_039z));
  float _1198 = (((cb0_013x)-_1189) * (cb0_013w)) + _1189;
  float _1199 = (((cb0_013y)-_1190) * (cb0_013w)) + _1190;
  float _1200 = (((cb0_013z)-_1191) * (cb0_013w)) + _1191;
  float _1201 = (cb0_014x) * (mad((UniformBufferConstants_WorkingColorSpace_012z), _791, (mad((UniformBufferConstants_WorkingColorSpace_012y), _789, (_787 * (UniformBufferConstants_WorkingColorSpace_012x))))));
  float _1202 = (cb0_014y) * (mad((UniformBufferConstants_WorkingColorSpace_013z), _791, (mad((UniformBufferConstants_WorkingColorSpace_013y), _789, ((UniformBufferConstants_WorkingColorSpace_013x)*_787)))));
  float _1203 = (cb0_014z) * (mad((UniformBufferConstants_WorkingColorSpace_014z), _791, (mad((UniformBufferConstants_WorkingColorSpace_014y), _789, ((UniformBufferConstants_WorkingColorSpace_014x)*_787)))));
  float _1210 = (((cb0_013x)-_1201) * (cb0_013w)) + _1201;
  float _1211 = (((cb0_013y)-_1202) * (cb0_013w)) + _1202;
  float _1212 = (((cb0_013z)-_1203) * (cb0_013w)) + _1203;
  float _1224 = exp2(((log2((max(0.0f, _1198)))) * (cb0_040y)));
  float _1225 = exp2(((log2((max(0.0f, _1199)))) * (cb0_040y)));
  float _1226 = exp2(((log2((max(0.0f, _1200)))) * (cb0_040y)));

  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1224, _1225, _1226));
  }

  if (((((uint)(cb0_040w)) == 0))) {
    _1266 = _1224;
    _1267 = _1225;
    _1268 = _1226;
    do {
      if (((((uint)(UniformBufferConstants_WorkingColorSpace_020x)) == 0))) {
        float _1249 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1225, ((UniformBufferConstants_WorkingColorSpace_008x)*_1224))));
        float _1252 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1225, ((UniformBufferConstants_WorkingColorSpace_009x)*_1224))));
        float _1255 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1225, ((UniformBufferConstants_WorkingColorSpace_010x)*_1224))));
        _1266 = (mad(_45, _1255, (mad(_44, _1252, (_1249 * _43)))));
        _1267 = (mad(_48, _1255, (mad(_47, _1252, (_1249 * _46)))));
        _1268 = (mad(_51, _1255, (mad(_50, _1252, (_1249 * _49)))));
      }
      do {
        if (((_1266 < 0.0031306699384003878f))) {
          _1279 = (_1266 * 12.920000076293945f);
        } else {
          _1279 = (((exp2(((log2(_1266)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (((_1267 < 0.0031306699384003878f))) {
            _1290 = (_1267 * 12.920000076293945f);
          } else {
            _1290 = (((exp2(((log2(_1267)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (((_1268 < 0.0031306699384003878f))) {
            _2646 = _1279;
            _2647 = _1290;
            _2648 = (_1268 * 12.920000076293945f);
          } else {
            _2646 = _1279;
            _2647 = _1290;
            _2648 = (((exp2(((log2(_1268)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (((((uint)(cb0_040w)) == 1))) {
      float _1317 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1225, ((UniformBufferConstants_WorkingColorSpace_008x)*_1224))));
      float _1320 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1225, ((UniformBufferConstants_WorkingColorSpace_009x)*_1224))));
      float _1323 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1225, ((UniformBufferConstants_WorkingColorSpace_010x)*_1224))));
      float _1333 = max(6.103519990574569e-05f, (mad(_45, _1323, (mad(_44, _1320, (_1317 * _43))))));
      float _1334 = max(6.103519990574569e-05f, (mad(_48, _1323, (mad(_47, _1320, (_1317 * _46))))));
      float _1335 = max(6.103519990574569e-05f, (mad(_51, _1323, (mad(_50, _1320, (_1317 * _49))))));
      _2646 = (min((_1333 * 4.5f), (((exp2(((log2((max(_1333, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2647 = (min((_1334 * 4.5f), (((exp2(((log2((max(_1334, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2648 = (min((_1335 * 4.5f), (((exp2(((log2((max(_1335, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
    } else {
      if ((((bool)((((uint)(cb0_040w)) == 3))) || ((bool)((((uint)(cb0_040w)) == 5))))) {
        _10[0] = (cb0_010x);
        _10[1] = (cb0_010y);
        _10[2] = (cb0_010z);
        _10[3] = (cb0_010w);
        _10[4] = (cb0_012x);
        _10[5] = (cb0_012x);
        _11[0] = (cb0_011x);
        _11[1] = (cb0_011y);
        _11[2] = (cb0_011z);
        _11[3] = (cb0_011w);
        _11[4] = (cb0_012y);
        _11[5] = (cb0_012y);
        float _1410 = (cb0_012z)*_1210;
        float _1411 = (cb0_012z)*_1211;
        float _1412 = (cb0_012z)*_1212;
        float _1415 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1412, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1411, ((UniformBufferConstants_WorkingColorSpace_016x)*_1410))));
        float _1418 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1412, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1411, ((UniformBufferConstants_WorkingColorSpace_017x)*_1410))));
        float _1421 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1412, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1411, ((UniformBufferConstants_WorkingColorSpace_018x)*_1410))));
        float _1425 = max((max(_1415, _1418)), _1421);
        float _1430 = ((max(_1425, 1.000000013351432e-10f)) - (max((min((min(_1415, _1418)), _1421)), 1.000000013351432e-10f))) / (max(_1425, 0.009999999776482582f));
        float _1443 = ((_1418 + _1415) + _1421) + ((sqrt(((((_1421 - _1418) * _1421) + ((_1418 - _1415) * _1418)) + ((_1415 - _1421) * _1415)))) * 1.75f);
        float _1444 = _1443 * 0.3333333432674408f;
        float _1445 = _1430 + -0.4000000059604645f;
        float _1446 = _1445 * 5.0f;
        float _1450 = max((1.0f - (abs((_1445 * 2.5f)))), 0.0f);
        float _1461 = (((float(((int(((bool)((_1446 > 0.0f))))) - (int(((bool)((_1446 < 0.0f)))))))) * (1.0f - (_1450 * _1450))) + 1.0f) * 0.02500000037252903f;
        _1470 = _1461;
        do {
          if ((!(_1444 <= 0.0533333346247673f))) {
            _1470 = 0.0f;
            if ((!(_1444 >= 0.1599999964237213f))) {
              _1470 = (((0.23999999463558197f / _1443) + -0.5f) * _1461);
            }
          }
          float _1471 = _1470 + 1.0f;
          float _1472 = _1471 * _1415;
          float _1473 = _1471 * _1418;
          float _1474 = _1471 * _1421;
          _1503 = 0.0f;
          do {
            if (!(((bool)((_1472 == _1473))) && ((bool)((_1473 == _1474))))) {
              float _1481 = ((_1472 * 2.0f) - _1473) - _1474;
              float _1484 = ((_1418 - _1421) * 1.7320507764816284f) * _1471;
              float _1486 = atan((_1484 / _1481));
              bool _1489 = (_1481 < 0.0f);
              bool _1490 = (_1481 == 0.0f);
              bool _1491 = (_1484 >= 0.0f);
              bool _1492 = (_1484 < 0.0f);
              _1503 = ((((bool)(_1491 && _1490)) ? 90.0f : ((((bool)(_1492 && _1490)) ? -90.0f : (((((bool)(_1492 && _1489)) ? (_1486 + -3.1415927410125732f) : ((((bool)(_1491 && _1489)) ? (_1486 + 3.1415927410125732f) : _1486)))) * 57.2957763671875f)))));
            }
            float _1508 = min((max(((((bool)((_1503 < 0.0f))) ? (_1503 + 360.0f) : _1503)), 0.0f)), 360.0f);
            do {
              if (((_1508 < -180.0f))) {
                _1517 = (_1508 + 360.0f);
              } else {
                _1517 = _1508;
                if (((_1508 > 180.0f))) {
                  _1517 = (_1508 + -360.0f);
                }
              }
              _1556 = 0.0f;
              do {
                if ((((bool)((_1517 > -67.5f))) && ((bool)((_1517 < 67.5f))))) {
                  float _1523 = (_1517 + 67.5f) * 0.029629629105329514f;
                  int _1524 = int(1524);
                  float _1526 = _1523 - (float(_1524));
                  float _1527 = _1526 * _1526;
                  float _1528 = _1527 * _1526;
                  if (((_1524 == 3))) {
                    _1556 = (((0.1666666716337204f - (_1526 * 0.5f)) + (_1527 * 0.5f)) - (_1528 * 0.1666666716337204f));
                  } else {
                    if (((_1524 == 2))) {
                      _1556 = ((0.6666666865348816f - _1527) + (_1528 * 0.5f));
                    } else {
                      if (((_1524 == 1))) {
                        _1556 = (((_1528 * -0.5f) + 0.1666666716337204f) + ((_1527 + _1526) * 0.5f));
                      } else {
                        _1556 = ((((bool)((_1524 == 0))) ? (_1528 * 0.1666666716337204f) : 0.0f));
                      }
                    }
                  }
                }
                float _1565 = min((max(((((_1430 * 0.27000001072883606f) * (0.029999999329447746f - _1472)) * _1556) + _1472), 0.0f)), 65535.0f);
                float _1566 = min((max(_1473, 0.0f)), 65535.0f);
                float _1567 = min((max(_1474, 0.0f)), 65535.0f);
                float _1580 = min((max((mad(-0.21492856740951538f, _1567, (mad(-0.2365107536315918f, _1566, (_1565 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                float _1581 = min((max((mad(-0.09967592358589172f, _1567, (mad(1.17622971534729f, _1566, (_1565 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                float _1582 = min((max((mad(0.9977163076400757f, _1567, (mad(-0.006032449658960104f, _1566, (_1565 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                float _1583 = dot(float3(_1580, _1581, _1582), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1594 = log2((max((((_1580 - _1583) * 0.9599999785423279f) + _1583), 1.000000013351432e-10f)));
                float _1595 = _1594 * 0.3010300099849701f;
                float _1596 = log2((cb0_008x));
                float _1597 = _1596 * 0.3010300099849701f;
                do {
                  if (!(!(_1595 <= _1597))) {
                    _1666 = ((log2((cb0_008y))) * 0.3010300099849701f);
                  } else {
                    float _1604 = log2((cb0_009x));
                    float _1605 = _1604 * 0.3010300099849701f;
                    if ((((bool)((_1595 > _1597))) && ((bool)((_1595 < _1605))))) {
                      float _1613 = ((_1594 - _1596) * 0.9030900001525879f) / ((_1604 - _1596) * 0.3010300099849701f);
                      int _1614 = int(1614);
                      float _1616 = _1613 - (float(_1614));
                      float _1618 = _10[_1614];
                      float _1621 = _10[(_1614 + 1)];
                      float _1626 = _1618 * 0.5f;
                      _1666 = (dot(float3((_1616 * _1616), _1616, 1.0f), float3((mad((_10[(_1614 + 2)]), 0.5f, (mad(_1621, -1.0f, _1626)))), (_1621 - _1618), (mad(_1621, 0.5f, _1626)))));
                    } else {
                      do {
                        if (!(!(_1595 >= _1605))) {
                          float _1635 = log2((cb0_008z));
                          if (((_1595 < (_1635 * 0.3010300099849701f)))) {
                            float _1643 = ((_1594 - _1604) * 0.9030900001525879f) / ((_1635 - _1604) * 0.3010300099849701f);
                            int _1644 = int(1644);
                            float _1646 = _1643 - (float(_1644));
                            float _1648 = _11[_1644];
                            float _1651 = _11[(_1644 + 1)];
                            float _1656 = _1648 * 0.5f;
                            _1666 = (dot(float3((_1646 * _1646), _1646, 1.0f), float3((mad((_11[(_1644 + 2)]), 0.5f, (mad(_1651, -1.0f, _1656)))), (_1651 - _1648), (mad(_1651, 0.5f, _1656)))));
                            break;
                          }
                        }
                        _1666 = ((log2((cb0_008w))) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1670 = log2((max((((_1581 - _1583) * 0.9599999785423279f) + _1583), 1.000000013351432e-10f)));
                  float _1671 = _1670 * 0.3010300099849701f;
                  do {
                    if (!(!(_1671 <= _1597))) {
                      _1740 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _1678 = log2((cb0_009x));
                      float _1679 = _1678 * 0.3010300099849701f;
                      if ((((bool)((_1671 > _1597))) && ((bool)((_1671 < _1679))))) {
                        float _1687 = ((_1670 - _1596) * 0.9030900001525879f) / ((_1678 - _1596) * 0.3010300099849701f);
                        int _1688 = int(1688);
                        float _1690 = _1687 - (float(_1688));
                        float _1692 = _10[_1688];
                        float _1695 = _10[(_1688 + 1)];
                        float _1700 = _1692 * 0.5f;
                        _1740 = (dot(float3((_1690 * _1690), _1690, 1.0f), float3((mad((_10[(_1688 + 2)]), 0.5f, (mad(_1695, -1.0f, _1700)))), (_1695 - _1692), (mad(_1695, 0.5f, _1700)))));
                      } else {
                        do {
                          if (!(!(_1671 >= _1679))) {
                            float _1709 = log2((cb0_008z));
                            if (((_1671 < (_1709 * 0.3010300099849701f)))) {
                              float _1717 = ((_1670 - _1678) * 0.9030900001525879f) / ((_1709 - _1678) * 0.3010300099849701f);
                              int _1718 = int(1718);
                              float _1720 = _1717 - (float(_1718));
                              float _1722 = _11[_1718];
                              float _1725 = _11[(_1718 + 1)];
                              float _1730 = _1722 * 0.5f;
                              _1740 = (dot(float3((_1720 * _1720), _1720, 1.0f), float3((mad((_11[(_1718 + 2)]), 0.5f, (mad(_1725, -1.0f, _1730)))), (_1725 - _1722), (mad(_1725, 0.5f, _1730)))));
                              break;
                            }
                          }
                          _1740 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1744 = log2((max((((_1582 - _1583) * 0.9599999785423279f) + _1583), 1.000000013351432e-10f)));
                    float _1745 = _1744 * 0.3010300099849701f;
                    do {
                      if (!(!(_1745 <= _1597))) {
                        _1814 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _1752 = log2((cb0_009x));
                        float _1753 = _1752 * 0.3010300099849701f;
                        if ((((bool)((_1745 > _1597))) && ((bool)((_1745 < _1753))))) {
                          float _1761 = ((_1744 - _1596) * 0.9030900001525879f) / ((_1752 - _1596) * 0.3010300099849701f);
                          int _1762 = int(1762);
                          float _1764 = _1761 - (float(_1762));
                          float _1766 = _10[_1762];
                          float _1769 = _10[(_1762 + 1)];
                          float _1774 = _1766 * 0.5f;
                          _1814 = (dot(float3((_1764 * _1764), _1764, 1.0f), float3((mad((_10[(_1762 + 2)]), 0.5f, (mad(_1769, -1.0f, _1774)))), (_1769 - _1766), (mad(_1769, 0.5f, _1774)))));
                        } else {
                          do {
                            if (!(!(_1745 >= _1753))) {
                              float _1783 = log2((cb0_008z));
                              if (((_1745 < (_1783 * 0.3010300099849701f)))) {
                                float _1791 = ((_1744 - _1752) * 0.9030900001525879f) / ((_1783 - _1752) * 0.3010300099849701f);
                                int _1792 = int(1792);
                                float _1794 = _1791 - (float(_1792));
                                float _1796 = _11[_1792];
                                float _1799 = _11[(_1792 + 1)];
                                float _1804 = _1796 * 0.5f;
                                _1814 = (dot(float3((_1794 * _1794), _1794, 1.0f), float3((mad((_11[(_1792 + 2)]), 0.5f, (mad(_1799, -1.0f, _1804)))), (_1799 - _1796), (mad(_1799, 0.5f, _1804)))));
                                break;
                              }
                            }
                            _1814 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1818 = (cb0_008w) - (cb0_008y);
                      float _1819 = ((exp2((_1666 * 3.321928024291992f))) - (cb0_008y)) / _1818;
                      float _1821 = ((exp2((_1740 * 3.321928024291992f))) - (cb0_008y)) / _1818;
                      float _1823 = ((exp2((_1814 * 3.321928024291992f))) - (cb0_008y)) / _1818;
                      float _1826 = mad(0.15618768334388733f, _1823, (mad(0.13400420546531677f, _1821, (_1819 * 0.6624541878700256f))));
                      float _1829 = mad(0.053689517080783844f, _1823, (mad(0.6740817427635193f, _1821, (_1819 * 0.2722287178039551f))));
                      float _1832 = mad(1.0103391408920288f, _1823, (mad(0.00406073359772563f, _1821, (_1819 * -0.005574649665504694f))));
                      float _1845 = min((max((mad(-0.23642469942569733f, _1832, (mad(-0.32480329275131226f, _1829, (_1826 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                      float _1846 = min((max((mad(0.016756348311901093f, _1832, (mad(1.6153316497802734f, _1829, (_1826 * -0.663662850856781f))))), 0.0f)), 1.0f);
                      float _1847 = min((max((mad(0.9883948564529419f, _1832, (mad(-0.008284442126750946f, _1829, (_1826 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                      float _1850 = mad(0.15618768334388733f, _1847, (mad(0.13400420546531677f, _1846, (_1845 * 0.6624541878700256f))));
                      float _1853 = mad(0.053689517080783844f, _1847, (mad(0.6740817427635193f, _1846, (_1845 * 0.2722287178039551f))));
                      float _1856 = mad(1.0103391408920288f, _1847, (mad(0.00406073359772563f, _1846, (_1845 * -0.005574649665504694f))));
                      float _1878 = min((max(((min((max((mad(-0.23642469942569733f, _1856, (mad(-0.32480329275131226f, _1853, (_1850 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1879 = min((max(((min((max((mad(0.016756348311901093f, _1856, (mad(1.6153316497802734f, _1853, (_1850 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1880 = min((max(((min((max((mad(0.9883948564529419f, _1856, (mad(-0.008284442126750946f, _1853, (_1850 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      _1893 = _1878;
                      _1894 = _1879;
                      _1895 = _1880;
                      do {
                        if (!((((uint)(cb0_040w)) == 5))) {
                          _1893 = (mad(_45, _1880, (mad(_44, _1879, (_1878 * _43)))));
                          _1894 = (mad(_48, _1880, (mad(_47, _1879, (_1878 * _46)))));
                          _1895 = (mad(_51, _1880, (mad(_50, _1879, (_1878 * _49)))));
                        }
                        float _1905 = exp2(((log2((_1893 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1906 = exp2(((log2((_1894 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1907 = exp2(((log2((_1895 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        _2646 = (exp2(((log2(((1.0f / ((_1905 * 18.6875f) + 1.0f)) * ((_1905 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2647 = (exp2(((log2(((1.0f / ((_1906 * 18.6875f) + 1.0f)) * ((_1906 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2648 = (exp2(((log2(((1.0f / ((_1907 * 18.6875f) + 1.0f)) * ((_1907 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((((((uint)(cb0_040w)) & -3) == 4))) {
          _8[0] = (cb0_010x);
          _8[1] = (cb0_010y);
          _8[2] = (cb0_010z);
          _8[3] = (cb0_010w);
          _8[4] = (cb0_012x);
          _8[5] = (cb0_012x);
          _9[0] = (cb0_011x);
          _9[1] = (cb0_011y);
          _9[2] = (cb0_011z);
          _9[3] = (cb0_011w);
          _9[4] = (cb0_012y);
          _9[5] = (cb0_012y);
          float _1984 = (cb0_012z)*_1210;
          float _1985 = (cb0_012z)*_1211;
          float _1986 = (cb0_012z)*_1212;
          float _1989 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1986, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1985, ((UniformBufferConstants_WorkingColorSpace_016x)*_1984))));
          float _1992 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1986, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1985, ((UniformBufferConstants_WorkingColorSpace_017x)*_1984))));
          float _1995 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1986, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1985, ((UniformBufferConstants_WorkingColorSpace_018x)*_1984))));
          float _1999 = max((max(_1989, _1992)), _1995);
          float _2004 = ((max(_1999, 1.000000013351432e-10f)) - (max((min((min(_1989, _1992)), _1995)), 1.000000013351432e-10f))) / (max(_1999, 0.009999999776482582f));
          float _2017 = ((_1992 + _1989) + _1995) + ((sqrt(((((_1995 - _1992) * _1995) + ((_1992 - _1989) * _1992)) + ((_1989 - _1995) * _1989)))) * 1.75f);
          float _2018 = _2017 * 0.3333333432674408f;
          float _2019 = _2004 + -0.4000000059604645f;
          float _2020 = _2019 * 5.0f;
          float _2024 = max((1.0f - (abs((_2019 * 2.5f)))), 0.0f);
          float _2035 = (((float(((int(((bool)((_2020 > 0.0f))))) - (int(((bool)((_2020 < 0.0f)))))))) * (1.0f - (_2024 * _2024))) + 1.0f) * 0.02500000037252903f;
          _2044 = _2035;
          do {
            if ((!(_2018 <= 0.0533333346247673f))) {
              _2044 = 0.0f;
              if ((!(_2018 >= 0.1599999964237213f))) {
                _2044 = (((0.23999999463558197f / _2017) + -0.5f) * _2035);
              }
            }
            float _2045 = _2044 + 1.0f;
            float _2046 = _2045 * _1989;
            float _2047 = _2045 * _1992;
            float _2048 = _2045 * _1995;
            _2077 = 0.0f;
            do {
              if (!(((bool)((_2046 == _2047))) && ((bool)((_2047 == _2048))))) {
                float _2055 = ((_2046 * 2.0f) - _2047) - _2048;
                float _2058 = ((_1992 - _1995) * 1.7320507764816284f) * _2045;
                float _2060 = atan((_2058 / _2055));
                bool _2063 = (_2055 < 0.0f);
                bool _2064 = (_2055 == 0.0f);
                bool _2065 = (_2058 >= 0.0f);
                bool _2066 = (_2058 < 0.0f);
                _2077 = ((((bool)(_2065 && _2064)) ? 90.0f : ((((bool)(_2066 && _2064)) ? -90.0f : (((((bool)(_2066 && _2063)) ? (_2060 + -3.1415927410125732f) : ((((bool)(_2065 && _2063)) ? (_2060 + 3.1415927410125732f) : _2060)))) * 57.2957763671875f)))));
              }
              float _2082 = min((max(((((bool)((_2077 < 0.0f))) ? (_2077 + 360.0f) : _2077)), 0.0f)), 360.0f);
              do {
                if (((_2082 < -180.0f))) {
                  _2091 = (_2082 + 360.0f);
                } else {
                  _2091 = _2082;
                  if (((_2082 > 180.0f))) {
                    _2091 = (_2082 + -360.0f);
                  }
                }
                _2130 = 0.0f;
                do {
                  if ((((bool)((_2091 > -67.5f))) && ((bool)((_2091 < 67.5f))))) {
                    float _2097 = (_2091 + 67.5f) * 0.029629629105329514f;
                    int _2098 = int(2098);
                    float _2100 = _2097 - (float(_2098));
                    float _2101 = _2100 * _2100;
                    float _2102 = _2101 * _2100;
                    if (((_2098 == 3))) {
                      _2130 = (((0.1666666716337204f - (_2100 * 0.5f)) + (_2101 * 0.5f)) - (_2102 * 0.1666666716337204f));
                    } else {
                      if (((_2098 == 2))) {
                        _2130 = ((0.6666666865348816f - _2101) + (_2102 * 0.5f));
                      } else {
                        if (((_2098 == 1))) {
                          _2130 = (((_2102 * -0.5f) + 0.1666666716337204f) + ((_2101 + _2100) * 0.5f));
                        } else {
                          _2130 = ((((bool)((_2098 == 0))) ? (_2102 * 0.1666666716337204f) : 0.0f));
                        }
                      }
                    }
                  }
                  float _2139 = min((max(((((_2004 * 0.27000001072883606f) * (0.029999999329447746f - _2046)) * _2130) + _2046), 0.0f)), 65535.0f);
                  float _2140 = min((max(_2047, 0.0f)), 65535.0f);
                  float _2141 = min((max(_2048, 0.0f)), 65535.0f);
                  float _2154 = min((max((mad(-0.21492856740951538f, _2141, (mad(-0.2365107536315918f, _2140, (_2139 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                  float _2155 = min((max((mad(-0.09967592358589172f, _2141, (mad(1.17622971534729f, _2140, (_2139 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                  float _2156 = min((max((mad(0.9977163076400757f, _2141, (mad(-0.006032449658960104f, _2140, (_2139 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                  float _2157 = dot(float3(_2154, _2155, _2156), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2168 = log2((max((((_2154 - _2157) * 0.9599999785423279f) + _2157), 1.000000013351432e-10f)));
                  float _2169 = _2168 * 0.3010300099849701f;
                  float _2170 = log2((cb0_008x));
                  float _2171 = _2170 * 0.3010300099849701f;
                  do {
                    if (!(!(_2169 <= _2171))) {
                      _2240 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _2178 = log2((cb0_009x));
                      float _2179 = _2178 * 0.3010300099849701f;
                      if ((((bool)((_2169 > _2171))) && ((bool)((_2169 < _2179))))) {
                        float _2187 = ((_2168 - _2170) * 0.9030900001525879f) / ((_2178 - _2170) * 0.3010300099849701f);
                        int _2188 = int(2188);
                        float _2190 = _2187 - (float(_2188));
                        float _2192 = _8[_2188];
                        float _2195 = _8[(_2188 + 1)];
                        float _2200 = _2192 * 0.5f;
                        _2240 = (dot(float3((_2190 * _2190), _2190, 1.0f), float3((mad((_8[(_2188 + 2)]), 0.5f, (mad(_2195, -1.0f, _2200)))), (_2195 - _2192), (mad(_2195, 0.5f, _2200)))));
                      } else {
                        do {
                          if (!(!(_2169 >= _2179))) {
                            float _2209 = log2((cb0_008z));
                            if (((_2169 < (_2209 * 0.3010300099849701f)))) {
                              float _2217 = ((_2168 - _2178) * 0.9030900001525879f) / ((_2209 - _2178) * 0.3010300099849701f);
                              int _2218 = int(2218);
                              float _2220 = _2217 - (float(_2218));
                              float _2222 = _9[_2218];
                              float _2225 = _9[(_2218 + 1)];
                              float _2230 = _2222 * 0.5f;
                              _2240 = (dot(float3((_2220 * _2220), _2220, 1.0f), float3((mad((_9[(_2218 + 2)]), 0.5f, (mad(_2225, -1.0f, _2230)))), (_2225 - _2222), (mad(_2225, 0.5f, _2230)))));
                              break;
                            }
                          }
                          _2240 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2244 = log2((max((((_2155 - _2157) * 0.9599999785423279f) + _2157), 1.000000013351432e-10f)));
                    float _2245 = _2244 * 0.3010300099849701f;
                    do {
                      if (!(!(_2245 <= _2171))) {
                        _2314 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _2252 = log2((cb0_009x));
                        float _2253 = _2252 * 0.3010300099849701f;
                        if ((((bool)((_2245 > _2171))) && ((bool)((_2245 < _2253))))) {
                          float _2261 = ((_2244 - _2170) * 0.9030900001525879f) / ((_2252 - _2170) * 0.3010300099849701f);
                          int _2262 = int(2262);
                          float _2264 = _2261 - (float(_2262));
                          float _2266 = _8[_2262];
                          float _2269 = _8[(_2262 + 1)];
                          float _2274 = _2266 * 0.5f;
                          _2314 = (dot(float3((_2264 * _2264), _2264, 1.0f), float3((mad((_8[(_2262 + 2)]), 0.5f, (mad(_2269, -1.0f, _2274)))), (_2269 - _2266), (mad(_2269, 0.5f, _2274)))));
                        } else {
                          do {
                            if (!(!(_2245 >= _2253))) {
                              float _2283 = log2((cb0_008z));
                              if (((_2245 < (_2283 * 0.3010300099849701f)))) {
                                float _2291 = ((_2244 - _2252) * 0.9030900001525879f) / ((_2283 - _2252) * 0.3010300099849701f);
                                int _2292 = int(2292);
                                float _2294 = _2291 - (float(_2292));
                                float _2296 = _9[_2292];
                                float _2299 = _9[(_2292 + 1)];
                                float _2304 = _2296 * 0.5f;
                                _2314 = (dot(float3((_2294 * _2294), _2294, 1.0f), float3((mad((_9[(_2292 + 2)]), 0.5f, (mad(_2299, -1.0f, _2304)))), (_2299 - _2296), (mad(_2299, 0.5f, _2304)))));
                                break;
                              }
                            }
                            _2314 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2318 = log2((max((((_2156 - _2157) * 0.9599999785423279f) + _2157), 1.000000013351432e-10f)));
                      float _2319 = _2318 * 0.3010300099849701f;
                      do {
                        if (!(!(_2319 <= _2171))) {
                          _2388 = ((log2((cb0_008y))) * 0.3010300099849701f);
                        } else {
                          float _2326 = log2((cb0_009x));
                          float _2327 = _2326 * 0.3010300099849701f;
                          if ((((bool)((_2319 > _2171))) && ((bool)((_2319 < _2327))))) {
                            float _2335 = ((_2318 - _2170) * 0.9030900001525879f) / ((_2326 - _2170) * 0.3010300099849701f);
                            int _2336 = int(2336);
                            float _2338 = _2335 - (float(_2336));
                            float _2340 = _8[_2336];
                            float _2343 = _8[(_2336 + 1)];
                            float _2348 = _2340 * 0.5f;
                            _2388 = (dot(float3((_2338 * _2338), _2338, 1.0f), float3((mad((_8[(_2336 + 2)]), 0.5f, (mad(_2343, -1.0f, _2348)))), (_2343 - _2340), (mad(_2343, 0.5f, _2348)))));
                          } else {
                            do {
                              if (!(!(_2319 >= _2327))) {
                                float _2357 = log2((cb0_008z));
                                if (((_2319 < (_2357 * 0.3010300099849701f)))) {
                                  float _2365 = ((_2318 - _2326) * 0.9030900001525879f) / ((_2357 - _2326) * 0.3010300099849701f);
                                  int _2366 = int(2366);
                                  float _2368 = _2365 - (float(_2366));
                                  float _2370 = _9[_2366];
                                  float _2373 = _9[(_2366 + 1)];
                                  float _2378 = _2370 * 0.5f;
                                  _2388 = (dot(float3((_2368 * _2368), _2368, 1.0f), float3((mad((_9[(_2366 + 2)]), 0.5f, (mad(_2373, -1.0f, _2378)))), (_2373 - _2370), (mad(_2373, 0.5f, _2378)))));
                                  break;
                                }
                              }
                              _2388 = ((log2((cb0_008w))) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2392 = (cb0_008w) - (cb0_008y);
                        float _2393 = ((exp2((_2240 * 3.321928024291992f))) - (cb0_008y)) / _2392;
                        float _2395 = ((exp2((_2314 * 3.321928024291992f))) - (cb0_008y)) / _2392;
                        float _2397 = ((exp2((_2388 * 3.321928024291992f))) - (cb0_008y)) / _2392;
                        float _2400 = mad(0.15618768334388733f, _2397, (mad(0.13400420546531677f, _2395, (_2393 * 0.6624541878700256f))));
                        float _2403 = mad(0.053689517080783844f, _2397, (mad(0.6740817427635193f, _2395, (_2393 * 0.2722287178039551f))));
                        float _2406 = mad(1.0103391408920288f, _2397, (mad(0.00406073359772563f, _2395, (_2393 * -0.005574649665504694f))));
                        float _2419 = min((max((mad(-0.23642469942569733f, _2406, (mad(-0.32480329275131226f, _2403, (_2400 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                        float _2420 = min((max((mad(0.016756348311901093f, _2406, (mad(1.6153316497802734f, _2403, (_2400 * -0.663662850856781f))))), 0.0f)), 1.0f);
                        float _2421 = min((max((mad(0.9883948564529419f, _2406, (mad(-0.008284442126750946f, _2403, (_2400 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                        float _2424 = mad(0.15618768334388733f, _2421, (mad(0.13400420546531677f, _2420, (_2419 * 0.6624541878700256f))));
                        float _2427 = mad(0.053689517080783844f, _2421, (mad(0.6740817427635193f, _2420, (_2419 * 0.2722287178039551f))));
                        float _2430 = mad(1.0103391408920288f, _2421, (mad(0.00406073359772563f, _2420, (_2419 * -0.005574649665504694f))));
                        float _2452 = min((max(((min((max((mad(-0.23642469942569733f, _2430, (mad(-0.32480329275131226f, _2427, (_2424 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2453 = min((max(((min((max((mad(0.016756348311901093f, _2430, (mad(1.6153316497802734f, _2427, (_2424 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2454 = min((max(((min((max((mad(0.9883948564529419f, _2430, (mad(-0.008284442126750946f, _2427, (_2424 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        _2467 = _2452;
                        _2468 = _2453;
                        _2469 = _2454;
                        do {
                          if (!((((uint)(cb0_040w)) == 6))) {
                            _2467 = (mad(_45, _2454, (mad(_44, _2453, (_2452 * _43)))));
                            _2468 = (mad(_48, _2454, (mad(_47, _2453, (_2452 * _46)))));
                            _2469 = (mad(_51, _2454, (mad(_50, _2453, (_2452 * _49)))));
                          }
                          float _2479 = exp2(((log2((_2467 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2480 = exp2(((log2((_2468 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2481 = exp2(((log2((_2469 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          _2646 = (exp2(((log2(((1.0f / ((_2479 * 18.6875f) + 1.0f)) * ((_2479 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2647 = (exp2(((log2(((1.0f / ((_2480 * 18.6875f) + 1.0f)) * ((_2480 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2648 = (exp2(((log2(((1.0f / ((_2481 * 18.6875f) + 1.0f)) * ((_2481 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (((((uint)(cb0_040w)) == 7))) {
            float _2526 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1212, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1211, ((UniformBufferConstants_WorkingColorSpace_008x)*_1210))));
            float _2529 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1212, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1211, ((UniformBufferConstants_WorkingColorSpace_009x)*_1210))));
            float _2532 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1212, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1211, ((UniformBufferConstants_WorkingColorSpace_010x)*_1210))));
            float _2551 = exp2(((log2(((mad(_45, _2532, (mad(_44, _2529, (_2526 * _43))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2552 = exp2(((log2(((mad(_48, _2532, (mad(_47, _2529, (_2526 * _46))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2553 = exp2(((log2(((mad(_51, _2532, (mad(_50, _2529, (_2526 * _49))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            _2646 = (exp2(((log2(((1.0f / ((_2551 * 18.6875f) + 1.0f)) * ((_2551 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2647 = (exp2(((log2(((1.0f / ((_2552 * 18.6875f) + 1.0f)) * ((_2552 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2648 = (exp2(((log2(((1.0f / ((_2553 * 18.6875f) + 1.0f)) * ((_2553 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
          } else {
            _2646 = _1210;
            _2647 = _1211;
            _2648 = _1212;
            if (!((((uint)(cb0_040w)) == 8))) {
              if (((((uint)(cb0_040w)) == 9))) {
                float _2600 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1200, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1199, ((UniformBufferConstants_WorkingColorSpace_008x)*_1198))));
                float _2603 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1200, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1199, ((UniformBufferConstants_WorkingColorSpace_009x)*_1198))));
                float _2606 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1200, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1199, ((UniformBufferConstants_WorkingColorSpace_010x)*_1198))));
                _2646 = (mad(_45, _2606, (mad(_44, _2603, (_2600 * _43)))));
                _2647 = (mad(_48, _2606, (mad(_47, _2603, (_2600 * _46)))));
                _2648 = (mad(_51, _2606, (mad(_50, _2603, (_2600 * _49)))));
              } else {
                float _2619 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1225, ((UniformBufferConstants_WorkingColorSpace_008x)*_1224))));
                float _2622 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1225, ((UniformBufferConstants_WorkingColorSpace_009x)*_1224))));
                float _2625 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1225, ((UniformBufferConstants_WorkingColorSpace_010x)*_1224))));
                _2646 = (exp2(((log2((mad(_45, _2625, (mad(_44, _2622, (_2619 * _43))))))) * (cb0_040z))));
                _2647 = (exp2(((log2((mad(_48, _2625, (mad(_47, _2622, (_2619 * _46))))))) * (cb0_040z))));
                _2648 = (exp2(((log2((mad(_51, _2625, (mad(_50, _2622, (_2619 * _49))))))) * (cb0_040z))));
              }
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2646 * 0.9523810148239136f);
  SV_Target.y = (_2647 * 0.9523810148239136f);
  SV_Target.z = (_2648 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
