#include "../common.hlsl"
#include "./adaptation.hlsl"

RWTexture1D<uint> renodx_eye_adaptation_histogram : register(u1, space50);

struct CameraBlock {
  float3 CameraBlock_000;
  int CameraBlock_012;
  float4 CameraBlock_016[4];
  float4 CameraBlock_080[4];
  float4 CameraBlock_144[4];
  float4 CameraBlock_208[4];
  float4 CameraBlock_272[4];
  float4 CameraBlock_336[4];
  float3 CameraBlock_400;
  int CameraBlock_412;
  float4 CameraBlock_416[4];
  float4 CameraBlock_480[4];
  float4 CameraBlock_544[4];
  float4 CameraBlock_608;
  float4 CameraBlock_624;
  float4 CameraBlock_640;
  float4 CameraBlock_656;
  float2 CameraBlock_672;
  float CameraBlock_680;
  float CameraBlock_684;
};

struct ResolutionBlock {
  float2 ResolutionBlock_000;
  float2 ResolutionBlock_008;
  float2 ResolutionBlock_016;
  float2 ResolutionBlock_024;
  int4 ResolutionBlock_032;
  float2 ResolutionBlock_048;
  float2 ResolutionBlock_056;
  float2 ResolutionBlock_064;
  float2 ResolutionBlock_072;
  int4 ResolutionBlock_080;
  int2 ResolutionBlock_096;
  float ResolutionBlock_104;
  int ResolutionBlock_108;
};

struct CameraBlockArray {
  CameraBlock CameraBlockArray_000[3];
  ResolutionBlock CameraBlockArray_2064[5];
};

struct VolumeShape {
  int VolumeShape_000;
  float3 VolumeShape_004;
  float4 VolumeShape_016[3];
  float4 VolumeShape_064[3];
};

struct Force {
  float3 Force_000;
  int Force_012;
  VolumeShape Force_016;
  float Force_128;
  float Force_132;
  int Force_136;
  int Force_140;
  float4 Force_144;
  float4 Force_160[8];
};

struct TopDownDepthSectorData {
  float4 TopDownDepthSectorData_000[4];
  float4 TopDownDepthSectorData_064[4];
  float4 TopDownDepthSectorData_128[4];
  float4 TopDownDepthSectorData_192[4];
  float3 TopDownDepthSectorData_256;
  int TopDownDepthSectorData_268;
};

struct HeightfieldData {
  int HeightfieldData_000;
  int HeightfieldData_004;
  float HeightfieldData_008;
  int HeightfieldData_012;
  TopDownDepthSectorData HeightfieldData_016[16];
};

struct ImageSpaceVolumeData {
  float4 ImageSpaceVolumeData_000[4];
  float4 ImageSpaceVolumeData_064[4];
  float3 ImageSpaceVolumeData_128;
  int ImageSpaceVolumeData_140;
  float ImageSpaceVolumeData_144;
  int ImageSpaceVolumeData_148;
  int ImageSpaceVolumeData_152;
  int ImageSpaceVolumeData_156;
};

struct VolumeArrayData {
  int VolumeArrayData_000;
  int VolumeArrayData_004;
  int VolumeArrayData_008;
  int VolumeArrayData_012;
  int VolumeArrayData_016;
  int VolumeArrayData_020;
  int VolumeArrayData_024;
  int VolumeArrayData_028;
};

struct ProbeRenderData {
  float4 ProbeRenderData_000[4];
  VolumeArrayData ProbeRenderData_064[12];
  int ProbeRenderData_448;
  int ProbeRenderData_452;
  float ProbeRenderData_456;
  int ProbeRenderData_460;
};

