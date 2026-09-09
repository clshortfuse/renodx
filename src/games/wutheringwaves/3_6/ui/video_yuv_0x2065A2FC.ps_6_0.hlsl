Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float4 YUY2ConvertUB_000[4] : packoffset(c000.x);
  int YUY2ConvertUB_064 : packoffset(c004.x);
  int YUY2ConvertUB_068 : packoffset(c004.y);
  float2 YUY2ConvertUB_072 : packoffset(c004.z);
};

SamplerState s0 : register(s0);

SamplerState s1 : register(s1);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _10;
  float _11;
  float4 _12;
  float4 _15;
  float _42;
  float _43;
  float _44;
  float _47;
  float _50;
  float _53;
  bool _54;
  float _55;
  float _56;
  float _57;
  _10 = YUY2ConvertUB_072.x * TEXCOORD.x;
  _11 = YUY2ConvertUB_072.y * TEXCOORD.y;
  _12 = t0.Sample(s0, float2(_10, _11));
  _15 = t0.Sample(s1, float2(_10, _11));
  _42 = select((floor(fmod((float((uint)(int)(YUY2ConvertUB_064)) * TEXCOORD.x), 2.0f)) == 0.0f), _15.z, _15.x) - (YUY2ConvertUB_000[0].w);
  _43 = _12.y - (YUY2ConvertUB_000[1].w);
  _44 = _12.w - (YUY2ConvertUB_000[2].w);
  _47 = mad((YUY2ConvertUB_000[0].z), _44, mad((YUY2ConvertUB_000[0].y), _43, (_42 * (YUY2ConvertUB_000[0].x))));
  _50 = mad((YUY2ConvertUB_000[1].z), _44, mad((YUY2ConvertUB_000[1].y), _43, ((YUY2ConvertUB_000[1].x) * _42)));
  _53 = mad((YUY2ConvertUB_000[2].z), _44, mad((YUY2ConvertUB_000[2].y), _43, ((YUY2ConvertUB_000[2].x) * _42)));
  _54 = (YUY2ConvertUB_068 == 1);
  _55 = max(6.103519990574569e-05f, _47);
  _56 = max(6.103519990574569e-05f, _50);
  _57 = max(6.103519990574569e-05f, _53);
  SV_Target.x = select(_54, select((_55 > 0.040449999272823334f), exp2(log2((_55 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_55 * 0.07739938050508499f)), _47);
  SV_Target.y = select(_54, select((_56 > 0.040449999272823334f), exp2(log2((_56 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_56 * 0.07739938050508499f)), _50);
  SV_Target.z = select(_54, select((_57 > 0.040449999272823334f), exp2(log2((_57 * 0.9478672742843628f) + 0.05213269963860512f) * 2.4000000953674316f), (_57 * 0.07739938050508499f)), _53);
  SV_Target.w = 1.0f;
  return SV_Target;
}