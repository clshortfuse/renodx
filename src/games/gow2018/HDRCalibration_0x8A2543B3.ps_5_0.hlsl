#include "./shared.h"

cbuffer ConstBuf__passData : register(b0)
{

  struct
  {
    float CascadeShadowSize;
    float OneOverCascadeShadowSize;
    float ShadowTextureW;
    float ShadowTextureH;
    float OneOverShadowTextureW;
    float OneOverShadowTextureH;

    struct
    {
      float giVolumeSHDiffuseBlur;
      float giVolumeSHSpecularBlur;
      float giVolumeSaturation;
      float4 defaultOcclusionSH;
      float4 skyFullRSH;
      float4 skyFullGSH;
      float4 skyFullBSH;
      float4 skyFullClampRSH;
      float4 skyFullClampGSH;
      float4 skyFullClampBSH;
      float4 skyFullGeoRSH;
      float4 skyFullGeoGSH;
      float4 skyFullGeoBSH;
      float4 skyTopRSH;
      float4 skyTopGSH;
      float4 skyTopBSH;
      float4 skyTopClampRSH;
      float4 skyTopClampGSH;
      float4 skyTopClampBSH;
      float4 skyTopGeoRSH;
      float4 skyTopGeoGSH;
      float4 skyTopGeoBSH;
      float4 skyTopAndBounceRSH;
      float4 skyTopAndBounceGSH;
      float4 skyTopAndBounceBSH;
      float4 skyTopAndBounceClampRSH;
      float4 skyTopAndBounceClampGSH;
      float4 skyTopAndBounceClampBSH;
      float4 skyTopAndBounceGeoRSH;
      float4 skyTopAndBounceGeoGSH;
      float4 skyTopAndBounceGeoBSH;
      float4 skyDifFullRSH;
      float4 skyDifFullGSH;
      float4 skyDifFullBSH;
      float4 skyDifFullClampRSH;
      float4 skyDifFullClampGSH;
      float4 skyDifFullClampBSH;
      float4 skyDifFullGeoRSH;
      float4 skyDifFullGeoGSH;
      float4 skyDifFullGeoBSH;
      float4 skyDifTopRSH;
      float4 skyDifTopGSH;
      float4 skyDifTopBSH;
      float4 skyDifTopClampRSH;
      float4 skyDifTopClampGSH;
      float4 skyDifTopClampBSH;
      float4 skyDifTopGeoRSH;
      float4 skyDifTopGeoGSH;
      float4 skyDifTopGeoBSH;
      float4 skyDifTopAndBounceRSH;
      float4 skyDifTopAndBounceGSH;
      float4 skyDifTopAndBounceBSH;
      float4 skyDifTopAndBounceClampRSH;
      float4 skyDifTopAndBounceClampGSH;
      float4 skyDifTopAndBounceClampBSH;
      float4 skyDifTopAndBounceGeoRSH;
      float4 skyDifTopAndBounceGeoGSH;
      float4 skyDifTopAndBounceGeoBSH;
    } giVolumeGlobal;


    struct
    {

      struct
      {
        float3 color;
        uint lightgroupID;
        float3 position;
        float sourceRadiusSquared;
        float falloffConstant;
        float innerMinusOuterCosHalfAngleRcp;
        float outerCosHalfAngle;
        float dirLightHalfAngle;
        float3 direction;
        float dirLightSolidAngle;
        int projectorIndex;
        float fadeStartOnDist;
        float fadeRcpDist;
        float fadeRate;
      } gLight[64];


      struct
      {
        float4x4 gWorldToLight;

        struct
        {
          float fScale;
          float3 vTranslate;
        } gCascadeOffset[3];

        float4 uvScaleOffset[4];
        int extraCascadeIndex;
        float cascadeRange;
        float2 linearizeConstants;
        float filterSize;
        float shadowFade;
        float shadowBias;
        float padd;
      } gLightShadowInfo[16];


      struct
      {
        float4x4 gWorldToLight;

        struct
        {
          float fScale;
          float3 vTranslate;
        } gCascadeOffset[3];

        float4 uvScaleOffset[4];
        int extraCascadeIndex;
        float cascadeRange;
        float2 linearizeConstants;
        float filterSize;
        float shadowFade;
        float shadowBias;
        float padd;
      } gShadowTransmittanceInfo;


      struct
      {
        float4x4 gWorldToLight;

        struct
        {
          float fScale;
          float3 vTranslate;
        } gCascadeOffset[3];

        float4 uvScaleOffset[4];
        int extraCascadeIndex;
        float cascadeRange;
        float2 linearizeConstants;
        float filterSize;
        float shadowFade;
        float shadowBias;
        float padd;
      } gExtraCascadeShadowInfo[16];


      struct
      {
        float4x4 mat;
      } projectors[4];

    } lightBuffer;


    struct
    {
      float gDebugAmbientAmount;
      float gDebugDiffuseAmount;
      float gDebugSpecularAmount;
      float gDebugEnvmapAmount;
      float3 g_GPUDebugOverridePositionXYZ;
      float gDebugAOAmount;
      float g_GPUDebugOn;
      float g_GPUDebugOverridePositionEnable;
      float g_skinSpecSecondLobeShift;
      float g_skinSpecSecondProportion;
      float g_thinScatteringAnisotropy;
      float g_volumetricScatteringAnisotropy;
      float g_volumetricSpecularScatteringAnisotropy;
      float g_skinScatteringAnisotropy;
      float g_volumetricScatteringNormalBend;
      float g_volumetricSpecularScatteringNormalBend;
      float g_hairSpecSecondLobeShift;
      float g_hairSpecSecondProportion;
      float g_isHDRRendering;
      float g_defaultSceneToScreenPower;
      float g_defaultWhiteLevel;
      float padding0;
      int g_flags;
      float g_reflectionOcclusionFalloff;
      float padding1;
      float padding2;

      struct
      {
        float3 cFogColor;
        float cHeightFalloff;
        float3 cEyePosition;
        float cHeightDensity;
        float cStartDistance;
        float cGlobalDensity;
        float cDepthReprojectScale;
        float cDepthReprojectBias;
        float4x4 cInvProjNoZReproj;
        float3 cDirectionalFogDirection;
        float cDirectionalityPower;
        float3 cDirectionalFogColor;
        float cDensityMapSparseBias;
        float3 cDensityMapInvExtents;
        float cDensityMapSparseSegmentScale;
        float3 cDensityMapBias;
        float cDensityMapSparseCutoff;
        float cVolFogExponentMultiply;
        float cVolFogDistanceMultiply;
        float cVolFogExponentNormalize;
        float cVolFogDistanceNormalize;
        float cVolFogResolutionScale;
        int cVolFogWidth;
        int cVolFogHeight;
        int cVolFogDepth;
      } atmosphericConstants;

    } environmentBuffer;

    float4x4 worldToBoatCap;
    float3 cameraPosInBoatSpace;
    float automaticWetnessFromHeightHeight;
    float automaticWetnessFromHeightTransitionDistance;
    float automaticWetnessFromHeightAmount;

    struct
    {
      float3 WBMatrixR;
      float3 WBMatrixG;
      float3 WBMatrixB;
      float EnableLocalAdaptation;
      float Adaptation_Exposure;
      float ExposureEV;
      float ExposureEVClampMin;
      float ExposureEVClampMax;
      float LocalAdaptationShadows;
      float LocalAdaptationHighlights;
      int Tonemapping_Curve;
      float Contrast;
      float HDRMax;
      float HDRWhite;
      float ContrastTimesShoulder;
      float ChannelCrossTalk;
      float PrecomputedBMult;
      float PrecomputedCAdd;
      float SceneToScreenPower;
      float IsHDRRendering;
      float DebugHDRRendering;
      float DebugHDRRenderingPhase;
      float DebugNoHDRRendering;
      float ShowWaveform;
    } calibrationTonemappingConstants;

    float4 userClipPlane0;
    float4 userClipPlane1;
  } resourceTables__passData : packoffset(c0);

}