struct SIndirectLightingData {
  int SIndirectLightingData_000;
  float SIndirectLightingData_004;
  float SIndirectLightingData_008;
  float SIndirectLightingData_012;
  float SIndirectLightingData_016;
  float SIndirectLightingData_020;
  float SIndirectLightingData_024;
  float SIndirectLightingData_028;
  float SIndirectLightingData_032;
  float SIndirectLightingData_036;
  float SIndirectLightingData_040;
  float SIndirectLightingData_044;
  float SIndirectLightingData_048;
  float SIndirectLightingData_052;
  float SIndirectLightingData_056;
  float SIndirectLightingData_060;
  float SIndirectLightingData_064;
  float SIndirectLightingData_068;
  float SIndirectLightingData_072;
  float SIndirectLightingData_076;
  float SIndirectLightingData_080;
  float SIndirectLightingData_084;
  int SIndirectLightingData_088;
  float SIndirectLightingData_092;
  float SIndirectLightingData_096;
  float SIndirectLightingData_100;
  float SIndirectLightingData_104;
  float SIndirectLightingData_108;
  float SIndirectLightingData_112;
  int SIndirectLightingData_116;
  float SIndirectLightingData_120;
  float SIndirectLightingData_124;
  float SIndirectLightingData_128;
  float SIndirectLightingData_132;
  float SIndirectLightingData_136;
  int SIndirectLightingData_140;
  int SIndirectLightingData_144;
  float SIndirectLightingData_148;
  int SIndirectLightingData_152;
  int SIndirectLightingData_156;
  int SIndirectLightingData_160;
  int SIndirectLightingData_164;
  int SIndirectLightingData_168;
  int SIndirectLightingData_172;
  ImageSpaceVolumeData SIndirectLightingData_176[256];
  int SIndirectLightingData_41136;
  float SIndirectLightingData_41140;
  float SIndirectLightingData_41144;
  float SIndirectLightingData_41148;
  float SIndirectLightingData_41152;
  float SIndirectLightingData_41156;
  int SIndirectLightingData_41160;
  int SIndirectLightingData_41164;
};

struct WindData {
  int WindData_000;
  float WindData_004;
  float WindData_008;
  float WindData_012;
  float WindData_016;
  float WindData_020;
  float WindData_024;
  float WindData_028;
  float WindData_032;
  float WindData_036;
  float WindData_040;
  float WindData_044;
  Force WindData_048[8];
};

struct CameraExposureData {
  float CameraExposureData_000;
  float CameraExposureData_004;
  float CameraExposureData_008;
  float CameraExposureData_012;
  float CameraExposureData_016;
  float CameraExposureData_020;
  float CameraExposureData_024;
  float CameraExposureData_028;
};

struct GlobalLightData {
  int GlobalLightData_000;
  int GlobalLightData_004;
  int GlobalLightData_008;
  int GlobalLightData_012;
};

struct CloudPlaneShadowData {
  float2 CloudPlaneShadowData_000;
  float CloudPlaneShadowData_008;
  float CloudPlaneShadowData_012;
  float CloudPlaneShadowData_016;
  int CloudPlaneShadowData_020;
  int CloudPlaneShadowData_024;
  int CloudPlaneShadowData_028;
};

struct CloudOverlaySet {
  CloudPlaneShadowData CloudOverlaySet_000;
};

struct GlobalShadowData {
  CloudOverlaySet GlobalShadowData_000[2];
  float GlobalShadowData_064;
  float GlobalShadowData_068;
  float GlobalShadowData_072;
  float GlobalShadowData_076;
  float GlobalShadowData_080;
  int GlobalShadowData_084;
  int GlobalShadowData_088;
  int GlobalShadowData_092;
};

struct ReflectionProbeDescData {
  int ReflectionProbeDescData_000;
  int ReflectionProbeDescData_004;
  int ReflectionProbeDescData_008;
  int ReflectionProbeDescData_012;
  float ReflectionProbeDescData_016;
  int ReflectionProbeDescData_020;
  float ReflectionProbeDescData_024;
  float ReflectionProbeDescData_028;
  float ReflectionProbeDescData_032;
  int ReflectionProbeDescData_036;
  int ReflectionProbeDescData_040;
  int ReflectionProbeDescData_044;
};

