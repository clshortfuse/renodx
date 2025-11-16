Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float UILevel : packoffset(c007.z);
  float UILuminance : packoffset(c007.w);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float4 _11 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _16 = max(6.103519990574569e-05f, _11.x);
  float _17 = max(6.103519990574569e-05f, _11.y);
  float _18 = max(6.103519990574569e-05f, _11.z);
  float _40 = select((_16 > 0.040449999272823334f), exp2(log2((_16 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_16 * 0.07739938050508499f));
  float _41 = select((_17 > 0.040449999272823334f), exp2(log2((_17 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_17 * 0.07739938050508499f));
  float _42 = select((_18 > 0.040449999272823334f), exp2(log2((_18 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_18 * 0.07739938050508499f));
  float4 _59 = t1.Sample(s1, float2(TEXCOORD.x, TEXCOORD.y));
  float _72 = mad(0.04330150783061981f, _59.z, mad(0.32926714420318604f, _59.y, (_59.x * 0.6274880170822144f))) * 80.0f;
  float _73 = mad(0.011359544470906258f, _59.z, mad(0.9195171594619751f, _59.y, (_59.x * 0.06910824030637741f))) * 80.0f;
  float _74 = mad(0.8954997062683105f, _59.z, mad(0.08802297711372375f, _59.y, (_59.x * 0.016396233811974525f))) * 80.0f;
  float _95;
  float _96;
  float _97;
  if ((bool)(_11.w > 0.0f) && (bool)(_11.w < 1.0f)) {
    float _80 = max(_72, 0.0f);
    float _81 = max(_73, 0.0f);
    float _82 = max(_74, 0.0f);
    float _90 = ((((1.0f / ((dot(float3(_80, _81, _82), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / UILevel) + 1.0f)) * UILevel) + -1.0f) * _11.w) + 1.0f;
    _95 = (_90 * _80);
    _96 = (_90 * _81);
    _97 = (_90 * _82);
  } else {
    _95 = _72;
    _96 = _73;
    _97 = _74;
  }
  float _98 = 1.0f - _11.w;
  float _105 = (_95 * _98) + ((UILuminance * mad(0.04330150783061981f, _42, mad(0.32926714420318604f, _41, (_40 * 0.6274880170822144f)))) * UILevel);
  float _108 = ((_96 * _98) + ((UILuminance * mad(0.011359544470906258f, _42, mad(0.9195171594619751f, _41, (_40 * 0.06910824030637741f)))) * UILevel)) * 0.012500000186264515f;
  float _109 = ((_97 * _98) + ((UILuminance * mad(0.8954997062683105f, _42, mad(0.08802297711372375f, _41, (_40 * 0.016396233811974525f)))) * UILevel)) * 0.012500000186264515f;
  SV_Target.x = mad(-0.07284006476402283f, _109, mad(-0.5876425504684448f, _108, (_105 * 0.020756645128130913f)));
  SV_Target.y = mad(-0.008348364382982254f, _109, mad(1.1329026222229004f, _108, (_105 * -0.001556919887661934f)));
  SV_Target.z = mad(1.11858069896698f, _109, mad(-0.10057909041643143f, _108, (_105 * -0.00022689001343678683f)));
  // SV_Target.w = 1.0f;
  SV_Target.w = _11.w;
  return SV_Target;
}
