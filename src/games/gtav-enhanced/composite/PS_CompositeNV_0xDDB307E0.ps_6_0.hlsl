Texture2DArray<float> t1 : register(t1);

Texture2D<float> t11_space1 : register(t11, space1);

Texture2D<float4> t15_space1 : register(t15, space1);

Texture2D<float4> t17_space1 : register(t17, space1);

Texture2D<float4> t19_space1 : register(t19, space1);

Texture2D<float4> t25_space1 : register(t25, space1);

Texture2D<float4> t31_space1 : register(t31, space1);

cbuffer cb3 : register(b3) {
  int g_rage_dynamicsamplerindices_000 : packoffset(c000.x);
  int g_rage_dynamicsamplerindices_004 : packoffset(c000.y);
  int g_rage_dynamicsamplerindices_008 : packoffset(c000.z);
  int g_rage_dynamicsamplerindices_012 : packoffset(c000.w);
  int g_rage_dynamicsamplerindices_016 : packoffset(c001.x);
  int g_rage_dynamicsamplerindices_020 : packoffset(c001.y);
  int g_rage_dynamicsamplerindices_024 : packoffset(c001.z);
  int g_rage_dynamicsamplerindices_028 : packoffset(c001.w);
  int g_rage_dynamicsamplerindices_032 : packoffset(c002.x);
  int g_rage_dynamicsamplerindices_036 : packoffset(c002.y);
  int g_rage_dynamicsamplerindices_040 : packoffset(c002.z);
  int g_rage_dynamicsamplerindices_044 : packoffset(c002.w);
  int g_rage_dynamicsamplerindices_048 : packoffset(c003.x);
  int g_rage_dynamicsamplerindices_052 : packoffset(c003.y);
  int g_rage_dynamicsamplerindices_056 : packoffset(c003.z);
  int g_rage_dynamicsamplerindices_060 : packoffset(c003.w);
  int g_rage_dynamicsamplerindices_064 : packoffset(c004.x);
  int g_rage_dynamicsamplerindices_068 : packoffset(c004.y);
  int g_rage_dynamicsamplerindices_072 : packoffset(c004.z);
  int g_rage_dynamicsamplerindices_076 : packoffset(c004.w);
  int g_rage_dynamicsamplerindices_080 : packoffset(c005.x);
  int g_rage_dynamicsamplerindices_084 : packoffset(c005.y);
};

cbuffer cb5 : register(b5) {
  float cb5_014w : packoffset(c014.w);
  uint cb5_022y : packoffset(c022.y);
};

