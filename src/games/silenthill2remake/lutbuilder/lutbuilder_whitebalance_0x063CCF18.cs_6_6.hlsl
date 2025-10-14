#include "./filmiclutbuilder.hlsli"

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _9[6];
  float _10[6];
  float _11[6];
  float _12[6];
  float _22 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _23 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _26 = float((uint)SV_DispatchThreadID.z);
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _52;
  float _53;
  float _54;
  float _55;
  float _113;
  float _114;
  float _115;
  float _164;
  float _893;
  float _929;
  float _940;
  float _1004;
  float _1272;
  float _1273;
  float _1274;
  float _1285;
  float _1296;
  float _1478;
  float _1514;
  float _1525;
  float _1564;
  float _1674;
  float _1748;
  float _1822;
  float _1901;
  float _1902;
  float _1903;
  float _2054;
  float _2090;
  float _2101;
  float _2140;
  float _2250;
  float _2324;
  float _2398;
  float _2477;
  float _2478;
  float _2479;
  float _2656;
  float _2657;
  float _2658;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _36 = (output_gamut == 4);
        _47 = select(_36, 1.0f, 1.7050515413284302f);
        _48 = select(_36, 0.0f, -0.6217905879020691f);
        _49 = select(_36, 0.0f, -0.0832584798336029f);
        _50 = select(_36, 0.0f, -0.13025718927383423f);
        _51 = select(_36, 1.0f, 1.1408027410507202f);
        _52 = select(_36, 0.0f, -0.010548528283834457f);
        _53 = select(_36, 0.0f, -0.024003278464078903f);
        _54 = select(_36, 0.0f, -0.1289687603712082f);
        _55 = select(_36, 1.0f, 1.152971863746643f);
      } else {
        _47 = 0.6954522132873535f;
        _48 = 0.14067870378494263f;
        _49 = 0.16386906802654266f;
        _50 = 0.044794563204050064f;
        _51 = 0.8596711158752441f;
        _52 = 0.0955343171954155f;
        _53 = -0.005525882821530104f;
        _54 = 0.004025210160762072f;
        _55 = 1.0015007257461548f;
      }
    } else {
      _47 = 1.02579927444458f;
      _48 = -0.020052503794431686f;
      _49 = -0.0057713985443115234f;
      _50 = -0.0022350111976265907f;
      _51 = 1.0045825242996216f;
      _52 = -0.002352306619286537f;
      _53 = -0.005014004185795784f;
      _54 = -0.025293385609984398f;
      _55 = 1.0304402112960815f;
    }
  } else {
    _47 = 1.379158854484558f;
    _48 = -0.3088507056236267f;
    _49 = -0.07034677267074585f;
    _50 = -0.06933528929948807f;
    _51 = 1.0822921991348267f;
    _52 = -0.012962047010660172f;
    _53 = -0.002159259282052517f;
    _54 = -0.045465391129255295f;
    _55 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _66 = exp2(log2(_22 * 1.0322580337524414f) * 0.012683313339948654f);
    float _67 = exp2(log2(_23 * 1.0322580337524414f) * 0.012683313339948654f);
    float _68 = exp2(log2(_26 * 0.032258063554763794f) * 0.012683313339948654f);
    _113 = (exp2(log2(max(0.0f, (_66 + -0.8359375f)) / (18.8515625f - (_66 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _114 = (exp2(log2(max(0.0f, (_67 + -0.8359375f)) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _115 = (exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _113 = ((exp2((_22 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _114 = ((exp2((_23 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _115 = ((exp2((_26 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  bool _142 = (cb0_038z != 0);
  float _147 = 0.9994439482688904f / cb0_035x;
  if (!(!((cb0_035x * 1.0005563497543335f) <= 7000.0f))) {
    _164 = (((((2967800.0f - (_147 * 4607000064.0f)) * _147) + 99.11000061035156f) * _147) + 0.24406300485134125f);
  } else {
    _164 = (((((1901800.0f - (_147 * 2006400000.0f)) * _147) + 247.47999572753906f) * _147) + 0.23703999817371368f);
  }
  float _178 = ((((cb0_035x * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035x) + 0.8601177334785461f) / ((((cb0_035x * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035x) + 1.0f);
  float _185 = cb0_035x * cb0_035x;
  float _188 = ((((cb0_035x * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035x) + 0.31739872694015503f) / ((1.0f - (cb0_035x * 2.8974181986995973e-05f)) + (_185 * 1.6145605741257896e-07f));
  float _193 = ((_178 * 2.0f) + 4.0f) - (_188 * 8.0f);
  float _194 = (_178 * 3.0f) / _193;
  float _196 = (_188 * 2.0f) / _193;
  bool _197 = (cb0_035x < 4000.0f);
  float _206 = ((cb0_035x + 1189.6199951171875f) * cb0_035x) + 1412139.875f;
  float _208 = ((-1137581184.0f - (cb0_035x * 1916156.25f)) - (_185 * 1.5317699909210205f)) / (_206 * _206);
  float _215 = (6193636.0f - (cb0_035x * 179.45599365234375f)) + _185;
  float _217 = ((1974715392.0f - (cb0_035x * 705674.0f)) - (_185 * 308.60699462890625f)) / (_215 * _215);
  float _219 = rsqrt(dot(float2(_208, _217), float2(_208, _217)));
  float _220 = cb0_035y * 0.05000000074505806f;
  float _223 = ((_220 * _217) * _219) + _178;
  float _226 = _188 - ((_220 * _208) * _219);
  float _231 = (4.0f - (_226 * 8.0f)) + (_223 * 2.0f);
  float _237 = (((_223 * 3.0f) / _231) - _194) + select(_197, _194, _164);
  float _238 = (((_226 * 2.0f) / _231) - _196) + select(_197, _196, (((_164 * 2.869999885559082f) + -0.2750000059604645f) - ((_164 * _164) * 3.0f)));
  float _239 = select(_142, _237, 0.3127000033855438f);
  float _240 = select(_142, _238, 0.32899999618530273f);
  float _241 = select(_142, 0.3127000033855438f, _237);
  float _242 = select(_142, 0.32899999618530273f, _238);
  float _243 = max(_240, 1.000000013351432e-10f);
  float _244 = _239 / _243;
  float _247 = ((1.0f - _239) - _240) / _243;
  float _248 = max(_242, 1.000000013351432e-10f);
  float _249 = _241 / _248;
  float _252 = ((1.0f - _241) - _242) / _248;
  float _271 = mad(-0.16140000522136688f, _252, ((_249 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _247, ((_244 * 0.8950999975204468f) + 0.266400009393692f));
  float _272 = mad(0.03669999912381172f, _252, (1.7135000228881836f - (_249 * 0.7501999735832214f))) / mad(0.03669999912381172f, _247, (1.7135000228881836f - (_244 * 0.7501999735832214f)));
  float _273 = mad(1.0296000242233276f, _252, ((_249 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _247, ((_244 * 0.03889999911189079f) + -0.06849999725818634f));
  float _274 = mad(_272, -0.7501999735832214f, 0.0f);
  float _275 = mad(_272, 1.7135000228881836f, 0.0f);
  float _276 = mad(_272, 0.03669999912381172f, -0.0f);
  float _277 = mad(_273, 0.03889999911189079f, 0.0f);
  float _278 = mad(_273, -0.06849999725818634f, 0.0f);
  float _279 = mad(_273, 1.0296000242233276f, 0.0f);
  float _282 = mad(0.1599626988172531f, _277, mad(-0.1470542997121811f, _274, (_271 * 0.883457362651825f)));
  float _285 = mad(0.1599626988172531f, _278, mad(-0.1470542997121811f, _275, (_271 * 0.26293492317199707f)));
  float _288 = mad(0.1599626988172531f, _279, mad(-0.1470542997121811f, _276, (_271 * -0.15930065512657166f)));
  float _291 = mad(0.04929120093584061f, _277, mad(0.5183603167533875f, _274, (_271 * 0.38695648312568665f)));
  float _294 = mad(0.04929120093584061f, _278, mad(0.5183603167533875f, _275, (_271 * 0.11516613513231277f)));
  float _297 = mad(0.04929120093584061f, _279, mad(0.5183603167533875f, _276, (_271 * -0.0697740763425827f)));
  float _300 = mad(0.9684867262840271f, _277, mad(0.04004279896616936f, _274, (_271 * -0.007634039502590895f)));
  float _303 = mad(0.9684867262840271f, _278, mad(0.04004279896616936f, _275, (_271 * -0.0022720457054674625f)));
  float _306 = mad(0.9684867262840271f, _279, mad(0.04004279896616936f, _276, (_271 * 0.0013765322510153055f)));
  float _309 = mad(_288, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_285, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_282 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _312 = mad(_288, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_285, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_282 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _315 = mad(_288, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_285, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_282 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _318 = mad(_297, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_294, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_291 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _321 = mad(_297, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_294, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_291 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _324 = mad(_297, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_294, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_291 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _327 = mad(_306, (UniformBufferConstants_WorkingColorSpace_000[2].x), mad(_303, (UniformBufferConstants_WorkingColorSpace_000[1].x), (_300 * (UniformBufferConstants_WorkingColorSpace_000[0].x))));
  float _330 = mad(_306, (UniformBufferConstants_WorkingColorSpace_000[2].y), mad(_303, (UniformBufferConstants_WorkingColorSpace_000[1].y), (_300 * (UniformBufferConstants_WorkingColorSpace_000[0].y))));
  float _333 = mad(_306, (UniformBufferConstants_WorkingColorSpace_000[2].z), mad(_303, (UniformBufferConstants_WorkingColorSpace_000[1].z), (_300 * (UniformBufferConstants_WorkingColorSpace_000[0].z))));
  float _363 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _333, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _324, (_315 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _115, mad(mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _330, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _321, (_312 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))), _114, (mad((UniformBufferConstants_WorkingColorSpace_064[0].z), _327, mad((UniformBufferConstants_WorkingColorSpace_064[0].y), _318, (_309 * (UniformBufferConstants_WorkingColorSpace_064[0].x)))) * _113)));
  float _366 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _333, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _324, (_315 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _115, mad(mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _330, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _321, (_312 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))), _114, (mad((UniformBufferConstants_WorkingColorSpace_064[1].z), _327, mad((UniformBufferConstants_WorkingColorSpace_064[1].y), _318, (_309 * (UniformBufferConstants_WorkingColorSpace_064[1].x)))) * _113)));
  float _369 = mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _333, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _324, (_315 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _115, mad(mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _330, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _321, (_312 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))), _114, (mad((UniformBufferConstants_WorkingColorSpace_064[2].z), _327, mad((UniformBufferConstants_WorkingColorSpace_064[2].y), _318, (_309 * (UniformBufferConstants_WorkingColorSpace_064[2].x)))) * _113)));
  float _384 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _369, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _366, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _363)));
  float _387 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _369, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _366, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _363)));
  float _390 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _369, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _366, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _363)));
  float _391 = dot(float3(_384, _387, _390), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _395 = (_384 / _391) + -1.0f;
  float _396 = (_387 / _391) + -1.0f;
  float _397 = (_390 / _391) + -1.0f;
  float _409 = (1.0f - exp2(((_391 * _391) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_395, _396, _397), float3(_395, _396, _397)) * -4.0f));
  float _425 = ((mad(-0.06368283927440643f, _390, mad(-0.32929131388664246f, _387, (_384 * 1.370412826538086f))) - _384) * _409) + _384;
  float _426 = ((mad(-0.010861567221581936f, _390, mad(1.0970908403396606f, _387, (_384 * -0.08343426138162613f))) - _387) * _409) + _387;
  float _427 = ((mad(1.203694462776184f, _390, mad(-0.09862564504146576f, _387, (_384 * -0.02579325996339321f))) - _390) * _409) + _390;

#if 1
  float _793;
  float _795;
  float _797;
  ApplyColorCorrection(
      _425, _426, _427,
      _793, _795, _797,
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
  float _428 = dot(float3(_425, _426, _427), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _442 = cb0_019w + cb0_024w;
  float _456 = cb0_018w * cb0_023w;
  float _470 = cb0_017w * cb0_022w;
  float _484 = cb0_016w * cb0_021w;
  float _498 = cb0_015w * cb0_020w;
  float _502 = _425 - _428;
  float _503 = _426 - _428;
  float _504 = _427 - _428;
  float _561 = saturate(_428 / cb0_035z);
  float _565 = (_561 * _561) * (3.0f - (_561 * 2.0f));
  float _566 = 1.0f - _565;
  float _575 = cb0_019w + cb0_034w;
  float _584 = cb0_018w * cb0_033w;
  float _593 = cb0_017w * cb0_032w;
  float _602 = cb0_016w * cb0_031w;
  float _611 = cb0_015w * cb0_030w;
  float _675 = saturate((_428 - cb0_035w) / (cb0_036x - cb0_035w));
  float _679 = (_675 * _675) * (3.0f - (_675 * 2.0f));
  float _688 = cb0_019w + cb0_029w;
  float _697 = cb0_018w * cb0_028w;
  float _706 = cb0_017w * cb0_027w;
  float _715 = cb0_016w * cb0_026w;
  float _724 = cb0_015w * cb0_025w;
  float _782 = _565 - _679;
  float _793 = ((_679 * (((cb0_019x + cb0_034x) + _575) + (((cb0_018x * cb0_033x) * _584) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _602) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _611) * _502) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _593)))))) + (_566 * (((cb0_019x + cb0_024x) + _442) + (((cb0_018x * cb0_023x) * _456) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _484) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _498) * _502) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _470))))))) + ((((cb0_019x + cb0_029x) + _688) + (((cb0_018x * cb0_028x) * _697) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _715) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _724) * _502) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _706))))) * _782);
  float _795 = ((_679 * (((cb0_019y + cb0_034y) + _575) + (((cb0_018y * cb0_033y) * _584) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _602) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _611) * _503) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _593)))))) + (_566 * (((cb0_019y + cb0_024y) + _442) + (((cb0_018y * cb0_023y) * _456) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _484) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _498) * _503) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _470))))))) + ((((cb0_019y + cb0_029y) + _688) + (((cb0_018y * cb0_028y) * _697) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _715) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _724) * _503) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _706))))) * _782);
  float _797 = ((_679 * (((cb0_019z + cb0_034z) + _575) + (((cb0_018z * cb0_033z) * _584) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _602) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _611) * _504) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _593)))))) + (_566 * (((cb0_019z + cb0_024z) + _442) + (((cb0_018z * cb0_023z) * _456) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _484) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _498) * _504) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _470))))))) + ((((cb0_019z + cb0_029z) + _688) + (((cb0_018z * cb0_028z) * _697) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _715) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _724) * _504) + _428)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _706))))) * _782);
