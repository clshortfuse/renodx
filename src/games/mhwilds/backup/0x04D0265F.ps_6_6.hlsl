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
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _26 = SrcTexture.SampleLevel(PointBorder, float2((1.0f - ((((SceneInfo_023x) + -0.5009999871253967f) * (TEXCOORD.x)) * (SceneInfo_023z))), ((((SceneInfo_023y) + -0.5009999871253967f) * (TEXCOORD.y)) * (SceneInfo_023w))), 0.0f);
  float _44 = -0.35844698548316956f;
  float _59;
  float _74;
  if ((!((_26.x) <= 0.0f))) {
    if ((((_26.x) < 3.0517578125e-05f))) {
      _44 = (((log2((((_26.x) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _44 = (((log2((_26.x))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _59 = -0.35844698548316956f;
  if ((!((_26.y) <= 0.0f))) {
    if ((((_26.y) < 3.0517578125e-05f))) {
      _59 = (((log2((((_26.y) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _59 = (((log2((_26.y))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _74 = -0.35844698548316956f;
  if ((!((_26.z) <= 0.0f))) {
    if ((((_26.z) < 3.0517578125e-05f))) {
      _74 = (((log2((((_26.z) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _74 = (((log2((_26.z))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _83 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_44 * 0.984375f) + 0.0078125f), ((_59 * 0.984375f) + 0.0078125f), ((_74 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = (_83.x);
  SV_Target.y = (_83.y);
  SV_Target.z = (_83.z);
  SV_Target.w = ((((bool)((((ReadonlyDepth.Load(int3((int(96)), (int(97)), 0))).x) <= 0.0f))) ? 0.0f : 1.0f));
  return SV_Target;
}
