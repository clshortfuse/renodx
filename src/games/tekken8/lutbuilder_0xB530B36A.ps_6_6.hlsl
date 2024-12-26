#include "./common.hlsl"
#include "./shared.h"

cbuffer cb0 : register(b0) {
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

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position,
    nointerpolation uint SV_RenderTargetArrayIndex: SV_RenderTargetArrayIndex)
    : SV_Target {
  float4 SV_Target;

  float _8[6];
  float _9[6];
  float _10[6];
  float _11[6];
  float _14 = 0.5f / (cb0_037x);
  float _19 = (cb0_037x) + -1.0f;
  float _20 = ((cb0_037x) * ((TEXCOORD.x) - _14)) / _19;
  float _21 = ((cb0_037x) * ((TEXCOORD.y) - _14)) / _19;
  float _23 = (float((uint)(SV_RenderTargetArrayIndex))) / _19;
  float _43 = 1.379158854484558f;
  float _44 = -0.3088507056236267f;
  float _45 = -0.07034677267074585f;
  float _46 = -0.06933528929948807f;
  float _47 = 1.0822921991348267f;
  float _48 = -0.012962047010660172f;
  float _49 = -0.002159259282052517f;
  float _50 = -0.045465391129255295f;
  float _51 = 1.0477596521377563f;
  float _109;
  float _110;
  float _111;
  float _634;
  float _667;
  float _681;
  float _745;
  float _1038;
  float _1039;
  float _1040;
  float _1051;
  float _1062;
  float _1242;
  float _1275;
  float _1289;
  float _1328;
  float _1438;
  float _1512;
  float _1586;
  float _1665;
  float _1666;
  float _1667;
  float _1816;
  float _1849;
  float _1863;
  float _1902;
  float _2012;
  float _2086;
  float _2160;
  float _2239;
  float _2240;
  float _2241;
  float _2418;
  float _2419;
  float _2420;
  if (!((((uint)(cb0_043x)) == 1))) {
    _43 = 1.02579927444458f;
    _44 = -0.020052503794431686f;
    _45 = -0.0057713985443115234f;
    _46 = -0.0022350111976265907f;
    _47 = 1.0045825242996216f;
    _48 = -0.002352306619286537f;
    _49 = -0.005014004185795784f;
    _50 = -0.025293385609984398f;
    _51 = 1.0304402112960815f;
    if (!((((uint)(cb0_043x)) == 2))) {
      _43 = 0.6954522132873535f;
      _44 = 0.14067870378494263f;
      _45 = 0.16386906802654266f;
      _46 = 0.044794563204050064f;
      _47 = 0.8596711158752441f;
      _48 = 0.0955343171954155f;
      _49 = -0.005525882821530104f;
      _50 = 0.004025210160762072f;
      _51 = 1.0015007257461548f;
      if (!((((uint)(cb0_043x)) == 3))) {
        bool _32 = (((uint)(cb0_043x)) == 4);
        _43 = ((_32 ? 1.0f : 1.7050515413284302f));
        _44 = ((_32 ? 0.0f : -0.6217905879020691f));
        _45 = ((_32 ? 0.0f : -0.0832584798336029f));
        _46 = ((_32 ? 0.0f : -0.13025718927383423f));
        _47 = ((_32 ? 1.0f : 1.1408027410507202f));
        _48 = ((_32 ? 0.0f : -0.010548528283834457f));
        _49 = ((_32 ? 0.0f : -0.024003278464078903f));
        _50 = ((_32 ? 0.0f : -0.1289687603712082f));
        _51 = ((_32 ? 1.0f : 1.152971863746643f));
      }
    }
  }
  if (((((uint)(cb0_042w)) > 2))) {
    float _62 = exp2(((log2(_20)) * 0.012683313339948654f));
    float _63 = exp2(((log2(_21)) * 0.012683313339948654f));
    float _64 = exp2(((log2(_23)) * 0.012683313339948654f));
    _109 = ((exp2(((log2(((max(0.0f, (_62 + -0.8359375f))) / (18.8515625f - (_62 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
    _110 = ((exp2(((log2(((max(0.0f, (_63 + -0.8359375f))) / (18.8515625f - (_63 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
    _111 = ((exp2(((log2(((max(0.0f, (_64 + -0.8359375f))) / (18.8515625f - (_64 * 18.6875f))))) * 6.277394771575928f))) * 100.0f);
  } else {
    _109 = (((exp2(((_20 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
    _110 = (((exp2(((_21 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
    _111 = (((exp2(((_23 + -0.4340175986289978f) * 14.0f))) * 0.18000000715255737f) + -0.002667719265446067f);
  }
  float _126 = mad((UniformBufferConstants_WorkingColorSpace_008z), _111, (mad((UniformBufferConstants_WorkingColorSpace_008y), _110, ((UniformBufferConstants_WorkingColorSpace_008x)*_109))));
  float _129 = mad((UniformBufferConstants_WorkingColorSpace_009z), _111, (mad((UniformBufferConstants_WorkingColorSpace_009y), _110, ((UniformBufferConstants_WorkingColorSpace_009x)*_109))));
  float _132 = mad((UniformBufferConstants_WorkingColorSpace_010z), _111, (mad((UniformBufferConstants_WorkingColorSpace_010y), _110, ((UniformBufferConstants_WorkingColorSpace_010x)*_109))));
  float _133 = dot(float3(_126, _129, _132), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _137 = (_126 / _133) + -1.0f;
  float _138 = (_129 / _133) + -1.0f;
  float _139 = (_132 / _133) + -1.0f;
  float _151 = (1.0f - (exp2((((_133 * _133) * -4.0f) * (cb0_038w))))) * (1.0f - (exp2(((dot(float3(_137, _138, _139), float3(_137, _138, _139))) * -4.0f))));
  float _167 = (((mad(-0.06368283927440643f, _132, (mad(-0.32929131388664246f, _129, (_126 * 1.370412826538086f))))) - _126) * _151) + _126;
  float _168 = (((mad(-0.010861567221581936f, _132, (mad(1.0970908403396606f, _129, (_126 * -0.08343426138162613f))))) - _129) * _151) + _129;
  float _169 = (((mad(1.203694462776184f, _132, (mad(-0.09862564504146576f, _129, (_126 * -0.02579325996339321f))))) - _132) * _151) + _132;
  float _170 = dot(float3(_167, _168, _169), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
  float _184 = (cb0_019w) + (cb0_024w);
  float _198 = (cb0_018w) * (cb0_023w);
  float _212 = (cb0_017w) * (cb0_022w);
  float _226 = (cb0_016w) * (cb0_021w);
  float _240 = (cb0_015w) * (cb0_020w);
  float _244 = _167 - _170;
  float _245 = _168 - _170;
  float _246 = _169 - _170;
  float _303 = saturate((_170 / (cb0_037w)));
  float _307 = (_303 * _303) * (3.0f - (_303 * 2.0f));
  float _308 = 1.0f - _307;
  float _317 = (cb0_019w) + (cb0_034w);
  float _326 = (cb0_018w) * (cb0_033w);
  float _335 = (cb0_017w) * (cb0_032w);
  float _344 = (cb0_016w) * (cb0_031w);
  float _353 = (cb0_015w) * (cb0_030w);
  float _416 = saturate(((_170 - (cb0_038x)) / ((cb0_038y) - (cb0_038x))));
  float _420 = (_416 * _416) * (3.0f - (_416 * 2.0f));
  float _429 = (cb0_019w) + (cb0_029w);
  float _438 = (cb0_018w) * (cb0_028w);
  float _447 = (cb0_017w) * (cb0_027w);
  float _456 = (cb0_016w) * (cb0_026w);
  float _465 = (cb0_015w) * (cb0_025w);
  float _523 = _307 - _420;
  float _534 = ((_420 * ((((cb0_019x) + (cb0_034x)) + _317) + ((((cb0_018x) * (cb0_033x)) * _326) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_031x)) * _344) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_030x)) * _353) * _244) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_032x)) * _335)))))))) + (_308 * ((((cb0_019x) + (cb0_024x)) + _184) + ((((cb0_018x) * (cb0_023x)) * _198) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_021x)) * _226) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_020x)) * _240) * _244) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_022x)) * _212))))))))) + (((((cb0_019x) + (cb0_029x)) + _429) + ((((cb0_018x) * (cb0_028x)) * _438) * (exp2(((log2(((exp2(((((cb0_016x) * (cb0_026x)) * _456) * (log2(((max(0.0f, (((((cb0_015x) * (cb0_025x)) * _465) * _244) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017x) * (cb0_027x)) * _447))))))) * _523);
  float _536 = ((_420 * ((((cb0_019y) + (cb0_034y)) + _317) + ((((cb0_018y) * (cb0_033y)) * _326) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_031y)) * _344) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_030y)) * _353) * _245) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_032y)) * _335)))))))) + (_308 * ((((cb0_019y) + (cb0_024y)) + _184) + ((((cb0_018y) * (cb0_023y)) * _198) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_021y)) * _226) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_020y)) * _240) * _245) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_022y)) * _212))))))))) + (((((cb0_019y) + (cb0_029y)) + _429) + ((((cb0_018y) * (cb0_028y)) * _438) * (exp2(((log2(((exp2(((((cb0_016y) * (cb0_026y)) * _456) * (log2(((max(0.0f, (((((cb0_015y) * (cb0_025y)) * _465) * _245) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017y) * (cb0_027y)) * _447))))))) * _523);
  float _538 = ((_420 * ((((cb0_019z) + (cb0_034z)) + _317) + ((((cb0_018z) * (cb0_033z)) * _326) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_031z)) * _344) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_030z)) * _353) * _246) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_032z)) * _335)))))))) + (_308 * ((((cb0_019z) + (cb0_024z)) + _184) + ((((cb0_018z) * (cb0_023z)) * _198) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_021z)) * _226) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_020z)) * _240) * _246) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_022z)) * _212))))))))) + (((((cb0_019z) + (cb0_029z)) + _429) + ((((cb0_018z) * (cb0_028z)) * _438) * (exp2(((log2(((exp2(((((cb0_016z) * (cb0_026z)) * _456) * (log2(((max(0.0f, (((((cb0_015z) * (cb0_025z)) * _465) * _246) + _170))) * 5.55555534362793f)))))) * 0.18000000715255737f))) * (1.0f / (((cb0_017z) * (cb0_027z)) * _447))))))) * _523);

  float3 untonemapped_ap1 = float3(_534, _536, _538);  // CustomEdit

  float _574 = (((mad(0.061360642313957214f, _538, (mad(-4.540197551250458e-09f, _536, (_534 * 0.9386394023895264f))))) - _534) * (cb0_038z)) + _534;
  float _575 = (((mad(0.169205904006958f, _538, (mad(0.8307942152023315f, _536, (_534 * 6.775371730327606e-08f))))) - _536) * (cb0_038z)) + _536;
  float _576 = ((mad(-2.3283064365386963e-10f, _536, (_534 * -9.313225746154785e-10f))) * (cb0_038z)) + _538;
  float _579 = mad(0.16386905312538147f, _576, (mad(0.14067868888378143f, _575, (_574 * 0.6954522132873535f))));
  float _582 = mad(0.0955343246459961f, _576, (mad(0.8596711158752441f, _575, (_574 * 0.044794581830501556f))));
  float _585 = mad(1.0015007257461548f, _576, (mad(0.004025210160762072f, _575, (_574 * -0.005525882821530104f))));
  float _589 = max((max(_579, _582)), _585);
  float _594 = ((max(_589, 1.000000013351432e-10f)) - (max((min((min(_579, _582)), _585)), 1.000000013351432e-10f))) / (max(_589, 0.009999999776482582f));
  float _607 = ((_582 + _579) + _585) + ((sqrt(((((_585 - _582) * _585) + ((_582 - _579) * _582)) + ((_579 - _585) * _579)))) * 1.75f);
  float _608 = _607 * 0.3333333432674408f;
  float _609 = _594 + -0.4000000059604645f;
  float _610 = _609 * 5.0f;
  float _614 = max((1.0f - (abs((_609 * 2.5f)))), 0.0f);
  float _625 = (((float(((int(((bool)((_610 > 0.0f))))) - (int(((bool)((_610 < 0.0f)))))))) * (1.0f - (_614 * _614))) + 1.0f) * 0.02500000037252903f;
  _634 = _625;
  if ((!(_608 <= 0.0533333346247673f))) {
    _634 = 0.0f;
    if ((!(_608 >= 0.1599999964237213f))) {
      _634 = (((0.23999999463558197f / _607) + -0.5f) * _625);
    }
  }
  float _635 = _634 + 1.0f;
  float _636 = _635 * _579;
  float _637 = _635 * _582;
  float _638 = _635 * _585;
  _667 = 0.0f;
  if (!(((bool)((_636 == _637))) && ((bool)((_637 == _638))))) {
    float _645 = ((_636 * 2.0f) - _637) - _638;
    float _648 = ((_582 - _585) * 1.7320507764816284f) * _635;
    float _650 = atan((_648 / _645));
    bool _653 = (_645 < 0.0f);
    bool _654 = (_645 == 0.0f);
    bool _655 = (_648 >= 0.0f);
    bool _656 = (_648 < 0.0f);
    _667 = ((((bool)(_655 && _654)) ? 90.0f : ((((bool)(_656 && _654)) ? -90.0f : (((((bool)(_656 && _653)) ? (_650 + -3.1415927410125732f) : ((((bool)(_655 && _653)) ? (_650 + 3.1415927410125732f) : _650)))) * 57.2957763671875f)))));
  }
  float _672 = min((max(((((bool)((_667 < 0.0f))) ? (_667 + 360.0f) : _667)), 0.0f)), 360.0f);
  if (((_672 < -180.0f))) {
    _681 = (_672 + 360.0f);
  } else {
    _681 = _672;
    if (((_672 > 180.0f))) {
      _681 = (_672 + -360.0f);
    }
  }
  float _685 = saturate((1.0f - (abs((_681 * 0.014814814552664757f)))));
  float _689 = (_685 * _685) * (3.0f - (_685 * 2.0f));
  float _695 = ((_689 * _689) * ((_594 * 0.18000000715255737f) * (0.029999999329447746f - _636))) + _636;
  float _705 = max(0.0f, (mad(-0.21492856740951538f, _638, (mad(-0.2365107536315918f, _637, (_695 * 1.4514392614364624f))))));
  float _706 = max(0.0f, (mad(-0.09967592358589172f, _638, (mad(1.17622971534729f, _637, (_695 * -0.07655377686023712f))))));
  float _707 = max(0.0f, (mad(0.9977163076400757f, _638, (mad(-0.006032449658960104f, _637, (_695 * 0.008316148072481155f))))));
  float _708 = dot(float3(_705, _706, _707), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float _723 = ((cb0_040x) + 1.0f) - (cb0_039z);
  float _725 = (cb0_040y) + 1.0f;
  float _727 = _725 - (cb0_039w);

  if ((((cb0_039z) > 0.800000011920929f))) {
    _745 = (((0.8199999928474426f - (cb0_039z)) / (cb0_039y)) + -0.7447274923324585f);
  } else {
    float _736 = ((cb0_040x) + 0.18000000715255737f) / _723;
    _745 = (-0.7447274923324585f - (((log2((_736 / (2.0f - _736)))) * 0.3465735912322998f) * (_723 / (cb0_039y))));
  }
  float _748 = ((1.0f - (cb0_039z)) / (cb0_039y)) - _745;
  float _750 = ((cb0_039w) / (cb0_039y)) - _748;
  float _754 = (log2((((_705 - _708) * 0.9599999785423279f) + _708))) * 0.3010300099849701f;
  float _755 = (log2((((_706 - _708) * 0.9599999785423279f) + _708))) * 0.3010300099849701f;
  float _756 = (log2((((_707 - _708) * 0.9599999785423279f) + _708))) * 0.3010300099849701f;
  float _760 = (cb0_039y) * (_754 + _748);
  float _761 = (cb0_039y) * (_755 + _748);
  float _762 = (cb0_039y) * (_756 + _748);
  float _763 = _723 * 2.0f;
  float _765 = ((cb0_039y) * -2.0f) / _723;
  float _766 = _754 - _745;
  float _767 = _755 - _745;
  float _768 = _756 - _745;
  float _787 = _727 * 2.0f;
  float _789 = ((cb0_039y) * 2.0f) / _727;
  float _814 = (((bool)((_754 < _745))) ? ((_763 / ((exp2(((_766 * 1.4426950216293335f) * _765))) + 1.0f)) - (cb0_040x)) : _760);
  float _815 = (((bool)((_755 < _745))) ? ((_763 / ((exp2(((_767 * 1.4426950216293335f) * _765))) + 1.0f)) - (cb0_040x)) : _761);
  float _816 = (((bool)((_756 < _745))) ? ((_763 / ((exp2(((_768 * 1.4426950216293335f) * _765))) + 1.0f)) - (cb0_040x)) : _762);
  float _823 = _750 - _745;
  float _827 = saturate((_766 / _823));
  float _828 = saturate((_767 / _823));
  float _829 = saturate((_768 / _823));
  bool _830 = (_750 < _745);
  float _834 = (_830 ? (1.0f - _827) : _827);
  float _835 = (_830 ? (1.0f - _828) : _828);
  float _836 = (_830 ? (1.0f - _829) : _829);
  float _855 = (((_834 * _834) * (((((bool)((_754 > _750))) ? (_725 - (_787 / ((exp2((((_754 - _750) * 1.4426950216293335f) * _789))) + 1.0f))) : _760)) - _814)) * (3.0f - (_834 * 2.0f))) + _814;
  float _856 = (((_835 * _835) * (((((bool)((_755 > _750))) ? (_725 - (_787 / ((exp2((((_755 - _750) * 1.4426950216293335f) * _789))) + 1.0f))) : _761)) - _815)) * (3.0f - (_835 * 2.0f))) + _815;
  float _857 = (((_836 * _836) * (((((bool)((_756 > _750))) ? (_725 - (_787 / ((exp2((((_756 - _750) * 1.4426950216293335f) * _789))) + 1.0f))) : _762)) - _816)) * (3.0f - (_836 * 2.0f))) + _816;
  float _858 = dot(float3(_855, _856, _857), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));

  float _878 = ((cb0_039x) * ((max(0.0f, (((_855 - _858) * 0.9300000071525574f) + _858))) - _574)) + _574;
  float _879 = ((cb0_039x) * ((max(0.0f, (((_856 - _858) * 0.9300000071525574f) + _858))) - _575)) + _575;
  float _880 = ((cb0_039x) * ((max(0.0f, (((_857 - _858) * 0.9300000071525574f) + _858))) - _576)) + _576;

  float _896 = (((mad(-0.06537103652954102f, _880, (mad(1.451815478503704e-06f, _879, (_878 * 1.065374732017517f))))) - _878) * (cb0_038z)) + _878;
  float _897 = (((mad(-0.20366770029067993f, _880, (mad(1.2036634683609009f, _879, (_878 * -2.57161445915699e-07f))))) - _879) * (cb0_038z)) + _879;
  float _898 = (((mad(0.9999996423721313f, _880, (mad(2.0954757928848267e-08f, _879, (_878 * 1.862645149230957e-08f))))) - _880) * (cb0_038z)) + _880;
  float _908 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_012z), _898, (mad((UniformBufferConstants_WorkingColorSpace_012y), _897, ((UniformBufferConstants_WorkingColorSpace_012x)*_896))))));
  float _909 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_013z), _898, (mad((UniformBufferConstants_WorkingColorSpace_013y), _897, ((UniformBufferConstants_WorkingColorSpace_013x)*_896))))));
  float _910 = max(0.0f, (mad((UniformBufferConstants_WorkingColorSpace_014z), _898, (mad((UniformBufferConstants_WorkingColorSpace_014y), _897, ((UniformBufferConstants_WorkingColorSpace_014x)*_896))))));
  float _936 = (cb0_014x) * ((((cb0_041y) + ((cb0_041x)*_908)) * _908) + (cb0_041z));
  float _937 = (cb0_014y) * ((((cb0_041y) + ((cb0_041x)*_909)) * _909) + (cb0_041z));
  float _938 = (cb0_014z) * ((((cb0_041y) + ((cb0_041x)*_910)) * _910) + (cb0_041z));
  float _945 = (((cb0_013x)-_936) * (cb0_013w)) + _936;
  float _946 = (((cb0_013y)-_937) * (cb0_013w)) + _937;
  float _947 = (((cb0_013z)-_938) * (cb0_013w)) + _938;
  float _948 = (cb0_014x) * (mad((UniformBufferConstants_WorkingColorSpace_012z), _538, (mad((UniformBufferConstants_WorkingColorSpace_012y), _536, (_534 * (UniformBufferConstants_WorkingColorSpace_012x))))));
  float _949 = (cb0_014y) * (mad((UniformBufferConstants_WorkingColorSpace_013z), _538, (mad((UniformBufferConstants_WorkingColorSpace_013y), _536, ((UniformBufferConstants_WorkingColorSpace_013x)*_534)))));
  float _950 = (cb0_014z) * (mad((UniformBufferConstants_WorkingColorSpace_014z), _538, (mad((UniformBufferConstants_WorkingColorSpace_014y), _536, ((UniformBufferConstants_WorkingColorSpace_014x)*_534)))));
  float _957 = (((cb0_013x)-_948) * (cb0_013w)) + _948;
  float _958 = (((cb0_013y)-_949) * (cb0_013w)) + _949;
  float _959 = (((cb0_013z)-_950) * (cb0_013w)) + _950;
  float _971 = exp2(((log2((max(0.0f, _945)))) * (cb0_042y)));
  float _972 = exp2(((log2((max(0.0f, _946)))) * (cb0_042y)));
  float _973 = exp2(((log2((max(0.0f, _947)))) * (cb0_042y)));

  // CustomEdit
  if (injectedData.toneMapType != 0) {
    return LutBuilderToneMap(untonemapped_ap1, float3(_971, _972, _973));
  }

  if (((((uint)(cb0_042w)) == 0))) {
    float _979 = max((dot(float3(_971, _972, _973), float3(0.2126390039920807f, 0.7151690125465393f, 0.0721919983625412f))), 9.999999747378752e-05f);
    float _999 = ((((((bool)((_979 < (cb0_036z)))) ? 0.0f : 1.0f)) * (((cb0_035y)-_979) + ((-0.0f - (cb0_036x)) / ((cb0_035x) + _979)))) + _979) * (cb0_036y);
    float _1000 = _999 * (_971 / _979);
    float _1001 = _999 * (_972 / _979);
    float _1002 = _999 * (_973 / _979);
    _1038 = _1000;
    _1039 = _1001;
    _1040 = _1002;
    do {
      if (((((uint)(UniformBufferConstants_WorkingColorSpace_020x)) == 0))) {
        float _1021 = mad((UniformBufferConstants_WorkingColorSpace_008z), _1002, (mad((UniformBufferConstants_WorkingColorSpace_008y), _1001, ((UniformBufferConstants_WorkingColorSpace_008x)*_1000))));
        float _1024 = mad((UniformBufferConstants_WorkingColorSpace_009z), _1002, (mad((UniformBufferConstants_WorkingColorSpace_009y), _1001, ((UniformBufferConstants_WorkingColorSpace_009x)*_1000))));
        float _1027 = mad((UniformBufferConstants_WorkingColorSpace_010z), _1002, (mad((UniformBufferConstants_WorkingColorSpace_010y), _1001, ((UniformBufferConstants_WorkingColorSpace_010x)*_1000))));
        _1038 = (mad(_45, _1027, (mad(_44, _1024, (_1021 * _43)))));
        _1039 = (mad(_48, _1027, (mad(_47, _1024, (_1021 * _46)))));
        _1040 = (mad(_51, _1027, (mad(_50, _1024, (_1021 * _49)))));
      }
      do {
        if (((_1038 < 0.0031306699384003878f))) {
          _1051 = (_1038 * 12.920000076293945f);
        } else {
          _1051 = (((exp2(((log2(_1038)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
        }
        do {
          if (((_1039 < 0.0031306699384003878f))) {
            _1062 = (_1039 * 12.920000076293945f);
          } else {
            _1062 = (((exp2(((log2(_1039)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
          if (((_1040 < 0.0031306699384003878f))) {
            _2418 = _1051;
            _2419 = _1062;
            _2420 = (_1040 * 12.920000076293945f);
          } else {
            _2418 = _1051;
            _2419 = _1062;
            _2420 = (((exp2(((log2(_1040)) * 0.4166666567325592f))) * 1.0549999475479126f) + -0.054999999701976776f);
          }
        } while (false);
      } while (false);
    } while (false);
  } else {
    if (((((uint)(cb0_042w)) == 1))) {
      float _1089 = mad((UniformBufferConstants_WorkingColorSpace_008z), _973, (mad((UniformBufferConstants_WorkingColorSpace_008y), _972, ((UniformBufferConstants_WorkingColorSpace_008x)*_971))));
      float _1092 = mad((UniformBufferConstants_WorkingColorSpace_009z), _973, (mad((UniformBufferConstants_WorkingColorSpace_009y), _972, ((UniformBufferConstants_WorkingColorSpace_009x)*_971))));
      float _1095 = mad((UniformBufferConstants_WorkingColorSpace_010z), _973, (mad((UniformBufferConstants_WorkingColorSpace_010y), _972, ((UniformBufferConstants_WorkingColorSpace_010x)*_971))));
      float _1105 = max(6.103519990574569e-05f, (mad(_45, _1095, (mad(_44, _1092, (_1089 * _43))))));
      float _1106 = max(6.103519990574569e-05f, (mad(_48, _1095, (mad(_47, _1092, (_1089 * _46))))));
      float _1107 = max(6.103519990574569e-05f, (mad(_51, _1095, (mad(_50, _1092, (_1089 * _49))))));
      _2418 = (min((_1105 * 4.5f), (((exp2(((log2((max(_1105, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2419 = (min((_1106 * 4.5f), (((exp2(((log2((max(_1106, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
      _2420 = (min((_1107 * 4.5f), (((exp2(((log2((max(_1107, 0.017999999225139618f)))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f)));
    } else {
      if ((((bool)((((uint)(cb0_042w)) == 3))) || ((bool)((((uint)(cb0_042w)) == 5))))) {
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
        float _1182 = (cb0_012z)*_957;
        float _1183 = (cb0_012z)*_958;
        float _1184 = (cb0_012z)*_959;
        float _1187 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1184, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1183, ((UniformBufferConstants_WorkingColorSpace_016x)*_1182))));
        float _1190 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1184, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1183, ((UniformBufferConstants_WorkingColorSpace_017x)*_1182))));
        float _1193 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1184, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1183, ((UniformBufferConstants_WorkingColorSpace_018x)*_1182))));
        float _1197 = max((max(_1187, _1190)), _1193);
        float _1202 = ((max(_1197, 1.000000013351432e-10f)) - (max((min((min(_1187, _1190)), _1193)), 1.000000013351432e-10f))) / (max(_1197, 0.009999999776482582f));
        float _1215 = ((_1190 + _1187) + _1193) + ((sqrt(((((_1193 - _1190) * _1193) + ((_1190 - _1187) * _1190)) + ((_1187 - _1193) * _1187)))) * 1.75f);
        float _1216 = _1215 * 0.3333333432674408f;
        float _1217 = _1202 + -0.4000000059604645f;
        float _1218 = _1217 * 5.0f;
        float _1222 = max((1.0f - (abs((_1217 * 2.5f)))), 0.0f);
        float _1233 = (((float(((int(((bool)((_1218 > 0.0f))))) - (int(((bool)((_1218 < 0.0f)))))))) * (1.0f - (_1222 * _1222))) + 1.0f) * 0.02500000037252903f;
        _1242 = _1233;
        do {
          if ((!(_1216 <= 0.0533333346247673f))) {
            _1242 = 0.0f;
            if ((!(_1216 >= 0.1599999964237213f))) {
              _1242 = (((0.23999999463558197f / _1215) + -0.5f) * _1233);
            }
          }
          float _1243 = _1242 + 1.0f;
          float _1244 = _1243 * _1187;
          float _1245 = _1243 * _1190;
          float _1246 = _1243 * _1193;
          _1275 = 0.0f;
          do {
            if (!(((bool)((_1244 == _1245))) && ((bool)((_1245 == _1246))))) {
              float _1253 = ((_1244 * 2.0f) - _1245) - _1246;
              float _1256 = ((_1190 - _1193) * 1.7320507764816284f) * _1243;
              float _1258 = atan((_1256 / _1253));
              bool _1261 = (_1253 < 0.0f);
              bool _1262 = (_1253 == 0.0f);
              bool _1263 = (_1256 >= 0.0f);
              bool _1264 = (_1256 < 0.0f);
              _1275 = ((((bool)(_1263 && _1262)) ? 90.0f : ((((bool)(_1264 && _1262)) ? -90.0f : (((((bool)(_1264 && _1261)) ? (_1258 + -3.1415927410125732f) : ((((bool)(_1263 && _1261)) ? (_1258 + 3.1415927410125732f) : _1258)))) * 57.2957763671875f)))));
            }
            float _1280 = min((max(((((bool)((_1275 < 0.0f))) ? (_1275 + 360.0f) : _1275)), 0.0f)), 360.0f);
            do {
              if (((_1280 < -180.0f))) {
                _1289 = (_1280 + 360.0f);
              } else {
                _1289 = _1280;
                if (((_1280 > 180.0f))) {
                  _1289 = (_1280 + -360.0f);
                }
              }
              _1328 = 0.0f;
              do {
                if ((((bool)((_1289 > -67.5f))) && ((bool)((_1289 < 67.5f))))) {
                  float _1295 = (_1289 + 67.5f) * 0.029629629105329514f;
                  int _1296 = int(1296);
                  float _1298 = _1295 - (float(_1296));
                  float _1299 = _1298 * _1298;
                  float _1300 = _1299 * _1298;
                  if (_1296 == 3) {
                    _1328 = (((0.1666666716337204f - (_1298 * 0.5f)) + (_1299 * 0.5f)) - (_1300 * 0.1666666716337204f));
                  } else {
                    if (_1296 == 2) {
                      _1328 = ((0.6666666865348816f - _1299) + (_1300 * 0.5f));
                    } else {
                      if (_1296 == 1) {
                        _1328 = (((_1300 * -0.5f) + 0.1666666716337204f) + ((_1299 + _1298) * 0.5f));
                      } else {
                        _1328 = ((((bool)((_1296 == 0))) ? (_1300 * 0.1666666716337204f) : 0.0f));
                      }
                    }
                  }
                }
                float _1337 = min((max(((((_1202 * 0.27000001072883606f) * (0.029999999329447746f - _1244)) * _1328) + _1244), 0.0f)), 65535.0f);
                float _1338 = min((max(_1245, 0.0f)), 65535.0f);
                float _1339 = min((max(_1246, 0.0f)), 65535.0f);
                float _1352 = min((max((mad(-0.21492856740951538f, _1339, (mad(-0.2365107536315918f, _1338, (_1337 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                float _1353 = min((max((mad(-0.09967592358589172f, _1339, (mad(1.17622971534729f, _1338, (_1337 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                float _1354 = min((max((mad(0.9977163076400757f, _1339, (mad(-0.006032449658960104f, _1338, (_1337 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                float _1355 = dot(float3(_1352, _1353, _1354), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                float _1366 = log2((max((((_1352 - _1355) * 0.9599999785423279f) + _1355), 1.000000013351432e-10f)));
                float _1367 = _1366 * 0.3010300099849701f;
                float _1368 = log2((cb0_008x));
                float _1369 = _1368 * 0.3010300099849701f;
                do {
                  if (!(!(_1367 <= _1369))) {
                    _1438 = ((log2((cb0_008y))) * 0.3010300099849701f);
                  } else {
                    float _1376 = log2((cb0_009x));
                    float _1377 = _1376 * 0.3010300099849701f;
                    if ((((bool)((_1367 > _1369))) && ((bool)((_1367 < _1377))))) {
                      float _1385 = ((_1366 - _1368) * 0.9030900001525879f) / ((_1376 - _1368) * 0.3010300099849701f);
                      int _1386 = int(1386);
                      float _1388 = _1385 - (float(_1386));
                      float _1390 = _10[_1386];
                      float _1393 = _10[(_1386 + 1)];
                      float _1398 = _1390 * 0.5f;
                      _1438 = (dot(float3((_1388 * _1388), _1388, 1.0f), float3((mad((_10[(_1386 + 2)]), 0.5f, (mad(_1393, -1.0f, _1398)))), (_1393 - _1390), (mad(_1393, 0.5f, _1398)))));
                    } else {
                      do {
                        if (!(!(_1367 >= _1377))) {
                          float _1407 = log2((cb0_008z));
                          if (((_1367 < (_1407 * 0.3010300099849701f)))) {
                            float _1415 = ((_1366 - _1376) * 0.9030900001525879f) / ((_1407 - _1376) * 0.3010300099849701f);
                            int _1416 = int(1416);
                            float _1418 = _1415 - (float(_1416));
                            float _1420 = _11[_1416];
                            float _1423 = _11[(_1416 + 1)];
                            float _1428 = _1420 * 0.5f;
                            _1438 = (dot(float3((_1418 * _1418), _1418, 1.0f), float3((mad((_11[(_1416 + 2)]), 0.5f, (mad(_1423, -1.0f, _1428)))), (_1423 - _1420), (mad(_1423, 0.5f, _1428)))));
                            break;
                          }
                        }
                        _1438 = ((log2((cb0_008w))) * 0.3010300099849701f);
                      } while (false);
                    }
                  }
                  float _1442 = log2((max((((_1353 - _1355) * 0.9599999785423279f) + _1355), 1.000000013351432e-10f)));
                  float _1443 = _1442 * 0.3010300099849701f;
                  do {
                    if (!(!(_1443 <= _1369))) {
                      _1512 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _1450 = log2((cb0_009x));
                      float _1451 = _1450 * 0.3010300099849701f;
                      if ((((bool)((_1443 > _1369))) && ((bool)((_1443 < _1451))))) {
                        float _1459 = ((_1442 - _1368) * 0.9030900001525879f) / ((_1450 - _1368) * 0.3010300099849701f);
                        int _1460 = int(1460);
                        float _1462 = _1459 - (float(_1460));
                        float _1464 = _10[_1460];
                        float _1467 = _10[(_1460 + 1)];
                        float _1472 = _1464 * 0.5f;
                        _1512 = (dot(float3((_1462 * _1462), _1462, 1.0f), float3((mad((_10[(_1460 + 2)]), 0.5f, (mad(_1467, -1.0f, _1472)))), (_1467 - _1464), (mad(_1467, 0.5f, _1472)))));
                      } else {
                        do {
                          if (!(!(_1443 >= _1451))) {
                            float _1481 = log2((cb0_008z));
                            if (((_1443 < (_1481 * 0.3010300099849701f)))) {
                              float _1489 = ((_1442 - _1450) * 0.9030900001525879f) / ((_1481 - _1450) * 0.3010300099849701f);
                              int _1490 = int(1490);
                              float _1492 = _1489 - (float(_1490));
                              float _1494 = _11[_1490];
                              float _1497 = _11[(_1490 + 1)];
                              float _1502 = _1494 * 0.5f;
                              _1512 = (dot(float3((_1492 * _1492), _1492, 1.0f), float3((mad((_11[(_1490 + 2)]), 0.5f, (mad(_1497, -1.0f, _1502)))), (_1497 - _1494), (mad(_1497, 0.5f, _1502)))));
                              break;
                            }
                          }
                          _1512 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _1516 = log2((max((((_1354 - _1355) * 0.9599999785423279f) + _1355), 1.000000013351432e-10f)));
                    float _1517 = _1516 * 0.3010300099849701f;
                    do {
                      if (!(!(_1517 <= _1369))) {
                        _1586 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _1524 = log2((cb0_009x));
                        float _1525 = _1524 * 0.3010300099849701f;
                        if ((((bool)((_1517 > _1369))) && ((bool)((_1517 < _1525))))) {
                          float _1533 = ((_1516 - _1368) * 0.9030900001525879f) / ((_1524 - _1368) * 0.3010300099849701f);
                          int _1534 = int(1534);
                          float _1536 = _1533 - (float(_1534));
                          float _1538 = _10[_1534];
                          float _1541 = _10[(_1534 + 1)];
                          float _1546 = _1538 * 0.5f;
                          _1586 = (dot(float3((_1536 * _1536), _1536, 1.0f), float3((mad((_10[(_1534 + 2)]), 0.5f, (mad(_1541, -1.0f, _1546)))), (_1541 - _1538), (mad(_1541, 0.5f, _1546)))));
                        } else {
                          do {
                            if (!(!(_1517 >= _1525))) {
                              float _1555 = log2((cb0_008z));
                              if (((_1517 < (_1555 * 0.3010300099849701f)))) {
                                float _1563 = ((_1516 - _1524) * 0.9030900001525879f) / ((_1555 - _1524) * 0.3010300099849701f);
                                int _1564 = int(1564);
                                float _1566 = _1563 - (float(_1564));
                                float _1568 = _11[_1564];
                                float _1571 = _11[(_1564 + 1)];
                                float _1576 = _1568 * 0.5f;
                                _1586 = (dot(float3((_1566 * _1566), _1566, 1.0f), float3((mad((_11[(_1564 + 2)]), 0.5f, (mad(_1571, -1.0f, _1576)))), (_1571 - _1568), (mad(_1571, 0.5f, _1576)))));
                                break;
                              }
                            }
                            _1586 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _1590 = (cb0_008w) - (cb0_008y);
                      float _1591 = ((exp2((_1438 * 3.321928024291992f))) - (cb0_008y)) / _1590;
                      float _1593 = ((exp2((_1512 * 3.321928024291992f))) - (cb0_008y)) / _1590;
                      float _1595 = ((exp2((_1586 * 3.321928024291992f))) - (cb0_008y)) / _1590;
                      float _1598 = mad(0.15618768334388733f, _1595, (mad(0.13400420546531677f, _1593, (_1591 * 0.6624541878700256f))));
                      float _1601 = mad(0.053689517080783844f, _1595, (mad(0.6740817427635193f, _1593, (_1591 * 0.2722287178039551f))));
                      float _1604 = mad(1.0103391408920288f, _1595, (mad(0.00406073359772563f, _1593, (_1591 * -0.005574649665504694f))));
                      float _1617 = min((max((mad(-0.23642469942569733f, _1604, (mad(-0.32480329275131226f, _1601, (_1598 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                      float _1618 = min((max((mad(0.016756348311901093f, _1604, (mad(1.6153316497802734f, _1601, (_1598 * -0.663662850856781f))))), 0.0f)), 1.0f);
                      float _1619 = min((max((mad(0.9883948564529419f, _1604, (mad(-0.008284442126750946f, _1601, (_1598 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                      float _1622 = mad(0.15618768334388733f, _1619, (mad(0.13400420546531677f, _1618, (_1617 * 0.6624541878700256f))));
                      float _1625 = mad(0.053689517080783844f, _1619, (mad(0.6740817427635193f, _1618, (_1617 * 0.2722287178039551f))));
                      float _1628 = mad(1.0103391408920288f, _1619, (mad(0.00406073359772563f, _1618, (_1617 * -0.005574649665504694f))));
                      float _1650 = min((max(((min((max((mad(-0.23642469942569733f, _1628, (mad(-0.32480329275131226f, _1625, (_1622 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1651 = min((max(((min((max((mad(0.016756348311901093f, _1628, (mad(1.6153316497802734f, _1625, (_1622 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      float _1652 = min((max(((min((max((mad(0.9883948564529419f, _1628, (mad(-0.008284442126750946f, _1625, (_1622 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                      _1665 = _1650;
                      _1666 = _1651;
                      _1667 = _1652;
                      _2418 = 1.f;
                      _2419 = 1.f;
                      _2420 = 0.f;

                      do {
                        if (!((((uint)(cb0_042w)) == 5))) {
                          _1665 = (mad(_45, _1652, (mad(_44, _1651, (_1650 * _43)))));
                          _1666 = (mad(_48, _1652, (mad(_47, _1651, (_1650 * _46)))));
                          _1667 = (mad(_51, _1652, (mad(_50, _1651, (_1650 * _49)))));
                        }
                        float _1677 = exp2(((log2((_1665 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1678 = exp2(((log2((_1666 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        float _1679 = exp2(((log2((_1667 * 9.999999747378752e-05f))) * 0.1593017578125f));
                        _2418 = (exp2(((log2(((1.0f / ((_1677 * 18.6875f) + 1.0f)) * ((_1677 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2419 = (exp2(((log2(((1.0f / ((_1678 * 18.6875f) + 1.0f)) * ((_1678 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                        _2420 = (exp2(((log2(((1.0f / ((_1679 * 18.6875f) + 1.0f)) * ((_1679 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
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
          _8[0] = (cb0_010x);
          _8[1] = (cb0_010y);
          _8[2] = (cb0_010z);
          _8[3] = (cb0_010w);
          _8[4] = (cb0_012x);
          _8[5] = (cb0_012x);
          _9[0] = (cb0_011x);
          _9[1] = (cb0_011y);
          _9[2] = (cb0_011z);
          _9[3] = (cb0_011w);
          _9[4] = (cb0_012y);
          _9[5] = (cb0_012y);
          float _1756 = (cb0_012z)*_957;
          float _1757 = (cb0_012z)*_958;
          float _1758 = (cb0_012z)*_959;
          float _1761 = mad((UniformBufferConstants_WorkingColorSpace_016z), _1758, (mad((UniformBufferConstants_WorkingColorSpace_016y), _1757, ((UniformBufferConstants_WorkingColorSpace_016x)*_1756))));
          float _1764 = mad((UniformBufferConstants_WorkingColorSpace_017z), _1758, (mad((UniformBufferConstants_WorkingColorSpace_017y), _1757, ((UniformBufferConstants_WorkingColorSpace_017x)*_1756))));
          float _1767 = mad((UniformBufferConstants_WorkingColorSpace_018z), _1758, (mad((UniformBufferConstants_WorkingColorSpace_018y), _1757, ((UniformBufferConstants_WorkingColorSpace_018x)*_1756))));
          float _1771 = max((max(_1761, _1764)), _1767);
          float _1776 = ((max(_1771, 1.000000013351432e-10f)) - (max((min((min(_1761, _1764)), _1767)), 1.000000013351432e-10f))) / (max(_1771, 0.009999999776482582f));
          float _1789 = ((_1764 + _1761) + _1767) + ((sqrt(((((_1767 - _1764) * _1767) + ((_1764 - _1761) * _1764)) + ((_1761 - _1767) * _1761)))) * 1.75f);
          float _1790 = _1789 * 0.3333333432674408f;
          float _1791 = _1776 + -0.4000000059604645f;
          float _1792 = _1791 * 5.0f;
          float _1796 = max((1.0f - (abs((_1791 * 2.5f)))), 0.0f);
          float _1807 = (((float(((int(((bool)((_1792 > 0.0f))))) - (int(((bool)((_1792 < 0.0f)))))))) * (1.0f - (_1796 * _1796))) + 1.0f) * 0.02500000037252903f;
          _1816 = _1807;
          do {
            if ((!(_1790 <= 0.0533333346247673f))) {
              _1816 = 0.0f;
              if ((!(_1790 >= 0.1599999964237213f))) {
                _1816 = (((0.23999999463558197f / _1789) + -0.5f) * _1807);
              }
            }
            float _1817 = _1816 + 1.0f;
            float _1818 = _1817 * _1761;
            float _1819 = _1817 * _1764;
            float _1820 = _1817 * _1767;
            _1849 = 0.0f;
            do {
              if (!(((bool)((_1818 == _1819))) && ((bool)((_1819 == _1820))))) {
                float _1827 = ((_1818 * 2.0f) - _1819) - _1820;
                float _1830 = ((_1764 - _1767) * 1.7320507764816284f) * _1817;
                float _1832 = atan((_1830 / _1827));
                bool _1835 = (_1827 < 0.0f);
                bool _1836 = (_1827 == 0.0f);
                bool _1837 = (_1830 >= 0.0f);
                bool _1838 = (_1830 < 0.0f);
                _1849 = ((((bool)(_1837 && _1836)) ? 90.0f : ((((bool)(_1838 && _1836)) ? -90.0f : (((((bool)(_1838 && _1835)) ? (_1832 + -3.1415927410125732f) : ((((bool)(_1837 && _1835)) ? (_1832 + 3.1415927410125732f) : _1832)))) * 57.2957763671875f)))));
              }
              float _1854 = min((max(((((bool)((_1849 < 0.0f))) ? (_1849 + 360.0f) : _1849)), 0.0f)), 360.0f);
              do {
                if (((_1854 < -180.0f))) {
                  _1863 = (_1854 + 360.0f);
                } else {
                  _1863 = _1854;
                  if (((_1854 > 180.0f))) {
                    _1863 = (_1854 + -360.0f);
                  }
                }
                _1902 = 0.0f;
                do {
                  if ((((bool)((_1863 > -67.5f))) && ((bool)((_1863 < 67.5f))))) {
                    float _1869 = (_1863 + 67.5f) * 0.029629629105329514f;
                    int _1870 = int(1870);
                    float _1872 = _1869 - (float(_1870));
                    float _1873 = _1872 * _1872;
                    float _1874 = _1873 * _1872;
                    if (_1870 == 3) {
                      _1902 = (((0.1666666716337204f - (_1872 * 0.5f)) + (_1873 * 0.5f)) - (_1874 * 0.1666666716337204f));
                    } else {
                      if (_1870 == 2) {
                        _1902 = ((0.6666666865348816f - _1873) + (_1874 * 0.5f));
                      } else {
                        if (_1870 == 1) {
                          _1902 = (((_1874 * -0.5f) + 0.1666666716337204f) + ((_1873 + _1872) * 0.5f));
                        } else {
                          _1902 = ((((bool)((_1870 == 0))) ? (_1874 * 0.1666666716337204f) : 0.0f));
                        }
                      }
                    }
                  }
                  float _1911 = min((max(((((_1776 * 0.27000001072883606f) * (0.029999999329447746f - _1818)) * _1902) + _1818), 0.0f)), 65535.0f);
                  float _1912 = min((max(_1819, 0.0f)), 65535.0f);
                  float _1913 = min((max(_1820, 0.0f)), 65535.0f);
                  float _1926 = min((max((mad(-0.21492856740951538f, _1913, (mad(-0.2365107536315918f, _1912, (_1911 * 1.4514392614364624f))))), 0.0f)), 65504.0f);
                  float _1927 = min((max((mad(-0.09967592358589172f, _1913, (mad(1.17622971534729f, _1912, (_1911 * -0.07655377686023712f))))), 0.0f)), 65504.0f);
                  float _1928 = min((max((mad(0.9977163076400757f, _1913, (mad(-0.006032449658960104f, _1912, (_1911 * 0.008316148072481155f))))), 0.0f)), 65504.0f);
                  float _1929 = dot(float3(_1926, _1927, _1928), float3(0.2722287178039551f, 0.6740817427635193f, 0.053689517080783844f));
                  float _1940 = log2((max((((_1926 - _1929) * 0.9599999785423279f) + _1929), 1.000000013351432e-10f)));
                  float _1941 = _1940 * 0.3010300099849701f;
                  float _1942 = log2((cb0_008x));
                  float _1943 = _1942 * 0.3010300099849701f;
                  do {
                    if (!(!(_1941 <= _1943))) {
                      _2012 = ((log2((cb0_008y))) * 0.3010300099849701f);
                    } else {
                      float _1950 = log2((cb0_009x));
                      float _1951 = _1950 * 0.3010300099849701f;
                      if ((((bool)((_1941 > _1943))) && ((bool)((_1941 < _1951))))) {
                        float _1959 = ((_1940 - _1942) * 0.9030900001525879f) / ((_1950 - _1942) * 0.3010300099849701f);
                        int _1960 = int(1960);
                        float _1962 = _1959 - (float(_1960));
                        float _1964 = _8[_1960];
                        float _1967 = _8[(_1960 + 1)];
                        float _1972 = _1964 * 0.5f;
                        _2012 = (dot(float3((_1962 * _1962), _1962, 1.0f), float3((mad((_8[(_1960 + 2)]), 0.5f, (mad(_1967, -1.0f, _1972)))), (_1967 - _1964), (mad(_1967, 0.5f, _1972)))));
                      } else {
                        do {
                          if (!(!(_1941 >= _1951))) {
                            float _1981 = log2((cb0_008z));
                            if (((_1941 < (_1981 * 0.3010300099849701f)))) {
                              float _1989 = ((_1940 - _1950) * 0.9030900001525879f) / ((_1981 - _1950) * 0.3010300099849701f);
                              int _1990 = int(1990);
                              float _1992 = _1989 - (float(_1990));
                              float _1994 = _9[_1990];
                              float _1997 = _9[(_1990 + 1)];
                              float _2002 = _1994 * 0.5f;
                              _2012 = (dot(float3((_1992 * _1992), _1992, 1.0f), float3((mad((_9[(_1990 + 2)]), 0.5f, (mad(_1997, -1.0f, _2002)))), (_1997 - _1994), (mad(_1997, 0.5f, _2002)))));
                              break;
                            }
                          }
                          _2012 = ((log2((cb0_008w))) * 0.3010300099849701f);
                        } while (false);
                      }
                    }
                    float _2016 = log2((max((((_1927 - _1929) * 0.9599999785423279f) + _1929), 1.000000013351432e-10f)));
                    float _2017 = _2016 * 0.3010300099849701f;
                    do {
                      if (!(!(_2017 <= _1943))) {
                        _2086 = ((log2((cb0_008y))) * 0.3010300099849701f);
                      } else {
                        float _2024 = log2((cb0_009x));
                        float _2025 = _2024 * 0.3010300099849701f;
                        if ((((bool)((_2017 > _1943))) && ((bool)((_2017 < _2025))))) {
                          float _2033 = ((_2016 - _1942) * 0.9030900001525879f) / ((_2024 - _1942) * 0.3010300099849701f);
                          int _2034 = int(2034);
                          float _2036 = _2033 - (float(_2034));
                          float _2038 = _8[_2034];
                          float _2041 = _8[(_2034 + 1)];
                          float _2046 = _2038 * 0.5f;
                          _2086 = (dot(float3((_2036 * _2036), _2036, 1.0f), float3((mad((_8[(_2034 + 2)]), 0.5f, (mad(_2041, -1.0f, _2046)))), (_2041 - _2038), (mad(_2041, 0.5f, _2046)))));
                        } else {
                          do {
                            if (!(!(_2017 >= _2025))) {
                              float _2055 = log2((cb0_008z));
                              if (((_2017 < (_2055 * 0.3010300099849701f)))) {
                                float _2063 = ((_2016 - _2024) * 0.9030900001525879f) / ((_2055 - _2024) * 0.3010300099849701f);
                                int _2064 = int(2064);
                                float _2066 = _2063 - (float(_2064));
                                float _2068 = _9[_2064];
                                float _2071 = _9[(_2064 + 1)];
                                float _2076 = _2068 * 0.5f;
                                _2086 = (dot(float3((_2066 * _2066), _2066, 1.0f), float3((mad((_9[(_2064 + 2)]), 0.5f, (mad(_2071, -1.0f, _2076)))), (_2071 - _2068), (mad(_2071, 0.5f, _2076)))));
                                break;
                              }
                            }
                            _2086 = ((log2((cb0_008w))) * 0.3010300099849701f);
                          } while (false);
                        }
                      }
                      float _2090 = log2((max((((_1928 - _1929) * 0.9599999785423279f) + _1929), 1.000000013351432e-10f)));
                      float _2091 = _2090 * 0.3010300099849701f;
                      do {
                        if (!(!(_2091 <= _1943))) {
                          _2160 = ((log2((cb0_008y))) * 0.3010300099849701f);
                        } else {
                          float _2098 = log2((cb0_009x));
                          float _2099 = _2098 * 0.3010300099849701f;
                          if ((((bool)((_2091 > _1943))) && ((bool)((_2091 < _2099))))) {
                            float _2107 = ((_2090 - _1942) * 0.9030900001525879f) / ((_2098 - _1942) * 0.3010300099849701f);
                            int _2108 = int(2108);
                            float _2110 = _2107 - (float(_2108));
                            float _2112 = _8[_2108];
                            float _2115 = _8[(_2108 + 1)];
                            float _2120 = _2112 * 0.5f;
                            _2160 = (dot(float3((_2110 * _2110), _2110, 1.0f), float3((mad((_8[(_2108 + 2)]), 0.5f, (mad(_2115, -1.0f, _2120)))), (_2115 - _2112), (mad(_2115, 0.5f, _2120)))));
                          } else {
                            do {
                              if (!(!(_2091 >= _2099))) {
                                float _2129 = log2((cb0_008z));
                                if (((_2091 < (_2129 * 0.3010300099849701f)))) {
                                  float _2137 = ((_2090 - _2098) * 0.9030900001525879f) / ((_2129 - _2098) * 0.3010300099849701f);
                                  int _2138 = int(2138);
                                  float _2140 = _2137 - (float(_2138));
                                  float _2142 = _9[_2138];
                                  float _2145 = _9[(_2138 + 1)];
                                  float _2150 = _2142 * 0.5f;
                                  _2160 = (dot(float3((_2140 * _2140), _2140, 1.0f), float3((mad((_9[(_2138 + 2)]), 0.5f, (mad(_2145, -1.0f, _2150)))), (_2145 - _2142), (mad(_2145, 0.5f, _2150)))));
                                  break;
                                }
                              }
                              _2160 = ((log2((cb0_008w))) * 0.3010300099849701f);
                            } while (false);
                          }
                        }
                        float _2164 = (cb0_008w) - (cb0_008y);
                        float _2165 = ((exp2((_2012 * 3.321928024291992f))) - (cb0_008y)) / _2164;
                        float _2167 = ((exp2((_2086 * 3.321928024291992f))) - (cb0_008y)) / _2164;
                        float _2169 = ((exp2((_2160 * 3.321928024291992f))) - (cb0_008y)) / _2164;
                        float _2172 = mad(0.15618768334388733f, _2169, (mad(0.13400420546531677f, _2167, (_2165 * 0.6624541878700256f))));
                        float _2175 = mad(0.053689517080783844f, _2169, (mad(0.6740817427635193f, _2167, (_2165 * 0.2722287178039551f))));
                        float _2178 = mad(1.0103391408920288f, _2169, (mad(0.00406073359772563f, _2167, (_2165 * -0.005574649665504694f))));
                        float _2191 = min((max((mad(-0.23642469942569733f, _2178, (mad(-0.32480329275131226f, _2175, (_2172 * 1.6410233974456787f))))), 0.0f)), 1.0f);
                        float _2192 = min((max((mad(0.016756348311901093f, _2178, (mad(1.6153316497802734f, _2175, (_2172 * -0.663662850856781f))))), 0.0f)), 1.0f);
                        float _2193 = min((max((mad(0.9883948564529419f, _2178, (mad(-0.008284442126750946f, _2175, (_2172 * 0.011721894145011902f))))), 0.0f)), 1.0f);
                        float _2196 = mad(0.15618768334388733f, _2193, (mad(0.13400420546531677f, _2192, (_2191 * 0.6624541878700256f))));
                        float _2199 = mad(0.053689517080783844f, _2193, (mad(0.6740817427635193f, _2192, (_2191 * 0.2722287178039551f))));
                        float _2202 = mad(1.0103391408920288f, _2193, (mad(0.00406073359772563f, _2192, (_2191 * -0.005574649665504694f))));
                        float _2224 = min((max(((min((max((mad(-0.23642469942569733f, _2202, (mad(-0.32480329275131226f, _2199, (_2196 * 1.6410233974456787f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2225 = min((max(((min((max((mad(0.016756348311901093f, _2202, (mad(1.6153316497802734f, _2199, (_2196 * -0.663662850856781f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        float _2226 = min((max(((min((max((mad(0.9883948564529419f, _2202, (mad(-0.008284442126750946f, _2199, (_2196 * 0.011721894145011902f))))), 0.0f)), 65535.0f)) * (cb0_008w)), 0.0f)), 65535.0f);
                        _2239 = _2224;
                        _2240 = _2225;
                        _2241 = _2226;
                        do {
                          if (!((((uint)(cb0_042w)) == 6))) {
                            _2239 = (mad(_45, _2226, (mad(_44, _2225, (_2224 * _43)))));
                            _2240 = (mad(_48, _2226, (mad(_47, _2225, (_2224 * _46)))));
                            _2241 = (mad(_51, _2226, (mad(_50, _2225, (_2224 * _49)))));
                          }
                          float _2251 = exp2(((log2((_2239 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2252 = exp2(((log2((_2240 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          float _2253 = exp2(((log2((_2241 * 9.999999747378752e-05f))) * 0.1593017578125f));
                          _2418 = (exp2(((log2(((1.0f / ((_2251 * 18.6875f) + 1.0f)) * ((_2251 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2419 = (exp2(((log2(((1.0f / ((_2252 * 18.6875f) + 1.0f)) * ((_2252 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
                          _2420 = (exp2(((log2(((1.0f / ((_2253 * 18.6875f) + 1.0f)) * ((_2253 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));

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
            float _2298 = mad((UniformBufferConstants_WorkingColorSpace_008z), _959, (mad((UniformBufferConstants_WorkingColorSpace_008y), _958, ((UniformBufferConstants_WorkingColorSpace_008x)*_957))));
            float _2301 = mad((UniformBufferConstants_WorkingColorSpace_009z), _959, (mad((UniformBufferConstants_WorkingColorSpace_009y), _958, ((UniformBufferConstants_WorkingColorSpace_009x)*_957))));
            float _2304 = mad((UniformBufferConstants_WorkingColorSpace_010z), _959, (mad((UniformBufferConstants_WorkingColorSpace_010y), _958, ((UniformBufferConstants_WorkingColorSpace_010x)*_957))));
            float _2323 = exp2(((log2(((mad(_45, _2304, (mad(_44, _2301, (_2298 * _43))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2324 = exp2(((log2(((mad(_48, _2304, (mad(_47, _2301, (_2298 * _46))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            float _2325 = exp2(((log2(((mad(_51, _2304, (mad(_50, _2301, (_2298 * _49))))) * 9.999999747378752e-05f))) * 0.1593017578125f));
            _2418 = (exp2(((log2(((1.0f / ((_2323 * 18.6875f) + 1.0f)) * ((_2323 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2419 = (exp2(((log2(((1.0f / ((_2324 * 18.6875f) + 1.0f)) * ((_2324 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
            _2420 = (exp2(((log2(((1.0f / ((_2325 * 18.6875f) + 1.0f)) * ((_2325 * 18.8515625f) + 0.8359375f)))) * 78.84375f)));
          } else {
            _2418 = _957;
            _2419 = _958;
            _2420 = _959;
            if (!((((uint)(cb0_042w)) == 8))) {
              if (((((uint)(cb0_042w)) == 9))) {
                float _2372 = mad((UniformBufferConstants_WorkingColorSpace_008z), _947, (mad((UniformBufferConstants_WorkingColorSpace_008y), _946, ((UniformBufferConstants_WorkingColorSpace_008x)*_945))));
                float _2375 = mad((UniformBufferConstants_WorkingColorSpace_009z), _947, (mad((UniformBufferConstants_WorkingColorSpace_009y), _946, ((UniformBufferConstants_WorkingColorSpace_009x)*_945))));
                float _2378 = mad((UniformBufferConstants_WorkingColorSpace_010z), _947, (mad((UniformBufferConstants_WorkingColorSpace_010y), _946, ((UniformBufferConstants_WorkingColorSpace_010x)*_945))));
                _2418 = (mad(_45, _2378, (mad(_44, _2375, (_2372 * _43)))));
                _2419 = (mad(_48, _2378, (mad(_47, _2375, (_2372 * _46)))));
                _2420 = (mad(_51, _2378, (mad(_50, _2375, (_2372 * _49)))));
              } else {
                float _2391 = mad((UniformBufferConstants_WorkingColorSpace_008z), _973, (mad((UniformBufferConstants_WorkingColorSpace_008y), _972, ((UniformBufferConstants_WorkingColorSpace_008x)*_971))));
                float _2394 = mad((UniformBufferConstants_WorkingColorSpace_009z), _973, (mad((UniformBufferConstants_WorkingColorSpace_009y), _972, ((UniformBufferConstants_WorkingColorSpace_009x)*_971))));
                float _2397 = mad((UniformBufferConstants_WorkingColorSpace_010z), _973, (mad((UniformBufferConstants_WorkingColorSpace_010y), _972, ((UniformBufferConstants_WorkingColorSpace_010x)*_971))));
                _2418 = (exp2(((log2((mad(_45, _2397, (mad(_44, _2394, (_2391 * _43))))))) * (cb0_042z))));
                _2419 = (exp2(((log2((mad(_48, _2397, (mad(_47, _2394, (_2391 * _46))))))) * (cb0_042z))));
                _2420 = (exp2(((log2((mad(_51, _2397, (mad(_50, _2394, (_2391 * _49))))))) * (cb0_042z))));
              }
            }
          }
        }
      }
    }
  }
  SV_Target.x = (_2418 * 0.9523810148239136f);
  SV_Target.y = (_2419 * 0.9523810148239136f);
  SV_Target.z = (_2420 * 0.9523810148239136f);
  SV_Target.w = 0.0f;
  SV_Target.rgb *= 5;
  return SV_Target;
}