#endif
  float _833 = ((mad(0.061360642313957214f, _797, mad(-4.540197551250458e-09f, _795, (_793 * 0.9386394023895264f))) - _793) * cb0_036y) + _793;
  float _834 = ((mad(0.169205904006958f, _797, mad(0.8307942152023315f, _795, (_793 * 6.775371730327606e-08f))) - _795) * cb0_036y) + _795;
  float _835 = (mad(-2.3283064365386963e-10f, _795, (_793 * -9.313225746154785e-10f)) * cb0_036y) + _797;
  float _838 = mad(0.16386905312538147f, _835, mad(0.14067868888378143f, _834, (_833 * 0.6954522132873535f)));
  float _841 = mad(0.0955343246459961f, _835, mad(0.8596711158752441f, _834, (_833 * 0.044794581830501556f)));
  float _844 = mad(1.0015007257461548f, _835, mad(0.004025210160762072f, _834, (_833 * -0.005525882821530104f)));
  float _848 = max(max(_838, _841), _844);
  float _853 = (max(_848, 1.000000013351432e-10f) - max(min(min(_838, _841), _844), 1.000000013351432e-10f)) / max(_848, 0.009999999776482582f);
  float _866 = ((_841 + _838) + _844) + (sqrt((((_844 - _841) * _844) + ((_841 - _838) * _841)) + ((_838 - _844) * _838)) * 1.75f);
  float _867 = _866 * 0.3333333432674408f;
  float _868 = _853 + -0.4000000059604645f;
  float _869 = _868 * 5.0f;
  float _873 = max((1.0f - abs(_868 * 2.5f)), 0.0f);
  float _884 = ((float((int)(((int)(uint)((bool)(_869 > 0.0f))) - ((int)(uint)((bool)(_869 < 0.0f))))) * (1.0f - (_873 * _873))) + 1.0f) * 0.02500000037252903f;
  if (!(_867 <= 0.0533333346247673f)) {
    if (!(_867 >= 0.1599999964237213f)) {
      _893 = (((0.23999999463558197f / _866) + -0.5f) * _884);
    } else {
      _893 = 0.0f;
    }
  } else {
    _893 = _884;
  }
  float _894 = _893 + 1.0f;
  float _895 = _894 * _838;
  float _896 = _894 * _841;
  float _897 = _894 * _844;
  if (!((bool)(_895 == _896) && (bool)(_896 == _897))) {
    float _904 = ((_895 * 2.0f) - _896) - _897;
    float _907 = ((_841 - _844) * 1.7320507764816284f) * _894;
    float _909 = atan(_907 / _904);
    bool _912 = (_904 < 0.0f);
    bool _913 = (_904 == 0.0f);
    bool _914 = (_907 >= 0.0f);
    bool _915 = (_907 < 0.0f);
    float _924 = select((_914 && _913), 90.0f, select((_915 && _913), -90.0f, (select((_915 && _912), (_909 + -3.1415927410125732f), select((_914 && _912), (_909 + 3.1415927410125732f), _909)) * 57.2957763671875f)));
    if (_924 < 0.0f) {
      _929 = (_924 + 360.0f);
    } else {
      _929 = _924;
    }
  } else {
    _929 = 0.0f;
  }
  float _931 = min(max(_929, 0.0f), 360.0f);
  if (_931 < -180.0f) {
    _940 = (_931 + 360.0f);
  } else {
    if (_931 > 180.0f) {
      _940 = (_931 + -360.0f);
    } else {
      _940 = _931;
    }
  }
  float _944 = saturate(1.0f - abs(_940 * 0.014814814552664757f));
  float _948 = (_944 * _944) * (3.0f - (_944 * 2.0f));
  float _954 = ((_948 * _948) * ((_853 * 0.18000000715255737f) * (0.029999999329447746f - _895))) + _895;
  float _964 = max(0.0f, mad(-0.21492856740951538f, _897, mad(-0.2365107536315918f, _896, (_954 * 1.4514392614364624f))));
  float _965 = max(0.0f, mad(-0.09967592358589172f, _897, mad(1.17622971534729f, _896, (_954 * -0.07655377686023712f))));
  float _966 = max(0.0f, mad(0.9977163076400757f, _897, mad(-0.006032449658960104f, _896, (_954 * 0.008316148072481155f))));
  float _967 = dot(float3(_964, _965, _966), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1013 = (lerp(_967, _964, 0.9599999785423279f));
  float _1014 = (lerp(_967, _965, 0.9599999785423279f));
  float _1015 = (lerp(_967, _966, 0.9599999785423279f));

#if 1
  float _1155, _1156, _1157;
  ApplyFilmicToneMap(_1013, _1014, _1015,
                     _833, _834, _835,
                     _1155, _1156, _1157);
#else
  float _1013 = log2(_1013) * 0.3010300099849701f;
  float _1014 = log2(_1014) * 0.3010300099849701f;
  float _1015 = log2(_1015) * 0.3010300099849701f;

  float _981 = (cb0_037w + 1.0f) - cb0_037y;
  float _984 = cb0_038x + 1.0f;
  float _986 = _984 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _1004 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _995 = (cb0_037w + 0.18000000715255737f) / _981;
    _1004 = (-0.7447274923324585f - ((log2(_995 / (2.0f - _995)) * 0.3465735912322998f) * (_981 / cb0_037x)));
  }
  float _1007 = ((1.0f - cb0_037y) / cb0_037x) - _1004;
  float _1009 = (cb0_037z / cb0_037x) - _1007;
  float _1019 = cb0_037x * (_1013 + _1007);
  float _1020 = cb0_037x * (_1014 + _1007);
  float _1021 = cb0_037x * (_1015 + _1007);
  float _1022 = _981 * 2.0f;
  float _1024 = (cb0_037x * -2.0f) / _981;
  float _1025 = _1013 - _1004;
  float _1026 = _1014 - _1004;
  float _1027 = _1015 - _1004;
  float _1046 = _986 * 2.0f;
  float _1048 = (cb0_037x * 2.0f) / _986;
  float _1073 = select((_1013 < _1004), ((_1022 / (exp2((_1025 * 1.4426950216293335f) * _1024) + 1.0f)) - cb0_037w), _1019);
  float _1074 = select((_1014 < _1004), ((_1022 / (exp2((_1026 * 1.4426950216293335f) * _1024) + 1.0f)) - cb0_037w), _1020);
  float _1075 = select((_1015 < _1004), ((_1022 / (exp2((_1027 * 1.4426950216293335f) * _1024) + 1.0f)) - cb0_037w), _1021);
  float _1082 = _1009 - _1004;
  float _1086 = saturate(_1025 / _1082);
  float _1087 = saturate(_1026 / _1082);
  float _1088 = saturate(_1027 / _1082);
  bool _1089 = (_1009 < _1004);
  float _1093 = select(_1089, (1.0f - _1086), _1086);
  float _1094 = select(_1089, (1.0f - _1087), _1087);
  float _1095 = select(_1089, (1.0f - _1088), _1088);
  float _1114 = (((_1093 * _1093) * (select((_1013 > _1009), (_984 - (_1046 / (exp2(((_1013 - _1009) * 1.4426950216293335f) * _1048) + 1.0f))), _1019) - _1073)) * (3.0f - (_1093 * 2.0f))) + _1073;
  float _1115 = (((_1094 * _1094) * (select((_1014 > _1009), (_984 - (_1046 / (exp2(((_1014 - _1009) * 1.4426950216293335f) * _1048) + 1.0f))), _1020) - _1074)) * (3.0f - (_1094 * 2.0f))) + _1074;
  float _1116 = (((_1095 * _1095) * (select((_1015 > _1009), (_984 - (_1046 / (exp2(((_1015 - _1009) * 1.4426950216293335f) * _1048) + 1.0f))), _1021) - _1075)) * (3.0f - (_1095 * 2.0f))) + _1075;
  float _1117 = dot(float3(_1114, _1115, _1116), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1137 = (cb0_036w * (max(0.0f, (lerp(_1117, _1114, 0.9300000071525574f))) - _833)) + _833;
  float _1138 = (cb0_036w * (max(0.0f, (lerp(_1117, _1115, 0.9300000071525574f))) - _834)) + _834;
  float _1139 = (cb0_036w * (max(0.0f, (lerp(_1117, _1116, 0.9300000071525574f))) - _835)) + _835;
  float _1155 = ((mad(-0.06537103652954102f, _1139, mad(1.451815478503704e-06f, _1138, (_1137 * 1.065374732017517f))) - _1137) * cb0_036y) + _1137;
  float _1156 = ((mad(-0.20366770029067993f, _1139, mad(1.2036634683609009f, _1138, (_1137 * -2.57161445915699e-07f))) - _1138) * cb0_036y) + _1138;
  float _1157 = ((mad(0.9999996423721313f, _1139, mad(2.0954757928848267e-08f, _1138, (_1137 * 1.862645149230957e-08f))) - _1139) * cb0_036y) + _1139;
#endif
  float _1167 = (mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _1157, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _1156, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _1155))));
  float _1168 = (mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _1157, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _1156, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _1155))));
  float _1169 = (mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _1157, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _1156, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _1155))));
  float _1195 = cb0_014x * (((cb0_039y + (cb0_039x * _1167)) * _1167) + cb0_039z);
  float _1196 = cb0_014y * (((cb0_039y + (cb0_039x * _1168)) * _1168) + cb0_039z);
  float _1197 = cb0_014z * (((cb0_039y + (cb0_039x * _1169)) * _1169) + cb0_039z);
  float _1204 = ((cb0_013x - _1195) * cb0_013w) + _1195;
  float _1205 = ((cb0_013y - _1196) * cb0_013w) + _1196;
  float _1206 = ((cb0_013z - _1197) * cb0_013w) + _1197;

  if (GenerateOutput(_1204, _1205, _1206, u0[SV_DispatchThreadID])) {
    return;
  }

  float _1207 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _797, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _795, (_793 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1208 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _797, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _795, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _793)));
  float _1209 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _797, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _795, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _793)));
  float _1216 = ((cb0_013x - _1207) * cb0_013w) + _1207;
  float _1217 = ((cb0_013y - _1208) * cb0_013w) + _1208;
  float _1218 = ((cb0_013z - _1209) * cb0_013w) + _1209;
  float _1230 = exp2(log2(max(0.0f, _1204)) * cb0_040y);
  float _1231 = exp2(log2(max(0.0f, _1205)) * cb0_040y);
  float _1232 = exp2(log2(max(0.0f, _1206)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1255 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1230)));
        float _1258 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1230)));
        float _1261 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1230)));
        _1272 = mad(_49, _1261, mad(_48, _1258, (_1255 * _47)));
        _1273 = mad(_52, _1261, mad(_51, _1258, (_1255 * _50)));
        _1274 = mad(_55, _1261, mad(_54, _1258, (_1255 * _53)));
      } else {
        _1272 = _1230;
        _1273 = _1231;
        _1274 = _1232;
      }
      do {
        if (_1272 < 0.0031306699384003878f) {
          _1285 = (_1272 * 12.920000076293945f);
        } else {
          _1285 = (((pow(_1272, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1273 < 0.0031306699384003878f) {
            _1296 = (_1273 * 12.920000076293945f);
          } else {
            _1296 = (((pow(_1273, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1274 < 0.0031306699384003878f) {
            _2656 = _1285;
            _2657 = _1296;
            _2658 = (_1274 * 12.920000076293945f);
          } else {
            _2656 = _1285;
            _2657 = _1296;
            _2658 = (((pow(_1274, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1323 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1230)));
      float _1326 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1230)));
      float _1329 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1230)));
      float _1339 = max(6.103519990574569e-05f, mad(_49, _1329, mad(_48, _1326, (_1323 * _47))));
      float _1340 = max(6.103519990574569e-05f, mad(_52, _1329, mad(_51, _1326, (_1323 * _50))));
      float _1341 = max(6.103519990574569e-05f, mad(_55, _1329, mad(_54, _1326, (_1323 * _53))));
      _2656 = min((_1339 * 4.5f), ((exp2(log2(max(_1339, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2657 = min((_1340 * 4.5f), ((exp2(log2(max(_1340, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2658 = min((_1341 * 4.5f), ((exp2(log2(max(_1341, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1418 = cb0_012z * _1216;
        float _1419 = cb0_012z * _1217;
        float _1420 = cb0_012z * _1218;
        float _1423 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1420, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1419, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1418)));
        float _1426 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1420, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1419, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1418)));
        float _1429 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1420, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1419, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1418)));
        float _1433 = max(max(_1423, _1426), _1429);
        float _1438 = (max(_1433, 1.000000013351432e-10f) - max(min(min(_1423, _1426), _1429), 1.000000013351432e-10f)) / max(_1433, 0.009999999776482582f);
        float _1451 = ((_1426 + _1423) + _1429) + (sqrt((((_1429 - _1426) * _1429) + ((_1426 - _1423) * _1426)) + ((_1423 - _1429) * _1423)) * 1.75f);
        float _1452 = _1451 * 0.3333333432674408f;
        float _1453 = _1438 + -0.4000000059604645f;
        float _1454 = _1453 * 5.0f;
        float _1458 = max((1.0f - abs(_1453 * 2.5f)), 0.0f);
        float _1469 = ((float((int)(((int)(uint)((bool)(_1454 > 0.0f))) - ((int)(uint)((bool)(_1454 < 0.0f))))) * (1.0f - (_1458 * _1458))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1452 <= 0.0533333346247673f)) {
            if (!(_1452 >= 0.1599999964237213f)) {
              _1478 = (((0.23999999463558197f / _1451) + -0.5f) * _1469);
            } else {
              _1478 = 0.0f;
            }
          } else {
            _1478 = _1469;
          }
          float _1479 = _1478 + 1.0f;
          float _1480 = _1479 * _1423;
          float _1481 = _1479 * _1426;
          float _1482 = _1479 * _1429;
          do {
            if (!((bool)(_1480 == _1481) && (bool)(_1481 == _1482))) {
              float _1489 = ((_1480 * 2.0f) - _1481) - _1482;
              float _1492 = ((_1426 - _1429) * 1.7320507764816284f) * _1479;
              float _1494 = atan(_1492 / _1489);
              bool _1497 = (_1489 < 0.0f);
              bool _1498 = (_1489 == 0.0f);
              bool _1499 = (_1492 >= 0.0f);
              bool _1500 = (_1492 < 0.0f);
              float _1509 = select((_1499 && _1498), 90.0f, select((_1500 && _1498), -90.0f, (select((_1500 && _1497), (_1494 + -3.1415927410125732f), select((_1499 && _1497), (_1494 + 3.1415927410125732f), _1494)) * 57.2957763671875f)));
              if (_1509 < 0.0f) {
                _1514 = (_1509 + 360.0f);
              } else {
                _1514 = _1509;
              }
            } else {
              _1514 = 0.0f;
            }
            float _1516 = min(max(_1514, 0.0f), 360.0f);
            do {
              if (_1516 < -180.0f) {
                _1525 = (_1516 + 360.0f);
              } else {
                if (_1516 > 180.0f) {
                  _1525 = (_1516 + -360.0f);
                } else {
                  _1525 = _1516;
                }
              }
              do {
                if ((bool)(_1525 > -67.5f) && (bool)(_1525 < 67.5f)) {
                  float _1531 = (_1525 + 67.5f) * 0.029629629105329514f;
                  int _1532 = int(_1531);
                  float _1534 = _1531 - float((int)(_1532));
                  float _1535 = _1534 * _1534;
                  float _1536 = _1535 * _1534;
                  if (_1532 == 3) {
                    _1564 = (((0.1666666716337204f - (_1534 * 0.5f)) + (_1535 * 0.5f)) - (_1536 * 0.1666666716337204f));
                  } else {
                    if (_1532 == 2) {
                      _1564 = ((0.6666666865348816f - _1535) + (_1536 * 0.5f));
                    } else {
                      if (_1532 == 1) {
                        _1564 = (((_1536 * -0.5f) + 0.1666666716337204f) + ((_1535 + _1534) * 0.5f));
                      } else {
                        _1564 = select((_1532 == 0), (_1536 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1564 = 0.0f;
                }
                float _1573 = min(max(((((_1438 * 0.27000001072883606f) * (0.029999999329447746f - _1480)) * _1564) + _1480), 0.0f), 65535.0f);
                float _1574 = min(max(_1481, 0.0f), 65535.0f);
                float _1575 = min(max(_1482, 0.0f), 65535.0f);
                float _1588 = min(max(mad(-0.21492856740951538f, _1575, mad(-0.2365107536315918f, _1574, (_1573 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1589 = min(max(mad(-0.09967592358589172f, _1575, mad(1.17622971534729f, _1574, (_1573 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1590 = min(max(mad(0.9977163076400757f, _1575, mad(-0.006032449658960104f, _1574, (_1573 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1591 = dot(float3(_1588, _1589, _1590), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1602 = log2(max((lerp(_1591, _1588, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1603 = _1602 * 0.3010300099849701f;
                float _1604 = log2(cb0_008x);
                float _1605 = _1604 * 0.3010300099849701f;
                do {
                  if (!(!(_1603 <= _1605))) {
                    _1674 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1612 = log2(cb0_009x);
                    float _1613 = _1612 * 0.3010300099849701f;
                    if ((bool)(_1603 > _1605) && (bool)(_1603 < _1613)) {
                      float _1621 = ((_1602 - _1604) * 0.9030900001525879f) / ((_1612 - _1604) * 0.3010300099849701f);
                      int _1622 = int(_1621);
                      float _1624 = _1621 - float((int)(_1622));
                      float _1626 = _11[_1622];
                      float _1629 = _11[(_1622 + 1)];
                      float _1634 = _1626 * 0.5f;
                      _1674 = dot(float3((_1624 * _1624), _1624, 1.0f), float3(mad((_11[(_1622 + 2)]), 0.5f, mad(_1629, -1.0f, _1634)), (_1629 - _1626), mad(_1629, 0.5f, _1634)));
                    } else {
                      do {
                        if (!(!(_1603 >= _1613))) {
                          float _1643 = log2(cb0_008z);
                          if (_1603 < (_1643 * 0.3010300099849701f)) {
                            float _1651 = ((_1602 - _1612) * 0.9030900001525879f) / ((_1643 - _1612) * 0.3010300099849701f);
                            int _1652 = int(_1651);
                            float _1654 = _1651 - float((int)(_1652));
                            float _1656 = _12[_1652];
                            float _1659 = _12[(_1652 + 1)];
                            float _1664 = _1656 * 0.5f;
                            _1674 = dot(float3((_1654 * _1654), _1654, 1.0f), float3(mad((_12[(_1652 + 2)]), 0.5f, mad(_1659, -1.0f, _1664)), (_1659 - _1656), mad(_1659, 0.5f, _1664)));
                            break;
                          }
                        }
                        _1674 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1678 = log2(max((lerp(_1591, _1589, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1679 = _1678 * 0.3010300099849701f;
                  do {
                    if (!(!(_1679 <= _1605))) {
                      _1748 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1686 = log2(cb0_009x);
                      float _1687 = _1686 * 0.3010300099849701f;
                      if ((bool)(_1679 > _1605) && (bool)(_1679 < _1687)) {
                        float _1695 = ((_1678 - _1604) * 0.9030900001525879f) / ((_1686 - _1604) * 0.3010300099849701f);
                        int _1696 = int(_1695);
                        float _1698 = _1695 - float((int)(_1696));
                        float _1700 = _11[_1696];
                        float _1703 = _11[(_1696 + 1)];
                        float _1708 = _1700 * 0.5f;
                        _1748 = dot(float3((_1698 * _1698), _1698, 1.0f), float3(mad((_11[(_1696 + 2)]), 0.5f, mad(_1703, -1.0f, _1708)), (_1703 - _1700), mad(_1703, 0.5f, _1708)));
                      } else {
                        do {
                          if (!(!(_1679 >= _1687))) {
                            float _1717 = log2(cb0_008z);
                            if (_1679 < (_1717 * 0.3010300099849701f)) {
                              float _1725 = ((_1678 - _1686) * 0.9030900001525879f) / ((_1717 - _1686) * 0.3010300099849701f);
                              int _1726 = int(_1725);
                              float _1728 = _1725 - float((int)(_1726));
                              float _1730 = _12[_1726];
                              float _1733 = _12[(_1726 + 1)];
                              float _1738 = _1730 * 0.5f;
                              _1748 = dot(float3((_1728 * _1728), _1728, 1.0f), float3(mad((_12[(_1726 + 2)]), 0.5f, mad(_1733, -1.0f, _1738)), (_1733 - _1730), mad(_1733, 0.5f, _1738)));
                              break;
                            }
                          }
                          _1748 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1752 = log2(max((lerp(_1591, _1590, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1753 = _1752 * 0.3010300099849701f;
                    do {
                      if (!(!(_1753 <= _1605))) {
                        _1822 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1760 = log2(cb0_009x);
                        float _1761 = _1760 * 0.3010300099849701f;
                        if ((bool)(_1753 > _1605) && (bool)(_1753 < _1761)) {
                          float _1769 = ((_1752 - _1604) * 0.9030900001525879f) / ((_1760 - _1604) * 0.3010300099849701f);
                          int _1770 = int(_1769);
                          float _1772 = _1769 - float((int)(_1770));
                          float _1774 = _11[_1770];
                          float _1777 = _11[(_1770 + 1)];
                          float _1782 = _1774 * 0.5f;
                          _1822 = dot(float3((_1772 * _1772), _1772, 1.0f), float3(mad((_11[(_1770 + 2)]), 0.5f, mad(_1777, -1.0f, _1782)), (_1777 - _1774), mad(_1777, 0.5f, _1782)));
                        } else {
                          do {
                            if (!(!(_1753 >= _1761))) {
                              float _1791 = log2(cb0_008z);
                              if (_1753 < (_1791 * 0.3010300099849701f)) {
                                float _1799 = ((_1752 - _1760) * 0.9030900001525879f) / ((_1791 - _1760) * 0.3010300099849701f);
                                int _1800 = int(_1799);
                                float _1802 = _1799 - float((int)(_1800));
                                float _1804 = _12[_1800];
                                float _1807 = _12[(_1800 + 1)];
                                float _1812 = _1804 * 0.5f;
                                _1822 = dot(float3((_1802 * _1802), _1802, 1.0f), float3(mad((_12[(_1800 + 2)]), 0.5f, mad(_1807, -1.0f, _1812)), (_1807 - _1804), mad(_1807, 0.5f, _1812)));
                                break;
                              }
                            }
                            _1822 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1826 = cb0_008w - cb0_008y;
                      float _1827 = (exp2(_1674 * 3.321928024291992f) - cb0_008y) / _1826;
                      float _1829 = (exp2(_1748 * 3.321928024291992f) - cb0_008y) / _1826;
                      float _1831 = (exp2(_1822 * 3.321928024291992f) - cb0_008y) / _1826;
                      float _1834 = mad(0.15618768334388733f, _1831, mad(0.13400420546531677f, _1829, (_1827 * 0.6624541878700256f)));
                      float _1837 = mad(0.053689517080783844f, _1831, mad(0.6740817427635193f, _1829, (_1827 * 0.2722287178039551f)));
                      float _1840 = mad(1.0103391408920288f, _1831, mad(0.00406073359772563f, _1829, (_1827 * -0.005574649665504694f)));
                      float _1853 = min(max(mad(-0.23642469942569733f, _1840, mad(-0.32480329275131226f, _1837, (_1834 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1854 = min(max(mad(0.016756348311901093f, _1840, mad(1.6153316497802734f, _1837, (_1834 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1855 = min(max(mad(0.9883948564529419f, _1840, mad(-0.008284442126750946f, _1837, (_1834 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1858 = mad(0.15618768334388733f, _1855, mad(0.13400420546531677f, _1854, (_1853 * 0.6624541878700256f)));
                      float _1861 = mad(0.053689517080783844f, _1855, mad(0.6740817427635193f, _1854, (_1853 * 0.2722287178039551f)));
                      float _1864 = mad(1.0103391408920288f, _1855, mad(0.00406073359772563f, _1854, (_1853 * -0.005574649665504694f)));
                      float _1886 = min(max((min(max(mad(-0.23642469942569733f, _1864, mad(-0.32480329275131226f, _1861, (_1858 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1887 = min(max((min(max(mad(0.016756348311901093f, _1864, mad(1.6153316497802734f, _1861, (_1858 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1888 = min(max((min(max(mad(0.9883948564529419f, _1864, mad(-0.008284442126750946f, _1861, (_1858 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1901 = mad(_49, _1888, mad(_48, _1887, (_1886 * _47)));
                          _1902 = mad(_52, _1888, mad(_51, _1887, (_1886 * _50)));
                          _1903 = mad(_55, _1888, mad(_54, _1887, (_1886 * _53)));
                        } else {
                          _1901 = _1886;
                          _1902 = _1887;
                          _1903 = _1888;
                        }
                        float _1913 = exp2(log2(_1901 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1914 = exp2(log2(_1902 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1915 = exp2(log2(_1903 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2656 = exp2(log2((1.0f / ((_1913 * 18.6875f) + 1.0f)) * ((_1913 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2657 = exp2(log2((1.0f / ((_1914 * 18.6875f) + 1.0f)) * ((_1914 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2658 = exp2(log2((1.0f / ((_1915 * 18.6875f) + 1.0f)) * ((_1915 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          _9[0] = cb0_010x;
          _9[1] = cb0_010y;
          _9[2] = cb0_010z;
          _9[3] = cb0_010w;
          _9[4] = cb0_012x;
          _9[5] = cb0_012x;
          _10[0] = cb0_011x;
          _10[1] = cb0_011y;
          _10[2] = cb0_011z;
          _10[3] = cb0_011w;
          _10[4] = cb0_012y;
          _10[5] = cb0_012y;
          float _1994 = cb0_012z * _1216;
          float _1995 = cb0_012z * _1217;
          float _1996 = cb0_012z * _1218;
          float _1999 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1996, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1995, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1994)));
          float _2002 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1996, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1995, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1994)));
          float _2005 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1996, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1995, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1994)));
          float _2009 = max(max(_1999, _2002), _2005);
          float _2014 = (max(_2009, 1.000000013351432e-10f) - max(min(min(_1999, _2002), _2005), 1.000000013351432e-10f)) / max(_2009, 0.009999999776482582f);
          float _2027 = ((_2002 + _1999) + _2005) + (sqrt((((_2005 - _2002) * _2005) + ((_2002 - _1999) * _2002)) + ((_1999 - _2005) * _1999)) * 1.75f);
          float _2028 = _2027 * 0.3333333432674408f;
          float _2029 = _2014 + -0.4000000059604645f;
          float _2030 = _2029 * 5.0f;
          float _2034 = max((1.0f - abs(_2029 * 2.5f)), 0.0f);
          float _2045 = ((float((int)(((int)(uint)((bool)(_2030 > 0.0f))) - ((int)(uint)((bool)(_2030 < 0.0f))))) * (1.0f - (_2034 * _2034))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_2028 <= 0.0533333346247673f)) {
              if (!(_2028 >= 0.1599999964237213f)) {
                _2054 = (((0.23999999463558197f / _2027) + -0.5f) * _2045);
              } else {
                _2054 = 0.0f;
              }
            } else {
              _2054 = _2045;
            }
            float _2055 = _2054 + 1.0f;
            float _2056 = _2055 * _1999;
            float _2057 = _2055 * _2002;
            float _2058 = _2055 * _2005;
            do {
              if (!((bool)(_2056 == _2057) && (bool)(_2057 == _2058))) {
                float _2065 = ((_2056 * 2.0f) - _2057) - _2058;
                float _2068 = ((_2002 - _2005) * 1.7320507764816284f) * _2055;
                float _2070 = atan(_2068 / _2065);
                bool _2073 = (_2065 < 0.0f);
                bool _2074 = (_2065 == 0.0f);
                bool _2075 = (_2068 >= 0.0f);
                bool _2076 = (_2068 < 0.0f);
                float _2085 = select((_2075 && _2074), 90.0f, select((_2076 && _2074), -90.0f, (select((_2076 && _2073), (_2070 + -3.1415927410125732f), select((_2075 && _2073), (_2070 + 3.1415927410125732f), _2070)) * 57.2957763671875f)));
                if (_2085 < 0.0f) {
                  _2090 = (_2085 + 360.0f);
                } else {
                  _2090 = _2085;
                }
              } else {
                _2090 = 0.0f;
              }
              float _2092 = min(max(_2090, 0.0f), 360.0f);
              do {
                if (_2092 < -180.0f) {
                  _2101 = (_2092 + 360.0f);
                } else {
                  if (_2092 > 180.0f) {
                    _2101 = (_2092 + -360.0f);
                  } else {
                    _2101 = _2092;
                  }
                }
                do {
                  if ((bool)(_2101 > -67.5f) && (bool)(_2101 < 67.5f)) {
                    float _2107 = (_2101 + 67.5f) * 0.029629629105329514f;
                    int _2108 = int(_2107);
                    float _2110 = _2107 - float((int)(_2108));
                    float _2111 = _2110 * _2110;
                    float _2112 = _2111 * _2110;
                    if (_2108 == 3) {
                      _2140 = (((0.1666666716337204f - (_2110 * 0.5f)) + (_2111 * 0.5f)) - (_2112 * 0.1666666716337204f));
                    } else {
                      if (_2108 == 2) {
                        _2140 = ((0.6666666865348816f - _2111) + (_2112 * 0.5f));
                      } else {
                        if (_2108 == 1) {
                          _2140 = (((_2112 * -0.5f) + 0.1666666716337204f) + ((_2111 + _2110) * 0.5f));
                        } else {
                          _2140 = select((_2108 == 0), (_2112 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2140 = 0.0f;
                  }
                  float _2149 = min(max(((((_2014 * 0.27000001072883606f) * (0.029999999329447746f - _2056)) * _2140) + _2056), 0.0f), 65535.0f);
                  float _2150 = min(max(_2057, 0.0f), 65535.0f);
                  float _2151 = min(max(_2058, 0.0f), 65535.0f);
                  float _2164 = min(max(mad(-0.21492856740951538f, _2151, mad(-0.2365107536315918f, _2150, (_2149 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2165 = min(max(mad(-0.09967592358589172f, _2151, mad(1.17622971534729f, _2150, (_2149 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2166 = min(max(mad(0.9977163076400757f, _2151, mad(-0.006032449658960104f, _2150, (_2149 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2167 = dot(float3(_2164, _2165, _2166), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2178 = log2(max((lerp(_2167, _2164, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2179 = _2178 * 0.3010300099849701f;
                  float _2180 = log2(cb0_008x);
                  float _2181 = _2180 * 0.3010300099849701f;
                  do {
                    if (!(!(_2179 <= _2181))) {
                      _2250 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2188 = log2(cb0_009x);
                      float _2189 = _2188 * 0.3010300099849701f;
                      if ((bool)(_2179 > _2181) && (bool)(_2179 < _2189)) {
                        float _2197 = ((_2178 - _2180) * 0.9030900001525879f) / ((_2188 - _2180) * 0.3010300099849701f);
                        int _2198 = int(_2197);
                        float _2200 = _2197 - float((int)(_2198));
                        float _2202 = _9[_2198];
                        float _2205 = _9[(_2198 + 1)];
                        float _2210 = _2202 * 0.5f;
                        _2250 = dot(float3((_2200 * _2200), _2200, 1.0f), float3(mad((_9[(_2198 + 2)]), 0.5f, mad(_2205, -1.0f, _2210)), (_2205 - _2202), mad(_2205, 0.5f, _2210)));
                      } else {
                        do {
                          if (!(!(_2179 >= _2189))) {
                            float _2219 = log2(cb0_008z);
                            if (_2179 < (_2219 * 0.3010300099849701f)) {
                              float _2227 = ((_2178 - _2188) * 0.9030900001525879f) / ((_2219 - _2188) * 0.3010300099849701f);
                              int _2228 = int(_2227);
                              float _2230 = _2227 - float((int)(_2228));
                              float _2232 = _10[_2228];
                              float _2235 = _10[(_2228 + 1)];
                              float _2240 = _2232 * 0.5f;
                              _2250 = dot(float3((_2230 * _2230), _2230, 1.0f), float3(mad((_10[(_2228 + 2)]), 0.5f, mad(_2235, -1.0f, _2240)), (_2235 - _2232), mad(_2235, 0.5f, _2240)));
                              break;
                            }
                          }
                          _2250 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2254 = log2(max((lerp(_2167, _2165, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2255 = _2254 * 0.3010300099849701f;
                    do {
                      if (!(!(_2255 <= _2181))) {
                        _2324 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2262 = log2(cb0_009x);
                        float _2263 = _2262 * 0.3010300099849701f;
                        if ((bool)(_2255 > _2181) && (bool)(_2255 < _2263)) {
                          float _2271 = ((_2254 - _2180) * 0.9030900001525879f) / ((_2262 - _2180) * 0.3010300099849701f);
                          int _2272 = int(_2271);
                          float _2274 = _2271 - float((int)(_2272));
                          float _2276 = _9[_2272];
                          float _2279 = _9[(_2272 + 1)];
                          float _2284 = _2276 * 0.5f;
                          _2324 = dot(float3((_2274 * _2274), _2274, 1.0f), float3(mad((_9[(_2272 + 2)]), 0.5f, mad(_2279, -1.0f, _2284)), (_2279 - _2276), mad(_2279, 0.5f, _2284)));
                        } else {
                          do {
                            if (!(!(_2255 >= _2263))) {
                              float _2293 = log2(cb0_008z);
                              if (_2255 < (_2293 * 0.3010300099849701f)) {
                                float _2301 = ((_2254 - _2262) * 0.9030900001525879f) / ((_2293 - _2262) * 0.3010300099849701f);
                                int _2302 = int(_2301);
                                float _2304 = _2301 - float((int)(_2302));
                                float _2306 = _10[_2302];
                                float _2309 = _10[(_2302 + 1)];
                                float _2314 = _2306 * 0.5f;
                                _2324 = dot(float3((_2304 * _2304), _2304, 1.0f), float3(mad((_10[(_2302 + 2)]), 0.5f, mad(_2309, -1.0f, _2314)), (_2309 - _2306), mad(_2309, 0.5f, _2314)));
                                break;
                              }
                            }
                            _2324 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2328 = log2(max((lerp(_2167, _2166, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2329 = _2328 * 0.3010300099849701f;
                      do {
                        if (!(!(_2329 <= _2181))) {
                          _2398 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2336 = log2(cb0_009x);
                          float _2337 = _2336 * 0.3010300099849701f;
                          if ((bool)(_2329 > _2181) && (bool)(_2329 < _2337)) {
                            float _2345 = ((_2328 - _2180) * 0.9030900001525879f) / ((_2336 - _2180) * 0.3010300099849701f);
                            int _2346 = int(_2345);
                            float _2348 = _2345 - float((int)(_2346));
                            float _2350 = _9[_2346];
                            float _2353 = _9[(_2346 + 1)];
                            float _2358 = _2350 * 0.5f;
                            _2398 = dot(float3((_2348 * _2348), _2348, 1.0f), float3(mad((_9[(_2346 + 2)]), 0.5f, mad(_2353, -1.0f, _2358)), (_2353 - _2350), mad(_2353, 0.5f, _2358)));
                          } else {
                            do {
                              if (!(!(_2329 >= _2337))) {
                                float _2367 = log2(cb0_008z);
                                if (_2329 < (_2367 * 0.3010300099849701f)) {
                                  float _2375 = ((_2328 - _2336) * 0.9030900001525879f) / ((_2367 - _2336) * 0.3010300099849701f);
                                  int _2376 = int(_2375);
                                  float _2378 = _2375 - float((int)(_2376));
                                  float _2380 = _10[_2376];
                                  float _2383 = _10[(_2376 + 1)];
                                  float _2388 = _2380 * 0.5f;
                                  _2398 = dot(float3((_2378 * _2378), _2378, 1.0f), float3(mad((_10[(_2376 + 2)]), 0.5f, mad(_2383, -1.0f, _2388)), (_2383 - _2380), mad(_2383, 0.5f, _2388)));
                                  break;
                                }
                              }
                              _2398 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2402 = cb0_008w - cb0_008y;
                        float _2403 = (exp2(_2250 * 3.321928024291992f) - cb0_008y) / _2402;
                        float _2405 = (exp2(_2324 * 3.321928024291992f) - cb0_008y) / _2402;
                        float _2407 = (exp2(_2398 * 3.321928024291992f) - cb0_008y) / _2402;
                        float _2410 = mad(0.15618768334388733f, _2407, mad(0.13400420546531677f, _2405, (_2403 * 0.6624541878700256f)));
                        float _2413 = mad(0.053689517080783844f, _2407, mad(0.6740817427635193f, _2405, (_2403 * 0.2722287178039551f)));
                        float _2416 = mad(1.0103391408920288f, _2407, mad(0.00406073359772563f, _2405, (_2403 * -0.005574649665504694f)));
                        float _2429 = min(max(mad(-0.23642469942569733f, _2416, mad(-0.32480329275131226f, _2413, (_2410 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2430 = min(max(mad(0.016756348311901093f, _2416, mad(1.6153316497802734f, _2413, (_2410 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2431 = min(max(mad(0.9883948564529419f, _2416, mad(-0.008284442126750946f, _2413, (_2410 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2434 = mad(0.15618768334388733f, _2431, mad(0.13400420546531677f, _2430, (_2429 * 0.6624541878700256f)));
                        float _2437 = mad(0.053689517080783844f, _2431, mad(0.6740817427635193f, _2430, (_2429 * 0.2722287178039551f)));
                        float _2440 = mad(1.0103391408920288f, _2431, mad(0.00406073359772563f, _2430, (_2429 * -0.005574649665504694f)));
                        float _2462 = min(max((min(max(mad(-0.23642469942569733f, _2440, mad(-0.32480329275131226f, _2437, (_2434 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2463 = min(max((min(max(mad(0.016756348311901093f, _2440, mad(1.6153316497802734f, _2437, (_2434 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2464 = min(max((min(max(mad(0.9883948564529419f, _2440, mad(-0.008284442126750946f, _2437, (_2434 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2477 = mad(_49, _2464, mad(_48, _2463, (_2462 * _47)));
                            _2478 = mad(_52, _2464, mad(_51, _2463, (_2462 * _50)));
                            _2479 = mad(_55, _2464, mad(_54, _2463, (_2462 * _53)));
                          } else {
                            _2477 = _2462;
                            _2478 = _2463;
                            _2479 = _2464;
                          }
                          float _2489 = exp2(log2(_2477 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2490 = exp2(log2(_2478 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2491 = exp2(log2(_2479 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2656 = exp2(log2((1.0f / ((_2489 * 18.6875f) + 1.0f)) * ((_2489 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2657 = exp2(log2((1.0f / ((_2490 * 18.6875f) + 1.0f)) * ((_2490 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2658 = exp2(log2((1.0f / ((_2491 * 18.6875f) + 1.0f)) * ((_2491 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2536 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1218, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1217, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1216)));
            float _2539 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1218, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1217, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1216)));
            float _2542 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1218, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1217, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1216)));
            float _2561 = exp2(log2(mad(_49, _2542, mad(_48, _2539, (_2536 * _47))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2562 = exp2(log2(mad(_52, _2542, mad(_51, _2539, (_2536 * _50))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2563 = exp2(log2(mad(_55, _2542, mad(_54, _2539, (_2536 * _53))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2656 = exp2(log2((1.0f / ((_2561 * 18.6875f) + 1.0f)) * ((_2561 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2657 = exp2(log2((1.0f / ((_2562 * 18.6875f) + 1.0f)) * ((_2562 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2658 = exp2(log2((1.0f / ((_2563 * 18.6875f) + 1.0f)) * ((_2563 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2610 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1206, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1205, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1204)));
                float _2613 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1206, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1205, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1204)));
                float _2616 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1206, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1205, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1204)));
                _2656 = mad(_49, _2616, mad(_48, _2613, (_2610 * _47)));
                _2657 = mad(_52, _2616, mad(_51, _2613, (_2610 * _50)));
                _2658 = mad(_55, _2616, mad(_54, _2613, (_2610 * _53)));
              } else {
                float _2629 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1230)));
                float _2632 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1230)));
                float _2635 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1232, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1231, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1230)));
                _2656 = exp2(log2(mad(_49, _2635, mad(_48, _2632, (_2629 * _47)))) * cb0_040z);
                _2657 = exp2(log2(mad(_52, _2635, mad(_51, _2632, (_2629 * _50)))) * cb0_040z);
                _2658 = exp2(log2(mad(_55, _2635, mad(_54, _2632, (_2629 * _53)))) * cb0_040z);
              }
            } else {
              _2656 = _1216;
              _2657 = _1217;
              _2658 = _1218;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2656 * 0.9523810148239136f), (_2657 * 0.9523810148239136f), (_2658 * 0.9523810148239136f), 0.0f);
}
