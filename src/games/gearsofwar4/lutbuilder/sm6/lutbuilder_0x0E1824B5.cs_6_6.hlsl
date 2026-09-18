// Found in Blood of Dawnwalker

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
  float cb0_006x : packoffset(c006.x);
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
  float _21[6];
  float _22[6];
  float _23[6];
  float _24[6];
  float _25[6];
  float _26[6];
  float _27[6];
  float _28[6];
  float _40 = 0.5f / cb0_035x;
  float _45 = cb0_035x + -1.0f;
  float _46 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _40)) / _45;
  float _47 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _40)) / _45;
  float _49 = float((uint)SV_DispatchThreadID.z) / _45;
  float _69;
  float _70;
  float _71;
  float _72;
  float _73;
  float _74;
  float _75;
  float _76;
  float _77;
  float _135;
  float _136;
  float _137;
  float _660;
  float _693;
  float _707;
  float _771;
  float _950;
  float _961;
  float _972;
  float _1222;
  float _1223;
  float _1224;
  float _1235;
  float _1246;
  float _1419;
  float _1434;
  float _1449;
  float _1457;
  float _1458;
  float _1459;
  float _1526;
  float _1559;
  float _1573;
  float _1612;
  float _1734;
  float _1820;
  float _1894;
  float _1973;
  float _1974;
  float _1975;
  float _2105;
  float _2120;
  float _2135;
  float _2143;
  float _2144;
  float _2145;
  float _2212;
  float _2245;
  float _2259;
  float _2298;
  float _2420;
  float _2506;
  float _2592;
  float _2671;
  float _2672;
  float _2673;
  float _2850;
  float _2851;
  float _2852;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _58 = (cb0_041x == 4);
        _69 = select(_58, 1.0f, 1.705051064491272f);
        _70 = select(_58, 0.0f, -0.6217921376228333f);
        _71 = select(_58, 0.0f, -0.0832589864730835f);
        _72 = select(_58, 0.0f, -0.13025647401809692f);
        _73 = select(_58, 1.0f, 1.140804648399353f);
        _74 = select(_58, 0.0f, -0.010548308491706848f);
        _75 = select(_58, 0.0f, -0.024003351107239723f);
        _76 = select(_58, 0.0f, -0.1289689838886261f);
        _77 = select(_58, 1.0f, 1.1529725790023804f);
      } else {
        _69 = 0.6954522132873535f;
        _70 = 0.14067870378494263f;
        _71 = 0.16386906802654266f;
        _72 = 0.044794563204050064f;
        _73 = 0.8596711158752441f;
        _74 = 0.0955343171954155f;
        _75 = -0.005525882821530104f;
        _76 = 0.004025210160762072f;
        _77 = 1.0015007257461548f;
      }
    } else {
      _69 = 1.0258246660232544f;
      _70 = -0.020053181797266006f;
      _71 = -0.005771636962890625f;
      _72 = -0.002234415616840124f;
      _73 = 1.0045864582061768f;
      _74 = -0.002352118492126465f;
      _75 = -0.005013350863009691f;
      _76 = -0.025290070101618767f;
      _77 = 1.0303035974502563f;
    }
  } else {
    _69 = 1.3792141675949097f;
    _70 = -0.30886411666870117f;
    _71 = -0.0703500509262085f;
    _72 = -0.06933490186929703f;
    _73 = 1.08229660987854f;
    _74 = -0.012961871922016144f;
    _75 = -0.0021590073592960835f;
    _76 = -0.0454593189060688f;
    _77 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _88 = (pow(_46, 0.012683313339948654f));
    float _89 = (pow(_47, 0.012683313339948654f));
    float _90 = (pow(_49, 0.012683313339948654f));
    _135 = (exp2(log2(max(0.0f, (_88 + -0.8359375f)) / (18.8515625f - (_88 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _136 = (exp2(log2(max(0.0f, (_89 + -0.8359375f)) / (18.8515625f - (_89 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _137 = (exp2(log2(max(0.0f, (_90 + -0.8359375f)) / (18.8515625f - (_90 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _135 = ((exp2((_46 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _136 = ((exp2((_47 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _137 = ((exp2((_49 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _152 = mad((WorkingColorSpace_128[0].z), _137, mad((WorkingColorSpace_128[0].y), _136, ((WorkingColorSpace_128[0].x) * _135)));
  float _155 = mad((WorkingColorSpace_128[1].z), _137, mad((WorkingColorSpace_128[1].y), _136, ((WorkingColorSpace_128[1].x) * _135)));
  float _158 = mad((WorkingColorSpace_128[2].z), _137, mad((WorkingColorSpace_128[2].y), _136, ((WorkingColorSpace_128[2].x) * _135)));
  float _159 = dot(float3(_152, _155, _158), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _163 = (_152 / _159) + -1.0f;
  float _164 = (_155 / _159) + -1.0f;
  float _165 = (_158 / _159) + -1.0f;
  float _177 = (1.0f - exp2(((_159 * _159) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_163, _164, _165), float3(_163, _164, _165)) * -4.0f));
  float _193 = ((mad(-0.06368321925401688f, _158, mad(-0.3292922377586365f, _155, (_152 * 1.3704125881195068f))) - _152) * _177) + _152;
  float _194 = ((mad(-0.010861365124583244f, _158, mad(1.0970927476882935f, _155, (_152 * -0.08343357592821121f))) - _155) * _177) + _155;
  float _195 = ((mad(1.2036951780319214f, _158, mad(-0.09862580895423889f, _155, (_152 * -0.02579331398010254f))) - _158) * _177) + _158;
  float _196 = dot(float3(_193, _194, _195), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _210 = cb0_019w + cb0_024w;
  float _224 = cb0_018w * cb0_023w;
  float _238 = cb0_017w * cb0_022w;
  float _252 = cb0_016w * cb0_021w;
  float _266 = cb0_015w * cb0_020w;
  float _270 = _193 - _196;
  float _271 = _194 - _196;
  float _272 = _195 - _196;
  float _329 = saturate(_196 / cb0_035w);
  float _333 = (_329 * _329) * (3.0f - (_329 * 2.0f));
  float _334 = 1.0f - _333;
  float _343 = cb0_019w + cb0_034w;
  float _352 = cb0_018w * cb0_033w;
  float _361 = cb0_017w * cb0_032w;
  float _370 = cb0_016w * cb0_031w;
  float _379 = cb0_015w * cb0_030w;
  float _442 = saturate((_196 - cb0_036x) / (cb0_036y - cb0_036x));
  float _446 = (_442 * _442) * (3.0f - (_442 * 2.0f));
  float _455 = cb0_019w + cb0_029w;
  float _464 = cb0_018w * cb0_028w;
  float _473 = cb0_017w * cb0_027w;
  float _482 = cb0_016w * cb0_026w;
  float _491 = cb0_015w * cb0_025w;
  float _549 = _333 - _446;
  float _560 = ((_446 * (((cb0_019x + cb0_034x) + _343) + (((cb0_018x * cb0_033x) * _352) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _370) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _379) * _270) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _361)))))) + (_334 * (((cb0_019x + cb0_024x) + _210) + (((cb0_018x * cb0_023x) * _224) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _252) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _266) * _270) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _238))))))) + ((((cb0_019x + cb0_029x) + _455) + (((cb0_018x * cb0_028x) * _464) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _482) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _491) * _270) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _473))))) * _549);
  float _562 = ((_446 * (((cb0_019y + cb0_034y) + _343) + (((cb0_018y * cb0_033y) * _352) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _370) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _379) * _271) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _361)))))) + (_334 * (((cb0_019y + cb0_024y) + _210) + (((cb0_018y * cb0_023y) * _224) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _252) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _266) * _271) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _238))))))) + ((((cb0_019y + cb0_029y) + _455) + (((cb0_018y * cb0_028y) * _464) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _482) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _491) * _271) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _473))))) * _549);
  float _564 = ((_446 * (((cb0_019z + cb0_034z) + _343) + (((cb0_018z * cb0_033z) * _352) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _370) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _379) * _272) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _361)))))) + (_334 * (((cb0_019z + cb0_024z) + _210) + (((cb0_018z * cb0_023z) * _224) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _252) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _266) * _272) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _238))))))) + ((((cb0_019z + cb0_029z) + _455) + (((cb0_018z * cb0_028z) * _464) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _482) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _491) * _272) + _196)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _473))))) * _549);

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

  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(cb0_006x, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyzw  is used

  float4 output = ProcessLutbuilder(float3(_560, _562, _564), s0, s1, s2, s3, t0, t1, t2, t3, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _600 = ((mad(0.061360642313957214f, _564, mad(-4.540197551250458e-09f, _562, (_560 * 0.9386394023895264f))) - _560) * cb0_036z) + _560;
  float _601 = ((mad(0.169205904006958f, _564, mad(0.8307942152023315f, _562, (_560 * 6.775371730327606e-08f))) - _562) * cb0_036z) + _562;
  float _602 = (mad(-2.3283064365386963e-10f, _562, (_560 * -9.313225746154785e-10f)) * cb0_036z) + _564;
  float _605 = mad(0.16386905312538147f, _602, mad(0.14067868888378143f, _601, (_600 * 0.6954522132873535f)));
  float _608 = mad(0.0955343246459961f, _602, mad(0.8596711158752441f, _601, (_600 * 0.044794581830501556f)));
  float _611 = mad(1.0015007257461548f, _602, mad(0.004025210160762072f, _601, (_600 * -0.005525882821530104f)));
  float _615 = max(max(_605, _608), _611);
  float _620 = (max(_615, 1.000000013351432e-10f) - max(min(min(_605, _608), _611), 1.000000013351432e-10f)) / max(_615, 0.009999999776482582f);
  float _633 = ((_608 + _605) + _611) + (sqrt((((_611 - _608) * _611) + ((_608 - _605) * _608)) + ((_605 - _611) * _605)) * 1.75f);
  float _634 = _633 * 0.3333333432674408f;
  float _635 = _620 + -0.4000000059604645f;
  float _636 = _635 * 5.0f;
  float _640 = max((1.0f - abs(_635 * 2.5f)), 0.0f);
  float _651 = ((float((int)(((int)(uint)((bool)(_636 > 0.0f))) - ((int)(uint)((bool)(_636 < 0.0f))))) * (1.0f - (_640 * _640))) + 1.0f) * 0.02500000037252903f;
  if (!(_634 <= 0.0533333346247673f)) {
    if (!(_634 >= 0.1599999964237213f)) {
      _660 = (((0.23999999463558197f / _633) + -0.5f) * _651);
    } else {
      _660 = 0.0f;
    }
  } else {
    _660 = _651;
  }
  float _661 = _660 + 1.0f;
  float _662 = _661 * _605;
  float _663 = _661 * _608;
  float _664 = _661 * _611;
  if (!((bool)(_662 == _663) && (bool)(_663 == _664))) {
    float _671 = ((_662 * 2.0f) - _663) - _664;
    float _674 = ((_608 - _611) * 1.7320507764816284f) * _661;
    float _676 = atan(_674 / _671);
    bool _679 = (_671 < 0.0f);
    bool _680 = (_671 == 0.0f);
    bool _681 = (_674 >= 0.0f);
    bool _682 = (_674 < 0.0f);
    _693 = select((_681 && _680), 90.0f, select((_682 && _680), -90.0f, (select((_682 && _679), (_676 + -3.1415927410125732f), select((_681 && _679), (_676 + 3.1415927410125732f), _676)) * 57.2957763671875f)));
  } else {
    _693 = 0.0f;
  }
  float _698 = min(max(select((_693 < 0.0f), (_693 + 360.0f), _693), 0.0f), 360.0f);
  if (_698 < -180.0f) {
    _707 = (_698 + 360.0f);
  } else {
    if (_698 > 180.0f) {
      _707 = (_698 + -360.0f);
    } else {
      _707 = _698;
    }
  }
  float _711 = saturate(1.0f - abs(_707 * 0.014814814552664757f));
  float _715 = (_711 * _711) * (3.0f - (_711 * 2.0f));
  float _721 = ((_715 * _715) * ((_620 * 0.18000000715255737f) * (0.029999999329447746f - _662))) + _662;
  float _731 = max(0.0f, mad(-0.21492856740951538f, _664, mad(-0.2365107536315918f, _663, (_721 * 1.4514392614364624f))));
  float _732 = max(0.0f, mad(-0.09967592358589172f, _664, mad(1.17622971534729f, _663, (_721 * -0.07655377686023712f))));
  float _733 = max(0.0f, mad(0.9977163076400757f, _664, mad(-0.006032449658960104f, _663, (_721 * 0.008316148072481155f))));
  float _734 = dot(float3(_731, _732, _733), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _749 = (cb0_038x + 1.0f) - cb0_037z;
  float _751 = cb0_038y + 1.0f;
  float _753 = _751 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _771 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _762 = (cb0_038x + 0.18000000715255737f) / _749;
    _771 = (-0.7447274923324585f - ((log2(_762 / (2.0f - _762)) * 0.3465735912322998f) * (_749 / cb0_037y)));
  }
  float _774 = ((1.0f - cb0_037z) / cb0_037y) - _771;
  float _776 = (cb0_037w / cb0_037y) - _774;
  float _780 = log2(lerp(_734, _731, 0.9599999785423279f)) * 0.3010300099849701f;
  float _781 = log2(lerp(_734, _732, 0.9599999785423279f)) * 0.3010300099849701f;
  float _782 = log2(lerp(_734, _733, 0.9599999785423279f)) * 0.3010300099849701f;
  float _786 = cb0_037y * (_780 + _774);
  float _787 = cb0_037y * (_781 + _774);
  float _788 = cb0_037y * (_782 + _774);
  float _789 = _749 * 2.0f;
  float _791 = (cb0_037y * -2.0f) / _749;
  float _792 = _780 - _771;
  float _793 = _781 - _771;
  float _794 = _782 - _771;
  float _813 = _753 * 2.0f;
  float _815 = (cb0_037y * 2.0f) / _753;
  float _840 = select((_780 < _771), ((_789 / (exp2((_792 * 1.4426950216293335f) * _791) + 1.0f)) - cb0_038x), _786);
  float _841 = select((_781 < _771), ((_789 / (exp2((_793 * 1.4426950216293335f) * _791) + 1.0f)) - cb0_038x), _787);
  float _842 = select((_782 < _771), ((_789 / (exp2((_794 * 1.4426950216293335f) * _791) + 1.0f)) - cb0_038x), _788);
  float _849 = _776 - _771;
  float _853 = saturate(_792 / _849);
  float _854 = saturate(_793 / _849);
  float _855 = saturate(_794 / _849);
  bool _856 = (_776 < _771);
  float _860 = select(_856, (1.0f - _853), _853);
  float _861 = select(_856, (1.0f - _854), _854);
  float _862 = select(_856, (1.0f - _855), _855);
  float _881 = (((_860 * _860) * (select((_780 > _776), (_751 - (_813 / (exp2(((_780 - _776) * 1.4426950216293335f) * _815) + 1.0f))), _786) - _840)) * (3.0f - (_860 * 2.0f))) + _840;
  float _882 = (((_861 * _861) * (select((_781 > _776), (_751 - (_813 / (exp2(((_781 - _776) * 1.4426950216293335f) * _815) + 1.0f))), _787) - _841)) * (3.0f - (_861 * 2.0f))) + _841;
  float _883 = (((_862 * _862) * (select((_782 > _776), (_751 - (_813 / (exp2(((_782 - _776) * 1.4426950216293335f) * _815) + 1.0f))), _788) - _842)) * (3.0f - (_862 * 2.0f))) + _842;
  float _884 = dot(float3(_881, _882, _883), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _904 = (cb0_037x * (max(0.0f, (lerp(_884, _881, 0.9300000071525574f))) - _600)) + _600;
  float _905 = (cb0_037x * (max(0.0f, (lerp(_884, _882, 0.9300000071525574f))) - _601)) + _601;
  float _906 = (cb0_037x * (max(0.0f, (lerp(_884, _883, 0.9300000071525574f))) - _602)) + _602;
  float _922 = ((mad(-0.06537103652954102f, _906, mad(1.451815478503704e-06f, _905, (_904 * 1.065374732017517f))) - _904) * cb0_036z) + _904;
  float _923 = ((mad(-0.20366770029067993f, _906, mad(1.2036634683609009f, _905, (_904 * -2.57161445915699e-07f))) - _905) * cb0_036z) + _905;
  float _924 = ((mad(0.9999996423721313f, _906, mad(2.0954757928848267e-08f, _905, (_904 * 1.862645149230957e-08f))) - _906) * cb0_036z) + _906;
  float _937 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _924, mad((WorkingColorSpace_192[0].y), _923, ((WorkingColorSpace_192[0].x) * _922)))));
  float _938 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _924, mad((WorkingColorSpace_192[1].y), _923, ((WorkingColorSpace_192[1].x) * _922)))));
  float _939 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _924, mad((WorkingColorSpace_192[2].y), _923, ((WorkingColorSpace_192[2].x) * _922)))));
  if (_937 < 0.0031306699384003878f) {
    _950 = (_937 * 12.920000076293945f);
  } else {
    _950 = (((pow(_937, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_938 < 0.0031306699384003878f) {
    _961 = (_938 * 12.920000076293945f);
  } else {
    _961 = (((pow(_938, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_939 < 0.0031306699384003878f) {
    _972 = (_939 * 12.920000076293945f);
  } else {
    _972 = (((pow(_939, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _976 = (_961 * 0.9375f) + 0.03125f;
  float _983 = _972 * 15.0f;
  float _984 = floor(_983);
  float _985 = _983 - _984;
  float _987 = (_984 + ((_950 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _990 = t0.SampleLevel(s0, float2(_987, _976), 0.0f);
  float _994 = _987 + 0.0625f;
  float4 _995 = t0.SampleLevel(s0, float2(_994, _976), 0.0f);
  float4 _1017 = t1.SampleLevel(s1, float2(_987, _976), 0.0f);
  float4 _1021 = t1.SampleLevel(s1, float2(_994, _976), 0.0f);
  float4 _1043 = t2.SampleLevel(s2, float2(_987, _976), 0.0f);
  float4 _1047 = t2.SampleLevel(s2, float2(_994, _976), 0.0f);
  float4 _1070 = t3.SampleLevel(s3, float2(_987, _976), 0.0f);
  float4 _1074 = t3.SampleLevel(s3, float2(_994, _976), 0.0f);
  float _1093 = max(6.103519990574569e-05f, ((((((lerp(_990.x, _995.x, _985)) * cb0_005y) + (cb0_005x * _950)) + ((lerp(_1017.x, _1021.x, _985)) * cb0_005z)) + ((lerp(_1043.x, _1047.x, _985)) * cb0_005w)) + ((lerp(_1070.x, _1074.x, _985)) * cb0_006x)));
  float _1094 = max(6.103519990574569e-05f, ((((((lerp(_990.y, _995.y, _985)) * cb0_005y) + (cb0_005x * _961)) + ((lerp(_1017.y, _1021.y, _985)) * cb0_005z)) + ((lerp(_1043.y, _1047.y, _985)) * cb0_005w)) + ((lerp(_1070.y, _1074.y, _985)) * cb0_006x)));
  float _1095 = max(6.103519990574569e-05f, ((((((lerp(_990.z, _995.z, _985)) * cb0_005y) + (cb0_005x * _972)) + ((lerp(_1017.z, _1021.z, _985)) * cb0_005z)) + ((lerp(_1043.z, _1047.z, _985)) * cb0_005w)) + ((lerp(_1070.z, _1074.z, _985)) * cb0_006x)));
  float _1117 = select((_1093 > 0.040449999272823334f), exp2(log2((_1093 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1093 * 0.07739938050508499f));
  float _1118 = select((_1094 > 0.040449999272823334f), exp2(log2((_1094 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1094 * 0.07739938050508499f));
  float _1119 = select((_1095 > 0.040449999272823334f), exp2(log2((_1095 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1095 * 0.07739938050508499f));
  float _1145 = cb0_014x * (((cb0_039y + (cb0_039x * _1117)) * _1117) + cb0_039z);
  float _1146 = cb0_014y * (((cb0_039y + (cb0_039x * _1118)) * _1118) + cb0_039z);
  float _1147 = cb0_014z * (((cb0_039y + (cb0_039x * _1119)) * _1119) + cb0_039z);
  float _1154 = ((cb0_013x - _1145) * cb0_013w) + _1145;
  float _1155 = ((cb0_013y - _1146) * cb0_013w) + _1146;
  float _1156 = ((cb0_013z - _1147) * cb0_013w) + _1147;
  float _1157 = cb0_014x * mad((WorkingColorSpace_192[0].z), _564, mad((WorkingColorSpace_192[0].y), _562, (_560 * (WorkingColorSpace_192[0].x))));
  float _1158 = cb0_014y * mad((WorkingColorSpace_192[1].z), _564, mad((WorkingColorSpace_192[1].y), _562, ((WorkingColorSpace_192[1].x) * _560)));
  float _1159 = cb0_014z * mad((WorkingColorSpace_192[2].z), _564, mad((WorkingColorSpace_192[2].y), _562, ((WorkingColorSpace_192[2].x) * _560)));
  float _1166 = ((cb0_013x - _1157) * cb0_013w) + _1157;
  float _1167 = ((cb0_013y - _1158) * cb0_013w) + _1158;
  float _1168 = ((cb0_013z - _1159) * cb0_013w) + _1159;
  float _1180 = exp2(log2(max(0.0f, _1154)) * cb0_040y);
  float _1181 = exp2(log2(max(0.0f, _1155)) * cb0_040y);
  float _1182 = exp2(log2(max(0.0f, _1156)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1205 = mad((WorkingColorSpace_128[0].z), _1182, mad((WorkingColorSpace_128[0].y), _1181, ((WorkingColorSpace_128[0].x) * _1180)));
        float _1208 = mad((WorkingColorSpace_128[1].z), _1182, mad((WorkingColorSpace_128[1].y), _1181, ((WorkingColorSpace_128[1].x) * _1180)));
        float _1211 = mad((WorkingColorSpace_128[2].z), _1182, mad((WorkingColorSpace_128[2].y), _1181, ((WorkingColorSpace_128[2].x) * _1180)));
        _1222 = mad(_71, _1211, mad(_70, _1208, (_1205 * _69)));
        _1223 = mad(_74, _1211, mad(_73, _1208, (_1205 * _72)));
        _1224 = mad(_77, _1211, mad(_76, _1208, (_1205 * _75)));
      } else {
        _1222 = _1180;
        _1223 = _1181;
        _1224 = _1182;
      }
      do {
        if (_1222 < 0.0031306699384003878f) {
          _1235 = (_1222 * 12.920000076293945f);
        } else {
          _1235 = (((pow(_1222, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1223 < 0.0031306699384003878f) {
            _1246 = (_1223 * 12.920000076293945f);
          } else {
            _1246 = (((pow(_1223, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1224 < 0.0031306699384003878f) {
            _2850 = _1235;
            _2851 = _1246;
            _2852 = (_1224 * 12.920000076293945f);
          } else {
            _2850 = _1235;
            _2851 = _1246;
            _2852 = (((pow(_1224, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1273 = mad((WorkingColorSpace_128[0].z), _1182, mad((WorkingColorSpace_128[0].y), _1181, ((WorkingColorSpace_128[0].x) * _1180)));
      float _1276 = mad((WorkingColorSpace_128[1].z), _1182, mad((WorkingColorSpace_128[1].y), _1181, ((WorkingColorSpace_128[1].x) * _1180)));
      float _1279 = mad((WorkingColorSpace_128[2].z), _1182, mad((WorkingColorSpace_128[2].y), _1181, ((WorkingColorSpace_128[2].x) * _1180)));
      float _1289 = max(6.103519990574569e-05f, mad(_71, _1279, mad(_70, _1276, (_1273 * _69))));
      float _1290 = max(6.103519990574569e-05f, mad(_74, _1279, mad(_73, _1276, (_1273 * _72))));
      float _1291 = max(6.103519990574569e-05f, mad(_77, _1279, mad(_76, _1276, (_1273 * _75))));
      _2850 = min((_1289 * 4.5f), ((exp2(log2(max(_1289, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2851 = min((_1290 * 4.5f), ((exp2(log2(max(_1290, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2852 = min((_1291 * 4.5f), ((exp2(log2(max(_1291, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1367 = cb0_012z * _1166;
        float _1368 = cb0_012z * _1167;
        float _1369 = cb0_012z * _1168;
        float _1372 = mad((WorkingColorSpace_256[0].z), _1369, mad((WorkingColorSpace_256[0].y), _1368, ((WorkingColorSpace_256[0].x) * _1367)));
        float _1375 = mad((WorkingColorSpace_256[1].z), _1369, mad((WorkingColorSpace_256[1].y), _1368, ((WorkingColorSpace_256[1].x) * _1367)));
        float _1378 = mad((WorkingColorSpace_256[2].z), _1369, mad((WorkingColorSpace_256[2].y), _1368, ((WorkingColorSpace_256[2].x) * _1367)));
        float _1381 = mad(-0.21492856740951538f, _1378, mad(-0.2365107536315918f, _1375, (_1372 * 1.4514392614364624f)));
        float _1384 = mad(-0.09967592358589172f, _1378, mad(1.17622971534729f, _1375, (_1372 * -0.07655377686023712f)));
        float _1387 = mad(0.9977163076400757f, _1378, mad(-0.006032449658960104f, _1375, (_1372 * 0.008316148072481155f)));
        float _1389 = max(_1381, max(_1384, _1387));
        do {
          if (!(_1389 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1372 < 0.0f) || (bool)(_1375 < 0.0f))) || (bool)(_1378 < 0.0f))) {
              float _1399 = abs(_1389);
              float _1400 = (_1389 - _1381) / _1399;
              float _1402 = (_1389 - _1384) / _1399;
              float _1404 = (_1389 - _1387) / _1399;
              do {
                if (!(_1400 < 0.8149999976158142f)) {
                  float _1407 = _1400 + -0.8149999976158142f;
                  _1419 = ((_1407 / exp2(log2(exp2(log2(_1407 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1419 = _1400;
                }
                do {
                  if (!(_1402 < 0.8029999732971191f)) {
                    float _1422 = _1402 + -0.8029999732971191f;
                    _1434 = ((_1422 / exp2(log2(exp2(log2(_1422 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1434 = _1402;
                  }
                  do {
                    if (!(_1404 < 0.8799999952316284f)) {
                      float _1437 = _1404 + -0.8799999952316284f;
                      _1449 = ((_1437 / exp2(log2(exp2(log2(_1437 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1449 = _1404;
                    }
                    _1457 = (_1389 - (_1399 * _1419));
                    _1458 = (_1389 - (_1399 * _1434));
                    _1459 = (_1389 - (_1399 * _1449));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1457 = _1381;
              _1458 = _1384;
              _1459 = _1387;
            }
          } else {
            _1457 = _1381;
            _1458 = _1384;
            _1459 = _1387;
          }
          float _1475 = ((mad(0.16386906802654266f, _1459, mad(0.14067870378494263f, _1458, (_1457 * 0.6954522132873535f))) - _1372) * cb0_012w) + _1372;
          float _1476 = ((mad(0.0955343171954155f, _1459, mad(0.8596711158752441f, _1458, (_1457 * 0.044794563204050064f))) - _1375) * cb0_012w) + _1375;
          float _1477 = ((mad(1.0015007257461548f, _1459, mad(0.004025210160762072f, _1458, (_1457 * -0.005525882821530104f))) - _1378) * cb0_012w) + _1378;
          float _1481 = max(max(_1475, _1476), _1477);
          float _1486 = (max(_1481, 1.000000013351432e-10f) - max(min(min(_1475, _1476), _1477), 1.000000013351432e-10f)) / max(_1481, 0.009999999776482582f);
          float _1499 = ((_1476 + _1475) + _1477) + (sqrt((((_1477 - _1476) * _1477) + ((_1476 - _1475) * _1476)) + ((_1475 - _1477) * _1475)) * 1.75f);
          float _1500 = _1499 * 0.3333333432674408f;
          float _1501 = _1486 + -0.4000000059604645f;
          float _1502 = _1501 * 5.0f;
          float _1506 = max((1.0f - abs(_1501 * 2.5f)), 0.0f);
          float _1517 = ((float((int)(((int)(uint)((bool)(_1502 > 0.0f))) - ((int)(uint)((bool)(_1502 < 0.0f))))) * (1.0f - (_1506 * _1506))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1500 <= 0.0533333346247673f)) {
              if (!(_1500 >= 0.1599999964237213f)) {
                _1526 = (((0.23999999463558197f / _1499) + -0.5f) * _1517);
              } else {
                _1526 = 0.0f;
              }
            } else {
              _1526 = _1517;
            }
            float _1527 = _1526 + 1.0f;
            float _1528 = _1527 * _1475;
            float _1529 = _1527 * _1476;
            float _1530 = _1527 * _1477;
            do {
              if (!((bool)(_1528 == _1529) && (bool)(_1529 == _1530))) {
                float _1537 = ((_1528 * 2.0f) - _1529) - _1530;
                float _1540 = ((_1476 - _1477) * 1.7320507764816284f) * _1527;
                float _1542 = atan(_1540 / _1537);
                bool _1545 = (_1537 < 0.0f);
                bool _1546 = (_1537 == 0.0f);
                bool _1547 = (_1540 >= 0.0f);
                bool _1548 = (_1540 < 0.0f);
                _1559 = select((_1547 && _1546), 90.0f, select((_1548 && _1546), -90.0f, (select((_1548 && _1545), (_1542 + -3.1415927410125732f), select((_1547 && _1545), (_1542 + 3.1415927410125732f), _1542)) * 57.2957763671875f)));
              } else {
                _1559 = 0.0f;
              }
              float _1564 = min(max(select((_1559 < 0.0f), (_1559 + 360.0f), _1559), 0.0f), 360.0f);
              do {
                if (_1564 < -180.0f) {
                  _1573 = (_1564 + 360.0f);
                } else {
                  if (_1564 > 180.0f) {
                    _1573 = (_1564 + -360.0f);
                  } else {
                    _1573 = _1564;
                  }
                }
                do {
                  if ((bool)(_1573 > -67.5f) && (bool)(_1573 < 67.5f)) {
                    float _1579 = (_1573 + 67.5f) * 0.029629629105329514f;
                    int _1580 = int(_1579);
                    float _1582 = _1579 - float((int)(_1580));
                    float _1583 = _1582 * _1582;
                    float _1584 = _1583 * _1582;
                    if (_1580 == 3) {
                      _1612 = (((0.1666666716337204f - (_1582 * 0.5f)) + (_1583 * 0.5f)) - (_1584 * 0.1666666716337204f));
                    } else {
                      if (_1580 == 2) {
                        _1612 = ((0.6666666865348816f - _1583) + (_1584 * 0.5f));
                      } else {
                        if (_1580 == 1) {
                          _1612 = (((_1584 * -0.5f) + 0.1666666716337204f) + ((_1583 + _1582) * 0.5f));
                        } else {
                          _1612 = select((_1580 == 0), (_1584 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1612 = 0.0f;
                  }
                  float _1621 = min(max(((((_1486 * 0.27000001072883606f) * (0.029999999329447746f - _1528)) * _1612) + _1528), 0.0f), 65535.0f);
                  float _1622 = min(max(_1529, 0.0f), 65535.0f);
                  float _1623 = min(max(_1530, 0.0f), 65535.0f);
                  float _1636 = min(max(mad(-0.21492856740951538f, _1623, mad(-0.2365107536315918f, _1622, (_1621 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1637 = min(max(mad(-0.09967592358589172f, _1623, mad(1.17622971534729f, _1622, (_1621 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1638 = min(max(mad(0.9977163076400757f, _1623, mad(-0.006032449658960104f, _1622, (_1621 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1639 = dot(float3(_1636, _1637, _1638), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  _25[0] = cb0_010x;
                  _25[1] = cb0_010y;
                  _25[2] = cb0_010z;
                  _25[3] = cb0_010w;
                  _25[4] = cb0_012x;
                  _25[5] = cb0_012x;
                  _26[0] = cb0_011x;
                  _26[1] = cb0_011y;
                  _26[2] = cb0_011z;
                  _26[3] = cb0_011w;
                  _26[4] = cb0_012y;
                  _26[5] = cb0_012y;
                  float _1662 = log2(max((lerp(_1639, _1636, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1663 = _1662 * 0.3010300099849701f;
                  float _1664 = log2(cb0_008x);
                  float _1665 = _1664 * 0.3010300099849701f;
                  do {
                    if (!(!(_1663 <= _1665))) {
                      _1734 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1672 = log2(cb0_009x);
                      float _1673 = _1672 * 0.3010300099849701f;
                      if ((bool)(_1663 > _1665) && (bool)(_1663 < _1673)) {
                        float _1681 = ((_1662 - _1664) * 0.9030900001525879f) / ((_1672 - _1664) * 0.3010300099849701f);
                        int _1682 = int(_1681);
                        float _1684 = _1681 - float((int)(_1682));
                        float _1686 = _25[_1682];
                        float _1689 = _25[(_1682 + 1)];
                        float _1694 = _1686 * 0.5f;
                        _1734 = dot(float3((_1684 * _1684), _1684, 1.0f), float3(mad((_25[(_1682 + 2)]), 0.5f, mad(_1689, -1.0f, _1694)), (_1689 - _1686), mad(_1689, 0.5f, _1694)));
                      } else {
                        do {
                          if (!(!(_1663 >= _1673))) {
                            float _1703 = log2(cb0_008z);
                            if (_1663 < (_1703 * 0.3010300099849701f)) {
                              float _1711 = ((_1662 - _1672) * 0.9030900001525879f) / ((_1703 - _1672) * 0.3010300099849701f);
                              int _1712 = int(_1711);
                              float _1714 = _1711 - float((int)(_1712));
                              float _1716 = _26[_1712];
                              float _1719 = _26[(_1712 + 1)];
                              float _1724 = _1716 * 0.5f;
                              _1734 = dot(float3((_1714 * _1714), _1714, 1.0f), float3(mad((_26[(_1712 + 2)]), 0.5f, mad(_1719, -1.0f, _1724)), (_1719 - _1716), mad(_1719, 0.5f, _1724)));
                              break;
                            }
                          }
                          _1734 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _27[0] = cb0_010x;
                    _27[1] = cb0_010y;
                    _27[2] = cb0_010z;
                    _27[3] = cb0_010w;
                    _27[4] = cb0_012x;
                    _27[5] = cb0_012x;
                    _28[0] = cb0_011x;
                    _28[1] = cb0_011y;
                    _28[2] = cb0_011z;
                    _28[3] = cb0_011w;
                    _28[4] = cb0_012y;
                    _28[5] = cb0_012y;
                    float _1750 = log2(max((lerp(_1639, _1637, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1751 = _1750 * 0.3010300099849701f;
                    do {
                      if (!(!(_1751 <= _1665))) {
                        _1820 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1758 = log2(cb0_009x);
                        float _1759 = _1758 * 0.3010300099849701f;
                        if ((bool)(_1751 > _1665) && (bool)(_1751 < _1759)) {
                          float _1767 = ((_1750 - _1664) * 0.9030900001525879f) / ((_1758 - _1664) * 0.3010300099849701f);
                          int _1768 = int(_1767);
                          float _1770 = _1767 - float((int)(_1768));
                          float _1772 = _27[_1768];
                          float _1775 = _27[(_1768 + 1)];
                          float _1780 = _1772 * 0.5f;
                          _1820 = dot(float3((_1770 * _1770), _1770, 1.0f), float3(mad((_27[(_1768 + 2)]), 0.5f, mad(_1775, -1.0f, _1780)), (_1775 - _1772), mad(_1775, 0.5f, _1780)));
                        } else {
                          do {
                            if (!(!(_1751 >= _1759))) {
                              float _1789 = log2(cb0_008z);
                              if (_1751 < (_1789 * 0.3010300099849701f)) {
                                float _1797 = ((_1750 - _1758) * 0.9030900001525879f) / ((_1789 - _1758) * 0.3010300099849701f);
                                int _1798 = int(_1797);
                                float _1800 = _1797 - float((int)(_1798));
                                float _1802 = _28[_1798];
                                float _1805 = _28[(_1798 + 1)];
                                float _1810 = _1802 * 0.5f;
                                _1820 = dot(float3((_1800 * _1800), _1800, 1.0f), float3(mad((_28[(_1798 + 2)]), 0.5f, mad(_1805, -1.0f, _1810)), (_1805 - _1802), mad(_1805, 0.5f, _1810)));
                                break;
                              }
                            }
                            _1820 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1824 = log2(max((lerp(_1639, _1638, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1825 = _1824 * 0.3010300099849701f;
                      do {
                        if (!(!(_1825 <= _1665))) {
                          _1894 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1832 = log2(cb0_009x);
                          float _1833 = _1832 * 0.3010300099849701f;
                          if ((bool)(_1825 > _1665) && (bool)(_1825 < _1833)) {
                            float _1841 = ((_1824 - _1664) * 0.9030900001525879f) / ((_1832 - _1664) * 0.3010300099849701f);
                            int _1842 = int(_1841);
                            float _1844 = _1841 - float((int)(_1842));
                            float _1846 = _17[_1842];
                            float _1849 = _17[(_1842 + 1)];
                            float _1854 = _1846 * 0.5f;
                            _1894 = dot(float3((_1844 * _1844), _1844, 1.0f), float3(mad((_17[(_1842 + 2)]), 0.5f, mad(_1849, -1.0f, _1854)), (_1849 - _1846), mad(_1849, 0.5f, _1854)));
                          } else {
                            do {
                              if (!(!(_1825 >= _1833))) {
                                float _1863 = log2(cb0_008z);
                                if (_1825 < (_1863 * 0.3010300099849701f)) {
                                  float _1871 = ((_1824 - _1832) * 0.9030900001525879f) / ((_1863 - _1832) * 0.3010300099849701f);
                                  int _1872 = int(_1871);
                                  float _1874 = _1871 - float((int)(_1872));
                                  float _1876 = _18[_1872];
                                  float _1879 = _18[(_1872 + 1)];
                                  float _1884 = _1876 * 0.5f;
                                  _1894 = dot(float3((_1874 * _1874), _1874, 1.0f), float3(mad((_18[(_1872 + 2)]), 0.5f, mad(_1879, -1.0f, _1884)), (_1879 - _1876), mad(_1879, 0.5f, _1884)));
                                  break;
                                }
                              }
                              _1894 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1898 = cb0_008w - cb0_008y;
                        float _1899 = (exp2(_1734 * 3.321928024291992f) - cb0_008y) / _1898;
                        float _1901 = (exp2(_1820 * 3.321928024291992f) - cb0_008y) / _1898;
                        float _1903 = (exp2(_1894 * 3.321928024291992f) - cb0_008y) / _1898;
                        float _1906 = mad(0.15618768334388733f, _1903, mad(0.13400420546531677f, _1901, (_1899 * 0.6624541878700256f)));
                        float _1909 = mad(0.053689517080783844f, _1903, mad(0.6740817427635193f, _1901, (_1899 * 0.2722287178039551f)));
                        float _1912 = mad(1.0103391408920288f, _1903, mad(0.00406073359772563f, _1901, (_1899 * -0.005574649665504694f)));
                        float _1925 = min(max(mad(-0.23642469942569733f, _1912, mad(-0.32480329275131226f, _1909, (_1906 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1926 = min(max(mad(0.016756348311901093f, _1912, mad(1.6153316497802734f, _1909, (_1906 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1927 = min(max(mad(0.9883948564529419f, _1912, mad(-0.008284442126750946f, _1909, (_1906 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1930 = mad(0.15618768334388733f, _1927, mad(0.13400420546531677f, _1926, (_1925 * 0.6624541878700256f)));
                        float _1933 = mad(0.053689517080783844f, _1927, mad(0.6740817427635193f, _1926, (_1925 * 0.2722287178039551f)));
                        float _1936 = mad(1.0103391408920288f, _1927, mad(0.00406073359772563f, _1926, (_1925 * -0.005574649665504694f)));
                        float _1958 = min(max((min(max(mad(-0.23642469942569733f, _1936, mad(-0.32480329275131226f, _1933, (_1930 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1959 = min(max((min(max(mad(0.016756348311901093f, _1936, mad(1.6153316497802734f, _1933, (_1930 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1960 = min(max((min(max(mad(0.9883948564529419f, _1936, mad(-0.008284442126750946f, _1933, (_1930 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _1973 = mad(_71, _1960, mad(_70, _1959, (_1958 * _69)));
                            _1974 = mad(_74, _1960, mad(_73, _1959, (_1958 * _72)));
                            _1975 = mad(_77, _1960, mad(_76, _1959, (_1958 * _75)));
                          } else {
                            _1973 = _1958;
                            _1974 = _1959;
                            _1975 = _1960;
                          }
                          float _1985 = exp2(log2(_1973 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1986 = exp2(log2(_1974 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1987 = exp2(log2(_1975 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2850 = exp2(log2((1.0f / ((_1985 * 18.6875f) + 1.0f)) * ((_1985 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2851 = exp2(log2((1.0f / ((_1986 * 18.6875f) + 1.0f)) * ((_1986 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2852 = exp2(log2((1.0f / ((_1987 * 18.6875f) + 1.0f)) * ((_1987 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2053 = cb0_012z * _1166;
          float _2054 = cb0_012z * _1167;
          float _2055 = cb0_012z * _1168;
          float _2058 = mad((WorkingColorSpace_256[0].z), _2055, mad((WorkingColorSpace_256[0].y), _2054, ((WorkingColorSpace_256[0].x) * _2053)));
          float _2061 = mad((WorkingColorSpace_256[1].z), _2055, mad((WorkingColorSpace_256[1].y), _2054, ((WorkingColorSpace_256[1].x) * _2053)));
          float _2064 = mad((WorkingColorSpace_256[2].z), _2055, mad((WorkingColorSpace_256[2].y), _2054, ((WorkingColorSpace_256[2].x) * _2053)));
          float _2067 = mad(-0.21492856740951538f, _2064, mad(-0.2365107536315918f, _2061, (_2058 * 1.4514392614364624f)));
          float _2070 = mad(-0.09967592358589172f, _2064, mad(1.17622971534729f, _2061, (_2058 * -0.07655377686023712f)));
          float _2073 = mad(0.9977163076400757f, _2064, mad(-0.006032449658960104f, _2061, (_2058 * 0.008316148072481155f)));
          float _2075 = max(_2067, max(_2070, _2073));
          do {
            if (!(_2075 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2058 < 0.0f) || (bool)(_2061 < 0.0f))) || (bool)(_2064 < 0.0f))) {
                float _2085 = abs(_2075);
                float _2086 = (_2075 - _2067) / _2085;
                float _2088 = (_2075 - _2070) / _2085;
                float _2090 = (_2075 - _2073) / _2085;
                do {
                  if (!(_2086 < 0.8149999976158142f)) {
                    float _2093 = _2086 + -0.8149999976158142f;
                    _2105 = ((_2093 / exp2(log2(exp2(log2(_2093 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2105 = _2086;
                  }
                  do {
                    if (!(_2088 < 0.8029999732971191f)) {
                      float _2108 = _2088 + -0.8029999732971191f;
                      _2120 = ((_2108 / exp2(log2(exp2(log2(_2108 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2120 = _2088;
                    }
                    do {
                      if (!(_2090 < 0.8799999952316284f)) {
                        float _2123 = _2090 + -0.8799999952316284f;
                        _2135 = ((_2123 / exp2(log2(exp2(log2(_2123 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2135 = _2090;
                      }
                      _2143 = (_2075 - (_2085 * _2105));
                      _2144 = (_2075 - (_2085 * _2120));
                      _2145 = (_2075 - (_2085 * _2135));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2143 = _2067;
                _2144 = _2070;
                _2145 = _2073;
              }
            } else {
              _2143 = _2067;
              _2144 = _2070;
              _2145 = _2073;
            }
            float _2161 = ((mad(0.16386906802654266f, _2145, mad(0.14067870378494263f, _2144, (_2143 * 0.6954522132873535f))) - _2058) * cb0_012w) + _2058;
            float _2162 = ((mad(0.0955343171954155f, _2145, mad(0.8596711158752441f, _2144, (_2143 * 0.044794563204050064f))) - _2061) * cb0_012w) + _2061;
            float _2163 = ((mad(1.0015007257461548f, _2145, mad(0.004025210160762072f, _2144, (_2143 * -0.005525882821530104f))) - _2064) * cb0_012w) + _2064;
            float _2167 = max(max(_2161, _2162), _2163);
            float _2172 = (max(_2167, 1.000000013351432e-10f) - max(min(min(_2161, _2162), _2163), 1.000000013351432e-10f)) / max(_2167, 0.009999999776482582f);
            float _2185 = ((_2162 + _2161) + _2163) + (sqrt((((_2163 - _2162) * _2163) + ((_2162 - _2161) * _2162)) + ((_2161 - _2163) * _2161)) * 1.75f);
            float _2186 = _2185 * 0.3333333432674408f;
            float _2187 = _2172 + -0.4000000059604645f;
            float _2188 = _2187 * 5.0f;
            float _2192 = max((1.0f - abs(_2187 * 2.5f)), 0.0f);
            float _2203 = ((float((int)(((int)(uint)((bool)(_2188 > 0.0f))) - ((int)(uint)((bool)(_2188 < 0.0f))))) * (1.0f - (_2192 * _2192))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2186 <= 0.0533333346247673f)) {
                if (!(_2186 >= 0.1599999964237213f)) {
                  _2212 = (((0.23999999463558197f / _2185) + -0.5f) * _2203);
                } else {
                  _2212 = 0.0f;
                }
              } else {
                _2212 = _2203;
              }
              float _2213 = _2212 + 1.0f;
              float _2214 = _2213 * _2161;
              float _2215 = _2213 * _2162;
              float _2216 = _2213 * _2163;
              do {
                if (!((bool)(_2214 == _2215) && (bool)(_2215 == _2216))) {
                  float _2223 = ((_2214 * 2.0f) - _2215) - _2216;
                  float _2226 = ((_2162 - _2163) * 1.7320507764816284f) * _2213;
                  float _2228 = atan(_2226 / _2223);
                  bool _2231 = (_2223 < 0.0f);
                  bool _2232 = (_2223 == 0.0f);
                  bool _2233 = (_2226 >= 0.0f);
                  bool _2234 = (_2226 < 0.0f);
                  _2245 = select((_2233 && _2232), 90.0f, select((_2234 && _2232), -90.0f, (select((_2234 && _2231), (_2228 + -3.1415927410125732f), select((_2233 && _2231), (_2228 + 3.1415927410125732f), _2228)) * 57.2957763671875f)));
                } else {
                  _2245 = 0.0f;
                }
                float _2250 = min(max(select((_2245 < 0.0f), (_2245 + 360.0f), _2245), 0.0f), 360.0f);
                do {
                  if (_2250 < -180.0f) {
                    _2259 = (_2250 + 360.0f);
                  } else {
                    if (_2250 > 180.0f) {
                      _2259 = (_2250 + -360.0f);
                    } else {
                      _2259 = _2250;
                    }
                  }
                  do {
                    if ((bool)(_2259 > -67.5f) && (bool)(_2259 < 67.5f)) {
                      float _2265 = (_2259 + 67.5f) * 0.029629629105329514f;
                      int _2266 = int(_2265);
                      float _2268 = _2265 - float((int)(_2266));
                      float _2269 = _2268 * _2268;
                      float _2270 = _2269 * _2268;
                      if (_2266 == 3) {
                        _2298 = (((0.1666666716337204f - (_2268 * 0.5f)) + (_2269 * 0.5f)) - (_2270 * 0.1666666716337204f));
                      } else {
                        if (_2266 == 2) {
                          _2298 = ((0.6666666865348816f - _2269) + (_2270 * 0.5f));
                        } else {
                          if (_2266 == 1) {
                            _2298 = (((_2270 * -0.5f) + 0.1666666716337204f) + ((_2269 + _2268) * 0.5f));
                          } else {
                            _2298 = select((_2266 == 0), (_2270 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2298 = 0.0f;
                    }
                    float _2307 = min(max(((((_2172 * 0.27000001072883606f) * (0.029999999329447746f - _2214)) * _2298) + _2214), 0.0f), 65535.0f);
                    float _2308 = min(max(_2215, 0.0f), 65535.0f);
                    float _2309 = min(max(_2216, 0.0f), 65535.0f);
                    float _2322 = min(max(mad(-0.21492856740951538f, _2309, mad(-0.2365107536315918f, _2308, (_2307 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2323 = min(max(mad(-0.09967592358589172f, _2309, mad(1.17622971534729f, _2308, (_2307 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2324 = min(max(mad(0.9977163076400757f, _2309, mad(-0.006032449658960104f, _2308, (_2307 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2325 = dot(float3(_2322, _2323, _2324), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                    _23[0] = cb0_010x;
                    _23[1] = cb0_010y;
                    _23[2] = cb0_010z;
                    _23[3] = cb0_010w;
                    _23[4] = cb0_012x;
                    _23[5] = cb0_012x;
                    _24[0] = cb0_011x;
                    _24[1] = cb0_011y;
                    _24[2] = cb0_011z;
                    _24[3] = cb0_011w;
                    _24[4] = cb0_012y;
                    _24[5] = cb0_012y;
                    float _2348 = log2(max((lerp(_2325, _2322, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2349 = _2348 * 0.3010300099849701f;
                    float _2350 = log2(cb0_008x);
                    float _2351 = _2350 * 0.3010300099849701f;
                    do {
                      if (!(!(_2349 <= _2351))) {
                        _2420 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2358 = log2(cb0_009x);
                        float _2359 = _2358 * 0.3010300099849701f;
                        if ((bool)(_2349 > _2351) && (bool)(_2349 < _2359)) {
                          float _2367 = ((_2348 - _2350) * 0.9030900001525879f) / ((_2358 - _2350) * 0.3010300099849701f);
                          int _2368 = int(_2367);
                          float _2370 = _2367 - float((int)(_2368));
                          float _2372 = _23[_2368];
                          float _2375 = _23[(_2368 + 1)];
                          float _2380 = _2372 * 0.5f;
                          _2420 = dot(float3((_2370 * _2370), _2370, 1.0f), float3(mad((_23[(_2368 + 2)]), 0.5f, mad(_2375, -1.0f, _2380)), (_2375 - _2372), mad(_2375, 0.5f, _2380)));
                        } else {
                          do {
                            if (!(!(_2349 >= _2359))) {
                              float _2389 = log2(cb0_008z);
                              if (_2349 < (_2389 * 0.3010300099849701f)) {
                                float _2397 = ((_2348 - _2358) * 0.9030900001525879f) / ((_2389 - _2358) * 0.3010300099849701f);
                                int _2398 = int(_2397);
                                float _2400 = _2397 - float((int)(_2398));
                                float _2402 = _24[_2398];
                                float _2405 = _24[(_2398 + 1)];
                                float _2410 = _2402 * 0.5f;
                                _2420 = dot(float3((_2400 * _2400), _2400, 1.0f), float3(mad((_24[(_2398 + 2)]), 0.5f, mad(_2405, -1.0f, _2410)), (_2405 - _2402), mad(_2405, 0.5f, _2410)));
                                break;
                              }
                            }
                            _2420 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2436 = log2(max((lerp(_2325, _2323, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2437 = _2436 * 0.3010300099849701f;
                      do {
                        if (!(!(_2437 <= _2351))) {
                          _2506 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2444 = log2(cb0_009x);
                          float _2445 = _2444 * 0.3010300099849701f;
                          if ((bool)(_2437 > _2351) && (bool)(_2437 < _2445)) {
                            float _2453 = ((_2436 - _2350) * 0.9030900001525879f) / ((_2444 - _2350) * 0.3010300099849701f);
                            int _2454 = int(_2453);
                            float _2456 = _2453 - float((int)(_2454));
                            float _2458 = _19[_2454];
                            float _2461 = _19[(_2454 + 1)];
                            float _2466 = _2458 * 0.5f;
                            _2506 = dot(float3((_2456 * _2456), _2456, 1.0f), float3(mad((_19[(_2454 + 2)]), 0.5f, mad(_2461, -1.0f, _2466)), (_2461 - _2458), mad(_2461, 0.5f, _2466)));
                          } else {
                            do {
                              if (!(!(_2437 >= _2445))) {
                                float _2475 = log2(cb0_008z);
                                if (_2437 < (_2475 * 0.3010300099849701f)) {
                                  float _2483 = ((_2436 - _2444) * 0.9030900001525879f) / ((_2475 - _2444) * 0.3010300099849701f);
                                  int _2484 = int(_2483);
                                  float _2486 = _2483 - float((int)(_2484));
                                  float _2488 = _20[_2484];
                                  float _2491 = _20[(_2484 + 1)];
                                  float _2496 = _2488 * 0.5f;
                                  _2506 = dot(float3((_2486 * _2486), _2486, 1.0f), float3(mad((_20[(_2484 + 2)]), 0.5f, mad(_2491, -1.0f, _2496)), (_2491 - _2488), mad(_2491, 0.5f, _2496)));
                                  break;
                                }
                              }
                              _2506 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        _21[0] = cb0_010x;
                        _21[1] = cb0_010y;
                        _21[2] = cb0_010z;
                        _21[3] = cb0_010w;
                        _21[4] = cb0_012x;
                        _21[5] = cb0_012x;
                        _22[0] = cb0_011x;
                        _22[1] = cb0_011y;
                        _22[2] = cb0_011z;
                        _22[3] = cb0_011w;
                        _22[4] = cb0_012y;
                        _22[5] = cb0_012y;
                        float _2522 = log2(max((lerp(_2325, _2324, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2523 = _2522 * 0.3010300099849701f;
                        do {
                          if (!(!(_2523 <= _2351))) {
                            _2592 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2530 = log2(cb0_009x);
                            float _2531 = _2530 * 0.3010300099849701f;
                            if ((bool)(_2523 > _2351) && (bool)(_2523 < _2531)) {
                              float _2539 = ((_2522 - _2350) * 0.9030900001525879f) / ((_2530 - _2350) * 0.3010300099849701f);
                              int _2540 = int(_2539);
                              float _2542 = _2539 - float((int)(_2540));
                              float _2544 = _21[_2540];
                              float _2547 = _21[(_2540 + 1)];
                              float _2552 = _2544 * 0.5f;
                              _2592 = dot(float3((_2542 * _2542), _2542, 1.0f), float3(mad((_21[(_2540 + 2)]), 0.5f, mad(_2547, -1.0f, _2552)), (_2547 - _2544), mad(_2547, 0.5f, _2552)));
                            } else {
                              do {
                                if (!(!(_2523 >= _2531))) {
                                  float _2561 = log2(cb0_008z);
                                  if (_2523 < (_2561 * 0.3010300099849701f)) {
                                    float _2569 = ((_2522 - _2530) * 0.9030900001525879f) / ((_2561 - _2530) * 0.3010300099849701f);
                                    int _2570 = int(_2569);
                                    float _2572 = _2569 - float((int)(_2570));
                                    float _2574 = _22[_2570];
                                    float _2577 = _22[(_2570 + 1)];
                                    float _2582 = _2574 * 0.5f;
                                    _2592 = dot(float3((_2572 * _2572), _2572, 1.0f), float3(mad((_22[(_2570 + 2)]), 0.5f, mad(_2577, -1.0f, _2582)), (_2577 - _2574), mad(_2577, 0.5f, _2582)));
                                    break;
                                  }
                                }
                                _2592 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2596 = cb0_008w - cb0_008y;
                          float _2597 = (exp2(_2420 * 3.321928024291992f) - cb0_008y) / _2596;
                          float _2599 = (exp2(_2506 * 3.321928024291992f) - cb0_008y) / _2596;
                          float _2601 = (exp2(_2592 * 3.321928024291992f) - cb0_008y) / _2596;
                          float _2604 = mad(0.15618768334388733f, _2601, mad(0.13400420546531677f, _2599, (_2597 * 0.6624541878700256f)));
                          float _2607 = mad(0.053689517080783844f, _2601, mad(0.6740817427635193f, _2599, (_2597 * 0.2722287178039551f)));
                          float _2610 = mad(1.0103391408920288f, _2601, mad(0.00406073359772563f, _2599, (_2597 * -0.005574649665504694f)));
                          float _2623 = min(max(mad(-0.23642469942569733f, _2610, mad(-0.32480329275131226f, _2607, (_2604 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2624 = min(max(mad(0.016756348311901093f, _2610, mad(1.6153316497802734f, _2607, (_2604 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2625 = min(max(mad(0.9883948564529419f, _2610, mad(-0.008284442126750946f, _2607, (_2604 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2628 = mad(0.15618768334388733f, _2625, mad(0.13400420546531677f, _2624, (_2623 * 0.6624541878700256f)));
                          float _2631 = mad(0.053689517080783844f, _2625, mad(0.6740817427635193f, _2624, (_2623 * 0.2722287178039551f)));
                          float _2634 = mad(1.0103391408920288f, _2625, mad(0.00406073359772563f, _2624, (_2623 * -0.005574649665504694f)));
                          float _2656 = min(max((min(max(mad(-0.23642469942569733f, _2634, mad(-0.32480329275131226f, _2631, (_2628 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2657 = min(max((min(max(mad(0.016756348311901093f, _2634, mad(1.6153316497802734f, _2631, (_2628 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2658 = min(max((min(max(mad(0.9883948564529419f, _2634, mad(-0.008284442126750946f, _2631, (_2628 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2671 = mad(_71, _2658, mad(_70, _2657, (_2656 * _69)));
                              _2672 = mad(_74, _2658, mad(_73, _2657, (_2656 * _72)));
                              _2673 = mad(_77, _2658, mad(_76, _2657, (_2656 * _75)));
                            } else {
                              _2671 = _2656;
                              _2672 = _2657;
                              _2673 = _2658;
                            }
                            float _2683 = exp2(log2(_2671 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2684 = exp2(log2(_2672 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2685 = exp2(log2(_2673 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2850 = exp2(log2((1.0f / ((_2683 * 18.6875f) + 1.0f)) * ((_2683 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2851 = exp2(log2((1.0f / ((_2684 * 18.6875f) + 1.0f)) * ((_2684 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2852 = exp2(log2((1.0f / ((_2685 * 18.6875f) + 1.0f)) * ((_2685 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2730 = mad((WorkingColorSpace_128[0].z), _1168, mad((WorkingColorSpace_128[0].y), _1167, ((WorkingColorSpace_128[0].x) * _1166)));
            float _2733 = mad((WorkingColorSpace_128[1].z), _1168, mad((WorkingColorSpace_128[1].y), _1167, ((WorkingColorSpace_128[1].x) * _1166)));
            float _2736 = mad((WorkingColorSpace_128[2].z), _1168, mad((WorkingColorSpace_128[2].y), _1167, ((WorkingColorSpace_128[2].x) * _1166)));
            float _2755 = exp2(log2(mad(_71, _2736, mad(_70, _2733, (_2730 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2756 = exp2(log2(mad(_74, _2736, mad(_73, _2733, (_2730 * _72))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2757 = exp2(log2(mad(_77, _2736, mad(_76, _2733, (_2730 * _75))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2850 = exp2(log2((1.0f / ((_2755 * 18.6875f) + 1.0f)) * ((_2755 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2851 = exp2(log2((1.0f / ((_2756 * 18.6875f) + 1.0f)) * ((_2756 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2852 = exp2(log2((1.0f / ((_2757 * 18.6875f) + 1.0f)) * ((_2757 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2804 = mad((WorkingColorSpace_128[0].z), _1156, mad((WorkingColorSpace_128[0].y), _1155, ((WorkingColorSpace_128[0].x) * _1154)));
                float _2807 = mad((WorkingColorSpace_128[1].z), _1156, mad((WorkingColorSpace_128[1].y), _1155, ((WorkingColorSpace_128[1].x) * _1154)));
                float _2810 = mad((WorkingColorSpace_128[2].z), _1156, mad((WorkingColorSpace_128[2].y), _1155, ((WorkingColorSpace_128[2].x) * _1154)));
                _2850 = mad(_71, _2810, mad(_70, _2807, (_2804 * _69)));
                _2851 = mad(_74, _2810, mad(_73, _2807, (_2804 * _72)));
                _2852 = mad(_77, _2810, mad(_76, _2807, (_2804 * _75)));
              } else {
                float _2823 = mad((WorkingColorSpace_128[0].z), _1182, mad((WorkingColorSpace_128[0].y), _1181, ((WorkingColorSpace_128[0].x) * _1180)));
                float _2826 = mad((WorkingColorSpace_128[1].z), _1182, mad((WorkingColorSpace_128[1].y), _1181, ((WorkingColorSpace_128[1].x) * _1180)));
                float _2829 = mad((WorkingColorSpace_128[2].z), _1182, mad((WorkingColorSpace_128[2].y), _1181, ((WorkingColorSpace_128[2].x) * _1180)));
                _2850 = exp2(log2(mad(_71, _2829, mad(_70, _2826, (_2823 * _69)))) * cb0_040z);
                _2851 = exp2(log2(mad(_74, _2829, mad(_73, _2826, (_2823 * _72)))) * cb0_040z);
                _2852 = exp2(log2(mad(_77, _2829, mad(_76, _2826, (_2823 * _75)))) * cb0_040z);
              }
            } else {
              _2850 = _1166;
              _2851 = _1167;
              _2852 = _1168;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2850 * 0.9523810148239136f), (_2851 * 0.9523810148239136f), (_2852 * 0.9523810148239136f), 0.0f);
}
