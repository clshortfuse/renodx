#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
//   float cb0_005z : packoffset(c005.z);
//   float cb0_005w : packoffset(c005.w);
//   float cb0_008x : packoffset(c008.x);
//   float cb0_008y : packoffset(c008.y);
//   float cb0_008z : packoffset(c008.z);
//   float cb0_008w : packoffset(c008.w);
//   float cb0_009x : packoffset(c009.x);
//   float cb0_010x : packoffset(c010.x);
//   float cb0_010y : packoffset(c010.y);
//   float cb0_010z : packoffset(c010.z);
//   float cb0_010w : packoffset(c010.w);
//   float cb0_011x : packoffset(c011.x);
//   float cb0_011y : packoffset(c011.y);
//   float cb0_011z : packoffset(c011.z);
//   float cb0_011w : packoffset(c011.w);
//   float cb0_012x : packoffset(c012.x);
//   float cb0_012y : packoffset(c012.y);
//   float cb0_012z : packoffset(c012.z);
//   float cb0_013x : packoffset(c013.x);
//   float cb0_013y : packoffset(c013.y);
//   float cb0_013z : packoffset(c013.z);
//   float cb0_013w : packoffset(c013.w);
//   float cb0_014x : packoffset(c014.x);
//   float cb0_014y : packoffset(c014.y);
//   float cb0_014z : packoffset(c014.z);
//   float cb0_015x : packoffset(c015.x);
//   float cb0_015y : packoffset(c015.y);
//   float cb0_015z : packoffset(c015.z);
//   float cb0_015w : packoffset(c015.w);
//   float cb0_016x : packoffset(c016.x);
//   float cb0_016y : packoffset(c016.y);
//   float cb0_016z : packoffset(c016.z);
//   float cb0_016w : packoffset(c016.w);
//   float cb0_017x : packoffset(c017.x);
//   float cb0_017y : packoffset(c017.y);
//   float cb0_017z : packoffset(c017.z);
//   float cb0_017w : packoffset(c017.w);
//   float cb0_018x : packoffset(c018.x);
//   float cb0_018y : packoffset(c018.y);
//   float cb0_018z : packoffset(c018.z);
//   float cb0_018w : packoffset(c018.w);
//   float cb0_019x : packoffset(c019.x);
//   float cb0_019y : packoffset(c019.y);
//   float cb0_019z : packoffset(c019.z);
//   float cb0_019w : packoffset(c019.w);
//   float cb0_020x : packoffset(c020.x);
//   float cb0_020y : packoffset(c020.y);
//   float cb0_020z : packoffset(c020.z);
//   float cb0_020w : packoffset(c020.w);
//   float cb0_021x : packoffset(c021.x);
//   float cb0_021y : packoffset(c021.y);
//   float cb0_021z : packoffset(c021.z);
//   float cb0_021w : packoffset(c021.w);
//   float cb0_022x : packoffset(c022.x);
//   float cb0_022y : packoffset(c022.y);
//   float cb0_022z : packoffset(c022.z);
//   float cb0_022w : packoffset(c022.w);
//   float cb0_023x : packoffset(c023.x);
//   float cb0_023y : packoffset(c023.y);
//   float cb0_023z : packoffset(c023.z);
//   float cb0_023w : packoffset(c023.w);
//   float cb0_024x : packoffset(c024.x);
//   float cb0_024y : packoffset(c024.y);
//   float cb0_024z : packoffset(c024.z);
//   float cb0_024w : packoffset(c024.w);
//   float cb0_025x : packoffset(c025.x);
//   float cb0_025y : packoffset(c025.y);
//   float cb0_025z : packoffset(c025.z);
//   float cb0_025w : packoffset(c025.w);
//   float cb0_026x : packoffset(c026.x);
//   float cb0_026y : packoffset(c026.y);
//   float cb0_026z : packoffset(c026.z);
//   float cb0_026w : packoffset(c026.w);
//   float cb0_027x : packoffset(c027.x);
//   float cb0_027y : packoffset(c027.y);
//   float cb0_027z : packoffset(c027.z);
//   float cb0_027w : packoffset(c027.w);
//   float cb0_028x : packoffset(c028.x);
//   float cb0_028y : packoffset(c028.y);
//   float cb0_028z : packoffset(c028.z);
//   float cb0_028w : packoffset(c028.w);
//   float cb0_029x : packoffset(c029.x);
//   float cb0_029y : packoffset(c029.y);
//   float cb0_029z : packoffset(c029.z);
//   float cb0_029w : packoffset(c029.w);
//   float cb0_030x : packoffset(c030.x);
//   float cb0_030y : packoffset(c030.y);
//   float cb0_030z : packoffset(c030.z);
//   float cb0_030w : packoffset(c030.w);
//   float cb0_031x : packoffset(c031.x);
//   float cb0_031y : packoffset(c031.y);
//   float cb0_031z : packoffset(c031.z);
//   float cb0_031w : packoffset(c031.w);
//   float cb0_032x : packoffset(c032.x);
//   float cb0_032y : packoffset(c032.y);
//   float cb0_032z : packoffset(c032.z);
//   float cb0_032w : packoffset(c032.w);
//   float cb0_033x : packoffset(c033.x);
//   float cb0_033y : packoffset(c033.y);
//   float cb0_033z : packoffset(c033.z);
//   float cb0_033w : packoffset(c033.w);
//   float cb0_034x : packoffset(c034.x);
//   float cb0_034y : packoffset(c034.y);
//   float cb0_034z : packoffset(c034.z);
//   float cb0_034w : packoffset(c034.w);
//   float cb0_035x : packoffset(c035.x);
//   float cb0_035y : packoffset(c035.y);
//   float cb0_035z : packoffset(c035.z);
//   float cb0_035w : packoffset(c035.w);
//   float cb0_036x : packoffset(c036.x);
//   float cb0_036y : packoffset(c036.y);
//   float expand_gamut : packoffset(c036.z);
//   float cb0_036w : packoffset(c036.w);
//   float cb0_037x : packoffset(c037.x);
//   float cb0_037y : packoffset(c037.y);
//   float cb0_037z : packoffset(c037.z);
//   float cb0_037w : packoffset(c037.w);
//   float cb0_038x : packoffset(c038.x);
//   int cb0_038z : packoffset(c038.z);
//   float cb0_039x : packoffset(c039.x);
//   float cb0_039y : packoffset(c039.y);
//   float cb0_039z : packoffset(c039.z);
//   float cb0_040y : packoffset(c040.y);
//   float cb0_040z : packoffset(c040.z);
//   int output_device : packoffset(c040.w);
//   int output_gamut : packoffset(c041.x);
//   float cb0_042x : packoffset(c042.x);
//   float cb0_042y : packoffset(c042.y);
// };

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
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
  float _28 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _29 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _32 = float((uint)SV_DispatchThreadID.z);
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _119;
  float _120;
  float _121;
  float _170;
  float _899;
  float _935;
  float _946;
  float _1010;
  float _1189;
  float _1200;
  float _1211;
  float _1434;
  float _1435;
  float _1436;
  float _1447;
  float _1458;
  float _1640;
  float _1676;
  float _1687;
  float _1726;
  float _1836;
  float _1910;
  float _1984;
  float _2063;
  float _2064;
  float _2065;
  float _2216;
  float _2252;
  float _2263;
  float _2302;
  float _2412;
  float _2486;
  float _2560;
  float _2639;
  float _2640;
  float _2641;
  float _2818;
  float _2819;
  float _2820;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _42 = (output_gamut == 4);
        _53 = select(_42, 1.0f, 1.7050515413284302f);
        _54 = select(_42, 0.0f, -0.6217905879020691f);
        _55 = select(_42, 0.0f, -0.0832584798336029f);
        _56 = select(_42, 0.0f, -0.13025718927383423f);
        _57 = select(_42, 1.0f, 1.1408027410507202f);
        _58 = select(_42, 0.0f, -0.010548528283834457f);
        _59 = select(_42, 0.0f, -0.024003278464078903f);
        _60 = select(_42, 0.0f, -0.1289687603712082f);
        _61 = select(_42, 1.0f, 1.152971863746643f);
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
      _53 = 1.02579927444458f;
      _54 = -0.020052503794431686f;
      _55 = -0.0057713985443115234f;
      _56 = -0.0022350111976265907f;
      _57 = 1.0045825242996216f;
      _58 = -0.002352306619286537f;
      _59 = -0.005014004185795784f;
      _60 = -0.025293385609984398f;
      _61 = 1.0304402112960815f;
    }
  } else {
    _53 = 1.379158854484558f;
    _54 = -0.3088507056236267f;
    _55 = -0.07034677267074585f;
    _56 = -0.06933528929948807f;
    _57 = 1.0822921991348267f;
    _58 = -0.012962047010660172f;
    _59 = -0.002159259282052517f;
    _60 = -0.045465391129255295f;
    _61 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _72 = exp2(log2(_28 * 1.0322580337524414f) * 0.012683313339948654f);
    float _73 = exp2(log2(_29 * 1.0322580337524414f) * 0.012683313339948654f);
    float _74 = exp2(log2(_32 * 0.032258063554763794f) * 0.012683313339948654f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _120 = (exp2(log2(max(0.0f, (_73 + -0.8359375f)) / (18.8515625f - (_73 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _119 = ((exp2((_28 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _120 = ((exp2((_29 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _121 = ((exp2((_32 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  bool _148 = (cb0_038z != 0);
  float _153 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _170 = (((((2967800.0f - (_153 * 4607000064.0f)) * _153) + 99.11000061035156f) * _153) + 0.24406300485134125f);
  } else {
    _170 = (((((1901800.0f - (_153 * 2006400000.0f)) * _153) + 247.47999572753906f) * _153) + 0.23703999817371368f);
  }
  float _184 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _191 = cb0_035x * cb0_035x;
  float _194 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_191 * 1.6145605741257896e-07f));
  float _199 = ((_184 * 2.0f) + 4.0f) - (_194 * 8.0f);
  float _200 = (_184 * 3.0f) / _199;
  float _202 = (_194 * 2.0f) / _199;
  bool _203 = (cb0_035x < 4000.0f);
  float _212 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _214 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_191 * 1.5317699909210205f)) / (_212 * _212);
  float _221 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _191;
  float _223 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_191 * 308.60699462890625f)) / (_221 * _221);
  float _225 = rsqrt(dot(float2(_214, _223), float2(_214, _223)));
  float _226 = cb0_035y * 0.05000000074505806f;
  float _229 = ((_226 * _223) * _225) + _184;
  float _232 = _194 - ((_226 * _214) * _225);
  float _237 = (4.0f - (_232 * 8.0f)) + (_229 * 2.0f);
  float _243 = (((_229 * 3.0f) / _237) - _200) + select(_203, _200, _170);
  float _244 = (((_232 * 2.0f) / _237) - _202) + select(_203, _202, (((_170 * 2.869999885559082f) + -0.2750000059604645f) - ((_170 * _170) * 3.0f)));
  float _245 = select(_148, _243, 0.3127000033855438f);
  float _246 = select(_148, _244, 0.32899999618530273f);
  float _247 = select(_148, 0.3127000033855438f, _243);
  float _248 = select(_148, 0.32899999618530273f, _244);
  float _249 = max(_246, 1.000000013351432e-10f);
  float _250 = _245 / _249;
  float _253 = ((1.0f - _245) - _246) / _249;
  float _254 = max(_248, 1.000000013351432e-10f);
  float _255 = _247 / _254;
  float _258 = ((1.0f - _247) - _248) / _254;
  float _277 = mad(-0.16140000522136688f, _258, ((_255 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _253, ((_250 * 0.8950999975204468f) + 0.266400009393692f));
  float _278 = mad(0.03669999912381172f, _258, (1.7135000228881836f - (_255 * 0.7501999735832214f))) / mad(0.03669999912381172f, _253, (1.7135000228881836f - (_250 * 0.7501999735832214f)));
  float _279 = mad(1.0296000242233276f, _258, ((_255 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _253, ((_250 * 0.03889999911189079f) + -0.06849999725818634f));
  float _280 = mad(_278, -0.7501999735832214f, 0.0f);
  float _281 = mad(_278, 1.7135000228881836f, 0.0f);
  float _282 = mad(_278, 0.03669999912381172f, -0.0f);
  float _283 = mad(_279, 0.03889999911189079f, 0.0f);
  float _284 = mad(_279, -0.06849999725818634f, 0.0f);
  float _285 = mad(_279, 1.0296000242233276f, 0.0f);
  float _288 = mad(0.1599626988172531f, _283, mad(-0.1470542997121811f, _280, (_277 * 0.883457362651825f)));
  float _291 = mad(0.1599626988172531f, _284, mad(-0.1470542997121811f, _281, (_277 * 0.26293492317199707f)));
  float _294 = mad(0.1599626988172531f, _285, mad(-0.1470542997121811f, _282, (_277 * -0.15930065512657166f)));
  float _297 = mad(0.04929120093584061f, _283, mad(0.5183603167533875f, _280, (_277 * 0.38695648312568665f)));
  float _300 = mad(0.04929120093584061f, _284, mad(0.5183603167533875f, _281, (_277 * 0.11516613513231277f)));
  float _303 = mad(0.04929120093584061f, _285, mad(0.5183603167533875f, _282, (_277 * -0.0697740763425827f)));
  float _306 = mad(0.9684867262840271f, _283, mad(0.04004279896616936f, _280, (_277 * -0.007634039502590895f)));
  float _309 = mad(0.9684867262840271f, _284, mad(0.04004279896616936f, _281, (_277 * -0.0022720457054674625f)));
  float _312 = mad(0.9684867262840271f, _285, mad(0.04004279896616936f, _282, (_277 * 0.0013765322510153055f)));
  float _315 = mad(_294, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_291, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_288 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _318 = mad(_294, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_291, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_288 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _321 = mad(_294, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_291, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_288 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _324 = mad(_303, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_300, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_297 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _327 = mad(_303, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_300, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_297 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _330 = mad(_303, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_300, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_297 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _333 = mad(_312, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_309, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_306 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _336 = mad(_312, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_309, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_306 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _339 = mad(_312, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_309, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_306 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _369 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _339, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _330, (_321 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _121, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _336, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _327, (_318 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _120, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _333, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _324, (_315 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _119)));
  float _372 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _339, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _330, (_321 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _121, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _336, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _327, (_318 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _120, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _333, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _324, (_315 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _119)));
  float _375 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _339, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _330, (_321 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _121, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _336, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _327, (_318 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _120, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _333, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _324, (_315 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _119)));
  float _390 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _375, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _372, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _369)));
  float _393 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _375, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _372, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _369)));
  float _396 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _375, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _372, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _369)));
  float _397 = dot(float3(_390, _393, _396), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _401 = (_390 / _397) + -1.0f;
  float _402 = (_393 / _397) + -1.0f;
  float _403 = (_396 / _397) + -1.0f;
  float _415 = (1.0f - exp2(((_397 * _397) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_401, _402, _403), float3(_401, _402, _403)) * -4.0f));
  float _431 = ((mad(-0.06368283927440643f, _396, mad(-0.32929131388664246f, _393, (_390 * 1.370412826538086f))) - _390) * _415) + _390;
  float _432 = ((mad(-0.010861567221581936f, _396, mad(1.0970908403396606f, _393, (_390 * -0.08343426138162613f))) - _393) * _415) + _393;
  float _433 = ((mad(1.203694462776184f, _396, mad(-0.09862564504146576f, _393, (_390 * -0.02579325996339321f))) - _396) * _415) + _396;

#if 1
  float _799, _801, _803;
  ApplyColorCorrection(
      _431, _432, _433,
      _799, _801, _803,
      ColorSaturation,
      ColorContrast,
      ColorGamma,
      ColorGain,
      ColorOffset,
      ColorSaturationShadows,
      ColorContrastShadows,
      ColorGammaShadows,
      ColorGainShadows,
      ColorOffsetShadows,
      ColorSaturationHighlights,
      ColorContrastHighlights,
      ColorGammaHighlights,
      ColorGainHighlights,
      ColorOffsetHighlights,
      ColorSaturationMidtones,
      ColorContrastMidtones,
      ColorGammaMidtones,
      ColorGainMidtones,
      ColorOffsetMidtones,
      ColorCorrectionShadowsMax,
      ColorCorrectionHighlightsMin,
      ColorCorrectionHighlightsMax);
#else
  float _434 = dot(float3(_431, _432, _433), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _448 = cb0_019w + cb0_024w;
  float _462 = cb0_018w * cb0_023w;
  float _476 = cb0_017w * cb0_022w;
  float _490 = cb0_016w * cb0_021w;
  float _504 = cb0_015w * cb0_020w;
  float _508 = _431 - _434;
  float _509 = _432 - _434;
  float _510 = _433 - _434;
  float _567 = saturate(_434 / cb0_035z);
  float _571 = (_567 * _567) * (3.0f - (_567 * 2.0f));
  float _572 = 1.0f - _571;
  float _581 = cb0_019w + cb0_034w;
  float _590 = cb0_018w * cb0_033w;
  float _599 = cb0_017w * cb0_032w;
  float _608 = cb0_016w * cb0_031w;
  float _617 = cb0_015w * cb0_030w;
  float _681 = saturate((_434 - cb0_035w) / (cb0_036x - cb0_035w));
  float _685 = (_681 * _681) * (3.0f - (_681 * 2.0f));
  float _694 = cb0_019w + cb0_029w;
  float _703 = cb0_018w * cb0_028w;
  float _712 = cb0_017w * cb0_027w;
  float _721 = cb0_016w * cb0_026w;
  float _730 = cb0_015w * cb0_025w;
  float _788 = _571 - _685;
  float _799 = ((_685 * (((cb0_019x + cb0_034x) + _581) + (((cb0_018x * cb0_033x) * _590) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _608) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _617) * _508) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _599)))))) + (_572 * (((cb0_019x + cb0_024x) + _448) + (((cb0_018x * cb0_023x) * _462) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _490) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _504) * _508) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _476))))))) + ((((cb0_019x + cb0_029x) + _694) + (((cb0_018x * cb0_028x) * _703) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _721) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _730) * _508) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _712))))) * _788);
  float _801 = ((_685 * (((cb0_019y + cb0_034y) + _581) + (((cb0_018y * cb0_033y) * _590) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _608) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _617) * _509) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _599)))))) + (_572 * (((cb0_019y + cb0_024y) + _448) + (((cb0_018y * cb0_023y) * _462) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _490) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _504) * _509) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _476))))))) + ((((cb0_019y + cb0_029y) + _694) + (((cb0_018y * cb0_028y) * _703) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _721) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _730) * _509) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _712))))) * _788);
  float _803 = ((_685 * (((cb0_019z + cb0_034z) + _581) + (((cb0_018z * cb0_033z) * _590) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _608) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _617) * _510) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _599)))))) + (_572 * (((cb0_019z + cb0_024z) + _448) + (((cb0_018z * cb0_023z) * _462) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _490) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _504) * _510) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _476))))))) + ((((cb0_019z + cb0_029z) + _694) + (((cb0_018z * cb0_028z) * _703) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _721) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _730) * _510) + _434)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _712))))) * _788);
