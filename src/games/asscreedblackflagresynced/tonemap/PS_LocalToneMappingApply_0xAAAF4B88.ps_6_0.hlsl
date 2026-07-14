#include "./tonemap.hlsli"

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

struct AerialPerspectiveVolumeParams__Constants {
  int AerialPerspectiveVolumeParams__Constants_000;
  float AerialPerspectiveVolumeParams__Constants_004;
  float AerialPerspectiveVolumeParams__Constants_008;
  float2 AerialPerspectiveVolumeParams__Constants_012;
};

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
  int AmbientLightingParams__Constants_048;
  int4 AmbientLightingParams__Constants_052;
  int AmbientLightingParams__Constants_068;
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

struct ClusteredDecalsEvaluateParams__Constants {
  float4 ClusteredDecalsEvaluateParams__Constants_000;
  float4 ClusteredDecalsEvaluateParams__Constants_016;
  float4 ClusteredDecalsEvaluateParams__Constants_032;
  int ClusteredDecalsEvaluateParams__Constants_048;
  int ClusteredDecalsEvaluateParams__Constants_052;
  int ClusteredDecalsEvaluateParams__Constants_056;
};

struct ClusteredWorldVoxelColorEvaluateParams__Constants {
  float4 ClusteredWorldVoxelColorEvaluateParams__Constants_000;
  float4 ClusteredWorldVoxelColorEvaluateParams__Constants_016;
  float4 ClusteredWorldVoxelColorEvaluateParams__Constants_032;
  int ClusteredWorldVoxelColorEvaluateParams__Constants_048;
  int ClusteredWorldVoxelColorEvaluateParams__Constants_052;
  int ClusteredWorldVoxelColorEvaluateParams__Constants_056;
  int ClusteredWorldVoxelColorEvaluateParams__Constants_060;
  int ClusteredWorldVoxelColorEvaluateParams__Constants_064;
};

struct CombinedCloudShadow__Constants {
  float4 CombinedCloudShadow__Constants_000;
  float4 CombinedCloudShadow__Constants_016;
  float2 CombinedCloudShadow__Constants_032;
  float4 CombinedCloudShadow__Constants_040;
  float CombinedCloudShadow__Constants_056;
};

struct DeferredCommonParams__Constants {
  float4 DeferredCommonParams__Constants_000;
  float DeferredCommonParams__Constants_016;
};

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
};

struct FarShadowParams__Constants {
  float FarShadowParams__Constants_000;
};

struct VolumetricFogParams__Constants {
  int VolumetricFogParams__Constants_000;
  float4 VolumetricFogParams__Constants_004;
  float4 VolumetricFogParams__Constants_020;
  float4 VolumetricFogParams__Constants_036;
  float4 VolumetricFogParams__Constants_052;
  float4 VolumetricFogParams__Constants_068;
  float4 VolumetricFogParams__Constants_084;
  float4 VolumetricFogParams__Constants_100;
  float4 VolumetricFogParams__Constants_116;
  float4 VolumetricFogParams__Constants_132;
  float4 VolumetricFogParams__Constants_148;
  float3 VolumetricFogParams__Constants_164;
  float3 VolumetricFogParams__Constants_176;
  float3 VolumetricFogParams__Constants_188[10];
  int1 VolumetricFogParams__Constants_308;
  float2 VolumetricFogParams__Constants_312;
  int VolumetricFogParams__Constants_320;
  float VolumetricFogParams__Constants_324;
};

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
};

struct GrassForceSamplingParams__Constants {
  float2 GrassForceSamplingParams__Constants_000;
  float2 GrassForceSamplingParams__Constants_008;
  float2 GrassForceSamplingParams__Constants_016;
  float2 GrassForceSamplingParams__Constants_024;
  float GrassForceSamplingParams__Constants_032;
  float GrassForceSamplingParams__Constants_036;
};

struct LocalizedSkyLightingParams__Constants {
  float4 LocalizedSkyLightingParams__Constants_000;
  float LocalizedSkyLightingParams__Constants_016;
  float LocalizedSkyLightingParams__Constants_020;
  float LocalizedSkyLightingParams__Constants_024;
  float LocalizedSkyLightingParams__Constants_028;
};

