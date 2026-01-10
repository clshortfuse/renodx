#include "common.hlsli"

struct CustomDepthMapParams__Constants {
  int CustomDepthMapParams__Constants_000;
  int CustomDepthMapParams__Constants_004;
  float4 CustomDepthMapParams__Constants_008[4];
};

struct IndoorDepthMapParams__Constants {
  float4 IndoorDepthMapParams__Constants_000[4];
  int2 IndoorDepthMapParams__Constants_064;
  int IndoorDepthMapParams__Constants_072;
};

struct ReverseProjParams__Constants {
  float4 ReverseProjParams__Constants_000[4];
  float4 ReverseProjParams__Constants_064[4];
  float4 ReverseProjParams__Constants_128[4];
  float4 ReverseProjParams__Constants_192;
};

struct VolumetricCloudShadow__Constants {
  float4 VolumetricCloudShadow__Constants_000;
  float4 VolumetricCloudShadow__Constants_016;
  float4 VolumetricCloudShadow__Constants_032;
  float3 VolumetricCloudShadow__Constants_048;
  float VolumetricCloudShadow__Constants_060;
  int VolumetricCloudShadow__Constants_064;
  float VolumetricCloudShadow__Constants_068;
  float4 VolumetricCloudShadow__Constants_072[3];
  float4 VolumetricCloudShadow__Constants_120[3];
};

