// Wuchang: Fallen Feathers

#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  uint output_gamut = cb0_041x;
  uint output_device = cb0_040w;
  float expand_gamut = cb0_036w;
  bool is_hdr = (output_device >= 3u && output_device <= 6u);

  float4 SV_Target;
  float _12[6];
  float _13[6];
  float _14[6];
  float _15[6];
  float _16 = TEXCOORD.x + -0.015625f;
  float _17 = TEXCOORD.y + -0.015625f;
  float _20 = float((uint)(int)(SV_RenderTargetArrayIndex));
  float _41;
  float _42;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _107;
  float _108;
  float _109;
  float _158;
  float _887;
  float _923;
  float _934;
  float _998;
  float _1177;
  float _1188;
  float _1199;
  float _1401;
  float _1402;
  float _1403;
  float _1414;
  float _1425;
  float _1607;
  float _1643;
  float _1654;
  float _1693;
  float _1803;
  float _1877;
  float _1951;
  float _2030;
  float _2031;
  float _2032;
  float _2183;
  float _2219;
  float _2230;
  float _2269;
  float _2379;
  float _2453;
  float _2527;
  float _2606;
  float _2607;
  float _2608;
  float _2785;
  float _2786;
  float _2787;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _30 = (output_gamut == 4);
        _41 = select(_30, 1.0f, 1.7050515413284302f);
        _42 = select(_30, 0.0f, -0.6217905879020691f);
        _43 = select(_30, 0.0f, -0.0832584798336029f);
        _44 = select(_30, 0.0f, -0.13025718927383423f);
        _45 = select(_30, 1.0f, 1.1408027410507202f);
        _46 = select(_30, 0.0f, -0.010548528283834457f);
        _47 = select(_30, 0.0f, -0.024003278464078903f);
        _48 = select(_30, 0.0f, -0.1289687603712082f);
        _49 = select(_30, 1.0f, 1.152971863746643f);
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
      _41 = 1.02579927444458f;
      _42 = -0.020052503794431686f;
      _43 = -0.0057713985443115234f;
      _44 = -0.0022350111976265907f;
      _45 = 1.0045825242996216f;
      _46 = -0.002352306619286537f;
      _47 = -0.005014004185795784f;
      _48 = -0.025293385609984398f;
      _49 = 1.0304402112960815f;
    }
  } else {
    _41 = 1.379158854484558f;
    _42 = -0.3088507056236267f;
    _43 = -0.07034677267074585f;
    _44 = -0.06933528929948807f;
    _45 = 1.0822921991348267f;
    _46 = -0.012962047010660172f;
    _47 = -0.002159259282052517f;
    _48 = -0.045465391129255295f;
    _49 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _60 = exp2(log2(_16 * 1.0322580337524414f) * 0.012683313339948654f);
    float _61 = exp2(log2(_17 * 1.0322580337524414f) * 0.012683313339948654f);
    float _62 = exp2(log2(_20 * 0.032258063554763794f) * 0.012683313339948654f);
    _107 = (exp2(log2(max(0.0f, (_60 + -0.8359375f)) / (18.8515625f - (_60 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _108 = (exp2(log2(max(0.0f, (_61 + -0.8359375f)) / (18.8515625f - (_61 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _109 = (exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _107 = ((exp2((_16 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _108 = ((exp2((_17 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _109 = ((exp2((_20 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  bool _136 = (cb0_038z != 0);
  float _141 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _158 = (((((2967800.0f - (_141 * 4607000064.0f)) * _141) + 99.11000061035156f) * _141) + 0.24406300485134125f);
  } else {
    _158 = (((((1901800.0f - (_141 * 2006400000.0f)) * _141) + 247.47999572753906f) * _141) + 0.23703999817371368f);
  }
  float _172 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _179 = cb0_035x * cb0_035x;
  float _182 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_179 * 1.6145605741257896e-07f));
  float _187 = ((_172 * 2.0f) + 4.0f) - (_182 * 8.0f);
  float _188 = (_172 * 3.0f) / _187;
  float _190 = (_182 * 2.0f) / _187;
  bool _191 = (cb0_035x < 4000.0f);
  float _200 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _202 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_179 * 1.5317699909210205f)) / (_200 * _200);
  float _209 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _179;
  float _211 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_179 * 308.60699462890625f)) / (_209 * _209);
  float _213 = rsqrt(dot(float2(_202, _211), float2(_202, _211)));
  float _214 = cb0_035y * 0.05000000074505806f;
  float _217 = ((_214 * _211) * _213) + _172;
  float _220 = _182 - ((_214 * _202) * _213);
  float _225 = (4.0f - (_220 * 8.0f)) + (_217 * 2.0f);
  float _231 = (((_217 * 3.0f) / _225) - _188) + select(_191, _188, _158);
  float _232 = (((_220 * 2.0f) / _225) - _190) + select(_191, _190, (((_158 * 2.869999885559082f) + -0.2750000059604645f) - ((_158 * _158) * 3.0f)));
  float _233 = select(_136, _231, 0.3127000033855438f);
  float _234 = select(_136, _232, 0.32899999618530273f);
  float _235 = select(_136, 0.3127000033855438f, _231);
  float _236 = select(_136, 0.32899999618530273f, _232);
  float _237 = max(_234, 1.000000013351432e-10f);
  float _238 = _233 / _237;
  float _241 = ((1.0f - _233) - _234) / _237;
  float _242 = max(_236, 1.000000013351432e-10f);
  float _243 = _235 / _242;
  float _246 = ((1.0f - _235) - _236) / _242;
  float _265 = mad(-0.16140000522136688f, _246, ((_243 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _241, ((_238 * 0.8950999975204468f) + 0.266400009393692f));
  float _266 = mad(0.03669999912381172f, _246, (1.7135000228881836f - (_243 * 0.7501999735832214f))) / mad(0.03669999912381172f, _241, (1.7135000228881836f - (_238 * 0.7501999735832214f)));
  float _267 = mad(1.0296000242233276f, _246, ((_243 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _241, ((_238 * 0.03889999911189079f) + -0.06849999725818634f));
  float _268 = mad(_266, -0.7501999735832214f, 0.0f);
  float _269 = mad(_266, 1.7135000228881836f, 0.0f);
  float _270 = mad(_266, 0.03669999912381172f, -0.0f);
  float _271 = mad(_267, 0.03889999911189079f, 0.0f);
  float _272 = mad(_267, -0.06849999725818634f, 0.0f);
  float _273 = mad(_267, 1.0296000242233276f, 0.0f);
  float _276 = mad(0.1599626988172531f, _271, mad(-0.1470542997121811f, _268, (_265 * 0.883457362651825f)));
  float _279 = mad(0.1599626988172531f, _272, mad(-0.1470542997121811f, _269, (_265 * 0.26293492317199707f)));
  float _282 = mad(0.1599626988172531f, _273, mad(-0.1470542997121811f, _270, (_265 * -0.15930065512657166f)));
  float _285 = mad(0.04929120093584061f, _271, mad(0.5183603167533875f, _268, (_265 * 0.38695648312568665f)));
  float _288 = mad(0.04929120093584061f, _272, mad(0.5183603167533875f, _269, (_265 * 0.11516613513231277f)));
  float _291 = mad(0.04929120093584061f, _273, mad(0.5183603167533875f, _270, (_265 * -0.0697740763425827f)));
  float _294 = mad(0.9684867262840271f, _271, mad(0.04004279896616936f, _268, (_265 * -0.007634039502590895f)));
  float _297 = mad(0.9684867262840271f, _272, mad(0.04004279896616936f, _269, (_265 * -0.0022720457054674625f)));
  float _300 = mad(0.9684867262840271f, _273, mad(0.04004279896616936f, _270, (_265 * 0.0013765322510153055f)));
  float _303 = mad(_282, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_279, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_276 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _306 = mad(_282, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_279, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_276 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _309 = mad(_282, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_279, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_276 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _312 = mad(_291, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_288, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_285 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _315 = mad(_291, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_288, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_285 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _318 = mad(_291, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_288, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_285 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _321 = mad(_300, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_297, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_294 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _324 = mad(_300, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_297, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_294 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _327 = mad(_300, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_297, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_294 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _357 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _327, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _318, (_309 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _109, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _324, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _315, (_306 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _108, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _321, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _312, (_303 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _107)));
  float _360 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _327, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _318, (_309 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _109, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _324, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _315, (_306 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _108, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _321, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _312, (_303 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _107)));
  float _363 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _327, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _318, (_309 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _109, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _324, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _315, (_306 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _108, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _321, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _312, (_303 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _107)));
  float _378 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _363, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _360, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _357)));
  float _381 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _363, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _360, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _357)));
  float _384 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _363, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _360, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _357)));
  float _385 = dot(float3(_378, _381, _384), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _389 = (_378 / _385) + -1.0f;
  float _390 = (_381 / _385) + -1.0f;
  float _391 = (_384 / _385) + -1.0f;
  float _403 = (1.0f - exp2(((_385 * _385) * -4.0f) * cb0_036z)) * (1.0f - exp2(dot(float3(_389, _390, _391), float3(_389, _390, _391)) * -4.0f));
  float _419 = ((mad(-0.06368283927440643f, _384, mad(-0.32929131388664246f, _381, (_378 * 1.370412826538086f))) - _378) * _403) + _378;
  float _420 = ((mad(-0.010861567221581936f, _384, mad(1.0970908403396606f, _381, (_378 * -0.08343426138162613f))) - _381) * _403) + _381;
  float _421 = ((mad(1.203694462776184f, _384, mad(-0.09862564504146576f, _381, (_378 * -0.02579325996339321f))) - _384) * _403) + _384;
  float _422 = dot(float3(_419, _420, _421), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    output_gamut = 0u;
    output_device = 0u;
    expand_gamut = 0.f;
  }
  float _436 = cb0_019w + cb0_024w;
  float _450 = cb0_018w * cb0_023w;
  float _464 = cb0_017w * cb0_022w;
  float _478 = cb0_016w * cb0_021w;
  float _492 = cb0_015w * cb0_020w;
  float _496 = _419 - _422;
  float _497 = _420 - _422;
  float _498 = _421 - _422;
  float _555 = saturate(_422 / cb0_035z);
  float _559 = (_555 * _555) * (3.0f - (_555 * 2.0f));
  float _560 = 1.0f - _559;
  float _569 = cb0_019w + cb0_034w;
  float _578 = cb0_018w * cb0_033w;
  float _587 = cb0_017w * cb0_032w;
  float _596 = cb0_016w * cb0_031w;
  float _605 = cb0_015w * cb0_030w;
  float _669 = saturate((_422 - cb0_035w) / (cb0_036x - cb0_035w));
  float _673 = (_669 * _669) * (3.0f - (_669 * 2.0f));
  float _682 = cb0_019w + cb0_029w;
  float _691 = cb0_018w * cb0_028w;
  float _700 = cb0_017w * cb0_027w;
  float _709 = cb0_016w * cb0_026w;
  float _718 = cb0_015w * cb0_025w;
  float _776 = _559 - _673;
  float _787 = ((_673 * (((cb0_019x + cb0_034x) + _569) + (((cb0_018x * cb0_033x) * _578) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _596) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _605) * _496) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _587)))))) + (_560 * (((cb0_019x + cb0_024x) + _436) + (((cb0_018x * cb0_023x) * _450) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _478) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _492) * _496) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _464))))))) + ((((cb0_019x + cb0_029x) + _682) + (((cb0_018x * cb0_028x) * _691) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _709) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _718) * _496) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _700))))) * _776);
  float _789 = ((_673 * (((cb0_019y + cb0_034y) + _569) + (((cb0_018y * cb0_033y) * _578) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _596) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _605) * _497) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _587)))))) + (_560 * (((cb0_019y + cb0_024y) + _436) + (((cb0_018y * cb0_023y) * _450) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _478) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _492) * _497) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _464))))))) + ((((cb0_019y + cb0_029y) + _682) + (((cb0_018y * cb0_028y) * _691) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _709) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _718) * _497) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _700))))) * _776);
  float _791 = ((_673 * (((cb0_019z + cb0_034z) + _569) + (((cb0_018z * cb0_033z) * _578) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _596) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _605) * _498) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _587)))))) + (_560 * (((cb0_019z + cb0_024z) + _436) + (((cb0_018z * cb0_023z) * _450) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _478) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _492) * _498) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _464))))))) + ((((cb0_019z + cb0_029z) + _682) + (((cb0_018z * cb0_028z) * _691) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _709) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _718) * _498) + _422)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _700))))) * _776);
  float _827 = ((mad(0.061360642313957214f, _791, mad(-4.540197551250458e-09f, _789, (_787 * 0.9386394023895264f))) - _787) * cb0_036y) + _787;
  float _828 = ((mad(0.169205904006958f, _791, mad(0.8307942152023315f, _789, (_787 * 6.775371730327606e-08f))) - _789) * cb0_036y) + _789;
  float _829 = (mad(-2.3283064365386963e-10f, _789, (_787 * -9.313225746154785e-10f)) * cb0_036y) + _791;
  float _832 = mad(0.16386905312538147f, _829, mad(0.14067868888378143f, _828, (_827 * 0.6954522132873535f)));
  float _835 = mad(0.0955343246459961f, _829, mad(0.8596711158752441f, _828, (_827 * 0.044794581830501556f)));
  float _838 = mad(1.0015007257461548f, _829, mad(0.004025210160762072f, _828, (_827 * -0.005525882821530104f)));
  float _842 = max(max(_832, _835), _838);
  float _847 = (max(_842, 1.000000013351432e-10f) - max(min(min(_832, _835), _838), 1.000000013351432e-10f)) / max(_842, 0.009999999776482582f);
  float _860 = ((_835 + _832) + _838) + (sqrt((((_838 - _835) * _838) + ((_835 - _832) * _835)) + ((_832 - _838) * _832)) * 1.75f);
  float _861 = _860 * 0.3333333432674408f;
  float _862 = _847 + -0.4000000059604645f;
  float _863 = _862 * 5.0f;
  float _867 = max((1.0f - abs(_862 * 2.5f)), 0.0f);
  float _878 = ((float((int)(((int)(uint)((bool)(_863 > 0.0f))) - ((int)(uint)((bool)(_863 < 0.0f))))) * (1.0f - (_867 * _867))) + 1.0f) * 0.02500000037252903f;
  if (!(_861 <= 0.0533333346247673f)) {
    if (!(_861 >= 0.1599999964237213f)) {
      _887 = (((0.23999999463558197f / _860) + -0.5f) * _878);
    } else {
      _887 = 0.0f;
    }
  } else {
    _887 = _878;
  }
  float _888 = _887 + 1.0f;
  float _889 = _888 * _832;
  float _890 = _888 * _835;
  float _891 = _888 * _838;
  if (!((bool)(_889 == _890) && (bool)(_890 == _891))) {
    float _898 = ((_889 * 2.0f) - _890) - _891;
    float _901 = ((_835 - _838) * 1.7320507764816284f) * _888;
    float _903 = atan(_901 / _898);
    bool _906 = (_898 < 0.0f);
    bool _907 = (_898 == 0.0f);
    bool _908 = (_901 >= 0.0f);
    bool _909 = (_901 < 0.0f);
    float _918 = select((_908 && _907), 90.0f, select((_909 && _907), -90.0f, (select((_909 && _906), (_903 + -3.1415927410125732f), select((_908 && _906), (_903 + 3.1415927410125732f), _903)) * 57.2957763671875f)));
    if (_918 < 0.0f) {
      _923 = (_918 + 360.0f);
    } else {
      _923 = _918;
    }
  } else {
    _923 = 0.0f;
  }
  float _925 = min(max(_923, 0.0f), 360.0f);
  if (_925 < -180.0f) {
    _934 = (_925 + 360.0f);
  } else {
    if (_925 > 180.0f) {
      _934 = (_925 + -360.0f);
    } else {
      _934 = _925;
    }
  }
  float _938 = saturate(1.0f - abs(_934 * 0.014814814552664757f));
  float _942 = (_938 * _938) * (3.0f - (_938 * 2.0f));
  float _948 = ((_942 * _942) * ((_847 * 0.18000000715255737f) * (0.029999999329447746f - _889))) + _889;
  float _958 = max(0.0f, mad(-0.21492856740951538f, _891, mad(-0.2365107536315918f, _890, (_948 * 1.4514392614364624f))));
  float _959 = max(0.0f, mad(-0.09967592358589172f, _891, mad(1.17622971534729f, _890, (_948 * -0.07655377686023712f))));
  float _960 = max(0.0f, mad(0.9977163076400757f, _891, mad(-0.006032449658960104f, _890, (_948 * 0.008316148072481155f))));
  float _961 = dot(float3(_958, _959, _960), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _975 = (cb0_037w + 1.0f) - cb0_037y;
  float _978 = cb0_038x + 1.0f;
  float _980 = _978 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _998 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _989 = (cb0_037w + 0.18000000715255737f) / _975;
    _998 = (-0.7447274923324585f - ((log2(_989 / (2.0f - _989)) * 0.3465735912322998f) * (_975 / cb0_037x)));
  }
  float _1001 = ((1.0f - cb0_037y) / cb0_037x) - _998;
  float _1003 = (cb0_037z / cb0_037x) - _1001;
  float3 lerpColor = lerp(_961, float3(_958, _959, _960), 0.9599999785423279f);