cbuffer cb12_space1 : register(b12, space1) {
  float cb12_space1_000z : packoffset(c000.z);
  float cb12_space1_000w : packoffset(c000.w);
  float cb12_space1_002x : packoffset(c002.x);
  float cb12_space1_002y : packoffset(c002.y);
  float cb12_space1_002z : packoffset(c002.z);
  float cb12_space1_007y : packoffset(c007.y);
  float cb12_space1_010x : packoffset(c010.x);
  float cb12_space1_010y : packoffset(c010.y);
  float cb12_space1_010z : packoffset(c010.z);
  float cb12_space1_010w : packoffset(c010.w);
  float cb12_space1_011x : packoffset(c011.x);
  float cb12_space1_011y : packoffset(c011.y);
  float cb12_space1_011z : packoffset(c011.z);
  float cb12_space1_012x : packoffset(c012.x);
  float cb12_space1_012y : packoffset(c012.y);
  float cb12_space1_012z : packoffset(c012.z);
  float cb12_space1_012w : packoffset(c012.w);
  float cb12_space1_013x : packoffset(c013.x);
  float cb12_space1_013y : packoffset(c013.y);
  float cb12_space1_013z : packoffset(c013.z);
  float cb12_space1_014x : packoffset(c014.x);
  float cb12_space1_014y : packoffset(c014.y);
  float cb12_space1_015x : packoffset(c015.x);
  float cb12_space1_015y : packoffset(c015.y);
  float cb12_space1_023w : packoffset(c023.w);
  float cb12_space1_024x : packoffset(c024.x);
  float cb12_space1_024y : packoffset(c024.y);
  float cb12_space1_024z : packoffset(c024.z);
  float cb12_space1_024w : packoffset(c024.w);
  float cb12_space1_025x : packoffset(c025.x);
  float cb12_space1_025y : packoffset(c025.y);
  float cb12_space1_025z : packoffset(c025.z);
  float cb12_space1_025w : packoffset(c025.w);
  float cb12_space1_026x : packoffset(c026.x);
  float cb12_space1_026y : packoffset(c026.y);
  float cb12_space1_027x : packoffset(c027.x);
  float cb12_space1_027y : packoffset(c027.y);
  float cb12_space1_027z : packoffset(c027.z);
  float cb12_space1_028x : packoffset(c028.x);
  float cb12_space1_028y : packoffset(c028.y);
  float cb12_space1_028z : packoffset(c028.z);
  float cb12_space1_029x : packoffset(c029.x);
  float cb12_space1_029y : packoffset(c029.y);
  float cb12_space1_029z : packoffset(c029.z);
  float cb12_space1_046x : packoffset(c046.x);
  float cb12_space1_046y : packoffset(c046.y);
  float cb12_space1_046z : packoffset(c046.z);
  float cb12_space1_065x : packoffset(c065.x);
  float cb12_space1_065y : packoffset(c065.y);
  float cb12_space1_065z : packoffset(c065.z);
  float cb12_space1_065w : packoffset(c065.w);
  float cb12_space1_066x : packoffset(c066.x);
  float cb12_space1_066y : packoffset(c066.y);
  float cb12_space1_066z : packoffset(c066.z);
  float cb12_space1_066w : packoffset(c066.w);
  float cb12_space1_067x : packoffset(c067.x);
  float cb12_space1_075z : packoffset(c075.z);
  float cb12_space1_089x : packoffset(c089.x);
  float cb12_space1_090x : packoffset(c090.x);
  float cb12_space1_090y : packoffset(c090.y);
  float cb12_space1_090z : packoffset(c090.z);
  float cb12_space1_091x : packoffset(c091.x);
  float cb12_space1_091y : packoffset(c091.y);
  float cb12_space1_091z : packoffset(c091.z);
  float cb12_space1_092x : packoffset(c092.x);
  float cb12_space1_092y : packoffset(c092.y);
  float cb12_space1_092z : packoffset(c092.z);
  float cb12_space1_092w : packoffset(c092.w);
  float cb12_space1_093x : packoffset(c093.x);
  float cb12_space1_093y : packoffset(c093.y);
  float cb12_space1_093z : packoffset(c093.z);
  float cb12_space1_093w : packoffset(c093.w);
};

SamplerState s0_space1 : register(s0, space1);

SamplerState s1_space1 : register(s1, space1);

SamplerState s2_space1 : register(s2, space1);

SamplerState s0_space2[] : register(s0, space2);

