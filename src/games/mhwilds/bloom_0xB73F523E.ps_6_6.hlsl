Texture2D<float4> texSrc : register(t0);

cbuffer RangeCompressInfo : register(b0) {
  float RangeCompressInfo_000x : packoffset(c000.x);
  float RangeCompressInfo_000y : packoffset(c000.y);
};

cbuffer cbSoftBloom : register(b1) {
  float cbSoftBloom_000w : packoffset(c000.w);
};

cbuffer cbSoftBloomSrcResolution : register(b2) {
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
  float _15 = (cbSoftBloomSrcResolution_000x) * 0.5f;
  float _16 = (cbSoftBloomSrcResolution_000y) * 0.5f;
  float4 _19 = texSrc.SampleLevel(BilinearClamp, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _25 = (TEXCOORD.x) - _15;
  float _26 = (TEXCOORD.y) - _16;
  float4 _27 = texSrc.SampleLevel(BilinearClamp, float2(_25, _26), 0.0f);
  float _31 = _15 + (TEXCOORD.x);
  float4 _32 = texSrc.SampleLevel(BilinearClamp, float2(_31, _26), 0.0f);
  float _36 = _16 + (TEXCOORD.y);
  float4 _37 = texSrc.SampleLevel(BilinearClamp, float2(_25, _36), 0.0f);
  float4 _41 = texSrc.SampleLevel(BilinearClamp, float2(_31, _36), 0.0f);
  float _45 = (TEXCOORD.x) - (cbSoftBloomSrcResolution_000x);
  float4 _46 = texSrc.SampleLevel(BilinearClamp, float2(_45, (TEXCOORD.y)), 0.0f);
  float _50 = (cbSoftBloomSrcResolution_000x) + (TEXCOORD.x);
  float4 _51 = texSrc.SampleLevel(BilinearClamp, float2(_50, (TEXCOORD.y)), 0.0f);
  float _55 = (TEXCOORD.y) - (cbSoftBloomSrcResolution_000y);
  float4 _56 = texSrc.SampleLevel(BilinearClamp, float2((TEXCOORD.x), _55), 0.0f);
  float _60 = (cbSoftBloomSrcResolution_000y) + (TEXCOORD.y);
  float4 _61 = texSrc.SampleLevel(BilinearClamp, float2((TEXCOORD.x), _60), 0.0f);
  float4 _65 = texSrc.SampleLevel(BilinearClamp, float2(_45, _55), 0.0f);
  float4 _69 = texSrc.SampleLevel(BilinearClamp, float2(_50, _55), 0.0f);
  float4 _73 = texSrc.SampleLevel(BilinearClamp, float2(_45, _60), 0.0f);
  float4 _77 = texSrc.SampleLevel(BilinearClamp, float2(_50, _60), 0.0f);
  float _88 = (RangeCompressInfo_000y) * ((((_32.x) + (_27.x)) + (_37.x)) + (_41.x));
  float _90 = (RangeCompressInfo_000y) * ((((_32.y) + (_27.y)) + (_37.y)) + (_41.y));
  float _92 = (RangeCompressInfo_000y) * ((((_32.z) + (_27.z)) + (_37.z)) + (_41.z));
  float _96 = 1.0f / ((max((max(_88, _90)), _92)) + 1.0f);
  float _103 = (_46.x) + (_19.x);
  float _106 = (RangeCompressInfo_000y) * ((_103 + (_56.x)) + (_65.x));
  float _107 = (_46.y) + (_19.y);
  float _110 = (RangeCompressInfo_000y) * ((_107 + (_56.y)) + (_65.y));
  float _111 = (_46.z) + (_19.z);
  float _114 = (RangeCompressInfo_000y) * ((_111 + (_56.z)) + (_65.z));
  float _118 = 1.0f / ((max((max(_106, _110)), _114)) + 1.0f);
  float _123 = (_51.x) + (_19.x);
  float _126 = (RangeCompressInfo_000y) * ((_123 + (_56.x)) + (_69.x));
  float _127 = (_51.y) + (_19.y);
  float _130 = (RangeCompressInfo_000y) * ((_127 + (_56.y)) + (_69.y));
  float _131 = (_51.z) + (_19.z);
  float _134 = (RangeCompressInfo_000y) * ((_131 + (_56.z)) + (_69.z));
  float _138 = 1.0f / ((max((max(_126, _130)), _134)) + 1.0f);
  float _145 = (RangeCompressInfo_000y) * ((_103 + (_61.x)) + (_73.x));
  float _148 = (RangeCompressInfo_000y) * ((_107 + (_61.y)) + (_73.y));
  float _151 = (RangeCompressInfo_000y) * ((_111 + (_61.z)) + (_73.z));
  float _155 = 1.0f / ((max((max(_145, _148)), _151)) + 1.0f);
  float _164 = (RangeCompressInfo_000y) * ((_123 + (_61.x)) + (_77.x));
  float _166 = (RangeCompressInfo_000y) * ((_127 + (_61.y)) + (_77.y));
  float _168 = (RangeCompressInfo_000y) * ((_131 + (_61.z)) + (_77.z));
  float _172 = 1.0f / ((max((max(_164, _166)), _168)) + 1.0f);
  float _191 = (((_118 + _96) + _138) + _155) + _172;
  float _195 = (((((((_138 * _126) + (_118 * _106)) + (_155 * _145)) + (_172 * _164)) * 0.125f) + ((_88 * 0.5f) * _96)) / _191) * (EXPOSURE);
  float _196 = (((((((_138 * _130) + (_118 * _110)) + (_155 * _148)) + (_172 * _166)) * 0.125f) + ((_90 * 0.5f) * _96)) / _191) * (EXPOSURE);
  float _197 = (((((((_138 * _134) + (_118 * _114)) + (_155 * _151)) + (_172 * _168)) * 0.125f) + ((_92 * 0.5f) * _96)) / _191) * (EXPOSURE);
  float _203 = saturate(((max((max(_195, _196)), _197)) / (cbSoftBloom_000w)));
  SV_Target.x = ((_203 * _195) * (RangeCompressInfo_000x));
  SV_Target.y = ((_203 * _196) * (RangeCompressInfo_000x));
  SV_Target.z = ((_203 * _197) * (RangeCompressInfo_000x));
  SV_Target.w = 1.0f;
  return SV_Target;
}
