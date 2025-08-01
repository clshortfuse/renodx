#include "../shared.h"

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

struct CameraBlockArray {
  CameraBlock CameraBlockArray_000[3];
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
    float2 ResolutionBlock_080;
    int2 ResolutionBlock_088;
    int4 ResolutionBlock_096;
    float ResolutionBlock_112;
    int ResolutionBlock_116;
    int ResolutionBlock_120;
    int ResolutionBlock_124;
  }
  CameraBlockArray_2064[5];
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

struct ProbeRenderData {
  float4 ProbeRenderData_000[4];
  struct VolumeArrayData {
    int VolumeArrayData_000;
    int VolumeArrayData_004;
    int VolumeArrayData_008;
    int VolumeArrayData_012;
    int VolumeArrayData_016;
    int VolumeArrayData_020;
    int VolumeArrayData_024;
    int VolumeArrayData_028;
  }
  ProbeRenderData_064[12];
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

struct SPerSceneConstants {
  CameraBlockArray SPerSceneConstants_000;
  WindData SPerSceneConstants_2704;
  struct CameraExposureData {
    float CameraExposureData_000;
    float CameraExposureData_004;
    float CameraExposureData_008;
    float CameraExposureData_012;
    float CameraExposureData_016;
    float CameraExposureData_020;
    float CameraExposureData_024;
    float CameraExposureData_028;
  }
  SPerSceneConstants_5056;
  struct GlobalLightData {
    int GlobalLightData_000;
    int GlobalLightData_004;
    int GlobalLightData_008;
    int GlobalLightData_012;
  }
  SPerSceneConstants_5088;
  struct GlobalShadowData {
    struct CloudOverlaySet {
      struct CloudPlaneShadowData {
        float2 CloudPlaneShadowData_000;
        float CloudPlaneShadowData_008;
        float CloudPlaneShadowData_012;
        float CloudPlaneShadowData_016;
        int CloudPlaneShadowData_020;
        int CloudPlaneShadowData_024;
        int CloudPlaneShadowData_028;
      }
      CloudOverlaySet_000;
    }
    GlobalShadowData_000[2];
    float GlobalShadowData_064;
    float GlobalShadowData_068;
    float GlobalShadowData_072;
    float GlobalShadowData_076;
    float GlobalShadowData_080;
    int GlobalShadowData_084;
    int GlobalShadowData_088;
    int GlobalShadowData_092;
  }
  SPerSceneConstants_5104;
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
  }
  SPerSceneConstants_5200;
  struct ReflectionProbeExposureData {
    struct IndirectExposureData {
      float IndirectExposureData_000;
      float IndirectExposureData_004;
      int IndirectExposureData_008;
      int IndirectExposureData_012;
    }
    ReflectionProbeExposureData_000[32];
  }
  SPerSceneConstants_5248;
  SIndirectLightingData SPerSceneConstants_5760;
  ProbeRenderData SPerSceneConstants_46928;
  struct PlanetConstantsData {
    int PlanetConstantsData_000;
    int PlanetConstantsData_004;
    int PlanetConstantsData_008;
    int PlanetConstantsData_012;
  }
  SPerSceneConstants_47392;
  float SPerSceneConstants_47408;
  int SPerSceneConstants_47412;
  int SPerSceneConstants_47416;
  float SPerSceneConstants_47420;
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
  }
  SPerSceneConstants_47424;
  float SPerSceneConstants_47536;
  float SPerSceneConstants_47540;
  float SPerSceneConstants_47544;
  float SPerSceneConstants_47548;
  float SPerSceneConstants_47552;
  float SPerSceneConstants_47556;
  float SPerSceneConstants_47560;
  float SPerSceneConstants_47564;
  float SPerSceneConstants_47568;
  int SPerSceneConstants_47572;
  int SPerSceneConstants_47576;
  int SPerSceneConstants_47580;
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
  }
  SPerSceneConstants_47584;
  struct VolumetricLightingApplyParameters {
    float VolumetricLightingApplyParameters_000;
    float VolumetricLightingApplyParameters_004;
    float VolumetricLightingApplyParameters_008;
    float VolumetricLightingApplyParameters_012;
    float VolumetricLightingApplyParameters_016;
    float VolumetricLightingApplyParameters_020;
    float VolumetricLightingApplyParameters_024;
    int VolumetricLightingApplyParameters_028;
  }
  SPerSceneConstants_47632;
  struct PrecomputeTransmittanceParameters {
    float3 PrecomputeTransmittanceParameters_000;
    int PrecomputeTransmittanceParameters_012;
    float3 PrecomputeTransmittanceParameters_016;
    int PrecomputeTransmittanceParameters_028;
    float3 PrecomputeTransmittanceParameters_032;
    float PrecomputeTransmittanceParameters_044;
  }
  SPerSceneConstants_47664;
  HeightfieldData SPerSceneConstants_47712;
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
  }
  SPerSceneConstants_52080;
  struct TonemappingParams {
    float TonemappingParams_000;
    float TonemappingParams_004;
    float TonemappingParams_008;
    float TonemappingParams_012;
    float TonemappingParams_016;
    float TonemappingParams_020;
    float TonemappingParams_024;
    int TonemappingParams_028;
  }
  SPerSceneConstants_52144;
  struct EffectsAlphaThresholdParams {
    float EffectsAlphaThresholdParams_000;
    float EffectsAlphaThresholdParams_004;
    float EffectsAlphaThresholdParams_008;
    float EffectsAlphaThresholdParams_012;
  }
  SPerSceneConstants_52176;
  struct TiledLightingDebug {
    int TiledLightingDebug_000;
    int TiledLightingDebug_004;
    float TiledLightingDebug_008;
    float TiledLightingDebug_012;
    float TiledLightingDebug_016;
    int TiledLightingDebug_020;
    int TiledLightingDebug_024;
    int TiledLightingDebug_028;
  }
  SPerSceneConstants_52192;
  struct GPUDebugGeometrySettings {
    int GPUDebugGeometrySettings_000;
    int GPUDebugGeometrySettings_004;
    int GPUDebugGeometrySettings_008;
    int GPUDebugGeometrySettings_012;
  }
  SPerSceneConstants_52224;
  struct FoliageDeformationData {
    struct FoliageDeformationInstance {
      float3 FoliageDeformationInstance_000;
      float FoliageDeformationInstance_012;
      float FoliageDeformationInstance_016;
      int FoliageDeformationInstance_020;
      int FoliageDeformationInstance_024;
      int FoliageDeformationInstance_028;
    }
    FoliageDeformationData_000[25];
    int FoliageDeformationData_800;
    float FoliageDeformationData_804;
    float FoliageDeformationData_808;
    float FoliageDeformationData_812;
    float FoliageDeformationData_816;
    int FoliageDeformationData_820;
    int FoliageDeformationData_824;
    int FoliageDeformationData_828;
  }
  SPerSceneConstants_52240;
};