struct TiledZBinLightsEvaluateParams__Constants {
  int4 TiledZBinLightsEvaluateParams__Constants_000;
  int TiledZBinLightsEvaluateParams__Constants_016;
};

struct LocalLightsEvaluateParams__Constants {
  TiledZBinLightsEvaluateParams__Constants LocalLightsEvaluateParams__Constants_000;
};

struct LongRangeShadowsParams__Constants {
  int LongRangeShadowsParams__Constants_000;
  float LongRangeShadowsParams__Constants_004;
  float LongRangeShadowsParams__Constants_008;
  float LongRangeShadowsParams__Constants_012;
  float LongRangeShadowsParams__Constants_016;
  float LongRangeShadowsParams__Constants_020;
  int LongRangeShadowsParams__Constants_024;
};

struct NearShadowParams__Constants {
  int NearShadowParams__Constants_000;
};

struct OmnidirectionalClusteredLightsEvaluateParams__Constants {
  float4 OmnidirectionalClusteredLightsEvaluateParams__Constants_000;
};

struct OmnidirectionalLocalLightsEvaluateParams__Constants {
  OmnidirectionalClusteredLightsEvaluateParams__Constants OmnidirectionalLocalLightsEvaluateParams__Constants_000;
};

struct OpacitySlices__Constants {
  float OpacitySlices__Constants_000;
  float2 OpacitySlices__Constants_004;
  float2 OpacitySlices__Constants_012;
  float4 OpacitySlices__Constants_020[10];
};

struct OpaqueLightingCommonParams__Constants {
  int4 OpaqueLightingCommonParams__Constants_000;
  int2 OpaqueLightingCommonParams__Constants_016;
  int OpaqueLightingCommonParams__Constants_024;
  float4 OpaqueLightingCommonParams__Constants_028;
};

struct PreintergratedSSSParams__Constants {
  int PreintergratedSSSParams__Constants_000;
  int PreintergratedSSSParams__Constants_004;
};

struct RainBlockerParams__Constants {
  float4 RainBlockerParams__Constants_000;
  float2 RainBlockerParams__Constants_016;
};

struct ReadbackTextureStreamingMipFeedbackParams__Constants {
  int ReadbackTextureStreamingMipFeedbackParams__Constants_000;
  int ReadbackTextureStreamingMipFeedbackParams__Constants_004;
  float ReadbackTextureStreamingMipFeedbackParams__Constants_008;
  float ReadbackTextureStreamingMipFeedbackParams__Constants_012;
};

struct RTGILightingParams__Constants {
  float RTGILightingParams__Constants_000;
};

struct RTSpecularParams__Constants {
  float RTSpecularParams__Constants_000;
};

struct SnowDisplacementParams__Constants {
  float4 SnowDisplacementParams__Constants_000;
};

struct SnowRemoverMaskParams__Constants {
  float4 SnowRemoverMaskParams__Constants_000;
  float4 SnowRemoverMaskParams__Constants_016;
  float2 SnowRemoverMaskParams__Constants_032;
  float SnowRemoverMaskParams__Constants_040;
  float SnowRemoverMaskParams__Constants_044;
};

struct TerrainDeformationParams__Constants {
  int TerrainDeformationParams__Constants_000;
};

