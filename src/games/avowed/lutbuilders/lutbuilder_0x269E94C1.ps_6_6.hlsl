#include "../common.hlsl"

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
  uint cb0_040w : packoffset(c040.w);
  uint cb0_041x : packoffset(c041.x);
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
  float _16 = 0.5f / (cb0_035x);
  float _21 = (cb0_035x) + -1.0f;
  float _22 = ((cb0_035x) * ((TEXCOORD.x) - _16)) / _21;
  float _23 = ((cb0_035x) * ((TEXCOORD.y) - _16)) / _21;
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
  float _1121;
  float _1122;
  float _1123;
  float _1134;
  float _1145;
  float _1325;
  float _1358;
  float _1372;
  float _1411;
  float _1521;
  float _1595;
  float _1669;
  float _1748;
  float _1749;
  float _1750;
  float _1899;
  float _1932;
  float _1946;
  float _1985;
  float _2095;
  float _2169;
  float _2243;
  float _2322;
  float _2323;
  float _2324;
  float _2501;
  float _2502;
  float _2503;
  if (!((((uint)(cb0_041x)) == 1))) {
    _45 = 1.02579927444458f;
    _46 = -0.020052503794431686f;
    _47 = -0.0057713985443115234f;
    _48 = -0.0022350111976265907f;
    _49 = 1.0045825242996216f;
    _50 = -0.002352306619286537f;
    _51 = -0.005014004185795784f;
    _52 = -0.025293385609984398f;
    _53 = 1.0304402112960815f;
    if (!((((uint)(cb0_041x)) == 2))) {
      _45 = 0.6954522132873535f;
      _46 = 0.14067870378494263f;
      _47 = 0.16386906802654266f;
      _48 = 0.044794563204050064f;
      _49 = 0.8596711158752441f;
      _50 = 0.0955343171954155f;
      _51 = -0.005525882821530104f;
      _52 = 0.004025210160762072f;
      _53 = 1.0015007257461548f;
      if (!((((uint)(cb0_041x)) == 3))) {
        bool _34 = (((uint)(cb0_041x)) == 4);
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
  if (((((uint)(cb0_040w)) > 2))) {
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
  float _153 = (1.0f - (exp2((((_135 * _135) * -4.0f) * (cb0_036w))))) * (1.0f - (exp2(((dot(float3(_139, _140, _141), float3(_139, _140, _141))) * -4.0f))));
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
  float _305 = saturate((_172 / (cb0_035w)));
  float _309 = (_305 * _305) * (3.0f - (_305 * 2.0f));
  float _310 = 1.0f - _309;
  float _319 = (cb0_019w) + (cb0_034w);
  float _328 = (cb0_018w) * (cb0_033w);
  float _337 = (cb0_017w) * (cb0_032w);
  float _346 = (cb0_016w) * (cb0_031w);
  float _355 = (cb0_015w) * (cb0_030w);
  float _418 = saturate(((_172 - (cb0_036x)) / ((cb0_036y) - (cb0_036x))));
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

  SetUntonemappedAP1(float3(_536, _538, _540));

  float _576 = (((mad(0.061360642313957214f, _540, (mad(-4.540197551250458e-09f, _538, (_536 * 0.9386394023895264f))))) - _536) * (cb0_036z)) + _536;
  float _577 = (((mad(0.169205904006958f, _540, (mad(0.8307942152023315f, _538, (_536 * 6.775371730327606e-08f))))) - _538) * (cb0_036z)) + _538;
  float _578 = ((mad(-2.3283064365386963e-10f, _538, (_536 * -9.313225746154785e-10f))) * (cb0_036z)) + _540;
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
  float _725 = ((cb0_038x) + 1.0f) - (cb0_037z);
  float _727 = (cb0_038y) + 1.0f;
  float _729 = _727 - (cb0_037w);
  if ((((cb0_037z) > 0.800000011920929f))) {
    _747 = (((0.8199999928474426f - (cb0_037z)) / (cb0_037y)) + -0.7447274923324585f);
  } else {
    float _738 = ((cb0_038x) + 0.18000000715255737f) / _725;
    _747 = (-0.7447274923324585f - (((log2((_738 / (2.0f - _738)))) * 0.3465735912322998f) * (_725 / (cb0_037y))));
  }
  float _750 = ((1.0f - (cb0_037z)) / (cb0_037y)) - _747;
  float _752 = ((cb0_037w) / (cb0_037y)) - _750;
  float _756 = (log2((((_707 - _710) * 0.9599999785423279f) + _710))) * 0.3010300099849701f;
  float _757 = (log2((((_708 - _710) * 0.9599999785423279f) + _710))) * 0.3010300099849701f;
  float _758 = (log2((((_709 - _710) * 0.9599999785423279f) + _710))) * 0.3010300099849701f;
  float _762 = (cb0_037y) * (_756 + _750);
  float _763 = (cb0_037y) * (_757 + _750);
  float _764 = (cb0_037y) * (_758 + _750);
  float _765 = _725 * 2.0f;
  float _767 = ((cb0_037y) * -2.0f) / _725;
  float _768 = _756 - _747;
  float _769 = _757 - _747;
  float _770 = _758 - _747;
  float _789 = _729 * 2.0f;
  float _791 = ((cb0_037y) * 2.0f) / _729;
  float _816 = (((bool)((_756 < _747))) ? ((_765 / ((exp2(((_768 * 1.4426950216293335f) * _767))) + 1.0f)) - (cb0_038x)) : _762);
  float _817 = (((bool)((_757 < _747))) ? ((_765 / ((exp2(((_769 * 1.4426950216293335f) * _767))) + 1.0f)) - (cb0_038x)) : _763);
  float _818 = (((bool)((_758 < _747))) ? ((_765 / ((exp2(((_770 * 1.4426950216293335f) * _767))) + 1.0f)) - (cb0_038x)) : _764);
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
  float _880 = ((cb0_037x) * ((max(0.0f, (((_857 - _860) * 0.9300000071525574f) + _860))) - _576)) + _576;
  float _881 = ((cb0_037x) * ((max(0.0f, (((_858 - _860) * 0.9300000071525574f) + _860))) - _577)) + _577;
  float _882 = ((cb0_037x) * ((max(0.0f, (((_859 - _860) * 0.9300000071525574f) + _860))) - _578)) + _578;
  float _898 = (((mad(-0.06537103652954102f, _882, (mad(1.451815478503704e-06f, _881, (_880 * 1.065374732017517f))))) - _880) * (cb0_036z)) + _880;
  float _899 = (((mad(-0.20366770029067993f, _882, (mad(1.2036634683609009f, _881, (_880 * -2.57161445915699e-07f))))) - _881) * (cb0_036z)) + _881;
  float _900 = (((mad(0.9999996423721313f, _882, (mad(2.0954757928848267e-08f, _881, (_880 * 1.862645149230957e-08f))))) - _882) * (cb0_036z)) + _882;

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
  float _1044 = (cb0_014x) * ((((cb0_039y) + ((cb0_039x)*_1016)) * _1016) + (cb0_039z));
  float _1045 = (cb0_014y) * ((((cb0_039y) + ((cb0_039x)*_1017)) * _1017) + (cb0_039z));
  float _1046 = (cb0_014z) * ((((cb0_039y) + ((cb0_039x)*_1018)) * _1018) + (cb0_039z));
  float _1053 = (((cb0_013x)-_1044) * (cb0_013w)) + _1044;
  float _1054 = (((cb0_013y)-_1045) * (cb0_013w)) + _1045;
  float _1055 = (((cb0_013z)-_1046) * (cb0_013w)) + _1046;
  float _1056 = (cb0_014x) * (mad((UniformBufferConstants_WorkingColorSpace_012z), _540, (mad((UniformBufferConstants_WorkingColorSpace_012y), _538, (_536 * (UniformBufferConstants_WorkingColorSpace_012x))))));
  float _1057 = (cb0_014y) * (mad((UniformBufferConstants_WorkingColorSpace_013z), _540, (mad((UniformBufferConstants_WorkingColorSpace_013y), _538, ((UniformBufferConstants_WorkingColorSpace_013x)*_536)))));
  float _1058 = (cb0_014z) * (mad((UniformBufferConstants_WorkingColorSpace_014z), _540, (mad((UniformBufferConstants_WorkingColorSpace_014y), _538, ((UniformBufferConstants_WorkingColorSpace_014x)*_536)))));
  float _1065 = (((cb0_013x)-_1056) * (cb0_013w)) + _1056;
  float _1066 = (((cb0_013y)-_1057) * (cb0_013w)) + _1057;
  float _1067 = (((cb0_013z)-_1058) * (cb0_013w)) + _1058;
  float _1079 = exp2(((log2((max(0.0f, _1053)))) * (cb0_040y)));
  float _1080 = exp2(((log2((max(0.0f, _1054)))) * (cb0_040y)));
  float _1081 = exp2(((log2((max(0.0f, _1055)))) * (cb0_040y)));

  if (true) {
    return GenerateOutput(float3(_1079, _1080, _1081), cb0_040w);
  }

  if (((((uint)(cb0_040w)) == 0))) {
    _1121 = _1079;
    _1122 = _1080;
    _1123 = _1081;
    do {
      if (((((uint)(UniformBufferConstants_WorkingColorSpace_020x)) == 0))) {
        float _1104 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1080, ((UniformBufferConstants_WorkingColorSpace_008x)*_1079))));
        float _1107 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1080, ((UniformBufferConstants_WorkingColorSpace_009x)*_1079))));
        float _1110 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1080, ((UniformBufferConstants_WorkingColorSpace_010x)*_1079))));
        _1121 = (mad(_47, _1110, (mad(_46, _1107, (_1104 * _45)))));
        _1122 = (mad(_50, _1110, (mad(_49, _1107, (_1104 * _48)))));
        _1123 = (mad(_53, _1110, (mad(_52, _1107, (_1104 * _51)))));
      }
      do {
        if (((_1121 < 0.0031306699384003878f))) {
          _1134 = (_1121 * 12.920000076293945f);
        } else {
          _1134 = (((exp2(((log2(_1121)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (((_1122 < 0.0031306699384003878f))) {
            _1145 = (_1122 * 12.920000076293945f);
          } else {
            _1145 = (((exp2(((log2(_1122)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (((_1123 < 0.0031306699384003878f))) {
            _2501 = _1134;
            _2502 = _1145;
            _2503 = (_1123 * 12.920000076293945f);
          } else {
            _2501 = _1134;
            _2502 = _1145;
            _2503 = (((exp2(((log2(_1123)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (((((uint)(cb0_040w)) == 1))) {
      float _1172 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1080, ((UniformBufferConstants_WorkingColorSpace_008x)*_1079))));
      float _1175 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1080, ((UniformBufferConstants_WorkingColorSpace_009x)*_1079))));
      float _1178 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1080, ((UniformBufferConstants_WorkingColorSpace_010x)*_1079))));
      float _1188 = max(6.103519990574569e-05f, (mad(_47, _1178, (mad(_46, _1175, (_1172 * _45))))));
      float _1189 = max(6.103519990574569e-05f, (mad(_50, _1178, (mad(_49, _1175, (_1172 * _48))))));
      float _1190 = max(6.103519990574569e-05f, (mad(_53, _1178, (mad(_52, _1175, (_1172 * _51))))));
      _2501 = (min((_1188 * 4.5f), (((exp2(((log2((max(_1188, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2502 = (min((_1189 * 4.5f), (((exp2(((log2((max(_1189, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2503 = (min((_1190 * 4.5f), (((exp2(((log2((max(_1190, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
    } else {
      if ((((bool)((((uint)(cb0_040w)) == 3))) || ((bool)((((uint)(cb0_040w)) == 5))))) {
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
        float _1265 = (cb0_012z)*_1065;
        float _1266 = (cb0_012z)*_1066;
        float _1267 = (cb0_012z)*_1067;
        float _1270 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1267, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1266, ((UniformBufferConstants_WorkingColorSpace_016x)*_1265))));
        float _1273 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1267, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1266, ((UniformBufferConstants_WorkingColorSpace_017x)*_1265))));
        float _1276 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1267, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1266, ((UniformBufferConstants_WorkingColorSpace_018x)*_1265))));
        float _1280 = max((max(_1270, _1273)), _1276);
        float _1285 = ((max(_1280, 1.000000013351432e-10f)) - (max((min((min(_1270, _1273)), _1276)), 1.000000013351432e-10f))) / (max(_1280, 0.009999999776482582f));
        float _1298 = ((_1273 + _1270) + _1276) + ((sqrt(((((_1276 - _1273) * _1276) + ((_1273 - _1270) * _1273)) + ((_1270 - _1276) * _1270)))) * 1.75f);
        float _1299 = _1298 * 0.3333333432674408f;
        float _1300 = _1285 + -0.4000000059604645f;
        float _1301 = _1300 * 5.0f;
        float _1305 = max((1.0f - (abs((_1300 * 2.5f)))), 0.0f);
        float _1316 = (((float(((int(((bool)((_1301 > 0.0f))))) - (int(((bool)((_1301 < 0.0f)))))))) * (1.0f - (_1305 * _1305))) + 1.0f) * 0.02500000037252903f;
        _1325 = _1316;
        do {
          if ((!(_1299 <= 0.0533333346247673f))) {
            _1325 = 0.0f;
            if ((!(_1299 >= 0.1599999964237213f))) {
              _1325 = (((0.23999999463558197f / _1298) + -0.5f) * _1316);
            }
          }
          float _1326 = _1325 + 1.0f;
          float _1327 = _1326 * _1270;
          float _1328 = _1326 * _1273;
          float _1329 = _1326 * _1276;
          _1358 = 0.0f;
          do {
            if (!(((bool)((_1327 == _1328))) && ((bool)((_1328 == _1329))))) {
              float _1336 = ((_1327 * 2.0f) - _1328) - _1329;
              float _1339 = ((_1273 - _1276) * 1.7320507764816284f) * _1326;
              float _1341 = atan((_1339 / _1336));
              bool _1344 = (_1336 < 0.0f);
              bool _1345 = (_1336 == 0.0f);
              bool _1346 = (_1339 >= 0.0f);
              bool _1347 = (_1339 < 0.0f);
              _1358 = ((((bool)(_1346 && _1345)) ? 90.0f : ((((bool)(_1347 && _1345)) ? -90.0f : (((((bool)(_1347 && _1344)) ? (_1341 + -3.1415927410125732f) : ((((bool)(_1346 && _1344)) ? (_1341 + 3.1415927410125732f) : _1341)))) * 57.2957763671875f)))));
            }
            float _1363 = min((max(((((bool)((_1358 < 0.0f))) ? (_1358 + 360.0f) : _1358)), 0.0f)), 360.0f);
            do {
              if (((_1363 < -180.0f))) {
                _1372 = (_1363 + 360.0f);
              } else {
                _1372 = _1363;
                if (((_1363 > 180.0f))) {
                  _1372 = (_1363 + -360.0f);
                }
              }
              _1411 = 0.0f;
              do {
                if ((((bool)((_1372 > -67.5f))) && ((bool)((_1372 < 67.5f))))) {
                  float _1378 = (_1372 + 67.5f) * 0.029629629105329514f;
                  int _1379 = int(1379);
                  float _1381 = _1378 - (float(_1379));
                  float _1382 = _1381 * _1381;
                  float _1383 = _1382 * _1381;
                  if (((_1379 == 3))) {
                    _1411 = (((0.1666666716337204f - (_1381 * 0.5f)) + (_1382 * 0.5f)) - (_1383 * 0.1666666716337204f));
                  } else {
                    if (((_1379 == 2))) {
                      _1411 = ((0.6666666865348816f - _1382) + (_1383 * 0.5f));
                    } else {
                      if (((_1379 == 1))) {
                        _1411 = (((_1383 * -0.5f) + 0.1666666716337204f) + ((_1382 + _1381) * 0.5f));
                      } else {
                        _1411 = ((((bool)((_1379 == 0))) ? (_1383 * 0.1666666716337204f) : 0.0f));
                      }
                    }
                  }
                }
                float _1420 = min((max(((((_1285 * 0.27000001072883606f) * (0.029999999329447746f - _1327)) * _1411) + _1327), 0.0f)), 65535.0f);
                float _1421 = min((max(_1328, 0.0f)), 65535.0f);
                float _1422 = min((max(_1329, 0.0f)), 65535.0f);
                float _1435 = min((max((mad(-0.21492856740951538f, _1422, (mad(-0.2365107536315918f, _1421, (_1420 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                float _1436 = min((max((mad(-0.09967592358589172f, _1422, (mad(1.17622971534729f, _1421, (_1420 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                float _1437 = min((max((mad(0.9977163076400757f, _1422, (mad(-0.006032449658960104f, _1421, (_1420 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                float _1438 = dot(float3(_1435, _1436, _1437), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1449 = log2((max((((_1435 - _1438) * 0.9599999785423279f) + _1438), 1.000000013351432e-10f)));
                float _1450 = _1449 * 0.3010300099849701f;
                float _1451 = log2((cb0_008x));
                float _1452 = _1451 * 0.3010300099849701f;
                do {
                  if (!(!(_1450 <= _1452))) {
                    _1521 = ((log2((cb0_008y))) * 0.3010300099849701f);
                  } else {
                    float _1459 = log2((cb0_009x));
                    float _1460 = _1459 * 0.3010300099849701f;
                    if ((((bool)((_1450 > _1452))) && ((bool)((_1450 < _1460))))) {
                      float _1468 = ((_1449 - _1451) * 0.9030900001525879f) / ((_1459 - _1451) * 0.3010300099849701f);
                      int _1469 = int(1469);
                      float _1471 = _1468 - (float(_1469));
                      float _1473 = _12[_1469];
                      float _1476 = _12[(_1469 + 1)];
                      float _1481 = _1473 * 0.5f;
                      _1521 = (dot(float3((_1471 * _1471), _1471, 1.0f), float3((mad((_12[(_1469 + 2)]), 0.5f, (mad(_1476, -1.0f, _1481)))), (_1476 - _1473), (mad(_1476, 0.5f, _1481)))));
                    } else {
                      do {
                        if (!(!(_1450 >= _1460))) {
                          float _1490 = log2((cb0_008z));
                          if (((_1450 < (_1490 * 0.3010300099849701f)))) {
                            float _1498 = ((_1449 - _1459) * 0.9030900001525879f) / ((_1490 - _1459) * 0.3010300099849701f);
                            int _1499 = int(1499);
                            float _1501 = _1498 - (float(_1499));
                            float _1503 = _13[_1499];
                            float _1506 = _13[(_1499 + 1)];
                            float _1511 = _1503 * 0.5f;
                            _1521 = (dot(float3((_1501 * _1501), _1501, 1.0f), float3((mad((_13[(_1499 + 2)]), 0.5f, (mad(_1506, -1.0f, _1511)))), (_1506 - _1503), (mad(_1506, 0.5f, _1511)))));
                            break;
                          }
                        }
                        _1521 = ((log2((cb0_008w))) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1525 = log2((max((((_1436 - _1438) * 0.9599999785423279f) + _1438), 1.000000013351432e-10f)));
                  float _1526 = _1525 * 0.3010300099849701f;
                  do {
                    if (!(!(_1526 <= _1452))) {
                      _1595 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _1533 = log2((cb0_009x));
                      float _1534 = _1533 * 0.3010300099849701f;
                      if ((((bool)((_1526 > _1452))) && ((bool)((_1526 < _1534))))) {
                        float _1542 = ((_1525 - _1451) * 0.9030900001525879f) / ((_1533 - _1451) * 0.3010300099849701f);
                        int _1543 = int(1543);
                        float _1545 = _1542 - (float(_1543));
                        float _1547 = _12[_1543];
                        float _1550 = _12[(_1543 + 1)];
                        float _1555 = _1547 * 0.5f;
                        _1595 = (dot(float3((_1545 * _1545), _1545, 1.0f), float3((mad((_12[(_1543 + 2)]), 0.5f, (mad(_1550, -1.0f, _1555)))), (_1550 - _1547), (mad(_1550, 0.5f, _1555)))));
                      } else {
                        do {
                          if (!(!(_1526 >= _1534))) {
                            float _1564 = log2((cb0_008z));
                            if (((_1526 < (_1564 * 0.3010300099849701f)))) {
                              float _1572 = ((_1525 - _1533) * 0.9030900001525879f) / ((_1564 - _1533) * 0.3010300099849701f);
                              int _1573 = int(1573);
                              float _1575 = _1572 - (float(_1573));
                              float _1577 = _13[_1573];
                              float _1580 = _13[(_1573 + 1)];
                              float _1585 = _1577 * 0.5f;
                              _1595 = (dot(float3((_1575 * _1575), _1575, 1.0f), float3((mad((_13[(_1573 + 2)]), 0.5f, (mad(_1580, -1.0f, _1585)))), (_1580 - _1577), (mad(_1580, 0.5f, _1585)))));
                              break;
                            }
                          }
                          _1595 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1599 = log2((max((((_1437 - _1438) * 0.9599999785423279f) + _1438), 1.000000013351432e-10f)));
                    float _1600 = _1599 * 0.3010300099849701f;
                    do {
                      if (!(!(_1600 <= _1452))) {
                        _1669 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _1607 = log2((cb0_009x));
                        float _1608 = _1607 * 0.3010300099849701f;
                        if ((((bool)((_1600 > _1452))) && ((bool)((_1600 < _1608))))) {
                          float _1616 = ((_1599 - _1451) * 0.9030900001525879f) / ((_1607 - _1451) * 0.3010300099849701f);
                          int _1617 = int(1617);
                          float _1619 = _1616 - (float(_1617));
                          float _1621 = _12[_1617];
                          float _1624 = _12[(_1617 + 1)];
                          float _1629 = _1621 * 0.5f;
                          _1669 = (dot(float3((_1619 * _1619), _1619, 1.0f), float3((mad((_12[(_1617 + 2)]), 0.5f, (mad(_1624, -1.0f, _1629)))), (_1624 - _1621), (mad(_1624, 0.5f, _1629)))));
                        } else {
                          do {
                            if (!(!(_1600 >= _1608))) {
                              float _1638 = log2((cb0_008z));
                              if (((_1600 < (_1638 * 0.3010300099849701f)))) {
                                float _1646 = ((_1599 - _1607) * 0.9030900001525879f) / ((_1638 - _1607) * 0.3010300099849701f);
                                int _1647 = int(1647);
                                float _1649 = _1646 - (float(_1647));
                                float _1651 = _13[_1647];
                                float _1654 = _13[(_1647 + 1)];
                                float _1659 = _1651 * 0.5f;
                                _1669 = (dot(float3((_1649 * _1649), _1649, 1.0f), float3((mad((_13[(_1647 + 2)]), 0.5f, (mad(_1654, -1.0f, _1659)))), (_1654 - _1651), (mad(_1654, 0.5f, _1659)))));
                                break;
                              }
                            }
                            _1669 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1673 = (cb0_008w) - (cb0_008y);
                      float _1674 = ((exp2((_1521 * 3.321928024291992f))) - (cb0_008y)) / _1673;
                      float _1676 = ((exp2((_1595 * 3.321928024291992f))) - (cb0_008y)) / _1673;
                      float _1678 = ((exp2((_1669 * 3.321928024291992f))) - (cb0_008y)) / _1673;
                      float _1681 = mad(0.15618768334388733f, _1678, (mad(0.13400420546531677f, _1676, (_1674 * 0.6624541878700256f))));
                      float _1684 = mad(0.053689517080783844f, _1678, (mad(0.6740817427635193f, _1676, (_1674 * 0.2722287178039551f))));
                      float _1687 = mad(1.0103391408920288f, _1678, (mad(0.00406073359772563f, _1676, (_1674 * -0.005574649665504694f))));
                      float _1700 = min((max((mad(-0.23642469942569733f, _1687, (mad(-0.32480329275131226f, _1684, (_1681 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                      float _1701 = min((max((mad(0.016756348311901093f, _1687, (mad(1.6153316497802734f, _1684, (_1681 * -0.663662850856781f))))), 0.0f)), 1.0f);
                      float _1702 = min((max((mad(0.9883948564529419f, _1687, (mad(-0.008284442126750946f, _1684, (_1681 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                      float _1705 = mad(0.15618768334388733f, _1702, (mad(0.13400420546531677f, _1701, (_1700 * 0.6624541878700256f))));
                      float _1708 = mad(0.053689517080783844f, _1702, (mad(0.6740817427635193f, _1701, (_1700 * 0.2722287178039551f))));
                      float _1711 = mad(1.0103391408920288f, _1702, (mad(0.00406073359772563f, _1701, (_1700 * -0.005574649665504694f))));
                      float _1733 = min((max(((min((max((mad(-0.23642469942569733f, _1711, (mad(-0.32480329275131226f, _1708, (_1705 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1734 = min((max(((min((max((mad(0.016756348311901093f, _1711, (mad(1.6153316497802734f, _1708, (_1705 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1735 = min((max(((min((max((mad(0.9883948564529419f, _1711, (mad(-0.008284442126750946f, _1708, (_1705 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      _1748 = _1733;
                      _1749 = _1734;
                      _1750 = _1735;
                      do {
                        if (!((((uint)(cb0_040w)) == 5))) {
                          _1748 = (mad(_47, _1735, (mad(_46, _1734, (_1733 * _45)))));
                          _1749 = (mad(_50, _1735, (mad(_49, _1734, (_1733 * _48)))));
                          _1750 = (mad(_53, _1735, (mad(_52, _1734, (_1733 * _51)))));
                        }
                        float _1760 = exp2(((log2((_1748 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1761 = exp2(((log2((_1749 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1762 = exp2(((log2((_1750 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        _2501 = (exp2(((log2(((1.0f / ((_1760 * 18.6875f) + 1.0f)) * ((_1760 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2502 = (exp2(((log2(((1.0f / ((_1761 * 18.6875f) + 1.0f)) * ((_1761 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2503 = (exp2(((log2(((1.0f / ((_1762 * 18.6875f) + 1.0f)) * ((_1762 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        if ((((((uint)(cb0_040w)) & -3) == 4))) {
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
          float _1839 = (cb0_012z)*_1065;
          float _1840 = (cb0_012z)*_1066;
          float _1841 = (cb0_012z)*_1067;
          float _1844 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1841, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1840, ((UniformBufferConstants_WorkingColorSpace_016x)*_1839))));
          float _1847 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1841, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1840, ((UniformBufferConstants_WorkingColorSpace_017x)*_1839))));
          float _1850 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1841, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1840, ((UniformBufferConstants_WorkingColorSpace_018x)*_1839))));
          float _1854 = max((max(_1844, _1847)), _1850);
          float _1859 = ((max(_1854, 1.000000013351432e-10f)) - (max((min((min(_1844, _1847)), _1850)), 1.000000013351432e-10f))) / (max(_1854, 0.009999999776482582f));
          float _1872 = ((_1847 + _1844) + _1850) + ((sqrt(((((_1850 - _1847) * _1850) + ((_1847 - _1844) * _1847)) + ((_1844 - _1850) * _1844)))) * 1.75f);
          float _1873 = _1872 * 0.3333333432674408f;
          float _1874 = _1859 + -0.4000000059604645f;
          float _1875 = _1874 * 5.0f;
          float _1879 = max((1.0f - (abs((_1874 * 2.5f)))), 0.0f);
          float _1890 = (((float(((int(((bool)((_1875 > 0.0f))))) - (int(((bool)((_1875 < 0.0f)))))))) * (1.0f - (_1879 * _1879))) + 1.0f) * 0.02500000037252903f;
          _1899 = _1890;
          do {
            if ((!(_1873 <= 0.0533333346247673f))) {
              _1899 = 0.0f;
              if ((!(_1873 >= 0.1599999964237213f))) {
                _1899 = (((0.23999999463558197f / _1872) + -0.5f) * _1890);
              }
            }
            float _1900 = _1899 + 1.0f;
            float _1901 = _1900 * _1844;
            float _1902 = _1900 * _1847;
            float _1903 = _1900 * _1850;
            _1932 = 0.0f;
            do {
              if (!(((bool)((_1901 == _1902))) && ((bool)((_1902 == _1903))))) {
                float _1910 = ((_1901 * 2.0f) - _1902) - _1903;
                float _1913 = ((_1847 - _1850) * 1.7320507764816284f) * _1900;
                float _1915 = atan((_1913 / _1910));
                bool _1918 = (_1910 < 0.0f);
                bool _1919 = (_1910 == 0.0f);
                bool _1920 = (_1913 >= 0.0f);
                bool _1921 = (_1913 < 0.0f);
                _1932 = ((((bool)(_1920 && _1919)) ? 90.0f : ((((bool)(_1921 && _1919)) ? -90.0f : (((((bool)(_1921 && _1918)) ? (_1915 + -3.1415927410125732f) : ((((bool)(_1920 && _1918)) ? (_1915 + 3.1415927410125732f) : _1915)))) * 57.2957763671875f)))));
              }
              float _1937 = min((max(((((bool)((_1932 < 0.0f))) ? (_1932 + 360.0f) : _1932)), 0.0f)), 360.0f);
              do {
                if (((_1937 < -180.0f))) {
                  _1946 = (_1937 + 360.0f);
                } else {
                  _1946 = _1937;
                  if (((_1937 > 180.0f))) {
                    _1946 = (_1937 + -360.0f);
                  }
                }
                _1985 = 0.0f;
                do {
                  if ((((bool)((_1946 > -67.5f))) && ((bool)((_1946 < 67.5f))))) {
                    float _1952 = (_1946 + 67.5f) * 0.029629629105329514f;
                    int _1953 = int(1953);
                    float _1955 = _1952 - (float(_1953));
                    float _1956 = _1955 * _1955;
                    float _1957 = _1956 * _1955;
                    if (((_1953 == 3))) {
                      _1985 = (((0.1666666716337204f - (_1955 * 0.5f)) + (_1956 * 0.5f)) - (_1957 * 0.1666666716337204f));
                    } else {
                      if (((_1953 == 2))) {
                        _1985 = ((0.6666666865348816f - _1956) + (_1957 * 0.5f));
                      } else {
                        if (((_1953 == 1))) {
                          _1985 = (((_1957 * -0.5f) + 0.1666666716337204f) + ((_1956 + _1955) * 0.5f));
                        } else {
                          _1985 = ((((bool)((_1953 == 0))) ? (_1957 * 0.1666666716337204f) : 0.0f));
                        }
                      }
                    }
                  }
                  float _1994 = min((max(((((_1859 * 0.27000001072883606f) * (0.029999999329447746f - _1901)) * _1985) + _1901), 0.0f)), 65535.0f);
                  float _1995 = min((max(_1902, 0.0f)), 65535.0f);
                  float _1996 = min((max(_1903, 0.0f)), 65535.0f);
                  float _2009 = min((max((mad(-0.21492856740951538f, _1996, (mad(-0.2365107536315918f, _1995, (_1994 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                  float _2010 = min((max((mad(-0.09967592358589172f, _1996, (mad(1.17622971534729f, _1995, (_1994 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                  float _2011 = min((max((mad(0.9977163076400757f, _1996, (mad(-0.006032449658960104f, _1995, (_1994 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                  float _2012 = dot(float3(_2009, _2010, _2011), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _2023 = log2((max((((_2009 - _2012) * 0.9599999785423279f) + _2012), 1.000000013351432e-10f)));
                  float _2024 = _2023 * 0.3010300099849701f;
                  float _2025 = log2((cb0_008x));
                  float _2026 = _2025 * 0.3010300099849701f;
                  do {
                    if (!(!(_2024 <= _2026))) {
                      _2095 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _2033 = log2((cb0_009x));
                      float _2034 = _2033 * 0.3010300099849701f;
                      if ((((bool)((_2024 > _2026))) && ((bool)((_2024 < _2034))))) {
                        float _2042 = ((_2023 - _2025) * 0.9030900001525879f) / ((_2033 - _2025) * 0.3010300099849701f);
                        int _2043 = int(2043);
                        float _2045 = _2042 - (float(_2043));
                        float _2047 = _10[_2043];
                        float _2050 = _10[(_2043 + 1)];
                        float _2055 = _2047 * 0.5f;
                        _2095 = (dot(float3((_2045 * _2045), _2045, 1.0f), float3((mad((_10[(_2043 + 2)]), 0.5f, (mad(_2050, -1.0f, _2055)))), (_2050 - _2047), (mad(_2050, 0.5f, _2055)))));
                      } else {
                        do {
                          if (!(!(_2024 >= _2034))) {
                            float _2064 = log2((cb0_008z));
                            if (((_2024 < (_2064 * 0.3010300099849701f)))) {
                              float _2072 = ((_2023 - _2033) * 0.9030900001525879f) / ((_2064 - _2033) * 0.3010300099849701f);
                              int _2073 = int(2073);
                              float _2075 = _2072 - (float(_2073));
                              float _2077 = _11[_2073];
                              float _2080 = _11[(_2073 + 1)];
                              float _2085 = _2077 * 0.5f;
                              _2095 = (dot(float3((_2075 * _2075), _2075, 1.0f), float3((mad((_11[(_2073 + 2)]), 0.5f, (mad(_2080, -1.0f, _2085)))), (_2080 - _2077), (mad(_2080, 0.5f, _2085)))));
                              break;
                            }
                          }
                          _2095 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2099 = log2((max((((_2010 - _2012) * 0.9599999785423279f) + _2012), 1.000000013351432e-10f)));
                    float _2100 = _2099 * 0.3010300099849701f;
                    do {
                      if (!(!(_2100 <= _2026))) {
                        _2169 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _2107 = log2((cb0_009x));
                        float _2108 = _2107 * 0.3010300099849701f;
                        if ((((bool)((_2100 > _2026))) && ((bool)((_2100 < _2108))))) {
                          float _2116 = ((_2099 - _2025) * 0.9030900001525879f) / ((_2107 - _2025) * 0.3010300099849701f);
                          int _2117 = int(2117);
                          float _2119 = _2116 - (float(_2117));
                          float _2121 = _10[_2117];
                          float _2124 = _10[(_2117 + 1)];
                          float _2129 = _2121 * 0.5f;
                          _2169 = (dot(float3((_2119 * _2119), _2119, 1.0f), float3((mad((_10[(_2117 + 2)]), 0.5f, (mad(_2124, -1.0f, _2129)))), (_2124 - _2121), (mad(_2124, 0.5f, _2129)))));
                        } else {
                          do {
                            if (!(!(_2100 >= _2108))) {
                              float _2138 = log2((cb0_008z));
                              if (((_2100 < (_2138 * 0.3010300099849701f)))) {
                                float _2146 = ((_2099 - _2107) * 0.9030900001525879f) / ((_2138 - _2107) * 0.3010300099849701f);
                                int _2147 = int(2147);
                                float _2149 = _2146 - (float(_2147));
                                float _2151 = _11[_2147];
                                float _2154 = _11[(_2147 + 1)];
                                float _2159 = _2151 * 0.5f;
                                _2169 = (dot(float3((_2149 * _2149), _2149, 1.0f), float3((mad((_11[(_2147 + 2)]), 0.5f, (mad(_2154, -1.0f, _2159)))), (_2154 - _2151), (mad(_2154, 0.5f, _2159)))));
                                break;
                              }
                            }
                            _2169 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2173 = log2((max((((_2011 - _2012) * 0.9599999785423279f) + _2012), 1.000000013351432e-10f)));
                      float _2174 = _2173 * 0.3010300099849701f;
                      do {
                        if (!(!(_2174 <= _2026))) {
                          _2243 = ((log2((cb0_008y))) * 0.3010300099849701f);
                        } else {
                          float _2181 = log2((cb0_009x));
                          float _2182 = _2181 * 0.3010300099849701f;
                          if ((((bool)((_2174 > _2026))) && ((bool)((_2174 < _2182))))) {
                            float _2190 = ((_2173 - _2025) * 0.9030900001525879f) / ((_2181 - _2025) * 0.3010300099849701f);
                            int _2191 = int(2191);
                            float _2193 = _2190 - (float(_2191));
                            float _2195 = _10[_2191];
                            float _2198 = _10[(_2191 + 1)];
                            float _2203 = _2195 * 0.5f;
                            _2243 = (dot(float3((_2193 * _2193), _2193, 1.0f), float3((mad((_10[(_2191 + 2)]), 0.5f, (mad(_2198, -1.0f, _2203)))), (_2198 - _2195), (mad(_2198, 0.5f, _2203)))));
                          } else {
                            do {
                              if (!(!(_2174 >= _2182))) {
                                float _2212 = log2((cb0_008z));
                                if (((_2174 < (_2212 * 0.3010300099849701f)))) {
                                  float _2220 = ((_2173 - _2181) * 0.9030900001525879f) / ((_2212 - _2181) * 0.3010300099849701f);
                                  int _2221 = int(2221);
                                  float _2223 = _2220 - (float(_2221));
                                  float _2225 = _11[_2221];
                                  float _2228 = _11[(_2221 + 1)];
                                  float _2233 = _2225 * 0.5f;
                                  _2243 = (dot(float3((_2223 * _2223), _2223, 1.0f), float3((mad((_11[(_2221 + 2)]), 0.5f, (mad(_2228, -1.0f, _2233)))), (_2228 - _2225), (mad(_2228, 0.5f, _2233)))));
                                  break;
                                }
                              }
                              _2243 = ((log2((cb0_008w))) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2247 = (cb0_008w) - (cb0_008y);
                        float _2248 = ((exp2((_2095 * 3.321928024291992f))) - (cb0_008y)) / _2247;
                        float _2250 = ((exp2((_2169 * 3.321928024291992f))) - (cb0_008y)) / _2247;
                        float _2252 = ((exp2((_2243 * 3.321928024291992f))) - (cb0_008y)) / _2247;
                        float _2255 = mad(0.15618768334388733f, _2252, (mad(0.13400420546531677f, _2250, (_2248 * 0.6624541878700256f))));
                        float _2258 = mad(0.053689517080783844f, _2252, (mad(0.6740817427635193f, _2250, (_2248 * 0.2722287178039551f))));
                        float _2261 = mad(1.0103391408920288f, _2252, (mad(0.00406073359772563f, _2250, (_2248 * -0.005574649665504694f))));
                        float _2274 = min((max((mad(-0.23642469942569733f, _2261, (mad(-0.32480329275131226f, _2258, (_2255 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                        float _2275 = min((max((mad(0.016756348311901093f, _2261, (mad(1.6153316497802734f, _2258, (_2255 * -0.663662850856781f))))), 0.0f)), 1.0f);
                        float _2276 = min((max((mad(0.9883948564529419f, _2261, (mad(-0.008284442126750946f, _2258, (_2255 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                        float _2279 = mad(0.15618768334388733f, _2276, (mad(0.13400420546531677f, _2275, (_2274 * 0.6624541878700256f))));
                        float _2282 = mad(0.053689517080783844f, _2276, (mad(0.6740817427635193f, _2275, (_2274 * 0.2722287178039551f))));
                        float _2285 = mad(1.0103391408920288f, _2276, (mad(0.00406073359772563f, _2275, (_2274 * -0.005574649665504694f))));
                        float _2307 = min((max(((min((max((mad(-0.23642469942569733f, _2285, (mad(-0.32480329275131226f, _2282, (_2279 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2308 = min((max(((min((max((mad(0.016756348311901093f, _2285, (mad(1.6153316497802734f, _2282, (_2279 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2309 = min((max(((min((max((mad(0.9883948564529419f, _2285, (mad(-0.008284442126750946f, _2282, (_2279 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        _2322 = _2307;
                        _2323 = _2308;
                        _2324 = _2309;
                        do {
                          if (!((((uint)(cb0_040w)) == 6))) {
                            _2322 = (mad(_47, _2309, (mad(_46, _2308, (_2307 * _45)))));
                            _2323 = (mad(_50, _2309, (mad(_49, _2308, (_2307 * _48)))));
                            _2324 = (mad(_53, _2309, (mad(_52, _2308, (_2307 * _51)))));
                          }
                          float _2334 = exp2(((log2((_2322 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2335 = exp2(((log2((_2323 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2336 = exp2(((log2((_2324 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          _2501 = (exp2(((log2(((1.0f / ((_2334 * 18.6875f) + 1.0f)) * ((_2334 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2502 = (exp2(((log2(((1.0f / ((_2335 * 18.6875f) + 1.0f)) * ((_2335 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2503 = (exp2(((log2(((1.0f / ((_2336 * 18.6875f) + 1.0f)) * ((_2336 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } else {
          if (((((uint)(cb0_040w)) == 7))) {
            float _2381 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1067, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1066, ((UniformBufferConstants_WorkingColorSpace_008x)*_1065))));
            float _2384 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1067, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1066, ((UniformBufferConstants_WorkingColorSpace_009x)*_1065))));
            float _2387 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1067, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1066, ((UniformBufferConstants_WorkingColorSpace_010x)*_1065))));
            float _2406 = exp2(((log2(((mad(_47, _2387, (mad(_46, _2384, (_2381 * _45))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2407 = exp2(((log2(((mad(_50, _2387, (mad(_49, _2384, (_2381 * _48))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2408 = exp2(((log2(((mad(_53, _2387, (mad(_52, _2384, (_2381 * _51))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            _2501 = (exp2(((log2(((1.0f / ((_2406 * 18.6875f) + 1.0f)) * ((_2406 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2502 = (exp2(((log2(((1.0f / ((_2407 * 18.6875f) + 1.0f)) * ((_2407 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2503 = (exp2(((log2(((1.0f / ((_2408 * 18.6875f) + 1.0f)) * ((_2408 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
          } else {
            _2501 = _1065;
            _2502 = _1066;
            _2503 = _1067;
            if (!((((uint)(cb0_040w)) == 8))) {
              if (((((uint)(cb0_040w)) == 9))) {
                float _2455 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1055, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1054, ((UniformBufferConstants_WorkingColorSpace_008x)*_1053))));
                float _2458 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1055, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1054, ((UniformBufferConstants_WorkingColorSpace_009x)*_1053))));
                float _2461 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1055, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1054, ((UniformBufferConstants_WorkingColorSpace_010x)*_1053))));
                _2501 = (mad(_47, _2461, (mad(_46, _2458, (_2455 * _45)))));
                _2502 = (mad(_50, _2461, (mad(_49, _2458, (_2455 * _48)))));
                _2503 = (mad(_53, _2461, (mad(_52, _2458, (_2455 * _51)))));
              } else {
                float _2474 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1080, ((UniformBufferConstants_WorkingColorSpace_008x)*_1079))));
                float _2477 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1080, ((UniformBufferConstants_WorkingColorSpace_009x)*_1079))));
                float _2480 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1081, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1080, ((UniformBufferConstants_WorkingColorSpace_010x)*_1079))));
                _2501 = (exp2(((log2((mad(_47, _2480, (mad(_46, _2477, (_2474 * _45))))))) * (cb0_040z))));
                _2502 = (exp2(((log2((mad(_50, _2480, (mad(_49, _2477, (_2474 * _48))))))) * (cb0_040z))));
                _2503 = (exp2(((log2((mad(_53, _2480, (mad(_52, _2477, (_2474 * _51))))))) * (cb0_040z))));
              }
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2501 * 0.9523810148239136f);
  SV_Target.y = (_2502 * 0.9523810148239136f);
  SV_Target.z = (_2503 * 0.9523810148239136f);
  SV_Target.w = 0.0f;

  SV_Target = saturate(SV_Target);

  return SV_Target;
}
