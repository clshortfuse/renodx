#include "../common.hlsl"

// Found in The Casting of Frank Stone

Texture3D<float4> t0 : register(t0);

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
  int cb0_038z : packoffset(c038.z);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
  int cb0_041x : packoffset(c041.x);
  int cb0_042x : packoffset(c042.x);
  int cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
};

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
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
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
  float _803;
  float _813;
  float _823;
  float _900;
  float _901;
  float _902;
  float _912;
  float _922;
  float _932;
  float _940;
  float _941;
  float _942;
  float _1039;
  float _1075;
  float _1086;
  float _1150;
  float _1418;
  float _1419;
  float _1420;
  float _1431;
  float _1442;
  float _1624;
  float _1660;
  float _1671;
  float _1710;
  float _1820;
  float _1894;
  float _1968;
  float _2047;
  float _2048;
  float _2049;
  float _2200;
  float _2236;
  float _2247;
  float _2286;
  float _2396;
  float _2470;
  float _2544;
  float _2623;
  float _2624;
  float _2625;
  float _2802;
  float _2803;
  float _2804;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _28 = (cb0_041x == 4);
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
  if ((uint)cb0_040w > (uint)2) {
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

  SetUngradedAP1(float3(_376, _379, _382));

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

  SetUntonemappedAP1(float3(_785, _787, _789));

  if (!(cb0_042x == 0)) {
    do {
      if (_785 > 0.0078125f) {
        _803 = ((log2(_785) + 9.720000267028809f) * 0.05707762390375137f);
      } else {
        _803 = ((_785 * 10.540237426757812f) + 0.072905533015728f);
      }
      do {
        if (_787 > 0.0078125f) {
          _813 = ((log2(_787) + 9.720000267028809f) * 0.05707762390375137f);
        } else {
          _813 = ((_787 * 10.540237426757812f) + 0.072905533015728f);
        }
        do {
          if (_789 > 0.0078125f) {
            _823 = ((log2(_789) + 9.720000267028809f) * 0.05707762390375137f);
          } else {
            _823 = ((_789 * 10.540237426757812f) + 0.072905533015728f);
          }
          float _827 = min(max(_803, 0.0f), 1.0f);
          float _828 = min(max(_813, 0.0f), 1.0f);
          float _829 = min(max(_823, 0.0f), 1.0f);
          float4 _834 = t0.Sample(s0, float3(_827, _828, _829));
          do {
            if (cb0_042y == 1) {
              float4 _842 = t0.Sample(s0, float3((cb0_042z + _827), _828, _829));
              float4 _847 = t0.Sample(s0, float3(_827, (cb0_042z + _828), _829));
              float4 _852 = t0.Sample(s0, float3(_827, _828, (cb0_042z + _829)));
              float _868 = saturate(1.0f - abs(_827 - floor(_827)));
              float _869 = saturate(1.0f - abs(_828 - floor(_828)));
              float _870 = saturate(1.0f - abs(_829 - floor(_829)));
              float _871 = dot(float3(_868, _869, _870), float3(1.0f, 1.0f, 1.0f));
              float _872 = _868 / _871;
              float _873 = _869 / _871;
              float _874 = _870 / _871;
              float _892 = ((1.0f - _872) - _873) - _874;
              _900 = ((((_873 * _842.x) + (_872 * _834.x)) + (_874 * _847.x)) + (_892 * _852.x));
              _901 = ((((_873 * _842.y) + (_872 * _834.y)) + (_874 * _847.y)) + (_892 * _852.y));
              _902 = ((((_873 * _842.z) + (_872 * _834.z)) + (_874 * _847.z)) + (_892 * _852.z));
            } else {
              _900 = _834.x;
              _901 = _834.y;
              _902 = _834.z;
            }
            do {
              if (_900 > 0.155251145362854f) {
                _912 = exp2((_900 * 17.520000457763672f) + -9.720000267028809f);
              } else {
                _912 = ((_900 + -0.072905533015728f) * 0.09487452358007431f);
              }
              do {
                if (_901 > 0.155251145362854f) {
                  _922 = exp2((_901 * 17.520000457763672f) + -9.720000267028809f);
                } else {
                  _922 = ((_901 + -0.072905533015728f) * 0.09487452358007431f);
                }
                do {
                  if (_902 > 0.155251145362854f) {
                    _932 = exp2((_902 * 17.520000457763672f) + -9.720000267028809f);
                  } else {
                    _932 = ((_902 + -0.072905533015728f) * 0.09487452358007431f);
                  }
                  _940 = min(max(_912, 0.0f), 65504.0f);
                  _941 = min(max(_922, 0.0f), 65504.0f);
                  _942 = min(max(_932, 0.0f), 65504.0f);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    } while (false);
  } else {
    _940 = _785;
    _941 = _787;
    _942 = _789;
  }
  float _979 = ((mad(0.061360642313957214f, _942, mad(-4.540197551250458e-09f, _941, (_940 * 0.9386394023895264f))) - _940) * cb0_036y) + _940;
  float _980 = ((mad(0.169205904006958f, _942, mad(0.8307942152023315f, _941, (_940 * 6.775371730327606e-08f))) - _941) * cb0_036y) + _941;
  float _981 = (mad(-2.3283064365386963e-10f, _941, (_940 * -9.313225746154785e-10f)) * cb0_036y) + _942;
  float _984 = mad(0.16386905312538147f, _981, mad(0.14067868888378143f, _980, (_979 * 0.6954522132873535f)));
  float _987 = mad(0.0955343246459961f, _981, mad(0.8596711158752441f, _980, (_979 * 0.044794581830501556f)));
  float _990 = mad(1.0015007257461548f, _981, mad(0.004025210160762072f, _980, (_979 * -0.005525882821530104f)));
  float _994 = max(max(_984, _987), _990);
  float _999 = (max(_994, 1.000000013351432e-10f) - max(min(min(_984, _987), _990), 1.000000013351432e-10f)) / max(_994, 0.009999999776482582f);
  float _1012 = ((_987 + _984) + _990) + (sqrt((((_990 - _987) * _990) + ((_987 - _984) * _987)) + ((_984 - _990) * _984)) * 1.75f);
  float _1013 = _1012 * 0.3333333432674408f;
  float _1014 = _999 + -0.4000000059604645f;
  float _1015 = _1014 * 5.0f;
  float _1019 = max((1.0f - abs(_1014 * 2.5f)), 0.0f);
  float _1030 = ((float((int)(((int)(uint)((bool)(_1015 > 0.0f))) - ((int)(uint)((bool)(_1015 < 0.0f))))) * (1.0f - (_1019 * _1019))) + 1.0f) * 0.02500000037252903f;
  if (!(_1013 <= 0.0533333346247673f)) {
    if (!(_1013 >= 0.1599999964237213f)) {
      _1039 = (((0.23999999463558197f / _1012) + -0.5f) * _1030);
    } else {
      _1039 = 0.0f;
    }
  } else {
    _1039 = _1030;
  }
  float _1040 = _1039 + 1.0f;
  float _1041 = _1040 * _984;
  float _1042 = _1040 * _987;
  float _1043 = _1040 * _990;
  if (!((bool)(_1041 == _1042) && (bool)(_1042 == _1043))) {
    float _1050 = ((_1041 * 2.0f) - _1042) - _1043;
    float _1053 = ((_987 - _990) * 1.7320507764816284f) * _1040;
    float _1055 = atan(_1053 / _1050);
    bool _1058 = (_1050 < 0.0f);
    bool _1059 = (_1050 == 0.0f);
    bool _1060 = (_1053 >= 0.0f);
    bool _1061 = (_1053 < 0.0f);
    float _1070 = select((_1060 && _1059), 90.0f, select((_1061 && _1059), -90.0f, (select((_1061 && _1058), (_1055 + -3.1415927410125732f), select((_1060 && _1058), (_1055 + 3.1415927410125732f), _1055)) * 57.2957763671875f)));
    if (_1070 < 0.0f) {
      _1075 = (_1070 + 360.0f);
    } else {
      _1075 = _1070;
    }
  } else {
    _1075 = 0.0f;
  }
  float _1077 = min(max(_1075, 0.0f), 360.0f);
  if (_1077 < -180.0f) {
    _1086 = (_1077 + 360.0f);
  } else {
    if (_1077 > 180.0f) {
      _1086 = (_1077 + -360.0f);
    } else {
      _1086 = _1077;
    }
  }
  float _1090 = saturate(1.0f - abs(_1086 * 0.014814814552664757f));
  float _1094 = (_1090 * _1090) * (3.0f - (_1090 * 2.0f));
  float _1100 = ((_1094 * _1094) * ((_999 * 0.18000000715255737f) * (0.029999999329447746f - _1041))) + _1041;
  float _1110 = max(0.0f, mad(-0.21492856740951538f, _1043, mad(-0.2365107536315918f, _1042, (_1100 * 1.4514392614364624f))));
  float _1111 = max(0.0f, mad(-0.09967592358589172f, _1043, mad(1.17622971534729f, _1042, (_1100 * -0.07655377686023712f))));
  float _1112 = max(0.0f, mad(0.9977163076400757f, _1043, mad(-0.006032449658960104f, _1042, (_1100 * 0.008316148072481155f))));
  float _1113 = dot(float3(_1110, _1111, _1112), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1127 = (cb0_037w + 1.0f) - cb0_037y;
  float _1130 = cb0_038x + 1.0f;
  float _1132 = _1130 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _1150 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _1141 = (cb0_037w + 0.18000000715255737f) / _1127;
    _1150 = (-0.7447274923324585f - ((log2(_1141 / (2.0f - _1141)) * 0.3465735912322998f) * (_1127 / cb0_037x)));
  }
  float _1153 = ((1.0f - cb0_037y) / cb0_037x) - _1150;
  float _1155 = (cb0_037z / cb0_037x) - _1153;
  float _1159 = log2(lerp(_1113, _1110, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1160 = log2(lerp(_1113, _1111, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1161 = log2(lerp(_1113, _1112, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1165 = cb0_037x * (_1159 + _1153);
  float _1166 = cb0_037x * (_1160 + _1153);
  float _1167 = cb0_037x * (_1161 + _1153);
  float _1168 = _1127 * 2.0f;
  float _1170 = (cb0_037x * -2.0f) / _1127;
  float _1171 = _1159 - _1150;
  float _1172 = _1160 - _1150;
  float _1173 = _1161 - _1150;
  float _1192 = _1132 * 2.0f;
  float _1194 = (cb0_037x * 2.0f) / _1132;
  float _1219 = select((_1159 < _1150), ((_1168 / (exp2((_1171 * 1.4426950216293335f) * _1170) + 1.0f)) - cb0_037w), _1165);
  float _1220 = select((_1160 < _1150), ((_1168 / (exp2((_1172 * 1.4426950216293335f) * _1170) + 1.0f)) - cb0_037w), _1166);
  float _1221 = select((_1161 < _1150), ((_1168 / (exp2((_1173 * 1.4426950216293335f) * _1170) + 1.0f)) - cb0_037w), _1167);
  float _1228 = _1155 - _1150;
  float _1232 = saturate(_1171 / _1228);
  float _1233 = saturate(_1172 / _1228);
  float _1234 = saturate(_1173 / _1228);
  bool _1235 = (_1155 < _1150);
  float _1239 = select(_1235, (1.0f - _1232), _1232);
  float _1240 = select(_1235, (1.0f - _1233), _1233);
  float _1241 = select(_1235, (1.0f - _1234), _1234);
  float _1260 = (((_1239 * _1239) * (select((_1159 > _1155), (_1130 - (_1192 / (exp2(((_1159 - _1155) * 1.4426950216293335f) * _1194) + 1.0f))), _1165) - _1219)) * (3.0f - (_1239 * 2.0f))) + _1219;
  float _1261 = (((_1240 * _1240) * (select((_1160 > _1155), (_1130 - (_1192 / (exp2(((_1160 - _1155) * 1.4426950216293335f) * _1194) + 1.0f))), _1166) - _1220)) * (3.0f - (_1240 * 2.0f))) + _1220;
  float _1262 = (((_1241 * _1241) * (select((_1161 > _1155), (_1130 - (_1192 / (exp2(((_1161 - _1155) * 1.4426950216293335f) * _1194) + 1.0f))), _1167) - _1221)) * (3.0f - (_1241 * 2.0f))) + _1221;
  float _1263 = dot(float3(_1260, _1261, _1262), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1283 = (cb0_036w * (max(0.0f, (lerp(_1263, _1260, 0.9300000071525574f))) - _979)) + _979;
  float _1284 = (cb0_036w * (max(0.0f, (lerp(_1263, _1261, 0.9300000071525574f))) - _980)) + _980;
  float _1285 = (cb0_036w * (max(0.0f, (lerp(_1263, _1262, 0.9300000071525574f))) - _981)) + _981;
  float _1301 = ((mad(-0.06537103652954102f, _1285, mad(1.451815478503704e-06f, _1284, (_1283 * 1.065374732017517f))) - _1283) * cb0_036y) + _1283;
  float _1302 = ((mad(-0.20366770029067993f, _1285, mad(1.2036634683609009f, _1284, (_1283 * -2.57161445915699e-07f))) - _1284) * cb0_036y) + _1284;
  float _1303 = ((mad(0.9999996423721313f, _1285, mad(2.0954757928848267e-08f, _1284, (_1283 * 1.862645149230957e-08f))) - _1285) * cb0_036y) + _1285;

  SetTonemappedAP1(_1301, _1302, _1303);

  float _1313 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1303, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1302, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1301))));
  float _1314 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1303, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1302, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1301))));
  float _1315 = max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1303, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1302, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1301))));
  float _1341 = cb0_014x * (((cb0_039y + (cb0_039x * _1313)) * _1313) + cb0_039z);
  float _1342 = cb0_014y * (((cb0_039y + (cb0_039x * _1314)) * _1314) + cb0_039z);
  float _1343 = cb0_014z * (((cb0_039y + (cb0_039x * _1315)) * _1315) + cb0_039z);
  float _1350 = ((cb0_013x - _1341) * cb0_013w) + _1341;
  float _1351 = ((cb0_013y - _1342) * cb0_013w) + _1342;
  float _1352 = ((cb0_013z - _1343) * cb0_013w) + _1343;
  float _1353 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _942, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _941, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _940)));
  float _1354 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _942, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _941, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _940)));
  float _1355 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _942, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _941, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _940)));
  float _1362 = ((cb0_013x - _1353) * cb0_013w) + _1353;
  float _1363 = ((cb0_013y - _1354) * cb0_013w) + _1354;
  float _1364 = ((cb0_013z - _1355) * cb0_013w) + _1355;
  float _1376 = exp2(log2(max(0.0f, _1350)) * cb0_040y);
  float _1377 = exp2(log2(max(0.0f, _1351)) * cb0_040y);
  float _1378 = exp2(log2(max(0.0f, _1352)) * cb0_040y);

  if (true) {
    return GenerateOutput(float3(_1376, _1377, _1378), cb0_040w);
  }

  [branch]
  if (cb0_040w == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1401 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1376)));
        float _1404 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1376)));
        float _1407 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1376)));
        _1418 = mad(_41, _1407, mad(_40, _1404, (_1401 * _39)));
        _1419 = mad(_44, _1407, mad(_43, _1404, (_1401 * _42)));
        _1420 = mad(_47, _1407, mad(_46, _1404, (_1401 * _45)));
      } else {
        _1418 = _1376;
        _1419 = _1377;
        _1420 = _1378;
      }
      do {
        if (_1418 < 0.0031306699384003878f) {
          _1431 = (_1418 * 12.920000076293945f);
        } else {
          _1431 = (((pow(_1418, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1419 < 0.0031306699384003878f) {
            _1442 = (_1419 * 12.920000076293945f);
          } else {
            _1442 = (((pow(_1419, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1420 < 0.0031306699384003878f) {
            _2802 = _1431;
            _2803 = _1442;
            _2804 = (_1420 * 12.920000076293945f);
          } else {
            _2802 = _1431;
            _2803 = _1442;
            _2804 = (((pow(_1420, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1469 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1376)));
      float _1472 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1376)));
      float _1475 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1376)));
      float _1485 = max(6.103519990574569e-05f, mad(_41, _1475, mad(_40, _1472, (_1469 * _39))));
      float _1486 = max(6.103519990574569e-05f, mad(_44, _1475, mad(_43, _1472, (_1469 * _42))));
      float _1487 = max(6.103519990574569e-05f, mad(_47, _1475, mad(_46, _1472, (_1469 * _45))));
      _2802 = min((_1485 * 4.5f), ((exp2(log2(max(_1485, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2803 = min((_1486 * 4.5f), ((exp2(log2(max(_1486, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2804 = min((_1487 * 4.5f), ((exp2(log2(max(_1487, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1564 = cb0_012z * _1362;
        float _1565 = cb0_012z * _1363;
        float _1566 = cb0_012z * _1364;
        float _1569 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1566, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1565, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1564)));
        float _1572 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1566, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1565, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1564)));
        float _1575 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1566, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1565, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1564)));
        float _1579 = max(max(_1569, _1572), _1575);
        float _1584 = (max(_1579, 1.000000013351432e-10f) - max(min(min(_1569, _1572), _1575), 1.000000013351432e-10f)) / max(_1579, 0.009999999776482582f);
        float _1597 = ((_1572 + _1569) + _1575) + (sqrt((((_1575 - _1572) * _1575) + ((_1572 - _1569) * _1572)) + ((_1569 - _1575) * _1569)) * 1.75f);
        float _1598 = _1597 * 0.3333333432674408f;
        float _1599 = _1584 + -0.4000000059604645f;
        float _1600 = _1599 * 5.0f;
        float _1604 = max((1.0f - abs(_1599 * 2.5f)), 0.0f);
        float _1615 = ((float((int)(((int)(uint)((bool)(_1600 > 0.0f))) - ((int)(uint)((bool)(_1600 < 0.0f))))) * (1.0f - (_1604 * _1604))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1598 <= 0.0533333346247673f)) {
            if (!(_1598 >= 0.1599999964237213f)) {
              _1624 = (((0.23999999463558197f / _1597) + -0.5f) * _1615);
            } else {
              _1624 = 0.0f;
            }
          } else {
            _1624 = _1615;
          }
          float _1625 = _1624 + 1.0f;
          float _1626 = _1625 * _1569;
          float _1627 = _1625 * _1572;
          float _1628 = _1625 * _1575;
          do {
            if (!((bool)(_1626 == _1627) && (bool)(_1627 == _1628))) {
              float _1635 = ((_1626 * 2.0f) - _1627) - _1628;
              float _1638 = ((_1572 - _1575) * 1.7320507764816284f) * _1625;
              float _1640 = atan(_1638 / _1635);
              bool _1643 = (_1635 < 0.0f);
              bool _1644 = (_1635 == 0.0f);
              bool _1645 = (_1638 >= 0.0f);
              bool _1646 = (_1638 < 0.0f);
              float _1655 = select((_1645 && _1644), 90.0f, select((_1646 && _1644), -90.0f, (select((_1646 && _1643), (_1640 + -3.1415927410125732f), select((_1645 && _1643), (_1640 + 3.1415927410125732f), _1640)) * 57.2957763671875f)));
              if (_1655 < 0.0f) {
                _1660 = (_1655 + 360.0f);
              } else {
                _1660 = _1655;
              }
            } else {
              _1660 = 0.0f;
            }
            float _1662 = min(max(_1660, 0.0f), 360.0f);
            do {
              if (_1662 < -180.0f) {
                _1671 = (_1662 + 360.0f);
              } else {
                if (_1662 > 180.0f) {
                  _1671 = (_1662 + -360.0f);
                } else {
                  _1671 = _1662;
                }
              }
              do {
                if ((bool)(_1671 > -67.5f) && (bool)(_1671 < 67.5f)) {
                  float _1677 = (_1671 + 67.5f) * 0.029629629105329514f;
                  int _1678 = int(_1677);
                  float _1680 = _1677 - float((int)(_1678));
                  float _1681 = _1680 * _1680;
                  float _1682 = _1681 * _1680;
                  if (_1678 == 3) {
                    _1710 = (((0.1666666716337204f - (_1680 * 0.5f)) + (_1681 * 0.5f)) - (_1682 * 0.1666666716337204f));
                  } else {
                    if (_1678 == 2) {
                      _1710 = ((0.6666666865348816f - _1681) + (_1682 * 0.5f));
                    } else {
                      if (_1678 == 1) {
                        _1710 = (((_1682 * -0.5f) + 0.1666666716337204f) + ((_1681 + _1680) * 0.5f));
                      } else {
                        _1710 = select((_1678 == 0), (_1682 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1710 = 0.0f;
                }
                float _1719 = min(max(((((_1584 * 0.27000001072883606f) * (0.029999999329447746f - _1626)) * _1710) + _1626), 0.0f), 65535.0f);
                float _1720 = min(max(_1627, 0.0f), 65535.0f);
                float _1721 = min(max(_1628, 0.0f), 65535.0f);
                float _1734 = min(max(mad(-0.21492856740951538f, _1721, mad(-0.2365107536315918f, _1720, (_1719 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1735 = min(max(mad(-0.09967592358589172f, _1721, mad(1.17622971534729f, _1720, (_1719 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1736 = min(max(mad(0.9977163076400757f, _1721, mad(-0.006032449658960104f, _1720, (_1719 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1737 = dot(float3(_1734, _1735, _1736), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1748 = log2(max((lerp(_1737, _1734, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1749 = _1748 * 0.3010300099849701f;
                float _1750 = log2(cb0_008x);
                float _1751 = _1750 * 0.3010300099849701f;
                do {
                  if (!(!(_1749 <= _1751))) {
                    _1820 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1758 = log2(cb0_009x);
                    float _1759 = _1758 * 0.3010300099849701f;
                    if ((bool)(_1749 > _1751) && (bool)(_1749 < _1759)) {
                      float _1767 = ((_1748 - _1750) * 0.9030900001525879f) / ((_1758 - _1750) * 0.3010300099849701f);
                      int _1768 = int(_1767);
                      float _1770 = _1767 - float((int)(_1768));
                      float _1772 = _12[_1768];
                      float _1775 = _12[(_1768 + 1)];
                      float _1780 = _1772 * 0.5f;
                      _1820 = dot(float3((_1770 * _1770), _1770, 1.0f), float3(mad((_12[(_1768 + 2)]), 0.5f, mad(_1775, -1.0f, _1780)), (_1775 - _1772), mad(_1775, 0.5f, _1780)));
                    } else {
                      do {
                        if (!(!(_1749 >= _1759))) {
                          float _1789 = log2(cb0_008z);
                          if (_1749 < (_1789 * 0.3010300099849701f)) {
                            float _1797 = ((_1748 - _1758) * 0.9030900001525879f) / ((_1789 - _1758) * 0.3010300099849701f);
                            int _1798 = int(_1797);
                            float _1800 = _1797 - float((int)(_1798));
                            float _1802 = _13[_1798];
                            float _1805 = _13[(_1798 + 1)];
                            float _1810 = _1802 * 0.5f;
                            _1820 = dot(float3((_1800 * _1800), _1800, 1.0f), float3(mad((_13[(_1798 + 2)]), 0.5f, mad(_1805, -1.0f, _1810)), (_1805 - _1802), mad(_1805, 0.5f, _1810)));
                            break;
                          }
                        }
                        _1820 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1824 = log2(max((lerp(_1737, _1735, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1825 = _1824 * 0.3010300099849701f;
                  do {
                    if (!(!(_1825 <= _1751))) {
                      _1894 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1832 = log2(cb0_009x);
                      float _1833 = _1832 * 0.3010300099849701f;
                      if ((bool)(_1825 > _1751) && (bool)(_1825 < _1833)) {
                        float _1841 = ((_1824 - _1750) * 0.9030900001525879f) / ((_1832 - _1750) * 0.3010300099849701f);
                        int _1842 = int(_1841);
                        float _1844 = _1841 - float((int)(_1842));
                        float _1846 = _12[_1842];
                        float _1849 = _12[(_1842 + 1)];
                        float _1854 = _1846 * 0.5f;
                        _1894 = dot(float3((_1844 * _1844), _1844, 1.0f), float3(mad((_12[(_1842 + 2)]), 0.5f, mad(_1849, -1.0f, _1854)), (_1849 - _1846), mad(_1849, 0.5f, _1854)));
                      } else {
                        do {
                          if (!(!(_1825 >= _1833))) {
                            float _1863 = log2(cb0_008z);
                            if (_1825 < (_1863 * 0.3010300099849701f)) {
                              float _1871 = ((_1824 - _1832) * 0.9030900001525879f) / ((_1863 - _1832) * 0.3010300099849701f);
                              int _1872 = int(_1871);
                              float _1874 = _1871 - float((int)(_1872));
                              float _1876 = _13[_1872];
                              float _1879 = _13[(_1872 + 1)];
                              float _1884 = _1876 * 0.5f;
                              _1894 = dot(float3((_1874 * _1874), _1874, 1.0f), float3(mad((_13[(_1872 + 2)]), 0.5f, mad(_1879, -1.0f, _1884)), (_1879 - _1876), mad(_1879, 0.5f, _1884)));
                              break;
                            }
                          }
                          _1894 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1898 = log2(max((lerp(_1737, _1736, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1899 = _1898 * 0.3010300099849701f;
                    do {
                      if (!(!(_1899 <= _1751))) {
                        _1968 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1906 = log2(cb0_009x);
                        float _1907 = _1906 * 0.3010300099849701f;
                        if ((bool)(_1899 > _1751) && (bool)(_1899 < _1907)) {
                          float _1915 = ((_1898 - _1750) * 0.9030900001525879f) / ((_1906 - _1750) * 0.3010300099849701f);
                          int _1916 = int(_1915);
                          float _1918 = _1915 - float((int)(_1916));
                          float _1920 = _12[_1916];
                          float _1923 = _12[(_1916 + 1)];
                          float _1928 = _1920 * 0.5f;
                          _1968 = dot(float3((_1918 * _1918), _1918, 1.0f), float3(mad((_12[(_1916 + 2)]), 0.5f, mad(_1923, -1.0f, _1928)), (_1923 - _1920), mad(_1923, 0.5f, _1928)));
                        } else {
                          do {
                            if (!(!(_1899 >= _1907))) {
                              float _1937 = log2(cb0_008z);
                              if (_1899 < (_1937 * 0.3010300099849701f)) {
                                float _1945 = ((_1898 - _1906) * 0.9030900001525879f) / ((_1937 - _1906) * 0.3010300099849701f);
                                int _1946 = int(_1945);
                                float _1948 = _1945 - float((int)(_1946));
                                float _1950 = _13[_1946];
                                float _1953 = _13[(_1946 + 1)];
                                float _1958 = _1950 * 0.5f;
                                _1968 = dot(float3((_1948 * _1948), _1948, 1.0f), float3(mad((_13[(_1946 + 2)]), 0.5f, mad(_1953, -1.0f, _1958)), (_1953 - _1950), mad(_1953, 0.5f, _1958)));
                                break;
                              }
                            }
                            _1968 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1972 = cb0_008w - cb0_008y;
                      float _1973 = (exp2(_1820 * 3.321928024291992f) - cb0_008y) / _1972;
                      float _1975 = (exp2(_1894 * 3.321928024291992f) - cb0_008y) / _1972;
                      float _1977 = (exp2(_1968 * 3.321928024291992f) - cb0_008y) / _1972;
                      float _1980 = mad(0.15618768334388733f, _1977, mad(0.13400420546531677f, _1975, (_1973 * 0.6624541878700256f)));
                      float _1983 = mad(0.053689517080783844f, _1977, mad(0.6740817427635193f, _1975, (_1973 * 0.2722287178039551f)));
                      float _1986 = mad(1.0103391408920288f, _1977, mad(0.00406073359772563f, _1975, (_1973 * -0.005574649665504694f)));
                      float _1999 = min(max(mad(-0.23642469942569733f, _1986, mad(-0.32480329275131226f, _1983, (_1980 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _2000 = min(max(mad(0.016756348311901093f, _1986, mad(1.6153316497802734f, _1983, (_1980 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _2001 = min(max(mad(0.9883948564529419f, _1986, mad(-0.008284442126750946f, _1983, (_1980 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _2004 = mad(0.15618768334388733f, _2001, mad(0.13400420546531677f, _2000, (_1999 * 0.6624541878700256f)));
                      float _2007 = mad(0.053689517080783844f, _2001, mad(0.6740817427635193f, _2000, (_1999 * 0.2722287178039551f)));
                      float _2010 = mad(1.0103391408920288f, _2001, mad(0.00406073359772563f, _2000, (_1999 * -0.005574649665504694f)));
                      float _2032 = min(max((min(max(mad(-0.23642469942569733f, _2010, mad(-0.32480329275131226f, _2007, (_2004 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2033 = min(max((min(max(mad(0.016756348311901093f, _2010, mad(1.6153316497802734f, _2007, (_2004 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _2034 = min(max((min(max(mad(0.9883948564529419f, _2010, mad(-0.008284442126750946f, _2007, (_2004 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(cb0_040w == 5)) {
                          _2047 = mad(_41, _2034, mad(_40, _2033, (_2032 * _39)));
                          _2048 = mad(_44, _2034, mad(_43, _2033, (_2032 * _42)));
                          _2049 = mad(_47, _2034, mad(_46, _2033, (_2032 * _45)));
                        } else {
                          _2047 = _2032;
                          _2048 = _2033;
                          _2049 = _2034;
                        }
                        float _2059 = exp2(log2(_2047 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2060 = exp2(log2(_2048 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2061 = exp2(log2(_2049 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2802 = exp2(log2((1.0f / ((_2059 * 18.6875f) + 1.0f)) * ((_2059 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2803 = exp2(log2((1.0f / ((_2060 * 18.6875f) + 1.0f)) * ((_2060 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2804 = exp2(log2((1.0f / ((_2061 * 18.6875f) + 1.0f)) * ((_2061 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((cb0_040w & -3) == 4) {
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
          float _2140 = cb0_012z * _1362;
          float _2141 = cb0_012z * _1363;
          float _2142 = cb0_012z * _1364;
          float _2145 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _2142, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _2141, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _2140)));
          float _2148 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _2142, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _2141, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _2140)));
          float _2151 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _2142, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _2141, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _2140)));
          float _2155 = max(max(_2145, _2148), _2151);
          float _2160 = (max(_2155, 1.000000013351432e-10f) - max(min(min(_2145, _2148), _2151), 1.000000013351432e-10f)) / max(_2155, 0.009999999776482582f);
          float _2173 = ((_2148 + _2145) + _2151) + (sqrt((((_2151 - _2148) * _2151) + ((_2148 - _2145) * _2148)) + ((_2145 - _2151) * _2145)) * 1.75f);
          float _2174 = _2173 * 0.3333333432674408f;
          float _2175 = _2160 + -0.4000000059604645f;
          float _2176 = _2175 * 5.0f;
          float _2180 = max((1.0f - abs(_2175 * 2.5f)), 0.0f);
          float _2191 = ((float((int)(((int)(uint)((bool)(_2176 > 0.0f))) - ((int)(uint)((bool)(_2176 < 0.0f))))) * (1.0f - (_2180 * _2180))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2174 <= 0.0533333346247673f)) {
              if (!(_2174 >= 0.1599999964237213f)) {
                _2200 = (((0.23999999463558197f / _2173) + -0.5f) * _2191);
              } else {
                _2200 = 0.0f;
              }
            } else {
              _2200 = _2191;
            }
            float _2201 = _2200 + 1.0f;
            float _2202 = _2201 * _2145;
            float _2203 = _2201 * _2148;
            float _2204 = _2201 * _2151;
            do {
              if (!((bool)(_2202 == _2203) && (bool)(_2203 == _2204))) {
                float _2211 = ((_2202 * 2.0f) - _2203) - _2204;
                float _2214 = ((_2148 - _2151) * 1.7320507764816284f) * _2201;
                float _2216 = atan(_2214 / _2211);
                bool _2219 = (_2211 < 0.0f);
                bool _2220 = (_2211 == 0.0f);
                bool _2221 = (_2214 >= 0.0f);
                bool _2222 = (_2214 < 0.0f);
                float _2231 = select((_2221 && _2220), 90.0f, select((_2222 && _2220), -90.0f, (select((_2222 && _2219), (_2216 + -3.1415927410125732f), select((_2221 && _2219), (_2216 + 3.1415927410125732f), _2216)) * 57.2957763671875f)));
                if (_2231 < 0.0f) {
                  _2236 = (_2231 + 360.0f);
                } else {
                  _2236 = _2231;
                }
              } else {
                _2236 = 0.0f;
              }
              float _2238 = min(max(_2236, 0.0f), 360.0f);
              do {
                if (_2238 < -180.0f) {
                  _2247 = (_2238 + 360.0f);
                } else {
                  if (_2238 > 180.0f) {
                    _2247 = (_2238 + -360.0f);
                  } else {
                    _2247 = _2238;
                  }
                }
                do {
                  if ((bool)(_2247 > -67.5f) && (bool)(_2247 < 67.5f)) {
                    float _2253 = (_2247 + 67.5f) * 0.029629629105329514f;
                    int _2254 = int(_2253);
                    float _2256 = _2253 - float((int)(_2254));
                    float _2257 = _2256 * _2256;
                    float _2258 = _2257 * _2256;
                    if (_2254 == 3) {
                      _2286 = (((0.1666666716337204f - (_2256 * 0.5f)) + (_2257 * 0.5f)) - (_2258 * 0.1666666716337204f));
                    } else {
                      if (_2254 == 2) {
                        _2286 = ((0.6666666865348816f - _2257) + (_2258 * 0.5f));
                      } else {
                        if (_2254 == 1) {
                          _2286 = (((_2258 * -0.5f) + 0.1666666716337204f) + ((_2257 + _2256) * 0.5f));
                        } else {
                          _2286 = select((_2254 == 0), (_2258 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2286 = 0.0f;
                  }
                  float _2295 = min(max(((((_2160 * 0.27000001072883606f) * (0.029999999329447746f - _2202)) * _2286) + _2202), 0.0f), 65535.0f);
                  float _2296 = min(max(_2203, 0.0f), 65535.0f);
                  float _2297 = min(max(_2204, 0.0f), 65535.0f);
                  float _2310 = min(max(mad(-0.21492856740951538f, _2297, mad(-0.2365107536315918f, _2296, (_2295 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2311 = min(max(mad(-0.09967592358589172f, _2297, mad(1.17622971534729f, _2296, (_2295 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2312 = min(max(mad(0.9977163076400757f, _2297, mad(-0.006032449658960104f, _2296, (_2295 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2313 = dot(float3(_2310, _2311, _2312), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2324 = log2(max((lerp(_2313, _2310, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2325 = _2324 * 0.3010300099849701f;
                  float _2326 = log2(cb0_008x);
                  float _2327 = _2326 * 0.3010300099849701f;
                  do {
                    if (!(!(_2325 <= _2327))) {
                      _2396 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2334 = log2(cb0_009x);
                      float _2335 = _2334 * 0.3010300099849701f;
                      if ((bool)(_2325 > _2327) && (bool)(_2325 < _2335)) {
                        float _2343 = ((_2324 - _2326) * 0.9030900001525879f) / ((_2334 - _2326) * 0.3010300099849701f);
                        int _2344 = int(_2343);
                        float _2346 = _2343 - float((int)(_2344));
                        float _2348 = _10[_2344];
                        float _2351 = _10[(_2344 + 1)];
                        float _2356 = _2348 * 0.5f;
                        _2396 = dot(float3((_2346 * _2346), _2346, 1.0f), float3(mad((_10[(_2344 + 2)]), 0.5f, mad(_2351, -1.0f, _2356)), (_2351 - _2348), mad(_2351, 0.5f, _2356)));
                      } else {
                        do {
                          if (!(!(_2325 >= _2335))) {
                            float _2365 = log2(cb0_008z);
                            if (_2325 < (_2365 * 0.3010300099849701f)) {
                              float _2373 = ((_2324 - _2334) * 0.9030900001525879f) / ((_2365 - _2334) * 0.3010300099849701f);
                              int _2374 = int(_2373);
                              float _2376 = _2373 - float((int)(_2374));
                              float _2378 = _11[_2374];
                              float _2381 = _11[(_2374 + 1)];
                              float _2386 = _2378 * 0.5f;
                              _2396 = dot(float3((_2376 * _2376), _2376, 1.0f), float3(mad((_11[(_2374 + 2)]), 0.5f, mad(_2381, -1.0f, _2386)), (_2381 - _2378), mad(_2381, 0.5f, _2386)));
                              break;
                            }
                          }
                          _2396 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2400 = log2(max((lerp(_2313, _2311, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2401 = _2400 * 0.3010300099849701f;
                    do {
                      if (!(!(_2401 <= _2327))) {
                        _2470 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2408 = log2(cb0_009x);
                        float _2409 = _2408 * 0.3010300099849701f;
                        if ((bool)(_2401 > _2327) && (bool)(_2401 < _2409)) {
                          float _2417 = ((_2400 - _2326) * 0.9030900001525879f) / ((_2408 - _2326) * 0.3010300099849701f);
                          int _2418 = int(_2417);
                          float _2420 = _2417 - float((int)(_2418));
                          float _2422 = _10[_2418];
                          float _2425 = _10[(_2418 + 1)];
                          float _2430 = _2422 * 0.5f;
                          _2470 = dot(float3((_2420 * _2420), _2420, 1.0f), float3(mad((_10[(_2418 + 2)]), 0.5f, mad(_2425, -1.0f, _2430)), (_2425 - _2422), mad(_2425, 0.5f, _2430)));
                        } else {
                          do {
                            if (!(!(_2401 >= _2409))) {
                              float _2439 = log2(cb0_008z);
                              if (_2401 < (_2439 * 0.3010300099849701f)) {
                                float _2447 = ((_2400 - _2408) * 0.9030900001525879f) / ((_2439 - _2408) * 0.3010300099849701f);
                                int _2448 = int(_2447);
                                float _2450 = _2447 - float((int)(_2448));
                                float _2452 = _11[_2448];
                                float _2455 = _11[(_2448 + 1)];
                                float _2460 = _2452 * 0.5f;
                                _2470 = dot(float3((_2450 * _2450), _2450, 1.0f), float3(mad((_11[(_2448 + 2)]), 0.5f, mad(_2455, -1.0f, _2460)), (_2455 - _2452), mad(_2455, 0.5f, _2460)));
                                break;
                              }
                            }
                            _2470 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2474 = log2(max((lerp(_2313, _2312, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2475 = _2474 * 0.3010300099849701f;
                      do {
                        if (!(!(_2475 <= _2327))) {
                          _2544 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2482 = log2(cb0_009x);
                          float _2483 = _2482 * 0.3010300099849701f;
                          if ((bool)(_2475 > _2327) && (bool)(_2475 < _2483)) {
                            float _2491 = ((_2474 - _2326) * 0.9030900001525879f) / ((_2482 - _2326) * 0.3010300099849701f);
                            int _2492 = int(_2491);
                            float _2494 = _2491 - float((int)(_2492));
                            float _2496 = _10[_2492];
                            float _2499 = _10[(_2492 + 1)];
                            float _2504 = _2496 * 0.5f;
                            _2544 = dot(float3((_2494 * _2494), _2494, 1.0f), float3(mad((_10[(_2492 + 2)]), 0.5f, mad(_2499, -1.0f, _2504)), (_2499 - _2496), mad(_2499, 0.5f, _2504)));
                          } else {
                            do {
                              if (!(!(_2475 >= _2483))) {
                                float _2513 = log2(cb0_008z);
                                if (_2475 < (_2513 * 0.3010300099849701f)) {
                                  float _2521 = ((_2474 - _2482) * 0.9030900001525879f) / ((_2513 - _2482) * 0.3010300099849701f);
                                  int _2522 = int(_2521);
                                  float _2524 = _2521 - float((int)(_2522));
                                  float _2526 = _11[_2522];
                                  float _2529 = _11[(_2522 + 1)];
                                  float _2534 = _2526 * 0.5f;
                                  _2544 = dot(float3((_2524 * _2524), _2524, 1.0f), float3(mad((_11[(_2522 + 2)]), 0.5f, mad(_2529, -1.0f, _2534)), (_2529 - _2526), mad(_2529, 0.5f, _2534)));
                                  break;
                                }
                              }
                              _2544 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2548 = cb0_008w - cb0_008y;
                        float _2549 = (exp2(_2396 * 3.321928024291992f) - cb0_008y) / _2548;
                        float _2551 = (exp2(_2470 * 3.321928024291992f) - cb0_008y) / _2548;
                        float _2553 = (exp2(_2544 * 3.321928024291992f) - cb0_008y) / _2548;
                        float _2556 = mad(0.15618768334388733f, _2553, mad(0.13400420546531677f, _2551, (_2549 * 0.6624541878700256f)));
                        float _2559 = mad(0.053689517080783844f, _2553, mad(0.6740817427635193f, _2551, (_2549 * 0.2722287178039551f)));
                        float _2562 = mad(1.0103391408920288f, _2553, mad(0.00406073359772563f, _2551, (_2549 * -0.005574649665504694f)));
                        float _2575 = min(max(mad(-0.23642469942569733f, _2562, mad(-0.32480329275131226f, _2559, (_2556 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2576 = min(max(mad(0.016756348311901093f, _2562, mad(1.6153316497802734f, _2559, (_2556 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2577 = min(max(mad(0.9883948564529419f, _2562, mad(-0.008284442126750946f, _2559, (_2556 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2580 = mad(0.15618768334388733f, _2577, mad(0.13400420546531677f, _2576, (_2575 * 0.6624541878700256f)));
                        float _2583 = mad(0.053689517080783844f, _2577, mad(0.6740817427635193f, _2576, (_2575 * 0.2722287178039551f)));
                        float _2586 = mad(1.0103391408920288f, _2577, mad(0.00406073359772563f, _2576, (_2575 * -0.005574649665504694f)));
                        float _2608 = min(max((min(max(mad(-0.23642469942569733f, _2586, mad(-0.32480329275131226f, _2583, (_2580 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2609 = min(max((min(max(mad(0.016756348311901093f, _2586, mad(1.6153316497802734f, _2583, (_2580 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2610 = min(max((min(max(mad(0.9883948564529419f, _2586, mad(-0.008284442126750946f, _2583, (_2580 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 6)) {
                            _2623 = mad(_41, _2610, mad(_40, _2609, (_2608 * _39)));
                            _2624 = mad(_44, _2610, mad(_43, _2609, (_2608 * _42)));
                            _2625 = mad(_47, _2610, mad(_46, _2609, (_2608 * _45)));
                          } else {
                            _2623 = _2608;
                            _2624 = _2609;
                            _2625 = _2610;
                          }
                          float _2635 = exp2(log2(_2623 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2636 = exp2(log2(_2624 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2637 = exp2(log2(_2625 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2802 = exp2(log2((1.0f / ((_2635 * 18.6875f) + 1.0f)) * ((_2635 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2803 = exp2(log2((1.0f / ((_2636 * 18.6875f) + 1.0f)) * ((_2636 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2804 = exp2(log2((1.0f / ((_2637 * 18.6875f) + 1.0f)) * ((_2637 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (cb0_040w == 7) {
            float _2682 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1364, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1363, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1362)));
            float _2685 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1364, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1363, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1362)));
            float _2688 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1364, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1363, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1362)));
            float _2707 = exp2(log2(mad(_41, _2688, mad(_40, _2685, (_2682 * _39))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2708 = exp2(log2(mad(_44, _2688, mad(_43, _2685, (_2682 * _42))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2709 = exp2(log2(mad(_47, _2688, mad(_46, _2685, (_2682 * _45))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2802 = exp2(log2((1.0f / ((_2707 * 18.6875f) + 1.0f)) * ((_2707 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2803 = exp2(log2((1.0f / ((_2708 * 18.6875f) + 1.0f)) * ((_2708 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2804 = exp2(log2((1.0f / ((_2709 * 18.6875f) + 1.0f)) * ((_2709 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2756 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1352, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1351, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1350)));
                float _2759 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1352, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1351, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1350)));
                float _2762 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1352, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1351, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1350)));
                _2802 = mad(_41, _2762, mad(_40, _2759, (_2756 * _39)));
                _2803 = mad(_44, _2762, mad(_43, _2759, (_2756 * _42)));
                _2804 = mad(_47, _2762, mad(_46, _2759, (_2756 * _45)));
              } else {
                float _2775 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1376)));
                float _2778 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1376)));
                float _2781 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1378, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1377, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1376)));
                _2802 = exp2(log2(mad(_41, _2781, mad(_40, _2778, (_2775 * _39)))) * cb0_040z);
                _2803 = exp2(log2(mad(_44, _2781, mad(_43, _2778, (_2775 * _42)))) * cb0_040z);
                _2804 = exp2(log2(mad(_47, _2781, mad(_46, _2778, (_2775 * _45)))) * cb0_040z);
              }
            } else {
              _2802 = _1362;
              _2803 = _1363;
              _2804 = _1364;
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2802 * 0.9523810148239136f);
  SV_Target.y = (_2803 * 0.9523810148239136f);
  SV_Target.z = (_2804 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