#if 1
  ApplyFilmicToneMap(lerpColor.r, lerpColor.g, lerpColor.b, _827, _828, _829);
  float _1149 = lerpColor.r, _1150 = lerpColor.g, _1151 = lerpColor.b;
#else
  float _1007 = log2(lerp(_961, _958, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1008 = log2(lerp(_961, _959, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1009 = log2(lerp(_961, _960, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1013 = cb0_037x * (_1007 + _1001);
  float _1014 = cb0_037x * (_1008 + _1001);
  float _1015 = cb0_037x * (_1009 + _1001);
  float _1016 = _975 * 2.0f;
  float _1018 = (cb0_037x * -2.0f) / _975;
  float _1019 = _1007 - _998;
  float _1020 = _1008 - _998;
  float _1021 = _1009 - _998;
  float _1040 = _980 * 2.0f;
  float _1042 = (cb0_037x * 2.0f) / _980;
  float _1067 = select((_1007 < _998), ((_1016 / (exp2((_1019 * 1.4426950216293335f) * _1018) + 1.0f)) - cb0_037w), _1013);
  float _1068 = select((_1008 < _998), ((_1016 / (exp2((_1020 * 1.4426950216293335f) * _1018) + 1.0f)) - cb0_037w), _1014);
  float _1069 = select((_1009 < _998), ((_1016 / (exp2((_1021 * 1.4426950216293335f) * _1018) + 1.0f)) - cb0_037w), _1015);
  float _1076 = _1003 - _998;
  float _1080 = saturate(_1019 / _1076);
  float _1081 = saturate(_1020 / _1076);
  float _1082 = saturate(_1021 / _1076);
  bool _1083 = (_1003 < _998);
  float _1087 = select(_1083, (1.0f - _1080), _1080);
  float _1088 = select(_1083, (1.0f - _1081), _1081);
  float _1089 = select(_1083, (1.0f - _1082), _1082);
  float _1108 = (((_1087 * _1087) * (select((_1007 > _1003), (_978 - (_1040 / (exp2(((_1007 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1013) - _1067)) * (3.0f - (_1087 * 2.0f))) + _1067;
  float _1109 = (((_1088 * _1088) * (select((_1008 > _1003), (_978 - (_1040 / (exp2(((_1008 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1014) - _1068)) * (3.0f - (_1088 * 2.0f))) + _1068;
  float _1110 = (((_1089 * _1089) * (select((_1009 > _1003), (_978 - (_1040 / (exp2(((_1009 - _1003) * 1.4426950216293335f) * _1042) + 1.0f))), _1015) - _1069)) * (3.0f - (_1089 * 2.0f))) + _1069;
  float _1111 = dot(float3(_1108, _1109, _1110), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1131 = (expand_gamut * (max(0.0f, (lerp(_1111, _1108, 0.9300000071525574f))) - _827)) + _827;
  float _1132 = (expand_gamut * (max(0.0f, (lerp(_1111, _1109, 0.9300000071525574f))) - _828)) + _828;
  float _1133 = (expand_gamut * (max(0.0f, (lerp(_1111, _1110, 0.9300000071525574f))) - _829)) + _829;
  float _1149 = ((mad(-0.06537103652954102f, _1133, mad(1.451815478503704e-06f, _1132, (_1131 * 1.065374732017517f))) - _1131) * cb0_036y) + _1131;
  float _1150 = ((mad(-0.20366770029067993f, _1133, mad(1.2036634683609009f, _1132, (_1131 * -2.57161445915699e-07f))) - _1132) * cb0_036y) + _1132;
  float _1151 = ((mad(0.9999996423721313f, _1133, mad(2.0954757928848267e-08f, _1132, (_1131 * 1.862645149230957e-08f))) - _1133) * cb0_036y) + _1133;
#endif

  float _1164 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1151, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1150, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1149))));
  float _1165 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1151, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1150, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1149))));
  float _1166 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1151, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1150, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1149))));
  /* if (_1164 < 0.0031306699384003878f) {
    _1177 = (_1164 * 12.920000076293945f);
  } else {
    _1177 = (((pow(_1164, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1165 < 0.0031306699384003878f) {
    _1188 = (_1165 * 12.920000076293945f);
  } else {
    _1188 = (((pow(_1165, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1166 < 0.0031306699384003878f) {
    _1199 = (_1166 * 12.920000076293945f);
  } else {
    _1199 = (((pow(_1166, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1203 = (_1188 * 0.9375f) + 0.03125f;
  float _1210 = _1199 * 15.0f;
  float _1211 = floor(_1210);
  float _1212 = _1210 - _1211;
  float _1214 = (_1211 + ((_1177 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1217 = t0.Sample(s0, float2(_1214, _1203));
  float _1221 = _1214 + 0.0625f;
  float4 _1224 = t0.Sample(s0, float2(_1221, _1203));
  float4 _1247 = t1.Sample(s1, float2(_1214, _1203));
  float4 _1253 = t1.Sample(s1, float2(_1221, _1203));
  float _1272 = max(6.103519990574569e-05f, ((((lerp(_1217.x, _1224.x, _1212)) * cb0_005y) + (cb0_005x * _1177)) + ((lerp(_1247.x, _1253.x, _1212)) * cb0_005z)));
  float _1273 = max(6.103519990574569e-05f, ((((lerp(_1217.y, _1224.y, _1212)) * cb0_005y) + (cb0_005x * _1188)) + ((lerp(_1247.y, _1253.y, _1212)) * cb0_005z)));
  float _1274 = max(6.103519990574569e-05f, ((((lerp(_1217.z, _1224.z, _1212)) * cb0_005y) + (cb0_005x * _1199)) + ((lerp(_1247.z, _1253.z, _1212)) * cb0_005z)));
  float _1296 = select((_1272 > 0.040449999272823334f), exp2(log2((_1272 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1272 * 0.07739938050508499f));
  float _1297 = select((_1273 > 0.040449999272823334f), exp2(log2((_1273 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1273 * 0.07739938050508499f));
  float _1298 = select((_1274 > 0.040449999272823334f), exp2(log2((_1274 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1274 * 0.07739938050508499f)); */
  float3 untonemapped = float3(_1164, _1165, _1166);
  float _1296;
  float _1297;
  float _1298;
  SampleLUTUpgradeToneMap(untonemapped, s0, s1, t0, t1, _1296, _1297, _1298);
  float _1324 = cb0_014x * (((cb0_039y + (cb0_039x * _1296)) * _1296) + cb0_039z);
  float _1325 = cb0_014y * (((cb0_039y + (cb0_039x * _1297)) * _1297) + cb0_039z);
  float _1326 = cb0_014z * (((cb0_039y + (cb0_039x * _1298)) * _1298) + cb0_039z);
  float _1333 = ((cb0_013x - _1324) * cb0_013w) + _1324;
  float _1334 = ((cb0_013y - _1325) * cb0_013w) + _1325;
  float _1335 = ((cb0_013z - _1326) * cb0_013w) + _1326;
  if (GenerateOutput(_1333, _1334, _1335, SV_Target, is_hdr)) {
    return SV_Target;
  }
  float _1336 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _791, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _789, (_787 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1337 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _791, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _789, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _787)));
  float _1338 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _791, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _789, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _787)));
  float _1345 = ((cb0_013x - _1336) * cb0_013w) + _1336;
  float _1346 = ((cb0_013y - _1337) * cb0_013w) + _1337;
  float _1347 = ((cb0_013z - _1338) * cb0_013w) + _1338;
  float _1359 = exp2(log2(max(0.0f, _1333)) * cb0_040y);
  float _1360 = exp2(log2(max(0.0f, _1334)) * cb0_040y);
  float _1361 = exp2(log2(max(0.0f, _1335)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1384 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1359)));
        float _1387 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1359)));
        float _1390 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1359)));
        _1401 = mad(_43, _1390, mad(_42, _1387, (_1384 * _41)));
        _1402 = mad(_46, _1390, mad(_45, _1387, (_1384 * _44)));
        _1403 = mad(_49, _1390, mad(_48, _1387, (_1384 * _47)));
      } else {
        _1401 = _1359;
        _1402 = _1360;
        _1403 = _1361;
      }
      do {
        if (_1401 < 0.0031306699384003878f) {
          _1414 = (_1401 * 12.920000076293945f);
        } else {
          _1414 = (((pow(_1401, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1402 < 0.0031306699384003878f) {
            _1425 = (_1402 * 12.920000076293945f);
          } else {
            _1425 = (((pow(_1402, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1403 < 0.0031306699384003878f) {
            _2785 = _1414;
            _2786 = _1425;
            _2787 = (_1403 * 12.920000076293945f);
          } else {
            _2785 = _1414;
            _2786 = _1425;
            _2787 = (((pow(_1403, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1452 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1359)));
      float _1455 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1359)));
      float _1458 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1359)));
      float _1468 = max(6.103519990574569e-05f, mad(_43, _1458, mad(_42, _1455, (_1452 * _41))));
      float _1469 = max(6.103519990574569e-05f, mad(_46, _1458, mad(_45, _1455, (_1452 * _44))));
      float _1470 = max(6.103519990574569e-05f, mad(_49, _1458, mad(_48, _1455, (_1452 * _47))));
      _2785 = min((_1468 * 4.5f), ((exp2(log2(max(_1468, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2786 = min((_1469 * 4.5f), ((exp2(log2(max(_1469, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2787 = min((_1470 * 4.5f), ((exp2(log2(max(_1470, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
        _14[0] = cb0_010x;
        _14[1] = cb0_010y;
        _14[2] = cb0_010z;
        _14[3] = cb0_010w;
        _14[4] = cb0_012x;
        _14[5] = cb0_012x;
        _15[0] = cb0_011x;
        _15[1] = cb0_011y;
        _15[2] = cb0_011z;
        _15[3] = cb0_011w;
        _15[4] = cb0_012y;
        _15[5] = cb0_012y;
        float _1547 = cb0_012z * _1345;
        float _1548 = cb0_012z * _1346;
        float _1549 = cb0_012z * _1347;
        float _1552 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1549, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1548, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1547)));
        float _1555 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1549, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1548, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1547)));
        float _1558 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1549, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1548, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1547)));
        float _1562 = max(max(_1552, _1555), _1558);
        float _1567 = (max(_1562, 1.000000013351432e-10f) - max(min(min(_1552, _1555), _1558), 1.000000013351432e-10f)) / max(_1562, 0.009999999776482582f);
        float _1580 = ((_1555 + _1552) + _1558) + (sqrt((((_1558 - _1555) * _1558) + ((_1555 - _1552) * _1555)) + ((_1552 - _1558) * _1552)) * 1.75f);
        float _1581 = _1580 * 0.3333333432674408f;
        float _1582 = _1567 + -0.4000000059604645f;
        float _1583 = _1582 * 5.0f;
        float _1587 = max((1.0f - abs(_1582 * 2.5f)), 0.0f);
        float _1598 = ((float((int)(((int)(uint)((bool)(_1583 > 0.0f))) - ((int)(uint)((bool)(_1583 < 0.0f))))) * (1.0f - (_1587 * _1587))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1581 <= 0.0533333346247673f)) {
            if (!(_1581 >= 0.1599999964237213f)) {
              _1607 = (((0.23999999463558197f / _1580) + -0.5f) * _1598);
            } else {
              _1607 = 0.0f;
            }
          } else {
            _1607 = _1598;
          }
          float _1608 = _1607 + 1.0f;
          float _1609 = _1608 * _1552;
          float _1610 = _1608 * _1555;
          float _1611 = _1608 * _1558;
          do {
            if (!((bool)(_1609 == _1610) && (bool)(_1610 == _1611))) {
              float _1618 = ((_1609 * 2.0f) - _1610) - _1611;
              float _1621 = ((_1555 - _1558) * 1.7320507764816284f) * _1608;
              float _1623 = atan(_1621 / _1618);
              bool _1626 = (_1618 < 0.0f);
              bool _1627 = (_1618 == 0.0f);
              bool _1628 = (_1621 >= 0.0f);
              bool _1629 = (_1621 < 0.0f);
              float _1638 = select((_1628 && _1627), 90.0f, select((_1629 && _1627), -90.0f, (select((_1629 && _1626), (_1623 + -3.1415927410125732f), select((_1628 && _1626), (_1623 + 3.1415927410125732f), _1623)) * 57.2957763671875f)));
              if (_1638 < 0.0f) {
                _1643 = (_1638 + 360.0f);
              } else {
                _1643 = _1638;
              }
            } else {
              _1643 = 0.0f;
            }
            float _1645 = min(max(_1643, 0.0f), 360.0f);
            do {
              if (_1645 < -180.0f) {
                _1654 = (_1645 + 360.0f);
              } else {
                if (_1645 > 180.0f) {
                  _1654 = (_1645 + -360.0f);
                } else {
                  _1654 = _1645;
                }
              }
              do {
                if ((bool)(_1654 > -67.5f) && (bool)(_1654 < 67.5f)) {
                  float _1660 = (_1654 + 67.5f) * 0.029629629105329514f;
                  int _1661 = int(_1660);
                  float _1663 = _1660 - float((int)(_1661));
                  float _1664 = _1663 * _1663;
                  float _1665 = _1664 * _1663;
                  if (_1661 == 3) {
                    _1693 = (((0.1666666716337204f - (_1663 * 0.5f)) + (_1664 * 0.5f)) - (_1665 * 0.1666666716337204f));
                  } else {
                    if (_1661 == 2) {
                      _1693 = ((0.6666666865348816f - _1664) + (_1665 * 0.5f));
                    } else {
                      if (_1661 == 1) {
                        _1693 = (((_1665 * -0.5f) + 0.1666666716337204f) + ((_1664 + _1663) * 0.5f));
                      } else {
                        _1693 = select((_1661 == 0), (_1665 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1693 = 0.0f;
                }
                float _1702 = min(max(((((_1567 * 0.27000001072883606f) * (0.029999999329447746f - _1609)) * _1693) + _1609), 0.0f), 65535.0f);
                float _1703 = min(max(_1610, 0.0f), 65535.0f);
                float _1704 = min(max(_1611, 0.0f), 65535.0f);
                float _1717 = min(max(mad(-0.21492856740951538f, _1704, mad(-0.2365107536315918f, _1703, (_1702 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1718 = min(max(mad(-0.09967592358589172f, _1704, mad(1.17622971534729f, _1703, (_1702 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1719 = min(max(mad(0.9977163076400757f, _1704, mad(-0.006032449658960104f, _1703, (_1702 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1720 = dot(float3(_1717, _1718, _1719), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1731 = log2(max((lerp(_1720, _1717, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1732 = _1731 * 0.3010300099849701f;
                float _1733 = log2(cb0_008x);
                float _1734 = _1733 * 0.3010300099849701f;
                do {
                  if (!(!(_1732 <= _1734))) {
                    _1803 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1741 = log2(cb0_009x);
                    float _1742 = _1741 * 0.3010300099849701f;
                    if ((bool)(_1732 > _1734) && (bool)(_1732 < _1742)) {
                      float _1750 = ((_1731 - _1733) * 0.9030900001525879f) / ((_1741 - _1733) * 0.3010300099849701f);
                      int _1751 = int(_1750);
                      float _1753 = _1750 - float((int)(_1751));
                      float _1755 = _14[_1751];
                      float _1758 = _14[(_1751 + 1)];
                      float _1763 = _1755 * 0.5f;
                      _1803 = dot(float3((_1753 * _1753), _1753, 1.0f), float3(mad((_14[(_1751 + 2)]), 0.5f, mad(_1758, -1.0f, _1763)), (_1758 - _1755), mad(_1758, 0.5f, _1763)));
                    } else {
                      do {
                        if (!(!(_1732 >= _1742))) {
                          float _1772 = log2(cb0_008z);
                          if (_1732 < (_1772 * 0.3010300099849701f)) {
                            float _1780 = ((_1731 - _1741) * 0.9030900001525879f) / ((_1772 - _1741) * 0.3010300099849701f);
                            int _1781 = int(_1780);
                            float _1783 = _1780 - float((int)(_1781));
                            float _1785 = _15[_1781];
                            float _1788 = _15[(_1781 + 1)];
                            float _1793 = _1785 * 0.5f;
                            _1803 = dot(float3((_1783 * _1783), _1783, 1.0f), float3(mad((_15[(_1781 + 2)]), 0.5f, mad(_1788, -1.0f, _1793)), (_1788 - _1785), mad(_1788, 0.5f, _1793)));
                            break;
                          }
                        }
                        _1803 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1807 = log2(max((lerp(_1720, _1718, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1808 = _1807 * 0.3010300099849701f;
                  do {
                    if (!(!(_1808 <= _1734))) {
                      _1877 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1815 = log2(cb0_009x);
                      float _1816 = _1815 * 0.3010300099849701f;
                      if ((bool)(_1808 > _1734) && (bool)(_1808 < _1816)) {
                        float _1824 = ((_1807 - _1733) * 0.9030900001525879f) / ((_1815 - _1733) * 0.3010300099849701f);
                        int _1825 = int(_1824);
                        float _1827 = _1824 - float((int)(_1825));
                        float _1829 = _14[_1825];
                        float _1832 = _14[(_1825 + 1)];
                        float _1837 = _1829 * 0.5f;
                        _1877 = dot(float3((_1827 * _1827), _1827, 1.0f), float3(mad((_14[(_1825 + 2)]), 0.5f, mad(_1832, -1.0f, _1837)), (_1832 - _1829), mad(_1832, 0.5f, _1837)));
                      } else {
                        do {
                          if (!(!(_1808 >= _1816))) {
                            float _1846 = log2(cb0_008z);
                            if (_1808 < (_1846 * 0.3010300099849701f)) {
                              float _1854 = ((_1807 - _1815) * 0.9030900001525879f) / ((_1846 - _1815) * 0.3010300099849701f);
                              int _1855 = int(_1854);
                              float _1857 = _1854 - float((int)(_1855));
                              float _1859 = _15[_1855];
                              float _1862 = _15[(_1855 + 1)];
                              float _1867 = _1859 * 0.5f;
                              _1877 = dot(float3((_1857 * _1857), _1857, 1.0f), float3(mad((_15[(_1855 + 2)]), 0.5f, mad(_1862, -1.0f, _1867)), (_1862 - _1859), mad(_1862, 0.5f, _1867)));
                              break;
                            }
                          }
                          _1877 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1881 = log2(max((lerp(_1720, _1719, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1882 = _1881 * 0.3010300099849701f;
                    do {
                      if (!(!(_1882 <= _1734))) {
                        _1951 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1889 = log2(cb0_009x);
                        float _1890 = _1889 * 0.3010300099849701f;
                        if ((bool)(_1882 > _1734) && (bool)(_1882 < _1890)) {
                          float _1898 = ((_1881 - _1733) * 0.9030900001525879f) / ((_1889 - _1733) * 0.3010300099849701f);
                          int _1899 = int(_1898);
                          float _1901 = _1898 - float((int)(_1899));
                          float _1903 = _14[_1899];
                          float _1906 = _14[(_1899 + 1)];
                          float _1911 = _1903 * 0.5f;
                          _1951 = dot(float3((_1901 * _1901), _1901, 1.0f), float3(mad((_14[(_1899 + 2)]), 0.5f, mad(_1906, -1.0f, _1911)), (_1906 - _1903), mad(_1906, 0.5f, _1911)));
                        } else {
                          do {
                            if (!(!(_1882 >= _1890))) {
                              float _1920 = log2(cb0_008z);
                              if (_1882 < (_1920 * 0.3010300099849701f)) {
                                float _1928 = ((_1881 - _1889) * 0.9030900001525879f) / ((_1920 - _1889) * 0.3010300099849701f);
                                int _1929 = int(_1928);
                                float _1931 = _1928 - float((int)(_1929));
                                float _1933 = _15[_1929];
                                float _1936 = _15[(_1929 + 1)];
                                float _1941 = _1933 * 0.5f;
                                _1951 = dot(float3((_1931 * _1931), _1931, 1.0f), float3(mad((_15[(_1929 + 2)]), 0.5f, mad(_1936, -1.0f, _1941)), (_1936 - _1933), mad(_1936, 0.5f, _1941)));
                                break;
                              }
                            }
                            _1951 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1955 = cb0_008w - cb0_008y;
                      float _1956 = (exp2(_1803 * 3.321928024291992f) - cb0_008y) / _1955;
                      float _1958 = (exp2(_1877 * 3.321928024291992f) - cb0_008y) / _1955;
                      float _1960 = (exp2(_1951 * 3.321928024291992f) - cb0_008y) / _1955;
                      float _1963 = mad(0.15618768334388733f, _1960, mad(0.13400420546531677f, _1958, (_1956 * 0.6624541878700256f)));
                      float _1966 = mad(0.053689517080783844f, _1960, mad(0.6740817427635193f, _1958, (_1956 * 0.2722287178039551f)));
                      float _1969 = mad(1.0103391408920288f, _1960, mad(0.00406073359772563f, _1958, (_1956 * -0.005574649665504694f)));
                      float _1982 = min(max(mad(-0.23642469942569733f, _1969, mad(-0.32480329275131226f, _1966, (_1963 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1983 = min(max(mad(0.016756348311901093f, _1969, mad(1.6153316497802734f, _1966, (_1963 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1984 = min(max(mad(0.9883948564529419f, _1969, mad(-0.008284442126750946f, _1966, (_1963 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1987 = mad(0.15618768334388733f, _1984, mad(0.13400420546531677f, _1983, (_1982 * 0.6624541878700256f)));
                      float _1990 = mad(0.053689517080783844f, _1984, mad(0.6740817427635193f, _1983, (_1982 * 0.2722287178039551f)));
                      float _1993 = mad(1.0103391408920288f, _1984, mad(0.00406073359772563f, _1983, (_1982 * -0.005574649665504694f)));
                      float _2015 = min(max((min(max(mad(-0.23642469942569733f, _1993, mad(-0.32480329275131226f, _1990, (_1987 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2016 = min(max((min(max(mad(0.016756348311901093f, _1993, mad(1.6153316497802734f, _1990, (_1987 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2017 = min(max((min(max(mad(0.9883948564529419f, _1993, mad(-0.008284442126750946f, _1990, (_1987 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _2030 = mad(_43, _2017, mad(_42, _2016, (_2015 * _41)));
                          _2031 = mad(_46, _2017, mad(_45, _2016, (_2015 * _44)));
                          _2032 = mad(_49, _2017, mad(_48, _2016, (_2015 * _47)));
                        } else {
                          _2030 = _2015;
                          _2031 = _2016;
                          _2032 = _2017;
                        }
                        float _2042 = exp2(log2(_2030 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2043 = exp2(log2(_2031 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2044 = exp2(log2(_2032 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2785 = exp2(log2((1.0f / ((_2042 * 18.6875f) + 1.0f)) * ((_2042 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2786 = exp2(log2((1.0f / ((_2043 * 18.6875f) + 1.0f)) * ((_2043 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2787 = exp2(log2((1.0f / ((_2044 * 18.6875f) + 1.0f)) * ((_2044 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2123 = cb0_012z * _1345;
          float _2124 = cb0_012z * _1346;
          float _2125 = cb0_012z * _1347;
          float _2128 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _2125, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _2124, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _2123)));
          float _2131 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _2125, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _2124, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _2123)));
          float _2134 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _2125, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _2124, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _2123)));
          float _2138 = max(max(_2128, _2131), _2134);
          float _2143 = (max(_2138, 1.000000013351432e-10f) - max(min(min(_2128, _2131), _2134), 1.000000013351432e-10f)) / max(_2138, 0.009999999776482582f);
          float _2156 = ((_2131 + _2128) + _2134) + (sqrt((((_2134 - _2131) * _2134) + ((_2131 - _2128) * _2131)) + ((_2128 - _2134) * _2128)) * 1.75f);
          float _2157 = _2156 * 0.3333333432674408f;
          float _2158 = _2143 + -0.4000000059604645f;
          float _2159 = _2158 * 5.0f;
          float _2163 = max((1.0f - abs(_2158 * 2.5f)), 0.0f);
          float _2174 = ((float((int)(((int)(uint)((bool)(_2159 > 0.0f))) - ((int)(uint)((bool)(_2159 < 0.0f))))) * (1.0f - (_2163 * _2163))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2157 <= 0.0533333346247673f)) {
              if (!(_2157 >= 0.1599999964237213f)) {
                _2183 = (((0.23999999463558197f / _2156) + -0.5f) * _2174);
              } else {
                _2183 = 0.0f;
              }
            } else {
              _2183 = _2174;
            }
            float _2184 = _2183 + 1.0f;
            float _2185 = _2184 * _2128;
            float _2186 = _2184 * _2131;
            float _2187 = _2184 * _2134;
            do {
              if (!((bool)(_2185 == _2186) && (bool)(_2186 == _2187))) {
                float _2194 = ((_2185 * 2.0f) - _2186) - _2187;
                float _2197 = ((_2131 - _2134) * 1.7320507764816284f) * _2184;
                float _2199 = atan(_2197 / _2194);
                bool _2202 = (_2194 < 0.0f);
                bool _2203 = (_2194 == 0.0f);
                bool _2204 = (_2197 >= 0.0f);
                bool _2205 = (_2197 < 0.0f);
                float _2214 = select((_2204 && _2203), 90.0f, select((_2205 && _2203), -90.0f, (select((_2205 && _2202), (_2199 + -3.1415927410125732f), select((_2204 && _2202), (_2199 + 3.1415927410125732f), _2199)) * 57.2957763671875f)));
                if (_2214 < 0.0f) {
                  _2219 = (_2214 + 360.0f);
                } else {
                  _2219 = _2214;
                }
              } else {
                _2219 = 0.0f;
              }
              float _2221 = min(max(_2219, 0.0f), 360.0f);
              do {
                if (_2221 < -180.0f) {
                  _2230 = (_2221 + 360.0f);
                } else {
                  if (_2221 > 180.0f) {
                    _2230 = (_2221 + -360.0f);
                  } else {
                    _2230 = _2221;
                  }
                }
                do {
                  if ((bool)(_2230 > -67.5f) && (bool)(_2230 < 67.5f)) {
                    float _2236 = (_2230 + 67.5f) * 0.029629629105329514f;
                    int _2237 = int(_2236);
                    float _2239 = _2236 - float((int)(_2237));
                    float _2240 = _2239 * _2239;
                    float _2241 = _2240 * _2239;
                    if (_2237 == 3) {
                      _2269 = (((0.1666666716337204f - (_2239 * 0.5f)) + (_2240 * 0.5f)) - (_2241 * 0.1666666716337204f));
                    } else {
                      if (_2237 == 2) {
                        _2269 = ((0.6666666865348816f - _2240) + (_2241 * 0.5f));
                      } else {
                        if (_2237 == 1) {
                          _2269 = (((_2241 * -0.5f) + 0.1666666716337204f) + ((_2240 + _2239) * 0.5f));
                        } else {
                          _2269 = select((_2237 == 0), (_2241 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2269 = 0.0f;
                  }
                  float _2278 = min(max(((((_2143 * 0.27000001072883606f) * (0.029999999329447746f - _2185)) * _2269) + _2185), 0.0f), 65535.0f);
                  float _2279 = min(max(_2186, 0.0f), 65535.0f);
                  float _2280 = min(max(_2187, 0.0f), 65535.0f);
                  float _2293 = min(max(mad(-0.21492856740951538f, _2280, mad(-0.2365107536315918f, _2279, (_2278 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2294 = min(max(mad(-0.09967592358589172f, _2280, mad(1.17622971534729f, _2279, (_2278 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2295 = min(max(mad(0.9977163076400757f, _2280, mad(-0.006032449658960104f, _2279, (_2278 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2296 = dot(float3(_2293, _2294, _2295), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2307 = log2(max((lerp(_2296, _2293, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2308 = _2307 * 0.3010300099849701f;
                  float _2309 = log2(cb0_008x);
                  float _2310 = _2309 * 0.3010300099849701f;
                  do {
                    if (!(!(_2308 <= _2310))) {
                      _2379 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2317 = log2(cb0_009x);
                      float _2318 = _2317 * 0.3010300099849701f;
                      if ((bool)(_2308 > _2310) && (bool)(_2308 < _2318)) {
                        float _2326 = ((_2307 - _2309) * 0.9030900001525879f) / ((_2317 - _2309) * 0.3010300099849701f);
                        int _2327 = int(_2326);
                        float _2329 = _2326 - float((int)(_2327));
                        float _2331 = _12[_2327];
                        float _2334 = _12[(_2327 + 1)];
                        float _2339 = _2331 * 0.5f;
                        _2379 = dot(float3((_2329 * _2329), _2329, 1.0f), float3(mad((_12[(_2327 + 2)]), 0.5f, mad(_2334, -1.0f, _2339)), (_2334 - _2331), mad(_2334, 0.5f, _2339)));
                      } else {
                        do {
                          if (!(!(_2308 >= _2318))) {
                            float _2348 = log2(cb0_008z);
                            if (_2308 < (_2348 * 0.3010300099849701f)) {
                              float _2356 = ((_2307 - _2317) * 0.9030900001525879f) / ((_2348 - _2317) * 0.3010300099849701f);
                              int _2357 = int(_2356);
                              float _2359 = _2356 - float((int)(_2357));
                              float _2361 = _13[_2357];
                              float _2364 = _13[(_2357 + 1)];
                              float _2369 = _2361 * 0.5f;
                              _2379 = dot(float3((_2359 * _2359), _2359, 1.0f), float3(mad((_13[(_2357 + 2)]), 0.5f, mad(_2364, -1.0f, _2369)), (_2364 - _2361), mad(_2364, 0.5f, _2369)));
                              break;
                            }
                          }
                          _2379 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2383 = log2(max((lerp(_2296, _2294, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2384 = _2383 * 0.3010300099849701f;
                    do {
                      if (!(!(_2384 <= _2310))) {
                        _2453 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2391 = log2(cb0_009x);
                        float _2392 = _2391 * 0.3010300099849701f;
                        if ((bool)(_2384 > _2310) && (bool)(_2384 < _2392)) {
                          float _2400 = ((_2383 - _2309) * 0.9030900001525879f) / ((_2391 - _2309) * 0.3010300099849701f);
                          int _2401 = int(_2400);
                          float _2403 = _2400 - float((int)(_2401));
                          float _2405 = _12[_2401];
                          float _2408 = _12[(_2401 + 1)];
                          float _2413 = _2405 * 0.5f;
                          _2453 = dot(float3((_2403 * _2403), _2403, 1.0f), float3(mad((_12[(_2401 + 2)]), 0.5f, mad(_2408, -1.0f, _2413)), (_2408 - _2405), mad(_2408, 0.5f, _2413)));
                        } else {
                          do {
                            if (!(!(_2384 >= _2392))) {
                              float _2422 = log2(cb0_008z);
                              if (_2384 < (_2422 * 0.3010300099849701f)) {
                                float _2430 = ((_2383 - _2391) * 0.9030900001525879f) / ((_2422 - _2391) * 0.3010300099849701f);
                                int _2431 = int(_2430);
                                float _2433 = _2430 - float((int)(_2431));
                                float _2435 = _13[_2431];
                                float _2438 = _13[(_2431 + 1)];
                                float _2443 = _2435 * 0.5f;
                                _2453 = dot(float3((_2433 * _2433), _2433, 1.0f), float3(mad((_13[(_2431 + 2)]), 0.5f, mad(_2438, -1.0f, _2443)), (_2438 - _2435), mad(_2438, 0.5f, _2443)));
                                break;
                              }
                            }
                            _2453 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2457 = log2(max((lerp(_2296, _2295, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2458 = _2457 * 0.3010300099849701f;
                      do {
                        if (!(!(_2458 <= _2310))) {
                          _2527 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2465 = log2(cb0_009x);
                          float _2466 = _2465 * 0.3010300099849701f;
                          if ((bool)(_2458 > _2310) && (bool)(_2458 < _2466)) {
                            float _2474 = ((_2457 - _2309) * 0.9030900001525879f) / ((_2465 - _2309) * 0.3010300099849701f);
                            int _2475 = int(_2474);
                            float _2477 = _2474 - float((int)(_2475));
                            float _2479 = _12[_2475];
                            float _2482 = _12[(_2475 + 1)];
                            float _2487 = _2479 * 0.5f;
                            _2527 = dot(float3((_2477 * _2477), _2477, 1.0f), float3(mad((_12[(_2475 + 2)]), 0.5f, mad(_2482, -1.0f, _2487)), (_2482 - _2479), mad(_2482, 0.5f, _2487)));
                          } else {
                            do {
                              if (!(!(_2458 >= _2466))) {
                                float _2496 = log2(cb0_008z);
                                if (_2458 < (_2496 * 0.3010300099849701f)) {
                                  float _2504 = ((_2457 - _2465) * 0.9030900001525879f) / ((_2496 - _2465) * 0.3010300099849701f);
                                  int _2505 = int(_2504);
                                  float _2507 = _2504 - float((int)(_2505));
                                  float _2509 = _13[_2505];
                                  float _2512 = _13[(_2505 + 1)];
                                  float _2517 = _2509 * 0.5f;
                                  _2527 = dot(float3((_2507 * _2507), _2507, 1.0f), float3(mad((_13[(_2505 + 2)]), 0.5f, mad(_2512, -1.0f, _2517)), (_2512 - _2509), mad(_2512, 0.5f, _2517)));
                                  break;
                                }
                              }
                              _2527 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2531 = cb0_008w - cb0_008y;
                        float _2532 = (exp2(_2379 * 3.321928024291992f) - cb0_008y) / _2531;
                        float _2534 = (exp2(_2453 * 3.321928024291992f) - cb0_008y) / _2531;
                        float _2536 = (exp2(_2527 * 3.321928024291992f) - cb0_008y) / _2531;
                        float _2539 = mad(0.15618768334388733f, _2536, mad(0.13400420546531677f, _2534, (_2532 * 0.6624541878700256f)));
                        float _2542 = mad(0.053689517080783844f, _2536, mad(0.6740817427635193f, _2534, (_2532 * 0.2722287178039551f)));
                        float _2545 = mad(1.0103391408920288f, _2536, mad(0.00406073359772563f, _2534, (_2532 * -0.005574649665504694f)));
                        float _2558 = min(max(mad(-0.23642469942569733f, _2545, mad(-0.32480329275131226f, _2542, (_2539 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2559 = min(max(mad(0.016756348311901093f, _2545, mad(1.6153316497802734f, _2542, (_2539 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2560 = min(max(mad(0.9883948564529419f, _2545, mad(-0.008284442126750946f, _2542, (_2539 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2563 = mad(0.15618768334388733f, _2560, mad(0.13400420546531677f, _2559, (_2558 * 0.6624541878700256f)));
                        float _2566 = mad(0.053689517080783844f, _2560, mad(0.6740817427635193f, _2559, (_2558 * 0.2722287178039551f)));
                        float _2569 = mad(1.0103391408920288f, _2560, mad(0.00406073359772563f, _2559, (_2558 * -0.005574649665504694f)));
                        float _2591 = min(max((min(max(mad(-0.23642469942569733f, _2569, mad(-0.32480329275131226f, _2566, (_2563 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2592 = min(max((min(max(mad(0.016756348311901093f, _2569, mad(1.6153316497802734f, _2566, (_2563 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2593 = min(max((min(max(mad(0.9883948564529419f, _2569, mad(-0.008284442126750946f, _2566, (_2563 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2606 = mad(_43, _2593, mad(_42, _2592, (_2591 * _41)));
                            _2607 = mad(_46, _2593, mad(_45, _2592, (_2591 * _44)));
                            _2608 = mad(_49, _2593, mad(_48, _2592, (_2591 * _47)));
                          } else {
                            _2606 = _2591;
                            _2607 = _2592;
                            _2608 = _2593;
                          }
                          float _2618 = exp2(log2(_2606 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2619 = exp2(log2(_2607 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2620 = exp2(log2(_2608 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2785 = exp2(log2((1.0f / ((_2618 * 18.6875f) + 1.0f)) * ((_2618 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2786 = exp2(log2((1.0f / ((_2619 * 18.6875f) + 1.0f)) * ((_2619 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2787 = exp2(log2((1.0f / ((_2620 * 18.6875f) + 1.0f)) * ((_2620 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2665 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1347, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1346, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1345)));
            float _2668 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1347, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1346, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1345)));
            float _2671 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1347, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1346, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1345)));
            float _2690 = exp2(log2(mad(_43, _2671, mad(_42, _2668, (_2665 * _41))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2691 = exp2(log2(mad(_46, _2671, mad(_45, _2668, (_2665 * _44))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2692 = exp2(log2(mad(_49, _2671, mad(_48, _2668, (_2665 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2785 = exp2(log2((1.0f / ((_2690 * 18.6875f) + 1.0f)) * ((_2690 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2786 = exp2(log2((1.0f / ((_2691 * 18.6875f) + 1.0f)) * ((_2691 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2787 = exp2(log2((1.0f / ((_2692 * 18.6875f) + 1.0f)) * ((_2692 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2739 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1335, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1334, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1333)));
                float _2742 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1335, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1334, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1333)));
                float _2745 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1335, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1334, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1333)));
                _2785 = mad(_43, _2745, mad(_42, _2742, (_2739 * _41)));
                _2786 = mad(_46, _2745, mad(_45, _2742, (_2739 * _44)));
                _2787 = mad(_49, _2745, mad(_48, _2742, (_2739 * _47)));
              } else {
                float _2758 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1359)));
                float _2761 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1359)));
                float _2764 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1361, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1360, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1359)));
                _2785 = exp2(log2(mad(_43, _2764, mad(_42, _2761, (_2758 * _41)))) * cb0_040z);
                _2786 = exp2(log2(mad(_46, _2764, mad(_45, _2761, (_2758 * _44)))) * cb0_040z);
                _2787 = exp2(log2(mad(_49, _2764, mad(_48, _2761, (_2758 * _47)))) * cb0_040z);
              }
            } else {
              _2785 = _1345;
              _2786 = _1346;
              _2787 = _1347;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2785 * 0.9523810148239136f);
  SV_Target.y = (_2786 * 0.9523810148239136f);
  SV_Target.z = (_2787 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
