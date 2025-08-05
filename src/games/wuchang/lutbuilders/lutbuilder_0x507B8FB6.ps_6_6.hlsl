#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

cbuffer cb1 : register(b1) {
  float4 UniformBufferConstants_WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 UniformBufferConstants_WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 UniformBufferConstants_WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 UniformBufferConstants_WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 UniformBufferConstants_WorkingColorSpace_256[4] : packoffset(c016.x);
  int UniformBufferConstants_WorkingColorSpace_320 : packoffset(c020.x);
};

SamplerState s0 : register(s0);

float4 main(
  noperspective float2 TEXCOORD : TEXCOORD,
  noperspective float4 SV_Position : SV_Position,
  nointerpolation uint SV_RenderTargetArrayIndex : SV_RenderTargetArrayIndex
) : SV_Target {
  uint output_gamut = cb0_041x;
  uint output_device = cb0_040w;
  float expand_gamut = cb0_036w;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 output_color;

  float4 SV_Target;
  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _14 = TEXCOORD.x + -0.015625f;
  float _15 = TEXCOORD.y + -0.015625f;
  float _18 = float((uint)(int)(SV_RenderTargetArrayIndex));
  float _39;
  float _40;
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _105;
  float _106;
  float _107;
  float _156;
  float _885;
  float _921;
  float _932;
  float _996;
  float _1175;
  float _1186;
  float _1197;
  float _1370;
  float _1371;
  float _1372;
  float _1383;
  float _1394;
  float _1576;
  float _1612;
  float _1623;
  float _1662;
  float _1772;
  float _1846;
  float _1920;
  float _1999;
  float _2000;
  float _2001;
  float _2152;
  float _2188;
  float _2199;
  float _2238;
  float _2348;
  float _2422;
  float _2496;
  float _2575;
  float _2576;
  float _2577;
  float _2754;
  float _2755;
  float _2756;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _28 = (output_gamut == 4);
        _39 = select(_28, 1.0f, 1.7050515413284302f);
        _40 = select(_28, 0.0f, -0.6217905879020691f);
        _41 = select(_28, 0.0f, -0.0832584798336029f);
        _42 = select(_28, 0.0f, -0.13025718927383423f);
        _43 = select(_28, 1.0f, 1.1408027410507202f);
        _44 = select(_28, 0.0f, -0.010548528283834457f);
        _45 = select(_28, 0.0f, -0.024003278464078903f);
        _46 = select(_28, 0.0f, -0.1289687603712082f);
        _47 = select(_28, 1.0f, 1.152971863746643f);
      } else {
        _39 = 0.6954522132873535f;
        _40 = 0.14067870378494263f;
        _41 = 0.16386906802654266f;
        _42 = 0.044794563204050064f;
        _43 = 0.8596711158752441f;
        _44 = 0.0955343171954155f;
        _45 = -0.005525882821530104f;
        _46 = 0.004025210160762072f;
        _47 = 1.0015007257461548f;
      }
    } else {
      _39 = 1.02579927444458f;
      _40 = -0.020052503794431686f;
      _41 = -0.0057713985443115234f;
      _42 = -0.0022350111976265907f;
      _43 = 1.0045825242996216f;
      _44 = -0.002352306619286537f;
      _45 = -0.005014004185795784f;
      _46 = -0.025293385609984398f;
      _47 = 1.0304402112960815f;
    }
  } else {
    _39 = 1.379158854484558f;
    _40 = -0.3088507056236267f;
    _41 = -0.07034677267074585f;
    _42 = -0.06933528929948807f;
    _43 = 1.0822921991348267f;
    _44 = -0.012962047010660172f;
    _45 = -0.002159259282052517f;
    _46 = -0.045465391129255295f;
    _47 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _58 = exp2(log2(_14 * 1.0322580337524414f) * 0.012683313339948654f);
    float _59 = exp2(log2(_15 * 1.0322580337524414f) * 0.012683313339948654f);
    float _60 = exp2(log2(_18 * 0.032258063554763794f) * 0.012683313339948654f);
    _105 = (exp2(log2(max(0.0f, (_58 + -0.8359375f)) / (18.8515625f - (_58 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _106 = (exp2(log2(max(0.0f, (_59 + -0.8359375f)) / (18.8515625f - (_59 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _105 = ((exp2((_14 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _106 = ((exp2((_15 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _107 = ((exp2((_18 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _134 = (cb0_038z != 0);
  float _139 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _156 = (((((2967800.0f - (_139 * 4607000064.0f)) * _139) + 99.11000061035156f) * _139) + 0.24406300485134125f);
  } else {
    _156 = (((((1901800.0f - (_139 * 2006400000.0f)) * _139) + 247.47999572753906f) * _139) + 0.23703999817371368f);
  }
  float _170 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _177 = cb0_035x * cb0_035x;
  float _180 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_177 * 1.6145605741257896e-07f));
  float _185 = ((_170 * 2.0f) + 4.0f) - (_180 * 8.0f);
  float _186 = (_170 * 3.0f) / _185;
  float _188 = (_180 * 2.0f) / _185;
  bool _189 = (cb0_035x < 4000.0f);
  float _198 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _200 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_177 * 1.5317699909210205f)) / (_198 * _198);
  float _207 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _177;
  float _209 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_177 * 308.60699462890625f)) / (_207 * _207);
  float _211 = rsqrt(dot(float2(_200, _209), float2(_200, _209)));
  float _212 = cb0_035y * 0.05000000074505806f;
  float _215 = ((_212 * _209) * _211) + _170;
  float _218 = _180 - ((_212 * _200) * _211);
  float _223 = (4.0f - (_218 * 8.0f)) + (_215 * 2.0f);
  float _229 = (((_215 * 3.0f) / _223) - _186) + select(_189, _186, _156);
  float _230 = (((_218 * 2.0f) / _223) - _188) + select(_189, _188, (((_156 * 2.869999885559082f) + -0.2750000059604645f) - ((_156 * _156) * 3.0f)));
  float _231 = select(_134, _229, 0.3127000033855438f);
  float _232 = select(_134, _230, 0.32899999618530273f);
  float _233 = select(_134, 0.3127000033855438f, _229);
  float _234 = select(_134, 0.32899999618530273f, _230);
  float _235 = max(_232, 1.000000013351432e-10f);
  float _236 = _231 / _235;
  float _239 = ((1.0f - _231) - _232) / _235;
  float _240 = max(_234, 1.000000013351432e-10f);
  float _241 = _233 / _240;
  float _244 = ((1.0f - _233) - _234) / _240;
  float _263 = mad(-0.16140000522136688f, _244, ((_241 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _239, ((_236 * 0.8950999975204468f) + 0.266400009393692f));
  float _264 = mad(0.03669999912381172f, _244, (1.7135000228881836f - (_241 * 0.7501999735832214f))) / mad(0.03669999912381172f, _239, (1.7135000228881836f - (_236 * 0.7501999735832214f)));
  float _265 = mad(1.0296000242233276f, _244, ((_241 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _239, ((_236 * 0.03889999911189079f) + -0.06849999725818634f));
  float _266 = mad(_264, -0.7501999735832214f, 0.0f);
  float _267 = mad(_264, 1.7135000228881836f, 0.0f);
  float _268 = mad(_264, 0.03669999912381172f, -0.0f);
  float _269 = mad(_265, 0.03889999911189079f, 0.0f);
  float _270 = mad(_265, -0.06849999725818634f, 0.0f);
  float _271 = mad(_265, 1.0296000242233276f, 0.0f);
  float _274 = mad(0.1599626988172531f, _269, mad(-0.1470542997121811f, _266, (_263 * 0.883457362651825f)));
  float _277 = mad(0.1599626988172531f, _270, mad(-0.1470542997121811f, _267, (_263 * 0.26293492317199707f)));
  float _280 = mad(0.1599626988172531f, _271, mad(-0.1470542997121811f, _268, (_263 * -0.15930065512657166f)));
  float _283 = mad(0.04929120093584061f, _269, mad(0.5183603167533875f, _266, (_263 * 0.38695648312568665f)));
  float _286 = mad(0.04929120093584061f, _270, mad(0.5183603167533875f, _267, (_263 * 0.11516613513231277f)));
  float _289 = mad(0.04929120093584061f, _271, mad(0.5183603167533875f, _268, (_263 * -0.0697740763425827f)));
  float _292 = mad(0.9684867262840271f, _269, mad(0.04004279896616936f, _266, (_263 * -0.007634039502590895f)));
  float _295 = mad(0.9684867262840271f, _270, mad(0.04004279896616936f, _267, (_263 * -0.0022720457054674625f)));
  float _298 = mad(0.9684867262840271f, _271, mad(0.04004279896616936f, _268, (_263 * 0.0013765322510153055f)));
  float _301 = mad(_280, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_277, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_274 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _304 = mad(_280, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_277, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_274 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _307 = mad(_280, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_277, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_274 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _310 = mad(_289, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_286, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_283 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _313 = mad(_289, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_286, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_283 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _316 = mad(_289, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_286, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_283 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _319 = mad(_298, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_295, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_292 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _322 = mad(_298, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_295, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_292 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _325 = mad(_298, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_295, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_292 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _355 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _325, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _316, (_307 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _107, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _322, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _313, (_304 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _106, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _319, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _310, (_301 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _105)));
  float _358 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _325, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _316, (_307 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _107, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _322, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _313, (_304 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _106, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _319, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _310, (_301 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _105)));
  float _361 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _325, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _316, (_307 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _107, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _322, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _313, (_304 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _106, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _319, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _310, (_301 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _105)));
  float _376 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _361, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _358, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _355)));
  float _379 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _361, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _358, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _355)));
  float _382 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _361, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _358, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _355)));
  float _383 = dot(float3(_376, _379, _382), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }

  float _387 = (_376 / _383) + -1.0f;
  float _388 = (_379 / _383) + -1.0f;
  float _389 = (_382 / _383) + -1.0f;
  float _401 = (1.0f - exp2(((_383 * _383) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_387, _388, _389), float3(_387, _388, _389)) * -4.0f));
  float _417 = ((mad(-0.06368283927440643f, _382, mad(-0.32929131388664246f, _379, (_376 * 1.370412826538086f))) - _376) * _401) + _376;
  float _418 = ((mad(-0.010861567221581936f, _382, mad(1.0970908403396606f, _379, (_376 * -0.08343426138162613f))) - _379) * _401) + _379;
  float _419 = ((mad(1.203694462776184f, _382, mad(-0.09862564504146576f, _379, (_376 * -0.02579325996339321f))) - _382) * _401) + _382;
  float _420 = dot(float3(_417, _418, _419), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _434 = cb0_019w + cb0_024w;
  float _448 = cb0_018w * cb0_023w;
  float _462 = cb0_017w * cb0_022w;
  float _476 = cb0_016w * cb0_021w;
  float _490 = cb0_015w * cb0_020w;
  float _494 = _417 - _420;
  float _495 = _418 - _420;
  float _496 = _419 - _420;
  float _553 = saturate(_420 / cb0_035z);
  float _557 = (_553 * _553) * (3.0f - (_553 * 2.0f));
  float _558 = 1.0f - _557;
  float _567 = cb0_019w + cb0_034w;
  float _576 = cb0_018w * cb0_033w;
  float _585 = cb0_017w * cb0_032w;
  float _594 = cb0_016w * cb0_031w;
  float _603 = cb0_015w * cb0_030w;
  float _667 = saturate((_420 - cb0_035w) / (cb0_036x - cb0_035w));
  float _671 = (_667 * _667) * (3.0f - (_667 * 2.0f));
  float _680 = cb0_019w + cb0_029w;
  float _689 = cb0_018w * cb0_028w;
  float _698 = cb0_017w * cb0_027w;
  float _707 = cb0_016w * cb0_026w;
  float _716 = cb0_015w * cb0_025w;
  float _774 = _557 - _671;
  float _785 = ((_671 * (((cb0_019x + cb0_034x) + _567) + (((cb0_018x * cb0_033x) * _576) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _594) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _603) * _494) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _585)))))) + (_558 * (((cb0_019x + cb0_024x) + _434) + (((cb0_018x * cb0_023x) * _448) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _476) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _490) * _494) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _462))))))) + ((((cb0_019x + cb0_029x) + _680) + (((cb0_018x * cb0_028x) * _689) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _707) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _716) * _494) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _698))))) * _774);
  float _787 = ((_671 * (((cb0_019y + cb0_034y) + _567) + (((cb0_018y * cb0_033y) * _576) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _594) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _603) * _495) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _585)))))) + (_558 * (((cb0_019y + cb0_024y) + _434) + (((cb0_018y * cb0_023y) * _448) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _476) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _490) * _495) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _462))))))) + ((((cb0_019y + cb0_029y) + _680) + (((cb0_018y * cb0_028y) * _689) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _707) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _716) * _495) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _698))))) * _774);
  float _789 = ((_671 * (((cb0_019z + cb0_034z) + _567) + (((cb0_018z * cb0_033z) * _576) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _594) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _603) * _496) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _585)))))) + (_558 * (((cb0_019z + cb0_024z) + _434) + (((cb0_018z * cb0_023z) * _448) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _476) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _490) * _496) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _462))))))) + ((((cb0_019z + cb0_029z) + _680) + (((cb0_018z * cb0_028z) * _689) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _707) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _716) * _496) + _420)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _698))))) * _774);
  float _825 = ((mad(0.061360642313957214f, _789, mad(-4.540197551250458e-09f, _787, (_785 * 0.9386394023895264f))) - _785) * cb0_036y) + _785;
  float _826 = ((mad(0.169205904006958f, _789, mad(0.8307942152023315f, _787, (_785 * 6.775371730327606e-08f))) - _787) * cb0_036y) + _787;
  float _827 = (mad(-2.3283064365386963e-10f, _787, (_785 * -9.313225746154785e-10f)) * cb0_036y) + _789;
  float _830 = mad(0.16386905312538147f, _827, mad(0.14067868888378143f, _826, (_825 * 0.6954522132873535f)));
  float _833 = mad(0.0955343246459961f, _827, mad(0.8596711158752441f, _826, (_825 * 0.044794581830501556f)));
  float _836 = mad(1.0015007257461548f, _827, mad(0.004025210160762072f, _826, (_825 * -0.005525882821530104f)));
  float _840 = max(max(_830, _833), _836);
  float _845 = (max(_840, 1.000000013351432e-10f) - max(min(min(_830, _833), _836), 1.000000013351432e-10f)) / max(_840, 0.009999999776482582f);
  float _858 = ((_833 + _830) + _836) + (sqrt((((_836 - _833) * _836) + ((_833 - _830) * _833)) + ((_830 - _836) * _830)) * 1.75f);
  float _859 = _858 * 0.3333333432674408f;
  float _860 = _845 + -0.4000000059604645f;
  float _861 = _860 * 5.0f;
  float _865 = max((1.0f - abs(_860 * 2.5f)), 0.0f);
  float _876 = ((float((int)(((int)(uint)((bool)(_861 > 0.0f))) - ((int)(uint)((bool)(_861 < 0.0f))))) * (1.0f - (_865 * _865))) + 1.0f) * 0.02500000037252903f;
  if (!(_859 <= 0.0533333346247673f)) {
    if (!(_859 >= 0.1599999964237213f)) {
      _885 = (((0.23999999463558197f / _858) + -0.5f) * _876);
    } else {
      _885 = 0.0f;
    }
  } else {
    _885 = _876;
  }
  float _886 = _885 + 1.0f;
  float _887 = _886 * _830;
  float _888 = _886 * _833;
  float _889 = _886 * _836;
  if (!((bool)(_887 == _888) && (bool)(_888 == _889))) {
    float _896 = ((_887 * 2.0f) - _888) - _889;
    float _899 = ((_833 - _836) * 1.7320507764816284f) * _886;
    float _901 = atan(_899 / _896);
    bool _904 = (_896 < 0.0f);
    bool _905 = (_896 == 0.0f);
    bool _906 = (_899 >= 0.0f);
    bool _907 = (_899 < 0.0f);
    float _916 = select((_906 && _905), 90.0f, select((_907 && _905), -90.0f, (select((_907 && _904), (_901 + -3.1415927410125732f), select((_906 && _904), (_901 + 3.1415927410125732f), _901)) * 57.2957763671875f)));
    if (_916 < 0.0f) {
      _921 = (_916 + 360.0f);
    } else {
      _921 = _916;
    }
  } else {
    _921 = 0.0f;
  }
  float _923 = min(max(_921, 0.0f), 360.0f);
  if (_923 < -180.0f) {
    _932 = (_923 + 360.0f);
  } else {
    if (_923 > 180.0f) {
      _932 = (_923 + -360.0f);
    } else {
      _932 = _923;
    }
  }
  float _936 = saturate(1.0f - abs(_932 * 0.014814814552664757f));
  float _940 = (_936 * _936) * (3.0f - (_936 * 2.0f));
  float _946 = ((_940 * _940) * ((_845 * 0.18000000715255737f) * (0.029999999329447746f - _887))) + _887;
  float _956 = max(0.0f, mad(-0.21492856740951538f, _889, mad(-0.2365107536315918f, _888, (_946 * 1.4514392614364624f))));
  float _957 = max(0.0f, mad(-0.09967592358589172f, _889, mad(1.17622971534729f, _888, (_946 * -0.07655377686023712f))));
  float _958 = max(0.0f, mad(0.9977163076400757f, _889, mad(-0.006032449658960104f, _888, (_946 * 0.008316148072481155f))));
  float _959 = dot(float3(_956, _957, _958), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _973 = (cb0_037w + 1.0f) - cb0_037y;
  float _976 = cb0_038x + 1.0f;
  float _978 = _976 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _996 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _987 = (cb0_037w + 0.18000000715255737f) / _973;
    _996 = (-0.7447274923324585f - ((log2(_987 / (2.0f - _987)) * 0.3465735912322998f) * (_973 / cb0_037x)));
  }
  float _999 = ((1.0f - cb0_037y) / cb0_037x) - _996;
  float _1001 = (cb0_037z / cb0_037x) - _999;

  float3 lerpColor = lerp(_959, float3(_956, _957, _958), 0.9599999785423279f);

