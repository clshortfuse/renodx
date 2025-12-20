#include "./postprocess.hlsl"
#include "./shared.h"

Buffer<uint4> WhitePtSrv : register(t0);

Texture3D<float2> BilateralLuminanceSRV : register(t1);

Texture2D<float> BlurredLogLumSRV : register(t2);

Texture2D<float4> RE_POSTPROCESS_Color : register(t3);

RWTexture2D<float3> OutputTex : register(u0);

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
  float SceneInfo_Reserve0 : packoffset(c035.w);
  uint4 rayTracingParams : packoffset(c036.x);
  float4 sceneExtendedData : packoffset(c037.x);
  float2 projectionSpaceJitterOffset : packoffset(c038.x);
  float2 SceneInfo_Reserve2 : packoffset(c038.z);
};

cbuffer RangeCompressInfo : register(b1) {
  float rangeCompress : packoffset(c000.x);
  float rangeDecompress : packoffset(c000.y);
  float prevRangeCompress : packoffset(c000.z);
  float prevRangeDecompress : packoffset(c000.w);
  float rangeCompressForResource : packoffset(c001.x);
  float rangeDecompressForResource : packoffset(c001.y);
  float rangeCompressForCommon : packoffset(c001.z);
  float rangeDecompressForCommon : packoffset(c001.w);
};

cbuffer Tonemap : register(b2) {
  float exposureAdjustment : packoffset(c000.x);
  float tonemapRange : packoffset(c000.y);
  float specularSuppression : packoffset(c000.z);
  float sharpness : packoffset(c000.w);
  float preTonemapRange : packoffset(c001.x);
  int useAutoExposure : packoffset(c001.y);
  float echoBlend : packoffset(c001.z);
  float AABlend : packoffset(c001.w);
  float AASubPixel : packoffset(c002.x);
  float ResponsiveAARate : packoffset(c002.y);
  float VelocityWeightRate : packoffset(c002.z);
  float DepthRejectionRate : packoffset(c002.w);
  float ContrastTrackingRate : packoffset(c003.x);
  float ContrastTrackingThreshold : packoffset(c003.y);
  float LEHighlightContrast : packoffset(c003.z);
  float LEShadowContrast : packoffset(c003.w);
  float LEDetailStrength : packoffset(c004.x);
  float LEMiddleGreyLog : packoffset(c004.y);
  float LEBilateralGridScale : packoffset(c004.z);
  float LEBilateralGridBias : packoffset(c004.w);
  float LEPreExposureLog : packoffset(c005.x);
  int LEBlurredLogDownsampleMip : packoffset(c005.y);
  int2 LELuminanceTextureSize : packoffset(c005.z);
};

SamplerState BilinearClamp : register(s5, space32);

[numthreads(8, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _14 = float((uint)SV_DispatchThreadID.x);
  float _15 = float((uint)SV_DispatchThreadID.y);
  float _45;
  if ((bool)(_14 < screenSize.x) && (bool)(_15 < screenSize.y)) {
    float4 _25 = RE_POSTPROCESS_Color.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    float _31 = rangeDecompress * _25.x;
    float _32 = rangeDecompress * _25.y;
    float _33 = rangeDecompress * _25.z;
    do {
      if (!(useAutoExposure == 0)) {
        int4 _41 = asint(WhitePtSrv[16 / 4]);
        _45 = asfloat(_41.x);
      } else {
        _45 = 1.0f;
      }
      float _46 = _45 * exposureAdjustment;
      float _52 = log2(dot(float3((_46 * _31), (_46 * _32), (_46 * _33)), float3(0.25f, 0.5f, 0.25f)) + 9.999999747378752e-06f);
      float _58 = screenInverseSize.x * (_14 + 0.5f);
      float _59 = screenInverseSize.y * (_15 + 0.5f);
      float2 _69 = BilateralLuminanceSRV.SampleLevel(BilinearClamp, float3(_58, _59, ((((LEBilateralGridScale * _52) + LEBilateralGridBias) * 0.984375f) + 0.0078125f)), 0.0f);
      float _74 = BlurredLogLumSRV.SampleLevel(BilinearClamp, float2(_58, _59), 0.0f);
      float _77 = select((_69.y < 0.0010000000474974513f), _74.x, (_69.x / _69.y));
      float _83 = (LEPreExposureLog + _77) + ((_74.x - _77) * 0.6000000238418579f);
      float _84 = LEPreExposureLog + _52;
      float _87 = _83 - LEMiddleGreyLog;
      float _99 = exp2((((select((_87 > 0.0f), LEHighlightContrast, LEShadowContrast) * _87) - _84) + LEMiddleGreyLog) + (LEDetailStrength * (_84 - _83)));

      _99 = PickExposure(_99);
      
      OutputTex[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float3(((_99 * _31) * rangeCompress), ((_99 * _32) * rangeCompress), ((_99 * _33) * rangeCompress));
    } while (false);
  }
}
