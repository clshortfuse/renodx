#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
//   float cb0_005z : packoffset(c005.z);
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
  float _26 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _27 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _30 = float((uint)SV_DispatchThreadID.z);
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _117;
  float _118;
  float _119;
  float _168;
  float _897;
  float _933;
  float _944;
  float _1008;
  float _1187;
  float _1198;
  float _1209;
  float _1406;
  float _1407;
  float _1408;
  float _1419;
  float _1430;
  float _1612;
  float _1648;
  float _1659;
  float _1698;
  float _1808;
  float _1882;
  float _1956;
  float _2035;
  float _2036;
  float _2037;
  float _2188;
  float _2224;
  float _2235;
  float _2274;
  float _2384;
  float _2458;
  float _2532;
  float _2611;
  float _2612;
  float _2613;
  float _2790;
  float _2791;
  float _2792;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _40 = (output_gamut == 4);
        _51 = select(_40, 1.0f, 1.7050515413284302f);
        _52 = select(_40, 0.0f, -0.6217905879020691f);
        _53 = select(_40, 0.0f, -0.0832584798336029f);
        _54 = select(_40, 0.0f, -0.13025718927383423f);
        _55 = select(_40, 1.0f, 1.1408027410507202f);
        _56 = select(_40, 0.0f, -0.010548528283834457f);
        _57 = select(_40, 0.0f, -0.024003278464078903f);
        _58 = select(_40, 0.0f, -0.1289687603712082f);
        _59 = select(_40, 1.0f, 1.152971863746643f);
      } else {
        _51 = 0.6954522132873535f;
        _52 = 0.14067870378494263f;
        _53 = 0.16386906802654266f;
        _54 = 0.044794563204050064f;
        _55 = 0.8596711158752441f;
        _56 = 0.0955343171954155f;
        _57 = -0.005525882821530104f;
        _58 = 0.004025210160762072f;
        _59 = 1.0015007257461548f;
      }
    } else {
      _51 = 1.02579927444458f;
      _52 = -0.020052503794431686f;
      _53 = -0.0057713985443115234f;
      _54 = -0.0022350111976265907f;
      _55 = 1.0045825242996216f;
      _56 = -0.002352306619286537f;
      _57 = -0.005014004185795784f;
      _58 = -0.025293385609984398f;
      _59 = 1.0304402112960815f;
    }
  } else {
    _51 = 1.379158854484558f;
    _52 = -0.3088507056236267f;
    _53 = -0.07034677267074585f;
    _54 = -0.06933528929948807f;
    _55 = 1.0822921991348267f;
    _56 = -0.012962047010660172f;
    _57 = -0.002159259282052517f;
    _58 = -0.045465391129255295f;
    _59 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _70 = exp2(log2(_26 * 1.0322580337524414f) * 0.012683313339948654f);
    float _71 = exp2(log2(_27 * 1.0322580337524414f) * 0.012683313339948654f);
    float _72 = exp2(log2(_30 * 0.032258063554763794f) * 0.012683313339948654f);
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _118 = (exp2(log2(max(0.0f, (_71 + -0.8359375f)) / (18.8515625f - (_71 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _119 = (exp2(log2(max(0.0f, (_72 + -0.8359375f)) / (18.8515625f - (_72 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _117 = ((exp2((_26 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _118 = ((exp2((_27 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _119 = ((exp2((_30 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  bool _146 = (cb0_038z != 0);
  float _151 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _168 = (((((2967800.0f - (_151 * 4607000064.0f)) * _151) + 99.11000061035156f) * _151) + 0.24406300485134125f);
  } else {
    _168 = (((((1901800.0f - (_151 * 2006400000.0f)) * _151) + 247.47999572753906f) * _151) + 0.23703999817371368f);
  }
  float _182 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _189 = cb0_035x * cb0_035x;
  float _192 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_189 * 1.6145605741257896e-07f));
  float _197 = ((_182 * 2.0f) + 4.0f) - (_192 * 8.0f);
  float _198 = (_182 * 3.0f) / _197;
  float _200 = (_192 * 2.0f) / _197;
  bool _201 = (cb0_035x < 4000.0f);
  float _210 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _212 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_189 * 1.5317699909210205f)) / (_210 * _210);
  float _219 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _189;
  float _221 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_189 * 308.60699462890625f)) / (_219 * _219);
  float _223 = rsqrt(dot(float2(_212, _221), float2(_212, _221)));
  float _224 = cb0_035y * 0.05000000074505806f;
  float _227 = ((_224 * _221) * _223) + _182;
  float _230 = _192 - ((_224 * _212) * _223);
  float _235 = (4.0f - (_230 * 8.0f)) + (_227 * 2.0f);
  float _241 = (((_227 * 3.0f) / _235) - _198) + select(_201, _198, _168);
  float _242 = (((_230 * 2.0f) / _235) - _200) + select(_201, _200, (((_168 * 2.869999885559082f) + -0.2750000059604645f) - ((_168 * _168) * 3.0f)));
  float _243 = select(_146, _241, 0.3127000033855438f);
  float _244 = select(_146, _242, 0.32899999618530273f);
  float _245 = select(_146, 0.3127000033855438f, _241);
  float _246 = select(_146, 0.32899999618530273f, _242);
  float _247 = max(_244, 1.000000013351432e-10f);
  float _248 = _243 / _247;
  float _251 = ((1.0f - _243) - _244) / _247;
  float _252 = max(_246, 1.000000013351432e-10f);
  float _253 = _245 / _252;
  float _256 = ((1.0f - _245) - _246) / _252;
  float _275 = mad(-0.16140000522136688f, _256, ((_253 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _251, ((_248 * 0.8950999975204468f) + 0.266400009393692f));
  float _276 = mad(0.03669999912381172f, _256, (1.7135000228881836f - (_253 * 0.7501999735832214f))) / mad(0.03669999912381172f, _251, (1.7135000228881836f - (_248 * 0.7501999735832214f)));
  float _277 = mad(1.0296000242233276f, _256, ((_253 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _251, ((_248 * 0.03889999911189079f) + -0.06849999725818634f));
  float _278 = mad(_276, -0.7501999735832214f, 0.0f);
  float _279 = mad(_276, 1.7135000228881836f, 0.0f);
  float _280 = mad(_276, 0.03669999912381172f, -0.0f);
  float _281 = mad(_277, 0.03889999911189079f, 0.0f);
  float _282 = mad(_277, -0.06849999725818634f, 0.0f);
  float _283 = mad(_277, 1.0296000242233276f, 0.0f);
  float _286 = mad(0.1599626988172531f, _281, mad(-0.1470542997121811f, _278, (_275 * 0.883457362651825f)));
  float _289 = mad(0.1599626988172531f, _282, mad(-0.1470542997121811f, _279, (_275 * 0.26293492317199707f)));
  float _292 = mad(0.1599626988172531f, _283, mad(-0.1470542997121811f, _280, (_275 * -0.15930065512657166f)));
  float _295 = mad(0.04929120093584061f, _281, mad(0.5183603167533875f, _278, (_275 * 0.38695648312568665f)));
  float _298 = mad(0.04929120093584061f, _282, mad(0.5183603167533875f, _279, (_275 * 0.11516613513231277f)));
  float _301 = mad(0.04929120093584061f, _283, mad(0.5183603167533875f, _280, (_275 * -0.0697740763425827f)));
  float _304 = mad(0.9684867262840271f, _281, mad(0.04004279896616936f, _278, (_275 * -0.007634039502590895f)));
  float _307 = mad(0.9684867262840271f, _282, mad(0.04004279896616936f, _279, (_275 * -0.0022720457054674625f)));
  float _310 = mad(0.9684867262840271f, _283, mad(0.04004279896616936f, _280, (_275 * 0.0013765322510153055f)));
  float _313 = mad(_292, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_289, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_286 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _316 = mad(_292, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_289, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_286 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _319 = mad(_292, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_289, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_286 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _322 = mad(_301, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_298, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_295 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _325 = mad(_301, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_298, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_295 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _328 = mad(_301, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_298, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_295 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _331 = mad(_310, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_307, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_304 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _334 = mad(_310, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_307, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_304 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _337 = mad(_310, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_307, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_304 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _367 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _337, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _328, (_319 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _119, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _334, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _325, (_316 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _118, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _331, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _322, (_313 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _117)));
  float _370 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _337, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _328, (_319 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _119, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _334, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _325, (_316 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _118, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _331, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _322, (_313 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _117)));
  float _373 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _337, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _328, (_319 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _119, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _334, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _325, (_316 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _118, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _331, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _322, (_313 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _117)));
  float _388 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _373, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _370, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _367)));
  float _391 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _373, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _370, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _367)));
  float _394 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _373, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _370, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _367)));
  float _395 = dot(float3(_388, _391, _394), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _399 = (_388 / _395) + -1.0f;
  float _400 = (_391 / _395) + -1.0f;
  float _401 = (_394 / _395) + -1.0f;
  float _413 = (1.0f - exp2(((_395 * _395) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_399, _400, _401), float3(_399, _400, _401)) * -4.0f));
  float _429 = ((mad(-0.06368283927440643f, _394, mad(-0.32929131388664246f, _391, (_388 * 1.370412826538086f))) - _388) * _413) + _388;
  float _430 = ((mad(-0.010861567221581936f, _394, mad(1.0970908403396606f, _391, (_388 * -0.08343426138162613f))) - _391) * _413) + _391;
  float _431 = ((mad(1.203694462776184f, _394, mad(-0.09862564504146576f, _391, (_388 * -0.02579325996339321f))) - _394) * _413) + _394;
  float _432 = dot(float3(_429, _430, _431), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _446 = cb0_019w + cb0_024w;
  float _460 = cb0_018w * cb0_023w;
  float _474 = cb0_017w * cb0_022w;
  float _488 = cb0_016w * cb0_021w;
  float _502 = cb0_015w * cb0_020w;
  float _506 = _429 - _432;
  float _507 = _430 - _432;
  float _508 = _431 - _432;
  float _565 = saturate(_432 / cb0_035z);
  float _569 = (_565 * _565) * (3.0f - (_565 * 2.0f));
  float _570 = 1.0f - _569;
  float _579 = cb0_019w + cb0_034w;
  float _588 = cb0_018w * cb0_033w;
  float _597 = cb0_017w * cb0_032w;
  float _606 = cb0_016w * cb0_031w;
  float _615 = cb0_015w * cb0_030w;
  float _679 = saturate((_432 - cb0_035w) / (cb0_036x - cb0_035w));
  float _683 = (_679 * _679) * (3.0f - (_679 * 2.0f));
  float _692 = cb0_019w + cb0_029w;
  float _701 = cb0_018w * cb0_028w;
  float _710 = cb0_017w * cb0_027w;
  float _719 = cb0_016w * cb0_026w;
  float _728 = cb0_015w * cb0_025w;
  float _786 = _569 - _683;
  float _797 = ((_683 * (((cb0_019x + cb0_034x) + _579) + (((cb0_018x * cb0_033x) * _588) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _606) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _615) * _506) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _597)))))) + (_570 * (((cb0_019x + cb0_024x) + _446) + (((cb0_018x * cb0_023x) * _460) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _488) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _502) * _506) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _474))))))) + ((((cb0_019x + cb0_029x) + _692) + (((cb0_018x * cb0_028x) * _701) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _719) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _728) * _506) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _710))))) * _786);
  float _799 = ((_683 * (((cb0_019y + cb0_034y) + _579) + (((cb0_018y * cb0_033y) * _588) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _606) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _615) * _507) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _597)))))) + (_570 * (((cb0_019y + cb0_024y) + _446) + (((cb0_018y * cb0_023y) * _460) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _488) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _502) * _507) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _474))))))) + ((((cb0_019y + cb0_029y) + _692) + (((cb0_018y * cb0_028y) * _701) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _719) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _728) * _507) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _710))))) * _786);
  float _801 = ((_683 * (((cb0_019z + cb0_034z) + _579) + (((cb0_018z * cb0_033z) * _588) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _606) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _615) * _508) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _597)))))) + (_570 * (((cb0_019z + cb0_024z) + _446) + (((cb0_018z * cb0_023z) * _460) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _488) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _502) * _508) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _474))))))) + ((((cb0_019z + cb0_029z) + _692) + (((cb0_018z * cb0_028z) * _701) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _719) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _728) * _508) + _432)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _710))))) * _786);
  float _837 = ((mad(0.061360642313957214f, _801, mad(-4.540197551250458e-09f, _799, (_797 * 0.9386394023895264f))) - _797) * cb0_036y) + _797;
  float _838 = ((mad(0.169205904006958f, _801, mad(0.8307942152023315f, _799, (_797 * 6.775371730327606e-08f))) - _799) * cb0_036y) + _799;
  float _839 = (mad(-2.3283064365386963e-10f, _799, (_797 * -9.313225746154785e-10f)) * cb0_036y) + _801;
  float _842 = mad(0.16386905312538147f, _839, mad(0.14067868888378143f, _838, (_837 * 0.6954522132873535f)));
  float _845 = mad(0.0955343246459961f, _839, mad(0.8596711158752441f, _838, (_837 * 0.044794581830501556f)));
  float _848 = mad(1.0015007257461548f, _839, mad(0.004025210160762072f, _838, (_837 * -0.005525882821530104f)));
  float _852 = max(max(_842, _845), _848);
  float _857 = (max(_852, 1.000000013351432e-10f) - max(min(min(_842, _845), _848), 1.000000013351432e-10f)) / max(_852, 0.009999999776482582f);
  float _870 = ((_845 + _842) + _848) + (sqrt((((_848 - _845) * _848) + ((_845 - _842) * _845)) + ((_842 - _848) * _842)) * 1.75f);
  float _871 = _870 * 0.3333333432674408f;
  float _872 = _857 + -0.4000000059604645f;
  float _873 = _872 * 5.0f;
  float _877 = max((1.0f - abs(_872 * 2.5f)), 0.0f);
  float _888 = ((float((int)(((int)(uint)((bool)(_873 > 0.0f))) - ((int)(uint)((bool)(_873 < 0.0f))))) * (1.0f - (_877 * _877))) + 1.0f) * 0.02500000037252903f;
  if (!(_871 <= 0.0533333346247673f)) {
    if (!(_871 >= 0.1599999964237213f)) {
      _897 = (((0.23999999463558197f / _870) + -0.5f) * _888);
    } else {
      _897 = 0.0f;
    }
  } else {
    _897 = _888;
  }
  float _898 = _897 + 1.0f;
  float _899 = _898 * _842;
  float _900 = _898 * _845;
  float _901 = _898 * _848;
  if (!((bool)(_899 == _900) && (bool)(_900 == _901))) {
    float _908 = ((_899 * 2.0f) - _900) - _901;
    float _911 = ((_845 - _848) * 1.7320507764816284f) * _898;
    float _913 = atan(_911 / _908);
    bool _916 = (_908 < 0.0f);
    bool _917 = (_908 == 0.0f);
    bool _918 = (_911 >= 0.0f);
    bool _919 = (_911 < 0.0f);
    float _928 = select((_918 && _917), 90.0f, select((_919 && _917), -90.0f, (select((_919 && _916), (_913 + -3.1415927410125732f), select((_918 && _916), (_913 + 3.1415927410125732f), _913)) * 57.2957763671875f)));
    if (_928 < 0.0f) {
      _933 = (_928 + 360.0f);
    } else {
      _933 = _928;
    }
  } else {
    _933 = 0.0f;
  }
  float _935 = min(max(_933, 0.0f), 360.0f);
  if (_935 < -180.0f) {
    _944 = (_935 + 360.0f);
  } else {
    if (_935 > 180.0f) {
      _944 = (_935 + -360.0f);
    } else {
      _944 = _935;
    }
  }
  float _948 = saturate(1.0f - abs(_944 * 0.014814814552664757f));
  float _952 = (_948 * _948) * (3.0f - (_948 * 2.0f));
  float _958 = ((_952 * _952) * ((_857 * 0.18000000715255737f) * (0.029999999329447746f - _899))) + _899;
  float _968 = max(0.0f, mad(-0.21492856740951538f, _901, mad(-0.2365107536315918f, _900, (_958 * 1.4514392614364624f))));
  float _969 = max(0.0f, mad(-0.09967592358589172f, _901, mad(1.17622971534729f, _900, (_958 * -0.07655377686023712f))));
  float _970 = max(0.0f, mad(0.9977163076400757f, _901, mad(-0.006032449658960104f, _900, (_958 * 0.008316148072481155f))));
  float _971 = dot(float3(_968, _969, _970), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _985 = (cb0_037w + 1.0f) - cb0_037y;
  float _988 = cb0_038x + 1.0f;
  float _990 = _988 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _1008 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _999 = (cb0_037w + 0.18000000715255737f) / _985;
    _1008 = (-0.7447274923324585f - ((log2(_999 / (2.0f - _999)) * 0.3465735912322998f) * (_985 / cb0_037x)));
  }
  float _1011 = ((1.0f - cb0_037y) / cb0_037x) - _1008;
  float _1013 = (cb0_037z / cb0_037x) - _1011;
  float _1017 = log2(lerp(_971, _968, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1018 = log2(lerp(_971, _969, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1019 = log2(lerp(_971, _970, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1023 = cb0_037x * (_1017 + _1011);
  float _1024 = cb0_037x * (_1018 + _1011);
  float _1025 = cb0_037x * (_1019 + _1011);
  float _1026 = _985 * 2.0f;
  float _1028 = (cb0_037x * -2.0f) / _985;
  float _1029 = _1017 - _1008;
  float _1030 = _1018 - _1008;
  float _1031 = _1019 - _1008;
  float _1050 = _990 * 2.0f;
  float _1052 = (cb0_037x * 2.0f) / _990;
  float _1077 = select((_1017 < _1008), ((_1026 / (exp2((_1029 * 1.4426950216293335f) * _1028) + 1.0f)) - cb0_037w), _1023);
  float _1078 = select((_1018 < _1008), ((_1026 / (exp2((_1030 * 1.4426950216293335f) * _1028) + 1.0f)) - cb0_037w), _1024);
  float _1079 = select((_1019 < _1008), ((_1026 / (exp2((_1031 * 1.4426950216293335f) * _1028) + 1.0f)) - cb0_037w), _1025);
  float _1086 = _1013 - _1008;
  float _1090 = saturate(_1029 / _1086);
  float _1091 = saturate(_1030 / _1086);
  float _1092 = saturate(_1031 / _1086);
  bool _1093 = (_1013 < _1008);
  float _1097 = select(_1093, (1.0f - _1090), _1090);
  float _1098 = select(_1093, (1.0f - _1091), _1091);
  float _1099 = select(_1093, (1.0f - _1092), _1092);
  float _1118 = (((_1097 * _1097) * (select((_1017 > _1013), (_988 - (_1050 / (exp2(((_1017 - _1013) * 1.4426950216293335f) * _1052) + 1.0f))), _1023) - _1077)) * (3.0f - (_1097 * 2.0f))) + _1077;
  float _1119 = (((_1098 * _1098) * (select((_1018 > _1013), (_988 - (_1050 / (exp2(((_1018 - _1013) * 1.4426950216293335f) * _1052) + 1.0f))), _1024) - _1078)) * (3.0f - (_1098 * 2.0f))) + _1078;
  float _1120 = (((_1099 * _1099) * (select((_1019 > _1013), (_988 - (_1050 / (exp2(((_1019 - _1013) * 1.4426950216293335f) * _1052) + 1.0f))), _1025) - _1079)) * (3.0f - (_1099 * 2.0f))) + _1079;
  float _1121 = dot(float3(_1118, _1119, _1120), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1141 = (cb0_036w * (max(0.0f, (lerp(_1121, _1118, 0.9300000071525574f))) - _837)) + _837;
  float _1142 = (cb0_036w * (max(0.0f, (lerp(_1121, _1119, 0.9300000071525574f))) - _838)) + _838;
  float _1143 = (cb0_036w * (max(0.0f, (lerp(_1121, _1120, 0.9300000071525574f))) - _839)) + _839;
  float _1159 = ((mad(-0.06537103652954102f, _1143, mad(1.451815478503704e-06f, _1142, (_1141 * 1.065374732017517f))) - _1141) * cb0_036y) + _1141;
  float _1160 = ((mad(-0.20366770029067993f, _1143, mad(1.2036634683609009f, _1142, (_1141 * -2.57161445915699e-07f))) - _1142) * cb0_036y) + _1142;
  float _1161 = ((mad(0.9999996423721313f, _1143, mad(2.0954757928848267e-08f, _1142, (_1141 * 1.862645149230957e-08f))) - _1143) * cb0_036y) + _1143;
  float _1174 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1161, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1160, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1159)))));
  float _1175 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1161, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1160, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1159)))));
  float _1176 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1161, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1160, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1159)))));
  if (_1174 < 0.0031306699384003878f) {
    _1187 = (_1174 * 12.920000076293945f);
  } else {
    _1187 = (((pow(_1174, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1175 < 0.0031306699384003878f) {
    _1198 = (_1175 * 12.920000076293945f);
  } else {
    _1198 = (((pow(_1175, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1176 < 0.0031306699384003878f) {
    _1209 = (_1176 * 12.920000076293945f);
  } else {
    _1209 = (((pow(_1176, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1213 = (_1198 * 0.9375f) + 0.03125f;
  float _1220 = _1209 * 15.0f;
  float _1221 = floor(_1220);
  float _1222 = _1220 - _1221;
  float _1224 = (_1221 + ((_1187 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1227 = t0.SampleLevel(s0, float2(_1224, _1213), 0.0f);
  float _1231 = _1224 + 0.0625f;
  float4 _1232 = t0.SampleLevel(s0, float2(_1231, _1213), 0.0f);
  float4 _1254 = t1.SampleLevel(s1, float2(_1224, _1213), 0.0f);
  float4 _1258 = t1.SampleLevel(s1, float2(_1231, _1213), 0.0f);
  float _1277 = max(6.103519990574569e-05f, ((((lerp(_1227.x, _1232.x, _1222))*cb0_005y) + (cb0_005x * _1187)) + ((lerp(_1254.x, _1258.x, _1222))*cb0_005z)));
  float _1278 = max(6.103519990574569e-05f, ((((lerp(_1227.y, _1232.y, _1222))*cb0_005y) + (cb0_005x * _1198)) + ((lerp(_1254.y, _1258.y, _1222))*cb0_005z)));
  float _1279 = max(6.103519990574569e-05f, ((((lerp(_1227.z, _1232.z, _1222))*cb0_005y) + (cb0_005x * _1209)) + ((lerp(_1254.z, _1258.z, _1222))*cb0_005z)));
  float _1301 = select((_1277 > 0.040449999272823334f), exp2(log2((_1277 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1277 * 0.07739938050508499f));
  float _1302 = select((_1278 > 0.040449999272823334f), exp2(log2((_1278 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1278 * 0.07739938050508499f));
  float _1303 = select((_1279 > 0.040449999272823334f), exp2(log2((_1279 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1279 * 0.07739938050508499f));
  float _1329 = cb0_014x * (((cb0_039y + (cb0_039x * _1301)) * _1301) + cb0_039z);
  float _1330 = cb0_014y * (((cb0_039y + (cb0_039x * _1302)) * _1302) + cb0_039z);
  float _1331 = cb0_014z * (((cb0_039y + (cb0_039x * _1303)) * _1303) + cb0_039z);
  float _1338 = ((cb0_013x - _1329) * cb0_013w) + _1329;
  float _1339 = ((cb0_013y - _1330) * cb0_013w) + _1330;
  float _1340 = ((cb0_013z - _1331) * cb0_013w) + _1331;
  float _1341 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _801, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _799, (_797 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1342 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _801, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _799, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _797)));
  float _1343 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _801, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _799, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _797)));
  float _1350 = ((cb0_013x - _1341) * cb0_013w) + _1341;
  float _1351 = ((cb0_013y - _1342) * cb0_013w) + _1342;
  float _1352 = ((cb0_013z - _1343) * cb0_013w) + _1343;
  float _1364 = exp2(log2(max(0.0f, _1338)) * cb0_040y);
  float _1365 = exp2(log2(max(0.0f, _1339)) * cb0_040y);
  float _1366 = exp2(log2(max(0.0f, _1340)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1389 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1364)));
        float _1392 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1364)));
        float _1395 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1364)));
        _1406 = mad(_53, _1395, mad(_52, _1392, (_1389 * _51)));
        _1407 = mad(_56, _1395, mad(_55, _1392, (_1389 * _54)));
        _1408 = mad(_59, _1395, mad(_58, _1392, (_1389 * _57)));
      } else {
        _1406 = _1364;
        _1407 = _1365;
        _1408 = _1366;
      }
      do {
        if (_1406 < 0.0031306699384003878f) {
          _1419 = (_1406 * 12.920000076293945f);
        } else {
          _1419 = (((pow(_1406, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1407 < 0.0031306699384003878f) {
            _1430 = (_1407 * 12.920000076293945f);
          } else {
            _1430 = (((pow(_1407, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1408 < 0.0031306699384003878f) {
            _2790 = _1419;
            _2791 = _1430;
            _2792 = (_1408 * 12.920000076293945f);
          } else {
            _2790 = _1419;
            _2791 = _1430;
            _2792 = (((pow(_1408, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1457 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1364)));
      float _1460 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1364)));
      float _1463 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1364)));
      float _1473 = max(6.103519990574569e-05f, mad(_53, _1463, mad(_52, _1460, (_1457 * _51))));
      float _1474 = max(6.103519990574569e-05f, mad(_56, _1463, mad(_55, _1460, (_1457 * _54))));
      float _1475 = max(6.103519990574569e-05f, mad(_59, _1463, mad(_58, _1460, (_1457 * _57))));
      _2790 = min((_1473 * 4.5f), ((exp2(log2(max(_1473, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2791 = min((_1474 * 4.5f), ((exp2(log2(max(_1474, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2792 = min((_1475 * 4.5f), ((exp2(log2(max(_1475, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1552 = cb0_012z * _1350;
        float _1553 = cb0_012z * _1351;
        float _1554 = cb0_012z * _1352;
        float _1557 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1554, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1553, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1552)));
        float _1560 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1554, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1553, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1552)));
        float _1563 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1554, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1553, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1552)));
        float _1567 = max(max(_1557, _1560), _1563);
        float _1572 = (max(_1567, 1.000000013351432e-10f) - max(min(min(_1557, _1560), _1563), 1.000000013351432e-10f)) / max(_1567, 0.009999999776482582f);
        float _1585 = ((_1560 + _1557) + _1563) + (sqrt((((_1563 - _1560) * _1563) + ((_1560 - _1557) * _1560)) + ((_1557 - _1563) * _1557)) * 1.75f);
        float _1586 = _1585 * 0.3333333432674408f;
        float _1587 = _1572 + -0.4000000059604645f;
        float _1588 = _1587 * 5.0f;
        float _1592 = max((1.0f - abs(_1587 * 2.5f)), 0.0f);
        float _1603 = ((float((int)(((int)(uint)((bool)(_1588 > 0.0f))) - ((int)(uint)((bool)(_1588 < 0.0f))))) * (1.0f - (_1592 * _1592))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1586 <= 0.0533333346247673f)) {
            if (!(_1586 >= 0.1599999964237213f)) {
              _1612 = (((0.23999999463558197f / _1585) + -0.5f) * _1603);
            } else {
              _1612 = 0.0f;
            }
          } else {
            _1612 = _1603;
          }
          float _1613 = _1612 + 1.0f;
          float _1614 = _1613 * _1557;
          float _1615 = _1613 * _1560;
          float _1616 = _1613 * _1563;
          do {
            if (!((bool)(_1614 == _1615) && (bool)(_1615 == _1616))) {
              float _1623 = ((_1614 * 2.0f) - _1615) - _1616;
              float _1626 = ((_1560 - _1563) * 1.7320507764816284f) * _1613;
              float _1628 = atan(_1626 / _1623);
              bool _1631 = (_1623 < 0.0f);
              bool _1632 = (_1623 == 0.0f);
              bool _1633 = (_1626 >= 0.0f);
              bool _1634 = (_1626 < 0.0f);
              float _1643 = select((_1633 && _1632), 90.0f, select((_1634 && _1632), -90.0f, (select((_1634 && _1631), (_1628 + -3.1415927410125732f), select((_1633 && _1631), (_1628 + 3.1415927410125732f), _1628)) * 57.2957763671875f)));
              if (_1643 < 0.0f) {
                _1648 = (_1643 + 360.0f);
              } else {
                _1648 = _1643;
              }
            } else {
              _1648 = 0.0f;
            }
            float _1650 = min(max(_1648, 0.0f), 360.0f);
            do {
              if (_1650 < -180.0f) {
                _1659 = (_1650 + 360.0f);
              } else {
                if (_1650 > 180.0f) {
                  _1659 = (_1650 + -360.0f);
                } else {
                  _1659 = _1650;
                }
              }
              do {
                if ((bool)(_1659 > -67.5f) && (bool)(_1659 < 67.5f)) {
                  float _1665 = (_1659 + 67.5f) * 0.029629629105329514f;
                  int _1666 = int(_1665);
                  float _1668 = _1665 - float((int)(_1666));
                  float _1669 = _1668 * _1668;
                  float _1670 = _1669 * _1668;
                  if (_1666 == 3) {
                    _1698 = (((0.1666666716337204f - (_1668 * 0.5f)) + (_1669 * 0.5f)) - (_1670 * 0.1666666716337204f));
                  } else {
                    if (_1666 == 2) {
                      _1698 = ((0.6666666865348816f - _1669) + (_1670 * 0.5f));
                    } else {
                      if (_1666 == 1) {
                        _1698 = (((_1670 * -0.5f) + 0.1666666716337204f) + ((_1669 + _1668) * 0.5f));
                      } else {
                        _1698 = select((_1666 == 0), (_1670 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1698 = 0.0f;
                }
                float _1707 = min(max(((((_1572 * 0.27000001072883606f) * (0.029999999329447746f - _1614)) * _1698) + _1614), 0.0f), 65535.0f);
                float _1708 = min(max(_1615, 0.0f), 65535.0f);
                float _1709 = min(max(_1616, 0.0f), 65535.0f);
                float _1722 = min(max(mad(-0.21492856740951538f, _1709, mad(-0.2365107536315918f, _1708, (_1707 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1723 = min(max(mad(-0.09967592358589172f, _1709, mad(1.17622971534729f, _1708, (_1707 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1724 = min(max(mad(0.9977163076400757f, _1709, mad(-0.006032449658960104f, _1708, (_1707 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1725 = dot(float3(_1722, _1723, _1724), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1736 = log2(max((lerp(_1725, _1722, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1737 = _1736 * 0.3010300099849701f;
                float _1738 = log2(cb0_008x);
                float _1739 = _1738 * 0.3010300099849701f;
                do {
                  if (!(!(_1737 <= _1739))) {
                    _1808 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1746 = log2(cb0_009x);
                    float _1747 = _1746 * 0.3010300099849701f;
                    if ((bool)(_1737 > _1739) && (bool)(_1737 < _1747)) {
                      float _1755 = ((_1736 - _1738) * 0.9030900001525879f) / ((_1746 - _1738) * 0.3010300099849701f);
                      int _1756 = int(_1755);
                      float _1758 = _1755 - float((int)(_1756));
                      float _1760 = _15[_1756];
                      float _1763 = _15[(_1756 + 1)];
                      float _1768 = _1760 * 0.5f;
                      _1808 = dot(float3((_1758 * _1758), _1758, 1.0f), float3(mad((_15[(_1756 + 2)]), 0.5f, mad(_1763, -1.0f, _1768)), (_1763 - _1760), mad(_1763, 0.5f, _1768)));
                    } else {
                      do {
                        if (!(!(_1737 >= _1747))) {
                          float _1777 = log2(cb0_008z);
                          if (_1737 < (_1777 * 0.3010300099849701f)) {
                            float _1785 = ((_1736 - _1746) * 0.9030900001525879f) / ((_1777 - _1746) * 0.3010300099849701f);
                            int _1786 = int(_1785);
                            float _1788 = _1785 - float((int)(_1786));
                            float _1790 = _16[_1786];
                            float _1793 = _16[(_1786 + 1)];
                            float _1798 = _1790 * 0.5f;
                            _1808 = dot(float3((_1788 * _1788), _1788, 1.0f), float3(mad((_16[(_1786 + 2)]), 0.5f, mad(_1793, -1.0f, _1798)), (_1793 - _1790), mad(_1793, 0.5f, _1798)));
                            break;
                          }
                        }
                        _1808 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1812 = log2(max((lerp(_1725, _1723, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1813 = _1812 * 0.3010300099849701f;
                  do {
                    if (!(!(_1813 <= _1739))) {
                      _1882 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1820 = log2(cb0_009x);
                      float _1821 = _1820 * 0.3010300099849701f;
                      if ((bool)(_1813 > _1739) && (bool)(_1813 < _1821)) {
                        float _1829 = ((_1812 - _1738) * 0.9030900001525879f) / ((_1820 - _1738) * 0.3010300099849701f);
                        int _1830 = int(_1829);
                        float _1832 = _1829 - float((int)(_1830));
                        float _1834 = _15[_1830];
                        float _1837 = _15[(_1830 + 1)];
                        float _1842 = _1834 * 0.5f;
                        _1882 = dot(float3((_1832 * _1832), _1832, 1.0f), float3(mad((_15[(_1830 + 2)]), 0.5f, mad(_1837, -1.0f, _1842)), (_1837 - _1834), mad(_1837, 0.5f, _1842)));
                      } else {
                        do {
                          if (!(!(_1813 >= _1821))) {
                            float _1851 = log2(cb0_008z);
                            if (_1813 < (_1851 * 0.3010300099849701f)) {
                              float _1859 = ((_1812 - _1820) * 0.9030900001525879f) / ((_1851 - _1820) * 0.3010300099849701f);
                              int _1860 = int(_1859);
                              float _1862 = _1859 - float((int)(_1860));
                              float _1864 = _16[_1860];
                              float _1867 = _16[(_1860 + 1)];
                              float _1872 = _1864 * 0.5f;
                              _1882 = dot(float3((_1862 * _1862), _1862, 1.0f), float3(mad((_16[(_1860 + 2)]), 0.5f, mad(_1867, -1.0f, _1872)), (_1867 - _1864), mad(_1867, 0.5f, _1872)));
                              break;
                            }
                          }
                          _1882 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1886 = log2(max((lerp(_1725, _1724, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1887 = _1886 * 0.3010300099849701f;
                    do {
                      if (!(!(_1887 <= _1739))) {
                        _1956 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1894 = log2(cb0_009x);
                        float _1895 = _1894 * 0.3010300099849701f;
                        if ((bool)(_1887 > _1739) && (bool)(_1887 < _1895)) {
                          float _1903 = ((_1886 - _1738) * 0.9030900001525879f) / ((_1894 - _1738) * 0.3010300099849701f);
                          int _1904 = int(_1903);
                          float _1906 = _1903 - float((int)(_1904));
                          float _1908 = _15[_1904];
                          float _1911 = _15[(_1904 + 1)];
                          float _1916 = _1908 * 0.5f;
                          _1956 = dot(float3((_1906 * _1906), _1906, 1.0f), float3(mad((_15[(_1904 + 2)]), 0.5f, mad(_1911, -1.0f, _1916)), (_1911 - _1908), mad(_1911, 0.5f, _1916)));
                        } else {
                          do {
                            if (!(!(_1887 >= _1895))) {
                              float _1925 = log2(cb0_008z);
                              if (_1887 < (_1925 * 0.3010300099849701f)) {
                                float _1933 = ((_1886 - _1894) * 0.9030900001525879f) / ((_1925 - _1894) * 0.3010300099849701f);
                                int _1934 = int(_1933);
                                float _1936 = _1933 - float((int)(_1934));
                                float _1938 = _16[_1934];
                                float _1941 = _16[(_1934 + 1)];
                                float _1946 = _1938 * 0.5f;
                                _1956 = dot(float3((_1936 * _1936), _1936, 1.0f), float3(mad((_16[(_1934 + 2)]), 0.5f, mad(_1941, -1.0f, _1946)), (_1941 - _1938), mad(_1941, 0.5f, _1946)));
                                break;
                              }
                            }
                            _1956 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1960 = cb0_008w - cb0_008y;
                      float _1961 = (exp2(_1808 * 3.321928024291992f) - cb0_008y) / _1960;
                      float _1963 = (exp2(_1882 * 3.321928024291992f) - cb0_008y) / _1960;
                      float _1965 = (exp2(_1956 * 3.321928024291992f) - cb0_008y) / _1960;
                      float _1968 = mad(0.15618768334388733f, _1965, mad(0.13400420546531677f, _1963, (_1961 * 0.6624541878700256f)));
                      float _1971 = mad(0.053689517080783844f, _1965, mad(0.6740817427635193f, _1963, (_1961 * 0.2722287178039551f)));
                      float _1974 = mad(1.0103391408920288f, _1965, mad(0.00406073359772563f, _1963, (_1961 * -0.005574649665504694f)));
                      float _1987 = min(max(mad(-0.23642469942569733f, _1974, mad(-0.32480329275131226f, _1971, (_1968 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1988 = min(max(mad(0.016756348311901093f, _1974, mad(1.6153316497802734f, _1971, (_1968 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1989 = min(max(mad(0.9883948564529419f, _1974, mad(-0.008284442126750946f, _1971, (_1968 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1992 = mad(0.15618768334388733f, _1989, mad(0.13400420546531677f, _1988, (_1987 * 0.6624541878700256f)));
                      float _1995 = mad(0.053689517080783844f, _1989, mad(0.6740817427635193f, _1988, (_1987 * 0.2722287178039551f)));
                      float _1998 = mad(1.0103391408920288f, _1989, mad(0.00406073359772563f, _1988, (_1987 * -0.005574649665504694f)));
                      float _2020 = min(max((min(max(mad(-0.23642469942569733f, _1998, mad(-0.32480329275131226f, _1995, (_1992 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2021 = min(max((min(max(mad(0.016756348311901093f, _1998, mad(1.6153316497802734f, _1995, (_1992 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2022 = min(max((min(max(mad(0.9883948564529419f, _1998, mad(-0.008284442126750946f, _1995, (_1992 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _2035 = mad(_53, _2022, mad(_52, _2021, (_2020 * _51)));
                          _2036 = mad(_56, _2022, mad(_55, _2021, (_2020 * _54)));
                          _2037 = mad(_59, _2022, mad(_58, _2021, (_2020 * _57)));
                        } else {
                          _2035 = _2020;
                          _2036 = _2021;
                          _2037 = _2022;
                        }
                        float _2047 = exp2(log2(_2035 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2048 = exp2(log2(_2036 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2049 = exp2(log2(_2037 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2790 = exp2(log2((1.0f / ((_2047 * 18.6875f) + 1.0f)) * ((_2047 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2791 = exp2(log2((1.0f / ((_2048 * 18.6875f) + 1.0f)) * ((_2048 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2792 = exp2(log2((1.0f / ((_2049 * 18.6875f) + 1.0f)) * ((_2049 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2128 = cb0_012z * _1350;
          float _2129 = cb0_012z * _1351;
          float _2130 = cb0_012z * _1352;
          float _2133 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _2130, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _2129, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _2128)));
          float _2136 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _2130, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _2129, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _2128)));
          float _2139 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _2130, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _2129, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _2128)));
          float _2143 = max(max(_2133, _2136), _2139);
          float _2148 = (max(_2143, 1.000000013351432e-10f) - max(min(min(_2133, _2136), _2139), 1.000000013351432e-10f)) / max(_2143, 0.009999999776482582f);
          float _2161 = ((_2136 + _2133) + _2139) + (sqrt((((_2139 - _2136) * _2139) + ((_2136 - _2133) * _2136)) + ((_2133 - _2139) * _2133)) * 1.75f);
          float _2162 = _2161 * 0.3333333432674408f;
          float _2163 = _2148 + -0.4000000059604645f;
          float _2164 = _2163 * 5.0f;
          float _2168 = max((1.0f - abs(_2163 * 2.5f)), 0.0f);
          float _2179 = ((float((int)(((int)(uint)((bool)(_2164 > 0.0f))) - ((int)(uint)((bool)(_2164 < 0.0f))))) * (1.0f - (_2168 * _2168))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2162 <= 0.0533333346247673f)) {
              if (!(_2162 >= 0.1599999964237213f)) {
                _2188 = (((0.23999999463558197f / _2161) + -0.5f) * _2179);
              } else {
                _2188 = 0.0f;
              }
            } else {
              _2188 = _2179;
            }
            float _2189 = _2188 + 1.0f;
            float _2190 = _2189 * _2133;
            float _2191 = _2189 * _2136;
            float _2192 = _2189 * _2139;
            do {
              if (!((bool)(_2190 == _2191) && (bool)(_2191 == _2192))) {
                float _2199 = ((_2190 * 2.0f) - _2191) - _2192;
                float _2202 = ((_2136 - _2139) * 1.7320507764816284f) * _2189;
                float _2204 = atan(_2202 / _2199);
                bool _2207 = (_2199 < 0.0f);
                bool _2208 = (_2199 == 0.0f);
                bool _2209 = (_2202 >= 0.0f);
                bool _2210 = (_2202 < 0.0f);
                float _2219 = select((_2209 && _2208), 90.0f, select((_2210 && _2208), -90.0f, (select((_2210 && _2207), (_2204 + -3.1415927410125732f), select((_2209 && _2207), (_2204 + 3.1415927410125732f), _2204)) * 57.2957763671875f)));
                if (_2219 < 0.0f) {
                  _2224 = (_2219 + 360.0f);
                } else {
                  _2224 = _2219;
                }
              } else {
                _2224 = 0.0f;
              }
              float _2226 = min(max(_2224, 0.0f), 360.0f);
              do {
                if (_2226 < -180.0f) {
                  _2235 = (_2226 + 360.0f);
                } else {
                  if (_2226 > 180.0f) {
                    _2235 = (_2226 + -360.0f);
                  } else {
                    _2235 = _2226;
                  }
                }
                do {
                  if ((bool)(_2235 > -67.5f) && (bool)(_2235 < 67.5f)) {
                    float _2241 = (_2235 + 67.5f) * 0.029629629105329514f;
                    int _2242 = int(_2241);
                    float _2244 = _2241 - float((int)(_2242));
                    float _2245 = _2244 * _2244;
                    float _2246 = _2245 * _2244;
                    if (_2242 == 3) {
                      _2274 = (((0.1666666716337204f - (_2244 * 0.5f)) + (_2245 * 0.5f)) - (_2246 * 0.1666666716337204f));
                    } else {
                      if (_2242 == 2) {
                        _2274 = ((0.6666666865348816f - _2245) + (_2246 * 0.5f));
                      } else {
                        if (_2242 == 1) {
                          _2274 = (((_2246 * -0.5f) + 0.1666666716337204f) + ((_2245 + _2244) * 0.5f));
                        } else {
                          _2274 = select((_2242 == 0), (_2246 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2274 = 0.0f;
                  }
                  float _2283 = min(max(((((_2148 * 0.27000001072883606f) * (0.029999999329447746f - _2190)) * _2274) + _2190), 0.0f), 65535.0f);
                  float _2284 = min(max(_2191, 0.0f), 65535.0f);
                  float _2285 = min(max(_2192, 0.0f), 65535.0f);
                  float _2298 = min(max(mad(-0.21492856740951538f, _2285, mad(-0.2365107536315918f, _2284, (_2283 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2299 = min(max(mad(-0.09967592358589172f, _2285, mad(1.17622971534729f, _2284, (_2283 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2300 = min(max(mad(0.9977163076400757f, _2285, mad(-0.006032449658960104f, _2284, (_2283 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2301 = dot(float3(_2298, _2299, _2300), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2312 = log2(max((lerp(_2301, _2298, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2313 = _2312 * 0.3010300099849701f;
                  float _2314 = log2(cb0_008x);
                  float _2315 = _2314 * 0.3010300099849701f;
                  do {
                    if (!(!(_2313 <= _2315))) {
                      _2384 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2322 = log2(cb0_009x);
                      float _2323 = _2322 * 0.3010300099849701f;
                      if ((bool)(_2313 > _2315) && (bool)(_2313 < _2323)) {
                        float _2331 = ((_2312 - _2314) * 0.9030900001525879f) / ((_2322 - _2314) * 0.3010300099849701f);
                        int _2332 = int(_2331);
                        float _2334 = _2331 - float((int)(_2332));
                        float _2336 = _13[_2332];
                        float _2339 = _13[(_2332 + 1)];
                        float _2344 = _2336 * 0.5f;
                        _2384 = dot(float3((_2334 * _2334), _2334, 1.0f), float3(mad((_13[(_2332 + 2)]), 0.5f, mad(_2339, -1.0f, _2344)), (_2339 - _2336), mad(_2339, 0.5f, _2344)));
                      } else {
                        do {
                          if (!(!(_2313 >= _2323))) {
                            float _2353 = log2(cb0_008z);
                            if (_2313 < (_2353 * 0.3010300099849701f)) {
                              float _2361 = ((_2312 - _2322) * 0.9030900001525879f) / ((_2353 - _2322) * 0.3010300099849701f);
                              int _2362 = int(_2361);
                              float _2364 = _2361 - float((int)(_2362));
                              float _2366 = _14[_2362];
                              float _2369 = _14[(_2362 + 1)];
                              float _2374 = _2366 * 0.5f;
                              _2384 = dot(float3((_2364 * _2364), _2364, 1.0f), float3(mad((_14[(_2362 + 2)]), 0.5f, mad(_2369, -1.0f, _2374)), (_2369 - _2366), mad(_2369, 0.5f, _2374)));
                              break;
                            }
                          }
                          _2384 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2388 = log2(max((lerp(_2301, _2299, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2389 = _2388 * 0.3010300099849701f;
                    do {
                      if (!(!(_2389 <= _2315))) {
                        _2458 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2396 = log2(cb0_009x);
                        float _2397 = _2396 * 0.3010300099849701f;
                        if ((bool)(_2389 > _2315) && (bool)(_2389 < _2397)) {
                          float _2405 = ((_2388 - _2314) * 0.9030900001525879f) / ((_2396 - _2314) * 0.3010300099849701f);
                          int _2406 = int(_2405);
                          float _2408 = _2405 - float((int)(_2406));
                          float _2410 = _13[_2406];
                          float _2413 = _13[(_2406 + 1)];
                          float _2418 = _2410 * 0.5f;
                          _2458 = dot(float3((_2408 * _2408), _2408, 1.0f), float3(mad((_13[(_2406 + 2)]), 0.5f, mad(_2413, -1.0f, _2418)), (_2413 - _2410), mad(_2413, 0.5f, _2418)));
                        } else {
                          do {
                            if (!(!(_2389 >= _2397))) {
                              float _2427 = log2(cb0_008z);
                              if (_2389 < (_2427 * 0.3010300099849701f)) {
                                float _2435 = ((_2388 - _2396) * 0.9030900001525879f) / ((_2427 - _2396) * 0.3010300099849701f);
                                int _2436 = int(_2435);
                                float _2438 = _2435 - float((int)(_2436));
                                float _2440 = _14[_2436];
                                float _2443 = _14[(_2436 + 1)];
                                float _2448 = _2440 * 0.5f;
                                _2458 = dot(float3((_2438 * _2438), _2438, 1.0f), float3(mad((_14[(_2436 + 2)]), 0.5f, mad(_2443, -1.0f, _2448)), (_2443 - _2440), mad(_2443, 0.5f, _2448)));
                                break;
                              }
                            }
                            _2458 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2462 = log2(max((lerp(_2301, _2300, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2463 = _2462 * 0.3010300099849701f;
                      do {
                        if (!(!(_2463 <= _2315))) {
                          _2532 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2470 = log2(cb0_009x);
                          float _2471 = _2470 * 0.3010300099849701f;
                          if ((bool)(_2463 > _2315) && (bool)(_2463 < _2471)) {
                            float _2479 = ((_2462 - _2314) * 0.9030900001525879f) / ((_2470 - _2314) * 0.3010300099849701f);
                            int _2480 = int(_2479);
                            float _2482 = _2479 - float((int)(_2480));
                            float _2484 = _13[_2480];
                            float _2487 = _13[(_2480 + 1)];
                            float _2492 = _2484 * 0.5f;
                            _2532 = dot(float3((_2482 * _2482), _2482, 1.0f), float3(mad((_13[(_2480 + 2)]), 0.5f, mad(_2487, -1.0f, _2492)), (_2487 - _2484), mad(_2487, 0.5f, _2492)));
                          } else {
                            do {
                              if (!(!(_2463 >= _2471))) {
                                float _2501 = log2(cb0_008z);
                                if (_2463 < (_2501 * 0.3010300099849701f)) {
                                  float _2509 = ((_2462 - _2470) * 0.9030900001525879f) / ((_2501 - _2470) * 0.3010300099849701f);
                                  int _2510 = int(_2509);
                                  float _2512 = _2509 - float((int)(_2510));
                                  float _2514 = _14[_2510];
                                  float _2517 = _14[(_2510 + 1)];
                                  float _2522 = _2514 * 0.5f;
                                  _2532 = dot(float3((_2512 * _2512), _2512, 1.0f), float3(mad((_14[(_2510 + 2)]), 0.5f, mad(_2517, -1.0f, _2522)), (_2517 - _2514), mad(_2517, 0.5f, _2522)));
                                  break;
                                }
                              }
                              _2532 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2536 = cb0_008w - cb0_008y;
                        float _2537 = (exp2(_2384 * 3.321928024291992f) - cb0_008y) / _2536;
                        float _2539 = (exp2(_2458 * 3.321928024291992f) - cb0_008y) / _2536;
                        float _2541 = (exp2(_2532 * 3.321928024291992f) - cb0_008y) / _2536;
                        float _2544 = mad(0.15618768334388733f, _2541, mad(0.13400420546531677f, _2539, (_2537 * 0.6624541878700256f)));
                        float _2547 = mad(0.053689517080783844f, _2541, mad(0.6740817427635193f, _2539, (_2537 * 0.2722287178039551f)));
                        float _2550 = mad(1.0103391408920288f, _2541, mad(0.00406073359772563f, _2539, (_2537 * -0.005574649665504694f)));
                        float _2563 = min(max(mad(-0.23642469942569733f, _2550, mad(-0.32480329275131226f, _2547, (_2544 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2564 = min(max(mad(0.016756348311901093f, _2550, mad(1.6153316497802734f, _2547, (_2544 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2565 = min(max(mad(0.9883948564529419f, _2550, mad(-0.008284442126750946f, _2547, (_2544 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2568 = mad(0.15618768334388733f, _2565, mad(0.13400420546531677f, _2564, (_2563 * 0.6624541878700256f)));
                        float _2571 = mad(0.053689517080783844f, _2565, mad(0.6740817427635193f, _2564, (_2563 * 0.2722287178039551f)));
                        float _2574 = mad(1.0103391408920288f, _2565, mad(0.00406073359772563f, _2564, (_2563 * -0.005574649665504694f)));
                        float _2596 = min(max((min(max(mad(-0.23642469942569733f, _2574, mad(-0.32480329275131226f, _2571, (_2568 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2597 = min(max((min(max(mad(0.016756348311901093f, _2574, mad(1.6153316497802734f, _2571, (_2568 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2598 = min(max((min(max(mad(0.9883948564529419f, _2574, mad(-0.008284442126750946f, _2571, (_2568 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2611 = mad(_53, _2598, mad(_52, _2597, (_2596 * _51)));
                            _2612 = mad(_56, _2598, mad(_55, _2597, (_2596 * _54)));
                            _2613 = mad(_59, _2598, mad(_58, _2597, (_2596 * _57)));
                          } else {
                            _2611 = _2596;
                            _2612 = _2597;
                            _2613 = _2598;
                          }
                          float _2623 = exp2(log2(_2611 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2624 = exp2(log2(_2612 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2625 = exp2(log2(_2613 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2790 = exp2(log2((1.0f / ((_2623 * 18.6875f) + 1.0f)) * ((_2623 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2791 = exp2(log2((1.0f / ((_2624 * 18.6875f) + 1.0f)) * ((_2624 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2792 = exp2(log2((1.0f / ((_2625 * 18.6875f) + 1.0f)) * ((_2625 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2670 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1352, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1351, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1350)));
            float _2673 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1352, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1351, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1350)));
            float _2676 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1352, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1351, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1350)));
            float _2695 = exp2(log2(mad(_53, _2676, mad(_52, _2673, (_2670 * _51))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2696 = exp2(log2(mad(_56, _2676, mad(_55, _2673, (_2670 * _54))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2697 = exp2(log2(mad(_59, _2676, mad(_58, _2673, (_2670 * _57))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2790 = exp2(log2((1.0f / ((_2695 * 18.6875f) + 1.0f)) * ((_2695 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2791 = exp2(log2((1.0f / ((_2696 * 18.6875f) + 1.0f)) * ((_2696 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2792 = exp2(log2((1.0f / ((_2697 * 18.6875f) + 1.0f)) * ((_2697 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2744 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1340, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1339, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1338)));
                float _2747 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1340, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1339, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1338)));
                float _2750 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1340, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1339, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1338)));
                _2790 = mad(_53, _2750, mad(_52, _2747, (_2744 * _51)));
                _2791 = mad(_56, _2750, mad(_55, _2747, (_2744 * _54)));
                _2792 = mad(_59, _2750, mad(_58, _2747, (_2744 * _57)));
              } else {
                float _2763 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1364)));
                float _2766 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1364)));
                float _2769 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1366, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1365, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1364)));
                _2790 = exp2(log2(mad(_53, _2769, mad(_52, _2766, (_2763 * _51)))) * cb0_040z);
                _2791 = exp2(log2(mad(_56, _2769, mad(_55, _2766, (_2763 * _54)))) * cb0_040z);
                _2792 = exp2(log2(mad(_59, _2769, mad(_58, _2766, (_2763 * _57)))) * cb0_040z);
              }
            } else {
              _2790 = _1350;
              _2791 = _1351;
              _2792 = _1352;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2790 * 0.9523810148239136f), (_2791 * 0.9523810148239136f), (_2792 * 0.9523810148239136f), 0.0f);
}
