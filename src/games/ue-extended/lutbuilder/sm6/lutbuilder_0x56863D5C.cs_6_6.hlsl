// High on Life 2, UE 5.5

#include "../lutbuilderoutput.hlsli"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

cbuffer cb0 : register(b0) {
  float cb0_005x : packoffset(c005.x);
  float cb0_005y : packoffset(c005.y);
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
  float _15[6];
  float _16[6];
  float _17[6];
  float _18[6];
  float _19[6];
  float _20[6];
  float _21[6];
  float _22[6];
  float _34 = 0.5f / cb0_035x;
  float _39 = cb0_035x + -1.0f;
  float _40 = (cb0_035x * ((cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _34)) / _39;
  float _41 = (cb0_035x * ((cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _34)) / _39;
  float _43 = float((uint)SV_DispatchThreadID.z) / _39;
  float _63;
  float _64;
  float _65;
  float _66;
  float _67;
  float _68;
  float _69;
  float _70;
  float _71;
  float _129;
  float _130;
  float _131;
  float _654;
  float _687;
  float _701;
  float _765;
  float _944;
  float _955;
  float _966;
  float _1137;
  float _1138;
  float _1139;
  float _1150;
  float _1161;
  float _1334;
  float _1349;
  float _1364;
  float _1372;
  float _1373;
  float _1374;
  float _1441;
  float _1474;
  float _1488;
  float _1527;
  float _1649;
  float _1735;
  float _1809;
  float _1888;
  float _1889;
  float _1890;
  float _2020;
  float _2035;
  float _2050;
  float _2058;
  float _2059;
  float _2060;
  float _2127;
  float _2160;
  float _2174;
  float _2213;
  float _2335;
  float _2421;
  float _2507;
  float _2586;
  float _2587;
  float _2588;
  float _2765;
  float _2766;
  float _2767;
  if (!(cb0_041x == 1)) {
    if (!(cb0_041x == 2)) {
      if (!(cb0_041x == 3)) {
        bool _52 = (cb0_041x == 4);
        _63 = select(_52, 1.0f, 1.705051064491272f);
        _64 = select(_52, 0.0f, -0.6217921376228333f);
        _65 = select(_52, 0.0f, -0.0832589864730835f);
        _66 = select(_52, 0.0f, -0.13025647401809692f);
        _67 = select(_52, 1.0f, 1.140804648399353f);
        _68 = select(_52, 0.0f, -0.010548308491706848f);
        _69 = select(_52, 0.0f, -0.024003351107239723f);
        _70 = select(_52, 0.0f, -0.1289689838886261f);
        _71 = select(_52, 1.0f, 1.1529725790023804f);
      } else {
        _63 = 0.6954522132873535f;
        _64 = 0.14067870378494263f;
        _65 = 0.16386906802654266f;
        _66 = 0.044794563204050064f;
        _67 = 0.8596711158752441f;
        _68 = 0.0955343171954155f;
        _69 = -0.005525882821530104f;
        _70 = 0.004025210160762072f;
        _71 = 1.0015007257461548f;
      }
    } else {
      _63 = 1.0258246660232544f;
      _64 = -0.020053181797266006f;
      _65 = -0.005771636962890625f;
      _66 = -0.002234415616840124f;
      _67 = 1.0045864582061768f;
      _68 = -0.002352118492126465f;
      _69 = -0.005013350863009691f;
      _70 = -0.025290070101618767f;
      _71 = 1.0303035974502563f;
    }
  } else {
    _63 = 1.3792141675949097f;
    _64 = -0.30886411666870117f;
    _65 = -0.0703500509262085f;
    _66 = -0.06933490186929703f;
    _67 = 1.08229660987854f;
    _68 = -0.012961871922016144f;
    _69 = -0.0021590073592960835f;
    _70 = -0.0454593189060688f;
    _71 = 1.0476183891296387f;
  }
  [branch]
  if ((uint)cb0_040w > (uint)2) {
    float _82 = (pow(_40, 0.012683313339948654f));
    float _83 = (pow(_41, 0.012683313339948654f));
    float _84 = (pow(_43, 0.012683313339948654f));
    _129 = (exp2(log2(max(0.0f, (_82 + -0.8359375f)) / (18.8515625f - (_82 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _130 = (exp2(log2(max(0.0f, (_83 + -0.8359375f)) / (18.8515625f - (_83 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _131 = (exp2(log2(max(0.0f, (_84 + -0.8359375f)) / (18.8515625f - (_84 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _129 = ((exp2((_40 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _130 = ((exp2((_41 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
    _131 = ((exp2((_43 + -0.4340175986289978f) * 14.0f) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _146 = mad((WorkingColorSpace_128[0].z), _131, mad((WorkingColorSpace_128[0].y), _130, ((WorkingColorSpace_128[0].x) * _129)));
  float _149 = mad((WorkingColorSpace_128[1].z), _131, mad((WorkingColorSpace_128[1].y), _130, ((WorkingColorSpace_128[1].x) * _129)));
  float _152 = mad((WorkingColorSpace_128[2].z), _131, mad((WorkingColorSpace_128[2].y), _130, ((WorkingColorSpace_128[2].x) * _129)));
  float _153 = dot(float3(_146, _149, _152), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _157 = (_146 / _153) + -1.0f;
  float _158 = (_149 / _153) + -1.0f;
  float _159 = (_152 / _153) + -1.0f;

  // float _171 = (1.0f - exp2(((_153 * _153) * -4.0f) * cb0_036w)) * (1.0f - exp2(dot(float3(_157, _158, _159), float3(_157, _158, _159)) * -4.0f));
  float _171 = (1.0f - exp2(((_153 * _153) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_157, _158, _159), float3(_157, _158, _159)) * -4.0f));

  float _187 = ((mad(-0.06368321925401688f, _152, mad(-0.3292922377586365f, _149, (_146 * 1.3704125881195068f))) - _146) * _171) + _146;
  float _188 = ((mad(-0.010861365124583244f, _152, mad(1.0970927476882935f, _149, (_146 * -0.08343357592821121f))) - _149) * _171) + _149;
  float _189 = ((mad(1.2036951780319214f, _152, mad(-0.09862580895423889f, _149, (_146 * -0.02579331398010254f))) - _152) * _171) + _152;
  float _190 = dot(float3(_187, _188, _189), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _204 = cb0_019w + cb0_024w;
  float _218 = cb0_018w * cb0_023w;
  float _232 = cb0_017w * cb0_022w;
  float _246 = cb0_016w * cb0_021w;
  float _260 = cb0_015w * cb0_020w;
  float _264 = _187 - _190;
  float _265 = _188 - _190;
  float _266 = _189 - _190;
  float _323 = saturate(_190 / cb0_035w);
  float _327 = (_323 * _323) * (3.0f - (_323 * 2.0f));
  float _328 = 1.0f - _327;
  float _337 = cb0_019w + cb0_034w;
  float _346 = cb0_018w * cb0_033w;
  float _355 = cb0_017w * cb0_032w;
  float _364 = cb0_016w * cb0_031w;
  float _373 = cb0_015w * cb0_030w;
  float _436 = saturate((_190 - cb0_036x) / (cb0_036y - cb0_036x));
  float _440 = (_436 * _436) * (3.0f - (_436 * 2.0f));
  float _449 = cb0_019w + cb0_029w;
  float _458 = cb0_018w * cb0_028w;
  float _467 = cb0_017w * cb0_027w;
  float _476 = cb0_016w * cb0_026w;
  float _485 = cb0_015w * cb0_025w;
  float _543 = _327 - _440;
  float _554 = ((_440 * (((cb0_019x + cb0_034x) + _337) + (((cb0_018x * cb0_033x) * _346) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _364) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _373) * _264) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _355)))))) + (_328 * (((cb0_019x + cb0_024x) + _204) + (((cb0_018x * cb0_023x) * _218) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _246) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _260) * _264) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _232))))))) + ((((cb0_019x + cb0_029x) + _449) + (((cb0_018x * cb0_028x) * _458) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _476) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _485) * _264) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _467))))) * _543);
  float _556 = ((_440 * (((cb0_019y + cb0_034y) + _337) + (((cb0_018y * cb0_033y) * _346) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _364) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _373) * _265) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _355)))))) + (_328 * (((cb0_019y + cb0_024y) + _204) + (((cb0_018y * cb0_023y) * _218) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _246) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _260) * _265) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _232))))))) + ((((cb0_019y + cb0_029y) + _449) + (((cb0_018y * cb0_028y) * _458) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _476) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _485) * _265) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _467))))) * _543);
  float _558 = ((_440 * (((cb0_019z + cb0_034z) + _337) + (((cb0_018z * cb0_033z) * _346) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _364) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _373) * _266) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _355)))))) + (_328 * (((cb0_019z + cb0_024z) + _204) + (((cb0_018z * cb0_023z) * _218) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _246) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _260) * _266) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _232))))))) + ((((cb0_019z + cb0_029z) + _449) + (((cb0_018z * cb0_028z) * _458) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _476) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _485) * _266) + _190)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _467))))) * _543);

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
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xy is used

  float4 output = ProcessLutbuilder(float3(_554, _556, _558), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _594 = ((mad(0.061360642313957214f, _558, mad(-4.540197551250458e-09f, _556, (_554 * 0.9386394023895264f))) - _554) * cb0_036z) + _554;
  float _595 = ((mad(0.169205904006958f, _558, mad(0.8307942152023315f, _556, (_554 * 6.775371730327606e-08f))) - _556) * cb0_036z) + _556;
  float _596 = (mad(-2.3283064365386963e-10f, _556, (_554 * -9.313225746154785e-10f)) * cb0_036z) + _558;
  float _599 = mad(0.16386905312538147f, _596, mad(0.14067868888378143f, _595, (_594 * 0.6954522132873535f)));
  float _602 = mad(0.0955343246459961f, _596, mad(0.8596711158752441f, _595, (_594 * 0.044794581830501556f)));
  float _605 = mad(1.0015007257461548f, _596, mad(0.004025210160762072f, _595, (_594 * -0.005525882821530104f)));
  float _609 = max(max(_599, _602), _605);
  float _614 = (max(_609, 1.000000013351432e-10f) - max(min(min(_599, _602), _605), 1.000000013351432e-10f)) / max(_609, 0.009999999776482582f);
  float _627 = ((_602 + _599) + _605) + (sqrt((((_605 - _602) * _605) + ((_602 - _599) * _602)) + ((_599 - _605) * _599)) * 1.75f);
  float _628 = _627 * 0.3333333432674408f;
  float _629 = _614 + -0.4000000059604645f;
  float _630 = _629 * 5.0f;
  float _634 = max((1.0f - abs(_629 * 2.5f)), 0.0f);
  float _645 = ((float((int)(((int)(uint)((bool)(_630 > 0.0f))) - ((int)(uint)((bool)(_630 < 0.0f))))) * (1.0f - (_634 * _634))) + 1.0f) * 0.02500000037252903f;
  if (!(_628 <= 0.0533333346247673f)) {
    if (!(_628 >= 0.1599999964237213f)) {
      _654 = (((0.23999999463558197f / _627) + -0.5f) * _645);
    } else {
      _654 = 0.0f;
    }
  } else {
    _654 = _645;
  }
  float _655 = _654 + 1.0f;
  float _656 = _655 * _599;
  float _657 = _655 * _602;
  float _658 = _655 * _605;
  if (!((bool)(_656 == _657) && (bool)(_657 == _658))) {
    float _665 = ((_656 * 2.0f) - _657) - _658;
    float _668 = ((_602 - _605) * 1.7320507764816284f) * _655;
    float _670 = atan(_668 / _665);
    bool _673 = (_665 < 0.0f);
    bool _674 = (_665 == 0.0f);
    bool _675 = (_668 >= 0.0f);
    bool _676 = (_668 < 0.0f);
    _687 = select((_675 && _674), 90.0f, select((_676 && _674), -90.0f, (select((_676 && _673), (_670 + -3.1415927410125732f), select((_675 && _673), (_670 + 3.1415927410125732f), _670)) * 57.2957763671875f)));
  } else {
    _687 = 0.0f;
  }
  float _692 = min(max(select((_687 < 0.0f), (_687 + 360.0f), _687), 0.0f), 360.0f);
  if (_692 < -180.0f) {
    _701 = (_692 + 360.0f);
  } else {
    if (_692 > 180.0f) {
      _701 = (_692 + -360.0f);
    } else {
      _701 = _692;
    }
  }
  float _705 = saturate(1.0f - abs(_701 * 0.014814814552664757f));
  float _709 = (_705 * _705) * (3.0f - (_705 * 2.0f));
  float _715 = ((_709 * _709) * ((_614 * 0.18000000715255737f) * (0.029999999329447746f - _656))) + _656;
  float _725 = max(0.0f, mad(-0.21492856740951538f, _658, mad(-0.2365107536315918f, _657, (_715 * 1.4514392614364624f))));
  float _726 = max(0.0f, mad(-0.09967592358589172f, _658, mad(1.17622971534729f, _657, (_715 * -0.07655377686023712f))));
  float _727 = max(0.0f, mad(0.9977163076400757f, _658, mad(-0.006032449658960104f, _657, (_715 * 0.008316148072481155f))));
  float _728 = dot(float3(_725, _726, _727), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _743 = (cb0_038x + 1.0f) - cb0_037z;
  float _745 = cb0_038y + 1.0f;
  float _747 = _745 - cb0_037w;
  if (cb0_037z > 0.800000011920929f) {
    _765 = (((0.8199999928474426f - cb0_037z) / cb0_037y) + -0.7447274923324585f);
  } else {
    float _756 = (cb0_038x + 0.18000000715255737f) / _743;
    _765 = (-0.7447274923324585f - ((log2(_756 / (2.0f - _756)) * 0.3465735912322998f) * (_743 / cb0_037y)));
  }
  float _768 = ((1.0f - cb0_037z) / cb0_037y) - _765;
  float _770 = (cb0_037w / cb0_037y) - _768;
  float _774 = log2(lerp(_728, _725, 0.9599999785423279f)) * 0.3010300099849701f;
  float _775 = log2(lerp(_728, _726, 0.9599999785423279f)) * 0.3010300099849701f;
  float _776 = log2(lerp(_728, _727, 0.9599999785423279f)) * 0.3010300099849701f;
  float _780 = cb0_037y * (_774 + _768);
  float _781 = cb0_037y * (_775 + _768);
  float _782 = cb0_037y * (_776 + _768);
  float _783 = _743 * 2.0f;
  float _785 = (cb0_037y * -2.0f) / _743;
  float _786 = _774 - _765;
  float _787 = _775 - _765;
  float _788 = _776 - _765;
  float _807 = _747 * 2.0f;
  float _809 = (cb0_037y * 2.0f) / _747;
  float _834 = select((_774 < _765), ((_783 / (exp2((_786 * 1.4426950216293335f) * _785) + 1.0f)) - cb0_038x), _780);
  float _835 = select((_775 < _765), ((_783 / (exp2((_787 * 1.4426950216293335f) * _785) + 1.0f)) - cb0_038x), _781);
  float _836 = select((_776 < _765), ((_783 / (exp2((_788 * 1.4426950216293335f) * _785) + 1.0f)) - cb0_038x), _782);
  float _843 = _770 - _765;
  float _847 = saturate(_786 / _843);
  float _848 = saturate(_787 / _843);
  float _849 = saturate(_788 / _843);
  bool _850 = (_770 < _765);
  float _854 = select(_850, (1.0f - _847), _847);
  float _855 = select(_850, (1.0f - _848), _848);
  float _856 = select(_850, (1.0f - _849), _849);
  float _875 = (((_854 * _854) * (select((_774 > _770), (_745 - (_807 / (exp2(((_774 - _770) * 1.4426950216293335f) * _809) + 1.0f))), _780) - _834)) * (3.0f - (_854 * 2.0f))) + _834;
  float _876 = (((_855 * _855) * (select((_775 > _770), (_745 - (_807 / (exp2(((_775 - _770) * 1.4426950216293335f) * _809) + 1.0f))), _781) - _835)) * (3.0f - (_855 * 2.0f))) + _835;
  float _877 = (((_856 * _856) * (select((_776 > _770), (_745 - (_807 / (exp2(((_776 - _770) * 1.4426950216293335f) * _809) + 1.0f))), _782) - _836)) * (3.0f - (_856 * 2.0f))) + _836;
  float _878 = dot(float3(_875, _876, _877), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _898 = (cb0_037x * (max(0.0f, (lerp(_878, _875, 0.9300000071525574f))) - _594)) + _594;
  float _899 = (cb0_037x * (max(0.0f, (lerp(_878, _876, 0.9300000071525574f))) - _595)) + _595;
  float _900 = (cb0_037x * (max(0.0f, (lerp(_878, _877, 0.9300000071525574f))) - _596)) + _596;
  float _916 = ((mad(-0.06537103652954102f, _900, mad(1.451815478503704e-06f, _899, (_898 * 1.065374732017517f))) - _898) * cb0_036z) + _898;
  float _917 = ((mad(-0.20366770029067993f, _900, mad(1.2036634683609009f, _899, (_898 * -2.57161445915699e-07f))) - _899) * cb0_036z) + _899;
  float _918 = ((mad(0.9999996423721313f, _900, mad(2.0954757928848267e-08f, _899, (_898 * 1.862645149230957e-08f))) - _900) * cb0_036z) + _900;
  float _931 = saturate(max(0.0f, mad((WorkingColorSpace_192[0].z), _918, mad((WorkingColorSpace_192[0].y), _917, ((WorkingColorSpace_192[0].x) * _916)))));
  float _932 = saturate(max(0.0f, mad((WorkingColorSpace_192[1].z), _918, mad((WorkingColorSpace_192[1].y), _917, ((WorkingColorSpace_192[1].x) * _916)))));
  float _933 = saturate(max(0.0f, mad((WorkingColorSpace_192[2].z), _918, mad((WorkingColorSpace_192[2].y), _917, ((WorkingColorSpace_192[2].x) * _916)))));
  if (_931 < 0.0031306699384003878f) {
    _944 = (_931 * 12.920000076293945f);
  } else {
    _944 = (((pow(_931, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_932 < 0.0031306699384003878f) {
    _955 = (_932 * 12.920000076293945f);
  } else {
    _955 = (((pow(_932, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_933 < 0.0031306699384003878f) {
    _966 = (_933 * 12.920000076293945f);
  } else {
    _966 = (((pow(_933, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _970 = (_955 * 0.9375f) + 0.03125f;
  float _977 = _966 * 15.0f;
  float _978 = floor(_977);
  float _979 = _977 - _978;
  float _981 = (((_944 * 0.9375f) + 0.03125f) + _978) * 0.0625f;
  float4 _984 = t0.SampleLevel(s0, float2(_981, _970), 0.0f);
  float4 _989 = t0.SampleLevel(s0, float2((_981 + 0.0625f), _970), 0.0f);
  float _1008 = max(6.103519990574569e-05f, (((lerp(_984.x, _989.x, _979)) * cb0_005y) + (cb0_005x * _944)));
  float _1009 = max(6.103519990574569e-05f, (((lerp(_984.y, _989.y, _979)) * cb0_005y) + (cb0_005x * _955)));
  float _1010 = max(6.103519990574569e-05f, (((lerp(_984.z, _989.z, _979)) * cb0_005y) + (cb0_005x * _966)));
  float _1032 = select((_1008 > 0.040449999272823334f), exp2(log2((_1008 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1008 * 0.07739938050508499f));
  float _1033 = select((_1009 > 0.040449999272823334f), exp2(log2((_1009 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1009 * 0.07739938050508499f));
  float _1034 = select((_1010 > 0.040449999272823334f), exp2(log2((_1010 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1010 * 0.07739938050508499f));
  float _1060 = cb0_014x * (((cb0_039y + (cb0_039x * _1032)) * _1032) + cb0_039z);
  float _1061 = cb0_014y * (((cb0_039y + (cb0_039x * _1033)) * _1033) + cb0_039z);
  float _1062 = cb0_014z * (((cb0_039y + (cb0_039x * _1034)) * _1034) + cb0_039z);
  float _1069 = ((cb0_013x - _1060) * cb0_013w) + _1060;
  float _1070 = ((cb0_013y - _1061) * cb0_013w) + _1061;
  float _1071 = ((cb0_013z - _1062) * cb0_013w) + _1062;
  float _1072 = cb0_014x * mad((WorkingColorSpace_192[0].z), _558, mad((WorkingColorSpace_192[0].y), _556, (_554 * (WorkingColorSpace_192[0].x))));
  float _1073 = cb0_014y * mad((WorkingColorSpace_192[1].z), _558, mad((WorkingColorSpace_192[1].y), _556, ((WorkingColorSpace_192[1].x) * _554)));
  float _1074 = cb0_014z * mad((WorkingColorSpace_192[2].z), _558, mad((WorkingColorSpace_192[2].y), _556, ((WorkingColorSpace_192[2].x) * _554)));
  float _1081 = ((cb0_013x - _1072) * cb0_013w) + _1072;
  float _1082 = ((cb0_013y - _1073) * cb0_013w) + _1073;
  float _1083 = ((cb0_013z - _1074) * cb0_013w) + _1074;
  float _1095 = exp2(log2(max(0.0f, _1069)) * cb0_040y);
  float _1096 = exp2(log2(max(0.0f, _1070)) * cb0_040y);
  float _1097 = exp2(log2(max(0.0f, _1071)) * cb0_040y);
  [branch]
  if (cb0_040w == 0) {
    do {
      if (WorkingColorSpace_320 == 0) {
        float _1120 = mad((WorkingColorSpace_128[0].z), _1097, mad((WorkingColorSpace_128[0].y), _1096, ((WorkingColorSpace_128[0].x) * _1095)));
        float _1123 = mad((WorkingColorSpace_128[1].z), _1097, mad((WorkingColorSpace_128[1].y), _1096, ((WorkingColorSpace_128[1].x) * _1095)));
        float _1126 = mad((WorkingColorSpace_128[2].z), _1097, mad((WorkingColorSpace_128[2].y), _1096, ((WorkingColorSpace_128[2].x) * _1095)));
        _1137 = mad(_65, _1126, mad(_64, _1123, (_1120 * _63)));
        _1138 = mad(_68, _1126, mad(_67, _1123, (_1120 * _66)));
        _1139 = mad(_71, _1126, mad(_70, _1123, (_1120 * _69)));
      } else {
        _1137 = _1095;
        _1138 = _1096;
        _1139 = _1097;
      }
      do {
        if (_1137 < 0.0031306699384003878f) {
          _1150 = (_1137 * 12.920000076293945f);
        } else {
          _1150 = (((pow(_1137, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1138 < 0.0031306699384003878f) {
            _1161 = (_1138 * 12.920000076293945f);
          } else {
            _1161 = (((pow(_1138, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1139 < 0.0031306699384003878f) {
            _2765 = _1150;
            _2766 = _1161;
            _2767 = (_1139 * 12.920000076293945f);
          } else {
            _2765 = _1150;
            _2766 = _1161;
            _2767 = (((pow(_1139, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (cb0_040w == 1) {
      float _1188 = mad((WorkingColorSpace_128[0].z), _1097, mad((WorkingColorSpace_128[0].y), _1096, ((WorkingColorSpace_128[0].x) * _1095)));
      float _1191 = mad((WorkingColorSpace_128[1].z), _1097, mad((WorkingColorSpace_128[1].y), _1096, ((WorkingColorSpace_128[1].x) * _1095)));
      float _1194 = mad((WorkingColorSpace_128[2].z), _1097, mad((WorkingColorSpace_128[2].y), _1096, ((WorkingColorSpace_128[2].x) * _1095)));
      float _1204 = max(6.103519990574569e-05f, mad(_65, _1194, mad(_64, _1191, (_1188 * _63))));
      float _1205 = max(6.103519990574569e-05f, mad(_68, _1194, mad(_67, _1191, (_1188 * _66))));
      float _1206 = max(6.103519990574569e-05f, mad(_71, _1194, mad(_70, _1191, (_1188 * _69))));
      _2765 = min((_1204 * 4.5f), ((exp2(log2(max(_1204, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2766 = min((_1205 * 4.5f), ((exp2(log2(max(_1205, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2767 = min((_1206 * 4.5f), ((exp2(log2(max(_1206, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(cb0_040w == 3) || (bool)(cb0_040w == 5)) {
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
        float _1282 = cb0_012z * _1081;
        float _1283 = cb0_012z * _1082;
        float _1284 = cb0_012z * _1083;
        float _1287 = mad((WorkingColorSpace_256[0].z), _1284, mad((WorkingColorSpace_256[0].y), _1283, ((WorkingColorSpace_256[0].x) * _1282)));
        float _1290 = mad((WorkingColorSpace_256[1].z), _1284, mad((WorkingColorSpace_256[1].y), _1283, ((WorkingColorSpace_256[1].x) * _1282)));
        float _1293 = mad((WorkingColorSpace_256[2].z), _1284, mad((WorkingColorSpace_256[2].y), _1283, ((WorkingColorSpace_256[2].x) * _1282)));
        float _1296 = mad(-0.21492856740951538f, _1293, mad(-0.2365107536315918f, _1290, (_1287 * 1.4514392614364624f)));
        float _1299 = mad(-0.09967592358589172f, _1293, mad(1.17622971534729f, _1290, (_1287 * -0.07655377686023712f)));
        float _1302 = mad(0.9977163076400757f, _1293, mad(-0.006032449658960104f, _1290, (_1287 * 0.008316148072481155f)));
        float _1304 = max(_1296, max(_1299, _1302));
        do {
          if (!(_1304 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1287 < 0.0f) || (bool)(_1290 < 0.0f))) || (bool)(_1293 < 0.0f))) {
              float _1314 = abs(_1304);
              float _1315 = (_1304 - _1296) / _1314;
              float _1317 = (_1304 - _1299) / _1314;
              float _1319 = (_1304 - _1302) / _1314;
              do {
                if (!(_1315 < 0.8149999976158142f)) {
                  float _1322 = _1315 + -0.8149999976158142f;
                  _1334 = ((_1322 / exp2(log2(exp2(log2(_1322 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1334 = _1315;
                }
                do {
                  if (!(_1317 < 0.8029999732971191f)) {
                    float _1337 = _1317 + -0.8029999732971191f;
                    _1349 = ((_1337 / exp2(log2(exp2(log2(_1337 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1349 = _1317;
                  }
                  do {
                    if (!(_1319 < 0.8799999952316284f)) {
                      float _1352 = _1319 + -0.8799999952316284f;
                      _1364 = ((_1352 / exp2(log2(exp2(log2(_1352 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1364 = _1319;
                    }
                    _1372 = (_1304 - (_1314 * _1334));
                    _1373 = (_1304 - (_1314 * _1349));
                    _1374 = (_1304 - (_1314 * _1364));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1372 = _1296;
              _1373 = _1299;
              _1374 = _1302;
            }
          } else {
            _1372 = _1296;
            _1373 = _1299;
            _1374 = _1302;
          }
          float _1390 = ((mad(0.16386906802654266f, _1374, mad(0.14067870378494263f, _1373, (_1372 * 0.6954522132873535f))) - _1287) * cb0_012w) + _1287;
          float _1391 = ((mad(0.0955343171954155f, _1374, mad(0.8596711158752441f, _1373, (_1372 * 0.044794563204050064f))) - _1290) * cb0_012w) + _1290;
          float _1392 = ((mad(1.0015007257461548f, _1374, mad(0.004025210160762072f, _1373, (_1372 * -0.005525882821530104f))) - _1293) * cb0_012w) + _1293;
          float _1396 = max(max(_1390, _1391), _1392);
          float _1401 = (max(_1396, 1.000000013351432e-10f) - max(min(min(_1390, _1391), _1392), 1.000000013351432e-10f)) / max(_1396, 0.009999999776482582f);
          float _1414 = ((_1391 + _1390) + _1392) + (sqrt((((_1392 - _1391) * _1392) + ((_1391 - _1390) * _1391)) + ((_1390 - _1392) * _1390)) * 1.75f);
          float _1415 = _1414 * 0.3333333432674408f;
          float _1416 = _1401 + -0.4000000059604645f;
          float _1417 = _1416 * 5.0f;
          float _1421 = max((1.0f - abs(_1416 * 2.5f)), 0.0f);
          float _1432 = ((float((int)(((int)(uint)((bool)(_1417 > 0.0f))) - ((int)(uint)((bool)(_1417 < 0.0f))))) * (1.0f - (_1421 * _1421))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1415 <= 0.0533333346247673f)) {
              if (!(_1415 >= 0.1599999964237213f)) {
                _1441 = (((0.23999999463558197f / _1414) + -0.5f) * _1432);
              } else {
                _1441 = 0.0f;
              }
            } else {
              _1441 = _1432;
            }
            float _1442 = _1441 + 1.0f;
            float _1443 = _1442 * _1390;
            float _1444 = _1442 * _1391;
            float _1445 = _1442 * _1392;
            do {
              if (!((bool)(_1443 == _1444) && (bool)(_1444 == _1445))) {
                float _1452 = ((_1443 * 2.0f) - _1444) - _1445;
                float _1455 = ((_1391 - _1392) * 1.7320507764816284f) * _1442;
                float _1457 = atan(_1455 / _1452);
                bool _1460 = (_1452 < 0.0f);
                bool _1461 = (_1452 == 0.0f);
                bool _1462 = (_1455 >= 0.0f);
                bool _1463 = (_1455 < 0.0f);
                _1474 = select((_1462 && _1461), 90.0f, select((_1463 && _1461), -90.0f, (select((_1463 && _1460), (_1457 + -3.1415927410125732f), select((_1462 && _1460), (_1457 + 3.1415927410125732f), _1457)) * 57.2957763671875f)));
              } else {
                _1474 = 0.0f;
              }
              float _1479 = min(max(select((_1474 < 0.0f), (_1474 + 360.0f), _1474), 0.0f), 360.0f);
              do {
                if (_1479 < -180.0f) {
                  _1488 = (_1479 + 360.0f);
                } else {
                  if (_1479 > 180.0f) {
                    _1488 = (_1479 + -360.0f);
                  } else {
                    _1488 = _1479;
                  }
                }
                do {
                  if ((bool)(_1488 > -67.5f) && (bool)(_1488 < 67.5f)) {
                    float _1494 = (_1488 + 67.5f) * 0.029629629105329514f;
                    int _1495 = int(_1494);
                    float _1497 = _1494 - float((int)(_1495));
                    float _1498 = _1497 * _1497;
                    float _1499 = _1498 * _1497;
                    if (_1495 == 3) {
                      _1527 = (((0.1666666716337204f - (_1497 * 0.5f)) + (_1498 * 0.5f)) - (_1499 * 0.1666666716337204f));
                    } else {
                      if (_1495 == 2) {
                        _1527 = ((0.6666666865348816f - _1498) + (_1499 * 0.5f));
                      } else {
                        if (_1495 == 1) {
                          _1527 = (((_1499 * -0.5f) + 0.1666666716337204f) + ((_1498 + _1497) * 0.5f));
                        } else {
                          _1527 = select((_1495 == 0), (_1499 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1527 = 0.0f;
                  }
                  float _1536 = min(max(((((_1401 * 0.27000001072883606f) * (0.029999999329447746f - _1443)) * _1527) + _1443), 0.0f), 65535.0f);
                  float _1537 = min(max(_1444, 0.0f), 65535.0f);
                  float _1538 = min(max(_1445, 0.0f), 65535.0f);
                  float _1551 = min(max(mad(-0.21492856740951538f, _1538, mad(-0.2365107536315918f, _1537, (_1536 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1552 = min(max(mad(-0.09967592358589172f, _1538, mad(1.17622971534729f, _1537, (_1536 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1553 = min(max(mad(0.9977163076400757f, _1538, mad(-0.006032449658960104f, _1537, (_1536 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1554 = dot(float3(_1551, _1552, _1553), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1577 = log2(max((lerp(_1554, _1551, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1578 = _1577 * 0.3010300099849701f;
                  float _1579 = log2(cb0_008x);
                  float _1580 = _1579 * 0.3010300099849701f;
                  do {
                    if (!(!(_1578 <= _1580))) {
                      _1649 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1587 = log2(cb0_009x);
                      float _1588 = _1587 * 0.3010300099849701f;
                      if ((bool)(_1578 > _1580) && (bool)(_1578 < _1588)) {
                        float _1596 = ((_1577 - _1579) * 0.9030900001525879f) / ((_1587 - _1579) * 0.3010300099849701f);
                        int _1597 = int(_1596);
                        float _1599 = _1596 - float((int)(_1597));
                        float _1601 = _19[_1597];
                        float _1604 = _19[(_1597 + 1)];
                        float _1609 = _1601 * 0.5f;
                        _1649 = dot(float3((_1599 * _1599), _1599, 1.0f), float3(mad((_19[(_1597 + 2)]), 0.5f, mad(_1604, -1.0f, _1609)), (_1604 - _1601), mad(_1604, 0.5f, _1609)));
                      } else {
                        do {
                          if (!(!(_1578 >= _1588))) {
                            float _1618 = log2(cb0_008z);
                            if (_1578 < (_1618 * 0.3010300099849701f)) {
                              float _1626 = ((_1577 - _1587) * 0.9030900001525879f) / ((_1618 - _1587) * 0.3010300099849701f);
                              int _1627 = int(_1626);
                              float _1629 = _1626 - float((int)(_1627));
                              float _1631 = _20[_1627];
                              float _1634 = _20[(_1627 + 1)];
                              float _1639 = _1631 * 0.5f;
                              _1649 = dot(float3((_1629 * _1629), _1629, 1.0f), float3(mad((_20[(_1627 + 2)]), 0.5f, mad(_1634, -1.0f, _1639)), (_1634 - _1631), mad(_1634, 0.5f, _1639)));
                              break;
                            }
                          }
                          _1649 = (log2(cb0_008w) * 0.3010300099849701f);
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
                    float _1665 = log2(max((lerp(_1554, _1552, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1666 = _1665 * 0.3010300099849701f;
                    do {
                      if (!(!(_1666 <= _1580))) {
                        _1735 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1673 = log2(cb0_009x);
                        float _1674 = _1673 * 0.3010300099849701f;
                        if ((bool)(_1666 > _1580) && (bool)(_1666 < _1674)) {
                          float _1682 = ((_1665 - _1579) * 0.9030900001525879f) / ((_1673 - _1579) * 0.3010300099849701f);
                          int _1683 = int(_1682);
                          float _1685 = _1682 - float((int)(_1683));
                          float _1687 = _21[_1683];
                          float _1690 = _21[(_1683 + 1)];
                          float _1695 = _1687 * 0.5f;
                          _1735 = dot(float3((_1685 * _1685), _1685, 1.0f), float3(mad((_21[(_1683 + 2)]), 0.5f, mad(_1690, -1.0f, _1695)), (_1690 - _1687), mad(_1690, 0.5f, _1695)));
                        } else {
                          do {
                            if (!(!(_1666 >= _1674))) {
                              float _1704 = log2(cb0_008z);
                              if (_1666 < (_1704 * 0.3010300099849701f)) {
                                float _1712 = ((_1665 - _1673) * 0.9030900001525879f) / ((_1704 - _1673) * 0.3010300099849701f);
                                int _1713 = int(_1712);
                                float _1715 = _1712 - float((int)(_1713));
                                float _1717 = _22[_1713];
                                float _1720 = _22[(_1713 + 1)];
                                float _1725 = _1717 * 0.5f;
                                _1735 = dot(float3((_1715 * _1715), _1715, 1.0f), float3(mad((_22[(_1713 + 2)]), 0.5f, mad(_1720, -1.0f, _1725)), (_1720 - _1717), mad(_1720, 0.5f, _1725)));
                                break;
                              }
                            }
                            _1735 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1739 = log2(max((lerp(_1554, _1553, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _1740 = _1739 * 0.3010300099849701f;
                      do {
                        if (!(!(_1740 <= _1580))) {
                          _1809 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _1747 = log2(cb0_009x);
                          float _1748 = _1747 * 0.3010300099849701f;
                          if ((bool)(_1740 > _1580) && (bool)(_1740 < _1748)) {
                            float _1756 = ((_1739 - _1579) * 0.9030900001525879f) / ((_1747 - _1579) * 0.3010300099849701f);
                            int _1757 = int(_1756);
                            float _1759 = _1756 - float((int)(_1757));
                            float _1761 = _11[_1757];
                            float _1764 = _11[(_1757 + 1)];
                            float _1769 = _1761 * 0.5f;
                            _1809 = dot(float3((_1759 * _1759), _1759, 1.0f), float3(mad((_11[(_1757 + 2)]), 0.5f, mad(_1764, -1.0f, _1769)), (_1764 - _1761), mad(_1764, 0.5f, _1769)));
                          } else {
                            do {
                              if (!(!(_1740 >= _1748))) {
                                float _1778 = log2(cb0_008z);
                                if (_1740 < (_1778 * 0.3010300099849701f)) {
                                  float _1786 = ((_1739 - _1747) * 0.9030900001525879f) / ((_1778 - _1747) * 0.3010300099849701f);
                                  int _1787 = int(_1786);
                                  float _1789 = _1786 - float((int)(_1787));
                                  float _1791 = _12[_1787];
                                  float _1794 = _12[(_1787 + 1)];
                                  float _1799 = _1791 * 0.5f;
                                  _1809 = dot(float3((_1789 * _1789), _1789, 1.0f), float3(mad((_12[(_1787 + 2)]), 0.5f, mad(_1794, -1.0f, _1799)), (_1794 - _1791), mad(_1794, 0.5f, _1799)));
                                  break;
                                }
                              }
                              _1809 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _1813 = cb0_008w - cb0_008y;
                        float _1814 = (exp2(_1649 * 3.321928024291992f) - cb0_008y) / _1813;
                        float _1816 = (exp2(_1735 * 3.321928024291992f) - cb0_008y) / _1813;
                        float _1818 = (exp2(_1809 * 3.321928024291992f) - cb0_008y) / _1813;
                        float _1821 = mad(0.15618768334388733f, _1818, mad(0.13400420546531677f, _1816, (_1814 * 0.6624541878700256f)));
                        float _1824 = mad(0.053689517080783844f, _1818, mad(0.6740817427635193f, _1816, (_1814 * 0.2722287178039551f)));
                        float _1827 = mad(1.0103391408920288f, _1818, mad(0.00406073359772563f, _1816, (_1814 * -0.005574649665504694f)));
                        float _1840 = min(max(mad(-0.23642469942569733f, _1827, mad(-0.32480329275131226f, _1824, (_1821 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _1841 = min(max(mad(0.016756348311901093f, _1827, mad(1.6153316497802734f, _1824, (_1821 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _1842 = min(max(mad(0.9883948564529419f, _1827, mad(-0.008284442126750946f, _1824, (_1821 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _1845 = mad(0.15618768334388733f, _1842, mad(0.13400420546531677f, _1841, (_1840 * 0.6624541878700256f)));
                        float _1848 = mad(0.053689517080783844f, _1842, mad(0.6740817427635193f, _1841, (_1840 * 0.2722287178039551f)));
                        float _1851 = mad(1.0103391408920288f, _1842, mad(0.00406073359772563f, _1841, (_1840 * -0.005574649665504694f)));
                        float _1873 = min(max((min(max(mad(-0.23642469942569733f, _1851, mad(-0.32480329275131226f, _1848, (_1845 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1874 = min(max((min(max(mad(0.016756348311901093f, _1851, mad(1.6153316497802734f, _1848, (_1845 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _1875 = min(max((min(max(mad(0.9883948564529419f, _1851, mad(-0.008284442126750946f, _1848, (_1845 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(cb0_040w == 5)) {
                            _1888 = mad(_65, _1875, mad(_64, _1874, (_1873 * _63)));
                            _1889 = mad(_68, _1875, mad(_67, _1874, (_1873 * _66)));
                            _1890 = mad(_71, _1875, mad(_70, _1874, (_1873 * _69)));
                          } else {
                            _1888 = _1873;
                            _1889 = _1874;
                            _1890 = _1875;
                          }
                          float _1900 = exp2(log2(_1888 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1901 = exp2(log2(_1889 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _1902 = exp2(log2(_1890 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2765 = exp2(log2((1.0f / ((_1900 * 18.6875f) + 1.0f)) * ((_1900 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2766 = exp2(log2((1.0f / ((_1901 * 18.6875f) + 1.0f)) * ((_1901 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2767 = exp2(log2((1.0f / ((_1902 * 18.6875f) + 1.0f)) * ((_1902 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1968 = cb0_012z * _1081;
          float _1969 = cb0_012z * _1082;
          float _1970 = cb0_012z * _1083;
          float _1973 = mad((WorkingColorSpace_256[0].z), _1970, mad((WorkingColorSpace_256[0].y), _1969, ((WorkingColorSpace_256[0].x) * _1968)));
          float _1976 = mad((WorkingColorSpace_256[1].z), _1970, mad((WorkingColorSpace_256[1].y), _1969, ((WorkingColorSpace_256[1].x) * _1968)));
          float _1979 = mad((WorkingColorSpace_256[2].z), _1970, mad((WorkingColorSpace_256[2].y), _1969, ((WorkingColorSpace_256[2].x) * _1968)));
          float _1982 = mad(-0.21492856740951538f, _1979, mad(-0.2365107536315918f, _1976, (_1973 * 1.4514392614364624f)));
          float _1985 = mad(-0.09967592358589172f, _1979, mad(1.17622971534729f, _1976, (_1973 * -0.07655377686023712f)));
          float _1988 = mad(0.9977163076400757f, _1979, mad(-0.006032449658960104f, _1976, (_1973 * 0.008316148072481155f)));
          float _1990 = max(_1982, max(_1985, _1988));
          do {
            if (!(_1990 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_1973 < 0.0f) || (bool)(_1976 < 0.0f))) || (bool)(_1979 < 0.0f))) {
                float _2000 = abs(_1990);
                float _2001 = (_1990 - _1982) / _2000;
                float _2003 = (_1990 - _1985) / _2000;
                float _2005 = (_1990 - _1988) / _2000;
                do {
                  if (!(_2001 < 0.8149999976158142f)) {
                    float _2008 = _2001 + -0.8149999976158142f;
                    _2020 = ((_2008 / exp2(log2(exp2(log2(_2008 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2020 = _2001;
                  }
                  do {
                    if (!(_2003 < 0.8029999732971191f)) {
                      float _2023 = _2003 + -0.8029999732971191f;
                      _2035 = ((_2023 / exp2(log2(exp2(log2(_2023 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2035 = _2003;
                    }
                    do {
                      if (!(_2005 < 0.8799999952316284f)) {
                        float _2038 = _2005 + -0.8799999952316284f;
                        _2050 = ((_2038 / exp2(log2(exp2(log2(_2038 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2050 = _2005;
                      }
                      _2058 = (_1990 - (_2000 * _2020));
                      _2059 = (_1990 - (_2000 * _2035));
                      _2060 = (_1990 - (_2000 * _2050));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2058 = _1982;
                _2059 = _1985;
                _2060 = _1988;
              }
            } else {
              _2058 = _1982;
              _2059 = _1985;
              _2060 = _1988;
            }
            float _2076 = ((mad(0.16386906802654266f, _2060, mad(0.14067870378494263f, _2059, (_2058 * 0.6954522132873535f))) - _1973) * cb0_012w) + _1973;
            float _2077 = ((mad(0.0955343171954155f, _2060, mad(0.8596711158752441f, _2059, (_2058 * 0.044794563204050064f))) - _1976) * cb0_012w) + _1976;
            float _2078 = ((mad(1.0015007257461548f, _2060, mad(0.004025210160762072f, _2059, (_2058 * -0.005525882821530104f))) - _1979) * cb0_012w) + _1979;
            float _2082 = max(max(_2076, _2077), _2078);
            float _2087 = (max(_2082, 1.000000013351432e-10f) - max(min(min(_2076, _2077), _2078), 1.000000013351432e-10f)) / max(_2082, 0.009999999776482582f);
            float _2100 = ((_2077 + _2076) + _2078) + (sqrt((((_2078 - _2077) * _2078) + ((_2077 - _2076) * _2077)) + ((_2076 - _2078) * _2076)) * 1.75f);
            float _2101 = _2100 * 0.3333333432674408f;
            float _2102 = _2087 + -0.4000000059604645f;
            float _2103 = _2102 * 5.0f;
            float _2107 = max((1.0f - abs(_2102 * 2.5f)), 0.0f);
            float _2118 = ((float((int)(((int)(uint)((bool)(_2103 > 0.0f))) - ((int)(uint)((bool)(_2103 < 0.0f))))) * (1.0f - (_2107 * _2107))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2101 <= 0.0533333346247673f)) {
                if (!(_2101 >= 0.1599999964237213f)) {
                  _2127 = (((0.23999999463558197f / _2100) + -0.5f) * _2118);
                } else {
                  _2127 = 0.0f;
                }
              } else {
                _2127 = _2118;
              }
              float _2128 = _2127 + 1.0f;
              float _2129 = _2128 * _2076;
              float _2130 = _2128 * _2077;
              float _2131 = _2128 * _2078;
              do {
                if (!((bool)(_2129 == _2130) && (bool)(_2130 == _2131))) {
                  float _2138 = ((_2129 * 2.0f) - _2130) - _2131;
                  float _2141 = ((_2077 - _2078) * 1.7320507764816284f) * _2128;
                  float _2143 = atan(_2141 / _2138);
                  bool _2146 = (_2138 < 0.0f);
                  bool _2147 = (_2138 == 0.0f);
                  bool _2148 = (_2141 >= 0.0f);
                  bool _2149 = (_2141 < 0.0f);
                  _2160 = select((_2148 && _2147), 90.0f, select((_2149 && _2147), -90.0f, (select((_2149 && _2146), (_2143 + -3.1415927410125732f), select((_2148 && _2146), (_2143 + 3.1415927410125732f), _2143)) * 57.2957763671875f)));
                } else {
                  _2160 = 0.0f;
                }
                float _2165 = min(max(select((_2160 < 0.0f), (_2160 + 360.0f), _2160), 0.0f), 360.0f);
                do {
                  if (_2165 < -180.0f) {
                    _2174 = (_2165 + 360.0f);
                  } else {
                    if (_2165 > 180.0f) {
                      _2174 = (_2165 + -360.0f);
                    } else {
                      _2174 = _2165;
                    }
                  }
                  do {
                    if ((bool)(_2174 > -67.5f) && (bool)(_2174 < 67.5f)) {
                      float _2180 = (_2174 + 67.5f) * 0.029629629105329514f;
                      int _2181 = int(_2180);
                      float _2183 = _2180 - float((int)(_2181));
                      float _2184 = _2183 * _2183;
                      float _2185 = _2184 * _2183;
                      if (_2181 == 3) {
                        _2213 = (((0.1666666716337204f - (_2183 * 0.5f)) + (_2184 * 0.5f)) - (_2185 * 0.1666666716337204f));
                      } else {
                        if (_2181 == 2) {
                          _2213 = ((0.6666666865348816f - _2184) + (_2185 * 0.5f));
                        } else {
                          if (_2181 == 1) {
                            _2213 = (((_2185 * -0.5f) + 0.1666666716337204f) + ((_2184 + _2183) * 0.5f));
                          } else {
                            _2213 = select((_2181 == 0), (_2185 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2213 = 0.0f;
                    }
                    float _2222 = min(max(((((_2087 * 0.27000001072883606f) * (0.029999999329447746f - _2129)) * _2213) + _2129), 0.0f), 65535.0f);
                    float _2223 = min(max(_2130, 0.0f), 65535.0f);
                    float _2224 = min(max(_2131, 0.0f), 65535.0f);
                    float _2237 = min(max(mad(-0.21492856740951538f, _2224, mad(-0.2365107536315918f, _2223, (_2222 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2238 = min(max(mad(-0.09967592358589172f, _2224, mad(1.17622971534729f, _2223, (_2222 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2239 = min(max(mad(0.9977163076400757f, _2224, mad(-0.006032449658960104f, _2223, (_2222 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2240 = dot(float3(_2237, _2238, _2239), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2263 = log2(max((lerp(_2240, _2237, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2264 = _2263 * 0.3010300099849701f;
                    float _2265 = log2(cb0_008x);
                    float _2266 = _2265 * 0.3010300099849701f;
                    do {
                      if (!(!(_2264 <= _2266))) {
                        _2335 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2273 = log2(cb0_009x);
                        float _2274 = _2273 * 0.3010300099849701f;
                        if ((bool)(_2264 > _2266) && (bool)(_2264 < _2274)) {
                          float _2282 = ((_2263 - _2265) * 0.9030900001525879f) / ((_2273 - _2265) * 0.3010300099849701f);
                          int _2283 = int(_2282);
                          float _2285 = _2282 - float((int)(_2283));
                          float _2287 = _17[_2283];
                          float _2290 = _17[(_2283 + 1)];
                          float _2295 = _2287 * 0.5f;
                          _2335 = dot(float3((_2285 * _2285), _2285, 1.0f), float3(mad((_17[(_2283 + 2)]), 0.5f, mad(_2290, -1.0f, _2295)), (_2290 - _2287), mad(_2290, 0.5f, _2295)));
                        } else {
                          do {
                            if (!(!(_2264 >= _2274))) {
                              float _2304 = log2(cb0_008z);
                              if (_2264 < (_2304 * 0.3010300099849701f)) {
                                float _2312 = ((_2263 - _2273) * 0.9030900001525879f) / ((_2304 - _2273) * 0.3010300099849701f);
                                int _2313 = int(_2312);
                                float _2315 = _2312 - float((int)(_2313));
                                float _2317 = _18[_2313];
                                float _2320 = _18[(_2313 + 1)];
                                float _2325 = _2317 * 0.5f;
                                _2335 = dot(float3((_2315 * _2315), _2315, 1.0f), float3(mad((_18[(_2313 + 2)]), 0.5f, mad(_2320, -1.0f, _2325)), (_2320 - _2317), mad(_2320, 0.5f, _2325)));
                                break;
                              }
                            }
                            _2335 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
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
                      float _2351 = log2(max((lerp(_2240, _2238, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2352 = _2351 * 0.3010300099849701f;
                      do {
                        if (!(!(_2352 <= _2266))) {
                          _2421 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2359 = log2(cb0_009x);
                          float _2360 = _2359 * 0.3010300099849701f;
                          if ((bool)(_2352 > _2266) && (bool)(_2352 < _2360)) {
                            float _2368 = ((_2351 - _2265) * 0.9030900001525879f) / ((_2359 - _2265) * 0.3010300099849701f);
                            int _2369 = int(_2368);
                            float _2371 = _2368 - float((int)(_2369));
                            float _2373 = _13[_2369];
                            float _2376 = _13[(_2369 + 1)];
                            float _2381 = _2373 * 0.5f;
                            _2421 = dot(float3((_2371 * _2371), _2371, 1.0f), float3(mad((_13[(_2369 + 2)]), 0.5f, mad(_2376, -1.0f, _2381)), (_2376 - _2373), mad(_2376, 0.5f, _2381)));
                          } else {
                            do {
                              if (!(!(_2352 >= _2360))) {
                                float _2390 = log2(cb0_008z);
                                if (_2352 < (_2390 * 0.3010300099849701f)) {
                                  float _2398 = ((_2351 - _2359) * 0.9030900001525879f) / ((_2390 - _2359) * 0.3010300099849701f);
                                  int _2399 = int(_2398);
                                  float _2401 = _2398 - float((int)(_2399));
                                  float _2403 = _14[_2399];
                                  float _2406 = _14[(_2399 + 1)];
                                  float _2411 = _2403 * 0.5f;
                                  _2421 = dot(float3((_2401 * _2401), _2401, 1.0f), float3(mad((_14[(_2399 + 2)]), 0.5f, mad(_2406, -1.0f, _2411)), (_2406 - _2403), mad(_2406, 0.5f, _2411)));
                                  break;
                                }
                              }
                              _2421 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2437 = log2(max((lerp(_2240, _2239, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2438 = _2437 * 0.3010300099849701f;
                        do {
                          if (!(!(_2438 <= _2266))) {
                            _2507 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2445 = log2(cb0_009x);
                            float _2446 = _2445 * 0.3010300099849701f;
                            if ((bool)(_2438 > _2266) && (bool)(_2438 < _2446)) {
                              float _2454 = ((_2437 - _2265) * 0.9030900001525879f) / ((_2445 - _2265) * 0.3010300099849701f);
                              int _2455 = int(_2454);
                              float _2457 = _2454 - float((int)(_2455));
                              float _2459 = _15[_2455];
                              float _2462 = _15[(_2455 + 1)];
                              float _2467 = _2459 * 0.5f;
                              _2507 = dot(float3((_2457 * _2457), _2457, 1.0f), float3(mad((_15[(_2455 + 2)]), 0.5f, mad(_2462, -1.0f, _2467)), (_2462 - _2459), mad(_2462, 0.5f, _2467)));
                            } else {
                              do {
                                if (!(!(_2438 >= _2446))) {
                                  float _2476 = log2(cb0_008z);
                                  if (_2438 < (_2476 * 0.3010300099849701f)) {
                                    float _2484 = ((_2437 - _2445) * 0.9030900001525879f) / ((_2476 - _2445) * 0.3010300099849701f);
                                    int _2485 = int(_2484);
                                    float _2487 = _2484 - float((int)(_2485));
                                    float _2489 = _16[_2485];
                                    float _2492 = _16[(_2485 + 1)];
                                    float _2497 = _2489 * 0.5f;
                                    _2507 = dot(float3((_2487 * _2487), _2487, 1.0f), float3(mad((_16[(_2485 + 2)]), 0.5f, mad(_2492, -1.0f, _2497)), (_2492 - _2489), mad(_2492, 0.5f, _2497)));
                                    break;
                                  }
                                }
                                _2507 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2511 = cb0_008w - cb0_008y;
                          float _2512 = (exp2(_2335 * 3.321928024291992f) - cb0_008y) / _2511;
                          float _2514 = (exp2(_2421 * 3.321928024291992f) - cb0_008y) / _2511;
                          float _2516 = (exp2(_2507 * 3.321928024291992f) - cb0_008y) / _2511;
                          float _2519 = mad(0.15618768334388733f, _2516, mad(0.13400420546531677f, _2514, (_2512 * 0.6624541878700256f)));
                          float _2522 = mad(0.053689517080783844f, _2516, mad(0.6740817427635193f, _2514, (_2512 * 0.2722287178039551f)));
                          float _2525 = mad(1.0103391408920288f, _2516, mad(0.00406073359772563f, _2514, (_2512 * -0.005574649665504694f)));
                          float _2538 = min(max(mad(-0.23642469942569733f, _2525, mad(-0.32480329275131226f, _2522, (_2519 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2539 = min(max(mad(0.016756348311901093f, _2525, mad(1.6153316497802734f, _2522, (_2519 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2540 = min(max(mad(0.9883948564529419f, _2525, mad(-0.008284442126750946f, _2522, (_2519 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2543 = mad(0.15618768334388733f, _2540, mad(0.13400420546531677f, _2539, (_2538 * 0.6624541878700256f)));
                          float _2546 = mad(0.053689517080783844f, _2540, mad(0.6740817427635193f, _2539, (_2538 * 0.2722287178039551f)));
                          float _2549 = mad(1.0103391408920288f, _2540, mad(0.00406073359772563f, _2539, (_2538 * -0.005574649665504694f)));
                          float _2571 = min(max((min(max(mad(-0.23642469942569733f, _2549, mad(-0.32480329275131226f, _2546, (_2543 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2572 = min(max((min(max(mad(0.016756348311901093f, _2549, mad(1.6153316497802734f, _2546, (_2543 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2573 = min(max((min(max(mad(0.9883948564529419f, _2549, mad(-0.008284442126750946f, _2546, (_2543 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          do {
                            if (!(cb0_040w == 6)) {
                              _2586 = mad(_65, _2573, mad(_64, _2572, (_2571 * _63)));
                              _2587 = mad(_68, _2573, mad(_67, _2572, (_2571 * _66)));
                              _2588 = mad(_71, _2573, mad(_70, _2572, (_2571 * _69)));
                            } else {
                              _2586 = _2571;
                              _2587 = _2572;
                              _2588 = _2573;
                            }
                            float _2598 = exp2(log2(_2586 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2599 = exp2(log2(_2587 * 9.999999747378752e-05f) * 0.1593017578125f);
                            float _2600 = exp2(log2(_2588 * 9.999999747378752e-05f) * 0.1593017578125f);
                            _2765 = exp2(log2((1.0f / ((_2598 * 18.6875f) + 1.0f)) * ((_2598 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2766 = exp2(log2((1.0f / ((_2599 * 18.6875f) + 1.0f)) * ((_2599 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                            _2767 = exp2(log2((1.0f / ((_2600 * 18.6875f) + 1.0f)) * ((_2600 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2645 = mad((WorkingColorSpace_128[0].z), _1083, mad((WorkingColorSpace_128[0].y), _1082, ((WorkingColorSpace_128[0].x) * _1081)));
            float _2648 = mad((WorkingColorSpace_128[1].z), _1083, mad((WorkingColorSpace_128[1].y), _1082, ((WorkingColorSpace_128[1].x) * _1081)));
            float _2651 = mad((WorkingColorSpace_128[2].z), _1083, mad((WorkingColorSpace_128[2].y), _1082, ((WorkingColorSpace_128[2].x) * _1081)));
            float _2670 = exp2(log2(mad(_65, _2651, mad(_64, _2648, (_2645 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2671 = exp2(log2(mad(_68, _2651, mad(_67, _2648, (_2645 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2672 = exp2(log2(mad(_71, _2651, mad(_70, _2648, (_2645 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2765 = exp2(log2((1.0f / ((_2670 * 18.6875f) + 1.0f)) * ((_2670 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2766 = exp2(log2((1.0f / ((_2671 * 18.6875f) + 1.0f)) * ((_2671 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2767 = exp2(log2((1.0f / ((_2672 * 18.6875f) + 1.0f)) * ((_2672 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(cb0_040w == 8)) {
              if (cb0_040w == 9) {
                float _2719 = mad((WorkingColorSpace_128[0].z), _1071, mad((WorkingColorSpace_128[0].y), _1070, ((WorkingColorSpace_128[0].x) * _1069)));
                float _2722 = mad((WorkingColorSpace_128[1].z), _1071, mad((WorkingColorSpace_128[1].y), _1070, ((WorkingColorSpace_128[1].x) * _1069)));
                float _2725 = mad((WorkingColorSpace_128[2].z), _1071, mad((WorkingColorSpace_128[2].y), _1070, ((WorkingColorSpace_128[2].x) * _1069)));
                _2765 = mad(_65, _2725, mad(_64, _2722, (_2719 * _63)));
                _2766 = mad(_68, _2725, mad(_67, _2722, (_2719 * _66)));
                _2767 = mad(_71, _2725, mad(_70, _2722, (_2719 * _69)));
              } else {
                float _2738 = mad((WorkingColorSpace_128[0].z), _1097, mad((WorkingColorSpace_128[0].y), _1096, ((WorkingColorSpace_128[0].x) * _1095)));
                float _2741 = mad((WorkingColorSpace_128[1].z), _1097, mad((WorkingColorSpace_128[1].y), _1096, ((WorkingColorSpace_128[1].x) * _1095)));
                float _2744 = mad((WorkingColorSpace_128[2].z), _1097, mad((WorkingColorSpace_128[2].y), _1096, ((WorkingColorSpace_128[2].x) * _1095)));
                _2765 = exp2(log2(mad(_65, _2744, mad(_64, _2741, (_2738 * _63)))) * cb0_040z);
                _2766 = exp2(log2(mad(_68, _2744, mad(_67, _2741, (_2738 * _66)))) * cb0_040z);
                _2767 = exp2(log2(mad(_71, _2744, mad(_70, _2741, (_2738 * _69)))) * cb0_040z);
              }
            } else {
              _2765 = _1081;
              _2766 = _1082;
              _2767 = _1083;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2765 * 0.9523810148239136f), (_2766 * 0.9523810148239136f), (_2767 * 0.9523810148239136f), 0.0f);
}
