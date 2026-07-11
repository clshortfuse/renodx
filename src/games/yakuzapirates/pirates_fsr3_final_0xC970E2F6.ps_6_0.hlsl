// Pirates FSR3 FG Final

#include "./common.hlsl"

Texture2D<float4> s0_t : register(t0);

cbuffer cb_user : register(b9) {
  float cb_user_000x : packoffset(c000.x);
  float cb_user_000y : packoffset(c000.y);
  float cb_user_002x : packoffset(c002.x);
  float cb_user_002y : packoffset(c002.y);
  float cb_user_002z : packoffset(c002.z);
  float cb_user_002w : packoffset(c002.w);
};

SamplerState s0_s : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _6 = s0_t.Sample(s0_s, float2((TEXCOORD.x), (TEXCOORD.y)));

  if (injectedData.toneMapType != 0.f) {
    float3 color = ProcessColor(_6.rgb);
    SV_Target.xyz = color.rgb;
    SV_Target.w = 1.f;
    return SV_Target;
  }

  float _43 = 1.0f / (cb_user_000x);
  float _50 = exp2(((log2((exp2(((log2(((((bool)(((bool)(!((_6.x) == 0.0f))) && ((bool)(((asint((abs((_6.x))))) > 2139095040))))) ? 0.0f : (max(0.0f, (_6.x))))))) * (cb_user_000y)))))) * _43));
  float _51 = exp2(((log2((exp2(((log2(((((bool)(((bool)(!((_6.y) == 0.0f))) && ((bool)(((asint((abs((_6.y))))) > 2139095040))))) ? 0.0f : (max(0.0f, (_6.y))))))) * (cb_user_000y)))))) * _43));
  float _52 = exp2(((log2((exp2(((log2(((((bool)(((bool)(!((_6.z) == 0.0f))) && ((bool)(((asint((abs((_6.z))))) > 2139095040))))) ? 0.0f : (max(0.0f, (_6.z))))))) * (cb_user_000y)))))) * _43));
  float _55 = mad(0.043299127370119095f, _52, (mad(0.32924848794937134f, _51, (_50 * 0.6274523735046387f))));
  float _58 = mad(0.011359736323356628f, _52, (mad(0.9195311069488525f, _51, (_50 * 0.06910918653011322f))));
  float _61 = mad(0.895572304725647f, _52, (mad(0.0880301371216774f, _51, (_50 * 0.016397561877965927f))));
  float _103 = (cb_user_002x) * 0.009999999776482582f;
  float _104 = _103 * (exp2(((log2(((((bool)((_55 <= 0.0003024152829311788f))) ? (_55 * 267.8399963378906f) : (((exp2(((log2((_55 * 59.52080154418945f))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f))))) * 2.4000000953674316f)));
  float _105 = _103 * (exp2(((log2(((((bool)((_58 <= 0.0003024152829311788f))) ? (_58 * 267.8399963378906f) : (((exp2(((log2((_58 * 59.52080154418945f))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f))))) * 2.4000000953674316f)));
  float _106 = _103 * (exp2(((log2(((((bool)((_61 <= 0.0003024152829311788f))) ? (_61 * 267.8399963378906f) : (((exp2(((log2((_61 * 59.52080154418945f))) * 0.44999998807907104f))) * 1.0989999771118164f) + -0.0989999994635582f))))) * 2.4000000953674316f)));
  float _107 = (cb_user_002z) / (cb_user_002y);
  float _108 = (cb_user_002w) - (cb_user_002z);
  float _116 = ((cb_user_002y) / _108) * -1.4426950216293335f;
  float _147 = exp2(((log2((abs((((((bool)((_104 < _107))) ? (_104 * (cb_user_002y)) : ((cb_user_002w) - ((exp2(((_104 - _107) * _116))) * _108)))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _148 = exp2(((log2((abs((((((bool)((_105 < _107))) ? (_105 * (cb_user_002y)) : ((cb_user_002w) - ((exp2(((_105 - _107) * _116))) * _108)))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  float _149 = exp2(((log2((abs((((((bool)((_106 < _107))) ? (_106 * (cb_user_002y)) : ((cb_user_002w) - ((exp2(((_106 - _107) * _116))) * _108)))) * 9.999999747378752e-05f))))) * 0.1593017578125f));
  SV_Target.x = (max((exp2(((log2((((_147 * 18.8515625f) + 0.8359375f) / ((_147 * 18.6875f) + 1.0f)))) * 78.84375f))), 0.078125f));
  SV_Target.y = (max((exp2(((log2((((_148 * 18.8515625f) + 0.8359375f) / ((_148 * 18.6875f) + 1.0f)))) * 78.84375f))), 0.078125f));
  SV_Target.z = (max((exp2(((log2((((_149 * 18.8515625f) + 0.8359375f) / ((_149 * 18.6875f) + 1.0f)))) * 78.84375f))), 0.078125f));
  SV_Target.w = 1.0f;
  return SV_Target;
}
