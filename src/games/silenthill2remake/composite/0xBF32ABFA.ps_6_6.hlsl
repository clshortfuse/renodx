Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float UILevel : packoffset(c007.z);
  float UILuminance : packoffset(c007.w);
};

SamplerState s0 : register(s0);

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float4 _10 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _15 = max(6.103519990574569e-05f, _10.x);
  float _16 = max(6.103519990574569e-05f, _10.y);
  float _17 = max(6.103519990574569e-05f, _10.z);
  float _39 = select((_15 > 0.040449999272823334f), exp2(log2((_15 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_15 * 0.07739938050508499f));
  float _40 = select((_16 > 0.040449999272823334f), exp2(log2((_16 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_16 * 0.07739938050508499f));
  float _41 = select((_17 > 0.040449999272823334f), exp2(log2((_17 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_17 * 0.07739938050508499f));
  float4 _57 = t1.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  float _70 = mad(0.04330150783061981f, _57.z, mad(0.32926714420318604f, _57.y, (_57.x * 0.6274880170822144f))) * 80.0f;
  float _71 = mad(0.011359544470906258f, _57.z, mad(0.9195171594619751f, _57.y, (_57.x * 0.06910824030637741f))) * 80.0f;
  float _72 = mad(0.8954997062683105f, _57.z, mad(0.08802297711372375f, _57.y, (_57.x * 0.016396233811974525f))) * 80.0f;
  float _93;
  float _94;
  float _95;
  if ((bool)(_10.w > 0.0f) && (bool)(_10.w < 1.0f)) {
    float _78 = max(_70, 0.0f);
    float _79 = max(_71, 0.0f);
    float _80 = max(_72, 0.0f);
    float _88 = ((((1.0f / ((dot(float3(_78, _79, _80), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / UILevel) + 1.0f)) * UILevel) + -1.0f) * _10.w) + 1.0f;
    _93 = (_88 * _78);
    _94 = (_88 * _79);
    _95 = (_88 * _80);
  } else {
    _93 = _70;
    _94 = _71;
    _95 = _72;
  }
  float _96 = 1.0f - _10.w;
  SV_Target.x = (((_93 * _96) + ((UILuminance * mad(0.04330150783061981f, _41, mad(0.32926714420318604f, _40, (_39 * 0.6274880170822144f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.y = (((_94 * _96) + ((UILuminance * mad(0.011359544470906258f, _41, mad(0.9195171594619751f, _40, (_39 * 0.06910824030637741f)))) * UILevel)) * 0.012500000186264515f);
  SV_Target.z = (((_95 * _96) + ((UILuminance * mad(0.8954997062683105f, _41, mad(0.08802297711372375f, _40, (_39 * 0.016396233811974525f)))) * UILevel)) * 0.012500000186264515f);
  // SV_Target.w = 1.0f;
  SV_Target.w = _10.w;

  return SV_Target;
}
