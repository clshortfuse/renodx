// Found in Stellar Blade (HDR10 ini)

#include "./composite.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_010w : packoffset(c010.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position) : SV_Target {
  float4 SV_Target;
  float4 _8 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _13 = max(6.103519990574569e-05f, _8.x);
  float _14 = max(6.103519990574569e-05f, _8.y);
  float _15 = max(6.103519990574569e-05f, _8.z);
  float _37 = select((_13 > 0.040449999272823334f), exp2(log2((_13 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_13 * 0.07739938050508499f));
  float _38 = select((_14 > 0.040449999272823334f), exp2(log2((_14 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_14 * 0.07739938050508499f));
  float _39 = select((_15 > 0.040449999272823334f), exp2(log2((_15 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_15 * 0.07739938050508499f));
  float4 _52 = t1.Sample(s1, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleUICompositing(_8, _52, SV_Target, TEXCOORD.xy, t1, s1)) {
    return SV_Target;
  }

  float _62 = (pow(_52.x, 0.012683313339948654f));
  float _63 = (pow(_52.y, 0.012683313339948654f));
  float _64 = (pow(_52.z, 0.012683313339948654f));
  float _89 = exp2(log2(max(0.0f, (_62 + -0.8359375f)) / (18.8515625f - (_62 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _90 = exp2(log2(max(0.0f, (_63 + -0.8359375f)) / (18.8515625f - (_63 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _91 = exp2(log2(max(0.0f, (_64 + -0.8359375f)) / (18.8515625f - (_64 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  float _113;
  float _114;
  float _115;
  [branch]
  if ((bool)(_8.w > 0.0f) && (bool)(_8.w < 1.0f)) {
    float _96 = max(_89, 0.0f);
    float _97 = max(_90, 0.0f);
    float _98 = max(_91, 0.0f);
    float _108 = (((cb0_010w * (1.0f / ((dot(float3(_96, _97, _98), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / cb0_010w) + 1.0f))) + -1.0f) * _8.w) + 1.0f;
    _113 = (_108 * _96);
    _114 = (_108 * _97);
    _115 = (_108 * _98);
  } else {
    _113 = _89;
    _114 = _90;
    _115 = _91;
  }
  float _116 = 1.0f - _8.w;
  float _137 = exp2(log2((((mad(0.04330150783061981f, _39, mad(0.32926714420318604f, _38, (_37 * 0.6274880170822144f))) * 300.0f) * cb0_010w) + (_113 * _116)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _138 = exp2(log2((((mad(0.011359544470906258f, _39, mad(0.9195171594619751f, _38, (_37 * 0.06910824030637741f))) * 300.0f) * cb0_010w) + (_114 * _116)) * 9.999999747378752e-05f) * 0.1593017578125f);
  float _139 = exp2(log2((((mad(0.8954997062683105f, _39, mad(0.08802297711372375f, _38, (_37 * 0.016396233811974525f))) * 300.0f) * cb0_010w) + (_115 * _116)) * 9.999999747378752e-05f) * 0.1593017578125f);
  SV_Target.x = exp2(log2((1.0f / ((_137 * 18.6875f) + 1.0f)) * ((_137 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.y = exp2(log2((1.0f / ((_138 * 18.6875f) + 1.0f)) * ((_138 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.z = exp2(log2((1.0f / ((_139 * 18.6875f) + 1.0f)) * ((_139 * 18.8515625f) + 0.8359375f)) * 78.84375f);
  SV_Target.w = 1.0f;
  return SV_Target;
}