struct IndirectExposureData {
  float IndirectExposureData_000;
  float IndirectExposureData_004;
  int IndirectExposureData_008;
  int IndirectExposureData_012;
};

struct ReflectionProbeExposureData {
  IndirectExposureData ReflectionProbeExposureData_000[32];
};

struct PlanetConstantsData {
  int PlanetConstantsData_000;
  int PlanetConstantsData_004;
  int PlanetConstantsData_008;
  int PlanetConstantsData_012;
};

struct TiledBinning_idTech7FrameData {
  int TiledBinning_idTech7FrameData_000;
  int TiledBinning_idTech7FrameData_004;
  int TiledBinning_idTech7FrameData_008;
  int TiledBinning_idTech7FrameData_012;
  int TiledBinning_idTech7FrameData_016;
  float TiledBinning_idTech7FrameData_020;
  float TiledBinning_idTech7FrameData_024;
  float TiledBinning_idTech7FrameData_028;
  float TiledBinning_idTech7FrameData_032;
  float TiledBinning_idTech7FrameData_036;
  float TiledBinning_idTech7FrameData_040;
  int TiledBinning_idTech7FrameData_044;
  int TiledBinning_idTech7FrameData_048;
  int TiledBinning_idTech7FrameData_052;
  int TiledBinning_idTech7FrameData_056;
  int TiledBinning_idTech7FrameData_060;
  int TiledBinning_idTech7FrameData_064;
  int TiledBinning_idTech7FrameData_068;
  int TiledBinning_idTech7FrameData_072;
  int TiledBinning_idTech7FrameData_076;
  float2 TiledBinning_idTech7FrameData_080;
  float2 TiledBinning_idTech7FrameData_088;
  float2 TiledBinning_idTech7FrameData_096;
  int TiledBinning_idTech7FrameData_104;
  int TiledBinning_idTech7FrameData_108;
};

struct InlineContactShadowsConstants {
  int InlineContactShadowsConstants_000;
  int InlineContactShadowsConstants_004;
  float InlineContactShadowsConstants_008;
  float InlineContactShadowsConstants_012;
  float InlineContactShadowsConstants_016;
  float InlineContactShadowsConstants_020;
  float InlineContactShadowsConstants_024;
  float InlineContactShadowsConstants_028;
  float InlineContactShadowsConstants_032;
  float InlineContactShadowsConstants_036;
  int InlineContactShadowsConstants_040;
  int InlineContactShadowsConstants_044;
};

struct VolumetricLightingApplyParameters {
  float VolumetricLightingApplyParameters_000;
  float VolumetricLightingApplyParameters_004;
  float VolumetricLightingApplyParameters_008;
  float VolumetricLightingApplyParameters_012;
  float VolumetricLightingApplyParameters_016;
  float VolumetricLightingApplyParameters_020;
  float VolumetricLightingApplyParameters_024;
  int VolumetricLightingApplyParameters_028;
};

struct PrecomputeTransmittanceParameters {
  float3 PrecomputeTransmittanceParameters_000;
  int PrecomputeTransmittanceParameters_012;
  float3 PrecomputeTransmittanceParameters_016;
  int PrecomputeTransmittanceParameters_028;
  float3 PrecomputeTransmittanceParameters_032;
  float PrecomputeTransmittanceParameters_044;
};

struct MomentBasedOITSettings {
  float MomentBasedOITSettings_000;
  float MomentBasedOITSettings_004;
  float MomentBasedOITSettings_008;
  float MomentBasedOITSettings_012;
  float MomentBasedOITSettings_016;
  float MomentBasedOITSettings_020;
  float MomentBasedOITSettings_024;
  float MomentBasedOITSettings_028;
  float2 MomentBasedOITSettings_032;
  float MomentBasedOITSettings_040;
  float MomentBasedOITSettings_044;
  float MomentBasedOITSettings_048;
  int MomentBasedOITSettings_052;
  int MomentBasedOITSettings_056;
  int MomentBasedOITSettings_060;
};