// clang-format off
struct PassParams__Constants {
  float4 PassParams__Constants_000;
  float4 PassParams__Constants_016;
  float4 PassParams__Constants_032;
  float4 PassParams__Constants_048;
  float4 PassParams__Constants_064[4];
  float4 PassParams__Constants_128[4];
  float4 PassParams__Constants_192[4];
  float4 PassParams__Constants_256[4];
  float4 PassParams__Constants_320[4];
  float4 PassParams__Constants_384[4];
  float4 PassParams__Constants_448[4];
  float4 PassParams__Constants_512[4];
  float4 PassParams__Constants_576[4];
  float4 PassParams__Constants_640[4];
  float4 PassParams__Constants_704[4];
  float4 PassParams__Constants_768[4];
  float4 PassParams__Constants_832[4];
  float4 PassParams__Constants_896;
  float4 PassParams__Constants_912;
  float4 PassParams__Constants_928;
  float4 PassParams__Constants_944;
  float4 PassParams__Constants_960;
  float4 PassParams__Constants_976;
  float4 PassParams__Constants_992;
  float4 PassParams__Constants_1008;
  float4 PassParams__Constants_1024;
  float4 PassParams__Constants_1040;
  float4 PassParams__Constants_1056;
  float4 PassParams__Constants_1072[4];
  float4 PassParams__Constants_1136;
  float4 PassParams__Constants_1152;
  float4 PassParams__Constants_1168;
  float4 PassParams__Constants_1184;
  float PassParams__Constants_1200;
  float PassParams__Constants_1204;
  float PassParams__Constants_1208;
  float PassParams__Constants_1212;
  int PassParams__Constants_1216;
  int PassParams__Constants_1220;
  int PassParams__Constants_1224;
  int PassParams__Constants_1228;
  int PassParams__Constants_1232;
  int PassParams__Constants_1236;
  int PassParams__Constants_1240;
  int PassParams__Constants_1244;
  int PassParams__Constants_1248;
  int PassParams__Constants_1252;
  ReverseProjParams__Constants PassParams__Constants_1256;
  struct AerialPerspectiveVolumeParams__Constants {
    int AerialPerspectiveVolumeParams__Constants_000;
    float AerialPerspectiveVolumeParams__Constants_004;
    float AerialPerspectiveVolumeParams__Constants_008;
    float2 AerialPerspectiveVolumeParams__Constants_012;
  } PassParams__Constants_1464;
  struct AmbientLightingParams__Constants {
    float AmbientLightingParams__Constants_000;
    float AmbientLightingParams__Constants_004;
    float AmbientLightingParams__Constants_008;
    float AmbientLightingParams__Constants_012;
    float AmbientLightingParams__Constants_016;
    float AmbientLightingParams__Constants_020;
    float AmbientLightingParams__Constants_024;
    int AmbientLightingParams__Constants_028;
    int AmbientLightingParams__Constants_032;
    float3 AmbientLightingParams__Constants_036;
    int4 AmbientLightingParams__Constants_048;
    int AmbientLightingParams__Constants_064;
  } PassParams__Constants_1484;
  VolumetricCloudShadow__Constants PassParams__Constants_1552;
  struct ClusteredDecalsEvaluateParams__Constants {
    float4 ClusteredDecalsEvaluateParams__Constants_000;
    float4 ClusteredDecalsEvaluateParams__Constants_016;
    float4 ClusteredDecalsEvaluateParams__Constants_032;
    int ClusteredDecalsEvaluateParams__Constants_048;
    int ClusteredDecalsEvaluateParams__Constants_052;
    int ClusteredDecalsEvaluateParams__Constants_056;
    int ClusteredDecalsEvaluateParams__Constants_060;
  } PassParams__Constants_1720;
  struct ClusteredWorldVoxelColorEvaluateParams__Constants {
    float4 ClusteredWorldVoxelColorEvaluateParams__Constants_000;
    float4 ClusteredWorldVoxelColorEvaluateParams__Constants_016;
    float4 ClusteredWorldVoxelColorEvaluateParams__Constants_032;
    int ClusteredWorldVoxelColorEvaluateParams__Constants_048;
    int ClusteredWorldVoxelColorEvaluateParams__Constants_052;
    int ClusteredWorldVoxelColorEvaluateParams__Constants_056;
    int ClusteredWorldVoxelColorEvaluateParams__Constants_060;
    int ClusteredWorldVoxelColorEvaluateParams__Constants_064;
  } PassParams__Constants_1784;
  struct CombinedCloudShadow__Constants {
    float4 CombinedCloudShadow__Constants_000;
    float4 CombinedCloudShadow__Constants_016;
    float2 CombinedCloudShadow__Constants_032;
    float4 CombinedCloudShadow__Constants_040;
    float CombinedCloudShadow__Constants_056;
  } PassParams__Constants_1852;
  CustomDepthMapParams__Constants PassParams__Constants_1912;
  struct DeferredCommonParams__Constants {
    float4 DeferredCommonParams__Constants_000;
    float DeferredCommonParams__Constants_016;
  } PassParams__Constants_1984;
  struct DynamicWindParams__Constants {
    float3 DynamicWindParams__Constants_000;
    float3 DynamicWindParams__Constants_012;
    float DynamicWindParams__Constants_024;
    float2 DynamicWindParams__Constants_028;
    float2 DynamicWindParams__Constants_036;
    float DynamicWindParams__Constants_044;
    float DynamicWindParams__Constants_048;
    int DynamicWindParams__Constants_052;
    float4 DynamicWindParams__Constants_056[4];
    float4 DynamicWindParams__Constants_120[4];
    float4 DynamicWindParams__Constants_184[4];
    float4 DynamicWindParams__Constants_248[4];
  } PassParams__Constants_2004;
  struct FarShadowParams__Constants {
    float FarShadowParams__Constants_000;
  } PassParams__Constants_2316;
  struct VolumetricFogParams__Constants {
    float4 VolumetricFogParams__Constants_000;
    float4 VolumetricFogParams__Constants_016;
    float4 VolumetricFogParams__Constants_032;
    float4 VolumetricFogParams__Constants_048;
    float4 VolumetricFogParams__Constants_064;
    float4 VolumetricFogParams__Constants_080;
    float4 VolumetricFogParams__Constants_096;
    float4 VolumetricFogParams__Constants_112;
    float4 VolumetricFogParams__Constants_128;
    float4 VolumetricFogParams__Constants_144;
    float3 VolumetricFogParams__Constants_160;
    float3 VolumetricFogParams__Constants_172;
    float3 VolumetricFogParams__Constants_184[10];
    int1 VolumetricFogParams__Constants_304;
    float2 VolumetricFogParams__Constants_308;
    int VolumetricFogParams__Constants_316;
    float VolumetricFogParams__Constants_320;
  } PassParams__Constants_2320;
  struct GenericStamperParams__Constants {
    int GenericStamperParams__Constants_000;
    float2 GenericStamperParams__Constants_004[4];
    int2 GenericStamperParams__Constants_036;
    float GenericStamperParams__Constants_044[4];
    int3 GenericStamperParams__Constants_060;
    float GenericStamperParams__Constants_072[4];
    int3 GenericStamperParams__Constants_088;
    float2 GenericStamperParams__Constants_100[4];
    int2 GenericStamperParams__Constants_132;
    float4 GenericStamperParams__Constants_140[4];
    float2 GenericStamperParams__Constants_204[4];
    int2 GenericStamperParams__Constants_236;
    float4 GenericStamperParams__Constants_244[4];
  } PassParams__Constants_2644;
  struct GrassForceSamplingParams__Constants {
    float2 GrassForceSamplingParams__Constants_000;
    float2 GrassForceSamplingParams__Constants_008;
    float2 GrassForceSamplingParams__Constants_016;
    float2 GrassForceSamplingParams__Constants_024;
    float GrassForceSamplingParams__Constants_032;
    float GrassForceSamplingParams__Constants_036;
  } PassParams__Constants_2952;
  IndoorDepthMapParams__Constants PassParams__Constants_2992;
  struct LocalizedSkyLightingParams__Constants {
    float4 LocalizedSkyLightingParams__Constants_000;
    float LocalizedSkyLightingParams__Constants_016;
    float LocalizedSkyLightingParams__Constants_020;
    float LocalizedSkyLightingParams__Constants_024;
    float LocalizedSkyLightingParams__Constants_028;
  } PassParams__Constants_3068;
  struct LocalLightsEvaluateParams__Constants {
    struct TiledZBinLightsEvaluateParams__Constants {
      int4 TiledZBinLightsEvaluateParams__Constants_000;
      int TiledZBinLightsEvaluateParams__Constants_016;
    } LocalLightsEvaluateParams__Constants_000;
  } PassParams__Constants_3100;
  struct LongRangeShadowsParams__Constants {
    int LongRangeShadowsParams__Constants_000;
    float LongRangeShadowsParams__Constants_004;
    float LongRangeShadowsParams__Constants_008;
    float LongRangeShadowsParams__Constants_012;
    float LongRangeShadowsParams__Constants_016;
    float LongRangeShadowsParams__Constants_020;
    int LongRangeShadowsParams__Constants_024;
  } PassParams__Constants_3120;
  struct NearShadowParams__Constants {
    int NearShadowParams__Constants_000;
  } PassParams__Constants_3148;
  struct OmnidirectionalLocalLightsEvaluateParams__Constants {
    struct OmnidirectionalClusteredLightsEvaluateParams__Constants {
      float4 OmnidirectionalClusteredLightsEvaluateParams__Constants_000;
    } OmnidirectionalLocalLightsEvaluateParams__Constants_000;
  } PassParams__Constants_3152;
  struct OpacitySlices__Constants {
    float OpacitySlices__Constants_000;
    float2 OpacitySlices__Constants_004;
    float2 OpacitySlices__Constants_012;
    float4 OpacitySlices__Constants_020[10];
  } PassParams__Constants_3168;
  struct OpaqueLightingCommonParams__Constants {
    int4 OpaqueLightingCommonParams__Constants_000;
    int2 OpaqueLightingCommonParams__Constants_016;
    int OpaqueLightingCommonParams__Constants_024;
    float4 OpaqueLightingCommonParams__Constants_028;
  } PassParams__Constants_3348;
  struct PreintergratedSSSParams__Constants {
    int PreintergratedSSSParams__Constants_000;
    int PreintergratedSSSParams__Constants_004;
  } PassParams__Constants_3392;
  struct RainBlockerParams__Constants {
    float4 RainBlockerParams__Constants_000;
    float2 RainBlockerParams__Constants_016;
  } PassParams__Constants_3400;
  struct ReadbackTextureStreamingMipFeedbackParams__Constants {
    int ReadbackTextureStreamingMipFeedbackParams__Constants_000;
    int ReadbackTextureStreamingMipFeedbackParams__Constants_004;
    float ReadbackTextureStreamingMipFeedbackParams__Constants_008;
    float ReadbackTextureStreamingMipFeedbackParams__Constants_012;
  } PassParams__Constants_3424;
  struct RTGILightingParams__Constants {
    float RTGILightingParams__Constants_000;
  } PassParams__Constants_3440;
  struct RTSpecularParams__Constants {
    float RTSpecularParams__Constants_000;
  } PassParams__Constants_3444;
  struct SnowDisplacementParams__Constants {
    int SnowDisplacementParams__Constants_000;
    int SnowDisplacementParams__Constants_004;
    int SnowDisplacementParams__Constants_008;
    int SnowDisplacementParams__Constants_012;
    float2 SnowDisplacementParams__Constants_016;
    float4 SnowDisplacementParams__Constants_024;
    int2 SnowDisplacementParams__Constants_040;
    float2 SnowDisplacementParams__Constants_048;
    float4 SnowDisplacementParams__Constants_056;
    float2 SnowDisplacementParams__Constants_072;
    float SnowDisplacementParams__Constants_080;
  } PassParams__Constants_3448;
  struct SnowRemoverMaskParams__Constants {
    float4 SnowRemoverMaskParams__Constants_000;
    float4 SnowRemoverMaskParams__Constants_016;
    float2 SnowRemoverMaskParams__Constants_032;
    float SnowRemoverMaskParams__Constants_040;
    float SnowRemoverMaskParams__Constants_044;
  } PassParams__Constants_3532;
  struct TerrainDeformationParams__Constants {
    int TerrainDeformationParams__Constants_000;
  } PassParams__Constants_3580;
  struct TerrainFrameParams2__Constants {
    float TerrainFrameParams2__Constants_000;
    float TerrainFrameParams2__Constants_004;
    float TerrainFrameParams2__Constants_008;
    float TerrainFrameParams2__Constants_012;
    int TerrainFrameParams2__Constants_016;
    int TerrainFrameParams2__Constants_020;
    float TerrainFrameParams2__Constants_024;
    float TerrainFrameParams2__Constants_028;
    float TerrainFrameParams2__Constants_032;
    float TerrainFrameParams2__Constants_036;
    float4 TerrainFrameParams2__Constants_040;
    float TerrainFrameParams2__Constants_056;
    float TerrainFrameParams2__Constants_060;
    float TerrainFrameParams2__Constants_064;
    int TerrainFrameParams2__Constants_068;
    float TerrainFrameParams2__Constants_072;
    float TerrainFrameParams2__Constants_076;
    float TerrainFrameParams2__Constants_080;
    float TerrainFrameParams2__Constants_084;
    float TerrainFrameParams2__Constants_088;
    float TerrainFrameParams2__Constants_092;
    float TerrainFrameParams2__Constants_096;
    float TerrainFrameParams2__Constants_100;
    int TerrainFrameParams2__Constants_104;
    float TerrainFrameParams2__Constants_108;
    float TerrainFrameParams2__Constants_112;
    float TerrainFrameParams2__Constants_116;
    float TerrainFrameParams2__Constants_120;
    float3 TerrainFrameParams2__Constants_124;
    float TerrainFrameParams2__Constants_136;
    float TerrainFrameParams2__Constants_140;
    float TerrainFrameParams2__Constants_144;
    float TerrainFrameParams2__Constants_148;
    float TerrainFrameParams2__Constants_152;
    float TerrainFrameParams2__Constants_156;
    float TerrainFrameParams2__Constants_160;
    float TerrainFrameParams2__Constants_164;
    int TerrainFrameParams2__Constants_168;
    int TerrainFrameParams2__Constants_172;
    int TerrainFrameParams2__Constants_176;
    int TerrainFrameParams2__Constants_180;
  } PassParams__Constants_3584;
  struct ToolModeParams__Constants {
    float4 ToolModeParams__Constants_000;
    float4 ToolModeParams__Constants_016;
    float4 ToolModeParams__Constants_032;
    int ToolModeParams__Constants_048;
    int ToolModeParams__Constants_052;
    int ToolModeParams__Constants_056;
    float4 ToolModeParams__Constants_060;
    float4 ToolModeParams__Constants_076;
    float4 ToolModeParams__Constants_092;
    float4 ToolModeParams__Constants_108;
    int4 ToolModeParams__Constants_124;
    int4 ToolModeParams__Constants_140;
    int4 ToolModeParams__Constants_156;
    int4 ToolModeParams__Constants_172;
    float4 ToolModeParams__Constants_188;
    int ToolModeParams__Constants_204;
  } PassParams__Constants_3768;
  struct UIPassParams__Constants {
    int UIPassParams__Constants_000;
  } PassParams__Constants_3976;
  struct UnderwaterLightingParams__Constants {
    float3 UnderwaterLightingParams__Constants_000;
  } PassParams__Constants_3980;
  struct VertexPickingParams__Constants {
    float2 VertexPickingParams__Constants_000[2];
    int2 VertexPickingParams__Constants_016;
    float2 VertexPickingParams__Constants_024;
    float VertexPickingParams__Constants_032;
    float VertexPickingParams__Constants_036;
    float VertexPickingParams__Constants_040;
    int VertexPickingParams__Constants_044;
  } PassParams__Constants_3992;
  struct WaterBaseLevelParams__Constants {
    float4 WaterBaseLevelParams__Constants_000;
    float4 WaterBaseLevelParams__Constants_016;
    float4 WaterBaseLevelParams__Constants_032;
    float2 WaterBaseLevelParams__Constants_048;
  } PassParams__Constants_4040;
  struct WaterCustomMeshParams__Constants {
    float3 WaterCustomMeshParams__Constants_000;
  } PassParams__Constants_4096;
  struct WaterStamperTextureParams__Constants {
    float4 WaterStamperTextureParams__Constants_000;
    float WaterStamperTextureParams__Constants_016;
  } PassParams__Constants_4108;
};
// clang-format on

