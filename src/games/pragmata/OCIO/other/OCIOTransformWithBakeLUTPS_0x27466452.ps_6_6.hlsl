#include "../OCIO.hlsli"

Texture2D<float> ReadonlyDepth : register(t0);

Texture2D<float4> NormalXNormalYRoughnessMiscSRV : register(t1);

Texture2D<float4> SrcTexture : register(t2);

Texture3D<float4> SrcLUT : register(t3);

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

cbuffer CaptureBufferInfo : register(b1) {
  uint captureObjectType : packoffset(c000.x);
  uint captureBufferType : packoffset(c000.y);
  float farPlaneDistance : packoffset(c000.z);
};

cbuffer ImageSizeInfo : register(b2) {
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
  float _24 = screenInverseSize.x * TEXCOORD.x;
  float _26 = screenInverseSize.y * TEXCOORD.y;
  float4 _30 = SrcTexture.SampleLevel(PointBorder, float2((_24 * (screenSize.x + -0.5009999871253967f)), (_26 * (screenSize.y + -0.5009999871253967f))), 0.0f);
  float _48;
  float _63;
  float _78;
  bool _115;
  float _137;
  float _138;
  float _139;
  int _145;
  float _156;
  float _157;
  float _158;
  float _159;
  if (!(_30.x <= 0.0f)) {
    if (_30.x < 3.0517578125e-05f) {
      _48 = ((log2((_30.x * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _48 = ((log2(_30.x) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _48 = -0.35844698548316956f;
  }
  if (!(_30.y <= 0.0f)) {
    if (_30.y < 3.0517578125e-05f) {
      _63 = ((log2((_30.y * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _63 = ((log2(_30.y) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _63 = -0.35844698548316956f;
  }
  if (!(_30.z <= 0.0f)) {
    if (_30.z < 3.0517578125e-05f) {
      _78 = ((log2((_30.z * 0.5f) + 1.52587890625e-05f) * 0.05707760155200958f) + 0.5547950267791748f);
    } else {
      _78 = ((log2(_30.z) * 0.05707760155200958f) + 0.5547950267791748f);
    }
  } else {
    _78 = -0.35844698548316956f;
  }
  float4 _87 = SrcLUT.SampleLevel(TrilinearClamp, float3(((_48 * 0.984375f) + 0.0078125f), ((_63 * 0.984375f) + 0.0078125f), ((_78 * 0.984375f) + 0.0078125f)), 0.0f);
  float _101 = ReadonlyDepth.Load(int3(int((_24 * screenSize.x) * readOnlyDepthSize.x), int((_26 * screenSize.y) * readOnlyDepthSize.y), 0));
  bool _103 = (_101.x <= 0.0f);
  float4 _107 = NormalXNormalYRoughnessMiscSRV.Load(int3((uint)(uint(SV_Position.x)), (uint)(uint(SV_Position.y)), 0));
  if (!(_107.w == 0.0f)) {
    if (!(_107.w < 0.5f)) {
      _115 = (_107.w == 1.0f);
    } else {
      _115 = true;
    }
  } else {
    _115 = false;
  }
  if (!(captureBufferType == 0)) {
    float _122 = ReadonlyDepth.Load(int3(int(SV_Position.x), int(SV_Position.y), 0));
    float _135 = min(max((ZToLinear.z / ((ZToLinear.x - (ZToLinear.y * _122.x)) * farPlaneDistance)), 0.0f), 1.0f);
    _137 = _135;
    _138 = _135;
    _139 = _135;
  } else {
    _137 = _87.x;
    _138 = _87.y;
    _139 = _87.z;
  }
  if (captureObjectType == 1) {
    if (_103 || _115) {
      _156 = 0.0f;
      _157 = 0.0f;
      _158 = 0.0f;
      _159 = 0.0f;
      SV_Target.x = _156;
      SV_Target.y = _157;
      SV_Target.z = _158;
      SV_Target.w = _159;
    } else {
      _145 = 1;
    }
  } else {
    _145 = captureObjectType;
  }
  bool _149 = ((bool)(_103 || ((bool)(!_115)))) && (bool)(_145 == 2);
  _156 = select(_149, 0.0f, _137);
  _157 = select(_149, 0.0f, _138);
  _158 = select(_149, 0.0f, _139);
  _159 = select((_103 || _149), 0.0f, 1.0f);
  SV_Target.x = _156;
  SV_Target.y = _157;
  SV_Target.z = _158;
  SV_Target.w = _159;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


