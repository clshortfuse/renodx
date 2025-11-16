#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
//   float cb0_005z : packoffset(c005.z);
//   float cb0_005w : packoffset(c005.w);
//   float cb0_006x : packoffset(c006.x);
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

SamplerState s3 : register(s3);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _30 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _31 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _34 = float((uint)SV_DispatchThreadID.z);
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _121;
  float _122;
  float _123;
  float _172;
  float _901;
  float _937;
  float _948;
  float _1012;
  float _1191;
  float _1202;
  float _1213;
  float _1463;
  float _1464;
  float _1465;
  float _1476;
  float _1487;
  float _1669;
  float _1705;
  float _1716;
  float _1755;
  float _1865;
  float _1939;
  float _2013;
  float _2092;
  float _2093;
  float _2094;
  float _2245;
  float _2281;
  float _2292;
  float _2331;
  float _2441;
  float _2515;
  float _2589;
  float _2668;
  float _2669;
  float _2670;
  float _2847;
  float _2848;
  float _2849;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _44 = (output_gamut == 4);
        _55 = select(_44, 1.0f, 1.7050515413284302f);
        _56 = select(_44, 0.0f, -0.6217905879020691f);
        _57 = select(_44, 0.0f, -0.0832584798336029f);
        _58 = select(_44, 0.0f, -0.13025718927383423f);
        _59 = select(_44, 1.0f, 1.1408027410507202f);
        _60 = select(_44, 0.0f, -0.010548528283834457f);
        _61 = select(_44, 0.0f, -0.024003278464078903f);
        _62 = select(_44, 0.0f, -0.1289687603712082f);
        _63 = select(_44, 1.0f, 1.152971863746643f);
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
      _55 = 1.02579927444458f;
      _56 = -0.020052503794431686f;
      _57 = -0.0057713985443115234f;
      _58 = -0.0022350111976265907f;
      _59 = 1.0045825242996216f;
      _60 = -0.002352306619286537f;
      _61 = -0.005014004185795784f;
      _62 = -0.025293385609984398f;
      _63 = 1.0304402112960815f;
    }
  } else {
    _55 = 1.379158854484558f;
    _56 = -0.3088507056236267f;
    _57 = -0.07034677267074585f;
    _58 = -0.06933528929948807f;
    _59 = 1.0822921991348267f;
    _60 = -0.012962047010660172f;
    _61 = -0.002159259282052517f;
    _62 = -0.045465391129255295f;
    _63 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _74 = exp2(log2(_30 * 1.0322580337524414f) * 0.012683313339948654f);
    float _75 = exp2(log2(_31 * 1.0322580337524414f) * 0.012683313339948654f);
    float _76 = exp2(log2(_34 * 0.032258063554763794f) * 0.012683313339948654f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _122 = (exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _123 = (exp2(log2(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _121 = ((exp2((_30 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _122 = ((exp2((_31 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _123 = ((exp2((_34 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  bool _150 = (cb0_038z != 0);
  float _155 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _172 = (((((2967800.0f - (_155 * 4607000064.0f)) * _155) + 99.11000061035156f) * _155) + 0.24406300485134125f);
  } else {
    _172 = (((((1901800.0f - (_155 * 2006400000.0f)) * _155) + 247.47999572753906f) * _155) + 0.23703999817371368f);
  }
  float _186 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _193 = cb0_035x * cb0_035x;
  float _196 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_193 * 1.6145605741257896e-07f));
  float _201 = ((_186 * 2.0f) + 4.0f) - (_196 * 8.0f);
  float _202 = (_186 * 3.0f) / _201;
  float _204 = (_196 * 2.0f) / _201;
  bool _205 = (cb0_035x < 4000.0f);
  float _214 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _216 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_193 * 1.5317699909210205f)) / (_214 * _214);
  float _223 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _193;
  float _225 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_193 * 308.60699462890625f)) / (_223 * _223);
  float _227 = rsqrt(dot(float2(_216, _225), float2(_216, _225)));
  float _228 = cb0_035y * 0.05000000074505806f;
  float _231 = ((_228 * _225) * _227) + _186;
  float _234 = _196 - ((_228 * _216) * _227);
  float _239 = (4.0f - (_234 * 8.0f)) + (_231 * 2.0f);
  float _245 = (((_231 * 3.0f) / _239) - _202) + select(_205, _202, _172);
  float _246 = (((_234 * 2.0f) / _239) - _204) + select(_205, _204, (((_172 * 2.869999885559082f) + -0.2750000059604645f) - ((_172 * _172) * 3.0f)));
  float _247 = select(_150, _245, 0.3127000033855438f);
  float _248 = select(_150, _246, 0.32899999618530273f);
  float _249 = select(_150, 0.3127000033855438f, _245);
  float _250 = select(_150, 0.32899999618530273f, _246);
  float _251 = max(_248, 1.000000013351432e-10f);
  float _252 = _247 / _251;
  float _255 = ((1.0f - _247) - _248) / _251;
  float _256 = max(_250, 1.000000013351432e-10f);
  float _257 = _249 / _256;
  float _260 = ((1.0f - _249) - _250) / _256;
  float _279 = mad(-0.16140000522136688f, _260, ((_257 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _255, ((_252 * 0.8950999975204468f) + 0.266400009393692f));
  float _280 = mad(0.03669999912381172f, _260, (1.7135000228881836f - (_257 * 0.7501999735832214f))) / mad(0.03669999912381172f, _255, (1.7135000228881836f - (_252 * 0.7501999735832214f)));
  float _281 = mad(1.0296000242233276f, _260, ((_257 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _255, ((_252 * 0.03889999911189079f) + -0.06849999725818634f));
  float _282 = mad(_280, -0.7501999735832214f, 0.0f);
  float _283 = mad(_280, 1.7135000228881836f, 0.0f);
  float _284 = mad(_280, 0.03669999912381172f, -0.0f);
  float _285 = mad(_281, 0.03889999911189079f, 0.0f);
  float _286 = mad(_281, -0.06849999725818634f, 0.0f);
  float _287 = mad(_281, 1.0296000242233276f, 0.0f);
  float _290 = mad(0.1599626988172531f, _285, mad(-0.1470542997121811f, _282, (_279 * 0.883457362651825f)));
  float _293 = mad(0.1599626988172531f, _286, mad(-0.1470542997121811f, _283, (_279 * 0.26293492317199707f)));
  float _296 = mad(0.1599626988172531f, _287, mad(-0.1470542997121811f, _284, (_279 * -0.15930065512657166f)));
  float _299 = mad(0.04929120093584061f, _285, mad(0.5183603167533875f, _282, (_279 * 0.38695648312568665f)));
  float _302 = mad(0.04929120093584061f, _286, mad(0.5183603167533875f, _283, (_279 * 0.11516613513231277f)));
  float _305 = mad(0.04929120093584061f, _287, mad(0.5183603167533875f, _284, (_279 * -0.0697740763425827f)));
  float _308 = mad(0.9684867262840271f, _285, mad(0.04004279896616936f, _282, (_279 * -0.007634039502590895f)));
  float _311 = mad(0.9684867262840271f, _286, mad(0.04004279896616936f, _283, (_279 * -0.0022720457054674625f)));
  float _314 = mad(0.9684867262840271f, _287, mad(0.04004279896616936f, _284, (_279 * 0.0013765322510153055f)));
  float _317 = mad(_296, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_293, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_290 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _320 = mad(_296, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_293, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_290 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _323 = mad(_296, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_293, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_290 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _326 = mad(_305, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_302, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_299 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _329 = mad(_305, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_302, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_299 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _332 = mad(_305, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_302, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_299 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _335 = mad(_314, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_311, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_308 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _338 = mad(_314, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_311, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_308 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _341 = mad(_314, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_311, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_308 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _371 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _341, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _332, (_323 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _123, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _338, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _329, (_320 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _122, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _335, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _326, (_317 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _121)));
  float _374 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _341, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _332, (_323 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _123, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _338, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _329, (_320 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _122, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _335, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _326, (_317 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _121)));
  float _377 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _341, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _332, (_323 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _123, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _338, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _329, (_320 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _122, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _335, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _326, (_317 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _121)));
  float _392 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _377, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _374, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _371)));
  float _395 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _377, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _374, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _371)));
  float _398 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _377, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _374, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _371)));
  float _399 = dot(float3(_392, _395, _398), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _403 = (_392 / _399) + -1.0f;
  float _404 = (_395 / _399) + -1.0f;
  float _405 = (_398 / _399) + -1.0f;
  float _417 = (1.0f - exp2(((_399 * _399) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_403, _404, _405), float3(_403, _404, _405)) * -4.0f));
  float _433 = ((mad(-0.06368283927440643f, _398, mad(-0.32929131388664246f, _395, (_392 * 1.370412826538086f))) - _392) * _417) + _392;
  float _434 = ((mad(-0.010861567221581936f, _398, mad(1.0970908403396606f, _395, (_392 * -0.08343426138162613f))) - _395) * _417) + _395;
  float _435 = ((mad(1.203694462776184f, _398, mad(-0.09862564504146576f, _395, (_392 * -0.02579325996339321f))) - _398) * _417) + _398;
#if 1
  float _801, _803, _805;
  ApplyColorCorrection(
      _433, _434, _435,
      _801, _803, _805,
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
  float _436 = dot(float3(_433, _434, _435), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _450 = cb0_019w + cb0_024w;
  float _464 = cb0_018w * cb0_023w;
  float _478 = cb0_017w * cb0_022w;
  float _492 = cb0_016w * cb0_021w;
  float _506 = cb0_015w * cb0_020w;
  float _510 = _433 - _436;
  float _511 = _434 - _436;
  float _512 = _435 - _436;
  float _569 = saturate(_436 / cb0_035z);
  float _573 = (_569 * _569) * (3.0f - (_569 * 2.0f));
  float _574 = 1.0f - _573;
  float _583 = cb0_019w + cb0_034w;
  float _592 = cb0_018w * cb0_033w;
  float _601 = cb0_017w * cb0_032w;
  float _610 = cb0_016w * cb0_031w;
  float _619 = cb0_015w * cb0_030w;
  float _683 = saturate((_436 - cb0_035w) / (cb0_036x - cb0_035w));
  float _687 = (_683 * _683) * (3.0f - (_683 * 2.0f));
  float _696 = cb0_019w + cb0_029w;
  float _705 = cb0_018w * cb0_028w;
  float _714 = cb0_017w * cb0_027w;
  float _723 = cb0_016w * cb0_026w;
  float _732 = cb0_015w * cb0_025w;
  float _790 = _573 - _687;
  float _801 = ((_687 * (((cb0_019x + cb0_034x) + _583) + (((cb0_018x * cb0_033x) * _592) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _610) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _619) * _510) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _601)))))) + (_574 * (((cb0_019x + cb0_024x) + _450) + (((cb0_018x * cb0_023x) * _464) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _492) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _506) * _510) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _478))))))) + ((((cb0_019x + cb0_029x) + _696) + (((cb0_018x * cb0_028x) * _705) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _723) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _732) * _510) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _714))))) * _790);
  float _803 = ((_687 * (((cb0_019y + cb0_034y) + _583) + (((cb0_018y * cb0_033y) * _592) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _610) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _619) * _511) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _601)))))) + (_574 * (((cb0_019y + cb0_024y) + _450) + (((cb0_018y * cb0_023y) * _464) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _492) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _506) * _511) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _478))))))) + ((((cb0_019y + cb0_029y) + _696) + (((cb0_018y * cb0_028y) * _705) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _723) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _732) * _511) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _714))))) * _790);
  float _805 = ((_687 * (((cb0_019z + cb0_034z) + _583) + (((cb0_018z * cb0_033z) * _592) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _610) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _619) * _512) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _601)))))) + (_574 * (((cb0_019z + cb0_024z) + _450) + (((cb0_018z * cb0_023z) * _464) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _492) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _506) * _512) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _478))))))) + ((((cb0_019z + cb0_029z) + _696) + (((cb0_018z * cb0_028z) * _705) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _723) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _732) * _512) + _436)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _714))))) * _790);
