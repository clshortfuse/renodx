#include "../common.hlsl"

RWTexture3D<float> RWOutputTexture : register(u0);

cbuffer cb0 : register(b0) {
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
  uint cb0_041x : packoffset(c041.x);
  float cb0_042x : packoffset(c042.x);
  float cb0_042y : packoffset(c042.y);
};

cbuffer UniformBufferConstants_WorkingColorSpace : register(b1) {
  float UniformBufferConstants_WorkingColorSpace_008x : packoffset(c008.x);
  float UniformBufferConstants_WorkingColorSpace_008y : packoffset(c008.y);
  float UniformBufferConstants_WorkingColorSpace_008z : packoffset(c008.z);
  float UniformBufferConstants_WorkingColorSpace_009x : packoffset(c009.x);
  float UniformBufferConstants_WorkingColorSpace_009y : packoffset(c009.y);
  float UniformBufferConstants_WorkingColorSpace_009z : packoffset(c009.z);
  float UniformBufferConstants_WorkingColorSpace_010x : packoffset(c010.x);
  float UniformBufferConstants_WorkingColorSpace_010y : packoffset(c010.y);
  float UniformBufferConstants_WorkingColorSpace_010z : packoffset(c010.z);
  float UniformBufferConstants_WorkingColorSpace_012x : packoffset(c012.x);
  float UniformBufferConstants_WorkingColorSpace_012y : packoffset(c012.y);
  float UniformBufferConstants_WorkingColorSpace_012z : packoffset(c012.z);
  float UniformBufferConstants_WorkingColorSpace_013x : packoffset(c013.x);
  float UniformBufferConstants_WorkingColorSpace_013y : packoffset(c013.y);
  float UniformBufferConstants_WorkingColorSpace_013z : packoffset(c013.z);
  float UniformBufferConstants_WorkingColorSpace_014x : packoffset(c014.x);
  float UniformBufferConstants_WorkingColorSpace_014y : packoffset(c014.y);
  float UniformBufferConstants_WorkingColorSpace_014z : packoffset(c014.z);
  uint UniformBufferConstants_WorkingColorSpace_020x : packoffset(c020.x);
};