StructuredBuffer<float> t0_space1 : register(t0, space1);

Texture2D<float4> t0_space3 : register(t0, space3);

Texture3D<float2> t1_space3 : register(t1, space3);

Texture2D<float> t2_space3 : register(t2, space3);

// clang-format off
cbuffer cb1 : register(b1) {
  struct SkyLightingValues {
    float4 SkyLightingValues_000[7];
    float3 SkyLightingValues_112;
  } FrameParams_skylighting_SkyConstants_cbuffer_000 : packoffset(c000.x);
};

cbuffer cb0_space1 : register(b0, space1) {
  float cb0_space1_071x : packoffset(c071.x);
};

cbuffer cb0_space3 : register(b0, space3) {
  struct LocalToneMappingBilateralGridParams__Constants {
    float LocalToneMappingBilateralGridParams__Constants_000;
    float LocalToneMappingBilateralGridParams__Constants_004;
    float LocalToneMappingBilateralGridParams__Constants_008;
    float LocalToneMappingBilateralGridParams__Constants_012;
    float LocalToneMappingBilateralGridParams__Constants_016;
    float LocalToneMappingBilateralGridParams__Constants_020;
    float LocalToneMappingBilateralGridParams__Constants_024;
    float LocalToneMappingBilateralGridParams__Constants_028;
    float LocalToneMappingBilateralGridParams__Constants_032;
    float LocalToneMappingBilateralGridParams__Constants_036;
    float LocalToneMappingBilateralGridParams__Constants_040;
    int LocalToneMappingBilateralGridParams__Constants_044;
  } LocalToneMappingBilateralGridParams_cbuffer_000 : packoffset(c000.x);
};
// clang-format on