#endif
  float _839 = ((mad(0.061360642313957214f, _803, mad(-4.540197551250458e-09f, _801, (_799 * 0.9386394023895264f))) - _799) * cb0_036y) + _799;
  float _840 = ((mad(0.169205904006958f, _803, mad(0.8307942152023315f, _801, (_799 * 6.775371730327606e-08f))) - _801) * cb0_036y) + _801;
  float _841 = (mad(-2.3283064365386963e-10f, _801, (_799 * -9.313225746154785e-10f)) * cb0_036y) + _803;
  float _844 = mad(0.16386905312538147f, _841, mad(0.14067868888378143f, _840, (_839 * 0.6954522132873535f)));
  float _847 = mad(0.0955343246459961f, _841, mad(0.8596711158752441f, _840, (_839 * 0.044794581830501556f)));
  float _850 = mad(1.0015007257461548f, _841, mad(0.004025210160762072f, _840, (_839 * -0.005525882821530104f)));
  float _854 = max(max(_844, _847), _850);
  float _859 = (max(_854, 1.000000013351432e-10f) - max(min(min(_844, _847), _850), 1.000000013351432e-10f)) / max(_854, 0.009999999776482582f);
  float _872 = ((_847 + _844) + _850) + (sqrt((((_850 - _847) * _850) + ((_847 - _844) * _847)) + ((_844 - _850) * _844)) * 1.75f);
  float _873 = _872 * 0.3333333432674408f;
  float _874 = _859 + -0.4000000059604645f;
  float _875 = _874 * 5.0f;
  float _879 = max((1.0f - abs(_874 * 2.5f)), 0.0f);
  float _890 = ((float((int)(((int)(uint)((bool)(_875 > 0.0f))) - ((int)(uint)((bool)(_875 < 0.0f))))) * (1.0f - (_879 * _879))) + 1.0f) * 0.02500000037252903f;
  if (!(_873 <= 0.0533333346247673f)) {
    if (!(_873 >= 0.1599999964237213f)) {
      _899 = (((0.23999999463558197f / _872) + -0.5f) * _890);
    } else {
      _899 = 0.0f;
    }
  } else {
    _899 = _890;
  }
  float _900 = _899 + 1.0f;
  float _901 = _900 * _844;
  float _902 = _900 * _847;
  float _903 = _900 * _850;
  if (!((bool)(_901 == _902) && (bool)(_902 == _903))) {
    float _910 = ((_901 * 2.0f) - _902) - _903;
    float _913 = ((_847 - _850) * 1.7320507764816284f) * _900;
    float _915 = atan(_913 / _910);
    bool _918 = (_910 < 0.0f);
    bool _919 = (_910 == 0.0f);
    bool _920 = (_913 >= 0.0f);
    bool _921 = (_913 < 0.0f);
    float _930 = select((_920 && _919), 90.0f, select((_921 && _919), -90.0f, (select((_921 && _918), (_915 + -3.1415927410125732f), select((_920 && _918), (_915 + 3.1415927410125732f), _915)) * 57.2957763671875f)));
    if (_930 < 0.0f) {
      _935 = (_930 + 360.0f);
    } else {
      _935 = _930;
    }
  } else {
    _935 = 0.0f;
  }
  float _937 = min(max(_935, 0.0f), 360.0f);
  if (_937 < -180.0f) {
    _946 = (_937 + 360.0f);
  } else {
    if (_937 > 180.0f) {
      _946 = (_937 + -360.0f);
    } else {
      _946 = _937;
    }
  }
  float _950 = saturate(1.0f - abs(_946 * 0.014814814552664757f));
  float _954 = (_950 * _950) * (3.0f - (_950 * 2.0f));
  float _960 = ((_954 * _954) * ((_859 * 0.18000000715255737f) * (0.029999999329447746f - _901))) + _901;
  float _970 = max(0.0f, mad(-0.21492856740951538f, _903, mad(-0.2365107536315918f, _902, (_960 * 1.4514392614364624f))));
  float _971 = max(0.0f, mad(-0.09967592358589172f, _903, mad(1.17622971534729f, _902, (_960 * -0.07655377686023712f))));
  float _972 = max(0.0f, mad(0.9977163076400757f, _903, mad(-0.006032449658960104f, _902, (_960 * 0.008316148072481155f))));
  float _973 = dot(float3(_970, _971, _972), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1019 = (lerp(_973, _970, 0.9599999785423279f));
  float _1020 = (lerp(_973, _971, 0.9599999785423279f));
  float _1021 = (lerp(_973, _972, 0.9599999785423279f));

#if 1
  float _1161, _1162, _1163;
  ApplyFilmicToneMap(_1019, _1020, _1021,
                     _839, _840, _841,
                     _1161, _1162, _1163);
#else
  _1019 = log2(_1019) * 0.3010300099849701f;
  _1020 = log2(_1020) * 0.3010300099849701f;
  _1021 = log2(_1021) * 0.3010300099849701f;

  float _987 = (cb0_037w + 1.0f) - cb0_037y;
  float _990 = cb0_038x + 1.0f;
  float _992 = _990 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _1010 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _1001 = (cb0_037w + 0.18000000715255737f) / _987;
    _1010 = (-0.7447274923324585f - ((log2(_1001 / (2.0f - _1001)) * 0.3465735912322998f) * (_987 / cb0_037x)));
  }
  float _1013 = ((1.0f - cb0_037y) / cb0_037x) - _1010;
  float _1015 = (cb0_037z / cb0_037x) - _1013;
  float _1025 = cb0_037x * (_1019 + _1013);
  float _1026 = cb0_037x * (_1020 + _1013);
  float _1027 = cb0_037x * (_1021 + _1013);
  float _1028 = _987 * 2.0f;
  float _1030 = (cb0_037x * -2.0f) / _987;
  float _1031 = _1019 - _1010;
  float _1032 = _1020 - _1010;
  float _1033 = _1021 - _1010;
  float _1052 = _992 * 2.0f;
  float _1054 = (cb0_037x * 2.0f) / _992;
  float _1079 = select((_1019 < _1010), ((_1028 / (exp2((_1031 * 1.4426950216293335f) * _1030) + 1.0f)) - cb0_037w), _1025);
  float _1080 = select((_1020 < _1010), ((_1028 / (exp2((_1032 * 1.4426950216293335f) * _1030) + 1.0f)) - cb0_037w), _1026);
  float _1081 = select((_1021 < _1010), ((_1028 / (exp2((_1033 * 1.4426950216293335f) * _1030) + 1.0f)) - cb0_037w), _1027);
  float _1088 = _1015 - _1010;
  float _1092 = saturate(_1031 / _1088);
  float _1093 = saturate(_1032 / _1088);
  float _1094 = saturate(_1033 / _1088);
  bool _1095 = (_1015 < _1010);
  float _1099 = select(_1095, (1.0f - _1092), _1092);
  float _1100 = select(_1095, (1.0f - _1093), _1093);
  float _1101 = select(_1095, (1.0f - _1094), _1094);
  float _1120 = (((_1099 * _1099) * (select((_1019 > _1015), (_990 - (_1052 / (exp2(((_1019 - _1015) * 1.4426950216293335f) * _1054) + 1.0f))), _1025) - _1079)) * (3.0f - (_1099 * 2.0f))) + _1079;
  float _1121 = (((_1100 * _1100) * (select((_1020 > _1015), (_990 - (_1052 / (exp2(((_1020 - _1015) * 1.4426950216293335f) * _1054) + 1.0f))), _1026) - _1080)) * (3.0f - (_1100 * 2.0f))) + _1080;
  float _1122 = (((_1101 * _1101) * (select((_1021 > _1015), (_990 - (_1052 / (exp2(((_1021 - _1015) * 1.4426950216293335f) * _1054) + 1.0f))), _1027) - _1081)) * (3.0f - (_1101 * 2.0f))) + _1081;
  float _1123 = dot(float3(_1120, _1121, _1122), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1143 = (cb0_036w * (max(0.0f, (lerp(_1123, _1120, 0.9300000071525574f))) - _839)) + _839;
  float _1144 = (cb0_036w * (max(0.0f, (lerp(_1123, _1121, 0.9300000071525574f))) - _840)) + _840;
  float _1145 = (cb0_036w * (max(0.0f, (lerp(_1123, _1122, 0.9300000071525574f))) - _841)) + _841;
  float _1161 = ((mad(-0.06537103652954102f, _1145, mad(1.451815478503704e-06f, _1144, (_1143 * 1.065374732017517f))) - _1143) * cb0_036y) + _1143;
  float _1162 = ((mad(-0.20366770029067993f, _1145, mad(1.2036634683609009f, _1144, (_1143 * -2.57161445915699e-07f))) - _1144) * cb0_036y) + _1144;
  float _1163 = ((mad(0.9999996423721313f, _1145, mad(2.0954757928848267e-08f, _1144, (_1143 * 1.862645149230957e-08f))) - _1145) * cb0_036y) + _1145;
#endif

  float _1176 = ((mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1163, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1162, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1161)))));
  float _1177 = ((mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1163, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1162, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1161)))));
  float _1178 = ((mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1163, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1162, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1161)))));

