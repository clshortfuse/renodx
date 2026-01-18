#include "../../common.hlsl"

Texture2D<float4> Textures_1 : register(t0);

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
  float cb0_036x : packoffset(c036.x);
  float cb0_036y : packoffset(c036.y);
  float cb0_036z : packoffset(c036.z);
  float cb0_037x : packoffset(c037.x);
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
  float cb0_041x : packoffset(c041.x);
  float cb0_041y : packoffset(c041.y);
  float cb0_041z : packoffset(c041.z);
  float cb0_042y : packoffset(c042.y);
  float cb0_042z : packoffset(c042.z);
  uint cb0_042w : packoffset(c042.w);
  uint cb0_043x : packoffset(c043.x);
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
  float UniformBufferConstants_WorkingColorSpace_016x : packoffset(c016.x);
  float UniformBufferConstants_WorkingColorSpace_016y : packoffset(c016.y);
  float UniformBufferConstants_WorkingColorSpace_016z : packoffset(c016.z);
  float UniformBufferConstants_WorkingColorSpace_017x : packoffset(c017.x);
  float UniformBufferConstants_WorkingColorSpace_017y : packoffset(c017.y);
  float UniformBufferConstants_WorkingColorSpace_017z : packoffset(c017.z);
  float UniformBufferConstants_WorkingColorSpace_018x : packoffset(c018.x);
  float UniformBufferConstants_WorkingColorSpace_018y : packoffset(c018.y);
  float UniformBufferConstants_WorkingColorSpace_018z : packoffset(c018.z);
  uint UniformBufferConstants_WorkingColorSpace_020x : packoffset(c020.x);
};