SamplerState s0_space99 : register(s0, space99);

SamplerState s8_space98 : register(s8, space98);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _12 = t0_space3.SampleLevel(s0_space99, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  float3 untonemapped = _12.rgb;

  float _16 = dot(float3(_12.x, _12.y, _12.z), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));

  bool _17 = (_16 == 0.0f);
  float _169;
  if (!_17) {
    float _21 = t0_space1.Load(3);
    float _23 = t0_space1.Load(0);
    float _27 = _21.x * 983.52001953125f;
    float _28 = _27 * _23.x;
    float _29 = _28 * cb0_space1_071x;
    float _30 = log2(_29);
    float _33 = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_000 * 0.5f;
    float _34 = _30 - _33;
    float _35 = 1.0f / LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_000;
    float _36 = _34 * _35;
    bool _37 = (_16 > 9.99999993922529e-09f);
    float _38 = _16 * 5464.0f;
    float _39 = log2(_38);
    float _40 = select(_37, _39, -14.159683227539062f);
    float _41 = _40 - _34;
    float _42 = _41 * _35;
    float _43 = saturate(_42);
    float2 _44 = t1_space3.SampleLevel(s8_space98, float3(TEXCOORD.x, TEXCOORD.y, _43), 0.0f);
    float _47 = max(_44.y, 1.0000000116860974e-07f);
    float _48 = _44.x / _47;
    float _49 = _48 + _36;
    float _50 = _49 / _35;
    float _51 = t2_space3.SampleLevel(s8_space98, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _53 = _51.x * 5464.0f;
    float _54 = log2(_53);
    float _71 = dot(float4((FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[0].x), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[0].y), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[0].z), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[0].w)), float4(0.0f, 0.0f, 0.0f, 1.0f));
    float _77 = dot(float4((FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[1].x), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[1].y), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[1].z), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[1].w)), float4(0.0f, 0.0f, 0.0f, 1.0f));
    float _83 = dot(float4((FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[2].x), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[2].y), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[2].z), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[2].w)), float4(0.0f, 0.0f, 0.0f, 1.0f));
    float _89 = dot(float4((FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[3].x), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[3].y), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[3].z), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[3].w)), float4(0.0f, 0.0f, 0.0f, 0.0f));
    float _95 = dot(float4((FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[4].x), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[4].y), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[4].z), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[4].w)), float4(0.0f, 0.0f, 0.0f, 0.0f));
    float _101 = dot(float4((FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[5].x), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[5].y), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[5].z), (FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[5].w)), float4(0.0f, 0.0f, 0.0f, 0.0f));
    float _102 = _89 + _71;
    float _103 = _95 + _77;
    float _104 = _101 + _83;
    float _105 = max(0.0f, _102);
    float _106 = max(0.0f, _103);
    float _107 = max(0.0f, _104);
    float _108 = max(0.0f, _105);
    float _109 = max(0.0f, _106);
    float _110 = max(0.0f, _107);
    float _111 = dot(float3(_108, _109, _110), float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
    float _112 = _21.x * 5464.0f;
    float _113 = log2(_112);
    float _114 = _111 * 5464.0f;
    float _115 = log2(_114);
    float _116 = _111 * 10928.0f;
    float _117 = log2(_116);
    float _118 = _115 - _113;
    float _119 = _117 - _113;
    float _120 = _119 * 6.0f;
    float _121 = max(0.0f, _118);
    float _122 = max(0.0f, _120);
    float _123 = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_032 / LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_004;
    float _124 = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_036 / LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_008;
    float _125 = max(1.0f, _123);
    float _126 = max(1.0f, _124);
    float _127 = _121 * LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_020;
    float _128 = _122 * LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_024;
    float _129 = min(_127, _125);
    float _130 = min(_128, _126);
    float _131 = max(1.0f, _129);
    float _132 = max(1.0f, _130);
    float _133 = _121 * LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_028;
    float _134 = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_016 + _30;
    float _135 = _134 - _133;
    float _136 = _54 - _50;
    float _137 = _136 * LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_040;
    float _138 = _137 + _50;
    float _139 = _138 - _135;
    float _140 = _40 - _138;
    bool _141 = (_139 > 0.0f);
    bool _142 = (_139 < 0.0f);
    int _143 = (int)(uint)(_141);
    int _144 = (int)(uint)(_142);
    int _145 = _143 - _144;
    int _146 = max(0, _145);
    float _147 = float(_146);
    float _148 = 1.0f - _147;
    float _149 = _131 * LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_004;
    float _150 = _149 * _147;
    float _151 = _132 * LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_008;

#if 1
    _150 *= CUSTOM_LOCAL_TONEMAP_SHOULDER;
    _151 *= CUSTOM_LOCAL_TONEMAP_TOE;
#endif

    float _152 = _151 * _148;
    float _153 = 1.0f - _150;
    float _154 = _153 - _152;
    float _155 = _154 * _139;
    float _156 = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_012 * _140;
    float _157 = _135 + _156;
    float _158 = _157 + _155;
    float _159 = exp2(_158);
    float _160 = _159 * 0.0001830161054385826f;
    float _161 = _160 / _16;
    int _162 = asint(_161);
    int _163 = _162 & 2139095040;
    bool _164 = ((uint)_163 > (uint)2139095039);
    bool _165 = isinf(_161);
    bool _166 = _165 || _164;
    float _167 = select(_166, 1.0f, _161);
    _169 = _167;
  } else {
    _169 = 1.0f;
  }

  SV_Target.rgb = _169 * _12.rgb;
#if 1
  if (CUSTOM_LOCAL_TONEMAP_TYPE != 0.f) {
    // clamp chrominance gain to limit shadow smearing
    SV_Target.rgb = HueAndChrominanceOKLab(SV_Target.rgb, untonemapped, 1.f, 1.f, 0.f, 1.f);
  }
#endif
  SV_Target.w = 1.0f;
  return SV_Target;
}