struct TerrainFrameParams2__Constants {
  float TerrainFrameParams2__Constants_000;
  float TerrainFrameParams2__Constants_004;
  float TerrainFrameParams2__Constants_008;
  float TerrainFrameParams2__Constants_012;
  int TerrainFrameParams2__Constants_016;
  int TerrainFrameParams2__Constants_020;
  int TerrainFrameParams2__Constants_024;
  float TerrainFrameParams2__Constants_028;
  float TerrainFrameParams2__Constants_032;
  float TerrainFrameParams2__Constants_036;
  float TerrainFrameParams2__Constants_040;
  float4 TerrainFrameParams2__Constants_044;
  float TerrainFrameParams2__Constants_060;
  float TerrainFrameParams2__Constants_064;
  float TerrainFrameParams2__Constants_068;
  int TerrainFrameParams2__Constants_072;
  float TerrainFrameParams2__Constants_076;
  float TerrainFrameParams2__Constants_080;
  float TerrainFrameParams2__Constants_084;
  float TerrainFrameParams2__Constants_088;
  float TerrainFrameParams2__Constants_092;
  float TerrainFrameParams2__Constants_096;
  float TerrainFrameParams2__Constants_100;
  float TerrainFrameParams2__Constants_104;
  float TerrainFrameParams2__Constants_108;
  int TerrainFrameParams2__Constants_112;
  float TerrainFrameParams2__Constants_116;
  float TerrainFrameParams2__Constants_120;
  float TerrainFrameParams2__Constants_124;
  float TerrainFrameParams2__Constants_128;
  float TerrainFrameParams2__Constants_132;
  float3 TerrainFrameParams2__Constants_136;
  float TerrainFrameParams2__Constants_148;
  float TerrainFrameParams2__Constants_152;
  float TerrainFrameParams2__Constants_156;
  float TerrainFrameParams2__Constants_160;
  float TerrainFrameParams2__Constants_164;
  float TerrainFrameParams2__Constants_168;
  int TerrainFrameParams2__Constants_172;
  int TerrainFrameParams2__Constants_176;
  int TerrainFrameParams2__Constants_180;
};

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
  float4 ToolModeParams__Constants_208;
  int ToolModeParams__Constants_224;
};

struct UIPassParams__Constants {
  int UIPassParams__Constants_000;
};

struct UnderwaterLightingParams__Constants {
  float3 UnderwaterLightingParams__Constants_000;
};

struct VertexPickingParams__Constants {
  float2 VertexPickingParams__Constants_000[2];
  int2 VertexPickingParams__Constants_016;
  float2 VertexPickingParams__Constants_024;
  float VertexPickingParams__Constants_032;
  float VertexPickingParams__Constants_036;
  float VertexPickingParams__Constants_040;
  int VertexPickingParams__Constants_044;
};

struct WaterBaseLevelParams__Constants {
  float4 WaterBaseLevelParams__Constants_000;
  float4 WaterBaseLevelParams__Constants_016;
  float2 WaterBaseLevelParams__Constants_032;
};

struct WaterCustomMeshParams__Constants {
  float3 WaterCustomMeshParams__Constants_000;
};

struct NestedGridsRO__Constants {
  int NestedGridsRO__Constants_000;
  int NestedGridsRO__Constants_004;
  float2 NestedGridsRO__Constants_008;
  float NestedGridsRO__Constants_016[10];
  int3 NestedGridsRO__Constants_056;
  float4 NestedGridsRO__Constants_068[10];
};

struct WaterParticlesCommonParams__Constants {
  float3 WaterParticlesCommonParams__Constants_000;
  float4 WaterParticlesCommonParams__Constants_012[6];
  int WaterParticlesCommonParams__Constants_108;
  int WaterParticlesCommonParams__Constants_112;
  float WaterParticlesCommonParams__Constants_116;
  float4 WaterParticlesCommonParams__Constants_120;
  float WaterParticlesCommonParams__Constants_136;
  float3 WaterParticlesCommonParams__Constants_140;
  float WaterParticlesCommonParams__Constants_152;
  float2 WaterParticlesCommonParams__Constants_156;
  int WaterParticlesCommonParams__Constants_164;
  int WaterParticlesCommonParams__Constants_168;
  int WaterParticlesCommonParams__Constants_172;
  float3 WaterParticlesCommonParams__Constants_176;
  int WaterParticlesCommonParams__Constants_188;
  float WaterParticlesCommonParams__Constants_192;
  int WaterParticlesCommonParams__Constants_196;
  NestedGridsRO__Constants WaterParticlesCommonParams__Constants_200;
};