Texture2D<float3> t0 : register(t0, space9);

Texture2D<float> t1 : register(t1, space9);

Texture2D<float3> t2 : register(t2, space9);

Texture3D<float3> t3 : register(t3, space9);

struct HDRCompositeData {
  float4 HDRCompositeData_000;
  float4 HDRCompositeData_016;
  float HDRCompositeData_032;
  float HDRCompositeData_036;
  float HDRCompositeData_040;
  int HDRCompositeData_044;
};

StructuredBuffer<HDRCompositeData> t4 : register(t4, space9);

cbuffer cb0 : register(b0, space6) {
  struct FrameData {
    int FrameData_000;
    int FrameData_004;
    float2 FrameData_008;
    float FrameData_016;
    float FrameData_020;
    float FrameData_024;
    float FrameData_028;
    float FrameData_032;
    int FrameData_036;
    float FrameData_040;
    float FrameData_044;
    float4 FrameData_048;
    float FrameData_064;
    float FrameData_068;
    int FrameData_072;
    int FrameData_076;
    struct FrameDebug {
      int2 FrameDebug_000;
      int2 FrameDebug_008;
      int2 FrameDebug_016;
      int FrameDebug_024;
      int FrameDebug_028;
      float FrameDebug_032;
      int FrameDebug_036;
      int FrameDebug_040;
      int FrameDebug_044;
      int FrameDebug_048;
      int FrameDebug_052;
      int FrameDebug_056;
      int FrameDebug_060;
    }
    FrameData_080;
  }
SharedFrameData_000:
  packoffset(c000.x);  //  Offset:    0
};