#endif

#if 1  // begin FilmToneMap with BlueCorrect
  float _1163, _1164, _1165;
  ApplyFilmToneMapWithBlueCorrect(_801, _803, _805,
                                  _1163, _1164, _1165);
#else
  float _841 = ((mad(0.061360642313957214f, _805, mad(-4.540197551250458e-09f, _803, (_801 * 0.9386394023895264f))) - _801) * cb0_036y) + _801;
  float _842 = ((mad(0.169205904006958f, _805, mad(0.8307942152023315f, _803, (_801 * 6.775371730327606e-08f))) - _803) * cb0_036y) + _803;
  float _843 = (mad(-2.3283064365386963e-10f, _803, (_801 * -9.313225746154785e-10f)) * cb0_036y) + _805;
  float _846 = mad(0.16386905312538147f, _843, mad(0.14067868888378143f, _842, (_841 * 0.6954522132873535f)));
  float _849 = mad(0.0955343246459961f, _843, mad(0.8596711158752441f, _842, (_841 * 0.044794581830501556f)));
  float _852 = mad(1.0015007257461548f, _843, mad(0.004025210160762072f, _842, (_841 * -0.005525882821530104f)));
  float _856 = max(max(_846, _849), _852);
  float _861 = (max(_856, 1.000000013351432e-10f) - max(min(min(_846, _849), _852), 1.000000013351432e-10f)) / max(_856, 0.009999999776482582f);
  float _874 = ((_849 + _846) + _852) + (sqrt((((_852 - _849) * _852) + ((_849 - _846) * _849)) + ((_846 - _852) * _846)) * 1.75f);
  float _875 = _874 * 0.3333333432674408f;
  float _876 = _861 + -0.4000000059604645f;
  float _877 = _876 * 5.0f;
  float _881 = max((1.0f - abs(_876 * 2.5f)), 0.0f);
  float _892 = ((float((int)(((int)(uint)((bool)(_877 > 0.0f))) - ((int)(uint)((bool)(_877 < 0.0f))))) * (1.0f - (_881 * _881))) + 1.0f) * 0.02500000037252903f;
  if (!(_875 <= 0.0533333346247673f)) {
    if (!(_875 >= 0.1599999964237213f)) {
      _901 = (((0.23999999463558197f / _874) + -0.5f) * _892);
    } else {
      _901 = 0.0f;
    }
  } else {
    _901 = _892;
  }
  float _902 = _901 + 1.0f;
  float _903 = _902 * _846;
  float _904 = _902 * _849;
  float _905 = _902 * _852;
  if (!((bool)(_903 == _904) && (bool)(_904 == _905))) {
    float _912 = ((_903 * 2.0f) - _904) - _905;
    float _915 = ((_849 - _852) * 1.7320507764816284f) * _902;
    float _917 = atan(_915 / _912);
    bool _920 = (_912 < 0.0f);
    bool _921 = (_912 == 0.0f);
    bool _922 = (_915 >= 0.0f);
    bool _923 = (_915 < 0.0f);
    float _932 = select((_922 && _921), 90.0f, select((_923 && _921), -90.0f, (select((_923 && _920), (_917 + -3.1415927410125732f), select((_922 && _920), (_917 + 3.1415927410125732f), _917)) * 57.2957763671875f)));
    if (_932 < 0.0f) {
      _937 = (_932 + 360.0f);
    } else {
      _937 = _932;
    }
  } else {
    _937 = 0.0f;
  }
  float _939 = min(max(_937, 0.0f), 360.0f);
  if (_939 < -180.0f) {
    _948 = (_939 + 360.0f);
  } else {
    if (_939 > 180.0f) {
      _948 = (_939 + -360.0f);
    } else {
      _948 = _939;
    }
  }
  float _952 = saturate(1.0f - abs(_948 * 0.014814814552664757f));
  float _956 = (_952 * _952) * (3.0f - (_952 * 2.0f));
  float _962 = ((_956 * _956) * ((_861 * 0.18000000715255737f) * (0.029999999329447746f - _903))) + _903;
  float _972 = max(0.0f, mad(-0.21492856740951538f, _905, mad(-0.2365107536315918f, _904, (_962 * 1.4514392614364624f))));
  float _973 = max(0.0f, mad(-0.09967592358589172f, _905, mad(1.17622971534729f, _904, (_962 * -0.07655377686023712f))));
  float _974 = max(0.0f, mad(0.9977163076400757f, _905, mad(-0.006032449658960104f, _904, (_962 * 0.008316148072481155f))));
  float _975 = dot(float3(_972, _973, _974), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1021 = (lerp(_975, _972, 0.9599999785423279f));
  float _1022 = (lerp(_975, _973, 0.9599999785423279f));
  float _1023 = (lerp(_975, _974, 0.9599999785423279f));

#if 1
  float _1163, _1164, _1165;
  ApplyFilmicToneMap(_1021, _1022, _1023,
                     _841, _842, _843,
                     _1163, _1164, _1165);
#else
  _1021 = log2(_1021) * 0.3010300099849701f;
  _1022 = log2(_1022) * 0.3010300099849701f;
  _1023 = log2(_1023) * 0.3010300099849701f;

  float _989 = (cb0_037w + 1.0f) - cb0_037y;
  float _992 = cb0_038x + 1.0f;
  float _994 = _992 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _1012 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _1003 = (cb0_037w + 0.18000000715255737f) / _989;
    _1012 = (-0.7447274923324585f - ((log2(_1003 / (2.0f - _1003)) * 0.3465735912322998f) * (_989 / cb0_037x)));
  }
  float _1015 = ((1.0f - cb0_037y) / cb0_037x) - _1012;
  float _1017 = (cb0_037z / cb0_037x) - _1015;
  float _1027 = cb0_037x * (_1021 + _1015);
  float _1028 = cb0_037x * (_1022 + _1015);
  float _1029 = cb0_037x * (_1023 + _1015);
  float _1030 = _989 * 2.0f;
  float _1032 = (cb0_037x * -2.0f) / _989;
  float _1033 = _1021 - _1012;
  float _1034 = _1022 - _1012;
  float _1035 = _1023 - _1012;
  float _1054 = _994 * 2.0f;
  float _1056 = (cb0_037x * 2.0f) / _994;
  float _1081 = select((_1021 < _1012), ((_1030 / (exp2((_1033 * 1.4426950216293335f) * _1032) + 1.0f)) - cb0_037w), _1027);
  float _1082 = select((_1022 < _1012), ((_1030 / (exp2((_1034 * 1.4426950216293335f) * _1032) + 1.0f)) - cb0_037w), _1028);
  float _1083 = select((_1023 < _1012), ((_1030 / (exp2((_1035 * 1.4426950216293335f) * _1032) + 1.0f)) - cb0_037w), _1029);
  float _1090 = _1017 - _1012;
  float _1094 = saturate(_1033 / _1090);
  float _1095 = saturate(_1034 / _1090);
  float _1096 = saturate(_1035 / _1090);
  bool _1097 = (_1017 < _1012);
  float _1101 = select(_1097, (1.0f - _1094), _1094);
  float _1102 = select(_1097, (1.0f - _1095), _1095);
  float _1103 = select(_1097, (1.0f - _1096), _1096);
  float _1122 = (((_1101 * _1101) * (select((_1021 > _1017), (_992 - (_1054 / (exp2(((_1021 - _1017) * 1.4426950216293335f) * _1056) + 1.0f))), _1027) - _1081)) * (3.0f - (_1101 * 2.0f))) + _1081;
  float _1123 = (((_1102 * _1102) * (select((_1022 > _1017), (_992 - (_1054 / (exp2(((_1022 - _1017) * 1.4426950216293335f) * _1056) + 1.0f))), _1028) - _1082)) * (3.0f - (_1102 * 2.0f))) + _1082;
  float _1124 = (((_1103 * _1103) * (select((_1023 > _1017), (_992 - (_1054 / (exp2(((_1023 - _1017) * 1.4426950216293335f) * _1056) + 1.0f))), _1029) - _1083)) * (3.0f - (_1103 * 2.0f))) + _1083;
  float _1125 = dot(float3(_1122, _1123, _1124), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1145 = (cb0_036w * (max(0.0f, (lerp(_1125, _1122, 0.9300000071525574f))) - _841)) + _841;
  float _1146 = (cb0_036w * (max(0.0f, (lerp(_1125, _1123, 0.9300000071525574f))) - _842)) + _842;
  float _1147 = (cb0_036w * (max(0.0f, (lerp(_1125, _1124, 0.9300000071525574f))) - _843)) + _843;
  float _1163 = ((mad(-0.06537103652954102f, _1147, mad(1.451815478503704e-06f, _1146, (_1145 * 1.065374732017517f))) - _1145) * cb0_036y) + _1145;
  float _1164 = ((mad(-0.20366770029067993f, _1147, mad(1.2036634683609009f, _1146, (_1145 * -2.57161445915699e-07f))) - _1146) * cb0_036y) + _1146;
  float _1165 = ((mad(0.9999996423721313f, _1147, mad(2.0954757928848267e-08f, _1146, (_1145 * 1.862645149230957e-08f))) - _1147) * cb0_036y) + _1147;
#endif

#endif  // end FilmToneMap with BlueCorrect

  float _1178 = ((mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1165, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1164, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1163)))));
  float _1179 = ((mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1165, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1164, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1163)))));
  float _1180 = ((mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1165, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1164, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1163)))));

