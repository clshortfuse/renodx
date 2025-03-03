Texture2D<float4> SrcTexture : register(t0);

Texture3D<float4> SrcLUT : register(t1);

cbuffer HDRMapping : register(b0) {
  float HDRMapping_000x : packoffset(c000.x);
  float HDRMapping_000y : packoffset(c000.y);
};

cbuffer OCIOTransformMatrix : register(b1) {
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

SamplerState PointClamp : register(s1, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = SrcTexture.SampleLevel(PointClamp, float2((TEXCOORD.x), (TEXCOORD.y)), 0.0f);
  float _20 = (HDRMapping_000y) * (_13.w);
  float _63;
  float _78;
  float _93;
  float _107 = (_13.x);
  float _108 = (_13.y);
  float _109 = (_13.z);
  if (((_20 > 0.0f))) {
    float _24 = (HDRMapping_000x) * 0.009999999776482582f;
    float _25 = _24 * (_13.x);
    float _26 = _24 * (_13.y);
    float _27 = _24 * (_13.z);
    float _42 = mad(_27, (OCIOTransformMatrix_002x), (mad(_26, (OCIOTransformMatrix_001x), (_25 * (OCIOTransformMatrix_000x)))));
    float _45 = mad(_27, (OCIOTransformMatrix_002y), (mad(_26, (OCIOTransformMatrix_001y), (_25 * (OCIOTransformMatrix_000y)))));
    float _48 = mad(_27, (OCIOTransformMatrix_002z), (mad(_26, (OCIOTransformMatrix_001z), (_25 * (OCIOTransformMatrix_000z)))));
    _63 = -0.35844698548316956f;
    do {
      if ((!(_42 <= 0.0f))) {
        if (((_42 < 3.0517578125e-05f))) {
          _63 = (((log2(((_42 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
        } else {
          _63 = (((log2(_42)) * 0.05707760155200958f) + 0.5547950267791748f);
        }
      }
      _78 = -0.35844698548316956f;
      do {
        if ((!(_45 <= 0.0f))) {
          if (((_45 < 3.0517578125e-05f))) {
            _78 = (((log2(((_45 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
          } else {
            _78 = (((log2(_45)) * 0.05707760155200958f) + 0.5547950267791748f);
          }
        }
        _93 = -0.35844698548316956f;
        do {
          if ((!(_48 <= 0.0f))) {
            if (((_48 < 3.0517578125e-05f))) {
              _93 = (((log2(((_48 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
            } else {
              _93 = (((log2(_48)) * 0.05707760155200958f) + 0.5547950267791748f);
            }
          }
          float4 _102 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_63 * 0.984375f) + 0.0078125f), ((_78 * 0.984375f) + 0.0078125f), ((_93 * 0.984375f) + 0.0078125f)), 0.0f);
          _107 = (_102.x);
          _108 = (_102.y);
          _109 = (_102.z);
        } while (false);
      } while (false);
    } while (false);
  }
  SV_Target.x = _107;
  SV_Target.y = _108;
  SV_Target.z = _109;
  SV_Target.w = _20;
  return SV_Target;
}
