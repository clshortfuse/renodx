Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> SrcTexture : register(t1);

Texture3D<float4> SrcLUT : register(t2);

cbuffer SceneInfo : register(b0) {
  float SceneInfo_023x : packoffset(c023.x);
  float SceneInfo_023y : packoffset(c023.y);
  float SceneInfo_023z : packoffset(c023.z);
  float SceneInfo_023w : packoffset(c023.w);
};

cbuffer ImageSizeInfo : register(b1) {
  float ImageSizeInfo_000x : packoffset(c000.x);
  float ImageSizeInfo_000y : packoffset(c000.y);
  float ImageSizeInfo_001x : packoffset(c001.x);
  float ImageSizeInfo_001y : packoffset(c001.y);
  float ImageSizeInfo_001z : packoffset(c001.z);
  float ImageSizeInfo_001w : packoffset(c001.w);
  float ImageSizeInfo_002x : packoffset(c002.x);
  uint ImageSizeInfo_002y : packoffset(c002.y);
};

cbuffer OCIOTransformMatrix : register(b2) {
  float OCIOTransformMatrix_000x : packoffset(c000.x);
  float OCIOTransformMatrix_000y : packoffset(c000.y);
  float OCIOTransformMatrix_000z : packoffset(c000.z);
  float OCIOTransformMatrix_001x : packoffset(c001.x);
  float OCIOTransformMatrix_001y : packoffset(c001.y);
  float OCIOTransformMatrix_001z : packoffset(c001.z);
  float OCIOTransformMatrix_002x : packoffset(c002.x);
  float OCIOTransformMatrix_002y : packoffset(c002.y);
  float OCIOTransformMatrix_002z : packoffset(c002.z);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _27 = SrcTexture.SampleLevel(PointBorder, float2(((((SceneInfo_023x) + -0.5009999871253967f) * (TEXCOORD.x)) * (SceneInfo_023z)), ((((SceneInfo_023y) + -0.5009999871253967f) * (TEXCOORD.y)) * (SceneInfo_023w))), 0.0f);
  float _45 = -0.35844698548316956f;
  float _60;
  float _75;
  float _168;
  if ((!((_27.x) <= 0.0f))) {
    if ((((_27.x) < 3.0517578125e-05f))) {
      _45 = (((log2((((_27.x) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _45 = (((log2((_27.x))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _60 = -0.35844698548316956f;
  if ((!((_27.y) <= 0.0f))) {
    if ((((_27.y) < 3.0517578125e-05f))) {
      _60 = (((log2((((_27.y) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _60 = (((log2((_27.y))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _75 = -0.35844698548316956f;
  if ((!((_27.z) <= 0.0f))) {
    if ((((_27.z) < 3.0517578125e-05f))) {
      _75 = (((log2((((_27.z) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _75 = (((log2((_27.z))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _84 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_45 * 0.984375f) + 0.0078125f), ((_60 * 0.984375f) + 0.0078125f), ((_75 * 0.984375f) + 0.0078125f)), 0.0f);
  float _118 = mad((_27.z), (OCIOTransformMatrix_002x), (mad((_27.y), (OCIOTransformMatrix_001x), ((OCIOTransformMatrix_000x) * (_27.x)))));
  float _121 = mad((_27.z), (OCIOTransformMatrix_002y), (mad((_27.y), (OCIOTransformMatrix_001y), ((OCIOTransformMatrix_000y) * (_27.x)))));
  float _124 = mad((_27.z), (OCIOTransformMatrix_002z), (mad((_27.y), (OCIOTransformMatrix_001z), ((OCIOTransformMatrix_000z) * (_27.x)))));
  float _131 = ((dot(float3(_118, _121, _124), float3(-0.14800000190734863f, -0.29100000858306885f, 0.49300000071525574f))) + 0.5f) - (ImageSizeInfo_001y);
  float _134 = (0.5f - (ImageSizeInfo_001z)) + (dot(float3(_118, _121, _124), float3(0.4390000104904175f, -0.36800000071525574f, -0.07100000232458115f)));
  float _137 = sqrt(((_131 * _131) + (_134 * _134)));
  if (!(((((uint)(ImageSizeInfo_002y)) & 1) == 0))) {
    float _159 = saturate((saturate(((((((bool)(((((uint)(ImageSizeInfo_002y)) & 2) != 0))) ? ((min((abs((((ImageSizeInfo_001x) + -0.0625f) - (dot(float3(_118, _121, _124), float3(0.25699999928474426f, 0.5040000081062317f, 0.09799999743700027f)))))), 1.0f)) + _137) : _137)) - (ImageSizeInfo_001w)) * (ImageSizeInfo_002x)))));
    _168 = ((_159 * _159) * (3.0f - (_159 * 2.0f)));
  } else {
    _168 = ((((bool)((_137 < (ImageSizeInfo_001w)))) ? 0.0f : 1.0f));
  }
  SV_Target.x = (_84.x);
  SV_Target.y = (_84.y);
  SV_Target.z = (_84.z);
  SV_Target.w = (max(((((bool)((((ReadonlyDepth.Load(int3((int(97)), (int(98)), 0))).x) <= 0.0f))) ? 0.0f : 1.0f)), _168));
  return SV_Target;
}