struct WaterStamperTextureParams__Constants {
  float4 WaterStamperTextureParams__Constants_000;
  float WaterStamperTextureParams__Constants_016;
};

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
  AerialPerspectiveVolumeParams__Constants PassParams__Constants_1464;
  AmbientLightingParams__Constants PassParams__Constants_1484;
  VolumetricCloudShadow__Constants PassParams__Constants_1556;
  ClusteredDecalsEvaluateParams__Constants PassParams__Constants_1724;
  ClusteredWorldVoxelColorEvaluateParams__Constants PassParams__Constants_1784;
  CombinedCloudShadow__Constants PassParams__Constants_1852;
  CustomDepthMapParams__Constants PassParams__Constants_1912;
  DeferredCommonParams__Constants PassParams__Constants_1984;
  DynamicWindParams__Constants PassParams__Constants_2004;
  FarShadowParams__Constants PassParams__Constants_2316;
  VolumetricFogParams__Constants PassParams__Constants_2320;
  GenericStamperParams__Constants PassParams__Constants_2648;
  GrassForceSamplingParams__Constants PassParams__Constants_2956;
  IndoorDepthMapParams__Constants PassParams__Constants_2996;
  LocalizedSkyLightingParams__Constants PassParams__Constants_3072;
  LocalLightsEvaluateParams__Constants PassParams__Constants_3104;
  LongRangeShadowsParams__Constants PassParams__Constants_3124;
  NearShadowParams__Constants PassParams__Constants_3152;
  OmnidirectionalLocalLightsEvaluateParams__Constants PassParams__Constants_3156;
  OpacitySlices__Constants PassParams__Constants_3172;
  OpaqueLightingCommonParams__Constants PassParams__Constants_3352;
  PreintergratedSSSParams__Constants PassParams__Constants_3396;
  RainBlockerParams__Constants PassParams__Constants_3404;
  ReadbackTextureStreamingMipFeedbackParams__Constants PassParams__Constants_3428;
  RTGILightingParams__Constants PassParams__Constants_3444;
  RTSpecularParams__Constants PassParams__Constants_3448;
  SnowDisplacementParams__Constants PassParams__Constants_3452;
  SnowRemoverMaskParams__Constants PassParams__Constants_3468;
  TerrainDeformationParams__Constants PassParams__Constants_3516;
  TerrainFrameParams2__Constants PassParams__Constants_3520;
  ToolModeParams__Constants PassParams__Constants_3704;
  UIPassParams__Constants PassParams__Constants_3932;
  UnderwaterLightingParams__Constants PassParams__Constants_3936;
  VertexPickingParams__Constants PassParams__Constants_3948;
  WaterBaseLevelParams__Constants PassParams__Constants_3996;
  WaterCustomMeshParams__Constants PassParams__Constants_4036;
  WaterParticlesCommonParams__Constants PassParams__Constants_4048;
  WaterStamperTextureParams__Constants PassParams__Constants_4476;
};

struct LocalToneMappingBilateralGridParams__Constants {
  float4 LocalToneMappingBilateralGridParams__Constants_000;
  float LocalToneMappingBilateralGridParams__Constants_016;
  float LocalToneMappingBilateralGridParams__Constants_020;
  float LocalToneMappingBilateralGridParams__Constants_024;
  float LocalToneMappingBilateralGridParams__Constants_028;
  float LocalToneMappingBilateralGridParams__Constants_032;
  float LocalToneMappingBilateralGridParams__Constants_036;
  float LocalToneMappingBilateralGridParams__Constants_040;
  float LocalToneMappingBilateralGridParams__Constants_044;
  float LocalToneMappingBilateralGridParams__Constants_048;
  float LocalToneMappingBilateralGridParams__Constants_052;
  float LocalToneMappingBilateralGridParams__Constants_056;
  int LocalToneMappingBilateralGridParams__Constants_060;
};

struct SkyLightingValues {
  float4 SkyLightingValues_000[7];
};

StructuredBuffer<float> t0_space1 : register(t0, space1);

Texture2D<float4> t0_space3 : register(t0, space3);

Texture3D<float2> t1_space3 : register(t1, space3);

Texture2D<float> t2_space3 : register(t2, space3);