SamplerState Samplers_1 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  float4 SV_Target;

  float _10[6];
  float _11[6];
  float _12[6];
  float _13[6];
  float _16 = 0.5f / (cb0_037x);
  float _21 = (cb0_037x) + -1.0f;
  float _22 = ((cb0_037x) * ((TEXCOORD.x) - _16)) / _21;
  float _23 = ((cb0_037x) * ((TEXCOORD.y) - _16)) / _21;
  float _25 = (float((uint)(SV_RenderTargetArrayIndex))) / _21;
  float _45 = 1.379158854484558f;
  float _46 = -0.3088507056236267f;
  float _47 = -0.07034677267074585f;
  float _48 = -0.06933528929948807f;
  float _49 = 1.0822921991348267f;
  float _50 = -0.012962047010660172f;
  float _51 = -0.002159259282052517f;
  float _52 = -0.045465391129255295f;
  float _53 = 1.0477596521377563f;
  float _111;
  float _112;
  float _113;
  float _636;
  float _669;
  float _683;
  float _747;
  float _926;
  float _937;
  float _948;
  float _1146;
  float _1147;
  float _1148;
  float _1159;
  float _1170;
  float _1350;
  float _1383;
  float _1397;
  float _1436;
  float _1546;
  float _1620;
  float _1694;
  float _1773;
  float _1774;
  float _1775;
  float _1924;
  float _1957;
  float _1971;
  float _2010;
  float _2120;
  float _2194;
  float _2268;
  float _2347;
  float _2348;
  float _2349;
  float _2526;
  float _2527;
  float _2528;
  if (!((((uint)(cb0_043x)) == 1))) {
    _45 = 1.02579927444458f;
    _46 = -0.020052503794431686f;
    _47 = -0.0057713985443115234f;
    _48 = -0.0022350111976265907f;
    _49 = 1.0045825242996216f;
    _50 = -0.002352306619286537f;
    _51 = -0.005014004185795784f;
    _52 = -0.025293385609984398f;
    _53 = 1.0304402112960815f;
    if (!((((uint)(cb0_043x)) == 2))) {
      _45 = 0.6954522132873535f;
      _46 = 0.14067870378494263f;
      _47 = 0.16386906802654266f;
      _48 = 0.044794563204050064f;
      _49 = 0.8596711158752441f;
      _50 = 0.0955343171954155f;
      _51 = -0.005525882821530104f;
      _52 = 0.004025210160762072f;
      _53 = 1.0015007257461548f;
      if (!((((uint)(cb0_043x)) == 3))) {
        bool _34 = (((uint)(cb0_043x)) == 4);
        _45 = ((_34 ? 1.0f : 1.7050515413284302f));
        _46 = ((_34 ? 0.0f : -0.6217905879020691f));
        _47 = ((_34 ? 0.0f : -0.0832584798336029f));
        _48 = ((_34 ? 0.0f : -0.13025718927383423f));
        _49 = ((_34 ? 1.0f : 1.1408027410507202f));
        _50 = ((_34 ? 0.0f : -0.010548528283834457f));
        _51 = ((_34 ? 0.0f : -0.024003278464078903f));
        _52 = ((_34 ? 0.0f : -0.1289687603712082f));
        _53 = ((_34 ? 1.0f : 1.152971863746643f));
      }
    }
  }
  if (((((uint)(cb0_042w)) > 2))) {
    float _64 = exp2(((log2(_22)) * 0.012683313339948654f));
    float _65 = exp2(((log2(_23)) * 0.012683313339948654f));
    float _66 = exp2(((log2(_25)) * 0.012683313339948654f));
    _111 = ((exp2(((log2(((max(0.0f, (_64 + -0.8359375f))) / (18.8515625f - (_64 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
    _112 = ((exp2(((log2(((max(0.0f, (_65 + -0.8359375f))) / (18.8515625f - (_65 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
    _113 = ((exp2(((log2(((max(0.0f, (_66 + -0.8359375f))) / (18.8515625f - (_66 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
  } else {
    _111 = (((exp2(((_22 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
    _112 = (((exp2(((_23 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
    _113 = (((exp2(((_25 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _128 = mad((UniformBufferConstants_WorkingColorSpace_008z), _113, (mad((UniformBufferConstants_WorkingColorSpace_008y), _112, ((UniformBufferConstants_WorkingColorSpace_008x)*_111))));
  float _131 = mad((UniformBufferConstants_WorkingColorSpace_009z), _113, (mad((UniformBufferConstants_WorkingColorSpace_009y), _112, ((UniformBufferConstants_WorkingColorSpace_009x)*_111))));
  float _134 = mad((UniformBufferConstants_WorkingColorSpace_010z), _113, (mad((UniformBufferConstants_WorkingColorSpace_010y), _112, ((UniformBufferConstants_WorkingColorSpace_010x)*_111))));
  float _135 = dot(float3(_128, _131, _134), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  SetUngradedAP1(float3(_128, _131, _134));

  float _139 = (_128 / _135) + -1.0f;
  float _140 = (_131 / _135) + -1.0f;
  float _141 = (_134 / _135) + -1.0f;
  float _153 = (1.0f - (exp2((((_135 * _135) * -4.0f) * (cb0_038w))))) * (1.0f - (exp2(((dot(float3(_139, _140, _141), float3(_139, _140, _141))) * -4.0f))));
  float _169 = (((mad(-0.06368283927440643f, _134, (mad(-0.32929131388664246f, _131, (_128 * 1.370412826538086f))))) - _128) * _153) + _128;
  float _170 = (((mad(-0.010861567221581936f, _134, (mad(1.0970908403396606f, _131, (_128 * -0.08343426138162613f))))) - _131) * _153) + _131;
  float _171 = (((mad(1.203694462776184f, _134, (mad(-0.09862564504146576f, _131, (_128 * -0.02579325996339321f))))) - _134) * _153) + _134;
  float _172 = dot(float3(_169, _170, _171), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _186 = (cb0_019w) + (cb0_024w);
  float _200 = (cb0_018w) * (cb0_023w);
  float _214 = (cb0_017w) * (cb0_022w);
  float _228 = (cb0_016w) * (cb0_021w);
  float _242 = (cb0_015w) * (cb0_020w);
  float _246 = _169 - _172;
  float _247 = _170 - _172;
  float _248 = _171 - _172;
  float _305 = saturate((_172 / (cb0_037w)));
  float _309 = (_305 * _305) * (3.0f - (_305 * 2.0f));
  float _310 = 1.0f - _309;
  float _319 = (cb0_019w) + (cb0_034w);
  float _328 = (cb0_018w) * (cb0_033w);
  float _337 = (cb0_017w) * (cb0_032w);
  float _346 = (cb0_016w) * (cb0_031w);
  float _355 = (cb0_015w) * (cb0_030w);
  float _418 = saturate(((_172 - (cb0_038x)) / ((cb0_038y) - (cb0_038x))));
  float _422 = (_418 * _418) * (3.0f - (_418 * 2.0f));
  float _431 = (cb0_019w) + (cb0_029w);
  float _440 = (cb0_018w) * (cb0_028w);
  float _449 = (cb0_017w) * (cb0_027w);
  float _458 = (cb0_016w) * (cb0_026w);
  float _467 = (cb0_015w) * (cb0_025w);
  float _525 = _309 - _422;
  float _536 = ((_422 * ((((cb0_019x) + (cb0_034x)) + _319) + ((((cb0_018x) * (cb0_033x)) * _328) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_031x)) * _346) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_030x)) * _355) * _246) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_032x)) * _337)))))))) + (_310 * ((((cb0_019x) + (cb0_024x)) + _186) + ((((cb0_018x) * (cb0_023x)) * _200) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_021x)) * _228) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_020x)) * _242) * _246) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_022x)) * _214))))))))) + (((((cb0_019x) + (cb0_029x)) + _431) + ((((cb0_018x) * (cb0_028x)) * _440) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_026x)) * _458) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_025x)) * _467) * _246) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_027x)) * _449))))))) * _525);
  float _538 = ((_422 * ((((cb0_019y) + (cb0_034y)) + _319) + ((((cb0_018y) * (cb0_033y)) * _328) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_031y)) * _346) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_030y)) * _355) * _247) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_032y)) * _337)))))))) + (_310 * ((((cb0_019y) + (cb0_024y)) + _186) + ((((cb0_018y) * (cb0_023y)) * _200) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_021y)) * _228) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_020y)) * _242) * _247) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_022y)) * _214))))))))) + (((((cb0_019y) + (cb0_029y)) + _431) + ((((cb0_018y) * (cb0_028y)) * _440) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_026y)) * _458) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_025y)) * _467) * _247) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_027y)) * _449))))))) * _525);
  float _540 = ((_422 * ((((cb0_019z) + (cb0_034z)) + _319) + ((((cb0_018z) * (cb0_033z)) * _328) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_031z)) * _346) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_030z)) * _355) * _248) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_032z)) * _337)))))))) + (_310 * ((((cb0_019z) + (cb0_024z)) + _186) + ((((cb0_018z) * (cb0_023z)) * _200) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_021z)) * _228) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_020z)) * _242) * _248) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_022z)) * _214))))))))) + (((((cb0_019z) + (cb0_029z)) + _431) + ((((cb0_018z) * (cb0_028z)) * _440) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_026z)) * _458) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_025z)) * _467) * _248) + _172))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_027z)) * _449))))))) * _525);

  SetUntonemappedAP1(float3(_536, _538, _540));  // CustomEdit

  float _576 = (((mad(0.061360642313957214f, _540, (mad(-4.540197551250458e-09f, _538, (_536 * 0.9386394023895264f))))) - _536) * (cb0_038z)) + _536;
  float _577 = (((mad(0.169205904006958f, _540, (mad(0.8307942152023315f, _538, (_536 * 6.775371730327606e-08f))))) - _538) * (cb0_038z)) + _538;
  float _578 = ((mad(-2.3283064365386963e-10f, _538, (_536 * -9.313225746154785e-10f))) * (cb0_038z)) + _540;

  float _581 = mad(0.16386905312538147f, _578, (mad(0.14067868888378143f, _577, (_576 * 0.6954522132873535f))));
  float _584 = mad(0.0955343246459961f, _578, (mad(0.8596711158752441f, _577, (_576 * 0.044794581830501556f))));
  float _587 = mad(1.0015007257461548f, _578, (mad(0.004025210160762072f, _577, (_576 * -0.005525882821530104f))));
  float _591 = max((max(_581, _584)), _587);
  float _596 = ((max(_591, 1.000000013351432e-10f)) - (max((min((min(_581, _584)), _587)), 1.000000013351432e-10f))) / (max(_591, 0.009999999776482582f));
  float _609 = ((_584 + _581) + _587) + ((sqrt(((((_587 - _584) * _587) + ((_584 - _581) * _584)) + ((_581 - _587) * _581)))) * 1.75f);
  float _610 = _609 * 0.3333333432674408f;
  float _611 = _596 + -0.4000000059604645f;
  float _612 = _611 * 5.0f;
  float _616 = max((1.0f - (abs((_611 * 2.5f)))), 0.0f);
  float _627 = (((float(((int(((bool)((_612 > 0.0f))))) - (int(((bool)((_612 < 0.0f)))))))) * (1.0f - (_616 * _616))) + 1.0f) * 0.02500000037252903f;
  _636 = _627;
  if ((!(_610 <= 0.0533333346247673f))) {
    _636 = 0.0f;
    if ((!(_610 >= 0.1599999964237213f))) {
      _636 = (((0.23999999463558197f / _609) + -0.5f) * _627);
    }
  }
  float _637 = _636 + 1.0f;
  float _638 = _637 * _581;
  float _639 = _637 * _584;
  float _640 = _637 * _587;
  _669 = 0.0f;
  if (!(((bool)((_638 == _639))) && ((bool)((_639 == _640))))) {
    float _647 = ((_638 * 2.0f) - _639) - _640;
    float _650 = ((_584 - _587) * 1.7320507764816284f) * _637;
    float _652 = atan((_650 / _647));
    bool _655 = (_647 < 0.0f);
    bool _656 = (_647 == 0.0f);
    bool _657 = (_650 >= 0.0f);
    bool _658 = (_650 < 0.0f);
    _669 = ((((bool)(_657 && _656)) ? 90.0f : ((((bool)(_658 && _656)) ? -90.0f : (((((bool)(_658 && _655)) ? (_652 + -3.1415927410125732f) : ((((bool)(_657 && _655)) ? (_652 + 3.1415927410125732f) : _652)))) * 57.2957763671875f)))));
  }
  float _674 = min((max(((((bool)((_669 < 0.0f))) ? (_669 + 360.0f) : _669)), 0.0f)), 360.0f);
  if (((_674 < -180.0f))) {
    _683 = (_674 + 360.0f);
  } else {
    _683 = _674;
    if (((_674 > 180.0f))) {
      _683 = (_674 + -360.0f);
    }
  }
  float _687 = saturate((1.0f - (abs((_683 * 0.014814814552664757f)))));
  float _691 = (_687 * _687) * (3.0f - (_687 * 2.0f));
  float _697 = ((_691 * _691) * ((_596 * 0.18000000715255737f) * (0.029999999329447746f - _638))) + _638;
  float _707 = max(0.0f, (mad(-0.21492856740951538f, _640, (mad(-0.2365107536315918f, _639, (_697 * 1.4514392614364624f))))));
  float _708 = max(0.0f, (mad(-0.09967592358589172f, _640, (mad(1.17622971534729f, _639, (_697 * -0.07655377686023712f))))));
  float _709 = max(0.0f, (mad(0.9977163076400757f, _640, (mad(-0.006032449658960104f, _639, (_697 * 0.008316148072481155f))))));
  float _710 = dot(float3(_707, _708, _709), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _725 = ((cb0_040x) + 1.0f) - (cb0_039z);
  float _727 = (cb0_040y) + 1.0f;
  float _729 = _727 - (cb0_039w);
  if ((((cb0_039z) > 0.800000011920929f))) {
    _747 = (((0.8199999928474426f - (cb0_039z)) / (cb0_039y)) + -0.7447274923324585f);
  } else {
    float _738 = ((cb0_040x) + 0.18000000715255737f) / _725;
    _747 = (-0.7447274923324585f - (((log2((_738 / (2.0f - _738)))) * 0.3465735912322998f) * (_725 / (cb0_039y))));
  }
  float _750 = ((1.0f - (cb0_039z)) / (cb0_039y)) - _747;
  float _752 = ((cb0_039w) / (cb0_039y)) - _750;
  float _756 = (log2((((_707 - _710) * 0.9599999785423279f) + _710))) * 0.3010300099849701f;
  float _757 = (log2((((_708 - _710) * 0.9599999785423279f) + _710))) * 0.3010300099849701f;
  float _758 = (log2((((_709 - _710) * 0.9599999785423279f) + _710))) * 0.3010300099849701f;
  float _762 = (cb0_039y) * (_756 + _750);
  float _763 = (cb0_039y) * (_757 + _750);
  float _764 = (cb0_039y) * (_758 + _750);
  float _765 = _725 * 2.0f;
  float _767 = ((cb0_039y) * -2.0f) / _725;
  float _768 = _756 - _747;
  float _769 = _757 - _747;
  float _770 = _758 - _747;
  float _789 = _729 * 2.0f;
  float _791 = ((cb0_039y) * 2.0f) / _729;
  float _816 = (((bool)((_756 < _747))) ? ((_765 / ((exp2(((_768 * 1.4426950216293335f) * _767))) + 1.0f)) - (cb0_040x)) : _762);
  float _817 = (((bool)((_757 < _747))) ? ((_765 / ((exp2(((_769 * 1.4426950216293335f) * _767))) + 1.0f)) - (cb0_040x)) : _763);
  float _818 = (((bool)((_758 < _747))) ? ((_765 / ((exp2(((_770 * 1.4426950216293335f) * _767))) + 1.0f)) - (cb0_040x)) : _764);
  float _825 = _752 - _747;
  float _829 = saturate((_768 / _825));
  float _830 = saturate((_769 / _825));
  float _831 = saturate((_770 / _825));
  bool _832 = (_752 < _747);
  float _836 = (_832 ? (1.0f - _829) : _829);
  float _837 = (_832 ? (1.0f - _830) : _830);
  float _838 = (_832 ? (1.0f - _831) : _831);
  float _857 = (((_836 * _836) * (((((bool)((_756 > _752))) ? (_727 - (_789 / ((exp2((((_756 - _752) * 1.4426950216293335f) * _791))) + 1.0f))) : _762)) - _816)) * (3.0f - (_836 * 2.0f))) + _816;
  float _858 = (((_837 * _837) * (((((bool)((_757 > _752))) ? (_727 - (_789 / ((exp2((((_757 - _752) * 1.4426950216293335f) * _791))) + 1.0f))) : _763)) - _817)) * (3.0f - (_837 * 2.0f))) + _817;
  float _859 = (((_838 * _838) * (((((bool)((_758 > _752))) ? (_727 - (_789 / ((exp2((((_758 - _752) * 1.4426950216293335f) * _791))) + 1.0f))) : _764)) - _818)) * (3.0f - (_838 * 2.0f))) + _818;
  float _860 = dot(float3(_857, _858, _859), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _880 = ((cb0_039x) * ((max(0.0f, (((_857 - _860) * 0.9300000071525574f) + _860))) - _576)) + _576;
  float _881 = ((cb0_039x) * ((max(0.0f, (((_858 - _860) * 0.9300000071525574f) + _860))) - _577)) + _577;
  float _882 = ((cb0_039x) * ((max(0.0f, (((_859 - _860) * 0.9300000071525574f) + _860))) - _578)) + _578;
  float _898 = (((mad(-0.06537103652954102f, _882, (mad(1.451815478503704e-06f, _881, (_880 * 1.065374732017517f))))) - _880) * (cb0_038z)) + _880;
  float _899 = (((mad(-0.20366770029067993f, _882, (mad(1.2036634683609009f, _881, (_880 * -2.57161445915699e-07f))))) - _881) * (cb0_038z)) + _881;
  float _900 = (((mad(0.9999996423721313f, _882, (mad(2.0954757928848267e-08f, _881, (_880 * 1.862645149230957e-08f))))) - _882) * (cb0_038z)) + _882;

  SetTonemappedAP1(_898, _899, _900);

  float _913 = saturate((max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_012z), _900, (mad((UniformBufferConstants_WorkingColorSpace_012y), _899, ((UniformBufferConstants_WorkingColorSpace_012x)*_898))))))));
  float _914 = saturate((max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_013z), _900, (mad((UniformBufferConstants_WorkingColorSpace_013y), _899, ((UniformBufferConstants_WorkingColorSpace_013x)*_898))))))));
  float _915 = saturate((max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_014z), _900, (mad((UniformBufferConstants_WorkingColorSpace_014y), _899, ((UniformBufferConstants_WorkingColorSpace_014x)*_898))))))));
  if (((_913 < 0.0031306699384003878f))) {
    _926 = (_913 * 12.920000076293945f);
  } else {
    _926 = (((exp2(((log2(_913)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_914 < 0.0031306699384003878f))) {
    _937 = (_914 * 12.920000076293945f);
  } else {
    _937 = (((exp2(((log2(_914)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  if (((_915 < 0.0031306699384003878f))) {
    _948 = (_915 * 12.920000076293945f);
  } else {
    _948 = (((exp2(((log2(_915)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
  }
  float _952 = (_937 * 0.9375f) + 0.03125f;
  float _959 = _948 * 15.0f;
  float _960 = floor(_959);
  float _961 = _959 - _960;
  float _963 = (((_926 * 0.9375f) + 0.03125f) + _960) * 0.0625f;
  float4 _966 = Textures_1.Sample(Samplers_1, float2(_963, _952));
  float4 _973 = Textures_1.Sample(Samplers_1, float2((_963 + 0.0625f), _952));
  float _992 = max(6.103519990574569e-05f, ((((((_973.x) - (_966.x)) * _961) + (_966.x)) * (cb0_005y)) + ((cb0_005x)*_926)));
  float _993 = max(6.103519990574569e-05f, ((((((_973.y) - (_966.y)) * _961) + (_966.y)) * (cb0_005y)) + ((cb0_005x)*_937)));
  float _994 = max(6.103519990574569e-05f, ((((((_973.z) - (_966.z)) * _961) + (_966.z)) * (cb0_005y)) + ((cb0_005x)*_948)));
  float _1016 = (((bool)((_992 > 0.040449999272823334f))) ? (exp2(((log2(((_992 * 0.9478672742843628f) + 0.05213269963860512f))) * 2.4000000953674316f))) : (_992 * 0.07739938050508499f));
  float _1017 = (((bool)((_993 > 0.040449999272823334f))) ? (exp2(((log2(((_993 * 0.9478672742843628f) + 0.05213269963860512f))) * 2.4000000953674316f))) : (_993 * 0.07739938050508499f));
  float _1018 = (((bool)((_994 > 0.040449999272823334f))) ? (exp2(((log2(((_994 * 0.9478672742843628f) + 0.05213269963860512f))) * 2.4000000953674316f))) : (_994 * 0.07739938050508499f));
  float _1044 = (cb0_014x) * ((((cb0_041y) + ((cb0_041x)*_1016)) * _1016) + (cb0_041z));
  float _1045 = (cb0_014y) * ((((cb0_041y) + ((cb0_041x)*_1017)) * _1017) + (cb0_041z));
  float _1046 = (cb0_014z) * ((((cb0_041y) + ((cb0_041x)*_1018)) * _1018) + (cb0_041z));
  float _1053 = (((cb0_013x)-_1044) * (cb0_013w)) + _1044;
  float _1054 = (((cb0_013y)-_1045) * (cb0_013w)) + _1045;
  float _1055 = (((cb0_013z)-_1046) * (cb0_013w)) + _1046;
  float _1056 = (cb0_014x) * (mad((UniformBufferConstants_WorkingColorSpace_012z), _540, (mad((UniformBufferConstants_WorkingColorSpace_012y), _538, (_536 * (UniformBufferConstants_WorkingColorSpace_012x))))));
  float _1057 = (cb0_014y) * (mad((UniformBufferConstants_WorkingColorSpace_013z), _540, (mad((UniformBufferConstants_WorkingColorSpace_013y), _538, ((UniformBufferConstants_WorkingColorSpace_013x)*_536)))));
  float _1058 = (cb0_014z) * (mad((UniformBufferConstants_WorkingColorSpace_014z), _540, (mad((UniformBufferConstants_WorkingColorSpace_014y), _538, ((UniformBufferConstants_WorkingColorSpace_014x)*_536)))));
  float _1065 = (((cb0_013x)-_1056) * (cb0_013w)) + _1056;
  float _1066 = (((cb0_013y)-_1057) * (cb0_013w)) + _1057;
  float _1067 = (((cb0_013z)-_1058) * (cb0_013w)) + _1058;
  float _1079 = exp2(((log2((max(0.0f, _1053)))) * (cb0_042y)));
  float _1080 = exp2(((log2((max(0.0f, _1054)))) * (cb0_042y)));
  float _1081 = exp2(((log2((max(0.0f, _1055)))) * (cb0_042y)));

  // CustomEdit
  if (RENODX_TONE_MAP_TYPE != 0) {
    return GenerateOutput(float3(_1079, _1080, _1081), cb0_042w);
  }

  if (((((uint)(cb0_042w)) == 0))) {
    float _1087 = max((dot(float3(_1079, _1080, _1081), float3(0.2126390039920807f, 0.7151690125465393f, 0.0721919983625412f))), 9.999999747378752e-05f);
    float _1107 = ((((((bool)((_1087 < (cb0_036z)))) ? 0.0f : 1.0f)) * (((cb0_035y)-_1087) + ((-0.0f - (cb0_036x)) / ((cb0_035x) + _1087)))) + _1087) * (cb0_036y);
    float _1108 = _1107 * (_1079 / _1087);
    float _1109 = _1107 * (_1080 / _1087);
    float _1110 = _1107 * (_1081 / _1087);
    _1146 = _1108;
    _1147 = _1109;
    _1148 = _1110;
    do {
      if (((((uint)(UniformBufferConstants_WorkingColorSpace_020x)) == 0))) {
        float _1129 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1110, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1109, ((UniformBufferConstants_WorkingColorSpace_008x)*_1108))));
        float _1132 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1110, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1109, ((UniformBufferConstants_WorkingColorSpace_009x)*_1108))));
        float _1135 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1110, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1109, ((UniformBufferConstants_WorkingColorSpace_010x)*_1108))));
        _1146 = (mad(_47, _1135, (mad(_46, _1132, (_1129 * _45)))));
        _1147 = (mad(_50, _1135, (mad(_49, _1132, (_1129 * _48)))));
        _1148 = (mad(_53, _1135, (mad(_52, _1132, (_1129 * _51)))));
      }
      do {
        if (((_1146 < 0.0031306699384003878f))) {
          _1159 = (_1146 * 12.920000076293945f);
        } else {
          _1159 = (((exp2(((log2(_1146)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (((_1147 < 0.0031306699384003878f))) {
            _1170 = (_1147 * 12.920000076293945f);
          } else {
            _1170 = (((exp2(((log2(_1147)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (((_1148 < 0.0031306699384003878f))) {
            _2526 = _1159;
            _2527 = _1170;
            _2528 = (_1148 * 12.920000076293945f);
          } else {
            _2526 = _1159;
            _2527 = _1170;
            _2528 = (((exp2(((log2(_1148)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (((((uint)(cb0_042w)) == 1))) {
      float _1197 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1080, ((UniformBufferConstants_WorkingColorSpace_008x)*_1079))));
      float _1200 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1080, ((UniformBufferConstants_WorkingColorSpace_009x)*_1079))));
      float _1203 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1080, ((UniformBufferConstants_WorkingColorSpace_010x)*_1079))));
      float _1213 = max(6.103519990574569e-05f, (mad(_47, _1203, (mad(_46, _1200, (_1197 * _45))))));
      float _1214 = max(6.103519990574569e-05f, (mad(_50, _1203, (mad(_49, _1200, (_1197 * _48))))));
      float _1215 = max(6.103519990574569e-05f, (mad(_53, _1203, (mad(_52, _1200, (_1197 * _51))))));
      _2526 = (min((_1213 * 4.5f), (((exp2(((log2((max(_1213, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2527 = (min((_1214 * 4.5f), (((exp2(((log2((max(_1214, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2528 = (min((_1215 * 4.5f), (((exp2(((log2((max(_1215, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
    } else {
      if ((((bool)((((uint)(cb0_042w)) == 3))) || ((bool)((((uint)(cb0_042w)) == 5))))) {
        _12[0] = (cb0_010x);
        _12[1] = (cb0_010y);
        _12[2] = (cb0_010z);
        _12[3] = (cb0_010w);
        _12[4] = (cb0_012x);
        _12[5] = (cb0_012x);
        _13[0] = (cb0_011x);
        _13[1] = (cb0_011y);
        _13[2] = (cb0_011z);
        _13[3] = (cb0_011w);
        _13[4] = (cb0_012y);
        _13[5] = (cb0_012y);
        float _1290 = (cb0_012z)*_1065;
        float _1291 = (cb0_012z)*_1066;
        float _1292 = (cb0_012z)*_1067;
        float _1295 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1292, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1291, ((UniformBufferConstants_WorkingColorSpace_016x)*_1290))));
        float _1298 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1292, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1291, ((UniformBufferConstants_WorkingColorSpace_017x)*_1290))));
        float _1301 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1292, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1291, ((UniformBufferConstants_WorkingColorSpace_018x)*_1290))));
        float _1305 = max((max(_1295, _1298)), _1301);
        float _1310 = ((max(_1305, 1.000000013351432e-10f)) - (max((min((min(_1295, _1298)), _1301)), 1.000000013351432e-10f))) / (max(_1305, 0.009999999776482582f));
        float _1323 = ((_1298 + _1295) + _1301) + ((sqrt(((((_1301 - _1298) * _1301) + ((_1298 - _1295) * _1298)) + ((_1295 - _1301) * _1295)))) * 1.75f);
        float _1324 = _1323 * 0.3333333432674408f;
        float _1325 = _1310 + -0.4000000059604645f;
        float _1326 = _1325 * 5.0f;
        float _1330 = max((1.0f - (abs((_1325 * 2.5f)))), 0.0f);
        float _1341 = (((float(((int(((bool)((_1326 > 0.0f))))) - (int(((bool)((_1326 < 0.0f)))))))) * (1.0f - (_1330 * _1330))) + 1.0f) * 0.02500000037252903f;
        _1350 = _1341;
        do {
          if ((!(_1324 <= 0.0533333346247673f))) {
            _1350 = 0.0f;
            if ((!(_1324 >= 0.1599999964237213f))) {
              _1350 = (((0.23999999463558197f / _1323) + -0.5f) * _1341);
            }
          }
          float _1351 = _1350 + 1.0f;
          float _1352 = _1351 * _1295;
          float _1353 = _1351 * _1298;
          float _1354 = _1351 * _1301;
          _1383 = 0.0f;
          do {
            if (!(((bool)((_1352 == _1353))) && ((bool)((_1353 == _1354))))) {
              float _1361 = ((_1352 * 2.0f) - _1353) - _1354;
              float _1364 = ((_1298 - _1301) * 1.7320507764816284f) * _1351;
              float _1366 = atan((_1364 / _1361));
              bool _1369 = (_1361 < 0.0f);
              bool _1370 = (_1361 == 0.0f);
              bool _1371 = (_1364 >= 0.0f);
              bool _1372 = (_1364 < 0.0f);
              _1383 = ((((bool)(_1371 && _1370)) ? 90.0f : ((((bool)(_1372 && _1370)) ? -90.0f : (((((bool)(_1372 && _1369)) ? (_1366 + -3.1415927410125732f) : ((((bool)(_1371 && _1369)) ? (_1366 + 3.1415927410125732f) : _1366)))) * 57.2957763671875f)))));
            }
            float _1388 = min((max(((((bool)((_1383 < 0.0f))) ? (_1383 + 360.0f) : _1383)), 0.0f)), 360.0f);
            do {
              if (((_1388 < -180.0f))) {
                _1397 = (_1388 + 360.0f);
              } else {
                _1397 = _1388;
                if (((_1388 > 180.0f))) {
                  _1397 = (_1388 + -360.0f);
                }
              }
              _1436 = 0.0f;
              do {
                if ((((bool)((_1397 > -67.5f))) && ((bool)((_1397 < 67.5f))))) {
                  float _1403 = (_1397 + 67.5f) * 0.029629629105329514f;
                  int _1404 = int(1404);
                  float _1406 = _1403 - (float(_1404));
                  float _1407 = _1406 * _1406;
                  float _1408 = _1407 * _1406;
                  if (((_1404 == 3))) {
                    _1436 = (((0.1666666716337204f - (_1406 * 0.5f)) + (_1407 * 0.5f)) - (_1408 * 0.1666666716337204f));
                  } else {
                    if (((_1404 == 2))) {
                      _1436 = ((0.6666666865348816f - _1407) + (_1408 * 0.5f));
                    } else {
                      if (((_1404 == 1))) {
                        _1436 = (((_1408 * -0.5f) + 0.1666666716337204f) + ((_1407 + _1406) * 0.5f));
                      } else {
                        _1436 = ((((bool)((_1404 == 0))) ? (_1408 * 0.1666666716337204f) : 0.0f));
                      }
                    }
                  }
                }
                float _1445 = min((max(((((_1310 * 0.27000001072883606f) * (0.029999999329447746f - _1352)) * _1436) + _1352), 0.0f)), 65535.0f);
                float _1446 = min((max(_1353, 0.0f)), 65535.0f);
                float _1447 = min((max(_1354, 0.0f)), 65535.0f);
                float _1460 = min((max((mad(-0.21492856740951538f, _1447, (mad(-0.2365107536315918f, _1446, (_1445 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                float _1461 = min((max((mad(-0.09967592358589172f, _1447, (mad(1.17622971534729f, _1446, (_1445 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                float _1462 = min((max((mad(0.9977163076400757f, _1447, (mad(-0.006032449658960104f, _1446, (_1445 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                float _1463 = dot(float3(_1460, _1461, _1462), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1474 = log2((max((((_1460 - _1463) * 0.9599999785423279f) + _1463), 1.000000013351432e-10f)));
                float _1475 = _1474 * 0.3010300099849701f;
                float _1476 = log2((cb0_008x));
                float _1477 = _1476 * 0.3010300099849701f;
                do {
                  if (!(!(_1475 <= _1477))) {
                    _1546 = ((log2((cb0_008y))) * 0.3010300099849701f);
                  } else {
                    float _1484 = log2((cb0_009x));
                    float _1485 = _1484 * 0.3010300099849701f;
                    if ((((bool)((_1475 > _1477))) && ((bool)((_1475 < _1485))))) {
                      float _1493 = ((_1474 - _1476) * 0.9030900001525879f) / ((_1484 - _1476) * 0.3010300099849701f);
                      int _1494 = int(1494);
                      float _1496 = _1493 - (float(_1494));
                      float _1498 = _12[_1494];
                      float _1501 = _12[(_1494 + 1)];
                      float _1506 = _1498 * 0.5f;
                      _1546 = (dot(float3((_1496 * _1496), _1496, 1.0f), float3((mad((_12[(_1494 + 2)]), 0.5f, (mad(_1501, -1.0f, _1506)))), (_1501 - _1498), (mad(_1501, 0.5f, _1506)))));
                    } else {
                      do {
                        if (!(!(_1475 >= _1485))) {
                          float _1515 = log2((cb0_008z));
                          if (((_1475 < (_1515 * 0.3010300099849701f)))) {
                            float _1523 = ((_1474 - _1484) * 0.9030900001525879f) / ((_1515 - _1484) * 0.3010300099849701f);
                            int _1524 = int(1524);
                            float _1526 = _1523 - (float(_1524));
                            float _1528 = _13[_1524];
                            float _1531 = _13[(_1524 + 1)];
                            float _1536 = _1528 * 0.5f;
                            _1546 = (dot(float3((_1526 * _1526), _1526, 1.0f), float3((mad((_13[(_1524 + 2)]), 0.5f, (mad(_1531, -1.0f, _1536)))), (_1531 - _1528), (mad(_1531, 0.5f, _1536)))));
                            break;
                          }
                        }
                        _1546 = ((log2((cb0_008w))) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1550 = log2((max((((_1461 - _1463) * 0.9599999785423279f) + _1463), 1.000000013351432e-10f)));
                  float _1551 = _1550 * 0.3010300099849701f;
                  do {
                    if (!(!(_1551 <= _1477))) {
                      _1620 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _1558 = log2((cb0_009x));
                      float _1559 = _1558 * 0.3010300099849701f;
                      if ((((bool)((_1551 > _1477))) && ((bool)((_1551 < _1559))))) {
                        float _1567 = ((_1550 - _1476) * 0.9030900001525879f) / ((_1558 - _1476) * 0.3010300099849701f);
                        int _1568 = int(1568);
                        float _1570 = _1567 - (float(_1568));
                        float _1572 = _12[_1568];
                        float _1575 = _12[(_1568 + 1)];
                        float _1580 = _1572 * 0.5f;
                        _1620 = (dot(float3((_1570 * _1570), _1570, 1.0f), float3((mad((_12[(_1568 + 2)]), 0.5f, (mad(_1575, -1.0f, _1580)))), (_1575 - _1572), (mad(_1575, 0.5f, _1580)))));
                      } else {
                        do {
                          if (!(!(_1551 >= _1559))) {
                            float _1589 = log2((cb0_008z));
                            if (((_1551 < (_1589 * 0.3010300099849701f)))) {
                              float _1597 = ((_1550 - _1558) * 0.9030900001525879f) / ((_1589 - _1558) * 0.3010300099849701f);
                              int _1598 = int(1598);
                              float _1600 = _1597 - (float(_1598));
                              float _1602 = _13[_1598];
                              float _1605 = _13[(_1598 + 1)];
                              float _1610 = _1602 * 0.5f;
                              _1620 = (dot(float3((_1600 * _1600), _1600, 1.0f), float3((mad((_13[(_1598 + 2)]), 0.5f, (mad(_1605, -1.0f, _1610)))), (_1605 - _1602), (mad(_1605, 0.5f, _1610)))));
                              break;
                            }
                          }
                          _1620 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1624 = log2((max((((_1462 - _1463) * 0.9599999785423279f) + _1463), 1.000000013351432e-10f)));
                    float _1625 = _1624 * 0.3010300099849701f;
                    do {
                      if (!(!(_1625 <= _1477))) {
                        _1694 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _1632 = log2((cb0_009x));
                        float _1633 = _1632 * 0.3010300099849701f;
                        if ((((bool)((_1625 > _1477))) && ((bool)((_1625 < _1633))))) {
                          float _1641 = ((_1624 - _1476) * 0.9030900001525879f) / ((_1632 - _1476) * 0.3010300099849701f);
                          int _1642 = int(1642);
                          float _1644 = _1641 - (float(_1642));
                          float _1646 = _12[_1642];
                          float _1649 = _12[(_1642 + 1)];
                          float _1654 = _1646 * 0.5f;
                          _1694 = (dot(float3((_1644 * _1644), _1644, 1.0f), float3((mad((_12[(_1642 + 2)]), 0.5f, (mad(_1649, -1.0f, _1654)))), (_1649 - _1646), (mad(_1649, 0.5f, _1654)))));
                        } else {
                          do {
                            if (!(!(_1625 >= _1633))) {
                              float _1663 = log2((cb0_008z));
                              if (((_1625 < (_1663 * 0.3010300099849701f)))) {
                                float _1671 = ((_1624 - _1632) * 0.9030900001525879f) / ((_1663 - _1632) * 0.3010300099849701f);
                                int _1672 = int(1672);
                                float _1674 = _1671 - (float(_1672));
                                float _1676 = _13[_1672];
                                float _1679 = _13[(_1672 + 1)];
                                float _1684 = _1676 * 0.5f;
                                _1694 = (dot(float3((_1674 * _1674), _1674, 1.0f), float3((mad((_13[(_1672 + 2)]), 0.5f, (mad(_1679, -1.0f, _1684)))), (_1679 - _1676), (mad(_1679, 0.5f, _1684)))));
                                break;
                              }
                            }
                            _1694 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1698 = (cb0_008w) - (cb0_008y);
                      float _1699 = ((exp2((_1546 * 3.321928024291992f))) - (cb0_008y)) / _1698;
                      float _1701 = ((exp2((_1620 * 3.321928024291992f))) - (cb0_008y)) / _1698;
                      float _1703 = ((exp2((_1694 * 3.321928024291992f))) - (cb0_008y)) / _1698;
                      float _1706 = mad(0.15618768334388733f, _1703, (mad(0.13400420546531677f, _1701, (_1699 * 0.6624541878700256f))));
                      float _1709 = mad(0.053689517080783844f, _1703, (mad(0.6740817427635193f, _1701, (_1699 * 0.2722287178039551f))));
                      float _1712 = mad(1.0103391408920288f, _1703, (mad(0.00406073359772563f, _1701, (_1699 * -0.005574649665504694f))));
                      float _1725 = min((max((mad(-0.23642469942569733f, _1712, (mad(-0.32480329275131226f, _1709, (_1706 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                      float _1726 = min((max((mad(0.016756348311901093f, _1712, (mad(1.6153316497802734f, _1709, (_1706 * -0.663662850856781f))))), 0.0f)), 1.0f);
                      float _1727 = min((max((mad(0.9883948564529419f, _1712, (mad(-0.008284442126750946f, _1709, (_1706 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                      float _1730 = mad(0.15618768334388733f, _1727, (mad(0.13400420546531677f, _1726, (_1725 * 0.6624541878700256f))));
                      float _1733 = mad(0.053689517080783844f, _1727, (mad(0.6740817427635193f, _1726, (_1725 * 0.2722287178039551f))));
                      float _1736 = mad(1.0103391408920288f, _1727, (mad(0.00406073359772563f, _1726, (_1725 * -0.005574649665504694f))));
                      float _1758 = min((max(((min((max((mad(-0.23642469942569733f, _1736, (mad(-0.32480329275131226f, _1733, (_1730 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1759 = min((max(((min((max((mad(0.016756348311901093f, _1736, (mad(1.6153316497802734f, _1733, (_1730 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1760 = min((max(((min((max((mad(0.9883948564529419f, _1736, (mad(-0.008284442126750946f, _1733, (_1730 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      _1773 = _1758;
                      _1774 = _1759;
                      _1775 = _1760;
                      do {
                        if (!((((uint)(cb0_042w)) == 5))) {
                          _1773 = (mad(_47, _1760, (mad(_46, _1759, (_1758 * _45)))));
                          _1774 = (mad(_50, _1760, (mad(_49, _1759, (_1758 * _48)))));
                          _1775 = (mad(_53, _1760, (mad(_52, _1759, (_1758 * _51)))));
                        }
                        float _1785 = exp2(((log2((_1773 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1786 = exp2(((log2((_1774 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1787 = exp2(((log2((_1775 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        _2526 = (exp2(((log2(((1.0f / ((_1785 * 18.6875f) + 1.0f)) * ((_1785 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2527 = (exp2(((log2(((1.0f / ((_1786 * 18.6875f) + 1.0f)) * ((_1786 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2528 = (exp2(((log2(((1.0f / ((_1787 * 18.6875f) + 1.0f)) * ((_1787 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((((((uint)(cb0_042w)) & -3) == 4))) {
          _10[0] = (cb0_010x);
          _10[1] = (cb0_010y);
          _10[2] = (cb0_010z);
          _10[3] = (cb0_010w);
          _10[4] = (cb0_012x);
          _10[5] = (cb0_012x);
          _11[0] = (cb0_011x);
          _11[1] = (cb0_011y);
          _11[2] = (cb0_011z);
          _11[3] = (cb0_011w);
          _11[4] = (cb0_012y);
          _11[5] = (cb0_012y);
          float _1864 = (cb0_012z)*_1065;
          float _1865 = (cb0_012z)*_1066;
          float _1866 = (cb0_012z)*_1067;
          float _1869 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1866, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1865, ((UniformBufferConstants_WorkingColorSpace_016x)*_1864))));
          float _1872 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1866, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1865, ((UniformBufferConstants_WorkingColorSpace_017x)*_1864))));
          float _1875 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1866, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1865, ((UniformBufferConstants_WorkingColorSpace_018x)*_1864))));
          float _1879 = max((max(_1869, _1872)), _1875);
          float _1884 = ((max(_1879, 1.000000013351432e-10f)) - (max((min((min(_1869, _1872)), _1875)), 1.000000013351432e-10f))) / (max(_1879, 0.009999999776482582f));
          float _1897 = ((_1872 + _1869) + _1875) + ((sqrt(((((_1875 - _1872) * _1875) + ((_1872 - _1869) * _1872)) + ((_1869 - _1875) * _1869)))) * 1.75f);
          float _1898 = _1897 * 0.3333333432674408f;
          float _1899 = _1884 + -0.4000000059604645f;
          float _1900 = _1899 * 5.0f;
          float _1904 = max((1.0f - (abs((_1899 * 2.5f)))), 0.0f);
          float _1915 = (((float(((int(((bool)((_1900 > 0.0f))))) - (int(((bool)((_1900 < 0.0f)))))))) * (1.0f - (_1904 * _1904))) + 1.0f) * 0.02500000037252903f;
          _1924 = _1915;
          do {
            if ((!(_1898 <= 0.0533333346247673f))) {
              _1924 = 0.0f;
              if ((!(_1898 >= 0.1599999964237213f))) {
                _1924 = (((0.23999999463558197f / _1897) + -0.5f) * _1915);
              }
            }
            float _1925 = _1924 + 1.0f;
            float _1926 = _1925 * _1869;
            float _1927 = _1925 * _1872;
            float _1928 = _1925 * _1875;
            _1957 = 0.0f;
            do {
              if (!(((bool)((_1926 == _1927))) && ((bool)((_1927 == _1928))))) {
                float _1935 = ((_1926 * 2.0f) - _1927) - _1928;
                float _1938 = ((_1872 - _1875) * 1.7320507764816284f) * _1925;
                float _1940 = atan((_1938 / _1935));
                bool _1943 = (_1935 < 0.0f);
                bool _1944 = (_1935 == 0.0f);
                bool _1945 = (_1938 >= 0.0f);
                bool _1946 = (_1938 < 0.0f);
                _1957 = ((((bool)(_1945 && _1944)) ? 90.0f : ((((bool)(_1946 && _1944)) ? -90.0f : (((((bool)(_1946 && _1943)) ? (_1940 + -3.1415927410125732f) : ((((bool)(_1945 && _1943)) ? (_1940 + 3.1415927410125732f) : _1940)))) * 57.2957763671875f)))));
              }
              float _1962 = min((max(((((bool)((_1957 < 0.0f))) ? (_1957 + 360.0f) : _1957)), 0.0f)), 360.0f);
              do {
                if (((_1962 < -180.0f))) {
                  _1971 = (_1962 + 360.0f);
                } else {
                  _1971 = _1962;
                  if (((_1962 > 180.0f))) {
                    _1971 = (_1962 + -360.0f);
                  }
                }
                _2010 = 0.0f;
                do {
                  if ((((bool)((_1971 > -67.5f))) && ((bool)((_1971 < 67.5f))))) {
                    float _1977 = (_1971 + 67.5f) * 0.029629629105329514f;
                    int _1978 = int(1978);
                    float _1980 = _1977 - (float(_1978));
                    float _1981 = _1980 * _1980;
                    float _1982 = _1981 * _1980;
                    if (((_1978 == 3))) {
                      _2010 = (((0.1666666716337204f - (_1980 * 0.5f)) + (_1981 * 0.5f)) - (_1982 * 0.1666666716337204f));
                    } else {
                      if (((_1978 == 2))) {
                        _2010 = ((0.6666666865348816f - _1981) + (_1982 * 0.5f));
                      } else {
                        if (((_1978 == 1))) {
                          _2010 = (((_1982 * -0.5f) + 0.1666666716337204f) + ((_1981 + _1980) * 0.5f));
                        } else {
                          _2010 = ((((bool)((_1978 == 0))) ? (_1982 * 0.1666666716337204f) : 0.0f));
                        }
                      }
                    }
                  }
                  float _2019 = min((max(((((_1884 * 0.27000001072883606f) * (0.029999999329447746f - _1926)) * _2010) + _1926), 0.0f)), 65535.0f);
                  float _2020 = min((max(_1927, 0.0f)), 65535.0f);
                  float _2021 = min((max(_1928, 0.0f)), 65535.0f);
                  float _2034 = min((max((mad(-0.21492856740951538f, _2021, (mad(-0.2365107536315918f, _2020, (_2019 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                  float _2035 = min((max((mad(-0.09967592358589172f, _2021, (mad(1.17622971534729f, _2020, (_2019 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                  float _2036 = min((max((mad(0.9977163076400757f, _2021, (mad(-0.006032449658960104f, _2020, (_2019 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                  float _2037 = dot(float3(_2034, _2035, _2036), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2048 = log2((max((((_2034 - _2037) * 0.9599999785423279f) + _2037), 1.000000013351432e-10f)));
                  float _2049 = _2048 * 0.3010300099849701f;
                  float _2050 = log2((cb0_008x));
                  float _2051 = _2050 * 0.3010300099849701f;
                  do {
                    if (!(!(_2049 <= _2051))) {
                      _2120 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _2058 = log2((cb0_009x));
                      float _2059 = _2058 * 0.3010300099849701f;
                      if ((((bool)((_2049 > _2051))) && ((bool)((_2049 < _2059))))) {
                        float _2067 = ((_2048 - _2050) * 0.9030900001525879f) / ((_2058 - _2050) * 0.3010300099849701f);
                        int _2068 = int(2068);
                        float _2070 = _2067 - (float(_2068));
                        float _2072 = _10[_2068];
                        float _2075 = _10[(_2068 + 1)];
                        float _2080 = _2072 * 0.5f;
                        _2120 = (dot(float3((_2070 * _2070), _2070, 1.0f), float3((mad((_10[(_2068 + 2)]), 0.5f, (mad(_2075, -1.0f, _2080)))), (_2075 - _2072), (mad(_2075, 0.5f, _2080)))));
                      } else {
                        do {
                          if (!(!(_2049 >= _2059))) {
                            float _2089 = log2((cb0_008z));
                            if (((_2049 < (_2089 * 0.3010300099849701f)))) {
                              float _2097 = ((_2048 - _2058) * 0.9030900001525879f) / ((_2089 - _2058) * 0.3010300099849701f);
                              int _2098 = int(2098);
                              float _2100 = _2097 - (float(_2098));
                              float _2102 = _11[_2098];
                              float _2105 = _11[(_2098 + 1)];
                              float _2110 = _2102 * 0.5f;
                              _2120 = (dot(float3((_2100 * _2100), _2100, 1.0f), float3((mad((_11[(_2098 + 2)]), 0.5f, (mad(_2105, -1.0f, _2110)))), (_2105 - _2102), (mad(_2105, 0.5f, _2110)))));
                              break;
                            }
                          }
                          _2120 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2124 = log2((max((((_2035 - _2037) * 0.9599999785423279f) + _2037), 1.000000013351432e-10f)));
                    float _2125 = _2124 * 0.3010300099849701f;
                    do {
                      if (!(!(_2125 <= _2051))) {
                        _2194 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _2132 = log2((cb0_009x));
                        float _2133 = _2132 * 0.3010300099849701f;
                        if ((((bool)((_2125 > _2051))) && ((bool)((_2125 < _2133))))) {
                          float _2141 = ((_2124 - _2050) * 0.9030900001525879f) / ((_2132 - _2050) * 0.3010300099849701f);
                          int _2142 = int(2142);
                          float _2144 = _2141 - (float(_2142));
                          float _2146 = _10[_2142];
                          float _2149 = _10[(_2142 + 1)];
                          float _2154 = _2146 * 0.5f;
                          _2194 = (dot(float3((_2144 * _2144), _2144, 1.0f), float3((mad((_10[(_2142 + 2)]), 0.5f, (mad(_2149, -1.0f, _2154)))), (_2149 - _2146), (mad(_2149, 0.5f, _2154)))));
                        } else {
                          do {
                            if (!(!(_2125 >= _2133))) {
                              float _2163 = log2((cb0_008z));
                              if (((_2125 < (_2163 * 0.3010300099849701f)))) {
                                float _2171 = ((_2124 - _2132) * 0.9030900001525879f) / ((_2163 - _2132) * 0.3010300099849701f);
                                int _2172 = int(2172);
                                float _2174 = _2171 - (float(_2172));
                                float _2176 = _11[_2172];
                                float _2179 = _11[(_2172 + 1)];
                                float _2184 = _2176 * 0.5f;
                                _2194 = (dot(float3((_2174 * _2174), _2174, 1.0f), float3((mad((_11[(_2172 + 2)]), 0.5f, (mad(_2179, -1.0f, _2184)))), (_2179 - _2176), (mad(_2179, 0.5f, _2184)))));
                                break;
                              }
                            }
                            _2194 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2198 = log2((max((((_2036 - _2037) * 0.9599999785423279f) + _2037), 1.000000013351432e-10f)));
                      float _2199 = _2198 * 0.3010300099849701f;
                      do {
                        if (!(!(_2199 <= _2051))) {
                          _2268 = ((log2((cb0_008y))) * 0.3010300099849701f);
                        } else {
                          float _2206 = log2((cb0_009x));
                          float _2207 = _2206 * 0.3010300099849701f;
                          if ((((bool)((_2199 > _2051))) && ((bool)((_2199 < _2207))))) {
                            float _2215 = ((_2198 - _2050) * 0.9030900001525879f) / ((_2206 - _2050) * 0.3010300099849701f);
                            int _2216 = int(2216);
                            float _2218 = _2215 - (float(_2216));
                            float _2220 = _10[_2216];
                            float _2223 = _10[(_2216 + 1)];
                            float _2228 = _2220 * 0.5f;
                            _2268 = (dot(float3((_2218 * _2218), _2218, 1.0f), float3((mad((_10[(_2216 + 2)]), 0.5f, (mad(_2223, -1.0f, _2228)))), (_2223 - _2220), (mad(_2223, 0.5f, _2228)))));
                          } else {
                            do {
                              if (!(!(_2199 >= _2207))) {
                                float _2237 = log2((cb0_008z));
                                if (((_2199 < (_2237 * 0.3010300099849701f)))) {
                                  float _2245 = ((_2198 - _2206) * 0.9030900001525879f) / ((_2237 - _2206) * 0.3010300099849701f);
                                  int _2246 = int(2246);
                                  float _2248 = _2245 - (float(_2246));
                                  float _2250 = _11[_2246];
                                  float _2253 = _11[(_2246 + 1)];
                                  float _2258 = _2250 * 0.5f;
                                  _2268 = (dot(float3((_2248 * _2248), _2248, 1.0f), float3((mad((_11[(_2246 + 2)]), 0.5f, (mad(_2253, -1.0f, _2258)))), (_2253 - _2250), (mad(_2253, 0.5f, _2258)))));
                                  break;
                                }
                              }
                              _2268 = ((log2((cb0_008w))) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2272 = (cb0_008w) - (cb0_008y);
                        float _2273 = ((exp2((_2120 * 3.321928024291992f))) - (cb0_008y)) / _2272;
                        float _2275 = ((exp2((_2194 * 3.321928024291992f))) - (cb0_008y)) / _2272;
                        float _2277 = ((exp2((_2268 * 3.321928024291992f))) - (cb0_008y)) / _2272;
                        float _2280 = mad(0.15618768334388733f, _2277, (mad(0.13400420546531677f, _2275, (_2273 * 0.6624541878700256f))));
                        float _2283 = mad(0.053689517080783844f, _2277, (mad(0.6740817427635193f, _2275, (_2273 * 0.2722287178039551f))));
                        float _2286 = mad(1.0103391408920288f, _2277, (mad(0.00406073359772563f, _2275, (_2273 * -0.005574649665504694f))));
                        float _2299 = min((max((mad(-0.23642469942569733f, _2286, (mad(-0.32480329275131226f, _2283, (_2280 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                        float _2300 = min((max((mad(0.016756348311901093f, _2286, (mad(1.6153316497802734f, _2283, (_2280 * -0.663662850856781f))))), 0.0f)), 1.0f);
                        float _2301 = min((max((mad(0.9883948564529419f, _2286, (mad(-0.008284442126750946f, _2283, (_2280 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                        float _2304 = mad(0.15618768334388733f, _2301, (mad(0.13400420546531677f, _2300, (_2299 * 0.6624541878700256f))));
                        float _2307 = mad(0.053689517080783844f, _2301, (mad(0.6740817427635193f, _2300, (_2299 * 0.2722287178039551f))));
                        float _2310 = mad(1.0103391408920288f, _2301, (mad(0.00406073359772563f, _2300, (_2299 * -0.005574649665504694f))));
                        float _2332 = min((max(((min((max((mad(-0.23642469942569733f, _2310, (mad(-0.32480329275131226f, _2307, (_2304 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2333 = min((max(((min((max((mad(0.016756348311901093f, _2310, (mad(1.6153316497802734f, _2307, (_2304 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2334 = min((max(((min((max((mad(0.9883948564529419f, _2310, (mad(-0.008284442126750946f, _2307, (_2304 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        _2347 = _2332;
                        _2348 = _2333;
                        _2349 = _2334;
                        do {
                          if (!((((uint)(cb0_042w)) == 6))) {
                            _2347 = (mad(_47, _2334, (mad(_46, _2333, (_2332 * _45)))));
                            _2348 = (mad(_50, _2334, (mad(_49, _2333, (_2332 * _48)))));
                            _2349 = (mad(_53, _2334, (mad(_52, _2333, (_2332 * _51)))));
                          }
                          float _2359 = exp2(((log2((_2347 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2360 = exp2(((log2((_2348 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2361 = exp2(((log2((_2349 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          _2526 = (exp2(((log2(((1.0f / ((_2359 * 18.6875f) + 1.0f)) * ((_2359 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2527 = (exp2(((log2(((1.0f / ((_2360 * 18.6875f) + 1.0f)) * ((_2360 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2528 = (exp2(((log2(((1.0f / ((_2361 * 18.6875f) + 1.0f)) * ((_2361 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (((((uint)(cb0_042w)) == 7))) {
            float _2406 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1067, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1066, ((UniformBufferConstants_WorkingColorSpace_008x)*_1065))));
            float _2409 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1067, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1066, ((UniformBufferConstants_WorkingColorSpace_009x)*_1065))));
            float _2412 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1067, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1066, ((UniformBufferConstants_WorkingColorSpace_010x)*_1065))));
            float _2431 = exp2(((log2(((mad(_47, _2412, (mad(_46, _2409, (_2406 * _45))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2432 = exp2(((log2(((mad(_50, _2412, (mad(_49, _2409, (_2406 * _48))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2433 = exp2(((log2(((mad(_53, _2412, (mad(_52, _2409, (_2406 * _51))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            _2526 = (exp2(((log2(((1.0f / ((_2431 * 18.6875f) + 1.0f)) * ((_2431 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2527 = (exp2(((log2(((1.0f / ((_2432 * 18.6875f) + 1.0f)) * ((_2432 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2528 = (exp2(((log2(((1.0f / ((_2433 * 18.6875f) + 1.0f)) * ((_2433 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
          } else {
            _2526 = _1065;
            _2527 = _1066;
            _2528 = _1067;
            if (!((((uint)(cb0_042w)) == 8))) {
              if (((((uint)(cb0_042w)) == 9))) {
                float _2480 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1055, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1054, ((UniformBufferConstants_WorkingColorSpace_008x)*_1053))));
                float _2483 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1055, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1054, ((UniformBufferConstants_WorkingColorSpace_009x)*_1053))));
                float _2486 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1055, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1054, ((UniformBufferConstants_WorkingColorSpace_010x)*_1053))));
                _2526 = (mad(_47, _2486, (mad(_46, _2483, (_2480 * _45)))));
                _2527 = (mad(_50, _2486, (mad(_49, _2483, (_2480 * _48)))));
                _2528 = (mad(_53, _2486, (mad(_52, _2483, (_2480 * _51)))));
              } else {
                float _2499 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1080, ((UniformBufferConstants_WorkingColorSpace_008x)*_1079))));
                float _2502 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1080, ((UniformBufferConstants_WorkingColorSpace_009x)*_1079))));
                float _2505 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1080, ((UniformBufferConstants_WorkingColorSpace_010x)*_1079))));
                _2526 = (exp2(((log2((mad(_47, _2505, (mad(_46, _2502, (_2499 * _45))))))) * (cb0_042z))));
                _2527 = (exp2(((log2((mad(_50, _2505, (mad(_49, _2502, (_2499 * _48))))))) * (cb0_042z))));
                _2528 = (exp2(((log2((mad(_53, _2505, (mad(_52, _2502, (_2499 * _51))))))) * (cb0_042z))));
              }
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2526 * 0.9523810148239136f);
  SV_Target.y = (_2527 * 0.9523810148239136f);
  SV_Target.z = (_2528 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
