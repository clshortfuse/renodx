Texture2D<float4> texSrc : register(t0);

cbuffer RangeCompressInfo : register(b0) {
  float RangeCompressInfo_000x : packoffset(c000.x);
  float RangeCompressInfo_000y : packoffset(c000.y);
};

cbuffer cbSoftBloom : register(b1) {
  float cbSoftBloom_001w : packoffset(c001.w);
};

cbuffer cbCone : register(b2) {
  float cbCone_000x : packoffset(c000.x);
  float cbCone_000y : packoffset(c000.y);
};

cbuffer cbSoftBloomScale : register(b3) {
  float cbSoftBloomScale_000x : packoffset(c000.x);
  float cbSoftBloomScale_000y : packoffset(c000.y);
};

cbuffer cbSoftBloomSrcResolution : register(b4) {
  float cbSoftBloomSrcResolution_000x : packoffset(c000.x);
  float cbSoftBloomSrcResolution_000y : packoffset(c000.y);
};

SamplerState BilinearClamp : register(s5, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float EXPOSURE : EXPOSURE
) : SV_Target {
  float4 SV_Target;
  float _27 = ((cbSoftBloomScale_000x) * (cbSoftBloomSrcResolution_000x)) * (cbCone_000x);
  float _28 = ((cbSoftBloomScale_000y) * (cbSoftBloomSrcResolution_000y)) * (cbCone_000y);
  float _29 = (TEXCOORD.x) - _27;
  float _30 = (TEXCOORD.y) - _28;
  float4 _33 = texSrc.SampleLevel(BilinearClamp, float2(_29, _30), 0.0f);
  float4 _37 = texSrc.SampleLevel(BilinearClamp, float2((TEXCOORD.x), _30), 0.0f);
  float _41 = _27 + (TEXCOORD.x);
  float4 _42 = texSrc.SampleLevel(BilinearClamp, float2(_41, _30), 0.0f);
  float4 _46 = texSrc.SampleLevel(BilinearClamp, float2(_29, (TEXCOORD.y)), 0.0f);
  float4 _50 = texSrc.SampleLevel(BilinearClamp, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float4 _54 = texSrc.SampleLevel(BilinearClamp, float2(_41, (TEXCOORD.y)), 0.0f);
  float _58 = _28 + (TEXCOORD.y);
  float4 _59 = texSrc.SampleLevel(BilinearClamp, float2(_29, _58), 0.0f);
  float4 _63 = texSrc.SampleLevel(BilinearClamp, float2((TEXCOORD.x), _58), 0.0f);
  float4 _67 = texSrc.SampleLevel(BilinearClamp, float2(_41, _58), 0.0f);
  float _105 = 1.0f / (EXPOSURE);
  float _107 = (RangeCompressInfo_000y) * 0.0625f;
  SV_Target.x = ((((_107 * ((((((_42.x) + (_33.x)) + ((_50.x) * 4.0f)) + (_59.x)) + (_67.x)) + (((((_46.x) + (_37.x)) + (_54.x)) + (_63.x)) * 2.0f))) * (cbSoftBloom_001w)) * _105) * (RangeCompressInfo_000x));
  SV_Target.y = ((((_107 * ((((((_42.y) + (_33.y)) + ((_50.y) * 4.0f)) + (_59.y)) + (_67.y)) + (((((_46.y) + (_37.y)) + (_54.y)) + (_63.y)) * 2.0f))) * (cbSoftBloom_001w)) * _105) * (RangeCompressInfo_000x));
  SV_Target.z = ((((_107 * ((((((_42.z) + (_33.z)) + ((_50.z) * 4.0f)) + (_59.z)) + (_67.z)) + (((((_46.z) + (_37.z)) + (_54.z)) + (_63.z)) * 2.0f))) * (cbSoftBloom_001w)) * _105) * (RangeCompressInfo_000x));
  SV_Target.w = 1.0f;
  return SV_Target;
}
