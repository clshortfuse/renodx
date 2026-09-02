#include "./composite.hlsli"

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

cbuffer cb0 : register(b0) {
  float cb0_002x : packoffset(c002.x);
  float cb0_002y : packoffset(c002.y);
};

SamplerState s0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float4 main(
    noperspective float2 TEXCOORD: TEXCOORD,
    precise noperspective float4 SV_Position: SV_Position)
    : SV_Target {
  float4 SV_Target;
  float4 _10;
  float _15;
  float _16;
  float _17;
  float _39;
  float _40;
  float _41;
  float4 _57;
  float _67;
  float _68;
  float _69;
  float _94;
  float _95;
  float _96;
  float _117;
  float _118;
  float _119;
  float _102;
  float _103;
  float _104;
  float _112;
  float _120;
  _10 = t0.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));
  _57 = t1.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));

  if (HandleIntermediateCompositing(_10, _57, SV_Target)) {
    return SV_Target;
  }

  _15 = max(6.103519990574569e-05f, _10.x);
  _16 = max(6.103519990574569e-05f, _10.y);
  _17 = max(6.103519990574569e-05f, _10.z);
  _39 = select((_15 > 0.040449999272823334f), exp2(log2((_15 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_15 * 0.07739938050508499f));
  _40 = select((_16 > 0.040449999272823334f), exp2(log2((_16 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_16 * 0.07739938050508499f));
  _41 = select((_17 > 0.040449999272823334f), exp2(log2((_17 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_17 * 0.07739938050508499f));
  _67 = (pow(_57.x, 0.012683313339948654f));
  _68 = (pow(_57.y, 0.012683313339948654f));
  _69 = (pow(_57.z, 0.012683313339948654f));
  _94 = exp2(log2(max(0.0f, (_67 + -0.8359375f)) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  _95 = exp2(log2(max(0.0f, (_68 + -0.8359375f)) / (18.8515625f - (_68 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  _96 = exp2(log2(max(0.0f, (_69 + -0.8359375f)) / (18.8515625f - (_69 * 18.6875f))) * 6.277394771575928f) * 10000.0f;
  if ((_10.w > 0.0f) && (_10.w < 1.0f)) {
    _102 = max(_94, 0.0f);
    _103 = max(_95, 0.0f);
    _104 = max(_96, 0.0f);
    _112 = ((((1.0f / ((dot(float3(_102, _103, _104), float3(0.26269999146461487f, 0.6779999732971191f, 0.059300001710653305f)) / cb0_002x) + 1.0f)) * cb0_002x) + -1.0f) * _10.w) + 1.0f;
    _117 = (_112 * _102);
    _118 = (_112 * _103);
    _119 = (_112 * _104);
  } else {
    _117 = _94;
    _118 = _95;
    _119 = _96;
  }
  _120 = 1.0f - _10.w;
  SV_Target.x = (((_117 * _120) + ((cb0_002y * mad(0.043313056230545044f, _41, mad(0.3292830288410187f, _40, (_39 * 0.6274039149284363f)))) * cb0_002x)) * 0.012500000186264515f);
  SV_Target.y = (((_118 * _120) + ((cb0_002y * mad(0.011362319812178612f, _41, mad(0.919540286064148f, _40, (_39 * 0.06909731030464172f)))) * cb0_002x)) * 0.012500000186264515f);
  SV_Target.z = (((_119 * _120) + ((cb0_002y * mad(0.8955953121185303f, _41, mad(0.08801331371068954f, _40, (_39 * 0.016391439363360405f)))) * cb0_002x)) * 0.012500000186264515f);
  SV_Target.w = 1.0f;
  return SV_Target;
}