cbuffer cb1 : register(b1) {
  SkyLightingValues FrameParams_skylighting_SkyConstants_cbuffer_000 : packoffset(c000.x);
};

cbuffer cb0_space1 : register(b0, space1) {
  float cb0_space1_071x : packoffset(c071.x);
};

cbuffer cb0_space3 : register(b0, space3) {
  LocalToneMappingBilateralGridParams__Constants LocalToneMappingBilateralGridParams_cbuffer_000 : packoffset(c000.x);
};

SamplerState s0_space99 : register(s0, space99);

SamplerState s8_space98 : register(s8, space98);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

float3 HueAndChrominanceOKLab(
    float3 incorrect_color, float3 reference_color,
    float hue_correct_strength = 0.f,
    float chrominance_correct_strength = 0.f,
    float clamp_chrominance_loss = 0.f,
    float clamp_chrominance_gain = 0.f,
    float saturation = 1.f) {
  if (hue_correct_strength != 0.f || chrominance_correct_strength != 0.f) {
    float3 perceptual_new = renodx::color::oklab::from::BT709(incorrect_color);
    const float3 reference_oklab = renodx::color::oklab::from::BT709(reference_color);

    float chrominance_current = length(perceptual_new.yz);
    float chrominance_ratio_hue = 1.f;
    float chrominance_ratio = 1.f;

    if (hue_correct_strength != 0.f) {
      const float chrominance_pre = chrominance_current;
      perceptual_new.yz = lerp(perceptual_new.yz, reference_oklab.yz, hue_correct_strength);
      const float chrominancePost = length(perceptual_new.yz);
      chrominance_ratio_hue = renodx::math::SafeDivision(chrominance_pre, chrominancePost, 1);
      chrominance_current = chrominancePost;
    }

    if (chrominance_correct_strength != 0.f) {
      const float reference_chrominance = length(reference_oklab.yz);
      float target_chrominance_ratio = renodx::math::SafeDivision(reference_chrominance, chrominance_current, 1);
      chrominance_ratio = lerp(chrominance_ratio, target_chrominance_ratio, chrominance_correct_strength);
    }

    // Combine hue-preservation scaling and chroma correction, then clamp gain/loss.
    float chroma_scale = chrominance_ratio_hue * chrominance_ratio;
    const float chroma_gain_mask = step(1.f, chroma_scale);        // 1 when scaling up
    const float chroma_loss_mask = 1.f - step(1.f, chroma_scale);  // 1 when scaling down
    chroma_scale = lerp(chroma_scale, 1.f, chroma_gain_mask * clamp_chrominance_gain);
    chroma_scale = lerp(chroma_scale, 1.f, chroma_loss_mask * clamp_chrominance_loss);

    perceptual_new.yz *= chroma_scale;
    perceptual_new.yz *= saturation;

    incorrect_color = renodx::color::bt709::from::OkLab(perceptual_new);
    incorrect_color = renodx::color::bt709::clamp::AP1(incorrect_color);
  }
  return incorrect_color;
}

static const float LOCAL_TONEMAP_LUMINANCE_SCALE = 5464.f;
static const float LOCAL_TONEMAP_INVERSE_LUMINANCE_SCALE = 0.0001830161054385826f;

struct LocalToneMapConfig {
  float adaptation_log_threshold;
  float adaptation_log_range;
  float detail_adaptation_scale;
  float slope_adaptation_strength;
  float grid_log_range;
  float shoulder_strength;
  float toe_strength;
  float base_slope;
  float output_log_offset;
  float shoulder_environment_scale;
  float toe_environment_scale;
  float environment_exposure_scale;
  float shoulder_max;
  float toe_max;
  float local_luminance_blend;
};

struct LocalToneMapParams {
  float input_log;
  float output_log_base;
  float local_adaptation_log;
  float input_log_slope;
  float local_detail_contribution;
  float uncompressed_local_detail_contribution;
};

struct LocalToneMapDetail {
  float contribution;
  float uncompressed_contribution;
};

struct LocalToneMapResult {
  float scale;
  float scale_without_toe_and_shoulder;
};

