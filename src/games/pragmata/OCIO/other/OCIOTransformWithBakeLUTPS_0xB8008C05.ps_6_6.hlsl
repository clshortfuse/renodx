#include "../OCIO.hlsli"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> SrcTexture : register(t1);

Texture3D<float4> SrcLUT : register(t2);

cbuffer SceneInfo : register(b0) {
  row_major float4x4 viewProjMat : packoffset(c000.x);
  row_major float3x4 transposeViewMat : packoffset(c004.x);
  row_major float3x4 transposeViewInvMat : packoffset(c007.x);
  float4 projElement[2] : packoffset(c010.x);
  float4 projInvElements[2] : packoffset(c012.x);
  row_major float4x4 viewProjInvMat : packoffset(c014.x);
  row_major float4x4 prevViewProjMat : packoffset(c018.x);
  float3 ZToLinear : packoffset(c022.x);
  float subdivisionLevel : packoffset(c022.w);
  float2 screenSize : packoffset(c023.x);
  float2 screenInverseSize : packoffset(c023.z);
  float2 cullingHelper : packoffset(c024.x);
  float cameraNearPlane : packoffset(c024.z);
  float cameraFarPlane : packoffset(c024.w);
  float4 viewFrustum[8] : packoffset(c025.x);
  float4 clipplane : packoffset(c033.x);
  float2 vrsVelocityThreshold : packoffset(c034.x);
  uint GPUVisibleMask : packoffset(c034.z);
  uint resolutionRatioPacked : packoffset(c034.w);
  float3 worldOffset : packoffset(c035.x);
  uint sceneInfoMisc : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float tessellationParam : packoffset(c038.z);
  uint sceneInfoAdditionalFlags : packoffset(c038.w);
};

cbuffer ImageSizeInfo : register(b1) {
  float2 readOnlyDepthSize : packoffset(c000.x);
  float2 reserve : packoffset(c000.z);
  float4 chromaKeyColor : packoffset(c001.x);
  float chromaKeyWeightMultiplier : packoffset(c002.x);
  uint chromaKeySetting : packoffset(c002.y);
};

SamplerState PointBorder : register(s2, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _19 = screenInverseSize.x * TEXCOORD.x;
  float _21 = screenInverseSize.y * TEXCOORD.y;
  float4 _25 = SrcTexture.SampleLevel(PointBorder, float2((_19 * (screenSize.x + -0.5009999871253967f)), (_21 * (screenSize.y + -0.5009999871253967f))), 0.0f);
  float _43;
  float _58;
  float _73;
  if (!(_25.x <= 0.0f)) {
    if (_25.x < 3.0517578125e-05f) {
      _43 = ((log2((_25.x * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _43 = ((log2(_25.x) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _43 = -0.35844698548316956f;
  }
  if (!(_25.y <= 0.0f)) {
    if (_25.y < 3.0517578125e-05f) {
      _58 = ((log2((_25.y * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _58 = ((log2(_25.y) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _58 = -0.35844698548316956f;
  }
  if (!(_25.z <= 0.0f)) {
    if (_25.z < 3.0517578125e-05f) {
      _73 = ((log2((_25.z * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _73 = ((log2(_25.z) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _73 = -0.35844698548316956f;
  }
  float4 _82 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_43 * 0.984375f) + 0.0078125f), ((_58 * 0.984375f) + 0.0078125f), ((_73 * 0.984375f) + 0.0078125f)), 0.0f);
  float _96 = ReadonlyDepth.Load(int3(int((_19 * screenSize.x) * readOnlyDepthSize.x), int((_21 * screenSize.y) * readOnlyDepthSize.y), 0));
  SV_Target.x = _82.x;
  SV_Target.y = _82.y;
  SV_Target.z = _82.z;
  SV_Target.w = select((_96.x <= 0.0f), 0.0f, 1.0f);

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


