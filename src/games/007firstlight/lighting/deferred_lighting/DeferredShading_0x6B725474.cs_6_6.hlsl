#include "deferred_isfast.hlsli"

// Set to 0 to compile the original SSR color sample, independently of IS-FAST.
#if 1
#define FIRSTLIGHT_SSR_ENABLED 1

#define RENODX_SKIP_SHARED_RENODX_HLSL 1
#include "../../shared.h"
#undef RENODX_SKIP_SHARED_RENODX_HLSL

float3 RenoDX_DecodeDeferredNormal(float2 encoded_normal) {
  float nx = (saturate(encoded_normal.x) * 2.0f) + -1.0f;
  float ny = (saturate(encoded_normal.y) * 2.0f) + -1.0f;
  float nz = (1.0f - abs(nx)) - abs(ny);
  float t = saturate(-0.0f - nz);
  nx += (nx >= 0.0f) ? (-0.0f - t) : t;
  ny += (ny >= 0.0f) ? (-0.0f - t) : t;
  return float3(nx, ny, nz) * rsqrt(dot(float3(nx, ny, nz), float3(nx, ny, nz)));
}

#else
#define FIRSTLIGHT_SSR_ENABLED 0
#endif

struct S_cbSharedPerViewData {
  row_major float4x4 mProjection[1];
  row_major float4x4 mProjectionPrev[1];
  row_major float4x4 mViewToViewport[1];
  row_major float3x4 mViewToWorld[1];
  row_major float3x4 mViewToWorldPrev[1];
  row_major float3x4 mWorldToView;
  row_major float3x4 mWorldToViewPrev;
  row_major float4x4 mProjToWorld;
  row_major float4x4 mFxWorldToSampleSpace;
  row_major float4x4 mViewToGlobalShadowVSPT;
  row_major float3x4 mCSMViewToLight;
  float4 vViewRemap;
  float4 vViewDepthRemap[1];
  float4 vEyeVectorUL[1];
  float4 vEyeVectorLR[1];
  float4 vEyeVectorDelta[1];
  float4 vPixelToEyeVectorScaleBias[1];
  float4 vViewSpaceUpVector;
  float4 vViewportSize;
  float4 vEngineTime;
  uint nFrameCounter;
  float fShaderLodFactorRcp;
  float fMipLODBias;
  float fScaledMipLODBias;
  float4 vShaderColor0;
  float4 vShaderColor1;
  float4 vShaderColor2;
  float4 vShaderColor3;
  float4 vClipPlane0;
  float4 vClipPlane1;
  float4 vClipPlane2;
  float4 vClipPlane3;
  float4 vClipPlane4;
  float4 vClipPlane5;
  float4 vClusteredLightingParams;
  uint4 viClusteredLightingClusterParams;
  float4 vMippedDepthRemap;
  float4 vSpecularOcclusionSettings;
  float4 vSaturatedAmbientOcclusionSettings;
  float4 vHDRScale;
  float4 vTweakableShaderParams;
  float4 vAtmosphericScatteringParameters;
  float4 vAtmosphericScatteringParameters2;
  float4 vAtmosphericScatteringParameters3;
  float3 vAtmosphericScatteringMieBeta;
  uint _pad_0;
  float3 vAtmosphericScatteringRayleighBeta;
  uint _pad_1;
  float3 vAtmosphericScatteringShadowedMieBeta;
  uint _pad_2;
  float3 vAtmosphericScatteringShadowedRayleighBeta;
  uint _pad_3;
  float3 vAttenuatedSunColor;
  uint _pad_4;
  float3 vSunDirectionVS;
  uint _pad_5;
  float3 vSunDirectionWS;
  float fSunScatteringIntensity;
  float4 vWindDirectionAndStrength;
  float4 vWindDirectionAndStrengthPrev;
  float4 vWindInitialDirectionAndStrength;
  float4 vFxFadeParameters;
  float2 vFxSize;
  int nNumCSMCascades;
  float fCSMFadeAdd;
  int nEnableClothBias;
  int nEnableCloth;
  int nClothInstanceDataOffset;
  uint _pad_6;
  int2 viNumTiles;
  int nLightTileDebugFlags;
  int nSelectedBoxReflectionId;
  int nEnableAtmosphericScatteringBackdrop;
  int nFallbackRoomMask;
  int nInspectorId;
  uint _pad_7;
  float4 vClearColor;
  float4 vShadowAtlasSize;
  float fShadowPoissonScaleInPixels;
  int nShadowSpotKernel;
  int nShadowCSMKernel;
  uint _pad_8;
  float4 vPixelJitter;
  float2 vUnjitter;
  float fMaxReactiveMask;
  float fReactiveMaskMotionThreshold;
  float2 vGlobalShadowSize;
  float fGlobalShadowMapConstantBias;
  float fGlobalShadowMapLinearBias;
  float fGlobalShadowMapNormalOffsetBias;
  float2 vGlobalCascadeOffset;
  uint _pad_9;
  float2 vGlobalCascadeScale;
  float2 vGlobalCascadeFadeOffset;
  float2 vGlobalCascadeFadeScale;
  float fGlobalCascadeFadeAmount;
  uint nGlobalCascadeBindlessID;
  float fVTSMConstantDepthBias;
  float fVTSMLinearDepthBias;
  float fVTSMConstantNormalBias;
  float fVTSMLinearNormalBias;
  int nHashedAlphaPeriod;
  int nIsRenderingOffscreen;
  int nMirrorsDisabled;
  int nScatterMode;
  int nSrvObjectIndicesOffset;
  int nCameraDistanceDitherEnable;
  float fPixelAngleFootprintApprox;
  int nSSROnTransparent;
  int nSSRHalfRes;
  uint nMaxViewDistance;
  int nVolumetricLightingApplyEnable;
  float fVolumetricLightingApplyZBias;
  float fVolumetricLightingEndDistance;
  float3 vVolumetricLightingViewToFroxelWParams;
  float2 vVolumetricLightingPixelCoordToFroxel;
  uint _pad_10;
  uint _pad_11;
  float3 vVolumetricLightingGridSize;
  float fGlobalHeightFogFalloffScale;
  float fGlobalHeightFogFalloffHeight;
  uint _pad_12;
  uint _pad_13;
  uint _pad_14;
  float4 vGlobalHeightFogAlbedoAndExtinction;
  float3 vVolumetricLightingAmbientEmissive;
  float fGlobalHeightFogFalloffHeightScaled;
  float3 vVolumetricLightingHeightFogEmissive;
  uint nOutsideBoxReflectionFallbackId;
  float3 vGIProbesUVWScale;
  uint nGIProbesNumGrids;
  float3 vGIProbesUVWBias;
  uint nLightingFeatureFlags;
  uint nAccessibilityFlags;
  uint _pad_15;
  uint _pad_16;
  uint _pad_17;
  float4 vAccessibilityColorOpaque;
  float4 vAccessibilityColorOpaqueCrowd;
  float4 vAccessibilityColorEmissive;
  float4 vAccessibilityColorTransparent;
  float4 vAccessibilityColorParticles;
  int nEnableContactShadows;
  int nEnableContactShadowsDebugColor;
  uint _pad_18;
  uint _pad_19;
  uint4 nGIProbesRoomBitsToIds[8];
  uint4 viGIProbesCMResolution;
  float4 vGIProbesVoxelSize;
  float4 vGIProbesCMRegionMinWS[4];
  float4 vGIProbesCMRegionMaxWS[4];
  float4 vGIProbesCMBlendSizeWS[4];
  float4 vGIProbesCMCoordToUVWScaleXY;
  float4 vGIProbesCMCoordToUVWScaleZ;
  float4 vGIProbesCMWorldToCoordScale;
  float4 vGIProbesCoordToCMWorldScale;
  float4 vGIProbesCMWorldToCoordBias[4];
  float4 vGIProbesSampleParams;
  uint nGIProbesFlags;
  uint nGIProbesForceLevel;
  uint _pad_20;
  uint _pad_21;
  float4 vWireBackCol;
  float fWireThickness;
  float fWireSmoothness;
  float fWireThicknessFar;
  float fWireSmoothnessFar;
  float fWireFadeStart;
  float fWireFadeEnd;
  float fWireAlphaFadeStart;
  float fWireAlphaFadeEnd;
  float fWireAlphaFade;
  uint nIsRenderingShadow;
  uint nWireMode;
  uint nSSGIEnabled;
  uint nBentNormalsEnabled;
  uint nPathTracingIsEnabled;
  uint _pad_22;
  uint _pad_23;
  float3 vOutsideBoxReflectionFallbackModifier;
  float fLogNearPlane;
  float fInvLogPlaneDifference;
  uint _pad_24;
  uint _pad_25;
  uint _pad_26;
  float4 vMomentsSize;
  float4 vWrappingZoneParameters;
  float fOverestimation;
  float fMomentBias;
  uint2 oitDebugPixel;
  float4 vTerrainRGNParams[8];
  uint2 viTerrainSectorNearCam;
  float fTerrainVTOneOverPageAtlasSizeXY;
  uint nTerrainVTFlags;
  uint nLightingShadowFeatures;
  float2 vVolumetricReferenceTransmittanceDepthToUVScaleBias;
  uint nSmolderCSMSplit;
  float waterMaxtessellationFactor;
  uint nSmolderCSMBindlessID;
  float fSmolderCSMDepthOffset;
  uint nDebugLightblocker;
  uint4 vVoxelCount[4];
  float4 vVoxelSize[4];
  float4 vGridOrigins[8];
  uint vortexTextureAtlasWidth;
  uint vortexTextureAtlasHeight;
  uint vortexTextureAtlasDepth;
  uint collisionTextureAtlasWidth;
  uint collisionTextureAtlasHeight;
  uint collisionTextureAtlasDepth;
  uint _pad_27;
  uint _pad_28;
  row_major float3x4 mCinematicVolumeWorldToObject;
  float3 vCinematicVolumeBoxHalfSize;
  uint nCinematicVolumeEnabled;
  float3 vCinematicVolumeBoxFadeNeg;
  uint nCinematicVolumeRemoveCSM;
  float3 vCinematicVolumeBoxFadePos;
  uint nPadCinematicVolume1;
  float4 vMirrorPlanesWS[16];
  uint nNumMirrorPlanes;
  uint nPadMirrorPlanes0;
  uint nPadMirrorPlanes1;
  uint nPadMirrorPlanes2;
};

struct SCSLightData {
  uint nLightTileIndex;
  uint nLayerIndex;
  uint2 vAtlasOrigin;
  uint2 vScreenOrigin;
  uint2 vSize;
  float fRayLength;
  float fIntensity;
  float fFadeValue;
  float fRadius;
};

struct SLightInfoBase {
  uint nFlags;
  uint nRoomMask;
  uint nBufferOffset;
};

struct SMaterialBindlessOffset {
  uint offset;
};

struct S_cbDeferredShading {
  float4 avPlaneEquations[20];
  float3 vSunDirWS;
  float fSunDiscIntensityScale;
  float3 vSunDiscTint;
  float fSunDiscRadiusScale;
  float2 adaptationBounds;
  int nEnablePlaneEquations;
  int nPermutationOffset;
  uint4 viSSLightIndices;
  float4 vScreenPixelSize;
  uint nSSGIHalfRes;
  uint _pad_0;
  uint _pad_1;
  uint _pad_2;
};

Texture2D<float4> srvGlobalGBuffer0 : register(t64);

Texture2D<float4> srvGlobalGBuffer1 : register(t65);

Texture2D<float4> srvGlobalGBuffer2 : register(t66);

Texture2D<float4> srvGlobalGBuffer3 : register(t67);

Texture2D<float4> srvGlobalGBuffer4 : register(t68);

StructuredBuffer<SLightInfoBase> srvLightInfoBase : register(t38);

ByteAddressBuffer srvLightInfoProperties : register(t39);

StructuredBuffer<uint> srvLightDeferredRoomTiles : register(t44);

StructuredBuffer<uint> srvLightFeaturePermutationTiles : register(t45);

StructuredBuffer<uint> srvDeferredClusters : register(t46);

StructuredBuffer<uint4> srvFallbackInfo : register(t29);

StructuredBuffer<uint4> srvRoomInfo : register(t84);

Texture2DArray<float4> srvBillboardArray : register(t16);

Texture2D<float4> srvPreintegratedGGXLUT : register(t110);

Texture2D<float4> srvReflectionsColor : register(t80);

Texture2D<uint> srvReflectionsWeight : register(t81);

Texture2D<float2> srvSSDGIHalfBentNormals : register(t77);

TextureCubeArray<float4> srvBoxReflectionCube : register(t21);

TextureCubeArray<float4> srvBoxReflectionCubeDiffuse : register(t22);

TextureCubeArray<float4> srvBoxReflectionCube2 : register(t24);

TextureCubeArray<float4> srvBoxReflectionCubeDiffuse2 : register(t23);

StructuredBuffer<SCSLightData> srvLightIndexData : register(t86);

StructuredBuffer<uint> srvLightMappingData : register(t87);

Texture2D<uint> srvScreenSpaceContactLocalShadowMask : register(t88);

Texture2D<float2> srvDeferredShadingPass_DeferredShadows : register(t0);

Texture2D<float4> srvDeferredShadingPass_SoftShadowsMask : register(t1);

TextureCube<float4> srvDeferredShadingPass_BackdropCube : register(t2);

Texture2D<float4> srvDeferredShadingPass_SunDisc : register(t3);

Texture2D<float4> srvDeferredShadingPass_SSGIColor : register(t4);

Texture2D<float> srvDeferredShadingPass_SSGIOcclusion : register(t5);

Texture2D<float> srvDeferredShadingPass_HalfResDepth : register(t6);

RWTexture2D<float3> uavDeferredShadingPass_Specular : register(u0);

RWTexture2D<float3> uavDeferredShadingPass_Diffuse : register(u1);

cbuffer cbBindless : register(b0, space2) {
  SMaterialBindlessOffset cbBindless : packoffset(c000.x);
};

cbuffer _cbSharedPerViewData : register(b2) {
  S_cbSharedPerViewData cbSharedPerViewData : packoffset(c000.x);
};

cbuffer _cbDeferredShading : register(b4) {
  S_cbDeferredShading cbDeferredShading : packoffset(c000.x);
};

SamplerState samplerPointClampNode : register(s0);

SamplerState samplerPointBorderWhiteNode : register(s3);

SamplerState samplerLinearClampNode : register(s4);

SamplerState samplerLinearWrapNode : register(s5);

SamplerState samplerLinearBorderBlackNode : register(s6);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}
uint firstbithigh_msb(uint value) {
  return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value));
}

groupshared uint _global_0;
groupshared uint _global_1;
groupshared uint _global_2;
groupshared uint _global_3[64];
groupshared uint _global_4[64];
groupshared uint _global_5[64];
groupshared uint _global_6[64];
static const float _global_7[128] = { 1.0f, 0.0f, -0.7373688817024231f, 0.6754903197288513f, 0.08742572367191315f, -0.9961710572242737f, 0.6084388494491577f, 0.7936007380485535f, -0.9847134947776794f, -0.1741819530725479f, 0.843755304813385f, -0.536728024482727f, -0.2596043050289154f, 0.9657150506973267f, -0.4609070122241974f, -0.8874484300613403f, 0.9393212795257568f, 0.3430386185646057f, -0.9243455529212952f, 0.3815564215183258f, 0.4238460063934326f, -0.9057343006134033f, 0.29928386211395264f, 0.9541641473770142f, -0.8652111887931824f, -0.5014075636863708f, 0.9766757488250732f, -0.21471942961215973f, -0.5751294493675232f, 0.818062424659729f, -0.12851068377494812f, -0.9917080998420715f, 0.764648973941803f, 0.6444469690322876f, -0.999146044254303f, 0.04131782799959183f, 0.708829402923584f, -0.7053799629211426f, -0.04619144648313522f, 0.9989326000213623f, -0.6407091617584229f, -0.7677837014198303f, 0.9910694360733032f, 0.13334698975086212f, -0.820858359336853f, 0.5711318254470825f, 0.21948136389255524f, -0.9756166934967041f, 0.49718087911605835f, 0.8676469326019287f, -0.9526928067207336f, -0.3039349913597107f, 0.9077911376953125f, -0.41942253708839417f, -0.38606107234954834f, 0.9224731922149658f, -0.3384522795677185f, -0.9409835338592529f, 0.885189414024353f, 0.4652307629585266f, -0.9669700264930725f, 0.25489020347595215f, 0.5408377647399902f, -0.8411269187927246f, 0.1693761795759201f, 0.9855514764785767f, -0.7906231880187988f, -0.6123030185699463f, 0.9965856671333313f, -0.08256508409976959f, -0.6790793538093567f, 0.7340648770332336f, 0.004878276959061623f, -0.9999880790710449f, 0.6718851923942566f, 0.7406553626060486f, -0.9957327246665955f, -0.09228428453207016f, 0.7965594530105591f, -0.6045601963996887f, -0.17898358404636383f, 0.9838520884513855f, -0.5326055884361267f, -0.8463635444641113f, 0.9644371867179871f, 0.2643122375011444f, -0.8896862864494324f, 0.4565723240375519f, 0.3476168215274811f, -0.93763667345047f, 0.37704265117645264f, 0.9261959195137024f, -0.9036558866500854f, -0.42825937271118164f, 0.9556127786636353f, -0.2946256399154663f, -0.5056223273277283f, 0.8627548813819885f, -0.20995238423347473f, -0.9777116179466248f, 0.8152470588684082f, 0.5791133046150208f, -0.9923232197761536f, 0.12367133051156998f, 0.6481694579124451f, -0.7614961266517639f, 0.03644322231411934f, 0.9993357062339783f, -0.7019136548042297f, -0.7122620344161987f, 0.9986953735351562f, 0.05106396600604057f, -0.7709001302719116f, 0.6369560360908508f, 0.13818010687828064f, -0.9904071092605591f, 0.5671206712722778f, 0.823634684085846f, -0.9745343923568726f, -0.2242380827665329f, 0.870061993598938f, -0.49294233322143555f, -0.30857884883880615f, 0.9511987566947937f, -0.41498908400535583f, -0.909826397895813f, 0.9205789566040039f, 0.39055657386779785f };

#include "deferred_soft_shadow.hlsli"

[numthreads(8, 8, 1)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  uint _53;
  int _59;
  uint _64;
  uint _65;
  uint _72;
  int _75;
  int _90;
  float _270;
  float _271;
  float _272;
  float _273;
  float _363;
  float _364;
  float _402;
  int _440;
  float _441;
  float _442;
  float _443;
  int _562;
  float _563;
  float _564;
  float _565;
  float _566;
  float _567;
  float _568;
  float _569;
  float _570;
  float _571;
  float _572;
  float _573;
  float _574;
  float _575;
  float _576;
  float _691;
  float _692;
  float _693;
  float _780;
  float _781;
  float _782;
  float _800;
  float _801;
  float _802;
  float _834;
  float _835;
  float _836;
  float _837;
  float _838;
  float _839;
  float _840;
  float _854;
  float _855;
  float _856;
  float _857;
  float _858;
  float _859;
  float _860;
  float _861;
  float _862;
  float _863;
  float _864;
  float _865;
  float _866;
  float _867;
  float _872;
  float _873;
  float _874;
  float _875;
  float _876;
  float _877;
  float _878;
  float _879;
  float _880;
  float _881;
  float _882;
  float _883;
  float _884;
  float _885;
  float _934;
  float _935;
  float _936;
  float _956;
  float _957;
  float _958;
  float _969;
  float _970;
  float _971;
  float _972;
  float _973;
  float _974;
  float _977;
  float _978;
  float _979;
  float _980;
  float _981;
  float _982;
  float _983;
  float _997;
  float _998;
  float _999;
  float _1000;
  float _1001;
  float _1002;
  float _1031;
  float _1032;
  float _1033;
  float _1053;
  float _1054;
  float _1055;
  float _1066;
  float _1067;
  float _1068;
  float _1069;
  float _1070;
  float _1071;
  float _1090;
  float _1091;
  float _1092;
  float _1093;
  float _1094;
  float _1095;
  float _1114;
  float _1115;
  float _1116;
  int _1157;
  float _1158;
  float _1276;
  float _1281;
  float _1297;
  float _1354;
  float _1370;
  float _1423;
  float _1424;
  float _1425;
  float _1478;
  float _1479;
  float _1480;
  float _1590;
  float _1595;
  float _1596;
  float _1597;
  float _1598;
  float _1599;
  float _1600;
  int _1601;
  float _2222;
  float _2223;
  float _2224;
  float _2314;
  float _2323;
  float _2332;
  float _2340;
  float _2411;
  float _2420;
  float _2429;
  float _2437;
  float _2510;
  float _2519;
  float _2528;
  float _2536;
  float _2609;
  float _2618;
  float _2627;
  float _2635;
  float _2687;
  float _2692;
  float _2789;
  float _2810;
  float _2811;
  float _2812;
  int _2831;
  float _2848;
  float _2852;
  float _2891;
  float _2923;
  float _3033;
  float _3034;
  float _3046;
  float _3058;
  float _3129;
  float _3220;
  float _3221;
  float _3222;
  float _3251;
  float _3361;
  float _3362;
  float _3374;
  float _3386;
  float _3448;
  float _3449;
  float _3450;
  float _3481;
  float _3510;
  float _3511;
  float _3512;
  float _3528;
  float _3529;
  float _3530;
  float _3543;
  float _3544;
  float _3545;
  float _3714;
  float _3715;
  float _3716;
  float _3717;
  float _3718;
  float _3719;
  float _3811;
  float _3812;
  float _3813;
  float _3814;
  float _3815;
  float _3918;
  float _3927;
  float _3936;
  float _3944;
  float _4015;
  float _4024;
  float _4033;
  float _4041;
  float _4114;
  float _4123;
  float _4132;
  float _4140;
  float _4213;
  float _4222;
  float _4231;
  float _4239;
  float _4574;
  float _4575;
  int _4576;
  float _4605;
  float _4606;
  float _4607;
  float _4608;
  float _4609;
  float _4711;
  float _4720;
  float _4729;
  float _4737;
  float _4808;
  float _4817;
  float _4826;
  float _4834;
  float _4907;
  float _4916;
  float _4925;
  float _4933;
  float _5006;
  float _5015;
  float _5024;
  float _5032;
  float _5366;
  float _5367;
  bool _5368;
  float _5383;
  float _5384;
  float _5385;
  float _5443;
  float _5444;
  float _5469;
  float _5470;
  float _5565;
  float _5568;
  float _5569;
  float _5589;
  float _5590;
  float _5591;
  int _5609;
  float _5626;
  float _5630;
  float _5657;
  float _5658;
  float _5659;
  float _5690;
  float _5719;
  float _5720;
  float _5721;
  float _5737;
  float _5738;
  float _5739;
  float _5775;
  float _5823;
  float _5824;
  float _5825;
  float _5841;
  float _5901;
  float _5902;
  float _5903;
  float _6024;
  float _6025;
  float _6038;
  float _6050;
  float _6051;
  float _6071;
  float _6257;
  float _6836;
  float _6837;
  float _6838;
  float _6928;
  float _6937;
  float _6946;
  float _6954;
  float _7025;
  float _7034;
  float _7043;
  float _7051;
  float _7124;
  float _7133;
  float _7142;
  float _7150;
  float _7223;
  float _7232;
  float _7241;
  float _7249;
  float _7301;
  float _7306;
  float _7307;
  float _7404;
  float _7405;
  float _7426;
  float _7427;
  float _7428;
  int _7447;
  float _7464;
  float _7472;
  float _7498;
  float _7499;
  float _7500;
  float _7531;
  float _7560;
  float _7561;
  float _7562;
  float _7578;
  float _7579;
  float _7580;
  float _7616;
  float _7664;
  float _7665;
  float _7666;
  float _7682;
  float _7742;
  float _7743;
  float _7744;
  float _7865;
  float _7866;
  float _7879;
  float _7891;
  float _7892;
  float _7912;
  float _8108;
  float _8109;
  float _8133;
  float _8134;
  float _8159;
  float _8160;
  float _8185;
  float _8186;
  float _8329;
  float _8330;
  float _8331;
  float _8355;
  float _8446;
  float _8447;
  float _8448;
  float _8462;
  float _8463;
  float _8464;
  float _8465;
  float _8466;
  float _8467;
  float _8472;
  float _8473;
  float _8474;
  float _8475;
  float _8476;
  float _8477;
  float _8626;
  float _8627;
  float _8628;
  float _8637;
  float _8638;
  float _8639;
  float _8640;
  float _8641;
  float _8642;
  float _8643;
  float _8644;
  float _8645;
  int _86;
  uint _92;
  int _99;
  int _104;
  int _107;
  int _109;
  int _111;
  int _113;
  float4 _118;
  float _126;
  float _127;
  float _135;
  float _136;
  float4 _139;
  float4 _143;
  float4 _149;
  float4 _152;
  float _159;
  float _160;
  float _161;
  float _165;
  float _170;
  float _171;
  float _175;
  float _177;
  float _178;
  float _183;
  float _184;
  float _186;
  float _187;
  float _188;
  float _189;
  float _191;
  float _192;
  float _193;
  float _194;
  float _203;
  float _204;
  float _211;
  float _212;
  float _213;
  float _219;
  float _227;
  float _233;
  float _234;
  float _235;
  float _236;
  int _242;
  uint _246;
  float _252;
  float4 _261;
  float _282;
  float _283;
  float _298;
  float _299;
  float _302;
  float _303;
  float _306;
  float _307;
  float4 _312;
  float _346;
  float _348;
  bool _349;
  float _351;
  float _353;
  bool _354;
  float4 _367;
  float _371;
  float _383;
  float _384;
  float _385;
  float _386;
  float _387;
  float _388;
  bool _391;
  bool _405;
  int _406;
  float2 _409;
  float _414;
  float _415;
  float _419;
  float _421;
  float _422;
  float _427;
  float _428;
  float _430;
  float _431;
  float _432;
  float _433;
  float _435;
  float _444;
  float _448;
  float _449;
  float _451;
  float _452;
  float _453;
  int _461;
  int _462;
  int _463;
  int _464;
  float _468;
  float _470;
  float _471;
  float _481;
  float _486;
  float _490;
  float _491;
  float _494;
  float _507;
  float _508;
  float _509;
  float _513;
  float _528;
  float _531;
  float _534;
  float _537;
  float _540;
  float _543;
  int _579;
  int _580;
  float _583;
  float _584;
  float _585;
  float _586;
  float _589;
  float _590;
  float _591;
  float _592;
  float _595;
  float _596;
  float _597;
  float _598;
  float _601;
  float _602;
  float _603;
  float _604;
  float _607;
  float _608;
  float _609;
  float _610;
  float _613;
  float _614;
  float _615;
  float _616;
  int _619;
  float _622;
  float _623;
  float _624;
  float _627;
  float _628;
  float _629;
  int _632;
  int _635;
  int _638;
  float _667;
  float _670;
  float _673;
  float _674;
  float4 _680;
  float4 _686;
  float _695;
  float _699;
  float _702;
  float _705;
  float _746;
  float _751;
  float _753;
  float _755;
  float _762;
  float _763;
  float4 _769;
  float4 _775;
  float _783;
  float4 _789;
  float4 _795;
  float _812;
  float _813;
  float _814;
  float _815;
  float _816;
  float _817;
  float _818;
  float _819;
  float _820;
  uint _868;
  bool _891;
  int _901;
  float _903;
  float _904;
  float _911;
  float _916;
  float _917;
  bool _918;
  float4 _923;
  float4 _929;
  float _940;
  float4 _945;
  float4 _951;
  float _989;
  int _1009;
  float _1010;
  float _1013;
  float _1014;
  bool _1015;
  float4 _1020;
  float4 _1026;
  float _1037;
  float4 _1042;
  float4 _1048;
  float _1076;
  float _1129;
  float4 _1132;
  float _1135;
  float _1136;
  float _1140;
  float _1144;
  float _1145;
  float _1146;
  float _1153;
  uint _1159;
  int _1162;
  int _1163;
  int _1167;
  int _1171;
  float _1183;
  float _1188;
  float _1189;
  float _1190;
  float _1191;
  float _1194;
  float _1195;
  float _1196;
  float _1197;
  float _1200;
  float _1201;
  float _1202;
  float _1203;
  int _1206;
  int _1209;
  int _1212;
  int _1215;
  float _1230;
  float _1234;
  float _1238;
  float _1263;
  float _1264;
  float _1265;
  float _1268;
  uint _1277;
  bool _1285;
  float _1300;
  float _1302;
  float _1303;
  float _1304;
  float _1305;
  float _1310;
  float _1311;
  float _1312;
  float _1313;
  float _1315;
  float _1324;
  float _1325;
  float _1330;
  float _1336;
  float _1344;
  float _1357;
  float _1360;
  float _1363;
  int _1373;
  int _1376;
  int _1377;
  int _1378;
  int _1384;
  int _1385;
  int _1386;
  int _1392;
  int _1393;
  int _1394;
  float _1400;
  float _1404;
  float _1408;
  float _1415;
  int _1428;
  int _1431;
  int _1432;
  int _1433;
  int _1439;
  int _1440;
  int _1441;
  int _1447;
  int _1448;
  int _1449;
  float _1455;
  float _1459;
  float _1463;
  float _1470;
  float _1503;
  float _1507;
  float _1511;
  float _1530;
  float _1534;
  float _1538;
  float _1551;
  float _1552;
  float _1553;
  uint _1591;
  int _1603;
  int _1607;
  int _1608;
  int _1609;
  int _1610;
  int _1622;
  int _1626;
  float _1638;
  int _1641;
  float _1658;
  float _1663;
  float _1664;
  float _1665;
  float _1666;
  float _1669;
  float _1670;
  float _1671;
  float _1672;
  float _1675;
  float _1676;
  float _1677;
  float _1678;
  int _1681;
  int _1684;
  int _1687;
  int _1690;
  int _1693;
  float _1695;
  float _1696;
  float _1698;
  float _1702;
  float _1715;
  float _1719;
  float _1723;
  float _1748;
  float _1749;
  float _1750;
  float _1753;
  float _1754;
  float _1761;
  float _1782;
  float _1783;
  float _1784;
  float _1785;
  float _1788;
  float _1789;
  float _1790;
  float _1791;
  float _1794;
  float _1795;
  float _1796;
  float _1797;
  float _1800;
  float _1801;
  float _1802;
  float _1805;
  int _1808;
  int _1811;
  int _1814;
  int _1817;
  int _1820;
  float _1823;
  float _1824;
  float _1825;
  float _1826;
  int _1829;
  int _1832;
  int _1835;
  int _1838;
  int _1841;
  int _1844;
  int _1847;
  int _1850;
  float _1852;
  float _1853;
  float _1855;
  float _1859;
  float _1862;
  float _1864;
  int _1867;
  float _1877;
  float _1878;
  float _1880;
  float _1881;
  float _1882;
  float _1883;
  float _1902;
  float _1906;
  float _1907;
  float _1908;
  float _1912;
  float _1916;
  float _1920;
  float _1921;
  float _1944;
  float _1945;
  float _1946;
  float _1949;
  float _1950;
  float _1957;
  float _1958;
  float _1959;
  float _1964;
  float _1966;
  float _1967;
  float _1970;
  float _1974;
  float _1983;
  float _1984;
  float _1985;
  int _1986;
  float _1991;
  float _2000;
  float _2001;
  float _2003;
  float4 _2008;
  float _2013;
  float _2015;
  float _2017;
  float _2019;
  float _2023;
  float _2025;
  float _2029;
  float _2031;
  int _2038;
  float _2043;
  float _2052;
  float _2053;
  float4 _2059;
  float _2064;
  float _2066;
  float _2070;
  float _2072;
  float _2076;
  float _2078;
  float _2082;
  float _2084;
  int _2091;
  float _2096;
  float _2105;
  float _2106;
  float4 _2112;
  float _2117;
  float _2119;
  float _2123;
  float _2125;
  float _2129;
  float _2131;
  float _2135;
  float _2137;
  int _2144;
  float _2149;
  float _2158;
  float _2159;
  float4 _2165;
  float _2170;
  float _2172;
  float _2176;
  float _2178;
  float _2182;
  float _2184;
  float _2188;
  float _2190;
  float _2191;
  float _2202;
  float _2208;
  float _2210;
  float _2212;
  float _2219;
  float _2227;
  float _2228;
  float _2237;
  float _2241;
  float _2250;
  float _2251;
  float _2252;
  float _2257;
  int _2258;
  float _2263;
  float _2272;
  float _2273;
  float _2275;
  float _2277;
  float _2278;
  float4 _2280;
  float _2284;
  float _2285;
  float _2288;
  float _2289;
  float _2294;
  float _2295;
  float _2298;
  float _2299;
  float _2301;
  float _2303;
  bool _2304;
  bool _2305;
  bool _2315;
  bool _2324;
  float _2341;
  float _2343;
  float _2345;
  float _2347;
  float _2351;
  float _2353;
  float _2357;
  float _2359;
  int _2366;
  float _2371;
  float _2380;
  float _2381;
  float _2384;
  float _2385;
  float4 _2387;
  float _2391;
  float _2392;
  float _2395;
  float _2396;
  float _2398;
  float _2400;
  bool _2401;
  bool _2402;
  bool _2412;
  bool _2421;
  float _2438;
  float _2440;
  float _2444;
  float _2446;
  float _2450;
  float _2452;
  float _2456;
  float _2458;
  int _2465;
  float _2470;
  float _2479;
  float _2480;
  float _2483;
  float _2484;
  float4 _2486;
  float _2490;
  float _2491;
  float _2494;
  float _2495;
  float _2497;
  float _2499;
  bool _2500;
  bool _2501;
  bool _2511;
  bool _2520;
  float _2537;
  float _2539;
  float _2543;
  float _2545;
  float _2549;
  float _2551;
  float _2555;
  float _2557;
  int _2564;
  float _2569;
  float _2578;
  float _2579;
  float _2582;
  float _2583;
  float4 _2585;
  float _2589;
  float _2590;
  float _2593;
  float _2594;
  float _2596;
  float _2598;
  bool _2599;
  bool _2600;
  bool _2610;
  bool _2619;
  float _2636;
  float _2638;
  float _2642;
  float _2644;
  float _2648;
  float _2650;
  float _2654;
  float _2656;
  float _2657;
  float _2668;
  float _2674;
  float _2676;
  float _2678;
  float _2698;
  float4 _2705;
  float _2719;
  float _2720;
  float _2721;
  float _2722;
  float _2724;
  float _2729;
  float _2732;
  float _2733;
  float _2735;
  float _2736;
  float _2741;
  float _2746;
  float _2748;
  float _2751;
  float _2752;
  float _2757;
  float _2759;
  float _2761;
  float _2763;
  float _2768;
  float _2774;
  float _2776;
  float3 _2802;
  float _2813;
  float4 _2834;
  int _2862;
  int _2867;
  int _2869;
  int _2870;
  int _2872;
  int _2873;
  int _2882;
  bool _2895;
  float _2898;
  float _2900;
  float _2901;
  float _2902;
  float _2903;
  float _2904;
  float _2905;
  float _2913;
  float _2918;
  float _2924;
  float _2928;
  float _2930;
  float _2931;
  float _2932;
  float _2935;
  bool _2942;
  float _2946;
  float _2948;
  float _2949;
  float _2957;
  float _2960;
  float _2961;
  float _2966;
  float _2975;
  float _2976;
  float _2979;
  float _2981;
  float _2982;
  float _2983;
  float _2985;
  float _2986;
  float _2987;
  float _2988;
  float _2993;
  float _3007;
  float _3012;
  float _3013;
  float _3015;
  float _3021;
  float _3024;
  float _3035;
  float _3036;
  float _3047;
  float _3062;
  float _3069;
  float _3072;
  float _3073;
  float _3085;
  float _3088;
  float _3089;
  float _3090;
  float _3091;
  float _3098;
  float _3099;
  float _3100;
  float _3112;
  float _3132;
  float _3133;
  float _3134;
  float _3135;
  float _3138;
  float _3139;
  float _3140;
  float _3141;
  float _3144;
  float _3145;
  float _3146;
  int _3149;
  int _3152;
  int _3155;
  int _3158;
  int _3161;
  int _3164;
  float _3167;
  float _3171;
  float _3173;
  int _3175;
  float2 _3195;
  float3 _3212;
  float _3225;
  float _3228;
  float _3229;
  float _3230;
  float _3231;
  float _3232;
  float _3233;
  float _3241;
  float _3246;
  float _3252;
  float _3256;
  float _3258;
  float _3259;
  float _3260;
  float _3263;
  bool _3270;
  float _3274;
  float _3276;
  float _3277;
  float _3285;
  float _3288;
  float _3289;
  float _3294;
  float _3303;
  float _3304;
  float _3307;
  float _3309;
  float _3310;
  float _3311;
  float _3313;
  float _3314;
  float _3315;
  float _3316;
  float _3321;
  float _3335;
  float _3340;
  float _3341;
  float _3343;
  float _3349;
  float _3352;
  float _3363;
  float _3364;
  float _3375;
  float _3390;
  float _3400;
  float _3409;
  float _3410;
  float _3422;
  float _3425;
  float _3438;
  bool _3451;
  float _3452;
  float _3453;
  float _3454;
  bool _3455;
  float _3457;
  float _3458;
  float _3462;
  float _3468;
  float _3482;
  float _3483;
  float _3486;
  float _3490;
  int _3491;
  float _3493;
  float _3495;
  float _3498;
  float _3502;
  float _3513;
  float _3514;
  float _3515;
  float _3517;
  float _3531;
  float _3532;
  float _3533;
  float _3549;
  float _3550;
  float _3551;
  float _3554;
  float _3575;
  float _3576;
  float _3577;
  float _3580;
  float _3581;
  float _3582;
  float _3585;
  float _3586;
  float _3587;
  float _3590;
  float _3591;
  float _3592;
  float _3595;
  float _3596;
  float _3597;
  int _3600;
  int _3603;
  int _3606;
  int _3609;
  int _3612;
  int _3615;
  int _3618;
  int _3621;
  int _3624;
  int _3627;
  int _3630;
  float _3633;
  float _3634;
  float _3635;
  float _3636;
  int _3639;
  int _3642;
  int _3645;
  int _3648;
  float _3650;
  float _3651;
  float _3653;
  float _3657;
  float _3660;
  float _3661;
  float _3663;
  float _3667;
  float _3669;
  float _3670;
  float _3672;
  int _3675;
  bool _3679;
  float _3687;
  float _3688;
  float _3690;
  float _3693;
  float _3694;
  float _3696;
  float _3697;
  float _3699;
  float _3700;
  float _3704;
  float _3710;
  float _3711;
  float _3712;
  float _3723;
  float _3724;
  float _3725;
  float _3726;
  float _3727;
  float _3728;
  float _3729;
  float _3730;
  float _3731;
  float _3734;
  float _3735;
  float _3736;
  float _3739;
  float _3746;
  float _3759;
  float _3763;
  float _3767;
  float _3768;
  float _3769;
  float _3772;
  float _3775;
  bool _3777;
  float _3783;
  float _3784;
  float _3785;
  float _3790;
  float _3791;
  float _3792;
  bool _3796;
  bool _3802;
  bool _3806;
  float _3816;
  float _3820;
  float _3829;
  float _3830;
  float _3837;
  float _3838;
  float _3841;
  float _3845;
  float _3854;
  float _3855;
  float _3856;
  float _3861;
  int _3862;
  float _3867;
  float _3876;
  float _3877;
  float _3879;
  float _3881;
  float _3882;
  float4 _3884;
  float _3888;
  float _3889;
  float _3892;
  float _3893;
  float _3898;
  float _3899;
  float _3902;
  float _3903;
  float _3905;
  float _3907;
  bool _3908;
  bool _3909;
  bool _3919;
  bool _3928;
  float _3945;
  float _3947;
  float _3949;
  float _3951;
  float _3955;
  float _3957;
  float _3961;
  float _3963;
  int _3970;
  float _3975;
  float _3984;
  float _3985;
  float _3988;
  float _3989;
  float4 _3991;
  float _3995;
  float _3996;
  float _3999;
  float _4000;
  float _4002;
  float _4004;
  bool _4005;
  bool _4006;
  bool _4016;
  bool _4025;
  float _4042;
  float _4044;
  float _4048;
  float _4050;
  float _4054;
  float _4056;
  float _4060;
  float _4062;
  int _4069;
  float _4074;
  float _4083;
  float _4084;
  float _4087;
  float _4088;
  float4 _4090;
  float _4094;
  float _4095;
  float _4098;
  float _4099;
  float _4101;
  float _4103;
  bool _4104;
  bool _4105;
  bool _4115;
  bool _4124;
  float _4141;
  float _4143;
  float _4147;
  float _4149;
  float _4153;
  float _4155;
  float _4159;
  float _4161;
  int _4168;
  float _4173;
  float _4182;
  float _4183;
  float _4186;
  float _4187;
  float4 _4189;
  float _4193;
  float _4194;
  float _4197;
  float _4198;
  float _4200;
  float _4202;
  bool _4203;
  bool _4204;
  bool _4214;
  bool _4223;
  float _4240;
  float _4242;
  float _4246;
  float _4248;
  float _4252;
  float _4254;
  float _4258;
  float _4260;
  float _4261;
  float _4272;
  float _4278;
  float _4280;
  float _4282;
  float _4291;
  float _4294;
  float _4295;
  float _4309;
  float _4310;
  float _4311;
  float _4315;
  float _4324;
  float _4325;
  float _4326;
  int _4327;
  float _4332;
  float _4341;
  float _4342;
  float _4344;
  float4 _4349;
  float _4354;
  float _4356;
  float _4358;
  float _4360;
  float _4364;
  float _4366;
  float _4370;
  float _4372;
  int _4379;
  float _4384;
  float _4393;
  float _4394;
  float4 _4400;
  float _4405;
  float _4407;
  float _4411;
  float _4413;
  float _4417;
  float _4419;
  float _4423;
  float _4425;
  int _4432;
  float _4437;
  float _4446;
  float _4447;
  float4 _4453;
  float _4458;
  float _4460;
  float _4464;
  float _4466;
  float _4470;
  float _4472;
  float _4476;
  float _4478;
  int _4485;
  float _4490;
  float _4499;
  float _4500;
  float4 _4506;
  float _4511;
  float _4513;
  float _4517;
  float _4519;
  float _4523;
  float _4525;
  float _4529;
  float _4531;
  float _4532;
  float _4543;
  float _4549;
  float _4551;
  float _4553;
  float _4561;
  float _4568;
  float _4570;
  float _4584;
  float _4585;
  float _4586;
  bool _4590;
  bool _4596;
  bool _4600;
  float _4610;
  float _4615;
  float _4624;
  float _4625;
  float _4630;
  float _4631;
  float _4634;
  float _4638;
  float _4647;
  float _4648;
  float _4649;
  float _4654;
  int _4655;
  float _4660;
  float _4669;
  float _4670;
  float _4672;
  float _4674;
  float _4675;
  float4 _4677;
  float _4681;
  float _4682;
  float _4685;
  float _4686;
  float _4691;
  float _4692;
  float _4695;
  float _4696;
  float _4698;
  float _4700;
  bool _4701;
  bool _4702;
  bool _4712;
  bool _4721;
  float _4738;
  float _4740;
  float _4742;
  float _4744;
  float _4748;
  float _4750;
  float _4754;
  float _4756;
  int _4763;
  float _4768;
  float _4777;
  float _4778;
  float _4781;
  float _4782;
  float4 _4784;
  float _4788;
  float _4789;
  float _4792;
  float _4793;
  float _4795;
  float _4797;
  bool _4798;
  bool _4799;
  bool _4809;
  bool _4818;
  float _4835;
  float _4837;
  float _4841;
  float _4843;
  float _4847;
  float _4849;
  float _4853;
  float _4855;
  int _4862;
  float _4867;
  float _4876;
  float _4877;
  float _4880;
  float _4881;
  float4 _4883;
  float _4887;
  float _4888;
  float _4891;
  float _4892;
  float _4894;
  float _4896;
  bool _4897;
  bool _4898;
  bool _4908;
  bool _4917;
  float _4934;
  float _4936;
  float _4940;
  float _4942;
  float _4946;
  float _4948;
  float _4952;
  float _4954;
  int _4961;
  float _4966;
  float _4975;
  float _4976;
  float _4979;
  float _4980;
  float4 _4982;
  float _4986;
  float _4987;
  float _4990;
  float _4991;
  float _4993;
  float _4995;
  bool _4996;
  bool _4997;
  bool _5007;
  bool _5016;
  float _5033;
  float _5035;
  float _5039;
  float _5041;
  float _5045;
  float _5047;
  float _5051;
  float _5053;
  float _5054;
  float _5065;
  float _5071;
  float _5073;
  float _5075;
  float _5084;
  float _5087;
  float _5088;
  float _5101;
  float _5102;
  float _5103;
  float _5107;
  float _5116;
  float _5117;
  float _5118;
  int _5119;
  float _5124;
  float _5133;
  float _5134;
  float _5136;
  float4 _5141;
  float _5146;
  float _5148;
  float _5150;
  float _5152;
  float _5156;
  float _5158;
  float _5162;
  float _5164;
  int _5171;
  float _5176;
  float _5185;
  float _5186;
  float4 _5192;
  float _5197;
  float _5199;
  float _5203;
  float _5205;
  float _5209;
  float _5211;
  float _5215;
  float _5217;
  int _5224;
  float _5229;
  float _5238;
  float _5239;
  float4 _5245;
  float _5250;
  float _5252;
  float _5256;
  float _5258;
  float _5262;
  float _5264;
  float _5268;
  float _5270;
  int _5277;
  float _5282;
  float _5291;
  float _5292;
  float4 _5298;
  float _5303;
  float _5305;
  float _5309;
  float _5311;
  float _5315;
  float _5317;
  float _5321;
  float _5323;
  float _5324;
  float _5335;
  float _5341;
  float _5343;
  float _5345;
  float _5353;
  float _5360;
  float _5362;
  float _5388;
  float _5390;
  float _5391;
  float _5392;
  float _5407;
  float _5410;
  float _5413;
  float _5415;
  float _5416;
  float _5417;
  float _5418;
  float _5426;
  float _5427;
  float _5428;
  bool _5430;
  float _5450;
  float4 _5475;
  float _5495;
  float _5496;
  float _5497;
  float _5498;
  float _5500;
  float _5505;
  float _5508;
  float _5509;
  float _5511;
  float _5512;
  float _5517;
  float _5522;
  float _5524;
  float _5527;
  float _5528;
  float _5533;
  float _5535;
  float _5537;
  float _5539;
  float _5544;
  float _5550;
  float _5552;
  float3 _5581;
  float4 _5612;
  float _5647;
  bool _5660;
  float _5661;
  float _5662;
  float _5663;
  bool _5664;
  float _5666;
  float _5667;
  float _5671;
  float _5677;
  float _5691;
  float _5692;
  float _5695;
  float _5699;
  int _5700;
  float _5702;
  float _5704;
  float _5707;
  float _5711;
  float _5722;
  float _5723;
  float _5724;
  float _5726;
  int _5746;
  int _5751;
  int _5753;
  int _5754;
  int _5756;
  int _5757;
  int _5766;
  bool _5779;
  float _5782;
  float _5784;
  float _5785;
  float _5786;
  float _5787;
  float _5788;
  float _5789;
  float _5790;
  float _5791;
  float _5792;
  float _5793;
  float _5794;
  float _5795;
  bool _5796;
  float _5797;
  float _5798;
  float _5801;
  float _5802;
  float _5804;
  float _5831;
  float _5836;
  float _5843;
  float _5844;
  float _5845;
  float _5847;
  float _5851;
  float _5852;
  float _5853;
  float _5854;
  float _5855;
  float _5856;
  float _5857;
  float _5863;
  float _5872;
  float _5876;
  float _5877;
  float _5878;
  float _5879;
  float _5883;
  float _5884;
  float _5885;
  float _5893;
  float _5905;
  float _5906;
  float _5907;
  float _5908;
  float _5909;
  float _5913;
  float _5915;
  float _5917;
  float _5921;
  float _5922;
  float _5923;
  float _5926;
  bool _5933;
  float _5937;
  float _5939;
  float _5940;
  float _5948;
  float _5951;
  float _5952;
  float _5957;
  float _5966;
  float _5967;
  float _5970;
  float _5972;
  float _5973;
  float _5974;
  float _5976;
  float _5977;
  float _5978;
  float _5979;
  float _5984;
  float _5998;
  float _6003;
  float _6004;
  float _6006;
  float _6012;
  float _6015;
  float _6026;
  float _6028;
  float _6047;
  float _6058;
  float _6075;
  float _6082;
  float _6085;
  float _6086;
  float _6087;
  float _6099;
  float _6102;
  float _6103;
  float _6104;
  float _6105;
  float _6112;
  float _6113;
  float _6114;
  float _6127;
  float _6148;
  float _6149;
  float _6150;
  float _6153;
  float _6154;
  float _6155;
  float _6158;
  int _6161;
  int _6164;
  int _6167;
  float _6176;
  float _6179;
  float _6182;
  float _6189;
  float _6194;
  float _6196;
  float _6198;
  float _6199;
  float _6200;
  float _6202;
  float _6203;
  float _6204;
  float _6207;
  float _6208;
  float _6209;
  float _6212;
  float _6219;
  int _6228;
  int _6233;
  int _6235;
  int _6236;
  int _6238;
  int _6239;
  int _6248;
  bool _6261;
  float _6263;
  float _6264;
  float _6265;
  float _6266;
  float _6269;
  float _6272;
  float _6276;
  float _6277;
  float _6278;
  float _6282;
  float _6289;
  float _6292;
  float _6293;
  float _6294;
  float _6306;
  float _6308;
  float _6309;
  float _6310;
  float _6311;
  float _6318;
  float _6319;
  float _6320;
  float _6335;
  float _6356;
  float _6357;
  float _6358;
  float _6361;
  float _6362;
  float _6363;
  float _6366;
  float _6367;
  float _6368;
  float _6371;
  float _6372;
  float _6373;
  float _6376;
  float _6377;
  float _6378;
  float _6381;
  float _6382;
  float _6383;
  int _6386;
  int _6389;
  int _6392;
  int _6395;
  float _6398;
  float _6399;
  float _6400;
  float _6401;
  int _6404;
  int _6407;
  int _6410;
  int _6413;
  int _6416;
  int _6419;
  int _6422;
  float _6425;
  float _6426;
  float _6427;
  float _6428;
  int _6431;
  int _6434;
  int _6437;
  float _6439;
  float _6440;
  float _6442;
  float _6446;
  float _6449;
  float _6450;
  float _6452;
  float _6456;
  int _6460;
  float _6476;
  float _6477;
  float _6479;
  float _6480;
  float _6481;
  float _6482;
  float _6483;
  float _6484;
  float _6485;
  float _6486;
  float _6487;
  float _6488;
  float _6489;
  float _6490;
  float _6491;
  float _6494;
  float _6495;
  float _6496;
  float _6499;
  float _6510;
  float _6514;
  float _6521;
  float _6522;
  float _6523;
  float _6535;
  float _6536;
  float _6537;
  float _6538;
  float _6541;
  float _6542;
  float _6545;
  float _6546;
  float _6553;
  float _6555;
  float _6561;
  bool _6563;
  float _6571;
  float _6572;
  float _6573;
  float _6578;
  float _6580;
  float _6581;
  float _6584;
  float _6588;
  float _6597;
  float _6598;
  float _6599;
  int _6600;
  float _6605;
  float _6614;
  float _6615;
  float _6617;
  float4 _6622;
  float _6627;
  float _6629;
  float _6631;
  float _6633;
  float _6637;
  float _6639;
  float _6643;
  float _6645;
  int _6652;
  float _6657;
  float _6666;
  float _6667;
  float4 _6673;
  float _6678;
  float _6680;
  float _6684;
  float _6686;
  float _6690;
  float _6692;
  float _6696;
  float _6698;
  int _6705;
  float _6710;
  float _6719;
  float _6720;
  float4 _6726;
  float _6731;
  float _6733;
  float _6737;
  float _6739;
  float _6743;
  float _6745;
  float _6749;
  float _6751;
  int _6758;
  float _6763;
  float _6772;
  float _6773;
  float4 _6779;
  float _6784;
  float _6786;
  float _6790;
  float _6792;
  float _6796;
  float _6798;
  float _6802;
  float _6804;
  float _6805;
  float _6816;
  float _6822;
  float _6824;
  float _6826;
  float _6833;
  float _6841;
  float _6842;
  float _6851;
  float _6855;
  float _6864;
  float _6865;
  float _6866;
  float _6871;
  int _6872;
  float _6877;
  float _6886;
  float _6887;
  float _6889;
  float _6891;
  float _6892;
  float4 _6894;
  float _6898;
  float _6899;
  float _6902;
  float _6903;
  float _6908;
  float _6909;
  float _6912;
  float _6913;
  float _6915;
  float _6917;
  bool _6918;
  bool _6919;
  bool _6929;
  bool _6938;
  float _6955;
  float _6957;
  float _6959;
  float _6961;
  float _6965;
  float _6967;
  float _6971;
  float _6973;
  int _6980;
  float _6985;
  float _6994;
  float _6995;
  float _6998;
  float _6999;
  float4 _7001;
  float _7005;
  float _7006;
  float _7009;
  float _7010;
  float _7012;
  float _7014;
  bool _7015;
  bool _7016;
  bool _7026;
  bool _7035;
  float _7052;
  float _7054;
  float _7058;
  float _7060;
  float _7064;
  float _7066;
  float _7070;
  float _7072;
  int _7079;
  float _7084;
  float _7093;
  float _7094;
  float _7097;
  float _7098;
  float4 _7100;
  float _7104;
  float _7105;
  float _7108;
  float _7109;
  float _7111;
  float _7113;
  bool _7114;
  bool _7115;
  bool _7125;
  bool _7134;
  float _7151;
  float _7153;
  float _7157;
  float _7159;
  float _7163;
  float _7165;
  float _7169;
  float _7171;
  int _7178;
  float _7183;
  float _7192;
  float _7193;
  float _7196;
  float _7197;
  float4 _7199;
  float _7203;
  float _7204;
  float _7207;
  float _7208;
  float _7210;
  float _7212;
  bool _7213;
  bool _7214;
  bool _7224;
  bool _7233;
  float _7250;
  float _7252;
  float _7256;
  float _7258;
  float _7262;
  float _7264;
  float _7268;
  float _7270;
  float _7271;
  float _7282;
  float _7288;
  float _7290;
  float _7292;
  float _7313;
  float4 _7320;
  float _7334;
  float _7335;
  float _7336;
  float _7337;
  float _7339;
  float _7344;
  float _7347;
  float _7348;
  float _7350;
  float _7351;
  float _7356;
  float _7361;
  float _7363;
  float _7366;
  float _7367;
  float _7372;
  float _7374;
  float _7376;
  float _7378;
  float _7383;
  float _7389;
  float _7391;
  float3 _7418;
  float _7429;
  float4 _7450;
  float _7488;
  bool _7501;
  float _7502;
  float _7503;
  float _7504;
  bool _7505;
  float _7507;
  float _7508;
  float _7512;
  float _7518;
  float _7532;
  float _7533;
  float _7536;
  float _7540;
  int _7541;
  float _7543;
  float _7545;
  float _7548;
  float _7552;
  float _7563;
  float _7564;
  float _7565;
  float _7567;
  int _7587;
  int _7592;
  int _7594;
  int _7595;
  int _7597;
  int _7598;
  int _7607;
  bool _7620;
  float _7623;
  float _7625;
  float _7626;
  float _7627;
  float _7628;
  float _7629;
  float _7630;
  float _7631;
  float _7632;
  float _7633;
  float _7634;
  float _7635;
  float _7636;
  bool _7637;
  float _7638;
  float _7639;
  float _7642;
  float _7643;
  float _7645;
  float _7672;
  float _7677;
  float _7684;
  float _7685;
  float _7686;
  float _7688;
  float _7692;
  float _7693;
  float _7694;
  float _7695;
  float _7696;
  float _7697;
  float _7698;
  float _7704;
  float _7713;
  float _7717;
  float _7718;
  float _7719;
  float _7720;
  float _7724;
  float _7725;
  float _7726;
  float _7734;
  float _7746;
  float _7747;
  float _7748;
  float _7749;
  float _7750;
  float _7754;
  float _7756;
  float _7758;
  float _7762;
  float _7763;
  float _7764;
  float _7767;
  bool _7774;
  float _7778;
  float _7780;
  float _7781;
  float _7789;
  float _7792;
  float _7793;
  float _7798;
  float _7807;
  float _7808;
  float _7811;
  float _7813;
  float _7814;
  float _7815;
  float _7817;
  float _7818;
  float _7819;
  float _7820;
  float _7825;
  float _7839;
  float _7844;
  float _7845;
  float _7847;
  float _7853;
  float _7856;
  float _7867;
  float _7869;
  float _7888;
  float _7899;
  float _7916;
  float _7923;
  float _7926;
  float _7927;
  float _7928;
  float _7940;
  float _7943;
  float _7944;
  float _7945;
  float _7946;
  float _7953;
  float _7954;
  float _7955;
  float _7968;
  float _7989;
  float _7990;
  float _7991;
  float _7992;
  float _7995;
  float _7996;
  float _7997;
  float _7998;
  float _8001;
  float _8002;
  float _8003;
  float _8004;
  float _8007;
  float _8008;
  int _8011;
  int _8014;
  int _8017;
  int _8020;
  float _8023;
  float _8025;
  float _8026;
  float _8028;
  float _8032;
  float _8034;
  float _8038;
  float _8042;
  float _8046;
  float _8049;
  float _8052;
  float _8055;
  float _8067;
  float _8068;
  float _8069;
  float _8070;
  float _8071;
  float _8072;
  float _8073;
  float _8074;
  float _8075;
  float _8076;
  float _8077;
  float _8079;
  float _8081;
  float _8083;
  float _8085;
  float _8086;
  float _8092;
  float _8094;
  float _8101;
  float _8116;
  float _8118;
  float _8125;
  float _8135;
  float _8141;
  float _8143;
  float _8150;
  float _8167;
  float _8169;
  float _8176;
  float _8195;
  float _8196;
  float _8197;
  float _8198;
  float _8200;
  float _8202;
  float _8203;
  float _8204;
  float _8205;
  float _8206;
  float _8207;
  float _8208;
  float _8209;
  float _8211;
  float _8213;
  float _8214;
  float _8215;
  float _8216;
  float _8217;
  float _8218;
  float _8219;
  float _8221;
  float _8223;
  float _8230;
  bool _8243;
  float _8245;
  float _8251;
  float _8255;
  float _8257;
  float _8258;
  bool _8259;
  float _8261;
  float _8267;
  float _8268;
  float _8273;
  float _8274;
  float _8277;
  float _8279;
  float _8286;
  float _8299;
  float _8301;
  float _8308;
  float _8337;
  float _8338;
  float _8347;
  float _8356;
  float _8357;
  float _8363;
  float _8368;
  float _8377;
  float _8384;
  float _8387;
  float4 _8395;
  float _8397;
  float4 _8398;
  float _8407;
  float _8425;
  float _8426;
  float _8454;
  uint _8468;
  float _8479;
  float _8486;
  float _8497;
  float _8516;
  float _8519;
  float _8522;
  float4 _8543;
  float _8547;
  float _8548;
  float _8549;
  float _8551;
  float _8552;
  float _8553;
  float _8554;
  float _8555;
  float _8556;
  float _8557;
  float _8558;
  float _8559;
  float _8564;
  float _8569;
  float _8582;
  float4 _8590;
  float _8592;
  float _8599;
  bool _8632;
  _53 = (SV_GroupIndex - ((int)(SV_GroupIndex) % (int)(WaveGetLaneCount()))) + (uint)(WaveGetLaneIndex());
  _59 = srvLightFeaturePermutationTiles[((int)((uint)(cbDeferredShading.nPermutationOffset) + SV_GroupID.x))];
  _64 = ((uint)(((int)(_59 << 3)) & 524280)) + SV_GroupThreadID.x;
  _65 = ((uint)(((uint)(_59) >> 16) << 3)) + SV_GroupThreadID.y;
  _72 = ((int)((((uint)(_65) >> 4) * cbSharedPerViewData.viClusteredLightingClusterParams.x) + ((uint)((uint)(_64) >> 4)))) << 6;
  _75 = srvDeferredClusters[_72];
  if (_53 == 0) {
    _global_2 = (_75 & 255);
    _global_0 = (((uint)(_75) >> 16) & 255);
    _global_1 = (((uint)(_75) >> 8) & 255);
  }
  GroupMemoryBarrierWithGroupSync();
  _86 = (uint)((uint)(_global_2) + 63u) >> 6;
  if (!(_86 == 0)) {
    _90 = 0;
    bool _loop_break_0 = false;
    while (true) {
      _92 = (_90 << 6) + _53;
      do {
        if ((uint)_92 < (uint)_global_2) {
          _99 = srvDeferredClusters[((int)(((uint)(_72 | 1)) + _92))];
          _global_3[min((uint)(_92), 63u)] = _99;
          _104 = _99 & 4095;
          _107 = srvLightInfoBase[_104].nFlags;
          _109 = srvLightInfoBase[_104].nRoomMask;
          _111 = srvLightInfoBase[_104].nBufferOffset;
          _global_4[min((uint)(_92), 63u)] = _107;
          _global_5[min((uint)(_92), 63u)] = _109;
          _global_6[min((uint)(_92), 63u)] = _111;
        }
        _113 = _90 + 1;
        do {
          if (!(_113 == _86)) {
            _90 = _113;
            _loop_break_0 = true;
            break;
          }
        } while (false);
        if (_loop_break_0) break;
      } while (false);
      if (_loop_break_0) {
        _loop_break_0 = false;
        continue;
      }
      break;
    }
  }
  GroupMemoryBarrierWithGroupSync();
  _118 = srvGlobalGBuffer0.Load(int3(_64, _65, 0));
  [branch]
  if (_118.x == 1.0f) {
    uavDeferredShadingPass_Specular[int2(_64, _65)] = float3(0.0f, 0.0f, 0.0f);
    uavDeferredShadingPass_Diffuse[int2(_64, _65)] = float3(0.0f, 0.0f, 0.0f);
  } else {
    _126 = (float)((uint)_64);
    _127 = (float)((uint)_65);
    _135 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].x) * _126) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].z);
    _136 = ((cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].y) * _127) + (cbSharedPerViewData.vPixelToEyeVectorScaleBias[0].w);
    do {
      [branch]
      if (_118.x > 0.0f) {
        _139 = srvGlobalGBuffer1.Load(int3(_64, _65, 0));
        _143 = srvGlobalGBuffer2.Load(int3(_64, _65, 0));
        _149 = srvGlobalGBuffer3.Load(int3(_64, _65, 0));
        _152 = srvGlobalGBuffer4.Load(int3(_64, _65, 0));
        _159 = saturate(_143.x);
        _160 = saturate(_143.y);
        _161 = saturate(_143.z);
        _165 = saturate(_152.y);
        _170 = (saturate(_139.x) * 2.0f) + -1.0f;
        _171 = (saturate(_139.y) * 2.0f) + -1.0f;
        _175 = (1.0f - abs(_170)) - abs(_171);
        _177 = saturate(-0.0f - _175);
        _178 = -0.0f - _177;
        _183 = select((_170 >= 0.0f), _178, _177) + _170;
        _184 = select((_171 >= 0.0f), _178, _177) + _171;
        _186 = rsqrt(dot(float3(_183, _184, _175), float3(_183, _184, _175)));
        _187 = _183 * _186;
        _188 = _184 * _186;
        _189 = _186 * _175;
        _191 = rsqrt(dot(float3(_187, _188, _189), float3(_187, _188, _189)));
        _192 = _191 * _187;
        _193 = _191 * _188;
        _194 = _191 * _189;
        _203 = saturate(_149.x);
        _204 = saturate(_149.y) * 0.07999999821186066f;
        _211 = (_203 * (_159 - _204)) + _204;
        _212 = (_203 * (_160 - _204)) + _204;
        _213 = (_203 * (_161 - _204)) + _204;
        _219 = min(1.0f, max(saturate(_152.x), 0.019999999552965164f));
        _227 = (_203 * (1.0f - _204)) + _204;
        _233 = 1.0f / ((cbSharedPerViewData.vViewRemap.z * _118.x) - cbSharedPerViewData.vViewRemap.y);
        _234 = _233 * _135;
        _235 = _233 * _136;
        _236 = -0.0f - _233;
        _242 = (int)(uint)((int)(cbSharedPerViewData.nSSRHalfRes != 0));
        _246 = srvReflectionsWeight.Load(int3(((uint)(_64) >> _242), ((uint)(_65) >> _242), 0));
        _252 = ((float)((uint)((uint)(_246.x & 254)))) * 0.003921568859368563f;
        do {
          _270 = 1.0f;
          _271 = 0.0f;
          _272 = 0.0f;
          _273 = 0.0f;
          if ((_246.x & 1) == 0) {
            #if FIRSTLIGHT_SSR_ENABLED
            if (CUSTOM_SSR_REFLECTION_FIX >= 1.5f) {
              int2 renodx_ssr_pixel = int2(((uint)(_64) >> _242), ((uint)(_65) >> _242));
              int renodx_gbuffer_step = (int)(1u << (uint)(_242));
              uint renodx_ssr_width;
              uint renodx_ssr_height;
              uint renodx_gbuffer_width;
              uint renodx_gbuffer_height;
              srvReflectionsWeight.GetDimensions(renodx_ssr_width, renodx_ssr_height);
              srvGlobalGBuffer0.GetDimensions(renodx_gbuffer_width, renodx_gbuffer_height);

              float renodx_center_reflection_weight = _252;
              float3 renodx_center_reflection_color = srvReflectionsColor.Load(int3(renodx_ssr_pixel, 0)).xyz;
              float3 renodx_center_normal = float3(_192, _193, _194);
              float3 renodx_filtered_color = float3(0.0f, 0.0f, 0.0f);
              float renodx_filter_kernel_sum = 0.0f;

              if (renodx_center_reflection_weight > 0.0f) {
                [unroll]
                for (int renodx_y = -2; renodx_y <= 2; renodx_y++) {
                  [unroll]
                  for (int renodx_x = -2; renodx_x <= 2; renodx_x++) {
                    int2 renodx_ssr_sample_pixel = renodx_ssr_pixel + int2(renodx_x, renodx_y);
                    int2 renodx_gbuffer_sample_pixel = int2(_64, _65) + (int2(renodx_x, renodx_y) * renodx_gbuffer_step);
                    if (((renodx_ssr_sample_pixel.x | renodx_ssr_sample_pixel.y | renodx_gbuffer_sample_pixel.x | renodx_gbuffer_sample_pixel.y) >= 0)
                        && ((uint)(renodx_ssr_sample_pixel.x) < renodx_ssr_width)
                        && ((uint)(renodx_ssr_sample_pixel.y) < renodx_ssr_height)
                        && ((uint)(renodx_gbuffer_sample_pixel.x) < renodx_gbuffer_width)
                        && ((uint)(renodx_gbuffer_sample_pixel.y) < renodx_gbuffer_height)) {
                      uint renodx_sample_packed_weight = srvReflectionsWeight.Load(int3(renodx_ssr_sample_pixel, 0));
                      float renodx_sample_reflection_weight = ((float)((uint)(renodx_sample_packed_weight & 254u))) * 0.003921568859368563f;
                      float renodx_weight_similarity = saturate(1.0f - (abs(renodx_sample_reflection_weight - renodx_center_reflection_weight) / max(0.0625f, renodx_center_reflection_weight)));
                      renodx_weight_similarity *= renodx_weight_similarity;
                      if (((renodx_sample_packed_weight & 1u) == 0u) && (renodx_sample_reflection_weight > 0.0f) && (renodx_weight_similarity > 0.0f)) {
                        float2 renodx_filter_offset = float2((float)(renodx_x), (float)(renodx_y));
                        float renodx_spatial_weight = rcp(1.0f + (dot(renodx_filter_offset, renodx_filter_offset) * 0.5f));

                        float renodx_sample_depth = srvGlobalGBuffer0.Load(int3(renodx_gbuffer_sample_pixel, 0)).x;
                        float renodx_sample_view_depth = 1.0f / ((cbSharedPerViewData.vViewRemap.z * renodx_sample_depth) - cbSharedPerViewData.vViewRemap.y);
                        float renodx_depth_sigma = max(0.05000000074505806f, abs(_233) * 0.029999999329447746f);
                        float renodx_depth_weight = saturate(1.0f - (abs(renodx_sample_view_depth - _233) / renodx_depth_sigma));
                        renodx_depth_weight *= renodx_depth_weight;

                        float3 renodx_sample_normal = RenoDX_DecodeDeferredNormal(srvGlobalGBuffer1.Load(int3(renodx_gbuffer_sample_pixel, 0)).xy);
                        float renodx_normal_weight = saturate((dot(renodx_center_normal, renodx_sample_normal) + -0.800000011920929f) * 5.0f);
                        renodx_normal_weight *= renodx_normal_weight;

                        float renodx_kernel_weight = renodx_spatial_weight * renodx_depth_weight * renodx_normal_weight * renodx_weight_similarity;
                        float3 renodx_sample_reflection_color = srvReflectionsColor.Load(int3(renodx_ssr_sample_pixel, 0)).xyz;
                        renodx_filtered_color += renodx_sample_reflection_color * renodx_kernel_weight;
                        renodx_filter_kernel_sum += renodx_kernel_weight;
                      }
                    }
                  }
                }
              }

              if (renodx_filter_kernel_sum > 0.0f) {
                float3 renodx_filtered_reflection_color = renodx_filtered_color / renodx_filter_kernel_sum;
                float renodx_center_luminance = dot(renodx_center_reflection_color, float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                float renodx_filtered_luminance = dot(renodx_filtered_reflection_color, float3(0.2125999927520752f, 0.7152000069618225f, 0.0722000002861023f));
                renodx_filtered_reflection_color *= min(1.0f, (renodx_center_luminance + 9.999999747378752e-05f) / max(renodx_filtered_luminance, 9.999999747378752e-05f));
                _252 = renodx_center_reflection_weight;
                _261 = float4(lerp(renodx_center_reflection_color, renodx_filtered_reflection_color, 0.8500000238418579f), 1.0f);
              } else {
                _261 = float4(renodx_center_reflection_color, 1.0f);
              }
            } else if (CUSTOM_SSR_REFLECTION_FIX != 0.0f) {
              _261 = srvReflectionsColor.Load(int3(((uint)(_64) >> _242), ((uint)(_65) >> _242), 0));
            } else {
              _261 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _126), (cbSharedPerViewData.vViewportSize.y * _127)), 0.0f);
            }
            #else
            _261 = srvReflectionsColor.SampleLevel(samplerLinearClampNode, float2((cbSharedPerViewData.vViewportSize.x * _126), (cbSharedPerViewData.vViewportSize.y * _127)), 0.0f);
            #endif
            _270 = (1.0f - _252);
            _271 = (_261.x * _252);
            _272 = (_261.y * _252);
            _273 = (_261.z * _252);
          }
          _282 = cbSharedPerViewData.vViewportSize.x * (_126 + 0.5f);
          _283 = cbSharedPerViewData.vViewportSize.y * (_127 + 0.5f);
          do {
            _363 = _282;
            _364 = _283;
            if (!(cbDeferredShading.nSSGIHalfRes == 0)) {
              _298 = (floor((_282 - cbDeferredShading.vScreenPixelSize.z) / cbDeferredShading.vScreenPixelSize.x) * cbDeferredShading.vScreenPixelSize.x) + cbDeferredShading.vScreenPixelSize.z;
              _299 = (floor((_283 - cbDeferredShading.vScreenPixelSize.w) / cbDeferredShading.vScreenPixelSize.y) * cbDeferredShading.vScreenPixelSize.y) + cbDeferredShading.vScreenPixelSize.w;
              _302 = max(_298, cbDeferredShading.vScreenPixelSize.z);
              _303 = max(_299, cbDeferredShading.vScreenPixelSize.w);
              _306 = min((_298 + cbDeferredShading.vScreenPixelSize.x), (1.0f - cbDeferredShading.vScreenPixelSize.z));
              _307 = min((_299 + cbDeferredShading.vScreenPixelSize.y), (1.0f - cbDeferredShading.vScreenPixelSize.w));
              _312 = srvDeferredShadingPass_HalfResDepth.GatherRed(samplerPointClampNode, float2((_302 + cbDeferredShading.vScreenPixelSize.z), (_303 + cbDeferredShading.vScreenPixelSize.w)));
              if ((((abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.x) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.y) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.z) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f)) || (abs((1.0f / ((cbSharedPerViewData.vViewRemap.z * _312.w) - cbSharedPerViewData.vViewRemap.y)) - _233) > 0.029999999329447746f)) {
                _346 = abs(_118.x - _312.w);
                _348 = abs(_118.x - _312.z);
                _349 = (_348 < _346);
                _351 = select(_349, _348, _346);
                _353 = abs(_118.x - _312.x);
                _354 = (_353 < _351);
                if (abs(_118.x - _312.y) < select(_354, _353, _351)) {
                  _363 = _306;
                  _364 = _307;
                } else {
                  _363 = select(_354, _302, select(_349, _306, _302));
                  _364 = select(_354, _307, _303);
                }
              } else {
                _363 = _282;
                _364 = _283;
              }
            }
            _367 = srvDeferredShadingPass_SSGIColor.SampleLevel(samplerLinearClampNode, float2(_363, _364), 0.0f);
            _371 = _367.x - _367.z;
            _383 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_367.y + _371)), 0.0f);
            _384 = -0.0f - _383;
            _385 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_367.x + _367.z)), 0.0f);
            _386 = -0.0f - _385;
            _387 = cbSharedPerViewData.vHDRScale.x * min((-0.0f - (_371 - _367.y)), 0.0f);
            _388 = -0.0f - _387;
            _391 = (cbSharedPerViewData.nSSGIEnabled == 0);
            do {
              _402 = 1.0f;
              if (!(_391)) {
                if (!((cbSharedPerViewData.nLightingFeatureFlags & 3072) == 0)) {
                  _402 = ((srvDeferredShadingPass_SSGIOcclusion.SampleLevel(samplerLinearClampNode, float2(_363, _364), 0.0f)).x);
                } else {
                  _402 = 1.0f;
                }
              }
              do {
                _440 = 0;
                _441 = 0.0f;
                _442 = 0.0f;
                _443 = 0.0f;
                if (!(_391)) {
                  _405 = (cbSharedPerViewData.nBentNormalsEnabled != 0);
                  _406 = (int)(uint)(_405);
                  if (_405) {
                    _409 = srvSSDGIHalfBentNormals.SampleLevel(samplerLinearClampNode, float2(_363, _364), 0.0f);
                    _414 = (_409.x * 2.0f) + -1.0f;
                    _415 = (_409.y * 2.0f) + -1.0f;
                    _419 = (1.0f - abs(_414)) - abs(_415);
                    _421 = saturate(-0.0f - _419);
                    _422 = -0.0f - _421;
                    _427 = select((_414 >= 0.0f), _422, _421) + _414;
                    _428 = select((_415 >= 0.0f), _422, _421) + _415;
                    _430 = rsqrt(dot(float3(_427, _428, _419), float3(_427, _428, _419)));
                    _431 = _427 * _430;
                    _432 = _428 * _430;
                    _433 = _430 * _419;
                    _435 = rsqrt(dot(float3(_431, _432, _433), float3(_431, _432, _433)));
                    _440 = _406;
                    _441 = (_431 * _435);
                    _442 = (_432 * _435);
                    _443 = (_435 * _433);
                  } else {
                    _440 = _406;
                    _441 = 0.0f;
                    _442 = 0.0f;
                    _443 = 0.0f;
                  }
                }
                _444 = 1.0f - _203;
                _448 = -0.0f - _135;
                _449 = -0.0f - _136;
                _451 = rsqrt(dot(float3(_448, _449, 1.0f), float3(_448, _449, 1.0f)));
                _452 = _451 * _448;
                _453 = _451 * _449;
                _461 = srvLightDeferredRoomTiles[((int)(((int)(uint(cbSharedPerViewData.vViewportSize.z)) * _65) + _64))];
                _462 = _461 & 255;
                _463 = (uint)(_461) >> 8;
                _464 = _463 & 255;
                _468 = ((float)((uint)((uint)(((uint)(_461) >> 16) & 255)))) * 0.003921568859368563f;
                _470 = (float)((uint)((uint)((uint)(_461) >> 24)));
                _471 = _470 * 0.003921568859368563f;
                do {
                  _1090 = 0.0f;
                  _1091 = 0.0f;
                  _1092 = 0.0f;
                  _1093 = 0.0f;
                  _1094 = 0.0f;
                  _1095 = 0.0f;
                  [branch]
                  if (!((((int)(uint((saturate(_143.w) * 255.0f) + 0.5f)) & 192) == 128) || ((cbSharedPerViewData.nLightingFeatureFlags & 1) == 0))) {
                    _481 = _219 * 4.0f;
                    _486 = dot(float3((-0.0f - _452), (-0.0f - _453), (-0.0f - _451)), float3(_192, _193, _194)) * 2.0f;
                    _490 = _219 * _219;
                    _491 = 1.0f - _490;
                    _494 = (sqrt(_491) + _490) * _491;
                    _507 = (_494 * (((-0.0f - _192) - _452) - (_486 * _192))) + _192;
                    _508 = (_494 * (((-0.0f - _193) - _453) - (_486 * _193))) + _193;
                    _509 = (_494 * (((-0.0f - _194) - _451) - (_486 * _194))) + _194;
                    _513 = saturate(1.0f - ((_219 + -0.30000001192092896f) * 3.3333332538604736f));
                    _528 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _509, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _508, (_507 * (cbSharedPerViewData.mViewToWorld[0][0].x))));
                    _531 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _509, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _508, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _507)));
                    _534 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _509, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _508, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _507)));
                    _537 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _194, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _193, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _192)));
                    _540 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _194, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _193, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _192)));
                    _543 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _194, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _193, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _192)));
                    do {
                      _872 = 0.0f;
                      _873 = 0.0f;
                      _874 = 0.0f;
                      _875 = 0.0f;
                      _876 = 0.0f;
                      _877 = 0.0f;
                      _878 = 0.0f;
                      _879 = 0.0f;
                      _880 = 0.0f;
                      _881 = 0.0f;
                      _882 = 0.0f;
                      _883 = 0.0f;
                      _884 = 0.0f;
                      _885 = 0.0f;
                      if (!(_global_0 == 0)) {
                        _562 = 0;
                        _563 = 0.0f;
                        _564 = 0.0f;
                        _565 = 0.0f;
                        _566 = 0.0f;
                        _567 = 0.0f;
                        _568 = 0.0f;
                        _569 = 0.0f;
                        _570 = 0.0f;
                        _571 = 0.0f;
                        _572 = 0.0f;
                        _573 = 0.0f;
                        _574 = 0.0f;
                        _575 = 0.0f;
                        _576 = 0.0f;
                        bool _loop_break_1 = false;
                        while (true) {
                          _579 = _global_5[min((uint)(_562), 63u)];
                          _580 = _global_6[min((uint)(_562), 63u)];
                          _583 = asfloat(srvLightInfoProperties.Load4(_580)).x;
                          _584 = asfloat(srvLightInfoProperties.Load4(_580)).y;
                          _585 = asfloat(srvLightInfoProperties.Load4(_580)).z;
                          _586 = asfloat(srvLightInfoProperties.Load4(_580)).w;
                          _589 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 16u)))).x;
                          _590 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 16u)))).y;
                          _591 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 16u)))).z;
                          _592 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 16u)))).w;
                          _595 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 32u)))).x;
                          _596 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 32u)))).y;
                          _597 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 32u)))).z;
                          _598 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 32u)))).w;
                          _601 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 48u)))).x;
                          _602 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 48u)))).y;
                          _603 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 48u)))).z;
                          _604 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 48u)))).w;
                          _607 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 64u)))).x;
                          _608 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 64u)))).y;
                          _609 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 64u)))).z;
                          _610 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 64u)))).w;
                          _613 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 80u)))).x;
                          _614 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 80u)))).y;
                          _615 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 80u)))).z;
                          _616 = asfloat(srvLightInfoProperties.Load4(((int)(_580 + 80u)))).w;
                          _619 = asint(srvLightInfoProperties.Load(((int)(_580 + 96u))));
                          _622 = asfloat(srvLightInfoProperties.Load3(((int)(_580 + 100u)))).x;
                          _623 = asfloat(srvLightInfoProperties.Load3(((int)(_580 + 100u)))).y;
                          _624 = asfloat(srvLightInfoProperties.Load3(((int)(_580 + 100u)))).z;
                          _627 = asfloat(srvLightInfoProperties.Load3(((int)(_580 + 112u)))).x;
                          _628 = asfloat(srvLightInfoProperties.Load3(((int)(_580 + 112u)))).y;
                          _629 = asfloat(srvLightInfoProperties.Load3(((int)(_580 + 112u)))).z;
                          _632 = asint(srvLightInfoProperties.Load(((int)(_580 + 124u))));
                          _635 = asint(srvLightInfoProperties.Load(((int)(_580 + 128u))));
                          _638 = _619 & 65535;
                          _667 = ((saturate(1.0f - abs(mad(_585, _236, mad(_584, _235, (_583 * _234))) + _586)) * f16tof32(((uint)((uint)(_619) >> 16)))) * saturate(1.0f - abs(mad(_591, _236, mad(_590, _235, (_589 * _234))) + _592))) * saturate(1.0f - abs(mad(_597, _236, mad(_596, _235, (_595 * _234))) + _598));
                          do {
                            _854 = _563;
                            _855 = _564;
                            _856 = _565;
                            _857 = _566;
                            _858 = _567;
                            _859 = _568;
                            _860 = _569;
                            _861 = _570;
                            _862 = _571;
                            _863 = _572;
                            _864 = _573;
                            _865 = _574;
                            _866 = _575;
                            _867 = _576;
                            [branch]
                            if (_667 > 0.0f) {
                              _670 = _667 * _667;
                              do {
                                _691 = 0.0f;
                                _692 = 0.0f;
                                _693 = 0.0f;
                                [branch]
                                if (_513 < 1.0f) {
                                  _673 = (float)((uint)_638);
                                  _674 = -0.0f - _528;
                                  [branch]
                                  if (!(!(_673 >= 341.0f))) {
                                    _680 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_674, _531, _534, (_673 + -341.0f)), _481);
                                    _691 = _680.x;
                                    _692 = _680.y;
                                    _693 = _680.z;
                                  } else {
                                    _686 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_674, _531, _534, _673), _481);
                                    _691 = _686.x;
                                    _692 = _686.y;
                                    _693 = _686.z;
                                  }
                                }
                                _695 = (float)((uint)_638);
                                do {
                                  _780 = 0.0f;
                                  _781 = 0.0f;
                                  _782 = 0.0f;
                                  [branch]
                                  if (_513 > 0.0f) {
                                    _699 = mad(_603, _509, mad(_602, _508, (_601 * _507)));
                                    _702 = mad(_609, _509, mad(_608, _508, (_607 * _507)));
                                    _705 = mad(_615, _509, mad(_614, _508, (_613 * _507)));
                                    _746 = min(((((float((int)(((int)(uint)((int)(_699 > 0.0f))) - ((int)(uint)((int)(_699 < 0.0f))))) * _622) - _604) - mad(_603, _236, mad(_602, _235, (_601 * _234)))) / _699), min(((((float((int)(((int)(uint)((int)(_702 > 0.0f))) - ((int)(uint)((int)(_702 < 0.0f))))) * _623) - _610) - mad(_609, _236, mad(_608, _235, (_607 * _234)))) / _702), ((((float((int)(((int)(uint)((int)(_705 > 0.0f))) - ((int)(uint)((int)(_705 < 0.0f))))) * _624) - _616) - mad(_615, _236, mad(_614, _235, (_613 * _234)))) / _705)));
                                    _751 = ((mad((cbSharedPerViewData.mViewToWorld[0][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _235, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][0].w)) - _627) + (_746 * _528);
                                    _753 = ((mad((cbSharedPerViewData.mViewToWorld[0][1].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _235, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][1].w)) - _628) + (_746 * _531);
                                    _755 = ((mad((cbSharedPerViewData.mViewToWorld[0][2].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _235, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][2].w)) - _629) + (_746 * _534);
                                    _762 = (max(log2((_746 * _746) / dot(float3(_751, _753, _755), float3(_751, _753, _755))), -1.0f) * 0.3333333432674408f) + _481;
                                    _763 = -0.0f - _751;
                                    [branch]
                                    if (!(!(_695 >= 341.0f))) {
                                      _769 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_763, _753, _755, (_695 + -341.0f)), _762);
                                      _780 = _769.x;
                                      _781 = _769.y;
                                      _782 = _769.z;
                                    } else {
                                      _775 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_763, _753, _755, _695), _762);
                                      _780 = _775.x;
                                      _781 = _775.y;
                                      _782 = _775.z;
                                    }
                                  }
                                  _783 = -0.0f - _537;
                                  do {
                                    [branch]
                                    if (!(!(_695 >= 341.0f))) {
                                      _789 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_783, _540, _543, (_695 + -341.0f)), 0.0f);
                                      _800 = _789.x;
                                      _801 = _789.y;
                                      _802 = _789.z;
                                    } else {
                                      _795 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_783, _540, _543, _695), 0.0f);
                                      _800 = _795.x;
                                      _801 = _795.y;
                                      _802 = _795.z;
                                    }
                                    _812 = _670 * f16tof32(((uint)((uint)(_632) >> 16)));
                                    _813 = _812 * _800;
                                    _814 = _670 * f16tof32(_632);
                                    _815 = _814 * _801;
                                    _816 = _670 * f16tof32(((uint)((uint)(_635) >> 16)));
                                    _817 = _816 * _802;
                                    _818 = _812 * (lerp(_691, _780, _513));
                                    _819 = _814 * (lerp(_692, _781, _513));
                                    _820 = _816 * (lerp(_693, _782, _513));
                                    do {
                                      _834 = _563;
                                      _835 = _564;
                                      _836 = _565;
                                      _837 = _566;
                                      _838 = _567;
                                      _839 = _568;
                                      _840 = _569;
                                      [branch]
                                      if (!((_579 & ((int)(1 << (_461 & 31)))) == 0)) {
                                        _834 = (_813 + _563);
                                        _835 = (_815 + _564);
                                        _836 = (_817 + _565);
                                        _837 = (_818 + _566);
                                        _838 = (_819 + _567);
                                        _839 = (_820 + _568);
                                        _840 = (_670 + _569);
                                      }
                                      [branch]
                                      if (!((_579 & ((int)(1 << (_463 & 31)))) == 0)) {
                                        _854 = _834;
                                        _855 = _835;
                                        _856 = _836;
                                        _857 = _837;
                                        _858 = _838;
                                        _859 = _839;
                                        _860 = _840;
                                        _861 = (_813 + _570);
                                        _862 = (_815 + _571);
                                        _863 = (_817 + _572);
                                        _864 = (_818 + _573);
                                        _865 = (_819 + _574);
                                        _866 = (_820 + _575);
                                        _867 = (_670 + _576);
                                      } else {
                                        _854 = _834;
                                        _855 = _835;
                                        _856 = _836;
                                        _857 = _837;
                                        _858 = _838;
                                        _859 = _839;
                                        _860 = _840;
                                        _861 = _570;
                                        _862 = _571;
                                        _863 = _572;
                                        _864 = _573;
                                        _865 = _574;
                                        _866 = _575;
                                        _867 = _576;
                                      }
                                    } while (false);
                                    if (_loop_break_1) break;
                                  } while (false);
                                  if (_loop_break_1) break;
                                } while (false);
                                if (_loop_break_1) break;
                              } while (false);
                              if (_loop_break_1) break;
                            }
                            _868 = _562 + 1u;
                            do {
                              if (!(_868 == _global_0)) {
                                _562 = _868;
                                _563 = _854;
                                _564 = _855;
                                _565 = _856;
                                _566 = _857;
                                _567 = _858;
                                _568 = _859;
                                _569 = _860;
                                _570 = _861;
                                _571 = _862;
                                _572 = _863;
                                _573 = _864;
                                _574 = _865;
                                _575 = _866;
                                _576 = _867;
                                _loop_break_1 = true;
                                break;
                              }
                              _872 = _854;
                              _873 = _855;
                              _874 = _856;
                              _875 = _857;
                              _876 = _858;
                              _877 = _859;
                              _878 = _860;
                              _879 = _861;
                              _880 = _862;
                              _881 = _863;
                              _882 = _864;
                              _883 = _865;
                              _884 = _866;
                              _885 = _867;
                            } while (false);
                            if (_loop_break_1) break;
                          } while (false);
                          if (_loop_break_1) {
                            _loop_break_1 = false;
                            continue;
                          }
                          break;
                        }
                      }
                      _891 = ((cbSharedPerViewData.nFallbackRoomMask & ((int)(1 << (_461 & 31)))) != 0);
                      do {
                        _997 = 0.0f;
                        _998 = 0.0f;
                        _999 = 0.0f;
                        _1000 = 0.0f;
                        _1001 = 0.0f;
                        _1002 = 0.0f;
                        if ((_468 > 0.0f) || ((_471 > 0.0f) || _891)) {
                          _901 = srvFallbackInfo[((_462 << 2) | 3)].x;
                          _903 = select(_891, 9.999999747378752e-05f, (_470 * 3.921568847431445e-09f));
                          _904 = _878 * 0.20000000298023224f;
                          _911 = saturate((_903 - _904) / (((_878 * 0.4000000059604645f) + 9.99999993922529e-09f) - _904)) * _903;
                          do {
                            _977 = _878;
                            _978 = _875;
                            _979 = _876;
                            _980 = _877;
                            _981 = _872;
                            _982 = _873;
                            _983 = _874;
                            [branch]
                            if (_911 > 0.0f) {
                              do {
                                _969 = _875;
                                _970 = _876;
                                _971 = _877;
                                _972 = _872;
                                _973 = _873;
                                _974 = _874;
                                [branch]
                                if ((int)_901 > (int)-1) {
                                  _916 = float((int)(_901));
                                  _917 = -0.0f - _528;
                                  _918 = !(_916 >= 341.0f);
                                  do {
                                    [branch]
                                    if (!(_918)) {
                                      _923 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_917, _531, _534, (_916 + -341.0f)), _481);
                                      _934 = _923.x;
                                      _935 = _923.y;
                                      _936 = _923.z;
                                    } else {
                                      _929 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_917, _531, _534, _916), _481);
                                      _934 = _929.x;
                                      _935 = _929.y;
                                      _936 = _929.z;
                                    }
                                    _940 = -0.0f - _537;
                                    do {
                                      [branch]
                                      if (!(_918)) {
                                        _945 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_940, _540, _543, (_916 + -341.0f)), 0.0f);
                                        _956 = _945.x;
                                        _957 = _945.y;
                                        _958 = _945.z;
                                      } else {
                                        _951 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_940, _540, _543, _916), 0.0f);
                                        _956 = _951.x;
                                        _957 = _951.y;
                                        _958 = _951.z;
                                      }
                                      _969 = ((_934 * _911) + _875);
                                      _970 = ((_935 * _911) + _876);
                                      _971 = ((_936 * _911) + _877);
                                      _972 = ((_956 * _911) + _872);
                                      _973 = ((_957 * _911) + _873);
                                      _974 = ((_958 * _911) + _874);
                                    } while (false);
                                  } while (false);
                                }
                                _977 = (_911 + _878);
                                _978 = _969;
                                _979 = _970;
                                _980 = _971;
                                _981 = _972;
                                _982 = _973;
                                _983 = _974;
                              } while (false);
                            }
                            if (_977 > 0.0f) {
                              _989 = (cbSharedPerViewData.vHDRScale.x * _468) / _977;
                              _997 = (_989 * _981);
                              _998 = (_989 * _982);
                              _999 = (_989 * _983);
                              _1000 = (_989 * _978);
                              _1001 = (_989 * _979);
                              _1002 = (_989 * _980);
                            } else {
                              _997 = 0.0f;
                              _998 = 0.0f;
                              _999 = 0.0f;
                              _1000 = 0.0f;
                              _1001 = 0.0f;
                              _1002 = 0.0f;
                            }
                          } while (false);
                        }
                        [branch]
                        if (!(_471 == 0.0f)) {
                          _1009 = srvFallbackInfo[((_464 << 2) | 3)].x;
                          _1010 = _470 * 3.921568847431445e-09f;
                          do {
                            _1066 = _882;
                            _1067 = _883;
                            _1068 = _884;
                            _1069 = _879;
                            _1070 = _880;
                            _1071 = _881;
                            [branch]
                            if ((int)_1009 > (int)-1) {
                              _1013 = float((int)(_1009));
                              _1014 = -0.0f - _528;
                              _1015 = !(_1013 >= 341.0f);
                              do {
                                [branch]
                                if (!(_1015)) {
                                  _1020 = srvBoxReflectionCube2.SampleLevel(samplerLinearClampNode, float4(_1014, _531, _534, (_1013 + -341.0f)), _481);
                                  _1031 = _1020.x;
                                  _1032 = _1020.y;
                                  _1033 = _1020.z;
                                } else {
                                  _1026 = srvBoxReflectionCube.SampleLevel(samplerLinearClampNode, float4(_1014, _531, _534, _1013), _481);
                                  _1031 = _1026.x;
                                  _1032 = _1026.y;
                                  _1033 = _1026.z;
                                }
                                _1037 = -0.0f - _537;
                                do {
                                  [branch]
                                  if (!(_1015)) {
                                    _1042 = srvBoxReflectionCubeDiffuse2.SampleLevel(samplerLinearClampNode, float4(_1037, _540, _543, (_1013 + -341.0f)), 0.0f);
                                    _1053 = _1042.x;
                                    _1054 = _1042.y;
                                    _1055 = _1042.z;
                                  } else {
                                    _1048 = srvBoxReflectionCubeDiffuse.SampleLevel(samplerLinearClampNode, float4(_1037, _540, _543, _1013), 0.0f);
                                    _1053 = _1048.x;
                                    _1054 = _1048.y;
                                    _1055 = _1048.z;
                                  }
                                  _1066 = ((_1031 * _1010) + _882);
                                  _1067 = ((_1032 * _1010) + _883);
                                  _1068 = ((_1033 * _1010) + _884);
                                  _1069 = ((_1053 * _1010) + _879);
                                  _1070 = ((_1054 * _1010) + _880);
                                  _1071 = ((_1055 * _1010) + _881);
                                } while (false);
                              } while (false);
                            }
                            _1076 = (cbSharedPerViewData.vHDRScale.x * _471) / (_885 + _1010);
                            _1090 = ((_1076 * _1069) + _997);
                            _1091 = ((_1076 * _1070) + _998);
                            _1092 = ((_1076 * _1071) + _999);
                            _1093 = ((_1076 * _1066) + _1000);
                            _1094 = ((_1076 * _1067) + _1001);
                            _1095 = ((_1076 * _1068) + _1002);
                          } while (false);
                        } else {
                          _1090 = _997;
                          _1091 = _998;
                          _1092 = _999;
                          _1093 = _1000;
                          _1094 = _1001;
                          _1095 = _1002;
                        }
                      } while (false);
                    } while (false);
                  }
                  do {
                    _1114 = _1093;
                    _1115 = _1094;
                    _1116 = _1095;
                    [branch]
                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 16) == 0)) {
                      _1114 = (min((_384 / max(9.999999747378752e-05f, _1090)), 1.0f) * _1093);
                      _1115 = (min((_386 / max(9.999999747378752e-05f, _1091)), 1.0f) * _1094);
                      _1116 = (min((_388 / max(9.999999747378752e-05f, _1092)), 1.0f) * _1095);
                    }
                    _1129 = saturate(dot(float3(_452, _453, _451), float3(_192, _193, _194)));
                    _1132 = srvPreintegratedGGXLUT.SampleLevel(samplerLinearClampNode, float2(_1129, _219), 0.0f);
                    _1135 = _1132.x + _1132.y;
                    _1136 = 1.0f - _1135;
                    _1140 = max(9.999999747378752e-06f, _1135);
                    _1144 = ((_1136 * _211) / _1140) + 1.0f;
                    _1145 = ((_1136 * _212) / _1140) + 1.0f;
                    _1146 = ((_1136 * _213) / _1140) + 1.0f;
                    _1153 = min(select((cbSharedPerViewData.nPathTracingIsEnabled != 0), 1.0f, (_165 * _165)), _402);
                    do {
                      _1281 = _1153;
                      if (!(_global_1 == 0)) {
                        _1157 = 0;
                        _1158 = _1153;
                        bool _loop_break_2 = false;
                        while (true) {
                          _1159 = _1157 + (uint)(_global_0);
                          _1162 = _global_5[min((uint)(_1159), 63u)];
                          _1163 = _global_6[min((uint)(_1159), 63u)];
                          _1167 = (int)((int)(_1162 << (((int)(31u - _461)) & 31))) >> 31;
                          _1171 = (int)((int)(_1162 << ((31 - _463) & 31))) >> 31;
                          _1183 = saturate((asfloat((_1167 & asint(_468))) + asfloat((_1171 & asint(_471)))) + asfloat(((_1171 & 1065353216) & _1167)));
                          do {
                            _1276 = _1158;
                            [branch]
                            if (!(_1183 == 0.0f)) {
                              _1188 = asfloat(srvLightInfoProperties.Load4(_1163)).x;
                              _1189 = asfloat(srvLightInfoProperties.Load4(_1163)).y;
                              _1190 = asfloat(srvLightInfoProperties.Load4(_1163)).z;
                              _1191 = asfloat(srvLightInfoProperties.Load4(_1163)).w;
                              _1194 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 16u)))).x;
                              _1195 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 16u)))).y;
                              _1196 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 16u)))).z;
                              _1197 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 16u)))).w;
                              _1200 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 32u)))).x;
                              _1201 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 32u)))).y;
                              _1202 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 32u)))).z;
                              _1203 = asfloat(srvLightInfoProperties.Load4(((int)(_1163 + 32u)))).w;
                              _1206 = asint(srvLightInfoProperties.Load(((int)(_1163 + 48u))));
                              _1209 = asint(srvLightInfoProperties.Load(((int)(_1163 + 52u))));
                              _1212 = asint(srvLightInfoProperties.Load(((int)(_1163 + 56u))));
                              _1215 = asint(srvLightInfoProperties.Load(((int)(_1163 + 60u))));
                              _1230 = mad(_1190, _236, mad(_1189, _235, (_1188 * _234))) + _1191;
                              _1234 = mad(_1196, _236, mad(_1195, _235, (_1194 * _234))) + _1197;
                              _1238 = mad(_1202, _236, mad(_1201, _235, (_1200 * _234))) + _1203;
                              _1263 = saturate(1.0f - ((_1230 + 1.0f) * f16tof32(_1209))) + saturate(1.0f - ((1.0f - _1230) * f16tof32(((uint)((uint)(_1209) >> 16)))));
                              _1264 = saturate(1.0f - ((_1234 + 1.0f) * f16tof32(_1212))) + saturate(1.0f - ((1.0f - _1234) * f16tof32(((uint)((uint)(_1212) >> 16)))));
                              _1265 = saturate(1.0f - ((_1238 + 1.0f) * f16tof32(_1215))) + saturate(1.0f - ((1.0f - _1238) * f16tof32(((uint)((uint)(_1215) >> 16)))));
                              _1268 = saturate(1.0f - dot(float3(_1263, _1264, _1265), float3(_1263, _1264, _1265)));
                              _1276 = (saturate(1.0f - ((_1268 * _1268) * (f16tof32(((uint)((uint)(_1206) >> 16))) * _1183))) * _1158);
                            }
                            _1277 = _1157 + 1u;
                            do {
                              if (!(_1277 == _global_1)) {
                                _1157 = _1277;
                                _1158 = _1276;
                                _loop_break_2 = true;
                                break;
                              }
                              _1281 = _1276;
                            } while (false);
                            if (_loop_break_2) break;
                          } while (false);
                          if (_loop_break_2) {
                            _loop_break_2 = false;
                            continue;
                          }
                          break;
                        }
                      }
                      _1285 = (cbSharedPerViewData.vSpecularOcclusionSettings.x > 0.0f);
                      do {
                        _1297 = _1281;
                        if (_1285) {
                          _1297 = saturate((_1281 + -1.0f) + exp2((_219 * _219) * log2(max((_1281 + _1129), 0.0f))));
                        }
                        do {
                          _1354 = _1297;
                          if (!(_440 == 0)) {
                            _1300 = rsqrt(dot(float3(_441, _442, _443), float3(_441, _442, _443)));
                            _1302 = rsqrt(dot(float3(_192, _193, _194), float3(_192, _193, _194)));
                            _1303 = _1302 * _192;
                            _1304 = _1302 * _193;
                            _1305 = _1302 * _194;
                            if (_1285) {
                              _1310 = max(_219, 0.10000000149011612f);
                              _1311 = -0.0f - _452;
                              _1312 = -0.0f - _453;
                              _1313 = -0.0f - _451;
                              _1315 = dot(float3(_1311, _1312, _1313), float3(_1303, _1304, _1305)) * 2.0f;
                              _1324 = min(max(dot(float3((_1300 * _441), (_1300 * _442), (_1300 * _443)), float3((_1311 - (_1315 * _1303)), (_1312 - (_1315 * _1304)), (_1313 - (_1315 * _1305)))), -1.0f), 1.0f);
                              _1325 = abs(_1324);
                              _1330 = (1.5707963705062866f - (_1325 * 0.1565829962491989f)) * sqrt(1.0f - _1325);
                              _1336 = abs((_1310 - _1281) * 3.1415927410125732f);
                              _1344 = saturate(1.0f - saturate((select((_1324 >= 0.0f), _1330, (3.1415927410125732f - _1330)) - _1336) / (((_1310 + _1281) * 3.1415927410125732f) - _1336)));
                              _1354 = (((_1344 * _1344) * saturate((_1281 * 15.707963943481445f) + -0.5f)) * (3.0f - (_1344 * 2.0f)));
                            } else {
                              _1354 = _1281;
                            }
                          }
                          _1357 = ((_1144 * ((cbSharedPerViewData.vHDRScale.x * _271) + (_1114 * _270))) * ((_1132.x * _211) + _1132.y)) * _1354;
                          _1360 = ((((_1132.x * _212) + _1132.y) * ((cbSharedPerViewData.vHDRScale.x * _272) + (_1115 * _270))) * _1145) * _1354;
                          _1363 = ((((_1132.x * _213) + _1132.y) * ((cbSharedPerViewData.vHDRScale.x * _273) + (_1116 * _270))) * _1146) * _1354;
                          do {
                            _1370 = 1.0f;
                            [branch]
                            if (!((cbSharedPerViewData.nLightingFeatureFlags & 8192) == 0)) {
                              _1370 = _1281;
                            }
                            do {
                              _1423 = _384;
                              _1424 = _386;
                              _1425 = _388;
                              if (_468 > 0.0f) {
                                _1373 = _462 * 3;
                                _1376 = srvRoomInfo[_1373].x;
                                _1377 = srvRoomInfo[_1373].y;
                                _1378 = srvRoomInfo[_1373].z;
                                _1384 = srvRoomInfo[(_1373 + 1)].x;
                                _1385 = srvRoomInfo[(_1373 + 1)].y;
                                _1386 = srvRoomInfo[(_1373 + 1)].z;
                                _1392 = srvRoomInfo[(_1373 + 2)].x;
                                _1393 = srvRoomInfo[(_1373 + 2)].y;
                                _1394 = srvRoomInfo[(_1373 + 2)].z;
                                _1400 = saturate(dot(float3(_192, _193, _194), float3(asfloat(_1376), asfloat(_1377), asfloat(_1378))) + 0.5f);
                                _1404 = (_1400 * _1400) * (3.0f - (_1400 * 2.0f));
                                _1408 = 1.0f - _1404;
                                _1415 = _1370 * _468;
                                _1423 = ((_1415 * ((_1408 * asfloat(_1392)) + (_1404 * asfloat(_1384)))) - _383);
                                _1424 = ((_1415 * ((_1408 * asfloat(_1393)) + (_1404 * asfloat(_1385)))) - _385);
                                _1425 = ((_1415 * ((_1408 * asfloat(_1394)) + (_1404 * asfloat(_1386)))) - _387);
                              }
                              do {
                                _1478 = _1423;
                                _1479 = _1424;
                                _1480 = _1425;
                                if (_471 > 0.0f) {
                                  _1428 = _464 * 3;
                                  _1431 = srvRoomInfo[_1428].x;
                                  _1432 = srvRoomInfo[_1428].y;
                                  _1433 = srvRoomInfo[_1428].z;
                                  _1439 = srvRoomInfo[(_1428 + 1)].x;
                                  _1440 = srvRoomInfo[(_1428 + 1)].y;
                                  _1441 = srvRoomInfo[(_1428 + 1)].z;
                                  _1447 = srvRoomInfo[(_1428 + 2)].x;
                                  _1448 = srvRoomInfo[(_1428 + 2)].y;
                                  _1449 = srvRoomInfo[(_1428 + 2)].z;
                                  _1455 = saturate(dot(float3(_192, _193, _194), float3(asfloat(_1431), asfloat(_1432), asfloat(_1433))) + 0.5f);
                                  _1459 = (_1455 * _1455) * (3.0f - (_1455 * 2.0f));
                                  _1463 = 1.0f - _1459;
                                  _1470 = _1370 * _471;
                                  _1478 = ((_1470 * ((_1463 * asfloat(_1447)) + (_1459 * asfloat(_1439)))) + _1423);
                                  _1479 = ((_1470 * ((_1463 * asfloat(_1448)) + (_1459 * asfloat(_1440)))) + _1424);
                                  _1480 = ((_1470 * ((_1463 * asfloat(_1449)) + (_1459 * asfloat(_1441)))) + _1425);
                                }
                                do {
                                  _1590 = 0.0f;
                                  if (!(cbSharedPerViewData.nCinematicVolumeEnabled == 0)) {
                                    _1503 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _235, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][0].w);
                                    _1507 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _235, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][1].w);
                                    _1511 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _236, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _235, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _234))) + (cbSharedPerViewData.mViewToWorld[0][2].w);
                                    _1530 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].z), _1511, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].y), _1507, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[0].x) * _1503))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[0].w);
                                    _1534 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].z), _1511, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].y), _1507, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[1].x) * _1503))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[1].w);
                                    _1538 = mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].z), _1511, mad((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].y), _1507, ((cbSharedPerViewData.mCinematicVolumeWorldToObject[2].x) * _1503))) + (cbSharedPerViewData.mCinematicVolumeWorldToObject[2].w);
                                    _1551 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.x, 9.999999747378752e-06f);
                                    _1552 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.y, 9.999999747378752e-06f);
                                    _1553 = max(cbSharedPerViewData.vCinematicVolumeBoxHalfSize.z, 9.999999747378752e-06f);
                                    _1590 = min(min(saturate((_1530 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.x / _1551), 9.999999747378752e-06f)), saturate((1.0f - _1530) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.x / _1551), 9.999999747378752e-06f))), min(min(saturate((_1534 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.y / _1552), 9.999999747378752e-06f)), saturate((1.0f - _1534) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.y / _1552), 9.999999747378752e-06f))), min(saturate((_1538 + 1.0f) / max((cbSharedPerViewData.vCinematicVolumeBoxFadeNeg.z / _1553), 9.999999747378752e-06f)), saturate((1.0f - _1538) / max((cbSharedPerViewData.vCinematicVolumeBoxFadePos.z / _1553), 9.999999747378752e-06f)))));
                                  }
                                  _1591 = (uint)(_global_1) + (uint)(_global_0);
                                  do {
                                    _8472 = _1478;
                                    _8473 = _1479;
                                    _8474 = _1480;
                                    _8475 = _1357;
                                    _8476 = _1360;
                                    _8477 = _1363;
                                    if ((uint)_1591 < (uint)_global_2) {
                                      _1595 = _1478;
                                      _1596 = _1479;
                                      _1597 = _1480;
                                      _1598 = _1357;
                                      _1599 = _1360;
                                      _1600 = _1363;
                                      _1601 = _1591;
                                      bool _loop_break_3 = false;
                                      while (true) {
                                        _1603 = _global_3[min((uint)(_1601), 63u)];
                                        _1607 = _global_4[min((uint)(_1601), 63u)];
                                        _1608 = _global_5[min((uint)(_1601), 63u)];
                                        _1609 = _global_6[min((uint)(_1601), 63u)];
                                        _1610 = _1603 & 4095;
                                        do {
                                          _8462 = _1595;
                                          _8463 = _1596;
                                          _8464 = _1597;
                                          _8465 = _1598;
                                          _8466 = _1599;
                                          _8467 = _1600;
                                          [branch]
                                          if (((((int)(uint(saturate(_152.w) * 255.0f)) & 64) != 0) || ((_1607 & 8388608) == 0)) && (((int)(uint((saturate(_152.z) * 1.9921875f) + 0.003921568859368563f)) != 0) || ((_1607 & 16777216) == 0))) {
                                            _1622 = (int)((int)(_1608 << (((int)(31u - _461)) & 31))) >> 31;
                                            _1626 = (int)((int)(_1608 << ((31 - _463) & 31))) >> 31;
                                            _1638 = saturate((asfloat((_1622 & asint(_468))) + asfloat((_1626 & asint(_471)))) + asfloat(((_1626 & 1065353216) & _1622)));
                                            [branch]
                                            if (!(_1638 == 0.0f)) {
                                              _1641 = (uint)(_1603) >> 12;
                                              if (_1641 == 6) {
                                                do {
                                                  _3129 = _1638;
                                                  if (!(cbSharedPerViewData.nCinematicVolumeRemoveCSM == 0)) {
                                                    _3129 = (_1638 * select(((_1607 & 67108864) != 0), 1.0f, (1.0f - _1590)));
                                                  }
                                                  _3132 = asfloat(srvLightInfoProperties.Load4(_1609)).x;
                                                  _3133 = asfloat(srvLightInfoProperties.Load4(_1609)).y;
                                                  _3134 = asfloat(srvLightInfoProperties.Load4(_1609)).z;
                                                  _3135 = asfloat(srvLightInfoProperties.Load4(_1609)).w;
                                                  _3138 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).x;
                                                  _3139 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).y;
                                                  _3140 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).z;
                                                  _3141 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).w;
                                                  _3144 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).x;
                                                  _3145 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).y;
                                                  _3146 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).z;
                                                  _3149 = asint(srvLightInfoProperties.Load(((int)(_1609 + 68u))));
                                                  _3152 = asint(srvLightInfoProperties.Load(((int)(_1609 + 72u))));
                                                  _3155 = asint(srvLightInfoProperties.Load(((int)(_1609 + 76u))));
                                                  _3158 = asint(srvLightInfoProperties.Load(((int)(_1609 + 84u))));
                                                  _3161 = asint(srvLightInfoProperties.Load(((int)(_1609 + 88u))));
                                                  _3164 = asint(srvLightInfoProperties.Load(((int)(_1609 + 92u))));
                                                  _3167 = (float)((uint)((uint)(((uint)(_3149) >> 8) & 255)));
                                                  _3171 = ((float)((uint)((uint)(_3149 & 255)))) * 0.003921499941498041f;
                                                  _3173 = f16tof32(((uint)((uint)(_3152) >> 16)));
                                                  _3175 = (uint)(_3155) >> 16;
                                                  _3195 = srvDeferredShadingPass_DeferredShadows.Load(int3(_64, _65, 0));
                                                  [branch]
                                                  if (!(_3195.x == 0.0f)) {
                                                    do {
                                                      _3220 = cbSharedPerViewData.vAttenuatedSunColor.x;
                                                      _3221 = cbSharedPerViewData.vAttenuatedSunColor.y;
                                                      _3222 = cbSharedPerViewData.vAttenuatedSunColor.z;
                                                      [branch]
                                                      if (!(_3175 == 0)) {
                                                        Texture2D<float3> _HeapResource_21 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3175)))];
                                                        _3212 = _HeapResource_21.SampleLevel(samplerLinearWrapNode, float2((((mad(_3134, _236, mad(_3133, _235, (_3132 * _234))) + _3135) * f16tof32(((uint)((uint)(_3161) >> 16)))) + f16tof32(((uint)((uint)(_3164) >> 16)))), (((mad(_3140, _236, mad(_3139, _235, (_3138 * _234))) + _3141) * f16tof32(_3161)) + f16tof32(_3164))), 0.0f);
                                                        _3220 = (_3212.x * cbSharedPerViewData.vAttenuatedSunColor.x);
                                                        _3221 = (_3212.y * cbSharedPerViewData.vAttenuatedSunColor.y);
                                                        _3222 = (_3212.z * cbSharedPerViewData.vAttenuatedSunColor.z);
                                                      }
                                                      _3225 = min(_3195.x, _3195.y) * _3129;
                                                      [branch]
                                                      if (_3225 > 0.0f) {
                                                        _3228 = dot(float3(_3144, _3145, _3146), float3(_3144, _3145, _3146));
                                                        _3229 = rsqrt(_3228);
                                                        _3230 = _3229 * _3144;
                                                        _3231 = _3229 * _3145;
                                                        _3232 = _3229 * _3146;
                                                        _3233 = dot(float3(_192, _193, _194), float3(_3230, _3231, _3232));
                                                        do {
                                                          _3251 = _3233;
                                                          if (_3173 > 0.0f) {
                                                            _3241 = sqrt(saturate((_3173 * _3173) * (1.0f / (_3228 + 1.0f))));
                                                            if (_3233 < _3241) {
                                                              _3246 = max(_3233, (-0.0f - _3241)) + _3241;
                                                              _3251 = ((_3246 * _3246) / (_3241 * 4.0f));
                                                            } else {
                                                              _3251 = _3233;
                                                            }
                                                          }
                                                          _3252 = _219 * _219;
                                                          _3256 = saturate((_3173 * (1.0f - _3252)) * _3229);
                                                          _3258 = saturate(_3229 * f16tof32(_3152));
                                                          _3259 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                          _3260 = dot(float3(_452, _453, _451), float3(_3230, _3231, _3232));
                                                          _3263 = rsqrt((_3260 * 2.0f) + 2.0f);
                                                          _3270 = (_3256 > 0.0f);
                                                          do {
                                                            _3361 = saturate((_3263 * _3260) + _3263);
                                                            _3362 = saturate(_3263 * (_3259 + _3233));
                                                            if (_3270) {
                                                              _3274 = sqrt(1.0f - (_3256 * _3256));
                                                              _3276 = (_3233 * 2.0f) * _3259;
                                                              _3277 = _3276 - _3260;
                                                              if (!(!(_3277 >= _3274))) {
                                                                _3361 = abs(_3259);
                                                                _3362 = 1.0f;
                                                              } else {
                                                                _3285 = rsqrt(1.0f - (_3277 * _3277)) * _3256;
                                                                _3288 = _3285 * (_3259 - (_3277 * _3233));
                                                                _3289 = _3259 * _3259;
                                                                _3294 = _3285 * (((_3289 * 2.0f) + -1.0f) - (_3277 * _3260));
                                                                _3303 = sqrt(saturate((((1.0f - (_3233 * _3233)) - _3289) - (_3260 * _3260)) + (_3276 * _3260)));
                                                                _3304 = _3303 * _3285;
                                                                _3307 = ((_3259 * 2.0f) * _3285) * _3303;
                                                                _3309 = (_3274 * _3233) + _3259;
                                                                _3310 = _3309 + _3288;
                                                                _3311 = _3274 * _3260;
                                                                _3313 = (_3311 + 1.0f) + _3294;
                                                                _3314 = _3304 * _3313;
                                                                _3315 = _3310 * _3313;
                                                                _3316 = _3307 * _3310;
                                                                _3321 = (((_3310 * 0.25f) * _3307) - (_3314 * 0.5f)) * _3315;
                                                                _3335 = (((_3316 - (_3314 * 2.0f)) * _3316) + (_3314 * _3314)) + ((((-0.5f - ((_3313 + _3311) * 0.5f)) * _3315) + ((_3313 * _3313) * _3309)) * _3310);
                                                                _3340 = (_3321 * 2.0f) / ((_3335 * _3335) + (_3321 * _3321));
                                                                _3341 = _3335 * _3340;
                                                                _3343 = 1.0f - (_3321 * _3340);
                                                                _3349 = ((_3341 * _3307) + _3311) + (_3343 * _3294);
                                                                _3352 = rsqrt((_3349 * 2.0f) + 2.0f);
                                                                _3361 = saturate((_3349 * _3352) + _3352);
                                                                _3362 = saturate(((_3309 + (_3341 * _3304)) + (_3343 * _3288)) * _3352);
                                                              }
                                                            }
                                                            _3363 = saturate(_3251);
                                                            _3364 = _3252 * _3252;
                                                            do {
                                                              _3374 = _3364;
                                                              if (_3258 > 0.0f) {
                                                                _3374 = saturate(((_3258 * _3258) / ((_3361 * 3.5999999046325684f) + 0.4000000059604645f)) + _3364);
                                                              }
                                                              _3375 = sqrt(_3374);
                                                              do {
                                                                _3386 = 1.0f;
                                                                if (_3270) {
                                                                  _3386 = (_3374 / ((((_3256 * 0.25f) * ((_3375 * 3.0f) + _3256)) / (_3361 + 0.0010000000474974513f)) + _3374));
                                                                }
                                                                _3390 = (((_3374 * _3362) - _3362) * _3362) + 1.0f;
                                                                _3400 = exp2(log2(1.0f - saturate(_3361)) * 5.0f);
                                                                _3409 = saturate(abs(_3259) + 9.999999747378752e-06f);
                                                                _3410 = 1.0f - _3375;
                                                                _3422 = saturate((_3233 + _3171) / (_3171 + 1.0f));
                                                                _3425 = ((_3386 * _3363) * (_3374 / (_3390 * _3390))) * (0.5f / ((((_3410 * _3409) + _3375) * _3363) + (((_3410 * _3363) + _3375) * _3409)));
                                                                do {
                                                                  _3528 = _3220;
                                                                  _3529 = _3221;
                                                                  _3530 = _3222;
                                                                  [branch]
                                                                  if (!((_3158 & 1) == 0)) {
                                                                    _3438 = max(max(_3220, _3221), _3222);
                                                                    do {
                                                                      _3448 = _3220;
                                                                      _3449 = _3221;
                                                                      _3450 = _3222;
                                                                      if (_3438 > 0.0f) {
                                                                        _3448 = saturate(_3220 / _3438);
                                                                        _3449 = saturate(_3221 / _3438);
                                                                        _3450 = saturate(_3222 / _3438);
                                                                      }
                                                                      _3451 = (_3449 < _3450);
                                                                      _3452 = select(_3451, _3450, _3449);
                                                                      _3453 = select(_3451, _3449, _3450);
                                                                      _3454 = select(_3451, -1.0f, 0.0f);
                                                                      _3455 = (_3448 < _3452);
                                                                      _3457 = select(_3455, _3452, _3448);
                                                                      _3458 = select(_3455, _3448, _3452);
                                                                      _3462 = _3457 - select((_3458 < _3453), _3458, _3453);
                                                                      _3468 = abs(select(_3455, (-0.3333333432674408f - _3454), _3454) + ((_3458 - _3453) / ((_3462 * 6.0f) + 9.999999682655225e-21f)));
                                                                      do {
                                                                        _3481 = _3468;
                                                                        if (_3468 < 0.6666666865348816f) {
                                                                          _3481 = ((saturate(((float)((uint)((uint)(((uint)(_3158) >> 9) & 255)))) * 0.003921499941498041f) * (select((_3468 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _3468)) + _3468);
                                                                        }
                                                                        _3482 = saturate((_3462 / (_3457 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3158) >> 1) & 255)))) * 0.003921499941498041f));
                                                                        _3483 = saturate(_3457);
                                                                        do {
                                                                          _3510 = _3483;
                                                                          _3511 = _3483;
                                                                          _3512 = _3483;
                                                                          if (!(_3482 <= 0.0f)) {
                                                                            _3486 = saturate(_3481);
                                                                            _3490 = select(((_3486 * 360.0f) >= 360.0f), 0.0f, (_3486 * 6.0f));
                                                                            _3491 = int(_3490);
                                                                            _3493 = _3490 - float((int)(_3491));
                                                                            _3495 = _3483 * (1.0f - _3482);
                                                                            _3498 = (1.0f - (_3493 * _3482)) * _3483;
                                                                            _3502 = (1.0f - ((1.0f - _3493) * _3482)) * _3483;
                                                                            switch (_3491) {
                                                                              case 0: {
                                                                                _3510 = _3483;
                                                                                _3511 = _3502;
                                                                                _3512 = _3495;
                                                                                break;
                                                                              }
                                                                              case 1: {
                                                                                _3510 = _3498;
                                                                                _3511 = _3483;
                                                                                _3512 = _3495;
                                                                                break;
                                                                              }
                                                                              case 2: {
                                                                                _3510 = _3495;
                                                                                _3511 = _3483;
                                                                                _3512 = _3502;
                                                                                break;
                                                                              }
                                                                              case 3: {
                                                                                _3510 = _3495;
                                                                                _3511 = _3498;
                                                                                _3512 = _3483;
                                                                                break;
                                                                              }
                                                                              case 4: {
                                                                                _3510 = _3502;
                                                                                _3511 = _3495;
                                                                                _3512 = _3483;
                                                                                break;
                                                                              }
                                                                              case 5: {
                                                                                _3510 = _3483;
                                                                                _3511 = _3495;
                                                                                _3512 = _3498;
                                                                                break;
                                                                              }
                                                                              default: {
                                                                                _3510 = 0.0f;
                                                                                _3511 = 0.0f;
                                                                                _3512 = 0.0f;
                                                                                break;
                                                                              }
                                                                            }
                                                                          }
                                                                          _3513 = _3510 * _3438;
                                                                          _3514 = _3511 * _3438;
                                                                          _3515 = _3512 * _3438;
                                                                          _3517 = saturate(_3225 * 1.0101009607315063f);
                                                                          _3528 = ((_3517 * (_3220 - _3513)) + _3513);
                                                                          _3529 = ((_3517 * (_3221 - _3514)) + _3514);
                                                                          _3530 = (lerp(_3515, _3222, _3517));
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  }
                                                                  _3531 = _3528 * _3225;
                                                                  _3532 = _3529 * _3225;
                                                                  _3533 = _3530 * _3225;
                                                                  do {
                                                                    _3543 = _3531;
                                                                    _3544 = _3532;
                                                                    _3545 = _3533;
                                                                    if (!((cbSharedPerViewData.nLightingFeatureFlags & 1024) == 0)) {
                                                                      _3543 = (_3531 * _1281);
                                                                      _3544 = (_3532 * _1281);
                                                                      _3545 = (_3533 * _1281);
                                                                    }
                                                                    _3549 = (_3543 * _3422) + _1595;
                                                                    _3550 = (_3544 * _3422) + _1596;
                                                                    _3551 = (_3545 * _3422) + _1597;
                                                                    if ((_3167 * 0.003921499941498041f) > 0.0f) {
                                                                      _3554 = (_1354 * 0.003921499941498041f) * _3167;
                                                                      _8462 = _3549;
                                                                      _8463 = _3550;
                                                                      _8464 = _3551;
                                                                      _8465 = (((((_3554 * _1144) * ((_3400 * (1.0f - _211)) + _211)) * _3425) * _3543) + _1598);
                                                                      _8466 = (((((_3554 * _1145) * ((_3400 * (1.0f - _212)) + _212)) * _3425) * _3544) + _1599);
                                                                      _8467 = (((((_3554 * _1146) * ((_3400 * (1.0f - _213)) + _213)) * _3425) * _3545) + _1600);
                                                                    } else {
                                                                      _8462 = _3549;
                                                                      _8463 = _3550;
                                                                      _8464 = _3551;
                                                                      _8465 = _1598;
                                                                      _8466 = _1599;
                                                                      _8467 = _1600;
                                                                    }
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } else {
                                                        _8462 = _1595;
                                                        _8463 = _1596;
                                                        _8464 = _1597;
                                                        _8465 = _1598;
                                                        _8466 = _1599;
                                                        _8467 = _1600;
                                                      }
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    _8462 = _1595;
                                                    _8463 = _1596;
                                                    _8464 = _1597;
                                                    _8465 = _1598;
                                                    _8466 = _1599;
                                                    _8467 = _1600;
                                                  }
                                                } while (false);
                                                if (_loop_break_3) break;
                                              } else {
                                                _1658 = _1638 * select(((_1607 & 67108864) != 0), 1.0f, (1.0f - _1590));
                                                [branch]
                                                if (_1641 == 4) {
                                                  _1663 = asfloat(srvLightInfoProperties.Load4(_1609)).x;
                                                  _1664 = asfloat(srvLightInfoProperties.Load4(_1609)).y;
                                                  _1665 = asfloat(srvLightInfoProperties.Load4(_1609)).z;
                                                  _1666 = asfloat(srvLightInfoProperties.Load4(_1609)).w;
                                                  _1669 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).x;
                                                  _1670 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).y;
                                                  _1671 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).z;
                                                  _1672 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).w;
                                                  _1675 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).x;
                                                  _1676 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).y;
                                                  _1677 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).z;
                                                  _1678 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).w;
                                                  _1681 = asint(srvLightInfoProperties.Load(((int)(_1609 + 48u))));
                                                  _1684 = asint(srvLightInfoProperties.Load(((int)(_1609 + 52u))));
                                                  _1687 = asint(srvLightInfoProperties.Load(((int)(_1609 + 64u))));
                                                  _1690 = asint(srvLightInfoProperties.Load(((int)(_1609 + 68u))));
                                                  _1693 = asint(srvLightInfoProperties.Load(((int)(_1609 + 72u))));
                                                  _1695 = f16tof32(((uint)((uint)(_1681) >> 16)));
                                                  _1696 = f16tof32(_1681);
                                                  _1698 = f16tof32(((uint)((uint)(_1684) >> 16)));
                                                  _1702 = ((float)((uint)((uint)(((uint)(_1684) >> 8) & 255)))) * 0.003921499941498041f;
                                                  _1715 = mad(_1665, _236, mad(_1664, _235, (_1663 * _234))) + _1666;
                                                  _1719 = mad(_1671, _236, mad(_1670, _235, (_1669 * _234))) + _1672;
                                                  _1723 = mad(_1677, _236, mad(_1676, _235, (_1675 * _234))) + _1678;
                                                  _1748 = saturate(1.0f - ((_1715 + 1.0f) * f16tof32(_1687))) + saturate(1.0f - ((1.0f - _1715) * f16tof32(((uint)((uint)(_1687) >> 16)))));
                                                  _1749 = saturate(1.0f - ((_1719 + 1.0f) * f16tof32(_1690))) + saturate(1.0f - ((1.0f - _1719) * f16tof32(((uint)((uint)(_1690) >> 16)))));
                                                  _1750 = saturate(1.0f - ((_1723 + 1.0f) * f16tof32(_1693))) + saturate(1.0f - ((1.0f - _1723) * f16tof32(((uint)((uint)(_1693) >> 16)))));
                                                  _1753 = saturate(1.0f - dot(float3(_1748, _1749, _1750), float3(_1748, _1749, _1750)));
                                                  _1754 = _1753 * _1753;
                                                  _1761 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_1754 * _1281), _1754) * _1658;
                                                  _8462 = ((_1761 * _1695) + _1595);
                                                  _8463 = ((_1761 * _1696) + _1596);
                                                  _8464 = ((_1761 * _1698) + _1597);
                                                  _8465 = (((_1702 * _1695) * _1761) + _1598);
                                                  _8466 = (((_1702 * _1696) * _1761) + _1599);
                                                  _8467 = (((_1698 * _1702) * _1761) + _1600);
                                                } else {
                                                  if (_1641 == 5) {
                                                    _1782 = asfloat(srvLightInfoProperties.Load4(_1609)).x;
                                                    _1783 = asfloat(srvLightInfoProperties.Load4(_1609)).y;
                                                    _1784 = asfloat(srvLightInfoProperties.Load4(_1609)).z;
                                                    _1785 = asfloat(srvLightInfoProperties.Load4(_1609)).w;
                                                    _1788 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).x;
                                                    _1789 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).y;
                                                    _1790 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).z;
                                                    _1791 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).w;
                                                    _1794 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).x;
                                                    _1795 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).y;
                                                    _1796 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).z;
                                                    _1797 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).w;
                                                    _1800 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).x;
                                                    _1801 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).y;
                                                    _1802 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).z;
                                                    _1805 = asfloat(srvLightInfoProperties.Load(((int)(_1609 + 60u))));
                                                    _1808 = asint(srvLightInfoProperties.Load(((int)(_1609 + 64u))));
                                                    _1811 = asint(srvLightInfoProperties.Load(((int)(_1609 + 68u))));
                                                    _1814 = asint(srvLightInfoProperties.Load(((int)(_1609 + 80u))));
                                                    _1817 = asint(srvLightInfoProperties.Load(((int)(_1609 + 84u))));
                                                    _1820 = asint(srvLightInfoProperties.Load(((int)(_1609 + 88u))));
                                                    _1823 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 92u)))).x;
                                                    _1824 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 92u)))).y;
                                                    _1825 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 92u)))).z;
                                                    _1826 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 92u)))).w;
                                                    _1829 = asint(srvLightInfoProperties.Load(((int)(_1609 + 108u))));
                                                    _1832 = asint(srvLightInfoProperties.Load(((int)(_1609 + 112u))));
                                                    _1835 = asint(srvLightInfoProperties.Load(((int)(_1609 + 120u))));
                                                    _1838 = asint(srvLightInfoProperties.Load(((int)(_1609 + 124u))));
                                                    _1841 = asint(srvLightInfoProperties.Load(((int)(_1609 + 128u))));
                                                    _1844 = asint(srvLightInfoProperties.Load(((int)(_1609 + 132u))));
                                                    _1847 = asint(srvLightInfoProperties.Load(((int)(_1609 + 136u))));
                                                    _1850 = asint(srvLightInfoProperties.Load(((int)(_1609 + 140u))));
                                                    _1852 = f16tof32(((uint)((uint)(_1808) >> 16)));
                                                    _1853 = f16tof32(_1808);
                                                    _1855 = f16tof32(((uint)((uint)(_1811) >> 16)));
                                                    _1859 = ((float)((uint)((uint)(((uint)(_1811) >> 8) & 255)))) * 0.003921499941498041f;
                                                    _1862 = ((float)((uint)((uint)(_1811 & 255)))) * 0.003921499941498041f;
                                                    _1864 = f16tof32(((uint)((uint)(_1814) >> 16)));
                                                    _1867 = _1817 & 65535;
                                                    _1877 = f16tof32(((uint)((uint)(_1832) >> 16)));
                                                    _1878 = f16tof32(_1832);
                                                    _1880 = f16tof32(((uint)((uint)(_1835) >> 16)));
                                                    _1881 = 1.0f / _1880;
                                                    _1882 = _1880 + -1.0f;
                                                    _1883 = f16tof32(_1835);
                                                    _1902 = saturate(1.0f - dot(float3(_192, _193, _194), float3(_1800, _1801, _1802))) * f16tof32(_1829);
                                                    _1906 = (_1902 * _192) + _234;
                                                    _1907 = (_1902 * _193) + _235;
                                                    _1908 = (_1902 * _194) - _233;
                                                    _1912 = mad(_1784, _1908, mad(_1783, _1907, (_1906 * _1782))) + _1785;
                                                    _1916 = mad(_1790, _1908, mad(_1789, _1907, (_1906 * _1788))) + _1791;
                                                    _1920 = mad(_1796, _1908, mad(_1795, _1907, (_1906 * _1794))) + _1797;
                                                    _1921 = saturate(_1920);
                                                    _1944 = saturate(1.0f - (_1912 * f16tof32(_1844))) + saturate(1.0f - ((1.0f - _1912) * f16tof32(((uint)((uint)(_1844) >> 16)))));
                                                    _1945 = saturate(1.0f - (_1916 * f16tof32(_1847))) + saturate(1.0f - ((1.0f - _1916) * f16tof32(((uint)((uint)(_1847) >> 16)))));
                                                    _1946 = saturate(1.0f - (_1920 * f16tof32(_1850))) + saturate(1.0f - ((1.0f - _1920) * f16tof32(((uint)((uint)(_1850) >> 16)))));
                                                    _1949 = saturate(1.0f - dot(float3(_1944, _1945, _1946), float3(_1944, _1945, _1946)));
                                                    _1950 = _1949 * _1949;
                                                    do {
                                                      _2789 = 1.0f;
                                                      if (!(((_1607 & 3584) == 0) || (!(_1950 > 0.0f)))) {
                                                        _1957 = 1.0f - _1921;
                                                        _1958 = saturate(_1912);
                                                        _1959 = saturate(_1916);
                                                        do {
                                                          _2222 = 1.0f;
                                                          _2223 = 0.0f;
                                                          _2224 = _1957;
                                                          [branch]
                                                          if (!((_1607 & 1024) == 0)) {
                                                            _1964 = ((_1958 * _1882) + 0.5f) * _1881;
                                                            _1966 = ((_1959 * _1882) + 0.5f) * _1881;
                                                            _1967 = _1957 + f16tof32(((uint)((uint)(_1829) >> 16)));
                                                            Texture2D<float4> _HeapResource_16 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1817) >> 16))];
                                                            _1970 = saturate(_1967);
                                                            _1974 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                            #if FIRSTLIGHT_ISFAST_ENABLED
                                                            if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                              _1983 = RenoDX_ISFASTShadowAngle(
                                                                  uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 0u);
                                                            } else {
                                                              _1983 = frac(frac(dot(float2(((_1974 * 32.665000915527344f) + _126), ((_1974 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            }
                                                            #else
                                                            _1983 = frac(frac(dot(float2(((_1974 * 32.665000915527344f) + _126), ((_1974 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                            #endif
                                                            _1984 = sin(_1983);
                                                            _1985 = cos(_1983);
                                                            _1986 = cbSharedPerViewData.nFrameCounter & 3;
                                                            _1991 = sqrt((float((int)(_1986)) * 0.25f) + 0.125f) * _1877;
                                                            _2000 = (_global_7[min((uint)(((int)(0u + (_1986 * 2)))), 127u)]) * _1991;
                                                            _2001 = (_global_7[min((uint)(((int)(1u + (_1986 * 2)))), 127u)]) * _1991;
                                                            _2003 = -0.0f - _1984;
                                                            _2008 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2000, _2001), float2(_1985, _1984)) + _1964), (dot(float2(_2000, _2001), float2(_2003, _1985)) + _1966)));
                                                            _2013 = _2008.x - _1970;
                                                            _2015 = select((_2013 < 0.0f), 0.0f, 1.0f);
                                                            _2017 = _2008.y - _1970;
                                                            _2019 = select((_2017 < 0.0f), 0.0f, 1.0f);
                                                            _2023 = _2008.z - _1970;
                                                            _2025 = select((_2023 < 0.0f), 0.0f, 1.0f);
                                                            _2029 = _2008.w - _1970;
                                                            _2031 = select((_2029 < 0.0f), 0.0f, 1.0f);
                                                            _2038 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                            _2043 = sqrt((float((int)(_2038)) * 0.25f) + 0.125f) * _1877;
                                                            _2052 = (_global_7[min((uint)(((int)(0u + (_2038 * 2)))), 127u)]) * _2043;
                                                            _2053 = (_global_7[min((uint)(((int)(1u + (_2038 * 2)))), 127u)]) * _2043;
                                                            _2059 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2052, _2053), float2(_1985, _1984)) + _1964), (dot(float2(_2052, _2053), float2(_2003, _1985)) + _1966)));
                                                            _2064 = _2059.x - _1970;
                                                            _2066 = select((_2064 < 0.0f), 0.0f, 1.0f);
                                                            _2070 = _2059.y - _1970;
                                                            _2072 = select((_2070 < 0.0f), 0.0f, 1.0f);
                                                            _2076 = _2059.z - _1970;
                                                            _2078 = select((_2076 < 0.0f), 0.0f, 1.0f);
                                                            _2082 = _2059.w - _1970;
                                                            _2084 = select((_2082 < 0.0f), 0.0f, 1.0f);
                                                            _2091 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                            _2096 = sqrt((float((int)(_2091)) * 0.25f) + 0.125f) * _1877;
                                                            _2105 = (_global_7[min((uint)(((int)(0u + (_2091 * 2)))), 127u)]) * _2096;
                                                            _2106 = (_global_7[min((uint)(((int)(1u + (_2091 * 2)))), 127u)]) * _2096;
                                                            _2112 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2105, _2106), float2(_1985, _1984)) + _1964), (dot(float2(_2105, _2106), float2(_2003, _1985)) + _1966)));
                                                            _2117 = _2112.x - _1970;
                                                            _2119 = select((_2117 < 0.0f), 0.0f, 1.0f);
                                                            _2123 = _2112.y - _1970;
                                                            _2125 = select((_2123 < 0.0f), 0.0f, 1.0f);
                                                            _2129 = _2112.z - _1970;
                                                            _2131 = select((_2129 < 0.0f), 0.0f, 1.0f);
                                                            _2135 = _2112.w - _1970;
                                                            _2137 = select((_2135 < 0.0f), 0.0f, 1.0f);
                                                            _2144 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                            _2149 = sqrt((float((int)(_2144)) * 0.25f) + 0.125f) * _1877;
                                                            _2158 = (_global_7[min((uint)(((int)(0u + (_2144 * 2)))), 127u)]) * _2149;
                                                            _2159 = (_global_7[min((uint)(((int)(1u + (_2144 * 2)))), 127u)]) * _2149;
                                                            _2165 = _HeapResource_16.GatherRed(samplerPointClampNode, float2((dot(float2(_2158, _2159), float2(_1985, _1984)) + _1964), (dot(float2(_2158, _2159), float2(_2003, _1985)) + _1966)));
                                                            _2170 = _2165.x - _1970;
                                                            _2172 = select((_2170 < 0.0f), 0.0f, 1.0f);
                                                            _2176 = _2165.y - _1970;
                                                            _2178 = select((_2176 < 0.0f), 0.0f, 1.0f);
                                                            _2182 = _2165.z - _1970;
                                                            _2184 = select((_2182 < 0.0f), 0.0f, 1.0f);
                                                            _2188 = _2165.w - _1970;
                                                            _2190 = select((_2188 < 0.0f), 0.0f, 1.0f);
                                                            _2191 = ((((((((((((((_2015 + _2019) + _2025) + _2031) + _2066) + _2072) + _2078) + _2084) + _2119) + _2125) + _2131) + _2137) + _2172) + _2178) + _2184) + _2190;
                                                            _2202 = (saturate(_2191 * 0.0625f) * 2.0f) + -1.0f;
                                                            _2208 = float((int)(((int)(uint)((int)(_2202 > 0.0f))) - ((int)(uint)((int)(_2202 < 0.0f)))));
                                                            _2210 = 1.0f - (_2208 * _2202);
                                                            _2212 = (_2210 * _2210) * _2210;
                                                            _2219 = 0.5f - ((_2208 * 0.5f) * ((1.0f - _2212) - ((_2210 - _2212) * saturate(((1.0f / _1970) * (1.0f / _2191)) * ((((((((((((((((_2015 * _2013) + (_2019 * _2017)) + (_2025 * _2023)) + (_2031 * _2029)) + (_2066 * _2064)) + (_2072 * _2070)) + (_2078 * _2076)) + (_2084 * _2082)) + (_2119 * _2117)) + (_2125 * _2123)) + (_2131 * _2129)) + (_2137 * _2135)) + (_2172 * _2170)) + (_2178 * _2176)) + (_2184 * _2182)) + (_2190 * _2188))))));
                                                            [branch]
                                                            if (!(_1883 < 1.0f)) {
                                                              _2692 = _2219;
                                                              do {
                                                                _2789 = _2692;
                                                                [branch]
                                                                if (!((_1607 & 2048) == 0)) {
                                                                  Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1820) >> 16))];
                                                                  _2698 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1912, _1916), 0.0f);
                                                                  if (_2698.x > 0.0f) {
                                                                    Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1820 & 65535))];
                                                                    _2705 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1912, _1916), 0.0f);
                                                                    _2719 = mad(saturate(((log2(_1921 * _1805) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                    _2720 = max(9.999999747378752e-06f, _2698.x);
                                                                    _2721 = _2705.x / _2720;
                                                                    _2722 = _2705.y / _2720;
                                                                    _2724 = _2705.w / _2720;
                                                                    _2729 = ((0.375f - _2722) * 4.999999873689376e-06f) + _2722;
                                                                    _2732 = -0.0f - _2721;
                                                                    _2733 = mad(_2732, _2729, (_2705.z / _2720));
                                                                    _2735 = 1.0f / mad(_2732, _2721, _2729);
                                                                    _2736 = _2735 * _2733;
                                                                    _2741 = _2719 - _2721;
                                                                    _2746 = (((_2719 * _2719) - _2729) - (_2736 * _2741)) / mad((-0.0f - _2733), _2736, mad((-0.0f - _2729), _2729, (((0.375f - _2724) * 4.999999873689376e-06f) + _2724)));
                                                                    _2748 = (_2735 * _2741) - (_2746 * _2736);
                                                                    _2751 = 1.0f / _2746;
                                                                    _2752 = _2748 * _2751;
                                                                    _2757 = sqrt(((_2752 * _2752) * 0.25f) - ((1.0f - dot(float2(_2748, _2746), float2(_2721, _2729))) * _2751));
                                                                    _2759 = (_2752 * -0.5f) - _2757;
                                                                    _2761 = _2757 - (_2752 * 0.5f);
                                                                    _2763 = select((_2759 < _2719), 1.0f, 0.0f);
                                                                    _2768 = (_2763 + -0.05000000074505806f) / (_2759 - _2719);
                                                                    _2774 = (((select((_2761 < _2719), 1.0f, 0.0f) - _2763) / (_2761 - _2759)) - _2768) / (_2761 - _2719);
                                                                    _2776 = _2768 - (_2774 * _2759);
                                                                    _2789 = (exp2((_2698.x * -1.4426950216293335f) * saturate((dot(float2(_2721, _2729), float2((_2776 - (_2774 * _2719)), _2774)) + 0.05000000074505806f) - (_2776 * _2719))) * _2692);
                                                                  } else {
                                                                    _2789 = _2692;
                                                                  }
                                                                }
                                                                break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                              // Native completed depth-gather shadow bypasses the fallback path.
                                                              break;
                                                            } else {
                                                              _2222 = _2219;
                                                              _2223 = _1883;
                                                              _2224 = _1967;
                                                            }
                                                          }
                                                          _2227 = (_1958 * _1823) + _1825;
                                                          _2228 = (_1959 * _1824) + _1826;
                                                          do {
                                                            _2687 = 1.0f;
                                                            if (!((_1607 & 512) == 0)) {
                                                              Texture2D<float4> _HeapResource_17 = ResourceDescriptorHeap[5];
                                                              _2237 = saturate(_2224);
                                                              _2241 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                              #if FIRSTLIGHT_ISFAST_ENABLED
                                                              if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                _2250 = RenoDX_ISFASTShadowAngle(
                                                                    uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 1u);
                                                              } else {
                                                                _2250 = frac(frac(dot(float2(((_2241 * 32.665000915527344f) + _126), ((_2241 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              }
                                                              #else
                                                              _2250 = frac(frac(dot(float2(((_2241 * 32.665000915527344f) + _126), ((_2241 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                              #endif
                                                              _2251 = sin(_2250);
                                                              _2252 = cos(_2250);
                                                              _2257 = select(((((float4)(_HeapResource_17.SampleLevel(samplerPointBorderWhiteNode, float2(_2227, _2228), 0.0f))).x) > _2237), 1.0f, 0.0f);
                                                              _2258 = cbSharedPerViewData.nFrameCounter & 3;
                                                              _2263 = sqrt((float((int)(_2258)) * 0.25f) + 0.125f) * _1878;
                                                              _2272 = (_global_7[min((uint)(((int)(0u + (_2258 * 2)))), 127u)]) * _2263;
                                                              _2273 = (_global_7[min((uint)(((int)(1u + (_2258 * 2)))), 127u)]) * _2263;
                                                              _2275 = -0.0f - _2251;
                                                              _2277 = dot(float2(_2272, _2273), float2(_2252, _2251)) + _2227;
                                                              _2278 = dot(float2(_2272, _2273), float2(_2275, _2252)) + _2228;
                                                              _2280 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2277, _2278));
                                                              _2284 = _2277 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                              _2285 = _2278 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                              _2288 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _1825);
                                                              _2289 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _1826);
                                                              _2294 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_1823 + _1825)) + 0.5f);
                                                              _2295 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_1824 + _1826)) + 0.5f);
                                                              _2298 = floor(_2284 + -0.5f);
                                                              _2299 = floor(_2285 + 0.5f);
                                                              _2301 = floor(_2284 + 0.5f);
                                                              _2303 = floor(_2285 + -0.5f);
                                                              _2304 = (_2298 < _2288);
                                                              _2305 = (_2299 < _2289);
                                                              do {
                                                                if (!(_2304 || _2305)) {
                                                                  if ((_2298 >= _2294) || (_2299 >= _2295)) {
                                                                    _2314 = _2257;
                                                                  } else {
                                                                    _2314 = _2280.x;
                                                                  }
                                                                } else {
                                                                  _2314 = _2257;
                                                                }
                                                                _2315 = (_2301 < _2288);
                                                                do {
                                                                  if (!(_2315 || _2305)) {
                                                                    if ((_2301 >= _2294) || (_2299 >= _2295)) {
                                                                      _2323 = _2257;
                                                                    } else {
                                                                      _2323 = _2280.y;
                                                                    }
                                                                  } else {
                                                                    _2323 = _2257;
                                                                  }
                                                                  _2324 = (_2303 < _2289);
                                                                  do {
                                                                    if (!(_2315 || _2324)) {
                                                                      if ((_2301 >= _2294) || (_2303 >= _2295)) {
                                                                        _2332 = _2257;
                                                                      } else {
                                                                        _2332 = _2280.z;
                                                                      }
                                                                    } else {
                                                                      _2332 = _2257;
                                                                    }
                                                                    do {
                                                                      if (!(_2304 || _2324)) {
                                                                        if ((_2298 >= _2294) || (_2303 >= _2295)) {
                                                                          _2340 = _2257;
                                                                        } else {
                                                                          _2340 = _2280.w;
                                                                        }
                                                                      } else {
                                                                        _2340 = _2257;
                                                                      }
                                                                      _2341 = _2314 - _2237;
                                                                      _2343 = select((_2341 < 0.0f), 0.0f, 1.0f);
                                                                      _2345 = _2323 - _2237;
                                                                      _2347 = select((_2345 < 0.0f), 0.0f, 1.0f);
                                                                      _2351 = _2332 - _2237;
                                                                      _2353 = select((_2351 < 0.0f), 0.0f, 1.0f);
                                                                      _2357 = _2340 - _2237;
                                                                      _2359 = select((_2357 < 0.0f), 0.0f, 1.0f);
                                                                      _2366 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _2371 = sqrt((float((int)(_2366)) * 0.25f) + 0.125f) * _1878;
                                                                      _2380 = (_global_7[min((uint)(((int)(0u + (_2366 * 2)))), 127u)]) * _2371;
                                                                      _2381 = (_global_7[min((uint)(((int)(1u + (_2366 * 2)))), 127u)]) * _2371;
                                                                      _2384 = dot(float2(_2380, _2381), float2(_2252, _2251)) + _2227;
                                                                      _2385 = dot(float2(_2380, _2381), float2(_2275, _2252)) + _2228;
                                                                      _2387 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2384, _2385));
                                                                      _2391 = _2384 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _2392 = _2385 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _2395 = floor(_2391 + -0.5f);
                                                                      _2396 = floor(_2392 + 0.5f);
                                                                      _2398 = floor(_2391 + 0.5f);
                                                                      _2400 = floor(_2392 + -0.5f);
                                                                      _2401 = (_2395 < _2288);
                                                                      _2402 = (_2396 < _2289);
                                                                      do {
                                                                        if (!(_2401 || _2402)) {
                                                                          if ((_2395 >= _2294) || (_2396 >= _2295)) {
                                                                            _2411 = _2257;
                                                                          } else {
                                                                            _2411 = _2387.x;
                                                                          }
                                                                        } else {
                                                                          _2411 = _2257;
                                                                        }
                                                                        _2412 = (_2398 < _2288);
                                                                        do {
                                                                          if (!(_2412 || _2402)) {
                                                                            if ((_2398 >= _2294) || (_2396 >= _2295)) {
                                                                              _2420 = _2257;
                                                                            } else {
                                                                              _2420 = _2387.y;
                                                                            }
                                                                          } else {
                                                                            _2420 = _2257;
                                                                          }
                                                                          _2421 = (_2400 < _2289);
                                                                          do {
                                                                            if (!(_2412 || _2421)) {
                                                                              if ((_2398 >= _2294) || (_2400 >= _2295)) {
                                                                                _2429 = _2257;
                                                                              } else {
                                                                                _2429 = _2387.z;
                                                                              }
                                                                            } else {
                                                                              _2429 = _2257;
                                                                            }
                                                                            do {
                                                                              if (!(_2401 || _2421)) {
                                                                                if ((_2395 >= _2294) || (_2400 >= _2295)) {
                                                                                  _2437 = _2257;
                                                                                } else {
                                                                                  _2437 = _2387.w;
                                                                                }
                                                                              } else {
                                                                                _2437 = _2257;
                                                                              }
                                                                              _2438 = _2411 - _2237;
                                                                              _2440 = select((_2438 < 0.0f), 0.0f, 1.0f);
                                                                              _2444 = _2420 - _2237;
                                                                              _2446 = select((_2444 < 0.0f), 0.0f, 1.0f);
                                                                              _2450 = _2429 - _2237;
                                                                              _2452 = select((_2450 < 0.0f), 0.0f, 1.0f);
                                                                              _2456 = _2437 - _2237;
                                                                              _2458 = select((_2456 < 0.0f), 0.0f, 1.0f);
                                                                              _2465 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                              _2470 = sqrt((float((int)(_2465)) * 0.25f) + 0.125f) * _1878;
                                                                              _2479 = (_global_7[min((uint)(((int)(0u + (_2465 * 2)))), 127u)]) * _2470;
                                                                              _2480 = (_global_7[min((uint)(((int)(1u + (_2465 * 2)))), 127u)]) * _2470;
                                                                              _2483 = dot(float2(_2479, _2480), float2(_2252, _2251)) + _2227;
                                                                              _2484 = dot(float2(_2479, _2480), float2(_2275, _2252)) + _2228;
                                                                              _2486 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2483, _2484));
                                                                              _2490 = _2483 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _2491 = _2484 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _2494 = floor(_2490 + -0.5f);
                                                                              _2495 = floor(_2491 + 0.5f);
                                                                              _2497 = floor(_2490 + 0.5f);
                                                                              _2499 = floor(_2491 + -0.5f);
                                                                              _2500 = (_2494 < _2288);
                                                                              _2501 = (_2495 < _2289);
                                                                              do {
                                                                                if (!(_2500 || _2501)) {
                                                                                  if ((_2494 >= _2294) || (_2495 >= _2295)) {
                                                                                    _2510 = _2257;
                                                                                  } else {
                                                                                    _2510 = _2486.x;
                                                                                  }
                                                                                } else {
                                                                                  _2510 = _2257;
                                                                                }
                                                                                _2511 = (_2497 < _2288);
                                                                                do {
                                                                                  if (!(_2511 || _2501)) {
                                                                                    if ((_2497 >= _2294) || (_2495 >= _2295)) {
                                                                                      _2519 = _2257;
                                                                                    } else {
                                                                                      _2519 = _2486.y;
                                                                                    }
                                                                                  } else {
                                                                                    _2519 = _2257;
                                                                                  }
                                                                                  _2520 = (_2499 < _2289);
                                                                                  do {
                                                                                    if (!(_2511 || _2520)) {
                                                                                      if ((_2497 >= _2294) || (_2499 >= _2295)) {
                                                                                        _2528 = _2257;
                                                                                      } else {
                                                                                        _2528 = _2486.z;
                                                                                      }
                                                                                    } else {
                                                                                      _2528 = _2257;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_2500 || _2520)) {
                                                                                        if ((_2494 >= _2294) || (_2499 >= _2295)) {
                                                                                          _2536 = _2257;
                                                                                        } else {
                                                                                          _2536 = _2486.w;
                                                                                        }
                                                                                      } else {
                                                                                        _2536 = _2257;
                                                                                      }
                                                                                      _2537 = _2510 - _2237;
                                                                                      _2539 = select((_2537 < 0.0f), 0.0f, 1.0f);
                                                                                      _2543 = _2519 - _2237;
                                                                                      _2545 = select((_2543 < 0.0f), 0.0f, 1.0f);
                                                                                      _2549 = _2528 - _2237;
                                                                                      _2551 = select((_2549 < 0.0f), 0.0f, 1.0f);
                                                                                      _2555 = _2536 - _2237;
                                                                                      _2557 = select((_2555 < 0.0f), 0.0f, 1.0f);
                                                                                      _2564 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                      _2569 = sqrt((float((int)(_2564)) * 0.25f) + 0.125f) * _1878;
                                                                                      _2578 = (_global_7[min((uint)(((int)(0u + (_2564 * 2)))), 127u)]) * _2569;
                                                                                      _2579 = (_global_7[min((uint)(((int)(1u + (_2564 * 2)))), 127u)]) * _2569;
                                                                                      _2582 = dot(float2(_2578, _2579), float2(_2252, _2251)) + _2227;
                                                                                      _2583 = dot(float2(_2578, _2579), float2(_2275, _2252)) + _2228;
                                                                                      _2585 = _HeapResource_17.GatherRed(samplerPointClampNode, float2(_2582, _2583));
                                                                                      _2589 = _2582 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _2590 = _2583 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _2593 = floor(_2589 + -0.5f);
                                                                                      _2594 = floor(_2590 + 0.5f);
                                                                                      _2596 = floor(_2589 + 0.5f);
                                                                                      _2598 = floor(_2590 + -0.5f);
                                                                                      _2599 = (_2593 < _2288);
                                                                                      _2600 = (_2594 < _2289);
                                                                                      do {
                                                                                        if (!(_2599 || _2600)) {
                                                                                          if ((_2593 >= _2294) || (_2594 >= _2295)) {
                                                                                            _2609 = _2257;
                                                                                          } else {
                                                                                            _2609 = _2585.x;
                                                                                          }
                                                                                        } else {
                                                                                          _2609 = _2257;
                                                                                        }
                                                                                        _2610 = (_2596 < _2288);
                                                                                        do {
                                                                                          if (!(_2610 || _2600)) {
                                                                                            if ((_2596 >= _2294) || (_2594 >= _2295)) {
                                                                                              _2618 = _2257;
                                                                                            } else {
                                                                                              _2618 = _2585.y;
                                                                                            }
                                                                                          } else {
                                                                                            _2618 = _2257;
                                                                                          }
                                                                                          _2619 = (_2598 < _2289);
                                                                                          do {
                                                                                            if (!(_2610 || _2619)) {
                                                                                              if ((_2596 >= _2294) || (_2598 >= _2295)) {
                                                                                                _2627 = _2257;
                                                                                              } else {
                                                                                                _2627 = _2585.z;
                                                                                              }
                                                                                            } else {
                                                                                              _2627 = _2257;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_2599 || _2619)) {
                                                                                                if ((_2593 >= _2294) || (_2598 >= _2295)) {
                                                                                                  _2635 = _2257;
                                                                                                } else {
                                                                                                  _2635 = _2585.w;
                                                                                                }
                                                                                              } else {
                                                                                                _2635 = _2257;
                                                                                              }
                                                                                              _2636 = _2609 - _2237;
                                                                                              _2638 = select((_2636 < 0.0f), 0.0f, 1.0f);
                                                                                              _2642 = _2618 - _2237;
                                                                                              _2644 = select((_2642 < 0.0f), 0.0f, 1.0f);
                                                                                              _2648 = _2627 - _2237;
                                                                                              _2650 = select((_2648 < 0.0f), 0.0f, 1.0f);
                                                                                              _2654 = _2635 - _2237;
                                                                                              _2656 = select((_2654 < 0.0f), 0.0f, 1.0f);
                                                                                              _2657 = ((((((((((((((_2347 + _2343) + _2353) + _2359) + _2440) + _2446) + _2452) + _2458) + _2539) + _2545) + _2551) + _2557) + _2638) + _2644) + _2650) + _2656;
                                                                                              _2668 = (saturate(_2657 * 0.0625f) * 2.0f) + -1.0f;
                                                                                              _2674 = float((int)(((int)(uint)((int)(_2668 > 0.0f))) - ((int)(uint)((int)(_2668 < 0.0f)))));
                                                                                              _2676 = 1.0f - (_2674 * _2668);
                                                                                              _2678 = (_2676 * _2676) * _2676;
                                                                                              _2687 = (0.5f - ((_2674 * 0.5f) * ((1.0f - _2678) - ((_2676 - _2678) * saturate(((1.0f / _2237) * (1.0f / _2657)) * ((((((((((((((((_2347 * _2345) + (_2343 * _2341)) + (_2353 * _2351)) + (_2359 * _2357)) + (_2440 * _2438)) + (_2446 * _2444)) + (_2452 * _2450)) + (_2458 * _2456)) + (_2539 * _2537)) + (_2545 * _2543)) + (_2551 * _2549)) + (_2557 * _2555)) + (_2638 * _2636)) + (_2644 * _2642)) + (_2650 * _2648)) + (_2656 * _2654)))))));
                                                                                            } while (false);
                                                                                            if (_loop_break_3) break;
                                                                                          } while (false);
                                                                                          if (_loop_break_3) break;
                                                                                        } while (false);
                                                                                        if (_loop_break_3) break;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            }
                                                            _2692 = (lerp(_2687, _2222, _2223));
                                                            [branch]
                                                            if (!((_1607 & 2048) == 0)) {
                                                              Texture2D<float> _HeapResource_18 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_1820) >> 16))];
                                                              _2698 = _HeapResource_18.SampleLevel(samplerLinearClampNode, float2(_1912, _1916), 0.0f);
                                                              if (_2698.x > 0.0f) {
                                                                Texture2D<float4> _HeapResource_19 = ResourceDescriptorHeap[NonUniformResourceIndex((_1820 & 65535))];
                                                                _2705 = _HeapResource_19.SampleLevel(samplerLinearClampNode, float2(_1912, _1916), 0.0f);
                                                                _2719 = mad(saturate(((log2(_1921 * _1805) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                _2720 = max(9.999999747378752e-06f, _2698.x);
                                                                _2721 = _2705.x / _2720;
                                                                _2722 = _2705.y / _2720;
                                                                _2724 = _2705.w / _2720;
                                                                _2729 = ((0.375f - _2722) * 4.999999873689376e-06f) + _2722;
                                                                _2732 = -0.0f - _2721;
                                                                _2733 = mad(_2732, _2729, (_2705.z / _2720));
                                                                _2735 = 1.0f / mad(_2732, _2721, _2729);
                                                                _2736 = _2735 * _2733;
                                                                _2741 = _2719 - _2721;
                                                                _2746 = (((_2719 * _2719) - _2729) - (_2736 * _2741)) / mad((-0.0f - _2733), _2736, mad((-0.0f - _2729), _2729, (((0.375f - _2724) * 4.999999873689376e-06f) + _2724)));
                                                                _2748 = (_2735 * _2741) - (_2746 * _2736);
                                                                _2751 = 1.0f / _2746;
                                                                _2752 = _2748 * _2751;
                                                                _2757 = sqrt(((_2752 * _2752) * 0.25f) - ((1.0f - dot(float2(_2748, _2746), float2(_2721, _2729))) * _2751));
                                                                _2759 = (_2752 * -0.5f) - _2757;
                                                                _2761 = _2757 - (_2752 * 0.5f);
                                                                _2763 = select((_2759 < _2719), 1.0f, 0.0f);
                                                                _2768 = (_2763 + -0.05000000074505806f) / (_2759 - _2719);
                                                                _2774 = (((select((_2761 < _2719), 1.0f, 0.0f) - _2763) / (_2761 - _2759)) - _2768) / (_2761 - _2719);
                                                                _2776 = _2768 - (_2774 * _2759);
                                                                _2789 = (exp2((_2698.x * -1.4426950216293335f) * saturate((dot(float2(_2721, _2729), float2((_2776 - (_2774 * _2719)), _2774)) + 0.05000000074505806f) - (_2776 * _2719))) * _2692);
                                                              } else {
                                                                _2789 = _2692;
                                                              }
                                                            } else {
                                                              _2789 = _2692;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      }
                                                      do {
                                                        _2810 = _1852;
                                                        _2811 = _1853;
                                                        _2812 = _1855;
                                                        [branch]
                                                        if (!(_1867 == 0)) {
                                                          Texture2D<float3> _HeapResource_20 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _1867)))];
                                                          _2802 = _HeapResource_20.SampleLevel(samplerLinearWrapNode, float2(((_1912 * f16tof32(((uint)((uint)(_1838) >> 16)))) + f16tof32(((uint)((uint)(_1841) >> 16)))), ((_1916 * f16tof32(_1838)) + f16tof32(_1841))), 0.0f);
                                                          _2810 = (_2802.x * _1852);
                                                          _2811 = (_2802.y * _1853);
                                                          _2812 = (_2802.z * _1855);
                                                        }
                                                        _2813 = _2789 * _1950;
                                                        [branch]
                                                        if (!(_2813 == 0.0f)) {
                                                          do {
                                                            _2831 = GetDeferredSoftShadowChannel(_1610);
                                                            if (_2831 < 0) {
                                                                  _2852 = _2813;
                                                                  do {
                                                                    _8462 = _1595;
                                                                    _8463 = _1596;
                                                                    _8464 = _1597;
                                                                    _8465 = _1598;
                                                                    _8466 = _1599;
                                                                    _8467 = _1600;
                                                                    [branch]
                                                                    if (!(_2852 == 0.0f)) {
                                                                      do {
                                                                        _2891 = _2852;
                                                                        [branch]
                                                                        if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                          _2862 = srvLightMappingData[_1610];
                                                                          if (!(_2862 == -1)) {
                                                                            _2867 = srvLightIndexData[_2862].nLayerIndex;
                                                                            _2869 = srvLightIndexData[_2862].vAtlasOrigin.x;
                                                                            _2870 = srvLightIndexData[_2862].vAtlasOrigin.y;
                                                                            _2872 = srvLightIndexData[_2862].vScreenOrigin.x;
                                                                            _2873 = srvLightIndexData[_2862].vScreenOrigin.y;
                                                                            _2882 = ((int)(_2867 * 5)) & 31;
                                                                            _2891 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2869 + _64) - _2872)), ((int)((_2870 + _65) - _2873)), 0)))).x) & ((int)(31 << _2882)))) >> _2882)) >> 1)))) * 0.06666667014360428f) * _2852);
                                                                          } else {
                                                                            _2891 = _2852;
                                                                          }
                                                                        }
                                                                        _2895 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                        _2898 = select(_2895, (_2891 * _1281), _2891);
                                                                        _2900 = dot(float3(_1800, _1801, _1802), float3(_1800, _1801, _1802));
                                                                        _2901 = rsqrt(_2900);
                                                                        _2902 = _2901 * _1800;
                                                                        _2903 = _2901 * _1801;
                                                                        _2904 = _2901 * _1802;
                                                                        _2905 = dot(float3(_192, _193, _194), float3(_2902, _2903, _2904));
                                                                        do {
                                                                          _2923 = _2905;
                                                                          if (_1864 > 0.0f) {
                                                                            _2913 = sqrt(saturate((_1864 * _1864) * (1.0f / (_2900 + 1.0f))));
                                                                            if (_2905 < _2913) {
                                                                              _2918 = max(_2905, (-0.0f - _2913)) + _2913;
                                                                              _2923 = ((_2918 * _2918) / (_2913 * 4.0f));
                                                                            } else {
                                                                              _2923 = _2905;
                                                                            }
                                                                          }
                                                                          _2924 = _219 * _219;
                                                                          _2928 = saturate((_1864 * (1.0f - _2924)) * _2901);
                                                                          _2930 = saturate(_2901 * f16tof32(_1814));
                                                                          _2931 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                                          _2932 = dot(float3(_452, _453, _451), float3(_2902, _2903, _2904));
                                                                          _2935 = rsqrt((_2932 * 2.0f) + 2.0f);
                                                                          _2942 = (_2928 > 0.0f);
                                                                          do {
                                                                            _3033 = saturate((_2935 * _2932) + _2935);
                                                                            _3034 = saturate(_2935 * (_2931 + _2905));
                                                                            if (_2942) {
                                                                              _2946 = sqrt(1.0f - (_2928 * _2928));
                                                                              _2948 = (_2905 * 2.0f) * _2931;
                                                                              _2949 = _2948 - _2932;
                                                                              if (!(!(_2949 >= _2946))) {
                                                                                _3033 = abs(_2931);
                                                                                _3034 = 1.0f;
                                                                              } else {
                                                                                _2957 = rsqrt(1.0f - (_2949 * _2949)) * _2928;
                                                                                _2960 = _2957 * (_2931 - (_2949 * _2905));
                                                                                _2961 = _2931 * _2931;
                                                                                _2966 = _2957 * (((_2961 * 2.0f) + -1.0f) - (_2949 * _2932));
                                                                                _2975 = sqrt(saturate((((1.0f - (_2905 * _2905)) - _2961) - (_2932 * _2932)) + (_2948 * _2932)));
                                                                                _2976 = _2975 * _2957;
                                                                                _2979 = ((_2931 * 2.0f) * _2957) * _2975;
                                                                                _2981 = (_2946 * _2905) + _2931;
                                                                                _2982 = _2981 + _2960;
                                                                                _2983 = _2946 * _2932;
                                                                                _2985 = (_2983 + 1.0f) + _2966;
                                                                                _2986 = _2976 * _2985;
                                                                                _2987 = _2982 * _2985;
                                                                                _2988 = _2979 * _2982;
                                                                                _2993 = (((_2982 * 0.25f) * _2979) - (_2986 * 0.5f)) * _2987;
                                                                                _3007 = (((_2988 - (_2986 * 2.0f)) * _2988) + (_2986 * _2986)) + ((((-0.5f - ((_2985 + _2983) * 0.5f)) * _2987) + ((_2985 * _2985) * _2981)) * _2982);
                                                                                _3012 = (_2993 * 2.0f) / ((_3007 * _3007) + (_2993 * _2993));
                                                                                _3013 = _3007 * _3012;
                                                                                _3015 = 1.0f - (_2993 * _3012);
                                                                                _3021 = ((_3013 * _2979) + _2983) + (_3015 * _2966);
                                                                                _3024 = rsqrt((_3021 * 2.0f) + 2.0f);
                                                                                _3033 = saturate((_3021 * _3024) + _3024);
                                                                                _3034 = saturate(((_2981 + (_3013 * _2976)) + (_3015 * _2960)) * _3024);
                                                                              }
                                                                            }
                                                                            _3035 = saturate(_2923);
                                                                            _3036 = _2924 * _2924;
                                                                            do {
                                                                              _3046 = _3036;
                                                                              if (_2930 > 0.0f) {
                                                                                _3046 = saturate(((_2930 * _2930) / ((_3033 * 3.5999999046325684f) + 0.4000000059604645f)) + _3036);
                                                                              }
                                                                              _3047 = sqrt(_3046);
                                                                              do {
                                                                                _3058 = 1.0f;
                                                                                if (_2942) {
                                                                                  _3058 = (_3046 / ((((_2928 * 0.25f) * ((_3047 * 3.0f) + _2928)) / (_3033 + 0.0010000000474974513f)) + _3046));
                                                                                }
                                                                                _3062 = (((_3046 * _3034) - _3034) * _3034) + 1.0f;
                                                                                _3069 = exp2(log2(1.0f - saturate(_3033)) * 5.0f);
                                                                                _3072 = saturate(abs(_2931) + 9.999999747378752e-06f);
                                                                                _3073 = 1.0f - _3047;
                                                                                _3085 = saturate((_2905 + _1862) / (_1862 + 1.0f));
                                                                                _3088 = ((_3058 * _3035) * (_3046 / (_3062 * _3062))) * (0.5f / ((((_3073 * _3072) + _3047) * _3035) + (((_3073 * _3035) + _3047) * _3072)));
                                                                                _3089 = _2810 * _1658;
                                                                                _3090 = _2811 * _1658;
                                                                                _3091 = _2812 * _1658;
                                                                                _3098 = ((_2898 * _3089) * _3085) + _1595;
                                                                                _3099 = ((_2898 * _3090) * _3085) + _1596;
                                                                                _3100 = ((_2898 * _3091) * _3085) + _1597;
                                                                                if (_1859 > 0.0f) {
                                                                                  _3112 = (_1859 * _1354) * select(_2895, (_2891 * _1281), _2891);
                                                                                  _8462 = _3098;
                                                                                  _8463 = _3099;
                                                                                  _8464 = _3100;
                                                                                  _8465 = (((((_3089 * _1144) * _3112) * ((_3069 * (1.0f - _211)) + _211)) * _3088) + _1598);
                                                                                  _8466 = (((((_3090 * _1145) * _3112) * ((_3069 * (1.0f - _212)) + _212)) * _3088) + _1599);
                                                                                  _8467 = (((((_3091 * _1146) * _3112) * ((_3069 * (1.0f - _213)) + _213)) * _3088) + _1600);
                                                                                } else {
                                                                                  _8462 = _3098;
                                                                                  _8463 = _3099;
                                                                                  _8464 = _3100;
                                                                                  _8465 = _1598;
                                                                                  _8466 = _1599;
                                                                                  _8467 = _1600;
                                                                                }
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    }
                                                                    break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                              // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                              break;
                                                            }
                                                            _2834 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_64, _65, 0));
                                                            do {
                                                              if (_2831 == 0) {
                                                                _2848 = _2834.x;
                                                              } else {
                                                                if (_2831 == 1) {
                                                                  _2848 = _2834.y;
                                                                } else {
                                                                  if (_2831 == 2) {
                                                                    _2848 = _2834.z;
                                                                  } else {
                                                                    _2848 = _2834.w;
                                                                  }
                                                                }
                                                              }
                                                              _2852 = ((_2848 * _2848) * _1950);
                                                              [branch]
                                                              if (!(_2852 == 0.0f)) {
                                                                do {
                                                                  _2891 = _2852;
                                                                  [branch]
                                                                  if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                    _2862 = srvLightMappingData[_1610];
                                                                    if (!(_2862 == -1)) {
                                                                      _2867 = srvLightIndexData[_2862].nLayerIndex;
                                                                      _2869 = srvLightIndexData[_2862].vAtlasOrigin.x;
                                                                      _2870 = srvLightIndexData[_2862].vAtlasOrigin.y;
                                                                      _2872 = srvLightIndexData[_2862].vScreenOrigin.x;
                                                                      _2873 = srvLightIndexData[_2862].vScreenOrigin.y;
                                                                      _2882 = ((int)(_2867 * 5)) & 31;
                                                                      _2891 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_2869 + _64) - _2872)), ((int)((_2870 + _65) - _2873)), 0)))).x) & ((int)(31 << _2882)))) >> _2882)) >> 1)))) * 0.06666667014360428f) * _2852);
                                                                    } else {
                                                                      _2891 = _2852;
                                                                    }
                                                                  }
                                                                  _2895 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                  _2898 = select(_2895, (_2891 * _1281), _2891);
                                                                  _2900 = dot(float3(_1800, _1801, _1802), float3(_1800, _1801, _1802));
                                                                  _2901 = rsqrt(_2900);
                                                                  _2902 = _2901 * _1800;
                                                                  _2903 = _2901 * _1801;
                                                                  _2904 = _2901 * _1802;
                                                                  _2905 = dot(float3(_192, _193, _194), float3(_2902, _2903, _2904));
                                                                  do {
                                                                    _2923 = _2905;
                                                                    if (_1864 > 0.0f) {
                                                                      _2913 = sqrt(saturate((_1864 * _1864) * (1.0f / (_2900 + 1.0f))));
                                                                      if (_2905 < _2913) {
                                                                        _2918 = max(_2905, (-0.0f - _2913)) + _2913;
                                                                        _2923 = ((_2918 * _2918) / (_2913 * 4.0f));
                                                                      } else {
                                                                        _2923 = _2905;
                                                                      }
                                                                    }
                                                                    _2924 = _219 * _219;
                                                                    _2928 = saturate((_1864 * (1.0f - _2924)) * _2901);
                                                                    _2930 = saturate(_2901 * f16tof32(_1814));
                                                                    _2931 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                                    _2932 = dot(float3(_452, _453, _451), float3(_2902, _2903, _2904));
                                                                    _2935 = rsqrt((_2932 * 2.0f) + 2.0f);
                                                                    _2942 = (_2928 > 0.0f);
                                                                    do {
                                                                      _3033 = saturate((_2935 * _2932) + _2935);
                                                                      _3034 = saturate(_2935 * (_2931 + _2905));
                                                                      if (_2942) {
                                                                        _2946 = sqrt(1.0f - (_2928 * _2928));
                                                                        _2948 = (_2905 * 2.0f) * _2931;
                                                                        _2949 = _2948 - _2932;
                                                                        if (!(!(_2949 >= _2946))) {
                                                                          _3033 = abs(_2931);
                                                                          _3034 = 1.0f;
                                                                        } else {
                                                                          _2957 = rsqrt(1.0f - (_2949 * _2949)) * _2928;
                                                                          _2960 = _2957 * (_2931 - (_2949 * _2905));
                                                                          _2961 = _2931 * _2931;
                                                                          _2966 = _2957 * (((_2961 * 2.0f) + -1.0f) - (_2949 * _2932));
                                                                          _2975 = sqrt(saturate((((1.0f - (_2905 * _2905)) - _2961) - (_2932 * _2932)) + (_2948 * _2932)));
                                                                          _2976 = _2975 * _2957;
                                                                          _2979 = ((_2931 * 2.0f) * _2957) * _2975;
                                                                          _2981 = (_2946 * _2905) + _2931;
                                                                          _2982 = _2981 + _2960;
                                                                          _2983 = _2946 * _2932;
                                                                          _2985 = (_2983 + 1.0f) + _2966;
                                                                          _2986 = _2976 * _2985;
                                                                          _2987 = _2982 * _2985;
                                                                          _2988 = _2979 * _2982;
                                                                          _2993 = (((_2982 * 0.25f) * _2979) - (_2986 * 0.5f)) * _2987;
                                                                          _3007 = (((_2988 - (_2986 * 2.0f)) * _2988) + (_2986 * _2986)) + ((((-0.5f - ((_2985 + _2983) * 0.5f)) * _2987) + ((_2985 * _2985) * _2981)) * _2982);
                                                                          _3012 = (_2993 * 2.0f) / ((_3007 * _3007) + (_2993 * _2993));
                                                                          _3013 = _3007 * _3012;
                                                                          _3015 = 1.0f - (_2993 * _3012);
                                                                          _3021 = ((_3013 * _2979) + _2983) + (_3015 * _2966);
                                                                          _3024 = rsqrt((_3021 * 2.0f) + 2.0f);
                                                                          _3033 = saturate((_3021 * _3024) + _3024);
                                                                          _3034 = saturate(((_2981 + (_3013 * _2976)) + (_3015 * _2960)) * _3024);
                                                                        }
                                                                      }
                                                                      _3035 = saturate(_2923);
                                                                      _3036 = _2924 * _2924;
                                                                      do {
                                                                        _3046 = _3036;
                                                                        if (_2930 > 0.0f) {
                                                                          _3046 = saturate(((_2930 * _2930) / ((_3033 * 3.5999999046325684f) + 0.4000000059604645f)) + _3036);
                                                                        }
                                                                        _3047 = sqrt(_3046);
                                                                        do {
                                                                          _3058 = 1.0f;
                                                                          if (_2942) {
                                                                            _3058 = (_3046 / ((((_2928 * 0.25f) * ((_3047 * 3.0f) + _2928)) / (_3033 + 0.0010000000474974513f)) + _3046));
                                                                          }
                                                                          _3062 = (((_3046 * _3034) - _3034) * _3034) + 1.0f;
                                                                          _3069 = exp2(log2(1.0f - saturate(_3033)) * 5.0f);
                                                                          _3072 = saturate(abs(_2931) + 9.999999747378752e-06f);
                                                                          _3073 = 1.0f - _3047;
                                                                          _3085 = saturate((_2905 + _1862) / (_1862 + 1.0f));
                                                                          _3088 = ((_3058 * _3035) * (_3046 / (_3062 * _3062))) * (0.5f / ((((_3073 * _3072) + _3047) * _3035) + (((_3073 * _3035) + _3047) * _3072)));
                                                                          _3089 = _2810 * _1658;
                                                                          _3090 = _2811 * _1658;
                                                                          _3091 = _2812 * _1658;
                                                                          _3098 = ((_2898 * _3089) * _3085) + _1595;
                                                                          _3099 = ((_2898 * _3090) * _3085) + _1596;
                                                                          _3100 = ((_2898 * _3091) * _3085) + _1597;
                                                                          if (_1859 > 0.0f) {
                                                                            _3112 = (_1859 * _1354) * select(_2895, (_2891 * _1281), _2891);
                                                                            _8462 = _3098;
                                                                            _8463 = _3099;
                                                                            _8464 = _3100;
                                                                            _8465 = (((((_3089 * _1144) * _3112) * ((_3069 * (1.0f - _211)) + _211)) * _3088) + _1598);
                                                                            _8466 = (((((_3090 * _1145) * _3112) * ((_3069 * (1.0f - _212)) + _212)) * _3088) + _1599);
                                                                            _8467 = (((((_3091 * _1146) * _3112) * ((_3069 * (1.0f - _213)) + _213)) * _3088) + _1600);
                                                                          } else {
                                                                            _8462 = _3098;
                                                                            _8463 = _3099;
                                                                            _8464 = _3100;
                                                                            _8465 = _1598;
                                                                            _8466 = _1599;
                                                                            _8467 = _1600;
                                                                          }
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } else {
                                                                _8462 = _1595;
                                                                _8463 = _1596;
                                                                _8464 = _1597;
                                                                _8465 = _1598;
                                                                _8466 = _1599;
                                                                _8467 = _1600;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _8462 = _1595;
                                                          _8463 = _1596;
                                                          _8464 = _1597;
                                                          _8465 = _1598;
                                                          _8466 = _1599;
                                                          _8467 = _1600;
                                                        }
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } while (false);
                                                    if (_loop_break_3) break;
                                                  } else {
                                                    if (_1641 == 7) {
                                                      _3575 = asfloat(srvLightInfoProperties.Load3(_1609)).x;
                                                      _3576 = asfloat(srvLightInfoProperties.Load3(_1609)).y;
                                                      _3577 = asfloat(srvLightInfoProperties.Load3(_1609)).z;
                                                      _3580 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 12u)))).x;
                                                      _3581 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 12u)))).y;
                                                      _3582 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 12u)))).z;
                                                      _3585 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 24u)))).x;
                                                      _3586 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 24u)))).y;
                                                      _3587 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 24u)))).z;
                                                      _3590 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 36u)))).x;
                                                      _3591 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 36u)))).y;
                                                      _3592 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 36u)))).z;
                                                      _3595 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).x;
                                                      _3596 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).y;
                                                      _3597 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 48u)))).z;
                                                      _3600 = asint(srvLightInfoProperties.Load(((int)(_1609 + 60u))));
                                                      _3603 = asint(srvLightInfoProperties.Load(((int)(_1609 + 64u))));
                                                      _3606 = asint(srvLightInfoProperties.Load(((int)(_1609 + 72u))));
                                                      _3609 = asint(srvLightInfoProperties.Load(((int)(_1609 + 76u))));
                                                      _3612 = asint(srvLightInfoProperties.Load(((int)(_1609 + 80u))));
                                                      _3615 = asint(srvLightInfoProperties.Load(((int)(_1609 + 84u))));
                                                      _3618 = asint(srvLightInfoProperties.Load(((int)(_1609 + 88u))));
                                                      _3621 = asint(srvLightInfoProperties.Load(((int)(_1609 + 92u))));
                                                      _3624 = asint(srvLightInfoProperties.Load(((int)(_1609 + 96u))));
                                                      _3627 = asint(srvLightInfoProperties.Load(((int)(_1609 + 100u))));
                                                      _3630 = asint(srvLightInfoProperties.Load(((int)(_1609 + 104u))));
                                                      _3633 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).x;
                                                      _3634 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).y;
                                                      _3635 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).z;
                                                      _3636 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).w;
                                                      _3639 = asint(srvLightInfoProperties.Load(((int)(_1609 + 124u))));
                                                      _3642 = asint(srvLightInfoProperties.Load(((int)(_1609 + 128u))));
                                                      _3645 = asint(srvLightInfoProperties.Load(((int)(_1609 + 136u))));
                                                      _3648 = asint(srvLightInfoProperties.Load(((int)(_1609 + 140u))));
                                                      _3650 = f16tof32(((uint)((uint)(_3600) >> 16)));
                                                      _3651 = f16tof32(_3600);
                                                      _3653 = f16tof32(((uint)((uint)(_3603) >> 16)));
                                                      _3657 = ((float)((uint)((uint)(((uint)(_3603) >> 8) & 255)))) * 0.003921499941498041f;
                                                      _3660 = ((float)((uint)((uint)(_3603 & 255)))) * 0.003921499941498041f;
                                                      _3661 = f16tof32(_3606);
                                                      _3663 = f16tof32(((uint)((uint)(_3609) >> 16)));
                                                      _3667 = f16tof32(_3612);
                                                      _3669 = f16tof32(((uint)((uint)(_3615) >> 16)));
                                                      _3670 = f16tof32(_3615);
                                                      _3672 = f16tof32(((uint)((uint)(_3618) >> 16)));
                                                      _3675 = _3621 & 65535;
                                                      _3679 = ((_1607 & 4194304) != 0);
                                                      _3687 = f16tof32(((uint)((uint)(_3630) >> 16)));
                                                      _3688 = f16tof32(_3630);
                                                      _3690 = f16tof32(((uint)((uint)(_3639) >> 16)));
                                                      _3693 = f16tof32(((uint)((uint)(_3642) >> 16)));
                                                      _3694 = f16tof32(_3642);
                                                      _3696 = f16tof32(((uint)((uint)(_3645) >> 16)));
                                                      _3697 = _3696 + -1.0f;
                                                      do {
                                                        if (_3679) {
                                                          _3699 = 0.5f / _3696;
                                                          _3700 = 0.3333333432674408f / _3696;
                                                          _3704 = (_3696 * 0.5f) + 0.5f;
                                                          _3714 = (_3699 * _3697);
                                                          _3715 = (_3700 * _3697);
                                                          _3716 = (_3699 * _3704);
                                                          _3717 = (_3700 * _3704);
                                                          _3718 = (_3696 * 2.0f);
                                                          _3719 = (_3696 * 3.0f);
                                                        } else {
                                                          _3710 = 1.0f / _3696;
                                                          _3711 = _3710 * _3697;
                                                          _3712 = _3710 * 0.5f;
                                                          _3714 = _3711;
                                                          _3715 = _3711;
                                                          _3716 = _3712;
                                                          _3717 = _3712;
                                                          _3718 = _3696;
                                                          _3719 = _3696;
                                                        }
                                                        _3723 = _3590 - _234;
                                                        _3724 = _3591 - _235;
                                                        _3725 = _3592 + _233;
                                                        _3726 = dot(float3(_3723, _3724, _3725), float3(_3723, _3724, _3725));
                                                        _3727 = rsqrt(_3726);
                                                        _3728 = _3727 * _3726;
                                                        _3729 = _3727 * _3723;
                                                        _3730 = _3727 * _3724;
                                                        _3731 = _3727 * _3725;
                                                        _3734 = max(0.0f, (_3728 - abs(_3667)));
                                                        _3735 = _3734 * f16tof32(((uint)((uint)(_3612) >> 16)));
                                                        _3736 = _3735 * _3735;
                                                        _3739 = saturate(1.0f - (_3736 * _3736));
                                                        _3746 = (_3739 * _3739) / (select((_3667 < 0.0f), (_3736 * 16.0f), (_3734 * _3734)) + 1.0f);
                                                        _3759 = saturate(1.0f - dot(float3(_192, _193, _194), float3(_3729, _3730, _3731))) * f16tof32(_3639);
                                                        _3763 = abs(_3725);
                                                        _3767 = _3723 - ((_3759 * _192) * _3763);
                                                        _3768 = _3724 - ((_3759 * _193) * _3763);
                                                        _3769 = _3725 - ((_3759 * _194) * _3763);
                                                        _3772 = mad(_3769, _3586, mad(_3768, _3581, (_3767 * _3576)));
                                                        _3775 = mad(_3769, _3587, mad(_3768, _3582, (_3767 * _3577)));
                                                        _3777 = ((_1607 & 3584) != 0);
                                                        do {
                                                          _5568 = _3746;
                                                          _5569 = 1.0f;
                                                          if (_3777 && (_3746 > 0.0f)) {
                                                            _3783 = mad(_3769, _3585, mad(_3768, _3580, (_3767 * _3575)));
                                                            _3784 = -0.0f - _3775;
                                                            _3785 = -0.0f - _3772;
                                                            do {
                                                              _4574 = 1.0f;
                                                              _4575 = 1.0f;
                                                              _4576 = 0;
                                                              [branch]
                                                              if (!((_1607 & 1024) == 0)) {
                                                                Texture2D<float4> _HeapResource_22 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3621) >> 16))];
                                                                [branch]
                                                                if (_3679) {
                                                                  _3790 = abs(_3783);
                                                                  _3791 = abs(_3784);
                                                                  _3792 = abs(_3785);
                                                                  do {
                                                                    if (_3790 > max(_3791, _3792)) {
                                                                      _3796 = (_3783 > 0.0f);
                                                                      _3811 = select(_3796, 0.0f, 1.0f);
                                                                      _3812 = 0.0f;
                                                                      _3813 = select(_3796, _3772, _3785);
                                                                      _3814 = _3775;
                                                                      _3815 = _3790;
                                                                    } else {
                                                                      if (_3791 > _3792) {
                                                                        _3802 = (_3775 < -0.0f);
                                                                        _3811 = select(_3802, 0.0f, 1.0f);
                                                                        _3812 = 1.0f;
                                                                        _3813 = _3783;
                                                                        _3814 = select(_3802, _3785, _3772);
                                                                        _3815 = _3791;
                                                                      } else {
                                                                        _3806 = (_3772 < -0.0f);
                                                                        _3811 = select(_3806, 0.0f, 1.0f);
                                                                        _3812 = 2.0f;
                                                                        _3813 = select(_3806, _3783, (-0.0f - _3783));
                                                                        _3814 = _3775;
                                                                        _3815 = _3792;
                                                                      }
                                                                    }
                                                                    _3816 = _3815 * 2.0f;
                                                                    _3820 = -0.0f - _3688;
                                                                    _3829 = ((min(max((_3813 / _3816), _3820), _3688) + _3811) * _3714) + _3716;
                                                                    _3830 = ((min(max((_3814 / _3816), _3820), _3688) + _3812) * _3715) + _3717;
                                                                    _3837 = ((_3811 + -0.5f) * _3714) + _3716;
                                                                    _3838 = ((_3812 + -0.5f) * _3715) + _3717;
                                                                    _3841 = saturate((_3690 + 1.0f) - (_3815 * _3672));
                                                                    _3845 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _3854 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 2u);
                                                                    } else {
                                                                      _3854 = frac(frac(dot(float2(((_3845 * 32.665000915527344f) + _126), ((_3845 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _3854 = frac(frac(dot(float2(((_3845 * 32.665000915527344f) + _126), ((_3845 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _3855 = sin(_3854);
                                                                    _3856 = cos(_3854);
                                                                    _3861 = select(((((float4)(_HeapResource_22.SampleLevel(samplerPointBorderWhiteNode, float2(_3829, _3830), 0.0f))).x) > _3841), 1.0f, 0.0f);
                                                                    _3862 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _3867 = sqrt((float((int)(_3862)) * 0.25f) + 0.125f) * _3693;
                                                                    _3876 = (_global_7[min((uint)(((int)(0u + (_3862 * 2)))), 127u)]) * _3867;
                                                                    _3877 = (_global_7[min((uint)(((int)(1u + (_3862 * 2)))), 127u)]) * _3867;
                                                                    _3879 = -0.0f - _3855;
                                                                    _3881 = dot(float2(_3876, _3877), float2(_3856, _3855)) + _3829;
                                                                    _3882 = dot(float2(_3876, _3877), float2(_3879, _3856)) + _3830;
                                                                    _3884 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3881, _3882));
                                                                    _3888 = _3881 * _3718;
                                                                    _3889 = _3882 * _3719;
                                                                    _3892 = floor(_3837 * _3718);
                                                                    _3893 = floor(_3838 * _3719);
                                                                    _3898 = floor(((_3837 + _3714) * _3718) + 0.5f);
                                                                    _3899 = floor(((_3838 + _3715) * _3719) + 0.5f);
                                                                    _3902 = floor(_3888 + -0.5f);
                                                                    _3903 = floor(_3889 + 0.5f);
                                                                    _3905 = floor(_3888 + 0.5f);
                                                                    _3907 = floor(_3889 + -0.5f);
                                                                    _3908 = (_3902 < _3892);
                                                                    _3909 = (_3903 < _3893);
                                                                    do {
                                                                      if (!(_3908 || _3909)) {
                                                                        if ((_3902 >= _3898) || (_3903 >= _3899)) {
                                                                          _3918 = _3861;
                                                                        } else {
                                                                          _3918 = _3884.x;
                                                                        }
                                                                      } else {
                                                                        _3918 = _3861;
                                                                      }
                                                                      _3919 = (_3905 < _3892);
                                                                      do {
                                                                        if (!(_3919 || _3909)) {
                                                                          if ((_3905 >= _3898) || (_3903 >= _3899)) {
                                                                            _3927 = _3861;
                                                                          } else {
                                                                            _3927 = _3884.y;
                                                                          }
                                                                        } else {
                                                                          _3927 = _3861;
                                                                        }
                                                                        _3928 = (_3907 < _3893);
                                                                        do {
                                                                          if (!(_3919 || _3928)) {
                                                                            if ((_3905 >= _3898) || (_3907 >= _3899)) {
                                                                              _3936 = _3861;
                                                                            } else {
                                                                              _3936 = _3884.z;
                                                                            }
                                                                          } else {
                                                                            _3936 = _3861;
                                                                          }
                                                                          do {
                                                                            if (!(_3908 || _3928)) {
                                                                              if ((_3902 >= _3898) || (_3907 >= _3899)) {
                                                                                _3944 = _3861;
                                                                              } else {
                                                                                _3944 = _3884.w;
                                                                              }
                                                                            } else {
                                                                              _3944 = _3861;
                                                                            }
                                                                            _3945 = _3918 - _3841;
                                                                            _3947 = select((_3945 < 0.0f), 0.0f, 1.0f);
                                                                            _3949 = _3927 - _3841;
                                                                            _3951 = select((_3949 < 0.0f), 0.0f, 1.0f);
                                                                            _3955 = _3936 - _3841;
                                                                            _3957 = select((_3955 < 0.0f), 0.0f, 1.0f);
                                                                            _3961 = _3944 - _3841;
                                                                            _3963 = select((_3961 < 0.0f), 0.0f, 1.0f);
                                                                            _3970 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                            _3975 = sqrt((float((int)(_3970)) * 0.25f) + 0.125f) * _3693;
                                                                            _3984 = (_global_7[min((uint)(((int)(0u + (_3970 * 2)))), 127u)]) * _3975;
                                                                            _3985 = (_global_7[min((uint)(((int)(1u + (_3970 * 2)))), 127u)]) * _3975;
                                                                            _3988 = dot(float2(_3984, _3985), float2(_3856, _3855)) + _3829;
                                                                            _3989 = dot(float2(_3984, _3985), float2(_3879, _3856)) + _3830;
                                                                            _3991 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_3988, _3989));
                                                                            _3995 = _3988 * _3718;
                                                                            _3996 = _3989 * _3719;
                                                                            _3999 = floor(_3995 + -0.5f);
                                                                            _4000 = floor(_3996 + 0.5f);
                                                                            _4002 = floor(_3995 + 0.5f);
                                                                            _4004 = floor(_3996 + -0.5f);
                                                                            _4005 = (_3999 < _3892);
                                                                            _4006 = (_4000 < _3893);
                                                                            do {
                                                                              if (!(_4005 || _4006)) {
                                                                                if ((_3999 >= _3898) || (_4000 >= _3899)) {
                                                                                  _4015 = _3861;
                                                                                } else {
                                                                                  _4015 = _3991.x;
                                                                                }
                                                                              } else {
                                                                                _4015 = _3861;
                                                                              }
                                                                              _4016 = (_4002 < _3892);
                                                                              do {
                                                                                if (!(_4016 || _4006)) {
                                                                                  if ((_4002 >= _3898) || (_4000 >= _3899)) {
                                                                                    _4024 = _3861;
                                                                                  } else {
                                                                                    _4024 = _3991.y;
                                                                                  }
                                                                                } else {
                                                                                  _4024 = _3861;
                                                                                }
                                                                                _4025 = (_4004 < _3893);
                                                                                do {
                                                                                  if (!(_4016 || _4025)) {
                                                                                    if ((_4002 >= _3898) || (_4004 >= _3899)) {
                                                                                      _4033 = _3861;
                                                                                    } else {
                                                                                      _4033 = _3991.z;
                                                                                    }
                                                                                  } else {
                                                                                    _4033 = _3861;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_4005 || _4025)) {
                                                                                      if ((_3999 >= _3898) || (_4004 >= _3899)) {
                                                                                        _4041 = _3861;
                                                                                      } else {
                                                                                        _4041 = _3991.w;
                                                                                      }
                                                                                    } else {
                                                                                      _4041 = _3861;
                                                                                    }
                                                                                    _4042 = _4015 - _3841;
                                                                                    _4044 = select((_4042 < 0.0f), 0.0f, 1.0f);
                                                                                    _4048 = _4024 - _3841;
                                                                                    _4050 = select((_4048 < 0.0f), 0.0f, 1.0f);
                                                                                    _4054 = _4033 - _3841;
                                                                                    _4056 = select((_4054 < 0.0f), 0.0f, 1.0f);
                                                                                    _4060 = _4041 - _3841;
                                                                                    _4062 = select((_4060 < 0.0f), 0.0f, 1.0f);
                                                                                    _4069 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                    _4074 = sqrt((float((int)(_4069)) * 0.25f) + 0.125f) * _3693;
                                                                                    _4083 = (_global_7[min((uint)(((int)(0u + (_4069 * 2)))), 127u)]) * _4074;
                                                                                    _4084 = (_global_7[min((uint)(((int)(1u + (_4069 * 2)))), 127u)]) * _4074;
                                                                                    _4087 = dot(float2(_4083, _4084), float2(_3856, _3855)) + _3829;
                                                                                    _4088 = dot(float2(_4083, _4084), float2(_3879, _3856)) + _3830;
                                                                                    _4090 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4087, _4088));
                                                                                    _4094 = _4087 * _3718;
                                                                                    _4095 = _4088 * _3719;
                                                                                    _4098 = floor(_4094 + -0.5f);
                                                                                    _4099 = floor(_4095 + 0.5f);
                                                                                    _4101 = floor(_4094 + 0.5f);
                                                                                    _4103 = floor(_4095 + -0.5f);
                                                                                    _4104 = (_4098 < _3892);
                                                                                    _4105 = (_4099 < _3893);
                                                                                    do {
                                                                                      if (!(_4104 || _4105)) {
                                                                                        if ((_4098 >= _3898) || (_4099 >= _3899)) {
                                                                                          _4114 = _3861;
                                                                                        } else {
                                                                                          _4114 = _4090.x;
                                                                                        }
                                                                                      } else {
                                                                                        _4114 = _3861;
                                                                                      }
                                                                                      _4115 = (_4101 < _3892);
                                                                                      do {
                                                                                        if (!(_4115 || _4105)) {
                                                                                          if ((_4101 >= _3898) || (_4099 >= _3899)) {
                                                                                            _4123 = _3861;
                                                                                          } else {
                                                                                            _4123 = _4090.y;
                                                                                          }
                                                                                        } else {
                                                                                          _4123 = _3861;
                                                                                        }
                                                                                        _4124 = (_4103 < _3893);
                                                                                        do {
                                                                                          if (!(_4115 || _4124)) {
                                                                                            if ((_4101 >= _3898) || (_4103 >= _3899)) {
                                                                                              _4132 = _3861;
                                                                                            } else {
                                                                                              _4132 = _4090.z;
                                                                                            }
                                                                                          } else {
                                                                                            _4132 = _3861;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_4104 || _4124)) {
                                                                                              if ((_4098 >= _3898) || (_4103 >= _3899)) {
                                                                                                _4140 = _3861;
                                                                                              } else {
                                                                                                _4140 = _4090.w;
                                                                                              }
                                                                                            } else {
                                                                                              _4140 = _3861;
                                                                                            }
                                                                                            _4141 = _4114 - _3841;
                                                                                            _4143 = select((_4141 < 0.0f), 0.0f, 1.0f);
                                                                                            _4147 = _4123 - _3841;
                                                                                            _4149 = select((_4147 < 0.0f), 0.0f, 1.0f);
                                                                                            _4153 = _4132 - _3841;
                                                                                            _4155 = select((_4153 < 0.0f), 0.0f, 1.0f);
                                                                                            _4159 = _4140 - _3841;
                                                                                            _4161 = select((_4159 < 0.0f), 0.0f, 1.0f);
                                                                                            _4168 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                            _4173 = sqrt((float((int)(_4168)) * 0.25f) + 0.125f) * _3693;
                                                                                            _4182 = (_global_7[min((uint)(((int)(0u + (_4168 * 2)))), 127u)]) * _4173;
                                                                                            _4183 = (_global_7[min((uint)(((int)(1u + (_4168 * 2)))), 127u)]) * _4173;
                                                                                            _4186 = dot(float2(_4182, _4183), float2(_3856, _3855)) + _3829;
                                                                                            _4187 = dot(float2(_4182, _4183), float2(_3879, _3856)) + _3830;
                                                                                            _4189 = _HeapResource_22.GatherRed(samplerPointClampNode, float2(_4186, _4187));
                                                                                            _4193 = _4186 * _3718;
                                                                                            _4194 = _4187 * _3719;
                                                                                            _4197 = floor(_4193 + -0.5f);
                                                                                            _4198 = floor(_4194 + 0.5f);
                                                                                            _4200 = floor(_4193 + 0.5f);
                                                                                            _4202 = floor(_4194 + -0.5f);
                                                                                            _4203 = (_4197 < _3892);
                                                                                            _4204 = (_4198 < _3893);
                                                                                            do {
                                                                                              if (!(_4203 || _4204)) {
                                                                                                if ((_4197 >= _3898) || (_4198 >= _3899)) {
                                                                                                  _4213 = _3861;
                                                                                                } else {
                                                                                                  _4213 = _4189.x;
                                                                                                }
                                                                                              } else {
                                                                                                _4213 = _3861;
                                                                                              }
                                                                                              _4214 = (_4200 < _3892);
                                                                                              do {
                                                                                                if (!(_4214 || _4204)) {
                                                                                                  if ((_4200 >= _3898) || (_4198 >= _3899)) {
                                                                                                    _4222 = _3861;
                                                                                                  } else {
                                                                                                    _4222 = _4189.y;
                                                                                                  }
                                                                                                } else {
                                                                                                  _4222 = _3861;
                                                                                                }
                                                                                                _4223 = (_4202 < _3893);
                                                                                                do {
                                                                                                  if (!(_4214 || _4223)) {
                                                                                                    if ((_4200 >= _3898) || (_4202 >= _3899)) {
                                                                                                      _4231 = _3861;
                                                                                                    } else {
                                                                                                      _4231 = _4189.z;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _4231 = _3861;
                                                                                                  }
                                                                                                  do {
                                                                                                    if (!(_4203 || _4223)) {
                                                                                                      if ((_4197 >= _3898) || (_4202 >= _3899)) {
                                                                                                        _4239 = _3861;
                                                                                                      } else {
                                                                                                        _4239 = _4189.w;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _4239 = _3861;
                                                                                                    }
                                                                                                    _4240 = _4213 - _3841;
                                                                                                    _4242 = select((_4240 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4246 = _4222 - _3841;
                                                                                                    _4248 = select((_4246 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4252 = _4231 - _3841;
                                                                                                    _4254 = select((_4252 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4258 = _4239 - _3841;
                                                                                                    _4260 = select((_4258 < 0.0f), 0.0f, 1.0f);
                                                                                                    _4261 = ((((((((((((((_3951 + _3947) + _3957) + _3963) + _4044) + _4050) + _4056) + _4062) + _4143) + _4149) + _4155) + _4161) + _4242) + _4248) + _4254) + _4260;
                                                                                                    _4272 = (saturate(_4261 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                    _4278 = float((int)(((int)(uint)((int)(_4272 > 0.0f))) - ((int)(uint)((int)(_4272 < 0.0f)))));
                                                                                                    _4280 = 1.0f - (_4278 * _4272);
                                                                                                    _4282 = (_4280 * _4280) * _4280;
                                                                                                    _4574 = (0.5f - ((_4278 * 0.5f) * ((1.0f - _4282) - ((_4280 - _4282) * saturate(((1.0f / _3841) * (1.0f / _4261)) * ((((((((((((((((_3951 * _3949) + (_3947 * _3945)) + (_3957 * _3955)) + (_3963 * _3961)) + (_4044 * _4042)) + (_4050 * _4048)) + (_4056 * _4054)) + (_4062 * _4060)) + (_4143 * _4141)) + (_4149 * _4147)) + (_4155 * _4153)) + (_4161 * _4159)) + (_4242 * _4240)) + (_4248 * _4246)) + (_4254 * _4252)) + (_4260 * _4258)))))));
                                                                                                    _4575 = 1.0f;
                                                                                                    _4576 = 1;
                                                                                                  } while (false);
                                                                                                  if (_loop_break_3) break;
                                                                                                } while (false);
                                                                                                if (_loop_break_3) break;
                                                                                              } while (false);
                                                                                              if (_loop_break_3) break;
                                                                                            } while (false);
                                                                                            if (_loop_break_3) break;
                                                                                          } while (false);
                                                                                          if (_loop_break_3) break;
                                                                                        } while (false);
                                                                                        if (_loop_break_3) break;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } else {
                                                                  _4291 = f16tof32(_3648) / _3785;
                                                                  _4294 = mad((_4291 * _3783), 0.5f, 0.5f);
                                                                  _4295 = mad((_4291 * _3784), 0.5f, 0.5f);
                                                                  if (_3772 > -0.0f) {
                                                                    if ((saturate(_4294) == _4294) && (saturate(_4295) == _4295)) {
                                                                      _4309 = (_4294 * _3714) + _3716;
                                                                      _4310 = (_4295 * _3715) + _3717;
                                                                      _4311 = saturate((_3690 + 1.0f) - (_3772 * _3672));
                                                                      _4315 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                        _4324 = RenoDX_ISFASTShadowAngle(
                                                                            uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 3u);
                                                                      } else {
                                                                        _4324 = frac(frac(dot(float2(((_4315 * 32.665000915527344f) + _126), ((_4315 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      }
                                                                      #else
                                                                      _4324 = frac(frac(dot(float2(((_4315 * 32.665000915527344f) + _126), ((_4315 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      #endif
                                                                      _4325 = sin(_4324);
                                                                      _4326 = cos(_4324);
                                                                      _4327 = cbSharedPerViewData.nFrameCounter & 3;
                                                                      _4332 = sqrt((float((int)(_4327)) * 0.25f) + 0.125f) * _3693;
                                                                      _4341 = (_global_7[min((uint)(((int)(0u + (_4327 * 2)))), 127u)]) * _4332;
                                                                      _4342 = (_global_7[min((uint)(((int)(1u + (_4327 * 2)))), 127u)]) * _4332;
                                                                      _4344 = -0.0f - _4325;
                                                                      _4349 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4341, _4342), float2(_4326, _4325)) + _4309), (dot(float2(_4341, _4342), float2(_4344, _4326)) + _4310)));
                                                                      _4354 = _4349.x - _4311;
                                                                      _4356 = select((_4354 < 0.0f), 0.0f, 1.0f);
                                                                      _4358 = _4349.y - _4311;
                                                                      _4360 = select((_4358 < 0.0f), 0.0f, 1.0f);
                                                                      _4364 = _4349.z - _4311;
                                                                      _4366 = select((_4364 < 0.0f), 0.0f, 1.0f);
                                                                      _4370 = _4349.w - _4311;
                                                                      _4372 = select((_4370 < 0.0f), 0.0f, 1.0f);
                                                                      _4379 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                      _4384 = sqrt((float((int)(_4379)) * 0.25f) + 0.125f) * _3693;
                                                                      _4393 = (_global_7[min((uint)(((int)(0u + (_4379 * 2)))), 127u)]) * _4384;
                                                                      _4394 = (_global_7[min((uint)(((int)(1u + (_4379 * 2)))), 127u)]) * _4384;
                                                                      _4400 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4393, _4394), float2(_4326, _4325)) + _4309), (dot(float2(_4393, _4394), float2(_4344, _4326)) + _4310)));
                                                                      _4405 = _4400.x - _4311;
                                                                      _4407 = select((_4405 < 0.0f), 0.0f, 1.0f);
                                                                      _4411 = _4400.y - _4311;
                                                                      _4413 = select((_4411 < 0.0f), 0.0f, 1.0f);
                                                                      _4417 = _4400.z - _4311;
                                                                      _4419 = select((_4417 < 0.0f), 0.0f, 1.0f);
                                                                      _4423 = _4400.w - _4311;
                                                                      _4425 = select((_4423 < 0.0f), 0.0f, 1.0f);
                                                                      _4432 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                      _4437 = sqrt((float((int)(_4432)) * 0.25f) + 0.125f) * _3693;
                                                                      _4446 = (_global_7[min((uint)(((int)(0u + (_4432 * 2)))), 127u)]) * _4437;
                                                                      _4447 = (_global_7[min((uint)(((int)(1u + (_4432 * 2)))), 127u)]) * _4437;
                                                                      _4453 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4446, _4447), float2(_4326, _4325)) + _4309), (dot(float2(_4446, _4447), float2(_4344, _4326)) + _4310)));
                                                                      _4458 = _4453.x - _4311;
                                                                      _4460 = select((_4458 < 0.0f), 0.0f, 1.0f);
                                                                      _4464 = _4453.y - _4311;
                                                                      _4466 = select((_4464 < 0.0f), 0.0f, 1.0f);
                                                                      _4470 = _4453.z - _4311;
                                                                      _4472 = select((_4470 < 0.0f), 0.0f, 1.0f);
                                                                      _4476 = _4453.w - _4311;
                                                                      _4478 = select((_4476 < 0.0f), 0.0f, 1.0f);
                                                                      _4485 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                      _4490 = sqrt((float((int)(_4485)) * 0.25f) + 0.125f) * _3693;
                                                                      _4499 = (_global_7[min((uint)(((int)(0u + (_4485 * 2)))), 127u)]) * _4490;
                                                                      _4500 = (_global_7[min((uint)(((int)(1u + (_4485 * 2)))), 127u)]) * _4490;
                                                                      _4506 = _HeapResource_22.GatherRed(samplerPointClampNode, float2((dot(float2(_4499, _4500), float2(_4326, _4325)) + _4309), (dot(float2(_4499, _4500), float2(_4344, _4326)) + _4310)));
                                                                      _4511 = _4506.x - _4311;
                                                                      _4513 = select((_4511 < 0.0f), 0.0f, 1.0f);
                                                                      _4517 = _4506.y - _4311;
                                                                      _4519 = select((_4517 < 0.0f), 0.0f, 1.0f);
                                                                      _4523 = _4506.z - _4311;
                                                                      _4525 = select((_4523 < 0.0f), 0.0f, 1.0f);
                                                                      _4529 = _4506.w - _4311;
                                                                      _4531 = select((_4529 < 0.0f), 0.0f, 1.0f);
                                                                      _4532 = ((((((((((((((_4356 + _4360) + _4366) + _4372) + _4407) + _4413) + _4419) + _4425) + _4460) + _4466) + _4472) + _4478) + _4513) + _4519) + _4525) + _4531;
                                                                      _4543 = (saturate(_4532 * 0.0625f) * 2.0f) + -1.0f;
                                                                      _4549 = float((int)(((int)(uint)((int)(_4543 > 0.0f))) - ((int)(uint)((int)(_4543 < 0.0f)))));
                                                                      _4551 = 1.0f - (_4549 * _4543);
                                                                      _4553 = (_4551 * _4551) * _4551;
                                                                      _4561 = -0.0f - _3783;
                                                                      _4568 = saturate((saturate(rsqrt(dot(float3(_4561, _3775, _3772), float3(_4561, _3775, _3772))) * _3772) * _3670) + _3669);
                                                                      _4570 = 1.0f - (_4568 * _4568);
                                                                      _4574 = (0.5f - ((_4549 * 0.5f) * ((1.0f - _4553) - ((_4551 - _4553) * saturate(((1.0f / _4311) * (1.0f / _4532)) * ((((((((((((((((_4356 * _4354) + (_4360 * _4358)) + (_4366 * _4364)) + (_4372 * _4370)) + (_4407 * _4405)) + (_4413 * _4411)) + (_4419 * _4417)) + (_4425 * _4423)) + (_4460 * _4458)) + (_4466 * _4464)) + (_4472 * _4470)) + (_4478 * _4476)) + (_4513 * _4511)) + (_4519 * _4517)) + (_4525 * _4523)) + (_4531 * _4529)))))));
                                                                      _4575 = (1.0f - (_4570 * _4570));
                                                                      _4576 = 1;
                                                                    } else {
                                                                      _4574 = 1.0f;
                                                                      _4575 = 1.0f;
                                                                      _4576 = 0;
                                                                    }
                                                                  } else {
                                                                    _4574 = 1.0f;
                                                                    _4575 = 1.0f;
                                                                    _4576 = 0;
                                                                  }
                                                                }
                                                              }
                                                              do {
                                                                _5366 = 1.0f;
                                                                _5367 = 1.0f;
                                                                _5368 = true;
                                                                [branch]
                                                                if (!((_1607 & 512) == 0)) {
                                                                  Texture2D<float4> _HeapResource_23 = ResourceDescriptorHeap[5];
                                                                  [branch]
                                                                  if (!((_1607 & 2097152) == 0)) {
                                                                    _4584 = abs(_3783);
                                                                    _4585 = abs(_3784);
                                                                    _4586 = abs(_3785);
                                                                    do {
                                                                      if (_4584 > max(_4585, _4586)) {
                                                                        _4590 = (_3783 > 0.0f);
                                                                        _4605 = select(_4590, 0.0f, 1.0f);
                                                                        _4606 = 0.0f;
                                                                        _4607 = select(_4590, _3772, _3785);
                                                                        _4608 = _3775;
                                                                        _4609 = _4584;
                                                                      } else {
                                                                        if (_4585 > _4586) {
                                                                          _4596 = (_3775 < -0.0f);
                                                                          _4605 = select(_4596, 0.0f, 1.0f);
                                                                          _4606 = 1.0f;
                                                                          _4607 = _3783;
                                                                          _4608 = select(_4596, _3785, _3772);
                                                                          _4609 = _4585;
                                                                        } else {
                                                                          _4600 = (_3772 < -0.0f);
                                                                          _4605 = select(_4600, 0.0f, 1.0f);
                                                                          _4606 = 2.0f;
                                                                          _4607 = select(_4600, _3783, (-0.0f - _3783));
                                                                          _4608 = _3775;
                                                                          _4609 = _4586;
                                                                        }
                                                                      }
                                                                      _4610 = _4609 * 2.0f;
                                                                      _4615 = -0.0f - _3687;
                                                                      _4624 = ((min(max((_4607 / _4610), _4615), _3687) + _4605) * _3633) + _3635;
                                                                      _4625 = ((min(max((_4608 / _4610), _4615), _3687) + _4606) * _3634) + _3636;
                                                                      _4630 = ((_4605 + -0.5f) * _3633) + _3635;
                                                                      _4631 = ((_4606 + -0.5f) * _3634) + _3636;
                                                                      _4634 = saturate(1.0f - (_4609 * _3672));
                                                                      _4638 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                      #if FIRSTLIGHT_ISFAST_ENABLED
                                                                      if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                        _4647 = RenoDX_ISFASTShadowAngle(
                                                                            uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 4u);
                                                                      } else {
                                                                        _4647 = frac(frac(dot(float2(((_4638 * 32.665000915527344f) + _126), ((_4638 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      }
                                                                      #else
                                                                      _4647 = frac(frac(dot(float2(((_4638 * 32.665000915527344f) + _126), ((_4638 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                      #endif
                                                                      _4648 = sin(_4647);
                                                                      _4649 = cos(_4647);
                                                                      _4654 = select(((((float4)(_HeapResource_23.SampleLevel(samplerPointBorderWhiteNode, float2(_4624, _4625), 0.0f))).x) > _4634), 1.0f, 0.0f);
                                                                      _4655 = cbSharedPerViewData.nFrameCounter & 3;
                                                                      _4660 = sqrt((float((int)(_4655)) * 0.25f) + 0.125f) * _3694;
                                                                      _4669 = (_global_7[min((uint)(((int)(0u + (_4655 * 2)))), 127u)]) * _4660;
                                                                      _4670 = (_global_7[min((uint)(((int)(1u + (_4655 * 2)))), 127u)]) * _4660;
                                                                      _4672 = -0.0f - _4648;
                                                                      _4674 = dot(float2(_4669, _4670), float2(_4649, _4648)) + _4624;
                                                                      _4675 = dot(float2(_4669, _4670), float2(_4672, _4649)) + _4625;
                                                                      _4677 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4674, _4675));
                                                                      _4681 = _4674 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                      _4682 = _4675 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                      _4685 = floor(_4630 * cbSharedPerViewData.vShadowAtlasSize.x);
                                                                      _4686 = floor(_4631 * cbSharedPerViewData.vShadowAtlasSize.y);
                                                                      _4691 = floor(((_4630 + _3633) * cbSharedPerViewData.vShadowAtlasSize.x) + 0.5f);
                                                                      _4692 = floor(((_4631 + _3634) * cbSharedPerViewData.vShadowAtlasSize.y) + 0.5f);
                                                                      _4695 = floor(_4681 + -0.5f);
                                                                      _4696 = floor(_4682 + 0.5f);
                                                                      _4698 = floor(_4681 + 0.5f);
                                                                      _4700 = floor(_4682 + -0.5f);
                                                                      _4701 = (_4695 < _4685);
                                                                      _4702 = (_4696 < _4686);
                                                                      do {
                                                                        if (!(_4701 || _4702)) {
                                                                          if ((_4695 >= _4691) || (_4696 >= _4692)) {
                                                                            _4711 = _4654;
                                                                          } else {
                                                                            _4711 = _4677.x;
                                                                          }
                                                                        } else {
                                                                          _4711 = _4654;
                                                                        }
                                                                        _4712 = (_4698 < _4685);
                                                                        do {
                                                                          if (!(_4712 || _4702)) {
                                                                            if ((_4698 >= _4691) || (_4696 >= _4692)) {
                                                                              _4720 = _4654;
                                                                            } else {
                                                                              _4720 = _4677.y;
                                                                            }
                                                                          } else {
                                                                            _4720 = _4654;
                                                                          }
                                                                          _4721 = (_4700 < _4686);
                                                                          do {
                                                                            if (!(_4712 || _4721)) {
                                                                              if ((_4698 >= _4691) || (_4700 >= _4692)) {
                                                                                _4729 = _4654;
                                                                              } else {
                                                                                _4729 = _4677.z;
                                                                              }
                                                                            } else {
                                                                              _4729 = _4654;
                                                                            }
                                                                            do {
                                                                              if (!(_4701 || _4721)) {
                                                                                if ((_4695 >= _4691) || (_4700 >= _4692)) {
                                                                                  _4737 = _4654;
                                                                                } else {
                                                                                  _4737 = _4677.w;
                                                                                }
                                                                              } else {
                                                                                _4737 = _4654;
                                                                              }
                                                                              _4738 = _4711 - _4634;
                                                                              _4740 = select((_4738 < 0.0f), 0.0f, 1.0f);
                                                                              _4742 = _4720 - _4634;
                                                                              _4744 = select((_4742 < 0.0f), 0.0f, 1.0f);
                                                                              _4748 = _4729 - _4634;
                                                                              _4750 = select((_4748 < 0.0f), 0.0f, 1.0f);
                                                                              _4754 = _4737 - _4634;
                                                                              _4756 = select((_4754 < 0.0f), 0.0f, 1.0f);
                                                                              _4763 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                              _4768 = sqrt((float((int)(_4763)) * 0.25f) + 0.125f) * _3694;
                                                                              _4777 = (_global_7[min((uint)(((int)(0u + (_4763 * 2)))), 127u)]) * _4768;
                                                                              _4778 = (_global_7[min((uint)(((int)(1u + (_4763 * 2)))), 127u)]) * _4768;
                                                                              _4781 = dot(float2(_4777, _4778), float2(_4649, _4648)) + _4624;
                                                                              _4782 = dot(float2(_4777, _4778), float2(_4672, _4649)) + _4625;
                                                                              _4784 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4781, _4782));
                                                                              _4788 = _4781 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                              _4789 = _4782 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                              _4792 = floor(_4788 + -0.5f);
                                                                              _4793 = floor(_4789 + 0.5f);
                                                                              _4795 = floor(_4788 + 0.5f);
                                                                              _4797 = floor(_4789 + -0.5f);
                                                                              _4798 = (_4792 < _4685);
                                                                              _4799 = (_4793 < _4686);
                                                                              do {
                                                                                if (!(_4798 || _4799)) {
                                                                                  if ((_4792 >= _4691) || (_4793 >= _4692)) {
                                                                                    _4808 = _4654;
                                                                                  } else {
                                                                                    _4808 = _4784.x;
                                                                                  }
                                                                                } else {
                                                                                  _4808 = _4654;
                                                                                }
                                                                                _4809 = (_4795 < _4685);
                                                                                do {
                                                                                  if (!(_4809 || _4799)) {
                                                                                    if ((_4795 >= _4691) || (_4793 >= _4692)) {
                                                                                      _4817 = _4654;
                                                                                    } else {
                                                                                      _4817 = _4784.y;
                                                                                    }
                                                                                  } else {
                                                                                    _4817 = _4654;
                                                                                  }
                                                                                  _4818 = (_4797 < _4686);
                                                                                  do {
                                                                                    if (!(_4809 || _4818)) {
                                                                                      if ((_4795 >= _4691) || (_4797 >= _4692)) {
                                                                                        _4826 = _4654;
                                                                                      } else {
                                                                                        _4826 = _4784.z;
                                                                                      }
                                                                                    } else {
                                                                                      _4826 = _4654;
                                                                                    }
                                                                                    do {
                                                                                      if (!(_4798 || _4818)) {
                                                                                        if ((_4792 >= _4691) || (_4797 >= _4692)) {
                                                                                          _4834 = _4654;
                                                                                        } else {
                                                                                          _4834 = _4784.w;
                                                                                        }
                                                                                      } else {
                                                                                        _4834 = _4654;
                                                                                      }
                                                                                      _4835 = _4808 - _4634;
                                                                                      _4837 = select((_4835 < 0.0f), 0.0f, 1.0f);
                                                                                      _4841 = _4817 - _4634;
                                                                                      _4843 = select((_4841 < 0.0f), 0.0f, 1.0f);
                                                                                      _4847 = _4826 - _4634;
                                                                                      _4849 = select((_4847 < 0.0f), 0.0f, 1.0f);
                                                                                      _4853 = _4834 - _4634;
                                                                                      _4855 = select((_4853 < 0.0f), 0.0f, 1.0f);
                                                                                      _4862 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                      _4867 = sqrt((float((int)(_4862)) * 0.25f) + 0.125f) * _3694;
                                                                                      _4876 = (_global_7[min((uint)(((int)(0u + (_4862 * 2)))), 127u)]) * _4867;
                                                                                      _4877 = (_global_7[min((uint)(((int)(1u + (_4862 * 2)))), 127u)]) * _4867;
                                                                                      _4880 = dot(float2(_4876, _4877), float2(_4649, _4648)) + _4624;
                                                                                      _4881 = dot(float2(_4876, _4877), float2(_4672, _4649)) + _4625;
                                                                                      _4883 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4880, _4881));
                                                                                      _4887 = _4880 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                      _4888 = _4881 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                      _4891 = floor(_4887 + -0.5f);
                                                                                      _4892 = floor(_4888 + 0.5f);
                                                                                      _4894 = floor(_4887 + 0.5f);
                                                                                      _4896 = floor(_4888 + -0.5f);
                                                                                      _4897 = (_4891 < _4685);
                                                                                      _4898 = (_4892 < _4686);
                                                                                      do {
                                                                                        if (!(_4897 || _4898)) {
                                                                                          if ((_4891 >= _4691) || (_4892 >= _4692)) {
                                                                                            _4907 = _4654;
                                                                                          } else {
                                                                                            _4907 = _4883.x;
                                                                                          }
                                                                                        } else {
                                                                                          _4907 = _4654;
                                                                                        }
                                                                                        _4908 = (_4894 < _4685);
                                                                                        do {
                                                                                          if (!(_4908 || _4898)) {
                                                                                            if ((_4894 >= _4691) || (_4892 >= _4692)) {
                                                                                              _4916 = _4654;
                                                                                            } else {
                                                                                              _4916 = _4883.y;
                                                                                            }
                                                                                          } else {
                                                                                            _4916 = _4654;
                                                                                          }
                                                                                          _4917 = (_4896 < _4686);
                                                                                          do {
                                                                                            if (!(_4908 || _4917)) {
                                                                                              if ((_4894 >= _4691) || (_4896 >= _4692)) {
                                                                                                _4925 = _4654;
                                                                                              } else {
                                                                                                _4925 = _4883.z;
                                                                                              }
                                                                                            } else {
                                                                                              _4925 = _4654;
                                                                                            }
                                                                                            do {
                                                                                              if (!(_4897 || _4917)) {
                                                                                                if ((_4891 >= _4691) || (_4896 >= _4692)) {
                                                                                                  _4933 = _4654;
                                                                                                } else {
                                                                                                  _4933 = _4883.w;
                                                                                                }
                                                                                              } else {
                                                                                                _4933 = _4654;
                                                                                              }
                                                                                              _4934 = _4907 - _4634;
                                                                                              _4936 = select((_4934 < 0.0f), 0.0f, 1.0f);
                                                                                              _4940 = _4916 - _4634;
                                                                                              _4942 = select((_4940 < 0.0f), 0.0f, 1.0f);
                                                                                              _4946 = _4925 - _4634;
                                                                                              _4948 = select((_4946 < 0.0f), 0.0f, 1.0f);
                                                                                              _4952 = _4933 - _4634;
                                                                                              _4954 = select((_4952 < 0.0f), 0.0f, 1.0f);
                                                                                              _4961 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                              _4966 = sqrt((float((int)(_4961)) * 0.25f) + 0.125f) * _3694;
                                                                                              _4975 = (_global_7[min((uint)(((int)(0u + (_4961 * 2)))), 127u)]) * _4966;
                                                                                              _4976 = (_global_7[min((uint)(((int)(1u + (_4961 * 2)))), 127u)]) * _4966;
                                                                                              _4979 = dot(float2(_4975, _4976), float2(_4649, _4648)) + _4624;
                                                                                              _4980 = dot(float2(_4975, _4976), float2(_4672, _4649)) + _4625;
                                                                                              _4982 = _HeapResource_23.GatherRed(samplerPointClampNode, float2(_4979, _4980));
                                                                                              _4986 = _4979 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                              _4987 = _4980 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                              _4990 = floor(_4986 + -0.5f);
                                                                                              _4991 = floor(_4987 + 0.5f);
                                                                                              _4993 = floor(_4986 + 0.5f);
                                                                                              _4995 = floor(_4987 + -0.5f);
                                                                                              _4996 = (_4990 < _4685);
                                                                                              _4997 = (_4991 < _4686);
                                                                                              do {
                                                                                                if (!(_4996 || _4997)) {
                                                                                                  if ((_4990 >= _4691) || (_4991 >= _4692)) {
                                                                                                    _5006 = _4654;
                                                                                                  } else {
                                                                                                    _5006 = _4982.x;
                                                                                                  }
                                                                                                } else {
                                                                                                  _5006 = _4654;
                                                                                                }
                                                                                                _5007 = (_4993 < _4685);
                                                                                                do {
                                                                                                  if (!(_5007 || _4997)) {
                                                                                                    if ((_4993 >= _4691) || (_4991 >= _4692)) {
                                                                                                      _5015 = _4654;
                                                                                                    } else {
                                                                                                      _5015 = _4982.y;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _5015 = _4654;
                                                                                                  }
                                                                                                  _5016 = (_4995 < _4686);
                                                                                                  do {
                                                                                                    if (!(_5007 || _5016)) {
                                                                                                      if ((_4993 >= _4691) || (_4995 >= _4692)) {
                                                                                                        _5024 = _4654;
                                                                                                      } else {
                                                                                                        _5024 = _4982.z;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _5024 = _4654;
                                                                                                    }
                                                                                                    do {
                                                                                                      if (!(_4996 || _5016)) {
                                                                                                        if ((_4990 >= _4691) || (_4995 >= _4692)) {
                                                                                                          _5032 = _4654;
                                                                                                        } else {
                                                                                                          _5032 = _4982.w;
                                                                                                        }
                                                                                                      } else {
                                                                                                        _5032 = _4654;
                                                                                                      }
                                                                                                      _5033 = _5006 - _4634;
                                                                                                      _5035 = select((_5033 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5039 = _5015 - _4634;
                                                                                                      _5041 = select((_5039 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5045 = _5024 - _4634;
                                                                                                      _5047 = select((_5045 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5051 = _5032 - _4634;
                                                                                                      _5053 = select((_5051 < 0.0f), 0.0f, 1.0f);
                                                                                                      _5054 = ((((((((((((((_4744 + _4740) + _4750) + _4756) + _4837) + _4843) + _4849) + _4855) + _4936) + _4942) + _4948) + _4954) + _5035) + _5041) + _5047) + _5053;
                                                                                                      _5065 = (saturate(_5054 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                      _5071 = float((int)(((int)(uint)((int)(_5065 > 0.0f))) - ((int)(uint)((int)(_5065 < 0.0f)))));
                                                                                                      _5073 = 1.0f - (_5071 * _5065);
                                                                                                      _5075 = (_5073 * _5073) * _5073;
                                                                                                      _5366 = (0.5f - ((_5071 * 0.5f) * ((1.0f - _5075) - ((_5073 - _5075) * saturate(((1.0f / _4634) * (1.0f / _5054)) * ((((((((((((((((_4744 * _4742) + (_4740 * _4738)) + (_4750 * _4748)) + (_4756 * _4754)) + (_4837 * _4835)) + (_4843 * _4841)) + (_4849 * _4847)) + (_4855 * _4853)) + (_4936 * _4934)) + (_4942 * _4940)) + (_4948 * _4946)) + (_4954 * _4952)) + (_5035 * _5033)) + (_5041 * _5039)) + (_5047 * _5045)) + (_5053 * _5051)))))));
                                                                                                      _5367 = 1.0f;
                                                                                                      _5368 = false;
                                                                                                    } while (false);
                                                                                                    if (_loop_break_3) break;
                                                                                                  } while (false);
                                                                                                  if (_loop_break_3) break;
                                                                                                } while (false);
                                                                                                if (_loop_break_3) break;
                                                                                              } while (false);
                                                                                              if (_loop_break_3) break;
                                                                                            } while (false);
                                                                                            if (_loop_break_3) break;
                                                                                          } while (false);
                                                                                          if (_loop_break_3) break;
                                                                                        } while (false);
                                                                                        if (_loop_break_3) break;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } else {
                                                                    _5084 = f16tof32(((uint)((uint)(_3648) >> 16))) / _3785;
                                                                    _5087 = mad((_5084 * _3783), 0.5f, 0.5f);
                                                                    _5088 = mad((_5084 * _3784), 0.5f, 0.5f);
                                                                    if (_3772 > -0.0f) {
                                                                      if ((saturate(_5087) == _5087) && (saturate(_5088) == _5088)) {
                                                                        _5101 = (_5087 * _3633) + _3635;
                                                                        _5102 = (_5088 * _3634) + _3636;
                                                                        _5103 = saturate(1.0f - (_3772 * _3672));
                                                                        _5107 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                        #if FIRSTLIGHT_ISFAST_ENABLED
                                                                        if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                          _5116 = RenoDX_ISFASTShadowAngle(
                                                                              uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 5u);
                                                                        } else {
                                                                          _5116 = frac(frac(dot(float2(((_5107 * 32.665000915527344f) + _126), ((_5107 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                        }
                                                                        #else
                                                                        _5116 = frac(frac(dot(float2(((_5107 * 32.665000915527344f) + _126), ((_5107 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                        #endif
                                                                        _5117 = sin(_5116);
                                                                        _5118 = cos(_5116);
                                                                        _5119 = cbSharedPerViewData.nFrameCounter & 3;
                                                                        _5124 = sqrt((float((int)(_5119)) * 0.25f) + 0.125f) * _3694;
                                                                        _5133 = (_global_7[min((uint)(((int)(0u + (_5119 * 2)))), 127u)]) * _5124;
                                                                        _5134 = (_global_7[min((uint)(((int)(1u + (_5119 * 2)))), 127u)]) * _5124;
                                                                        _5136 = -0.0f - _5117;
                                                                        _5141 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5133, _5134), float2(_5118, _5117)) + _5101), (dot(float2(_5133, _5134), float2(_5136, _5118)) + _5102)));
                                                                        _5146 = _5141.x - _5103;
                                                                        _5148 = select((_5146 < 0.0f), 0.0f, 1.0f);
                                                                        _5150 = _5141.y - _5103;
                                                                        _5152 = select((_5150 < 0.0f), 0.0f, 1.0f);
                                                                        _5156 = _5141.z - _5103;
                                                                        _5158 = select((_5156 < 0.0f), 0.0f, 1.0f);
                                                                        _5162 = _5141.w - _5103;
                                                                        _5164 = select((_5162 < 0.0f), 0.0f, 1.0f);
                                                                        _5171 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                        _5176 = sqrt((float((int)(_5171)) * 0.25f) + 0.125f) * _3694;
                                                                        _5185 = (_global_7[min((uint)(((int)(0u + (_5171 * 2)))), 127u)]) * _5176;
                                                                        _5186 = (_global_7[min((uint)(((int)(1u + (_5171 * 2)))), 127u)]) * _5176;
                                                                        _5192 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5185, _5186), float2(_5118, _5117)) + _5101), (dot(float2(_5185, _5186), float2(_5136, _5118)) + _5102)));
                                                                        _5197 = _5192.x - _5103;
                                                                        _5199 = select((_5197 < 0.0f), 0.0f, 1.0f);
                                                                        _5203 = _5192.y - _5103;
                                                                        _5205 = select((_5203 < 0.0f), 0.0f, 1.0f);
                                                                        _5209 = _5192.z - _5103;
                                                                        _5211 = select((_5209 < 0.0f), 0.0f, 1.0f);
                                                                        _5215 = _5192.w - _5103;
                                                                        _5217 = select((_5215 < 0.0f), 0.0f, 1.0f);
                                                                        _5224 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                        _5229 = sqrt((float((int)(_5224)) * 0.25f) + 0.125f) * _3694;
                                                                        _5238 = (_global_7[min((uint)(((int)(0u + (_5224 * 2)))), 127u)]) * _5229;
                                                                        _5239 = (_global_7[min((uint)(((int)(1u + (_5224 * 2)))), 127u)]) * _5229;
                                                                        _5245 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5238, _5239), float2(_5118, _5117)) + _5101), (dot(float2(_5238, _5239), float2(_5136, _5118)) + _5102)));
                                                                        _5250 = _5245.x - _5103;
                                                                        _5252 = select((_5250 < 0.0f), 0.0f, 1.0f);
                                                                        _5256 = _5245.y - _5103;
                                                                        _5258 = select((_5256 < 0.0f), 0.0f, 1.0f);
                                                                        _5262 = _5245.z - _5103;
                                                                        _5264 = select((_5262 < 0.0f), 0.0f, 1.0f);
                                                                        _5268 = _5245.w - _5103;
                                                                        _5270 = select((_5268 < 0.0f), 0.0f, 1.0f);
                                                                        _5277 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                        _5282 = sqrt((float((int)(_5277)) * 0.25f) + 0.125f) * _3694;
                                                                        _5291 = (_global_7[min((uint)(((int)(0u + (_5277 * 2)))), 127u)]) * _5282;
                                                                        _5292 = (_global_7[min((uint)(((int)(1u + (_5277 * 2)))), 127u)]) * _5282;
                                                                        _5298 = _HeapResource_23.GatherRed(samplerPointClampNode, float2((dot(float2(_5291, _5292), float2(_5118, _5117)) + _5101), (dot(float2(_5291, _5292), float2(_5136, _5118)) + _5102)));
                                                                        _5303 = _5298.x - _5103;
                                                                        _5305 = select((_5303 < 0.0f), 0.0f, 1.0f);
                                                                        _5309 = _5298.y - _5103;
                                                                        _5311 = select((_5309 < 0.0f), 0.0f, 1.0f);
                                                                        _5315 = _5298.z - _5103;
                                                                        _5317 = select((_5315 < 0.0f), 0.0f, 1.0f);
                                                                        _5321 = _5298.w - _5103;
                                                                        _5323 = select((_5321 < 0.0f), 0.0f, 1.0f);
                                                                        _5324 = ((((((((((((((_5148 + _5152) + _5158) + _5164) + _5199) + _5205) + _5211) + _5217) + _5252) + _5258) + _5264) + _5270) + _5305) + _5311) + _5317) + _5323;
                                                                        _5335 = (saturate(_5324 * 0.0625f) * 2.0f) + -1.0f;
                                                                        _5341 = float((int)(((int)(uint)((int)(_5335 > 0.0f))) - ((int)(uint)((int)(_5335 < 0.0f)))));
                                                                        _5343 = 1.0f - (_5341 * _5335);
                                                                        _5345 = (_5343 * _5343) * _5343;
                                                                        _5353 = -0.0f - _3783;
                                                                        _5360 = saturate((saturate(rsqrt(dot(float3(_5353, _3775, _3772), float3(_5353, _3775, _3772))) * _3772) * _3670) + _3669);
                                                                        _5362 = 1.0f - (_5360 * _5360);
                                                                        _5366 = (0.5f - ((_5341 * 0.5f) * ((1.0f - _5345) - ((_5343 - _5345) * saturate(((1.0f / _5103) * (1.0f / _5324)) * ((((((((((((((((_5148 * _5146) + (_5152 * _5150)) + (_5158 * _5156)) + (_5164 * _5162)) + (_5199 * _5197)) + (_5205 * _5203)) + (_5211 * _5209)) + (_5217 * _5215)) + (_5252 * _5250)) + (_5258 * _5256)) + (_5264 * _5262)) + (_5270 * _5268)) + (_5305 * _5303)) + (_5311 * _5309)) + (_5317 * _5315)) + (_5323 * _5321)))))));
                                                                        _5367 = (1.0f - (_5362 * _5362));
                                                                        _5368 = false;
                                                                      } else {
                                                                        _5366 = 1.0f;
                                                                        _5367 = 1.0f;
                                                                        _5368 = true;
                                                                      }
                                                                    } else {
                                                                      _5366 = 1.0f;
                                                                      _5367 = 1.0f;
                                                                      _5368 = true;
                                                                    }
                                                                  }
                                                                }
                                                                do {
                                                                  if (_4576 == 0) {
                                                                    if (!(_5368)) {
                                                                      _5383 = _4574;
                                                                      _5384 = ((_5367 * (_5366 + -1.0f)) + 1.0f);
                                                                      _5385 = 0.0f;
                                                                    } else {
                                                                      _5383 = _4574;
                                                                      _5384 = _5366;
                                                                      _5385 = 0.0f;
                                                                    }
                                                                  } else {
                                                                    if (_5368) {
                                                                      _5383 = ((_4575 * (_4574 + -1.0f)) + 1.0f);
                                                                      _5384 = _5366;
                                                                      _5385 = 1.0f;
                                                                    } else {
                                                                      _5383 = _4574;
                                                                      _5384 = _5366;
                                                                      _5385 = (_4575 * f16tof32(_3618));
                                                                    }
                                                                  }
                                                                  _5388 = (_5385 * (_5383 - _5384)) + _5384;
                                                                  do {
                                                                    _5565 = _5388;
                                                                    [branch]
                                                                    if (!((_1607 & 2048) == 0)) {
                                                                      _5390 = _234 - _3590;
                                                                      _5391 = _235 - _3591;
                                                                      _5392 = _236 - _3592;
                                                                      _5407 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), _5392, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _5391, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _5390)));
                                                                      _5410 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), _5392, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _5391, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _5390)));
                                                                      _5413 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), _5392, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _5391, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _5390)));
                                                                      _5415 = rsqrt(dot(float3(_5407, _5410, _5413), float3(_5407, _5410, _5413)));
                                                                      _5416 = _5415 * _5407;
                                                                      _5417 = _5415 * _5410;
                                                                      _5418 = _5415 * _5413;
                                                                      Texture2D<float> _HeapResource_24 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_3624) >> 16))];
                                                                      _5426 = (abs(_5417) + abs(_5416)) + abs(_5418);
                                                                      _5427 = _5416 / _5426;
                                                                      _5428 = _5417 / _5426;
                                                                      _5430 = !((_5418 / _5426) >= 0.0f);
                                                                      do {
                                                                        _5443 = _5427;
                                                                        _5444 = _5428;
                                                                        if (_5430) {
                                                                          _5443 = ((1.0f - abs(_5428)) * select((_5427 >= 0.0f), 1.0f, -1.0f));
                                                                          _5444 = ((1.0f - abs(_5427)) * select((_5428 >= 0.0f), 1.0f, -1.0f));
                                                                        }
                                                                        _5450 = _HeapResource_24.SampleLevel(samplerLinearClampNode, float2(((_5443 * 0.5f) + 0.5f), ((_5444 * 0.5f) + 0.5f)), 0.0f);
                                                                        if (_5450.x > 0.0f) {
                                                                          Texture2D<float4> _HeapResource_25 = ResourceDescriptorHeap[NonUniformResourceIndex((_3624 & 65535))];
                                                                          do {
                                                                            _5469 = _5427;
                                                                            _5470 = _5428;
                                                                            if (_5430) {
                                                                              _5469 = ((1.0f - abs(_5428)) * select((_5427 >= 0.0f), 1.0f, -1.0f));
                                                                              _5470 = ((1.0f - abs(_5427)) * select((_5428 >= 0.0f), 1.0f, -1.0f));
                                                                            }
                                                                            _5475 = _HeapResource_25.SampleLevel(samplerLinearClampNode, float2(((_5469 * 0.5f) + 0.5f), ((_5470 * 0.5f) + 0.5f)), 0.0f);
                                                                            _5495 = mad(saturate(((log2(sqrt(((_5390 * _5390) + (_5391 * _5391)) + (_5392 * _5392))) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                            _5496 = max(9.999999747378752e-06f, _5450.x);
                                                                            _5497 = _5475.x / _5496;
                                                                            _5498 = _5475.y / _5496;
                                                                            _5500 = _5475.w / _5496;
                                                                            _5505 = ((0.375f - _5498) * 4.999999873689376e-06f) + _5498;
                                                                            _5508 = -0.0f - _5497;
                                                                            _5509 = mad(_5508, _5505, (_5475.z / _5496));
                                                                            _5511 = 1.0f / mad(_5508, _5497, _5505);
                                                                            _5512 = _5511 * _5509;
                                                                            _5517 = _5495 - _5497;
                                                                            _5522 = (((_5495 * _5495) - _5505) - (_5512 * _5517)) / mad((-0.0f - _5509), _5512, mad((-0.0f - _5505), _5505, (((0.375f - _5500) * 4.999999873689376e-06f) + _5500)));
                                                                            _5524 = (_5511 * _5517) - (_5522 * _5512);
                                                                            _5527 = 1.0f / _5522;
                                                                            _5528 = _5524 * _5527;
                                                                            _5533 = sqrt(((_5528 * _5528) * 0.25f) - ((1.0f - dot(float2(_5524, _5522), float2(_5497, _5505))) * _5527));
                                                                            _5535 = (_5528 * -0.5f) - _5533;
                                                                            _5537 = _5533 - (_5528 * 0.5f);
                                                                            _5539 = select((_5535 < _5495), 1.0f, 0.0f);
                                                                            _5544 = (_5539 + -0.05000000074505806f) / (_5535 - _5495);
                                                                            _5550 = (((select((_5537 < _5495), 1.0f, 0.0f) - _5539) / (_5537 - _5535)) - _5544) / (_5537 - _5495);
                                                                            _5552 = _5544 - (_5550 * _5535);
                                                                            _5565 = (exp2((_5450.x * -1.4426950216293335f) * saturate((dot(float2(_5497, _5505), float2((_5552 - (_5550 * _5495)), _5550)) + 0.05000000074505806f) - (_5552 * _5495))) * _5388);
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } else {
                                                                          _5565 = _5388;
                                                                        }
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    }
                                                                    _5568 = (_5565 * _3746);
                                                                    _5569 = _5565;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          }
                                                          do {
                                                            _5589 = _3650;
                                                            _5590 = _3651;
                                                            _5591 = _3653;
                                                            [branch]
                                                            if (!(_3675 == 0)) {
                                                              TextureCube<float3> _HeapResource_26 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _3675)))];
                                                              _5581 = _HeapResource_26.SampleLevel(samplerLinearClampNode, float3((-0.0f - mad(_3725, _3585, mad(_3724, _3580, (_3723 * _3575)))), (-0.0f - mad(_3725, _3586, mad(_3724, _3581, (_3723 * _3576)))), (-0.0f - mad(_3725, _3587, mad(_3724, _3582, (_3723 * _3577))))), 0.0f);
                                                              _5589 = (_5581.x * _3650);
                                                              _5590 = (_5581.y * _3651);
                                                              _5591 = (_5581.z * _3653);
                                                            }
                                                            [branch]
                                                            if (!(_5568 == 0.0f)) {
                                                              do {
                                                                _5609 = GetDeferredSoftShadowChannel(_1610);
                                                                if (_5609 < 0) {
                                                                      _5630 = _5568;
                                                                      do {
                                                                        _8462 = _1595;
                                                                        _8463 = _1596;
                                                                        _8464 = _1597;
                                                                        _8465 = _1598;
                                                                        _8466 = _1599;
                                                                        _8467 = _1600;
                                                                        [branch]
                                                                        if (!(_5630 == 0.0f)) {
                                                                          do {
                                                                            _5737 = _5589;
                                                                            _5738 = _5590;
                                                                            _5739 = _5591;
                                                                            [branch]
                                                                            if (!(((_3627 & 1) == 0) || (!_3777))) {
                                                                              _5647 = max(max(_5589, _5590), _5591);
                                                                              do {
                                                                                _5657 = _5589;
                                                                                _5658 = _5590;
                                                                                _5659 = _5591;
                                                                                if (_5647 > 0.0f) {
                                                                                  _5657 = saturate(_5589 / _5647);
                                                                                  _5658 = saturate(_5590 / _5647);
                                                                                  _5659 = saturate(_5591 / _5647);
                                                                                }
                                                                                _5660 = (_5658 < _5659);
                                                                                _5661 = select(_5660, _5659, _5658);
                                                                                _5662 = select(_5660, _5658, _5659);
                                                                                _5663 = select(_5660, -1.0f, 0.0f);
                                                                                _5664 = (_5657 < _5661);
                                                                                _5666 = select(_5664, _5661, _5657);
                                                                                _5667 = select(_5664, _5657, _5661);
                                                                                _5671 = _5666 - select((_5667 < _5662), _5667, _5662);
                                                                                _5677 = abs(select(_5664, (-0.3333333432674408f - _5663), _5663) + ((_5667 - _5662) / ((_5671 * 6.0f) + 9.999999682655225e-21f)));
                                                                                do {
                                                                                  _5690 = _5677;
                                                                                  if (_5677 < 0.6666666865348816f) {
                                                                                    _5690 = ((saturate(((float)((uint)((uint)(((uint)(_3627) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5677 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5677)) + _5677);
                                                                                  }
                                                                                  _5691 = saturate((_5671 / (_5666 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3627) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                  _5692 = saturate(_5666);
                                                                                  do {
                                                                                    _5719 = _5692;
                                                                                    _5720 = _5692;
                                                                                    _5721 = _5692;
                                                                                    if (!(_5691 <= 0.0f)) {
                                                                                      _5695 = saturate(_5690);
                                                                                      _5699 = select(((_5695 * 360.0f) >= 360.0f), 0.0f, (_5695 * 6.0f));
                                                                                      _5700 = int(_5699);
                                                                                      _5702 = _5699 - float((int)(_5700));
                                                                                      _5704 = _5692 * (1.0f - _5691);
                                                                                      _5707 = (1.0f - (_5702 * _5691)) * _5692;
                                                                                      _5711 = (1.0f - ((1.0f - _5702) * _5691)) * _5692;
                                                                                      switch (_5700) {
                                                                                        case 0: {
                                                                                          _5719 = _5692;
                                                                                          _5720 = _5711;
                                                                                          _5721 = _5704;
                                                                                          break;
                                                                                        }
                                                                                        case 1: {
                                                                                          _5719 = _5707;
                                                                                          _5720 = _5692;
                                                                                          _5721 = _5704;
                                                                                          break;
                                                                                        }
                                                                                        case 2: {
                                                                                          _5719 = _5704;
                                                                                          _5720 = _5692;
                                                                                          _5721 = _5711;
                                                                                          break;
                                                                                        }
                                                                                        case 3: {
                                                                                          _5719 = _5704;
                                                                                          _5720 = _5707;
                                                                                          _5721 = _5692;
                                                                                          break;
                                                                                        }
                                                                                        case 4: {
                                                                                          _5719 = _5711;
                                                                                          _5720 = _5704;
                                                                                          _5721 = _5692;
                                                                                          break;
                                                                                        }
                                                                                        case 5: {
                                                                                          _5719 = _5692;
                                                                                          _5720 = _5704;
                                                                                          _5721 = _5707;
                                                                                          break;
                                                                                        }
                                                                                        default: {
                                                                                          _5719 = 0.0f;
                                                                                          _5720 = 0.0f;
                                                                                          _5721 = 0.0f;
                                                                                          break;
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                    _5722 = _5719 * _5647;
                                                                                    _5723 = _5720 * _5647;
                                                                                    _5724 = _5721 * _5647;
                                                                                    _5726 = saturate(_5569 * 1.0101009607315063f);
                                                                                    _5737 = ((_5726 * (_5589 - _5722)) + _5722);
                                                                                    _5738 = ((_5726 * (_5590 - _5723)) + _5723);
                                                                                    _5739 = (lerp(_5724, _5591, _5726));
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            }
                                                                            do {
                                                                              _5775 = _5630;
                                                                              [branch]
                                                                              if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                                _5746 = srvLightMappingData[_1610];
                                                                                if (!(_5746 == -1)) {
                                                                                  _5751 = srvLightIndexData[_5746].nLayerIndex;
                                                                                  _5753 = srvLightIndexData[_5746].vAtlasOrigin.x;
                                                                                  _5754 = srvLightIndexData[_5746].vAtlasOrigin.y;
                                                                                  _5756 = srvLightIndexData[_5746].vScreenOrigin.x;
                                                                                  _5757 = srvLightIndexData[_5746].vScreenOrigin.y;
                                                                                  _5766 = ((int)(_5751 * 5)) & 31;
                                                                                  _5775 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5753 + _64) - _5756)), ((int)((_5754 + _65) - _5757)), 0)))).x) & ((int)(31 << _5766)))) >> _5766)) >> 1)))) * 0.06666667014360428f) * _5630);
                                                                                } else {
                                                                                  _5775 = _5630;
                                                                                }
                                                                              }
                                                                              _5779 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                              _5782 = select(_5779, (_5775 * _1281), _5775);
                                                                              _5784 = _3729 * _3728;
                                                                              _5785 = _3730 * _3728;
                                                                              _5786 = _3731 * _3728;
                                                                              _5787 = _3661 * _3595;
                                                                              _5788 = _3661 * _3596;
                                                                              _5789 = _3661 * _3597;
                                                                              _5790 = _5784 + _5787;
                                                                              _5791 = _5785 + _5788;
                                                                              _5792 = _5786 + _5789;
                                                                              _5793 = _5784 - _5787;
                                                                              _5794 = _5785 - _5788;
                                                                              _5795 = _5786 - _5789;
                                                                              _5796 = (_3661 > 0.0f);
                                                                              _5797 = dot(float3(_5790, _5791, _5792), float3(_5790, _5791, _5792));
                                                                              _5798 = rsqrt(_5797);
                                                                              do {
                                                                                [branch]
                                                                                if (_5796) {
                                                                                  _5801 = rsqrt(dot(float3(_5793, _5794, _5795), float3(_5793, _5794, _5795)));
                                                                                  _5802 = _5801 * _5798;
                                                                                  _5804 = dot(float3(_5790, _5791, _5792), float3(_5793, _5794, _5795)) * _5802;
                                                                                  _5823 = (_5802 / ((_5802 + 0.5f) + (_5804 * 0.5f)));
                                                                                  _5824 = (((dot(float3(_192, _193, _194), float3(_5793, _5794, _5795)) * _5801) + (dot(float3(_192, _193, _194), float3(_5790, _5791, _5792)) * _5798)) * 0.5f);
                                                                                  _5825 = _5804;
                                                                                } else {
                                                                                  _5823 = (1.0f / (_5797 + 1.0f));
                                                                                  _5824 = dot(float3(_192, _193, _194), float3((_5798 * _5790), (_5798 * _5791), (_5798 * _5792)));
                                                                                  _5825 = 1.0f;
                                                                                }
                                                                                do {
                                                                                  _5841 = _5824;
                                                                                  if (_3663 > 0.0f) {
                                                                                    _5831 = sqrt(saturate((_3663 * _3663) * _5823));
                                                                                    if (_5824 < _5831) {
                                                                                      _5836 = max(_5824, (-0.0f - _5831)) + _5831;
                                                                                      _5841 = ((_5836 * _5836) / (_5831 * 4.0f));
                                                                                    } else {
                                                                                      _5841 = _5824;
                                                                                    }
                                                                                  }
                                                                                  do {
                                                                                    _5901 = _5790;
                                                                                    _5902 = _5791;
                                                                                    _5903 = _5792;
                                                                                    if (_5796) {
                                                                                      _5843 = -0.0f - _452;
                                                                                      _5844 = -0.0f - _453;
                                                                                      _5845 = -0.0f - _451;
                                                                                      _5847 = dot(float3(_5843, _5844, _5845), float3(_192, _193, _194)) * 2.0f;
                                                                                      _5851 = _5843 - (_5847 * _192);
                                                                                      _5852 = _5844 - (_5847 * _193);
                                                                                      _5853 = _5845 - (_5847 * _194);
                                                                                      _5854 = _5793 - _5790;
                                                                                      _5855 = _5794 - _5791;
                                                                                      _5856 = _5795 - _5792;
                                                                                      _5857 = dot(float3(_5851, _5852, _5853), float3(_5854, _5855, _5856));
                                                                                      _5863 = sqrt(((_5854 * _5854) + (_5855 * _5855)) + (_5856 * _5856));
                                                                                      _5872 = saturate(((dot(float3(_5851, _5852, _5853), float3(_5790, _5791, _5792)) * _5857) - dot(float3(_5790, _5791, _5792), float3(_5854, _5855, _5856))) / ((_5863 * _5863) - (_5857 * _5857)));
                                                                                      _5876 = (_5872 * _5854) + _5790;
                                                                                      _5877 = (_5872 * _5855) + _5791;
                                                                                      _5878 = (_5872 * _5856) + _5792;
                                                                                      _5879 = dot(float3(_5876, _5877, _5878), float3(_5851, _5852, _5853));
                                                                                      _5883 = (_5879 * _5851) - _5876;
                                                                                      _5884 = (_5879 * _5852) - _5877;
                                                                                      _5885 = (_5879 * _5853) - _5878;
                                                                                      _5893 = saturate(0.009999999776482582f / sqrt(((_5883 * _5883) + (_5884 * _5884)) + (_5885 * _5885)));
                                                                                      _5901 = ((_5893 * _5883) + _5876);
                                                                                      _5902 = ((_5893 * _5884) + _5877);
                                                                                      _5903 = ((_5893 * _5885) + _5878);
                                                                                    }
                                                                                    _5905 = rsqrt(dot(float3(_5901, _5902, _5903), float3(_5901, _5902, _5903)));
                                                                                    _5906 = _5905 * _5901;
                                                                                    _5907 = _5905 * _5902;
                                                                                    _5908 = _5905 * _5903;
                                                                                    _5909 = _219 * _219;
                                                                                    _5913 = saturate((_3663 * (1.0f - _5909)) * _5905);
                                                                                    _5915 = saturate(_5905 * f16tof32(_3609));
                                                                                    _5917 = rsqrt(dot(float3(_5784, _5785, _5786), float3(_5784, _5785, _5786)));
                                                                                    _5921 = dot(float3(_192, _193, _194), float3(_5906, _5907, _5908));
                                                                                    _5922 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                                                    _5923 = dot(float3(_452, _453, _451), float3(_5906, _5907, _5908));
                                                                                    _5926 = rsqrt((_5923 * 2.0f) + 2.0f);
                                                                                    _5933 = (_5913 > 0.0f);
                                                                                    do {
                                                                                      _6024 = saturate((_5926 * _5923) + _5926);
                                                                                      _6025 = saturate(_5926 * (_5922 + _5921));
                                                                                      if (_5933) {
                                                                                        _5937 = sqrt(1.0f - (_5913 * _5913));
                                                                                        _5939 = (_5921 * 2.0f) * _5922;
                                                                                        _5940 = _5939 - _5923;
                                                                                        if (!(!(_5940 >= _5937))) {
                                                                                          _6024 = abs(_5922);
                                                                                          _6025 = 1.0f;
                                                                                        } else {
                                                                                          _5948 = rsqrt(1.0f - (_5940 * _5940)) * _5913;
                                                                                          _5951 = _5948 * (_5922 - (_5940 * _5921));
                                                                                          _5952 = _5922 * _5922;
                                                                                          _5957 = _5948 * (((_5952 * 2.0f) + -1.0f) - (_5940 * _5923));
                                                                                          _5966 = sqrt(saturate((((1.0f - (_5921 * _5921)) - _5952) - (_5923 * _5923)) + (_5939 * _5923)));
                                                                                          _5967 = _5966 * _5948;
                                                                                          _5970 = ((_5922 * 2.0f) * _5948) * _5966;
                                                                                          _5972 = (_5937 * _5921) + _5922;
                                                                                          _5973 = _5972 + _5951;
                                                                                          _5974 = _5937 * _5923;
                                                                                          _5976 = (_5974 + 1.0f) + _5957;
                                                                                          _5977 = _5967 * _5976;
                                                                                          _5978 = _5973 * _5976;
                                                                                          _5979 = _5970 * _5973;
                                                                                          _5984 = (((_5973 * 0.25f) * _5970) - (_5977 * 0.5f)) * _5978;
                                                                                          _5998 = (((_5979 - (_5977 * 2.0f)) * _5979) + (_5977 * _5977)) + ((((-0.5f - ((_5976 + _5974) * 0.5f)) * _5978) + ((_5976 * _5976) * _5972)) * _5973);
                                                                                          _6003 = (_5984 * 2.0f) / ((_5998 * _5998) + (_5984 * _5984));
                                                                                          _6004 = _5998 * _6003;
                                                                                          _6006 = 1.0f - (_5984 * _6003);
                                                                                          _6012 = ((_6004 * _5970) + _5974) + (_6006 * _5957);
                                                                                          _6015 = rsqrt((_6012 * 2.0f) + 2.0f);
                                                                                          _6024 = saturate((_6012 * _6015) + _6015);
                                                                                          _6025 = saturate(((_5972 + (_6004 * _5967)) + (_6006 * _5951)) * _6015);
                                                                                        }
                                                                                      }
                                                                                      _6026 = saturate(_5841);
                                                                                      _6028 = _5909 * _5909;
                                                                                      do {
                                                                                        _6038 = _6028;
                                                                                        if (_5915 > 0.0f) {
                                                                                          _6038 = saturate(((_5915 * _5915) / ((_6024 * 3.5999999046325684f) + 0.4000000059604645f)) + _6028);
                                                                                        }
                                                                                        do {
                                                                                          _6050 = _6038;
                                                                                          _6051 = 1.0f;
                                                                                          if (_5933) {
                                                                                            _6047 = (((_5913 * 0.25f) * ((sqrt(_6038) * 3.0f) + _5913)) / (_6024 + 0.0010000000474974513f)) + _6038;
                                                                                            _6050 = _6047;
                                                                                            _6051 = (_6038 / _6047);
                                                                                          }
                                                                                          do {
                                                                                            _6071 = _6051;
                                                                                            if (_5825 < 1.0f) {
                                                                                              _6058 = sqrt((1.000100016593933f - _5825) / max(9.999999974752427e-07f, (_5825 + 1.0f)));
                                                                                              _6071 = (sqrt(_6050 / ((((_6058 * 0.25f) * ((sqrt(_6050) * 3.0f) + _6058)) / (_6024 + 0.0010000000474974513f)) + _6050)) * _6051);
                                                                                            }
                                                                                            _6075 = (((_6038 * _6025) - _6025) * _6025) + 1.0f;
                                                                                            _6082 = exp2(log2(1.0f - saturate(_6024)) * 5.0f);
                                                                                            _6085 = saturate(abs(_5922) + 9.999999747378752e-06f);
                                                                                            _6086 = sqrt(_6038);
                                                                                            _6087 = 1.0f - _6086;
                                                                                            _6099 = saturate((dot(float3(_192, _193, _194), float3((_5917 * _5784), (_5917 * _5785), (_5917 * _5786))) + _3660) / (_3660 + 1.0f));
                                                                                            _6102 = ((_6071 * _6026) * (_6038 / (_6075 * _6075))) * (0.5f / ((((_6087 * _6085) + _6086) * _6026) + (((_6087 * _6026) + _6086) * _6085)));
                                                                                            _6103 = _5737 * _1658;
                                                                                            _6104 = _5738 * _1658;
                                                                                            _6105 = _5739 * _1658;
                                                                                            _6112 = ((_5782 * _6103) * _6099) + _1595;
                                                                                            _6113 = ((_5782 * _6104) * _6099) + _1596;
                                                                                            _6114 = ((_5782 * _6105) * _6099) + _1597;
                                                                                            if (_3657 > 0.0f) {
                                                                                              _6127 = (_3657 * _1354) * select(_5779, (_5775 * _1281), _5775);
                                                                                              _8462 = _6112;
                                                                                              _8463 = _6113;
                                                                                              _8464 = _6114;
                                                                                              _8465 = (((((_6103 * _1144) * _6127) * ((_6082 * (1.0f - _211)) + _211)) * _6102) + _1598);
                                                                                              _8466 = (((((_6104 * _1145) * _6127) * ((_6082 * (1.0f - _212)) + _212)) * _6102) + _1599);
                                                                                              _8467 = (((((_6105 * _1146) * _6127) * ((_6082 * (1.0f - _213)) + _213)) * _6102) + _1600);
                                                                                            } else {
                                                                                              _8462 = _6112;
                                                                                              _8463 = _6113;
                                                                                              _8464 = _6114;
                                                                                              _8465 = _1598;
                                                                                              _8466 = _1599;
                                                                                              _8467 = _1600;
                                                                                            }
                                                                                          } while (false);
                                                                                          if (_loop_break_3) break;
                                                                                        } while (false);
                                                                                        if (_loop_break_3) break;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        }
                                                                        break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                  // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                                  break;
                                                                }
                                                                _5612 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_64, _65, 0));
                                                                do {
                                                                  if (_5609 == 0) {
                                                                    _5626 = _5612.x;
                                                                  } else {
                                                                    if (_5609 == 1) {
                                                                      _5626 = _5612.y;
                                                                    } else {
                                                                      if (_5609 == 2) {
                                                                        _5626 = _5612.z;
                                                                      } else {
                                                                        _5626 = _5612.w;
                                                                      }
                                                                    }
                                                                  }
                                                                  _5630 = ((_5626 * _5626) * _3746);
                                                                  [branch]
                                                                  if (!(_5630 == 0.0f)) {
                                                                    do {
                                                                      _5737 = _5589;
                                                                      _5738 = _5590;
                                                                      _5739 = _5591;
                                                                      [branch]
                                                                      if (!(((_3627 & 1) == 0) || (!_3777))) {
                                                                        _5647 = max(max(_5589, _5590), _5591);
                                                                        do {
                                                                          _5657 = _5589;
                                                                          _5658 = _5590;
                                                                          _5659 = _5591;
                                                                          if (_5647 > 0.0f) {
                                                                            _5657 = saturate(_5589 / _5647);
                                                                            _5658 = saturate(_5590 / _5647);
                                                                            _5659 = saturate(_5591 / _5647);
                                                                          }
                                                                          _5660 = (_5658 < _5659);
                                                                          _5661 = select(_5660, _5659, _5658);
                                                                          _5662 = select(_5660, _5658, _5659);
                                                                          _5663 = select(_5660, -1.0f, 0.0f);
                                                                          _5664 = (_5657 < _5661);
                                                                          _5666 = select(_5664, _5661, _5657);
                                                                          _5667 = select(_5664, _5657, _5661);
                                                                          _5671 = _5666 - select((_5667 < _5662), _5667, _5662);
                                                                          _5677 = abs(select(_5664, (-0.3333333432674408f - _5663), _5663) + ((_5667 - _5662) / ((_5671 * 6.0f) + 9.999999682655225e-21f)));
                                                                          do {
                                                                            _5690 = _5677;
                                                                            if (_5677 < 0.6666666865348816f) {
                                                                              _5690 = ((saturate(((float)((uint)((uint)(((uint)(_3627) >> 9) & 255)))) * 0.003921499941498041f) * (select((_5677 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _5677)) + _5677);
                                                                            }
                                                                            _5691 = saturate((_5671 / (_5666 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_3627) >> 1) & 255)))) * 0.003921499941498041f));
                                                                            _5692 = saturate(_5666);
                                                                            do {
                                                                              _5719 = _5692;
                                                                              _5720 = _5692;
                                                                              _5721 = _5692;
                                                                              if (!(_5691 <= 0.0f)) {
                                                                                _5695 = saturate(_5690);
                                                                                _5699 = select(((_5695 * 360.0f) >= 360.0f), 0.0f, (_5695 * 6.0f));
                                                                                _5700 = int(_5699);
                                                                                _5702 = _5699 - float((int)(_5700));
                                                                                _5704 = _5692 * (1.0f - _5691);
                                                                                _5707 = (1.0f - (_5702 * _5691)) * _5692;
                                                                                _5711 = (1.0f - ((1.0f - _5702) * _5691)) * _5692;
                                                                                switch (_5700) {
                                                                                  case 0: {
                                                                                    _5719 = _5692;
                                                                                    _5720 = _5711;
                                                                                    _5721 = _5704;
                                                                                    break;
                                                                                  }
                                                                                  case 1: {
                                                                                    _5719 = _5707;
                                                                                    _5720 = _5692;
                                                                                    _5721 = _5704;
                                                                                    break;
                                                                                  }
                                                                                  case 2: {
                                                                                    _5719 = _5704;
                                                                                    _5720 = _5692;
                                                                                    _5721 = _5711;
                                                                                    break;
                                                                                  }
                                                                                  case 3: {
                                                                                    _5719 = _5704;
                                                                                    _5720 = _5707;
                                                                                    _5721 = _5692;
                                                                                    break;
                                                                                  }
                                                                                  case 4: {
                                                                                    _5719 = _5711;
                                                                                    _5720 = _5704;
                                                                                    _5721 = _5692;
                                                                                    break;
                                                                                  }
                                                                                  case 5: {
                                                                                    _5719 = _5692;
                                                                                    _5720 = _5704;
                                                                                    _5721 = _5707;
                                                                                    break;
                                                                                  }
                                                                                  default: {
                                                                                    _5719 = 0.0f;
                                                                                    _5720 = 0.0f;
                                                                                    _5721 = 0.0f;
                                                                                    break;
                                                                                  }
                                                                                }
                                                                              }
                                                                              _5722 = _5719 * _5647;
                                                                              _5723 = _5720 * _5647;
                                                                              _5724 = _5721 * _5647;
                                                                              _5726 = saturate(_5569 * 1.0101009607315063f);
                                                                              _5737 = ((_5726 * (_5589 - _5722)) + _5722);
                                                                              _5738 = ((_5726 * (_5590 - _5723)) + _5723);
                                                                              _5739 = (lerp(_5724, _5591, _5726));
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      }
                                                                      do {
                                                                        _5775 = _5630;
                                                                        [branch]
                                                                        if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                          _5746 = srvLightMappingData[_1610];
                                                                          if (!(_5746 == -1)) {
                                                                            _5751 = srvLightIndexData[_5746].nLayerIndex;
                                                                            _5753 = srvLightIndexData[_5746].vAtlasOrigin.x;
                                                                            _5754 = srvLightIndexData[_5746].vAtlasOrigin.y;
                                                                            _5756 = srvLightIndexData[_5746].vScreenOrigin.x;
                                                                            _5757 = srvLightIndexData[_5746].vScreenOrigin.y;
                                                                            _5766 = ((int)(_5751 * 5)) & 31;
                                                                            _5775 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_5753 + _64) - _5756)), ((int)((_5754 + _65) - _5757)), 0)))).x) & ((int)(31 << _5766)))) >> _5766)) >> 1)))) * 0.06666667014360428f) * _5630);
                                                                          } else {
                                                                            _5775 = _5630;
                                                                          }
                                                                        }
                                                                        _5779 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                        _5782 = select(_5779, (_5775 * _1281), _5775);
                                                                        _5784 = _3729 * _3728;
                                                                        _5785 = _3730 * _3728;
                                                                        _5786 = _3731 * _3728;
                                                                        _5787 = _3661 * _3595;
                                                                        _5788 = _3661 * _3596;
                                                                        _5789 = _3661 * _3597;
                                                                        _5790 = _5784 + _5787;
                                                                        _5791 = _5785 + _5788;
                                                                        _5792 = _5786 + _5789;
                                                                        _5793 = _5784 - _5787;
                                                                        _5794 = _5785 - _5788;
                                                                        _5795 = _5786 - _5789;
                                                                        _5796 = (_3661 > 0.0f);
                                                                        _5797 = dot(float3(_5790, _5791, _5792), float3(_5790, _5791, _5792));
                                                                        _5798 = rsqrt(_5797);
                                                                        do {
                                                                          [branch]
                                                                          if (_5796) {
                                                                            _5801 = rsqrt(dot(float3(_5793, _5794, _5795), float3(_5793, _5794, _5795)));
                                                                            _5802 = _5801 * _5798;
                                                                            _5804 = dot(float3(_5790, _5791, _5792), float3(_5793, _5794, _5795)) * _5802;
                                                                            _5823 = (_5802 / ((_5802 + 0.5f) + (_5804 * 0.5f)));
                                                                            _5824 = (((dot(float3(_192, _193, _194), float3(_5793, _5794, _5795)) * _5801) + (dot(float3(_192, _193, _194), float3(_5790, _5791, _5792)) * _5798)) * 0.5f);
                                                                            _5825 = _5804;
                                                                          } else {
                                                                            _5823 = (1.0f / (_5797 + 1.0f));
                                                                            _5824 = dot(float3(_192, _193, _194), float3((_5798 * _5790), (_5798 * _5791), (_5798 * _5792)));
                                                                            _5825 = 1.0f;
                                                                          }
                                                                          do {
                                                                            _5841 = _5824;
                                                                            if (_3663 > 0.0f) {
                                                                              _5831 = sqrt(saturate((_3663 * _3663) * _5823));
                                                                              if (_5824 < _5831) {
                                                                                _5836 = max(_5824, (-0.0f - _5831)) + _5831;
                                                                                _5841 = ((_5836 * _5836) / (_5831 * 4.0f));
                                                                              } else {
                                                                                _5841 = _5824;
                                                                              }
                                                                            }
                                                                            do {
                                                                              _5901 = _5790;
                                                                              _5902 = _5791;
                                                                              _5903 = _5792;
                                                                              if (_5796) {
                                                                                _5843 = -0.0f - _452;
                                                                                _5844 = -0.0f - _453;
                                                                                _5845 = -0.0f - _451;
                                                                                _5847 = dot(float3(_5843, _5844, _5845), float3(_192, _193, _194)) * 2.0f;
                                                                                _5851 = _5843 - (_5847 * _192);
                                                                                _5852 = _5844 - (_5847 * _193);
                                                                                _5853 = _5845 - (_5847 * _194);
                                                                                _5854 = _5793 - _5790;
                                                                                _5855 = _5794 - _5791;
                                                                                _5856 = _5795 - _5792;
                                                                                _5857 = dot(float3(_5851, _5852, _5853), float3(_5854, _5855, _5856));
                                                                                _5863 = sqrt(((_5854 * _5854) + (_5855 * _5855)) + (_5856 * _5856));
                                                                                _5872 = saturate(((dot(float3(_5851, _5852, _5853), float3(_5790, _5791, _5792)) * _5857) - dot(float3(_5790, _5791, _5792), float3(_5854, _5855, _5856))) / ((_5863 * _5863) - (_5857 * _5857)));
                                                                                _5876 = (_5872 * _5854) + _5790;
                                                                                _5877 = (_5872 * _5855) + _5791;
                                                                                _5878 = (_5872 * _5856) + _5792;
                                                                                _5879 = dot(float3(_5876, _5877, _5878), float3(_5851, _5852, _5853));
                                                                                _5883 = (_5879 * _5851) - _5876;
                                                                                _5884 = (_5879 * _5852) - _5877;
                                                                                _5885 = (_5879 * _5853) - _5878;
                                                                                _5893 = saturate(0.009999999776482582f / sqrt(((_5883 * _5883) + (_5884 * _5884)) + (_5885 * _5885)));
                                                                                _5901 = ((_5893 * _5883) + _5876);
                                                                                _5902 = ((_5893 * _5884) + _5877);
                                                                                _5903 = ((_5893 * _5885) + _5878);
                                                                              }
                                                                              _5905 = rsqrt(dot(float3(_5901, _5902, _5903), float3(_5901, _5902, _5903)));
                                                                              _5906 = _5905 * _5901;
                                                                              _5907 = _5905 * _5902;
                                                                              _5908 = _5905 * _5903;
                                                                              _5909 = _219 * _219;
                                                                              _5913 = saturate((_3663 * (1.0f - _5909)) * _5905);
                                                                              _5915 = saturate(_5905 * f16tof32(_3609));
                                                                              _5917 = rsqrt(dot(float3(_5784, _5785, _5786), float3(_5784, _5785, _5786)));
                                                                              _5921 = dot(float3(_192, _193, _194), float3(_5906, _5907, _5908));
                                                                              _5922 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                                              _5923 = dot(float3(_452, _453, _451), float3(_5906, _5907, _5908));
                                                                              _5926 = rsqrt((_5923 * 2.0f) + 2.0f);
                                                                              _5933 = (_5913 > 0.0f);
                                                                              do {
                                                                                _6024 = saturate((_5926 * _5923) + _5926);
                                                                                _6025 = saturate(_5926 * (_5922 + _5921));
                                                                                if (_5933) {
                                                                                  _5937 = sqrt(1.0f - (_5913 * _5913));
                                                                                  _5939 = (_5921 * 2.0f) * _5922;
                                                                                  _5940 = _5939 - _5923;
                                                                                  if (!(!(_5940 >= _5937))) {
                                                                                    _6024 = abs(_5922);
                                                                                    _6025 = 1.0f;
                                                                                  } else {
                                                                                    _5948 = rsqrt(1.0f - (_5940 * _5940)) * _5913;
                                                                                    _5951 = _5948 * (_5922 - (_5940 * _5921));
                                                                                    _5952 = _5922 * _5922;
                                                                                    _5957 = _5948 * (((_5952 * 2.0f) + -1.0f) - (_5940 * _5923));
                                                                                    _5966 = sqrt(saturate((((1.0f - (_5921 * _5921)) - _5952) - (_5923 * _5923)) + (_5939 * _5923)));
                                                                                    _5967 = _5966 * _5948;
                                                                                    _5970 = ((_5922 * 2.0f) * _5948) * _5966;
                                                                                    _5972 = (_5937 * _5921) + _5922;
                                                                                    _5973 = _5972 + _5951;
                                                                                    _5974 = _5937 * _5923;
                                                                                    _5976 = (_5974 + 1.0f) + _5957;
                                                                                    _5977 = _5967 * _5976;
                                                                                    _5978 = _5973 * _5976;
                                                                                    _5979 = _5970 * _5973;
                                                                                    _5984 = (((_5973 * 0.25f) * _5970) - (_5977 * 0.5f)) * _5978;
                                                                                    _5998 = (((_5979 - (_5977 * 2.0f)) * _5979) + (_5977 * _5977)) + ((((-0.5f - ((_5976 + _5974) * 0.5f)) * _5978) + ((_5976 * _5976) * _5972)) * _5973);
                                                                                    _6003 = (_5984 * 2.0f) / ((_5998 * _5998) + (_5984 * _5984));
                                                                                    _6004 = _5998 * _6003;
                                                                                    _6006 = 1.0f - (_5984 * _6003);
                                                                                    _6012 = ((_6004 * _5970) + _5974) + (_6006 * _5957);
                                                                                    _6015 = rsqrt((_6012 * 2.0f) + 2.0f);
                                                                                    _6024 = saturate((_6012 * _6015) + _6015);
                                                                                    _6025 = saturate(((_5972 + (_6004 * _5967)) + (_6006 * _5951)) * _6015);
                                                                                  }
                                                                                }
                                                                                _6026 = saturate(_5841);
                                                                                _6028 = _5909 * _5909;
                                                                                do {
                                                                                  _6038 = _6028;
                                                                                  if (_5915 > 0.0f) {
                                                                                    _6038 = saturate(((_5915 * _5915) / ((_6024 * 3.5999999046325684f) + 0.4000000059604645f)) + _6028);
                                                                                  }
                                                                                  do {
                                                                                    _6050 = _6038;
                                                                                    _6051 = 1.0f;
                                                                                    if (_5933) {
                                                                                      _6047 = (((_5913 * 0.25f) * ((sqrt(_6038) * 3.0f) + _5913)) / (_6024 + 0.0010000000474974513f)) + _6038;
                                                                                      _6050 = _6047;
                                                                                      _6051 = (_6038 / _6047);
                                                                                    }
                                                                                    do {
                                                                                      _6071 = _6051;
                                                                                      if (_5825 < 1.0f) {
                                                                                        _6058 = sqrt((1.000100016593933f - _5825) / max(9.999999974752427e-07f, (_5825 + 1.0f)));
                                                                                        _6071 = (sqrt(_6050 / ((((_6058 * 0.25f) * ((sqrt(_6050) * 3.0f) + _6058)) / (_6024 + 0.0010000000474974513f)) + _6050)) * _6051);
                                                                                      }
                                                                                      _6075 = (((_6038 * _6025) - _6025) * _6025) + 1.0f;
                                                                                      _6082 = exp2(log2(1.0f - saturate(_6024)) * 5.0f);
                                                                                      _6085 = saturate(abs(_5922) + 9.999999747378752e-06f);
                                                                                      _6086 = sqrt(_6038);
                                                                                      _6087 = 1.0f - _6086;
                                                                                      _6099 = saturate((dot(float3(_192, _193, _194), float3((_5917 * _5784), (_5917 * _5785), (_5917 * _5786))) + _3660) / (_3660 + 1.0f));
                                                                                      _6102 = ((_6071 * _6026) * (_6038 / (_6075 * _6075))) * (0.5f / ((((_6087 * _6085) + _6086) * _6026) + (((_6087 * _6026) + _6086) * _6085)));
                                                                                      _6103 = _5737 * _1658;
                                                                                      _6104 = _5738 * _1658;
                                                                                      _6105 = _5739 * _1658;
                                                                                      _6112 = ((_5782 * _6103) * _6099) + _1595;
                                                                                      _6113 = ((_5782 * _6104) * _6099) + _1596;
                                                                                      _6114 = ((_5782 * _6105) * _6099) + _1597;
                                                                                      if (_3657 > 0.0f) {
                                                                                        _6127 = (_3657 * _1354) * select(_5779, (_5775 * _1281), _5775);
                                                                                        _8462 = _6112;
                                                                                        _8463 = _6113;
                                                                                        _8464 = _6114;
                                                                                        _8465 = (((((_6103 * _1144) * _6127) * ((_6082 * (1.0f - _211)) + _211)) * _6102) + _1598);
                                                                                        _8466 = (((((_6104 * _1145) * _6127) * ((_6082 * (1.0f - _212)) + _212)) * _6102) + _1599);
                                                                                        _8467 = (((((_6105 * _1146) * _6127) * ((_6082 * (1.0f - _213)) + _213)) * _6102) + _1600);
                                                                                      } else {
                                                                                        _8462 = _6112;
                                                                                        _8463 = _6113;
                                                                                        _8464 = _6114;
                                                                                        _8465 = _1598;
                                                                                        _8466 = _1599;
                                                                                        _8467 = _1600;
                                                                                      }
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } else {
                                                                    _8462 = _1595;
                                                                    _8463 = _1596;
                                                                    _8464 = _1597;
                                                                    _8465 = _1598;
                                                                    _8466 = _1599;
                                                                    _8467 = _1600;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } else {
                                                              _8462 = _1595;
                                                              _8463 = _1596;
                                                              _8464 = _1597;
                                                              _8465 = _1598;
                                                              _8466 = _1599;
                                                              _8467 = _1600;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } while (false);
                                                        if (_loop_break_3) break;
                                                      } while (false);
                                                      if (_loop_break_3) break;
                                                    } else {
                                                      if (_1641 == 8) {
                                                        _6148 = asfloat(srvLightInfoProperties.Load3(_1609)).x;
                                                        _6149 = asfloat(srvLightInfoProperties.Load3(_1609)).y;
                                                        _6150 = asfloat(srvLightInfoProperties.Load3(_1609)).z;
                                                        _6153 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 12u)))).x;
                                                        _6154 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 12u)))).y;
                                                        _6155 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 12u)))).z;
                                                        _6158 = asfloat(srvLightInfoProperties.Load(((int)(_1609 + 24u))));
                                                        _6161 = asint(srvLightInfoProperties.Load(((int)(_1609 + 28u))));
                                                        _6164 = asint(srvLightInfoProperties.Load(((int)(_1609 + 32u))));
                                                        _6167 = asint(srvLightInfoProperties.Load(((int)(_1609 + 44u))));
                                                        _6176 = ((float)((uint)((uint)(((uint)(_6164) >> 8) & 255)))) * 0.003921499941498041f;
                                                        _6179 = ((float)((uint)((uint)(_6164 & 255)))) * 0.003921499941498041f;
                                                        _6182 = f16tof32(_6167);
                                                        _6189 = min(max(dot(float3((_234 - _6148), (_235 - _6149), (_236 - _6150)), float3(_6153, _6154, _6155)), (-0.0f - _6158)), _6158);
                                                        _6194 = (_6148 - _234) + (_6189 * _6153);
                                                        _6196 = (_6149 - _235) + (_6189 * _6154);
                                                        _6198 = (_6150 + _233) + (_6189 * _6155);
                                                        _6199 = dot(float3(_6194, _6196, _6198), float3(_6194, _6196, _6198));
                                                        _6200 = rsqrt(_6199);
                                                        _6202 = _6194 * _6200;
                                                        _6203 = _6196 * _6200;
                                                        _6204 = _6198 * _6200;
                                                        _6207 = max(0.0f, ((_6200 * _6199) - abs(_6182)));
                                                        _6208 = _6207 * f16tof32(((uint)((uint)(_6167) >> 16)));
                                                        _6209 = _6208 * _6208;
                                                        _6212 = saturate(1.0f - (_6209 * _6209));
                                                        _6219 = (_6212 * _6212) / (select((_6182 < 0.0f), (_6209 * 16.0f), (_6207 * _6207)) + 1.0f);
                                                        [branch]
                                                        if (!(_6219 == 0.0f)) {
                                                          do {
                                                            _6257 = _6219;
                                                            [branch]
                                                            if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                              _6228 = srvLightMappingData[_1610];
                                                              if (!(_6228 == -1)) {
                                                                _6233 = srvLightIndexData[_6228].nLayerIndex;
                                                                _6235 = srvLightIndexData[_6228].vAtlasOrigin.x;
                                                                _6236 = srvLightIndexData[_6228].vAtlasOrigin.y;
                                                                _6238 = srvLightIndexData[_6228].vScreenOrigin.x;
                                                                _6239 = srvLightIndexData[_6228].vScreenOrigin.y;
                                                                _6248 = ((int)(_6233 * 5)) & 31;
                                                                _6257 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_6235 + _64) - _6238)), ((int)((_6236 + _65) - _6239)), 0)))).x) & ((int)(31 << _6248)))) >> _6248)) >> 1)))) * 0.06666667014360428f) * _6219);
                                                              } else {
                                                                _6257 = _6219;
                                                              }
                                                            }
                                                            _6261 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                            _6263 = select(_6261, (_6257 * _1281), _6257);
                                                            _6264 = dot(float3(_192, _193, _194), float3(_6202, _6203, _6204));
                                                            _6265 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                            _6266 = dot(float3(_452, _453, _451), float3(_6202, _6203, _6204));
                                                            _6269 = rsqrt((_6266 * 2.0f) + 2.0f);
                                                            _6272 = saturate(_6269 * (_6265 + _6264));
                                                            _6276 = saturate(_6264);
                                                            _6277 = _219 * _219;
                                                            _6278 = _6277 * _6277;
                                                            _6282 = (((_6272 * _6278) - _6272) * _6272) + 1.0f;
                                                            _6289 = exp2(log2(1.0f - saturate(saturate((_6269 * _6266) + _6269))) * 5.0f);
                                                            _6292 = saturate(abs(_6265) + 9.999999747378752e-06f);
                                                            _6293 = sqrt(_6278);
                                                            _6294 = 1.0f - _6293;
                                                            _6306 = saturate((_6264 + _6179) / (_6179 + 1.0f));
                                                            _6308 = ((_6278 / (_6282 * _6282)) * _6276) * (0.5f / ((((_6294 * _6292) + _6293) * _6276) + (((_6294 * _6276) + _6293) * _6292)));
                                                            _6309 = f16tof32(((uint)((uint)(_6161) >> 16))) * _1658;
                                                            _6310 = f16tof32(_6161) * _1658;
                                                            _6311 = f16tof32(((uint)((uint)(_6164) >> 16))) * _1658;
                                                            _6318 = ((_6263 * _6309) * _6306) + _1595;
                                                            _6319 = ((_6263 * _6310) * _6306) + _1596;
                                                            _6320 = ((_6263 * _6311) * _6306) + _1597;
                                                            if (_6176 > 0.0f) {
                                                              _6335 = (_6176 * _1354) * select(_6261, (_6257 * _1281), _6257);
                                                              _8462 = _6318;
                                                              _8463 = _6319;
                                                              _8464 = _6320;
                                                              _8465 = (((((_6309 * _1144) * _6335) * ((_6289 * (1.0f - _211)) + _211)) * _6308) + _1598);
                                                              _8466 = (((((_6310 * _1145) * _6335) * ((_6289 * (1.0f - _212)) + _212)) * _6308) + _1599);
                                                              _8467 = (((((_6311 * _1146) * _6335) * ((_6289 * (1.0f - _213)) + _213)) * _6308) + _1600);
                                                            } else {
                                                              _8462 = _6318;
                                                              _8463 = _6319;
                                                              _8464 = _6320;
                                                              _8465 = _1598;
                                                              _8466 = _1599;
                                                              _8467 = _1600;
                                                            }
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          _8462 = _1595;
                                                          _8463 = _1596;
                                                          _8464 = _1597;
                                                          _8465 = _1598;
                                                          _8466 = _1599;
                                                          _8467 = _1600;
                                                        }
                                                      } else {
                                                        if (_1641 == 9) {
                                                          _6356 = asfloat(srvLightInfoProperties.Load4(_1609)).x;
                                                          _6357 = asfloat(srvLightInfoProperties.Load4(_1609)).y;
                                                          _6358 = asfloat(srvLightInfoProperties.Load4(_1609)).w;
                                                          _6361 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).x;
                                                          _6362 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).y;
                                                          _6363 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).w;
                                                          _6366 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).x;
                                                          _6367 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).y;
                                                          _6368 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).w;
                                                          _6371 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 48u)))).x;
                                                          _6372 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 48u)))).y;
                                                          _6373 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 48u)))).w;
                                                          _6376 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 64u)))).x;
                                                          _6377 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 64u)))).y;
                                                          _6378 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 64u)))).z;
                                                          _6381 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 76u)))).x;
                                                          _6382 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 76u)))).y;
                                                          _6383 = asfloat(srvLightInfoProperties.Load3(((int)(_1609 + 76u)))).z;
                                                          _6386 = asint(srvLightInfoProperties.Load(((int)(_1609 + 88u))));
                                                          _6389 = asint(srvLightInfoProperties.Load(((int)(_1609 + 92u))));
                                                          _6392 = asint(srvLightInfoProperties.Load(((int)(_1609 + 100u))));
                                                          _6395 = asint(srvLightInfoProperties.Load(((int)(_1609 + 104u))));
                                                          _6398 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).x;
                                                          _6399 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).y;
                                                          _6400 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).z;
                                                          _6401 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 108u)))).w;
                                                          _6404 = asint(srvLightInfoProperties.Load(((int)(_1609 + 124u))));
                                                          _6407 = asint(srvLightInfoProperties.Load(((int)(_1609 + 128u))));
                                                          _6410 = asint(srvLightInfoProperties.Load(((int)(_1609 + 132u))));
                                                          _6413 = asint(srvLightInfoProperties.Load(((int)(_1609 + 136u))));
                                                          _6416 = asint(srvLightInfoProperties.Load(((int)(_1609 + 140u))));
                                                          _6419 = asint(srvLightInfoProperties.Load(((int)(_1609 + 144u))));
                                                          _6422 = asint(srvLightInfoProperties.Load(((int)(_1609 + 148u))));
                                                          _6425 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 152u)))).x;
                                                          _6426 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 152u)))).y;
                                                          _6427 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 152u)))).z;
                                                          _6428 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 152u)))).w;
                                                          _6431 = asint(srvLightInfoProperties.Load(((int)(_1609 + 168u))));
                                                          _6434 = asint(srvLightInfoProperties.Load(((int)(_1609 + 172u))));
                                                          _6437 = asint(srvLightInfoProperties.Load(((int)(_1609 + 180u))));
                                                          _6439 = f16tof32(((uint)((uint)(_6386) >> 16)));
                                                          _6440 = f16tof32(_6386);
                                                          _6442 = f16tof32(((uint)((uint)(_6389) >> 16)));
                                                          _6446 = ((float)((uint)((uint)(((uint)(_6389) >> 8) & 255)))) * 0.003921499941498041f;
                                                          _6449 = ((float)((uint)((uint)(_6389 & 255)))) * 0.003921499941498041f;
                                                          _6450 = f16tof32(_6392);
                                                          _6452 = f16tof32(((uint)((uint)(_6395) >> 16)));
                                                          _6456 = f16tof32(_6404);
                                                          _6460 = _6410 & 65535;
                                                          _6476 = f16tof32(((uint)((uint)(_6434) >> 16)));
                                                          _6477 = f16tof32(_6434);
                                                          _6479 = f16tof32(((uint)((uint)(_6437) >> 16)));
                                                          _6480 = 1.0f / _6479;
                                                          _6481 = _6479 + -1.0f;
                                                          _6482 = f16tof32(_6437);
                                                          _6483 = _6376 - _234;
                                                          _6484 = _6377 - _235;
                                                          _6485 = _6378 + _233;
                                                          _6486 = dot(float3(_6483, _6484, _6485), float3(_6483, _6484, _6485));
                                                          _6487 = rsqrt(_6486);
                                                          _6488 = _6487 * _6486;
                                                          _6489 = _6487 * _6483;
                                                          _6490 = _6487 * _6484;
                                                          _6491 = _6487 * _6485;
                                                          _6494 = max(0.0f, (_6488 - abs(_6456)));
                                                          _6495 = _6494 * f16tof32(((uint)((uint)(_6404) >> 16)));
                                                          _6496 = _6495 * _6495;
                                                          _6499 = saturate(1.0f - (_6496 * _6496));
                                                          _6510 = mad(_236, _6368, mad(_235, _6363, (_6358 * _234))) + _6373;
                                                          _6514 = saturate(1.0f - dot(float3(_192, _193, _194), float3(_6489, _6490, _6491))) * f16tof32(_6431);
                                                          _6521 = ((_6510 * _192) * _6514) + _234;
                                                          _6522 = ((_6510 * _193) * _6514) + _235;
                                                          _6523 = ((_6510 * _194) * _6514) - _233;
                                                          _6535 = mad(_6523, _6368, mad(_6522, _6363, (_6521 * _6358))) + _6373;
                                                          _6536 = 1.0f / _6535;
                                                          _6537 = _6536 * (mad(_6523, _6366, mad(_6522, _6361, (_6521 * _6356))) + _6371);
                                                          _6538 = _6536 * (mad(_6523, _6367, mad(_6522, _6362, (_6521 * _6357))) + _6372);
                                                          _6541 = (_6537 * _6398) + _6399;
                                                          _6542 = (_6538 * _6398) + _6399;
                                                          _6545 = _6541 - saturate(_6541);
                                                          _6546 = _6542 - saturate(_6542);
                                                          _6553 = saturate((sqrt((_6545 * _6545) + (_6546 * _6546)) * _6400) + _6401);
                                                          _6555 = 1.0f - (_6553 * _6553);
                                                          _6561 = (_6555 * _6555) * (((float)((bool)(uint)((_6535 - f16tof32(((uint)((uint)(_6407) >> 16)))) > 0.0f))) * ((_6499 * _6499) / (select((_6456 < 0.0f), (_6496 * 16.0f), (_6494 * _6494)) + 1.0f)));
                                                          _6563 = ((_1607 & 3584) == 0);
                                                          do {
                                                            _7404 = 0.0f;
                                                            _7405 = 1.0f;
                                                            if (!((!(_6561 > 0.0f)) || _6563)) {
                                                              _6571 = 1.0f - saturate(f16tof32(_6407) * _6535);
                                                              _6572 = saturate(_6537);
                                                              _6573 = saturate(_6538);
                                                              do {
                                                                _6836 = 1.0f;
                                                                _6837 = 0.0f;
                                                                _6838 = _6571;
                                                                [branch]
                                                                if (!((_1607 & 1024) == 0)) {
                                                                  _6578 = ((_6572 * _6481) + 0.5f) * _6480;
                                                                  _6580 = ((_6573 * _6481) + 0.5f) * _6480;
                                                                  _6581 = _6571 + f16tof32(((uint)((uint)(_6431) >> 16)));
                                                                  Texture2D<float4> _HeapResource_27 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6410) >> 16))];
                                                                  _6584 = saturate(_6581);
                                                                  _6588 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                  #if FIRSTLIGHT_ISFAST_ENABLED
                                                                  if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                    _6597 = RenoDX_ISFASTShadowAngle(
                                                                        uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 6u);
                                                                  } else {
                                                                    _6597 = frac(frac(dot(float2(((_6588 * 32.665000915527344f) + _126), ((_6588 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  }
                                                                  #else
                                                                  _6597 = frac(frac(dot(float2(((_6588 * 32.665000915527344f) + _126), ((_6588 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                  #endif
                                                                  _6598 = sin(_6597);
                                                                  _6599 = cos(_6597);
                                                                  _6600 = cbSharedPerViewData.nFrameCounter & 3;
                                                                  _6605 = sqrt((float((int)(_6600)) * 0.25f) + 0.125f) * _6476;
                                                                  _6614 = (_global_7[min((uint)(((int)(0u + (_6600 * 2)))), 127u)]) * _6605;
                                                                  _6615 = (_global_7[min((uint)(((int)(1u + (_6600 * 2)))), 127u)]) * _6605;
                                                                  _6617 = -0.0f - _6598;
                                                                  _6622 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6614, _6615), float2(_6599, _6598)) + _6578), (dot(float2(_6614, _6615), float2(_6617, _6599)) + _6580)));
                                                                  _6627 = _6622.x - _6584;
                                                                  _6629 = select((_6627 < 0.0f), 0.0f, 1.0f);
                                                                  _6631 = _6622.y - _6584;
                                                                  _6633 = select((_6631 < 0.0f), 0.0f, 1.0f);
                                                                  _6637 = _6622.z - _6584;
                                                                  _6639 = select((_6637 < 0.0f), 0.0f, 1.0f);
                                                                  _6643 = _6622.w - _6584;
                                                                  _6645 = select((_6643 < 0.0f), 0.0f, 1.0f);
                                                                  _6652 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                  _6657 = sqrt((float((int)(_6652)) * 0.25f) + 0.125f) * _6476;
                                                                  _6666 = (_global_7[min((uint)(((int)(0u + (_6652 * 2)))), 127u)]) * _6657;
                                                                  _6667 = (_global_7[min((uint)(((int)(1u + (_6652 * 2)))), 127u)]) * _6657;
                                                                  _6673 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6666, _6667), float2(_6599, _6598)) + _6578), (dot(float2(_6666, _6667), float2(_6617, _6599)) + _6580)));
                                                                  _6678 = _6673.x - _6584;
                                                                  _6680 = select((_6678 < 0.0f), 0.0f, 1.0f);
                                                                  _6684 = _6673.y - _6584;
                                                                  _6686 = select((_6684 < 0.0f), 0.0f, 1.0f);
                                                                  _6690 = _6673.z - _6584;
                                                                  _6692 = select((_6690 < 0.0f), 0.0f, 1.0f);
                                                                  _6696 = _6673.w - _6584;
                                                                  _6698 = select((_6696 < 0.0f), 0.0f, 1.0f);
                                                                  _6705 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                  _6710 = sqrt((float((int)(_6705)) * 0.25f) + 0.125f) * _6476;
                                                                  _6719 = (_global_7[min((uint)(((int)(0u + (_6705 * 2)))), 127u)]) * _6710;
                                                                  _6720 = (_global_7[min((uint)(((int)(1u + (_6705 * 2)))), 127u)]) * _6710;
                                                                  _6726 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6719, _6720), float2(_6599, _6598)) + _6578), (dot(float2(_6719, _6720), float2(_6617, _6599)) + _6580)));
                                                                  _6731 = _6726.x - _6584;
                                                                  _6733 = select((_6731 < 0.0f), 0.0f, 1.0f);
                                                                  _6737 = _6726.y - _6584;
                                                                  _6739 = select((_6737 < 0.0f), 0.0f, 1.0f);
                                                                  _6743 = _6726.z - _6584;
                                                                  _6745 = select((_6743 < 0.0f), 0.0f, 1.0f);
                                                                  _6749 = _6726.w - _6584;
                                                                  _6751 = select((_6749 < 0.0f), 0.0f, 1.0f);
                                                                  _6758 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                  _6763 = sqrt((float((int)(_6758)) * 0.25f) + 0.125f) * _6476;
                                                                  _6772 = (_global_7[min((uint)(((int)(0u + (_6758 * 2)))), 127u)]) * _6763;
                                                                  _6773 = (_global_7[min((uint)(((int)(1u + (_6758 * 2)))), 127u)]) * _6763;
                                                                  _6779 = _HeapResource_27.GatherRed(samplerPointClampNode, float2((dot(float2(_6772, _6773), float2(_6599, _6598)) + _6578), (dot(float2(_6772, _6773), float2(_6617, _6599)) + _6580)));
                                                                  _6784 = _6779.x - _6584;
                                                                  _6786 = select((_6784 < 0.0f), 0.0f, 1.0f);
                                                                  _6790 = _6779.y - _6584;
                                                                  _6792 = select((_6790 < 0.0f), 0.0f, 1.0f);
                                                                  _6796 = _6779.z - _6584;
                                                                  _6798 = select((_6796 < 0.0f), 0.0f, 1.0f);
                                                                  _6802 = _6779.w - _6584;
                                                                  _6804 = select((_6802 < 0.0f), 0.0f, 1.0f);
                                                                  _6805 = ((((((((((((((_6629 + _6633) + _6639) + _6645) + _6680) + _6686) + _6692) + _6698) + _6733) + _6739) + _6745) + _6751) + _6786) + _6792) + _6798) + _6804;
                                                                  _6816 = (saturate(_6805 * 0.0625f) * 2.0f) + -1.0f;
                                                                  _6822 = float((int)(((int)(uint)((int)(_6816 > 0.0f))) - ((int)(uint)((int)(_6816 < 0.0f)))));
                                                                  _6824 = 1.0f - (_6822 * _6816);
                                                                  _6826 = (_6824 * _6824) * _6824;
                                                                  _6833 = 0.5f - ((_6822 * 0.5f) * ((1.0f - _6826) - ((_6824 - _6826) * saturate(((1.0f / _6584) * (1.0f / _6805)) * ((((((((((((((((_6629 * _6627) + (_6633 * _6631)) + (_6639 * _6637)) + (_6645 * _6643)) + (_6680 * _6678)) + (_6686 * _6684)) + (_6692 * _6690)) + (_6698 * _6696)) + (_6733 * _6731)) + (_6739 * _6737)) + (_6745 * _6743)) + (_6751 * _6749)) + (_6786 * _6784)) + (_6792 * _6790)) + (_6798 * _6796)) + (_6804 * _6802))))));
                                                                  [branch]
                                                                  if (!(_6482 < 1.0f)) {
                                                                    _7306 = _6482;
                                                                    _7307 = _6833;
                                                                    do {
                                                                      _7404 = _7306;
                                                                      _7405 = _7307;
                                                                      [branch]
                                                                      if (!((_1607 & 2048) == 0)) {
                                                                        Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6413) >> 16))];
                                                                        _7313 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6537, _6538), 0.0f);
                                                                        if (_7313.x > 0.0f) {
                                                                          Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6413 & 65535))];
                                                                          _7320 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6537, _6538), 0.0f);
                                                                          _7334 = mad(saturate(((log2(_6488) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                          _7335 = max(9.999999747378752e-06f, _7313.x);
                                                                          _7336 = _7320.x / _7335;
                                                                          _7337 = _7320.y / _7335;
                                                                          _7339 = _7320.w / _7335;
                                                                          _7344 = ((0.375f - _7337) * 4.999999873689376e-06f) + _7337;
                                                                          _7347 = -0.0f - _7336;
                                                                          _7348 = mad(_7347, _7344, (_7320.z / _7335));
                                                                          _7350 = 1.0f / mad(_7347, _7336, _7344);
                                                                          _7351 = _7350 * _7348;
                                                                          _7356 = _7334 - _7336;
                                                                          _7361 = (((_7334 * _7334) - _7344) - (_7351 * _7356)) / mad((-0.0f - _7348), _7351, mad((-0.0f - _7344), _7344, (((0.375f - _7339) * 4.999999873689376e-06f) + _7339)));
                                                                          _7363 = (_7350 * _7356) - (_7361 * _7351);
                                                                          _7366 = 1.0f / _7361;
                                                                          _7367 = _7363 * _7366;
                                                                          _7372 = sqrt(((_7367 * _7367) * 0.25f) - ((1.0f - dot(float2(_7363, _7361), float2(_7336, _7344))) * _7366));
                                                                          _7374 = (_7367 * -0.5f) - _7372;
                                                                          _7376 = _7372 - (_7367 * 0.5f);
                                                                          _7378 = select((_7374 < _7334), 1.0f, 0.0f);
                                                                          _7383 = (_7378 + -0.05000000074505806f) / (_7374 - _7334);
                                                                          _7389 = (((select((_7376 < _7334), 1.0f, 0.0f) - _7378) / (_7376 - _7374)) - _7383) / (_7376 - _7334);
                                                                          _7391 = _7383 - (_7389 * _7374);
                                                                          _7404 = _7306;
                                                                          _7405 = (exp2((_7313.x * -1.4426950216293335f) * saturate((dot(float2(_7336, _7344), float2((_7391 - (_7389 * _7334)), _7389)) + 0.05000000074505806f) - (_7391 * _7334))) * _7307);
                                                                        } else {
                                                                          _7404 = _7306;
                                                                          _7405 = _7307;
                                                                        }
                                                                      }
                                                                      break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                    // Native completed depth-gather shadow bypasses the fallback path.
                                                                    break;
                                                                  } else {
                                                                    _6836 = _6833;
                                                                    _6837 = _6482;
                                                                    _6838 = _6581;
                                                                  }
                                                                }
                                                                _6841 = (_6572 * _6425) + _6427;
                                                                _6842 = (_6573 * _6426) + _6428;
                                                                do {
                                                                  _7301 = 1.0f;
                                                                  if (!((_1607 & 512) == 0)) {
                                                                    Texture2D<float4> _HeapResource_28 = ResourceDescriptorHeap[5];
                                                                    _6851 = saturate(_6838);
                                                                    _6855 = (float)((uint)((uint)(cbSharedPerViewData.nFrameCounter & 15)));
                                                                    #if FIRSTLIGHT_ISFAST_ENABLED
                                                                    if (CUSTOM_ISFAST_SHADOWS > 0.5f) {
                                                                      _6864 = RenoDX_ISFASTShadowAngle(
                                                                          uint2(_64, _65), cbSharedPerViewData.nFrameCounter, 7u);
                                                                    } else {
                                                                      _6864 = frac(frac(dot(float2(((_6855 * 32.665000915527344f) + _126), ((_6855 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    }
                                                                    #else
                                                                    _6864 = frac(frac(dot(float2(((_6855 * 32.665000915527344f) + _126), ((_6855 * 11.8149995803833f) + _127)), float2(0.0671105608344078f, 0.005837149918079376f))) * 52.98291778564453f) * 6.2831854820251465f;
                                                                    #endif
                                                                    _6865 = sin(_6864);
                                                                    _6866 = cos(_6864);
                                                                    _6871 = select(((((float4)(_HeapResource_28.SampleLevel(samplerPointBorderWhiteNode, float2(_6841, _6842), 0.0f))).x) > _6851), 1.0f, 0.0f);
                                                                    _6872 = cbSharedPerViewData.nFrameCounter & 3;
                                                                    _6877 = sqrt((float((int)(_6872)) * 0.25f) + 0.125f) * _6477;
                                                                    _6886 = (_global_7[min((uint)(((int)(0u + (_6872 * 2)))), 127u)]) * _6877;
                                                                    _6887 = (_global_7[min((uint)(((int)(1u + (_6872 * 2)))), 127u)]) * _6877;
                                                                    _6889 = -0.0f - _6865;
                                                                    _6891 = dot(float2(_6886, _6887), float2(_6866, _6865)) + _6841;
                                                                    _6892 = dot(float2(_6886, _6887), float2(_6889, _6866)) + _6842;
                                                                    _6894 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6891, _6892));
                                                                    _6898 = _6891 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                    _6899 = _6892 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                    _6902 = floor(cbSharedPerViewData.vShadowAtlasSize.x * _6427);
                                                                    _6903 = floor(cbSharedPerViewData.vShadowAtlasSize.y * _6428);
                                                                    _6908 = floor((cbSharedPerViewData.vShadowAtlasSize.x * (_6425 + _6427)) + 0.5f);
                                                                    _6909 = floor((cbSharedPerViewData.vShadowAtlasSize.y * (_6426 + _6428)) + 0.5f);
                                                                    _6912 = floor(_6898 + -0.5f);
                                                                    _6913 = floor(_6899 + 0.5f);
                                                                    _6915 = floor(_6898 + 0.5f);
                                                                    _6917 = floor(_6899 + -0.5f);
                                                                    _6918 = (_6912 < _6902);
                                                                    _6919 = (_6913 < _6903);
                                                                    do {
                                                                      if (!(_6918 || _6919)) {
                                                                        if ((_6912 >= _6908) || (_6913 >= _6909)) {
                                                                          _6928 = _6871;
                                                                        } else {
                                                                          _6928 = _6894.x;
                                                                        }
                                                                      } else {
                                                                        _6928 = _6871;
                                                                      }
                                                                      _6929 = (_6915 < _6902);
                                                                      do {
                                                                        if (!(_6929 || _6919)) {
                                                                          if ((_6915 >= _6908) || (_6913 >= _6909)) {
                                                                            _6937 = _6871;
                                                                          } else {
                                                                            _6937 = _6894.y;
                                                                          }
                                                                        } else {
                                                                          _6937 = _6871;
                                                                        }
                                                                        _6938 = (_6917 < _6903);
                                                                        do {
                                                                          if (!(_6929 || _6938)) {
                                                                            if ((_6915 >= _6908) || (_6917 >= _6909)) {
                                                                              _6946 = _6871;
                                                                            } else {
                                                                              _6946 = _6894.z;
                                                                            }
                                                                          } else {
                                                                            _6946 = _6871;
                                                                          }
                                                                          do {
                                                                            if (!(_6918 || _6938)) {
                                                                              if ((_6912 >= _6908) || (_6917 >= _6909)) {
                                                                                _6954 = _6871;
                                                                              } else {
                                                                                _6954 = _6894.w;
                                                                              }
                                                                            } else {
                                                                              _6954 = _6871;
                                                                            }
                                                                            _6955 = _6928 - _6851;
                                                                            _6957 = select((_6955 < 0.0f), 0.0f, 1.0f);
                                                                            _6959 = _6937 - _6851;
                                                                            _6961 = select((_6959 < 0.0f), 0.0f, 1.0f);
                                                                            _6965 = _6946 - _6851;
                                                                            _6967 = select((_6965 < 0.0f), 0.0f, 1.0f);
                                                                            _6971 = _6954 - _6851;
                                                                            _6973 = select((_6971 < 0.0f), 0.0f, 1.0f);
                                                                            _6980 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 1u)) & 3;
                                                                            _6985 = sqrt((float((int)(_6980)) * 0.25f) + 0.125f) * _6477;
                                                                            _6994 = (_global_7[min((uint)(((int)(0u + (_6980 * 2)))), 127u)]) * _6985;
                                                                            _6995 = (_global_7[min((uint)(((int)(1u + (_6980 * 2)))), 127u)]) * _6985;
                                                                            _6998 = dot(float2(_6994, _6995), float2(_6866, _6865)) + _6841;
                                                                            _6999 = dot(float2(_6994, _6995), float2(_6889, _6866)) + _6842;
                                                                            _7001 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_6998, _6999));
                                                                            _7005 = _6998 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                            _7006 = _6999 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                            _7009 = floor(_7005 + -0.5f);
                                                                            _7010 = floor(_7006 + 0.5f);
                                                                            _7012 = floor(_7005 + 0.5f);
                                                                            _7014 = floor(_7006 + -0.5f);
                                                                            _7015 = (_7009 < _6902);
                                                                            _7016 = (_7010 < _6903);
                                                                            do {
                                                                              if (!(_7015 || _7016)) {
                                                                                if ((_7009 >= _6908) || (_7010 >= _6909)) {
                                                                                  _7025 = _6871;
                                                                                } else {
                                                                                  _7025 = _7001.x;
                                                                                }
                                                                              } else {
                                                                                _7025 = _6871;
                                                                              }
                                                                              _7026 = (_7012 < _6902);
                                                                              do {
                                                                                if (!(_7026 || _7016)) {
                                                                                  if ((_7012 >= _6908) || (_7010 >= _6909)) {
                                                                                    _7034 = _6871;
                                                                                  } else {
                                                                                    _7034 = _7001.y;
                                                                                  }
                                                                                } else {
                                                                                  _7034 = _6871;
                                                                                }
                                                                                _7035 = (_7014 < _6903);
                                                                                do {
                                                                                  if (!(_7026 || _7035)) {
                                                                                    if ((_7012 >= _6908) || (_7014 >= _6909)) {
                                                                                      _7043 = _6871;
                                                                                    } else {
                                                                                      _7043 = _7001.z;
                                                                                    }
                                                                                  } else {
                                                                                    _7043 = _6871;
                                                                                  }
                                                                                  do {
                                                                                    if (!(_7015 || _7035)) {
                                                                                      if ((_7009 >= _6908) || (_7014 >= _6909)) {
                                                                                        _7051 = _6871;
                                                                                      } else {
                                                                                        _7051 = _7001.w;
                                                                                      }
                                                                                    } else {
                                                                                      _7051 = _6871;
                                                                                    }
                                                                                    _7052 = _7025 - _6851;
                                                                                    _7054 = select((_7052 < 0.0f), 0.0f, 1.0f);
                                                                                    _7058 = _7034 - _6851;
                                                                                    _7060 = select((_7058 < 0.0f), 0.0f, 1.0f);
                                                                                    _7064 = _7043 - _6851;
                                                                                    _7066 = select((_7064 < 0.0f), 0.0f, 1.0f);
                                                                                    _7070 = _7051 - _6851;
                                                                                    _7072 = select((_7070 < 0.0f), 0.0f, 1.0f);
                                                                                    _7079 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 2u)) & 3;
                                                                                    _7084 = sqrt((float((int)(_7079)) * 0.25f) + 0.125f) * _6477;
                                                                                    _7093 = (_global_7[min((uint)(((int)(0u + (_7079 * 2)))), 127u)]) * _7084;
                                                                                    _7094 = (_global_7[min((uint)(((int)(1u + (_7079 * 2)))), 127u)]) * _7084;
                                                                                    _7097 = dot(float2(_7093, _7094), float2(_6866, _6865)) + _6841;
                                                                                    _7098 = dot(float2(_7093, _7094), float2(_6889, _6866)) + _6842;
                                                                                    _7100 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7097, _7098));
                                                                                    _7104 = _7097 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                    _7105 = _7098 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                    _7108 = floor(_7104 + -0.5f);
                                                                                    _7109 = floor(_7105 + 0.5f);
                                                                                    _7111 = floor(_7104 + 0.5f);
                                                                                    _7113 = floor(_7105 + -0.5f);
                                                                                    _7114 = (_7108 < _6902);
                                                                                    _7115 = (_7109 < _6903);
                                                                                    do {
                                                                                      if (!(_7114 || _7115)) {
                                                                                        if ((_7108 >= _6908) || (_7109 >= _6909)) {
                                                                                          _7124 = _6871;
                                                                                        } else {
                                                                                          _7124 = _7100.x;
                                                                                        }
                                                                                      } else {
                                                                                        _7124 = _6871;
                                                                                      }
                                                                                      _7125 = (_7111 < _6902);
                                                                                      do {
                                                                                        if (!(_7125 || _7115)) {
                                                                                          if ((_7111 >= _6908) || (_7109 >= _6909)) {
                                                                                            _7133 = _6871;
                                                                                          } else {
                                                                                            _7133 = _7100.y;
                                                                                          }
                                                                                        } else {
                                                                                          _7133 = _6871;
                                                                                        }
                                                                                        _7134 = (_7113 < _6903);
                                                                                        do {
                                                                                          if (!(_7125 || _7134)) {
                                                                                            if ((_7111 >= _6908) || (_7113 >= _6909)) {
                                                                                              _7142 = _6871;
                                                                                            } else {
                                                                                              _7142 = _7100.z;
                                                                                            }
                                                                                          } else {
                                                                                            _7142 = _6871;
                                                                                          }
                                                                                          do {
                                                                                            if (!(_7114 || _7134)) {
                                                                                              if ((_7108 >= _6908) || (_7113 >= _6909)) {
                                                                                                _7150 = _6871;
                                                                                              } else {
                                                                                                _7150 = _7100.w;
                                                                                              }
                                                                                            } else {
                                                                                              _7150 = _6871;
                                                                                            }
                                                                                            _7151 = _7124 - _6851;
                                                                                            _7153 = select((_7151 < 0.0f), 0.0f, 1.0f);
                                                                                            _7157 = _7133 - _6851;
                                                                                            _7159 = select((_7157 < 0.0f), 0.0f, 1.0f);
                                                                                            _7163 = _7142 - _6851;
                                                                                            _7165 = select((_7163 < 0.0f), 0.0f, 1.0f);
                                                                                            _7169 = _7150 - _6851;
                                                                                            _7171 = select((_7169 < 0.0f), 0.0f, 1.0f);
                                                                                            _7178 = ((int)((uint)(cbSharedPerViewData.nFrameCounter) + 3u)) & 3;
                                                                                            _7183 = sqrt((float((int)(_7178)) * 0.25f) + 0.125f) * _6477;
                                                                                            _7192 = (_global_7[min((uint)(((int)(0u + (_7178 * 2)))), 127u)]) * _7183;
                                                                                            _7193 = (_global_7[min((uint)(((int)(1u + (_7178 * 2)))), 127u)]) * _7183;
                                                                                            _7196 = dot(float2(_7192, _7193), float2(_6866, _6865)) + _6841;
                                                                                            _7197 = dot(float2(_7192, _7193), float2(_6889, _6866)) + _6842;
                                                                                            _7199 = _HeapResource_28.GatherRed(samplerPointClampNode, float2(_7196, _7197));
                                                                                            _7203 = _7196 * cbSharedPerViewData.vShadowAtlasSize.x;
                                                                                            _7204 = _7197 * cbSharedPerViewData.vShadowAtlasSize.y;
                                                                                            _7207 = floor(_7203 + -0.5f);
                                                                                            _7208 = floor(_7204 + 0.5f);
                                                                                            _7210 = floor(_7203 + 0.5f);
                                                                                            _7212 = floor(_7204 + -0.5f);
                                                                                            _7213 = (_7207 < _6902);
                                                                                            _7214 = (_7208 < _6903);
                                                                                            do {
                                                                                              if (!(_7213 || _7214)) {
                                                                                                if ((_7207 >= _6908) || (_7208 >= _6909)) {
                                                                                                  _7223 = _6871;
                                                                                                } else {
                                                                                                  _7223 = _7199.x;
                                                                                                }
                                                                                              } else {
                                                                                                _7223 = _6871;
                                                                                              }
                                                                                              _7224 = (_7210 < _6902);
                                                                                              do {
                                                                                                if (!(_7224 || _7214)) {
                                                                                                  if ((_7210 >= _6908) || (_7208 >= _6909)) {
                                                                                                    _7232 = _6871;
                                                                                                  } else {
                                                                                                    _7232 = _7199.y;
                                                                                                  }
                                                                                                } else {
                                                                                                  _7232 = _6871;
                                                                                                }
                                                                                                _7233 = (_7212 < _6903);
                                                                                                do {
                                                                                                  if (!(_7224 || _7233)) {
                                                                                                    if ((_7210 >= _6908) || (_7212 >= _6909)) {
                                                                                                      _7241 = _6871;
                                                                                                    } else {
                                                                                                      _7241 = _7199.z;
                                                                                                    }
                                                                                                  } else {
                                                                                                    _7241 = _6871;
                                                                                                  }
                                                                                                  do {
                                                                                                    if (!(_7213 || _7233)) {
                                                                                                      if ((_7207 >= _6908) || (_7212 >= _6909)) {
                                                                                                        _7249 = _6871;
                                                                                                      } else {
                                                                                                        _7249 = _7199.w;
                                                                                                      }
                                                                                                    } else {
                                                                                                      _7249 = _6871;
                                                                                                    }
                                                                                                    _7250 = _7223 - _6851;
                                                                                                    _7252 = select((_7250 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7256 = _7232 - _6851;
                                                                                                    _7258 = select((_7256 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7262 = _7241 - _6851;
                                                                                                    _7264 = select((_7262 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7268 = _7249 - _6851;
                                                                                                    _7270 = select((_7268 < 0.0f), 0.0f, 1.0f);
                                                                                                    _7271 = ((((((((((((((_6961 + _6957) + _6967) + _6973) + _7054) + _7060) + _7066) + _7072) + _7153) + _7159) + _7165) + _7171) + _7252) + _7258) + _7264) + _7270;
                                                                                                    _7282 = (saturate(_7271 * 0.0625f) * 2.0f) + -1.0f;
                                                                                                    _7288 = float((int)(((int)(uint)((int)(_7282 > 0.0f))) - ((int)(uint)((int)(_7282 < 0.0f)))));
                                                                                                    _7290 = 1.0f - (_7288 * _7282);
                                                                                                    _7292 = (_7290 * _7290) * _7290;
                                                                                                    _7301 = (0.5f - ((_7288 * 0.5f) * ((1.0f - _7292) - ((_7290 - _7292) * saturate(((1.0f / _6851) * (1.0f / _7271)) * ((((((((((((((((_6961 * _6959) + (_6957 * _6955)) + (_6967 * _6965)) + (_6973 * _6971)) + (_7054 * _7052)) + (_7060 * _7058)) + (_7066 * _7064)) + (_7072 * _7070)) + (_7153 * _7151)) + (_7159 * _7157)) + (_7165 * _7163)) + (_7171 * _7169)) + (_7252 * _7250)) + (_7258 * _7256)) + (_7264 * _7262)) + (_7270 * _7268)))))));
                                                                                                  } while (false);
                                                                                                  if (_loop_break_3) break;
                                                                                                } while (false);
                                                                                                if (_loop_break_3) break;
                                                                                              } while (false);
                                                                                              if (_loop_break_3) break;
                                                                                            } while (false);
                                                                                            if (_loop_break_3) break;
                                                                                          } while (false);
                                                                                          if (_loop_break_3) break;
                                                                                        } while (false);
                                                                                        if (_loop_break_3) break;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  }
                                                                  _7306 = _6837;
                                                                  _7307 = (lerp(_7301, _6836, _6837));
                                                                  [branch]
                                                                  if (!((_1607 & 2048) == 0)) {
                                                                    Texture2D<float> _HeapResource_29 = ResourceDescriptorHeap[NonUniformResourceIndex(((uint)(_6413) >> 16))];
                                                                    _7313 = _HeapResource_29.SampleLevel(samplerLinearClampNode, float2(_6537, _6538), 0.0f);
                                                                    if (_7313.x > 0.0f) {
                                                                      Texture2D<float4> _HeapResource_30 = ResourceDescriptorHeap[NonUniformResourceIndex((_6413 & 65535))];
                                                                      _7320 = _HeapResource_30.SampleLevel(samplerLinearClampNode, float2(_6537, _6538), 0.0f);
                                                                      _7334 = mad(saturate(((log2(_6488) * 0.6931471824645996f) - cbSharedPerViewData.fLogNearPlane) * cbSharedPerViewData.fInvLogPlaneDifference), 2.0f, -1.0f);
                                                                      _7335 = max(9.999999747378752e-06f, _7313.x);
                                                                      _7336 = _7320.x / _7335;
                                                                      _7337 = _7320.y / _7335;
                                                                      _7339 = _7320.w / _7335;
                                                                      _7344 = ((0.375f - _7337) * 4.999999873689376e-06f) + _7337;
                                                                      _7347 = -0.0f - _7336;
                                                                      _7348 = mad(_7347, _7344, (_7320.z / _7335));
                                                                      _7350 = 1.0f / mad(_7347, _7336, _7344);
                                                                      _7351 = _7350 * _7348;
                                                                      _7356 = _7334 - _7336;
                                                                      _7361 = (((_7334 * _7334) - _7344) - (_7351 * _7356)) / mad((-0.0f - _7348), _7351, mad((-0.0f - _7344), _7344, (((0.375f - _7339) * 4.999999873689376e-06f) + _7339)));
                                                                      _7363 = (_7350 * _7356) - (_7361 * _7351);
                                                                      _7366 = 1.0f / _7361;
                                                                      _7367 = _7363 * _7366;
                                                                      _7372 = sqrt(((_7367 * _7367) * 0.25f) - ((1.0f - dot(float2(_7363, _7361), float2(_7336, _7344))) * _7366));
                                                                      _7374 = (_7367 * -0.5f) - _7372;
                                                                      _7376 = _7372 - (_7367 * 0.5f);
                                                                      _7378 = select((_7374 < _7334), 1.0f, 0.0f);
                                                                      _7383 = (_7378 + -0.05000000074505806f) / (_7374 - _7334);
                                                                      _7389 = (((select((_7376 < _7334), 1.0f, 0.0f) - _7378) / (_7376 - _7374)) - _7383) / (_7376 - _7334);
                                                                      _7391 = _7383 - (_7389 * _7374);
                                                                      _7404 = _7306;
                                                                      _7405 = (exp2((_7313.x * -1.4426950216293335f) * saturate((dot(float2(_7336, _7344), float2((_7391 - (_7389 * _7334)), _7389)) + 0.05000000074505806f) - (_7391 * _7334))) * _7307);
                                                                    } else {
                                                                      _7404 = _7306;
                                                                      _7405 = _7307;
                                                                    }
                                                                  } else {
                                                                    _7404 = _7306;
                                                                    _7405 = _7307;
                                                                  }
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            }
                                                            do {
                                                              _7426 = _6439;
                                                              _7427 = _6440;
                                                              _7428 = _6442;
                                                              [branch]
                                                              if (!(_6460 == 0)) {
                                                                Texture2D<float3> _HeapResource_31 = ResourceDescriptorHeap[NonUniformResourceIndex(((int)((uint)(cbBindless.offset) + _6460)))];
                                                                _7418 = _HeapResource_31.SampleLevel(samplerLinearWrapNode, float2(((_6537 * f16tof32(((uint)((uint)(_6419) >> 16)))) + f16tof32(((uint)((uint)(_6422) >> 16)))), ((_6538 * f16tof32(_6419)) + f16tof32(_6422))), 0.0f);
                                                                _7426 = (_7418.x * _6439);
                                                                _7427 = (_7418.y * _6440);
                                                                _7428 = (_7418.z * _6442);
                                                              }
                                                              _7429 = _7405 * _6561;
                                                              [branch]
                                                              if (!(_7429 == 0.0f)) {
                                                                do {
                                                                  _7447 = GetDeferredSoftShadowChannel(_1610);
                                                                  if (_7447 < 0) {
                                                                        _7472 = _7429;
                                                                        do {
                                                                          _8462 = _1595;
                                                                          _8463 = _1596;
                                                                          _8464 = _1597;
                                                                          _8465 = _1598;
                                                                          _8466 = _1599;
                                                                          _8467 = _1600;
                                                                          [branch]
                                                                          if (_7472 > 0.0f) {
                                                                            do {
                                                                              _7578 = _7426;
                                                                              _7579 = _7427;
                                                                              _7580 = _7428;
                                                                              if (!(((_6416 & 1) == 0) || _6563)) {
                                                                                _7488 = max(max(_7426, _7427), _7428);
                                                                                do {
                                                                                  _7498 = _7426;
                                                                                  _7499 = _7427;
                                                                                  _7500 = _7428;
                                                                                  if (_7488 > 0.0f) {
                                                                                    _7498 = saturate(_7426 / _7488);
                                                                                    _7499 = saturate(_7427 / _7488);
                                                                                    _7500 = saturate(_7428 / _7488);
                                                                                  }
                                                                                  _7501 = (_7499 < _7500);
                                                                                  _7502 = select(_7501, _7500, _7499);
                                                                                  _7503 = select(_7501, _7499, _7500);
                                                                                  _7504 = select(_7501, -1.0f, 0.0f);
                                                                                  _7505 = (_7498 < _7502);
                                                                                  _7507 = select(_7505, _7502, _7498);
                                                                                  _7508 = select(_7505, _7498, _7502);
                                                                                  _7512 = _7507 - select((_7508 < _7503), _7508, _7503);
                                                                                  _7518 = abs(select(_7505, (-0.3333333432674408f - _7504), _7504) + ((_7508 - _7503) / ((_7512 * 6.0f) + 9.999999682655225e-21f)));
                                                                                  do {
                                                                                    _7531 = _7518;
                                                                                    if (_7518 < 0.6666666865348816f) {
                                                                                      _7531 = ((saturate(((float)((uint)((uint)(((uint)(_6416) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7518 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7518)) + _7518);
                                                                                    }
                                                                                    _7532 = saturate((_7512 / (_7507 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6416) >> 1) & 255)))) * 0.003921499941498041f));
                                                                                    _7533 = saturate(_7507);
                                                                                    do {
                                                                                      _7560 = _7533;
                                                                                      _7561 = _7533;
                                                                                      _7562 = _7533;
                                                                                      if (!(_7532 <= 0.0f)) {
                                                                                        _7536 = saturate(_7531);
                                                                                        _7540 = select(((_7536 * 360.0f) >= 360.0f), 0.0f, (_7536 * 6.0f));
                                                                                        _7541 = int(_7540);
                                                                                        _7543 = _7540 - float((int)(_7541));
                                                                                        _7545 = _7533 * (1.0f - _7532);
                                                                                        _7548 = (1.0f - (_7543 * _7532)) * _7533;
                                                                                        _7552 = (1.0f - ((1.0f - _7543) * _7532)) * _7533;
                                                                                        switch (_7541) {
                                                                                          case 0: {
                                                                                            _7560 = _7533;
                                                                                            _7561 = _7552;
                                                                                            _7562 = _7545;
                                                                                            break;
                                                                                          }
                                                                                          case 1: {
                                                                                            _7560 = _7548;
                                                                                            _7561 = _7533;
                                                                                            _7562 = _7545;
                                                                                            break;
                                                                                          }
                                                                                          case 2: {
                                                                                            _7560 = _7545;
                                                                                            _7561 = _7533;
                                                                                            _7562 = _7552;
                                                                                            break;
                                                                                          }
                                                                                          case 3: {
                                                                                            _7560 = _7545;
                                                                                            _7561 = _7548;
                                                                                            _7562 = _7533;
                                                                                            break;
                                                                                          }
                                                                                          case 4: {
                                                                                            _7560 = _7552;
                                                                                            _7561 = _7545;
                                                                                            _7562 = _7533;
                                                                                            break;
                                                                                          }
                                                                                          case 5: {
                                                                                            _7560 = _7533;
                                                                                            _7561 = _7545;
                                                                                            _7562 = _7548;
                                                                                            break;
                                                                                          }
                                                                                          default: {
                                                                                            _7560 = 0.0f;
                                                                                            _7561 = 0.0f;
                                                                                            _7562 = 0.0f;
                                                                                            break;
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                      _7563 = _7560 * _7488;
                                                                                      _7564 = _7561 * _7488;
                                                                                      _7565 = _7562 * _7488;
                                                                                      _7567 = saturate(_7405 * 1.0101009607315063f);
                                                                                      _7578 = ((_7567 * (_7426 - _7563)) + _7563);
                                                                                      _7579 = ((_7567 * (_7427 - _7564)) + _7564);
                                                                                      _7580 = (lerp(_7565, _7428, _7567));
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              }
                                                                              do {
                                                                                _7616 = _7472;
                                                                                [branch]
                                                                                if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                                  _7587 = srvLightMappingData[_1610];
                                                                                  if (!(_7587 == -1)) {
                                                                                    _7592 = srvLightIndexData[_7587].nLayerIndex;
                                                                                    _7594 = srvLightIndexData[_7587].vAtlasOrigin.x;
                                                                                    _7595 = srvLightIndexData[_7587].vAtlasOrigin.y;
                                                                                    _7597 = srvLightIndexData[_7587].vScreenOrigin.x;
                                                                                    _7598 = srvLightIndexData[_7587].vScreenOrigin.y;
                                                                                    _7607 = ((int)(_7592 * 5)) & 31;
                                                                                    _7616 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7594 + _64) - _7597)), ((int)((_7595 + _65) - _7598)), 0)))).x) & ((int)(31 << _7607)))) >> _7607)) >> 1)))) * 0.06666667014360428f) * _7472);
                                                                                  } else {
                                                                                    _7616 = _7472;
                                                                                  }
                                                                                }
                                                                                _7620 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                                _7623 = select(_7620, (_7616 * _1281), _7616);
                                                                                _7625 = _6489 * _6488;
                                                                                _7626 = _6490 * _6488;
                                                                                _7627 = _6491 * _6488;
                                                                                _7628 = _6450 * _6381;
                                                                                _7629 = _6450 * _6382;
                                                                                _7630 = _6450 * _6383;
                                                                                _7631 = _7625 + _7628;
                                                                                _7632 = _7626 + _7629;
                                                                                _7633 = _7627 + _7630;
                                                                                _7634 = _7625 - _7628;
                                                                                _7635 = _7626 - _7629;
                                                                                _7636 = _7627 - _7630;
                                                                                _7637 = (_6450 > 0.0f);
                                                                                _7638 = dot(float3(_7631, _7632, _7633), float3(_7631, _7632, _7633));
                                                                                _7639 = rsqrt(_7638);
                                                                                do {
                                                                                  [branch]
                                                                                  if (_7637) {
                                                                                    _7642 = rsqrt(dot(float3(_7634, _7635, _7636), float3(_7634, _7635, _7636)));
                                                                                    _7643 = _7642 * _7639;
                                                                                    _7645 = dot(float3(_7631, _7632, _7633), float3(_7634, _7635, _7636)) * _7643;
                                                                                    _7664 = (_7643 / ((_7643 + 0.5f) + (_7645 * 0.5f)));
                                                                                    _7665 = (((dot(float3(_192, _193, _194), float3(_7634, _7635, _7636)) * _7642) + (dot(float3(_192, _193, _194), float3(_7631, _7632, _7633)) * _7639)) * 0.5f);
                                                                                    _7666 = _7645;
                                                                                  } else {
                                                                                    _7664 = (1.0f / (_7638 + 1.0f));
                                                                                    _7665 = dot(float3(_192, _193, _194), float3((_7639 * _7631), (_7639 * _7632), (_7639 * _7633)));
                                                                                    _7666 = 1.0f;
                                                                                  }
                                                                                  do {
                                                                                    _7682 = _7665;
                                                                                    if (_6452 > 0.0f) {
                                                                                      _7672 = sqrt(saturate((_6452 * _6452) * _7664));
                                                                                      if (_7665 < _7672) {
                                                                                        _7677 = max(_7665, (-0.0f - _7672)) + _7672;
                                                                                        _7682 = ((_7677 * _7677) / (_7672 * 4.0f));
                                                                                      } else {
                                                                                        _7682 = _7665;
                                                                                      }
                                                                                    }
                                                                                    do {
                                                                                      _7742 = _7631;
                                                                                      _7743 = _7632;
                                                                                      _7744 = _7633;
                                                                                      if (_7637) {
                                                                                        _7684 = -0.0f - _452;
                                                                                        _7685 = -0.0f - _453;
                                                                                        _7686 = -0.0f - _451;
                                                                                        _7688 = dot(float3(_7684, _7685, _7686), float3(_192, _193, _194)) * 2.0f;
                                                                                        _7692 = _7684 - (_7688 * _192);
                                                                                        _7693 = _7685 - (_7688 * _193);
                                                                                        _7694 = _7686 - (_7688 * _194);
                                                                                        _7695 = _7634 - _7631;
                                                                                        _7696 = _7635 - _7632;
                                                                                        _7697 = _7636 - _7633;
                                                                                        _7698 = dot(float3(_7692, _7693, _7694), float3(_7695, _7696, _7697));
                                                                                        _7704 = sqrt(((_7695 * _7695) + (_7696 * _7696)) + (_7697 * _7697));
                                                                                        _7713 = saturate(((dot(float3(_7692, _7693, _7694), float3(_7631, _7632, _7633)) * _7698) - dot(float3(_7631, _7632, _7633), float3(_7695, _7696, _7697))) / ((_7704 * _7704) - (_7698 * _7698)));
                                                                                        _7717 = (_7713 * _7695) + _7631;
                                                                                        _7718 = (_7713 * _7696) + _7632;
                                                                                        _7719 = (_7713 * _7697) + _7633;
                                                                                        _7720 = dot(float3(_7717, _7718, _7719), float3(_7692, _7693, _7694));
                                                                                        _7724 = (_7720 * _7692) - _7717;
                                                                                        _7725 = (_7720 * _7693) - _7718;
                                                                                        _7726 = (_7720 * _7694) - _7719;
                                                                                        _7734 = saturate(0.009999999776482582f / sqrt(((_7724 * _7724) + (_7725 * _7725)) + (_7726 * _7726)));
                                                                                        _7742 = ((_7734 * _7724) + _7717);
                                                                                        _7743 = ((_7734 * _7725) + _7718);
                                                                                        _7744 = ((_7734 * _7726) + _7719);
                                                                                      }
                                                                                      _7746 = rsqrt(dot(float3(_7742, _7743, _7744), float3(_7742, _7743, _7744)));
                                                                                      _7747 = _7746 * _7742;
                                                                                      _7748 = _7746 * _7743;
                                                                                      _7749 = _7746 * _7744;
                                                                                      _7750 = _219 * _219;
                                                                                      _7754 = saturate((_6452 * (1.0f - _7750)) * _7746);
                                                                                      _7756 = saturate(_7746 * f16tof32(_6395));
                                                                                      _7758 = rsqrt(dot(float3(_7625, _7626, _7627), float3(_7625, _7626, _7627)));
                                                                                      _7762 = dot(float3(_192, _193, _194), float3(_7747, _7748, _7749));
                                                                                      _7763 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                                                      _7764 = dot(float3(_452, _453, _451), float3(_7747, _7748, _7749));
                                                                                      _7767 = rsqrt((_7764 * 2.0f) + 2.0f);
                                                                                      _7774 = (_7754 > 0.0f);
                                                                                      do {
                                                                                        _7865 = saturate((_7767 * _7764) + _7767);
                                                                                        _7866 = saturate(_7767 * (_7763 + _7762));
                                                                                        if (_7774) {
                                                                                          _7778 = sqrt(1.0f - (_7754 * _7754));
                                                                                          _7780 = (_7762 * 2.0f) * _7763;
                                                                                          _7781 = _7780 - _7764;
                                                                                          if (!(!(_7781 >= _7778))) {
                                                                                            _7865 = abs(_7763);
                                                                                            _7866 = 1.0f;
                                                                                          } else {
                                                                                            _7789 = rsqrt(1.0f - (_7781 * _7781)) * _7754;
                                                                                            _7792 = _7789 * (_7763 - (_7781 * _7762));
                                                                                            _7793 = _7763 * _7763;
                                                                                            _7798 = _7789 * (((_7793 * 2.0f) + -1.0f) - (_7781 * _7764));
                                                                                            _7807 = sqrt(saturate((((1.0f - (_7762 * _7762)) - _7793) - (_7764 * _7764)) + (_7780 * _7764)));
                                                                                            _7808 = _7807 * _7789;
                                                                                            _7811 = ((_7763 * 2.0f) * _7789) * _7807;
                                                                                            _7813 = (_7778 * _7762) + _7763;
                                                                                            _7814 = _7813 + _7792;
                                                                                            _7815 = _7778 * _7764;
                                                                                            _7817 = (_7815 + 1.0f) + _7798;
                                                                                            _7818 = _7808 * _7817;
                                                                                            _7819 = _7814 * _7817;
                                                                                            _7820 = _7811 * _7814;
                                                                                            _7825 = (((_7814 * 0.25f) * _7811) - (_7818 * 0.5f)) * _7819;
                                                                                            _7839 = (((_7820 - (_7818 * 2.0f)) * _7820) + (_7818 * _7818)) + ((((-0.5f - ((_7817 + _7815) * 0.5f)) * _7819) + ((_7817 * _7817) * _7813)) * _7814);
                                                                                            _7844 = (_7825 * 2.0f) / ((_7839 * _7839) + (_7825 * _7825));
                                                                                            _7845 = _7839 * _7844;
                                                                                            _7847 = 1.0f - (_7825 * _7844);
                                                                                            _7853 = ((_7845 * _7811) + _7815) + (_7847 * _7798);
                                                                                            _7856 = rsqrt((_7853 * 2.0f) + 2.0f);
                                                                                            _7865 = saturate((_7853 * _7856) + _7856);
                                                                                            _7866 = saturate(((_7813 + (_7845 * _7808)) + (_7847 * _7792)) * _7856);
                                                                                          }
                                                                                        }
                                                                                        _7867 = saturate(_7682);
                                                                                        _7869 = _7750 * _7750;
                                                                                        do {
                                                                                          _7879 = _7869;
                                                                                          if (_7756 > 0.0f) {
                                                                                            _7879 = saturate(((_7756 * _7756) / ((_7865 * 3.5999999046325684f) + 0.4000000059604645f)) + _7869);
                                                                                          }
                                                                                          do {
                                                                                            _7891 = _7879;
                                                                                            _7892 = 1.0f;
                                                                                            if (_7774) {
                                                                                              _7888 = (((_7754 * 0.25f) * ((sqrt(_7879) * 3.0f) + _7754)) / (_7865 + 0.0010000000474974513f)) + _7879;
                                                                                              _7891 = _7888;
                                                                                              _7892 = (_7879 / _7888);
                                                                                            }
                                                                                            do {
                                                                                              _7912 = _7892;
                                                                                              if (_7666 < 1.0f) {
                                                                                                _7899 = sqrt((1.000100016593933f - _7666) / max(9.999999974752427e-07f, (_7666 + 1.0f)));
                                                                                                _7912 = (sqrt(_7891 / ((((_7899 * 0.25f) * ((sqrt(_7891) * 3.0f) + _7899)) / (_7865 + 0.0010000000474974513f)) + _7891)) * _7892);
                                                                                              }
                                                                                              _7916 = (((_7879 * _7866) - _7866) * _7866) + 1.0f;
                                                                                              _7923 = exp2(log2(1.0f - saturate(_7865)) * 5.0f);
                                                                                              _7926 = saturate(abs(_7763) + 9.999999747378752e-06f);
                                                                                              _7927 = sqrt(_7879);
                                                                                              _7928 = 1.0f - _7927;
                                                                                              _7940 = saturate((dot(float3(_192, _193, _194), float3((_7758 * _7625), (_7758 * _7626), (_7758 * _7627))) + _6449) / (_6449 + 1.0f));
                                                                                              _7943 = ((_7912 * _7867) * (_7879 / (_7916 * _7916))) * (0.5f / ((((_7928 * _7926) + _7927) * _7867) + (((_7928 * _7867) + _7927) * _7926)));
                                                                                              _7944 = _7578 * _1658;
                                                                                              _7945 = _7579 * _1658;
                                                                                              _7946 = _7580 * _1658;
                                                                                              _7953 = ((_7623 * _7944) * _7940) + _1595;
                                                                                              _7954 = ((_7623 * _7945) * _7940) + _1596;
                                                                                              _7955 = ((_7623 * _7946) * _7940) + _1597;
                                                                                              if (_6446 > 0.0f) {
                                                                                                _7968 = (_6446 * _1354) * select(_7620, (_7616 * _1281), _7616);
                                                                                                _8462 = _7953;
                                                                                                _8463 = _7954;
                                                                                                _8464 = _7955;
                                                                                                _8465 = (((((_7944 * _1144) * _7968) * ((_7923 * (1.0f - _211)) + _211)) * _7943) + _1598);
                                                                                                _8466 = (((((_7945 * _1145) * _7968) * ((_7923 * (1.0f - _212)) + _212)) * _7943) + _1599);
                                                                                                _8467 = (((((_7946 * _1146) * _7968) * ((_7923 * (1.0f - _213)) + _213)) * _7943) + _1600);
                                                                                              } else {
                                                                                                _8462 = _7953;
                                                                                                _8463 = _7954;
                                                                                                _8464 = _7955;
                                                                                                _8465 = _1598;
                                                                                                _8466 = _1599;
                                                                                                _8467 = _1600;
                                                                                              }
                                                                                            } while (false);
                                                                                            if (_loop_break_3) break;
                                                                                          } while (false);
                                                                                          if (_loop_break_3) break;
                                                                                        } while (false);
                                                                                        if (_loop_break_3) break;
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          }
                                                                          break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                    // Native unlisted-light path bypasses mask sampling and the duplicate shading path.
                                                                    break;
                                                                  }
                                                                  _7450 = srvDeferredShadingPass_SoftShadowsMask.Load(int3(_64, _65, 0));
                                                                  do {
                                                                    if (_7447 == 0) {
                                                                      _7464 = _7450.x;
                                                                    } else {
                                                                      if (_7447 == 1) {
                                                                        _7464 = _7450.y;
                                                                      } else {
                                                                        if (_7447 == 2) {
                                                                          _7464 = _7450.z;
                                                                        } else {
                                                                          _7464 = _7450.w;
                                                                        }
                                                                      }
                                                                    }
                                                                    _7472 = ((((_7404 * _7404) * ((_7464 * _7464) + -1.0f)) + 1.0f) * _6561);
                                                                    [branch]
                                                                    if (_7472 > 0.0f) {
                                                                      do {
                                                                        _7578 = _7426;
                                                                        _7579 = _7427;
                                                                        _7580 = _7428;
                                                                        if (!(((_6416 & 1) == 0) || _6563)) {
                                                                          _7488 = max(max(_7426, _7427), _7428);
                                                                          do {
                                                                            _7498 = _7426;
                                                                            _7499 = _7427;
                                                                            _7500 = _7428;
                                                                            if (_7488 > 0.0f) {
                                                                              _7498 = saturate(_7426 / _7488);
                                                                              _7499 = saturate(_7427 / _7488);
                                                                              _7500 = saturate(_7428 / _7488);
                                                                            }
                                                                            _7501 = (_7499 < _7500);
                                                                            _7502 = select(_7501, _7500, _7499);
                                                                            _7503 = select(_7501, _7499, _7500);
                                                                            _7504 = select(_7501, -1.0f, 0.0f);
                                                                            _7505 = (_7498 < _7502);
                                                                            _7507 = select(_7505, _7502, _7498);
                                                                            _7508 = select(_7505, _7498, _7502);
                                                                            _7512 = _7507 - select((_7508 < _7503), _7508, _7503);
                                                                            _7518 = abs(select(_7505, (-0.3333333432674408f - _7504), _7504) + ((_7508 - _7503) / ((_7512 * 6.0f) + 9.999999682655225e-21f)));
                                                                            do {
                                                                              _7531 = _7518;
                                                                              if (_7518 < 0.6666666865348816f) {
                                                                                _7531 = ((saturate(((float)((uint)((uint)(((uint)(_6416) >> 9) & 255)))) * 0.003921499941498041f) * (select((_7518 < 0.3333333432674408f), 0.0f, 0.6666666865348816f) - _7518)) + _7518);
                                                                              }
                                                                              _7532 = saturate((_7512 / (_7507 + 9.999999682655225e-21f)) + (((float)((uint)((uint)(((uint)(_6416) >> 1) & 255)))) * 0.003921499941498041f));
                                                                              _7533 = saturate(_7507);
                                                                              do {
                                                                                _7560 = _7533;
                                                                                _7561 = _7533;
                                                                                _7562 = _7533;
                                                                                if (!(_7532 <= 0.0f)) {
                                                                                  _7536 = saturate(_7531);
                                                                                  _7540 = select(((_7536 * 360.0f) >= 360.0f), 0.0f, (_7536 * 6.0f));
                                                                                  _7541 = int(_7540);
                                                                                  _7543 = _7540 - float((int)(_7541));
                                                                                  _7545 = _7533 * (1.0f - _7532);
                                                                                  _7548 = (1.0f - (_7543 * _7532)) * _7533;
                                                                                  _7552 = (1.0f - ((1.0f - _7543) * _7532)) * _7533;
                                                                                  switch (_7541) {
                                                                                    case 0: {
                                                                                      _7560 = _7533;
                                                                                      _7561 = _7552;
                                                                                      _7562 = _7545;
                                                                                      break;
                                                                                    }
                                                                                    case 1: {
                                                                                      _7560 = _7548;
                                                                                      _7561 = _7533;
                                                                                      _7562 = _7545;
                                                                                      break;
                                                                                    }
                                                                                    case 2: {
                                                                                      _7560 = _7545;
                                                                                      _7561 = _7533;
                                                                                      _7562 = _7552;
                                                                                      break;
                                                                                    }
                                                                                    case 3: {
                                                                                      _7560 = _7545;
                                                                                      _7561 = _7548;
                                                                                      _7562 = _7533;
                                                                                      break;
                                                                                    }
                                                                                    case 4: {
                                                                                      _7560 = _7552;
                                                                                      _7561 = _7545;
                                                                                      _7562 = _7533;
                                                                                      break;
                                                                                    }
                                                                                    case 5: {
                                                                                      _7560 = _7533;
                                                                                      _7561 = _7545;
                                                                                      _7562 = _7548;
                                                                                      break;
                                                                                    }
                                                                                    default: {
                                                                                      _7560 = 0.0f;
                                                                                      _7561 = 0.0f;
                                                                                      _7562 = 0.0f;
                                                                                      break;
                                                                                    }
                                                                                  }
                                                                                }
                                                                                _7563 = _7560 * _7488;
                                                                                _7564 = _7561 * _7488;
                                                                                _7565 = _7562 * _7488;
                                                                                _7567 = saturate(_7405 * 1.0101009607315063f);
                                                                                _7578 = ((_7567 * (_7426 - _7563)) + _7563);
                                                                                _7579 = ((_7567 * (_7427 - _7564)) + _7564);
                                                                                _7580 = (lerp(_7565, _7428, _7567));
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        }
                                                                        do {
                                                                          _7616 = _7472;
                                                                          [branch]
                                                                          if (!(cbSharedPerViewData.nEnableContactShadows == 0)) {
                                                                            _7587 = srvLightMappingData[_1610];
                                                                            if (!(_7587 == -1)) {
                                                                              _7592 = srvLightIndexData[_7587].nLayerIndex;
                                                                              _7594 = srvLightIndexData[_7587].vAtlasOrigin.x;
                                                                              _7595 = srvLightIndexData[_7587].vAtlasOrigin.y;
                                                                              _7597 = srvLightIndexData[_7587].vScreenOrigin.x;
                                                                              _7598 = srvLightIndexData[_7587].vScreenOrigin.y;
                                                                              _7607 = ((int)(_7592 * 5)) & 31;
                                                                              _7616 = ((((float)((uint)((uint)((uint)((uint)((uint)((uint)((((uint)(srvScreenSpaceContactLocalShadowMask.Load(int3(((int)((_7594 + _64) - _7597)), ((int)((_7595 + _65) - _7598)), 0)))).x) & ((int)(31 << _7607)))) >> _7607)) >> 1)))) * 0.06666667014360428f) * _7472);
                                                                            } else {
                                                                              _7616 = _7472;
                                                                            }
                                                                          }
                                                                          _7620 = ((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0);
                                                                          _7623 = select(_7620, (_7616 * _1281), _7616);
                                                                          _7625 = _6489 * _6488;
                                                                          _7626 = _6490 * _6488;
                                                                          _7627 = _6491 * _6488;
                                                                          _7628 = _6450 * _6381;
                                                                          _7629 = _6450 * _6382;
                                                                          _7630 = _6450 * _6383;
                                                                          _7631 = _7625 + _7628;
                                                                          _7632 = _7626 + _7629;
                                                                          _7633 = _7627 + _7630;
                                                                          _7634 = _7625 - _7628;
                                                                          _7635 = _7626 - _7629;
                                                                          _7636 = _7627 - _7630;
                                                                          _7637 = (_6450 > 0.0f);
                                                                          _7638 = dot(float3(_7631, _7632, _7633), float3(_7631, _7632, _7633));
                                                                          _7639 = rsqrt(_7638);
                                                                          do {
                                                                            [branch]
                                                                            if (_7637) {
                                                                              _7642 = rsqrt(dot(float3(_7634, _7635, _7636), float3(_7634, _7635, _7636)));
                                                                              _7643 = _7642 * _7639;
                                                                              _7645 = dot(float3(_7631, _7632, _7633), float3(_7634, _7635, _7636)) * _7643;
                                                                              _7664 = (_7643 / ((_7643 + 0.5f) + (_7645 * 0.5f)));
                                                                              _7665 = (((dot(float3(_192, _193, _194), float3(_7634, _7635, _7636)) * _7642) + (dot(float3(_192, _193, _194), float3(_7631, _7632, _7633)) * _7639)) * 0.5f);
                                                                              _7666 = _7645;
                                                                            } else {
                                                                              _7664 = (1.0f / (_7638 + 1.0f));
                                                                              _7665 = dot(float3(_192, _193, _194), float3((_7639 * _7631), (_7639 * _7632), (_7639 * _7633)));
                                                                              _7666 = 1.0f;
                                                                            }
                                                                            do {
                                                                              _7682 = _7665;
                                                                              if (_6452 > 0.0f) {
                                                                                _7672 = sqrt(saturate((_6452 * _6452) * _7664));
                                                                                if (_7665 < _7672) {
                                                                                  _7677 = max(_7665, (-0.0f - _7672)) + _7672;
                                                                                  _7682 = ((_7677 * _7677) / (_7672 * 4.0f));
                                                                                } else {
                                                                                  _7682 = _7665;
                                                                                }
                                                                              }
                                                                              do {
                                                                                _7742 = _7631;
                                                                                _7743 = _7632;
                                                                                _7744 = _7633;
                                                                                if (_7637) {
                                                                                  _7684 = -0.0f - _452;
                                                                                  _7685 = -0.0f - _453;
                                                                                  _7686 = -0.0f - _451;
                                                                                  _7688 = dot(float3(_7684, _7685, _7686), float3(_192, _193, _194)) * 2.0f;
                                                                                  _7692 = _7684 - (_7688 * _192);
                                                                                  _7693 = _7685 - (_7688 * _193);
                                                                                  _7694 = _7686 - (_7688 * _194);
                                                                                  _7695 = _7634 - _7631;
                                                                                  _7696 = _7635 - _7632;
                                                                                  _7697 = _7636 - _7633;
                                                                                  _7698 = dot(float3(_7692, _7693, _7694), float3(_7695, _7696, _7697));
                                                                                  _7704 = sqrt(((_7695 * _7695) + (_7696 * _7696)) + (_7697 * _7697));
                                                                                  _7713 = saturate(((dot(float3(_7692, _7693, _7694), float3(_7631, _7632, _7633)) * _7698) - dot(float3(_7631, _7632, _7633), float3(_7695, _7696, _7697))) / ((_7704 * _7704) - (_7698 * _7698)));
                                                                                  _7717 = (_7713 * _7695) + _7631;
                                                                                  _7718 = (_7713 * _7696) + _7632;
                                                                                  _7719 = (_7713 * _7697) + _7633;
                                                                                  _7720 = dot(float3(_7717, _7718, _7719), float3(_7692, _7693, _7694));
                                                                                  _7724 = (_7720 * _7692) - _7717;
                                                                                  _7725 = (_7720 * _7693) - _7718;
                                                                                  _7726 = (_7720 * _7694) - _7719;
                                                                                  _7734 = saturate(0.009999999776482582f / sqrt(((_7724 * _7724) + (_7725 * _7725)) + (_7726 * _7726)));
                                                                                  _7742 = ((_7734 * _7724) + _7717);
                                                                                  _7743 = ((_7734 * _7725) + _7718);
                                                                                  _7744 = ((_7734 * _7726) + _7719);
                                                                                }
                                                                                _7746 = rsqrt(dot(float3(_7742, _7743, _7744), float3(_7742, _7743, _7744)));
                                                                                _7747 = _7746 * _7742;
                                                                                _7748 = _7746 * _7743;
                                                                                _7749 = _7746 * _7744;
                                                                                _7750 = _219 * _219;
                                                                                _7754 = saturate((_6452 * (1.0f - _7750)) * _7746);
                                                                                _7756 = saturate(_7746 * f16tof32(_6395));
                                                                                _7758 = rsqrt(dot(float3(_7625, _7626, _7627), float3(_7625, _7626, _7627)));
                                                                                _7762 = dot(float3(_192, _193, _194), float3(_7747, _7748, _7749));
                                                                                _7763 = dot(float3(_192, _193, _194), float3(_452, _453, _451));
                                                                                _7764 = dot(float3(_452, _453, _451), float3(_7747, _7748, _7749));
                                                                                _7767 = rsqrt((_7764 * 2.0f) + 2.0f);
                                                                                _7774 = (_7754 > 0.0f);
                                                                                do {
                                                                                  _7865 = saturate((_7767 * _7764) + _7767);
                                                                                  _7866 = saturate(_7767 * (_7763 + _7762));
                                                                                  if (_7774) {
                                                                                    _7778 = sqrt(1.0f - (_7754 * _7754));
                                                                                    _7780 = (_7762 * 2.0f) * _7763;
                                                                                    _7781 = _7780 - _7764;
                                                                                    if (!(!(_7781 >= _7778))) {
                                                                                      _7865 = abs(_7763);
                                                                                      _7866 = 1.0f;
                                                                                    } else {
                                                                                      _7789 = rsqrt(1.0f - (_7781 * _7781)) * _7754;
                                                                                      _7792 = _7789 * (_7763 - (_7781 * _7762));
                                                                                      _7793 = _7763 * _7763;
                                                                                      _7798 = _7789 * (((_7793 * 2.0f) + -1.0f) - (_7781 * _7764));
                                                                                      _7807 = sqrt(saturate((((1.0f - (_7762 * _7762)) - _7793) - (_7764 * _7764)) + (_7780 * _7764)));
                                                                                      _7808 = _7807 * _7789;
                                                                                      _7811 = ((_7763 * 2.0f) * _7789) * _7807;
                                                                                      _7813 = (_7778 * _7762) + _7763;
                                                                                      _7814 = _7813 + _7792;
                                                                                      _7815 = _7778 * _7764;
                                                                                      _7817 = (_7815 + 1.0f) + _7798;
                                                                                      _7818 = _7808 * _7817;
                                                                                      _7819 = _7814 * _7817;
                                                                                      _7820 = _7811 * _7814;
                                                                                      _7825 = (((_7814 * 0.25f) * _7811) - (_7818 * 0.5f)) * _7819;
                                                                                      _7839 = (((_7820 - (_7818 * 2.0f)) * _7820) + (_7818 * _7818)) + ((((-0.5f - ((_7817 + _7815) * 0.5f)) * _7819) + ((_7817 * _7817) * _7813)) * _7814);
                                                                                      _7844 = (_7825 * 2.0f) / ((_7839 * _7839) + (_7825 * _7825));
                                                                                      _7845 = _7839 * _7844;
                                                                                      _7847 = 1.0f - (_7825 * _7844);
                                                                                      _7853 = ((_7845 * _7811) + _7815) + (_7847 * _7798);
                                                                                      _7856 = rsqrt((_7853 * 2.0f) + 2.0f);
                                                                                      _7865 = saturate((_7853 * _7856) + _7856);
                                                                                      _7866 = saturate(((_7813 + (_7845 * _7808)) + (_7847 * _7792)) * _7856);
                                                                                    }
                                                                                  }
                                                                                  _7867 = saturate(_7682);
                                                                                  _7869 = _7750 * _7750;
                                                                                  do {
                                                                                    _7879 = _7869;
                                                                                    if (_7756 > 0.0f) {
                                                                                      _7879 = saturate(((_7756 * _7756) / ((_7865 * 3.5999999046325684f) + 0.4000000059604645f)) + _7869);
                                                                                    }
                                                                                    do {
                                                                                      _7891 = _7879;
                                                                                      _7892 = 1.0f;
                                                                                      if (_7774) {
                                                                                        _7888 = (((_7754 * 0.25f) * ((sqrt(_7879) * 3.0f) + _7754)) / (_7865 + 0.0010000000474974513f)) + _7879;
                                                                                        _7891 = _7888;
                                                                                        _7892 = (_7879 / _7888);
                                                                                      }
                                                                                      do {
                                                                                        _7912 = _7892;
                                                                                        if (_7666 < 1.0f) {
                                                                                          _7899 = sqrt((1.000100016593933f - _7666) / max(9.999999974752427e-07f, (_7666 + 1.0f)));
                                                                                          _7912 = (sqrt(_7891 / ((((_7899 * 0.25f) * ((sqrt(_7891) * 3.0f) + _7899)) / (_7865 + 0.0010000000474974513f)) + _7891)) * _7892);
                                                                                        }
                                                                                        _7916 = (((_7879 * _7866) - _7866) * _7866) + 1.0f;
                                                                                        _7923 = exp2(log2(1.0f - saturate(_7865)) * 5.0f);
                                                                                        _7926 = saturate(abs(_7763) + 9.999999747378752e-06f);
                                                                                        _7927 = sqrt(_7879);
                                                                                        _7928 = 1.0f - _7927;
                                                                                        _7940 = saturate((dot(float3(_192, _193, _194), float3((_7758 * _7625), (_7758 * _7626), (_7758 * _7627))) + _6449) / (_6449 + 1.0f));
                                                                                        _7943 = ((_7912 * _7867) * (_7879 / (_7916 * _7916))) * (0.5f / ((((_7928 * _7926) + _7927) * _7867) + (((_7928 * _7867) + _7927) * _7926)));
                                                                                        _7944 = _7578 * _1658;
                                                                                        _7945 = _7579 * _1658;
                                                                                        _7946 = _7580 * _1658;
                                                                                        _7953 = ((_7623 * _7944) * _7940) + _1595;
                                                                                        _7954 = ((_7623 * _7945) * _7940) + _1596;
                                                                                        _7955 = ((_7623 * _7946) * _7940) + _1597;
                                                                                        if (_6446 > 0.0f) {
                                                                                          _7968 = (_6446 * _1354) * select(_7620, (_7616 * _1281), _7616);
                                                                                          _8462 = _7953;
                                                                                          _8463 = _7954;
                                                                                          _8464 = _7955;
                                                                                          _8465 = (((((_7944 * _1144) * _7968) * ((_7923 * (1.0f - _211)) + _211)) * _7943) + _1598);
                                                                                          _8466 = (((((_7945 * _1145) * _7968) * ((_7923 * (1.0f - _212)) + _212)) * _7943) + _1599);
                                                                                          _8467 = (((((_7946 * _1146) * _7968) * ((_7923 * (1.0f - _213)) + _213)) * _7943) + _1600);
                                                                                        } else {
                                                                                          _8462 = _7953;
                                                                                          _8463 = _7954;
                                                                                          _8464 = _7955;
                                                                                          _8465 = _1598;
                                                                                          _8466 = _1599;
                                                                                          _8467 = _1600;
                                                                                        }
                                                                                      } while (false);
                                                                                      if (_loop_break_3) break;
                                                                                    } while (false);
                                                                                    if (_loop_break_3) break;
                                                                                  } while (false);
                                                                                  if (_loop_break_3) break;
                                                                                } while (false);
                                                                                if (_loop_break_3) break;
                                                                              } while (false);
                                                                              if (_loop_break_3) break;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } while (false);
                                                                        if (_loop_break_3) break;
                                                                      } while (false);
                                                                      if (_loop_break_3) break;
                                                                    } else {
                                                                      _8462 = _1595;
                                                                      _8463 = _1596;
                                                                      _8464 = _1597;
                                                                      _8465 = _1598;
                                                                      _8466 = _1599;
                                                                      _8467 = _1600;
                                                                    }
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } else {
                                                                _8462 = _1595;
                                                                _8463 = _1596;
                                                                _8464 = _1597;
                                                                _8465 = _1598;
                                                                _8466 = _1599;
                                                                _8467 = _1600;
                                                              }
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } while (false);
                                                          if (_loop_break_3) break;
                                                        } else {
                                                          if (_1641 == 10) {
                                                            _7989 = asfloat(srvLightInfoProperties.Load4(_1609)).x;
                                                            _7990 = asfloat(srvLightInfoProperties.Load4(_1609)).y;
                                                            _7991 = asfloat(srvLightInfoProperties.Load4(_1609)).z;
                                                            _7992 = asfloat(srvLightInfoProperties.Load4(_1609)).w;
                                                            _7995 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).x;
                                                            _7996 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).y;
                                                            _7997 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).z;
                                                            _7998 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 16u)))).w;
                                                            _8001 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).x;
                                                            _8002 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).y;
                                                            _8003 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).z;
                                                            _8004 = asfloat(srvLightInfoProperties.Load4(((int)(_1609 + 32u)))).w;
                                                            _8007 = asfloat(srvLightInfoProperties.Load2(((int)(_1609 + 72u)))).x;
                                                            _8008 = asfloat(srvLightInfoProperties.Load2(((int)(_1609 + 72u)))).y;
                                                            _8011 = asint(srvLightInfoProperties.Load(((int)(_1609 + 80u))));
                                                            _8014 = asint(srvLightInfoProperties.Load(((int)(_1609 + 84u))));
                                                            _8017 = asint(srvLightInfoProperties.Load(((int)(_1609 + 88u))));
                                                            _8020 = asint(srvLightInfoProperties.Load(((int)(_1609 + 96u))));
                                                            _8023 = f16tof32(_8011);
                                                            _8025 = f16tof32(((uint)((uint)(_8014) >> 16)));
                                                            _8026 = f16tof32(_8014);
                                                            _8028 = f16tof32(((uint)((uint)(_8017) >> 16)));
                                                            _8032 = ((float)((uint)((uint)(((uint)(_8017) >> 8) & 255)))) * 0.003921499941498041f;
                                                            _8034 = (float)((uint)((uint)(_8020 & 65535)));
                                                            _8038 = mad(_7991, _236, mad(_7990, _235, (_7989 * _234))) + _7992;
                                                            _8042 = mad(_7997, _236, mad(_7996, _235, (_7995 * _234))) + _7998;
                                                            _8046 = mad(_8003, _236, mad(_8002, _235, (_8001 * _234))) + _8004;
                                                            _8049 = mad(_7991, _194, mad(_7990, _193, (_7989 * _192)));
                                                            _8052 = mad(_7997, _194, mad(_7996, _193, (_7995 * _192)));
                                                            _8055 = mad(_8003, _194, mad(_8002, _193, (_8001 * _192)));
                                                            _8067 = -0.0f - mad(_8003, _451, mad(_8002, _453, (_8001 * _452)));
                                                            _8068 = _8007 * 0.5f;
                                                            _8069 = _8008 * 0.5f;
                                                            _8070 = -0.0f - _8068;
                                                            _8071 = -0.0f - _8069;
                                                            _8072 = _8070 - _8038;
                                                            _8073 = _8071 - _8042;
                                                            _8074 = -0.0f - _8046;
                                                            _8075 = _8068 - _8038;
                                                            _8076 = _8069 - _8042;
                                                            _8077 = dot(float3(_8038, _8042, _8046), float3(_8049, _8052, _8055));
                                                            _8079 = dot(float3(_8070, _8071, 0.0f), float3(_8049, _8052, _8055)) - _8077;
                                                            _8081 = dot(float3(_8068, _8071, 0.0f), float3(_8049, _8052, _8055)) - _8077;
                                                            _8083 = dot(float3(_8068, _8069, 0.0f), float3(_8049, _8052, _8055)) - _8077;
                                                            _8085 = dot(float3(_8070, _8069, 0.0f), float3(_8049, _8052, _8055)) - _8077;
                                                            _8086 = min(_8079, _8081);
                                                            do {
                                                              _8108 = 0.0f;
                                                              _8109 = 0.0f;
                                                              [branch]
                                                              if (!(!(_8086 >= 0.0f))) {
                                                                _8092 = rsqrt(dot(float3(_8075, _8073, _8074), float3(_8075, _8073, _8074)) * dot(float3(_8072, _8073, _8074), float3(_8072, _8073, _8074)));
                                                                _8094 = dot(float3(_8072, _8073, _8074), float3(_8075, _8073, _8074)) * _8092;
                                                                _8101 = rsqrt(max(((((_8094 * 0.09300000220537186f) + 0.5f) * _8094) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8092;
                                                                _8108 = (_8101 * (_8007 * _8074));
                                                                _8109 = (_8101 * (_8073 * (_8070 - _8068)));
                                                              }
                                                              do {
                                                                _8133 = 0.0f;
                                                                _8134 = _8109;
                                                                [branch]
                                                                if (!(!(min(_8081, _8083) >= 0.0f))) {
                                                                  _8116 = rsqrt(dot(float3(_8075, _8076, _8074), float3(_8075, _8076, _8074)) * dot(float3(_8075, _8073, _8074), float3(_8075, _8073, _8074)));
                                                                  _8118 = dot(float3(_8075, _8073, _8074), float3(_8075, _8076, _8074)) * _8116;
                                                                  _8125 = rsqrt(max(((((_8118 * 0.09300000220537186f) + 0.5f) * _8118) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8116;
                                                                  _8133 = (_8125 * ((_8071 - _8069) * _8074));
                                                                  _8134 = ((_8125 * (_8008 * _8075)) + _8109);
                                                                }
                                                                _8135 = min(_8083, _8085);
                                                                do {
                                                                  _8159 = _8108;
                                                                  _8160 = _8134;
                                                                  [branch]
                                                                  if (!(!(_8135 >= 0.0f))) {
                                                                    _8141 = rsqrt(dot(float3(_8072, _8076, _8074), float3(_8072, _8076, _8074)) * dot(float3(_8075, _8076, _8074), float3(_8075, _8076, _8074)));
                                                                    _8143 = dot(float3(_8075, _8076, _8074), float3(_8072, _8076, _8074)) * _8141;
                                                                    _8150 = rsqrt(max(((((_8143 * 0.09300000220537186f) + 0.5f) * _8143) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8141;
                                                                    _8159 = ((_8150 * ((_8070 - _8068) * _8074)) + _8108);
                                                                    _8160 = ((_8150 * (_8007 * _8076)) + _8134);
                                                                  }
                                                                  do {
                                                                    _8185 = _8133;
                                                                    _8186 = _8160;
                                                                    [branch]
                                                                    if (!(!(min(_8085, _8079) >= 0.0f))) {
                                                                      _8167 = rsqrt(dot(float3(_8072, _8073, _8074), float3(_8072, _8073, _8074)) * dot(float3(_8072, _8076, _8074), float3(_8072, _8076, _8074)));
                                                                      _8169 = dot(float3(_8072, _8076, _8074), float3(_8072, _8073, _8074)) * _8167;
                                                                      _8176 = rsqrt(max(((((_8169 * 0.09300000220537186f) + 0.5f) * _8169) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8167;
                                                                      _8185 = ((_8176 * (_8008 * _8074)) + _8133);
                                                                      _8186 = ((_8176 * (_8072 * (_8071 - _8069))) + _8160);
                                                                    }
                                                                    do {
                                                                      _8329 = _8185;
                                                                      _8330 = _8159;
                                                                      _8331 = _8186;
                                                                      if (min(_8086, _8135) < 0.0f) {
                                                                        [branch]
                                                                        if (!(!(max(max(_8079, _8081), max(_8083, _8085)) >= 0.0f))) {
                                                                          _8195 = -0.0f - _8049;
                                                                          _8196 = _8077 / _8052;
                                                                          _8197 = _8070 / _8052;
                                                                          _8198 = _8068 / _8052;
                                                                          _8200 = (_8071 - _8196) / _8195;
                                                                          _8202 = (_8069 - _8196) / _8195;
                                                                          _8203 = min(_8197, _8198);
                                                                          _8204 = max(_8197, _8198);
                                                                          _8205 = min(_8200, _8202);
                                                                          _8206 = max(_8200, _8202);
                                                                          _8207 = max(_8203, _8205);
                                                                          _8208 = min(_8204, _8206);
                                                                          _8209 = _8207 * _8052;
                                                                          _8211 = _8208 * _8052;
                                                                          _8213 = _8209 - _8038;
                                                                          _8214 = _8196 - _8042;
                                                                          _8215 = _8214 + (_8207 * _8195);
                                                                          _8216 = _8211 - _8038;
                                                                          _8217 = _8214 + (_8208 * _8195);
                                                                          _8218 = dot(float3(_8213, _8215, _8074), float3(_8213, _8215, _8074));
                                                                          _8219 = dot(float3(_8216, _8217, _8074), float3(_8216, _8217, _8074));
                                                                          _8221 = rsqrt(_8219 * _8218);
                                                                          _8223 = dot(float3(_8213, _8215, _8074), float3(_8216, _8217, _8074)) * _8221;
                                                                          _8230 = rsqrt(max(((((_8223 * 0.09300000220537186f) + 0.5f) * _8223) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8221;
                                                                          _8243 = (_8203 > _8205);
                                                                          _8245 = select(_8243, _8052, _8049);
                                                                          _8251 = float((int)(((int)(uint)((int)(_8245 > 0.0f))) - ((int)(uint)((int)(_8245 < 0.0f)))));
                                                                          _8255 = ((1.0f - (((float)((bool)_8243)) * 2.0f)) * _8068) * _8251;
                                                                          _8257 = _8255 - _8038;
                                                                          _8258 = (_8251 * _8069) - _8042;
                                                                          _8259 = (_8204 < _8206);
                                                                          _8261 = select(_8259, _8052, _8049);
                                                                          _8267 = float((int)(((int)(uint)((int)(_8261 > 0.0f))) - ((int)(uint)((int)(_8261 < 0.0f)))));
                                                                          _8268 = _8267 * _8068;
                                                                          _8273 = _8268 - _8038;
                                                                          _8274 = ((((((float)((bool)_8259)) * 2.0f) + -1.0f) * _8069) * _8267) - _8042;
                                                                          _8277 = rsqrt(_8218 * dot(float3(_8257, _8258, _8074), float3(_8257, _8258, _8074)));
                                                                          _8279 = dot(float3(_8257, _8258, _8074), float3(_8213, _8215, _8074)) * _8277;
                                                                          _8286 = rsqrt(max(((((_8279 * 0.09300000220537186f) + 0.5f) * _8279) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8277;
                                                                          _8299 = rsqrt(dot(float3(_8273, _8274, _8074), float3(_8273, _8274, _8074)) * _8219);
                                                                          _8301 = dot(float3(_8216, _8217, _8074), float3(_8273, _8274, _8074)) * _8299;
                                                                          _8308 = rsqrt(max(((((_8301 * 0.09300000220537186f) + 0.5f) * _8301) + 0.40700000524520874f), 9.999999682655225e-21f)) * _8299;
                                                                          _8329 = ((((_8230 * (((_8207 - _8208) * _8195) * _8074)) + _8185) + (_8286 * ((_8258 - _8215) * _8074))) + (_8308 * ((_8217 - _8274) * _8074)));
                                                                          _8330 = ((((_8230 * ((_8052 * (_8208 - _8207)) * _8074)) + _8159) + (_8286 * ((_8209 - _8255) * _8074))) + (_8308 * ((_8268 - _8211) * _8074)));
                                                                          _8331 = ((((_8230 * ((_8217 * _8213) - (_8216 * _8215))) + _8186) + (_8286 * ((_8257 * _8215) - (_8258 * _8213)))) + (_8308 * ((_8274 * _8216) - (_8273 * _8217))));
                                                                        } else {
                                                                          _8329 = _8185;
                                                                          _8330 = _8159;
                                                                          _8331 = _8186;
                                                                        }
                                                                      }
                                                                      _8337 = sqrt(((_8330 * _8330) + (_8329 * _8329)) + (_8331 * _8331));
                                                                      _8338 = _8337 * 0.15915493667125702f;
                                                                      [branch]
                                                                      if (!(_8338 == 0.0f)) {
                                                                        _8347 = saturate((_8338 - _8023) / (1.0f - _8023)) * ((float)((bool)(uint)(_8046 <= 0.0f)));
                                                                        [branch]
                                                                        if (!(_8347 == 0.0f)) {
                                                                          do {
                                                                            _8355 = 0.0f;
                                                                            if (_8337 > 0.0f) {
                                                                              _8355 = (dot(float3(_8049, _8052, _8055), float3(_8329, _8330, _8331)) / _8337);
                                                                            }
                                                                            _8356 = 1.0f - _219;
                                                                            _8357 = _8356 * _8356;
                                                                            _8363 = exp2(log2(1.0f - saturate(dot(float3(_192, _193, _194), float3(_452, _453, _451)))) * 5.0f);
                                                                            _8368 = min(_219, 0.800000011920929f);
                                                                            _8377 = exp2(((((((_8368 * 3.322999954223633f) + -3.7669999599456787f) * _8368) + -0.3479999899864197f) * _8368) + 0.9919999837875366f) * 13.0f) * 0.25f;
                                                                            _8384 = _8074 / (_8067 - ((_8055 * 2.0f) * dot(float3((-0.0f - mad(_7991, _451, mad(_7990, _453, (_7989 * _452)))), (-0.0f - mad(_7997, _451, mad(_7996, _453, (_7995 * _452)))), _8067), float3(_8049, _8052, _8055))));
                                                                            _8387 = (_8384 * 2.0f) * rsqrt(((9.999999747378752e-05f - _8377) * saturate((_219 + -0.5f) * 2.500000238418579f)) + _8377);
                                                                            _8395 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8034), ((log2((_8387 * _8387) * f16tof32(((uint)((uint)(_8011) >> 16)))) * 0.5f) + 5.5f));
                                                                            _8397 = (float)((bool)(uint)(_8384 > 0.0f));
                                                                            _8398 = srvBillboardArray.SampleLevel(samplerLinearBorderBlackNode, float3(0.5f, 0.5f, _8034), 10.0f);
                                                                            _8407 = select(((cbSharedPerViewData.nLightingFeatureFlags & 2048) != 0), (_8347 * _1281), _8347);
                                                                            do {
                                                                              _8446 = _1598;
                                                                              _8447 = _1599;
                                                                              _8448 = _1600;
                                                                              if (_8032 > 0.0f) {
                                                                                _8425 = _8032 * _1354;
                                                                                _8426 = _8407 * _1658;
                                                                                _8446 = ((((((_8425 * _8025) * _8397) * _8395.x) * _8426) * (((max(_8357, _211) - _211) * _8363) + _211)) + _1598);
                                                                                _8447 = ((((((_8425 * _8026) * _8397) * _8395.y) * _8426) * (((max(_8357, _212) - _212) * _8363) + _212)) + _1599);
                                                                                _8448 = ((((((_8028 * _8425) * _8397) * _8395.z) * _8426) * (((max(_8357, _213) - _213) * _8363) + _213)) + _1600);
                                                                              }
                                                                              _8454 = ((_1658 * 5.4256415367126465f) * _8355) * _8407;
                                                                              _8462 = (((_8398.x * _8025) * _8454) + _1595);
                                                                              _8463 = (((_8398.y * _8026) * _8454) + _1596);
                                                                              _8464 = (((_8398.z * _8028) * _8454) + _1597);
                                                                              _8465 = _8446;
                                                                              _8466 = _8447;
                                                                              _8467 = _8448;
                                                                            } while (false);
                                                                            if (_loop_break_3) break;
                                                                          } while (false);
                                                                          if (_loop_break_3) break;
                                                                        } else {
                                                                          _8462 = _1595;
                                                                          _8463 = _1596;
                                                                          _8464 = _1597;
                                                                          _8465 = _1598;
                                                                          _8466 = _1599;
                                                                          _8467 = _1600;
                                                                        }
                                                                      } else {
                                                                        _8462 = _1595;
                                                                        _8463 = _1596;
                                                                        _8464 = _1597;
                                                                        _8465 = _1598;
                                                                        _8466 = _1599;
                                                                        _8467 = _1600;
                                                                      }
                                                                    } while (false);
                                                                    if (_loop_break_3) break;
                                                                  } while (false);
                                                                  if (_loop_break_3) break;
                                                                } while (false);
                                                                if (_loop_break_3) break;
                                                              } while (false);
                                                              if (_loop_break_3) break;
                                                            } while (false);
                                                            if (_loop_break_3) break;
                                                          } else {
                                                            _8462 = _1595;
                                                            _8463 = _1596;
                                                            _8464 = _1597;
                                                            _8465 = _1598;
                                                            _8466 = _1599;
                                                            _8467 = _1600;
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            } else {
                                              _8462 = _1595;
                                              _8463 = _1596;
                                              _8464 = _1597;
                                              _8465 = _1598;
                                              _8466 = _1599;
                                              _8467 = _1600;
                                            }
                                          }
                                          _8468 = _1601 + 1u;
                                          do {
                                            if (!(_8468 == _global_2)) {
                                              _1595 = _8462;
                                              _1596 = _8463;
                                              _1597 = _8464;
                                              _1598 = _8465;
                                              _1599 = _8466;
                                              _1600 = _8467;
                                              _1601 = _8468;
                                              _loop_break_3 = true;
                                              break;
                                            }
                                            _8472 = _8462;
                                            _8473 = _8463;
                                            _8474 = _8464;
                                            _8475 = _8465;
                                            _8476 = _8466;
                                            _8477 = _8467;
                                          } while (false);
                                          if (_loop_break_3) break;
                                        } while (false);
                                        if (_loop_break_3) {
                                          _loop_break_3 = false;
                                          continue;
                                        }
                                        break;
                                      }
                                    }
                                    _8479 = rsqrt(dot(float3(_135, _136, -1.0f), float3(_135, _136, -1.0f)));
                                    _8486 = 1.0f - _219;
                                    _8497 = (1.0f - _227) - (exp2(log2(1.0f - saturate(saturate(dot(float3(_192, _193, _194), float3((-0.0f - (_135 * _8479)), (-0.0f - (_136 * _8479)), _8479))))) * 5.0f) * (max((_8486 * _8486), _227) - _227));
                                    _8637 = (_8497 * _8472);
                                    _8638 = (_8497 * _8473);
                                    _8639 = (_8497 * _8474);
                                    _8640 = _8475;
                                    _8641 = _8476;
                                    _8642 = _8477;
                                    _8643 = (_444 * _159);
                                    _8644 = (_444 * _160);
                                    _8645 = (_444 * _161);
                                  } while (false);
                                } while (false);
                              } while (false);
                            } while (false);
                          } while (false);
                        } while (false);
                      } while (false);
                    } while (false);
                  } while (false);
                } while (false);
              } while (false);
            } while (false);
          } while (false);
        } while (false);
      } else {
        _8516 = mad((cbSharedPerViewData.mViewToWorld[0][0].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][0].y), _136, ((cbSharedPerViewData.mViewToWorld[0][0].x) * _135)));
        _8519 = mad((cbSharedPerViewData.mViewToWorld[0][1].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][1].y), _136, ((cbSharedPerViewData.mViewToWorld[0][1].x) * _135)));
        _8522 = mad((cbSharedPerViewData.mViewToWorld[0][2].z), -1.0f, mad((cbSharedPerViewData.mViewToWorld[0][2].y), _136, ((cbSharedPerViewData.mViewToWorld[0][2].x) * _135)));
        do {
          [branch]
          if (!(cbSharedPerViewData.nEnableAtmosphericScatteringBackdrop == 0)) {
            _8543 = srvDeferredShadingPass_BackdropCube.SampleLevel(samplerLinearClampNode, float3(_8516, _8519, _8522), 0.0f);
            _8547 = _8543.x * 32.0f;
            _8548 = _8543.y * 32.0f;
            _8549 = _8543.z * 32.0f;
            _8551 = rsqrt(dot(float3(_8516, _8519, _8522), float3(_8516, _8519, _8522)));
            _8552 = _8551 * _8516;
            _8553 = _8551 * _8519;
            _8554 = _8551 * _8522;
            _8555 = cbDeferredShading.fSunDiscRadiusScale * 0.6958000063896179f;
            _8556 = cbDeferredShading.vSunDirWS.x * 149.60000610351562f;
            _8557 = cbDeferredShading.vSunDirWS.y * 149.60000610351562f;
            _8558 = cbDeferredShading.vSunDirWS.z * 149.60000610351562f;
            _8559 = dot(float3(_8552, _8553, _8554), float3(_8556, _8557, _8558));
            _8564 = (_8559 * _8559) - (dot(float3(_8556, _8557, _8558), float3(_8556, _8557, _8558)) - (_8555 * _8555));
            if ((_8559 > -0.0f) && (_8564 > 0.0f)) {
              _8569 = -0.0f - cbDeferredShading.vSunDirWS.z;
              _8582 = 74.80000305175781f / ((dot(float3(_8552, _8553, _8554), float3(cbDeferredShading.vSunDirWS.x, cbDeferredShading.vSunDirWS.y, cbDeferredShading.vSunDirWS.z)) * _8555) * sqrt(1.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.y)));
              _8590 = srvDeferredShadingPass_SunDisc.SampleLevel(samplerLinearClampNode, float2(((dot(float2(_8552, _8554), float2(_8569, cbDeferredShading.vSunDirWS.x)) * _8582) + 0.5f), ((dot(float3(_8552, _8553, _8554), float3((-0.0f - (cbDeferredShading.vSunDirWS.y * cbDeferredShading.vSunDirWS.x)), ((cbDeferredShading.vSunDirWS.x * cbDeferredShading.vSunDirWS.x) - (cbDeferredShading.vSunDirWS.z * _8569)), (cbDeferredShading.vSunDirWS.y * _8569))) * _8582) + 0.5f)), 0.0f);
              _8592 = _8564 / (cbDeferredShading.fSunDiscRadiusScale * 1.3916000127792358f);
              if (_8592 > 0.0f) {
                _8599 = saturate(_8592 * 5.0f);
                _8626 = (((((cbSharedPerViewData.vAttenuatedSunColor.x * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.x) * _8590.x) * _8599) + _8547);
                _8627 = (((((cbSharedPerViewData.vAttenuatedSunColor.y * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.y) * _8590.y) * _8599) + _8548);
                _8628 = (((((cbSharedPerViewData.vAttenuatedSunColor.z * cbDeferredShading.fSunDiscIntensityScale) * cbDeferredShading.vSunDiscTint.z) * _8590.z) * _8599) + _8549);
              } else {
                _8626 = _8547;
                _8627 = _8548;
                _8628 = _8549;
              }
            } else {
              _8626 = _8547;
              _8627 = _8548;
              _8628 = _8549;
            }
          } else {
            _8626 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.x);
            _8627 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.y);
            _8628 = (cbSharedPerViewData.vHDRScale.x * cbSharedPerViewData.vClearColor.z);
          }
          _8632 = ((cbSharedPerViewData.nLightingFeatureFlags & 256) != 0);
          _8637 = 0.0f;
          _8638 = 0.0f;
          _8639 = 0.0f;
          _8640 = select(_8632, 0.0f, _8626);
          _8641 = select(_8632, 0.0f, _8627);
          _8642 = select(_8632, 0.0f, _8628);
          _8643 = 0.0f;
          _8644 = 0.0f;
          _8645 = 0.0f;
        } while (false);
      }
      uavDeferredShadingPass_Specular[int2(_64, _65)] = float3(max(min((cbSharedPerViewData.vHDRScale.y * ((_8643 * _8637) + _8640)), 7936.0f), 5.960464477539063e-08f), max(min((cbSharedPerViewData.vHDRScale.y * ((_8644 * _8638) + _8641)), 7936.0f), 5.960464477539063e-08f), max(min((((_8645 * _8639) + _8642) * cbSharedPerViewData.vHDRScale.y), 7936.0f), 5.960464477539063e-08f));
      uavDeferredShadingPass_Diffuse[int2(_64, _65)] = float3(0.0f, 0.0f, 0.0f);
    } while (false);
  }
}
