#include "../lutbuilderoutput.hlsli"

// The Expanse: Osiris Reborn beta

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
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
  float cb0_038y : packoffset(c038.y);
  uint cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  uint cb0_041x : packoffset(c041.x);
};

cbuffer cb1 : register(b1) {
  float4 WorkingColorSpace_000[4] : packoffset(c000.x);
  float4 WorkingColorSpace_064[4] : packoffset(c004.x);
  float4 WorkingColorSpace_128[4] : packoffset(c008.x);
  float4 WorkingColorSpace_192[4] : packoffset(c012.x);
  float4 WorkingColorSpace_256[4] : packoffset(c016.x);
  int WorkingColorSpace_320 : packoffset(c020.x);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex) : SV_Target {
  float4 SV_Target;
  float _14 = 0.5f / cb0_035x;
  float _19 = cb0_035x + -1.0f;
  float _43;
  float _44;
  float _45;
  float _46;
  float _47;
  float _48;
  float _49;
  float _50;
  float _51;
  float _114;
  float _821;
  float _854;
  float _868;
  float _932;
  float _1123;
  float _1134;
  float _1145;
  float _1331;
  float _1332;
  float _1333;
  float _1344;
  float _1355;
  float _1366;
  if (!((uint)(cb0_041x) == 1)) {
    if (!((uint)(cb0_041x) == 2)) {
      if (!((uint)(cb0_041x) == 3)) {
        bool _32 = ((uint)(cb0_041x) == 4);
        _43 = select(_32, 1.0f, 1.705051064491272f);
        _44 = select(_32, 0.0f, -0.6217921376228333f);
        _45 = select(_32, 0.0f, -0.0832589864730835f);
        _46 = select(_32, 0.0f, -0.13025647401809692f);
        _47 = select(_32, 1.0f, 1.140804648399353f);
        _48 = select(_32, 0.0f, -0.010548308491706848f);
        _49 = select(_32, 0.0f, -0.024003351107239723f);
        _50 = select(_32, 0.0f, -0.1289689838886261f);
        _51 = select(_32, 1.0f, 1.1529725790023804f);
      } else {
        _43 = 0.6954522132873535f;
        _44 = 0.14067870378494263f;
        _45 = 0.16386906802654266f;
        _46 = 0.044794563204050064f;
        _47 = 0.8596711158752441f;
        _48 = 0.0955343171954155f;
        _49 = -0.005525882821530104f;
        _50 = 0.004025210160762072f;
        _51 = 1.0015007257461548f;
      }
    } else {
      _43 = 1.0258246660232544f;
      _44 = -0.020053181797266006f;
      _45 = -0.005771636962890625f;
      _46 = -0.002234415616840124f;
      _47 = 1.0045864582061768f;
      _48 = -0.002352118492126465f;
      _49 = -0.005013350863009691f;
      _50 = -0.025290070101618767f;
      _51 = 1.0303035974502563f;
    }
  } else {
    _43 = 1.3792141675949097f;
    _44 = -0.30886411666870117f;
    _45 = -0.0703500509262085f;
    _46 = -0.06933490186929703f;
    _47 = 1.08229660987854f;
    _48 = -0.012961871922016144f;
    _49 = -0.0021590073592960835f;
    _50 = -0.0454593189060688f;
    _51 = 1.0476183891296387f;
  }
  float _64 = (exp2((((cb0_035x * (TEXCOORD.x - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _65 = (exp2((((cb0_035x * (TEXCOORD.y - _14)) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  float _66 = (exp2(((float((uint)SV_RenderTargetArrayIndex) / _19) + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f;
  bool _93 = ((uint)(cb0_038w) != 0);
  float _97 = 0.9994439482688904f / cb0_035y;
  if (!(!((cb0_035y * 1.0005563497543335f) <= 7000.0f))) {
    _114 = (((((2967800.0f - (_97 * 4607000064.0f)) * _97) + 99.11000061035156f) * _97) + 0.24406300485134125f);
  } else {
    _114 = (((((1901800.0f - (_97 * 2006400000.0f)) * _97) + 247.47999572753906f) * _97) + 0.23703999817371368f);
  }
  float _128 = ((((cb0_035y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_035y) + 0.8601177334785461f) / ((((cb0_035y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_035y) + 1.0f);
  float _135 = cb0_035y * cb0_035y;
  float _138 = ((((cb0_035y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_035y) + 0.31739872694015503f) / ((1.0f - (cb0_035y * 2.8974181986995973e-05f)) + (_135 * 1.6145605741257896e-07f));
  float _143 = ((_128 * 2.0f) + 4.0f) - (_138 * 8.0f);
  float _144 = (_128 * 3.0f) / _143;
  float _146 = (_138 * 2.0f) / _143;
  bool _147 = (cb0_035y < 4000.0f);
  float _156 = ((cb0_035y + 1189.6199951171875f) * cb0_035y) + 1412139.875f;
  float _158 = ((-1137581184.0f - (cb0_035y * 1916156.25f)) - (_135 * 1.5317699909210205f)) / (_156 * _156);
  float _165 = (6193636.0f - (cb0_035y * 179.45599365234375f)) + _135;
  float _167 = ((1974715392.0f - (cb0_035y * 705674.0f)) - (_135 * 308.60699462890625f)) / (_165 * _165);
  float _169 = rsqrt(dot(float2(_158, _167), float2(_158, _167)));
  float _170 = cb0_035z * 0.05000000074505806f;
  float _173 = ((_170 * _167) * _169) + _128;
  float _176 = _138 - ((_170 * _158) * _169);
  float _181 = (4.0f - (_176 * 8.0f)) + (_173 * 2.0f);
  float _187 = (((_173 * 3.0f) / _181) - _144) + select(_147, _144, _114);
  float _188 = (((_176 * 2.0f) / _181) - _146) + select(_147, _146, (((_114 * 2.869999885559082f) + -0.2750000059604645f) - ((_114 * _114) * 3.0f)));
  float _189 = select(_93, _187, 0.3127000033855438f);
  float _190 = select(_93, _188, 0.32899999618530273f);
  float _191 = select(_93, 0.3127000033855438f, _187);
  float _192 = select(_93, 0.32899999618530273f, _188);
  float _193 = max(_190, 1.000000013351432e-10f);
  float _194 = _189 / _193;
  float _197 = ((1.0f - _189) - _190) / _193;
  float _198 = max(_192, 1.000000013351432e-10f);
  float _199 = _191 / _198;
  float _202 = ((1.0f - _191) - _192) / _198;
  float _221 = mad(-0.16140000522136688f, _202, ((_199 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _197, ((_194 * 0.8950999975204468f) + 0.266400009393692f));
  float _222 = mad(0.03669999912381172f, _202, (1.7135000228881836f - (_199 * 0.7501999735832214f))) / mad(0.03669999912381172f, _197, (1.7135000228881836f - (_194 * 0.7501999735832214f)));
  float _223 = mad(1.0296000242233276f, _202, ((_199 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _197, ((_194 * 0.03889999911189079f) + -0.06849999725818634f));
  float _224 = mad(_222, -0.7501999735832214f, 0.0f);
  float _225 = mad(_222, 1.7135000228881836f, 0.0f);
  float _226 = mad(_222, 0.03669999912381172f, -0.0f);
  float _227 = mad(_223, 0.03889999911189079f, 0.0f);
  float _228 = mad(_223, -0.06849999725818634f, 0.0f);
  float _229 = mad(_223, 1.0296000242233276f, 0.0f);
  float _232 = mad(0.1599626988172531f, _227, mad(-0.1470542997121811f, _224, (_221 * 0.883457362651825f)));
  float _235 = mad(0.1599626988172531f, _228, mad(-0.1470542997121811f, _225, (_221 * 0.26293492317199707f)));
  float _238 = mad(0.1599626988172531f, _229, mad(-0.1470542997121811f, _226, (_221 * -0.15930065512657166f)));
  float _241 = mad(0.04929120093584061f, _227, mad(0.5183603167533875f, _224, (_221 * 0.38695648312568665f)));
  float _244 = mad(0.04929120093584061f, _228, mad(0.5183603167533875f, _225, (_221 * 0.11516613513231277f)));
  float _247 = mad(0.04929120093584061f, _229, mad(0.5183603167533875f, _226, (_221 * -0.0697740763425827f)));
  float _250 = mad(0.9684867262840271f, _227, mad(0.04004279896616936f, _224, (_221 * -0.007634039502590895f)));
  float _253 = mad(0.9684867262840271f, _228, mad(0.04004279896616936f, _225, (_221 * -0.0022720457054674625f)));
  float _256 = mad(0.9684867262840271f, _229, mad(0.04004279896616936f, _226, (_221 * 0.0013765322510153055f)));
  float _259 = mad(_238, (WorkingColorSpace_000[2].x), mad(_235, (WorkingColorSpace_000[1].x), (_232 * (WorkingColorSpace_000[0].x))));
  float _262 = mad(_238, (WorkingColorSpace_000[2].y), mad(_235, (WorkingColorSpace_000[1].y), (_232 * (WorkingColorSpace_000[0].y))));
  float _265 = mad(_238, (WorkingColorSpace_000[2].z), mad(_235, (WorkingColorSpace_000[1].z), (_232 * (WorkingColorSpace_000[0].z))));
  float _268 = mad(_247, (WorkingColorSpace_000[2].x), mad(_244, (WorkingColorSpace_000[1].x), (_241 * (WorkingColorSpace_000[0].x))));
  float _271 = mad(_247, (WorkingColorSpace_000[2].y), mad(_244, (WorkingColorSpace_000[1].y), (_241 * (WorkingColorSpace_000[0].y))));
  float _274 = mad(_247, (WorkingColorSpace_000[2].z), mad(_244, (WorkingColorSpace_000[1].z), (_241 * (WorkingColorSpace_000[0].z))));
  float _277 = mad(_256, (WorkingColorSpace_000[2].x), mad(_253, (WorkingColorSpace_000[1].x), (_250 * (WorkingColorSpace_000[0].x))));
  float _280 = mad(_256, (WorkingColorSpace_000[2].y), mad(_253, (WorkingColorSpace_000[1].y), (_250 * (WorkingColorSpace_000[0].y))));
  float _283 = mad(_256, (WorkingColorSpace_000[2].z), mad(_253, (WorkingColorSpace_000[1].z), (_250 * (WorkingColorSpace_000[0].z))));
  float _313 = mad(mad((WorkingColorSpace_064[0].z), _283, mad((WorkingColorSpace_064[0].y), _274, (_265 * (WorkingColorSpace_064[0].x)))), _66, mad(mad((WorkingColorSpace_064[0].z), _280, mad((WorkingColorSpace_064[0].y), _271, (_262 * (WorkingColorSpace_064[0].x)))), _65, (mad((WorkingColorSpace_064[0].z), _277, mad((WorkingColorSpace_064[0].y), _268, (_259 * (WorkingColorSpace_064[0].x)))) * _64)));
  float _316 = mad(mad((WorkingColorSpace_064[1].z), _283, mad((WorkingColorSpace_064[1].y), _274, (_265 * (WorkingColorSpace_064[1].x)))), _66, mad(mad((WorkingColorSpace_064[1].z), _280, mad((WorkingColorSpace_064[1].y), _271, (_262 * (WorkingColorSpace_064[1].x)))), _65, (mad((WorkingColorSpace_064[1].z), _277, mad((WorkingColorSpace_064[1].y), _268, (_259 * (WorkingColorSpace_064[1].x)))) * _64)));
  float _319 = mad(mad((WorkingColorSpace_064[2].z), _283, mad((WorkingColorSpace_064[2].y), _274, (_265 * (WorkingColorSpace_064[2].x)))), _66, mad(mad((WorkingColorSpace_064[2].z), _280, mad((WorkingColorSpace_064[2].y), _271, (_262 * (WorkingColorSpace_064[2].x)))), _65, (mad((WorkingColorSpace_064[2].z), _277, mad((WorkingColorSpace_064[2].y), _268, (_259 * (WorkingColorSpace_064[2].x)))) * _64)));
  float _334 = mad((WorkingColorSpace_128[0].z), _319, mad((WorkingColorSpace_128[0].y), _316, ((WorkingColorSpace_128[0].x) * _313)));
  float _337 = mad((WorkingColorSpace_128[1].z), _319, mad((WorkingColorSpace_128[1].y), _316, ((WorkingColorSpace_128[1].x) * _313)));
  float _340 = mad((WorkingColorSpace_128[2].z), _319, mad((WorkingColorSpace_128[2].y), _316, ((WorkingColorSpace_128[2].x) * _313)));
  float _341 = dot(float3(_334, _337, _340), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _345 = (_334 / _341) + -1.0f;
  float _346 = (_337 / _341) + -1.0f;
  float _347 = (_340 / _341) + -1.0f;

  // float _359 = (1.0f - exp2(((_341 * _341) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_345, _346, _347), float3(_345, _346, _347)) * -4.0f));
  float _359 = (1.0f - exp2(((_341 * _341) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_345, _346, _347), float3(_345, _346, _347)) * -4.0f));

  float _375 = ((mad(-0.06368321925401688f, _340, mad(-0.3292922377586365f, _337, (_334 * 1.3704125881195068f))) - _334) * _359) + _334;
  float _376 = ((mad(-0.010861365124583244f, _340, mad(1.0970927476882935f, _337, (_334 * -0.08343357592821121f))) - _337) * _359) + _337;
  float _377 = ((mad(1.2036951780319214f, _340, mad(-0.09862580895423889f, _337, (_334 * -0.02579331398010254f))) - _340) * _359) + _340;
  float _378 = dot(float3(_375, _376, _377), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _392 = cb0_019w + cb0_024w;
  float _406 = cb0_018w * cb0_023w;
  float _420 = cb0_017w * cb0_022w;
  float _434 = cb0_016w * cb0_021w;
  float _448 = cb0_015w * cb0_020w;
  float _452 = _375 - _378;
  float _453 = _376 - _378;
  float _454 = _377 - _378;
  float _511 = saturate(_378 / cb0_035w);
  float _515 = (_511 * _511) * (3.0f - (_511 * 2.0f));
  float _516 = 1.0f - _515;
  float _525 = cb0_019w + cb0_034w;
  float _534 = cb0_018w * cb0_033w;
  float _543 = cb0_017w * cb0_032w;
  float _552 = cb0_016w * cb0_031w;
  float _561 = cb0_015w * cb0_030w;
  float _624 = saturate((_378 - cb0_036x) / (cb0_036y - cb0_036x));
  float _628 = (_624 * _624) * (3.0f - (_624 * 2.0f));
  float _637 = cb0_019w + cb0_029w;
  float _646 = cb0_018w * cb0_028w;
  float _655 = cb0_017w * cb0_027w;
  float _664 = cb0_016w * cb0_026w;
  float _673 = cb0_015w * cb0_025w;
  float _731 = _515 - _628;
  float _742 = ((_628 * (((cb0_019x + cb0_034x) + _525) + (((cb0_018x * cb0_033x) * _534) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _552) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _561) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _543)))))) + (_516 * (((cb0_019x + cb0_024x) + _392) + (((cb0_018x * cb0_023x) * _406) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _434) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _448) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _420))))))) + ((((cb0_019x + cb0_029x) + _637) + (((cb0_018x * cb0_028x) * _646) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _664) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _673) * _452) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _655))))) * _731);
  float _744 = ((_628 * (((cb0_019y + cb0_034y) + _525) + (((cb0_018y * cb0_033y) * _534) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _552) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _561) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _543)))))) + (_516 * (((cb0_019y + cb0_024y) + _392) + (((cb0_018y * cb0_023y) * _406) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _434) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _448) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _420))))))) + ((((cb0_019y + cb0_029y) + _637) + (((cb0_018y * cb0_028y) * _646) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _664) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _673) * _453) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _655))))) * _731);
  float _746 = ((_628 * (((cb0_019z + cb0_034z) + _525) + (((cb0_018z * cb0_033z) * _534) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _552) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _561) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _543)))))) + (_516 * (((cb0_019z + cb0_024z) + _392) + (((cb0_018z * cb0_023z) * _406) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _434) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _448) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _420))))))) + ((((cb0_019z + cb0_029z) + _637) + (((cb0_018z * cb0_028z) * _646) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _664) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _673) * _454) + _378)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _655))))) * _731);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_038x;
  cb_config.ue_filmtoe = cb0_037z;
  cb_config.ue_filmshoulder = cb0_037w;
  cb_config.ue_filmslope = cb0_037y;
  cb_config.ue_filmwhiteclip = cb0_038y;
  cb_config.ue_tonecurveammount = cb0_037x;
  cb_config.ue_mappingpolynomial = float3(cb0_039x, cb0_039y, cb0_039z);
  cb_config.ue_overlaycolor = float4(cb0_013x, cb0_013y, cb0_013z, cb0_013w);
  cb_config.ue_bluecorrection = cb0_036z;
  cb_config.ue_colorscale = float3(cb0_014x, cb0_014y, cb0_014z);
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyz is used

  SV_Target = ProcessLutbuilder(float3(_742, _744, _746), s0, s1, t0, t1, cb_config, SV_Target, 0u);
  return SV_Target;

  float _761 = ((mad(0.061360642313957214f, _746, mad(-4.540197551250458e-09f, _744, (_742 * 0.9386394023895264f))) - _742) * cb0_036z) + _742;
  float _762 = ((mad(0.169205904006958f, _746, mad(0.8307942152023315f, _744, (_742 * 6.775371730327606e-08f))) - _744) * cb0_036z) + _744;
  float _763 = (mad(-2.3283064365386963e-10f, _744, (_742 * -9.313225746154785e-10f)) * cb0_036z) + _746;
  float _766 = mad(0.16386905312538147f, _763, mad(0.14067868888378143f, _762, (_761 * 0.6954522132873535f)));
  float _769 = mad(0.0955343246459961f, _763, mad(0.8596711158752441f, _762, (_761 * 0.044794581830501556f)));
  float _772 = mad(1.0015007257461548f, _763, mad(0.004025210160762072f, _762, (_761 * -0.005525882821530104f)));
  float _776 = max(max(_766, _769), _772);
  float _781 = (max(_776, 1.000000013351432e-10f) - max(min(min(_766, _769), _772), 1.000000013351432e-10f)) / max(_776, 0.009999999776482582f);
  float _794 = ((_769 + _766) + _772) + (sqrt((((_772 - _769) * _772) + ((_769 - _766) * _769)) + ((_766 - _772) * _766)) * 1.75f);
  float _795 = _794 * 0.3333333432674408f;
  float _796 = _781 + -0.4000000059604645f;
  float _797 = _796 * 5.0f;
  float _801 = max((1.0f - abs(_796 * 2.5f)), 0.0f);
  float _812 = ((float(((int)(uint)((bool)(_797 > 0.0f))) - ((int)(uint)((bool)(_797 < 0.0f)))) * (1.0f - (_801 * _801))) + 1.0f) * 0.02500000037252903f;
  if (!(_795 <= 0.0533333346247673f)) {
    if (!(_795 >= 0.1599999964237213f)) {
      _821 = (((0.23999999463558197f / _794) + -0.5f) * _812);
    } else {
      _821 = 0.0f;
    }
  } else {
    _821 = _812;
  }
  float _822 = _821 + 1.0f;
  float _823 = _822 * _766;
  float _824 = _822 * _769;
  float _825 = _822 * _772;
  if (!((bool)(_823 == _824) && (bool)(_824 == _825))) {
    float _832 = ((_823 * 2.0f) - _824) - _825;
    float _835 = ((_769 - _772) * 1.7320507764816284f) * _822;
    float _837 = atan(_835 / _832);
    bool _840 = (_832 < 0.0f);
    bool _841 = (_832 == 0.0f);
    bool _842 = (_835 >= 0.0f);
    bool _843 = (_835 < 0.0f);
    _854 = select((_842 && _841), 90.0f, select((_843 && _841), -90.0f, (select((_843 && _840), (_837 + -3.1415927410125732f), select((_842 && _840), (_837 + 3.1415927410125732f), _837)) * 57.2957763671875f)));
  } else {
    _854 = 0.0f;
  }
  float _859 = min(max(select((_854 < 0.0f), (_854 + 360.0f), _854), 0.0f), 360.0f);
  if (_859 < -180.0f) {
    _868 = (_859 + 360.0f);
  } else {
    if (_859 > 180.0f) {
      _868 = (_859 + -360.0f);
    } else {
      _868 = _859;
    }
  }
  float _872 = saturate(1.0f - abs(_868 * 0.014814814552664757f));
  float _876 = (_872 * _872) * (3.0f - (_872 * 2.0f));
  float _882 = ((_876 * _876) * ((_781 * 0.18000000715255737f) * (0.029999999329447746f - _823))) + _823;
  float _892 = max(0.0f, mad(-0.21492856740951538f, _825, mad(-0.2365107536315918f, _824, (_882 * 1.4514392614364624f))));
  float _893 = max(0.0f, mad(-0.09967592358589172f, _825, mad(1.17622971534729f, _824, (_882 * -0.07655377686023712f))));
  float _894 = max(0.0f, mad(0.9977163076400757f, _825, mad(-0.006032449658960104f, _824, (_882 * 0.008316148072481155f))));
  float _895 = dot(float3(_892, _893, _894), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _910 = (cb0_038x + 1.0f) - cb0_037z;
  float _912 = cb0_038y + 1.0f;
  float _914 = _912 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _932 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _923 = (cb0_038x + 0.18000000715255737f) / _910;
    _932 = (-0.7447274923324585f - ((log2(_923 / (2.0f - _923)) * 0.3465735912322998f) * (_910 / cb0_037y)));
  }
  float _935 = ((1.0f - cb0_037z) / cb0_037y) - _932;
  float _937 = (cb0_037w / cb0_037y) - _935;
  float _941 = log2(lerp(_895, _892, 0.9599999785423279f)) * 0.3010300099849701f;
  float _942 = log2(lerp(_895, _893, 0.9599999785423279f)) * 0.3010300099849701f;
  float _943 = log2(lerp(_895, _894, 0.9599999785423279f)) * 0.3010300099849701f;
  float _947 = cb0_037y * (_941 + _935);
  float _948 = cb0_037y * (_942 + _935);
  float _949 = cb0_037y * (_943 + _935);
  float _950 = _910 * 2.0f;
  float _952 = (cb0_037y * -2.0f) / _910;
  float _953 = _941 - _932;
  float _954 = _942 - _932;
  float _955 = _943 - _932;
  float _974 = _914 * 2.0f;
  float _976 = (cb0_037y * 2.0f) / _914;
  float _1001 = select((_941 < _932), ((_950 / (exp2((_953 * 1.4426950216293335f) * _952) + 1.0f)) - cb0_038x), _947);
  float _1002 = select((_942 < _932), ((_950 / (exp2((_954 * 1.4426950216293335f) * _952) + 1.0f)) - cb0_038x), _948);
  float _1003 = select((_943 < _932), ((_950 / (exp2((_955 * 1.4426950216293335f) * _952) + 1.0f)) - cb0_038x), _949);
  float _1010 = _937 - _932;
  float _1014 = saturate(_953 / _1010);
  float _1015 = saturate(_954 / _1010);
  float _1016 = saturate(_955 / _1010);
  bool _1017 = (_937 < _932);
  float _1021 = select(_1017, (1.0f - _1014), _1014);
  float _1022 = select(_1017, (1.0f - _1015), _1015);
  float _1023 = select(_1017, (1.0f - _1016), _1016);
  float _1042 = (((_1021 * _1021) * (select((_941 > _937), (_912 - (_974 / (exp2(((_941 - _937) * 1.4426950216293335f) * _976) + 1.0f))), _947) - _1001)) * (3.0f - (_1021 * 2.0f))) + _1001;
  float _1043 = (((_1022 * _1022) * (select((_942 > _937), (_912 - (_974 / (exp2(((_942 - _937) * 1.4426950216293335f) * _976) + 1.0f))), _948) - _1002)) * (3.0f - (_1022 * 2.0f))) + _1002;
  float _1044 = (((_1023 * _1023) * (select((_943 > _937), (_912 - (_974 / (exp2(((_943 - _937) * 1.4426950216293335f) * _976) + 1.0f))), _949) - _1003)) * (3.0f - (_1023 * 2.0f))) + _1003;
  float _1045 = dot(float3(_1042, _1043, _1044), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1065 = (cb0_037x * (max(0.0f, (lerp(_1045, _1042, 0.9300000071525574f))) - _761)) + _761;
  float _1066 = (cb0_037x * (max(0.0f, (lerp(_1045, _1043, 0.9300000071525574f))) - _762)) + _762;
  float _1067 = (cb0_037x * (max(0.0f, (lerp(_1045, _1044, 0.9300000071525574f))) - _763)) + _763;
  float _1083 = ((mad(-0.06537103652954102f, _1067, mad(1.451815478503704e-06f, _1066, (_1065 * 1.065374732017517f))) - _1065) * cb0_036z) + _1065;
  float _1084 = ((mad(-0.20366770029067993f, _1067, mad(1.2036634683609009f, _1066, (_1065 * -2.57161445915699e-07f))) - _1066) * cb0_036z) + _1066;
  float _1085 = ((mad(0.9999996423721313f, _1067, mad(2.0954757928848267e-08f, _1066, (_1065 * 1.862645149230957e-08f))) - _1067) * cb0_036z) + _1067;
  float _1110 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _1085, mad((WorkingColorSpace_192[0].y), _1084, ((WorkingColorSpace_192[0].x) * _1083)))));
  float _1111 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _1085, mad((WorkingColorSpace_192[1].y), _1084, ((WorkingColorSpace_192[1].x) * _1083)))));
  float _1112 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _1085, mad((WorkingColorSpace_192[2].y), _1084, ((WorkingColorSpace_192[2].x) * _1083)))));
  if (_1110 < 0.0031306699384003878f) {
    _1123 = (_1110 * 12.920000076293945f);
  } else {
    _1123 = (((pow(_1110, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1111 < 0.0031306699384003878f) {
    _1134 = (_1111 * 12.920000076293945f);
  } else {
    _1134 = (((pow(_1111, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1112 < 0.0031306699384003878f) {
    _1145 = (_1112 * 12.920000076293945f);
  } else {
    _1145 = (((pow(_1112, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1149 = (_1134 * 0.9375f) + 0.03125f;
  float _1156 = _1145 * 15.0f;
  float _1157 = floor(_1156);
  float _1158 = _1156 - _1157;
  float _1160 = (_1157 + ((_1123 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _1163 = t0.Sample(s0, float2(_1160, _1149));
  float _1167 = _1160 + 0.0625f;
  float4 _1170 = t0.Sample(s0, float2(_1167, _1149));
  float4 _1193 = t1.Sample(s1, float2(_1160, _1149));
  float4 _1199 = t1.Sample(s1, float2(_1167, _1149));
  float _1218 = max(6.103519990574569e-05f, ((((lerp(_1163.x, _1170.x, _1158)) * cb0_005y) + (cb0_005x * _1123)) + ((lerp(_1193.x, _1199.x, _1158)) * cb0_005z)));
  float _1219 = max(6.103519990574569e-05f, ((((lerp(_1163.y, _1170.y, _1158)) * cb0_005y) + (cb0_005x * _1134)) + ((lerp(_1193.y, _1199.y, _1158)) * cb0_005z)));
  float _1220 = max(6.103519990574569e-05f, ((((lerp(_1163.z, _1170.z, _1158)) * cb0_005y) + (cb0_005x * _1145)) + ((lerp(_1193.z, _1199.z, _1158)) * cb0_005z)));
  float _1242 = select((_1218 > 0.040449999272823334f), exp2(log2((_1218 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1218 * 0.07739938050508499f));
  float _1243 = select((_1219 > 0.040449999272823334f), exp2(log2((_1219 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1219 * 0.07739938050508499f));
  float _1244 = select((_1220 > 0.040449999272823334f), exp2(log2((_1220 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1220 * 0.07739938050508499f));
  float _1270 = cb0_014x * (((cb0_039y + (cb0_039x * _1242)) * _1242) + cb0_039z);
  float _1271 = cb0_014y * (((cb0_039y + (cb0_039x * _1243)) * _1243) + cb0_039z);
  float _1272 = cb0_014z * (((cb0_039y + (cb0_039x * _1244)) * _1244) + cb0_039z);
  float _1293 = exp2(log2(max(0.0f, (lerp(_1270, cb0_013x, cb0_013w)))) * cb0_040y);
  float _1294 = exp2(log2(max(0.0f, (lerp(_1271, cb0_013y, cb0_013w)))) * cb0_040y);
  float _1295 = exp2(log2(max(0.0f, (lerp(_1272, cb0_013z, cb0_013w)))) * cb0_040y);
  if ((uint)(WorkingColorSpace_320) == 0) {
    float _1314 = mad((WorkingColorSpace_128[0].z), _1295, mad((WorkingColorSpace_128[0].y), _1294, ((WorkingColorSpace_128[0].x) * _1293)));
    float _1317 = mad((WorkingColorSpace_128[1].z), _1295, mad((WorkingColorSpace_128[1].y), _1294, ((WorkingColorSpace_128[1].x) * _1293)));
    float _1320 = mad((WorkingColorSpace_128[2].z), _1295, mad((WorkingColorSpace_128[2].y), _1294, ((WorkingColorSpace_128[2].x) * _1293)));
    _1331 = mad(_45, _1320, mad(_44, _1317, (_1314 * _43)));
    _1332 = mad(_48, _1320, mad(_47, _1317, (_1314 * _46)));
    _1333 = mad(_51, _1320, mad(_50, _1317, (_1314 * _49)));
  } else {
    _1331 = _1293;
    _1332 = _1294;
    _1333 = _1295;
  }
  if (_1331 < 0.0031306699384003878f) {
    _1344 = (_1331 * 12.920000076293945f);
  } else {
    _1344 = (((pow(_1331, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1332 < 0.0031306699384003878f) {
    _1355 = (_1332 * 12.920000076293945f);
  } else {
    _1355 = (((pow(_1332, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1333 < 0.0031306699384003878f) {
    _1366 = (_1333 * 12.920000076293945f);
  } else {
    _1366 = (((pow(_1333, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  SV_Target.x = (_1344 * 0.9523810148239136f);
  SV_Target.y = (_1355 * 0.9523810148239136f);
  SV_Target.z = (_1366 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  return SV_Target;
}
