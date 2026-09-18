// Found in Blood of Dawnwalker

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
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
  float cb0_012w : packoffset(c012.w);
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
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_040y : packoffset(c040.y);
  float cb0_040z : packoffset(c040.z);
  int cb0_040w : packoffset(c040.w);
  int cb0_041x : packoffset(c041.x);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
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
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  float _23[6];
  float _35 = 0.5f / cb0_035x;
  float _40 = cb0_035x + -1.0f;
  float _41 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _35)) / _40;
  float _42 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _35)) / _40;
  float _44 = float((uint)SV_DispatchThreadID.z) / _40;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _130;
  float _131;
  float _132;
  float _655;
  float _688;
  float _702;
  float _766;
  float _945;
  float _956;
  float _967;
  float _1164;
  float _1165;
  float _1166;
  float _1177;
  float _1188;
  float _1361;
  float _1376;
  float _1391;
  float _1399;
  float _1400;
  float _1401;
  float _1468;
  float _1501;
  float _1515;
  float _1554;
  float _1670;
  float _1756;
  float _1830;
  float _1909;
  float _1910;
  float _1911;
  float _2041;
  float _2056;
  float _2071;
  float _2079;
  float _2080;
  float _2081;
  float _2148;
  float _2181;
  float _2195;
  float _2234;
  float _2356;
  float _2442;
  float _2528;
  float _2607;
  float _2608;
  float _2609;
  float _2786;
  float _2787;
  float _2788;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _53 = (cb0_041x == 4);
        _64 = select(_53, 1.0f, 1.705051064491272f);
        _65 = select(_53, 0.0f, -0.6217921376228333f);
        _66 = select(_53, 0.0f, -0.0832589864730835f);
        _67 = select(_53, 0.0f, -0.13025647401809692f);
        _68 = select(_53, 1.0f, 1.140804648399353f);
        _69 = select(_53, 0.0f, -0.010548308491706848f);
        _70 = select(_53, 0.0f, -0.024003351107239723f);
        _71 = select(_53, 0.0f, -0.1289689838886261f);
        _72 = select(_53, 1.0f, 1.1529725790023804f);
      } else {
        _64 = 0.6954522132873535f;
        _65 = 0.14067870378494263f;
        _66 = 0.16386906802654266f;
        _67 = 0.044794563204050064f;
        _68 = 0.8596711158752441f;
        _69 = 0.0955343171954155f;
        _70 = -0.005525882821530104f;
        _71 = 0.004025210160762072f;
        _72 = 1.0015007257461548f;
      }
    } else {
      _64 = 1.0258246660232544f;
      _65 = -0.020053181797266006f;
      _66 = -0.005771636962890625f;
      _67 = -0.002234415616840124f;
      _68 = 1.0045864582061768f;
      _69 = -0.002352118492126465f;
      _70 = -0.005013350863009691f;
      _71 = -0.025290070101618767f;
      _72 = 1.0303035974502563f;
    }
  } else {
    _64 = 1.3792141675949097f;
    _65 = -0.30886411666870117f;
    _66 = -0.0703500509262085f;
    _67 = -0.06933490186929703f;
    _68 = 1.08229660987854f;
    _69 = -0.012961871922016144f;
    _70 = -0.0021590073592960835f;
    _71 = -0.0454593189060688f;
    _72 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _83 = (pow(_41, 0.012683313339948654f));
    float _84 = (pow(_42, 0.012683313339948654f));
    float _85 = (pow(_44, 0.012683313339948654f));
    _130 = (exp2(log2(max(0.0f, (_83 + -0.8359375f)) / (18.8515625f - (_83 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _131 = (exp2(log2(max(0.0f, (_84 + -0.8359375f)) / (18.8515625f - (_84 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _132 = (exp2(log2(max(0.0f, (_85 + -0.8359375f)) / (18.8515625f - (_85 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _130 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _131 = ((exp2((_42 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _132 = ((exp2((_44 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _147 = mad((WorkingColorSpace_128[0].z), _132, mad((WorkingColorSpace_128[0].y), _131, ((WorkingColorSpace_128[0].x) * _130)));
  float _150 = mad((WorkingColorSpace_128[1].z), _132, mad((WorkingColorSpace_128[1].y), _131, ((WorkingColorSpace_128[1].x) * _130)));
  float _153 = mad((WorkingColorSpace_128[2].z), _132, mad((WorkingColorSpace_128[2].y), _131, ((WorkingColorSpace_128[2].x) * _130)));
  float _154 = dot(float3(_147, _150, _153), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _158 = (_147 / _154) + -1.0f;
  float _159 = (_150 / _154) + -1.0f;
  float _160 = (_153 / _154) + -1.0f;
  float _172 = (1.0f - exp2(((_154 * _154) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_158, _159, _160), float3(_158, _159, _160)) * -4.0f));
  float _188 = ((mad(-0.06368321925401688f, _153, mad(-0.3292922377586365f, _150, (_147 * 1.3704125881195068f))) - _147) * _172) + _147;
  float _189 = ((mad(-0.010861365124583244f, _153, mad(1.0970927476882935f, _150, (_147 * -0.08343357592821121f))) - _150) * _172) + _150;
  float _190 = ((mad(1.2036951780319214f, _153, mad(-0.09862580895423889f, _150, (_147 * -0.02579331398010254f))) - _153) * _172) + _153;
  float _191 = dot(float3(_188, _189, _190), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _205 = cb0_019w + cb0_024w;
  float _219 = cb0_018w * cb0_023w;
  float _233 = cb0_017w * cb0_022w;
  float _247 = cb0_016w * cb0_021w;
  float _261 = cb0_015w * cb0_020w;
  float _265 = _188 - _191;
  float _266 = _189 - _191;
  float _267 = _190 - _191;
  float _324 = saturate(_191 / cb0_035w);
  float _328 = (_324 * _324) * (3.0f - (_324 * 2.0f));
  float _329 = 1.0f - _328;
  float _338 = cb0_019w + cb0_034w;
  float _347 = cb0_018w * cb0_033w;
  float _356 = cb0_017w * cb0_032w;
  float _365 = cb0_016w * cb0_031w;
  float _374 = cb0_015w * cb0_030w;
  float _437 = saturate((_191 - cb0_036x) / (cb0_036y - cb0_036x));
  float _441 = (_437 * _437) * (3.0f - (_437 * 2.0f));
  float _450 = cb0_019w + cb0_029w;
  float _459 = cb0_018w * cb0_028w;
  float _468 = cb0_017w * cb0_027w;
  float _477 = cb0_016w * cb0_026w;
  float _486 = cb0_015w * cb0_025w;
  float _544 = _328 - _441;
  float _555 = ((_441 * (((cb0_019x + cb0_034x) + _338) + (((cb0_018x * cb0_033x) * _347) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _365) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _374) * _265) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _356)))))) + (_329 * (((cb0_019x + cb0_024x) + _205) + (((cb0_018x * cb0_023x) * _219) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _247) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _261) * _265) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _233))))))) + ((((cb0_019x + cb0_029x) + _450) + (((cb0_018x * cb0_028x) * _459) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _477) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _486) * _265) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _468))))) * _544);
  float _557 = ((_441 * (((cb0_019y + cb0_034y) + _338) + (((cb0_018y * cb0_033y) * _347) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _365) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _374) * _266) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _356)))))) + (_329 * (((cb0_019y + cb0_024y) + _205) + (((cb0_018y * cb0_023y) * _219) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _247) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _261) * _266) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _233))))))) + ((((cb0_019y + cb0_029y) + _450) + (((cb0_018y * cb0_028y) * _459) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _477) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _486) * _266) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _468))))) * _544);
  float _559 = ((_441 * (((cb0_019z + cb0_034z) + _338) + (((cb0_018z * cb0_033z) * _347) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _365) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _374) * _267) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _356)))))) + (_329 * (((cb0_019z + cb0_024z) + _205) + (((cb0_018z * cb0_023z) * _219) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _247) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _261) * _267) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _233))))))) + ((((cb0_019z + cb0_029z) + _450) + (((cb0_018z * cb0_028z) * _459) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _477) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _486) * _267) + _191)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _468))))) * _544);

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

  float4 output = ProcessLutbuilder(float3(_555, _557, _559), s0, s1, t0, t1, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _595 = ((mad(0.061360642313957214f, _559, mad(-4.540197551250458e-09f, _557, (_555 * 0.9386394023895264f))) - _555) * cb0_036z) + _555;
  float _596 = ((mad(0.169205904006958f, _559, mad(0.8307942152023315f, _557, (_555 * 6.775371730327606e-08f))) - _557) * cb0_036z) + _557;
  float _597 = (mad(-2.3283064365386963e-10f, _557, (_555 * -9.313225746154785e-10f)) * cb0_036z) + _559;
  float _600 = mad(0.16386905312538147f, _597, mad(0.14067868888378143f, _596, (_595 * 0.6954522132873535f)));
  float _603 = mad(0.0955343246459961f, _597, mad(0.8596711158752441f, _596, (_595 * 0.044794581830501556f)));
  float _606 = mad(1.0015007257461548f, _597, mad(0.004025210160762072f, _596, (_595 * -0.005525882821530104f)));
  float _610 = max(max(_600, _603), _606);
  float _615 = (max(_610, 1.000000013351432e-10f) - max(min(min(_600, _603), _606), 1.000000013351432e-10f)) / max(_610, 0.009999999776482582f);
  float _628 = ((_603 + _600) + _606) + (sqrt((((_606 - _603) * _606) + ((_603 - _600) * _603)) + ((_600 - _606) * _600)) * 1.75f);
  float _629 = _628 * 0.3333333432674408f;
  float _630 = _615 + -0.4000000059604645f;
  float _631 = _630 * 5.0f;
  float _635 = max((1.0f - abs(_630 * 2.5f)), 0.0f);
  float _646 = ((float((int)(((int)(uint)((bool)(_631 > 0.0f))) - ((int)(uint)((bool)(_631 < 0.0f))))) * (1.0f - (_635 * _635))) + 1.0f) * 0.02500000037252903f;
  if (!(_629 <= 0.0533333346247673f)) {
    if (!(_629 >= 0.1599999964237213f)) {
      _655 = (((0.23999999463558197f / _628) + -0.5f) * _646);
    } else {
      _655 = 0.0f;
    }
  } else {
    _655 = _646;
  }
  float _656 = _655 + 1.0f;
  float _657 = _656 * _600;
  float _658 = _656 * _603;
  float _659 = _656 * _606;
  if (!((bool)(_657 == _658) && (bool)(_658 == _659))) {
    float _666 = ((_657 * 2.0f) - _658) - _659;
    float _669 = ((_603 - _606) * 1.7320507764816284f) * _656;
    float _671 = atan(_669 / _666);
    bool _674 = (_666 < 0.0f);
    bool _675 = (_666 == 0.0f);
    bool _676 = (_669 >= 0.0f);
    bool _677 = (_669 < 0.0f);
    _688 = select((_676 && _675), 90.0f, select((_677 && _675), -90.0f, (select((_677 && _674), (_671 + -3.1415927410125732f), select((_676 && _674), (_671 + 3.1415927410125732f), _671)) * 57.2957763671875f)));
  } else {
    _688 = 0.0f;
  }
  float _693 = min(max(select((_688 < 0.0f), (_688 + 360.0f), _688), 0.0f), 360.0f);
  if (_693 < -180.0f) {
    _702 = (_693 + 360.0f);
  } else {
    if (_693 > 180.0f) {
      _702 = (_693 + -360.0f);
    } else {
      _702 = _693;
    }
  }
  float _706 = saturate(1.0f - abs(_702 * 0.014814814552664757f));
  float _710 = (_706 * _706) * (3.0f - (_706 * 2.0f));
  float _716 = ((_710 * _710) * ((_615 * 0.18000000715255737f) * (0.029999999329447746f - _657))) + _657;
  float _726 = max(0.0f, mad(-0.21492856740951538f, _659, mad(-0.2365107536315918f, _658, (_716 * 1.4514392614364624f))));
  float _727 = max(0.0f, mad(-0.09967592358589172f, _659, mad(1.17622971534729f, _658, (_716 * -0.07655377686023712f))));
  float _728 = max(0.0f, mad(0.9977163076400757f, _659, mad(-0.006032449658960104f, _658, (_716 * 0.008316148072481155f))));
  float _729 = dot(float3(_726, _727, _728), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _744 = (cb0_038x + 1.0f) - cb0_037z;
  float _746 = cb0_038y + 1.0f;
  float _748 = _746 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _766 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _757 = (cb0_038x + 0.18000000715255737f) / _744;
    _766 = (-0.7447274923324585f - ((log2(_757 / (2.0f - _757)) * 0.3465735912322998f) * (_744 / cb0_037y)));
  }
  float _769 = ((1.0f - cb0_037z) / cb0_037y) - _766;
  float _771 = (cb0_037w / cb0_037y) - _769;
  float _775 = log2(lerp(_729, _726, 0.9599999785423279f)) * 0.3010300099849701f;
  float _776 = log2(lerp(_729, _727, 0.9599999785423279f)) * 0.3010300099849701f;
  float _777 = log2(lerp(_729, _728, 0.9599999785423279f)) * 0.3010300099849701f;
  float _781 = cb0_037y * (_775 + _769);
  float _782 = cb0_037y * (_776 + _769);
  float _783 = cb0_037y * (_777 + _769);
  float _784 = _744 * 2.0f;
  float _786 = (cb0_037y * -2.0f) / _744;
  float _787 = _775 - _766;
  float _788 = _776 - _766;
  float _789 = _777 - _766;
  float _808 = _748 * 2.0f;
  float _810 = (cb0_037y * 2.0f) / _748;
  float _835 = select((_775 < _766), ((_784 / (exp2((_787 * 1.4426950216293335f) * _786) + 1.0f)) - cb0_038x), _781);
  float _836 = select((_776 < _766), ((_784 / (exp2((_788 * 1.4426950216293335f) * _786) + 1.0f)) - cb0_038x), _782);
  float _837 = select((_777 < _766), ((_784 / (exp2((_789 * 1.4426950216293335f) * _786) + 1.0f)) - cb0_038x), _783);
  float _844 = _771 - _766;
  float _848 = saturate(_787 / _844);
  float _849 = saturate(_788 / _844);
  float _850 = saturate(_789 / _844);
  bool _851 = (_771 < _766);
  float _855 = select(_851, (1.0f - _848), _848);
  float _856 = select(_851, (1.0f - _849), _849);
  float _857 = select(_851, (1.0f - _850), _850);
  float _876 = (((_855 * _855) * (select((_775 > _771), (_746 - (_808 / (exp2(((_775 - _771) * 1.4426950216293335f) * _810) + 1.0f))), _781) - _835)) * (3.0f - (_855 * 2.0f))) + _835;
  float _877 = (((_856 * _856) * (select((_776 > _771), (_746 - (_808 / (exp2(((_776 - _771) * 1.4426950216293335f) * _810) + 1.0f))), _782) - _836)) * (3.0f - (_856 * 2.0f))) + _836;
  float _878 = (((_857 * _857) * (select((_777 > _771), (_746 - (_808 / (exp2(((_777 - _771) * 1.4426950216293335f) * _810) + 1.0f))), _783) - _837)) * (3.0f - (_857 * 2.0f))) + _837;
  float _879 = dot(float3(_876, _877, _878), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _899 = (cb0_037x * (max(0.0f, (lerp(_879, _876, 0.9300000071525574f))) - _595)) + _595;
  float _900 = (cb0_037x * (max(0.0f, (lerp(_879, _877, 0.9300000071525574f))) - _596)) + _596;
  float _901 = (cb0_037x * (max(0.0f, (lerp(_879, _878, 0.9300000071525574f))) - _597)) + _597;
  float _917 = ((mad(-0.06537103652954102f, _901, mad(1.451815478503704e-06f, _900, (_899 * 1.065374732017517f))) - _899) * cb0_036z) + _899;
  float _918 = ((mad(-0.20366770029067993f, _901, mad(1.2036634683609009f, _900, (_899 * -2.57161445915699e-07f))) - _900) * cb0_036z) + _900;
  float _919 = ((mad(0.9999996423721313f, _901, mad(2.0954757928848267e-08f, _900, (_899 * 1.862645149230957e-08f))) - _901) * cb0_036z) + _901;
  float _932 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _919, mad((WorkingColorSpace_192[0].y), _918, ((WorkingColorSpace_192[0].x) * _917)))));
  float _933 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _919, mad((WorkingColorSpace_192[1].y), _918, ((WorkingColorSpace_192[1].x) * _917)))));
  float _934 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _919, mad((WorkingColorSpace_192[2].y), _918, ((WorkingColorSpace_192[2].x) * _917)))));
  if (_932 < 0.0031306699384003878f) {
    _945 = (_932 * 12.920000076293945f);
  } else {
    _945 = (((pow(_932, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_933 < 0.0031306699384003878f) {
    _956 = (_933 * 12.920000076293945f);
  } else {
    _956 = (((pow(_933, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_934 < 0.0031306699384003878f) {
    _967 = (_934 * 12.920000076293945f);
  } else {
    _967 = (((pow(_934, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _971 = (_956 * 0.9375f) + 0.03125f;
  float _978 = _967 * 15.0f;
  float _979 = floor(_978);
  float _980 = _978 - _979;
  float _982 = (_979 + ((_945 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _985 = t0.SampleLevel(s0, float2(_982, _971), 0.0f);
  float _989 = _982 + 0.0625f;
  float4 _990 = t0.SampleLevel(s0, float2(_989, _971), 0.0f);
  float4 _1012 = t1.SampleLevel(s1, float2(_982, _971), 0.0f);
  float4 _1016 = t1.SampleLevel(s1, float2(_989, _971), 0.0f);
  float _1035 = max(6.103519990574569e-05f, ((((lerp(_985.x, _990.x, _980)) * cb0_005y) + (cb0_005x * _945)) + ((lerp(_1012.x, _1016.x, _980)) * cb0_005z)));
  float _1036 = max(6.103519990574569e-05f, ((((lerp(_985.y, _990.y, _980)) * cb0_005y) + (cb0_005x * _956)) + ((lerp(_1012.y, _1016.y, _980)) * cb0_005z)));
  float _1037 = max(6.103519990574569e-05f, ((((lerp(_985.z, _990.z, _980)) * cb0_005y) + (cb0_005x * _967)) + ((lerp(_1012.z, _1016.z, _980)) * cb0_005z)));
  float _1059 = select((_1035 > 0.040449999272823334f), exp2(log2((_1035 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1035 * 0.07739938050508499f));
  float _1060 = select((_1036 > 0.040449999272823334f), exp2(log2((_1036 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1036 * 0.07739938050508499f));
  float _1061 = select((_1037 > 0.040449999272823334f), exp2(log2((_1037 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1037 * 0.07739938050508499f));
  float _1087 = cb0_014x * (((cb0_039y + (cb0_039x * _1059)) * _1059) + cb0_039z);
  float _1088 = cb0_014y * (((cb0_039y + (cb0_039x * _1060)) * _1060) + cb0_039z);
  float _1089 = cb0_014z * (((cb0_039y + (cb0_039x * _1061)) * _1061) + cb0_039z);
  float _1096 = ((cb0_013x - _1087) * cb0_013w) + _1087;
  float _1097 = ((cb0_013y - _1088) * cb0_013w) + _1088;
  float _1098 = ((cb0_013z - _1089) * cb0_013w) + _1089;
  float _1099 = cb0_014x * mad((WorkingColorSpace_192[0].z), _559, mad((WorkingColorSpace_192[0].y), _557, (_555 * (WorkingColorSpace_192[0].x))));
  float _1100 = cb0_014y * mad((WorkingColorSpace_192[1].z), _559, mad((WorkingColorSpace_192[1].y), _557, ((WorkingColorSpace_192[1].x) * _555)));
  float _1101 = cb0_014z * mad((WorkingColorSpace_192[2].z), _559, mad((WorkingColorSpace_192[2].y), _557, ((WorkingColorSpace_192[2].x) * _555)));
  float _1108 = ((cb0_013x - _1099) * cb0_013w) + _1099;
  float _1109 = ((cb0_013y - _1100) * cb0_013w) + _1100;
  float _1110 = ((cb0_013z - _1101) * cb0_013w) + _1101;
  float _1122 = exp2(log2(max(0.0f, _1096)) * cb0_040y);
  float _1123 = exp2(log2(max(0.0f, _1097)) * cb0_040y);
  float _1124 = exp2(log2(max(0.0f, _1098)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1147 = mad((WorkingColorSpace_128[0].z), _1124, mad((WorkingColorSpace_128[0].y), _1123, ((WorkingColorSpace_128[0].x) * _1122)));
        float _1150 = mad((WorkingColorSpace_128[1].z), _1124, mad((WorkingColorSpace_128[1].y), _1123, ((WorkingColorSpace_128[1].x) * _1122)));
        float _1153 = mad((WorkingColorSpace_128[2].z), _1124, mad((WorkingColorSpace_128[2].y), _1123, ((WorkingColorSpace_128[2].x) * _1122)));
        _1164 = mad(_66, _1153, mad(_65, _1150, (_1147 * _64)));
        _1165 = mad(_69, _1153, mad(_68, _1150, (_1147 * _67)));
        _1166 = mad(_72, _1153, mad(_71, _1150, (_1147 * _70)));
      } else {
        _1164 = _1122;
        _1165 = _1123;
        _1166 = _1124;
      }
      do {
        if (_1164 < 0.0031306699384003878f) {
          _1177 = (_1164 * 12.920000076293945f);
        } else {
          _1177 = (((pow(_1164, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1165 < 0.0031306699384003878f) {
            _1188 = (_1165 * 12.920000076293945f);
          } else {
            _1188 = (((pow(_1165, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1166 < 0.0031306699384003878f) {
            _2786 = _1177;
            _2787 = _1188;
            _2788 = (_1166 * 12.920000076293945f);
          } else {
            _2786 = _1177;
            _2787 = _1188;
            _2788 = (((pow(_1166, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1215 = mad((WorkingColorSpace_128[0].z), _1124, mad((WorkingColorSpace_128[0].y), _1123, ((WorkingColorSpace_128[0].x) * _1122)));
      float _1218 = mad((WorkingColorSpace_128[1].z), _1124, mad((WorkingColorSpace_128[1].y), _1123, ((WorkingColorSpace_128[1].x) * _1122)));
      float _1221 = mad((WorkingColorSpace_128[2].z), _1124, mad((WorkingColorSpace_128[2].y), _1123, ((WorkingColorSpace_128[2].x) * _1122)));
      float _1231 = max(6.103519990574569e-05f, mad(_66, _1221, mad(_65, _1218, (_1215 * _64))));
      float _1232 = max(6.103519990574569e-05f, mad(_69, _1221, mad(_68, _1218, (_1215 * _67))));
      float _1233 = max(6.103519990574569e-05f, mad(_72, _1221, mad(_71, _1218, (_1215 * _70))));
      _2786 = min((_1231 * 4.5f), ((exp2(log2(max(_1231, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2787 = min((_1232 * 4.5f), ((exp2(log2(max(_1232, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2788 = min((_1233 * 4.5f), ((exp2(log2(max(_1233, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1309 = cb0_012z * _1108;
        float _1310 = cb0_012z * _1109;
        float _1311 = cb0_012z * _1110;
        float _1314 = mad((WorkingColorSpace_256[0].z), _1311, mad((WorkingColorSpace_256[0].y), _1310, ((WorkingColorSpace_256[0].x) * _1309)));
        float _1317 = mad((WorkingColorSpace_256[1].z), _1311, mad((WorkingColorSpace_256[1].y), _1310, ((WorkingColorSpace_256[1].x) * _1309)));
        float _1320 = mad((WorkingColorSpace_256[2].z), _1311, mad((WorkingColorSpace_256[2].y), _1310, ((WorkingColorSpace_256[2].x) * _1309)));
        float _1323 = mad(-0.21492856740951538f, _1320, mad(-0.2365107536315918f, _1317, (_1314 * 1.4514392614364624f)));
        float _1326 = mad(-0.09967592358589172f, _1320, mad(1.17622971534729f, _1317, (_1314 * -0.07655377686023712f)));
        float _1329 = mad(0.9977163076400757f, _1320, mad(-0.006032449658960104f, _1317, (_1314 * 0.008316148072481155f)));
        float _1331 = max(_1323, max(_1326, _1329));
        do {
          if (!(_1331 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1314 < 0.0f) || (bool)(_1317 < 0.0f))) || (bool)(_1320 < 0.0f))) {
              float _1341 = abs(_1331);
              float _1342 = (_1331 - _1323) / _1341;
              float _1344 = (_1331 - _1326) / _1341;
              float _1346 = (_1331 - _1329) / _1341;
              do {
                if (!(_1342 < 0.8149999976158142f)) {
                  float _1349 = _1342 + -0.8149999976158142f;
                  _1361 = ((_1349 / exp2(log2(exp2(log2(_1349 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1361 = _1342;
                }
                do {
                  if (!(_1344 < 0.8029999732971191f)) {
                    float _1364 = _1344 + -0.8029999732971191f;
                    _1376 = ((_1364 / exp2(log2(exp2(log2(_1364 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1376 = _1344;
                  }
                  do {
                    if (!(_1346 < 0.8799999952316284f)) {
                      float _1379 = _1346 + -0.8799999952316284f;
                      _1391 = ((_1379 / exp2(log2(exp2(log2(_1379 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1391 = _1346;
                    }
                    _1399 = (_1331 - (_1341 * _1361));
                    _1400 = (_1331 - (_1341 * _1376));
                    _1401 = (_1331 - (_1341 * _1391));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1399 = _1323;
              _1400 = _1326;
              _1401 = _1329;
            }
          } else {
            _1399 = _1323;
            _1400 = _1326;
            _1401 = _1329;
          }
          float _1417 = ((mad(0.16386906802654266f, _1401, mad(0.14067870378494263f, _1400, (_1399 * 0.6954522132873535f))) - _1314) * cb0_012w) + _1314;
          float _1418 = ((mad(0.0955343171954155f, _1401, mad(0.8596711158752441f, _1400, (_1399 * 0.044794563204050064f))) - _1317) * cb0_012w) + _1317;
          float _1419 = ((mad(1.0015007257461548f, _1401, mad(0.004025210160762072f, _1400, (_1399 * -0.005525882821530104f))) - _1320) * cb0_012w) + _1320;
          float _1423 = max(max(_1417, _1418), _1419);
          float _1428 = (max(_1423, 1.000000013351432e-10f) - max(min(min(_1417, _1418), _1419), 1.000000013351432e-10f)) / max(_1423, 0.009999999776482582f);
          float _1441 = ((_1418 + _1417) + _1419) + (sqrt((((_1419 - _1418) * _1419) + ((_1418 - _1417) * _1418)) + ((_1417 - _1419) * _1417)) * 1.75f);
          float _1442 = _1441 * 0.3333333432674408f;
          float _1443 = _1428 + -0.4000000059604645f;
          float _1444 = _1443 * 5.0f;
          float _1448 = max((1.0f - abs(_1443 * 2.5f)), 0.0f);
          float _1459 = ((float((int)(((int)(uint)((bool)(_1444 > 0.0f))) - ((int)(uint)((bool)(_1444 < 0.0f))))) * (1.0f - (_1448 * _1448))) + 1.0f) * 0.02500000037252903f;
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
            float _1470 = _1469 * _1417;
            float _1471 = _1469 * _1418;
            float _1472 = _1469 * _1419;
            do {
              if (!((bool)(_1470 == _1471) && (bool)(_1471 == _1472))) {
                float _1479 = ((_1470 * 2.0f) - _1471) - _1472;
                float _1482 = ((_1418 - _1419) * 1.7320507764816284f) * _1469;
                float _1484 = atan(_1482 / _1479);
                bool _1487 = (_1479 < 0.0f);
                bool _1488 = (_1479 == 0.0f);
                bool _1489 = (_1482 >= 0.0f);
                bool _1490 = (_1482 < 0.0f);
                _1501 = select((_1489 && _1488), 90.0f, select((_1490 && _1488), -90.0f, (select((_1490 && _1487), (_1484 + -3.1415927410125732f), select((_1489 && _1487), (_1484 + 3.1415927410125732f), _1484)) * 57.2957763671875f)));
              } else {
                _1501 = 0.0f;
              }
              float _1506 = min(max(select((_1501 < 0.0f), (_1501 + 360.0f), _1501), 0.0f), 360.0f);
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
                    float _1524 = _1521 - float((int)(_1522));
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
                  _21[0] = cb0_010x;
                  _21[1] = cb0_010y;
                  _21[2] = cb0_010z;
                  _21[3] = cb0_010w;
                  _21[4] = cb0_012x;
                  _21[5] = cb0_012x;
                  float _1598 = log2(max((lerp(_1581, _1578, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1599 = _1598 * 0.3010300099849701f;
                  float _1600 = log2(cb0_008x);
                  float _1601 = _1600 * 0.3010300099849701f;
                  do {
                    if (!(!(_1599 <= _1601))) {
                      _1670 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1608 = log2(cb0_009x);
                      float _1609 = _1608 * 0.3010300099849701f;
                      if ((bool)(_1599 > _1601) && (bool)(_1599 < _1609)) {
                        float _1617 = ((_1598 - _1600) * 0.9030900001525879f) / ((_1608 - _1600) * 0.3010300099849701f);
                        int _1618 = int(_1617);
                        float _1620 = _1617 - float((int)(_1618));
                        float _1622 = _21[_1618];
                        float _1625 = _21[(_1618 + 1)];
                        float _1630 = _1622 * 0.5f;
                        _1670 = dot(float3((_1620 * _1620), _1620, 1.0f), float3(mad((_21[(_1618 + 2)]), 0.5f, mad(_1625, -1.0f, _1630)), (_1625 - _1622), mad(_1625, 0.5f, _1630)));
                      } else {
                        do {
                          if (!(!(_1599 >= _1609))) {
                            float _1639 = log2(cb0_008z);
                            if (_1599 < (_1639 * 0.3010300099849701f)) {
                              float _1647 = ((_1598 - _1608) * 0.9030900001525879f) / ((_1639 - _1608) * 0.3010300099849701f);
                              int _1648 = int(_1647);
                              float _1650 = _1647 - float((int)(_1648));
                              float _1652 = _14[_1648];
                              float _1655 = _14[(_1648 + 1)];
                              float _1660 = _1652 * 0.5f;
                              _1670 = dot(float3((_1650 * _1650), _1650, 1.0f), float3(mad((_14[(_1648 + 2)]), 0.5f, mad(_1655, -1.0f, _1660)), (_1655 - _1652), mad(_1655, 0.5f, _1660)));
                              break;
                            }
                          }
                          _1670 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _22[0] = cb0_010x;
                    _22[1] = cb0_010y;
                    _22[2] = cb0_010z;
                    _22[3] = cb0_010w;
                    _22[4] = cb0_012x;
                    _22[5] = cb0_012x;
                    _23[0] = cb0_011x;
                    _23[1] = cb0_011y;
                    _23[2] = cb0_011z;
                    _23[3] = cb0_011w;
                    _23[4] = cb0_012y;
                    _23[5] = cb0_012y;
                    float _1686 = log2(max((lerp(_1581, _1579, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1687 = _1686 * 0.3010300099849701f;
                    do {
                      if (!(!(_1687 <= _1601))) {
                        _1756 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1694 = log2(cb0_009x);
                        float _1695 = _1694 * 0.3010300099849701f;
                        if ((bool)(_1687 > _1601) && (bool)(_1687 < _1695)) {
                          float _1703 = ((_1686 - _1600) * 0.9030900001525879f) / ((_1694 - _1600) * 0.3010300099849701f);
                          int _1704 = int(_1703);
                          float _1706 = _1703 - float((int)(_1704));
                          float _1708 = _22[_1704];
                          float _1711 = _22[(_1704 + 1)];
                          float _1716 = _1708 * 0.5f;
                          _1756 = dot(float3((_1706 * _1706), _1706, 1.0f), float3(mad((_22[(_1704 + 2)]), 0.5f, mad(_1711, -1.0f, _1716)), (_1711 - _1708), mad(_1711, 0.5f, _1716)));
                        } else {
                          do {
                            if (!(!(_1687 >= _1695))) {
                              float _1725 = log2(cb0_008z);
                              if (_1687 < (_1725 * 0.3010300099849701f)) {
                                float _1733 = ((_1686 - _1694) * 0.9030900001525879f) / ((_1725 - _1694) * 0.3010300099849701f);
                                int _1734 = int(_1733);
                                float _1736 = _1733 - float((int)(_1734));
                                float _1738 = _23[_1734];
                                float _1741 = _23[(_1734 + 1)];
                                float _1746 = _1738 * 0.5f;
                                _1756 = dot(float3((_1736 * _1736), _1736, 1.0f), float3(mad((_23[(_1734 + 2)]), 0.5f, mad(_1741, -1.0f, _1746)), (_1741 - _1738), mad(_1741, 0.5f, _1746)));
                                break;
                              }
                            }
                            _1756 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1760 = log2(max((lerp(_1581, _1580, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1761 = _1760 * 0.3010300099849701f;
                      do {
                        if (!(!(_1761 <= _1601))) {
                          _1830 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1768 = log2(cb0_009x);
                          float _1769 = _1768 * 0.3010300099849701f;
                          if ((bool)(_1761 > _1601) && (bool)(_1761 < _1769)) {
                            float _1777 = ((_1760 - _1600) * 0.9030900001525879f) / ((_1768 - _1600) * 0.3010300099849701f);
                            int _1778 = int(_1777);
                            float _1780 = _1777 - float((int)(_1778));
                            float _1782 = _13[_1778];
                            float _1785 = _13[(_1778 + 1)];
                            float _1790 = _1782 * 0.5f;
                            _1830 = dot(float3((_1780 * _1780), _1780, 1.0f), float3(mad((_13[(_1778 + 2)]), 0.5f, mad(_1785, -1.0f, _1790)), (_1785 - _1782), mad(_1785, 0.5f, _1790)));
                          } else {
                            do {
                              if (!(!(_1761 >= _1769))) {
                                float _1799 = log2(cb0_008z);
                                if (_1761 < (_1799 * 0.3010300099849701f)) {
                                  float _1807 = ((_1760 - _1768) * 0.9030900001525879f) / ((_1799 - _1768) * 0.3010300099849701f);
                                  int _1808 = int(_1807);
                                  float _1810 = _1807 - float((int)(_1808));
                                  float _1812 = _14[_1808];
                                  float _1815 = _14[(_1808 + 1)];
                                  float _1820 = _1812 * 0.5f;
                                  _1830 = dot(float3((_1810 * _1810), _1810, 1.0f), float3(mad((_14[(_1808 + 2)]), 0.5f, mad(_1815, -1.0f, _1820)), (_1815 - _1812), mad(_1815, 0.5f, _1820)));
                                  break;
                                }
                              }
                              _1830 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1834 = cb0_008w - cb0_008y;
                        float _1835 = (exp2(_1670 * 3.321928024291992f) - cb0_008y) / _1834;
                        float _1837 = (exp2(_1756 * 3.321928024291992f) - cb0_008y) / _1834;
                        float _1839 = (exp2(_1830 * 3.321928024291992f) - cb0_008y) / _1834;
                        float _1842 = mad(0.15618768334388733f, _1839, mad(0.13400420546531677f, _1837, (_1835 * 0.6624541878700256f)));
                        float _1845 = mad(0.053689517080783844f, _1839, mad(0.6740817427635193f, _1837, (_1835 * 0.2722287178039551f)));
                        float _1848 = mad(1.0103391408920288f, _1839, mad(0.00406073359772563f, _1837, (_1835 * -0.005574649665504694f)));
                        float _1861 = min(max(mad(-0.23642469942569733f, _1848, mad(-0.32480329275131226f, _1845, (_1842 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1862 = min(max(mad(0.016756348311901093f, _1848, mad(1.6153316497802734f, _1845, (_1842 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1863 = min(max(mad(0.9883948564529419f, _1848, mad(-0.008284442126750946f, _1845, (_1842 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1866 = mad(0.15618768334388733f, _1863, mad(0.13400420546531677f, _1862, (_1861 * 0.6624541878700256f)));
                        float _1869 = mad(0.053689517080783844f, _1863, mad(0.6740817427635193f, _1862, (_1861 * 0.2722287178039551f)));
                        float _1872 = mad(1.0103391408920288f, _1863, mad(0.00406073359772563f, _1862, (_1861 * -0.005574649665504694f)));
                        float _1894 = min(max((min(max(mad(-0.23642469942569733f, _1872, mad(-0.32480329275131226f, _1869, (_1866 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1895 = min(max((min(max(mad(0.016756348311901093f, _1872, mad(1.6153316497802734f, _1869, (_1866 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1896 = min(max((min(max(mad(0.9883948564529419f, _1872, mad(-0.008284442126750946f, _1869, (_1866 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _1909 = mad(_66, _1896, mad(_65, _1895, (_1894 * _64)));
                            _1910 = mad(_69, _1896, mad(_68, _1895, (_1894 * _67)));
                            _1911 = mad(_72, _1896, mad(_71, _1895, (_1894 * _70)));
                          } else {
                            _1909 = _1894;
                            _1910 = _1895;
                            _1911 = _1896;
                          }
                          float _1921 = exp2(log2(_1909 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1922 = exp2(log2(_1910 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1923 = exp2(log2(_1911 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2786 = exp2(log2((1.0f / ((_1921 * 18.6875f) + 1.0f)) * ((_1921 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2787 = exp2(log2((1.0f / ((_1922 * 18.6875f) + 1.0f)) * ((_1922 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2788 = exp2(log2((1.0f / ((_1923 * 18.6875f) + 1.0f)) * ((_1923 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        } while (false);
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
          float _1989 = cb0_012z * _1108;
          float _1990 = cb0_012z * _1109;
          float _1991 = cb0_012z * _1110;
          float _1994 = mad((WorkingColorSpace_256[0].z), _1991, mad((WorkingColorSpace_256[0].y), _1990, ((WorkingColorSpace_256[0].x) * _1989)));
          float _1997 = mad((WorkingColorSpace_256[1].z), _1991, mad((WorkingColorSpace_256[1].y), _1990, ((WorkingColorSpace_256[1].x) * _1989)));
          float _2000 = mad((WorkingColorSpace_256[2].z), _1991, mad((WorkingColorSpace_256[2].y), _1990, ((WorkingColorSpace_256[2].x) * _1989)));
          float _2003 = mad(-0.21492856740951538f, _2000, mad(-0.2365107536315918f, _1997, (_1994 * 1.4514392614364624f)));
          float _2006 = mad(-0.09967592358589172f, _2000, mad(1.17622971534729f, _1997, (_1994 * -0.07655377686023712f)));
          float _2009 = mad(0.9977163076400757f, _2000, mad(-0.006032449658960104f, _1997, (_1994 * 0.008316148072481155f)));
          float _2011 = max(_2003, max(_2006, _2009));
          do {
            if (!(_2011 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1994 < 0.0f) || (bool)(_1997 < 0.0f))) || (bool)(_2000 < 0.0f))) {
                float _2021 = abs(_2011);
                float _2022 = (_2011 - _2003) / _2021;
                float _2024 = (_2011 - _2006) / _2021;
                float _2026 = (_2011 - _2009) / _2021;
                do {
                  if (!(_2022 < 0.8149999976158142f)) {
                    float _2029 = _2022 + -0.8149999976158142f;
                    _2041 = ((_2029 / exp2(log2(exp2(log2(_2029 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2041 = _2022;
                  }
                  do {
                    if (!(_2024 < 0.8029999732971191f)) {
                      float _2044 = _2024 + -0.8029999732971191f;
                      _2056 = ((_2044 / exp2(log2(exp2(log2(_2044 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2056 = _2024;
                    }
                    do {
                      if (!(_2026 < 0.8799999952316284f)) {
                        float _2059 = _2026 + -0.8799999952316284f;
                        _2071 = ((_2059 / exp2(log2(exp2(log2(_2059 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2071 = _2026;
                      }
                      _2079 = (_2011 - (_2021 * _2041));
                      _2080 = (_2011 - (_2021 * _2056));
                      _2081 = (_2011 - (_2021 * _2071));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2079 = _2003;
                _2080 = _2006;
                _2081 = _2009;
              }
            } else {
              _2079 = _2003;
              _2080 = _2006;
              _2081 = _2009;
            }
            float _2097 = ((mad(0.16386906802654266f, _2081, mad(0.14067870378494263f, _2080, (_2079 * 0.6954522132873535f))) - _1994) * cb0_012w) + _1994;
            float _2098 = ((mad(0.0955343171954155f, _2081, mad(0.8596711158752441f, _2080, (_2079 * 0.044794563204050064f))) - _1997) * cb0_012w) + _1997;
            float _2099 = ((mad(1.0015007257461548f, _2081, mad(0.004025210160762072f, _2080, (_2079 * -0.005525882821530104f))) - _2000) * cb0_012w) + _2000;
            float _2103 = max(max(_2097, _2098), _2099);
            float _2108 = (max(_2103, 1.000000013351432e-10f) - max(min(min(_2097, _2098), _2099), 1.000000013351432e-10f)) / max(_2103, 0.009999999776482582f);
            float _2121 = ((_2098 + _2097) + _2099) + (sqrt((((_2099 - _2098) * _2099) + ((_2098 - _2097) * _2098)) + ((_2097 - _2099) * _2097)) * 1.75f);
            float _2122 = _2121 * 0.3333333432674408f;
            float _2123 = _2108 + -0.4000000059604645f;
            float _2124 = _2123 * 5.0f;
            float _2128 = max((1.0f - abs(_2123 * 2.5f)), 0.0f);
            float _2139 = ((float((int)(((int)(uint)((bool)(_2124 > 0.0f))) - ((int)(uint)((bool)(_2124 < 0.0f))))) * (1.0f - (_2128 * _2128))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2122 <= 0.0533333346247673f)) {
                if (!(_2122 >= 0.1599999964237213f)) {
                  _2148 = (((0.23999999463558197f / _2121) + -0.5f) * _2139);
                } else {
                  _2148 = 0.0f;
                }
              } else {
                _2148 = _2139;
              }
              float _2149 = _2148 + 1.0f;
              float _2150 = _2149 * _2097;
              float _2151 = _2149 * _2098;
              float _2152 = _2149 * _2099;
              do {
                if (!((bool)(_2150 == _2151) && (bool)(_2151 == _2152))) {
                  float _2159 = ((_2150 * 2.0f) - _2151) - _2152;
                  float _2162 = ((_2098 - _2099) * 1.7320507764816284f) * _2149;
                  float _2164 = atan(_2162 / _2159);
                  bool _2167 = (_2159 < 0.0f);
                  bool _2168 = (_2159 == 0.0f);
                  bool _2169 = (_2162 >= 0.0f);
                  bool _2170 = (_2162 < 0.0f);
                  _2181 = select((_2169 && _2168), 90.0f, select((_2170 && _2168), -90.0f, (select((_2170 && _2167), (_2164 + -3.1415927410125732f), select((_2169 && _2167), (_2164 + 3.1415927410125732f), _2164)) * 57.2957763671875f)));
                } else {
                  _2181 = 0.0f;
                }
                float _2186 = min(max(select((_2181 < 0.0f), (_2181 + 360.0f), _2181), 0.0f), 360.0f);
                do {
                  if (_2186 < -180.0f) {
                    _2195 = (_2186 + 360.0f);
                  } else {
                    if (_2186 > 180.0f) {
                      _2195 = (_2186 + -360.0f);
                    } else {
                      _2195 = _2186;
                    }
                  }
                  do {
                    if ((bool)(_2195 > -67.5f) && (bool)(_2195 < 67.5f)) {
                      float _2201 = (_2195 + 67.5f) * 0.029629629105329514f;
                      int _2202 = int(_2201);
                      float _2204 = _2201 - float((int)(_2202));
                      float _2205 = _2204 * _2204;
                      float _2206 = _2205 * _2204;
                      if (_2202 == 3) {
                        _2234 = (((0.1666666716337204f - (_2204 * 0.5f)) + (_2205 * 0.5f)) - (_2206 * 0.1666666716337204f));
                      } else {
                        if (_2202 == 2) {
                          _2234 = ((0.6666666865348816f - _2205) + (_2206 * 0.5f));
                        } else {
                          if (_2202 == 1) {
                            _2234 = (((_2206 * -0.5f) + 0.1666666716337204f) + ((_2205 + _2204) * 0.5f));
                          } else {
                            _2234 = select((_2202 == 0), (_2206 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2234 = 0.0f;
                    }
                    float _2243 = min(max(((((_2108 * 0.27000001072883606f) * (0.029999999329447746f - _2150)) * _2234) + _2150), 0.0f), 65535.0f);
                    float _2244 = min(max(_2151, 0.0f), 65535.0f);
                    float _2245 = min(max(_2152, 0.0f), 65535.0f);
                    float _2258 = min(max(mad(-0.21492856740951538f, _2245, mad(-0.2365107536315918f, _2244, (_2243 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2259 = min(max(mad(-0.09967592358589172f, _2245, mad(1.17622971534729f, _2244, (_2243 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2260 = min(max(mad(0.9977163076400757f, _2245, mad(-0.006032449658960104f, _2244, (_2243 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2261 = dot(float3(_2258, _2259, _2260), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2284 = log2(max((lerp(_2261, _2258, 0.9599999785423279f)), 1.000000013351432e-10f));
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
                          float _2308 = _19[_2304];
                          float _2311 = _19[(_2304 + 1)];
                          float _2316 = _2308 * 0.5f;
                          _2356 = dot(float3((_2306 * _2306), _2306, 1.0f), float3(mad((_19[(_2304 + 2)]), 0.5f, mad(_2311, -1.0f, _2316)), (_2311 - _2308), mad(_2311, 0.5f, _2316)));
                        } else {
                          do {
                            if (!(!(_2285 >= _2295))) {
                              float _2325 = log2(cb0_008z);
                              if (_2285 < (_2325 * 0.3010300099849701f)) {
                                float _2333 = ((_2284 - _2294) * 0.9030900001525879f) / ((_2325 - _2294) * 0.3010300099849701f);
                                int _2334 = int(_2333);
                                float _2336 = _2333 - float((int)(_2334));
                                float _2338 = _20[_2334];
                                float _2341 = _20[(_2334 + 1)];
                                float _2346 = _2338 * 0.5f;
                                _2356 = dot(float3((_2336 * _2336), _2336, 1.0f), float3(mad((_20[(_2334 + 2)]), 0.5f, mad(_2341, -1.0f, _2346)), (_2341 - _2338), mad(_2341, 0.5f, _2346)));
                                break;
                              }
                            }
                            _2356 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2372 = log2(max((lerp(_2261, _2259, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2373 = _2372 * 0.3010300099849701f;
                      do {
                        if (!(!(_2373 <= _2287))) {
                          _2442 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2380 = log2(cb0_009x);
                          float _2381 = _2380 * 0.3010300099849701f;
                          if ((bool)(_2373 > _2287) && (bool)(_2373 < _2381)) {
                            float _2389 = ((_2372 - _2286) * 0.9030900001525879f) / ((_2380 - _2286) * 0.3010300099849701f);
                            int _2390 = int(_2389);
                            float _2392 = _2389 - float((int)(_2390));
                            float _2394 = _15[_2390];
                            float _2397 = _15[(_2390 + 1)];
                            float _2402 = _2394 * 0.5f;
                            _2442 = dot(float3((_2392 * _2392), _2392, 1.0f), float3(mad((_15[(_2390 + 2)]), 0.5f, mad(_2397, -1.0f, _2402)), (_2397 - _2394), mad(_2397, 0.5f, _2402)));
                          } else {
                            do {
                              if (!(!(_2373 >= _2381))) {
                                float _2411 = log2(cb0_008z);
                                if (_2373 < (_2411 * 0.3010300099849701f)) {
                                  float _2419 = ((_2372 - _2380) * 0.9030900001525879f) / ((_2411 - _2380) * 0.3010300099849701f);
                                  int _2420 = int(_2419);
                                  float _2422 = _2419 - float((int)(_2420));
                                  float _2424 = _16[_2420];
                                  float _2427 = _16[(_2420 + 1)];
                                  float _2432 = _2424 * 0.5f;
                                  _2442 = dot(float3((_2422 * _2422), _2422, 1.0f), float3(mad((_16[(_2420 + 2)]), 0.5f, mad(_2427, -1.0f, _2432)), (_2427 - _2424), mad(_2427, 0.5f, _2432)));
                                  break;
                                }
                              }
                              _2442 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
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
                        float _2458 = log2(max((lerp(_2261, _2260, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2459 = _2458 * 0.3010300099849701f;
                        do {
                          if (!(!(_2459 <= _2287))) {
                            _2528 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2466 = log2(cb0_009x);
                            float _2467 = _2466 * 0.3010300099849701f;
                            if ((bool)(_2459 > _2287) && (bool)(_2459 < _2467)) {
                              float _2475 = ((_2458 - _2286) * 0.9030900001525879f) / ((_2466 - _2286) * 0.3010300099849701f);
                              int _2476 = int(_2475);
                              float _2478 = _2475 - float((int)(_2476));
                              float _2480 = _17[_2476];
                              float _2483 = _17[(_2476 + 1)];
                              float _2488 = _2480 * 0.5f;
                              _2528 = dot(float3((_2478 * _2478), _2478, 1.0f), float3(mad((_17[(_2476 + 2)]), 0.5f, mad(_2483, -1.0f, _2488)), (_2483 - _2480), mad(_2483, 0.5f, _2488)));
                            } else {
                              do {
                                if (!(!(_2459 >= _2467))) {
                                  float _2497 = log2(cb0_008z);
                                  if (_2459 < (_2497 * 0.3010300099849701f)) {
                                    float _2505 = ((_2458 - _2466) * 0.9030900001525879f) / ((_2497 - _2466) * 0.3010300099849701f);
                                    int _2506 = int(_2505);
                                    float _2508 = _2505 - float((int)(_2506));
                                    float _2510 = _18[_2506];
                                    float _2513 = _18[(_2506 + 1)];
                                    float _2518 = _2510 * 0.5f;
                                    _2528 = dot(float3((_2508 * _2508), _2508, 1.0f), float3(mad((_18[(_2506 + 2)]), 0.5f, mad(_2513, -1.0f, _2518)), (_2513 - _2510), mad(_2513, 0.5f, _2518)));
                                    break;
                                  }
                                }
                                _2528 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2532 = cb0_008w - cb0_008y;
                          float _2533 = (exp2(_2356 * 3.321928024291992f) - cb0_008y) / _2532;
                          float _2535 = (exp2(_2442 * 3.321928024291992f) - cb0_008y) / _2532;
                          float _2537 = (exp2(_2528 * 3.321928024291992f) - cb0_008y) / _2532;
                          float _2540 = mad(0.15618768334388733f, _2537, mad(0.13400420546531677f, _2535, (_2533 * 0.6624541878700256f)));
                          float _2543 = mad(0.053689517080783844f, _2537, mad(0.6740817427635193f, _2535, (_2533 * 0.2722287178039551f)));
                          float _2546 = mad(1.0103391408920288f, _2537, mad(0.00406073359772563f, _2535, (_2533 * -0.005574649665504694f)));
                          float _2559 = min(max(mad(-0.23642469942569733f, _2546, mad(-0.32480329275131226f, _2543, (_2540 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2560 = min(max(mad(0.016756348311901093f, _2546, mad(1.6153316497802734f, _2543, (_2540 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2561 = min(max(mad(0.9883948564529419f, _2546, mad(-0.008284442126750946f, _2543, (_2540 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2564 = mad(0.15618768334388733f, _2561, mad(0.13400420546531677f, _2560, (_2559 * 0.6624541878700256f)));
                          float _2567 = mad(0.053689517080783844f, _2561, mad(0.6740817427635193f, _2560, (_2559 * 0.2722287178039551f)));
                          float _2570 = mad(1.0103391408920288f, _2561, mad(0.00406073359772563f, _2560, (_2559 * -0.005574649665504694f)));
                          float _2592 = min(max((min(max(mad(-0.23642469942569733f, _2570, mad(-0.32480329275131226f, _2567, (_2564 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2593 = min(max((min(max(mad(0.016756348311901093f, _2570, mad(1.6153316497802734f, _2567, (_2564 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2594 = min(max((min(max(mad(0.9883948564529419f, _2570, mad(-0.008284442126750946f, _2567, (_2564 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2607 = mad(_66, _2594, mad(_65, _2593, (_2592 * _64)));
                              _2608 = mad(_69, _2594, mad(_68, _2593, (_2592 * _67)));
                              _2609 = mad(_72, _2594, mad(_71, _2593, (_2592 * _70)));
                            } else {
                              _2607 = _2592;
                              _2608 = _2593;
                              _2609 = _2594;
                            }
                            float _2619 = exp2(log2(_2607 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2620 = exp2(log2(_2608 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2621 = exp2(log2(_2609 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2786 = exp2(log2((1.0f / ((_2619 * 18.6875f) + 1.0f)) * ((_2619 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2787 = exp2(log2((1.0f / ((_2620 * 18.6875f) + 1.0f)) * ((_2620 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2788 = exp2(log2((1.0f / ((_2621 * 18.6875f) + 1.0f)) * ((_2621 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          } while (false);
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
            float _2666 = mad((WorkingColorSpace_128[0].z), _1110, mad((WorkingColorSpace_128[0].y), _1109, ((WorkingColorSpace_128[0].x) * _1108)));
            float _2669 = mad((WorkingColorSpace_128[1].z), _1110, mad((WorkingColorSpace_128[1].y), _1109, ((WorkingColorSpace_128[1].x) * _1108)));
            float _2672 = mad((WorkingColorSpace_128[2].z), _1110, mad((WorkingColorSpace_128[2].y), _1109, ((WorkingColorSpace_128[2].x) * _1108)));
            float _2691 = exp2(log2(mad(_66, _2672, mad(_65, _2669, (_2666 * _64))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2692 = exp2(log2(mad(_69, _2672, mad(_68, _2669, (_2666 * _67))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2693 = exp2(log2(mad(_72, _2672, mad(_71, _2669, (_2666 * _70))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2786 = exp2(log2((1.0f / ((_2691 * 18.6875f) + 1.0f)) * ((_2691 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2787 = exp2(log2((1.0f / ((_2692 * 18.6875f) + 1.0f)) * ((_2692 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2788 = exp2(log2((1.0f / ((_2693 * 18.6875f) + 1.0f)) * ((_2693 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2740 = mad((WorkingColorSpace_128[0].z), _1098, mad((WorkingColorSpace_128[0].y), _1097, ((WorkingColorSpace_128[0].x) * _1096)));
                float _2743 = mad((WorkingColorSpace_128[1].z), _1098, mad((WorkingColorSpace_128[1].y), _1097, ((WorkingColorSpace_128[1].x) * _1096)));
                float _2746 = mad((WorkingColorSpace_128[2].z), _1098, mad((WorkingColorSpace_128[2].y), _1097, ((WorkingColorSpace_128[2].x) * _1096)));
                _2786 = mad(_66, _2746, mad(_65, _2743, (_2740 * _64)));
                _2787 = mad(_69, _2746, mad(_68, _2743, (_2740 * _67)));
                _2788 = mad(_72, _2746, mad(_71, _2743, (_2740 * _70)));
              } else {
                float _2759 = mad((WorkingColorSpace_128[0].z), _1124, mad((WorkingColorSpace_128[0].y), _1123, ((WorkingColorSpace_128[0].x) * _1122)));
                float _2762 = mad((WorkingColorSpace_128[1].z), _1124, mad((WorkingColorSpace_128[1].y), _1123, ((WorkingColorSpace_128[1].x) * _1122)));
                float _2765 = mad((WorkingColorSpace_128[2].z), _1124, mad((WorkingColorSpace_128[2].y), _1123, ((WorkingColorSpace_128[2].x) * _1122)));
                _2786 = exp2(log2(mad(_66, _2765, mad(_65, _2762, (_2759 * _64)))) * cb0_040z);
                _2787 = exp2(log2(mad(_69, _2765, mad(_68, _2762, (_2759 * _67)))) * cb0_040z);
                _2788 = exp2(log2(mad(_72, _2765, mad(_71, _2762, (_2759 * _70)))) * cb0_040z);
              }
            } else {
              _2786 = _1108;
              _2787 = _1109;
              _2788 = _1110;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2786 * 0.9523810148239136f), (_2787 * 0.9523810148239136f), (_2788 * 0.9523810148239136f), 0.0f);
}
