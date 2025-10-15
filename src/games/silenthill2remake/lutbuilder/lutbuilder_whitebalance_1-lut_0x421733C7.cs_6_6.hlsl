#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _11[6];
  float _12[6];
  float _13[6];
  float _14[6];
  float _24 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _25 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _28 = float((uint)SV_DispatchThreadID.z);
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _56;
  float _57;
  float _115;
  float _116;
  float _117;
  float _166;
  float _895;
  float _931;
  float _942;
  float _1006;
  float _1185;
  float _1196;
  float _1207;
  float _1378;
  float _1379;
  float _1380;
  float _1391;
  float _1402;
  float _1584;
  float _1620;
  float _1631;
  float _1670;
  float _1780;
  float _1854;
  float _1928;
  float _2007;
  float _2008;
  float _2009;
  float _2160;
  float _2196;
  float _2207;
  float _2246;
  float _2356;
  float _2430;
  float _2504;
  float _2583;
  float _2584;
  float _2585;
  float _2762;
  float _2763;
  float _2764;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _38 = (output_gamut == 4);
        _49 = select(_38, 1.0f, 1.7050515413284302f);
        _50 = select(_38, 0.0f, -0.6217905879020691f);
        _51 = select(_38, 0.0f, -0.0832584798336029f);
        _52 = select(_38, 0.0f, -0.13025718927383423f);
        _53 = select(_38, 1.0f, 1.1408027410507202f);
        _54 = select(_38, 0.0f, -0.010548528283834457f);
        _55 = select(_38, 0.0f, -0.024003278464078903f);
        _56 = select(_38, 0.0f, -0.1289687603712082f);
        _57 = select(_38, 1.0f, 1.152971863746643f);
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
      _49 = 1.02579927444458f;
      _50 = -0.020052503794431686f;
      _51 = -0.0057713985443115234f;
      _52 = -0.0022350111976265907f;
      _53 = 1.0045825242996216f;
      _54 = -0.002352306619286537f;
      _55 = -0.005014004185795784f;
      _56 = -0.025293385609984398f;
      _57 = 1.0304402112960815f;
    }
  } else {
    _49 = 1.379158854484558f;
    _50 = -0.3088507056236267f;
    _51 = -0.07034677267074585f;
    _52 = -0.06933528929948807f;
    _53 = 1.0822921991348267f;
    _54 = -0.012962047010660172f;
    _55 = -0.002159259282052517f;
    _56 = -0.045465391129255295f;
    _57 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _68 = exp2(log2(_24 * 1.0322580337524414f) * 0.012683313339948654f);
    float _69 = exp2(log2(_25 * 1.0322580337524414f) * 0.012683313339948654f);
    float _70 = exp2(log2(_28 * 0.032258063554763794f) * 0.012683313339948654f);
    _115 = (exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _116 = (exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _117 = (exp2(log2(max(0.0f, (_70 + -0.8359375f)) / (18.8515625f - (_70 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _115 = ((exp2((_24 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _116 = ((exp2((_25 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _117 = ((exp2((_28 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  bool _144 = (cb0_038z != 0);
  float _149 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _166 = (((((2967800.0f - (_149 * 4607000064.0f)) * _149) + 99.11000061035156f) * _149) + 0.24406300485134125f);
  } else {
    _166 = (((((1901800.0f - (_149 * 2006400000.0f)) * _149) + 247.47999572753906f) * _149) + 0.23703999817371368f);
  }
  float _180 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _187 = cb0_035x * cb0_035x;
  float _190 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_187 * 1.6145605741257896e-07f));
  float _195 = ((_180 * 2.0f) + 4.0f) - (_190 * 8.0f);
  float _196 = (_180 * 3.0f) / _195;
  float _198 = (_190 * 2.0f) / _195;
  bool _199 = (cb0_035x < 4000.0f);
  float _208 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _210 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_187 * 1.5317699909210205f)) / (_208 * _208);
  float _217 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _187;
  float _219 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_187 * 308.60699462890625f)) / (_217 * _217);
  float _221 = rsqrt(dot(float2(_210, _219), float2(_210, _219)));
  float _222 = cb0_035y * 0.05000000074505806f;
  float _225 = ((_222 * _219) * _221) + _180;
  float _228 = _190 - ((_222 * _210) * _221);
  float _233 = (4.0f - (_228 * 8.0f)) + (_225 * 2.0f);
  float _239 = (((_225 * 3.0f) / _233) - _196) + select(_199, _196, _166);
  float _240 = (((_228 * 2.0f) / _233) - _198) + select(_199, _198, (((_166 * 2.869999885559082f) + -0.2750000059604645f) - ((_166 * _166) * 3.0f)));
  float _241 = select(_144, _239, 0.3127000033855438f);
  float _242 = select(_144, _240, 0.32899999618530273f);
  float _243 = select(_144, 0.3127000033855438f, _239);
  float _244 = select(_144, 0.32899999618530273f, _240);
  float _245 = max(_242, 1.000000013351432e-10f);
  float _246 = _241 / _245;
  float _249 = ((1.0f - _241) - _242) / _245;
  float _250 = max(_244, 1.000000013351432e-10f);
  float _251 = _243 / _250;
  float _254 = ((1.0f - _243) - _244) / _250;
  float _273 = mad(-0.16140000522136688f, _254, ((_251 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _249, ((_246 * 0.8950999975204468f) + 0.266400009393692f));
  float _274 = mad(0.03669999912381172f, _254, (1.7135000228881836f - (_251 * 0.7501999735832214f))) / mad(0.03669999912381172f, _249, (1.7135000228881836f - (_246 * 0.7501999735832214f)));
  float _275 = mad(1.0296000242233276f, _254, ((_251 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _249, ((_246 * 0.03889999911189079f) + -0.06849999725818634f));
  float _276 = mad(_274, -0.7501999735832214f, 0.0f);
  float _277 = mad(_274, 1.7135000228881836f, 0.0f);
  float _278 = mad(_274, 0.03669999912381172f, -0.0f);
  float _279 = mad(_275, 0.03889999911189079f, 0.0f);
  float _280 = mad(_275, -0.06849999725818634f, 0.0f);
  float _281 = mad(_275, 1.0296000242233276f, 0.0f);
  float _284 = mad(0.1599626988172531f, _279, mad(-0.1470542997121811f, _276, (_273 * 0.883457362651825f)));
  float _287 = mad(0.1599626988172531f, _280, mad(-0.1470542997121811f, _277, (_273 * 0.26293492317199707f)));
  float _290 = mad(0.1599626988172531f, _281, mad(-0.1470542997121811f, _278, (_273 * -0.15930065512657166f)));
  float _293 = mad(0.04929120093584061f, _279, mad(0.5183603167533875f, _276, (_273 * 0.38695648312568665f)));
  float _296 = mad(0.04929120093584061f, _280, mad(0.5183603167533875f, _277, (_273 * 0.11516613513231277f)));
  float _299 = mad(0.04929120093584061f, _281, mad(0.5183603167533875f, _278, (_273 * -0.0697740763425827f)));
  float _302 = mad(0.9684867262840271f, _279, mad(0.04004279896616936f, _276, (_273 * -0.007634039502590895f)));
  float _305 = mad(0.9684867262840271f, _280, mad(0.04004279896616936f, _277, (_273 * -0.0022720457054674625f)));
  float _308 = mad(0.9684867262840271f, _281, mad(0.04004279896616936f, _278, (_273 * 0.0013765322510153055f)));
  float _311 = mad(_290, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_287, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_284 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _314 = mad(_290, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_287, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_284 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _317 = mad(_290, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_287, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_284 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _320 = mad(_299, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_296, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_293 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _323 = mad(_299, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_296, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_293 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _326 = mad(_299, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_296, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_293 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _329 = mad(_308, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_305, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_302 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _332 = mad(_308, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_305, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_302 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _335 = mad(_308, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_305, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_302 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _365 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _335, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _326, (_317 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _117, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _332, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _323, (_314 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _116, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _329, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _320, (_311 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _115)));
  float _368 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _335, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _326, (_317 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _117, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _332, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _323, (_314 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _116, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _329, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _320, (_311 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _115)));
  float _371 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _335, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _326, (_317 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _117, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _332, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _323, (_314 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _116, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _329, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _320, (_311 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _115)));
  float _386 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _371, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _368, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _365)));
  float _389 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _371, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _368, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _365)));
  float _392 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _371, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _368, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _365)));
  float _393 = dot(float3(_386, _389, _392), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _397 = (_386 / _393) + -1.0f;
  float _398 = (_389 / _393) + -1.0f;
  float _399 = (_392 / _393) + -1.0f;
  float _411 = (1.0f - exp2(((_393 * _393) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_397, _398, _399), float3(_397, _398, _399)) * -4.0f));
  float _427 = ((mad(-0.06368283927440643f, _392, mad(-0.32929131388664246f, _389, (_386 * 1.370412826538086f))) - _386) * _411) + _386;
  float _428 = ((mad(-0.010861567221581936f, _392, mad(1.0970908403396606f, _389, (_386 * -0.08343426138162613f))) - _389) * _411) + _389;

#if 1
  float _795, _797, _799;
  ApplyColorCorrection(
      _411, _427, _428,
      _795, _797, _799,
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
  float _429 = ((mad(1.203694462776184f, _392, mad(-0.09862564504146576f, _389, (_386 * -0.02579325996339321f))) - _392) * _411) + _392;
  float _430 = dot(float3(_427, _428, _429), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _444 = cb0_019w + cb0_024w;
  float _458 = cb0_018w * cb0_023w;
  float _472 = cb0_017w * cb0_022w;
  float _486 = cb0_016w * cb0_021w;
  float _500 = cb0_015w * cb0_020w;
  float _504 = _427 - _430;
  float _505 = _428 - _430;
  float _506 = _429 - _430;
  float _563 = saturate(_430 / cb0_035z);
  float _567 = (_563 * _563) * (3.0f - (_563 * 2.0f));
  float _568 = 1.0f - _567;
  float _577 = cb0_019w + cb0_034w;
  float _586 = cb0_018w * cb0_033w;
  float _595 = cb0_017w * cb0_032w;
  float _604 = cb0_016w * cb0_031w;
  float _613 = cb0_015w * cb0_030w;
  float _677 = saturate((_430 - cb0_035w) / (cb0_036x - cb0_035w));
  float _681 = (_677 * _677) * (3.0f - (_677 * 2.0f));
  float _690 = cb0_019w + cb0_029w;
  float _699 = cb0_018w * cb0_028w;
  float _708 = cb0_017w * cb0_027w;
  float _717 = cb0_016w * cb0_026w;
  float _726 = cb0_015w * cb0_025w;
  float _784 = _567 - _681;
  float _795 = ((_681 * (((cb0_019x + cb0_034x) + _577) + (((cb0_018x * cb0_033x) * _586) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _604) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _613) * _504) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _595)))))) + (_568 * (((cb0_019x + cb0_024x) + _444) + (((cb0_018x * cb0_023x) * _458) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _486) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _500) * _504) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _472))))))) + ((((cb0_019x + cb0_029x) + _690) + (((cb0_018x * cb0_028x) * _699) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _717) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _726) * _504) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _708))))) * _784);
  float _797 = ((_681 * (((cb0_019y + cb0_034y) + _577) + (((cb0_018y * cb0_033y) * _586) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _604) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _613) * _505) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _595)))))) + (_568 * (((cb0_019y + cb0_024y) + _444) + (((cb0_018y * cb0_023y) * _458) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _486) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _500) * _505) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _472))))))) + ((((cb0_019y + cb0_029y) + _690) + (((cb0_018y * cb0_028y) * _699) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _717) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _726) * _505) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _708))))) * _784);
  float _799 = ((_681 * (((cb0_019z + cb0_034z) + _577) + (((cb0_018z * cb0_033z) * _586) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _604) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _613) * _506) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _595)))))) + (_568 * (((cb0_019z + cb0_024z) + _444) + (((cb0_018z * cb0_023z) * _458) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _486) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _500) * _506) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _472))))))) + ((((cb0_019z + cb0_029z) + _690) + (((cb0_018z * cb0_028z) * _699) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _717) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _726) * _506) + _430)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _708))))) * _784);