struct TonemappingParams {
  float TonemappingParams_000;
  float TonemappingParams_004;
  float TonemappingParams_008;
  float TonemappingParams_012;
  float TonemappingParams_016;
  float TonemappingParams_020;
  float TonemappingParams_024;
  int TonemappingParams_028;
};

struct EffectsAlphaThresholdParams {
  float EffectsAlphaThresholdParams_000;
  float EffectsAlphaThresholdParams_004;
  float EffectsAlphaThresholdParams_008;
  float EffectsAlphaThresholdParams_012;
};

struct TiledLightingDebug {
  int TiledLightingDebug_000;
  int TiledLightingDebug_004;
  float TiledLightingDebug_008;
  float TiledLightingDebug_012;
  float TiledLightingDebug_016;
  int TiledLightingDebug_020;
  int TiledLightingDebug_024;
  int TiledLightingDebug_028;
};

struct GPUDebugGeometrySettings {
  int GPUDebugGeometrySettings_000;
  int GPUDebugGeometrySettings_004;
  int GPUDebugGeometrySettings_008;
  int GPUDebugGeometrySettings_012;
};

struct FoliageDeformationInstance {
  float3 FoliageDeformationInstance_000;
  float FoliageDeformationInstance_012;
  float FoliageDeformationInstance_016;
  int FoliageDeformationInstance_020;
  int FoliageDeformationInstance_024;
  int FoliageDeformationInstance_028;
};

struct FoliageDeformationData {
  FoliageDeformationInstance FoliageDeformationData_000[25];
  int FoliageDeformationData_800;
  float FoliageDeformationData_804;
  float FoliageDeformationData_808;
  float FoliageDeformationData_812;
  float FoliageDeformationData_816;
  int FoliageDeformationData_820;
  int FoliageDeformationData_824;
  int FoliageDeformationData_828;
};

struct SPerSceneConstants {
  CameraBlockArray SPerSceneConstants_000;
  WindData SPerSceneConstants_2624;
  CameraExposureData SPerSceneConstants_4976;
  GlobalLightData SPerSceneConstants_5008;
  GlobalShadowData SPerSceneConstants_5024;
  ReflectionProbeDescData SPerSceneConstants_5120;
  ReflectionProbeExposureData SPerSceneConstants_5168;
  SIndirectLightingData SPerSceneConstants_5680;
  ProbeRenderData SPerSceneConstants_46848;
  PlanetConstantsData SPerSceneConstants_47312;
  float SPerSceneConstants_47328;
  int SPerSceneConstants_47332;
  int SPerSceneConstants_47336;
  int SPerSceneConstants_47340;
  float SPerSceneConstants_47344;
  int SPerSceneConstants_47348;
  int SPerSceneConstants_47352;
  int SPerSceneConstants_47356;
  TiledBinning_idTech7FrameData SPerSceneConstants_47360;
  float SPerSceneConstants_47472;
  float SPerSceneConstants_47476;
  float SPerSceneConstants_47480;
  float SPerSceneConstants_47484;
  float SPerSceneConstants_47488;
  float SPerSceneConstants_47492;
  float SPerSceneConstants_47496;
  float SPerSceneConstants_47500;
  float SPerSceneConstants_47504;
  int SPerSceneConstants_47508;
  int SPerSceneConstants_47512;
  int SPerSceneConstants_47516;
  InlineContactShadowsConstants SPerSceneConstants_47520;
  VolumetricLightingApplyParameters SPerSceneConstants_47568;
  PrecomputeTransmittanceParameters SPerSceneConstants_47600;
  HeightfieldData SPerSceneConstants_47648;
  MomentBasedOITSettings SPerSceneConstants_52016;
  TonemappingParams SPerSceneConstants_52080;
  EffectsAlphaThresholdParams SPerSceneConstants_52112;
  TiledLightingDebug SPerSceneConstants_52128;
  GPUDebugGeometrySettings SPerSceneConstants_52160;
  FoliageDeformationData SPerSceneConstants_52176;
};

