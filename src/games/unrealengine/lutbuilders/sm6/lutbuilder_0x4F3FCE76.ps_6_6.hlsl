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
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
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
  uint cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  uint cb0_042w : packoffset(c042.w);
  uint cb0_043x : packoffset(c043.x);
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
  float _14 = 0.5f / (cb0_037x);
  float _19 = (cb0_037x) + -1.0f;
  float _20 = ((cb0_037x) * ((TEXCOORD.x) - _14)) / _19;
  float _21 = ((cb0_037x) * ((TEXCOORD.y) - _14)) / _19;
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
  float _1291;
  float _1292;
  float _1293;
  float _1304;
  float _1315;
  float _1495;
  float _1528;
  float _1542;
  float _1581;
  float _1691;
  float _1765;
  float _1839;
  float _1918;
  float _1919;
  float _1920;
  float _2069;
  float _2102;
  float _2116;
  float _2155;
  float _2265;
  float _2339;
  float _2413;
  float _2492;
  float _2493;
  float _2494;
  float _2671;
  float _2672;
  float _2673;
  if (!((((uint)(cb0_043x)) == 1))) {
    _43 = 1.02579927444458f;
    _44 = -0.020052503794431686f;
    _45 = -0.0057713985443115234f;
    _46 = -0.0022350111976265907f;
    _47 = 1.0045825242996216f;
    _48 = -0.002352306619286537f;
    _49 = -0.005014004185795784f;
    _50 = -0.025293385609984398f;
    _51 = 1.0304402112960815f;
    if (!((((uint)(cb0_043x)) == 2))) {
      _43 = 0.6954522132873535f;
      _44 = 0.14067870378494263f;
      _45 = 0.16386906802654266f;
      _46 = 0.044794563204050064f;
      _47 = 0.8596711158752441f;
      _48 = 0.0955343171954155f;
      _49 = -0.005525882821530104f;
      _50 = 0.004025210160762072f;
      _51 = 1.0015007257461548f;
      if (!((((uint)(cb0_043x)) == 3))) {
        bool _32 = (((uint)(cb0_043x)) == 4);
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
  if (((((uint)(cb0_042w)) > 2))) {
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
  bool _138 = (((uint)(cb0_040w)) != 0);
  float _142 = 0.9994439482688904f / (cb0_037y);
  if (!(!(((cb0_037y) * 1.0005563497543335f) <= 7000.0f))) {
    _159 = (((((2967800.0f - (_142 * 4607000064.0f)) * _142) + 99.11000061035156f) * _142) + 0.24406300485134125f);
  } else {
    _159 = (((((1901800.0f - (_142 * 2006400000.0f)) * _142) + 247.47999572753906f) * _142) + 0.23703999817371368f);
  }
  float _173 = (((((cb0_037y) * 1.2864121856637212e-07f) + 0.00015411825734190643f) * (cb0_037y)) + 0.8601177334785461f) / (((((cb0_037y) * 7.081451371959702e-07f) + 0.0008424202096648514f) * (cb0_037y)) + 1.0f);
  float _180 = (cb0_037y) * (cb0_037y);
  float _183 = (((((cb0_037y) * 4.204816761443908e-08f) + 4.228062607580796e-05f) * (cb0_037y)) + 0.31739872694015503f) / ((1.0f - ((cb0_037y) * 2.8974181986995973e-05f)) + (_180 * 1.6145605741257896e-07f));
  float _188 = ((_173 * 2.0f) + 4.0f) - (_183 * 8.0f);
  float _189 = (_173 * 3.0f) / _188;
  float _191 = (_183 * 2.0f) / _188;
  bool _192 = ((cb0_037y) < 4000.0f);
  float _201 = (((cb0_037y) + 1189.6199951171875f) * (cb0_037y)) + 1412139.875f;
  float _203 = ((-1137581184.0f - ((cb0_037y) * 1916156.25f)) - (_180 * 1.5317699909210205f)) / (_201 * _201);
  float _210 = (6193636.0f - ((cb0_037y) * 179.45599365234375f)) + _180;
  float _212 = ((1974715392.0f - ((cb0_037y) * 705674.0f)) - (_180 * 308.60699462890625f)) / (_210 * _210);
  float _214 = rsqrt((dot(float2(_203, _212), float2(_203, _212))));
  float _215 = (cb0_037z) * 0.05000000074505806f;
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
  float _404 = (1.0f - (exp2((((_386 * _386) * -4.0f) * (cb0_038w))))) * (1.0f - (exp2(((dot(float3(_390, _391, _392), float3(_390, _391, _392))) * -4.0f))));
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
  float _556 = saturate((_423 / (cb0_037w)));
  float _560 = (_556 * _556) * (3.0f - (_556 * 2.0f));
  float _561 = 1.0f - _560;
  float _570 = (cb0_019w) + (cb0_034w);
  float _579 = (cb0_018w) * (cb0_033w);
  float _588 = (cb0_017w) * (cb0_032w);
  float _597 = (cb0_016w) * (cb0_031w);
  float _606 = (cb0_015w) * (cb0_030w);
  float _669 = saturate(((_423 - (cb0_038x)) / ((cb0_038y) - (cb0_038x))));
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

  SetUntonemappedAP1(float3(_787, _789, _791));  // CustomEdit

  float _827 = (((mad(0.061360642313957214f, _791, (mad(-4.540197551250458e-09f, _789, (_787 * 0.9386394023895264f))))) - _787) * (cb0_038z)) + _787;
  float _828 = (((mad(0.169205904006958f, _791, (mad(0.8307942152023315f, _789, (_787 * 6.775371730327606e-08f))))) - _789) * (cb0_038z)) + _789;
  float _829 = ((mad(-2.3283064365386963e-10f, _789, (_787 * -9.313225746154785e-10f))) * (cb0_038z)) + _791;

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

  float _976 = ((cb0_040x) + 1.0f) - (cb0_039z);
  float _978 = (cb0_040y) + 1.0f;
  float _980 = _978 - (cb0_039w);

  if ((((cb0_039z) > 0.800000011920929f))) {
    _998 = (((0.8199999928474426f - (cb0_039z)) / (cb0_039y)) + -0.7447274923324585f);
  } else {
    float _989 = ((cb0_040x) + 0.18000000715255737f) / _976;
    _998 = (-0.7447274923324585f - (((log2((_989 / (2.0f - _989)))) * 0.3465735912322998f) * (_976 / (cb0_039y))));
  }
  float _1001 = ((1.0f - (cb0_039z)) / (cb0_039y)) - _998;
  float _1003 = ((cb0_039w) / (cb0_039y)) - _1001;
  float _1007 = (log2((((_958 - _961) * 0.9599999785423279f) + _961))) * 0.3010300099849701f;
  float _1008 = (log2((((_959 - _961) * 0.9599999785423279f) + _961))) * 0.3010300099849701f;
  float _1009 = (log2((((_960 - _961) * 0.9599999785423279f) + _961))) * 0.3010300099849701f;
  float _1013 = (cb0_039y) * (_1007 + _1001);
  float _1014 = (cb0_039y) * (_1008 + _1001);
  float _1015 = (cb0_039y) * (_1009 + _1001);
  float _1016 = _976 * 2.0f;
  float _1018 = ((cb0_039y) * -2.0f) / _976;
  float _1019 = _1007 - _998;
  float _1020 = _1008 - _998;
  float _1021 = _1009 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = ((cb0_039y) * 2.0f) / _980;
  float _1067 = (((bool)((_1007 < _998))) ? ((_1016 / ((exp2(((_1019 * 1.4426950216293335f) * _1018))) + 1.0f)) - (cb0_040x)) : _1013);
  float _1068 = (((bool)((_1008 < _998))) ? ((_1016 / ((exp2(((_1020 * 1.4426950216293335f) * _1018))) + 1.0f)) - (cb0_040x)) : _1014);
  float _1069 = (((bool)((_1009 < _998))) ? ((_1016 / ((exp2(((_1021 * 1.4426950216293335f) * _1018))) + 1.0f)) - (cb0_040x)) : _1015);
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

  float _1131 = ((cb0_039x) * ((max(0.0f, (((_1108 - _1111) * 0.9300000071525574f) + _1111))) - _827)) + _827;
  float _1132 = ((cb0_039x) * ((max(0.0f, (((_1109 - _1111) * 0.9300000071525574f) + _1111))) - _828)) + _828;
  float _1133 = ((cb0_039x) * ((max(0.0f, (((_1110 - _1111) * 0.9300000071525574f) + _1111))) - _829)) + _829;

  float _1149 = (((mad(-0.06537103652954102f, _1133, (mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))))) - _1131) * (cb0_038z)) + _1131;
  float _1150 = (((mad(-0.20366770029067993f, _1133, (mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))))) - _1132) * (cb0_038z)) + _1132;
  float _1151 = (((mad(0.9999996423721313f, _1133, (mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))))) - _1133) * (cb0_038z)) + _1133;

  SetTonemappedAP1(_1149, _1150, _1151);

  float _1161 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_012z), _1151, (mad((UniformBufferConstants_WorkingColorSpace_012y), _1150, ((UniformBufferConstants_WorkingColorSpace_012x)*_1149))))));
  float _1162 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_013z), _1151, (mad((UniformBufferConstants_WorkingColorSpace_013y), _1150, ((UniformBufferConstants_WorkingColorSpace_013x)*_1149))))));
  float _1163 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_014z), _1151, (mad((UniformBufferConstants_WorkingColorSpace_014y), _1150, ((UniformBufferConstants_WorkingColorSpace_014x)*_1149))))));
  float _1189 = (cb0_014x) * ((((cb0_041y) + ((cb0_041x)*_1161)) * _1161) + (cb0_041z));
  float _1190 = (cb0_014y) * ((((cb0_041y) + ((cb0_041x)*_1162)) * _1162) + (cb0_041z));
  float _1191 = (cb0_014z) * ((((cb0_041y) + ((cb0_041x)*_1163)) * _1163) + (cb0_041z));
  float _1198 = (((cb0_013x)-_1189) * (cb0_013w)) + _1189;
  float _1199 = (((cb0_013y)-_1190) * (cb0_013w)) + _1190;
  float _1200 = (((cb0_013z)-_1191) * (cb0_013w)) + _1191;
  float _1201 = (cb0_014x) * (mad((UniformBufferConstants_WorkingColorSpace_012z), _791, (mad((UniformBufferConstants_WorkingColorSpace_012y), _789, (_787 * (UniformBufferConstants_WorkingColorSpace_012x))))));
  float _1202 = (cb0_014y) * (mad((UniformBufferConstants_WorkingColorSpace_013z), _791, (mad((UniformBufferConstants_WorkingColorSpace_013y), _789, ((UniformBufferConstants_WorkingColorSpace_013x)*_787)))));
  float _1203 = (cb0_014z) * (mad((UniformBufferConstants_WorkingColorSpace_014z), _791, (mad((UniformBufferConstants_WorkingColorSpace_014y), _789, ((UniformBufferConstants_WorkingColorSpace_014x)*_787)))));
  float _1210 = (((cb0_013x)-_1201) * (cb0_013w)) + _1201;
  float _1211 = (((cb0_013y)-_1202) * (cb0_013w)) + _1202;
  float _1212 = (((cb0_013z)-_1203) * (cb0_013w)) + _1203;
  float _1224 = exp2(((log2((max(0.0f, _1198)))) * (cb0_042y)));
  float _1225 = exp2(((log2((max(0.0f, _1199)))) * (cb0_042y)));
  float _1226 = exp2(((log2((max(0.0f, _1200)))) * (cb0_042y)));

  // CustomEdit
  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1224, _1225, _1226));
  }

  if (((((uint)(cb0_042w)) == 0))) {
    float _1232 = max((dot(float3(_1224, _1225, _1226), float3(0.2126390039920807f, 0.7151690125465393f, 0.0721919983625412f))), 9.999999747378752e-05f);
    float _1252 = ((((((bool)((_1232 < (cb0_036z)))) ? 0.0f : 1.0f)) * (((cb0_035y)-_1232) + ((-0.0f - (cb0_036x)) / ((cb0_035x) + _1232)))) + _1232) * (cb0_036y);
    float _1253 = _1252 * (_1224 / _1232);
    float _1254 = _1252 * (_1225 / _1232);
    float _1255 = _1252 * (_1226 / _1232);
    _1291 = _1253;
    _1292 = _1254;
    _1293 = _1255;
    do {
      if (((((uint)(UniformBufferConstants_WorkingColorSpace_020x)) == 0))) {
        float _1274 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1255, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1254, ((UniformBufferConstants_WorkingColorSpace_008x)*_1253))));
        float _1277 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1255, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1254, ((UniformBufferConstants_WorkingColorSpace_009x)*_1253))));
        float _1280 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1255, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1254, ((UniformBufferConstants_WorkingColorSpace_010x)*_1253))));
        _1291 = (mad(_45, _1280, (mad(_44, _1277, (_1274 * _43)))));
        _1292 = (mad(_48, _1280, (mad(_47, _1277, (_1274 * _46)))));
        _1293 = (mad(_51, _1280, (mad(_50, _1277, (_1274 * _49)))));
      }
      do {
        if (((_1291 < 0.0031306699384003878f))) {
          _1304 = (_1291 * 12.920000076293945f);
        } else {
          _1304 = (((exp2(((log2(_1291)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (((_1292 < 0.0031306699384003878f))) {
            _1315 = (_1292 * 12.920000076293945f);
          } else {
            _1315 = (((exp2(((log2(_1292)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (((_1293 < 0.0031306699384003878f))) {
            _2671 = _1304;
            _2672 = _1315;
            _2673 = (_1293 * 12.920000076293945f);
          } else {
            _2671 = _1304;
            _2672 = _1315;
            _2673 = (((exp2(((log2(_1293)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (((((uint)(cb0_042w)) == 1))) {
      float _1342 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1225, ((UniformBufferConstants_WorkingColorSpace_008x)*_1224))));
      float _1345 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1225, ((UniformBufferConstants_WorkingColorSpace_009x)*_1224))));
      float _1348 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1225, ((UniformBufferConstants_WorkingColorSpace_010x)*_1224))));
      float _1358 = max(6.103519990574569e-05f, (mad(_45, _1348, (mad(_44, _1345, (_1342 * _43))))));
      float _1359 = max(6.103519990574569e-05f, (mad(_48, _1348, (mad(_47, _1345, (_1342 * _46))))));
      float _1360 = max(6.103519990574569e-05f, (mad(_51, _1348, (mad(_50, _1345, (_1342 * _49))))));
      _2671 = (min((_1358 * 4.5f), (((exp2(((log2((max(_1358, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2672 = (min((_1359 * 4.5f), (((exp2(((log2((max(_1359, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2673 = (min((_1360 * 4.5f), (((exp2(((log2((max(_1360, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
    } else {
      if ((((bool)((((uint)(cb0_042w)) == 3))) || ((bool)((((uint)(cb0_042w)) == 5))))) {
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
        float _1435 = (cb0_012z)*_1210;
        float _1436 = (cb0_012z)*_1211;
        float _1437 = (cb0_012z)*_1212;
        float _1440 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1437, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1436, ((UniformBufferConstants_WorkingColorSpace_016x)*_1435))));
        float _1443 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1437, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1436, ((UniformBufferConstants_WorkingColorSpace_017x)*_1435))));
        float _1446 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1437, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1436, ((UniformBufferConstants_WorkingColorSpace_018x)*_1435))));
        float _1450 = max((max(_1440, _1443)), _1446);
        float _1455 = ((max(_1450, 1.000000013351432e-10f)) - (max((min((min(_1440, _1443)), _1446)), 1.000000013351432e-10f))) / (max(_1450, 0.009999999776482582f));
        float _1468 = ((_1443 + _1440) + _1446) + ((sqrt(((((_1446 - _1443) * _1446) + ((_1443 - _1440) * _1443)) + ((_1440 - _1446) * _1440)))) * 1.75f);
        float _1469 = _1468 * 0.3333333432674408f;
        float _1470 = _1455 + -0.4000000059604645f;
        float _1471 = _1470 * 5.0f;
        float _1475 = max((1.0f - (abs((_1470 * 2.5f)))), 0.0f);
        float _1486 = (((float(((int(((bool)((_1471 > 0.0f))))) - (int(((bool)((_1471 < 0.0f)))))))) * (1.0f - (_1475 * _1475))) + 1.0f) * 0.02500000037252903f;
        _1495 = _1486;
        do {
          if ((!(_1469 <= 0.0533333346247673f))) {
            _1495 = 0.0f;
            if ((!(_1469 >= 0.1599999964237213f))) {
              _1495 = (((0.23999999463558197f / _1468) + -0.5f) * _1486);
            }
          }
          float _1496 = _1495 + 1.0f;
          float _1497 = _1496 * _1440;
          float _1498 = _1496 * _1443;
          float _1499 = _1496 * _1446;
          _1528 = 0.0f;
          do {
            if (!(((bool)((_1497 == _1498))) && ((bool)((_1498 == _1499))))) {
              float _1506 = ((_1497 * 2.0f) - _1498) - _1499;
              float _1509 = ((_1443 - _1446) * 1.7320507764816284f) * _1496;
              float _1511 = atan((_1509 / _1506));
              bool _1514 = (_1506 < 0.0f);
              bool _1515 = (_1506 == 0.0f);
              bool _1516 = (_1509 >= 0.0f);
              bool _1517 = (_1509 < 0.0f);
              _1528 = ((((bool)(_1516 && _1515)) ? 90.0f : ((((bool)(_1517 && _1515)) ? -90.0f : (((((bool)(_1517 && _1514)) ? (_1511 + -3.1415927410125732f) : ((((bool)(_1516 && _1514)) ? (_1511 + 3.1415927410125732f) : _1511)))) * 57.2957763671875f)))));
            }
            float _1533 = min((max(((((bool)((_1528 < 0.0f))) ? (_1528 + 360.0f) : _1528)), 0.0f)), 360.0f);
            do {
              if (((_1533 < -180.0f))) {
                _1542 = (_1533 + 360.0f);
              } else {
                _1542 = _1533;
                if (((_1533 > 180.0f))) {
                  _1542 = (_1533 + -360.0f);
                }
              }
              _1581 = 0.0f;
              do {
                if ((((bool)((_1542 > -67.5f))) && ((bool)((_1542 < 67.5f))))) {
                  float _1548 = (_1542 + 67.5f) * 0.029629629105329514f;
                  int _1549 = int(1549);
                  float _1551 = _1548 - (float(_1549));
                  float _1552 = _1551 * _1551;
                  float _1553 = _1552 * _1551;
                  if (((_1549 == 3))) {
                    _1581 = (((0.1666666716337204f - (_1551 * 0.5f)) + (_1552 * 0.5f)) - (_1553 * 0.1666666716337204f));
                  } else {
                    if (((_1549 == 2))) {
                      _1581 = ((0.6666666865348816f - _1552) + (_1553 * 0.5f));
                    } else {
                      if (((_1549 == 1))) {
                        _1581 = (((_1553 * -0.5f) + 0.1666666716337204f) + ((_1552 + _1551) * 0.5f));
                      } else {
                        _1581 = ((((bool)((_1549 == 0))) ? (_1553 * 0.1666666716337204f) : 0.0f));
                      }
                    }
                  }
                }
                float _1590 = min((max(((((_1455 * 0.27000001072883606f) * (0.029999999329447746f - _1497)) * _1581) + _1497), 0.0f)), 65535.0f);
                float _1591 = min((max(_1498, 0.0f)), 65535.0f);
                float _1592 = min((max(_1499, 0.0f)), 65535.0f);
                float _1605 = min((max((mad(-0.21492856740951538f, _1592, (mad(-0.2365107536315918f, _1591, (_1590 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                float _1606 = min((max((mad(-0.09967592358589172f, _1592, (mad(1.17622971534729f, _1591, (_1590 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                float _1607 = min((max((mad(0.9977163076400757f, _1592, (mad(-0.006032449658960104f, _1591, (_1590 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                float _1608 = dot(float3(_1605, _1606, _1607), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1619 = log2((max((((_1605 - _1608) * 0.9599999785423279f) + _1608), 1.000000013351432e-10f)));
                float _1620 = _1619 * 0.3010300099849701f;
                float _1621 = log2((cb0_008x));
                float _1622 = _1621 * 0.3010300099849701f;
                do {
                  if (!(!(_1620 <= _1622))) {
                    _1691 = ((log2((cb0_008y))) * 0.3010300099849701f);
                  } else {
                    float _1629 = log2((cb0_009x));
                    float _1630 = _1629 * 0.3010300099849701f;
                    if ((((bool)((_1620 > _1622))) && ((bool)((_1620 < _1630))))) {
                      float _1638 = ((_1619 - _1621) * 0.9030900001525879f) / ((_1629 - _1621) * 0.3010300099849701f);
                      int _1639 = int(1639);
                      float _1641 = _1638 - (float(_1639));
                      float _1643 = _10[_1639];
                      float _1646 = _10[(_1639 + 1)];
                      float _1651 = _1643 * 0.5f;
                      _1691 = (dot(float3((_1641 * _1641), _1641, 1.0f), float3((mad((_10[(_1639 + 2)]), 0.5f, (mad(_1646, -1.0f, _1651)))), (_1646 - _1643), (mad(_1646, 0.5f, _1651)))));
                    } else {
                      do {
                        if (!(!(_1620 >= _1630))) {
                          float _1660 = log2((cb0_008z));
                          if (((_1620 < (_1660 * 0.3010300099849701f)))) {
                            float _1668 = ((_1619 - _1629) * 0.9030900001525879f) / ((_1660 - _1629) * 0.3010300099849701f);
                            int _1669 = int(1669);
                            float _1671 = _1668 - (float(_1669));
                            float _1673 = _11[_1669];
                            float _1676 = _11[(_1669 + 1)];
                            float _1681 = _1673 * 0.5f;
                            _1691 = (dot(float3((_1671 * _1671), _1671, 1.0f), float3((mad((_11[(_1669 + 2)]), 0.5f, (mad(_1676, -1.0f, _1681)))), (_1676 - _1673), (mad(_1676, 0.5f, _1681)))));
                            break;
                          }
                        }
                        _1691 = ((log2((cb0_008w))) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1695 = log2((max((((_1606 - _1608) * 0.9599999785423279f) + _1608), 1.000000013351432e-10f)));
                  float _1696 = _1695 * 0.3010300099849701f;
                  do {
                    if (!(!(_1696 <= _1622))) {
                      _1765 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _1703 = log2((cb0_009x));
                      float _1704 = _1703 * 0.3010300099849701f;
                      if ((((bool)((_1696 > _1622))) && ((bool)((_1696 < _1704))))) {
                        float _1712 = ((_1695 - _1621) * 0.9030900001525879f) / ((_1703 - _1621) * 0.3010300099849701f);
                        int _1713 = int(1713);
                        float _1715 = _1712 - (float(_1713));
                        float _1717 = _10[_1713];
                        float _1720 = _10[(_1713 + 1)];
                        float _1725 = _1717 * 0.5f;
                        _1765 = (dot(float3((_1715 * _1715), _1715, 1.0f), float3((mad((_10[(_1713 + 2)]), 0.5f, (mad(_1720, -1.0f, _1725)))), (_1720 - _1717), (mad(_1720, 0.5f, _1725)))));
                      } else {
                        do {
                          if (!(!(_1696 >= _1704))) {
                            float _1734 = log2((cb0_008z));
                            if (((_1696 < (_1734 * 0.3010300099849701f)))) {
                              float _1742 = ((_1695 - _1703) * 0.9030900001525879f) / ((_1734 - _1703) * 0.3010300099849701f);
                              int _1743 = int(1743);
                              float _1745 = _1742 - (float(_1743));
                              float _1747 = _11[_1743];
                              float _1750 = _11[(_1743 + 1)];
                              float _1755 = _1747 * 0.5f;
                              _1765 = (dot(float3((_1745 * _1745), _1745, 1.0f), float3((mad((_11[(_1743 + 2)]), 0.5f, (mad(_1750, -1.0f, _1755)))), (_1750 - _1747), (mad(_1750, 0.5f, _1755)))));
                              break;
                            }
                          }
                          _1765 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1769 = log2((max((((_1607 - _1608) * 0.9599999785423279f) + _1608), 1.000000013351432e-10f)));
                    float _1770 = _1769 * 0.3010300099849701f;
                    do {
                      if (!(!(_1770 <= _1622))) {
                        _1839 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _1777 = log2((cb0_009x));
                        float _1778 = _1777 * 0.3010300099849701f;
                        if ((((bool)((_1770 > _1622))) && ((bool)((_1770 < _1778))))) {
                          float _1786 = ((_1769 - _1621) * 0.9030900001525879f) / ((_1777 - _1621) * 0.3010300099849701f);
                          int _1787 = int(1787);
                          float _1789 = _1786 - (float(_1787));
                          float _1791 = _10[_1787];
                          float _1794 = _10[(_1787 + 1)];
                          float _1799 = _1791 * 0.5f;
                          _1839 = (dot(float3((_1789 * _1789), _1789, 1.0f), float3((mad((_10[(_1787 + 2)]), 0.5f, (mad(_1794, -1.0f, _1799)))), (_1794 - _1791), (mad(_1794, 0.5f, _1799)))));
                        } else {
                          do {
                            if (!(!(_1770 >= _1778))) {
                              float _1808 = log2((cb0_008z));
                              if (((_1770 < (_1808 * 0.3010300099849701f)))) {
                                float _1816 = ((_1769 - _1777) * 0.9030900001525879f) / ((_1808 - _1777) * 0.3010300099849701f);
                                int _1817 = int(1817);
                                float _1819 = _1816 - (float(_1817));
                                float _1821 = _11[_1817];
                                float _1824 = _11[(_1817 + 1)];
                                float _1829 = _1821 * 0.5f;
                                _1839 = (dot(float3((_1819 * _1819), _1819, 1.0f), float3((mad((_11[(_1817 + 2)]), 0.5f, (mad(_1824, -1.0f, _1829)))), (_1824 - _1821), (mad(_1824, 0.5f, _1829)))));
                                break;
                              }
                            }
                            _1839 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1843 = (cb0_008w) - (cb0_008y);
                      float _1844 = ((exp2((_1691 * 3.321928024291992f))) - (cb0_008y)) / _1843;
                      float _1846 = ((exp2((_1765 * 3.321928024291992f))) - (cb0_008y)) / _1843;
                      float _1848 = ((exp2((_1839 * 3.321928024291992f))) - (cb0_008y)) / _1843;
                      float _1851 = mad(0.15618768334388733f, _1848, (mad(0.13400420546531677f, _1846, (_1844 * 0.6624541878700256f))));
                      float _1854 = mad(0.053689517080783844f, _1848, (mad(0.6740817427635193f, _1846, (_1844 * 0.2722287178039551f))));
                      float _1857 = mad(1.0103391408920288f, _1848, (mad(0.00406073359772563f, _1846, (_1844 * -0.005574649665504694f))));
                      float _1870 = min((max((mad(-0.23642469942569733f, _1857, (mad(-0.32480329275131226f, _1854, (_1851 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                      float _1871 = min((max((mad(0.016756348311901093f, _1857, (mad(1.6153316497802734f, _1854, (_1851 * -0.663662850856781f))))), 0.0f)), 1.0f);
                      float _1872 = min((max((mad(0.9883948564529419f, _1857, (mad(-0.008284442126750946f, _1854, (_1851 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                      float _1875 = mad(0.15618768334388733f, _1872, (mad(0.13400420546531677f, _1871, (_1870 * 0.6624541878700256f))));
                      float _1878 = mad(0.053689517080783844f, _1872, (mad(0.6740817427635193f, _1871, (_1870 * 0.2722287178039551f))));
                      float _1881 = mad(1.0103391408920288f, _1872, (mad(0.00406073359772563f, _1871, (_1870 * -0.005574649665504694f))));
                      float _1903 = min((max(((min((max((mad(-0.23642469942569733f, _1881, (mad(-0.32480329275131226f, _1878, (_1875 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1904 = min((max(((min((max((mad(0.016756348311901093f, _1881, (mad(1.6153316497802734f, _1878, (_1875 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1905 = min((max(((min((max((mad(0.9883948564529419f, _1881, (mad(-0.008284442126750946f, _1878, (_1875 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      _1918 = _1903;
                      _1919 = _1904;
                      _1920 = _1905;
                      do {
                        if (!((((uint)(cb0_042w)) == 5))) {
                          _1918 = (mad(_45, _1905, (mad(_44, _1904, (_1903 * _43)))));
                          _1919 = (mad(_48, _1905, (mad(_47, _1904, (_1903 * _46)))));
                          _1920 = (mad(_51, _1905, (mad(_50, _1904, (_1903 * _49)))));
                        }
                        float _1930 = exp2(((log2((_1918 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1931 = exp2(((log2((_1919 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1932 = exp2(((log2((_1920 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        _2671 = (exp2(((log2(((1.0f / ((_1930 * 18.6875f) + 1.0f)) * ((_1930 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2672 = (exp2(((log2(((1.0f / ((_1931 * 18.6875f) + 1.0f)) * ((_1931 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2673 = (exp2(((log2(((1.0f / ((_1932 * 18.6875f) + 1.0f)) * ((_1932 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((((((uint)(cb0_042w)) & -3) == 4))) {
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
          float _2009 = (cb0_012z)*_1210;
          float _2010 = (cb0_012z)*_1211;
          float _2011 = (cb0_012z)*_1212;
          float _2014 = mad((UniformBufferConstants_WorkingColorSpace_016z), _2011, (mad((UniformBufferConstants_WorkingColorSpace_016y), _2010, ((UniformBufferConstants_WorkingColorSpace_016x)*_2009))));
          float _2017 = mad((UniformBufferConstants_WorkingColorSpace_017z), _2011, (mad((UniformBufferConstants_WorkingColorSpace_017y), _2010, ((UniformBufferConstants_WorkingColorSpace_017x)*_2009))));
          float _2020 = mad((UniformBufferConstants_WorkingColorSpace_018z), _2011, (mad((UniformBufferConstants_WorkingColorSpace_018y), _2010, ((UniformBufferConstants_WorkingColorSpace_018x)*_2009))));
          float _2024 = max((max(_2014, _2017)), _2020);
          float _2029 = ((max(_2024, 1.000000013351432e-10f)) - (max((min((min(_2014, _2017)), _2020)), 1.000000013351432e-10f))) / (max(_2024, 0.009999999776482582f));
          float _2042 = ((_2017 + _2014) + _2020) + ((sqrt(((((_2020 - _2017) * _2020) + ((_2017 - _2014) * _2017)) + ((_2014 - _2020) * _2014)))) * 1.75f);
          float _2043 = _2042 * 0.3333333432674408f;
          float _2044 = _2029 + -0.4000000059604645f;
          float _2045 = _2044 * 5.0f;
          float _2049 = max((1.0f - (abs((_2044 * 2.5f)))), 0.0f);
          float _2060 = (((float(((int(((bool)((_2045 > 0.0f))))) - (int(((bool)((_2045 < 0.0f)))))))) * (1.0f - (_2049 * _2049))) + 1.0f) * 0.02500000037252903f;
          _2069 = _2060;
          do {
            if ((!(_2043 <= 0.0533333346247673f))) {
              _2069 = 0.0f;
              if ((!(_2043 >= 0.1599999964237213f))) {
                _2069 = (((0.23999999463558197f / _2042) + -0.5f) * _2060);
              }
            }
            float _2070 = _2069 + 1.0f;
            float _2071 = _2070 * _2014;
            float _2072 = _2070 * _2017;
            float _2073 = _2070 * _2020;
            _2102 = 0.0f;
            do {
              if (!(((bool)((_2071 == _2072))) && ((bool)((_2072 == _2073))))) {
                float _2080 = ((_2071 * 2.0f) - _2072) - _2073;
                float _2083 = ((_2017 - _2020) * 1.7320507764816284f) * _2070;
                float _2085 = atan((_2083 / _2080));
                bool _2088 = (_2080 < 0.0f);
                bool _2089 = (_2080 == 0.0f);
                bool _2090 = (_2083 >= 0.0f);
                bool _2091 = (_2083 < 0.0f);
                _2102 = ((((bool)(_2090 && _2089)) ? 90.0f : ((((bool)(_2091 && _2089)) ? -90.0f : (((((bool)(_2091 && _2088)) ? (_2085 + -3.1415927410125732f) : ((((bool)(_2090 && _2088)) ? (_2085 + 3.1415927410125732f) : _2085)))) * 57.2957763671875f)))));
              }
              float _2107 = min((max(((((bool)((_2102 < 0.0f))) ? (_2102 + 360.0f) : _2102)), 0.0f)), 360.0f);
              do {
                if (((_2107 < -180.0f))) {
                  _2116 = (_2107 + 360.0f);
                } else {
                  _2116 = _2107;
                  if (((_2107 > 180.0f))) {
                    _2116 = (_2107 + -360.0f);
                  }
                }
                _2155 = 0.0f;
                do {
                  if ((((bool)((_2116 > -67.5f))) && ((bool)((_2116 < 67.5f))))) {
                    float _2122 = (_2116 + 67.5f) * 0.029629629105329514f;
                    int _2123 = int(2123);
                    float _2125 = _2122 - (float(_2123));
                    float _2126 = _2125 * _2125;
                    float _2127 = _2126 * _2125;
                    if (((_2123 == 3))) {
                      _2155 = (((0.1666666716337204f - (_2125 * 0.5f)) + (_2126 * 0.5f)) - (_2127 * 0.1666666716337204f));
                    } else {
                      if (((_2123 == 2))) {
                        _2155 = ((0.6666666865348816f - _2126) + (_2127 * 0.5f));
                      } else {
                        if (((_2123 == 1))) {
                          _2155 = (((_2127 * -0.5f) + 0.1666666716337204f) + ((_2126 + _2125) * 0.5f));
                        } else {
                          _2155 = ((((bool)((_2123 == 0))) ? (_2127 * 0.1666666716337204f) : 0.0f));
                        }
                      }
                    }
                  }
                  float _2164 = min((max(((((_2029 * 0.27000001072883606f) * (0.029999999329447746f - _2071)) * _2155) + _2071), 0.0f)), 65535.0f);
                  float _2165 = min((max(_2072, 0.0f)), 65535.0f);
                  float _2166 = min((max(_2073, 0.0f)), 65535.0f);
                  float _2179 = min((max((mad(-0.21492856740951538f, _2166, (mad(-0.2365107536315918f, _2165, (_2164 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                  float _2180 = min((max((mad(-0.09967592358589172f, _2166, (mad(1.17622971534729f, _2165, (_2164 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                  float _2181 = min((max((mad(0.9977163076400757f, _2166, (mad(-0.006032449658960104f, _2165, (_2164 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                  float _2182 = dot(float3(_2179, _2180, _2181), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2193 = log2((max((((_2179 - _2182) * 0.9599999785423279f) + _2182), 1.000000013351432e-10f)));
                  float _2194 = _2193 * 0.3010300099849701f;
                  float _2195 = log2((cb0_008x));
                  float _2196 = _2195 * 0.3010300099849701f;
                  do {
                    if (!(!(_2194 <= _2196))) {
                      _2265 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _2203 = log2((cb0_009x));
                      float _2204 = _2203 * 0.3010300099849701f;
                      if ((((bool)((_2194 > _2196))) && ((bool)((_2194 < _2204))))) {
                        float _2212 = ((_2193 - _2195) * 0.9030900001525879f) / ((_2203 - _2195) * 0.3010300099849701f);
                        int _2213 = int(2213);
                        float _2215 = _2212 - (float(_2213));
                        float _2217 = _8[_2213];
                        float _2220 = _8[(_2213 + 1)];
                        float _2225 = _2217 * 0.5f;
                        _2265 = (dot(float3((_2215 * _2215), _2215, 1.0f), float3((mad((_8[(_2213 + 2)]), 0.5f, (mad(_2220, -1.0f, _2225)))), (_2220 - _2217), (mad(_2220, 0.5f, _2225)))));
                      } else {
                        do {
                          if (!(!(_2194 >= _2204))) {
                            float _2234 = log2((cb0_008z));
                            if (((_2194 < (_2234 * 0.3010300099849701f)))) {
                              float _2242 = ((_2193 - _2203) * 0.9030900001525879f) / ((_2234 - _2203) * 0.3010300099849701f);
                              int _2243 = int(2243);
                              float _2245 = _2242 - (float(_2243));
                              float _2247 = _9[_2243];
                              float _2250 = _9[(_2243 + 1)];
                              float _2255 = _2247 * 0.5f;
                              _2265 = (dot(float3((_2245 * _2245), _2245, 1.0f), float3((mad((_9[(_2243 + 2)]), 0.5f, (mad(_2250, -1.0f, _2255)))), (_2250 - _2247), (mad(_2250, 0.5f, _2255)))));
                              break;
                            }
                          }
                          _2265 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2269 = log2((max((((_2180 - _2182) * 0.9599999785423279f) + _2182), 1.000000013351432e-10f)));
                    float _2270 = _2269 * 0.3010300099849701f;
                    do {
                      if (!(!(_2270 <= _2196))) {
                        _2339 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _2277 = log2((cb0_009x));
                        float _2278 = _2277 * 0.3010300099849701f;
                        if ((((bool)((_2270 > _2196))) && ((bool)((_2270 < _2278))))) {
                          float _2286 = ((_2269 - _2195) * 0.9030900001525879f) / ((_2277 - _2195) * 0.3010300099849701f);
                          int _2287 = int(2287);
                          float _2289 = _2286 - (float(_2287));
                          float _2291 = _8[_2287];
                          float _2294 = _8[(_2287 + 1)];
                          float _2299 = _2291 * 0.5f;
                          _2339 = (dot(float3((_2289 * _2289), _2289, 1.0f), float3((mad((_8[(_2287 + 2)]), 0.5f, (mad(_2294, -1.0f, _2299)))), (_2294 - _2291), (mad(_2294, 0.5f, _2299)))));
                        } else {
                          do {
                            if (!(!(_2270 >= _2278))) {
                              float _2308 = log2((cb0_008z));
                              if (((_2270 < (_2308 * 0.3010300099849701f)))) {
                                float _2316 = ((_2269 - _2277) * 0.9030900001525879f) / ((_2308 - _2277) * 0.3010300099849701f);
                                int _2317 = int(2317);
                                float _2319 = _2316 - (float(_2317));
                                float _2321 = _9[_2317];
                                float _2324 = _9[(_2317 + 1)];
                                float _2329 = _2321 * 0.5f;
                                _2339 = (dot(float3((_2319 * _2319), _2319, 1.0f), float3((mad((_9[(_2317 + 2)]), 0.5f, (mad(_2324, -1.0f, _2329)))), (_2324 - _2321), (mad(_2324, 0.5f, _2329)))));
                                break;
                              }
                            }
                            _2339 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2343 = log2((max((((_2181 - _2182) * 0.9599999785423279f) + _2182), 1.000000013351432e-10f)));
                      float _2344 = _2343 * 0.3010300099849701f;
                      do {
                        if (!(!(_2344 <= _2196))) {
                          _2413 = ((log2((cb0_008y))) * 0.3010300099849701f);
                        } else {
                          float _2351 = log2((cb0_009x));
                          float _2352 = _2351 * 0.3010300099849701f;
                          if ((((bool)((_2344 > _2196))) && ((bool)((_2344 < _2352))))) {
                            float _2360 = ((_2343 - _2195) * 0.9030900001525879f) / ((_2351 - _2195) * 0.3010300099849701f);
                            int _2361 = int(2361);
                            float _2363 = _2360 - (float(_2361));
                            float _2365 = _8[_2361];
                            float _2368 = _8[(_2361 + 1)];
                            float _2373 = _2365 * 0.5f;
                            _2413 = (dot(float3((_2363 * _2363), _2363, 1.0f), float3((mad((_8[(_2361 + 2)]), 0.5f, (mad(_2368, -1.0f, _2373)))), (_2368 - _2365), (mad(_2368, 0.5f, _2373)))));
                          } else {
                            do {
                              if (!(!(_2344 >= _2352))) {
                                float _2382 = log2((cb0_008z));
                                if (((_2344 < (_2382 * 0.3010300099849701f)))) {
                                  float _2390 = ((_2343 - _2351) * 0.9030900001525879f) / ((_2382 - _2351) * 0.3010300099849701f);
                                  int _2391 = int(2391);
                                  float _2393 = _2390 - (float(_2391));
                                  float _2395 = _9[_2391];
                                  float _2398 = _9[(_2391 + 1)];
                                  float _2403 = _2395 * 0.5f;
                                  _2413 = (dot(float3((_2393 * _2393), _2393, 1.0f), float3((mad((_9[(_2391 + 2)]), 0.5f, (mad(_2398, -1.0f, _2403)))), (_2398 - _2395), (mad(_2398, 0.5f, _2403)))));
                                  break;
                                }
                              }
                              _2413 = ((log2((cb0_008w))) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2417 = (cb0_008w) - (cb0_008y);
                        float _2418 = ((exp2((_2265 * 3.321928024291992f))) - (cb0_008y)) / _2417;
                        float _2420 = ((exp2((_2339 * 3.321928024291992f))) - (cb0_008y)) / _2417;
                        float _2422 = ((exp2((_2413 * 3.321928024291992f))) - (cb0_008y)) / _2417;
                        float _2425 = mad(0.15618768334388733f, _2422, (mad(0.13400420546531677f, _2420, (_2418 * 0.6624541878700256f))));
                        float _2428 = mad(0.053689517080783844f, _2422, (mad(0.6740817427635193f, _2420, (_2418 * 0.2722287178039551f))));
                        float _2431 = mad(1.0103391408920288f, _2422, (mad(0.00406073359772563f, _2420, (_2418 * -0.005574649665504694f))));
                        float _2444 = min((max((mad(-0.23642469942569733f, _2431, (mad(-0.32480329275131226f, _2428, (_2425 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                        float _2445 = min((max((mad(0.016756348311901093f, _2431, (mad(1.6153316497802734f, _2428, (_2425 * -0.663662850856781f))))), 0.0f)), 1.0f);
                        float _2446 = min((max((mad(0.9883948564529419f, _2431, (mad(-0.008284442126750946f, _2428, (_2425 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                        float _2449 = mad(0.15618768334388733f, _2446, (mad(0.13400420546531677f, _2445, (_2444 * 0.6624541878700256f))));
                        float _2452 = mad(0.053689517080783844f, _2446, (mad(0.6740817427635193f, _2445, (_2444 * 0.2722287178039551f))));
                        float _2455 = mad(1.0103391408920288f, _2446, (mad(0.00406073359772563f, _2445, (_2444 * -0.005574649665504694f))));
                        float _2477 = min((max(((min((max((mad(-0.23642469942569733f, _2455, (mad(-0.32480329275131226f, _2452, (_2449 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2478 = min((max(((min((max((mad(0.016756348311901093f, _2455, (mad(1.6153316497802734f, _2452, (_2449 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2479 = min((max(((min((max((mad(0.9883948564529419f, _2455, (mad(-0.008284442126750946f, _2452, (_2449 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        _2492 = _2477;
                        _2493 = _2478;
                        _2494 = _2479;
                        do {
                          if (!((((uint)(cb0_042w)) == 6))) {
                            _2492 = (mad(_45, _2479, (mad(_44, _2478, (_2477 * _43)))));
                            _2493 = (mad(_48, _2479, (mad(_47, _2478, (_2477 * _46)))));
                            _2494 = (mad(_51, _2479, (mad(_50, _2478, (_2477 * _49)))));
                          }
                          float _2504 = exp2(((log2((_2492 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2505 = exp2(((log2((_2493 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2506 = exp2(((log2((_2494 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          _2671 = (exp2(((log2(((1.0f / ((_2504 * 18.6875f) + 1.0f)) * ((_2504 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2672 = (exp2(((log2(((1.0f / ((_2505 * 18.6875f) + 1.0f)) * ((_2505 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2673 = (exp2(((log2(((1.0f / ((_2506 * 18.6875f) + 1.0f)) * ((_2506 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (((((uint)(cb0_042w)) == 7))) {
            float _2551 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1212, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1211, ((UniformBufferConstants_WorkingColorSpace_008x)*_1210))));
            float _2554 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1212, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1211, ((UniformBufferConstants_WorkingColorSpace_009x)*_1210))));
            float _2557 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1212, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1211, ((UniformBufferConstants_WorkingColorSpace_010x)*_1210))));
            float _2576 = exp2(((log2(((mad(_45, _2557, (mad(_44, _2554, (_2551 * _43))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2577 = exp2(((log2(((mad(_48, _2557, (mad(_47, _2554, (_2551 * _46))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2578 = exp2(((log2(((mad(_51, _2557, (mad(_50, _2554, (_2551 * _49))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            _2671 = (exp2(((log2(((1.0f / ((_2576 * 18.6875f) + 1.0f)) * ((_2576 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2672 = (exp2(((log2(((1.0f / ((_2577 * 18.6875f) + 1.0f)) * ((_2577 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2673 = (exp2(((log2(((1.0f / ((_2578 * 18.6875f) + 1.0f)) * ((_2578 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
          } else {
            _2671 = _1210;
            _2672 = _1211;
            _2673 = _1212;
            if (!((((uint)(cb0_042w)) == 8))) {
              if (((((uint)(cb0_042w)) == 9))) {
                float _2625 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1200, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1199, ((UniformBufferConstants_WorkingColorSpace_008x)*_1198))));
                float _2628 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1200, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1199, ((UniformBufferConstants_WorkingColorSpace_009x)*_1198))));
                float _2631 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1200, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1199, ((UniformBufferConstants_WorkingColorSpace_010x)*_1198))));
                _2671 = (mad(_45, _2631, (mad(_44, _2628, (_2625 * _43)))));
                _2672 = (mad(_48, _2631, (mad(_47, _2628, (_2625 * _46)))));
                _2673 = (mad(_51, _2631, (mad(_50, _2628, (_2625 * _49)))));
              } else {
                float _2644 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1225, ((UniformBufferConstants_WorkingColorSpace_008x)*_1224))));
                float _2647 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1225, ((UniformBufferConstants_WorkingColorSpace_009x)*_1224))));
                float _2650 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1226, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1225, ((UniformBufferConstants_WorkingColorSpace_010x)*_1224))));
                _2671 = (exp2(((log2((mad(_45, _2650, (mad(_44, _2647, (_2644 * _43))))))) * (cb0_042z))));
                _2672 = (exp2(((log2((mad(_48, _2650, (mad(_47, _2647, (_2644 * _46))))))) * (cb0_042z))));
                _2673 = (exp2(((log2((mad(_51, _2650, (mad(_50, _2647, (_2644 * _49))))))) * (cb0_042z))));
              }
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2671 * 0.9523810148239136f);
  SV_Target.y = (_2672 * 0.9523810148239136f);
  SV_Target.z = (_2673 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