#if 1
  float _1358, _1359, _1360;
  Sample4LUTsUpgradeToneMap(
      float3(_1178, _1179, _1180),
      s0, s1, s2, s3,
      t0, t1, t2, t3,
      _1358, _1359, _1360);
#else
  if (_1178 < 0.0031306699384003878f) {
    _1191 = (_1178 * 12.920000076293945f);
  } else {
    _1191 = (((pow(_1178, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1179 < 0.0031306699384003878f) {
    _1202 = (_1179 * 12.920000076293945f);
  } else {
    _1202 = (((pow(_1179, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1180 < 0.0031306699384003878f) {
    _1213 = (_1180 * 12.920000076293945f);
  } else {
    _1213 = (((pow(_1180, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1217 = (_1202 * 0.9375f) + 0.03125f;
  float _1224 = _1213 * 15.0f;
  float _1225 = floor(_1224);
  float _1226 = _1224 - _1225;
  float _1228 = (_1225 + ((_1191 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1231 = t0.SampleLevel(s0, float2(_1228, _1217), 0.0f);
  float _1235 = _1228 + 0.0625f;
  float4 _1236 = t0.SampleLevel(s0, float2(_1235, _1217), 0.0f);
  float4 _1258 = t1.SampleLevel(s1, float2(_1228, _1217), 0.0f);
  float4 _1262 = t1.SampleLevel(s1, float2(_1235, _1217), 0.0f);
  float4 _1284 = t2.SampleLevel(s2, float2(_1228, _1217), 0.0f);
  float4 _1288 = t2.SampleLevel(s2, float2(_1235, _1217), 0.0f);
  float4 _1311 = t3.SampleLevel(s3, float2(_1228, _1217), 0.0f);
  float4 _1315 = t3.SampleLevel(s3, float2(_1235, _1217), 0.0f);
  float _1334 = max(6.103519990574569e-05f, ((((((lerp(_1231.x, _1236.x, _1226))*cb0_005y) + (cb0_005x * _1191)) + ((lerp(_1258.x, _1262.x, _1226))*cb0_005z)) + ((lerp(_1284.x, _1288.x, _1226))*cb0_005w)) + ((lerp(_1311.x, _1315.x, _1226))*cb0_006x)));
  float _1335 = max(6.103519990574569e-05f, ((((((lerp(_1231.y, _1236.y, _1226))*cb0_005y) + (cb0_005x * _1202)) + ((lerp(_1258.y, _1262.y, _1226))*cb0_005z)) + ((lerp(_1284.y, _1288.y, _1226))*cb0_005w)) + ((lerp(_1311.y, _1315.y, _1226))*cb0_006x)));
  float _1336 = max(6.103519990574569e-05f, ((((((lerp(_1231.z, _1236.z, _1226))*cb0_005y) + (cb0_005x * _1213)) + ((lerp(_1258.z, _1262.z, _1226))*cb0_005z)) + ((lerp(_1284.z, _1288.z, _1226))*cb0_005w)) + ((lerp(_1311.z, _1315.z, _1226))*cb0_006x)));
  float _1358 = select((_1334 > 0.040449999272823334f), exp2(log2((_1334 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1334 * 0.07739938050508499f));
  float _1359 = select((_1335 > 0.040449999272823334f), exp2(log2((_1335 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1335 * 0.07739938050508499f));
  float _1360 = select((_1336 > 0.040449999272823334f), exp2(log2((_1336 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1336 * 0.07739938050508499f));
#endif

  float _1386 = cb0_014x * (((cb0_039y + (cb0_039x * _1358)) * _1358) + cb0_039z);
  float _1387 = cb0_014y * (((cb0_039y + (cb0_039x * _1359)) * _1359) + cb0_039z);
  float _1388 = cb0_014z * (((cb0_039y + (cb0_039x * _1360)) * _1360) + cb0_039z);
  float _1395 = ((cb0_013x - _1386) * cb0_013w) + _1386;
  float _1396 = ((cb0_013y - _1387) * cb0_013w) + _1387;
  float _1397 = ((cb0_013z - _1388) * cb0_013w) + _1388;

  if (GenerateOutput(_1395, _1396, _1397, u0[SV_DispatchThreadID])) {
    return;
  }

  float _1398 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _805, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _803, (_801 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1399 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _805, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _803, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _801)));
  float _1400 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _805, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _803, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _801)));
  float _1407 = ((cb0_013x - _1398) * cb0_013w) + _1398;
  float _1408 = ((cb0_013y - _1399) * cb0_013w) + _1399;
  float _1409 = ((cb0_013z - _1400) * cb0_013w) + _1400;
  float _1421 = exp2(log2(max(0.0f, _1395)) * cb0_040y);
  float _1422 = exp2(log2(max(0.0f, _1396)) * cb0_040y);
  float _1423 = exp2(log2(max(0.0f, _1397)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1446 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1421)));
        float _1449 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1421)));
        float _1452 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1421)));
        _1463 = mad(_57, _1452, mad(_56, _1449, (_1446 * _55)));
        _1464 = mad(_60, _1452, mad(_59, _1449, (_1446 * _58)));
        _1465 = mad(_63, _1452, mad(_62, _1449, (_1446 * _61)));
      } else {
        _1463 = _1421;
        _1464 = _1422;
        _1465 = _1423;
      }
      do {
        if (_1463 < 0.0031306699384003878f) {
          _1476 = (_1463 * 12.920000076293945f);
        } else {
          _1476 = (((pow(_1463, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1464 < 0.0031306699384003878f) {
            _1487 = (_1464 * 12.920000076293945f);
          } else {
            _1487 = (((pow(_1464, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1465 < 0.0031306699384003878f) {
            _2847 = _1476;
            _2848 = _1487;
            _2849 = (_1465 * 12.920000076293945f);
          } else {
            _2847 = _1476;
            _2848 = _1487;
            _2849 = (((pow(_1465, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1514 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1421)));
      float _1517 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1421)));
      float _1520 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1421)));
      float _1530 = max(6.103519990574569e-05f, mad(_57, _1520, mad(_56, _1517, (_1514 * _55))));
      float _1531 = max(6.103519990574569e-05f, mad(_60, _1520, mad(_59, _1517, (_1514 * _58))));
      float _1532 = max(6.103519990574569e-05f, mad(_63, _1520, mad(_62, _1517, (_1514 * _61))));
      _2847 = min((_1530 * 4.5f), ((exp2(log2(max(_1530, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2848 = min((_1531 * 4.5f), ((exp2(log2(max(_1531, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2849 = min((_1532 * 4.5f), ((exp2(log2(max(_1532, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1609 = cb0_012z * _1407;
        float _1610 = cb0_012z * _1408;
        float _1611 = cb0_012z * _1409;
        float _1614 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1611, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1610, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1609)));
        float _1617 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1611, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1610, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1609)));
        float _1620 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1611, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1610, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1609)));
        float _1624 = max(max(_1614, _1617), _1620);
        float _1629 = (max(_1624, 1.000000013351432e-10f) - max(min(min(_1614, _1617), _1620), 1.000000013351432e-10f)) / max(_1624, 0.009999999776482582f);
        float _1642 = ((_1617 + _1614) + _1620) + (sqrt((((_1620 - _1617) * _1620) + ((_1617 - _1614) * _1617)) + ((_1614 - _1620) * _1614)) * 1.75f);
        float _1643 = _1642 * 0.3333333432674408f;
        float _1644 = _1629 + -0.4000000059604645f;
        float _1645 = _1644 * 5.0f;
        float _1649 = max((1.0f - abs(_1644 * 2.5f)), 0.0f);
        float _1660 = ((float((int)(((int)(uint)((bool)(_1645 > 0.0f))) - ((int)(uint)((bool)(_1645 < 0.0f))))) * (1.0f - (_1649 * _1649))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1643 <= 0.0533333346247673f)) {
            if (!(_1643 >= 0.1599999964237213f)) {
              _1669 = (((0.23999999463558197f / _1642) + -0.5f) * _1660);
            } else {
              _1669 = 0.0f;
            }
          } else {
            _1669 = _1660;
          }
          float _1670 = _1669 + 1.0f;
          float _1671 = _1670 * _1614;
          float _1672 = _1670 * _1617;
          float _1673 = _1670 * _1620;
          do {
            if (!((bool)(_1671 == _1672) && (bool)(_1672 == _1673))) {
              float _1680 = ((_1671 * 2.0f) - _1672) - _1673;
              float _1683 = ((_1617 - _1620) * 1.7320507764816284f) * _1670;
              float _1685 = atan(_1683 / _1680);
              bool _1688 = (_1680 < 0.0f);
              bool _1689 = (_1680 == 0.0f);
              bool _1690 = (_1683 >= 0.0f);
              bool _1691 = (_1683 < 0.0f);
              float _1700 = select((_1690 && _1689), 90.0f, select((_1691 && _1689), -90.0f, (select((_1691 && _1688), (_1685 + -3.1415927410125732f), select((_1690 && _1688), (_1685 + 3.1415927410125732f), _1685)) * 57.2957763671875f)));
              if (_1700 < 0.0f) {
                _1705 = (_1700 + 360.0f);
              } else {
                _1705 = _1700;
              }
            } else {
              _1705 = 0.0f;
            }
            float _1707 = min(max(_1705, 0.0f), 360.0f);
            do {
              if (_1707 < -180.0f) {
                _1716 = (_1707 + 360.0f);
              } else {
                if (_1707 > 180.0f) {
                  _1716 = (_1707 + -360.0f);
                } else {
                  _1716 = _1707;
                }
              }
              do {
                if ((bool)(_1716 > -67.5f) && (bool)(_1716 < 67.5f)) {
                  float _1722 = (_1716 + 67.5f) * 0.029629629105329514f;
                  int _1723 = int(_1722);
                  float _1725 = _1722 - float((int)(_1723));
                  float _1726 = _1725 * _1725;
                  float _1727 = _1726 * _1725;
                  if (_1723 == 3) {
                    _1755 = (((0.1666666716337204f - (_1725 * 0.5f)) + (_1726 * 0.5f)) - (_1727 * 0.1666666716337204f));
                  } else {
                    if (_1723 == 2) {
                      _1755 = ((0.6666666865348816f - _1726) + (_1727 * 0.5f));
                    } else {
                      if (_1723 == 1) {
                        _1755 = (((_1727 * -0.5f) + 0.1666666716337204f) + ((_1726 + _1725) * 0.5f));
                      } else {
                        _1755 = select((_1723 == 0), (_1727 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1755 = 0.0f;
                }
                float _1764 = min(max(((((_1629 * 0.27000001072883606f) * (0.029999999329447746f - _1671)) * _1755) + _1671), 0.0f), 65535.0f);
                float _1765 = min(max(_1672, 0.0f), 65535.0f);
                float _1766 = min(max(_1673, 0.0f), 65535.0f);
                float _1779 = min(max(mad(-0.21492856740951538f, _1766, mad(-0.2365107536315918f, _1765, (_1764 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1780 = min(max(mad(-0.09967592358589172f, _1766, mad(1.17622971534729f, _1765, (_1764 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1781 = min(max(mad(0.9977163076400757f, _1766, mad(-0.006032449658960104f, _1765, (_1764 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1782 = dot(float3(_1779, _1780, _1781), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1793 = log2(max((lerp(_1782, _1779, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1794 = _1793 * 0.3010300099849701f;
                float _1795 = log2(cb0_008x);
                float _1796 = _1795 * 0.3010300099849701f;
                do {
                  if (!(!(_1794 <= _1796))) {
                    _1865 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1803 = log2(cb0_009x);
                    float _1804 = _1803 * 0.3010300099849701f;
                    if ((bool)(_1794 > _1796) && (bool)(_1794 < _1804)) {
                      float _1812 = ((_1793 - _1795) * 0.9030900001525879f) / ((_1803 - _1795) * 0.3010300099849701f);
                      int _1813 = int(_1812);
                      float _1815 = _1812 - float((int)(_1813));
                      float _1817 = _19[_1813];
                      float _1820 = _19[(_1813 + 1)];
                      float _1825 = _1817 * 0.5f;
                      _1865 = dot(float3((_1815 * _1815), _1815, 1.0f), float3(mad((_19[(_1813 + 2)]), 0.5f, mad(_1820, -1.0f, _1825)), (_1820 - _1817), mad(_1820, 0.5f, _1825)));
                    } else {
                      do {
                        if (!(!(_1794 >= _1804))) {
                          float _1834 = log2(cb0_008z);
                          if (_1794 < (_1834 * 0.3010300099849701f)) {
                            float _1842 = ((_1793 - _1803) * 0.9030900001525879f) / ((_1834 - _1803) * 0.3010300099849701f);
                            int _1843 = int(_1842);
                            float _1845 = _1842 - float((int)(_1843));
                            float _1847 = _20[_1843];
                            float _1850 = _20[(_1843 + 1)];
                            float _1855 = _1847 * 0.5f;
                            _1865 = dot(float3((_1845 * _1845), _1845, 1.0f), float3(mad((_20[(_1843 + 2)]), 0.5f, mad(_1850, -1.0f, _1855)), (_1850 - _1847), mad(_1850, 0.5f, _1855)));
                            break;
                          }
                        }
                        _1865 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1869 = log2(max((lerp(_1782, _1780, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1870 = _1869 * 0.3010300099849701f;
                  do {
                    if (!(!(_1870 <= _1796))) {
                      _1939 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1877 = log2(cb0_009x);
                      float _1878 = _1877 * 0.3010300099849701f;
                      if ((bool)(_1870 > _1796) && (bool)(_1870 < _1878)) {
                        float _1886 = ((_1869 - _1795) * 0.9030900001525879f) / ((_1877 - _1795) * 0.3010300099849701f);
                        int _1887 = int(_1886);
                        float _1889 = _1886 - float((int)(_1887));
                        float _1891 = _19[_1887];
                        float _1894 = _19[(_1887 + 1)];
                        float _1899 = _1891 * 0.5f;
                        _1939 = dot(float3((_1889 * _1889), _1889, 1.0f), float3(mad((_19[(_1887 + 2)]), 0.5f, mad(_1894, -1.0f, _1899)), (_1894 - _1891), mad(_1894, 0.5f, _1899)));
                      } else {
                        do {
                          if (!(!(_1870 >= _1878))) {
                            float _1908 = log2(cb0_008z);
                            if (_1870 < (_1908 * 0.3010300099849701f)) {
                              float _1916 = ((_1869 - _1877) * 0.9030900001525879f) / ((_1908 - _1877) * 0.3010300099849701f);
                              int _1917 = int(_1916);
                              float _1919 = _1916 - float((int)(_1917));
                              float _1921 = _20[_1917];
                              float _1924 = _20[(_1917 + 1)];
                              float _1929 = _1921 * 0.5f;
                              _1939 = dot(float3((_1919 * _1919), _1919, 1.0f), float3(mad((_20[(_1917 + 2)]), 0.5f, mad(_1924, -1.0f, _1929)), (_1924 - _1921), mad(_1924, 0.5f, _1929)));
                              break;
                            }
                          }
                          _1939 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1943 = log2(max((lerp(_1782, _1781, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1944 = _1943 * 0.3010300099849701f;
                    do {
                      if (!(!(_1944 <= _1796))) {
                        _2013 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1951 = log2(cb0_009x);
                        float _1952 = _1951 * 0.3010300099849701f;
                        if ((bool)(_1944 > _1796) && (bool)(_1944 < _1952)) {
                          float _1960 = ((_1943 - _1795) * 0.9030900001525879f) / ((_1951 - _1795) * 0.3010300099849701f);
                          int _1961 = int(_1960);
                          float _1963 = _1960 - float((int)(_1961));
                          float _1965 = _19[_1961];
                          float _1968 = _19[(_1961 + 1)];
                          float _1973 = _1965 * 0.5f;
                          _2013 = dot(float3((_1963 * _1963), _1963, 1.0f), float3(mad((_19[(_1961 + 2)]), 0.5f, mad(_1968, -1.0f, _1973)), (_1968 - _1965), mad(_1968, 0.5f, _1973)));
                        } else {
                          do {
                            if (!(!(_1944 >= _1952))) {
                              float _1982 = log2(cb0_008z);
                              if (_1944 < (_1982 * 0.3010300099849701f)) {
                                float _1990 = ((_1943 - _1951) * 0.9030900001525879f) / ((_1982 - _1951) * 0.3010300099849701f);
                                int _1991 = int(_1990);
                                float _1993 = _1990 - float((int)(_1991));
                                float _1995 = _20[_1991];
                                float _1998 = _20[(_1991 + 1)];
                                float _2003 = _1995 * 0.5f;
                                _2013 = dot(float3((_1993 * _1993), _1993, 1.0f), float3(mad((_20[(_1991 + 2)]), 0.5f, mad(_1998, -1.0f, _2003)), (_1998 - _1995), mad(_1998, 0.5f, _2003)));
                                break;
                              }
                            }
                            _2013 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2017 = cb0_008w - cb0_008y;
                      float _2018 = (exp2(_1865 * 3.321928024291992f) - cb0_008y) / _2017;
                      float _2020 = (exp2(_1939 * 3.321928024291992f) - cb0_008y) / _2017;
                      float _2022 = (exp2(_2013 * 3.321928024291992f) - cb0_008y) / _2017;
                      float _2025 = mad(0.15618768334388733f, _2022, mad(0.13400420546531677f, _2020, (_2018 * 0.6624541878700256f)));
                      float _2028 = mad(0.053689517080783844f, _2022, mad(0.6740817427635193f, _2020, (_2018 * 0.2722287178039551f)));
                      float _2031 = mad(1.0103391408920288f, _2022, mad(0.00406073359772563f, _2020, (_2018 * -0.005574649665504694f)));
                      float _2044 = min(max(mad(-0.23642469942569733f, _2031, mad(-0.32480329275131226f, _2028, (_2025 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2045 = min(max(mad(0.016756348311901093f, _2031, mad(1.6153316497802734f, _2028, (_2025 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2046 = min(max(mad(0.9883948564529419f, _2031, mad(-0.008284442126750946f, _2028, (_2025 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2049 = mad(0.15618768334388733f, _2046, mad(0.13400420546531677f, _2045, (_2044 * 0.6624541878700256f)));
                      float _2052 = mad(0.053689517080783844f, _2046, mad(0.6740817427635193f, _2045, (_2044 * 0.2722287178039551f)));
                      float _2055 = mad(1.0103391408920288f, _2046, mad(0.00406073359772563f, _2045, (_2044 * -0.005574649665504694f)));
                      float _2077 = min(max((min(max(mad(-0.23642469942569733f, _2055, mad(-0.32480329275131226f, _2052, (_2049 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2078 = min(max((min(max(mad(0.016756348311901093f, _2055, mad(1.6153316497802734f, _2052, (_2049 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2079 = min(max((min(max(mad(0.9883948564529419f, _2055, mad(-0.008284442126750946f, _2052, (_2049 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _2092 = mad(_57, _2079, mad(_56, _2078, (_2077 * _55)));
                          _2093 = mad(_60, _2079, mad(_59, _2078, (_2077 * _58)));
                          _2094 = mad(_63, _2079, mad(_62, _2078, (_2077 * _61)));
                        } else {
                          _2092 = _2077;
                          _2093 = _2078;
                          _2094 = _2079;
                        }
                        float _2104 = exp2(log2(_2092 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2105 = exp2(log2(_2093 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2106 = exp2(log2(_2094 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2847 = exp2(log2((1.0f / ((_2104 * 18.6875f) + 1.0f)) * ((_2104 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2848 = exp2(log2((1.0f / ((_2105 * 18.6875f) + 1.0f)) * ((_2105 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2849 = exp2(log2((1.0f / ((_2106 * 18.6875f) + 1.0f)) * ((_2106 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2185 = cb0_012z * _1407;
          float _2186 = cb0_012z * _1408;
          float _2187 = cb0_012z * _1409;
          float _2190 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _2187, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _2186, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _2185)));
          float _2193 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _2187, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _2186, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _2185)));
          float _2196 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _2187, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _2186, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _2185)));
          float _2200 = max(max(_2190, _2193), _2196);
          float _2205 = (max(_2200, 1.000000013351432e-10f) - max(min(min(_2190, _2193), _2196), 1.000000013351432e-10f)) / max(_2200, 0.009999999776482582f);
          float _2218 = ((_2193 + _2190) + _2196) + (sqrt((((_2196 - _2193) * _2196) + ((_2193 - _2190) * _2193)) + ((_2190 - _2196) * _2190)) * 1.75f);
          float _2219 = _2218 * 0.3333333432674408f;
          float _2220 = _2205 + -0.4000000059604645f;
          float _2221 = _2220 * 5.0f;
          float _2225 = max((1.0f - abs(_2220 * 2.5f)), 0.0f);
          float _2236 = ((float((int)(((int)(uint)((bool)(_2221 > 0.0f))) - ((int)(uint)((bool)(_2221 < 0.0f))))) * (1.0f - (_2225 * _2225))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2219 <= 0.0533333346247673f)) {
              if (!(_2219 >= 0.1599999964237213f)) {
                _2245 = (((0.23999999463558197f / _2218) + -0.5f) * _2236);
              } else {
                _2245 = 0.0f;
              }
            } else {
              _2245 = _2236;
            }
            float _2246 = _2245 + 1.0f;
            float _2247 = _2246 * _2190;
            float _2248 = _2246 * _2193;
            float _2249 = _2246 * _2196;
            do {
              if (!((bool)(_2247 == _2248) && (bool)(_2248 == _2249))) {
                float _2256 = ((_2247 * 2.0f) - _2248) - _2249;
                float _2259 = ((_2193 - _2196) * 1.7320507764816284f) * _2246;
                float _2261 = atan(_2259 / _2256);
                bool _2264 = (_2256 < 0.0f);
                bool _2265 = (_2256 == 0.0f);
                bool _2266 = (_2259 >= 0.0f);
                bool _2267 = (_2259 < 0.0f);
                float _2276 = select((_2266 && _2265), 90.0f, select((_2267 && _2265), -90.0f, (select((_2267 && _2264), (_2261 + -3.1415927410125732f), select((_2266 && _2264), (_2261 + 3.1415927410125732f), _2261)) * 57.2957763671875f)));
                if (_2276 < 0.0f) {
                  _2281 = (_2276 + 360.0f);
                } else {
                  _2281 = _2276;
                }
              } else {
                _2281 = 0.0f;
              }
              float _2283 = min(max(_2281, 0.0f), 360.0f);
              do {
                if (_2283 < -180.0f) {
                  _2292 = (_2283 + 360.0f);
                } else {
                  if (_2283 > 180.0f) {
                    _2292 = (_2283 + -360.0f);
                  } else {
                    _2292 = _2283;
                  }
                }
                do {
                  if ((bool)(_2292 > -67.5f) && (bool)(_2292 < 67.5f)) {
                    float _2298 = (_2292 + 67.5f) * 0.029629629105329514f;
                    int _2299 = int(_2298);
                    float _2301 = _2298 - float((int)(_2299));
                    float _2302 = _2301 * _2301;
                    float _2303 = _2302 * _2301;
                    if (_2299 == 3) {
                      _2331 = (((0.1666666716337204f - (_2301 * 0.5f)) + (_2302 * 0.5f)) - (_2303 * 0.1666666716337204f));
                    } else {
                      if (_2299 == 2) {
                        _2331 = ((0.6666666865348816f - _2302) + (_2303 * 0.5f));
                      } else {
                        if (_2299 == 1) {
                          _2331 = (((_2303 * -0.5f) + 0.1666666716337204f) + ((_2302 + _2301) * 0.5f));
                        } else {
                          _2331 = select((_2299 == 0), (_2303 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2331 = 0.0f;
                  }
                  float _2340 = min(max(((((_2205 * 0.27000001072883606f) * (0.029999999329447746f - _2247)) * _2331) + _2247), 0.0f), 65535.0f);
                  float _2341 = min(max(_2248, 0.0f), 65535.0f);
                  float _2342 = min(max(_2249, 0.0f), 65535.0f);
                  float _2355 = min(max(mad(-0.21492856740951538f, _2342, mad(-0.2365107536315918f, _2341, (_2340 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2356 = min(max(mad(-0.09967592358589172f, _2342, mad(1.17622971534729f, _2341, (_2340 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2357 = min(max(mad(0.9977163076400757f, _2342, mad(-0.006032449658960104f, _2341, (_2340 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2358 = dot(float3(_2355, _2356, _2357), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2369 = log2(max((lerp(_2358, _2355, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2370 = _2369 * 0.3010300099849701f;
                  float _2371 = log2(cb0_008x);
                  float _2372 = _2371 * 0.3010300099849701f;
                  do {
                    if (!(!(_2370 <= _2372))) {
                      _2441 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2379 = log2(cb0_009x);
                      float _2380 = _2379 * 0.3010300099849701f;
                      if ((bool)(_2370 > _2372) && (bool)(_2370 < _2380)) {
                        float _2388 = ((_2369 - _2371) * 0.9030900001525879f) / ((_2379 - _2371) * 0.3010300099849701f);
                        int _2389 = int(_2388);
                        float _2391 = _2388 - float((int)(_2389));
                        float _2393 = _17[_2389];
                        float _2396 = _17[(_2389 + 1)];
                        float _2401 = _2393 * 0.5f;
                        _2441 = dot(float3((_2391 * _2391), _2391, 1.0f), float3(mad((_17[(_2389 + 2)]), 0.5f, mad(_2396, -1.0f, _2401)), (_2396 - _2393), mad(_2396, 0.5f, _2401)));
                      } else {
                        do {
                          if (!(!(_2370 >= _2380))) {
                            float _2410 = log2(cb0_008z);
                            if (_2370 < (_2410 * 0.3010300099849701f)) {
                              float _2418 = ((_2369 - _2379) * 0.9030900001525879f) / ((_2410 - _2379) * 0.3010300099849701f);
                              int _2419 = int(_2418);
                              float _2421 = _2418 - float((int)(_2419));
                              float _2423 = _18[_2419];
                              float _2426 = _18[(_2419 + 1)];
                              float _2431 = _2423 * 0.5f;
                              _2441 = dot(float3((_2421 * _2421), _2421, 1.0f), float3(mad((_18[(_2419 + 2)]), 0.5f, mad(_2426, -1.0f, _2431)), (_2426 - _2423), mad(_2426, 0.5f, _2431)));
                              break;
                            }
                          }
                          _2441 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2445 = log2(max((lerp(_2358, _2356, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2446 = _2445 * 0.3010300099849701f;
                    do {
                      if (!(!(_2446 <= _2372))) {
                        _2515 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2453 = log2(cb0_009x);
                        float _2454 = _2453 * 0.3010300099849701f;
                        if ((bool)(_2446 > _2372) && (bool)(_2446 < _2454)) {
                          float _2462 = ((_2445 - _2371) * 0.9030900001525879f) / ((_2453 - _2371) * 0.3010300099849701f);
                          int _2463 = int(_2462);
                          float _2465 = _2462 - float((int)(_2463));
                          float _2467 = _17[_2463];
                          float _2470 = _17[(_2463 + 1)];
                          float _2475 = _2467 * 0.5f;
                          _2515 = dot(float3((_2465 * _2465), _2465, 1.0f), float3(mad((_17[(_2463 + 2)]), 0.5f, mad(_2470, -1.0f, _2475)), (_2470 - _2467), mad(_2470, 0.5f, _2475)));
                        } else {
                          do {
                            if (!(!(_2446 >= _2454))) {
                              float _2484 = log2(cb0_008z);
                              if (_2446 < (_2484 * 0.3010300099849701f)) {
                                float _2492 = ((_2445 - _2453) * 0.9030900001525879f) / ((_2484 - _2453) * 0.3010300099849701f);
                                int _2493 = int(_2492);
                                float _2495 = _2492 - float((int)(_2493));
                                float _2497 = _18[_2493];
                                float _2500 = _18[(_2493 + 1)];
                                float _2505 = _2497 * 0.5f;
                                _2515 = dot(float3((_2495 * _2495), _2495, 1.0f), float3(mad((_18[(_2493 + 2)]), 0.5f, mad(_2500, -1.0f, _2505)), (_2500 - _2497), mad(_2500, 0.5f, _2505)));
                                break;
                              }
                            }
                            _2515 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2519 = log2(max((lerp(_2358, _2357, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2520 = _2519 * 0.3010300099849701f;
                      do {
                        if (!(!(_2520 <= _2372))) {
                          _2589 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2527 = log2(cb0_009x);
                          float _2528 = _2527 * 0.3010300099849701f;
                          if ((bool)(_2520 > _2372) && (bool)(_2520 < _2528)) {
                            float _2536 = ((_2519 - _2371) * 0.9030900001525879f) / ((_2527 - _2371) * 0.3010300099849701f);
                            int _2537 = int(_2536);
                            float _2539 = _2536 - float((int)(_2537));
                            float _2541 = _17[_2537];
                            float _2544 = _17[(_2537 + 1)];
                            float _2549 = _2541 * 0.5f;
                            _2589 = dot(float3((_2539 * _2539), _2539, 1.0f), float3(mad((_17[(_2537 + 2)]), 0.5f, mad(_2544, -1.0f, _2549)), (_2544 - _2541), mad(_2544, 0.5f, _2549)));
                          } else {
                            do {
                              if (!(!(_2520 >= _2528))) {
                                float _2558 = log2(cb0_008z);
                                if (_2520 < (_2558 * 0.3010300099849701f)) {
                                  float _2566 = ((_2519 - _2527) * 0.9030900001525879f) / ((_2558 - _2527) * 0.3010300099849701f);
                                  int _2567 = int(_2566);
                                  float _2569 = _2566 - float((int)(_2567));
                                  float _2571 = _18[_2567];
                                  float _2574 = _18[(_2567 + 1)];
                                  float _2579 = _2571 * 0.5f;
                                  _2589 = dot(float3((_2569 * _2569), _2569, 1.0f), float3(mad((_18[(_2567 + 2)]), 0.5f, mad(_2574, -1.0f, _2579)), (_2574 - _2571), mad(_2574, 0.5f, _2579)));
                                  break;
                                }
                              }
                              _2589 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2593 = cb0_008w - cb0_008y;
                        float _2594 = (exp2(_2441 * 3.321928024291992f) - cb0_008y) / _2593;
                        float _2596 = (exp2(_2515 * 3.321928024291992f) - cb0_008y) / _2593;
                        float _2598 = (exp2(_2589 * 3.321928024291992f) - cb0_008y) / _2593;
                        float _2601 = mad(0.15618768334388733f, _2598, mad(0.13400420546531677f, _2596, (_2594 * 0.6624541878700256f)));
                        float _2604 = mad(0.053689517080783844f, _2598, mad(0.6740817427635193f, _2596, (_2594 * 0.2722287178039551f)));
                        float _2607 = mad(1.0103391408920288f, _2598, mad(0.00406073359772563f, _2596, (_2594 * -0.005574649665504694f)));
                        float _2620 = min(max(mad(-0.23642469942569733f, _2607, mad(-0.32480329275131226f, _2604, (_2601 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2621 = min(max(mad(0.016756348311901093f, _2607, mad(1.6153316497802734f, _2604, (_2601 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2622 = min(max(mad(0.9883948564529419f, _2607, mad(-0.008284442126750946f, _2604, (_2601 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2625 = mad(0.15618768334388733f, _2622, mad(0.13400420546531677f, _2621, (_2620 * 0.6624541878700256f)));
                        float _2628 = mad(0.053689517080783844f, _2622, mad(0.6740817427635193f, _2621, (_2620 * 0.2722287178039551f)));
                        float _2631 = mad(1.0103391408920288f, _2622, mad(0.00406073359772563f, _2621, (_2620 * -0.005574649665504694f)));
                        float _2653 = min(max((min(max(mad(-0.23642469942569733f, _2631, mad(-0.32480329275131226f, _2628, (_2625 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2654 = min(max((min(max(mad(0.016756348311901093f, _2631, mad(1.6153316497802734f, _2628, (_2625 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2655 = min(max((min(max(mad(0.9883948564529419f, _2631, mad(-0.008284442126750946f, _2628, (_2625 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2668 = mad(_57, _2655, mad(_56, _2654, (_2653 * _55)));
                            _2669 = mad(_60, _2655, mad(_59, _2654, (_2653 * _58)));
                            _2670 = mad(_63, _2655, mad(_62, _2654, (_2653 * _61)));
                          } else {
                            _2668 = _2653;
                            _2669 = _2654;
                            _2670 = _2655;
                          }
                          float _2680 = exp2(log2(_2668 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2681 = exp2(log2(_2669 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2682 = exp2(log2(_2670 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2847 = exp2(log2((1.0f / ((_2680 * 18.6875f) + 1.0f)) * ((_2680 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2848 = exp2(log2((1.0f / ((_2681 * 18.6875f) + 1.0f)) * ((_2681 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2849 = exp2(log2((1.0f / ((_2682 * 18.6875f) + 1.0f)) * ((_2682 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2727 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1409, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1408, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1407)));
            float _2730 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1409, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1408, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1407)));
            float _2733 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1409, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1408, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1407)));
            float _2752 = exp2(log2(mad(_57, _2733, mad(_56, _2730, (_2727 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2753 = exp2(log2(mad(_60, _2733, mad(_59, _2730, (_2727 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2754 = exp2(log2(mad(_63, _2733, mad(_62, _2730, (_2727 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2847 = exp2(log2((1.0f / ((_2752 * 18.6875f) + 1.0f)) * ((_2752 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2848 = exp2(log2((1.0f / ((_2753 * 18.6875f) + 1.0f)) * ((_2753 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2849 = exp2(log2((1.0f / ((_2754 * 18.6875f) + 1.0f)) * ((_2754 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2801 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1397, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1396, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1395)));
                float _2804 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1397, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1396, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1395)));
                float _2807 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1397, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1396, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1395)));
                _2847 = mad(_57, _2807, mad(_56, _2804, (_2801 * _55)));
                _2848 = mad(_60, _2807, mad(_59, _2804, (_2801 * _58)));
                _2849 = mad(_63, _2807, mad(_62, _2804, (_2801 * _61)));
              } else {
                float _2820 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1421)));
                float _2823 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1421)));
                float _2826 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1423, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1422, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1421)));
                _2847 = exp2(log2(mad(_57, _2826, mad(_56, _2823, (_2820 * _55)))) * cb0_040z);
                _2848 = exp2(log2(mad(_60, _2826, mad(_59, _2823, (_2820 * _58)))) * cb0_040z);
                _2849 = exp2(log2(mad(_63, _2826, mad(_62, _2823, (_2820 * _61)))) * cb0_040z);
              }
            } else {
              _2847 = _1407;
              _2848 = _1408;
              _2849 = _1409;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2847 * 0.9523810148239136f), (_2848 * 0.9523810148239136f), (_2849 * 0.9523810148239136f), 0.0f);
}
