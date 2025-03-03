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
  float4 _25 = SrcTexture.SampleLevel(PointBorder, float2(((((SceneInfo_023x) + -0.5009999871253967f) * (TEXCOORD.x)) * (SceneInfo_023z)), ((((SceneInfo_023y) + -0.5009999871253967f) * (TEXCOORD.y)) * (SceneInfo_023w))), 0.0f);
  float _43 = -0.35844698548316956f;
  float _58;
  float _73;
  if ((!((_25.x) <= 0.0f))) {
    if ((((_25.x) < 3.0517578125e-05f))) {
      _43 = (((log2((((_25.x) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _43 = (((log2((_25.x))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _58 = -0.35844698548316956f;
  if ((!((_25.y) <= 0.0f))) {
    if ((((_25.y) < 3.0517578125e-05f))) {
      _58 = (((log2((((_25.y) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _58 = (((log2((_25.y))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  _73 = -0.35844698548316956f;
  if ((!((_25.z) <= 0.0f))) {
    if ((((_25.z) < 3.0517578125e-05f))) {
      _73 = (((log2((((_25.z) * 0.5f) + 1.52587890625e-05f))) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _73 = (((log2((_25.z))) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  }
  float4 _82 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_43 * 0.984375f) + 0.0078125f), ((_58 * 0.984375f) + 0.0078125f), ((_73 * 0.984375f) + 0.0078125f)), 0.0f);
  SV_Target.x = (_82.x);
  SV_Target.y = (_82.y);
  SV_Target.z = (_82.z);
  SV_Target.w = ((((bool)((((ReadonlyDepth.Load(int3((int(95)), (int(96)), 0))).x) <= 0.0f))) ? 0.0f : 1.0f));
  return SV_Target;
}
