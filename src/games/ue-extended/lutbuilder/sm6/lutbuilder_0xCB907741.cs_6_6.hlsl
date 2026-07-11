// Far Far West (UE 5.7.4.0)

#include "../lutbuilderoutput.hlsli"

struct FWorkingColorSpaceConstants {
  float4 FWorkingColorSpaceConstants_000[4];
  float4 FWorkingColorSpaceConstants_064[4];
  float4 FWorkingColorSpaceConstants_128[4];
  float4 FWorkingColorSpaceConstants_192[4];
  float4 FWorkingColorSpaceConstants_256[4];
  float4 FWorkingColorSpaceConstants_320[4];
  int FWorkingColorSpaceConstants_384;
};

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
  float cb0_015x : packoffset(c015.x);
  float cb0_015y : packoffset(c015.y);
  float cb0_015z : packoffset(c015.z);
  float cb0_015w : packoffset(c015.w);
  float cb0_016x : packoffset(c016.x);
  float cb0_016y : packoffset(c016.y);
  float cb0_016z : packoffset(c016.z);
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
  float cb0_038z : packoffset(c038.z);
  float cb0_038w : packoffset(c038.w);
  float cb0_039x : packoffset(c039.x);
  float cb0_039y : packoffset(c039.y);
  float cb0_039z : packoffset(c039.z);
  float cb0_039w : packoffset(c039.w);
  float cb0_040x : packoffset(c040.x);
  float cb0_040y : packoffset(c040.y);
  uint cb0_040w : packoffset(c040.w);
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  uint cb0_042w : packoffset(c042.w);
  uint cb0_043x : packoffset(c043.x);
  float cb0_044x : packoffset(c044.x);
  float cb0_044y : packoffset(c044.y);
};

cbuffer cb1 : register(b1) {
  FWorkingColorSpaceConstants WorkingColorSpace_000 : packoffset(c000.x);
};

SamplerState s0 : register(s0);

