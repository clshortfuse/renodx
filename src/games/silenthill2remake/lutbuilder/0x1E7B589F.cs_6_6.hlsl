#include "./filmiclutbuilder.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

RWTexture3D<float4> u0 : register(u0);

// cbuffer cb0 : register(b0) {
//   float cb0_005x : packoffset(c005.x);
//   float cb0_005y : packoffset(c005.y);
//   float cb0_005z : packoffset(c005.z);
//   float cb0_005w : packoffset(c005.w);
//   float cb0_006x : packoffset(c006.x);
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
  float _30 = (cb0_042x * (float((uint)SV_DispatchThreadID.x) + 0.5f)) + -0.015625f;
  float _31 = (cb0_042y * (float((uint)SV_DispatchThreadID.y) + 0.5f)) + -0.015625f;
  float _34 = float((uint)SV_DispatchThreadID.z);
  float _55;
  float _56;
  float _57;
  float _58;
  float _59;
  float _60;
  float _61;
  float _62;
  float _63;
  float _121;
  float _122;
  float _123;
  float _647;
  float _683;
  float _694;
  float _758;
  float _937;
  float _948;
  float _959;
  float _1209;
  float _1210;
  float _1211;
  float _1222;
  float _1233;
  float _1415;
  float _1451;
  float _1462;
  float _1501;
  float _1611;
  float _1685;
  float _1759;
  float _1838;
  float _1839;
  float _1840;
  float _1991;
  float _2027;
  float _2038;
  float _2077;
  float _2187;
  float _2261;
  float _2335;
  float _2414;
  float _2415;
  float _2416;
  float _2593;
  float _2594;
  float _2595;
  if (!(output_gamut == 1)) {
    if (!(output_gamut == 2)) {
      if (!(output_gamut == 3)) {
        bool _44 = (output_gamut == 4);
        _55 = select(_44, 1.0f, 1.7050515413284302f);
        _56 = select(_44, 0.0f, -0.6217905879020691f);
        _57 = select(_44, 0.0f, -0.0832584798336029f);
        _58 = select(_44, 0.0f, -0.13025718927383423f);
        _59 = select(_44, 1.0f, 1.1408027410507202f);
        _60 = select(_44, 0.0f, -0.010548528283834457f);
        _61 = select(_44, 0.0f, -0.024003278464078903f);
        _62 = select(_44, 0.0f, -0.1289687603712082f);
        _63 = select(_44, 1.0f, 1.152971863746643f);
      } else {
        _55 = 0.6954522132873535f;
        _56 = 0.14067870378494263f;
        _57 = 0.16386906802654266f;
        _58 = 0.044794563204050064f;
        _59 = 0.8596711158752441f;
        _60 = 0.0955343171954155f;
        _61 = -0.005525882821530104f;
        _62 = 0.004025210160762072f;
        _63 = 1.0015007257461548f;
      }
    } else {
      _55 = 1.02579927444458f;
      _56 = -0.020052503794431686f;
      _57 = -0.0057713985443115234f;
      _58 = -0.0022350111976265907f;
      _59 = 1.0045825242996216f;
      _60 = -0.002352306619286537f;
      _61 = -0.005014004185795784f;
      _62 = -0.025293385609984398f;
      _63 = 1.0304402112960815f;
    }
  } else {
    _55 = 1.379158854484558f;
    _56 = -0.3088507056236267f;
    _57 = -0.07034677267074585f;
    _58 = -0.06933528929948807f;
    _59 = 1.0822921991348267f;
    _60 = -0.012962047010660172f;
    _61 = -0.002159259282052517f;
    _62 = -0.045465391129255295f;
    _63 = 1.0477596521377563f;
  }
  if ((uint)output_device > (uint)2) {
    float _74 = exp2(log2(_30 * 1.0322580337524414f) * 0.012683313339948654f);
    float _75 = exp2(log2(_31 * 1.0322580337524414f) * 0.012683313339948654f);
    float _76 = exp2(log2(_34 * 0.032258063554763794f) * 0.012683313339948654f);
    _121 = (exp2(log2(max(0.0f, (_74 + -0.8359375f)) / (18.8515625f - (_74 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _122 = (exp2(log2(max(0.0f, (_75 + -0.8359375f)) / (18.8515625f - (_75 * 18.6875f))) * 6.277394771575928f) * 100.0f);
    _123 = (exp2(log2(max(0.0f, (_76 + -0.8359375f)) / (18.8515625f - (_76 * 18.6875f))) * 6.277394771575928f) * 100.0f);
  } else {
    _121 = ((exp2((_30 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _122 = ((exp2((_31 * 14.45161247253418f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
    _123 = ((exp2((_34 * 0.4516128897666931f) + -6.07624626159668f) * 0.18000000715255737f) + -0.002667719265446067f);
  }

#if 1  // delay output device override until after input is decoded
  ApplyLUTOutputOverrides();
#endif

  float _138 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _123, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _122, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _121)));
  float _141 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _123, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _122, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _121)));
  float _144 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _123, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _122, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _121)));
  float _145 = dot(float3(_138, _141, _144), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _149 = (_138 / _145) + -1.0f;
  float _150 = (_141 / _145) + -1.0f;
  float _151 = (_144 / _145) + -1.0f;
  float _163 = (1.0f - exp2(((_145 * _145) * -4.0f) * expand_gamut)) * (1.0f - exp2(dot(float3(_149, _150, _151), float3(_149, _150, _151)) * -4.0f));
  float _179 = ((mad(-0.06368283927440643f, _144, mad(-0.32929131388664246f, _141, (_138 * 1.370412826538086f))) - _138) * _163) + _138;
  float _180 = ((mad(-0.010861567221581936f, _144, mad(1.0970908403396606f, _141, (_138 * -0.08343426138162613f))) - _141) * _163) + _141;
  float _181 = ((mad(1.203694462776184f, _144, mad(-0.09862564504146576f, _141, (_138 * -0.02579325996339321f))) - _144) * _163) + _144;
  float _182 = dot(float3(_179, _180, _181), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _196 = cb0_019w + cb0_024w;
  float _210 = cb0_018w * cb0_023w;
  float _224 = cb0_017w * cb0_022w;
  float _238 = cb0_016w * cb0_021w;
  float _252 = cb0_015w * cb0_020w;
  float _256 = _179 - _182;
  float _257 = _180 - _182;
  float _258 = _181 - _182;
  float _316 = saturate(_182 / cb0_035z);
  float _320 = (_316 * _316) * (3.0f - (_316 * 2.0f));
  float _321 = 1.0f - _320;
  float _330 = cb0_019w + cb0_034w;
  float _339 = cb0_018w * cb0_033w;
  float _348 = cb0_017w * cb0_032w;
  float _357 = cb0_016w * cb0_031w;
  float _366 = cb0_015w * cb0_030w;
  float _429 = saturate((_182 - cb0_035w) / (cb0_036x - cb0_035w));
  float _433 = (_429 * _429) * (3.0f - (_429 * 2.0f));
  float _442 = cb0_019w + cb0_029w;
  float _451 = cb0_018w * cb0_028w;
  float _460 = cb0_017w * cb0_027w;
  float _469 = cb0_016w * cb0_026w;
  float _478 = cb0_015w * cb0_025w;
  float _536 = _320 - _433;
  float _547 = ((_433 * (((cb0_019x + cb0_034x) + _330) + (((cb0_018x * cb0_033x) * _339) * exp2(log2(exp2(((cb0_016x * cb0_031x) * _357) * log2(max(0.0f, ((((cb0_015x * cb0_030x) * _366) * _256) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_032x) * _348)))))) + (_321 * (((cb0_019x + cb0_024x) + _196) + (((cb0_018x * cb0_023x) * _210) * exp2(log2(exp2(((cb0_016x * cb0_021x) * _238) * log2(max(0.0f, ((((cb0_015x * cb0_020x) * _252) * _256) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_022x) * _224))))))) + ((((cb0_019x + cb0_029x) + _442) + (((cb0_018x * cb0_028x) * _451) * exp2(log2(exp2(((cb0_016x * cb0_026x) * _469) * log2(max(0.0f, ((((cb0_015x * cb0_025x) * _478) * _256) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017x * cb0_027x) * _460))))) * _536);
  float _549 = ((_433 * (((cb0_019y + cb0_034y) + _330) + (((cb0_018y * cb0_033y) * _339) * exp2(log2(exp2(((cb0_016y * cb0_031y) * _357) * log2(max(0.0f, ((((cb0_015y * cb0_030y) * _366) * _257) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_032y) * _348)))))) + (_321 * (((cb0_019y + cb0_024y) + _196) + (((cb0_018y * cb0_023y) * _210) * exp2(log2(exp2(((cb0_016y * cb0_021y) * _238) * log2(max(0.0f, ((((cb0_015y * cb0_020y) * _252) * _257) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_022y) * _224))))))) + ((((cb0_019y + cb0_029y) + _442) + (((cb0_018y * cb0_028y) * _451) * exp2(log2(exp2(((cb0_016y * cb0_026y) * _469) * log2(max(0.0f, ((((cb0_015y * cb0_025y) * _478) * _257) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017y * cb0_027y) * _460))))) * _536);
  float _551 = ((_433 * (((cb0_019z + cb0_034z) + _330) + (((cb0_018z * cb0_033z) * _339) * exp2(log2(exp2(((cb0_016z * cb0_031z) * _357) * log2(max(0.0f, ((((cb0_015z * cb0_030z) * _366) * _258) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_032z) * _348)))))) + (_321 * (((cb0_019z + cb0_024z) + _196) + (((cb0_018z * cb0_023z) * _210) * exp2(log2(exp2(((cb0_016z * cb0_021z) * _238) * log2(max(0.0f, ((((cb0_015z * cb0_020z) * _252) * _258) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_022z) * _224))))))) + ((((cb0_019z + cb0_029z) + _442) + (((cb0_018z * cb0_028z) * _451) * exp2(log2(exp2(((cb0_016z * cb0_026z) * _469) * log2(max(0.0f, ((((cb0_015z * cb0_025z) * _478) * _258) + _182)) * 5.55555534362793f)) * 0.18000000715255737f) * (1.0f / ((cb0_017z * cb0_027z) * _460))))) * _536);
  float _587 = ((mad(0.061360642313957214f, _551, mad(-4.540197551250458e-09f, _549, (_547 * 0.9386394023895264f))) - _547) * cb0_036y) + _547;
  float _588 = ((mad(0.169205904006958f, _551, mad(0.8307942152023315f, _549, (_547 * 6.775371730327606e-08f))) - _549) * cb0_036y) + _549;
  float _589 = (mad(-2.3283064365386963e-10f, _549, (_547 * -9.313225746154785e-10f)) * cb0_036y) + _551;
  float _592 = mad(0.16386905312538147f, _589, mad(0.14067868888378143f, _588, (_587 * 0.6954522132873535f)));
  float _595 = mad(0.0955343246459961f, _589, mad(0.8596711158752441f, _588, (_587 * 0.044794581830501556f)));
  float _598 = mad(1.0015007257461548f, _589, mad(0.004025210160762072f, _588, (_587 * -0.005525882821530104f)));
  float _602 = max(max(_592, _595), _598);
  float _607 = (max(_602, 1.000000013351432e-10f) - max(min(min(_592, _595), _598), 1.000000013351432e-10f)) / max(_602, 0.009999999776482582f);
  float _620 = ((_595 + _592) + _598) + (sqrt((((_598 - _595) * _598) + ((_595 - _592) * _595)) + ((_592 - _598) * _592)) * 1.75f);
  float _621 = _620 * 0.3333333432674408f;
  float _622 = _607 + -0.4000000059604645f;
  float _623 = _622 * 5.0f;
  float _627 = max((1.0f - abs(_622 * 2.5f)), 0.0f);
  float _638 = ((float((int)(((int)(uint)((bool)(_623 > 0.0f))) - ((int)(uint)((bool)(_623 < 0.0f))))) * (1.0f - (_627 * _627))) + 1.0f) * 0.02500000037252903f;
  if (!(_621 <= 0.0533333346247673f)) {
    if (!(_621 >= 0.1599999964237213f)) {
      _647 = (((0.23999999463558197f / _620) + -0.5f) * _638);
    } else {
      _647 = 0.0f;
    }
  } else {
    _647 = _638;
  }
  float _648 = _647 + 1.0f;
  float _649 = _648 * _592;
  float _650 = _648 * _595;
  float _651 = _648 * _598;
  if (!((bool)(_649 == _650) && (bool)(_650 == _651))) {
    float _658 = ((_649 * 2.0f) - _650) - _651;
    float _661 = ((_595 - _598) * 1.7320507764816284f) * _648;
    float _663 = atan(_661 / _658);
    bool _666 = (_658 < 0.0f);
    bool _667 = (_658 == 0.0f);
    bool _668 = (_661 >= 0.0f);
    bool _669 = (_661 < 0.0f);
    float _678 = select((_668 && _667), 90.0f, select((_669 && _667), -90.0f, (select((_669 && _666), (_663 + -3.1415927410125732f), select((_668 && _666), (_663 + 3.1415927410125732f), _663)) * 57.2957763671875f)));
    if (_678 < 0.0f) {
      _683 = (_678 + 360.0f);
    } else {
      _683 = _678;
    }
  } else {
    _683 = 0.0f;
  }
  float _685 = min(max(_683, 0.0f), 360.0f);
  if (_685 < -180.0f) {
    _694 = (_685 + 360.0f);
  } else {
    if (_685 > 180.0f) {
      _694 = (_685 + -360.0f);
    } else {
      _694 = _685;
    }
  }
  float _698 = saturate(1.0f - abs(_694 * 0.014814814552664757f));
  float _702 = (_698 * _698) * (3.0f - (_698 * 2.0f));
  float _708 = ((_702 * _702) * ((_607 * 0.18000000715255737f) * (0.029999999329447746f - _649))) + _649;
  float _718 = max(0.0f, mad(-0.21492856740951538f, _651, mad(-0.2365107536315918f, _650, (_708 * 1.4514392614364624f))));
  float _719 = max(0.0f, mad(-0.09967592358589172f, _651, mad(1.17622971534729f, _650, (_708 * -0.07655377686023712f))));
  float _720 = max(0.0f, mad(0.9977163076400757f, _651, mad(-0.006032449658960104f, _650, (_708 * 0.008316148072481155f))));
  float _721 = dot(float3(_718, _719, _720), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _735 = (cb0_037w + 1.0f) - cb0_037y;
  float _738 = cb0_038x + 1.0f;
  float _740 = _738 - cb0_037z;
  if (cb0_037y > 0.800000011920929f) {
    _758 = (((0.8199999928474426f - cb0_037y) / cb0_037x) + -0.7447274923324585f);
  } else {
    float _749 = (cb0_037w + 0.18000000715255737f) / _735;
    _758 = (-0.7447274923324585f - ((log2(_749 / (2.0f - _749)) * 0.3465735912322998f) * (_735 / cb0_037x)));
  }
  float _761 = ((1.0f - cb0_037y) / cb0_037x) - _758;
  float _763 = (cb0_037z / cb0_037x) - _761;
  float _767 = log2(lerp(_721, _718, 0.9599999785423279f)) * 0.3010300099849701f;
  float _768 = log2(lerp(_721, _719, 0.9599999785423279f)) * 0.3010300099849701f;
  float _769 = log2(lerp(_721, _720, 0.9599999785423279f)) * 0.3010300099849701f;
  float _773 = cb0_037x * (_767 + _761);
  float _774 = cb0_037x * (_768 + _761);
  float _775 = cb0_037x * (_769 + _761);
  float _776 = _735 * 2.0f;
  float _778 = (cb0_037x * -2.0f) / _735;
  float _779 = _767 - _758;
  float _780 = _768 - _758;
  float _781 = _769 - _758;
  float _800 = _740 * 2.0f;
  float _802 = (cb0_037x * 2.0f) / _740;
  float _827 = select((_767 < _758), ((_776 / (exp2((_779 * 1.4426950216293335f) * _778) + 1.0f)) - cb0_037w), _773);
  float _828 = select((_768 < _758), ((_776 / (exp2((_780 * 1.4426950216293335f) * _778) + 1.0f)) - cb0_037w), _774);
  float _829 = select((_769 < _758), ((_776 / (exp2((_781 * 1.4426950216293335f) * _778) + 1.0f)) - cb0_037w), _775);
  float _836 = _763 - _758;
  float _840 = saturate(_779 / _836);
  float _841 = saturate(_780 / _836);
  float _842 = saturate(_781 / _836);
  bool _843 = (_763 < _758);
  float _847 = select(_843, (1.0f - _840), _840);
  float _848 = select(_843, (1.0f - _841), _841);
  float _849 = select(_843, (1.0f - _842), _842);
  float _868 = (((_847 * _847) * (select((_767 > _763), (_738 - (_800 / (exp2(((_767 - _763) * 1.4426950216293335f) * _802) + 1.0f))), _773) - _827)) * (3.0f - (_847 * 2.0f))) + _827;
  float _869 = (((_848 * _848) * (select((_768 > _763), (_738 - (_800 / (exp2(((_768 - _763) * 1.4426950216293335f) * _802) + 1.0f))), _774) - _828)) * (3.0f - (_848 * 2.0f))) + _828;
  float _870 = (((_849 * _849) * (select((_769 > _763), (_738 - (_800 / (exp2(((_769 - _763) * 1.4426950216293335f) * _802) + 1.0f))), _775) - _829)) * (3.0f - (_849 * 2.0f))) + _829;
  float _871 = dot(float3(_868, _869, _870), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _891 = (cb0_036w * (max(0.0f, (lerp(_871, _868, 0.9300000071525574f))) - _587)) + _587;
  float _892 = (cb0_036w * (max(0.0f, (lerp(_871, _869, 0.9300000071525574f))) - _588)) + _588;
  float _893 = (cb0_036w * (max(0.0f, (lerp(_871, _870, 0.9300000071525574f))) - _589)) + _589;
  float _909 = ((mad(-0.06537103652954102f, _893, mad(1.451815478503704e-06f, _892, (_891 * 1.065374732017517f))) - _891) * cb0_036y) + _891;
  float _910 = ((mad(-0.20366770029067993f, _893, mad(1.2036634683609009f, _892, (_891 * -2.57161445915699e-07f))) - _892) * cb0_036y) + _892;
  float _911 = ((mad(0.9999996423721313f, _893, mad(2.0954757928848267e-08f, _892, (_891 * 1.862645149230957e-08f))) - _893) * cb0_036y) + _893;
  float _924 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _911, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _910, ((UniformBufferConstants_WorkingColorSpace_192[0].x) * _909)))));
  float _925 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _911, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _910, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _909)))));
  float _926 = saturate(max(0.0f, mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _911, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _910, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _909)))));
  if (_924 < 0.0031306699384003878f) {
    _937 = (_924 * 12.920000076293945f);
  } else {
    _937 = (((pow(_924, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_925 < 0.0031306699384003878f) {
    _948 = (_925 * 12.920000076293945f);
  } else {
    _948 = (((pow(_925, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (_926 < 0.0031306699384003878f) {
    _959 = (_926 * 12.920000076293945f);
  } else {
    _959 = (((pow(_926, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _963 = (_948 * 0.9375f) + 0.03125f;
  float _970 = _959 * 15.0f;
  float _971 = floor(_970);
  float _972 = _970 - _971;
  float _974 = (_971 + ((_937 * 0.9375f) + 0.03125f)) * 0.0625f;
  float4 _977 = t0.SampleLevel(s0, float2(_974, _963), 0.0f);
  float _981 = _974 + 0.0625f;
  float4 _982 = t0.SampleLevel(s0, float2(_981, _963), 0.0f);
  float4 _1004 = t1.SampleLevel(s1, float2(_974, _963), 0.0f);
  float4 _1008 = t1.SampleLevel(s1, float2(_981, _963), 0.0f);
  float4 _1030 = t2.SampleLevel(s2, float2(_974, _963), 0.0f);
  float4 _1034 = t2.SampleLevel(s2, float2(_981, _963), 0.0f);
  float4 _1057 = t3.SampleLevel(s3, float2(_974, _963), 0.0f);
  float4 _1061 = t3.SampleLevel(s3, float2(_981, _963), 0.0f);
  float _1080 = max(6.103519990574569e-05f, ((((((lerp(_977.x, _982.x, _972))*cb0_005y) + (cb0_005x * _937)) + ((lerp(_1004.x, _1008.x, _972))*cb0_005z)) + ((lerp(_1030.x, _1034.x, _972))*cb0_005w)) + ((lerp(_1057.x, _1061.x, _972))*cb0_006x)));
  float _1081 = max(6.103519990574569e-05f, ((((((lerp(_977.y, _982.y, _972))*cb0_005y) + (cb0_005x * _948)) + ((lerp(_1004.y, _1008.y, _972))*cb0_005z)) + ((lerp(_1030.y, _1034.y, _972))*cb0_005w)) + ((lerp(_1057.y, _1061.y, _972))*cb0_006x)));
  float _1082 = max(6.103519990574569e-05f, ((((((lerp(_977.z, _982.z, _972))*cb0_005y) + (cb0_005x * _959)) + ((lerp(_1004.z, _1008.z, _972))*cb0_005z)) + ((lerp(_1030.z, _1034.z, _972))*cb0_005w)) + ((lerp(_1057.z, _1061.z, _972))*cb0_006x)));
  float _1104 = select((_1080 > 0.040449999272823334f), exp2(log2((_1080 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1080 * 0.07739938050508499f));
  float _1105 = select((_1081 > 0.040449999272823334f), exp2(log2((_1081 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1081 * 0.07739938050508499f));
  float _1106 = select((_1082 > 0.040449999272823334f), exp2(log2((_1082 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_1082 * 0.07739938050508499f));
  float _1132 = cb0_014x * (((cb0_039y + (cb0_039x * _1104)) * _1104) + cb0_039z);
  float _1133 = cb0_014y * (((cb0_039y + (cb0_039x * _1105)) * _1105) + cb0_039z);
  float _1134 = cb0_014z * (((cb0_039y + (cb0_039x * _1106)) * _1106) + cb0_039z);
  float _1141 = ((cb0_013x - _1132) * cb0_013w) + _1132;
  float _1142 = ((cb0_013y - _1133) * cb0_013w) + _1133;
  float _1143 = ((cb0_013z - _1134) * cb0_013w) + _1134;
  float _1144 = cb0_014x * mad((UniformBufferConstants_WorkingColorSpace_192[0].z), _551, mad((UniformBufferConstants_WorkingColorSpace_192[0].y), _549, (_547 * (UniformBufferConstants_WorkingColorSpace_192[0].x))));
  float _1145 = cb0_014y * mad((UniformBufferConstants_WorkingColorSpace_192[1].z), _551, mad((UniformBufferConstants_WorkingColorSpace_192[1].y), _549, ((UniformBufferConstants_WorkingColorSpace_192[1].x) * _547)));
  float _1146 = cb0_014z * mad((UniformBufferConstants_WorkingColorSpace_192[2].z), _551, mad((UniformBufferConstants_WorkingColorSpace_192[2].y), _549, ((UniformBufferConstants_WorkingColorSpace_192[2].x) * _547)));
  float _1153 = ((cb0_013x - _1144) * cb0_013w) + _1144;
  float _1154 = ((cb0_013y - _1145) * cb0_013w) + _1145;
  float _1155 = ((cb0_013z - _1146) * cb0_013w) + _1146;
  float _1167 = exp2(log2(max(0.0f, _1141)) * cb0_040y);
  float _1168 = exp2(log2(max(0.0f, _1142)) * cb0_040y);
  float _1169 = exp2(log2(max(0.0f, _1143)) * cb0_040y);
  [branch]
  if (output_device == 0) {
    do {
      if (UniformBufferConstants_WorkingColorSpace_320 == 0) {
        float _1192 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1167)));
        float _1195 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1167)));
        float _1198 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1167)));
        _1209 = mad(_57, _1198, mad(_56, _1195, (_1192 * _55)));
        _1210 = mad(_60, _1198, mad(_59, _1195, (_1192 * _58)));
        _1211 = mad(_63, _1198, mad(_62, _1195, (_1192 * _61)));
      } else {
        _1209 = _1167;
        _1210 = _1168;
        _1211 = _1169;
      }
      do {
        if (_1209 < 0.0031306699384003878f) {
          _1222 = (_1209 * 12.920000076293945f);
        } else {
          _1222 = (((pow(_1209, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (_1210 < 0.0031306699384003878f) {
            _1233 = (_1210 * 12.920000076293945f);
          } else {
            _1233 = (((pow(_1210, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (_1211 < 0.0031306699384003878f) {
            _2593 = _1222;
            _2594 = _1233;
            _2595 = (_1211 * 12.920000076293945f);
          } else {
            _2593 = _1222;
            _2594 = _1233;
            _2595 = (((pow(_1211, 0.4166666567325592f)) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (output_device == 1) {
      float _1260 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1167)));
      float _1263 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1167)));
      float _1266 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1167)));
      float _1276 = max(6.103519990574569e-05f, mad(_57, _1266, mad(_56, _1263, (_1260 * _55))));
      float _1277 = max(6.103519990574569e-05f, mad(_60, _1266, mad(_59, _1263, (_1260 * _58))));
      float _1278 = max(6.103519990574569e-05f, mad(_63, _1266, mad(_62, _1263, (_1260 * _61))));
      _2593 = min((_1276 * 4.5f), ((exp2(log2(max(_1276, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2594 = min((_1277 * 4.5f), ((exp2(log2(max(_1277, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
      _2595 = min((_1278 * 4.5f), ((exp2(log2(max(_1278, 0.017999999225139618f)) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f));
    } else {
      if ((bool)(output_device == 3) || (bool)(output_device == 5)) {
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
        float _1355 = cb0_012z * _1153;
        float _1356 = cb0_012z * _1154;
        float _1357 = cb0_012z * _1155;
        float _1360 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1357, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1356, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1355)));
        float _1363 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1357, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1356, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1355)));
        float _1366 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1357, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1356, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1355)));
        float _1370 = max(max(_1360, _1363), _1366);
        float _1375 = (max(_1370, 1.000000013351432e-10f) - max(min(min(_1360, _1363), _1366), 1.000000013351432e-10f)) / max(_1370, 0.009999999776482582f);
        float _1388 = ((_1363 + _1360) + _1366) + (sqrt((((_1366 - _1363) * _1366) + ((_1363 - _1360) * _1363)) + ((_1360 - _1366) * _1360)) * 1.75f);
        float _1389 = _1388 * 0.3333333432674408f;
        float _1390 = _1375 + -0.4000000059604645f;
        float _1391 = _1390 * 5.0f;
        float _1395 = max((1.0f - abs(_1390 * 2.5f)), 0.0f);
        float _1406 = ((float((int)(((int)(uint)((bool)(_1391 > 0.0f))) - ((int)(uint)((bool)(_1391 < 0.0f))))) * (1.0f - (_1395 * _1395))) + 1.0f) * 0.02500000037252903f;
        do {
          if (!(_1389 <= 0.0533333346247673f)) {
            if (!(_1389 >= 0.1599999964237213f)) {
              _1415 = (((0.23999999463558197f / _1388) + -0.5f) * _1406);
            } else {
              _1415 = 0.0f;
            }
          } else {
            _1415 = _1406;
          }
          float _1416 = _1415 + 1.0f;
          float _1417 = _1416 * _1360;
          float _1418 = _1416 * _1363;
          float _1419 = _1416 * _1366;
          do {
            if (!((bool)(_1417 == _1418) && (bool)(_1418 == _1419))) {
              float _1426 = ((_1417 * 2.0f) - _1418) - _1419;
              float _1429 = ((_1363 - _1366) * 1.7320507764816284f) * _1416;
              float _1431 = atan(_1429 / _1426);
              bool _1434 = (_1426 < 0.0f);
              bool _1435 = (_1426 == 0.0f);
              bool _1436 = (_1429 >= 0.0f);
              bool _1437 = (_1429 < 0.0f);
              float _1446 = select((_1436 && _1435), 90.0f, select((_1437 && _1435), -90.0f, (select((_1437 && _1434), (_1431 + -3.1415927410125732f), select((_1436 && _1434), (_1431 + 3.1415927410125732f), _1431)) * 57.2957763671875f)));
              if (_1446 < 0.0f) {
                _1451 = (_1446 + 360.0f);
              } else {
                _1451 = _1446;
              }
            } else {
              _1451 = 0.0f;
            }
            float _1453 = min(max(_1451, 0.0f), 360.0f);
            do {
              if (_1453 < -180.0f) {
                _1462 = (_1453 + 360.0f);
              } else {
                if (_1453 > 180.0f) {
                  _1462 = (_1453 + -360.0f);
                } else {
                  _1462 = _1453;
                }
              }
              do {
                if ((bool)(_1462 > -67.5f) && (bool)(_1462 < 67.5f)) {
                  float _1468 = (_1462 + 67.5f) * 0.029629629105329514f;
                  int _1469 = int(_1468);
                  float _1471 = _1468 - float((int)(_1469));
                  float _1472 = _1471 * _1471;
                  float _1473 = _1472 * _1471;
                  if (_1469 == 3) {
                    _1501 = (((0.1666666716337204f - (_1471 * 0.5f)) + (_1472 * 0.5f)) - (_1473 * 0.1666666716337204f));
                  } else {
                    if (_1469 == 2) {
                      _1501 = ((0.6666666865348816f - _1472) + (_1473 * 0.5f));
                    } else {
                      if (_1469 == 1) {
                        _1501 = (((_1473 * -0.5f) + 0.1666666716337204f) + ((_1472 + _1471) * 0.5f));
                      } else {
                        _1501 = select((_1469 == 0), (_1473 * 0.1666666716337204f), 0.0f);
                      }
                    }
                  }
                } else {
                  _1501 = 0.0f;
                }
                float _1510 = min(max(((((_1375 * 0.27000001072883606f) * (0.029999999329447746f - _1417)) * _1501) + _1417), 0.0f), 65535.0f);
                float _1511 = min(max(_1418, 0.0f), 65535.0f);
                float _1512 = min(max(_1419, 0.0f), 65535.0f);
                float _1525 = min(max(mad(-0.21492856740951538f, _1512, mad(-0.2365107536315918f, _1511, (_1510 * 1.4514392614364624f))), 0.0f), 65504.0f);
                float _1526 = min(max(mad(-0.09967592358589172f, _1512, mad(1.17622971534729f, _1511, (_1510 * -0.07655377686023712f))), 0.0f), 65504.0f);
                float _1527 = min(max(mad(0.9977163076400757f, _1512, mad(-0.006032449658960104f, _1511, (_1510 * 0.008316148072481155f))), 0.0f), 65504.0f);
                float _1528 = dot(float3(_1525, _1526, _1527), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1539 = log2(max((lerp(_1528, _1525, 0.9599999785423279f)), 1.000000013351432e-10f));
                float _1540 = _1539 * 0.3010300099849701f;
                float _1541 = log2(cb0_008x);
                float _1542 = _1541 * 0.3010300099849701f;
                do {
                  if (!(!(_1540 <= _1542))) {
                    _1611 = (log2(cb0_008y) * 0.3010300099849701f);
                  } else {
                    float _1549 = log2(cb0_009x);
                    float _1550 = _1549 * 0.3010300099849701f;
                    if ((bool)(_1540 > _1542) && (bool)(_1540 < _1550)) {
                      float _1558 = ((_1539 - _1541) * 0.9030900001525879f) / ((_1549 - _1541) * 0.3010300099849701f);
                      int _1559 = int(_1558);
                      float _1561 = _1558 - float((int)(_1559));
                      float _1563 = _19[_1559];
                      float _1566 = _19[(_1559 + 1)];
                      float _1571 = _1563 * 0.5f;
                      _1611 = dot(float3((_1561 * _1561), _1561, 1.0f), float3(mad((_19[(_1559 + 2)]), 0.5f, mad(_1566, -1.0f, _1571)), (_1566 - _1563), mad(_1566, 0.5f, _1571)));
                    } else {
                      do {
                        if (!(!(_1540 >= _1550))) {
                          float _1580 = log2(cb0_008z);
                          if (_1540 < (_1580 * 0.3010300099849701f)) {
                            float _1588 = ((_1539 - _1549) * 0.9030900001525879f) / ((_1580 - _1549) * 0.3010300099849701f);
                            int _1589 = int(_1588);
                            float _1591 = _1588 - float((int)(_1589));
                            float _1593 = _20[_1589];
                            float _1596 = _20[(_1589 + 1)];
                            float _1601 = _1593 * 0.5f;
                            _1611 = dot(float3((_1591 * _1591), _1591, 1.0f), float3(mad((_20[(_1589 + 2)]), 0.5f, mad(_1596, -1.0f, _1601)), (_1596 - _1593), mad(_1596, 0.5f, _1601)));
                            break;
                          }
                        }
                        _1611 = (log2(cb0_008w) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1615 = log2(max((lerp(_1528, _1526, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _1616 = _1615 * 0.3010300099849701f;
                  do {
                    if (!(!(_1616 <= _1542))) {
                      _1685 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _1623 = log2(cb0_009x);
                      float _1624 = _1623 * 0.3010300099849701f;
                      if ((bool)(_1616 > _1542) && (bool)(_1616 < _1624)) {
                        float _1632 = ((_1615 - _1541) * 0.9030900001525879f) / ((_1623 - _1541) * 0.3010300099849701f);
                        int _1633 = int(_1632);
                        float _1635 = _1632 - float((int)(_1633));
                        float _1637 = _19[_1633];
                        float _1640 = _19[(_1633 + 1)];
                        float _1645 = _1637 * 0.5f;
                        _1685 = dot(float3((_1635 * _1635), _1635, 1.0f), float3(mad((_19[(_1633 + 2)]), 0.5f, mad(_1640, -1.0f, _1645)), (_1640 - _1637), mad(_1640, 0.5f, _1645)));
                      } else {
                        do {
                          if (!(!(_1616 >= _1624))) {
                            float _1654 = log2(cb0_008z);
                            if (_1616 < (_1654 * 0.3010300099849701f)) {
                              float _1662 = ((_1615 - _1623) * 0.9030900001525879f) / ((_1654 - _1623) * 0.3010300099849701f);
                              int _1663 = int(_1662);
                              float _1665 = _1662 - float((int)(_1663));
                              float _1667 = _20[_1663];
                              float _1670 = _20[(_1663 + 1)];
                              float _1675 = _1667 * 0.5f;
                              _1685 = dot(float3((_1665 * _1665), _1665, 1.0f), float3(mad((_20[(_1663 + 2)]), 0.5f, mad(_1670, -1.0f, _1675)), (_1670 - _1667), mad(_1670, 0.5f, _1675)));
                              break;
                            }
                          }
                          _1685 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1689 = log2(max((lerp(_1528, _1527, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _1690 = _1689 * 0.3010300099849701f;
                    do {
                      if (!(!(_1690 <= _1542))) {
                        _1759 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _1697 = log2(cb0_009x);
                        float _1698 = _1697 * 0.3010300099849701f;
                        if ((bool)(_1690 > _1542) && (bool)(_1690 < _1698)) {
                          float _1706 = ((_1689 - _1541) * 0.9030900001525879f) / ((_1697 - _1541) * 0.3010300099849701f);
                          int _1707 = int(_1706);
                          float _1709 = _1706 - float((int)(_1707));
                          float _1711 = _19[_1707];
                          float _1714 = _19[(_1707 + 1)];
                          float _1719 = _1711 * 0.5f;
                          _1759 = dot(float3((_1709 * _1709), _1709, 1.0f), float3(mad((_19[(_1707 + 2)]), 0.5f, mad(_1714, -1.0f, _1719)), (_1714 - _1711), mad(_1714, 0.5f, _1719)));
                        } else {
                          do {
                            if (!(!(_1690 >= _1698))) {
                              float _1728 = log2(cb0_008z);
                              if (_1690 < (_1728 * 0.3010300099849701f)) {
                                float _1736 = ((_1689 - _1697) * 0.9030900001525879f) / ((_1728 - _1697) * 0.3010300099849701f);
                                int _1737 = int(_1736);
                                float _1739 = _1736 - float((int)(_1737));
                                float _1741 = _20[_1737];
                                float _1744 = _20[(_1737 + 1)];
                                float _1749 = _1741 * 0.5f;
                                _1759 = dot(float3((_1739 * _1739), _1739, 1.0f), float3(mad((_20[(_1737 + 2)]), 0.5f, mad(_1744, -1.0f, _1749)), (_1744 - _1741), mad(_1744, 0.5f, _1749)));
                                break;
                              }
                            }
                            _1759 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1763 = cb0_008w - cb0_008y;
                      float _1764 = (exp2(_1611 * 3.321928024291992f) - cb0_008y) / _1763;
                      float _1766 = (exp2(_1685 * 3.321928024291992f) - cb0_008y) / _1763;
                      float _1768 = (exp2(_1759 * 3.321928024291992f) - cb0_008y) / _1763;
                      float _1771 = mad(0.15618768334388733f, _1768, mad(0.13400420546531677f, _1766, (_1764 * 0.6624541878700256f)));
                      float _1774 = mad(0.053689517080783844f, _1768, mad(0.6740817427635193f, _1766, (_1764 * 0.2722287178039551f)));
                      float _1777 = mad(1.0103391408920288f, _1768, mad(0.00406073359772563f, _1766, (_1764 * -0.005574649665504694f)));
                      float _1790 = min(max(mad(-0.23642469942569733f, _1777, mad(-0.32480329275131226f, _1774, (_1771 * 1.6410233974456787f))), 0.0f), 1.0f);
                      float _1791 = min(max(mad(0.016756348311901093f, _1777, mad(1.6153316497802734f, _1774, (_1771 * -0.663662850856781f))), 0.0f), 1.0f);
                      float _1792 = min(max(mad(0.9883948564529419f, _1777, mad(-0.008284442126750946f, _1774, (_1771 * 0.011721894145011902f))), 0.0f), 1.0f);
                      float _1795 = mad(0.15618768334388733f, _1792, mad(0.13400420546531677f, _1791, (_1790 * 0.6624541878700256f)));
                      float _1798 = mad(0.053689517080783844f, _1792, mad(0.6740817427635193f, _1791, (_1790 * 0.2722287178039551f)));
                      float _1801 = mad(1.0103391408920288f, _1792, mad(0.00406073359772563f, _1791, (_1790 * -0.005574649665504694f)));
                      float _1823 = min(max((min(max(mad(-0.23642469942569733f, _1801, mad(-0.32480329275131226f, _1798, (_1795 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1824 = min(max((min(max(mad(0.016756348311901093f, _1801, mad(1.6153316497802734f, _1798, (_1795 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      float _1825 = min(max((min(max(mad(0.9883948564529419f, _1801, mad(-0.008284442126750946f, _1798, (_1795 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                      do {
                        if (!(output_device == 5)) {
                          _1838 = mad(_57, _1825, mad(_56, _1824, (_1823 * _55)));
                          _1839 = mad(_60, _1825, mad(_59, _1824, (_1823 * _58)));
                          _1840 = mad(_63, _1825, mad(_62, _1824, (_1823 * _61)));
                        } else {
                          _1838 = _1823;
                          _1839 = _1824;
                          _1840 = _1825;
                        }
                        float _1850 = exp2(log2(_1838 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1851 = exp2(log2(_1839 * 9.999999747378752e-05f) * 0.1593017578125f);
                        float _1852 = exp2(log2(_1840 * 9.999999747378752e-05f) * 0.1593017578125f);
                        _2593 = exp2(log2((1.0f / ((_1850 * 18.6875f) + 1.0f)) * ((_1850 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2594 = exp2(log2((1.0f / ((_1851 * 18.6875f) + 1.0f)) * ((_1851 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                        _2595 = exp2(log2((1.0f / ((_1852 * 18.6875f) + 1.0f)) * ((_1852 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
          float _1931 = cb0_012z * _1153;
          float _1932 = cb0_012z * _1154;
          float _1933 = cb0_012z * _1155;
          float _1936 = mad((UniformBufferConstants_WorkingColorSpace_256[0].z), _1933, mad((UniformBufferConstants_WorkingColorSpace_256[0].y), _1932, ((UniformBufferConstants_WorkingColorSpace_256[0].x) * _1931)));
          float _1939 = mad((UniformBufferConstants_WorkingColorSpace_256[1].z), _1933, mad((UniformBufferConstants_WorkingColorSpace_256[1].y), _1932, ((UniformBufferConstants_WorkingColorSpace_256[1].x) * _1931)));
          float _1942 = mad((UniformBufferConstants_WorkingColorSpace_256[2].z), _1933, mad((UniformBufferConstants_WorkingColorSpace_256[2].y), _1932, ((UniformBufferConstants_WorkingColorSpace_256[2].x) * _1931)));
          float _1946 = max(max(_1936, _1939), _1942);
          float _1951 = (max(_1946, 1.000000013351432e-10f) - max(min(min(_1936, _1939), _1942), 1.000000013351432e-10f)) / max(_1946, 0.009999999776482582f);
          float _1964 = ((_1939 + _1936) + _1942) + (sqrt((((_1942 - _1939) * _1942) + ((_1939 - _1936) * _1939)) + ((_1936 - _1942) * _1936)) * 1.75f);
          float _1965 = _1964 * 0.3333333432674408f;
          float _1966 = _1951 + -0.4000000059604645f;
          float _1967 = _1966 * 5.0f;
          float _1971 = max((1.0f - abs(_1966 * 2.5f)), 0.0f);
          float _1982 = ((float((int)(((int)(uint)((bool)(_1967 > 0.0f))) - ((int)(uint)((bool)(_1967 < 0.0f))))) * (1.0f - (_1971 * _1971))) + 1.0f) * 0.02500000037252903f;
          do {
            if (!(_1965 <= 0.0533333346247673f)) {
              if (!(_1965 >= 0.1599999964237213f)) {
                _1991 = (((0.23999999463558197f / _1964) + -0.5f) * _1982);
              } else {
                _1991 = 0.0f;
              }
            } else {
              _1991 = _1982;
            }
            float _1992 = _1991 + 1.0f;
            float _1993 = _1992 * _1936;
            float _1994 = _1992 * _1939;
            float _1995 = _1992 * _1942;
            do {
              if (!((bool)(_1993 == _1994) && (bool)(_1994 == _1995))) {
                float _2002 = ((_1993 * 2.0f) - _1994) - _1995;
                float _2005 = ((_1939 - _1942) * 1.7320507764816284f) * _1992;
                float _2007 = atan(_2005 / _2002);
                bool _2010 = (_2002 < 0.0f);
                bool _2011 = (_2002 == 0.0f);
                bool _2012 = (_2005 >= 0.0f);
                bool _2013 = (_2005 < 0.0f);
                float _2022 = select((_2012 && _2011), 90.0f, select((_2013 && _2011), -90.0f, (select((_2013 && _2010), (_2007 + -3.1415927410125732f), select((_2012 && _2010), (_2007 + 3.1415927410125732f), _2007)) * 57.2957763671875f)));
                if (_2022 < 0.0f) {
                  _2027 = (_2022 + 360.0f);
                } else {
                  _2027 = _2022;
                }
              } else {
                _2027 = 0.0f;
              }
              float _2029 = min(max(_2027, 0.0f), 360.0f);
              do {
                if (_2029 < -180.0f) {
                  _2038 = (_2029 + 360.0f);
                } else {
                  if (_2029 > 180.0f) {
                    _2038 = (_2029 + -360.0f);
                  } else {
                    _2038 = _2029;
                  }
                }
                do {
                  if ((bool)(_2038 > -67.5f) && (bool)(_2038 < 67.5f)) {
                    float _2044 = (_2038 + 67.5f) * 0.029629629105329514f;
                    int _2045 = int(_2044);
                    float _2047 = _2044 - float((int)(_2045));
                    float _2048 = _2047 * _2047;
                    float _2049 = _2048 * _2047;
                    if (_2045 == 3) {
                      _2077 = (((0.1666666716337204f - (_2047 * 0.5f)) + (_2048 * 0.5f)) - (_2049 * 0.1666666716337204f));
                    } else {
                      if (_2045 == 2) {
                        _2077 = ((0.6666666865348816f - _2048) + (_2049 * 0.5f));
                      } else {
                        if (_2045 == 1) {
                          _2077 = (((_2049 * -0.5f) + 0.1666666716337204f) + ((_2048 + _2047) * 0.5f));
                        } else {
                          _2077 = select((_2045 == 0), (_2049 * 0.1666666716337204f), 0.0f);
                        }
                      }
                    }
                  } else {
                    _2077 = 0.0f;
                  }
                  float _2086 = min(max(((((_1951 * 0.27000001072883606f) * (0.029999999329447746f - _1993)) * _2077) + _1993), 0.0f), 65535.0f);
                  float _2087 = min(max(_1994, 0.0f), 65535.0f);
                  float _2088 = min(max(_1995, 0.0f), 65535.0f);
                  float _2101 = min(max(mad(-0.21492856740951538f, _2088, mad(-0.2365107536315918f, _2087, (_2086 * 1.4514392614364624f))), 0.0f), 65504.0f);
                  float _2102 = min(max(mad(-0.09967592358589172f, _2088, mad(1.17622971534729f, _2087, (_2086 * -0.07655377686023712f))), 0.0f), 65504.0f);
                  float _2103 = min(max(mad(0.9977163076400757f, _2088, mad(-0.006032449658960104f, _2087, (_2086 * 0.008316148072481155f))), 0.0f), 65504.0f);
                  float _2104 = dot(float3(_2101, _2102, _2103), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2115 = log2(max((lerp(_2104, _2101, 0.9599999785423279f)), 1.000000013351432e-10f));
                  float _2116 = _2115 * 0.3010300099849701f;
                  float _2117 = log2(cb0_008x);
                  float _2118 = _2117 * 0.3010300099849701f;
                  do {
                    if (!(!(_2116 <= _2118))) {
                      _2187 = (log2(cb0_008y) * 0.3010300099849701f);
                    } else {
                      float _2125 = log2(cb0_009x);
                      float _2126 = _2125 * 0.3010300099849701f;
                      if ((bool)(_2116 > _2118) && (bool)(_2116 < _2126)) {
                        float _2134 = ((_2115 - _2117) * 0.9030900001525879f) / ((_2125 - _2117) * 0.3010300099849701f);
                        int _2135 = int(_2134);
                        float _2137 = _2134 - float((int)(_2135));
                        float _2139 = _17[_2135];
                        float _2142 = _17[(_2135 + 1)];
                        float _2147 = _2139 * 0.5f;
                        _2187 = dot(float3((_2137 * _2137), _2137, 1.0f), float3(mad((_17[(_2135 + 2)]), 0.5f, mad(_2142, -1.0f, _2147)), (_2142 - _2139), mad(_2142, 0.5f, _2147)));
                      } else {
                        do {
                          if (!(!(_2116 >= _2126))) {
                            float _2156 = log2(cb0_008z);
                            if (_2116 < (_2156 * 0.3010300099849701f)) {
                              float _2164 = ((_2115 - _2125) * 0.9030900001525879f) / ((_2156 - _2125) * 0.3010300099849701f);
                              int _2165 = int(_2164);
                              float _2167 = _2164 - float((int)(_2165));
                              float _2169 = _18[_2165];
                              float _2172 = _18[(_2165 + 1)];
                              float _2177 = _2169 * 0.5f;
                              _2187 = dot(float3((_2167 * _2167), _2167, 1.0f), float3(mad((_18[(_2165 + 2)]), 0.5f, mad(_2172, -1.0f, _2177)), (_2172 - _2169), mad(_2172, 0.5f, _2177)));
                              break;
                            }
                          }
                          _2187 = (log2(cb0_008w) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2191 = log2(max((lerp(_2104, _2102, 0.9599999785423279f)), 1.000000013351432e-10f));
                    float _2192 = _2191 * 0.3010300099849701f;
                    do {
                      if (!(!(_2192 <= _2118))) {
                        _2261 = (log2(cb0_008y) * 0.3010300099849701f);
                      } else {
                        float _2199 = log2(cb0_009x);
                        float _2200 = _2199 * 0.3010300099849701f;
                        if ((bool)(_2192 > _2118) && (bool)(_2192 < _2200)) {
                          float _2208 = ((_2191 - _2117) * 0.9030900001525879f) / ((_2199 - _2117) * 0.3010300099849701f);
                          int _2209 = int(_2208);
                          float _2211 = _2208 - float((int)(_2209));
                          float _2213 = _17[_2209];
                          float _2216 = _17[(_2209 + 1)];
                          float _2221 = _2213 * 0.5f;
                          _2261 = dot(float3((_2211 * _2211), _2211, 1.0f), float3(mad((_17[(_2209 + 2)]), 0.5f, mad(_2216, -1.0f, _2221)), (_2216 - _2213), mad(_2216, 0.5f, _2221)));
                        } else {
                          do {
                            if (!(!(_2192 >= _2200))) {
                              float _2230 = log2(cb0_008z);
                              if (_2192 < (_2230 * 0.3010300099849701f)) {
                                float _2238 = ((_2191 - _2199) * 0.9030900001525879f) / ((_2230 - _2199) * 0.3010300099849701f);
                                int _2239 = int(_2238);
                                float _2241 = _2238 - float((int)(_2239));
                                float _2243 = _18[_2239];
                                float _2246 = _18[(_2239 + 1)];
                                float _2251 = _2243 * 0.5f;
                                _2261 = dot(float3((_2241 * _2241), _2241, 1.0f), float3(mad((_18[(_2239 + 2)]), 0.5f, mad(_2246, -1.0f, _2251)), (_2246 - _2243), mad(_2246, 0.5f, _2251)));
                                break;
                              }
                            }
                            _2261 = (log2(cb0_008w) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2265 = log2(max((lerp(_2104, _2103, 0.9599999785423279f)), 1.000000013351432e-10f));
                      float _2266 = _2265 * 0.3010300099849701f;
                      do {
                        if (!(!(_2266 <= _2118))) {
                          _2335 = (log2(cb0_008y) * 0.3010300099849701f);
                        } else {
                          float _2273 = log2(cb0_009x);
                          float _2274 = _2273 * 0.3010300099849701f;
                          if ((bool)(_2266 > _2118) && (bool)(_2266 < _2274)) {
                            float _2282 = ((_2265 - _2117) * 0.9030900001525879f) / ((_2273 - _2117) * 0.3010300099849701f);
                            int _2283 = int(_2282);
                            float _2285 = _2282 - float((int)(_2283));
                            float _2287 = _17[_2283];
                            float _2290 = _17[(_2283 + 1)];
                            float _2295 = _2287 * 0.5f;
                            _2335 = dot(float3((_2285 * _2285), _2285, 1.0f), float3(mad((_17[(_2283 + 2)]), 0.5f, mad(_2290, -1.0f, _2295)), (_2290 - _2287), mad(_2290, 0.5f, _2295)));
                          } else {
                            do {
                              if (!(!(_2266 >= _2274))) {
                                float _2304 = log2(cb0_008z);
                                if (_2266 < (_2304 * 0.3010300099849701f)) {
                                  float _2312 = ((_2265 - _2273) * 0.9030900001525879f) / ((_2304 - _2273) * 0.3010300099849701f);
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
                        float _2339 = cb0_008w - cb0_008y;
                        float _2340 = (exp2(_2187 * 3.321928024291992f) - cb0_008y) / _2339;
                        float _2342 = (exp2(_2261 * 3.321928024291992f) - cb0_008y) / _2339;
                        float _2344 = (exp2(_2335 * 3.321928024291992f) - cb0_008y) / _2339;
                        float _2347 = mad(0.15618768334388733f, _2344, mad(0.13400420546531677f, _2342, (_2340 * 0.6624541878700256f)));
                        float _2350 = mad(0.053689517080783844f, _2344, mad(0.6740817427635193f, _2342, (_2340 * 0.2722287178039551f)));
                        float _2353 = mad(1.0103391408920288f, _2344, mad(0.00406073359772563f, _2342, (_2340 * -0.005574649665504694f)));
                        float _2366 = min(max(mad(-0.23642469942569733f, _2353, mad(-0.32480329275131226f, _2350, (_2347 * 1.6410233974456787f))), 0.0f), 1.0f);
                        float _2367 = min(max(mad(0.016756348311901093f, _2353, mad(1.6153316497802734f, _2350, (_2347 * -0.663662850856781f))), 0.0f), 1.0f);
                        float _2368 = min(max(mad(0.9883948564529419f, _2353, mad(-0.008284442126750946f, _2350, (_2347 * 0.011721894145011902f))), 0.0f), 1.0f);
                        float _2371 = mad(0.15618768334388733f, _2368, mad(0.13400420546531677f, _2367, (_2366 * 0.6624541878700256f)));
                        float _2374 = mad(0.053689517080783844f, _2368, mad(0.6740817427635193f, _2367, (_2366 * 0.2722287178039551f)));
                        float _2377 = mad(1.0103391408920288f, _2368, mad(0.00406073359772563f, _2367, (_2366 * -0.005574649665504694f)));
                        float _2399 = min(max((min(max(mad(-0.23642469942569733f, _2377, mad(-0.32480329275131226f, _2374, (_2371 * 1.6410233974456787f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2400 = min(max((min(max(mad(0.016756348311901093f, _2377, mad(1.6153316497802734f, _2374, (_2371 * -0.663662850856781f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        float _2401 = min(max((min(max(mad(0.9883948564529419f, _2377, mad(-0.008284442126750946f, _2374, (_2371 * 0.011721894145011902f))), 0.0f), 65535.0f) * cb0_008w), 0.0f), 65535.0f);
                        do {
                          if (!(output_device == 6)) {
                            _2414 = mad(_57, _2401, mad(_56, _2400, (_2399 * _55)));
                            _2415 = mad(_60, _2401, mad(_59, _2400, (_2399 * _58)));
                            _2416 = mad(_63, _2401, mad(_62, _2400, (_2399 * _61)));
                          } else {
                            _2414 = _2399;
                            _2415 = _2400;
                            _2416 = _2401;
                          }
                          float _2426 = exp2(log2(_2414 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2427 = exp2(log2(_2415 * 9.999999747378752e-05f) * 0.1593017578125f);
                          float _2428 = exp2(log2(_2416 * 9.999999747378752e-05f) * 0.1593017578125f);
                          _2593 = exp2(log2((1.0f / ((_2426 * 18.6875f) + 1.0f)) * ((_2426 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2594 = exp2(log2((1.0f / ((_2427 * 18.6875f) + 1.0f)) * ((_2427 * 18.8515625f) + 0.8359375f)) * 78.84375f);
                          _2595 = exp2(log2((1.0f / ((_2428 * 18.6875f) + 1.0f)) * ((_2428 * 18.8515625f) + 0.8359375f)) * 78.84375f);
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
            float _2473 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1155, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1154, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1153)));
            float _2476 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1155, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1154, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1153)));
            float _2479 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1155, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1154, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1153)));
            float _2498 = exp2(log2(mad(_57, _2479, mad(_56, _2476, (_2473 * _55))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2499 = exp2(log2(mad(_60, _2479, mad(_59, _2476, (_2473 * _58))) * 9.999999747378752e-05f) * 0.1593017578125f);
            float _2500 = exp2(log2(mad(_63, _2479, mad(_62, _2476, (_2473 * _61))) * 9.999999747378752e-05f) * 0.1593017578125f);
            _2593 = exp2(log2((1.0f / ((_2498 * 18.6875f) + 1.0f)) * ((_2498 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2594 = exp2(log2((1.0f / ((_2499 * 18.6875f) + 1.0f)) * ((_2499 * 18.8515625f) + 0.8359375f)) * 78.84375f);
            _2595 = exp2(log2((1.0f / ((_2500 * 18.6875f) + 1.0f)) * ((_2500 * 18.8515625f) + 0.8359375f)) * 78.84375f);
          } else {
            if (!(output_device == 8)) {
              if (output_device == 9) {
                float _2547 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1143, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1142, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1141)));
                float _2550 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1143, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1142, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1141)));
                float _2553 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1143, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1142, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1141)));
                _2593 = mad(_57, _2553, mad(_56, _2550, (_2547 * _55)));
                _2594 = mad(_60, _2553, mad(_59, _2550, (_2547 * _58)));
                _2595 = mad(_63, _2553, mad(_62, _2550, (_2547 * _61)));
              } else {
                float _2566 = mad((UniformBufferConstants_WorkingColorSpace_128[0].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[0].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[0].x) * _1167)));
                float _2569 = mad((UniformBufferConstants_WorkingColorSpace_128[1].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[1].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[1].x) * _1167)));
                float _2572 = mad((UniformBufferConstants_WorkingColorSpace_128[2].z), _1169, mad((UniformBufferConstants_WorkingColorSpace_128[2].y), _1168, ((UniformBufferConstants_WorkingColorSpace_128[2].x) * _1167)));
                _2593 = exp2(log2(mad(_57, _2572, mad(_56, _2569, (_2566 * _55)))) * cb0_040z);
                _2594 = exp2(log2(mad(_60, _2572, mad(_59, _2569, (_2566 * _58)))) * cb0_040z);
                _2595 = exp2(log2(mad(_63, _2572, mad(_62, _2569, (_2566 * _61)))) * cb0_040z);
              }
            } else {
              _2593 = _1153;
              _2594 = _1154;
              _2595 = _1155;
            }
          }
        }
      }
    }
  }
  u0[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((_2593 * 0.9523810148239136f), (_2594 * 0.9523810148239136f), (_2595 * 0.9523810148239136f), 0.0f);
}
