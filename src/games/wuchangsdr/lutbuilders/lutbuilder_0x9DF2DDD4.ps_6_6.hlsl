#include "./filmiclutbuilder.hlsli"

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
};

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  uint output_gamut = cb0_041x;
  uint output_device = cb0_040w;
  float expand_gamut = cb0_036w;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 output_color;
  float4 SV_Target;
  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _12 = TEXCOORD.x + -0.015625f;
  float _13 = TEXCOORD.y + -0.015625f;
  float _16 = float((uint)SV_RenderTargetArrayIndex);
  float _37;
  float _38;
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _103;
  float _104;
  float _105;
  float _154;
  float _883;
  float _919;
  float _930;
  float _994;
  float _1262;
  float _1263;
  float _1264;
  float _1275;
  float _1286;
  float _1468;
  float _1504;
  float _1515;
  float _1554;
  float _1664;
  float _1738;
  float _1812;
  float _1891;
  float _1892;
  float _1893;
  float _2044;
  float _2080;
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
  if (!((uint)(output_gamut) == 1)) {
    if (!((uint)(output_gamut) == 2)) {
      if (!((uint)(output_gamut) == 3)) {
        bool _26 = ((uint)(output_gamut) == 4);
        _37 = select(_26, 1.0f, 1.7050515413284302f);
        _38 = select(_26, 0.0f, -0.6217905879020691f);
        _39 = select(_26, 0.0f, -0.0832584798336029f);
        _40 = select(_26, 0.0f, -0.13025718927383423f);
        _41 = select(_26, 1.0f, 1.1408027410507202f);
        _42 = select(_26, 0.0f, -0.010548528283834457f);
        _43 = select(_26, 0.0f, -0.024003278464078903f);
        _44 = select(_26, 0.0f, -0.1289687603712082f);
        _45 = select(_26, 1.0f, 1.152971863746643f);
      } else {
        _37 = 0.6954522132873535f;
        _38 = 0.14067870378494263f;
        _39 = 0.16386906802654266f;
        _40 = 0.044794563204050064f;
        _41 = 0.8596711158752441f;
        _42 = 0.0955343171954155f;
        _43 = -0.005525882821530104f;
        _44 = 0.004025210160762072f;
        _45 = 1.0015007257461548f;
      }
    } else {
      _37 = 1.02579927444458f;
      _38 = -0.020052503794431686f;
      _39 = -0.0057713985443115234f;
      _40 = -0.0022350111976265907f;
      _41 = 1.0045825242996216f;
      _42 = -0.002352306619286537f;
      _43 = -0.005014004185795784f;
      _44 = -0.025293385609984398f;
      _45 = 1.0304402112960815f;
    }
  } else {
    _37 = 1.379158854484558f;
    _38 = -0.3088507056236267f;
    _39 = -0.07034677267074585f;
    _40 = -0.06933528929948807f;
    _41 = 1.0822921991348267f;
    _42 = -0.012962047010660172f;
    _43 = -0.002159259282052517f;
    _44 = -0.045465391129255295f;
    _45 = 1.0477596521377563f;
  }
  if ((uint)(uint)(output_device) > (uint)2) {
    float _56 = exp2(log2(_12 * 1.0322580337524414f) * 0.012683313339948654f);
    float _57 = exp2(log2(_13 * 1.0322580337524414f) * 0.012683313339948654f);
    float _58 = exp2(log2(_16 * 0.032258063554763794f) * 0.012683313339948654f);
    _103 = (exp2(log2(max(0.0f, (_56 + -0.8359375f)) / (18.8515625f - (_56 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _104 = (exp2(log2(max(0.0f, (_57 + -0.8359375f)) / (18.8515625f - (_57 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _103 = ((exp2((_12 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _104 = ((exp2((_13 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _105 = ((exp2((_16 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _132 = ((uint)(cb0_038z) != 0);
  float _137 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _154 = (((((2967800.0f - (_137 * 4607000064.0f)) * _137) + 99.11000061035156f) * _137) + 0.24406300485134125f);
  } else {
    _154 = (((((1901800.0f - (_137 * 2006400000.0f)) * _137) + 247.47999572753906f) * _137) + 0.23703999817371368f);
  }
  float _168 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _175 = cb0_035x * cb0_035x;
  float _178 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_175 * 1.6145605741257896e-07f));
  float _183 = ((_168 * 2.0f) + 4.0f) - (_178 * 8.0f);
  float _184 = (_168 * 3.0f) / _183;
  float _186 = (_178 * 2.0f) / _183;
  bool _187 = (cb0_035x < 4000.0f);
  float _196 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _198 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_175 * 1.5317699909210205f)) / (_196 * _196);
  float _205 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _175;
  float _207 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_175 * 308.60699462890625f)) / (_205 * _205);
  float _209 = rsqrt(dot(float2(_198, _207), float2(_198, _207)));
  float _210 = cb0_035y * 0.05000000074505806f;
  float _213 = ((_210 * _207) * _209) + _168;
  float _216 = _178 - ((_210 * _198) * _209);
  float _221 = (4.0f - (_216 * 8.0f)) + (_213 * 2.0f);
  float _227 = (((_213 * 3.0f) / _221) - _184) + select(_187, _184, _154);
  float _228 = (((_216 * 2.0f) / _221) - _186) + select(_187, _186, (((_154 * 2.869999885559082f) + -0.2750000059604645f) - ((_154 * _154) * 3.0f)));
  float _229 = select(_132, _227, 0.3127000033855438f);
  float _230 = select(_132, _228, 0.32899999618530273f);
  float _231 = select(_132, 0.3127000033855438f, _227);
  float _232 = select(_132, 0.32899999618530273f, _228);
  float _233 = max(_230, 1.000000013351432e-10f);
  float _234 = _229 / _233;
  float _237 = ((1.0f - _229) - _230) / _233;
  float _238 = max(_232, 1.000000013351432e-10f);
  float _239 = _231 / _238;
  float _242 = ((1.0f - _231) - _232) / _238;
  float _261 = mad(-0.16140000522136688f, _242, ((_239 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _237, ((_234 * 0.8950999975204468f) + 0.266400009393692f));
  float _262 = mad(0.03669999912381172f, _242, (1.7135000228881836f - (_239 * 0.7501999735832214f))) / mad(0.03669999912381172f, _237, (1.7135000228881836f - (_234 * 0.7501999735832214f)));
  float _263 = mad(1.0296000242233276f, _242, ((_239 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _237, ((_234 * 0.03889999911189079f) + -0.06849999725818634f));
  float _264 = mad(_262, -0.7501999735832214f, 0.0f);
  float _265 = mad(_262, 1.7135000228881836f, 0.0f);
  float _266 = mad(_262, 0.03669999912381172f, -0.0f);
  float _267 = mad(_263, 0.03889999911189079f, 0.0f);
  float _268 = mad(_263, -0.06849999725818634f, 0.0f);
  float _269 = mad(_263, 1.0296000242233276f, 0.0f);
  float _272 = mad(0.1599626988172531f, _267, mad(-0.1470542997121811f, _264, (_261 * 0.883457362651825f)));
  float _275 = mad(0.1599626988172531f, _268, mad(-0.1470542997121811f, _265, (_261 * 0.26293492317199707f)));
  float _278 = mad(0.1599626988172531f, _269, mad(-0.1470542997121811f, _266, (_261 * -0.15930065512657166f)));
  float _281 = mad(0.04929120093584061f, _267, mad(0.5183603167533875f, _264, (_261 * 0.38695648312568665f)));
  float _284 = mad(0.04929120093584061f, _268, mad(0.5183603167533875f, _265, (_261 * 0.11516613513231277f)));
  float _287 = mad(0.04929120093584061f, _269, mad(0.5183603167533875f, _266, (_261 * -0.0697740763425827f)));
  float _290 = mad(0.9684867262840271f, _267, mad(0.04004279896616936f, _264, (_261 * -0.007634039502590895f)));
  float _293 = mad(0.9684867262840271f, _268, mad(0.04004279896616936f, _265, (_261 * -0.0022720457054674625f)));
  float _296 = mad(0.9684867262840271f, _269, mad(0.04004279896616936f, _266, (_261 * 0.0013765322510153055f)));
  float _299 = mad(_278, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_275, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_272 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _302 = mad(_278, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_275, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_272 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _305 = mad(_278, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_275, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_272 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _308 = mad(_287, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_284, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_281 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _311 = mad(_287, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_284, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_281 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _314 = mad(_287, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_284, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_281 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _317 = mad(_296, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_293, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_290 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _320 = mad(_296, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_293, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_290 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _323 = mad(_296, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_293, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_290 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _353 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _323, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _314, (_305 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _105, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _320, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _311, (_302 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _104, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _317, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _308, (_299 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _103)));
  float _356 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _323, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _314, (_305 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _105, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _320, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _311, (_302 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _104, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _317, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _308, (_299 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _103)));
  float _359 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _323, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _314, (_305 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _105, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _320, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _311, (_302 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _104, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _317, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _308, (_299 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _103)));
  float _374 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _359, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _356, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _353)));
  float _377 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _359, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _356, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _353)));
  float _380 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _359, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _356, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _353)));
  float _381 = dot(float3(_374, _377, _380), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _385 = (_374 / _381) + -1.0f;
  float _386 = (_377 / _381) + -1.0f;
  float _387 = (_380 / _381) + -1.0f;
  float _399 = (1.0f - exp2(((_381 * _381) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_385, _386, _387), float3(_385, _386, _387)) * -4.0f));
  float _415 = ((mad(-0.06368283927440643f, _380, mad(-0.32929131388664246f, _377, (_374 * 1.370412826538086f))) - _374) * _399) + _374;
  float _416 = ((mad(-0.010861567221581936f, _380, mad(1.0970908403396606f, _377, (_374 * -0.08343426138162613f))) - _377) * _399) + _377;
  float _417 = ((mad(1.203694462776184f, _380, mad(-0.09862564504146576f, _377, (_374 * -0.02579325996339321f))) - _380) * _399) + _380;
  float _418 = dot(float3(_415, _416, _417), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _432 = cb0_019w + cb0_024w;
  float _446 = cb0_018w * cb0_023w;
  float _460 = cb0_017w * cb0_022w;
  float _474 = cb0_016w * cb0_021w;
  float _488 = cb0_015w * cb0_020w;
  float _492 = _415 - _418;
  float _493 = _416 - _418;
  float _494 = _417 - _418;
  float _551 = saturate(_418 / cb0_035z);
  float _555 = (_551 * _551) * (3.0f - (_551 * 2.0f));
  float _556 = 1.0f - _555;
  float _565 = cb0_019w + cb0_034w;
  float _574 = cb0_018w * cb0_033w;
  float _583 = cb0_017w * cb0_032w;
  float _592 = cb0_016w * cb0_031w;
  float _601 = cb0_015w * cb0_030w;
  float _665 = saturate((_418 - cb0_035w) / (cb0_036x - cb0_035w));
  float _669 = (_665 * _665) * (3.0f - (_665 * 2.0f));
  float _678 = cb0_019w + cb0_029w;
  float _687 = cb0_018w * cb0_028w;
  float _696 = cb0_017w * cb0_027w;
  float _705 = cb0_016w * cb0_026w;
  float _714 = cb0_015w * cb0_025w;
  float _772 = _555 - _669;
  
  float _783 = ((_669 * (((cb0_019x + cb0_034x) + _565) + (((cb0_018x * cb0_033x) * _574) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _592) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _601) * _492) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _583)))))) + (_556 * (((cb0_019x + cb0_024x) + _432) + (((cb0_018x * cb0_023x) * _446) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _474) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _488) * _492) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _460))))))) + ((((cb0_019x + cb0_029x) + _678) + (((cb0_018x * cb0_028x) * _687) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _705) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _714) * _492) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _696))))) * _772);
  float _785 = ((_669 * (((cb0_019y + cb0_034y) + _565) + (((cb0_018y * cb0_033y) * _574) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _592) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _601) * _493) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _583)))))) + (_556 * (((cb0_019y + cb0_024y) + _432) + (((cb0_018y * cb0_023y) * _446) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _474) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _488) * _493) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _460))))))) + ((((cb0_019y + cb0_029y) + _678) + (((cb0_018y * cb0_028y) * _687) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _705) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _714) * _493) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _696))))) * _772);
  float _787 = ((_669 * (((cb0_019z + cb0_034z) + _565) + (((cb0_018z * cb0_033z) * _574) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _592) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _601) * _494) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _583)))))) + (_556 * (((cb0_019z + cb0_024z) + _432) + (((cb0_018z * cb0_023z) * _446) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _474) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _488) * _494) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _460))))))) + ((((cb0_019z + cb0_029z) + _678) + (((cb0_018z * cb0_028z) * _687) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _705) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _714) * _494) + _418)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _696))))) * _772);

  float _823 = ((mad(0.061360642313957214f, _787, mad(-4.540197551250458e-09f, _785, (_783 * 0.9386394023895264f))) - _783) * cb0_036y) + _783;
  float _824 = ((mad(0.169205904006958f, _787, mad(0.8307942152023315f, _785, (_783 * 6.775371730327606e-08f))) - _785) * cb0_036y) + _785;
  float _825 = (mad(-2.3283064365386963e-10f, _785, (_783 * -9.313225746154785e-10f)) * cb0_036y) + _787;
  float _828 = mad(0.16386905312538147f, _825, mad(0.14067868888378143f, _824, (_823 * 0.6954522132873535f)));
  float _831 = mad(0.0955343246459961f, _825, mad(0.8596711158752441f, _824, (_823 * 0.044794581830501556f)));
  float _834 = mad(1.0015007257461548f, _825, mad(0.004025210160762072f, _824, (_823 * -0.005525882821530104f)));
  float _838 = max(max(_828, _831), _834);
  float _843 = (max(_838, 1.000000013351432e-10f) - max(min(min(_828, _831), _834), 1.000000013351432e-10f)) / max(_838, 0.009999999776482582f);
  float _856 = ((_831 + _828) + _834) + (sqrt((((_834 - _831) * _834) + ((_831 - _828) * _831)) + ((_828 - _834) * _828)) * 1.75f);
  float _857 = _856 * 0.3333333432674408f;
  float _858 = _843 + -0.4000000059604645f;
  float _859 = _858 * 5.0f;
  float _863 = max((1.0f - abs(_858 * 2.5f)), 0.0f);
  float _874 = ((float(((int)(uint)((bool)(_859 > 0.0f))) - ((int)(uint)((bool)(_859 < 0.0f)))) * (1.0f - (_863 * _863))) + 1.0f) * 0.02500000037252903f;
  if (!(_857 <= 0.0533333346247673f)) {
    if (!(_857 >= 0.1599999964237213f)) {
      _883 = (((0.23999999463558197f / _856) + -0.5f) * _874);
    } else {
      _883 = 0.0f;
    }
  } else {
    _883 = _874;
  }
  float _884 = _883 + 1.0f;
  float _885 = _884 * _828;
  float _886 = _884 * _831;
  float _887 = _884 * _834;
  if (!((bool)(_885 == _886) && (bool)(_886 == _887))) {
    float _894 = ((_885 * 2.0f) - _886) - _887;
    float _897 = ((_831 - _834) * 1.7320507764816284f) * _884;
    float _899 = atan(_897 / _894);
    bool _902 = (_894 < 0.0f);
    bool _903 = (_894 == 0.0f);
    bool _904 = (_897 >= 0.0f);
    bool _905 = (_897 < 0.0f);
    float _914 = select((_904 && _903), 90.0f, select((_905 && _903), -90.0f, (select((_905 && _902), (_899 + -3.1415927410125732f), select((_904 && _902), (_899 + 3.1415927410125732f), _899)) * 57.2957763671875f)));
    if (_914 < 0.0f) {
      _919 = (_914 + 360.0f);
    } else {
      _919 = _914;
    }
  } else {
    _919 = 0.0f;
  }
  float _921 = min(max(_919, 0.0f), 360.0f);
  if (_921 < -180.0f) {
    _930 = (_921 + 360.0f);
  } else {
    if (_921 > 180.0f) {
      _930 = (_921 + -360.0f);
    } else {
      _930 = _921;
    }
  }
  float _934 = saturate(1.0f - abs(_930 * 0.014814814552664757f));
  float _938 = (_934 * _934) * (3.0f - (_934 * 2.0f));
  float _944 = ((_938 * _938) * ((_843 * 0.18000000715255737f) * (0.029999999329447746f - _885))) + _885;
  float _954 = max(0.0f, mad(-0.21492856740951538f, _887, mad(-0.2365107536315918f, _886, (_944 * 1.4514392614364624f))));
  float _955 = max(0.0f, mad(-0.09967592358589172f, _887, mad(1.17622971534729f, _886, (_944 * -0.07655377686023712f))));
  float _956 = max(0.0f, mad(0.9977163076400757f, _887, mad(-0.006032449658960104f, _886, (_944 * 0.008316148072481155f))));
  float _957 = dot(float3(_954, _955, _956), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _971 = (cb0_037w + 1.0f) - cb0_037y;
  float _974 = cb0_038x + 1.0f;
  float _976 = _974 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _994 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _985 = (cb0_037w + 0.18000000715255737f) / _971;
    _994 = (-0.7447274923324585f - ((log2(_985 / (2.0f - _985)) * 0.3465735912322998f) * (_971 / cb0_037x)));
  }
  float _997 = ((1.0f - cb0_037y) / cb0_037x) - _994;
  float _999 = (cb0_037z / cb0_037x) - _997;
  float3 lerpColor = lerp(_957, float3(_954, _955, _956), 0.9599999785423279f);