#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _825, _826, _827);
  float _1147 = lerpColor.r, _1148 = lerpColor.g, _1149 = lerpColor.b;
#else
  float _1005 = log2(lerp(_959, _956, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1006 = log2(lerp(_959, _957, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1007 = log2(lerp(_959, _958, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1011 = cb0_037x * (_1005 + _999);
  float _1012 = cb0_037x * (_1006 + _999);
  float _1013 = cb0_037x * (_1007 + _999);
  float _1014 = _973 * 2.0f;
  float _1016 = (cb0_037x * -2.0f) / _973;
  float _1017 = _1005 - _996;
  float _1018 = _1006 - _996;
  float _1019 = _1007 - _996;
  float _1038 = _978 * 2.0f;
  float _1040 = (cb0_037x * 2.0f) / _978;
  float _1065 = select((_1005 < _996), ((_1014 / (exp2((_1017 * 1.4426950216293335f) * _1016) + 1.0f)) - cb0_037w), _1011);
  float _1066 = select((_1006 < _996), ((_1014 / (exp2((_1018 * 1.4426950216293335f) * _1016) + 1.0f)) - cb0_037w), _1012);
  float _1067 = select((_1007 < _996), ((_1014 / (exp2((_1019 * 1.4426950216293335f) * _1016) + 1.0f)) - cb0_037w), _1013);
  float _1074 = _1001 - _996;
  float _1078 = saturate(_1017 / _1074);
  float _1079 = saturate(_1018 / _1074);
  float _1080 = saturate(_1019 / _1074);
  bool _1081 = (_1001 < _996);
  float _1085 = select(_1081, (1.0f - _1078), _1078);
  float _1086 = select(_1081, (1.0f - _1079), _1079);
  float _1087 = select(_1081, (1.0f - _1080), _1080);
  float _1106 = (((_1085 * _1085) * (select((_1005 > _1001), (_976 - (_1038 / (exp2(((_1005 - _1001) * 1.4426950216293335f) * _1040) + 1.0f))), _1011) - _1065)) * (3.0f - (_1085 * 2.0f))) + _1065;
  float _1107 = (((_1086 * _1086) * (select((_1006 > _1001), (_976 - (_1038 / (exp2(((_1006 - _1001) * 1.4426950216293335f) * _1040) + 1.0f))), _1012) - _1066)) * (3.0f - (_1086 * 2.0f))) + _1066;
  float _1108 = (((_1087 * _1087) * (select((_1007 > _1001), (_976 - (_1038 / (exp2(((_1007 - _1001) * 1.4426950216293335f) * _1040) + 1.0f))), _1013) - _1067)) * (3.0f - (_1087 * 2.0f))) + _1067;
  float _1109 = dot(float3(_1106, _1107, _1108), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1129 = (expand_gamut * (max(0.0f, (lerp(_1109, _1106, 0.9300000071525574f))) - _825)) + _825;
  float _1130 = (expand_gamut * (max(0.0f, (lerp(_1109, _1107, 0.9300000071525574f))) - _826)) + _826;
  float _1131 = (expand_gamut * (max(0.0f, (lerp(_1109, _1108, 0.9300000071525574f))) - _827)) + _827;
  float _1147 = ((mad(-0.06537103652954102f, _1131, mad(1.451815478503704e-06f, _1130, (_1129 * 1.065374732017517f))) - _1129) * cb0_036y) + _1129;
  float _1148 = ((mad(-0.20366770029067993f, _1131, mad(1.2036634683609009f, _1130, (_1129 * -2.57161445915699e-07f))) - _1130) * cb0_036y) + _1130;
  float _1149 = ((mad(0.9999996423721313f, _1131, mad(2.0954757928848267e-08f, _1130, (_1129 * 1.862645149230957e-08f))) - _1131) * cb0_036y) + _1131;
#endif

  float _1162 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1149, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1148, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1147))));
  float _1163 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1149, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1148, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1147))));
  float _1164 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1149, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1148, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1147))));
  // float _1162 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1149, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1148, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1147)))));
  // float _1163 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1149, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1148, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1147)))));
  // float _1164 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1149, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1148, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1147)))));
  // if (_1162 < 0.0031306699384003878f) {
  //   _1175 = (_1162 * 12.920000076293945f);
  // } else {
  //   _1175 = (((pow(_1162, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  // }
  // if (_1163 < 0.0031306699384003878f) {
  //   _1186 = (_1163 * 12.920000076293945f);
  // } else {
  //   _1186 = (((pow(_1163, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  // }
  // if (_1164 < 0.0031306699384003878f) {
  //   _1197 = (_1164 * 12.920000076293945f);
  // } else {
  //   _1197 = (((pow(_1164, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  // }
  // float _1201 = (_1186 * 0.9375f) + 0.03125f;
  // float _1208 = _1197 * 15.0f;
  // float _1209 = floor(_1208);
  // float _1210 = _1208 - _1209;
  // float _1212 = (((_1175 * 0.9375f) + 0.03125f) + _1209) * 0.0625f;
  // float4 _1215 = t0.Sample(s0, float2(_1212, _1201));
  // float4 _1222 = t0.Sample(s0, float2((_1212 + 0.0625f), _1201));
  // float _1241 = max(6.103519990574569e-05f, (((lerp(_1215.x, _1222.x, _1210)) * cb0_005y) + (cb0_005x * _1175)));
  // float _1242 = max(6.103519990574569e-05f, (((lerp(_1215.y, _1222.y, _1210)) * cb0_005y) + (cb0_005x * _1186)));
  // float _1243 = max(6.103519990574569e-05f, (((lerp(_1215.z, _1222.z, _1210)) * cb0_005y) + (cb0_005x * _1197)));
  // float _1265 = select((_1241 > 0.040449999272823334f), exp2(log2((_1241 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1241 * 0.07739938050508499f));
  // float _1266 = select((_1242 > 0.040449999272823334f), exp2(log2((_1242 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1242 * 0.07739938050508499f));
  // float _1267 = select((_1243 > 0.040449999272823334f), exp2(log2((_1243 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1243 * 0.07739938050508499f));

  float3 untonemapped = float3(_1162, _1163, _1164);
  float _1265, _1266, _1267;
  SampleLUTUpgradeToneMap(untonemapped, s0, t0, _1265, _1266, _1267);

  float _1293 = cb0_014x * (((cb0_039y + (cb0_039x * _1265)) * _1265) + cb0_039z);
  float _1294 = cb0_014y * (((cb0_039y + (cb0_039x * _1266)) * _1266) + cb0_039z);
  float _1295 = cb0_014z * (((cb0_039y + (cb0_039x * _1267)) * _1267) + cb0_039z);
  float _1302 = ((cb0_013x - _1293) * cb0_013w) + _1293;
  float _1303 = ((cb0_013y - _1294) * cb0_013w) + _1294;
  float _1304 = ((cb0_013z - _1295) * cb0_013w) + _1295;

  if (GenerateOutput(_1302, _1303, _1304, SV_Target, is_hdr)) {
    return SV_Target;
  }

  float _1305 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _789, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _787, (_785 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1306 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _789, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _787, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _785)));
  float _1307 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _789, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _787, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _785)));
  float _1314 = ((cb0_013x - _1305) * cb0_013w) + _1305;
  float _1315 = ((cb0_013y - _1306) * cb0_013w) + _1306;
  float _1316 = ((cb0_013z - _1307) * cb0_013w) + _1307;
  float _1328 = exp2(log2(max(0.0f, _1302)) * cb0_040y);
  float _1329 = exp2(log2(max(0.0f, _1303)) * cb0_040y);
  float _1330 = exp2(log2(max(0.0f, _1304)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1353 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1328)));
        float _1356 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1328)));
        float _1359 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1328)));
        _1370 = mad(_41, _1359, mad(_40, _1356, (_1353 * _39)));
        _1371 = mad(_44, _1359, mad(_43, _1356, (_1353 * _42)));
        _1372 = mad(_47, _1359, mad(_46, _1356, (_1353 * _45)));
      } else {
        _1370 = _1328;
        _1371 = _1329;
        _1372 = _1330;
      }
      do {
        if (_1370 < 0.0031306699384003878f) {
          _1383 = (_1370 * 12.920000076293945f);
        } else {
          _1383 = (((pow(_1370, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1371 < 0.0031306699384003878f) {
            _1394 = (_1371 * 12.920000076293945f);
          } else {
            _1394 = (((pow(_1371, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1372 < 0.0031306699384003878f) {
            _2754 = _1383;
            _2755 = _1394;
            _2756 = (_1372 * 12.920000076293945f);
          } else {
            _2754 = _1383;
            _2755 = _1394;
            _2756 = (((pow(_1372, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1421 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1328)));
      float _1424 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1328)));
      float _1427 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1328)));
      float _1437 = max(6.103519990574569e-05f, mad(_41, _1427, mad(_40, _1424, (_1421 * _39))));
      float _1438 = max(6.103519990574569e-05f, mad(_44, _1427, mad(_43, _1424, (_1421 * _42))));
      float _1439 = max(6.103519990574569e-05f, mad(_47, _1427, mad(_46, _1424, (_1421 * _45))));
      _2754 = min((_1437 * 4.5f), ((exp2(log2(max(_1437, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2755 = min((_1438 * 4.5f), ((exp2(log2(max(_1438, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2756 = min((_1439 * 4.5f), ((exp2(log2(max(_1439, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
        _12[0] = cb0_010x;
        _12[1] = cb0_010y;
        _12[2] = cb0_010z;
        _12[3] = cb0_010w;
        _12[4] = cb0_012x;
        _12[5] = cb0_012x;
        _13[0] = cb0_011x;
        _13[1] = cb0_011y;
        _13[2] = cb0_011z;
        _13[3] = cb0_011w;
        _13[4] = cb0_012y;
        _13[5] = cb0_012y;
        float _1516 = cb0_012z * _1314;
        float _1517 = cb0_012z * _1315;
        float _1518 = cb0_012z * _1316;
        float _1521 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1518, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1517, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1516)));
        float _1524 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1518, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1517, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1516)));
        float _1527 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1518, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1517, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1516)));
        float _1531 = max(max(_1521, _1524), _1527);
        float _1536 = (max(_1531, 1.000000013351432e-10f) - max(min(min(_1521, _1524), _1527), 1.000000013351432e-10f)) / max(_1531, 0.009999999776482582f);
        float _1549 = ((_1524 + _1521) + _1527) + (sqrt((((_1527 - _1524) * _1527) + ((_1524 - _1521) * _1524)) + ((_1521 - _1527) * _1521)) * 1.75f);
        float _1550 = _1549 * 0.3333333432674408f;
        float _1551 = _1536 + -0.4000000059604645f;
        float _1552 = _1551 * 5.0f;
        float _1556 = max((1.0f - abs(_1551 * 2.5f)), 0.0f);
        float _1567 = ((float((int)(((int)(uint)((bool)(_1552 > 0.0f))) - ((int)(uint)((bool)(_1552 < 0.0f))))) * (1.0f - (_1556 * _1556))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1550 <= 0.0533333346247673f)) {
            if (!(_1550 >= 0.1599999964237213f)) {
              _1576 = (((0.23999999463558197f / _1549) + -0.5f) * _1567);
            } else {
              _1576 = 0.0f;
            }
          } else {
            _1576 = _1567;
          }
          float _1577 = _1576 + 1.0f;
          float _1578 = _1577 * _1521;
          float _1579 = _1577 * _1524;
          float _1580 = _1577 * _1527;
          do {
            if (!((bool)(_1578 == _1579) && (bool)(_1579 == _1580))) {
              float _1587 = ((_1578 * 2.0f) - _1579) - _1580;
              float _1590 = ((_1524 - _1527) * 1.7320507764816284f) * _1577;
              float _1592 = atan(_1590 / _1587);
              bool _1595 = (_1587 < 0.0f);
              bool _1596 = (_1587 == 0.0f);
              bool _1597 = (_1590 >= 0.0f);
              bool _1598 = (_1590 < 0.0f);
              float _1607 = select((_1597 && _1596), 90.0f, select((_1598 && _1596), -90.0f, (select((_1598 && _1595), (_1592 + -3.1415927410125732f), select((_1597 && _1595), (_1592 + 3.1415927410125732f), _1592)) * 57.2957763671875f)));
              if (_1607 < 0.0f) {
                _1612 = (_1607 + 360.0f);
              } else {
                _1612 = _1607;
              }
            } else {
              _1612 = 0.0f;
            }
            float _1614 = min(max(_1612, 0.0f), 360.0f);
            do {
              if (_1614 < -180.0f) {
                _1623 = (_1614 + 360.0f);
              } else {
                if (_1614 > 180.0f) {
                  _1623 = (_1614 + -360.0f);
                } else {
                  _1623 = _1614;
                }
              }
              do {
                if ((bool)(_1623 > -67.5f) && (bool)(_1623 < 67.5f)) {
                  float _1629 = (_1623 + 67.5f) * 0.029629629105329514f;
                  int _1630 = int(_1629);
                  float _1632 = _1629 - float((int)(_1630));
                  float _1633 = _1632 * _1632;
                  float _1634 = _1633 * _1632;
                  if (_1630 == 3) {
                    _1662 = (((0.1666666716337204f - (_1632 * 0.5f)) + (_1633 * 0.5f)) - (_1634 * 0.1666666716337204f));
                  } else {
                    if (_1630 == 2) {
                      _1662 = ((0.6666666865348816f - _1633) + (_1634 * 0.5f));
                    } else {
                      if (_1630 == 1) {
                        _1662 = (((_1634 * -0.5f) + 0.1666666716337204f) + ((_1633 + _1632) * 0.5f));
                      } else {
                        _1662 = select((_1630 == 0), (_1634 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1662 = 0.0f;
                }
                float _1671 = min(max(((((_1536 * 0.27000001072883606f) * (0.029999999329447746f - _1578)) * _1662) + _1578), 0.0f), 65535.0f);
                float _1672 = min(max(_1579, 0.0f), 65535.0f);
                float _1673 = min(max(_1580, 0.0f), 65535.0f);
                float _1686 = min(max(mad(-0.21492856740951538f, _1673, mad(-0.2365107536315918f, _1672, (_1671 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1687 = min(max(mad(-0.09967592358589172f, _1673, mad(1.17622971534729f, _1672, (_1671 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1688 = min(max(mad(0.9977163076400757f, _1673, mad(-0.006032449658960104f, _1672, (_1671 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1689 = dot(float3(_1686, _1687, _1688), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1700 = log2(max((lerp(_1689, _1686, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1701 = _1700 * 0.3010300099849701f;
                float _1702 = log2(cb0_008x);
                float _1703 = _1702 * 0.3010300099849701f;
                do {
                  if (!(!(_1701 <= _1703))) {
                    _1772 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1710 = log2(cb0_009x);
                    float _1711 = _1710 * 0.3010300099849701f;
                    if ((bool)(_1701 > _1703) && (bool)(_1701 < _1711)) {
                      float _1719 = ((_1700 - _1702) * 0.9030900001525879f) / ((_1710 - _1702) * 0.3010300099849701f);
                      int _1720 = int(_1719);
                      float _1722 = _1719 - float((int)(_1720));
                      float _1724 = _12[_1720];
                      float _1727 = _12[(_1720 + 1)];
                      float _1732 = _1724 * 0.5f;
                      _1772 = dot(float3((_1722 * _1722), _1722, 1.0f), float3(mad((_12[(_1720 + 2)]), 0.5f, mad(_1727, -1.0f, _1732)), (_1727 - _1724), mad(_1727, 0.5f, _1732)));
                    } else {
                      do {
                        if (!(!(_1701 >= _1711))) {
                          float _1741 = log2(cb0_008z);
                          if (_1701 < (_1741 * 0.3010300099849701f)) {
                            float _1749 = ((_1700 - _1710) * 0.9030900001525879f) / ((_1741 - _1710) * 0.3010300099849701f);
                            int _1750 = int(_1749);
                            float _1752 = _1749 - float((int)(_1750));
                            float _1754 = _13[_1750];
                            float _1757 = _13[(_1750 + 1)];
                            float _1762 = _1754 * 0.5f;
                            _1772 = dot(float3((_1752 * _1752), _1752, 1.0f), float3(mad((_13[(_1750 + 2)]), 0.5f, mad(_1757, -1.0f, _1762)), (_1757 - _1754), mad(_1757, 0.5f, _1762)));
                            break;
                          }
                        }
                        _1772 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1776 = log2(max((lerp(_1689, _1687, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1777 = _1776 * 0.3010300099849701f;
                  do {
                    if (!(!(_1777 <= _1703))) {
                      _1846 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1784 = log2(cb0_009x);
                      float _1785 = _1784 * 0.3010300099849701f;
                      if ((bool)(_1777 > _1703) && (bool)(_1777 < _1785)) {
                        float _1793 = ((_1776 - _1702) * 0.9030900001525879f) / ((_1784 - _1702) * 0.3010300099849701f);
                        int _1794 = int(_1793);
                        float _1796 = _1793 - float((int)(_1794));
                        float _1798 = _12[_1794];
                        float _1801 = _12[(_1794 + 1)];
                        float _1806 = _1798 * 0.5f;
                        _1846 = dot(float3((_1796 * _1796), _1796, 1.0f), float3(mad((_12[(_1794 + 2)]), 0.5f, mad(_1801, -1.0f, _1806)), (_1801 - _1798), mad(_1801, 0.5f, _1806)));
                      } else {
                        do {
                          if (!(!(_1777 >= _1785))) {
                            float _1815 = log2(cb0_008z);
                            if (_1777 < (_1815 * 0.3010300099849701f)) {
                              float _1823 = ((_1776 - _1784) * 0.9030900001525879f) / ((_1815 - _1784) * 0.3010300099849701f);
                              int _1824 = int(_1823);
                              float _1826 = _1823 - float((int)(_1824));
                              float _1828 = _13[_1824];
                              float _1831 = _13[(_1824 + 1)];
                              float _1836 = _1828 * 0.5f;
                              _1846 = dot(float3((_1826 * _1826), _1826, 1.0f), float3(mad((_13[(_1824 + 2)]), 0.5f, mad(_1831, -1.0f, _1836)), (_1831 - _1828), mad(_1831, 0.5f, _1836)));
                              break;
                            }
                          }
                          _1846 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1850 = log2(max((lerp(_1689, _1688, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1851 = _1850 * 0.3010300099849701f;
                    do {
                      if (!(!(_1851 <= _1703))) {
                        _1920 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1858 = log2(cb0_009x);
                        float _1859 = _1858 * 0.3010300099849701f;
                        if ((bool)(_1851 > _1703) && (bool)(_1851 < _1859)) {
                          float _1867 = ((_1850 - _1702) * 0.9030900001525879f) / ((_1858 - _1702) * 0.3010300099849701f);
                          int _1868 = int(_1867);
                          float _1870 = _1867 - float((int)(_1868));
                          float _1872 = _12[_1868];
                          float _1875 = _12[(_1868 + 1)];
                          float _1880 = _1872 * 0.5f;
                          _1920 = dot(float3((_1870 * _1870), _1870, 1.0f), float3(mad((_12[(_1868 + 2)]), 0.5f, mad(_1875, -1.0f, _1880)), (_1875 - _1872), mad(_1875, 0.5f, _1880)));
                        } else {
                          do {
                            if (!(!(_1851 >= _1859))) {
                              float _1889 = log2(cb0_008z);
                              if (_1851 < (_1889 * 0.3010300099849701f)) {
                                float _1897 = ((_1850 - _1858) * 0.9030900001525879f) / ((_1889 - _1858) * 0.3010300099849701f);
                                int _1898 = int(_1897);
                                float _1900 = _1897 - float((int)(_1898));
                                float _1902 = _13[_1898];
                                float _1905 = _13[(_1898 + 1)];
                                float _1910 = _1902 * 0.5f;
                                _1920 = dot(float3((_1900 * _1900), _1900, 1.0f), float3(mad((_13[(_1898 + 2)]), 0.5f, mad(_1905, -1.0f, _1910)), (_1905 - _1902), mad(_1905, 0.5f, _1910)));
                                break;
                              }
                            }
                            _1920 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1924 = cb0_008w - cb0_008y;
                      float _1925 = (exp2(_1772 * 3.321928024291992f) - cb0_008y) / _1924;
                      float _1927 = (exp2(_1846 * 3.321928024291992f) - cb0_008y) / _1924;
                      float _1929 = (exp2(_1920 * 3.321928024291992f) - cb0_008y) / _1924;
                      float _1932 = mad(0.15618768334388733f, _1929, mad(0.13400420546531677f, _1927, (_1925 * 0.6624541878700256f)));
                      float _1935 = mad(0.053689517080783844f, _1929, mad(0.6740817427635193f, _1927, (_1925 * 0.2722287178039551f)));
                      float _1938 = mad(1.0103391408920288f, _1929, mad(0.00406073359772563f, _1927, (_1925 * -0.005574649665504694f)));
                      float _1951 = min(max(mad(-0.23642469942569733f, _1938, mad(-0.32480329275131226f, _1935, (_1932 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1952 = min(max(mad(0.016756348311901093f, _1938, mad(1.6153316497802734f, _1935, (_1932 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1953 = min(max(mad(0.9883948564529419f, _1938, mad(-0.008284442126750946f, _1935, (_1932 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1956 = mad(0.15618768334388733f, _1953, mad(0.13400420546531677f, _1952, (_1951 * 0.6624541878700256f)));
                      float _1959 = mad(0.053689517080783844f, _1953, mad(0.6740817427635193f, _1952, (_1951 * 0.2722287178039551f)));
                      float _1962 = mad(1.0103391408920288f, _1953, mad(0.00406073359772563f, _1952, (_1951 * -0.005574649665504694f)));
                      float _1984 = min(max((min(max(mad(-0.23642469942569733f, _1962, mad(-0.32480329275131226f, _1959, (_1956 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1985 = min(max((min(max(mad(0.016756348311901093f, _1962, mad(1.6153316497802734f, _1959, (_1956 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1986 = min(max((min(max(mad(0.9883948564529419f, _1962, mad(-0.008284442126750946f, _1959, (_1956 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1999 = mad(_41, _1986, mad(_40, _1985, (_1984 * _39)));
                          _2000 = mad(_44, _1986, mad(_43, _1985, (_1984 * _42)));
                          _2001 = mad(_47, _1986, mad(_46, _1985, (_1984 * _45)));
                        } else {
                          _1999 = _1984;
                          _2000 = _1985;
                          _2001 = _1986;
                        }
                        float _2011 = exp2(log2(_1999 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2012 = exp2(log2(_2000 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2013 = exp2(log2(_2001 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2754 = exp2(log2((1.0f / ((_2011 * 18.6875f) + 1.0f)) * ((_2011 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2755 = exp2(log2((1.0f / ((_2012 * 18.6875f) + 1.0f)) * ((_2012 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2756 = exp2(log2((1.0f / ((_2013 * 18.6875f) + 1.0f)) * ((_2013 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2092 = cb0_012z * _1314;
          float _2093 = cb0_012z * _1315;
          float _2094 = cb0_012z * _1316;
          float _2097 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _2094, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _2093, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _2092)));
          float _2100 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _2094, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _2093, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _2092)));
          float _2103 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _2094, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _2093, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _2092)));
          float _2107 = max(max(_2097, _2100), _2103);
          float _2112 = (max(_2107, 1.000000013351432e-10f) - max(min(min(_2097, _2100), _2103), 1.000000013351432e-10f)) / max(_2107, 0.009999999776482582f);
          float _2125 = ((_2100 + _2097) + _2103) + (sqrt((((_2103 - _2100) * _2103) + ((_2100 - _2097) * _2100)) + ((_2097 - _2103) * _2097)) * 1.75f);
          float _2126 = _2125 * 0.3333333432674408f;
          float _2127 = _2112 + -0.4000000059604645f;
          float _2128 = _2127 * 5.0f;
          float _2132 = max((1.0f - abs(_2127 * 2.5f)), 0.0f);
          float _2143 = ((float((int)(((int)(uint)((bool)(_2128 > 0.0f))) - ((int)(uint)((bool)(_2128 < 0.0f))))) * (1.0f - (_2132 * _2132))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2126 <= 0.0533333346247673f)) {
              if (!(_2126 >= 0.1599999964237213f)) {
                _2152 = (((0.23999999463558197f / _2125) + -0.5f) * _2143);
              } else {
                _2152 = 0.0f;
              }
            } else {
              _2152 = _2143;
            }
            float _2153 = _2152 + 1.0f;
            float _2154 = _2153 * _2097;
            float _2155 = _2153 * _2100;
            float _2156 = _2153 * _2103;
            do {
              if (!((bool)(_2154 == _2155) && (bool)(_2155 == _2156))) {
                float _2163 = ((_2154 * 2.0f) - _2155) - _2156;
                float _2166 = ((_2100 - _2103) * 1.7320507764816284f) * _2153;
                float _2168 = atan(_2166 / _2163);
                bool _2171 = (_2163 < 0.0f);
                bool _2172 = (_2163 == 0.0f);
                bool _2173 = (_2166 >= 0.0f);
                bool _2174 = (_2166 < 0.0f);
                float _2183 = select((_2173 && _2172), 90.0f, select((_2174 && _2172), -90.0f, (select((_2174 && _2171), (_2168 + -3.1415927410125732f), select((_2173 && _2171), (_2168 + 3.1415927410125732f), _2168)) * 57.2957763671875f)));
                if (_2183 < 0.0f) {
                  _2188 = (_2183 + 360.0f);
                } else {
                  _2188 = _2183;
                }
              } else {
                _2188 = 0.0f;
              }
              float _2190 = min(max(_2188, 0.0f), 360.0f);
              do {
                if (_2190 < -180.0f) {
                  _2199 = (_2190 + 360.0f);
                } else {
                  if (_2190 > 180.0f) {
                    _2199 = (_2190 + -360.0f);
                  } else {
                    _2199 = _2190;
                  }
                }
                do {
                  if ((bool)(_2199 > -67.5f) && (bool)(_2199 < 67.5f)) {
                    float _2205 = (_2199 + 67.5f) * 0.029629629105329514f;
                    int _2206 = int(_2205);
                    float _2208 = _2205 - float((int)(_2206));
                    float _2209 = _2208 * _2208;
                    float _2210 = _2209 * _2208;
                    if (_2206 == 3) {
                      _2238 = (((0.1666666716337204f - (_2208 * 0.5f)) + (_2209 * 0.5f)) - (_2210 * 0.1666666716337204f));
                    } else {
                      if (_2206 == 2) {
                        _2238 = ((0.6666666865348816f - _2209) + (_2210 * 0.5f));
                      } else {
                        if (_2206 == 1) {
                          _2238 = (((_2210 * -0.5f) + 0.1666666716337204f) + ((_2209 + _2208) * 0.5f));
                        } else {
                          _2238 = select((_2206 == 0), (_2210 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2238 = 0.0f;
                  }
                  float _2247 = min(max(((((_2112 * 0.27000001072883606f) * (0.029999999329447746f - _2154)) * _2238) + _2154), 0.0f), 65535.0f);
                  float _2248 = min(max(_2155, 0.0f), 65535.0f);
                  float _2249 = min(max(_2156, 0.0f), 65535.0f);
                  float _2262 = min(max(mad(-0.21492856740951538f, _2249, mad(-0.2365107536315918f, _2248, (_2247 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2263 = min(max(mad(-0.09967592358589172f, _2249, mad(1.17622971534729f, _2248, (_2247 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2264 = min(max(mad(0.9977163076400757f, _2249, mad(-0.006032449658960104f, _2248, (_2247 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2265 = dot(float3(_2262, _2263, _2264), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2276 = log2(max((lerp(_2265, _2262, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2277 = _2276 * 0.3010300099849701f;
                  float _2278 = log2(cb0_008x);
                  float _2279 = _2278 * 0.3010300099849701f;
                  do {
                    if (!(!(_2277 <= _2279))) {
                      _2348 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2286 = log2(cb0_009x);
                      float _2287 = _2286 * 0.3010300099849701f;
                      if ((bool)(_2277 > _2279) && (bool)(_2277 < _2287)) {
                        float _2295 = ((_2276 - _2278) * 0.9030900001525879f) / ((_2286 - _2278) * 0.3010300099849701f);
                        int _2296 = int(_2295);
                        float _2298 = _2295 - float((int)(_2296));
                        float _2300 = _10[_2296];
                        float _2303 = _10[(_2296 + 1)];
                        float _2308 = _2300 * 0.5f;
                        _2348 = dot(float3((_2298 * _2298), _2298, 1.0f), float3(mad((_10[(_2296 + 2)]), 0.5f, mad(_2303, -1.0f, _2308)), (_2303 - _2300), mad(_2303, 0.5f, _2308)));
                      } else {
                        do {
                          if (!(!(_2277 >= _2287))) {
                            float _2317 = log2(cb0_008z);
                            if (_2277 < (_2317 * 0.3010300099849701f)) {
                              float _2325 = ((_2276 - _2286) * 0.9030900001525879f) / ((_2317 - _2286) * 0.3010300099849701f);
                              int _2326 = int(_2325);
                              float _2328 = _2325 - float((int)(_2326));
                              float _2330 = _11[_2326];
                              float _2333 = _11[(_2326 + 1)];
                              float _2338 = _2330 * 0.5f;
                              _2348 = dot(float3((_2328 * _2328), _2328, 1.0f), float3(mad((_11[(_2326 + 2)]), 0.5f, mad(_2333, -1.0f, _2338)), (_2333 - _2330), mad(_2333, 0.5f, _2338)));
                              break;
                            }
                          }
                          _2348 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2352 = log2(max((lerp(_2265, _2263, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2353 = _2352 * 0.3010300099849701f;
                    do {
                      if (!(!(_2353 <= _2279))) {
                        _2422 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2360 = log2(cb0_009x);
                        float _2361 = _2360 * 0.3010300099849701f;
                        if ((bool)(_2353 > _2279) && (bool)(_2353 < _2361)) {
                          float _2369 = ((_2352 - _2278) * 0.9030900001525879f) / ((_2360 - _2278) * 0.3010300099849701f);
                          int _2370 = int(_2369);
                          float _2372 = _2369 - float((int)(_2370));
                          float _2374 = _10[_2370];
                          float _2377 = _10[(_2370 + 1)];
                          float _2382 = _2374 * 0.5f;
                          _2422 = dot(float3((_2372 * _2372), _2372, 1.0f), float3(mad((_10[(_2370 + 2)]), 0.5f, mad(_2377, -1.0f, _2382)), (_2377 - _2374), mad(_2377, 0.5f, _2382)));
                        } else {
                          do {
                            if (!(!(_2353 >= _2361))) {
                              float _2391 = log2(cb0_008z);
                              if (_2353 < (_2391 * 0.3010300099849701f)) {
                                float _2399 = ((_2352 - _2360) * 0.9030900001525879f) / ((_2391 - _2360) * 0.3010300099849701f);
                                int _2400 = int(_2399);
                                float _2402 = _2399 - float((int)(_2400));
                                float _2404 = _11[_2400];
                                float _2407 = _11[(_2400 + 1)];
                                float _2412 = _2404 * 0.5f;
                                _2422 = dot(float3((_2402 * _2402), _2402, 1.0f), float3(mad((_11[(_2400 + 2)]), 0.5f, mad(_2407, -1.0f, _2412)), (_2407 - _2404), mad(_2407, 0.5f, _2412)));
                                break;
                              }
                            }
                            _2422 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2426 = log2(max((lerp(_2265, _2264, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2427 = _2426 * 0.3010300099849701f;
                      do {
                        if (!(!(_2427 <= _2279))) {
                          _2496 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2434 = log2(cb0_009x);
                          float _2435 = _2434 * 0.3010300099849701f;
                          if ((bool)(_2427 > _2279) && (bool)(_2427 < _2435)) {
                            float _2443 = ((_2426 - _2278) * 0.9030900001525879f) / ((_2434 - _2278) * 0.3010300099849701f);
                            int _2444 = int(_2443);
                            float _2446 = _2443 - float((int)(_2444));
                            float _2448 = _10[_2444];
                            float _2451 = _10[(_2444 + 1)];
                            float _2456 = _2448 * 0.5f;
                            _2496 = dot(float3((_2446 * _2446), _2446, 1.0f), float3(mad((_10[(_2444 + 2)]), 0.5f, mad(_2451, -1.0f, _2456)), (_2451 - _2448), mad(_2451, 0.5f, _2456)));
                          } else {
                            do {
                              if (!(!(_2427 >= _2435))) {
                                float _2465 = log2(cb0_008z);
                                if (_2427 < (_2465 * 0.3010300099849701f)) {
                                  float _2473 = ((_2426 - _2434) * 0.9030900001525879f) / ((_2465 - _2434) * 0.3010300099849701f);
                                  int _2474 = int(_2473);
                                  float _2476 = _2473 - float((int)(_2474));
                                  float _2478 = _11[_2474];
                                  float _2481 = _11[(_2474 + 1)];
                                  float _2486 = _2478 * 0.5f;
                                  _2496 = dot(float3((_2476 * _2476), _2476, 1.0f), float3(mad((_11[(_2474 + 2)]), 0.5f, mad(_2481, -1.0f, _2486)), (_2481 - _2478), mad(_2481, 0.5f, _2486)));
                                  break;
                                }
                              }
                              _2496 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2500 = cb0_008w - cb0_008y;
                        float _2501 = (exp2(_2348 * 3.321928024291992f) - cb0_008y) / _2500;
                        float _2503 = (exp2(_2422 * 3.321928024291992f) - cb0_008y) / _2500;
                        float _2505 = (exp2(_2496 * 3.321928024291992f) - cb0_008y) / _2500;
                        float _2508 = mad(0.15618768334388733f, _2505, mad(0.13400420546531677f, _2503, (_2501 * 0.6624541878700256f)));
                        float _2511 = mad(0.053689517080783844f, _2505, mad(0.6740817427635193f, _2503, (_2501 * 0.2722287178039551f)));
                        float _2514 = mad(1.0103391408920288f, _2505, mad(0.00406073359772563f, _2503, (_2501 * -0.005574649665504694f)));
                        float _2527 = min(max(mad(-0.23642469942569733f, _2514, mad(-0.32480329275131226f, _2511, (_2508 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2528 = min(max(mad(0.016756348311901093f, _2514, mad(1.6153316497802734f, _2511, (_2508 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2529 = min(max(mad(0.9883948564529419f, _2514, mad(-0.008284442126750946f, _2511, (_2508 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2532 = mad(0.15618768334388733f, _2529, mad(0.13400420546531677f, _2528, (_2527 * 0.6624541878700256f)));
                        float _2535 = mad(0.053689517080783844f, _2529, mad(0.6740817427635193f, _2528, (_2527 * 0.2722287178039551f)));
                        float _2538 = mad(1.0103391408920288f, _2529, mad(0.00406073359772563f, _2528, (_2527 * -0.005574649665504694f)));
                        float _2560 = min(max((min(max(mad(-0.23642469942569733f, _2538, mad(-0.32480329275131226f, _2535, (_2532 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2561 = min(max((min(max(mad(0.016756348311901093f, _2538, mad(1.6153316497802734f, _2535, (_2532 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2562 = min(max((min(max(mad(0.9883948564529419f, _2538, mad(-0.008284442126750946f, _2535, (_2532 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2575 = mad(_41, _2562, mad(_40, _2561, (_2560 * _39)));
                            _2576 = mad(_44, _2562, mad(_43, _2561, (_2560 * _42)));
                            _2577 = mad(_47, _2562, mad(_46, _2561, (_2560 * _45)));
                          } else {
                            _2575 = _2560;
                            _2576 = _2561;
                            _2577 = _2562;
                          }
                          float _2587 = exp2(log2(_2575 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2588 = exp2(log2(_2576 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2589 = exp2(log2(_2577 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2754 = exp2(log2((1.0f / ((_2587 * 18.6875f) + 1.0f)) * ((_2587 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2755 = exp2(log2((1.0f / ((_2588 * 18.6875f) + 1.0f)) * ((_2588 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2756 = exp2(log2((1.0f / ((_2589 * 18.6875f) + 1.0f)) * ((_2589 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2634 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1316, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1315, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1314)));
            float _2637 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1316, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1315, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1314)));
            float _2640 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1316, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1315, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1314)));
            float _2659 = exp2(log2(mad(_41, _2640, mad(_40, _2637, (_2634 * _39))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2660 = exp2(log2(mad(_44, _2640, mad(_43, _2637, (_2634 * _42))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2661 = exp2(log2(mad(_47, _2640, mad(_46, _2637, (_2634 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2754 = exp2(log2((1.0f / ((_2659 * 18.6875f) + 1.0f)) * ((_2659 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2755 = exp2(log2((1.0f / ((_2660 * 18.6875f) + 1.0f)) * ((_2660 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2756 = exp2(log2((1.0f / ((_2661 * 18.6875f) + 1.0f)) * ((_2661 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2708 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1304, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1303, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1302)));
                float _2711 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1304, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1303, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1302)));
                float _2714 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1304, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1303, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1302)));
                _2754 = mad(_41, _2714, mad(_40, _2711, (_2708 * _39)));
                _2755 = mad(_44, _2714, mad(_43, _2711, (_2708 * _42)));
                _2756 = mad(_47, _2714, mad(_46, _2711, (_2708 * _45)));
              } else {
                float _2727 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1328)));
                float _2730 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1328)));
                float _2733 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1330, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1329, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1328)));
                _2754 = exp2(log2(mad(_41, _2733, mad(_40, _2730, (_2727 * _39)))) * cb0_040z);
                _2755 = exp2(log2(mad(_44, _2733, mad(_43, _2730, (_2727 * _42)))) * cb0_040z);
                _2756 = exp2(log2(mad(_47, _2733, mad(_46, _2730, (_2727 * _45)))) * cb0_040z);
              }
            } else {
              _2754 = _1314;
              _2755 = _1315;
              _2756 = _1316;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2754 * 0.9523810148239136f);
  SV_Target.y = (_2755 * 0.9523810148239136f);
  SV_Target.z = (_2756 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