struct LocalToneMapSharedContext {
  LocalToneMapConfig config;
  float2 texcoord;
  float grid_min_log;
  float inverse_grid_log_range;
  float reference_log;
  float output_log_base;
  float local_luminance_log;
  float shoulder_gain;
  float toe_gain;
};

LocalToneMapConfig LoadLocalToneMapConfig() {
  const float4 adaptation = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_000;

  LocalToneMapConfig config;
  config.adaptation_log_threshold = adaptation.x;
  config.adaptation_log_range = adaptation.y;
  config.detail_adaptation_scale = adaptation.z;
  config.slope_adaptation_strength = adaptation.w;
  config.grid_log_range = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_016;
  config.shoulder_strength = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_020;
  config.toe_strength = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_024;
  config.base_slope = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_028;
  config.output_log_offset = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_032;
  config.shoulder_environment_scale = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_036;
  config.toe_environment_scale = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_040;
  config.environment_exposure_scale = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_044;
  config.shoulder_max = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_048;
  config.toe_max = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_052;
  config.local_luminance_blend = LocalToneMappingBilateralGridParams_cbuffer_000.LocalToneMappingBilateralGridParams__Constants_056;
  return config;
}

float ComputeLimitedLocalDetailGain(
    float environment_delta,
    float environment_scale,
    float base_gain,
    float maximum_gain) {
  const float gain_limit = max(1.f, maximum_gain / base_gain);
  return max(1.f, min(environment_delta * environment_scale, gain_limit)) * base_gain;
}

float ComputeLocalToneMapInputLog(float input) {
  return select(
      input > 1.000000013351432e-10f,
      log2(input * LOCAL_TONEMAP_LUMINANCE_SCALE),
      -20.803539276123047f);
}

LocalToneMapDetail ComputeLocalToneMapDetail(
    float local_adaptation_log,
    LocalToneMapSharedContext context) {
  const float local_detail_delta = local_adaptation_log - context.output_log_base;
  const float positive_detail_mask = select(local_detail_delta > 0.f, 1.f, 0.f);
  const float adaptation_strength = saturate(
                                        (context.config.adaptation_log_threshold - context.reference_log)
                                        / context.config.adaptation_log_range)
                                    * positive_detail_mask;
  const float detail_gain = lerp(
      context.toe_gain,
      context.shoulder_gain,
      positive_detail_mask);
  const float detail_adaptation = mad(
      adaptation_strength,
      context.config.detail_adaptation_scale - 1.f,
      1.f);

  LocalToneMapDetail detail;
  detail.contribution = (1.f - detail_gain) * local_detail_delta * detail_adaptation;
  detail.uncompressed_contribution = local_detail_delta * detail_adaptation;
  return detail;
}

