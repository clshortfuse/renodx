Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> tTex : register(t1);

Texture3D<float4> SrcLUT : register(t2);

cbuffer TonemapParam : register(b0) {
  float TonemapParam_000x : packoffset(c000.x);
  float TonemapParam_000y : packoffset(c000.y);
  float TonemapParam_000w : packoffset(c000.w);
  float TonemapParam_001x : packoffset(c001.x);
  float TonemapParam_001y : packoffset(c001.y);
  float TonemapParam_001z : packoffset(c001.z);
  float TonemapParam_001w : packoffset(c001.w);
  float TonemapParam_002x : packoffset(c002.x);
  float TonemapParam_002y : packoffset(c002.y);
  float TonemapParam_002z : packoffset(c002.z);
  float TonemapParam_002w : packoffset(c002.w);
};

cbuffer CBImagePlane : register(b1) {
  float CBImagePlane_000x : packoffset(c000.x);
  float CBImagePlane_000y : packoffset(c000.y);
  float CBImagePlane_000z : packoffset(c000.z);
  float CBImagePlane_001x : packoffset(c001.x);
  float CBImagePlane_001y : packoffset(c001.y);
  float CBImagePlane_002x : packoffset(c002.x);
  float CBImagePlane_002y : packoffset(c002.y);
  float CBImagePlane_002z : packoffset(c002.z);
  float CBImagePlane_002w : packoffset(c002.w);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _25 = tTex.Sample(BilinearClamp, float2((((CBImagePlane_002z) * (TEXCOORD.x)) + (CBImagePlane_002x)), (((CBImagePlane_002w) * (TEXCOORD.y)) + (CBImagePlane_002y))));
  float _33 = (CBImagePlane_000x) * (_25.x);
  float _34 = (CBImagePlane_000y) * (_25.y);
  float _35 = (CBImagePlane_000z) * (_25.z);
  float _51;
  float _60;
  float _69;
  float _140 = _33;
  float _141 = _34;
  float _142 = _35;
  float _157;
  float _172;
  float _187;
  if ((((TonemapParam_002w) == 0.0f))) {
    float _43 = (TonemapParam_002y) * _33;
    _51 = 1.0f;
    do {
      if ((!(_33 >= (TonemapParam_000y)))) {
        _51 = ((_43 * _43) * (3.0f - (_43 * 2.0f)));
      }
      float _52 = (TonemapParam_002y) * _34;
      _60 = 1.0f;
      do {
        if ((!(_34 >= (TonemapParam_000y)))) {
          _60 = ((_52 * _52) * (3.0f - (_52 * 2.0f)));
        }
        float _61 = (TonemapParam_002y) * _35;
        _69 = 1.0f;
        do {
          if ((!(_35 >= (TonemapParam_000y)))) {
            _69 = ((_61 * _61) * (3.0f - (_61 * 2.0f)));
          }
          float _78 = (((bool)((_33 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _79 = (((bool)((_34 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _80 = (((bool)((_35 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          _140 = ((((((TonemapParam_000x) * _33) + (TonemapParam_002z)) * (_51 - _78)) + (((exp2(((log2(_43)) * (TonemapParam_000w)))) * (1.0f - _51)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w) * _33) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _78));
          _141 = ((((((TonemapParam_000x) * _34) + (TonemapParam_002z)) * (_60 - _79)) + (((exp2(((log2(_52)) * (TonemapParam_000w)))) * (1.0f - _60)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w) * _34) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _79));
          _142 = ((((((TonemapParam_000x) * _35) + (TonemapParam_002z)) * (_69 - _80)) + (((exp2(((log2(_61)) * (TonemapParam_000w)))) * (1.0f - _69)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w) * _35) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _80));
        } while (false);
      } while (false);
    } while (false);
  }
  _157 = -0.35844698548316956f;
  if ((!(_140 <= 0.0f))) {
    if (((_140 < 3.0517578125e-05f))) {
      _157 = (((log2(((_140 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _157 = (((log2(_140)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _172 = -0.35844698548316956f;
  if ((!(_141 <= 0.0f))) {
    if (((_141 < 3.0517578125e-05f))) {
      _172 = (((log2(((_141 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _172 = (((log2(_141)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _187 = -0.35844698548316956f;
  if ((!(_142 <= 0.0f))) {
    if (((_142 < 3.0517578125e-05f))) {
      _187 = (((log2(((_142 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _187 = (((log2(_142)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _196 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_157 * 0.984375f) + 0.0078125f), ((_172 * 0.984375f) + 0.0078125f), ((_187 * 0.984375f) + 0.0078125f)), 0.0f);
  uint2 _201; ReadonlyDepth.GetDimensions(_201.x, _201.y);
  SV_Target.x = (_196.x);
  SV_Target.y = (_196.y);
  SV_Target.z = (_196.z);
  SV_Target.w = ((((bool)((((ReadonlyDepth.Load(int3((int(213)), (int(214)), 0))).x) <= 0.0f))) ? 0.0f : 1.0f));
  return SV_Target;
}
