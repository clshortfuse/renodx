Texture2D<float4> tTex : register(t0);

Texture3D<float4> SrcLUT : register(t1);

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
  float4 _22 = tTex.Sample(BilinearClamp, float2((((CBImagePlane_002z) * (TEXCOORD.x)) + (CBImagePlane_002x)), (((CBImagePlane_002w) * (TEXCOORD.y)) + (CBImagePlane_002y))));
  float _30 = (CBImagePlane_000x) * (_22.x);
  float _31 = (CBImagePlane_000y) * (_22.y);
  float _32 = (CBImagePlane_000z) * (_22.z);
  float _48;
  float _57;
  float _66;
  float _137 = _30;
  float _138 = _31;
  float _139 = _32;
  float _154;
  float _169;
  float _184;
  if ((((TonemapParam_002w) == 0.0f))) {
    float _40 = (TonemapParam_002y) * _30;
    _48 = 1.0f;
    do {
      if ((!(_30 >= (TonemapParam_000y)))) {
        _48 = ((_40 * _40) * (3.0f - (_40 * 2.0f)));
      }
      float _49 = (TonemapParam_002y) * _31;
      _57 = 1.0f;
      do {
        if ((!(_31 >= (TonemapParam_000y)))) {
          _57 = ((_49 * _49) * (3.0f - (_49 * 2.0f)));
        }
        float _58 = (TonemapParam_002y) * _32;
        _66 = 1.0f;
        do {
          if ((!(_32 >= (TonemapParam_000y)))) {
            _66 = ((_58 * _58) * (3.0f - (_58 * 2.0f)));
          }
          float _75 = (((bool)((_30 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _76 = (((bool)((_31 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          float _77 = (((bool)((_32 < (TonemapParam_001y)))) ? 0.0f : 1.0f);
          _137 = ((((((TonemapParam_000x) * _30) + (TonemapParam_002z)) * (_48 - _75)) + (((exp2(((log2(_40)) * (TonemapParam_000w)))) * (1.0f - _48)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w) * _30) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _75));
          _138 = ((((((TonemapParam_000x) * _31) + (TonemapParam_002z)) * (_57 - _76)) + (((exp2(((log2(_49)) * (TonemapParam_000w)))) * (1.0f - _57)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w) * _31) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _76));
          _139 = ((((((TonemapParam_000x) * _32) + (TonemapParam_002z)) * (_66 - _77)) + (((exp2(((log2(_58)) * (TonemapParam_000w)))) * (1.0f - _66)) * (TonemapParam_000y))) + (((TonemapParam_001x) - ((exp2((((TonemapParam_001w) * _32) + (TonemapParam_002x)))) * (TonemapParam_001z))) * _77));
        } while (false);
      } while (false);
    } while (false);
  }
  _154 = -0.35844698548316956f;
  if ((!(_137 <= 0.0f))) {
    if (((_137 < 3.0517578125e-05f))) {
      _154 = (((log2(((_137 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _154 = (((log2(_137)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _169 = -0.35844698548316956f;
  if ((!(_138 <= 0.0f))) {
    if (((_138 < 3.0517578125e-05f))) {
      _169 = (((log2(((_138 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _169 = (((log2(_138)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _184 = -0.35844698548316956f;
  if ((!(_139 <= 0.0f))) {
    if (((_139 < 3.0517578125e-05f))) {
      _184 = (((log2(((_139 * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _184 = (((log2(_139)) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _193 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_154 * 0.984375f) + 0.0078125f), ((_169 * 0.984375f) + 0.0078125f), ((_184 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = (_193.x);
  SV_Target.y = (_193.y);
  SV_Target.z = (_193.z);
  SV_Target.w = 1.0f;
  return SV_Target;
}