[numthreads(8, 8, 8)]
void main(
 uint3 SV_DispatchThreadID : SV_DispatchThreadID,
 uint3 SV_GroupID : SV_GroupID,
 uint3 SV_GroupThreadID : SV_GroupThreadID,
 uint SV_GroupIndex : SV_GroupIndex
) {
  float _20 = 0.5f / (cb0_035x);
  float _25 = (cb0_035x) + -1.0f;
  float _49 = 1.3792141675949097f;
  float _50 = -0.30886411666870117f;
  float _51 = -0.0703500509262085f;
  float _52 = -0.06933490186929703f;
  float _53 = 1.08229660987854f;
  float _54 = -0.012961871922016144f;
  float _55 = -0.0021590073592960835f;
  float _56 = -0.0454593189060688f;
  float _57 = 1.0476183891296387f;
  float _574;
  float _607;
  float _621;
  float _685;
  float _937;
  float _938;
  float _939;
  float _950;
  float _961;
  float _972;
  if (!((((uint)(cb0_041x)) == 1))) {
    _49 = 1.0258246660232544f;
    _50 = -0.020053181797266006f;
    _51 = -0.005771636962890625f;
    _52 = -0.002234415616840124f;
    _53 = 1.0045864582061768f;
    _54 = -0.002352118492126465f;
    _55 = -0.005013350863009691f;
    _56 = -0.025290070101618767f;
    _57 = 1.0303035974502563f;
    if (!((((uint)(cb0_041x)) == 2))) {
      _49 = 0.6954522132873535f;
      _50 = 0.14067870378494263f;
      _51 = 0.16386906802654266f;
      _52 = 0.044794563204050064f;
      _53 = 0.8596711158752441f;
      _54 = 0.0955343171954155f;
      _55 = -0.005525882821530104f;
      _56 = 0.004025210160762072f;
      _57 = 1.0015007257461548f;
      if (!((((uint)(cb0_041x)) == 3))) {
        bool _38 = (((uint)(cb0_041x)) == 4);
        _49 = ((_38 ? 1.0f : 1.705051064491272f));
        _50 = ((_38 ? 0.0f : -0.6217921376228333f));
        _51 = ((_38 ? 0.0f : -0.0832589864730835f));
        _52 = ((_38 ? 0.0f : -0.13025647401809692f));
        _53 = ((_38 ? 1.0f : 1.140804648399353f));
        _54 = ((_38 ? 0.0f : -0.010548308491706848f));
        _55 = ((_38 ? 0.0f : -0.024003351107239723f));
        _56 = ((_38 ? 0.0f : -0.1289689838886261f));
        _57 = ((_38 ? 1.0f : 1.1529725790023804f));
      }
    }
  }
  float _70 = ((exp2((((((cb0_035x) * (((cb0_042x) * ((float((uint)(SV_DispatchThreadID.x))) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f;
  float _71 = ((exp2((((((cb0_035x) * (((cb0_042y) * ((float((uint)(SV_DispatchThreadID.y))) + 0.5f)) - _20)) / _25) + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f;
  float _72 = ((exp2(((((float((uint)(SV_DispatchThreadID.z))) / _25) + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f;
  float _87 = mad((UniformBufferConstants_WorkingColorSpace_008z), _72, (mad((UniformBufferConstants_WorkingColorSpace_008y), _71, ((UniformBufferConstants_WorkingColorSpace_008x) * _70))));
  float _90 = mad((UniformBufferConstants_WorkingColorSpace_009z), _72, (mad((UniformBufferConstants_WorkingColorSpace_009y), _71, ((UniformBufferConstants_WorkingColorSpace_009x) * _70))));
  float _93 = mad((UniformBufferConstants_WorkingColorSpace_010z), _72, (mad((UniformBufferConstants_WorkingColorSpace_010y), _71, ((UniformBufferConstants_WorkingColorSpace_010x) * _70))));
  float _94 = dot(float3(_87, _90, _93), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _98 = (_87 / _94) + -1.0f;
  float _99 = (_90 / _94) + -1.0f;
  float _100 = (_93 / _94) + -1.0f;
  float _112 = (1.0f - (exp2((((_94 * _94) * -4.0f) * (cb0_036w))))) * (1.0f - (exp2(((dot(float3(_98, _99, _100), float3(_98, _99, _100))) * -4.0f))));
  float _128 = (((mad(-0.06368321925401688f, _93, (mad(-0.3292922377586365f, _90, (_87 * 1.3704125881195068f))))) - _87) * _112) + _87;
  float _129 = (((mad(-0.010861365124583244f, _93, (mad(1.0970927476882935f, _90, (_87 * -0.08343357592821121f))))) - _90) * _112) + _90;
  float _130 = (((mad(1.2036951780319214f, _93, (mad(-0.09862580895423889f, _90, (_87 * -0.02579331398010254f))))) - _93) * _112) + _93;
  float _131 = dot(float3(_128, _129, _130), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _145 = (cb0_019w) + (cb0_024w);
  float _159 = (cb0_018w) * (cb0_023w);
  float _173 = (cb0_017w) * (cb0_022w);
  float _187 = (cb0_016w) * (cb0_021w);
  float _201 = (cb0_015w) * (cb0_020w);
  float _205 = _128 - _131;
  float _206 = _129 - _131;
  float _207 = _130 - _131;
  float _264 = saturate((_131 / (cb0_035w)));
  float _268 = (_264 * _264) * (3.0f - (_264 * 2.0f));
  float _269 = 1.0f - _268;
  float _278 = (cb0_019w) + (cb0_034w);
  float _287 = (cb0_018w) * (cb0_033w);
  float _296 = (cb0_017w) * (cb0_032w);
  float _305 = (cb0_016w) * (cb0_031w);
  float _314 = (cb0_015w) * (cb0_030w);
  float _377 = saturate(((_131 - (cb0_036x)) / ((cb0_036y) - (cb0_036x))));
  float _381 = (_377 * _377) * (3.0f - (_377 * 2.0f));
  float _390 = (cb0_019w) + (cb0_029w);
  float _399 = (cb0_018w) * (cb0_028w);
  float _408 = (cb0_017w) * (cb0_027w);
  float _417 = (cb0_016w) * (cb0_026w);
  float _426 = (cb0_015w) * (cb0_025w);
  float _484 = _268 - _381;
  float _495 = ((_381 * ((((cb0_019x) + (cb0_034x)) + _278) + ((((cb0_018x) * (cb0_033x)) * _287) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_031x)) * _305) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_030x)) * _314) * _205) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_032x)) * _296)))))))) + (_269 * ((((cb0_019x) + (cb0_024x)) + _145) + ((((cb0_018x) * (cb0_023x)) * _159) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_021x)) * _187) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_020x)) * _201) * _205) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_022x)) * _173))))))))) + (((((cb0_019x) + (cb0_029x)) + _390) + ((((cb0_018x) * (cb0_028x)) * _399) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_026x)) * _417) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_025x)) * _426) * _205) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_027x)) * _408))))))) * _484);
  float _497 = ((_381 * ((((cb0_019y) + (cb0_034y)) + _278) + ((((cb0_018y) * (cb0_033y)) * _287) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_031y)) * _305) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_030y)) * _314) * _206) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_032y)) * _296)))))))) + (_269 * ((((cb0_019y) + (cb0_024y)) + _145) + ((((cb0_018y) * (cb0_023y)) * _159) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_021y)) * _187) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_020y)) * _201) * _206) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_022y)) * _173))))))))) + (((((cb0_019y) + (cb0_029y)) + _390) + ((((cb0_018y) * (cb0_028y)) * _399) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_026y)) * _417) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_025y)) * _426) * _206) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_027y)) * _408))))))) * _484);
  float _499 = ((_381 * ((((cb0_019z) + (cb0_034z)) + _278) + ((((cb0_018z) * (cb0_033z)) * _287) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_031z)) * _305) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_030z)) * _314) * _207) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_032z)) * _296)))))))) + (_269 * ((((cb0_019z) + (cb0_024z)) + _145) + ((((cb0_018z) * (cb0_023z)) * _159) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_021z)) * _187) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_020z)) * _201) * _207) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_022z)) * _173))))))))) + (((((cb0_019z) + (cb0_029z)) + _390) + ((((cb0_018z) * (cb0_028z)) * _399) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_026z)) * _417) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_025z)) * _426) * _207) + _131))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_027z)) * _408))))))) * _484);
        float3 untonemapped_ap1 = float3(_495, _497, _499);  // CustomEdit

  float _514 = (((mad(0.061360642313957214f, _499, (mad(-4.540197551250458e-09f, _497, (_495 * 0.9386394023895264f))))) - _495) * (cb0_036z)) + _495;
  float _515 = (((mad(0.169205904006958f, _499, (mad(0.8307942152023315f, _497, (_495 * 6.775371730327606e-08f))))) - _497) * (cb0_036z)) + _497;
  float _516 = ((mad(-2.3283064365386963e-10f, _497, (_495 * -9.313225746154785e-10f))) * (cb0_036z)) + _499;
  float _519 = mad(0.16386905312538147f, _516, (mad(0.14067868888378143f, _515, (_514 * 0.6954522132873535f))));
  float _522 = mad(0.0955343246459961f, _516, (mad(0.8596711158752441f, _515, (_514 * 0.044794581830501556f))));
  float _525 = mad(1.0015007257461548f, _516, (mad(0.004025210160762072f, _515, (_514 * -0.005525882821530104f))));
  float _529 = max((max(_519, _522)), _525);
  float _534 = ((max(_529, 1.000000013351432e-10f)) - (max((min((min(_519, _522)), _525)), 1.000000013351432e-10f))) / (max(_529, 0.009999999776482582f));
  float _547 = ((_522 + _519) + _525) + ((sqrt(((((_525 - _522) * _525) + ((_522 - _519) * _522)) + ((_519 - _525) * _519)))) * 1.75f);
  float _548 = _547 * 0.3333333432674408f;
  float _549 = _534 + -0.4000000059604645f;
  float _550 = _549 * 5.0f;
  float _554 = max((1.0f - (abs((_549 * 2.5f)))), 0.0f);
  float _565 = (((float(((int(((bool)((_550 > 0.0f))))) - (int(((bool)((_550 < 0.0f)))))))) * (1.0f - (_554 * _554))) + 1.0f) * 0.02500000037252903f;
  _574 = _565;
  if ((!(_548 <= 0.0533333346247673f))) {
    _574 = 0.0f;
    if ((!(_548 >= 0.1599999964237213f))) {
      _574 = (((0.23999999463558197f / _547) + -0.5f) * _565);
    }
  }
  float _575 = _574 + 1.0f;
  float _576 = _575 * _519;
  float _577 = _575 * _522;
  float _578 = _575 * _525;
  _607 = 0.0f;
  if (!(((bool)((_576 == _577))) && ((bool)((_577 == _578))))) {
    float _585 = ((_576 * 2.0f) - _577) - _578;
    float _588 = ((_522 - _525) * 1.7320507764816284f) * _575;
    float _590 = atan((_588 / _585));
    bool _593 = (_585 < 0.0f);
    bool _594 = (_585 == 0.0f);
    bool _595 = (_588 >= 0.0f);
    bool _596 = (_588 < 0.0f);
    _607 = ((((bool)(_595 && _594)) ? 90.0f : ((((bool)(_596 && _594)) ? -90.0f : (((((bool)(_596 && _593)) ? (_590 + -3.1415927410125732f) : ((((bool)(_595 && _593)) ? (_590 + 3.1415927410125732f) : _590)))) * 57.2957763671875f)))));
  }
  float _612 = min((max(((((bool)((_607 < 0.0f))) ? (_607 + 360.0f) : _607)), 0.0f)), 360.0f);
  if (((_612 < -180.0f))) {
    _621 = (_612 + 360.0f);
  } else {
    _621 = _612;
    if (((_612 > 180.0f))) {
      _621 = (_612 + -360.0f);
    }
  }
  float _625 = saturate((1.0f - (abs((_621 * 0.014814814552664757f)))));
  float _629 = (_625 * _625) * (3.0f - (_625 * 2.0f));
  float _635 = ((_629 * _629) * ((_534 * 0.18000000715255737f) * (0.029999999329447746f - _576))) + _576;
  float _645 = max(0.0f, (mad(-0.21492856740951538f, _578, (mad(-0.2365107536315918f, _577, (_635 * 1.4514392614364624f))))));
  float _646 = max(0.0f, (mad(-0.09967592358589172f, _578, (mad(1.17622971534729f, _577, (_635 * -0.07655377686023712f))))));
  float _647 = max(0.0f, (mad(0.9977163076400757f, _578, (mad(-0.006032449658960104f, _577, (_635 * 0.008316148072481155f))))));
  float _648 = dot(float3(_645, _646, _647), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _663 = ((cb0_038x) + 1.0f) - (cb0_037z);
  float _665 = (cb0_038y) + 1.0f;
  float _667 = _665 - (cb0_037w);
  if ((((cb0_037z) > 0.800000011920929f))) {
    _685 = (((0.8199999928474426f - (cb0_037z)) / (cb0_037y)) + -0.7447274923324585f);
  } else {
    float _676 = ((cb0_038x) + 0.18000000715255737f) / _663;
    _685 = (-0.7447274923324585f - (((log2((_676 / (2.0f - _676)))) * 0.3465735912322998f) * (_663 / (cb0_037y))));
  }
  float _688 = ((1.0f - (cb0_037z)) / (cb0_037y)) - _685;
  float _690 = ((cb0_037w) / (cb0_037y)) - _688;
  float _694 = (log2((((_645 - _648) * 0.9599999785423279f) + _648))) * 0.3010300099849701f;
  float _695 = (log2((((_646 - _648) * 0.9599999785423279f) + _648))) * 0.3010300099849701f;
  float _696 = (log2((((_647 - _648) * 0.9599999785423279f) + _648))) * 0.3010300099849701f;
  float _700 = (cb0_037y) * (_694 + _688);
  float _701 = (cb0_037y) * (_695 + _688);
  float _702 = (cb0_037y) * (_696 + _688);
  float _703 = _663 * 2.0f;
  float _705 = ((cb0_037y) * -2.0f) / _663;
  float _706 = _694 - _685;
  float _707 = _695 - _685;
  float _708 = _696 - _685;
  float _727 = _667 * 2.0f;
  float _729 = ((cb0_037y) * 2.0f) / _667;
  float _754 = (((bool)((_694 < _685))) ? ((_703 / ((exp2(((_706 * 1.4426950216293335f) * _705))) + 1.0f)) - (cb0_038x)) : _700);
  float _755 = (((bool)((_695 < _685))) ? ((_703 / ((exp2(((_707 * 1.4426950216293335f) * _705))) + 1.0f)) - (cb0_038x)) : _701);
  float _756 = (((bool)((_696 < _685))) ? ((_703 / ((exp2(((_708 * 1.4426950216293335f) * _705))) + 1.0f)) - (cb0_038x)) : _702);
  float _763 = _690 - _685;
  float _767 = saturate((_706 / _763));
  float _768 = saturate((_707 / _763));
  float _769 = saturate((_708 / _763));
  bool _770 = (_690 < _685);
  float _774 = (_770 ? (1.0f - _767) : _767);
  float _775 = (_770 ? (1.0f - _768) : _768);
  float _776 = (_770 ? (1.0f - _769) : _769);
  float _795 = (((_774 * _774) * (((((bool)((_694 > _690))) ? (_665 - (_727 / ((exp2((((_694 - _690) * 1.4426950216293335f) * _729))) + 1.0f))) : _700)) - _754)) * (3.0f - (_774 * 2.0f))) + _754;
  float _796 = (((_775 * _775) * (((((bool)((_695 > _690))) ? (_665 - (_727 / ((exp2((((_695 - _690) * 1.4426950216293335f) * _729))) + 1.0f))) : _701)) - _755)) * (3.0f - (_775 * 2.0f))) + _755;
  float _797 = (((_776 * _776) * (((((bool)((_696 > _690))) ? (_665 - (_727 / ((exp2((((_696 - _690) * 1.4426950216293335f) * _729))) + 1.0f))) : _702)) - _756)) * (3.0f - (_776 * 2.0f))) + _756;
  float _798 = dot(float3(_795, _796, _797), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _818 = ((cb0_037x) * ((max(0.0f, (((_795 - _798) * 0.9300000071525574f) + _798))) - _514)) + _514;
  float _819 = ((cb0_037x) * ((max(0.0f, (((_796 - _798) * 0.9300000071525574f) + _798))) - _515)) + _515;
  float _820 = ((cb0_037x) * ((max(0.0f, (((_797 - _798) * 0.9300000071525574f) + _798))) - _516)) + _516;
  float _836 = (((mad(-0.06537103652954102f, _820, (mad(1.451815478503704e-06f, _819, (_818 * 1.065374732017517f))))) - _818) * (cb0_036z)) + _818;
  float _837 = (((mad(-0.20366770029067993f, _820, (mad(1.2036634683609009f, _819, (_818 * -2.57161445915699e-07f))))) - _819) * (cb0_036z)) + _819;
  float _838 = (((mad(0.9999996423721313f, _820, (mad(2.0954757928848267e-08f, _819, (_818 * 1.862645149230957e-08f))))) - _820) * (cb0_036z)) + _820;
  float _860 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_012z), _838, (mad((UniformBufferConstants_WorkingColorSpace_012y), _837, ((UniformBufferConstants_WorkingColorSpace_012x) * _836))))));
  float _861 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_013z), _838, (mad((UniformBufferConstants_WorkingColorSpace_013y), _837, ((UniformBufferConstants_WorkingColorSpace_013x) * _836))))));
  float _862 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_014z), _838, (mad((UniformBufferConstants_WorkingColorSpace_014y), _837, ((UniformBufferConstants_WorkingColorSpace_014x) * _836))))));
  float _888 = (cb0_014x) * ((((cb0_039y) + ((cb0_039x) * _860)) * _860) + (cb0_039z));
  float _889 = (cb0_014y) * ((((cb0_039y) + ((cb0_039x) * _861)) * _861) + (cb0_039z));
  float _890 = (cb0_014z) * ((((cb0_039y) + ((cb0_039x) * _862)) * _862) + (cb0_039z));
  float _911 = exp2(((log2((max(0.0f, ((((cb0_013x) - _888) * (cb0_013w)) + _888))))) * (cb0_040y)));
  float _912 = exp2(((log2((max(0.0f, ((((cb0_013y) - _889) * (cb0_013w)) + _889))))) * (cb0_040y)));
  float _913 = exp2(((log2((max(0.0f, ((((cb0_013z) - _890) * (cb0_013w)) + _890))))) * (cb0_040y)));
  _937 = _911;
  _938 = _912;
  _939 = _913;

        // CustomEdit
  if (RENODX_TONE_MAP_TYPE != 0) {
    RWOutputTexture[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))]  = LutBuilderToneMap(untonemapped_ap1, float3(_937, _938, _939));
    return;
  }

  if (((((uint)(UniformBufferConstants_WorkingColorSpace_020x)) == 0))) {
    float _920 = mad((UniformBufferConstants_WorkingColorSpace_008z), _913, (mad((UniformBufferConstants_WorkingColorSpace_008y), _912, ((UniformBufferConstants_WorkingColorSpace_008x) * _911))));
    float _923 = mad((UniformBufferConstants_WorkingColorSpace_009z), _913, (mad((UniformBufferConstants_WorkingColorSpace_009y), _912, ((UniformBufferConstants_WorkingColorSpace_009x) * _911))));
    float _926 = mad((UniformBufferConstants_WorkingColorSpace_010z), _913, (mad((UniformBufferConstants_WorkingColorSpace_010y), _912, ((UniformBufferConstants_WorkingColorSpace_010x) * _911))));
    _937 = (mad(_51, _926, (mad(_50, _923, (_920 * _49)))));
    _938 = (mad(_54, _926, (mad(_53, _923, (_920 * _52)))));
    _939 = (mad(_57, _926, (mad(_56, _923, (_920 * _55)))));
  }
  if (((_937 < 0.0031306699384003878f))) {
    _950 = (_937 * 12.920000076293945f);
  } else {
    _950 = (((exp2(((log2(_937)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_938 < 0.0031306699384003878f))) {
    _961 = (_938 * 12.920000076293945f);
  } else {
    _961 = (((exp2(((log2(_938)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_939 < 0.0031306699384003878f))) {
    _972 = (_939 * 12.920000076293945f);
  } else {
    _972 = (((exp2(((log2(_939)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  RWOutputTexture[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4((_950 * 0.9523810148239136f), (_961 * 0.9523810148239136f), (_972 * 0.9523810148239136f), 0.0f);
}