LocalToneMapSharedContext ComputeLocalToneMapSharedContext(float2 texcoord) {
  LocalToneMapSharedContext context;
  context.config = LoadLocalToneMapConfig();
  context.texcoord = texcoord;

  const float reference_luminance = t0_space1[3];
  const float global_luminance_scale = t0_space1[0];
  const float grid_center_log = log2(
      reference_luminance * 983.52001953125f
      * global_luminance_scale
      * cb0_space1_071x);
  context.grid_min_log = grid_center_log - context.config.grid_log_range * 0.5f;
  context.inverse_grid_log_range = 1.f / context.config.grid_log_range;

  // Sky luminance adjusts the output anchor and the bright/dark detail limits.
  const float3 sky_color = max(float3(
                                   FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[0].w,
                                   FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[1].w,
                                   FrameParams_skylighting_SkyConstants_cbuffer_000.SkyLightingValues_000[2].w),
                               0.f);
  const float sky_luminance = dot(sky_color, float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
  context.reference_log = log2(reference_luminance * LOCAL_TONEMAP_LUMINANCE_SCALE);
  const float environment_log_delta = max(
      0.f,
      log2(sky_luminance * LOCAL_TONEMAP_LUMINANCE_SCALE) - context.reference_log);
  context.output_log_base = context.config.output_log_offset
                            + grid_center_log
                            - environment_log_delta * context.config.environment_exposure_scale;

  context.local_luminance_log = log2(
      t2_space3.SampleLevel(s8_space98, texcoord, 0.f)
      * LOCAL_TONEMAP_LUMINANCE_SCALE);

  context.shoulder_gain = ComputeLimitedLocalDetailGain(
      environment_log_delta,
      context.config.shoulder_environment_scale,
      context.config.shoulder_strength,
      context.config.shoulder_max);

  const float negative_environment_delta = max(
      0.f,
      (log2(sky_luminance * 10928.f) - context.reference_log) * 6.f);
  context.toe_gain = ComputeLimitedLocalDetailGain(
      negative_environment_delta,
      context.config.toe_environment_scale,
      context.config.toe_strength,
      context.config.toe_max);

  return context;
}

LocalToneMapParams ComputeLocalToneMapParams(
    float local_tonemap_input,
    LocalToneMapSharedContext context) {
  const float input_log = ComputeLocalToneMapInputLog(local_tonemap_input);

  // Run the complete bilateral-grid reconstruction for this channel.
  const float grid_z = saturate(
      (input_log - context.grid_min_log) * context.inverse_grid_log_range);
  const float2 bilateral_sample = t1_space3.SampleLevel(
      s8_space98,
      float3(context.texcoord, grid_z),
      0.f);
  const float bilateral_log = (bilateral_sample.x / max(bilateral_sample.y, 1.0000000116860974e-07f)
                               + context.grid_min_log * context.inverse_grid_log_range)
                              / context.inverse_grid_log_range;

  LocalToneMapParams params;
  params.input_log = input_log;
  params.output_log_base = context.output_log_base;
  params.local_adaptation_log = mad(
      context.config.local_luminance_blend,
      context.local_luminance_log - bilateral_log,
      bilateral_log);

  const LocalToneMapDetail detail = ComputeLocalToneMapDetail(
      params.local_adaptation_log,
      context);
  const float positive_detail_mask = select(
      params.local_adaptation_log > params.output_log_base,
      1.f,
      0.f);
  const float adaptation_strength = saturate(
                                        (context.config.adaptation_log_threshold - context.reference_log)
                                        / context.config.adaptation_log_range)
                                    * positive_detail_mask;
  params.input_log_slope = context.config.base_slope
                           * mad(
                               adaptation_strength,
                               context.config.slope_adaptation_strength,
                               1.f);
  params.local_detail_contribution = detail.contribution;
  params.uncompressed_local_detail_contribution = detail.uncompressed_contribution;
  return params;
}

float SanitizeLocalToneMapScale(float scale) {
  const uint exponent_bits = asuint(scale) & 0x7F800000u;
  const bool invalid_scale = isinf(scale)
                             || exponent_bits > 0x7F7FFFFFu;
  return select(invalid_scale, 1.f, scale);
}

LocalToneMapResult ComputeLocalToneMapResult(
    float local_tonemap_input,
    LocalToneMapParams params) {
  LocalToneMapResult result;
  if (local_tonemap_input == 0.f) {
    result.scale = 1.f;
    result.scale_without_toe_and_shoulder = 1.f;
    return result;
  }

  const float output_log_base = params.output_log_base
                                + params.input_log_slope
                                      * (params.input_log - params.local_adaptation_log);
  const float output_log_without_toe_and_shoulder = output_log_base
                                                    + params.uncompressed_local_detail_contribution;
  const float output_log = output_log_base + params.local_detail_contribution;
  result.scale_without_toe_and_shoulder = SanitizeLocalToneMapScale(
      exp2(output_log_without_toe_and_shoulder)
      * LOCAL_TONEMAP_INVERSE_LUMINANCE_SCALE
      / local_tonemap_input);
  result.scale = SanitizeLocalToneMapScale(
      exp2(output_log)
      * LOCAL_TONEMAP_INVERSE_LUMINANCE_SCALE
      / local_tonemap_input);
  return result;
}

float3 ApplyLocalToneMapToeAndShoulderLMS(
    float3 input_lms,
    float3 precompression_lms,
    float3 white_lms,
    LocalToneMapParams luminance_params,
    LocalToneMapSharedContext context) {
  const float3 normalized_input_lms = input_lms / white_lms;
  const float3 channel_input_logs = float3(
      ComputeLocalToneMapInputLog(normalized_input_lms.x),
      ComputeLocalToneMapInputLog(normalized_input_lms.y),
      ComputeLocalToneMapInputLog(normalized_input_lms.z));

  // Carry each cone's log offset into the luminance-derived local adaptation point.
  const float3 channel_adaptation_logs = luminance_params.local_adaptation_log
                                         + channel_input_logs
                                         - luminance_params.input_log;

  // Select one smoothly varying toe/shoulder gain from luminance. Independent
  // hard branch changes in L, M, and S produce visible chromatic gradients.
  const float luminance_detail_delta = luminance_params.local_adaptation_log
                                       - luminance_params.output_log_base;
  const float shoulder_weight = smoothstep(-0.5f, 0.5f, luminance_detail_delta);
  const float adaptation_strength = saturate(
                                        (context.config.adaptation_log_threshold - context.reference_log)
                                        / context.config.adaptation_log_range)
                                    * shoulder_weight;
  const float detail_gain = lerp(context.toe_gain, context.shoulder_gain, shoulder_weight);
  const float detail_adaptation = mad(
      adaptation_strength,
      context.config.detail_adaptation_scale - 1.f,
      1.f);
  const float3 channel_detail_deltas = channel_adaptation_logs - context.output_log_base;
  const float3 toe_and_shoulder_log_delta = -detail_gain
                                            * channel_detail_deltas
                                            * detail_adaptation;

  // Apply only the toe/shoulder delta; exposure, grid adaptation, and slope stay luminance-driven.
  const float3 normalized_precompression_lms = precompression_lms / white_lms;
  const float3 normalized_tonemapped_lms = normalized_precompression_lms
                                           * exp2(toe_and_shoulder_log_delta);
  return normalized_tonemapped_lms * white_lms;
}

float4 main(
    precise noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  const float3 input_color = t0_space3.SampleLevel(s0_space99, TEXCOORD, 0.f).rgb;
  const bool use_enhanced_local_tonemap = CUSTOM_LOCAL_TONE_MAP_TYPE != 0.f;
  const float input_luminance = use_enhanced_local_tonemap
                                    ? renodx::color::yf::from::BT709(input_color)
                                    : renodx::color::y::from::BT709(input_color);
  const LocalToneMapSharedContext context = ComputeLocalToneMapSharedContext(TEXCOORD);
  const LocalToneMapParams params = ComputeLocalToneMapParams(input_luminance, context);
  const LocalToneMapResult local_tonemap = ComputeLocalToneMapResult(input_luminance, params);
  const float3 local_tonemapped_color = local_tonemap.scale * input_color;
  const float3 local_tonemapped_without_toe_and_shoulder = local_tonemap.scale_without_toe_and_shoulder * input_color;

  float3 output_color;
  if (use_enhanced_local_tonemap) {
    const float3 bt709_white_lms = renodx::color::lms::from::BT709(1.f.xxx);
    const float3 input_lms = renodx::color::lms::from::BT709(input_color);
    const float3 precompression_lms = renodx::color::lms::from::BT709(local_tonemapped_without_toe_and_shoulder);
    float3 lms_tonemapped_color = renodx::color::bt709::from::LMS(
        ApplyLocalToneMapToeAndShoulderLMS(
            input_lms,
            precompression_lms,
            bt709_white_lms,
            params,
            context));
    lms_tonemapped_color = renodx::color::correct::Luminance(
        lms_tonemapped_color,
        renodx::color::yf::from::BT709(lms_tonemapped_color),
        renodx::color::yf::from::BT709(local_tonemapped_color));
    output_color = lerp(
        lms_tonemapped_color,
        local_tonemapped_color,
        saturate(renodx::color::yf::from::BT709(local_tonemapped_color) / 0.5f));
  } else {
    output_color = local_tonemapped_color;
  }

  return float4(output_color, 1.f);
}