cbuffer cb1 : register(b0, space7) {
  SPerSceneConstants PerSceneConstants_000 : packoffset(c000.x);  //  Offset:    0
};

cbuffer cb2 : register(b0) {
  struct PushConstantWrapper_HDRComposite {
    int PushConstantWrapper_HDRComposite_000;
    int PushConstantWrapper_HDRComposite_004;
    int PushConstantWrapper_HDRComposite_008;
  }
stub_PushConstantWrapper_HDRComposite_000:
  packoffset(c000.x);  //  Offset:    0
};

SamplerState s0 : register(s0, space9);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _17[3];
  float _18[3];
  float _23 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_000.x;
  float _24 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_000.y;
  float _25 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_000.z;
  float _26 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_000.w;
  float _28 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_016.x;
  float _29 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_016.y;
  float _30 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_016.z;
  float _31 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_016.w;
  float _33 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_032;
  float _35 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_036;
  float _37 = t4[(uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_000)].HDRCompositeData_040;
  float3 _41 = t0.Load(int3(((uint)(uint(SV_Position.x))), ((uint)(uint(SV_Position.y))), 0));
  float _55;
  float _239;
  float _247;
  int _248;
  float _282;
  float _285;
  float _302;
  float _303;
  float _304;
  float _505;
  float _506;
  float _507;
  if (!(((uint)(SharedFrameData_000.FrameData_036)) == 0)) {
    // _55 = lerp(SharedFrameData_000.FrameData_040, 1.0f, 0.8500000238418579f);
    _55 = 1.0f;
  } else {
    _55 = 1.0f;
  }

  if (CUSTOM_LUT_SCALING != 0) {
    _55 = 1.f;
  }

  float3 _58 = t2.SampleLevel(s0, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  _58 *= CUSTOM_BLOOM;

  float _63 = asfloat((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_008));
  float _70 = ((_58.x * _55) * _63) + _41.x;
  float _71 = ((_58.y * _55) * _63) + _41.y;
  float _72 = ((_58.z * _55) * _63) + _41.z;

  float3 untonemapped = float3(_70, _71, _72);

  float mid_gray = 0.18f;
  // Duplicate for midgray computation
  {
    _70 = 0.18f;
    if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 0) {
      _302 = (saturate(_70));
      _303 = (saturate(_71));
      _304 = (saturate(_72));
    } else {
      if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 1) {
        _302 = (saturate((((_70 * 2.509999990463257f) + 0.029999999329447746f) * _70) / ((((_70 * 2.430000066757202f) + 0.5899999737739563f) * _70) + 0.14000000059604645f)));
        _303 = (saturate((((_71 * 2.509999990463257f) + 0.029999999329447746f) * _71) / ((((_71 * 2.430000066757202f) + 0.5899999737739563f) * _71) + 0.14000000059604645f)));
        _304 = (saturate((((_72 * 2.509999990463257f) + 0.029999999329447746f) * _72) / ((((_72 * 2.430000066757202f) + 0.5899999737739563f) * _72) + 0.14000000059604645f)));
      } else {
        if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 2) {
          float _119 = ((0.5600000023841858f / PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_000) + 2.430000066757202f) + (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_000 * PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_000));
          _302 = (saturate((((_119 * _70) + 0.029999999329447746f) * _70) / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 + (((_70 * 2.430000066757202f) + 0.5899999737739563f) * _70))));
          _303 = (saturate((((_119 * _71) + 0.029999999329447746f) * _71) / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 + (((_71 * 2.430000066757202f) + 0.5899999737739563f) * _71))));
          _304 = (saturate((((_119 * _72) + 0.029999999329447746f) * _72) / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 + (((_72 * 2.430000066757202f) + 0.5899999737739563f) * _72))));
        } else {
          if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 3) {
            _17[0] = _70;
            _17[1] = _71;
            _17[2] = _72;
            float _168 = max(0.0f, (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_016));
            float _170 = saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_024);
            float _171 = (exp2((log2(saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_012))) * 2.200000047683716f)) * 0.5f;
            float _173 = (1.0f - (saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_008))) * _171;
            float _174 = 1.0f - _173;
            float _176 = (1.0f - (min(0.9999899864196777f, (max(1.1920928955078125e-07f, (saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_020))))))) * _174;
            float _182 = ((_171 + -0.9999998807907104f) + _174) + (exp2(_168));
            float _189 = _171 / _182;
            float _190 = (_176 + _171) / _182;
            float _191 = (((_168 * 2.0f) * _170) * _182) / _182;
            float _192 = _176 / _182;
            float _196 = (((bool)((abs(_192)) < 1.1920928955078125e-07f)) ? 1.0f : (_176 / _192));
            float _199 = _196 + 1.1920928955078125e-07f;
            float _204 = max(1.1920928955078125e-07f, (exp2(log2(_173))));
            float _210 = exp2(log2(((_168 * 0.5f) * _170) + 1.0f));
            float _213 = (_199 * _189) / (_204 + 1.1920928955078125e-07f);
            float _219 = (1.0f - _190) + _191;
            float _220 = _210 - (max(1.1920928955078125e-07f, (exp2(log2(_176 + _173)))));
            float _227 = ((_199 * _219) / (_220 + 1.1920928955078125e-07f)) * 0.6931471824645996f;
            float _229 = ((log2(_220)) * 0.6931471824645996f) - (_227 * (log2(_219)));
            if (_191 > 0.0f) {
              _239 = (-0.0f - (exp2(((_227 * (log2(_191))) + _229) * 1.4426950216293335f)));
            } else {
              _239 = -0.0f;
            }
            _18[0] = 0.0f;
            _18[1] = 0.0f;
            _18[2] = 0.0f;
            _247 = _70;
            _248 = 0;
            while (true) {
              float _249 = _247 * (1.0f / _182);
              if (_249 < _189) {
                if (_249 > 0.0f) {
                  _285 = (exp2((((((log2(_249)) * _213) + (log2(_204))) * 0.6931471824645996f) + ((_213 * -0.6931471824645996f) * (log2(_189)))) * 1.4426950216293335f));
                } else {
                  _285 = 0.0f;
                }
              } else {
                if (_249 < _190) {
                  float _264 = _249 + ((_173 - (_196 * _189)) / _199);
                  if (_264 > 0.0f) {
                    _285 = (exp2((log2(_264)) + (log2(_199))));
                  } else {
                    _285 = 0.0f;
                  }
                } else {
                  float _272 = (-1.0f - _191) + _249;
                  if (_272 < -0.0f) {
                    _282 = (exp2(((_227 * (log2(-0.0f - _272))) + _229) * 1.4426950216293335f));
                  } else {
                    _282 = 0.0f;
                  }
                  _285 = (_210 - _282);
                }
              }
              _18[_248] = (_285 * (1.0f / (_239 + _210)));
              int _288 = _248 + 1;
              if (!(_288 == 3)) {
                _247 = (_17[_288]);
                _248 = _288;
                continue;
              }
              _302 = (_18[0]);
              _303 = (_18[1]);
              _304 = (_18[2]);
              break;
            }
          } else {
            _302 = (saturate(_70));
            _303 = (saturate(_71));
            _304 = (saturate(_72));
          }
        }
      }
    }
    mid_gray = _302;
    _70 = untonemapped.r;
  }

  if (CUSTOM_VANILLA_BY_LUMINANCE != 0) {
    _70 = renodx::color::y::from::BT709(untonemapped);
  }

  if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 0) {
    _302 = (saturate(_70));
    _303 = (saturate(_71));
    _304 = (saturate(_72));
  } else {
    if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 1) {
      _302 = (saturate((((_70 * 2.509999990463257f) + 0.029999999329447746f) * _70) / ((((_70 * 2.430000066757202f) + 0.5899999737739563f) * _70) + 0.14000000059604645f)));
      _303 = (saturate((((_71 * 2.509999990463257f) + 0.029999999329447746f) * _71) / ((((_71 * 2.430000066757202f) + 0.5899999737739563f) * _71) + 0.14000000059604645f)));
      _304 = (saturate((((_72 * 2.509999990463257f) + 0.029999999329447746f) * _72) / ((((_72 * 2.430000066757202f) + 0.5899999737739563f) * _72) + 0.14000000059604645f)));
    } else {
      if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 2) {
        float _119 = ((0.5600000023841858f / PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_000) + 2.430000066757202f) + (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_000 * PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_000));
        _302 = (saturate((((_119 * _70) + 0.029999999329447746f) * _70) / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 + (((_70 * 2.430000066757202f) + 0.5899999737739563f) * _70))));
        _303 = (saturate((((_119 * _71) + 0.029999999329447746f) * _71) / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 + (((_71 * 2.430000066757202f) + 0.5899999737739563f) * _71))));
        _304 = (saturate((((_119 * _72) + 0.029999999329447746f) * _72) / (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_004 + (((_72 * 2.430000066757202f) + 0.5899999737739563f) * _72))));
      } else {
        if ((uint)(stub_PushConstantWrapper_HDRComposite_000.PushConstantWrapper_HDRComposite_004) == 3) {
          _17[0] = _70;
          _17[1] = _71;
          _17[2] = _72;
          float _168 = max(0.0f, (PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_016));
          float _170 = saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_024);
          float _171 = (exp2((log2(saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_012))) * 2.200000047683716f)) * 0.5f;
          float _173 = (1.0f - (saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_008))) * _171;
          float _174 = 1.0f - _173;
          float _176 = (1.0f - (min(0.9999899864196777f, (max(1.1920928955078125e-07f, (saturate(PerSceneConstants_000.SPerSceneConstants_52144.TonemappingParams_020))))))) * _174;
          float _182 = ((_171 + -0.9999998807907104f) + _174) + (exp2(_168));
          float _189 = _171 / _182;
          float _190 = (_176 + _171) / _182;
          float _191 = (((_168 * 2.0f) * _170) * _182) / _182;
          float _192 = _176 / _182;
          float _196 = (((bool)((abs(_192)) < 1.1920928955078125e-07f)) ? 1.0f : (_176 / _192));
          float _199 = _196 + 1.1920928955078125e-07f;
          float _204 = max(1.1920928955078125e-07f, (exp2(log2(_173))));
          float _210 = exp2(log2(((_168 * 0.5f) * _170) + 1.0f));
          float _213 = (_199 * _189) / (_204 + 1.1920928955078125e-07f);
          float _219 = (1.0f - _190) + _191;
          float _220 = _210 - (max(1.1920928955078125e-07f, (exp2(log2(_176 + _173)))));
          float _227 = ((_199 * _219) / (_220 + 1.1920928955078125e-07f)) * 0.6931471824645996f;
          float _229 = ((log2(_220)) * 0.6931471824645996f) - (_227 * (log2(_219)));
          if (_191 > 0.0f) {
            _239 = (-0.0f - (exp2(((_227 * (log2(_191))) + _229) * 1.4426950216293335f)));
          } else {
            _239 = -0.0f;
          }
          _18[0] = 0.0f;
          _18[1] = 0.0f;
          _18[2] = 0.0f;
          _247 = _70;
          _248 = 0;
          while (true) {
            float _249 = _247 * (1.0f / _182);
            if (_249 < _189) {
              if (_249 > 0.0f) {
                _285 = (exp2((((((log2(_249)) * _213) + (log2(_204))) * 0.6931471824645996f) + ((_213 * -0.6931471824645996f) * (log2(_189)))) * 1.4426950216293335f));
              } else {
                _285 = 0.0f;
              }
            } else {
              if (_249 < _190) {
                float _264 = _249 + ((_173 - (_196 * _189)) / _199);
                if (_264 > 0.0f) {
                  _285 = (exp2((log2(_264)) + (log2(_199))));
                } else {
                  _285 = 0.0f;
                }
              } else {
                float _272 = (-1.0f - _191) + _249;
                if (_272 < -0.0f) {
                  _282 = (exp2(((_227 * (log2(-0.0f - _272))) + _229) * 1.4426950216293335f));
                } else {
                  _282 = 0.0f;
                }
                _285 = (_210 - _282);
              }
            }
            _18[_248] = (_285 * (1.0f / (_239 + _210)));
            int _288 = _248 + 1;
            if (!(_288 == 3)) {
              _247 = (_17[_288]);
              _248 = _288;
              continue;
            }
            _302 = (_18[0]);
            _303 = (_18[1]);
            _304 = (_18[2]);
            break;
          }
        } else {
          _302 = (saturate(_70));
          _303 = (saturate(_71));
          _304 = (saturate(_72));
        }
      }
    }
  }

  float _307 = dot(float3(_302, _303, _304), float3(0.21250000596046448f, 0.715399980545044f, 0.07209999859333038f));
  float _314 = ((_302 - _307) * _33) + _307;
  float _315 = ((_303 - _307) * _33) + _307;
  float _316 = ((_304 - _307) * _33) + _307;
  float _338 = (((((((_307 * _23) - _314) * _26) + _314) * _35) - (PerSceneConstants_000.SPerSceneConstants_5056.CameraExposureData_008)) * _37) + (PerSceneConstants_000.SPerSceneConstants_5056.CameraExposureData_008);
  float _339 = (((((((_307 * _24) - _315) * _26) + _315) * _35) - (PerSceneConstants_000.SPerSceneConstants_5056.CameraExposureData_008)) * _37) + (PerSceneConstants_000.SPerSceneConstants_5056.CameraExposureData_008);
  float _340 = (((((((_307 * _25) - _316) * _26) + _316) * _35) - (PerSceneConstants_000.SPerSceneConstants_5056.CameraExposureData_008)) * _37) + (PerSceneConstants_000.SPerSceneConstants_5056.CameraExposureData_008);

  // User Contrast

  float _352 = max(SharedFrameData_000.FrameData_032, 0.0010000000474974513f);

  _352 = 1.f;

  float _359 = ((lerp(_338, _28, _31) * 2.0f) + -1.0f) * _352;
  float _360 = ((lerp(_339, _29, _31) * 2.0f) + -1.0f) * _352;
  float _361 = ((lerp(_340, _30, _31) * 2.0f) + -1.0f) * _352;
  float _366 = (_352 / (sqrt((_352 * _352) + 1.0f))) * 2.0f;

  // float _388 = 1.0f / (max(SharedFrameData_000.FrameData_028, 0.0010000000474974513f));
  // Bethesda thinks the 2.4 in SRGB is "Brightness" and should be user selectable.

  // float _404 = max(((exp2(log2((_359 / (sqrt((_359 * _359) + 1.0f) * _366)) + 0.5f) * _388) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f);
  // float _405 = max(((exp2(log2((_360 / (sqrt((_360 * _360) + 1.0f) * _366)) + 0.5f) * _388) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f);
  // float _406 = max(((exp2(log2((_361 / (sqrt((_361 * _361) + 1.0f) * _366)) + 0.5f) * _388) * 1.0549999475479126f) + -0.054999999701976776f), 0.0f);

  float _404 = (_359 / ((sqrt((_359 * _359) + 1.0f)) * _366)) + 0.5f;
  float _405 = (_360 / ((sqrt((_360 * _360) + 1.0f)) * _366)) + 0.5f;
  float _406 = (_361 / ((sqrt((_361 * _361) + 1.0f)) * _366)) + 0.5f;

  if (CUSTOM_VANILLA_BY_LUMINANCE != 0) {
    float3 by_luminance = untonemapped * renodx::math::DivideSafe(_404, _70, 0);
    by_luminance = renodx::color::correct::Hue(by_luminance, untonemapped, 1.f);

    _404 = by_luminance.r;
    _405 = by_luminance.g;
    _406 = by_luminance.b;
  }

  float3 corrected_color = renodx::color::correct::Hue(
      float3(_404, _405, _406),
      untonemapped,
      1.f);

  _404 = corrected_color.r;
  _405 = corrected_color.g;
  _406 = corrected_color.b;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.lut_sampler = s0;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.tetrahedral = false;
  lut_config.type_input = renodx::lut::config::type::SRGB;
  lut_config.type_output = renodx::lut::config::type::SRGB;
  lut_config.size = 16u;
  lut_config.recolor = 0.f;  // imprecise
  float3 lut_output_color = renodx::lut::Sample(float3(_404, _405, _406), lut_config, t3);

  float3 mid_gray_lut = renodx::lut::Sample((mid_gray).xxx, lut_config, t3);
  mid_gray = renodx::color::y::from::BT709(mid_gray_lut);

  // float3 _415 = t3.Sample(s0, float3(((_404 * 0.9375f) + 0.03125f), ((_405 * 0.9375f) + 0.03125f), ((_406 * 0.9375f) + 0.03125f)));
  float3 _415 = renodx::color::srgb::EncodeSafe(lut_output_color);

  float _420 = t1.Sample(s0, float2(TEXCOORD.x, TEXCOORD.y));

  // Lerp LUT strength by _420
  float _428 = (_420.x * (_404 - _415.x)) + _415.x;
  float _429 = (_420.x * (_405 - _415.y)) + _415.y;
  float _430 = (_420.x * (_406 - _415.z)) + _415.z;

  // if (!(((uint)(SharedFrameData_000.FrameData_036)) == 0)) {
  if (false && !(((uint)(SharedFrameData_000.FrameData_036)) == 0)) {
    float3 _435 = t3.Sample(s0, float3(0.03125f, 0.03125f, 0.03125f));
    float3 _439 = t3.Sample(s0, float3(0.96875f, 0.96875f, 0.96875f));
    float _444 = min(_435.x, (min(_435.y, _435.z)));
    float _449 = 1.0f / (max(0.0f, ((max(_439.x, (max(_439.y, _439.z)))) - _444)));
    float _456 = saturate(_449 * (_428 - _444));
    float _457 = saturate(_449 * (_429 - _444));
    float _458 = saturate(_449 * (_430 - _444));
    float _479 = exp2((log2(_456)) * SharedFrameData_000.FrameData_044);
    float _480 = exp2((log2(_457)) * SharedFrameData_000.FrameData_044);
    float _481 = exp2((log2(_458)) * SharedFrameData_000.FrameData_044);
    _505 = ((SharedFrameData_000.FrameData_040 * (((_479 * (1.0f - (exp2((_456 * _456) * -14.42694091796875f)))) - _428) + ((1.0f - _479) * _456))) + _428);
    _506 = ((SharedFrameData_000.FrameData_040 * (((_480 * (1.0f - (exp2((_457 * _457) * -14.42694091796875f)))) - _429) + ((1.0f - _480) * _457))) + _429);
    _507 = (((((_481 * (1.0f - (exp2((_458 * _458) * -14.42694091796875f)))) - _430) + ((1.0f - _481) * _458)) * SharedFrameData_000.FrameData_040) + _430);
  } else {
    _505 = _428;
    _506 = _429;
    _507 = _430;
  }
  SV_Target.x = _505;
  SV_Target.y = _506;
  SV_Target.z = _507;
  SV_Target.w = 1.0f;

  float3 vanilla_linear = renodx::color::srgb::DecodeSafe(SV_Target.rgb);
  float3 color = vanilla_linear;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    color = renodx::draw::ToneMapPass(untonemapped * mid_gray / 0.18f, vanilla_linear);
  } else {
    color = max(0, color);
  }
  SV_Target.rgb = renodx::draw::RenderIntermediatePass(color);

  return SV_Target;
}