cbuffer ConstBuf__modelData : register(b1)
{

  struct
  {
    uint lightGroupID;
    uint modelFlags;
    float lodFade;
    float displacementBlend;
    int turbulenceDataIdx;
    int instanceOffset;
    int characterFxIdx;
    uint debugRenderChannel;
    uint decayWriteOffset;
    uint decayWriteMaxCount;
    uint decayAtomicCounterIndex;
    float modelAlpha;
    float emissiveScale;
    float desaturationScale;
    float decayCoverageEstimation;
    float3 quantScale;
    float3 quantBias;
  } resourceTables__modelData : packoffset(c0);

}

SamplerState resourceTables__viewData__smpLinear_s : register(s1);
Texture2D<float4> resourceTables__materialData__layer_0__emissive : register(t41);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  uint v1 : VERT_ID0,
  float2 v2 : TEXCOORD0,
  float3 v3 : NORMAL0,
  float3 v4 : TANGENT0,
  float3 v5 : BINORMAL0,
  float3 v6 : TEXCOORD8,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = resourceTables__materialData__layer_0__emissive.Sample(resourceTables__viewData__smpLinear_s, v2.xy).xyz;
  r0.xyz = resourceTables__modelData.emissiveScale * r0.xyz;
  r0.w = cmp(0 != resourceTables__passData.calibrationTonemappingConstants.IsHDRRendering);
  r1.x = max(r0.y, r0.z);
  r1.x = max(r1.x, r0.x);
  r1.yzw = cmp(r0.xyz < float3(0.180000007,0.180000007,0.180000007));
  r2.xyz = min(resourceTables__passData.calibrationTonemappingConstants.HDRMax, r0.xyz);
  r2.xyz = log2(r2.xyz);
  r3.xyz = resourceTables__passData.calibrationTonemappingConstants.Contrast * r2.xyz;
  r3.xyz = exp2(r3.xyz);
  r2.xyz = resourceTables__passData.calibrationTonemappingConstants.ContrastTimesShoulder * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r2.xyz = r2.xyz * resourceTables__passData.calibrationTonemappingConstants.PrecomputedBMult + resourceTables__passData.calibrationTonemappingConstants.PrecomputedCAdd;
  r2.xyz = r3.xyz / r2.xyz;
  r1.yzw = r1.yzw ? r2.xyz : r0.xyz;
  r1.yzw = r0.www ? r1.yzw : r2.xyz;
  r2.x = max(r1.z, r1.w);
  r2.x = max(r2.x, r1.y);
  r0.xyz = r2.xxx * r0.xyz;
  r0.xyz = r0.xyz / r1.xxx;
  r1.xyz = r1.yzw + -r0.xyz;
  r0.xyz = resourceTables__passData.calibrationTonemappingConstants.ChannelCrossTalk * r1.xyz + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  if (r0.w != 0) {
    if (!RENODX_GAMMA_CORRECTION) {
      r0.w = dot(float3(0.627403915,0.329283029,0.0433130674), r0.xyz);
      r1.x = dot(float3(0.069097288,0.919540405,0.0113623161), r0.xyz);
      r1.y = dot(float3(0.0163914394,0.0880133063,0.895595253), r0.xyz);
      r2.x = log2(r0.w);
      r2.y = log2(r1.x);
      r2.z = log2(r1.y);
      r1.xyz = resourceTables__passData.calibrationTonemappingConstants.SceneToScreenPower * r2.xyz;
      r1.xyz = exp2(r1.xyz);
    } else {
      r0.rgb = renodx::color::correct::GammaSafe(r0.rgb);
      r1.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
    }

    if (!RENODX_OVERRIDE_BRIGHTNESS) {
      if (RENODX_TONE_MAP_TYPE) {
        float peak_nits = RENODX_PEAK_WHITE_NITS / resourceTables__passData.calibrationTonemappingConstants.HDRWhite;
        r0.rgb = renodx::tonemap::ExponentialRollOff(r0.rgb, min(1.f, peak_nits * 0.5f), peak_nits);
      }
      r1.xyz = resourceTables__passData.calibrationTonemappingConstants.HDRWhite * r1.xyz;
    } else {
      if (RENODX_TONE_MAP_TYPE) {
        float peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
        r1.rgb = renodx::tonemap::ExponentialRollOff(r1.rgb, min(1.f, peak_nits * 0.5f), peak_nits);
      }
      r1.rgb *= RENODX_DIFFUSE_WHITE_NITS / 100.f;
    }
    if (!RENODX_USE_PQ_ENCODING) {
      r2.xyz = r1.xyz * float3(533095.75,533095.75,533095.75) + float3(47438308,47438308,47438308);
      r2.xyz = r1.xyz * r2.xyz + float3(29063622,29063622,29063622);
      r2.xyz = r1.xyz * r2.xyz + float3(575216.75,575216.75,575216.75);
      r2.xyz = r1.xyz * r2.xyz + float3(383.091034,383.091034,383.091034);
      r2.xyz = r1.xyz * r2.xyz + float3(0.000487781013,0.000487781013,0.000487781013);
      r3.xyz = r1.xyz * float3(66391356,66391356,66391356) + float3(81884528,81884528,81884528);
      r3.xyz = r1.xyz * r3.xyz + float3(4182885,4182885,4182885);
      r3.xyz = r1.xyz * r3.xyz + float3(10668.4043,10668.4043,10668.4043);
      r1.xyz = r1.xyz * r3.xyz + float3(1,1,1);
      r1.xyz = r2.xyz / r1.xyz;
    } else {
      r1.rgb = renodx::color::pq::EncodeSafe(r1.rgb, 100.f);
    }

  } else {
    r2.xyz = cmp(r0.xyz < float3(0.00313080009,0.00313080009,0.00313080009));
    r3.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.416666657,0.416666657,0.416666657) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.xyz = r0.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r1.xyz = r2.xyz ? r3.xyz : r0.xyz;
  }
  r0.x = dot(float3(0.300000012,0.600000024,0.114), r1.xyz);
  r0.xyz = r0.xxx * float3(0.300000012,0.300000012,0.300000012) + -r1.xyz;
  r0.xyz = resourceTables__modelData.desaturationScale * r0.xyz + r1.xyz;
  r0.w = 1;
  o0.xyzw = resourceTables__modelData.modelAlpha * r0.xyzw;
  return;
}