#endif
  float _835 = ((mad(0.061360642313957214f, _799, mad(-4.540197551250458e-09f, _797, (_795 * 0.9386394023895264f))) - _795) * cb0_036y) + _795;
  float _836 = ((mad(0.169205904006958f, _799, mad(0.8307942152023315f, _797, (_795 * 6.775371730327606e-08f))) - _797) * cb0_036y) + _797;
  float _837 = (mad(-2.3283064365386963e-10f, _797, (_795 * -9.313225746154785e-10f)) * cb0_036y) + _799;
  float _840 = mad(0.16386905312538147f, _837, mad(0.14067868888378143f, _836, (_835 * 0.6954522132873535f)));
  float _843 = mad(0.0955343246459961f, _837, mad(0.8596711158752441f, _836, (_835 * 0.044794581830501556f)));
  float _846 = mad(1.0015007257461548f, _837, mad(0.004025210160762072f, _836, (_835 * -0.005525882821530104f)));
  float _850 = max(max(_840, _843), _846);
  float _855 = (max(_850, 1.000000013351432e-10f) - max(min(min(_840, _843), _846), 1.000000013351432e-10f)) / max(_850, 0.009999999776482582f);
  float _868 = ((_843 + _840) + _846) + (sqrt((((_846 - _843) * _846) + ((_843 - _840) * _843)) + ((_840 - _846) * _840)) * 1.75f);
  float _869 = _868 * 0.3333333432674408f;
  float _870 = _855 + -0.4000000059604645f;
  float _871 = _870 * 5.0f;
  float _875 = max((1.0f - abs(_870 * 2.5f)), 0.0f);
  float _886 = ((float((int)(((int)(uint)((bool)(_871 > 0.0f))) - ((int)(uint)((bool)(_871 < 0.0f))))) * (1.0f - (_875 * _875))) + 1.0f) * 0.02500000037252903f;
  if (!(_869 <= 0.0533333346247673f)) {
    if (!(_869 >= 0.1599999964237213f)) {
      _895 = (((0.23999999463558197f / _868) + -0.5f) * _886);
    } else {
      _895 = 0.0f;
    }
  } else {
    _895 = _886;
  }
  float _896 = _895 + 1.0f;
  float _897 = _896 * _840;
  float _898 = _896 * _843;
  float _899 = _896 * _846;
  if (!((bool)(_897 == _898) && (bool)(_898 == _899))) {
    float _906 = ((_897 * 2.0f) - _898) - _899;
    float _909 = ((_843 - _846) * 1.7320507764816284f) * _896;
    float _911 = atan(_909 / _906);
    bool _914 = (_906 < 0.0f);
    bool _915 = (_906 == 0.0f);
    bool _916 = (_909 >= 0.0f);
    bool _917 = (_909 < 0.0f);
    float _926 = select((_916 && _915), 90.0f, select((_917 && _915), -90.0f, (select((_917 && _914), (_911 + -3.1415927410125732f), select((_916 && _914), (_911 + 3.1415927410125732f), _911)) * 57.2957763671875f)));
    if (_926 < 0.0f) {
      _931 = (_926 + 360.0f);
    } else {
      _931 = _926;
    }
  } else {
    _931 = 0.0f;
  }
  float _933 = min(max(_931, 0.0f), 360.0f);
  if (_933 < -180.0f) {
    _942 = (_933 + 360.0f);
  } else {
    if (_933 > 180.0f) {
      _942 = (_933 + -360.0f);
    } else {
      _942 = _933;
    }
  }
  float _946 = saturate(1.0f - abs(_942 * 0.014814814552664757f));
  float _950 = (_946 * _946) * (3.0f - (_946 * 2.0f));
  float _956 = ((_950 * _950) * ((_855 * 0.18000000715255737f) * (0.029999999329447746f - _897))) + _897;
  float _966 = max(0.0f, mad(-0.21492856740951538f, _899, mad(-0.2365107536315918f, _898, (_956 * 1.4514392614364624f))));
  float _967 = max(0.0f, mad(-0.09967592358589172f, _899, mad(1.17622971534729f, _898, (_956 * -0.07655377686023712f))));
  float _968 = max(0.0f, mad(0.9977163076400757f, _899, mad(-0.006032449658960104f, _898, (_956 * 0.008316148072481155f))));
  float _969 = dot(float3(_966, _967, _968), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1015 = log2(lerp(_969, _966, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1016 = log2(lerp(_969, _967, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1017 = log2(lerp(_969, _968, 0.9599999785423279f)) * 0.3010300099849701f;

#if 1
  float _1157, _1158, _1159;
  ApplyFilmicToneMap(_1015, _1016, _1017,
                     _835, _836, _837,
                     _1157, _1158, _1159);
#else
  float _983 = (cb0_037w + 1.0f) - cb0_037y;
  float _986 = cb0_038x + 1.0f;
  float _988 = _986 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _1006 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _997 = (cb0_037w + 0.18000000715255737f) / _983;
    _1006 = (-0.7447274923324585f - ((log2(_997 / (2.0f - _997)) * 0.3465735912322998f) * (_983 / cb0_037x)));
  }
  float _1009 = ((1.0f - cb0_037y) / cb0_037x) - _1006;
  float _1011 = (cb0_037z / cb0_037x) - _1009;
  float _1021 = cb0_037x * (_1015 + _1009);
  float _1022 = cb0_037x * (_1016 + _1009);
  float _1023 = cb0_037x * (_1017 + _1009);
  float _1024 = _983 * 2.0f;
  float _1026 = (cb0_037x * -2.0f) / _983;
  float _1027 = _1015 - _1006;
  float _1028 = _1016 - _1006;
  float _1029 = _1017 - _1006;
  float _1048 = _988 * 2.0f;
  float _1050 = (cb0_037x * 2.0f) / _988;
  float _1075 = select((_1015 < _1006), ((_1024 / (exp2((_1027 * 1.4426950216293335f) * _1026) + 1.0f)) - cb0_037w), _1021);
  float _1076 = select((_1016 < _1006), ((_1024 / (exp2((_1028 * 1.4426950216293335f) * _1026) + 1.0f)) - cb0_037w), _1022);
  float _1077 = select((_1017 < _1006), ((_1024 / (exp2((_1029 * 1.4426950216293335f) * _1026) + 1.0f)) - cb0_037w), _1023);
  float _1084 = _1011 - _1006;
  float _1088 = saturate(_1027 / _1084);
  float _1089 = saturate(_1028 / _1084);
  float _1090 = saturate(_1029 / _1084);
  bool _1091 = (_1011 < _1006);
  float _1095 = select(_1091, (1.0f - _1088), _1088);
  float _1096 = select(_1091, (1.0f - _1089), _1089);
  float _1097 = select(_1091, (1.0f - _1090), _1090);
  float _1116 = (((_1095 * _1095) * (select((_1015 > _1011), (_986 - (_1048 / (exp2(((_1015 - _1011) * 1.4426950216293335f) * _1050) + 1.0f))), _1021) - _1075)) * (3.0f - (_1095 * 2.0f))) + _1075;
  float _1117 = (((_1096 * _1096) * (select((_1016 > _1011), (_986 - (_1048 / (exp2(((_1016 - _1011) * 1.4426950216293335f) * _1050) + 1.0f))), _1022) - _1076)) * (3.0f - (_1096 * 2.0f))) + _1076;
  float _1118 = (((_1097 * _1097) * (select((_1017 > _1011), (_986 - (_1048 / (exp2(((_1017 - _1011) * 1.4426950216293335f) * _1050) + 1.0f))), _1023) - _1077)) * (3.0f - (_1097 * 2.0f))) + _1077;
  float _1119 = dot(float3(_1116, _1117, _1118), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1139 = (cb0_036w * (max(0.0f, (lerp(_1119, _1116, 0.9300000071525574f))) - _835)) + _835;
  float _1140 = (cb0_036w * (max(0.0f, (lerp(_1119, _1117, 0.9300000071525574f))) - _836)) + _836;
  float _1141 = (cb0_036w * (max(0.0f, (lerp(_1119, _1118, 0.9300000071525574f))) - _837)) + _837;
  float _1157 = ((mad(-0.06537103652954102f, _1141, mad(1.451815478503704e-06f, _1140, (_1139 * 1.065374732017517f))) - _1139) * cb0_036y) + _1139;
  float _1158 = ((mad(-0.20366770029067993f, _1141, mad(1.2036634683609009f, _1140, (_1139 * -2.57161445915699e-07f))) - _1140) * cb0_036y) + _1140;
  float _1159 = ((mad(0.9999996423721313f, _1141, mad(2.0954757928848267e-08f, _1140, (_1139 * 1.862645149230957e-08f))) - _1141) * cb0_036y) + _1141;
#endif
  float _1172 = ((mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1159, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1158, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1157)))));
  float _1173 = ((mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1159, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1158, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1157)))));
  float _1174 = ((mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1159, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1158, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1157)))));