struct HDRData {
  float HDRData_000;
  float HDRData_004;
  int HDRData_008;
  int HDRData_012;
};

struct PushConstantWrapper_BloomDownsample {
  int PushConstantWrapper_BloomDownsample_000;
  int PushConstantWrapper_BloomDownsample_004;
  int PushConstantWrapper_BloomDownsample_008;
  int PushConstantWrapper_BloomDownsample_012;
  int PushConstantWrapper_BloomDownsample_016;
  int PushConstantWrapper_BloomDownsample_020;
  int PushConstantWrapper_BloomDownsample_024;
};

Texture2D<float3> t0_space5 : register(t0, space5);

RWTexture2D<float3> u0_space5 : register(u0, space5);

RWTexture2D<float> u1_space5 : register(u1, space5);

RWStructuredBuffer<uint> u2_space5 : register(u2, space5);

cbuffer cb0_space3 : register(b0, space3) {
  SPerSceneConstants PerSceneConstants_000 : packoffset(c000.x);
};

cbuffer cb0_space5 : register(b0, space5) {
  HDRData Data_000 : packoffset(c000.x);
};

cbuffer cb0 : register(b0) {
  PushConstantWrapper_BloomDownsample stub_PushConstantWrapper_BloomDownsample_000 : packoffset(c000.x);
};

SamplerState s0_space5 : register(s0, space5);

