Texture2D<float4> texSrc : register(t0);

cbuffer cbSoftBloomSrcResolution : register(b0) {
  float4 cbSoftBloomSrcDimension : packoffset(c000.x);
};

SamplerState BilinearClamp : register(s5, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _10 = cbSoftBloomSrcDimension.x * 0.5f;
  float _11 = cbSoftBloomSrcDimension.y * 0.5f;
  float4 _14 = texSrc.SampleLevel(BilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _18 = TEXCOORD.x - _10;
  float _19 = TEXCOORD.y - _11;
  float4 _20 = texSrc.SampleLevel(BilinearClamp, float2(_18, _19), 0.0f);
  float _24 = _10 + TEXCOORD.x;
  float4 _25 = texSrc.SampleLevel(BilinearClamp, float2(_24, _19), 0.0f);
  float _29 = _11 + TEXCOORD.y;
  float4 _30 = texSrc.SampleLevel(BilinearClamp, float2(_18, _29), 0.0f);
  float4 _34 = texSrc.SampleLevel(BilinearClamp, float2(_24, _29), 0.0f);
  float _53 = TEXCOORD.x - cbSoftBloomSrcDimension.x;
  float4 _54 = texSrc.SampleLevel(BilinearClamp, float2(_53, TEXCOORD.y), 0.0f);
  float _58 = cbSoftBloomSrcDimension.x + TEXCOORD.x;
  float4 _59 = texSrc.SampleLevel(BilinearClamp, float2(_58, TEXCOORD.y), 0.0f);
  float _63 = TEXCOORD.y - cbSoftBloomSrcDimension.y;
  float4 _64 = texSrc.SampleLevel(BilinearClamp, float2(TEXCOORD.x, _63), 0.0f);
  float _68 = cbSoftBloomSrcDimension.y + TEXCOORD.y;
  float4 _69 = texSrc.SampleLevel(BilinearClamp, float2(TEXCOORD.x, _68), 0.0f);
  float4 _88 = texSrc.SampleLevel(BilinearClamp, float2(_53, _63), 0.0f);
  float4 _92 = texSrc.SampleLevel(BilinearClamp, float2(_58, _63), 0.0f);
  float4 _96 = texSrc.SampleLevel(BilinearClamp, float2(_53, _68), 0.0f);
  float4 _100 = texSrc.SampleLevel(BilinearClamp, float2(_58, _68), 0.0f);
  SV_Target.x = ((((((_59.x + _54.x) + (_64.x)) + (_69.x)) * 0.0625f) + (((((_20.x + _14.x) + _25.x) + _30.x) + _34.x) * 0.125f)) + ((((_92.x + _88.x) + (_96.x)) + _100.x) * 0.03125f));
  SV_Target.y = ((((((_59.y + _54.y) + (_64.y)) + (_69.y)) * 0.0625f) + (((((_20.y + _14.y) + _25.y) + _30.y) + _34.y) * 0.125f)) + ((((_92.y + _88.y) + (_96.y)) + _100.y) * 0.03125f));
  SV_Target.z = ((((((_59.z + _54.z) + (_64.z)) + (_69.z)) * 0.0625f) + (((((_20.z + _14.z) + _25.z) + _30.z) + _34.z) * 0.125f)) + ((((_92.z + _88.z) + (_96.z)) + _100.z) * 0.03125f));
  SV_Target.w = 1.0f;
  return SV_Target;
}
