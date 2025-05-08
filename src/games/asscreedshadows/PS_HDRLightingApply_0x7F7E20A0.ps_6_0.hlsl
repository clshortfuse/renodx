#include "./shared.h"
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

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t0_space2 : register(t0, space2);

Texture3D<float4> t3_space2 : register(t3, space2);

Texture2D<float4> t11_space2 : register(t11, space2);

Texture2D<float4> t12_space2 : register(t12, space2);

cbuffer cb0_space1 : register(b0, space1) {
  int cb0_space1_076x : packoffset(c076.x);
};

cbuffer cb0_space2 : register(b0, space2) {
  float cb0_space2_000x : packoffset(c000.x);
  float cb0_space2_007x : packoffset(c007.x);
  int cb0_space2_007y : packoffset(c007.y);
  float cb0_space2_008x : packoffset(c008.x);
  float cb0_space2_008y : packoffset(c008.y);
  float cb0_space2_008z : packoffset(c008.z);
};

SamplerState s0_space99 : register(s0, space99);

SamplerState s0_space3 : register(s0, space3);

SamplerState s1_space3 : register(s1, space3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD,
    nointerpolation float TEXCOORD_1: TEXCOORD1)
    : SV_Target {
  float4 SV_Target;
  float4 _16 = t0_space2.SampleLevel(s0_space99, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float _20 = _16.x * TEXCOORD_1;
  float _21 = _16.y * TEXCOORD_1;
  float _22 = _16.z * TEXCOORD_1;
  float4 _23 = t11_space2.SampleLevel(s1_space3, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  _23.rgb *= CUSTOM_BLOOM;

  float _28 = _23.x + _20;
  float _29 = _23.y + _21;
  float _30 = _23.z + _22;
  bool _33 = (cb0_space2_007y == 0);
  float _53;
  float _54;
  float _55;
  float _126;
  float _127;
  float _128;
  if (!_33) {
    float4 _35 = t12_space2.SampleLevel(s1_space3, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _39 = _35.x * _23.x;
    float _40 = _35.y * _23.y;
    float _41 = _35.z * _23.z;
    float _46 = _39 * cb0_space2_008x;
    float _47 = _40 * cb0_space2_008y;
    float _48 = _41 * cb0_space2_008z;
    float _49 = _46 + _28;
    float _50 = _47 + _29;
    float _51 = _48 + _30;
    _53 = _49;
    _54 = _50;
    _55 = _51;
  } else {
    _53 = _28;
    _54 = _29;
    _55 = _30;
  }
  float _58 = cb0_space2_007x * _23.w;
  float _59 = _58 + 1.0f;
  float _60 = 1.0f / _59;
  float _61 = _60 * _53;
  float _62 = _60 * _54;
  float _63 = _60 * _55;
  bool _66 = !(cb0_space2_000x == 0.0f);
  if (_66) {
    float _68 = TEXCOORD.x + -0.5f;
    float _69 = TEXCOORD.y + -0.5f;
    float _70 = dot(float2(_68, _69), float2(_68, _69));
    float _71 = 1.0f - _70;
    float _72 = saturate(_71);
    float _73 = log2(_72);
    float _74 = _73 * cb0_space2_000x;
    float _75 = exp2(_74);
    uint _78 = (int)(cb0_space1_076x) + 41451437u;
    uint _79 = uint(SV_Position.x);
    uint _80 = uint(SV_Position.y);
    uint _81 = _78 * 1215282323;
    uint _82 = _81 + -200870954u;
    uint _83 = _82 << 16;
    int _84 = (uint)(_82) >> 16;
    int _85 = _83 | _84;
    uint _86 = _85 * _82;
    uint _87 = _82 + _79;
    uint _88 = _87 + _86;
    uint _89 = _84 + _80;
    int _90 = _88 & 63;
    int _91 = _89 & 63;
    float4 _92 = t0.Load(int3(_90, _91, 0));
    uint _95 = _78 * -1935564855;
    uint _96 = _95 + 706565374u;
    uint _97 = _96 << 16;
    int _98 = (uint)(_96) >> 16;
    int _99 = _97 | _98;
    uint _100 = _99 * _96;
    uint _101 = _96 + _79;
    uint _102 = _101 + _100;
    uint _103 = _98 + _80;
    int _104 = _102 & 63;
    int _105 = _103 & 63;
    float4 _106 = t0.Load(int3(_104, _105, 0));
    float _108 = _75 * 0.0625f;
    float _109 = _75 * 0.125f;
    float _110 = _92.x + -0.5f;
    float _111 = _92.y + -0.5f;
    float _112 = _106.x + -0.5f;
    float _113 = _108 * _110;
    float _114 = _108 * _111;
    float _115 = _109 * _112;
    float _116 = _113 + _75;
    float _117 = _114 + _75;
    float _118 = _115 + _75;
    float _119 = max(0.0f, _116);
    float _120 = max(0.0f, _117);
    float _121 = max(0.0f, _118);
    float _122 = _119 * _61;
    float _123 = _120 * _62;
    float _124 = _121 * _63;
    _126 = _122;
    _127 = _123;
    _128 = _124;
  } else {
    _126 = _61;
    _127 = _62;
    _128 = _63;
  }
  float _129 = log2(_126);
  float _130 = _129 * 0.05000000074505806f;
  float _131 = _130 + 0.6236965656280518f;
  float _132 = log2(_127);
  float _133 = _132 * 0.05000000074505806f;
  float _134 = _133 + 0.6236965656280518f;
  float _135 = log2(_128);
  float _136 = _135 * 0.05000000074505806f;
  float _137 = _136 + 0.6236965656280518f;
  float _138 = saturate(_131);
  float _139 = saturate(_134);
  float _140 = saturate(_137);
  float _141 = _138 * 0.96875f;
  float _142 = _139 * 0.96875f;
  float _143 = _140 * 0.96875f;
  float _144 = _141 + 0.015625f;
  float _145 = _142 + 0.015625f;
  float _146 = _143 + 0.015625f;
  float4 _147 = t3_space2.SampleLevel(s0_space3, float3(_144, _145, _146), 0.0f);
  SV_Target.x = _147.x;
  SV_Target.y = _147.y;
  SV_Target.z = _147.z;
  SV_Target.w = 1.0f;
  return SV_Target;
}
