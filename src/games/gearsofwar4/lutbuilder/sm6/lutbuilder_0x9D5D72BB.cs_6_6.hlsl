// Found in Blood of Dawnwalker

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
  float cb0_005z : packoffset(c005.z);
  float cb0_005w : packoffset(c005.w);
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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  float _23[6];
  float _24[6];
  float _25[6];
  float _37 = 0.5f / cb0_035x;
  float _42 = cb0_035x + -1.0f;
  float _43 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _37)) / _42;
  float _44 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _37)) / _42;
  float _46 = float((uint)SV_DispatchThreadID.z) / _42;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _72;
  float _73;
  float _74;
  float _132;
  float _133;
  float _134;
  float _657;
  float _690;
  float _704;
  float _768;
  float _947;
  float _958;
  float _969;
  float _1192;
  float _1193;
  float _1194;
  float _1205;
  float _1216;
  float _1389;
  float _1404;
  float _1419;
  float _1427;
  float _1428;
  float _1429;
  float _1496;
  float _1529;
  float _1543;
  float _1582;
  float _1704;
  float _1784;
  float _1858;
  float _1937;
  float _1938;
  float _1939;
  float _2069;
  float _2084;
  float _2099;
  float _2107;
  float _2108;
  float _2109;
  float _2176;
  float _2209;
  float _2223;
  float _2262;
  float _2384;
  float _2470;
  float _2556;
  float _2635;
  float _2636;
  float _2637;
  float _2814;
  float _2815;
  float _2816;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _55 = (cb0_041x == 4);
        _66 = select(_55, 1.0f, 1.705051064491272f);
        _67 = select(_55, 0.0f, -0.6217921376228333f);
        _68 = select(_55, 0.0f, -0.0832589864730835f);
        _69 = select(_55, 0.0f, -0.13025647401809692f);
        _70 = select(_55, 1.0f, 1.140804648399353f);
        _71 = select(_55, 0.0f, -0.010548308491706848f);
        _72 = select(_55, 0.0f, -0.024003351107239723f);
        _73 = select(_55, 0.0f, -0.1289689838886261f);
        _74 = select(_55, 1.0f, 1.1529725790023804f);
      } else {
        _66 = 0.6954522132873535f;
        _67 = 0.14067870378494263f;
        _68 = 0.16386906802654266f;
        _69 = 0.044794563204050064f;
        _70 = 0.8596711158752441f;
        _71 = 0.0955343171954155f;
        _72 = -0.005525882821530104f;
        _73 = 0.004025210160762072f;
        _74 = 1.0015007257461548f;
      }
    } else {
      _66 = 1.0258246660232544f;
      _67 = -0.020053181797266006f;
      _68 = -0.005771636962890625f;
      _69 = -0.002234415616840124f;
      _70 = 1.0045864582061768f;
      _71 = -0.002352118492126465f;
      _72 = -0.005013350863009691f;
      _73 = -0.025290070101618767f;
      _74 = 1.0303035974502563f;
    }
  } else {
    _66 = 1.3792141675949097f;
    _67 = -0.30886411666870117f;
    _68 = -0.0703500509262085f;
    _69 = -0.06933490186929703f;
    _70 = 1.08229660987854f;
    _71 = -0.012961871922016144f;
    _72 = -0.0021590073592960835f;
    _73 = -0.0454593189060688f;
    _74 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _85 = (pow(_43, 0.012683313339948654f));
    float _86 = (pow(_44, 0.012683313339948654f));
    float _87 = (pow(_46, 0.012683313339948654f));
    _132 = (exp2(log2(max(0.0f, (_85 + -0.8359375f)) / (18.8515625f - (_85 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _133 = (exp2(log2(max(0.0f, (_86 + -0.8359375f)) / (18.8515625f - (_86 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _134 = (exp2(log2(max(0.0f, (_87 + -0.8359375f)) / (18.8515625f - (_87 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _132 = ((exp2((_43 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _133 = ((exp2((_44 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _134 = ((exp2((_46 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _149 = mad((WorkingColorSpace_128[0].z), _134, mad((WorkingColorSpace_128[0].y), _133, ((WorkingColorSpace_128[0].x) * _132)));
  float _152 = mad((WorkingColorSpace_128[1].z), _134, mad((WorkingColorSpace_128[1].y), _133, ((WorkingColorSpace_128[1].x) * _132)));
  float _155 = mad((WorkingColorSpace_128[2].z), _134, mad((WorkingColorSpace_128[2].y), _133, ((WorkingColorSpace_128[2].x) * _132)));
  float _156 = dot(float3(_149, _152, _155), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _160 = (_149 / _156) + -1.0f;
  float _161 = (_152 / _156) + -1.0f;
  float _162 = (_155 / _156) + -1.0f;
  float _174 = (1.0f - exp2(((_156 * _156) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_160, _161, _162), float3(_160, _161, _162)) * -4.0f));
  float _190 = ((mad(-0.06368321925401688f, _155, mad(-0.3292922377586365f, _152, (_149 * 1.3704125881195068f))) - _149) * _174) + _149;
  float _191 = ((mad(-0.010861365124583244f, _155, mad(1.0970927476882935f, _152, (_149 * -0.08343357592821121f))) - _152) * _174) + _152;
  float _192 = ((mad(1.2036951780319214f, _155, mad(-0.09862580895423889f, _152, (_149 * -0.02579331398010254f))) - _155) * _174) + _155;
  float _193 = dot(float3(_190, _191, _192), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _207 = cb0_019w + cb0_024w;
  float _221 = cb0_018w * cb0_023w;
  float _235 = cb0_017w * cb0_022w;
  float _249 = cb0_016w * cb0_021w;
  float _263 = cb0_015w * cb0_020w;
  float _267 = _190 - _193;
  float _268 = _191 - _193;
  float _269 = _192 - _193;
  float _326 = saturate(_193 / cb0_035w);
  float _330 = (_326 * _326) * (3.0f - (_326 * 2.0f));
  float _331 = 1.0f - _330;
  float _340 = cb0_019w + cb0_034w;
  float _349 = cb0_018w * cb0_033w;
  float _358 = cb0_017w * cb0_032w;
  float _367 = cb0_016w * cb0_031w;
  float _376 = cb0_015w * cb0_030w;
  float _439 = saturate((_193 - cb0_036x) / (cb0_036y - cb0_036x));
  float _443 = (_439 * _439) * (3.0f - (_439 * 2.0f));
  float _452 = cb0_019w + cb0_029w;
  float _461 = cb0_018w * cb0_028w;
  float _470 = cb0_017w * cb0_027w;
  float _479 = cb0_016w * cb0_026w;
  float _488 = cb0_015w * cb0_025w;
  float _546 = _330 - _443;
  float _557 = ((_443 * (((cb0_019x + cb0_034x) + _340) + (((cb0_018x * cb0_033x) * _349) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _367) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _376) * _267) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _358)))))) + (_331 * (((cb0_019x + cb0_024x) + _207) + (((cb0_018x * cb0_023x) * _221) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _249) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _263) * _267) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _235))))))) + ((((cb0_019x + cb0_029x) + _452) + (((cb0_018x * cb0_028x) * _461) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _479) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _488) * _267) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _470))))) * _546);
  float _559 = ((_443 * (((cb0_019y + cb0_034y) + _340) + (((cb0_018y * cb0_033y) * _349) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _367) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _376) * _268) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _358)))))) + (_331 * (((cb0_019y + cb0_024y) + _207) + (((cb0_018y * cb0_023y) * _221) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _249) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _263) * _268) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _235))))))) + ((((cb0_019y + cb0_029y) + _452) + (((cb0_018y * cb0_028y) * _461) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _479) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _488) * _268) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _470))))) * _546);
  float _561 = ((_443 * (((cb0_019z + cb0_034z) + _340) + (((cb0_018z * cb0_033z) * _349) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _367) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _376) * _269) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _358)))))) + (_331 * (((cb0_019z + cb0_024z) + _207) + (((cb0_018z * cb0_023z) * _221) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _249) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _263) * _269) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _235))))))) + ((((cb0_019z + cb0_029z) + _452) + (((cb0_018z * cb0_028z) * _461) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _479) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _488) * _269) + _193)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _470))))) * _546);

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

  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, cb0_005z, cb0_005w), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xyzw  is used

  float4 output = ProcessLutbuilder(float3(_557, _559, _561), s0, s1, s2, t0, t1, t2, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _597 = ((mad(0.061360642313957214f, _561, mad(-4.540197551250458e-09f, _559, (_557 * 0.9386394023895264f))) - _557) * cb0_036z) + _557;
  float _598 = ((mad(0.169205904006958f, _561, mad(0.8307942152023315f, _559, (_557 * 6.775371730327606e-08f))) - _559) * cb0_036z) + _559;
  float _599 = (mad(-2.3283064365386963e-10f, _559, (_557 * -9.313225746154785e-10f)) * cb0_036z) + _561;
  float _602 = mad(0.16386905312538147f, _599, mad(0.14067868888378143f, _598, (_597 * 0.6954522132873535f)));
  float _605 = mad(0.0955343246459961f, _599, mad(0.8596711158752441f, _598, (_597 * 0.044794581830501556f)));
  float _608 = mad(1.0015007257461548f, _599, mad(0.004025210160762072f, _598, (_597 * -0.005525882821530104f)));
  float _612 = max(max(_602, _605), _608);
  float _617 = (max(_612, 1.000000013351432e-10f) - max(min(min(_602, _605), _608), 1.000000013351432e-10f)) / max(_612, 0.009999999776482582f);
  float _630 = ((_605 + _602) + _608) + (sqrt((((_608 - _605) * _608) + ((_605 - _602) * _605)) + ((_602 - _608) * _602)) * 1.75f);
  float _631 = _630 * 0.3333333432674408f;
  float _632 = _617 + -0.4000000059604645f;
  float _633 = _632 * 5.0f;
  float _637 = max((1.0f - abs(_632 * 2.5f)), 0.0f);
  float _648 = ((float((int)(((int)(uint)((bool)(_633 > 0.0f))) - ((int)(uint)((bool)(_633 < 0.0f))))) * (1.0f - (_637 * _637))) + 1.0f) * 0.02500000037252903f;
  if (!(_631 <= 0.0533333346247673f)) {
    if (!(_631 >= 0.1599999964237213f)) {
      _657 = (((0.23999999463558197f / _630) + -0.5f) * _648);
    } else {
      _657 = 0.0f;
    }
  } else {
    _657 = _648;
  }
  float _658 = _657 + 1.0f;
  float _659 = _658 * _602;
  float _660 = _658 * _605;
  float _661 = _658 * _608;
  if (!((bool)(_659 == _660) && (bool)(_660 == _661))) {
    float _668 = ((_659 * 2.0f) - _660) - _661;
    float _671 = ((_605 - _608) * 1.7320507764816284f) * _658;
    float _673 = atan(_671 / _668);
    bool _676 = (_668 < 0.0f);
    bool _677 = (_668 == 0.0f);
    bool _678 = (_671 >= 0.0f);
    bool _679 = (_671 < 0.0f);
    _690 = select((_678 && _677), 90.0f, select((_679 && _677), -90.0f, (select((_679 && _676), (_673 + -3.1415927410125732f), select((_678 && _676), (_673 + 3.1415927410125732f), _673)) * 57.2957763671875f)));
  } else {
    _690 = 0.0f;
  }
  float _695 = min(max(select((_690 < 0.0f), (_690 + 360.0f), _690), 0.0f), 360.0f);
  if (_695 < -180.0f) {
    _704 = (_695 + 360.0f);
  } else {
    if (_695 > 180.0f) {
      _704 = (_695 + -360.0f);
    } else {
      _704 = _695;
    }
  }
  float _708 = saturate(1.0f - abs(_704 * 0.014814814552664757f));
  float _712 = (_708 * _708) * (3.0f - (_708 * 2.0f));
  float _718 = ((_712 * _712) * ((_617 * 0.18000000715255737f) * (0.029999999329447746f - _659))) + _659;
  float _728 = max(0.0f, mad(-0.21492856740951538f, _661, mad(-0.2365107536315918f, _660, (_718 * 1.4514392614364624f))));
  float _729 = max(0.0f, mad(-0.09967592358589172f, _661, mad(1.17622971534729f, _660, (_718 * -0.07655377686023712f))));
  float _730 = max(0.0f, mad(0.9977163076400757f, _661, mad(-0.006032449658960104f, _660, (_718 * 0.008316148072481155f))));
  float _731 = dot(float3(_728, _729, _730), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _746 = (cb0_038x + 1.0f) - cb0_037z;
  float _748 = cb0_038y + 1.0f;
  float _750 = _748 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _768 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _759 = (cb0_038x + 0.18000000715255737f) / _746;
    _768 = (-0.7447274923324585f - ((log2(_759 / (2.0f - _759)) * 0.3465735912322998f) * (_746 / cb0_037y)));
  }
  float _771 = ((1.0f - cb0_037z) / cb0_037y) - _768;
  float _773 = (cb0_037w / cb0_037y) - _771;
  float _777 = log2(lerp(_731, _728, 0.9599999785423279f)) * 0.3010300099849701f;
  float _778 = log2(lerp(_731, _729, 0.9599999785423279f)) * 0.3010300099849701f;
  float _779 = log2(lerp(_731, _730, 0.9599999785423279f)) * 0.3010300099849701f;
  float _783 = cb0_037y * (_777 + _771);
  float _784 = cb0_037y * (_778 + _771);
  float _785 = cb0_037y * (_779 + _771);
  float _786 = _746 * 2.0f;
  float _788 = (cb0_037y * -2.0f) / _746;
  float _789 = _777 - _768;
  float _790 = _778 - _768;
  float _791 = _779 - _768;
  float _810 = _750 * 2.0f;
  float _812 = (cb0_037y * 2.0f) / _750;
  float _837 = select((_777 < _768), ((_786 / (exp2((_789 * 1.4426950216293335f) * _788) + 1.0f)) - cb0_038x), _783);
  float _838 = select((_778 < _768), ((_786 / (exp2((_790 * 1.4426950216293335f) * _788) + 1.0f)) - cb0_038x), _784);
  float _839 = select((_779 < _768), ((_786 / (exp2((_791 * 1.4426950216293335f) * _788) + 1.0f)) - cb0_038x), _785);
  float _846 = _773 - _768;
  float _850 = saturate(_789 / _846);
  float _851 = saturate(_790 / _846);
  float _852 = saturate(_791 / _846);
  bool _853 = (_773 < _768);
  float _857 = select(_853, (1.0f - _850), _850);
  float _858 = select(_853, (1.0f - _851), _851);
  float _859 = select(_853, (1.0f - _852), _852);
  float _878 = (((_857 * _857) * (select((_777 > _773), (_748 - (_810 / (exp2(((_777 - _773) * 1.4426950216293335f) * _812) + 1.0f))), _783) - _837)) * (3.0f - (_857 * 2.0f))) + _837;
  float _879 = (((_858 * _858) * (select((_778 > _773), (_748 - (_810 / (exp2(((_778 - _773) * 1.4426950216293335f) * _812) + 1.0f))), _784) - _838)) * (3.0f - (_858 * 2.0f))) + _838;
  float _880 = (((_859 * _859) * (select((_779 > _773), (_748 - (_810 / (exp2(((_779 - _773) * 1.4426950216293335f) * _812) + 1.0f))), _785) - _839)) * (3.0f - (_859 * 2.0f))) + _839;
  float _881 = dot(float3(_878, _879, _880), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _901 = (cb0_037x * (max(0.0f, (lerp(_881, _878, 0.9300000071525574f))) - _597)) + _597;
  float _902 = (cb0_037x * (max(0.0f, (lerp(_881, _879, 0.9300000071525574f))) - _598)) + _598;
  float _903 = (cb0_037x * (max(0.0f, (lerp(_881, _880, 0.9300000071525574f))) - _599)) + _599;
  float _919 = ((mad(-0.06537103652954102f, _903, mad(1.451815478503704e-06f, _902, (_901 * 1.065374732017517f))) - _901) * cb0_036z) + _901;
  float _920 = ((mad(-0.20366770029067993f, _903, mad(1.2036634683609009f, _902, (_901 * -2.57161445915699e-07f))) - _902) * cb0_036z) + _902;
  float _921 = ((mad(0.9999996423721313f, _903, mad(2.0954757928848267e-08f, _902, (_901 * 1.862645149230957e-08f))) - _903) * cb0_036z) + _903;
  float _934 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _921, mad((WorkingColorSpace_192[0].y), _920, ((WorkingColorSpace_192[0].x) * _919)))));
  float _935 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _921, mad((WorkingColorSpace_192[1].y), _920, ((WorkingColorSpace_192[1].x) * _919)))));
  float _936 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _921, mad((WorkingColorSpace_192[2].y), _920, ((WorkingColorSpace_192[2].x) * _919)))));
  if (_934 < 0.0031306699384003878f) {
    _947 = (_934 * 12.920000076293945f);
  } else {
    _947 = (((pow(_934, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_935 < 0.0031306699384003878f) {
    _958 = (_935 * 12.920000076293945f);
  } else {
    _958 = (((pow(_935, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_936 < 0.0031306699384003878f) {
    _969 = (_936 * 12.920000076293945f);
  } else {
    _969 = (((pow(_936, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _973 = (_958 * 0.9375f) + 0.03125f;
  float _980 = _969 * 15.0f;
  float _981 = floor(_980);
  float _982 = _980 - _981;
  float _984 = (_981 + ((_947 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _987 = t0.SampleLevel(s0, float2(_984, _973), 0.0f);
  float _991 = _984 + 0.0625f;
  float4 _992 = t0.SampleLevel(s0, float2(_991, _973), 0.0f);
  float4 _1014 = t1.SampleLevel(s1, float2(_984, _973), 0.0f);
  float4 _1018 = t1.SampleLevel(s1, float2(_991, _973), 0.0f);
  float4 _1040 = t2.SampleLevel(s2, float2(_984, _973), 0.0f);
  float4 _1044 = t2.SampleLevel(s2, float2(_991, _973), 0.0f);
  float _1063 = max(6.103519990574569e-05f, (((((lerp(_987.x, _992.x, _982)) * cb0_005y) + (cb0_005x * _947)) + ((lerp(_1014.x, _1018.x, _982)) * cb0_005z)) + ((lerp(_1040.x, _1044.x, _982)) * cb0_005w)));
  float _1064 = max(6.103519990574569e-05f, (((((lerp(_987.y, _992.y, _982)) * cb0_005y) + (cb0_005x * _958)) + ((lerp(_1014.y, _1018.y, _982)) * cb0_005z)) + ((lerp(_1040.y, _1044.y, _982)) * cb0_005w)));
  float _1065 = max(6.103519990574569e-05f, (((((lerp(_987.z, _992.z, _982)) * cb0_005y) + (cb0_005x * _969)) + ((lerp(_1014.z, _1018.z, _982)) * cb0_005z)) + ((lerp(_1040.z, _1044.z, _982)) * cb0_005w)));
  float _1087 = select((_1063 > 0.040449999272823334f), exp2(log2((_1063 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1063 * 0.07739938050508499f));
  float _1088 = select((_1064 > 0.040449999272823334f), exp2(log2((_1064 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1064 * 0.07739938050508499f));
  float _1089 = select((_1065 > 0.040449999272823334f), exp2(log2((_1065 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1065 * 0.07739938050508499f));
  float _1115 = cb0_014x * (((cb0_039y + (cb0_039x * _1087)) * _1087) + cb0_039z);
  float _1116 = cb0_014y * (((cb0_039y + (cb0_039x * _1088)) * _1088) + cb0_039z);
  float _1117 = cb0_014z * (((cb0_039y + (cb0_039x * _1089)) * _1089) + cb0_039z);
  float _1124 = ((cb0_013x - _1115) * cb0_013w) + _1115;
  float _1125 = ((cb0_013y - _1116) * cb0_013w) + _1116;
  float _1126 = ((cb0_013z - _1117) * cb0_013w) + _1117;
  float _1127 = cb0_014x * mad((WorkingColorSpace_192[0].z), _561, mad((WorkingColorSpace_192[0].y), _559, (_557 * (WorkingColorSpace_192[0].x))));
  float _1128 = cb0_014y * mad((WorkingColorSpace_192[1].z), _561, mad((WorkingColorSpace_192[1].y), _559, ((WorkingColorSpace_192[1].x) * _557)));
  float _1129 = cb0_014z * mad((WorkingColorSpace_192[2].z), _561, mad((WorkingColorSpace_192[2].y), _559, ((WorkingColorSpace_192[2].x) * _557)));
  float _1136 = ((cb0_013x - _1127) * cb0_013w) + _1127;
  float _1137 = ((cb0_013y - _1128) * cb0_013w) + _1128;
  float _1138 = ((cb0_013z - _1129) * cb0_013w) + _1129;
  float _1150 = exp2(log2(max(0.0f, _1124)) * cb0_040y);
  float _1151 = exp2(log2(max(0.0f, _1125)) * cb0_040y);
  float _1152 = exp2(log2(max(0.0f, _1126)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1175 = mad((WorkingColorSpace_128[0].z), _1152, mad((WorkingColorSpace_128[0].y), _1151, ((WorkingColorSpace_128[0].x) * _1150)));
        float _1178 = mad((WorkingColorSpace_128[1].z), _1152, mad((WorkingColorSpace_128[1].y), _1151, ((WorkingColorSpace_128[1].x) * _1150)));
        float _1181 = mad((WorkingColorSpace_128[2].z), _1152, mad((WorkingColorSpace_128[2].y), _1151, ((WorkingColorSpace_128[2].x) * _1150)));
        _1192 = mad(_68, _1181, mad(_67, _1178, (_1175 * _66)));
        _1193 = mad(_71, _1181, mad(_70, _1178, (_1175 * _69)));
        _1194 = mad(_74, _1181, mad(_73, _1178, (_1175 * _72)));
      } else {
        _1192 = _1150;
        _1193 = _1151;
        _1194 = _1152;
      }
      do {
        if (_1192 < 0.0031306699384003878f) {
          _1205 = (_1192 * 12.920000076293945f);
        } else {
          _1205 = (((pow(_1192, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1193 < 0.0031306699384003878f) {
            _1216 = (_1193 * 12.920000076293945f);
          } else {
            _1216 = (((pow(_1193, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1194 < 0.0031306699384003878f) {
            _2814 = _1205;
            _2815 = _1216;
            _2816 = (_1194 * 12.920000076293945f);
          } else {
            _2814 = _1205;
            _2815 = _1216;
            _2816 = (((pow(_1194, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1243 = mad((WorkingColorSpace_128[0].z), _1152, mad((WorkingColorSpace_128[0].y), _1151, ((WorkingColorSpace_128[0].x) * _1150)));
      float _1246 = mad((WorkingColorSpace_128[1].z), _1152, mad((WorkingColorSpace_128[1].y), _1151, ((WorkingColorSpace_128[1].x) * _1150)));
      float _1249 = mad((WorkingColorSpace_128[2].z), _1152, mad((WorkingColorSpace_128[2].y), _1151, ((WorkingColorSpace_128[2].x) * _1150)));
      float _1259 = max(6.103519990574569e-05f, mad(_68, _1249, mad(_67, _1246, (_1243 * _66))));
      float _1260 = max(6.103519990574569e-05f, mad(_71, _1249, mad(_70, _1246, (_1243 * _69))));
      float _1261 = max(6.103519990574569e-05f, mad(_74, _1249, mad(_73, _1246, (_1243 * _72))));
      _2814 = min((_1259 * 4.5f), ((exp2(log2(max(_1259, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2815 = min((_1260 * 4.5f), ((exp2(log2(max(_1260, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2816 = min((_1261 * 4.5f), ((exp2(log2(max(_1261, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1337 = cb0_012z * _1136;
        float _1338 = cb0_012z * _1137;
        float _1339 = cb0_012z * _1138;
        float _1342 = mad((WorkingColorSpace_256[0].z), _1339, mad((WorkingColorSpace_256[0].y), _1338, ((WorkingColorSpace_256[0].x) * _1337)));
        float _1345 = mad((WorkingColorSpace_256[1].z), _1339, mad((WorkingColorSpace_256[1].y), _1338, ((WorkingColorSpace_256[1].x) * _1337)));
        float _1348 = mad((WorkingColorSpace_256[2].z), _1339, mad((WorkingColorSpace_256[2].y), _1338, ((WorkingColorSpace_256[2].x) * _1337)));
        float _1351 = mad(-0.21492856740951538f, _1348, mad(-0.2365107536315918f, _1345, (_1342 * 1.4514392614364624f)));
        float _1354 = mad(-0.09967592358589172f, _1348, mad(1.17622971534729f, _1345, (_1342 * -0.07655377686023712f)));
        float _1357 = mad(0.9977163076400757f, _1348, mad(-0.006032449658960104f, _1345, (_1342 * 0.008316148072481155f)));
        float _1359 = max(_1351, max(_1354, _1357));
        do {
          if (!(_1359 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1342 < 0.0f) || (bool)(_1345 < 0.0f))) || (bool)(_1348 < 0.0f))) {
              float _1369 = abs(_1359);
              float _1370 = (_1359 - _1351) / _1369;
              float _1372 = (_1359 - _1354) / _1369;
              float _1374 = (_1359 - _1357) / _1369;
              do {
                if (!(_1370 < 0.8149999976158142f)) {
                  float _1377 = _1370 + -0.8149999976158142f;
                  _1389 = ((_1377 / exp2(log2(exp2(log2(_1377 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1389 = _1370;
                }
                do {
                  if (!(_1372 < 0.8029999732971191f)) {
                    float _1392 = _1372 + -0.8029999732971191f;
                    _1404 = ((_1392 / exp2(log2(exp2(log2(_1392 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1404 = _1372;
                  }
                  do {
                    if (!(_1374 < 0.8799999952316284f)) {
                      float _1407 = _1374 + -0.8799999952316284f;
                      _1419 = ((_1407 / exp2(log2(exp2(log2(_1407 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1419 = _1374;
                    }
                    _1427 = (_1359 - (_1369 * _1389));
                    _1428 = (_1359 - (_1369 * _1404));
                    _1429 = (_1359 - (_1369 * _1419));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1427 = _1351;
              _1428 = _1354;
              _1429 = _1357;
            }
          } else {
            _1427 = _1351;
            _1428 = _1354;
            _1429 = _1357;
          }
          float _1445 = ((mad(0.16386906802654266f, _1429, mad(0.14067870378494263f, _1428, (_1427 * 0.6954522132873535f))) - _1342) * cb0_012w) + _1342;
          float _1446 = ((mad(0.0955343171954155f, _1429, mad(0.8596711158752441f, _1428, (_1427 * 0.044794563204050064f))) - _1345) * cb0_012w) + _1345;
          float _1447 = ((mad(1.0015007257461548f, _1429, mad(0.004025210160762072f, _1428, (_1427 * -0.005525882821530104f))) - _1348) * cb0_012w) + _1348;
          float _1451 = max(max(_1445, _1446), _1447);
          float _1456 = (max(_1451, 1.000000013351432e-10f) - max(min(min(_1445, _1446), _1447), 1.000000013351432e-10f)) / max(_1451, 0.009999999776482582f);
          float _1469 = ((_1446 + _1445) + _1447) + (sqrt((((_1447 - _1446) * _1447) + ((_1446 - _1445) * _1446)) + ((_1445 - _1447) * _1445)) * 1.75f);
          float _1470 = _1469 * 0.3333333432674408f;
          float _1471 = _1456 + -0.4000000059604645f;
          float _1472 = _1471 * 5.0f;
          float _1476 = max((1.0f - abs(_1471 * 2.5f)), 0.0f);
          float _1487 = ((float((int)(((int)(uint)((bool)(_1472 > 0.0f))) - ((int)(uint)((bool)(_1472 < 0.0f))))) * (1.0f - (_1476 * _1476))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1470 <= 0.0533333346247673f)) {
              if (!(_1470 >= 0.1599999964237213f)) {
                _1496 = (((0.23999999463558197f / _1469) + -0.5f) * _1487);
              } else {
                _1496 = 0.0f;
              }
            } else {
              _1496 = _1487;
            }
            float _1497 = _1496 + 1.0f;
            float _1498 = _1497 * _1445;
            float _1499 = _1497 * _1446;
            float _1500 = _1497 * _1447;
            do {
              if (!((bool)(_1498 == _1499) && (bool)(_1499 == _1500))) {
                float _1507 = ((_1498 * 2.0f) - _1499) - _1500;
                float _1510 = ((_1446 - _1447) * 1.7320507764816284f) * _1497;
                float _1512 = atan(_1510 / _1507);
                bool _1515 = (_1507 < 0.0f);
                bool _1516 = (_1507 == 0.0f);
                bool _1517 = (_1510 >= 0.0f);
                bool _1518 = (_1510 < 0.0f);
                _1529 = select((_1517 && _1516), 90.0f, select((_1518 && _1516), -90.0f, (select((_1518 && _1515), (_1512 + -3.1415927410125732f), select((_1517 && _1515), (_1512 + 3.1415927410125732f), _1512)) * 57.2957763671875f)));
              } else {
                _1529 = 0.0f;
              }
              float _1534 = min(max(select((_1529 < 0.0f), (_1529 + 360.0f), _1529), 0.0f), 360.0f);
              do {
                if (_1534 < -180.0f) {
                  _1543 = (_1534 + 360.0f);
                } else {
                  if (_1534 > 180.0f) {
                    _1543 = (_1534 + -360.0f);
                  } else {
                    _1543 = _1534;
                  }
                }
                do {
                  if ((bool)(_1543 > -67.5f) && (bool)(_1543 < 67.5f)) {
                    float _1549 = (_1543 + 67.5f) * 0.029629629105329514f;
                    int _1550 = int(_1549);
                    float _1552 = _1549 - float((int)(_1550));
                    float _1553 = _1552 * _1552;
                    float _1554 = _1553 * _1552;
                    if (_1550 == 3) {
                      _1582 = (((0.1666666716337204f - (_1552 * 0.5f)) + (_1553 * 0.5f)) - (_1554 * 0.1666666716337204f));
                    } else {
                      if (_1550 == 2) {
                        _1582 = ((0.6666666865348816f - _1553) + (_1554 * 0.5f));
                      } else {
                        if (_1550 == 1) {
                          _1582 = (((_1554 * -0.5f) + 0.1666666716337204f) + ((_1553 + _1552) * 0.5f));
                        } else {
                          _1582 = select((_1550 == 0), (_1554 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1582 = 0.0f;
                  }
                  float _1591 = min(max(((((_1456 * 0.27000001072883606f) * (0.029999999329447746f - _1498)) * _1582) + _1498), 0.0f), 65535.0f);
                  float _1592 = min(max(_1499, 0.0f), 65535.0f);
                  float _1593 = min(max(_1500, 0.0f), 65535.0f);
                  float _1606 = min(max(mad(-0.21492856740951538f, _1593, mad(-0.2365107536315918f, _1592, (_1591 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1607 = min(max(mad(-0.09967592358589172f, _1593, mad(1.17622971534729f, _1592, (_1591 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1608 = min(max(mad(0.9977163076400757f, _1593, mad(-0.006032449658960104f, _1592, (_1591 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1609 = dot(float3(_1606, _1607, _1608), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1632 = log2(max((lerp(_1609, _1606, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1633 = _1632 * 0.3010300099849701f;
                  float _1634 = log2(cb0_008x);
                  float _1635 = _1634 * 0.3010300099849701f;
                  do {
                    if (!(!(_1633 <= _1635))) {
                      _1704 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1642 = log2(cb0_009x);
                      float _1643 = _1642 * 0.3010300099849701f;
                      if ((bool)(_1633 > _1635) && (bool)(_1633 < _1643)) {
                        float _1651 = ((_1632 - _1634) * 0.9030900001525879f) / ((_1642 - _1634) * 0.3010300099849701f);
                        int _1652 = int(_1651);
                        float _1654 = _1651 - float((int)(_1652));
                        float _1656 = _23[_1652];
                        float _1659 = _23[(_1652 + 1)];
                        float _1664 = _1656 * 0.5f;
                        _1704 = dot(float3((_1654 * _1654), _1654, 1.0f), float3(mad((_23[(_1652 + 2)]), 0.5f, mad(_1659, -1.0f, _1664)), (_1659 - _1656), mad(_1659, 0.5f, _1664)));
                      } else {
                        do {
                          if (!(!(_1633 >= _1643))) {
                            float _1673 = log2(cb0_008z);
                            if (_1633 < (_1673 * 0.3010300099849701f)) {
                              float _1681 = ((_1632 - _1642) * 0.9030900001525879f) / ((_1673 - _1642) * 0.3010300099849701f);
                              int _1682 = int(_1681);
                              float _1684 = _1681 - float((int)(_1682));
                              float _1686 = _24[_1682];
                              float _1689 = _24[(_1682 + 1)];
                              float _1694 = _1686 * 0.5f;
                              _1704 = dot(float3((_1684 * _1684), _1684, 1.0f), float3(mad((_24[(_1682 + 2)]), 0.5f, mad(_1689, -1.0f, _1694)), (_1689 - _1686), mad(_1689, 0.5f, _1694)));
                              break;
                            }
                          }
                          _1704 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    _25[0] = cb0_010x;
                    _25[1] = cb0_010y;
                    _25[2] = cb0_010z;
                    _25[3] = cb0_010w;
                    _25[4] = cb0_012x;
                    _25[5] = cb0_012x;
                    float _1714 = log2(max((lerp(_1609, _1607, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1715 = _1714 * 0.3010300099849701f;
                    do {
                      if (!(!(_1715 <= _1635))) {
                        _1784 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1722 = log2(cb0_009x);
                        float _1723 = _1722 * 0.3010300099849701f;
                        if ((bool)(_1715 > _1635) && (bool)(_1715 < _1723)) {
                          float _1731 = ((_1714 - _1634) * 0.9030900001525879f) / ((_1722 - _1634) * 0.3010300099849701f);
                          int _1732 = int(_1731);
                          float _1734 = _1731 - float((int)(_1732));
                          float _1736 = _25[_1732];
                          float _1739 = _25[(_1732 + 1)];
                          float _1744 = _1736 * 0.5f;
                          _1784 = dot(float3((_1734 * _1734), _1734, 1.0f), float3(mad((_25[(_1732 + 2)]), 0.5f, mad(_1739, -1.0f, _1744)), (_1739 - _1736), mad(_1739, 0.5f, _1744)));
                        } else {
                          do {
                            if (!(!(_1715 >= _1723))) {
                              float _1753 = log2(cb0_008z);
                              if (_1715 < (_1753 * 0.3010300099849701f)) {
                                float _1761 = ((_1714 - _1722) * 0.9030900001525879f) / ((_1753 - _1722) * 0.3010300099849701f);
                                int _1762 = int(_1761);
                                float _1764 = _1761 - float((int)(_1762));
                                float _1766 = _16[_1762];
                                float _1769 = _16[(_1762 + 1)];
                                float _1774 = _1766 * 0.5f;
                                _1784 = dot(float3((_1764 * _1764), _1764, 1.0f), float3(mad((_16[(_1762 + 2)]), 0.5f, mad(_1769, -1.0f, _1774)), (_1769 - _1766), mad(_1769, 0.5f, _1774)));
                                break;
                              }
                            }
                            _1784 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1788 = log2(max((lerp(_1609, _1608, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1789 = _1788 * 0.3010300099849701f;
                      do {
                        if (!(!(_1789 <= _1635))) {
                          _1858 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1796 = log2(cb0_009x);
                          float _1797 = _1796 * 0.3010300099849701f;
                          if ((bool)(_1789 > _1635) && (bool)(_1789 < _1797)) {
                            float _1805 = ((_1788 - _1634) * 0.9030900001525879f) / ((_1796 - _1634) * 0.3010300099849701f);
                            int _1806 = int(_1805);
                            float _1808 = _1805 - float((int)(_1806));
                            float _1810 = _15[_1806];
                            float _1813 = _15[(_1806 + 1)];
                            float _1818 = _1810 * 0.5f;
                            _1858 = dot(float3((_1808 * _1808), _1808, 1.0f), float3(mad((_15[(_1806 + 2)]), 0.5f, mad(_1813, -1.0f, _1818)), (_1813 - _1810), mad(_1813, 0.5f, _1818)));
                          } else {
                            do {
                              if (!(!(_1789 >= _1797))) {
                                float _1827 = log2(cb0_008z);
                                if (_1789 < (_1827 * 0.3010300099849701f)) {
                                  float _1835 = ((_1788 - _1796) * 0.9030900001525879f) / ((_1827 - _1796) * 0.3010300099849701f);
                                  int _1836 = int(_1835);
                                  float _1838 = _1835 - float((int)(_1836));
                                  float _1840 = _16[_1836];
                                  float _1843 = _16[(_1836 + 1)];
                                  float _1848 = _1840 * 0.5f;
                                  _1858 = dot(float3((_1838 * _1838), _1838, 1.0f), float3(mad((_16[(_1836 + 2)]), 0.5f, mad(_1843, -1.0f, _1848)), (_1843 - _1840), mad(_1843, 0.5f, _1848)));
                                  break;
                                }
                              }
                              _1858 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1862 = cb0_008w - cb0_008y;
                        float _1863 = (exp2(_1704 * 3.321928024291992f) - cb0_008y) / _1862;
                        float _1865 = (exp2(_1784 * 3.321928024291992f) - cb0_008y) / _1862;
                        float _1867 = (exp2(_1858 * 3.321928024291992f) - cb0_008y) / _1862;
                        float _1870 = mad(0.15618768334388733f, _1867, mad(0.13400420546531677f, _1865, (_1863 * 0.6624541878700256f)));
                        float _1873 = mad(0.053689517080783844f, _1867, mad(0.6740817427635193f, _1865, (_1863 * 0.2722287178039551f)));
                        float _1876 = mad(1.0103391408920288f, _1867, mad(0.00406073359772563f, _1865, (_1863 * -0.005574649665504694f)));
                        float _1889 = min(max(mad(-0.23642469942569733f, _1876, mad(-0.32480329275131226f, _1873, (_1870 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1890 = min(max(mad(0.016756348311901093f, _1876, mad(1.6153316497802734f, _1873, (_1870 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1891 = min(max(mad(0.9883948564529419f, _1876, mad(-0.008284442126750946f, _1873, (_1870 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1894 = mad(0.15618768334388733f, _1891, mad(0.13400420546531677f, _1890, (_1889 * 0.6624541878700256f)));
                        float _1897 = mad(0.053689517080783844f, _1891, mad(0.6740817427635193f, _1890, (_1889 * 0.2722287178039551f)));
                        float _1900 = mad(1.0103391408920288f, _1891, mad(0.00406073359772563f, _1890, (_1889 * -0.005574649665504694f)));
                        float _1922 = min(max((min(max(mad(-0.23642469942569733f, _1900, mad(-0.32480329275131226f, _1897, (_1894 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1923 = min(max((min(max(mad(0.016756348311901093f, _1900, mad(1.6153316497802734f, _1897, (_1894 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1924 = min(max((min(max(mad(0.9883948564529419f, _1900, mad(-0.008284442126750946f, _1897, (_1894 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _1937 = mad(_68, _1924, mad(_67, _1923, (_1922 * _66)));
                            _1938 = mad(_71, _1924, mad(_70, _1923, (_1922 * _69)));
                            _1939 = mad(_74, _1924, mad(_73, _1923, (_1922 * _72)));
                          } else {
                            _1937 = _1922;
                            _1938 = _1923;
                            _1939 = _1924;
                          }
                          float _1949 = exp2(log2(_1937 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1950 = exp2(log2(_1938 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1951 = exp2(log2(_1939 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2814 = exp2(log2((1.0f / ((_1949 * 18.6875f) + 1.0f)) * ((_1949 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2815 = exp2(log2((1.0f / ((_1950 * 18.6875f) + 1.0f)) * ((_1950 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2816 = exp2(log2((1.0f / ((_1951 * 18.6875f) + 1.0f)) * ((_1951 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _2017 = cb0_012z * _1136;
          float _2018 = cb0_012z * _1137;
          float _2019 = cb0_012z * _1138;
          float _2022 = mad((WorkingColorSpace_256[0].z), _2019, mad((WorkingColorSpace_256[0].y), _2018, ((WorkingColorSpace_256[0].x) * _2017)));
          float _2025 = mad((WorkingColorSpace_256[1].z), _2019, mad((WorkingColorSpace_256[1].y), _2018, ((WorkingColorSpace_256[1].x) * _2017)));
          float _2028 = mad((WorkingColorSpace_256[2].z), _2019, mad((WorkingColorSpace_256[2].y), _2018, ((WorkingColorSpace_256[2].x) * _2017)));
          float _2031 = mad(-0.21492856740951538f, _2028, mad(-0.2365107536315918f, _2025, (_2022 * 1.4514392614364624f)));
          float _2034 = mad(-0.09967592358589172f, _2028, mad(1.17622971534729f, _2025, (_2022 * -0.07655377686023712f)));
          float _2037 = mad(0.9977163076400757f, _2028, mad(-0.006032449658960104f, _2025, (_2022 * 0.008316148072481155f)));
          float _2039 = max(_2031, max(_2034, _2037));
          do {
            if (!(_2039 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2022 < 0.0f) || (bool)(_2025 < 0.0f))) || (bool)(_2028 < 0.0f))) {
                float _2049 = abs(_2039);
                float _2050 = (_2039 - _2031) / _2049;
                float _2052 = (_2039 - _2034) / _2049;
                float _2054 = (_2039 - _2037) / _2049;
                do {
                  if (!(_2050 < 0.8149999976158142f)) {
                    float _2057 = _2050 + -0.8149999976158142f;
                    _2069 = ((_2057 / exp2(log2(exp2(log2(_2057 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2069 = _2050;
                  }
                  do {
                    if (!(_2052 < 0.8029999732971191f)) {
                      float _2072 = _2052 + -0.8029999732971191f;
                      _2084 = ((_2072 / exp2(log2(exp2(log2(_2072 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2084 = _2052;
                    }
                    do {
                      if (!(_2054 < 0.8799999952316284f)) {
                        float _2087 = _2054 + -0.8799999952316284f;
                        _2099 = ((_2087 / exp2(log2(exp2(log2(_2087 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2099 = _2054;
                      }
                      _2107 = (_2039 - (_2049 * _2069));
                      _2108 = (_2039 - (_2049 * _2084));
                      _2109 = (_2039 - (_2049 * _2099));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2107 = _2031;
                _2108 = _2034;
                _2109 = _2037;
              }
            } else {
              _2107 = _2031;
              _2108 = _2034;
              _2109 = _2037;
            }
            float _2125 = ((mad(0.16386906802654266f, _2109, mad(0.14067870378494263f, _2108, (_2107 * 0.6954522132873535f))) - _2022) * cb0_012w) + _2022;
            float _2126 = ((mad(0.0955343171954155f, _2109, mad(0.8596711158752441f, _2108, (_2107 * 0.044794563204050064f))) - _2025) * cb0_012w) + _2025;
            float _2127 = ((mad(1.0015007257461548f, _2109, mad(0.004025210160762072f, _2108, (_2107 * -0.005525882821530104f))) - _2028) * cb0_012w) + _2028;
            float _2131 = max(max(_2125, _2126), _2127);
            float _2136 = (max(_2131, 1.000000013351432e-10f) - max(min(min(_2125, _2126), _2127), 1.000000013351432e-10f)) / max(_2131, 0.009999999776482582f);
            float _2149 = ((_2126 + _2125) + _2127) + (sqrt((((_2127 - _2126) * _2127) + ((_2126 - _2125) * _2126)) + ((_2125 - _2127) * _2125)) * 1.75f);
            float _2150 = _2149 * 0.3333333432674408f;
            float _2151 = _2136 + -0.4000000059604645f;
            float _2152 = _2151 * 5.0f;
            float _2156 = max((1.0f - abs(_2151 * 2.5f)), 0.0f);
            float _2167 = ((float((int)(((int)(uint)((bool)(_2152 > 0.0f))) - ((int)(uint)((bool)(_2152 < 0.0f))))) * (1.0f - (_2156 * _2156))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2150 <= 0.0533333346247673f)) {
                if (!(_2150 >= 0.1599999964237213f)) {
                  _2176 = (((0.23999999463558197f / _2149) + -0.5f) * _2167);
                } else {
                  _2176 = 0.0f;
                }
              } else {
                _2176 = _2167;
              }
              float _2177 = _2176 + 1.0f;
              float _2178 = _2177 * _2125;
              float _2179 = _2177 * _2126;
              float _2180 = _2177 * _2127;
              do {
                if (!((bool)(_2178 == _2179) && (bool)(_2179 == _2180))) {
                  float _2187 = ((_2178 * 2.0f) - _2179) - _2180;
                  float _2190 = ((_2126 - _2127) * 1.7320507764816284f) * _2177;
                  float _2192 = atan(_2190 / _2187);
                  bool _2195 = (_2187 < 0.0f);
                  bool _2196 = (_2187 == 0.0f);
                  bool _2197 = (_2190 >= 0.0f);
                  bool _2198 = (_2190 < 0.0f);
                  _2209 = select((_2197 && _2196), 90.0f, select((_2198 && _2196), -90.0f, (select((_2198 && _2195), (_2192 + -3.1415927410125732f), select((_2197 && _2195), (_2192 + 3.1415927410125732f), _2192)) * 57.2957763671875f)));
                } else {
                  _2209 = 0.0f;
                }
                float _2214 = min(max(select((_2209 < 0.0f), (_2209 + 360.0f), _2209), 0.0f), 360.0f);
                do {
                  if (_2214 < -180.0f) {
                    _2223 = (_2214 + 360.0f);
                  } else {
                    if (_2214 > 180.0f) {
                      _2223 = (_2214 + -360.0f);
                    } else {
                      _2223 = _2214;
                    }
                  }
                  do {
                    if ((bool)(_2223 > -67.5f) && (bool)(_2223 < 67.5f)) {
                      float _2229 = (_2223 + 67.5f) * 0.029629629105329514f;
                      int _2230 = int(_2229);
                      float _2232 = _2229 - float((int)(_2230));
                      float _2233 = _2232 * _2232;
                      float _2234 = _2233 * _2232;
                      if (_2230 == 3) {
                        _2262 = (((0.1666666716337204f - (_2232 * 0.5f)) + (_2233 * 0.5f)) - (_2234 * 0.1666666716337204f));
                      } else {
                        if (_2230 == 2) {
                          _2262 = ((0.6666666865348816f - _2233) + (_2234 * 0.5f));
                        } else {
                          if (_2230 == 1) {
                            _2262 = (((_2234 * -0.5f) + 0.1666666716337204f) + ((_2233 + _2232) * 0.5f));
                          } else {
                            _2262 = select((_2230 == 0), (_2234 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2262 = 0.0f;
                    }
                    float _2271 = min(max(((((_2136 * 0.27000001072883606f) * (0.029999999329447746f - _2178)) * _2262) + _2178), 0.0f), 65535.0f);
                    float _2272 = min(max(_2179, 0.0f), 65535.0f);
                    float _2273 = min(max(_2180, 0.0f), 65535.0f);
                    float _2286 = min(max(mad(-0.21492856740951538f, _2273, mad(-0.2365107536315918f, _2272, (_2271 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2287 = min(max(mad(-0.09967592358589172f, _2273, mad(1.17622971534729f, _2272, (_2271 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2288 = min(max(mad(0.9977163076400757f, _2273, mad(-0.006032449658960104f, _2272, (_2271 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2289 = dot(float3(_2286, _2287, _2288), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2312 = log2(max((lerp(_2289, _2286, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2313 = _2312 * 0.3010300099849701f;
                    float _2314 = log2(cb0_008x);
                    float _2315 = _2314 * 0.3010300099849701f;
                    do {
                      if (!(!(_2313 <= _2315))) {
                        _2384 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2322 = log2(cb0_009x);
                        float _2323 = _2322 * 0.3010300099849701f;
                        if ((bool)(_2313 > _2315) && (bool)(_2313 < _2323)) {
                          float _2331 = ((_2312 - _2314) * 0.9030900001525879f) / ((_2322 - _2314) * 0.3010300099849701f);
                          int _2332 = int(_2331);
                          float _2334 = _2331 - float((int)(_2332));
                          float _2336 = _21[_2332];
                          float _2339 = _21[(_2332 + 1)];
                          float _2344 = _2336 * 0.5f;
                          _2384 = dot(float3((_2334 * _2334), _2334, 1.0f), float3(mad((_21[(_2332 + 2)]), 0.5f, mad(_2339, -1.0f, _2344)), (_2339 - _2336), mad(_2339, 0.5f, _2344)));
                        } else {
                          do {
                            if (!(!(_2313 >= _2323))) {
                              float _2353 = log2(cb0_008z);
                              if (_2313 < (_2353 * 0.3010300099849701f)) {
                                float _2361 = ((_2312 - _2322) * 0.9030900001525879f) / ((_2353 - _2322) * 0.3010300099849701f);
                                int _2362 = int(_2361);
                                float _2364 = _2361 - float((int)(_2362));
                                float _2366 = _22[_2362];
                                float _2369 = _22[(_2362 + 1)];
                                float _2374 = _2366 * 0.5f;
                                _2384 = dot(float3((_2364 * _2364), _2364, 1.0f), float3(mad((_22[(_2362 + 2)]), 0.5f, mad(_2369, -1.0f, _2374)), (_2369 - _2366), mad(_2369, 0.5f, _2374)));
                                break;
                              }
                            }
                            _2384 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _2400 = log2(max((lerp(_2289, _2287, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2401 = _2400 * 0.3010300099849701f;
                      do {
                        if (!(!(_2401 <= _2315))) {
                          _2470 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2408 = log2(cb0_009x);
                          float _2409 = _2408 * 0.3010300099849701f;
                          if ((bool)(_2401 > _2315) && (bool)(_2401 < _2409)) {
                            float _2417 = ((_2400 - _2314) * 0.9030900001525879f) / ((_2408 - _2314) * 0.3010300099849701f);
                            int _2418 = int(_2417);
                            float _2420 = _2417 - float((int)(_2418));
                            float _2422 = _17[_2418];
                            float _2425 = _17[(_2418 + 1)];
                            float _2430 = _2422 * 0.5f;
                            _2470 = dot(float3((_2420 * _2420), _2420, 1.0f), float3(mad((_17[(_2418 + 2)]), 0.5f, mad(_2425, -1.0f, _2430)), (_2425 - _2422), mad(_2425, 0.5f, _2430)));
                          } else {
                            do {
                              if (!(!(_2401 >= _2409))) {
                                float _2439 = log2(cb0_008z);
                                if (_2401 < (_2439 * 0.3010300099849701f)) {
                                  float _2447 = ((_2400 - _2408) * 0.9030900001525879f) / ((_2439 - _2408) * 0.3010300099849701f);
                                  int _2448 = int(_2447);
                                  float _2450 = _2447 - float((int)(_2448));
                                  float _2452 = _18[_2448];
                                  float _2455 = _18[(_2448 + 1)];
                                  float _2460 = _2452 * 0.5f;
                                  _2470 = dot(float3((_2450 * _2450), _2450, 1.0f), float3(mad((_18[(_2448 + 2)]), 0.5f, mad(_2455, -1.0f, _2460)), (_2455 - _2452), mad(_2455, 0.5f, _2460)));
                                  break;
                                }
                              }
                              _2470 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2486 = log2(max((lerp(_2289, _2288, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2487 = _2486 * 0.3010300099849701f;
                        do {
                          if (!(!(_2487 <= _2315))) {
                            _2556 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2494 = log2(cb0_009x);
                            float _2495 = _2494 * 0.3010300099849701f;
                            if ((bool)(_2487 > _2315) && (bool)(_2487 < _2495)) {
                              float _2503 = ((_2486 - _2314) * 0.9030900001525879f) / ((_2494 - _2314) * 0.3010300099849701f);
                              int _2504 = int(_2503);
                              float _2506 = _2503 - float((int)(_2504));
                              float _2508 = _19[_2504];
                              float _2511 = _19[(_2504 + 1)];
                              float _2516 = _2508 * 0.5f;
                              _2556 = dot(float3((_2506 * _2506), _2506, 1.0f), float3(mad((_19[(_2504 + 2)]), 0.5f, mad(_2511, -1.0f, _2516)), (_2511 - _2508), mad(_2511, 0.5f, _2516)));
                            } else {
                              do {
                                if (!(!(_2487 >= _2495))) {
                                  float _2525 = log2(cb0_008z);
                                  if (_2487 < (_2525 * 0.3010300099849701f)) {
                                    float _2533 = ((_2486 - _2494) * 0.9030900001525879f) / ((_2525 - _2494) * 0.3010300099849701f);
                                    int _2534 = int(_2533);
                                    float _2536 = _2533 - float((int)(_2534));
                                    float _2538 = _20[_2534];
                                    float _2541 = _20[(_2534 + 1)];
                                    float _2546 = _2538 * 0.5f;
                                    _2556 = dot(float3((_2536 * _2536), _2536, 1.0f), float3(mad((_20[(_2534 + 2)]), 0.5f, mad(_2541, -1.0f, _2546)), (_2541 - _2538), mad(_2541, 0.5f, _2546)));
                                    break;
                                  }
                                }
                                _2556 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2560 = cb0_008w - cb0_008y;
                          float _2561 = (exp2(_2384 * 3.321928024291992f) - cb0_008y) / _2560;
                          float _2563 = (exp2(_2470 * 3.321928024291992f) - cb0_008y) / _2560;
                          float _2565 = (exp2(_2556 * 3.321928024291992f) - cb0_008y) / _2560;
                          float _2568 = mad(0.15618768334388733f, _2565, mad(0.13400420546531677f, _2563, (_2561 * 0.6624541878700256f)));
                          float _2571 = mad(0.053689517080783844f, _2565, mad(0.6740817427635193f, _2563, (_2561 * 0.2722287178039551f)));
                          float _2574 = mad(1.0103391408920288f, _2565, mad(0.00406073359772563f, _2563, (_2561 * -0.005574649665504694f)));
                          float _2587 = min(max(mad(-0.23642469942569733f, _2574, mad(-0.32480329275131226f, _2571, (_2568 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2588 = min(max(mad(0.016756348311901093f, _2574, mad(1.6153316497802734f, _2571, (_2568 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2589 = min(max(mad(0.9883948564529419f, _2574, mad(-0.008284442126750946f, _2571, (_2568 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2592 = mad(0.15618768334388733f, _2589, mad(0.13400420546531677f, _2588, (_2587 * 0.6624541878700256f)));
                          float _2595 = mad(0.053689517080783844f, _2589, mad(0.6740817427635193f, _2588, (_2587 * 0.2722287178039551f)));
                          float _2598 = mad(1.0103391408920288f, _2589, mad(0.00406073359772563f, _2588, (_2587 * -0.005574649665504694f)));
                          float _2620 = min(max((min(max(mad(-0.23642469942569733f, _2598, mad(-0.32480329275131226f, _2595, (_2592 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2621 = min(max((min(max(mad(0.016756348311901093f, _2598, mad(1.6153316497802734f, _2595, (_2592 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2622 = min(max((min(max(mad(0.9883948564529419f, _2598, mad(-0.008284442126750946f, _2595, (_2592 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2635 = mad(_68, _2622, mad(_67, _2621, (_2620 * _66)));
                              _2636 = mad(_71, _2622, mad(_70, _2621, (_2620 * _69)));
                              _2637 = mad(_74, _2622, mad(_73, _2621, (_2620 * _72)));
                            } else {
                              _2635 = _2620;
                              _2636 = _2621;
                              _2637 = _2622;
                            }
                            float _2647 = exp2(log2(_2635 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2648 = exp2(log2(_2636 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2649 = exp2(log2(_2637 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2814 = exp2(log2((1.0f / ((_2647 * 18.6875f) + 1.0f)) * ((_2647 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2815 = exp2(log2((1.0f / ((_2648 * 18.6875f) + 1.0f)) * ((_2648 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2816 = exp2(log2((1.0f / ((_2649 * 18.6875f) + 1.0f)) * ((_2649 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2694 = mad((WorkingColorSpace_128[0].z), _1138, mad((WorkingColorSpace_128[0].y), _1137, ((WorkingColorSpace_128[0].x) * _1136)));
            float _2697 = mad((WorkingColorSpace_128[1].z), _1138, mad((WorkingColorSpace_128[1].y), _1137, ((WorkingColorSpace_128[1].x) * _1136)));
            float _2700 = mad((WorkingColorSpace_128[2].z), _1138, mad((WorkingColorSpace_128[2].y), _1137, ((WorkingColorSpace_128[2].x) * _1136)));
            float _2719 = exp2(log2(mad(_68, _2700, mad(_67, _2697, (_2694 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2720 = exp2(log2(mad(_71, _2700, mad(_70, _2697, (_2694 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2721 = exp2(log2(mad(_74, _2700, mad(_73, _2697, (_2694 * _72))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2814 = exp2(log2((1.0f / ((_2719 * 18.6875f) + 1.0f)) * ((_2719 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2815 = exp2(log2((1.0f / ((_2720 * 18.6875f) + 1.0f)) * ((_2720 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2816 = exp2(log2((1.0f / ((_2721 * 18.6875f) + 1.0f)) * ((_2721 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2768 = mad((WorkingColorSpace_128[0].z), _1126, mad((WorkingColorSpace_128[0].y), _1125, ((WorkingColorSpace_128[0].x) * _1124)));
                float _2771 = mad((WorkingColorSpace_128[1].z), _1126, mad((WorkingColorSpace_128[1].y), _1125, ((WorkingColorSpace_128[1].x) * _1124)));
                float _2774 = mad((WorkingColorSpace_128[2].z), _1126, mad((WorkingColorSpace_128[2].y), _1125, ((WorkingColorSpace_128[2].x) * _1124)));
                _2814 = mad(_68, _2774, mad(_67, _2771, (_2768 * _66)));
                _2815 = mad(_71, _2774, mad(_70, _2771, (_2768 * _69)));
                _2816 = mad(_74, _2774, mad(_73, _2771, (_2768 * _72)));
              } else {
                float _2787 = mad((WorkingColorSpace_128[0].z), _1152, mad((WorkingColorSpace_128[0].y), _1151, ((WorkingColorSpace_128[0].x) * _1150)));
                float _2790 = mad((WorkingColorSpace_128[1].z), _1152, mad((WorkingColorSpace_128[1].y), _1151, ((WorkingColorSpace_128[1].x) * _1150)));
                float _2793 = mad((WorkingColorSpace_128[2].z), _1152, mad((WorkingColorSpace_128[2].y), _1151, ((WorkingColorSpace_128[2].x) * _1150)));
                _2814 = exp2(log2(mad(_68, _2793, mad(_67, _2790, (_2787 * _66)))) * cb0_040z);
                _2815 = exp2(log2(mad(_71, _2793, mad(_70, _2790, (_2787 * _69)))) * cb0_040z);
                _2816 = exp2(log2(mad(_74, _2793, mad(_73, _2790, (_2787 * _72)))) * cb0_040z);
              }
            } else {
              _2814 = _1136;
              _2815 = _1137;
              _2816 = _1138;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2814 * 0.9523810148239136f), (_2815 * 0.9523810148239136f), (_2816 * 0.9523810148239136f), 0.0f);
}
