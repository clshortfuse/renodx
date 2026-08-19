// Yakuza 3 final

#include "./common.hlsl"

Texture2D<float4> s0_t : register(t0);

cbuffer cb_user : register(b9) {
  float c_scale : packoffset(c000.x);
  float c_gamma : packoffset(c000.y);
  uint c_tv_gamma_mode : packoffset(c001.y);
  float c_paper_white_nits : packoffset(c002.x);
  float c_tonemap_exposure_scale : packoffset(c002.y);
  float c_tonemap_shoulder_level : packoffset(c002.z);
  float c_tonemap_max_level : packoffset(c002.w);
  float4 c_d65_d93_mtx[4] : packoffset(c003.x);
};

SamplerState s0_s : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float4 _6 = s0_t.Sample(s0_s, float2(TEXCOORD.x, TEXCOORD.y));

  if (injectedData.toneMapType != 0.f) {
    float3 color = ProcessColor(_6.rgb);
    SV_Target.xyz = color.rgb;
    SV_Target.w = 1.f;
    return SV_Target;
  }

  float _43 = 1.0f / c_scale;
  float _50 = exp2(log2(exp2(log2(select((((bool)(!(_6.x == 0.0f))) && (bool)((uint)asint(abs(_6.x)) > (uint)2139095040)), 0.0f, max(0.0f, _6.x))) * c_gamma)) * _43);
  float _51 = exp2(log2(exp2(log2(select((((bool)(!(_6.y == 0.0f))) && (bool)((uint)asint(abs(_6.y)) > (uint)2139095040)), 0.0f, max(0.0f, _6.y))) * c_gamma)) * _43);
  float _52 = exp2(log2(exp2(log2(select((((bool)(!(_6.z == 0.0f))) && (bool)((uint)asint(abs(_6.z)) > (uint)2139095040)), 0.0f, max(0.0f, _6.z))) * c_gamma)) * _43);
  float _55 = mad(0.043299127370119095f, _52, mad(0.32924848794937134f, _51, (_50 * 0.6274523735046387f)));
  float _58 = mad(0.011359736323356628f, _52, mad(0.9195311069488525f, _51, (_50 * 0.06910918653011322f)));
  float _61 = mad(0.895572304725647f, _52, mad(0.0880301371216774f, _51, (_50 * 0.016397561877965927f)));
  float _103 = c_paper_white_nits * 0.009999999776482582f;
  float _104 = _103 * exp2(log2(select((_55 <= 0.0003024152829311788f), (_55 * 267.8399963378906f), ((exp2(log2(_55 * 59.52080154418945f) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f))) * 2.4000000953674316f);
  float _105 = _103 * exp2(log2(select((_58 <= 0.0003024152829311788f), (_58 * 267.8399963378906f), ((exp2(log2(_58 * 59.52080154418945f) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f))) * 2.4000000953674316f);
  float _106 = _103 * exp2(log2(select((_61 <= 0.0003024152829311788f), (_61 * 267.8399963378906f), ((exp2(log2(_61 * 59.52080154418945f) * 0.44999998807907104f) * 1.0989999771118164f) + -0.0989999994635582f))) * 2.4000000953674316f);
  float _107 = c_tonemap_shoulder_level / c_tonemap_exposure_scale;
  float _108 = c_tonemap_max_level - c_tonemap_shoulder_level;
  float _116 = (c_tonemap_exposure_scale / _108) * -1.4426950216293335f;
  float _147 = exp2(log2(abs(select((_104 < _107), (_104 * c_tonemap_exposure_scale), (c_tonemap_max_level - (exp2((_104 - _107) * _116) * _108))) * 9.999999747378752e-05f)) * 0.1593017578125f);
  float _148 = exp2(log2(abs(select((_105 < _107), (_105 * c_tonemap_exposure_scale), (c_tonemap_max_level - (exp2((_105 - _107) * _116) * _108))) * 9.999999747378752e-05f)) * 0.1593017578125f);
  float _149 = exp2(log2(abs(select((_106 < _107), (_106 * c_tonemap_exposure_scale), (c_tonemap_max_level - (exp2((_106 - _107) * _116) * _108))) * 9.999999747378752e-05f)) * 0.1593017578125f);
  SV_Target.x = exp2(log2(((_147 * 18.8515625f) + 0.8359375f) / ((_147 * 18.6875f) + 1.0f)) * 78.84375f);
  SV_Target.y = exp2(log2(((_148 * 18.8515625f) + 0.8359375f) / ((_148 * 18.6875f) + 1.0f)) * 78.84375f);
  SV_Target.z = exp2(log2(((_149 * 18.8515625f) + 0.8359375f) / ((_149 * 18.6875f) + 1.0f)) * 78.84375f);
  SV_Target.w = 1.0f;
  return SV_Target;
}