groupshared float ldsLumaCache[64];

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _82;
  float _198;
  float _221;
  float _244;
  if (!((((uint)(int)(SV_DispatchThreadID.x) >= (uint)stub_PushConstantWrapper_BloomDownsample_000.PushConstantWrapper_BloomDownsample_000)) || (((uint)(int)(SV_DispatchThreadID.y) >= (uint)stub_PushConstantWrapper_BloomDownsample_000.PushConstantWrapper_BloomDownsample_004)))) {
    float _25 = asfloat(stub_PushConstantWrapper_BloomDownsample_000.PushConstantWrapper_BloomDownsample_008);
    float _27 = asfloat(stub_PushConstantWrapper_BloomDownsample_000.PushConstantWrapper_BloomDownsample_012);
    float _28 = float((uint)SV_DispatchThreadID.x);
    float _29 = float((uint)SV_DispatchThreadID.y);
    float _31 = _25 * (_28 + 0.25f);
    float _33 = _27 * (_29 + 0.25f);
    float _35 = _27 * (_29 + 0.75f);
    float _37 = _25 * (_28 + 0.75f);
    float3 _40 = t0_space5.SampleLevel(s0_space5, float2(_31, _33), 0.0f);
    float _44 = max(0.0f, _40.x);
    float _45 = max(0.0f, _40.y);
    float _46 = max(0.0f, _40.z);
    float3 _47 = t0_space5.SampleLevel(s0_space5, float2(_31, _35), 0.0f);
    float _51 = max(0.0f, _47.x);
    float _52 = max(0.0f, _47.y);
    float _53 = max(0.0f, _47.z);
    float3 _54 = t0_space5.SampleLevel(s0_space5, float2(_37, _33), 0.0f);
    float _58 = max(0.0f, _54.x);
    float _59 = max(0.0f, _54.y);
    float _60 = max(0.0f, _54.z);
    float3 _61 = t0_space5.SampleLevel(s0_space5, float2(_37, _35), 0.0f);
    float _65 = max(0.0f, _61.x);
    float _66 = max(0.0f, _61.y);
    float _67 = max(0.0f, _61.z);
    float _68 = dot(float3(_44, _45, _46), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
    float _69 = dot(float3(_51, _52, _53), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
    float _70 = dot(float3(_58, _59, _60), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
    float _71 = dot(float3(_65, _66, _67), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
    if (!(PerSceneConstants_000.SPerSceneConstants_4976.CameraExposureData_004 > 1.000000013351432e-10f)) {
      _82 = (PerSceneConstants_000.SPerSceneConstants_4976.CameraExposureData_008 / max((PerSceneConstants_000.SPerSceneConstants_4976.CameraExposureData_000 * 1.2000000476837158f), 9.999999747378752e-05f));
    } else {
      _82 = PerSceneConstants_000.SPerSceneConstants_4976.CameraExposureData_004;
    }
    float _92 = (((_69 + _68) + _70) + _71) / (min(max(_82, PerSceneConstants_000.SPerSceneConstants_4976.CameraExposureData_020), PerSceneConstants_000.SPerSceneConstants_4976.CameraExposureData_024) * 4.0f);
    float _95 = asfloat(stub_PushConstantWrapper_BloomDownsample_000.PushConstantWrapper_BloomDownsample_016);
    float _133 = 1.0f / (_68 + 1.0f);
    float _135 = 1.0f / (_69 + 1.0f);
    float _137 = 1.0f / (_70 + 1.0f);
    float _139 = 1.0f / (_71 + 1.0f);
    float _142 = ((_135 + _133) + _137) + _139;
    float _168 = asfloat(stub_PushConstantWrapper_BloomDownsample_000.PushConstantWrapper_BloomDownsample_020);
    ldsLumaCache[((int)(SV_GroupThreadID.y + (asuint((int)(SV_GroupThreadID.x)) * 8u)))] = _92;
    GroupMemoryBarrierWithGroupSync();
    if ((((int)(SV_GroupThreadID.y) | (int)(SV_GroupThreadID.x)) & 1) == 0) {
      float _196 = ((((ldsLumaCache[((int)((SV_GroupThreadID.y + 1u) + (asuint((int)(SV_GroupThreadID.x)) * 8u)))]) + _92) + (ldsLumaCache[((int)(SV_GroupThreadID.y + (asuint(((int)(SV_GroupThreadID.x + 1u))) * 8u)))])) + (ldsLumaCache[((int)((SV_GroupThreadID.y + 1u) + (asuint(((int)(SV_GroupThreadID.x + 1u))) * 8u)))])) * 0.25f;
      ldsLumaCache[((int)(SV_GroupThreadID.y + (asuint((int)(SV_GroupThreadID.x)) * 8u)))] = _196;
      _198 = _196;
    } else {
      _198 = _92;
    }
    GroupMemoryBarrierWithGroupSync();
    if ((((int)(SV_GroupThreadID.y) | (int)(SV_GroupThreadID.x)) & 3) == 0) {
      float _219 = ((((ldsLumaCache[((int)((SV_GroupThreadID.y + 2u) + (asuint((int)(SV_GroupThreadID.x)) * 8u)))]) + _198) + (ldsLumaCache[((int)(SV_GroupThreadID.y + (asuint(((int)(SV_GroupThreadID.x + 2u))) * 8u)))])) + (ldsLumaCache[((int)((SV_GroupThreadID.y + 2u) + (asuint(((int)(SV_GroupThreadID.x + 2u))) * 8u)))])) * 0.25f;
      ldsLumaCache[((int)(SV_GroupThreadID.y + (asuint((int)(SV_GroupThreadID.x)) * 8u)))] = _219;
      _221 = _219;
    } else {
      _221 = _198;
    }
    GroupMemoryBarrierWithGroupSync();
    if ((((int)(SV_GroupThreadID.y) | (int)(SV_GroupThreadID.x)) & 7) == 0) {
      float _242 = ((((ldsLumaCache[((int)((SV_GroupThreadID.y + 4u) + (asuint((int)(SV_GroupThreadID.x)) * 8u)))]) + _221) + (ldsLumaCache[((int)(SV_GroupThreadID.y + (asuint(((int)(SV_GroupThreadID.x + 4u))) * 8u)))])) + (ldsLumaCache[((int)((SV_GroupThreadID.y + 4u) + (asuint(((int)(SV_GroupThreadID.x + 4u))) * 8u)))])) * 0.25f;
      ldsLumaCache[((int)(SV_GroupThreadID.y + (asuint((int)(SV_GroupThreadID.x)) * 8u)))] = _242;
      _244 = _242;
    } else {
      _244 = _221;
    }
    if ((int)(SV_GroupIndex) == 0) {
      u1_space5[int2(((uint)(SV_DispatchThreadID.x) >> 3), ((uint)(SV_DispatchThreadID.y) >> 3))] = _244;
      uint _263 = min((uint)(99), (uint)((int)(uint(floor(saturate((log2(max(_244, 9.999999974752427e-07f)) - Data_000.HDRData_000) / max((Data_000.HDRData_004 - Data_000.HDRData_000), 9.999999974752427e-07f)) * 100.0f)))));
      uint _265;
      InterlockedAdd(u2_space5[(int)(_263)], 1, _265);
    }
    if (CUSTOM_EYE_ADAPTATION_PERCEPTUAL) {
      float3 psychov17_average_color = float3(
          ((_44 + _51) + (_58 + _65)) * 0.25f,
          ((_45 + _52) + (_59 + _66)) * 0.25f,
          ((_46 + _53) + (_60 + _67)) * 0.25f);
      float psychov17_histogram_yf = renodx::color::yf::from::BT709(psychov17_average_color);
      float2 psychov17_uv = float2(_25 * (_28 + 0.5f), _27 * (_29 + 0.5f));
      float2 psychov17_center_delta = psychov17_uv - float2(0.5f, 0.5f);
      float psychov17_radius2 = dot(psychov17_center_delta, psychov17_center_delta);
      float psychov17_center_weight = exp(
          (-0.5f * psychov17_radius2)
          / (custom::adaptation::v1::HISTOGRAM_CENTER_WEIGHT_SIGMA * custom::adaptation::v1::HISTOGRAM_CENTER_WEIGHT_SIGMA));
      // Each thread represents a 2x2 source region. Weight it like a valid
      // four-sample contribution, then center-weight it with the Crimson Desert
      // gaussian kernel.
      uint psychov17_weight = max(
          custom::adaptation::v1::HISTOGRAM_BASE_SAMPLE_WEIGHT,
          (uint)round((float)custom::adaptation::v1::HISTOGRAM_BASE_SAMPLE_WEIGHT * psychov17_center_weight * custom::adaptation::v1::HISTOGRAM_CENTER_WEIGHT_SCALE));
      uint psychov17_bin = custom::adaptation::v1::EncodeHistogramBin(psychov17_histogram_yf);
      uint psychov17_previous_count;
      InterlockedAdd(renodx_eye_adaptation_histogram[psychov17_bin], psychov17_weight, psychov17_previous_count);
    }
    u0_space5[int2((int)(SV_DispatchThreadID.x), (int)(SV_DispatchThreadID.y))] = float3((_168 * (((((_135 * max(0.0f, ((_95 * _51) + -1.0f))) + (_133 * max(0.0f, ((_95 * _44) + -1.0f)))) + (_137 * max(0.0f, ((_95 * _58) + -1.0f)))) + (_139 * max(0.0f, ((_95 * _65) + -1.0f)))) / _142)), (_168 * (((((_135 * max(0.0f, ((_95 * _52) + -1.0f))) + (_133 * max(0.0f, ((_95 * _45) + -1.0f)))) + (_137 * max(0.0f, ((_95 * _59) + -1.0f)))) + (_139 * max(0.0f, ((_95 * _66) + -1.0f)))) / _142)), (_168 * (((((_135 * max(0.0f, ((_95 * _53) + -1.0f))) + (_133 * max(0.0f, ((_95 * _46) + -1.0f)))) + (_137 * max(0.0f, ((_95 * _60) + -1.0f)))) + (_139 * max(0.0f, ((_95 * _67) + -1.0f)))) / _142)));
  }
}