SamplerState s8_space1 : register(s8, space1);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD,
  linear float TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float _22 = t11_space1.Sample(s0_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _24 = 1.0f - _22.x;
  float4 _45 = t15_space1.Sample(s0_space2[(g_rage_dynamicsamplerindices_012 + 0u)], float2(TEXCOORD.x, TEXCOORD.y));
  float _51 = cb5_014w * _45.x;
  float _52 = cb5_014w * _45.y;
  float _53 = cb5_014w * _45.z;
  float4 _54 = t19_space1.Sample(s1_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _58 = saturate((saturate(cb12_space1_002y * ((cb12_space1_000z / (_24 + cb12_space1_000w)) - cb12_space1_002x)) * float((bool)((bool)(!(_24 == 0.0f))))) * cb12_space1_002z);
  float _65 = ((_54.x - _51) * _58) + _51;
  float _66 = ((_54.y - _52) * _58) + _52;
  float _67 = ((_54.z - _53) * _58) + _53;
  float4 _72 = t25_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
  float _96;
  float _97;
  float _98;
  float _474;
  float _475;
  float _476;
  if (cb12_space1_075z > 0.0f) {
    float4 _80 = t31_space1.Sample(s2_space1, float2(TEXCOORD.x, TEXCOORD.y));
    float _82 = _80.x * _80.x;
    float _83 = _82 * _82;
    float _84 = _83 * _83;
    _96 = ((_84 * cb12_space1_046x) + _65);
    _97 = ((_84 * cb12_space1_046y) + _66);
    _98 = ((_84 * cb12_space1_046z) + _67);
  } else {
    _96 = _65;
    _97 = _66;
    _98 = _67;
  }
  float _107 = saturate((cb12_space1_014x * TEXCOORD_1) + cb12_space1_014y);
  float _126 = ((cb12_space1_012x - cb12_space1_010x) * _107) + cb12_space1_010x;
  float _127 = ((cb12_space1_012y - cb12_space1_010y) * _107) + cb12_space1_010y;
  float _129 = ((cb12_space1_012w - cb12_space1_010w) * _107) + cb12_space1_010w;
  float _144 = ((cb12_space1_013x - cb12_space1_011x) * _107) + cb12_space1_011x;
  float _145 = ((cb12_space1_013y - cb12_space1_011y) * _107) + cb12_space1_011y;
  float _146 = ((cb12_space1_013z - cb12_space1_011z) * _107) + cb12_space1_011z;
  float _147 = _146 * _126;
  float _148 = (lerp(cb12_space1_010z, cb12_space1_012z, _107)) * _127;
  float _151 = _144 * _129;
  float _155 = _145 * _129;
  float _158 = _144 / _145;
  float _160 = 1.0f / (((((_147 + _148) * _146) + _151) / (((_147 + _127) * _146) + _155)) - _158);
  float _164 = max(0.0f, (min(_96, 65504.0f) * TEXCOORD.z));
  float _165 = max(0.0f, (min(_97, 65504.0f) * TEXCOORD.z));
  float _166 = max(0.0f, (min(_98, 65504.0f) * TEXCOORD.z));
  float _167 = _164 * _126;
  float _168 = _165 * _126;
  float _169 = _166 * _126;
  float _197 = saturate((((((_167 + _148) * _164) + _151) / (((_167 + _127) * _164) + _155)) - _158) * _160);
  float _198 = saturate((((((_168 + _148) * _165) + _151) / (((_168 + _127) * _165) + _155)) - _158) * _160);
  float _199 = saturate((((((_169 + _148) * _166) + _151) / (((_169 + _127) * _166) + _155)) - _158) * _160);
  float _200 = dot(float3(_197, _198, _199), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _209 = (cb12_space1_067x * (_197 - _200)) + _200;
  float _210 = (cb12_space1_067x * (_198 - _200)) + _200;
  float _211 = (cb12_space1_067x * (_199 - _200)) + _200;
  float _215 = saturate(_200 / cb12_space1_066w);
  float _232 = (lerp(cb12_space1_066x, cb12_space1_065x, _215)) * _209;
  float _233 = (lerp(cb12_space1_066y, cb12_space1_065y, _215)) * _210;
  float _234 = (lerp(cb12_space1_066z, cb12_space1_065z, _215)) * _211;
  float _240 = saturate(((_200 + -1.0f) + cb12_space1_065w) / max(0.009999999776482582f, cb12_space1_065w));
  float _256 = cb12_space1_024z * dot(float3(saturate(lerp(_232, _209, _240)), saturate(lerp(_233, _210, _240)), saturate(lerp(_234, _211, _240))), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _260 = saturate(_256 / cb12_space1_023w);
  float _261 = 1.0f - _260;
  float _267 = saturate((_256 - cb12_space1_024x) / (cb12_space1_024y - cb12_space1_024x));
  float _268 = _260 - _267;
  float _277 = ((cb12_space1_025y * _267) + (cb12_space1_025x * _261)) + (cb12_space1_024w * _268);
  float4 _288 = t17_space1.Sample(s8_space1, float2(frac(cb12_space1_015x + (TEXCOORD.x * 2.4000000953674316f)), frac(cb12_space1_015y + (TEXCOORD.y * 1.3499999046325684f))));
  float _295 = _288.y + -0.5f;
  float _302 = select((cb12_space1_007y < 0.0f), 1.0f, TEXCOORD.w) * TEXCOORD.z;
  float _306 = max(0.0f, (_302 * _72.x));
  float _307 = max(0.0f, (_302 * _72.y));
  float _308 = max(0.0f, (_302 * _72.z));
  float _309 = _306 * _126;
  float _310 = _307 * _126;
  float _311 = _308 * _126;
  float _351 = (((_277 + _256) + max(((_295 * _267) * cb12_space1_026x), 0.0f)) + (((cb12_space1_025z * _268) + (cb12_space1_025w * _261)) * _295)) + (max(((_277 - _267) + (cb12_space1_024z * dot(float3(saturate((((((_309 + _148) * _306) + _151) / (((_309 + _127) * _306) + _155)) - _158) * _160), saturate((((((_310 + _148) * _307) + _151) / (((_310 + _127) * _307) + _155)) - _158) * _160), saturate((((((_311 + _148) * _308) + _151) / (((_311 + _127) * _308) + _155)) - _158) * _160)), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f)))), 0.0f) * cb12_space1_026y);
  float _382 = saturate((((cb12_space1_029x * _267) + (cb12_space1_028x * _261)) + (cb12_space1_027x * _268)) * _351);
  float _383 = saturate((((cb12_space1_029y * _267) + (cb12_space1_028y * _261)) + (cb12_space1_027y * _268)) * _351);
  float _384 = saturate((((cb12_space1_029z * _267) + (cb12_space1_028z * _261)) + (cb12_space1_027z * _268)) * _351);
  if (!(asint(cb12_space1_089x) == 0)) {
    bool _394 = (asint(cb12_space1_092w) != 0);
    float _396 = max(_382, max(_383, _384));
    float _450 = t1.Load(int4(((uint)(uint(SV_Position.x)) & 63), ((uint)(uint(SV_Position.y)) & 63), ((uint)(cb5_022y) & 31), 0));
    float _453 = (_450.x * 2.0f) + -1.0f;
    float _459 = float(((int)(uint)((bool)(_453 > 0.0f))) - ((int)(uint)((bool)(_453 < 0.0f))));
    float _463 = 1.0f - sqrt(1.0f - abs(_453));
    _474 = (((_463 * (((cb12_space1_091x - cb12_space1_090x) * exp2(log2(saturate((select(_394, _382, _396) - cb12_space1_093x) * cb12_space1_092x)) * cb12_space1_093w)) + cb12_space1_090x)) * _459) + _382);
    _475 = (((_463 * (((cb12_space1_091y - cb12_space1_090y) * exp2(log2(saturate((select(_394, _383, _396) - cb12_space1_093y) * cb12_space1_092y)) * cb12_space1_093w)) + cb12_space1_090y)) * _459) + _383);
    _476 = (((_463 * (((cb12_space1_091z - cb12_space1_090z) * exp2(log2(saturate((select(_394, _384, _396) - cb12_space1_093z) * cb12_space1_092z)) * cb12_space1_093w)) + cb12_space1_090z)) * _459) + _384);
  } else {
    _474 = _382;
    _475 = _383;
    _476 = _384;
  }
  SV_Target.x = _474;
  SV_Target.y = _475;
  SV_Target.z = _476;
  SV_Target.w = dot(float3(_382, _383, _384), float3(0.29899999499320984f, 0.5870000123977661f, 0.11400000005960464f));
  return SV_Target;
}