#if 1
  float _1273, _1274, _1275;
  SampleLUTUpgradeToneMap(
      float3(_1172, _1173, _1174),
      s0,
      t0,
      _1273, _1274, _1275);
#else
  if (_1172 < 0.0031306699384003878f) {
    _1185 = (_1172 * 12.920000076293945f);
  } else {
    _1185 = (((pow(_1172, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1173 < 0.0031306699384003878f) {
    _1196 = (_1173 * 12.920000076293945f);
  } else {
    _1196 = (((pow(_1173, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1174 < 0.0031306699384003878f) {
    _1207 = (_1174 * 12.920000076293945f);
  } else {
    _1207 = (((pow(_1174, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1211 = (_1196 * 0.9375f) + 0.03125f;
  float _1218 = _1207 * 15.0f;
  float _1219 = floor(_1218);
  float _1220 = _1218 - _1219;
  float _1222 = (((_1185 * 0.9375f) + 0.03125f) + _1219) * 0.0625f;
  float4 _1225 = t0.SampleLevel(s0, float2(_1222, _1211), 0.0f);
  float4 _1230 = t0.SampleLevel(s0, float2((_1222 + 0.0625f), _1211), 0.0f);
  float _1249 = max(6.103519990574569e-05f, (((lerp(_1225.x, _1230.x, _1220))*cb0_005y) + (cb0_005x * _1185)));
  float _1250 = max(6.103519990574569e-05f, (((lerp(_1225.y, _1230.y, _1220))*cb0_005y) + (cb0_005x * _1196)));
  float _1251 = max(6.103519990574569e-05f, (((lerp(_1225.z, _1230.z, _1220))*cb0_005y) + (cb0_005x * _1207)));
  float _1273 = select((_1249 > 0.040449999272823334f), exp2(log2((_1249 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1249 * 0.07739938050508499f));
  float _1274 = select((_1250 > 0.040449999272823334f), exp2(log2((_1250 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1250 * 0.07739938050508499f));
  float _1275 = select((_1251 > 0.040449999272823334f), exp2(log2((_1251 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1251 * 0.07739938050508499f));
#endif
  float _1301 = cb0_014x * (((cb0_039y + (cb0_039x * _1273)) * _1273) + cb0_039z);
  float _1302 = cb0_014y * (((cb0_039y + (cb0_039x * _1274)) * _1274) + cb0_039z);
  float _1303 = cb0_014z * (((cb0_039y + (cb0_039x * _1275)) * _1275) + cb0_039z);
  float _1310 = ((cb0_013x - _1301) * cb0_013w) + _1301;
  float _1311 = ((cb0_013y - _1302) * cb0_013w) + _1302;
  float _1312 = ((cb0_013z - _1303) * cb0_013w) + _1303;

  if (GenerateOutput(_1310, _1311, _1312, u0[SV_DispatchThreadID])) {
    return;
  }

  float _1313 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _799, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _797, (_795 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1314 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _799, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _797, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _795)));
  float _1315 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _799, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _797, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _795)));
  float _1322 = ((cb0_013x - _1313) * cb0_013w) + _1313;
  float _1323 = ((cb0_013y - _1314) * cb0_013w) + _1314;
  float _1324 = ((cb0_013z - _1315) * cb0_013w) + _1315;
  float _1336 = exp2(log2(max(0.0f, _1310)) * cb0_040y);
  float _1337 = exp2(log2(max(0.0f, _1311)) * cb0_040y);
  float _1338 = exp2(log2(max(0.0f, _1312)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1361 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1336)));
        float _1364 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1336)));
        float _1367 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1336)));
        _1378 = mad(_51, _1367, mad(_50, _1364, (_1361 * _49)));
        _1379 = mad(_54, _1367, mad(_53, _1364, (_1361 * _52)));
        _1380 = mad(_57, _1367, mad(_56, _1364, (_1361 * _55)));
      } else {
        _1378 = _1336;
        _1379 = _1337;
        _1380 = _1338;
      }
      do {
        if (_1378 < 0.0031306699384003878f) {
          _1391 = (_1378 * 12.920000076293945f);
        } else {
          _1391 = (((pow(_1378, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1379 < 0.0031306699384003878f) {
            _1402 = (_1379 * 12.920000076293945f);
          } else {
            _1402 = (((pow(_1379, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1380 < 0.0031306699384003878f) {
            _2762 = _1391;
            _2763 = _1402;
            _2764 = (_1380 * 12.920000076293945f);
          } else {
            _2762 = _1391;
            _2763 = _1402;
            _2764 = (((pow(_1380, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1429 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1336)));
      float _1432 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1336)));
      float _1435 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1336)));
      float _1445 = max(6.103519990574569e-05f, mad(_51, _1435, mad(_50, _1432, (_1429 * _49))));
      float _1446 = max(6.103519990574569e-05f, mad(_54, _1435, mad(_53, _1432, (_1429 * _52))));
      float _1447 = max(6.103519990574569e-05f, mad(_57, _1435, mad(_56, _1432, (_1429 * _55))));
      _2762 = min((_1445 * 4.5f), ((exp2(log2(max(_1445, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2763 = min((_1446 * 4.5f), ((exp2(log2(max(_1446, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2764 = min((_1447 * 4.5f), ((exp2(log2(max(_1447, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1524 = cb0_012z * _1322;
        float _1525 = cb0_012z * _1323;
        float _1526 = cb0_012z * _1324;
        float _1529 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1526, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1525, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1524)));
        float _1532 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1526, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1525, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1524)));
        float _1535 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1526, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1525, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1524)));
        float _1539 = max(max(_1529, _1532), _1535);
        float _1544 = (max(_1539, 1.000000013351432e-10f) - max(min(min(_1529, _1532), _1535), 1.000000013351432e-10f)) / max(_1539, 0.009999999776482582f);
        float _1557 = ((_1532 + _1529) + _1535) + (sqrt((((_1535 - _1532) * _1535) + ((_1532 - _1529) * _1532)) + ((_1529 - _1535) * _1529)) * 1.75f);
        float _1558 = _1557 * 0.3333333432674408f;
        float _1559 = _1544 + -0.4000000059604645f;
        float _1560 = _1559 * 5.0f;
        float _1564 = max((1.0f - abs(_1559 * 2.5f)), 0.0f);
        float _1575 = ((float((int)(((int)(uint)((bool)(_1560 > 0.0f))) - ((int)(uint)((bool)(_1560 < 0.0f))))) * (1.0f - (_1564 * _1564))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1558 <= 0.0533333346247673f)) {
            if (!(_1558 >= 0.1599999964237213f)) {
              _1584 = (((0.23999999463558197f / _1557) + -0.5f) * _1575);
            } else {
              _1584 = 0.0f;
            }
          } else {
            _1584 = _1575;
          }
          float _1585 = _1584 + 1.0f;
          float _1586 = _1585 * _1529;
          float _1587 = _1585 * _1532;
          float _1588 = _1585 * _1535;
          do {
            if (!((bool)(_1586 == _1587) && (bool)(_1587 == _1588))) {
              float _1595 = ((_1586 * 2.0f) - _1587) - _1588;
              float _1598 = ((_1532 - _1535) * 1.7320507764816284f) * _1585;
              float _1600 = atan(_1598 / _1595);
              bool _1603 = (_1595 < 0.0f);
              bool _1604 = (_1595 == 0.0f);
              bool _1605 = (_1598 >= 0.0f);
              bool _1606 = (_1598 < 0.0f);
              float _1615 = select((_1605 && _1604), 90.0f, select((_1606 && _1604), -90.0f, (select((_1606 && _1603), (_1600 + -3.1415927410125732f), select((_1605 && _1603), (_1600 + 3.1415927410125732f), _1600)) * 57.2957763671875f)));
              if (_1615 < 0.0f) {
                _1620 = (_1615 + 360.0f);
              } else {
                _1620 = _1615;
              }
            } else {
              _1620 = 0.0f;
            }
            float _1622 = min(max(_1620, 0.0f), 360.0f);
            do {
              if (_1622 < -180.0f) {
                _1631 = (_1622 + 360.0f);
              } else {
                if (_1622 > 180.0f) {
                  _1631 = (_1622 + -360.0f);
                } else {
                  _1631 = _1622;
                }
              }
              do {
                if ((bool)(_1631 > -67.5f) && (bool)(_1631 < 67.5f)) {
                  float _1637 = (_1631 + 67.5f) * 0.029629629105329514f;
                  int _1638 = int(_1637);
                  float _1640 = _1637 - float((int)(_1638));
                  float _1641 = _1640 * _1640;
                  float _1642 = _1641 * _1640;
                  if (_1638 == 3) {
                    _1670 = (((0.1666666716337204f - (_1640 * 0.5f)) + (_1641 * 0.5f)) - (_1642 * 0.1666666716337204f));
                  } else {
                    if (_1638 == 2) {
                      _1670 = ((0.6666666865348816f - _1641) + (_1642 * 0.5f));
                    } else {
                      if (_1638 == 1) {
                        _1670 = (((_1642 * -0.5f) + 0.1666666716337204f) + ((_1641 + _1640) * 0.5f));
                      } else {
                        _1670 = select((_1638 == 0), (_1642 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1670 = 0.0f;
                }
                float _1679 = min(max(((((_1544 * 0.27000001072883606f) * (0.029999999329447746f - _1586)) * _1670) + _1586), 0.0f), 65535.0f);
                float _1680 = min(max(_1587, 0.0f), 65535.0f);
                float _1681 = min(max(_1588, 0.0f), 65535.0f);
                float _1694 = min(max(mad(-0.21492856740951538f, _1681, mad(-0.2365107536315918f, _1680, (_1679 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1695 = min(max(mad(-0.09967592358589172f, _1681, mad(1.17622971534729f, _1680, (_1679 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1696 = min(max(mad(0.9977163076400757f, _1681, mad(-0.006032449658960104f, _1680, (_1679 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1697 = dot(float3(_1694, _1695, _1696), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1708 = log2(max((lerp(_1697, _1694, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1709 = _1708 * 0.3010300099849701f;
                float _1710 = log2(cb0_008x);
                float _1711 = _1710 * 0.3010300099849701f;
                do {
                  if (!(!(_1709 <= _1711))) {
                    _1780 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1718 = log2(cb0_009x);
                    float _1719 = _1718 * 0.3010300099849701f;
                    if ((bool)(_1709 > _1711) && (bool)(_1709 < _1719)) {
                      float _1727 = ((_1708 - _1710) * 0.9030900001525879f) / ((_1718 - _1710) * 0.3010300099849701f);
                      int _1728 = int(_1727);
                      float _1730 = _1727 - float((int)(_1728));
                      float _1732 = _13[_1728];
                      float _1735 = _13[(_1728 + 1)];
                      float _1740 = _1732 * 0.5f;
                      _1780 = dot(float3((_1730 * _1730), _1730, 1.0f), float3(mad((_13[(_1728 + 2)]), 0.5f, mad(_1735, -1.0f, _1740)), (_1735 - _1732), mad(_1735, 0.5f, _1740)));
                    } else {
                      do {
                        if (!(!(_1709 >= _1719))) {
                          float _1749 = log2(cb0_008z);
                          if (_1709 < (_1749 * 0.3010300099849701f)) {
                            float _1757 = ((_1708 - _1718) * 0.9030900001525879f) / ((_1749 - _1718) * 0.3010300099849701f);
                            int _1758 = int(_1757);
                            float _1760 = _1757 - float((int)(_1758));
                            float _1762 = _14[_1758];
                            float _1765 = _14[(_1758 + 1)];
                            float _1770 = _1762 * 0.5f;
                            _1780 = dot(float3((_1760 * _1760), _1760, 1.0f), float3(mad((_14[(_1758 + 2)]), 0.5f, mad(_1765, -1.0f, _1770)), (_1765 - _1762), mad(_1765, 0.5f, _1770)));
                            break;
                          }
                        }
                        _1780 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1784 = log2(max((lerp(_1697, _1695, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1785 = _1784 * 0.3010300099849701f;
                  do {
                    if (!(!(_1785 <= _1711))) {
                      _1854 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1792 = log2(cb0_009x);
                      float _1793 = _1792 * 0.3010300099849701f;
                      if ((bool)(_1785 > _1711) && (bool)(_1785 < _1793)) {
                        float _1801 = ((_1784 - _1710) * 0.9030900001525879f) / ((_1792 - _1710) * 0.3010300099849701f);
                        int _1802 = int(_1801);
                        float _1804 = _1801 - float((int)(_1802));
                        float _1806 = _13[_1802];
                        float _1809 = _13[(_1802 + 1)];
                        float _1814 = _1806 * 0.5f;
                        _1854 = dot(float3((_1804 * _1804), _1804, 1.0f), float3(mad((_13[(_1802 + 2)]), 0.5f, mad(_1809, -1.0f, _1814)), (_1809 - _1806), mad(_1809, 0.5f, _1814)));
                      } else {
                        do {
                          if (!(!(_1785 >= _1793))) {
                            float _1823 = log2(cb0_008z);
                            if (_1785 < (_1823 * 0.3010300099849701f)) {
                              float _1831 = ((_1784 - _1792) * 0.9030900001525879f) / ((_1823 - _1792) * 0.3010300099849701f);
                              int _1832 = int(_1831);
                              float _1834 = _1831 - float((int)(_1832));
                              float _1836 = _14[_1832];
                              float _1839 = _14[(_1832 + 1)];
                              float _1844 = _1836 * 0.5f;
                              _1854 = dot(float3((_1834 * _1834), _1834, 1.0f), float3(mad((_14[(_1832 + 2)]), 0.5f, mad(_1839, -1.0f, _1844)), (_1839 - _1836), mad(_1839, 0.5f, _1844)));
                              break;
                            }
                          }
                          _1854 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1858 = log2(max((lerp(_1697, _1696, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1859 = _1858 * 0.3010300099849701f;
                    do {
                      if (!(!(_1859 <= _1711))) {
                        _1928 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1866 = log2(cb0_009x);
                        float _1867 = _1866 * 0.3010300099849701f;
                        if ((bool)(_1859 > _1711) && (bool)(_1859 < _1867)) {
                          float _1875 = ((_1858 - _1710) * 0.9030900001525879f) / ((_1866 - _1710) * 0.3010300099849701f);
                          int _1876 = int(_1875);
                          float _1878 = _1875 - float((int)(_1876));
                          float _1880 = _13[_1876];
                          float _1883 = _13[(_1876 + 1)];
                          float _1888 = _1880 * 0.5f;
                          _1928 = dot(float3((_1878 * _1878), _1878, 1.0f), float3(mad((_13[(_1876 + 2)]), 0.5f, mad(_1883, -1.0f, _1888)), (_1883 - _1880), mad(_1883, 0.5f, _1888)));
                        } else {
                          do {
                            if (!(!(_1859 >= _1867))) {
                              float _1897 = log2(cb0_008z);
                              if (_1859 < (_1897 * 0.3010300099849701f)) {
                                float _1905 = ((_1858 - _1866) * 0.9030900001525879f) / ((_1897 - _1866) * 0.3010300099849701f);
                                int _1906 = int(_1905);
                                float _1908 = _1905 - float((int)(_1906));
                                float _1910 = _14[_1906];
                                float _1913 = _14[(_1906 + 1)];
                                float _1918 = _1910 * 0.5f;
                                _1928 = dot(float3((_1908 * _1908), _1908, 1.0f), float3(mad((_14[(_1906 + 2)]), 0.5f, mad(_1913, -1.0f, _1918)), (_1913 - _1910), mad(_1913, 0.5f, _1918)));
                                break;
                              }
                            }
                            _1928 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1932 = cb0_008w - cb0_008y;
                      float _1933 = (exp2(_1780 * 3.321928024291992f) - cb0_008y) / _1932;
                      float _1935 = (exp2(_1854 * 3.321928024291992f) - cb0_008y) / _1932;
                      float _1937 = (exp2(_1928 * 3.321928024291992f) - cb0_008y) / _1932;
                      float _1940 = mad(0.15618768334388733f, _1937, mad(0.13400420546531677f, _1935, (_1933 * 0.6624541878700256f)));
                      float _1943 = mad(0.053689517080783844f, _1937, mad(0.6740817427635193f, _1935, (_1933 * 0.2722287178039551f)));
                      float _1946 = mad(1.0103391408920288f, _1937, mad(0.00406073359772563f, _1935, (_1933 * -0.005574649665504694f)));
                      float _1959 = min(max(mad(-0.23642469942569733f, _1946, mad(-0.32480329275131226f, _1943, (_1940 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1960 = min(max(mad(0.016756348311901093f, _1946, mad(1.6153316497802734f, _1943, (_1940 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1961 = min(max(mad(0.9883948564529419f, _1946, mad(-0.008284442126750946f, _1943, (_1940 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1964 = mad(0.15618768334388733f, _1961, mad(0.13400420546531677f, _1960, (_1959 * 0.6624541878700256f)));
                      float _1967 = mad(0.053689517080783844f, _1961, mad(0.6740817427635193f, _1960, (_1959 * 0.2722287178039551f)));
                      float _1970 = mad(1.0103391408920288f, _1961, mad(0.00406073359772563f, _1960, (_1959 * -0.005574649665504694f)));
                      float _1992 = min(max((min(max(mad(-0.23642469942569733f, _1970, mad(-0.32480329275131226f, _1967, (_1964 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1993 = min(max((min(max(mad(0.016756348311901093f, _1970, mad(1.6153316497802734f, _1967, (_1964 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1994 = min(max((min(max(mad(0.9883948564529419f, _1970, mad(-0.008284442126750946f, _1967, (_1964 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _2007 = mad(_51, _1994, mad(_50, _1993, (_1992 * _49)));
                          _2008 = mad(_54, _1994, mad(_53, _1993, (_1992 * _52)));
                          _2009 = mad(_57, _1994, mad(_56, _1993, (_1992 * _55)));
                        } else {
                          _2007 = _1992;
                          _2008 = _1993;
                          _2009 = _1994;
                        }
                        float _2019 = exp2(log2(_2007 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2020 = exp2(log2(_2008 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2021 = exp2(log2(_2009 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2762 = exp2(log2((1.0f / ((_2019 * 18.6875f) + 1.0f)) * ((_2019 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2763 = exp2(log2((1.0f / ((_2020 * 18.6875f) + 1.0f)) * ((_2020 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2764 = exp2(log2((1.0f / ((_2021 * 18.6875f) + 1.0f)) * ((_2021 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _11[0] = cb0_010x;
          _11[1] = cb0_010y;
          _11[2] = cb0_010z;
          _11[3] = cb0_010w;
          _11[4] = cb0_012x;
          _11[5] = cb0_012x;
          _12[0] = cb0_011x;
          _12[1] = cb0_011y;
          _12[2] = cb0_011z;
          _12[3] = cb0_011w;
          _12[4] = cb0_012y;
          _12[5] = cb0_012y;
          float _2100 = cb0_012z * _1322;
          float _2101 = cb0_012z * _1323;
          float _2102 = cb0_012z * _1324;
          float _2105 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _2102, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _2101, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _2100)));
          float _2108 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _2102, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _2101, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _2100)));
          float _2111 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _2102, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _2101, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _2100)));
          float _2115 = max(max(_2105, _2108), _2111);
          float _2120 = (max(_2115, 1.000000013351432e-10f) - max(min(min(_2105, _2108), _2111), 1.000000013351432e-10f)) / max(_2115, 0.009999999776482582f);
          float _2133 = ((_2108 + _2105) + _2111) + (sqrt((((_2111 - _2108) * _2111) + ((_2108 - _2105) * _2108)) + ((_2105 - _2111) * _2105)) * 1.75f);
          float _2134 = _2133 * 0.3333333432674408f;
          float _2135 = _2120 + -0.4000000059604645f;
          float _2136 = _2135 * 5.0f;
          float _2140 = max((1.0f - abs(_2135 * 2.5f)), 0.0f);
          float _2151 = ((float((int)(((int)(uint)((bool)(_2136 > 0.0f))) - ((int)(uint)((bool)(_2136 < 0.0f))))) * (1.0f - (_2140 * _2140))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2134 <= 0.0533333346247673f)) {
              if (!(_2134 >= 0.1599999964237213f)) {
                _2160 = (((0.23999999463558197f / _2133) + -0.5f) * _2151);
              } else {
                _2160 = 0.0f;
              }
            } else {
              _2160 = _2151;
            }
            float _2161 = _2160 + 1.0f;
            float _2162 = _2161 * _2105;
            float _2163 = _2161 * _2108;
            float _2164 = _2161 * _2111;
            do {
              if (!((bool)(_2162 == _2163) && (bool)(_2163 == _2164))) {
                float _2171 = ((_2162 * 2.0f) - _2163) - _2164;
                float _2174 = ((_2108 - _2111) * 1.7320507764816284f) * _2161;
                float _2176 = atan(_2174 / _2171);
                bool _2179 = (_2171 < 0.0f);
                bool _2180 = (_2171 == 0.0f);
                bool _2181 = (_2174 >= 0.0f);
                bool _2182 = (_2174 < 0.0f);
                float _2191 = select((_2181 && _2180), 90.0f, select((_2182 && _2180), -90.0f, (select((_2182 && _2179), (_2176 + -3.1415927410125732f), select((_2181 && _2179), (_2176 + 3.1415927410125732f), _2176)) * 57.2957763671875f)));
                if (_2191 < 0.0f) {
                  _2196 = (_2191 + 360.0f);
                } else {
                  _2196 = _2191;
                }
              } else {
                _2196 = 0.0f;
              }
              float _2198 = min(max(_2196, 0.0f), 360.0f);
              do {
                if (_2198 < -180.0f) {
                  _2207 = (_2198 + 360.0f);
                } else {
                  if (_2198 > 180.0f) {
                    _2207 = (_2198 + -360.0f);
                  } else {
                    _2207 = _2198;
                  }
                }
                do {
                  if ((bool)(_2207 > -67.5f) && (bool)(_2207 < 67.5f)) {
                    float _2213 = (_2207 + 67.5f) * 0.029629629105329514f;
                    int _2214 = int(_2213);
                    float _2216 = _2213 - float((int)(_2214));
                    float _2217 = _2216 * _2216;
                    float _2218 = _2217 * _2216;
                    if (_2214 == 3) {
                      _2246 = (((0.1666666716337204f - (_2216 * 0.5f)) + (_2217 * 0.5f)) - (_2218 * 0.1666666716337204f));
                    } else {
                      if (_2214 == 2) {
                        _2246 = ((0.6666666865348816f - _2217) + (_2218 * 0.5f));
                      } else {
                        if (_2214 == 1) {
                          _2246 = (((_2218 * -0.5f) + 0.1666666716337204f) + ((_2217 + _2216) * 0.5f));
                        } else {
                          _2246 = select((_2214 == 0), (_2218 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2246 = 0.0f;
                  }
                  float _2255 = min(max(((((_2120 * 0.27000001072883606f) * (0.029999999329447746f - _2162)) * _2246) + _2162), 0.0f), 65535.0f);
                  float _2256 = min(max(_2163, 0.0f), 65535.0f);
                  float _2257 = min(max(_2164, 0.0f), 65535.0f);
                  float _2270 = min(max(mad(-0.21492856740951538f, _2257, mad(-0.2365107536315918f, _2256, (_2255 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2271 = min(max(mad(-0.09967592358589172f, _2257, mad(1.17622971534729f, _2256, (_2255 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2272 = min(max(mad(0.9977163076400757f, _2257, mad(-0.006032449658960104f, _2256, (_2255 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2273 = dot(float3(_2270, _2271, _2272), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2284 = log2(max((lerp(_2273, _2270, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2285 = _2284 * 0.3010300099849701f;
                  float _2286 = log2(cb0_008x);
                  float _2287 = _2286 * 0.3010300099849701f;
                  do {
                    if (!(!(_2285 <= _2287))) {
                      _2356 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2294 = log2(cb0_009x);
                      float _2295 = _2294 * 0.3010300099849701f;
                      if ((bool)(_2285 > _2287) && (bool)(_2285 < _2295)) {
                        float _2303 = ((_2284 - _2286) * 0.9030900001525879f) / ((_2294 - _2286) * 0.3010300099849701f);
                        int _2304 = int(_2303);
                        float _2306 = _2303 - float((int)(_2304));
                        float _2308 = _11[_2304];
                        float _2311 = _11[(_2304 + 1)];
                        float _2316 = _2308 * 0.5f;
                        _2356 = dot(float3((_2306 * _2306), _2306, 1.0f), float3(mad((_11[(_2304 + 2)]), 0.5f, mad(_2311, -1.0f, _2316)), (_2311 - _2308), mad(_2311, 0.5f, _2316)));
                      } else {
                        do {
                          if (!(!(_2285 >= _2295))) {
                            float _2325 = log2(cb0_008z);
                            if (_2285 < (_2325 * 0.3010300099849701f)) {
                              float _2333 = ((_2284 - _2294) * 0.9030900001525879f) / ((_2325 - _2294) * 0.3010300099849701f);
                              int _2334 = int(_2333);
                              float _2336 = _2333 - float((int)(_2334));
                              float _2338 = _12[_2334];
                              float _2341 = _12[(_2334 + 1)];
                              float _2346 = _2338 * 0.5f;
                              _2356 = dot(float3((_2336 * _2336), _2336, 1.0f), float3(mad((_12[(_2334 + 2)]), 0.5f, mad(_2341, -1.0f, _2346)), (_2341 - _2338), mad(_2341, 0.5f, _2346)));
                              break;
                            }
                          }
                          _2356 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2360 = log2(max((lerp(_2273, _2271, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2361 = _2360 * 0.3010300099849701f;
                    do {
                      if (!(!(_2361 <= _2287))) {
                        _2430 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2368 = log2(cb0_009x);
                        float _2369 = _2368 * 0.3010300099849701f;
                        if ((bool)(_2361 > _2287) && (bool)(_2361 < _2369)) {
                          float _2377 = ((_2360 - _2286) * 0.9030900001525879f) / ((_2368 - _2286) * 0.3010300099849701f);
                          int _2378 = int(_2377);
                          float _2380 = _2377 - float((int)(_2378));
                          float _2382 = _11[_2378];
                          float _2385 = _11[(_2378 + 1)];
                          float _2390 = _2382 * 0.5f;
                          _2430 = dot(float3((_2380 * _2380), _2380, 1.0f), float3(mad((_11[(_2378 + 2)]), 0.5f, mad(_2385, -1.0f, _2390)), (_2385 - _2382), mad(_2385, 0.5f, _2390)));
                        } else {
                          do {
                            if (!(!(_2361 >= _2369))) {
                              float _2399 = log2(cb0_008z);
                              if (_2361 < (_2399 * 0.3010300099849701f)) {
                                float _2407 = ((_2360 - _2368) * 0.9030900001525879f) / ((_2399 - _2368) * 0.3010300099849701f);
                                int _2408 = int(_2407);
                                float _2410 = _2407 - float((int)(_2408));
                                float _2412 = _12[_2408];
                                float _2415 = _12[(_2408 + 1)];
                                float _2420 = _2412 * 0.5f;
                                _2430 = dot(float3((_2410 * _2410), _2410, 1.0f), float3(mad((_12[(_2408 + 2)]), 0.5f, mad(_2415, -1.0f, _2420)), (_2415 - _2412), mad(_2415, 0.5f, _2420)));
                                break;
                              }
                            }
                            _2430 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2434 = log2(max((lerp(_2273, _2272, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2435 = _2434 * 0.3010300099849701f;
                      do {
                        if (!(!(_2435 <= _2287))) {
                          _2504 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2442 = log2(cb0_009x);
                          float _2443 = _2442 * 0.3010300099849701f;
                          if ((bool)(_2435 > _2287) && (bool)(_2435 < _2443)) {
                            float _2451 = ((_2434 - _2286) * 0.9030900001525879f) / ((_2442 - _2286) * 0.3010300099849701f);
                            int _2452 = int(_2451);
                            float _2454 = _2451 - float((int)(_2452));
                            float _2456 = _11[_2452];
                            float _2459 = _11[(_2452 + 1)];
                            float _2464 = _2456 * 0.5f;
                            _2504 = dot(float3((_2454 * _2454), _2454, 1.0f), float3(mad((_11[(_2452 + 2)]), 0.5f, mad(_2459, -1.0f, _2464)), (_2459 - _2456), mad(_2459, 0.5f, _2464)));
                          } else {
                            do {
                              if (!(!(_2435 >= _2443))) {
                                float _2473 = log2(cb0_008z);
                                if (_2435 < (_2473 * 0.3010300099849701f)) {
                                  float _2481 = ((_2434 - _2442) * 0.9030900001525879f) / ((_2473 - _2442) * 0.3010300099849701f);
                                  int _2482 = int(_2481);
                                  float _2484 = _2481 - float((int)(_2482));
                                  float _2486 = _12[_2482];
                                  float _2489 = _12[(_2482 + 1)];
                                  float _2494 = _2486 * 0.5f;
                                  _2504 = dot(float3((_2484 * _2484), _2484, 1.0f), float3(mad((_12[(_2482 + 2)]), 0.5f, mad(_2489, -1.0f, _2494)), (_2489 - _2486), mad(_2489, 0.5f, _2494)));
                                  break;
                                }
                              }
                              _2504 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2508 = cb0_008w - cb0_008y;
                        float _2509 = (exp2(_2356 * 3.321928024291992f) - cb0_008y) / _2508;
                        float _2511 = (exp2(_2430 * 3.321928024291992f) - cb0_008y) / _2508;
                        float _2513 = (exp2(_2504 * 3.321928024291992f) - cb0_008y) / _2508;
                        float _2516 = mad(0.15618768334388733f, _2513, mad(0.13400420546531677f, _2511, (_2509 * 0.6624541878700256f)));
                        float _2519 = mad(0.053689517080783844f, _2513, mad(0.6740817427635193f, _2511, (_2509 * 0.2722287178039551f)));
                        float _2522 = mad(1.0103391408920288f, _2513, mad(0.00406073359772563f, _2511, (_2509 * -0.005574649665504694f)));
                        float _2535 = min(max(mad(-0.23642469942569733f, _2522, mad(-0.32480329275131226f, _2519, (_2516 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2536 = min(max(mad(0.016756348311901093f, _2522, mad(1.6153316497802734f, _2519, (_2516 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2537 = min(max(mad(0.9883948564529419f, _2522, mad(-0.008284442126750946f, _2519, (_2516 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2540 = mad(0.15618768334388733f, _2537, mad(0.13400420546531677f, _2536, (_2535 * 0.6624541878700256f)));
                        float _2543 = mad(0.053689517080783844f, _2537, mad(0.6740817427635193f, _2536, (_2535 * 0.2722287178039551f)));
                        float _2546 = mad(1.0103391408920288f, _2537, mad(0.00406073359772563f, _2536, (_2535 * -0.005574649665504694f)));
                        float _2568 = min(max((min(max(mad(-0.23642469942569733f, _2546, mad(-0.32480329275131226f, _2543, (_2540 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2569 = min(max((min(max(mad(0.016756348311901093f, _2546, mad(1.6153316497802734f, _2543, (_2540 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2570 = min(max((min(max(mad(0.9883948564529419f, _2546, mad(-0.008284442126750946f, _2543, (_2540 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2583 = mad(_51, _2570, mad(_50, _2569, (_2568 * _49)));
                            _2584 = mad(_54, _2570, mad(_53, _2569, (_2568 * _52)));
                            _2585 = mad(_57, _2570, mad(_56, _2569, (_2568 * _55)));
                          } else {
                            _2583 = _2568;
                            _2584 = _2569;
                            _2585 = _2570;
                          }
                          float _2595 = exp2(log2(_2583 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2596 = exp2(log2(_2584 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2597 = exp2(log2(_2585 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2762 = exp2(log2((1.0f / ((_2595 * 18.6875f) + 1.0f)) * ((_2595 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2763 = exp2(log2((1.0f / ((_2596 * 18.6875f) + 1.0f)) * ((_2596 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2764 = exp2(log2((1.0f / ((_2597 * 18.6875f) + 1.0f)) * ((_2597 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2642 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1324, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1323, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1322)));
            float _2645 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1324, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1323, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1322)));
            float _2648 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1324, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1323, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1322)));
            float _2667 = exp2(log2(mad(_51, _2648, mad(_50, _2645, (_2642 * _49))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2668 = exp2(log2(mad(_54, _2648, mad(_53, _2645, (_2642 * _52))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2669 = exp2(log2(mad(_57, _2648, mad(_56, _2645, (_2642 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2762 = exp2(log2((1.0f / ((_2667 * 18.6875f) + 1.0f)) * ((_2667 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2763 = exp2(log2((1.0f / ((_2668 * 18.6875f) + 1.0f)) * ((_2668 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2764 = exp2(log2((1.0f / ((_2669 * 18.6875f) + 1.0f)) * ((_2669 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2716 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1312, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1311, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1310)));
                float _2719 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1312, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1311, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1310)));
                float _2722 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1312, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1311, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1310)));
                _2762 = mad(_51, _2722, mad(_50, _2719, (_2716 * _49)));
                _2763 = mad(_54, _2722, mad(_53, _2719, (_2716 * _52)));
                _2764 = mad(_57, _2722, mad(_56, _2719, (_2716 * _55)));
              } else {
                float _2735 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1336)));
                float _2738 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1336)));
                float _2741 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1338, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1337, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1336)));
                _2762 = exp2(log2(mad(_51, _2741, mad(_50, _2738, (_2735 * _49)))) * cb0_040z);
                _2763 = exp2(log2(mad(_54, _2741, mad(_53, _2738, (_2735 * _52)))) * cb0_040z);
                _2764 = exp2(log2(mad(_57, _2741, mad(_56, _2738, (_2735 * _55)))) * cb0_040z);
              }
            } else {
              _2762 = _1322;
              _2763 = _1323;
              _2764 = _1324;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2762 * 0.9523810148239136f), (_2763 * 0.9523810148239136f), (_2764 * 0.9523810148239136f), 0.0f);
}