[numthreads(4, 4, 4)]
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
  float _34 = 0.5f / cb0_037x;
  float _39 = cb0_037x + -1.0f;
  float _40 = (cb0_037x * ((cb0_044x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) - _34)) / _39;
  float _41 = (cb0_037x * ((cb0_044y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) - _34)) / _39;
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
  float _186;
  float _393;
  float _394;
  float _395;
  float _918;
  float _951;
  float _965;
  float _1029;
  float _1208;
  float _1219;
  float _1230;
  float _1401;
  float _1402;
  float _1403;
  float _1414;
  float _1425;
  float _1582;
  float _1597;
  float _1612;
  float _1620;
  float _1621;
  float _1622;
  float _1689;
  float _1722;
  float _1736;
  float _1775;
  float _1897;
  float _1983;
  float _2069;
  float _2274;
  float _2289;
  float _2304;
  float _2312;
  float _2313;
  float _2314;
  float _2381;
  float _2414;
  float _2428;
  float _2467;
  float _2589;
  float _2675;
  float _2761;
  float _2976;
  float _2977;
  float _2978;
  if (!((uint)(cb0_043x) == 1)) {
    if (!((uint)(cb0_043x) == 2)) {
      if (!((uint)(cb0_043x) == 3)) {
        bool _52 = ((uint)(cb0_043x) == 4);
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
  if ((uint)(uint)(cb0_042w) > (uint)2) {
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
  if (!(abs(cb0_037y + -6500.0f) > 9.99999993922529e-09f)) {
    [branch]
    if (!(abs(cb0_037z) > 9.99999993922529e-09f)) {
      _393 = _129;
      _394 = _130;
      _395 = _131;
      float _410 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _395, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _394, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _393)));
      float _413 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _395, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _394, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _393)));
      float _416 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _395, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _394, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _393)));
      float _417 = dot(float3(_410, _413, _416), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _421 = (_410 / _417) + -1.0f;
      float _422 = (_413 / _417) + -1.0f;
      float _423 = (_416 / _417) + -1.0f;

      // float _435 = (1.0f - exp2(((_417 * _417) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_421, _422, _423), float3(_421, _422, _423)) * -4.0f));
      float _435 = (1.0f - exp2(((_417 * _417) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_421, _422, _423), float3(_421, _422, _423)) * -4.0f));

      float _451 = ((mad(-0.06368321925401688f, _416, mad(-0.3292922377586365f, _413, (_410 * 1.3704125881195068f))) - _410) * _435) + _410;
      float _452 = ((mad(-0.010861365124583244f, _416, mad(1.0970927476882935f, _413, (_410 * -0.08343357592821121f))) - _413) * _435) + _413;
      float _453 = ((mad(1.2036951780319214f, _416, mad(-0.09862580895423889f, _413, (_410 * -0.02579331398010254f))) - _416) * _435) + _416;
      float _454 = dot(float3(_451, _452, _453), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
      float _468 = cb0_021w + cb0_026w;
      float _482 = cb0_020w * cb0_025w;
      float _496 = cb0_019w * cb0_024w;
      float _510 = cb0_018w * cb0_023w;
      float _524 = cb0_017w * cb0_022w;
      float _528 = _451 - _454;
      float _529 = _452 - _454;
      float _530 = _453 - _454;
      float _587 = saturate(_454 / cb0_037w);
      float _591 = (_587 * _587) * (3.0f - (_587 * 2.0f));
      float _592 = 1.0f - _591;
      float _601 = cb0_021w + cb0_036w;
      float _610 = cb0_020w * cb0_035w;
      float _619 = cb0_019w * cb0_034w;
      float _628 = cb0_018w * cb0_033w;
      float _637 = cb0_017w * cb0_032w;
      float _700 = saturate((_454 - cb0_038x) / (cb0_038y - cb0_038x));
      float _704 = (_700 * _700) * (3.0f - (_700 * 2.0f));
      float _713 = cb0_021w + cb0_031w;
      float _722 = cb0_020w * cb0_030w;
      float _731 = cb0_019w * cb0_029w;
      float _740 = cb0_018w * cb0_028w;
      float _749 = cb0_017w * cb0_027w;
      float _807 = _591 - _704;
      float _818 = ((_704 * (((cb0_021x + cb0_036x) + _601) + (((cb0_020x * cb0_035x) * _610) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _628) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _637) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _619)))))) + (_592 * (((cb0_021x + cb0_026x) + _468) + (((cb0_020x * cb0_025x) * _482) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _510) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _524) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _496))))))) + ((((cb0_021x + cb0_031x) + _713) + (((cb0_020x * cb0_030x) * _722) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _740) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _749) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _731))))) * _807);
      float _820 = ((_704 * (((cb0_021y + cb0_036y) + _601) + (((cb0_020y * cb0_035y) * _610) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _628) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _637) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _619)))))) + (_592 * (((cb0_021y + cb0_026y) + _468) + (((cb0_020y * cb0_025y) * _482) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _510) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _524) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _496))))))) + ((((cb0_021y + cb0_031y) + _713) + (((cb0_020y * cb0_030y) * _722) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _740) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _749) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _731))))) * _807);
      float _822 = ((_704 * (((cb0_021z + cb0_036z) + _601) + (((cb0_020z * cb0_035z) * _610) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _628) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _637) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _619)))))) + (_592 * (((cb0_021z + cb0_026z) + _468) + (((cb0_020z * cb0_025z) * _482) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _510) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _524) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _496))))))) + ((((cb0_021z + cb0_031z) + _713) + (((cb0_020z * cb0_030z) * _722) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _740) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _749) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _731))))) * _807);

      UECbufferConfig cb_config = CreateCbufferConfig();
      cb_config.ue_filmblackclip = cb0_040x;
      cb_config.ue_filmtoe = cb0_039z;
      cb_config.ue_filmshoulder = cb0_039w;
      cb_config.ue_filmslope = cb0_039y;
      cb_config.ue_filmwhiteclip = cb0_040y;
      cb_config.ue_tonecurveammount = cb0_039x;
      cb_config.ue_mappingpolynomial = float3(cb0_041x, cb0_041y, cb0_041z);
      cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
      cb_config.ue_bluecorrection = cb0_038z;
      cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);
      float4 lutweights[2] = { float4(cb0_005x, cb0_005y, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
      cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xy is used

      float4 output = ProcessLutbuilder(float3(_818, _820, _822), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
      u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
      return;

      float _858 = ((mad(0.061360642313957214f, _822, mad(-4.540197551250458e-09f, _820, (_818 * 0.9386394023895264f))) - _818) * cb0_038z) + _818;
      float _859 = ((mad(0.169205904006958f, _822, mad(0.8307942152023315f, _820, (_818 * 6.775371730327606e-08f))) - _820) * cb0_038z) + _820;
      float _860 = (mad(-2.3283064365386963e-10f, _820, (_818 * -9.313225746154785e-10f)) * cb0_038z) + _822;
      float _863 = mad(0.16386905312538147f, _860, mad(0.14067868888378143f, _859, (_858 * 0.6954522132873535f)));
      float _866 = mad(0.0955343246459961f, _860, mad(0.8596711158752441f, _859, (_858 * 0.044794581830501556f)));
      float _869 = mad(1.0015007257461548f, _860, mad(0.004025210160762072f, _859, (_858 * -0.005525882821530104f)));
      float _873 = max(max(_863, _866), _869);
      float _878 = (max(_873, 1.000000013351432e-10f) - max(min(min(_863, _866), _869), 1.000000013351432e-10f)) / max(_873, 0.009999999776482582f);
      float _891 = ((_866 + _863) + _869) + (sqrt((((_869 - _866) * _869) + ((_866 - _863) * _866)) + ((_863 - _869) * _863)) * 1.75f);
      float _892 = _891 * 0.3333333432674408f;
      float _893 = _878 + -0.4000000059604645f;
      float _894 = _893 * 5.0f;
      float _898 = max((1.0f - abs(_893 * 2.5f)), 0.0f);
      float _909 = ((float(((int)(uint)((bool)(_894 > 0.0f))) - ((int)(uint)((bool)(_894 < 0.0f)))) * (1.0f - (_898 * _898))) + 1.0f) * 0.02500000037252903f;
      do {
        if (!(_892 <= 0.0533333346247673f)) {
          if (!(_892 >= 0.1599999964237213f)) {
            _918 = (((0.23999999463558197f / _891) + -0.5f) * _909);
          } else {
            _918 = 0.0f;
          }
        } else {
          _918 = _909;
        }
        float _919 = _918 + 1.0f;
        float _920 = _919 * _863;
        float _921 = _919 * _866;
        float _922 = _919 * _869;
        do {
          if (!((bool)(_920 == _921) && (bool)(_921 == _922))) {
            float _929 = ((_920 * 2.0f) - _921) - _922;
            float _932 = ((_866 - _869) * 1.7320507764816284f) * _919;
            float _934 = atan(_932 / _929);
            bool _937 = (_929 < 0.0f);
            bool _938 = (_929 == 0.0f);
            bool _939 = (_932 >= 0.0f);
            bool _940 = (_932 < 0.0f);
            _951 = select((_939 && _938), 90.0f, select((_940 && _938), -90.0f, (select((_940 && _937), (_934 + -3.1415927410125732f), select((_939 && _937), (_934 + 3.1415927410125732f), _934)) * 57.2957763671875f)));
          } else {
            _951 = 0.0f;
          }
          float _956 = min(max(select((_951 < 0.0f), (_951 + 360.0f), _951), 0.0f), 360.0f);
          do {
            if (_956 < -180.0f) {
              _965 = (_956 + 360.0f);
            } else {
              if (_956 > 180.0f) {
                _965 = (_956 + -360.0f);
              } else {
                _965 = _956;
              }
            }
            float _969 = saturate(1.0f - abs(_965 * 0.014814814552664757f));
            float _973 = (_969 * _969) * (3.0f - (_969 * 2.0f));
            float _979 = ((_973 * _973) * ((_878 * 0.18000000715255737f) * (0.029999999329447746f - _920))) + _920;
            float _989 = max(0.0f, mad(-0.21492856740951538f, _922, mad(-0.2365107536315918f, _921, (_979 * 1.4514392614364624f))));
            float _990 = max(0.0f, mad(-0.09967592358589172f, _922, mad(1.17622971534729f, _921, (_979 * -0.07655377686023712f))));
            float _991 = max(0.0f, mad(0.9977163076400757f, _922, mad(-0.006032449658960104f, _921, (_979 * 0.008316148072481155f))));
            float _992 = dot(float3(_989, _990, _991), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
            float _1007 = (cb0_040x + 1.0f) - cb0_039z;
            float _1009 = cb0_040y + 1.0f;
            float _1011 = _1009 - cb0_039w;
            do {
              if (cb0_039z > 0.800000011920929f) {
                _1029 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
              } else {
                float _1020 = (cb0_040x + 0.18000000715255737f) / _1007;
                _1029 = (-0.7447274923324585f - ((log2(_1020 / (2.0f - _1020)) * 0.3465735912322998f) * (_1007 / cb0_039y)));
              }
              float _1032 = ((1.0f - cb0_039z) / cb0_039y) - _1029;
              float _1034 = (cb0_039w / cb0_039y) - _1032;
              float _1038 = log2(lerp(_992, _989, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1039 = log2(lerp(_992, _990, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1040 = log2(lerp(_992, _991, 0.9599999785423279f)) * 0.3010300099849701f;
              float _1044 = cb0_039y * (_1038 + _1032);
              float _1045 = cb0_039y * (_1039 + _1032);
              float _1046 = cb0_039y * (_1040 + _1032);
              float _1047 = _1007 * 2.0f;
              float _1049 = (cb0_039y * -2.0f) / _1007;
              float _1050 = _1038 - _1029;
              float _1051 = _1039 - _1029;
              float _1052 = _1040 - _1029;
              float _1071 = _1011 * 2.0f;
              float _1073 = (cb0_039y * 2.0f) / _1011;
              float _1098 = select((_1038 < _1029), ((_1047 / (exp2((_1050 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1044);
              float _1099 = select((_1039 < _1029), ((_1047 / (exp2((_1051 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1045);
              float _1100 = select((_1040 < _1029), ((_1047 / (exp2((_1052 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1046);
              float _1107 = _1034 - _1029;
              float _1111 = saturate(_1050 / _1107);
              float _1112 = saturate(_1051 / _1107);
              float _1113 = saturate(_1052 / _1107);
              bool _1114 = (_1034 < _1029);
              float _1118 = select(_1114, (1.0f - _1111), _1111);
              float _1119 = select(_1114, (1.0f - _1112), _1112);
              float _1120 = select(_1114, (1.0f - _1113), _1113);
              float _1139 = (((_1118 * _1118) * (select((_1038 > _1034), (_1009 - (_1071 / (exp2(((_1038 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1044) - _1098)) * (3.0f - (_1118 * 2.0f))) + _1098;
              float _1140 = (((_1119 * _1119) * (select((_1039 > _1034), (_1009 - (_1071 / (exp2(((_1039 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1045) - _1099)) * (3.0f - (_1119 * 2.0f))) + _1099;
              float _1141 = (((_1120 * _1120) * (select((_1040 > _1034), (_1009 - (_1071 / (exp2(((_1040 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1046) - _1100)) * (3.0f - (_1120 * 2.0f))) + _1100;
              float _1142 = dot(float3(_1139, _1140, _1141), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
              float _1162 = (cb0_039x * (max(0.0f, (lerp(_1142, _1139, 0.9300000071525574f))) - _858)) + _858;
              float _1163 = (cb0_039x * (max(0.0f, (lerp(_1142, _1140, 0.9300000071525574f))) - _859)) + _859;
              float _1164 = (cb0_039x * (max(0.0f, (lerp(_1142, _1141, 0.9300000071525574f))) - _860)) + _860;
              float _1180 = ((mad(-0.06537103652954102f, _1164, mad(1.451815478503704e-06f, _1163, (_1162 * 1.065374732017517f))) - _1162) * cb0_038z) + _1162;
              float _1181 = ((mad(-0.20366770029067993f, _1164, mad(1.2036634683609009f, _1163, (_1162 * -2.57161445915699e-07f))) - _1163) * cb0_038z) + _1163;
              float _1182 = ((mad(0.9999996423721313f, _1164, mad(2.0954757928848267e-08f, _1163, (_1162 * 1.862645149230957e-08f))) - _1164) * cb0_038z) + _1164;
              float _1195 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1182, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1181, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1180)))));
              float _1196 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1182, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1181, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1180)))));
              float _1197 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1182, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1181, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1180)))));
              do {
                if (_1195 < 0.0031306699384003878f) {
                  _1208 = (_1195 * 12.920000076293945f);
                } else {
                  _1208 = (((pow(_1195, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                }
                do {
                  if (_1196 < 0.0031306699384003878f) {
                    _1219 = (_1196 * 12.920000076293945f);
                  } else {
                    _1219 = (((pow(_1196, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                  }
                  do {
                    if (_1197 < 0.0031306699384003878f) {
                      _1230 = (_1197 * 12.920000076293945f);
                    } else {
                      _1230 = (((pow(_1197, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                    }
                    float _1234 = (_1219 * 0.9375f) + 0.03125f;
                    float _1241 = _1230 * 15.0f;
                    float _1242 = floor(_1241);
                    float _1243 = _1241 - _1242;
                    float _1245 = (((_1208 * 0.9375f) + 0.03125f) + _1242) * 0.0625f;
                    float4 _1248 = t0.SampleLevel(s0, float2(_1245, _1234), 0.0f);
                    float4 _1253 = t0.SampleLevel(s0, float2((_1245 + 0.0625f), _1234), 0.0f);
                    float _1269 = ((lerp(_1248.x, _1253.x, _1243)) * cb0_005y) + (cb0_005x * _1208);
                    float _1270 = ((lerp(_1248.y, _1253.y, _1243)) * cb0_005y) + (cb0_005x * _1219);
                    float _1271 = ((lerp(_1248.z, _1253.z, _1243)) * cb0_005y) + (cb0_005x * _1230);
                    float _1296 = select((_1269 > 0.040449999272823334f), exp2(log2((abs(_1269) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1269 * 0.07739938050508499f));
                    float _1297 = select((_1270 > 0.040449999272823334f), exp2(log2((abs(_1270) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1270 * 0.07739938050508499f));
                    float _1298 = select((_1271 > 0.040449999272823334f), exp2(log2((abs(_1271) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1271 * 0.07739938050508499f));
                    float _1324 = cb0_016x * (((cb0_041y + (cb0_041x * _1296)) * _1296) + cb0_041z);
                    float _1325 = cb0_016y * (((cb0_041y + (cb0_041x * _1297)) * _1297) + cb0_041z);
                    float _1326 = cb0_016z * (((cb0_041y + (cb0_041x * _1298)) * _1298) + cb0_041z);
                    float _1333 = ((cb0_015x - _1324) * cb0_015w) + _1324;
                    float _1334 = ((cb0_015y - _1325) * cb0_015w) + _1325;
                    float _1335 = ((cb0_015z - _1326) * cb0_015w) + _1326;
                    float _1336 = cb0_016x * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _822, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _820, (_818 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x))));
                    float _1337 = cb0_016y * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _822, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _820, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _818)));
                    float _1338 = cb0_016z * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _822, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _820, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _818)));
                    float _1345 = ((cb0_015x - _1336) * cb0_015w) + _1336;
                    float _1346 = ((cb0_015y - _1337) * cb0_015w) + _1337;
                    float _1347 = ((cb0_015z - _1338) * cb0_015w) + _1338;
                    float _1359 = exp2(log2(max(0.0f, _1333)) * cb0_042y);
                    float _1360 = exp2(log2(max(0.0f, _1334)) * cb0_042y);
                    float _1361 = exp2(log2(max(0.0f, _1335)) * cb0_042y);
                    do {
                      [branch]
                      if ((uint)(cb0_042w) == 0) {
                        do {
                          if ((uint)(WorkingColorSpace_000.FWorkingColorSpaceConstants_384) == 0) {
                            float _1384 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1359)));
                            float _1387 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1359)));
                            float _1390 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1359)));
                            _1401 = mad(_65, _1390, mad(_64, _1387, (_1384 * _63)));
                            _1402 = mad(_68, _1390, mad(_67, _1387, (_1384 * _66)));
                            _1403 = mad(_71, _1390, mad(_70, _1387, (_1384 * _69)));
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
                                _2976 = _1414;
                                _2977 = _1425;
                                _2978 = (_1403 * 12.920000076293945f);
                              } else {
                                _2976 = _1414;
                                _2977 = _1425;
                                _2978 = (((pow(_1403, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
                              }
                            } while (false);
                          } while (false);
                        } while (false);
                      } else {
                        if ((uint)(cb0_042w) == 1) {
                          float _1452 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1359)));
                          float _1455 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1359)));
                          float _1458 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1359)));
                          float _1461 = mad(_65, _1458, mad(_64, _1455, (_1452 * _63)));
                          float _1464 = mad(_68, _1458, mad(_67, _1455, (_1452 * _66)));
                          float _1467 = mad(_71, _1458, mad(_70, _1455, (_1452 * _69)));
                          _2976 = min((_1461 * 4.5f), ((exp2(log2(max(_1461, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                          _2977 = min((_1464 * 4.5f), ((exp2(log2(max(_1464, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                          _2978 = min((_1467 * 4.5f), ((exp2(log2(max(_1467, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
                        } else {
                          if ((uint)((uint)(cb0_042w + -3u)) < (uint)2) {
                            float _1530 = cb0_012z * _1345;
                            float _1531 = cb0_012z * _1346;
                            float _1532 = cb0_012z * _1347;
                            float _1535 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _1532, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _1531, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _1530)));
                            float _1538 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _1532, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _1531, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _1530)));
                            float _1541 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _1532, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _1531, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _1530)));
                            float _1544 = mad(-0.21492856740951538f, _1541, mad(-0.2365107536315918f, _1538, (_1535 * 1.4514392614364624f)));
                            float _1547 = mad(-0.09967592358589172f, _1541, mad(1.17622971534729f, _1538, (_1535 * -0.07655377686023712f)));
                            float _1550 = mad(0.9977163076400757f, _1541, mad(-0.006032449658960104f, _1538, (_1535 * 0.008316148072481155f)));
                            float _1552 = max(_1544, max(_1547, _1550));
                            do {
                              if (!(_1552 < 1.000000013351432e-10f)) {
                                if (!(((bool)((bool)(_1535 < 0.0f) || (bool)(_1538 < 0.0f))) || (bool)(_1541 < 0.0f))) {
                                  float _1562 = abs(_1552);
                                  float _1563 = (_1552 - _1544) / _1562;
                                  float _1565 = (_1552 - _1547) / _1562;
                                  float _1567 = (_1552 - _1550) / _1562;
                                  do {
                                    if (!(_1563 < 0.8149999976158142f)) {
                                      float _1570 = _1563 + -0.8149999976158142f;
                                      _1582 = ((_1570 / exp2(log2(exp2(log2(_1570 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                    } else {
                                      _1582 = _1563;
                                    }
                                    do {
                                      if (!(_1565 < 0.8029999732971191f)) {
                                        float _1585 = _1565 + -0.8029999732971191f;
                                        _1597 = ((_1585 / exp2(log2(exp2(log2(_1585 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                      } else {
                                        _1597 = _1565;
                                      }
                                      do {
                                        if (!(_1567 < 0.8799999952316284f)) {
                                          float _1600 = _1567 + -0.8799999952316284f;
                                          _1612 = ((_1600 / exp2(log2(exp2(log2(_1600 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                        } else {
                                          _1612 = _1567;
                                        }
                                        _1620 = (_1552 - (_1562 * _1582));
                                        _1621 = (_1552 - (_1562 * _1597));
                                        _1622 = (_1552 - (_1562 * _1612));
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } else {
                                  _1620 = _1544;
                                  _1621 = _1547;
                                  _1622 = _1550;
                                }
                              } else {
                                _1620 = _1544;
                                _1621 = _1547;
                                _1622 = _1550;
                              }
                              float _1638 = ((mad(0.16386906802654266f, _1622, mad(0.14067870378494263f, _1621, (_1620 * 0.6954522132873535f))) - _1535) * cb0_012w) + _1535;
                              float _1639 = ((mad(0.0955343171954155f, _1622, mad(0.8596711158752441f, _1621, (_1620 * 0.044794563204050064f))) - _1538) * cb0_012w) + _1538;
                              float _1640 = ((mad(1.0015007257461548f, _1622, mad(0.004025210160762072f, _1621, (_1620 * -0.005525882821530104f))) - _1541) * cb0_012w) + _1541;
                              float _1644 = max(max(_1638, _1639), _1640);
                              float _1649 = (max(_1644, 1.000000013351432e-10f) - max(min(min(_1638, _1639), _1640), 1.000000013351432e-10f)) / max(_1644, 0.009999999776482582f);
                              float _1662 = ((_1639 + _1638) + _1640) + (sqrt((((_1640 - _1639) * _1640) + ((_1639 - _1638) * _1639)) + ((_1638 - _1640) * _1638)) * 1.75f);
                              float _1663 = _1662 * 0.3333333432674408f;
                              float _1664 = _1649 + -0.4000000059604645f;
                              float _1665 = _1664 * 5.0f;
                              float _1669 = max((1.0f - abs(_1664 * 2.5f)), 0.0f);
                              float _1680 = ((float(((int)(uint)((bool)(_1665 > 0.0f))) - ((int)(uint)((bool)(_1665 < 0.0f)))) * (1.0f - (_1669 * _1669))) + 1.0f) * 0.02500000037252903f;
                              do {
                                if (!(_1663 <= 0.0533333346247673f)) {
                                  if (!(_1663 >= 0.1599999964237213f)) {
                                    _1689 = (((0.23999999463558197f / _1662) + -0.5f) * _1680);
                                  } else {
                                    _1689 = 0.0f;
                                  }
                                } else {
                                  _1689 = _1680;
                                }
                                float _1690 = _1689 + 1.0f;
                                float _1691 = _1690 * _1638;
                                float _1692 = _1690 * _1639;
                                float _1693 = _1690 * _1640;
                                do {
                                  if (!((bool)(_1691 == _1692) && (bool)(_1692 == _1693))) {
                                    float _1700 = ((_1691 * 2.0f) - _1692) - _1693;
                                    float _1703 = ((_1639 - _1640) * 1.7320507764816284f) * _1690;
                                    float _1705 = atan(_1703 / _1700);
                                    bool _1708 = (_1700 < 0.0f);
                                    bool _1709 = (_1700 == 0.0f);
                                    bool _1710 = (_1703 >= 0.0f);
                                    bool _1711 = (_1703 < 0.0f);
                                    _1722 = select((_1710 && _1709), 90.0f, select((_1711 && _1709), -90.0f, (select((_1711 && _1708), (_1705 + -3.1415927410125732f), select((_1710 && _1708), (_1705 + 3.1415927410125732f), _1705)) * 57.2957763671875f)));
                                  } else {
                                    _1722 = 0.0f;
                                  }
                                  float _1727 = min(max(select((_1722 < 0.0f), (_1722 + 360.0f), _1722), 0.0f), 360.0f);
                                  do {
                                    if (_1727 < -180.0f) {
                                      _1736 = (_1727 + 360.0f);
                                    } else {
                                      if (_1727 > 180.0f) {
                                        _1736 = (_1727 + -360.0f);
                                      } else {
                                        _1736 = _1727;
                                      }
                                    }
                                    do {
                                      if ((bool)(_1736 > -67.5f) && (bool)(_1736 < 67.5f)) {
                                        float _1742 = (_1736 + 67.5f) * 0.029629629105329514f;
                                        int _1743 = int(_1742);
                                        float _1745 = _1742 - float(_1743);
                                        float _1746 = _1745 * _1745;
                                        float _1747 = _1746 * _1745;
                                        if (_1743 == 3) {
                                          _1775 = (((0.1666666716337204f - (_1745 * 0.5f)) + (_1746 * 0.5f)) - (_1747 * 0.1666666716337204f));
                                        } else {
                                          if (_1743 == 2) {
                                            _1775 = ((0.6666666865348816f - _1746) + (_1747 * 0.5f));
                                          } else {
                                            if (_1743 == 1) {
                                              _1775 = (((_1747 * -0.5f) + 0.1666666716337204f) + ((_1746 + _1745) * 0.5f));
                                            } else {
                                              _1775 = select((_1743 == 0), (_1747 * 0.1666666716337204f), 0.0f);
                                            }
                                          }
                                        }
                                      } else {
                                        _1775 = 0.0f;
                                      }
                                      float _1784 = min(max(((((_1649 * 0.27000001072883606f) * (0.029999999329447746f - _1691)) * _1775) + _1691), 0.0f), 65535.0f);
                                      float _1785 = min(max(_1692, 0.0f), 65535.0f);
                                      float _1786 = min(max(_1693, 0.0f), 65535.0f);
                                      float _1799 = min(max(mad(-0.21492856740951538f, _1786, mad(-0.2365107536315918f, _1785, (_1784 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                      float _1800 = min(max(mad(-0.09967592358589172f, _1786, mad(1.17622971534729f, _1785, (_1784 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                      float _1801 = min(max(mad(0.9977163076400757f, _1786, mad(-0.006032449658960104f, _1785, (_1784 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                      float _1802 = dot(float3(_1799, _1800, _1801), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                      float _1825 = log2(max((lerp(_1802, _1799, 0.9599999785423279f)), 1.000000013351432e-10f));
                                      float _1826 = _1825 * 0.3010300099849701f;
                                      float _1827 = log2(cb0_008x);
                                      float _1828 = _1827 * 0.3010300099849701f;
                                      do {
                                        if (!(!(_1826 <= _1828))) {
                                          _1897 = (log2(cb0_008y) * 0.3010300099849701f);
                                        } else {
                                          float _1835 = log2(cb0_009x);
                                          float _1836 = _1835 * 0.3010300099849701f;
                                          if ((bool)(_1826 > _1828) && (bool)(_1826 < _1836)) {
                                            float _1844 = ((_1825 - _1827) * 0.9030900001525879f) / ((_1835 - _1827) * 0.3010300099849701f);
                                            int _1845 = int(_1844);
                                            float _1847 = _1844 - float(_1845);
                                            float _1849 = _17[_1845];
                                            float _1852 = _17[(_1845 + 1)];
                                            float _1857 = _1849 * 0.5f;
                                            _1897 = dot(float3((_1847 * _1847), _1847, 1.0f), float3(mad((_17[(_1845 + 2)]), 0.5f, mad(_1852, -1.0f, _1857)), (_1852 - _1849), mad(_1852, 0.5f, _1857)));
                                          } else {
                                            do {
                                              if (!(!(_1826 >= _1836))) {
                                                float _1866 = log2(cb0_008z);
                                                if (_1826 < (_1866 * 0.3010300099849701f)) {
                                                  float _1874 = ((_1825 - _1835) * 0.9030900001525879f) / ((_1866 - _1835) * 0.3010300099849701f);
                                                  int _1875 = int(_1874);
                                                  float _1877 = _1874 - float(_1875);
                                                  float _1879 = _18[_1875];
                                                  float _1882 = _18[(_1875 + 1)];
                                                  float _1887 = _1879 * 0.5f;
                                                  _1897 = dot(float3((_1877 * _1877), _1877, 1.0f), float3(mad((_18[(_1875 + 2)]), 0.5f, mad(_1882, -1.0f, _1887)), (_1882 - _1879), mad(_1882, 0.5f, _1887)));
                                                  break;
                                                }
                                              }
                                              _1897 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                        float _1913 = log2(max((lerp(_1802, _1800, 0.9599999785423279f)), 1.000000013351432e-10f));
                                        float _1914 = _1913 * 0.3010300099849701f;
                                        do {
                                          if (!(!(_1914 <= _1828))) {
                                            _1983 = (log2(cb0_008y) * 0.3010300099849701f);
                                          } else {
                                            float _1921 = log2(cb0_009x);
                                            float _1922 = _1921 * 0.3010300099849701f;
                                            if ((bool)(_1914 > _1828) && (bool)(_1914 < _1922)) {
                                              float _1930 = ((_1913 - _1827) * 0.9030900001525879f) / ((_1921 - _1827) * 0.3010300099849701f);
                                              int _1931 = int(_1930);
                                              float _1933 = _1930 - float(_1931);
                                              float _1935 = _19[_1931];
                                              float _1938 = _19[(_1931 + 1)];
                                              float _1943 = _1935 * 0.5f;
                                              _1983 = dot(float3((_1933 * _1933), _1933, 1.0f), float3(mad((_19[(_1931 + 2)]), 0.5f, mad(_1938, -1.0f, _1943)), (_1938 - _1935), mad(_1938, 0.5f, _1943)));
                                            } else {
                                              do {
                                                if (!(!(_1914 >= _1922))) {
                                                  float _1952 = log2(cb0_008z);
                                                  if (_1914 < (_1952 * 0.3010300099849701f)) {
                                                    float _1960 = ((_1913 - _1921) * 0.9030900001525879f) / ((_1952 - _1921) * 0.3010300099849701f);
                                                    int _1961 = int(_1960);
                                                    float _1963 = _1960 - float(_1961);
                                                    float _1965 = _20[_1961];
                                                    float _1968 = _20[(_1961 + 1)];
                                                    float _1973 = _1965 * 0.5f;
                                                    _1983 = dot(float3((_1963 * _1963), _1963, 1.0f), float3(mad((_20[(_1961 + 2)]), 0.5f, mad(_1968, -1.0f, _1973)), (_1968 - _1965), mad(_1968, 0.5f, _1973)));
                                                    break;
                                                  }
                                                }
                                                _1983 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                          float _1999 = log2(max((lerp(_1802, _1801, 0.9599999785423279f)), 1.000000013351432e-10f));
                                          float _2000 = _1999 * 0.3010300099849701f;
                                          do {
                                            if (!(!(_2000 <= _1828))) {
                                              _2069 = (log2(cb0_008y) * 0.3010300099849701f);
                                            } else {
                                              float _2007 = log2(cb0_009x);
                                              float _2008 = _2007 * 0.3010300099849701f;
                                              if ((bool)(_2000 > _1828) && (bool)(_2000 < _2008)) {
                                                float _2016 = ((_1999 - _1827) * 0.9030900001525879f) / ((_2007 - _1827) * 0.3010300099849701f);
                                                int _2017 = int(_2016);
                                                float _2019 = _2016 - float(_2017);
                                                float _2021 = _21[_2017];
                                                float _2024 = _21[(_2017 + 1)];
                                                float _2029 = _2021 * 0.5f;
                                                _2069 = dot(float3((_2019 * _2019), _2019, 1.0f), float3(mad((_21[(_2017 + 2)]), 0.5f, mad(_2024, -1.0f, _2029)), (_2024 - _2021), mad(_2024, 0.5f, _2029)));
                                              } else {
                                                do {
                                                  if (!(!(_2000 >= _2008))) {
                                                    float _2038 = log2(cb0_008z);
                                                    if (_2000 < (_2038 * 0.3010300099849701f)) {
                                                      float _2046 = ((_1999 - _2007) * 0.9030900001525879f) / ((_2038 - _2007) * 0.3010300099849701f);
                                                      int _2047 = int(_2046);
                                                      float _2049 = _2046 - float(_2047);
                                                      float _2051 = _22[_2047];
                                                      float _2054 = _22[(_2047 + 1)];
                                                      float _2059 = _2051 * 0.5f;
                                                      _2069 = dot(float3((_2049 * _2049), _2049, 1.0f), float3(mad((_22[(_2047 + 2)]), 0.5f, mad(_2054, -1.0f, _2059)), (_2054 - _2051), mad(_2054, 0.5f, _2059)));
                                                      break;
                                                    }
                                                  }
                                                  _2069 = (log2(cb0_008w) * 0.3010300099849701f);
                                                } while (false);
                                              }
                                            }
                                            float _2073 = cb0_008w - cb0_008y;
                                            float _2074 = (exp2(_1897 * 3.321928024291992f) - cb0_008y) / _2073;
                                            float _2076 = (exp2(_1983 * 3.321928024291992f) - cb0_008y) / _2073;
                                            float _2078 = (exp2(_2069 * 3.321928024291992f) - cb0_008y) / _2073;
                                            float _2081 = mad(0.15618768334388733f, _2078, mad(0.13400420546531677f, _2076, (_2074 * 0.6624541878700256f)));
                                            float _2084 = mad(0.053689517080783844f, _2078, mad(0.6740817427635193f, _2076, (_2074 * 0.2722287178039551f)));
                                            float _2087 = mad(1.0103391408920288f, _2078, mad(0.00406073359772563f, _2076, (_2074 * -0.005574649665504694f)));
                                            float _2100 = min(max(mad(-0.23642469942569733f, _2087, mad(-0.32480329275131226f, _2084, (_2081 * 1.6410233974456787f))), 0.0f), 1.0f);
                                            float _2101 = min(max(mad(0.016756348311901093f, _2087, mad(1.6153316497802734f, _2084, (_2081 * -0.663662850856781f))), 0.0f), 1.0f);
                                            float _2102 = min(max(mad(0.9883948564529419f, _2087, mad(-0.008284442126750946f, _2084, (_2081 * 0.011721894145011902f))), 0.0f), 1.0f);
                                            float _2105 = mad(0.15618768334388733f, _2102, mad(0.13400420546531677f, _2101, (_2100 * 0.6624541878700256f)));
                                            float _2108 = mad(0.053689517080783844f, _2102, mad(0.6740817427635193f, _2101, (_2100 * 0.2722287178039551f)));
                                            float _2111 = mad(1.0103391408920288f, _2102, mad(0.00406073359772563f, _2101, (_2100 * -0.005574649665504694f)));
                                            float _2133 = min(max((min(max(mad(-0.23642469942569733f, _2111, mad(-0.32480329275131226f, _2108, (_2105 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                            float _2134 = min(max((min(max(mad(0.016756348311901093f, _2111, mad(1.6153316497802734f, _2108, (_2105 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                            float _2135 = min(max((min(max(mad(0.9883948564529419f, _2111, mad(-0.008284442126750946f, _2108, (_2105 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                            float _2154 = exp2(log2(mad(_65, _2135, mad(_64, _2134, (_2133 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                            float _2155 = exp2(log2(mad(_68, _2135, mad(_67, _2134, (_2133 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                            float _2156 = exp2(log2(mad(_71, _2135, mad(_70, _2134, (_2133 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                            _2976 = exp2(log2((1.0f / ((_2154 * 18.6875f) + 1.0f)) * ((_2154 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                            _2977 = exp2(log2((1.0f / ((_2155 * 18.6875f) + 1.0f)) * ((_2155 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                            _2978 = exp2(log2((1.0f / ((_2156 * 18.6875f) + 1.0f)) * ((_2156 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } while (false);
                          } else {
                            if ((uint)((uint)(cb0_042w + -5u)) < (uint)2) {
                              float _2222 = cb0_012z * _1345;
                              float _2223 = cb0_012z * _1346;
                              float _2224 = cb0_012z * _1347;
                              float _2227 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _2224, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _2223, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _2222)));
                              float _2230 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _2224, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _2223, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _2222)));
                              float _2233 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _2224, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _2223, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _2222)));
                              float _2236 = mad(-0.21492856740951538f, _2233, mad(-0.2365107536315918f, _2230, (_2227 * 1.4514392614364624f)));
                              float _2239 = mad(-0.09967592358589172f, _2233, mad(1.17622971534729f, _2230, (_2227 * -0.07655377686023712f)));
                              float _2242 = mad(0.9977163076400757f, _2233, mad(-0.006032449658960104f, _2230, (_2227 * 0.008316148072481155f)));
                              float _2244 = max(_2236, max(_2239, _2242));
                              do {
                                if (!(_2244 < 1.000000013351432e-10f)) {
                                  if (!(((bool)((bool)(_2227 < 0.0f) || (bool)(_2230 < 0.0f))) || (bool)(_2233 < 0.0f))) {
                                    float _2254 = abs(_2244);
                                    float _2255 = (_2244 - _2236) / _2254;
                                    float _2257 = (_2244 - _2239) / _2254;
                                    float _2259 = (_2244 - _2242) / _2254;
                                    do {
                                      if (!(_2255 < 0.8149999976158142f)) {
                                        float _2262 = _2255 + -0.8149999976158142f;
                                        _2274 = ((_2262 / exp2(log2(exp2(log2(_2262 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                                      } else {
                                        _2274 = _2255;
                                      }
                                      do {
                                        if (!(_2257 < 0.8029999732971191f)) {
                                          float _2277 = _2257 + -0.8029999732971191f;
                                          _2289 = ((_2277 / exp2(log2(exp2(log2(_2277 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                                        } else {
                                          _2289 = _2257;
                                        }
                                        do {
                                          if (!(_2259 < 0.8799999952316284f)) {
                                            float _2292 = _2259 + -0.8799999952316284f;
                                            _2304 = ((_2292 / exp2(log2(exp2(log2(_2292 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                                          } else {
                                            _2304 = _2259;
                                          }
                                          _2312 = (_2244 - (_2254 * _2274));
                                          _2313 = (_2244 - (_2254 * _2289));
                                          _2314 = (_2244 - (_2254 * _2304));
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } else {
                                    _2312 = _2236;
                                    _2313 = _2239;
                                    _2314 = _2242;
                                  }
                                } else {
                                  _2312 = _2236;
                                  _2313 = _2239;
                                  _2314 = _2242;
                                }
                                float _2330 = ((mad(0.16386906802654266f, _2314, mad(0.14067870378494263f, _2313, (_2312 * 0.6954522132873535f))) - _2227) * cb0_012w) + _2227;
                                float _2331 = ((mad(0.0955343171954155f, _2314, mad(0.8596711158752441f, _2313, (_2312 * 0.044794563204050064f))) - _2230) * cb0_012w) + _2230;
                                float _2332 = ((mad(1.0015007257461548f, _2314, mad(0.004025210160762072f, _2313, (_2312 * -0.005525882821530104f))) - _2233) * cb0_012w) + _2233;
                                float _2336 = max(max(_2330, _2331), _2332);
                                float _2341 = (max(_2336, 1.000000013351432e-10f) - max(min(min(_2330, _2331), _2332), 1.000000013351432e-10f)) / max(_2336, 0.009999999776482582f);
                                float _2354 = ((_2331 + _2330) + _2332) + (sqrt((((_2332 - _2331) * _2332) + ((_2331 - _2330) * _2331)) + ((_2330 - _2332) * _2330)) * 1.75f);
                                float _2355 = _2354 * 0.3333333432674408f;
                                float _2356 = _2341 + -0.4000000059604645f;
                                float _2357 = _2356 * 5.0f;
                                float _2361 = max((1.0f - abs(_2356 * 2.5f)), 0.0f);
                                float _2372 = ((float(((int)(uint)((bool)(_2357 > 0.0f))) - ((int)(uint)((bool)(_2357 < 0.0f)))) * (1.0f - (_2361 * _2361))) + 1.0f) * 0.02500000037252903f;
                                do {
                                  if (!(_2355 <= 0.0533333346247673f)) {
                                    if (!(_2355 >= 0.1599999964237213f)) {
                                      _2381 = (((0.23999999463558197f / _2354) + -0.5f) * _2372);
                                    } else {
                                      _2381 = 0.0f;
                                    }
                                  } else {
                                    _2381 = _2372;
                                  }
                                  float _2382 = _2381 + 1.0f;
                                  float _2383 = _2382 * _2330;
                                  float _2384 = _2382 * _2331;
                                  float _2385 = _2382 * _2332;
                                  do {
                                    if (!((bool)(_2383 == _2384) && (bool)(_2384 == _2385))) {
                                      float _2392 = ((_2383 * 2.0f) - _2384) - _2385;
                                      float _2395 = ((_2331 - _2332) * 1.7320507764816284f) * _2382;
                                      float _2397 = atan(_2395 / _2392);
                                      bool _2400 = (_2392 < 0.0f);
                                      bool _2401 = (_2392 == 0.0f);
                                      bool _2402 = (_2395 >= 0.0f);
                                      bool _2403 = (_2395 < 0.0f);
                                      _2414 = select((_2402 && _2401), 90.0f, select((_2403 && _2401), -90.0f, (select((_2403 && _2400), (_2397 + -3.1415927410125732f), select((_2402 && _2400), (_2397 + 3.1415927410125732f), _2397)) * 57.2957763671875f)));
                                    } else {
                                      _2414 = 0.0f;
                                    }
                                    float _2419 = min(max(select((_2414 < 0.0f), (_2414 + 360.0f), _2414), 0.0f), 360.0f);
                                    do {
                                      if (_2419 < -180.0f) {
                                        _2428 = (_2419 + 360.0f);
                                      } else {
                                        if (_2419 > 180.0f) {
                                          _2428 = (_2419 + -360.0f);
                                        } else {
                                          _2428 = _2419;
                                        }
                                      }
                                      do {
                                        if ((bool)(_2428 > -67.5f) && (bool)(_2428 < 67.5f)) {
                                          float _2434 = (_2428 + 67.5f) * 0.029629629105329514f;
                                          int _2435 = int(_2434);
                                          float _2437 = _2434 - float(_2435);
                                          float _2438 = _2437 * _2437;
                                          float _2439 = _2438 * _2437;
                                          if (_2435 == 3) {
                                            _2467 = (((0.1666666716337204f - (_2437 * 0.5f)) + (_2438 * 0.5f)) - (_2439 * 0.1666666716337204f));
                                          } else {
                                            if (_2435 == 2) {
                                              _2467 = ((0.6666666865348816f - _2438) + (_2439 * 0.5f));
                                            } else {
                                              if (_2435 == 1) {
                                                _2467 = (((_2439 * -0.5f) + 0.1666666716337204f) + ((_2438 + _2437) * 0.5f));
                                              } else {
                                                _2467 = select((_2435 == 0), (_2439 * 0.1666666716337204f), 0.0f);
                                              }
                                            }
                                          }
                                        } else {
                                          _2467 = 0.0f;
                                        }
                                        float _2476 = min(max(((((_2341 * 0.27000001072883606f) * (0.029999999329447746f - _2383)) * _2467) + _2383), 0.0f), 65535.0f);
                                        float _2477 = min(max(_2384, 0.0f), 65535.0f);
                                        float _2478 = min(max(_2385, 0.0f), 65535.0f);
                                        float _2491 = min(max(mad(-0.21492856740951538f, _2478, mad(-0.2365107536315918f, _2477, (_2476 * 1.4514392614364624f))), 0.0f), 65504.0f);
                                        float _2492 = min(max(mad(-0.09967592358589172f, _2478, mad(1.17622971534729f, _2477, (_2476 * -0.07655377686023712f))), 0.0f), 65504.0f);
                                        float _2493 = min(max(mad(0.9977163076400757f, _2478, mad(-0.006032449658960104f, _2477, (_2476 * 0.008316148072481155f))), 0.0f), 65504.0f);
                                        float _2494 = dot(float3(_2491, _2492, _2493), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                                        float _2517 = log2(max((lerp(_2494, _2491, 0.9599999785423279f)), 1.000000013351432e-10f));
                                        float _2518 = _2517 * 0.3010300099849701f;
                                        float _2519 = log2(cb0_008x);
                                        float _2520 = _2519 * 0.3010300099849701f;
                                        do {
                                          if (!(!(_2518 <= _2520))) {
                                            _2589 = (log2(cb0_008y) * 0.3010300099849701f);
                                          } else {
                                            float _2527 = log2(cb0_009x);
                                            float _2528 = _2527 * 0.3010300099849701f;
                                            if ((bool)(_2518 > _2520) && (bool)(_2518 < _2528)) {
                                              float _2536 = ((_2517 - _2519) * 0.9030900001525879f) / ((_2527 - _2519) * 0.3010300099849701f);
                                              int _2537 = int(_2536);
                                              float _2539 = _2536 - float(_2537);
                                              float _2541 = _11[_2537];
                                              float _2544 = _11[(_2537 + 1)];
                                              float _2549 = _2541 * 0.5f;
                                              _2589 = dot(float3((_2539 * _2539), _2539, 1.0f), float3(mad((_11[(_2537 + 2)]), 0.5f, mad(_2544, -1.0f, _2549)), (_2544 - _2541), mad(_2544, 0.5f, _2549)));
                                            } else {
                                              do {
                                                if (!(!(_2518 >= _2528))) {
                                                  float _2558 = log2(cb0_008z);
                                                  if (_2518 < (_2558 * 0.3010300099849701f)) {
                                                    float _2566 = ((_2517 - _2527) * 0.9030900001525879f) / ((_2558 - _2527) * 0.3010300099849701f);
                                                    int _2567 = int(_2566);
                                                    float _2569 = _2566 - float(_2567);
                                                    float _2571 = _12[_2567];
                                                    float _2574 = _12[(_2567 + 1)];
                                                    float _2579 = _2571 * 0.5f;
                                                    _2589 = dot(float3((_2569 * _2569), _2569, 1.0f), float3(mad((_12[(_2567 + 2)]), 0.5f, mad(_2574, -1.0f, _2579)), (_2574 - _2571), mad(_2574, 0.5f, _2579)));
                                                    break;
                                                  }
                                                }
                                                _2589 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                          float _2605 = log2(max((lerp(_2494, _2492, 0.9599999785423279f)), 1.000000013351432e-10f));
                                          float _2606 = _2605 * 0.3010300099849701f;
                                          do {
                                            if (!(!(_2606 <= _2520))) {
                                              _2675 = (log2(cb0_008y) * 0.3010300099849701f);
                                            } else {
                                              float _2613 = log2(cb0_009x);
                                              float _2614 = _2613 * 0.3010300099849701f;
                                              if ((bool)(_2606 > _2520) && (bool)(_2606 < _2614)) {
                                                float _2622 = ((_2605 - _2519) * 0.9030900001525879f) / ((_2613 - _2519) * 0.3010300099849701f);
                                                int _2623 = int(_2622);
                                                float _2625 = _2622 - float(_2623);
                                                float _2627 = _13[_2623];
                                                float _2630 = _13[(_2623 + 1)];
                                                float _2635 = _2627 * 0.5f;
                                                _2675 = dot(float3((_2625 * _2625), _2625, 1.0f), float3(mad((_13[(_2623 + 2)]), 0.5f, mad(_2630, -1.0f, _2635)), (_2630 - _2627), mad(_2630, 0.5f, _2635)));
                                              } else {
                                                do {
                                                  if (!(!(_2606 >= _2614))) {
                                                    float _2644 = log2(cb0_008z);
                                                    if (_2606 < (_2644 * 0.3010300099849701f)) {
                                                      float _2652 = ((_2605 - _2613) * 0.9030900001525879f) / ((_2644 - _2613) * 0.3010300099849701f);
                                                      int _2653 = int(_2652);
                                                      float _2655 = _2652 - float(_2653);
                                                      float _2657 = _14[_2653];
                                                      float _2660 = _14[(_2653 + 1)];
                                                      float _2665 = _2657 * 0.5f;
                                                      _2675 = dot(float3((_2655 * _2655), _2655, 1.0f), float3(mad((_14[(_2653 + 2)]), 0.5f, mad(_2660, -1.0f, _2665)), (_2660 - _2657), mad(_2660, 0.5f, _2665)));
                                                      break;
                                                    }
                                                  }
                                                  _2675 = (log2(cb0_008w) * 0.3010300099849701f);
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
                                            float _2691 = log2(max((lerp(_2494, _2493, 0.9599999785423279f)), 1.000000013351432e-10f));
                                            float _2692 = _2691 * 0.3010300099849701f;
                                            do {
                                              if (!(!(_2692 <= _2520))) {
                                                _2761 = (log2(cb0_008y) * 0.3010300099849701f);
                                              } else {
                                                float _2699 = log2(cb0_009x);
                                                float _2700 = _2699 * 0.3010300099849701f;
                                                if ((bool)(_2692 > _2520) && (bool)(_2692 < _2700)) {
                                                  float _2708 = ((_2691 - _2519) * 0.9030900001525879f) / ((_2699 - _2519) * 0.3010300099849701f);
                                                  int _2709 = int(_2708);
                                                  float _2711 = _2708 - float(_2709);
                                                  float _2713 = _15[_2709];
                                                  float _2716 = _15[(_2709 + 1)];
                                                  float _2721 = _2713 * 0.5f;
                                                  _2761 = dot(float3((_2711 * _2711), _2711, 1.0f), float3(mad((_15[(_2709 + 2)]), 0.5f, mad(_2716, -1.0f, _2721)), (_2716 - _2713), mad(_2716, 0.5f, _2721)));
                                                } else {
                                                  do {
                                                    if (!(!(_2692 >= _2700))) {
                                                      float _2730 = log2(cb0_008z);
                                                      if (_2692 < (_2730 * 0.3010300099849701f)) {
                                                        float _2738 = ((_2691 - _2699) * 0.9030900001525879f) / ((_2730 - _2699) * 0.3010300099849701f);
                                                        int _2739 = int(_2738);
                                                        float _2741 = _2738 - float(_2739);
                                                        float _2743 = _16[_2739];
                                                        float _2746 = _16[(_2739 + 1)];
                                                        float _2751 = _2743 * 0.5f;
                                                        _2761 = dot(float3((_2741 * _2741), _2741, 1.0f), float3(mad((_16[(_2739 + 2)]), 0.5f, mad(_2746, -1.0f, _2751)), (_2746 - _2743), mad(_2746, 0.5f, _2751)));
                                                        break;
                                                      }
                                                    }
                                                    _2761 = (log2(cb0_008w) * 0.3010300099849701f);
                                                  } while (false);
                                                }
                                              }
                                              float _2765 = cb0_008w - cb0_008y;
                                              float _2766 = (exp2(_2589 * 3.321928024291992f) - cb0_008y) / _2765;
                                              float _2768 = (exp2(_2675 * 3.321928024291992f) - cb0_008y) / _2765;
                                              float _2770 = (exp2(_2761 * 3.321928024291992f) - cb0_008y) / _2765;
                                              float _2773 = mad(0.15618768334388733f, _2770, mad(0.13400420546531677f, _2768, (_2766 * 0.6624541878700256f)));
                                              float _2776 = mad(0.053689517080783844f, _2770, mad(0.6740817427635193f, _2768, (_2766 * 0.2722287178039551f)));
                                              float _2779 = mad(1.0103391408920288f, _2770, mad(0.00406073359772563f, _2768, (_2766 * -0.005574649665504694f)));
                                              float _2792 = min(max(mad(-0.23642469942569733f, _2779, mad(-0.32480329275131226f, _2776, (_2773 * 1.6410233974456787f))), 0.0f), 1.0f);
                                              float _2793 = min(max(mad(0.016756348311901093f, _2779, mad(1.6153316497802734f, _2776, (_2773 * -0.663662850856781f))), 0.0f), 1.0f);
                                              float _2794 = min(max(mad(0.9883948564529419f, _2779, mad(-0.008284442126750946f, _2776, (_2773 * 0.011721894145011902f))), 0.0f), 1.0f);
                                              float _2797 = mad(0.15618768334388733f, _2794, mad(0.13400420546531677f, _2793, (_2792 * 0.6624541878700256f)));
                                              float _2800 = mad(0.053689517080783844f, _2794, mad(0.6740817427635193f, _2793, (_2792 * 0.2722287178039551f)));
                                              float _2803 = mad(1.0103391408920288f, _2794, mad(0.00406073359772563f, _2793, (_2792 * -0.005574649665504694f)));
                                              float _2825 = min(max((min(max(mad(-0.23642469942569733f, _2803, mad(-0.32480329275131226f, _2800, (_2797 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                                              float _2828 = min(max((min(max(mad(0.016756348311901093f, _2803, mad(1.6153316497802734f, _2800, (_2797 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                              float _2829 = min(max((min(max(mad(0.9883948564529419f, _2803, mad(-0.008284442126750946f, _2800, (_2797 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                                              _2976 = mad(-0.0832589864730835f, _2829, mad(-0.6217921376228333f, _2828, (_2825 * 0.0213131383061409f)));
                                              _2977 = mad(-0.010548308491706848f, _2829, mad(1.140804648399353f, _2828, (_2825 * -0.0016282059950754046f)));
                                              _2978 = mad(1.1529725790023804f, _2829, mad(-0.1289689838886261f, _2828, (_2825 * -0.00030004189466126263f)));
                                            } while (false);
                                          } while (false);
                                        } while (false);
                                      } while (false);
                                    } while (false);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } else {
                              if ((uint)(cb0_042w) == 7) {
                                float _2856 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1346, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1345)));
                                float _2859 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1346, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1345)));
                                float _2862 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1346, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1345)));
                                float _2881 = exp2(log2(mad(_65, _2862, mad(_64, _2859, (_2856 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                float _2882 = exp2(log2(mad(_68, _2862, mad(_67, _2859, (_2856 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                float _2883 = exp2(log2(mad(_71, _2862, mad(_70, _2859, (_2856 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
                                _2976 = exp2(log2((1.0f / ((_2881 * 18.6875f) + 1.0f)) * ((_2881 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                _2977 = exp2(log2((1.0f / ((_2882 * 18.6875f) + 1.0f)) * ((_2882 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                                _2978 = exp2(log2((1.0f / ((_2883 * 18.6875f) + 1.0f)) * ((_2883 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                              } else {
                                if (!((uint)(cb0_042w) == 8)) {
                                  if ((uint)(cb0_042w) == 9) {
                                    float _2930 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1335, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1334, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1333)));
                                    float _2933 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1335, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1334, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1333)));
                                    float _2936 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1335, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1334, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1333)));
                                    _2976 = mad(_65, _2936, mad(_64, _2933, (_2930 * _63)));
                                    _2977 = mad(_68, _2936, mad(_67, _2933, (_2930 * _66)));
                                    _2978 = mad(_71, _2936, mad(_70, _2933, (_2930 * _69)));
                                  } else {
                                    float _2949 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1359)));
                                    float _2952 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1359)));
                                    float _2955 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1359)));
                                    _2976 = exp2(log2(mad(_65, _2955, mad(_64, _2952, (_2949 * _63)))) * cb0_042z);
                                    _2977 = exp2(log2(mad(_68, _2955, mad(_67, _2952, (_2949 * _66)))) * cb0_042z);
                                    _2978 = exp2(log2(mad(_71, _2955, mad(_70, _2952, (_2949 * _69)))) * cb0_042z);
                                  }
                                } else {
                                  _2976 = _1345;
                                  _2977 = _1346;
                                  _2978 = _1347;
                                }
                              }
                            }
                          }
                        }
                      }
                      u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2976 * 0.9523810148239136f), (_2977 * 0.9523810148239136f), (_2978 * 0.9523810148239136f), 0.0f);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } while (false);
    }
  }
  bool _167 = ((uint)(cb0_040w) != 0);
  float _169 = 0.9994439482688904f / cb0_037y;
  if (!(!((cb0_037y * 1.0005563497543335f) <= 7000.0f))) {
    _186 = (((((2967800.0f - (_169 * 4607000064.0f)) * _169) + 99.11000061035156f) * _169) + 0.24406300485134125f);
  } else {
    _186 = (((((1901800.0f - (_169 * 2006400000.0f)) * _169) + 247.47999572753906f) * _169) + 0.23703999817371368f);
  }
  float _200 = ((((cb0_037y * 1.2864121856637212e-07f) + 0.00015411825734190643f) * cb0_037y) + 0.8601177334785461f) / ((((cb0_037y * 7.081451371959702e-07f) + 0.0008424202096648514f) * cb0_037y) + 1.0f);
  float _207 = cb0_037y * cb0_037y;
  float _210 = ((((cb0_037y * 4.204816761443908e-08f) + 4.228062607580796e-05f) * cb0_037y) + 0.31739872694015503f) / ((1.0f - (cb0_037y * 2.8974181986995973e-05f)) + (_207 * 1.6145605741257896e-07f));
  float _215 = ((_200 * 2.0f) + 4.0f) - (_210 * 8.0f);
  float _216 = (_200 * 3.0f) / _215;
  float _218 = (_210 * 2.0f) / _215;
  bool _219 = (cb0_037y < 4000.0f);
  float _228 = ((cb0_037y + 1189.6199951171875f) * cb0_037y) + 1412139.875f;
  float _230 = ((-1137581184.0f - (cb0_037y * 1916156.25f)) - (_207 * 1.5317699909210205f)) / (_228 * _228);
  float _237 = (6193636.0f - (cb0_037y * 179.45599365234375f)) + _207;
  float _239 = ((1974715392.0f - (cb0_037y * 705674.0f)) - (_207 * 308.60699462890625f)) / (_237 * _237);
  float _241 = rsqrt(dot(float2(_230, _239), float2(_230, _239)));
  float _242 = cb0_037z * 0.05000000074505806f;
  float _245 = ((_242 * _239) * _241) + _200;
  float _248 = _210 - ((_242 * _230) * _241);
  float _253 = (4.0f - (_248 * 8.0f)) + (_245 * 2.0f);
  float _259 = (((_245 * 3.0f) / _253) - _216) + select(_219, _216, _186);
  float _260 = (((_248 * 2.0f) / _253) - _218) + select(_219, _218, (((_186 * 2.869999885559082f) + -0.2750000059604645f) - ((_186 * _186) * 3.0f)));
  float _261 = select(_167, _259, 0.3127000033855438f);
  float _262 = select(_167, _260, 0.32899999618530273f);
  float _263 = select(_167, 0.3127000033855438f, _259);
  float _264 = select(_167, 0.32899999618530273f, _260);
  float _265 = max(_262, 1.000000013351432e-10f);
  float _266 = _261 / _265;
  float _269 = ((1.0f - _261) - _262) / _265;
  float _270 = max(_264, 1.000000013351432e-10f);
  float _271 = _263 / _270;
  float _274 = ((1.0f - _263) - _264) / _270;
  float _293 = mad(-0.16140000522136688f, _274, ((_271 * 0.8950999975204468f) + 0.266400009393692f)) / mad(-0.16140000522136688f, _269, ((_266 * 0.8950999975204468f) + 0.266400009393692f));
  float _294 = mad(0.03669999912381172f, _274, (1.7135000228881836f - (_271 * 0.7501999735832214f))) / mad(0.03669999912381172f, _269, (1.7135000228881836f - (_266 * 0.7501999735832214f)));
  float _295 = mad(1.0296000242233276f, _274, ((_271 * 0.03889999911189079f) + -0.06849999725818634f)) / mad(1.0296000242233276f, _269, ((_266 * 0.03889999911189079f) + -0.06849999725818634f));
  float _296 = mad(_294, -0.7501999735832214f, 0.0f);
  float _297 = mad(_294, 1.7135000228881836f, 0.0f);
  float _298 = mad(_294, 0.03669999912381172f, -0.0f);
  float _299 = mad(_295, 0.03889999911189079f, 0.0f);
  float _300 = mad(_295, -0.06849999725818634f, 0.0f);
  float _301 = mad(_295, 1.0296000242233276f, 0.0f);
  float _304 = mad(0.1599626988172531f, _299, mad(-0.1470542997121811f, _296, (_293 * 0.883457362651825f)));
  float _307 = mad(0.1599626988172531f, _300, mad(-0.1470542997121811f, _297, (_293 * 0.26293492317199707f)));
  float _310 = mad(0.1599626988172531f, _301, mad(-0.1470542997121811f, _298, (_293 * -0.15930065512657166f)));
  float _313 = mad(0.04929120093584061f, _299, mad(0.5183603167533875f, _296, (_293 * 0.38695648312568665f)));
  float _316 = mad(0.04929120093584061f, _300, mad(0.5183603167533875f, _297, (_293 * 0.11516613513231277f)));
  float _319 = mad(0.04929120093584061f, _301, mad(0.5183603167533875f, _298, (_293 * -0.0697740763425827f)));
  float _322 = mad(0.9684867262840271f, _299, mad(0.04004279896616936f, _296, (_293 * -0.007634039502590895f)));
  float _325 = mad(0.9684867262840271f, _300, mad(0.04004279896616936f, _297, (_293 * -0.0022720457054674625f)));
  float _328 = mad(0.9684867262840271f, _301, mad(0.04004279896616936f, _298, (_293 * 0.0013765322510153055f)));
  float _331 = mad(_310, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_307, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_304 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _334 = mad(_310, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_307, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_304 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _337 = mad(_310, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_307, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_304 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _340 = mad(_319, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_316, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_313 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _343 = mad(_319, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_316, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_313 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _346 = mad(_319, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_316, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_313 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  float _349 = mad(_328, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].x), mad(_325, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].x), (_322 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].x))));
  float _352 = mad(_328, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].y), mad(_325, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].y), (_322 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].y))));
  float _355 = mad(_328, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[2].z), mad(_325, (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[1].z), (_322 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_000[0].z))));
  _393 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _355, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _346, (_337 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _131, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _352, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _343, (_334 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))), _130, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].z), _349, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].y), _340, (_331 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[0].x)))) * _129)));
  _394 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _355, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _346, (_337 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _131, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _352, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _343, (_334 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))), _130, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].z), _349, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].y), _340, (_331 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[1].x)))) * _129)));
  _395 = mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _355, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _346, (_337 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _131, mad(mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _352, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _343, (_334 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))), _130, (mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].z), _349, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].y), _340, (_331 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_064[2].x)))) * _129)));
  float _410 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _395, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _394, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _393)));
  float _413 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _395, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _394, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _393)));
  float _416 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _395, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _394, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _393)));
  float _417 = dot(float3(_410, _413, _416), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _421 = (_410 / _417) + -1.0f;
  float _422 = (_413 / _417) + -1.0f;
  float _423 = (_416 / _417) + -1.0f;

  // float _435 = (1.0f - exp2(((_417 * _417) * -4.0f) * cb0_038w)) * (1.0f - exp2(dot(float3(_421, _422, _423), float3(_421, _422, _423)) * -4.0f));
  float _435 = (1.0f - exp2(((_417 * _417) * -4.0f) * 0.f)) * (1.0f - exp2(dot(float3(_421, _422, _423), float3(_421, _422, _423)) * -4.0f));

  float _451 = ((mad(-0.06368321925401688f, _416, mad(-0.3292922377586365f, _413, (_410 * 1.3704125881195068f))) - _410) * _435) + _410;
  float _452 = ((mad(-0.010861365124583244f, _416, mad(1.0970927476882935f, _413, (_410 * -0.08343357592821121f))) - _413) * _435) + _413;
  float _453 = ((mad(1.2036951780319214f, _416, mad(-0.09862580895423889f, _413, (_410 * -0.02579331398010254f))) - _416) * _435) + _416;
  float _454 = dot(float3(_451, _452, _453), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _468 = cb0_021w + cb0_026w;
  float _482 = cb0_020w * cb0_025w;
  float _496 = cb0_019w * cb0_024w;
  float _510 = cb0_018w * cb0_023w;
  float _524 = cb0_017w * cb0_022w;
  float _528 = _451 - _454;
  float _529 = _452 - _454;
  float _530 = _453 - _454;
  float _587 = saturate(_454 / cb0_037w);
  float _591 = (_587 * _587) * (3.0f - (_587 * 2.0f));
  float _592 = 1.0f - _591;
  float _601 = cb0_021w + cb0_036w;
  float _610 = cb0_020w * cb0_035w;
  float _619 = cb0_019w * cb0_034w;
  float _628 = cb0_018w * cb0_033w;
  float _637 = cb0_017w * cb0_032w;
  float _700 = saturate((_454 - cb0_038x) / (cb0_038y - cb0_038x));
  float _704 = (_700 * _700) * (3.0f - (_700 * 2.0f));
  float _713 = cb0_021w + cb0_031w;
  float _722 = cb0_020w * cb0_030w;
  float _731 = cb0_019w * cb0_029w;
  float _740 = cb0_018w * cb0_028w;
  float _749 = cb0_017w * cb0_027w;
  float _807 = _591 - _704;
  float _818 = ((_704 * (((cb0_021x + cb0_036x) + _601) + (((cb0_020x * cb0_035x) * _610) * exp2(log2(exp2(((cb0_018x * cb0_033x) * _628) * log2(max(0.0f, ((((cb0_017x * cb0_032x) * _637) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_034x) * _619)))))) + (_592 * (((cb0_021x + cb0_026x) + _468) + (((cb0_020x * cb0_025x) * _482) * exp2(log2(exp2(((cb0_018x * cb0_023x) * _510) * log2(max(0.0f, ((((cb0_017x * cb0_022x) * _524) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_024x) * _496))))))) + ((((cb0_021x + cb0_031x) + _713) + (((cb0_020x * cb0_030x) * _722) * exp2(log2(exp2(((cb0_018x * cb0_028x) * _740) * log2(max(0.0f, ((((cb0_017x * cb0_027x) * _749) * _528) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019x * cb0_029x) * _731))))) * _807);
  float _820 = ((_704 * (((cb0_021y + cb0_036y) + _601) + (((cb0_020y * cb0_035y) * _610) * exp2(log2(exp2(((cb0_018y * cb0_033y) * _628) * log2(max(0.0f, ((((cb0_017y * cb0_032y) * _637) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_034y) * _619)))))) + (_592 * (((cb0_021y + cb0_026y) + _468) + (((cb0_020y * cb0_025y) * _482) * exp2(log2(exp2(((cb0_018y * cb0_023y) * _510) * log2(max(0.0f, ((((cb0_017y * cb0_022y) * _524) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_024y) * _496))))))) + ((((cb0_021y + cb0_031y) + _713) + (((cb0_020y * cb0_030y) * _722) * exp2(log2(exp2(((cb0_018y * cb0_028y) * _740) * log2(max(0.0f, ((((cb0_017y * cb0_027y) * _749) * _529) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019y * cb0_029y) * _731))))) * _807);
  float _822 = ((_704 * (((cb0_021z + cb0_036z) + _601) + (((cb0_020z * cb0_035z) * _610) * exp2(log2(exp2(((cb0_018z * cb0_033z) * _628) * log2(max(0.0f, ((((cb0_017z * cb0_032z) * _637) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_034z) * _619)))))) + (_592 * (((cb0_021z + cb0_026z) + _468) + (((cb0_020z * cb0_025z) * _482) * exp2(log2(exp2(((cb0_018z * cb0_023z) * _510) * log2(max(0.0f, ((((cb0_017z * cb0_022z) * _524) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_024z) * _496))))))) + ((((cb0_021z + cb0_031z) + _713) + (((cb0_020z * cb0_030z) * _722) * exp2(log2(exp2(((cb0_018z * cb0_028z) * _740) * log2(max(0.0f, ((((cb0_017z * cb0_027z) * _749) * _530) + _454)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_019z * cb0_029z) * _731))))) * _807);

  UECbufferConfig cb_config = CreateCbufferConfig();
  cb_config.ue_filmblackclip = cb0_040x;
  cb_config.ue_filmtoe = cb0_039z;
  cb_config.ue_filmshoulder = cb0_039w;
  cb_config.ue_filmslope = cb0_039y;
  cb_config.ue_filmwhiteclip = cb0_040y;
  cb_config.ue_tonecurveammount = cb0_039x;
  cb_config.ue_mappingpolynomial = float3(cb0_041x, cb0_041y, cb0_041z);
  cb_config.ue_overlaycolor = float4(cb0_015x, cb0_015y, cb0_015z, cb0_015w);
  cb_config.ue_bluecorrection = cb0_038z;
  cb_config.ue_colorscale = float3(cb0_016x, cb0_016y, cb0_016z);
  float4 lutweights[2] = { float4(cb0_005x, cb0_005y, 0.f, 0.f), float4(0.f, 0.f, 0.f, 0.f) };
  cb_config.ue_lutweights = lutweights;  // Only Lutweights[0].xy is used

  float4 output = ProcessLutbuilder(float3(_818, _820, _822), s0, t0, cb_config, u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))], cb0_040w);
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = output;
  return;

  float _858 = ((mad(0.061360642313957214f, _822, mad(-4.540197551250458e-09f, _820, (_818 * 0.9386394023895264f))) - _818) * cb0_038z) + _818;
  float _859 = ((mad(0.169205904006958f, _822, mad(0.8307942152023315f, _820, (_818 * 6.775371730327606e-08f))) - _820) * cb0_038z) + _820;
  float _860 = (mad(-2.3283064365386963e-10f, _820, (_818 * -9.313225746154785e-10f)) * cb0_038z) + _822;
  float _863 = mad(0.16386905312538147f, _860, mad(0.14067868888378143f, _859, (_858 * 0.6954522132873535f)));
  float _866 = mad(0.0955343246459961f, _860, mad(0.8596711158752441f, _859, (_858 * 0.044794581830501556f)));
  float _869 = mad(1.0015007257461548f, _860, mad(0.004025210160762072f, _859, (_858 * -0.005525882821530104f)));
  float _873 = max(max(_863, _866), _869);
  float _878 = (max(_873, 1.000000013351432e-10f) - max(min(min(_863, _866), _869), 1.000000013351432e-10f)) / max(_873, 0.009999999776482582f);
  float _891 = ((_866 + _863) + _869) + (sqrt((((_869 - _866) * _869) + ((_866 - _863) * _866)) + ((_863 - _869) * _863)) * 1.75f);
  float _892 = _891 * 0.3333333432674408f;
  float _893 = _878 + -0.4000000059604645f;
  float _894 = _893 * 5.0f;
  float _898 = max((1.0f - abs(_893 * 2.5f)), 0.0f);
  float _909 = ((float(((int)(uint)((bool)(_894 > 0.0f))) - ((int)(uint)((bool)(_894 < 0.0f)))) * (1.0f - (_898 * _898))) + 1.0f) * 0.02500000037252903f;
  if (!(_892 <= 0.0533333346247673f)) {
    if (!(_892 >= 0.1599999964237213f)) {
      _918 = (((0.23999999463558197f / _891) + -0.5f) * _909);
    } else {
      _918 = 0.0f;
    }
  } else {
    _918 = _909;
  }
  float _919 = _918 + 1.0f;
  float _920 = _919 * _863;
  float _921 = _919 * _866;
  float _922 = _919 * _869;
  if (!((bool)(_920 == _921) && (bool)(_921 == _922))) {
    float _929 = ((_920 * 2.0f) - _921) - _922;
    float _932 = ((_866 - _869) * 1.7320507764816284f) * _919;
    float _934 = atan(_932 / _929);
    bool _937 = (_929 < 0.0f);
    bool _938 = (_929 == 0.0f);
    bool _939 = (_932 >= 0.0f);
    bool _940 = (_932 < 0.0f);
    _951 = select((_939 && _938), 90.0f, select((_940 && _938), -90.0f, (select((_940 && _937), (_934 + -3.1415927410125732f), select((_939 && _937), (_934 + 3.1415927410125732f), _934)) * 57.2957763671875f)));
  } else {
    _951 = 0.0f;
  }
  float _956 = min(max(select((_951 < 0.0f), (_951 + 360.0f), _951), 0.0f), 360.0f);
  if (_956 < -180.0f) {
    _965 = (_956 + 360.0f);
  } else {
    if (_956 > 180.0f) {
      _965 = (_956 + -360.0f);
    } else {
      _965 = _956;
    }
  }
  float _969 = saturate(1.0f - abs(_965 * 0.014814814552664757f));
  float _973 = (_969 * _969) * (3.0f - (_969 * 2.0f));
  float _979 = ((_973 * _973) * ((_878 * 0.18000000715255737f) * (0.029999999329447746f - _920))) + _920;
  float _989 = max(0.0f, mad(-0.21492856740951538f, _922, mad(-0.2365107536315918f, _921, (_979 * 1.4514392614364624f))));
  float _990 = max(0.0f, mad(-0.09967592358589172f, _922, mad(1.17622971534729f, _921, (_979 * -0.07655377686023712f))));
  float _991 = max(0.0f, mad(0.9977163076400757f, _922, mad(-0.006032449658960104f, _921, (_979 * 0.008316148072481155f))));
  float _992 = dot(float3(_989, _990, _991), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1007 = (cb0_040x + 1.0f) - cb0_039z;
  float _1009 = cb0_040y + 1.0f;
  float _1011 = _1009 - cb0_039w;
  if (cb0_039z > 0.800000011920929f) {
    _1029 = (((0.8199999928474426f - cb0_039z) / cb0_039y) + -0.7447274923324585f);
  } else {
    float _1020 = (cb0_040x + 0.18000000715255737f) / _1007;
    _1029 = (-0.7447274923324585f - ((log2(_1020 / (2.0f - _1020)) * 0.3465735912322998f) * (_1007 / cb0_039y)));
  }
  float _1032 = ((1.0f - cb0_039z) / cb0_039y) - _1029;
  float _1034 = (cb0_039w / cb0_039y) - _1032;
  float _1038 = log2(lerp(_992, _989, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1039 = log2(lerp(_992, _990, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1040 = log2(lerp(_992, _991, 0.9599999785423279f)) * 0.3010300099849701f;
  float _1044 = cb0_039y * (_1038 + _1032);
  float _1045 = cb0_039y * (_1039 + _1032);
  float _1046 = cb0_039y * (_1040 + _1032);
  float _1047 = _1007 * 2.0f;
  float _1049 = (cb0_039y * -2.0f) / _1007;
  float _1050 = _1038 - _1029;
  float _1051 = _1039 - _1029;
  float _1052 = _1040 - _1029;
  float _1071 = _1011 * 2.0f;
  float _1073 = (cb0_039y * 2.0f) / _1011;
  float _1098 = select((_1038 < _1029), ((_1047 / (exp2((_1050 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1044);
  float _1099 = select((_1039 < _1029), ((_1047 / (exp2((_1051 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1045);
  float _1100 = select((_1040 < _1029), ((_1047 / (exp2((_1052 * 1.4426950216293335f) * _1049) + 1.0f)) - cb0_040x), _1046);
  float _1107 = _1034 - _1029;
  float _1111 = saturate(_1050 / _1107);
  float _1112 = saturate(_1051 / _1107);
  float _1113 = saturate(_1052 / _1107);
  bool _1114 = (_1034 < _1029);
  float _1118 = select(_1114, (1.0f - _1111), _1111);
  float _1119 = select(_1114, (1.0f - _1112), _1112);
  float _1120 = select(_1114, (1.0f - _1113), _1113);
  float _1139 = (((_1118 * _1118) * (select((_1038 > _1034), (_1009 - (_1071 / (exp2(((_1038 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1044) - _1098)) * (3.0f - (_1118 * 2.0f))) + _1098;
  float _1140 = (((_1119 * _1119) * (select((_1039 > _1034), (_1009 - (_1071 / (exp2(((_1039 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1045) - _1099)) * (3.0f - (_1119 * 2.0f))) + _1099;
  float _1141 = (((_1120 * _1120) * (select((_1040 > _1034), (_1009 - (_1071 / (exp2(((_1040 - _1034) * 1.4426950216293335f) * _1073) + 1.0f))), _1046) - _1100)) * (3.0f - (_1120 * 2.0f))) + _1100;
  float _1142 = dot(float3(_1139, _1140, _1141), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _1162 = (cb0_039x * (max(0.0f, (lerp(_1142, _1139, 0.9300000071525574f))) - _858)) + _858;
  float _1163 = (cb0_039x * (max(0.0f, (lerp(_1142, _1140, 0.9300000071525574f))) - _859)) + _859;
  float _1164 = (cb0_039x * (max(0.0f, (lerp(_1142, _1141, 0.9300000071525574f))) - _860)) + _860;
  float _1180 = ((mad(-0.06537103652954102f, _1164, mad(1.451815478503704e-06f, _1163, (_1162 * 1.065374732017517f))) - _1162) * cb0_038z) + _1162;
  float _1181 = ((mad(-0.20366770029067993f, _1164, mad(1.2036634683609009f, _1163, (_1162 * -2.57161445915699e-07f))) - _1163) * cb0_038z) + _1163;
  float _1182 = ((mad(0.9999996423721313f, _1164, mad(2.0954757928848267e-08f, _1163, (_1162 * 1.862645149230957e-08f))) - _1164) * cb0_038z) + _1164;
  float _1195 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _1182, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _1181, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x) * _1180)))));
  float _1196 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _1182, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _1181, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _1180)))));
  float _1197 = saturate(max(0.0f, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _1182, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _1181, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _1180)))));
  if (_1195 < 0.0031306699384003878f) {
    _1208 = (_1195 * 12.920000076293945f);
  } else {
    _1208 = (((pow(_1195, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1196 < 0.0031306699384003878f) {
    _1219 = (_1196 * 12.920000076293945f);
  } else {
    _1219 = (((pow(_1196, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_1197 < 0.0031306699384003878f) {
    _1230 = (_1197 * 12.920000076293945f);
  } else {
    _1230 = (((pow(_1197, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _1234 = (_1219 * 0.9375f) + 0.03125f;
  float _1241 = _1230 * 15.0f;
  float _1242 = floor(_1241);
  float _1243 = _1241 - _1242;
  float _1245 = (((_1208 * 0.9375f) + 0.03125f) + _1242) * 0.0625f;
  float4 _1248 = t0.SampleLevel(s0, float2(_1245, _1234), 0.0f);
  float4 _1253 = t0.SampleLevel(s0, float2((_1245 + 0.0625f), _1234), 0.0f);
  float _1269 = ((lerp(_1248.x, _1253.x, _1243)) * cb0_005y) + (cb0_005x * _1208);
  float _1270 = ((lerp(_1248.y, _1253.y, _1243)) * cb0_005y) + (cb0_005x * _1219);
  float _1271 = ((lerp(_1248.z, _1253.z, _1243)) * cb0_005y) + (cb0_005x * _1230);
  float _1296 = select((_1269 > 0.040449999272823334f), exp2(log2((abs(_1269) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1269 * 0.07739938050508499f));
  float _1297 = select((_1270 > 0.040449999272823334f), exp2(log2((abs(_1270) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1270 * 0.07739938050508499f));
  float _1298 = select((_1271 > 0.040449999272823334f), exp2(log2((abs(_1271) * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1271 * 0.07739938050508499f));
  float _1324 = cb0_016x * (((cb0_041y + (cb0_041x * _1296)) * _1296) + cb0_041z);
  float _1325 = cb0_016y * (((cb0_041y + (cb0_041x * _1297)) * _1297) + cb0_041z);
  float _1326 = cb0_016z * (((cb0_041y + (cb0_041x * _1298)) * _1298) + cb0_041z);
  float _1333 = ((cb0_015x - _1324) * cb0_015w) + _1324;
  float _1334 = ((cb0_015y - _1325) * cb0_015w) + _1325;
  float _1335 = ((cb0_015z - _1326) * cb0_015w) + _1326;
  float _1336 = cb0_016x * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].z), _822, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].y), _820, (_818 * (WorkingColorSpace_000.FWorkingColorSpaceConstants_192[0].x))));
  float _1337 = cb0_016y * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].z), _822, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].y), _820, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[1].x) * _818)));
  float _1338 = cb0_016z * mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].z), _822, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].y), _820, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_192[2].x) * _818)));
  float _1345 = ((cb0_015x - _1336) * cb0_015w) + _1336;
  float _1346 = ((cb0_015y - _1337) * cb0_015w) + _1337;
  float _1347 = ((cb0_015z - _1338) * cb0_015w) + _1338;
  float _1359 = exp2(log2(max(0.0f, _1333)) * cb0_042y);
  float _1360 = exp2(log2(max(0.0f, _1334)) * cb0_042y);
  float _1361 = exp2(log2(max(0.0f, _1335)) * cb0_042y);
  [branch]
  if ((uint)(cb0_042w) == 0) {
    do {
      if ((uint)(WorkingColorSpace_000.FWorkingColorSpaceConstants_384) == 0) {
        float _1384 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1359)));
        float _1387 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1359)));
        float _1390 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1359)));
        _1401 = mad(_65, _1390, mad(_64, _1387, (_1384 * _63)));
        _1402 = mad(_68, _1390, mad(_67, _1387, (_1384 * _66)));
        _1403 = mad(_71, _1390, mad(_70, _1387, (_1384 * _69)));
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
            _2976 = _1414;
            _2977 = _1425;
            _2978 = (_1403 * 12.920000076293945f);
          } else {
            _2976 = _1414;
            _2977 = _1425;
            _2978 = (((pow(_1403, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if ((uint)(cb0_042w) == 1) {
      float _1452 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1359)));
      float _1455 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1359)));
      float _1458 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1359)));
      float _1461 = mad(_65, _1458, mad(_64, _1455, (_1452 * _63)));
      float _1464 = mad(_68, _1458, mad(_67, _1455, (_1452 * _66)));
      float _1467 = mad(_71, _1458, mad(_70, _1455, (_1452 * _69)));
      _2976 = min((_1461 * 4.5f), ((exp2(log2(max(_1461, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2977 = min((_1464 * 4.5f), ((exp2(log2(max(_1464, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2978 = min((_1467 * 4.5f), ((exp2(log2(max(_1467, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((uint)((uint)(cb0_042w + -3u)) < (uint)2) {
        float _1530 = cb0_012z * _1345;
        float _1531 = cb0_012z * _1346;
        float _1532 = cb0_012z * _1347;
        float _1535 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _1532, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _1531, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _1530)));
        float _1538 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _1532, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _1531, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _1530)));
        float _1541 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _1532, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _1531, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _1530)));
        float _1544 = mad(-0.21492856740951538f, _1541, mad(-0.2365107536315918f, _1538, (_1535 * 1.4514392614364624f)));
        float _1547 = mad(-0.09967592358589172f, _1541, mad(1.17622971534729f, _1538, (_1535 * -0.07655377686023712f)));
        float _1550 = mad(0.9977163076400757f, _1541, mad(-0.006032449658960104f, _1538, (_1535 * 0.008316148072481155f)));
        float _1552 = max(_1544, max(_1547, _1550));
        do {
          if (!(_1552 < 1.000000013351432e-10f)) {
            if (!(((bool)((bool)(_1535 < 0.0f) || (bool)(_1538 < 0.0f))) || (bool)(_1541 < 0.0f))) {
              float _1562 = abs(_1552);
              float _1563 = (_1552 - _1544) / _1562;
              float _1565 = (_1552 - _1547) / _1562;
              float _1567 = (_1552 - _1550) / _1562;
              do {
                if (!(_1563 < 0.8149999976158142f)) {
                  float _1570 = _1563 + -0.8149999976158142f;
                  _1582 = ((_1570 / exp2(log2(exp2(log2(_1570 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                } else {
                  _1582 = _1563;
                }
                do {
                  if (!(_1565 < 0.8029999732971191f)) {
                    float _1585 = _1565 + -0.8029999732971191f;
                    _1597 = ((_1585 / exp2(log2(exp2(log2(_1585 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                  } else {
                    _1597 = _1565;
                  }
                  do {
                    if (!(_1567 < 0.8799999952316284f)) {
                      float _1600 = _1567 + -0.8799999952316284f;
                      _1612 = ((_1600 / exp2(log2(exp2(log2(_1600 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                    } else {
                      _1612 = _1567;
                    }
                    _1620 = (_1552 - (_1562 * _1582));
                    _1621 = (_1552 - (_1562 * _1597));
                    _1622 = (_1552 - (_1562 * _1612));
                  } while (false);
                } while (false);
              } while (false);
            } else {
              _1620 = _1544;
              _1621 = _1547;
              _1622 = _1550;
            }
          } else {
            _1620 = _1544;
            _1621 = _1547;
            _1622 = _1550;
          }
          float _1638 = ((mad(0.16386906802654266f, _1622, mad(0.14067870378494263f, _1621, (_1620 * 0.6954522132873535f))) - _1535) * cb0_012w) + _1535;
          float _1639 = ((mad(0.0955343171954155f, _1622, mad(0.8596711158752441f, _1621, (_1620 * 0.044794563204050064f))) - _1538) * cb0_012w) + _1538;
          float _1640 = ((mad(1.0015007257461548f, _1622, mad(0.004025210160762072f, _1621, (_1620 * -0.005525882821530104f))) - _1541) * cb0_012w) + _1541;
          float _1644 = max(max(_1638, _1639), _1640);
          float _1649 = (max(_1644, 1.000000013351432e-10f) - max(min(min(_1638, _1639), _1640), 1.000000013351432e-10f)) / max(_1644, 0.009999999776482582f);
          float _1662 = ((_1639 + _1638) + _1640) + (sqrt((((_1640 - _1639) * _1640) + ((_1639 - _1638) * _1639)) + ((_1638 - _1640) * _1638)) * 1.75f);
          float _1663 = _1662 * 0.3333333432674408f;
          float _1664 = _1649 + -0.4000000059604645f;
          float _1665 = _1664 * 5.0f;
          float _1669 = max((1.0f - abs(_1664 * 2.5f)), 0.0f);
          float _1680 = ((float(((int)(uint)((bool)(_1665 > 0.0f))) - ((int)(uint)((bool)(_1665 < 0.0f)))) * (1.0f - (_1669 * _1669))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1663 <= 0.0533333346247673f)) {
              if (!(_1663 >= 0.1599999964237213f)) {
                _1689 = (((0.23999999463558197f / _1662) + -0.5f) * _1680);
              } else {
                _1689 = 0.0f;
              }
            } else {
              _1689 = _1680;
            }
            float _1690 = _1689 + 1.0f;
            float _1691 = _1690 * _1638;
            float _1692 = _1690 * _1639;
            float _1693 = _1690 * _1640;
            do {
              if (!((bool)(_1691 == _1692) && (bool)(_1692 == _1693))) {
                float _1700 = ((_1691 * 2.0f) - _1692) - _1693;
                float _1703 = ((_1639 - _1640) * 1.7320507764816284f) * _1690;
                float _1705 = atan(_1703 / _1700);
                bool _1708 = (_1700 < 0.0f);
                bool _1709 = (_1700 == 0.0f);
                bool _1710 = (_1703 >= 0.0f);
                bool _1711 = (_1703 < 0.0f);
                _1722 = select((_1710 && _1709), 90.0f, select((_1711 && _1709), -90.0f, (select((_1711 && _1708), (_1705 + -3.1415927410125732f), select((_1710 && _1708), (_1705 + 3.1415927410125732f), _1705)) * 57.2957763671875f)));
              } else {
                _1722 = 0.0f;
              }
              float _1727 = min(max(select((_1722 < 0.0f), (_1722 + 360.0f), _1722), 0.0f), 360.0f);
              do {
                if (_1727 < -180.0f) {
                  _1736 = (_1727 + 360.0f);
                } else {
                  if (_1727 > 180.0f) {
                    _1736 = (_1727 + -360.0f);
                  } else {
                    _1736 = _1727;
                  }
                }
                do {
                  if ((bool)(_1736 > -67.5f) && (bool)(_1736 < 67.5f)) {
                    float _1742 = (_1736 + 67.5f) * 0.029629629105329514f;
                    int _1743 = int(_1742);
                    float _1745 = _1742 - float(_1743);
                    float _1746 = _1745 * _1745;
                    float _1747 = _1746 * _1745;
                    if (_1743 == 3) {
                      _1775 = (((0.1666666716337204f - (_1745 * 0.5f)) + (_1746 * 0.5f)) - (_1747 * 0.1666666716337204f));
                    } else {
                      if (_1743 == 2) {
                        _1775 = ((0.6666666865348816f - _1746) + (_1747 * 0.5f));
                      } else {
                        if (_1743 == 1) {
                          _1775 = (((_1747 * -0.5f) + 0.1666666716337204f) + ((_1746 + _1745) * 0.5f));
                        } else {
                          _1775 = select((_1743 == 0), (_1747 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _1775 = 0.0f;
                  }
                  float _1784 = min(max(((((_1649 * 0.27000001072883606f) * (0.029999999329447746f - _1691)) * _1775) + _1691), 0.0f), 65535.0f);
                  float _1785 = min(max(_1692, 0.0f), 65535.0f);
                  float _1786 = min(max(_1693, 0.0f), 65535.0f);
                  float _1799 = min(max(mad(-0.21492856740951538f, _1786, mad(-0.2365107536315918f, _1785, (_1784 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _1800 = min(max(mad(-0.09967592358589172f, _1786, mad(1.17622971534729f, _1785, (_1784 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _1801 = min(max(mad(0.9977163076400757f, _1786, mad(-0.006032449658960104f, _1785, (_1784 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _1802 = dot(float3(_1799, _1800, _1801), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                  float _1825 = log2(max((lerp(_1802, _1799, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1826 = _1825 * 0.3010300099849701f;
                  float _1827 = log2(cb0_008x);
                  float _1828 = _1827 * 0.3010300099849701f;
                  do {
                    if (!(!(_1826 <= _1828))) {
                      _1897 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1835 = log2(cb0_009x);
                      float _1836 = _1835 * 0.3010300099849701f;
                      if ((bool)(_1826 > _1828) && (bool)(_1826 < _1836)) {
                        float _1844 = ((_1825 - _1827) * 0.9030900001525879f) / ((_1835 - _1827) * 0.3010300099849701f);
                        int _1845 = int(_1844);
                        float _1847 = _1844 - float(_1845);
                        float _1849 = _17[_1845];
                        float _1852 = _17[(_1845 + 1)];
                        float _1857 = _1849 * 0.5f;
                        _1897 = dot(float3((_1847 * _1847), _1847, 1.0f), float3(mad((_17[(_1845 + 2)]), 0.5f, mad(_1852, -1.0f, _1857)), (_1852 - _1849), mad(_1852, 0.5f, _1857)));
                      } else {
                        do {
                          if (!(!(_1826 >= _1836))) {
                            float _1866 = log2(cb0_008z);
                            if (_1826 < (_1866 * 0.3010300099849701f)) {
                              float _1874 = ((_1825 - _1835) * 0.9030900001525879f) / ((_1866 - _1835) * 0.3010300099849701f);
                              int _1875 = int(_1874);
                              float _1877 = _1874 - float(_1875);
                              float _1879 = _18[_1875];
                              float _1882 = _18[(_1875 + 1)];
                              float _1887 = _1879 * 0.5f;
                              _1897 = dot(float3((_1877 * _1877), _1877, 1.0f), float3(mad((_18[(_1875 + 2)]), 0.5f, mad(_1882, -1.0f, _1887)), (_1882 - _1879), mad(_1882, 0.5f, _1887)));
                              break;
                            }
                          }
                          _1897 = (log2(cb0_008w) * 0.3010300099849701f);
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
                    float _1913 = log2(max((lerp(_1802, _1800, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1914 = _1913 * 0.3010300099849701f;
                    do {
                      if (!(!(_1914 <= _1828))) {
                        _1983 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1921 = log2(cb0_009x);
                        float _1922 = _1921 * 0.3010300099849701f;
                        if ((bool)(_1914 > _1828) && (bool)(_1914 < _1922)) {
                          float _1930 = ((_1913 - _1827) * 0.9030900001525879f) / ((_1921 - _1827) * 0.3010300099849701f);
                          int _1931 = int(_1930);
                          float _1933 = _1930 - float(_1931);
                          float _1935 = _19[_1931];
                          float _1938 = _19[(_1931 + 1)];
                          float _1943 = _1935 * 0.5f;
                          _1983 = dot(float3((_1933 * _1933), _1933, 1.0f), float3(mad((_19[(_1931 + 2)]), 0.5f, mad(_1938, -1.0f, _1943)), (_1938 - _1935), mad(_1938, 0.5f, _1943)));
                        } else {
                          do {
                            if (!(!(_1914 >= _1922))) {
                              float _1952 = log2(cb0_008z);
                              if (_1914 < (_1952 * 0.3010300099849701f)) {
                                float _1960 = ((_1913 - _1921) * 0.9030900001525879f) / ((_1952 - _1921) * 0.3010300099849701f);
                                int _1961 = int(_1960);
                                float _1963 = _1960 - float(_1961);
                                float _1965 = _20[_1961];
                                float _1968 = _20[(_1961 + 1)];
                                float _1973 = _1965 * 0.5f;
                                _1983 = dot(float3((_1963 * _1963), _1963, 1.0f), float3(mad((_20[(_1961 + 2)]), 0.5f, mad(_1968, -1.0f, _1973)), (_1968 - _1965), mad(_1968, 0.5f, _1973)));
                                break;
                              }
                            }
                            _1983 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _1999 = log2(max((lerp(_1802, _1801, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2000 = _1999 * 0.3010300099849701f;
                      do {
                        if (!(!(_2000 <= _1828))) {
                          _2069 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2007 = log2(cb0_009x);
                          float _2008 = _2007 * 0.3010300099849701f;
                          if ((bool)(_2000 > _1828) && (bool)(_2000 < _2008)) {
                            float _2016 = ((_1999 - _1827) * 0.9030900001525879f) / ((_2007 - _1827) * 0.3010300099849701f);
                            int _2017 = int(_2016);
                            float _2019 = _2016 - float(_2017);
                            float _2021 = _21[_2017];
                            float _2024 = _21[(_2017 + 1)];
                            float _2029 = _2021 * 0.5f;
                            _2069 = dot(float3((_2019 * _2019), _2019, 1.0f), float3(mad((_21[(_2017 + 2)]), 0.5f, mad(_2024, -1.0f, _2029)), (_2024 - _2021), mad(_2024, 0.5f, _2029)));
                          } else {
                            do {
                              if (!(!(_2000 >= _2008))) {
                                float _2038 = log2(cb0_008z);
                                if (_2000 < (_2038 * 0.3010300099849701f)) {
                                  float _2046 = ((_1999 - _2007) * 0.9030900001525879f) / ((_2038 - _2007) * 0.3010300099849701f);
                                  int _2047 = int(_2046);
                                  float _2049 = _2046 - float(_2047);
                                  float _2051 = _22[_2047];
                                  float _2054 = _22[(_2047 + 1)];
                                  float _2059 = _2051 * 0.5f;
                                  _2069 = dot(float3((_2049 * _2049), _2049, 1.0f), float3(mad((_22[(_2047 + 2)]), 0.5f, mad(_2054, -1.0f, _2059)), (_2054 - _2051), mad(_2054, 0.5f, _2059)));
                                  break;
                                }
                              }
                              _2069 = (log2(cb0_008w) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2073 = cb0_008w - cb0_008y;
                        float _2074 = (exp2(_1897 * 3.321928024291992f) - cb0_008y) / _2073;
                        float _2076 = (exp2(_1983 * 3.321928024291992f) - cb0_008y) / _2073;
                        float _2078 = (exp2(_2069 * 3.321928024291992f) - cb0_008y) / _2073;
                        float _2081 = mad(0.15618768334388733f, _2078, mad(0.13400420546531677f, _2076, (_2074 * 0.6624541878700256f)));
                        float _2084 = mad(0.053689517080783844f, _2078, mad(0.6740817427635193f, _2076, (_2074 * 0.2722287178039551f)));
                        float _2087 = mad(1.0103391408920288f, _2078, mad(0.00406073359772563f, _2076, (_2074 * -0.005574649665504694f)));
                        float _2100 = min(max(mad(-0.23642469942569733f, _2087, mad(-0.32480329275131226f, _2084, (_2081 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2101 = min(max(mad(0.016756348311901093f, _2087, mad(1.6153316497802734f, _2084, (_2081 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2102 = min(max(mad(0.9883948564529419f, _2087, mad(-0.008284442126750946f, _2084, (_2081 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2105 = mad(0.15618768334388733f, _2102, mad(0.13400420546531677f, _2101, (_2100 * 0.6624541878700256f)));
                        float _2108 = mad(0.053689517080783844f, _2102, mad(0.6740817427635193f, _2101, (_2100 * 0.2722287178039551f)));
                        float _2111 = mad(1.0103391408920288f, _2102, mad(0.00406073359772563f, _2101, (_2100 * -0.005574649665504694f)));
                        float _2133 = min(max((min(max(mad(-0.23642469942569733f, _2111, mad(-0.32480329275131226f, _2108, (_2105 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2134 = min(max((min(max(mad(0.016756348311901093f, _2111, mad(1.6153316497802734f, _2108, (_2105 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2135 = min(max((min(max(mad(0.9883948564529419f, _2111, mad(-0.008284442126750946f, _2108, (_2105 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2154 = exp2(log2(mad(_65, _2135, mad(_64, _2134, (_2133 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2155 = exp2(log2(mad(_68, _2135, mad(_67, _2134, (_2133 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _2156 = exp2(log2(mad(_71, _2135, mad(_70, _2134, (_2133 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2976 = exp2(log2((1.0f / ((_2154 * 18.6875f) + 1.0f)) * ((_2154 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2977 = exp2(log2((1.0f / ((_2155 * 18.6875f) + 1.0f)) * ((_2155 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2978 = exp2(log2((1.0f / ((_2156 * 18.6875f) + 1.0f)) * ((_2156 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((uint)((uint)(cb0_042w + -5u)) < (uint)2) {
          float _2222 = cb0_012z * _1345;
          float _2223 = cb0_012z * _1346;
          float _2224 = cb0_012z * _1347;
          float _2227 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].z), _2224, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].y), _2223, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[0].x) * _2222)));
          float _2230 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].z), _2224, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].y), _2223, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[1].x) * _2222)));
          float _2233 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].z), _2224, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].y), _2223, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_256[2].x) * _2222)));
          float _2236 = mad(-0.21492856740951538f, _2233, mad(-0.2365107536315918f, _2230, (_2227 * 1.4514392614364624f)));
          float _2239 = mad(-0.09967592358589172f, _2233, mad(1.17622971534729f, _2230, (_2227 * -0.07655377686023712f)));
          float _2242 = mad(0.9977163076400757f, _2233, mad(-0.006032449658960104f, _2230, (_2227 * 0.008316148072481155f)));
          float _2244 = max(_2236, max(_2239, _2242));
          do {
            if (!(_2244 < 1.000000013351432e-10f)) {
              if (!(((bool)((bool)(_2227 < 0.0f) || (bool)(_2230 < 0.0f))) || (bool)(_2233 < 0.0f))) {
                float _2254 = abs(_2244);
                float _2255 = (_2244 - _2236) / _2254;
                float _2257 = (_2244 - _2239) / _2254;
                float _2259 = (_2244 - _2242) / _2254;
                do {
                  if (!(_2255 < 0.8149999976158142f)) {
                    float _2262 = _2255 + -0.8149999976158142f;
                    _2274 = ((_2262 / exp2(log2(exp2(log2(_2262 * 3.0552830696105957f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8149999976158142f);
                  } else {
                    _2274 = _2255;
                  }
                  do {
                    if (!(_2257 < 0.8029999732971191f)) {
                      float _2277 = _2257 + -0.8029999732971191f;
                      _2289 = ((_2277 / exp2(log2(exp2(log2(_2277 * 3.4972610473632812f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8029999732971191f);
                    } else {
                      _2289 = _2257;
                    }
                    do {
                      if (!(_2259 < 0.8799999952316284f)) {
                        float _2292 = _2259 + -0.8799999952316284f;
                        _2304 = ((_2292 / exp2(log2(exp2(log2(_2292 * 6.810994625091553f) * 1.2000000476837158f) + 1.0f) * 0.8333333134651184f)) + 0.8799999952316284f);
                      } else {
                        _2304 = _2259;
                      }
                      _2312 = (_2244 - (_2254 * _2274));
                      _2313 = (_2244 - (_2254 * _2289));
                      _2314 = (_2244 - (_2254 * _2304));
                    } while (false);
                  } while (false);
                } while (false);
              } else {
                _2312 = _2236;
                _2313 = _2239;
                _2314 = _2242;
              }
            } else {
              _2312 = _2236;
              _2313 = _2239;
              _2314 = _2242;
            }
            float _2330 = ((mad(0.16386906802654266f, _2314, mad(0.14067870378494263f, _2313, (_2312 * 0.6954522132873535f))) - _2227) * cb0_012w) + _2227;
            float _2331 = ((mad(0.0955343171954155f, _2314, mad(0.8596711158752441f, _2313, (_2312 * 0.044794563204050064f))) - _2230) * cb0_012w) + _2230;
            float _2332 = ((mad(1.0015007257461548f, _2314, mad(0.004025210160762072f, _2313, (_2312 * -0.005525882821530104f))) - _2233) * cb0_012w) + _2233;
            float _2336 = max(max(_2330, _2331), _2332);
            float _2341 = (max(_2336, 1.000000013351432e-10f) - max(min(min(_2330, _2331), _2332), 1.000000013351432e-10f)) / max(_2336, 0.009999999776482582f);
            float _2354 = ((_2331 + _2330) + _2332) + (sqrt((((_2332 - _2331) * _2332) + ((_2331 - _2330) * _2331)) + ((_2330 - _2332) * _2330)) * 1.75f);
            float _2355 = _2354 * 0.3333333432674408f;
            float _2356 = _2341 + -0.4000000059604645f;
            float _2357 = _2356 * 5.0f;
            float _2361 = max((1.0f - abs(_2356 * 2.5f)), 0.0f);
            float _2372 = ((float(((int)(uint)((bool)(_2357 > 0.0f))) - ((int)(uint)((bool)(_2357 < 0.0f)))) * (1.0f - (_2361 * _2361))) + 1.0f) * 0.02500000037252903f;
            do {
              if (!(_2355 <= 0.0533333346247673f)) {
                if (!(_2355 >= 0.1599999964237213f)) {
                  _2381 = (((0.23999999463558197f / _2354) + -0.5f) * _2372);
                } else {
                  _2381 = 0.0f;
                }
              } else {
                _2381 = _2372;
              }
              float _2382 = _2381 + 1.0f;
              float _2383 = _2382 * _2330;
              float _2384 = _2382 * _2331;
              float _2385 = _2382 * _2332;
              do {
                if (!((bool)(_2383 == _2384) && (bool)(_2384 == _2385))) {
                  float _2392 = ((_2383 * 2.0f) - _2384) - _2385;
                  float _2395 = ((_2331 - _2332) * 1.7320507764816284f) * _2382;
                  float _2397 = atan(_2395 / _2392);
                  bool _2400 = (_2392 < 0.0f);
                  bool _2401 = (_2392 == 0.0f);
                  bool _2402 = (_2395 >= 0.0f);
                  bool _2403 = (_2395 < 0.0f);
                  _2414 = select((_2402 && _2401), 90.0f, select((_2403 && _2401), -90.0f, (select((_2403 && _2400), (_2397 + -3.1415927410125732f), select((_2402 && _2400), (_2397 + 3.1415927410125732f), _2397)) * 57.2957763671875f)));
                } else {
                  _2414 = 0.0f;
                }
                float _2419 = min(max(select((_2414 < 0.0f), (_2414 + 360.0f), _2414), 0.0f), 360.0f);
                do {
                  if (_2419 < -180.0f) {
                    _2428 = (_2419 + 360.0f);
                  } else {
                    if (_2419 > 180.0f) {
                      _2428 = (_2419 + -360.0f);
                    } else {
                      _2428 = _2419;
                    }
                  }
                  do {
                    if ((bool)(_2428 > -67.5f) && (bool)(_2428 < 67.5f)) {
                      float _2434 = (_2428 + 67.5f) * 0.029629629105329514f;
                      int _2435 = int(_2434);
                      float _2437 = _2434 - float(_2435);
                      float _2438 = _2437 * _2437;
                      float _2439 = _2438 * _2437;
                      if (_2435 == 3) {
                        _2467 = (((0.1666666716337204f - (_2437 * 0.5f)) + (_2438 * 0.5f)) - (_2439 * 0.1666666716337204f));
                      } else {
                        if (_2435 == 2) {
                          _2467 = ((0.6666666865348816f - _2438) + (_2439 * 0.5f));
                        } else {
                          if (_2435 == 1) {
                            _2467 = (((_2439 * -0.5f) + 0.1666666716337204f) + ((_2438 + _2437) * 0.5f));
                          } else {
                            _2467 = select((_2435 == 0), (_2439 * 0.1666666716337204f), 0.0f);
                          }
                        }
                      }
                    } else {
                      _2467 = 0.0f;
                    }
                    float _2476 = min(max(((((_2341 * 0.27000001072883606f) * (0.029999999329447746f - _2383)) * _2467) + _2383), 0.0f), 65535.0f);
                    float _2477 = min(max(_2384, 0.0f), 65535.0f);
                    float _2478 = min(max(_2385, 0.0f), 65535.0f);
                    float _2491 = min(max(mad(-0.21492856740951538f, _2478, mad(-0.2365107536315918f, _2477, (_2476 * 1.4514392614364624f))), 0.0f), 65504.0f);
                    float _2492 = min(max(mad(-0.09967592358589172f, _2478, mad(1.17622971534729f, _2477, (_2476 * -0.07655377686023712f))), 0.0f), 65504.0f);
                    float _2493 = min(max(mad(0.9977163076400757f, _2478, mad(-0.006032449658960104f, _2477, (_2476 * 0.008316148072481155f))), 0.0f), 65504.0f);
                    float _2494 = dot(float3(_2491, _2492, _2493), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
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
                    float _2517 = log2(max((lerp(_2494, _2491, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2518 = _2517 * 0.3010300099849701f;
                    float _2519 = log2(cb0_008x);
                    float _2520 = _2519 * 0.3010300099849701f;
                    do {
                      if (!(!(_2518 <= _2520))) {
                        _2589 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2527 = log2(cb0_009x);
                        float _2528 = _2527 * 0.3010300099849701f;
                        if ((bool)(_2518 > _2520) && (bool)(_2518 < _2528)) {
                          float _2536 = ((_2517 - _2519) * 0.9030900001525879f) / ((_2527 - _2519) * 0.3010300099849701f);
                          int _2537 = int(_2536);
                          float _2539 = _2536 - float(_2537);
                          float _2541 = _11[_2537];
                          float _2544 = _11[(_2537 + 1)];
                          float _2549 = _2541 * 0.5f;
                          _2589 = dot(float3((_2539 * _2539), _2539, 1.0f), float3(mad((_11[(_2537 + 2)]), 0.5f, mad(_2544, -1.0f, _2549)), (_2544 - _2541), mad(_2544, 0.5f, _2549)));
                        } else {
                          do {
                            if (!(!(_2518 >= _2528))) {
                              float _2558 = log2(cb0_008z);
                              if (_2518 < (_2558 * 0.3010300099849701f)) {
                                float _2566 = ((_2517 - _2527) * 0.9030900001525879f) / ((_2558 - _2527) * 0.3010300099849701f);
                                int _2567 = int(_2566);
                                float _2569 = _2566 - float(_2567);
                                float _2571 = _12[_2567];
                                float _2574 = _12[(_2567 + 1)];
                                float _2579 = _2571 * 0.5f;
                                _2589 = dot(float3((_2569 * _2569), _2569, 1.0f), float3(mad((_12[(_2567 + 2)]), 0.5f, mad(_2574, -1.0f, _2579)), (_2574 - _2571), mad(_2574, 0.5f, _2579)));
                                break;
                              }
                            }
                            _2589 = (log2(cb0_008w) * 0.3010300099849701f);
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
                      float _2605 = log2(max((lerp(_2494, _2492, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2606 = _2605 * 0.3010300099849701f;
                      do {
                        if (!(!(_2606 <= _2520))) {
                          _2675 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2613 = log2(cb0_009x);
                          float _2614 = _2613 * 0.3010300099849701f;
                          if ((bool)(_2606 > _2520) && (bool)(_2606 < _2614)) {
                            float _2622 = ((_2605 - _2519) * 0.9030900001525879f) / ((_2613 - _2519) * 0.3010300099849701f);
                            int _2623 = int(_2622);
                            float _2625 = _2622 - float(_2623);
                            float _2627 = _13[_2623];
                            float _2630 = _13[(_2623 + 1)];
                            float _2635 = _2627 * 0.5f;
                            _2675 = dot(float3((_2625 * _2625), _2625, 1.0f), float3(mad((_13[(_2623 + 2)]), 0.5f, mad(_2630, -1.0f, _2635)), (_2630 - _2627), mad(_2630, 0.5f, _2635)));
                          } else {
                            do {
                              if (!(!(_2606 >= _2614))) {
                                float _2644 = log2(cb0_008z);
                                if (_2606 < (_2644 * 0.3010300099849701f)) {
                                  float _2652 = ((_2605 - _2613) * 0.9030900001525879f) / ((_2644 - _2613) * 0.3010300099849701f);
                                  int _2653 = int(_2652);
                                  float _2655 = _2652 - float(_2653);
                                  float _2657 = _14[_2653];
                                  float _2660 = _14[(_2653 + 1)];
                                  float _2665 = _2657 * 0.5f;
                                  _2675 = dot(float3((_2655 * _2655), _2655, 1.0f), float3(mad((_14[(_2653 + 2)]), 0.5f, mad(_2660, -1.0f, _2665)), (_2660 - _2657), mad(_2660, 0.5f, _2665)));
                                  break;
                                }
                              }
                              _2675 = (log2(cb0_008w) * 0.3010300099849701f);
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
                        float _2691 = log2(max((lerp(_2494, _2493, 0.9599999785423279f)), 1.000000013351432e-10f));
                        float _2692 = _2691 * 0.3010300099849701f;
                        do {
                          if (!(!(_2692 <= _2520))) {
                            _2761 = (log2(cb0_008y) * 0.3010300099849701f);
                          } else {
                            float _2699 = log2(cb0_009x);
                            float _2700 = _2699 * 0.3010300099849701f;
                            if ((bool)(_2692 > _2520) && (bool)(_2692 < _2700)) {
                              float _2708 = ((_2691 - _2519) * 0.9030900001525879f) / ((_2699 - _2519) * 0.3010300099849701f);
                              int _2709 = int(_2708);
                              float _2711 = _2708 - float(_2709);
                              float _2713 = _15[_2709];
                              float _2716 = _15[(_2709 + 1)];
                              float _2721 = _2713 * 0.5f;
                              _2761 = dot(float3((_2711 * _2711), _2711, 1.0f), float3(mad((_15[(_2709 + 2)]), 0.5f, mad(_2716, -1.0f, _2721)), (_2716 - _2713), mad(_2716, 0.5f, _2721)));
                            } else {
                              do {
                                if (!(!(_2692 >= _2700))) {
                                  float _2730 = log2(cb0_008z);
                                  if (_2692 < (_2730 * 0.3010300099849701f)) {
                                    float _2738 = ((_2691 - _2699) * 0.9030900001525879f) / ((_2730 - _2699) * 0.3010300099849701f);
                                    int _2739 = int(_2738);
                                    float _2741 = _2738 - float(_2739);
                                    float _2743 = _16[_2739];
                                    float _2746 = _16[(_2739 + 1)];
                                    float _2751 = _2743 * 0.5f;
                                    _2761 = dot(float3((_2741 * _2741), _2741, 1.0f), float3(mad((_16[(_2739 + 2)]), 0.5f, mad(_2746, -1.0f, _2751)), (_2746 - _2743), mad(_2746, 0.5f, _2751)));
                                    break;
                                  }
                                }
                                _2761 = (log2(cb0_008w) * 0.3010300099849701f);
                              } while (false);
                            }
                          }
                          float _2765 = cb0_008w - cb0_008y;
                          float _2766 = (exp2(_2589 * 3.321928024291992f) - cb0_008y) / _2765;
                          float _2768 = (exp2(_2675 * 3.321928024291992f) - cb0_008y) / _2765;
                          float _2770 = (exp2(_2761 * 3.321928024291992f) - cb0_008y) / _2765;
                          float _2773 = mad(0.15618768334388733f, _2770, mad(0.13400420546531677f, _2768, (_2766 * 0.6624541878700256f)));
                          float _2776 = mad(0.053689517080783844f, _2770, mad(0.6740817427635193f, _2768, (_2766 * 0.2722287178039551f)));
                          float _2779 = mad(1.0103391408920288f, _2770, mad(0.00406073359772563f, _2768, (_2766 * -0.005574649665504694f)));
                          float _2792 = min(max(mad(-0.23642469942569733f, _2779, mad(-0.32480329275131226f, _2776, (_2773 * 1.6410233974456787f))), 0.0f), 1.0f);
                          float _2793 = min(max(mad(0.016756348311901093f, _2779, mad(1.6153316497802734f, _2776, (_2773 * -0.663662850856781f))), 0.0f), 1.0f);
                          float _2794 = min(max(mad(0.9883948564529419f, _2779, mad(-0.008284442126750946f, _2776, (_2773 * 0.011721894145011902f))), 0.0f), 1.0f);
                          float _2797 = mad(0.15618768334388733f, _2794, mad(0.13400420546531677f, _2793, (_2792 * 0.6624541878700256f)));
                          float _2800 = mad(0.053689517080783844f, _2794, mad(0.6740817427635193f, _2793, (_2792 * 0.2722287178039551f)));
                          float _2803 = mad(1.0103391408920288f, _2794, mad(0.00406073359772563f, _2793, (_2792 * -0.005574649665504694f)));
                          float _2825 = min(max((min(max(mad(-0.23642469942569733f, _2803, mad(-0.32480329275131226f, _2800, (_2797 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                          float _2828 = min(max((min(max(mad(0.016756348311901093f, _2803, mad(1.6153316497802734f, _2800, (_2797 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          float _2829 = min(max((min(max(mad(0.9883948564529419f, _2803, mad(-0.008284442126750946f, _2800, (_2797 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f) * 0.012500000186264515f;
                          _2976 = mad(-0.0832589864730835f, _2829, mad(-0.6217921376228333f, _2828, (_2825 * 0.0213131383061409f)));
                          _2977 = mad(-0.010548308491706848f, _2829, mad(1.140804648399353f, _2828, (_2825 * -0.0016282059950754046f)));
                          _2978 = mad(1.1529725790023804f, _2829, mad(-0.1289689838886261f, _2828, (_2825 * -0.00030004189466126263f)));
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if ((uint)(cb0_042w) == 7) {
            float _2856 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1346, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1345)));
            float _2859 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1346, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1345)));
            float _2862 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1347, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1346, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1345)));
            float _2881 = exp2(log2(mad(_65, _2862, mad(_64, _2859, (_2856 * _63))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2882 = exp2(log2(mad(_68, _2862, mad(_67, _2859, (_2856 * _66))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2883 = exp2(log2(mad(_71, _2862, mad(_70, _2859, (_2856 * _69))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2976 = exp2(log2((1.0f / ((_2881 * 18.6875f) + 1.0f)) * ((_2881 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2977 = exp2(log2((1.0f / ((_2882 * 18.6875f) + 1.0f)) * ((_2882 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2978 = exp2(log2((1.0f / ((_2883 * 18.6875f) + 1.0f)) * ((_2883 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!((uint)(cb0_042w) == 8)) {
              if ((uint)(cb0_042w) == 9) {
                float _2930 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1335, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1334, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1333)));
                float _2933 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1335, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1334, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1333)));
                float _2936 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1335, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1334, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1333)));
                _2976 = mad(_65, _2936, mad(_64, _2933, (_2930 * _63)));
                _2977 = mad(_68, _2936, mad(_67, _2933, (_2930 * _66)));
                _2978 = mad(_71, _2936, mad(_70, _2933, (_2930 * _69)));
              } else {
                float _2949 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[0].x) * _1359)));
                float _2952 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[1].x) * _1359)));
                float _2955 = mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].z), _1361, mad((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].y), _1360, ((WorkingColorSpace_000.FWorkingColorSpaceConstants_128[2].x) * _1359)));
                _2976 = exp2(log2(mad(_65, _2955, mad(_64, _2952, (_2949 * _63)))) * cb0_042z);
                _2977 = exp2(log2(mad(_68, _2955, mad(_67, _2952, (_2949 * _66)))) * cb0_042z);
                _2978 = exp2(log2(mad(_71, _2955, mad(_70, _2952, (_2949 * _69)))) * cb0_042z);
              }
            } else {
              _2976 = _1345;
              _2977 = _1346;
              _2978 = _1347;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2976 * 0.9523810148239136f), (_2977 * 0.9523810148239136f), (_2978 * 0.9523810148239136f), 0.0f);
}