#if 1
  float _1329, _1330, _1331;
  Sample3LUTsUpgradeToneMap(
      float3(_1176, _1177, _1178),
      s0, s1, s2,
      t0, t1, t2,
      _1329, _1330, _1331);

#else
  if (_1176 < 0.0031306699384003878f) {
    _1189 = (_1176 * 12.920000076293945f);
  } else {
    _1189 = (((pow(_1176, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1177 < 0.0031306699384003878f) {
    _1200 = (_1177 * 12.920000076293945f);
  } else {
    _1200 = (((pow(_1177, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1178 < 0.0031306699384003878f) {
    _1211 = (_1178 * 12.920000076293945f);
  } else {
    _1211 = (((pow(_1178, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1215 = (_1200 * 0.9375f) + 0.03125f;
  float _1222 = _1211 * 15.0f;
  float _1223 = floor(_1222);
  float _1224 = _1222 - _1223;
  float _1226 = (_1223 + ((_1189 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1229 = t0.SampleLevel(s0, float2(_1226, _1215), 0.0f);
  float _1233 = _1226 + 0.0625f;
  float4 _1234 = t0.SampleLevel(s0, float2(_1233, _1215), 0.0f);
  float4 _1256 = t1.SampleLevel(s1, float2(_1226, _1215), 0.0f);
  float4 _1260 = t1.SampleLevel(s1, float2(_1233, _1215), 0.0f);
  float4 _1282 = t2.SampleLevel(s2, float2(_1226, _1215), 0.0f);
  float4 _1286 = t2.SampleLevel(s2, float2(_1233, _1215), 0.0f);
  float _1305 = max(6.103519990574569e-05f, (((((lerp(_1229.x, _1234.x, _1224))*cb0_005y) + (cb0_005x * _1189)) + ((lerp(_1256.x, _1260.x, _1224))*cb0_005z)) + ((lerp(_1282.x, _1286.x, _1224))*cb0_005w)));
  float _1306 = max(6.103519990574569e-05f, (((((lerp(_1229.y, _1234.y, _1224))*cb0_005y) + (cb0_005x * _1200)) + ((lerp(_1256.y, _1260.y, _1224))*cb0_005z)) + ((lerp(_1282.y, _1286.y, _1224))*cb0_005w)));
  float _1307 = max(6.103519990574569e-05f, (((((lerp(_1229.z, _1234.z, _1224))*cb0_005y) + (cb0_005x * _1211)) + ((lerp(_1256.z, _1260.z, _1224))*cb0_005z)) + ((lerp(_1282.z, _1286.z, _1224))*cb0_005w)));
  float _1329 = select((_1305 > 0.040449999272823334f), exp2(log2((_1305 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1305 * 0.07739938050508499f));
  float _1330 = select((_1306 > 0.040449999272823334f), exp2(log2((_1306 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1306 * 0.07739938050508499f));
  float _1331 = select((_1307 > 0.040449999272823334f), exp2(log2((_1307 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1307 * 0.07739938050508499f));
#endif

  float _1357 = cb0_014x * (((cb0_039y + (cb0_039x * _1329)) * _1329) + cb0_039z);
  float _1358 = cb0_014y * (((cb0_039y + (cb0_039x * _1330)) * _1330) + cb0_039z);
  float _1359 = cb0_014z * (((cb0_039y + (cb0_039x * _1331)) * _1331) + cb0_039z);
  float _1366 = ((cb0_013x - _1357) * cb0_013w) + _1357;
  float _1367 = ((cb0_013y - _1358) * cb0_013w) + _1358;
  float _1368 = ((cb0_013z - _1359) * cb0_013w) + _1359;

  if (GenerateOutput(_1366, _1367, _1368, u0[SV_DispatchThreadID])) {
    return;
  }

  float _1369 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _803, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _801, (_799 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1370 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _803, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _801, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _799)));
  float _1371 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _803, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _801, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _799)));
  float _1378 = ((cb0_013x - _1369) * cb0_013w) + _1369;
  float _1379 = ((cb0_013y - _1370) * cb0_013w) + _1370;
  float _1380 = ((cb0_013z - _1371) * cb0_013w) + _1371;
  float _1392 = exp2(log2(max(0.0f, _1366)) * cb0_040y);
  float _1393 = exp2(log2(max(0.0f, _1367)) * cb0_040y);
  float _1394 = exp2(log2(max(0.0f, _1368)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1417 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1392)));
        float _1420 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1392)));
        float _1423 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1392)));
        _1434 = mad(_55, _1423, mad(_54, _1420, (_1417 * _53)));
        _1435 = mad(_58, _1423, mad(_57, _1420, (_1417 * _56)));
        _1436 = mad(_61, _1423, mad(_60, _1420, (_1417 * _59)));
      } else {
        _1434 = _1392;
        _1435 = _1393;
        _1436 = _1394;
      }
      do {
        if (_1434 < 0.0031306699384003878f) {
          _1447 = (_1434 * 12.920000076293945f);
        } else {
          _1447 = (((pow(_1434, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1435 < 0.0031306699384003878f) {
            _1458 = (_1435 * 12.920000076293945f);
          } else {
            _1458 = (((pow(_1435, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1436 < 0.0031306699384003878f) {
            _2818 = _1447;
            _2819 = _1458;
            _2820 = (_1436 * 12.920000076293945f);
          } else {
            _2818 = _1447;
            _2819 = _1458;
            _2820 = (((pow(_1436, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1485 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1392)));
      float _1488 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1392)));
      float _1491 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1392)));
      float _1501 = max(6.103519990574569e-05f, mad(_55, _1491, mad(_54, _1488, (_1485 * _53))));
      float _1502 = max(6.103519990574569e-05f, mad(_58, _1491, mad(_57, _1488, (_1485 * _56))));
      float _1503 = max(6.103519990574569e-05f, mad(_61, _1491, mad(_60, _1488, (_1485 * _59))));
      _2818 = min((_1501 * 4.5f), ((exp2(log2(max(_1501, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2819 = min((_1502 * 4.5f), ((exp2(log2(max(_1502, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2820 = min((_1503 * 4.5f), ((exp2(log2(max(_1503, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1580 = cb0_012z * _1378;
        float _1581 = cb0_012z * _1379;
        float _1582 = cb0_012z * _1380;
        float _1585 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1582, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1581, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1580)));
        float _1588 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1582, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1581, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1580)));
        float _1591 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1582, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1581, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1580)));
        float _1595 = max(max(_1585, _1588), _1591);
        float _1600 = (max(_1595, 1.000000013351432e-10f) - max(min(min(_1585, _1588), _1591), 1.000000013351432e-10f)) / max(_1595, 0.009999999776482582f);
        float _1613 = ((_1588 + _1585) + _1591) + (sqrt((((_1591 - _1588) * _1591) + ((_1588 - _1585) * _1588)) + ((_1585 - _1591) * _1585)) * 1.75f);
        float _1614 = _1613 * 0.3333333432674408f;
        float _1615 = _1600 + -0.4000000059604645f;
        float _1616 = _1615 * 5.0f;
        float _1620 = max((1.0f - abs(_1615 * 2.5f)), 0.0f);
        float _1631 = ((float((int)(((int)(uint)((bool)(_1616 > 0.0f))) - ((int)(uint)((bool)(_1616 < 0.0f))))) * (1.0f - (_1620 * _1620))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1614 <= 0.0533333346247673f)) {
            if (!(_1614 >= 0.1599999964237213f)) {
              _1640 = (((0.23999999463558197f / _1613) + -0.5f) * _1631);
            } else {
              _1640 = 0.0f;
            }
          } else {
            _1640 = _1631;
          }
          float _1641 = _1640 + 1.0f;
          float _1642 = _1641 * _1585;
          float _1643 = _1641 * _1588;
          float _1644 = _1641 * _1591;
          do {
            if (!((bool)(_1642 == _1643) && (bool)(_1643 == _1644))) {
              float _1651 = ((_1642 * 2.0f) - _1643) - _1644;
              float _1654 = ((_1588 - _1591) * 1.7320507764816284f) * _1641;
              float _1656 = atan(_1654 / _1651);
              bool _1659 = (_1651 < 0.0f);
              bool _1660 = (_1651 == 0.0f);
              bool _1661 = (_1654 >= 0.0f);
              bool _1662 = (_1654 < 0.0f);
              float _1671 = select((_1661 && _1660), 90.0f, select((_1662 && _1660), -90.0f, (select((_1662 && _1659), (_1656 + -3.1415927410125732f), select((_1661 && _1659), (_1656 + 3.1415927410125732f), _1656)) * 57.2957763671875f)));
              if (_1671 < 0.0f) {
                _1676 = (_1671 + 360.0f);
              } else {
                _1676 = _1671;
              }
            } else {
              _1676 = 0.0f;
            }
            float _1678 = min(max(_1676, 0.0f), 360.0f);
            do {
              if (_1678 < -180.0f) {
                _1687 = (_1678 + 360.0f);
              } else {
                if (_1678 > 180.0f) {
                  _1687 = (_1678 + -360.0f);
                } else {
                  _1687 = _1678;
                }
              }
              do {
                if ((bool)(_1687 > -67.5f) && (bool)(_1687 < 67.5f)) {
                  float _1693 = (_1687 + 67.5f) * 0.029629629105329514f;
                  int _1694 = int(_1693);
                  float _1696 = _1693 - float((int)(_1694));
                  float _1697 = _1696 * _1696;
                  float _1698 = _1697 * _1696;
                  if (_1694 == 3) {
                    _1726 = (((0.1666666716337204f - (_1696 * 0.5f)) + (_1697 * 0.5f)) - (_1698 * 0.1666666716337204f));
                  } else {
                    if (_1694 == 2) {
                      _1726 = ((0.6666666865348816f - _1697) + (_1698 * 0.5f));
                    } else {
                      if (_1694 == 1) {
                        _1726 = (((_1698 * -0.5f) + 0.1666666716337204f) + ((_1697 + _1696) * 0.5f));
                      } else {
                        _1726 = select((_1694 == 0), (_1698 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1726 = 0.0f;
                }
                float _1735 = min(max(((((_1600 * 0.27000001072883606f) * (0.029999999329447746f - _1642)) * _1726) + _1642), 0.0f), 65535.0f);
                float _1736 = min(max(_1643, 0.0f), 65535.0f);
                float _1737 = min(max(_1644, 0.0f), 65535.0f);
                float _1750 = min(max(mad(-0.21492856740951538f, _1737, mad(-0.2365107536315918f, _1736, (_1735 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1751 = min(max(mad(-0.09967592358589172f, _1737, mad(1.17622971534729f, _1736, (_1735 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1752 = min(max(mad(0.9977163076400757f, _1737, mad(-0.006032449658960104f, _1736, (_1735 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1753 = dot(float3(_1750, _1751, _1752), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1764 = log2(max((lerp(_1753, _1750, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1765 = _1764 * 0.3010300099849701f;
                float _1766 = log2(cb0_008x);
                float _1767 = _1766 * 0.3010300099849701f;
                do {
                  if (!(!(_1765 <= _1767))) {
                    _1836 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1774 = log2(cb0_009x);
                    float _1775 = _1774 * 0.3010300099849701f;
                    if ((bool)(_1765 > _1767) && (bool)(_1765 < _1775)) {
                      float _1783 = ((_1764 - _1766) * 0.9030900001525879f) / ((_1774 - _1766) * 0.3010300099849701f);
                      int _1784 = int(_1783);
                      float _1786 = _1783 - float((int)(_1784));
                      float _1788 = _17[_1784];
                      float _1791 = _17[(_1784 + 1)];
                      float _1796 = _1788 * 0.5f;
                      _1836 = dot(float3((_1786 * _1786), _1786, 1.0f), float3(mad((_17[(_1784 + 2)]), 0.5f, mad(_1791, -1.0f, _1796)), (_1791 - _1788), mad(_1791, 0.5f, _1796)));
                    } else {
                      do {
                        if (!(!(_1765 >= _1775))) {
                          float _1805 = log2(cb0_008z);
                          if (_1765 < (_1805 * 0.3010300099849701f)) {
                            float _1813 = ((_1764 - _1774) * 0.9030900001525879f) / ((_1805 - _1774) * 0.3010300099849701f);
                            int _1814 = int(_1813);
                            float _1816 = _1813 - float((int)(_1814));
                            float _1818 = _18[_1814];
                            float _1821 = _18[(_1814 + 1)];
                            float _1826 = _1818 * 0.5f;
                            _1836 = dot(float3((_1816 * _1816), _1816, 1.0f), float3(mad((_18[(_1814 + 2)]), 0.5f, mad(_1821, -1.0f, _1826)), (_1821 - _1818), mad(_1821, 0.5f, _1826)));
                            break;
                          }
                        }
                        _1836 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1840 = log2(max((lerp(_1753, _1751, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1841 = _1840 * 0.3010300099849701f;
                  do {
                    if (!(!(_1841 <= _1767))) {
                      _1910 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1848 = log2(cb0_009x);
                      float _1849 = _1848 * 0.3010300099849701f;
                      if ((bool)(_1841 > _1767) && (bool)(_1841 < _1849)) {
                        float _1857 = ((_1840 - _1766) * 0.9030900001525879f) / ((_1848 - _1766) * 0.3010300099849701f);
                        int _1858 = int(_1857);
                        float _1860 = _1857 - float((int)(_1858));
                        float _1862 = _17[_1858];
                        float _1865 = _17[(_1858 + 1)];
                        float _1870 = _1862 * 0.5f;
                        _1910 = dot(float3((_1860 * _1860), _1860, 1.0f), float3(mad((_17[(_1858 + 2)]), 0.5f, mad(_1865, -1.0f, _1870)), (_1865 - _1862), mad(_1865, 0.5f, _1870)));
                      } else {
                        do {
                          if (!(!(_1841 >= _1849))) {
                            float _1879 = log2(cb0_008z);
                            if (_1841 < (_1879 * 0.3010300099849701f)) {
                              float _1887 = ((_1840 - _1848) * 0.9030900001525879f) / ((_1879 - _1848) * 0.3010300099849701f);
                              int _1888 = int(_1887);
                              float _1890 = _1887 - float((int)(_1888));
                              float _1892 = _18[_1888];
                              float _1895 = _18[(_1888 + 1)];
                              float _1900 = _1892 * 0.5f;
                              _1910 = dot(float3((_1890 * _1890), _1890, 1.0f), float3(mad((_18[(_1888 + 2)]), 0.5f, mad(_1895, -1.0f, _1900)), (_1895 - _1892), mad(_1895, 0.5f, _1900)));
                              break;
                            }
                          }
                          _1910 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1914 = log2(max((lerp(_1753, _1752, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1915 = _1914 * 0.3010300099849701f;
                    do {
                      if (!(!(_1915 <= _1767))) {
                        _1984 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1922 = log2(cb0_009x);
                        float _1923 = _1922 * 0.3010300099849701f;
                        if ((bool)(_1915 > _1767) && (bool)(_1915 < _1923)) {
                          float _1931 = ((_1914 - _1766) * 0.9030900001525879f) / ((_1922 - _1766) * 0.3010300099849701f);
                          int _1932 = int(_1931);
                          float _1934 = _1931 - float((int)(_1932));
                          float _1936 = _17[_1932];
                          float _1939 = _17[(_1932 + 1)];
                          float _1944 = _1936 * 0.5f;
                          _1984 = dot(float3((_1934 * _1934), _1934, 1.0f), float3(mad((_17[(_1932 + 2)]), 0.5f, mad(_1939, -1.0f, _1944)), (_1939 - _1936), mad(_1939, 0.5f, _1944)));
                        } else {
                          do {
                            if (!(!(_1915 >= _1923))) {
                              float _1953 = log2(cb0_008z);
                              if (_1915 < (_1953 * 0.3010300099849701f)) {
                                float _1961 = ((_1914 - _1922) * 0.9030900001525879f) / ((_1953 - _1922) * 0.3010300099849701f);
                                int _1962 = int(_1961);
                                float _1964 = _1961 - float((int)(_1962));
                                float _1966 = _18[_1962];
                                float _1969 = _18[(_1962 + 1)];
                                float _1974 = _1966 * 0.5f;
                                _1984 = dot(float3((_1964 * _1964), _1964, 1.0f), float3(mad((_18[(_1962 + 2)]), 0.5f, mad(_1969, -1.0f, _1974)), (_1969 - _1966), mad(_1969, 0.5f, _1974)));
                                break;
                              }
                            }
                            _1984 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1988 = cb0_008w - cb0_008y;
                      float _1989 = (exp2(_1836 * 3.321928024291992f) - cb0_008y) / _1988;
                      float _1991 = (exp2(_1910 * 3.321928024291992f) - cb0_008y) / _1988;
                      float _1993 = (exp2(_1984 * 3.321928024291992f) - cb0_008y) / _1988;
                      float _1996 = mad(0.15618768334388733f, _1993, mad(0.13400420546531677f, _1991, (_1989 * 0.6624541878700256f)));
                      float _1999 = mad(0.053689517080783844f, _1993, mad(0.6740817427635193f, _1991, (_1989 * 0.2722287178039551f)));
                      float _2002 = mad(1.0103391408920288f, _1993, mad(0.00406073359772563f, _1991, (_1989 * -0.005574649665504694f)));
                      float _2015 = min(max(mad(-0.23642469942569733f, _2002, mad(-0.32480329275131226f, _1999, (_1996 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2016 = min(max(mad(0.016756348311901093f, _2002, mad(1.6153316497802734f, _1999, (_1996 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2017 = min(max(mad(0.9883948564529419f, _2002, mad(-0.008284442126750946f, _1999, (_1996 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2020 = mad(0.15618768334388733f, _2017, mad(0.13400420546531677f, _2016, (_2015 * 0.6624541878700256f)));
                      float _2023 = mad(0.053689517080783844f, _2017, mad(0.6740817427635193f, _2016, (_2015 * 0.2722287178039551f)));
                      float _2026 = mad(1.0103391408920288f, _2017, mad(0.00406073359772563f, _2016, (_2015 * -0.005574649665504694f)));
                      float _2048 = min(max((min(max(mad(-0.23642469942569733f, _2026, mad(-0.32480329275131226f, _2023, (_2020 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2049 = min(max((min(max(mad(0.016756348311901093f, _2026, mad(1.6153316497802734f, _2023, (_2020 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2050 = min(max((min(max(mad(0.9883948564529419f, _2026, mad(-0.008284442126750946f, _2023, (_2020 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _2063 = mad(_55, _2050, mad(_54, _2049, (_2048 * _53)));
                          _2064 = mad(_58, _2050, mad(_57, _2049, (_2048 * _56)));
                          _2065 = mad(_61, _2050, mad(_60, _2049, (_2048 * _59)));
                        } else {
                          _2063 = _2048;
                          _2064 = _2049;
                          _2065 = _2050;
                        }
                        float _2075 = exp2(log2(_2063 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2076 = exp2(log2(_2064 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2077 = exp2(log2(_2065 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2818 = exp2(log2((1.0f / ((_2075 * 18.6875f) + 1.0f)) * ((_2075 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2819 = exp2(log2((1.0f / ((_2076 * 18.6875f) + 1.0f)) * ((_2076 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2820 = exp2(log2((1.0f / ((_2077 * 18.6875f) + 1.0f)) * ((_2077 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((output_device & -3) == 4) {
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
          float _2156 = cb0_012z * _1378;
          float _2157 = cb0_012z * _1379;
          float _2158 = cb0_012z * _1380;
          float _2161 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _2158, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _2157, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _2156)));
          float _2164 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _2158, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _2157, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _2156)));
          float _2167 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _2158, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _2157, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _2156)));
          float _2171 = max(max(_2161, _2164), _2167);
          float _2176 = (max(_2171, 1.000000013351432e-10f) - max(min(min(_2161, _2164), _2167), 1.000000013351432e-10f)) / max(_2171, 0.009999999776482582f);
          float _2189 = ((_2164 + _2161) + _2167) + (sqrt((((_2167 - _2164) * _2167) + ((_2164 - _2161) * _2164)) + ((_2161 - _2167) * _2161)) * 1.75f);
          float _2190 = _2189 * 0.3333333432674408f;
          float _2191 = _2176 + -0.4000000059604645f;
          float _2192 = _2191 * 5.0f;
          float _2196 = max((1.0f - abs(_2191 * 2.5f)), 0.0f);
          float _2207 = ((float((int)(((int)(uint)((bool)(_2192 > 0.0f))) - ((int)(uint)((bool)(_2192 < 0.0f))))) * (1.0f - (_2196 * _2196))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2190 <= 0.0533333346247673f)) {
              if (!(_2190 >= 0.1599999964237213f)) {
                _2216 = (((0.23999999463558197f / _2189) + -0.5f) * _2207);
              } else {
                _2216 = 0.0f;
              }
            } else {
              _2216 = _2207;
            }
            float _2217 = _2216 + 1.0f;
            float _2218 = _2217 * _2161;
            float _2219 = _2217 * _2164;
            float _2220 = _2217 * _2167;
            do {
              if (!((bool)(_2218 == _2219) && (bool)(_2219 == _2220))) {
                float _2227 = ((_2218 * 2.0f) - _2219) - _2220;
                float _2230 = ((_2164 - _2167) * 1.7320507764816284f) * _2217;
                float _2232 = atan(_2230 / _2227);
                bool _2235 = (_2227 < 0.0f);
                bool _2236 = (_2227 == 0.0f);
                bool _2237 = (_2230 >= 0.0f);
                bool _2238 = (_2230 < 0.0f);
                float _2247 = select((_2237 && _2236), 90.0f, select((_2238 && _2236), -90.0f, (select((_2238 && _2235), (_2232 + -3.1415927410125732f), select((_2237 && _2235), (_2232 + 3.1415927410125732f), _2232)) * 57.2957763671875f)));
                if (_2247 < 0.0f) {
                  _2252 = (_2247 + 360.0f);
                } else {
                  _2252 = _2247;
                }
              } else {
                _2252 = 0.0f;
              }
              float _2254 = min(max(_2252, 0.0f), 360.0f);
              do {
                if (_2254 < -180.0f) {
                  _2263 = (_2254 + 360.0f);
                } else {
                  if (_2254 > 180.0f) {
                    _2263 = (_2254 + -360.0f);
                  } else {
                    _2263 = _2254;
                  }
                }
                do {
                  if ((bool)(_2263 > -67.5f) && (bool)(_2263 < 67.5f)) {
                    float _2269 = (_2263 + 67.5f) * 0.029629629105329514f;
                    int _2270 = int(_2269);
                    float _2272 = _2269 - float((int)(_2270));
                    float _2273 = _2272 * _2272;
                    float _2274 = _2273 * _2272;
                    if (_2270 == 3) {
                      _2302 = (((0.1666666716337204f - (_2272 * 0.5f)) + (_2273 * 0.5f)) - (_2274 * 0.1666666716337204f));
                    } else {
                      if (_2270 == 2) {
                        _2302 = ((0.6666666865348816f - _2273) + (_2274 * 0.5f));
                      } else {
                        if (_2270 == 1) {
                          _2302 = (((_2274 * -0.5f) + 0.1666666716337204f) + ((_2273 + _2272) * 0.5f));
                        } else {
                          _2302 = select((_2270 == 0), (_2274 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2302 = 0.0f;
                  }
                  float _2311 = min(max(((((_2176 * 0.27000001072883606f) * (0.029999999329447746f - _2218)) * _2302) + _2218), 0.0f), 65535.0f);
                  float _2312 = min(max(_2219, 0.0f), 65535.0f);
                  float _2313 = min(max(_2220, 0.0f), 65535.0f);
                  float _2326 = min(max(mad(-0.21492856740951538f, _2313, mad(-0.2365107536315918f, _2312, (_2311 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2327 = min(max(mad(-0.09967592358589172f, _2313, mad(1.17622971534729f, _2312, (_2311 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2328 = min(max(mad(0.9977163076400757f, _2313, mad(-0.006032449658960104f, _2312, (_2311 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2329 = dot(float3(_2326, _2327, _2328), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2340 = log2(max((lerp(_2329, _2326, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2341 = _2340 * 0.3010300099849701f;
                  float _2342 = log2(cb0_008x);
                  float _2343 = _2342 * 0.3010300099849701f;
                  do {
                    if (!(!(_2341 <= _2343))) {
                      _2412 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2350 = log2(cb0_009x);
                      float _2351 = _2350 * 0.3010300099849701f;
                      if ((bool)(_2341 > _2343) && (bool)(_2341 < _2351)) {
                        float _2359 = ((_2340 - _2342) * 0.9030900001525879f) / ((_2350 - _2342) * 0.3010300099849701f);
                        int _2360 = int(_2359);
                        float _2362 = _2359 - float((int)(_2360));
                        float _2364 = _15[_2360];
                        float _2367 = _15[(_2360 + 1)];
                        float _2372 = _2364 * 0.5f;
                        _2412 = dot(float3((_2362 * _2362), _2362, 1.0f), float3(mad((_15[(_2360 + 2)]), 0.5f, mad(_2367, -1.0f, _2372)), (_2367 - _2364), mad(_2367, 0.5f, _2372)));
                      } else {
                        do {
                          if (!(!(_2341 >= _2351))) {
                            float _2381 = log2(cb0_008z);
                            if (_2341 < (_2381 * 0.3010300099849701f)) {
                              float _2389 = ((_2340 - _2350) * 0.9030900001525879f) / ((_2381 - _2350) * 0.3010300099849701f);
                              int _2390 = int(_2389);
                              float _2392 = _2389 - float((int)(_2390));
                              float _2394 = _16[_2390];
                              float _2397 = _16[(_2390 + 1)];
                              float _2402 = _2394 * 0.5f;
                              _2412 = dot(float3((_2392 * _2392), _2392, 1.0f), float3(mad((_16[(_2390 + 2)]), 0.5f, mad(_2397, -1.0f, _2402)), (_2397 - _2394), mad(_2397, 0.5f, _2402)));
                              break;
                            }
                          }
                          _2412 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2416 = log2(max((lerp(_2329, _2327, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2417 = _2416 * 0.3010300099849701f;
                    do {
                      if (!(!(_2417 <= _2343))) {
                        _2486 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2424 = log2(cb0_009x);
                        float _2425 = _2424 * 0.3010300099849701f;
                        if ((bool)(_2417 > _2343) && (bool)(_2417 < _2425)) {
                          float _2433 = ((_2416 - _2342) * 0.9030900001525879f) / ((_2424 - _2342) * 0.3010300099849701f);
                          int _2434 = int(_2433);
                          float _2436 = _2433 - float((int)(_2434));
                          float _2438 = _15[_2434];
                          float _2441 = _15[(_2434 + 1)];
                          float _2446 = _2438 * 0.5f;
                          _2486 = dot(float3((_2436 * _2436), _2436, 1.0f), float3(mad((_15[(_2434 + 2)]), 0.5f, mad(_2441, -1.0f, _2446)), (_2441 - _2438), mad(_2441, 0.5f, _2446)));
                        } else {
                          do {
                            if (!(!(_2417 >= _2425))) {
                              float _2455 = log2(cb0_008z);
                              if (_2417 < (_2455 * 0.3010300099849701f)) {
                                float _2463 = ((_2416 - _2424) * 0.9030900001525879f) / ((_2455 - _2424) * 0.3010300099849701f);
                                int _2464 = int(_2463);
                                float _2466 = _2463 - float((int)(_2464));
                                float _2468 = _16[_2464];
                                float _2471 = _16[(_2464 + 1)];
                                float _2476 = _2468 * 0.5f;
                                _2486 = dot(float3((_2466 * _2466), _2466, 1.0f), float3(mad((_16[(_2464 + 2)]), 0.5f, mad(_2471, -1.0f, _2476)), (_2471 - _2468), mad(_2471, 0.5f, _2476)));
                                break;
                              }
                            }
                            _2486 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2490 = log2(max((lerp(_2329, _2328, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2491 = _2490 * 0.3010300099849701f;
                      do {
                        if (!(!(_2491 <= _2343))) {
                          _2560 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2498 = log2(cb0_009x);
                          float _2499 = _2498 * 0.3010300099849701f;
                          if ((bool)(_2491 > _2343) && (bool)(_2491 < _2499)) {
                            float _2507 = ((_2490 - _2342) * 0.9030900001525879f) / ((_2498 - _2342) * 0.3010300099849701f);
                            int _2508 = int(_2507);
                            float _2510 = _2507 - float((int)(_2508));
                            float _2512 = _15[_2508];
                            float _2515 = _15[(_2508 + 1)];
                            float _2520 = _2512 * 0.5f;
                            _2560 = dot(float3((_2510 * _2510), _2510, 1.0f), float3(mad((_15[(_2508 + 2)]), 0.5f, mad(_2515, -1.0f, _2520)), (_2515 - _2512), mad(_2515, 0.5f, _2520)));
                          } else {
                            do {
                              if (!(!(_2491 >= _2499))) {
                                float _2529 = log2(cb0_008z);
                                if (_2491 < (_2529 * 0.3010300099849701f)) {
                                  float _2537 = ((_2490 - _2498) * 0.9030900001525879f) / ((_2529 - _2498) * 0.3010300099849701f);
                                  int _2538 = int(_2537);
                                  float _2540 = _2537 - float((int)(_2538));
                                  float _2542 = _16[_2538];
                                  float _2545 = _16[(_2538 + 1)];
                                  float _2550 = _2542 * 0.5f;
                                  _2560 = dot(float3((_2540 * _2540), _2540, 1.0f), float3(mad((_16[(_2538 + 2)]), 0.5f, mad(_2545, -1.0f, _2550)), (_2545 - _2542), mad(_2545, 0.5f, _2550)));
                                  break;
                                }
                              }
                              _2560 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2564 = cb0_008w - cb0_008y;
                        float _2565 = (exp2(_2412 * 3.321928024291992f) - cb0_008y) / _2564;
                        float _2567 = (exp2(_2486 * 3.321928024291992f) - cb0_008y) / _2564;
                        float _2569 = (exp2(_2560 * 3.321928024291992f) - cb0_008y) / _2564;
                        float _2572 = mad(0.15618768334388733f, _2569, mad(0.13400420546531677f, _2567, (_2565 * 0.6624541878700256f)));
                        float _2575 = mad(0.053689517080783844f, _2569, mad(0.6740817427635193f, _2567, (_2565 * 0.2722287178039551f)));
                        float _2578 = mad(1.0103391408920288f, _2569, mad(0.00406073359772563f, _2567, (_2565 * -0.005574649665504694f)));
                        float _2591 = min(max(mad(-0.23642469942569733f, _2578, mad(-0.32480329275131226f, _2575, (_2572 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2592 = min(max(mad(0.016756348311901093f, _2578, mad(1.6153316497802734f, _2575, (_2572 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2593 = min(max(mad(0.9883948564529419f, _2578, mad(-0.008284442126750946f, _2575, (_2572 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2596 = mad(0.15618768334388733f, _2593, mad(0.13400420546531677f, _2592, (_2591 * 0.6624541878700256f)));
                        float _2599 = mad(0.053689517080783844f, _2593, mad(0.6740817427635193f, _2592, (_2591 * 0.2722287178039551f)));
                        float _2602 = mad(1.0103391408920288f, _2593, mad(0.00406073359772563f, _2592, (_2591 * -0.005574649665504694f)));
                        float _2624 = min(max((min(max(mad(-0.23642469942569733f, _2602, mad(-0.32480329275131226f, _2599, (_2596 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2625 = min(max((min(max(mad(0.016756348311901093f, _2602, mad(1.6153316497802734f, _2599, (_2596 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2626 = min(max((min(max(mad(0.9883948564529419f, _2602, mad(-0.008284442126750946f, _2599, (_2596 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2639 = mad(_55, _2626, mad(_54, _2625, (_2624 * _53)));
                            _2640 = mad(_58, _2626, mad(_57, _2625, (_2624 * _56)));
                            _2641 = mad(_61, _2626, mad(_60, _2625, (_2624 * _59)));
                          } else {
                            _2639 = _2624;
                            _2640 = _2625;
                            _2641 = _2626;
                          }
                          float _2651 = exp2(log2(_2639 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2652 = exp2(log2(_2640 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2653 = exp2(log2(_2641 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2818 = exp2(log2((1.0f / ((_2651 * 18.6875f) + 1.0f)) * ((_2651 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2819 = exp2(log2((1.0f / ((_2652 * 18.6875f) + 1.0f)) * ((_2652 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2820 = exp2(log2((1.0f / ((_2653 * 18.6875f) + 1.0f)) * ((_2653 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (output_device == 7) {
            float _2698 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1380, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1379, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1378)));
            float _2701 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1380, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1379, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1378)));
            float _2704 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1380, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1379, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1378)));
            float _2723 = exp2(log2(mad(_55, _2704, mad(_54, _2701, (_2698 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2724 = exp2(log2(mad(_58, _2704, mad(_57, _2701, (_2698 * _56))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2725 = exp2(log2(mad(_61, _2704, mad(_60, _2701, (_2698 * _59))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2818 = exp2(log2((1.0f / ((_2723 * 18.6875f) + 1.0f)) * ((_2723 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2819 = exp2(log2((1.0f / ((_2724 * 18.6875f) + 1.0f)) * ((_2724 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2820 = exp2(log2((1.0f / ((_2725 * 18.6875f) + 1.0f)) * ((_2725 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2772 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1368, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1367, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1366)));
                float _2775 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1368, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1367, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1366)));
                float _2778 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1368, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1367, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1366)));
                _2818 = mad(_55, _2778, mad(_54, _2775, (_2772 * _53)));
                _2819 = mad(_58, _2778, mad(_57, _2775, (_2772 * _56)));
                _2820 = mad(_61, _2778, mad(_60, _2775, (_2772 * _59)));
              } else {
                float _2791 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1392)));
                float _2794 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1392)));
                float _2797 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1394, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1393, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1392)));
                _2818 = exp2(log2(mad(_55, _2797, mad(_54, _2794, (_2791 * _53)))) * cb0_040z);
                _2819 = exp2(log2(mad(_58, _2797, mad(_57, _2794, (_2791 * _56)))) * cb0_040z);
                _2820 = exp2(log2(mad(_61, _2797, mad(_60, _2794, (_2791 * _59)))) * cb0_040z);
              }
            } else {
              _2818 = _1378;
              _2819 = _1379;
              _2820 = _1380;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2818 * 0.9523810148239136f), (_2819 * 0.9523810148239136f), (_2820 * 0.9523810148239136f), 0.0f);
}