#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _823, _824, _825);
  float _1145 = lerpColor.r, _1146 = lerpColor.g, _1147 = lerpColor.b;
#else

  float _1003 = log2(lerp(_957, _954, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1004 = log2(lerp(_957, _955, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1005 = log2(lerp(_957, _956, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1009 = cb0_037x * (_1003 + _997);
  float _1010 = cb0_037x * (_1004 + _997);
  float _1011 = cb0_037x * (_1005 + _997);
  float _1012 = _971 * 2.0f;
  float _1014 = (cb0_037x * -2.0f) / _971;
  float _1015 = _1003 - _994;
  float _1016 = _1004 - _994;
  float _1017 = _1005 - _994;
  float _1036 = _976 * 2.0f;
  float _1038 = (cb0_037x * 2.0f) / _976;
  float _1063 = select((_1003 < _994), ((_1012 / (exp2((_1015 * 1.4426950216293335f) * _1014) + 1.0f)) - cb0_037w), _1009);
  float _1064 = select((_1004 < _994), ((_1012 / (exp2((_1016 * 1.4426950216293335f) * _1014) + 1.0f)) - cb0_037w), _1010);
  float _1065 = select((_1005 < _994), ((_1012 / (exp2((_1017 * 1.4426950216293335f) * _1014) + 1.0f)) - cb0_037w), _1011);
  float _1072 = _999 - _994;
  float _1076 = saturate(_1015 / _1072);
  float _1077 = saturate(_1016 / _1072);
  float _1078 = saturate(_1017 / _1072);
  bool _1079 = (_999 < _994);
  float _1083 = select(_1079, (1.0f - _1076), _1076);
  float _1084 = select(_1079, (1.0f - _1077), _1077);
  float _1085 = select(_1079, (1.0f - _1078), _1078);
  float _1104 = (((_1083 * _1083) * (select((_1003 > _999), (_974 - (_1036 / (exp2(((_1003 - _999) * 1.4426950216293335f) * _1038) + 1.0f))), _1009) - _1063)) * (3.0f - (_1083 * 2.0f))) + _1063;
  float _1105 = (((_1084 * _1084) * (select((_1004 > _999), (_974 - (_1036 / (exp2(((_1004 - _999) * 1.4426950216293335f) * _1038) + 1.0f))), _1010) - _1064)) * (3.0f - (_1084 * 2.0f))) + _1064;
  float _1106 = (((_1085 * _1085) * (select((_1005 > _999), (_974 - (_1036 / (exp2(((_1005 - _999) * 1.4426950216293335f) * _1038) + 1.0f))), _1011) - _1065)) * (3.0f - (_1085 * 2.0f))) + _1065;
  float _1107 = dot(float3(_1104, _1105, _1106), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1127 = (expand_gamut * (max(0.0f, (lerp(_1107, _1104, 0.9300000071525574f))) - _823)) + _823;
  float _1128 = (expand_gamut * (max(0.0f, (lerp(_1107, _1105, 0.9300000071525574f))) - _824)) + _824;
  float _1129 = (expand_gamut * (max(0.0f, (lerp(_1107, _1106, 0.9300000071525574f))) - _825)) + _825;
  float _1145 = ((mad(-0.06537103652954102f, _1129, mad(1.451815478503704e-06f, _1128, (_1127 * 1.065374732017517f))) - _1127) * cb0_036y) + _1127;
  float _1146 = ((mad(-0.20366770029067993f, _1129, mad(1.2036634683609009f, _1128, (_1127 * -2.57161445915699e-07f))) - _1128) * cb0_036y) + _1128;
  float _1147 = ((mad(0.9999996423721313f, _1129, mad(2.0954757928848267e-08f, _1128, (_1127 * 1.862645149230957e-08f))) - _1129) * cb0_036y) + _1129;
#endif

  //SetTonemappedAP1(_1145, _1146, _1147);

  float _1157 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1147, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1146, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1145))));
  float _1158 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1147, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1146, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1145))));
  float _1159 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1147, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1146, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1145))));


  float _1185 = cb0_014x * (((cb0_039y + (cb0_039x * _1157)) * _1157) + cb0_039z);
  float _1186 = cb0_014y * (((cb0_039y + (cb0_039x * _1158)) * _1158) + cb0_039z);
  float _1187 = cb0_014z * (((cb0_039y + (cb0_039x * _1159)) * _1159) + cb0_039z);
  float _1194 = ((cb0_013x - _1185) * cb0_013w) + _1185;
  float _1195 = ((cb0_013y - _1186) * cb0_013w) + _1186;
  float _1196 = ((cb0_013z - _1187) * cb0_013w) + _1187;

  if (GenerateOutput(_1194, _1195, _1196, SV_Target, is_hdr)) {
    return SV_Target;
  }

  float _1197 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _787, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _785, (_783 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1198 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _787, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _785, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _783)));
  float _1199 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _787, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _785, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _783)));
  float _1206 = ((cb0_013x - _1197) * cb0_013w) + _1197;
  float _1207 = ((cb0_013y - _1198) * cb0_013w) + _1198;
  float _1208 = ((cb0_013z - _1199) * cb0_013w) + _1199;
  float _1220 = exp2(log2(max(0.0f, _1194)) * cb0_040y);
  float _1221 = exp2(log2(max(0.0f, _1195)) * cb0_040y);
  float _1222 = exp2(log2(max(0.0f, _1196)) * cb0_040y);

  [branch]
  if ((uint)(output_device) == 0) {
    do {
      if ((uint)(UniformBufferConstants_WorkingColorSpace_320) == 0) {
        float _1245 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1220)));
        float _1248 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1220)));
        float _1251 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1220)));
        _1262 = mad(_39, _1251, mad(_38, _1248, (_1245 * _37)));
        _1263 = mad(_42, _1251, mad(_41, _1248, (_1245 * _40)));
        _1264 = mad(_45, _1251, mad(_44, _1248, (_1245 * _43)));
      } else {
        _1262 = _1220;
        _1263 = _1221;
        _1264 = _1222;
      }
      do {
        if (_1262 < 0.0031306699384003878f) {
          _1275 = (_1262 * 12.920000076293945f);
        } else {
          _1275 = (((pow(_1262, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1263 < 0.0031306699384003878f) {
            _1286 = (_1263 * 12.920000076293945f);
          } else {
            _1286 = (((pow(_1263, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1264 < 0.0031306699384003878f) {
            _2646 = _1275;
            _2647 = _1286;
            _2648 = (_1264 * 12.920000076293945f);
          } else {
            _2646 = _1275;
            _2647 = _1286;
            _2648 = (((pow(_1264, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(output_device) == 1) {
      float _1313 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1220)));
      float _1316 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1220)));
      float _1319 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1220)));
      float _1329 = max(6.103519990574569e-05f, mad(_39, _1319, mad(_38, _1316, (_1313 * _37))));
      float _1330 = max(6.103519990574569e-05f, mad(_42, _1319, mad(_41, _1316, (_1313 * _40))));
      float _1331 = max(6.103519990574569e-05f, mad(_45, _1319, mad(_44, _1316, (_1313 * _43))));
      _2646 = min((_1329 * 4.5f), ((exp2(log2(max(_1329, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2647 = min((_1330 * 4.5f), ((exp2(log2(max(_1330, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2648 = min((_1331 * 4.5f), ((exp2(log2(max(_1331, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)((uint)(output_device) == 3) || (bool)((uint)(output_device) == 5)) {
        _10[0] = cb0_010x;
        _10[1] = cb0_010y;
        _10[2] = cb0_010z;
        _10[3] = cb0_010w;
        _10[4] = cb0_012x;
        _10[5] = cb0_012x;
        _11[0] = cb0_011x;
        _11[1] = cb0_011y;
        _11[2] = cb0_011z;
        _11[3] = cb0_011w;
        _11[4] = cb0_012y;
        _11[5] = cb0_012y;
        float _1408 = cb0_012z * _1206;
        float _1409 = cb0_012z * _1207;
        float _1410 = cb0_012z * _1208;
        float _1413 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1410, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1409, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1408)));
        float _1416 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1410, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1409, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1408)));
        float _1419 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1410, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1409, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1408)));
        float _1423 = max(max(_1413, _1416), _1419);
        float _1428 = (max(_1423, 1.000000013351432e-10f) - max(min(min(_1413, _1416), _1419), 1.000000013351432e-10f)) / max(_1423, 0.009999999776482582f);
        float _1441 = ((_1416 + _1413) + _1419) + (sqrt((((_1419 - _1416) * _1419) + ((_1416 - _1413) * _1416)) + ((_1413 - _1419) * _1413)) * 1.75f);
        float _1442 = _1441 * 0.3333333432674408f;
        float _1443 = _1428 + -0.4000000059604645f;
        float _1444 = _1443 * 5.0f;
        float _1448 = max((1.0f - abs(_1443 * 2.5f)), 0.0f);
        float _1459 = ((float(((int)(uint)((bool)(_1444 > 0.0f))) - ((int)(uint)((bool)(_1444 < 0.0f)))) * (1.0f - (_1448 * _1448))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1442 <= 0.0533333346247673f)) {
            if (!(_1442 >= 0.1599999964237213f)) {
              _1468 = (((0.23999999463558197f / _1441) + -0.5f) * _1459);
            } else {
              _1468 = 0.0f;
            }
          } else {
            _1468 = _1459;
          }
          float _1469 = _1468 + 1.0f;
          float _1470 = _1469 * _1413;
          float _1471 = _1469 * _1416;
          float _1472 = _1469 * _1419;
          do {
            if (!((bool)(_1470 == _1471) && (bool)(_1471 == _1472))) {
              float _1479 = ((_1470 * 2.0f) - _1471) - _1472;
              float _1482 = ((_1416 - _1419) * 1.7320507764816284f) * _1469;
              float _1484 = atan(_1482 / _1479);
              bool _1487 = (_1479 < 0.0f);
              bool _1488 = (_1479 == 0.0f);
              bool _1489 = (_1482 >= 0.0f);
              bool _1490 = (_1482 < 0.0f);
              float _1499 = select((_1489 && _1488), 90.0f, select((_1490 && _1488), -90.0f, (select((_1490 && _1487), (_1484 + -3.1415927410125732f), select((_1489 && _1487), (_1484 + 3.1415927410125732f), _1484)) * 57.2957763671875f)));
              if (_1499 < 0.0f) {
                _1504 = (_1499 + 360.0f);
              } else {
                _1504 = _1499;
              }
            } else {
              _1504 = 0.0f;
            }
            float _1506 = min(max(_1504, 0.0f), 360.0f);
            do {
              if (_1506 < -180.0f) {
                _1515 = (_1506 + 360.0f);
              } else {
                if (_1506 > 180.0f) {
                  _1515 = (_1506 + -360.0f);
                } else {
                  _1515 = _1506;
                }
              }
              do {
                if ((bool)(_1515 > -67.5f) && (bool)(_1515 < 67.5f)) {
                  float _1521 = (_1515 + 67.5f) * 0.029629629105329514f;
                  int _1522 = int(_1521);
                  float _1524 = _1521 - float(_1522);
                  float _1525 = _1524 * _1524;
                  float _1526 = _1525 * _1524;
                  if (_1522 == 3) {
                    _1554 = (((0.1666666716337204f - (_1524 * 0.5f)) + (_1525 * 0.5f)) - (_1526 * 0.1666666716337204f));
                  } else {
                    if (_1522 == 2) {
                      _1554 = ((0.6666666865348816f - _1525) + (_1526 * 0.5f));
                    } else {
                      if (_1522 == 1) {
                        _1554 = (((_1526 * -0.5f) + 0.1666666716337204f) + ((_1525 + _1524) * 0.5f));
                      } else {
                        _1554 = select((_1522 == 0), (_1526 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1554 = 0.0f;
                }
                float _1563 = min(max(((((_1428 * 0.27000001072883606f) * (0.029999999329447746f - _1470)) * _1554) + _1470), 0.0f), 65535.0f);
                float _1564 = min(max(_1471, 0.0f), 65535.0f);
                float _1565 = min(max(_1472, 0.0f), 65535.0f);
                float _1578 = min(max(mad(-0.21492856740951538f, _1565, mad(-0.2365107536315918f, _1564, (_1563 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1579 = min(max(mad(-0.09967592358589172f, _1565, mad(1.17622971534729f, _1564, (_1563 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1580 = min(max(mad(0.9977163076400757f, _1565, mad(-0.006032449658960104f, _1564, (_1563 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1581 = dot(float3(_1578, _1579, _1580), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1592 = log2(max((lerp(_1581, _1578, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1593 = _1592 * 0.3010300099849701f;
                float _1594 = log2(cb0_008x);
                float _1595 = _1594 * 0.3010300099849701f;
                do {
                  if (!(!(_1593 <= _1595))) {
                    _1664 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1602 = log2(cb0_009x);
                    float _1603 = _1602 * 0.3010300099849701f;
                    if ((bool)(_1593 > _1595) && (bool)(_1593 < _1603)) {
                      float _1611 = ((_1592 - _1594) * 0.9030900001525879f) / ((_1602 - _1594) * 0.3010300099849701f);
                      int _1612 = int(_1611);
                      float _1614 = _1611 - float(_1612);
                      float _1616 = _10[_1612];
                      float _1619 = _10[(_1612 + 1)];
                      float _1624 = _1616 * 0.5f;
                      _1664 = dot(float3((_1614 * _1614), _1614, 1.0f), float3(mad((_10[(_1612 + 2)]), 0.5f, mad(_1619, -1.0f, _1624)), (_1619 - _1616), mad(_1619, 0.5f, _1624)));
                    } else {
                      do {
                        if (!(!(_1593 >= _1603))) {
                          float _1633 = log2(cb0_008z);
                          if (_1593 < (_1633 * 0.3010300099849701f)) {
                            float _1641 = ((_1592 - _1602) * 0.9030900001525879f) / ((_1633 - _1602) * 0.3010300099849701f);
                            int _1642 = int(_1641);
                            float _1644 = _1641 - float(_1642);
                            float _1646 = _11[_1642];
                            float _1649 = _11[(_1642 + 1)];
                            float _1654 = _1646 * 0.5f;
                            _1664 = dot(float3((_1644 * _1644), _1644, 1.0f), float3(mad((_11[(_1642 + 2)]), 0.5f, mad(_1649, -1.0f, _1654)), (_1649 - _1646), mad(_1649, 0.5f, _1654)));
                            break;
                          }
                        }
                        _1664 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1668 = log2(max((lerp(_1581, _1579, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1669 = _1668 * 0.3010300099849701f;
                  do {
                    if (!(!(_1669 <= _1595))) {
                      _1738 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1676 = log2(cb0_009x);
                      float _1677 = _1676 * 0.3010300099849701f;
                      if ((bool)(_1669 > _1595) && (bool)(_1669 < _1677)) {
                        float _1685 = ((_1668 - _1594) * 0.9030900001525879f) / ((_1676 - _1594) * 0.3010300099849701f);
                        int _1686 = int(_1685);
                        float _1688 = _1685 - float(_1686);
                        float _1690 = _10[_1686];
                        float _1693 = _10[(_1686 + 1)];
                        float _1698 = _1690 * 0.5f;
                        _1738 = dot(float3((_1688 * _1688), _1688, 1.0f), float3(mad((_10[(_1686 + 2)]), 0.5f, mad(_1693, -1.0f, _1698)), (_1693 - _1690), mad(_1693, 0.5f, _1698)));
                      } else {
                        do {
                          if (!(!(_1669 >= _1677))) {
                            float _1707 = log2(cb0_008z);
                            if (_1669 < (_1707 * 0.3010300099849701f)) {
                              float _1715 = ((_1668 - _1676) * 0.9030900001525879f) / ((_1707 - _1676) * 0.3010300099849701f);
                              int _1716 = int(_1715);
                              float _1718 = _1715 - float(_1716);
                              float _1720 = _11[_1716];
                              float _1723 = _11[(_1716 + 1)];
                              float _1728 = _1720 * 0.5f;
                              _1738 = dot(float3((_1718 * _1718), _1718, 1.0f), float3(mad((_11[(_1716 + 2)]), 0.5f, mad(_1723, -1.0f, _1728)), (_1723 - _1720), mad(_1723, 0.5f, _1728)));
                              break;
                            }
                          }
                          _1738 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1742 = log2(max((lerp(_1581, _1580, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1743 = _1742 * 0.3010300099849701f;
                    do {
                      if (!(!(_1743 <= _1595))) {
                        _1812 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1750 = log2(cb0_009x);
                        float _1751 = _1750 * 0.3010300099849701f;
                        if ((bool)(_1743 > _1595) && (bool)(_1743 < _1751)) {
                          float _1759 = ((_1742 - _1594) * 0.9030900001525879f) / ((_1750 - _1594) * 0.3010300099849701f);
                          int _1760 = int(_1759);
                          float _1762 = _1759 - float(_1760);
                          float _1764 = _10[_1760];
                          float _1767 = _10[(_1760 + 1)];
                          float _1772 = _1764 * 0.5f;
                          _1812 = dot(float3((_1762 * _1762), _1762, 1.0f), float3(mad((_10[(_1760 + 2)]), 0.5f, mad(_1767, -1.0f, _1772)), (_1767 - _1764), mad(_1767, 0.5f, _1772)));
                        } else {
                          do {
                            if (!(!(_1743 >= _1751))) {
                              float _1781 = log2(cb0_008z);
                              if (_1743 < (_1781 * 0.3010300099849701f)) {
                                float _1789 = ((_1742 - _1750) * 0.9030900001525879f) / ((_1781 - _1750) * 0.3010300099849701f);
                                int _1790 = int(_1789);
                                float _1792 = _1789 - float(_1790);
                                float _1794 = _11[_1790];
                                float _1797 = _11[(_1790 + 1)];
                                float _1802 = _1794 * 0.5f;
                                _1812 = dot(float3((_1792 * _1792), _1792, 1.0f), float3(mad((_11[(_1790 + 2)]), 0.5f, mad(_1797, -1.0f, _1802)), (_1797 - _1794), mad(_1797, 0.5f, _1802)));
                                break;
                              }
                            }
                            _1812 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1816 = cb0_008w - cb0_008y;
                      float _1817 = (exp2(_1664 * 3.321928024291992f) - cb0_008y) / _1816;
                      float _1819 = (exp2(_1738 * 3.321928024291992f) - cb0_008y) / _1816;
                      float _1821 = (exp2(_1812 * 3.321928024291992f) - cb0_008y) / _1816;
                      float _1824 = mad(0.15618768334388733f, _1821, mad(0.13400420546531677f, _1819, (_1817 * 0.6624541878700256f)));
                      float _1827 = mad(0.053689517080783844f, _1821, mad(0.6740817427635193f, _1819, (_1817 * 0.2722287178039551f)));
                      float _1830 = mad(1.0103391408920288f, _1821, mad(0.00406073359772563f, _1819, (_1817 * -0.005574649665504694f)));
                      float _1843 = min(max(mad(-0.23642469942569733f, _1830, mad(-0.32480329275131226f, _1827, (_1824 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1844 = min(max(mad(0.016756348311901093f, _1830, mad(1.6153316497802734f, _1827, (_1824 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1845 = min(max(mad(0.9883948564529419f, _1830, mad(-0.008284442126750946f, _1827, (_1824 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1848 = mad(0.15618768334388733f, _1845, mad(0.13400420546531677f, _1844, (_1843 * 0.6624541878700256f)));
                      float _1851 = mad(0.053689517080783844f, _1845, mad(0.6740817427635193f, _1844, (_1843 * 0.2722287178039551f)));
                      float _1854 = mad(1.0103391408920288f, _1845, mad(0.00406073359772563f, _1844, (_1843 * -0.005574649665504694f)));
                      float _1876 = min(max((min(max(mad(-0.23642469942569733f, _1854, mad(-0.32480329275131226f, _1851, (_1848 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1877 = min(max((min(max(mad(0.016756348311901093f, _1854, mad(1.6153316497802734f, _1851, (_1848 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1878 = min(max((min(max(mad(0.9883948564529419f, _1854, mad(-0.008284442126750946f, _1851, (_1848 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!((uint)(output_device) == 5)) {
                          _1891 = mad(_39, _1878, mad(_38, _1877, (_1876 * _37)));
                          _1892 = mad(_42, _1878, mad(_41, _1877, (_1876 * _40)));
                          _1893 = mad(_45, _1878, mad(_44, _1877, (_1876 * _43)));
                        } else {
                          _1891 = _1876;
                          _1892 = _1877;
                          _1893 = _1878;
                        }
                        float _1903 = exp2(log2(_1891 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1904 = exp2(log2(_1892 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1905 = exp2(log2(_1893 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2646 = exp2(log2((1.0f / ((_1903 * 18.6875f) + 1.0f)) * ((_1903 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2647 = exp2(log2((1.0f / ((_1904 * 18.6875f) + 1.0f)) * ((_1904 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2648 = exp2(log2((1.0f / ((_1905 * 18.6875f) + 1.0f)) * ((_1905 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if (((uint)(output_device) & -3) == 4) {
          _8[0] = cb0_010x;
          _8[1] = cb0_010y;
          _8[2] = cb0_010z;
          _8[3] = cb0_010w;
          _8[4] = cb0_012x;
          _8[5] = cb0_012x;
          _9[0] = cb0_011x;
          _9[1] = cb0_011y;
          _9[2] = cb0_011z;
          _9[3] = cb0_011w;
          _9[4] = cb0_012y;
          _9[5] = cb0_012y;
          float _1984 = cb0_012z * _1206;
          float _1985 = cb0_012z * _1207;
          float _1986 = cb0_012z * _1208;
          float _1989 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1986, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1985, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1984)));
          float _1992 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1986, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1985, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1984)));
          float _1995 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1986, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1985, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1984)));
          float _1999 = max(max(_1989, _1992), _1995);
          float _2004 = (max(_1999, 1.000000013351432e-10f) - max(min(min(_1989, _1992), _1995), 1.000000013351432e-10f)) / max(_1999, 0.009999999776482582f);
          float _2017 = ((_1992 + _1989) + _1995) + (sqrt((((_1995 - _1992) * _1995) + ((_1992 - _1989) * _1992)) + ((_1989 - _1995) * _1989)) * 1.75f);
          float _2018 = _2017 * 0.3333333432674408f;
          float _2019 = _2004 + -0.4000000059604645f;
          float _2020 = _2019 * 5.0f;
          float _2024 = max((1.0f - abs(_2019 * 2.5f)), 0.0f);
          float _2035 = ((float(((int)(uint)((bool)(_2020 > 0.0f))) - ((int)(uint)((bool)(_2020 < 0.0f)))) * (1.0f - (_2024 * _2024))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2018 <= 0.0533333346247673f)) {
              if (!(_2018 >= 0.1599999964237213f)) {
                _2044 = (((0.23999999463558197f / _2017) + -0.5f) * _2035);
              } else {
                _2044 = 0.0f;
              }
            } else {
              _2044 = _2035;
            }
            float _2045 = _2044 + 1.0f;
            float _2046 = _2045 * _1989;
            float _2047 = _2045 * _1992;
            float _2048 = _2045 * _1995;
            do {
              if (!((bool)(_2046 == _2047) && (bool)(_2047 == _2048))) {
                float _2055 = ((_2046 * 2.0f) - _2047) - _2048;
                float _2058 = ((_1992 - _1995) * 1.7320507764816284f) * _2045;
                float _2060 = atan(_2058 / _2055);
                bool _2063 = (_2055 < 0.0f);
                bool _2064 = (_2055 == 0.0f);
                bool _2065 = (_2058 >= 0.0f);
                bool _2066 = (_2058 < 0.0f);
                float _2075 = select((_2065 && _2064), 90.0f, select((_2066 && _2064), -90.0f, (select((_2066 && _2063), (_2060 + -3.1415927410125732f), select((_2065 && _2063), (_2060 + 3.1415927410125732f), _2060)) * 57.2957763671875f)));
                if (_2075 < 0.0f) {
                  _2080 = (_2075 + 360.0f);
                } else {
                  _2080 = _2075;
                }
              } else {
                _2080 = 0.0f;
              }
              float _2082 = min(max(_2080, 0.0f), 360.0f);
              do {
                if (_2082 < -180.0f) {
                  _2091 = (_2082 + 360.0f);
                } else {
                  if (_2082 > 180.0f) {
                    _2091 = (_2082 + -360.0f);
                  } else {
                    _2091 = _2082;
                  }
                }
                do {
                  if ((bool)(_2091 > -67.5f) && (bool)(_2091 < 67.5f)) {
                    float _2097 = (_2091 + 67.5f) * 0.029629629105329514f;
                    int _2098 = int(_2097);
                    float _2100 = _2097 - float(_2098);
                    float _2101 = _2100 * _2100;
                    float _2102 = _2101 * _2100;
                    if (_2098 == 3) {
                      _2130 = (((0.1666666716337204f - (_2100 * 0.5f)) + (_2101 * 0.5f)) - (_2102 * 0.1666666716337204f));
                    } else {
                      if (_2098 == 2) {
                        _2130 = ((0.6666666865348816f - _2101) + (_2102 * 0.5f));
                      } else {
                        if (_2098 == 1) {
                          _2130 = (((_2102 * -0.5f) + 0.1666666716337204f) + ((_2101 + _2100) * 0.5f));
                        } else {
                          _2130 = select((_2098 == 0), (_2102 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2130 = 0.0f;
                  }
                  float _2139 = min(max(((((_2004 * 0.27000001072883606f) * (0.029999999329447746f - _2046)) * _2130) + _2046), 0.0f), 65535.0f);
                  float _2140 = min(max(_2047, 0.0f), 65535.0f);
                  float _2141 = min(max(_2048, 0.0f), 65535.0f);
                  float _2154 = min(max(mad(-0.21492856740951538f, _2141, mad(-0.2365107536315918f, _2140, (_2139 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2155 = min(max(mad(-0.09967592358589172f, _2141, mad(1.17622971534729f, _2140, (_2139 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2156 = min(max(mad(0.9977163076400757f, _2141, mad(-0.006032449658960104f, _2140, (_2139 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2157 = dot(float3(_2154, _2155, _2156), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2168 = log2(max((lerp(_2157, _2154, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2169 = _2168 * 0.3010300099849701f;
                  float _2170 = log2(cb0_008x);
                  float _2171 = _2170 * 0.3010300099849701f;
                  do {
                    if (!(!(_2169 <= _2171))) {
                      _2240 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2178 = log2(cb0_009x);
                      float _2179 = _2178 * 0.3010300099849701f;
                      if ((bool)(_2169 > _2171) && (bool)(_2169 < _2179)) {
                        float _2187 = ((_2168 - _2170) * 0.9030900001525879f) / ((_2178 - _2170) * 0.3010300099849701f);
                        int _2188 = int(_2187);
                        float _2190 = _2187 - float(_2188);
                        float _2192 = _8[_2188];
                        float _2195 = _8[(_2188 + 1)];
                        float _2200 = _2192 * 0.5f;
                        _2240 = dot(float3((_2190 * _2190), _2190, 1.0f), float3(mad((_8[(_2188 + 2)]), 0.5f, mad(_2195, -1.0f, _2200)), (_2195 - _2192), mad(_2195, 0.5f, _2200)));
                      } else {
                        do {
                          if (!(!(_2169 >= _2179))) {
                            float _2209 = log2(cb0_008z);
                            if (_2169 < (_2209 * 0.3010300099849701f)) {
                              float _2217 = ((_2168 - _2178) * 0.9030900001525879f) / ((_2209 - _2178) * 0.3010300099849701f);
                              int _2218 = int(_2217);
                              float _2220 = _2217 - float(_2218);
                              float _2222 = _9[_2218];
                              float _2225 = _9[(_2218 + 1)];
                              float _2230 = _2222 * 0.5f;
                              _2240 = dot(float3((_2220 * _2220), _2220, 1.0f), float3(mad((_9[(_2218 + 2)]), 0.5f, mad(_2225, -1.0f, _2230)), (_2225 - _2222), mad(_2225, 0.5f, _2230)));
                              break;
                            }
                          }
                          _2240 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2244 = log2(max((lerp(_2157, _2155, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2245 = _2244 * 0.3010300099849701f;
                    do {
                      if (!(!(_2245 <= _2171))) {
                        _2314 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2252 = log2(cb0_009x);
                        float _2253 = _2252 * 0.3010300099849701f;
                        if ((bool)(_2245 > _2171) && (bool)(_2245 < _2253)) {
                          float _2261 = ((_2244 - _2170) * 0.9030900001525879f) / ((_2252 - _2170) * 0.3010300099849701f);
                          int _2262 = int(_2261);
                          float _2264 = _2261 - float(_2262);
                          float _2266 = _8[_2262];
                          float _2269 = _8[(_2262 + 1)];
                          float _2274 = _2266 * 0.5f;
                          _2314 = dot(float3((_2264 * _2264), _2264, 1.0f), float3(mad((_8[(_2262 + 2)]), 0.5f, mad(_2269, -1.0f, _2274)), (_2269 - _2266), mad(_2269, 0.5f, _2274)));
                        } else {
                          do {
                            if (!(!(_2245 >= _2253))) {
                              float _2283 = log2(cb0_008z);
                              if (_2245 < (_2283 * 0.3010300099849701f)) {
                                float _2291 = ((_2244 - _2252) * 0.9030900001525879f) / ((_2283 - _2252) * 0.3010300099849701f);
                                int _2292 = int(_2291);
                                float _2294 = _2291 - float(_2292);
                                float _2296 = _9[_2292];
                                float _2299 = _9[(_2292 + 1)];
                                float _2304 = _2296 * 0.5f;
                                _2314 = dot(float3((_2294 * _2294), _2294, 1.0f), float3(mad((_9[(_2292 + 2)]), 0.5f, mad(_2299, -1.0f, _2304)), (_2299 - _2296), mad(_2299, 0.5f, _2304)));
                                break;
                              }
                            }
                            _2314 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2318 = log2(max((lerp(_2157, _2156, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2319 = _2318 * 0.3010300099849701f;
                      do {
                        if (!(!(_2319 <= _2171))) {
                          _2388 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2326 = log2(cb0_009x);
                          float _2327 = _2326 * 0.3010300099849701f;
                          if ((bool)(_2319 > _2171) && (bool)(_2319 < _2327)) {
                            float _2335 = ((_2318 - _2170) * 0.9030900001525879f) / ((_2326 - _2170) * 0.3010300099849701f);
                            int _2336 = int(_2335);
                            float _2338 = _2335 - float(_2336);
                            float _2340 = _8[_2336];
                            float _2343 = _8[(_2336 + 1)];
                            float _2348 = _2340 * 0.5f;
                            _2388 = dot(float3((_2338 * _2338), _2338, 1.0f), float3(mad((_8[(_2336 + 2)]), 0.5f, mad(_2343, -1.0f, _2348)), (_2343 - _2340), mad(_2343, 0.5f, _2348)));
                          } else {
                            do {
                              if (!(!(_2319 >= _2327))) {
                                float _2357 = log2(cb0_008z);
                                if (_2319 < (_2357 * 0.3010300099849701f)) {
                                  float _2365 = ((_2318 - _2326) * 0.9030900001525879f) / ((_2357 - _2326) * 0.3010300099849701f);
                                  int _2366 = int(_2365);
                                  float _2368 = _2365 - float(_2366);
                                  float _2370 = _9[_2366];
                                  float _2373 = _9[(_2366 + 1)];
                                  float _2378 = _2370 * 0.5f;
                                  _2388 = dot(float3((_2368 * _2368), _2368, 1.0f), float3(mad((_9[(_2366 + 2)]), 0.5f, mad(_2373, -1.0f, _2378)), (_2373 - _2370), mad(_2373, 0.5f, _2378)));
                                  break;
                                }
                              }
                              _2388 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2392 = cb0_008w - cb0_008y;
                        float _2393 = (exp2(_2240 * 3.321928024291992f) - cb0_008y) / _2392;
                        float _2395 = (exp2(_2314 * 3.321928024291992f) - cb0_008y) / _2392;
                        float _2397 = (exp2(_2388 * 3.321928024291992f) - cb0_008y) / _2392;
                        float _2400 = mad(0.15618768334388733f, _2397, mad(0.13400420546531677f, _2395, (_2393 * 0.6624541878700256f)));
                        float _2403 = mad(0.053689517080783844f, _2397, mad(0.6740817427635193f, _2395, (_2393 * 0.2722287178039551f)));
                        float _2406 = mad(1.0103391408920288f, _2397, mad(0.00406073359772563f, _2395, (_2393 * -0.005574649665504694f)));
                        float _2419 = min(max(mad(-0.23642469942569733f, _2406, mad(-0.32480329275131226f, _2403, (_2400 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2420 = min(max(mad(0.016756348311901093f, _2406, mad(1.6153316497802734f, _2403, (_2400 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2421 = min(max(mad(0.9883948564529419f, _2406, mad(-0.008284442126750946f, _2403, (_2400 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2424 = mad(0.15618768334388733f, _2421, mad(0.13400420546531677f, _2420, (_2419 * 0.6624541878700256f)));
                        float _2427 = mad(0.053689517080783844f, _2421, mad(0.6740817427635193f, _2420, (_2419 * 0.2722287178039551f)));
                        float _2430 = mad(1.0103391408920288f, _2421, mad(0.00406073359772563f, _2420, (_2419 * -0.005574649665504694f)));
                        float _2452 = min(max((min(max(mad(-0.23642469942569733f, _2430, mad(-0.32480329275131226f, _2427, (_2424 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2453 = min(max((min(max(mad(0.016756348311901093f, _2430, mad(1.6153316497802734f, _2427, (_2424 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2454 = min(max((min(max(mad(0.9883948564529419f, _2430, mad(-0.008284442126750946f, _2427, (_2424 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!((uint)(output_device) == 6)) {
                            _2467 = mad(_39, _2454, mad(_38, _2453, (_2452 * _37)));
                            _2468 = mad(_42, _2454, mad(_41, _2453, (_2452 * _40)));
                            _2469 = mad(_45, _2454, mad(_44, _2453, (_2452 * _43)));
                          } else {
                            _2467 = _2452;
                            _2468 = _2453;
                            _2469 = _2454;
                          }
                          float _2479 = exp2(log2(_2467 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2480 = exp2(log2(_2468 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2481 = exp2(log2(_2469 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2646 = exp2(log2((1.0f / ((_2479 * 18.6875f) + 1.0f)) * ((_2479 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2647 = exp2(log2((1.0f / ((_2480 * 18.6875f) + 1.0f)) * ((_2480 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2648 = exp2(log2((1.0f / ((_2481 * 18.6875f) + 1.0f)) * ((_2481 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if ((uint)(output_device) == 7) {
            float _2526 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1208, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1207, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1206)));
            float _2529 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1208, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1207, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1206)));
            float _2532 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1208, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1207, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1206)));
            float _2551 = exp2(log2(mad(_39, _2532, mad(_38, _2529, (_2526 * _37))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2552 = exp2(log2(mad(_42, _2532, mad(_41, _2529, (_2526 * _40))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2553 = exp2(log2(mad(_45, _2532, mad(_44, _2529, (_2526 * _43))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2646 = exp2(log2((1.0f / ((_2551 * 18.6875f) + 1.0f)) * ((_2551 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2647 = exp2(log2((1.0f / ((_2552 * 18.6875f) + 1.0f)) * ((_2552 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2648 = exp2(log2((1.0f / ((_2553 * 18.6875f) + 1.0f)) * ((_2553 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(output_device) == 8)) {
              if ((uint)(output_device) == 9) {
                float _2600 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1196, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1195, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1194)));
                float _2603 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1196, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1195, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1194)));
                float _2606 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1196, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1195, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1194)));
                _2646 = mad(_39, _2606, mad(_38, _2603, (_2600 * _37)));
                _2647 = mad(_42, _2606, mad(_41, _2603, (_2600 * _40)));
                _2648 = mad(_45, _2606, mad(_44, _2603, (_2600 * _43)));
              } else {
                float _2619 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1220)));
                float _2622 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1220)));
                float _2625 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1222, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1221, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1220)));
                _2646 = exp2(log2(mad(_39, _2625, mad(_38, _2622, (_2619 * _37)))) * cb0_040z);
                _2647 = exp2(log2(mad(_42, _2625, mad(_41, _2622, (_2619 * _40)))) * cb0_040z);
                _2648 = exp2(log2(mad(_45, _2625, mad(_44, _2622, (_2619 * _43)))) * cb0_040z);
              }
            } else {
              _2646 = _1206;
              _2647 = _1207;
              _2648 = _1208;
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
